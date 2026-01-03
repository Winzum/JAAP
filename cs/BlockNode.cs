using Godot;

public abstract partial class BlockNode : GraphNode
{
	protected void Initialize(int canvas_id, int blocktype_id, float pos_x, float pos_y, string text = "")
	{
		var reader = DatabaseManager.ExecuteReader("SELECT name FROM sqlite_master WHERE type='table';");
		foreach (var row in reader)  
		{  
			foreach (var kvp in row)  
			{  
				GD.Print($"{kvp.Key}: {kvp.Value}");  
			}  
		}
		
		var query = $"""
		             insert into "block" ("canvas_id", "blocktype_id", "pos_x", "pos_y", "text")
		             values ({canvas_id}, {blocktype_id}, {pos_x}, {pos_y}, '{text}');
		             """;
		GD.Print(query);
		var queryresult = DatabaseManager.ExecuteNonQuery(query);
		GD.Print("here2");
		GD.Print(queryresult);
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
