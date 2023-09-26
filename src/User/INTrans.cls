/// IN Transaction           (INTR,292)
Class User.INTrans Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_Trans, StorageStrategy = SQLStorage ]
{

/// Stock Transaction Type
Property INTRType As %String(COLLATION = "AlphaUp", MAXLEN = 1, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = INTR_Type ];

/// Transaction Date
Property INTRDate As %Date [ SqlColumnNumber = 11, SqlFieldName = INTR_Date ];

/// Transaction Time
Property INTRTime As %Time [ SqlColumnNumber = 12, SqlFieldName = INTR_Time ];

/// GL Batch
Property INTRGLBatchDR As GLBatch [ SqlColumnNumber = 16, SqlFieldName = INTR_GLBatch_DR ];

/// Update Inventory Flag
Property INTRUpdFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 18, SqlFieldName = INTR_UpdFlag ];

/// Update Balance Flag
Property INTRUpdBalFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N", SqlColumnNumber = 19, SqlFieldName = INTR_UpdBalFlag ];

/// Pointer to other table
Property INTRPointer As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 29, SqlFieldName = INTR_Pointer ];

/// Amount
Property INTRAmount As %Float(MAXVAL = 999999999999.9999, MINVAL = -99999999999.9999) [ SqlColumnNumber = 30, SqlFieldName = INTR_Amount ];

/// Des Ref to INCLB
Property INTRINCLBDR As INCItmLcBt [ SqlColumnNumber = 31, SqlFieldName = INTR_INCLB_DR ];

/// Quantity
Property INTRQty As %Float(MAXVAL = 999999999999, MINVAL = -99999999999) [ SqlColumnNumber = 32, SqlFieldName = INTR_Qty ];

/// Des Ref to CTUOM (Unit of Measurement)
Property INTRCTUOMDR As CTUOM [ SqlColumnNumber = 33, SqlFieldName = INTR_CTUOM_DR ];

/// Des ref to SSUSR
Property INTRSSUSRDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, SqlColumnNumber = 34, SqlFieldName = INTR_SSUSR_DR ];

/// Des Ref INCI
Property INTRINCIDR As INCItm [ SqlColumnNumber = 35, SqlComputeCode = { s {INTR_INCI_DR}=$p({INTR_INCLB_DR},"||")
}, SqlComputed, SqlFieldName = INTR_INCI_DR, Transient ];

/// Transaction Number
Property INTRNo As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 36, SqlFieldName = INTR_No ];

/// Average Price
Property INTRAveragePrice As %Float [ SqlColumnNumber = 37, SqlFieldName = INTR_AveragePrice ];

/// Des Ref CTLOC
Property INTRCTLOCDR As CTLoc [ SqlColumnNumber = 38, SqlComputeCode = { s {INTR_CTLOC_DR}=$p($g(^INCI(+{INTR_INCLB_DR},"IL",+$p({INTR_INCLB_DR},"||",2))),"^")
}, SqlComputed, SqlFieldName = INTR_CTLOC_DR, Transient ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.INTrans).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INTrans","OnAfterDelete")
 
 d POFILDEL^at292b
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.INTrans).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INTrans","OnAfterInsert")
 
 d POFILINS^at292b
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.INTrans).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INTrans","OnAfterUpdate")
 
 d POFILUPD^at292b
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.INTrans).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INTrans","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.INTrans).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INTrans","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INTR(0))</SqlIdExpression>
<SQLMap name="DataMasterINTR">
<Data name="INTR_Amount">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INTR_AveragePrice">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INTR_CTUOM_DR">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INTR_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INTR_GLBatch_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INTR_INCLB_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INTR_No">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INTR_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INTR_Qty">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INTR_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INTR_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INTR_Type">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INTR_UpdBalFlag">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INTR_UpdFlag">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^INTR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateType">
<Global>^INTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGLBatch">
<Global>^INTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GLBatch"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTR_GLBatch_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGLNotPosted">
<Condition>{INTR_GLBatch_DR}=""</Condition>
<ConditionFields>INTR_Date,INTR_GLBatch_DR</ConditionFields>
<Global>^INTR</Global>
<PopulationPct>50</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GLPost"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINCIDate">
<Global>^INTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"INCI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTR_INCI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINTRDate">
<Global>^INTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINTRTypePointer">
<Global>^INTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INTR_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<AccessType>sub</AccessType>
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocTypeDate">
<Global>^INTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocTypeDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTR_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTR_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeNumber">
<Global>^INTR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INTR_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypeNo"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INTR_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({INTR_No})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INTR_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INTR_RowId</SqlRowIdName>
<StreamLocation>^User.INTransS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
