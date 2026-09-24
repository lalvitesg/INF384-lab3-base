# ETAPA 1: Construcción (Build)
FROM public.ecr.aws/lambda/nodejs:20 AS build

WORKDIR /app

# 1. Manifiesto y lock file copiados antes del código
COPY package.json package-lock.json ./

# 2. Instalación desde el lock file
RUN npm ci

# Copiamos el código fuente
COPY src ./src

# Construimos la aplicación (empaqueta todo en dist/)
RUN npm run build

# ---------------------------------------------------------
# ETAPA 2: Runtime (Etapa Final)
FROM public.ecr.aws/lambda/nodejs:20 AS runtime

# Usamos la ruta nativa de AWS Lambda
WORKDIR ${LAMBDA_TASK_ROOT}

# 3. SIN valores de credencial declarados (se eliminó ENV DB_PASSWORD)

# 4. Únicamente el artefacto empaquetado pasa a la etapa final (NO node_modules)
COPY --from=build /app/dist/ ./

# 5. SIN gestores de sistema ni herramientas extra

# Ejecutamos el handler desde la raíz (ya que copiamos el contenido de dist/)
CMD ["handler.handler"]