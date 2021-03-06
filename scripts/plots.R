# setup -------------------------------------------------------------------
# library(survminer)

ff.col <- "steelblue" # good for single groups scale fill/color brewer
ff.pal <- "Paired"    # good for binary groups scale fill/color brewer

scale_color_discrete <- function(...) scale_color_brewer(palette = ff.pal, ...)
scale_fill_discrete <- function(...) scale_fill_brewer(palette = ff.pal, ...)

gg <- analytical_long %>%
  filter(!str_detect(name, "PERDA")) %>%
  ggplot() +
  theme_ff()

# plots -------------------------------------------------------------------

gg.outcome <- gg +
  geom_line(aes(time, value, group = id), col = ff.col) +
  facet_wrap(~ name, scales = "free") +
  labs(caption = paste("N =", Nobs_final)) +
  xlab(attr(analytical_long$time, "label")) +
  ylab("")

gg_perda <- analytical_long %>%
  filter(str_detect(name, "PERDA")) %>%
  ggplot() +
  geom_line(aes(time, value, group = id), col = ff.col, alpha = .7) +
  facet_wrap(~ name, scales = "free") +
  labs(caption = paste("N =", Nobs_final)) +
  xlab(attr(analytical_long$time, "label")) +
  ylab("") +
  theme_ff()

gg_age <- epi %>%
  ggplot(aes(idade, fill = sexo)) +
  geom_density(alpha = .9) +
  labs(fill = NULL) +
  xlab(attr(epi$idade, "label")) +
  ylab("") +
  theme_ff()

# cool facet trick from https://stackoverflow.com/questions/3695497 by JWilliman
# gg +
#   geom_histogram(bins = 5, aes(outcome, y = ..count../tapply(..count.., ..PANEL.., sum)[..PANEL..]), fill = ff.col) +
#   scale_y_continuous(labels = scales::label_percent(accuracy = 1)) +
#   xlab(attr(analytical$outcome, "label")) +
#   ylab("") +
#   facet_wrap(~ group, ncol = 2)
