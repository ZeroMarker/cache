Class web.eprajax.deleteChart Extends %CSP.Page [ ProcedureBlock ]
{

ClassMethod OnPage() As %Status
{
	//获取对应参数。不存在则赋默认值-1
	s EpisodeID  = $Get(%request.Data("EpisodeID",1),"-1")
	s PatientID = $Get(%request.Data("PatientID",1),"-1")
	s PrintTemplateDocID  = $Get(%request.Data("EPRDocID",1),"-1")
	s TemplateDocID  = $Get(%request.Data("TemplateDocID",1),"-1")
	s TemplateID = $Get(%request.Data("BindTemplateID",1),"-1")
	s EPRNum  = $Get(%request.Data("EPRNum",1),"-1")
	s OldPrtDocID = $Get(%request.Data("DocID",1),"-1")			//原打印模板DocID
	s NewPrtDocID = $Get(%request.Data("newDocID",1),"-1")		//新打印模板DocID
	s PrintTemplateType = $zcvt($Get(%request.Data("PrintTemplateType",1),"-1"),"U")
	s ListChartItemID = $Get(%request.Data("ListChartItemID",1),"-1")
	s Action = $g(%request.Data("Action",1),"")
	
	if Action="DumpData"
	{
		s isOK =..DumpData(EpisodeID,TemplateID,PrintTemplateType,ListChartItemID,EPRNum)
		q:(isOK '= "1") "failed"
		
		w "success"
		Quit $$$OK
	}
	elseif Action="ELSE" 
	{
		//d ..Global(EpisodeID,ListChartItemID)
		w "success"
		Quit $$$OK
	}
}

//w ##class(web.eprajax.deleteChart).DumpData("503","5","","ML627","1")

ClassMethod DumpData(AEpisodeID, ATemplateID, APrintTemplateType, AListChartItemID, AEPRNum) As %String
{
	s ^CacheTempDHCEPRDebug("web.eprajax.deleteChart","input")=AEpisodeID_","_ATemplateID_","_APrintTemplateType_","_AListChartItemID_","_AEPRNum
	
	s InstanceID=""
	//判断打印模板类型前台传输参数的问题；
	//如果是唯一模板传送打印模板类型，索引时要加CG；
	//可重复模板则是传送ListChartItemID，比如ML627。
	if (APrintTemplateType="SINGLE")!(AListChartItemID=-1)
	{
		s InstanceID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," CG"_ATemplateID,""))
		Quit:(InstanceID="") -1
		
		Quit:(-1=##class(EPRservice.BORecInstanceData).DumpData(InstanceID_"||1")) -1
		Quit $$$OK
	}
	elseif ($e(AListChartItemID,1,2)="ML")
	{
		b "s"
		s ecRecordID = $o(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_AListChartItemID,""))
		Quit:(ecRecordID="") -1
		
		s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID," "_AEPRNum,""))
		q:(childSub="") -1
		
		s instanceID = ecRecordID_"||"_childSub
		Quit:(-1=##class(EPRservice.BORecInstanceData).DumpData(instanceID,"Multi")) -1
		Quit $$$OK
	}
}

ClassMethod Test()
{
}

}
