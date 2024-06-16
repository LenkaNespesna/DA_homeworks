import json

full_list = []

with open('domaci_ukol/netflix_titles.tsv', 'r', encoding='utf-8') as file_in:
    for line in file_in:
        cleaned_line = line.strip().split('\t')  # Split by tab
        full_list.append(cleaned_line)

# First element in the list contains category names (keys)
category = full_list[0]
searched_category = ['PRIMARYTITLE', 'DIRECTOR', 'CAST', 'GENRES', 'STARTYEAR']

# Find indices of the searched categories
position_list = [category.index(item) for item in searched_category]

# Define keys for the film dictionaries
key_list = ['title', 'directors', 'cast', 'genres', 'decade']

# Create dictionaries for each film
final_film_list = []
for j in range(1, len(full_list)):
    film = {}
    for i in range(len(key_list)):
        value = full_list[j][position_list[i]]
        # Store the value as an empty list if it's an empty string
        film[key_list[i]] = [value] if value else []
    final_film_list.append(film)

print(final_film_list)


with open ('domaci_ukol/kontrola_ukol_2.json', 'w', encoding='utf-8') as out_file:
    json.dump(final_film_list, out_file, indent=4, ensure_ascii=False, sort_keys=True)