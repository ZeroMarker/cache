Class DHCEPRFS.DHCC.Srv.SrvMedia.SrvPIC Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvPIC";

ClassMethod GetFTPPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).GetPICFTPPath(AEpisodeID)
	q ret
}

Storage Default
{
<Data name="SrvPICDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.DHCC.Srv.S2EBE.SrvPICD</DataLocation>
<DefaultData>SrvPICDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.DHCC.Srv.S2EBE.SrvPICD</IdLocation>
<IndexLocation>^DHCEPRFS.DHCC.Srv.S2EBE.SrvPICI</IndexLocation>
<StreamLocation>^DHCEPRFS.DHCC.Srv.S2EBE.SrvPICS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
