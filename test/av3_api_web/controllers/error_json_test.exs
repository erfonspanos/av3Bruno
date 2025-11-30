defmodule Av3ApiWeb.ErrorJSONTest do
  use Av3ApiWeb.ConnCase, async: true

  test "renders 404" do
    assert Av3ApiWeb.ErrorJSON.render("404.json", %{}) == %{errors: %{detail: "Not Found"}}
  end

  test "renders 500" do
    assert Av3ApiWeb.ErrorJSON.render("500.json", %{}) ==
             %{errors: %{detail: "Internal Server Error"}}
  end
end
