/// <H3>为TimeLine提供明细数据</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建者：2012-08-17</H4>
Class DHCMed.CCService.IntegratedControl.TimeLineService Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

ClassMethod Update(objResult As DHCMed.CC.CtlResult)
{
	n (objResult)
	Quit:$IsObject(objResult)=0 -1
	
	Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(objResult.KeyWord)
	Quit:$IsObject(objKeyword)=0 -3
	Set objTimeLineDataType=##class(icare.ClinicalDataType).%OpenId(objKeyword.Code)	
	Quit:$IsObject(objTimeLineDataType)=0 -2
	
	set obj=##class(icare.ClinicalRepository).%New()
	Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(objResult.EpisodeID)
	Do objAdm.%Close()
	Set obj.PatientID=objAdm.PatientID
	Set obj.EpisodeID=objResult.EpisodeID
	Set obj.ActDate=objResult.ActDate
	Set obj.ActTime=objResult.ActTime
	Set obj.Summary=objResult.Summary
	Set obj.DataValue=objResult.DataValue
	Set obj.ObjectID=objResult.ObjectID
	Set obj.Parameters=objResult.Parameters
	
	
	Do objTimeLineDataType.%Close()
	Set obj.DataTypeCode=objTimeLineDataType
	
	Set ActCode=objKeyword.Code_"01"
	Set objAct=##class(icare.ClinicalDataTypeAct).%OpenId(ActCode)
	Do objAct.%Close()
	Set obj.ActCode=objAct
	
	Set objUser=##class(DHCMed.Base.SSUser).GetObjById(objResult.UserID)
	Set:$IsObject(objUser)=0 objUser=##class(DHCMed.Base.SSUser).%New()
	Set obj.CareProviderID=objUser.CtpcpDr
	
	Set ret=obj.%Save()
	Quit obj.%Id()
}

}
