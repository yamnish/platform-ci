# platform-ci

Shared CI infrastructure: linter Docker images and reusable GitHub Actions composite actions.

## Linters

| Linter | Что проверяет | Файлы |
|--------|---------------|-------|
| [shellcheck](#shellcheck) | Синтаксис и баги в shell-скриптах | `*.sh` |
| [hadolint](#hadolint) | Лучшие практики написания Dockerfile | `Dockerfile`, `Dockerfile.*` |
| [yamllint](#yamllint) | Синтаксис и стиль YAML | `*.yml`, `*.yaml` |
| [json](#json) | Валидность JSON | `*.json` |
| [markdownlint](#markdownlint) | Стиль и структура Markdown | `*.md` |
| [gitleaks](#gitleaks) | Утечки секретов в истории git | весь репозиторий |
| [dotenv](#dotenv) | Синтаксис `.env.example` файлов | `*.env.example`, `.env.example` |

---

## Как подключить линтеры к репозиторию

Добавь файл `.github/workflows/ci.yml` в свой репозиторий:

```yaml
name: CI

on:
  push:
  pull_request:

jobs:
  lint-shellcheck:
    runs-on: [self-hosted, linux, x64]
    steps:
      - uses: actions/checkout@v4
      - uses: yamnish/platform-ci/.github/actions/lint-shellcheck@main

  lint-hadolint:
    runs-on: [self-hosted, linux, x64]
    steps:
      - uses: actions/checkout@v4
      - uses: yamnish/platform-ci/.github/actions/lint-hadolint@main

  lint-yamllint:
    runs-on: [self-hosted, linux, x64]
    steps:
      - uses: actions/checkout@v4
      - uses: yamnish/platform-ci/.github/actions/lint-yamllint@main

  lint-json:
    runs-on: [self-hosted, linux, x64]
    steps:
      - uses: actions/checkout@v4
      - uses: yamnish/platform-ci/.github/actions/lint-json@main

  lint-markdown:
    runs-on: [self-hosted, linux, x64]
    steps:
      - uses: actions/checkout@v4
      - uses: yamnish/platform-ci/.github/actions/lint-markdown@main

  lint-gitleaks:
    runs-on: [self-hosted, linux, x64]
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0        # обязательно для gitleaks — нужна полная история
      - uses: yamnish/platform-ci/.github/actions/lint-gitleaks@main

  lint-dotenv:
    runs-on: [self-hosted, linux, x64]
    steps:
      - uses: actions/checkout@v4
      - uses: yamnish/platform-ci/.github/actions/lint-dotenv@main
```

Можно подключить только нужные линтеры — каждый job независим.

> Линтеры запускаются внутри Docker-образов, собранных в этом репозитории. Перед первым использованием в новом репозитории убедись, что образы уже собраны (`linter-shellcheck:latest` и т.д. присутствуют на runner'е).

---

## Описание линтеров

### shellcheck

Статический анализатор для bash/sh скриптов. Находит синтаксические ошибки, неправильное использование кавычек, неэкранированные переменные и другие типичные баги.

Проверяет все файлы `*.sh` в репозитории (кроме `.git/`).

```yaml
- uses: yamnish/platform-ci/.github/actions/lint-shellcheck@main
```

---

### hadolint

Линтер для Dockerfile. Проверяет соответствие лучшим практикам: использование `COPY` вместо `ADD`, закрепление версий пакетов, правильный порядок слоёв, отсутствие `sudo` и т.д.

Проверяет все файлы с именем `Dockerfile` или `Dockerfile.*` в репозитории.

```yaml
- uses: yamnish/platform-ci/.github/actions/lint-hadolint@main
```

---

### yamllint

Линтер для YAML файлов. Проверяет синтаксис, отступы, лишние пробелы, дублирующиеся ключи.

Настройки (применяются ко всем репозиториям):
- Максимальная длина строки: 200 символов
- Допустимые булевы значения: `true`, `false`, `on`, `off`
- Комментарии: минимум 1 пробел от содержимого

```yaml
- uses: yamnish/platform-ci/.github/actions/lint-yamllint@main
```

---

### json

Проверяет, что все `.json` файлы валидны (парсятся без ошибок). Использует `jq`.

```yaml
- uses: yamnish/platform-ci/.github/actions/lint-json@main
```

---

### markdownlint

Линтер для Markdown файлов. Проверяет стиль и структуру: заголовки, списки, пустые строки, ссылки.

Отключённые правила (слишком строгие для обычного использования):
- `MD013` — ограничение длины строки
- `MD033` — запрет inline HTML
- `MD034` — голые URL
- `MD041` — первый заголовок должен быть H1

```yaml
- uses: yamnish/platform-ci/.github/actions/lint-markdown@main
```

---

### gitleaks

Сканирует **всю историю git** на предмет утечек секретов: API-ключи, токены, пароли, приватные ключи и т.д.

Требует полную историю коммитов — обязательно указывай `fetch-depth: 0`:

```yaml
- uses: actions/checkout@v4
  with:
    fetch-depth: 0
- uses: yamnish/platform-ci/.github/actions/lint-gitleaks@main
```

---

### dotenv

Проверяет синтаксис `.env.example` файлов: правильный формат `KEY=VALUE`, отсутствие реальных секретов (по формату), корректные имена ключей.

Проверяет файлы с именами `*.env.example` и `.env.example`.

```yaml
- uses: yamnish/platform-ci/.github/actions/lint-dotenv@main
```

---

## Сборка образов

Образы собираются автоматически в этом репозитории при изменении файлов в `linters/**`. Каждый линтер собирается в отдельном job'е параллельно.

Запустить сборку вручную: Actions → **Build linter images** → Run workflow.

Каждый образ:

| Образ | Registry | Базовый образ |
|-------|----------|---------------|
| `linter-shellcheck` | `ghcr.io/yamnish/linter-shellcheck:latest` | `koalaman/shellcheck-alpine:stable` |
| `linter-hadolint` | `ghcr.io/yamnish/linter-hadolint:latest` | `hadolint/hadolint:v2.12.0-alpine` |
| `linter-yamllint` | `ghcr.io/yamnish/linter-yamllint:latest` | `python:3-alpine` |
| `linter-jq` | `ghcr.io/yamnish/linter-jq:latest` | `alpine:3.19` |
| `linter-markdownlint` | `ghcr.io/yamnish/linter-markdownlint:latest` | `node:lts-alpine` |
| `linter-gitleaks` | `ghcr.io/yamnish/linter-gitleaks:latest` | `alpine:3.19` |
| `linter-dotenv` | `ghcr.io/yamnish/linter-dotenv:latest` | `alpine:3.19` |
