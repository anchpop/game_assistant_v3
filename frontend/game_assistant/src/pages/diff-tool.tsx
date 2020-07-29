import * as React from 'react';
import { useState, useEffect } from 'react';
import TextareaAutosize from 'react-textarea-autosize';
import ReactDiffViewer from 'react-diff-viewer';
import Konami from 'react-konami-code';
import useDarkMode from 'use-dark-mode';

import Layout from '../components/layout';


const api_url = "https://game-assistant.gigalixirapp.com"


interface CodeAPI {
  code: string;
}

interface FilesListingAPI {
  files: string[];
}

interface ProjectsListingAPI {
  projects: string[];
}

interface ChaptersListingAPI {
  chapters: string[];
}

const removeComments = (s) => s.replace(/\/\*[\s\S]*?\*\/|\/\/.*/g, '');
const removeEmptyLines = (s) => s.replace(/^\s*[\r\n]/gm, '');
const removeTrailingSpaces = (s) => s.split(/\r?\n/).map(sp => sp.replace(/\s+$/m, '')).join('\n')
const removeInternalExtraWhitespace = (s) => {
  let leadingSpaces = s.search(/\S|$/)
  let deduped = s.replace(/ +/g, ' ')
  return leadingSpaces > 0 ? " ".repeat(leadingSpaces - 1) + deduped : deduped
};

const normalize = (s) => removeInternalExtraWhitespace(removeTrailingSpaces(removeComments(removeEmptyLines(s))))


// Interface for the Counter component state
interface CounterState {
  currentCount: number;
}

const initialState = { currentCount: 0 };

const getCode = (
  project: string,
  chapter: string,
  file: string,
  setCode: React.Dispatch<React.SetStateAction<string>>
) => {
  if (file === '') {
    setCode('');
  } else {
    fetch(`${api_url}/api/code/${encodeURIComponent(project)}/${encodeURIComponent(chapter)}/${encodeURIComponent(file)}`)
      .then((response) => response.json() as Promise<CodeAPI>)
      .then(({ code }) => {
        setCode(code)
      })
      .catch((error) => {
        console.error('Error:', error);
      });
  }
};

const getProjects = (
  setProjects: React.Dispatch<
    React.SetStateAction<string[]>
  >
) => {

  fetch(`${api_url}/api/projects/`)
    .then((response) => response.json() as Promise<ProjectsListingAPI>)
    .then(({ projects }) => {
      setProjects(projects)
    })
    .catch((error) => {
      console.error('Error:', error);
    });
};

const getChapters = (
  project: string,
  setAvailableChapters: React.Dispatch<
    React.SetStateAction<string[]>
  >
) => {
  if (project === "") {
    setAvailableChapters([]);
    return;
  }
  fetch(`${api_url}/api/chapter_list/${encodeURIComponent(project)}`)
    .then((response) => response.json() as Promise<ChaptersListingAPI>)
    .then(({ chapters }) => {
      setAvailableChapters(chapters)
    })
    .catch((error) => {
      console.error('Error:', error);
    });
};



const getFiles = (
  project: string,
  chapter: string,
  setAvailableFiles: React.Dispatch<
    React.SetStateAction<string[]>
  >
) => {
  if (project === "" || chapter == "") {
    setAvailableFiles([])
    return
  }
  fetch(`${api_url}/api/file_list/${encodeURIComponent(project)}/${encodeURIComponent(chapter)}`)
    .then((response) => response.json() as Promise<FilesListingAPI>)
    .then(({ files }) => {
      setAvailableFiles(files);
    })
    .catch((error) => {
      console.error('Error:', error);
    });
};

export default () => {
  const darkMode = useDarkMode(true);

  const [availableProjects, setProjects] = useState([] as string[]);
  const [projectSelected, setProjectSelected] = useState("");
  const [availableChapters, setAvailableChapters] = useState([] as string[]);
  const [chapterSelected, setChapterSelected] = useState("");
  const [availableFiles, setAvailableFiles] = useState([] as string[]);
  const [fileSelected, setFileSelected] = useState("");
  const [correctCode, setCode] = useState('');
  const [userCode, setUserCode] = useState('');

  const [konamiCodePressed, setKonamiCodePressed] = useState(false);

  useEffect(() => {
    getProjects(setProjects);
  }, []);

  useEffect(() => {
    getChapters(projectSelected, setAvailableChapters);
  }, [projectSelected]);

  useEffect(() => {
    getFiles(projectSelected, chapterSelected, setAvailableFiles);
  }, [projectSelected, chapterSelected]);


  useEffect(() => {
    getCode(projectSelected, chapterSelected, fileSelected, setCode);
  }, [projectSelected, chapterSelected, fileSelected]);



  const projects = availableProjects.map((projectName, key) => {
    return (
      <div className="form-check" key={key}>
        <label>
          <input
            type="radio"
            name="address"
            checked={projectName === projectSelected}
            onChange={() => {
              setProjectSelected(projectName);
              setChapterSelected("");
              setFileSelected("")
            }}
          />
          <span>{projectName}</span>
        </label>
      </div>
    );
  });


  const chapters = availableChapters.map((chapterName, key) => {
    return (
      <div className="form-check" key={key}>
        <label>
          <input
            type="radio"
            name="address"
            checked={chapterName === chapterSelected}
            onChange={() => {
              setChapterSelected(chapterName);
              setFileSelected("")
            }}
          />
          <span>{chapterName}</span>
        </label>
      </div>
    );
  });


  const fileSelect = availableFiles.map((filename, key) => {

    const fileSplit = filename.split('/');
    const fileDisplay = fileSplit.map((breadcrumb, index) =>
      index !== fileSplit.length - 1 ? (
        <span key={index}>
          <span className="directoryBreadcrumb">{breadcrumb}</span>
          <span className="directorySlash">/</span>
        </span>
      ) : (
          <span className="directoryFilename" key={index}>
            {breadcrumb}
          </span>
        )
    );
    return (
      <div className="form-check" key={key}>
        <label>
          <input
            type="radio"
            name="address"
            checked={filename === fileSelected}
            onChange={() => {
              setFileSelected(filename);
            }}
          />
          <span className="directory">{fileDisplay}</span>
        </label>
      </div>
    );
  });



  const studentDiff = <ReactDiffViewer
    oldValue={normalize(userCode)}
    newValue={normalize(correctCode)}
    splitView={false}
    leftTitle={`${fileSelected} (STUDENT)`}
    rightTitle={`${fileSelected} (TEXTBOOK)`}
    useDarkTheme={darkMode.value}
    showAdded={false}
  />
  const teacherDiff = <ReactDiffViewer
    oldValue={normalize(userCode)}
    newValue={normalize(correctCode)}
    splitView={true}
    leftTitle={`${fileSelected} (STUDENT)`}
    rightTitle={`${fileSelected} (TEXTBOOK)`}
    useDarkTheme={darkMode.value}
  />


  return (
    <Layout>
      <Konami action={() => setKonamiCodePressed(true)} />


      <h2>This tool will show you where the code you've written differs from the code as you should have it at a specific point in the book. </h2>
      <h3>It is divided by sections of each chapter (i.e., the large purple headings in each chapter) and is tied to what the code should
        look like at the end of that section.</h3>
      <label>
        What prototype chapter are you working on?
        <form onSubmit={() => { }}>
          {projects}
        </form>
      </label>
      {
        chapters.length > 0 ?
          (
            <label>
              And what section of the chapter have you just completed?
              <form onSubmit={() => { }}>
                {chapters}
              </form>
            </label>)
          : <span></span>
      }

      {availableFiles.length !== 0 ? (
        <label>
          What file?

          <form onSubmit={() => { }}>
            {fileSelect}
          </form>
        </label>
      ) : (
          <span></span>
        )}

      <TextareaAutosize
        placeholder="Please paste your code here!"
        value={userCode}
        onChange={(e) => setUserCode(e.target.value)}
      />

      {userCode.length !== 0 && correctCode.length !== 0 ? (
        <div className="diff-viewer">
          {konamiCodePressed ? teacherDiff : studentDiff}
        </div>
      ) : (
          <div></div>
        )}
    </Layout>
  );
};
