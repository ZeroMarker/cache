/// SS GroupAlertCategory(2062)
Class User.SSGroupAlertCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupAlertCategory, StorageStrategy = SQLStorage ]
{

/// Des Ref AlertCateg
Property ALCAlertCategDR As PACAlertCategory [ SqlColumnNumber = 3, SqlFieldName = ALC_AlertCateg_DR ];

/// Childsub
Property ALCChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ALC",0))}, SqlColumnNumber = 2, SqlFieldName = ALC_Childsub ];

/// SS_Group Parent Reference
Relationship ALCParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupAlertCategory, Required, SqlFieldName = ALC_ParRef ];

/// Read Only
Property ALCReadOnly As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ SqlColumnNumber = 4, SqlFieldName = ALC_ReadOnly ];

Index RowIDBasedIDKeyIndex On ALCChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 8;

Storage SQLStorage
{
<ExtentSize>8</ExtentSize>
<Property name="ALCAlertCategDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALCChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALCParRef">
<Selectivity>1</Selectivity>
</Property>
<Property name="ALCReadOnly">
<Selectivity>33.3333%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="ALC_AlertCateg_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="ALC_ReadOnly">
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
<Field>ALC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ALC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ALC_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAlert">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ALC_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ALC"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Alert"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ALC_AlertCateg_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ALC_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ALC_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupAlertCategoryS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
