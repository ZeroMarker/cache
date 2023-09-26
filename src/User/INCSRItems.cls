/// Central SterSystemItems(1127)
Class User.INCSRItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_CSR_Items, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CSRIChildsub [ IdKey, PrimaryKey, Unique ];

/// IN_CSR Parent Reference
Relationship CSRIParRef As INCSR [ Cardinality = parent, Inverse = ChildINCSRItems, Required, SqlFieldName = CSRI_ParRef ];

/// Childsub
Property CSRIChildsub As %Float [ InitialExpression = {$i(^INCSR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ITM",0))}, Required, SqlColumnNumber = 2, SqlFieldName = CSRI_Childsub ];

/// Des Ref to INCI
Property CSRIINCIDR As INCItm [ Required, SqlColumnNumber = 3, SqlFieldName = CSRI_INCI_DR ];

/// Qty Received
Property CSRIQtyReceived As %Float(MINVAL = 0) [ SqlColumnNumber = 4, SqlFieldName = CSRI_Qty_Received ];

/// Qty Returned Dirty
Property CSRIQtyReturnedDirty As %Float(MINVAL = 0) [ SqlColumnNumber = 5, SqlFieldName = CSRI_Qty_Returned_Dirty ];

/// Remarks
Property CSRIRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CSRI_Remarks, SqlListType = subnode ];

/// Qty_in_Ward
Property CSRIQtyinWard As %Float [ SqlColumnNumber = 7, SqlComputeCode = { s {CSRI_Qty_in_Ward}=$$CO07^at1127({CSRI_ParRef},{CSRI_INCI_DR},{CSRI_Qty_Received},{CSRI_Qty_Returned_Clean},{CSRI_Qty_Returned_Dirty},{CSRI_RowId})
}, SqlComputed, SqlFieldName = CSRI_Qty_in_Ward, Transient ];

/// Qty in Laundry
Property CSRIQtyinLaundry As %Float [ SqlColumnNumber = 8, SqlComputeCode = { s {CSRI_Qty_in_Laundry}=$$CO08^at1127({CSRI_ParRef},{CSRI_INCI_DR},{CSRI_Qty_Received},{CSRI_Qty_Returned_Clean},{CSRI_Qty_Returned_Dirty},{CSRI_RowId})
}, SqlComputed, SqlFieldName = CSRI_Qty_in_Laundry, Transient ];

/// Qty Returned Clean
Property CSRIQtyReturnedClean As %Float(MINVAL = 0) [ SqlColumnNumber = 9, SqlFieldName = CSRI_Qty_Returned_Clean ];

/// Des Ref to INCLB(Laundry)
Property CSRIINCLBDRLaundry As INCItmLcBt [ SqlColumnNumber = 10, SqlFieldName = CSRI_INCLB_DR_Laundry ];

/// Des Ref to INCLB(Ward)
Property CSRIINCLBDRWard As INCItmLcBt [ SqlColumnNumber = 11, SqlFieldName = CSRI_INCLB_DR_Ward ];

/// Qty Changed
Property CSRIQtyChanged As %Float [ SqlColumnNumber = 12, SqlFieldName = CSRI_Qty_Changed ];

/// ChangeType
Property CSRIChangeType As %String(DISPLAYLIST = ",Clean->Dirty,Dirty->Clean", MAXLEN = 12, TRUNCATE = 1, VALUELIST = ",0,1") [ SqlColumnNumber = 13, SqlFieldName = CSRI_ChangeType ];

/// Qty in Ward Dirty
Property CSRIQtyinWardDirty As %Float [ SqlColumnNumber = 14, SqlComputeCode = { s {CSRI_Qty_in_Ward_Dirty}=$$CO14^at1127({CSRI_ParRef},{CSRI_INCI_DR},{CSRI_Qty_Changed},{CSRI_ChangeType},{CSRI_RowId})
}, SqlComputed, SqlFieldName = CSRI_Qty_in_Ward_Dirty, Transient ];

/// Qty Requested
Property CSRIQtyRequested As %Float [ SqlColumnNumber = 15, SqlFieldName = CSRI_Qty_Requested ];

/// Des Ref to SterCat
Property CSRISterCatDR As INCSterileCategory [ InitialExpression = {$$DEF16^at1127a($s($d(initvalue):initvalue,1:%d(0)))}, SqlColumnNumber = 16, SqlFieldName = CSRI_SterCat_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INCSRItems).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSRItems","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INCSRItems).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSRItems","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INCSRItems).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSRItems","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INCSRItems).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSRItems","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSRItems","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INCSRItems).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INCSRItems","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CSRI_ChangeType">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="CSRI_INCI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CSRI_INCLB_DR_Laundry">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="CSRI_INCLB_DR_Ward">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="CSRI_Qty_Changed">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="CSRI_Qty_Received">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CSRI_Qty_Requested">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="CSRI_Qty_Returned_Clean">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CSRI_Qty_Returned_Dirty">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CSRI_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="CSRI_SterCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Global>^INCSR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_CSR.INCSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>CSRI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{IN_CSR.INCSR_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{CSRI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>CSRI_RowId</SqlRowIdName>
<StreamLocation>^User.INCSRItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
