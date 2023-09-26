/// 汇总手术用血信息
Class dbo.BSOperation Extends (%Persistent, %XML.Adaptor) [ Owner = {UnknownUser}, SqlTableName = BS_Operation ]
{

Index IndexMaster On (HospDR, OperationDate, OperationId, AdmId) [ SqlName = Index_Master, Type = index ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// DDL Primary Key Specification
Index PKBSOperationId On RowID [ PrimaryKey, Type = index, Unique ];

/// 医院
Property HospDR As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ Required, SqlColumnNumber = 3 ];

/// 手术日期
Property OperationDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

/// 手术Id
Property OperationId As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 手术医生Code
Property OPSurgeonId As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 6 ];

/// 手术医生
Property OPSurgeon As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 7 ];

/// 手术类型
Property OperationType As %Library.String(COLLATION = "Exact", MAXLEN = 50) [ Required, SqlColumnNumber = 8 ];

/// 就诊号
Property AdmId As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 9 ];

/// 手术等级
Property OperationASA As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 10 ];

/// 手术名称
Property OperationName As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 11 ];

/// 手术编码
Property OperationCode As %Library.String(COLLATION = "Exact", MAXLEN = 200) [ Required, SqlColumnNumber = 12 ];

Storage Default
{
<Data name="BSOperationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospDR</Value>
</Value>
<Value name="3">
<Value>OperationDate</Value>
</Value>
<Value name="4">
<Value>OperationId</Value>
</Value>
<Value name="5">
<Value>OPSurgeonId</Value>
</Value>
<Value name="6">
<Value>OPSurgeon</Value>
</Value>
<Value name="7">
<Value>OperationType</Value>
</Value>
<Value name="8">
<Value>AdmId</Value>
</Value>
<Value name="9">
<Value>OperationASA</Value>
</Value>
<Value name="10">
<Value>OperationName</Value>
</Value>
<Value name="11">
<Value>OperationCode</Value>
</Value>
</Data>
<DataLocation>^dbo.BSOperationD</DataLocation>
<DefaultData>BSOperationDefaultData</DefaultData>
<IdLocation>^dbo.BSOperationD</IdLocation>
<IndexLocation>^dbo.BSOperationI</IndexLocation>
<StreamLocation>^dbo.BSOperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
