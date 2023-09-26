Class User.DHCPhaReserve Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = PRES_Rowid, SqlTableName = DHC_PhaReserve, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Relationship ChildDHCPhaReserveDetail As User.DHCPhaReserveDetail [ Cardinality = children, Inverse = PRDETPRESParref ];

/// PRES_CTLOC_DR
Property PRESCTLOCDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = PRES_CTLOC_DR ];

/// PRES_INCI_DR
Property PRESINCIDR As User.INCItm [ SqlColumnNumber = 3, SqlFieldName = PRES_INCI_DR ];

/// PRES_ResQty
Property PRESResQty As %Library.Float [ SqlColumnNumber = 4, SqlFieldName = PRES_ResQty ];

/// PRES_Ward_DR
Property PRESWardDR As User.PACWard [ SqlColumnNumber = 5, SqlFieldName = PRES_Ward_DR ];

/// PRES_Dept_DR
Property PRESDeptDR As User.CTLoc [ SqlColumnNumber = 6, SqlFieldName = PRES_Dept_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCPRES)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PRES_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRES_Dept_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PRES_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRES_ResQty">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PRES_Ward_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCPRES</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PRES_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{PRES_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDept">
<Global>^DHCPRES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PRES_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCINCIDEPT"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRES_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRES_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PRES_Dept_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PRES_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocINCIWard">
<Global>^DHCPRES</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>PRES_Rowid</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"LOCINCIWARD"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{PRES_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{PRES_INCI_DR}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{PRES_Ward_DR}</Expression>
</Subscript>
<Subscript name="6">
<AccessType>sub</AccessType>
<Expression>{PRES_Rowid}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaReserveS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
