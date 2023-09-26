/// 名称:EMRservice.BOMessageServer
/// 描述:编辑器插件交互服务
/// 编写者：Guozongtao
/// 编写日期: 2013-12-25
Class EMRservice.BOMessageServer Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      guozongtao
/// CreatDate：    2013-12-25
/// Description:   命令代理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"params":"{\"docId\":\"160202\", \"actionUrl\":\"/editor/diseasedoc/load.cmd\"}","type":"action"}。
///                argInData    :传入的数据
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.BOMessageServer).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)	
Method AcitonProxy(argInMessage As %GlobalBinaryStream, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s argOutMessage=##Class(%GlobalBinaryStream).%New()
	s argOutData=##Class(%GlobalBinaryStream).%New()
		
	//s ReturnValue=##Class(EMRservice.BOActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)
	
	s ReturnValue=##Class(EMRservice.BOAbstractActionFactory).CreateActionFactory(argInMessage,argInData,argOutMessage,argOutData)
	
	quit ReturnValue
}

}
