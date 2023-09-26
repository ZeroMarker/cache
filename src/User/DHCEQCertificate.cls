Class User.DHCEQCertificate Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = C_RowID, SqlTableName = DHC_EQCertificate, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// C_CertificateType
Property CCertificateType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = C_CertificateType ];

/// C_CertificateNo
Property CCertificateNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = C_CertificateNo ];

/// C_CertificateDate
Property CCertificateDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = C_CertificateDate ];

/// C_CertificateUserDR
Property CCertificateUserDR As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = C_CertificateUserDR ];

/// C_CertificateFee
Property CCertificateFee As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = C_CertificateFee ];

/// C_Remark
Property CRemark As %Library.String(COLLATION = "Exact", MAXLEN = 300, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = C_Remark ];

/// C_Hold1
Property CHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = C_Hold1 ];

/// C_Hold2
Property CHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = C_Hold2 ];

/// C_Hold3
Property CHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = C_Hold3 ];

/// C_Hold4
Property CHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = C_Hold4 ];

/// C_Hold5
Property CHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = C_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCertificate("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="C_CertificateDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="C_CertificateFee">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="C_CertificateNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="C_CertificateType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="C_CertificateUserDR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="C_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="C_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="C_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="C_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="C_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="C_Remark">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^DHCEQCertificate</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>C_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{C_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCertificateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
