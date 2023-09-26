Class web.DHCEQCAffixCat Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 7;

Parameter SQLCODE = "AC_Code";

Parameter SQLDATEFROM;

Parameter SQLFILTER = " (AC_InvalidFlag = 'N') ";

Parameter SQLDATETO;

Parameter SQLDESCRIPTION = "AC_Desc";

Parameter SQLROWID = "AC_RowID";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT AC_Desc,
	   AC_RowID,
	   AC_Code
FROM sqluser.DHC_EQCAffixCat
where AC_InvalidFlag = 'N' and AC_Desc like nvl(:para,'')||'%'
}

}
