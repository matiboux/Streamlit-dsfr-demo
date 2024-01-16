#syntax=docker/dockerfile:1.4

# This Dockerfile uses the root folder as context.


# --
# Upstream images

FROM python:3.11-slim AS python_upstream


# --
# Python Prod image

FROM python_upstream AS app_prod

ENV APP_ENV=prod

# Create app directory
WORKDIR /app

# Copy source code
COPY --link . .

# Install dependencies
RUN pip install --no-cache-dir -r requirements.txt && \
	# Clean up
	pip cache purge

# Create user 'user' and group 'app'
RUN groupadd -r app && \
	useradd -lr -G app -d /app user && \
	chown -R user:app /app
USER user

# Set exposed port
ARG PORT=80
ENV PORT=${PORT}

# Expose port
EXPOSE ${PORT}

CMD [ "sh", "-c", "streamlit run app.py --server.port ${PORT}" ]
