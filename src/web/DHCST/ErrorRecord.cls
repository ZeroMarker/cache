Import sqluser

/// Descript:系统错误日志相关
/// Creater:	LiMingzhong
/// CreateDate:	2012-06-13
Class web.DHCST.ErrorRecord Extends (%RegisteredObject, %XML.Adaptor, StkTypeG) [ Not ProcedureBlock ]
{

/// Descript:	查询系统错误日志信息
/// Creater:	LiMingzhong
/// CreateDate:	2012-06-13
/// Table:DHC_StkSysErrorRecord
/// Input:起始日期,截止日期
/// Output:		
/// Return：系统错误日志信息
/// Others: w ##class(web.DHCST.ErrorRecord).SelectAll("2012-06-12","2012-06-13")
ClassMethod SelectAll(startDate, endDate, Sort = "", Dir = "") As %String
{
	n (startDate,endDate,Sort,Dir)
	s sortFlag = $s(Dir="ASC":1, 1:-1)
	s startDate =##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(startDate)
	s endDate = ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(endDate)
	
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select DHCSTER_RowId as RowId,DHCSTER_Date as STERDate,DHCSTER_Time as STERTime,DHCSTER_App as App,DHCSTER_ErrInfo as ErrInfo,DHCSTER_KeyValue as KValue,DHCSTER_ErrorTrigger as Trigger,DHCSTER_IP as IP,DHCSTER_SSUSR_DR as UserDr,DHCSTER_BrowserInfo as BrowserInfo,DHCSTER_StkType as StkType from DHC_StkSysErrorRecord where DHCSTER_Date>="_startDate_" and DHCSTER_Date<="_endDate
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s json = ##class(Code.JsonObj).%New()
	While(result.Next()) {	
		s StkType = result.Data("StkType")
		continue:StkType'="G"
	    i $g(pid)="" s pid=..NewPid()
		s UserName="",AppName=""
		s RowId = result.Data("RowId")
		s Date = result.Data("STERDate")
		s Time = result.Data("STERTime")
		s App = result.Data("App")
		
		s:App>0 AppName = $P(^DHCSSA(App),"^",2)
		s ErrInfo = result.Data("ErrInfo")
		s KValue = result.Data("KValue")
		s Trigger = result.Data("Trigger")
		s IP = result.Data("IP")
		s UserDr = result.Data("UserDr")
		s:UserDr'="" UserName = $P(^SSU("SSUSR",UserDr),"^",2)
		s BrowserInfo = result.Data("BrowserInfo")
		s sortDate = $s(Date'="":$zd(Date,3), 1:"YYYY-MM-DD") //Huxt 2020-02-24
		s:Date'="" Date=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(Date)
		s:Time'="" Time=$zt(Time,1)
		
		s data=RowId_"^"_Date_"^"_Time_"^"_AppName_"^"_ErrInfo_"^"_KValue_"^"_Trigger_"^"_IP_"^"_UserName_"^"_BrowserInfo
		s count = count+1		
        s index="Sort^"_sortDate_"^"_Time_"^"_count  //排序
        s index = $s(
        	Sort="Date":"Sort^"_sortDate_"^"_count,
        	Sort="Time":"Sort^"_Time_"^"_count,
        	Sort="AppName":"Sort^"_AppName_"^"_count,
        	Sort="ErrInfo":"Sort^"_ErrInfo_"^"_count,
        	Sort="KValue":"Sort^"_KValue_"^"_count,
        	Sort="Trigger":"Sort^"_Trigger_"^"_count,
        	Sort="IP":"Sort^"_IP_"^"_count,
        	Sort="UserName":"Sort^"_UserName_"^"_count,
        	Sort="BrowserInfo":"Sort^"_BrowserInfo_"^"_count,
        	1:"Sort^"_sortDate_"^"_Time_"^"_count //默认
        )
        s ^TMP("DHCST","ErrorRecord","SelectAll",pid,"index",index)=data
	}
	d result.Close()

	q:count=0 ##class(web.DHCSTEXTCOMMON).GetNoJson()
	s maxrow=count
	s count=0
    s h=""
    f  s h=$o(^TMP("DHCST","ErrorRecord","SelectAll",pid,"index",h),sortFlag) q:h=""  d
    .s data=^TMP("DHCST","ErrorRecord","SelectAll",pid,"index",h)
    .s RowId=$p(data,"^",1)
    .s Date=$p(data,"^",2)
    .s Time=$p(data,"^",3)
    .s AppName=$p(data,"^",4)
    .s ErrInfo=$p(data,"^",5)
    .s KValue=$p(data,"^",6)
    .s Trigger=$p(data,"^",7)
    .s IP=$p(data,"^",8)
    .s UserName=$p(data,"^",9)
    .s BrowserInfo=$p(data,"^",10)
    .
	.s count=count+1
    .
    .s RowId=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("RowId",RowId)
	.s Date=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Date",Date)
	.s Time=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Time",Time)
	.s AppName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("AppName",AppName)
	.s ErrInfo=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("ErrInfo",ErrInfo)
	.s KValue=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("KValue",KValue)
	.s Trigger=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("Trigger",Trigger)
	.s IP=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("IP",IP)
	.s UserName=##class(web.DHCSTEXTCOMMON).GetJsonFirstCell("UserName",UserName)
	.s BrowserInfo=##class(web.DHCSTEXTCOMMON).GetJsonLastCell("BrowserInfo",BrowserInfo)
	.
    .s tmpstr=RowId_Date_Time_AppName_ErrInfo_KValue_Trigger_IP_UserName_BrowserInfo
	.
    .s startString=##class(web.DHCSTEXTCOMMON).GetJsonStartString(maxrow)
    .s firstrow=##class(web.DHCSTEXTCOMMON).GetJsonFirstRow(tmpstr)
    .s lastrow=##class(web.DHCSTEXTCOMMON).GetJsonLastRow(tmpstr)
	.
    .i count=1 w startString
    .i count<maxrow w firstrow
    .i count=maxrow w lastrow
	.
	//k ^TMP("DHCST","ErrorRecord","SelectAll",pid)
	Q ""
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

ClassMethod NewPid() As %String
{
  	q $I(^DHCSTPID("ErrorRecord"))
}

}
