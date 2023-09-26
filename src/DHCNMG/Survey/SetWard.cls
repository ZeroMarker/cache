/// Creator: guozj
/// Createdate: 2018-01-23
/// Description：患者满意度病区维护设置【南方医院版】
/// 
Class DHCNMG.Survey.SetWard Extends %Persistent
{

/// 病区描述
Property WardSetDesc As %String [ SqlColumnNumber = 2, SqlFieldName = WardSet_Desc ];

/// 病区代码
Property WardSetCode As %String [ SqlColumnNumber = 3, SqlFieldName = WardSet_Code ];

/// 病区描述简拼
Property WardSetSpell As %String [ SqlColumnNumber = 4, SqlFieldName = WardSet_Spell ];

/// 关联HIS病区 [暂时用ctlocid] 【PACWard RowID】
Property WardSetLink As %String [ SqlColumnNumber = 5, SqlFieldName = WardSet_Link ];

Index Desc On WardSetDesc;

Index spell On WardSetSpell;

Index wardlink On WardSetLink [ Unique ];

Storage Default
{
<Data name="SetWardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WardSetDesc</Value>
</Value>
<Value name="3">
<Value>WardSetCode</Value>
</Value>
<Value name="4">
<Value>WardSetSpell</Value>
</Value>
<Value name="5">
<Value>WardSetLink</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.Survey.SetWardD</DataLocation>
<DefaultData>SetWardDefaultData</DefaultData>
<IdLocation>^DHCNMG.Survey.SetWardD</IdLocation>
<IndexLocation>^DHCNMG.Survey.SetWardI</IndexLocation>
<StreamLocation>^DHCNMG.Survey.SetWardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
