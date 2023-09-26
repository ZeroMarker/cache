/// GroupToPerson
Class dhc.pa.inter.GroupToPerson Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = GroupToPerson_rowid, SqlTableName = GroupToPerson ]
{

Property Type As dhc.pa.inter.Type [ SqlColumnNumber = 2, SqlFieldName = GroupToPerson_Type ];

/// Group
Property GroupDr As dhc.pa.data.JXUnit [ SqlColumnNumber = 3, SqlFieldName = GroupToPerson_GroupDr ];

/// person
Property PersonDr As dhc.pa.inter.InterPerson [ SqlColumnNumber = 4, SqlFieldName = GroupToPerson_Person ];

Index PersonGroup On (PersonDr As Exact, GroupDr As Exact);

Index GroupPerson On (GroupDr As Exact, PersonDr As Exact);

Storage Default
{
<Data name="GroupToPersonDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupDr</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>PersonDr</Value>
</Value>
</Data>
<DataLocation>^dhc.pa.inter.GroupToPersonD</DataLocation>
<DefaultData>GroupToPersonDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dhc.pa.inter.GroupToPersonD</IdLocation>
<IndexLocation>^dhc.pa.inter.GroupToPersonI</IndexLocation>
<StreamLocation>^dhc.pa.inter.GroupToPersonS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
