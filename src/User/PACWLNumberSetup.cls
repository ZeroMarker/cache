/// WL Number Setup(2600)
Class User.PACWLNumberSetup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_WLNumberSetup, StorageStrategy = SQLStorage ]
{

/// Des Ref WaitListType
Property WLNSWaitListTypeDR As PACWaitingListType [ SqlColumnNumber = 2, SqlFieldName = WLNS_WaitListType_DR ];

/// DateFrom
Property WLNSDateFrom As %Date [ SqlColumnNumber = 3, SqlFieldName = WLNS_DateFrom ];

/// DateTo
Property WLNSDateTo As %Date [ SqlColumnNumber = 4, SqlFieldName = WLNS_DateTo ];

/// Des Ref Hospital
Property WLNSHospitalDR As CTHospital [ SqlColumnNumber = 5, SqlFieldName = WLNS_Hospital_DR ];

/// Des Ref CTLOC
Property WLNSCTLOCDR As CTLoc [ SqlColumnNumber = 6, SqlFieldName = WLNS_CTLOC_DR ];

/// Des Ref Counter
Property WLNSCounterDR As PACCounterType [ SqlColumnNumber = 7, SqlFieldName = WLNS_Counter_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACWLNumberSetup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLNumberSetup","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACWLNumberSetup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLNumberSetup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACWLNumberSetup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLNumberSetup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACWLNumberSetup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLNumberSetup","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACWLNumberSetup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLNumberSetup","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACWLNumberSetup","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("WLNS",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="WLNS_CTLOC_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="WLNS_Counter_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="WLNS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WLNS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WLNS_Hospital_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WLNS_WaitListType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WLNS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLNS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WLNS_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDateFrom">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WLNS_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WLNS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Date"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{WLNS_DateFrom}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WLNS_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WLNS_RowId</SqlRowIdName>
<StreamLocation>^User.PACWLNumberSetupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
