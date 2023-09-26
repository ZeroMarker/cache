Import SQLUser

Class web.DHCEQCFaultCase Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "FC_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "FC_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "FC_RowID";

Parameter SQLFILTER = " (FC_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT FC_Desc,
	   FC_RowID,
	   FC_Code
FROM sqluser.DHC_EQCFaultCase
where FC_InvalidFlag = 'N' and FC_Desc like nvl(:para,'')||'%'
}

}
