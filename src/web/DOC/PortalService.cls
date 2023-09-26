/// Desc：提供给Portal的服务
/// Creator：郭荣勇
/// Date：2015-10-16
Class web.DOC.PortalService Extends (%RegisteredObject, %XML.Adaptor)
{

/// 在新增或删除过敏记录的业务中触发
/// ##class(web.DHCENS.EnsHISService).DHCHisInterface（'S00000013'，过敏记录ID，状态，就诊号）
/// 状态： 1：新增 2：删除
/// 返回值 ： 0^成功，  -1^失败
ClassMethod DHCHisInterface(code As %String, allergyId As %String, status As %String, episodeId As %String) As %String
{
	Q ##class(web.DHCENS.EnsHISService).DHCHisInterface(code,allergyId,status,episodeId)
}

/// shadow增加任务定时查询所有待审核医嘱(实习医生需审核医嘱)并在查询方法内调用下列方法发送给平台组
/// ##class(web.DHCENS.EnsHISService).DHCHisInterface（'S00000028'，医嘱ID，状态,就诊号）
/// 状态：1:实习医生申请医嘱审核，2:医生确定通过,3:医生不通过
/// 返回值 ： 0^成功，  -1^失败
/// d ##class(web.DOC.PortalService).TaskNeedAuditOEItem("S00000028","1||1",1,2)
ClassMethod TaskNeedAuditOEItem(code As %String, OrderStr As %String, status As %String, episodeId As %String)
{
	s Rtn=0
	Q:OrderStr="" Rtn
	s Rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface(code,OrderStr,status,episodeId)
	Q Rtn
	/*set ShowPaidOrder=##class(web.DHCDocConfig).GetConfigNode("ShowPaidOrder")
	set NoDisplayItemCat=##class(web.DHCDocConfig).GetConfigNode("NoDisplayItemCat")
	s OEORIItemStatDR=$o(^OEC("OSTAT",0,"Code","I",""))
	s OEORISttDat=+$h
	s OEORDRowId=0
	f  s OEORDRowId=$o(^OEORDi(0,"StDtStat",OEORISttDat,OEORIItemStatDR,OEORDRowId)) q:OEORDRowId=""  d
	.s EpisodeID=$p(^OEORD(OEORDRowId),"^",1)
	.q:EpisodeID=""
	.s PAADMType=$p($g(^PAADM(EpisodeID)),"^",2)
	.s OEORIChildsub=0
	.f  s OEORIChildsub=$o(^OEORDi(0,"StDtStat",OEORISttDat,OEORIItemStatDR,OEORDRowId,OEORIChildsub)) q:OEORIChildsub=""  d
	..s billed=$p($g(^OEORD(+OEORDRowId,"I",OEORIChildsub,3)),"^",5)
	..q:(billed="P")&(ShowPaidOrder'="1")
	..s ARCIMRowid=$p($g(^OEORD(+OEORDRowId,"I",OEORIChildsub,1)),"^",2)
	..q:ARCIMRowid=""
	..s subcat=$p($g(^ARCIM(+ARCIMRowid,1,1)),"^",10)
	..q:(NoDisplayItemCat'="")&(subcat'="")&(("^"_NoDisplayItemCat_"^")[("^"_subcat_"^"))
	..s FillerNo=$p($g(^OEORD(+OEORDRowId,"I",OEORIChildsub,9)),"^",12)
	..;住院非新开长嘱不显示
	..q:(PAADMType="I")&(FillerNo'="")
	..;w OEORDRowId_"||"_OEORIChildsub,!
	..d ##class(web.DHCENS.EnsHISService).DHCHisInterface("S00000028",OEORDRowId_"||"_OEORIChildsub,EpisodeID)
	q 0*/
}

}
