/// SS TableField(2691)
Class User.SSTableField Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_TableField, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 21702;

Index RowIDBasedIDKeyIndex On FLDChildsub [ IdKey, PrimaryKey, Unique ];

/// SS_Table Parent Reference
Relationship FLDParRef As SSTable [ Cardinality = parent, Inverse = ChildSSTableField, Required, SqlFieldName = FLD_ParRef ];

/// Childsub
Property FLDChildsub As %Float [ SqlColumnNumber = 2, SqlFieldName = FLD_Childsub ];

/// Name
Property FLDName As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = FLD_Name ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSTableField).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSTableField","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSTableField).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSTableField","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSTableField).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSTableField","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSTableField).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSTableField","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSTableField).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.SSTableField","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>21702</ExtentSize>
<Property name="FLDChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="FLDName">
<Selectivity>0.0126%</Selectivity>
</Property>
<Property name="FLDParRef">
<Selectivity>0.1388%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="FLD_Name">
<Delimiter>$c(1)</Delimiter>
<Node>1</Node>
<Piece>1</Piece>
</Data>
<Global>^mdd</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Table.SSTAB_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>FLD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>1</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Table.SSTAB_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>2</Expression>
</Subscript>
<Subscript name="4">
<Expression>{FLD_Childsub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>FLD_RowId</SqlRowIdName>
<StreamLocation>^User.SSTableFieldS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
