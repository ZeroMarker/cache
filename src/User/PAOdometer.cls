/// Odometer(2204)
Class User.PAOdometer Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Odometer, StorageStrategy = SQLStorage ]
{

/// Des Ref User
Property ODOMUserDR As SSUser [ SqlColumnNumber = 2, SqlFieldName = ODOM_User_DR ];

/// Date
Property ODOMDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ODOM_Date ];

/// StartOdometer
Property ODOMStartOdometer As %Float [ SqlColumnNumber = 4, SqlFieldName = ODOM_StartOdometer ];

/// EndOdometer
Property ODOMEndOdometer As %Float [ SqlColumnNumber = 5, SqlFieldName = ODOM_EndOdometer ];

/// Travel Time
Property ODOMTravelTime As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ODOM_TravelTime ];

/// Des Ref CTCP
Property ODOMCTCPDR As CTCareProv [ SqlColumnNumber = 7, SqlFieldName = ODOM_CTCP_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAOdometer).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAOdometer","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAOdometer).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAOdometer","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAOdometer).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAOdometer","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAOdometer).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAOdometer","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAOdometer).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PAOdometer","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PA("ODOM",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="ODOM_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ODOM_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ODOM_EndOdometer">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ODOM_StartOdometer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ODOM_TravelTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ODOM_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^PA</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ODOM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ODOM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ODOM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCTCP">
<Global>^PAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ODOM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ODOM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Doc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ODOM_CTCP_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ODOM_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ODOM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexUser">
<Global>^PAi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>ODOM_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ODOM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ODOM_User_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ODOM_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ODOM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ODOM_RowId</SqlRowIdName>
<StreamLocation>^User.PAOdometerS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
