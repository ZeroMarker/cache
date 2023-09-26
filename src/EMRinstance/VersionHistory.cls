Class EMRinstance.VersionHistory Extends %Persistent
{

/// Rule reference
Property TemplateDR As %String(TRUNCATE = 1);

Property ReasonDescription As %String(MAXLEN = 500, TRUNCATE = 1);

Property ContentDescription As %String(MAXLEN = 500, TRUNCATE = 1);

/// 最后保存版本
Property LastVersion As %Integer;

Property CreateDate As %Date;

Property CreateTime As %Time;

Index TemplateDR On TemplateDR;

Storage Default
{
<Data name="VersionHistoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateDR</Value>
</Value>
<Value name="3">
<Value>ReasonDescription</Value>
</Value>
<Value name="4">
<Value>ContentDescription</Value>
</Value>
<Value name="5">
<Value>LastVersion</Value>
</Value>
<Value name="6">
<Value>CreateDate</Value>
</Value>
<Value name="7">
<Value>CreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCEMRI.VersionHistoryD</DataLocation>
<DefaultData>VersionHistoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRI.VersionHistoryD</IdLocation>
<IndexLocation>^DHCEMRI.VersionHistoryI</IndexLocation>
<StreamLocation>^DHCEMRI.VersionHistoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
