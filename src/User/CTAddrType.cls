/// CT Address Type           (CTADR,4)
Class User.CTAddrType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_AddrType, StorageStrategy = SQLStorage ]
{

/// Address Type Code
Property CTADRCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = CTADR_Code ];

/// Address Type Description
Property CTADRDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = CTADR_Desc ];

/// Block
Property CTADRBlk As %Float(MAXVAL = 2, MINVAL = 0) [ InitialExpression = 0, SqlColumnNumber = 5, SqlFieldName = CTADR_Blk ];

/// Level (allow input?)
Property CTADRLevel As %Float(MAXVAL = 2, MINVAL = 0) [ InitialExpression = 0, SqlColumnNumber = 6, SqlFieldName = CTADR_Level ];

/// Unit (allow input?)
Property CTADRUnit As %Float(MAXVAL = 2, MINVAL = 0) [ InitialExpression = 0, SqlColumnNumber = 7, SqlFieldName = CTADR_Unit ];

/// Postal Code (allow input?)
Property CTADRZip As %Float(MAXVAL = 2, MINVAL = 0) [ InitialExpression = 0, SqlColumnNumber = 8, SqlFieldName = CTADR_Zip ];

/// Street Name (allow input?)
Property CTADRStreet As %Float(MAXVAL = 2, MINVAL = 0) [ InitialExpression = 0, SqlColumnNumber = 9, SqlFieldName = CTADR_Street ];

/// Date From
Property CTADRDateFrom As %Date [ SqlColumnNumber = 12, SqlFieldName = CTADR_DateFrom ];

/// Date To
Property CTADRDateTo As %Date [ SqlColumnNumber = 13, SqlFieldName = CTADR_DateTo ];

/// Priority
Property CTADRPriority As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CTADR_Priority ];

/// RestrictFromLookUp
Property CTADRRestrictFromLookUp As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = CTADR_RestrictFromLookUp ];

/// Mail
Property CTADRMail As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = CTADR_Mail ];

Index CTADRCodeUnqIdx1 On CTADRCode [ Unique ];

Index CTADRDescUnqIdx2 On CTADRDesc [ Unique ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTAddrType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAddrType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTAddrType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAddrType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTAddrType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAddrType","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTAddrType).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAddrType","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAddrType","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTAddrType).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTAddrType","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CT("ADR",0))</SqlIdExpression>
<SQLMap name="DataMasterCTADR">
<Data name="CTADR_Blk">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CTADR_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CTADR_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CTADR_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CTADR_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CTADR_Level">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CTADR_Mail">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="CTADR_Priority">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="CTADR_RestrictFromLookUp">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="CTADR_Street">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CTADR_Unit">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CTADR_Zip">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CTADR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ADR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{CTADR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTADRCode">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTADR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ADR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTADR_Code})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTADR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexCTADRDesc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CTADR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"ADR"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({CTADR_Desc})</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{CTADR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CTADR_RowId</SqlRowIdName>
<StreamLocation>^User.CTAddrTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
