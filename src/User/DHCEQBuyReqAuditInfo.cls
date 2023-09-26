Class User.DHCEQBuyReqAuditInfo Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = BRAI_RowID, SqlTableName = DHC_EQBuyReqAuditInfo, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// BRAI_BuyRequestListDR
Property BRALBuyRequestListDR As User.DHCEQBuyRequestList [ SqlColumnNumber = 2, SqlFieldName = BRAI_BuyRequestListDR ];

/// BRAI_Step
Property BRAIStep As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = BRAI_Step ];

/// BRAI_ActionDR
Property BRAIActionDR As User.DHCEQCAction [ SqlColumnNumber = 4, SqlFieldName = BRAI_ActionDR ];

/// BRAI_AuditQuantity
Property BRAIAuditQuantity As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = BRAI_AuditQuantity ];

/// BRAI_AuditPrice
Property BRAIAuditPrice As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = BRAI_AuditPrice ];

/// BRAI_AuditTotalFee
Property BRAIAuditTotalFee As %Library.Float [ SqlColumnNumber = 7, SqlFieldName = BRAI_AuditTotalFee ];

/// BRAI_Hold1
Property BRLHold1 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 8, SqlFieldName = BRAI_Hold1 ];

/// BRAI_Hold2
Property BRAIHold2 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = BRAI_Hold2 ];

/// BRAI_Hold3
Property BRAIHold3 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = BRAI_Hold3 ];

/// BRAI_Hold4
Property BRAIHold4 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 11, SqlFieldName = BRAI_Hold4 ];

/// BRAI_Hold5
Property BRAIHold5 As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 12, SqlFieldName = BRAI_Hold5 ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCEQBuyReqAuditInfo("0"))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BRAI_ActionDR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BRAI_AuditPrice">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="BRAI_AuditQuantity">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BRAI_AuditTotalFee">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="BRAI_BuyRequestListDR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BRAI_Hold1">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="BRAI_Hold2">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="BRAI_Hold3">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="BRAI_Hold4">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="BRAI_Hold5">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="BRAI_Step">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEQBuyReqAuditInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>BRAI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{BRAI_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBuyReqListStep">
<Global>^DHCEQBuyReqAuditInfo</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BRAI_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BuyRequestListStep"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BRAI_BuyRequestListDR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{BRAI_Step}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BRAI_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEQBuyReqAuditInfoS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
