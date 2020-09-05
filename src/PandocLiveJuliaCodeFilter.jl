
# Author: Hiroharu Sugawara <hsugawa@gmail.com>
# Copyright: (C) 2020 Hiroharu Sugawara

export investigate_image, investigate_codeblock

function newmodule(name::String, outdir::String)::Module
   mod = Core.eval(Main, Meta.parse("""
module $name
   macro OUTPUT(); return "$outdir"; end
end
"""))
end

function run_code(mod, code, out_path, err_path)
   function run_code_inside(mod, code, out_path, err_path)
      res=nothing
      open(out_path, "w") do out_f
         redirect_stdout(out_f) do
            open(err_path, "w") do err_f
               n = sizeof(code)
               pos = 1
               while pos <= n
                  try
                     ex, pos = Meta.parse(code, pos)
                     isnothing(ex) && continue
                     res = Core.eval(mod, ex)
                  catch exc
                     if isa(exc,Base.Meta.ParseError)
                        print(err_f, "ERROR: syntax: "*exc.msg)
                     else
                        showerror(err_f, exc)
                     end
                     break
                  end
               end
            end # open(err_path)
         end # redirect_stdout(outf)
      end # open(out_path
      return res
   end

   isempty(code) && return nothing
   ispath(out_path) || mkpath(dirname(out_path))
   ispath(err_path) || mkpath(dirname(err_path))
   run_code_inside(mod,code, out_path, err_path)
end

function remove_hide_from_code(code)
   removed=String[]
   for text in split(code,"\n")
      endswith(text,"#hide") && continue
      push!(removed,text)
   end
   removed=join(removed,"\n")
   isempty(removed) || return removed
   endswith(removed,"\n") && (removed *= "\n")
   return removed
end


OUTDIR="assets"
global MOD=newmodule("mod", OUTDIR)
global COUNT=0

function run_the_code(code)
   global COUNT, OUTDIR, MOD
   COUNT += 1
   out_path=joinpath(OUTDIR, "code"*string(COUNT)*".out")
   err_path=joinpath(OUTDIR, "code"*string(COUNT)*".err")
   res=run_code(MOD, code, out_path, err_path)
   out_message=join(readlines(out_path),"\n")
   err_message=join(readlines(err_path),"\n")
   return res, out_message, err_message
end

function destruct_attrs(a)
   id=""
   length(a) >= 1 && (id=a[1])
   classes=[]
   length(a) >= 2 && (classes=a[2])
   keyvals=[]
   length(a) >= 3 && (keyvals=a[3])
   return id, classes, keyvals
end

function investigate_codeblock(t, c, format, meta)
   (t == "CodeBlock") || return nothing
   attrs, code=c
   id, classes, keyvals=destruct_attrs(attrs)
   length(classes)>=1 || return nothing
   class1 = classes[1]
   startswith(class1,"julia-exec,") || return nothing
   class1 = replace(class1, "julia-exec," => "")
   res, out_s, err_s = run_the_code(code)
   attrs1=deepcopy(attrs)
   attrs1[2][1]=class1
   code=remove_hide_from_code(code)
   isempty(code) && return []
   element1=PandocFilters.CodeBlock(attrs1,code)
   result=Any[]
   push!(result, element1)

   if ! isempty(out_s)
      element2=PandocFilters.CodeBlock(attrs1,out_s)
      push!(result, element2)
   end
   if ! isempty(err_s)
      element3=PandocFilters.CodeBlock(attrs1,err_s)
      push!(result, element3)
   end
   #
   if isempty(out_s) && isempty(err_s)
      if !isnothing(res)
         element4=PandocFilters.CodeBlock(attrs1,string(res))
         push!(result, element4)
      end
   end
   return result
end

function investigate_image(t, c, format, meta)
   (t == "Image") || return nothing
   attr, inlines, url_title = c
   url, title = url_title
   url = replace(url, "@OUTPUT/" => "assets/")
   PandocFilters.Image(attr, inlines, [url, title])
end
