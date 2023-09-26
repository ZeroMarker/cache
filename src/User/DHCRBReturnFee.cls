Class User.DHCRBReturnFee Extends %Persistent [ ClassType = persistent, Not ProcedureBlock, SqlTableName = DHCRB_ReturnFee, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 252;

/// DRBR_OEORDITEM_DR
Property DRBROEORDITEMDR As OEOrdItem [ SqlColumnNumber = 2, SqlFieldName = DRBR_OEORDITEM_DR ];

/// DRBR_Count
Property DRBRCount As %Float [ SqlColumnNumber = 3, SqlFieldName = DRBR_Count ];

/// DRBR_USSER_DR
Property DRBRUSSERDR As SSUser [ SqlColumnNumber = 4, SqlFieldName = DRBR_USSER_DR ];

/// DRBR_DATE
Property DRBRDATE As %Date [ SqlColumnNumber = 5, SqlFieldName = DRBR_DATE ];

/// DRBR_Time
Property DRBRTime As %Time [ SqlColumnNumber = 6, SqlFieldName = DRBR_Time ];

/// DRBR_Reason_DR
Property DRBRReasonDR As DHCRBReturnReason [ SqlColumnNumber = 7, SqlFieldName = DRBR_Reason_DR ];

/// DRBR_Loc_DR
Property DRBRLocDR As CTLoc [ SqlColumnNumber = 8, SqlFieldName = DRBR_Loc_DR ];

/// DRBR_TotalPrice
Property DRBRTotalPrice As %Float [ SqlColumnNumber = 9, SqlFieldName = DRBR_TotalPrice ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBRF("Record"))</SqlIdExpression>
<SQLMap name="DataMasterIndex">
<Data name="DRBR_Count">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DRBR_DATE">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DRBR_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DRBR_OEORDITEM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DRBR_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DRBR_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DRBR_TotalPrice">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DRBR_USSER_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBRF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DRBR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Record"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRBR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOrditemRowid">
<Global>^DHCRBRFi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DRBR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Orderitem"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRBR_OEORDITEM_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRBR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="indexloc">
<Global>^DHCRBRFi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DRBR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LOC-DATE"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DRBR_Loc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DRBR_DATE}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DRBR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DRBR_RowID</SqlRowIdName>
<StreamLocation>^User.DHCRBReturnFeeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
