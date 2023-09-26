/// 系统页面功能点
Class dbo.SYSFormFunction Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_FormFunction ]
{

Index IndexMaster On (FormDR, FunctionDR) [ SqlName = Index_Master, Type = index ];

/// DDL Primary Key Specification
Index PKSYSFormFunction On RowID [ PrimaryKey, SqlName = PK_SYS_FormFunction, Type = index, Unique ];

/// Foreign Key FormDR created via DDL
ForeignKey FKForm(FormDR) References dbo.SYSForm(PKSYSForm) [ SqlName = FK_Form ];

/// Foreign Key FunctionDR created via DDL
ForeignKey FKFunction(FunctionDR) References dbo.SYSFunction(PKSYSFUNCTION) [ SqlName = FK_Function ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 页面  
Property FormDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 功能点  
Property FunctionDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 4 ];

Storage Default
{
<Data name="SYSFormFunctionDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FormDR</Value>
</Value>
<Value name="3">
<Value>FunctionDR</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSFormFunctionD</DataLocation>
<DefaultData>SYSFormFunctionDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.SYSFormFunctionD</IdLocation>
<IndexLocation>^dbo.SYSFormFunctionI</IndexLocation>
<StreamLocation>^dbo.SYSFormFunctionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
