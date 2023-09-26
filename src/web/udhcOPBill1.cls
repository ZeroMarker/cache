Class web.udhcOPBill1 Extends %RegisteredObject
{

/// 此处只是返回OE_OrdItm表的RowID
/// 也可以生成一个临时Global
/// Debug: w ##class(web.udhcOPBill1).GetOrderByOERowID("31","","","")
ClassMethod GetOrderByOERowID(OrderRowid As %String, AdmInsType As %String, UnBillStr As %String, RecLocStr As %String) As %String
{
	set OERIDStr=""
	
	set adm=$p($g(^OEORD(OrderRowid)),"^",1)
	set hospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm) 
	
	set itemsub=0
	for  set itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) quit:(itemsub="")  do
	.set OEORIRowid=OrderRowid_"||"_itemsub
	.quit:(("^"_UnBillStr_"^")[("^"_OEORIRowid_"^"))
	.set billed=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
	.quit:(" P I "[(" "_billed_" "))
	.set itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	.set statcode=$s((+itemstat'=0):$p($g(^OEC("OSTAT",itemstat)),"^",1),1:"")
	.quit:(" V E "'[(" "_statcode_" "))
	.set InsTypeDR=##class(web.DHCBillCons1).GetCurrentOrdInsType(OEORIRowid, AdmInsType, hospDR)  //+2018-08-31 ZhYW
	.quit:((AdmInsType'="")&&(AdmInsType'=InsTypeDR))
	.set recdepcode=$p($g(^OEORD(+OrderRowid,"I",+itemsub,3)),"^",6)  ;接收科室
	.quit:((RecLocStr'="")&&(RecLocStr'[("^"_recdepcode_"^")))
	.set OERIDStr=OERIDStr_"^"_OEORIRowid
	
	if (OERIDStr'="") do
	.set OERIDStr=OERIDStr_"^"
	
	quit OERIDStr
}

/// Debug: w ##class(web.udhcOPBill1).GetnobilledCount("7^8","")
ClassMethod GetnobilledCount(PAADMStr As %String = "", UnBillStr As %String, RecDepStr As %String) As %String
{
	set nCount=0

	for i=1:1:$l(PAADMStr,"^") do
	.set PAADMRowid=$p(PAADMStr,"^",i)
	.quit:(+PAADMRowid=0)
	.set OrderRowid=$o(^OEORD(0,"Adm",+PAADMRowid,""))
	.quit:(+OrderRowid=0)
	.set itemsub=0
	.for  set itemsub=$o(^OEORD(OrderRowid,"I",itemsub)) quit:(itemsub="")  do
	..quit:(("^"_UnBillStr_"^")[("^"_OrderRowid_"||"_itemsub_"^"))
	..set billed=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
	..quit:(" P I "[(" "_billed_" "))
	..//set InsTypeDR=$p(^OEORD(+OrderRowid,"I",itemsub,11),"^",18) ;OEORI_BBExtCode
	..//quit:(AdmReason'="")&&(InsTypeDR'=AdmReason)
	..set myRecDepDR=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",6)
	..quit:((RecDepStr'="")&&(RecDepStr'[("^"_myRecDepDR_"^")))
	..set itemstat=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
	..set statcode=$s((+itemstat'=0):$p($g(^OEC("OSTAT",itemstat)),"^",1),1:"")
	..quit:(" V E "'[(" "_statcode_" "))
	..set nCount=$i(nCount)
	
	quit nCount
}

/// Debug: w ##class(web.udhcOPBill1).ReadUFPatOrderFlag("00018462","141","982")
ClassMethod ReadUFPatOrderFlag(PatientNo As %String, GroupDR As %String = "", CTLocDR As %String = "") As %String
{
	quit:(PatientNo="") "N"
	set PAPMI=$o(^PAPERi("PAPMI_PatNo",PatientNo,0))
	quit:(PAPMI="") "N"
	
	set HospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocDR)
	
	set myExpStr=""_"^"_GroupDR_"^"_CTLocDR_"^"_HospId
	set myPAADMStr=##class(web.DHCOPCashierIF).GetToDayAdmStr(PAPMI, myExpStr)
	quit:(myPAADMStr="") "N"
	
	//费别
	set myITStr=##class(web.DHCOPCashier).GetPatPrescTypeList(PAPMI)
	set myOrderStr=""
	for i=1:1:$l(myITStr,$c(2)) {
		set myinfo=$p(myITStr,$c(2),i)
		set myInsType=$p(myinfo,"^",2)
		set myOrderStr=..ReadUFAdmOrder(myPAADMStr, myInsType, "", GroupDR, CTLocDR)
		quit:(myOrderStr'="")
	}
	set rtn="N"
	if (myOrderStr'="") {
		set rtn="Y"
	}
	quit rtn
}

/// Description: 获取所有就诊科室开的当前科室执行医嘱
/// Debug: w ##class(web.udhcOPBill1).ReadUFAdmOrder("440938^","1","undefined"_$C(2)_"440938"_$C(2)_"^440933||20^440933||21^440933||22^440933||23^"_$C(2)_"440938"_$C(2),"5","2")
ClassMethod ReadUFAdmOrder(PAADMStr As %String, AdmInsType As %String, UnBillStr As %String, GroupDR As %String = "", CTLocDR As %String = "") As %String
{
	set myOEStr=""
	if (PAADMStr="") {
		quit myOEStr
	}
	
	set HospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocDR)
	//取出门诊结算费用配置
	set myRecLocStr=""
	if ((GroupDR'="")&&(CTLocDR'="")) {
		set myRecLocStr=##class(web.UDHCOPGSConfig).ReadRLByGPRowID(GroupDR, HospDR, CTLocDR)
	}
	
	for i=1:1:$l(PAADMStr,"^") {
		set PAADMRowid=$p(PAADMStr,"^",i)
		continue:(+PAADMRowid=0)
		set OrderRowid=##class(web.DHCOPAdmFind).GetPAADMOrderRowid(PAADMRowid)
		continue:(+OrderRowid=0)
		//循环取出医嘱
		set mytmp=..GetOrderByOERowID(OrderRowid, AdmInsType, UnBillStr, myRecLocStr)
		set myOEStr=myOEStr_mytmp
	}
	
	quit myOEStr
}

/// Debug: w ##class(web.udhcOPBill1).OPOEORDBILLINL("382","763^","727||1^727||2^727||3","26.80","11103","28","10","293","")
ClassMethod OPOEORDBILLINL(PAPMIDR As %String, ADMStrInfo As %String, OEORDStr As %String, PatPaySum As %String, AccMRowID As %String, SessionStr As %String) As %String
{
	set ^TMP("OPOEORDBILLINL")=$lb(PAPMIDR, ADMStrInfo, OEORDStr, PatPaySum, AccMRowID, SessionStr)
	
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	
	//计费参数输入有误退出
	quit:(PAPMIDR="") 2620_"^"_"患者主索引不能为空"
	quit:(ADMStrInfo="") 2620_"^"_"就诊不能为空"
	
	quit:(OEORDStr="") 2620_"^"_"待结算医嘱不能为空"
	
	set OEORDStr="^"_OEORDStr_"^"
	
	set myAllInsStr=""
	set mySum=0
	
	quit:(AccMRowID="") 107_"^"_"账户不能为空"
	
	set myPAPMIDR=$p($g(^DHCACD("AccM",AccMRowID)),"^",2)
	
	quit:(PAPMIDR'=myPAPMIDR) -206_"^"_"预交金账户开户人和结算患者不一致"
	
	//+2018-08-31 ZhYW 1.获取患者的费别
	set rtnValue=##class(web.DHCOPConfig).GetOPUseFareTypeConfig(HospId)
	set myFareType=+$p(rtnValue,"^",2)
	if (+myFareType=0) {
		set myInsList=##class(web.DHCOPCashier).GetPatPrescTypeList(PAPMIDR, "", SessionStr)
	}else  {
		set myInsList=##class(web.DHCOPCashier).GetPatAdmInsTypeList(ADMStrInfo)
	}
	
	kill ^||TMP($j)
	set mylen=$l(myInsList,$c(2))
	for i=1:1:mylen  {
		set myInsDR=$p($p(myInsList,$c(2),i),"^",2)
		continue:(+myInsDR=0)
		set ^||TMP($j,"INS",myInsDR)=myInsDR			//费别
		set ^||TMP($j,"INS",myInsDR,"PatSum")=0		//患者支付钱
		set ^||TMP($j,"INS",myInsDR,"UB")=""			//Unbilled OEORI Str
		set ^||TMP($j,"INS",myInsDR,"ADMUB")=""		//Unbilled OEORI Str
		set ^||TMP($j,"INS",myInsDR,"BillStr")=""		//结算的OEORI串
		set myUnBillStr=""		    //不结算的医嘱
		set myBillStr=""			//结算的医嘱
		set myRtnStr=..ReadUFAdmOrder(ADMStrInfo, myInsDR, "", GroupId, CTLocId)
		set myAllInsStr=$g(myAllInsStr)_"^"_myRtnStr_"^"
		set myRtnLen=$l(myRtnStr,"^")
		for j=1:1:myRtnLen {
			set myOERowID=$p(myRtnStr,"^",j)
			continue:(myOERowID="")
			continue:("^"_$g(^||TMP($j,"INS",myInsDR,"ADMUB"))_"^")[(("^"_myOERowID_"^"))  //+2018-08-31 ZhYW
			if ("^"_OEORDStr_"^")'[("^"_myOERowID_"^") {
				set myUnBillStr=myUnBillStr_"^"_myOERowID
			}else {
				set myBillStr=myBillStr_"^"_myOERowID
			}
		}
		if (myUnBillStr'="") set myUnBillStr=myUnBillStr_"^"
		if (myBillStr="") set myBillStr=myBillStr_"^"
		set ^||TMP($j,"INS",myInsDR,"UB")=myUnBillStr
		set ^||TMP($j,"INS",myInsDR,"BillStr")=myBillStr
		set myPatSum=..GetOEORDSum(myBillStr)
		set ^||TMP($j,"INS",myInsDR,"PatSum")=myPatSum
		set mySum=$i(mySum, myPatSum)
		//写UnBill字符串
		set myBillStr=$g(^||TMP($j,"INS",myInsDR,"BillStr"))
		set myAdmLen=$l(ADMStrInfo,"^")
		for Idx=1:1:myAdmLen {
			quit:(myBillStr="")
			set myAdmRowID=$p(ADMStrInfo,"^",Idx)
			continue:(myAdmRowID="")
			set myOEORDDR=$o(^OEORD(0,"Adm",myAdmRowID,0))
			set myCurAdmUBStr=""
			set myBillStr=$g(^||TMP($j,"INS",myInsDR,"BillStr"))
			continue:(myBillStr="")
			set myUnBillStr=$g(^||TMP($j,"INS",myInsDR,"UB"))
			set myOELen=$l(myUnBillStr,"^")
			set myOPUnBillStr=""
			for OEIdx=1:1:myOELen {
				set myOERowID=$p(myUnBillStr,"^",OEIdx)
				continue:("^"_myOERowID)'[("^"_myOEORDDR_"||")		//当前OERowID,不是本次就诊退出
				set myOPUnBillStr=myOPUnBillStr_myOERowID_"^"
			}
			set myOPUnBillStr="^"_myOPUnBillStr
			set myAdmStr=$c(2)_myAdmRowID_$c(2)
			set ^||TMP($j,"INS",myInsDR,"ADMUB")=$g(^||TMP($j,"INS",myInsDR,"ADMUB"))_myAdmStr_myOPUnBillStr_myAdmStr
		}
	}
	
	if (+PatPaySum'=+mySum) {
		kill ^||TMP($j)
		quit 102_"^"_"支付金额不符，计算金额："_$fn(mySum,"",2)_"，传入金额："_$fn(PatPaySum,"",2)			//金额不符
	}
	
	set myComFlag=0		//包含标志
	//验证医嘱串是否符合条件？？
	set mylen=$l(OEORDStr,"^")
	for i=1:1:mylen {
		set myBillOERowID=$p(OEORDStr,"^",i)
		continue:(myBillOERowID="")
		if (myAllInsStr'[("^"_myBillOERowID_"^")) {
			set myComFlag=1
			quit
		}
	}
	if (+myComFlag=1) {
		kill ^||TMP($j)
		quit:(+myComFlag=1) 2621_"^"_"传入的医嘱串格式错误"
	}
	
	//默认CPP支付
	set myCPPDR=$o(^CT("CTPM",0,"Code","CPP",0))
	if (myCPPDR=""){
		kill ^||TMP($j)
		quit 105_"^"_"支付方式错误"			//没有这种支付模式错误
	}
	set Payinfo=""
	
	set rtn=0
	
	set checkOutMode=1      //+2018-08-31 ZhYW 卡支付不弹界面标识
	set insuDicCode=""      //病种编码
	//+2023-03-17 ZhYW 做日结使用的操作员Id(诊间收费不可以为空)
	set footUserId=##class(web.DHCOPCashier).GetGrupContFootUser(GroupId, HospId)
	
	ts
	
	//3.循环费别,记帐
	set myINVStr=""
	set myInsDR=0
	while($o(^||TMP($j,"INS",myInsDR))) {
		set myInsDR=$o(^||TMP($j,"INS",myInsDR))
		set myBillStr=$g(^||TMP($j,"INS",myInsDR,"BillStr"))
		set myUnBillStr=$g(^||TMP($j,"INS",myInsDR,"ADMUB"))
		set myPatSum=$g(^||TMP($j,"INS",myInsDR,"PatSum"))
		set mySFlag=0
		set myOldINVRID=""
		set myInsPayCtl=0
		set myExpStr=GroupId_"^"_CTLocId_"^"_AccMRowID_"^N^F^^^^^^^"_checkOutMode_"^"_insuDicCode_"^"_footUserId
		continue:((myBillStr="")||(myBillStr="^"))
		set rtnValue=##class(web.DHCOPINVCons).OPBillCharge(ADMStrInfo, UserId, myUnBillStr, myInsDR, myPatSum, Payinfo, GroupId, mySFlag, myOldINVRID, myInsPayCtl, myExpStr)
		set rtn=+$p(rtnValue,"^",1)
		if (+rtn) {
			set rtn=rtnValue
			quit
		}
		set myStr=$p(rtnValue,"^",2,*)
		set myINVStr=myINVStr_myStr
	}
	if (+rtn) {
		tro
		kill ^||TMP($j)
		quit rtn
	}
	
	if ($tl>0) tc
	
	kill ^||TMP($j)
	
	quit rtn_"^"_myINVStr
}

/// Debug: w ##class(web.udhcOPBill1).GetOEORDSum("63||3^63||4^63||5")
ClassMethod GetOEORDSum(OEORIStr As %String) As %String
{
	set mySum=0
	
	for i=1:1:$l(OEORIStr,"^")  {
		set OEORIRowid=$p(OEORIStr,"^",i)
		continue:(OEORIRowid="")
		set OrderRowid=+OEORIRowid
		set itemsub=$p(OEORIRowid,"||",2)
		set adm=$p(^OEORD(+OrderRowid),"^",1)
		set RCDRowID=$p($g(^PAADM(adm,"DHC")),"^",25)
		set HospId=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
		set billed=$p($g(^OEORD(OrderRowid,"I",itemsub,3)),"^",5)
		continue:(" P I "[(" "_billed_" "))
		set statDR=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
		continue:(" V E "'[(" "_statCode_" "))
		set InsTypeDR=$p($g(^OEORD(+OrderRowid,"I",itemsub,11)),"^",18)   //OEORI_BBExtCode
		set JfCF=##class(web.DHCBillCommon).GetTarParaId(HospId)
		if (InsTypeDR="")&&(JfCF'="") set InsTypeDR=$P(^DHCTarC("CF",JfCF),"^",3)
		set ArcimRowid=$p($g(^OEORD(OrderRowid,"I",itemsub,1)),"^",2)
		set PackUOM=##class(web.DHCBillCommon).GetPackUom(ArcimRowid, OEORIRowid)
		set PackQty=##class(BILL.OP.COM.Method).GetOrdEffectivePackQty(OEORIRowid)
		continue:(+PackQty=0)  //过滤数量为0的记录
		set CostAmtStr=##class(BILL.OP.COM.Method).GetPendPayOrdItmCost(OEORIRowid, InsTypeDR, HospId)
		set TotalAmt=$p(CostAmtStr,"^",1)
		set DiscAmt=$p(CostAmtStr,"^",2)
		set PayorAmt=$p(CostAmtStr,"^",3)
		set PatAmt=$p(CostAmtStr,"^",4)
		set mySum=$i(mySum, PatAmt)
	}
	
	set mySum=$fn(mySum,"",2)
	quit mySum
}

/// Creator: Lid
/// CreatDate: 2014-04-11
/// Description: 根据就诊号或医嘱Rowid串，获取科室结算数据(注：医嘱串的优先级高)
/// Input:	EpisodeID: 就诊号
/// 	    InsType: 费别
/// 	    OeoriIDStr: 要结算的医嘱串
/// 	    SessionStr: 扩展串(用户^安全组^科室^院区^^^)
/// Return: 
/// Debug:w ##class(web.udhcOPBill1).GetLocCheckOutInfo(592,1,"","600^63^28^^")
ClassMethod GetLocCheckOutInfo(EpisodeID As %String, InsType As %String, OeoriIDStr As %String, SessionStr As %String) As %String
{
	if ((OeoriIDStr="")&&(EpisodeID'="")){
		//判断就诊记录是否存在预结算状态的发票记录,如果存在,则需先撤销后再结算
		set rtn=##class(web.DHCOPBillChargExcepiton).CheckTPFlagByEpisodeID(EpisodeID, "")
		quit:(+rtn'=0) "!!!"
		//医嘱串的优先级高
		set rset=##class(%ResultSet).%New("web.DHCOPAdmFind:GetADMOrder")
		set columns=rset.GetColumnCount()
		set OrdItmStr=""
		set rs=rset.Execute(EpisodeID, InsType, "^^", SessionStr)
		while (rset.Next()) {
			set myOrdItmRowID=$g(rset.Data("OrdRowId"))
			set myBillFlag=$g(rset.Data("OPOrdBillFlag"))
			continue:(+myBillFlag=0) 	       //过滤不能缴费的医嘱
			set OrdItmStr=$s((OrdItmStr=""):myOrdItmRowID,1:(OrdItmStr_"^"_myOrdItmRowID))
		}
		set OeoriIDStr=OrdItmStr
	}
	set count=$l(OeoriIDStr,"^")
	set admIdStr=""
	for i=1:1:count {
		set oeoriId=$p(OeoriIDStr,"^",i)
		continue:(oeoriId="")
		set ord=$p(oeoriId,"||",1), itm=$p(oeoriId,"||",2)
		set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
		if (" P I "[(" "_billed_" ")) {
			set $p(OeoriIDStr,"^",i)=""
			continue
		}
		set itemStat=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
		set statCode=$s((+itemStat'=0):$p($g(^OEC("OSTAT",itemStat)),"^",1),1:"")
		if (" V E "'[(" "_statCode_" ")) {
			set $p(OeoriIDStr,"^",i)=""
			continue
		}
		set admId=+^OEORD(ord)
		set rtn=##class(web.DHCOPBillChargExcepiton).CheckTPFlagByEpisodeID(admId, "")
		continue:(+rtn)
		if ("^"_admIdStr)'[("^"_admId_"^") {
			set admIdStr=admIdStr_admId_"^"
		}
	}

	if (admIdStr'="^") set papmiId=+^PAADM(+admIdStr)
	set billSum=##class(web.udhcOPBillIF).GetOEORDSum(OeoriIDStr)

	quit billSum_"!"_OeoriIDStr_"!"_admIdStr_"!"_papmiId
}

/// Creator: ZhYW
/// CreatDate: 2021-09-02
/// Description: 判断就诊所在院区是否能在登录院区结算
/// Input:	adm: PA_Adm.RowId, sessionStr:扩展串(用户^安全组^科室^院区^^^)
/// Return: 1:是, 0:否
/// Debug: w ##class(web.udhcOPBill1).HasHospChgAuth(1,"600^63^28^^")
ClassMethod HasHospChgAuth(adm As %String, sessionStr As %String) As %String
{
	quit:(+adm=0) 0
	
	set hospId=$p(sessionStr,"^",4)
	do ##class(BILL.Interface.Inside.Invoke).GetMultiHospCfg(hospId, "OPCharge", .mulHospAry)
	
	set admDeptDR=$p($g(^PAADM(adm)),"^",4)
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
	if ($d(mulHospAry("JZ"))) {
		quit:('$d(mulHospAry("JZ",admHospDR))) 0
		
		if ($d(mulHospAry("JZ",admHospDR,"LOC"))) {
			quit:('$d(mulHospAry("JZ",admHospDR,"LOC",admDeptDR))) 0
		}
		
		quit 1
	}
	
	quit:('$d(mulHospAry(admHospDR))) 0
	
	quit 1
}

}
