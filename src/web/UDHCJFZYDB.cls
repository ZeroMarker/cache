Import SQLUser

Class web.UDHCJFZYDB Extends BILL.COM.Abstract
{

/// Creator: ZhYW
/// CreatDate: 2018-07-12
/// Description: 查询住院患者就诊信息
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFZYDB", "FindAdmInfo", 1027)
Query FindAdmInfo(patientId As %String, episodeId As %String, admStatus As %String, sessionStr As %String) As websys.Query(ROWSPEC = "adm:%String,admDate:%String,admTime:%String,admDept:%String")
{
}

ClassMethod FindAdmInfoExecute(ByRef qHandle As %Binary, patientId As %String, episodeId As %String, admStatus As %String, sessionStr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((patientId="")&&(episodeId=""))  quit $$$OK
	
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	if (+episodeId'=0) {
		do GetAdmInfo(episodeId)
		quit $$$OK
	}
	
	set adm=""
	while($o(^PAPERdr(patientId,"ADM","I",adm),-1)) {
		set adm=$o(^PAPERdr(patientId,"ADM","I",adm),-1)
		set visitStatus=$p(^PAADM(adm),"^",20)
		continue:(" A D "'[(" "_visitStatus_" "))
		continue:((admStatus'="")&&(visitStatus'=admStatus))
		do GetAdmInfo(adm)
	}
	quit $$$OK
GetAdmInfo(adm)
	set admData=$g(^PAADM(adm))
	quit:(admData="")
	set admDeptDR=$p(admData,"^",4)
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
	quit:(admHospDR'=hospId)
	set admDept=$s((+admDeptDR'=0):$p($g(^CTLOC(admDeptDR)),"^",2), 1:"")
	set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
	set admDate=$p(admData,"^",6)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=$p(admData,"^",7)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	do OutputAdmList
	quit
OutputAdmList
	set Data=$lb(adm,admDate,admTime,admDept)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-07-12
/// Description: 查询住院担保信息
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFZYDB", "FindWarrInfo", "486", "2")
Query FindWarrInfo(episodeId As %String, langId As %String = "") As websys.Query(ROWSPEC = "regNo:%String:登记号,patName:%String:患者姓名,admDept:%String:就诊科室,warrDate:%String:担保日期,warrTime:%String:担保时间,warrtorDR:%String:担保人ID,warrtor:%String:担保人,warrAmt:%Float:担保金额,warrEndDate:%String:结束日期,status:%String:是否有效,userName:%String:操作员,credTypeDR:%String:担保物ID,warrItems:%String:担保物,remark:%String:备注,adm:%String:就诊ID,papmi:%String:患者ID,warrId:%String:担保ID,guarantId:%String:申请ID,warrReaId:%String:担保原因ID,warrReaDesc:%String:担保原因")
{
}

ClassMethod FindWarrInfoExecute(ByRef qHandle As %Binary, episodeId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindWarrInfo")=$lb(episodeId, langId)
	quit:(+episodeId=0) $$$OK
	
	if (langId="")&&($d(%session)) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set warrId=0
	while($o(^DHCWARRANT(0,"ADM",episodeId,warrId))) {
		set warrId=$o(^DHCWARRANT(0,"ADM",episodeId,warrId))
		do GetWarrInfo(warrId)
	}
	
	quit $$$OK
	
GetWarrInfo(warrId)
	set warrData=$g(^DHCWARRANT(warrId))
	quit:(warrData="")
	set admDR=$p(warrData,"^",1)
	set warrAmt=$p(warrData,"^",2)
	set warrAmt=$fn(warrAmt,"",2)
	set warrtorDR=$p(warrData,"^",9)
	set warrtor=$s((+warrtorDR'=0):$p(^SSU("SSUSR",warrtorDR),"^",2),1:"")
	set warrtor=##class(User.SSUser).GetTranByDesc("SSUSRName", warrtor, langId)
	set warrDate=$p(warrData,"^",3)
	set warrTime=$p(warrData,"^",17)
	set warrDate=##class(websys.Conversions).DateLogicalToHtml(warrDate)
	set warrTime=##class(websys.Conversions).TimeLogicalToHtml(warrTime)
	set warrEndDate=$p(warrData,"^",4)
	set warrEndDate=##class(websys.Conversions).DateLogicalToHtml(warrEndDate)
	set userDR=$p(warrData,"^",7)
	set userName=$s((+userDR'=0):$p(^SSU("SSUSR",userDR),"^",2), 1:"")
	set userName=##class(User.SSUser).GetTranByDesc("SSUSRName", userName, langId)
	set status=$p(warrData,"^",8)
	set remark=$p(warrData,"^",10)
	set papmi=$p(warrData,"^",11)
	set regNo=$p(^PAPER(papmi,"PAT",1),"^",2)
	set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	set admDeptDR=$p(^PAADM(admDR),"^",4)
	set admDept=$s((+admDeptDR'=0):$p(^CTLOC(admDeptDR),"^",2), 1:"")
	set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
	set guarantId=$p(warrData,"^",18)
	set credTypeDR=$p(warrData,"^",19)
	set warrItems=$s((+credTypeDR'=0):$p($g(^PAC("CARD",credTypeDR)),"^",2),1:"")   //担保物使用证件类型
	set warrItems=##class(User.DHCCredType).GetTranByDesc("CRTDesc", warrItems, langId)
    set warrReaId=$p(warrData,"^",21)  //担保原因
    set warrReaDesc=$s((+warrReaId'=0):$lg(^User.DHCEmGuaReasonD(warrReaId),3),1:"")   //2022-11-04  LUANZH 取担保原因
    set warrReaDesc=##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCEmGuaReason", "GREDesc", "", warrReaDesc)
	do OutputWarrList
	quit
 
OutputWarrList
	set Data=$lb(regNo,patName,admDept,warrDate,warrTime,warrtorDR,warrtor,warrAmt,warrEndDate,status,userName,credTypeDR,warrItems,remark,admDR,papmi,warrId,guarantId,warrReaId,warrReaDesc)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// w ##class(web.UDHCJFZYDB).AuditWarr()
ClassMethod AuditWarr(auditInfo As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("Audit")=auditInfo
	set warrdr=$p(auditInfo,"^",1)
	quit:(warrdr="")||('$d(^DHCWARRANT(warrdr))) -1_"^"_"参数错误"
	set rtn=0
	set auditusr=$p(auditInfo,"^",2)
	set newauditflag=$p(auditInfo,"^",3)
	set newwarramt=+$p(auditInfo,"^",4)
	
	set warrData=$g(^DHCWARRANT(warrdr))
	set initauditflag=$p(warrData,"^",13)
	set initwarramt=$p(warrData,"^",2)

	quit:(initauditflag=newauditflag) -2_"^"_"审核状态没有变化"

	ts
	
	&SQL(
		UPDATE DHC_WARRANT
		SET WARR_AuditFlag = :newauditflag, WARR_AuditUSER_DR = :auditusr, WARR_AuditDate = CONVERT(DATE, NOW()),
			WARR_AuditTime = CONVERT(TIME, NOW()), WARR_AMT = :newwarramt
		WHERE %ID = :warrdr
	)
	set rtn=SQLCODE
	if (+rtn) tro  quit rtn_"^"_$g(%msg)
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-07-13
/// Description: 获取患者基本信息
/// Input: patientNo：登记号, medicareNo：病案号
/// Return：
/// Debug: w ##class(web.UDHCJFZYDB).GetPatInfo("")
ClassMethod GetPatInfo(patientNo As %String, medicareNo As %String, hospId As %String) As %String
{
	set patientId=""
	if (patientNo'="") {
		set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
		set patientId=$o(^PAPERi("PAPMI_PatNo",patientNo,0))
	}elseif (medicareNo'=""){
		set patientId=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(medicareNo, "I", hospId, "")
	}
	quit ##class(BILL.COM.PAPatMas).GetPatientInfo(patientId, hospId)
}

/// Creator: ZhYW
/// CreatDate: 2019-10-09
/// Description: 根据就诊号取患者费用信息
/// Input: 
/// Return: 
/// Debug: w ##class(web.UDHCJFZYDB).GetPatPayInfoByAdm("507")
ClassMethod GetPatPayInfoByAdm(episodeId As %String, langId As %String = "") As %String
{
	set ^TMP("GetPatPayInfoByAdm")=$lb(episodeId, langId)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set rtn="^^^^"
	set adm=episodeId
	quit:(+adm=0) rtn
	set visitStatus=$p($g(^PAADM(adm)),"^",20)
	quit:(" A D "'[(" "_visitStatus_" ")) rtn
	
	set warrAmt=..GetWarrAmt(adm)
	
	set admDepDR=$p(^PAADM(adm),"^",4)
	set admDept=$s((+admDepDR'=0):$p($g(^CTLOC(admDepDR)),"^",2),1:"")
	set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
	
	set patFeeInfo=##class(web.UDHCJFBaseCommon).GetDepositFeeByAdm(adm)

 	set rtn=patFeeInfo_"^"_warrAmt_"^"_admDept
 
 	quit rtn
}

/// Creator: xiongwang
/// CreatDate: 2017-08-20
/// Description: 取担保金额
/// Input: adm:PA_Adm.RowID
/// Return: 
/// Debug: w ##class(web.UDHCJFZYDB).GetWarrAmt(2985)
ClassMethod GetWarrAmt(adm As %String) As %String
{
	set warrAmt=0
	quit:(+adm=0) warrAmt
	
	set wdr=0
	while($o(^DHCWARRANT(0,"ADM",adm,wdr))) {
		set wdr=$o(^DHCWARRANT(0,"ADM",adm,wdr))
		set warrData=$g(^DHCWARRANT(wdr))
		set status=$p(warrData,"^",8)
		continue:(status'="Y")
		set ltd=$p(warrData,"^",4)      //WARR_LIMMIT_DATE 担保结束日期
		continue:((ltd'="")&&(ltd<+$h))
		set stDate=$p(warrData,"^",3)   //WARR_DATE 担保开始日期
		set time=$p(warrData,"^",17)
		continue:((stDate'="")&&(stDate>+$h))
		set limitStr=..GetLimitWarrantByAdm(adm)
		set flag=$p(limitStr,"^",1)
		set limitTime=$p(limitStr,"^",3)
		if ((flag="Y")&&(limitTime>0)) {
			continue:($SYSTEM.SQL.DATEDIFF("ss", stDate_","_time, $h)>(limitTime*3600))
		}
		set amt=$p(warrData,"^",2)
		set warrAmt=warrAmt+amt
	}

	quit $fn(warrAmt,"",2)
}

/// Creator: xiongwang
/// CreatDate: 2017-08-20
/// Description: 取担保限额配置信息
/// Input: adm:PA_Adm.RowID
/// Return: 
/// Debug: w ##class(web.UDHCJFZYDB).GetLimitWarrantByAdm(2985)
ClassMethod GetLimitWarrantByAdm(adm As %String) As %String
{
	set LimitAmt="", LimitTime=""
	set admDeptDR=$p(^PAADM(adm),"^",4)
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
 	set admReaDR=$p(^PAADM(adm,1),"^",7)
 	set admType=$p(^PAADM(adm),"^",2)
 	quit:(admType'="I") ""
 	
 	set wllId=""
 	
 	set mywllId=""
 	while($o(^DHCJFWARRANTLOCLIMITi(0,"LOCAdmReason",admDeptDR,admReaDR,mywllId),-1)&&(wllId="")) {
	 	set mywllId=$o(^DHCJFWARRANTLOCLIMITi(0,"LOCAdmReason",admDeptDR,admReaDR,mywllId),-1)
	 	set tmp=$g(^DHCJFWARRANTLOCLIMIT(mywllId))
	 	set myHospDR=$p(tmp,"^",9)
	 	continue:(admHospDR'=myHospDR)
	 	set wllId=mywllId
	}
 	
 	if (wllId="") {
	 	set mywllId=""
	 	while($o(^DHCJFWARRANTLOCLIMITi(0,"AdmReason",admReaDR,mywllId),-1)&&(wllId="")) {
		 	set mywllId=$o(^DHCJFWARRANTLOCLIMITi(0,"AdmReason",admReaDR,mywllId),-1)
		 	set tmp=$g(^DHCJFWARRANTLOCLIMIT(mywllId))
		 	set myHospDR=$p(tmp,"^",9)
		 	continue:(admHospDR'=myHospDR)
		 	set myLoc=$p(tmp,"^",1)
		 	continue:(myLoc'="")
		 	set wllId=mywllId
		}
	}
	
	if (wllId="") {
		set mywllId=""
	 	while($o(^DHCJFWARRANTLOCLIMITi(0,"LOC",admDeptDR,mywllId),-1)&&(wllId="")) {
		 	set mywllId=$o(^DHCJFWARRANTLOCLIMITi(0,"LOC",admDeptDR,mywllId),-1)
		 	set tmp=$g(^DHCJFWARRANTLOCLIMIT(mywllId))
		 	set myHospDR=$p(tmp,"^",9)
		 	continue:(admHospDR'=myHospDR)
		 	set myAdmReason=$p(tmp,"^",2)
		 	continue:(myAdmReason'="")
		 	set wllId=mywllId
		}
	}
	quit:(+wllId=0) "N"_"^"_LimitAmt_"^"_LimitTime
	
 	set data=$g(^DHCJFWARRANTLOCLIMIT(+wllId))
 	quit:(data="") "N"_"^"_LimitAmt_"^"_LimitTime
 	
 	set LimitType=$p(data,"^",3)
 	set LimitValue=$p(data,"^",4)
	set LimitAmt=$p(data,"^",5)
 	set LimitTime=$case(LimitType,"H":LimitValue,"D":(LimitValue*24),:"")
 	
 	quit "Y"_"^"_LimitAmt_"^"_LimitTime
}

/// Creator: ZhYW
/// CreatDate: 2022-04-11
/// Description: 结算时，将患者该就诊下所有有效的担保记录置结束日期
/// Input: adm:PA_Adm.RowID, dateTo:担保结束日期
/// Return: 
/// Debug: w ##class(web.UDHCJFZYDB).FinishAdmWarrants(43)
ClassMethod FinishAdmWarrants(adm As %String, dateTo As %Date = {+$h}) As %String
{
	set $zt="ERROR"
	set rtn=0
	quit:(+adm=0) -1_"^"_"参数错误"
	
	ts
	
	set id=0
	while($o(^DHCWARRANT(0,"ADM",adm,id))) {
		set id=$o(^DHCWARRANT(0,"ADM",adm,id))
		set data=$g(^DHCWARRANT(id))
		set status=$p(data,"^",8)
		continue:(status'="Y")
		set ltd=$p(data,"^",4)          //WARR_LIMMIT_DATE 担保结束日期
		continue:((ltd'="")&&(ltd'>dateTo))      //结束日期不于等于传入日期时退出
		&SQL(
			UPDATE DHC_WARRANT
			SET WARR_LIMMIT_DATE = :dateTo
			WHERE %ID = :id
		)
		set rtn=SQLCODE
		if (+rtn) {
			set rtn=rtn_"^"_$g(%msg)
			quit
		}
	}
	if (+rtn) tro  quit rtn
	
	if ($tl>0) tc
	
	quit rtn

ERROR
	quit ..AppException()
}

}
