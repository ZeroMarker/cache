/// 处方追踪主表（新疆中医院） 2017-12-22 hulihua 
/// d ##Class(User.DHCPhaPresTrack).%BuildIndices()
Class User.DHCPhaPresTrack Extends (%Library.Persistent, %XML.Adaptor, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlRowIdName = PHAPT_RowId, SqlTableName = DHC_PhaPresTrack, StorageStrategy = SQLStorage ]
{

/// 和子表做关联	
Relationship ChildDHCPhaPresTrackItm As User.DHCPhaPresTrackItm [ Cardinality = children, Inverse = PHAPTIPHAPTParRef ];

/// 就诊ID
Property PHAPTAdmDR As User.PAAdm [ SqlColumnNumber = 2, SqlFieldName = PHAPT_Adm_DR ];

/// 处方主医嘱ID
Property PHAPTMOEORIDR As User.OEOrdItem [ SqlColumnNumber = 3, SqlFieldName = PHAPT_MOEORI_DR ];

/// 处方号
Property PHAPTPrescNo As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = PHAPT_PrescNo ];

/// 处方当前状态
Property PHAPTNPreStateDR As User.DHCPhaPreState [ SqlColumnNumber = 5, SqlFieldName = PHAPT_NPreState_DR ];

Storage SQLStorage
{
<SqlIdExpression>$i(^PHAPRESTRACK)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PHAPT_Adm_DR">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PHAPT_MOEORI_DR">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PHAPT_NPreState_DR">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="PHAPT_PrescNo">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PHAPRESTRACK</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PHAPT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PHAPT_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexMOeori">
<Global>^PHAPRESTRACKi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHAPT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"MOEORI"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAPT_MOEORI_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPatAdmPresc">
<Global>^PHAPRESTRACKi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PHAPT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PatAdmPresc"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAPT_Adm_DR}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAPT_PrescNo}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PHAPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexPrescNo">
<Global>^PHAPRESTRACKi</Global>
<RowIdSpec name="1">
<Expression>{L3}</Expression>
<Field>PHAPT_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"PRESCNO"</Expression>
</Subscript>
<Subscript name="2">
<Expression>{PHAPT_PrescNo}</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PHAPT_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCPhaPresTrackS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
