/// ItemCatQuestion(2065)
Class User.ARCItemCatQuestion Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = ARC_ItemCatQuestion, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On QUESChildsub [ IdKey, PrimaryKey, Unique ];

/// ARC_ItemCat Parent Reference
Relationship QUESParRef As ARCItemCat [ Cardinality = parent, Inverse = ChildARCItemCatQuestion, Required, SqlFieldName = QUES_ParRef ];

/// Childsub
Property QUESChildsub As %Float [ InitialExpression = {$i(^ARC("IC",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"QUES",0))}, SqlColumnNumber = 2, SqlFieldName = QUES_Childsub ];

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

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.ARCItemCatQuestion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCatQuestion","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.ARCItemCatQuestion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCatQuestion","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.ARCItemCatQuestion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCatQuestion","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.ARCItemCatQuestion).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCatQuestion","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCatQuestion","OnBeforeInsert")
}

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.ARCItemCatQuestion).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.ARCItemCatQuestion","OnAfterDelete")
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
<Global>^ARC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_ItemCat.ARCIC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>QUES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItemCat.ARCIC_RowId}</Expression>
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
<Global>^ARC</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>ARC_ItemCat.ARCIC_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>QUES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"IC"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ARC_ItemCat.ARCIC_RowId}</Expression>
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
<StreamLocation>^User.ARCItemCatQuestionS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
