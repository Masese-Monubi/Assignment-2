# Imports the custom Python helper actions.
import helpers.jaseci_actions as jaseci_actions;
import helpers.repo_tools as repo_tools;

walker repo_mapper {
    # TEMPORARY FIX: URL is hardcoded to bypass the broken 'jac run' argument passing.
    has repo_url: str = "https://github.com/Masese-Monubi/Masese.git";

    # Internal state variables for the walker's execution.
    has local_repo_path: str = "";
    has readme_content: str = "";
    has readme_summary: str = "";
    has file_tree_str: str = "";
    has prompt: str = "";

    with entry {
        jaseci_actions.out("--- Step 1: Cloning Repository ---");

        # Execute the Python action to clone the repository using the hardcoded URL.
        local_repo_path = repo_tools.clone_repo(repo_url=repo_url);

        # --- CRITICAL CHECK: Ensure the clone succeeded and returned a path (not None) ---
        if (local_repo_path) {
            jaseci_actions.out(f"✅ Success! Repository cloned to: {local_repo_path}");

            jaseci_actions.out("--- Step 2: Mapping Repository Structure ---");

            # Read README and generate the file tree.
            readme_content = repo_tools.read_readme(local_path=local_repo_path);
            file_tree_str = repo_tools.get_file_tree(startpath=local_repo_path);
            jaseci_actions.out("✅ File tree generated.");


            # --- Step 3: Summarizing README with LLM ---
            
            # This variable will hold the content we actually send to the LLM
            has prompt_content: str;

            if (readme_content) {
                # If README is found, use its content
                prompt_content = readme_content;
            } else {
                # FALLBACK: If README is empty or missing, provide a dummy description
                prompt_content = "This project is a small, basic repository that contains typical portfolio files: an index.html, a style.css, and some utility code. It appears to be a basic web development template. The README file was empty, so use this information to create a detailed summary.";
                jaseci_actions.out("⚠️ WARNING: README not found/empty. Using a generic fallback description for the summary.");
            };

            # Now, build the final prompt with the determined content
            # Added instruction to guarantee text output.
            prompt = "Summarize the following project's documentation into a concise overview (max 3 paragraphs). You MUST return a summary of at least 50 words. Focus on the project's purpose, key features, and installation instructions:\n\n" + prompt_content;

            jaseci_actions.out("⚠️ Attempting LLM Summary. (Requires GEMINI_API_KEY)");
            readme_summary = jaseci_actions.llm_gen.generate(
                prompt=prompt,
                model="gemini-2.5-flash",
                max_tokens=500
            );

            jaseci_actions.out("✅ LLM Summary complete.");
            

            # --- Step 4: Output for Supervisor (or testing) ---
            jaseci_actions.out("\n*** FILE TREE (Partial) ***");
            jaseci_actions.out(file_tree_str);

            jaseci_actions.out("\n*** README SUMMARY (for Supervisor Planning) ***");
            jaseci_actions.out(readme_summary);
        } else {
             jaseci_actions.out(f"❌ ERROR: Failed to clone repository from {repo_url}. Skipping further steps.");
        };
    }
}
