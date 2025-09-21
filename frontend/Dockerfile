# Stage 1: Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:3.35.4 AS build
WORKDIR /app

# copy all content ของ frontend เข้า container
COPY ./ ./ 

# ติดตั้ง dependencies และ build web
RUN flutter pub get
RUN flutter build web --release

# Stage 2: Serve ด้วย nginx
FROM nginx:alpine AS runtime
RUN rm -rf /usr/share/nginx/html/*

# copy จาก stage build
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
