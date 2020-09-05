#!/usr/bin/env julia

# Author: Hiroharu Sugawara <hsugawa@gmail.com>
# Copyright: (C) 2020 Hiroharu Sugawara

using PandocFiltersLiveJuliaCode

if abspath(PROGRAM_FILE) == @__FILE__
   PandocFiltersLiveJuliaCode.filter([
      PandocFiltersLiveJuliaCode.investigate_image,
      PandocFiltersLiveJuliaCode.investigate_codeblock ])
end
