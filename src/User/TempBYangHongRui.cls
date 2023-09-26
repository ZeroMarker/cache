Class User.TempBYangHongRui Extends (%Persistent, User.Abstract) [ SqlTableName = TempB_YangHongRui, StorageStrategy = NewStorage1 ]
{

/// 字段：PatName  BED_NO  BED_Desc
/// 姓名
Property PatName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Pat_Name ];

/// 床号
Property BEDNO As %String [ SqlColumnNumber = 3, SqlFieldName = BED_NO ];

/// 床的型号
Property BEDDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BED_Desc ];

/// 对代码进行唯一性限制
/// 姓名索引
Index Name On PatName As Exact;

Index NO On BEDNO As Exact;

Storage NewStorage1
{
<SqlIdExpression>$i(^TempBB(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="BED_Desc">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="BED_NO">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="Pat_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^TempBYHR</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAADM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PAADM_RowId}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexNO">
<Global>^TempBYHR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAADM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"NO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BED_NO}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^TempBYHR</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAADM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{Pat_Name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAADM_RowId</SqlRowIdName>
<StreamLocation>^User.TempBYangHongRuiS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
