/// 
/// 
/// 专科发展
Class DHCNMG.HR.MgSepcialDevelop Extends %Persistent
{

/// 人员档案id
Property SpecialPerDR As DHCNMG.HR.MgPersons [ SqlColumnNumber = 2, SqlFieldName = Special_PerDR ];

/// 病区
Property SpecialWard As %String [ SqlColumnNumber = 3, SqlFieldName = Special_Ward ];

/// 事件
Property SpecialEvent As %String(MAXLEN = 5000) [ SqlColumnNumber = 4, SqlFieldName = Special_Event ];

/// 状态
Property SpecialStatus As %String [ SqlColumnNumber = 5, SqlFieldName = Special_Status ];

Property SpecialUser As %String [ SqlColumnNumber = 6, SqlFieldName = Special_User ];

Index ssid On SpecialPerDR;

Storage Default
{
<Data name="MgSepcialDevelopDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SepicalPerDR</Value>
</Value>
<Value name="3">
<Value>SepicalWard</Value>
</Value>
<Value name="4">
<Value>SepicalEvent</Value>
</Value>
<Value name="5">
<Value>ReseaStatus</Value>
</Value>
<Value name="6">
<Value>ReseaUser</Value>
</Value>
<Value name="7">
<Value>SepicalStatus</Value>
</Value>
<Value name="8">
<Value>SepicalUser</Value>
</Value>
<Value name="9">
<Value>SpeicalPerDR</Value>
</Value>
<Value name="10">
<Value>SpeicalWard</Value>
</Value>
<Value name="11">
<Value>SpeicalEvent</Value>
</Value>
<Value name="12">
<Value>SpeicalStatus</Value>
</Value>
<Value name="13">
<Value>SpeicalUser</Value>
</Value>
<Value name="14">
<Value>SpecialPerDR</Value>
</Value>
<Value name="15">
<Value>SpecialWard</Value>
</Value>
<Value name="16">
<Value>SpecialEvent</Value>
</Value>
<Value name="17">
<Value>SpecialStatus</Value>
</Value>
<Value name="18">
<Value>SpecialUser</Value>
</Value>
</Data>
<DataLocation>^DHCNMG.HR.MgSepcialDevelopD</DataLocation>
<DefaultData>MgSepcialDevelopDefaultData</DefaultData>
<IdLocation>^DHCNMG.HR.MgSepcialDevelopD</IdLocation>
<IndexLocation>^DHCNMG.HR.MgSepcialDevelopI</IndexLocation>
<StreamLocation>^DHCNMG.HR.MgSepcialDevelopS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
