import json
from pathlib import Path
import string
import re
import sys,os

sys.path.append(os.path.realpath('..'))

base_path = Path('./projects')
output_path = Path('../backend/game_assistant/lib/game_assistant/tutorializing/book_contents.ex')

def convertToElixirJsonString(o):
    s = ""
    for page in o:
        pass
    return '{' + s + '}'

def main():
    print("Collecting project scripts...")
    result = {'projects': {}}
    all_projects = [x for x in base_path.iterdir() if x.is_dir()]
    for project in all_projects:
        project_name = project.parts[-1].replace("_", " ")
        result['projects'][project_name] = {}
        all_chapters = project.iterdir()
        for chapter in all_chapters:
            chapter_name = chapter.parts[-1].replace("_", " ")
            print(f"chapter: {chapter_name}")
            result['projects'][project_name][chapter_name] = {}

            scripts = chapter.glob("**/*.cs")
            for script_path in scripts:
                adjusted_path = "/".join(script_path.parts[len(chapter.parts):])
                with open(script_path, "r", encoding='utf-8') as f:
                    script_contents_raw = f.read()
                    printable = set(string.printable)
                    script_contents = ''.join(filter(lambda x: x in printable, script_contents_raw))

                result['projects'][project_name][chapter_name][adjusted_path] = script_contents

    print("Scripts collected.")

    print("new structure:")


    print(f"Copying into '{output_path}' ...")




    formatted_info_unfixed = repr(json.dumps(result))[1:-1]
    formatted_info = ""
    for i in formatted_info_unfixed:
        formatted_info += '\\"' if i == '"' else ('\\\\' if i == '\\' else i)

    with open(output_path, "r", encoding='utf-8') as f:
        file_original = f.read()
        file_rewritten = re.sub(r"# PYSTART.*?# PYEND", f"# PYSTART\n   \"{formatted_info}\"\n# PYEND", file_original, flags=re.DOTALL)
        print(f"file_original length: {len(file_original)}, file_rewritten length: {len(file_rewritten)}")

    with open(output_path, "w", encoding='utf-8') as f:
        f.write(file_rewritten)

    print("Written!")



if __name__ == "__main__":
    main()
