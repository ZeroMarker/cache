Class User.CSSDCleanItmReason Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_CleanItmReason ]
{

/// 不合格品编码
Property CSSDRejectCode As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = CSSD_RejectCode ];

/// 不合格品原因
Property CSSDRejectDesc As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 3, SqlFieldName = CSSD_RejectDesc ];

Property CSSDCNotUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 5, SqlFieldName = CSSDC_NotUseFlag ];

Index CSSDRejectCodeIndex On CSSDRejectCode As Exact;

Index CSSDRejectDescIndex On CSSDRejectDesc As Exact;

Storage Default
{
<Data name="CSSDCleanItmReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDRejectCode</Value>
</Value>
<Value name="3">
<Value>CSSDRejectDesc</Value>
</Value>
<Value name="4"/>
<Value name="5">
<Value>CSSDCNotUseFlag</Value>
</Value>
</Data>
<DataLocation>^User.CSSDCleanItmReasonD</DataLocation>
<DefaultData>CSSDCleanItmReasonDefaultData</DefaultData>
<IdLocation>^User.CSSDCleanItmReasonD</IdLocation>
<IndexLocation>^User.CSSDCleanItmReasonI</IndexLocation>
<StreamLocation>^User.CSSDCleanItmReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
