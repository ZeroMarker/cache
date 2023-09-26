Import SQLUSER

/// Creator:     	qqa
/// CreateDate:   	2021-09-09
/// Descript:		获取待处理信息
Class web.DHCPRESCAuditPopup Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCPRESCAuditPopup).JsonListUnreadMessage("","")
ClassMethod JsonListUnreadMessage(Params, LgParams)
{
	n (Params,LgParams)
	s LgUserID=$p(LgParams,"^",4)
	s ListTitle="PARRowID^PaAdmID^PatientID^PatName^PatNo^PatSex^PatAge^PatLoc^QueDoc^PrescNo^User^Date^Time^Status^Reason^Remark"
	s Count=0
	w "["
	s PARRowID=0
	f  s PARRowID=$o(^PHA.PREADT.AuditResultI("ReadFlag"," N",PARRowID)) q:PARRowID=""  d
	.s LastID=$lg(^PHA.PREADT.AuditResultD(PARRowID),9)
	.q:+LastID'=0
	.s AuditID=$lg(^PHA.PREADT.AuditResultD(PARRowID),2)
	.q:+AuditID=0
	.s PAUserId=$lg(^PHA.PREADT.AuditD(AuditID),11)
	.;q:LgUserID'=PAUserId
	.s PaAdmID=$lg(^PHA.PREADT.AuditD(AuditID),3)
	.s PatientID=$lg(^PHA.PREADT.AuditD(AuditID),4)
	.q:+PatientID=0
	.s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	.s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	.s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	.s PatSex=$p($g(^CT("SEX",+SexId)),"^",2)
	.s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)
	.s PatLocID=$p(^PAADM(PaAdmID),"^",4) 		/// 就诊科室
	.s PatLoc=$p($g(^CTLOC(+PatLocID)),"^",2)
	.s DHCQueueDr = $o(^User.DHCQueueI("QuePaadmDrIndex",PaAdmID,""),-1)
	.s QueDocDr = $lg($g(^User.DHCQueueD(+DHCQueueDr)),5)							   //就诊医生
	.s QueDoc = $case(QueDocDr,"":"",QueDocDr:$p(^CTPCP(QueDocDr,1),"^",2))
	.s PrescNo=$lg(^PHA.PREADT.AuditD(AuditID),15) ///处方号
	.s UserID=$lg(^PHA.PREADT.AuditResultD(PARRowID),3)
	.s User=$p(^SSU("SSUSR",UserID),"^",2)					///审核人
	.s Date=$lg(^PHA.PREADT.AuditResultD(PARRowID),4)		///审核日期
	.s:Date'="" Date=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(Date)
	.s Time=$lg(^PHA.PREADT.AuditResultD(PARRowID),5)		///审核时间
	.s:Time'="" Time=$zt(Time,2)
	.s StatusID=$lg(^PHA.PREADT.AuditResultD(PARRowID),6)
	.s Status=$case(StatusID,1:"必须修改",2:"双签复核",3:"双签通过",4:"通过",:"") ///打回,医生双签,通过
	.s ReasonID=$lg(^PHA.PREADT.AuditResultD(PARRowID),7)		///审核原因
	.s Reason=""
	.s Remark=$lg(^PHA.PREADT.AuditResultD(PARRowID),8)		///原因备注
	.s Count=Count+1
	.w $case(Count,1:"",:",")
	.s ListData=PARRowID_"^"_PaAdmID_"^"_PatientID_"^"_PatName_"^"_PatNo_"^"_PatSex_"^"_PatAge_"^"_PatLoc_"^"_QueDoc_"^"_PrescNo_"^"_User_"^"_Date_"^"_Time
	.s ListData=ListData_"^"_Status_"^"_Reason_"^"_Remark
	.w ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
	w "]"
	q ""
}

ClassMethod UpdDataReadStat(PARRowID)
{
	n (PARRowID)
	;&sql(UPDATE PHA_PREADT.AuditResult SET PAR_ReadFlag="Y" WHERE PAR_RowID=:PARRowID)
	q SQLCODE
}

/// Descript:主页右下角，显示待处理数量
/// w ##class(web.DHCPRESCAuditPopup).MainUnReadTextNew("Doctor^13923")
ClassMethod MainUnReadTextNew(Params)
{
	n (Params)
	
	s UserType=$p(Params,"^",1) ;Audit/Doctor
	s UserID=$p(Params,"^",2)
	
	s AllAuditNum=0,AllMsgNum=0 ;未读消息数
	s Num=0,AuditDr="",ResStaCode="" //最新一条待处理消息的主表指针、结果状态
	
	;24小时内的方子
	s StDate=+$h-1
	s EndDate=+$h
	f Date=StDate:1:EndDate d
	.s:Date=StDate Time=$p($h,",",2)
	.s:Date=EndDate Time=0
	.f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time)) q:Time=""  d
	..s AuditID=0
	..f  s AuditID=$o(^PHA.PREADT.AuditI("Date",Date,Time,AuditID)) q:AuditID=""  d
	...;d ##class(web.DHCPRESCAudit).SynPrescAuditStatus(AuditID)		//超时自动通过
	...s AppUserID=$lg(^PHA.PREADT.AuditD(AuditID),11)
	...s PAMRowID=0
	...f  s PAMRowID =$o(^PHA.PREADT.AuditMsgI("PAMAudit",AuditID,PAMRowID)) q:PAMRowID=""  d
	....s IsRead=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),8)
	....s PAMType=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),9)
	....q:(UserType="Doctor")&&(PAMType'="Audit")
	....;q:(UserType="Audit")&&(PAMType'="Doctor")
	....q:(UserType="Doctor")&&(UserID'="")&&(UserID'=AppUserID)  ;医师查看自己的消息时,只看自己提交的记录的
	....s:IsRead="N" AllMsgNum=AllMsgNum+1	 ;未读数量才+1
	....s Con=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),4)
#;	....s:(Con="已审核，请处理处方！")&(Num=0) AuditDr=AuditID //第一个未读消息且是审核结果的消息审方主表ID
#;	....s:(Con="已审核，请处理处方！")&(Num=0) Num= Num+1      //第一个未读消息且是审核结果的消息审方主表ID
#;	....s:AuditDr'="" ResStaCode=##Class(web.DHCPRESCCommonUtil).GetResStaCode(AuditID) //
	....;b //
	....q:$d(TMPData(AuditID))
	....s IsPend=##class(web.DHCPRESCAuditPopup).DocIsPendStatus(AuditID)
	....s TMPData(AuditID)=""
	....q:IsPend'="Y"
	....s:AllAuditNum=0 AuditDr=AuditID //第一个待处理审方主表ID
	....s:AuditDr'="" ResStaCode=##Class(web.DHCPRESCCommonUtil).GetResStaCode(AuditID)
	....s AllAuditNum=AllAuditNum+1
	
	;含有未读消息
	/*
	s PAMRowID=0
	f  s PAMRowID=$o(^PHA.PREADT.AuditMsgI("ReadFlag"," N",PAMRowID)) q:PAMRowID=""  d
	.s AuditID=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),2)
	.q:+AuditID=0
	.d ##class(web.DHCPRESCAudit).SynPrescAuditStatus(AuditID)		//超时自动通过
	.s PAUserId=$lg(^PHA.PREADT.AuditD(AuditID),11)
	.s PAMType=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),9)
	.q:(UserType="Doctor")&&(PAMType'="Audit")
	.q:(UserType="Audit")&&(PAMType'="Doctor")
	.q:(UserType="Doctor")&&(UserID'="")&&(UserID'=PAUserId)  ;医师查看自己的消息时,只看自己提交的记录的
	.s AllMsgNum=AllMsgNum+1
	.q:$d(TMPData(AuditID))
	.s IsPend=##class(web.DHCPRESCAuditPopup).DocIsPendStatus(AuditID)
	.s TMPData(AuditID)=""
	.q:IsPend'="Y"
	.s AllAuditNum=AllAuditNum+1
	
	;b ; err
	
	;含有未处理,这里只考虑医师的未处理
	i UserType="Doctor" d
	.s StDate=+$h-30
	.s EndDate=+$h
	.f Date=StDate:1:EndDate d
	..s Time=0
	..f  s Time=$o(^PHA.PREADT.AuditResultI("Date",Date,Time)) q:Time=""  d
	...s PARRowId=0
	...f  s PARRowId=$o(^PHA.PREADT.AuditResultI("Date",Date,Time,PARRowId)) q:PARRowId=""  d
	....s AuditID=$lg(^PHA.PREADT.AuditResultD(PARRowId),2)
	....d ##class(web.DHCPRESCAudit).SynPrescAuditStatus(AuditID)		//超时自动通过
	....s AppUserID=$lg(^PHA.PREADT.AuditD(AuditID),11)
	....q:(UserID'="")&&(UserID'=AppUserID)
	....q:$d(TMPData(AuditID))
	....s IsPend=##class(web.DHCPRESCAuditPopup).DocIsPendStatus(AuditID)
	....s TMPData(AuditID)=""
	....q:IsPend'="Y"
	....s AllAuditNum=AllAuditNum+1
	*/
	
	q AllAuditNum_"^"_AllMsgNum_"^"_AuditDr_"^"_ResStaCode
}

/// Descript:待弹出消息列表
/// w ##class(web.DHCPRESCAuditPopup).MainUnReadList("Doctor^11870")
ClassMethod MainUnReadList(Params)
{
	n (Params)
	s UserType=$p(Params,"^",1) ;Audit/Doctor
	s UserID=$p(Params,"^",2)
	
	
	s AllAuditNum=0,AllMsgNum=0 ;未读消息数
	
	;查几个小时之内的方子
	s InHours=1
	s SelectStTime = $p($h,",",2)-(InHours*3600)
	s:SelectStTime<0 SelectStTime=SelectStTime+(3600*24)
	
	k TPMData("AllList")
	;24小时内的方子
	s StDate=+$h-1
	s EndDate=+$h
	f Date=StDate:1:EndDate d
	.s:Date=StDate Time=SelectStTime ;$p($h,",",2)
	.s:Date=EndDate Time=0
	.f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time)) q:Time=""  d
	..s AuditID=0
	..f  s AuditID=$o(^PHA.PREADT.AuditI("Date",Date,Time,AuditID)) q:AuditID=""  d
	...;d ##class(web.DHCPRESCAudit).SynPrescAuditStatus(AuditID)		//超时自动通过
	...s CreatDate=$lg(^PHA.PREADT.AuditD(AuditID),13)
	...s CreatTime=$lg(^PHA.PREADT.AuditD(AuditID),14)
	...s DateTime = $zd(CreatDate,3)_" "_$zt(CreatTime,1)
	...s AppUserID=$lg(^PHA.PREADT.AuditD(AuditID),11)
	...s PrescNo=$lg(^PHA.PREADT.AuditD(AuditID),15) ///处方号
	...s PaAdmID=$lg(^PHA.PREADT.AuditD(AuditID),3)
	...s PatientID=$lg(^PHA.PREADT.AuditD(AuditID),4)
	...q:+PatientID=0
	...s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	...s HasUnReadMsg=""
	...s PAMRowID=0
	...f  s PAMRowID =$o(^PHA.PREADT.AuditMsgI("PAMAudit",AuditID,PAMRowID)) q:PAMRowID=""  d
	....s IsRead=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),8)
	....s PAMType=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),9)
	....q:(UserType="Doctor")&&(PAMType'="Audit")
	....;q:(UserType="Audit")&&(PAMType'="Doctor")
	....q:(UserType="Doctor")&&(UserID'="")&&(UserID'=AppUserID)  ;医师查看自己的消息时,只看自己提交的记录的
	....s:IsRead="N" HasUnReadMsg="Y"
	....s:IsRead="N" AllMsgNum=AllMsgNum+1	 ;未读数量才+1
	....s Con=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),4)
	....q:$d(TMPData(AuditID))
	....s IsPend=##class(web.DHCPRESCAuditPopup).DocIsPendStatus(AuditID)
	....s:IsPend="Y" AllAuditNum=AllAuditNum+1
	....q:(HasUnReadMsg'="Y")&&(IsPend'="Y") ;没有未读消息也不是需要处理的不自动弹出
	....s TMPData(AuditID)=""
	....s ResStaCode=##Class(web.DHCPRESCCommonUtil).GetResStaCode(AuditID)
	....s OrderIsPend=$case(IsPend,"Y":1,:2)
	....s OrderHasUnReadMsg=$case(HasUnReadMsg,"Y":1,:2)
	....s OrderIndex= OrderHasUnReadMsg_"^"_OrderIsPend
	....s TPMData("AllList",OrderIndex,AuditID)= AuditID_"^"_ResStaCode_"^"_PrescNo_"^"_PatName_"^"_DateTime
	
	s ItmTitle = "AuditID^ResStaCode^PrescNo^PatName^DateTime"
	w "{"
	w """AllAuditNum"":"_AllAuditNum_","
	w """AllMsgNum"":"_AllMsgNum_","
	w """unDeal"":["
	s Count=0
	s Index=""
	f  s Index = $o(TPMData("AllList",Index)) q:Index=""  d
	.s AuditID=0
	.f  s AuditID=$o(TPMData("AllList",Index,AuditID)) q:AuditID=""  d
	..s ItmData = TPMData("AllList",Index,AuditID)
	..s Count=Count+1
	..w $case(Count,1:"",:",")
	..w ##class(web.DHCAPPJsonCommon).getJsonData(ItmTitle,ItmData)
	w "]"
	w "}"
	q ""
}

ClassMethod IsPending(Params)
{
	n (Params)
	s UserType=$p(Params,"^",1) ;Audit/Doctor
	s UserID=$p(Params,"^",2)
}

/// Descript:主页右下角，显示待处理数量
/// w ##class(web.DHCPRESCAuditPopup).MainUnReadText("Audit","")
ClassMethod MainUnReadText(Params, LgParams)
{
	n (Params,LgParams)
	
	s MsgType=$p(Params,"^",1)
	s LgUserID=$p(LgParams,"^",4)
	
	s PAMRowID=0
	f  s PAMRowID=$o(^PHA.PREADT.AuditMsgI("ReadFlag"," N",PAMRowID)) q:PAMRowID=""  d
	.s AuditID=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),2)
	.q:+AuditID=0
	.s PAUserId=$lg(^PHA.PREADT.AuditD(AuditID),11)
	.q:(MsgType="Audit")&&(LgUserID'=PAUserId) ;查看中心发消息时,只看自己提交的记录的
	.s PAMType=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),9)
	.q:(MsgType'="")&&(MsgType'=PAMType)
	.s:$d(TMPData(AuditID)) TMPData(AuditID)=TMPData(AuditID)+1
	.s:'$d(TMPData(AuditID)) TMPData(AuditID)=1
	
	s AllAuditNum=0,AllMsgNum=0
	s AuditID=""
	f  s AuditID=$o(TMPData(AuditID)) q:AuditID=""  d
	.s ThisMsgNum = TMPData(AuditID)
	.s AllAuditNum=AllAuditNum+1
	.s AllMsgNum=AllMsgNum+ThisMsgNum
	
	q AllAuditNum_"^"_AllMsgNum
}

/// Descript:
/// w ##class(web.DHCPRESCAuditPopup).JsonListUnreadMessageNew("Audit","2^184^135^18946")
ClassMethod JsonListUnreadMessageNew(Params, LgParams)
{
	n (Params, LgParams)
	s ^temptest("Params") = $lb(Params, LgParams)
	s UserType=$p(Params,"^",1)
	s isReadFlag = $p(Params,"^",2)
	s LgUserID=$p(LgParams,"^",4)
	
	
	;未读列表
	;s PAMRowID=0
	;f  s PAMRowID=$o(^PHA.PREADT.AuditMsgI("ReadFlag"," N",PAMRowID)) q:PAMRowID=""  d
	;.s AuditID=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),2)
	;.q:+AuditID=0
	;.s PAUserId=$lg(^PHA.PREADT.AuditD(AuditID),11)
	;.s PAMType=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),9)
	;.;q:(UserType="Doctor")&&(PAMType'="Audit")
	;.;q:(UserType="Audit")&&(PAMType'="Doctor")
	;.;q:(UserType="Doctor")&&(LgUserID'="")&&(LgUserID'=PAUserId)  ;医师查看自己的消息时,只看自己提交的记录的
	;.s TMPData(AuditID)=""
	
	
	s StDate=+$h-1
	s EndDate=+$h
	f Date=StDate:1:EndDate d
	.s:Date=StDate Time=$p($h,",",2)
	.s:Date=EndDate Time=0
	.f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time)) q:Time=""  d
	..s AuditID=0
	..f  s AuditID=$o(^PHA.PREADT.AuditI("Date",Date,Time,AuditID)) q:AuditID=""  d
	...;s AuditID=$lg(^PHA.PREADT.AuditResultD(PARRowId),2)
	...s AppUserID=$lg(^PHA.PREADT.AuditD(AuditID),11)
	...;q:(UserType="Doctor")&&(LgUserID'=AppUserID)   ;调试完放开
	...s readFlag = ##class(web.DHCPRESCAuditPopup).IsReadFlag(AuditID,UserType)
	...Q:(isReadFlag'="")&&(readFlag'=isReadFlag)
	...;s TMPData(AuditID)=""
	...s OrdIndex = Date_","_Time
	...s TMPData("OrderTime",OrdIndex,AuditID)=""
	
	;不能按照未读和已读以及审核未审核排序，要按照申请日期和时间
	;s AuditID=""
	;f  s AuditID=$o(TMPData(AuditID),-1) q:AuditID=""  d
	;.s IsPend=##class(web.DHCPRESCAuditPopup).DocIsPendStatus(AuditID)
	;.s IndexRead=2
	;.s:IsPend="Y" IndexRead=1
	;.s TMPData("PAMRowID",IndexRead,AuditID)=""
	
	s Count=0
	w "["
	s Index=""
	f  s Index=$o(TMPData("OrderTime",Index),-1) q:Index=""  d
	.s AuditID=0
	.f  s AuditID=$o(TMPData("OrderTime",Index,AuditID)) q:AuditID=""  d
	..s Count=Count+1
	..w $case(Count,1:"",:",")
	..w ##class(web.DHCPRESCAuditPopup).JsonUnreadMessageNew(AuditID)
	w "]"
	
	q ""
}

/// Descript:废弃了
/// w ##class(web.DHCPRESCAuditPopup).JsonListUnreadMessageNew("Audit","2^212^22^11843")
ClassMethod JsonListUnreadMessageNewBak(Params, LgParams)
{
	n (Params,LgParams)
	s MsgType=$p(Params,"^",1)
	s LgUserID=$p(LgParams,"^",4)
	
	
	;未读列表
	s PAMRowID=0
	f  s PAMRowID=$o(^PHA.PREADT.AuditMsgI("ReadFlag"," N",PAMRowID)) q:PAMRowID=""  d
	.s AuditID=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),2)
	.q:+AuditID=0
	.s PAUserId=$lg(^PHA.PREADT.AuditD(AuditID),11)
	.q:(MsgType="Audit")&&(LgUserID'=PAUserId) ;查看中心发消息时,只看自己提交的记录的
	.s PAMType=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),9)
	.q:(MsgType'="")&&(MsgType'=PAMType)
	.s IndexRead=1 
	.s TMPData("PAMRowID",IndexRead,AuditID)=""
	
	;当日的列表
	s StDate=+$h
	s EndDate=+$h
	f Date=StDate:1:EndDate d
	.s Time=0
	.f  s Time=$o(^PHA.PREADT.AuditI("Date",Date,Time)) q:Time=""  d
	..s AuditId=0
	..f  s AuditId=$o(^PHA.PREADT.AuditI("Date",Date,Time,AuditId)) q:AuditId=""  d
	...s HasUnRead=$d(^PHA.PREADT.AuditMsgI("PAMAuditReadFlag",AuditId," N"))
	...s PAUserId=$lg(^PHA.PREADT.AuditD(AuditId),11)
	...q:(MsgType="Audit")&&(LgUserID'=PAUserId) ;查看中心发消息时,只看自己提交的记录的
	...s IndexRead=2
	...s:HasUnRead IndexRead=1
	...s TMPData("PAMRowID",IndexRead,AuditId)=""
	
	s Count=0
	w "["
	s IndexRead=""
	f  s IndexRead=$o(TMPData("PAMRowID",IndexRead)) q:IndexRead=""  d
	.s AuditID=0
	.f  s AuditID=$o(TMPData("PAMRowID",IndexRead,AuditID)) q:AuditID=""  d
	..s Count=Count+1
	..w $case(Count,1:"",:",")
	..w ##class(web.DHCPRESCAuditPopup).JsonUnreadMessageNew(AuditID)
	w "]"
	
	q ""
}

/// w ##class(web.DHCPRESCAuditPopup).JsonUnreadMessageNew("1")
ClassMethod JsonUnreadMessageNew(AuditID)
{
	n (AuditID)
	
	s UnReadMesNumber = ##class(web.DHCPRESCAuditPopup).GetUnReadMessageNumber(AuditID)
	s DoctorCount=$p(UnReadMesNumber,"^",1)
	s AuditCount=$p(UnReadMesNumber,"^",2)
	
	s PARRowID=$o(^PHA.PREADT.AuditResultI("Parref",AuditID,""),-1)
	s AuditResultData=$g(^PHA.PREADT.AuditResultD(+PARRowID))
	s LastID=$lg(AuditResultData,9)
	s PAUserId=$lg(^PHA.PREADT.AuditD(AuditID),11)
	s PaAdmID=$lg(^PHA.PREADT.AuditD(AuditID),3)
	s PatientID=$lg(^PHA.PREADT.AuditD(AuditID),4)
	s PatName=$p(^PAPER(PatientID,"ALL"),"^",1) /// 姓名
	s PatNo=$p(^PAPER(PatientID,"PAT",1),"^",1) /// 登记号
	s SexId=$p(^PAPER(PatientID,"ALL"),"^",7)    /// 姓别
	s PatSex=$p($g(^CT("SEX",+SexId)),"^",2)
	s PatAge=##Class(web.DHCSTKUTIL).GetAge(PatientID)
	s Diag=##class(web.DHCSTKUTIL).GetMRDiagnosDesc(PaAdmID,",")	//诊断
	s PatLoc=""
	s PatLocID=$p(^PAADM(PaAdmID),"^",4) 		/// 就诊科室
	s:PatLocID'="" PatLoc=$p(^CTLOC(PatLocID),"^",2)
	s QueDoc=""
	s:PAUserId'="" QueDoc = $p($g(^SSU("SSUSR",+PAUserId)),"^",2)
	s PrescNo=$lg(^PHA.PREADT.AuditD(AuditID),15) ///处方号
	s UserID=$lg(AuditResultData,3)
	s User=$p($g(^SSU("SSUSR",+UserID)),"^",2)					///审核人
	s Date=$lg(AuditResultData,4)		///审核日期
	s:Date'="" Date=##Class(web.DHCEMCommonUtil).DateLogicalToHtml(Date)
	s Time=$lg(AuditResultData,5)		///审核时间
	s:Time'="" Time=$zt(Time,2)
	s StatusID=$lg(AuditResultData,6)
	s Status=$case(StatusID,1:"必须修改",2:"双签复核",3:"双签通过",4:"通过",:"") ///打回,医生双签,通过
	s ReasonID=$lg(AuditResultData,7)		///审核原因
	s Reason=""
	s:ReasonID'="" Reason = $lg(^CT.PHA.PREADT.DicItemD(ReasonID),3)
	s Remark=$lg(AuditResultData,8)		///原因备注
	s ListData=AuditID_"^"_PARRowID_"^"_PaAdmID_"^"_PatientID_"^"_PatName_"^"_PatNo_"^"_PatSex_"^"_PatAge_"^"_Diag_"^"_PatLoc_"^"_QueDoc_"^"_PrescNo_"^"_User_"^"_Date_"^"_Time
	s ListData=ListData_"^"_Status_"^"_Reason_"^"_Remark_"^"_DoctorCount_"^"_AuditCount
	s ListTitle="AuditID^PARRowID^PaAdmID^PatientID^PatName^PatNo^PatSex^PatAge^Diag^PatLoc^QueDoc^PrescNo^User^Date^Time^Status^Reason^Remark^DoctorCount^AuditCount"
	q ##class(web.DHCAPPJsonCommon).getJsonData(ListTitle,ListData)
}

/// 通过审方ID获取未读消息数量
/// Return:医生未读^药师未读
/// w ##class(web.DHCPRESCAuditPopup).GetUnReadMessageNumber("1")
ClassMethod GetUnReadMessageNumber(AuditID)
{
	
	s DoctorCount=0,AuditCount=0
	s PAMRowID=""
	f  s PAMRowID=$o(^PHA.PREADT.AuditMsgI("PAMAuditReadFlag",AuditID," N",PAMRowID)) q:PAMRowID=""  d
	.s Type=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),9)
	.s:Type="Doctor" DoctorCount=DoctorCount+1
	.s:Type="Audit" AuditCount=AuditCount+1
	q DoctorCount_"^"_AuditCount
}

/// Decript:对于医师是否是待审核状态
/// w ##class(web.DHCPRESCAuditPopup).DocIsPendStatus("158")
ClassMethod DocIsPendStatus(AuditID)
{
	n (AuditID)
	s Ret="N"
	s LastAuditRsID=$o(^PHA.PREADT.AuditResultI("Parref",AuditID,""),-1)	
	q:+LastAuditRsID=0 Ret
	;b ;11
	s AuditResultData=$g(^PHA.PREADT.AuditResultD(+LastAuditRsID))
	s LastID=$lg(AuditResultData,9)
	q:+LastID'=0 Ret
	s StatusID=$lg(AuditResultData,6)
	;b ;22
	s Status=$lg($g(^CT.PHA.PREADT.DicItemD(+StatusID)),3)
	s:Status["双签" Ret="Y" ;双签时待审核，其他是看一眼就行了
	;s:Status["通过" Ret="Y"
	;s:Status["必须修改" Ret="Y"
	q Ret
}

// w ##class(web.DHCPRESCAuditPopup).Test("1")

ClassMethod Test(Hours)
{
	s MDate=+$h
	s MTime=$p($h,",",2)
	s AllMTime=MTime+(Hours*3600)
	s Date=MDate+(AllMTime\3600\12)
	s Time=AllMTime#(3600*12)
	q $zd(Date,3)_" "_$zt(Time,1)
}

// w ##class(web.DHCPRESCAuditPopup).GetServerDate()

ClassMethod GetServerDate()
{
	q $zd(+$h,3)_" "_$zt($p($h,",",2),1)
}

/// Descript:判断消息的状态
/// w ##class(web.DHCPRESCAuditPopup).IsReadFlag("1")
ClassMethod IsReadFlag(auditId, userType)
{
	s msgId= ""
	s retFlag = 0
	for  s msgId = $o(^PHA.PREADT.AuditMsgI("PAMAudit",auditId,msgId))  Q:(msgId="")||(retFlag=1)  d
	.s type = $lg(^PHA.PREADT.AuditMsgD(msgId),9)
	.Q:type'=userType
	.s readFlag = $lg(^PHA.PREADT.AuditMsgD(msgId),8)
	.Q:readFlag'="Y"
	.s retFlag = 1
	Q retFlag
}

}
