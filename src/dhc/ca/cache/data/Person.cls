Class dhc.ca.cache.data.Person Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = Person_Rowid, SqlTableName = PersonZbp, StorageStrategy = Default ]
{

Parameter EXTENTSIZE = 250;

Property Code As %String(MAXLEN = 40) [ SqlColumnNumber = 2, SqlFieldName = person_code ];

Property name As %String(MAXLEN = 18) [ SqlColumnNumber = 3, SqlFieldName = person_name ];

Property sex As %String(MAXLEN = 18) [ SqlColumnNumber = 4, SqlFieldName = person_sex ];

ClassMethod InsertData(code, name, fale) As %Integer [ SqlProc ]
{
	
	&SQL(insert into  dhc_ca_cache_data.PersonZbp(person_code,person_name ,person_sex) values (:code,:name,:fale))
	q SQLCODE
}

Index NewIndex1 On Code [ Unique ];

Storage Default
{
<Data name="PersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>CardID</Value>
</Value>
<Value name="4">
<Value>DOB</Value>
</Value>
<Value name="5">
<Value>Phone</Value>
</Value>
<Value name="6">
<Value>Gender</Value>
</Value>
<Value name="7">
<Value>Spouse</Value>
</Value>
<Value name="8">
<Value>monthdr</Value>
</Value>
<Value name="9">
<Value>Code</Value>
</Value>
<Value name="10">
<Value>name</Value>
</Value>
<Value name="11">
<Value>sex</Value>
</Value>
</Data>
<DataLocation>^dhc.ca.cache.data.PersonD</DataLocation>
<DefaultData>PersonDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^dhc.ca.cache.data.PersonD</IdLocation>
<IndexLocation>^dhc.ca.cache.data.PersonI</IndexLocation>
<SqlIdExpression>$i(^DHCCAPERSONSZBP(0))</SqlIdExpression>
<SQLMap name="IndexCode">
<Global>^DHCCAPERSONSZBP</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>person_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{person_code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{person_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCCAPERSONSZBP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>person_rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{person_name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{person_rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MapIndex">
<Data name="person_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="person_name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="person_sex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCCAPERSONSZBP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>{person_rowi}</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{person_rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^dhc.ca.cache.data.PersonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
