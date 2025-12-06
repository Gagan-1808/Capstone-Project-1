FROM hshar/webapp
WORKDIR /var/www/html
COPY  index.html images/ /var/www/html/
COPY  images/ /var/www/html/images/
EXPOSE 80 
