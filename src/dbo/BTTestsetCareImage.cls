Class dbo.BTTestsetCareImage Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestsetCareImage ]
{

/// Foreign Key FKTestSet created via DDL
ForeignKey FKTestSet(TestSetDR) References dbo.BTTestSet(PKBTTESTSET) [ SqlName = FK_TestSe ];

Index IndexMaster On (TestSetDR, ImageClass) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexSequence On (TestSetDR, Sequence, ImageClass) [ SqlName = Index_Sequence, Type = index, Unique ];

/// DDL Primary Key TestsetCareImage
Index PKBTTESTSETCAREIMAGE On RowID [ PrimaryKey, SqlName = PK_BT_TESTSETCAREIMAGE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ImageClass As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ Required, SqlColumnNumber = 4 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 6 ];

Storage Default
{
<Data name="BTTestsetCareImageDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>ImageClass</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestsetCareImageD</DataLocation>
<DefaultData>BTTestsetCareImageDefaultData</DefaultData>
<IdLocation>^dbo.BTTestsetCareImageD</IdLocation>
<IndexLocation>^dbo.BTTestsetCareImageI</IndexLocation>
<StreamLocation>^dbo.BTTestsetCareImageS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
