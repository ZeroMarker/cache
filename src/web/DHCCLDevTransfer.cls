Class web.DHCCLDevTransfer Extends %SOAP.WebClient [ ClassType = "", Not ProcedureBlock ]
{

Method InsertANOrder(opaId As %String = "", icuaId As %String = "", equipId As %String = "", anoSource As %String = "", userId As %String = "", dataPara As %String = "", status As %String = "") As %String [ WebMethod ]
{
    Quit ..WebMethod("InsertANOrder").Invoke(##this,"http://tempuri.org/InsertANOrder",.opaId,.icuaId,.equipId,.anoSource,.userId,.dataPara,.status)
}

Method AddDataByIP(source As %String, ip As %String, port As %String, dataPara As %String) As %String [ Final, ProcedureBlock = 1, SoapBindingStyle = document, SoapBodyUse = literal, WebMethod ]
{
    Quit ..WebMethod("AddDataByIP").Invoke(##this,"http://tempuri.org/AddDataByIP",.source,.ip,.port,.dataPara)
}

// Parameter LOCATION = "http://10.0.20.51/iMedical/web/web.DHCANService.cls";

/// This is the URL used to access the web service.
/// This is the namespace used by the Service
Parameter NAMESPACE = "http://tempuri.org";

/// This is the name of the Service
Parameter SERVICENAME = "AnInterface";

/// 
/// 把旧库采集数据转发到新库
/// d ##class(web.DHCANTransfer).AsyncToNewDb(source,equipId, dataPara)
ClassMethod AsyncToNewDb(source, equipId, dataPara)
{
	// &sql(SELECT IP into :ip FROM DHC_AN_Device WHERE RowId=:equipId)
    s obj=##class(web.DHCANTransfer).%New()
    // 新库web服务器或负截均衡的ip或URL =====要改
    s obj.Location="http://127.0.0.1/iMedical/web/web.DHCANService.cls"  
    d obj.WSSecurityLogin("dhwebservice","dhwebservice")
	set equip=##class(User.DHCICUBedEquip).%OpenId(equipId)
	set ip=equip.ICUBETcpipAddress
	set port=equip.ICUBEPort
    s res=obj.AddDataByIP(source,ip,port,dataPara)
    d obj.%Close()
    q res
}

/// 只换库，不升级，几乎不会用
/// 还需要个性业务代码
ClassMethod AsyncToNewDbWithoutUpdate(source, equipId, dataPara, userId, status)
{
	// &sql(SELECT IP into :ip FROM DHC_AN_Device WHERE RowId=:equipId)
    s obj=##class(web.DHCANTransfer).%New()
    s obj.Location="http://10.220.8.165/iMedical/web/web.DHCANService.cls"  // 新库web服务器或负截均衡的ip或URL =====要改
    d obj.WSSecurityLogin("dhwebservice","Abc@123")
    s res=obj.InsertANOrder("","",equipId,source,userId,dataPara,status)  // 1. AddDataByIP==>InsertANOrder 2. 新库添加AddDataByIP
    d obj.%Close()
    q res
}

}
