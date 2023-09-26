Class User.DHCAppRepLog Extends %Persistent [ SqlRowIdName = AR_RowID, SqlTableName = DHC_AppRepLog, StorageStrategy = SQLStorage ]
{

/// AR_Pointer	项目id
Property ARPointer As %Library.String [ SqlColumnNumber = 2, SqlFieldName = AR_Pointer ];

/// AR_Type	"A"-检查申请,"P"-病理申请
Property ARType As %Library.String(DISPLAYLIST = ",A,P", MAXLEN = 3, SELECTIVITY = "25%", VALUELIST = ",A,P") [ SqlColumnNumber = 3, SqlFieldName = AR_Type ];

/// AR_Oeori_Dr	医嘱id
Property AROeoriDr As User.OEOrdItem [ SqlColumnNumber = 4, SqlFieldName = AR_Oeori_Dr ];

/// AR_OpeUserCode	操作员代码
Property AROpeUserCode As %Library.String [ SqlColumnNumber = 5, SqlFieldName = AR_OpeUserCode ];

/// AR_OpeUser	操作员
Property AROpeUser As %Library.String [ SqlColumnNumber = 6, SqlFieldName = AR_OpeUser ];

/// AR_Status_Dr	报告状态
Property ARStatusDr As User.OECResultStatus [ SqlColumnNumber = 7, SqlFieldName = AR_Status_Dr ];

/// AR_Date	  操作日期
Property ARDate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = AR_Date ];

/// AR_Time	操作时间
Property ARTime As %Library.Time [ SqlColumnNumber = 9, SqlFieldName = AR_Time ];

/// AR_Reason	操作原因
Property ARReason As %Library.String [ SqlColumnNumber = 10, SqlFieldName = AR_Reason ];

/// AR_PisStuNo	病理号
Property ARPisStuNo As %Library.String [ SqlColumnNumber = 11, SqlFieldName = AR_PisStuNo ];

/// AR_EQTxt	设备
Property AREQTxt As %Library.String [ SqlColumnNumber = 12, SqlFieldName = AR_EQTxt ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCAPPRL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="AR_Date">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="AR_EQTxt">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="AR_Oeori_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="AR_OpeUser">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="AR_OpeUserCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="AR_PisStuNo">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="AR_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="AR_Reason">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="AR_Status_Dr">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="AR_Time">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="AR_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCAPPRL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexTypePointer">
<Global>^DHCAPPRL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>AR_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{AR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{AR_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{AR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCAppRepLogS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
