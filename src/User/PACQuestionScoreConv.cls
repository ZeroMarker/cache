/// Question Score Conversion(2649)
Class User.PACQuestionScoreConv Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_QuestionScoreConv, StorageStrategy = SQLStorage ]
{

/// From
Property QSCFrom As %Float [ SqlColumnNumber = 2, SqlFieldName = QSC_From ];

/// To
Property QSCTo As %Float [ SqlColumnNumber = 3, SqlFieldName = QSC_To ];

/// Hours
Property QSCHours As %Float [ SqlColumnNumber = 4, SqlFieldName = QSC_Hours ];

/// Description
Property QSCDesc As list Of %String(COLLATION = "Exact", MAXLEN = "", TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = QSC_Desc, SqlListType = subnode ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PACQuestionScoreConv).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestionScoreConv","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PACQuestionScoreConv).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestionScoreConv","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PACQuestionScoreConv).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestionScoreConv","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PACQuestionScoreConv).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestionScoreConv","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PACQuestionScoreConv).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestionScoreConv","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestionScoreConv","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("QSC",0))</SqlIdExpression>
<SQLMap name="Datamaster">
<Data name="QSC_Desc">
<Node>"TXT"</Node>
</Data>
<Data name="QSC_From">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QSC_Hours">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QSC_To">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>QSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QSC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QSC_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexFrom">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QSC_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QSC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"From"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QSC_From}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QSC_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QSC_RowId</SqlRowIdName>
<StreamLocation>^User.PACQuestionScoreConvS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
