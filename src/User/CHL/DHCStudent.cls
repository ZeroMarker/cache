Class User.CHL.DHCStudent Extends %Persistent [ SqlRowIdName = St_RowId, SqlTableName = DHC_Student, StorageStrategy = NewStorage1 ]
{

// 陈洪亮

// 学号

Property StCode As %String [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

// 姓名

Property StName As %String [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

// 性别

Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

// 生日

Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

// 学号索引

Index StCodeIdx On StCode [ Unique ];

Storage NewStorage1
{
<SqlIdExpression>$i(^DCHSTUDENTCHL(0))</SqlIdExpression>
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
<Global>^DHCSTUDENTCHL</Global>
<RowIdSpec name="1">
<Expression>{L1}</Expression>
<Field>St_RowId</Field>
</RowIdSpec>
<Subscript name="1">
<Expression>{St_RowId}</Expression>
<StartValue>1</StartValue>
</Subscript>
<Type>data</Type>
</SQLMap>
<SQLMap name="IndexCode">
<Global>^DHCSTUDENTCHL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_RowId</Field>
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
<Expression>{St_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexName">
<Global>^DHCSTUDENTCHL</Global>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_RowId</Field>
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
<Expression>{St_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>St_RowId</SqlRowIdName>
<StreamLocation>^User.CHL.DHCStudentS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
