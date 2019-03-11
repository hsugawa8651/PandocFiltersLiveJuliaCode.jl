using PandocFilters: walk, Plain, Null, Code, Str
using Test, JSON
import PandocFilters

PandocFilters.walk(x,y) =walk(x,y, "", Dict{String,Any}())

@testset "JSON" begin
  para = JSON.parse(raw"""{
  "t": "Para",
  "c": [{
      "t": "Str",
      "c": "Brief"
  }, {
      "t": "Space"
  }, {
      "t": "Str",
      "c": "mathematical"
  }] }""")
  j_para = JSON.json(para)
  p_in = copy(para)
  j_test_no_change = JSON.json(walk(para, (t,c,f,m) -> nothing))
  # Check para wasn't mutated
  @test para == p_in 

  # Test the json was unchanged
  @test j_para == j_test_no_change
  j_test_no_space = JSON.json(walk(para, (t,c,f,m) -> t == "Space" ? [] : nothing))

  j_no_space = raw"""{"c":[{"c":"Brief","t":"Str"},{"c":"mathematical","t":"Str"}],"t":"Para"}"""
  @test j_no_space == j_test_no_space
  
end


@testset "Testing walk with (t,c)->1" begin
    action(t, c, format, meta) = 1
    @test walk(1,action) == 1
    @test walk(["string1","string2"],action) == ["string1","string2"]
    @test walk([1,2,3],action) == [1,2,3]
    @test walk(Dict("x"=>2,"y"=>3),action) == Dict("x"=>2,"y"=>3)
    @test walk([Dict("t"=>2,"c"=>3)],action) == [1]
end

@testset "Testing walk with t=>x -> t=>y" begin
    action(t, c, format, meta) = (t=="x") ? Dict("t"=>"y","c"=>c) : nothing
    dict_x = Dict("t"=>"x","c"=>"z")
    dict_y = Dict("t"=>"y","c"=>"z")
    dict_z = Dict("t"=>"z","c"=>"w")
    @test walk([dict_x],action, "", Dict()) == [dict_y]
    @test walk([dict_x,dict_y,dict_z],action) == [dict_y,dict_y,dict_z]
    @test walk(Dict("t"=>"w","c"=>[dict_x]),action) == Dict("t"=>"w","c"=>[dict_y])
    @test walk([dict_z,Dict("t"=>"w","c"=>[dict_x])],action) == [dict_z,Dict("t"=>"w","c"=>[dict_y])]
end
@testset "Testing Pandoc elements" begin
  @test Plain("Plain text") == Dict("t"=>"Plain","c"=>"Plain text")
  @test Null() == Dict("t"=>"Null","c"=>[])
  @test Code(["fun";Any[[],[]]],"1+1") ==  Dict("t"=>"Code","c"=>Any[["fun"; Any[[],[]]],"1+1"])
end

@testset "Testing walk with string replacement" begin
  action(t, c, format, meta) = (t=="Str") ? Dict("t"=>"Str","c"=>"This string was $c") : nothing
  @test walk([Str("abc"),Code("xy", "ab")], action) == [Str("This string was abc"), Code("xy", "ab")]
end
