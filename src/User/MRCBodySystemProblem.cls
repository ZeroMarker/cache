/// MRC Body System Problms(MRBSP,1069)
Class User.MRCBodySystemProblem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_BodySystemProblem, StorageStrategy = SQLStorage ]
{

Relationship ChildMRCBodySystemProblemSubp As MRCBodySystemProblemSubp [ Cardinality = children, Inverse = SUBPParRef ];

/// Childsub
Property PROChildsub As %Float [ InitialExpression = {$i(^MRC("BODS",$p(%d(0),$c(1)),"PRO",0))}, SqlColumnNumber = 2, SqlFieldName = PRO_Childsub ];

/// Code
Property PROCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = PRO_Code ];

/// Description
Property PRODesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = PRO_Desc ];

/// Explanation
Property PROExplanation As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = PRO_Explanation, SqlListType = SUBNODE ];

/// MRC_BodySystems Parent Reference
Relationship PROParRef As MRCBodySystems [ Cardinality = parent, Inverse = ChildMRCBodySystemProblem, Required, SqlFieldName = PRO_ParRef ];

Index RowIDBasedIDKeyIndex On PROChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 557;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCBodySystemProblem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodySystemProblem","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCBodySystemProblem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodySystemProblem","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCBodySystemProblem).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodySystemProblem","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCBodySystemProblem).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodySystemProblem","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCBodySystemProblem).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodySystemProblem","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>557</ExtentSize>
<Property name="PROChildsub">
<Selectivity>2.1277%</Selectivity>
</Property>
<Property name="PROCode">
<Selectivity>0.3165%</Selectivity>
</Property>
<Property name="PRODesc">
<Selectivity>0.2740%</Selectivity>
</Property>
<Property name="PROExplanation">
<Selectivity>12.5000%</Selectivity>
</Property>
<Property name="PROParRef">
<Selectivity>1.8182%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="PRO_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PRO_Desc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PRO_Explanation">
<Node>"EXP"</Node>
</Data>
<Global>^MRC</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>MRC_BodySystems.BODS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PRO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"BODS"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{MRC_BodySystems.BODS_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"PRO"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PRO_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>PRO_RowId</SqlRowIdName>
<StreamLocation>^User.MRCBodySystemProblemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
