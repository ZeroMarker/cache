Class User.DHCRBExposureNumber Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DEN_RowID, SqlTableName = DHCRB_Exposure_Number, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DEN_Loc_DR
Property DENLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DEN_Loc_DR ];

/// DEN_RegDate
Property DENRegDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 3, SqlFieldName = DEN_RegDate ];

/// DEN_Eq_DR
Property DENEqDR As User.RBCEquipment [ SqlColumnNumber = 4, SqlFieldName = DEN_Eq_DR ];

/// DEN_ReainNumber
Property DENReainNumber As %Library.Float [ SqlColumnNumber = 5, SqlFieldName = DEN_ReainNumber ];

/// DEN_MaxNumber
Property DENMaxNumber As %Library.Float [ SqlColumnNumber = 6, SqlFieldName = DEN_MaxNumber ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBExposureNumber)</SqlIdExpression>
<SQLMap name="IndexEq">
<Global>^DHCRBExposureNumberi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DEN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DEN_Eq_DR}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEN_RegDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^DHCRBExposureNumberi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DEN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DEN_Loc_DR}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEN_RegDate}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocEQ">
<Global>^DHCRBExposureNumberi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DEN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DEN_Loc_DR}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DEN_Eq_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DEN_RegDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DEN_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DEN_Eq_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DEN_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DEN_MaxNumber">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DEN_ReainNumber">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DEN_RegDate">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBExposureNumber</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DEN_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DEN_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBExposureNumberS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
