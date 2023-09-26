/// function:学生类（默认存储）
/// createdate:2023-09-12
/// creator:夏双玲
Class User.DHCStudentA Extends %Persistent [ SqlTableName = DHCStudentA ]
{

/// 学号
Property StCode As %string [ SqlColumnNumber = 2, SqlFieldName = St_Code ];

/// 姓名
Property StName As %string [ SqlColumnNumber = 3, SqlFieldName = St_Name ];

/// 性别
Property StSexDR As User.CTSex [ SqlColumnNumber = 4, SqlFieldName = St_Sex_DR ];

/// 出生日期
Property StDob As %Date [ SqlColumnNumber = 5, SqlFieldName = St_Dob ];

}
