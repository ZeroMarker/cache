/// ConsultCategQuestion(2696)
Class User.OECConsultCategQuestion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_ConsultCategQuestion, StorageStrategy = SQLStorage ]
{

Parameter EXTENTSIZE = 5;

Index RowIDBasedIDKeyIndex On QUESChildsub [ IdKey, PrimaryKey, Unique ];

/// OEC_ConsultCateg Parent Reference
Relationship QUESParRef As OECConsultCateg [ Cardinality = parent, Inverse = ChildOECConsultCategQuestion, Required, SqlFieldName = QUES_ParRef ];

/// Childsub
Property QUESChildsub As %Float [ InitialExpression = {$i(^OEC("CONS",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"QUES",0))}, SqlColumnNumber = 2, SqlFieldName = QUES_Childsub ];

/// Des Ref UserDefWindow
Property QUESUserDefWindowDR As SSUserDefWindow [ SqlColumnNumber = 3, SqlFieldName = QUES_UserDefWindow_DR ];

/// PrimaryQuestionnaire
Property QUESPrimaryQuestionnaire As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = QUES_PrimaryQuestionnaire ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.OECConsultCategQuestion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategQuestion","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.OECConsultCategQuestion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategQuestion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.OECConsultCategQuestion).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategQuestion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.OECConsultCategQuestion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategQuestion","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.OECConsultCategQuestion).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECConsultCategQuestion","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>5</ExtentSize>
<Property name="QUESChildsub">
<Selectivity>20.0000%</Selectivity>
</Property>
<Property name="QUESParRef">
<Selectivity>100.0000%</Selectivity>
</Property>
<Property name="QUESPrimaryQuestionnaire">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="QUESUserDefWindowDR">
<Selectivity>20.0000%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="QUES_PrimaryQuestionnaire">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QUES_UserDefWindow_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>QUES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"QUES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{QUES_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexQuest">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_ConsultCateg.CONS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>QUES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CONS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_ConsultCateg.CONS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"QUES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Ques"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{QUES_UserDefWindow_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{QUES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QUES_RowId</SqlRowIdName>
<StreamLocation>^User.OECConsultCategQuestionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
