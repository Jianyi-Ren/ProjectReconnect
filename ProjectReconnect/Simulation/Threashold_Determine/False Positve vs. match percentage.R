x = 100:94
y = dbinom(as.integer(384*x/100),size = 384, prob = 0.8975)*100000
plot(x,y,type = 'l',xlab = "Persentage Threshold for Positive Match ",ylab = "False Positive for 100,000 samples")
text(x, y, round(y, 5), cex=1)
title("False Positive vs. match persentage")
