/// IN Disposal Item        (INDSI,446)
Class User.INDispItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_DispItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 2;

Index RowIDBasedIDKeyIndex On INDSIChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref To INDS
Relationship INDSIINDSParRef As INDisp [ Cardinality = parent, Inverse = ChildINDispItm, Required, SqlFieldName = INDSI_INDS_ParRef ];

/// INDSI ChildSub (NewKey)
Property INDSIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INDS($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"DSI",0))}, SqlColumnNumber = 2, SqlFieldName = INDSI_ChildSub ];

/// Quantity
Property INDSIQty As %Float(MAXVAL = 999999999999, MINVAL = 0) [ SqlColumnNumber = 3, SqlFieldName = INDSI_Qty ];

/// Des Ref to INCLB
Property INDSIINCLBDR As INCItmLcBt [ Required, SqlColumnNumber = 4, SqlFieldName = INDSI_INCLB_DR ];

/// Remarks
Property INDSIRemarks As %String(COLLATION = "Exact", MAXLEN = 40, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = INDSI_Remarks ];

/// Unit Cost
Property INDSIUCost As %Float(MAXVAL = 9999999999.9999, MINVAL = -9999999999.9999) [ SqlColumnNumber = 6, SqlFieldName = INDSI_UCost ];

/// Des Ref to CTUOM
Property INDSICTUOMDR As CTUOM [ Required, SqlColumnNumber = 8, SqlFieldName = INDSI_CTUOM_DR ];

/// Company Sold To
Property INDSICompanySoldToDR As CTCompany [ SqlColumnNumber = 9, SqlFieldName = INDSI_CompanySoldTo_DR ];

/// Amount Sold for
Property INDSIAmountSoldFor As %Float [ SqlColumnNumber = 10, SqlFieldName = INDSI_AmountSoldFor ];

/// Des Ref CTLOC
Property INDSICTLOCDR As CTLoc [ SqlColumnNumber = 11, SqlComputeCode = { s {INDSI_CTLOC_DR}=$$CO11^at446({INDSI_INCLB_DR})
}, SqlComputed, SqlFieldName = INDSI_CTLOC_DR, Transient ];

/// Type
Property INDSIType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlComputeCode = { s {INDSI_Type}=$$CO12^at446({INDSI_INDS_ParRef})
}, SqlComputed, SqlFieldName = INDSI_Type, Transient ];

/// Des REf ConsReason
Property INDSIConsReasonDR As INCConsumptionReason [ SqlColumnNumber = 13, SqlFieldName = INDSI_ConsReason_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INDispItm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDispItm","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INDispItm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDispItm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INDispItm).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDispItm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INDispItm).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDispItm","OnBeforeDelete")
 d VALDEL^at446
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d VALINS^at446
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INDispItm).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDispItm","OnBeforeUpdate")
 d VALUPD^at446
}

Storage SQLStorage
{
<ExtentSize>2</ExtentSize>
<Property name="INDSIAmountSoldFor">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INDSICTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="INDSICTUOMDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INDSIChildSub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INDSICompanySoldToDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INDSIConsReasonDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INDSIINCLBDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INDSIINDSParRef">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INDSIQty">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INDSIRemarks">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INDSIType">
<Selectivity>1</Selectivity>
</Property>
<Property name="INDSIUCost">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="DataMasterINDSI">
<Data name="INDSI_AmountSoldFor">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDSI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDSI_CompanySoldTo_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDSI_ConsReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INDSI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDSI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDSI_Remarks">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INDSI_UCost">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^INDS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_Disp.INDS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INDSI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IN_Disp.INDS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"DSI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INDSI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocation">
<Global>^INDS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>IN_Disp.INDS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>INDSI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INDSI_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INDSI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{IN_Disp.INDS_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INDSI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INDSI_RowId</SqlRowIdName>
<StreamLocation>^User.INDispItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
