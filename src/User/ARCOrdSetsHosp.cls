/// OrdSetsHosp(2677)
Class User.ARCOrdSetsHosp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_OrdSetsHosp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HOSPChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_OrdSets Parent Reference
Relationship HOSPParRef As ARCOrdSets [ Cardinality = parent, Inverse = ChildARCOrdSetsHosp, Required, SqlFieldName = HOSP_ParRef ];

/// Childsub
Property HOSPChildsub As %Float [ InitialExpression = {$i(^ARCOS($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"HOSP",0))}, SqlColumnNumber = 2, SqlFieldName = HOSP_Childsub ];

/// Des Ref Hospital
Property HOSPHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = HOSP_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetsHosp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetsHosp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetsHosp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetsHosp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCOrdSetsHosp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetsHosp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCOrdSetsHosp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetsHosp","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCOrdSetsHosp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetsHosp","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCOrdSetsHosp","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="HOSP_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARCOS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>HOSP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{HOSP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^ARCOS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_OrdSets.ARCOS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>HOSP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_OrdSets.ARCOS_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{HOSP_Hospital_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{HOSP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HOSP_RowId</SqlRowIdName>
<StreamLocation>^User.ARCOrdSetsHospS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
