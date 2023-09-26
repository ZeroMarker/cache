/// RB Resource Close(1570)
Class User.RBResourceClose Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = RB_ResourceClose, StorageStrategy = SQLStorage ]
{

/// Date
Property CLDate As %Date [ SqlColumnNumber = 3, SqlFieldName = CL_Date ];

/// Des Ref Resource
Property CLResourceDR As RBResource [ SqlColumnNumber = 2, SqlFieldName = CL_Resource_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.RBResourceClose).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResourceClose","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.RBResourceClose).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResourceClose","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.RBResourceClose).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResourceClose","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.RBResourceClose).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResourceClose","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.RBResourceClose).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.RBResourceClose","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^RB("CL",0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="CL_Date">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="CL_Resource_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^RBCL</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>CL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{CL_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexResource">
<Global>^RBCL</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>CL_RowId</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"CL"</Expression>
</Subscript>
<Subscript name="2">
<Expression>0</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CL_Resource_DR}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{CL_Date}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CL_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CL_RowId</SqlRowIdName>
<StreamLocation>^User.RBResourceCloseS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
