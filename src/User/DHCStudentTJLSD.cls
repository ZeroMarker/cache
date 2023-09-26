Class User.DHCStudentTJLSD Extends %Persistent [ SqlRowIdName = St_RowID, SqlTableName = DHC_StudentTJL, StorageStrategy = NewStorage1 ]
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
<SQLMap name="IndexDOB">
<Global>^DHCSTUDENT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_RowID</Field>
</RowIdSpec>
<RowIdSpec name="2"/>
<Subscript name="1">
<Expression>0</Expression>
</Subscript>
<Subscript name="2">
<Expression>"DOB"</Expression>
</Subscript>
<Subscript name="3">
<Expression>{St_Dob}</Expression>
</Subscript>
<Subscript name="4">
<Expression>{St_RowID}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSex">
<Global>^DHCSTUDENT</Global>
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
<SQLMap name="Master Map">
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
<Field>St_RowID</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{St_ROWID}</Expression>
</Subscript>
<Type>data</Type>
</SQLMap>
<Type>%Storage.SQL</Type>
}

}
