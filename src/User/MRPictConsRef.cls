/// PictConsRef(2763)
Class User.MRPictConsRef Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PictConsRef, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On REFChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Pictures Parent Reference
Relationship REFParRef As MRPictures [ Cardinality = parent, Inverse = ChildMRPictConsRef, Required, SqlFieldName = REF_ParRef ];

/// Childsub
Property REFChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"PIC",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"CREF",0))}, SqlColumnNumber = 2, SqlFieldName = REF_Childsub ];

/// Des Ref ConsultRef
Property REFConsultRefDR As PAPersonConsultSetConsR [ SqlColumnNumber = 3, SqlFieldName = REF_ConsultRef_DR ];

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRPictConsRef).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictConsRef","OnAfterDelete")
}

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRPictConsRef).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictConsRef","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRPictConsRef).OnTrigger($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictConsRef","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRPictConsRef).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictConsRef","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRPictConsRef).getOld($g(%d(1)))

 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictConsRef","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictConsRef","OnBeforeInsert")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="REF_ConsultRef_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
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
<Field>REF_Childsub</Field>
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
<Expression>"CREF"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{REF_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexConsRef">
<Global>^MRi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>MR_Pictures.PIC_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>REF_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PIC-ConsRef"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{REF_ConsultRef_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Pictures.PIC_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{REF_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REF_RowId</SqlRowIdName>
<StreamLocation>^User.MRPictConsRefS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
