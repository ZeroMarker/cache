/// BillGroupType(2723)
Class User.ARCBillGroupType Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_BillGroupType, StorageStrategy = SQLStorage ]
{

/// Code
Property BILLGTCode As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = BILLGT_Code ];

/// Description
Property BILLGTDesc As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = BILLGT_Desc ];

/// Type
Property BILLGTType As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = BILLGT_Type ];

/// Default
Property BILLGTDefault As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 5, SqlFieldName = BILLGT_Default ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCBillGroupType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGroupType","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCBillGroupType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGroupType","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCBillGroupType).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGroupType","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCBillGroupType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGroupType","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCBillGroupType).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCBillGroupType","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^ARC("BILLGT",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BILLGT_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="BILLGT_Default">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="BILLGT_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="BILLGT_Type">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>BILLGT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BILLGT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{BILLGT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BILLGT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BILLGT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BILLGT_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BILLGT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>BILLGT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BILLGT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BILLGT_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{BILLGT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeCode">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BILLGT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BILLGT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TypeCode"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BILLGT_Type})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({BILLGT_Code})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BILLGT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTypeDesc">
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>BILLGT_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BILLGT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"TypeDesc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({BILLGT_Type})</Expression>
</Subscript>
<Subscript name="5">
<Expression>$$ALPHAUP({BILLGT_Desc})</Expression>
</Subscript>
<Subscript name="6">
<Expression>{BILLGT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>BILLGT_RowId</SqlRowIdName>
<StreamLocation>^User.ARCBillGroupTypeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
