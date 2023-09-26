Class User.DHCHMCSetting Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CSetting ]
{

Parameter ClassName = "User.DHCHMCSetting";

Property STypeCode As %String [ Required ];

Index STypeCodeIndex On (STypeCode, SOrder);

Property STable As %String;

Index STableIndex On STable;

Property SCode As %String [ SqlFieldName = S_Code ];

Property SOrder As %Integer [ SqlFieldName = S_Order ];

Property SValue As %String [ SqlFieldName = S_Value ];

Property SRemark As %String [ SqlFieldName = S_Remark ];

Index SCodeIndex On SCode;

Storage Default
{
<Data name="DHCHMCSettingDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>STable</Value>
</Value>
<Value name="3">
<Value>STypeCode</Value>
</Value>
<Value name="4">
<Value>SCode</Value>
</Value>
<Value name="5">
<Value>SOrder</Value>
</Value>
<Value name="6">
<Value>SRemark</Value>
</Value>
<Value name="7">
<Value>SValue</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCSettingD</DataLocation>
<DefaultData>DHCHMCSettingDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCSettingD</IdLocation>
<Index name="SCode"/>
<IndexLocation>^User.DHCHMCSettingI</IndexLocation>
<StreamLocation>^User.DHCHMCSettingS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
