using Godot;
using System;

public partial class ActionPopupContainer : PopupMenu
{
	[Signal] public delegate void PopupCloseEventHandler();
	[Signal] public delegate void SubmitNameEventHandler(string name);
	
	[Export] public Popup PopupRename { get; set; }
	
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		IdPressed += OnIdPressed;
	}

	private void OnIdPressed(long id)
	{
		if (id == 0)
		{
			Hide();
			
			if (PopupRename != null)
			{
				PopupRename.Position = Position;
				PopupRename.Show();
			}
		}
		else if (id == 1)
		{
			EmitSignal(SignalName.PopupClose);
		}
	}

	private void OnNameSubmitted(string name)
	{
		EmitSignal(SignalName.SubmitName, name);;
		PopupRename.Hide();
	}
}
