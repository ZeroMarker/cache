/// 名称:EMRservice.BLL.SysOption
/// 描述:系统参数配置服务
/// 编写者：Guozongtao
/// 编写日期: 2014-01-06
Class EMRservice.BL.BLSysOption Extends %RegisteredObject
{

ClassMethod GetOptionValueByName(AName As %String, AFlag As %String = "") As %String
{
	s value=""
	if ((AName="PluginUrl")&&(AFlag="")){
		//取插件地址
		s value = ..GetPluginUrl(AName)
	}
	q:((AName="PluginUrl")&&(AFlag="")) value
	s id=$o(^DHCEMRM.SysOptionI("NameIndex"," "_$zcvt(AName,"U"),""))
	q:(""=id) value
	    
	s obj=##Class(EMRmeta.SysOption).%OpenId(id)    
	if ("NET_CONNECT"=AName) {
		s Address=##Class(EMRservice.SystemParameter).GetServerIP()
        q "{'server':'"_Address_"'"_$case(obj.OptionValue,$c(0):"}",:","_obj.OptionValue_"}")
	}
    elseif (("SetDefaultFontStyle"=AName)||("SetOPDefaultFontStyle"=AName)){
        s defaultFontStyle = ##Class(EMRservice.BL.plugin.DefaultFontStyle).getDefaultFontStyleConfig()
        if (defaultFontStyle '= ""){
            q defaultFontStyle
        }else{
            q $case(obj.OptionValue,$c(0):"",:obj.OptionValue) 
        }
    }
	else 
	{ 		
		q $case(obj.OptionValue,$c(0):"",:obj.OptionValue) 
	}
}

/// 插件地址兼容内外服务器
ClassMethod GetPluginUrl(AName As %String)
{
	s $ZT="ERROR"
	s value=""
	s value = ..GetOptionValueByName(AName,"PluginUrl")
	if (value="NoVD"){
		s port = $case(%request.CgiEnvs("SERVER_PORT"),"80":"",:":"_%request.CgiEnvs("SERVER_PORT"))
		s ipHref = %request.CgiEnvs("SERVER_NAME")_port_%request.Application
		s httpsSwitch = $G(%request.CgiEnvs("HTTPS"))
		if (httpsSwitch'="off"){
			s value ="https://"_ipHref_"service/iemrplugin/"
		}else{
			s value ="http://"_ipHref_"service/iemrplugin/"	
		}
	}
	q value
ERROR
	q ""
}

ClassMethod GetOptionValueByName2(AName As %String, ADefaultValue As %String) As %String
{
	s id=$o(^DHCEMRM.SysOptionI("NameIndex"," "_$zcvt(AName,"U"),""))
	q:(""=id) ADefaultValue
	s rtn = ..GetOptionValueByName(AName)
    q:(""=rtn) ADefaultValue
    q rtn
}

Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String,OptionValue:%String,Description:%String,IsEditor:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_SysOption_SELECTALL, SqlProc ]
{
 SELECT ID, Name,OptionValue,  Description,IsEditor
 FROM EMRmeta.SysOption
 WHERE ((IsVisible = 'Y') OR (IsVisible is null))
 ORDER BY Name
}

/// Desc: 增加系统参数
/// Modify: candyxu
/// ModifyDate: 2015-9-8
/// Debug: D ##Class(EMRmeta.SysOption).Insert()
ClassMethod Insert(AName As %String, AValue As %String, ADesc As %String, AIsEditor As %String) As %String
{
	s result = "1"
	s id = $o(^DHCEMRM.SysOptionI("NameIndex"," "_$zcvt(AName,"U"),""))
	if (id = "")
	{
	  s obj=##Class(EMRmeta.SysOption).%New()
	}
	else
	{
		s obj = ##Class(EMRmeta.SysOption).%OpenId(id)
	}
	s obj.Description = ADesc
	s obj.IsVisible = "Y"
	s obj.Name = AName
	s obj.OptionValue = AValue
	s obj.IsEditor = AIsEditor
	s:($$$ISERR(obj.%Save())) result = "0"
	q result
}

/// Desc: 删除系统参数
/// Creator: candyxu
/// CreateDate: 2015-9-8
ClassMethod Delete(AName As %String) As %String
{
	s result = "1"
	s id = $o(^DHCEMRM.SysOptionI("NameIndex"," "_$zcvt(AName,"U"),""))
	if (id '= "")
	{
		s sc = ##Class(EMRmeta.SysOption).%DeleteId(id)
		s:($$$ISERR(sc)) result = "0"
	}
	q result
}

ClassMethod CheckUpdateNameUnique(AID As %String, AName As %String) As %Integer
{
 ;b "S"
 new Result
 new OldID 
 &sql(SELECT Count(Name) into :Result  FROM EMRmeta.SysOption WHERE Name = :AName)
 if (Result="")!(Result=0)
 {
	 s Result=0
 }
 if '(Result=0) 
 {
	 &sql(SELECT ID into :OldID FROM EMRmeta.SysOption WHERE Name = :AName)
	 if ('OldID=AID)     
	 { 
	 	s Result= 1
	 }
	 if (OldID=AID)     
	 { 
	 	s Result= 0
	 }
 }
 QUIT Result
}

ClassMethod CheckIdExist(AID As %String) As %Integer
{
 new Result
 &sql(SELECT Count(ID) into :Result FROM EMRmeta.SysOption WHERE ID = :AID)
 if Result=""
 {s Result=0 }
 QUIT Result
}

ClassMethod CheckMinusFieldExist(ATableName As %String, AFieldName As %String) As %String
{
 new Result
 
 &sql(SELECT Count(OptionValue)
 	into :Result 
 	FROM EMRmeta.SysOption
 	WHERE  Name = 'NotRemoveMinus' )
 
 if (Result="")||(Result="0")
 {s Result="0" }
 if '(Result="0")
 { 
 	New OptionValueStr
   	&sql(SELECT OptionValue
   		into :OptionValueStr
   		FROM EMRmeta.SysOption
   		WHERE  Name = 'NotRemoveMinus' )
   	
   	if '($F(OptionValueStr,ATableName)=0)
   	{ 
   		if ('$F(OptionValueStr,AFieldName)=0)  
		{ s Result="1" }
		else { s Result="0" } 
   	}
	else 
	{ 	s Result="0" }
  }
  
  QUIT Result
}

ClassMethod CheckNameUnique(AName As %String) As %Integer
{
 new Result
 &sql(SELECT Count(Name)
 into :Result 
 FROM EMRmeta.SysOption
 WHERE Name = :AName)
 QUIT Result
}

ClassMethod GetNetConnect() As %String
{
   
	s hostname=$zu(54,0)
	s CtmDictCode=$P($zu(54,13,hostname),",",1)
	s id = $O(^DHCEMRM.CustomDictionaryI("IdxCtmTypeCode",$zcvt("NET_CONNECT","U"), $zcvt(CtmDictCode,"U"), ""))
	if (id'="") 
	{
		s obj=##Class(EMRmeta.CustomDictionary).%OpenId(id)
		q:(obj'="") obj.IdxCtmDictDesc
	}
	q ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("NET_CONNECT")
}

/// w ##Class(EMRservice.BL.BLSysOption).GetNetConnectJson()
ClassMethod GetNetConnectJson(ArgIP As %String = "", ArgPort As %String = "", ArgdbConnectType As %String = "") As %String
{
	s key = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("DECRYPTKEY")
	s connectType = ##class(EMRservice.SystemParameter).GetNetConnectType()
	if (connectType = "http")
	{
		//判定https是否启用状态，如on：dbConnectType赋值https ,off:赋值http。异常默认值http
		s httpsStatus=$method(%request,"Get"_"CgiEnv","HTTPS")
		s dbConnectType = $case(httpsStatus,"on":"https","off":"http",:"http")
		//前端传入值与当前CGI环境变量值不一致，优先选用前端
		s:(ArgdbConnectType'="")&&(ArgdbConnectType'=dbConnectType) dbConnectType = ArgdbConnectType
		
		s server = $method(%request,"Get"_"CgiEnv","SERVER_NAME")
		//s server = $method(%request,"Get"_"CgiEnv","LOCAL_ADDR")
		//前端传入值与当前CGI环境变量值不一致，优先选用前端
		s:(ArgIP'="")&&(ArgIP'=server) server = ArgIP
		s server = ##Class(web.Util.Encryption).SimpleEncrypt(server,"lacideMi"_key)
		
		s url = %session.Application_"EMRservice.Ajax.MessageServer.cls"
		s url = ##Class(web.Util.Encryption).SimpleEncrypt(url,"lacideMi"_key)
		
		s port = $method(%request,"Get"_"CgiEnv","SERVER_PORT")	
		//前端传入值与当前CGI环境变量值不一致，优先选用前端
		s:(ArgPort'="")&&(ArgPort'=port) port = ArgPort
		s port = ##Class(web.Util.Encryption).SimpleEncrypt(port,"lacideMi"_key)
		//s cookies = %request.GatewaySessionCookie_"="_%session.CSPSessionCookie_";CSPWSERVERID="_%request.GetCookie("CSPWSERVERID")
		s cookies = $method(%request,"Get"_"CgiEnv","HTTP_COOKIE")	
		s useragent = $method(%request,"Get"_"CgiEnv","HTTP_USER_AGENT")
		s useragent = ##Class(web.Util.Encryption).SimpleEncrypt(useragent,"lacideMi"_key)
		s connection = $method(%request,"Get"_"CgiEnv","HTTP_CONNECTION")
		s connection = ##Class(web.Util.Encryption).SimpleEncrypt(connection,"lacideMi"_key)
		s netJson = "{'dbConnectType':'"_dbConnectType_"','server':'"_server_"','port':'"_port_"','requestUrl':'"_url_"','cookie':'"_cookies_"','UserAgent':'"_useragent_"','Connection':'"_connection_"'}"			
	}
	else
	{
		s netJson = ##Class(EMRservice.BL.BLSysOption).GetOptionValueByName("NET_CONNECT")
	}
	s json = "{'Params':"_netJson_",'Key':'"_key_"'}"

	q json
}

/// Desc:取复制粘贴权限设置
/// Creator:Candy
/// CreateDate:2018-6-12
/// Input:AProduct:产品(门诊：OP)
/// Debug: w ##Class(EMRservice.BL.BLSysOption).GetCopyPastStatus()
ClassMethod GetCopyPastStatus(AProduct As %String = "") As %String
{
	s result = ""
    if (AProduct = "OP")
    {
		s copyPasteExternalData = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DISABLE_PASTE_NON_EDITOR_OP","Y")
		s copyPasteAcrossPatient = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ENABLE_PASTE_LIMIT_OP","Y")
	}
	else
	{
		s copyPasteExternalData = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DISABLE_PASTE_NON_EDITOR","Y")
        s copyPasteAcrossPatient = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ENABLE_PASTE_LIMIT","Y")
	}
	s result = "{""ExternalData"":"""_copyPasteExternalData_""",""AcrossPatient"":"""_copyPasteAcrossPatient_"""}"
	q result
}

/// Desc:取电子病历运行环境参数
/// Creator:Donglulu
/// CreateDate:2019-4-10
/// Input:Type :电子病历版本（非融合版：UnHisui）
///       AProduct:产品(门诊：OP)
/// Debug: w ##Class(EMRservice.BL.BLSysOption).GetRunEMRParams()	
ClassMethod GetRunEMRParams(Type As %String = "", AProduct As %String = "") As %String
{
	s result = ""
    
    if (AProduct = "OP")
	{
		s flagExternalData = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DISABLE_PASTE_NON_EDITOR_OP","Y")
		s flagAcrossPatient = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ENABLE_PASTE_LIMIT_OP","Y")
        s isJsUpdateTitleInfo = "N"
	}
	else
	{
		s flagExternalData = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("DISABLE_PASTE_NON_EDITOR","Y")
		s flagAcrossPatient = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName2("ENABLE_PASTE_LIMIT","Y")
        
        s isJsUpdateTitleInfo = "false"
        if (Type '= "UnHisui")
        {
            s isJsUpdateTitleInfo = ##class(EMRservice.BL.BLSysOption).GetOptionValueByName("IsJsUpdateTitleInfo")
        }
	}
	
	s flagExternalData = $case(flagExternalData,"N":"true",:"false")
	s flagAcrossPatient = $case(flagAcrossPatient,"N":"true",:"false")
    	s isJsUpdateTitleInfo = $case(isJsUpdateTitleInfo,"Y":"true",:"false")
   
	s enableEditMultiRecord = ##Class(EMRservice.SystemParameter).IsEnableEditMultiRecord()
	s EMRHeart = ##class(EMRservice.SystemParameter).GetEMRHeartBeatTime()
	s menuEditParagraphVisible = ##Class(EMRservice.SystemParameter).SetMenuEditParagraphVisible()
	s revisionSettings = ##Class(EMRservice.SystemParameter).GetRevisionSettings()
	
	s setOpenCompress = ##Class(EMRservice.SystemParameter).GetSetOpenCompress()
	s result = "{""EnablePasteCopyExternalData"":"""_flagExternalData_""",""EnablePasteCopyAcrossPatient"":"""_flagAcrossPatient_""""
	s result = result_",""EnableEditMultiRecord"":"""_enableEditMultiRecord_""""
	s result = result_",""EMRHeartBeatTimeCycle"":"""_EMRHeart_""""
	s result = result_",""MenuEditParagraphVisible"":"""_menuEditParagraphVisible_""""
	s result = result_",""RevisionSettings"":"_revisionSettings_""
	s result = result_",""JsUpdateTitleInfo"":"""_isJsUpdateTitleInfo_""""
	//s result = result_",""OpenCompress"":"""_setOpenCompress_""""
	s result = result_"}"
	s result = "{""action"":""SET_RUNEMR_PARAMS"",""args"":"_result_"}"
	q result
}

}
