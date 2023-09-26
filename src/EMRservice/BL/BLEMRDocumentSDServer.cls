/// 名称:EMRservice.BL.BLEMRDocumentSDServer
/// 描述:病历共享文档访问接口业务类
/// 编写者：Guozongtao
/// 编写日期: 2016-10-30
Class EMRservice.BL.BLEMRDocumentSDServer Extends (%RegisteredObject, %XML.Adaptor)
{

Parameter ERROR = "{""params"":{""result"":""ERROR""";

Parameter NONE = "NONE";

/// Creator：      guozongtao
/// CreatDate：    2016-10-29
/// Description:   共享文档生成工厂,解析argInMessage参数，进行分支处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"params":{"EisodeID":"1","InternalID":"HDSD00.03"},"Action":"Save","Products":"GlobalEMR"}
///                其中：Action参数为枚举值：EMR.Save\EMR.Sign.OK\EMR.Print.OK\EMR.Print.OK
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.BOActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod AcitonProxy(ByRef argInMessage As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	//定义错误处理函数
	s $ZT="ERROR"
	
	//解析json参数		       
	s objJson = ##Class(EMRservice.Parser.Json).%New()
	s array = objJson.Deserialize(argInMessage)
	s strInternalID = array.GetAt("params").GetAt("InternalID")
	 
	s ReturnValue=""

	//文档分发HDSD000301
	if (strInternalID = "HDSD00.03")  
	{
		//生成门急诊病历导出文档
    	s ReturnValue=##Class(EMRservice.BL.SDHDSD000301).XMLSerialize(array,argOutMessage,argOutData)
    	
	}
	elseif(strInternalID = "HDSD00.04")
	{
		//生成XXX病历导出文档
    	//d ..LoadDocumentIndex(array,argOutMessage,argOutData)
	}
	
	q ReturnValue
	
ERROR			
	d argOutMessage.Write(..#ERROR_",""Err"":"""_$zerror_"""}}")
	d argOutData.Write(..#NONE)	 	        
	q "0"
}

/// d ##CLASS(EMRservice.BL.BLEMRDocumentSDServer).Test()
ClassMethod Test()
{
	s InMessage =##class(%FileCharacterStream).%New()
	s InMessage.Filename = "/tmp/InMessage.txt"
	//s ret= ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000053",InMessage.Read())
	
	s argOutMessage = ##class(%FileBinaryStream).%New() 
	s argOutData = ##class(%FileCharacterStream).%New()
	d ..AcitonProxy(InMessage,argOutMessage,argOutData)
	//d argOutData.OutputToDevice()
	d argOutMessage.OutputToDevice()
	s AStream=##Class(%FileCharacterStream).%New()
	s AStream.Filename="/tmp/SD_DOCUMENT1.xml"
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
	q
}

}
