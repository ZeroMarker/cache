/// CloseShiftAdjust(2733)
Class User.ARCloseShiftAdjust Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = AR_CloseShiftAdjust, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ADJChildsub [ IdKey, PrimaryKey, Unique ];

/// AR_CloseShift Parent Reference
Relationship ADJParRef As ARCloseShift [ Cardinality = parent, Inverse = ChildARCloseShiftAdjust, Required, SqlFieldName = ADJ_ParRef ];

/// Childsub
Property ADJChildsub As %Float [ InitialExpression = {$i(^AR("CLSH",$p(initvalue,$c(1)),"ADJ",0))}, SqlColumnNumber = 2, SqlFieldName = ADJ_Childsub ];

/// Date
Property ADJDate As %Date [ SqlColumnNumber = 3, SqlFieldName = ADJ_Date ];

/// Time
Property ADJTime As %Time [ SqlColumnNumber = 4, SqlFieldName = ADJ_Time ];

/// Amount
Property ADJAmount As %Float [ SqlColumnNumber = 5, SqlFieldName = ADJ_Amount ];

/// Des Ref Reason
Property ADJReasonDR As ARCCashShiftAdjust [ SqlColumnNumber = 6, SqlFieldName = ADJ_Reason_DR ];

/// UpdateDate
Property ADJUpdateDate As %Date [ SqlColumnNumber = 7, SqlFieldName = ADJ_UpdateDate ];

/// UpdateTime
Property ADJUpdateTime As %Time [ SqlColumnNumber = 8, SqlFieldName = ADJ_UpdateTime ];

/// Des Ref UpdateUser
Property ADJUpdateUserDR As SSUser [ SqlColumnNumber = 9, SqlFieldName = ADJ_UpdateUser_DR ];

/// Comments
Property ADJComments As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ADJ_Comments ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCloseShiftAdjust).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftAdjust","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCloseShiftAdjust).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftAdjust","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCloseShiftAdjust).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftAdjust","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCloseShiftAdjust).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftAdjust","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCloseShiftAdjust).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCloseShiftAdjust","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ADJ_Amount">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ADJ_Comments">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="ADJ_Date">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ADJ_Reason_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ADJ_Time">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ADJ_UpdateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ADJ_UpdateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="ADJ_UpdateUser_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Global>^AR</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>AR_CloseShift.CLS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>ADJ_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CLSH"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{AR_CloseShift.CLS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ADJ"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADJ_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ADJ_RowId</SqlRowIdName>
<StreamLocation>^User.ARCloseShiftAdjustS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
