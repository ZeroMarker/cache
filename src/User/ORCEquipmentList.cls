/// Equipment List(2804)
Class User.ORCEquipmentList Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ORC_EquipmentList, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LSChildsub [ IdKey, PrimaryKey, Unique ];

/// ORC_Equipment Parent Reference
Relationship LSParRef As ORCEquipment [ Cardinality = parent, Inverse = ChildORCEquipmentList, Required, SqlFieldName = LS_ParRef ];

/// Childsub
Property LSChildsub As %Float [ InitialExpression = {$i(^ORC("EQ",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LS",0))}, SqlColumnNumber = 2, SqlFieldName = LS_Childsub ];

/// Code
Property LSCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LS_Code ];

/// Description
Property LSDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LS_Desc ];

/// DateFrom
Property LSDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = LS_DateFrom ];

/// DateTo
Property LSDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = LS_DateTo ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.ORCEquipmentList).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCEquipmentList","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.ORCEquipmentList).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCEquipmentList","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.ORCEquipmentList).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCEquipmentList","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.ORCEquipmentList).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCEquipmentList","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCEquipmentList","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.ORCEquipmentList).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCEquipmentList","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="LS_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LS_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LS_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LS_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ORC_Equipment.EQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ORC_Equipment.EQ_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ORC_Equipment.EQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>LS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ORC_Equipment.EQ_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({LS_Code})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ORC_Equipment.EQ_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>LS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EQ"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ORC_Equipment.EQ_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LS"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="6">
<Expression>$$ALPHAUP({LS_Desc})</Expression>
</Subscript>
<Subscript name="7">
<Expression>{LS_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LS_RowId</SqlRowIdName>
<StreamLocation>^User.ORCEquipmentListS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
