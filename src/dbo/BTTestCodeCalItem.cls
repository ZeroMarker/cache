///     
Class dbo.BTTestCodeCalItem Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestCodeCalItem, StorageStrategy = Default ]
{

/// Foreign Key FKTestCodeCalItem created via DDL
ForeignKey FKTestCodeCalItem(CalTestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodeCalItem ];

/// Foreign Key FKTestCodeCalItemTC created via DDL
ForeignKey FKTestCodeCalItemTC(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_TestCodeCalItemTC ];

Index IndexCalTestCode On (CalTestCodeDR, TestCodeDR) [ SqlName = Index_CalTestCode, Type = index ];

Index IndexDataMaster On (TestCodeDR, CalTestCodeDR) [ SqlName = Index_DataMaster, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTTESTCODECALITEM On RowID [ PrimaryKey, SqlName = PK_BT_TESTCODECALITEM, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, Required, SqlColumnNumber = 2 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property CalTestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTTestCodeCalItemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestCodeDR</Value>
</Value>
<Value name="3">
<Value>CalTestCodeDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestCodeCalItemD</DataLocation>
<DefaultData>BTTestCodeCalItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.BTTestCodeCalItemD</IdLocation>
<IndexLocation>^dbo.BTTestCodeCalItemI</IndexLocation>
<StreamLocation>^dbo.BTTestCodeCalItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
