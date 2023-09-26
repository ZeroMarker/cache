Class EMRservice.InterfaceService.InterfaceToDHCWL Extends %RegisteredObject
{

/// desc:提供接口判定患者完成的病案首页为中医病案首页或为西医病案首页。
/// createor:lfb
/// date:202220311
/// Input:EpisodeID 就诊号
/// retrun:1,中医首页 2,西医首页 0,未完成首页
/// w ##class(EMRservice.InterfaceService.InterfaceToDHCWL).GetFirstPageType()
ClassMethod GetFirstPageType(AEpisodeID As %String) As %String
{
	s ret=0
	
	
	//中医首页DocID
	s CnFPDocIDs = "302^639"
	//病案首页DocID
	s FPDocIDs =  "52^640"
	
	for i=1:1:$l(CnFPDocIDs,"^")
	{
		s cnFPDocId=$p(CnFPDocIDs,"^",i)
		s hasInstance = ..GetInstance(AEpisodeID,cnFPDocId)
		s:(hasInstance=1) ret=1
		q:(ret'=0)
	}
	
	for i=1:1:$l(FPDocIDs,"^")
	{
		s FPDocId=$p(FPDocIDs,"^",i)
		s hasInstance = ..GetInstance(AEpisodeID,FPDocId)
		s:(hasInstance=1) ret=2
		q:(ret'=0)
	}
	q ret
}

/// w ##class(EMRservice.InterfaceService.InterfaceToDHCWL).GetInstance(143,640)
ClassMethod GetInstance(AEpisodeID As %String, ADocID As %String) As %String
{
	s ret=0
	s hasData = $d(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ADocID))
	q:(hasData=0) ret
	
	s ecrecordId = $o(^DHCEMRI.ECRecordI("IdxEpisodeIDChartItemID",AEpisodeID,ADocID,""))
	s objECRecord = ##class(EMRinstance.ECRecord).%OpenId(ecrecordId)
	q:(objECRecord="") ret
	
	s Instances = objECRecord.Instances
	Set key = ""
	do
	{ 
    	S objInstanceData = Instances.GetNext(.key)
	    if (objInstanceData '= "")
     	{ 
     		continue:(objInstanceData.Status'="Save")
     		s ret=1
     		q
	  	} 
	} 
	while (key '="" )
	q ret
}

}
