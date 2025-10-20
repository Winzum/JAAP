using System;
using Microsoft.Data.Sqlite;
using System.IO;

public class DatabaseManager
{
    private static readonly string DbPath = Path.Combine(Directory.GetCurrentDirectory(),"db" , "data.db");

    static DatabaseManager()
    {
        if (File.Exists(DbPath)) return;
        using var connection = new SqliteConnection($"Data Source={DbPath}");
        connection.Open();
        var command = connection.CreateCommand();
        command.CommandText = """
                              CREATE TABLE IF NOT EXISTS "block" (
                              	"id"	INTEGER NOT NULL UNIQUE,
                              	"canvas_id"	INTEGER NOT NULL,
                              	"text"	TEXT,
                              	"pos_x"	REAL,
                              	"pos_y"	REAL,
                              	"created_at"	TEXT NOT NULL DEFAULT current_timestamp,
                              	"updated_at"	TEXT NOT NULL DEFAULT current_timestamp,
                              	PRIMARY KEY("id"),
                              	CONSTRAINT "block_canvas" FOREIGN KEY("canvas_id") REFERENCES "canvas"("id") on delete cascade on update cascade
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
                              """;
        command.ExecuteNonQuery();
    }
}