Import SQLUser

Class web.DHCEQCAppendFeeType Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "AFT_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "AFT_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "AFT_RowID";

Parameter SQLFILTER = " (AFT_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT AFT_Desc,
	   AFT_RowID,
	   AFT_Code
FROM sqluser.DHC_EQCAppendFeeType
where AFT_InvalidFlag = 'N' and AFT_Desc like nvl(:para,'')||'%'
}

}
