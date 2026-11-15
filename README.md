# TempleVerse

TempleVerse is a temple discovery platform that helps users explore temples, learn about their history, and discover important cultural and religious information.

## Features

- Search and explore temples.
- View individual temple details.
- Explore temple information and heritage.
- Multilingual translation support:
  - English
  - Hindi
  - Telugu
  - Tamil
  - Malayalam
- Supabase database integration.
- Responsive user interface.

## Technologies Used

- React
- Vite
- JavaScript
- Tailwind CSS
- Supabase

## Prerequisites

Install the following before running the project:

- Node.js
- npm
- Git (optional)

## Installation

1. Clone or download the project.
2. Open the project folder in VS Code.
3. Open the terminal.
4. Install dependencies:

```bash
npm install
```

## Environment Configuration

Create a file named `.env.local` in the project root.

Add your Supabase configuration:

```env
VITE_SUPABASE_URL=your_supabase_project_url
VITE_SUPABASE_ANON_KEY=your_supabase_publishable_or_anon_key
```

Do not share your `.env.local` file or commit it to GitHub.

## Run the Project

Start the development server:

```bash
npm run dev
```

Open the local URL displayed in the terminal.

## Database

TempleVerse uses Supabase for database services.

Make sure the required database tables, policies, and other backend configurations are available in your Supabase project.

## Project Structure

```text
TempleVerse/
├── public/
├── src/
│   ├── components/
│   ├── pages/
│   ├── services/
│   └── lib/
├── supabase/
├── index.html
├── package.json
├── vite.config.js
└── README.md
```

## Contributors

M.Kesava
Aniket Gupta
P.Harshitha
H.Amrutha
murali(No contribution)

## License

Add your project's license information here.
