using Godot;

public abstract partial class BlockNode : GraphNode
{
	[Export] public Button CloseButton { get; set; }

	private int BlockId { get; set; }

	protected void Initialize(int canvas_id, int blocktype_id, float pos_x, float pos_y, string text = "")
	{
		var query = $"""
		             insert into "block" ("canvas_id", "blocktype_id", "pos_x", "pos_y", "text")
		             values ({canvas_id}, {blocktype_id}, {pos_x}, {pos_y}, '{text}');
		             """;
		var result = DatabaseManager.ExecuteNonQuery(query);
		if (result > 0)
		{
			var newId = DatabaseManager.ExecuteReader("""
			                                          select id from block
			                                          order by created_at desc
			                                          limit 1;
			                                          """)[0]["id"];
			if (newId != null && int.TryParse(newId.ToString(), out int id))
			{
				BlockId = id;
			}
		}
	}


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		if (CloseButton != null)
		{
			CloseButton.Pressed += _DeleteAndFree;
		}
	}

	private void _DeleteAndFree()
	{
		var query =	 $"""
		             delete from "block"
		             where id = {BlockId};
		             """;
		GD.Print(query);
		var result = DatabaseManager.ExecuteNonQuery(query);
		if (result > 0)
		{
			QueueFree();
		}
	}

}
	