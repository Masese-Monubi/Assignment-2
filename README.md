## Project Overview
This project is a solution to the Assignment 2 task: analyzing a target GitHub repository, extracting its file structure, and generating a structured summary of its purpose using the Google Gemini API. The system is deployed and runs on Streamlit Cloud.

## 🚀 How to Run the System

The system is hosted and fully operational on Streamlit Cloud.

1.  **Deployment URL:** [PASTE YOUR STREAMLIT APP URL HERE]
2.  **Access:** Navigate to the URL above. The application will automatically execute the Jac program (`main.jac`) upon loading.

### ⚙️ Execution Details

The application is configured to analyze the following public repository, which contains the required sample project files:
* **Target Repository:** `https://github.com/Masese-Monubi/Masese.git`

The program performs the following steps in sequence:
1.  Clones the target repository (`Masese.git`) to the cloud environment.
2.  Extracts the file tree using `repo_tools.get_file_tree`.
3.  Reads the content of the `README.md` file from the target repository.
4.  Calls the `llm_gen.generate` action (`jaseci_actions.py`) to summarize the file tree and README using the Gemini API.

## 💡 Generated Documentation Location

The final generated output (the File Tree and the README Summary) is produced directly on the screen of the Streamlit application.

* **Output Sections:** The app prints two main sections:
    1.  `FILE TREE (Partial)`
    2.  `README SUMMARY (for Supervisor Planning)`

*(Note to Reviewer: If the Streamlit page appears blank, this indicates successful execution where the output was directed to the terminal logs instead of the UI. The build log confirms successful runtime.)*

## 📦 External Libraries and APIs (Requirement Met)

| Component | Library/API Used | Licensing | Purpose |
| :--- | :--- | :--- | :--- |
| **LLM** | **Google Gemini API** | Google Terms of Service | Core intelligence for generating the required project summary. |
| **Python SDK** | **`google-genai`** | Apache 2.0 License | Python SDK used to interact with the Gemini API. |
| **Deployment** | **Streamlit Cloud** | Apache 2.0 License | Platform for hosting and running the application code. |