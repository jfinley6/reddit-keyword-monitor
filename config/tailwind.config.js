const defaultTheme = require("tailwindcss/defaultTheme");

module.exports = {
    content: [
        "./public/*.html",
        "./app/helpers/**/*.rb",
        "./app/javascript/**/*.js",
        "./app/views/**/*.{erb,haml,html,slim}",
        "./app/components/**/*.{erb,html}",
        "./node_modules/flowbite/**/*.js",
    ],
    plugins: [
        require("@tailwindcss/forms"),
        require("@tailwindcss/aspect-ratio"),
        require("@tailwindcss/typography"),
        require("flowbite/plugin"),
    ],
};
