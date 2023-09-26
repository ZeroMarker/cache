Import sqluser

/// Descript:系统错误日志相关
/// Creater:	LiMingzhong
/// CreateDate:	2012-06-13
Class web.DHCSTMHUI.ErrorRecord Extends (%RegisteredObject, %XML.Adaptor, StkTypeM) [ Not ProcedureBlock ]
{

/// Descript:	查询系统错误日志信息
/// Creater:	LiMingzhong
/// CreateDate:	2012-06-13
/// Table:DHC_StkSysErrorRecord
/// Input:起始日期,截止日期
/// Output:		
/// Return：系统错误日志信息
/// Others: d ##class(web.DHCSTMHUI.ErrorRecord).SelectAll("2013-06-12","2014-06-13")    AppType表示类组类型
ClassMethod SelectAll(startDate, endDate) As %String
{
	n (startDate,endDate)
	
	s startDate = $ZDH(startDate,3)
	s endDate = $ZDH(endDate,3)
	s Type=..sssCode()
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DHCSTER_RowId as RowId,DHCSTER_Date as STERDate,DHCSTER_Time as STERTime,DHCSTER_App as App,DHCSTER_ErrInfo as ErrInfo,DHCSTER_KeyValue as KValue,DHCSTER_ErrorTrigger as Trigger,DHCSTER_IP as IP,DHCSTER_SSUSR_DR as UserDr,DHCSTER_BrowserInfo as BrowserInfo from DHC_StkSysErrorRecord where DHCSTER_Date>="_startDate_" and DHCSTER_Date<="_endDate_" and DHCSTER_StkType='"_Type_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s titleStr="RowId^Date^Time^AppName^ErrInfo^KValue^Trigger^IP^UserName^BrowserInfo"
	w "{results:"_count_",rows:["
	While(result.Next())
	{	
		s UserName="",AppName=""
		s RowId = result.Data("RowId")
		s Date = result.Data("STERDate")
		s Time = result.Data("STERTime")
		s App = result.Data("App")
		s:App>0 AppName = $P(^DHCSSA(App),"^",2)
		
	    s AppType=""                          
		s:+App>0 AppType = $P(^DHCSSA(App),"^",3) 
		continue:AppType'=..sssCode()              ///..sssCode()  继承的StkType中的方法
		
		s ErrInfo = result.Data("ErrInfo")
		s KValue = result.Data("KValue")
		s Trigger = result.Data("Trigger")
		s IP = result.Data("IP")
		s UserDr = result.Data("UserDr")
		s:UserDr'="" UserName = $P(^SSU("SSUSR",UserDr),"^",2)
		s BrowserInfo = result.Data("BrowserInfo")
		
		s:Date'="" Date=..DL2H(Date)
		s:Time'="" Time=..TL2H(Time)
		
		s tmp=RowId_"^"_Date_"^"_Time_"^"_AppName_"^"_ErrInfo_"^"_KValue_"^"_Trigger_"^"_IP_"^"_UserName_"^"_BrowserInfo
		s count = count+1	
		i count=1 d
		.w ##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmp,titleStr)  ///json:extjs的grid, 对后台数据通过json方式解析
		e  d
		.w ","_##class(web.DHCSTMHUI.Common.UtilCommon).GetJsonStr(tmp,titleStr)
	}
	d result.Close()
	w "]}"
	q
}

/// Descript:取某一条系统错误日志信息
/// Creater:zhangdongmei
/// CreateDate:	2012-10-19
/// Table:DHC_StkSysErrorRecord
/// Input:id
/// Output:		
/// Return：系统错误日志信息
/// Others: 
ClassMethod GetErrorInfo(Rowid) As %String
{
	n (Rowid)
	q:Rowid="" ""
	s KeyValue=$p(^DHCSTERROR(Rowid),$c(1),5)
	s ErrorInfo=$p(^DHCSTERROR(Rowid),$c(1),4)
	q KeyValue_"-"_ErrorInfo
}

/// d ##class(%ResultSet).RunQuery("web.DHCSTMHUI.ErrorRecord","Query","{""StartDate"":""04/03/2019"",""gUserId"":""873"",""gLocId"":""153"",""gGroupId"":""98"",""gHospId"":""2"",""EndDate"":""28/03/2019""}")
Query Query(Params As %String) As Query(ROWSPEC = "RowId,Date,Time,AppName,ErrInfo,KValue,Trigger,IP,UserName,BrowserInfo") [ SqlProc ]
{
}

ClassMethod QueryExecute(ByRef qHandle As %Binary, Params As %String) As %Status
{
	n (qHandle, Params)
	s repid=$I(^CacheTemp)
	s ind=1
	s qHandle=$lb(0,repid,0)
	s PJobj=##class(web.DHCSTMHUI.Common.FromJson).%New()
	d PJobj.%FromJSON(Params)
	s StartDate=PJobj.%Get("StartDate")
	s EndDate=PJobj.%Get("EndDate")
	s:StartDate'="" StartDate=..DH2L(StartDate)
	s:EndDate'="" EndDate=..DH2L(EndDate)
	s Type=..sssCode()
	s result = ##class(%Library.ResultSet).%New()
	d result.RuntimeModeSet(0)
	s sqlStr = "select DHCSTER_RowId as RowId," 
	s sqlStr = sqlStr_"DHCSTER_Date as STERDate,"
	s sqlStr = sqlStr_"DHCSTER_Time as STERTime,"
	s sqlStr = sqlStr_"DHCSTER_App as App,"
	s sqlStr = sqlStr_"DHCSTER_ErrInfo as ErrInfo,"
	s sqlStr = sqlStr_"DHCSTER_KeyValue as KValue,"
	s sqlStr = sqlStr_"DHCSTER_ErrorTrigger as Trigger,"
	s sqlStr = sqlStr_"DHCSTER_IP as IP,"
	s sqlStr = sqlStr_"DHCSTER_SSUSR_DR as UserDr,"
	s sqlStr = sqlStr_"DHCSTER_BrowserInfo as BrowserInfo "
	s sqlStr = sqlStr_" from DHC_StkSysErrorRecord"
	s sqlStr = sqlStr_" where DHCSTER_Date>="_StartDate_" and DHCSTER_Date<="_EndDate
	s sqlStr = sqlStr_" and DHCSTER_StkType='"_Type_"'"
	d result.Prepare(sqlStr)
	d result.Execute()
	While(result.Next())
	{	
		s UserName="",AppName=""
		s RowId = result.Data("RowId")
		s Date = result.Data("STERDate")
		s Time = result.Data("STERTime")
		s App = result.Data("App")
		s:App>0 AppName = $P(^DHCSSA(App),"^",2)
		
	    s AppType=""                          
		s:+App>0 AppType = $P(^DHCSSA(App),"^",3) 
		continue:AppType'=..sssCode()              ///..sssCode()  继承的StkType中的方法
		
		s ErrInfo = result.Data("ErrInfo")
		s KValue = result.Data("KValue")
		s Trigger = result.Data("Trigger")
		s IP = result.Data("IP")
		s UserDr = result.Data("UserDr")
		s:UserDr'="" UserName = $P(^SSU("SSUSR",UserDr),"^",2)
		s BrowserInfo = result.Data("BrowserInfo")
		
		s:Date'="" Date=..DL2H(Date)
		s:Time'="" Time=..TL2H(Time)
		d OutPutRow
	}
	
	
	Quit $$$OK

OutPutRow
	s Data=$lb(RowId,Date,Time,AppName,ErrInfo,
		KValue,Trigger,IP,UserName,BrowserInfo)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

}
