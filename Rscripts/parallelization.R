require(ggplot2)


x <- c(1, 2, 3, 4, 5, 6, 7, 8)
y <- c(2358, 1486, 1112, 923, 900, 870, 793, 777)
d <- data.frame(x=x, y=y)

plot(x, y, type='line')

ggplot(d, aes(X, Y)) +
  geom_point(size=3) +
  geom_line(size=1)

i = c(2, 3, 4, 5, 6, 7, 8)
plot(y[i]/y[1])

e <- 1/exp(x)
d2 <- data.frame(x=x, y=e)
plot(e)

plot(x, y)
mod <- nls(y ~ 1/exp(a + b * x), data = d2, start = list(a = 0, b = 0))
lines(d$x, predict(mod, list(x=d$x)))

# generate data
beta <- 0.05
n <- 100
temp <- data.frame(y = exp(beta * seq(n)) + rnorm(n), x = seq(n))

# plot data
plot(temp$x, temp$y)

# fit non-linear model
mod <- nls(y ~ exp(a + b * x), data = temp, start = list(a = 0, b = 0))

# add fitted curve
lines(temp$x, predict(mod, list(x = temp$x)))