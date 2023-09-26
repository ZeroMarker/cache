Class web.DHCOPCashier7 Extends BILL.COM.Abstract
{

/// Input: PAPMI:PA_PatMas.RowId, SessionStr:SSUser.RowId^SS_Group.RowId^CT_Loc.RowId^CT_Hospital.RowId
/// Debug: w ##class(web.DHCOPCashier7).GetToDayAdmStr("131","17275^239^3^2^20")
ClassMethod GetToDayAdmStr(PAPMI As %String, SessionStr As %String) As %String
{
	set ^TMP("GetToDayAdmStr")=$lb(PAPMI, SessionStr)
	set UserId=$p(SessionStr,"^",1)
	set GroupId=$p(SessionStr,"^",2)
	set CTLocId=$p(SessionStr,"^",3)
	set HospId=$p(SessionStr,"^",4)
	if (HospId="") {
		set HospId=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(CTLocId)
	}
	
	kill AdmAry
	
	//门急诊就诊
	set EffectiveAdmStr=..GetCfgTimeRangeAdmByPatDr(PAPMI, HospId)
	do PushAdmAry(EffectiveAdmStr)
	
	//2015-01-15 取科研用药的就诊记录
	set PilotAdm=##class(web.DHCBillPilot).GetPilotInsuType(PAPMI, "O")
	set IsPilot=$p(PilotAdm,"!",1)
	if (+IsPilot=1) {
		set EffectiveAdmStr=$p(PilotAdm,"!",2)
		do PushAdmAry(EffectiveAdmStr)
	}
	
	//2015-03-05 Lid 获取当日下医嘱的就诊
	set EffectiveAdmStr=..GetActiveAdmByPatDr(PAPMI)
	do PushAdmAry(EffectiveAdmStr)
	
	//2022-03-25 ZhYW 获取退费后需要重新收费的就诊
	set EffectiveAdmStr=..GetReChgAdmByPatDr(PAPMI)
	do PushAdmAry(EffectiveAdmStr)
	
	//2022-06-24 ZhYW 获取有"先诊疗后付费"就诊下有未结算医嘱的就诊
	set EffectiveAdmStr=..GetGreenAdmByPatDr(PAPMI)
	do PushAdmAry(EffectiveAdmStr)
	
	//2022-11-11 ZhYW 获取有"预住院转门诊"就诊下有未结算医嘱的就诊
	set EffectiveAdmStr=..GetPreIPToOPAdmByPatDr(PAPMI)
	do PushAdmAry(EffectiveAdmStr)
	
	do ##class(BILL.Interface.Inside.Invoke).GetMultiHospCfg(HospId, "OPCharge", .mulHospAry)
	
	set AdmStr=""
	
	set AdmType=""
	while($o(AdmAry(AdmType))'="") {
		set AdmType=$o(AdmAry(AdmType))
		set Adm=""
		while($o(AdmAry(AdmType,Adm),-1)) {
			set Adm=$o(AdmAry(AdmType,Adm),-1)
			set StayInfo=##class(web.DHCBillInterface).IGetStayStatusByEpisodeID(Adm)
			set StayFlag=$p(StayInfo,"^",1)
			continue:(" 1 2 "[(" "_StayFlag_" "))     //2015-04-15 Lid 门诊收费界面过滤急诊留观就诊记录，留观病人必须在留观结算界面结算。
			set AdmDeptDR=$p($g(^PAADM(Adm)),"^",4)
			set AdmHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(AdmDeptDR)
			if ($d(mulHospAry("JZ"))) {
				continue:('$d(mulHospAry("JZ",AdmHospDR)))
				if ($d(mulHospAry("JZ",AdmHospDR,"LOC"))) {
					continue:('$d(mulHospAry("JZ",AdmHospDR,"LOC",AdmDeptDR)))
				}
			}else {
				continue:('$d(mulHospAry(AdmHospDR)))
			}
			set AdmStr=$s((AdmStr=""):Adm,1:(AdmStr_"^"_Adm))
		}
	}
	
	quit AdmStr

PushAdmAry(EffectiveAdmStr)
	for i=1:1:$l(EffectiveAdmStr,"^") {
		set Adm=$p(EffectiveAdmStr,"^",i)
		continue:(+Adm=0)
		set AdmType=$p($g(^PAADM(Adm)),"^",2)
		set AdmAry(AdmType,Adm)=""
	}
	quit
}

/// Creator: ZhYW
/// CreatDate: 2022-06-24
/// Description: 获取配置时间范围内的就诊
/// Input: patientId: PA_PatMas.RowId, hospId:CT_Hosp
/// Return: 
/// Debug: w ##class(web.DHCOPCashier7).GetCfgTimeRangeAdmByPatDr(88, 2)
ClassMethod GetCfgTimeRangeAdmByPatDr(patientId As %String, hospId As %String) As %String
{
	set admStr=""
	
	quit:(+patientId=0) admStr
	
	set myOPBeginDate=0
	set myOPBeginTime=0				//最小到小时
	set myEMBeginDate=0
	set myEMBeginTime=0
	
	set myCfgInfo=##class(web.DHCOPConfig).ReadOPSPConfig(hospId)
	set myOPFlag=+$p(myCfgInfo,"^",24)
	set myOPValue=+$p(myCfgInfo,"^",25)
	//Emergency
	set myEMFlag=+$p(myCfgInfo,"^",26)
	set myEMValue=+$p(myCfgInfo,"^",27)
	
	set myCurDate=+$h+($p($h,",",2)/86400)		//把当前时间转换为天
	
	if (+myOPValue=0) set myOPValue=1
	if (+myEMValue=0) set myEMValue=1
	
	//按照日期
	if (+myOPFlag=0) {
		set myOPBeginDate=+$h-myOPValue
		set myOPBeginTime=0
	}
	
	//按照时间
	if (+myOPFlag=1) {
		set myDateCount=(myOPValue/24)
		set myOPBeginDate=+$p((myCurDate-myDateCount),".",1)
		set myOPDecimal=(myCurDate-myDateCount)-myOPBeginDate
		set myOPBeginTime=$fn((+myOPDecimal)*86400,"",0)
	}
	
	//按照日期
	if (+myEMFlag=0) {
		set myEMBeginDate=+$h-myEMValue
		set myEMBeginTime=0
	}
	
	//按照时间
	if (+myEMFlag=1) {
		set myDateCount=(myEMValue/24)
		set myEMBeginDate=+$p((myCurDate-myDateCount),".",1)
		set myEMDecimal=(myCurDate-myDateCount)-myEMBeginDate
		set myEMBeginTime=$fn((myEMDecimal)*86400,"",0)
	}
	
	set admType=""
	while($o(^PAPERdr(patientId,"ADM",admType))'="") {
		set admType=$o(^PAPERdr(patientId,"ADM",admType))
		continue:(" O E "'[(" "_admType_" "))
		set adm=""
		while($o(^PAPERdr(patientId,"ADM",admType,adm),-1)) {
			set adm=$o(^PAPERdr(patientId,"ADM",admType,adm),-1)
			set admData=$g(^PAADM(adm))
			set visitStatus=$p(admData,"^",20)
			continue:(visitStatus="C")
			set admDate=$p(admData,"^",6)
			set admTime=$p(admData,"^",7)
			continue:(admType="O")&&((admDate<+myOPBeginDate)||((admDate=+myOPBeginDate)&&(admTime<+myOPBeginTime)))
			continue:(admType="E")&&((admDate<+myEMBeginDate)||((admDate=+myEMBeginDate)&&(admTime<+myEMBeginTime)))
			set admStr=$s((admStr=""):adm,1:(admStr_"^"_adm))
		}
	}
	
	quit admStr
}

/// Creator: Lid
/// CreatDate: 2015-03-04
/// Description: 获取当日下医嘱的就诊记录rowid
/// 				主要解决的问题：部分医院会在很早以前的就诊上开医嘱，导致收费界面不能显示这个就诊，收费员必须点“查询”
/// 						先查询到这个就诊再收费，如果收费员不查询就会漏费；如果我们把门诊系统配置里的时间设置的足够长，
/// 						又会显示一些多余的就诊记录
/// Input: patientId: PA_PatMas.RowId
/// Return: 有当日未缴费医嘱的就诊RowId串
/// Debug: w ##class(web.DHCOPCashier7).GetActiveAdmByPatDr(12)
ClassMethod GetActiveAdmByPatDr(patientId As %String) As %String
{
	set admStr=""
	
	quit:(+patientId=0) admStr
	
	set admType=""
	while($o(^PAPERdr(patientId,"ADM",admType))'="") {
		set admType=$o(^PAPERdr(patientId,"ADM",admType))
		continue:(" O E "'[(" "_admType_" "))
		set adm=0
		while($o(^PAPERdr(patientId,"ADM",admType,adm))) {
			set adm=$o(^PAPERdr(patientId,"ADM",admType,adm))
			set admData=$g(^PAADM(adm))
			set visitStatus=$p(admData,"^",20)
			continue:(visitStatus="C")
			set ord=##class(web.DHCOPAdmFind).GetPAADMOrderRowid(adm)
			continue:(ord="")
			set flag=0
			set itm=""
			while($o(^OEORD(ord,"I",itm),-1)) {
				set itm=$o(^OEORD(ord,"I",itm),-1)
				continue:('$d(^OEORD(ord,"I",itm,1)))
				set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
				continue:(" P I "[(" "_billed_" "))
				set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
				set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
				continue:(" V E "'[(" "_statCode_" "))
				set insertDate=$p($g(^OEORD(ord,"I",itm,1)),"^",19)   //OEORI_InsertDate
				continue:(insertDate'=+$h)
				set flag=1	      //有当日未缴费医嘱
				quit
			}
			continue:(flag=0)
			set admStr=$s((admStr=""):adm,1:(admStr_"^"_adm))
		}
	}
	quit admStr
}

/// Creator: ZhYW
/// CreatDate: 2022-03-25
/// Description: 获取退费后需要重新收费的就诊
/// Input: patientId: PA_PatMas.RowId
/// Return: 有当日未缴费医嘱的就诊RowId串
/// Debug: w ##class(web.DHCOPCashier7).GetReChgAdmByPatDr(131)
ClassMethod GetReChgAdmByPatDr(patientId As %String) As %String
{
	set admStr=""
	
	quit:(+patientId=0) admStr

	set id=0
	while($o(^BILL.OP.ReChgOrderI("IdxPAPMI",patientId,id))) {
		set id=$o(^BILL.OP.ReChgOrderI("IdxPAPMI",patientId,id))
		set data=$g(^BILL.OP.ReChgOrderD(id))
		set adm=$lg(data,3)
		continue:(("^"_admStr_"^")[("^"_adm_"^"))
		set oeitm=$lg(data,4)
		continue:(oeitm="")
		set ord=+oeitm
		set itm=$p(oeitm,"||",2)
		set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
		continue:(" P I "[(" "_billed_" "))
		set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
		continue:(" V E "'[(" "_statCode_" "))
		set admStr=$s((admStr=""):adm,1:(admStr_"^"_adm))
	}
	quit admStr
}

/// Creator: ZhYW
/// CreatDate: 2022-06-24
/// Description: 获取有"先诊疗后付费"就诊下有未结算医嘱的就诊
/// Input: patientId: PA_PatMas.RowId
/// Return: 有未缴费医嘱的就诊RowId串
/// Debug: w ##class(web.DHCOPCashier7).GetGreenAdmByPatDr(88)
ClassMethod GetGreenAdmByPatDr(patientId As %String) As %String
{
	set admStr=""
	
	quit:(+patientId=0) admStr
	
	set admType=""
	while($o(^PAPERdr(patientId,"ADM",admType))'="") {
		set admType=$o(^PAPERdr(patientId,"ADM",admType))
		continue:(" O E "'[(" "_admType_" "))
		set adm=0
		while($o(^PAPERdr(patientId,"ADM",admType,adm))) {
			set adm=$o(^PAPERdr(patientId,"ADM",admType,adm))
			set admData=$g(^PAADM(adm))
			set visitStatus=$p(admData,"^",20)
			continue:(visitStatus="C")
			set rtn=##class(BILL.OP.COM.Method).ChkPendPayOrdByGreenAdm(adm)
			continue:(+rtn=0)
			set admStr=$s((admStr=""):adm,1:(admStr_"^"_adm))
		}
	}
	quit admStr
}

/// Creator: ZhYW
/// CreatDate: 2022-06-24
/// Description: 获取有"预住院转门诊"就诊下有未结算医嘱的就诊
/// Input: patientId: PA_PatMas.RowId
/// Return: 有未缴费医嘱的就诊RowId串
/// Debug: w ##class(web.DHCOPCashier7).GetPreIPToOPAdmByPatDr(162)
ClassMethod GetPreIPToOPAdmByPatDr(patientId As %String) As %String
{
	set admStr=""
	
	quit:(+patientId=0) admStr
	
	set adm=0
	while($o(^PAPERdr(patientId,"ADM","O",adm))) {
		set adm=$o(^PAPERdr(patientId,"ADM","O",adm))
		continue:('$d(^DHCBillPreIPAdmTransLogi(0,"ADMDR",adm)))  //过滤非预住院转入门诊的就诊
		set admData=$g(^PAADM(adm))
		set visitStatus=$p(admData,"^",20)
		continue:(visitStatus="C")
		set ord=##class(web.DHCOPAdmFind).GetPAADMOrderRowid(adm)
		continue:(ord="")
		set flag=0
		set itm=""
		while($o(^OEORD(ord,"I",itm),-1)) {
			set itm=$o(^OEORD(ord,"I",itm),-1)
			continue:('$d(^OEORD(ord,"I",itm,1)))
			set billed=$p($g(^OEORD(ord,"I",itm,3)),"^",5)
			continue:(" P I "[(" "_billed_" "))
			set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
			set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
			continue:(" V E "'[(" "_statCode_" "))
			set flag=1	      //有未缴费医嘱
			quit
		}
		continue:(flag=0)
		set admStr=$s((admStr=""):adm,1:(admStr_"^"_adm))
	}
	quit admStr
}

}
