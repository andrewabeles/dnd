# D&D Character Stats Dataset Generator  
The script generate_stats.R simulates the creation of 10,000 D&D characters. The resulting dataset can be used to build machine learning models (e.g. predict character race) or to just practice data analysis.  

## Methodology
1. Generate 10,000 rows of ability scores using the Roll 4d6 Drop Lowest method described [here.](https://dicecove.com/how-to-roll-for-stats/)
2. Randomly assign with uniform probability each row one of the playable races from the 5e Player's Handbook.
3. Apply the racial ability modifiers to the rolled ability scores as described [here](https://www.dndbeyond.com/races)
4. Calculate each row's height and weight using the method described [here](https://blackcitadelrpg.com/height-age-weight-5e/)

## Dataset  
[Link to resulting dataset on Kaggle](https://www.kaggle.com/datasets/andrewabeles/dnd-stats)

## Fields 
- race (dragonborn, dwarf, elf, gnome, half-elf, half-orc, halfling, human, tiefling)
- height (inches)
- weight (lbs)
- speed (ft.)
- strength
- dexterity 
- constitution
- wisdom
- intelligence 
- charisma 
