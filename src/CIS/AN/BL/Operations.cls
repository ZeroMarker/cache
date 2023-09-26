/// 实施手术信息
Class CIS.AN.BL.Operations Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-1-8
/// Description： 	查询手术列表
/// Table：        	DHCAN.OperationList
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperationList","FindOperationList","6")
Query FindOperationList(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RowId As AnaOperID,
	   OperSchedule,
	   Operation,
	   CIS_AN_COM.String_GetDescByID("CT.AN.Operation","Description",Operation) As OperationDesc,
	   OperClass,
	   OperClass->Description As OperClassDesc,
	   BladeType,
	   BladeType->Description As BladeTypeDesc,
	   BodySite,
	   BodySite->Description As BodySiteDesc,
	   OperPos,
	   OperPos->Description As OperPosDesc,
	   Surgeon,
	   CIS_AN_COM.String_GetDescByID("User.RBResource","RESDesc",Surgeon) As SurgeonDesc,
	   CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPDesc",Surgeon) As SurCareProvDesc,
	   CIS_AN_COM.String_GetDescByID("User.CTCareProv","CTPCPOtherName",Surgeon) As SurgeonShortDesc,
	   Assistant,
	   CIS_AN_BL.OperationList_GetAssistantDesc(Assistant) As AssistantDesc,
	   SurgeonDeptID,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",SurgeonDeptID) As SurgeonDeptDesc,
	   AddtionalStaff,
	   OperNote,
	   CIS_AN_BL.OperationList_GetOperInfo(Operation,OperNote,OperClass->Description,BodySite->Description) As OperInfo
	   from CIS_AN.OperList
	   where OperSchedule=:opsId
}

/// Creator：      	雍阳
/// CreatDate：    	2017-12-14
/// Description： 	查询拟施手术列表
/// Table：        	DHCAN.PlanOperationList
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperationList","FindPlanOperationList","8")
Query FindPlanOperationList(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RowId As AnaOperID,
	   OperSchedule,
	   Operation,
	   CIS_AN_COM.String_GetDescByID("CT.AN.Operation","Description",Operation) As OperationDesc,
	   OperClass,
	   OperClass->Description As OperClassDesc,
	   BladeType,
	   BladeType->Description As BladeTypeDesc,
	   BodySite,
	   BodySite->Description As BodySiteDesc,
	   OperPos,
	   OperPos->Description As OperPosDesc,
	   Surgeon,
	   CIS_AN_COM.String_GetDescBySQL("SQLUser.RB_Resource","RES_CTPCP_DR->CTPCP_Desc",Surgeon) As SurgeonDesc,
	   CIS_AN_COM.String_GetDescBySQL("SQLUser.RB_Resource","RES_CTPCP_DR->CTPCP_OtherName",Surgeon) As SurgeonShortDesc,
	   Assistant,
	   CIS_AN_BL.OperationList_GetAssistantDesc(Assistant) As AssistantDesc,
	   SurgeonDeptID,
	   CIS_AN_COM.String_GetDescByID("User.CTLoc","CTLOCDesc",SurgeonDeptID) As SurgeonDeptDesc,
	   AddtionalStaff,
	   OperNote,
	   CIS_AN_BL.OperationList_GetOperInfo(Operation,OperNote,OperClass->Description,BodySite->Description) As OperInfo
	   from CIS_AN.PlanOperList
	   where OperSchedule=:opsId
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-9
/// Description： 	获取手术助手名称
/// Table：        	SQLUser.CT_CareProv
/// Input:			assIdStr:手术助手ID，多个助手以","拼接
/// Return：       	手术助手名称，多个助手以","拼接
/// w ##class(CIS.AN.BL.OperationList).GetAssistantDesc("1")
ClassMethod GetAssistantDesc(assIdStr As %String) As %String [ SqlProc ]
{
	set assIdCount=$length(assIdStr,","),result=""
	for i=1:1:assIdCount
	{
		set assId=$p(assIdStr,",",i)
		set careProvDesc=##class(CIS.AN.COM.String).GetDescBySQL("SQLUser.RB_Resource","RES_CTPCP_DR->CTPCP_Desc",assId)
		set:(careProvDesc="") careProvDesc=assId
		if (i>1)&(assId'="")
		{
			set result=result_","	
		}	
		set result=result_careProvDesc
	}	
	
	quit result
}

/// Creator：      	雍阳
/// CreatDate：    	2018-8-30
/// Description： 	获取手术名称
/// Table：        	
/// Input:			operation:手术名称ID，operNote:手术备注
/// Return：       	
/// w ##class(CIS.AN.BL.OperationList).GetOperInfo("1")
ClassMethod GetOperInfo(operation, operNote, operClassDesc = "", bodySiteDesc = "") As %String [ SqlProc ]
{
	set result = ""
	if operation>0 
	{
		set result = ##class(CIS.AN.COM.String).GetDescByID("CT.AN.Operation","Description",operation)
	}
	else 
	{
		set result = operNote
	}
	
	//if (operClassDesc'="")&(bodySiteDesc'="")
	//{
	//	set result=result_"("_operClassDesc_","_bodySiteDesc_")"	
	//}
		
	quit result
}

ClassMethod GetSurgeonDesc(opsId As %String) As %String
{
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	set sc=rset.Execute(opsId)
	set ret=""
	while(rset.%Next())
	{
		set surgeonDesc=rset.Get("SurgeonDesc")
		if (ret'="")
		{
			set ret=ret_","	
		}	
		set ret=ret_surgeonDesc
	}	
	quit ret
}

/// Creator：      	唐潇
/// CreatDate：    	2018-12-28
/// Description： 	术后登记
/// Table：        	CIS.AN.OperSchedule
/// Input:			opsId:手术排班ID
/// Return：       	
/// w ##class(CIS.AN.BL.OperationList).RegOperation("1")
ClassMethod RegOperation(opsId As %String) As %String
{
	q:'##class(CIS.AN.OperSchedule).%ExistsId(opsId) "E^该条手术记录不存在"
	set $zt="Error"
	tstart
	s OperSchedule=##class(CIS.AN.OperSchedule).%OpenId(opsId)
	s opaId=OperSchedule.ExternalID
	d OperSchedule.StatusSetObjectId(7)
	s sc=OperSchedule.%Save()
	q:$$$ISERR(sc) "E^"_$system.Status.GetErrorText(sc)
	s $p(^DHCANOPArrange(opaId),"^",27)="F"
	TCOMMIT
	quit "S^"
Error
	trollback
	quit "E^"_$ze
}

ClassMethod GetOperDescInfo(opsId As %String, operDescList As %String) As %String
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	set sc=rs.Execute(opsId)
	set operationDesc="",operNote="",surgeon="",surgeonDesc="",assistant="",assistantDesc=""
	set bodySite="",bodySiteDesc="",bladeType="",bladeTypeDesc="",operPos="",operPosDesc="",operClass="",operClassDesc=""
	set splitChar=","
	while(rs.%Next())
	{
		set curOperDesc=rs.Get("OperationDesc")	
		set curOperNote=rs.Get("OperNote")
		set:(curOperDesc="") curOperDesc=curOperNote
		set curSurgeon=rs.Get("Surgeon")
		set curSurgeonDesc=rs.Get("SurgeonDesc")
		set:(curSurgeonDesc="") curSurgeonDesc=curSurgeon
		set curAssistant=rs.Get("Assistant")
		set curAssistantDesc=rs.Get("AssistantDesc")
		set curBodySite=rs.Get("BodySite")
		set curBodySiteDesc=rs.Get("BodySiteDesc")
		set curBladeType=rs.Get("BladeType")
		set curBladeTypeDesc=rs.Get("BladeTypeDesc")
		set curOperPos=rs.Get("OperPos")
		set curOperPosDesc=rs.Get("OperPosDesc")
		set curOperClass=rs.Get("OperClass")
		set curOperClassDesc=rs.Get("OperClassDesc")
		
		set:(operationDesc'="")&(curOperDesc'="") operationDesc=operationDesc_splitChar
		set operationDesc=operationDesc_curOperDesc
		
		set:(operNote'="")&(curOperNote'="") operNote=operNote_splitChar
		set operNote=operNote_curOperNote
		
		set:(surgeonDesc'="")&(curSurgeonDesc'="") surgeonDesc=surgeonDesc_splitChar
		set surgeonDesc=surgeonDesc_curSurgeonDesc
		
		set:(surgeon'="")&(curSurgeon'="") surgeon=surgeon_splitChar
		set surgeon=surgeon_curSurgeon
		
		set:(assistant'="")&(curAssistant'="") assistant=assistant_splitChar
		set assistant=assistant_curAssistant
		
		set:(assistantDesc'="")&(curAssistantDesc'="") assistantDesc=assistantDesc_splitChar
		set assistantDesc=assistantDesc_curAssistantDesc
		
		set:(bodySite'="")&(curBodySite'="") bodySite=bodySite_splitChar
		set bodySite=bodySite_curBodySite
		
		set:(bodySiteDesc'="")&(curBodySiteDesc'="") bodySiteDesc=bodySiteDesc_splitChar
		set bodySiteDesc=bodySiteDesc_curBodySiteDesc
		
		set:(bladeType'="")&(curBladeType'="") bladeType=bladeType_splitChar
		set bladeType=bladeType_curBladeType
		
		set:(bladeTypeDesc'="")&(curBladeTypeDesc'="") bladeTypeDesc=bladeTypeDesc_splitChar
		set bladeTypeDesc=bladeTypeDesc_curBladeTypeDesc
		
		set:(assistantDesc'="")&(curAssistantDesc'="") assistantDesc=assistantDesc_splitChar
		set assistantDesc=assistantDesc_curAssistantDesc
		
		set:(assistantDesc'="")&(curAssistantDesc'="") assistantDesc=assistantDesc_splitChar
		set assistantDesc=assistantDesc_curAssistantDesc
		
		set:(assistantDesc'="")&(curAssistantDesc'="") assistantDesc=assistantDesc_splitChar
		set assistantDesc=assistantDesc_curAssistantDesc
		
		set:(assistantDesc'="")&(curAssistantDesc'="") assistantDesc=assistantDesc_splitChar
		set assistantDesc=assistantDesc_curAssistantDesc
		
	}
}

}
