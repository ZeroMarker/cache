/// 科室管理组按人员维护
/// LiangQiang 2013-11-22
Class User.DHCLocUserManGrp Extends %Library.Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = LUMG_RowId, SqlTableName = DHC_LocUserManGrp, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 250;

Index RowIDBasedIDKeyIndex On LUMGChildSub [ IdKey, PrimaryKey, Unique ];

/// DHC_LocManGrp Parent Reference
Relationship LUMGParref As User.DHCLocManGrp [ Cardinality = parent, Inverse = ChildDHCLocUserManGrp, Required, SqlFieldName = LUMG_Parref ];

/// LUMG_ChildSub
Property LUMGChildSub As %Library.Float [ SqlColumnNumber = 2, SqlFieldName = LUMG_ChildSub ];

/// LUMG_SSUSR_DR
Property LUMGSSUSRDR As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = LUMG_SSUSR_DR ];

/// LUMG_Active
Property LUMGActive As %Library.String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, SELECTIVITY = "33.3333%", TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = LUMG_Active ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SQLMap name="IndexUser">
<Global>^DHCLMG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DHC_LocManGrp.LMG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>LUMG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"USER"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{LUMG_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DHC_LocManGrp.LMG_Rowid}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{LUMG_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="MasterData">
<Data name="LUMG_Active">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LUMG_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCLMG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DHC_LocManGrp.LMG_Rowid</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>LUMG_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<AccessType>Sub</AccessType>
<Expression>{DHC_LocManGrp.LMG_Rowid}</Expression>
</Subscript>
<Subscript name="2">
<AccessType>Sub</AccessType>
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>Sub</AccessType>
<Expression>{LUMG_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCLocUserManGrpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
