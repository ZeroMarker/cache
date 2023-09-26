Class web.DHCTimeRange Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod TimeRangeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 &sql(SELECT TR_Rowid,TR_Code,TR_Desc,{fn CONVERT(TR_StartTime,SQL_VARCHAR)},{fn CONVERT(TR_EndTime,SQL_VARCHAR)} into :id,:code,:Name,:StartTime,:EndTime FROM SQLUSER.DHC_TimeRange where TR_Code =:val) 
 if SQLCODE'=0 quit 0
 set retval=itmjs_"('"_$ZCVT(Name,"O","JS")_"');"
 if itmjsex'="""" set retval=retval_itmjsex_"('"_$ZCVT(id,"O","JS")_"^"_$ZCVT(code,"O","JS")_"^"_$ZCVT(Name,"O","JS")_"^"_$ZCVT(StartTime,"O","JS")_"^"_$ZCVT(EndTime,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

Query TimeRangeQuery(Name As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT TR_Desc AS NAME,TR_Code AS CODE,TR_Rowid AS ID,{fn CONVERT(TR_StartTime,SQL_VARCHAR)} As StartTime,{fn CONVERT(TR_EndTime,SQL_VARCHAR)} As EndTime FROM SQLUSER.DHC_TimeRange where TR_Desc %STARTSWITH :Name
}

}
