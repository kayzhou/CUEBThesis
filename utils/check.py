#!/usr/bin/env python3
"""Compile real fixtures and verify CUEB output behavior (Python standard library)."""
from pathlib import Path
import argparse
import re
import shutil
import subprocess
import sys
import xml.etree.ElementTree as ET

ROOT = Path(__file__).resolve().parents[1]
BUILD = ROOT / 'build' / 'checks'


def run(args, expected_success=True):
    result = subprocess.run(args, cwd=ROOT, text=True, stdout=subprocess.PIPE,
                            stderr=subprocess.STDOUT)
    if expected_success and result.returncode:
        raise AssertionError(f"Command failed: {' '.join(map(str, args))}\n{result.stdout[-6000:]}")
    return result


def assert_clean(log):
    bad = re.findall(r'(?:Overfull \\[hv]box|Missing character:|LaTeX Error:|Undefined control sequence|Citation .+ undefined|Reference .+ undefined|There were undefined references|Package fancyhdr Warning:).*', log)
    if bad:
        raise AssertionError('\n'.join(bad))


def compile_case(name, source):
    folder = BUILD / name
    folder.mkdir(parents=True, exist_ok=True)
    tex = folder / f'{name}.tex'
    tex.write_text(source, encoding='utf-8')
    result = run(['latexmk', '-outdir=' + folder.relative_to(ROOT).as_posix(), tex.relative_to(ROOT).as_posix()])
    (folder / 'build-output.txt').write_text(result.stdout, encoding='utf-8')
    log = (folder / f'{name}.log').read_text(encoding='utf-8')
    assert_clean(log)
    return folder, log


def labels(folder, name):
    aux = (folder / f'{name}.aux').read_text(encoding='utf-8')
    return dict(re.findall(r'\\newlabel\{([^}]+)\}\{\{([^}]+)\}', aux))


def pdf_text(path):
    return run(['pdftotext', '-layout', str(path), '-']).stdout


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--pdf', type=Path, help='Only validate an already built PDF and its log')
    args = parser.parse_args()
    for tool in (['pdftotext'] if args.pdf else ['latexmk', 'xelatex', 'biber', 'pdftotext']):
        if not shutil.which(tool):
            parser.error(f'Required command is not on PATH: {tool}')
    if args.pdf:
        path = args.pdf.resolve()
        assert path.exists(), f'PDF missing: {path}'
        assert_clean(path.with_suffix('.log').read_text(encoding='utf-8'))
        assert len(pdf_text(path).strip()) > 30, 'PDF text is missing'
        print(f'PASS PDF and compilation log: {path.name}')
        return

    base = (ROOT / 'testfiles/acceptance.tex').read_text(encoding='utf-8')
    folder, log = compile_case('continuous', base)
    values = labels(folder, 'continuous')
    assert [values[k] for k in ['eq:first', 'eq:second', 'fig:first', 'fig:second']] == ['1', '2', '1', '2'], values
    baseline = float(re.search(r'CUEB-BASELINE=([0-9.]+)pt', log).group(1))
    assert abs(baseline - 18 * 72.27 / 72) < 0.01, baseline
    assert values['eq:appendix'] == '3', values
    assert 'CUEB-FOOTNOTES=8' in log, 'Footnotes must continue across sections and share the ordinary note counter'
    entries = re.findall(r'\\entry\{([^}]+)\}', (folder/'continuous.bbl').read_text(encoding='utf-8'))
    assert entries == ['li', 'wang', 'zhou', 'bishop', 'web'], entries
    bbox = ET.fromstring(run(['pdftotext', '-bbox', str(folder/'continuous.pdf'), '-']).stdout)
    words = list(bbox.iter('{http://www.w3.org/1999/xhtml}word'))
    first_para = next(w for w in words if (w.text or '').startswith('首次引用中文文献'))
    assert abs(float(first_para.attrib['xMin']) - (3.8 * 72 / 2.54 + 24)) < 0.2, first_para.attrib
    text = pdf_text(folder/'continuous.pdf')
    pages = text.split('\f')
    assert '[1] 周志华' in pages[0] and '[2] BISHOP' in pages[0], 'First citations must occur on first page'
    compact = re.sub(r'\s+', '', pages[1])
    assert '[3]周志华' in compact and '[4]这是第四条脚注' in compact
    assert 'https://www.latex-project.org/' in compact and '2026-01-01' in compact
    assert '2006(2):5–10' in compact or '2006(2):5-10' in compact, 'Journal issue/pages lost'
    assert '[8]周志华' in compact and compact.rfind('BISHOP') > compact.index('[8]周志华'), 'Multiple citation keys lost'
    assert '23–25' in pages[0] or '23-25' in pages[0], 'Citation locator lost'
    print('PASS continuous figures/equations, repeated footnotes, on-page notes, bibliography sorting and online date')

    variant = base.replace(r'\begin{document}', r'\cuebsetup{numbering=section}' + '\n' + r'\begin{document}')
    folder, _ = compile_case('section', variant)
    values = labels(folder, 'section')
    assert [values[k] for k in ['eq:first', 'eq:second', 'fig:first', 'fig:second']] == ['1.1','2.1','1.1','2.1'], values
    assert values['eq:appendix'] == '附1.1', values
    print('PASS optional section numbering and distinct appendix labels')

    profile = ROOT / 'config/colleges/cueb-test-fixture.def'
    assert not profile.exists(), f'Refusing to overwrite {profile}'
    profile.write_text(r'\cuebprofilesetup{numbering=section}' + '\n', encoding='utf-8')
    try:
        variant = base.replace(r'\begin{document}', r'\cuebsetup{college-profile=cueb-test-fixture}'+'\n'+r'\begin{document}')
        folder, _ = compile_case('college', variant)
        assert labels(folder, 'college')['eq:second'] == '2.1'
        variant = variant.replace(r'\begin{document}', r'\cuebsetup{numbering=continuous}'+'\n'+r'\begin{document}')
        folder, _ = compile_case('override', variant)
        assert labels(folder, 'override')['eq:second'] == '2'
    finally:
        profile.unlink()
    print('PASS college defaults and explicit user override precedence')

    invalid_cases = {
        'missing-author': (base.replace('author={测试作者}', 'author={}'), 'Required metadata'),
        'unknown-college': (base.replace(r'\begin{document}', r'\cuebsetup{college-profile=nonexistent}'+'\n'+r'\begin{document}'), 'Unknown or invalid profile'),
        'path-traversal': (base.replace(r'\begin{document}', r'\cuebsetup{college-profile=../general}'+'\n'+r'\begin{document}'), 'Unknown or invalid profile'),
        'bad-numbering': (base.replace(r'\begin{document}', r'\cuebsetup{numbering=nonsense}'+'\n'+r'\begin{document}'), 'accepts only a fixed set of choices'),
    }
    for name, (source, expected) in invalid_cases.items():
        folder = BUILD / name
        folder.mkdir(parents=True, exist_ok=True)
        tex = folder / (name + '.tex')
        tex.write_text(source, encoding='utf-8')
        result = run(['xelatex', '-halt-on-error', '-interaction=nonstopmode', '-output-directory='+folder.relative_to(ROOT).as_posix(), tex.relative_to(ROOT).as_posix()], expected_success=False)
        assert result.returncode != 0, f'{name} unexpectedly compiled'
        assert expected in result.stdout, f'{name}: wrong failure\n{result.stdout[-2000:]}'
    print('PASS required metadata, unknown profiles, invalid values and profile path validation')
    folder = BUILD / 'submission'
    folder.mkdir(parents=True, exist_ok=True)
    tex = folder / 'submission.tex'
    tex.write_text(base.replace('font-profile=preview', 'font-profile=submission'), encoding='utf-8')
    result = run(['xelatex', '-halt-on-error', '-interaction=nonstopmode', '-output-directory='+folder.relative_to(ROOT).as_posix(), tex.relative_to(ROOT).as_posix()], expected_success=False)
    if result.returncode:
        assert 'Submission font' in result.stdout and 'is not installed' in result.stdout, result.stdout[-2500:]
        print('PASS submission mode rejects missing required fonts (no silent substitution)')
    else:
        print('PASS submission mode with installed required fonts')
    print('All acceptance checks passed.')


if __name__ == '__main__':
    try:
        main()
    except (AssertionError, OSError) as exc:
        print(f'FAIL: {exc}', file=sys.stderr)
        sys.exit(1)
