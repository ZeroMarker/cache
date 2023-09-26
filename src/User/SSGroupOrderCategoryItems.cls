/// GroupOrderCategoryItem(2357)
Class User.SSGroupOrderCategoryItems Extends (%Persistent, User.Abstract) [ ClassType = persistent, Not ProcedureBlock, SqlTableName = SS_GroupOrderCategoryItems, StorageStrategy = SQLStorage ]
{

/// Des Ref ARCIM
Property ITMARCIMDR As ARCItmMast [ SqlColumnNumber = 3, SqlFieldName = ITM_ARCIM_DR ];

/// Childsub
Property ITMChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),"||"),"SSORD",$p($s($d(initvalue):initvalue,1:%d(0)),"||",2),"ITM",0))}, SqlColumnNumber = 2, SqlFieldName = ITM_Childsub ];

/// SS_GroupOrderCategory Parent Reference
Relationship ITMParRef As SSGroupOrderCategory [ Cardinality = parent, Inverse = ChildSSGroupOrderCategoryItems, Required, SqlFieldName = ITM_ParRef ];

/// Unverified Order
Property ITMUnverifOrder As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ITM_UnverifOrder ];

/// ITM_IncludeExclude
Property ITMIncludeExclude As %String(DISPLAYLIST = ",Include,Exclude", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",I,E") [ SqlColumnNumber = 5, SqlFieldName = ITM_IncludeExclude ];

Index RowIDBasedIDKeyIndex On ITMChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 10;

Storage SQLStorage
{
<ExtentSize>10</ExtentSize>
<Property name="ITMARCIMDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="ITMUnverifOrder">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="ITM_ARCIM_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ITM_IncludeExclude">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="ITM_UnverifOrder">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^SSU</Global>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>SS_GroupOrderCategory.SSORD_Childsub</Field>
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
<Expression>"SSORD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_GroupOrderCategory.SSORD_Childsub}</Expression>
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
<Expression>{L4}</Expression>
<Field>SS_GroupOrderCategory.SSORD_Childsub</Field>
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
<Expression>"SSORD"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SS_GroupOrderCategory.SSORD_Childsub}</Expression>
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
<StreamLocation>^User.SSGroupOrderCategoryItemsS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
