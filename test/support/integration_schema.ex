defmodule LangSchema.Test.IntegrationSchema do
  @moduledoc """
  Shared schema for external LLM integration tests.

  Covers all major type/keyword branches:
  - string, integer, number, boolean (primitive types)
  - enum (string enum)
  - nullable (nullable string)
  - array of strings
  - nested object
  """

  def schema do
    %{
      type: :object,
      description: "A person",
      required: [:name, :age, :height, :active, :role, :hobby, :tags, :address],
      properties: [
        name: %{type: :string, description: "The person's full name"},
        age: %{type: :integer, description: "The person's age in years"},
        height: %{type: :number, description: "The person's height in meters, e.g. 1.65"},
        active: %{type: :boolean, description: "Whether the person is currently active"},
        role: %{
          type: :string,
          description: "The person's role",
          enum: ["admin", "member", "guest"]
        },
        hobby: %{
          type: :string,
          description: "The person's primary hobby, or null if unknown",
          nullable: true
        },
        tags: %{
          type: :array,
          description: "Descriptive tags for this person",
          items: %{type: :string}
        },
        address: %{
          type: :object,
          description: "The person's address",
          required: [:city, :country],
          properties: [
            city: %{type: :string, description: "City name"},
            country: %{type: :string, description: "Country name"}
          ]
        }
      ]
    }
  end
end
