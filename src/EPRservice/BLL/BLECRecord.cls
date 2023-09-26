Class EPRservice.BLL.BLECRecord Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	取ECRecordID
ClassMethod GetECRecordID(AEpisodeID As %String, AChartItemID As %String) As %String
{
	q:(AECRecordID="")||(AChartItemID="") ""
	
	s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_AChartItemID,""))
	q ecRecordID
}

/// Desc:	取InstanceDataID
ClassMethod GetInstanceIDByECRecord(AECRecordID As %String, AEPRNum As %String) As %String
{
	q:(AECRecordID="")||(AEPRNum="") ""
	
	s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",AECRecordID," "_AEPRNum,""))
	q:(childSub = "") ""
	q AECRecordID_"||"_childSub
}

/// Desc:	取InstanceDataID
/// Debug:	W ##Class(EPRservice.BLL.BLECRecord).GetInstanceID("201764","ML104","1")
ClassMethod GetInstanceID(AEpisodeID As %String, AChartItemID As %String, AEPRNum As %String) As %String
{
	q:(AEpisodeID="")||(AChartItemID="")||(AEPRNum="") ""
	
	s ecRecordID = $O(^DHCEPRI.ECRecordI("IdxEpisodeIDChartItemID"," "_AEpisodeID," "_AChartItemID,""))
	q:(ecRecordID = "") ""
	
	s childSub = $O(^DHCEPRI.InstanceDataI("IdxEcRecordAndListNo",ecRecordID," "_AEPRNum,""))
	q:(childSub = "") ""
	
	q ecRecordID_"||"_childSub
}

}
