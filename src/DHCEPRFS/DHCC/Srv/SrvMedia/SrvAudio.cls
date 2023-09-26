Class DHCEPRFS.DHCC.Srv.SrvMedia.SrvAudio Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/epr/dhceprfsservice";

/// Name of the WebService.
Parameter SERVICENAME = "SrvAudio";

ClassMethod GetFTPPath(AEpisodeID As %String) As %String [ WebMethod ]
{
	s ret = ##Class(DHCEPRFS.BL.HISInfo.BLMediaInfo).GetAudioFTPPath(AEpisodeID)
	q ret
}

Storage Default
{
<Data name="SrvAudioDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.DHCC.Srv2EBE.SrvAudioD</DataLocation>
<DefaultData>SrvAudioDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.DHCC.Srv2EBE.SrvAudioD</IdLocation>
<IndexLocation>^DHCEPRFS.DHCC.Srv2EBE.SrvAudioI</IndexLocation>
<StreamLocation>^DHCEPRFS.DHCC.Srv2EBE.SrvAudioS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
