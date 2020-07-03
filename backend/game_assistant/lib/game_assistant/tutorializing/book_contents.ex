defmodule GameAssistant.Tutorializing.BookConents do

# example json:
# "{
#   \"projects\": {
#     \"space smup\": {
#       \"ch1\": {
#         \"scripts/file1\": \"line1;\\nline2;\\nline3;\\nline4;\"
#       },
#       \"ch2\": {
#         \"scripts/file2\": \"brine1;\\nbrine2;\\nbrine3;\\nbrine4;\"
#       }
#     }
#   }
# }"

  def rawContents() do
  "{
    \"projects\": {
      \"space smup\": {
        \"ch1\": {
          \"scripts/file1\": \"line1;\\nline2;\\nline3;\\nline4;\"
        },
        \"ch2\": {
          \"scripts/file2\": \"brine1;\\nbrine2;\\nbrine3;\\nbrine4;\"
        }
      }
    }
  }"
  end

  def getContents() do
    Jason.decode!(rawContents())
  end
end
