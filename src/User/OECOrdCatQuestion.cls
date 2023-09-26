/// OEC Order Cat Question(1915)
Class User.OECOrdCatQuestion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = OEC_OrdCatQuestion, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On QUESChildsub [ IdKey, PrimaryKey, Unique ];

/// OEC_OrderCategory Parent Reference
Relationship QUESParRef As OECOrderCategory [ Cardinality = parent, Inverse = ChildOECOrdCatQuestion, Required, SqlFieldName = QUES_ParRef ];

/// Childsub
Property QUESChildsub As %Float [ InitialExpression = {$i(^OEC("ORCAT",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"QUES",0))}, SqlColumnNumber = 2, SqlFieldName = QUES_Childsub ];

/// Des Ref Question
Property QUESQuestionDR As PACQuestion [ SqlColumnNumber = 3, SqlFieldName = QUES_Question_DR ];

/// Mandatory
Property QUESMandatory As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = QUES_Mandatory ];

/// Date From
Property QUESDateFrom As %Date [ SqlColumnNumber = 5, SqlFieldName = QUES_DateFrom ];

/// Date To
Property QUESDateTo As %Date [ SqlColumnNumber = 6, SqlFieldName = QUES_DateTo ];

/// ClinicalDetails
Property QUESClinicalDetails As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 7, SqlFieldName = QUES_ClinicalDetails ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.OECOrdCatQuestion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatQuestion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.OECOrdCatQuestion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatQuestion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.OECOrdCatQuestion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatQuestion","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.OECOrdCatQuestion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatQuestion","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatQuestion","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.OECOrdCatQuestion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.OECOrdCatQuestion","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="QUES_ClinicalDetails">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="QUES_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="QUES_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="QUES_Mandatory">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="QUES_Question_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^OEC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_OrderCategory.ORCAT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>QUES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_OrderCategory.ORCAT_RowId}</Expression>
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
<SQLMap name="IndexQuestion">
<Global>^OEC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>OEC_OrderCategory.ORCAT_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>QUES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ORCAT"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{OEC_OrderCategory.ORCAT_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"QUES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Question"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{QUES_Question_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{QUES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>QUES_RowId</SqlRowIdName>
<StreamLocation>^User.OECOrdCatQuestionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
