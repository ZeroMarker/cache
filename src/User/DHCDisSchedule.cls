Class User.DHCDisSchedule Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = SCH_RowID, SqlTableName = DHC_DisSchedule, StorageStrategy = SQLStorage ]
{

/// 排班类型  SCH_DisSch_Dr 
Property SCHDisSchDr As User.DHCDisScheduleType [ SqlColumnNumber = 2, SqlFieldName = SCH_DisSch_Dr ];

/// 配送任务类型  SCH_DisType_Dr
Property SCHDisTypeDr As User.DHCDisTypeAdd [ SqlColumnNumber = 3, SqlFieldName = SCH_DisType_Dr ];

/// 工作岗位  SCH_Node_Dr 
Property SCHNodeDr As User.DHCDisWorkNode [ SqlColumnNumber = 4, SqlFieldName = SCH_Node_Dr ];

/// 工作人员  SCH_SSUser_Dr
Property SCHSSUserDr As User.SSUser [ SqlColumnNumber = 5, SqlFieldName = SCH_SSUser_Dr ];

Storage SQLStorage
{
<SqlIdExpression>$i(^DHCDISSCH)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="SCH_DisSch_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="SCH_DisType_Dr">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="SCH_Node_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="SCH_SSUser_Dr">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Global>^DHCDISSCH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>SCH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{SCH_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNode">
<Global>^DHCDISSCH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SCH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Nodepoint"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCH_Node_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SCH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSchtId">
<Global>^DHCDISSCH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>SCH_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"point"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{SCH_DisSch_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{SCH_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisScheduleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
