/// Function:学生类（默认存储)
/// createDate : 2023-09-12
/// Creator :俞长志
Class User.YCZ.DHCStudentY Extends (%Persistent, User.Abstract) [ SqlTableName = DHC_StudentY ]
{

/// 学号
Property StCode As %String [ Required, SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

}
