Class User.DHCHMCCodeTable Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlTableName = DHC_HM_CCodeTable ]
{

Parameter ClassName = "User.DHCHMCCodeTable";

Property CTCode As %String [ Required, SqlFieldName = CT_Code ];

Property CTDesc As %String [ Required, SqlFieldName = CT_Desc ];

Property CTRemark As %String(MAXLEN = 200) [ SqlFieldName = CT_Remark ];

Property CTExpandCode As %String [ SqlFieldName = CT_ExpandCode ];

Property CTDefault As %String [ SqlFieldName = CT_Default ];

Property CTActive As %String [ SqlFieldName = CT_Active ];

Property CTType As %String [ Required, SqlFieldName = CT_Type ];

Index Type On CTType;

Index TypeCodeIndex On (CTType, CTCode) [ Unique ];

Index TypeDescIndex On (CTType, CTDesc) [ Unique ];

Index TypeExpandCodeIndex On (CTType, CTExpandCode);

Index CTDefault On (CTType, CTDefault);

Storage Default
{
<Data name="DHCHMCCodeTableDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CTActive</Value>
</Value>
<Value name="3">
<Value>CTCode</Value>
</Value>
<Value name="4">
<Value>CTDefault</Value>
</Value>
<Value name="5">
<Value>CTDesc</Value>
</Value>
<Value name="6">
<Value>CTExpandCode</Value>
</Value>
<Value name="7">
<Value>CTRemark</Value>
</Value>
<Value name="8">
<Value>CTType</Value>
</Value>
</Data>
<DataLocation>^User.DHCHMCCodeTableD</DataLocation>
<DefaultData>DHCHMCCodeTableDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCHMCCodeTableD</IdLocation>
<IndexLocation>^User.DHCHMCCodeTableI</IndexLocation>
<StreamLocation>^User.DHCHMCCodeTableS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
