# docker_captchaAPI

Docker Captcha Edge is a project built for secondary captcha verification API integration using Docker and OpenResty.

## Features

- Deploy using Docker for simplified environment setup.
- Perform captcha secondary verification through API integration.
- Support user-defined domain configuration.
- Configure bucketList timeout duration and whether to log verification activities.

## Usage

1. Set your domain within the `/data/site` directory and configure it in the `domain.conf` file.
2. In the `domain.conf` file, you can set the bucketList timeout duration and specify whether to log verification activities.

## Deploying the Project

1. Clone the project locally:

   ```bash
   git clone [project repository URL]
   cd docker_captchaAPI
   ```

2. Place your domain configuration file (e.g., `domain.conf`) in the `/data/site` directory.

3. Launch the project using Docker Compose:

   ```bash
   docker-compose up -d
   ```

## Configuration Details

In the `docker-compose.yml` file's `environment` section, you can configure the following environment variables:

- `nginxPath`: Path to OpenResty.
- `captchaKey`: Captcha Key for API validation.
- `captchaId`: Captcha ID for API validation.
- `captchaUrl_html`: URL for Captcha HTML file.
- `captchaUrl_verify`: URL for Captcha verification API.
- `captchaUrl_status`: URL for Captcha status API.

## Reloading Configuration

If you've modified the OpenResty configuration and want the changes to take effect, you can execute the following command to reload OpenResty:

```bash
docker exec -ti openresty_captcha openresty -s reload
```

This will reload the OpenResty configuration and apply your changes.

