/// MRC Word Result Code(1460)
Class User.MRCWordResultCode Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_WordResultCode, StorageStrategy = SQLStorage ]
{

Relationship ChildMRCWordResultCodeUsers As MRCWordResultCodeUsers [ Cardinality = children, Inverse = USRParRef ];

/// Code
Property WORDCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = WORD_Code ];

/// Des Ref Order Sub Cat
Property WORDOrderSubCatDR As ARCItemCat [ SqlColumnNumber = 3, SqlFieldName = WORD_OrderSubCat_DR ];

/// Text
Property WORDText As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = WORD_Text, SqlListType = SUBNODE ];

/// des ref to SS_User
Property WORDUserDr As SSUser [ SqlColumnNumber = 5, SqlFieldName = WORD_UserDr ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCWordResultCode).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCWordResultCode","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCWordResultCode).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCWordResultCode","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCWordResultCode).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCWordResultCode","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCWordResultCode).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCWordResultCode","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCWordResultCode).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCWordResultCode","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^MRC("WORD",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="WORD_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="WORD_OrderSubCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="WORD_Text">
<Node>"TEXT"</Node>
</Data>
<Data name="WORD_UserDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>WORD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WORD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{WORD_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^MRC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>WORD_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"WORD"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({WORD_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{WORD_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>WORD_RowId</SqlRowIdName>
<StreamLocation>^User.MRCWordResultCodeS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
