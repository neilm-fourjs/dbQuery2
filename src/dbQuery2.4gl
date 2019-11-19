
-- A Basic dynamic stock maintenance program.
-- Does: find, update, insert, delete
-- To Do: locking, sample, listing report

IMPORT util
IMPORT os
IMPORT FGL g2_lib
IMPORT FGL g2_appInfo
IMPORT FGL g2_about
IMPORT FGL g2_db
IMPORT FGL g2_lib
IMPORT FGL g2_db
IMPORT FGL g2_simpleLookup
IMPORT FGL glm_mkForm
IMPORT FGL glm_sql
IMPORT FGL glm_ui

CONSTANT C_PRGVER="3.2"
CONSTANT C_PRGDESC = "dbQuery2 Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

DEFINE m_appInfo g2_appInfo.appInfo
DEFINE m_db g2_db.dbInfo
DEFINE m_table STRING
DEFINE m_schemaPath STRING = "../etc"
MAIN

  CALL m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
  CALL g2_lib.g2_init(ARG_VAL(1), "dbQuery2")

	CALL initArgs()
	DISPLAY SFMT("Args DB: %1 Table: %2", m_db.name, m_table )
	IF m_db.name IS NULL OR m_db.name = "ASK" THEN LET m_db.name = getDBName() END IF
	IF m_db.name IS NULL THEN DISPLAY "No db selected" EXIT PROGRAM END IF

-- setup and connect to DB
  CALL m_db.g2_connect(m_db.name)

	IF m_table = "ASK" THEN
		LET m_table = selectTable()
	END IF

	DISPLAY SFMT("DB: %1 Table: %2", m_db.name, NVL(m_table,"NULL") )

	IF m_table IS NOT NULL THEN
		CALL queryTable(m_table)
	END IF

	IF m_table IS NULL THEN
		CALL queryDB()
	END IF

END MAIN
--------------------------------------------------------------------------------------------------------------
-- Process the position dependant command line args
FUNCTION initArgs() RETURNS ()
	IF base.Application.getArgumentCount() = 0 THEN RETURN END IF
	IF base.Application.getArgumentCount() > 0 THEN
		LET m_db.name = base.Application.getArgument(1)
	END IF
	IF base.Application.getArgumentCount() > 1 THEN
		LET m_table = base.Application.getArgument(2)
	END IF
END FUNCTION
--------------------------------------------------------------------------------------------------------------
-- Do a simple list of db schema files and return selected name
FUNCTION getDBName() RETURNS STRING
	DEFINE l_dbName, l_path STRING
	DEFINE d INT
	DEFINE sl g2_simpleLookup.simpleLookup
	CALL os.Path.dirSort("name", 1)
	LET d = os.Path.dirOpen(m_schemaPath)
	IF d > 0 THEN
		WHILE TRUE
			LET l_path = os.Path.dirNext(d)
			IF l_path IS NULL THEN EXIT WHILE END IF
			IF os.path.isDirectory(l_path) THEN CONTINUE WHILE END IF
			IF os.path.extension(l_path) != "sch" THEN CONTINUE WHILE END IF
			LET sl.arr[ sl.arr.getLength() + 1 ].desc = os.path.rootName( l_path )
		END WHILE
	END IF
	IF sl.arr.getLength() = 0 THEN
		CALL g2_lib.g2_winMessage("Error",SFMT("No Schema files found in %1",m_schemaPath),"exclamation")
		RETURN NULL
	END IF
	LET sl.keyTitle = "_"
	LET sl.descTitle = "Schema"
	LET sl.title = "Schemas"
	LET l_dbName = sl.g2_simpleLookup()
	DISPLAY SFMT("DB: %1 Selected", NVL(l_dbName, "NULL"))
	RETURN l_dbName
END FUNCTION
--------------------------------------------------------------------------------------------------------------
-- Do a simple list of tables and allow selection.
FUNCTION selectTable() RETURNS STRING
	DEFINE l_table STRING
	RETURN l_table
END FUNCTION
--------------------------------------------------------------------------------------------------------------
-- Genero a form for the table and query the data.
FUNCTION queryTable(l_table STRING) RETURNS ()
END FUNCTION
--------------------------------------------------------------------------------------------------------------
-- Present the layout and table list and area for table.
FUNCTION queryDB() RETURNS ()
END FUNCTION