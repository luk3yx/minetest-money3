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

local storage = assert(...)
local db_ver = storage:get_int("version")
assert(db_ver <= 1, "Database was created with a newer version of money3")
if db_ver == 1 then return end

-- Migrate any old balances that still exist
local worldpath = minetest.get_worldpath()
local migrated = 0
for _, filename in ipairs(minetest.get_dir_list(worldpath, false)) do
	local name = filename:match("^money_([A-Za-z0-9_%-]+)%.txt$")
	if name then
		-- Try and get a handler to the balance file
		local path = worldpath .. "/" .. filename
		local file, err = assert(io.open(path, "r"))
		if not file then
		    minetest.log("error", "[money3] Error migrating database: " .. err)
		    return
		end

		-- Read the credit
		local credit = file:read("*n")
		file:close()

		-- Set the player's balance if they don't have any balance in mod
		-- storage
		if credit and credit == credit and credit >= 0 and
				not money3.get(name) then
			money3.set(name, credit)

			-- Delete the file
			os.remove(path)

			migrated = migrated + 1
		end
	end
end

-- Move the convert_stats file to mod storage
local stat_file = worldpath .. "/convert_stats"
local f = io.open(stat_file)
if f then
	storage:set_string("stats2", f:read("*a"))
	f:close()
	os.remove(stat_file)
end

-- Update the version
storage:set_int("version", 1)

if migrated > 0 then
	minetest.log("action", "[money3] Migrated " .. migrated ..
		" old money2 balance files.")
end
