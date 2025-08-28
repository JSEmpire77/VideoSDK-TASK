# Stage 1: Build environment & install dependency
FROM node:18-alpine AS build

WORKDIR /app

# Copy package.json first for dependency
COPY package.json .

RUN npm install

# Copy the application code
COPY . .

# Stage 2: final stage
FROM node:18-alpine

WORKDIR /app

# Copy only the necessary files from the builder stage
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/index.js ./index.js

# Expose the application port
EXPOSE 8080

CMD ["node", "index.js"]


