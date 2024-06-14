# Установка и загрузка необходимых библиотек
install.packages(c("ggplot2", "sf", "rnaturalearth", "rnaturalearthdata", "dplyr"))
library(ggplot2)
library(sf)
library(rnaturalearth)
library(rnaturalearthdata)
library(dplyr)

# Данные о кредитных рейтингах ---------------------------
ratings <- data.frame(
  ratings <- data.frame(
    country = c("Albania", "Andorra", "Austria", "Azerbaijan", "Belarus", "Belgium",
                "Bosnia and Herz.", "Bulgaria", "Croatia", "Cyprus", "Czechia",
                "Denmark", "Estonia", "Finland", "France", "Georgia", "Germany", "Greece",
                "Hungary", "Iceland", "Ireland", "Italy", "Kazakhstan", "Kosovo", "Latvia", 
                "Lithuania", "Luxembourg", "Malta", "Moldova", "Montenegro", "Netherlands", 
                "North Macedonia", "Norway", "Poland", "Portugal", "Romania", "Russia", 
                "Serbia", "Slovakia", "Slovenia", "Spain", "Sweden", "Switzerland", "Turkey", 
                "Ukraine", "United Kingdom", "Armenia"),
    rating = c("BB", "AAA", "AAA", "BB+", "BB-", "AAA", "BB", "A", "AAA", "AAA", "AA+", "AAA",
               "AAA", "AAA", "AAA", "BBB-", "AAA", "AAA", "BBB+", "AA-", "AAA", "AAA", "BBB", 
               "NA", "AAA", "AAA", "AAA", "AAA", "BB-", "AAA", "AAA", "BB", "AAA", "A+", "AAA", 
               "A-", "BB+", "BBB-", "AAA", "AAA", "AAA", "AAA", "AAA", "B+", "CCC+", "AAA", "BB")
  )
)
ratings$rating[ratings$country == "Iceland"] <- "AA-"

# Загрузка географических данных для Европы ---------------------------
europe <- ne_countries(scale = "medium", returnclass = "sf")

# Фильтрация для включения только европейских стран и европейских частей России, Турции, Казахстана и кавказских стран ---------------------------
europe <- europe %>%
  filter(
    region_un == "Europe" |
      name %in% c("Russia", "Turkey", "Kazakhstan", "Armenia", "Azerbaijan", "Georgia")
  )

ratings$rating[ratings$country == "Iceland"] <- "AA-"

europe <- st_crop(europe, xmin = -25, xmax = 60, ymin = 10, ymax = 75)

# Объединение данных с рейтингами ---------------------------
europe_ratings <- europe %>%
  left_join(ratings, by = c("name" = "country"))

# Создание цветовой палитры ---------------------------
rating_colors <- c(
  "AAA" = "#006400",  # DarkGreen
  "AA+" = "#00FF00",  # Lime
  "A+" = "#ADFF2F",   # GreenYellow
  "A" = "#FFFF00",    # Yellow
  "BBB+" = "#FFD700", # Gold
  "BBB" = "#FFA500",  # Orange
  "BBB-" = "#FF4500", # OrangeRed
  "BB+" = "#DC143C",  # Crimson
  "BB" = "#FF0000",   # Red
  "BB-" = "#8B0000",  # DarkRed
  "B+" = "#A52A2A",   # Brown
  "CCC+" = "#800000", # Maroon
  "A-" = "#FFFFE0"    # LightYellow
)

# Создание карты ---------------------------
ggplot(data = europe_ratings) +
  geom_sf(aes(fill = rating)) +
  scale_fill_manual(values = rating_colors, na.value = "grey") +
  theme_minimal() +
  labs(
    title = "Кредитные рейтинги стран Европы",
    fill = "Рейтинг"
  )



# Установка пути для сохранения файла
save_path <- "C:/Users/User/Desktop/R/map.png"

# Сохранение изображения карты
ggsave(filename = save_path, plot = last_plot(), width = 10, height = 8, dpi = 300)
