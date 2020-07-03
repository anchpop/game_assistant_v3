import json
from pathlib import Path
import string
import re

base_path = Path('../projects')
output_path = Path('../../lib/phoenix_react_playground/tutorializing/book_contents.ex')

def convertToElixirJsonString(o):
    s = ""
    for page in o:
        pass
    return '{' + s + '}'

def main():
    print("Collecting project scripts...")
    result = {'pages': {}}
    all_chapters = [x for x in base_path.iterdir() if x.is_dir()]
    for chapter in all_chapters:
        all_pages = [(x, int(x.parts[-1])) for x in chapter.iterdir() if x.is_dir()]
        for (page_path, page_number) in all_pages:
            result['pages'][str(page_number)] = {}
            scripts = page_path.glob("**/*.cs")
            for script_path in scripts:
                adjusted_path = "/".join(script_path.parts[len(page_path.parts):])
                with open(script_path, "r", encoding='utf-8') as f:
                    script_contents_raw = f.read()
                    printable = set(string.printable)
                    script_contents = ''.join(filter(lambda x: x in printable, script_contents_raw))

                result['pages'][str(page_number)][adjusted_path] = script_contents

    print("Scripts collected.")
    print(f"Copying into '{output_path}' ...")

    if False:
        result = {
            "pages": {
                "100": {
                    "scripts/file1": "line1;\\nline2;\\nline3;\\nline4;",
                    "scripts/file2": "brine1;\\nbrine2;\\nbrine3;\\nbrine4;"
                },
                "101": {
                    "scripts/smile1": "cline1;\\nline2;\\nline3;\\nline4;",
                    "scripts/smile3": "cbrine1;\\nbrine2;\\nbrine3;\\nbrine4;"
                }
            }
        }


    formatted_info_unfixed = repr(json.dumps(result))[1:-1]
    formatted_info = ""
    for i in formatted_info_unfixed:
        formatted_info += '\\"' if i == '"' else ('\\\\' if i == '\\' else i)

    with open(output_path, "r", encoding='utf-8') as f:
        file_original = f.read()
        file_rewritten = re.sub(r"# PYSTART.*?# PYEND", f"# PYSTART\n   \"{formatted_info}\"\n# PYEND", file_original, flags=re.DOTALL)
        print(f"file_original: {len(file_original)}, file_rewritten: {len(file_rewritten)}")

    with open(output_path, "w", encoding='utf-8') as f:
        f.write(file_rewritten)

    print("Written!")



if __name__ == "__main__":
    main()
