Import SQLUser

Class web.DHCEQCOrigin Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "O_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "O_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "O_RowID";

Parameter SQLFILTER = " (O_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String:设备来源,HIDDEN:%String,Code:%String:编码")
{
SELECT O_Desc,
	   O_RowID,
	   O_Code
FROM sqluser.DHC_EQCOrigin
where O_InvalidFlag = 'N' and O_Desc like nvl(:para,'')||'%'
}

}
