import sys
from pathlib import Path

# Добавляем корень проекта в sys.path, чтобы pytest видел main.py
sys.path.insert(0, str(Path(__file__).parent))
