/// INC Item Location Batch (INCLB,375)
Class User.INCItmLcBt Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = INC_ItmLcBt, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INCLBChildSub [ IdKey, PrimaryKey, Unique ];

/// INCIL Par Ref
Relationship INCLBINCILParRef As INCItmLoc [ Cardinality = parent, Inverse = ChildINCItmLcBt, Required, SqlFieldName = INCLB_INCIL_ParRef ];

/// INCLB ChildSub (NewKey)
Property INCLBChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INCI($p($s($d(initvalue):initvalue,1:%d(0)),"||",1),"IL",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"LB",0))}, SqlColumnNumber = 2, SqlFieldName = INCLB_ChildSub ];

/// Physical Quantity 
Property INCLBPhyQty As %Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ InitialExpression = 0, Required, SqlColumnNumber = 3, SqlComputeCode = { i {INCLB_INCIB_DR}="" s {INCLB_PhyQty}="" q
 s {INCLB_PhyQty}=0
}, SqlComputed, SqlComputeOnChange = INCLBINCIBDR, SqlFieldName = INCLB_PhyQty ];

/// Des Ref to INCIB
Property INCLBINCIBDR As INCItmBat [ Required, SqlColumnNumber = 6, SqlFieldName = INCLB_INCIB_DR ];

/// Dirty Qty
Property INCLBDirtyQty As %Float [ SqlColumnNumber = 7, SqlFieldName = INCLB_DirtyQty ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INCItmLcBt).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLcBt","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INCItmLcBt).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLcBt","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INCItmLcBt).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLcBt","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INCItmLcBt).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLcBt","OnBeforeDelete")
 
 d VALDEL^at375
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INCItmLcBt).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLcBt","OnBeforeUpdate")
 
 d VALUPD^at375
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCItmLcBt","OnBeforeInsert")
 
 d VALINS^at375
}

Storage SQLStorage
{
<ExtentSize>189</ExtentSize>
<Property name="INCLBChildSub">
<Selectivity>5.8824%</Selectivity>
</Property>
<Property name="INCLBDirtyQty">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INCLBINCIBDR">
<Selectivity>0.6993%</Selectivity>
</Property>
<Property name="INCLBINCILParRef">
<Selectivity>1.2195%</Selectivity>
</Property>
<Property name="INCLBPhyQty">
<Selectivity>1.5152%</Selectivity>
</Property>
<SQLMap name="DataMasterINCLB">
<Data name="INCLB_DirtyQty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INCLB_INCIB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INCLB_PhyQty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^INCI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INC_ItmLoc.INCIL_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INCLB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INC_Itm.INCI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"IL"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INC_ItmLoc.INCIL_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"LB"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INCLB_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINCIBDR">
<Global>^INCI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>INC_Itm.INCI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>INC_ItmLoc.INCIL_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INCLB_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>"LB_IB"</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>{INCLB_INCIB_DR}</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INC_Itm.INCI_RowId}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INC_ItmLoc.INCIL_ChildSub}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INCLB_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INCLB_RowId</SqlRowIdName>
<StreamLocation>^User.INCItmLcBtS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
