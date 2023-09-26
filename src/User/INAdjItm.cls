/// IN Adjust Item          (INADI,447)
Class User.INAdjItm Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_AdjItm, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 4;

Index RowIDBasedIDKeyIndex On INADIChildSub [ IdKey, PrimaryKey, Unique ];

/// Des Ref To INAD
Relationship INADIINADParRef As INAdj [ Cardinality = parent, Inverse = ChildINAdjItm, Required, SqlFieldName = INADI_INAD_ParRef ];

/// INADI ChildSub (New Key)
Property INADIChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^INAD($p($s($d(initvalue):initvalue,1:%d(0)),$c(1),1),"ADI",0))}, Required, SqlColumnNumber = 2, SqlFieldName = INADI_ChildSub ];

/// Quantity
Property INADIQty As %Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ SqlColumnNumber = 3, SqlFieldName = INADI_Qty ];

/// Des Ref to INCLB
Property INADIINCLBDR As INCItmLcBt [ Required, SqlColumnNumber = 4, SqlFieldName = INADI_INCLB_DR ];

/// Des Ref to INSTI
Property INADIINSTIDR As INStkTkItm [ SqlColumnNumber = 5, SqlFieldName = INADI_INSTI_DR ];

/// Unit Cost
Property INADIUCost As %Float(MAXVAL = 999999999999, MINVAL = -9999999999) [ InitialExpression = 0, Required, SqlColumnNumber = 6, SqlFieldName = INADI_UCost ];

/// Des Ref to CTUOM
Property INADICTUOMDR As CTUOM [ SqlColumnNumber = 8, SqlFieldName = INADI_CTUOM_DR ];

/// Des Ref CTLOC
Property INADICTLOCDR As CTLoc [ SqlColumnNumber = 9, SqlComputeCode = { s {INADI_CTLOC_DR}=$$CO09^at447({INADI_INCLB_DR})
}, SqlComputed, SqlFieldName = INADI_CTLOC_DR, Transient ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INAdjItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdjItm","OnAfterDelete")
 d POFILDEL^at447({INADI_RowId})
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INAdjItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdjItm","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INAdjItm).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdjItm","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INAdjItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdjItm","OnBeforeDelete")
 d PRFILDEL^at447({INADI_RowId})
 d VALDEL^at447
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d VALINS^at447
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INAdjItm).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdjItm","OnBeforeUpdate")
 d VALUPD^at447
}

Storage SQLStorage
{
<ExtentSize>4</ExtentSize>
<Property name="INADICTLOCDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="INADICTUOMDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INADIChildSub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INADIINADParRef">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INADIINCLBDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="INADIINSTIDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="INADIQty">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="INADIUCost">
<Selectivity>50.0000%</Selectivity>
</Property>
<SQLMap name="DataMasterINADI">
<Data name="INADI_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INADI_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INADI_INSTI_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INADI_Qty">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INADI_UCost">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^INAD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>IN_Adj.INAD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>INADI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{IN_Adj.INAD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"ADI"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INADI_ChildSub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLocation">
<Global>^INAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>IN_Adj.INAD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>INADI_ChildSub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Loc"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INADI_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{IN_Adj.INAD_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INADI_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INADI_RowId</SqlRowIdName>
<StreamLocation>^User.INAdjItmS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
