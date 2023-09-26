Import SQLUser

/// 名称: web.DHCBillPreIPAdmTrans.cls
/// 描述: 预住院转门诊/住院
/// 编写者: ZhYW
/// 编写日期: 2018-06-30
Class web.DHCBillPreIPAdmTrans Extends BILL.COM.Abstract
{

/// 是否更新就诊日期时间的设置？1:更新, <>1:不更新
Parameter UpdateAdmDateFlag [ Final ] = 1;

/// Creator: ZhYW
/// CreatDate: 2018-06-22
/// Description: 查询住院病区
/// Input: 
/// Output:  
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPreIPAdmTrans", "FindWard", "", "2")
Query FindWard(desc As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindWardExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("FindWard")=$lb(desc, hospId, langId)
 	
 	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
    set desc=$$ALPHAUP^SSUTIL4(desc)

	set rowId=0
	while($o(^CTLOC(rowId))) {
		set rowId=$o(^CTLOC(rowId))
		set deptData=$g(^CTLOC(rowId))
		continue:(deptData="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", rowId, hospId)
		continue:(showFlag="N")
		set wardFlag=$p(deptData,"^",5)
		continue:(wardFlag'="Y")
		set locType=$p(deptData,"^",13)
		set dateFrom=$p(deptData,"^",24)
		set dateTo=$p(deptData,"^",25)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))      //+2018-01-16 ZhYW 过滤不在有效期的
		set contactName=$p(deptData,"^",43)        //科室检索码
		set deptName=$p(deptData,"^",2)
		continue:((desc'="")&&($$ALPHAUP^SSUTIL4(contactName)'[desc)&&($$ALPHAUP^SSUTIL4(deptName)'[desc))
		set wardDR=$o(^PAWARD(0,"WARD_LocationDR",rowId,0))
		set deptName=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", deptName, langId)
	 	do OutputWard
	}
    
	quit $$$OK
    
OutputWard
	set Data=$lb(wardDR,deptName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-06-22
/// Description: 查询住院科室
/// Input:  
/// Output:  
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPreIPAdmTrans", "FindDept", "", "2")
Query FindDept(desc As %String, hospId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String")
{
}

ClassMethod FindDeptExecute(ByRef qHandle As %Binary, desc As %String, hospId As %String, langId As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set rowId=0
	while($o(^CTLOC(rowId))) {
		set rowId=$o(^CTLOC(rowId))
		set deptData=$g(^CTLOC(rowId))
		continue:(deptData="")
		set showFlag=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("CT_Loc", rowId, hospId)
		continue:(showFlag="N")
		set wardFlag=$p(deptData,"^",5)
		continue:(wardFlag="Y")
		set dateFrom=$p(deptData,"^",24)
		set dateTo=$p(deptData,"^",25)
		continue:((dateFrom'="")&&(dateFrom>+$h))
		continue:((dateTo'="")&&(dateTo<+$h))          //+2018-01-16 ZhYW 过滤不在有效期的
		set contactName=$p(deptData,"^",43)          //科室检索码
		set deptName=$p(deptData,"^",2)
		continue:((desc'="")&&($$ALPHAUP^SSUTIL4(contactName)'[desc)&&($$ALPHAUP^SSUTIL4(deptName)'[desc))
		set deptName=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", deptName, langId)
		do OutputDept
	}
    
	quit $$$OK
    
OutputDept
	set Data=$lb(rowId,deptName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-07-13
/// Description: 查询病区(有预约时，取预约到的病区，否则取住院证上的病区。没有住院证时取科室关联病区)
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPreIPAdmTrans", "FindLinkedWard", "", "1")
Query FindLinkedWard(docIPBookId As %String, deptId As %String, langId As %String = "") As websys.Query(ROWSPEC = "id:%String,text:%String,selected:%Boolean")
{
}

ClassMethod FindLinkedWardExecute(ByRef qHandle As %Binary, docIPBookId As %String, deptId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
 	set ind=1
 	set ^TMP("FindLinkedWard")=$lb(docIPBookId, deptId)
 	
	set job=$j
	do ..GetLinkedWard(docIPBookId, deptId, job)
	set rowId=0
	while($o(^||TMP(job,rowId))) {
		set rowId=$o(^||TMP(job,rowId))
		set wardData=$g(^||TMP(job,rowId))
		continue:(wardData="")
		set wardDesc=$p(wardData,"^",1)
		set wardDesc=##class(User.PACWard).GetTranByDesc("WARDDesc", wardDesc, langId)
		set selected=$p(wardData,"^",2)
		do OutputLinkedWard
	}
	kill ^||TMP(job)

	quit $$$OK
OutputLinkedWard
	set Data=$lb(rowId,wardDesc,selected)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod GetLinkedWard(docIPBookId As %String, deptId As %String, job As %String) As %String
{
	kill ^||TMP(job)
	
	set wardType=""
	if (+docIPBookId'=0) {
		set appBedInfo=##class(Nur.InService.Interface).ifPatAppBed(docIPBookId)   //预约床位
 		set rtn=$p(appBedInfo,"^",1)
 		if (+rtn=0) {
	 		set deptDR=$p(appBedInfo,"^",2)
	 		if (+deptDR'=0) {
		 		set wardDR=$o(^PAWARD(0,"WARD_LocationDR",deptDR,"0"))
		 		set wardDesc=$s((+wardDR'=0):$p(^PAWARD(wardDR),"^",2), 1:"")
		 		if (+wardDR'=0) {
			 		set selected=1
			 		set ^||TMP(job,wardDR)=wardDesc_"^"_selected
			 	}
		 	}
			quit 0    //开启了床位预约时,只取预约的床位
	 	}else {
		 	set docIPBookInfo=##class(web.DHCDocIPBookNew).GetBookMesage(docIPBookId)
			set wardDR=$p(docIPBookInfo,"^",12)
			set wardDesc=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2), 1:"")
			if (+wardDR'=0) {
				set selected=1
				set ^||TMP(job,wardDR)=wardDesc_"^"_selected
			}
			set deptDR=$p(docIPBookInfo,"^",14)
			if (+deptDR'=0) {
				set deptId=deptDR
			}
			set wardType=$p(docIPBookInfo,"^",55)
		}
	}
	set defWard=""
	set rset=##class(%ResultSet).%New("web.DHCDocIPBookNew:CombListFind")
	do rset.Execute("InWard", deptId, defWard, wardType)
	while(rset.Next()) {
		set wardDR=$g(rset.Data("CombValue"))
		set wardDesc=$g(rset.Data("CombDesc"))
		set selected=0
		continue:($d(^||TMP(job,wardDR)))
		set ^||TMP(job,wardDR)=wardDesc_"^"_selected
	}
	kill rset
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2018-07-13
/// Description: 查询预住院就诊
/// Input: 
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPreIPAdmTrans", "FindAdmInfo", "2021-11-10","2021-11-17","40","","","12177^344^205^2^20")
Query FindAdmInfo(stDate As %String, endDate As %String, wardId As %String, patientId As %String, episodeId As %String, sessionStr As %String) As websys.Query(ROWSPEC = "RegNo:%String:登记号,MrNo:%String:病案号,PatName:%String:患者姓名,Sex:%String:性别,PatAge:%String:年龄,AdmDate:%String:就诊日期,AdmTime:%String:就诊时间,AdmDept:%String:就诊科室,AdmWard:%String:就诊病区,AdmReaDesc:%String:费别,Deposit:%Float:押金,MRDiagnos:%String:诊断,AuditFlag:%String:是否审核,DocIPBookId:%String,CurrStateDesc:%String:床位预约状态,Adm:%String,PatientId:%String")
{
}

ClassMethod FindAdmInfoExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, wardId As %String, patientId As %String, episodeId As %String, sessionStr As %String) As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	set ^TMP("FindAdmInfo")=$lb(stDate, endDate, wardId, patientId, episodeId, sessionStr)
	
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	set langId=$p(sessionStr,"^",5)
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	
	set lkLocIdStr=$case(##class(web.DHCBL.CT.ORCDaySurgeryLoc).IsDaySurgeryLoc(ctLocId),
						 "Y":##class(web.DHCBL.CT.ORCDaySurgeryLocLinkLoc).GetLinkLoc(ctLocId),
						 :"")

	if (+episodeId'=0) {
		set adm=episodeId
		do GetAdmInfo(adm)
		quit $$$OK
	}
	
	if (+patientId'=0) {
		set adm=""
		while($o(^PAPERdr(patientId,"ADM","I",adm),-1)) {
			set adm=$o(^PAPERdr(patientId,"ADM","I",adm),-1)
			set deptDR=$p(^PAADM(adm),"^",4)
			continue:((lkLocIdStr'="")&&(("^"_lkLocIdStr_"^")'[("^"_deptDR_"^")))
			do GetAdmInfo(adm)
		}
		quit $$$OK
	}
	
	for date=stDate:1:endDate {
		set adm=0
		while($o(^PAADMi("PAADM_AdmDate",date,adm))) {
			set adm=$o(^PAADMi("PAADM_AdmDate",date,adm))
			set deptDR=$p(^PAADM(adm),"^",4)
			continue:((lkLocIdStr'="")&&(("^"_lkLocIdStr_"^")'[("^"_deptDR_"^")))
			do GetAdmInfo(adm)
		}
	}
    
	quit $$$OK
	
GetAdmInfo(adm)
	set admData=$g(^PAADM(adm))
	quit:(admData="")
	set admType=$p(admData,"^",2)
	quit:(admType'="I")
	set visitStatus=$p(admData,"^",20)
	quit:(visitStatus'="P")
	set admHospDR=##class(web.UDHCHospitalGroup).GetHospitalByAdm(adm)
	quit:(admHospDR'=hospId)
	set papmi=$p(admData,"^",1)
    set patName=$p(^PAPER(papmi,"ALL"),"^",1)
	set regNo=$p(^PAPER(papmi,"PAT",1),"^",2)
	set mrNo=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(papmi, "I", hospId, "")
	set sexDR=$p(^PAPER(papmi,"ALL"),"^",7)
	set sex=$s((+sexDR'=0):$p(^CT("SEX",sexDR),"^",2), 1:"")
	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
	set patAge=##class(web.DHCBillInterface).GetPapmiAge(papmi, adm, hospId)  //年龄
	set admDate=$p(admData,"^",6)
	set admTime=$p(admData,"^",7)
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	set deptDR=$p(admData,"^",4)
    set dept=$s((+deptDR'=0):$p($g(^CTLOC(deptDR)),"^",2), 1:"")
    set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, langId)
	set wardDR=$p(admData,"^",70)
	quit:((wardId'="")&&(wardId'=wardDR))
	set ward=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2), 1:"")
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
	set admReaDR=$p($g(^PAADM(adm,1)),"^",7)
    set admReaDesc=$s((+admReaDR'=0):$p($g(^PAC("ADMREA",admReaDR)),"^",2), 1:"")
    set admReaDesc=##class(User.PACAdmReason).GetTranByDesc("READesc", admReaDesc, langId)
	set deposit=##class(web.UDHCJFBaseCommon).deposit(adm)
	set diagDesc=##class(DHCDoc.Interface.Inside.ServiceDiag).GetAdmDiagDesc(adm)
    set auditFlag=..GetAuditFlag(adm)
    set docIPBookId=$o(^DHCDocIPBK(0,"EpisodeIDTo",adm,""),-1)
	set currStateDR=$s((+docIPBookId'=0):$p($g(^DHCDocIPBK(docIPBookId)),"^",8),1:"")
	set currStateDesc=$s((+currStateDR'=0):$p($g(^DHCDocIPBDIC(currStateDR)),"^",2),1:"")
	set currStateDesc=##class(User.DHCDocIPBDictory).GetTranByDesc("MDICDesc", currStateDesc, langId)
	set isActive=$s((+docIPBookId'=0):$p($g(^DHCDocIPBK(docIPBookId)),"^",9),1:"")
	if (isActive'="Y") set docIPBookId=""
    do OutputAdmInfo
	quit

OutputAdmInfo
   	set Data=$lb(regNo,mrNo,patName,sex,patAge,admDate,admTime,dept,ward,admReaDesc,deposit,diagDesc,auditFlag,docIPBookId,currStateDesc,adm,papmi)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2018-07-22
/// Description: 转门诊审核
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).Audit(3218, 4632)
ClassMethod Audit(episodeId As %String, transType As %String, norOperFlag As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	set ^TMP("Audit")=$lb(episodeId, transType, norOperFlag, sessionStr)
	
	set userId=$p(sessionStr,"^",1)     //操作员RowID
	set groupId=$p(sessionStr,"^",2)    //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)    //登录科室RowID
	set hospId=$p(sessionStr,"^",4)     //登录医院RowID
	
	set rtn=0
	
	set transAdmType=..GetTransAdmType(transType, norOperFlag)  //O:门诊,I:住院,C:常规手术
	set transTypeDesc=..GetTransTypeDesc(transType, norOperFlag)
	
	set adm=episodeId
	quit:(+adm=0) ..GetErrMsg(-1, "就诊号为空")
	
	set admType=$p($g(^PAADM(adm)),"^",2)
	set visitStatus=$p($g(^PAADM(adm)),"^",20)
	quit:((admType'="I")||(visitStatus'="P")) ..GetErrMsg(-1, "非预住院患者不能审核")
	
	set auditFlag=..GetAuditFlag(adm)
	quit:(auditFlag="Y") ..GetErrMsg(-1, "已审核记录不能再次审核")
	
	set auditCfgPointCode="PREIP.PreIPToOPIP."_$s((norOperFlag="Y"):"ZCGSSSFXYSH",1:$case(transType,"O":"ZMZSFXYSH",:"ZZYSFXYSH"))
	set isNeedAudit=..GetToOPIPCfgValue(auditCfgPointCode, hospId)
	quit:(isNeedAudit=0) ..GetErrMsg(-1, "配置转"_transTypeDesc_"无需审核")
	
	//+2022-07-15 ZhYW 校验是否有未发药医嘱
	if (transType="O") {
		set rtn=##class(web.DHCBillPreIPAdmTrans).ChkMedOrdDisp(adm)
		if (+rtn) quit ..GetErrMsg(-1, "有处方未发药，需发药或撤销医嘱后才能转"_transTypeDesc_"审核")
	}
	
	ts
	
	set obj=##class(User.DHCBillPreIPAdmTransLog).%New()
	do obj.PTLADMDRSetObjectId(adm)
	set obj.PTLAdmType=transAdmType
	do obj.PTLAuditUserDRSetObjectId(userId)
	set obj.PTLAuditDate=+$h
	set obj.PTLAuditTime=$p($h,",",2)
	set obj.PTLAuditFlag="Y"
	set sc=obj.%Save()
	if $$$ISERR(sc){
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	if ($tl>0) tc

 	quit ..GetErrMsg(0, "审核成功")

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-07-22
/// Description: 撤销审核
/// Input: 
/// Return:  
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).CancelAudit(1776, 4632)
ClassMethod CancelAudit(episodeId As %String) As %String
{
	set $zt="ERROR"
	
	set adm=episodeId
	quit:(+adm=0) ..GetErrMsg(-1, "就诊号为空")
	
	set admType=$p($g(^PAADM(adm)),"^",2)
	set visitStatus=$p($g(^PAADM(adm)),"^",20)
	quit:((admType'="I")||(visitStatus'="P")) ..GetErrMsg(-1, "非预住院患者不能审核")
	
	set auditFlag=..GetAuditFlag(adm)
	quit:(auditFlag'="Y") ..GetErrMsg(-1, "没有审核记录，不能撤销")
	
	set rowId=$o(^DHCBillPreIPAdmTransLogi(0,"ADMDR",adm,""),-1)
	set sc=##class(User.DHCBillPreIPAdmTransLog).%DeleteId(rowId)
	if $$$ISERR(sc) {
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
 	quit ..GetErrMsg(0, "撤销成功")

ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-07-22
/// Description: 获取审核标识
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).GetAuditFlag(1776)
ClassMethod GetAuditFlag(episodeId As %String) As %String
{
	set auditFlag="N"
	quit:(+episodeId=0) auditFlag
	set rowId=$o(^DHCBillPreIPAdmTransLogi(0,"ADMDR",episodeId,""),-1)
	quit:(+rowId=0) auditFlag
	set auditFlag=$p(^DHCBillPreIPAdmTransLog(rowId),"^",9)
 	quit auditFlag
}

/// Creator: ZhYW
/// CreatDate: 2018-07-22
/// Description: 预约转门诊/住院
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).AdmTrans("3546","O","191","3","","18885^276^490^2^20")
ClassMethod AdmTrans(episodeId As %String, transType As %String, deptId As %String, wardId As %String, norOperFlag As %String, sessionStr As %String) As %String
{
	set $zt="ERROR"
	
	set rtn=0
	set ^TMP("AdmTrans")=$lb(episodeId, transType, deptId, wardId, norOperFlag, sessionStr)
	set userId=$p(sessionStr,"^",1)     //操作员RowID
	set groupId=$p(sessionStr,"^",2)    //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)    //登录科室RowID
	set hospId=$p(sessionStr,"^",4)     //登录医院RowID
	
	set adm=episodeId
	
	//+2022-10-18 ZhYW 转门诊/住院/常规手术前先校验数据的合法性
	set rtnValue=..CheckTransData(adm, transType, deptId, wardId, norOperFlag, sessionStr)
	set rtn=$p(rtnValue,"^",1)
	quit:(+rtn) rtnValue
	
	set transTypeDesc=..GetTransTypeDesc(transType, norOperFlag)

	set papmi=$p($g(^PAADM(adm)),"^",1)
	set docIPBookId=$o(^DHCDocIPBK(0,"EpisodeIDTo",adm,""),-1)
	
	ts

	if (transType="O") {
		set rtn=##class(web.DHCDocIPBookNew).CancelBookStatu(docIPBookId, userId)
		if (+rtn) tro  quit ..GetErrMsg(+rtn, "撤销住院证失败:"_rtn)

		set docIPAppId=$o(^DHCDocIPApp(0,"IPBookingID",docIPBookId,0))
		if (+docIPAppId'=0) {
			set docIPAppObj=##class(User.DHCDocIPAppointment).%OpenId(docIPAppId, 0)   //更新预约状态，否则病区床位图还显示
			set docIPAppObj.IPStatus="C"
			set sc=docIPAppObj.%Save()
			do docIPAppObj.%Close()
			if $$$ISERR(sc) {
				tro
				quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
			}
			set papmi=$p($g(^PAADM(adm)),"^",1)
			do ##class(Nur.DHCBedApointflag).Cancel("C", userId, papmi)
		}
	}else {
		set rtn=##class(web.DHCDocIPBookingCtl).PatientArrive(docIPBookId, adm, userId)
		if (+rtn) tro  quit ..GetErrMsg(+rtn, "更新住院证失败:"_rtn)

		//更新诊断日期
		set rtn=##class(web.DHCDocIPBookNew).UpdatePreInPatDiagDate(adm, userId)
		if (+rtn) tro  quit ..GetErrMsg(+rtn, "更新诊断日期失败:"_$p(rtn,"^",2))
	}
	
	//转门诊和转常规手术时日间手术标识取消、日间手术申请撤销
    if ((transType="O")||(norOperFlag="Y")) {
	    //撤销患者日间手术标识
		set rtn=##class(web.DHCDocIPBookNew).CancelDaySurg(adm, userId)
		if (+rtn) tro  quit ..GetErrMsg(+rtn, "撤销日间手术标识失败:"_rtn)
		
		//撤销日间手术
		do ##class(web.DHCANAdaptor).CancelDayOper(adm, userId)
	}
	
	set admTimes=+$p($g(^PAPER(papmi,"PER",4)),"^",8)
	set admTimes=$i(admTimes)
	
	set admObj=##class(User.PAAdm).%OpenId(adm, 0)
	set admObj.PAADMType=transType
	set admObj.PAADMVisitStatus="A"
	set admObj.PAADMUpdateDate=+$h
	set admObj.PAADMUpdateTime=$p($h,",",2)
	do admObj.PAADMUpdateUserDRSetObjectId(userId)
	if (transType="I") {
		if (..#UpdateAdmDateFlag=1) {
			set admObj.PAADMAdmDate=+$h
			set admObj.PAADMAdmTime=$p($h,",",2)
		}
		//2020-01-25 ZhYW 入院情况
		if ('admObj.PAADMAdmCategDRGetObjectId()) {
			set defAdmCatId=##class(web.DHCIPBillReg).GetDefAdmCatId()
			do admObj.PAADMAdmCategDRSetObjectId(defAdmCatId)
		}
		do admObj.PAADMDepCodeDRSetObjectId(deptId)
		do admObj.PAADMCurrentWardDRSetObjectId(wardId)
		set admObj.PAADMInPatNo=admTimes
	}
	set sc=admObj.%Save()
	do admObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	
	//预住院转住院 增加住院次数
	if (transType="I") {
		set personObj=##class(User.PAPerson).%OpenId(papmi, 0)
		set personObj.PAPERExemptionNumber=admTimes
		set sc=personObj.%Save()
		do personObj.%Close()
		if $$$ISERR(sc) {
			tro
			quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
		}
	}
 	
	set rowId=$o(^DHCBillPreIPAdmTransLogi(0,"ADMDR",adm,""),-1)
	if (+rowId'=0) {
		set transLogObj=##class(User.DHCBillPreIPAdmTransLog).%OpenId(rowId, 0)
	}else {
		set transLogObj=##class(User.DHCBillPreIPAdmTransLog).%New()
	}
	do transLogObj.PTLADMDRSetObjectId(adm)
	set transLogObj.PTLAdmType=transType
	do transLogObj.PTLUserDRSetObjectId(userId)
	set transLogObj.PTLDate=+$h
	set transLogObj.PTLTime=$p($h,",",2)
	set transLogObj.PTLAuditFlag=$s((transLogObj.PTLAuditFlag'=""):transLogObj.PTLAuditFlag,1:"N")
	set sc=transLogObj.%Save()
	do transLogObj.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	
	if (transType="O") {
		//转门诊时,需取消预约床位
		set rtn=##class(Nur.InService.Interface).cancelPatAppBed(docIPBookId, userId)
		if (+rtn) tro  quit ..GetErrMsg(+rtn, "取消预约床位失败:"_rtn)

		//删除B状态账单
		set pb=0
		while ($o(^DHCPB(0,"ADM",adm,pb))) {
			set pb=$o(^DHCPB(0,"ADM",adm,pb))
			set pbData=$g(^DHCPB(pb))
			continue:(pbData="")
			set payedFlag=$p(pbData,"^",16)
			continue:(payedFlag'="B")
			set rtn=..UpdateAppRepBilled(pb)     //更新新版检查申请单中间表
			quit:(+rtn)
			set sc=##class(User.DHCPatientBill).%DeleteId(pb)
			if ($$$ISERR(sc)) {
				set rtn=$system.Status.GetErrorCodes(sc)
				quit
			}
			//记录日志,用于综合查询组冲账
			set ^DHCBILLPREDEL(+$h,pb)=adm_"^"_pb
		}
	}else {
		set rtn=##class(web.DHCDischargeHistory).SaveAdminDateTime(adm, +$h, $p($h,",",2), 1, deptId, wardId)
		if (+rtn=-2) tro  quit ..GetErrMsg(+rtn, "转"_transTypeDesc_"失败:"_rtn)

		set rtn=0
		set admTransObj=##class(User.PAAdmTransaction).%New(adm)
		do admTransObj.TRANSParRefSetObjectId(adm)
		set admTransObj.TRANSStartDate=+$h
		set admTransObj.TRANSStartTime=$p($h,",",2)
		do admTransObj.TRANSCTLOCDRSetObjectId(deptId)
		set transReqStatusDR=$o(^PAC("REQST",0,"Code","T",0))    //Transfer
		do admTransObj.TRANSStatusDRSetObjectId(transReqStatusDR)
		set admTransObj.TRANSMain="Y"
		set admTransObj.TRANSUpdateDate=+$h
		set admTransObj.TRANSUpdateTime=$p($h,",",2)
		do admTransObj.TRANSUpdateUserDRSetObjectId(userId)
		set sc=admTransObj.%Save()
		set admTransId=admTransObj.%Id()
		do admTransObj.%Close()
		if $$$ISERR(sc) {
			tro
			quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
		}
		set wardAdmObj=##class(User.PACWardAdm).%New(wardId)
		do wardAdmObj.WADMParRefSetObjectId(wardId)
		do wardAdmObj.WADMPAADMDRSetObjectId(adm)
		set wardAdmObj.WADMBookedStatus="O"
		do wardAdmObj.WADMTransDRSetObjectId(admTransId)
		set sc=wardAdmObj.%Save()
		do wardAdmObj.%Close()
		if $$$ISERR(sc) {
			tro
			quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
		}
	}
	if (+rtn) tro  quit ..GetErrMsg(+rtn, "转"_transTypeDesc_"失败")
	
	if ($tl>0) tc
	
	//调用账单
	do ##class(web.UDHCJFBILL).BILLN(adm, userId)

	set msg="转"_transTypeDesc_"成功"
	
	if (transType="I") {
		//病案接诊、分配病案号
		set retValue=##class(DHCWMR.IO.ToOutService).IGroupReceipt(adm, "", ctLocId, userId)
		if ($p(retValue,"^",1)'=1) {
			set msg=msg_"，接诊失败，请手工接诊"
		}
		//+2023-02-23 ZhYW 住院登记后推送服务
		do ##class(BILL.IP.BL.SendSrv).SendRegInfo(adm, sessionStr)
	}
	
 	quit ..GetErrMsg(+rtn, msg)
 	
ERROR
	quit ..AppException()
}

/// Creator: ZhYW
/// CreatDate: 2018-07-11
/// Description: 更新新版检查申请单中间表
/// Input: bill: DHC_PatientBill.RowId
/// Return: rtn:(0:更新成功, <>0:更新失败)
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).UpdateAppRepBilled(274901)
ClassMethod UpdateAppRepBilled(bill As %String) As %String
{
	set rtn=0
	quit:(+bill=0) rtn
	
	set pbo=0
	while($o(^DHCPB(bill,"O",pbo))&&(+rtn=0)) {
		set pbo=$o(^DHCPB(bill,"O",pbo))
		set pboData=$g(^DHCPB(bill,"O",pbo))
		continue:(pboData="")
		set pboRowId=bill_"||"_pbo
		set artiDR=0
		while($o(^DHCAPREPTA(0,"PBO",pboRowId,artiDR))&&(+rtn=0)) {
			set artiDR=$o(^DHCAPREPTA(0,"PBO",pboRowId,artiDR))
			set artiData=$g(^DHCAPREPTA(artiDR))
			continue:(artiData="")
			set billStatus=$p(artiData,"^",9)   //账单状态
			continue:(billStatus'="B")
			&SQL(
				UPDATE DHC_AppRepTarItm
				SET ARTI_Billed = 'TB', ARTI_PBO_Dr = NULL
				WHERE %ID = :artiDR
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
/// CreatDate: 2018-07-11
/// Description: 获取患者在院就诊数量,控制能不能办理住院
/// Input: papmi: PA_PatMas
/// Return: rtn:(0:可以办理住院, <>0:不能再办理住院)
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).GetAdminIPAdmNum(636)
ClassMethod GetAdminIPAdmNum(papmi As %String) As %String
{
	set num=0
	quit:(+papmi=0) num
	
	set adm=0
	while($o(^PAPERdr(papmi,"ADM","I",adm))&&(num=0)) {
		set adm=$o(^PAPERdr(papmi,"ADM","I",adm))
		set visitStatus=$p($g(^PAADM(adm)),"^",20)
		continue:(visitStatus'="A")
		set num=$i(num)
	}
	
	quit num
}

/// Creator: ZhYW
/// CreatDate: 2018-07-11
/// Description: 判断转入门诊费用是否已结清
/// Input: episodeId: PA_Adm.RowID, sessionStr: 用户Id^安全组Id^登录科室Id^医院Id
/// Return: rtn:(0:可以退押金, 1:有效医嘱不能退押金, 2:有未结算医嘱不能退押金)
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).CheckRefDeposit(1963, "")
ClassMethod CheckRefDeposit(episodeId As %String, sessionStr As %String) As %String
{
	set rtn=0
	quit:(+episodeId=0) rtn
	
	set userId=$p(sessionStr,"^",1)
	set groupId=$p(sessionStr,"^",2)
	set ctLocId=$p(sessionStr,"^",3)
	set hospId=$p(sessionStr,"^",4)
	
	set visitStatus=$p($g(^PAADM(episodeId)),"^",20)
	if (visitStatus="P") {
		set ord=0
		while($o(^OEORD(0,"Adm",episodeId,ord))&&(+rtn=0)) {
			set ord=$o(^OEORD(0,"Adm",episodeId,ord))
			set sub=0
			while($o(^OEORD(ord,"I",sub))&&(+rtn=0)) {
				set sub=$o(^OEORD(ord,"I",sub))
				set oeori=ord_"||"_sub
				//set myPriorFlag=##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(oeori)
				//continue:(+myPriorFlag=1)   //自备药品退出
				set itmStatDR=$p(^OEORD(ord,"I",sub,1),"^",13)
				set statCode=$s((+itmStatDR'=0):$p($g(^OEC("OSTAT",itmStatDR)),"^",1), 1:"")
				if (" V E "[(" "_statCode_" ")) {
					set rtn=$i(rtn)
				}
			}
		}
		quit:(+rtn>0) 1
	}else {
		set admType=$p($g(^PAADM(episodeId)),"^",2)
		quit:(admType'="O") rtn
		set rowId=$o(^DHCBillPreIPAdmTransLogi(0,"ADMDR",episodeId,""),-1)
		quit:(+rowId=0) rtn
		set transAdmType=$p(^DHCBillPreIPAdmTransLog(rowId),"^",2)
		quit:(transAdmType'="O") rtn
		set transUserDR=$p(^DHCBillPreIPAdmTransLog(rowId),"^",3)
		quit:(+transUserDR=0) rtn
		set rtn=##class(web.DHCBillInterface).GetnotPayOrderByRegno("", episodeId, ctLocId)
		quit:(+rtn>0) 2
	}
	
	quit 0
}

ClassMethod GetErrMsg(rtn As %String, msg As %String) As %String
{
	quit rtn_"^"_msg
}

/// Creator: ZhYW 
/// CreatDate: 2022-07-15
/// Description: 判断就诊对应的药品医嘱的发药状态
/// Input: episodeId: PA_Adm.RowID, isDisped(0:查询未发药，1:查询已发药)
/// Return: 1:是，0:否
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).ChkMedOrdDisp(535)
ClassMethod ChkMedOrdDisp(adm As %String, isDisped As %String = 0) As %String
{
	set rtn=0
	quit:(+adm=0) rtn
	set ord=##class(web.DHCOPAdmFind).GetPAADMOrderRowid(adm)
	quit:(+ord=0) rtn
	set itm=0
	while($o(^OEORD(ord,"I",itm))) {
		set itm=$o(^OEORD(ord,"I",itm))
		continue:('$d(^OEORD(ord,"I",itm,1)))
		set oeitm=ord_"||"_itm
		continue:(##class(web.UDHCOEORDOP1).ReadOECPriorityFlag(oeitm)=1)      //自备药医嘱退出
		set statDR=$p($g(^OEORD(ord,"I",itm,1)),"^",13)
		set statCode=$s((+statDR'=0):$p($g(^OEC("OSTAT",statDR)),"^",1),1:"")
		continue:(" V E "'[(" "_statCode_" "))
		set orderType=##class(web.UDHCJFBaseCommon).GetOrdCateType(oeitm)
		continue:(orderType'="R")
		set dispFlag=##class(BILL.Interface.Inside.Invoke).IsDispByOeoriForPreIP(oeitm)
		continue:((isDisped=0)&&(dispFlag="Y"))   //查询未发药时，过滤已发药医嘱
		continue:((isDisped=1)&&(dispFlag'="Y"))  //查询已发药时，过滤未发药医嘱
		set rtn=1
		quit
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-10-18
/// Description: 转门诊/住院/常规手术前先校验数据的合法性
/// Input: 
/// Return: rtn:(0:校验通过, <>0:校验不通过)
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).CheckTransData(274901)
ClassMethod CheckTransData(adm As %String, transType As %String, deptId As %String, wardId As %String, norOperFlag As %String, sessionStr As %String) As %String
{
	set userId=$p(sessionStr,"^",1)     //操作员RowID
	set groupId=$p(sessionStr,"^",2)    //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)    //登录科室RowID
	set hospId=$p(sessionStr,"^",4)     //登录医院RowID

	quit:((+adm=0)||(" O I "'[(" "_transType_" "))) ..GetErrMsg(-1, "参数错误")
	
	set transAdmType=..GetTransAdmType(transType, norOperFlag) //O:门诊,I:住院,C:常规手术
	set transTypeDesc=..GetTransTypeDesc(transType, norOperFlag)
	
	set admType=$p($g(^PAADM(adm)),"^",2)
	set visitStatus=$p($g(^PAADM(adm)),"^",20)
	quit:((admType'="I")||(visitStatus'="P")) ..GetErrMsg(-1, "非预住院患者不能，不能转"_transTypeDesc)
	
	set papmi=$p($g(^PAADM(adm)),"^",1)
	
	set docIPBookId=$o(^DHCDocIPBK(0,"EpisodeIDTo",adm,""),-1)
	set isActive=$s((+docIPBookId'=0):$p($g(^DHCDocIPBK(docIPBookId)),"^",9), 1:"")
	quit:((+docIPBookId=0)||(isActive'="Y")) ..GetErrMsg(-1, "该就诊没有有效的住院证信息")
	
	set auditCfgPointCode="PREIP.PreIPToOPIP."_$s((norOperFlag="Y"):"ZCGSSSFXYSH",1:$case(transType,"O":"ZMZSFXYSH",:"ZZYSFXYSH"))
	set isNeedAudit=..GetToOPIPCfgValue(auditCfgPointCode, hospId)
	if (isNeedAudit=1) {
		set auditFlag=..GetAuditFlag(adm)
		quit:(auditFlag'="Y") ..GetErrMsg(-1, "此就诊没有审核，如需转"_transTypeDesc_"请先审核")
	}
	
	set auditId=$o(^DHCBillPreIPAdmTransLogi(0,"ADMDR",adm,""),-1)
	set auditAdmType=$s((+auditId'=0):$p(^DHCBillPreIPAdmTransLog(auditId),"^",2),1:"")
	quit:((auditAdmType'="")&&(transAdmType'=auditAdmType)) ..GetErrMsg(-1, "已申请转"_$case(auditAdmType,"O":"门诊","I":"住院","C":"常规手术",:"")_"，如需转"_transTypeDesc_"，请先撤销审核")
	
	if (transType="O") {
		//+2022-07-15 ZhYW 校验是否有未发药医嘱
		set rtn=##class(web.DHCBillPreIPAdmTrans).ChkMedOrdDisp(adm)
		quit:(+rtn) ..GetErrMsg(-1, "有处方未发药，需发药或撤销医嘱后才能转门诊")
	}
	
	if (transType="I") {
		set adminNum=..GetAdminIPAdmNum(papmi)
		quit:(+adminNum>0) ..GetErrMsg(-1, "该患者已经在院，不能转"_transTypeDesc)
		
		//+2021-11-18 ZhYW 调用接口判断有未执行医嘱时是否可入院
		set allowInAdmCfg=##class(web.DHCBL.CT.ORCDaySurgeryConfig).GetDSCContentByCode("WZXZRY", hospId)
		if (allowInAdmCfg'="Y") {
			set noExecFlag=##class(Nur.InService.Interface).ifHasNotExecOrder(adm)
			quit:(noExecFlag="Y") ..GetErrMsg(-1, "该患者有未执行的医嘱，不能转"_transTypeDesc)
		}
		
		set treatedPriDR=$p($g(^PAADM(adm,"DHC")),"^",49)
		set treatedPriCode=$s((+treatedPriDR'=0):$p($g(^DHCDocIPBDIC(treatedPriDR)),"^",1), 1:"")
		if (treatedPriCode="DaySurg") {
			if (norOperFlag'="Y") {
				set rtnValue=##class(web.DHCANAdaptor).CheckValidDayOper(adm)   //日间手术的患者有正式的日间手术申请
				if ($p(rtnValue,"^",1,2)'="Y^A") {
					quit ..GetErrMsg(-1, "该患者没有正式的日间手术申请，只能转入门诊或转入常规手术")
				}
			}
		}else {
			if (norOperFlag="Y") {
				quit ..GetErrMsg(-1, "该患者非日间手术患者，不能转"_transTypeDesc)
			}
		}
		if ((+deptId=0)||(+wardId=0)) {
			quit ..GetErrMsg(-1, "转"_transTypeDesc_"时，科室和病区不能为空")
		}
		
		//床位预约判断
		set appBedInfo=##class(Nur.InService.Interface).ifPatAppBed(docIPBookId)   //是否预约到床位
		set rtn=$p(appBedInfo,"^",1)
		if (+rtn) {
			set appSwitch=##class(Nur.InService.Interface).ifHospNeedAppByWard(wardId)
			if (appSwitch="Y") {
				quit ..GetErrMsg(-1, $p(appBedInfo,"^",2))   //转入病区开启了床位预约，但没有预约到床位时不能转入
			}
			set rtn=0  //未开启床位预约时，将该值置为0
			set wardBedIdleNum=##class(Nur.Interface.OutSide.Ward).GetWardBedIdleNum(wardId)
			if (+wardBedIdleNum'>0) {
				quit ..GetErrMsg(-1, "该病区没有可用床位")
			}
		}else {
			set appWardLocId=$p(appBedInfo,"^",2)
			set appBedId=$p(appBedInfo,"^",3)
			set wardLocDR=$p($g(^PAWARD(wardId)),"^",5)
			if (appWardLocId'=wardLocDR) {
				set appWard=$p(^CTLOC(appWardLocId),"^",2)
				set appBed=$p(^PAWARD(+appBedId,"BED",$p(appBedId,"||",2)),"^",1)
				quit ..GetErrMsg(-1, "患者已预约了"_appWard_"病区"_appBed_"床，不能转入其它病区")
			}
		}
		
		set birthDate=$p($g(^PAPER(papmi,"ALL")),"^",6)
		set sexDR=$p($g(^PAPER(papmi,"ALL")),"^",7)
		set age=##class(web.DHCBillInterface).GetPapmiAge(papmi, adm, hospId)  //年龄
		set wardLocDR=$p(^PAWARD(wardId),"^",5)
		set rtnValue=##class(web.DHCIPBillReg).GetSexAndAgeByLoc(wardLocDR, sexDR, age, birthDate)
		set rtn=$p(rtnValue,"^",1)
		quit:(+rtn) rtnValue
		
		set locBeInHospital=$p($g(^CTLOC(deptId)),"^",87)
		if (locBeInHospital="Y") {
			set currentStateDR=$p($g(^DHCDocIPBK(docIPBookId)),"^",8)
			set IPMDICCode=$p($g(^DHCDocIPBDIC(+currentStateDR)),"^",1)
			if (IPMDICCode'="SignBed") {
				quit ..GetErrMsg(-1, "科室开启了住院总签床，但住院证状态不是签床，不能转"_transTypeDesc)
			}
		}
	}
	
	quit rtn
}

/// Creator: ZhYW
/// CreatDate: 2022-10-18
/// Description: 根据转入代码取转入类型描述
/// Input: transType:转入类型代码, norOperFlag:是否常规手术
/// Return: 
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).GetTransTypeDesc("O", "")
ClassMethod GetTransTypeDesc(transType As %String, norOperFlag As %String) As %String
{
	quit $s((norOperFlag="Y"):"常规手术",1:$case(transType,"O":"门诊",:"住院"))
}

/// Creator: ZhYW
/// CreatDate: 2022-10-18
/// Description: 根据转入代码取转入类型描述
/// Input: transType:转入类型代码, norOperFlag:是否常规手术
/// Return: 
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).GetTransAdmType("O", "")
ClassMethod GetTransAdmType(transType As %String, norOperFlag As %String) As %String
{
	quit $s((norOperFlag="Y"):"C",1:transType)    //O:门诊,I:住院,C:常规手术
}

/// Creator: ZhYW
/// CreatDate: 2022-10-18
/// Description: 取预住院转门诊/住院值类型配置
/// Input: cfgPointCode:配置点代码, hospId: CT_Hospital.RowId
/// Return: 1:是, 0:否
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).GetToOPIPCfgValue("PREIP.PreIPToOPIP.ZCGSSSFXYSH", 2)
ClassMethod GetToOPIPCfgValue(cfgPointCode As %String, hospId As %String) As %String
{
    set jsonStr=##class(BILL.CFG.COM.GeneralCfg).GetResultByRelaCode(cfgPointCode, "", "", hospId)
	set cfgData=##class(%DynamicObject).%FromJSON(jsonStr).data
	quit ($zcvt($p(cfgData,"^",2),"U")="YES")
}

/// Creator: LUANZH
/// CreatDate: 2023-03-09
/// Description: 查询预住院转入信息
/// Input: stDate:开始时间,endDate:结束时间,admType: O->转门诊，I->转住院,deptId:就诊科室,userId:操作人
/// Output: 
/// Debug: do ##class(%ResultSet).RunQuery("web.DHCBillPreIPAdmTrans", "QryPreIPAdmTransList","2023-03-10","2023-03-10","O","","")
Query QryPreIPAdmTransList(stDate As %String, endDate As %String, admType As %String, deptId As %String, userId As %String, langId As %String = "") As websys.Query(ROWSPEC = "RegNo:%String:登记号,PatientId:%String:患者ID,PatName:%String:患者姓名,Sex:%String:性别,Age:%String:年龄,AdmDate:%String:入院日期,AdmTime:%String:入院时间,AdmDept:%String:转入科室,AdmWard:%String:转入病区,AdmLocMedUnit:%String:科室医疗组,BookUser:%String:住院证开立人,TransDate:%String:转入日期,TransTime:%String:转入时间,TransUser:%String:操作员") [ SqlProc ]
{
}

ClassMethod QryPreIPAdmTransListExecute(ByRef qHandle As %Binary, stDate As %String, endDate As %String, admType As %String, deptId As %String, userId As %String, langId As %String = "") As %Status
{
	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1
	if ((stDate="")||(endDate="")) quit $$$OK
	set ^TMP("QryPreIPAdmTransList")=$lb(stDate, endDate, admType, deptId, userId)
	
	if ((langId="")&&($d(%session))) {
		set langId=%session.Get("LOGON.LANGID")
	}
	
	set stDate=##class(websys.Conversions).DateHtmlToLogical(stDate)
	set endDate=##class(websys.Conversions).DateHtmlToLogical(endDate)

	for date=stDate:1:endDate {
		set rowId=0
		while($o(^DHCBillPreIPAdmTransLogi(0,"Date",date,rowId))) {
			set rowId=$o(^DHCBillPreIPAdmTransLogi(0,"Date",date,rowId))
			set preIpAdmTransData=$g(^DHCBillPreIPAdmTransLog(rowId))
			do GetPreIpAdmTransData
		}
	}
	
	quit $$$OK

GetPreIpAdmTransData
	set adm=$p(preIpAdmTransData,"^",1)                             //就诊号
	set admData=$g(^PAADM(adm))
    set admDate=$p(admData,"^",6)                                   //入院日期
	set admTime=$p(admData,"^",7)									  //入院时间
	set admDate=##class(websys.Conversions).DateLogicalToHtml(admDate)
	set admTime=##class(websys.Conversions).TimeLogicalToHtml(admTime)
	set deptDR=$p(admData,"^",4)                                    //就诊科室
	quit:((deptId'="")&&(deptDR'=deptId))
    set dept=$s((+deptDR'=0):$p($g(^CTLOC(deptDR)),"^",2), 1:"")
	set dept=##class(User.CTLoc).GetTranByDesc("CTLOCDesc", dept, langId)
	set wardDR=$p(admData,"^",70)                                   //就诊病区
	set ward=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2), 1:"") 
	set ward=##class(User.PACWard).GetTranByDesc("WARDDesc", ward, langId)
	set bookId=$o(^DHCDocIPBK(0,"EpisodeIDTo",adm,""))
	set bookData=$g(^DHCDocIPBK(+bookId))
	set admLocMedUnitDR=$p(bookData,"^",30)
	set admLocMedUnit=$s((admLocMedUnitDR'=""):$p(^CTLOC(+admLocMedUnitDR,"MU",$p(admLocMedUnitDR,"||",2)),"^",2),1:"")		//科室医疗单元
	set admLocMedUnit=##class(User.DHCCTLocMedUnit).GetTranByDesc("CTMUDesc", admLocMedUnit, langId)
	set bookUserDR=$p(bookData,"^",6)
	set bookUser=$s((bookUserDR'=""):$p($g(^SSU("SSUSR",bookUserDR)),"^",2),1:"") //预住院证开立人
	set bookUser=##class(User.SSUser).GetTranByDesc("SSUSRName", bookUser, langId)
	set transDate=$p(preIpAdmTransData,"^",4)                       //预住院转门诊/住院日期
	set transTime=$p(preIpAdmTransData,"^",5)                       //预住院转门诊/住院时间
	set transDate=##class(websys.Conversions).DateLogicalToHtml(transDate)
	set transTime=##class(websys.Conversions).TimeLogicalToHtml(transTime)
	set ptlAdmType=$p(preIpAdmTransData,"^",2)                      //转门诊/转住院
	quit:((admType'="")&&(ptlAdmType'=admType))
	set transUserDR=$p(preIpAdmTransData,"^",3)                    //操作人
	quit:((userId'="")&&(userId'=transUserDR))
	set transUser=$s((transUserDR'=""):$p($g(^SSU("SSUSR",transUserDR)),"^",2),1:"")
	set transUser=##class(User.SSUser).GetTranByDesc("SSUSRName", transUser, langId)
	set patientId=$p(admData,"^",1)                                 //患者ID
	set patName=$p(^PAPER(patientId,"ALL"),"^",1)	  //患者姓名
	set patAge=##class(web.DHCBillInterface).GetPapmiAge(patientId, adm)  //年龄
	set regNo=$p(^PAPER(patientId,"PAT",1),"^",1)	  //登记号
	set sexDR=$p(^PAPER(patientId,"ALL"),"^",7)
	set sex=$s((sexDR'=""):$p($g(^CT("SEX",sexDR)),"^",2),1:"")     //性别
	set sex=##class(User.CTSex).GetTranByDesc("CTSEXDesc", sex, langId)
    do OutputPreIpAdmTransDataList
    quit
   
OutputPreIpAdmTransDataList
	set data=$lb(regNo,patientId,patName,sex,patAge,admDate,admTime,dept,ward,admLocMedUnit,bookUser,transDate,transTime,transUser)
	set ^CacheTemp(repid,ind)=data
	set ind=ind+1
	quit
}

/// Creator: ZhYW
/// CreatDate: 2023-05-04
/// Description: 预约转住院-给住院登记页面提供
/// Input: 
/// Return: 
/// Debug: w ##class(web.DHCBillPreIPAdmTrans).Trans2IPFromReg()
ClassMethod Trans2IPFromReg(personXML As %String, personExpXML As %String, admXML As %String, sessionStr As %String, expStr As %String) As %String
{
	set $zt="ERROR"
	
	set userId=$p(sessionStr,"^",1)      //操作员RowID
	set groupId=$p(sessionStr,"^",2)     //安全组RowID
	set ctLocId=$p(sessionStr,"^",3)     //登录科室RowID
	set hospId=$p(sessionStr,"^",4)      //登录医院RowID
	
	set photoStream=$p(expStr,"^",1)      //照片信息(Base64编码串)
	
	set personObj=##class(BILL.IP.DTO.Entity.Reg.PAPerson).%New()
	do personObj.XMLDeserialize(.personObj, personXML)
	if (photoStream'="") {
		set personObj.PhotoStream=photoStream
	}
	
	set personExpObj=##class(BILL.IP.DTO.Entity.Reg.PAPersonExp).%New()
	do personExpObj.XMLDeserialize(.personExpObj, personExpXML)
	
	set admObj=##class(BILL.IP.DTO.Entity.Reg.PAAdm).%New()
	do admObj.XMLDeserialize(.admObj, admXML)
	
	//患者类别为空时根据费别取默认的患者类别
	if ((+personObj.SocialStatus=0)&&(+admObj.AdmReason'=0)) {
		set personObj.SocialStatus=##class(web.DHCIPBillReg).GetDefSocStatIdByInsType(admObj.AdmReason, hospId)
	}
	
	set personExpObj.BirthDate=##class(websys.Conversions).DateHtmlToLogical(personExpObj.BirthDate)
	set personExpObj.BirthTime=##class(websys.Conversions).TimeHtmlToLogical(personExpObj.BirthTime)
	//没有写身份证号时,若所选证件类型为身份证,则身份证号即证件号
	if ((+personExpObj.CredType'=0)&&(personExpObj.CredNo'="")) {
		set credTypeCode=$p($g(^PAC("CARD",+personExpObj.CredType)),"^",1)
		if (credTypeCode="01") {     //"01"为身份证
			set personObj.IDNo=personExpObj.CredNo
		}
	}
	
	ts
  	
  	set rtnValue=##class(web.DHCIPBillReg).SavePatInfo(personObj, personExpObj, admObj, sessionStr, 1)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	set rtnValue=..AdmTrans(admObj.EpisodeID, "I", admObj.Dept, admObj.Ward, "", sessionStr)
	set rtn=$p(rtnValue,"^",1)
	if (+rtn) tro  quit rtnValue
	
	set objectAdm=##class(User.PAAdm).%OpenId(admObj.EpisodeID, 0)
 	do objectAdm.PAADMAdmCategDRSetObjectId(admObj.AdmCategory)
 	do objectAdm.PAADMAdmReasonDRSetObjectId(admObj.AdmReason)
 	do objectAdm.PAADMEpissubtypeDRSetObjectId(admObj.EpisSubType)
 	do objectAdm.PAADMAdmDocCodeDRSetObjectId(admObj.Doctor)
 	do objectAdm.PAADMAdmSrcDRSetObjectId(admObj.AdmSource)
 	do objectAdm.PAADMReferralPriorityDRSetObjectId(admObj.AdmReferPriority)
	set sc=objectAdm.%Save()
	do objectAdm.%Close()
	if $$$ISERR(sc) {
		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	
	//修改优惠类型、推荐医生、就诊备注信息
  	set objectAdmExt=##class(User.PAAdmExt).%OpenId(admObj.EpisodeID, 0)
  	do objectAdmExt.PAADMRegConDisDRSetObjectId(admObj.RegConDisc)      //更新优惠类型
  	do objectAdmExt.PAADMAdviseDocDrSetObjectId(admObj.AdviseDoc)       //推荐医生
  	do objectAdmExt.PAADMRemarks.Clear()
	do objectAdmExt.PAADMRemarks.Insert(admObj.AdmRemark)        //2022-09-02 ZhYW 就诊备注(患者便签)
  	set sc=objectAdmExt.%Save()
  	do objectAdmExt.%Close()
  	if $$$ISERR(sc) {
  		tro
		quit ..GetErrMsg($system.Status.GetErrorCodes(sc), $system.Status.GetErrorText(sc))
	}
	
	if ($tl>0) tc
	
	quit rtn_"^"_$p(rtnValue,"^",2)_"^"_personObj.PatientID_"^"_admObj.EpisodeID
 	
ERROR
	quit ..AppException()
}

}
