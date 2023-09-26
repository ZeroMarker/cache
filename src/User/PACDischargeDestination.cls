/// PAC Discharge Destination(1544
Class User.PACDischargeDestination Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_DischargeDestination, StorageStrategy = SQLStorage ]
{

/// Code
Property DDESTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = DDEST_Code ];

/// Description
Property DDESTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = DDEST_Desc ];

/// Icon Name
Property DDESTIconName As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = DDEST_IconName ];

/// Icon Priority
Property DDESTIconPriority As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DDEST_IconPriority ];

/// Date From
Property DDESTDateFrom As %Date [ SqlColumnNumber = 6, SqlFieldName = DDEST_DateFrom ];

/// Date To
Property DDESTDateTo As %Date [ SqlColumnNumber = 7, SqlFieldName = DDEST_DateTo ];

/// National Code
Property DDESTNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = DDEST_NationalCode ];

/// CriticalCareTransfer
Property DDESTCriticalCareTransfer As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = DDEST_CriticalCareTransfer ];

/// Transfer Source
Property DDESTTransferSource As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = DDEST_TransferSource ];

/// Statistical Discharge
Property DDESTStatisticalDischarge As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 11, SqlFieldName = DDEST_StatisticalDischarge ];

/// IntentReadmit
Property DDESTIntentReadmit As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = DDEST_IntentReadmit ];

/// CareAvailab
Property DDESTCareAvailab As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = DDEST_CareAvailab ];

/// CareType
Property DDESTCareType As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = DDEST_CareType ];

/// SeparReferral
Property DDESTSeparReferral As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = DDEST_SeparReferral ];

Index DDESTCodeUnqIdx1 On DDESTCode [ Unique ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACDischargeDestination).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeDestination","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACDischargeDestination).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeDestination","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACDischargeDestination).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeDestination","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACDischargeDestination).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeDestination","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACDischargeDestination).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeDestination","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACDischargeDestination","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("DDEST",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DDEST_CareAvailab">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="DDEST_CareType">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="DDEST_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DDEST_CriticalCareTransfer">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DDEST_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DDEST_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DDEST_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DDEST_IconName">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DDEST_IconPriority">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DDEST_IntentReadmit">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DDEST_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DDEST_SeparReferral">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="DDEST_StatisticalDischarge">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DDEST_TransferSource">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>DDEST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DDEST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{DDEST_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DDEST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DDEST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DDEST_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDEST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DDEST_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"DDEST"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({DDEST_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DDEST_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>DDEST_RowId</SqlRowIdName>
<StreamLocation>^User.PACDischargeDestinationS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
