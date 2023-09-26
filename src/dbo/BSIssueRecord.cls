/// 汇总日常发血记录
Class dbo.BSIssueRecord Extends %Persistent [ Owner = {UnknownUser}, SqlTableName = BS_IssueRecord ]
{

Index IndexMaster On (WorkGroupDR, DateTypeId, TypeDate, TypeClassId, TypeClass, IssueNumberDR) [ SqlName = Index_Master, Type = index ];

Index IndexIssueNumber On (IssueNumberDR, WorkGroupDR, DateTypeId, TypeDate, TypeClassId, TypeClass) [ SqlName = Index_IssueNumber, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKIssueRecordId On RowID [ PrimaryKey, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医院代码
Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

/// 日期类型（ISS：发血日期，TARNS：预定用血日期）
Property DateTypeId As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 4 ];

/// 日期
Property TypeDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 1:申请科室 LOC,2:病房 WARD 3:医生 DOC 4:申请类型REQTYPE，5:申请目的PORPOSE
Property TypeClassId As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 6 ];

/// 1:申请科室 LOC,2:病房 WARD 3:医生 DOC 4:申请类型REQTYPE，5:申请目的PORPOSE
Property TypeClass As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 7 ];

/// 发血单号
Property IssueNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 8 ];

Storage Default
{
<Data name="BSIssueRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospCode</Value>
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
<Value>TypeClass</Value>
</Value>
<Value name="7">
<Value>IssueNumber</Value>
</Value>
<Value name="8">
<Value>WorkGroupDR</Value>
</Value>
<Value name="9">
<Value>IssueNumberDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BSIssueRecordD</DataLocation>
<DefaultData>BSIssueRecordDefaultData</DefaultData>
<IdLocation>^dbo.BSIssueRecordD</IdLocation>
<IndexLocation>^dbo.BSIssueRecordI</IndexLocation>
<StreamLocation>^dbo.BSIssueRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
