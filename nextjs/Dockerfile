# escape=`
FROM node:18-alpine AS base

FROM base as deps
RUN apk add --no-cache libc6-compat
WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

FROM base as runner
WORKDIR /app

RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

COPY --from=deps --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --chown=nextjs:nodejs . .
RUN chown nextjs:nodejs /app

USER nextjs

EXPOSE 3000
ENTRYPOINT ["npm", "run", "dev"]