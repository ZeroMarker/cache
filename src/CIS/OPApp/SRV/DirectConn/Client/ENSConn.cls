Class CIS.OPApp.SRV.DirectConn.Client.ENSConn Extends %RegisteredObject
{

/// Version of the direct connect client.
Parameter Version = "0.1.0";

/// Name of the Service.
Parameter SERVICENAME = "ENSAPIForOPApp";

/// Class Name of the Service.
Parameter SERVICECLASS = "web.DHCENS.EnsHISService";

/// Class Method of the Service.
Parameter SERVICEMETHOD = "DHCHisInterface";

/// if debug is 1, then write console logs
Parameter DEBUG = 0;

/// 发送手术信息到平台
ClassMethod SendOperationApplyInfo(opsId) As %String
{
	set result=""
	try
	{
		set operScheduleObj=##class(CIS.AN.OperSchedule).%OpenId(opsId)
		set opaId=operScheduleObj.ExternalID
		// 调用消息平台接口	
		set ENSRES=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDOPERATIONAPPLYINFO",opaId)
		if (+ENSRES'=0) set result="E^发送手术申请失败，原因："_$p(ENSRES,"^",2)
		else  set result="S^发送手术申请成功"
	}
	catch(e)
	{
		set result="E^DTS:调用消息平台接口错误:"_e.DisplayString()
	}
	
	quit result
}

/// 同步手术闭环数据
ClassMethod SendSystemStatus(array As %DynamicArray) As %String
{
	set result=""
	try
	{
		set stream=##class(%GlobalCharacterStream).%New()
		do stream.Write(array.%ToJSON())
		set ENSRES=##class(web.DHCENS.EnsHISService).DHCHisInterface("UpdateSystemStatus",stream)
		
		set stream=##class(%GlobalCharacterStream).%New()
		do stream.CopyFrom(ENSRES)
		do stream.Rewind()
		if ..#DEBUG=1 write "ENS RES:",stream.Read(),!
		set retJSON=##class(%DynamicObject).%FromJSON(stream.Read())
		if (+retJSON."0".ResultCode'=0) set result="E^同步手术闭环数据失败，原因："_retJSON."0".ResultContent
		else  set result="S^同步手术闭环数据成功"
		
		if ..#DEBUG=1 write "OPApp:ENSConn SendSystemStatus Result:",result,!
	}
	catch(e)
	{
		if ..#DEBUG=1 write "OPApp:ENSConn SendSystemStatus Error:",e.DisplayString(),!
		set result="E^DTS:调用消息平台接口错误:"_e.DisplayString()
	}
	
	quit result
}

}
