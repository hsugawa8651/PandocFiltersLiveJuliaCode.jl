#!/usr/bin/env julia

"""
Pandoc filter to convert all regular text to uppercase.
Code, link URLs, etc. are not affected.
"""

using PandocFiltersLiveJuliaCode

function caps(t,v,format, meta)
   (t == "Str") || return nothing
   return Str(uppercase(v))
end

if abspath(PROGRAM_FILE) == @__FILE__
   PandocFiltersLiveJuliaCode.filter(caps)
end
