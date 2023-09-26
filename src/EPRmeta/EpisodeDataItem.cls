Class EPRmeta.EpisodeDataItem Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Property Name As %String(TRUNCATE = 1);

Property FieldName As %String(TRUNCATE = 1);

Property DataType As %String(TRUNCATE = 1);

Property Description As %String(TRUNCATE = 1);

/// Index IdxForFieldName On FieldName [ Unique ];
Query SELECTALL() As %SQLQuery(CONTAINID = 1, ROWSPEC = "ID:%Integer,Name:%String, FieldName:%String,DataType:%String,Description:%String", SELECTMODE = "RUNTIME") [ SqlName = SP_EpisodeDataItem_SELECTALL, SqlProc ]
{
 SELECT ID, Name,  FieldName ,DataType, Description
 FROM EPRmeta.EpisodeDataItem
 ORDER BY ID
}

/*
ClassMethod GetDataTypeByFieldName(argFieldName As %String) As %String
{
	s returnValue=""
	&sql(select top 1 DataType into :returnValue from EPRmeta.EpisodeDataItem 
	     where FieldName = :argFieldName )
	quit returnValue
}
*/
Storage Default
{
<Data name="EpisodeDataItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DataType</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>FieldName</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>PropertyDesc</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.EpisodeDataItemD</DataLocation>
<DefaultData>EpisodeDataItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.EpisodeDataItemD</IdLocation>
<IndexLocation>^DHCEPRM.EpisodeDataItemI</IndexLocation>
<StreamLocation>^DHCEPRM.EpisodeDataItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
