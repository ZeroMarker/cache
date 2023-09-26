Class DHCEPRFS.BI.BIToAN Extends %RegisteredObject [ ProcedureBlock ]
{

/// Desc:	加入PDF生成队列接口, 手麻记录
/// Intput：AEpisodeID 	：就诊rowid
/// Return：ID - 队列ID, 空 - 加入队列失败
/// Debug:	w ##Class(DHCEPRFS.BI.BIToAN).DHCANToPDF("1")
ClassMethod DHCANToPDF(AEpisodeID As %String) As %String
{
	s schemeType = ##Class(DHCEPRFS.Const.SchemeType).CreateAN()
	s ret = ##Class(DHCEPRFS.BL.BLAdmTaskQueue).Create("DHC",AEpisodeID,"50",schemeType,"N","")
	q ret
}

}
