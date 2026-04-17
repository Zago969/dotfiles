return {
  "CRAG666/code_runner.nvim",
  event = "VeryLazy",
  config = function()
    require("code_runner").setup({
      mode = "term", -- Bottom terminal that stays open
      startinsert = true, -- Start in insert mode for easy re-runs
      filetype = {
        -- Python
        python = "cd $dir && python $fileName",

        -- JavaScript & TypeScript
        javascript = "cd $dir && node $fileName",
        typescript = "cd $dir && ts-node $fileName",

        -- C & C++
        c = "cd $dir && gcc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",
        cpp = "cd $dir && g++ $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",

        -- Rust
        rust = "cd $dir && rustc $fileName -o $fileNameWithoutExt && ./$fileNameWithoutExt",

        -- Go
        go = "cd $dir && go run $fileName",

        -- Java
        java = "cd $dir && javac $fileName && java $fileNameWithoutExt",

        -- Lua
        lua = "cd $dir && lua $fileName",

        -- Bash / Shell scripts
        sh = "cd $dir && bash $fileName",

        -- HTML (opens in default browser)
        html = "xdg-open $fileName || open $fileName || start $fileName",

        -- PHP
        php = "cd $dir && php $fileName",

        -- Ruby
        ruby = "cd $dir && ruby $fileName",

        -- Perl
        perl = "cd $dir && perl $fileName",

        -- R
        r = "cd $dir && Rscript $fileName",

        -- Julia
        julia = "cd $dir && julia $fileName",

        -- Kotlin
        kotlin = "cd $dir && kotlinc $fileName -include-runtime -d $fileNameWithoutExt.jar && java -jar $fileNameWithoutExt.jar",

        -- Swift
        swift = "cd $dir && swift $fileName",

        -- Dart
        dart = "cd $dir && dart $fileName",

        -- Haskell
        haskell = "cd $dir && runhaskell $fileName",

        -- Elixir
        elixir = "cd $dir && elixir $fileName",

        -- SQL (runs with sqlite3 if file has .sql extension)
        sql = "cd $dir && sqlite3 test.db < $fileName",

        -- Markdown preview (optional)
        markdown = "glow $fileName", -- Needs 'glow' installed
      },
    })

    -- Universal F5 to run current file (any language)
    vim.keymap.set("n", "<F5>", ":RunCode<cr>", { desc = "Run current file" })
    vim.keymap.set("n", "<leader>rp", ":RunCode<cr>", { desc = "Run file" })
  end,
}
