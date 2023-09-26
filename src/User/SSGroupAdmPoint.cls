/// Group Admission Point(2418)
Class User.SSGroupAdmPoint Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupAdmPoint, StorageStrategy = SQLStorage ]
{

/// Des Ref AdmissionPoint
Property ADMPAdmissionPointDR As PACAdmissionPoint [ SqlColumnNumber = 3, SqlFieldName = ADMP_AdmissionPoint_DR ];

/// Childsub
Property ADMPChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"ADMP",0))}, SqlColumnNumber = 2, SqlFieldName = ADMP_Childsub ];

/// SS_Group Parent Reference
Relationship ADMPParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupAdmPoint, Required, SqlFieldName = ADMP_ParRef ];

Index RowIDBasedIDKeyIndex On ADMPChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 3;

Storage SQLStorage
{
<ExtentSize>3</ExtentSize>
<Property name="ADMPAdmissionPointDR">
<Selectivity>1</Selectivity>
</Property>
<Property name="ADMPChildsub">
<Selectivity>1</Selectivity>
</Property>
<Property name="ADMPParRef">
<Selectivity>1</Selectivity>
</Property>
<SQLMap name="Datamaster">
<Data name="ADMP_AdmissionPoint_DR">
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
<Field>ADMP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ADMP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{ADMP_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexAdmPoint">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>ADMP_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"ADMP"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"AdmPoint"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{ADMP_AdmissionPoint_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{ADMP_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>ADMP_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupAdmPointS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
