/// MR Voice(MRVOI 1441)
Class User.MRVoice Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_Voice, StorageStrategy = SQLStorage ]
{

/// Childsub
Property VOIChildsub As %Float [ InitialExpression = {$i(^MR($p(%d(0),$c(1)),"VOI",0))}, SqlColumnNumber = 2, SqlFieldName = VOI_Childsub ];

/// Date Created
Property VOIDateCreated As %Date [ SqlColumnNumber = 5, SqlFieldName = VOI_DateCreated ];

/// Description
Property VOIDesc As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = VOI_Desc ];

/// MR_Adm Parent Reference
Relationship VOIParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRVoice, Required, SqlFieldName = VOI_ParRef ];

/// Path
Property VOIPath As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = VOI_Path ];

/// Time Created
Property VOITimeCreated As %Time [ SqlColumnNumber = 6, SqlFieldName = VOI_TimeCreated ];

/// User Created
Property VOIUserCreated As SSUser [ SqlColumnNumber = 7, SqlFieldName = VOI_UserCreated ];

Index RowIDBasedIDKeyIndex On VOIChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 26;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRVoice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRVoice","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRVoice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRVoice","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRVoice).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRVoice","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRVoice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRVoice","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRVoice).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRVoice","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>26</ExtentSize>
<Property name="VOIChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="VOIDateCreated">
<Selectivity>1</Selectivity>
</Property>
<Property name="VOIDesc">
<Selectivity>1</Selectivity>
</Property>
<Property name="VOIParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="VOIPath">
<Selectivity>1</Selectivity>
</Property>
<Property name="VOITimeCreated">
<Selectivity>1</Selectivity>
</Property>
<Property name="VOIUserCreated">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="VOI_DateCreated">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="VOI_Desc">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="VOI_Path">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="VOI_TimeCreated">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="VOI_UserCreated">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>VOI_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"VOI"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{VOI_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>VOI_RowId</SqlRowIdName>
<StreamLocation>^User.MRVoiceS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
