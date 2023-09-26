/// ORC Operation Item (1931)
Class User.ORCOperationItemLink Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ORC_OperationItemLink, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On LINKChildsub [ IdKey, PrimaryKey, Unique ];

/// ORC_Operation Parent Reference
Relationship LINKParRef As ORCOperation [ Cardinality = parent, Inverse = ChildORCOperationItemLink, Required, SqlFieldName = LINK_ParRef ];

/// Childsub
Property LINKChildsub As %Float [ InitialExpression = {$i(^ORC("OPER",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"LINK",0))}, SqlColumnNumber = 2, SqlFieldName = LINK_Childsub ];

/// Des Ref ARCIM
Property LINKARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = LINK_ARCIM_DR ];

/// Percent
Property LINKPercent As %Float [ SqlColumnNumber = 4, SqlFieldName = LINK_Percent ];

/// Of Code
Property LINKOfCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = LINK_OfCode ];

/// MinAmt
Property LINKMinAmt As %Float [ SqlColumnNumber = 6, SqlFieldName = LINK_MinAmt ];

/// Min Value of Main Item
Property LINKMinValueMainItem As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = LINK_MinValueMainItem ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.ORCOperationItemLink).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationItemLink","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.ORCOperationItemLink).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationItemLink","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.ORCOperationItemLink).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationItemLink","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.ORCOperationItemLink).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationItemLink","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.ORCOperationItemLink).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationItemLink","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationItemLink","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="LINK_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LINK_MinAmt">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LINK_MinValueMainItem">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LINK_OfCode">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LINK_Percent">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ORC_Operation.OPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ORC_Operation.OPER_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"LINK"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LINK_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>ORC_Operation.OPER_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>LINK_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"OPER"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{LINK_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORC_Operation.OPER_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{LINK_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>LINK_RowId</SqlRowIdName>
<StreamLocation>^User.ORCOperationItemLinkS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
