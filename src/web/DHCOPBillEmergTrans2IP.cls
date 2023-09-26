Import SQLUser

/// 名称: web.DHCOPBillEmergTrans2IP.cls
/// 描述: 门急诊费用转住院业务类
/// 编写者: ZhYW
/// 编写日期: 2019-07-16
Class web.DHCOPBillEmergTrans2IP Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2019-07-16
/// Description: 门诊票据查询
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillEmergTrans2IP","FindOPBillINV","","","0000000508","5^122^49^2")
Query FindOPBillINV(stDate As %String, endDate As %String, patientNo As %String, sessionStr As %String) As websys.Query(ROWSPEC = "select:%String,papmi:%String:患者基本信息ID,patNo:%String:登记号,patName:%String:患者姓名,invRowId:%String,invNo:%String:发票号,patShareAmt:%Float:自付金额,userName:%String:收费员,invDate:%String:收费日期,invTime:%String:收费时间,totalAmt:%Float:费用总额,prtRowId:%String,invType:%String,cant2Msg:%String")
{
}

ClassMethod FindOPBillINVExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, patientNo As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindOPBillINV")=$lb(stDate, endDate, patientNo, sessionStr)
	if (patientNo="") quit $$$OK
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
	set patientId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(patientNo),""))
	if (patientId="") quit $$$OK

	//根据患者主索引查询
	//结算发票
	set invType="PRT"
	set invRowId=""
	while($o(^DHCINVPRT(0,"PAPMI",patientId,invRowId),-1)) {
		set invRowId=$o(^DHCINVPRT(0,"PAPMI",patientId,invRowId),-1)
		set data=$g(^DHCINVPRT(invRowId))
		set invDate=$p(data,"^",5)
		set invTime=$p(data,"^",20)
		continue:((stDate'="")&&(invDate<stDate))
		continue:((endDate'="")&&(invDate>endDate))
		do GetPrtInfo(invRowId)
	}
	//集中打印发票
	set invType="API"
	set invRowId=""
	while($o(^DHCINVPRTAPi(0,"PAPMI",patientId,invRowId),-1)) {
		set invRowId=$o(^DHCINVPRTAPi(0,"PAPMI",patientId,invRowId),-1)
		set data=$g(^DHCINVPRTAP(invRowId))
		set invDate=$p(data,"^",3)
		set invTime=$p(data,"^",4)
		continue:((stDate'="")&&(invDate<stDate))
		continue:((endDate'="")&&(invDate>endDate))
		do GetAPIInfo(invRowId)
	}
	
	quit $$$OK
	
GetPrtInfo(invRowId)
	set prtData=$g(^DHCINVPRT(invRowId))
	set prtFlag=$p(prtData,"^",8)
	quit:(prtFlag="TP")
	set fairType=$p(prtData,"^",34)
	quit:(fairType'="F")
	set totalAmt=$p(prtData,"^",1)
	set totalAmt=$fn(totalAmt,"",2)
	set invNo=$p(prtData,"^",14)
	set accPayInvDR=$p(prtData,"^",4)
	quit:(accPayInvDR'="")    //集中打印发票的退出
	set initInvDR=$p(prtData,"^",13)
	quit:(initInvDR'="")
	quit:($o(^DHCINVPRT(0,"InitInvDR",invRowId,""))'="")  //被退费的小条退出
	quit:($o(^DHCINVPRT(0,"OldINV",invRowId,""))'="")
	
	set patShareAmt=$p(prtData,"^",16)
	set patShareAmt=$fn(patShareAmt,"",2)
	set hospDR=$p(prtData,"^",39)
	quit:(hospDR'=hospId)
	
	do InitOutputInv
	set jsonStr=..GetPrtCan2IP(invRowId)
	set jsonObj={}.%FromJSON(jsonStr)
	set select='jsonObj.success
	set cant2Msg=jsonObj.msg
	set invDate=$p(prtData,"^",5)
	set invDate=##class(websys.Conversions).DateLogicalToHtml(invDate)
	set invTime=$p(prtData,"^",20)
	set invTime=##class(websys.Conversions).TimeLogicalToHtml(invTime)
	set userDR=$p(prtData,"^",21)
	set userName=$p($g(^SSU("SSUSR",userDR)),"^",2)
	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
	set papmi=$p(prtData,"^",15)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",2)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	do OutputInv
	quit
	
GetAPIInfo(invRowId)
	set accPInvData=$g(^DHCINVPRTAP(invRowId))
	set totalAmt=$p(accPInvData,"^",1)
	set totalAmt=$fn(totalAmt,"",2)
	set userDR=$p($g(accPInvData),"^",5)
	set userName=$p($g(^SSU("SSUSR",userDR)),"^",2)
	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
	set invNo=$p(accPInvData,"^",6)
	set initInvDR=$p(accPInvData,"^",10)
	quit:(initInvDR'="")    //负票退出
	quit:($o(^DHCINVPRTAPi(0,"OldADR",invRowId,""))'="")  //被退费的发票退出
	quit:($o(^DHCINVPRTAPi(0,"APIDR",invRowId,""))'="")
	
	set invDate=$p(accPInvData,"^",3)
	set invDate=##class(websys.Conversions).DateLogicalToHtml(invDate)
	set invTime=$p(accPInvData,"^",4)
	set invTime=##class(websys.Conversions).TimeLogicalToHtml(invTime)

	set patShareAmt=$p(accPInvData,"^",13)
	set patShareAmt=$fn(patShareAmt,"",2)
	set hospDR=$p(accPInvData,"^",30)
	quit:(hospDR'=hospId)
	
	do InitOutputInv
	set papmi=$p(accPInvData,"^",11)
	set regNo=$p($g(^PAPER(papmi,"PAT",1)),"^",2)
	set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	do OutputInv
	quit

InitOutputInv
	set select=1   //0:不能选中，1:可以选中
	set cant2Msg=""
	quit
OutputInv
	set Data=$lb(select,papmi,regNo,patName,invRowId,invNo,patShareAmt,userName,invDate,invTime,totalAmt,invRowId,invType,cant2Msg)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-07-16
/// Description: 查询门诊退费医嘱
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillEmergTrans2IP","FindOrdItm", "238885:PRT")
Query FindOrdItm(invStr As %String, langId As %String = "") As websys.Query(ROWSPEC = "arcimDesc:%String:医嘱,totalAmt:%Float:金额,patShareAmt:%Float:自付金额,price:%Float:单价,billQty:%String:数量,baseUom:%String:基本单位,execCode:%String,execDesc:%String:执行状态,prescNo:%String:处方号,recDept:%String:接收科室,ordSttDate:%String:医嘱日期,ordSttTime:%String:医嘱时间,oeitm:%String:医嘱ID,pboRowId:%String:医嘱账单ID,adm:%String:就诊ID,accPayInvId:%String:集中打印发票ID,invNo:%String:发票号,prtDate:%String:结算日期,prtTime:%String:结算时间,prtId:%String,prtFlag:%String,invFlag:%String:发票状态,ociId:%String,cantTransArc:%String:不可转入住院原因")
{
}

ClassMethod FindOrdItmExecute(ByRef qHandle As %Binary, invStr As %String, langId As %String = "") As %Status
{
    set repid=$I(^CacheTemp)
    set qHandle=$lb(0,repid,0)
    set ind=1
	set ^TMP("FindOrdItm")=$lb(invStr)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	for i=1:1:$l(invStr,"^") {
		set myInvStr=$p(invStr,"^",i)
		continue:(myInvStr="")
		set invId=$p(myInvStr,":",1)
		set invType=$p(myInvStr,":",2)
		continue:((invId="")||(invType=""))
		if (invType="API") {
			set apiConDR=0
			while($o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))) {
				set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))
				set data=$g(^DHCINVPRTCAP(apiConDR))
			  	continue:(data="")
			  	set prtId=$p(data,"^",1)
			  	do GetOrdItmDtl(invId, prtId)
			}
		}else {
			set accPayInvDR=""
			do GetOrdItmDtl(accPayInvDR, invId)
		}
	}
	
    quit $$$OK
    
GetOrdItmDtl(accPayInvId, prtId)
	set fairType=$p($g(^DHCINVPRT(prtId)),"^",34)
	quit:(fairType'="F")
	
	if (+accPayInvId'=0) {
		set invNo=$p($g(^DHCINVPRTAP(accPayInvId)),"^",6)
	}else {
		set invNo=$p($g(^DHCINVPRT(prtId)),"^",14)
	}
	set prtData=$g(^DHCINVPRT(prtId))
	set prtDate=$p(prtData,"^",5)
	set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
	set prtTime=$p(prtData,"^",20)
	set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
	set hospDR=$p(prtData,"^",39)
	set prtFlag=$p(prtData,"^",8)
	set invFlag=$case(prtFlag,"A":"作废","S":"红冲",:"正常")
	set invFlag=##class(websys.Translation).Get("", invFlag)
	
    set billConInv=0
    while($o(^DHCBCI(0,"INV",prtId,billConInv))) {
	    set billConInv=$o(^DHCBCI(0,"INV",prtId,billConInv))
		set conData=$g(^DHCBCI(billConInv))
	    continue:(conData="")
	    set adm=$p(conData,"^",3)
	    set pb=$p(conData,"^",2)
	    set pbo=0
	    while($o(^DHCPB(pb,"O",pbo))) {
		    set pbo=$o(^DHCPB(pb,"O",pbo))
			set pboData=$g(^DHCPB(pb,"O",pbo))
		    continue:(pboData="")
			set pboRowId=pb_"||"_pbo
			set price=$p(pboData,"^",7)
		    set price=$fn(price,"",4)
			set totalAmt=$p(pboData,"^",8)
		    set totalAmt=$fn(totalAmt,"",2)
		    set patShareAmt=$p(pboData,"^",11)
   			set patShareAmt=$fn(patShareAmt,"",2)
		    set arcim=$p(pboData,"^",3)
		    set arcGrp=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)       //医嘱子类
			set ordCateType=$p($g(^ARC("IC",arcGrp)),"^",7)               //医嘱类型
		    set arcGrpDesc=$s((+arcGrp'=0):$p($g(^ARC("IC",arcGrp)),"^",2),1:"")
		    set billSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(arcim, hospDR)   //是否是挂号费性质医嘱
		    continue:(billSubType'="NotRegFee")         //过滤挂号费性质医嘱
		    set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)   //名称
		    set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
		    set oeitm=$p(pboData,"^",4)               //PBO_oeitm_DR
		    continue:(..OrdIsOPToIPByOEORI(oeitm)=1)  //过滤已转入住院的医嘱
			set pboBillQty=$p(pboData,"^",5)          //PBO_BillQty
			set pboRefQty=$p(pboData,"^",6)           //PBO_RefundQty
		    set ordSttDate=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",9)            //OEORI_SttDat 医嘱日期
		    set ordSttDate=##class(websys.Conversions).DateLogicalToHtml(ordSttDate)
		    set ordSttTime=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",10)            //OEORI_SttTim 医嘱时间
		    set ordSttTime=##class(websys.Conversions).TimeLogicalToHtml(ordSttTime)
		    set ordDeptDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",3)             //OEORI_OrdDept_DR 就诊科室
		    set ordDept=$s((+ordDeptDR'=0):$p($g(^CTLOC(ordDeptDR)),"^",2),1:"")
			set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)   //新版检查申请单标识
			if (isAppRepFlag="Y") {
				set partDesc=##class(web.DHCAPPInterface).GetExaReqPartDesc(oeitm)
				set arcimDesc=arcimDesc_partDesc
			}
		    set baseUom=##class(web.DHCBillCommon).GetBaseUom(arcim, oeitm)
		    set baseUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", baseUom, langId)
		    set refundQty=0  //已药数量
		    set isMatGrantFlag=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(oeitm)
		    if (ordCateType="R") {
			    //药品
			    set refundQty=##class(PHA.FACE.OUT.Com).GetRetOrdQty(oeitm, prtId)
		    }elseif (isMatGrantFlag="Y") {
			    //走发放的物资材料
			    set refundQty=##class(web.DHCOPBillRefund).GetMatRetQty(oeitm, prtId)     //物资实际退费数量
		    }
			set billQty=(pboBillQty+pboRefQty-refundQty)
			set billQty=$fn(billQty,"N")
		    set recDeptDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),3)),"^",6)     //接收科室
		    set recDept=$s((+recDeptDR'=0):$p($g(^CTLOC(recDeptDR)),"^",2),1:"")
		    set recDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", recDept, langId)
		    set prescNo=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",14)        //处方号
		    set execInfo=..GetOrdExecStatus(oeitm)
		    set execCode=$p(execInfo,"^",1)
			set execDesc=$p(execInfo,"^",2)
			set execDesc=##class(websys.Translation).Get("", execDesc)
			set ociId=""
			set cantTransArc=""
			set unTransOrderCateStr=##class(web.DHCBillPageConf).GetPageConfValue("dhcbill.opbill.emergtrans2ip.csp", "LCATE", "", hospDR)
			if (($c(2)_unTransOrderCateStr_$c(2))[($c(2)_arcGrp_$c(2))) {
				set execCode=0
				set cantTransArc=arcGrpDesc
			}
		    do OutputOrdItm
		}
	}
    
    quit

OutputOrdItm
    set Data=$lb(arcimDesc,totalAmt,patShareAmt,price,billQty,baseUom,execCode,execDesc,prescNo,recDept,ordSttDate,ordSttTime,oeitm,pboRowId,adm,accPayInvId,invNo,prtDate,prtTime,prtId,prtFlag,invFlag,ociId,cantTransArc)
    set ^CacheTemp(repid,ind)=Data
    set ind=$i(ind)
    quit
}

/// Creator: ZhYW
/// CreatDate: 2019-07-16
/// Description: 查询已转入住院的医嘱
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillEmergTrans2IP","FindOCIList","2635","5^122^49^2^1")
Query FindOCIList(episodeId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "arcimDesc:%String:医嘱,totalAmt:%Float:金额,patShareAmt:%Float:自付金额,price:%Float:单价,billQty:%String:数量,baseUom:%String:基本单位,execCode:%String,execDesc:%String:执行状态,prescNo:%String:处方号,recDept:%String:接收科室,ordSttDate:%String:医嘱日期,ordSttTime:%String:医嘱时间,oeitm:%String:医嘱ID,pboRowId:%String:医嘱账单ID,adm:%String:就诊ID,accPayInvId:%String:集中打印发票ID,invNo:%String:发票号,prtDate:%String:结算日期,prtTime:%String:结算时间,prtId:%String,prtFlag:%String,invFlag:%String:发票状态,ociId:%String,cantTransArc:%String:不可转入住院原因")
{
}

ClassMethod FindOCIListExecute(ByRef qHandle As %Binary, episodeId As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindOCIList")=$lb(episodeId, sessionStr)
	if (+episodeId=0) quit $$$OK
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set oeitm=""
	while($o(^DHCOPIPADMCON(0,"IPADM",episodeId,"OEORI",oeitm))) {
		set oeitm=$o(^DHCOPIPADMCON(0,"IPADM",episodeId,"OEORI",oeitm))
		set ociId=0
		while($o(^DHCOPIPADMCON(0,"IPADM",episodeId,"OEORI",oeitm,ociId))) {
			set ociId=$o(^DHCOPIPADMCON(0,"IPADM",episodeId,"OEORI",oeitm,ociId))
			set data=$g(^DHCOPIPADMCON(ociId))
			continue:(data="")
			set status=$p(data,"^",7)
			continue:(status'="N")
			set adm=$p(data,"^",2)
			set prtId=$p(data,"^",4)
			set prtFlag=$p($g(^DHCINVPRT(prtId)),"^",8)
			set invFlag=$case(prtFlag,"A":"作废","S":"红冲",:"正常")
			set invFlag=##class(websys.Translation).Get("", invFlag)
			set accPayInvId=$p(data,"^",5)
			if (+accPayInvId'=0) {
				set invNo=$p($g(^DHCINVPRTAP(accPayInvId)),"^",6)
			}else {
				set invNo=$p($g(^DHCINVPRT(prtId)),"^",14)
			}
			set prtDate=$p(^DHCINVPRT(prtId),"^",5)
			set prtDate=##class(websys.Conversions).DateLogicalToHtml(prtDate)
			set prtTime=$p(^DHCINVPRT(prtId),"^",20)
			set prtTime=##class(websys.Conversions).TimeLogicalToHtml(prtTime)
			set pboRowId=$$GetPBO(prtId, oeitm)
			set pboData=$g(^DHCPB(+pboRowId,"O",$p(pboRowId,"||",2)))
			continue:(pboData="")
			set price=$p(pboData,"^",7)
		    set price=$fn(price,"",4)
			set totalAmt=$p(pboData,"^",8)
		    set totalAmt=$fn(totalAmt,"",2)
			set patShareAmt=$p(pboData,"^",11)
   			set patShareAmt=$fn(patShareAmt,"",2)
		    set arcim=$p(pboData,"^",3)
			set arcGrp=$p(^ARCIM(+arcim,$p(arcim,"||",2),1),"^",10)         //医嘱子类
			set ordCateType=$p($g(^ARC("IC",arcGrp)),"^",7)                 //医嘱类型
		    set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)   //名称
		    set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
			set pboBillQty=$p(pboData,"^",5)          //PBO_BillQty
			set pboRefQty=$p(pboData,"^",6)           //PBO_RefundQty
		    set ordSttDate=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",9)            //OEORI_SttDat 医嘱日期
		    set ordSttDate=##class(websys.Conversions).DateLogicalToHtml(ordSttDate)
		    set ordSttTime=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",10)            //OEORI_SttTim 医嘱时间
		    set ordSttTime=##class(websys.Conversions).TimeLogicalToHtml(ordSttTime)
		    set ordDeptDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",3)             //OEORI_OrdDept_DR 就诊科室
		    set ordDept=$s((+ordDeptDR'=0):$p($g(^CTLOC(ordDeptDR)),"^",2),1:"")
			set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)   //新版检查申请单标识
			if (isAppRepFlag="Y") {
				set partDesc=##class(web.DHCAPPInterface).GetExaReqPartDesc(oeitm)
				set arcimDesc=arcimDesc_partDesc
			}
		    set baseUom=##class(web.DHCBillCommon).GetBaseUom(arcim, oeitm)
		    set baseUom=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", baseUom, langId)
		 	set refundQty=0  //已药数量
		    set isMatGrantFlag=##class(web.DHCOPBillRefundRequest).CheckIsMatDispGrant(oeitm)
		    if (ordCateType="R") {
			    //药品
			    set refundQty=##class(PHA.FACE.OUT.Com).GetRetOrdQty(oeitm, prtId)
		    }elseif (isMatGrantFlag="Y") {
			    //走发放的物资材料
			    set refundQty=##class(web.DHCOPBillRefund).GetMatRetQty(oeitm, prtId)     //物资实际退费数量
		    }
			set billQty=(pboBillQty+pboRefQty-refundQty)
			set billQty=$fn(billQty,"N")
		    set recDeptDR=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),3)),"^",6)     //接收科室
		    set recDept=$s((+recDeptDR'=0):$p($g(^CTLOC(recDeptDR)),"^",2),1:"")
		    set recDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", recDept, langId)
		    set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
		    set prescNo=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",14)        //处方号
			set execInfo=..GetOrdExecStatus(oeitm)
		    set execCode=$p(execInfo,"^",1)
			set execDesc=$p(execInfo,"^",2)
			set execDesc=##class(websys.Translation).Get("", execDesc)
			set cantTransArc=""
			do OutputOCIList
		}
	}
	
	quit $$$OK
	
GetPBO(prtId, oeitm)
	set pboRowId=""
	set billConInv=0
	while($o(^DHCBCI(0,"INV",prtId,billConInv))) {
		set billConInv=$o(^DHCBCI(0,"INV",prtId,billConInv))
		set conData=$g(^DHCBCI(billConInv))
	    continue:(conData="")
	    set pb=$p(conData,"^",2)
	    set pbo=$o(^DHCPBi(0,"OEORI",oeitm,pb,""))
	    continue:(pbo="")
		set pboRowId=pb_"||"_pbo
		quit
	}
    
	quit pboRowId
	
OutputOCIList
	set Data=$lb(arcimDesc,totalAmt,patShareAmt,price,billQty,baseUom,execCode,execDesc,prescNo,recDept,ordSttDate,ordSttTime,oeitm,pboRowId,adm,accPayInvId,invNo,prtDate,prtTime,prtId,prtFlag,invFlag,ociId,cantTransArc)
	set ^CacheTemp(repid,ind)=Data
	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-07-16
/// Description: 获取医嘱的执行状态
/// Input: oeitm:OE_OrdItem.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetOrdExecStatus("7155||12")
ClassMethod GetOrdExecStatus(oeitm As %String) As %String
{
	set execCode=0
	set execDesc=""
	set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
	set inci=$o(^INCI(0,"ARCIM_DR",+arcim,""))
	if (inci'="") {
		set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(arcim, 0)
		if (ordCateType="R") {
			set status=##class(PHA.FACE.OUT.Com).GetDispensingStat(oeitm)
			do GetDispStat(status, .execCode, .execDesc)
			quit execCode_"^"_execDesc
		}
		set isMatDisp=##class(BILL.IP.COM.Method).IsMatDisp(oeitm)  //住院物资是否走发放流程
		if (isMatDisp=1) {
			set status=..GetMatDspStatus(oeitm)
			do GetDispStat(status, .execCode, .execDesc)
		}else {
			set execCode=1
			set execDesc="正常"
		}
		quit execCode_"^"_execDesc
	}
	
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (isAppRep="Y") {
		set status=..GetAppRepExecStatus(oeitm)
		do GetOtherStat(status, .execCode, .execDesc)
		if (execCode=1) {
			set status=##class(web.DHCOPBillOERefundQty).IsPartRefund(oeitm)
			if (status=0) {
				set execCode=0
				set execDesc="部分退费"
			}
		}
		quit execCode_"^"_execDesc
	}
	
	set billQty=..GetBillQtyByOrd(oeitm)   //收费数量
	set execQty=##class(web.UDHCJFBILL).GetOrdExecQty(oeitm)
	if (+execQty=0) {
		set status=0
	}elseif (execQty<billQty) {
		set status=1
	}else {
		set status=2
	}
	do GetOtherStat(status, .execCode, .execDesc)
	
	quit execCode_"^"_execDesc
	
GetDispStat(status, code, desc)
	if (status="TC") {
		set desc="未发"
		quit
	}
	if (status="PC") {
		set desc="部分发"
		quit
	}
	if (status="PR") {
		set code=1
		set desc="正常"     //部分退药
		quit
	}
	if (status="R") {
		set desc="已退"
		quit
	}
	if (status="C") {
		set code=1
		set desc="正常"     //全发
		quit
	}
	quit
	
GetOtherStat(status, code, desc)
	if (status=0) {
		set desc="未执行"
		quit
	}
	if (status=1) {
		set desc="部分执行"
		quit
	}
	if (status=2) {
		set code=1
		set desc="正常"      //全部执行
		quit
	}
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-07-16
/// Description: 获取物资材料发放状态
/// Input: oeitm: OE_OrdItem.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetMatDspStatus("43||3", 2)
ClassMethod GetMatDspStatus(oeitm As %String) As %String
{
	set dspQty=0
	set notDspQty=0
	set retQty=0
	
	set dspId=0
	while ($o(^DHCOEDISQTY(0,"OEORI",oeitm,dspId))) {
		set dspId=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dspId))
		set dspData=$g(^DHCOEDISQTY(dspId))
		continue:(dspData="")
		set myDspStatus=$p(dspData,"^",7)
   		set myQty=$p(dspData,"^",11)
   		if (myDspStatus="TC") {
	   		set notDspQty=$i(notDspQty,myQty)
	   	}elseif (myDspStatus="C") {
		   	set dspQty=$i(dspQty,myQty)
		}elseif (myDspStatus="R") {
			set retQty=$i(retQty,myQty)
		}
	}
   	
	set dspStatus=""
   	if (+notDspQty'=0) {
	   	if (+dspQty=0) {
			set dspStatus="TC"    //未发
		}else {
			set dspStatus="PC"    //部分发
		}
	}else {
		set dspStatus="C"         //全发
	}
	
	if (+retQty'=0) {
		if (+dspQty=+retQty) {
			set dspStatus="R"    //全退
		}else {
			set dspStatus="PR"   //部分退
		}
	}
	
	quit dspStatus
}

/// Creator: ZhYW
/// CreatDate: 2019-07-16
/// Description: 获取住院就诊列表
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillEmergTrans2IP","FindAdmList","1181","2","1")  
Query FindAdmList(patientId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "admNo:%String,admDate:%String,admTime:%String,admDept:%String,admWard:%String,admBed:%String,disDate:%String,disTime:%String,admStatus:%String,admReason:%String,admId:%String")
{
}

ClassMethod FindAdmListExecute(ByRef qHandle As %Binary, patientId As %String, sessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("FindAdmList")=$lb(patientId, sessionStr)
	if (patientId="")  quit $$$OK

	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set rowId=0
	while($o(^PAPERdr(patientId,"ADM","I",rowId))) {
		set rowId=$o(^PAPERdr(patientId,"ADM","I",rowId))
		set admNo=$p(^PAADM(rowId),"^",81)
		set billFlag=$p(^PAADM(rowId),"^",45)
		continue:(billFlag="Y")
		set admDeptDR=$p(^PAADM(rowId),"^",4)
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
		continue:(admHospDR'=hospId)
		set visitStatus=$p(^PAADM(rowId),"^",20)
		continue:(" P C "[(" "_visitStatus_" "))
		set admStatus=$case(visitStatus,"A":"在院","D":"出院",:"")
		set admStatus=##class(websys.Translation).Get("", admStatus)
		set admJsonStr=##class(BILL.COM.PAAdm).GetAdmInfo(rowId)
		set admJson=##class(%DynamicObject).%FromJSON(admJsonStr)
		set admDate=admJson.AdmDate
		set admTime=admJson.AdmTime
		set disDate=admJson.DiscDate
		set disTime=admJson.DiscTime
    	set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admJson.Dept, langId)
		set admWard=##class(User.PACWard).GetTranByDesc("WARDDesc", admJson.Ward, langId)
		set admBed=admJson.Bed
		set admReason=##class(User.PACAdmReason).GetTranByDesc("READesc", admJson.InsType, langId)
		do OutputAdmList
	}
 	
	quit $$$OK
OutputAdmList
	set Data=$lb(admNo,admDate,admTime,admDept,admWard,admBed,disDate,disTime,admStatus,admReason,rowId)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate：2019-07-18
/// Description: 根据发票号获取票据信息
/// Input: recepitNo: 发票号
/// Return: 
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetRecepitInfo("AD00001009", 2)
ClassMethod GetRecepitInfo(recepitNo As %String, sessionStr As %String) As %String
{
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set obj={}
	quit:(recepitNo="") obj.%Set("success",-1).%Set("msg","发票号不能为空").%ToJSON()
	
	set invRowId=""
	set invType=""
	set prtFlag=""
	set papmi=""
	set prtRowId=0
	while($o(^DHCINVPRT(0,"INV",recepitNo,prtRowId))&&(invRowId="")) {
		set prtRowId=$o(^DHCINVPRT(0,"INV",recepitNo,prtRowId))
		set hospDR=$p(^DHCINVPRT(prtRowId),"^",39)
		continue:(hospDR'=hospId)
		set invRowId=prtRowId
	}
	if (invRowId="") {
		set prtRowId=0
		while($o(^DHCINVPRTAPi(0,"INVNo",recepitNo,prtRowId))&&(invRowId="")) {
			set prtRowId=$o(^DHCINVPRTAPi(0,"INVNo",recepitNo,prtRowId))
			set hospDR=$p(^DHCINVPRTAP(prtRowId),"^",30)
			continue:(hospDR'=hospId)
			set invRowId=prtRowId
		}
		if (invRowId'="") {
			set invType="API"
			set prtFlag=$p(^DHCINVPRTAP(invRowId),"^",2)
			set papmi=$p(^DHCINVPRTAP(invRowId),"^",11)
		}
	}else {
		set invType="PRT"
		set prtFlag=$p(^DHCINVPRT(invRowId),"^",8)
		set papmi=$p(^DHCINVPRT(invRowId),"^",15)
	}
	
	if (prtFlag="") {
		do obj.%Set("success",-2).%Set("msg","该发票不存在")
		quit obj.%ToJSON()
	}
	if (prtFlag="S") {
		do obj.%Set("success",-3).%Set("msg","该发票已红冲")
		quit obj.%ToJSON()
	}
	if (prtFlag="A") {
		do obj.%Set("success",-4).%Set("msg","该发票已作废")
		quit obj.%ToJSON()
	}
	if (papmi="") {
		do obj.%Set("success",-5).%Set("msg","获取患者主索引失败")
		quit obj.%ToJSON()
	}
	set success=0
	set msg="获取信息成功"
	if (invType="PRT") {
		set jsonStr=..GetPrtCan2IP(invRowId)
		set jsonObj={}.%FromJSON(jsonStr)
		set success=jsonObj.success
		set msg=jsonObj.msg
	}
	do obj.%Set("success",success).%Set("msg",msg)
	do obj.%Set("invRowId",invRowId).%Set("invType",invType)
	do ..SetPatInfo(papmi, obj, sessionStr)
	
	quit obj.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate：2019-07-18
/// Description: 根据登记号或病案号获取患者信息
/// Input: recepitNo: 发票号
/// Return: 
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetPatInfo("0000001167","","2","1")
ClassMethod GetPatInfo(patientNo As %String, medicareNo As %String, sessionStr As %String) As %String
{
	set ^TMP("GetPatInfo")=$lb(patientNo, medicareNo, sessionStr)
	
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set obj={}
	quit:((patientNo="")&&(medicareNo="")) obj.%Set("success",-1).%Set("msg","登记号和病案号不能都为空").%ToJSON()
	
	if (patientNo'="") {
		set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
		set papmi=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(patientNo),""))
	}else {
		set papmi=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(medicareNo, "I", hospId, "")
	}
	quit:(papmi="") obj.%Set("success",-2).%Set("msg","患者信息不存在").%ToJSON()
	
	do obj.%Set("success",0).%Set("msg","获取信息成功")
	
	do ..SetPatInfo(papmi, obj, sessionStr)
	
	quit obj.%ToJSON()
}

ClassMethod SetPatInfo(patientId As %String, obj As %ObjectHandle, sessionStr As %String) As %String
{
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	quit:(patientId="") 0
	
	set patJsonStr=##class(BILL.COM.PAPatMas).GetPatientInfo(patientId, hospId)
	set patJson=##class(%DynamicObject).%FromJSON(patJsonStr)
	do obj.%Set("patientId",patientId).%Set("patientNo",patJson.PatientNo)
	do obj.%Set("medicareNo",patJson.MedicareNo).%Set("patName",patJson.PatName)
	do obj.%Set("sex",##class(User.CTSex).GetTranByDesc("CTSEXDesc", patJson.Sex, langId))
	do obj.%Set("age",patJson.Age)
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2019-07-16
/// Description: 急诊转住院
/// Input: ordItmInfo:需要转入住院的医嘱信息, inEpisodeId:住院就诊Id
///        sessionStr:操作员Id^安全组Id^科室Id^医院Id
/// Return: 
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).EmergTrans2IP("641||3^11700^","541","5^122^49^2")
ClassMethod EmergTrans2IP(ordItmInfo As %String, inEpisodeId As %String, sessionStr As %String) As %String
{
	set ^TMP("EmergTrans2IP")=$lb(ordItmInfo, inEpisodeId, sessionStr)
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set $zt="ERROR"
	
	set rtn=0
	set currDate=+$h
	set currTime=$p($h,",",2)
	
	quit:(+inEpisodeId=0) -1_"^"_"住院就诊为空，不能转入"
	
	set patientId=$p($g(^PAADM(inEpisodeId)),"^",1)
	set visitStatus=$p($g(^PAADM(inEpisodeId)),"^",20)
	if (" P C "[(" "_visitStatus_" ")) {
		set admStatus=$case(visitStatus,"C":"退院","P":"预住院",:"")
		quit -1_"^"_admStatus_"患者，不能转入"
	}
	set billFlag=$p($g(^PAADM(inEpisodeId)),"^",45)
	quit:(billFlag="Y") -1_"^"_"患者已做财务结算，不能转入"
	
	//+2022-11-23 ZhYW
	set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(inEpisodeId)
	set admDate=$p(admInOutDateInfo,"^",1)
	set cfgIntDate=..GetOrdDateIntIPRegDays(hospId)   //获取开医嘱时间与入院时间间隔天数阈值
	
	ts
	
	set count=$l(ordItmInfo,$c(2))
	for i=1:1:count {
		quit:(+rtn)
		set ordItmStr=$p(ordItmInfo,$c(2),i)
		continue:(ordItmStr="")
		set oeitm=$p(ordItmStr,"^",1)
		continue:(oeitm="")
		//+2022-11-23 ZhYW
		set arcim=$p($g(^OEORD(+oeitm,"I",$p(oeitm,"||",2),1)),"^",2)
		set arcimDesc=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)   //医嘱名称
		set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
		if (..OrdIsOPToIPByOEORI(oeitm)=1) {
			set rtn=-1_"^"_arcimDesc_##class(websys.Translation).Get("dhcbill.opbill.emergtrans2ip.csp", "已转入住院，不能重复转入", langId)
			quit
		}
		set ordSttDate=$p($g(^OEORD(+oeitm,"I",+$p(oeitm,"||",2),1)),"^",9)     //医嘱日期
		if ((+cfgIntDate'=0)&&($zabs($system.SQL.DATEDIFF("dd", admDate, ordSttDate)>+cfgIntDate))) {			
			set rtn=-1_"^"_arcimDesc_##class(websys.Translation).Get("dhcbill.opbill.emergtrans2ip.csp", "医嘱日期和入院日期间隔超过", langId)_cfgIntDate_##class(websys.Translation).Get("dhcbill.opbill.emergtrans2ip.csp", "天，不能转入", langId)
			quit
		}
		set myAdm=$p(^OEORD(+oeitm),"^",1)
		continue:(myAdm="")
		set myPapmi=$p(^PAADM(+myAdm),"^",1)
		if (patientId'=myPapmi) {
			set rtn=-1_"^"_"患者基本信息不一致"
			quit
		}
		
		set invPrtDR=$p(ordItmStr,"^",2)
		set accPayInvDR=$p(ordItmStr,"^",3)
		
		set execInfo=..GetOrdExecStatus(oeitm)
		set execCode=$p(execInfo,"^",1)
		if (execCode=0) {
			set rtn=-1_"^"_arcimDesc_"未执行，不能转入"
			quit
		}

		set rtn=$$INSERT()
		quit:(+rtn)
		
		set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
		if (isAppRepFlag="Y") {
			set rtn=..UpdateAppRepTarItm(oeitm, "P", "TB")	 //更新多部位检查申请单中间表的账单状态
		}else {
			set rtn=##class(appcom.OEOrdItem).MigrateOPExec(oeitm)
			if (+rtn) {
				set rtn=rtn_"^"_"生成执行记录失败"
			}
		}
		quit:(+rtn)
		
		//2021-05-10 ZhYW 转入后的价格时间以门诊收费时间为准时，将执行记录的取价格时间修改为门诊的取价格时间
		if (##class(web.DHCBillCommon).GetParamConfigFlag("Em2IPPriceMode")=1) {
			set ord=$p(oeitm,"||",1)
			set itm=$p(oeitm,"||",2)
			set priceDate=$p($g(^OEORD(ord,"I",itm,9)),"^",15)    //OEORI_BillPriceDate
			set priceTime=$p($g(^OEORD(ord,"I",itm,9)),"^",16)    //OEORI_BillPriceTime
			set exec=0
			while($o(^OEORD(ord,"I",itm,"X",exec))) {
				set exec=$o(^OEORD(ord,"I",itm,"X",exec))
				set oeore=ord_"||"_itm_"||"_exec
				set rtn=##class(web.UDHCJFBILLIP).UpdateOEPriceDate(oeore, priceDate, priceTime)
				quit:(+rtn)
			}
			quit:(+rtn)
		}
		
		set rtnValue=##class(web.UDHCJFBILL).BILLN(inEpisodeId, userId)
		set rtn=$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
	}
	
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
	
INSERT()
	set dataObj=##class(User.DHCOPIPADMCON).%New()
	do dataObj.OCIPAPMIDRSetObjectId(myPapmi)
	do dataObj.OCIOPAdmDRSetObjectId(myAdm)
	do dataObj.OCIIPAdmDRSetObjectId(inEpisodeId)
	do dataObj.OCIInvPrtDRSetObjectId(invPrtDR)
	do dataObj.OCIAccPayInvDRSetObjectId(accPayInvDR)
	do dataObj.OCIOEORIDRSetObjectId(oeitm)
	set dataObj.OCIStatus="N"
	set dataObj.OCIDate=currDate
	set dataObj.OCITime=currTime
	do dataObj.OCIUserDRSetObjectId(userId)
	do dataObj.OCIHospDRSetObjectId(hospId)
	set sc=dataObj.%Save()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	quit 0

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-07-16
/// Description: 住院转急诊
/// Input: ociIdStr:DHC_OPIPADMCON.RowId串(以"^"分割)
///        sessionStr:操作员Id^安全组Id^科室Id^医院Id
/// Return: 
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).IPTrans2Emerg("291","5^122^49^2")
ClassMethod IPTrans2Emerg(ociIdStr As %String, sessionStr As %String) As %String
{
	set ^TMP("IPTrans2Emerg")=$lb(ociIdStr, sessionStr)
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set $zt="ERROR"
	
	set rtn=0
	set currDate=+$h
	set currTime=$p($h,",",2)
	
	ts
	
	set count=$l(ociIdStr,"^")
	for i=1:1:count {
		quit:(+rtn)
		set rowId=$p(ociIdStr,"^",i)
		continue:(+rowId=0)
		set admConData=$g(^DHCOPIPADMCON(rowId))
		set ipEpisodeId=$p(admConData,"^",3)
		set admBillFlag=$p(^PAADM(ipEpisodeId),"^",45)
		if (admBillFlag="Y") {
			set rtn=-1_"^患者已做结算，不能撤回"
			quit
		}
		set oeitm=$p(admConData,"^",6)
		continue:(oeitm="")
		set prtId=$p(admConData,"^",4)
		continue:(prtId="")
		if ($d(^DHCINVPRT(0,"InitInvDR",prtId))) {
			set rtn=-1_"^发票已作废，不能撤回"
			quit
		}
		set status=$p(admConData,"^",7)
		if (status="C") {
			set rtn=-1_"^"_"医嘱ID:"_oeitm_"已撤回，不能重复撤回"
			quit
		}
		
		set rtn=$$UPDATE()
		quit:(+rtn)
		
		set babyInfo=##class(web.UDHCJFORDCHK).GetMotherAdmByBabyAdm(ipEpisodeId)
		set isBaby=$p(babyInfo,"^",1)
		set momAdmDR=$p(babyInfo,"^",2)
		if (isBaby="true") {
			//婴儿费用和母亲费用在同一账单时，根据母亲就诊判断是否费用已结算，已结算时不能撤回
			set pb=0
			while($o(^DHCPB(0,"ADM",momAdmDR,pb))) {
				set pb=$o(^DHCPB(0,"ADM",momAdmDR,pb))
				set pbData=$g(^DHCPB(pb))
				set payedFlag=$p(pbData,"^",16)
				set refundFlag=$p(pbData,"^",17)
				if ((payedFlag="P")&&(refundFlag="")&&($d(^DHCPBi(0,"OEORI",oeitm,pb)))) {
					set isCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(pb)
					set payedStatus=$s((isCloseAcount="Y"):"封账",1:"结算")
					set rtn=-1_"^"_"住院费用已"_payedStatus_"，不能撤回"
					quit
				}
			}
			quit:(+rtn)
		}
		
		//删除已有的账单
		set pb=0
		while($o(^DHCPB(0,"ADM",ipEpisodeId,pb))) {
			set pb=$o(^DHCPB(0,"ADM",ipEpisodeId,pb))
			set pbData=$g(^DHCPB(pb))
			set payedFlag=$p(pbData,"^",16)
			set refundFlag=$p(pbData,"^",17)
			if ((payedFlag="P")&&(refundFlag="")&&($d(^DHCPBi(0,"OEORI",oeitm,pb)))) {
				set isCloseAcount=##class(web.DHCIPBillPBCloseAcount).GetPaidCAcountFlag(pb)
				set payedStatus=$s((isCloseAcount="Y"):"封账",1:"结算")
				set rtn=-1_"^"_"住院费用已"_payedStatus_"，不能撤回"
				quit
			}
			continue:(payedFlag'="B")
			lock +^DHCPB(pb):5
			set totalSum=0
			set discSum=0
			set payorShareSum=0
			set patShareSum=0
			set pbo=0
			while($o(^DHCPBi(0,"OEORI",oeitm,pb,pbo))) {
				set pbo=$o(^DHCPBi(0,"OEORI",oeitm,pb,pbo))
				set pboData=$g(^DHCPB(pb,"O",pbo))
				continue:(pboData="")
				set pboRowId=pb_"||"_pbo
				set rtnValue=##class(web.UDHCJFBILLIP).PBODEL(pboRowId, userId)
				set rtn=$p(rtnValue,"^",1)
				if (+rtn) {
					set rtn=rtnValue
					quit
				}
				set totalAmt=$p(rtnValue,"^",2)
				set discAmt=$p(rtnValue,"^",3)
				set payorShareAmt=$p(rtnValue,"^",4)
				set patShareAmt=$p(rtnValue,"^",5)
				set totalSum=$i(totalSum, totalAmt)
				set discSum=$i(discSum, discAmt)
				set payorShareSum=$i(payorShareSum, payorShareAmt)
				set patShareSum=$i(patShareSum, patShareAmt)
			}
			quit:(+rtn)
			set pbObj=##class(User.DHCPatientBill).%OpenId(pb, 0)
			set pbObj.PBTotalAmount=pbObj.PBTotalAmount+totalSum
			set pbObj.PBDiscAmount=pbObj.PBDiscAmount+discSum
			set pbObj.PBPayorShare=pbObj.PBPayorShare+payorShareSum
			set pbObj.PBPatientShare=pbObj.PBPatientShare+patShareSum
			if ((pbObj.PBTotalAmount<0)||(pbObj.PBDiscAmount<0)||(pbObj.PBPayorShare<0)||(pbObj.PBPatientShare<0)) {
				lock -^DHCPB(pb)
				set rtn=-1_"^"_"撤回后账单金额小于0，不能撤回"
				quit
			}
			set pbObj.PBUpdateDate=currDate
			set pbObj.PBUpdateTime=currTime
			do pbObj.PBUpdateUserSetObjectId(userId)
			set sc=pbObj.%Save()
			do pbObj.%Close()
			if $$$ISERR(sc) {
				lock -^DHCPB(pb)
				set rtn=$system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
				quit
			}
			lock -^DHCPB(pb)
		}
		quit:(+rtn)
		
		//更新新版检查申请单中间表
		set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
		if (isAppRepFlag="Y") {
			set rtn=..UpdateAppRepTarItm(oeitm, "TB^B", "P")	 //更新多部位检查申请单中间表的账单状态
			quit:(+rtn)
		}
	}
	
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn
	
UPDATE()
	set dataObj=##class(User.DHCOPIPADMCON).%OpenId(rowId, 0)
	set dataObj.OCIStatus="C"
	set dataObj.OCICancelDate=currDate
	set dataObj.OCICancelTime=currTime
	do dataObj.OCICancelUserDRSetObjectId(userId)
	set sc=dataObj.%Save()
	do dataObj.%Close()
	if $$$ISERR(sc) {
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	quit 0
	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2019-07-18
/// Descripion: 急诊转住院时，更新多部位检查申请单中间表的账单状态
/// 		注：多部位检查申请单不支持部分转住院
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).UpdateAppRepTarItm()
ClassMethod UpdateAppRepTarItm(oeitm As %String, frmStatus As %String, toStatus As %String) As %String
{
	set rtn=0
	
	set itmDR=0
	while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR))&&(+rtn=0)) {
		set itmDR=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR))
		set artiDR=0
		while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR,artiDR))&&(+rtn=0)) {
			set artiDR=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR,artiDR))
			set data=$g(^DHCAPREPTA(artiDR))
			continue:(data="")
			set billStatus=$p(data,"^",9)   //账单状态
			continue:(("^"_frmStatus_"^")'[("^"_billStatus_"^"))
			set exec=$p(data,"^",10)	   //ARTI_OrdExec
			&SQL(
				UPDATE DHC_AppRepTarItm
				SET ARTI_Billed = :toStatus
				WHERE %ID = :artiDR
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
			//更新执行记录表
			&SQL(
				UPDATE OE_OrdExec
				SET OEORE_Billed = :toStatus
				WHERE %ID = :exec
			)
			set rtn=SQLCODE
			if (+rtn) {
				set rtn=rtn_"^"_$g(%msg)
				quit
			}
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断发票串中是否包含急诊转入住院的发票记录(集中打印发票判断小条)
/// Input: 
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).CheckInvIsOPToIP()
ClassMethod CheckInvIsOPToIP(invStr As %String) As %String
{
	set rtn=0
	
	for i=1:1:$l(invStr,"^") {
		set myInvStr=$p(invStr,"^",i)
		continue:(myInvStr="")
		set invId=$p(myInvStr,":",1)
		set invType=$p(myInvStr,":",2)
		continue:((invId="")||(invType=""))
		if (invType="API") {
			set apiConDR=0
			while($o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))&&(rtn=0)) {
				set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))
				set data=$g(^DHCINVPRTCAP(apiConDR))
				set prtId=$p(data,"^",1)
				set ociRowId=..GetOCIRowIdByInvPrt(prtId)
				if (ociRowId'="") {
					set rtn=1
				}
			}
		}else {
			set ociRowId=..GetOCIRowIdByInvPrt(invId)
			if (ociRowId'="") {
				set rtn=1
			}
		}
		quit:(+rtn)
	}
	
  	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断医嘱是否是急诊转入住院的医嘱
/// Input: oeitm: OE_OrdItem.RowId
/// Return: 0:否, 1:是
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI("46||5")
ClassMethod OrdIsOPToIPByOEORI(oeitm As %String) As %String
{
	set rtn=0
	quit:($l(oeitm,"||")'=2) rtn
	
	set adm=$p($g(^OEORD(+oeitm)),"^",1)
	quit:(+adm=0) rtn
	
	set ociId=$o(^DHCOPIPADMCON(0,"OPADM",adm,"OEORI",oeitm,""),-1)
	if (+ociId'=0) {
		set data=$g(^DHCOPIPADMCON(ociId))
		set status=$p(data,"^",7)
		if (status="N") {
			set rtn=1
		}
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断是否有急诊转入该住院就诊的医嘱(通过住院就诊判断)
/// Input: adm: PA_Adm.RowId(住院)
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).HasOPToIPOrdByIPAdm("310")
ClassMethod HasOPToIPOrdByIPAdm(adm As %String) As %String
{
	set rtn=0
	quit:(adm=0) rtn
	
	set opAdm=""
	while($o(^DHCOPIPADMCON(0,"IPADM",adm,"OPADM",opAdm),-1)&&(rtn=0)) {
		set opAdm=$o(^DHCOPIPADMCON(0,"IPADM",adm,"OPADM",opAdm),-1)
		set ociId=""
		while($o(^DHCOPIPADMCON(0,"IPADM",adm,"OPADM",opAdm,ociId),-1)&&(rtn=0)) {
			set ociId=$o(^DHCOPIPADMCON(0,"IPADM",adm,"OPADM",opAdm,ociId),-1)
			set data=$g(^DHCOPIPADMCON(ociId))
			set status=$p(data,"^",7)
			continue:(status'="N")
			set rtn=1
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-07-23
/// Description: 判断该急诊就诊下是否有转入住院的医嘱(通过门诊就诊判断)
/// Input: adm: PA_Adm.RowId(门诊)
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).HasOPToIPOrdByOPAdm("310")
ClassMethod HasOPToIPOrdByOPAdm(adm As %String) As %String
{
	set rtn=0
	quit:(adm=0) rtn
	
	set oeitm=""
	while($o(^DHCOPIPADMCON(0,"OPADM",adm,"OEORI",oeitm),-1)&&(rtn=0)) {
		set oeitm=$o(^DHCOPIPADMCON(0,"OPADM",adm,"OEORI",oeitm),-1)
		set ociId=""
		while($o(^DHCOPIPADMCON(0,"OPADM",adm,"OEORI",oeitm,ociId),-1)&&(rtn=0)) {
			set ociId=$o(^DHCOPIPADMCON(0,"OPADM",adm,"OEORI",oeitm,ociId),-1)
			set data=$g(^DHCOPIPADMCON(ociId))
			set status=$p(data,"^",7)
			continue:(status'="N")
			set rtn=1
		}
	}

	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-07-22
/// Description: 判断医嘱是否转入该住院就诊
/// Input: adm: PA_Adm.RowId(住院), oeitm: OE_OrdItem.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByIPAdm("2754", "2635||5")
ClassMethod OrdIsOPToIPByIPAdm(adm As %String, oeitm As %String) As %String
{
	set rtn=0
	quit:((adm=0)||(oeitm="")) rtn
	
	set ociId=$o(^DHCOPIPADMCON(0,"IPADM",adm,"OEORI",oeitm,""),-1)
	if (+ociId'=0) {
		set data=$g(^DHCOPIPADMCON(ociId))
		set status=$p(data,"^",7)
		if (status="N") {
			set rtn=1
		}
	}
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2019-07-22
/// Description: 根据DHC_INVPRT.RowId查询转入住院的Id
/// Input: prtRowId: DHC_INVPRT.RowId
/// Return: DHC_OPIPADMCON.RowId
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetOCIRowIdByInvPrt("2754")
ClassMethod GetOCIRowIdByInvPrt(prtRowId As %String) As %String
{
	set ociRowId=""
	set id=""
	while($o(^DHCOPIPADMCON(0,"InvPrt",prtRowId,id),-1)&&(ociRowId="")) {
		set id=$o(^DHCOPIPADMCON(0,"InvPrt",prtRowId,id),-1)
		set ociData=$g(^DHCOPIPADMCON(id))
		set status=$p(ociData,"^",7)
		continue:(status'="N")
		set ociRowId=id
	}
	
	quit ociRowId
}

/// Creator: ZhYW
/// CreatDate: 2019-07-22
/// Description: 根据DHC_INVPRT.RowId查询转入住院的Id
/// Input: prtRowId: DHC_INVPRT.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetPrtCan2IP("12516")
ClassMethod GetPrtCan2IP(prtRowId As %String) As %String
{
	set obj={}
	set obj.success=0
	set obj.msg="可以转住院"
	set myQFRowId=$o(^DHCOPQFPatInfo(0,"InvPrt",prtRowId,""))
	set myQFFlag=$s((+myQFRowId'=0):$p($g(^DHCOPQFPatInfo(myQFRowId)),"^",7),1:"")
	if (myQFFlag="Owe") {
		set obj.success=1
		set obj.msg="欠费结算记录不能转住院"
	}
	quit obj.%ToJSON()
}

/// Creator: ZhYW
/// CreatDate: 2021-04-23
/// Description: 获取门诊医嘱的计费数量
/// Input: oeitm: OE_OrdItem.RowId
/// Return: 
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetBillQtyByOrd("30035583||4")
ClassMethod GetBillQtyByOrd(oeitm As %String) As %String
{
	set billQty=0
	
	set pboRowId=""
	set pb=""
	while($o(^DHCPBi(0,"OEORI",oeitm,pb),-1)&&(pboRowId="")) {
		set pb=$o(^DHCPBi(0,"OEORI",oeitm,pb),-1)
		set payedFlag=$p(^DHCPB(pb),"^",16)
		continue:(payedFlag'="P")    //过滤未结算账单
		set refundFlag=$p(^DHCPB(pb),"^",17)
		continue:(refundFlag="R")    //过滤负账单
		set pbo=$o(^DHCPBi(0,"OEORI",oeitm,pb,0))
		set pboRowId=pb_"||"_pbo
		set pboData=$g(^DHCPB(pb,"O",pbo))
  		set pboBillQty=$p(pboData,"^",5)		   //PBO_BillQty
		set pboRefQty=$p(pboData,"^",6)	           //PBO_RefundQty
		set billQty=pboBillQty+pboRefQty
	}
	quit billQty
}

/// Creator: ZhYW
/// CreatDate: 2022-07-25
/// Description: 获取多部位检查申请单执行状态
/// Input: oeitm:OE_OrdItem.RowId
/// Table: DHC_AppRepTarItm
/// Return: -1:非新版检查申请单或无执行记录, 0:全部未执行, 1:部分执行, 2:全部执行
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetAppRepExecStatus("357||5")
ClassMethod GetAppRepExecStatus(oeitm As %String) As %String
{
	set flag=-1
	set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	quit:(isAppRep'="Y") flag
	
	set execFalg=0
	set noExecFlag=0
	
	set itmDR=0
	while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR))) {
		set itmDR=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR))
		set artiDR=0
		while($o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR,artiDR))) {
			set artiDR=$o(^DHCAPREPTA(0,"OrdTar",oeitm,itmDR,artiDR))
			set artiData=$g(^DHCAPREPTA(artiDR))
			continue:(artiData="")
			set ordExec=$p(artiData,"^",10)	     //ARTI_OrdExec
			set statDR=$p(^OEORD(+ordExec,"I",$p(ordExec,"||",2),"X",$p(ordExec,"||",3),"BILL"),"^",1)   //OE_OrdExec.OEORE_OrderStatus_DR
			set statCode=$s((+statDR'=0):$p(^OEC("OSTAT",statDR),"^",1),1:"")
			if (statCode="E") {
				set execFalg=1
			}else {
				set noExecFlag=1
			}
		}
	}
	
	if ((execFalg=0)&&(noExecFlag=1)) set flag=0	//全部未执行
	if ((execFalg=1)&&(noExecFlag=1)) set flag=1	//部分执行
	if ((execFalg=1)&&(noExecFlag=0)) set flag=2	//全部执行
	
	quit flag
}

/// Creator: ZhYW
/// CreatDate: 2022-11-23
/// Description: 获取开医嘱时间与入院时间间隔天数阈值
/// Input: hospId:CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetOrdDateIntIPRegDays(2)
ClassMethod GetOrdDateIntIPRegDays(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPEMFeeToIP.KYZSJYRYSJJGTSYZ", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit $p(cfgData,"^",1)
}

/// Creator: ZhYW
/// CreatDate: 2023-01-16
/// Description: 获取以"急诊转入"方式退费的支付方式Id
/// Input: 
/// Return: CT_PayMode.RowId
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetRefPayMode(2)
ClassMethod GetRefPayMode() As %String
{
	quit $o(^CT("CTPM",0,"Code","ZZZR",0))
}

/// Creator: ZhYW
/// CreatDate: 2023-01-16
/// Description: 将门诊退费的自费退费金额充值到住院押金
/// Input: 
/// Return: CT_PayMode.RowId
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).TransRefAmt2IPDep(2)
ClassMethod TransRefAmt2IPDep(invStr As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	
	set ^TMP("TransRefAmt2IPDep")=$lb(invStr, sessionStr)
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set invId=$p(invStr,":",1)
	set invType=$p(invStr,":",2)
	
	set rtn=0
	
	set ociRowId=""
	if (invType="API") {
		set apiConDR=0
		while($o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))) {
			set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",invId,apiConDR))
			set data=$g(^DHCINVPRTCAP(apiConDR))
			set prtId=$p(data,"^",1)
			set ociRowId=..GetOCIRowIdByInvPrt(prtId)
			quit:(+ociRowId=0)
		}
	}else {
		set ociRowId=..GetOCIRowIdByInvPrt(invId)
	}
	quit:(+ociRowId=0) rtn
	
	set inAdm=$p($g(^DHCOPIPADMCON(ociRowId)),"^",3)
	quit:(+inAdm=0) rtn
	
	set selfRefAmt=..GetSelfRefundSum(invStr)
	quit:(+selfRefAmt'<0) rtn
	
	set depTypeId=$o(^ARC("ARCDT",0,"Code","01",0))
	set payAmt=$zabs(selfRefAmt)
	set paymId=..GetRefPayMode()

	//充住院押金
	set company=""
	set bankId=""
	set chequeNo=""
	set payAccNo=""
	set bankCardTypeId=""
	set unitId=""
	set chequeDate=""
	set remark=""
	set transfer=""
	set strikeInvPrtId=""
	set initDepId=""
	set isSerial=""
	set refReasonId=""
	
	set depStr=depTypeId_"^"_payAmt_"^"_inAdm_"^"_remark_"^"_transfer_"^"_strikeInvPrtId_"^"_initDepId_"^"_refReasonId

	set paymStr=paymId_"^"_bankId_"^"_chequeNo_"^"_bankCardTypeId_"^"_unitId
	set paymStr=paymStr_"^"_chequeDate_"^"_payAccNo_"^"_payAmt
	
	set rtn=##class(web.DHCIPBillDeposit).InsertDeposit(depStr, paymStr, sessionStr)
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2023-01-16
/// Description: 获取病人自费退费金额
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).GetSelfRefundSum(2)
ClassMethod GetSelfRefundSum(invStr As %String) As %String
{
	set invId=$p(invStr,":",1)
	set invType=$p(invStr,":",2)
	
	set refSelfSum=0
	
	set refModeId=..GetRefPayMode()
	
	if (invType="API") {
		set refSelfSum=$$GetAccPayInv(invId)
	}else {
		set refSelfSum=$$GetPrtRowId(invId)
	}
	quit refSelfSum
	
GetAccPayInv(prtRowId)
	set accRefSelfSum=0
	set apiConDR=0
	while($o(^DHCINVPRTCAPi(0,"APINVDR",prtRowId,apiConDR))) {
		set apiConDR=$o(^DHCINVPRTCAPi(0,"APINVDR",prtRowId,apiConDR))
		set data=$g(^DHCINVPRTCAP(apiConDR))
		set prtId=$p(data,"^",1)
		set sigleRefSelfSum=$$GetPrtRowId(prtId)
		set accRefSelfSum=$i(accRefSelfSum, sigleRefSelfSum)
	}
	set accRefSelfSum=$fn(accRefSelfSum,"",2)
	quit accRefSelfSum
	
GetPrtRowId(prtRowId)
	set sigleRefSelfSum=0
	//负票
	set striRowId=$o(^DHCINVPRT(0,"InitInvDR",prtRowId,0))
	quit:(+striRowId=0) 0

	set paymSub=0
	while($o(^DHCINVPRTi(0,"PMDR",striRowId,refModeId,"P",paymSub))) {
		set paymSub=$o(^DHCINVPRTi(0,"PMDR",striRowId,refModeId,"P",paymSub))
		set subData=$g(^DHCINVPRT(striRowId,"P",paymSub))
		set paymAmt=$p(subData,"^",3)
		set sigleRefSelfSum=$i(sigleRefSelfSum, paymAmt)
	}
	
    //新发票
    set newRowId=$o(^DHCINVPRT(0,"OldINV",prtRowId,0))
    if (+newRowId'=0) {
		set paymSub=0
		while($o(^DHCINVPRTi(0,"PMDR",newRowId,refModeId,"P",paymSub))) {
			set paymSub=$o(^DHCINVPRTi(0,"PMDR",newRowId,refModeId,"P",paymSub))
			set subData=$g(^DHCINVPRT(newRowId,"P",paymSub))
			set paymAmt=$p(subData,"^",3)
			set sigleRefSelfSum=$i(sigleRefSelfSum, paymAmt)
		}
	}
	
	set sigleRefSelfSum=$fn(sigleRefSelfSum,"",2)
    quit sigleRefSelfSum
}

/// Creator: ZhYW
/// CreatDate: 2023-01-16
/// Description: 医嘱转入住院后是否自动退门诊费用
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCOPBillEmergTrans2IP).IsNeedToRefundOPInv(2)
ClassMethod IsNeedToRefundOPInv(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("OPCHRG.OPEMFeeToIP.YZZRZYHSFZDTMZFY", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

}
