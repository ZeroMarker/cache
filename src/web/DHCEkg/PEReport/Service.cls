/// web.DHCEkg.PEReport.Service
Class web.DHCEkg.PEReport.Service Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "Service";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// Creator：		yangyali
/// CreatDate：		2020-7-8
/// Modify:			yangyali
/// ModifyDate：	2020-7-8
/// Description:	向体检回传报告
/// Input：			医嘱号，报告医生工号，审核医生工号，临床诊断，检查所见，检查结果，是否正常(1:正常  0:异常)
/// Return：		调用体检接口的结果
Method UpdatePEResult(OEORIID, ReportUser, AuditUser, ClinicInfo, ExamDesc, ExamResult, NormalState) As %String [ WebMethod ]
{
	s ^tmpDHCEKG("Log","web.DHCEkg.PEReport.Service","UpdatePEResult",OEORIID,"param")=OEORIID_"^"_ReportUser_"^"_AuditUser_"^"_ClinicInfo_"^"_ExamDesc_"^"_ExamResult_"^"_NormalState
	s rtn= ##class(web.DHCPE.CRM.Gateway).UpdatePEResult(OEORIID, ReportUser, AuditUser, ClinicInfo, ExamDesc, ExamResult, NormalState)
	s ^tmpDHCEKG("Log","web.DHCEkg.PEReport.Service","UpdatePEResult",OEORIID,"rtn")=rtn
	q rtn
}

}
