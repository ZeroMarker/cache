/// 临床组对外手麻5.x版本接口
Class DHCCL.Implement.ANNew.OperScheduleService Extends (%RegisteredObject, DHCCL.Interface.AN.IOperInfoService)
{

/// 获取手术信息
Method GetOperInfoByEpisodeID(EpisodeID As %String) As %GlobalCharacterStream
{
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    
    do retStream.Write("<Response>")
	set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(EpisodeID)
	set operIdCount=$l(operIdList,",")
	for i=1:1:operIdCount
	{
		set opsId=$p(operIdList,",",i)
		continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
		do Output(opsId)
	}
	do retStream.Write("</Response>")
	quit retStream
	
Output(opsId)
	set rset=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	do rset.Execute("","","",opsId)
	while (rset.Next()) 
	{
		set operInfoObj=##class(DHCCL.DTO.AN.OperInfo).%New()
		set query=##class(%ResultSet).%New("CIS.AN.COM.DataService:FindProperties")
        set sc=query.Execute("DHCCL.DTO.AN.OperInfo")
        while(query.%Next())
        {
            set propertyName=query.Get("Name")
            if (propertyName'="OperationDetail")
            {
	            set $property(operInfoObj,propertyName)=rset.Get(propertyName)
	        }
	        else
	        {
		        set operListSet=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
				do operListSet.Execute(opsId)
				while (operListSet.Next()) 
				{
					set operListObj=##class(DHCCL.DTO.AN.OperationList).%New()
					set operListObj.RowId=operListSet.Get("RowId")
					set operListObj.OperSchedule=operListSet.Get("OperSchedule")
					set operListObj.Operation=operListSet.Get("Operation")
					set operListObj.OperationDesc=operListSet.Get("OperationDesc")
					set operListObj.OperClass=operListSet.Get("OperClass")
					set operListObj.OperClassDesc=operListSet.Get("OperClassDesc")
					set operListObj.BladeType=operListSet.Get("BladeType")
					set operListObj.BladeTypeDesc=operListSet.Get("BladeTypeDesc")
					set operListObj.BodySite=operListSet.Get("BodySite")
					set operListObj.BodySiteDesc=operListSet.Get("BodySiteDesc")
					set operListObj.OperPos=operListSet.Get("OperPos")
					set operListObj.OperPosDesc=operListSet.Get("OperPosDesc")
					set operListObj.Surgeon=operListSet.Get("Surgeon")
					set operListObj.SurgeonDesc=operListSet.Get("SurgeonDesc")
					set operListObj.SurCareProvDesc=operListSet.Get("SurCareProvDesc")
					set operListObj.SurgeonShortDesc=operListSet.Get("SurgeonShortDesc")
					set operListObj.SurgeonExpert=operListSet.Get("SurgeonExpert")
					set operListObj.Assistant=operListSet.Get("Assistant")
					set operListObj.AssistantDesc=operListSet.Get("AssistantDesc")
					set operListObj.SurgeonDeptID=operListSet.Get("SurgeonDeptID")
					set operListObj.SurgeonDeptDesc=operListSet.Get("SurgeonDeptDesc")
					set operListObj.AddtionalStaff=operListSet.Get("AddtionalStaff")
					set operListObj.OperNote=operListSet.Get("OperNote")
					set operListObj.OperInfo=operListSet.Get("OperInfo")
					
					do operInfoObj.OperationDetail.Insert(operListObj)
				}
		    }
        }
        set xml=##class(%GlobalCharacterStream).%New()
		set ret=operInfoObj.XMLExportToStream(.xml,"OperInfo")
		do retStream.CopyFrom(xml)
	}
	quit
}

/// 查询麻醉数据,itemCategory:数据分类, V-生命体征, E-时间, D-药品
Query FindAnaData(opsId, itemCategory) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
	SELECT ParaItem->RecordSheet->OperSchedule as OpsId,
	DataItem as DataItemId, 
	DataItem->Description as Name, 
	%ODBCOUT(StartDate)_" "_%ODBCOUT(StartTime) As StartDT,
	DataItem->itemCategory as Type
	FROM CIS_AN.ANAData 
	WHERE ParaItem->RecordSheet->OperSchedule=:opsId and EditFlag='N' and DataItem->itemCategory=:itemCategory
}

/// 获取麻醉质控指标信息
Method GetAnaQualityControl(startDate As %String, endDate As %String, anaDeptId As %String, userId As %String, Version As %String = "") As %GlobalCharacterStream
{
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    
    do retStream.Write("<Response>")
	set rset=##class(%ResultSet).%New("CIS.AN.BL.AnaestQualityControlStatistic:FindAnaQualityControlStat")
	do rset.Execute(startDate,endDate,anaDeptId,userId,Version)
	while (rset.Next()) 
	{
		set anaQualityControlObj=##class(DHCCL.DTO.AN.AnaQualityControl).%New()
		set query=##class(%ResultSet).%New("CIS.AN.COM.DataService:FindProperties")
        set sc=query.Execute("DHCCL.DTO.AN.AnaQualityControl")
        while(query.%Next())
        {
            set propertyName=query.Get("Name")
	        set $property(anaQualityControlObj,propertyName)=rset.Get(propertyName)
        }
		
		set xml=##class(%GlobalCharacterStream).%New()
		set ret=anaQualityControlObj.XMLExportToStream(.xml,"AnaQualityControl")
		do retStream.CopyFrom(xml)
	}
	do retStream.Write("</Response>")
	quit retStream
}

/// 获取麻醉质控指标病人详细信息
Method GetAnaQualityControlDetail(OperScheduleID As %String = "", EpisodeID As %String = "", DischargeDate As %String = "") As %GlobalCharacterStream
{
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    
    do retStream.Write("<Response>")
	set rset=##class(%ResultSet).%New("CIS.AN.SRV.ForBIService:FindAnaQualityControlDetail")
	do rset.Execute(OperScheduleID,EpisodeID,DischargeDate)
	while (rset.Next()) 
	{
		set anaQualityControlDetailObj=##class(DHCCL.DTO.AN.AnaQualityControlDetail).%New()
		set query=##class(%ResultSet).%New("CIS.AN.COM.DataService:FindProperties")
        set sc=query.Execute("DHCCL.DTO.AN.AnaQualityControlDetail")
        while(query.%Next())
        {
            set propertyName=query.Get("Name")
	        set $property(anaQualityControlDetailObj,propertyName)=rset.Get(propertyName)
        }
		
		set xml=##class(%GlobalCharacterStream).%New()
		set ret=anaQualityControlDetailObj.XMLExportToStream(.xml,"AnaQualityControlDetail")
		do retStream.CopyFrom(xml)
	}
	do retStream.Write("</Response>")
	quit retStream
}

Method GetAnaQualityControlJson(OperScheduleID As %String = "", EpisodeID As %String = "", DischargeDate As %String = "") As %String
{
	set jsonStr=##class(CIS.AN.COM.String).QueryToJSON("CIS.AN.SRV.ForBIService","FindAnaQualityControl",OperScheduleID,EpisodeID,DischargeDate)
	set tag="data"
	set ret="{"""_tag_""":"_jsonStr_"}"
	
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    do retStream.Write(ret)
	quit retStream
}

Method GetAnaOperThemeInfoJson(OperScheduleID As %String = "", EpisodeID As %String = "", OperDate As %String = "") As %String
{
	set jsonStr=##class(CIS.AN.COM.String).QueryToJSON("CIS.AN.SRV.ForBIService","FindOperThemeInfo",OperScheduleID,EpisodeID,OperDate)
	set tag="data"
	set ret="{"""_tag_""":"_jsonStr_"}"
	
	set retStream=##class(%GlobalCharacterStream).%New()
    do retStream.Rewind()
    do retStream.Write(ret)
	quit retStream
}

}
