--
-- money3
--
-- Copyright © 2012 Bad_Command
-- Copyright © 2012 kotolegokot
-- Copyright © 2019 by luk3yx
--
-- This library is free software; you can redistribute it and/or
-- modify it under the terms of the GNU Lesser General Public
-- License as published by the Free Software Foundation; either
-- version 2.1 of the License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU General Public License for more details.
--
-- You should have received a copy of the GNU Lesser General Public
-- License along with this library; if not, write to the Free Software
-- Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
--

money3 = {}
money3.version = 2.5

local modpath = assert(minetest.get_modpath("money3",
	"Please call this mod money3."))
dofile(modpath .. "/config.lua")

assert(not minetest.get_modpath("money2"), "money3 and money2 do not mix.")

local storage = minetest.get_mod_storage()
loadfile(modpath .. "/core.lua")(storage)
loadfile(modpath .. "/migration.lua")(storage)

-- Only load convertval.lua if required.
if next(money3.convert_items) then
	loadfile(modpath .. "/convertval.lua")(storage)
end

-- Load income
if money3.enable_income then
	dofile(modpath .. "/income.lua")
end

local function set_if_exists(name, balance)
	if money3.user_exists(name) and balance == balance then
		money3.set(name, balance)
		return true
	end
	return false
end

-- Register money3 as a backend for unified_money
if minetest.get_modpath("um_core") then
	local function make_canonical_name_cache()
		if minetest.global_exists("canonical_name") then
			return canonical_name.get
		end

		local names = {}
		for name in minetest.get_auth_handler().iterate() do
			names[name:lower()] = name
		end
		return function(name)
			return names[name:lower()]
		end
	end

	unified_money.register_backend({
		get_balance = money3.get,
		set_balance = set_if_exists,
		create_account = function(name, default_balance)
			if not name:find(":", 1, true) and
					not minetest.get_player_privs(name).money then
				return false
			end

			money3.set(name, default_balance or 0)
			return true
		end,
		delete_account = money3.delete,
		account_exists = money3.user_exists,
		list_accounts = function()
			local get_canonical_name = make_canonical_name_cache()
			local accounts = {}
			for _, key in ipairs(storage:get_keys()) do
				if key:sub(1, 8) == "balance-" then
					local name = key:sub(9)
					accounts[#accounts + 1] = get_canonical_name(name) or name
				end
			end
			return accounts
		end,
	})
end

-- Make sure the lurkcoin mod knows that money3 exists
if minetest.get_modpath("lurkcoin") then
	lurkcoin.change_bank({
		user_exists = money3.user_exists,
		getbal = money3.get,
		setbal = set_if_exists,
		pay = function(from, to, amount)
			local err = money.transfer(from, to, amount)
			return not err, err
		end
	})
end

-- Backwards compatibility
rawset(_G, "money", money3)

-- I couldn't be bothered to update lockedsign.lua
if minetest.get_modpath("locked_sign") then
	dofile(modpath .. "/lockedsign.lua")
end
