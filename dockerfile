FROM hshar/webapp
WORKDIR /var/www/html
COPY  index.html images/ /var/www/html/
EXPOSE 80 
