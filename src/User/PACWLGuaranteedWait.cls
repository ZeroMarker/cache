/// PAC WLGuaranteedWait(2050)
Class User.PACWLGuaranteedWait Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WLGuaranteedWait, StorageStrategy = SQLStorage ]
{

/// Des Ref CTLOC
Property WLGWCTLOCDR As CTLoc [ SqlColumnNumber = 2, SqlFieldName = WLGW_CTLOC_DR ];

/// Des Ref HCR
Property WLGWHCRDR As CTHealthCareRegion [ SqlColumnNumber = 3, SqlFieldName = WLGW_HCR_DR ];

/// Des Ref Operation
Property WLGWOperationDR As ORCOperation [ SqlColumnNumber = 4, SqlFieldName = WLGW_Operation_DR ];

/// Des Ref EpisSubtype
Property WLGWEpisSubtypeDR As PACEpisodeSubType [ SqlColumnNumber = 5, SqlFieldName = WLGW_EpisSubtype_DR ];

/// Wait Time
Property WLGWWaitTime As %Float [ SqlColumnNumber = 6, SqlFieldName = WLGW_WaitTime ];

/// PAC_StatePPP Des Ref
Property WLGWStatePPPDR As PACStatePPP [ SqlColumnNumber = 7, SqlFieldName = WLGW_StatePPP_DR ];

/// Des Ref Services
Property WLGWServicesDR As RBCServices [ SqlColumnNumber = 8, SqlFieldName = WLGW_Services_DR ];

/// Des Ref WaitTimeStandard
Property WLGWWaitTimeStandardDR As PACWaitingTimeStandard [ SqlColumnNumber = 9, SqlFieldName = WLGW_WaitTimeStandard_DR ];

/// DateCalculateWaitFrom
Property WLGWDateCalculateWaitFrom As %String(DISPLAYLIST = ",Date on GP Letter,Date Referral Received,Date Placed on Waiting List", MAXLEN = 27, TRUNCATE = 1, VALUELIST = ",GPL,RR,PWL") [ SqlColumnNumber = 10, SqlFieldName = WLGW_DateCalculateWaitFrom ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACWLGuaranteedWait).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLGuaranteedWait","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACWLGuaranteedWait).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLGuaranteedWait","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACWLGuaranteedWait).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLGuaranteedWait","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACWLGuaranteedWait).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLGuaranteedWait","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACWLGuaranteedWait).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLGuaranteedWait","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLGuaranteedWait","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>19</ExtentSize>
<Property name="WLGWCTLOCDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="WLGWDateCalculateWaitFrom">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="WLGWEpisSubtypeDR">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="WLGWHCRDR">
<Selectivity>25.0000%</Selectivity>
</Property>
<Property name="WLGWOperationDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="WLGWServicesDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="WLGWStatePPPDR">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="WLGWWaitTime">
<Selectivity>6.6667%</Selectivity>
</Property>
<Property name="WLGWWaitTimeStandardDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("WLGW",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WLGW_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WLGW_DateCalculateWaitFrom">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="WLGW_EpisSubtype_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WLGW_HCR_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLGW_Operation_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WLGW_Services_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="WLGW_StatePPP_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WLGW_WaitTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WLGW_WaitTimeStandard_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WLGW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLGW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WLGW_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTLOC">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLGW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLGW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CTLOC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLGW_CTLOC_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLGW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexEpisSubtype">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLGW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLGW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SUBT"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLGW_EpisSubtype_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLGW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexHCR">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLGW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLGW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"HCR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLGW_HCR_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLGW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexOperation">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLGW_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLGW"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLGW_Operation_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLGW_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WLGW_RowId</SqlRowIdName>
<StreamLocation>^User.PACWLGuaranteedWaitS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
