FROM node:22-slim

ENV NODE_ENV=production
WORKDIR /app

# Install production dependencies only (style.css is committed, so no build step)
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Application source
COPY server.js add-admin.js compress-uploads.js ./
COPY public ./public

# Runtime writes uploads/, database.sqlite and .session-secret into /app —
# mount volumes on these paths to persist data across container restarts.
RUN mkdir -p uploads/thumbs && chown -R node:node /app
USER node

EXPOSE 3000
CMD ["node", "server.js"]
