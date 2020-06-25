-- https://github.com/jgm/pandoc/issues/2106#issuecomment-371355862
function Span(el)
  if el.classes:includes("note") then
    return {
      pandoc.RawInline("latex", "\\note{"),
      el,
      pandoc.RawInline("latex", "}")
    }
  end
end
