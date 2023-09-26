/// PA Questionnaire Answers(1813)
Class User.PAQuestionnaireAnswers Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_QuestionnaireAnswers, StorageStrategy = SQLStorage ]
{

/// Childsub
Property ANSChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),"||",1),"QUE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ANS",0))}, SqlColumnNumber = 2, SqlFieldName = ANS_Childsub ];

/// PA_Questionnaire Parent Reference
Relationship ANSParRef As PAQuestionnaire [ Cardinality = parent, Inverse = ChildPAQuestionnaireAnswers, Required, SqlFieldName = ANS_ParRef ];

/// Des Ref UserWinControl
Property ANSUserWinControlDR As SSUserDefWindowControls [ SqlColumnNumber = 3, SqlFieldName = ANS_UserWinControl_DR ];

/// Value
Property ANSValue As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ANS_Value ];

Index RowIDBasedIDKeyIndex On ANSChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 2724;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAQuestionnaireAnswers).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAQuestionnaireAnswers","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAQuestionnaireAnswers).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAQuestionnaireAnswers","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAQuestionnaireAnswers).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAQuestionnaireAnswers","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAQuestionnaireAnswers).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAQuestionnaireAnswers","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAQuestionnaireAnswers).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAQuestionnaireAnswers","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>2724</ExtentSize>
<Property name="ANSChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANSParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANSUserWinControlDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ANSValue">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ANS_UserWinControl_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ANS_Value">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PA_Questionnaire.QUE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>ANS_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"QUE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Questionnaire.QUE_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"ANS"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ANS_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>ANS_RowId</SqlRowIdName>
<StreamLocation>^User.PAQuestionnaireAnswersS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
