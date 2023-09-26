/// GroupCodingStatus(2402)
Class User.SSGroupCodingStatus Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupCodingStatus, StorageStrategy = SQLStorage ]
{

/// Childsub
Property CODSTChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"CODST",0))}, SqlColumnNumber = 2, SqlFieldName = CODST_Childsub ];

/// Des Ref CodingStatus
Property CODSTCodingStatusDR As MRCCodingStatus [ SqlColumnNumber = 3, SqlFieldName = CODST_CodingStatus_DR ];

/// SS_Group Parent Reference
Relationship CODSTParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupCodingStatus, Required, SqlFieldName = CODST_ParRef ];

Index RowIDBasedIDKeyIndex On CODSTChildsub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="CODST_CodingStatus_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>CODST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CODST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{CODST_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCodStat">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>CODST_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"CODST"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"CodStat"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{CODST_CodingStatus_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{CODST_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>CODST_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupCodingStatusS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
