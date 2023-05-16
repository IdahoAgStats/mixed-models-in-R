
library(hexSticker)

imgurl <- magick::image_read("img/logo.PNG")

sticker(imgurl, package= "", p_size=20, s_x=1, s_y=1, s_width= 1.5, s_height = 1.5, 
        h_color = "gray25", h_fill = "#fcfaf6", h_size = 1, u_color = "gray25", asp = 1, p_color = "gray25",
        filename="img/hexLogo.png")
