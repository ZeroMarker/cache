/// FollowUpReason(2196)
Class User.MRFollowUpReason Extends (%Persistent, User.Abstract) [ ClassType = persistent, Inheritance = right, Not ProcedureBlock, SqlTableName = MR_FollowUpReason, StorageStrategy = SQLStorage ]
{

/// Childsub
Property FURChildsub As %Float [ InitialExpression = {$i(^MR($p($s($d(initvalue):initvalue,1:%d(0)),$c(1)),"FUR",0))}, SqlColumnNumber = 2, SqlFieldName = FUR_Childsub ];

/// FollowUpReason
Property FURFollowUpReason As %String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = FUR_FollowUpReason ];

/// Des Ref FollowUpReason
Property FURFollowUpReasonDR As PACFollowUpReason [ SqlColumnNumber = 3, SqlFieldName = FUR_FollowUpReason_DR ];

/// MR_Adm Parent Reference
Relationship FURParRef As MRAdm [ Cardinality = parent, Inverse = ChildMRFollowUpReason, Required, SqlFieldName = FUR_ParRef ];

Index RowIDBasedIDKeyIndex On FURChildsub [ IdKey, PrimaryKey, Unique ];

Parameter EXTENTSIZE = 20;

Storage SQLStorage
{
<ExtentSize>20</ExtentSize>
<Property name="FURChildsub">
<Selectivity>5.0000%</Selectivity>
</Property>
<Property name="FURFollowUpReason">
<Selectivity>50.0000%</Selectivity>
</Property>
<Property name="FURFollowUpReasonDR">
<Selectivity>14.2857%</Selectivity>
</Property>
<Property name="FURParRef">
<Selectivity>12.5000%</Selectivity>
</Property>
<SQLMap name="DataMaster">
<Data name="FUR_FollowUpReason">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="FUR_FollowUpReason_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^MR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>MR_Adm.MRADM_RowId</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>FUR_Childsub</Field>
</RowIdSpec>
<Structure>delimited</Structure>
<Subscript name="1">
<Expression>{MR_Adm.MRADM_RowId}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"FUR"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{FUR_Childsub}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>FUR_RowId</SqlRowIdName>
<StreamLocation>^User.MRFollowUpReasonS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
