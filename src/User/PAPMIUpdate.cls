/// PA PMI Update(1905)
Class User.PAPMIUpdate Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_PMIUpdate, StorageStrategy = SQLStorage ]
{

/// Des Ref PAPMI
Property PMIPAPMIDR As PAPatMas [ SqlColumnNumber = 2, SqlFieldName = PMI_PAPMI_DR ];

/// Date
Property PMIDate As %Date [ SqlColumnNumber = 3, SqlFieldName = PMI_Date ];

/// Time
Property PMITime As %Time [ SqlColumnNumber = 4, SqlFieldName = PMI_Time ];

/// Status
Property PMIStatus As %String(DISPLAYLIST = ",Pending,Waiting,Done,Error,Transfer Error,Waiting Tracking", MAXLEN = 16, TRUNCATE = 1, VALUELIST = ",P,W,D,E,TE,W1") [ SqlColumnNumber = 5, SqlFieldName = PMI_Status ];

/// Error Message
Property PMIErrorMessage As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PMI_ErrorMessage ];

/// Rego
Property PMIRego As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PMI_Rego ];

/// Des Ref PAADM
Property PMIPAADMDR As PAAdm [ SqlColumnNumber = 8, SqlFieldName = PMI_PAADM_DR ];

/// Des TrafficAccident
Property PMITrafficAccidentDR As PATrafficAccident [ SqlColumnNumber = 9, SqlFieldName = PMI_TrafficAccident_DR ];

/// Merge Data
Property PMIMergeData As %String(COLLATION = "Exact", MAXLEN = 250, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PMI_MergeData ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAPMIUpdate).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPMIUpdate","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAPMIUpdate).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPMIUpdate","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAPMIUpdate).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPMIUpdate","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAPMIUpdate).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPMIUpdate","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAPMIUpdate).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAPMIUpdate","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PMI(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PMI_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PMI_ErrorMessage">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PMI_MergeData">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PMI_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PMI_PAPMI_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PMI_Rego">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PMI_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PMI_Time">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="PMI_TrafficAccident_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PMI</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PMI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBlankPat">
<Condition>'{PMI_PAPMI_DR}</Condition>
<ConditionFields>PMI_PAPMI_DR,PMI_Status</ConditionFields>
<Global>^PMI</Global>
<PopulationPct>10</PopulationPct>
<PopulationType>conditional</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Stat1"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMI_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexRego">
<Global>^PMI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Rego"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({PMI_Rego})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexStatus">
<Global>^PMI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PMI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Stat"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PMI_Status}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PMI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PMI_RowId</SqlRowIdName>
<StreamLocation>^User.PAPMIUpdateS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
