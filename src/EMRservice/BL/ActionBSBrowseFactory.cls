/// 名称:	EMRservice.BL.ActionBSBrowseFactory
/// 描述:	BS病历浏览公用程序层 Request数据请求代理工厂
/// 编写者:	yejian
/// 编写日期: 	2022-1-5
/// 产品组：	电子病历产品组
Class EMRservice.BL.ActionBSBrowseFactory Extends (%RegisteredObject, %XML.Adaptor)
{

/// Creator：      yejian
/// CreatDate：    2020-12-7
/// Description:   编辑器的命令工厂,解析argInMessage参数，进行分支处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"action":"GET_RECORDDATA_BYID","p1":"1||1","p2":false,"OutputType":"Stream"}
///                argInData    :传入的数据
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMR.DOC.COM.ActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod AcitonProxy(ByRef argInMessage As %GlobalBinaryStream, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	//定义错误处理函数
	s $ZT="ERROR"
	
	s strJson = argInMessage.Read(32000)
	s strJson = $zcvt(strJson,"I","UTF8") 
	set argInJson = ##class(%DynamicAbstractObject).%FromJSON(strJson)
	s array = argInJson
	s strAction = array.action
	s p1 =array.p1
	s p2 = array.p2
	s p3 = array.p3
	s p4 = array.p4
	
	/*
	//旧版数据(2016之前版本支持)
	s objJson = ##Class(EMRservice.BL.StreamDataTool).%New()  
	s argInParams = objJson.Deserialize(argInMessage)
	s strAction = argInParams.GetAt("action")
	s p1 = argInParams.GetAt("p1")
	s p2 = argInParams.GetAt("p2")
	s p3 = argInParams.GetAt("p3")
	s p4 = argInParams.GetAt("p4")
	*/
	//命令分发
	if (strAction = "GET_RECORDDATA_BYID")         
	{	
		//获取文档xml内容
		s objRes = ##Class(EMRservice.BL.BLBSEMRBrowse).GetData(p1,p2,p3,p4)
		d argOutData.CopyFrom(objRes) 
	}
	elseif(strAction = "FTP_STORE_DATA")
	{
		//上传HTML流
		s strRes = ##class(EMRservice.BL.FtpService).FTPStoreData(p1,argInData)
	}
	else
	{
		q "0"
	}
	q "1"
	
ERROR	
	q "0"
}

/// Desc:  调试命令
/// Debug: d ##Class(EMRservice.BL.ActionBSBrowseFactory).test()
ClassMethod test()
{
	s Stream =##class(%FileBinaryStream).%New()
	s Stream.Filename = "d:\22.txt"
    s argInData = ##class(%FileBinaryStream).%New()
    s argInData.Filename = "d:\argInData.txt" 
	s argOutMessage = ##class(%DynamicObject).%New()
	s argOutData = ##class(%GlobalBinaryStream).%New() 
	d ..AcitonProxy(Stream,argInData,argOutMessage,.argOutData)
	w argOutData.Read()
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\SAVE_DOCUMENT1.xml"
	;s argOutData = ##Class(%GlobalBinaryStream).%New()
	;d argOutMessage.%ToJSON(argOutData)
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
}

}
