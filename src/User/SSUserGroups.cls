/// SS User Groups(1986)
Class User.SSUserGroups Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_UserGroups, StorageStrategy = SQLStorage ]
{

/// Childsub
Property GRPChildsub As %Float [ InitialExpression = {$i(^SSU("SSUSR",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"GRP",0))}, SqlColumnNumber = 2, SqlFieldName = GRP_Childsub ];

/// Date From
Property GRPDateFrom As %Date [ SqlColumnNumber = 4, SqlFieldName = GRP_DateFrom ];

/// Date To
Property GRPDateTo As %Date [ SqlColumnNumber = 5, SqlFieldName = GRP_DateTo ];

/// Des Ref Group
Property GRPGroupDR As SSGroup [ SqlColumnNumber = 3, SqlFieldName = GRP_Group_DR ];

/// SS_User Parent Reference
Relationship GRPParRef As SSUser [ Cardinality = parent, Inverse = ChildSSUserGroups, Required, SqlFieldName = GRP_ParRef ];

Index RowIDBasedIDKeyIndex On GRPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 26;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.SSUserGroups).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserGroups","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.SSUserGroups).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserGroups","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.SSUserGroups).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserGroups","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.SSUserGroups).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserGroups","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.SSUserGroups).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.SSUserGroups","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>26</ExtentSize>
<Property name="GRPChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="GRPDateFrom">
<Selectivity>1</Selectivity>
</Property>
<Property name="GRPDateTo">
<Selectivity>1</Selectivity>
</Property>
<Property name="GRPGroupDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="GRPParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="GRP_DateFrom">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="GRP_DateTo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="GRP_Group_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>GRP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GRP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{GRP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_User.SSUSR_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>GRP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSUSR"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_User.SSUSR_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"GRP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{GRP_Group_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{GRP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>GRP_RowId</SqlRowIdName>
<StreamLocation>^User.SSUserGroupsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
