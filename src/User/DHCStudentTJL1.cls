Class User.DHCStudentTJL1 Extends %Persistent [ SqlTableName = DHC_Student1, StorageStrategy = NewStorage1 ]
{

// 学号

Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

// 姓名

Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

// 性别

Property StSexDR As User.CTSex [ Required, SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

// 出生日期

Property StDob As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage NewStorage1
{
<SqlIdExpression>$i(^STUDENTh(0))</SqlIdExpression>
<SQLMap name="IndexSex">
<ConditionalWithHostVars></ConditionalWithHostVars>
<Global>^STUDENTh</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"SEX"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{St_Sex_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{St_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Map1">
<ConditionalWithHostVars></ConditionalWithHostVars>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DOB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{St_Sex_DR}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{St_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="Master Map">
<ConditionalWithHostVars></ConditionalWithHostVars>
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
<Global>^DHCSTUDENTh</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Field>St_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>St_RowID</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SqlRowIdName>St_RowID</SqlRowIdName>
<StreamLocation>^User.DHCStudentTJL1S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
