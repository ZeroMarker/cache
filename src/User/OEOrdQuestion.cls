/// OE Ord Question(1918)
Class User.OEOrdQuestion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OE_OrdQuestion, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On QAChildsub [ IdKey, PrimaryKey, Unique ];

/// OE_OrdItem Parent Reference
Relationship QAParRef As OEOrdItem [ Cardinality = parent, Inverse = ChildOEOrdQuestion, Required, SqlFieldName = QA_ParRef ];

/// Childsub
Property QAChildsub As %Float [ InitialExpression = {$i(^OEORD($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"I",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"QA",0))}, SqlColumnNumber = 2, SqlFieldName = QA_Childsub ];

/// Des Ref Question
Property QAQuestionDR As PACQuestion [ SqlColumnNumber = 3, SqlFieldName = QA_Question_DR ];

/// Answer
Property QAAnswer As %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = QA_Answer ];

/// Date
Property QADate As %Date [ SqlColumnNumber = 5, SqlFieldName = QA_Date ];

/// Time
Property QATime As %Time [ SqlColumnNumber = 6, SqlFieldName = QA_Time ];

/// Answer Multiline
Property QAAnswerMultiline As list Of %String(COLLATION = "Exact", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = QA_AnswerMultiline, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OEOrdQuestion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdQuestion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OEOrdQuestion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdQuestion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OEOrdQuestion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdQuestion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OEOrdQuestion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdQuestion","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OEOrdQuestion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OEOrdQuestion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="QA_Answer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QA_AnswerMultiline">
<Node>"ANS"</Node>
</Data>
<Data name="QA_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QA_Question_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QA_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^OEORD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>QA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"I"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"QA"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QA_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexQADate">
<Global>^OEORDi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>OE_Order.OEORD_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>OE_OrdItem.OEORI_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>QA_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"QADate"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{OE_Order.OEORD_RowId}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QA_Question_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QA_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{OE_OrdItem.OEORI_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{QA_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QA_RowId</SqlRowIdName>
<StreamLocation>^User.OEOrdQuestionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
