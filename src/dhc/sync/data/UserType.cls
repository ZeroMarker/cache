Class dhc.sync.data.UserType Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, SqlRowIdName = SUT_Rowid, SqlTableName = Sync_UserType ]
{

//SUT_Rowid SUT_Code SUT_Name SUT_IsValid

Property Code As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = SUT_Code ];

Property Name As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = SUT_Name ];

Property IsValid As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = SUT_IsValid ];

Index SyncUserTypeCode On Code;

Index SyncUserTypeName On Name;

Storage Default
{
<Data name="UserTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>IsValid</Value>
</Value>
</Data>
<DataLocation>^dhcsyncUserTypeD</DataLocation>
<DefaultData>UserTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhcsyncUserTypeD</IdLocation>
<IndexLocation>^dhcsyncUserTypeI</IndexLocation>
<StreamLocation>^dhcsyncUserTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
