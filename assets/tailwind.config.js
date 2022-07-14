const defaultTheme = require('tailwindcss/defaultTheme');

module.exports = {
  content: ['./js/**/*.js', '../lib/*_web/**/*.*ex'],
  theme: {
    extend: {
      colors: {
        close: '#FF5F57',
        minimize: '#FEBC2F',
        maximize: '#28C840',
        benvp: {
          green: '#00FFBF',
          purple: '#8710EB',
          red: '#FC6969',
          text: '#F2F2F2',
        },
      },
      fontFamily: (t) => ({
        mono: ['Fira Code', ...defaultTheme.fontFamily.mono],
        prose: ['Lato', ...defaultTheme.fontFamily.sans],
        title: ['Titillium Web', ...defaultTheme.fontFamily.sans],
      }),
      typography: ({ theme }) => ({
        DEFAULT: {
          css: {
            code: {
              color: '#b485d5',
              background: '#0f131a',
              margin: `0 ${theme('spacing')[0.5]}`,
              padding: `${theme('spacing')[0.5]} ${theme('spacing.1')}`,
              borderRadius: defaultTheme.borderRadius.DEFAULT,
              wordBreak: 'break-word',
              fontWeight: theme('fontWeight.normal'),
            },
            'code::before': {
              content: 'none',
            },
            'code::after': {
              content: 'none',
            },
          },
        },
        invert: {
          css: {
            '--tw-prose-invert-pre-bg': 'rgb(31 41 55 / 50%)',
          },
        },
      }),
    },
  },
  plugins: [require('@tailwindcss/forms'), require('@tailwindcss/typography')],
};
