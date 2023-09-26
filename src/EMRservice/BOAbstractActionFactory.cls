/// 名称:EMRservice.BOAbstractActionFactory
/// 描述:编辑器交互命令抽象工厂，解决多产品线应用编辑问题
/// 编写者：Guozongtao
/// 编写日期: 2016-7-25
Class EMRservice.BOAbstractActionFactory Extends %RegisteredObject
{

Parameter OK = "{""params"":{""result"":""OK""";

Parameter ERROR = "{""params"":{""result"":""ERROR""";

Parameter NONE = "NONE";

/// Creator：      guozongtao
/// CreatDate：    2013-12-25
/// Description:   编辑器的命令抽象工厂,解析argInMessage参数，按照产品线分配，分支处理，由各自产品线的工厂类处理
/// Table：        
/// Input：        argInMessage :命令信息 JSON格式  {"params":"{\"docId\":\"160202\", \"actionUrl\":\"/editor/diseasedoc/load.cmd\"}","Products":"GlobalEMR"}。
///                argInData    :传入的数据
/// Output         argOutMessage:传出的函数处理信息
///                argOutData   :传出数据
/// Return：       函数返回值的说明
/// Others：       其它说明
/// Debug:         w ##Class(EMRservice.BOAbstractActionFactory).Create(argInMessage,argInData,argOutMessage,argOutData)	
ClassMethod CreateActionFactory(ByRef argInMessage As %GlobalBinaryStream, argInData As %GlobalBinaryStream, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	
	//定义错误处理函数
	s $ZT="ERROR"
	
	//解析json参数		       
	s objJson = ##Class(EMRservice.Parser.Json).%New()  
	s array = objJson.Deserialize(argInMessage)
	
	s strProducts = array.GetAt("product")	
	if ((strProducts = "GlobalEMR")||(strProducts = ""))
	{
		s ReturnValue=##Class(EMRservice.BOActionFactory).AcitonProxy(array,argInData,argOutMessage,argOutData)
	
	}
	/// 临床药学平台
	if (strProducts = "GlobalPHCM")
	{
		s ReturnValue=##Class(web.DHCCM.EMRservice.BOActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)
	}
	//辅助生殖
	if (strProducts = "GlobalART")
	{
		s ReturnValue=##Class(EMR.ART.DAL.EMRActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)
	
	}
	//打印
	if (strProducts = "GlobalPRINT")
	{
		s ReturnValue=##Class(EMRservice.PrintActionFactory).AcitonProxy(argInMessage,argInData,argOutMessage,argOutData)
	}
	q 1

ERROR					 
	d argOutMessage.Write(..#ERROR_",""Err"":"""_$zerror_"""}}")
	d argOutData.Write(..#NONE)	 	        
	q "0"
}

/// Desc:  调试命令
/// Debug: d ##Class(EMRservice.BOAbstractActionFactory).test()
ClassMethod test()
{
	s Stream =##class(%FileBinaryStream).%New()
	//s Stream.Filename = "d:\22.txt"
	d Stream.Write("{""params"":{""DateTime"":"""",""DiseaseID"":""0"",""EpisodeID"":""9"",""HospitalID"":""2"",""IPAddress"":""192.168.110.77"",""InstanceID"":[""8||14"",""8||15"",""8||16""],""LoadDocMode"":""BATCH"",""PatientID"":""17"",""ProductSourceCode"":"""",""ProductSourceType"":""EMR"",""SessionID"":""AA36BE902629064B08F6D7DABC66FA06"",""SsgroupID"":""29"",""UserCode"":""ys01"",""UserID"":""18881"",""UserLocID"":""191"",""UserName"":""医生01"",""action"":""LOAD_DOCUMENT"",""status"":""NORMAL""},""product"":""GlobalEMR"",""type"":""action""}")
    s argInData = ##class(%FileBinaryStream).%New() 
	s argOutMessage = ##class(%FileBinaryStream).%New() 
	s argOutData = ##class(%FileBinaryStream).%New() 
	d ..CreateActionFactory(Stream,argInData,argOutMessage,argOutData)
	//d argOutData.OutputToDevice()
	s AStream=##Class(%FileBinaryStream).%New()
	s AStream.Filename="d:\SAVE_DOCUMENT1.xml"
	d AStream.CopyFrom(argOutData)
	d AStream.SaveStream()
	d AStream.%Close()
}

}
