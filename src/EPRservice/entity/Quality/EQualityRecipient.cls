Class EPRservice.entity.Quality.EQualityRecipient Extends (%RegisteredObject, %XML.Adaptor) [ ClassType = "", Inheritance = right, ProcedureBlock ]
{

Property ID As %String(TRUNCATE = 1);

Property EpisodeID As %String(TRUNCATE = 1);

Property MessageDR As %String(TRUNCATE = 1);

Property ReadDate As %Date;

Property ReadTime As %Time;

Property ReadUserDR As %String(TRUNCATE = 1);

Storage Default
{
<Data name="EQualityRecipientDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>ID</Value>
</Value>
<Value name="4">
<Value>MessageDR</Value>
</Value>
<Value name="5">
<Value>ReadDate</Value>
</Value>
<Value name="6">
<Value>ReadTime</Value>
</Value>
<Value name="7">
<Value>ReadUserDR</Value>
</Value>
</Data>
<DataLocation>^EPRservice9BA.EQualityReci6D1D</DataLocation>
<DefaultData>EQualityRecipientDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^EPRservice9BA.EQualityReci6D1D</IdLocation>
<IndexLocation>^EPRservice9BA.EQualityReci6D1I</IndexLocation>
<StreamLocation>^EPRservice9BA.EQualityReci6D1S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
