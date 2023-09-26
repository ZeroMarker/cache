/// ObservationItemLookUp(2777)
Class User.MRCObservationItemLookUp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_ObservationItemLookUp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LUChildsub [ IdKey, PrimaryKey, Unique ];

/// MRC_ObservationItem Parent Reference
Relationship LUParRef As MRCObservationItem [ Cardinality = parent, Inverse = ChildMRCObservationItemLookUp, Required, SqlFieldName = LU_ParRef ];

/// Childsub
Property LUChildsub As %Float [ InitialExpression = {$i(^MRC("OBITM",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LU",0))}, SqlColumnNumber = 2, SqlFieldName = LU_Childsub ];

/// Code
Property LUCode As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LU_Code ];

/// Description
Property LUDesc As %String(COLLATION = "AlphaUp", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LU_Desc ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRCObservationItemLookUp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItemLookUp","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRCObservationItemLookUp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItemLookUp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRCObservationItemLookUp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItemLookUp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRCObservationItemLookUp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItemLookUp","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRCObservationItemLookUp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItemLookUp","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCObservationItemLookUp","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="LU_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LU_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_ObservationItem.ITM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LU_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OBITM"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_ObservationItem.ITM_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LU"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LU_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LU_RowId</SqlRowIdName>
<StreamLocation>^User.MRCObservationItemLookUpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
