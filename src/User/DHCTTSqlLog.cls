Class User.DHCTTSqlLog Extends %Persistent
{

Property SQLStatement As %String(MAXLEN = 30000) [ Required ];

/// $lb("SQLUSER.PA_ADM")
Property StatementTables As %String;

/// sel/INS/UPD/DEL/CREATE and so on
Property FirstToken As %String [ Required ];

Property AffectedRow As %Integer;

Property Computer As %String;

/// SS_User
Property UserDR As %String;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

Index UpdateDate On UpdateDate;

Storage Default
{
<Data name="DHCTTSqlLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SQLStatement</Value>
</Value>
<Value name="3">
<Value>StatementTables</Value>
</Value>
<Value name="4">
<Value>FirstToken</Value>
</Value>
<Value name="5">
<Value>AffectedRow</Value>
</Value>
<Value name="6">
<Value>UserDR</Value>
</Value>
<Value name="7">
<Value>UpdateDate</Value>
</Value>
<Value name="8">
<Value>UpdateTime</Value>
</Value>
<Value name="9">
<Value>Computer</Value>
</Value>
</Data>
<DataLocation>^User.DHCTTSqlLogD</DataLocation>
<DefaultData>DHCTTSqlLogDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.DHCTTSqlLogD</IdLocation>
<IndexLocation>^User.DHCTTSqlLogI</IndexLocation>
<StreamLocation>^User.DHCTTSqlLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
