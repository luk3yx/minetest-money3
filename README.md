# money3

This is a fork of [money2](https://github.com/Bremaweb/money2) that uses more
modern APIs such as mod storage and is fully backwards compatible with
`money2` (you can upgrade from money2 nicely, however you can't downgrade
again).

## Config settings

*These can be set in `config.lua` or `minetest.conf`.*

 - `money3.initial_amount`: The amount of money new players get. Default: `0`.
 - `money3.currency_name`: The text appended to the currency when displaying it.
    Default: `cr`.
 - `money3.enable_income`: Pays players money (by default 10cr) every in-game
    day. Default: `true` if creative mode is disabled, otherwise `false`. If
    you are using the  [currency](https://gitlab.com/VanessaE/currency) mod, it
    is probably a good idea to set `currency.income_enabled` to `false`. If you
    use an outdated version of the currency mod where this setting does not
    exist, the automatic income system is automatically disabled.
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
