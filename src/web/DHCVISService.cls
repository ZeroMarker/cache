/// web.DHCVISService
Class web.DHCVISService Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// Name of the WebService.
Parameter SERVICENAME = "DHCVISService";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "https://172.18.18.147:1443/imedical/webservice/";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// TODO: add arguments and implementation.
/// Test
ClassMethod Test() As %String [ WebMethod ]
{
	Quit "Test"
}

ClassMethod test1(testparm As %String = "") As %String [ WebMethod ]
{
	Quit "Test"
}

/*
<?xml version="1.0" encoding="gb2312"?> <!—版本,编码信息-->
<PatientInfo>
    	<WindowName>窗口诊室名称</WindowName>
    	<WindowIP>IP地址</WindowIP>
    	<WindowDoctor>技师</WindowDoctor>
    	<WindowNote>说明</WindowNote>
		<!—就诊患者--->
        <VisitingPatient> 
        	<Name>患者姓名</Name>
			<QueueNo>排队号</QueueNo>
			<RegisterNo>登记号</RegisterNo>
			<Department>就诊科室</Department>
		</VisitingPatient>
                    :     <!—多个就诊患者--->
		<VisitingPatient>
               <Name>患者姓名</Name>
               <QueueNo>排队号</QueueNo>
               <RegisterNo>登记号</RegisterNo>
               <Department>就诊科室</Department>
		</VisitingPatient>  
		<!—诊室门口候诊患者--->
        <WaitingPatient>
               <Name>患者姓名</Name>
               <QueueNo>排队号</QueueNo>
               <RegisterNo>登记号</RegisterNo>
               <Department>就诊科室</Department> 
          </WaitingPatient>
                         :     <!—多个患者--->
          <WaitingPatient>
               <Name>患者姓名</Name>
               <QueueNo>排队号</QueueNo>
               <RegisterNo>登记号</RegisterNo>
               <Department>就诊科室</Department>
          </WaitingPatient>
</PatientInfo>
*/
/// Parameter      PatientInfo
/// Return Value   0-成功,其他-相应错误提示
ClassMethod RisSendRegQueue(PatientInfo As %String = "") As %String [ WebMethod ]
{
	s Index=$I(^DHCVISRisTest(+$H,"RisSendRegQueue"))
	s ^DHCVISRisTest(+$H,"RisSendRegQueue",Index)=PatientInfo
	s Ret=##Class(web.DHCVISInterface).RisInsertRegQueue(PatientInfo)
	i Ret'="0" s ^DHCVISRisTest(+$H,"RisSendRegQueueErr",Index)=Ret
	q Ret
}

/// Parameter      PatientInfo
/// Return Value   0-成功,其他-相应错误提示
ClassMethod RisSendVoice(PatientInfo As %String = "") As %String [ WebMethod ]
{
	s PatientInfo=PatientInfo
	s Index=$I(^DHCVISRisTest(+$H,"RisSendVoice"))
	s ^DHCVISRisTest(+$H,"RisSendVoice",Index)=PatientInfo
	s Ret=##Class(web.DHCVISInterface).RisInsertVoiceQueue(PatientInfo)
	i Ret'="0" s ^DHCVISRisTest(+$H,"RisSendVoiceErr",Index)=Ret
	q Ret
}

/// 用于更新医技病人状态 W等候 S过号 F完成 C呼叫
/// 呼叫状态由我组更改"C"
ClassMethod RisUpdatePatStatus(PatientInfo As %String = "") As %String [ WebMethod ]
{
	s Index=$I(^DHCVISRisTest(+$H,"RisUpdatePatStatus"))
	s ^DHCVISRisTest(+$H,"RisUpdatePatStatus",Index)=PatientInfo
	s Ret=##Class(web.DHCVISInterface).UpdatePatStatus(PatientInfo)
	i Ret'="0" s ^DHCVISRisTest(+$H,"RisUpdatePatStatusErr",Index)=Ret
	q Ret
}

/// 病人报告状态用此接口,报告状态为 DHC_VIS_ReportQueue表 N为有报告可取  Y为已发报告 
/// Return Value   0-成功,其他-相应错误提示
ClassMethod RisSendReport(PatientInfo As %String = "") As %String [ WebMethod ]
{
	s PatientInfo=PatientInfo
	s Index=$I(^DHCVISRisTest(+$H,"RisSendReport"))
	s ^DHCVISRisTest(+$H,"RisSendReport",Index)=PatientInfo
	s Ret=##Class(web.DHCVISInterface).RisInsertReport(PatientInfo)
	i Ret'="0" s ^DHCVISRisTest(+$H,"RisSendReportErr",Index)=Ret
	q Ret
}

}
