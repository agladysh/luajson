local json = require("json")
local lunit = require("lunit")
local math = math
local testutil = require("testutil")

local setmetatable = setmetatable

module("lunit-custom-encode", lunit.testcase, package.seeall)

function test_output()
	local encoder = json.encode.getEncoder()
	assert_equal('X', encoder(setmetatable({}, {__tojson=function() return "X" end})))
	assert_equal('"X"', encoder(setmetatable({}, {__tojson=function(value, encode, state) return encode("X") end})))
	assert_equal('{}', encoder(setmetatable({}, {__tojson=function(value, encode, state) return "X" end}), true))
	assert_equal('{}', encoder(setmetatable({}, {__tojson=function(value, encode, state) return encode(setmetatable({}, {__tojson=function() return 'Z' end}), state, true) end})))
	assert_equal('[Z]', encoder({setmetatable({}, {__tojson=function(value, encode, state) return 'Z' end})}))
end
