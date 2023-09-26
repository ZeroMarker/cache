Class User.ACCTVouchType Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_VouchType ]
{

Property CompCode As %String(MAXLEN = 20) [ Required, SqlFieldName = comp_code ];

Property CopyCode As %String(MAXLEN = 3) [ Required, SqlFieldName = copy_code ];

Property VouchTypeCode As %String(MAXLEN = 15) [ Required, SqlFieldName = vouch_type_code ];

Property VouchTypeName As %String(MAXLEN = 15) [ Required, SqlFieldName = vouch_type_name ];

Index PKACCTVouchType On (CompCode, CopyCode, VouchTypeCode) [ Unique ];

Storage Default
{
<Data name="ACCTVouchTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CompCode</Value>
</Value>
<Value name="3">
<Value>CopyCode</Value>
</Value>
<Value name="4">
<Value>VouchTypeCode</Value>
</Value>
<Value name="5">
<Value>VouchTypeName</Value>
</Value>
</Data>
<DataLocation>^User.ACCTVouchTypeD</DataLocation>
<DefaultData>ACCTVouchTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTVouchTypeD</IdLocation>
<IndexLocation>^User.ACCTVouchTypeI</IndexLocation>
<StreamLocation>^User.ACCTVouchTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
