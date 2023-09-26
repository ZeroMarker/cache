Class User.DHCStudent1 Extends (%Persistent, User.Abstract) [ SqlRowIdName = St_RowId, SqlTableName = DHC_Student1, StorageStrategy = NewStorage1 ]
{

Relationship ChildCourse As DHCStudentCourse [ Cardinality = children, Inverse = StudentParRef ];

Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

Property StSexDR As User.CTSex [ Required, SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

Property StDob As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index CodeIdx On StCode [ Unique ];

Storage NewStorage1
{
<SqlIdExpression>$I(^DHCSTUDENT(0))</SqlIdExpression>
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
<Global>^DHCSTUDENT</Global>
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
<SQLMap name="IndexDob">
<Global>^DHCSTUDENT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_RowId</Field>
</RowIdSpec>
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
<Expression>{St_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SQLMap name="IndexSex">
<Global>^DHCSTUDENT</Global>
<PopulationType>nonnull</PopulationType>
<RowIdSpec name="1">
<Expression>{L4}</Expression>
<Field>St_RowId</Field>
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
<Expression>{St_RowId}</Expression>
</Subscript>
<Type>index</Type>
</SQLMap>
<SqlRowIdName>St_RowId</SqlRowIdName>
<StreamLocation>^User.DHCStudent1S</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
