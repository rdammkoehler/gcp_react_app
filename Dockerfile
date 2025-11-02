# Stage 1: Build the React app
FROM node:latest as vite-build
WORKDIR /app
COPY package*.json ./
RUN yarn
COPY . .
RUN yarn build

# Stage 2: Serve the app using Nginx
FROM nginx:alpine
COPY nginx.conf /etc/nginx/conf.d/configfile.template
COPY --from=vite-build /app/dist /usr/share/nginx/html
ENV PORT 8080
EXPOSE 8080
CMD sh -c "envsubst '\$PORT' < /etc/nginx/conf.d/configfile.template > /etc/nginx/conf.d/default.conf && nginx -g 'daemon off;'"

