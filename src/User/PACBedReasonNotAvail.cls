/// PAC Bed Reason Not Avail(1537)
Class User.PACBedReasonNotAvail Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_BedReasonNotAvail, StorageStrategy = SQLStorage ]
{

/// Code
Property RNAVCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 2, SqlFieldName = RNAV_Code ];

/// Description
Property RNAVDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = RNAV_Desc ];

/// Date From
Property RNAVDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = RNAV_DateFrom ];

/// Date To
Property RNAVDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = RNAV_DateTo ];

/// TimeClosed
Property RNAVTimeClosed As %Float [ SqlColumnNumber = 6, SqlFieldName = RNAV_TimeClosed ];

/// MinutesDay
Property RNAVMinutesDay As %String(DISPLAYLIST = ",Day,Minutes", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",D,M") [ SqlColumnNumber = 7, SqlFieldName = RNAV_MinutesDay ];

Index RNAVCodeUnqIdx1 On RNAVCode [ Unique ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACBedReasonNotAvail).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedReasonNotAvail","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACBedReasonNotAvail).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedReasonNotAvail","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACBedReasonNotAvail).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedReasonNotAvail","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACBedReasonNotAvail).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedReasonNotAvail","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedReasonNotAvail","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACBedReasonNotAvail).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACBedReasonNotAvail","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("RNAV",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="RNAV_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RNAV_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RNAV_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="RNAV_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RNAV_MinutesDay">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="RNAV_TimeClosed">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RNAV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RNAV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RNAV_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RNAV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RNAV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RNAV_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RNAV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RNAV_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RNAV"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({RNAV_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RNAV_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RNAV_RowId</SqlRowIdName>
<StreamLocation>^User.PACBedReasonNotAvailS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
