# JsonResponse

Formatter Json para testes em Elixir

Adicionar no `test_helper.exs`

```elixir
  ExUnit.configure formatters: [ExUnit.CLIFormatter, JsonResponse]
```

Adicionar o Arquivo do formater de preferência na pasta `support` e adicionar a configuração no `mix.exs` para carregar a pasta junto com os testes

```elixir
  defp elixirc_paths(:test), do: ["lib", "test/support"]
```

Exemplo:

```json
{
  "excluded": [],
  "failed": [
    {
      "describe": "by_id/1",
      "file": "/media/miticos/HD/github/json_response/test/exmoveit/users/get_test.exs",
      "line": 10,
      "module": "Elixir.Exmoveit.Users.GetTest",
      "test": "test by_id/1 When id exist, returns the user"
    }
  ],
  "invalid": [],
  "passed": [
    {
      "describe": "changeset/1",
      "file": "/media/miticos/HD/github/json_response/test/exmoveit/user_test.exs",
      "line": 14,
      "module": "Elixir.Exmoveit.UserTest",
      "test": "test changeset/1 When all params are valid, returns a valid changeset"
    }
  ]
}
```
