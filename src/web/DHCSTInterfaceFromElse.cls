Import SQLUser

/// Descript：	其他产品提供的接口函数
/// CreateDate：2016-02-25 泰安
Class web.DHCSTInterfaceFromElse Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// CreateDate:	2016-02-25
/// Desc:		获取患者结算模式
/// Output: 	0:普通收费模式；1：押金收费模式
/// w ##class(web.DHCSTInterfaceFromElse).IStayPayModeByEpisodeID
ClassMethod IStayPayModeByEpisodeID(hospId As %String = "")
{
 q ##class(PHA.FACE.IN.Com).IStayPayModeByEpisodeID(hospId)

 //s chargeMode=##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
 //q chargeMode
}

/// creator:yunhaibao
/// createdate:20160304
/// description:根据病人id获取病历号(住院)
/// modify:		公用,统一调用GetMrNoByEpisodeID,yunhaibao,2020-04-26
ClassMethod IGetMrNoByPatientID(papmi)
{
	q ""
}

/// creator:yunhaibao
/// createdate:20160308
/// description:根据就诊id获取病历号统一接口(通用)
/// w ##class(web.DHCSTInterfaceFromElse).GetMrNoByEpisodeID(adm,admType)
ClassMethod GetMrNoByEpisodeID(EpisodeID As %String, AdmType As %String = "") As %String
{
	s ret=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(EpisodeID,AdmType,.ErrMsg)
	q ret
}

/// creator:	zhouyg
/// createdate:	20160310
/// description:根据就诊id取病人当前出院状态
ClassMethod GetCurrentDischargeStatus(EpisodeID As %String) As %String
{
	s admstatus=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(EpisodeID)
	q admstatus
}

/// creator:	yunhaibao
/// createdate:	20160324
/// description:根据就诊id获取入院前用药信息(调用电子病历接口)
/// input:就诊id,数据集代码
/// 病人入院前用药说明(数据集代码DHCST.01)
ClassMethod GetNewStdDataByGlossaryCategory(EpisodeId) As %String
{
	s obj=##Class(EMRservice.BIEMRService).GetDataByGlossary(EpisodeId,"DHCST.01.001")
	s ret=obj.GetNext()
	q ret
	//s obj=##Class(EMRservice.BL.BLScatterData).GetNewStdDataByGlossaryCategory(EpisodeId,"DHCST.01") // 20190417,原来给的接口
	//s ret=obj.GetAt("DHCST.01.001")
	//q ret
	//下方为旧版本病历取法20160324yunhaibao
	s:ret="" ret=##class(EPRservice.BOScatterData).GetEPRData(EpisodeId,"入院前药物使用情况.G0003^#TYPE:Segment#TID:168#TVER:0#GCODE:G0003")
	s:ret="" ret=##class(EPRservice.BOScatterData).GetEPRData(EpisodeId,"入院前用药清单.G0019^#TYPE:Segment#TID:188#TVER:0#GCODE:G0019")
	s:ret="" ret=##class(EPRservice.BOScatterData).GetEPRData(EpisodeId,"入院前使用药物情况.G0320^#TYPE:Segment#TID:182#TVER:0#GCODE:G0320")
	s:ret="" ret=##class(EPRservice.BOScatterData).GetEPRData(EpisodeId,"入院前使用药物情况.G0389^#TYPE:Segment#TID:186#TVER:0#GCODE:G0389")
	s:ret="" ret=##class(EPRservice.BOScatterData).GetEPRData(EpisodeId,"入院前药物使用情况.G0221^#TYPE:Segment#TID:211#TVER:0#GCODE:G0221")
	s:ret="" ret=##class(EPRservice.BOScatterData).GetEPRData(EpisodeId,"入院前用药清单.G0003^#TYPE:Segment#TID:202#TVER:0#GCODE:G0003")
	s:ret="" ret=##class(EPRservice.BOScatterData).GetEPRData(EpisodeId,"入院前用药清单.G0049^#TYPE:Segment#TID:209#TVER:0#GCODE:G0049")
	q ret
}

/// creator:	yunhaibao
/// createdate:	20170103
/// provider:	计费组
/// description:判断医嘱是否已做退费审核接口
/// return:		"Y":已审核, "N":未审核
/// w ##class(web.DHCSTInterfaceFromElse).ICheckOrderIsRefundAudit()
ClassMethod ICheckOrderIsRefundAudit(ordItmRowID As %String) As %String
{
	s refundRet="" //##class(web.DHCBillInterface).ICheckOrderIsRefundAudit(ordItmRowID)
	q refundRet
}

/// creator:	yunhaibao
/// createdate:	20170227
/// provider:	基础平台组
/// description:返回系统配置的日期格式
ClassMethod DateFormat() As %String
{
	
	q ##class(websys.Conversions).DateFormat()
}

/// creator:	yunhaibao
/// createdate:	20170227
/// provider:	基础平台组
/// description:日期转数字
/// w ##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical("2016-02-28")
ClassMethod DateHtmlToLogical(datehtml) As %String
{
	q:(datehtml = "") ""
	q:$d(%DHCSTInterfaceFromElse("DateHtmlToLogical", datehtml), ret) ret
	s ret = ##class(websys.Conversions).DateHtmlToLogical(datehtml)
	s %DHCSTInterfaceFromElse("DateHtmlToLogical", datehtml) = ret
	q ret
}

/// creator:	yunhaibao
/// createdate:	20170227
/// provider:	基础平台组
/// description:数字转日期
/// w ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml("64341")
ClassMethod DateLogicalToHtml(datelogical, type = "") As %String
{
	q:(datelogical = "") ""
	q:$d(%DHCSTInterfaceFromElse("DateLogicalToHtml", datelogical), ret) ret
	s ret = ##class(websys.Conversions).DateLogicalToHtml(datelogical)
	s %DHCSTInterfaceFromElse("DateLogicalToHtml", datelogical) = ret
	q ret
}

/// creator:	yunhaibao
/// createdate:	20170227
/// provider:	基础平台组
/// description:时间转数字
/// w ##class(web.DHCSTInterfaceFromElse).TimeHtmlToLogical("00:01")
ClassMethod TimeHtmlToLogical(timehtml) As %String
{
	q:(timehtml = "") ""
	q:$d(%DHCSTInterfaceFromElse("TimeHtmlToLogical", timehtml), ret) ret
	s ret = ##class(websys.Conversions).TimeHtmlToLogical(timehtml)
	s %DHCSTInterfaceFromElse("TimeHtmlToLogical", timehtml) = ret
	q ret
}

/// creator:	yunhaibao
/// createdate:	20170227
/// provider:	基础平台组
/// description:数字转时间,type:预留字段
/// w ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml("1")
ClassMethod TimeLogicalToHtml(timelogical, type = "") As %String
{
	q:(timelogical = "") ""
	q:$d(%DHCSTInterfaceFromElse("TimeLogicalToHtml", timelogical), ret) ret
	s ret = ##class(websys.Conversions).TimeLogicalToHtml(timelogical)
	s %DHCSTInterfaceFromElse("TimeLogicalToHtml", timelogical) = ret
	q ret
}

/// creator:	yunhaibao
/// createdate:	20170327
/// provider:	基础平台组
/// description:处理消息管理中的消息,发送消息
/// w ##class(web.DHCSTInterfaceFromElse).SendPharmacyMsg("1")
ClassMethod SendPharmacyMsg(Context, Para, OtherData) As %String
{
	s ActionCode=$p(Para,"^",1)
	s FrmUser=$p(Para,"^",2)
	s EpisodeId=$p(Para,"^",3)
	s OrdItm=$p(Para,"^",4)
	s ToUser=$p(Para,"^",5)
	
	s ret=##class(websys.DHCMessageInterface).Send(Context,ActionCode,FrmUser,EpisodeId,OrdItm,ToUser,OtherData)
	q ret
}

/// creator:	yunhaibao
/// createdate:	20170327
/// provider:	基础平台组
/// description:处理消息管理中的消息,读取消息
/// w ##class(web.DHCSTInterfaceFromElse).ExecMessage("1")
ClassMethod ExecPharmacyMsg(Context, Para, OtherData) As %String
{
	
	s ActionCode=$p(Para,"^",1)
	s FrmUser=$p(Para,"^",2)
	s EpisodeId=$p(Para,"^",3)
	s OrdItm=$p(Para,"^",4)
	s ToUser=$p(Para,"^",5)
	s ExeUser=1

	i $d(%session.Data("LOGON.USERID")) s ExeUser=%session.Data("LOGON.USERID")
	s ret=##class(websys.DHCMessageInterface).Exec(ToUser,ActionCode,EpisodeId,OrdItm,OtherData,ExeUser)
	q ret
}

/// creator:	MYQ
/// createdate:	20170818
/// provider:	基础平台组
/// description:处理消息管理中的消息,取消消息
/// w ##class(web.DHCSTInterfaceFromElse).ExecMessage("1")
ClassMethod CancelPharmacyMsg(Context, Para, OtherData) As %String
{
	s ActionCode=$p(Para,"^",1)
	s FrmUser=$p(Para,"^",2)
	s EpisodeId=$p(Para,"^",3)
	s OrdItm=$p(Para,"^",4)
	s ToUser=$p(Para,"^",5)
	s ExeUser=1
	i $d(%session) s ExeUser=%session.Data("LOGON.USERID")
	s ret=##class(websys.DHCMessageInterface).Cancel(ToUser,ActionCode,EpisodeId,OrdItm,OtherData,ExeUser)
	q ret
}

/// creator:	yunhaibao
/// createdate:	2018-06-13
/// provider:	计费医保组
/// description:根据医嘱项Id,费别获取医保类别(甲乙丙)
/// w ##class(web.DHCSTInterfaceFromElse).ArcimLinkInsu("1812||1","")
ClassMethod ArcimLinkInsu(ArcItmId, AdmReasonId = "", HospId = "") As %String
{
	q ##class(PHA.FACE.IN.Com).GetInsuCode(ArcItmId, AdmReasonId , HospId)
	/*
	i AdmReasonId="" d
	.s appName="DHCSTCOMMON"
	.s params="^^^"_HospId
    .s admReasonCode=##class(web.DHCST.Common.AppCommon).GetAppPropValue(appName,"ADmReasonLinkInsu",params)
    .s admReasonCode=$$ALPHAUP^SSUTIL4(admReasonCode)
    .q:admReasonCode=""
    .s AdmReasonId=$o(^PAC("ADMREA",0,"Code",admReasonCode,""))
	s insuRet=##class(web.DHCINSUPort).ArcimLinkInsu(ArcItmId,AdmReasonId,HospId)
	s insuType=$p(insuRet,"^",1)
	i +insuType<0 s insuType=""
	q insuType
	*/
}

/// creator:	dinghongying
/// createdate:	2018-08-16
/// provider:	护理组
/// description:根据就诊号获取床号
/// w ##class(web.DHCSTInterfaceFromElse).GetPatBedCode("")
ClassMethod GetPatBedCode(episodeId As %String) As %String
{
	set bedCode=##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(episodeId)
	q bedCode
}

/// creator:	yunhaibao
/// createdate:	2018-11-14
/// provider:	医生站
/// description:获取病人密级以及级别
/// return:		密级特殊字符^病人级别^密级代码^密级描述 或 空
/// others:		前台显示显示特殊字符与病人级别
/// w ##class(web.DHCSTInterfaceFromElse).GetPatEncryptLevel()
ClassMethod GetPatEncryptLevel(PatId) As %String
{
	q ##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(PatId,"")
}

/// creator:	yunhaibao
/// createdate:	2019-11-27
/// provider:	计费组
/// description:计费住院业务参数接口
/// input:		HospId(院区Id)
/// 			Flag(参数代码)
/// 				OutPhBillCondition[出院带药是否按计费点计费]<return:Y N>
/// return:		参数代码不同,返回结果不同
/// w ##class(web.DHCSTInterfaceFromElse).IGetIPParamConfig(2,"OutPhBillCondition")
ClassMethod IGetIPParamConfig(HospId, Flag) As %String
{
	s index = $lb(HospId, Flag)
	q:$d(%DHCSTInterfaceFromElse("IGetIPParamConfig", index), ret) ret
	s ret = ##class(web.DHCBillInterface).IGetIPParamConfig(HospId, Flag)
	s %DHCSTInterfaceFromElse("IGetIPParamConfig", index) = ret
	q ret
}

}
