/// 名称:EMRservice.BL.BLEMRCDAAssistData
/// 描述:交互命令工厂-请求电子病历CDA相关辅助数据
/// 编写者：niucaicai
/// 编写日期: 2018-11-05
Class EMRservice.BL.BLEMRCDAAssistData Extends %RegisteredObject
{

Parameter OK = "{""params"":{""result"":""OK""";

Parameter ERROR = "{""params"":{""result"":""ERROR""";

Parameter NONE = "NONE";

/// w ##Class(EMRservice.BL.BLEMRCDAAssistData).GetToothPositionByCode("AUL.1")
ClassMethod GetToothPositionByCode(AToothCode As %String, ByRef argOutMessage As %GlobalBinaryStream, ByRef argOutData As %GlobalBinaryStream) As %String
{
	s $zt = "Error"
	if (AToothCode = "")
	{
		d argOutData.Write(..#NONE)
		d argOutMessage.Write(..#NONE)
		q
	}
	
	s ToothInfo = ##Class(EMRservice.BL.BLToothPosition).GetToothPositionByCode(AToothCode)
	s ToothDisplayName = $p(ToothInfo,"^",4)
	
	s json = ##Class(%GlobalBinaryStream).%New()
	d json.Write(",""ToothDisplayName"":"""_$zcvt(ToothDisplayName,"O","UTF8"))
	d json.Write(""",""ToothCode"":"""_$zcvt(AToothCode,"O","UTF8")_"""")
	if (json.Size '= 0)
	{
		d argOutMessage.Write(..#OK)
		d argOutMessage.CopyFrom(json)
		d argOutMessage.Write("}}")
	}
	else
	{
		d argOutMessage.Write(..#ERROR)
		d argOutMessage.CopyFrom(json)
		d argOutMessage.Write("}}")
	}
	d argOutData.Write(..#NONE)
Error
	q argOutMessage.Write(..#ERROR_",""Error"":"""_$zerror_"""}}")
}

}
