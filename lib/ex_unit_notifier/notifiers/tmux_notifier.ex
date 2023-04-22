defmodule ExUnitNotifier.Notifiers.TmuxNotifier do
  @moduledoc false

  def notify(status, _message, opts) do
    # tmux set-window-option -t"$TMUX_PANE" window-status-style bg=red
    System.cmd("tmux", [
      "set-window-option",
      "-t#{tmux_pane()}",
      "window-status-style",
      style(status, opts)
    ])
  end

  def available?, do: tmux_pane() != nil

  defp style(:ok, opts) do
    Map.get(opts, :tmux_pass_style, "bg=green")
  end

  defp style(:error, opts) do
    Map.get(opts, :tmux_fail_style, "bg=red")
  end

  defp tmux_pane, do: System.get_env("TMUX_PANE")
end
