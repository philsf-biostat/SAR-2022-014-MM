# setup -------------------------------------------------------------------
library(philsfmisc)
# library(data.table)
library(tidyverse)
library(readxl)
# library(haven)
# library(foreign)
library(lubridate)
# library(naniar)
library(labelled)

# data loading ------------------------------------------------------------
set.seed(42)
# data.raw <- tibble(id=gl(2, 10), group = gl(2, 10), outcome = rnorm(20))
data.raw <- read_excel("dataset/Cópia Mestrado ATQ bilateral 09  Maio.xlsx",na = "NA") %>%
  janitor::clean_names()

Nvar_orig <- data.raw %>% ncol
Nobs_orig <- data.raw %>% nrow

# data cleaning -----------------------------------------------------------

data.raw <- data.raw %>%
  # select() %>%
  rename(
    id = prontuario,
    volemia = volemia_pre,
    perda_hb_24 = perda_hb_estimada_24,
    vol_tr = volume_transfundido,
    vol_24 = volume_infundido_24,
    vol_48 = volume_infundido_48,
  ) %>%
  mutate(
    idade = floor((nasc %--% data_cir)/dyears(1)),
    imc = peso/(altura^2),
    volemia = case_when(
      sexo == "M" ~ altura^3 * .356 * peso * .33 + .183,
      sexo == "H" ~ altura^3 * .367 * peso * .32 + .604,
    ),
    perda_hb_24 = volemia * (hb_pre - hb_24) + vol_24,
    perda_hb_48 = volemia * (hb_pre - hb_48) + vol_48,
    perda_sang_24 = volemia * perda_hb_24 / hb_pre,
    perda_sang_48 = volemia * perda_hb_48 / hb_pre,
    across(where(is.POSIXct), as.Date),
  ) %>%
  filter()

# data wrangling ----------------------------------------------------------

data.raw <- data.raw %>%
  mutate(
    id = factor(id), # or as.character
  )

# labels ------------------------------------------------------------------

data.raw <- data.raw %>%
  set_variable_labels(
    # group = "Study group",
    # outcome = "Study outcome",
  )

# analytical dataset ------------------------------------------------------

epi <- data.raw %>%
  # perfil epidemiológico
  select(
    id,
    sexo,
    idade,
    imc,
    volemia,
    contains("pre"),
    lado_1,
    cha_cir,
    vol_tr,
    tempo_alta,
  )

analytical <- data.raw %>%
  # select analytic variables
  select(
    id,
    hb_pre,
    ht_pre,
    eva_pre,
    hhs_pre,
    cha_cir,
    hb_24,
    ht_24,
    cha_24,
    vol_24,
    eva_24,
    perda_hb_24,
    perda_sang_24,
    hb_48,
    ht_48,
    cha_48,
    vol_48,
    eva_48,
    perda_hb_48,
    perda_sang_48,
    hhs_6s,
  )

Nvar_final <- analytical %>% ncol
Nobs_final <- analytical %>% nrow

# mockup of analytical dataset for SAP and public SAR
analytical_mockup <- tibble( id = c( "1", "2", "3", "...", "N") ) %>%
# analytical_mockup <- tibble( id = c( "1", "2", "3", "...", as.character(Nobs_final) ) ) %>%
  left_join(analytical %>% head(0), by = "id") %>%
  mutate_all(as.character) %>%
  replace(is.na(.), "")
