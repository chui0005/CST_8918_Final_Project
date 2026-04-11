# Remix Weather App

This repo is now focused on running the application without pulumi.

## Requirements

- Node.js 18+
- An OpenWeather API key

## Local setup

1. Install dependencies:

```sh
npm install
```

2. Create a local environment file:

```sh
cp .env.example .env
```

3. Add your OpenWeather API key to `.env`:

```env
WEATHER_API_KEY=your_openweather_api_key
```

4. Start the Remix dev server:

```sh
npm run dev
```

5. Open the app in your browser:

```text
http://localhost:3000
```

## Available scripts

- `npm run dev` - start the local dev server
- `npm run build` - build the app for production
- `npm run start` - run the production build locally
- `npm run lint` - run ESLint
- `npm run typecheck` - run TypeScript checks

## Docker

If you want to run the app with Docker locally:

```sh
docker build -t remix-weather .
docker run --rm -p 3000:3000 --env-file .env remix-weather
```

The container expects the same `WEATHER_API_KEY` environment variable.
