def process_files(path1, path2, output_file="output.txt"):
    import os

    # Dictionary to store code-line pairs from the first file
    code_lines = {}

    # Process the first file
    with open(path1, 'r', encoding='utf-8', errors='ignore') as file1:
        for line in file1:
            if "0x" in line:
                # Extract code starting with "0x"
                parts = line.split("0x", 1)
                code = "0x" + parts[1].split(" ", 1)[0].strip()  # Get the hex code and strip whitespace
                code_lines[code.lower()] = line.strip()  # Store the full line in lowercase

    # Process the second file
    if os.path.exists(path2):
        with open(path2, 'r', encoding='utf-8', errors='ignore') as file2:
            for line in file2:
                if "=" in line:  # Check for assignment
                    parts = line.split("=")
                    if len(parts) > 1:
                        # Extract code and strip whitespace
                        code_part = parts[1].strip().split()[0]  # Get the first part after '='
                        if code_part.startswith("0x"):
                            code = code_part.lower()  # Convert to lowercase
                            if code in code_lines:
                                # Append the entire line from the second file to the matching line
                                code_lines[code] += f" -- {line.strip()}"

    # Write output to the file
    with open(output_file, 'w', encoding='utf-8') as out_file:
        for line in code_lines.values():
            out_file.write(line + "\n")

    print("Output file ready")


# Example usage
path1 = r"C:\ProjectIgnis\config\strings.conf"
path2 = r"C:\ProjectIgnis\script\archetype_setcode_constants.lua"
process_files(path1, path2)