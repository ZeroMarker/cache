///     
Class dbo.BTQCReferenceMach Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BTQC_ReferenceMach ]
{

/// Foreign Key FKBTQCReferenceMachSourceMachineDR created via DDL
ForeignKey FKBTQCReferenceMachSourceMachineDR(SourceMachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCReferenceMachSourceMachineDR ];

/// Foreign Key FKBTQCReferenceMachComparedMachineDR created via DDL
ForeignKey FKBTQCReferenceMachComparedMachineDR(ComparedMachineDR) References dbo.BTMIMachineParameter(PKBTMIMACHINEPARAMETER) [ SqlName = FK_BTQCReferenceMachComparedMachineDR ];

/// DDL Primary Key Specification
Index PKBTQCREFERENCEMACH On RowID [ PrimaryKey, SqlName = PK_BTQC_REFERENCEMACH, Type = index, Unique ];

Index IndexMaster On (SourceMachineDR, ComparedMachineDR) [ SqlName = Index_Master, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property SourceMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property ComparedMachineDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="BTQCReferenceMachDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SourceMachineDR</Value>
</Value>
<Value name="3">
<Value>ComparedMachineDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTQCReferenceMachD</DataLocation>
<DefaultData>BTQCReferenceMachDefaultData</DefaultData>
<IdLocation>^dbo.BTQCReferenceMachD</IdLocation>
<IndexLocation>^dbo.BTQCReferenceMachI</IndexLocation>
<StreamLocation>^dbo.BTQCReferenceMachS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
