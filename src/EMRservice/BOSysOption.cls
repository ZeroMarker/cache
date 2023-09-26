/// EMRservice.BOSysOption
Class EMRservice.BOSysOption Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/trakcarelive/trak/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "SysOptionInfo";

Parameter SOAPSESSION = 1;

/// TODO: add arguments and implementation.
/// CreateSysOption
ClassMethod CreateSysOption(ASysOption As EMRservice.entity.ESysOption) As %String [ WebMethod ]
{
 set objSysOption = ##class(EMRmeta.SysOption).%New()
 Quit:(objSysOption ="") "ERROR"
 set UniqueFlag = ##class(EMRservice.BL.BLSysOption).CheckNameUnique(ASysOption.Name) 
 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } 

 set objSysOption.Name = ASysOption.Name

 set objSysOption.Description = ASysOption.Description
 set objSysOption.OptionValue = ASysOption.OptionValue
 if (ASysOption.IsVisible = "")
 {
 	set ASysOption.IsVisible = "Y"	 
 }
 set objSysOption.IsVisible = ASysOption.IsVisible
 set objSysOption.IsEditor = ASysOption.IsEditor
 if '(objSysOption.%Save())
 {
 Quit 0
 } 
 Quit objSysOption.%Id()
}

/// TODO: add arguments and implementation.
/// DeleteSysOption
ClassMethod DeleteSysOption(AID As %String) As %Boolean [ WebMethod ]
{
 S ExistID =  ##class(EMRservice.BL.BLSysOption).CheckIdExist(AID)
 if (ExistID = 0) 
 { Quit 1
	  }
	set objSysOption = ##class(EMRmeta.SysOption).%OpenId(AID)
	Quit objSysOption.%DeleteId(AID)
}

ClassMethod GetValueByName(AName As %String) As %String [ WebMethod ]
{
 set Result =##class(EMRservice.BL.BLSysOption).GetOptionValueByName(AName)
 Quit Result
}

ClassMethod GetValueByName2(AName As %String, ADefaultValue As %String) As %String [ WebMethod ]
{
 set Result =##class(EMRservice.BL.BLSysOption).GetOptionValueByName2(AName, ADefaultValue)
 Quit Result
}

ClassMethod SelectAllSysOption() As EMRservice.dataset.ESysOptionDataset [ WebMethod ]
{
 Set result=##class(EMRservice.dataset.ESysOptionDataset).%New()
 Quit result
}

/// TODO: add arguments and implementation.
/// UpdateSysOption
ClassMethod UpdateSysOption(ASysOption As EMRservice.entity.ESysOption) As %String [ WebMethod ]
{
 set objSysOption = ##class(EMRmeta.SysOption).%OpenId(ASysOption.ID)

 S UniqueFlag=##class(EMRservice.BL.BLSysOption).CheckUpdateNameUnique(ASysOption.ID,ASysOption.Name)
 if '(UniqueFlag=0)
 { 
 Quit "-1"
 } 

 set objSysOption.Name = ASysOption.Name


 set objSysOption.Description = ASysOption.Description
 set objSysOption.OptionValue = ASysOption.OptionValue
 set objSysOption.IsEditor = ASysOption.IsEditor
 if '(objSysOption.%Save())
 {Quit "0"}
 Quit "1"
}

/// TODO: Update Value Indexed By Name Or Id 
ClassMethod UpdateSysOptionValue(ASysOption As EMRservice.entity.ESysOption) As %String [ WebMethod ]
{
 
 S sysOptionId = ""
 s sysOptionName = ASysOption.Name
 if ((ASysOption.ID = "") && (ASysOption.Name '= ""))
 {
 	&SQL(select ID into :sysOptionId From EMRmeta.SysOption Where Name = :sysOptionName)	 
 }
 s ASysOption.ID = sysOptionId
 q:(ASysOption.ID = "") "-1"
 
 set objSysOption = ##class(EMRmeta.SysOption).%OpenId(ASysOption.ID)

 S UniqueFlag=##class(EMRservice.BL.BLSysOption).CheckUpdateNameUnique(ASysOption.ID,ASysOption.Name)
 q:('(UniqueFlag=0)) "-1"

 set objSysOption.OptionValue = ASysOption.OptionValue
 set objSysOption.IsEditor = ASysOption.IsEditor
 if '(objSysOption.%Save())
 {Quit "0"}
 
 Quit "1"
}

/// Desc: 获取HTTP链接参数
/// Creator: yejian
/// CreateDate: 2019-5-21
ClassMethod GetNetConnectJson(ByRef AServerPort As %String, ArgdbConnectType As %String = "") As %String [ WebMethod ]
{
	
 	s key = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("DECRYPTKEY")
	s connectType = ##class(EMRservice.SystemParameter).GetNetConnectType()
	s AServerPort = ""
	if (connectType = "http")
	{
		//判定https是否启用状态，如on：dbConnectType赋值https ,off:赋值http。异常默认值http
		s httpsStatus=$method(%request,"Get"_"CgiEnv","HTTPS")
		s dbConnectType = $case(httpsStatus,"on":"https","off":"http",:"http")
		//前端传入值与当前CGI环境变量值不一致，优先选用前端
		s:(ArgdbConnectType'="")&&(ArgdbConnectType'=dbConnectType) dbConnectType = ArgdbConnectType
		
		Set Value=$method(%request,"Get"_"CgiEnv","SERVER_NAME")
		s server = Value
		s server = ##Class(web.Util.Encryption).SimpleEncrypt(server,"lacideMi"_key)
		s url = %session.Application_"EMRservice.Ajax.MessageServer.cls"
		//imedical/webservice插件访问时跳转到imedical/web
		s url = $case(url,"/imedical/webservice/EMRservice.Ajax.MessageServer.cls":$replace(url,"webservice","web"),:url)
		
		s url = ##Class(web.Util.Encryption).SimpleEncrypt(url,"lacideMi"_key)
		Set port=$method(%request,"Get"_"CgiEnv","SERVER_PORT")
		s AServerPort = port
		s port = ##Class(web.Util.Encryption).SimpleEncrypt(port,"lacideMi"_key)
		s cookies = ""
		
		s netJson = "{'dbConnectType':'"_dbConnectType_"','server':'"_server_"','port':'"_port_"','requestUrl':'"_url_"','cookie':'@@COOKIE'}"		
	}
	else
	{
		s netJson = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("NET_CONNECT")
	}
	s json = "{'Params':"_netJson_",'Key':'"_key_"'}"
	q json
}

}
