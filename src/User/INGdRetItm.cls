/// IN Goods Return Item    (INGRD,628)
Class User.INGdRetItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_GdRetItm, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On INGRDChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Def INGRR
Relationship INGRDINGRRParRef As INGdRet [ Cardinality = parent, Inverse = ChildINGdRetItm, Required, SqlFieldName = INGRD_INGRR_ParRef ];

/// INGRD ChildSub (New Key)
Property INGRDChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INGR(+$s($d(initvalue):initvalue,1:%d(0)),"GRR",$p($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"||",2),"GRD",0))}, Required, SqlColumnNumber = 2, SqlFieldName = INGRD_ChildSub ];

/// Return Amount
Property INGRDAmount As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 3, SqlComputeCode = { i {INGRD_Qty}="" s {INGRD_Amount}="" q
 i {INGRD_INGRI_DR}="" s {INGRD_Amount}="" q
 s {INGRD_Amount}=$$CO03^at628({INGRD_Qty},{INGRD_INGRI_DR})
}, SqlComputed, SqlFieldName = INGRD_Amount ];

/// Des Ref to INGRI
Property INGRDINGRIDR As INGdRecItm [ Required, SqlColumnNumber = 4, SqlFieldName = INGRD_INGRI_DR ];

/// Return Quantity
Property INGRDQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ Required, SqlColumnNumber = 5, SqlFieldName = INGRD_Qty ];

/// Remarks
Property INGRDRemarks As %String(COLLATION = "AlphaUp", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = INGRD_Remarks ];

/// Base Amount 
Property INGRDBAmount As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 7, SqlComputeCode = { i {INGRD_Amount}="" s {INGRD_BAmount}="" q
 s {INGRD_BAmount}=$$CO07^at628({INGRD_Amount},{INGRD_INGRR_ParRef})
}, SqlComputed, SqlComputeOnChange = INGRDAmount, SqlFieldName = INGRD_BAmount ];

/// Des Ref to CTUOM(Return Unit)
Property INGRDCTUOMDR As CTUOM [ InitialExpression = {$$DEF08^at628b(%d(4))}, SqlColumnNumber = 8, SqlFieldName = INGRD_CTUOM_DR ];

/// Additional Qty(for other return UOM)
Property INGRDAdditQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ Required, SqlColumnNumber = 9, SqlFieldName = INGRD_AdditQty ];

/// Des Ref ReasonReturn
Property INGRDReasonReturnDR As INCReasonForReturn [ SqlColumnNumber = 10, SqlFieldName = INGRD_ReasonReturn_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INGdRetItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRetItm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INGdRetItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRetItm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INGdRetItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRetItm","OnBeforeDelete")
 d VALDEL^at628
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INGdRetItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRetItm","OnBeforeUpdate")
 d VALUPD^at628
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRetItm","OnBeforeInsert")
 d VALINS^at628
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INGdRetItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INGdRetItm","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMasterINGRD">
<Data name="INGRD_AdditQty">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INGRD_Amount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INGRD_BAmount">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INGRD_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INGRD_INGRI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INGRD_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INGRD_ReasonReturn_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INGRD_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^INGR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_GdRec.INGR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>IN_GdRet.INGRR_ChildSub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>INGRD_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IN_GdRec.INGR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"GRR"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{IN_GdRet.INGRR_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>"GRD"</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INGRD_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>INGRD_RowId</SqlRowIdName>
<StreamLocation>^User.INGdRetItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
