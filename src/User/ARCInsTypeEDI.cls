/// InsTypeEDI(2574)
Class User.ARCInsTypeEDI Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_InsTypeEDI, StorageStrategy = SQLStorage ]
{

/// Des Ref InsType
Property EDIInsTypeDR As ARCInsuranceType [ SqlColumnNumber = 2, SqlFieldName = EDI_InsType_DR ];

/// Path
Property EDIPath As %String(COLLATION = "Exact", MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = EDI_Path ];

/// FilePrefix
Property EDIFilePrefix As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = EDI_FilePrefix ];

/// LastFileNumber
Property EDILastFileNumber As %Float [ SqlColumnNumber = 5, SqlFieldName = EDI_LastFileNumber ];

/// Cache Routine
Property EDICacheRoutine As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = EDI_CacheRoutine ];

/// Active
Property EDIActive As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = EDI_Active ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCInsTypeEDI).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsTypeEDI","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCInsTypeEDI).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsTypeEDI","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCInsTypeEDI).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsTypeEDI","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCInsTypeEDI).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsTypeEDI","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCInsTypeEDI).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsTypeEDI","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCInsTypeEDI","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("INSEDI",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="EDI_Active">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="EDI_CacheRoutine">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="EDI_FilePrefix">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EDI_InsType_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="EDI_LastFileNumber">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="EDI_Path">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>EDI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSEDI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{EDI_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexInsType">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>EDI_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"INSEDI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"InsType"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EDI_InsType_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EDI_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>EDI_RowId</SqlRowIdName>
<StreamLocation>^User.ARCInsTypeEDIS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
