/// MR PictResults(2785)
Class User.MRPictResults Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_PictResults, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On RESChildsub [ IdKey, PrimaryKey, Unique ];

/// MR_Pictures Parent Reference
Relationship RESParRef As MRPictures [ Cardinality = parent, Inverse = ChildMRPictResults, Required, SqlFieldName = RES_ParRef ];

/// Childsub
Property RESChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),"||"),"PIC",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"RES",0))}, SqlColumnNumber = 2, SqlFieldName = RES_Childsub ];

/// Des Ref OEOrdItem
Property RESLabResultDR As OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = RES_LabResult_DR ];

/// Des Ref TextResult
Property RESTextResultDR As OETextResult [ SqlColumnNumber = 4, SqlFieldName = RES_TextResult_DR ];

/// Des Ref OEOrdresult
Property RESWordResultDR As OEOrdResult [ SqlColumnNumber = 5, SqlFieldName = RES_WordResult_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.MRPictResults).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictResults","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.MRPictResults).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictResults","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.MRPictResults).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictResults","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.MRPictResults).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictResults","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictResults","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.MRPictResults).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.MRPictResults","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="RES_LabResult_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RES_TextResult_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="RES_WordResult_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
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
<Field>RES_Childsub</Field>
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
<Expression>"RES"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RES_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexLabRes">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>MR_Pictures.PIC_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"LabRes"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RES_LabResult_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_Pictures.PIC_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexTextRes">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>MR_Pictures.PIC_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"TextRes"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RES_TextResult_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_Pictures.PIC_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWordRes">
<Global>^MR</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L6}</Expression>
<Field>MR_Pictures.PIC_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L7}</Expression>
<Field>RES_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PIC"</Expression>
</Subscript>
<Subscript name="3">
<Expression>0</Expression>
</Subscript>
<Subscript name="4">
<Expression>"WordRes"</Expression>
</Subscript>
<Subscript name="5">
<Expression>{RES_WordResult_DR}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{MR_Pictures.PIC_Childsub}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RES_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RES_RowId</SqlRowIdName>
<StreamLocation>^User.MRPictResultsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
