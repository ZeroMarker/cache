Import SQLUser

/// Creator: wenlai
/// Descript: 处方查询页面后台方法
/// CreateDate: 2022-01-06
Class web.DHCPRESCList Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator: wenlai
/// Descript: 获取处方列表
/// CreateDate: 2022-01-06
/// Input:
/// Output:
/// other: w ##class(web.DHCPRESCList).GetPrescList("30","1","2023-03-01^2023-03-01^^^^^^18946")
ClassMethod GetPrescList(rows, page, params)
{
	//2022-01-12^2022-01-12^111^666^禁止^73^152
	s ^temptest("222") = $lb(rows, page, params)
	set End = page*rows
	set Start=(page-1)*rows+1
	set stDate = $p(params,"^",1)
	set:stDate'="" stDate = ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(stDate)
	set endDate = $p(params,"^",2)
	set:endDate'="" endDate = ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(endDate)
	set patno = $p(params,"^",3)
	set admno = $p(params,"^",4)
	set warn = $p(params,"^",5)
	set problem = $p(params,"^",6) 
	set drug = $p(params,"^",7)
	set userID = $p(params,"^",8)
	set count = 0
	i userID  d
	.k ^TMP("DHCPRESC","web.DHCPRESCList","GetPrescPrtList",userID)
	w "{""rows"":["
	
	for dd = stDate:1:endDate{
		
		set time = ""
		for {
			set time = $o(^PHA.PREADT.AuditI("Date",dd,time))	
			quit:time=""
			
			set auditID = ""
			for {
				set auditID = $o(^PHA.PREADT.AuditI("Date",dd,time,auditID))	
				quit:auditID=""
				set reasonDesc=""
				
				set admID = $lg(^PHA.PREADT.AuditD(auditID),3)		//就诊ID
				set patientID = $lg(^PHA.PREADT.AuditD(auditID),4)	//患者ID
				set admNo = $p(^PAADM(admID),"^",81)					//门诊号
				set mradm = $p(^PAADM(admID),"^",61)
				quit:(admno'="")&(admNo'[admno)
				set patNo = $p(^PAPER(patientID,"PAT",1),"^",1) 		//登记号
				quit:(patno'="")&(patNo'[patno)
				set patName = $p(^PAPER(patientID,"ALL"),"^",1)			//病人姓名
				set sexID = $p(^PAPER(patientID,"ALL"),"^",7)    		//病人性别
				set:sexID'="" patSex = $p(^CT("SEX",sexID),"^",2)
				set patAge = ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",patientID,admID)			//年龄
				set diagnos = ##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis($g(admID))					//诊断
				set docID = $lg(^PHA.PREADT.AuditD(auditID),11)		
				set docDesc = ""
				set:docID'="" docDesc = $p(^SSU("SSUSR",docID),"^",2)	//处方医生
				set locID = $lg(^PHA.PREADT.AuditD(auditID),9)		    //处方科室
				set prescNo = $lg(^PHA.PREADT.AuditD(auditID),15)		//处方号
				i locID="" d    		 								// shy 2022-4-01  过滤科室为空情况
				.s locDesc=""	
				e  d
				.set locDesc = $p(^CTLOC(locID),"^",2)
				set manLevel = ..GetManLevel(auditID)					//标识
				quit:(warn'="")&(warn'=manLevel)
				set drugItem = ..GetDrugItem(auditID)					//获取药品代码
				quit:(drug'="")&(drugItem'[drug)
				set overview = ..GetOverView(auditID)					//获取问题类型概览 "存在……风险"
				quit:(problem'="")&(overview'[problem)
				
				set resultID = ""
				set resultID = $o(^PHA.PREADT.AuditResultI("Parref",auditID,""))
				set pharID = "",pharCode = "",pharDesc = "",remark = "",reason = "",statusId = "",status = ""
				set:resultID'="" statusId = $lg(^PHA.PREADT.AuditResultD(resultID),6)		//处方状态
				set:statusId'="" status = $lg(^CT.PHA.PREADT.DicItemD(statusId),3)
				set:resultID'="" pharID = $lg($g(^PHA.PREADT.AuditResultD(resultID)),3)	//审核药师
				set:pharID'="" pharCode = $p(^SSU("SSUSR",pharID),"^",1)
				set:pharID'="" pharDesc = $p(^SSU("SSUSR",pharID),"^",2)
				set:resultID'="" remark = $lg(^PHA.PREADT.AuditResultD(resultID),8)	//药师备注
				if pharCode = "demo"  d
				.if remark="自动通过" d
				..set pharCode = "系统通过"
				..set pharDesc = "系统通过"
				.if remark="超时自动通过" d
				..set pharCode = "超时通过"
				..set pharDesc = "超时通过"
				set:resultID'="" reason = $lg(^PHA.PREADT.AuditResultD(resultID),7)	//双签理由
				b:auditID=564  //11
				set:reason'="" reasonDesc = $lg($g(^CT.PHA.PREADT.DicItemD(reason)),3)
				set linResId = ""
				set:resultID'="" linResId = $o(^PHA.PREADT.AuditResultI("Parref",auditID,""),-1)
				set appealtext = ""
				set:(linResId'="")&&(linResId'=resultID) appealtext = $lg(^PHA.PREADT.AuditResultD(linResId),8)
				s CkbData="" ;##class(web.DHCPRESCReviewReply).GetAuditInfo(auditID)
				s PrescData="" ;##class(web.DHCPRESCAudit).GetPrescNo(auditID)
				set count = count + 1
				s ^TMP("DHCPRESC","web.DHCPRESCList","GetPrescPrtList",userID,count)=patName_"^"_patSex_"^"_patAge_"^"_diagnos_"^"_locDesc_"^"_PrescData_"^"_CkbData
				quit:count<Start
				quit:count>End
				w $case(count,Start:"",:",")
				set prescObj = {}
				set prescObj.auditID = auditID
				set prescObj.admID = admID
				set prescObj.patientID = patientID
				set prescObj.admNo = admNo
				set prescObj.patName = patName
				set prescObj.patSex = patSex
				set prescObj.patAge = patAge
				set prescObj.diagnos = diagnos
				set prescObj.docDesc = docDesc
				set prescObj.locDesc = locDesc
				set prescObj.manLevel = manLevel
				set prescObj.pharDesc = pharDesc
				set prescObj.remark = remark
				set prescObj.reason = reasonDesc
				set prescObj.status = status
				set prescObj.appealtext = appealtext
				set prescObj.mradm = mradm
				set prescObj.prescNo = prescNo
				w prescObj.%ToJSON()
			}
		}
		
	}
	w "],""total"":"_count_"}"
	q ""
}

/// Descript:处方重审-获取病人信息
/// CreateDate:2022-01-20
/// Creator:wenlai
/// Input:auditID
/// OutPut:
/// w ##class(web.DHCPRESCList).GetInfo(1618)
ClassMethod GetInfo(auditID)
{
	set admID = $lg(^PHA.PREADT.AuditD(auditID),3)		//就诊ID
	set patientID = $lg(^PHA.PREADT.AuditD(auditID),4)	//患者ID
	set admNo = $p(^PAADM(admID),"^",81)					//门诊号
	set patNo = $p(^PAPER(patientID,"PAT",1),"^",1) 		//登记号
	set patName = $p(^PAPER(patientID,"ALL"),"^",1)			//病人姓名
	set sexID = $p(^PAPER(patientID,"ALL"),"^",7)    		//病人性别
	set:sexID'="" patSex = $p(^CT("SEX",sexID),"^",2)
	set patAge =##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",patientID,admID)			//年龄
	set weight = $lg(^PHA.PREADT.AuditD(auditID),7)		//体重
	set diag = ##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis($g(admID))							//诊断
	set diagnos = ""
	set disdiaglen = $l(diag)
	if disdiaglen>30 s diagnos = $e(diag,1,30)_"..."
	e  s diagnos = diag
	set docID = $lg(^PHA.PREADT.AuditD(auditID),11)		
	set docDesc = ""
	set allergy = ##class(web.DHCPRESCCommonUtil).GetAlleList(admID)
	set:docID'="" docDesc = $p(^SSU("SSUSR",docID),"^",2)	//处方医生
	set locID = $lg(^PHA.PREADT.AuditD(auditID),9)		//处方科室
	set locDesc = $p(^CTLOC(locID),"^",2)
	
	set prescObj = {}
	set prescObj.auditID = auditID
	set prescObj.patNo = patNo
	set prescObj.admNo = admNo
	set prescObj.patName = patName
	set prescObj.patSex = patSex
	set prescObj.patAge = patAge
	set prescObj.diagnos = diagnos
	set prescObj.docDesc = docDesc
	set prescObj.locDesc = locDesc
	set prescObj.weight = weight
	set prescObj.allergy = allergy
	set prescObj.diag = diag
	w prescObj.%ToJSON()
	q ""
}

/// Descript:获取审核历史记录
/// CreateDate:2022-01-20
/// Creator:wenlai
/// Input:auditID
/// Output:
/// w ##class(web.DHCPRESCList).GetHistory(1137)
ClassMethod GetHistory(auditID)
{
	
	set resultID = ""
	set auidtArr = []
	set submmitObj = {}
	set createrUser = ""
	set docId = $lg(^PHA.PREADT.AuditD(auditID),11)
	set:docId'="" createrUser = $p(^SSU("SSUSR",docId),"^",2)
	set createrDate = $lg(^PHA.PREADT.AuditD(auditID),13)
	set:createrDate'="" createrDate = ##class(web.DHCPRESCCommonUtil).DateLogicalToHtml(createrDate)
	set createrTime = $lg(^PHA.PREADT.AuditD(auditID),14)
	set:createrTime'="" createrTime = $zt(createrTime,1)
	set audNote = ""
	set reasonDoc = ""
	set resCom = ""
	set submmitObj.createrUser = createrUser
	set submmitObj.createrDate = createrDate
	set submmitObj.createrTime = createrTime
	set submmitObj.audNote = audNote
	set submmitObj.reasonDoc = reasonDoc
	set submmitObj.resCom = resCom
	do auidtArr.%Push(submmitObj)
	for {
		
		set resultID = $o(^PHA.PREADT.AuditResultI("Parref",auditID,resultID))
		quit:resultID=""
		set status = $lg($g(^PHA.PREADT.AuditResultD(resultID)),6)	//审核状态
		set:status'="" status = $lg($g(^CT.PHA.PREADT.DicItemD(status)),3)
		set pharID = $lg($g(^PHA.PREADT.AuditResultD(resultID)),3)	//审核药师
		set:pharID'="" pharDesc = $p(^SSU("SSUSR",pharID),"^",2)
		set reson = ""
		set resonId = $lg(^PHA.PREADT.AuditResultD(resultID),7)	//原因
		set:resonId'="" reson = $lg($g(^CT.PHA.PREADT.DicItemD(resonId)),3)
		set remark = $lg(^PHA.PREADT.AuditResultD(resultID),8)	//药师备注
		set:(reson'="")&&(remark="") remark = reson
		set:(reson'="")&&(remark'="") remark = reson_","_remark
		set auditDate = $lg($g(^PHA.PREADT.AuditResultD(resultID)),4) //审核日期
		set:auditDate'="" auditDate = ##class(web.DHCPRESCCommonUtil).DateLogicalToHtml(auditDate)
		set auditTime = $lg($g(^PHA.PREADT.AuditResultD(resultID)),5)	//审核时间
		set:auditTime'="" auditTime = $zt(auditTime,1)
		
		set resultObj = {}
		set resultObj.pharDesc = pharDesc
		set resultObj.status = status
		set resultObj.remark = remark
		set resultObj.auditDate = auditDate
		set resultObj.auditTime = auditTime
		do auidtArr.%Push(resultObj)	
	}
	q auidtArr.%ToJSON()
}

/// Descript:获取诊断
/// CreateDate:2022-01-06
/// Creator:wenlai
/// Input:auditID
/// OutPut:diagList
/// w ##class(web.DHCPRESCAudit).GetDiagnos()
ClassMethod GetDiagnos(auditID)
{
	s diag = $lg(^PHA.PREADT.AuditD(auditID),8)		// 诊断
	s diagList = ""
	s len = $l(diag,"!!")
	for i=1:1:len  d
	.s tmpList = $p(diag,"!!",i)
	.s diagDesc = $p(tmpList,"&",2)
	.i diagList = "" s diagList= diagDesc
	.e  s diagList = diagList_";"_diagDesc
	Q diagList
}

/// Descript: 获取药品列表下拉框
/// CreateDate: 2022-01-12
/// Creator: wenlai
/// Input:
/// OutPut: druagList
/// w ##class(web.DHCPRESCList).GetDrugList()
ClassMethod GetDrugList()
{
	
	set parref = $o(^CT.CKB.PDSS.CommonDictionI("Desc","西药字典",""))	//获取西药字典ID
	
	w "["
	set count = 0
	set ID = ""
	for {
		
		set ID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,ID))
		quit:ID=""
		
		set code = $lg(^CT.CKB.PDSS.CommonDictionD(ID),2)	//取药品代码
		set count = count + 1
		if (count = 1){
			w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ID_"^"_code)	
		}else{
			w ","
			w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ID_"^"_code)	
		}	
	}
	
	w "]"
	quit ""
}

/// Descript: 获取问题类型下拉框
/// CreateDate: 2022-01-12
/// Creator: wenlai
/// Input:
/// OutPut: druagList
/// w ##class(web.DHCPRESCList).GetProblemType()
ClassMethod GetProblemType()
{
	
	set parref = $o(^CT.CKB.PDSS.CommonDictionI("Desc","药品目录字典",""))	//获取西药字典ID
	
	w "["
	set count = 0
	set ID = ""
	for {
		
		set ID = $o(^CT.CKB.PDSS.CommonDictionI("Parref",parref,ID))
		quit:ID=""
		set showFlag = ##class(web.DHCCKBCommon).IsShow(ID,"DHC_CKBCommonDiction")
		quit:showFlag'=1
		set desc = $lg(^CT.CKB.PDSS.CommonDictionD(ID),3)	//取问题类型描述
		set count = count + 1
		if (count = 1){
			w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ID_"^"_desc)	
		}else{
			w ","
			w ##class(web.DHCEMJsonCommon).getJsonData("value^text",ID_"^"_desc)	
		}	
	}
	
	w "]"
	quit ""
}

/// Descript: 获取警示级别
/// CreateDate: 2022-01-12
/// Creator: wenlai
/// Input:
/// OutPut: manLev 警示级别描述
/// w ##class(web.DHCPRESCList).GetManLevel(auditID)
ClassMethod GetManLevel(auditID)
{
	s $zt="Err"
	set ratResult = $lg(^PHA.PREADT.AuditD(auditID),17)
	if (ratResult'=""){
		
		set resultObj = ##class(%DynamicArray).%FromJSON(ratResult)

	}else{
		quit ""
	}	
	
	quit resultObj.manLev
Err 
    q ""
}

/// Descript: 获取药品代码
/// CreateDate: 2022-01-17
/// Creator: wenlai
/// Input:
/// OutPut: drugItem 药品代码
/// w ##class(web.DHCPRESCList).GetDrugItem(auditID)
ClassMethod GetDrugItem(auditID)
{
	s $zt="Er"
	set auditListId = ""
	set durgList = ""
	for  set auditListId = $o(^PHA.PREADT.AuditListI("IndexParref",auditID,auditListId))  q:auditListId=""  d
	.s drugDesc = $lg($g(^PHA.PREADT.AuditListD(auditListId)),5)
	.i durgList="" s durgList = drugDesc
	.e  s durgList = durgList_","_drugDesc
	
	quit durgList
Er
    q ""
}

/// Descript: 获取问题类型
/// CreateDate: 2022-01-17
/// Creator: wenlai
/// Input:
/// OutPut: overview 问题类型概览
/// w ##class(web.DHCPRESCList).GetOverView(auditID)
ClassMethod GetOverView(auditID)
{
	s $zt="Error"
	set ratResult = $lg(^PHA.PREADT.AuditD(auditID),17)
	set result = ""
	if (ratResult'=""){
		
		set resultObj = ##class(%DynamicArray).%FromJSON(ratResult)
		set items = resultObj.items
		set result = items.%Get(0).overview
	}else{
		set result = ""
	}	
	
	quit result
Error
    q ""
}

/// Creator: shy
/// Descript: 获取处方列表-批量审核
/// CreateDate: 2022-03-21
/// Input:
/// Output:
/// other: w ##class(web.DHCPRESCList).GetBatchPrescList("30","1","^^^^^^^^OE")
ClassMethod GetBatchPrescList(rows, page, params)
{
	//2022-01-12^2022-01-12^111^666^禁止^73^152
	s ^temptest("333888")=$lb(rows, page, params)
	set End = page*rows
	set Start=(page-1)*rows+1
	set stDate = +$h-1
	set endDate = +$h
	set patientno = $p(params,"^",1)
	set patadmno = $p(params,"^",2)
	set warn = $p(params,"^",3)
	set problem = $p(params,"^",4) 
	set drug = $p(params,"^",5)
	set handStaus = $p(params,"^",6)
	set MenuModule = $p(params,"^",7)
	set count = 0
	set:handStaus="" handStaus="全部"
	w "{""rows"":["
	
	for dd = stDate:1:endDate{
		set time = ""
		for {
			set time = $o(^PHA.PREADT.AuditI("Date",dd,time))	
			quit:time=""
			
			set auditID = ""
			for {
				set auditID = $o(^PHA.PREADT.AuditI("Date",dd,time,auditID))	
				quit:auditID=""
				set reasonDesc=""
				set admID = $lg(^PHA.PREADT.AuditD(auditID),3)		//就诊ID
				set patType=$p($g(^PAADM(+admID)),"^",2) 	
				;B  //11
				B:auditID=1116
				quit:(MenuModule'="")&(MenuModule'[patType)  //根据患者就诊类型过滤显示
				B:auditID=1116
				set patientID = $lg(^PHA.PREADT.AuditD(auditID),4)	//患者ID
				set admNo = $p(^PAADM(admID),"^",81)					//门诊号
				quit:(patadmno'="")&(admNo'[patadmno)
				set patNo = $p(^PAPER(patientID,"PAT",1),"^",1) 		//登记号
				quit:(patientno'="")&(patNo'[patientno)
				set patName = $p(^PAPER(patientID,"ALL"),"^",1)			//病人姓名
				set sexID = $p(^PAPER(patientID,"ALL"),"^",7)    		//病人性别
				set:sexID'="" patSex = $p(^CT("SEX",sexID),"^",2)
				set patAge=##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",patientID,admID)  /// 年龄  shy 2022-3-21
				set diagnos = ##class(web.DHCDoc.OP.AjaxInterface).GetMRAdmDiagnosis($g(admID))						//诊断
				set docID = $lg(^PHA.PREADT.AuditD(auditID),11)		
				set docDesc = ""
				set:docID'="" docDesc = $p(^SSU("SSUSR",docID),"^",2)	//处方医生
				set locID = $lg(^PHA.PREADT.AuditD(auditID),9)		//处方科室
				set locDesc =""
				set:locID'="" locDesc = $p($g(^CTLOC(locID)),"^",2)
				set manLevel = ..GetManLevel(auditID)					//标识
				quit:(warn'="")&(warn'=manLevel)
				set drugItem = ..GetDrugItem(auditID)					//获取药品代码
				quit:(drug'="")&(drugItem'[drug)
				set overview = ..GetOverView(auditID)					//获取问题类型概览 "存在……风险"
				quit:(problem'="")&(overview'[problem)
				set status = $lg(^PHA.PREADT.AuditD(auditID),16)		//处方状态
				set resultID = $o(^PHA.PREADT.AuditResultI("Parref",auditID,""),-1)
				quit:(handStaus="")&&(+resultID'=0)    			//已经有结果的不显示  shy
				quit:(handStaus="已处理")&&(+resultID=0)
				quit:(handStaus="未处理")&&(+resultID'=0)
				set createDate = $lg(^PHA.PREADT.AuditD(auditID),13)				//创建日期
				set:createDate'="" createDate = $zd(createDate,3)
				set createTime = $lg(^PHA.PREADT.AuditD(auditID),14)				//创建时间
				set:createTime'="" createTime = $zt(createTime,1)
				set creteDatetime = createDate_" "_createTime
				set pharDesc = "",pharID = ""
				set:resultID'="" pharID = $lg($g(^PHA.PREADT.AuditResultD(resultID)),3)	//审核药师
				set:pharID'="" pharDesc = $p(^SSU("SSUSR",pharID),"^",2)
				set statusId = "",status = "",remark = "",reasonDesc = "",reasonId = ""
				set:resultID'="" statusId = $lg(^PHA.PREADT.AuditResultD(resultID),6)		//处方状态
				set:statusId'="" status = $lg(^CT.PHA.PREADT.DicItemD(statusId),3)
				set:resultID'="" remark = $lg(^PHA.PREADT.AuditResultD(resultID),8)	//药师备注
				set:resultID'="" reasonId = $lg(^PHA.PREADT.AuditResultD(resultID),7)	//双签理由
				set:reasonId'="" reasonDesc = $lg($g(^CT.PHA.PREADT.DicItemD(reasonId)),3)
				set count = count + 1
				quit:count<Start
				quit:count>End
				w $case(count,Start:"",:",")
				set prescObj = {}
				set prescObj.auditID = auditID
				set prescObj.admID = admID
				set prescObj.patientID = patientID
				set prescObj.admNo = admNo
				set prescObj.patName = patName
				set prescObj.patSex = patSex
				set prescObj.patAge = patAge
				set prescObj.diagnos = diagnos
				set prescObj.docDesc = docDesc
				set prescObj.locDesc = locDesc
				set prescObj.manLevel = manLevel
				set prescObj.pharDesc = pharDesc
				set prescObj.remark = remark
				set prescObj.reason = reasonDesc
				set prescObj.status = status
				set prescObj.patType = patType
				set prescObj.creteDatetime = creteDatetime
				w prescObj.%ToJSON()
			}
		}
		
	}
	w "],""total"":"_count_"}"
	q ""
}

/// Creator: Shy
/// Descript: 获取打印数据
/// CreateDate: 2022-05-27
/// Input:
/// Output: 
/// other: w ##class(web.DHCPRESCList).GetPrescPrtList(30,1,"2021-10-20^2022-01-19^^^^^")
ClassMethod GetPrescPrtList(UserID)
{

	q:+UserID=0 "[]"
	
	s ListString = "PatName^PatSex^PatAge^Diadata^Loc^PrescData^CkbData"
	w "["
	s Count=""
	f  s Count = $o(^TMP("DHCPRESC","web.DHCPRESCList","GetPrescPrtList",+UserID,Count)) q:Count=""  d
	.s ListData = ^TMP("DHCPRESC","web.DHCPRESCList","GetPrescPrtList",+UserID,Count)
	.w $case(Count,1:"",Count:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListString,ListData)
	w "]"
	q ""
}

}
