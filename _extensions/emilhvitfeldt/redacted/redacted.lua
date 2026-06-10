local injected = false

local function ext_dir()
  local src = debug.getinfo(1, "S").source
  if src:sub(1, 1) == "@" then src = src:sub(2) end
  return pandoc.path.directory(src)
end

local class_map = {
  ["redacted"] = true,
  ["redacted-script"] = true,
  ["redacted-script-bold"] = true,
  ["redacted-script-light"] = true,
}

local latex_inline = {
  ["redacted"] = "\\redacted",
  ["redacted-script"] = "\\redactedscript",
  ["redacted-script-bold"] = "\\redactedscriptbold",
  ["redacted-script-light"] = "\\redactedscriptlight",
}

local latex_env = {
  ["redacted"] = "redactedblock",
  ["redacted-script"] = "redactedscriptblock",
  ["redacted-script-bold"] = "redactedscriptblock",
  ["redacted-script-light"] = "redactedscriptblock",
}

local typst_fn = {
  ["redacted"] = "redacted",
  ["redacted-script"] = "redacted-script",
  ["redacted-script-bold"] = "redacted-script-bold",
  ["redacted-script-light"] = "redacted-script-light",
}

local function find_class(classes)
  for _, c in ipairs(classes) do
    if class_map[c] then return c end
  end
  return nil
end

local function inject_resources()
  if injected then return end
  injected = true
  local dir = ext_dir()

  if quarto.doc.is_format("html:js") or quarto.doc.is_format("revealjs") then
    quarto.doc.add_html_dependency({
      name = "redacted",
      version = "0.1.0",
      stylesheets = { pandoc.path.join({ dir, "redacted.css" }) },
      resources = {
        { name = "fonts/Redacted-Regular.woff2", path = pandoc.path.join({ dir, "fonts/Redacted-Regular.woff2" }) },
        { name = "fonts/RedactedScript-Regular.woff2", path = pandoc.path.join({ dir, "fonts/RedactedScript-Regular.woff2" }) },
        { name = "fonts/RedactedScript-Bold.woff2", path = pandoc.path.join({ dir, "fonts/RedactedScript-Bold.woff2" }) },
        { name = "fonts/RedactedScript-Light.woff2", path = pandoc.path.join({ dir, "fonts/RedactedScript-Light.woff2" }) },
      },
    })
  elseif quarto.doc.is_format("latex") then
    local fonts = pandoc.path.join({ dir, "fonts" }) .. "/"
    local tex = string.format([[
\usepackage{fontspec}
\newfontfamily\redactedfont[Path=%s]{Redacted-Regular.ttf}
\newfontfamily\redactedscriptfont[Path=%s]{RedactedScript-Regular.ttf}
\newfontfamily\redactedscriptboldfont[Path=%s]{RedactedScript-Bold.ttf}
\newfontfamily\redactedscriptlightfont[Path=%s]{RedactedScript-Light.ttf}
\newcommand{\redacted}[1]{{\redactedfont #1}}
\newcommand{\redactedscript}[1]{{\redactedscriptfont #1}}
\newcommand{\redactedscriptbold}[1]{{\redactedscriptboldfont #1}}
\newcommand{\redactedscriptlight}[1]{{\redactedscriptlightfont #1}}
\newenvironment{redactedblock}{\redactedfont}{}
\newenvironment{redactedscriptblock}{\redactedscriptfont}{}
]], fonts, fonts, fonts, fonts)
    quarto.doc.include_text("in-header", tex)
  elseif quarto.doc.is_format("typst") then
    local fonts = pandoc.path.join({ dir, "fonts" })
    local typ = string.format([[
#let redacted(body) = text(font: "Redacted", body)
#let redacted-script(body) = text(font: "Redacted Script", body)
#let redacted-script-bold(body) = text(font: "Redacted Script", weight: "bold", body)
#let redacted-script-light(body) = text(font: "Redacted Script", weight: "light", body)
]])
    quarto.doc.include_text("in-header", typ)
    -- font-paths must be passed to typst CLI; user should add to YAML:
    -- typst:
    --   font-paths: [_extensions/redacted/fonts]
    -- We don't have a way to inject font-paths from a filter.
    _ = fonts
  end
end

function Meta(meta)
  inject_resources()
end

function Span(el)
  local cls = find_class(el.classes)
  if not cls then return nil end

  if quarto.doc.is_format("latex") then
    local cmd = latex_inline[cls]
    return {
      pandoc.RawInline("latex", cmd .. "{"),
      pandoc.Span(el.content),
      pandoc.RawInline("latex", "}"),
    }
  elseif quarto.doc.is_format("typst") then
    local fn = typst_fn[cls]
    return {
      pandoc.RawInline("typst", "#" .. fn .. "[#box[" ),
      pandoc.Span(el.content),
      pandoc.RawInline("typst", "]]"),
    }
  end
  return nil
end

function Div(el)
  local cls = find_class(el.classes)
  if not cls then return nil end

  if quarto.doc.is_format("latex") then
    local env = latex_env[cls]
    local out = pandoc.List()
    out:insert(pandoc.RawBlock("latex", "\\begin{" .. env .. "}"))
    for _, b in ipairs(el.content) do out:insert(b) end
    out:insert(pandoc.RawBlock("latex", "\\end{" .. env .. "}"))
    return out
  elseif quarto.doc.is_format("typst") then
    local fn = typst_fn[cls]
    local out = pandoc.List()
    out:insert(pandoc.RawBlock("typst", "#" .. fn .. "[" ))
    for _, b in ipairs(el.content) do out:insert(b) end
    out:insert(pandoc.RawBlock("typst", "]"))
    return out
  end
  return nil
end

return {
  { Meta = Meta },
  { Span = Span, Div = Div },
}
