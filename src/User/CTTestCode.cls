/// Test Code(2276)
Class User.CTTestCode Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CT_TestCode, StorageStrategy = SQLStorage ]
{

/// Code
Property TCCode As %String(COLLATION = "Exact", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = TC_Code ];

/// Description
Property TCDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = TC_Desc ];

Index RowIDBasedIDKeyIndex On TCCode [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 1369;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CTTestCode).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTTestCode","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CTTestCode).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTTestCode","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CTTestCode).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTTestCode","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CTTestCode).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTTestCode","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CTTestCode).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CTTestCode","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>1369</ExtentSize>
<Property name="TCCode">
<Selectivity>1</Selectivity>
</Property>
<Property name="TCDesc">
<Selectivity>0.0909%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="TC_Desc">
<Delimiter>"\"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^TTAB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>TC_Code</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"TC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{TC_Code}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>TC_RowId</SqlRowIdName>
<StreamLocation>^User.CTTestCodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
