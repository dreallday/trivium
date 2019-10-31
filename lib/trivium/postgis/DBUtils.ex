defmodule DBUtils do

	def result_to_map_list(result) do
		case result.__struct__ do
			Postgrex.Result ->
				result
				|> postgrex_result_to_map_list()
			Mysqlex.Result ->
				result
				|> mysqlex_result_to_map_list()
			_ ->
				[]
		end
	end

	defp postgrex_result_to_map_list(result) do
		column_names = result
			|> Map.get(:columns, [])
		rows = result
			|> Map.get(:rows, [])
		rows
		|> Enum.reduce([], fn row, acc ->
			acc ++ [
				row
				|> zip_column_names(column_names)
				|> Enum.into(%{})
			]
		end)
	end

	defp mysqlex_result_to_map_list(result) do
		column_names = result
			|> Map.get(:columns, [])
		rows = result
			|> Map.get(:rows, [])
		rows
		|> Enum.reduce([], fn row, acc ->
			acc ++ [
				row
				|> zip_column_names(column_names)
				|> Enum.into(%{})
			]
		end)
	end

	defp zip_column_names(row, column_names) do
		List.zip([
			column_names,
			row,
		])
	end

end
