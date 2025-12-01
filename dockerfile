FROM hshar/webapp
WORKDIR /var/www/html
COPY  index.html images/ .
EXPOSE 80 
