Class web.PilotProject.PPA.DHCDocPilotProPat Extends (%RegisteredObject, %XML.Adaptor, DHCCPM.BLL.DHCXMLReader) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// PPP_Papmi_Dr
Property EpisodeID As %Library.String(TRUNCATE = 1);

/// PPP_Papmi_Dr
Property PatientID As %Library.String(TRUNCATE = 1);

/// PPP_VisitStatus
Property PPPVisitStatus As %Library.String(TRUNCATE = 1);

/// PPP_CreateDepartment_Dr
Property PPPCreateDepartmentDr As %Library.String(TRUNCATE = 1);

/// PPP_CreateUser_Dr
Property PPPCreateUserDr As %Library.String(TRUNCATE = 1);

/// PPP_PatientLimit
Property PPPPatientLimit As %Library.String(TRUNCATE = 1);

/// PPP_ReMark
Property PPPReMark As %Library.String(TRUNCATE = 1);

/// 合同单位
Property HealthCareProviderDr As %Library.String(TRUNCATE = 1);

/// 签署知情同意书日期
Property AgreementDate As %Library.String(TRUNCATE = 1);

/// 病人退出日期
Property ExitDate As %Library.String(TRUNCATE = 1);

/// 病人筛选号
Property ScreenNo As %Library.String(TRUNCATE = 1);

/// 住院全部科研费用
Property AllFreeFlag As %Library.String(TRUNCATE = 1);

}
