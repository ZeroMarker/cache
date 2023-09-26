Class User.DHCDisPeople Extends (%Persistent, %XML.Adaptor) [ Owner = {_SYSTEM}, SqlRowIdName = DP_RowID, SqlTableName = DHC_DisPeople, StorageStrategy = NewStorage1 ]
{

/// 类型 DP_ReqType 1 配送 0陪送
Property DPReqType As %Library.String [ SqlColumnNumber = 2, SqlFieldName = DP_ReqType ];

/// 陪送/配送id DP_Pointer
Property DPPointer As %Library.String [ SqlColumnNumber = 3, SqlFieldName = DP_Pointer ];

/// 陪送/配送人 DP_User_Dr
Property DPUserDr As User.SSUser [ SqlColumnNumber = 4, SqlFieldName = DP_User_Dr ];

/// 人员状态 DP_Status
Property DPStatus As %Library.String [ SqlColumnNumber = 5, SqlFieldName = DP_Status ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCDISPE)</SqlIdExpression>
<SQLMap name="IndexUser">
<Global>^DHCDISPE</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"User"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DP_User_Dr}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DP_ReqType}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="dataMaster">
<Data name="DP_Pointer">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="DP_ReqType">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="DP_Status">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="DP_User_Dr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCDISPE</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>DP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{DP_RowID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="typeIndex">
<Global>^DHCDISPE</Global>
<RowIdSpec name="1">
<Expression>{L5}</Expression>
<Field>DP_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>"0"</Expression>
</Subscript>
<Subscript name="2">
<Expression>"TypePointer"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{DP_ReqType}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{DP_Pointer}</Expression>
</Subscript>
<Subscript name="5">
<Expression>{DP_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<StreamLocation>^User.DHCDisPeopleS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
