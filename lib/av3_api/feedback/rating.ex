defmodule Av3Api.Feedback.Rating do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ratings" do
    field :score, :integer
    field :comment, :string

    belongs_to :ride, Av3Api.Operation.Ride

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(rating, attrs) do
    rating
    |> cast(attrs, [:score, :comment, :ride_id])
    |> validate_required([:score, :ride_id])
    |> validate_inclusion(:score, 1..5, message: "A nota deve ser entre 1 e 5")
  end
end
