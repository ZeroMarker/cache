Class User.ACCTSubjType Extends %Persistent [ Owner = {_SYSTEM}, SqlTableName = ACCT_SubjType ]
{

Property CompCode As %String(MAXLEN = 20) [ Required, SqlFieldName = comp_code ];

Property CopyCode As %String(MAXLEN = 3) [ Required, SqlFieldName = copy_code ];

Property SubjTypeCode As %String(MAXLEN = 20) [ Required, SqlFieldName = subj_type_code ];

Property SubjTypeName As %String(MAXLEN = 20) [ Required, SqlFieldName = subj_type_name ];

Property Note As %String(MAXLEN = 100) [ SqlFieldName = note ];

Index PKCompCodeCopyCodeType On (CompCode, CopyCode, SubjTypeCode) [ Unique ];

Storage Default
{
<Data name="ACCTSubjTypeDefaultData">
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
<Value>Note</Value>
</Value>
<Value name="5">
<Value>SubjTypeCode</Value>
</Value>
<Value name="6">
<Value>SubjTypeName</Value>
</Value>
</Data>
<DataLocation>^User.ACCTSubjTypeD</DataLocation>
<DefaultData>ACCTSubjTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.ACCTSubjTypeD</IdLocation>
<IndexLocation>^User.ACCTSubjTypeI</IndexLocation>
<StreamLocation>^User.ACCTSubjTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
