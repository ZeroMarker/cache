Class DHCEPRFS.BL.HISInfo.BLCheckInfo Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Desc: 整合检查的校验数据
///       检查接口格式: 医嘱号^医嘱名称^医嘱大类^检查号^回传报告标志("Y"or"N"),以"!"分隔
/// Output: 医嘱号^医嘱名称^回传报告标志("1"or"0"),以"!"分隔
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).GetRISReport("588")
ClassMethod GetRISReport(AEpisodeID As %String) As %String
{
	s reportInfo = ##class(web.DHCEPRcheckreport).CheckRisReport(AEpisodeID)
	q:(reportInfo = "") "0"
	s ret = ""
	f i=2:1:$l(reportInfo,"!")
	{
		s itemInfo = $p(reportInfo,"!",i)
		s orderID = $p(itemInfo,"^",1)
		s orderDesc = $p(itemInfo,"^",2)
		s itemStatus = $p(itemInfo,"^",5)
		s result = "0"
		s:(itemStatus = "Y") result = "1"
		if (ret = "")
		{
			s ret = orderID_"^"_orderDesc_"^"_result
		}
		else
		{
			s ret = ret_"!"_orderID_"^"_orderDesc_"^"_result
		}
	}
	q ret
}

/// Desc: 整合检验的校验数据
///       检验接口格式: 医嘱号^医嘱名称^医嘱大类^检验号^回传报告标志("Y"or"N"),以"!"分隔
/// Output: 医嘱号^医嘱名称^回传报告标志("1"or"0"),以"!"分隔
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).GetLISReport("588")
ClassMethod GetLISReport(AEpisodeID As %String) As %String
{
	s reportInfo = ##class(web.DHCEPRcheckreport).CheckLisReport(AEpisodeID)
	q:(reportInfo = "") "0"
	s ret = ""
	f i=2:1:$l(reportInfo,"!")
	{
		s itemInfo = $p(reportInfo,"!",i)
		s orderID = $p(itemInfo,"^",1)
		s orderDesc = $p(itemInfo,"^",2)
		s itemStatus = $p(itemInfo,"^",5)
		s result = "0"
		s:(itemStatus = "Y") result = "1"
		if (ret = "")
		{
			s ret = orderID_"^"_orderDesc_"^"_result
		}
		else
		{
			s ret = ret_"!"_orderID_"^"_orderDesc_"^"_result
		}
	}
	q ret
}

/// Desc: 整合电生理的校验数据
///       电生理接口格式: 医嘱号^医嘱名称^医嘱大类^回传报告标志("Y"or"N"),以"!"分隔
/// Output: 医嘱号^医嘱名称^回传报告标志("1"or"0"),以"!"分隔
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).GetEKGReport("588")
ClassMethod GetEKGReport(AEpisodeID As %String) As %String
{
	s reportInfo = ##class(web.DHCEPRcheckreport).CheckEKGReport(AEpisodeID)
	q:(reportInfo = "") "0"
	s ret = ""
	f i=2:1:$l(reportInfo,"!")
	{
		s itemInfo = $p(reportInfo,"!",i)
		s orderID = $p(itemInfo,"^",1)
		s orderDesc = $p(itemInfo,"^",2)
		s itemStatus = $p(itemInfo,"^",4)
		s result = "0"
		s:(itemStatus = "Y") result = "1"
		if (ret = "")
		{
			s ret = orderID_"^"_orderDesc_"^"_result
		}
		else
		{
			s ret = ret_"!"_orderID_"^"_orderDesc_"^"_result
		}
	}
	q ret
}

/// Desc: 整合病理的校验数据
///       病理接口格式: 医嘱号^医嘱名称^病理号^病理报告名称^是否回传标志("Y"or"N"),以"!"分隔
/// Output: 医嘱号^医嘱名称^回传报告标志("1"or"0"),以"!"分隔
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).GetPISReport("588")
ClassMethod GetPISReport(AEpisodeID As %String) As %String
{
	s reportInfo = ##class(web.DHCEPRcheckreport).CheckPISReport(AEpisodeID)
	q:(reportInfo = "") "0"
	s ret = ""
	f i=2:1:$l(reportInfo,"!")
	{
		s itemInfo = $p(reportInfo,"!",i)
		s orderID = $p(itemInfo,"^",1)
		s orderDesc = $p(itemInfo,"^",2)
		s itemStatus = $p(itemInfo,"^",5)
		s result = "0"
		s:(itemStatus = "Y") result = "1"
		if (ret = "")
		{
			s ret = orderID_"^"_orderDesc_"^"_result
		}
		else
		{
			s ret = ret_"!"_orderID_"^"_orderDesc_"^"_result
		}
	}
	q ret
}

/// Desc: 是否有手术
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).HasOperation("")
ClassMethod HasOperation(AEpisodeID As %String) As %String
{
	s operationInfo = ##class(web.DHCEPRcheckreport).CheckOperation(AEpisodeID)
	q:(operationInfo '= "") "1"
	q "0"
}

/// Desc: 是否为全麻手术
///       手术接口格式: 手术id^手术状态^术前诊断^手术名称^麻醉类型
/// Debug: w ##class(DHCEPRFS.BL.HISInfo.BLCheckInfo).HasGeneralAN("588")
ClassMethod HasGeneralAN(AEpisodeID As %String) As %String
{
	s operationInfo = ##class(web.DHCEPRcheckreport).CheckOperation(AEpisodeID)
	q:(operationInfo = "") "N"
	s retStr = "N"
	f i=2:1:$l(operationInfo,"!")
	{
		s itemInfo = $p(operationInfo,"!",i)
		s anDesc = $p(itemInfo,"^",5)
		s:(anDesc = "全麻") retStr = "Y"
	}
	q retStr
}

}
