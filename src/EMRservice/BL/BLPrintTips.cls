///  名称：		EMRservice.BL.BLPrintTips
///  描述：		批量打印BL层(标注医生点击首次点击打印提示“请确认已打印心电图、CT报告单、会诊记录单”(辽宁沈阳胸科医院)
///  编写者：	yejian
///  编写时间：	2022-1-4
Class EMRservice.BL.BLPrintTips Extends (%RegisteredObject, %XML.Adaptor)
{

///  Creator:    yejian
///  CreateDate: 2021-12-31
///  Desc:       判断是否提示"请确认已打印心电图、CT报告单、会诊记录单",辽宁沈阳胸科医院，需要调用第三方接口
///  Input:      AEpisodeID:就诊号
/// 				 AUserID:用户ID
///  return:     result 1：返回提示信息  0：不提示
///  debug:	w ##class(EMRservice.BL.BLPrintTips).GetPrintTipsState(67,10209)
ClassMethod GetPrintTipsState(AEpisodeID As %String, AUserID As %String) As %String
{
	s strRes = "0"
	q:((AEpisodeID = "")||(AUserID="")) "-1"
	s curDate = $p($h,",",1)
	s strDate = $o(^DHCEMRI.PrintTipsI("IdxTipsData"," "_AUserID," "_AEpisodeID,""))
	s strDate = $tr(strDate," ")
	//没有记录，则插入一条记录
	if (strDate="")
	{
		s obj = ##class(EMRinstance.PrintTips).%New()
		s obj.UserID = AUserID
		s obj.EpisodeID = AEpisodeID
		s obj.TipsDate = curDate
		s sc = obj.%Save()
		s:(sc) strRes = "1"
		s:('sc) strRes = "-1"
	}
	elseif(strDate'=curDate) //有记录，但不是当天，则修改时间为当天
	{
		s strRowID = $o(^DHCEMRI.PrintTipsI("IdxTipsData"," "_AUserID," "_AEpisodeID," "_strDate,""))
		q:(strRowID="") "-1"
		s obj = ##class(EMRinstance.PrintTips).%OpenId(strRowID)
		s obj.TipsDate = curDate
		s sc = obj.%Save()
		s:(sc) strRes = "1"
		s:('sc) strRes = "-1"
	}
	q strRes
}

}
