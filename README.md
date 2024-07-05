# money3

This is a fork of [money2](https://github.com/Bremaweb/money2) that uses more
modern APIs such as mod storage and is fully backwards compatible with
`money2` (you can upgrade from money2 nicely, however you can't downgrade
again).

## Before installing

By default, players can convert gold and silver ingots into money using
`/convert gold` and `/convert silver`. To disable this, add
`money3.convert_items = nil` to minetest.conf.

Players need the "money" privilege to be able to use /money and receive
payments. You should consider adding `money` to the default_privs setting in
minetest.conf.

## Config settings

*These can be set in `config.lua` or `minetest.conf`.*

 - `money3.initial_amount`: The amount of money new players get. Default: `0`.
 - `money3.currency_name`: The text appended to the currency when displaying it.
    Default: `cr`.
 - `money3.enable_income`: Pays players money (by default 10cr) every in-game
    day. Default: `true` if creative mode is disabled, otherwise `false`. If
    you are using the [currency](https://content.minetest.net/packages/mt-mods/currency/)
    mod, it is probably a good idea to set `currency.income_enabled` to `false`.
 - `money3.income_amount`: Changes the amount of income players get paid. If
    income is not enabled, this does nothing.
 - `money3.convert_items`: A lua table (that can also be `nil` to disable)
    similar to the following (default) one:

```lua
{
    gold = { item = "default:gold_ingot", dig_block="default:stone_with_gold",
        desc='Gold', amount=75, minval=25 },
    silver = { item = "moreores:silver_ingot",
        dig_block="moreores:mineral_silver", desc='Silver', amount = 27,
        minval=7}
}
```
