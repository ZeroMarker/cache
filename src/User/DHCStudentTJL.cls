Class User.DHCStudentTJL Extends %Persistent [ SqlRowIdName = St_RowID, SqlTableName = DHC_StudentTJLTable, StorageStrategy = NewStorage ]
{

// 学号

Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

// 姓名

Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

// 性别

Property StSexDR As User.CTSex [ Required, SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

// 出生日期

Property StDob As %Date [ Required, SqlColumnNumber = 5, SqlFieldName = St_Dob ];

Index StCodeIndex On StCode [ Unique ];

Index StNameIndex On StName;

Index StSexDRIndex On (StCode, StSexDR);

Storage NewStorage
{
<StreamLocation>^User.DHCStudentTJLS</StreamLocation>
<Type>%Storage.SQL</Type>
}

}
