FROM ghcr.io/cirruslabs/flutter:3.35.4 AS build
WORKDIR /app

COPY ./ ./ 
RUN flutter pub get
RUN flutter build web --release
FROM nginx:alpine AS runtime
RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
