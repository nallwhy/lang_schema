defmodule LangSchema.Test.Schema do
  def schema() do
    %{
      type: :object,
      description: "All Types",
      properties: [
        # boolean
        flag: %{
          type: :boolean,
          description: "Flag"
        },
        # integer
        rating: %{
          type: :integer,
          description: "Rating",
          minimum: 0,
          maximum: 5
        },
        # number
        price: %{
          type: :number,
          description: "Price",
          multiple_of: 10
        },
        # string
        email: %{
          type: :string,
          description: "Email",
          min_length: 1,
          max_length: 255,
          pattern: ~r/^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$/,
          format: :email
        },
        # enum, nullable
        role: %{
          type: :string,
          description: "Role",
          enum: ["admin", "billing"],
          nullable: true
        },
        # array
        tags: %{
          type: :array,
          description: "Tags",
          items: %{type: :string, description: "Tag"},
          min_items: 1,
          max_items: 5,
          unique_items: true
        },
        # object
        metadata: %{
          type: :object,
          description: "Metadata",
          properties: [
            {"id", %{type: :string}},
            {"extra", %{type: :string}}
          ],
          required: [:id]
        }
      ]
    }
  end
end
