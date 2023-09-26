/// creator:	 yunhaibao
/// createdate:  2018-12-04
/// description: 药房药库-闭环管理接口
Class web.DHCPHACOM.ComInterface.FaceTimeLine Extends %RegisteredObject
{

/// description:药品闭环管理--门诊--药师审核信息
/// return:		审核日期^时间^药师姓名
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetPharAudit("6||47")
ClassMethod GetPharAudit(OrdItemId)
{
	s prescNo=$p($g(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),1)),"^",14)
	q:prescNo="" ""
	s pharAuditDataStr=""
	s phaOrdId=""
	f  s phaOrdId=$o(^DHCPHORDM(0,"PrescNo",prescNo,phaOrdId)) q:(phaOrdId="")  d
	.q:+phaOrdId=0
	.s phaOrdData=^DHCPHORDM(phaOrdId)
	.q:$p(phaOrdData,"^",9)'="OA"
	.q:$p(phaOrdData,"^",2)="D"
	.s cancelUser=$p(phaOrdData,"^",12)
	.q:(cancelUser'="")
	.s status=$p(phaOrdData,"^",2)
	.i status="Y" d
	..s auditUserId=$p(phaOrdData,"^",1)
	..s auditDate=$p(phaOrdData,"^",3)
	..s auditTime=$p(phaOrdData,"^",4)
	..s auditDate=..DateLogicalToHtml(auditDate)
	..s auditTime=..TimeLogicalToHtml(auditTime)
	..s auditUserName=$p($g(^SSU("SSUSR",+auditUserId)),"^",2)	
	..s pharAuditData=auditDate_"^"_auditTime_"^"_auditUserName
	..i pharAuditDataStr="" d
	...s pharAuditDataStr=pharAuditData
	..e  d
	...s pharAuditDataStr=pharAuditDataStr_"!"_pharAuditData
	q:pharAuditDataStr'="" pharAuditDataStr
	s retArr=..GetPharAuditArrByExecId(OrdItemId_"||1")
	q:retArr.Count()=0 ""
	q:retArr.GetAt("state")["拒绝" ""
	q retArr.GetAt("date")_"^"_retArr.GetAt("time")_"^"_retArr.GetAt("userName")
}

/// description:药品闭环管理--门诊--配药信息
/// return:		配药日期^时间^配药人姓名^数量^单位;...
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetDisp("1309||9")
ClassMethod GetDisp(OrdItemId)
{
	q:'$d(^DHCPHDI(0,"OEORI",OrdItemId)) ""
	s arcItmId=$p(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),1),"^",2)
	s strucMode=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcItmId)
	i strucMode="Y" d
	.s phcdfId=$p(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1),"^",12)
	.s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	e  d
	.s dispUomId=$p($g(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),"DHC")),"^",13)
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	.s bUomId=$p(^INCI(incId,1),"^",10)	
	s pyDataStr=""
	s phdId=0
	f  s phdId=$o(^DHCPHDI(0,"OEORI",OrdItemId,phdId)) q:phdId=""  d
	.s fyFlag=$p(^DHCPHDISP(phdId),"^",4)
	.s pyPerId=$p(^DHCPHDISP(phdId,1),"^",3)
	.s pyUserId=$p($g(^DHCPHPER(+pyPerId)),"^",5)
	.s pyUserName=$p($g(^SSU("SSUSR",+pyUserId)),"^",2)
	.s pyDate=$p(^DHCPHDISP(phdId,1),"^",5)
	.s pyTime=$p(^DHCPHDISP(phdId,1),"^",7)
	.s pyDate=..DateLogicalToHtml(pyDate)
	.s pyTime=..TimeLogicalToHtml(pyTime)
	.s qty=0
	.s phdItm=0
	.f  s phdItm=$o(^DHCPHDI(0,"OEORI",OrdItemId,phdId,phdItm)) q:phdItm=""  d
	..i fyFlag="1" d	// 已发药,按发药计算
	...s phdItmLb=0
	...f  s phdItmLb=$o(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb)) q:phdItmLb=""  d
	....s phdItmLbData=^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb)
	....s phdQty=$p(phdItmLbData,"^",1)
	....i strucMode="Y" d
	.....// 一对多,转换药学基本单位数量
	.....s inclb=$p(phdItmLbData,"^",3)
	.....s incBUomId=$p(^INCI(+inclb,1),"^",10)
	.....s fac=##class(web.DHCSTINTERFACE).UOMFac(incBUomId,phcUomId)
	.....s phdQty=phdQty*fac
	....s qty=qty+phdQty
	..e  d
	...s dspId=$o(^DHCOEDISQTY(0,"OEORI",OrdItemId,""))
	...q:dspId=""
	...s qty=$p(^DHCOEDISQTY(dspId),"^",5)
	.q:qty=0
	.i strucMode="Y" d
	..s uomDesc=$p(^CT("UOM",phcUomId),"^",2)
	.e  d
	..i dispUomId'="" d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..e  d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
    ..s qty=$p(qtyUomStr,"^",1)
    ..s uomId=$p(qtyUomStr,"^",2)
    ..s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
	.s pyData=pyDate_"^"_pyTime_"^"_pyUserName_"^"_qty_"^"_uomDesc
	.i pyDataStr="" s pyDataStr=pyData
	.e  s pyDataStr=pyDataStr_";"_pyData
	q pyDataStr
}

/// description:药品闭环管理--门诊--配药完成信息
/// return:		配药完成日期^配药完成时间^配药完成人姓名^数量^单位;...
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetDispEnd("1309||9")
ClassMethod GetDispEnd(OrdItemId)
{
	q:'$d(^DHCPHDI(0,"OEORI",OrdItemId)) ""
	s arcItmId=$p(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),1),"^",2)
	s strucMode=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcItmId)
	i strucMode="Y" d
	.s phcdfId=$p(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1),"^",12)
	.s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	e  d
	.s dispUomId=$p($g(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),"DHC")),"^",13)
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	.s bUomId=$p(^INCI(incId,1),"^",10)	
	s pyEndDataStr=""
	s phdId=0
	f  s phdId=$o(^DHCPHDI(0,"OEORI",OrdItemId,phdId)) q:phdId=""  d
	.s fyFlag=$p(^DHCPHDISP(phdId),"^",4)
	.s pyPerId=$p(^DHCPHDISP(phdId,1),"^",3)
	.s pyUserId=$p($g(^DHCPHPER(+pyPerId)),"^",5)
	.s pyUserName=$p($g(^SSU("SSUSR",+pyUserId)),"^",2)
	.s pyEndDate=$p(^DHCPHDISP(phdId,2),"^",5)
	.s pyEndTime=$p(^DHCPHDISP(phdId,2),"^",6)
	.s pyEndDate=..DateLogicalToHtml(pyEndDate)
	.s pyEndTime=..TimeLogicalToHtml(pyEndTime)
	.s qty=0
	.s phdItm=0
	.f  s phdItm=$o(^DHCPHDI(0,"OEORI",OrdItemId,phdId,phdItm)) q:phdItm=""  d
	..i fyFlag="1" d	// 已发药,按发药计算
	...s phdItmLb=0
	...f  s phdItmLb=$o(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb)) q:phdItmLb=""  d
	....s phdItmLbData=^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb)
	....s phdQty=$p(phdItmLbData,"^",1)
	....i strucMode="Y" d
	.....// 一对多,转换药学基本单位数量
	.....s inclb=$p(phdItmLbData,"^",3)
	.....s incBUomId=$p(^INCI(+inclb,1),"^",10)
	.....s fac=##class(web.DHCSTINTERFACE).UOMFac(incBUomId,phcUomId)
	.....s phdQty=phdQty*fac
	....s qty=qty+phdQty
	..e  d
	...s dspId=$o(^DHCOEDISQTY(0,"OEORI",OrdItemId,""))
	...q:dspId=""
	...s qty=$p(^DHCOEDISQTY(dspId),"^",5)
	.q:qty=0
	.i strucMode="Y" d
	..s uomDesc=$p(^CT("UOM",phcUomId),"^",2)
	.e  d
	..i dispUomId'="" d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..e  d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
    ..s qty=$p(qtyUomStr,"^",1)
    ..s uomId=$p(qtyUomStr,"^",2)
    ..s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
	.s pyEndData=pyEndDate_"^"_pyEndTime_"^"_pyUserName_"^"_qty_"^"_uomDesc
	.i pyEndDataStr="" s pyEndDataStr=pyEndData
	.e  s pyEndDataStr=pyEndDataStr_";"_pyEndData
	q pyEndDataStr
}

/// description:药品闭环管理--门诊--发药信息
/// return:		发药日期^发药时间^发药人姓名^数量^单位;...
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetDisDrg("120||92")
ClassMethod GetDisDrg(OrdItemId)
{
	/* 门诊 */
	s arcItmId=$p(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),1),"^",2)
	s strucMode=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcItmId)
	i strucMode="Y" d
	.s phcdfId=$p(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1),"^",12)
	.s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	e  d
	.s dispUomId=$p($g(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),"DHC")),"^",13)
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	.s bUomId=$p(^INCI(incId,1),"^",10)	
	s fyDataStr=""
	s phdId=0
	f  s phdId=$o(^DHCPHDI(0,"OEORI",OrdItemId,phdId)) q:phdId=""  d
	.s fyFlag=$p(^DHCPHDISP(phdId),"^",4)
	.q:fyFlag'="1"
	.s fyPerId=$p(^DHCPHDISP(phdId,1),"^",2)
	.s fyUserId=$p($g(^DHCPHPER(+fyPerId)),"^",5)
	.s fyUserName=$p($g(^SSU("SSUSR",+fyUserId)),"^",2)
	.s fyDate=$p(^DHCPHDISP(phdId),"^",3)
	.s fyTime=$p(^DHCPHDISP(phdId),"^",5)
	.s fyDate=..DateLogicalToHtml(fyDate)
	.s fyTime=..TimeLogicalToHtml(fyTime)
	.s qty=0
	.s phdItm=0
	.f  s phdItm=$o(^DHCPHDI(0,"OEORI",OrdItemId,phdId,phdItm)) q:phdItm=""  d
	..s phdItmLb=0
	..f  s phdItmLb=$o(^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb)) q:phdItmLb=""  d
	...s phdItmLbData=^DHCPHDI(phdId,"PHDI",phdItm,"INCLB",phdItmLb)
	...s phdQty=$p(phdItmLbData,"^",1)
	...i strucMode="Y" d
	....// 一对多,转换药学基本单位数量
	....s inclb=$p(phdItmLbData,"^",3)
	....s incBUomId=$p(^INCI(+inclb,1),"^",10)
	....s fac=##class(web.DHCSTINTERFACE).UOMFac(incBUomId,phcUomId)
	....s phdQty=phdQty*fac
	...s qty=qty+phdQty
	.q:qty=0
	.i strucMode="Y" d
	..s uomDesc=$p(^CT("UOM",phcUomId),"^",2)
	.e  d
	..i dispUomId'="" d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..e  d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
    ..s qty=$p(qtyUomStr,"^",1)
    ..s uomId=$p(qtyUomStr,"^",2)
    ..s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
	.s fyData=fyDate_"^"_fyTime_"^"_fyUserName_"^"_qty_"^"_uomDesc
	.i fyDataStr="" s fyDataStr=fyData
	.e  s fyDataStr=fyDataStr_";"_fyData
	q:fyDataStr'="" fyDataStr		
	/* 急诊押金,可能会在住院流程 */
	s dispArr=..GetDispArrByExecId(OrdItemId_"||1")
	q:dispArr.Count()=0 ""
	q dispArr.GetAt("dspDate")_"^"_
	  dispArr.GetAt("dspTime")_"^"_
	  dispArr.GetAt("dspUserName")_"^"_
	  dispArr.GetAt("qty")_"^"_
	  dispArr.GetAt("uomDesc")
}

/// description:药品闭环管理--门诊--申请退药信息
/// return:		申请退药日期^申请退药时间^申请退药人姓名^数量^单位;...
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetApplyReDrg("6||47")
ClassMethod GetApplyReDrg(OrdItemId)
{
	k GetApplyReDrgData
	s reqDataStr=""
	s arcItmId=$p(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),1),"^",2)
	s strucMode=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcItmId)
	i strucMode="Y" d
	.s phcdfId=$p(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1),"^",12)
	.s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	e  d
	.s dispUomId=$p($g(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),"DHC")),"^",13)
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	.s bUomId=$p(^INCI(incId,1),"^",10)
	s dspId=$o(^DHCOEDISQTY(0,"OEORI",OrdItemId,""))
	q:dspId="" ""
	s dspSub=0
	f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	.s dspSubId=dspId_"||"_dspSub
	.s phReqId=0
	.f  s phReqId=$o(^DHCPHREQi("DSPB",dspSubId,phReqId)) q:phReqId=""  d
	..s qty=0
	..s phReqItm=0
	..f  s phReqItm=$o(^DHCPHREQi("DSPB",dspSubId,phReqId,phReqItm)) q:phReqItm=""  d
	...s phReqItmData=^DHCPHREQ(phReqId,"I",phReqItm)
	...s reqQty=$p(phReqItmData,"^",4)
	...q:+reqQty=0
	...i strucMode="Y" d
	....// 一对多,转换药学基本单位数量
	....s inclb=$p(phReqItmData,"^",12)
	....s incBUomId=$p(^INCI(+inclb,1),"^",10)
	....s fac=##class(web.DHCSTINTERFACE).UOMFac(incBUomId,phcUomId)
	....s reqQty=reqQty*fac
	...s qty=qty+reqQty
	..q:qty=0
	..i '$d(GetApplyReDrgData(phReqId)) d
	...s GetApplyReDrgData(phReqId)=qty
	..e  d
	...s GetApplyReDrgData(phReqId)=qty+GetApplyReDrgData(phReqId)
	q:'$d(GetApplyReDrgData)="" ""
	s phReqId=""
	f  s phReqId=$o(GetApplyReDrgData(phReqId)) q:phReqId=""  d
	.s qty=GetApplyReDrgData(phReqId)
	.i strucMode="Y" d
	..s uomId=phcUomId
	.e  d
	..i dispUomId'="" d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..e  d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
    ..s qty=$p(qtyUomStr,"^",1)
    ..s uomId=$p(qtyUomStr,"^",2)
    .s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
	.s phReqData=^DHCPHREQ(phReqId)
	.s reqDate=$p(phReqData,"^",4)
	.s reqTime=$p(phReqData,"^",16)
	.s reqUserId=$p(phReqData,"^",17)
 	.s reqUserName=$p($g(^SSU("SSUSR",+reqUserId)),"^",2)
	.s reqDate=..DateLogicalToHtml(reqDate)
	.s reqTime=..TimeLogicalToHtml(reqTime)
	.s reqData=reqDate_"^"_reqTime_"^"_reqUserName_"^"_qty_"^"_uomDesc
	.i reqDataStr="" s reqDataStr=reqData
	.e  s reqDataStr=reqDataStr_";"_reqData
	q:reqDataStr'="" reqDataStr
	s retList = ..GetReqListByExecId(OrdItemId_"||"_1)
	q:retList.Size=0 ""
	s retDataStr = ""
	f i = 1 : 1 : retList.Size d
	.s arrData = retList.GetAt(i)
	.s retData=arrData.GetAt("date")_"^"_arrData.GetAt("time")_"^"_arrData.GetAt("userName")_"^"_arrData.GetAt("qty")_"^"_arrData.GetAt("uomDesc")
	.i retDataStr="" s retDataStr=retData
	.e  s retDataStr=retDataStr_";"_retData
	q retDataStr
}

/// description:药品闭环管理--门诊--退药信息
/// return:		退药日期^退药时间^退药人姓名^数量^单位;...
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetReDrg("6||44")
ClassMethod GetReDrg(OrdItemId)
{
	s retDataStr=""
	s arcItmId=$p(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),1),"^",2)
	s strucMode=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcItmId)
	i strucMode="Y" d
	.s phcdfId=$p(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1),"^",12)
	.s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	e  d
	.s dispUomId=$p($g(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),"DHC")),"^",13)
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	.s bUomId=$p(^INCI(incId,1),"^",10)
	s phrId=0
	f  s phrId=$o(^DHCPHRTIi(OrdItemId,"ORDI",phrId)) q:phrId=""  d
	.s phrData=^DHCPHRET(phrId)
	.s retPerId=$p(phrData,"^",8)
	.s retUserId=$p($g(^DHCPHPER(+retPerId)),"^",5)
 	.s retUserName=$p($g(^SSU("SSUSR",+retUserId)),"^",2)
	.s retDate=$p(phrData,"^",2)
	.s retTime=$p(phrData,"^",10)
	.s retDate=..DateLogicalToHtml(retDate)
	.s retTime=..TimeLogicalToHtml(retTime)
	.s qty=0
	.s phrItm=0
	.f  s phrItm=$o(^DHCPHRTIi(OrdItemId,"ORDI",phrId,phrItm)) q:phrItm=""  d
	..s pharItmData=^DHCPHRTI(phrId,"RTI",phrItm)
	..s retQty=$p(pharItmData,"^",3)
	..i strucMode="Y" d
	...// 一对多,转换药学基本单位数量
	...s inclb=$p(pharItmData,"^",13)
	...s incBUomId=$p(^INCI(+inclb,1),"^",10)
	...s fac=##class(web.DHCSTINTERFACE).UOMFac(incBUomId,phcUomId)
	...s retQty=retQty*fac
	..s qty=qty+retQty
	.q:qty=0
	.i strucMode="Y" d
	..s uomDesc=$p(^CT("UOM",phcUomId),"^",2)
	.e  d
	..i dispUomId'="" d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..e  d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
    ..s qty=$p(qtyUomStr,"^",1)
    ..s uomId=$p(qtyUomStr,"^",2)
    ..s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
    .s retData=retDate_"^"_retTime_"^"_retUserName_"^"_qty_"^"_uomDesc
	.i retDataStr="" s retDataStr=retData
	.e  s retDataStr=retDataStr_";"_retData
	q:retDataStr'="" retDataStr
	s retList = ..GetRetListByExecId(OrdItemId_"||"_1)
	q:retList.Size=0 ""
	s retDataStr = ""
	f i = 1 : 1 : retList.Size d
	.s arrData = retList.GetAt(i)
	.s retData=arrData.GetAt("retDate")_"^"_arrData.GetAt("retTime")_"^"_arrData.GetAt("retUserName")_"^"_arrData.GetAt("qty")_"^"_arrData.GetAt("uomDesc")
	.i retDataStr="" s retDataStr=retData
	.e  s retDataStr=retDataStr_";"_retData
	q retDataStr
}

/// description:药品闭环管理--门诊--撤消退药信息
/// return:		撤消退药日期^撤消退药时间^撤消退药人姓名^数量^单位;...
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetReDrgCancle("4828||16")
ClassMethod GetReDrgCancle(OrdItemId)
{
	s retDataStr=""
	s arcItmId=$p(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),1),"^",2)
	s strucMode=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcItmId)
	i strucMode="Y" d
	.s phcdfId=$p(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1),"^",12)
	.s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	e  d
	.s dispUomId=$p($g(^OEORD(+OrdItemId,"I",+$p(OrdItemId,"||",2),"DHC")),"^",13)
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	.s bUomId=$p(^INCI(incId,1),"^",10)
	s phrId=0
	f  s phrId=$o(^DHCPHRTIi(OrdItemId,"ORDI",phrId)) q:phrId=""  d
	.s phrData=^DHCPHRET(phrId)
	.s cancleRetFlag=$p(phrData, "^",19)
	.q:cancleRetFlag'="Y"		
	.s cRetPerId=$p(phrData,"^",22)
	.s cRetUserId=$p($g(^DHCPHPER(+cRetPerId)),"^",5)
 	.s cRetUserName=$p($g(^SSU("SSUSR",+cRetUserId)),"^",2)
	.s cRetDate=$p(phrData,"^",20)
	.s cRetTime=$p(phrData,"^",21)
	.s cRetDate=..DateLogicalToHtml(cRetDate)
	.s cRetTime=..TimeLogicalToHtml(cRetTime)
	.s qty=0
	.s phrItm=0
	.f  s phrItm=$o(^DHCPHRTIi(OrdItemId,"ORDI",phrId,phrItm)) q:phrItm=""  d
	..s pharItmData=^DHCPHRTI(phrId,"RTI",phrItm)
	..s cRetQty=$p(pharItmData,"^",3)
	..i strucMode="Y" d
	...// 一对多,转换药学基本单位数量
	...s inclb=$p(pharItmData,"^",13)
	...s incBUomId=$p(^INCI(+inclb,1),"^",10)
	...s fac=##class(web.DHCSTINTERFACE).UOMFac(incBUomId,phcUomId)
	...s cRetQty=cRetQty*fac
	..s qty=qty+cRetQty
	.q:qty=0
	.
	.i strucMode="Y" d
	..s uomDesc=$p(^CT("UOM",phcUomId),"^",2)
	.e  d
	..i dispUomId'="" d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..e  d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToOutUomQty(incId,qty)
    ..s qty=$p(qtyUomStr,"^",1)
    ..s uomId=$p(qtyUomStr,"^",2)
    ..s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
    .s retData=cRetDate_"^"_cRetTime_"^"_cRetUserName_"^"_qty_"^"_uomDesc
	.i retDataStr="" s retDataStr=retData
	.e  s retDataStr=retDataStr_";"_retData
	q retDataStr
}

/// description:药品闭环管理--住院--药品信息
/// return:		领药审核^药师审核^发药^申请退药^退费信息
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetDrgByExecId("282||42||1")
ClassMethod GetDrgByExecId(OrdExecId)
{
	s confirmData=..GetNurConfirmByExecId(OrdExecId)
	s pharData=..GetPharAuditByExecId(OrdExecId)
	s dispData=..GetDispByExecId(OrdExecId)
	s reqData=..GetReqByExecId(OrdExecId)
	s retData=..GetRetByExecId(OrdExecId)
	s refuseData=..GetIPRefuseDispInfo(OrdExecId)
	q confirmData_"^"_pharData_"^"_dispData_"^"_reqData_"^"_retData_"^"_refuseData
}

/// description:药品闭环管理--住院--领药审核
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetNurConfirmByExecId("42||295||17")
ClassMethod GetNurConfirmByExecId(OrdExecId)
{
	s dspId=$o(^DHCOEDISQTY(0,"OEORE",OrdExecId,""))
	q:dspId="" ""
	s nurAuditData=""
	s dspData=^DHCOEDISQTY(dspId)
	s conFlag=$p(dspData,"^",17)
	q:conFlag'="Y" ""
	s conUserId=$p(dspData,"^",12)
	s conDate=$p(dspData,"^",18)
	s conTime=$p(dspData,"^",19)
	s conUserName=$p($g(^SSU("SSUSR",+conUserId)),"^",2)
	s conDate=..DateLogicalToHtml(conDate)
	s conTime=..TimeLogicalToHtml(conTime)
	q conUserName_",已审核"_conDate_" "_conTime
}

/// description: 药品闭环管理--住院--药师审核
/// modify:		 2019-01-14,添加审核拒绝原因,MaYuqiang 
/// 			 2019-04-08,增加配液中心配伍审核(配伍可按天,此处仅显示最后一次),yunhaibao
/// 			 GetIPOrdItmAuditInfo,GetIPOrdItmRefuseInfo	时间轴调的这俩
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetPharAuditByExecId("6||47")
ClassMethod GetPharAuditByExecId(OrdExecId)
{
	s retArr=..GetPharAuditArrByExecId(OrdExecId)
	q:retArr.Count()=0 ""
	s retStr=retArr.GetAt("userName")_retArr.GetAt("state")_","_retArr.GetAt("date")_" "_retArr.GetAt("time")
	i retArr.GetAt("auditReasonStr")'="" d
	.s retStr=retStr_",拒绝原因:"_retArr.GetAt("auditReasonStr")
	q retStr
}

/// description:药品闭环管理--住院--发药
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetDispByExecId("34||7||1")
ClassMethod GetDispByExecId(OrdExecId)
{
	s dispArr=..GetDispArrByExecId(OrdExecId)
	q:dispArr.Count()=0 ""
	q dispArr.GetAt("state")_
	  "("_dispArr.GetAt("qty")_dispArr.GetAt("uomDesc")_"),"_
	  dispArr.GetAt("dspDate")_" "_
	  dispArr.GetAt("dspTime")
}

/// description:药品闭环管理--住院--申请退药
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetReqByExecId("")
ClassMethod GetReqByExecId(OrdExecId)
{
	s retList = ..GetReqListByExecId(OrdExecId)
	q:retList.Size=0 ""
	s retDataStr = ""
	f i = 1 : 1 : retList.Size d
	.s arrData = retList.GetAt(i)
	.s retData=arrData.GetAt("userName")_"申请退药("_arrData.GetAt("qty")_arrData.GetAt("uomDesc")_"),"_arrData.GetAt("date")_" "_arrData.GetAt("time")
	.i retDataStr="" s retDataStr=retData
	.e  s retDataStr=retDataStr_";"_retData
	q retDataStr
}

/// description:药品闭环管理--住院--退药
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetRetByExecId("25||26||2")
ClassMethod GetRetByExecId(OrdExecId)
{
	s retList = ..GetRetListByExecId(OrdExecId)
	q:retList.Size=0 ""
	s retDataStr = ""
	f i = 1 : 1 : retList.Size d
	.s arrData = retList.GetAt(i)
	.s retData=arrData.GetAt("retUserName")_"退药("_arrData.GetAt("qty")_arrData.GetAt("uomDesc")_"),"_arrData.GetAt("retDate")_" "_arrData.GetAt("retTime")
	.i retDataStr="" s retDataStr=retData
	.e  s retDataStr=retDataStr_";"_retData
	q retDataStr
}

/// Author : MaYuqiang
/// Date Created : 20190112
/// Description : 药品闭环管理--门诊--药师审核拒绝信息
/// Input : OrdItemId - 医嘱子表id
/// return : 审核日期^时间^药师姓名^拒绝原因
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetOPPrescRefuseInfo("444||3")
ClassMethod GetOPPrescRefuseInfo(OrdItemId)
{
	s pharRefuseDataStr=""
	s phaOrdId=""
	f  s phaOrdId=$o(^DHCPHORDM(0,"OrdItem",OrdItemId,phaOrdId)) q:phaOrdId=""  d
	.q:+phaOrdId=0
	.s phaOrdData=^DHCPHORDM(phaOrdId)
	.q:$p(phaOrdData,"^",2)="D"
	.q:$p(phaOrdData,"^",9)'="OA"
	.s cancelUser=$p(phaOrdData,"^",12)
	.q:cancelUser'=""
	.s status=$p(phaOrdData,"^",2)
	.i status="N" d
	..s auditUserId=$p(phaOrdData,"^",1)
	..s auditDate=$p(phaOrdData,"^",3)
	..s auditTime=$p(phaOrdData,"^",4)
	..s auditDate=..DateLogicalToHtml(auditDate)
	..s auditTime=..TimeLogicalToHtml(auditTime)
	..s auditUserName=$p($g(^SSU("SSUSR",+auditUserId)),"^",2)	
	..s sub="0",auditReasonStr=""
	..f  s sub=$o(^DHCPHORDM(0,"OrdItem",OrdItemId,phaOrdId,sub)) q:sub=""  d
	...s auditReasonDr=$p(^DHCPHORDM(phaOrdId,"I",sub),"^",3)		//拒绝原因id
	...i auditReasonDr'="" d
	....s auditReason=$p($g(^DHCPCREASON(auditReasonDr)),"^",2)
	....i auditReasonStr'="" d
	.....s auditReasonStr=auditReasonStr_","_auditReason
	....e  d
	.....s auditReasonStr=auditReason
	..s pharAuditData=auditDate_"^"_auditTime_"^"_auditUserName_"^"_auditReasonStr
	..i pharRefuseDataStr="" d
	...s pharRefuseDataStr=pharAuditData
	..e  d
	...s pharRefuseDataStr=pharRefuseDataStr_"!"_pharAuditData
	q:pharRefuseDataStr'="" pharRefuseDataStr
	s retArr=..GetPharAuditArrByExecId(OrdItemId_"||1")
	q:retArr.Count()=0 ""
	q:retArr.GetAt("state")'["拒绝" ""
	q retArr.GetAt("date")_"^"_retArr.GetAt("time")_"^"_retArr.GetAt("userName")_"^"_retArr.GetAt("auditReasonStr")
}

/// Author : MaYuqiang
/// Date Created : 20190114
/// Description : 药品闭环管理--门诊--拒绝发药信息
/// Input : OrdItemId - 医嘱子表id
/// return : 拒绝发药日期^拒绝发药时间^拒绝发药人姓名^拒发原因串
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetOPRefuseDispInfo("608||4")
ClassMethod GetOPRefuseDispInfo(OrdItemId)
{
	s pharRefuseDataStr=""
	s phaOrdId=""
	f  s phaOrdId=$o(^DHCPHORDM(0,"OrdItem",OrdItemId,phaOrdId)) q:phaOrdId=""  d
	.q:+phaOrdId=0
	.s phaOrdData=^DHCPHORDM(phaOrdId)
	.q:$p(phaOrdData,"^",2)="D"
	.q:$p(phaOrdData,"^",9)'="OR"
	.s cancelUser=$p(phaOrdData,"^",12)
	.q:(cancelUser'="")
	.s status=$p(phaOrdData,"^",2)
	.i status="N" d
	..s auditUserId=$p(phaOrdData,"^",1)
	..s auditDate=$p(phaOrdData,"^",3)
	..s auditTime=$p(phaOrdData,"^",4)
	..s auditDate=..DateLogicalToHtml(auditDate)
	..s auditTime=..TimeLogicalToHtml(auditTime)
	..s auditUserName=$p($g(^SSU("SSUSR",+auditUserId)),"^",2)	
	..s sub="0",auditReasonStr=""
	..f  s sub=$o(^DHCPHORDM(0,"OrdItem",OrdItemId,phaOrdId,sub)) q:sub=""  d
	...s auditReasonDr=$p(^DHCPHORDM(phaOrdId,"I",sub),"^",3)		//拒绝原因id
	...i auditReasonDr'="" d
	....s auditReason=$p($g(^DHCPCREASON(auditReasonDr)),"^",2)
	....i auditReasonStr'="" d
	.....s auditReasonStr=auditReasonStr_","_auditReason
	....e  d
	.....s auditReasonStr=auditReason
	..s pharAuditData=auditDate_"^"_auditTime_"^"_auditUserName_"^"_auditReasonStr
	..i pharRefuseDataStr="" d
	...s pharRefuseDataStr=pharAuditData
	..e  d
	...s pharRefuseDataStr=pharRefuseDataStr_"!"_pharAuditData
	q:pharRefuseDataStr'="" pharRefuseDataStr
	s dsp=$o(^DHCOEDISQTY(0,"OEORE",OrdItemId_"||1",""))
	q:dsp="" ""
	s stdf=$o(^STDF("DODIS",dsp,""))
	q:stdf="" ""
	s stdfData=$g(^STDF(stdf))
	s refuseDate=$p(stdfData,"^",4)
	s refuseDate=..DateLogicalToHtml(refuseDate)
	s refuseTime=$p(stdfData,"^",5)
	s refuseTime=..TimeLogicalToHtml(refuseTime)
	s refuseUserId=$p(stdfData,"^",6)
	s refuseUserName=$p($g(^SSU("SSUSR",+refuseUserId)),"^",2)	
	s refuseReason=$p(stdfData,"^",7)
	s refuseReasonDesc=$p($g(^DHCRFREASON(+refuseReason)),"^",2)
	q refuseDate_"^"_refuseTime_"^"_refuseUserName_"^"_refuseReasonDesc
}

/// Author : MaYuqiang
/// Date Created : 20190114
/// Description : 药品闭环管理--住院--拒绝发药信息
/// Input : OrdExecId - 执行记录表id
/// return : 拒绝发药日期^拒绝发药时间^拒绝发药人姓名^数量^单位
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetIPRefuseDispInfo("25||100||3")
ClassMethod GetIPRefuseDispInfo(OrdExecId)
{
	s DspId=$o(^DHCOEDISQTY(0,"OEORE",OrdExecId,""))
	q:DspId="" "该执行记录未获取到打包表记录!"
	s StdfId=$o(^STDF("DODIS",DspId,""))
	q:StdfId="" ""
	s StdfData=$g(^STDF(StdfId))
	s RefuseDate=$p(StdfData,"^",4)
	s RefuseDate=..DateLogicalToHtml(RefuseDate)
	s RefuseTime=$p(StdfData,"^",5)
	s RefuseTime=..TimeLogicalToHtml(RefuseTime)
	s RefuseUserId=$p(StdfData,"^",6)
	s RefuseUserName=$p($g(^SSU("SSUSR",+RefuseUserId)),"^",2)	
	s RefuseQty=$p($g(^DHCOEDISQTY(DspId)),"^",5)
	s RefuseUomId=$p($g(^DHCOEDISQTY(DspId)),"^",6)
	s RefuseUomDesc=$p(^CT("UOM",RefuseUomId),"^",2)
	s pharRefuseDataStr=RefuseUserName_"已拒绝发药,"_RefuseDate_" "_RefuseTime_",拒绝数量:"_RefuseQty_RefuseUomDesc
	q pharRefuseDataStr
}

/// Author : MaYuqiang
/// Date Created : 20190113
/// Description : 药品闭环管理--住院--药师审核通过信息
/// Input : OrdItemId - 医嘱子表id
/// return : 审核日期^时间^药师姓名
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetIPOrdItmAuditInfo("307||11")
ClassMethod GetIPOrdItmAuditInfo(OrdItemId)
{
	s pharAuditDataStr=""
	s phaOrdId=""
	f  s phaOrdId=$o(^DHCPHORDM(0,"OrdItem",OrdItemId,phaOrdId)) q:(phaOrdId="")  d
	.q:+phaOrdId=0
	.s phaOrdData=^DHCPHORDM(phaOrdId)
	.s phaAuditType=$p(phaOrdData,"^",9)
	.q:$p(phaOrdData,"^",2)="D"
	.q:(phaAuditType'="IA")&&(phaAuditType'="PIVAS")
	.s cancelUser=$p(phaOrdData,"^",12)
	.q:(cancelUser'="")
	.s status=$p(phaOrdData,"^",2)
	.i status="Y" d
	..s auditUserId=$p(phaOrdData,"^",1)
	..s auditDate=$p(phaOrdData,"^",3)
	..s auditTime=$p(phaOrdData,"^",4)
	..s auditDate=..DateLogicalToHtml(auditDate)
	..s auditTime=..TimeLogicalToHtml(auditTime)
	..s auditUserName=$p($g(^SSU("SSUSR",+auditUserId)),"^",2)	
	..s pharAuditData=auditDate_"^"_auditTime_"^"_auditUserName
	..i pharAuditDataStr="" d
	...s pharAuditDataStr=pharAuditData
	..e  d
	...s pharAuditDataStr=pharAuditDataStr_"!"_pharAuditData
	q pharAuditDataStr
}

/// Author : MaYuqiang
/// Date Created : 20190113
/// Description : 药品闭环管理--住院--药师审核拒绝信息
/// Input : OrdItemId - 医嘱子表id
/// return : 审核日期^时间^药师姓名^拒绝原因
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetIPOrdItmRefuseInfo("307||11")
ClassMethod GetIPOrdItmRefuseInfo(OrdItemId)
{
	s pharRefuseDataStr=""
	s phaOrdId=""
	f  s phaOrdId=$o(^DHCPHORDM(0,"OrdItem",OrdItemId,phaOrdId)) q:(phaOrdId="")  d
	.q:+phaOrdId=0
	.s phaOrdData=^DHCPHORDM(phaOrdId)
	.q:$p(phaOrdData,"^",2)="D"
	.q:($p(phaOrdData,"^",9)'="IA")&&($p(phaOrdData,"^",9)'="PIVAS")
	.s cancelUser=$p(phaOrdData,"^",12)
	.q:(cancelUser'="")
	.s status=$p(phaOrdData,"^",2)
	.i status="N" d
	..s auditUserId=$p(phaOrdData,"^",1)
	..s auditDate=$p(phaOrdData,"^",3)
	..s auditTime=$p(phaOrdData,"^",4)
	..s auditDate=..DateLogicalToHtml(auditDate)
	..s auditTime=..TimeLogicalToHtml(auditTime)
	..s auditUserName=$p($g(^SSU("SSUSR",+auditUserId)),"^",2)	
	..s sub="0",auditReasonStr=""
	..f  s sub=$o(^DHCPHORDM(0,"OrdItem",OrdItemId,phaOrdId,sub)) q:sub=""  d
	...s auditReasonDr=$p(^DHCPHORDM(phaOrdId,"I",sub),"^",3)		//拒绝原因id
	...i auditReasonDr'="" d
	....s auditReason=$p($g(^DHCPCREASON(auditReasonDr)),"^",2)
	....i auditReasonStr'="" d
	.....s auditReasonStr=auditReasonStr_","_auditReason
	....e  d
	.....s auditReasonStr=auditReason
	..s pharAuditData=auditDate_"^"_auditTime_"^"_auditUserName_"^"_auditReasonStr
	..i pharRefuseDataStr="" d
	...s pharRefuseDataStr=pharAuditData
	..e  d
	...s pharRefuseDataStr=pharRefuseDataStr_"!"_pharAuditData
	q pharRefuseDataStr
}

/// Description: 根据执行记录Id获取配液中心全流程记录
/// Return:		 ResultSet
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetPIVASRecords("265||146||4")
ClassMethod GetPIVASRecords(Oeore)
{
	s rs=##class(%ResultSet).%New("web.DHCPHACOM.ComInterface.FaceTimeLine:PIVASRecords")
	d rs.Execute(Oeore)
	q rs
}

/// Description: 根据执行记录Id获取配液中心全流程记录的Query
/// Input:		 Oeore(执行记录Id)
/// w ##class(%ResultSet).RunQuery("web.DHCPHACOM.ComInterface.FaceTimeLine","PIVASRecords","412||34||1")
Query PIVASRecords(Oeore) As websys.Query(ROWSPEC = "psName,dateTime,userName")
{
}

ClassMethod PIVASRecordsExecute(ByRef qHandle As %Binary, Oeore) As %Status
{
	k PIVASRecordsDATA
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:Oeore="" $$$OK
	s dspId=$o(^DHCOEDISQTY(0,"OEORE",Oeore,""))
	q:dspId="" $$$OK
	s pogId=$o(^PIVA(0,"DSP",dspId,""))
	q:pogId="" $$$OK
	s recLocId=$p(^DHCOEDISQTY(dspId),"^",24)
	s admId=$p(^DHCOEDISQTY(dspId),"^",26)
	s admType=$p(^PAADM(admId),"^",2)
	s pivasType=$s(admType="I":"I",1:"O")
	s sub=""
	f  s sub=$o(^PIVA(pogId,"S",sub)) q:sub=""  d
	.q:+sub=0
	.s PIVASDATA=$G(^PIVA(pogId,"S",sub))
	.s psDR=$p(PIVASDATA,"^",2)
	.s psUser=$p(PIVASDATA,"^",3)
	.s psDate=$p(PIVASDATA,"^",4)
 	.s psTime=$P(PIVASDATA,"^",5)
 	.s psNumber=$p($g(^PIVAS(psDR)),"^",1)
	.s psName=$p($g(^PIVAS(psDR)),"^",2)
	.s psUserName=$p($g(^SSU("SSUSR",+psUser)),"^",2)
	.s psDate=..DateLogicalToHtml(psDate)
	.s psTime=..TimeLogicalToHtml(psTime)
	.s psDateTime=psDate_" "_psTime
	.s PIVASRecordsDATA(+psNumber)=psName_"^"_psDateTime_"^"_psUserName
	s psNumber=""
	f  s psNumber=$o(^PIVAS(0,"LOCTYPENUMBER",recLocId,pivasType,psNumber)) q:psNumber=""  d
	.s psId=""
	.f  s psId=$o(^PIVAS(0,"LOCTYPENUMBER",recLocId,pivasType,psNumber,psId)) q:psId=""  d
	..s PIVASDATA=$g(^PIVAS(psId))
	..q:PIVASDATA=""
	..q:($p(PIVASDATA,"^",3)'="Y")||($p(PIVASDATA,"^",5)="Y")
	..s recordData=$g(PIVASRecordsDATA(+psNumber))
	..i recordData="" d
	...s recordData=$p(PIVASDATA,"^",2)_"^^"
	..s ^CacheTemp(repid,ind)=$lfs(recordData,"^")    
	..s ind=ind+1
	q $$$OK
}

/// description: 转日期
ClassMethod DateLogicalToHtml(LogDate)
{
	q ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(LogDate)
}

/// description: 转时间
ClassMethod TimeLogicalToHtml(LogTime)
{
	q ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(LogTime)
}

/// description:药品闭环管理--住院--发药--获取数据
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetDispArrByExecId("34||7||1")
ClassMethod GetDispArrByExecId(OrdExecId) As %ArrayOfDataTypes
{
	s retArr=##class(%ArrayOfDataTypes).%New()
	s dspId=$o(^DHCOEDISQTY(0,"OEORE",OrdExecId,""))
	q:dspId="" retArr
	s dspData=^DHCOEDISQTY(dspId)
	q:$p(dspData,"^",7)'="C" retArr
	s qty=$p(dspData,"^",5)
	s arcItmId=$p(^OEORD(+OrdExecId,"I",+$p(OrdExecId,"||",2),1),"^",2)
	s strucMode=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcItmId)
	i strucMode="Y" d
	.s phcdfId=$p(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1),"^",12)
	.s uomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	e  d
	./* 住院尚未涉及发药单位,暂不转换 */
	.s dispUomId="" //$p($g(^OEORD(+OrdExecId,"I",+$p(OrdExecId,"||",2),"DHC")),"^",13)
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	.s bUomId=$p(^INCI(incId,1),"^",10)
	.i dispUomId'="" d
	..s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	.e  d
	..s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToInUomQty(incId,qty)
    .s qty=$p(qtyUomStr,"^",1)
    .s uomId=$p(qtyUomStr,"^",2)
    i (qty<1)&&(qty[".")&&($p(qty,".",1)="") s qty=0_qty
	s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2)
	s dspDate=$p(dspData,"^",8)
	s dspTime=$p(dspData,"^",9)
	s dspUserId=$p(dspData,"^",10)
	s dspUserName=$p($g(^SSU("SSUSR",+dspUserId)),"^",2)
	s dspDate=..DateLogicalToHtml(dspDate)
	s dspTime=..TimeLogicalToHtml(dspTime)
	d retArr.SetAt("已发药","state")
	d retArr.SetAt(qty,"qty")
	d retArr.SetAt(uomDesc,"uomDesc")
	d retArr.SetAt(dspDate,"dspDate")
	d retArr.SetAt(dspTime,"dspTime")
	d retArr.SetAt(dspUserName,"dspUserName")
	q retArr
}

/// description:药品闭环管理--住院--退药--获取数据
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetRetListByExecId("530||685||1")
ClassMethod GetRetListByExecId(OrdExecId) As %ListOfObjects
{
	s retList=##class(%ListOfObjects).%New()
	k GetRetByExecIdData
	s dspId=$o(^DHCOEDISQTY(0,"OEORE",OrdExecId,""))
	q:dspId="" retList
	s retDataStr=""
	s dspData=^DHCOEDISQTY(dspId)
	q:$p(dspData,"^",7)'="C" retList	
	s arcItmId=$p(^OEORD(+OrdExecId,"I",+$p(OrdExecId,"||",2),1),"^",2)
	s prescNo = $p(^OEORD(+OrdExecId,"I",+$p(OrdExecId,"||",2),1), "^", 14)
	s queId = +##class(PHA.COM.Order).PrescCYQueId(prescNo)
	s strucMode=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcItmId)
	i strucMode="Y" d
	.s phcdfId=$p(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1),"^",12)
	.s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	e  d
	.s dispUomId="" //$p($g(^OEORD(+OrdExecId,"I",+$p(OrdExecId,"||",2),"DHC")),"^",13)
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))
	
	
	s dspId=""
	f  s dspId=$o(^DHCOEDISQTY(0,"OEORE",OrdExecId,dspId)) q:dspId=""  d
	.q:$p(^DHCOEDISQTY(dspId),"^",7)'="R"
	.s dspSub=0
	.f  s dspSub=$o(^DHCOEDISQTY(dspId,"I",dspSub)) q:dspSub=""  d
	..s dspSubId=dspId_"||"_dspSub
	..i (queId = 0) d
	...s retId=0
	...f  s retId=$o(^PHARETi("DSPB",dspSubId,retId)) q:retId=""  d
	....s qty=0
	....s retItm=0
	....f  s retItm=$o(^PHARETi("DSPB",dspSubId,retId,retItm)) q:retItm=""  d
	.....s retItmLb=0
	.....f  s retItmLb=$o(^PHARETi("DSPB",dspSubId,retId,retItm,retItmLb)) q:retItmLb=""  d
	......s retItmLbData=^PHARET(retId,"I",retItm,"B",retItmLb)
	......s retQty=$p(retItmLbData,"^",2)
	......i strucMode="Y" d
	.......s inclb=$p(retItmLbData,"^",1)
	.......s incBUomId=$p(^INCI(+inclb,1),"^",10)
	.......s fac=##class(web.DHCSTINTERFACE).UOMFac(incBUomId,phcUomId)
	.......s retQty=retQty*fac
	......s qty=qty+retQty
	....q:qty=0
	....i '$d(GetRetByExecIdData(retId)) d
	.....s GetRetByExecIdData(retId)=qty
	....e  d
	.....s GetRetByExecIdData(retId)=qty+GetRetByExecIdData(retId)
	..e  d
	...s retId = ""
	...f  s retId = $o(^BS.PHA.HERB.RETURNI("DSPB", dspSubId, retId)) q:(retId = "")  d
	....s qty = 0
	....s retItm = 0
	....f  s retItm = $o(^BS.PHA.HERB.RETURNI("DSPB", dspSubId, retId, retItm)) q:(retItm = "")  d
	.....s retItmData = $g(^BS.PHA.HERB.RETURND(retId, "I", retItm))
	.....q:(retItmData = "")
	.....s retQty = $lg(retItmData, 3)
	.....i strucMode="Y" d
	......s inclb = $lg(retItmData, 4)
	......s incBUomId = $p(^INCI(+inclb,1),"^",10)
	......s fac = ##class(web.DHCSTINTERFACE).UOMFac(incBUomId,phcUomId)
	......s retQty = retQty*fac
	.....s qty = qty + retQty
	....q:qty=0
	....i '$d(GetRetByExecIdData(retId)) d
	.....s GetRetByExecIdData(retId)=qty
	....e  d
	.....s GetRetByExecIdData(retId)=qty+GetRetByExecIdData(retId)
	...
	q:'$d(GetRetByExecIdData) retList
	s retId=""
	f  s retId=$o(GetRetByExecIdData(retId)) q:retId=""  d
	.s qty=GetRetByExecIdData(retId)
	.i strucMode="Y" d
	..s uomId=phcUomId
	.e  d
	..i dispUomId'="" d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	..e  d
	...s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToInUomQty(incId,qty)
    ..s qty=$p(qtyUomStr,"^",1)
    ..s uomId=$p(qtyUomStr,"^",2)
    .s uomDesc=$p($g(^CT("UOM",+uomId)),"^",2) 
	.i (qty<1)&&(qty[".")&&($p(qty,".",1)="") s qty=0_qty
	.i (queId = 0) d
	..s phRetData=^PHARET(retId)
	..s retDate=$p(phRetData,"^",1)
	..s retTime=$p(phRetData,"^",2)
	..s retUserId=$p(phRetData,"^",3)
	.e  d
	..s herbRetData = $g(^BS.PHA.HERB.RETURND(retId))
	..s retDate = $lg(herbRetData, 2)
	..s retTime = $lg(herbRetData, 3)
	..s retUserId = $lg(herbRetData, 4)
 	.s retUserName=$p($g(^SSU("SSUSR",+retUserId)),"^",2)
	.s retDate=..DateLogicalToHtml(retDate)
	.s retTime=..TimeLogicalToHtml(retTime)
	.s retArr=##class(%ArrayOfDataTypes).%New()
	.d retArr.SetAt("退药","state")
	.d retArr.SetAt(qty,"qty")
	.d retArr.SetAt(uomDesc,"uomDesc")
	.d retArr.SetAt(retDate,"retDate")
	.d retArr.SetAt(retTime,"retTime")
	.d retArr.SetAt(retUserName,"retUserName")
	.d retList.Insert(retArr)
	q retList
}

/// description:药品闭环管理--住院--药师审核--获取数据
ClassMethod GetPharAuditArrByExecId(OrdExecId) As %ArrayOfDataTypes
{
	s retArr=##class(%ArrayOfDataTypes).%New()
	s oeori=$p(OrdExecId,"||",1,2)
	q:oeori="" retArr
	s mOeori=##class(web.DHCSTCOMMONORDER).GetMainOeori(oeori)
	s existFlag=""
	s phaOrdId=""
	f  s phaOrdId=$o(^DHCPHORDM(0,"OrdItem",mOeori,phaOrdId),-1) q:(phaOrdId="")||(existFlag'="")  d
	.q:+phaOrdId=0
	.s phaOrdData=^DHCPHORDM(phaOrdId)
	.q:$p(phaOrdData,"^",2)="D"
	.q:($p(phaOrdData,"^",9)'="IA")&&($p(phaOrdData,"^",9)'="PIVAS")
	.s cancelUser=$p(phaOrdData,"^",12)
	.q:(cancelUser'="")
	.s status=$p(phaOrdData,"^",2)
	.s auditUserId=$p(phaOrdData,"^",1)
	.s auditDate=$p(phaOrdData,"^",3)
	.s auditTime=$p(phaOrdData,"^",4)
	.s auditDate=..DateLogicalToHtml(auditDate)
	.s auditTime=..TimeLogicalToHtml(auditTime)
	.s auditUserName=$p($g(^SSU("SSUSR",+auditUserId)),"^",2)
	.s auditReasonStr=""
	.d retArr.SetAt("","state")
	.d retArr.SetAt("","auditReasonStr")
	.d retArr.SetAt(auditUserName,"userName")
	.d retArr.SetAt(auditDate,"date")
	.d retArr.SetAt(auditTime,"time")
	.
	.i status="Y" d	
	..d retArr.SetAt("已审核","state")
	.e  i status="N" d
	..s sub="0",auditReasonStr=""
	..f  s sub=$o(^DHCPHORDM(0,"OrdItem",mOeori,phaOrdId,sub)) q:sub=""  d
	...s auditReasonDr=$p(^DHCPHORDM(phaOrdId,"I",sub),"^",3)		//拒绝原因id
	...i auditReasonDr'="" d
	....s auditReason=$p($g(^DHCPCREASON(auditReasonDr)),"^",2)
	....i auditReasonStr'="" d
	.....s auditReasonStr=auditReasonStr_","_auditReason
	....e  d
	.....s auditReasonStr=auditReason
	..d retArr.SetAt("已拒绝","state")
	..d retArr.SetAt("auditReasonStr","auditReasonStr")
	.s existFlag="Y"
	q retArr
}

/// description:药品闭环管理--住院--申请退药--获取数据
/// w ##class(web.DHCPHACOM.ComInterface.FaceTimeLine).GetReqByExecId("530||685||1")
ClassMethod GetReqListByExecId(OrdExecId) As %ListOfObjects
{
	s retList=##class(%ListOfObjects).%New()
	s dspId=$o(^DHCOEDISQTY(0,"OEORE",OrdExecId,""))
	q:dspId="" retList
	s prescNo = $p(^OEORD(+OrdExecId,"I",+$p(OrdExecId,"||",2),1),"^",14)
	s queId = +##class(PHA.COM.Order).PrescCYQueId(prescNo)
	q:('$d(^RETRQ(0,"DODIS",dspId))&&(queId = 0)) retList
	q:('$d(^BS.PHA.HERB.RETREQUESTI("DODIS",dspId))&&(queId '= 0)) retList
	s reqDataStr=""
	s dspData=^DHCOEDISQTY(dspId)
	q:$p(dspData,"^",7)'="C" ""	
	s arcItmId=$p(^OEORD(+OrdExecId,"I",+$p(OrdExecId,"||",2),1),"^",2)
	s strucMode=##class(web.DHCSTINTERFACE).GetStruModeFlag(arcItmId)
	i strucMode="Y" d
	.s phcdfId=$p(^ARCIM(+arcItmId,+$p(arcItmId,"||",2),1),"^",12)
	.s phcUomId=$p(^PHCD(+phcdfId,"DF",+$p(phcdfId,"||",2),2),"^",4)
	e  d
	.s dispUomId="" //$p($g(^OEORD(+OrdExecId,"I",+$p(OrdExecId,"||",2),"DHC")),"^",13)
	.s incId=$o(^INCI(0,"ARCIM_DR",+arcItmId,""))

	i (queId = 0) d
	.s reqId=0
	.f  s reqId=$o(^RETRQ(0,"DODIS",dspId,reqId)) q:reqId=""  d
	..s retReqData=^RETRQ(reqId)
	..s reqUserId=$p(retReqData,"^",15)
	..s reqDate=$p(retReqData,"^",16)
	..s reqTime=$p(retReqData,"^",17)
	..s qty=0
	..s reqItm=0
	..f  s reqItm=$o(^RETRQ(0,"DODIS",dspId,reqId,reqItm)) q:reqItm=""  d
	...s retReqItmData=^RETRQ(reqId,"I",reqItm)
	...s reqQty=$p(retReqItmData,"^",3)
	...i strucMode="Y" d
	....s inclb=$p(retReqItmData,"^",16)
	....s incBUomId=$p(^INCI(+inclb,1),"^",10)
	....s fac=##class(web.DHCSTINTERFACE).UOMFac(incBUomId,phcUomId)
	....s reqQty=reqQty*fac
	...s qty=qty+reqQty
	..q:qty=0
	..i strucMode="Y" d
	...s uomId=phcUomId
	..e  d
	...i dispUomId'="" d
	....s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId,qty,dispUomId)
	...e  d
	....s qtyUomStr=##class(web.DHCSTCOMMONSRV).BQtyToInUomQty(incId,qty)
    ...s qty=$p(qtyUomStr,"^",1)
    ...s uomId=$p(qtyUomStr,"^",2)
    ..d FormateData
	e  d
	.s reqId = 0
	.f  s reqId = $o(^BS.PHA.HERB.RETREQUESTI("DODIS", dspId, reqId)) q:reqId=""  d
	..s retReqData = $g(^BS.PHA.HERB.RETREQUESTD(reqId))
	..q:(retReqData = "")
	..s reqUserId = $lg(retReqData, 4)
	..s reqDate = $lg(retReqData, 2)
	..s reqTime = $lg(retReqData, 3)
	..s qty = 0
	..s reqItm = 0
	..f  s reqItm = $o(^BS.PHA.HERB.RETREQUESTI("DODIS", dspId, reqId, reqItm)) q:reqItm=""  d
	...s retReqItmData = $g(^BS.PHA.HERB.RETREQUESTD(reqId,"I",reqItm))
	...q:(retReqItmData = "")
	...s reqQty = $lg(retReqItmData, 2)
	...i strucMode="Y" d
	....s inclb = $lg(retReqItmData, 11)
	....s incBUomId = $p(^INCI(+inclb,1),"^",10)
	....s fac = ##class(web.DHCSTINTERFACE).UOMFac(incBUomId, phcUomId)
	....s reqQty = reqQty*fac
	...s qty = qty+reqQty
	..q:(qty = 0)
	..i strucMode="Y" d
	...s uomId = phcUomId
	..e  d
	...i (dispUomId '= "") d
	....s qtyUomStr = ##class(web.DHCSTCOMMONSRV).BQtyToPhaUomQty(incId, qty, dispUomId)
	...e  d
	....s qtyUomStr = ##class(web.DHCSTCOMMONSRV).BQtyToInUomQty(incId, qty)
    ...s qty = $p(qtyUomStr, "^", 1)
    ...s uomId = $p(qtyUomStr, "^", 2)
    ..d FormateData
	q retList

FormateData
	s uomDesc = $p($g(^CT("UOM", +uomId)), "^", 2) 
	s qty = $fn(qty, "N")
	s reqUserName = $p($g(^SSU("SSUSR",+reqUserId)),"^",2)
	s reqDate=..DateLogicalToHtml(reqDate)
	s reqTime=..TimeLogicalToHtml(reqTime)
	s retArr=##class(%ArrayOfDataTypes).%New()
	d retArr.SetAt(reqUserName,"userName")
	d retArr.SetAt(reqDate,"date")
	d retArr.SetAt(reqTime,"time")
	d retArr.SetAt(qty,"qty")
	d retArr.SetAt(uomDesc,"uomDesc")
	d retList.Insert(retArr)
	q ""
}

}
