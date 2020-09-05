
# Author: Hiroharu Sugawara <hsugawa@gmail.com>
# Copyright: (C) 2020 Hiroharu Sugawara

# Author: Eric P. Hanson
# Copyright: (C) 2018? Eric P. Hanson

# Author: Martin Vuk <martin.vuk@fri.uni-lj.si>
# Copyright: (C) 2016 Martin Vuk

# License: BSD 3-clause


"""
    PandocFiltersLiveJuliaCode

Package to aid writing Julia scripts that process the pandoc
AST serialized as JSON.
"""
module PandocFiltersLiveJuliaCode

using JSON

include("./PandocFilters.jl")

end # module
