# md-to-html

A parser with PEG.js. (souce file : `lib/rule.pegjs`)

input: Markdown, output: HTML

## Usage

Download files and execute this command:

```
npm install
npm run test
```

and access http://localhost:3000 .

The markdown file used in this test is `test/test.md` .

## Spec

**md-to-html** can parse this elements:

- \*Italic\*

  `<i>Italic\</i>`

- \*\*Bold\*\*

  `<b>Bold</b>`

- \# Heading

  `<h1>Heading</h1>`

- \#\# Heading

  `<h2>Heading</h2>`

- \[Link\]\(http://a.com\)

  `<a href="http://a.com">Link</h1>`

- http://a.com

  `<a href="http://a.com">http://a.com</h1>`

- \!\[Image](http://url/a.png)

  `<img alt="Image" src="http://url/a.png"/>`

- \>Blockquote

  `<blockquote>Blockquote</blockquote>`

- \- List

  `<ul><li>List</li></ul>`

  (List can be nested.)

- 1\. List

  `<ol><li>List</li></ol>`

  (List can be nested.)

- \---

  `<hr/>`

- \`Inline code`

  `<code>Inline code</code>`

- \``` code block ```

  `<pre><code>Inline code</code></pre>`

## Source

- [Markdown](https://daringfireball.net/projects/markdown/syntax)

- [CommonMark](https://commonmark.org/)

- [PEG.js](https://pegjs.org/)

- [mdown-parse-pegjs](https://github.com/shamansir/mdown-parse-pegjs)
