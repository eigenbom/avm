function setup_busted_helpers(assert)
	local say = require("say")

	local function almost_equals(_, arguments)
		local epsilon = 1e-9
		if arguments==nil or #arguments~=2 or #arguments[1]~=#arguments[2] then
			return false
		end

		for i=1,#arguments[1] do
			if math.abs(arguments[1][i] - arguments[2][i]) > epsilon then
				return false
			end
		end

		return true
	end

	say:set("assertion.almost_equals.positive", "Expected %s and %s to be almost equal")
	say:set("assertion.almost_equals.negative", "Expected %s and %s to not be almost equal")
	assert:register("assertion", "almost_equals", almost_equals, "assertion.almost_equals.positive", "assertion.almost_equals.negative")
end
