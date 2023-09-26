/// 取回执单提示
Class dbo.BTTestSetReceipt Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = BT_TestSetReceipt ]
{

Index IndexTestSetDR On (TestSetDR, FestivalWeek, AdmissionTypeDR) [ SqlName = Index_TestSetDR, Type = index ];

/// DDL Primary Key Specification
Index PKBTTestSetReceipt On RowID [ PrimaryKey, SqlName = PK_BT_TestSetReceipt, Type = index, Unique ];

/// Foreign Key FKVisitNumberAdmType created via DDL
ForeignKey FKTestSetReceiptAdmType(AdmissionTypeDR) References dbo.BTAdmissionType(PKBTADMISSIONTYPE) [ SqlName = FK_TestSetReceiptAdmType ];

/// Foreign Key FKVisitNumberHospital created via DDL
ForeignKey FKTestSetReceiptHospital(HospitalDR) References dbo.BTHospital(PKBTHOSPITAL) [ SqlName = FK_TestSetReceiptHospital ];

/// 主键  
Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

/// 医嘱  
Property TestSetDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 3 ];

/// 节假日  
Property FestivalWeek As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 4 ];

/// 优先级  
Property Priority As %Library.String(COLLATION = "Exact", MAXLEN = 30) [ SqlColumnNumber = 5 ];

/// 开始时间  
Property StartTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

/// 结束时间  
Property EndTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 7 ];

/// 取回执单提示  
Property GetRecTip As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 8 ];

/// 就诊类型  
Property AdmissionTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 9 ];

/// 采集说明  
Property CollectRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 10 ];

/// 取报告说明  
Property GetRepRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300) [ SqlColumnNumber = 11 ];

///       
Property Urgent As %Library.Boolean [ SqlColumnNumber = 12 ];

///       
Property Type As %Library.String(COLLATION = "Exact", MAXLEN = 5) [ SqlColumnNumber = 13 ];

/// 医院 
Property HospitalDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

Storage Default
{
<Data name="BTTestSetReceiptDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestSetDR</Value>
</Value>
<Value name="3">
<Value>FestivalWeek</Value>
</Value>
<Value name="4">
<Value>Priority</Value>
</Value>
<Value name="5">
<Value>StartTime</Value>
</Value>
<Value name="6">
<Value>EndTime</Value>
</Value>
<Value name="7">
<Value>GetRecTip</Value>
</Value>
<Value name="8">
<Value>AdmissionTypeDR</Value>
</Value>
<Value name="9">
<Value>CollectRemark</Value>
</Value>
<Value name="10">
<Value>GetRepRemark</Value>
</Value>
<Value name="11"/>
<Value name="12">
<Value>Urgent</Value>
</Value>
<Value name="13">
<Value>Type</Value>
</Value>
<Value name="14">
<Value>HospitalDR</Value>
</Value>
</Data>
<DataLocation>^dbo.BTTestSetReceiptD</DataLocation>
<DefaultData>BTTestSetReceiptDefaultData</DefaultData>
<IdLocation>^dbo.BTTestSetReceiptD</IdLocation>
<IndexLocation>^dbo.BTTestSetReceiptI</IndexLocation>
<StreamLocation>^dbo.BTTestSetReceiptS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
