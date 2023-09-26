/// WOReasonGroup(2450)
Class User.ARCWOReasonGroup Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_WOReasonGroup, StorageStrategy = SQLStorage ]
{

/// Code
Property WORGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WORG_Code ];

/// Description
Property WORGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = WORG_Desc ];

/// Date From
Property WORGDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = WORG_DateFrom ];

/// Date To
Property WORGDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = WORG_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCWOReasonGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCWOReasonGroup","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCWOReasonGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCWOReasonGroup","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCWOReasonGroup).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCWOReasonGroup","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCWOReasonGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCWOReasonGroup","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCWOReasonGroup).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCWOReasonGroup","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("WORG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WORG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WORG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="WORG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="WORG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WORG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WORG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WORG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WORG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WORG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WORG_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WORG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WORG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WORG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WORG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WORG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WORG_RowId</SqlRowIdName>
<StreamLocation>^User.ARCWOReasonGroupS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
