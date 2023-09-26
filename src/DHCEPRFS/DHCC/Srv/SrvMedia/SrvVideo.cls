Class DHCEPRFS.DHCC.Srv.SrvMedia.SrvVideo Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvVideo";

ClassMethod GetFTPPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).GetVideoFTPPath(AEpisodeID)
	q ret
}

Storage Default
{
<Data name="SrvVideoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.DHCC.Srv2EBE.SrvVideoD</DataLocation>
<DefaultData>SrvVideoDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.DHCC.Srv2EBE.SrvVideoD</IdLocation>
<IndexLocation>^DHCEPRFS.DHCC.Srv2EBE.SrvVideoI</IndexLocation>
<StreamLocation>^DHCEPRFS.DHCC.Srv2EBE.SrvVideoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
