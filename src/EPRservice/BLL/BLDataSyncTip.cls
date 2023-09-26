Class EPRservice.BLL.BLDataSyncTip Extends %RegisteredObject
{

/// w ##Class(EPRservice.BLL.BLDataSyncTip).NeedStopDataSync("105","11","148kS2sk00")
ClassMethod NeedStopDataSync(AUserID, AEpisodeID, ASessionID) As %String
{
	s id = $O(^DHCEPRI.DataSyncTipUserI("IdxUserID"," "_AUserID,""))
	q:(id = "") "0"
	
	s obj = ##class(EPRinstance.DataSyncTipUser).%OpenId(id)
	q:(obj="") "0"
	q:(obj.LogonSession = ASessionID) "1"
	
	q "0"
}

}
