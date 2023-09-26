Class User.DHCRBCSerAvailableRes Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DSAR_RowID, SqlTableName = DHCRBC_SerAvailableRes, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DSAR_ServiceGroup_DR
Property DSARServiceGroupDR As User.RBCServiceGroup [ SqlColumnNumber = 2, SqlFieldName = DSAR_ServiceGroup_DR ];

/// DSAR_Resource_DR
Property DSARResourceDR As User.RBResource [ SqlColumnNumber = 3, SqlFieldName = DSAR_Resource_DR ];

/// DSAR_StartDate
Property DSARStartDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 4, SqlFieldName = DSAR_StartDate ];

/// DSAR_EndDate
Property DSAREndDate As %Library.Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = DSAR_EndDate ];

/// DSAR_ArcItmMast_DR
Property DSARArcItmMastDR As User.ARCItmMast [ SqlColumnNumber = 6, SqlFieldName = DSAR_ArcItmMast_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCSerAvailableRes)</SqlIdExpression>
<SQLMap name="IndexArcItemMast">
<Global>^DHCRBCSerAvailableResi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSAR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ARCITEMMAST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSAR_ArcItmMast_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSAR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResource">
<Global>^DHCRBCSerAvailableResi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSAR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"AvailableRes"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSAR_Resource_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSAR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexServiceGroup">
<Global>^DHCRBCSerAvailableResi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DSAR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Service-Group"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DSAR_ServiceGroup_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DSAR_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DSAR_ArcItmMast_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DSAR_EndDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DSAR_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DSAR_ServiceGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DSAR_StartDate">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCRBCSerAvailableRes</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DSAR_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{DSAR_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCSerAvailableResS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
