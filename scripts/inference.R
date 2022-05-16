# setup -------------------------------------------------------------------
# library(infer)

# tables ------------------------------------------------------------------

t_24 <- analytical %>%
  # select(id, c(ends_with("pre"), hb_24, ht_24, eva_24, cha_24)) %>%
  # select(id, hb_pre, hb_24, ht_pre, ht_24, eva_pre, eva_24) %>%
  select(-ends_with("48"), -starts_with(c("perda", "vol", "cha", "hhs"))) %>%
  pivot_longer(
    -c(id),
    ) %>%
  separate(name, into = c("name", "time")) %>%
  mutate(
    time = ifelse(time == "pre", time, "pos"),
  ) %>%
  pivot_wider() %>%
  mutate(
    time = factor(time, levels = c("pre", "pos")),
  ) %>%
  tbl_summary(
    include = -id,
    by = time,
    label = c(
      hb = attr(analytical$hb_24, "label"),
      ht = attr(analytical$ht_24, "label"),
      eva = attr(analytical$eva_24, "label")
    ),
  ) %>%
  add_difference(
    # test = list(all_continuous() ~ "paired.t.test", all_categorical() ~ "mcnemar.test"),
    test = all_continuous() ~ "paired.t.test",
    group = id,
  )

t_48 <- analytical %>%
  select(-ends_with("24"), -starts_with(c("perda", "vol", "cha"))) %>%
  pivot_longer(
    -c(id),
  ) %>%
  separate(name, into = c("name", "time")) %>%
  mutate(
    time = ifelse(time == "pre", time, "pos"),
  ) %>%
  pivot_wider() %>%
  mutate(
    time = factor(time, levels = c("pre", "pos")),
  ) %>%
  tbl_summary(
    include = -id,
    by = time,
    label = c(
      hb = attr(analytical$hb_48, "label"),
      ht = attr(analytical$ht_48, "label"),
      eva = attr(analytical$eva_48, "label"),
      hhs = attr(analytical$hhs_pre, "label")
    ),
    type = list(eva ~ "continuous"),
    ) %>%
  add_difference(
    # test = list(all_continuous() ~ "paired.t.test", all_categorical() ~ "mcnemar.test"),
    test = all_continuous() ~ "paired.t.test",
    group = id,
  )

tab_inf <- tbl_stack(list(t_24, t_48))

# template p-value table
# tab_inf <- analytical %>%
#   tbl_summary(
#     include = c(group, outcome),
#     by = group,
#   ) %>%
#   # include study N
#   add_overall() %>%
#   # pretty format categorical variables
#   bold_labels() %>%
#   # bring home the bacon! (options: add_p or add_difference)
#   # add_p: quick and dirty
#   add_p(
#     # use Fisher test (defaults to chi-square)
#     test = all_categorical() ~ "fisher.test",
#     # use 3 digits in pvalue
#     pvalue_fun = function(x) style_pvalue(x, digits = 3),
#   ) %>%
#   # # diff: alternative to add_p
#   #   add_difference(
#   #     test = all_categorical() ~ "fisher.test",
#   #     # use 3 digits in pvalue
#   #     pvalue_fun = function(x) style_pvalue(x, digits = 3),
#   #     # ANCOVA
#   #     # adj.vars = c(sex, age, bmi),
#   #   ) %>%
#   # # EN
#   # modify_footnote(update = c(estimate, ci, p.value) ~ "ANCOVA (adjusted by sex, age and BMI)") %>%
#   # # PT
#   # modify_header(estimate ~ '**Diferença ajustada**') %>%
#   # modify_footnote(update = c(estimate, ci, p.value) ~ "ANCOVA (ajustada por sexo, idade e IMC)") %>%
#   # bold significant p values
#   bold_p()

# Template Cohen's D table (obs: does NOT compute p)
# tab_inf <- analytical %>%
#   # select
#   select(
#     -id,
#   ) %>%
#   tbl_summary(
#     by = group,
#   ) %>%
#   add_difference(
#     test = all_continuous() ~ "cohens_d",
#     # ANCOVA
#     adj.vars = c(sex, age, bmi),
#   ) %>%
#   modify_header(estimate ~ '**d**') %>%
#   bold_labels()
