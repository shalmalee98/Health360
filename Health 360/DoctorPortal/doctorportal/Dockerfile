# Multi-stage build for building the application
FROM node:18-alpine AS builder

WORKDIR /app

COPY package.json .

RUN npm install --legacy-peer-deps

RUN rm -rf node_modules/.vite

RUN npm cache clean --force

RUN npm install --legacy-peer-deps

COPY . .

RUN npx vite build

# Final image for running the application
FROM node:18-alpine

WORKDIR /app

COPY --from=builder /app/dist /app

EXPOSE 3001

CMD ["npx", "serve", "--single", "--listen", "3001", "."]
