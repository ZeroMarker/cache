/// Description:	学生类 (SqlStorage)
/// CreateDate:	2023年9月12日
/// Creator:		赵子豪
Class User.DHCStudentZZH Extends %Persistent [ SqlTableName = DHC_StudentZZH, StorageStrategy = ZZHStorage ]
{

/// 代码
Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage ZZHStorage
{
<SqlIdExpression>$i(^DHCStudentZZH)</SqlIdExpression>
<SQLMap name="DataMaster">
<Data name="St_Code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Data name="St_Dob">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="St_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="St_Sex_DR">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Global>^DHCStudentZZH</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>St_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{St_RowID}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCStudentZZH</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{St_Code}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{St_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCStudentZZH</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{St_Name}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{St_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>St_RowID</SqlRowIdName>
<StreamLocation>^User.DHCStudentZZHS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
