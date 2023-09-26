Class User.DHCEmDocUpdPatLev Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DUPL_RowID, SqlTableName = DHC_EmDocUpdPatLev, StorageStrategy = SQLStorage ]
{

/// 就诊ID PAAdm
Property DUPLAdmDr As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = DUPL_Adm_Dr ];

/// 变更的分级
Property DUPLLevel As %Library.Integer [ SqlColumnNumber = 3, SqlFieldName = DUPL_Level ];

/// 变更分级的原因
Property DUPLUpdReasonDr As %String [ SqlColumnNumber = 4, SqlFieldName = DUPL_UpdReason_Dr ];

/// 护士分级评估
Property DUPLAssessDr As %String [ SqlColumnNumber = 5, SqlFieldName = DUPL_Assess_Dr ];

/// 评估说明
Property DUPLRemark As %Text(MAXLEN = 1000, MINLEN = 0) [ SqlColumnNumber = 6, SqlFieldName = DUPL_Remark ];

/// 操作人
Property DUPLOperator As User.SSUser [ SqlColumnNumber = 7, SqlFieldName = DUPL_Operator ];

/// 操作日期
Property DUPLOperateDate As %Date [ SqlColumnNumber = 8, SqlFieldName = DUPL_OperateDate ];

/// 操作时间
Property DUPLOperateTime As %Time [ SqlColumnNumber = 9, SqlFieldName = DUPL_OperateTime ];

/// 操作类型
Property DUPLOperateType As %String [ SqlColumnNumber = 10, SqlFieldName = DUPL_OperateType ];

/// 变更科室
Property DUPLUpdLocDr As User.CTLoc [ SqlColumnNumber = 11, SqlFieldName = DUPL_UpdLoc_Dr ];

/// 预检分级ID
Property DUPLChkDr As User.DHCEmPatCheckLev [ SqlColumnNumber = 12, SqlFieldName = DUPL_Chk_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCEMDUPL)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DUPL_Adm_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DUPL_Assess_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DUPL_Chk_Dr">
<Delimiter>"^"</Delimiter>
<Piece>11</Piece>
</Data>
<Data name="DUPL_Level">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DUPL_OperateDate">
<Delimiter>"^"</Delimiter>
<Piece>5</Piece>
</Data>
<Data name="DUPL_OperateTime">
<Delimiter>"^"</Delimiter>
<Piece>6</Piece>
</Data>
<Data name="DUPL_OperateType">
<Delimiter>"^"</Delimiter>
<Piece>9</Piece>
</Data>
<Data name="DUPL_Operator">
<Delimiter>"^"</Delimiter>
<Piece>7</Piece>
</Data>
<Data name="DUPL_Remark">
<Delimiter>"^"</Delimiter>
<Piece>8</Piece>
</Data>
<Data name="DUPL_UpdLoc_Dr">
<Delimiter>"^"</Delimiter>
<Piece>10</Piece>
</Data>
<Data name="DUPL_UpdReason_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCEMDUPL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DUPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DUPL_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexChkType">
<Global>^DHCEMDUPL</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DUPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"ChkType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DUPL_Chk_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DUPL_OperateType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DUPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPaAdm">
<Global>^DHCEMDUPL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DUPL_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"PAADM"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DUPL_Adm_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DUPL_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCEmDocUpdPatLevS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
