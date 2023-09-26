Class EMRservice.BOFTPImageTool Extends %SOAP.WebService [ ClassType = "", Not ProcedureBlock ]
{

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/emr/metaservice";

/// Name of the WebService.
Parameter SERVICENAME = "FRPImageToolInfo";

/// Desc:    出院日期 根据类型取出出院日期
/// InPut:   argEpisodeID 就诊日期
///          argType 出院日期类型 "ByDoctor"医生医疗结算，"ByNurse"护士最终结算
/// Output： result "" 没出院,YYYY-MM-DD出院日期格式
/// Debug: w ##Class(EMRservice.BOFTPImageTool).GetDisDate(57)
ClassMethod GetDisDate(argEpisodeID As %String) As %String [ WebMethod ]
{
	s result = ""
	q:((argEpisodeID = "")) result
	q:(($d(^PAADM(argEpisodeID)) '= 1)&&($d(^PAADM(argEpisodeID)) '= 11)) result
	s dischgdate = ""
	//护士最终结算
	//if (argType = "ByNurse")
	//{
		s dischgdate = $P($G(^PAADM(argEpisodeID)),"^",17)
	//}
	//医生医疗结算
	//elseif (argType = "ByDoctor")
	//{
	//	s dischgdate = $P($G(^PAADM(argEpisodeID)),"^",59)
	//}
	s:(dischgdate '= "") result = $zd(dischgdate,3)
	q result
}

}
