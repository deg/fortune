"""Tests for the fortune CLI application."""

import unittest
from unittest.mock import patch, mock_open, MagicMock
import sys
import os
import tempfile
from pathlib import Path
import random

# Add the parent directory to sys.path so we can import fortune
sys.path.insert(0, str(Path(__file__).parent.parent))

from fortune.main import get_fortunes, main


class TestGetFortunes(unittest.TestCase):
    """Test the get_fortunes function."""

    def setUp(self):
        """Set up test fixtures."""
        self.test_dir = Path(__file__).parent
        self.original_cwd = os.getcwd()

    def tearDown(self):
        """Clean up test fixtures."""
        os.chdir(self.original_cwd)

    def test_get_fortunes_no_data_directory(self):
        """Test get_fortunes when data directory doesn't exist."""
        with patch('fortune.main.Path') as mock_path:
            # Mock the parent directory to not exist
            mock_path_instance = MagicMock()
            mock_path_instance.parent = MagicMock()
            mock_path_instance.parent.__truediv__ = MagicMock(return_value=MagicMock())
            mock_path_instance.parent.__truediv__.return_value.exists.return_value = False
            mock_path.return_value = mock_path_instance

            result = get_fortunes()
            self.assertEqual(result, ["No fortunes found. Please ensure the 'data' directory exists in the package."])

    def test_get_fortunes_empty_data_directory(self):
        """Test get_fortunes when data directory exists but is empty."""
        with tempfile.TemporaryDirectory() as temp_dir:
            data_dir = Path(temp_dir) / "data"
            data_dir.mkdir()

            with patch('fortune.main.Path') as mock_path:
                mock_path_instance = MagicMock()
                mock_path_instance.parent = MagicMock()
                mock_path_instance.parent.__truediv__ = MagicMock(return_value=data_dir)
                mock_path.return_value = mock_path_instance

                result = get_fortunes()
                self.assertEqual(result, ["The fortune database is empty."])

    def test_get_fortunes_with_valid_fortune_files(self):
        """Test get_fortunes with valid BSD fortune format files."""
        with tempfile.TemporaryDirectory() as temp_dir:
            data_dir = Path(temp_dir) / "data"
            data_dir.mkdir()

            # Create test fortune file
            fortune_file = data_dir / "test_fortunes"
            fortune_content = """First fortune text
%
Second fortune
with multiple lines
%
Third fortune%
%
"""

            fortune_file.write_text(fortune_content)

            with patch('fortune.main.Path') as mock_path:
                mock_path_instance = MagicMock()
                mock_path_instance.parent = MagicMock()
                mock_path_instance.parent.__truediv__ = MagicMock(return_value=data_dir)
                mock_path.return_value = mock_path_instance

                result = get_fortunes()
                expected = [
                    "First fortune text",
                    "Second fortune\nwith multiple lines",
                    "Third fortune%"
                ]
                self.assertEqual(result, expected)

    def test_get_fortunes_with_mixed_content(self):
        """Test get_fortunes with various fortune formats."""
        with tempfile.TemporaryDirectory() as temp_dir:
            data_dir = Path(temp_dir) / "data"
            data_dir.mkdir()

            # Create test fortune file with various formats
            fortune_file = data_dir / "test_fortunes"
            fortune_content = """Simple fortune
%
Fortune with
multiple lines
%
%
Empty fortune above
%
Trailing percent%
"""

            fortune_file.write_text(fortune_content)

            with patch('fortune.main.Path') as mock_path:
                mock_path_instance = MagicMock()
                mock_path_instance.parent = MagicMock()
                mock_path_instance.parent.__truediv__ = MagicMock(return_value=data_dir)
                mock_path.return_value = mock_path_instance

                result = get_fortunes()
                # Should filter out empty fortunes and standalone %
                expected = [
                    "Simple fortune",
                    "Fortune with\nmultiple lines",
                    "%\nEmpty fortune above",
                    "Trailing percent%"
                ]
                self.assertEqual(result, expected)

    def test_get_fortunes_skips_hidden_files(self):
        """Test get_fortunes skips files starting with dot."""
        with tempfile.TemporaryDirectory() as temp_dir:
            data_dir = Path(temp_dir) / "data"
            data_dir.mkdir()

            # Create regular and hidden files
            (data_dir / "fortunes").write_text("Regular fortune\n%\n")
            (data_dir / ".hidden").write_text("Hidden fortune\n%\n")

            with patch('fortune.main.Path') as mock_path:
                mock_path_instance = MagicMock()
                mock_path_instance.parent = MagicMock()
                mock_path_instance.parent.__truediv__ = MagicMock(return_value=data_dir)
                mock_path.return_value = mock_path_instance

                result = get_fortunes()
                self.assertEqual(result, ["Regular fortune"])

    def test_get_fortunes_handles_file_read_errors(self):
        """Test get_fortunes handles file reading errors gracefully."""
        with tempfile.TemporaryDirectory() as temp_dir:
            data_dir = Path(temp_dir) / "data"
            data_dir.mkdir()

            # Create a file that will cause a read error
            fortune_file = data_dir / "bad_file"
            fortune_file.write_text("Good fortune\n%\n")

            with patch('fortune.main.Path') as mock_path:
                mock_path_instance = MagicMock()
                mock_path_instance.parent = MagicMock()
                mock_path_instance.parent.__truediv__ = MagicMock(return_value=data_dir)
                mock_path.return_value = mock_path_instance

                # Mock open to raise an exception
                with patch('builtins.open', side_effect=OSError("Permission denied")):
                    result = get_fortunes()
                    # Should still work with other files, but since we mocked all opens, it should be empty
                    self.assertEqual(result, ["The fortune database is empty."])

    def test_get_fortunes_multiple_files(self):
        """Test get_fortunes combines fortunes from multiple files."""
        with tempfile.TemporaryDirectory() as temp_dir:
            data_dir = Path(temp_dir) / "data"
            data_dir.mkdir()

            # Create multiple fortune files
            (data_dir / "fortunes1").write_text("Fortune 1\n%\nFortune 2\n%\n")
            (data_dir / "fortunes2").write_text("Fortune 3\n%\n")

            with patch('fortune.main.Path') as mock_path:
                mock_path_instance = MagicMock()
                mock_path_instance.parent = MagicMock()
                mock_path_instance.parent.__truediv__ = MagicMock(return_value=data_dir)
                mock_path.return_value = mock_path_instance

                result = get_fortunes()
                expected = ["Fortune 1", "Fortune 2", "Fortune 3"]
                self.assertEqual(result, expected)


class TestMainFunction(unittest.TestCase):
    """Test the main function."""

    def setUp(self):
        """Set up test fixtures."""
        self.test_dir = Path(__file__).parent

    def test_main_help_flag(self):
        """Test main function with help flag."""
        with patch('sys.argv', ['fortune', '--help']), \
             patch('fortune.main.Console') as mock_console:

            main()
            mock_console.return_value.print.assert_called()

    def test_main_short_help_flag(self):
        """Test main function with short help flag."""
        with patch('sys.argv', ['fortune', '-h']), \
             patch('fortune.main.Console') as mock_console:

            main()
            mock_console.return_value.print.assert_called()

    @patch('fortune.main.get_fortunes')
    @patch('fortune.main.random.choice')
    def test_main_normal_execution(self, mock_choice, mock_get_fortunes):
        """Test main function normal execution."""
        mock_get_fortunes.return_value = ["Test fortune"]
        mock_choice.return_value = "Test fortune"

        with patch('fortune.main.Console') as mock_console:
            main()

            # Verify get_fortunes was called
            mock_get_fortunes.assert_called_once()

            # Verify random.choice was called with fortunes
            mock_choice.assert_called_once_with(["Test fortune"])

            # Verify console.print was called (with the panel)
            mock_console.return_value.print.assert_called_once()

    @patch('fortune.main.get_fortunes')
    def test_main_empty_fortunes(self, mock_get_fortunes):
        """Test main function when no fortunes are available."""
        mock_get_fortunes.return_value = ["No fortunes found. Please ensure the 'data' directory exists in the package."]

        with patch('fortune.main.random.choice') as mock_choice, \
             patch('fortune.main.Console') as mock_console:

            mock_choice.return_value = "No fortunes found. Please ensure the 'data' directory exists in the package."

            main()

            # Should still display the message
            mock_console.return_value.print.assert_called_once()


if __name__ == '__main__':
    unittest.main()