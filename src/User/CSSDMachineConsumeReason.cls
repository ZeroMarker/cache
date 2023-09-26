/// 器械损耗原因维护表
Class User.CSSDMachineConsumeReason Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDMConsume_Rowid, SqlTableName = CSSD_MachineConsumeReason ]
{

/// 器械损耗编码
Property CSSDMConsumeCode As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = CSSD_MConsumeCode ];

/// 器械损耗原因
Property CSSDMConsumeDesc As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 3, SqlFieldName = CSSD_MConsumeDesc ];

/// 器械损耗状态 可用、停用
Property CSSDCNotUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 4, SqlFieldName = CSSDC_NotUseFlag ];

Index CSSDMConsumeCodeIndex On CSSDMConsumeCode As Exact;

Index CSSDMConsumeDescIndex On CSSDMConsumeDesc As Exact;

Storage Default
{
<Data name="CSSDMachineConsumeReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDMConsumeCode</Value>
</Value>
<Value name="3">
<Value>CSSDMConsumeDesc</Value>
</Value>
<Value name="4">
<Value>CSSDCNotUseFlag</Value>
</Value>
</Data>
<DataLocation>^User.CSSDMachineConsumeReasonD</DataLocation>
<DefaultData>CSSDMachineConsumeReasonDefaultData</DefaultData>
<IdLocation>^User.CSSDMachineConsumeReasonD</IdLocation>
<IndexLocation>^User.CSSDMachineConsumeReasonI</IndexLocation>
<SqlRowIdName>CSSDMConsume_Rowid</SqlRowIdName>
<StreamLocation>^User.CSSDMachineConsumeReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
