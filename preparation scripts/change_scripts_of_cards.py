import os

scripts_path = "input_scripts"  # Path of the scripts folder we want to convert
conversion_path = "output_sorted.txt"  # Path of halal conversions txt, preferably SORTED

def convert_scripts_content(scripts_path, conversion_path, output="output_scripts"):
    exceptions = ["PHANT",  # PHANT because of the ELEPHANT win condition
                  "Grave", "Forbidden", "Reviv", "Dice",
                  "SUMMON", "Summon", "summon", "Earth", "EARTH", "earth"]
    # Some extras
    words_to_convert = {"GY": "RP"} 
    # These are added at the end of the words_to_convert after it has been populated
    words_to_append = {"DAMANCED": "DAMAGE", "Damanced": "Damage", "damanced": "damage"} 

    with open(conversion_path, "r", encoding="utf-8") as filec:
        lines = filec.readlines()
         
        for line in lines:
            line = line.split("--")[0].strip()
            split_line = line.split(" -> ")
            old_word = split_line[0].strip()
            new_word = split_line[1].replace("\n", "").strip()
            
            # Ignore the modes other than normal
            if not (old_word[0] == "-" and old_word[-1] == "-" or \
            "nameonly" in old_word.replace(" ", "") or \
            "desconly" in old_word.replace(" ", "") or \
            old_word.replace(" ", "")[-1] == ")" or \
            old_word.replace(" ","")[0] == "("):
                # Add to converts the variations that are not in exceptions
                old_variations = [old_word, old_word.upper(), old_word.lower()]
                new_variations = [new_word, new_word.upper(), new_word.lower()]
                for i in range(len(old_variations)):
                    if old_variations[i] in exceptions:
                        print(f"Ignoring {old_variations[i]}")
                    else:
                        words_to_convert.update({old_variations[i]: new_variations[i]})
        
        words_to_convert.update(words_to_append)

    # Ensure output directory exists
    if not os.path.exists(output):
        os.makedirs(output)

    # Rename directories if needed
    for root, dirs, files in os.walk(scripts_path, topdown=False):
        for old, new in words_to_convert.items():
            if old in root:
                new_root = root.replace(old, new)
                os.rename(root, new_root)
                print(f"Renamed directory: {root} -> {new_root}")
                break  # Stop checking further once renamed

    # Walk through all files and folders in the scripts_path
    for root, dirs, files in os.walk(scripts_path, topdown=True):
        relative_path = os.path.relpath(root, scripts_path)
        output_dir = os.path.join(output, relative_path)

        # Create equivalent directory structure in output
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
        
        for file_name in files:
            input_file_path = os.path.join(root, file_name)
            output_file_path = os.path.join(output_dir, file_name)

            # Rename file if needed
            for old, new in words_to_convert.items():
                if old in file_name:
                    output_file_path = os.path.join(output_dir, file_name.replace(old, new))
                    break  # Stop checking further once renamed

            # Read, replace, and save file content
            try:
                with open(input_file_path, "r", encoding="utf-8") as infile:
                    content = infile.read()

                for old, new in words_to_convert.items():
                    content = content.replace(old, new)
                    
                with open(output_file_path, "w", encoding="utf-8") as outfile:
                    outfile.write(content)

                print(f"Processed: {input_file_path} -> {output_file_path}")
            except Exception as e:
                print(f"Failed to process file {input_file_path}: {e}")

    print("Conversion completed.")

# Call the function

convert_scripts_content(scripts_path, conversion_path)