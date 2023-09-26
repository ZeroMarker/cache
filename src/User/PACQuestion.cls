/// PAC Question(1914)
Class User.PACQuestion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PAC_Question, StorageStrategy = SQLStorage ]
{

/// Code
Property QUESCode As %String(COLLATION = "AlphaUp", MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = QUES_Code ];

/// Description
Property QUESDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = QUES_Desc ];

/// Control Type
Property QUESControlType As %String(COLLATION = "AlphaUp", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = QUES_ControlType ];

/// Values
Property QUESValues As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = QUES_Values ];

/// Age From
Property QUESAgeFrom As %Float [ SqlColumnNumber = 6, SqlFieldName = QUES_AgeFrom ];

/// Age To
Property QUESAgeTo As %Float [ SqlColumnNumber = 7, SqlFieldName = QUES_AgeTo ];

/// Des Ref Sex
Property QUESSexDR As CTSex [ SqlColumnNumber = 8, SqlFieldName = QUES_Sex_DR ];

/// Text Length
Property QUESTextLength As %Float [ SqlColumnNumber = 9, SqlFieldName = QUES_TextLength ];

/// DefaultAnswer
Property QUESDefaultAnswer As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 10, SqlFieldName = QUES_DefaultAnswer ];

/// Date From
Property QUESDateFrom As %Date [ SqlColumnNumber = 11, SqlFieldName = QUES_DateFrom ];

/// Date To
Property QUESDateTo As %Date [ SqlColumnNumber = 12, SqlFieldName = QUES_DateTo ];

/// Decimal
Property QUESDecimal As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 13, SqlFieldName = QUES_Decimal ];

/// PositiveOnly
Property QUESPositiveOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 14, SqlFieldName = QUES_PositiveOnly ];

/// Other
Property QUESOther As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 15, SqlFieldName = QUES_Other ];

/// Field Type
Property QUESFieldType As %String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = QUES_FieldType ];

/// Number Of Days
Property QUESNumberOfDays As %Float [ SqlColumnNumber = 17, SqlFieldName = QUES_NumberOfDays ];

/// Atomic Test Result
Property QUESAtomicTestResult As list Of %String(COLLATION = "Exact", MAXLEN = "") [ SqlColumnNumber = 18, SqlFieldName = QUES_AtomicTestResult, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PACQuestion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PACQuestion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PACQuestion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PACQuestion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestion","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PACQuestion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PACQuestion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^PAC("QUES",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="QUES_AgeFrom">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QUES_AgeTo">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QUES_AtomicTestResult">
<Node>"ATOM"</Node>
</Data>
<Data name="QUES_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QUES_ControlType">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QUES_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="QUES_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="QUES_Decimal">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="QUES_DefaultAnswer">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="QUES_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QUES_FieldType">
<Delimiter>"^"</Delimiter>
<Piece>15</Piece>
</Data>
<Data name="QUES_NumberOfDays">
<Delimiter>"^"</Delimiter>
<Piece>16</Piece>
</Data>
<Data name="QUES_Other">
<Delimiter>"^"</Delimiter>
<Piece>14</Piece>
</Data>
<Data name="QUES_PositiveOnly">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="QUES_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="QUES_TextLength">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="QUES_Values">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^PAC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>QUES_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{QUES_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QUES_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({QUES_Code})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QUES_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDesc">
<Global>^PAC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>QUES_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"QUES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Desc"</Expression>
</Subscript>
<Subscript name="4">
<Expression>$$ALPHAUP({QUES_Desc})</Expression>
</Subscript>
<Subscript name="5">
<Expression>{QUES_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QUES_RowId</SqlRowIdName>
<StreamLocation>^User.PACQuestionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
