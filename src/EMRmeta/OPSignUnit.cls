/// 签名单元与模板对照关系
Class EMRmeta.OPSignUnit Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxTemplateID On TemplateID [ Unique ];

Property TemplateID As %String(TRUNCATE = 1);

Property UnitPath As %String(TRUNCATE = 1);

Storage Default
{
<Data name="OPSignUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TemplateID</Value>
</Value>
<Value name="3">
<Value>UnitPath</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.OPSignUnitD</DataLocation>
<DefaultData>OPSignUnitDefaultData</DefaultData>
<IdLocation>^DHCEMRM.OPSignUnitD</IdLocation>
<IndexLocation>^DHCEMRM.OPSignUnitI</IndexLocation>
<StreamLocation>^DHCEMRM.OPSignUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
