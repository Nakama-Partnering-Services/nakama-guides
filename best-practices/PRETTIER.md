These are the configurable rules that we follow in our [.prettierrc](https://github.com/Nakama-Partnering-Services/project-scaffolding/blob/main/.prettierrc) file:

-   trailingComma: ‘none’ (required for Aura)

-   singleQuote: true (preferable when writing HTML is needed in a Javascript file)

-   bracketSameLine: true (solves previous awful formatting of HTML files)

-   endOfLine: "lf" (default, as used by Unix based OS)

-   printWidth: 120 (we know, it is not aligned with commonly used guidelines in companies like google, where this value is 80, but we think it makes reading the code easier)

-   tabWidth: 4 (we know again, it is not aligned with commonly used guidelines in companies like google, where this value is 2, but we think it makes reading the code easier)

-   useTabs: true (once more, we know it is not aligned with commonly used guidelines in companies like google, where they use spaces, but we think tabs make our lives easier, as explained [here](https://softwareengineering.stackexchange.com/a/72))

-   apexInsertFinalNewline: true (default, also [enforced by prettier](https://unix.stackexchange.com/questions/18743/whats-the-point-in-adding-a-new-line-to-the-end-of-a-file) for non Apex files, since it has no option to change it)
