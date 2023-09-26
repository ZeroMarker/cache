/// 名称: web.DHCIPBillPatOrdFee.cls
/// 描述: 医嘱费用查询
/// 编写者: ZhYW
/// 编写日期: 2018-06-22
Class web.DHCIPBillPatOrdFee Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2018-06-26
/// Description: 根据登记号查询住院就诊信息
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPatOrdFee", "FindAdmList", "0000000005",2)
Query FindAdmList(patientId As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "adm:%String,admDate:%String,admTime:%String,admDept:%String")
{
}

ClassMethod FindAdmListExecute(ByRef qHandle As %Binary, patientId As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
	if (patientId="")  quit $$$OK
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set adm=""
	while($o(^PAPERdr(patientId,"ADM","I",adm),-1)) {
		set adm=$o(^PAPERdr(patientId,"ADM","I",adm),-1)
		set admData=$g(^PAADM(adm))
		continue:(admData="")
		set admDeptDR=$p(admData,"^",4)
		set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
		continue:(admHospDR'=hospId)
		set admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(adm)
		set admDate=$p(admInOutDateInfo,"^",1)
		set admTime=$p(admInOutDateInfo,"^",2)
		set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
		set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime, 1)
		set admDept=$s((+admDeptDR'=0):$p($g(^CTLOC(admDeptDR)),"^",2),1:"")
		set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
		do OutputAdmList
	}
	
	quit $$$OK
	
OutputAdmList
	set Data=$lb(adm,admDate,admTime,admDept)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-06-22
/// Description: 取未结算账单信息
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCIPBillPatOrdFee).GetUnPayedPBInfo(94)
ClassMethod GetUnPayedPBInfo(episodeId As %String) As %String
{
	set num=0
	set pbRowId=""
	quit:(+episodeId=0) num_"^"_pbRowId
	
	set pb=0
	while($o(^DHCPB(0,"ADM",episodeId,pb))) {
		set pb=$o(^DHCPB(0,"ADM",episodeId,pb))
		set payedFlag=$p(^DHCPB(pb),"^",16)
		continue:(payedFlag="P")
		set num=$i(num)
		set pbRowId=pb
	}

	quit num_"^"_pbRowId
}

/// Creator: ZhYW
/// CreatDate: 2018-06-22
/// Description: 根据婴儿Adm获取母亲Adm
/// Input: episodeId：婴儿就诊Id
/// Return：是否是婴儿的标志^母亲就诊id
/// Debug: w ##class(web.DHCIPBillPatOrdFee).GetMotherAdmByBabyAdm(723)
ClassMethod GetMotherAdmByBabyAdm(episodeId As %String) As %String
{
    set babyFlag="false"
	set motherDR=""
	quit:(+episodeId=0) babyFlag_"^"_motherDR
	
	set motherDR=$p(^PAADM(episodeId),"^",75)
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(episodeId)
	set conf=##class(web.DHCBillCommon).GetTarParaId(admHospDR)
	set newBornToMother=$s((+conf'=0):$p(^DHCTarC("CF",conf),"^",5),1:"")
    if ((+motherDR'=0)&&(newBornToMother="Y")) {
	    set babyFlag="true"
	}
    
    quit babyFlag_"^"_motherDR
}

/// Creator: ZhYW
/// CreatDate: 2018-06-22
/// Description: 根据登记号/住院号取最后一次住院就诊
/// Input: patientNo：登记号, medicareNo: 住院号
/// Return：
/// Debug: w ##class(web.DHCIPBillPatOrdFee).GetPatCurrAdm("129", "")
ClassMethod GetPatCurrAdm(patientNo As %String, medicareNo As %String, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set episodeId=""
	quit:((patientNo="")&&(medicareNo="")) episodeId
	
    set papmi=""
    if (patientNo'="") {
	    set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
	    set papmi=$o(^PAPERi("PAPMI_PatNo",patientNo,""))
	}else {
		set papmi=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(medicareNo, "I", hospId, "")
		if (+papmi'=0) {
			set patientNo=$p($g(^PAPER(papmi,"PAT",1)),"^",1)
		}
	}   
	quit:((+papmi=0)||('$d(^PAPER(papmi)))) episodeId
	
	set lastAdm=""
    set adm=""
    while($o(^PAPERdr(papmi,"ADM","I",adm),-1)&&(episodeId="")) {
	    set adm=$o(^PAPERdr(papmi,"ADM","I",adm),-1)
	    set admData=$g(^PAADM(adm))
    	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		continue:(admHospDR'=hospId)
		set lastAdm=adm
		set visitStatus=$p(admData,"^",20)
		continue:(visitStatus'="A")
		set episodeId=adm
	}
    
    if (+episodeId=0) {
	    set episodeId=lastAdm
	}
            
    quit episodeId
}

/// Creator: ZhYW
/// CreatDate: 2018-06-26
/// Description: 根据就诊取患者基本信息
/// Input: episodeId：就诊Id
/// Return：
/// Debug: w ##class(web.DHCIPBillPatOrdFee).GetPatInfoByAdm(3)
ClassMethod GetPatInfoByAdm(episodeId As %String) As %String
{
	set json=##class(%DynamicObject).%New()
	quit:(+episodeId=0) json.%ToJSON()
	set patientId=$p($g(^PAADM(episodeId)),"^",1)
	quit:(+patientId=0) json.%ToJSON()
	set jsonStr=##class(BILL.COM.PAPatMas).GetPatientInfo(patientId)
	set json=json.%FromJSON(jsonStr)
	set json.MedicareNo=##class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(episodeId, "I", "")
    quit json.%ToJSON()
}

/// Debug: w ##class(web.DHCIPBillPatOrdFee).GetPatPayInfoByAdm(2)
ClassMethod GetPatPayInfoByAdm(episodeId As %String) As %String
{
	set (deposit, totalAmt, balance, insuPayAmt, discAmt, payorAmt, patShareAmt, warrantAmt, notPayAmt)=0

	if (+episodeId'=0) {
		set deposit=##class(web.UDHCJFBaseCommon).deposit(episodeId)
		set warrantAmt=##class(web.UDHCJFZYDB).GetWarrAmt(episodeId)
		set payAmtStr=..GetPayAmt(episodeId)
		set totalAmt=$p(payAmtStr,"^",1)
		set insuPayAmt=$p(payAmtStr,"^",2)
		set discAmt=$p(payAmtStr,"^",4)
		set payorAmt=$p(payAmtStr,"^",5)
		set patShareAmt=$p(payAmtStr,"^",6)
		set notPayAmt=$p(payAmtStr,"^",7)
		set balance=deposit+warrantAmt-notPayAmt  //totalAmt 
		if (+insuPayAmt'=0) {
			set patShareAmt=totalAmt-insuPayAmt
			set balance=deposit-patShareAmt
		}
	 }
	 
	 set rtn=$fn(deposit,"",2)_"^"_$fn(totalAmt,"",2)_"^"_$fn(balance,"",2)_"^"_$fn(insuPayAmt,"",2)_"^"_$fn(discAmt,"",2)
	 set rtn=rtn_"^"_$fn(payorAmt,"",2)_"^"_$fn(patShareAmt,"",2)_"^"_$fn(warrantAmt,"",2)_"^"_$fn(notPayAmt,"",2)
	
	 quit rtn
}

ClassMethod GetPayAmt(episodeId As %String) As %String
{
	quit:(+episodeId=0) ""
	
	set (totalSum, insuPaySum, selfPaySum, discSum, payorSum, patShareSum, notPaySum)=0
	
	set pb=0
	while($o(^DHCPB(0,"ADM",episodeId,pb))) {
		set pb=$o(^DHCPB(0,"ADM",episodeId,pb))
		set pbData=$g(^DHCPB(pb))
    	set totalAmt=$p(pbData,"^",8)
   		set totalSum=$i(totalSum, totalAmt)
   		set discAmt=$p(pbData,"^",9)
   		set discSum=$i(discSum, discAmt)
   		set payorAmt=$p(pbData,"^",11)
   		set payorSum=$i(payorSum, payorAmt)
   		set patShareAmt=$p(pbData,"^",12)
    	set patShareSum=$i(patShareSum, patShareAmt)
    	set prtRowId=##class(BILL.IP.COM.Method).GetPrtInvIdByBill(pb)
    	if (prtRowId="") {
	    	//HIS未结算
    		set notPaySum=$i(notPaySum, patShareAmt)
		}
    	set insuPayAmt=##class(web.DHCINSUPort).GetDividePreByPBDr(pb)      //医保预结算
   		if (prtRowId'="") {
	   		//HIS已结算
    		set insuPayInfo=##class(web.DHCINSUPort).GetDivideByPBDr("", pb)       //+zhangli 2017-08-14 已经结算取结算数据
    		set insuStr=$p(insuPayInfo,"!^",2)
    		set insuTotalAmt=$p(insuStr,"^",7)	      //总费用
    		set insuSelfAmt=$p(insuStr,"^",15)        //医保自付(医保现金)
			set insuPayAmt=insuTotalAmt-insuSelfAmt
   		}
   		set insuPaySum=$i(insuPaySum, insuPayAmt)
	}
    
    set selfPaySum=patShareSum-insuPaySum  //自费金额
    
	set rtn=$fn(totalSum,"",2)_"^"_$fn(insuPaySum,"",2)_"^"_$fn(selfPaySum,"",2)_"^"_$fn(discSum,"",2)
	set rtn=rtn_"^"_$fn(payorSum,"",2)_"^"_$fn(patShareSum,"",2)_"^"_$fn(notPaySum,"",2)
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2018-06-22
/// Description: 查询医嘱明细
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPatOrdFee", "FindOrdDetail","39","","","","","^^^^^","18885^23^8^2^20")
Query FindOrdDetail(episodeId As %String, itmCateId As %String, arcimId As %String, recDeptId As %String, userDeptId As %String, expStr As %String, sessionStr As %String) As websys.Query(ROWSPEC = "TArcimDesc:%String:医嘱名称,TSeqNo:%String:医嘱序号,TSttDate:%String:医嘱日期,TSttTime:%String:医嘱时间,TDocName:%String:开单医生,TDocNatStdCode:%String:国家医师码,TStatus:%String:医嘱状态,TBillQty:%String:数量,TTotalAmt:%Float:金额,TDiscAmt:%Float:折扣金额,TPayOrAmt:%Float:记账金额,TPatShareAmt:%Float:自付金额,TPhQty:%String:药房打包,TDrugTCQty:%String:未发药数量,TPhReturnQty:%String:退药数量,TOrdItm:%String:医嘱ID,TPriorty:%String:医嘱优先级,TItmCatDesc:%String:医嘱大类,TPrescno:%String:处方号,TRecDeptName:%String:接收科室,TUserDeptName:%String:开单科室,TDspStatus:%String:发药状态,TNotBillNum:%String:未计费执行记录数量,TPhFreq:%String:频次,TBillCondition:%String:计费点,TFeeSource:%String:费用来源,TAdm:%String:就诊ID,TArcim:%String:医嘱项ID,TInsuFlag:%String:医保标识")
{
}

ClassMethod FindOrdDetailExecute(ByRef qHandle As %Binary, episodeId As %String, itmCateId As %String, arcimId As %String, recDeptId As %String, userDeptId As %String, expStr As %String, sessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("FindOrdDetail")=$lb(episodeId, itmCateId, arcimId, recDeptId, userDeptId, expStr, sessionStr)
    if (+episodeId=0)||('$d(^PAADM(episodeId)))  quit $$$OK
	
	set admType=$p($g(^PAADM(episodeId)),"^",2)
	if (admType'="I") quit $$$OK
    
	set billStatus=$p(expStr,"^",1)
	set tarItmId=$p(expStr,"^",2)
    set stDate=$p(expStr,"^",3)
    set endDate=$p(expStr,"^",4)
    set stTime=$p(expStr,"^",5)
    set endTime=$p(expStr,"^",6)

    set userId=$p(sessionStr,"^",1)
    set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
 	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
 	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
 	set stTime=##class(websys.Conversions).TimeHtmlToLogical(stTime, 1)
 	set endTime=##class(websys.Conversions).TimeHtmlToLogical(endTime, 1)
	
	set insTypeDR=$p($g(^PAADM(episodeId,1)),"^",7)   //就诊费别

	set (allQtySum, allTotalSum, allDiscSum, allPayOrSum, allPatShareSum)=0
	set (trans2IPQtySum, trans2IPTotalSum, trans2IPDiscSum, trans2IPayOrSum, trans2IPPatShareSum)=0   //急诊转住院费用合计金额
	
	set feeFlag=""
	do GetOrdDtl(episodeId)
 
 	//婴儿费用
 	set conf=##class(web.DHCBillCommon).GetTarParaId(hospId)
 	set newBornToMother=$s((+conf'=0):$p($g(^DHCTarC("CF",conf)),"^",5),1:"")
 	set isContainBabyFee=($d(^PAADMi("Mother",episodeId))&&(newBornToMother="Y"))  //是否包含新生儿费用(1:是，0:否)
 	
 	if (isContainBabyFee) {
	 	set babyAdm=0
	 	while($o(^PAADMi("Mother",episodeId,babyAdm))) {
		 	set babyAdm=$o(^PAADMi("Mother",episodeId,babyAdm))
		 	do InitOrdData
 			do GetOrdDtl(babyAdm)
		}
	}
	
	//门诊转住院费用
	set feeFlag="OP"
	set hasOP2IPOrd=0
	set opAdm=""
	while($o(^DHCOPIPADMCON(0,"IPADM",episodeId,"OPADM",opAdm),-1)) {
		set opAdm=$o(^DHCOPIPADMCON(0,"IPADM",episodeId,"OPADM",opAdm),-1)
		set myOPAdm=""
		set ociId=""
		while($o(^DHCOPIPADMCON(0,"IPADM",episodeId,"OPADM",opAdm,ociId),-1)&&(myOPAdm="")) {
			set ociId=$o(^DHCOPIPADMCON(0,"IPADM",episodeId,"OPADM",opAdm,ociId),-1)
			set ociData=$g(^DHCOPIPADMCON(ociId))
			set status=$p(ociData,"^",7)
			continue:(status'="N")
			set myOPAdm=opAdm
		}
		continue:(myOPAdm="")
		do InitOrdData
		set hasOP2IPOrd=1
		do GetOrdDtl(myOPAdm)
	}
	
	//婴儿急诊转住院医嘱
	if (isContainBabyFee) {
		set babyAdm=0
		while($o(^PAADMi("Mother",episodeId,babyAdm))) {
			set babyAdm=$o(^PAADMi("Mother",episodeId,babyAdm))
			set opAdm=""
			while($o(^DHCOPIPADMCON(0,"IPADM",babyAdm,"OPADM",opAdm),-1)) {
				set opAdm=$o(^DHCOPIPADMCON(0,"IPADM",babyAdm,"OPADM",opAdm),-1)
				set myOPAdm=""
				set ociId=""
				while($o(^DHCOPIPADMCON(0,"IPADM",babyAdm,"OPADM",opAdm,ociId),-1)&&(myOPAdm="")) {
					set ociId=$o(^DHCOPIPADMCON(0,"IPADM",babyAdm,"OPADM",opAdm,ociId),-1)
					set ociData=$g(^DHCOPIPADMCON(ociId))
					set status=$p(ociData,"^",7)
					continue:(status'="N")
					set myOPAdm=opAdm
				}
				continue:(myOPAdm="")
				do InitOrdData
				set hasOP2IPOrd=1
				do GetOrdDtl(myOPAdm)
			}
		}
	}
	
	if (hasOP2IPOrd) {
		do InitOrdData
		set arcimDesc=##class(websys.Translation).Get("", "门诊费用转住院合计", langId)
		set billQty=$fn(trans2IPQtySum,"N")   		//HuangYW 2023-03-14 数量合计
		set itmTotalAmt=$fn(trans2IPTotalSum,"",2)
		set itmDiscAmt=$fn(trans2IPDiscSum,"",2) 
		set itmPayOrAmt=$fn(trans2IPayOrSum,"",2) 
		set itmPatShareAmt=$fn(trans2IPPatShareSum,"",2)
		set ^CacheTemp(repid,ind)=$$GetOrdData()
	 	set ind=$i(ind)
	}
	
	if (isContainBabyFee || hasOP2IPOrd) {
		do InitOrdData
		set arcimDesc=##class(websys.Translation).Get("", "总合计", langId)
		set billQty=$fn(allQtySum,"N") 			//HuangYW 2023-03-14 数量合计
		set itmTotalAmt=$fn(allTotalSum,"",2)
		set itmDiscAmt=$fn(allDiscSum,"",2)
		set itmPayOrAmt=$fn(allPayOrSum,"",2)
		set itmPatShareAmt=$fn(allPatShareSum,"",2)
		set ^CacheTemp(repid,ind)=$$GetOrdData()
	 	set ind=$i(ind)
	}

	quit $$$OK
	
GetOrdDtl(adm)
	quit:(+adm=0)
	
	set ord=$o(^OEORD(0,"Adm",+adm,0))
	quit:(+ord=0)
	set rtn=##class(web.UDHCJFBILL).BILLN(adm, 1)
	set (qtySum, totalSum, patShareSum, payorSum, discSum)=0
	
	kill ordList
	
	set itm=0
	while($o(^OEORD(ord,"I",itm))) {
		set itm=$o(^OEORD(ord,"I",itm))
		continue:('$d(^OEORD(ord,"I",itm,1)))
		set oeitm=ord_"||"_itm
		set isOP2IP=0
		if (feeFlag="OP") {
			set isOP2IP=##class(web.UDHCJFBILLIP).OrdIsOPToIPByIPAdm(episodeId, oeitm)
			continue:(isOP2IP'=1)
		}
		do InitOrdData
		set ordItm=oeitm
		set mOEORIDR=$p($g(^OEORD(+ord,"I",itm,11)),"^",39)
		set arcim=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
		continue:((arcimId'="")&&(arcimId'=arcim))
		//2022-03-08 ZhYW 增加按收费项过滤
		if (tarItmId'="") {
			kill tarAry
			do ..GetOrdTarItm(oeitm, .tarAry)
			continue:('$d(tarAry(tarItmId)))
		}
		//2022-12-05 wzh 增加医保标识
		set insuFlag=$p(##class(web.DHCINSUPort).ArcimLinkInsu(arcim, insTypeDR, hospId),"^",1)
		set insuFlag=$s((("^甲类^乙类^")[("^"_insuFlag_"^")):"是",(("^丙类^")[("^"_insuFlag_"^")):"是",1:"")
		set arcimDesc=$p((^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",2)
		set arcimDesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc", arcimDesc, langId)
		set depProcNotes=$g(^OEORD(ord,"I",itm,"DEP",1))   //医嘱备注
		if (depProcNotes'="") set arcimDesc=arcimDesc_"("_depProcNotes_")"
		set isAppRep=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
		if (isAppRep="Y") {
			set partDesc=##class(web.DHCAPPInterface).GetExaReqPartDesc(oeitm)
			set arcimDesc=arcimDesc_partDesc      //名称 + 部位
		}
		set itmSubCatDR=$p($g(^ARCIM(+arcim,$p(arcim,"||",2),1)),"^",10)
		set itmCatDR=$p(^ARC("IC",itmSubCatDR),"^",8)          //ARC_ItemCat.ARCIC_OrdCat_DR
		continue:((+itmCateId'=0)&&(itmCateId'=itmCatDR))
		set arcimType=$p(^ARC("IC",itmSubCatDR),"^",7)
		set itmCatDesc=$p(^OEC("ORCAT",itmCatDR),"^",2)        //OEC_OrderCategory.ORCAT_Desc
		set itmCatDesc=##class(User.OECOrderCategory).GetTranByDesc("ORCATDesc", itmCatDesc, langId)
		set userAddDR=$p($g(^OEORD(ord,"I",itm,7)),"^",1)   //OEORI_UserAdd
		set docName=$s((+userAddDR'=0):$p($g(^SSU("SSUSR",userAddDR)),"^",2),1:"")
		set docName=##class(User.SSUser).GetTranByDesc("SSUSRName", docName, langId)
		set docNatStdCodeInfo=##class(web.DHCINSUPort).GetStdInfoByUserId(userAddDR, hospId)   //国家医师码
		set docNatStdCode=$p(docNatStdCodeInfo,"^",1)
		set recDeptDR=$p(^OEORD(ord,"I",itm,3),"^",6)
		continue:((recDeptId'="")&&(("^"_recDeptId_"^")'[("^"_recDeptDR_"^")))  //+WangXQ 20230214
		set recDeptName=$s((+recDeptDR'=0):$p($g(^CTLOC(recDeptDR)),"^",2),1:"")
		set recDeptName=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", recDeptName, langId)
		set userDeptDR=$p($g(^OEORD(ord,"I",itm,7)),"^",2)   //OEORI_UserDepartment_DR 开单科室
		continue:((userDeptId'="")&&(("^"_userDeptId_"^")'[("^"_userDeptDR_"^")))
		set userDeptName=$s((+userDeptDR'=0):$p($g(^CTLOC(userDeptDR)),"^",2),1:"")
		set userDeptName=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", userDeptName, langId)
		set sttDate=$p($g(^OEORD(ord,"I",itm,1)),"^",9)         //OEORI_SttDat
		set sttTime=$p($g(^OEORD(ord,"I",itm,1)),"^",10)        //OEORI_SttTim
		continue:((stDate'="")&&(sttDate<stDate))
		continue:((endDate'="")&&(sttDate>endDate))
		continue:((stTime'="")&&(stDate=sttDate)&&(sttTime<stTime))   //+2022-06-24 ZhYW 增加时间过滤条件
		continue:((endTime'="")&&(endDate=sttDate)&&(sttTime>endTime))
		set priorityDR=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
		set priorityCode=$s((+priorityDR'=0):$p($g(^OECPR(priorityDR)),"^",1),1:"")
		set priorty=$s((+priorityDR'=0):$p($g(^OECPR(priorityDR)),"^",2),1:"")
		set priorty=##class(User.OECPriority).GetTranByDesc("OECPRDesc", priorty, langId)
		set itmStatDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)      //OEORI_ItemStat_DR
		set itmStatCode=$s((+itmStatDR'=0):$p($g(^OEC("OSTAT",itmStatDR)),"^",1),1:"")
		set itmStat=$s((+itmStatDR'=0):$p($g(^OEC("OSTAT",itmStatDR)),"^",2),1:"")
		set itmStat=##class(User.OECOrderStatus).GetTranByDesc("OSTATDesc", itmStat, langId)
		set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)            //OEORI_Billed
		continue:((billStatus=0)&&(billed="P"))
		continue:((billStatus=1)&&(billed'="P"))
		set prescno=$p($g(^OEORD(ord,"I",itm,1)),"^",14)          //OEORI_PrescNo
		set seqNo=$p($g(^OEORD(ord,"I",itm,3)),"^",4)             //OEORI_SeqNo
		set phFreqDR=$p($g(^OEORD(ord,"I",itm,2)),"^",4)          //OEORI_PHFreq_DR
		set phFreq=$s((+phFreqDR'=0):$p($g(^PHCFR(phFreqDR)),"^",1),1:"")
		set drugTCQty=##class(web.DHCIPBillPayControl).GetOEORITCDsp(oeitm)   //医嘱剩余未发数量
		set drugTCQty=$s((+drugTCQty'=0):$fn(drugTCQty,"N"),1:"")
	 	set pb=0
	 	while($o(^DHCPBi(0,"OEORI",oeitm,pb))) {
		 	set pb=$o(^DHCPBi(0,"OEORI",oeitm,pb))
		 	set pbo=0
		 	while($o(^DHCPBi(0,"OEORI",oeitm,pb,pbo))) {
			 	set pbo=$o(^DHCPBi(0,"OEORI",oeitm,pb,pbo))
			 	set pboData=$g(^DHCPB(pb,"O",pbo))
			 	continue:(pboData="")
				set pboExecDR=$p(pboData,"^",20)
				continue:((feeFlag="OP")&&(pboExecDR=""))
				set pboBillQty=$p(pboData,"^",5)              //PBO_BillQty
				set pboRefundQty=$p(pboData,"^",6)            //PBO_RefundQty
				set pboQty=$i(pboBillQty, pboRefundQty)
				set pboTotalAmt=$p(pboData,"^",8)             //PBO_ToTalAmount
				set pboDiscAmt=$p(pboData,"^",9)              //PBO_DiscAmount
				set pboPayOrShareAmt=$p(pboData,"^",10)       //PBO_PayorShare
				set pboPatShareAmt=$p(pboData,"^",11)         //PBO_PatientShare
				set itmTotalAmt=$i(itmTotalAmt, pboTotalAmt)
				set itmDiscAmt=$i(itmDiscAmt, pboDiscAmt)
				set itmPayOrAmt=$i(itmPayOrAmt, pboPayOrShareAmt)
				set itmPatShareAmt=$i(itmPatShareAmt, pboPatShareAmt)
				set billQty=$i(billQty, pboQty)
			}
		}
		set itmTotalAmt=$fn(itmTotalAmt,"",2)
		set itmDiscAmt=$fn(itmDiscAmt,"",2)
		set itmPayOrAmt=$fn(itmPayOrAmt,"",2)
		set itmPatShareAmt=$fn(itmPatShareAmt,"",2)
		set billQty=$s((+billQty'=0):$fn(billQty,"N"),1:"")
		if (priorityCode'["OM") {
			set exec=0
			while($o(^OEORD(ord,"I",itm,"X",exec))) {
				set exec=$o(^OEORD(ord,"I",itm,"X",exec))
				set execData=$g(^OEORD(ord,"I",itm,"X",exec))
				continue:(execData="")
				set oeore=ord_"||"_itm_"||"_exec
				continue:((arcimType="R")&&(isOP2IP=1)&&('$d(^DHCOEDISQTY(0,"OEORE",oeore))))   //过滤急诊转住院,没有对应打包表记录的执行记录
				set billed=$p(execData,"^",6)
				if (" TB I "[(" "_billed_" ")) {
					set notBillNum=$i(notBillNum)
				}
			}
		}
		continue:((billStatus=2)&&(+notBillNum=0))
		if (arcimType="R") {
			set dspRowId=0
			while($o(^DHCOEDISQTY(0,"OEORI",oeitm,dspRowId))) {
				set dspRowId=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dspRowId))
				set dspData=$g(^DHCOEDISQTY(dspRowId))
				continue:(dspData="")
				set dspStatus=$p(dspData,"^",7)
				set dspQty=$p(dspData,"^",11)
				if (dspStatus="C") set phQty=$i(phQty,dspQty)
				if (dspStatus="R") set phReturnQty=$i(phReturnQty,dspQty)
			}
		}
		set phQty=$s((+phQty'=0):$fn(phQty,"N"),1:"")
		set phReturnQty=$s((+phReturnQty'=0):$fn(phReturnQty,"N"),1:"")
		set dspStatus=..GetDispensingStat(oeitm)
		set dspStatus=$case(dspStatus,"TC":"未发","C":"已发","PC":"部分发","R":"已退",:"")
		set dspStatus=##class(websys.Translation).Get("", dspStatus, langId)
		set billCondition=##class(BILL.IP.COM.Method).GetBillPoint(oeitm)
		set sttDate=##class(websys.Conversions).DateLogicalToHtml(sttDate)
		set sttTime=##class(websys.Conversions).TimeLogicalToHtml(sttTime, 1)
		set isBaby=$d(^PAADMi("Mother",episodeId,adm))
		set feeSource=$s((isOP2IP=1):"门诊转入",(isBaby=1):"婴儿费用",1:"本人费用")
		set feeSource=##class(websys.Translation).Get("", feeSource, langId)
		set mItm=$s((mOEORIDR'=""):$p(mOEORIDR,"||",2),1:itm)   //当前医嘱是子医嘱时，取到其主医嘱
		set ordList(arcimDesc,ord,mItm,itm)=$$GetOrdData()
	}
	
	//按医嘱分组输出明细
	set arcimDesc=""
	while($o(ordList(arcimDesc))'="") {
		set arcimDesc=$o(ordList(arcimDesc))
		set (subQtySum, subTotalSum, subDiscSum, subPayOrSum, subPatShareSum)=0  //HuangYW 2023-03-14 数量合计

		set mItm=0
		while($o(ordList(arcimDesc,ord,mItm))) {
			set mItm=$o(ordList(arcimDesc,ord,mItm))
			set itm=0
			while($o(ordList(arcimDesc,ord,mItm,itm))) {
				set itm=$o(ordList(arcimDesc,ord,mItm,itm))
				set data=$g(ordList(arcimDesc,ord,mItm,itm))
				set billQty=$lg(data,8)           //HuangYW 2023-03-14 数量
				set itmTotalAmt=$lg(data,9)
				set itmDiscAmt=$lg(data,10)
				set itmPayOrAmt=$lg(data,11)
				set itmPatShareAmt=$lg(data,12)
				set qtySum=$i(qtySum, billQty)    //HuangYW 2023-03-14 数量合计
				set totalSum=$i(totalSum, itmTotalAmt)
				set discSum=$i(discSum, itmDiscAmt)
				set payorSum=$i(payorSum, itmPayOrAmt)
				set patShareSum=$i(patShareSum, itmPatShareAmt)
				set subQtySum=$i(subQtySum, billQty)   //HuangYW 2023-03-14 数量小计
				set subTotalSum=$i(subTotalSum, itmTotalAmt)
				set subDiscSum=$i(subDiscSum, itmDiscAmt)
				set subPayOrSum=$i(subPayOrSum, itmPayOrAmt)
				set subPatShareSum=$i(subPatShareSum, itmPatShareAmt)
				//输出明细
				set ^CacheTemp(repid,ind)=data
			 	set ind=$i(ind)
			}
		}
		//按医嘱项小计
		do InitOrdData
		set seqNo=##class(websys.Translation).Get("", "小计", langId)
		set billQty=$fn(subQtySum,"N")      //HuangYW 2023-03-14 数量小计
		set itmTotalAmt=$fn(subTotalSum,"",2)
		set itmDiscAmt=$fn(subDiscSum,"",2)
		set itmPayOrAmt=$fn(subPayOrSum,"",2)
		set itmPatShareAmt=$fn(subPatShareSum,"",2)
		set ^CacheTemp(repid,ind)=$$GetOrdData()
 		set ind=$i(ind)
	}
	
	//合计
	do InitOrdData
	set allQtySum=$i(allQtySum, qtySum)   //HuangYW 2023-03-14 数量合计
	set allTotalSum=$i(allTotalSum, totalSum)
	set allDiscSum=$i(allDiscSum, discSum)
	set allPayOrSum=$i(allPayOrSum, payorSum)
	set allPatShareSum=$i(allPatShareSum, patShareSum)
	
	if (feeFlag="OP") {
		set trans2IPQtySum=$i(trans2IPQtySum, qtySum)  //HuangYW 2023-03-14 数量合计
		set trans2IPTotalSum=$i(trans2IPTotalSum, totalSum)
		set trans2IPDiscSum=$i(trans2IPDiscSum, discSum)
		set trans2IPayOrSum=$i(trans2IPayOrSum, payorSum)
		set trans2IPPatShareSum=$i(trans2IPPatShareSum, patShareSum)
		quit
	}
	
	//输出合计
	set billQty=$fn(qtySum,"N")  //HuangYW 2023-03-14 数量合计
	set itmTotalAmt=$fn(totalSum,"",2)
	set itmDiscAmt=$fn(discSum,"",2)
	set itmPayOrAmt=$fn(payorSum,"",2)
	set itmPatShareAmt=$fn(patShareSum,"",2)
	set papmi=$p($g(^PAADM(adm)),"^",1)
    set patName=$p($g(^PAPER(papmi,"ALL")),"^",1)
	set arcimDesc=patName_##class(websys.Translation).Get("", "合计", langId)
	set ^CacheTemp(repid,ind)=$$GetOrdData()
 	set ind=$i(ind)
	quit
	
GetOrdData()
	quit $lb(arcimDesc,seqNo,sttDate,sttTime,docName,docNatStdCode,itmStat,billQty,itmTotalAmt,itmDiscAmt,itmPayOrAmt,itmPatShareAmt,phQty,drugTCQty,phReturnQty,ordItm,priorty,itmCatDesc,prescno,recDeptName,userDeptName,dspStatus,notBillNum,phFreq,billCondition,feeSource,adm,arcim,insuFlag)

InitOrdData
	set (seqNo, sttDate, sttTime, docName, docNatStdCode, itmStat, billQty, prescno, phFreq, recDeptName, userDeptName, priorty)=""
	set (itmCatDesc, dspStatus, ordItm, billCondition, feeSource)=""
	set (notBillNum, phQty, phReturnQty, drugTCQty, insuFlag)=""
	set (itmTotalAmt, itmPatShareAmt, itmPayOrAmt, itmDiscAmt)=0
	quit
}

/// Description: 取发药状态
/// Debug: w ##class(web.DHCIPBillPatOrdFee).GetDispensingStat()
ClassMethod GetDispensingStat(oeitm As %String) As %String
{
	set dspStat=""
	quit:($l(oeitm,"||")'=2) dspStat
	set ord=+oeitm, itm=$p(oeitm,"||",2)
	set priorityDR=$p($g(^OEORD(ord,"I",itm,1)),"^",8)
	set priorityCode=$s(((+priorityDR'=0)):$p(^OECPR(priorityDR),"^",1),1:"")
	quit:(priorityCode["OM") "C"   //自备药视为已发
	set allC=1, allTC=1, returnFlag=0
	set dspRowId=0
	while($o(^DHCOEDISQTY(0,"OEORI",oeitm,dspRowId))) {
		set dspRowId=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dspRowId))
		set dspData=$g(^DHCOEDISQTY(dspRowId))
		continue:(dspData="")
		set dspStatus=$p(dspData,"^",7)
		if (dspStatus="R") set returnFlag=1
		if (dspStatus'="C") set allC=0
		if (dspStatus'="TC") set allTC=0
	}
	
	if allC=1,allTC=0 set dspStat="C"               //已发
	if allC=0,allTC=1 set dspStat="TC"              //未发
	if allC=0,allTC=0 set dspStat="PC"              //部分发
	if allC=0,allTC=0,returnFlag=1 set dspStat="R"  //已退
	
	quit dspStat
}

/// Creator: ZhYW
/// CreatDate: 2018-06-25
/// Description: 根据医嘱RowId查询执行记录信息
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPatOrdFee", "FindOrdExecInfo","11||324","","")
Query FindOrdExecInfo(ordItm As %String, stDate As %String, endDate As %String, langId As %String = "") As websys.Query(ROWSPEC = "TExecDate:%String:执行日期,TExecTime:%String:执行时间,TExecStatus:%String:执行状态,TExecUserName:%String:执行人,TExecStDate:%String:要求执行日期,TExecStTime:%String:要求执行时间,TBillTotalAmt:%Float:金额,TPBORowID:%String:账单医嘱ID,TBilled:%String,TBilledDesc:%String:计费状态,TFreeChargeFlag:%String:免费标识,TPhQty:%String:发药数量,TPhReturnQty:%String:退药数量,TOEORE:%String:执行记录ID,TConfFlag:%String:审核状态,TPriorty:%String:医嘱类型,TPriortyCode:%String")
{
}

ClassMethod FindOrdExecInfoExecute(ByRef qHandle As %Binary, ordItm As %String, stDate As %String, endDate As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindOrdExecInfo")=$lb(ordItm, stDate, endDate)
	;if ($l(ordItm,"||")'=2)  quit $$$OK
	if ordItm="" quit $$$OK
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
   	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
   	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	;set ord=+ordItm, itm=$p(ordItm,"||",2)
	
	;set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(ordItm)
	;set isOP2IP=##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(ordItm)
	set count=$l(ordItm,",")
	for i=1:1:count{		//+WangXQ 20230207 增加查询多条医嘱执行记录功能 
		set exec=0
		set ordItmStr=$p(ordItm,",",i)
		set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(ordItmStr)
		set isOP2IP=##class(web.DHCOPBillEmergTrans2IP).OrdIsOPToIPByOEORI(ordItmStr)
		set ord=+ordItmStr, itm=$p(ordItmStr,"||",2)
		while($o(^OEORD(ord,"I",itm,"X",exec))) {
			set exec=$o(^OEORD(ord,"I",itm,"X",exec))
			set execData=$g(^OEORD(ord,"I",itm,"X",exec))
			continue:(execData="")
			set oeore=ord_"||"_itm_"||"_exec
			continue:((ordCateType="R")&&(isOP2IP=1)&&('$d(^DHCOEDISQTY(0,"OEORE",oeore))))   //过滤急诊转住院,没有对应打包表记录的执行记录
			set CTPCPDR=$p(execData,"^",15)    //OEORE_CTPCP_DR
			set execUserName=$s((+CTPCPDR'=0):$p(^CTPCP(CTPCPDR,1),"^",2),1:"")   //执行人
			set execUserName=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc", execUserName, langId)
			set execStatusDR=$p(execData,"^",16)
			set execStatus=$s((+execStatusDR'=0):$p($g(^OEC("STAT",execStatusDR)),"^",2),1:"")
			set execStatus=##class(User.OECOrderAdminStatus).GetTranByDesc("STATDesc", execStatus, langId)
			set execDate=$p(execData,"^",19)
			set execTime=$p(execData,"^",20)                   //执行时间
			set execDate=##class(websys.Conversions).DateLogicalToHtml(execDate)
			set execTime=##class(websys.Conversions).TimeLogicalToHtml(execTime, 1)
			set execStDate=$p(execData,"^",1)                //OEORE_ExStDate 要求执行时间
			continue:((stDate'="")&&(execStDate<stDate))
			continue:((endDate'="")&&(execStDate>endDate))
			set execStTime=$p(execData,"^",2)        //OEORE_ExStTime
			set execStDate=##class(websys.Conversions).DateLogicalToHtml(execStDate)
			set execStTime=##class(websys.Conversions).TimeLogicalToHtml(execStTime, 1)
			set execStDatTime=execStDate_" "_execStTime
			set freeChargeFlag=$p($g(^OEORD(ord,"I",itm,"X",exec,"BILL")),"^",18)    //OEORE_FreeChargeFlag
			set billed=$p(execData,"^",6)
			set billedDesc=$case(billed,"TB":"未计费","B":"已计费","I":"需退费","R":"已退费","P":"已结算",:$case(freeChargeFlag,"Y":"免费",:"状态未知"))
			set billedDesc=##class(websys.Translation).Get("", billedDesc, langId)
			set priorityDR=$p($g(^OEORD(ord,"I",itm,1)),"^",8)				//医嘱类型 +WangXQ 20230411
			set priorty=$s((+priorityDR'=0):$p($g(^OECPR(priorityDR)),"^",2),1:"")
			set priorty=##class(User.OECPriority).GetTranByDesc("OECPRDesc", priorty, langId)
			set priortyCode=$s((+priorityDR'=0):$p($g(^OECPR(priorityDR)),"^",1),1:"")
			set billTotalAmt=0
			set pboRowId=$p($g(^OEORD(ord,"I",itm,"X",exec,"BILL")),"^",2)
			if (pboRowId'="") {
				set pboData=$g(^DHCPB(+$p(pboRowId,"||",1),"O",+$p(pboRowId,"||",2)))
				set billTotalAmt=+$p(pboData,"^",8)
			}
			set billTotalAmt=$fn(billTotalAmt,"",2)
			set phQty=0, phReturnQty=0
			set dspRowId=0
			while($o(^DHCOEDISQTY(0,"OEORE",oeore,dspRowId))) {
				set dspRowId=$o(^DHCOEDISQTY(0,"OEORE",oeore,dspRowId))
				set dspData=$g(^DHCOEDISQTY(dspRowId))
				set dspStatus=$p(dspData,"^",7)
				set dspQty=$p(dspData,"^",11)    //DSP_ConfirmQty
				if (dspStatus="C") set phQty=$i(phQty, dspQty)
				if (dspStatus="R") set phReturnQty=$i(phReturnQty, dspQty)
			}
			if (+phQty'=0) set phQty=$fn(phQty,"N")
			if (+phReturnQty'=0) set phReturnQty=$fn(phReturnQty,"N")
			set confFlag=""
			if (pboRowId'="") {
				set confDR=$o(^DHCIPBillPatFeeConfirmi(0,"PBO",pboRowId,""),-1)
				set conSub=$s((confDR'=""):$o(^DHCIPBillPatFeeConfirmi(0,"PBO",pboRowId,confDR,""),-1),1:"")
				if (conSub'="") set confFlag=$p(^DHCIPBillPatFeeConfirm(confDR,"O",conSub),"^",3)
				set confFlag=$case(confFlag,"R":"撤销审核","C":"审核","D":"拒绝",:"")
				set confFlag=##class(websys.Translation).Get("", confFlag, langId)
			}
			do OutputOrdExecInfo
		}
	}
	quit $$$OK
	
OutputOrdExecInfo
	set Data=$lb(execDate,execTime,execStatus,execUserName,execStDate,execStTime,billTotalAmt,pboRowId,billed,billedDesc,freeChargeFlag,phQty,phReturnQty,oeore,confFlag,priorty,priortyCode)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-06-25
/// Description: 根据账单医嘱RowId查询收费项明细
/// Input:
/// Output:
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCIPBillPatOrdFee", "FindTarInfo","264632||1")
Query FindTarInfo(pboRowId As %String, langId As %String = "") As websys.Query(ROWSPEC = "TTarItmDesc:%String:收费项名称,TUomDesc:%String:单位,TPrice:%Float:单价,TQty:%String:数量,TTotalAmt:%Float:金额,TPatShareAmt:%Float:自付金额,TDiscAmt:%Float:折扣金额,TPayorShareAmt:%Float:记账金额,TBillDate:%String:计费日期,TBillTime:%String:计费时间,TConfFlag:%String:审核标识")
{
}

ClassMethod FindTarInfoExecute(ByRef qHandle As %Binary, pboRowId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
    set ind=1
	if ($l(pboRowId,"||")'=2) quit $$$OK
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set refundFlag=$p(^DHCPB(+pboRowId),"^",17)
    set oeore=$p(^DHCPB(+pboRowId,"O",$p(pboRowId,"||",2)),"^",20)
	//Lid 2017-04-13 修改，解决问题：出院结算->召回->作废医嘱->重新生成账单，后医嘱费用查询界面显示负数的问题。
	//此处通过执行记录循环查询一下
	if (refundFlag="R") {
		set pb=0
		while($o(^DHCPB(0,"OEEXC",oeore,pb))) {
			set pb=$o(^DHCPB(0,"OEEXC",oeore,pb))
			set pbo=0
			while($o(^DHCPB(0,"OEEXC",oeore,pb,pbo))) {
				set pbo=$o(^DHCPB(0,"OEEXC",oeore,pb,pbo))
				set pboData=$g(^DHCPB(pb,"O",pbo))
				do GetTarItmInfo
			}
		}
	}else {
		set pb=+pboRowId
		set pbo=$p(pboRowId,"||",2)
		do GetTarItmInfo
	}
	
	quit $$$OK

GetTarItmInfo
	set pbd=0
	while($o(^DHCPB(pb,"O",pbo,"D",pbd))) {
		set pbd=$o(^DHCPB(pb,"O",pbo,"D",pbd))
		set pbdData=$g(^DHCPB(pb,"O",pbo,"D",pbd))
	 	continue:(pbdData="")
		set pbdRowId=pb_"||"_pbo_"||"_pbd
		set tarItmDR=$p(pbdData,"^",3)
	 	continue:(+tarItmDR=0)
	 	set tarUomDR=$p($g(^DHCTARI(tarItmDR)),"^",3)
	 	set uomDesc=$s((+tarUomDR'=0):$p($g(^CT("UOM",tarUomDR)),"^",2),1:"")
	 	set uomDesc=##class(User.CTUOM).GetTranByDesc("CTUOMDesc", uomDesc, langId)
	 	set tarItmDesc=$p(^DHCTARI(tarItmDR),"^",2)
	 	set tarItmDesc=##class(User.DHCTarItem).GetTranByDesc("TARIDesc", tarItmDesc, langId)
	  	set price=$p(pbdData,"^",4) //PBD_UnitPrice
	  	set price=$fn(price,"",4)
	 	set qty=$p(pbdData,"^",5)   //PBD_BillQty
	 	set qty=$fn(qty,"N")
		set totalAmt=$p(pbdData,"^",7)
		set totalAmt=$fn(totalAmt,"",2)
		set discAmt=$p(pbdData,"^",8)
		set discAmt=$fn(discAmt,"",2)
		set payorAmt=$p(pbdData,"^",9)
		set payorAmt=$fn(payorAmt,"",2)
		set patShareAmt=$p(pbdData,"^",10)
		set patShareAmt=$fn(patShareAmt,"",2)
		set billDate=$p(pbdData,"^",11)
		set billDate=##class(websys.Conversions).DateLogicalToHtml(billDate)
		set billTime=$p(pbdData,"^",12)
		set billTime=##class(websys.Conversions).TimeLogicalToHtml(billTime, 1)
		set confDR=$o(^DHCIPBillPatDetailConfirm(0,"PatDetail",pbdRowId,0))
		set confFlag=$s((+confDR'=0):$p(^DHCIPBillPatDetailConfirm(confDR),"^",8),1:"")
		set confFlag=$case(confFlag,"R":"撤销审核","C":"审核","D":"拒绝",:"")
		set confFlag=##class(websys.Translation).Get("", confFlag, langId)
		do OutputTarItmInfo
	}

	quit
		
OutputTarItmInfo
	set Data=$lb(tarItmDesc,uomDesc,price,qty,totalAmt,patShareAmt,discAmt,payorAmt,billDate,billTime,confFlag)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: tangzf
/// CreatDate: 2019-10-23
/// Description: 取有效账单信息(未取消结算的)
/// Input: episodeId:就诊号
/// Return: 账单数量_"^"_最后一条有效账单id
/// Debug: w ##class(web.DHCIPBillPatOrdFee).GetValidPBInfo(6)
ClassMethod GetValidPBInfo(episodeId As %String) As %String
{
	set num=0
	set pbRowId=""
	quit:(+episodeId=0) num_"^"_pbRowId
	
	set pb=0
	while($o(^DHCPB(0,"ADM",episodeId,pb))) {
		set pb=$o(^DHCPB(0,"ADM",episodeId,pb))
		set pbData=$g(^DHCPB(pb))
		set refundFlag=$p(pbData,"^",17)
		continue:(refundFlag'="")
		set num=$i(num)
		set pbRowId=pb
	}

	quit num_"^"_pbRowId
}

/// Creator: ZhYW
/// CreatDate: 2022-03-08
/// Description: 医嘱对应收费项
/// Input: oeitm:OE_OrdItem.RowId
/// Return: 
/// Debug: w ##class(web.DHCIPBillPatOrdFee).GetOrdTarItm("885||8", .tarAry)
ClassMethod GetOrdTarItm(oeitm As %String, ByRef tarAry) As %String
{
	quit:(+oeitm=0) 0
	
	set ord=$p(oeitm,"||",1)
	set itm=$p(oeitm,"||",2)
	set arcim=$p($g(^OEORD(ord,"I",itm,1)),"^",2)
	set dateH=$p($g(^OEORD(ord,"I",itm,1)),"^",19)    //OEORI_InsertDate
	
	set isAppRepFlag=##class(web.UDHCJFPRICE).IsAppRepOrder(oeitm)
	if (isAppRepFlag="Y") {
		set ordBillFlag=$p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),3),"^",5)
		set tari=0
		while($o(^DHCAPREPTA(0,"OrdTar",oeitm,tari))) {
			set tari=$o(^DHCAPREPTA(0,"OrdTar",oeitm,tari))
			set tarAry(tari)=""
		}
		quit 0
	}
	
	set ordCateType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
	if (ordCateType="R") {
		set dsp=0
		while($o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))) {
			set dsp=$o(^DHCOEDISQTY(0,"OEORI",oeitm,dsp))
			set dspb=0
			while($o(^DHCOEDISQTY(dsp,"I",dspb))) {
				set dspb=$o(^DHCOEDISQTY(dsp,"I",dspb))
				set dspbData=$g(^DHCOEDISQTY(dsp,"I",dspb))
				continue:(dspbData="")
				set inciDR=$p(dspbData,"^",5)        //DSPB_INCI_DR
				set clt=0
				while($o(^DHCINCTARi("INCI",inciDR,clt))) {
					set clt=$o(^DHCINCTARi("INCI",inciDR,clt))
					set cltData=$g(^DHCINCTAR(clt))
					set stDate=$p(cltData,"^",4)
					set endDate=$p(cltData,"^",5)
					continue:((dateH<stDate)||((endDate'="")&&(dateH>endDate)))
					set tari=$p(cltData,"^",2)
					set tarAry(tari)=""
				}
			}
		}

		quit 0
	}
	
	set stDate=0
	while($o(^DHCOLT(0,"ARCIM",arcim,"Z",stDate))) {
		set stDate=$o(^DHCOLT(0,"ARCIM",arcim,"Z",stDate))
		continue:(stDate>dateH)
		set olt=0
		while($o(^DHCOLT(0,"ARCIM",arcim,"Z",stDate,olt))) {
			set olt=$o(^DHCOLT(0,"ARCIM",arcim,"Z",stDate,olt))
			set oltData=$g(^DHCOLT(olt))
			set endDate=$p(oltData,"^",5)
			continue:((endDate'="")&&(endDate<dateH))
			set tari=$p(oltData,"^",2)
			set tarAry(tari)=""
		}
	}
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2023-03-15
/// Description: 取接收科室是否允许多选配置
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->住院收费系统->医嘱费用查询->接收科室是否允许多选
/// Debug: w ##class(web.DHCIPBillPatOrdFee).IsRecDeptMulti(2)
ClassMethod IsRecDeptMulti(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.DrOrdFeeQury.JSKSSFYXDX", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: ZhYW
/// CreatDate: 2023-03-15
/// Description: 取开单科室是否允许多选配置
/// Input: hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Others: 通用配置->住院收费系统->医嘱费用查询->开单科室是否允许多选
/// Debug: w ##class(web.DHCIPBillPatOrdFee).IsUserDeptMulti(2)
ClassMethod IsUserDeptMulti(hospId As %String) As %String
{
	set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode("IPCHRG.DrOrdFeeQury.KDKSSFYXDX", "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

}
