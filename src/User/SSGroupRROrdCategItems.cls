/// GroupRROrdCategItems(2356)
Class User.SSGroupRROrdCategItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupRROrdCategItems, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property ITMARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ITM_ARCIM_DR ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),"||"),"RESRR",$p(%d(0),"||",2),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// SS_GroupRROrdCateg Parent Reference
Relationship ITMParRef As SSGroupRROrdCateg [ Cardinality = parent, Inverse = ChildSSGroupRROrdCategItems, Required, SqlFieldName = ITM_ParRef ];

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="ITMARCIMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="ITM_ARCIM_DR">
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
<Field>SS_GroupRROrdCateg.RRCAT_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L6}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RESRR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_GroupRROrdCateg.RRCAT_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexARCIM">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>SS_GroupRROrdCateg.RRCAT_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L8}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RESRR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ITM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{SS_GroupRROrdCateg.RRCAT_Childsub}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexARCIM1">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SS_GroupRROrdCateg.RRCAT_Childsub</Field>
</RowIdSpec>
<RowIdSpec name="3">
<Expression>{L9}</Expression>
<Field>ITM_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"RESRR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_GroupRROrdCateg.RRCAT_Childsub}</Expression>
</Subscript>
<Subscript name="5">
<Expression>"ITM"</Expression>
</Subscript>
<Subscript name="6">
<Expression>0</Expression>
</Subscript>
<Subscript name="7">
<Expression>"ARCIM"</Expression>
</Subscript>
<Subscript name="8">
<Expression>{ITM_ARCIM_DR}</Expression>
</Subscript>
<Subscript name="9">
<Expression>{ITM_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ITM_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupRROrdCategItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
