"""Poppler output is UTF-8 even when Windows uses an ANSI locale."""
import importlib.util
from pathlib import Path
import sys
import unittest
from unittest.mock import patch

spec = importlib.util.spec_from_file_location('checks', Path(__file__).resolve().parents[1] / 'utils/check.py')
checks = importlib.util.module_from_spec(spec)
spec.loader.exec_module(checks)

class EncodingTest(unittest.TestCase):
    def test_utf8_output_under_ansi_locale(self):
        with patch('locale.getencoding', return_value='cp1252'):
            result = checks.run([sys.executable, '-c',
                "import sys; sys.stdout.buffer.write('人工智能学院'.encode('utf-8'))"])
        self.assertEqual(result.stdout, '人工智能学院')

if __name__ == '__main__':
    unittest.main()
