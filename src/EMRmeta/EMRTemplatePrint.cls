/// 调用另外一个模板作为打印模板
Class EMRmeta.EMRTemplatePrint Extends %Persistent
{

Index IdxEMRTemplateId On EMRTemplateId;

Property EMRTemplateId As %String(TRUNCATE = 1);

Property EMRTemplateIdPrint As %String(TRUNCATE = 1);

Storage Default
{
<Data name="EMRTemplatePrintDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EMRTemplateId</Value>
</Value>
<Value name="3">
<Value>EMRTemplateIdPrint</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRTemplatePrintD</DataLocation>
<DefaultData>EMRTemplatePrintDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRTemplatePrintD</IdLocation>
<IndexLocation>^DHCEMRM.EMRTemplatePrintI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRTemplatePrintS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
