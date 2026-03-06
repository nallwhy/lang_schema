defmodule LangSchema.External.FunctionCalling.AnthropicTest do
  use ExUnit.Case, async: true

  alias LangSchema.Test.IntegrationSchema
  alias LangSchema.Test.ExternalTestHelper

  @moduletag external: :anthropic

  test "tool call produces valid arguments" do
    json_schema = IntegrationSchema.schema() |> LangSchema.function_calling(:anthropic)

    tool =
      LangChain.Function.new!(%{
        name: "register_person",
        description: "Register a person in the system",
        parameters_schema: json_schema,
        function: fn _args, _context -> {:ok, "registered"} end
      })

    chat =
      LangChain.ChatModels.ChatAnthropic.new!(%{
        model: "claude-haiku-4-5-20251001",
        temperature: 0,
        tool_choice: %{"type" => "tool", "name" => "register_person"},
        api_key: ExternalTestHelper.api_key!(:anthropic)
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
    ExternalTestHelper.assert_valid_person(args)
  end
end
