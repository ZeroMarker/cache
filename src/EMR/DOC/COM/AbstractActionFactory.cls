/// 名称:	EMR.DOC.COM.AbstractActionFactory
/// 描述:	通用文档管理模块 Document(Doc) 公用程序层 Request数据请求抽象工厂
/// 编写者:	yejian
/// 编写日期: 	2020-12-7
/// 产品组：	电子病历产品组
Class EMR.DOC.COM.AbstractActionFactory Extends EMR.DOC.COM.ActionBase
{

/// Creator：      yejian
/// CreatDate：    2013-12-25
/// Description:   文档管理的命令抽象工厂,解析argInMessage参数，按照产品线分配，分支处理，由各自产品线的工厂类处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"params":"{\"docId\":\"160202\", \"actionUrl\":\"/editor/diseasedoc/load.cmd\"}","Product":"GlobalEMR"}。
///                argInData    :传入的数据
/// 				argMethod :http传输方式（get,post）
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.COM.AbstractActionFactory).CreateActionFactory(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod CreateActionFactory(ByRef argInMessage As %GlobalBinaryStream, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream, argMethod As %String = "") As %String
{
	
	//定义错误处理函数
	s $ZT="ERROR"
	
	//解析json参数		       
	s objStream = ##class(%GlobalBinaryStream).%New()
	d argInMessage.Rewind()
	while (argInMessage.AtEnd = 0)
	{
		s tmpOut = argInMessage.Read(32000)
		s:(tmpOut [ "GET_PACSDATA") ^TempActionFactory("123") = argMethod_"^"_tmpOut
		//POST方式需要转码
		s:($zcvt(argMethod,"U")="POST") tmpOut = $zcvt(tmpOut,"I","UTF8") 
		s:(tmpOut [ "GET_PACSDATA") ^TempActionFactory("1234") =  argMethod_"^"_tmpOut
		d objStream.Write(tmpOut)
	}
	//s strJson = "{""action"": ""LOAD_TEMPLATE"",""params"": {""templateId"": ""13||DT"", ""userCode"": ""YS01"", ""IP"": ""111.205.6.195""},""product"": ""GlobalEMR""}"
	set objJson = ##class(%DynamicAbstractObject).%FromJSON(objStream)
	s strProducts = objJson.product	
	//病历浏览 View、申请授权 AUTH、病历查询 Query,增加module入参
	s strModule = objJson.module
	//DOC或空 BS维护，OP 门诊，IP 住院 
	if ("OP"=strProducts) 
	{
		if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.OP.COM.ActionFactory") = "0") 
		{
			q ..SetOutMessage(argOutMessage,"ERROR","未找到命令工厂EMR.OP.COM.ActionFactory",2)
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
			q ..SetOutMessage(argOutMessage,"ERROR","未找到命令工厂EMR.IP.COM.ActionFactory",2)
		}
		s ReturnValue=##Class(EMR.IP.COM.ActionFactory).AcitonProxy(objJson,argInData,argOutMessage,argOutData)
	}
	else
	{
		if (##class(%Dictionary.CompiledClass).%ExistsId("EMR.DOC.COM.ActionFactory") = "0") 
		{
			q ..SetOutMessage(argOutMessage,"ERROR","未找到命令工厂EMR.DOC.COM.ActionFactory",2)
		}
		s ReturnValue=##Class(EMR.DOC.COM.ActionFactory).AcitonProxy(objJson,argInData,argOutMessage,argOutData)
	}

	//异常批量处理
	s:(argOutMessage.errorMessage'="") argOutMessage.errorCode =argOutMessage.errorCode_",action:"_objJson.action_""
	
	//增加审计日志模块增加trycatch防止接口异常影响正常代码执行。
	try
	{
		s eventLog = ##class(EMR.DOC.BL.DHCEventLogConfig).SetEventLog(objJson)
	}
	catch exception
	{
		
	}
	q 1

ERROR					 
	q ..SetOutMessage(argOutMessage,"ERROR","请求参数错误0000",2)
}

/// Desc:  调试命令
/// Debug: d ##Class(EMR.DOC.COM.AbstractActionFactory).test()
ClassMethod test()
{
	s Stream =##class(%FileCharacterStream).%New()
	s Stream.Filename = "d:\195emr\22.txt"
    s argInData = ##class(%FileBinaryStream).%New()
    s argInData.Filename = "d:\argInData.txt" 
	s argOutMessage = ##class(%DynamicObject).%New()
	s argOutData = ##class(%FileBinaryStream).%New() 
	d ..CreateActionFactory(Stream,argInData,argOutMessage,argOutData)
	d argOutData.OutputToDevice()
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\SAVE_DOCUMENT1.xml"
	s argOutData = ##Class(%GlobalBinaryStream).%New()
	d argOutMessage.%ToJSON(argOutData)
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
}

/// Desc:  调试命令
/// Debug: d ##Class(EMR.OP.COM.AbstractActionFactory).yeTest()
ClassMethod yeTest()
{
	s Stream =##class(%FileCharacterStream).%New()
	s Stream.Filename = "/debug/44.txt"
	s strJson = {"action":"PRINT_DOCUMENT","params":{"documentID":["38"],"userID":"19829","userLocID":"100","printType":"EMR","pmdType":"EMR","pmdCode":"","ipAddress":"192.168.89.37","langID":"20"},"product":"OP"}
	d Stream.Write(strJson.%ToJSON())
    s argInData = ##class(%FileBinaryStream).%New()
    s argInData.Filename = "/tmp/yeargInData.txt" 
	s argOutMessage = ##class(%DynamicObject).%New()
	s argOutData = ##class(%GlobalBinaryStream).%New() 
	d ..CreateActionFactory(Stream,argInData,argOutMessage,.argOutData)
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
	s Stream =##class(%FileCharacterStream).%New()
	s Stream.Filename = "d:\44.txt"
    s argInData = ##class(%FileBinaryStream).%New()
    s argInData.Filename = "d:\yeargInData.txt" 
	s argOutMessage = ##class(%DynamicObject).%New()
	s argOutData = ##class(%GlobalBinaryStream).%New() 
	d ..CreateActionFactory(Stream,argInData,argOutMessage,.argOutData)
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

ClassMethod newTest()
{
	s argInJson = ##class(%DynamicObject).%New()
	s argInData = ##class(%GlobalBinaryStream).%New()
	s argOutMessage = ##class(%DynamicObject).%New()
	d ..DefaultOutMessage(argOutMessage)
	s argOutData = ##class(%GlobalBinaryStream).%New()
	d argInData.Write("aaaa")
	s strJson= "{""action"":""ADD_KB_MANAGE"",""params"":{""childType"":""IT"",""description"":"""",""id"":""1378||KT"",""name"":""22233"",""userCode"":""YS01"",""documentData"":""{\""page\"":\""片段片段\""}""},""product"":""GlobalEMR""}"
	set objJson = ##class(%DynamicAbstractObject).%FromJSON(strJson)
	s strProducts = objJson.product	
	if ((strProducts = "GlobalEMR")||(strProducts = ""))
	{
		s ReturnValue=##Class(EMR.DOC.COM.ActionFactory).AcitonProxy(objJson,argInData,argOutMessage,argOutData)
	}
	q 1
}

/// Desc:  调试命令
/// Debug: d ##Class(EMR.DOC.COM.AbstractActionFactory).test()
ClassMethod zzytest()
{
	s Stream =##class(%FileCharacterStream).%New()
	s Stream.Filename = "d:\55.txt"
    s argInData = ##class(%FileBinaryStream).%New()
    s argInData.Filename = "d:\argInData.txt" 
	s argOutMessage = ##class(%DynamicObject).%New()
	s argOutData = ##class(%FileBinaryStream).%New() 
	d ..CreateActionFactory(Stream,argInData,argOutMessage,argOutData)
	d argOutData.OutputToDevice()
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\SAVE_DOCUMENT1.xml"
	s argOutData = ##Class(%GlobalBinaryStream).%New()
	d argOutMessage.%ToJSON(argOutData)
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
}

/// Desc:  调试命令
/// Debug: d ##Class(EMR.DOC.COM.AbstractActionFactory).Htest()
ClassMethod Htest()
{
	s Stream =##class(%FileBinaryStream).%New()
	s Stream.Filename = "/debug/22.txt"
    s argInData = ##class(%FileBinaryStream).%New()
    s argInData.Filename = "/debug/argInData.txt" 
	s argOutMessage = ##class(%DynamicObject).%New()
	s argOutData = ##class(%FileBinaryStream).%New() 
	d ..CreateActionFactory(Stream,argInData,argOutMessage,argOutData)
	d argOutData.OutputToDevice()
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="/debug/SAVE_DOCUMENT1.xml"
	s argOutData = ##Class(%GlobalBinaryStream).%New()
	d argOutMessage.%ToJSON(argOutData)
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
}

}
