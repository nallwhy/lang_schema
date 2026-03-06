defmodule LangSchema.External.StructuredOutput.GoogleTest do
  use ExUnit.Case, async: true

  alias LangSchema.Test.IntegrationSchema
  alias LangSchema.Test.ExternalTestHelper

  @moduletag external: :google

  test "generates valid structured output" do
    json_schema = IntegrationSchema.schema() |> LangSchema.structured_output(:google)

    chat =
      LangChain.ChatModels.ChatGoogleAI.new!(%{
        model: "gemini-2.5-flash",
        temperature: 0,
        json_response: true,
        json_schema: json_schema,
        api_key: ExternalTestHelper.api_key!(:google)
      })

    {:ok, chain} =
      %{llm: chat}
      |> LangChain.Chains.LLMChain.new!()
      |> LangChain.Chains.LLMChain.add_message(
        LangChain.Message.new_user!(ExternalTestHelper.prompt())
      )
      |> LangChain.Chains.LLMChain.run()

    person = chain.last_message |> ExternalTestHelper.extract_text_content() |> Jason.decode!()

    ExternalTestHelper.assert_valid_person(person)
  end
end
