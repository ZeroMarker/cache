Class User.DHCEmConsGrant Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = EC_RowID, SqlTableName = DHC_EmConsGrant, StorageStrategy = SQLStorage ]
{

/// 安全组指针 EC_WF_Dr
Property ECWFDr As User.DHCEmConsWorkFlowItem [ SqlColumnNumber = 2, SqlFieldName = EC_WF_Dr ];

/// G-按安全组,L-按科室，U-按用户 EC_Type G/L/U
Property ECType As %String [ SqlColumnNumber = 3, SqlFieldName = EC_Type ];

/// 指针串 EC_Poniter	
Property ECPointer As %String [ SqlColumnNumber = 4, SqlFieldName = EC_Poniter ];

Storage SQLStorage
{
<ExtentSize>100000</ExtentSize>
<SqlIdExpression>$i(^DHCEMCONG)</SqlIdExpression>
<SQLMap name="IndexTypePointer">
<Global>^DHCEMCONG</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L6}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_Type}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_Poniter}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{EC_WF_Dr}</Expression>
</Subscript>
<Subscript name="6">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexWorkItem">
<Global>^DHCEMCONG</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"WorkItem"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{EC_WF_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master">
<Data name="EC_Poniter">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="EC_Type">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="EC_WF_Dr">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCEMCONG</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>EC_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{EC_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCEmConsGrantS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
