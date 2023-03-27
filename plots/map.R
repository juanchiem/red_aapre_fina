library(tidyverse)
library(sf)

theme_set(theme_bw()+
            theme(
              panel.grid.major = element_line(color = gray(0.5), 
                                              linetype = "dashed", 
                                              linewidth = 0.1), 
              panel.background = element_rect(fill = "aliceblue"),
              axis.text.x =  element_text(size = 6),
              axis.text.y = element_text(size = 6),
            ))

BSAS <- geodata::gadm(country = "ARG", level = 2, path=here::here()) %>% 
  st_as_sf() %>% 
  filter(NAME_1 == "Buenos Aires") 

BSAS %>% 
  mutate(Localidad = case_when(
    str_detect(NAME_2, "Tandil") ~ "Tandil", 
    str_detect(NAME_2, "Necochea") ~ "Necochea", 
    str_detect(NAME_2, "Pueyrre") ~ "Gral. Pueyrredón")) %>%
  drop_na(Localidad) -> regionales 
# %>%   mutate(id = gsub("[^A-Z]+", "", .$NAME_2)) 

regionales <- cbind(regionales, st_coordinates(st_centroid(regionales$geometry)))

## sitio points
# meta$geo[3] %>% browseURL()
pts <- data.frame(Sitio="Tandil", long =-59.031256,lat=-37.374705) %>% 
  add_case(Sitio="MDP", long =-57.8465417,lat=-37.8798811) %>% 
  add_case(Sitio="La Dulce", long =-58.954469,lat=-38.343524) %>%
  st_as_sf(coords = c('long', 'lat'), crs = 4326)

mapa <- BSAS %>% 
  ggplot()+
  geom_sf()+
  geom_sf(data = BSAS, fill = "gray98", color= "gray60", size =0.2) +
  geom_sf(data = regionales, 
          aes(fill = Localidad),  color = gray(.5), size = 0.2, alpha=.2) +
  geom_sf(data=pts, aes(shape=Sitio))+
  coord_sf(xlim = c(-60,-56.5), ylim = c(-39, -36), expand = FALSE, 
           label_axes = waiver())+
  geom_text(data = regionales, aes(x = X, y = Y,  label = Localidad), 
            size = 3, hjust = 0.5, fontface = "bold")+
  labs(x = "", y = "") +
  guides(fill="none")

ggsave(mapa, filename = "plots/mapa_sitios.png", width = 6, height = 5,units = "in", dpi=300,device = "png")

