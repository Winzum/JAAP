using Godot;
using System;

public partial class HighlightTextNode : BlockNode
{
	public void Initialize(int canvas_id, float pos_x, float pos_y, string text = "")
	{
		base.Initialize(canvas_id, blocktype_id: 1, pos_x, pos_y, text);
	}

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
