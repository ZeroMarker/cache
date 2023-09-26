Class EMRmeta.SubjectEPRInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property SubjectType As %String(TRUNCATE = 1);

Property SubjectEvent As %String(TRUNCATE = 1);

Property EPRTemplateID As %String(TRUNCATE = 1);

Property EPRTemplateDesc As %String(TRUNCATE = 1);

Property EPRItemCode As %String(MAXLEN = 500, TRUNCATE = 1);

Property EPRItemDesc As %String(TRUNCATE = 1);

/// 界面模板I单元的代码列是否为码表的RowID
Property ValueCodeIsRowID As %Boolean;

Index IdxMain On (SubjectType, SubjectEvent, EPRTemplateID, EPRItemCode);

Index IdxTypeEvent On (SubjectType, SubjectEvent);

Storage Default
{
<Data name="SubjectEPRInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubjectType</Value>
</Value>
<Value name="3">
<Value>SubjectEvent</Value>
</Value>
<Value name="4">
<Value>EPRTemplateID</Value>
</Value>
<Value name="5">
<Value>EPRTemplateDesc</Value>
</Value>
<Value name="6">
<Value>EPRItemCode</Value>
</Value>
<Value name="7">
<Value>EPRItemDesc</Value>
</Value>
<Value name="8">
<Value>ValueCodeIsRowID</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.SubjectEPRInfoD</DataLocation>
<DefaultData>SubjectEPRInfoDefaultData</DefaultData>
<IdLocation>^DHCEMRM.SubjectEPRInfoD</IdLocation>
<IndexLocation>^DHCEMRM.SubjectEPRInfoI</IndexLocation>
<StreamLocation>^DHCEMRM.SubjectEPRInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
