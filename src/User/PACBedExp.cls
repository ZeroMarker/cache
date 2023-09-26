/// PAC Bed Expand 
/// created by caihaozhe @2015-4-3 
Class User.PACBedExp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = PAC_BedExp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On EXPChildsub [ IdKey, PrimaryKey, Unique ];

/// PAC_Bed Parent Reference
Relationship EXPParRef As PACBed [ Cardinality = parent, Inverse = ChildPACBedExp, Required, SqlFieldName = EXP_ParRef ];

/// Childsub
Property EXPChildsub As %Float [ InitialExpression = {$i(^PAWARDA($p($s($d(initvalue):initvalue,1:%d(0)),"||",1),"BED",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"EXP",0))}, SqlColumnNumber = 2, SqlFieldName = EXP_Childsub ];

/// Des Ref Loc
Property EXPLocDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = EXP_Loc_DR ];

/// PACBed Organization
Property EXPBedOrganizationDR As PACBedOrganization [ SqlColumnNumber = 4, SqlFieldName = EXP_BedOrganization_DR ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="EXP_BedOrganization_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EXP_Loc_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAWARDA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAC_Ward.WARD_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PAC_Bed.BED_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>EXP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PAC_Ward.WARD_RowID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BED"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PAC_Bed.BED_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"EXP"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EXP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>EXP_RowId</SqlRowIdName>
<StreamLocation>^User.PACBedExpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
