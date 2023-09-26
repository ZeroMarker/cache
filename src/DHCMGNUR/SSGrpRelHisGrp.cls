Class DHCMGNUR.SSGrpRelHisGrp Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

//护理管理安全组与His安全组对应

Property ssgrp As DHCMGNUR.SSGROUP;

Property hisssgrp As %String(TRUNCATE = 1);

Index hisgrp On hisssgrp;

Storage Default
{
<Data name="SSGrpRelHisGrpDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>hisssgrp</Value>
</Value>
<Value name="3">
<Value>ssgrp</Value>
</Value>
</Data>
<DataLocation>^DHCMGNUR.SSGrpRelHisGrpD</DataLocation>
<DefaultData>SSGrpRelHisGrpDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMGNUR.SSGrpRelHisGrpD</IdLocation>
<IndexLocation>^DHCMGNUR.SSGrpRelHisGrpI</IndexLocation>
<StreamLocation>^DHCMGNUR.SSGrpRelHisGrpS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
