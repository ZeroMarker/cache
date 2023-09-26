/// 申请单汇总
Class dbo.BSRequest Extends %Persistent [ Owner = {UnknownUser}, SqlTableName = BS_Request ]
{

Index IndexMaster On (WorkGroupDR, DateTypeId, TypeDate, TypeClassId, TypeClassCode, RequestDR) [ SqlName = Index_Master, Type = index ];

Index IndexType On (WorkGroupDR, TypeClassId, DateTypeId, TypeDate, TypeClassCode, RequestDR) [ SqlName = Index_Type, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKRequestTAT On RowID [ PrimaryKey, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医院代码
Property WorkGroupDR As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 3 ];

/// 日期类型（REQ：申请日期，TARNS：预定用血日期）
Property DateTypeId As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 4 ];

/// 日期
Property TypeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 1:申请科室 LOC,2:病房 WARD 3:医生 DOC 4:申请类型REQTYPE，5:申请目的PORPOSE
Property TypeClassId As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ Required, SqlColumnNumber = 6 ];

/// 1:对应TypeClassId业务表的DR
Property TypeClassCode As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 申请单Id
Property RequestDR As %Library.Integer(MAXVAL = 2147483647) [ SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BSRequestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WorkGroupDR</Value>
</Value>
<Value name="3">
<Value>DateTypeId</Value>
</Value>
<Value name="4">
<Value>TypeDate</Value>
</Value>
<Value name="5">
<Value>TypeClassId</Value>
</Value>
<Value name="6">
<Value>TypeClassCode</Value>
</Value>
<Value name="7">
<Value>RequestDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BSRequestD</DataLocation>
<DefaultData>BSRequestDefaultData</DefaultData>
<IdLocation>^dbo.BSRequestD</IdLocation>
<IndexLocation>^dbo.BSRequestI</IndexLocation>
<StreamLocation>^dbo.BSRequestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
