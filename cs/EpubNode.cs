using Godot;
using System;
using System.IO;
using QuickEPUB;

public partial class EpubNode(string bookTitle, string authorName) : Node
{
	private Epub doc = new(bookTitle, authorName);

	public void AddSection(string chapterTitle, string chapterContent)
	{
		// Adding sections of HTML content
		doc.AddSection(chapterTitle, chapterContent);
	}

	public void ExportEpub(string filePath)
	{
		using (var fs = new FileStream(filePath, FileMode.Create))
		{
			doc.Export(fs);
		}
	}
}
