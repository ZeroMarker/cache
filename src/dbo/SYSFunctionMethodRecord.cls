Class dbo.SYSFunctionMethodRecord Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = SYS_FunctionMethodRecord ]
{

Index IndexProductLine On ProductLine [ SqlName = Index_ProductLine, Type = index ];

Index IndexDeveloper On Developer [ SqlName = Index_Developer, Type = index ];

Index IndexModularFuncPoint On (Modular, FunctionPoint) [ SqlName = Index_ModularFuncPoint, Type = index ];

Index IndexClassMethodName On (ClassName, MethodName) [ SqlName = Index_ClassMethodName, Type = index ];

Index IndexDevelopDateAndTime On (DevelopDate, DevelopTime) [ SqlName = Index_DevelopDateAndTime, Type = index ];

/// DDL Primary Key Specification
Index PKSYSMETHOD On RowID [ PrimaryKey, SqlName = PK_SYS_METHOD, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 产品线
Property ProductLine As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 3 ];

/// 模块
Property Modular As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 4 ];

/// 功能点
Property FunctionPoint As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ Required, SqlColumnNumber = 5 ];

/// 类名
Property ClassName As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 6 ];

/// 方法名
Property MethodName As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 7 ];

/// 入参
Property Ginseng As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 8 ];

/// 返回值
Property ReturnVal As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 9 ];

/// 说明
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

/// 附件
Property Appendix As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 11 ];

/// 开发人
Property Developer As %Library.String(COLLATION = "Exact", MAXLEN = 40) [ SqlColumnNumber = 12 ];

/// 开发日期
Property DevelopDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 13 ];

/// 开发时间
Property DevelopTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

/// 序号
Property Sequence As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 15 ];

/// DTS编码
Property DTSCode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 16 ];

Storage Default
{
<Data name="SYSFunctionMethodRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ProductLine</Value>
</Value>
<Value name="3">
<Value>Modular</Value>
</Value>
<Value name="4">
<Value>FunctionPoint</Value>
</Value>
<Value name="5">
<Value>ClassName</Value>
</Value>
<Value name="6">
<Value>MethodName</Value>
</Value>
<Value name="7">
<Value>Ginseng</Value>
</Value>
<Value name="8">
<Value>ReturnVal</Value>
</Value>
<Value name="9">
<Value>Remark</Value>
</Value>
<Value name="10">
<Value>Appendix</Value>
</Value>
<Value name="11">
<Value>Developer</Value>
</Value>
<Value name="12">
<Value>DevelopDate</Value>
</Value>
<Value name="13">
<Value>DevelopTime</Value>
</Value>
<Value name="14">
<Value>Sequence</Value>
</Value>
<Value name="15">
<Value>DTSCode</Value>
</Value>
</Data>
<DataLocation>^dbo.SYSFunctionMethodRecordD</DataLocation>
<DefaultData>SYSFunctionMethodRecordDefaultData</DefaultData>
<IdLocation>^dbo.SYSFunctionMethodRecordD</IdLocation>
<IndexLocation>^dbo.SYSFunctionMethodRecordI</IndexLocation>
<StreamLocation>^dbo.SYSFunctionMethodRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
