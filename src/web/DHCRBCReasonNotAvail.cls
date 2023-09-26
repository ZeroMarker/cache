Class web.DHCRBCReasonNotAvail Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod DoctorStopReasonBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 &sql(SELECT %ID,RNAV_Code,RNAV_Desc into :id,:code,:Name FROM SQLUSER.RBC_ReasonNotAvail where RNAV_Code =:val) 
 if SQLCODE'=0 quit 0
 set retval=itmjs_"('"_$ZCVT(Name,"O","JS")_"');"
 if itmjsex'="""" set retval=retval_itmjsex_"('"_$ZCVT(id,"O","JS")_"^"_$ZCVT(code,"O","JS")_"^"_$ZCVT(Name,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod GetStopReasonStr() As %String
{
	s ret="" ,Sttime="",Endtime=""
	s RowId=0	f  s RowId=$O(^RBC("NA",RowId)) Q:RowId=""  d
	.s Sttime=$P(^RBC("NA",RowId),"^",4)
	.s Endtime=$P(^RBC("NA",RowId),"^",5)
	.q:Sttime>(+$H)
	.q:(Endtime<(+$H))&&(Endtime'="")
	.s Desc=$P(^RBC("NA",RowId),"^",2)
	.s TRData=RowId_$C(1)_Desc
	.i ret="" s ret=TRData
	.e  s ret=ret_"^"_TRData
	Q ret
}

Query DoctorStopReason() As %SQLQuery(CONTAINID = 1)
{
SELECT RNAV_Desc AS NAME,RNAV_Code AS CODE,%ID AS ID  
FROM SQLUSER.RBC_ReasonNotAvail
}

/// lxz
/// User User.PACApptBookingSystem 
/// Desc 补全预约时候外部预约机构通过Code查询
ClassMethod GetBookingSystemByCode(Code As %String) As %String
{
	s Code=$ZCVT(Code,"U")
	s RowID=$O(^PAC("APPTBS",0,"Code",Code,""))
	Q RowID
}

}
