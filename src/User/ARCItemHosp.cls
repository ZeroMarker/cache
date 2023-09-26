/// Item Hosp(2678)
Class User.ARCItemHosp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemHosp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On HOSPChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_ItmMast Parent Reference
Relationship HOSPParRef As ARCItmMast [ Cardinality = parent, Inverse = ChildARCItemHosp, Required, SqlFieldName = HOSP_ParRef ];

/// Childsub
Property HOSPChildsub As %Float [ InitialExpression = {$i(^ARCIM($p($s($d(initvalue):initvalue,1:%d(0)),"||"),1,"HOSP",0))}, SqlColumnNumber = 2, SqlFieldName = HOSP_Childsub ];

/// Des Ref Hospital
Property HOSPHospitalDR As CTHospital [ SqlColumnNumber = 3, SqlFieldName = HOSP_Hospital_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemHosp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemHosp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemHosp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemHosp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemHosp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemHosp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemHosp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemHosp","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemHosp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemHosp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="HOSP_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^ARCIM</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L4}</Expression>
<Field>HOSP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{HOSP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexHosp">
<Global>^ARCIM</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>ARC_ItmMast.ARCIM_Subscript</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L2}</Expression>
<Field>ARC_ItmMast.ARCIM_Version</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>HOSP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{ARC_ItmMast.ARCIM_Subscript}</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItmMast.ARCIM_Version}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HOSP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Hosp"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{HOSP_Hospital_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{HOSP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>HOSP_RowId</SqlRowIdName>
<StreamLocation>^User.ARCItemHospS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
