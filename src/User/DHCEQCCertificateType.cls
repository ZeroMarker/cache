Class User.DHCEQCCertificateType Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHC_EQCCertificateType, StorageStrategy = SQLStorage ]
{

/// CT_Code
Property CTCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = CT_Code ];

/// CT_Desc
Property CTDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = CT_Desc ];

/// CT_Remark
Property CTRemark As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = CT_Remark ];

/// CT_InvalidFlag
Property CTInvalidFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = CT_InvalidFlag ];

/// CT_Hold1
Property CTHold1 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = CT_Hold1 ];

/// CT_Hold2
Property CTHold2 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = CT_Hold2 ];

/// CT_Hold3
Property CTHold3 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = CT_Hold3 ];

/// CT_Hold4
Property CTHold4 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = CT_Hold4 ];

/// CT_Hold5
Property CTHold5 As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = CT_Hold5 ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCCertificateType",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CT_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CT_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CT_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CT_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CT_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CT_InvalidFlag">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CT_Remark">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"DHCEQCCertificateType"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CT_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CT_RowID</SqlRowIdName>
<StreamLocation>^User.DHCEQCCertificateTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
