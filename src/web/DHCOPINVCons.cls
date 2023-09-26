Import SQLUser

Class web.DHCOPINVCons Extends BILL.COM.Abstract
{

/// 利用接口来实现多态
/// Input: OldINVRID: 在退费过程中?原发票的RowID
/// 	   UnBillOrdStr: 不结算的医嘱RowId串(同时代表部分结帐)
///        ExpStr="gLoc^LoadCTLoc^AccManRowID^RequirINVFlag^FairType^OPPreSum^OPChange^OPRoundErr^NewInsType^LocalIPAddress^AdmStayFalg^CheckOutMode^InsuDicCode^FootUserId"
///        ExpStr=安全组^登陆科室^账户ID^是否打印发票标志^收费挂号标志^预收金额^找零^分币误差^新结算费别^终端IP^留观标志^科室卡消费不弹界面标识^病种编码^做日结使用的操作员Id(诊间收费不可以为空)
/// Modify: Lid 预结算时不插入支付方式，在确认完成时插入，此接口中的Payinfo参数保留，但是默认传空
/// Debug: w ##class(web.DHCOPINVCons).OPBillCharge("4740","17275","","1","311.09","","239","0","","0","239^3^919^Y^F^^^0^1^192.168.101.95^^^")
ClassMethod OPBillCharge(Paadminfo As %String, Userid As %String, UnBillOrdStr As %String, Instype As %String, PatPaySum As %String, Payinfo As %String, gloc As %String, SFlag As %String, OldINVRID As %String = "", InsPayCtl As %String = 0, ExpStr As %String) As %String
{
	set ^TMPUnBillOrdStr=UnBillOrdStr
	set ^TMP("OPBillCharge")=$lb(Paadminfo, Userid, "^TMPUnBillOrdStr", Instype, PatPaySum, Payinfo, gloc, SFlag, OldINVRID, InsPayCtl, ExpStr)
	//quit 0
	//日志开始时间
	set myTCLogBT=$p($zts,",",2)
	
	set myGroupId=$p(ExpStr,"^",1)
	set myCTLoc=$p(ExpStr,"^",2)
	set myFarType=$p(ExpStr,"^",5)
	set myAdmLGFlag=$p(ExpStr,"^",11)	        //留观标志
	set myCheckOutMode=$p(ExpStr,"^",12)		//ZhYW 科室卡消费不弹界面标识
	set myInsuDicCode=$p(ExpStr,"^",13)		    //ZhYW 病种编码
	
	set myHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myCTLoc)   //根据科室取医院DR
	
	/*
	if ((myFarType="F")&&(+SFlag=0)) {
		set myServiceName="OPCBeforeCharge"
		set myOEORIStr=##class(web.udhcOPBillIF).ReadUFAdmOrder(Paadminfo, Instype, UnBillOrdStr, myGroupId, myCTLoc)
		set myOERInfo=##class(web.DHCBL.CI.ServiceBuilder).OPOEORIService(myServiceName, myOEORIStr)
	}
	*/
	
	/*
	//唱收唱付
	set myValAry=PatPaySum_""
	set mySessionStr=""
	if ((myFarType="F")&&(+SFlag=0)) {
		set mySRTN=##class(web.DHCBL.SQuoteIF.SoundPrice).SoundService("", "TotalFee", myValAry, mySessionStr, "")
	}
	*/
	
	//2018-03-09 保存前台需结算医嘱信息
	do ##class(web.DHCOPBillChargExcepitonAnalyse).SaveChargeOrdLog(Paadminfo, Userid, UnBillOrdStr, Instype, PatPaySum, ExpStr)
	
	//2016-01-21 Lid 收费前生成处方号
	do ##class(web.DHCBillInterface).SetPresno(Paadminfo, Userid)
	
	//在此添加一个不同患者支付手段控制
	set myInsPayCtl=##class(web.DHCOPConfig).GetReasonType(Instype)
	quit:(+myInsPayCtl'=+InsPayCtl) 131_"^"_"患者结算需要附加条件"   //什么附加条件？
	
	set rtn=0
	
	//判断就诊记录是否存在预结算状态的发票记录，如果存在，则需先撤销后再结算
	set myExpStr=myCheckOutMode
	set rtn=##class(web.DHCOPBillChargExcepiton).CheckTPFlagByEpisodeID(Paadminfo, myExpStr)
	quit:(+rtn) 120_"^"_"有异常收费记录需要处理"
	
	//2020-08-31 ZhYW 判断医嘱数据完整性
	set rtn=..IsValidAdmOrd(Paadminfo, UnBillOrdStr, SFlag)
	quit:(+rtn) rtn
		
	set admCount=$l(Paadminfo,"^")
	if (+SFlag=0) {
		for i=1:1:admCount {
			set PAADMRowid=$p(Paadminfo,"^",i)
			continue:(+PAADMRowid=0)
			set AdmStayInfo=##class(web.UDHCJFBaseCommon).GetPatAdmStayStat(PAADMRowid)
			set StayFlag=$p(AdmStayInfo,"^",1)
			set AdmVisitStatus=$p(^PAADM(PAADMRowid),"^",20)	             //PAADM_VisitStatus
			set BillFlag=$p(^PAADM(PAADMRowid),"^",45)			             //PAADM_BillFlag
			continue:((StayFlag="Y")&&(AdmVisitStatus="D")&&(BillFlag'="Y"))	//留观病人，已留观出院，未做过财务结算
			set rtn=##class(web.UDHCOEORDOP).SetCurORDPrice(PAADMRowid)
			quit:(+rtn)
		}
		quit:(+rtn) rtn
	}
	
	set billnostr=""
	for i=1:1:admCount {
		set PAADMRowid=$p(Paadminfo,"^",i)
		continue:(+PAADMRowid=0)
		set rtn=##class(web.UDHCJFBILL).BILL(PAADMRowid, Userid)
		quit:(+rtn)
		set ARPBLRowid=""
		set myPBRowID=0
		while($o(^DHCPB(0,"ADM",PAADMRowid,myPBRowID))) {
			set myPBRowID=$o(^DHCPB(0,"ADM",PAADMRowid,myPBRowID))
			set myPBData=$g(^DHCPB(myPBRowID))
			set myPayedFlag=$p(myPBData,"^",16)
			continue:(myPayedFlag'="B")
			set ARPBLRowid=myPBRowID
			quit          //找到第一条B状态的账单就退出
		}
		if (ARPBLRowid'="") {
			set billnostr=$s((billnostr=""):ARPBLRowid,1:(billnostr_"^"_ARPBLRowid))
		}
	}
	quit:(+rtn) rtn
	
	//账单时间
	//do ##class(web.UDHCOPFError).TCLogReSet("OPBillTime",+$p($zts,",",2)-myTCLogBT)
	
	//取基本配置
	set myBCInfo=##class(web.DHCOPConfig).GetOPBaseConfigForGroup(myGroupId, myHospDR)
	set rtn=$p(myBCInfo,"^")
	quit:(+rtn) 104_"^"_"取门诊基本配置信息失败"
	set RecInvCount=$p(myBCInfo,"^",8)    //回执数量
	set PrintCount=$p(myBCInfo,"^",9)     //按明细数目拆分
	//2015-01-27 Lid 保证退费再收或急诊留观病人不拆分发票
	if ((+SFlag=1)||(myAdmLGFlag="Y")) {
		set RecInvCount=0, PrintCount=99999
	}
	
	do ##class(web.DHCBillConsIF).KTMP()
	b  ;^||TMP("BillINV",$j)
	set rtn=##class(web.DHCBillConsIF).GetBillData(billnostr, UnBillOrdStr, Instype, SFlag, ExpStr)
	quit:(+rtn) rtn
	b  ;^||TMP("BillINV",$j) over
	//获取数据
	set rtn=##class(web.DHCBillConsIF).ParDataToBill(RecInvCount, PrintCount, ExpStr)
	quit:(+rtn) rtn
	
	//2020-05-26 Lid 注释 预结算时不插支付方式，就不需要再计算舍入金额，此步放到后边出来
	/*
	//计算舍入
	set myPayModeDR=$p(Payinfo,"^",1)
	set myOPPreSum=$p(ExpStr,"^",6)
	set myOPChargeSum=$p(ExpStr,"^",7)
	set myOPRoundSum=$p(ExpStr,"^",8)
	set rtn=##class(web.DHCBillConsIF).BuildOPCINVRound(myOPPreSum, myOPChargeSum, myOPRoundSum, myPayModeDR, ExpStr)
	quit:(+rtn) rtn
	*/
	
	set myPAAdmRID=$p(Paadminfo,"^")
	set myPARowid=$p($g(^PAADM(myPAAdmRID)),"^",1)
	
	set myTCLogBT=$p($zts,",",2)
	
	//把账单生成票据
	set rtn=##class(web.DHCBillConsIF).ReBill(Userid, myPARowid, Instype, PatPaySum, Payinfo, SFlag, OldINVRID, ExpStr)
		
	//do ##class(web.UDHCOPFError).TCLogReSet("OPReBillTime",+$p($zts,",",2)-myTCLogBT)
	
	//xiongwang 复制进程Global到临时Global
	if (+rtn) {
		do ##class(web.DHCOPBillChargExcepitonAnalyse).CopyReBillOrdLog($j)
		set rtn=rtn_$c(3)_$j  //结算不成功只返回错误代码+$j
	}
	
	//在结束时也要清空^||TMP
	do ##class(web.DHCBillConsIF).KTMP()
	
	quit rtn
}

/// 门诊收费服务
/// Debug: w ##class(web.DHCOPINVCons).OPChargeService("<ConditionDefine><PRTRowIDStr>0^121^</PRTRowIDStr><SFlag>0</SFlag></ConditionDefine>","")
ClassMethod OPChargeService(XmlStr As %String, ExpStr As %String) As %String
{
	s myrtn=0
	
	s myConDef=##class(web.DHCEntity.CIDefine.ConditionDefine).%New()
	d myConDef.XMLDeserialize(.myConDef, XmlStr)
	q:('$IsObject(myConDef)) myrtn
	
	//药房接口, 在确认完成时再更新发药表
	//d ##class(web.udhcOPPHARWIN).UpdatePHWINV(myConDef.PRTRowIDStr)
	
	//接口服务
	s mySerInfo=##class(web.DHCBL.CI.Service).Service(myConDef)
	
	d myConDef.%Close()
	
	if (+mySerInfo=0) {
		s myINVStr=myConDef.PRTRowIDStr
		s myThirdInfo=$p(mySerInfo,$c(1),2)_$c(1)_$p(mySerInfo,$c(1),3)
		s myThirdInfo=myThirdInfo_$c(1)_$p(mySerInfo,$c(1),4)
		s ^TMPOPCTSeviceInfo(myINVStr)=myThirdInfo
	}
	
	q myrtn
}

ClassMethod CheckOPInvForInsu(InvList, ExpStr)
{
	set ^TMP("CheckOPInvForInsu")=$lb(InvList, ExpStr)
	set err=0
	set len=$l(InvList,"^")
	for i=1:1:len  quit:(+err'=0)  do
	.set InvDr=$p(InvList,"^",i)
	.quit:(+InvDr=0)
	.set insType=$p(^DHCINVPRT(+InvDr),"^",9)
	.set admSource=$p(^PAC("ADMREA",+insType),"^",9)
	.quit:(+admSource=0)
	.set Insdiv=$p(^DHCINVPRT(+InvDr),"^",30)
	.set insuerr=..CheckOPInvInsuData(InvDr, ExpStr)
	.if ($p(insuerr,"^",1)="N")&(+$p(insuerr,"^",2)=0)  set err=120
	.if ($p(insuerr,"^",1)="N")&(+$p(insuerr,"^",2)'=0)  set err=-120
	.if ($p(insuerr,"^",1)="Y")&(+$p(insuerr,"^",2)'=0)   set err=-121
	.if ($p(insuerr,"^",1)="Y")&(+$p(insuerr,"^",2)=0)   set err=0
	.if (+$p(insuerr,"^",2)'=0)  set InvList=InvList_"^"_InvDr_"@"_Insdiv_"@"_insType_"@"_admSource
	
	quit err
}

/// Debug: w ##class(web.DHCOPINVCons).CheckOPInvInsuData(217789, "^6")
ClassMethod CheckOPInvInsuData(InvPrtDr As %String, ExpStr As %String) As %String
{
    set InsLink=$p(ExpStr,"^",1)
    set insType=$p(^DHCINVPRT(+InvPrtDr),"^",9)
	set admSource=$p(^PAC("ADMREA",+insType),"^",9)
    quit:(+admSource=0) "Y^0"
    quit:(InsLink="N") "Y^0"
    
    set rtn=0
	set err=##class(web.DHCINSUPort).CheckINSUDivFlag(InvPrtDr, "", "", "", "N")
	set flag=$p(err,"!",1)
	if (flag="Y")  do
	.set OutStr=$p(err,"!",2)
	.set myPlen=$l(OutStr,$c(2))
	.if (myPlen>1) do
	..set myrtn=0
	..for myIdx=2:1:myPlen  quit:(+myrtn'=0)  do
	...set myPMInfo=$p(OutStr,$c(2),myIdx)
	...quit:(myPMInfo="")
	...set myPMDR=$p(myPMInfo,"^",1)
	...set myPMSum=$p(myPMInfo,"^",2)
	...set paysub=$o(^DHCINVPRTi(0,"PMDR",+InvPrtDr,+myPMDR,"P",0))
	...if (+paysub=0)  set rtn=-100
	...quit:(+paysub=0)
	...set payamt=$p(^DHCINVPRT(+InvPrtDr,"P",paysub),"^",3)
	...if (+payamt'=+myPMSum)  set rtn=-101
	...quit:(rtn)
	.if (rtn=-100)  do
	..set paysub=$o(^DHCINVPRT(+InvPrtDr,"P",""),-1)
	..quit:(+paysub=0)
    ..if (+paysub=1) do
	...set rtn=##class(web.DHCBillConsIF).UpdateINVPRTYBInfo(OutStr)
	...set rtn=+rtn
	else   do
	.set myGroupDR=$p(ExpStr,"^",1)
	.set rtn=##class(web.DHCBillConsIF).DelINVPRTForYB(InvPrtDr, myGroupDR)
	.set rtn=+rtn
	
	quit flag_"^"_rtn
}

ClassMethod CheckAPIInsuData(TMPGID As %String, ExpStr As %String) As %String
{
	set err=##class(web.DHCINSUPort).CheckINSUDivFlag("", "", TMPGID, "CPP", "N")
	set flag=$p(err,"!",1)
	set insuInfo=""
	if (flag'="Y") {
		set insType=0
		while($o(^DHCTMPACCColPRT("IP",TMPGID,insType))) {
			set insType=$o(^DHCTMPACCColPRT("IP",TMPGID,insType))
			set admSource=$p(^PAC("ADMREA",+insType),"^",9)
			set invIdx=0
			while($o(^DHCTMPACCColPRT("IP",TMPGID,insType,invIdx))) {
				set invIdx=$o(^DHCTMPACCColPRT("IP",TMPGID,insType,invIdx))
				set insuDivDR=$o(^DHCTMPACCColPRT("IP",TMPGID,insType,invIdx,"YBRowID",0))
				set myStr=insuDivDR_"^"_insType_"^"_admSource
				set insuInfo=$s((insuInfo=""):myStr,1:(insuInfo_"@"_myStr))
			}
		}
	}
	
	quit err_"!"_insuInfo
}

/// Creator: ZhYW
/// CreatDate: 2020-08-31
/// Description: 验证就诊下医嘱完整性
/// Input: admStr:PA_Adm.RowId, unBillOrdStr:不结算医嘱, sFlag:(0:收费，1:退费再收)
/// Return: 0: 数据完整，<>0: 数据不全
/// Debug: w ##class(web.DHCOPINVCons).IsValidAdmOrd("2427","")
ClassMethod IsValidAdmOrd(admStr As %String, unBillOrdStr As %String, sFlag As %String) As %String
{
	set ^TMP("IsValidAdmOrd")=$lb(admStr, unBillOrdStr, sFlag)
	set rtn=0
	for i=1:1:$l(admStr,"^") {
		set adm=$p(admStr,"^",i)
		continue:(+adm=0)
		set ord=$o(^OEORD(0,"Adm",adm,0))
		continue:(+ord=0)
		set itm=0
		while($o(^OEORD(ord,"I",itm))) {
			set itm=$o(^OEORD(ord,"I",itm))
			continue:'$d(^OEORD(ord,"I",itm,1))
			set oeitm=ord_"||"_itm
			continue:(("^"_unBillOrdStr_"^")[("^"_oeitm_"^"))
			if (+sFlag=0) {
				set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
				continue:(" P I "[(" "_billed_" "))
				set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
				set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
				continue:(" V E "'[(" "_statCode_" "))
			}
			set skinFlag=##class(web.UDHCOEORDOPIF).ReadSkinRtnFlag(oeitm)
			continue:(skinFlag="Y")				//限制医嘱不计费
			set rtnValue=##class(BILL.OP.COM.Method).IsValidOrd(oeitm)
			set rtn=('$p(rtnValue,"^",1))
			if (+rtn) {
				set rtn=141_"^"_$p(rtnValue,"^",2)
				quit
			}
		}
		quit:(+rtn)
	}
	
	quit rtn
}

}
