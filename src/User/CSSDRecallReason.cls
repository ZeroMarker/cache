Class User.CSSDRecallReason Extends (%Persistent, User.Abstract) [ SqlRowIdName = CSSDRR_RecallRowid, SqlTableName = CSSD_RecallReason ]
{

/// 召回原因编码
Property CSSDRecallCode As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = CSSD_RecallCode ];

/// 召回原因描述
Property CSSDRecallDesc As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 3, SqlFieldName = CSSD_RecallDesc ];

/// 是否可用
Property CSSDRecallUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 4, SqlFieldName = CSSD_RecallUseFlag ];

Index CSSDRecallCodeIndex On CSSDRecallCode As Exact;

Index CSSDRecallDescIndex On CSSDRecallDesc As Exact;

Storage Default
{
<Data name="CSSDRecallReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDRecallCode</Value>
</Value>
<Value name="3">
<Value>CSSDRecallDesc</Value>
</Value>
<Value name="4">
<Value>CSSDRecallUseFlag</Value>
</Value>
</Data>
<DataLocation>^User.CSSDRecallReasonD</DataLocation>
<DefaultData>CSSDRecallReasonDefaultData</DefaultData>
<IdLocation>^User.CSSDRecallReasonD</IdLocation>
<IndexLocation>^User.CSSDRecallReasonI</IndexLocation>
<SqlRowIdName>CSSDRR_RecallRowid</SqlRowIdName>
<StreamLocation>^User.CSSDRecallReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
