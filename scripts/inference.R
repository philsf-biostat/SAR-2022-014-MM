# setup -------------------------------------------------------------------
# library(infer)

# tables ------------------------------------------------------------------

# t_24 <- analytical %>%
#   select(-ends_with("48"), -starts_with(c("perda", "vol", "cha", "hhs"))) %>%
#   pivot_longer(
#     -id,
#   ) %>%
#   separate(name, into = c("name", "time")) %>%
#   mutate(
#     time = ifelse(time == "pre", time, "pos"),
#   ) %>%
#   pivot_wider() %>%
#   mutate(
#     time = factor(time, levels = c("pre", "pos")),
#   ) %>%
#   tbl_summary(
#     include = -id,
#     by = time,
#     label = c(
#       hb = attr(analytical$hb_24, "label"),
#       ht = attr(analytical$ht_24, "label"),
#       eva = attr(analytical$eva_24, "label")
#     ),
#   ) %>%
#   add_difference(
#     # test = list(all_continuous() ~ "paired.t.test", all_categorical() ~ "mcnemar.test"),
#     test = all_continuous() ~ "paired.t.test",
#     group = id,
#   ) %>%
#   modify_header(estimate ~ '**Diferença**')
# 
# t_48 <- analytical %>%
#   select(-ends_with("24"), -starts_with(c("perda", "vol", "cha"))) %>%
#   pivot_longer(
#     -id,
#   ) %>%
#   separate(name, into = c("name", "time")) %>%
#   mutate(
#     time = ifelse(time == "pre", time, "pos"),
#   ) %>%
#   pivot_wider() %>%
#   mutate(
#     time = factor(time, levels = c("pre", "pos")),
#   ) %>%
#   tbl_summary(
#     include = -id,
#     by = time,
#     label = c(
#       hb = attr(analytical$hb_48, "label"),
#       ht = attr(analytical$ht_48, "label"),
#       eva = attr(analytical$eva_48, "label"),
#       hhs = attr(analytical$hhs_pre, "label")
#     ),
#     type = list(eva ~ "continuous"),
#     ) %>%
#   add_difference(
#     # test = list(all_continuous() ~ "paired.t.test", all_categorical() ~ "mcnemar.test"),
#     test = all_continuous() ~ "paired.t.test",
#     group = id,
#   ) %>%
#     modify_header(estimate ~ '**Diferença**')
# 
# tab_inf <- tbl_stack(list(t_24, t_48))
# 
# write_rds(tab_inf, "dataset/tab_inf.rds")

tab_inf <- read_rds("dataset/tab_inf.rds")
