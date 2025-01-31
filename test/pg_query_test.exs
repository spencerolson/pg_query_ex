defmodule PgQueryTest do
  use ExUnit.Case

  test "parsing of ddl statement" do
    assert {:ok, ast} = PgQuery.parse("create table a (id int8 primary key)")

    assert %PgQuery.ParseResult{
             version: 150_001,
             stmts: [
               %PgQuery.RawStmt{
                 stmt: %PgQuery.Node{
                   node:
                     {:create_stmt,
                      %PgQuery.CreateStmt{
                        relation: %PgQuery.RangeVar{
                          schemaname: "",
                          relname: "a",
                          location: 13
                        }
                      }}
                 }
               }
             ]
           } = ast
  end

  test "error results" do
    query = "select * from something; snot!"

    assert {:error, %{cursorpos: cursorpos, message: _}} =
             PgQuery.parse(query)

    assert binary_part(query, cursorpos, 4) == "snot"
  end
end
