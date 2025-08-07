using Godot;
using System;
using System.IO;
using QuickEPUB;

public partial class EpubExport : Node
{
	public void PrintNTimes(string msg, int n)
	{
		for (int i = 0; i < n; ++i)
		{
			GD.Print(msg);
		}
	}
	
	public void WriteBook()
	{
		// Create an Epub instance
		var doc = new Epub("Book Title", "Author Name");
		// Adding sections of HTML content
		doc.AddSection("Chapter 1", "<p>Lorem ipsum dolor sit amet...</p>");
		//// Adding sections of HTML content (that reference image files)
		//doc.AddSection("Chapter 2", "<p><img src=\"image.jpg\" alt=\"Image\"/></p>");
		//// Adding images that are referenced in any of the sections
		//using (var jpgStream = new FileStream("image.jpg", FileMode.Open))
		//{
			//doc.AddResource("image.jpg", EpubResourceType.JPEG, jpgStream);
		//}
		//// Adding sections of HTML content (that use a custom CSS stylesheet)
		//doc.AddSection("Chapter 3", "<p class=\"body-text\">Lorem ipsum dolor sit amet...</p>", "custom.css");
		//// Add the CSS file referenced in the HTML content
		//using (var cssStream = new FileStream("custom.css", FileMode.Open))
		//{
			//doc.AddResource("custom.css", EpubResourceType.CSS, cssStream);
		//}
		// Export the result
		using (var fs = new FileStream("sample.epub", FileMode.Create))
		{
			doc.Export(fs);
		}	
	}
}
