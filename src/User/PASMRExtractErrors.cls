/// PA SMR Extract Errors(2029)
Class User.PASMRExtractErrors Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = PA_SMRExtractErrors, StorageStrategy = SQLStorage ]
{

Index RowIDBasedIDKeyIndex On ERRChildsub [ IdKey, PrimaryKey, Unique ];

/// PA_SMRExtract Parent Reference
Relationship ERRParRef As PASMRExtract [ Cardinality = parent, Inverse = ChildPASMRExtractErrors, Required, SqlFieldName = ERR_ParRef ];

/// Childsub
Property ERRChildsub As %Float [ InitialExpression = {$i(^PASMRE($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ERR",0))}, SqlColumnNumber = 2, SqlFieldName = ERR_Childsub ];

/// Des Ref Error
Property ERRErrorDR As PACSMRError [ SqlColumnNumber = 3, SqlFieldName = ERR_Error_DR ];

/// Id
Property ERRId As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = ERR_Id ];

/// Code
Property ERRCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = ERR_Code ];

/// National Code
Property ERRNationalCode As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = ERR_NationalCode ];

/// Des Ref ExtractBuild
Property ERRExtractBuildDR As PASMRExtractBuild [ SqlColumnNumber = 7, SqlFieldName = ERR_ExtractBuild_DR ];

/// Parameters
Property ERRParameters As %String(COLLATION = "Exact", MAXLEN = 999, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = ERR_Parameters ];

/// Des Ref PAADM
Property ERRPAADMDR As PAAdm [ SqlColumnNumber = 9, SqlFieldName = ERR_PAADM_DR ];

Trigger TAfterIns [ Event = insert, Order = 1, Time = after ]
{
 d ##Class(User.PASMRExtractErrors).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractErrors","OnAfterInsert")
}

Trigger TAfterUpd [ Event = update, Order = 2, Time = after ]
{
 d ##Class(User.PASMRExtractErrors).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractErrors","OnAfterUpdate")
}

Trigger TBeforeDel [ Event = delete, Order = 3, Time = before ]
{
 d ##Class(User.PASMRExtractErrors).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractErrors","OnBeforeDelete")
}

Trigger TBeforeUpd [ Event = update, Order = 2, Time = before ]
{
 d ##Class(User.PASMRExtractErrors).getOld($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractErrors","OnBeforeUpdate")
}

Trigger TBeforeIns [ Event = insert, Order = 1, Time = before ]
{
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractErrors","OnBeforeInsert")
}

Trigger TAfterDel [ Event = delete, Order = 3, Time = after ]
{
 d ##Class(User.PASMRExtractErrors).OnTrigger($g(%d(1)))
 d ##Class(websys.DSSActionType).doSomething($g(%d(1)),"L","User.PASMRExtractErrors","OnAfterDelete")
}

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="ERR_Code">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ERR_Error_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ERR_ExtractBuild_DR">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="ERR_Id">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="ERR_NationalCode">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="ERR_PAADM_DR">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="ERR_Parameters">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Global>^PASMRE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_SMRExtract.SMRE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>ERR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{PA_SMRExtract.SMRE_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ERR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexExtractBuildErr">
<Global>^PASMREi</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_SMRExtract.SMRE_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L5}</Expression>
<Field>ERR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"ExtrBuildErrors"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{ERR_ExtractBuild_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{ERR_Error_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_SMRExtract.SMRE_RowId}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{ERR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ERR_RowId</SqlRowIdName>
<StreamLocation>^User.PASMRExtractErrorsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
