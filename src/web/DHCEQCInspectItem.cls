Import SQLUser

Class web.DHCEQCInspectItem Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 12;

Parameter SQLCODE = "II_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "II_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "II_RowID";

Parameter SQLFILTER = " (II_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT II_Desc,
	   II_RowID,
	   II_Code
FROM sqluser.DHC_EQCInspectItem
where II_InvalidFlag = 'N' and II_Desc like nvl(:para,'')||'%'
}

}
