Class User.PATestYHR Extends %Persistent [ SqlTableName = PA_TestYHR, StorageStrategy = NewStorage1 ]
{

Relationship ChildPerson As PATestLogYHR [ Cardinality = children, Inverse = ParRef ];

/// 字段：PA_RowId  PA_Name  PA_CardNo PA_SexDr
/// 病人姓名
Property PAName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PA_Name ];

/// 病人身份证号
Property PACardNo As %String [ SqlColumnNumber = 3, SqlFieldName = PA_CardNo ];

/// 病人性别  PASexDr
Property PASexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = PA_SexDr ];

/// 对代码进行唯一性限制
/// 姓名索引
Index Name On PAName As Exact;

Storage NewStorage1
{
<SqlIdExpression>$i(^PATESTLOGYHRi(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="PA_CardNo">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="PA_Name">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="PA_SexDr">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^PATESTLOGYHRi</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>PA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{PA_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^PATESTLOGYHRi</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>PA_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{PA_Name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{PA_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>PA_RowId</SqlRowIdName>
<StreamLocation>^User.PATestYHRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
