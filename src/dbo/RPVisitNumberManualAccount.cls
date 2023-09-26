Class dbo.RPVisitNumberManualAccount Extends %Persistent [ ClassType = persistent, DdlAllowed, Owner = {UnknownUser}, ProcedureBlock, SqlRowIdPrivate, SqlTableName = RP_VisitNumberManualAccount ]
{

ForeignKey VisitNumberDR(VisitNumberDR) References dbo.RPVisitNumber(PKRPVISITNUMBER);

/// FKRPVisitNumberManualAccountOperator
ForeignKey OperateUserDR(OperateUserDR) References dbo.SYSUser(PKSYSUSER);

ForeignKey OperateTypeDR(OperateTypeDR) References dbo.BTOperatorType(PKBTOPERATORTYPE);

ForeignKey WorkGroupDR(WorkGroupDR) References dbo.BTWorkGroup(PKBTWORKGROUP);

Index IndexMaster On (VisitNumberDR, OperateDate, OperateTime) [ SqlName = Index_Master, Type = index, Unique ];

Index IndexReport On (VisitNumberReportDR, OperateDate, OperateTime) [ SqlName = Index_Report, Type = index, Unique ];

Index IndexOperateDate On (OperateDate, OperateTypeDR) [ SqlName = Index_OperateDate, Type = index ];

Index IndexOrdItem On (VisitNumberDR, OrdItem, OperateTypeDR) [ SqlName = Index_OrdItem, Type = index ];

Index IndexOperateType On (VisitNumberDR, OperateTypeDR) [ SqlName = Index_OperateType, Type = index ];

/// DDL Primary Key Specification
Index IndexRowID On RowID [ PrimaryKey, SqlName = PK_RP_VISITNUMBERRECORD, Type = index, Unique ];

Property RowID As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Identity, SqlColumnNumber = 2 ];

Property VisitNumberDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 3 ];

Property OperateDate As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 4 ];

Property OperateTime As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ Required, SqlColumnNumber = 5 ];

Property OperateUserDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 6 ];

Property OrderitemDR As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 7 ];

Property Quantity As %Library.Float [ SqlColumnNumber = 8 ];

Property Price As %Library.Numeric(MAXVAL = 999999999999999.9999, MINVAL = -999999999999999.9999, SCALE = 4) [ SqlColumnNumber = 9 ];

Property OperateTypeDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 10 ];

Property WorkGroupDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 11 ];

// 医嘱项

Property OrdItem As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 12 ];

// 添加类型DOC医生

Property AddType As %Library.String(COLLATION = "Exact", MAXLEN = 10) [ SqlColumnNumber = 13 ];

Property VisitNumberReportDR As %Library.Integer(MAXVAL = 2147483647, MINVAL = -2147483648) [ SqlColumnNumber = 14 ];

// 医嘱项代码

Property OrderItemCode As %Library.String(COLLATION = "Exact", MAXLEN = 100) [ SqlColumnNumber = 15 ];

Storage Default
{
<Data name="RPVisitNumberManualAccountDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>VisitNumberDR</Value>
</Value>
<Value name="3">
<Value>OperateDate</Value>
</Value>
<Value name="4">
<Value>OperateTime</Value>
</Value>
<Value name="5">
<Value>OperateUserDR</Value>
</Value>
<Value name="6">
<Value>OrderitemDR</Value>
</Value>
<Value name="7">
<Value>Quantity</Value>
</Value>
<Value name="8">
<Value>Price</Value>
</Value>
<Value name="9">
<Value>OperateTypeDR</Value>
</Value>
<Value name="10">
<Value>WorkGroupDR</Value>
</Value>
<Value name="11">
<Value>OrdItem</Value>
</Value>
<Value name="12">
<Value>AddType</Value>
</Value>
<Value name="13">
<Value>VisitNumberReportDR</Value>
</Value>
<Value name="14">
<Value>OrderItemCode</Value>
</Value>
</Data>
<DataLocation>^dbo.RPVisitNumberManualAccountD</DataLocation>
<DefaultData>RPVisitNumberManualAccountDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^dbo.RPVisitNumberManualAccountD</IdLocation>
<IndexLocation>^dbo.RPVisitNumberManualAccountI</IndexLocation>
<StreamLocation>^dbo.RPVisitNumberManualAccountS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
