/// IN Stock Take Header     (INST,293)
Class User.INStkTk Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_StkTk, StorageStrategy = SQLStorage ]
{

Relationship ChildINStkTkItm As INStkTkItm [ Cardinality = children, Inverse = INSTIINSTParRef ];

Relationship ChildINStkTkGrp As INStkTkGrp [ Cardinality = children, Inverse = TGParRef ];

/// Stock Take Reference Number
Property INSTNo As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INST_No ];

/// Transaction Date
Property INSTDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 3, SqlFieldName = INST_Date ];

/// Des Ref to SSUSR
Property INSTSSUSRDR As SSUser [ InitialExpression = {$g(XCONF("DPUSR",3))}, Required, SqlColumnNumber = 5, SqlFieldName = INST_SSUSR_DR ];

/// Des Ref To CTLOC
Property INSTCTLOCDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = INST_CTLOC_DR ];

/// Des Ref to INCTG
Property INSTFrGroupDR As INCStkTkGp [ SqlColumnNumber = 7, SqlFieldName = INST_FrGroup_DR ];

/// Des Ref To INCTG
Property INSTToGroupDR As INCStkTkGp [ SqlColumnNumber = 8, SqlFieldName = INST_ToGroup_DR ];

/// Des Ref to INCI
Property INSTFrCodeDR As INCItm [ SqlColumnNumber = 9, SqlFieldName = INST_FrCode_DR ];

/// Des Ref To INCI
Property INSTToCodeDR As INCItm [ SqlColumnNumber = 10, SqlFieldName = INST_ToCode_DR ];

/// Stock Take Batch Status
Property INSTStatus As %String(DISPLAYLIST = ",Freeze Stock,Data Entered,Variance Computed,Adjustment Done", MAXLEN = 17, TRUNCATE = 1, VALUELIST = ",F,E,V,A") [ InitialExpression = "Freeze Stock", SqlColumnNumber = 11, SqlFieldName = INST_Status ];

/// Double Stock Take
Property INSTDoubleST As %String(DISPLAYLIST = ",Single,Double", MAXLEN = 6, TRUNCATE = 1, VALUELIST = ",S,D") [ InitialExpression = "Single", SqlColumnNumber = 13, SqlFieldName = INST_DoubleST ];

/// Time
Property INSTTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 14, SqlFieldName = INST_Time ];

/// Remarks
Property INSTRemarks As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = INST_Remarks, SqlListType = subnode ];

/// Completed
Property INSTCompleted As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 16, SqlFieldName = INST_Completed ];

/// StockTakeComplete
Property INSTStockTakeComplete As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 17, SqlFieldName = INST_StockTakeComplete ];

/// Adjustment Complete
Property INSTAdjustmentComplete As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 18, SqlFieldName = INST_AdjustmentComplete ];

/// Des Ref Adjustment
Property INSTINADDR As INAdj [ SqlColumnNumber = 19, SqlFieldName = INST_INAD_DR ];

/// StockTakeComplete2
Property INSTStockTakeComplete2 As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 20, SqlFieldName = INST_StockTakeComplete2 ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INStkTk).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTk","OnAfterInsert")
 d POFILINS^at293
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INStkTk).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTk","OnAfterUpdate")
 d POFILUPD^at293
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INStkTk).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTk","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INStkTk).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTk","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTk","OnBeforeInsert")
 d VALINS^at293
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INStkTk).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INStkTk","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INST(0))</SqlIdExpression>
<SQLMap name="DataMasterINST">
<Data name="INST_AdjustmentComplete">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="INST_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="INST_Completed">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="INST_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INST_DoubleST">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INST_FrCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="INST_FrGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INST_INAD_DR">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="INST_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INST_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INST_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INST_Status">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="INST_StockTakeComplete">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="INST_StockTakeComplete2">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="INST_Time">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="INST_ToCode_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="INST_ToGroup_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^INST</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINSTDate">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INST_RowId</Field>
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
<Expression>{INST_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINSTNo">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<AccessType>sub</AccessType>
<Expression>"No"</Expression>
</Subscript>
<Subscript name="3">
<AccessType>sub</AccessType>
<Expression>$$ALPHAUP({INST_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexLocDate">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"LocDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INST_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INST_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUserDate">
<Global>^INST</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>INST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"UserDate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{INST_SSUSR_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{INST_Date}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{INST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INST_RowId</SqlRowIdName>
<StreamLocation>^User.INStkTkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
