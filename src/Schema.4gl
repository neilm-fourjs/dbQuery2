
IMPORT os
IMPORT FGL g2_lib

PUBLIC TYPE sch RECORD
		name STRING,
		no_of_tabs SMALLINT,
		tabs DYNAMIC ARRAY OF RECORD
			tabname STRING,
			cols DYNAMIC ARRAY OF RECORD
				colname STRING,
				colTypeNo SMALLINT,
				coltype STRING,
				colLength STRING,
				nulls BOOLEAN
			END RECORD
		END RECORD
	END RECORD

PUBLIC FUNCTION (this sch) open( l_fileName STRING )
	DEFINE c base.Channel
	DEFINE cols RECORD
		tabname STRING,
		colname STRING,
		coltype SMALLINT,
		collength SMALLINT,
		colno SMALLINT
	END RECORD
	DEFINE l_colNo SMALLINT
	DEFINE l_prevTab STRING = "."

	IF NOT os.path.exists( l_fileName ) THEN
		CALL g2_lib.g2_winMessage("Error",SFMT("'%1' doesn't exist!",l_fileName),"exclamation")
		RETURN
	END IF

	LET c = base.Channel.create()
	CALL c.setDelimiter("^")
	TRY
		CALL c.openFile(l_fileName,"r")
	CATCH
		CALL g2_lib.g2_winMessage("Error",SFMT("Failed to open %1",l_fileName),"exclamation")
		RETURN
	END TRY
	LET this.name = l_fileName
	LET this.no_of_tabs = 0
	WHILE c.read(cols)
		IF l_prevTab != cols.tabname THEN
			LET this.no_of_tabs = this.no_of_tabs + 1
			LET l_colNo = 0
			LET this.tabs[ this.no_of_tabs ].tabname = cols.tabname
		END IF
		LET l_colNo = l_colNo + 1
		LET this.tabs[ this.no_of_tabs ].cols[ l_colNo ].colname = cols.colname
		LET this.tabs[ this.no_of_tabs ].cols[ l_colNo ].coltypeNo = cols.coltype
		LET this.tabs[ this.no_of_tabs ].cols[ l_colNo ].coltype = sch_getColType(cols.coltype, cols.collength)
		LET this.tabs[ this.no_of_tabs ].cols[ l_colNo ].colLength = cols.collength
	END WHILE
	CALL c.close()

END FUNCTION
--------------------------------------------------------------------------------------------------------------
FUNCTION sch_getColType(l_typ SMALLINT,l_len SMALLINT) RETURNS STRING
	DEFINE l_si INTEGER
	DEFINE l_ctyp CHAR(40)
	DEFINE l_tmp,l_tmp2 DECIMAL(8,2)
	
	CASE l_typ
		WHEN 0
			LET l_ctyp = "CHAR(",l_len USING "<<<<<",")"
		WHEN 1
			LET l_ctyp = "SMALLINT"
		WHEN 2
			LET l_ctyp = "INTEGER"
		WHEN 3
			LET l_ctyp = "FLOAT"
		WHEN 4
			LET l_ctyp = "SMALLFLOAT"
		WHEN 6
			LET l_ctyp = "SERIAL"
		WHEN 5
			LET l_si = l_len / 256
			LET l_len = l_len - ( l_si * 256 )
			IF l_len = 255 THEN
				LET l_ctyp = "INTEGER"
			ELSE
				LET l_ctyp = "DECIMAL(",l_si USING "<<<<",",",l_len USING "<<<<&",")"
			END IF
		WHEN 7
			LET l_ctyp = "DATE"
		WHEN 8
			LET l_si = l_len / 256
			LET l_len = l_len - ( l_si * 256 )
			LET l_ctyp = "MONEY(",l_si USING "<<<<",",",l_len USING "<<<<&",")"
		WHEN 10
			LET l_ctyp = "DATETIME"
			LET l_tmp = l_len MOD 16
			LET l_tmp2 = ((l_len - l_tmp) MOD 256 ) / 16
			CASE l_tmp2
				WHEN	0 LET l_ctyp = l_ctyp CLIPPED," YEAR TO"
				WHEN	2 LET l_ctyp = l_ctyp CLIPPED," MONTH TO"
				WHEN	4 LET l_ctyp = l_ctyp CLIPPED," DAY TO"
				WHEN	6 LET l_ctyp = l_ctyp CLIPPED," HOUR TO"
				WHEN	8 LET l_ctyp = l_ctyp CLIPPED," MINUTE TO"
				WHEN 10 LET l_ctyp = l_ctyp CLIPPED," SECOND TO"
				OTHERWISE
				LET l_ctyp = l_ctyp CLIPPED," 2(",l_tmp2,")"
			END CASE
			CASE l_tmp
				WHEN	0 LET l_ctyp = l_ctyp CLIPPED," YEAR"
				WHEN	2 LET l_ctyp = l_ctyp CLIPPED," MONTH"
				WHEN	4 LET l_ctyp = l_ctyp CLIPPED," DAY"
				WHEN	6 LET l_ctyp = l_ctyp CLIPPED," HOUR"
				WHEN	8 LET l_ctyp = l_ctyp CLIPPED," MINUTE"
				WHEN 10 LET l_ctyp = l_ctyp CLIPPED," SECOND"
				WHEN 15 LET l_ctyp = l_ctyp CLIPPED," FRACTION(5)"
				OTHERWISE
				LET l_ctyp = l_ctyp CLIPPED," (",l_tmp,")"
			END CASE
		WHEN 11
			LET l_ctyp = "TEXT"
		WHEN 12
			LET l_ctyp = "BYTE"
		WHEN 13
			LET l_ctyp = "VARCHAR(",l_len USING "<<<<<",")"
		WHEN 14
			LET l_ctyp = "INTERVAL"
			LET l_tmp = l_len MOD 16
			LET l_tmp2 = ((l_len - l_tmp) MOD 256 ) / 16
			DISPLAY "Len:",l_len, " l_tmp:",l_tmp, " l_tmp2:",l_tmp2
			CASE l_tmp2
				WHEN	0 LET l_ctyp = l_ctyp CLIPPED," YEAR TO"
				WHEN	2 LET l_ctyp = l_ctyp CLIPPED," MONTH TO"
				WHEN	4 LET l_ctyp = l_ctyp CLIPPED," DAY(4) TO"
				WHEN	6 LET l_ctyp = l_ctyp CLIPPED," HOUR TO"
				WHEN	8 LET l_ctyp = l_ctyp CLIPPED," MINUTE TO"
				WHEN 10 LET l_ctyp = l_ctyp CLIPPED," SECOND TO"
			END CASE
			CASE l_tmp
				WHEN	0 LET l_ctyp = l_ctyp CLIPPED," YEAR"
				WHEN	2 LET l_ctyp = l_ctyp CLIPPED," MONTH"
				WHEN	4 LET l_ctyp = l_ctyp CLIPPED," DAY"
				WHEN	6 LET l_ctyp = l_ctyp CLIPPED," HOUR"
				WHEN	8 LET l_ctyp = l_ctyp CLIPPED," MINUTE"
				WHEN 10 LET l_ctyp = l_ctyp CLIPPED," SECOND"
				WHEN 15 LET l_ctyp = l_ctyp CLIPPED," FRACTION(5)"
				OTHERWISE
				LET l_ctyp = l_ctyp CLIPPED," (",l_tmp,")"
			END CASE
	END CASE

	RETURN l_ctyp

END FUNCTION
