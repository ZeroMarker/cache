Class User.DHCEQCRoleReqFields Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = RRF_RowID, SqlTableName = DHC_EQCRoleReqFields, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// RRF_Field
Property RRFField As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = RRF_Field ];

/// RRF_ApproveSetDR
Property RRFFlowDR As User.DHCEQCApproveFlow [ SqlColumnNumber = 2, SqlFieldName = RRF_FlowDR ];

/// RRF_Hold1
Property RRFHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = RRF_Hold1 ];

/// RRF_Hold2
Property RRFHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = RRF_Hold2 ];

/// RRF_Hold3
Property RRFHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = RRF_Hold3 ];

/// RRF_Hold4
Property RRFHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = RRF_Hold4 ];

/// RRF_Hold5
Property RRFHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = RRF_Hold5 ];

/// RRF_RoleDR
Property RRFMustFlag As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 3, SqlFieldName = RRF_MustFlag ];

/// RRF_Position
Property RRFPosition As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = RRF_Position ];

/// RRF_Sort
Property RRFSort As %Library.Float [ SqlColumnNumber = 8, SqlFieldName = RRF_Sort ];

/// RRF_TableName
Property RRFTableName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = RRF_TableName ];

/// RRF_Type
Property RRFType As %Library.String(DISPLAYLIST = ",文本,日期,引用,数值,时间,选择", MAXLEN = 2, SELECTIVITY = "14.2857%", TRUNCATE = 1, VALUELIST = ",1,2,3,4,5,6") [ SqlColumnNumber = 5, SqlFieldName = RRF_Type ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQCCode("DHCEQCRoleReqFields",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RRF_Field">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RRF_FlowDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RRF_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="RRF_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="RRF_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="RRF_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="RRF_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="RRF_MustFlag">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RRF_Position">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RRF_Sort">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="RRF_TableName">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RRF_Type">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCEQCCode</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RRF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCRoleReqFields"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RRF_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFlow">
<Global>^DHCEQCCode</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>RRF_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DHCEQCRoleReqFields"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Flow"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RRF_FlowDR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RRF_Sort}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RRF_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQCRoleReqFieldsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
