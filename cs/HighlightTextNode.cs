public partial class HighlightTextNode : BlockNode
{
	public void Initialize(int canvas_id, float pos_x, float pos_y, string text = "")
	{
		base.Initialize(canvas_id, blocktype_id: 1, pos_x, pos_y, text);
	}
	
}