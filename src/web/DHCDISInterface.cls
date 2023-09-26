Import SQLUser

/// Creator: 	 sufan
/// CreateDate:  2020-05-07
/// Descript:    陪送申请接口类
Class web.DHCDISInterface Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Not ProcedureBlock ]
{

/// Creator: 	 sufan
/// CreateDate:  2020-05-07
/// Descript:    去病案号，兼容新老方法
/// Input:		 EpisodeId：就诊ID
/// Output:		 病案号
/// w ##class(web.DHCDISInterface).GetMrNoByEpisodeID(16)
ClassMethod GetMrNoByEpisodeID(EpisodeId)
{
	n (EpisodeId)
	Q:EpisodeId="" ""
	s PatientID=$p(^PAADM(EpisodeId),"^",1)
	s MedType=$p(^PAADM(EpisodeId),"^",2)
	s ErrMsg=""
	s MrNo=""
	s Ret=0
	s Ret=##class(websys.Conversions).IsValidMethodName("DHCWMR.IO.OutService","IGetMrNoByEpisodeID")
	i Ret=1 d
	.s MrNo=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeId,MedType,.ErrMsg)
	e  d
	.s:PatientID'="" MrNo=$p(^PAPER(PatientID,"PAT",1),"^",22)  	
	Q MrNo
}

}
