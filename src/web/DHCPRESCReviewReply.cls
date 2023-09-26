Import SQLUSER

/// Creator:     	qqa
/// CreateDate:   	2021-09-09
/// Descript:		处理界面
Class web.DHCPRESCReviewReply Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCPRESCReviewReply).JsonReviewReplyData(323)
ClassMethod JsonReviewReplyData(AuditID)
{
	n (AuditID)
	s ListTitle="PARRowID^PaAdmID^PatientID^PatName^PatNo^PrescNo^User^Date^Time^Status^Reason^Remark^PatDiagDesc^PatSex^PatAge^PatLoc"
	;s AuditID=$lg(^PHA.PREADT.AuditResultD(PARRowID),2)
	s PARRowID=##class(web.DHCPRESCNewsContact).GetPARLastRowId(AuditID)
	q:+AuditID=0
	s PaAdmID=$lg(^PHA.PREADT.AuditD(AuditID),3)
	s PatDiagDesc=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(PaAdmID,",")	//诊断
	s PatientID=$lg(^PHA.PREADT.AuditD(AuditID),4)
	q:+PatientID=0
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)   /// 姓别
	s PatSex=$p($g(^CT("SEX",+SexId)),"^",2)
	s PatAge=##Class(web.DHCBillInterface).GetPapmiAge(PatientID,PaAdmID) ///年龄
	s PatLoc=""
	s PatLocID=$p(^PAADM(PaAdmID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s Diag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(PaAdmID,",")
	s PrescNo=$lg(^PHA.PREADT.AuditD(AuditID),15) ///处方号
	s UserID="",User=""
	s:PARRowID'="" UserID=$lg(^PHA.PREADT.AuditResultD(PARRowID),3)
	s:UserID'="" User=$p(^SSU("SSUSR",UserID),"^",2)					///审核人
	s Date="",Time=""
	s:PARRowID'="" Date=$lg(^PHA.PREADT.AuditResultD(PARRowID),4)		///审核日期
	s:Date'="" Date=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(Date)
	s:PARRowID'="" Time=$lg(^PHA.PREADT.AuditResultD(PARRowID),5)		///审核时间
	s:Time'="" Time=$zt(Time,1)
	s StatusID="",ReasonID="",Remark=""
	s:PARRowID'="" StatusID=$lg(^PHA.PREADT.AuditResultD(PARRowID),6)
	s Status=$lg(^CT.PHA.PREADT.DicItemD(StatusID),3)			///打回,医生双签,通过
								
	s:PARRowID'="" ReasonID=$lg(^PHA.PREADT.AuditResultD(PARRowID),7)		///审核原因
	s Reason=""
	s:ReasonID'="" Reason = $lg(^CT.PHA.PREADT.DicItemD(ReasonID),3)
	s:PARRowID'="" Remark=$lg(^PHA.PREADT.AuditResultD(PARRowID),8)		///原因备注
	s ListData=PARRowID_"^"_PaAdmID_"^"_PatientID_"^"_PatName_"^"_PatNo_"^"_PrescNo_"^"_User_"^"_Date_"^"_Time
	s ListData=ListData_"^"_Status_"^"_Reason_"^"_Remark_"^"_Diag_"^"_PatSex_"^"_PatAge_"^"_PatLoc
	w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	q ""
}

/// w ##class(web.DHCPRESCReviewReply).JsonReviewReplyListData(105)
ClassMethod JsonReviewReplyListData(AuditID)
{
	n (AuditID)
	;s AuditID=$lg(^PHA.PREADT.AuditResultD(PARRowID),2)
	q:+AuditID=0
	s PARRowID=##class(web.DHCPRESCNewsContact).GetPARLastRowId(AuditID)
	s Count=0
	s ListTitle="PALRowID^DrugCode^DrugDesc^OnceDose^Unit^DrugPreMet^DrugFreq^Treatment^FirstUseFlag^DrugSpeed^DrugSpeedUnit^LinkSeqNo^StDate^Question"
	w "["
	s PALRowID=0 
	f  s PALRowID=$o(^PHA.PREADT.AuditListI("IndexParref",AuditID,PALRowID)) q:PALRowID=""  d
	.s DrugCode=$lg(^PHA.PREADT.AuditListD(PALRowID),4)		///药品代码
	.s DrugDesc=$lg(^PHA.PREADT.AuditListD(PALRowID),5)		///药品名称
	.s OnceDose=$lg(^PHA.PREADT.AuditListD(PALRowID),6)		///单次剂量
	.s Unit=$lg(^PHA.PREADT.AuditListD(PALRowID),7)			///剂量单位
	.s DrugPreMet=$lg(^PHA.PREADT.AuditListD(PALRowID),8)		///用法
	.s DrugFreq=$lg(^PHA.PREADT.AuditListD(PALRowID),9)		///频次
	.s Treatment=$lg(^PHA.PREADT.AuditListD(PALRowID),10)		///疗程
	.s FirstUseFlag=$lg(^PHA.PREADT.AuditListD(PALRowID),11)	///是否首次用药
	.s DrugSpeed=$lg(^PHA.PREADT.AuditListD(PALRowID),12)		///滴速
	.s DrugSpeedUnit=$lg(^PHA.PREADT.AuditListD(PALRowID),13)	///滴速单位
	.s LinkSeqNo=$lg(^PHA.PREADT.AuditListD(PALRowID),14)		///关联序号
	.s StDate=$lg(^PHA.PREADT.AuditListD(PALRowID),15)		///开始日期
	.s Question = ..GetAuditInfo(AuditID)  	//处方问题   shy
	.s:StDate'="" StDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(StDate)
	.s ListData=PALRowID_"^"_DrugCode_"^"_DrugDesc_"^"_OnceDose_"^"_Unit_"^"_DrugPreMet_"^"_DrugFreq_"^"_Treatment_"^"_FirstUseFlag_"^"_DrugSpeed
	.s ListData=ListData_"^"_DrugSpeedUnit_"^"_LinkSeqNo_"^"_StDate_"^"_Question
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// w ##class(web.DHCPRESCReviewReply).JsonReviewReplyListDataAdm(6849,0)
ClassMethod JsonReviewReplyListDataAdm(AuditID, flag)
{
	n (AuditID,flag)
	i flag=0 d ..JsonReviewReplyListData(AuditID)
	q:flag=0 ""
	s nullStr = ""
	s PaAdmID=$lg(^PHA.PREADT.AuditD(AuditID),3)
	s audidtID =""
	
	/// 1.根据消息ID按组存auditID
	k AudidtIDARR,MSGARR
	f  s audidtID = $o(^PHA.PREADT.AuditI("Adm",PaAdmID,audidtID)) q:audidtID=""  d
	.s ResultID=""
	.i '$d(AudidtIDARR(audidtID)) s AudidtIDARR(audidtID)=""
	.s ResultID=$o(^PHA.PREADT.AuditResultI("Parref",audidtID,ResultID)) q:ResultID=""  d
	..s PARMsgId = $lg(^PHA.PREADT.AuditResultD(ResultID),10)
	..q:+PARMsgId=0
	..s MSGARR(PARMsgId,audidtID)=""    
	
	/// 2.把消息ID内按组存的auditID去除掉
	s msgID=""
	f  s msgID=$o(MSGARR(msgID)) q:msgID=""  d
	.s audit = "" ,audtiLis = "" 
	.f  s audit = $o(MSGARR(msgID,audit)) q:audit=""  d
	..k AudidtIDARR(audit)
	..i audtiLis="" s audtiLis = audit
	..e  s audtiLis = audtiLis_","_audit
	.s MSGARR(msgID)=audtiLis
	
	/// 3.把非成组的auditID，给个序列号存到数组
	s start = 0
	s audit=""
	f  s audit = $o(AudidtIDARR(audit)) q:audit=""  d
	.s start= start-1
	.s MSGARR(start)= audit
	
	s msgID="",Count=0
	w "["
	f  s msgID=$o(MSGARR(msgID)) q:msgID=""  d
	.s AuditList=MSGARR(msgID)
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.w ..getReviewReply(AuditList)
	
	w "]"
	
	q ""
}

/// 成组的输出，加循环
/// w ##class(web.DHCPRESCReviewReply).getReviewReply("6850,6851")
ClassMethod getReviewReply(AuditList)
{
	n (AuditList)
	
	;s AuditID=$lg(^PHA.PREADT.AuditResultD(PARRowID),2)
	q:+AuditList=0
	;s PARRowID=##class(web.DHCPRESCNewsContact).GetPARLastRowId(AuditID)
	s Count=0
	s ListTitle="PALRowID^DrugCode^DrugDesc^OnceDose^Unit^DrugPreMet^DrugFreq^Treatment^FirstUseFlag^DrugSpeed^DrugSpeedUnit^LinkSeqNo^StDate^Question"
	
	
	w "["
	s len = $l(AuditList,",")
	f w=1:1:len d
	.s AuditID= $p(AuditList,",",w)
	.s PALRowID=0
	.f  s PALRowID=$o(^PHA.PREADT.AuditListI("IndexParref",AuditID,PALRowID)) q:PALRowID=""  d
	..s DrugCode=$lg(^PHA.PREADT.AuditListD(PALRowID),4)		///药品代码
	..s DrugDesc=$lg(^PHA.PREADT.AuditListD(PALRowID),5)		///药品名称
	..s OnceDose=$lg(^PHA.PREADT.AuditListD(PALRowID),6)		///单次剂量
	..s Unit=$lg(^PHA.PREADT.AuditListD(PALRowID),7)			///剂量单位
	..s DrugPreMet=$lg(^PHA.PREADT.AuditListD(PALRowID),8)		///用法
	..s DrugFreq=$lg(^PHA.PREADT.AuditListD(PALRowID),9)		///频次
	..s Treatment=$lg(^PHA.PREADT.AuditListD(PALRowID),10)		///疗程
	..s FirstUseFlag=$lg(^PHA.PREADT.AuditListD(PALRowID),11)	///是否首次用药
	..s DrugSpeed=$lg(^PHA.PREADT.AuditListD(PALRowID),12)		///滴速
	..s DrugSpeedUnit=$lg(^PHA.PREADT.AuditListD(PALRowID),13)	///滴速单位
	..s LinkSeqNo=$lg(^PHA.PREADT.AuditListD(PALRowID),14)		///关联序号
	..s StDate=$lg(^PHA.PREADT.AuditListD(PALRowID),15)		///开始日期
	..s Question = ..GetAuditInfo(AuditID)  	//处方问题   shy
	..s:StDate'="" StDate=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(StDate)
	..s ListData=PALRowID_"^"_DrugCode_"^"_DrugDesc_"^"_OnceDose_"^"_Unit_"^"_DrugPreMet_"^"_DrugFreq_"^"_Treatment_"^"_FirstUseFlag_"^"_DrugSpeed
	..s ListData=ListData_"^"_DrugSpeedUnit_"^"_LinkSeqNo_"^"_StDate_"^"_Question
	..s Count=Count+1
	..w $case(Count,1:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

/// w ##class(web.DHCPRESCReviewReply).InsetPrescAuditResult("6850","^Y","2^1^318^11870")
ClassMethod InsetPrescAuditResult(AuditID, Params, LgParams)
{
	n (AuditID,Params,LgParams)
	s ^temptest("4sw44")=$lb(AuditID,Params,LgParams)
	s Remark=$p(Params,"^",1)
	s IsUpdStat=$p(Params,"^",2)
	;s AuditID=$lg(^PHA.PREADT.AuditResultD(PARRowID),2)
	s LgUserID=$p(LgParams,"^",4)
	s AuditDate=+$h
	s AuditTime=$p($h,",",2)
	;s StatusID=$lg(^PHA.PREADT.AuditResultD(PARRowID),6) 
	;s StatusID=4 ;固定的id(通过)
	s StatusID=$o(^CT.PHA.PREADT.DicItemI("Code","STA04",""))
	s ReasonID=""
	s LastId=##class(web.DHCPRESCNewsContact).GetPARLastRowId(AuditID)
	s ReadFlag="Y"	;回复的默认就是已读
	ts
	
	&sql(INSERT INTO PHA_PREADT.AuditResult (PAR_Audit_Dr,PAR_User_Dr,PAR_Date,PAR_Time,PAR_Status_Dr,PAR_Reason_Dr,PAR_Remark,PAR_LastId)
		 VALUES(:AuditID,:LgUserID,:AuditDate,:AuditTime,:StatusID,:ReasonID,:Remark,:LastId))
	tro:SQLCODE'=0
	q:SQLCODE'=0 "插入AuditResult错误,错误信息"_SQLCODE
	
	;&sql(UPDATE PHA_PREADT.Audit SET PA_AuditStatus_Dr="4" WHERE PA_RowID=:AuditID)
	;tro:SQLCODE'=0
	;q:SQLCODE'=0 "修改Audit表失败,错误信息"_SQLCODE
	
	tc
	
	do ##class(web.DHCPRESCNewsContact).WsSendData("Doctor",AuditID,LgUserID,"")
	
	q 0
}

/// Descript:取审查信息信息
/// CreateDate:2022-03-25
/// Creator:shy
/// Input:auditId
/// OutPut:合理用药提示信息
/// w ##class(web.DHCPRESCReviewReply).GetAuditInfo(216)
ClassMethod GetAuditInfo(auditId)
{
	Q:auditId="" "[]"
	s result = $lg(^PHA.PREADT.AuditD(auditId),17)
	s resultObj = ##class(%DynamicArray).%FromJSON(result)
	;w resultObj.%ToJSON()
	;Q ""
	s itemsArr = resultObj.items
	q:itemsArr="" "[]"
	s length = itemsArr.%Size()
	s previewArr = []
	s keynameArr = []
	s tipsArr = []
	s res= ""
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
	....s res=res_"$$"_val
	....s tipObj.keyname = subItmsObj.keyname
	....d tipsArr.%Push(tipObj)
	..s keyObj.tips = tipsArr
	.s drugObj.warn = keynameArr
	
	q res
}

/// 将医师的消息设置为已读状态
ClassMethod SetMsgStatus(AuditID, UserType, LgParams)
{
	n (AuditID,UserType,LgParams)
	
	s UserID=$p(LgParams,"^",4)
	s AppUserID=$lg(^PHA.PREADT.AuditD(AuditID),11)
	s PAMRowID=0
	f  s PAMRowID =$o(^PHA.PREADT.AuditMsgI("PAMAudit",AuditID,PAMRowID)) q:PAMRowID=""  d
	.s IsRead=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),8)
	.s PAMType=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),9)
	.q:IsRead="Y"
	.q:(UserType="Doctor")&&(PAMType'="Audit")
	.q:(UserType="Doctor")&&(UserID'="")&&(UserID'=AppUserID)  ;医师查看自己的消息时,只看自己提交的记录的
	.s TMPData("PAMRowID",PAMRowID)=""
	
	
	ts
	
	s Err = 0
	s PAMRowID = 0
	f  s PAMRowID=$o(TMPData("PAMRowID",PAMRowID)) q:(PAMRowID="")||(Err'=0)  d
	.&sql(UPDATE PHA_PREADT.AuditMsg SET PAM_ReadFlag="Y" WHERE PAM_RowID=:PAMRowID)
	.s Err=SQLCODE
	
	tro:Err'=0
	q:Err'=0 "失败!"
	
	tc
	
	q 0
}

}
