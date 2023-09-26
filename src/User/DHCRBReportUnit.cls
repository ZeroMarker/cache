Class User.DHCRBReportUnit Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DMRSU_RowID, SqlTableName = DHCRB_Report_Unit, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On DMRSUChildSub [ IdKey, PrimaryKey, Unique ];

/// DHCRB_Report Parent Reference
Relationship DMRSUParRef As User.DHCRBReport [ Cardinality = parent, Inverse = ChildDHCRBReportUnit, Required, SqlFieldName = DMRSU_ParRef ];

/// Child subscript
Property DMRSUChildSub As %Library.Float [ InitialExpression = {$i(^DHCRB("DHCRBREPORTUNIT"))}, Required, SqlColumnNumber = 2, SqlFieldName = DMRSU_ChildSub ];

/// DMRSU_UnitCode
Property DMRSUUnitCode As %Library.String(COLLATION = "Exact", MAXLEN = 10, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DMRSU_UnitCode ];

/// DMRSU_Unit_DR
Property DMRSUUnitDR As User.DHCRBUnit [ SqlColumnNumber = 4, SqlFieldName = DMRSU_Unit_DR ];

/// DMRSU_UnitValue
Property DMRSUUnitValue As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = DMRSU_UnitValue ];

/// DMRSU_Units
Property DMRSUUnits As %Library.String(COLLATION = "Exact", MAXLEN = 16, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = DMRSU_Units ];

/// DMRSU_Desc
Property DMRSUDesc As %Library.String(COLLATION = "Exact", MAXLEN = 20, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = DMRSU_Desc ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="DataMasterMap">
<Data name="DMRSU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DMRSU_UnitCode">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DMRSU_UnitValue">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DMRSU_Unit_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DMRSU_Units">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCRBStudy</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_Report.DRPT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DMRSU_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ReportUnit"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_Report.DRPT_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DMRSU_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_Report.DRPT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DMRSU_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"UnitCode"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{DMRSU_UnitCode}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{DHCRB_Report.DRPT_RowID}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{DMRSU_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>DHCRB_Report.DRPT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>DMRSU_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"UnitDesc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DMRSU_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DHCRB_Report.DRPT_RowID}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DMRSU_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDescValue">
<Global>^DHCRBStudyi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHCRB_Report.DRPT_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>DMRSU_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"Desc-Value"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DMRSU_Desc}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DMRSU_UnitValue}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHCRB_Report.DRPT_RowID}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DMRSU_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCRBReportUnitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
