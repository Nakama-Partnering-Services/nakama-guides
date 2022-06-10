These are the configurable rules that we follow in our [.prettierrc](https://github.com/Nakama-Partnering-Services/nakama-project-scaffolding/blob/main/.prettierrc) file:

-   trailingComma: ‘none’ (Required for Aura)

-   singleQuote: true (Preferable when writing HTML is needed in a Javascript file)

-   bracketSameLine: true (Solves previous awful formatting of HTML files)

-   endOfLine: "lf" (Default, as used by Unix based OS)

-   printWidth: 120 (We know, it is not aligned with commonly used guidelines in companies like google, where this value is 80, but we think it makes reading the code easier)

-   tabWidth: 4 (We know again, it is not aligned with commonly used guidelines in companies like google, where this value is 2, but we think it makes reading the code easier)

-   useTabs: true (Once again, we know it is not aligned with commonly used guidelines in companies like google, where they use spaces, but we think tabs make our lives easier, as explained [here](https://softwareengineering.stackexchange.com/a/72))

-   apexInsertFinalNewline: true (Default. It is also [enforced by prettier](https://unix.stackexchange.com/questions/18743/whats-the-point-in-adding-a-new-line-to-the-end-of-a-file) for non Apex files, since it has no option to change it. Unfortunately, Salesforce removes them when retrieving files, being unaligned with prettier, so for the time being we do not care about what Salesforce does, giving preference to prettier, and we hope that Salesforce changes this in the future in order to be aligned with prettier configurations)
