using Godot;

public abstract partial class BlockNode : GraphNode
{
	[Export] public Button CloseButton { get; set; }
	[Export] public ActionPopupContainer ActionPopup { get; set; }

	private int BlockId { get; set; }
	protected float PosX { get; set; }
	protected float PosY { get; set; }
	protected string Text { get; set; }
	
	private GraphEdit GraphEdit { get; set; }
	
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
			//TODO raise error if newId is null
			if (newId != null && int.TryParse(newId.ToString(), out int id))
			{
				BlockId = id;
				PosX = pos_x;
				PosY = pos_y;
				Text = text;
				GD.Print(PositionOffset);
			}
		}
	}

	protected void Update()
	{
		var query = $"""
		             update "block"
		             set pos_x = {PosX},
		                 pos_y = {PosY},
		                 text = '{Text}',
		                 title = '{Title}',
		                 updated_at = current_timestamp
		             where id = {BlockId};
		             """;
		GD.Print(query);
		var result = DatabaseManager.ExecuteNonQuery(query);
		if (result > 0)
		{
			GD.Print("Block updated successfully.");
		}
	}

	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		GraphEdit = GetParent<GraphEdit>();
		if (CloseButton != null)
		{
			CloseButton.Pressed += _DeleteAndFree;
		}
		
		if (ActionPopup != null)
		{
			GuiInput += _OnGuiInput;
			ActionPopup.PopupClose += _DeleteAndFree;
			ActionPopup.SubmitName += (string name) =>
			{
				Title = name;
				Update();
			};
		}
	}
	
	private void _OnGuiInput(InputEvent @event)
	{
		// On right click
		if (@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed && mouseEvent.ButtonIndex == MouseButton.Right)
		{
			var popupLocation = GetGlobalTransform().Origin + (mouseEvent.Position * GraphEdit.Zoom);
			ActionPopup.Position = new Vector2I((int)popupLocation.X, (int)popupLocation.Y);
			ActionPopup.Show();
			GD.Print($"Showing popup at: {ActionPopup.Position}");
			AcceptEvent();
		}
	}
	
	private void _DeleteAndFree()
	{
		var query =	 $"""
		             delete from "block"
		             where id = {BlockId};
		             """;
		var result = DatabaseManager.ExecuteNonQuery(query);
		if (result > 0)
		{
			QueueFree();
		}
	}

}
	