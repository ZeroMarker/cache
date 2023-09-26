/// SS Table(1725)
Class User.SSTable Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_Table, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 2079;

Relationship ChildSSTableField As SSTableField [ Cardinality = children, Inverse = FLDParRef ];

/// Table Name
Property SSTABName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = SSTAB_Name ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSTable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSTable","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSTable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSTable","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSTable).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSTable","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSTable).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSTable","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSTable).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSTable","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2079</ExtentSize>
<Property name="SSTABName">
<Selectivity>1</Selectivity>
</Property>
<SqlIdExpression>$i(^mdd(1))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="SSTAB_Name">
<Delimiter>$c(1)</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Global>^mdd</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SSTAB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>1</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SSTAB_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^mdd</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SSTAB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>1</Expression>
</Subscript>
<Subscript name="2">
<Expression>"m"</Expression>
</Subscript>
<Subscript name="3">
<Expression>$$ALPHAUP({SSTAB_Name})</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SSTAB_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SSTAB_RowId</SqlRowIdName>
<StreamLocation>^User.SSTableS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
