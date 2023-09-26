Class DHCEPRFS.BL.HISInfo.BLDocInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc:	是否有住院证需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLDocInfo).HasIPBookToPrint("8922671")
ClassMethod HasIPBookToPrint(AEpisodeID As %String) As %String
{
	q:AEpisodeID="" 0 
	s rtn = "0"
	s hospitalFlag = ##class(DHCEPRFS.BL.BLSysOption).GetValueByName("HospitalFlag")
	if (hospitalFlag = "LYEY")
	{
		set ipBookID = $o(^DHCDocIPBK(0, "EpisodeIDTo", AEpisodeID, ""),-1)
		q:(ipBookID="") "0"
		s rtn = "1"
	}
	else
	{   
		s ipbook=""
		s ipbook=$o(^DHCDocIPBK(0,"EpisodeIDTo",AEpisodeID,""))
		i ipbook'="" s rtn="1"
		e  s rtn="0"
	}
	q rtn
}

/// Desc:	通过住院就诊号获取门诊就诊号
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLDocInfo).GetInAdmByOutAdm("9686831")
ClassMethod GetInAdmByOutAdm(OutAdm As %String) As %String
{
	q:OutAdm="" 0
	s EpisodeIDFrom=0
	s rowid=0
	f  s rowid=$o(^DHCDocIPBK(0,"EpisodeIDTo",OutAdm,rowid)) q:rowid=""  d
	.s EpisodeIDFrom=$p(^DHCDocIPBK(rowid),"^",2)
	.q:EpisodeIDFrom=""
	q EpisodeIDFrom
}

}
