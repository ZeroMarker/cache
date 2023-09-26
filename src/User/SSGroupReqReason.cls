/// GroupRequest Reason(2427)
Class User.SSGroupReqReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = SS_GroupReqReason, StorageStrategy = SQLStorage ]
{

/// Childsub
Property REQRChildsub As %Float [ InitialExpression = {$i(^SSU("SSGRP",$p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"REQR",0))}, SqlColumnNumber = 2, SqlFieldName = REQR_Childsub ];

/// SS_Group Parent Reference
Relationship REQRParRef As SSGroup [ Cardinality = parent, Inverse = ChildSSGroupReqReason, Required, SqlFieldName = REQR_ParRef ];

/// Des Ref RequestReason
Property REQRRequestReasonDR As RTCReasonRequest [ SqlColumnNumber = 3, SqlFieldName = REQR_RequestReason_DR ];

Index RowIDBasedIDKeyIndex On REQRChildsub [ IdKey, PrimaryKey, Unique ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SQLMap name="DataMaster">
<Data name="REQR_RequestReason_DR">
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
<Field>REQR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REQR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>{REQR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexReqReason">
<Global>^SSU</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>SS_Group.SSGRP_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L7}</Expression>
<Field>REQR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>"SSGRP"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{SS_Group.SSGRP_RowId}</Expression>
</Subscript>
<Subscript name="3">
<Expression>"REQR"</Expression>
</Subscript>
<Subscript name="4">
<Expression>0</Expression>
</Subscript>
<Subscript name="5">
<Expression>"Reason"</Expression>
</Subscript>
<Subscript name="6">
<Expression>{REQR_RequestReason_DR}</Expression>
</Subscript>
<Subscript name="7">
<Expression>{REQR_Childsub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>REQR_RowId</SqlRowIdName>
<StreamLocation>^User.SSGroupReqReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
