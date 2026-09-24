# Dockerfile del repositorio base.
# Contiene cinco malas practicas deliberadas. Cada una lleva su numero en la
# linea anterior. Corregirlas es el bloque A1 de la guia del laboratorio.

# defecto 1 - OK
FROM public.ecr.aws/lambda/nodejs:20.2024.03.15.12 AS build

WORKDIR /app

# defecto 2 - OK
COPY package.json package-lock.json ./

# defecto 3 - OK
RUN npm ci

COPY src ./src

RUN npm run build && npm prune --omit=dev

# defecto 4 - OK
FROM public.ecr.aws/lambda/nodejs:20.2024.03.15.12 AS runtime

ENV DB_PASSWORD=db_password

WORKDIR /app

COPY --from=build /app/dist ./dist
COPY --from=build /app/node_modules ./node_modules

USER node

# defecto 5 - OK

CMD ["src/handler.handler"]
