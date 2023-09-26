/// 反馈接口
Class DHCMed.CCService.Feedback.FeedbackInterface Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// <H3>功能：查询某个患者的自动监控反馈</H3>
/// <H4>参数:</H4>
/// <OL>
/// <LI><B>EpisodeID</B>:就诊号，Paadm</LI>
/// <LI><B>Status</B>：0--未响应的反馈  1--已响应的反馈</LI>
/// </OL>
/// <H4>返回值:</H4>
/// 如果程序运行成功，返回结果字符串
/// <H4>实例</H4>
/// w ##class(DHCMed.CCService.Feedback.FeedbackInterface).GetCCAutoWorkFeedBackCnt(6,1)
ClassMethod GetCCAutoWorkFeedBackCnt(SubjectCode, EpisodeID, RepType, Status)
{
	New (SubjectCode, EpisodeID, RepType ,Status)
	Set ret=""
	Quit:EpisodeID="" ""
	
	Set Status=$g(Status)
	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode) //Modified By LiYang 通过Subject，RepType过滤反馈信息
	Quit:$IsObject(objSubject)=0 ret
	
	Set SubjectID=objSubject.%Id()
	Set NoResponse=0
	Set Response=0
	Set RowID=""
	if (RepType'="") {
		Set objRepTypeDic=##class(DHCMed.SS.Dictionary).GetByTypeCode($ZConvert("FeedBackRepType","U"),RepType,"")
		Set:'$IsObject(objRepTypeDic) objRepTypeDic=##class(DHCMed.SS.Dictionary).%New()
		Do objRepTypeDic.%Close()
	}
	else
	{
		Set:'$IsObject(objRepTypeDic) objRepTypeDic=##class(DHCMed.SS.Dictionary).%New()
		Set objRepTypeDic.Description="综合检测"
		Do objRepTypeDic.%Close()			
	}
	For {
		Set RowID=$o(^DHCMed.CC.CtlResultI("CtlFeedback","IndexEpisodeSubjectID",EpisodeID,SubjectID,RowID))
		Quit:RowID=""
		
		Set objFeedback=##class(DHCMed.CC.CtlFeedback).%OpenId(RowID)
		Continue:$IsObject(objFeedback)=0
		Continue:((objFeedback.FeedBackRepType'=RepType)&&(RepType'=""))
		Do objFeedback.%Close()
		Set:(objFeedback.Status=0) NoResponse=NoResponse+1
		Set:(objFeedback.Status'=0) Response=Response+1
	}
	Set:((Status=0)&&(NoResponse>0)) ret=objRepTypeDic.Description_"：有"_NoResponse_"条未处理的提示信息!"	
	Set:((Status=1)&&(Response>0)&&(NoResponse=0)) ret=objRepTypeDic.Description_"有"_Response_"条已处理的提示信息!"		
	Quit ret
}

}
