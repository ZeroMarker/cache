/// CTOR: QP
/// DATE: 2020-07-22
/// DESC: 化疗日期申请表
Class User.ChemoPlanDateApply Extends %Persistent [ SqlTableName = Chemo_PlanDateApply, StorageStrategy = SQLStorage ]
{

Relationship PDAParRef As User.ChemoPlanDate [ Cardinality = parent, Inverse = ChildApply, Required, SqlFieldName = PDA_ParRef ];

Relationship ChildDetail As User.ChemoPlanDateApplyStatus [ Cardinality = children, Inverse = PASParRef ];

Relationship ChildItem As User.ChemoPlanDateApplyItem [ Cardinality = children, Inverse = PDAIParRef ];

Index RowIDBasedIDKeyIndex On PDAChildSub [ IdKey, PrimaryKey, Unique ];

/// PDA_ChildSub
Property PDAChildSub As %Numeric(SCALE = 0) [ InitialExpression = {$i(^BS.DOC.Chemo.PlanDate(+$s($d(initvalue):initvalue,1:%d(0)),"A",0))}, Required, SqlColumnNumber = 2, SqlFieldName = PDA_ChildSub ];

/// 申请人
Property PDAApplyUser As User.SSUser [ SqlColumnNumber = 3, SqlFieldName = PDA_ApplyUser ];

/// 申请科室
Property PDAApplyLoc As User.CTLoc [ SqlColumnNumber = 4, SqlFieldName = PDA_ApplyLoc ];

/// 状态(A,S,RS,Y,RY：申请，科室通过，科室拒绝，药房同意，药房拒绝)
Property PDAStatus As %String [ SqlColumnNumber = 5, SqlFieldName = PDA_Status ];

/// 申请日期
Property PDAApplyDate As %Date [ SqlColumnNumber = 6, SqlFieldName = PDA_ApplyDate ];

/// 申请时间
Property PDAApplyTime As %Time [ SqlColumnNumber = 7, SqlFieldName = PDA_ApplyTime ];

/// 要求审核人(科室审核)
Property PDANeedUser As User.SSUser [ SqlColumnNumber = 8, SqlFieldName = PDA_NeedUser ];

/// 要求审核科室(科室审核)
Property PDANeedLoc As User.CTLoc [ SqlColumnNumber = 9, SqlFieldName = PDA_NeedLoc ];

/// 最后审核日期
Property PDAAuditDate As %Date [ SqlColumnNumber = 10, SqlFieldName = PDA_AuditDate ];

/// 最后审核时间
Property PDAAuditTime As %Time [ SqlColumnNumber = 11, SqlFieldName = PDA_AuditTime ];

/// 最后审核人
Property PDAAuditUser As User.SSUser [ SqlColumnNumber = 12, SqlFieldName = PDA_AuditUser ];

/// 最后审核科室
Property PDAAuditLoc As User.CTLoc [ SqlColumnNumber = 13, SqlFieldName = PDA_AuditLoc ];

/// 拒绝原因
Property PDAReason As %String(COLLATION = "Exact", MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = PDA_Reason ];

/// 关联申请ID
Property PDALinkPDAID As %String(COLLATION = "Exact", MAXLEN = 2000, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = PDA_LinkPDAID ];

Trigger TAfterIns [ Event = INSERT, Order = 1, Time = AFTER ]
{
 d ##class(DHCDoc.Chemo.BS.DateApplyStatus).OnTrigger($g(%d(1)),"TAfterIns")
}

Trigger TAfterUpd [ Event = UPDATE, Order = 2 ]
{
 d ##Class(DHCDoc.Chemo.BS.DateApplyStatus).OnTrigger($g(%d(1)),"TAfterUpd")
}

Storage SQLStorage
{
<SQLMap name="DataMaster">
<Data name="PDA_ApplyDate">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PDA_ApplyLoc">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PDA_ApplyTime">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="PDA_ApplyUser">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PDA_AuditDate">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="PDA_AuditLoc">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="PDA_AuditTime">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="PDA_AuditUser">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="PDA_LinkPDAID">
<Delimiter>"^"</Delimiter>
<Piece>13</Piece>
</Data>
<Data name="PDA_NeedLoc">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="PDA_NeedUser">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="PDA_Reason">
<Delimiter>"^"</Delimiter>
<Piece>12</Piece>
</Data>
<Data name="PDA_Status">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^BS.DOC.Chemo.PlanDateD</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>Chemo_PlanDate.PD_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L3}</Expression>
<Field>PDA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{Chemo_PlanDate.PD_ID}</Expression>
</Subscript>
<Subscript name="2">
<Expression>"A"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDA_ChildSub}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IdxApplyDate">
<Global>^BS.DOC.Chemo.PlanDateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>Chemo_PlanDate.PD_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PDA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlanDateApply"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Chemo_PlanDate.PD_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDA_ApplyDate}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxApplyLoc">
<Global>^BS.DOC.Chemo.PlanDateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>Chemo_PlanDate.PD_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PDA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlanDateApply"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Chemo_PlanDate.PD_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDA_ApplyLoc}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IdxApplyUser">
<Global>^BS.DOC.Chemo.PlanDateI</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L2}</Expression>
<Field>Chemo_PlanDate.PD_ID</Field>
</RowIdSpec>
<RowIdSpec name="2">
<Expression>{L4}</Expression>
<Field>PDA_ChildSub</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"ChemoPlanDateApply"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{Chemo_PlanDate.PD_ID}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PDA_ApplyUser}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PDA_ChildSub}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PDA_ID</SqlRowIdName>
<StreamLocation>^User.ChemoPlanDateApplyS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
