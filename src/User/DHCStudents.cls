Class User.DHCStudents Extends (%Persistent, User.Abstract) [ SqlTableName = DHCStudents ]
{

Property StCode As %string [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 学号
/// 姓名
Property StName As %string [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

}
