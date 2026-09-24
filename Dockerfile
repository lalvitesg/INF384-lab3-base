# ETAPA 1: Construcción (Build)
FROM public.ecr.aws/lambda/nodejs:20 AS build

WORKDIR /build

# Manifiesto y lock file copiados e instalados antes del código
COPY package.json package-lock.json ./
RUN npm ci

# Copiamos el código de la aplicación
COPY src ./src

### NO TOCAR DE ACA EN ADELANTE, CONSIDEREN QUE EL WORKDIR DEBE SER /build
RUN npx esbuild src/handler.js \
      --bundle --platform=node --target=node20 \
      --outfile=dist/handler.js

# Etapa final: recibe unicamente el artefacto empaquetado.
# El arbol de node_modules se queda en la etapa anterior.
FROM public.ecr.aws/lambda/nodejs:20 AS runtime
COPY --from=build /build/dist/handler.js ${LAMBDA_TASK_ROOT}/
CMD ["handler.handler"]