/// GroupResult Read OrdCateg(2355)
Class User.SSGroupRROrdCateg Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupRROrdCateg, StorageStrategy = SQLStorage ]
{

Relationship ChildSSGroupRROrdCategItems As SSGroupRROrdCategItems [ Cardinality = children, Inverse = ITMParRef ];

/// Childsub
Property RRCATChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p(%d(0),$c(1)),"RESRR",0))}, SqlColumnNumber = 2, SqlFieldName = RRCAT_Childsub ];

/// Include Exclude
Property RRCATIncludeExclude As %String(DISPLAYLIST = ",Include,Exclude", MAXLEN = 7, TRUNCATE = 1, VALUELIST = ",I,E") [ SqlColumnNumber = 5, SqlFieldName = RRCAT_IncludeExclude ];

/// Des Ref OrdCat
Property RRCATOrdCatDR As OECOrderCategory [ SqlColumnNumber = 3, SqlFieldName = RRCAT_OrdCat_DR ];

/// Des Ref OrderSubCat
Property RRCATOrderSubCatDR As ARCItemCat [ SqlColumnNumber = 4, SqlFieldName = RRCAT_OrderSubCat_DR ];

/// SS_Group Parent Reference
Relationship RRCATParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupRROrdCateg, Required, SqlFieldName = RRCAT_ParRef ];

Index RowIDBasedIDKeyIndex On RRCATChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="RRCATChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="RRCATIncludeExclude">
<Selectivity>33.3333%</Selectivity>
</Property>
<Property name="RRCATOrdCatDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RRCATOrderSubCatDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="RRCATParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="RRCAT_IncludeExclude">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="RRCAT_OrdCat_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="RRCAT_OrderSubCat_DR">
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
<Field>RRCAT_Childsub</Field>
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
<Expression>{RRCAT_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexSubCat">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L8}</Expression>
<Field>RRCAT_Childsub</Field>
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
<Expression>"SubCat"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RRCAT_OrdCat_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RRCAT_OrderSubCat_DR}</Expression>
</Subscript>
<Subscript name="8">
<Expression>{RRCAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Indexcateg">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>RRCAT_Childsub</Field>
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
<Expression>"Categ"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{RRCAT_OrdCat_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{RRCAT_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>RRCAT_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupRROrdCategS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
