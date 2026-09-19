#!/usr/bin/env python3
"""Create a source + compiled-example distribution without personal or build files."""
from pathlib import Path
import argparse
import hashlib
import re
import zipfile

ROOT = Path(__file__).resolve().parents[1]
VERSION = '0.1.0'
FILES = [
    'LICENSE', 'README.md', 'UPSTREAM.md', 'CHANGELOG.md', '.gitignore',
    'cuebthesis.cls', 'cueb-bibliography.bbx', 'cueb-footnote.cbx',
    'cuebsetup.tex', 'main.tex', 'latexmkrc', 'Makefile',
]
DIRECTORIES = ['config', 'assets', 'figures', 'data', 'ref', 'examples', 'docs', 'testfiles', 'utils', '.github']
ALLOWED_SUFFIXES = {'.def', '.png', '.md', '.tex', '.bib', '.py', '.yml', '.pdf', '.jpg', '.jpeg', '.eps', '.mps'}
PDFS = {'build/main.pdf': 'cuebthesis-example.pdf',
        'build/minimal/minimal.pdf': 'cuebthesis-minimal.pdf'}


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--version', default=VERSION)
    args = parser.parse_args()
    if not re.fullmatch(r'\d+\.\d+\.\d+(?:-[A-Za-z0-9.]+)?', args.version):
        parser.error('Version must be a semantic version without a path')
    files = [ROOT / name for name in FILES]
    for directory in DIRECTORIES:
        files.extend(p for p in sorted((ROOT / directory).rglob('*'))
                     if p.is_file() and p.suffix.lower() in ALLOWED_SUFFIXES and '__pycache__' not in p.parts)
    for path in [*files, *(ROOT / p for p in PDFS)]:
        if not path.is_file():
            raise SystemExit(f'Missing release input: {path.relative_to(ROOT)}. Run make all first.')
    out = ROOT / 'dist'
    out.mkdir(exist_ok=True)
    name = f'cueb-undergraduate-thesis-v{args.version}'
    archive = out / (name + '.zip')
    manifest = []
    with zipfile.ZipFile(archive, 'w', compression=zipfile.ZIP_DEFLATED) as z:
        for path in files:
            relative = path.relative_to(ROOT).as_posix()
            z.write(path, name + '/' + relative)
            manifest.append(relative)
        for source, target in PDFS.items():
            z.write(ROOT / source, name + '/' + target)
            manifest.append(target)
        z.writestr(name + '/MANIFEST.txt', '\n'.join(sorted(manifest)) + '\n')
    digest = hashlib.sha256(archive.read_bytes()).hexdigest()
    archive.with_suffix('.zip.sha256').write_text(f'{digest}  {archive.name}\n', encoding='utf-8')
    print(f'Created {archive.relative_to(ROOT)} ({len(manifest)} files)')


if __name__ == '__main__':
    main()
