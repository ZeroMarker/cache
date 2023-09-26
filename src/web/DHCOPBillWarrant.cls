/// 名称: web.DHCOPBillWarrant.cls
/// 描述: 门急诊担保
/// 编写者: ZhYW
/// 编写日期: 2018-07-12
Class web.DHCOPBillWarrant Extends BILL.COM.Abstract
{

/// 查询就诊日期范围阈值
Parameter AdmDateThrhd [ Final ] = 3;

/// Creator: ZhYW
/// CreatDate: 2018-07-12
/// Description: 查询门诊/急诊就诊信息
/// Input:  
/// Output:  
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillWarrant", "FindAdmInfo", 2, "", 2)
Query FindAdmInfo(patientId As %String, episodeId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "adm:%String,admType:%String,admDate:%String,admTime:%String,admDept:%String")
{
}

ClassMethod FindAdmInfoExecute(ByRef qHandle As %Binary, patientId As %String, episodeId As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindAdmInfo")=$lb(patientId, episodeId, sessionStr)
	if ((+patientId=0)&&(+episodeId=0))  quit $$$OK
	
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	if (+episodeId'=0) {
		do GetAdmInfo(episodeId)
		quit $$$OK
	}
	
	set admType=""
	while($o(^PAPERdr(patientId,"ADM",admType))'="") {
		set admType=$o(^PAPERdr(patientId,"ADM",admType))
		continue:(" O E "'[(" "_admType_" "))
		set adm=""
		while($o(^PAPERdr(patientId,"ADM",admType,adm),-1)) {
			set adm=$o(^PAPERdr(patientId,"ADM",admType,adm),-1)
			set admData=$g(^PAADM(adm))
			set admDate=$p(admData,"^",6)
			set stayFlag=##class(web.UDHCJFBaseCommon).GetObsPatYetDisHosp(adm)
			if (stayFlag=-1) {
				continue:($SYSTEM.SQL.DATEDIFF("dd", admDate, +$h)>..#AdmDateThrhd)
			}
			do GetAdmInfo(adm)
		}
	}
	
	quit $$$OK
	
GetAdmInfo(adm)
	set admData=$g(^PAADM(adm))
	quit:(admData="")
	set visitStatus=$p(admData,"^",20)
	quit:(visitStatus="C")
	set admTime=$p(admData,"^",7)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	set admDeptDR=$p(admData,"^",4)
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admDeptDR)
	quit:(admHospDR'=hospId)
	set admDept=$s((+admDeptDR'=0):$p($g(^CTLOC(admDeptDR)),"^",2), 1:"")
	set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
	do OutputAdmInfo
	
	quit
	
OutputAdmInfo
	set Data=$lb(adm,admType,admDate,admTime,admDept)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-07-12
/// Description: 查询急诊担保信息
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillWarrant", "FindWarrInfo", 486)
Query FindWarrInfo(episodeId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "regNo:%String:登记号,patName:%String:患者姓名,admDept:%String:就诊科室,warrDate:%String:担保日期,warrTime:%String:担保时间,warrtorDR:%String:担保人ID,warrtor:%String:担保人,warrAmt:%Float:担保金额,warrEndDate:%String:结束日期,status:%String:是否有效,userName:%String:操作员,credTypeDR:%String:担保物ID,warrItems:%String:担保物,remark:%String:备注,adm:%String:就诊ID,papmi:%String:患者ID,warrId:%String:担保ID,guarantId:%String:申请ID,warrReaId:%String:担保原因ID,warrReaDesc:%String:担保原因")
{
}

ClassMethod FindWarrInfoExecute(ByRef qHandle As %Binary, episodeId As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindWarrInfo")=$lb(episodeId, sessionStr)
	quit:(+episodeId=0) $$$OK
	
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
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
	set warrReaId=$p(warrData,"^",21)     //担保原因  2022-11-08 LUANZH
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

/// Creator: ZhYW
/// CreatDate: 2018-07-13
/// Description: 获取患者基本信息
/// Input: patientNo：登记号
/// Return：
/// Debug: w ##class(web.DHCOPBillWarrant).GetPatInfo("")
ClassMethod GetPatInfo(patientNo As %String, hospId As %String) As %String
{
	set patientId=""
	if (patientNo'="") {
		set patientNo=##class(web.UDHCJFBaseCommon).regnocon(patientNo)
		set patientId=$o(^PAPERi("PAPMI_PatNo",patientNo,0))
	}
	quit ##class(BILL.COM.PAPatMas).GetPatientInfo(patientId, hospId)
}

/// Creator: ZhYW
/// CreatDate: 2018-07-13
/// Description: 根据就诊号取患者费用信息
/// Input: episodeId：就诊号
/// Return：
/// Debug: w ##class(web.DHCOPBillWarrant).GetPatPayInfoByAdm("")
ClassMethod GetPatPayInfoByAdm(episodeId As %String, langId As %String = "") As %String
{
	set admDept=""
	if (+episodeId'=0) {
		set admDeptDR=$p($g(^PAADM(episodeId)),"^",4)
 		set admDept=$s((+admDeptDR'=0):$p($g(^CTLOC(admDeptDR)),"^",2), 1:"")
 		set admDept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", admDept, langId)
	}
	set warrAmt=..GetWarrAmt(episodeId)
	set payInfo=##class(web.DHCBillInterface).IGetDepAndBalnace(episodeId)
	
    quit admDept_"^"_warrAmt_"^"_payInfo
}

/// 取担保金额
ClassMethod GetWarrAmt(episodeId As %String) As %String
{
	set warrAmt=0
	quit:(+episodeId=0) warrAmt
	
	set warrId=0
	while($o(^DHCWARRANT(0,"ADM",episodeId,warrId))) {
		set warrId=$o(^DHCWARRANT(0,"ADM",episodeId,warrId))
		set warrData=$g(^DHCWARRANT(warrId))
		set status=$p(warrData,"^",8)
		continue:(status'="Y")
		set stDate=$p(warrData,"^",3)
		set endDate=$p(warrData,"^",4)
		continue:((endDate'="")&&(endDate<+$h))
		continue:((stDate'="")&&(stDate>+$h))
		set amt=$p(warrData,"^",2)
		set warrAmt=$i(warrAmt, amt)
	}
	
    quit $fn(warrAmt,"",2)
}

/// Creator: ZhYW
/// CreatDate: 2018-07-13
/// Description: 担保登记
/// Input: warrInfo: 担保信息
/// Return：
/// Debug: w ##class(web.DHCOPBillWarrant).SaveWarrant("523&1958&2018-07-16&&ddd11&1000.00&Y&&4632&E&&sdddd")
ClassMethod SaveWarrant(warrInfo As %String) As %String
{
	set ^TMP("SaveWarrant")=warrInfo
	set $zt="ERROR"
	
	set delimiter="&"
	set rowId=$p(warrInfo,delimiter,1)
	set episodeId=$p(warrInfo,delimiter,2)
	set stDate=$p(warrInfo,delimiter,3)
	set endDate=$p(warrInfo,delimiter,4)
	set warrtor=$p(warrInfo,delimiter,5)
	set warrAmt=$p(warrInfo,delimiter,6)
	set warrStatus=$p(warrInfo,delimiter,7)
	set remark=$p(warrInfo,delimiter,8)
	set userId=$p(warrInfo,delimiter,9)
	set patType=$p(warrInfo,delimiter,10)
	set guarantId=$p(warrInfo,delimiter,11)
	set warrItem=$p(warrInfo,delimiter,12)
	set hospId=$p(warrInfo,delimiter,13)
	set reasonId=$p(warrInfo,delimiter,14) //2022-11-4
	
	quit:(+episodeId=0) -1_"^"_"就诊号为空"
	quit:(warrStatus="") -1_"^"_"担保状态为空"
	quit:(stDate="") -1_"^"_"担保开始日期为空"
	quit:(warrtor="") -1_"^"_"担保人为空"
	quit:(+warrAmt'>0) -1_"^"_"担保金额无效"
	quit:(patType="") -1_"^"_"患者类型为空"

	set papmi=$p($g(^PAADM(episodeId)),"^",1)
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)

	if (endDate'="") {
		set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
		quit:(endDate<stDate) -1_"^"_"结束日期不能小于开始日期"
	}
	
	if ((warrStatus="Y")&&(patType="I")) {
		set limitStr=##class(web.UDHCJFZYDB).GetLimitWarrantByAdm(episodeId)
		if ($p(limitStr,"^",1)="Y") {
			set limitAmt=$p(limitStr,"^",2)
			set myWarrAmt=##class(web.UDHCJFZYDB).GetWarrAmt(episodeId)
			if (+rowId'=0) {
				set myWarrAmt=myWarrAmt-$p($g(^DHCWARRANT(rowId)),"^",2)  //+2022-10-08 ZhYW 修改时，应该减去当前待修改记录的担保金额来判断
			}
			if ((limitAmt-myWarrAmt)<warrAmt) {
				quit -1_"^"_"超过担保限额"
			}
		}
	}
	
	ts
	
	if (+rowId'=0) {
		set dataObj=##class(User.DHCWARRANT).%OpenId(rowId, 0)
	}else {
		set dataObj=##class(User.DHCWARRANT).%New()
	}
	do dataObj.WARRADMDRSetObjectId(episodeId)
	do dataObj.WARRUSERDRSetObjectId(userId)
	set dataObj.WARRAMT=warrAmt
	set dataObj.WARRDATE=stDate
	set dataObj.WARRLIMMITDATE=endDate
	set dataObj.WARRSTATUS=warrStatus
	set dataObj.WARRWarrantor=warrtor
	set dataObj.WARRMEMO=remark
	do dataObj.WARRPAPMIDRSetObjectId(papmi)
	set dataObj.WARRPatType=patType
	set dataObj.WARRTime=$p($h,",",2)
	do dataObj.WARRequestDRSetObjectId(guarantId)
	set dataObj.WARRWarrantItem=warrItem
	do dataObj.WARRHospDRSetObjectId(hospId)
	do dataObj.WARRReasonDRSetObjectId(reasonId)
	set sc=dataObj.%Save()
	do dataObj.%Close()
	if $$$ISERR(sc){
		tro
		quit $system.Status.GetErrorCodes(sc)_"^"_$system.Status.GetErrorText(sc)
	}
	if ($tl>0) tc
	
    quit 0_"^"_"保存成功"
    
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-11-21
/// Description: 查询急诊担保信息
/// Input:  
/// Output:  
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCOPBillWarrant", "GetWarrPrtInfo", 269)
Query GetWarrPrtInfo(warrId As %String) As websys.Query(ROWSPEC = "stDate:%String,endDate:%String,patName:%String,admDept:%String,warrtor:%String,warrAmt:%Float,remark:%String") [ SqlProc ]
{
}

ClassMethod GetWarrPrtInfoExecute(ByRef qHandle As %Binary, warrId As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if (+warrId=0) quit $$$OK
	
	set warrData=$g(^DHCWARRANT(warrId))
	if (warrData="") quit $$$OK
	
	set admDR=$p(warrData,"^",1)
	set warrAmt=$p(warrData,"^",2)
	set warrAmt=$fn(warrAmt,"",2)
	set warrtorDR=$p(warrData,"^",9)
	set warrtor=$s((+warrtorDR'=0):$p(^SSU("SSUSR",warrtorDR),"^",2),1:"")
	set stDate=$p(warrData,"^",3)
	set stDate=##class(websys.Conversions).DateLogicalToHtml(stDate)
	set endDate=$p(warrData,"^",4)
	set endDate=##class(websys.Conversions).DateLogicalToHtml(endDate)
	set remark=$p(warrData,"^",10)
	set papmi=$p(warrData,"^",11)
	set regNo=$p(^PAPER(papmi,"PAT",1),"^",2)
	set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	set admDeptDR=$p(^PAADM(admDR),"^",4)
	set admDept=$s((+admDeptDR'=0):$p(^CTLOC(admDeptDR),"^",2), 1:"")
	do OutputWarrPrtInfo
	quit $$$OK
	 
OutputWarrPrtInfo
	set Data=$lb(stDate,endDate,patName,admDept,warrtor,warrAmt,remark)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=$i(ind)
	quit
}

}
