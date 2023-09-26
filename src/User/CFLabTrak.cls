/// Config for LabTrak Interface(1296)
Class User.CFLabTrak Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = CF_LabTrak, StorageStrategy = SQLStorage ]
{

/// Des Ref to BillSub
Property LABBillSubDR As ARCBillSub [ SqlColumnNumber = 2, SqlFieldName = LAB_BillSub_DR ];

/// Des Ref to ServCat
Property LABServCatDR As ARCServCat [ SqlColumnNumber = 3, SqlFieldName = LAB_ServCat_DR ];

/// Des Ref ItemCat
Property LABItemCatDR As ARCItemCat [ SqlColumnNumber = 4, SqlFieldName = LAB_ItemCat_DR ];

/// Description
Property LABDescription As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = LAB_Description ];

/// Last Update Date
Property LABUpdateDate As %Date [ SqlColumnNumber = 6, SqlFieldName = LAB_UpdateDate ];

/// Last Update Time
Property LABUpdateTime As %Time [ SqlColumnNumber = 7, SqlFieldName = LAB_UpdateTime ];

/// Last Update User
Property LABUpdateUserDR As SSUser [ SqlColumnNumber = 8, SqlFieldName = LAB_UpdateUser_DR ];

/// Des Ref OrdCat
Property LABOrdCatDR As OECOrderCategory [ SqlColumnNumber = 9, SqlFieldName = LAB_OrdCat_DR ];

/// Link to ExtLabSystem
Property LABLinkExtLabSystem As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = LAB_LinkExtLabSystem ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.CFLabTrak).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFLabTrak","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.CFLabTrak).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFLabTrak","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.CFLabTrak).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFLabTrak","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.CFLabTrak).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFLabTrak","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.CFLabTrak).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.CFLabTrak","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^CF("LAB",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="LAB_BillSub_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="LAB_Description">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="LAB_ItemCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="LAB_LinkExtLabSystem">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="LAB_OrdCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="LAB_ServCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="LAB_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="LAB_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="LAB_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^CF</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>LAB_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"LAB"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{LAB_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>LAB_RowId</SqlRowIdName>
<StreamLocation>^User.CFLabTrakS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
