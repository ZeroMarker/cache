Class User.DHCHMCClassLevel Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CClassLevel ]
{

Parameter ClassName = "User.DHCHMCClassLevel";

Property CLCode As %String [ Required, SqlFieldName = CL_Code ];

Property CLDesc As %String [ Required, SqlFieldName = CL_Desc ];

Property CLRemark As %String(MAXLEN = 200) [ SqlFieldName = CL_Remark ];

Property CLExpandCode As %String [ SqlFieldName = CL_ExpandCode ];

Property CLActive As %String [ SqlFieldName = CL_Active ];

Property CLType As %String [ Required, SqlFieldName = CL_Type ];

Index CLTypeIndex On CLType;

Index TypeCodeIndex On (CLType, CLCode) [ Unique ];

Index TypeDescIndex On (CLType, CLDesc) [ Unique ];

Index TypeExpandCodeIndex On (CLType, CLExpandCode);

Storage Default
{
<Data name="DHCHMCClassLevelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CLACLive</Value>
</Value>
<Value name="3">
<Value>CLCode</Value>
</Value>
<Value name="4">
<Value>CLDefault</Value>
</Value>
<Value name="5">
<Value>CLDesc</Value>
</Value>
<Value name="6">
<Value>CLExpandCode</Value>
</Value>
<Value name="7">
<Value>CLRemark</Value>
</Value>
<Value name="8">
<Value>CLType</Value>
</Value>
<Value name="9">
<Value>CLACtive</Value>
</Value>
<Value name="10">
<Value>CLActive</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCClassLevelD</DataLocation>
<DefaultData>DHCHMCClassLevelDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCClassLevelD</IdLocation>
<IndexLocation>^User.DHCHMCClassLevelI</IndexLocation>
<StreamLocation>^User.DHCHMCClassLevelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
