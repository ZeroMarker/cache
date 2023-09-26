/// 名称:	EMR.DOC.SRV.AbstractActionCommon
/// 描述:	病历系统 Document(Doc) 公用程序层后台入口（CSP直接调用后台类）
/// 编写者:	yejian
/// 编写日期: 	2020-12-7
/// 产品组：	电子病历产品组
Class EMR.DOC.SRV.AbstractActionCommon Extends EMR.DOC.COM.ActionBase
{

/// Creator：      yejian
/// CreatDate：    2013-12-25
/// Description:   文档管理的命令抽象工厂,解析argInMessage参数，按照产品线分配，分支处理，由各自产品线的工厂类处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"product":"OP","action":"GET_DEFAULTTEMPLATE","params":{"userLocID":"60","ssgroupID":"149","episodeID":"1085","userID":"18881","titleCode":"","bdmcCode":""}}
///                argInData    :传入的数据
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:      	s strJson = {"product":"OP","action":"GET_SYSOPTION","params":[{"name":"HospitalName","defaultValue":"DHCC"},{"name":"NameSpaceHIS","defaultValue":""},{"name":"NameSpaceLIS","defaultValue":""}]} 
/// 				w ##Class(EMR.DOC.SRV.AbstractActionCommon).GetActionFactory(strJson)	
ClassMethod GetActionFactory(ByRef argInMessage As %DynamicAbstractObject, argInData As %GlobalBinaryStream = "", ByRef argOutMessage As %DynamicObject = "", ByRef argOutData As %GlobalBinaryStream = "") As %String
{
	
	//定义错误处理函数
	s $ZT="ERROR"
	s strRes = ""
	//解析json参数		       
	;s strJson = $zcvt(argInMessage,"I","UTF8") 
	;set objJson = ##class(%DynamicAbstractObject).%FromJSON(strJson)
	s objJson = argInMessage
	s strProducts = objJson.product	
	//病历浏览 View、申请授权 AUTH、病历查询 Query,增加module入参
	s strModule = objJson.module
	s:(argInData="") argInData = ##class(%GlobalBinaryStream).%New()
	s:(argOutMessage = "") argOutMessage = ##class(%DynamicObject).%New()
	s:(argOutData = "") argOutData = ##class(%GlobalBinaryStream).%New()
	//DOC或空 BS维护，OP 门诊，IP 住院 
	if ("OP"=strProducts)
	{
		if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.OP.COM.ActionFactory") = "0") 
		{
			q "未找到命令工厂EMR.OP.COM.ActionFactory"
		}
		s ReturnValue=##Class(EMR.OP.COM.ActionFactory).AcitonProxy(objJson,argInData,argOutMessage,argOutData)
	}
	elseif ("IP"=strProducts)&&("View"=strModule) //病历浏览
	{
		if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.IP.COM.ActionViewFactory") = "0") 
		{
			q ..SetOutMessage(argOutMessage,"ERROR","未找到命令工厂EMR.IP.COM.ActionViewFactory",2)
		}
		s ReturnValue=##Class(EMR.IP.COM.ActionViewFactory).AcitonProxy(objJson,argInData,argOutMessage,argOutData)
	}
	elseif ("IP"=strProducts)&&("AUTH"=strModule)	//申请审核
	{
		if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.IP.COM.ActionAUTHFactory") = "0") 
		{
			q ..SetOutMessage(argOutMessage,"ERROR","未找到命令工厂EMR.IP.COM.ActionAUTHFactory",2)
		}
		s ReturnValue=##Class(EMR.IP.COM.ActionAUTHFactory).AcitonProxy(objJson,argInData,argOutMessage,argOutData)
	}
	elseif ("IP"=strProducts)&&("Query"=strModule)	//病历查询
	{
		if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.IP.COM.ActionQueryFactory") = "0") 
		{
			q ..SetOutMessage(argOutMessage,"ERROR","未找到命令工厂EMR.IP.COM.ActionQueryFactory",2)
		}
		s ReturnValue=##Class(EMR.IP.COM.ActionQueryFactory).AcitonProxy(objJson,argInData,argOutMessage,argOutData)
	}
	elseif ("IP"=strProducts)
	{
		if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.IP.COM.ActionFactory") = "0") 
		{
			q "未找到命令工厂EMR.IP.COM.ActionFactory"
		}
		s ReturnValue=##Class(EMR.IP.COM.ActionFactory).AcitonProxy(objJson,argInData,argOutMessage,argOutData)
	}else
	{
		if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.DOC.COM.ActionFactory") = "0") 
		{
			q "未找到命令工厂EMR.DOC.COM.ActionFactory"
		}
		s ReturnValue=##Class(EMR.DOC.COM.ActionFactory).AcitonProxy(objJson,argInData,argOutMessage,argOutData)
	}
	//获取数据后直接返回结果
    d argOutData.Rewind()
	while (argOutData.AtEnd = 0)
	{
		s strRes = argOutData.Read(32000)
	}
	q strRes

ERROR					 
	s strRes ="请求参数错误"
	q strRes
}

/// Creator：      yejian
/// CreatDate：    2013-12-25
/// Description:   文档管理的命令抽象工厂,解析argInMessage参数，按照产品线分配，分支处理，由各自产品线的工厂类处理
/// Table：        
/// Input：        argClass :命令信息 JSON格式  {"product":"OP","action":"GET_DEFAULTTEMPLATE","params":{"userLocID":"60","ssgroupID":"149","episodeID":"1085","userID":"18881","titleCode":"","bdmcCode":""}}
///                argMethod    :传入的数据
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:      s strParam ="""HospitalName"",""OP"",""DHCC"""
/// 				w ##Class(EMR.DOC.SRV.AbstractActionCommon).GetActionCommon("EMR.DOC.BL.SysOption","GetOptionValueByName",strParam)
ClassMethod GetActionCommon(argClass As %String, argMethod As %String, argParam As %String) As %String
{
	s strRes= ""
	s param = ""
	;s param = """"_$replace(argParam,"""","""""")_""""
	s param = argParam
    s execCode = "result=##class("_argClass_")."_argMethod_"("_param_")"
    s @execCode
    s result = @"result" 

    s strRes= $ZSTRIP(result,"*C",,$c(1)_$c(2))

	
	q strRes
}

/// Desc:  调试命令
/// Debug: d ##Class(EMR.OP.COM.AbstractActionFactory).yeTest()
ClassMethod yeTest()
{
	s Stream =##class(%FileBinaryStream).%New()
	//s Stream.Filename = "/debug/44.txt" 1265||13
	//s strJson = {"project":"OP","product":"GlobalEMR","action":"SAVE_DOCUMENT","params":{"instanceId":"59||1","templateId":"9","episodeId":"4","userId":"10209","ip":"192.168.101.37","sourceType":"Template","productSourceType":"EMR","userLocId":"6","patientId":"27","loadMode":"baseTem","happenDateTime":"2021-07-22 09:41:26","operateDateTime":"2021-07-22 09:41:26","title":"","titleCode":"","userTemplateCode":"","productSourceCode":""}}
	s strJson = {"action":"GET_RECORD_HTML","params":{"recordID":"1265||13","emrVersion":"emr3"},"product":"IP","module":"View"}
	d Stream.Write(strJson.%ToJSON())
    s argInData = ##class(%FileBinaryStream).%New()
    s argInData.Filename = "/debug/yeargInData.txt" 
	s argOutMessage = ##class(%DynamicObject).%New()
	s argOutData = ##class(%GlobalBinaryStream).%New() 
	d ..GetActionFactory(strJson,argInData,argOutMessage,.argOutData)
	d argOutData.OutputToDevice()
	w argOutMessage.%ToJSON()
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="/debug/SAVE_DOCUMENT1.xml"
	;s argOutData = ##Class(%GlobalBinaryStream).%New()
	;d argOutMessage.%ToJSON(argOutData)
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
}

/// Desc:  调试命令
/// Debug: d ##Class(EMR.OP.COM.AbstractActionFactory).yeWTest()
ClassMethod yeWTest()
{
	s Stream =##class(%FileBinaryStream).%New()
	s Stream.Filename = "d:\44.txt"
    s argInData = ##class(%FileBinaryStream).%New()
    s argInData.Filename = "d:\yeargInData.txt" 
	s argOutMessage = ##class(%DynamicObject).%New()
	s argOutData = ##class(%GlobalBinaryStream).%New() 
	d ..GetActionFactory(Stream,argInData,argOutMessage,.argOutData)
	d argOutData.OutputToDevice()
	w argOutMessage.%ToJSON()
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\SAVE_DOCUMENT1.xml"
	;s argOutData = ##Class(%GlobalBinaryStream).%New()
	;d argOutMessage.%ToJSON(argOutData)
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
}

}
