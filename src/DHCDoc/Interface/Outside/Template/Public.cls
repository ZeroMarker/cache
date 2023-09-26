/// 本接口公共通用方法
/// 
Class DHCDoc.Interface.Outside.Template.Public Extends %RegisteredObject [ Abstract, Not ProcedureBlock ]
{

/// ;根据身份证取最近的患者病人ID,需要配置，根据配置确定是否在多ID的情况下返回空
ClassMethod GetHighestLevelPAPMIByIDNo(IDNo As %String) As %String
{
	n (IDNo)
	;w ##class(DHCDoc.Interface.Outside.OPAlloc.SelfRegPlulic).GetHighestLevelPAPMIByIDNo("412726199104176977")
	q:IDNo="" ""
	s PAPMI=""
	s IDNo=$$ALPHAUP^SSUTIL4(IDNo)
	i $L(IDNo)=18 {
		s IDCard=##class(DHCDoc.Util.Base).ID18to15(IDNo)
	}elseif $L(IDNo)=15 {
		s IDCard=##class(DHCDoc.Util.Base).ID15to18(IDNo)
	}elseif $L(IDNo)'="" {
		s IDCard=""
	}
	s IDNoStr=IDNo_"^"_IDCard
	s PAPMIRowIdStr=""
	s MulIDCount=0
	
	for IDLoop=1:1:$l(IDNoStr,"^") {
		s IDNo=$p(IDNoStr,"^",IDLoop)
		continue:IDNo=""
		s PAPMIRowId=0
		for {
			s PAPMIRowId=$O(^PAPERi("DVA",IDNo,PAPMIRowId)) q:PAPMIRowId=""
			s PatMasActive=$P($G(^PAPER(PAPMIRowId,"PAT",1)),"^",6)
			continue:PatMasActive="N"
			s MulIDCount=MulIDCount+1
			i PAPMIRowIdStr="" s PAPMIRowIdStr=PAPMIRowId
			e  s PAPMIRowIdStr=PAPMIRowIdStr_"^"_PAPMIRowId
		}
	}
	;TODO 需要配置，根据配置确定是否在多ID的情况下返回空
	i PAPMIRowIdStr'="" s PAPMI=$P(PAPMIRowIdStr,"^",$L(PAPMIRowIdStr,"^"))
	
	q PAPMI_"^"_MulIDCount
}

/// 得到入参对象
ClassMethod GetInputObjFromJson(TradeCode, JsonRequest, Output pObject As %RegisteredObject) As %String
{
	s:TradeCode="3030" ClassName="DHCDoc.Interface.Outside.Template.Entity.GetPatInfoRq"
	s:TradeCode="3031" ClassName="DHCDoc.Interface.Outside.Template.Entity.BuildMedicalRq"
	s:TradeCode="1012" ClassName="DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRq"
	
	s sc=##Class(ext.util.JsonObject).JSONStreamToObject(JsonRequest,.pObject,ClassName)
	
	q sc
}

/// 将对象转换为JSON格式
ClassMethod FromObjectJson(pObject As %RegisteredObject) As %GlobalCharacterStream
{
	s jsonObj = ##class(ext.util.JsonObject).%New()
	s json = jsonObj.FromObject(pObject).Json()
	s stream=##Class(%GlobalCharacterStream).%New()
	d stream.Write(json)
	
	q stream
}

/// 得到入参对象
ClassMethod GetInputObj(TradeCode, XMLRequest) As %RegisteredObject
{
	s:TradeCode="3030" ClassName="DHCDoc.Interface.Outside.Template.Entity.GetPatInfoRq"
	s:TradeCode="3031" ClassName="DHCDoc.Interface.Outside.Template.Entity.BuildMedicalRq"
	s:TradeCode="1012" ClassName="DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRq"
	
	s InputObj=$ZOBJCLASSMETHOD(ClassName,"%New")
	d InputObj.XMLNodeDeserialize(.InputObj,"Request",XMLRequest)
	q InputObj
}

/// 得到出参对象
ClassMethod GetOutputObj(TradeCode) As %RegisteredObject
{
	s:TradeCode="3030" ClassName="DHCDoc.Interface.Outside.Template.Entity.GetPatInfoRp"
	s:TradeCode="3031" ClassName="DHCDoc.Interface.Outside.Template.Entity.BuildMedicalRp"
	s:TradeCode="1012" ClassName="DHCDoc.Interface.Outside.Template.Entity.QueryDepartmentRp"
	
	s OutputObj=$ZOBJCLASSMETHOD(ClassName,"%New")
	q OutputObj
}

/// 赋值出参标识
ClassMethod SetOutputCode(ByRef object As %ObjectHandle, ResultCode As %String, ResultContent As %String)
{
	s object.ResultCode=ResultCode
	s object.ResultContent=ResultContent
}

}
