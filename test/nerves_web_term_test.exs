defmodule NervesWebTermTest do
  use ExUnit.Case
  doctest NervesWebTerm

  test "greets the world" do
    assert NervesWebTerm.hello() == :world
  end
end
