Class User.PAZYZTEST Extends %Persistent [ SqlTableName = PAZYZ_Test, StorageStrategy = NewStorage1 ]
{

/// 病人姓名
Property PAName As %String [ Required, SqlColumnNumber = 2, SqlFieldName = PA_Name ];

/// 病人身份证号
Property PACardNo As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PA_CardNo ];

/// 病人性别
Property PASexDr As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = PA_SexDr ];

Storage NewStorage1
{
<SqlIdExpression>$i(^PAZYZTest(0))</SqlIdExpression>
<SQLMap name="DataMaster">
<ConditionalWithHostVars></ConditionalWithHostVars>
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
<Global>^PAZYZTest</Global>
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
<SqlRowIdName>PA_RowId</SqlRowIdName>
<StreamLocation>^User.PAZYZTESTS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
