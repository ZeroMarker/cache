/// PAC Reason for crit transfer(1806
Class User.PACReasonCritCareTransfer Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_ReasonCritCareTransfer, StorageStrategy = SQLStorage ]
{

/// Code
Property RCCTCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = RCCT_Code ];

/// Date From
Property RCCTDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = RCCT_DateFrom ];

/// Date To
Property RCCTDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = RCCT_DateTo ];

/// Default
Property RCCTDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 6, SqlFieldName = RCCT_Default ];

/// Description
Property RCCTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RCCT_Desc ];

Parameter EXTENTSIZE = 1;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACReasonCritCareTransfer).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACReasonCritCareTransfer","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACReasonCritCareTransfer).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACReasonCritCareTransfer","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACReasonCritCareTransfer).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACReasonCritCareTransfer","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACReasonCritCareTransfer).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACReasonCritCareTransfer","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACReasonCritCareTransfer).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PACReasonCritCareTransfer","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="RCCTCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="RCCTDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="RCCTDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="RCCTDefault">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RCCTDesc">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^PAC("RCCT",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="RCCT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RCCT_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RCCT_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RCCT_Default">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="RCCT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RCCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RCCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RCCT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RCCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RCCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RCCT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RCCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RCCT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RCCT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RCCT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RCCT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RCCT_RowId</SqlRowIdName>
<StreamLocation>^User.PACReasonCritCareTransferS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
