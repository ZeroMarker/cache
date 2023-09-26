Class dbo.BTFormulaRule Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_FormulaRule ]
{

/// Foreign Key FKFormulaRule created via DDL
ForeignKey FKFormulaRule(DepartmentDR) References dbo.BTDepartment(PKBTDEPARTMENT) [ SqlName = FK_FormulaRule ];

Index IndexMaster On Code [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKBTFormulaRule On RowID [ PrimaryKey, SqlName = PK_BT_FormulaRule, Type = index, Unique ];

/// RowID  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 代码
Property Code As %Library.String(COLLATION = "Exact", MAXLEN = 15) [ Required, SqlColumnNumber = 3 ];

/// 名称
Property CName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 4 ];

/// 工作组  
Property DepartmentDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 5 ];

/// 类型  //名字,归类用(审核，提示，自动审核，查询等等)
Property TypeName As %Library.String(COLLATION = "Exact", MAXLEN = 20) [ SqlColumnNumber = 6 ];

/// 公式  
Property TxtRule As %Library.String(COLLATION = "Exact", MAXLEN = 500) [ SqlColumnNumber = 7 ];

/// 序号  
Property SeqNum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 是否激活  {1:true,0:false}
Property Active As %Library.Boolean [ SqlColumnNumber = 9 ];

Storage Default
{
<Data name="BTFormulaRuleDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>CName</Value>
</Value>
<Value name="4">
<Value>DepartmentDR</Value>
</Value>
<Value name="5">
<Value>TypeName</Value>
</Value>
<Value name="6">
<Value>TxtRule</Value>
</Value>
<Value name="7">
<Value>SeqNum</Value>
</Value>
<Value name="8">
<Value>Active</Value>
</Value>
</Data>
<DataLocation>^dbo.BTFormulaRuleD</DataLocation>
<DefaultData>BTFormulaRuleDefaultData</DefaultData>
<IdLocation>^dbo.BTFormulaRuleD</IdLocation>
<IndexLocation>^dbo.BTFormulaRuleI</IndexLocation>
<StreamLocation>^dbo.BTFormulaRuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
