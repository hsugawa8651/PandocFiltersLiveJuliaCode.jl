using PandocFilters: walk, Plain, Null, Code
using Test

# write your own tests here
@testset "Testing walk with (t,c)->1" begin
    action(t,c) = 1
    @test walk(1,action) == 1
    @test walk(["string1","string2"],action) == ["string1","string2"]
    @test walk([1,2,3],action) == [1,2,3]
    @test walk(Dict("x"=>2,"y"=>3),action) == Dict("x"=>2,"y"=>3)
    @test walk([Dict("t"=>2,"c"=>3)],action) == [1]
end

@testset "Testing walk with t=>x -> t=>y" begin
    action(t,c) = (t=="x") ? Dict("t"=>"y","c"=>c) : nothing
    dict_x = Dict("t"=>"x","c"=>"z")
    dict_y = Dict("t"=>"y","c"=>"z")
    dict_z = Dict("t"=>"z","c"=>"w")
    @test walk([dict_x],action) == [dict_y]
    @test walk([dict_x,dict_y,dict_z],action) == [dict_y,dict_y,dict_z]
    @test walk(Dict("t"=>"w","c"=>[dict_x]),action) == Dict("t"=>"w","c"=>[dict_y])
    @test walk([dict_z,Dict("t"=>"w","c"=>[dict_x])],action) == [dict_z,Dict("t"=>"w","c"=>[dict_y])]
end
@testset "Testing Pandoc elements" begin
  @test Plain("Plain text") == Dict("t"=>"Plain","c"=>"Plain text")
  @test Null() == Dict("t"=>"Null","c"=>[])
  @test Code(["fun";Any[[],[]]],"1+1") ==  Dict("t"=>"Code","c"=>Any[["fun"; Any[[],[]]],"1+1"])
end
