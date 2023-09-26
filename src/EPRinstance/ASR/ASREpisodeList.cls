Class EPRinstance.ASR.ASREpisodeList Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

Property EpisodeID As %String(TRUNCATE = 1);

/// PDF在FTP上全路径
Property FilePath As %String(MAXLEN = 200, TRUNCATE = 1);

Property FileName As %String(MAXLEN = 200, TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property Recognized As %Boolean;

Property ResultText As %GlobalCharacterStream(LOCATION = "^DHCEPRI.ASREpisodeListS");

Property AliasName As %String(MAXLEN = 200, TRUNCATE = 1);

Index Idx On EpisodeID;

Index IdxFileName On (EpisodeID, FileName);

ClassMethod GetResultText(AEpisodeID As %String, FileName As %String) As %GlobalCharacterStream
{
	s OID = $O(^DHCEPRI.ASREpisodeListI("IdxFileName", " "_AEpisodeID, " "_$ZCVT(FileName,"U"),""))
	b
	s foojb = ##Class(EPRinstance.ASR.ASREpisodeList).%OpenId(OID)
	q foojb.ResultText
}

Storage Default
{
<Data name="ASREpisodeListDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>FilePath</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>Recognized</Value>
</Value>
<Value name="7">
<Value>ResultText</Value>
</Value>
<Value name="8">
<Value>FileName</Value>
</Value>
<Value name="9">
<Value>AliasName</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.ASREpisodeListD</DataLocation>
<DefaultData>ASREpisodeListDefaultData</DefaultData>
<IdLocation>^DHCEPRI.ASREpisodeListD</IdLocation>
<IndexLocation>^DHCEPRI.ASREpisodeListI</IndexLocation>
<StreamLocation>^DHCEPRI.ASREpisodeListS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
