/// ORC Operation Category(1518)
Class User.ORCOperationCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ORC_OperationCategory, StorageStrategy = SQLStorage ]
{

/// Code
Property CATEGCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = CATEG_Code ];

/// Description
Property CATEGDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = CATEG_Desc ];

/// DateFrom
Property CATEGDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = CATEG_DateFrom ];

/// DateTo
Property CATEGDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = CATEG_DateTo ];

/// Des Ref Questionnaire
Property CATEGQuestionnaireDR As SSUserDefWindow [ SqlColumnNumber = 6, SqlFieldName = CATEG_Questionnaire_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.ORCOperationCategory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationCategory","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.ORCOperationCategory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationCategory","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.ORCOperationCategory).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationCategory","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.ORCOperationCategory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationCategory","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationCategory","OnBeforeInsert")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.ORCOperationCategory).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ORCOperationCategory","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="CATEGCode">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CATEGDateFrom">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CATEGDateTo">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="CATEGDesc">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="CATEGQuestionnaireDR">
<Selectivity>100.0000%</Selectivity>
</Property>
<SqlIdExpression>$i(^ORC("CATEG",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CATEG_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="CATEG_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="CATEG_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="CATEG_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CATEG_Questionnaire_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^ORC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CATEG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CATEG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CATEG_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CATEG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CATEG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CATEG_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CATEG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^ORC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>CATEG_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CATEG"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({CATEG_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CATEG_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CATEG_RowId</SqlRowIdName>
<StreamLocation>^User.ORCOperationCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
