# PandocFiltersLiveJuliaCode

[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://hsugawa8651.github.io/PandocFiltersLiveJuliaCode.jl/stable)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://hsugawa8651.github.io/PandocFiltersLiveJuliaCode.jl/dev)
[![Build Status](https://github.com/hsugawa8651/PandocFiltersLiveJuliaCode.jl/workflows/CI/badge.svg)](https://github.com/hsugawa8651/PandocFiltersLiveJuliaCode.jl/actions)

## Write pandoc filter in Julia

Example

```
% pandoc --filter=examples/caps.jl -t markdown examples/sample-caps.txt
THIS IS THE CAPS SAMPLE WITH ÄÜÖ.
```
