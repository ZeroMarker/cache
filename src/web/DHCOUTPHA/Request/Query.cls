/// description: 门诊退药申请
Class web.DHCOUTPHA.Request.Query Extends %RegisteredObject
{

/// creator:	yunhaibao
/// createdate:	2018-12-12
/// deccription:可退药申请的处方列表
/// 就诊日期+处方倒序
/// d ##class(%ResultSet).RunQuery("web.DHCOUTPHA.Request.Query","GetPrescForReq","0000000939^4634^266")
Query GetPrescForReq(inputStr = "") As websys.Query(ROWSPEC = "prescNo,recLocDesc,admDate")
{
}

ClassMethod GetPrescForReqExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s ^TMPDHCSTPARAMS("web.DHCOUTPHA.Request.Query","GetPrescForRet")=inputStr
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	s PatNo=$p(inputStr,"^",1)
	s DoctorId=$p(inputStr,"^",2)
	s DocLocId=$p(inputStr,"^",3)
	q:(PatNo="")||(DoctorId="")||(DocLocId="") $$$OK
	s HospId=$p($g(^CTLOC(DocLocId)),"^",22)
	s PayModeFlag=##class(PHA.FACE.IN.Com).IStayPayModeByEpisodeID(HospId)
	///q:PayModeFlag=0 $$$OK
	s PatId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(PatNo),""))
	q:PatId="" $$$OK
	/*******如上为常量*********/
	s phdId=0
	f  s phdId=$o(^DHCPHDISPi("PAPMI",PatId,phdId)) q:(phdId="")!(phdId="0")   d
	.q:'$d(^DHCPHDISP(phdId))
	.s fyFlag=$p(^DHCPHDISP(phdId),"^",4)
	.q:fyFlag'="1"
	.s phLocId=+$p(^DHCPHDISP(phdId,1),"^",1)
	.s locId=$p(^DHCPHLOC(phLocId),"^",1)
	.s hospId=+$p($g(^CTLOC(+locId)),"^",22)
	.// 过滤-院区
	.q:(+HospId'=0)&&(+HospId'=hospId) 
	.s fyDate=$p(^DHCPHDISP(phdId),"^",3)
	.s existFlag=""
	.s phdItm=""
	.f  s phdItm=$o(^DHCPHDI(phdId,"PHDI",phdItm)) q:(phdItm="")!(existFlag'="")  d
	..q:'$d(^DHCPHDI(phdId,"PHDI",phdItm))
	..s phdItmData=^DHCPHDI(phdId,"PHDI",phdItm)
	..s oeori=$p(phdItmData,"^",5)
	..q:##class(web.DHCOutPhCommon).PrtOPToIP(oeori)=1	// 门诊转住院
	..s emLGflag=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),"DHC")),"^",17)
	..q:emLGflag'="1"
	..s oeoriStatCode=$p(##class(web.DHCSTCOMMONORDER).OeoriStat(oeori),"^",1)
	..q:(oeoriStatCode="V")||(oeoriStatCode="E")
	..s userAddId=$p($g(^OEORD(+oeori,"I",+$p(oeori,"||",2),"7")),"^",1)
	..q:DoctorId'=userAddId
	..s phdSub=""
	..f  s phdSub=$o(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdSub))  q:(phdSub="")!(existFlag'="")  d
	...q:'$d(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdSub))
	...s dispQty=0,retedQty=0,canRetQty=0
	...s phdSubData=^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdSub)
	...s dispQty=+$p(phdSubData,"^",1)
	...s retedQty=+$p(phdSubData,"^",2)
	...s canRetQty=dispQty-retedQty
	...q:canRetQty<=0
	...s phditmlbid=phdId_"||"_phdItm_"||"_phdSub
	...s reqQty=0
	...i $d(^DHCPHREQi("PHDSUB",phditmlbid)) d
	....s reqid=""
	....f  s reqid=$o(^DHCPHREQi("PHDSUB",phditmlbid,reqid)) q:reqid=""  d
	.....s reqData=^DHCPHREQ(reqid)
	.....s reqCancel=$p(reqData,"^",1)
	.....q:reqCancel=1	
	.....s retFlag=$p(reqData,"^",11)
	.....// 过滤-已退
	.....q:(retFlag'=0)&&(retFlag'="")
	.....s reqsub=""
	.....f  s reqsub=$o(^DHCPHREQi("PHDSUB",phditmlbid,reqid,reqsub)) q:reqsub=""  d
	......s reqItmQty=0
	......s reqItmQty=$p(^DHCPHREQ(reqid,"I",reqsub),"^",4)
	......s reqQty=reqQty+reqItmQty
	...s canRetQty=canRetQty-reqQty
	...q:canRetQty<=0
	...s existFlag=1
	.q:existFlag=""
	.s prescNo=$p(^DHCPHDISP(phdId,2),"^",1)
	.q:prescNo=""
	.s admId=$p(^OEORD(+oeori),"^",1)
	.s admDate=$p(^PAADM(admId),"^",6)
	.s recLocDesc=$p(^CTLOC(locId),"^",2)
	.s admDateHtml=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(admDate)
	.s GetPrescForReqData(admDate,prescNo)=prescNo_"^"_recLocDesc_"^"_admDateHtml
	s outputI=""
	f  s outputI=$o(GetPrescForReqData(outputI),-1) q:outputI=""  d
	.s outputJ=""
	.f  s outputJ=$o(GetPrescForReqData(outputI,outputJ),-1) q:outputJ=""  d
	..s data=GetPrescForReqData(outputI,outputJ)
	..s Data=$lfs(data,"^")
	..s ^CacheTemp(repid,ind)=Data    
	..s ind=ind+1
	q $$$OK
}

}
