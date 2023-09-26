/// CT Location List Locations(1647)
Class User.CTLocationListLocations Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_LocationList_Locations, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LOCChildsub [ IdKey, PrimaryKey, Unique ];

/// CT_LocationList Parent Reference
Relationship LOCParRef As CTLocationList [ Cardinality = parent, Inverse = ChildCTLocationListLocations, Required, SqlFieldName = LOC_ParRef ];

/// Childsub
Property LOCChildsub As %Float [ InitialExpression = {$i(^CT("LL",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LOC",0))}, SqlColumnNumber = 2, SqlFieldName = LOC_Childsub ];

/// Des Ref CTLOC
Property LOCCTLOCDR As CTLoc [ SqlColumnNumber = 3, SqlFieldName = LOC_CTLOC_DR ];

/// Hospital CT des ref
Property LOCHospitalCTDR As CTHospital [ SqlColumnNumber = 4, SqlFieldName = LOC_HospitalCT_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTLocationListLocations).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocationListLocations","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTLocationListLocations).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocationListLocations","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTLocationListLocations).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocationListLocations","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTLocationListLocations).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocationListLocations","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTLocationListLocations).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTLocationListLocations","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="LOC_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LOC_HospitalCT_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^CT</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_LocationList.LL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_LocationList.LL_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLoc">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CT_LocationList.LL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CT_LocationList.LL_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LOC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLoc1">
<Global>^CT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CT_LocationList.LL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LOC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Loc1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LOC_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CT_LocationList.LL_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LOC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LOC_RowId</SqlRowIdName>
<StreamLocation>^User.CTLocationListLocationsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
