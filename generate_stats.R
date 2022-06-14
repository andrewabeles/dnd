abilities <- c(
  "strength",
  "dexterity",
  "constitution",
  "intelligence",
  "wisdom",
  "charisma"
)

races <- c(  
  "dragonborn",
  "dwarf",
  "elf",
  "gnome",
  "half.elf",
  "half.orc",
  "halfling",
  "human",
  "tiefling"
)

roll <- function(n, d) {
  if (d > 0) {
    values <- sample(1:d, n, replace = TRUE) # roll a d-sided die n times
  }
  else {
    values <- c(0, 0)
  }
  sum <- sum(values)
  result <- list(values, sum)
  names(result) <- c("values", "sum")
  return(result)
}

roll.stat <- function() {
  result <- roll(4, 6) # roll 4d6
  lowest <- min(result$values) # take the lowest 
  return(result$sum - lowest) # and remove it from the sum 
}

roll.stats <- function(n) {
  X <- matrix(1:n*6, nrow = n, ncol = 6)
  X[] <- sapply(X, function(ij) roll.stat())
  df <- as.data.frame(X)
  names(df) <- sapply(abilities, function(a) sprintf("%s.roll", a), USE.NAMES = FALSE)
  df$race <- apply(df, 1, function(i) sample(races, 1)) # randomly assign race 
  return(df)
}

set.seed(0)
stats.rolled <- roll.stats(10000)

base.height <- c(66, 48, 54, 35, 57, 58, 31, 56, 57)
base.weight <- c(175, 130, 90, 36, 110, 140, 36, 110, 110)
height.mod <- c(8, 4, 10, 4, 8, 10, 4, 10, 8)
weight.mod <- c(6, 6, 4, 0, 4, 6, 0, 4, 4)
speed <- c(30, 25, 30, 25, 30, 30, 25, 30, 30)
strength.mod <- c(2, 0, 0, 0, 0, 2, 0, 1, 0)
dexterity.mod <- c(2, 0, 0, 0, 0, 2, 0, 1, 0)
constitution.mod <- c(0, 2, 0, 0, 0, 1, 0, 1, 0)
wisdom.mod <- c(0, 0, 0, 0, 0, 0, 0, 1, 0)
intelligence.mod <- c(0, 0, 0, 2, 0, 0, 0, 1, 1)
charisma.mod <- c(1, 0, 0, 0, 2, 0, 0, 1, 2)

stats.racial <- data.frame(
  base.height,
  base.weight,
  height.mod,
  weight.mod,
  speed,
  strength.mod,
  dexterity.mod,
  constitution.mod,
  wisdom.mod,
  intelligence.mod,
  charisma.mod
)

rownames(stats.racial) <- races

stats <- merge(x = stats.rolled, y = stats.racial, by.x = "race", by.y = "row.names", all = TRUE)

# half elves get +2 charisma and +1 to any two abilities of their choice
set.seed(NULL)
mod.options <- abilities[abilities != "charisma"]
mod.options <- sapply(mod.options, function(a) sprintf("%s.mod", a), USE.NAMES = FALSE)
for (i in 1:nrow(stats)) {
  if (stats[i, "race"] == "half.elf") {
    chosen.mods <- sample(mod.options, 2, replace = FALSE)
    stats[i, chosen.mods[1]] = 1
    stats[i, chosen.mods[2]] = 1
  }
}

stats$strength <- stats$strength.roll + stats$strength.mod
stats$dexterity <- stats$dexterity.roll + stats$dexterity.mod 
stats$constitution <- stats$constitution.roll + stats$constitution.mod
stats$wisdom <- stats$wisdom.roll + stats$wisdom.mod
stats$intelligence <- stats$intelligence.roll + stats$intelligence.mod
stats$charisma <- stats$charisma.roll + stats$charisma.mod

calc.height.weight <- function(base.height, base.weight, height.mod, weight.mod) {
  height.inc <- roll(2, height.mod)$sum
  weight.inc <- height.inc * roll(2, weight.mod)$sum 
  height <- base.height + height.inc
  weight <- base.weight + weight.inc
  totals <- list(height, weight)
  names(totals) <- c("height", "weight")
  return(totals)
}

stats[, "height"] = NA
stats[, "weight"] = NA
for (i in 1:nrow(stats)) {
  size <- calc.height.weight(stats[i, "base.height"], stats[i, "base.weight"], stats[i, "height.mod"], stats[i, "weight.mod"])
  stats[i, "height"] = size$height
  stats[i, "weight"] = size$weight
}

final.cols <- append(abilities, c("race", "height", "weight", "speed"), 0)
stats.final <- stats[, final.cols]
write.csv(stats.final, "stats.csv")
