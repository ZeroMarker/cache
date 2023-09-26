Class web.DHCEQCCheckType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "CT_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "CT_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "CT_RowID";

Parameter SQLFILTER = " (CT_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT CT_Desc,
	   CT_RowID,
	   CT_Code
FROM sqluser.DHC_EQCCheckType
where CT_InvalidFlag = 'N' and CT_Desc like nvl(:para,'')||'%'
}

}
