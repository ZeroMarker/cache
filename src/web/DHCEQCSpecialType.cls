Class web.DHCEQCSpecialType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 9;

Parameter SQLCODE = "ST_Code";

Parameter SQLDATEFROM;

Parameter SQLFILTER = " (ST_InvalidFlag = 'N') ";

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "ST_Desc";

Parameter SQLROWID = "ST_RowID";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT ST_Desc,
	   ST_RowID,
	   ST_Code
FROM sqluser.DHC_EQCSpecialType
where ST_InvalidFlag = 'N' and ST_Desc like nvl(:para,'')||'%'
}

}
