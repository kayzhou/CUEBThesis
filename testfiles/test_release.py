"""Regression for configured cover and figure assets surviving release packaging."""
import contextlib
import importlib.util
import io
from pathlib import Path
import tempfile
import unittest
from unittest.mock import patch
import zipfile

MODULE = Path(__file__).resolve().parents[1] / 'utils/create_release.py'
spec = importlib.util.spec_from_file_location('release', MODULE)
release = importlib.util.module_from_spec(spec)
spec.loader.exec_module(release)


class ReleaseAssetsTest(unittest.TestCase):
    def test_configured_cover_and_figures_are_in_archive(self):
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for name in release.FILES:
                (root / name).parent.mkdir(parents=True, exist_ok=True)
                (root / name).write_text('packaging fixture', encoding='utf-8')
            (root/'cuebsetup.tex').write_text(r'\cuebsetup{cover-file={assets/approved-cover.pdf}}', encoding='utf-8')
            for name in [*release.PDFS, 'assets/approved-cover.pdf', 'figures/chart.pdf',
                         'figures/photo.JPEG', 'assets/private-handbook.docx']:
                path = root / name
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(b'asset fixture')
            with patch.object(release, 'ROOT', root), patch('sys.argv', ['create_release.py']), contextlib.redirect_stdout(io.StringIO()):
                release.main()
            archive = next((root/'dist').glob('*.zip'))
            with zipfile.ZipFile(archive) as z:
                names = {n.split('/', 1)[1] for n in z.namelist()}
                for expected in ['assets/approved-cover.pdf', 'figures/chart.pdf', 'figures/photo.JPEG']:
                    self.assertIn(expected, names)
                self.assertNotIn('assets/private-handbook.docx', names)
                self.assertEqual(z.read(archive.stem+'/figures/photo.JPEG'), b'asset fixture')


if __name__ == '__main__':
    unittest.main()
