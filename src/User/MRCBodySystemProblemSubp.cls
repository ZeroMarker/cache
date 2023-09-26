/// MRC BodySystemProblemSubp(1329)
Class User.MRCBodySystemProblemSubp Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MRC_BodySystemProblemSubp, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SUBPChildsub As %Float [ InitialExpression = {$i(^MRC("BODS",$p(%d(0),"||"),"PRO",$p(%d(0),"||",2),"SUBP",0))}, SqlColumnNumber = 2, SqlFieldName = SUBP_Childsub ];

/// Code
Property SUBPCode As %String(COLLATION = "AlphaUp", MAXLEN = 15, TRUNCATE = 1) [ Required, SqlColumnNumber = 3, SqlFieldName = SUBP_Code ];

/// Description
Property SUBPDesc As %String(COLLATION = "AlphaUp", MAXLEN = 220, TRUNCATE = 1) [ Required, SqlColumnNumber = 4, SqlFieldName = SUBP_Desc ];

/// MRC_BodySystemProblem Parent Reference
Relationship SUBPParRef As MRCBodySystemProblem [ Cardinality = parent, Inverse = ChildMRCBodySystemProblemSubp, Required, SqlFieldName = SUBP_ParRef ];

Index RowIDBasedIDKeyIndex On SUBPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 345;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRCBodySystemProblemSubp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodySystemProblemSubp","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRCBodySystemProblemSubp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodySystemProblemSubp","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRCBodySystemProblemSubp).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodySystemProblemSubp","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRCBodySystemProblemSubp).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodySystemProblemSubp","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRCBodySystemProblemSubp).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRCBodySystemProblemSubp","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>345</ExtentSize>
<Property name="SUBPChildsub">
<Selectivity>2.7027%</Selectivity>
</Property>
<Property name="SUBPCode">
<Selectivity>0.6494%</Selectivity>
</Property>
<Property name="SUBPDesc">
<Selectivity>0.4831%</Selectivity>
</Property>
<Property name="SUBPParRef">
<Selectivity>1.3514%</Selectivity>
</Property>
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
<Field>MRC_BodySystems.BODS_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>MRC_BodySystemProblem.PRO_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>SUBP_Childsub</Field>
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
<Expression>{MRC_BodySystemProblem.PRO_Childsub}</Expression>
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
<StreamLocation>^User.MRCBodySystemProblemSubpS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
