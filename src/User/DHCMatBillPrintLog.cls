Class User.DHCMatBillPrintLog Extends (%Persistent, User.Abstract) [ SqlRowIdName = PRT_RowID, SqlTableName = DHC_MatBillPrintLog ]
{

Parameter EXTENTSIZE = 25000;

Property PRTType As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PRT_Type ];

Property PRTNo As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PRT_No ];

Property PRTPointer As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PRT_Pointer ];

Property PRTSSUSRDR As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = PRT_SSUSR_DR ];

Property PRTDate As %Library.Date(FORMAT = 4) [ SqlColumnNumber = 6, SqlFieldName = PRT_Date ];

Property PRTTime As %Library.Time [ SqlColumnNumber = 7, SqlFieldName = PRT_Time ];

/// 打印方式
Property PRTMode As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = PRT_Mode ];

Property PRTCompleted As %Library.String(COLLATION = "Exact", DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", VALUELIST = ",Y,N") [ SqlColumnNumber = 9, SqlFieldName = PRT_Completed ];

/// 状态
Property PRTStatus As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 10, SqlFieldName = PRT_Status ];

/// 打印次数
Property PRTCount As %Library.String(COLLATION = "Exact") [ SqlColumnNumber = 11, SqlFieldName = PRT_Count ];

Index IndexTypePointer On (PRTType As Exact, PRTPointer As Exact);

Storage Default
{
<Data name="DHCMatBillPrintLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PRTType</Value>
</Value>
<Value name="3">
<Value>PRTNo</Value>
</Value>
<Value name="4">
<Value>PRTPointer</Value>
</Value>
<Value name="5">
<Value>PRTSSUSRDR</Value>
</Value>
<Value name="6">
<Value>PRTDate</Value>
</Value>
<Value name="7">
<Value>PRTTime</Value>
</Value>
<Value name="8">
<Value>PRTMode</Value>
</Value>
<Value name="9">
<Value>PRTCompleted</Value>
</Value>
<Value name="10">
<Value>PRTStatus</Value>
</Value>
<Value name="11">
<Value>PRTCount</Value>
</Value>
</Data>
<DataLocation>^User.DHCMatBillPrintLogD</DataLocation>
<DefaultData>DHCMatBillPrintLogDefaultData</DefaultData>
<ExtentSize>25000</ExtentSize>
<IdLocation>^User.DHCMatBillPrintLogD</IdLocation>
<IndexLocation>^User.DHCMatBillPrintLogI</IndexLocation>
<SqlRowIdName>PRT_RowID</SqlRowIdName>
<StreamLocation>^User.DHCMatBillPrintLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
