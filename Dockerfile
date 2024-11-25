# Use the official Node.js image as the base
FROM node:18 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy package.json and package-lock.json to install dependencies first
COPY package*.json ./

# Install the Angular CLI globally and install app dependencies
RUN npm install -g @angular/cli
RUN npm install --legacy-peer-deps

# Copy the rest of the application code
COPY . .

# Build the Angular project for production
RUN ng build --configuration production

# Use a smaller web server image to serve the built Angular app
FROM nginx:alpine

# Copy the built Angular app to the Nginx web server directory
COPY --from=build /app/dist /usr/share/nginx/html

# Expose port 80 for the Nginx server
EXPOSE 80

# Start Nginx to serve the app
CMD ["nginx", "-g", "daemon off;"]
