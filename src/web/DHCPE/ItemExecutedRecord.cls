Class web.DHCPE.ItemExecutedRecord Extends (%RegisteredObject, %XML.Adaptor)
{

/// 插入一个项目
/// Type: E 执行 D 撤销   OperType：PE 体检执行
ClassMethod Insert(OEID, Type, OperType, UserID, Date As %String = "", Time As %String = "")
{
	s $ZT="ExecutedRecordInsertErr"
	s:Date="" Date=+$H
	s:Time="" Time=$P($H,",",2)
	i UserID="" s UserID=%session.Get("LOGON.USERID")
	&SQL(insert into Sqluser.DHC_PE_ItemExecutedRecord (IER_OEORI_DR,IER_Type,IER_Oper_Type,IER_Date,IER_Time,IER_User_DR) values (:OEID,:Type,:OperType,:Date,:Time,:UserID))
	i SQLCODE'=0 d
	.s ^DHCPEDateEx("ItemExecutedRecord","Err",OEID,Type,OperType)=UserID_"^"_$H
	q SQLCODE
ExecutedRecordInsertErr
	q 0
}

/// 自动插入执行记录
/// d ##class(web.DHCPE.ItemExecutedRecord).AutoInsertIER("2019-01-01","2019-11-15")
ClassMethod AutoInsertIER(BeginDate As %String = "", EndDate As %String = "")
{
	s ^DHCPESetting("Statistic","Ris")="Y"
	s ^DHCPESetting("Statistic","Lis")="Y"
	//普通检查项目
	s SttDate=$tr(BeginDate,"-"),SttEndDate=$tr(EndDate,"-")
	s:BeginDate'="" BeginDate=##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	s:EndDate'="" EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s:BeginDate="" BeginDate=+$H-1
	s:EndDate="" EndDate=+$H-1
	
	//体检部门项目
	f Date=BeginDate:1:EndDate d
	.s OEORD=""
	.f  s OEORD=$o(^DHCPERLT("0","DateOrder",Date,OEORD)) q:OEORD=""  d
	..s RLTID=""
	..s RLTRowID=0
	..f  s RLTRowID=$o(^DHCPERLT("0","DateOrder",Date,OEORD,RLTRowID)) q:(RLTRowID="")||(RLTID'="")  d
	...q:'$D(^DHCPERLT(RLTRowID))
	...s ShowSort=$p(^DHCPERLT(RLTRowID),"^",14)
	...q:ShowSort=""
	...s RLTID=RLTRowID
	..q:RLTID=""
	..s ARCIM=$p(^DHCPERLT(RLTID),"^",2)
	..s Station=$o(^DHCPEST(0,"STORD_ARCIM",ARCIM,0))
	..Q:($G(^DHCPESetting("DHCPE","StationId_Lab"))=Station)					// 检验科室
	..Q:(("^"_^DHCPESetting("DHCPE","StationId_Ris")_"^")[("^"_Station_"^"))	// 检查科室
	..s UserID=$p(^DHCPERLT(RLTID),"^",5)
	..s Date=$p(^DHCPERLT(RLTID),"^",6)
	..s Time=$p(^DHCPERLT(RLTID),"^",11)
	..d ..Insert(OEORD, "E", "PE", UserID, Date, Time)
	
	//检查项目(报告医生) DHCRB_REPORT,DHCRB_REGINFO
	f Date=BeginDate:1:EndDate d
	.s DRPTRowID=""
	.f  s DRPTRowID=$o(^DHCRBStudyi("ReportDate",Date,DRPTRowID)) q:DRPTRowID=""  d
	..s PAADM=$p(^DHCRBStudy("Report",DRPTRowID),"^",16)
	..s PatType=$p(^PAADM(PAADM),"^",2)
	..q:PatType'="H"
	..s RPTStatus=$p(^DHCRBStudy("Report",DRPTRowID),"^",4)
	..q:RPTStatus'="5"
	..s UserID=$p(^DHCRBStudy("Report",DRPTRowID),"^",8)
	..s RPTTime=$p(^DHCRBStudy("Report",DRPTRowID),"^",10)
	..s DRPTStudyNo=$p(^DHCRBStudy("Report",DRPTRowID),"^",1)
	..s RARRowID=""
	..f  s RARRowID=$o(^DHCPACRegInfoi("StudyNo",DRPTStudyNo,RARRowID)) q:RARRowID=""  d
	...s OEORD=$p(^DHCPACRegInfo(RARRowID),"^",11)
	...d ..Insert(OEORD, "E", "RISR", UserID, Date, RPTTime)
	
	//检查项目(审核医生)  DHCRB_REPORT,DHCRB_REGINFO
	f Date=(BeginDate-7):1:(EndDate-7) d
	.s DRPTRowID=""
	.f  s DRPTRowID=$o(^DHCRBStudyi("ReportDate",Date,DRPTRowID)) q:DRPTRowID=""  d
	..s PAADM=$p(^DHCRBStudy("Report",DRPTRowID),"^",16)
	..s PatType=$p(^PAADM(PAADM),"^",2)
	..q:PatType'="H"
	..s RPTStatus=$p(^DHCRBStudy("Report",DRPTRowID),"^",4)
	..q:RPTStatus'="5"
	..s VUserID=$p(^DHCRBStudy("Report",DRPTRowID),"^",11)
	..q:VUserID=""
	..s VDate=$p(^DHCRBStudy("Report",DRPTRowID),"^",12)
	..s VTime=$p(^DHCRBStudy("Report",DRPTRowID),"^",13)
	..s DRPTStudyNo=$p(^DHCRBStudy("Report",DRPTRowID),"^",1)
	..s RARRowID=""
	..f  s RARRowID=$o(^DHCPACRegInfoi("StudyNo",DRPTStudyNo,RARRowID)) q:RARRowID=""  d
	...s OEORD=$p(^DHCPACRegInfo(RARRowID),"^",11)
	...d ..Insert(OEORD, "E", "RISV", VUserID, VDate, VTime)
	
	//检验项目(核收医生) RP_VisitNumberReport,RP_VisitNumber
	s BeginDate=##class(websys.Conversions).DateLogicalToHtml(BeginDate)
	s EndDate=##class(websys.Conversions).DateLogicalToHtml(EndDate)
	s SttDate=$tr(BeginDate,"-"),SttEndDate=$tr(EndDate,"-")
	s WorkGroupDR="" f  s WorkGroupDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR)) q:WorkGroupDR=""  d
	.s tCode="" f  s tCode=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,tCode)) q:tCode=""  d
	..s WorkGPMiDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,tCode,""))
	..s Date=$o(^dbo.RPVisitNumberReportI("IndexAcceptDate",WorkGPMiDR,SttDate),-1)
	..f  s Date=$o(^dbo.RPVisitNumberReportI("IndexAcceptDate",WorkGPMiDR,Date)) q:(Date="")||($l(SttEndDate)&&(Date>SttEndDate))  d
	...s AssayNo="" f  s AssayNo=$o(^dbo.RPVisitNumberReportI("IndexAcceptDate",WorkGPMiDR,Date,AssayNo)) q:AssayNo=""  d
	....s ReportDR="" f  s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexAcceptDate",WorkGPMiDR,Date,AssayNo,ReportDR)) q:ReportDR=""  d
	.....s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),2)
	.....s VisitNumberData = $g(^dbo.RPVisitNumberD(VisitNumberDR))
	.....s Status=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)
	.....q:Status'="3"
	.....s AcceptTime=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),10)
	.....s AcceptTime=##Class(LIS.Util.Common).FormatTime(AcceptTime)
	.....s AcceptTime=##class(websys.Conversions).TimeHtmlToLogical(AcceptTime)
	.....s AcceptDate=##Class(LIS.Util.Common).FormatDate(SttDate)
	.....s AcceptDate=##class(websys.Conversions).DateHtmlToLogical(AcceptDate)
	.....s AcceptUserDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),11)
	.....s UserID=""
	.....i AcceptUserDR'="" d
	......s AcceptUser=$lg($g(^dbo.SYSUserD(AcceptUserDR)),3)
	......s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",AcceptUser,0))
	.....s Labno=$lg(VisitNumberData,2)
	.....s OEORD=""
	.....f  s OEORD=$o(^OEORD(0,"EpisNo",Labno,OEORD)) q:OEORD=""  d
	......s PAADM=$p(^OEORD(OEORD),"^",1)
	......s PatType=$p(^PAADM(PAADM),"^",2)
	......q:PatType'="H"
	......s OEORDSub=0
	......f  s OEORDSub=$o(^OEORD(0,"EpisNo",Labno,OEORD,OEORDSub)) q:OEORDSub=""  d
	.......s OEOrdItem=OEORD_"||"_OEORDSub
	.......d ..Insert(OEOrdItem, "E", "LISAcc", UserID, AcceptDate, AcceptTime)
	
	//检验项目(审核医生) RP_VisitNumberReport,RP_VisitNumber
	s WorkGroupDR="" f  s WorkGroupDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR)) q:WorkGroupDR=""  d
	.s tCode="" f  s tCode=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,tCode)) q:tCode=""  d
	..s WorkGPMiDR=$o(^dbo.BTWorkGroupMachineI("IndexCode",WorkGroupDR,tCode,""))
	..s Date=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",WorkGPMiDR,SttDate),-1)
	..f  s Date=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",WorkGPMiDR,Date)) q:(Date="")||($l(SttEndDate)&&(Date>SttEndDate))  d
	...s ReportDR="" f  s ReportDR=$o(^dbo.RPVisitNumberReportI("IndexAuthDate",WorkGPMiDR,Date,ReportDR)) q:ReportDR=""  d
	....s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),2)
	....s VisitNumberData = $g(^dbo.RPVisitNumberD(VisitNumberDR))
	....s Status=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),22)
	....q:Status'="3"
	....s AuthTime=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),20)
	....s AuthTime=##Class(LIS.Util.Common).FormatTime(AuthTime)
	....s AuthTime=##class(websys.Conversions).TimeHtmlToLogical(AuthTime)
	....s AuthDate=##Class(LIS.Util.Common).FormatDate(SttDate)
	....s AuthDate=##class(websys.Conversions).DateHtmlToLogical(AuthDate)
	....s AuthUserDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),21)
	....s UserID=""
	....i AuthUserDR'="" d
	.....s AuthUserDR=$lg($g(^dbo.SYSUserD(AuthUserDR)),3)
	.....s UserID=$o(^SSU("SSUSR",0,"SSUSR_Initials",AuthUserDR,0))
	....s Labno=$lg(VisitNumberData,2)
	....s OEORD=""
	....f  s OEORD=$o(^OEORD(0,"EpisNo",Labno,OEORD)) q:OEORD=""  d
	.....s PAADM=$p(^OEORD(OEORD),"^",1)
	.....s PatType=$p(^PAADM(PAADM),"^",2)
	.....q:PatType'="H"
	.....s OEORDSub=0
	.....f  s OEORDSub=$o(^OEORD(0,"EpisNo",Labno,OEORD,OEORDSub)) q:OEORDSub=""  d
	......s OEOrdItem=OEORD_"||"_OEORDSub
	......d ..Insert(OEOrdItem, "E", "LISAu", UserID, AuthDate, AuthTime)
	
	q 0
}

}
