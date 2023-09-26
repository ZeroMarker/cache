Import sqluser

/// creator: 	yunhaibao
/// createdate:	2018-06-19
/// description:退药申请单查询
Class web.DHCINPHA.QueryRetReq Extends %RegisteredObject
{

/// description: 申请单列表
/// w ##class(%ResultSet).RunQuery("web.DHCINPHA.QueryRetReq","QueryRequest","2018-01-12^2018-07-12^10^98^A^^^^")
Query QueryRequest(inputStr = "") As websys.Query(ROWSPEC = "reqId,reqNo,reqDate,wardDesc,reqUserName,reqStatus,patInfo,refundStatus,reqTime,patName,hasRefuse")
{
}

ClassMethod QueryRequestExecute(ByRef qHandle As %Binary, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:inputStr="" $$$OK
	s StDate=$p(inputStr,"^",1)
	s EdDate=$p(inputStr,"^",2)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate) 
	s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
	s WardId=$p(inputStr,"^",3)
	s RecLocId=$p(inputStr,"^",4)
	s RequestStatus=$p(inputStr,"^",5)
	s PatNo=$p(inputStr,"^",6)
	s DocFlag=$p(inputStr,"^",7)
	s IncId=$p(inputStr,"^",8)
	s AdvRefundFlag=$p(inputStr,"^",9)
	s HospId=$p(inputStr,"^",10)
	s HasRefuseFlag=$p(inputStr,"^",11)
    s AdmIdStr=$p(inputStr,"^",12)
    #; 按登记号查询, 就诊ID则无用
    i PatNo'="" s AdmIdStr="" 
    s AdmIdList = $lfs(AdmIdStr)
    s trans("退药完成") = ##class(PHA.IP.COM.Base).Translate("退药完成")  // @translate
    s trans("退费完成") = ##class(PHA.IP.COM.Base).Translate("退费完成")  // @translate
    s trans("部分退药") = ##class(PHA.IP.COM.Base).Translate("部分退药")  // @translate
    s trans("部分退费") = ##class(PHA.IP.COM.Base).Translate("部分退费")  // @translate
    s trans("尚未退药") = ##class(PHA.IP.COM.Base).Translate("尚未退药")  // @translate
    s trans("尚未退费") = ##class(PHA.IP.COM.Base).Translate("尚未退费")  // @translate
	i +$p($g(^PAWARD(+WardId)),"^",5)>0 s WardLocId=$p($g(^PAWARD(+WardId)),"^",5)
	e  s WardLocId=WardId
	s stat="P"
	s recLocId=""
	f  s recLocId=$o(^RETRQ(0,"RECLOC",recLocId)) q:recLocId=""  d
	.q:+recLocId=0
	.q:(RecLocId'="")&&(RecLocId'=recLocId)
	.q:(HospId'="")&&(HospId'=$p(^CTLOC(recLocId),"^",22))
	.s calcuDate=""
	.f calcuDate=StDate:1:EdDate  d
	..s reqId=""
	..f  s reqId=$o(^RETRQ(0,"RECLOC",recLocId,calcuDate,reqId))  q:reqId=""  d
	...s reqData=$g(^RETRQ(reqId))
    ...s admId=$p(reqData,"^",5)
    ...q:(AdmIdList'="")&&($lf(AdmIdList,admId)=0)
    ...s reqLocId=$p(reqData,"^",7)
	...s wardLocId=$p(reqData,"^",21)
	...s patId=$p(reqData,"^",3)
	...s patNo=$p(^PAPER(patId,"PAT",1),"^",1)
	...q:(PatNo'="")&(PatNo'=patNo)
	...s patName=$p(^PAPER(patId,"ALL"),"^",1)
	...q:(WardLocId'="")&(WardLocId'=reqLocId)    	// 按申请科室过滤
	...s wardDesc=##class(PHA.COM.Data.Base).LocDesc(reqLocId)	// 特殊科室或者病区
	...s reqStatus=$p(reqData,"^",14)
	...s reqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(calcuDate)
	...s reqTime=$p(reqData,"^",17)
	...s reqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(reqTime)
	...s reqNo=$p(reqData,"^",1)
	...s reqUserId=$p(reqData,"^",15)
	...s reqUserName=##class(PHA.COM.Data.Base).UserName(reqUserId)
	...s reqRetStatus=..GetReqRetStatus(reqId) ;过滤已退申请单
	...q:(IncId'="")&&(..CheckReqInci(reqId,IncId)=0)
	...i RequestStatus=stat q:reqRetStatus=0
	...i reqRetStatus=0 s reqStatus=trans("退药完成")
	...e  i reqRetStatus=1 s reqStatus=trans("部分退药")
	...e  i reqRetStatus=2 s reqStatus=trans("尚未退药")
	...e  s reqStatus=trans("尚未退药")
	...s bedId=$p(reqData,"^",8)
	...
	...s bedNo="*"
 	...i bedId'="" d
 	....s montherAdmId=$p(^PAADM(admId),"^",75)
 	....i montherAdmId="" s bedNo=$p($g(^PAWARD(+bedId,"BED",+$p(bedId,"||",2))),"^",1)
 	....e  s bedNo=##class(web.DHCSTCOMMONORDER).GetAdmTransBed(admId,bedId)
 	...e  s bedNo="*"
	...s patInfo=patNo_"("_bedNo_")"
	...s refundStatus=..GetReqRefundStatus(reqId)
	...i refundStatus=0 s refundStatus=trans("尚未退费")
	...e  i refundStatus=1 s refundStatus=trans("退费完成")
	...e  i refundStatus=2 s refundStatus=trans("部分退费")
	...e  s refundStatus=trans("尚未退费")
	...q:(AdvRefundFlag="Y")&&(reqStatus=trans("退药完成"))
	...q:(AdvRefundFlag="Y")&&(refundStatus=trans("尚未退费"))
	...s hasRefuse = ##class(web.DHCSTPHARETURN2).IsReqHasStatus(reqId,"Refuse")
	...q:(HasRefuseFlag="Y")&&(hasRefuse'="Y")
	...s data1=reqId_"^"_reqNo_"^"_reqDate_"^"_wardDesc_"^"_reqUserName
	...s data2=reqStatus_"^"_patInfo_"^"_refundStatus_"^"_reqTime_"^"_patName
	...s data3=hasRefuse
	...s data=data1_"^"_data2_"^"_data3
	...s QueryRequestData(reqNo,reqId)=data
	s sortIndex=""
	f  s sortIndex=$o(QueryRequestData(sortIndex)) q:sortIndex=""  d
	.s reqId=""
	.f  s reqId=$o(QueryRequestData(sortIndex,reqId)) q:reqId=""  d
	..q:+reqId=0
	..s reqData=$g(QueryRequestData(sortIndex,reqId))
	..s ^CacheTemp(repid,ind)=$lfs(reqData,"^")    
	..s ind=ind+1
	q $$$OK
}

/// description: 申请单明细
/// w ##class(%ResultSet).RunQuery("web.DHCINPHA.QueryRetReq","QueryReqItm","140","")
Query QueryReqItm(reqIdStr, inputStr = "") As websys.Query(ROWSPEC = "patNo,admId,doctorName,deptLocDesc,bedNo,dspQty,prescNo,reqQty,sp,spAmt,reqUserName,reqDate,reqTime,incCode,incDesc,oeori,admLocDesc,recLocDesc,reqItmRowId,bUomDesc,patName,reqStatus,refundStatus,reasonDesc,retedQty,surQty,manfDesc,reqNo,encryptLevel,patLevel,cyFlag,needGrpRet,mDspId,refuseData,doseDateTime,oeori,priority") [ SqlProc ]
{
}

ClassMethod QueryReqItmExecute(ByRef qHandle As %Binary, reqIdStr, inputStr = "") As %Status
{
	s repid=$I(^CacheTemp)
	s qHandle=$lb(0,repid,0)
	s ind=1
	q:reqIdStr="" $$$OK
	s StDate=$p(inputStr,"^",1)
	s EdDate=$p(inputStr,"^",2)
	s StDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(StDate) 
	s EdDate=##class(web.DHCSTInterfaceFromElse).DateHtmlToLogical(EdDate)
	s WardId=$p(inputStr,"^",3)
	s RecLocId=$p(inputStr,"^",4)
	s RequestStatus=$p(inputStr,"^",5)
	s PatNo=$p(inputStr,"^",6)
	s DocFlag=$p(inputStr,"^",7)
	s IncId=$p(inputStr,"^",8)
	s AdvRefundFlag=$p(inputStr,"^",9)
	s EncryptFlag=##Class(web.DHCSTCOMMPARA).GetEncryptLevelFlag("")
	s stat="P"
	s recordCnt=0
    s trans("退费完成") = ##class(PHA.IP.COM.Base).Translate("退费完成") // @translate
    s trans("尚未退费") = ##class(PHA.IP.COM.Base).Translate("尚未退费") // @translate
    s trans("部分退费") = ##class(PHA.IP.COM.Base).Translate("部分退费") // @translate
    s trans("退费完成") = ##class(PHA.IP.COM.Base).Translate("退费完成") // @translate
    s trans("退药完成") = ##class(PHA.IP.COM.Base).Translate("退药完成") // @translate
    s trans("尚未退药") = ##class(PHA.IP.COM.Base).Translate("尚未退药") // @translate
    s trans("部分退药") = ##class(PHA.IP.COM.Base).Translate("部分退药") // @translate
    s trans("拒绝退药") = ##class(PHA.IP.COM.Base).Translate("拒绝退药") // @translate
	s reqLen=$l(reqIdStr,",")
	s reqI=0
	f reqI=1:1:reqLen d
	.s reqId=$p(reqIdStr,",",reqI)
	.q:+reqId=0
	.q:'$d(^RETRQ(reqId))
	.s reqNo=$p(^RETRQ(reqId),"^",1)
 	.s wardLocId=$p(^RETRQ(reqId),"^",21)
 	.s wardLocDesc=$p(^CTLOC(wardLocId),"^",2)
 	.s patId=$p(^RETRQ(reqId),"^",3)
 	.s patNo=$p(^PAPER(patId,"PAT",1),"^",1)
 	.q:(PatNo'="")&&(patNo'=PatNo)
 	.s patName=$p(^PAPER(patId,"ALL"),"^",1)
 	.s admId=$p(^RETRQ(reqId),"^",5)
 	.s admNo=$p(^PAADM(admId),"^",81)
 	.s admLocId=$p(^PAADM(admId),"^",4)
 	.s admLocDesc=$p($g(^CTLOC(+admLocId)),"^",2)
 	.s bedId=$p(^RETRQ(reqId),"^",8)
 	.s bedNo="*"
 	.i bedId'="" d
 	..s montherAdmId=$p(^PAADM(admId),"^",75)
 	..i montherAdmId="" s bedNo=$p($g(^PAWARD(+bedId,"BED",+$p(bedId,"||",2))),"^",1)
 	..e  s bedNo=##class(web.DHCSTCOMMONORDER).GetAdmTransBed(admId,bedId)
 	.e  s bedNo="*"
 	.s recLocId=$p(^RETRQ(reqId),"^",2)
 	.s recLocDesc=##class(PHA.COM.Data.Base).LocDesc(recLocId)
 	.s docCpId=$p(^RETRQ(reqId),"^",6)
 	.s doctorName=##class(PHA.COM.Data.Base).CareProvDesc(docCpId)
 	.s deptLocId=$p(^RETRQ(reqId),"^",7)
 	.s deptLocDesc=##class(PHA.COM.Data.Base).LocDesc(+deptLocId)
 	.s (patLevel,encryptLevel)=""
    .i EncryptFlag=1 d
	..s encryptLevelInfo=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(patId,"")
    ..s encryptLevel=$p(encryptLevelInfo,"^",1)
    ..s patLevel=$p(encryptLevelInfo,"^",2)
	.s reqItm=""
	.f  s reqItm=$o(^RETRQ(reqId,"I",reqItm)) q:reqItm=""  d
	..q:+reqItm=0
	..s reqItmRowId=reqId_"||"_reqItm
 	..s reqItmData=^RETRQ(reqId,"I",reqItm)
 	..s reqStatus=$p(reqItmData,"^",10)
 	..s oeori=$p(reqItmData,"^",1)
 	..s inclb=$p(reqItmData,"^",16)
 	..s dspSubId=$p(reqItmData,"^",14)
 	..s phacItmLbId=$p(reqItmData,"^",15)
 	..s ordId=+oeori
 	..s ordItm=+$p(oeori,"||",2)
 	..s doseDate=$p(reqItmData,"^",2)
 	..s reqQty=$p(reqItmData,"^",3)	//申请数量
 	..s sp=$p(reqItmData,"^",4)
 	..s spAmt=$p(reqItmData,"^",5)
 	..s reasonId=$p(reqItmData,"^",6)
 	..s reasonDesc=##class(PHA.COM.Data.Base).RefundReasonDesc(reasonId)
 	..s reqDate=$p(reqItmData,"^",7)
 	..s reqTime=$p(reqItmData,"^",8)
 	..s reqDate=##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml(reqDate,"IP")
 	..s reqTime=##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml(reqTime,"IP")
 	..s reqUserId=$p(reqItmData,"^",9)
 	..s reqUserName=##class(PHA.COM.Data.Base).UserName(reqUserId)
 	..s dspId=$p(reqItmData,"^",11)
 	..s mDspId=##class(web.DHCSTCOMMONORDER).GetMainDspId(dspId)
 	..s prescNo=$p(^OEORD(ordId,"I",ordItm,1),"^",14)
 	..s queid=##class(PHA.COM.Order).PrescCYQueId(prescNo)
 	..s cyFlag=$s(queid '= "" : "Y",1:"")
	..s pivasFlag=$p($g(^OEORD(ordId,"I",ordItm,"DHC")),"^",16)
	..s needGrpRet=""
	..i (cyFlag="Y")||(pivasFlag="Y") s needGrpRet="Y"	// 成组退
 	..s incId=+inclb
 	..q:(IncId'="")&&(needGrpRet="")&&(incId'=IncId)
	..q:(IncId'="")&&(cyFlag="Y")&&(..CheckReqItmInciGroup(reqId,IncId,prescNo,"")=0)  //add by zouxiang 20220524
	..q:(IncId'="")&&(pivasFlag="Y")&&(..CheckReqItmInciGroup(reqId,IncId,"",mDspId)=0)  //add by zouxiang 20220524
 	..s incDesc=##class(PHA.COM.Data.Base).InciDesc(incId)
 	..s incCode=$p(^INCI(incId,1),"^",1)
 	..s bUomId=$p(^INCI(incId,1),"^",10)
 	..i bUomId'="" s bUomDesc=##class(PHA.COM.Data.Base).UomDesc(bUomId)
 	..e  s bUomDesc=""
	..s geneName=$lg(##class(PHA.COM.Drug).GetGeneric(incId), 3)
 	..s spec=##class(PHA.COM.Drug).GetSpec(incId)
 	..s manfDesc=$lg(##class(PHA.COM.Drug).GetManf(incId), 3)
 	..s retedQty=+##class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(reqId_"||"_reqItm)  ;已退数量(本条申请明细的)
 	..s surQty=reqQty-retedQty        						// 未退数量
 	..s dspQty=$p($g(^DHCPHAC(+phacItmLbId,"I",+$p(phacItmLbId,"||",2),"B",+$p(phacItmLbId,"||",3))),"^",2) // 发药数量,子表记录了发药孙表Id
 	..s refundStatus=$p(reqItmData,"^",12)
 	..i refundStatus="1" s refundStatus=$g(trans("退费完成"))
 	..e  d
 	...i surQty=reqQty s refundStatus=$g(trans("尚未退费"))
 	...i (retedQty'=0)&(surQty>0)  s refundStatus=$g(trans("部分退费"  ))
 	...i surQty'>0 s refundStatus=$g(trans("退费完成"))
 	..i surQty<=0 s reqStatus=$g(trans("退药完成"))
 	..e  i surQty=reqQty s reqStatus=$g(trans("尚未退药"))
 	..e  s reqStatus=$g(trans("部分退药"))
 	..i $p(reqItmData,"^",10)="Refuse" s reqStatus=$g(trans("拒绝退药"))
 	..s sp=$fn(sp,"",$l($p(sp,".",2)))
 	..s spAmt=$fn(spAmt,"N")
 	..s reqQty=$fn(reqQty,"N")
 	..s surQty=$fn(surQty,"N")
 	..s dspQty=$fn(dspQty,"N")
 	..s retedQty=$fn(retedQty,"N")
 	..s refuseData=##class(web.DHCINPHA.Request).GetRefuseData(reqItmRowId)
 	..s dspData = $g(^DHCOEDISQTY(dspId))
 	..s doseDateHtml = ##class(web.DHCSTInterfaceFromElse).DateLogicalToHtml($p(dspData, "^", 21))
 	..s doseTimeHtml = ##class(web.DHCSTInterfaceFromElse).TimeLogicalToHtml($p(dspData, "^", 20))
 	..s doseDateTime = doseDateHtml _ " " _ doseTimeHtml
 	..s priority = $p(##class(PHA.COM.Order).OeoriPriority(oeori), "^", 3)
 	..s data1=patNo_"^"_admId_"^"_doctorName_"^"_deptLocDesc_"^"_bedNo
 	..s data2=dspQty_"^"_prescNo_"^"_reqQty_"^"_sp_"^"_spAmt
 	..s data3=reqUserName_"^"_reqDate_"^"_reqTime_"^"_incCode_"^"_incDesc
 	..s data4=oeori_"^"_admLocDesc_"^"_recLocDesc_"^"_reqItmRowId_"^"_bUomDesc
 	..s data5=patName_"^"_reqStatus_"^"_refundStatus_"^"_reasonDesc_"^"_retedQty
 	..s data6=surQty_"^"_manfDesc_"^"_reqNo_"^"_encryptLevel_"^"_patLevel
 	..s data7=cyFlag_"^"_needGrpRet_"^"_mDspId_"^"_refuseData_"^"_doseDateTime
 	..s data8=oeori_"^"_priority
 	..s data=data1_"^"_data2_"^"_data3_"^"_data4_"^"_data5_"^"_data6_"^"_data7_"^"_data8
 	..s recordCnt=recordCnt+1
 	..s QueryReqItmData(recordCnt)=data
	s recordCnt=""
	f  s recordCnt=$o(QueryReqItmData(recordCnt)) q:recordCnt=""  d
	.s reqItmData=$g(QueryReqItmData(recordCnt))
	.s ^CacheTemp(repid,ind)=$lfs(reqItmData,"^")    
	.s ind=ind+1
	q $$$OK
}

/// description: 判断申请单是否已经退药完成
/// return:	  	 0:已执行退药完毕 ,1:部分退药,2:未退
/// w ##class(web.DHCINPHA.QueryRetReq).GetReqRetStatus(34)
ClassMethod GetReqRetStatus(reqId)
{
	q:reqId="" 0
	s retReqStatus=2 // 默认未退
	s reqItmCnt=0
	s retItmCnt=0	 // 全退记录数
	s reqItm=""
	f  s reqItm=$o(^RETRQ(reqId,"I",reqItm)) q:(reqItm="")!(retReqStatus=1)  d
	.s reqItmStatus=$p(^RETRQ(reqId,"I",reqItm),"^",10)
	.s reqItmCnt=reqItmCnt+1
	.s reqQty=$p(^RETRQ(reqId,"I",reqItm),"^",3)
	.s retedQty=+##class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(reqId_"||"_reqItm)
	.i (+reqQty>+retedQty)&&(+retedQty>0) s retReqStatus=1
	.i +retedQty>=+reqQty s retItmCnt=retItmCnt+1
	i reqItmCnt=retItmCnt s retReqStatus=0
	e  i retItmCnt>0 s retReqStatus=1
	q retReqStatus
}

/// description: 判断申请单退费状态
/// return:	  	 1:全退,2:部分退,0:未退
/// w ##class(web.DHCINPHA.QueryRetReq).GetReqRefundStatus(45)
ClassMethod GetReqRefundStatus(reqId)
{
	q:reqId="" 0
	s reqItmCnt=0
	s retItmCnt=0	 // 全退记录数
	s reqRefFlag=""
	s reqItm=""
	f  s reqItm=$o(^RETRQ(reqId,"I",reqItm)) q:(reqItm="")  d
	.s reqItmStatus=$p(^RETRQ(reqId,"I",reqItm),"^",10)
	.s refundStatus=$p(^RETRQ(reqId,"I",reqItm),"^",12)
	.i reqItmStatus="Execute" s refundStatus=1
	.s reqQty=$p(^RETRQ(reqId,"I",reqItm),"^",3)
	.s retedQty=+##class(web.DHCSTPHARETURN).GetReqReturnedQtyByPhaRet(reqId_"||"_reqItm)
	.s reqItmCnt=reqItmCnt+1
    .i (refundStatus="1")||(reqQty'>retedQty) d
    ..s retItmCnt=retItmCnt+1
    ..s reqRefFlag=1
    .i (reqQty>retedQty)&&(+retedQty>0) d
    ..s reqRefFlag=1
	q:(reqRefFlag=1)&&(retItmCnt=reqItmCnt) 1 // 全退
	q:(reqRefFlag=1) 2 // 部分退
	q 0
}

/// description: 进程号
ClassMethod NewPid()
{
	q ##class(web.DHCSTKUTIL).NewPid($ClassName(),"IP")
}

ClassMethod CheckReqInci(req, inci)
{
	q:req="" 1
	q:inci="" 1
	s chkFlag=0
	s chl=0
	f  s chl=$o(^RETRQ(req,"I",chl)) q:(chl="")||(chkFlag=1)  d
	.s inciDr=$p($g(^RETRQ(req,"I",chl)),"^",13)
	.q:inciDr'=inci
	.s chkFlag=1
	q chkFlag
}

ClassMethod CheckReqItmInciGroup(req, inci, prescNo, mDspId)
{
	q:req="" 0
	q:inci="" 1
	q:(prescNo="")&(mDspId="") 1
	s chl=0,chkItmFlag=0
	f  s chl=$o(^RETRQ(0,"INCI",inci,req,chl)) q:(chl="")||(chkItmFlag=1)  d
	.i prescNo'="" d
	..s oeori=$p($g(^RETRQ(req,"I",chl)),"^",1)
	..q:oeori=""
	..s tmpPrescNo=$p(^OEORD(+oeori,"I",$p(oeori,"||",2),1),"^",14)
	..q:tmpPrescNo'=prescNo
	..s chkItmFlag=1
	.e  i mDspId'="" d
	..s dspId=$p($g(^RETRQ(req,"I",chl)),"^",11)
	..q:dspId="" 
	..s tmpMainDspId=##class(web.DHCSTCOMMONORDER).GetMainDspId(dspId) 
	..q:tmpMainDspId=""
	..q:tmpMainDspId'=mDspId
	..s chkItmFlag=1
	q chkItmFlag
}

}
