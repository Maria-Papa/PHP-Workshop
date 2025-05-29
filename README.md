# PHP-Workshop
Welcome to this hands-on workshop! This project is designed to help experienced PHP backend developers like yourself sharpen your skills and prepare for technical interviews by building a real-world Laravel application using Docker.


## Table Of Contents
- [✅ Prerequisites](#-prerequisites)
- [⚠️ AI Assistance Disclaimer](#️-ai-assistance-disclaimer)
- [🏗️ Workshop Structure: Master vs. Solution](#️-workshop-structure-master-vs-solution)
- [🚀 Getting Started (Your Workshop Journey)](#-getting-started-your-workshop-journey)
    - [1. Clone the Repository](#1-clone-the-repository)
    - [2. Copy Environment Configuration](#2-copy-environment-configuration)
    - [3. Start the Docker Compose Services](#3-start-the-docker-compose-services)
    - [4. Laravel Setup](#4-laravel-setup)
    - [5. View the App](#5-view-the-app)
- [🧑‍💻 Continuing the Workshop](#-continuing-the-workshop)
    - [🧪 Useful Commands](#-useful-commands)
        - [🛠️ Makefile Commands](#️-makefile-commands)
        - [🐳 Docker Compose Equivalents](#-docker-compose-equivalents)
    - [✅ Switching to the Solution Branch](#-switching-to-the-solution-branch)
- [👏 Good Luck](#-good-luck)



## ✅ Prerequisites
Make sure you have the following installed:
- **Docker Desktop**: [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- **WSL2:** [Windows Subsystem for Linux 2 (WSL2)](https://learn.microsoft.com/en-us/windows/wsl/install) (required for Windows users)
- **Make** (optional, but highly recommended):
    ```bash
    sudo apt update && sudo apt install -y make
    ```


## ⚠️ AI Assistance Disclaimer
This project was created collaboratively with the help of AI assistants like ChatGPT and Google Gemini.

AI assistance was used for:
- Structuring this README
- Designing Docker, Nginx, PostgreSQL, Redis, MongoDB integration
- Building the Makefile for convenience
- Scoping workshop exercises around backend interview prep (SOLID, design patterns, testing, services)

The technical vision and goals are shaped by the author's experience and preparation needs.


## 🏗️ Workshop Structure: Master vs. Solution
- **`master` branch** — Your starting point. Minimal but complete Laravel setup using Docker. Build everything step-by-step.
- **`solution` branch** — A complete implementation. Use it to compare, debug, or get unstuck.


## 🚀 Getting Started (Your Workshop Journey)
Follow these steps to set up your workshop environment and start coding:

### 1. Clone the Repository
```bash
git clone https://github.com/Maria-Papa/PHP-Workshop.git
cd PHP-Workshop
```

### 2. Copy Environment Configuration
Copy the example environment file so Docker and Laravel have the necessary environment variables:
```bash
cp .env.docker.example .env.docker
```
Set the env variables `UID` and `GID`.

### 3. Start the Docker Compose Services
This command will build the PHP-FPM image (including necessary extensions and Composer), then start all services: Nginx, PHP-FPM, PostgreSQL, MongoDB, and Redis.

> **Note:** Run the `make` commands from the **project root directory**.  
> Run the `docker-compose` commands from the **`docker/` directory**.

```bash
make start
# or
docker-compose up --build -d
```

> The first time you run this, it may take several minutes while Docker downloads base images and builds your containers.

### 4. Laravel Setup
Generate the application key:

> **Note:** Run the `make` commands from the **project root directory**.  
> Run the `docker-compose` commands from the **`docker/` directory**.

```bash
make keygen
# or
docker-compose exec app php artisan key:generate
```
Run migrations:
```bash
make migrate
# or
docker-compose exec app php artisan migrate --force
```

### 5. View the App
Open your browser:
```
http://localhost
```
You should see the default Laravel welcome page!


## 🧑‍💻 Continuing the Workshop
You're all set to start the hands-on workshop exercises!

The workshop is structured into **phases**, each located in the [`workshop_docs/`](./workshop_docs/) folder. These Markdown files (`phase_0.md`, `phase_1.md`, etc.) will guide you through implementing features step-by-step using real backend concepts.

Each phase includes:
- Clear learning objectives.
- Practical tasks to perform in your Laravel codebase.
- Optional challenges and reflections.

> 💡 **Tip:** As you complete each phase, follow the navigation links at the bottom of each file to move to the next phase.

Once you’ve read the instructions in a phase, go back to your Laravel project and implement the tasks described.

> 🔁 **Remember:** Commit your changes regularly to your `master` branch to keep track of your progress and ensure you don’t lose work.


### ✅ Switching to the Solution Branch
To see a fully implemented example:
```bash
git checkout solution
```
When switching branches, you may need to re-install dependencies:
```bash
docker-compose exec app composer install
docker-compose exec app npm install
```


### 🧪 Useful Commands

> **Note:** Run the `make` commands from the **project root directory**.  
> Run the `docker-compose` commands from the **`docker/` directory**.

#### 🛠️ Makefile Commands
| Command                 | Description                            |
| ----------------------- | -------------------------------------- |
| `make start`            | Start containers with build            |
| `make stop`             | Stop all containers                    |
| `make down`             | Stop and remove containers and volumes |
| `make restart`          | Restart the application containers     |
| `make keygen`           | Generate Laravel app key               |
| `make migrate`          | Run Laravel migrations                 |
| `make fresh`            | Drop all tables and re-run migrations  |
| `make seed`             | Seed the database                      |
| `make composer-install` | Install PHP dependencies               |
| `make npm-install`      | Install Node dependencies              |
| `make npm-dev`          | Run Laravel Mix in dev mode            |
| `make npm-build`        | Compile frontend for production        |
| `make logs`             | Tail Laravel container logs            |

#### 🐳 Docker Compose Equivalents
| Task                      | Docker Compose Command                                                                  |
| ------------------------- | --------------------------------------------------------------------------------------- |
| Start containers          | `docker-compose up -d --build`                             |
| Stop containers           | `docker-compose stop`                                      |
| Remove containers/volumes | `docker-compose down -v`                                   |
| Exec into app             | `docker-compose exec app bash`                             |
| Artisan migrate           | `docker-compose exec app php artisan migrate`              |
| Artisan fresh migrate     | `docker-compose exec app php artisan migrate:fresh --seed` |
| Composer install          | `docker-compose exec app composer install`                 |
| Generate app key          | `docker-compose exec app php artisan key:generate`         |
| NPM install               | `docker-compose exec app npm install`                      |
| NPM dev build             | `docker-compose exec app npm run dev`                      |
| NPM production build      | `docker-compose exec app npm run build`                    |
| View logs                 | `docker-compose logs -f app`                               |


## 👏 Good Luck
You’re all set to begin your Laravel workshop. Dive in, explore, break things, and build them back stronger.

Happy coding!
