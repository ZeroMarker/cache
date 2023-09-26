///     
Class dbo.BTTestCodeComments Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeComments, StorageStrategy = Default ]
{

/// Foreign Key FKTestCodeComments created via DDL
ForeignKey FKTestCodeComments(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodeComments ];

/// Foreign Key FKTestCodeSpecimen created via DDL
ForeignKey FKTestCodeSpecimen(SpecimenDR) References dbo.BTSpecimen(PKBTSPECIMEN) [ SqlName = FK_TestCodeSpecimen ];

Index IndexCode On (TestCodeDR, Code) [ SqlName = Index_Code, Type = index, Unique ];

Index IndexSpecimen On (TestCodeDR, SpecimenDR) [ SqlName = Index_Specimen, Type = index ];

/// DDL Primary Key Specification
Index PKBTTESTCODECOMMENTS On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODECOMMENTS, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 4 ];

Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 1000) [ SqlColumnNumber = 5 ];

Property AbFlag As %Library.String(COLLATION = "Exact", MAXLEN = 1) [ SqlColumnNumber = 6 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 8 ];

Property SpecimenDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTTestCodeCommentsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>CName</Value>
</Value>
<Value name="5">
<Value>AbFlag</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Active</Value>
</Value>
<Value name="8">
<Value>SpecimenDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeCommentsD</DataLocation>
<DefaultData>BTTestCodeCommentsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestCodeCommentsD</IdLocation>
<IndexLocation>^dbo.BTTestCodeCommentsI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeCommentsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
