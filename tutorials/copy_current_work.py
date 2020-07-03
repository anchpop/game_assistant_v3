from pathlib import Path
import shutil 
from functools import reduce
import os

current_work_path = Path('./current_work')
projects_path = Path("./projects")

create_path_from_strings = lambda strs: reduce(lambda acc, x: acc / x, strs, Path('./')) 

def main():
    chapter = input("What chapter have you just finished? ").replace(" ", "_")

    dirs_in_current_work = list(current_work_path.glob("*/"))
    if len(dirs_in_current_work) > 1:
        print("Found multiple directories inside ./current_work! Aborting")
    elif len(dirs_in_current_work) == 0:
        print("No work found in ./current_work! Aborting")
    else:
        copy_files(dirs_in_current_work[0], chapter)

def copy_files(dir, chapter):
    project = dir.parts[-1]
    scripts = (dir / "assets").glob("**/*.cs")
    destination = projects_path / project / chapter 
    
    for script in scripts:
        copy_to = destination / create_path_from_strings(script.parts[3:])
        dir_to_create = create_path_from_strings(copy_to.parts[:-1])
        os.makedirs(dir_to_create, exist_ok=True)


        shutil.copy2(script, copy_to)
    
    print("Copied!")


if __name__ == "__main__":
    main()
