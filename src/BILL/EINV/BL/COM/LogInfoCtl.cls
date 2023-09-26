/// 日志操作相关的方法
Class BILL.EINV.BL.COM.LogInfoCtl Extends %RegisteredObject
{

/// 功能说明：保存调试日志
ClassMethod Debug(DebugMsg As %String, PayAdmType As %String = "", HISPrtRowID As %String = "", LogLevel As %String = "0") As %Status
{
	s LogType="Debug"
	
	d ..WriteLog(DebugMsg, LogLevel, LogType, PayAdmType, HISPrtRowID)
	
	q $$$OK
}

/// 功能说明：保存普通的流程及入参日志
ClassMethod Info(InfogMsg As %String, PayAdmType As %String = "", HISPrtRowID As %String = "", LogLevel As %String = "1") As %Status
{
	s LogType="Info"
	
	d ..WriteLog(InfogMsg, LogLevel, LogType, PayAdmType, HISPrtRowID)
	
	q $$$OK
}

/// 功能说明：保存错误日志
ClassMethod Error(ErrorMsg As %String, PayAdmType As %String = "", HISPrtRowID As %String = "", LogLevel As %String = "2") As %Status
{
	s LogType="Error"
	
	d ..WriteLog(ErrorMsg, LogLevel, LogType, PayAdmType, HISPrtRowID)
	
	q $$$OK
}

/// 保存日志
/// w ##class(BILL.EINV.BL.COM.LogInfoCtl).WriteLog("test log", "1", "Error")
ClassMethod WriteLog(LogMsg As %String, LogLevel As %String, LogType As %String, PayAdmType As %String = "", HISPrtRowID As %String = "") As %Status
{
	s LogWriteFlg="0"   ;是否写日志
	s LogLevelFlg=1     ;日志级别  达到这个级别的才写日志，否则不写
	s LogConfigInfo=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case", "EInv_Log_ConfigInfo", 0)   ;日志配置信息
	if (LogConfigInfo'=""){
		s LogWriteFlg=$p(LogConfigInfo, "^", 5)
		s:(LogWriteFlg="") LogWriteFlg="0"
		s LogLevelFlg=+$p(LogConfigInfo, "^", 6)
		s:(LogLevelFlg="") LogLevelFlg=1
	}
	q:LogWriteFlg'="1" $$$OK             ;不写日志时退出
	q:(LogLevel<LogLevelFlg) $$$OK       ;达不到日志输出级别时 不输出日志

	s nowDateStr=$h
	s IPAddress=$ZUTIL(67,15,$JOB)   ;##class(%SYSTEM.Process).ClientIPAddress()    ;获取IP地址
	s MacAdress=""				;##class(%SYSTEM.Process).ClientIPAddress()

	s ObjLogInfo=##class(BILL.EINV.PO.LogInfo).%New()
	s ObjLogInfo.LogLevel=LogLevel         ;日志级别
	s ObjLogInfo.LogType=LogType           ;日志类型
	s ObjLogInfo.LogMsg=LogMsg             ;日志信息
	
	s ObjLogInfo.IPAdress=IPAddress        ;IP地址
	s ObjLogInfo.MacAdress=MacAdress       ;客户端MAC地址
	
	s ObjLogInfo.CreateDate=$p(nowDateStr, ",", 1)  ;日期
	s ObjLogInfo.CreateTime=$p(nowDateStr, ",", 2)  ;时间
	
	//add by xubaobao 2021 03 19 增加发票业务类型与发票表ID
	s ObjLogInfo.PayAdmType=PayAdmType        ;IP地址
	s ObjLogInfo.HISPrtRowID=HISPrtRowID       ;客户端MAC地址
	
	//保存数据
    s sc=ObjLogInfo.%Save()
    i $SYSTEM.Status.IsError(sc) {
	    s NowDate=$zd(+$h,3)
	    s NowTime=$zt($p($h, ",", 2))
	    s:(IPAddress="") IPAddress="255.255.255.255"
    	s ^TMPEInvLog("EInvNotSaveLog",NowDate,NowTime,IPAddress)=$SYSTEM.Status.GetErrorText(sc)
    }
    
    q $$$OK
}

/// 功能说明：批量删除多余的日志信息
/// w ##class(BILL.EINV.BL.COM.LogInfoCtl).DelLogTast()
ClassMethod DelLogTast() As %String
{
	s iNowDt=+$h   ;当前日期
	s Nums=0
	
	s LogDays=##class(BILL.EINV.COM.Common).GetEINVDicByCodeAndInd("Einv_ProCode_Case","EInv_Log_SaveDays",5)
	s:LogDays="" LogDays=30  ;默认保存30天的日志
	
	s tmpDate=iNowDt-LogDays
	f  s tmpDate=$o(^BILL.EINV.PO.LogInfoI("IdxCreateDate",tmpDate),-1) q:(tmpDate="")  d
	.s rowid=""
	.f  s rowid=$o(^BILL.EINV.PO.LogInfoI("IdxCreateDate",tmpDate,rowid),-1) q:(rowid="")  d
	..s Ret=##class(BILL.EINV.PO.LogInfo).%DeleteId(rowid)
	..s Nums=Nums+1
	
	q Nums
}

/// Creator：      ZhaoZW
/// CreatDate：    2020-2-6
/// Description:   日志查询
/// Table：        被访问的表(BILL_EINV_PO.LogInfo)
/// Input：        StDate : 开始时间 EdDate : 结束时间 IPAddr : 客户端IP
/// Output：       
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.LogInfoCtl","QueryLogInfo","2020-1-1","2020-2-10")
Query QueryLogInfo(StDate As %String, EdDate As %String, IPAddr As %String = "", ErrFlag As %String = "") As websys.Query(ROWSPEC = "ind,IPAdress:%String,LogType:%String,CreateDate:%String,CreateTime:%String,LogMsg:%String,LogLevel:%String,UserCode:%String,MacAdress:%String,PayAdmType:%String,HISPrtRowID:%String,OrgHISPrtRowID:%String,PathCode:%String,ExpStr:%String,XStr1:%String,XStr2:%String,XStr3:%String,XStr4:%String,XStr5:%String")
{
}

ClassMethod QueryLogInfoExecute(ByRef qHandle As %Binary, StDate As %String, EdDate As %String, IPAddr As %String = "", ErrFlag As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
	//以上不用动
    quit:((StDate="")||(EdDate="")) $$$OK
    s StDate=##class(websys.Conversions).DateHtmlToLogical(StDate)
	s EdDate=##class(websys.Conversions).DateHtmlToLogical(EdDate)

	f Date=EdDate:-1:StDate  d
	.s ID=0
	.f  s ID=$o(^BILL.EINV.PO.LogInfoI("IdxCreateDate",Date,ID)) q:(ID="")  d
	..s list=$g(^BILL.EINV.PO.LogInfoD(ID))            	;获取数据串
	..s LogLevel=$lg(list,2)							;日志级别
	..s LogType=$lg(list,3)								;日志类型
	..q:(ErrFlag="ON")&&(LogType'="Error")
	..s UserCode=$lg(list,4)							;操作员编码
	..s IPAdress=$lg(list,5)							;客户端IP
	..q:(IPAddr'="")&&(IPAdress'=IPAddr)
	..s MacAdress=$lg(list,6)							;客户端MAC地址
	..s CreateDate=$lg(list,7)							;日志生成日期
	..s:(CreateDate'="") CreateDate=##class(websys.Conversions).DateLogicalToHtml(CreateDate)
	..s CreateTime=$lg(list,8)							;日志生成时间
	..s:(CreateTime'="") CreateTime=##class(websys.Conversions).TimeLogicalToHtml(CreateTime)
	..s LogMsg=$lg(list,9)								;日志信息
	..s PayAdmType=$lg(list,10)							;票据业务类型
	..s HISPrtRowID=$lg(list,11)						;发票表Dr
	..s OrgHISPrtRowID=$lg(list,12)						;原发票ID
	..s PathCode=$lg(list,13)							;业务处理路径
	..s ExpStr=$lg(list,14)								;入参扩展参数
	..s XStr1=$lg(list,15)								;扩展参数1
	..s XStr2=$lg(list,16)								;扩展参数2
	..s XStr3=$lg(list,17)								;扩展参数3
	..s XStr4=$lg(list,18)								;扩展参数4
	..s XStr5=$lg(list,19)								;扩展参数5
    ..d OutputRow
    
    quit $$$OK
OutputRow
	//需要输出的列
	set Data=$lb(ind,IPAdress,LogType,CreateDate,CreateTime,LogMsg,LogLevel,UserCode,MacAdress,PayAdmType,HISPrtRowID,OrgHISPrtRowID,PathCode,ExpStr,XStr1,XStr2,XStr3,XStr4,XStr5)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 功能说明：根据日期查询IP地址
/// d ##class(%ResultSet).RunQuery("BILL.EINV.BL.COM.LogInfoCtl","SQLQueryList","65415","65416")
Query SQLQueryList(StDate As %String, EdDate As %String) As %SQLQuery(CONTAINID = 1)
{
	SELECT DISTINCT IPAdress FROM BILL_EINV_PO.LogInfo WHERE CreateDate BETWEEN :StDate AND :EdDate
}

/// 日期转化
/// d ##class(BILL.EINV.BL.COM.LogInfoCtl).FormatDate("2020-2-6")
ClassMethod FormatDate(Date As %String) As %String
{
	q:(Date="") $$$OK
	s Date=$zdh(Date,3)
	q Date
}

}
