Class User.DHCRBCLocResourceSet Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DLRS_RowID, SqlTableName = DHCRBC_LocResourceSet, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

/// DLRS_AppLoc_DR
Property DLRSAppLocDR As User.CTLoc [ SqlColumnNumber = 2, SqlFieldName = DLRS_AppLoc_DR ];

/// DLRS_Resource_DR
Property DLRSResourceDR As User.RBResource [ SqlColumnNumber = 3, SqlFieldName = DLRS_Resource_DR ];

/// DLRS_Hospital_DR
Property DLRSHospitalDR As User.CTHospital [ SqlColumnNumber = 4, SqlFieldName = DLRS_Hospital_DR ];

/// DLRS_RecLoc_DR
Property DLRSRecLocDR As User.CTLoc [ SqlColumnNumber = 5, SqlFieldName = DLRS_RecLoc_DR ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCRBCLocResourceSet("LoginLocRes"))</SqlIdExpression>
<SQLMap name="IndexAppLoc">
<Global>^DHCRBCLocResourceSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DLRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"App-Loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLRS_AppLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHospital">
<Global>^DHCRBCLocResourceSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DLRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Hospital"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLRS_Hospital_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRecLoc">
<Global>^DHCRBCLocResourceSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DLRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Rec-Loc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLRS_RecLoc_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexResource">
<Global>^DHCRBCLocResourceSeti</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DLRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Booked-Resource"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLRS_Resource_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DLRS_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterMap">
<Data name="DLRS_AppLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DLRS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DLRS_RecLoc_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DLRS_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCRBCLocResourceSet</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DLRS_RowID</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LoginLocRes"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DLRS_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCRBCLocResourceSetS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
