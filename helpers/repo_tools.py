import git
import os
from pathlib import Path

# --- Configuration ---
REPO_DIR = Path("./cloned_repos")
REPO_DIR.mkdir(exist_ok=True, parents=True) # Ensure 'cloned_repos' exists in the project root

# --- 1. Clone/Pull Repository ---

def clone_repo(repo_url: str) -> str:
    """Clones a GitHub repository or pulls the latest if it exists."""
    
    # 1. Determine the local path
    repo_name = repo_url.split('/')[-1].replace('.git', '')
    local_path = REPO_DIR / repo_name
    local_path_str = str(local_path)
    
    # 2. Check if the directory already exists (Pull)
    if os.path.exists(local_path_str) and os.path.isdir(local_path_str):
        # ... logic for pulling updates ...
        try:
            repo = git.Repo(local_path_str)
            repo.remotes.origin.pull()
            return local_path_str
        except Exception:
            # Handle potential errors if the directory isn't a valid Git repo
            return None
    
    # 3. Clone the repository
    try:
        git.Repo.clone_from(repo_url, local_path_str)
        return local_path_str
    except Exception:
        return None

# --- 2. Generate File Tree ---

def get_file_tree(startpath: str) -> str:
    """
    Generates a text file tree for the repository, ignoring common irrelevant directories 
    like .git[cite: 43].
    """
    output = []
    # Directories to ignore, as specified in the assignment [cite: 43]
    IGNORE = {'.git', 'venv', '__pycache__', 'node_modules', 'cloned_repos'} 
    
    path_root = Path(startpath)
    output.append(f"{path_root.name}/")
    
    # Simple, 2-level deep traversal for initial mapping [cite: 42]
    for item in path_root.iterdir():
        if item.name in IGNORE or item.name.startswith('.'):
            continue
            
        if item.is_dir():
            output.append(f"├── {item.name}/")
            
            # List contents of the subdirectory
            for sub_item in item.iterdir():
                if sub_item.name in IGNORE or sub_item.name.startswith('.'):
                    continue
                
                # Check for file or directory to use the correct prefix
                prefix = "│   ├── " if sub_item.is_file() else "│   └── "
                output.append(f"{prefix}{sub_item.name}")
        else:
            output.append(f"├── {item.name}")

    return "\n".join(output)

# --- 3. Read README.md Content (Helper for Jac) ---

def read_readme(local_path: str) -> str:
    """Reads README.md or readme.md content."""
    
    readme_path_md = Path(local_path) / "README.md"
    readme_path_txt = Path(local_path) / "readme.txt"
    readme_path_other = Path(local_path) / "readme.md"

    if readme_path_md.exists():
        return readme_path_md.read_text(encoding='utf-8', errors='ignore')
    if readme_path_other.exists():
        return readme_path_other.read_text(encoding='utf-8', errors='ignore')
    if readme_path_txt.exists():
        return readme_path_txt.read_text(encoding='utf-8', errors='ignore')
    
    return ""