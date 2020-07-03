defmodule GameAssistantWeb.TutorialController do
  use GameAssistantWeb, :controller

  def getProjects(conn,  %{}) do
    contents = GameAssistant.Tutorializing.BookConents.getContents()

    projects = Map.keys(contents["projects"])
    # filesSorted = Enum.sort(files)
    json(conn, %{projects: projects})

  end


  def getProjectChapters(conn,  %{"project" => project}) do
    contents = GameAssistant.Tutorializing.BookConents.getContents()
    if Map.has_key?(contents["projects"], project) do
      chapters = Map.keys(contents["projects"][project])
      json(conn, %{chapters: chapters})
    else
      json(conn, %{chapters: []})
    end
  end

  def getChapterFiles(conn,  %{"project" => project, "chapter" => chapter}) do
    contents = GameAssistant.Tutorializing.BookConents.getContents()
    if Map.has_key?(contents["projects"], project) do
      if Map.has_key?(contents["projects"][project], chapter) do
        files = Map.keys(contents["projects"][project][chapter])
        filesSorted = Enum.sort(files)
        json(conn, %{files: filesSorted})
      else
        json(conn, %{files: []})
      end
    else
      json(conn, %{files: []})
    end
  end

  def getCode(conn,  %{"project" => project, "chapter" => chapter, "file" => file}) do
    contents = GameAssistant.Tutorializing.BookConents.getContents()
    if Map.has_key?(contents["projects"], project) do
      if Map.has_key?(contents["projects"][project], chapter) do
        if Map.has_key?(contents["projects"][project][chapter], file) do
          json(conn, %{code: contents["projects"][project][chapter][file]})
        else
          json(conn, %{code: ""})
        end
      else
        json(conn, %{code: ""})
      end
    else
      json(conn, %{code: ""})
    end
  end
end
