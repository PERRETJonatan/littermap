FROM node:22-slim

ENV NODE_ENV=production
WORKDIR /app

# Install production dependencies only (style.css is committed, so no build step)
COPY package.json package-lock.json ./
RUN npm ci --omit=dev && npm cache clean --force

# Application source
COPY server.js add-admin.js compress-uploads.js ./
COPY public ./public

# Runtime writes uploads/, database.sqlite and .session-secret under
# DATA_DIR — mount a single volume there to persist everything across
# restarts. Defaults to /app when DATA_DIR is unset.
ENV DATA_DIR=/data
RUN mkdir -p /data/uploads/thumbs && chown -R node:node /app /data
USER node

EXPOSE 3000
CMD ["node", "server.js"]
