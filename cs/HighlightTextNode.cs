using Godot;

public partial class HighlightTextNode : BlockNode
{
	private PanelContainer panelContainer;
	private TextEdit panelText;
	private RichTextLabel richTextLabel;
	private PopupMenu highlightPopupMenu;
	
	public void Initialize(int canvasId, Vector2 position, string text = "")
	{
		base.Initialize(canvasId, blocktypeId: 1, position, text);
	}


	private void _OnTextLabelFocusEntered()
	{
		panelText.Text = richTextLabel.Text;
		
		var viewportSize = GetViewport().GetVisibleRect().Size;
		panelContainer.Size = viewportSize * 0.8f;
		panelContainer.Position = (viewportSize - panelContainer.Size) / 2;
		panelContainer.Show();
		panelText.GrabFocus();
	}

	private void _OnPopupPanelFocusExited()
	{
		richTextLabel.Text = panelText.Text;
		Text = richTextLabel.Text;
		Update();
		panelContainer.Hide();
	}
	
	private void _OnTextEditGuiInput(InputEvent @event)
	{
		if (@event is InputEventMouseButton mouseEvent && mouseEvent.Pressed &&
		    mouseEvent.ButtonIndex == MouseButton.Right)
		{
			GD.Print("Clicked on right mouse button");
			highlightPopupMenu.Position = (Vector2I)GetViewport().GetMousePosition();
			highlightPopupMenu.Show();
			highlightPopupMenu.GrabFocus();
			AcceptEvent();
		}

	}
	
	public override void _Ready()
	{
		base._Ready();
		panelContainer = GetNode<PanelContainer>("CanvasLayer/PanelContainer");
		panelText = panelContainer.GetNode<TextEdit>("TextEdit");
		richTextLabel = GetNode<RichTextLabel>("RichTextLabel");
		highlightPopupMenu = GetNode<PopupMenu>("HighlightPopupMenu");
	}
}