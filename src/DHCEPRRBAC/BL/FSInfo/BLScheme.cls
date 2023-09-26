Class DHCEPRRBAC.BL.FSInfo.BLScheme Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod GetVerItemByVersionItemsString(AEpisodeID As %String, AItemsString As %String) As %String
{
	s mrEpisodeID = ##class(DHCEPRFS.BL.BLMREpisode).GetMREpisodeIDByAdm(AEpisodeID,"DHC")
	q:(mrEpisodeID = "") "-1"
	s ret = ##Class(DHCEPRFS.BL.BLPrintScheme).GetVerItemByVersionItemsString(mrEpisodeID,AItemsString)
	q mrEpisodeID_"!"_ret
}

}
