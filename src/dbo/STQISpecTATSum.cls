Class dbo.STQISpecTATSum Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = ST_QISpecTATSum ]
{

Index IndexMaster On (HospCodeDR, OPDateType, OPDate, OPDataType, OPDataCode, ReqType, TimeInterval) [ SqlName = Index_Master, Type = index, Unique ];

/// DDL Primary Key Specification
Index PKSTQISpecTATSum On RowID [ PrimaryKey, SqlName = PK_ST_QISpecTATSum, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 999999999999999999, MINVAL = -999999999999999999) [ Identity, Required, SqlColumnNumber = 2 ];

Property HospCodeDR As %Library.Integer [ Required, SqlColumnNumber = 3 ];

/// 统计时间类型(1申请，2采集，3运送，4接收，5核收(按条码数)，6审核(按条码数))
Property OPDateType As %Library.Integer [ Required, SqlColumnNumber = 4 ];

/// 统计日期(申请日期，采集日期，运送日期，接收日期，核收日期，审核日期)
Property OPDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

/// 统计类型(1申请科室，2工作组，3工组小组，4用户)
Property OPDataType As %Library.Integer [ Required, SqlColumnNumber = 6 ];

/// 代码（申请科室，工作组，工组小组，用户）(空值转换成"-1")DR
Property OPDataCode As %Library.Integer [ Required, SqlColumnNumber = 7 ];

/// 统计病人类型(AdmissionTypeDR_","_Urgent)
Property ReqType As %Library.String(COLLATION = "Exact", MAXLEN = 3) [ Required, SqlColumnNumber = 8 ];

/// 时间段内归类(0.5,1,1.5,2,2.5,3,3.5,…,23,23.5,24) [x-0.5<=x<x+0.5]
Property TimeInterval As %Library.Float [ Required, SqlColumnNumber = 9 ];

/// 标本数
Property SPSum As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 10 ];

/// 金额数
Property BillSum As %Library.Float [ Required, SqlColumnNumber = 11 ];

Storage Default
{
<Data name="STQISpecTATSumDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HospCodeDR</Value>
</Value>
<Value name="3">
<Value>OPDateType</Value>
</Value>
<Value name="4">
<Value>OPDate</Value>
</Value>
<Value name="5">
<Value>OPDataType</Value>
</Value>
<Value name="6">
<Value>OPDataCode</Value>
</Value>
<Value name="7">
<Value>ReqType</Value>
</Value>
<Value name="8">
<Value>TimeInterval</Value>
</Value>
<Value name="9">
<Value>SPSum</Value>
</Value>
<Value name="10">
<Value>BillSum</Value>
</Value>
</Data>
<DataLocation>^dbo.STQISpecTATSumD</DataLocation>
<DefaultData>STQISpecTATSumDefaultData</DefaultData>
<IdLocation>^dbo.STQISpecTATSumD</IdLocation>
<IndexLocation>^dbo.STQISpecTATSumI</IndexLocation>
<StreamLocation>^dbo.STQISpecTATSumS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
