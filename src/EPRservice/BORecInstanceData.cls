Class EPRservice.BORecInstanceData Extends %SOAP.WebService [ ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// Parameter LOCATION = "http://localhost/dthealth/web";
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "RecInstanceDataInfo";

/*
//w ##class(EPRservice.BORecInstanceData).RestoreData(AInstanceID,ASeqNo,AModifyUser)

ClassMethod RestoreData(AInstanceID As %String = "", ASeqNo As %Integer = 1, AModifyUser As %String = "") As %String [ WebMethod ]
{
	Quit ##class(EPRservice.BLRecInstanceData).RestoreData(AInstanceID,ASeqNo,AModifyUser)
}*/
ClassMethod DumpData(AInstanceID As %String = "", AChartItemType As %String = "") As EPRservice.entity.ERecInstanceData [ WebMethod ]
{
	Quit ..XMLFormation(##Class(EPRservice.BLRecInstanceData).DumpData(AInstanceID,AChartItemType))
}

ClassMethod XMLFormation(ADumpedData As EPRinstance.RecInstanceData = -1) As EPRservice.entity.ERecInstanceData
{
	Quit:(ADumpedData=-1) -1
	
	s retXML = ##class(EPRservice.entity.ERecInstanceData).%New()
	if ($$$NULLOREF=retXML)
	{
		s retXML=""
		Quit -1
	}
	s dumpedData = ""
	s dumpedData = ADumpedData
	
	s retXML.EpisodeID = dumpedData.EpisodeID
	s retXML.InstanceID = dumpedData.InstanceID
	s retXML.ModifyDate = dumpedData.ModifyDate
	s retXML.ModifyTime = dumpedData.ModifyTime
	s retXML.ModifyUser = dumpedData.ModifyUser
	s retXML.Status = dumpedData.Status
	s retXML.SeqNo = dumpedData.SeqNo
	//
	s retXML.CreateDate = dumpedData.CreateDate
	s retXML.CreateTime = dumpedData.CreateTime
	s retXML.CreateUser = dumpedData.CreateUser
	s retXML.GroupItemID = dumpedData.GroupItemID
	s retXML.GroupItemName = dumpedData.GroupItemName
	s retXML.HappenDate = dumpedData.HappenDate
	s retXML.HappenTime = dumpedData.HappenTime
 	s retXML.ListNo = dumpedData.ListNo
 	s retXML.Remark = dumpedData.Remark
	s retXML.Title = dumpedData.Title
	s retXML.TemplateID = dumpedData.TemplateID
	s retXML.TemplateVersion = dumpedData.TemplateVersion
	d retXML.InstanceData.CopyFrom(dumpedData.InstanceData)
	
	Quit retXML
}

}
