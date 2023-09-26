/// AR Pat Bill Discount(1758)
Class User.ARPatBillDiscount Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_PatBillDiscount, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On DISCChildsub [ IdKey, PrimaryKey, Unique ];

/// AR_PatientBill Parent Reference
Relationship DISCParRef As ARPatientBill [ Cardinality = parent, Inverse = ChildARPatBillDiscount, Required, SqlFieldName = DISC_ParRef ];

/// Childsub
Property DISCChildsub As %Float [ InitialExpression = {$i(^ARPBL($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"DISC",0))}, SqlColumnNumber = 2, SqlFieldName = DISC_Childsub ];

/// Discret Amt
Property DISCDiscretAmt As %Float [ SqlColumnNumber = 3, SqlFieldName = DISC_DiscretAmt ];

/// Des Ref DiscType
Property DISCDiscTypeDR As ARCDiscretDiscType [ SqlColumnNumber = 4, SqlFieldName = DISC_DiscType_DR ];

/// Empl Name Disc
Property DISCEmplNameDisc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = DISC_EmplNameDisc ];

/// Department Disc
Property DISCDepartDisc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = DISC_DepartDisc ];

/// Comment Discount
Property DISCCommentDisc As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = DISC_CommentDisc ];

/// Date
Property DISCDate As %Date [ SqlColumnNumber = 8, SqlFieldName = DISC_Date ];

/// Time
Property DISCTime As %Time [ SqlColumnNumber = 9, SqlFieldName = DISC_Time ];

/// Des Ref User
Property DISCUserDR As SSUser [ SqlColumnNumber = 10, SqlFieldName = DISC_User_DR ];

/// Des Ref AccountPeriod
Property DISCAccountPeriodDR As BLCAccountingPeriod [ SqlColumnNumber = 11, SqlFieldName = DISC_AccountPeriod_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARPatBillDiscount).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscount","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARPatBillDiscount).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscount","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARPatBillDiscount).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscount","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARPatBillDiscount).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscount","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARPatBillDiscount).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscount","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARPatBillDiscount","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="DISC_AccountPeriod_DR">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DISC_CommentDisc">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DISC_Date">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DISC_DepartDisc">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DISC_DiscType_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DISC_DiscretAmt">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DISC_EmplNameDisc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DISC_Time">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DISC_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Global>^ARPBL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>AR_PatientBill.ARPBL_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>DISC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{AR_PatientBill.ARPBL_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DISC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DISC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>DISC_RowId</SqlRowIdName>
<StreamLocation>^User.ARPatBillDiscountS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
