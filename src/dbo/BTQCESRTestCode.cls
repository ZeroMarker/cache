///     
Class dbo.BTQCESRTestCode Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_ESRTestCode ]
{

/// Foreign Key FKBTQCESRTestCodeMachineDR created via DDL
ForeignKey FKBTQCESRTestCodeMachineDR(MachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCESRTestCodeMachineDR ];

/// Foreign Key FKBTQCESRTestCodeTestCodeDR created via DDL
ForeignKey FKBTQCESRTestCodeTestCodeDR(TestCodeDR) References dbo.BTTestCode(PKBTTESTCODE) [ SqlName = FK_BTQCESRTestCodeTestCodeDR ];

/// DDL IndexMaster
Index IndexMaster On (MachineDR, TestCodeDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTQCESRTESTCODE On RowID [ PrimaryKey, SqlName = PK_BTQC_ESRTESTCODE, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property MachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property TestCodeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property ValNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

Property MinVal As %Library.Float [ SqlColumnNumber = 6 ];

Property MaxVal As %Library.Float [ SqlColumnNumber = 7 ];

Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTQCESRTestCodeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MachineDR</Value>
</Value>
<Value name="3">
<Value>TestCodeDR</Value>
</Value>
<Value name="4">
<Value>ValNum</Value>
</Value>
<Value name="5">
<Value>MinVal</Value>
</Value>
<Value name="6">
<Value>MaxVal</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCESRTestCodeD</DataLocation>
<DefaultData>BTQCESRTestCodeDefaultData</DefaultData>
<IdLocation>^dbo.BTQCESRTestCodeD</IdLocation>
<IndexLocation>^dbo.BTQCESRTestCodeI</IndexLocation>
<StreamLocation>^dbo.BTQCESRTestCodeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
