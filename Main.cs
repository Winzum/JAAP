using System;
using Godot;

public partial class Main : Control
{
	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var reader = DatabaseManager.ExecuteReader("SELECT * FROM canvas");
		foreach (var row in reader)
		{
			foreach (var kvp in row)
			{
				GD.Print($"{kvp.Key}: {kvp.Value}");
			}
		}
	}	

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
