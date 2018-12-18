#!/usr/bin/env julia
 
using Test
 
# write your own tests here
@test 1 == 1

function test_using()
  try 
     using CORBITS
  catch
     return false
  end
  return true
end

@test test_using()

