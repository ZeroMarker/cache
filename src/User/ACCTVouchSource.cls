Class User.ACCTVouchSource Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_VouchSource ]
{

Property VouchSourceCode As %String(MAXLEN = 15) [ Required, SqlFieldName = vouch_source_code ];

Property VouchSourceName As %String(MAXLEN = 20) [ Required, SqlFieldName = vouch_source_name ];

Property IsLnk As %Integer(DISPLAYLIST = "0,1", VALUELIST = "0,1") [ SqlFieldName = is_lnk ];

Index PKACCTVouchSource On VouchSourceCode [ Unique ];

Storage Default
{
<Data name="ACCTVouchSourceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IsLnk</Value>
</Value>
<Value name="3">
<Value>VouchSourceCode</Value>
</Value>
<Value name="4">
<Value>VouchSourceName</Value>
</Value>
</Data>
<DataLocation>^User.ACCTVouchSourceD</DataLocation>
<DefaultData>ACCTVouchSourceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTVouchSourceD</IdLocation>
<IndexLocation>^User.ACCTVouchSourceI</IndexLocation>
<StreamLocation>^User.ACCTVouchSourceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
