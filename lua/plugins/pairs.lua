return {
  {
    "nvim-mini/mini.pairs",
    enabled = true,
    opts = {
      modes = { insert = true, command = true, terminal = false },
      mappings = {
        ["("] = { action = "open", pair = "()" },
        ["["] = { action = "open", pair = "[]" },
        ["{"] = { action = "open", pair = "{}" },
        ['"'] = { action = "closeopen", pair = '""', neigh_pattern = '^[^\\]', register = { cr = false } },
        ["'"] = { action = "closeopen", pair = "''", neigh_pattern = '^[^%a\\]', register = { cr = false } },
      },
    },
  },
}
