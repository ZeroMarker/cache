Class web.DHCEQCInspectResult Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "IR_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "IR_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "IR_RowID";

Parameter SQLFILTER = " (IR_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT IR_Desc,
	   IR_RowID,
	   IR_Code
FROM sqluser.DHC_EQCInspectResult
where IR_InvalidFlag = 'N' and IR_Desc like nvl(:para,'')||'%'
}

}
