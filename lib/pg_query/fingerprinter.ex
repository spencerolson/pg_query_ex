defmodule PgQuery.Fingerprinter do
  @on_load :init

  defmodule Error do
    defexception [:message]
  end

  def init do
    :ok = load_nif()
  end

  defp load_nif do
    :pg_query_ex
    |> Application.app_dir("priv/libpg_query_ex")
    |> String.to_charlist()
    |> :erlang.load_nif(0)
  end

  def fingerprint(query) when is_binary(query) do
    with {:ok, proto} <- fingerprint_query(query) do
      # Protox.decode(proto, PgQuery.ParseResult)
      proto
    end
  end

  # def parse!(query) when is_binary(query) do
  #   case parse_query(query) do
  #     {:ok, proto} ->
  #       Protox.decode!(proto, PgQuery.ParseResult)

  #     {:error, reason} ->
  #       raise Error, message: reason
  #   end
  # end

  def fingerprint_query(_query), do: :erlang.nif_error(:nif_not_loaded)
end
