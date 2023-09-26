/// 手写签名
Class EPRinstance.HandWrittenSign Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property EpisodeID As %String(TRUNCATE = 1);

Property PrintDocID As %String(TRUNCATE = 1);

Property EPRNum As %String(TRUNCATE = 1);

/// PDF的文件名
Property FileName As %String(TRUNCATE = 1);

/// PDF在FTP上全路径
Property FilePath As %String(MAXLEN = 200, TRUNCATE = 1);

Property CreateDate As %Date;

Property CreateTime As %Time;

Property IsValid As %Boolean;

Index Idx On (EpisodeID, PrintDocID, EPRNum);

Storage Default
{
<Data name="HandWrittenSignDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CreateDate</Value>
</Value>
<Value name="3">
<Value>CreateTime</Value>
</Value>
<Value name="4">
<Value>EPRNum</Value>
</Value>
<Value name="5">
<Value>EpisodeID</Value>
</Value>
<Value name="6">
<Value>InsIDs</Value>
</Value>
<Value name="7">
<Value>IsValid</Value>
</Value>
<Value name="8">
<Value>PrintDocID</Value>
</Value>
<Value name="9">
<Value>FileName</Value>
</Value>
<Value name="10">
<Value>FilePath</Value>
</Value>
</Data>
<DataLocation>^DHCEPRI.HandWrittenSignD</DataLocation>
<DefaultData>HandWrittenSignDefaultData</DefaultData>
<IdLocation>^DHCEPRI.HandWrittenSignD</IdLocation>
<IndexLocation>^DHCEPRI.HandWrittenSignI</IndexLocation>
<StreamLocation>^DHCEPRI.HandWrittenSignS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
