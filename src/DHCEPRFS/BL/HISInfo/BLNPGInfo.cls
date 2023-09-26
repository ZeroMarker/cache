Class DHCEPRFS.BL.HISInfo.BLNPGInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: update 2023-2-10 yangshun
/// Desc:	是否有会诊单需要打印
/// Debug:	w ##Class(DHCEPRFS.BL.HISInfo.BLNPGInfo).HasConsultToPrintNew("5366809")
ClassMethod HasConsultToPrintNew(AEpisodeID) As %String
{
	q:(AEpisodeID="") ""
	s ret = 0
	//s ret = ..GetCsComFlag(AEpisodeID)
	
	s ret = ##Class(web.DHCEMConsInterface).GetCsComFlag(AEpisodeID)
  	q ret
}

/// Creator:     congyue
/// CreateDate:  2019-03-18
/// Descript:    本次就诊是否有已完成的会诊
/// InPut:       EpisodeID - 就诊ID
/// OutPut:      1-有 ,0-其他
/// w ##Class(web.DHCEMConsInterface).GetCsComFlag("")
/// w ##Class(DHCEPRFS.BL.HISInfo.BLNPGInfo).GetCsComFlag("5366809")
ClassMethod GetCsComFlag(EpisodeID As %String) As %String
{
	q:(EpisodeID="") ""
	s CstID="",CstFlag=0
	F  s CstID=$o(^DHCEMCON(0,"ADM",EpisodeID,CstID)) Q:CstID=""  D
	.s ID=$p(^DHCEMCON(CstID),"^",18)   /// 会诊状态
	.s stCode=$p($g(^DHCEMCONS(+ID)),"^",1)
	.Q:stCode<50 /// 未完成
	.Q:(stCode=51) /// 取消完成
	.S:(stCode=50)||(stCode=55)||(stCode=60)||(stCode=70) CstFlag=1   ///完成||会诊评价||确认||评价
	Q CstFlag
}

}
