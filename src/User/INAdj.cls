/// IN Adjust                (INAD,437)
Class User.INAdj Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_Adj, StorageStrategy = SQLStorage ]
{

Relationship ChildINAdjItm As INAdjItm [ Cardinality = children, Inverse = INADIINADParRef ];

/// Remarks
Property INADRemarks As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = INAD_Remarks, SqlListType = subnode ];

/// Des Ref to INST
Property INADINSTDR As INStkTk [ SqlColumnNumber = 4, SqlFieldName = INAD_INST_DR ];

/// Des Ref to SSUSR
Property INADSSUSRDR As SSUser [ Required, SqlColumnNumber = 6, SqlFieldName = INAD_SSUSR_DR ];

/// Date of Adjustment
Property INADDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 7, SqlFieldName = INAD_Date ];

/// Adjustment Reference No
Property INADNo As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ Required, SqlColumnNumber = 9, SqlFieldName = INAD_No ];

/// Adjustment time
Property INADTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 12, SqlFieldName = INAD_Time ];

/// Des Ref ReasonAdj
Property INADReasonAdjDR As INCReasonForAdjustment [ SqlColumnNumber = 13, SqlFieldName = INAD_ReasonAdj_DR ];

Index INADNoUnqIdx1 On INADNo [ Unique ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INAdj).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdj","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INAdj).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdj","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INAdj).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdj","OnBeforeDelete")
 d VALDEL^at437
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INAdj).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdj","OnBeforeUpdate")
 d VALUPD^at437
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdj","OnBeforeInsert")
 d PRFILINS^at437
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INAdj).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INAdj","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INAD(0))</SqlIdExpression>
<SQLMap name="DataMasterINAD">
<Data name="INAD_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INAD_INST_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INAD_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INAD_ReasonAdj_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INAD_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INAD_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INAD_Time">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^INAD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INAD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INAD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINADDate">
<Global>^INAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAD_RowId</Field>
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
<Expression>{INAD_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINADNo">
<Global>^INAD</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INAD_RowId</Field>
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
<Expression>$$ALPHAUP({INAD_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INAD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INAD_RowId</SqlRowIdName>
<StreamLocation>^User.INAdjS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
