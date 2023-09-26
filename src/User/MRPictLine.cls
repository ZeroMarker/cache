/// MR Picture Line         (MRPL,1204)
Class User.MRPictLine Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PictLine, StorageStrategy = SQLStorage ]
{

/// Childsub
Property MRPLChildsub As %Float [ InitialExpression = {$i(^MR($p(%d(0),"||"),"PIC",$p(%d(0),"||",2),"LIN",0))}, SqlColumnNumber = 2, SqlFieldName = MRPL_Childsub ];

/// Line
Property MRPLLine As list Of %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = MRPL_Line, SqlListType = SUBNODE ];

/// MR_Pictures Parent Reference
Relationship MRPLParRef As MRPictures [ Cardinality = parent, Inverse = ChildMRPictLine, Required, SqlFieldName = MRPL_ParRef ];

Index RowIDBasedIDKeyIndex On MRPLChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 37;

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRPictLine).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRPictLine","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRPictLine).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRPictLine","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRPictLine).OnTrigger(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRPictLine","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRPictLine).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRPictLine","OnBeforeInsert")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRPictLine).getOld(%d(1))
 do ##Class(websys.DSSActionType).doSomething(%d(1),"L","User.MRPictLine","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>37</ExtentSize>
<Property name="MRPLChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRPLLine">
<Selectivity>1</Selectivity>
</Property>
<Property name="MRPLParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="MRPL_Line">
<Node>"LIN"</Node>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>MR_Pictures.PIC_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L5}</Expression>
<Field>MRPL_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{MR_Pictures.PIC_Childsub}</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LIN"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MRPL_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>MRPL_RowId</SqlRowIdName>
<StreamLocation>^User.MRPictLineS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
