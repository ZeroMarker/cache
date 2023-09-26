Class web.DHCSSUser Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 批准人
ClassMethod GetScheduleApproverStr() As %String
{
	s GroupRowId=1
	s ret=""
	s RowId=0	f  s RowId=$O(^SSU("SSUSR",0,"Group",GroupRowId,RowId)) Q:RowId=""  d
	.s Desc=$P(^SSU("SSUSR",RowId),"^",2)
	.s TRData=RowId_$C(1)_Desc
	.i ret="" s ret=TRData
	.e  s ret=ret_"^"_TRData
	Q ret
}

ClassMethod UserQueryBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 &sql(SELECT SSUSR_Rowid,SSUSR_DefaultDept_DR->CTLoc_Desc,SSUSR_Name into :id,:code,:Name FROM SQLUSER.SS_User where SSUSR_Name =:val) 
 if SQLCODE'=0 quit 0
 set retval=itmjs_"('"_$ZCVT(Name,"O","JS")_"');"
 if itmjsex'="""" set retval=retval_itmjsex_"('"_$ZCVT(id,"O","JS")_"^"_$ZCVT(code,"O","JS")_"^"_$ZCVT(Name,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

Query UserQuery(Name As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT SSUSR_Name AS Name,SSUSR_DefaultDept_DR->CTLoc_Desc As DepartMent,SSUSR_Rowid AS ID FROM SQLUSER.SS_User where SSUSR_Name %STARTSWITH :Name
}

}
