Class DHCLIS.DHCReportControl Extends %RegisteredObject
{

/// Creator：      liuzf
/// CreatDate：    20160115
/// Description:： 增加阅读结果记录
/// Table：       
/// Input：        就诊号
/// Output：       
/// Return：       其它:失败,1:成功
/// Others
/// w ##Class(DHCLIS.DHCReportControl).AddViewLog("462","189633","","157222||143,157222||144")
ClassMethod AddViewLog(UserId As %String, VisitNumberReportDRs As %String, HospID As %String, OrderIDs As %String) As %String
{
	s UserId=$g(UserId),VisitNumberReportDRs=$g(VisitNumberReportDRs),HospID=$g(HospID),OrderIDs=$g(OrderIDs)
	s RetValue=100
	S userCode=""
	I $L(UserId) {
		S userCode=$P($G(^SSU("SSUSR",UserId)),"^",1)
		S userName=$P($G(^SSU("SSUSR",UserId)),"^",2)
		//更新检验阅读日志 
		i $l(VisitNumberReportDRs)
		{
			s i =1
			for {
				s ReportDR = $p(VisitNumberReportDRs,",",i)
				i $l(ReportDR,"||")=2 s ReportDR=$p(ReportDR,"||",2)
				s OrderID = $p(OrderIDs,",",i)
				q:ReportDR=""
				q:i>$l(VisitNumberReportDRs,",")
				
				s i =i+1
				s HospCode=""
				i $l(HospID) s HospCode=$p($g(^CT("HOSP",HospID)),"^",1)
				//随便取个医院
				i '$l(HospCode) s HospCode=$o(^dbo.BTHospitalI("IndexCode",""))
				s DoctorDR=##Class(DHCLIS.DHCCommon).GetDoctorDR(userCode, userName, HospCode)
				//已阅读
				//i $d(^dbo.RPVisitNumberReportReadI("IndexReadDoctor",VisitNumberReportDR,DoctorDR)) s RetValue=1 q RetValue
				///RP_VisitNumberReport 首次阅读记录
				s objReport=##Class(dbo.RPVisitNumberReport).%OpenId(ReportDR)
				s Readed=objReport.Readed
				i (Readed'=1) 
				{
					s objReport.Readed=1
					s objReport.FirstReadDate=$tr($zd(+$h,3),"-")
					s objReport.FirstReadTime=$p($h,",",2)
					s objReport.FirstReadDoctorDR=DoctorDR
					s RetValue=objReport.%Save()
					i RetValue'=1 s RetValue=-1 q 
				}
				s HospCode=""
		 		s objRead=##Class(dbo.RPVisitNumberReportRead).%New()
				s objRead.VisitNumberReportDR=ReportDR
				s objRead.ReadDate=$tr($zd(+$h,3),"-")
				s objRead.ReadTime=$p($h,",",2)
				s objRead.ReadDoctorDR=DoctorDR
				s objRead.ReadNotes=""
				s RetValue=objRead.%Save()
				
				//往Portal更新阅读日志信息,liuzf,20190128
				s VisitNumberDR=$lg($g(^dbo.RPVisitNumberReportD(ReportDR)),2)
				s Labno=$lg($g(^dbo.RPVisitNumberD(VisitNumberDR)),2)
				s param=OrderID_"^"_Labno_"^"_"^"_UserId
				//i $l(OrderID) s ret=##class(web.DHCAPPInterface).ClinicRecordSet("R",param)
				//i $l(OrderID) D ##Class(web.DHCLabPortal).ReadingLog(OrderID,userCode)
			}
			
		}	
	}
	Quit RetValue
}

/// 1已读 
/// w ##class(DHCLIS.DHCReportControl).ReportViewLog("189633","462","")
ClassMethod ReportViewLog(VisitNumberReportDR As %String, UserId As %String, HospID As %String) As %String
{
	s UserId=$g(UserId),VisitNumberReportDR=$g(VisitNumberReportDR),HospID=$g(HospID),OrderID=$g(OrderID)
	s RetValue=100
	i '$l(VisitNumberReportDR) q 100
	i '$l(UserId) q 100
	S userCode=$P($G(^SSU("SSUSR",UserId)),"^",1)
	S userName=$P($G(^SSU("SSUSR",UserId)),"^",2)
	i '$l(userCode) q 100
	s HospCode=""
	i $l(HospID) s HospCode=$p($g(^CT("HOSP",HospID)),"^",1)
	//随便取个医院
	i '$l(HospCode) s HospCode=$o(^dbo.BTHospitalI("IndexCode",""))
	s DoctorDR=""
	i $l(HospCode) s DoctorDR=##Class(DHCLIS.DHCCommon).GetDoctorDR(userCode, userName, HospCode)
	i $l(DoctorDR),$d(^dbo.RPVisitNumberReportReadI("IndexReadDoctor",VisitNumberReportDR,DoctorDR)) 
	{
		s RetValue=1 
		
		//判断报告是否重审过，如果重审过，需要判断之前的阅读记录
		s ReportData = $g(^dbo.RPVisitNumberReportD(VisitNumberReportDR))
		s AuthDate = $lg(ReportData,19)
		s AuthTime = $lg(ReportData,20)
		i $l(AuthDate),$l(AuthTime) {
			s ReadDate=""
			s ReadDate = $o(^dbo.RPVisitNumberReportReadI("IndexMaster",VisitNumberReportDR,""),-1)
			i $l(ReadDate) {
				s ReadTime = $o(^dbo.RPVisitNumberReportReadI("IndexMaster",VisitNumberReportDR,ReadDate,""),-1)
				i (AuthDate=ReadDate),(AuthTime>ReadTime) s RetValue=0
				i (AuthDate>ReadDate) s RetValue=0
			}	
		}	
	}
	q RetValue
}

}
