
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
IMPORT FGL g2_getFileName
IMPORT FGL glm_mkForm
IMPORT FGL glm_sql
IMPORT FGL glm_ui
IMPORT FGL Schema

CONSTANT C_PRGVER="3.2"
CONSTANT C_PRGDESC = "dbQuery2 Demo"
CONSTANT C_PRGAUTH = "Neil J.Martin"
CONSTANT C_PRGICON = "logo_dark"

DEFINE m_appInfo g2_appInfo.appInfo
DEFINE m_db g2_db.dbInfo
DEFINE m_table STRING
DEFINE m_schemaPath STRING = "../etc"
DEFINE m_sch sch
MAIN
  CALL m_appInfo.progInfo(C_PRGDESC, C_PRGAUTH, C_PRGVER, C_PRGICON)
  CALL g2_lib.g2_init(ARG_VAL(1), "dbQuery2")

	CALL initArgs()
	DISPLAY SFMT("Args DB: %1 Table: %2 DBANME Env: %3", m_db.name, m_table, fgl_getEnv("DBNAME") )
	IF m_db.name IS NULL OR m_db.name = "ASK" THEN
		LET m_db.name = g2_getFileName.g2_getFileName(m_schemaPath, "sch", "DB Schemas","Schema")
	END IF
	IF m_db.name IS NULL THEN DISPLAY "No db selected" EXIT PROGRAM END IF
	DISPLAY SFMT("DB: %1 Table: %2", m_db.name, NVL(m_table,"NULL") )

	CALL m_sch.open( os.path.join(m_schemaPath,m_db.name||".sch") )

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