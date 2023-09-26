/// 学生表
/// DHC_Student,类名User.DHCStudent 主键 St_RowID
/// 字段 St_Code,St_Name,St_Sex_DR(Ct_Sex),St_Dob(Date)
Class User.DHCstudentHXR Extends %Persistent [ SqlRowIdName = St_RowId, SqlTableName = DHC_studentHXR, StorageStrategy = NewStorage1 ]
{

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As %String [ SqlColumnNumber = 4, SqlFieldName = St_Sex ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Storage Default
{
<Data name="DHCstudentHXRDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>StCode</Value>
</Value>
<Value name="3">
<Value>StName</Value>
</Value>
<Value name="4">
<Value>StSexDR</Value>
</Value>
<Value name="5">
<Value>StDob</Value>
</Value>
</Data>
<DataLocation>^User.DHCstudentHXRD</DataLocation>
<DefaultData>DHCstudentHXRDefaultData</DefaultData>
<IdLocation>^User.DHCstudentHXRD</IdLocation>
<IndexLocation>^User.DHCstudentHXRI</IndexLocation>
<StreamLocation>^User.DHCstudentHXRS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage NewStorage1
{
<SQLMap name="DataMaster">
<Data name="St_Dob">
<Delimiter>"^"</Delimiter>
<Piece>4</Piece>
</Data>
<Data name="St_Name">
<Delimiter>"^"</Delimiter>
<Piece>2</Piece>
</Data>
<Data name="St_Sex">
<Delimiter>"^"</Delimiter>
<Piece>3</Piece>
</Data>
<Data name="St_code">
<Delimiter>"^"</Delimiter>
<Piece>1</Piece>
</Data>
<Global>^DHCSTUDENTA</Global>
<Type>data</Type>
</SQLMap>
<StreamLocation>^User.DHCstudentHXRS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
