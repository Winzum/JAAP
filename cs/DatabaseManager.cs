using System.Collections.Generic;
using Microsoft.Data.Sqlite;
using System.IO;

public class DatabaseManager
{
    private static readonly string DbPath = Path.Combine(Directory.GetCurrentDirectory(),"db" , "data.db");
	
	private DatabaseManager() { }
    
    static DatabaseManager()
    {
	    if (File.Exists(DbPath)) return;
	    ExecuteNonQuery("""
	                    CREATE TABLE IF NOT EXISTS "block" (
	                    	"id"	INTEGER NOT NULL UNIQUE,
	                    	"blocktype_id"	INTEGER NOT NULL,
	                    	"canvas_id"	INTEGER NOT NULL,
	                    	"title"	TEXT,
	                    	"text"	TEXT,
	                    	"pos_x"	REAL,
	                    	"pos_y"	REAL,
	                    	"created_at"	TEXT NOT NULL DEFAULT current_timestamp,
	                    	"updated_at"	TEXT NOT NULL DEFAULT current_timestamp,
	                    	PRIMARY KEY("id"),
	                    	CONSTRAINT "block_blocktype" FOREIGN KEY("blocktype_id") REFERENCES "blocktype"("id") on delete restrict on update cascade,
	                    	CONSTRAINT "block_canvas" FOREIGN KEY("canvas_id") REFERENCES "canvas"("id") on delete cascade on update cascade
	                    );
	                    CREATE TABLE IF NOT EXISTS "blocktype" (
	                    	"id"	INTEGER NOT NULL UNIQUE,
	                    	"type"	TEXT NOT NULL UNIQUE,
	                    	PRIMARY KEY("id")
	                    );
	                    CREATE TABLE IF NOT EXISTS "canvas" (
	                    	"id"	INTEGER NOT NULL UNIQUE,
	                    	"created_at"	TEXT NOT NULL DEFAULT current_timestamp,
	                    	"updated_at"	TEXT NOT NULL DEFAULT current_timestamp,
	                    	PRIMARY KEY("id")
	                    );
	                    CREATE TABLE IF NOT EXISTS "link" (
	                    	"id"	INTEGER NOT NULL UNIQUE,
	                    	"block_id"	INTEGER NOT NULL,
	                    	"target_id"	INTEGER,
	                    	"text"	TEXT,
	                    	"char_start"	INTEGER,
	                    	"char_end"	INTEGER,
	                    	"created_at"	TEXT NOT NULL DEFAULT current_timestamp,
	                    	"updated_at"	TEXT NOT NULL DEFAULT current_timestamp,
	                    	PRIMARY KEY("id"),
	                    	CONSTRAINT "link_block" FOREIGN KEY("block_id") REFERENCES "block"("id") on update cascade on delete cascade,
	                    	CONSTRAINT "link_target" FOREIGN KEY("target_id") REFERENCES "block"("id") on update cascade on delete set null
	                    );
	                    INSERT INTO "blocktype" ("id","type") VALUES (1,'highlight');
	                    INSERT INTO "blocktype" ("id","type") VALUES (2,'boolean');
	                    );
	                    """);
    }
    
	// Executes a SQL query and returns the results as a list of dictionaries
    public static List<Dictionary<string, object>> ExecuteReader(string query)
	{
	    var results = new List<Dictionary<string, object>>();
		using var connection = new SqliteConnection($"Data Source={DbPath};");
		connection.Open();
		var command = connection.CreateCommand();
		command.CommandText = query;
		var reader = command.ExecuteReader();
		while (reader.Read())
		{
			var row = new Dictionary<string, object>();
			for (int i = 0; i < reader.FieldCount; i++)
			{
				row[reader.GetName(i)] = reader.GetValue(i);
			}
			results.Add(row);
		}
		return results;
	}
    
    // Executes a non-query SQL command (like CREATE, INSERT, UPDATE, DELETE)
    public static int ExecuteNonQuery(string query)
    {
	    using var connection = new SqliteConnection($"Data Source={DbPath};");
	    connection.Open();
	    
        var command = connection.CreateCommand();
        command.CommandText = query;
        
        return command.ExecuteNonQuery();
    }
    
}