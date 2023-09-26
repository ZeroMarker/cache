Import SQLUser

Class web.DHCCLDevTool Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod Test()
{
	// w ##class(web.DHCCLDevTool).Test()
	s cmd=$g(^tmpDebug("Test"))
	if (cmd="StartEq")
	{
	  d ##class(web.DHCICUCom).StartAllTask()
	  b
	  d ##class(web.DHCANCom).StartAllTask()
	  s ^tmpDebug("Test")="StopEq"
	}
	else
	{
		d ##class(web.DHCICUCom).StartAllTask(cmd)
	    d ##class(web.DHCANCom).StartAllTask(cmd)
	    s ^tmpDebug("Test")="StartEq"
	}
	q "Over"
}

// 执行设备任务命令

ClassMethod ExcuteDevTask(source As %String, equipId As %String, patId As %String, IP As %String, port As %String, interval As %String, devType As %String, extInfo As %String, cmd As %String, customSrvIP As %String = "") As %String
{
	// w ##class(web.DHCCLDevTool).ExcuteDevTask("S","10","","10.160.16.30","1183","300000","ABL800","","StartEq")
	i cmd="" q "cmd is NULL"
	i source="" q "source is NULL"
	i equipId="" q "equipId is NULL"
	s $ZT="ERROR" s retStr="TimeOut"
	s dStr=$zd($p($h,",",1))
	s iDate=+($p(dStr,"/",2))
	s time=$p($h,",",2)
	s hour=time\3600
	s min=(time-(hour*3600))\60
    
    s objDeviceServer=..GetSoapObject()
    q:'$ISOBJECT(objDeviceServer) objDeviceServer
    
    i devType="Relay" d
    .s locStr=objDeviceServer.Location
    .s relayIP=$p(IP,"|",1) ;中转PCIP
    .s devType=$p(IP,"|",3) ;真实设备类型
    .s IP=$p(IP,"|",2)      ;设备直连时的IP地址
    .s $p(locStr,"/",3)=relayIP
    .s objDeviceServer.Location=locStr
   
    //启动设备，返回"SUCCESS^";"FAILED^";"INVALID^";
    i devType="AutoCheckDev" d 
    .s extInfo="PB840;Maquet;EvitaXL;Hamilton;PhlipsV60;Prismaflex;PICCO;MindrayVT;VigIFMout"
    .
    .s portCount=$p(port,"|",2)
    .s basePort=$p(port,"|",1)
    .i portCount="" d
    ..s retStr=$$Excutecommand(equipId_"~"_i)
    .q:portCount=""
    .f i=1:1:portCount d
    ..s $ZT="ERROR"
    ..s port=basePort+i-1
    ..s retStr=$$Excutecommand(equipId_"~"_i)
    e  d
    .s retStr=$$Excutecommand(equipId)
    d objDeviceServer.%Close()
    q retStr
Excutecommand(equipId)
	s ^DHCANICUDEBUG(cmd,source,equipId,iDate,hour,min)=$zd(+$h)_" "_$zt(time)_"=>"_source_","_equipId_","_patId
	s ^DHCANICUDEBUG(cmd,source,equipId,iDate,hour,min,"taskInfo")=IP_","_port_","_interval_","_devType_","_extInfo
	//b  //
	//s objDeviceServer.Location="http://localhost/OAICUService/OAICUDevSrv.asmx"
	i cmd="StartEq" d
	.s retStr=objDeviceServer.StartTask(source, equipId, patId, IP, port, interval, devType, extInfo)
	.s ^DHCANICUDEBUG(cmd,source,equipId,iDate,hour,min,"rawres")=retStr
    e  i cmd="StopEq" d
    .s retStr=objDeviceServer.StopTask(source,equipId)
    i $p(retStr,"^")="SUCCESS" d
    .s retStr=0
    s ^DHCANICUDEBUG(cmd,source,equipId,iDate,hour,min,"res")=retStr
    w retStr,!
    q retStr
ERROR
	Set ErrorMsg=$ZE	           //得到系统返回的错误消息
	s ^DHCANICUDEBUG(cmd,source,equipId,iDate,hour,min,"Error")=ErrorMsg
	b // Error
 	Quit "接口服务调用错:"_ErrorMsg
}

ClassMethod GetSoapObject()
{
	s mIP=$g(^DHCCLSet("MSrvIP"))
	q:mIP="" "采集服务器未配置"
	s tmpIP=$p(mIP,"|",2) 
    s mIP=$p(mIP,"|",1)
    s dbIP=..GetDbIP()
    //q:dbIP'=tmpIP "采集服务器配置不含 数据库IP"
    
	s objDeviceServer=##class(web.DHCCLDevSoapInferface).%New() 
	s objDeviceServer.Timeout=10
    s locStr=objDeviceServer.Location
    s $p(locStr,"/",3)=mIP ;"10.160.16.110"
    s objDeviceServer.Location=locStr
    q objDeviceServer
}

ClassMethod GetDbIP()
{
	s str=##class(web.DHCClinicCom).GetSystemConfiguration()
    s str=$p(str,"^",2)
    s dbIP=$p($p(str,":",2),"[",1)
    q dbIP
}

ClassMethod SetSrvInfo(webURL)
{
	// w ##class(web.DHCCLDevTool).SetSrvInfo("127.0.0.1")
	//s webService="http://{0}/DtHealth/web/web.DHCANService.cls"
	//s webService=##class(web.DHCClinicCom).Replace(webService,"{0}",webURL)
	s totalUrl=$p(webURL,"|",3)
	s url=$p(totalUrl,"/",3)
	s ^tmpccldebug("url")=totalUrl
	i $$ALPHAUP^SSUTIL4(totalUrl)[$$ALPHAUP^SSUTIL4("DtHealth") d
	.s tmpUrl="http://{0}/DtHealth/web/web.DHCANService.cls"
	.s webService=$$GetWebService(tmpUrl,url)
	e  d
	.s tmpUrl="http://{0}/trakcarelive/trak/web/web.DHCANService.cls"
	.s webService=$$GetWebService(tmpUrl,url)
	
	s param=webService_"^"_..GetDbIP()
	s objDeviceServer=..GetSoapObject()
	
	s res=objDeviceServer.SetService(param)
	d objDeviceServer.%Close()
	q res
GetWebService(tmpUrl,url)
	s tmpUrl=##class(web.DHCClinicCom).Replace(tmpUrl,"{0}",url)
	q tmpUrl
}

ClassMethod CheckCollect()
{
	// w ##class(web.DHCCLDevTool).CheckCollect()
	s ^tmpcldev("log")=""
	// 检测采集服务器是否配置
	s checkStr=""
	s mIP=$g(^DHCCLSet("MSrvIP"))
	i mIP="" d ..AddLog("Error:采集服务没有配置")
	i $p(mIP,"|",2)="" d ..AddLog("Error:采集服务IP未配置数据库IP")
	i $O(^DHCANICUDEBUG("InsertToOrder",""))="" d
	.d ..AddLog("Error:未收到任何采集数据")
	e  d
	.i $g(^DHCANICUDEBUG("InsertToOrder","I"))="" d ..AddLog("Warning:未收到ICU采集数据")
	.i $g(^DHCANICUDEBUG("InsertToOrder","A"))="" d ..AddLog("Warning:未收到手麻采集数据")
	.i $g(^DHCANICUDEBUG("InsertToOrder","B"))="" d ..AddLog("Warning:未收到血透采集数据")
	// 检查监护数据
	d ..AddLog(..CheckDHCICUBedEquip())
	d ..AddLog(..CheckDHCANBedEquip())
	// 检查今天的数据的条数
	d ..AddLog(..CheckDHCANOrder())
	d ..AddLog(..CheckDHCICUCollectData())
	// 检查重症任务是否正常运行
	d ..CheckICUDBTask()
	// 检查今天入库数据的条数 并返回一icuaId和opaId,以及常用医嘱Code
	q $g(^tmpcldev("log"))
}

ClassMethod AddLog(str)
{
	q:str="" ""
	s oldStr=$g(^tmpcldev("log"))
	i oldStr="" s ^tmpcldev("log")=str
	e  s ^tmpcldev("log")=oldStr_"[~~]"_str
	q ^tmpcldev("log")
}

ClassMethod CheckDHCICUBedEquip()
{
	// w ##class(web.DHCCLDevTool).CheckDHCICUBedEquip()
	&sql(select count(*) into:count from DHC_ICU_BedEquip)
	q:count<=0 "重症监护设备未配置"
	q ""
}

ClassMethod CheckDHCANBedEquip()
{
	// w ##class(web.DHCCLDevTool).CheckDHCANBedEquip()
	&sql(select count(*) into:count from DHC_AN_RoomEquip)
	q:count<=0 "Error:手麻监护设备未配置"
	q ""
}

ClassMethod CheckDHCANOrder()
{
	// w ##class(web.DHCCLDevTool).CheckDHCANBedEquip()
	s todayDate=+$h
	s count=0
	&sql(SELECT count(ANO_RowId) FROM DHC_AN_Order WHERE ANO_StartDate=:todayDate AND ANO_Source="I")
	q:count<=0 "Warning:手麻今日款取到数据"
	q "手麻收到:"_count_"条数据"
}

ClassMethod CheckDHCICUCollectData()
{
	// w ##class(web.DHCCLDevTool).CheckDHCICUCollectData()
	s todayDate=+$h
	s count=0
	&sql(SELECT TOP 1 count(ICUCD_RowId) FROM DHC_ICU_CollectData WHERE ICUCD_StartDate=:todayDate)
	q:count<=0 "Warning:重症今日未取到数据"
	q "重症收到:"_count_"条数据"
}

ClassMethod CheckICUDBTask()
{
	// 
	s lastExcuteTime=$g(^tmpICUDebug("ComfirmCollectData","First"))
	i lastExcuteTime="" d ..AddLog("Error:ComfirmCollectData 未添加Task")
	e  d ..AddLog("ComfirmCollectData Last Excute Time:"_lastExcuteTime)
	// 今天发送的错误
	s todayDate=##class(web.DHCClinicCom).ConvertToDate(+$h)
	s res=$O(^TMPICUDEBUG("ComfirmCollectData",todayDate,""))
	i res'="" d ..AddLog("Error:ComfirmCollectData时发生错误，请通过Global查看^TMPICUDEBUG(""""ComfirmCollectData"""","_todayDate)
	
	// EveryHourTask
	s res=$O(^dhccldebuglog("EveryHourTask-EachWard",""))
	i res="" d ..AddLog("Error:EveryHourTask 未添加Task")
	e  d
	.s res=$O(^dhccldebuglog("EveryHourTask-EachWard",res,todayDate,""))
	.i res="" d ..AddLog("Error:EveryHourTask 今天未执行")
	.e  d
	..; 查看EveryHourTask今天没有是否报错
	..s res=$O(^dhccldebuglog("EveryHourTask-EachWard-Error",""))
	..i res'=""  d
	...s res=$O(^dhccldebuglog("EveryHourTask-EachWard-Error",res,""))
	...d ..AddLog("Error:ComfirmCollectData时发生错误，请通过Global查看^tmpdebug(""""EveryHourTask-EachWard-Error"""",,"_todayDate)
}

ClassMethod GetDeviceState(source, patId)
{
	// w ##class(web.DHCANCom).GetDeviceState(srouce, equipId)
	// {deviceName:'PhilisMp',IP:'127.0.0.1',state:'netoffline',troubleSource:'网线掉落电源线掉医嘱或网络故障'}
	i source="A" d
	.s res=$$LastCollcetdata()
	e  i source="I" d
	.
	q res
	// q "{deviceName:'PhilisMp',IP:'127.0.0.1',state:'netoffline',troubleSource:'网线掉落电源线掉医嘱或网络故障'}"
LastCollcetdata()
    s opaId=""
	&sql(SELECT ANO_StartDate,ANO_StartTime into :date,:time FROM DHC_AN_Order 
	WHERE ANO_OPA_Dr=:patId AND ANO_Source="I" ORDER BY ANO_RowId desc)
	s curDate=$h,curTime=$p($h,",",2)
	s curDateTime=curDate*(3600*24)+curTime
	s dateTime=date*(3600*24)+time
	s span=curDateTime-dateTime
	q:span<60 "0"
	q "获取监护仪数据失败"
GetOpaId
	s equip=##class(User.DHCANRoomEquip).%OpenId(equipId)
	q 0
}

}
