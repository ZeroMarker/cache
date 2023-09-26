///     
Class dbo.SYSGroupMenuFunction Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_GroupMenuFunction, StorageStrategy = Default ]
{

/// Foreign Key FKGroupMenuFunctionFun created via DDL
ForeignKey FKGroupMenuFunctionFun(FunctionDR) References dbo.SYSFunction(PKSYSFUNCTION) [ SqlName = FK_GroupMenuFunctionFun ];

/// Foreign Key FKGroupMenuFunctionGm created via DDL
ForeignKey FKGroupMenuFunctionGm(GroupMenuDR) References dbo.SYSGroupMenu(PKSYSGROUPMENU) [ SqlName = FK_GroupMenuFunctionGm ];

Index IndexMaster On (GroupMenuDR, FunctionDR) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSYSGROUPMENUFUNCTION On RowID [ PrimaryKey, SqlName = PK_SYS_GROUPMENUFUNCTION, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property GroupMenuDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property FunctionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Storage Default
{
<Data name="SYSGroupMenuFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>GroupMenuDR</Value>
</Value>
<Value name="3">
<Value>FunctionDR</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSGroupMenuFunctionD</DataLocation>
<DefaultData>SYSGroupMenuFunctionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSGroupMenuFunctionD</IdLocation>
<IndexLocation>^dbo.SYSGroupMenuFunctionI</IndexLocation>
<StreamLocation>^dbo.SYSGroupMenuFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
