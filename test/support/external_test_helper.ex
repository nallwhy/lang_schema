defmodule LangSchema.Test.ExternalTestHelper do
  @moduledoc """
  Shared helpers for external LLM integration tests.
  """

  import ExUnit.Assertions

  @prompt """
  Describe a fictional person with the following details:
  - Name: Alice Smith
  - Age: 30
  - Height: 1.65 meters
  - Active: true
  - Role: member
  - Hobby: (not provided)
  - Tags: ["creative", "kind"]
  - Address: city is Seoul, country is South Korea
  Fill in exactly these values.
  """

  def prompt, do: @prompt

  def api_key!(:openai), do: System.fetch_env!("OPENAI_API_KEY")
  def api_key!(:gemini), do: System.fetch_env!("GEMINI_API_KEY")

  @doc """
  Extracts text content from a LangChain message.
  Handles both plain string content and ContentPart lists.
  """
  def extract_text_content(%LangChain.Message{content: content}) when is_binary(content) do
    content
  end

  def extract_text_content(%LangChain.Message{
        content: [%LangChain.Message.ContentPart{type: :text, content: text} | _]
      }) do
    text
  end

  @doc """
  Extracts tool call arguments as a map.
  Handles both string (JSON) and map arguments.
  """
  def extract_tool_args(%LangChain.Message.ToolCall{arguments: args}) when is_map(args) do
    args
  end

  def extract_tool_args(%LangChain.Message.ToolCall{arguments: args}) when is_binary(args) do
    Jason.decode!(args)
  end

  def assert_valid_person(person, opts \\ []) do
    nullable_as_empty_string = Keyword.get(opts, :nullable_as_empty_string, false)

    assert is_map(person), "Expected a map, got: #{inspect(person)}"

    # string
    assert is_binary(person["name"]),
           "expected name to be a string, got: #{inspect(person["name"])}"

    # integer
    assert is_integer(person["age"]),
           "expected age to be an integer, got: #{inspect(person["age"])}"

    # number (float)
    assert is_number(person["height"]),
           "expected height to be a number, got: #{inspect(person["height"])}"

    # boolean
    assert is_boolean(person["active"]),
           "expected active to be a boolean, got: #{inspect(person["active"])}"

    # enum
    assert person["role"] in ["admin", "member", "guest"],
           "expected role to be one of admin/member/guest, got: #{inspect(person["role"])}"

    # nullable
    if nullable_as_empty_string do
      assert is_nil(person["hobby"]) or person["hobby"] == "",
             "expected hobby to be null or empty string, got: #{inspect(person["hobby"])}"
    else
      assert is_nil(person["hobby"]),
             "expected hobby to be null, got: #{inspect(person["hobby"])}"
    end

    # array of strings
    assert is_list(person["tags"]),
           "expected tags to be an array, got: #{inspect(person["tags"])}"

    assert Enum.all?(person["tags"], &is_binary/1),
           "expected tags to contain only strings"

    # nested object
    address = person["address"]
    assert is_map(address), "expected address to be an object, got: #{inspect(address)}"

    assert is_binary(address["city"]),
           "expected address.city to be a string, got: #{inspect(address["city"])}"

    assert is_binary(address["country"]),
           "expected address.country to be a string, got: #{inspect(address["country"])}"
  end
end
