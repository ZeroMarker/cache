Class User.DHCAccPayInvMedical Extends %Persistent [ SqlRowIdName = API_RowID, SqlTableName = DHC_AccPayInvMedical, StorageStrategy = SqlStorage ]
{

/// API_Amount
Property APIMAmount As %Float [ SqlColumnNumber = 2, SqlFieldName = API_Amount ];

/// API_Flag
Property APIFlag As %String(DISPLAYLIST = ",Normal,Abort,Strike", MAXLEN = 6, SELECTIVITY = "25.0000%", TRUNCATE = 1, VALUELIST = ",N,A,S") [ SqlColumnNumber = 3, SqlFieldName = API_Flag ];

/// API_Date
Property APIDate As %Date [ SqlColumnNumber = 4, SqlFieldName = API_Date ];

/// API_Time
Property APITime As %Time [ SqlColumnNumber = 5, SqlFieldName = API_Time ];

/// API_PUser_DR
Property APIPUserDR As %String [ SqlColumnNumber = 6, SqlFieldName = API_PUser_DR ];

/// API_INVNo
Property APIINVNo As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = API_INVNo ];

/// API_Handin
Property APIHandin As %String(DISPLAYLIST = ",Yes,No", SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 8, SqlFieldName = API_Handin ];

/// API_HandinDate
Property APIHandinDate As %Date [ SqlColumnNumber = 9, SqlFieldName = API_HandinDate ];

/// API_HandinTime
Property APIHandinTime As %Time [ SqlColumnNumber = 10, SqlFieldName = API_HandinTime ];

/// API_PayINV_DR
Property APIPayINVDR As %String [ SqlColumnNumber = 11, SqlFieldName = API_PayINV_DR ];

/// API_PAPMI_DR
Property APIPAPMIDR As %String [ SqlColumnNumber = 12, SqlFieldName = API_PAPMI_DR ];

/// API_INVRep_DR
Property APIINVRepDR As %String [ SqlColumnNumber = 13, SqlFieldName = API_INVRep_DR ];

Storage SqlStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCACCPAYINVMEDICAL)</SqlIdExpression>
<SQLMap name="MasterMap">
<Data name="API_Amount">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="API_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="API_Flag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="API_Handin">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="API_HandinDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="API_HandinTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="API_INVNo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="API_INVRep_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="API_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="API_PUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="API_PayINV_DR">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="API_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCACCPAYINVMEDICAL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>API_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{API_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCAccPayInvMedicalS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
