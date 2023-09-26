Class User.DHCHMCHumanClass Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CHumanClass ]
{

Parameter ClassName = "User.DHCHMCHumanClass";

Property HCCode As %String [ Required, SqlFieldName = HC_Code ];

Property HCDesc As %String [ Required, SqlFieldName = HC_Desc ];

Property HCRemark As %String(MAXLEN = 200) [ SqlFieldName = HC_Remark ];

Property HCExpandCode As %String [ SqlFieldName = HC_ExpandCode ];

Property HCActive As %String [ SqlFieldName = HC_Active ];

Property HCType As %String [ Required, SqlFieldName = HC_Type ];

Property HCMonths As %Integer [ SqlFieldName = HC_Months ];

Index HCTypeIndex On HCType;

Index TypeCodeIndex On (HCType, HCCode) [ Unique ];

Index TypeDescIndex On (HCType, HCDesc) [ Unique ];

Index TypeExpandCodeIndex On (HCType, HCExpandCode);

Storage Default
{
<Data name="DHCHMCHumanClassDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HCActive</Value>
</Value>
<Value name="3">
<Value>HCCode</Value>
</Value>
<Value name="4">
<Value>HCDefault</Value>
</Value>
<Value name="5">
<Value>HCDesc</Value>
</Value>
<Value name="6">
<Value>HCExpandCode</Value>
</Value>
<Value name="7">
<Value>HCRemark</Value>
</Value>
<Value name="8">
<Value>HCType</Value>
</Value>
<Value name="9">
<Value>HCMonths</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCHumanClassD</DataLocation>
<DefaultData>DHCHMCHumanClassDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCHumanClassD</IdLocation>
<IndexLocation>^User.DHCHMCHumanClassI</IndexLocation>
<StreamLocation>^User.DHCHMCHumanClassS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
