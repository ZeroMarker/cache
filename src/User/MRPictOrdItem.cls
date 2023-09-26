/// MR PictOrdItem(2540)
Class User.MRPictOrdItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PictOrdItem, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ORDChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Pictures Parent Reference
Relationship ORDParRef As MRPictures [ Cardinality = parent, Inverse = ChildMRPictOrdItem, Required, SqlFieldName = ORD_ParRef ];

/// Childsub
Property ORDChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"PIC",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ORD",0))}, SqlColumnNumber = 2, SqlFieldName = ORD_Childsub ];

/// Des Ref OEORI
Property ORDOEORIDR As OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = ORD_OEORI_DR ];

Trigger TAfterDel [ Event = DELETE, Order = 3, Time = AFTER ]
{
 d ##Class(User.MRPictOrdItem).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictOrdItem","OnAfterDelete")
}

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##Class(User.MRPictOrdItem).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictOrdItem","OnAfterInsert")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2, Time = AFTER ]
{
 d ##Class(User.MRPictOrdItem).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictOrdItem","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = DELETE, Order = 3 ]
{
 d ##Class(User.MRPictOrdItem).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictOrdItem","OnBeforeDelete")
}

Trigger TBeforeIns [ Event = INSERT, Order = 1 ]
{
}

Trigger TBeforeUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(User.MRPictOrdItem).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictOrdItem","OnBeforeUpdate")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ORD_OEORI_DR">
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
<Field>ORD_Childsub</Field>
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
<Expression>"ORD"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ORD_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexOEORI">
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
<Field>ORD_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Pic-Ord"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ORD_OEORI_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{MR_Pictures.PIC_Childsub}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ORD_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ORD_RowId</SqlRowIdName>
<StreamLocation>^User.MRPictOrdItemS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
