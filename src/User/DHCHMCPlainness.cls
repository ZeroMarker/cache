Class User.DHCHMCPlainness Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CPlainness ]
{

Parameter ClassName = "User.DHCHMCPlainness";

Property PCode As %String [ Required, SqlFieldName = P_Code ];

Property PDesc As %String [ Required, SqlFieldName = P_Desc ];

Property PRemark As %String [ SqlFieldName = P_Remark ];

Property PExpandCode As %String [ SqlFieldName = P_ExpandCode ];

Property PActive As %String [ SqlFieldName = P_Active ];

Property PType As %String [ Required, SqlFieldName = P_Type ];

Index PTypeIndex On PType;

Index TypeCodeIndex On (PType, PCode) [ Unique ];

Index TypeDescIndex On (PType, PDesc) [ Unique ];

Index TypeExpandCodeIndex On (PType, PExpandCode);

Storage Default
{
<Data name="DHCHMCPlainnessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PActive</Value>
</Value>
<Value name="3">
<Value>PCode</Value>
</Value>
<Value name="4">
<Value>PDesc</Value>
</Value>
<Value name="5">
<Value>PExpandCode</Value>
</Value>
<Value name="6">
<Value>PRemark</Value>
</Value>
<Value name="7">
<Value>PType</Value>
</Value>
<Value name="8">
<Value>CLActive</Value>
</Value>
<Value name="9">
<Value>CLCode</Value>
</Value>
<Value name="10">
<Value>CLDesc</Value>
</Value>
<Value name="11">
<Value>CLExpandCode</Value>
</Value>
<Value name="12">
<Value>CLRemark</Value>
</Value>
<Value name="13">
<Value>CLType</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCPlainnessD</DataLocation>
<DefaultData>DHCHMCPlainnessDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCPlainnessD</IdLocation>
<IndexLocation>^User.DHCHMCPlainnessI</IndexLocation>
<StreamLocation>^User.DHCHMCPlainnessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
