Import SQLUser

/// Description:药房药库用于基础平台消息接口汇总数据发出与处理
/// 			因发出与读取的部分字段是相同的,为防止错乱,统一此处汇总信息
/// CreateDate: 2017-03-27
/// Creator:	yunhaibao
Class web.DHCSTInterfaceMessage Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// description: 发送消息
/// 				 处方审核拒绝,拒绝发药,医嘱审核拒绝,配伍审核不通过
///       input: MonitorId:DHC_PHAORDMONITOR id
/// 				   MsgType:Exec-读取,Send-发送
/// w ##class(web.DHCSTInterfaceMessage).SendRefuseOrderMonitor(9959,"Send")
ClassMethod SendRefuseOrderMonitor(MonitorId As %String, MsgType As %String) As %String
{
	n (MonitorId,MsgType,%session)
	s apptype=$p(^DHCPHORDM(MonitorId),"^",9)
	s Context=""
	i apptype="" d
	.s Context="处方点评不通过"
	.s ActionCode="1002"
	i ((apptype="OR")||(apptype="HERBOR")||(apptype="HERBIR")) d
	.s Context="拒绝发药"
	.s ActionCode="1003"
	i (apptype="OA")||(apptype="HERBOA") d
	.s Context="处方审核不通过"
	.s ActionCode="1003"
	i ((apptype="IA")||(apptype="HERBIA")) d
	.s Context="医嘱审核不通过"
	.s ActionCode="1003"
	i apptype="PIVAS" d
	.s Context="配伍审核不通过"
	.s ActionCode="1003"
	q:ActionCode="" -1001
	s FrmUser=$p(^DHCPHORDM(MonitorId),"^",1)
	s MonitorSub=$o(^DHCPHORDM(MonitorId,"I",""))
	q:MonitorSub="" ""
	s prescno=$p(^DHCPHORDM(MonitorId,"I",MonitorSub),"^",4)
	i prescno'="" d
	.s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	.s orditm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
	e  d
	.s oeori=$p(^DHCPHORDM(MonitorId,"I",MonitorSub),"^",2)
	.s ord=+oeori
	.s orditm=$p(oeori,"||",2)	
	s EpisodeId=$p(^OEORD(ord),"^",1)
	S Papmi=$p(^PAADM(EpisodeId),"^",1)
	S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",2) //登记号
	s OrdItm=ord_"||"_orditm
	s doctor=$p($g(^OEORD(ord,"I",orditm,1)),"^",11)
	s ToUser=$o(^SSU("SSUSR",0,"CTPCP",doctor,""))
	s OtherData=..OrderMonitorLink("gPatNo="_PatNo_"&gOeori="_OrdItm,apptype)
	i MsgType="Exec" s FrmUser="",ToUser="" //,OtherData="gPatNo="_PatNo
	s Para=ActionCode_"^"_FrmUser_"^"_EpisodeId_"^"_OrdItm_"^"_ToUser
	s monitorDetail=..GetMonitorDetail(MonitorId,"R")
	s Context=Context_"</br>"_monitorDetail
	i MsgType="Send" s ret=##class(web.DHCSTInterfaceFromElse).SendPharmacyMsg(Context,Para,OtherData)
	e  i MsgType="Exec" d
	.s ret=##class(web.DHCSTInterfaceFromElse).ExecPharmacyMsg(Context,Para,OtherData)
	q ret
}

/// description: 撤销处方审核拒绝,撤销拒绝发药,撤销医嘱审核拒绝
/// 	  input: MonitorId:DHC_PHAORDMONITOR id
/// 				   MsgType:Exec-读取,Send-发送
ClassMethod SendCancelOrderMonitor(MonitorId As %String, MsgType As %String) As %String
{
	n (MonitorId,MsgType,%session)
	s apptype=$p(^DHCPHORDM(MonitorId),"^",9)
	s Context=""
	i apptype="" d
	.s Context="处方点评撤销"
	.s ActionCode="1002"
	i apptype="OR" d
	.s Context="撤销拒绝发药"
	.s ActionCode="1003"
	i apptype="OA" d
	.s Context="撤销处方审核不通过"
	.s ActionCode="1003"
	s MonitorSub=$o(^DHCPHORDM(MonitorId,"I",""))
	q:MonitorSub="" ""
	s prescno=$p(^DHCPHORDM(MonitorId,"I",MonitorSub),"^",4)
	q:'$d(^OEORD(0,"PrescNo",prescno)) 0
	s oeord=$o(^OEORD(0,"PrescNo",prescno,""))
	s oeorditm=$o(^OEORD(0,"PrescNo",prescno,oeord,""))
	s doctor=$p($g(^OEORD(oeord,"I",oeorditm,1)),"^",11)
	s ToUser=$o(^SSU("SSUSR",0,"CTPCP",doctor,"")) //modify by wyx 2015-02-04	
	s FrmUser=$p(^DHCPHORDM(MonitorId),"^",12)
	s EpisodeId=$p(^OEORD(oeord),"^",1)
	S Papmi=$p(^PAADM(EpisodeId),"^",1)
	S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",2) //登记号
	s OrdItm=oeord_"||"_oeorditm
	s ToUser=$o(^SSU("SSUSR",0,"CTPCP",doctor,"")) //modify by wyx 2015-02-04
	s OtherData=..OrderMonitorLink("gPatNo="_PatNo)
	s Para=ActionCode_"^"_FrmUser_"^"_EpisodeId_"^"_OrdItm_"^"_ToUser
	s ret=##class(web.DHCSTInterfaceFromElse).SendPharmacyMsg(Context,Para,OtherData)
}

/// description: 处方审核申诉
///       input: MonitorId:DHC_PHAORDMONITOR id
/// 		 		   MsgType:Exec-读取,Send-发送
/// d ##class(web.DHCSTInterfaceMessage).SendAppealOrderMonitor(9474,"Send",6)
ClassMethod SendAppealOrderMonitor(MonitorId As %String, MsgType As %String, FromUser = "") As %String
{
	n (MonitorId,MsgType,FromUser,%session)
	s apptype=$p(^DHCPHORDM(MonitorId),"^",9)
	s MonitorSub=$o(^DHCPHORDM(MonitorId,"I",""))
	q:MonitorSub="" ""
	s prescno=$p(^DHCPHORDM(MonitorId,"I",MonitorSub),"^",4)
    s ActionCode=""
    s Context=""
	i ((apptype="OA")||(apptype="HERBOA")||(apptype="HERBIA")) d
	.s Context=Context_" 处方审核申诉"
	.s ActionCode="1044"
	i ((apptype="OR")||(apptype="HERBOR")||(apptype="HERBIR")) d
	.s Context=Context_" 拒绝发药申诉"
	.s ActionCode="1048"
	i apptype="IA" d
	.s Context=Context_" 医嘱审核申诉"
	.s ActionCode="1044"
	i apptype="PIVAS" d
	.s Context=Context_" 配伍审核申诉"
	.s ActionCode="1044"
    i $d(%session) s FrmUser=$g(%session.Data("LOGON.USERID"))	
	e  s FrmUser=FromUser
	i prescno'="" d
	.s ord=$o(^OEORD(0,"PrescNo",prescno,""))
	.s orditm=$o(^OEORD(0,"PrescNo",prescno,ord,""))
	e  d
	.s oeori=$p(^DHCPHORDM(MonitorId,"I",MonitorSub),"^",2)
	.s ord=+oeori
	.s orditm=$p(oeori,"||",2)
	.s prescno=$p($g(^OEORD(ord,"I",orditm,1)),"^",14)
	s Context=Context_" 处方号:"_prescno	
	s EpisodeId=$p(^OEORD(ord),"^",1)
	S Papmi=$p(^PAADM(EpisodeId),"^",1)
	S PatNo=$p(^PAPER(Papmi,"PAT",1),"^",2) //登记号
	s OrdItm=ord_"||"_orditm
	s doctor=$p($g(^OEORD(ord,"I",orditm,1)),"^",11)
	s ToUser=$p(^DHCPHORDM(MonitorId),"^",1)
	s monitorDetail=..GetMonitorDetail(MonitorId,"R")
	s Context=Context_"</br>"_monitorDetail
	s OtherData=..AppealMonitorLink(apptype,"gPatNo="_PatNo_"&gOeori="_OrdItm,prescno)
	i MsgType="Exec" s FrmUser="", ToUser=""
	s Para=ActionCode_"^"_FrmUser_"^"_EpisodeId_"^"_OrdItm_"^"_ToUser
	i MsgType="Send" s ret=##class(web.DHCSTInterfaceFromElse).SendPharmacyMsg(Context,Para,OtherData)
	e  i MsgType="Exec" s ret=##class(web.DHCSTInterfaceFromElse).ExecPharmacyMsg(Context,Para,OtherData)
	q ret
}

/// description: 发送消息
/// 				 处方点评不合理
///       input: CntItm:DHC_PHCOMMENTSITM id , PcntsOrditm - 不合理医嘱id(add by myq 20170816)
/// 				   MsgType:Exec-读取,Send-发送
/// w ##class(web.DHCSTInterfaceMessage).SendCommentResult("1765||1","Send","124||20")
ClassMethod SendCommentResult(PCntItm As %String, MsgType As %String, PcntsOrditm As %String = "", Context As %String = "") As %String
{
	n (PCntItm,MsgType,PcntsOrditm,Context,%session)
	s PCntId=+PCntItm
	s PCntSub=+$p(PCntItm,"||",2)
	q:(PCntId=0)||(PCntSub=0) ""
	s PrescNo=$p(^DHCPHCNTS(PCntId,"I",PCntSub),"^",1)
	s Oeori=$p(^DHCPHCNTS(PCntId,"I",PCntSub),"^",2)
	s Ord=+Oeori
	s OrdItm=+$p(Oeori,"||",2)
	i (Ord=0)||(OrdItm=0) d
	.s Oeori=PcntsOrditm
	.s Ord=+PcntsOrditm
	.s OrdItm=+$p(PcntsOrditm,"||",2)
	q:(Ord=0)||(OrdItm=0) ""
	//s Context="处方点评不通过"
	s ActionCode="1002"
	s Adm=$p(^OEORD(Ord),"^",1)
	s Doctor=$p($g(^OEORD(Ord,"I",OrdItm,1)),"^",11)
	s ToUser=$o(^SSU("SSUSR",0,"CTPCP",Doctor,""))
    i $d(%session) s FrmUser=$g(%session.Data("LOGON.USERID"))	
	e  d
	.s PCntSubChl=$o(^DHCPHCNTS(PCntId,"I",PCntSub,"L",""),-1)
	.s FrmUser=$p(^DHCPHCNTS(PCntId,"I",PCntSub,"L",PCntSubChl),"^",5)
	q:FrmUser="" ""
	s AppType=""
	s OtherData=..CommentLink(AppType, "PCntItmLogID="_PCntItm)
	s ReSaveFlag=$p($g(^DHCPHCNTS(PCntId)),"^",13)	//二次点评标志
	i ReSaveFlag="Y" d
	.s ActionCode="1141"		// 二次抽点评为不合理时将消息放给一级点评药师
	.s firstCntsItm=$p(^DHCPHCNTS(PCntId,"I",PCntSub),"^",10)
	.s firstCntSubChl=+$o(^DHCPHCNTS(+firstCntsItm,"I",+$p(firstCntsItm,"||",2),"L",""),-1)
	.s ToUser=$p($g(^DHCPHCNTS(+firstCntsItm,"I",+$p(firstCntsItm,"||",2),"L",firstCntSubChl)),"^",5)
	.s PCntType=$p($g(^DHCPHCNTS(+firstCntsItm)),"^",5)	//点评单类型
	.s OrdItm=PcntsOrditm
	.s OtherData=..AppealCommentLink(PCntType,"gOeori="_OrdItm_"&gPCntId="_+firstCntsItm)
	
	i MsgType="Exec" s FrmUser="", ToUser=""
	s Para=ActionCode_"^"_FrmUser_"^"_Adm_"^"_Oeori_"^"_ToUser_"^"_PCntItm
	
	i MsgType="Send" s ret=##class(web.DHCSTInterfaceFromElse).SendPharmacyMsg(Context,Para,OtherData)
	e  i MsgType="Exec" s ret=##class(web.DHCSTInterfaceFromElse).ExecPharmacyMsg(Context,Para,Context)	
	e  i MsgType="Cancel" s ret=##class(web.DHCSTInterfaceFromElse).CancelPharmacyMsg(Context,Para,Context)	
	q ""
}

/// description: 发送消息
/// 				 处方点评申诉
///       input: CntItm:DHC_PHCOMMENTSITM id
/// 				   MsgType:Exec-读取,Send-发送
/// w ##class(web.DHCSTInterfaceMessage).SendAppealComment(7039,"Exec")
ClassMethod SendAppealComment(PCntItmSub As %String, MsgType As %String, PcntsOrditm As %String = "", Context As %String = "") As %String
{
	n (MsgType,PCntItmSub,PcntsOrditm,Context,%session)
	//s Context="处方点评申诉"
	s ActionCode="1056"
	s PCntId=+PCntItmSub
	s PCntSub=+$p(PCntItmSub,"||",2)
	s PCntSubChl=+$p(PCntItmSub,"||",3)
	q:(PCntId=0)||(PCntSub=0) ""
	s PCntType=$p(^DHCPHCNTS(PCntId),"^",5)	//点评单类型
	s OrdItm="",FrmUser="",EpisodeId="",ToUser=""
	i MsgType="Send" d
	.s PCTId=$o(^DHCPCTABL(0,"LOG",PCntItmSub,""))	 //DHC_PHCNTSTABOOLIST
	.s:PCTId'="" OrdItm=$p(^DHCPCTABL(PCTId),"^",1)
	.i OrdItm'="" d
	..s Doctor=$p(^OEORD(+OrdItm,"I",$p(OrdItm,"||",2),1),"^",11)		//下医嘱医生
	..s:Doctor'="" FrmUser=$o(^SSU("SSUSR",0,"CTPCP",Doctor,""))
	.s ToUser=$p(^DHCPHCNTS(+PCntId,"I",PCntSub,"L",PCntSubChl),"^",5)	//审核人
	e  d
	.s OrdItm=$p(^DHCPHCNTS(PCntId,"I",PCntSub),"^",2)
	.s EpisodeId=$p(^OEORD(+OrdItm),"^",1)	//就诊id
	
	s OtherData=..AppealCommentLink(PCntType,"gOeori="_OrdItm_"&gPCntId="_+PCntItmSub)
	s Para=ActionCode_"^"_FrmUser_"^"_EpisodeId_"^"_OrdItm_"^"_ToUser
	
	i MsgType="Send" s ret=##class(web.DHCSTInterfaceFromElse).SendPharmacyMsg(Context,Para,OtherData)
	e  i MsgType="Exec" s ret=##class(web.DHCSTInterfaceFromElse).ExecPharmacyMsg(Context,Para,OtherData)	
	q ""
}

/// description: 处方审核链接申诉界面
ClassMethod OrderMonitorLink(ParamsStr, AppType) As %String
{
	n (ParamsStr,AppType)
	//s startlink="{""link"":""dhcpha.outpha.outmonitorrefdrg.csp?"	// ext
	s startlink="{""link"":""dhcpha.outpha.docmonitor.csp?"
	s endlink=""",""dialogHeight"":""1000px"",""dialogWidth"":""1400px""}"
	s link=startlink_ParamsStr_endlink
	q link
}

/// description: 处方审核申诉链接处方审核/直接发药界面
/// w ##class(web.DHCSTInterfaceMessage).AppealMonitorLink("OR")
ClassMethod AppealMonitorLink(AppType, ParamsStr = "", PrescNo = "") As %String
{
	n (AppType,ParamsStr,PrescNo)
 	s cyFlag=""
 	i PrescNo'="" d
 	.s queId=##class(PHA.COM.Order).PrescCYQueId(PrescNo)
 	.s cyFlag=$s(queId>0:"Y",1:"")	
 	i AppType="OA" d
 	.i cyFlag="Y" d
 	..s startlink="{""link"":""dhcpha/dhcpha.outpha.hmprescaudit.csp?"
 	.e  d
	..s startlink="{""link"":""dhcpha/dhcpha.outpha.outmonitor.csp?"
	e  i AppType="IA" d
	.i cyFlag="Y" d
 	..s startlink="{""link"":""dhcpha/dhcpha.inpha.hmtrialprescaudit.csp?"
 	.e  d
	..s startlink="{""link"":""dhcpha/dhcpha.inpha.ipmonitor.csp?"
	e  i AppType="PIVAS" d
	.s ordId = +$o(^OEORD(0,"PrescNo",PrescNo,""))
	.s adm = $p($g(^OEORD(ordId)), "^", 1)
	.s admType = $p($g(^PAADM(adm)), "^", 2)
	.i (admType = "I") d
	..s startlink="{""link"":""dhcpha.pivas.oeaudit.csp?"
	.e  d
	..s startlink="{""link"":""pha.opivas.v4.oeaudit.csp?" 
	e  d
	.i cyFlag="Y" d
	..i AppType="HERBIR" d
 	...s startlink="{""link"":""pha.herb.v2.ipdisp.csp?"
 	..e  i AppType="HERBOR" d
 	...s startlink="{""link"":""pha.herb.v2.opdisp.csp?"
 	.e  d
	..s startlink="{""link"":""pha.op.v4.disp.csp?"
	..//s startlink="{""link"":""dhcpha/dhcpha.outpha.disp.csp?"
	.
	s endlink=""",""dialogHeight"":""1000px"",""dialogWidth"":""1400px""}"
	s link=startlink_ParamsStr_endlink
	q link
}

/// description: 处方点评不合理链接
/// w ##class(web.DHCSTInterfaceMessage).CommentLink("OR")
ClassMethod CommentLink(AppType, ParamsStr = "") As %String
{
	n (AppType,ParamsStr)
	//s startlink="{""link"":""dhcpha.comment.hisui.findfordoctor.csp?"""
	s startlink="{""link"":""pha.prc.v2.create.findfordoctor.csp?"
	s endlink=""",""dialogHeight"":""1000px"",""dialogWidth"":""1400px""}"
	s link=startlink_ParamsStr_endlink
	q link
}

/// description: 处方点评申诉链接
/// w ##class(web.DHCSTInterfaceMessage).AppealCommentLink("OR")
ClassMethod AppealCommentLink(AppType, ParamsStr = "") As %String
{
	n (AppType,ParamsStr)
	s startlink="{""link"":""dhcpha.comment.findfordoctor.csp?"
	//i AppType="F" s startlink="{""link"":""dhcpha.comment.main.csp?"
	//e  s startlink="{""link"":""dhcpha.comment.ipmain.csp?"
	i AppType="F" s startlink="{""link"":""pha.prc.v2.comment.main.csp?"
	e  s startlink="{""link"":""pha.prc.v2.comment.ipmain.csp?"
	s endlink=""",""dialogHeight"":""1000px"",""dialogWidth"":""1400px""}"
	s link=startlink_ParamsStr_endlink
	q link
}

/// Description: 住院药房拒绝发药发送与读取消息
/// CreateDate:	 2019-12-19
/// Creator:	 YunHaiBao
/// Input:		 DspId(打包表Id),MsgType(<Send:发送><Exec:读取>),UserId(操作人)
/// Debug:		 w ##class(web.DHCSTInterfaceMessage).SendIPRefuseDisp(4272,"Send",10213)
/// 			 w ##class(web.DHCSTInterfaceMessage).SendIPRefuseDisp(2656,"Cancel",10213)
ClassMethod SendIPRefuseDisp(DspId, MsgType, UserId)
{
	n (DspId, MsgType, UserId,%session)
	q:DspId="" ""
	s actionCode="1132"
	s DHCOEDISQTY=$g(^DHCOEDISQTY(DspId))
	s oeori=$p(DHCOEDISQTY,"^",1)
	s admId=$p(DHCOEDISQTY,"^",26)
	s confirmUserId=$p(DHCOEDISQTY,"^",12)
	i MsgType="Send" s confirmUserId=UserId
	s paramStr=actionCode_"^"_UserId_"^"_admId_"^"_oeori_"^"_""
	s arcim=$p(^OEORD(+oeori,"I",+$p(oeori,"||",2),1),"^",2)
	s arcimDesc=$p($g(^ARCIM(+arcim,1,1)),"^",2)
	s doseDate=$p(DHCOEDISQTY,"^",21)
	s doseTime=$p(DHCOEDISQTY,"^",20)
	s doseDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(doseDate,"IP")
	s doseTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(doseTime,"IP")
	s freqDesc=$p(##class(web.DHCSTCOMMONORDER).OeoriFreq(oeori),"^",4)
	s stdfId=$o(^STDF("DODIS",DspId,""))
	s reasonId=$p($g(^STDF(+stdfId)),"^",7)
	s reasonDesc=$p($g(^DHCRFREASON(+reasonId)),"^",2)
	s context="</br>"_arcimDesc_"<span style=padding-left:20px>"_freqDesc_"</span><span style=padding-left:20px>"_doseDate_" "_doseTime_"<span>"
	i reasonDesc'="" s context=context_"</br>拒绝原因:"_reasonDesc
	s otherJson={}
	s otherJson.dspId=DspId
	s otherData=otherJson.%ToJSON()	// 标识消息Id
	i MsgType="Send" s ret=##class(web.DHCSTInterfaceFromElse).SendPharmacyMsg(context,paramStr,otherData)
	e  i MsgType="Exec" s ret=##class(web.DHCSTInterfaceFromElse).ExecPharmacyMsg(context,paramStr,otherData)
	e  i MsgType="Cancel" s ret=##class(web.DHCSTInterfaceFromElse).CancelPharmacyMsg(context,paramStr,otherData)
	q ret
}

/// Description: 获取医嘱审核\处方审核的详细信息,用于消息界面的显示
/// 			 静配(仅显示主医嘱药品)
/// 			 其他(按选择的药品与原因显示)
/// Input:		 type(R:拒绝,A:申诉)
/// Debug:		 w ##class(web.DHCSTInterfaceMessage).GetMonitorDetail(821,"R")
ClassMethod GetMonitorDetail(phaOrd, type)
{
	n (phaOrd, type)
	q:phaOrd="" ""
	q:'$d(^DHCPHORDM(phaOrd)) ""
	k GetMonitorDetailDATA
	s retStr=""
	s phaOrdItm=$o(^DHCPHORDM(phaOrd,"I",0))
	q:+phaOrdItm=0 ""
	s appType=$p(^DHCPHORDM(phaOrd),"^",9)
	s oeori=$p(^DHCPHORDM(phaOrd,"I",phaOrdItm),"^",2)
	s prescNo=$p(^DHCPHORDM(phaOrd,"I",phaOrdItm),"^",4)
	s phNotes=$p(^DHCPHORDM(phaOrd),"^",6)
	s docNotes=$p(^DHCPHORDM(phaOrd),"^",7)
	i appType["PIVAS" d
	.s mOeori=##class(web.DHCSTCOMMONORDER).GetMainOeori(oeori)
	.s arcim=$p($g(^OEORD(+mOeori,"I",+$p(mOeori,"||",2),1)),"^",2)
	.s arcimDesc=$p($g(^ARCIM(+arcim,+$p(arcim,"||",2),1)),"^",2)
	.s reasonStr=""
	.s phaOrdItm=0
	.f  s phaOrdItm=$o(^DHCPHORDM(phaOrd,"I",phaOrdItm)) q:phaOrdItm=""  d
	..s DHCPHORDMI=^DHCPHORDM(phaOrd,"I",phaOrdItm)
	..s reasonDR=$p(DHCPHORDMI,"^",3)
	..q:reasonDR=""
	..s reasonDesc=$p($g(^DHCPCREASON(+reasonDR)),"^",2)
	..s reasonStr=$s(reasonStr="":reasonDesc,1:reasonStr_","_reasonDesc)
	.s retStr=arcimDesc_"</br>拒绝原因："_reasonStr
	.i phNotes'="" s retStr=retStr_"</br>药师备注："_phNotes
	.i docNotes'="" s retStr=retStr_"</br>医师备注："_docNotes
	q:appType["PIVAS" retStr
 	s phaOrdItm=0,reasonNum=0
 	f  s phaOrdItm=$o(^DHCPHORDM(phaOrd,"I",phaOrdItm)) q:phaOrdItm=""  d
 	.s phaOrdItmData=^DHCPHORDM(phaOrd,"I",phaOrdItm)
 	.s oeori=$p(phaOrdItmData,"^",2) 
	.q:oeori=""
 	.s reasonId=$p(phaOrdItmData,"^",3) // 审核原因
 	.q:reasonId=""
 	.s GetMonitorDetailDATA("Oeori",oeori)=phaOrdItmData
 	.q:$d(GetMonitorDetailDATA("Reason",oeori,reasonId))
	.s reasonDesc=$p($g(^DHCPCREASON(reasonId)),"^",2)
	.s reasonNum=reasonNum+1
	.i '$d(GetMonitorDetailDATA("ReasonStr",oeori)) d
	..s GetMonitorDetailDATA("ReasonStr",oeori)=reasonDesc
	.e  d
	..s GetMonitorDetailDATA("ReasonStr",oeori)=GetMonitorDetailDATA("ReasonStr",oeori)_","_reasonDesc
	q:'$d(GetMonitorDetailDATA) ""
	s oeori="",reasonStr=""
	f  s oeori=$o(GetMonitorDetailDATA("ReasonStr",oeori)) q:oeori=""  d
	.s arcim=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),1)),"^",2)
	.s arcimDesc=$p($g(^ARCIM(+arcim,+$p(arcim,"||",2),1)),"^",2)
	.s data=arcimDesc_" : "_GetMonitorDetailDATA("ReasonStr",oeori)
	.s reasonStr=$s(reasonStr="":data,1:reasonStr_"</br>"_data)
	s retStr=reasonStr
	i phNotes'="" s retStr=retStr_"</br>药师备注："_phNotes
	i docNotes'="" s retStr=retStr_"</br>医师备注："_docNotes	
	q retStr
}

}
