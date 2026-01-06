using Godot;

public partial class HighlightTextNode : BlockNode
{
	private PanelContainer panelContainer;
	private TextEdit panelText;
	private RichTextLabel richTextLabel;

	private void OnTextLabelFocusEntered()
	{
		panelText.Text = richTextLabel.Text;
		
		var viewportSize = GetViewport().GetVisibleRect().Size;
		panelContainer.Size = viewportSize * 0.8f;
		panelContainer.Position = (viewportSize - panelContainer.Size) / 2;
		panelContainer.Show();
		panelText.GrabFocus();
	}

	private void OnPopupPanelFocusExited()
	{
		richTextLabel.Text = panelText.Text;
		Text = richTextLabel.Text;
		Update();
		panelContainer.Hide();
	}

	public void Initialize(int canvas_id, float pos_x, float pos_y, string text = "")
	{
		base.Initialize(canvas_id, blocktype_id: 1, pos_x, pos_y, text);
	}
	
	public override void _Ready()
	{
		base._Ready();
		panelContainer = GetNode<PanelContainer>("CanvasLayer/PanelContainer");
		panelText = panelContainer.GetNode<TextEdit>("TextEdit");
		richTextLabel = GetNode<RichTextLabel>("RichTextLabel");
	}
}