Class web.DHCVISTest Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// w ##class(web.DHCVISTest).GetUTCTime()
ClassMethod XMLReader(InputStr As %String = "") As %String
{
    Set reader=##class(%XML.Reader).%New()
    Set sc=reader.OpenStream(retStr)
    Do reader.Correlate("HisUsers","User.DHCInterfaceHisUsers")
	While reader.Next(.person,.sc)
	{
	b
       s count=person.UserName
       w count
	}
	Do reader.Close()
}

/// cy20190125
/// 清除配置global
/// w ##class(web.DHCVISTest).KillDHCVISGlobal()
ClassMethod KillDHCVISGlobal(InputStr As %String = "") As %String
{
    // 客户端
    k ^DHCVISClient
    k ^DHCVISClienti
    // 服务器
    k ^DHCVISServer
    k ^DHCVISServeri
}

/// 清除业务的global
ClassMethod KillDHCVISSQLGlobal(InputStr As %String = "") As %String
{

   // DHC_VIS_VoieQueue
    k ^DHCVISQueue
    k ^DHCVISQueuei
    // DHC_VIS_DurgLedList
    k ^DHCVISDurgList
    k ^DHCVISDurgListi
    // DHC_VIS_RegQueue
    k ^DHCVISRegQueue
    k ^DHCVISRegQueuei
    // DHC_VIS_ReportQueue
    k ^DHCVISReportQueue
    k ^DHCVISReportQueuei
}

}
