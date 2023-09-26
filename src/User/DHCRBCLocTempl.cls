Class User.DHCRBCLocTempl Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLC_RowID, SqlTableName = DHCRBC_LocTempl, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DLC_Loc_DR
Property DLCLocDR As %String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = DLC_Loc_DR ];

/// DLC_ModCat_DR
Property DLCModCatDR As User.DHCRBCTemplCat [ SqlColumnNumber = 3, SqlFieldName = DLC_ModCat_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCTemplSet("LocTempl"))</SqlIdExpression>
<SQLMap name="IndexLoc">
<Global>^DHCRBCTemplSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DLC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Loc_Templ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLC_Loc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterDataIndex">
<Data name="DLC_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLC_ModCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCTemplSet</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DLC_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LocTempl"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCLocTemplS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
