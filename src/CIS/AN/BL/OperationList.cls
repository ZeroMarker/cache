/// 手术列表业务逻辑
Class CIS.AN.BL.OperationList Extends %RegisteredObject
{

/// Creator：      	陈长青
/// CreatDate：    	2017-1-8
/// Description： 	查询手术列表
/// Table：        	DHCAN.OperationList
/// Input:			opsId:手术计划ID
/// Return：       	ResultSet
/// d ##class(%ResultSet).RunQuery("CIS.AN.BL.OperationList","FindOperationList","21")
Query FindOperationList(opsId As %String) As %SQLQuery(CONTAINID = 1)
{
SELECT RowId,
	   RowId As AnaOperID,
	   OperSchedule,
	   Operation,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation) As OperationDesc,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation,"N",OperNote) As OperInfo,
	   OperClass,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperationCategory','CATEGDesc',OperClass) As OperClassDesc,
	   BladeType,
	   CIS_AN_COM.String_GetDescByID('User.ORCBladeType','BLDTPDesc',BladeType) As BladeTypeDesc,
	   BodySite,
	   CIS_AN_BL.OperationList_GetBodySiteDesc(BodySite) As BodySiteDesc,
	   OperPos,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperPosition','OPPOSDesc',OperPos) As OperPosDesc,
	   Surgeon,
	   CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',Surgeon,'Y') As SurgeonDesc,
	   CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',Surgeon,'Y') As SurCareProvDesc,
	   UPPER(CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPOtherName',Surgeon,'Y')) As SurgeonShortDesc,
	   Assistant,
	   CIS_AN_BL.OperationList_GetAssistantDesc(Assistant) As AssistantDesc,
	   SurgeonDeptID,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',SurgeonDeptID) As SurgeonDeptDesc,
	   AddtionalStaff,
	   OperNote,
	   ExternalID,
	   SurgeonExpert,
	   SKDOperID,
	   EmergencyOperation,
	   %EXTERNAL(EmergencyOperation) As EmergencyOperationDesc
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
	   CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation) As OperationDesc,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperation','OPERDesc',Operation,"N",OperNote) As OperInfo,
	   OperClass,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperationCategory','CATEGDesc',OperClass) As OperClassDesc,
	   BladeType,
	   CIS_AN_COM.String_GetDescByID('User.ORCBladeType','BLDTPDesc',BladeType) As BladeTypeDesc,
	   BodySite,
	   CIS_AN_COM.String_GetDescByID('User.OECBodySite','BODSDesc',BodySite) As BodySiteDesc,
	   OperPos,
	   CIS_AN_COM.String_GetDescByID('User.ORCOperPosition','OPPOSDesc',OperPos) As OperPosDesc,
	   Surgeon,
	   CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',Surgeon) As SurgeonDesc,
	   CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPDesc',Surgeon) As SurCareProvDesc,
	   UPPER(CIS_AN_COM.String_GetDescByID('User.CTCareProv','CTPCPOtherName',Surgeon)) As SurgeonShortDesc,
	   Assistant,
	   CIS_AN_BL.OperationList_GetAssistantDesc(Assistant) As AssistantDesc,
	   SurgeonDeptID,
	   CIS_AN_COM.String_GetDescByID('User.CTLoc','CTLOCDesc',SurgeonDeptID) As SurgeonDeptDesc,
	   AddtionalStaff,
	   OperNote,
	   ExternalID,
	   SurgeonExpert,
	   SKDOperID,
	   EmergencyOperation,
	   %EXTERNAL(EmergencyOperation) As EmergencyOperationDesc
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
	Set lang="20",sessionLang=""
	Set:($DATA(%session)) sessionLang=$GET(%session.Data("LOGON.LANGID"))
	Set:(sessionLang'="") lang=sessionLang
	set assIdCount=$length(assIdStr,","),result=""
	for i=1:1:assIdCount
	{
		set assId=$p(assIdStr,",",i)
		set careProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",assId,"Y")
    	set careProvDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",careProvDesc,lang)
		set:(careProvDesc="") careProvDesc=assId
		if (i>1)&(assId'="")
		{
			set result=result_","	
		}	
		set result=result_careProvDesc
	}	
	
	quit result
}

/// Creator：      	陈长青
/// CreatDate：    	2017-1-9
/// Description： 	获取手术助手名称
/// Table：        	SQLUser.CT_CareProv
/// Input:			assIdStr:手术助手ID，多个助手以","拼接
/// Return：       	手术助手名称，多个助手以","拼接
/// w ##class(CIS.AN.BL.OperationList).GetAssistantDesc("1")
ClassMethod GetCareProvDesc(assIdStr As %String) As %String [ SqlProc ]
{
	Set lang="20",sessionLang=""
	Set:($DATA(%session)) sessionLang=$GET(%session.Data("LOGON.LANGID"))
	Set:(sessionLang'="") lang=sessionLang
	set assIdCount=$length(assIdStr,","),result=""
	for i=1:1:assIdCount
	{
		set assId=$p(assIdStr,",",i)
		set careProvDesc=##class(CIS.AN.COM.String).GetDescByID("User.CTCareProv","CTPCPDesc",assId)
    	set careProvDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",careProvDesc,lang)
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
		set result = ##class(CIS.AN.COM.String).GetDescByID("User.ORCOperation","OPERDesc",operation)
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

/// Creator：      	元琳
/// CreatDate：    	2020-5-29
/// Description： 	获取手术助手名称
/// Table：        	SQLUser.OECBodySite
/// Input:			BodySite:手术部位ID，多个部位以","拼接
/// Return：       	手术部位名称，多个部位以","拼接
/// w ##class(CIS.AN.BL.OperationList).GetBodySiteDesc("1")
ClassMethod GetBodySiteDesc(BodySiteStr As %String) As %String [ SqlProc ]
{
	set BodySiteCount=$length(BodySiteStr,","),result=""
	for i=1:1:BodySiteCount
	{
		set BodySiteId=$p(BodySiteStr,",",i)
		set BodySiteDesc=##class(CIS.AN.COM.String).GetDescByID("User.OECBodySite","BODSDesc",BodySiteId)
		set:(BodySiteDesc="") BodySiteDesc=BodySiteId
		if (i>1)&(BodySiteId'="")
		{
			set result=result_","	
		}	
		set result=result_BodySiteDesc
	}	
	
	quit result
}

/// w ##class(CIS.AN.BL.OperationList).GetOperDesc("933")
ClassMethod GetOperDesc(opsId As %String, splitChar As %String = ",") As %String [ SqlProc ]
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	set sc=rs.Execute(opsId)
	set operDescStr=""
	while(rs.Next())
	{
		set operDescStr=operDescStr_$lb(rs.Get("OperationDesc"))
	}
	
	set res=$lts(operDescStr,splitChar)
	quit res
}

ClassMethod GetSurgeonDescNew(opsId As %String, splitChar As %String = ",") As %String [ SqlProc ]
{
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	set sc=rs.Execute(opsId)
	set operDescStr=""
	while(rs.Next())
	{
		set operDescStr=operDescStr_$lb(rs.Get("SurgeonDesc"))
	}
	
	set res=$lts(operDescStr,splitChar)
	quit res
}

/// zw ##class(CIS.AN.BL.OperationList).GetOperListObject("596")
ClassMethod GetOperListObject(opsId As %String) As %DynamicObject
{
	set res=##class(%DynamicObject).%New()
	set rs=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
	set sc=rs.Execute(opsId)
	set operStr="",operClassStr="",bodySiteStr="",bladeTypeStr="",surgeonStr="",assistantStr="",surgeonExpertStr=""
	set operDescStr="",operClassDescStr="",bodySiteDescStr="",bladeTypeDescStr="",operNoteStr="",surgeonDescStr="",assistantDescStr=""
	set operDescSplit="+",splitChar=","
	while(rs.Next())
	{
		set operStr=operStr_$lb(rs.Get("Operation"))
		set operDescStr=operDescStr_$lb(rs.Get("OperationDesc"))
		
		set operClassStr=operClassStr_$lb(rs.Get("OperClass"))
		set operClassDescStr=operClassDescStr_$lb(rs.Get("OperClassDesc"))
		
		set bodySiteStr=bodySiteStr_$lb(rs.Get("BodySite"))
		set bodySiteDescStr=bodySiteDescStr_$lb(rs.Get("BodySiteDesc"))
		
		set bladeTypeStr=bladeTypeStr_$lb(rs.Get("BladeType"))
		set bladeTypeDescStr=bladeTypeDescStr_$lb(rs.Get("BladeTypeDesc"))
		
		set surgeonStr=surgeonStr_$lb(rs.Get("Surgeon"))
		set surgeonDescStr=surgeonDescStr_$lb(rs.Get("SurgeonDesc"))
		
		set assistantStr=assistantStr_$lb(rs.Get("Assistant"))
		set assistantDescStr=assistantDescStr_$lb(rs.Get("AssistantDesc"))
		
		set operNoteStr=operNoteStr_$lb(rs.Get("OperNote"))
		
		set surgeonExpertStr=surgeonExpertStr_$lb(rs.Get("SurgeonExpert"))
	}
	
	set res.Operation=$lts(operStr,splitChar)
	set res.OperDesc=$lts(operDescStr,operDescSplit)
	set res.OperClass=$lts(operClassStr,splitChar)
	set res.OperClassDesc=$lts(operClassDescStr,splitChar)	
	set res.BodySite=$lts(bodySiteStr,splitChar)
	set res.BodySiteDesc=$lts(bodySiteDescStr,splitChar)
	set res.BladeType=$lts(bladeTypeStr,splitChar)
	set res.BladeTypeDesc=$lts(bladeTypeDescStr,splitChar)
	set res.Surgeon=$lts(surgeonStr,splitChar)
	set res.SurgeonDesc=$lts(surgeonDescStr,splitChar)
	set res.Assistant=$lts(assistantStr,splitChar)
	set res.AssistantDesc=$lts(assistantDescStr,splitChar)
	set res.OperNote=$lts(operNoteStr,splitChar)
	set res.SurgeonExpert=$lts(surgeonExpertStr,splitChar)
	return res
}

}
