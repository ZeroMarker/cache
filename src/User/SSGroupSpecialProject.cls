/// GroupSpecialProject(2417)
Class User.SSGroupSpecialProject Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupSpecialProject, StorageStrategy = SQLStorage ]
{

/// Childsub
Property SPECPROChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"SPECPRO",0))}, SqlColumnNumber = 2, SqlFieldName = SPECPRO_Childsub ];

/// SS_Group Parent Reference
Relationship SPECPROParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupSpecialProject, Required, SqlFieldName = SPECPRO_ParRef ];

/// Des Ref SpecProject
Property SPECPROSpecProjectDR As PACSpecialProject [ SqlColumnNumber = 3, SqlFieldName = SPECPRO_SpecProject_DR ];

Index RowIDBasedIDKeyIndex On SPECPROChildsub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="Datamaster">
<Data name="SPECPRO_SpecProject_DR">
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
<Field>SPECPRO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SPECPRO"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SPECPRO_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSpecproject">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>SPECPRO_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"SPECPRO"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"SpecPro"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{SPECPRO_SpecProject_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SPECPRO_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>SPECPRO_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupSpecialProjectS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
