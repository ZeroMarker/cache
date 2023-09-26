/// PA Questionnaire(1812)
Class User.PAQuestionnaire Extends (%Library.Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_Questionnaire, StorageStrategy = SQLStorage ]
{

Relationship ChildPAQuestionnaireAnswers As PAQuestionnaireAnswers [ Cardinality = children, Inverse = ANSParRef ];

/// Des Ref Adm
Property QUEAdmDR As PAAdm [ SqlColumnNumber = 4, SqlFieldName = QUE_Adm_DR ];

/// Childsub
Property QUEChildsub As %Float [ InitialExpression = {$i(^PAPER($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"QUE",0))}, SqlColumnNumber = 2, SqlFieldName = QUE_Childsub ];

/// Computed Score
Property QUEComputedScore As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = QUE_ComputedScore ];

/// Date
Property QUEDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 5, SqlFieldName = QUE_Date ];

/// PA_PatMas Parent Reference
Relationship QUEParRef As PAPatMas [ Cardinality = parent, Inverse = ChildPAQuestionnaire, Required, SqlFieldName = QUE_ParRef ];

/// Time
Property QUETime As %Time [ InitialExpression = {+$p($h,",",2)}, SqlColumnNumber = 6, SqlFieldName = QUE_Time ];

/// Des Ref User
Property QUEUserDR As SSUser [ SqlColumnNumber = 7, SqlFieldName = QUE_User_DR ];

/// Des REf UserWindow
Property QUEUserWindowDR As SSUserDefWindow [ SqlColumnNumber = 3, SqlFieldName = QUE_UserWindow_DR ];

Index RowIDBasedIDKeyIndex On QUEChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 505;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.PAQuestionnaire).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAQuestionnaire","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.PAQuestionnaire).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAQuestionnaire","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.PAQuestionnaire).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAQuestionnaire","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.PAQuestionnaire).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAQuestionnaire","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.PAQuestionnaire).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.PAQuestionnaire","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>505</ExtentSize>
<Property name="QUEAdmDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="QUEChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="QUEComputedScore">
<Selectivity>1</Selectivity>
</Property>
<Property name="QUEDate">
<Selectivity>1</Selectivity>
</Property>
<Property name="QUEParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="QUETime">
<Selectivity>1</Selectivity>
</Property>
<Property name="QUEUserDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="QUEUserWindowDR">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="QUE_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QUE_ComputedScore">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="QUE_Date">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QUE_Time">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QUE_UserWindow_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="QUE_User_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^PAPER</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_PatMas.PAPMI_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>QUE_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_PatMas.PAPMI_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"QUE"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{QUE_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>QUE_RowId</SqlRowIdName>
<StreamLocation>^User.PAQuestionnaireS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
