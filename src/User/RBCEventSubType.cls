/// EventSubType(2709)
Class User.RBCEventSubType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RBC_EventSubType, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 1;

Index RowIDBasedIDKeyIndex On SUBChildsub [ IdKey, PrimaryKey, Unique ];

/// RBC_EventType Parent Reference
Relationship SUBParRef As RBCEventType [ Cardinality = parent, Inverse = ChildRBCEventSubType, Required, SqlFieldName = SUB_ParRef ];

/// Childsub
Property SUBChildsub As %Float [ InitialExpression = {$i(^RBC("EVT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SUB",0))}, SqlColumnNumber = 2, SqlFieldName = SUB_Childsub ];

/// Code
Property SUBCode As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = SUB_Code ];

/// Description
Property SUBDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = SUB_Desc ];

/// DateFrom
Property SUBDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = SUB_DateFrom ];

/// DateTo
Property SUBDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = SUB_DateTo ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBCEventSubType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCEventSubType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBCEventSubType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCEventSubType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBCEventSubType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCEventSubType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBCEventSubType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCEventSubType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBCEventSubType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBCEventSubType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1</ExtentSize>
<Property name="SUBChildsub">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUBCode">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUBDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUBDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUBDesc">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="SUBParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="SUB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUB_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SUB_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="SUB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^RBC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RBC_EventType.EVT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SUB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"EVT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RBC_EventType.EVT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SUB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SUB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SUB_RowId</SqlRowIdName>
<StreamLocation>^User.RBCEventSubTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
