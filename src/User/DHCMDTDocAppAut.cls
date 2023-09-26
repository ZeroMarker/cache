Class User.DHCMDTDocAppAut Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = DA_RowID, SqlTableName = DHC_MDTDocAppAut, StorageStrategy = SQLStorage ]
{

Relationship ChildDHCMDTDOCAPPAUTITM As User.DHCMDTDocAppAutItm [ Cardinality = children, Inverse = DIParRefDr ];

/// DA_Group_Dr  病种ID
Property DAGroupDr As User.DHCMDTGroup [ SqlColumnNumber = 2, SqlFieldName = DA_Group_Dr ];

/// DA_ Type  描述
Property DAType As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = DA_Type ];

/// 指针  DA_Pointer
Property DAPointer As %Library.String [ SqlColumnNumber = 4, SqlFieldName = DA_Pointer ];

Storage SQLStorage
{
<ExtentSize>250</ExtentSize>
<SqlIdExpression>$i(^DHCMDTDAA)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="DA_Group_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DA_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="DA_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Global>^DHCMDTDAA</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DA_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexGroup">
<Global>^DHCMDTDAA</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>DA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Group"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DA_Group_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexGroupType">
<Global>^DHCMDTDAA</Global>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>DA_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"GroupType"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DA_Group_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DA_Type}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DA_Pointer}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{DA_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCMDTDocAppAutS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
