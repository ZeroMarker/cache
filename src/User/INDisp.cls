/// IN Disposal              (INDS,436)
Class User.INDisp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = IN_Disp, StorageStrategy = SQLStorage ]
{

Relationship ChildINDispItm As INDispItm [ Cardinality = children, Inverse = INDSIINDSParRef ];

/// Remarks
Property INDSRemarks As list Of %String(COLLATION = "AlphaUp", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = INDS_Remarks, SqlListType = subnode ];

/// Des Ref To SSUSR
Property INDSSSUSRDR As SSUser [ Required, SqlColumnNumber = 4, SqlFieldName = INDS_SSUSR_DR ];

/// Date Of Disposal
Property INDSDate As %Date [ InitialExpression = {+$h}, Required, SqlColumnNumber = 5, SqlFieldName = INDS_Date ];

/// Disposal Reference No
Property INDSNo As %String(COLLATION = "AlphaUp", MAXLEN = 100, TRUNCATE = 1) [ InitialExpression = "NEW", SqlColumnNumber = 8, SqlFieldName = INDS_No ];

/// Disposal Time
Property INDSTime As %Time [ InitialExpression = {$p($h,",",2)}, Required, SqlColumnNumber = 11, SqlFieldName = INDS_Time ];

/// Transaction Type
Property INDSType As %String(MAXLEN = 4, TRUNCATE = 1, VALUELIST = ",DISP,CONS") [ SqlColumnNumber = 12, SqlFieldName = INDS_Type ];

/// Des REf ReasonAdjustment
Property INDSReasonAdjustment As INCReasonForAdjustment [ SqlColumnNumber = 13, SqlFieldName = INDS_ReasonAdjustment ];

/// Des Ref StockOutType
Property INDSStOutTypeDR As INCStockOutType [ SqlColumnNumber = 14, SqlFieldName = INDS_StOutType_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.INDisp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDisp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.INDisp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDisp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.INDisp).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDisp","OnBeforeDelete")
 d VALDEL^at436
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.INDisp).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDisp","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDisp","OnBeforeInsert")
 d PRFILINS^at436
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.INDisp).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.INDisp","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^INDS(0))</SqlIdExpression>
<SQLMap name="DataMasterINDS">
<Data name="INDS_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="INDS_No">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="INDS_ReasonAdjustment">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="INDS_Remarks">
<Node>"REM"</Node>
</Data>
<Data name="INDS_SSUSR_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="INDS_StOutType_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="INDS_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="INDS_Type">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^INDS</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>INDS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<AccessType>sub</AccessType>
<Expression>{INDS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexINDSDate">
<Global>^INDS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDS_RowId</Field>
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
<Expression>{INDS_Date}</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexINDSNo">
<Global>^INDS</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>INDS_RowId</Field>
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
<Expression>$$ALPHAUP({INDS_No})</Expression>
</Subscript>
<Subscript name="4">
<AccessType>sub</AccessType>
<Expression>{INDS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>INDS_RowId</SqlRowIdName>
<StreamLocation>^User.INDispS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
