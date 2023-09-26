/// Foution：学生类（sqlStorage存储)
/// CreateDate:2023-09-12
/// CREATOR:翁瑞珍
Class User.DHCBStudent Extends (%Persistent, User.Abstract) [ SqlTableName = DHCB_Student, StorageStrategy = NewStorage1 ]
{

/// 关联子表
Relationship ChildCourse As DHCBStudentCourse [ Cardinality = children, Inverse = StudentParRef ];

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DHCSTUDENT(0))\</SqlIdExpression>
<SQLMap name="DataMasterMap1">
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
<Global>^DHCSTUDENT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>St_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{St_Rowid}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCSTUDENT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"Code"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<Expression>{St_Code}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>{St_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCSTUDENT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_Rowid</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="2">
<Expression>"Name"</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="3">
<Expression>{St_Name}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Subscript name="4">
<Expression>{St_Rowid}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>St_Rowid</SqlRowIdName>
<StreamLocation>^User.DHCBStudentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
