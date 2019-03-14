using PandocFilters: walk!, Plain, Null, Code, Str, Space
using Test, JSON, BenchmarkTools
import PandocFilters

PandocFilters.walk!(x,y) = walk!(x, y, "", Dict{String,Any}())
PandocFilters.walk!(x) = walk!(x, (t,c,m,f) -> nothing)




@testset "Manual roundtrip" begin
 manual_str = open("MANUAL.JSON", "r") do f
    read(f, String)
  end;
  j_manual = JSON.parse(manual_str);

  doc_out = walk!(j_manual, (t,c,m,f) -> nothing)

  @test doc_out == j_manual == JSON.parse(manual_str)
  
end


@testset "Paragraph" begin
  para = JSON.parse(raw"""{"c":[{"c":"Brief","t":"Str"},{"t":"Space"},{"c":"mathematical","t":"Str"}],"t":"Para"}""")
  j_para = JSON.json(para)
  p_in = copy(para)
  j_test_no_change = JSON.json(walk!(para, (t,c,f,m) -> nothing))


  # Test the json was unchanged
  @test j_para == j_test_no_change
  out = walk!(para, (t,c,f,m) -> t == "Space" ? [] : nothing)
  j_test_no_space = JSON.json(out)

  @test j_test_no_space == raw"""{"c":[{"c":"Brief","t":"Str"},{"c":"mathematical","t":"Str"}],"t":"Para"}"""

  # Check para was mutated
  @test para != p_in
  @test para == out
  
  # Try doubling the spaces
  j_test_double_space = JSON.json(walk!(p_in, (t,c,f,m) -> t == "Space" ? [Space(), Space()] : nothing))
  @test j_test_double_space == raw"""{"c":[{"c":"Brief","t":"Str"},{"t":"Space"},{"t":"Space"},{"c":"mathematical","t":"Str"}],"t":"Para"}"""
  
end


@testset "Testing walk with (t,c)->1" begin
    action(t, c, format, meta) = 1
    @test walk!(1,action) == 1
    @test walk!(["string1","string2"],action) == ["string1","string2"]
    @test walk!([1,2,3],action) == [1,2,3]
    @test walk!(Dict("x"=>2,"y"=>3),action) == Dict("x"=>2,"y"=>3)
    @test walk!([Dict("t"=>2,"c"=>3)],action) == [1]
end

@testset "Testing walk with t=>x -> t=>y" begin
    action(t, c, format, meta) = (t=="x") ? Dict("t"=>"y","c"=>c) : nothing
    dict_x = Dict("t"=>"x","c"=>"z")
    dict_y = Dict("t"=>"y","c"=>"z")
    dict_z = Dict("t"=>"z","c"=>"w")
    @test walk!([dict_x],action, "", Dict()) == [dict_y]
    @test walk!([dict_x,dict_y,dict_z],action) == [dict_y,dict_y,dict_z]
    @test walk!(Dict("t"=>"w","c"=>[dict_x]),action) == Dict("t"=>"w","c"=>[dict_y])
    @test walk!([dict_z,Dict("t"=>"w","c"=>[dict_x])],action) == [dict_z,Dict("t"=>"w","c"=>[dict_y])]
end

@testset "Testing Pandoc elements" begin
  @test Plain("Plain text") == Dict("t"=>"Plain","c"=>"Plain text")
  @test Null() == Dict("t"=>"Null")
  @test Code(["fun";Any[[],[]]],"1+1") ==  Dict("t"=>"Code","c"=>Any[["fun"; Any[[],[]]],"1+1"])
end

@testset "Testing walk with string replacement" begin
  action(t, c, format, meta) = (t=="Str") ? Dict("t"=>"Str","c"=>"This string was $c") : nothing
  @test walk!([Str("abc"),Code("xy", "ab")], action) == [Str("This string was abc"), Code("xy", "ab")]
end
