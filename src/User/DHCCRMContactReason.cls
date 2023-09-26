Class User.DHCCRMContactReason Extends (%Persistent, %XML.Adaptor, User.DHCHMAbstract) [ ClassType = persistent, Inheritance = right, SqlRowIdName = CR_RowId, SqlTableName = DHC_CRM_ContactReason ]
{

Parameter ClassName = "User.DHCCRMContactReason";

Property CRCode As %Library.String [ SqlColumnNumber = 2, SqlFieldName = CR_Code ];

Property CRDesc As %Library.String [ SqlColumnNumber = 3, SqlFieldName = CR_Desc ];

/// 类型：Z：暂时联系不上   L：联系不上
Property CRType As %Library.String [ SqlColumnNumber = 4, SqlFieldName = CR_Type ];

Property CRSequence As %Library.Integer [ SqlColumnNumber = 5, SqlFieldName = CR_Sequence ];

Property CRActive As %Library.String [ SqlColumnNumber = 6, SqlFieldName = CR_Active ];

Storage Default
{
<Data name="DHCCRMContactReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CRCode</Value>
</Value>
<Value name="3">
<Value>CRDesc</Value>
</Value>
<Value name="4">
<Value>CRType</Value>
</Value>
<Value name="5">
<Value>CRSequence</Value>
</Value>
<Value name="6">
<Value>CRActive</Value>
</Value>
</Data>
<DataLocation>^User.DHCCRMContactReasonD</DataLocation>
<DefaultData>DHCCRMContactReasonDefaultData</DefaultData>
<IdLocation>^User.DHCCRMContactReasonD</IdLocation>
<IndexLocation>^User.DHCCRMContactReasonI</IndexLocation>
<StreamLocation>^User.DHCCRMContactReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
