Class User.CSSDSteCheckReason Extends (%Persistent, User.Abstract) [ SqlTableName = CSSD_SteCheckReason ]
{

/// 消毒灭菌不合格编码
Property CSSDSteFailCode As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 2, SqlFieldName = CSSD_SteFailCode ];

/// 消毒灭菌不合格原因
Property CSSDSteFailDesc As %Library.String(COLLATION = "Exact") [ Required, SqlColumnNumber = 3, SqlFieldName = CSSD_SteFailDesc ];

Property CSSDSNotUseFlag As %String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, VALUELIST = ",Y,N") [ InitialExpression = "Y", Required, SqlColumnNumber = 4, SqlFieldName = CSSDS_NotUseFlag ];

Index CSSDSteFailCodeIndex On CSSDSteFailCode As Exact;

Index CSSDSteFailDescIndex On CSSDSteFailDesc As Exact;

Storage Default
{
<Data name="CSSDSteCheckReasonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CSSDSteFailCode</Value>
</Value>
<Value name="3">
<Value>CSSDSteFailDesc</Value>
</Value>
<Value name="4">
<Value>CSSDSNotUseFlag</Value>
</Value>
</Data>
<DataLocation>^User.CSSDSteCheckReasonD</DataLocation>
<DefaultData>CSSDSteCheckReasonDefaultData</DefaultData>
<IdLocation>^User.CSSDSteCheckReasonD</IdLocation>
<IndexLocation>^User.CSSDSteCheckReasonI</IndexLocation>
<StreamLocation>^User.CSSDSteCheckReasonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
