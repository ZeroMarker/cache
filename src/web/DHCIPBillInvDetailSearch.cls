/// 名称: web.DHCIPBillInvDetailSearch
/// 描述: 实现对票据的查询 
/// 编写者: 王刚
/// 编写日期: 2008-09-25
Class web.DHCIPBillInvDetailSearch Extends BILL.COM.Abstract
{

/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillInvDetailSearch","FindInvDetail","2021-05-25","2021-05-25","","","A","","","","","","1","241!222!2")
Query FindInvDetail(stDate As %String, endDate As %String, guser As %String, rcptStatus As %String, rcptType As %String, PayMode As %String, InvNo As %String, medicareNo As %String, PatType As %String, AdmReason As %String, depositType As %String, expStr As %String, PatStatus As %String = "") As websys.Query(ROWSPEC = "usrName:%String:收费员,invType:%String:票据类型,invNo:%String:票据号,patName:%String:患者姓名,regNo:%String:登记号,mrNo:%String:病案号,invDate:%String:收据日期,amount:%Float:金额,refUsrName:%String:退费人员,backDate:%String:退费日期,invStatus:%String:票据状态,oldInvNo:%String:原发票号,paymode:%String:支付方式,insType:%String:费别,insuCardNo:%String:医保卡号,insuAccPayAmt:%Float:个人账户支付,insuPayAmt:%Float:统筹支付,patStatus:%String:在院状态") [ SqlProc ]
{
}

ClassMethod FindInvDetailExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, guser As %String, rcptStatus As %String, rcptType As %String, PayMode As %String, InvNo As %String, medicareNo As %String, PatType As %String, AdmReason As %String, depositType As %String, expStr As %String, PatStatus As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	set ^TMP("FindInvDetail")=$lb(stDate, endDate, guser, rcptStatus, rcptType, PayMode, InvNo, medicareNo, PatType, AdmReason, depositType, expStr)
	if ((stDate="")||(endDate=""))  quit $$$OK

 	set hospId=$p(expStr,"!",1)
	set langId=$p(expStr,"!",2)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	
 	set depRcptStatus=$case(rcptStatus,"N":1,"A":2,"S":3,"BS":4,:"")
 	
 	set patientId=""
 	if (medicareNo'="") {
	 	set patientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(medicareNo, "I", hospId, "")
	 	if (+patientId=0) quit $$$OK
 	}
 	
 	if (InvNo'="") {
	 	//住院押金
	 	if ((rcptType="")||(rcptType="Y")) {
		 	set invType="押金收据"        //票据类型
 			set invType=##class(websys.Translation).Get("", invType, langId)
		 	set prtRowId=$o(^DHCSFPRINTDETAIL(0,"RcptNo",InvNo,""))
		 	if (prtRowId'="") {
			 	do GetDepositInfo(prtRowId, PayMode, PatType)
			}
		}
		//住院结算
		if ((rcptType="")||(rcptType="N")) {
			set invType="住院发票"                          //票据类型
 			set invType=##class(websys.Translation).Get("", invType, langId)
			set prtRowId=$o(^DHCINVPRTZY(0,"INV",InvNo,""))
			if (prtRowId'="") {
				do GetInvInfo(prtRowId, PayMode, PatType)
			}
		}
		//集中打印发票
		if ((rcptType="")||(rcptType="A")) {
			//ShangXuehao  集中打印
			set invType="集中打印"
 			set invType=##class(websys.Translation).Get("", invType, langId)
		 	set prtRowId=$o(^BILL.IP.SummaryPrtInvI("InvNo",InvNo,""))
		 	if (prtRowId'="") {
			 	do GetSPIInfo(prtRowId, PayMode, PatType)
			}
		}
		
	 	quit $$$OK
	}
	
	if (patientId'="") {
		set adm=0
		while($o(^PAPERdr(patientId,"ADM","I",adm))) {
			set adm=$o(^PAPERdr(patientId,"ADM","I",adm))
			if ((rcptType="")||(rcptType="Y")) {
				set invType="押金收据"        //票据类型
 				set invType=##class(websys.Translation).Get("", invType, langId)
				set prtRowId=0
				while($o(^DHCSFPRINTDETAIL(0,"adm",adm,prtRowId))) {
					set prtRowId=$o(^DHCSFPRINTDETAIL(0,"adm",adm,prtRowId))
					do GetDepositInfo(prtRowId, PayMode, PatType)
				}
			}
			if ((rcptType="")||(rcptType="N")) {
				set invType="住院发票"                          //票据类型
 				set invType=##class(websys.Translation).Get("", invType, langId)
				set prtRowId=0
				while($o(^DHCINVPRTZY(0,"ADM",adm,prtRowId))) {
					set prtRowId=$o(^DHCINVPRTZY(0,"ADM",adm,prtRowId))
					do GetInvInfo(prtRowId, PayMode, PatType)
				}
			}
			//ShangXuehao 集中打印
			if ((rcptType="")||(rcptType="A")) {
				set invType="集中打印"
 				set invType=##class(websys.Translation).Get("", invType, langId)
				set prtRowId=0
				while($o(^BILL.IP.SummaryPrtInvI("AdmDR",adm,prtRowId))) {
					set prtRowId=$o(^BILL.IP.SummaryPrtInvI("AdmDR",adm,prtRowId))
					do GetSPIInfo(prtRowId, PayMode, PatType)
				}
			}
		}
		
		quit $$$OK
 	}
 	
 	for date=stDate:1:endDate {
	 	if ((rcptType="")||(rcptType="Y")) {
		 	set invType="押金收据"        //票据类型
 			set invType=##class(websys.Translation).Get("", invType, langId)
			set prtRowId=0
			while($o(^DHCSFPRINTDETAIL(0,"PrtDate",date,prtRowId))) {
				set prtRowId=$o(^DHCSFPRINTDETAIL(0,"PrtDate",date,prtRowId))
				do GetDepositInfo(prtRowId, PayMode, PatType)
			}
		}
	 	if ((rcptType="")||(rcptType="N")) {
			set invType="住院发票"                          //票据类型
 			set invType=##class(websys.Translation).Get("", invType, langId)
			set prtRowId=0
		 	while($o(^DHCINVPRTZY(0,"DATE",date,prtRowId))) {
			 	set prtRowId=$o(^DHCINVPRTZY(0,"DATE",date,prtRowId))
			 	do GetInvInfo(prtRowId, PayMode, PatType)
			}
		}
	 	if ((rcptType="")||(rcptType="A")) {
			set invType="集中打印"
 			set invType=##class(websys.Translation).Get("", invType, langId)
			set prtRowId=0
		 	while($o(^BILL.IP.SummaryPrtInvI("PrtDate",date,prtRowId))) {
			 	set prtRowId=$o(^BILL.IP.SummaryPrtInvI("PrtDate",date,prtRowId))
			 	do GetSPIInfo(prtRowId, PayMode, PatType)
			}
		}
	}
 	
	quit $$$OK

GetDepositInfo(prtRowId, PayMode, PatType)
	set depData=$g(^DHCSFPRINTDETAIL(prtRowId))
	set oldInvNo="", refUsrName="", backDate="", insuCardNo="", insuAccPayAmt="", insuPayAmt=""
	set hospDR=$p(depData,"^",44)
 	quit:(hospDR'=hospId)
	set usrDR=$p(depData,"^",14)
 	quit:((guser'="")&&(guser'=usrDR))
 	set usrName=$p(^SSU("SSUSR",usrDR),"^",2)     //操作员
 	set usrName=##class(User.SSUser).GetTranByDesc("SSUSRName", usrName, langId)
	set prtStatus=$p(depData,"^",8)      //状态
 	quit:((depRcptStatus'="")&&(prtStatus'=depRcptStatus))
 	set invStatus=$case(prtStatus,1:"正常",2:"作废",3:"冲红",4:"正常",:"")
 	set invStatus=##class(websys.Translation).Get("", invStatus, langId)
 	set depTypeDR=$p(depData,"^",13)
 	quit:((+depositType'=0)&&(depTypeDR'=depositType))
 	set invNo=$p(depData,"^",1)   //票号
 	set adm=$p(depData,"^",4)
 	set papmi=$p(^PAADM(adm),"^",1)
 	
 	;+add by gongxin 20230424 start 查询退院患者预交金明细
 	set PatStatusDR=$p(^PAADM(adm),"^",20)
 	quit:((PatStatus'=PatStatusDR)&&(PatStatus'=""))
 	set PatStatusDesc=$case(PatStatusDR,"C":"退院","A":"在院","D":"出院","P":"预约",:"")  ;+add by gongxin 20230505 多院区翻译
 	set PatStatusDesc=##class(websys.Translation).Get("", PatStatusDesc, langId) ;+add by gongxin 20230505 多院区翻译
 	;+add by gongxin 20230424 end
 	
 	//add 2011-01-08 tangtao
 	set admReaDR=$p(^PAADM(adm,1),"^",7)
	quit:((AdmReason'=admReaDR)&&(AdmReason'=""))      //+hujunbin 2014-11-19
 	set nationalCode=$p(^PAC("ADMREA",admReaDR),"^",5)  
 	set insType=$p(^PAC("ADMREA",admReaDR),"^",2)     //费别
 	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
 	set insuFlag=$s((+nationalCode=0):"N",1:"Y")
 	quit:((PatType'=insuFlag)&&(PatType'=""))
 	set patName=$p(^PAPER(papmi,"ALL"),"^",1)     //患者姓名
 	set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)     //登记号
 	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
 	set invDate=$p(depData,"^",2)  //票据日期
 	set invDate=##class(websys.Conversions).DateLogicalToHtml(invDate)
 	set amount=$p(depData,"^",6)         //金额
 	set amount=$fn(amount,"",2)
 	set depPMSub=$o(^DHCSFPRINTDETAIL(prtRowId,"P",0))
	set depPMData=$g(^DHCSFPRINTDETAIL(prtRowId,"P",+depPMSub))
	set paymDR=$p(depPMData,"^",1)
	quit:((PayMode'="")&&(PayMode'=paymDR))
 	set paymDesc=$s((+paymDR'=0):$p($g(^CT("CTPM",paymDR)),"^",2),1:"")
 	set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
 	set paymStr=paymDesc_":"_amount
 	
 	if (amount<0) {
		set refUsrName=usrName   //退费人员
	 	set rowId=$p(depData,"^",43)     //原发票rowid
	 	if (+rowId'=0) {
		 	set oldInvNo=$p($g(^DHCSFPRINTDETAIL(rowId)),"^",1)
		}
	 	set backDate=invDate   //退费日期
	}
 	do OutputInvList
 	quit
 	
GetInvInfo(prtRowId, PayMode, PatType)
	set prtInvData=$g(^DHCINVPRTZY(prtRowId))
	set refUsrName="", backDate="", oldInvNo="", insuCardNo="", insuAccPayAmt="", insuPayAmt=""
	set hospDR=$p(prtInvData,"^",35)
 	quit:(hospDR'=hospId)
 	set usrDR=$p(prtInvData,"^",7)
 	quit:((guser'="")&&(guser'=usrDR))
	set usrName=$p(^SSU("SSUSR",usrDR),"^",2)   //操作员
	set usrName=##class(User.SSUser).GetTranByDesc("SSUSRName", usrName, langId)
 	//判断被红冲
 	set prtStatus=$p(prtInvData,"^",8)
 	set strikeInvDR=$o(^DHCINVPRTZY(0,"InitInv",prtRowId,0))
	if (strikeInvDR>0) {
		set prtStrikeFlag=$p($g(^DHCINVPRTZY(strikeInvDR)),"^",8)
		if (prtStrikeFlag="S") {
			set prtStatus="BS"
		}
	}
 	quit:((rcptStatus'="")&&(prtStatus'=rcptStatus))
	set invStatus=$case(prtStatus,"N":"正常","A":"作废","S":"冲红","I":"中途结算","BS":"已冲红",:"")
 	set invStatus=##class(websys.Translation).Get("", invStatus, langId)
 	set invNo=$p(prtInvData,"^",1)      //票号
 	set adm=$p(prtInvData,"^",4)
 	set papmi=$p(^PAADM(adm),"^",1)
 	
 	;+add by gongxin 20230424 start 查询退院患者预交金明细
 	set PatStatusDR=$p(^PAADM(adm),"^",20)
 	quit:((PatStatus'=PatStatusDR)&&(PatStatus'=""))
 	set PatStatusDesc=$case(PatStatusDR,"C":"退院","A":"在院","D":"出院","P":"预约",:"")  ;+add by gongxin 20230505 多院区翻译
 	set PatStatusDesc=##class(websys.Translation).Get("", PatStatusDesc, langId) ;+add by gongxin 20230505 多院区翻译
 	;+add by gongxin 20230424 end
 	
 	//add 2011-01-08 tangtao
 	set admReaDR=$p(^PAADM(adm,1),"^",7)
	quit:((AdmReason'=admReaDR)&&(AdmReason'=""))
 	set nationalCode=$p(^PAC("ADMREA",admReaDR),"^",5)
 	set insType=$p(^PAC("ADMREA",admReaDR),"^",2)     //费别
 	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
 	set insuFlag=$s((+nationalCode=0):"N",1:"Y")
 	quit:((PatType'=insuFlag)&&(PatType'=""))
 	set patName=$p(^PAPER(papmi,"ALL"),"^",1)     //患者姓名
 	set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)     //登记号
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
 	set invDate=$p(prtInvData,"^",2)  //票据日期
 	set invDate=##class(websys.Conversions).DateLogicalToHtml(invDate)
 	set amount=$p(prtInvData,"^",6)          //金额
 	set amount=$fn(amount,"",2)
 	quit:((prtStatus="A")&&(+amount<0))
 	
    set pbDR=$p(prtInvData,"^",5)
 	set YBZFPayInfo=##class(web.DHCINSUPort).GetDivideByPBDr(prtRowId, pbDR)
 	set DivInfo=$p(YBZFPayInfo,"!",2)
 	set insuCardNo=$p(DivInfo,"^",13)
	set selfPayAmt=$p(DivInfo,"^",16)
	set insuAccPayAmt=$p(DivInfo,"^",29)
	set insuAccPayAmt=$fn(insuAccPayAmt,"",2)
	set insuPayAmt=$p(DivInfo,"^",32)
	set insuPayAmt=$fn(insuPayAmt,"",2)
	
 	if (+amount<0) {
		set oldInvNoRowId=$p(prtInvData,"^",13)            
	 	if (oldInvNoRowId'="") {
		 	set oldInvNo=$p(^DHCINVPRTZY(oldInvNoRowId),"^",1)   //原发票号
		 	set backDate=invDate   //退费日期
		 	set refUsrName=usrName       //退费人员
	 	}
	}

	set paymFlag=(PayMode="")  //+hujunbin 2014-11-20
 	set paymStr=""
 	set paymSub=0
 	while($o(^DHCINVPRTZY(prtRowId,"P",paymSub))) {
	 	set paymSub=$o(^DHCINVPRTZY(prtRowId,"P",paymSub))
	 	set paymData=$g(^DHCINVPRTZY(prtRowId,"P",paymSub))
	 	set paymDR=$p(paymData,"^",1)
		if ((PayMode'="")&&(paymDR=PayMode)) set paymFlag=1
	 	set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	 	set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
	 	set paymAmt=$p(paymData,"^",3)
	 	set paymAmt=$fn(paymAmt,"",2)
	 	set paymStr=$s((paymStr=""):paymDesc_":"_paymAmt,1:(paymStr_";"_paymDesc_":"_paymAmt))
 	}
 	quit:(paymFlag=0)
 	
 	do OutputInvList
 	
 	quit
 	
GetSPIInfo(prtRowId, PayMode, PatType)
	set summaryData=$g(^BILL.IP.SummaryPrtInvD(prtRowId))
	set oldInvNo="", refUsrName="", backDate="", insuCardNo="", insuAccPayAmt="", insuPayAmt=""
	set usrDR=$lg(summaryData,5)
	quit:((guser'="")&&(guser'=usrDR))
	set hospDR=$lg(summaryData,14)
	quit:(hospDR'=hospId)
	set usrName=$p(^SSU("SSUSR",usrDR),"^",2)
	set usrName=##class(User.SSUser).GetTranByDesc("SSUSRName", usrName, langId)
	set spiFlag=$lg(summaryData,6)
	//判断被红冲
	set strikeInvDR=$o(^BILL.IP.SummaryPrtInvI("InitDR",prtRowId,0))
	if (strikeInvDR>0) {
		set spiStrikeFlag=$lg(^BILL.IP.SummaryPrtInvD(strikeInvDR),6)
		if (spiStrikeFlag="S") {
			set spiFlag="BS"
		}
	}
 	quit:((rcptStatus'="")&&(spiFlag'=rcptStatus))
 	set invStatus=$case(spiFlag,"N":"正常","A":"作废","S":"冲红","I":"中途结算","BS":"已冲红",:"")
 	set invStatus=##class(websys.Translation).Get("", invStatus, langId)
 	set invNo=$lg(summaryData,2)
 	set adm=$lg(summaryData,3)
	set papmi=$lg(summaryData,4)
	
	;+add by gongxin 20230424 start 查询退院患者预交金明细
 	set PatStatusDR=$p(^PAADM(adm),"^",20)
 	quit:((PatStatus'=PatStatusDR)&&(PatStatus'=""))
 	set PatStatusDesc=$case(PatStatusDR,"C":"退院","A":"在院","D":"出院","P":"预约",:"")  ;+add by gongxin 20230505 多院区翻译
 	set PatStatusDesc=##class(websys.Translation).Get("", PatStatusDesc, langId) ;+add by gongxin 20230505 多院区翻译
 	;+add by gongxin 20230424 end
 	
 	
	set admReaDR=$p(^PAADM(adm,1),"^",7)
	quit:((AdmReason'=admReaDR)&&(AdmReason'=""))
	set nationalCode=$p(^PAC("ADMREA",admReaDR),"^",5)
 	set insType=$p(^PAC("ADMREA",admReaDR),"^",2)    //费别
 	set insType=##class(User.PACAdmReason).GetTranByDesc("READesc", insType, langId)
 	set insuFlag=$s((+nationalCode=0):"N",1:"Y")
 	quit:((PatType'=insuFlag)&&(PatType'=""))
 	set patName=$p(^PAPER(papmi,"ALL"),"^",1)        //患者姓名
 	set regNo=$p(^PAPER(papmi,"PAT",1),"^",1)        //登记号
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(adm, "I", "")
 	set invDate=$lg(summaryData,7)  //票据日期
 	set invDate=##class(websys.Conversions).DateLogicalToHtml(invDate)
 	set conPrt=##class(BILL.IP.BL.SummaryPrtInv).GetPrtRowIdStrBySPI(prtRowId)
 	set amount=$p(^DHCINVPRTZY(conPrt),"^",6)          //金额
 	set amount=$fn(amount,"",2)
 	quit:((spiFlag="A")&&(+amount<0))
 	if (spiFlag="S") {
	 	set oldInvNoRowId=$lg(summaryData,9)
	 	if (oldInvNoRowId'="") {
			set oldInvNo=$lg(^BILL.IP.SummaryPrtInvD(oldInvNoRowId),2)
		 	set backDate=invDate
		 	set refUsrName=usrName
		}
	}
 	
 	set pbDR=$p(^DHCINVPRTZY(conPrt),"^",5)
 	set YBZFPayInfo=##class(web.DHCINSUPort).GetDivideByPBDr(prtRowId, pbDR)
 	set DivInfo=$p(YBZFPayInfo,"!",2)
 	set insuCardNo=$p(DivInfo,"^",13)
	set selfPayAmt=$p(DivInfo,"^",16)
	set insuAccPayAmt=$p(DivInfo,"^",29)
	set insuAccPayAmt=$fn(insuAccPayAmt,"",2)
	set insuPayAmt=$p(DivInfo,"^",32)
	set insuPayAmt=$fn(insuPayAmt,"",2)
	
	set paymFlag=(PayMode="")  //+hujunbin 2014-11-20
 	set paymStr=""
 	set paymSub=0
 	while($o(^DHCINVPRTZY(conPrt,"P",paymSub))) {
	 	set paymSub=$o(^DHCINVPRTZY(conPrt,"P",paymSub))
	 	set paymData=$g(^DHCINVPRTZY(conPrt,"P",paymSub))
		set paymDR=$p(paymData,"^",1)
		if ((PayMode'="")&&(paymDR=PayMode)) set paymFlag=1
	 	set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
	 	set paymDesc=##class(User.CTPayMode).GetTranByDesc("CTPMDesc", paymDesc, langId)
	 	set paymAmt=$p(paymData,"^",3)
	 	set paymAmt=$fn(paymAmt,"",2)
	 	set paymStr=$s((paymStr=""):paymDesc_":"_paymAmt,1:(paymStr_";"_paymDesc_":"_paymAmt))
	}
	quit:(paymFlag=0)
 	
 	do OutputInvList
 	
 	quit

OutputInvList
	set Data=$lb(usrName,invType,invNo,patName,regNo,mrNo,invDate,amount,refUsrName,backDate,invStatus,oldInvNo,paymStr,insType,insuCardNo,insuAccPayAmt,insuPayAmt,PatStatusDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2019-11-28
/// Description: 查询费别(医保/非医保)
/// Input: insuFlag:是否医保标识(Y:医保, N:非医保)
/// Output:
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillInvDetailSearch","FindAdmReason","Y")
Query FindAdmReason(insuFlag As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindAdmReasonExecute(ByRef qHandle As %Binary, insuFlag As %String, hospId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set rowId=0
	while($o(^PAC("ADMREA",rowId))) {
		set rowId=$o(^PAC("ADMREA",rowId))
		set reaData=$g(^PAC("ADMREA",rowId))
		continue:(reaData="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_AdmReason", rowId, hospId)
		continue:(showFlag="N")
		set dateFrom=$p(reaData,"^",3)
		set dateTo=$p(reaData,"^",4)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))
		set nationalCode=$p(reaData,"^",5)
		continue:((insuFlag="Y")&&(+nationalCode=0))
		continue:((insuFlag="N")&&(+nationalCode>0))
		set reaDesc=$p(reaData,"^",2)
		set reaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", reaDesc, langId)
		do OutputAdmReason
	}
	
	quit $$$OK
	
OutputAdmReason 
    set Data=$lb(rowId,reaDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

}
