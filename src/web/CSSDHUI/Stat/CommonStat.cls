Class web.CSSDHUI.Stat.CommonStat Extends (%RegisteredObject, web.CSSDHUI.CSSDType) [ Not ProcedureBlock ]
{

/// Creator:ban
/// Date:2020-2-18
/// Description: 获取当前日期:报表日期返回当前时间
/// Input:  
/// w ##class(%ResultSet).RunQuery("web.CSSDHUI.Stat.CommonStat","GetDate")
Query GetDate() As web.CSSDHUI.Query(ROWSPEC = "NowDate") [ SqlProc ]
{
}

ClassMethod GetDateExecute(ByRef qHandle As %Binary) As %Status
{
	n (qHandle)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s edate=$zdt($h,3)
	s etime=$p($h,",",2)
	s dateF=..DH2L(edate)
	s dateDF=..DL2H(dateF)
	s etime=..TL2H(etime)
	s NowDate=dateDF_" "_etime
	d OutPut
 	Quit $$$OK
	
OutPut
 s Data=$lb(NowDate)   
 s ^CacheTemp(repid,ind)=Data
 s ind=ind+1
 q
}

}
