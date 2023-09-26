Class User.ZYZTEMP Extends %Persistent [ SqlTableName = ZYZTEMP, StorageStrategy = NewStorage1 ]
{

/// 病人姓名
Property PatName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = Pat_Name ];

/// 病人床位号
Property BEDNO As %String [ Required, SqlColumnNumber = 3, SqlFieldName = BED_NO ];

/// 病人性别
Property BEDDesc As %String [ SqlColumnNumber = 4, SqlFieldName = BED_Desc ];

Storage NewStorage1
{
<SqlIdExpression>$i(^ZYZTEMP(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
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
<Global>^ZYZTEMP</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PAADM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PAADM_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexBEDNO">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^ZYZTEMP</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PAADM_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"BEDNO"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{BED_NO}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PAADM_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PAADM_RowId</SqlRowIdName>
<StreamLocation>^User.ZYZTEMPS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
