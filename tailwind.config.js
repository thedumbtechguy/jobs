const { execSync } = require('child_process');
const plutoniumGemPath = execSync("bundle show plutonium").toString().trim();
const plutoniumTailwindConfig = require(`${plutoniumGemPath}/tailwind.options.js`)
const tailwindPlugin = require('tailwindcss/plugin')

module.exports = {
  darkMode: plutoniumTailwindConfig.darkMode,
  plugins: [
    // add plugins here
  ].concat(plutoniumTailwindConfig.plugins.map(function (plugin) {
    switch (typeof plugin) {
      case "function":
        return tailwindPlugin(plugin)
      case "string":
        return require(plugin)
      default:
        throw Error(`unsupported plugin: ${plugin}: ${(typeof plugin)}`)
    }
  })),
  theme: plutoniumTailwindConfig.merge(
    plutoniumTailwindConfig.theme,
    {
      // Brand: indigo primary. Keys must cover 50-950, like Plutonium's palette.
      extend: {
        colors: {
          primary: {
            50: '#EEF2FF',
            100: '#E0E7FF',
            200: '#C7D2FE',
            300: '#A5B4FC',
            400: '#818CF8',
            500: '#6366F1',
            600: '#4F46E5',
            700: '#4338CA',
            800: '#3730A3',
            900: '#312E81',
            950: '#1E1B4B',
          },
        },
      },
    },
  ),
  content: [
    `${__dirname}/app/**/*.{erb,haml,html,slim,rb}`,
    `${__dirname}/app/javascript/**/*.js`,
    `${__dirname}/packages/**/app/**/*.{erb,haml,html,slim,rb}`,
  ].concat(plutoniumTailwindConfig.content),
}
