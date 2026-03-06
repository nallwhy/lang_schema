defmodule LangSchema.External.FunctionCalling.GoogleTest do
  use ExUnit.Case, async: true

  alias LangSchema.Test.IntegrationSchema
  alias LangSchema.Test.ExternalTestHelper

  @moduletag external: :google

  test "tool call produces valid arguments" do
    json_schema = IntegrationSchema.schema() |> LangSchema.function_calling(:google)

    tool =
      LangChain.Function.new!(%{
        name: "register_person",
        description: "Register a person in the system",
        parameters_schema: json_schema,
        function: fn _args, _context -> {:ok, "registered"} end
      })

    chat =
      LangChain.ChatModels.ChatGoogleAI.new!(%{
        model: "gemini-2.5-flash",
        temperature: 0,
        api_key: ExternalTestHelper.api_key!(:google)
      })

    {:ok, chain} =
      %{llm: chat}
      |> LangChain.Chains.LLMChain.new!()
      |> LangChain.Chains.LLMChain.add_message(
        LangChain.Message.new_user!(ExternalTestHelper.prompt() <> " Register this person.")
      )
      |> LangChain.Chains.LLMChain.add_tools([tool])
      |> LangChain.Chains.LLMChain.run()

    assert [%LangChain.Message.ToolCall{} = call | _] = chain.last_message.tool_calls
    assert call.name == "register_person"

    args = ExternalTestHelper.extract_tool_args(call)

    # Google function calling doesn't reliably return null for nullable fields;
    # it may return "" instead. Use relaxed nullable check for this case.
    ExternalTestHelper.assert_valid_person(args, nullable_as_empty_string: true)
  end
end
