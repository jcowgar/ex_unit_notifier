defmodule ExUnitNotifier.Notifiers.TerminalColor do
  @moduledoc """
  Change the terminal background between two colors based on success/failure of tests.

  Accepts four configuration values:

  * :terminal_pass_foreground
  * :terminal_pass_background
  * :terminal_fail_foreground
  * :terminal_fail_background

  These four must be defined to have the TerminalBackground notifier register as
  available. They should be set to `#rrggbb` hex values.

  ## Example Configuration

  This configuration looks pretty good when you are using the Catppuccin Mocha
  terminal color scheme.

  ```
  config :ex_unit_notifier,
    terminal_pass_background: "#1e2e2e",
    terminal_pass_foreground: "#cdd6f4",
    terminal_fail_background: "#3e1e2e",
    terminal_fail_foreground: "#cdd6f4"
  ```
  """

  def notify(status, _message, opts) do
    {bg, fg} = colors(status, opts)

    IO.puts(:stderr, "\e]10;#{fg}\a")
    IO.puts(:stderr, "\e]11;#{bg}\a")
  end

  def available?, do: configured?()

  defp colors(:ok, opts) do
    {
      Map.get(opts, :terminal_pass_background),
      Map.get(opts, :terminal_pass_foreground)
    }
  end

  defp colors(:error, opts) do
    {
      Map.get(opts, :terminal_fail_background),
      Map.get(opts, :terminal_fail_foreground)
    }
  end

  defp configured? do
    key_count =
      Application.get_all_env(:ex_unit_notifier)
      |> Keyword.keys()
      |> Enum.filter(fn k ->
        k in [
          :terminal_pass_background,
          :terminal_pass_foreground,
          :terminal_fail_background,
          :terminal_fail_foreground
        ]
      end)
      |> length()

    key_count == 4
  end
end
