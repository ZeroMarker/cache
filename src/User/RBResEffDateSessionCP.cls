/// ResEffDateSessionCP(2391)
Class User.RBResEffDateSessionCP Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResEffDateSessionCP, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On CPChildsub [ IdKey, PrimaryKey, Unique ];

/// RB_ResEffDateSession Parent Reference
Relationship CPParRef As RBResEffDateSession [ Cardinality = parent, Inverse = ChildRBResEffDateSessionCP, Required, SqlFieldName = CP_ParRef ];

/// Childsub
Property CPChildsub As %Float [ InitialExpression = {$i(^RB("RES",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"DATE",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"SESS",$p($s($d(initvalue):initvalue,1:%d(0)),"||",3),"CP",0))}, SqlColumnNumber = 2, SqlFieldName = CP_Childsub ];

/// Des Ref CTCP
Property CPCTCPDR As CTCareProv [ SqlColumnNumber = 3, SqlFieldName = CP_CTCP_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessionCP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessionCP","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessionCP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessionCP","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResEffDateSessionCP).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessionCP","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResEffDateSessionCP).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessionCP","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResEffDateSessionCP).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.RBResEffDateSessionCP","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="CP_CTCP_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RB</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>CP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"CP"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{CP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexDoc">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L11}</Expression>
<Field>CP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"DATE"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SESS"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>"CP"</Expression>
</Subscript>
<Subscript name="8">
<Expression>0</Expression>
</Subscript>
<Subscript name="9">
<Expression>"Doc"</Expression>
</Subscript>
<Subscript name="10">
<Expression>{CP_CTCP_DR}</Expression>
</Subscript>
<Subscript name="11">
<Expression>{CP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexDoc1">
<Global>^RB</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>RB_Resource.RES_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>RB_ResEffDate.DATE_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>RB_ResEffDateSession.SESS_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="4">
<Expression>{L8}</Expression>
<Field>CP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"Doc1"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CP_CTCP_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RB_Resource.RES_RowId}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RB_ResEffDate.DATE_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RB_ResEffDateSession.SESS_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{CP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CP_RowId</SqlRowIdName>
<StreamLocation>^User.RBResEffDateSessionCPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
