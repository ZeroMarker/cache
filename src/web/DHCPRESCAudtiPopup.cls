Import SQLUSER

/// Creator:     	qqa
/// CreateDate:   	2021-09-09
/// Descript:		获取待处理信息
Class web.DHCPRESCAudtiPopup Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCPRESCAudtiPopup).JsonListUnreadMessage("","")
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
	q 0
	//&sql(UPDATE PHA_PREADT.AuditResult SET PAR_ReadFlag="Y" WHERE PAR_RowID=:PARRowID)
	//q SQLCODE
}

/// w ##class(web.DHCPRESCAudtiPopup).JsonListUnreadMessage("","")
ClassMethod JsonListUnreadMessageNew(Params, LgParams)
{
	n (Params,LgParams)
	s LgUserID=$p(LgParams,"^",4)
	
	s PAMRowID=0
	f  s PAMRowID=$o(^PHA.PREADT.AuditMsgI("ReadFlag"," N",PAMRowID)) q:PAMRowID=""  d
	.s AuditID=$lg(^PHA.PREADT.AuditMsgD(PAMRowID),2)
	.q:+AuditID=0
	.s PAUserId=$lg(^PHA.PREADT.AuditD(AuditID),11)
	.;q:LgUserID'=PAUserId
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

// w ##class(web.DHCPRESCAudtiPopup).Test("1")

ClassMethod Test(Hours)
{
	s MDate=+$h
	s MTime=$p($h,",",2)
	s AllMTime=MTime+(Hours*3600)
	s Date=MDate+(AllMTime\3600\12)
	s Time=AllMTime#(3600*12)
	q $zd(Date,3)_" "_$zt(Time,1)
}

}
