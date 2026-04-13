# Stage 1: Build Flutter web (WASM)
FROM ghcr.io/cirruslabs/flutter:stable AS build
WORKDIR /app
COPY . .
RUN flutter pub get
RUN flutter build web --wasm --release --pwa-strategy offline-first --tree-shake-icons

# Stage 2: Pre-compress static assets with Brotli + Gzip
FROM alpine:latest AS compress
RUN apk add --no-cache brotli gzip findutils
COPY --from=build /app/build/web /web
RUN find /web -type f \( -name "*.js" -o -name "*.css" -o -name "*.html" -o -name "*.json" -o -name "*.wasm" -o -name "*.svg" \) \
    -exec brotli -q 11 --keep {} \; \
    -exec gzip -9 --keep {} \;

# Stage 3: Serve with Nginx
FROM nginx:alpine
COPY --from=compress /web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]
