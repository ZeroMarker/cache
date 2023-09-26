Import SQLUser

Class web.DHCPRESCAudit Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Descript:取主表信息
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:msgId
/// OutPut:主表串
/// w ##class(web.DHCPRESCAudit).GetMainInfo()
ClassMethod GetMainInfoOld(msgId)
{
	//$lg(^CKB.PDSS.MonMaster(msgId),2)
	s monData = $g(^CKB.PDSS.MonMasterD(msgId))
	s adm = $lg(monData,2)	//就诊Id //730
	s createDate = $lg(monData,3)	//发生日期
	s createTime = $lg(monData,4) 	//发生时间
	s createUser = $lg(monData,5) 	//创建人
	s passFlag = $lg(monData,7) 	//通过标记
	s manLev = $lg(monData,8) 		//级别
	s examParam = $lg(monData,9)	//入参
	s examParamObj = ##class(%DynamicArray).%FromJSON(examParam)
	s patientId = $p(^PAADM(adm),"^",1)					//患者Id
	s patName = examParamObj.PatName					//患者姓名
	s patAge = examParamObj.AgeProp						//年龄
	s patHeight = examParamObj.Height					//身高
	s patWeight = examParamObj.Weight					//体重
	s diagnosArr = examParamObj.ItemDis					//诊断
	s patDiagnos = ##class(web.DHCPRESCAudit).GetPatAdmData(diagnosArr)		//诊断
	s loc = examParamObj.PatLoc							//科室
	s locId = ""
	s:loc'="" locId = $o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(loc),""))
	s hosp = examParamObj.Hospital						//医院
	s hospId = ""
	s:hosp'="" hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp),""))
	s doctor = examParamObj.DocUser						//医生
	s doctorId = ""
	s:doctor'="" doctorId = $o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(doctor),""))
	s proTitle = examParamObj.Profess					//职称
	s prescNo = ""
	s result = $lg(monData,10)		//结果
	s listData = msgId_"^"_adm_"^"_patientId_"^"_patAge_"^"_patHeight_"^"_patWeight
	s listData = listData_"^"_patDiagnos_"^"_locId_"^"_hospId_"^"_doctorId_"^"_proTitle
	s listData = listData_"^"_$p($h,",",1)_"^"_$p($h,",",2)_"^"_prescNo_"^"_0_"^"_result
	Q listData
}

/// Descript:取主表信息
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:msgId
/// OutPut:主表串
/// w ##class(web.DHCPRESCAudit).GetMainInfo(2923579,"30035901||24")
ClassMethod GetMainInfo(ordParamObj, pdssres)
{
	
	s msgId = $p(pdssres,"&",1)
	s adm = ordParamObj.EpisodeID						//就诊Id 
	s patientId = $p(^PAADM(adm),"^",1)					//患者Id
	s patAge = ordParamObj.AgeProp						//年龄
	s patHeight = ordParamObj.Height					//身高
	s patWeight = ordParamObj.Weight					//体重
	s diagnosArr = ordParamObj.ItemDis					//诊断
	s patDiagnos = ##class(web.DHCPRESCAudit).GetPatAdmData(diagnosArr)		//诊断
	s loc = ordParamObj.LgCtLoc							//科室
	s locId = ""
	s:loc'="" locId = $o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(loc),""))
	s hosp = ordParamObj.Hospital						//医院
	s hospId = ""
	s:hosp'="" hospId = $o(^CT("HOSP",0,"Desc",$$ALPHAUP^SSUTIL4(hosp),""))
	s doctor = ordParamObj.LgUser						//医生
	s doctorId = ""
	s:doctor'="" doctorId = $o(^SSU("SSUSR",0,"SSUSR_Name",$$ALPHAUP^SSUTIL4(doctor),""))
	s proTitle = ordParamObj.Profess					//职称
	s createDate = +$H									//发生日期
	s createTime = $p($H,",",2)							//发生时间
	s prescNo = ""
	s result = ""
	s:msgId'="" result = $lg($g(^CKB.PDSS.MonMasterD(msgId)),10)				//结果
	s listData = msgId_"^"_adm_"^"_patientId_"^"_patAge_"^"_patHeight_"^"_patWeight
	s listData = listData_"^"_patDiagnos_"^"_locId_"^"_hospId_"^"_doctorId_"^"_proTitle
	s listData = listData_"^"_createDate_"^"_createTime_"^"_prescNo_"^"_0_"^"_result
	Q listData
}

/// Descript:取子表信息(药品)
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:msgId
/// OutPut:主表串
/// w ##class(web.DHCPRESCAudit).GetSubMainInfo()
ClassMethod GetSubMainInfoOld(msgId)
{
	s examParam = $lg(^CKB.PDSS.MonMasterD(msgId),9) 	//入参
	s examParamObj = ##class(%DynamicArray).%FromJSON(examParam)
	s retStr = ""
	s drugObj = examParamObj.Drug
	s len = drugObj.%Size()
	for i=0:1:len-1  d
	.s itmObj = drugObj.%Get(i)
	.s seqNo = itmObj.SeqNo   							//序号
	.s drugCode = itmObj.PhCode							//药品代码
	.s drugDesc = itmObj.item							//药品名称
	.s onceDose = itmObj.OnceDose						//单次剂量
	.s onceUnit = itmObj.Unit							//单次剂量单位
	.s preMet = itmObj.DrugPreMet						//给药途径
	.s freq  = itmObj.DrugFreq							//频次
	.s treatment = itmObj.Treatment						//疗程
	.s firstMark = itmObj.FirstMark						//首次给药标识
	.s drugSpeed = itmObj.DrugSpeedProp					//滴速
	.s drugSpeedUnit = itmObj.DrugSpeedPropUnit			//滴速单位
	.s linkSeqNo = itmObj.LinkSeqNo						//关联序号
	.s ordDate = itmObj.OrdDate							//医嘱日期
	.s form = itmObj.FormProp
	.s listData = seqNo_"^"_drugCode_"^"_drugDesc_"^"_onceDose_"^"_onceUnit_"^"_preMet_"^"_freq_"^"_treatment
	.s listData = listData_"^"_firstMark_"^"_drugSpeed_"^"_drugSpeedUnit_"^"_linkSeqNo_"^"_ordDate_"^"_form
	.i retStr = "" s retStr = listData
	.e  s retStr = retStr_"&&"_listData
	Q retStr
}

/// Descript:取子表信息(药品)
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:msgId
/// OutPut:主表串
/// w ##class(web.DHCPRESCAudit).GetSubMainInfoOld(2922489)
ClassMethod GetSubMainInfo(ordParamObj)
{
	s retStr = ""
	s drugObj = ordParamObj.ItemOrder
	s len = drugObj.%Size()
	for i=0:1:len-1  d
	.s itmObj = drugObj.%Get(i)
	.s seqNo = itmObj.SeqNo   							//序号
	.s drugCode = itmObj.PhCode							//药品代码
	.s drugDesc = itmObj.PhDesc							//药品名称
	.s onceDose = itmObj.OnceDose						//单次剂量
	.s onceUnit = itmObj.Unit							//单次剂量单位
	.s preMet = itmObj.DrugPreMet						//给药途径
	.s freq  = itmObj.DrugFreq							//频次
	.s treatment = itmObj.Treatment						//疗程
	.s firstMark = itmObj.FirstMark						//首次给药标识
	.s drugSpeed = itmObj.DurgSpeedProp					//滴速    -   这里接口文档给错了导致字段不对应 DrugSpeedProp  shy 2023-04-26
	.s drugSpeedUnit = itmObj.DrugSpeedPropUnit			//滴速单位
	.s linkSeqNo = itmObj.LinkSeqNo						//关联序号
	.s ordDate = itmObj.OrdDate							//医嘱日期
	.s form = itmObj.FormProp							//剂型
	.s ordSeNum = itmObj.OrdSeNum
	.s ordEndDate = itmObj.OrdEndDate
	.s ordPackQty = itmObj.OrderPackQty
	.s ordPackQtyUnit = itmObj.OrderPackQtyUnit
	.s skinTest = itmObj.SkinTest
	.s OrdPriority = itmObj.OrderPriority
	.s recDeptCode = itmObj.RecDeptCode
	.s recDeptName = itmObj.RecDeptName
	.s ordPrice = itmObj.OrdPrice
	.s ordDate = itmObj.OrdDate 
	.s listData = seqNo_"^"_drugCode_"^"_drugDesc_"^"_onceDose_"^"_onceUnit_"^"_preMet_"^"_freq_"^"_treatment
	.s listData = listData_"^"_firstMark_"^"_drugSpeed_"^"_drugSpeedUnit_"^"_linkSeqNo_"^"_ordDate_"^"_form
	.s listData = listData_"^"_ordSeNum_"^"_ordEndDate_"^"_ordPackQty_"^"_ordPackQtyUnit_"^"_skinTest
	.s listData = listData_"^"_OrdPriority_"^"_recDeptCode_"^"_recDeptName_"^"_ordPrice_"^"_ordDate
	.i retStr = "" s retStr = listData
	.e  s retStr = retStr_"&&"_listData
	Q retStr
}

/// Descript:取诊断,检查,手术
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:信息串
/// OutPut:代码^描述&&代码^描述
/// w ##class(web.DHCPRESCAudit).GetPatAdmData()
ClassMethod GetPatAdmData(inDataArr)
{
	s len = inDataArr.%Size()
	s retList = ""
	for i=0:1:len-1  d
	.s dataObj = inDataArr.%Get(i)
	.s code = dataObj.id
	.s desc = dataObj.item
	.s list = code_"&"_desc
	.i retList = "" s retList = list 
	.e  s retList = retList_"!!"_list
	Q retList
}

/// Descript:保存审核主表和子表
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:主表信息，子表信息
/// OutPut:mainList,subMainList
/// w ##class(web.DHCPRESCAudit).saveAuditData()
ClassMethod saveAuditData(mainList, subMainList)
{
	s ret = 0
	s $ZT="ErrMsgSave"
	TS
	s mainId = ##class(web.DHCPRESCAudit).insAuditData(mainList)
	i mainId<0 tro
	Q:mainId<0 mainId
	
	s ret = ##class(web.DHCPRESCAudit).saveSubAudit(mainId,subMainList)
	i ret<0 tro
	Q:ret<0 ret
	
	s msgId = $lg(^PHA.PREADT.AuditD(mainId),2)	
	s manLevCode = ""
	s:msgId'="" manLevCode = $lg($g(^CKB.PDSS.MonMasterD(msgId)),8)
	s manLevDesc = $s(manLevCode="forbid":"禁止",manLevCode="warn":"警示",manLevCode="tips":"提醒",manLevCode="normal":"提示",1:"正常")
	s hospId = $lg(^PHA.PREADT.AuditD(mainId),10)
	s reqAuditLev = ##class(web.DHCPRESCCommonUtil).GetPrescSysConfig("LEVEL",hospId)
	s locId = $lg(^PHA.PREADT.AuditD(mainId),9)
	s locDesc = ""
	s:locId'="" locDesc = $p(^CTLOC(locId),"^",2)
	s locList = ##class(web.DHCPRESCCommonUtil).GetOnlineLocList()
	s overMaxFlag = ##class(web.DHCPRESCCommonUtil).IsOverMaxViewNum(locDesc)
	i (reqAuditLev'[manLevDesc)||((locList'="")&&((","_locList_",")'[(","_locDesc_",")))||(overMaxFlag="Y")  d
	.b   //s222
	.s res=##class(web.DHCPRESCCommonUtil).SynPrescAuditStatus(mainId)
	TC
	Q mainId
ErrMsgSave
	TRO
	Q -1
}

/// Descript:保存审核主表
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:主表信息
/// OutPut:mainList
/// w ##class(web.DHCPRESCAudit).insAuditData("519^4413^12192^^CM^Kg^低血糖;伤风鼻塞(表...^191^2^18881^主任医师^66493^36061^I230119000027^0^{""MsgID"":"""",""Action"":""CheckRule"",""PatName"":""马玉"",""SexProp"":""女"",""AgeProp"":""1986-10-31"",""Height"":"""",""Weight"":"""",""BillType"":""全自费"",""BloodPress"":""~"",""SpecialPop"":[],""ProfessProp"":"""",""PatType"":""住院"",""PatLoc"":""ZYZY003"",""MainDoc"":""医生01"",""Group"":""住院医师"",""Hospital"":""东华标准版数字化医院[总院]"",""LgCtLoc"":""内分泌科"",""LgUser"":""医生01"",""Profess"":"""",""EpisodeID"":""4413"",""Disease"":[{""id"":""E16.200"",""item"":""低血糖""},{""id"":""A13.01.01"",""item"":""伤风鼻塞""},{""id"":""B01.03.01"",""item"":""表虚证""},{""id"":""P59.900"",""item"":""新生儿黄疸""},{""id"":""I63.900"",""item"":""脑梗死""},{""id"":""I10.x00x002"",""item"":""高血压""}],""Drug"":[{""SeqNo"":""1"",""item"":""复合维生素片(爱乐维)[CO*30]"",""FormProp"":""片剂"",""OnceDose"":""1"",""Unit"":""片"",""DrugPreMet"":""口服"",""DrugFreq"":""Qd"",""Treatment"":"""",""id"":""XKF000404"",""LinkSeqNo"":"""",""OrdDate"":""2023-01-19"",""IsFirstUseProp"":"""",""DurgSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""OrdEndDate"":"""",""ArciMastId"":""2223||1""}],""ItemHisOrder"":[{""SeqNo"":""413"",""item"":""复合维生素片(爱乐维)[CO*30]"",""FormProp"":""片剂"",""OnceDose"":""1"",""Unit"":""片"",""DrugPreMet"":""口服"",""DrugFreq"":""Qd"",""Treatment"":"""",""id"":""XKF000404"",""LinkSeqNo"":"""",""OrdDate"":""2023-01-19"",""IsFirstUseProp"":"""",""DurgSpeedProp"":"""",""DrugSpeedPropUnit"":"""",""OrdEndDate"":"""",""ArciMastId"":""2223||1""}],""HisAllergy"":[{""id"":""复方倍氯米松樟脑乳膏"",""item"":""复方倍氯米松樟脑乳膏""},{""id"":""复方倍氯米松樟脑乳膏"",""item"":""复方倍氯米松樟脑乳膏""},{""id"":""复方倍氯米松樟脑乳膏"",""item"":""复方倍氯米松樟脑乳膏""},{""id"":""复方倍氯米松樟脑乳膏"",""item"":""复方倍氯米松樟脑乳膏""},{""id"":""复方倍氯米松樟脑乳膏"",""item"":""复方倍氯米松樟脑乳膏""},{""id"":""复方倍氯米松樟脑乳膏"",""item"":""复方倍氯米松樟脑乳膏""}],""ItemOper"":false,""UseType"":""Doc"",""ClientIP"":""""}")
ClassMethod insAuditData(mainList)
{
	s msgId = $p(mainList,"^",1)						//日志表Id
	s adm = $p(mainList,"^",2)							//就诊Id
	s patientId = $p(mainList,"^",3)					//患者Id
	s patAge = $p(mainList,"^",4)						//年龄
	s patHeight = $p(mainList,"^",5)					//身高
	s patWeight = $p(mainList,"^",6)					//体重
	s patDiagnos = $p(mainList,"^",7) 					//诊断
	s locId = $p(mainList,"^",8) 						//科室Id
	s hospId = $p(mainList,"^",9)						//医疗机构
	s doctorId = $p(mainList,"^",10) 					//医生
	s proTitle = $p(mainList,"^",11)					//职称
	s date = $p(mainList,"^",12)						//日期
	s time = $p(mainList,"^",13)						//时间
	s prescNo = $p(mainList,"^",14)						//处方号
	s flag = $p(mainList,"^",15)						//待审核标识
	s result = $p(mainList,"^",16)						//合理用药审查结果
	s DefAuditor="" ;##class(web.DHCPRESCAudit).GetDefAuditor(mainList) //默认审核人
	&sql(
		insert into PHA_PREADT.Audit (
			PA_Mon_Dr, PA_Adm, PA_PatientID, PA_Age, PA_Height, PA_Weight,
			PA_Diagnos, PA_LocDr, PA_Hosp_Dr, PA_User_Dr, PA_Title, PA_CreateDate,
			PA_CreateTime, PA_PrescNo, PA_AuditStatus_Dr, PA_RatResult,PA_DefAuditor
		) values (
			:msgId, :adm, :patientId, :patAge, :patHeight, :patWeight,
			:patDiagnos, :locId, :hospId, :doctorId, :proTitle, :date,
			:time, :prescNo, :flag, :result, :DefAuditor
		)
	)
	Q %ROWID
}

/// Descript:保存审核子表
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:子表信息
/// OutPut:subMainList
/// w ##class(web.DHCPRESCAudit).saveSubAudit(3,"3^XKF000404^复合维生素片(爱乐维)[CO*30]^1^片^口服^Qd^^非首次^^^^66493^片剂^4016||414")
ClassMethod saveSubAudit(mainId, subMainList)
{
	
	TS
	s length = $l(subMainList,"&&")
	s ret = 0
	for i=1:1:length  Q:ret'=0  d
	.s subList = $p(subMainList,"&&",i)
	.s ret = ##class(web.DHCPRESCAudit).insSubAudit(mainId,subList)
	.Q:ret'=0
	i ret'=0 TRO
	Q:ret'=0 ret
	TC
	Q ret
}

/// Descript:保存审核子表
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:子表信息
/// OutPut:subMainList
/// w ##class(web.DHCPRESCAudit).insSubAudit("3","3^XKF000404^复合维生素片(爱乐维)[CO*30]^1^片^口服^Qd^^非首次^^^^66493^片剂^4016||414")
ClassMethod insSubAudit(mainId, subList)
{
	s seqNo = $p(subList,"^",1)						//组号
	s drugCode = $p(subList,"^",2)					//药品code
	s drugDesc = $p(subList,"^",3)					//药品名称
	s onceDose = $p(subList,"^",4)					//单次剂量
	s onceUnit = $p(subList,"^",5)					//单次剂量单位
	s preMet = $p(subList,"^",6) 					//给药途径
	s freq = $p(subList,"^",7)						//频次
	s treatment = $p(subList,"^",8)					//疗程
	s firstMark = $p(subList,"^",9)					//首次标识
	s drugSpeed = $p(subList,"^",10)				//滴速
	s drugSpeedUnit = $p(subList,"^",11)			//滴速单位
	s linkSeqNo = $p(subList,"^",12)				//关联号
	s ordDate = $p(subList,"^",13)					//医嘱日期
	s:ordDate'="" ordDate = ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(ordDate)
	s form = $p(subList,"^",14)						//剂型
	s ordSeNum = $p(subList,"^",15)					//流水号
	s ordEndDate = $p(subList,"^",16)				//流水号
	s:ordEndDate'="" ordEndDate = ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(ordEndDate)
	s ordPackQty = $p(subList,"^",17)					//流水号
	s ordPackQtyUnit = $p(subList,"^",18)					//流水号
	s skinTest = $p(subList,"^",19)					//流水号
	s OrdPriority = $p(subList,"^",20)					//流水号
	s recDeptCode = $p(subList,"^",21)					//流水号
	s recDeptName = $p(subList,"^",22)					//流水号
	s ordPrice = $p(subList,"^",23)					//流水号
	s ordDate = $p(subList,"^",24)					//流水号
	s:ordDate'="" ordDate = ##class(web.DHCPRESCCommonUtil).DateHtmlToLogical(ordDate)
	&sql(
		insert into PHA_PREADT.AuditList (
			PAL_Audit_Dr, PAL_Num, PAL_DrugCode, PAL_DrugDesc, PAL_OnceDose,
			PAL_Unit, PAL_DrugPreMet, PAL_DrugFreq, PAL_Treatment, PAL_FirstUseFlag,
			PAL_DrugSpeed, PAL_DrugSpeedUnit, PAL_LinkSeqNo, PAL_StDate, PAL_Form,PAL_OrdSeNum,
			PAL_EndDate,PAL_PackQty,PAL_PackQtyUnit,PAL_SkinTest,PAL_Priority,PAL_RecDeptCode,
			PAL_RecDeptDesc,PAL_OrdPrice,PAL_OrdDate
		) values (
			:mainId, :seqNo, :drugCode, :drugDesc, :onceDose, 
			:onceUnit, :preMet, :freq, :treatment, :firstMark, 
			:drugSpeed, :drugSpeedUnit, :linkSeqNo, :ordDate, :form,:ordSeNum,
			:ordEndDate,:ordPackQty,:ordPackQtyUnit,:skinTest,:OrdPriority,
			:recDeptCode,:recDeptName,:ordPrice,:ordDate
		)
	)
	Q SQLCODE
}

/// dhact
/// TryNoh!hP2
/// Descript:查询待审核列表[门急诊]
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:userId,date
/// OutPut:subMainList
/// w ##class(web.DHCPRESCAudit).QueryAuditList(30,1,"2023-5-14^2023-5-24^0^20725^^^^I")
ClassMethod QueryAuditList(rows, page, params)
{
	s End = page*rows
	s Start=(page-1)*rows+1
	s pid = ##class(web.DHCPRESCCommonUtil).NewPid()
	s ^temptest("333")=$lb(params)
	s stdate = $p(params,"^",1)
	s:stdate'="" stdate=$zdh(stdate,3)
	s enddate = $p(params,"^",2)
	s:enddate'="" enddate=$zdh(enddate,3)
	s state = $p(params,"^",3)
	s auduserId = $p(params,"^",4)
	s res = $p(params,"^",5)
	s searchNo= $p(params,"^",6)  
	s curPatientId = $p(params,"^",7)  
	s MenuModule= $p(params,"^",8)
	s newtask = 0
	s contask = 0
	s comtask = 0
	s mustedit = 0
	s dblcheck = 0
	s pass = 0
	s readTime = 0
	s count=0
	s audLocList = ##class(web.DHCPRESCCommonUtil).GetAuditLocList(auduserId)
	s prescTypeList = ##class(web.DHCPRESCCommonUtil).GetAuditPrescList(auduserId)
	k ^TMP("web.DHCPRESCAudit","QueryAuditList",pid)
	k ^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid)
	s time = ""
	for date=stdate:1:enddate  d
	.for  s time = $o(^PHA.PREADT.AuditI("Date",date,time))  Q:time=""  d
	..s auditId = ""
	..for  s auditId = $o(^PHA.PREADT.AuditI("Date",date,time,auditId))  Q:auditId=""  d
	...;q:auditId'=1657
	...s admId = $lg(^PHA.PREADT.AuditD(auditId),3)					//就诊Id
	...s mradm = $P(^PAADM(admId),"^",61)
	...s patType=$p($g(^PAADM(+admId)),"^",2) 	                        //就诊类型
	...q:(MenuModule'="")&(MenuModule'[patType)  //根据患者就诊类型过滤显示
	...s patientId = $lg(^PHA.PREADT.AuditD(auditId),4)				//患者Id
	...q:(curPatientId'="")&&(curPatientId'=patientId)					//xww 2022-03-03
	...s patName = $p(^PAPER(patientId,"ALL"),"^",1)  					//姓名
	...s patNo = $p(^PAPER(patientId,"PAT",1),"^",1)  					//登记号
	...s patSex = ""
	...s sexId = $p(^PAPER(patientId,"ALL"),"^",7)    					//姓别
	...i sexId'="" s patSex = $p(^CT("SEX",sexId),"^",2)	
	...s createDate = $lg(^PHA.PREADT.AuditD(auditId),13)				//创建日期
	...s:createDate'="" createDate = $zd(createDate,3)
	...s createTime = $lg(^PHA.PREADT.AuditD(auditId),14)				//创建时间
	...s imdtime = $p($h,",",2)-createTime
	...s readTime = $p($h,",",2)-createTime
	...s:createTime'="" createTime = $zt(createTime,3)
	...s patAge = ##class(web.DHCDocInterfaceMethod).DHCDocHisInterface("doc.reg.GetPapmiAge",patientId,admId)					//患者年龄
	...s locId = $lg(^PHA.PREADT.AuditD(auditId),9)					//科室
	...s locDesc = ""						
	...s locDesc = $p($g(^CTLOC(+locId)),"^",2)							//过滤非监测列表的数据
	...s switchFlag = ##class(web.DHCPRESCCommonUtil).GetByLocsSwitch(auditId)
	...Q:(audLocList'="")&&(switchFlag'=0)&&((","_audLocList_",")'[(","_locDesc_","))
	...s hospId = ##class(web.DHCPRESCCommonUtil).GetHospIDByAuditID(auditId)
	...s overViewNum = ##class(web.DHCPRESCCommonUtil).GetMaxViewCount(hospId_"^^"_auduserId_"^")
	...s viewNumOwn = ##class(web.DHCPRESCCommonUtil).GetAuditNum(auduserId,overViewNum)
	...s overViewFlag = $s(viewNumOwn>overViewNum:"Y",1:"")
	...s locMaxViewFlag = ##class(web.DHCPRESCCommonUtil).IsOverMaxViewNum(locDesc)
	...b:auditId=1881  //s1
	...i locMaxViewFlag = "Y"  d
	....s ^temptestsufan("xxx") = auditId_"^"_overViewNum_"^"_viewNumOwn
	....d ##class(web.DHCPRESCCommonUtil).SynPrescAuditStatus(auditId)
	...s locTelPhone=##Class(web.DHCPRESCAudit).GetLocTelPhone(locId)   //科室电话
	...s height = $lg(^PHA.PREADT.AuditD(auditId),6)					//身高
	...s weight = $lg(^PHA.PREADT.AuditD(auditId),7)					//体重
	...s admNo = $p(^PAADM(admId),"^",81)								//门诊号
	...s docId = $lg(^PHA.PREADT.AuditD(auditId),11)					//医生
	...s docDesc = "",CareProvID=""
	...s:docId'="" docDesc = $p(^SSU("SSUSR",docId),"^",2)	
	...s:docId'="" CareProvID=$p($g(^SSU("SSUSR",docId)),"^",14)
	...s docPhone=##Class(web.DHCPRESCAudit).GetCareProvPhone(CareProvID)  //医生电话
	...s diag = ##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(admId,",","GX") ;##class(web.DHCPRESCAudit).GetDiagnos(auditId)	
	...s spdiag = ""
	...s disdiaglen = $l(diag)
	...i disdiaglen>15 s spdiag = $e(diag,1,15)_"..."
	...e  s spdiag = diag
	...s chndiag = ##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(admId,",","GC")
	...s dischdiag = ""
	...s dischnlen = $l(chndiag)
	...i dischnlen>20 s dischdiag = $e(chndiag,1,22)_"..."
	...e  s dischdiag = chndiag	
	...s prescNo = $lg(^PHA.PREADT.AuditD(auditId),15)				//处方号
	...q:(searchNo'="")&&(searchNo'=prescNo)&&(searchNo'=admId)&&(searchNo'=patNo)  //xww 2022-03-03
	...s subId = $o(^PHA.PREADT.AuditListI("IndexParref",auditId,""))
	...s phCode = $lg(^PHA.PREADT.AuditListD(subId),4)
	...s presType = ##Class(web.DHCPRESCCommonUtil).GetRecipType(phCode)	
	...Q:(phCode'="")&(prescTypeList'="")&(prescTypeList'[presType)	                //处方类型的过滤
	...s status = $lg(^PHA.PREADT.AuditD(auditId),16)					//状态
	...s audresId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,""))
	...s resStatusCode = ""
	...s audresSta = ""
	...s:audresId'="" audresSta = $lg(^PHA.PREADT.AuditResultD(audresId),6)
	...s readFlag = $lg(^PHA.PREADT.AuditD(auditId),19)
	...s overTime = ##class(web.DHCPRESCCommonUtil).GetOverTime(auditId)
	...s overReadTime = ##class(web.DHCPRESCCommonUtil).GetOverReadTime(auditId)
	...b  //s2
	...i (state=0)&&(readFlag="Y")&&(imdtime>overReadTime)&&(audresSta="")  d
	....d ##class(web.DHCPRESCAudit).SynPrescAuditStatus(auditId)
	...Q:(state=0)&&(readFlag="Y")&&(overReadTime>=overTime)&&(imdtime>overReadTime)&&(audresSta="")
	...Q:(state=0)&&(readFlag="Y")&&(overReadTime<=overTime)&&(imdtime>overTime)&&(audresSta="")
	...;Q:(state=0)&&(readFlag="")&&(imdtime>overTime)&&(audresSta="")
	...b  //s3
	...s resStatus = ""
	
	...i (status = 0)&&(imdtime<overTime)&&(overViewFlag'="Y") s newtask = newtask+1
	...i status = 1 s contask = contask+1 s imdtime = ""
	...i status = 2 s comtask = comtask+1 s imdtime = ""
	...i $d(^PHA.PREADT.AuditResultI("Parref",auditId))  d
	....s resId = ""
	....s resId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,resId))
	....s resStatusId = $lg(^PHA.PREADT.AuditResultD(resId),6)
	....s resStatusCode = $lg(^CT.PHA.PREADT.DicItemD(resStatusId),2)
	....i resStatusCode = "STA01" s mustedit = mustedit + 1
	....i resStatusCode = "STA03" s dblcheck = dblcheck + 1
	....i resStatusCode = "STA04" s pass = pass + 1
	...e  d
	....d ##class(web.DHCPRESCAudit).SynPrescAuditStatus(auditId)
	...s bedNo = ##class(Nur.Interface.OutSide.Patient).getPatientLastBedCode(admId) 
	...q:(overViewFlag="Y")&&(locMaxViewFlag="N")
	...Q:(state'="")&&(status'=state)
	...;b:resStatusCode="STA01"  //s2
	...Q:(res'="")&&(resStatusCode'=res)
	...i patType="E" s patTypeNum=0  //急诊优先
	...e  s patTypeNum=1
	...s appeal=1 //申诉的处方
	...s alleHis = ##class(web.DHCPRESCCommonUtil).GetAlleList(admId)
	...s spalleHis = ""
	...s alleHislen = $l(alleHis)
	...i alleHislen>15 s spalleHis = $e(alleHis,1,15)_"..."
	...e  s spalleHis = alleHis	
	...s docremark = ##class(web.DHCPRESCCommonUtil).QueryDocNote(auditId)
	...s tmpstr=auditId_"^"_admId_"^"_patientId_"^"_patName_"^"_patNo_"^"_patSex_"^"_createDate_"^"_createTime_"^"_patAge_"^"_locDesc  //10
	...s tmpstr=tmpstr_"^"_height_"^"_weight_"^"_admNo_"^"_docDesc_"^"_diag_"^"_prescNo_"^"_status_"^"_imdtime_"^"_resStatusCode   //20
	...s tmpstr=tmpstr_"^"_patType_"^"_locTelPhone_"^"_docPhone_"^"_docId_"^"_spdiag_"^"_dischdiag_"^"_mradm_"^"_bedNo_"^"_chndiag
	...s tmpstr=tmpstr_"^"_alleHis_"^"_spalleHis_"^"_docremark_"^"_readFlag_"^"_overReadTime_"^"_readTime
	...s ^TMP("web.DHCPRESCAudit","QueryAuditList",pid,patTypeNum,appeal,date_"^"_time)=tmpstr
	...s ^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid,patientId)=+$g(^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid,patientId))+1
	...//组合同一患者多个审查记录
	...s:$d(^TMP("web.DHCPRESCAudit","QueryAuditList","Audits",pid,patientId)) ^TMP("web.DHCPRESCAudit","QueryAuditList","Audits",pid,patientId)=^TMP("web.DHCPRESCAudit","QueryAuditList","Audits",pid,patientId)_"!!"_auditId
	...s:'$d(^TMP("web.DHCPRESCAudit","QueryAuditList","Audits",pid,patientId)) ^TMP("web.DHCPRESCAudit","QueryAuditList","Audits",pid,patientId)=auditId
	
	
	s title="auditId^admId^patientId^patName^patNo^patSex^createDate^createTime^patAge^locDesc"  //10
	s title=title_"^height^weight^admNo^docDesc^diag^prescNo^status^imdtime^resStatusCode"   //19
	s title=title_"^patType^locTelPhone^docPhone^docId^spdiag^dischdiag^mradm^bedNo^chndiag^alleHis^spalleHis"
	s title=title_"^docremark^readFlag^overReadTime^readTime"
	s PatStr=""
	w "{""rows"":["
	s typeNo=""
	f  s typeNo=$o(^TMP("web.DHCPRESCAudit","QueryAuditList",pid,typeNo)) q:typeNo=""  d
	.s appealNo=""
	.s appealNo=$o(^TMP("web.DHCPRESCAudit","QueryAuditList",pid,typeNo,appealNo)) q:appealNo=""  d
	..s datetime=""
	..f  s datetime=$o(^TMP("web.DHCPRESCAudit","QueryAuditList",pid,typeNo,appealNo,datetime)) q:datetime=""  d
	...s data=^TMP("web.DHCPRESCAudit","QueryAuditList",pid,typeNo,appealNo,datetime)
	...s patId=$p(data,"^",3)
	...;s data=data_"^"_ ^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid,patId)
	...;s data=data_"^"_ ^TMP("web.DHCPRESCAudit","QueryAuditList","Audits",pid,patId)
	...//住院按患者显示，过滤相同patid数据
	...;q:(type="I")&&(PatStr[^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid,patId))
	...;s:(type="I") PatStr=PatStr_"^"_^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid,patId)
	...s count=count+1
	...q:count<Start
	...q:count>End
	...w $case(count,Start:"",:",")
	...w ##class(web.DHCADVJSONCOMMON).getJsonDataPort(title,data)
	w "],""total"":"_count_",""newtask"":"_newtask_",""contask"":"_contask_",""comtask"":"_comtask_",""mustedit"":"_mustedit_",""dblcheck"":"_dblcheck_",""pass"":"_pass_"}"
	k ^TMP("web.DHCPRESCAudit","QueryAuditList",pid)
	k ^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid)
	q ""
#;	...s count=count+1
#;	...q:count<Start
#;	...q:count>End
#;	...w $case(count,Start:"",:",")
#;	...s auditObj = {}
#;	...s auditObj.auditId = auditId
#;	...s auditObj.admId = admId
#;	...s auditObj.patientId = patientId
#;	...s auditObj.patName = patName
#;	...s auditObj.patNo = patNo
#;	...s auditObj.patSex = patSex
#;	...s auditObj.createDate = createDate
#;	...s auditObj.createTime = createTime
#;	...s auditObj.patAge = patAge
#;	...s auditObj.locDesc = locDesc
#;	...s auditObj.weight = weight
#;	...s auditObj.admNo = admNo
#;	...s auditObj.docDesc = docDesc
#;	...s auditObj.diag = diag
#;	...s auditObj.prescNo = prescNo
#;	...s auditObj.status = status
#;	...s auditObj.imdtime = imdtime
#;	...s auditObj.resStatus = resStatus
#;	...s auditObj.patType=patType
#;	...w auditObj.%ToJSON()
#;	w "],""total"":"_count_",""newtask"":"_newtask_",""contask"":"_contask_",""comtask"":"_comtask_",""mustedit"":"_mustedit_",""dblcheck"":"_dblcheck_",""pass"":"_pass_"}"
#;	q ""
}

/// Descript:获取诊断
/// CreateDate:2021-09-11
/// Creator:sufan
/// Input:auditId
/// OutPut:diagList
/// w ##class(web.DHCPRESCAudit).GetDiagnos()
ClassMethod GetDiagnos(auditId)
{
	s diag = $lg(^PHA.PREADT.AuditD(auditId),8)		// 诊断
	s diagList = ""
	s len = $l(diag,"!!")
	for i=1:1:len  d
	.s tmpList = $p(diag,"!!",i)
	.s diagDesc = $p(tmpList,"&",2)
	.i diagList = "" s diagList= diagDesc
	.e  s diagList = diagList_";"_diagDesc
	Q diagList
}

/// Descript:取处方信息
/// CreateDate:2021-09-14
/// Creator:sufan
/// Input:auditId
/// OutPut:医嘱信息
/// w ##class(web.DHCPRESCAudit).GetPrescNo(7232)
ClassMethod GetPrescNo(auditId)
{
	
	Q:auditId="" "[]"
	s auditFirst=$p(auditId,"!!",1)
	s result = $lg(^PHA.PREADT.AuditD(auditFirst),17)
	s prescNo = $lg(^PHA.PREADT.AuditD(auditFirst),15)
	s isOwnSys = ##class(web.DHCPRESCCommonUtil).GetSysConfig("ISOWNREASYS",2)  		//是否东华合理用药
	s subAuditArr = []
	s len=$l(auditId,"!!")
	f index=1:1:len   d
	.s auditDr=$p(auditId,"!!",index)
	.s subId = ""
	.for  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",auditDr,subId))  Q:subId=""  d
	..s drugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	..s drugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	..s onceDose = $lg(^PHA.PREADT.AuditListD(subId),6)		//单次剂量
	..s unit =  $lg(^PHA.PREADT.AuditListD(subId),7)			//单次剂量单位
	..s onceDose = onceDose_unit
	..s preMet = $lg(^PHA.PREADT.AuditListD(subId),8)			//给药途径
	..s freq = $lg(^PHA.PREADT.AuditListD(subId),9)			//频次
	..s treatment = $lg(^PHA.PREADT.AuditListD(subId),10)			//疗程
	..s OrdItemDr = $lg(^PHA.PREADT.AuditListD(subId),17)	    //医嘱 hxy 2022-07-13 st
	..s Cat=..getOrcatDesc(+OrdItemDr,$p(OrdItemDr,"||",2))      //医嘱大类 ed
	..s PrescQty="" //中草药的一次用量
	..i (Cat="中草药")&(OrdItemDr'="") d
	...s DHCQUERowID=$o(^PAQUE1(0,"DHCPAQue","LinkOrderItem",OrdItemDr,""))
	...s PrescQty=$p($g(^PAQUE1(+DHCQUERowID,"DHC")),"^",13)
	..s libDrugId = ""
	..i isOwnSys'=1  d
	...s libDrugId = ##class(web.DHCCKBCommon).GetDicIdByDesc(drugDesc)	 // 知识库的编码和描述
	..Q:drugDesc=""
	..s subAuditObj = {}
	..s subAuditObj.prescNo = prescNo
	..s subAuditObj.arciId =  ""	// his的编码和描述
	..s subAuditObj.drugCode = drugCode	
	..s subAuditObj.drugDesc = drugDesc
	..s subAuditObj.libDrugId =  libDrugId	
	..s subAuditObj.libDrugCode = drugCode	
	..s subAuditObj.libDrugDesc = drugDesc
	..s subAuditObj.onceDose = onceDose
	..s subAuditObj.preMet = preMet
	..s subAuditObj.freq = freq
	..s subAuditObj.treatment = treatment
	..s subAuditObj.cat=Cat
	..s subAuditObj.PrescQty=PrescQty
	..d subAuditArr.%Push(subAuditObj)
	w subAuditArr.%ToJSON()
	Q ""
}

/// Descript:取审查信息信息
/// CreateDate:2021-09-14
/// Creator:sufan
/// Input:auditId
/// OutPut:审查结果信息
/// w ##class(web.DHCPRESCAudit).GetAuditInfo(775)
ClassMethod GetAuditInfo(auditId)
{
	Q:auditId="" "[]"
	s result = $lg(^PHA.PREADT.AuditD(auditId),17)
	i result="" d
	.s monster = $lg(^PHA.PREADT.AuditD(auditId),2)
	.s result = $lg(^CKB.PDSS.MonMasterD(monster),10)
	Q:result="" "[]"
	s resultObj = ##class(%DynamicArray).%FromJSON(result)
	w resultObj.%ToJSON()
	Q ""
	s itemsArr = resultObj.items
	s length = itemsArr.%Size()
	s previewArr = []
	s keynameArr = []
	s tipsArr = []
	
	s msg = ""
	for i=0:1:length-1  d
	.s drugObj = {}
	.s itmsObj = itemsArr.%Get(i)
	.s drugDesc = itmsObj.item				//药品名称
	.s warnArr = itmsObj.warns
	.s drugObj.drug = drugDesc
	.s warnLen = warnArr.%Size()
	.for j =0:1:warnLen-1  d
	..s warnObj = warnArr.%Get(j)
	..s keyObj = {}
	..s itmsArr = warnObj.itms
	..s keyname = warnObj.keyname
	..s keyObj.keyName = keyname
	..d keynameArr.%Push(keyObj)
	..s itmsLen = itmsArr.%Size()
	..for k = 0:1:itmsLen-1  d
	...s itmsObj = itmsArr.%Get(k)
	...s control = itmsObj.control
	...s itmLeve = itmsObj.manLevel
	...s manLev = itmsObj.manLev
	...s subItmsArr = itmsObj.itms
	...s subLen = subItmsArr.%Size()
	...for n = 0:1:subLen-1  d
	....s tipObj = {}
	....s subItmsObj = subItmsArr.%Get(n)
	....s val = subItmsObj.val
	....s tipObj.itms = val
	....s tipObj.keyname = subItmsObj.keyname
	....d tipsArr.%Push(tipObj)
	..s keyObj.tips = tipsArr
	.s drugObj.warn = keynameArr
	w keynameArr.%ToJSON()
	Q ""
}

/// Descript:保存审核内容
/// CreateDate:2021-09-15
/// Creator:sufan
/// Input:listData
/// OutPut:审查结果信息
/// w ##class(web.DHCPRESCAudit).GetAuditRes(1603)
ClassMethod GetAuditRes(auditId)
{
	Q:auditId="" ""
	s resultId = ""
	Q:'$D(^PHA.PREADT.AuditResultI("Parref",auditId)) ""
	s resultId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,""),-1) 
	s statusId = $lg(^PHA.PREADT.AuditResultD(resultId),6)
	s audres = ""
	s:statusId'="" audres = $lg(^CT.PHA.PREADT.DicItemD(statusId),3)
	s itmId = $lg(^PHA.PREADT.AuditResultD(resultId),7)
	s res = $lg(^PHA.PREADT.AuditResultD(resultId),8)

	q itmId_"^"_res_"^"_audres
}

/// Descript:保存审核内容
/// CreateDate:2021-09-15
/// Creator:sufan
/// Input:listData
/// OutPut:审查结果信息
/// w ##class(web.DHCPRESCAudit).saveAuditRes(3)
ClassMethod saveAuditInfo(listData)
{
	s auditId = $p(listData,"^",1)
	s studr = $lg(^PHA.PREADT.AuditD(auditId),16)
	q:+studr'=0 "处方已审核，请勿重复审核！"
	
	s ret = 0
	TS
	s ret = ##class(web.DHCPRESCAudit).saveAuditRes(listData)
	i ret'=0 TRO
	Q:ret'=0 ret
	
	s ret = ##class(web.DHCPRESCAudit).updAuditState(listData)
	i ret'=0 TRO
	Q:ret'=0 ret
	TC
	
	s aduitId = $p(listData,"^",1)
	s userId = $p(listData,"^",3)
	s admId = $lg(^PHA.PREADT.AuditD(aduitId),3)
	s recLocId = $lg(^PHA.PREADT.AuditD(aduitId),9)
	s recLocId = recLocId_"|OnlyFlag"
	s recUserId = $lg(^PHA.PREADT.AuditD(aduitId),11)
	d ##class(web.DHCPRESCNewsContact).InsertMessage(aduitId_"^已审核，请处理处方！^Audit","^^^"_userId)
	
	s auditMes = "已审核，请处理处方！"
	s mesCode = "1087"
	d ##class(websys.DHCMessageInterface).Send(auditMes,mesCode,userId,admId,"",recUserId,"",recLocId)
	Q ret
}

/// Descript:审核内容
/// CreateDate:2021-09-15
/// Creator:sufan
/// Input:listData
/// OutPut:审查结果信息
/// w ##class(web.DHCPRESCAudit).saveAuditRes(3)
ClassMethod saveAuditRes(listData)
{
	s auditId = $p(listData,"^",1)				//审核状态
	s itemId = $p(listData,"^",2)				//审核原因
	s userId = $p(listData,"^",3)				//审核药师
	s stateCode = $p(listData,"^",4)			//状态代码
	s readCode = $p(listData,"^",5)				//已读标识
	s remark = $p(listData,"^",6)				//备注
	s date = +$h								//日期
	s time = $p($h,",",2)						//时间
	s stateId = $o(^CT.PHA.PREADT.DicItemI("Code",stateCode,""))			//状态Id
	
	&sql(
		insert into PHA_PREADT.AuditResult (
			PAR_Audit_Dr,PAR_User_Dr,PAR_Date,PAR_Time,PAR_Status_Dr,PAR_Reason_Dr,PAR_Remark
		)
		values (
			:auditId,:userId,:date,:time,:stateId,:itemId,:remark
		)
	)
	Q SQLCODE
}

/// Descript:更新审核状态
/// CreateDate:2021-09-15
/// Creator:sufan
/// Input:listData
/// OutPut:审查结果信息
/// w ##class(web.DHCPRESCAudit).updAuditState(3)
ClassMethod updAuditState(listData)
{
	s auditId = $p(listData,"^",1)
	s itemId = $p(listData,"^",2)
	s userId = $p(listData,"^",3)
	s stateCode = $p(listData,"^",4)
	s auditCode = ""
	i stateCode = "STA01" s auditCode = "2"
	i stateCode = "STA02" s auditCode = "1"
	i (stateCode = "STA03")||(stateCode = "STA04") s auditCode = "2"
	&sql(
		update PHA_PREADT.Audit set PA_AuditStatus_Dr=:auditCode where PA_RowID=:auditId
	)
	Q SQLCODE
}

/// Descript:更新岗位列表
/// CreateDate:2021-09-29
/// Creator:sufan
/// Input:userId
/// OutPut:0：成功，非0：失败
/// w ##class(web.DHCPRESCAudit).updScheState(3)
ClassMethod updScheState(userId, state)
{
	Q:'$d(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId)) "1"
	s scheId = $o(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId,""))
	&sql(
		  update CF_PHA_PREADT.DicScheme 
				 set PDS_Staus=:state 
		 		 where ID=:scheId
	)
	Q SQLCODE
}

/// Descript:更新岗位列表并记录日志
/// CreateDate:2022-04-07
/// Creator:Sunhuiyong
/// Input:userId
/// OutPut:0：成功，非0：失败
/// w ##class(web.DHCPRESCAudit).updScheStateNew("11874","在线")
ClassMethod updScheStateNew(userId, state)
{
	Q:'$d(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId)) "1"
	s scheId = $o(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId,""))
	q:$lg(^CF.PHA.PREADT.DicSchemeD(scheId),5)=state "0"
	
	TS
	b ;1
	s res=..updScheState(userId, state)
	tro:res'=0
	q:res'=0 res
	b ;2
	s res=..InsertScheStateLog(userId, state)
	tro:res'=0
	q:res'=0 res
	b ;3
	TC
	q res
}

/// Descript:插入岗位日志
/// CreateDate:2022-04-07
/// Creator:Sunhuiyong
/// Input:userId
/// OutPut:0：成功，非0：失败
/// w ##class(web.DHCPRESCAudit).InsertScheStateLog("11874","在线")
ClassMethod InsertScheStateLog(userId, state)
{
	Q:'$d(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId)) "1"
	s scheId = $o(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId,""))
	s date=+$h
	s time=$p($h,",",2)
	b ;11
	&sql(
		insert into PHA_PREADT.DicSchemelog values (:scheId,:state,:date,:time) 		 
	)
	Q SQLCODE
}

/// Descript:判断是否在线
/// CreateDate:2022-01-19
/// Creator:sufan
/// Input:userId
/// OutPut:0：成功，非0：失败
/// w ##class(web.DHCPRESCAudit).Isactive(10213)
ClassMethod Isactive(userId)
{
	Q:'$d(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId)) "-1"
	s scheId = $o(^CF.PHA.PREADT.DicSchemeI("UserIndex",userId,""))
	s state = $lg(^CF.PHA.PREADT.DicSchemeD(scheId),5)
	Q:state="离线" 0
	Q 1
}

/// Descript:判断是否在线
/// CreateDate:2022-01-19
/// Creator:sufan
/// Input:userId
/// OutPut:0：成功，非0：失败
/// w ##class(web.DHCPRESCAudit).SynPrescAuditStatus(114)
ClassMethod SynPrescAuditStatus(auditId)
{
	Q:$d(^PHA.PREADT.AuditResultI("Parref",auditId)) "0"
	s createTime = $lg(^PHA.PREADT.AuditD(auditId),14) //创建时间
	
	s itemId = ""				//审核原因
	s userId = ##class(web.DHCPRESCCommonUtil).GetAutoAuditUser() //审核药师
	s stateCode = "STA04"		//状态代码
	s readCode = ""				//已读标识
	s remark = "超时自动通过"   //备注
	s listData = auditId_"^"_itemId_"^"_userId_"^"_stateCode_"^"_readCode_"^"_remark
	s imdtime = $p($h,",",2)-createTime
	s readFlag = $lg(^PHA.PREADT.AuditD(auditId),19)
	s overReadTime = ##class(web.DHCPRESCCommonUtil).GetOverReadTime(auditId)
	s OverTime=##class(web.DHCPRESCCommonUtil).GetOverTime(auditId) //系统配置超时秒数
	s ReadFlag=##class(web.DHCPRESCCommonUtil).GetReadFlag(auditId) //获取阅读标记
	s ret = 0
	if (ReadFlag="Y")&&(imdtime>=overReadTime)  d
	.s ret = ##class(web.DHCPRESCAudit).saveAuditInfo(listData)
	e  if (ReadFlag="")&&(imdtime>OverTime) d
	.s ret = ##class(web.DHCPRESCAudit).saveAuditInfo(listData)
	q ret
}

/// Descript:取默认审核人（轮循按待审工作量）
/// CreateDate:2022-02-23
/// Creator:hxy
/// Input:主表信息
/// OutPut:mainList
/// w ##class(web.DHCPRESCAudit).GetDefAuditor("")
ClassMethod GetDefAuditor(mainList)
{
	s MsgId = $p(mainList,"^",1)						//日志表Id
	s LocId = $p(mainList,"^",8) 						//科室Id
	;取出都有哪些人可以审核，然后抓到这些人里待审核数量最小的
	s UserDr = ""
	f  s UserDr = $o(^CF.PHA.PREADT.DicSchemeI("UserIndex",UserDr))  Q:UserDr=""  d
	.s RowId = ""
	.f  s RowId = $o(^CF.PHA.PREADT.DicSchemeI("UserIndex",UserDr,RowId))  Q:RowId=""  d
	..s State = $lg(^CF.PHA.PREADT.DicSchemeD(RowId),5)
	..q:State'="在线"
	..s LocList="",PrescList="",LinkId=""
	..f  s LinkId = $o(^CF.PHA.PREADT.SchLinkLocI("ItemCodeIndex",RowId,LinkId))  Q:LinkId=""  d
	.s Type = $lg(^CF.PHA.PREADT.SchLinkLocD(LinkId),4)
	.s Dr = $lg(^CF.PHA.PREADT.SchLinkLocD(linkId),3)
	.i Type="CTLoc" d
	..i LocList="" s LocList=Dr
	..e  s LocList = LocList_","_Dr
	.i Type="MedType" d
	..s Dr=$s(Dr=1:"西药方",Dr=2:"中成药方",Dr=3:"中草药方",1:"")
	..i PrescList="" s PrescList=Dr
	..e  s PrescList = PrescList_","_Dr
	

	s prescTypeList = ##class(web.DHCPRESCCommonUtil).GetAuditPrescList(auduserId)

	q ""
}

/// Creator:    xww
/// CreateDate: 2022-03-03
/// Descript:   取科室电话
/// InPut:      LocID - 科室ID
/// OutPut:     电话号码
/// w ##Class(web.DHCEMConsultQuery).GetLocTelPhone("") 
ClassMethod GetLocTelPhone(LocID As %String) As %String
{
	Q:'$d(^CTLOC(+LocID)) ""
	s TelPhone=$p($g(^CTLOC(+LocID)),"^",40)               /// 科室电话
	Q TelPhone
}

/// Creator:    xww
/// CreateDate: 2018-04-12
/// Descript:   取医生电话
/// InPut:      CareProvID - 医生ID
/// OutPut:     2022-03-03
/// w ##Class(web.DHCEMConsultQuery).GetCareProvPhone("")
ClassMethod GetCareProvPhone(CareProvID As %String) As %String
{
    Q:'$d(^CTPCP(+CareProvID,2)) ""
	s TelPhone=$p($g(^CTPCP(+CareProvID,2)),"^",1)    /// 会诊医生电话
	Q TelPhone
}

/// Creator:    shy
/// CreateDate: 2022-3-7
/// Descript:   审方主表阅读标记
/// InPut:      主表ID
/// w ##Class(web.DHCPRESCAudit).SetReadFlag("1")
ClassMethod SetReadFlag(AuditId) As %String
{
	Q:$lg(^PHA.PREADT.AuditD(AuditId),19)="Y" "0"
	s ReadFlag="Y"
    &SQL(
		UPDATE PHA_PREADT.Audit SET PA_ReadFlag=:ReadFlag WHERE PA_RowID=:AuditId
	)
	Q SQLCODE
}

/// Descript:阅读超时自动通过
/// CreateDate:2022-01-19
/// Creator:shy
/// Input:userId
/// OutPut:0：成功，非0：失败
/// w ##class(web.DHCPRESCAudit).OverPrescAuditStatus("2198")
ClassMethod OverPrescAuditStatus(auditId)
{
	Q:$d(^PHA.PREADT.AuditResultI("Parref",auditId)) "0"
	s createTime = $lg(^PHA.PREADT.AuditD(auditId),14) //创建时间
	
	s itemId = ""				//审核原因
	s userId = ##class(web.DHCPRESCCommonUtil).GetAutoAuditUser() //审核药师
	s stateCode = "STA04"		//状态代码
	s readCode = ""				//已读标识
	s remark = "超时自动通过"   //备注
	s listData = auditId_"^"_itemId_"^"_userId_"^"_stateCode_"^"_readCode_"^"_remark
	s imdtime = $p($h,",",2)-createTime
	s OverTime=##class(web.DHCPRESCCommonUtil).GetOverTime(auditId) //系统配置超时秒数
	s AuditResult=##class(web.DHCPRESCCommonUtil).GetAuditResult(auditId) //获取是否存在结果
	s ret = 0
	b ;shy
	i (ReadFlag'="Y")&&(imdtime>OverTime)  d  d    //&&(imdtime>OverTime)
	.b ;success
	.s ret = ##class(web.DHCPRESCAudit).saveAuditInfo(listData)
	q ret
}

/// Descript:批量保存审核内容
/// CreateDate:2022-03-21
/// Creator:shy
/// Input:listDataStr
/// OutPut:审查结果信息
/// w ##class(web.DHCPRESCAudit).saveAuditsInfo()
ClassMethod saveAuditsInfo(listDataStr)
{
	s length=$l(listDataStr,"$$")
	s count=0,ret = 0
	f i=1:1:length  q:ret'=0  d
	.s listData=$p(listDataStr,"$$",i)
	.s aduitId = $p(listData,"^",1)
	.s:$d(^PHA.PREADT.AuditResultI("Parref",aduitId)) count=count+1
	.q:$d(^PHA.PREADT.AuditResultI("Parref",aduitId))
	.TS
	.s ret = ##class(web.DHCPRESCAudit).saveAuditRes(listData)
	.i ret'=0 TRO
	.s ret = ##class(web.DHCPRESCAudit).updAuditState(listData)
	.i ret'=0 TRO
	.TC
	.s aduitId = $p(listData,"^",1)
	.s userId = $p(listData,"^",3)
	.d ##class(web.DHCPRESCNewsContact).InsertMessage(aduitId_"^已审核，请处理处方！^Audit","^^^"_userId)
	
	Q ret_"^"_count
}

/// w ##class(web.DHCPRESCAudit).test()
ClassMethod test()
{
	s obj = ##class(web.TermServiceSoap).%New()
	s ss = obj.ExportDiseaseWiKiData(1)
}

/// Descript:查询待审核列表[门急诊]
/// CreateDate:2021-09-10
/// Creator:sufan
/// Input:userId,date
/// OutPut:""
/// w ##class(web.DHCPRESCAudit).QueryAuditListIn(30,1,"2022-6-13^2022-6-13^0^10213^^^")
ClassMethod QueryAuditListIn(rows, page, params)
{
	s End = page*rows
	s Start=(page-1)*rows+1
	s pid = ##class(web.DHCPRESCCommonUtil).NewPid()
	s ^temptest("333")=$lb(params)
	s stdate = $p(params,"^",1)
	s:stdate'="" stdate=$zdh(stdate,3)
	s enddate = $p(params,"^",2)
	s:enddate'="" enddate=$zdh(enddate,3)
	s state = $p(params,"^",3)
	s auduserId = $p(params,"^",4)
	s res = $p(params,"^",5)
	s searchNo= $p(params,"^",6)  
	s curPatientId = $p(params,"^",7)  
	s MenuModule= $p(params,"^",8)
	s newtask = 0
	s contask = 0
	s comtask = 0
	s mustedit = 0
	s dblcheck = 0
	s pass = 0
	s count=0
	s audLocList = ##class(web.DHCPRESCCommonUtil).GetAuditLocList(auduserId)
	s prescTypeList = ##class(web.DHCPRESCCommonUtil).GetAuditPrescList(auduserId)
	k ^TMP("web.DHCPRESCAudit","QueryAuditListIn",pid)
	k ^TMP("web.DHCPRESCAudit","QueryAuditListIn","PatNum",pid)
	s time = ""
	for date=stdate:1:enddate  d
	.for  s time = $o(^PHA.PREADT.AuditI("Date",date,time))  Q:time=""  d
	..s auditId = ""
	..for  s auditId = $o(^PHA.PREADT.AuditI("Date",date,time,auditId))  Q:auditId=""  d
	...s admId = $lg(^PHA.PREADT.AuditD(auditId),3)					//就诊Id
	...s patType=$p($g(^PAADM(+admId)),"^",2) 	                        //就诊类型
	...Q:patType'="I"
	...s patientId = $lg(^PHA.PREADT.AuditD(auditId),4)				//患者Id
	...q:(curPatientId'="")&&(curPatientId'=patientId)					//xww 2022-03-03
	...s patName = $p(^PAPER(patientId,"ALL"),"^",1)  					//姓名
	...s patNo = $p(^PAPER(patientId,"PAT",1),"^",1)  					//登记号
	...s patSex = ""
	...s sexId = $p(^PAPER(patientId,"ALL"),"^",7)    					//姓别
	...i sexId'="" s patSex = $p(^CT("SEX",sexId),"^",2)	
	...s createDate = $lg(^PHA.PREADT.AuditD(auditId),13)				//创建日期
	...s:createDate'="" createDate = $zd(createDate,3)
	...s createTime = $lg(^PHA.PREADT.AuditD(auditId),14)				//创建时间
	...s imdtime = $p($h,",",2)-createTime
	...s:createTime'="" createTime = $zt(createTime,3)
	...s patAge = $lg(^PHA.PREADT.AuditD(auditId),5)					//患者年龄
	...s locId = $lg(^PHA.PREADT.AuditD(auditId),9)					//科室
	...s locDesc = ""						
	...s locDesc = $p($g(^CTLOC(+locId)),"^",2)							//过滤非监测列表的数据
	...Q:(audLocList'="")&&((","_audLocList_",")'[(","_locDesc_","))
	...s locTelPhone=##Class(web.DHCPRESCAudit).GetLocTelPhone(locId)   //科室电话
	...s weight = $lg(^PHA.PREADT.AuditD(auditId),7)					//体重
	...s admNo = $p(^PAADM(admId),"^",81)								//门诊号
	...s docId = $lg(^PHA.PREADT.AuditD(auditId),11)					//医生
	...s docDesc = "",CareProvID=""
	...s:docId'="" docDesc = $p(^SSU("SSUSR",docId),"^",2)	
	...s:docId'="" CareProvID=$p($g(^SSU("SSUSR",docId)),"^",14)
	...s docPhone=##Class(web.DHCPRESCAudit).GetCareProvPhone(CareProvID)  //医生电话
	...s diag = ##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(admId,",","GX") ;##class(web.DHCPRESCAudit).GetDiagnos(auditId)	
	...s spdiag = ""
	...s disdiaglen = $l(diag)
	...i disdiaglen>20 s spdiag = $e(diag,1,34)_"..."
	...e  s spdiag = diag
	...s chndiag = ##class(web.DHCSTKUTIL).GetMRDiagnosDescForRunQian(admId,",","GC")
	...s dischdiag = ""
	...s dischnlen = $l(chndiag)
	...i dischnlen>20 s dischdiag = $e(chndiag,1,32)_"..."
	...e  s dischdiag = chndiag	
	...s prescNo = $lg(^PHA.PREADT.AuditD(auditId),15)				//处方号
	...q:(searchNo'="")&&(searchNo'=prescNo)&&(searchNo'=admId)&&(searchNo'=patNo)  //xww 2022-03-03
	...s subId = $o(^PHA.PREADT.AuditListI("IndexParref",auditId,""))
	...s phCode = $lg(^PHA.PREADT.AuditListD(subId),4)
	...s presType = ##Class(web.DHCPRESCCommonUtil).GetRecipType(phCode)	
	...Q:(phCode'="")&(prescTypeList'="")&(prescTypeList'[presType)	                //处方类型的过滤
	...s status = $lg(^PHA.PREADT.AuditD(auditId),16)					//状态
	...s audresId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,""))
	...s audresSta = ""
	...s:audresId'="" audresSta = $lg(^PHA.PREADT.AuditResultD(audresId),6)
	...Q:(state=0)&&(imdtime>60)&&(audresSta="")
	...s resStatus = ""
	...i (status = 0)&&(imdtime<60) s newtask = newtask+1
	...i status = 1 s contask = contask+1 s imdtime = ""
	...i status = 2 s comtask = comtask+1 s imdtime = ""
	...i $d(^PHA.PREADT.AuditResultI("Parref",auditId))  d
	....s resId = ""
	....for  s resId = $o(^PHA.PREADT.AuditResultI("Parref",auditId,resId)) Q:resId=""  d
	.....s resStatusId = $lg(^PHA.PREADT.AuditResultD(resId),6)
	.....s resStatusCode = $lg(^CT.PHA.PREADT.DicItemD(resStatusId),2)
	.....i resStatusCode = "STA01" s mustedit = mustedit + 1
	.....i resStatusCode = "STA03" s dblcheck = dblcheck + 1
	.....i resStatusCode = "STA04" s pass = pass + 1
	...e  d
	....d ##class(web.DHCPRESCAudit).SynPrescAuditStatus(auditId)
	...Q:(state'="")&&(status'=state)
	...Q:(res'="")&&(resStatus'=res)&&(res'=audresSta)
	...s appeal=1 //申诉的处方
	...s tmpstr=auditId
	...i $d(^TMP("web.DHCPRESCAudit","QueryAuditList",pid,admId))  d
	....s ^TMP("web.DHCPRESCAudit","QueryAuditList",pid,admId) = ^TMP("web.DHCPRESCAudit","QueryAuditList",pid,admId)_"^"_auditId
	...e  d
	....s ^TMP("web.DHCPRESCAudit","QueryAuditList",pid,admId)=tmpstr
	...s ^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid,patientId)=+$g(^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid,patientId))+1
	
	s title="auditId^admId^patientId^patName^patNo^patSex^createDate^createTime^patAge^locDesc"  //10
	s title=title_"^weight^admNo^docDesc^diag^prescNo^status^imdtime^resStatus^patType^locTelPhone^docId"   //19
	s title=title_"^docPhone^patNum"
	w "{""rows"":["
	s typeNo=""
	f  s typeNo=$o(^TMP("web.DHCPRESCAudit","QueryAuditList",pid,typeNo)) q:typeNo=""  d
	.s appealNo=""
	.s appealNo=$o(^TMP("web.DHCPRESCAudit","QueryAuditList",pid,typeNo,appealNo)) q:appealNo=""  d
	..s datetime=""
	..f  s datetime=$o(^TMP("web.DHCPRESCAudit","QueryAuditList",pid,typeNo,appealNo,datetime)) q:datetime=""  d
	...s data=^TMP("web.DHCPRESCAudit","QueryAuditList",pid,typeNo,appealNo,datetime)
	...s patId=$p(data,"^",3)
	...s data=data_"^"_ ^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid,patId)
	...s count=count+1
	...q:count<Start
	...q:count>End
	...w $case(count,Start:"",:",")
	...w ##class(web.DHCADVJSONCOMMON).getJsonDataPort(title,data)
	w "],""total"":"_count_",""newtask"":"_newtask_",""contask"":"_contask_",""comtask"":"_comtask_",""mustedit"":"_mustedit_",""dblcheck"":"_dblcheck_",""pass"":"_pass_"}"
	k ^TMP("web.DHCPRESCAudit","QueryAuditList",pid)
	k ^TMP("web.DHCPRESCAudit","QueryAuditList","PatNum",pid)
	q ""
}

/// 取医嘱大类
/// w ##class(web.DHCEMOrdInfoVO).getOrcatDesc(13,164)
ClassMethod getOrcatDesc(ord As %String, itm As %String) As %String
{
	q:itm="" ""
	s arcimId=$p($g(^OEORD(ord,"I",itm,1)),"^",2) 
	s arcicId =$P($G(^ARCIM(+arcimId,$P(arcimId,"||",2),1)),"^",10) 
	i arcicId'=""  	s orcatId=$p($g(^ARC("IC",arcicId)),"^",8)
	i $g(orcatId)'=""  q $p($g(^OEC("ORCAT",orcatId)),"^",2)
	e  q ""
}

/// Descript:取处方信息(住院)
/// CreateDate:2023-01-06
/// Creator:sunhuiyong
/// Input:auditId
/// OutPut:医嘱信息
/// w ##class(web.DHCPRESCAudit).GetOrdList("615^^^")
ClassMethod GetOrdList(rows, page, params)
{
	//s ^shy("12")=params
	s End = page*rows
	s Start=(page-1)*rows+1
	s auditId=$p(params,"^",1)
	s stDate=$p(params,"^",2)
	s:stDate'="" stDate=$zdh(stDate,3)
	s edDate=$p(params,"^",3)
	s:edDate'="" edDate=$zdh(edDate,3)
	Q:auditId="" "[]"
	w "{""rows"":["
	s len=$l(auditId,"!!")
	s count=0
	s listTitle="seqNo^priority^linkSeqNo^drugCode^drugDesc^onceDose^preMet"
	s listTitle = listTitle_"^freq^treatment^ordPrice^packQty^packQtyUnit"
	s listTitle = listTitle_"^skinTest^recDeptDesc^ordDate^ordStDate^ordEndDate"
	s listTitle = listTitle_"^drugSpeed^drugSpeedUnit"
	f index=1:1:len   d
	.s auditDr=$p(auditId,"!!",index)
	.s subId = ""
	.for  s subId = $o(^PHA.PREADT.AuditListI("IndexParref",auditDr,subId))  Q:subId=""  d
	..s seqNo = $lg(^PHA.PREADT.AuditListD(subId),3)			//xuhao
	..s priorityCode = $lg(^PHA.PREADT.AuditListD(subId,1),6)	//youxianji
	..s priority = "",priorityId =""
	..s:priorityCode'="" priorityId = $o(^OECPR(0,"Code",$$ALPHAUP^SSUTIL4(priorityCode),""))
	..s:priorityId'="" priority = $p(^OECPR(priorityId),"^",2)
	..s linkSeqNo = $lg(^PHA.PREADT.AuditListD(subId),14)
	..s drugCode = $lg(^PHA.PREADT.AuditListD(subId),4)		//药品代码
	..s drugDesc = $lg(^PHA.PREADT.AuditListD(subId),5)		//药品名称
	..s onceDose = $lg(^PHA.PREADT.AuditListD(subId),6)		//单次剂量
	..s unit =  $lg(^PHA.PREADT.AuditListD(subId),7)		//单次剂量单位
	..s:onceDose'="" onceDose = onceDose_unit
	..s preMet = $lg(^PHA.PREADT.AuditListD(subId),8)		//给药途径
	..s freq = $lg(^PHA.PREADT.AuditListD(subId),9)			//频次
	..s treatment = $lg(^PHA.PREADT.AuditListD(subId),10)	//疗程
	..s ordCat = ##Class(web.DHCPRESCCommonUtil).GetRecipType(drugCode)     //医嘱大类 
	..s ordPrice = $lg(^PHA.PREADT.AuditListD(subId,1),9)	
	..s packQty = $lg(^PHA.PREADT.AuditListD(subId,1),3)
	..s packQtyUnit = $lg(^PHA.PREADT.AuditListD(subId,1),4)
	..
	..s:packQty'="" packQty = packQty_packQtyUnit
	..s skinTest = $lg(^PHA.PREADT.AuditListD(subId,1),5)
	..s recDeptDesc = $lg(^PHA.PREADT.AuditListD(subId,1),8)
	..s ordDate = $lg(^PHA.PREADT.AuditListD(subId,1),10)
	..s:ordDate'="" ordDate = $zd(ordDate,3)
	..s ordStDate = $lg(^PHA.PREADT.AuditListD(subId),15)
	..s:ordStDate'="" ordStDate = $zd(ordStDate,3)
	..s oeordID=$lg(^PHA.PREADT.AuditListD(subId),17)
	..;s ordEndDate="" //$p($g(^OEORD($p(oeordID,"||",1),"I",$p(oeordID,"||",2),9)),"^",9)
	..;s ordEndDateStr = $g(^OEORD($p(oeordID,"||",1),"I",$p(oeordID,"||",2),3))
	..;s ordEndDate = $p(ordEndDateStr,"^",34)
	..s ordEndDate = $lg(^PHA.PREADT.AuditListD(subId),19)   //医嘱停止时间
	..s:ordEndDate'="" ordEndDate = $zd(ordEndDate,3)
	..s drugSpeed = $lg(^PHA.PREADT.AuditListD(subId),12)
	..s drugSpeedUnit = $lg(^PHA.PREADT.AuditListD(subId),13)
	..s drugSpeed = drugSpeed_drugSpeedUnit
	..s listData = seqNo_"^"_priority_"^"_linkSeqNo_"^"_drugCode_"^"_drugDesc_"^"_onceDose_"^"_preMet
	..s listData = listData_"^"_freq_"^"_treatment_"^"_ordPrice_"^"_packQty_"^"_packQtyUnit
	..s listData = listData_"^"_skinTest_"^"_recDeptDesc_"^"_ordDate_"^"_ordStDate_"^"_ordEndDate
	..s listData = listData_"^"_drugSpeed_"^"_drugSpeedUnit
	..s count=count+1
	..q:count<Start
	..q:count>End
	..w $case(count,Start:"",:",")
	..w ##class(web.DHCEMJsonCommon).getJsonData(listTitle,listData)
	
	w "],""total"":"_count_"}"
	
	Q ""
}

}
