/// MRC Body Area Problems     (MRBAP,)
Class User.MRCBodyAreaProblems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_BodyAreaProblems, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On PROBChildsub [ IdKey, PrimaryKey, Unique ];

Relationship ChildMRCBodyAreaProblemsSubp As MRCBodyAreaProblemsSubp [ Cardinality = children, Inverse = SUBPParRef ];

/// MRC_BodyArea Parent Reference
Relationship PROBParRef As MRCBodyArea [ Cardinality = parent, Inverse = ChildMRCBodyAreaProblems, Required, SqlFieldName = PROB_ParRef ];

/// Childsub
Property PROBChildsub As %Float [ InitialExpression = {$i(^MRC("BODAR",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"PROB",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PROB_Childsub ];

/// Code
Property PROBCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PROB_Code ];

/// Description
Property PROBDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = PROB_Desc ];

/// Explanation
Property PROBExplanation As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PROB_Explanation, SqlListType = SUBNODE ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCBodyAreaProblems).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCBodyAreaProblems","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCBodyAreaProblems).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCBodyAreaProblems","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCBodyAreaProblems).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCBodyAreaProblems","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCBodyAreaProblems).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCBodyAreaProblems","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCBodyAreaProblems).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCBodyAreaProblems","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="PROB_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PROB_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PROB_Explanation">
<Node>"EXP"</Node>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_BodyArea.BODAR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PROB_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BODAR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_BodyArea.BODAR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PROB"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PROB_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PROB_RowId</SqlRowIdName>
<StreamLocation>^User.MRCBodyAreaProblemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
