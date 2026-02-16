using Godot;

public abstract partial class BlockNode : GraphNode
{
	[Export] public Button CloseButton { get; set; }
	[Export] public ActionPopupContainer ActionPopup { get; set; }

	private int BlockId { get; set; }
	protected string Text { get; set; }
	
	private GraphEdit GraphEdit { get; set; }
	
	protected void Initialize(int canvasId, int blocktypeId, Vector2 position, string text = "")
	{
		var query = $"""
		             insert into "block" ("canvas_id", "blocktype_id", "position", "text")
		             values ({canvasId}, {blocktypeId}, '{position}', '{text}');
		             """;
		GD.Print(query);
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
				Text = text;
			}
		}
	}

	protected void Update()
	{
		var query = $"""
		             update "block"
		             set position = '{PositionOffset}',
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
		
		PositionOffsetChanged += _OnPositionOffsetChanged;
		
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
	
	private void _OnPositionOffsetChanged()
	{
		Update();
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
		GD.Print(query);
		var result = DatabaseManager.ExecuteNonQuery(query);
		if (result > 0)
		{
			QueueFree();
		}
	}

}
	