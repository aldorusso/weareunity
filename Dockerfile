FROM node:18-alpine AS build

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY . .
RUN npm run build

FROM node:18-alpine AS runtime

WORKDIR /app

COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules
COPY --from=build /app/package.json ./package.json

EXPOSE 3000

ENV HOST=0.0.0.0
ENV PORT=3000

CMD ["npm", "run", "preview", "--", "--host", "0.0.0.0", "--port", "3000"]