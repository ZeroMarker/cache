/// 名称:	EMR.OP.COM.AbstractActionFactory
/// 描述:	门诊病历--公用程序层 Request数据请求抽象工厂
/// 编写者:	yejian
/// 编写日期: 	2020-12-7
/// 产品组：	电子病历产品组
Class EMR.OP.COM.AbstractActionFactory Extends EMR.OP.COM.ActionBase
{

/// Creator：      yejian
/// CreatDate：    2021-7-19
/// Description:   文档管理的命令抽象工厂,解析argInMessage参数，按照产品线分配，分支处理，由各自产品线的工厂类处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"params":"{\"docId\":\"160202\", \"actionUrl\":\"/editor/diseasedoc/load.cmd\"}","Product":"GlobalEMR"}。
///                argInData    :传入的数据
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.OP.COM.AbstractActionFactory).CreateActionFactory(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod CreateActionFactory(ByRef argInMessage As %GlobalBinaryStream, argInData As %GlobalBinaryStream, ByRef argOutMessage As %DynamicObject, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	//定义错误处理函数
	s $ZT="ERROR"
	
	//解析json参数		       
	//s objJson = ##Class(EMR.DOC.COM.Parser.Json).%New()  
	//s array = objJson.Deserialize(argInMessage)
	s strJson = argInMessage.Read(32000)
	s strJson = $zcvt(strJson,"I","UTF8") 
	//s ^CreateActionFactory("1") = strJson
	//s ^CreateActionFactory("2") = argInData.Read(32000)
	set objJson = ##class(%DynamicAbstractObject).%FromJSON(strJson)

	s strProducts = objJson.product	
	if ((strProducts = "GlobalEMR")||(strProducts = ""))
	{
		s ReturnValue=##Class(EMR.OP.COM.ActionFactory).AcitonProxy(objJson,argInData,argOutMessage,argOutData)
	
	}
	q 1

ERROR					 
	q ..SetOutMessage(argOutMessage,"ERROR","请求参数错误0000",2)
}

/// Desc:  调试命令
/// Debug: d ##Class(EMR.OP.COM.AbstractActionFactory).test()
ClassMethod test()
{
	s Stream =##class(%FileBinaryStream).%New()
	s Stream.Filename = "d:\33.txt"
    s argInData = ##class(%FileBinaryStream).%New()
    s argInData.Filename = "d:\argInData.txt" 
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

/// Desc:  调试命令
/// Debug: d ##Class(EMR.OP.COM.AbstractActionFactory).yeTest()
ClassMethod yeTest()
{
	s Stream =##class(%FileBinaryStream).%New()
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

}
