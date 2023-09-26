Import SQLUser

Class web.DHCEQEquipStatus Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "ES_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "ES_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "ES_RowID";

Parameter SQLFILTER = " (ES_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Desc:%String,HIDDEN:%String,Code:%String")
{
SELECT ES_Desc,
	   ES_RowID,
	   ES_Code
FROM sqluser.DHC_EQEquipStatus
where ES_InvalidFlag = 'N' and ES_Desc like nvl(:para,'')||'%'
}

}
