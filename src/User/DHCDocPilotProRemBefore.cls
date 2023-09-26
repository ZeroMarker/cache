Class User.DHCDocPilotProRemBefore Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PPEB_RowId, SqlTableName = DHC_DocPilotProRemBefore, StorageStrategy = SQLStorage ]
{

/// PPEB_RemAmount：汇款金额
Property RemAmount As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = PPEB_RemAmount ];

Property Name As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = PPEB_Name ];

Property Department As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PPEB_Department ];

Property StartUser As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = PPEB_StartUser ];

Property ProjectName As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = PPEB_ProjectName ];

Property Remitter As %Library.String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = PPEB_Remitter ];

Property Date As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 8, SqlFieldName = PPEB_Date ];

/// PPEB_Remark：备注
Property Remark As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = PPEB_Remark ];

/// PPEB_state:状态 A:申请 V:确认到账
Property State As %Library.String(DISPLAYLIST = ",Apply,Verify", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",A,V") [ SqlColumnNumber = 10, SqlFieldName = PPEB_State ];

/// PPR_Account账号
Property Account As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = PPEB_Account ];

/// PPR_Type:类型 I:IEC B:备案费
Property Type As %Library.String(DISPLAYLIST = ",IEC,BAF", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",I,B") [ SqlColumnNumber = 12, SqlFieldName = PPEB_Type ];

Property ProjectDr As User.DHCDocPilotProject [ SqlColumnNumber = 13, SqlFieldName = PPEB_PProject_Dr ];

Property FirstPay As %Library.String(COLLATION = "Exact", MAXLEN = 3, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = PPEB_FirstPay ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCDocPPEB)</SqlIdExpression>
<SQLMap name="DataMasterIndex">
<Data name="PPEB_Account">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PPEB_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PPEB_Department">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PPEB_FirstPay">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PPEB_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PPEB_PProject_Dr">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PPEB_ProjectName">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PPEB_RemAmount">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PPEB_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PPEB_Remitter">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PPEB_StartUser">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PPEB_State">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PPEB_Type">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Global>^DHCDocPPEB</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PPEB_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PPEB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCDocPilotProRemBeforeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
