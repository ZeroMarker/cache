/// MRC BodyAreaProblemsSubp(1330)
Class User.MRCBodyAreaProblemsSubp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_BodyAreaProblemsSubp, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On SUBPChildsub [ IdKey, PrimaryKey, Unique ];

/// MRC_BodyAreaProblems Parent Reference
Relationship SUBPParRef As MRCBodyAreaProblems [ Cardinality = parent, Inverse = ChildMRCBodyAreaProblemsSubp, Required, SqlFieldName = SUBP_ParRef ];

/// Childsub
Property SUBPChildsub As %Float [ InitialExpression = {$i(^MRC("BODAR",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"PROB",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SUBP",0))}, SqlColumnNumber = 2, SqlFieldName = SUBP_Childsub ];

/// Code
Property SUBPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SUBP_Code ];

/// Description
Property SUBPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = SUBP_Desc ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCBodyAreaProblemsSubp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCBodyAreaProblemsSubp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCBodyAreaProblemsSubp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCBodyAreaProblemsSubp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCBodyAreaProblemsSubp).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCBodyAreaProblemsSubp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCBodyAreaProblemsSubp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCBodyAreaProblemsSubp","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCBodyAreaProblemsSubp).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRCBodyAreaProblemsSubp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="SUBP_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SUBP_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_BodyArea.BODAR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRC_BodyAreaProblems.PROB_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SUBP_Childsub</Field>
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
<Expression>{MRC_BodyAreaProblems.PROB_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SUBP"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SUBP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>SUBP_RowId</SqlRowIdName>
<StreamLocation>^User.MRCBodyAreaProblemsSubpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
