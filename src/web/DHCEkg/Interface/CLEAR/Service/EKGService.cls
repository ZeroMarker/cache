/// web.DHCEkg.Interface.CLEAR.Service.EKGService
Class web.DHCEkg.Interface.CLEAR.Service.EKGService Extends %SOAP.WebService [ ProcedureBlock ]
{

/// WebService 的名称.
Parameter SERVICENAME = "EKGService";

/// TODO:将此更改为实际 SOAP namespace.
/// WebService 的 SOAP Namespace
Parameter NAMESPACE = "http://tempuri.org";

/// 引用类的 Namespace 将在 WSDL 中使用.
Parameter USECLASSNAMESPACES = 1;

/// create: yyl
/// create: 2017-11-09
/// modify: yyl
/// modify: 2017-11-29
/// desc:   获取心电报告
/// input: 
/// return: 
/// examination.ekgTechnicianUserId 0:无状态；1：已下载；2：已打印
/// w ##class(web.DHCEkg.Interface.CLEAR.Service.EKGService).GetEkgReportInfo("<Request><CardNo></CardNo><PatientID></PatientID><Name></Name><StaccnumNo>CT20161109015</StaccnumNo><ModalityType></ModalityType><StartTime>2017-11-28</StartTime><EndTime>2017-11-30</EndTime><PrintedDisplay></PrintedDisplay><ExecDept>心电图室</ExecDept></Request>")
ClassMethod GetEkgReportInfo(RequestInfo As %String) As %GlobalCharacterStream [ WebMethod ]
{
	s (CardNo,PatientID,Name,StaccnumNo,ModalityType,StartTime,EndTime,PrintedDisplay,ExecDept)=""
	s reader1=##class(%XML.Reader).%New()
	s sc1=reader1.OpenString(RequestInfo)
	d reader1.Correlate("Request","web.DHCEkg.Interface.CLEAR.Dict.GetReport")
	while reader1.Next(.obj,.sc)
	{
		b ;obj
		s CardNo=obj.CardNo
		s PatientID=obj.PatientID
		s Name=obj.Name
		s StaccnumNo=obj.StaccnumNo
		s ModalityType=obj.ModalityType
		s StartTime=obj.StartTime
		s EndTime=obj.EndTime
		s PrintedDisplay=obj.PrintedDisplay
		s ExecDept=obj.ExecDept
	}
	s ^tmpDHCEKG("CLEAR","GetEkgReportInfo",$zdt($h,3))=CardNo_","_PatientID_","_
		Name_","_StaccnumNo_","_ModalityType_","_StartTime_","_EndTime_","_
		PrintedDisplay_","_ExecDept
	s currentSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s rtn=##class(Interface.CLEAR.Service.EKGInterface).GetEkgReportInfo(CardNo,PatientID,Name,StaccnumNo,ModalityType,StartTime,EndTime,PrintedDisplay,ExecDept)
	zn currentSpace
	
	q rtn
}

/// create: yyl
/// create: 2017-11-29
/// desc:   置报告下载和打印状态
/// input:  医嘱号，标志(0:无状态；1：已下载；2：已打印)
/// return: 
/// examination.ekgTechnicianUserId 0:无状态；1：已下载；2：已打印
/// w ##class(web.DHCEkg.Interface.CLEAR.Service.EKGService).SetEKGPrtMark("","1")
ClassMethod SetEKGPrtMark(OrdRowID As %String, Tag As %Integer) As %String [ WebMethod ]
{
	q:(OrdRowID="") "医嘱号为空"
	s ^tmpDHCEKG("CLEAR","SetEkgRptPrt",OrdRowID,Tag)=$zdt($h,3)
	s currentSpace=$ZNSPACE
	d ##class(web.DHCEkgSystemParam).SetEKGNameSpace()
	s rtn=##class(Interface.CLEAR.Service.EKGInterface).SetEKGPrtMark(OrdRowID,Tag)
	zn currentSpace
	
	q rtn
}

}
