Class web.UDHCJFPRINTINV Extends BILL.COM.Abstract
{

/// Debug: w ##class(web.UDHCJFPRINTINV).GetPrintInfo("476", "R")
ClassMethod GetPrintInfo(PrtRowId As %String, RePrtFlag As %String) As %String
{
	set ^TMP("GetPrintInfo")=$lb(PrtRowId, RePrtFlag)
	set prtInvData=$g(^DHCINVPRTZY(PrtRowId))
	set invNo=$p(prtInvData,"^",1)
	set adm=$p(prtInvData,"^",4)
	set billId=$p(prtInvData,"^",5)
	set hospDR=$p(prtInvData,"^",35)
	set hospital=$s((+hospDR'=0):$p($g(^CT("HOSP",hospDR)),"^",2),1:"")
	set userDR=$p(prtInvData,"^",7)
	set deposit=$p(prtInvData,"^",22)
	set insTypeDR=$p(prtInvData,"^",9)
	set insType=$s((insTypeDR'=""):$p($g(^PAC("ADMREA",insTypeDR)),"^",2),1:"")
	set InvNum=##class(BILL.INV.BL.PrtExt).GetInvBusinessNo("I", PrtRowId)  //业务流水号
	set SPIDR=$p(prtInvData,"^",21)
	if (+SPIDR'=0) {
		//如果是集中打印发票，取集中打印发票信息
		set SPIData=$g(^BILL.IP.SummaryPrtInvD(SPIDR))
		set invNo=$lg(SPIData,2)
		set userDR=$lg(SPIData,5)
		set InvNum=##class(BILL.INV.BL.PrtExt).GetInvBusinessNo("IS", SPIDR)
	}
	set userCode=$s((userDR'=""):$p($g(^SSU("SSUSR",userDR)),"^",1),1:"")
	set userName=$s((userDR'=""):$p($g(^SSU("SSUSR",userDR)),"^",2),1:"")
	
	set patientId=$p(^PAADM(adm),"^",1)
	
	//取患者基本信息
	set patInfo=##class(BILL.COM.PAPatMas).GetPatientInfo(patientId, hospDR)
	set patJson=##class(%DynamicObject).%FromJSON(patInfo)
	
	//取患者就诊信息
	set admInfo=##class(BILL.COM.PAAdm).GetAdmInfo(adm)
	set admJson=##class(%DynamicObject).%FromJSON(admInfo)
	
	set InDays=##class(web.UDHCJFBaseCommon).GetPatAdmInDays(adm, billId)
	set DateF=$p(InDays,"^",1)
	set DateT=$p(InDays,"^",2)
	set Days=$p(InDays,"^",3)
	set FYear=$p(DateF,"-",1)
	set FMon=$p(DateF,"-",2)
	set FDay=$p(DateF,"-",3)
	set TYear=$p(DateT,"-",1)
	set TMon=$p(DateT,"-",2)
	set TDay=$p(DateT,"-",3)
	
	set Date=$zd(+$h,3)
	set PYear=$p(Date,"-",1)
	set PMon=$p(Date,"-",2)
	set PDay=$p(Date,"-",3)

	do ..SetCurrencyUnit(hospDR)	//+WangXQ 20230412 根据配置设置单位

	set txtDataParaO=##class(%DynamicObject).%New()
	do txtDataParaO.%Set("RegNo",patJson.PatientNo).%Set("patname",patJson.PatName)
	do txtDataParaO.%Set("sex",patJson.Sex).%Set("address",patJson.Address)
	do txtDataParaO.%Set("medcare",admJson.MedicareNo).%Set("inadmdate",DateF)
	do txtDataParaO.%Set("outadmdate",DateT).%Set("loc",admJson.Dept)
	do txtDataParaO.%Set("ward",admJson.Ward).%Set("Hospital",hospital)
	do txtDataParaO.%Set("AdmReason",insType).%Set("Days",Days)
	do txtDataParaO.%Set("FYear",FYear).%Set("FMon",FMon).%Set("FDay",FDay)
	do txtDataParaO.%Set("TYear",TYear).%Set("TMon",TMon).%Set("TDay",TDay)
	do txtDataParaO.%Set("TYear",TYear).%Set("TMon",TMon).%Set("TDay",TDay)
	do txtDataParaO.%Set("InvNo",invNo).%Set("UsrInvNum",InvNum)
	do txtDataParaO.%Set("userName",userName).%Set("userCode",userCode)
	do txtDataParaO.%Set("Date",$zdt($h,3,1)).%Set("PYear",PYear).%Set("PMon",PMon).%Set("PDay",PDay)
	do txtDataParaO.%Set("RePrint",$s((RePrtFlag="R"):"补打",1:""))
	do txtDataParaO.%Set("deposit",$fn(deposit,"",2)_%CurrencyUnit)

	set pbJsonStr=..GetPatBillData(billId)
	if (pbJsonStr'="") {
		set pbJsonObj=##class(%DynamicObject).%FromJSON(pbJsonStr)
		set iter=pbJsonObj.%GetIterator()
	   	while iter.%GetNext(.key, .value) {
	   		do txtDataParaO.%Set(key,value)
	   	}
	}
	
	//获取发票打印的住院收费大类信息
	set cateJsonStr=..GetCateData(billId)
	if (cateJsonStr'="") {
		set cateJsonObj=##class(%DynamicObject).%FromJSON(cateJsonStr)  //分类信息
		set iter=cateJsonObj.%GetIterator()
	   	while iter.%GetNext(.key, .value) {
	   		do txtDataParaO.%Set(key,value)
	   	}
	}

	//取患者结算时的补退支付方式的金额
	kill paymAry
	do ..GetPayMList(PrtRowId, .paymAry)
	set TKStr="", SKStr=""
	set paymDR=""
	while($o(paymAry(paymDR))) {
		set paymDR=$o(paymAry(paymDR))
		set paymAmt=+$g(paymAry(paymDR))
		set paymDesc=$p(^CT("CTPM",paymDR),"^",2)
		if (+paymAmt<0) {
			set TKStr=TKStr_" "_paymDesc_":"_$fn($zabs(paymAmt),"",2)_%CurrencyUnit
		}else {
			set SKStr=SKStr_" "_paymDesc_":"_$fn($zabs(paymAmt),"",2)_%CurrencyUnit
		}
	}
	do txtDataParaO.%Set("收",SKStr)
	do txtDataParaO.%Set("退",TKStr)
	
	set prtTxtInfo=##class(BILL.COM.XMLPrint).GetPrintTxtData(txtDataParaO)
	set listDataO=##class(%DynamicArray).%New()
	
	//+2022-06-01 ZhYW 打印内容留痕
	do ##class(BILL.COM.BL.PrintLog).XMLPrintLog($classname(), "GetPrintInfo", "IPChgInv", PrtRowId, txtDataParaO, listDataO, $lb(PrtRowId, RePrtFlag))
	
	//add by lml 2015-01-27 增加打印日志
	set myCondition="{PrtRowId:"""_PrtRowId_"""}"
	set myContent="{PrtRowId:"""_PrtRowId_"""InvNo:"""_invNo_"""}"
	set mySecretCode=patJson.SecCode
	set mylog=##class(web.DHCEventLog).EventLog("UDHCJFPAY.PrintFP", myCondition, myContent, mySecretCode)
	
	quit prtTxtInfo
}

/// Description: 根据账单号取结算时补退的支付方式信息
/// Debug: w ##class(web.UDHCJFPRINTINV).GetPayMList()
ClassMethod GetPayMList(prtRowId As %String, ByRef paymAry) As %String
{
	set paymSub=0
	while($o(^DHCINVPRTZY(prtRowId,"P",paymSub))) {
		set paymSub=$o(^DHCINVPRTZY(prtRowId,"P",paymSub))
		set paymSubData=$g(^DHCINVPRTZY(prtRowId,"P",paymSub))
		set paymDR=$p(paymSubData,"^",1)
		continue:(+paymDR=0)
		set paymAmt=$p(paymSubData,"^",3)
		set paymAry(paymDR)=$g(paymAry(paymDR))+paymAmt
	}
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2022-06-02
/// Description: 获取发票打印的账单金额信息
/// Input: billId:DHC_PatientBill.RowId
/// Return: json
/// Debug: w ##class(web.UDHCJFPRINTINV).GetPatBillData(1)
ClassMethod GetPatBillData(billId As %String) As %String
{
	set $zt="ERROR"
	quit:(+billId=0) "{}"
	
	set jsonObj=##class(%DynamicObject).%New()
	
	set pbData=$g(^DHCPB(billId))
	set totalAmt=$p(pbData,"^",8)    //总金额
	set totalAmt=$fn(totalAmt,"",2)
	set discAmt=$p(pbData,"^",9)      //折扣金额
	set discAmt=$fn(discAmt,"",2)
	set payOrAmt=$p(pbData,"^",11)      //记账金额
	set payOrAmt=$fn(payOrAmt,"",2)
	set patShareAmt=$p(pbData,"^",12)      //自费金额
    set patShareAmt=$fn(patShareAmt,"",2)
    
	set patShareAmtUP=##class(web.UDHCJFBaseCommon).RMBDXXZH(patShareAmt)
	set totalAmtUP=##class(web.UDHCJFBaseCommon).RMBDXXZH(totalAmt)
	
	do jsonObj.%Set("discAmt",discAmt_%CurrencyUnit).%Set("payOrAmt",payOrAmt_%CurrencyUnit)
	do jsonObj.%Set("patshare",patShareAmt_%CurrencyUnit).%Set("patshareUP",patShareAmtUP)
	do jsonObj.%Set("totalAmt",totalAmt_%CurrencyUnit).%Set("totalAmtUP",totalAmtUP)

	quit jsonObj.%ToJSON()

ERROR
	set $zt=""
	quit "{}"
}

/// Creator: ZhYW
/// CreatDate: 2022-06-02
/// Description: 获取发票打印的住院收费大类信息
/// Input: billId:DHC_PatientBill.RowId
/// Return: json
/// Debug: w ##class(web.UDHCJFPRINTINV).GetCateData(1)
ClassMethod GetCateData(billId As %String) As %String
{
	set $zt="ERROR"
	quit:(+billId=0) "{}"
	
	set adm=$p($g(^DHCPB(billId)),"^",1)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	
	kill subCateAry
	do ##class(BILL.IP.COM.Method).GetChgSubCateFee(billId, .subCateAry, "IC")
	
	kill cateAry
	set subCatId=0
	while($o(subCateAry("IC",subCatId))) {
		set subCatId=$o(subCateAry("IC",subCatId))
		set subCatData=$g(subCateAry("IC",subCatId))
		set cateDR=$p(^DHCTarC("IC",subCatId),"^",3)                 //住院费用大类
		set totalAmt=$lg(subCatData,1)
		set discAmt=$lg(subCatData,2)
		set payOrAmt=$lg(subCatData,3)
		set patShareAmt=$lg(subCatData,4)
		set $li(cateAry(cateDR),1)=$lg($g(cateAry(cateDR)),1)+totalAmt
		set $li(cateAry(cateDR),2)=$lg($g(cateAry(cateDR)),2)+discAmt
		set $li(cateAry(cateDR),3)=$lg($g(cateAry(cateDR)),3)+payOrAmt
		set $li(cateAry(cateDR),4)=$lg($g(cateAry(cateDR)),4)+patShareAmt
	}
	
	set jsonObj=##class(%DynamicObject).%New()

	set cateIdx=0
	set myMTip="CatL"
	set myFBTip="CatFee"
	set id=0
	while($o(^DHCTarC("TIC",id))) {
		set id=$o(^DHCTarC("TIC",id))
		set data=$g(^DHCTarC("TIC",id))
		continue:(data="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("DHC_TarIC", id, hospDR)
		continue:(showFlag="N")
		set cateDesc=$p(data,"^",2)
		set cateAmt=$lg($g(cateAry(id)),1)
		set cateIdx=$i(cateIdx)
		do jsonObj.%Set(myMTip_cateIdx, cateDesc).%Set(myFBTip_cateIdx, $fn(cateAmt,"",2)_%CurrencyUnit)
	}
	
	quit jsonObj.%ToJSON()

ERROR
	set $zt=""
	quit "{}"
}

/// Creator: WangXQ
/// CreatDate: 2023-04-12
/// Description: 取配置的发票金额货币单位值
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.UDHCJFPRINTINV).GetCfgCurrencyUnit(2)
ClassMethod GetCfgCurrencyUnit(hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.IPChrg.FPJEHBDW", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).value
	quit cfgData
}

/// Creator: WangXQ
/// CreatDate: 2023-04-12
/// Description: 根据配置修改全局变量%CurrencyUnit的值
/// Input: hospId: CT_Hospital.RowId
ClassMethod SetCurrencyUnit(hospId As %String) As %String
{
    set CurrencyUnit=##class(web.UDHCJFPRINTINV).GetCfgCurrencyUnit(hospId)
	set %CurrencyUnit=CurrencyUnit
}

}
