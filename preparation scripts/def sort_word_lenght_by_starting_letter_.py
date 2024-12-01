import os
import re
def sort_word_lenght_by_starting_letter_before_arrow(filepath, output="output_sorted.txt"):

    # Dictionary with letters, we put another dictionary in them to signify the word associated with each line
    letter_groups = {}
    # Sorted words associated with each line
    sorted_groups =[]

    with open(filepath, 'r', encoding='utf-8', errors='ignore') as file1:
        lines = file1.readlines()
        # Sort only applies for the first letter
        lines = sorted(lines, key=lambda line: line[0])

        for line in lines:
            first_word = line.split()[0]
            word_dict = {first_word: line}
            first_letter = first_word[0]
            
            if first_letter in letter_groups:
                letter_groups[first_letter].append(word_dict)
            else:  # Make list of letter to append to if another is found
                letter_groups[first_letter] = [word_dict]
        
       
    for let_group in letter_groups.items():
        # print(let_group[0])
        # Sort the dictionary items in reverse order by their keys (first_word)
        sorted_group = sorted(let_group[1], key=lambda x: len(list(x.keys())[0].lower()), reverse=True)

        for word_lines in sorted_group:
            sorted_groups.append(word_lines)
            print(word_lines)

    # final sorted lines for the output_sorted.txt
    sorted_lines = []
    for word_line in sorted_groups:
        for line in word_line.values():
            sorted_lines.append(line)
    
    with open(output, 'w', encoding="utf-8") as outf:
        outf.writelines(sorted_lines)


def create_sql_queries(filepath, output="output_sql.txt"):
    output_lines = []
    sql_template = """
UPDATE texts 
SET desc = REPLACE(REPLACE(REPLACE(desc, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
name = REPLACE(REPLACE(REPLACE(name, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str1 = REPLACE(REPLACE(REPLACE(str1, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str2 = REPLACE(REPLACE(REPLACE(str2, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str3 = REPLACE(REPLACE(REPLACE(str3, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str4 = REPLACE(REPLACE(REPLACE(str4, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str5 = REPLACE(REPLACE(REPLACE(str5, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str6 = REPLACE(REPLACE(REPLACE(str6, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str7 = REPLACE(REPLACE(REPLACE(str7, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str8 = REPLACE(REPLACE(REPLACE(str8, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str9 = REPLACE(REPLACE(REPLACE(str9, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str10 = REPLACE(REPLACE(REPLACE(str10, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str11 = REPLACE(REPLACE(REPLACE(str11, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str12 = REPLACE(REPLACE(REPLACE(str12, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str13 = REPLACE(REPLACE(REPLACE(str13, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str14 = REPLACE(REPLACE(REPLACE(str14, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str15 = REPLACE(REPLACE(REPLACE(str15, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}')),
str16 = REPLACE(REPLACE(REPLACE(str16, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}'))
WHERE desc LIKE '%{old_word}%' OR name LIKE '%{old_word}%' OR
str1 LIKE '%{old_word}%' OR str2 LIKE '%{old_word}%' OR str3 LIKE '%{old_word}%' OR
str4 LIKE '%{old_word}%' OR str5 LIKE '%{old_word}%' OR str6 LIKE '%{old_word}%' OR
str7 LIKE '%{old_word}%' OR str8 LIKE '%{old_word}%' OR str9 LIKE '%{old_word}%' OR
str10 LIKE '%{old_word}%' OR str11 LIKE '%{old_word}%' OR str12 LIKE '%{old_word}%' OR
str13 LIKE '%{old_word}%' OR str14 LIKE '%{old_word}%' OR str15 LIKE '%{old_word}%' OR
str16 LIKE '%{old_word}%';
"""
    sql_name_only = """
UPDATE texts SET 
name = REPLACE(REPLACE(REPLACE(name, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}'))
WHERE 
name LIKE '%{old_word}%' OR name LIKE LOWER('%{old_word}%') OR name LIKE UPPER('%{old_word}%');
"""
    sql_desc_only = """
UPDATE texts SET 
desc = REPLACE(REPLACE(REPLACE(desc, '{old_word}', '{new_word}'), LOWER('{old_word}'), LOWER('{new_word}')), UPPER('{old_word}'), UPPER('{new_word}'))
WHERE 
desc LIKE '%{old_word}%' OR desc LIKE LOWER('%{old_word}%') OR desc LIKE UPPER('%{old_word}%');
"""
    sql_whole_word ="""
UPDATE texts
SET 
desc = REPLACE(
REPLACE(REPLACE(' ' || desc || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
name = REPLACE(
REPLACE(REPLACE(' ' || name || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str1 = REPLACE(
REPLACE(REPLACE(' ' || str1 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str2 = REPLACE(
REPLACE(REPLACE(' ' || str2 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str3 = REPLACE(
REPLACE(REPLACE(' ' || str3 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str4 = REPLACE(
REPLACE(REPLACE(' ' || str4 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str5 = REPLACE(
REPLACE(REPLACE(' ' || str5 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str6 = REPLACE(
REPLACE(REPLACE(' ' || str6 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str7 = REPLACE(
REPLACE(REPLACE(' ' || str7 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str8 = REPLACE(
REPLACE(REPLACE(' ' || str8 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str9 = REPLACE(
REPLACE(REPLACE(' ' || str9 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str10 = REPLACE(
REPLACE(REPLACE(' ' || str10 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str11 = REPLACE(
REPLACE(REPLACE(' ' || str11 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str12 = REPLACE(
REPLACE(REPLACE(' ' || str12 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str13 = REPLACE(
REPLACE(REPLACE(' ' || str13 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str14 = REPLACE(
REPLACE(REPLACE(' ' || str14 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str15 = REPLACE(
REPLACE(REPLACE(' ' || str15 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
),
str16 = REPLACE(
REPLACE(REPLACE(' ' || str16 || ' ', ' {old_word} ', ' {new_word} '), 
LOWER(' {old_word} '), LOWER(' {new_word} ')), 
UPPER(' {old_word} '), UPPER(' {new_word} ')
)
WHERE 
' ' || desc || ' ' LIKE '% {old_word} %' OR 
' ' || desc || ' ' LIKE '% ' || LOWER('{old_word}') || ' %' OR 
' ' || desc || ' ' LIKE '% ' || UPPER('{old_word}') || ' %' OR 
' ' || name || ' ' LIKE '% {old_word} %' OR 
' ' || name || ' ' LIKE '% ' || LOWER('{old_word}') || ' %' OR 
' ' || name || ' ' LIKE '% ' || UPPER('{old_word}') || ' %';

"""
    sql_desc_special="""
UPDATE texts SET
desc = REPLACE(desc, '{old_word}', '{new_word}'),
name = REPLACE(name, '{old_word}', '{new_word}')
WHERE desc REGEXP '{before_chars}{old_word}{after_chars}' OR name REGEXP '{before_chars}{old_word}{after_chars}';
"""

    with open(filepath,"r", encoding="utf-8") as sorted_file:
        lines = sorted_file.readlines()
        sql_line = ""

        for line in lines:
            line = line.split('--')[0].strip() # -- for comments
            old_word = line.split(" -> ")[0].strip()
            new_word = line.split(" -> ")[1].replace("\n", "").strip()

            # Whole word
            if old_word[0] == "-" and old_word[-1] == "-":
                old_word = old_word.removeprefix("-").removesuffix("-")
                sql_line = sql_whole_word.format(new_word= new_word, old_word= old_word)

            # Name only
            elif "(nameonly)" in old_word.lower().replace(" ", ""):
                sql_line = sql_name_only.format(new_word= new_word, old_word= old_word)

            # Desc only
            elif "(desconly)" in old_word.lower().replace(" ", ""):
                sql_line = sql_desc_only.format(new_word= new_word, old_word= old_word)

            # Characters specified
            elif old_word.replace(" ", "")[-1] == ")" or old_word.replace(" ","")[0] == "(":
                old_word_cleaned = re.sub(r'\((.*?)\)', "", old_word).rstrip().lstrip()

                before_chars_match = re.search(r'\((.*?)\)\s*' + re.escape(old_word_cleaned), old_word)
                after_chars_match = re.search(re.escape(old_word_cleaned) + r'\s*\((.*?)\)', old_word)

                # Extract characters before and after the old_word
                chars_before = before_chars_match.group(1).replace(" ", "") if before_chars_match else ""
                chars_after = after_chars_match.group(1).replace(" ", "") if after_chars_match else ""
                
                # Format so SQL can recognize
                # in this way, we can ignore empty strings
                if chars_before: chars_before = "[{c}]".format(c=chars_before)
                if chars_after: chars_after = "[{c}]".format(c=chars_after)
                
                sql_line = sql_desc_special.format(new_word= new_word, old_word= old_word_cleaned, 
                                                     before_chars= chars_before, after_chars= chars_after)
                # print(sql_line)
            # Normal
            else:                
                sql_line = sql_template.format(new_word= new_word, old_word= old_word)
            

            output_lines.append(sql_line)
    
    with open(output, "w", encoding="utf-8") as outf:
        output_lines.insert(0, "PRAGMA case_sensitive_like = ON;")
        output_lines.append('''
UPDATE texts SET 
desc = LTRIM(desc),
name = LTRIM(name),
str1 = LTRIM(str1),
str2 = LTRIM(str2),
str3 = LTRIM(str3),
str4 = LTRIM(str4),
str5 = LTRIM(str5),
str6 = LTRIM(str6),
str7 = LTRIM(str7),
str8 = LTRIM(str8),
str9 = LTRIM(str9),
str10 = LTRIM(str10),
str11 = LTRIM(str11),
str12 = LTRIM(str12),
str13 = LTRIM(str13),
str14 = LTRIM(str14),
str15 = LTRIM(str15),
str16 = LTRIM(str16);
UPDATE texts SET 
desc = RTRIM(desc),
name = RTRIM(name),
str1 = RTRIM(str1),
str2 = RTRIM(str2),
str3 = RTRIM(str3),
str4 = RTRIM(str4),
str5 = RTRIM(str5),
str6 = RTRIM(str6),
str7 = RTRIM(str7),
str8 = RTRIM(str8),
str9 = RTRIM(str9),
str10 = RTRIM(str10),
str11 = RTRIM(str11),
str12 = RTRIM(str12),
str13 = RTRIM(str13),
str14 = RTRIM(str14),
str15 = RTRIM(str15),
str16 = RTRIM(str16);
''')
        outf.writelines(output_lines)
    
    print("Program has run sucessfully.")
            

            



input("""This script:
-Sorts the list alphabetically by only checking the first letter in an descending order
-Then it sorts the lines by the longest first word (word to convert) to the shortest 
 grouped by their first letter. Gives sorted_output.txt
-Then it prepares SQLite statements in the direction of sorted_output.txt.

How to format the list:
It is mandatory to have spaces surrounding the "->"
If you want to use ' in your lines put it twice so that SQL cannot return error: Instead of Tree's write Tree''s etc.
There's 5 modes. Each line can accomodate 1 mode:
-> Normal
    Wordtoconvert -> Resultword
    - Prepares the conversion through UPPER and LOWER functions in SQL and the conversion specified in the list
    - For both name and desc
-> Specific characters before and/or after the word
    Brackets specify what character(s) should appear before and/or after the word, without changing the characters themselves:
    GY(.,) -> RP    If GY has "." or "," after, then it converts the GY only to RP
    - Prepares only the conversion in the list
    - Spaces in the brackets ignored
    - For both name and desc
    Please do not use multiple of the same brackets before or after the word!
-> Whole word
      -Fly- -> Bee
    By surrounding the word with -, the word is in whole word mode.
    In whole word mode, there must be NO characters before and after the word for the conversion to happen
    - Prepares UPPER, LOWER and conversion in the list
    - For both name and desc
-> Name only
      wordtoconvert(name only) -> resultword
      By adding (name only) after/before the word it means that only the name will be checked
      Overwrites any other () alteration
      Prepares UPPER, LOWER and conversion in the list
-> Desc only
      wordtoconvert(desc only) -> resultword
      By adding (desc only) after/before the word it means that only the name will be checked
      Prepares UPPER, LOWER and conversion in the list
    Note about Name and Desc only, if both are added to a word in the same line then name
    Note2 Using them *will* cause name inconsistencies, this does not affect functionality of cards. I hope
In order to circumvent some of the limitations, you can add multiple of the same conversions with different
modes to achieve the result you want. This script is not perfect and I am aware.
-Al- -> Ball
-AL- -> BALL
-al- -> ball
(, ; . !)Al -> Ball
-- for comments and everything after them is ignored in the line
PRESS ENTER TO START
""")
sort_word_lenght_by_starting_letter_before_arrow(r"C:\Users\stefa\Desktop\halal_yugioh\extra-non\\halal text converstions.txt")
create_sql_queries("output_sorted.txt")