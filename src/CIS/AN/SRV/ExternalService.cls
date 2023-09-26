Class CIS.AN.SRV.ExternalService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "AnInterface";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://127.0.0.1/iMedical/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://tempuri.org";

/// Creator：      	邓体进
/// CreatDate：    	2020-07-22
/// Description： 	根据id和类型获取手术麻醉信息
/// Table：        	CIS_AN.OperSchedule等
/// Input:			id  : 手术安排Id、就诊号或登记号
///                 type: id类型: OpsId:手术安排Id, EpisodeId：手术安排Id，RegNo：手术安排Id
/// Return：       	手术麻醉信息对象列表
/// w ##class(CIS.AN.SRV.ExternalService).GetOperInfo("29","EpisodeId").Read()
ClassMethod GetOperInfo(id, type) As %GlobalCharacterStream [ WebMethod ]
{
	// ##class(web.DHCANOPInterface).GetPatInfo(date,roomCode,ipNo)
    set retStr=##class(%GlobalCharacterStream).%New()
    do retStr.Rewind()
    do retStr.Write("<Result>")
	if (type="OpsId")
	{
		do Output(id)
	}
	elseif (type="EpisodeId")
	{
		set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(id)    //手术申请ID
		set operIdCount=$l(operIdList,",")
		for k=1:1:operIdCount
		{
			set opsId=$p(operIdList,",",k)
			continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
			do Output(opsId)
		}	
	}
	elseif (type="RegNo")
	{
		set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByRegNo(id)
		set operIdCount=$l(operIdList,",")
		for k=1:1:operIdCount
		{
			set opsId=$p(operIdList,",",k)
			continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
			do Output(opsId)	
		}
	}
	elseif (type="date")
	{
		set date=+##class(CIS.AN.COM.DateTime).ConvertToDateH(id,"")
		set opsId=""
		for
		{
			set opsId=$order(^CIS.AN.OperScheduleI("OPDate",date,opsId))
			quit:(opsId="")
			continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
			do Output(opsId)	
		}
	}
	d retStr.Write("</Result>")
	q retStr
	

Output(opsId)
	s rset=##class(%ResultSet).%New("CIS.AN.BL.OperScheduleList:FindOperScheduleList")
	s ret=""
	set params={}
	set params.opsId=opsId
	do rset.Execute("","","",opsId)
	s count=rset.GetColumnCount()
	while (rset.Next()) 
	{
		do retStr.Write("<OperInfo>")
		for i=1:1:count  
		{
			s name=rset.GetColumnName(i)
			s value=rset.Get(name)
			s tagStr="<"_name_">"
			d retStr.Write("<"_name_">"_value_"</"_name_">")
		}
		
		do retStr.Write("<AnData>")
		do ##class(CIS.AN.COM.Query).ToXml("CIS.AN.SRV.ExternalService:FindAnData",.retStr,opsId)
		do retStr.Write("</AnData>")
		
		do retStr.Write("<OperationList>")
		do ##class(CIS.AN.SRV.ExternalService).GetOperListInfoToXML(opsId, .retStr)
		do retStr.Write("</OperationList>")
		
		do retStr.Write("</OperInfo>")
	}

	q retStr
}

ClassMethod GetOperListInfoToXML(opsId As %String, ByRef stream As %GlobalCharacterStream = "")
{
	set query=##class(%ResultSet).%New("CIS.AN.BL.OperationList:FindOperationList")
    set sc=query.Execute(opsId)
    set colCount=query.GetColumnCount()
    set tag="Row"
    while (query.Next()) 
    {
		do stream.Write("<Row>")
		for i=1:1:colCount
		{
			set name=query.GetColumnName(i)
			set value=query.Get(name)
			if (name="OperInfo") set name="OperDescDetail"
			do stream.Write("<"_name_">"_value_"</"_name_">")
		}
		d stream.Write("</Row>")
	}
}

/// Creator：      	邓体进
/// CreatDate：    	2020-07-28
/// Description： 	根据id和类型获取手术麻醉信息
/// Table：        	CIS_AN.OperSchedule等
/// Input:			id  : 手术安排Id、就诊号或登记号
///                 type: id类型: OpsId:手术安排Id, EpisodeId：手术安排Id，RegNo：手术安排Id
/// Return：       	手术麻醉信息对象列表
/// w ##class(CIS.AN.SRV.ExternalService).GetANData("24","OpsId")
ClassMethod GetANData(id, type) As %GlobalCharacterStream [ WebMethod ]
{
	set retStr=##class(%GlobalCharacterStream).%New()
    do retStr.Rewind()
    do retStr.Write("<Result>")
	if (type="OpsId")
	{
		do Output(id)
	}
	elseif (type="EpisodeId")
	{
		set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByAdm(id)
		set operIdCount=$l(operIdList,",")
		for i=1:1:operIdCount
		{
			set opsId=$p(operIdList,",",i)
			continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
			do Output(id)
		}	
	}
	elseif (type="RegNo")
	{
		set operIdList=##class(CIS.AN.BL.OperScheduleList).GetOpsIdListByRegNo(id)
		set operIdCount=$l(operIdList,",")
		for i=1:1:operIdCount
		{
			set opsId=$p(operIdList,",",i)
			continue:(##class(CIS.AN.OperSchedule).%ExistsId(opsId)=0)
			do Output(id)	
		}
	}
	d retStr.Write("</Result>")
	q retStr
	

Output(id)
	do retStr.Write("<AnData>")
	do ##class(CIS.AN.COM.Query).ToXml("CIS.AN.SRV.ExternalService:FindAnData",.retStr,id)
	do retStr.Write("</AnData>")
		
	q retStr
}

Query FindAnData(opsId) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT a.ParaItem->RecordSheet->OperSchedule as OpsId, 
	a.DataItem->Code as Code, 
	a.DataItem->Description as Name, 
	%ODBCOUT(a.StartDate) As StartDate,
	%ODBCOUT(a.StartTime) As StartTime,
	%ODBCOUT(a.EndDate) As EndDate,
	%ODBCOUT(a.EndTime) As EndTime,
	a.DataItem->itemCategory as Type,
	b.DoseQty As DoseQty,
	b.DoseUnit->Description As DoseUnit,
	b.Speed As Speed,
	b.SpeedUnit As SpeedUnit
	FROM CIS_AN.ANAData a
	left join CIS_AN.DrugData b
	on a.RowId=b.AnaData
	WHERE a.ParaItem->RecordSheet->OperSchedule=:opsId and a.EditFlag='N' and a.DataItem->itemCategory IN ('D','E')
}

}
