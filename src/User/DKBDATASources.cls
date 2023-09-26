/// 数据来源表： DKB_DATASources
Class User.DKBDATASources Extends %Persistent [ SqlRowIdName = DKBDSS_RowId, SqlTableName = DKB_DATASources ]
{

//^User.DKBDATASourcesD

Property DKBDSSCode As %String(MAXLEN = "") [ SqlColumnNumber = 2, SqlFieldName = DKBDSS_Code ];

Property DKBDSSDesc As %String(MAXLEN = "") [ SqlColumnNumber = 3, SqlFieldName = DKBDSS_Desc ];

Property DKBDSSSources As %String [ SqlColumnNumber = 4, SqlFieldName = DKBDSS_Sources ];

Property DKBDSSXcode As %String(MAXLEN = "") [ SqlColumnNumber = 5, SqlFieldName = DKBDSS_Xcode ];

Index CodeIndex On DKBDSSCode [ Unique ];

Index DescIndex On DKBDSSDesc [ Unique ];

Storage Default
{
<Data name="DKBDATASourcesDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DKBDSSCode</Value>
</Value>
<Value name="3">
<Value>DKBDSSDesc</Value>
</Value>
<Value name="4">
<Value>DKBDSSSources</Value>
</Value>
<Value name="5">
<Value>DKBDSSXcode</Value>
</Value>
</Data>
<DataLocation>^User.DKBDATASourcesD</DataLocation>
<DefaultData>DKBDATASourcesDefaultData</DefaultData>
<IdLocation>^User.DKBDATASourcesD</IdLocation>
<IndexLocation>^User.DKBDATASourcesI</IndexLocation>
<StreamLocation>^User.DKBDATASourcesS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
