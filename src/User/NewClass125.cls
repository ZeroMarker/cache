Class User.NewClass125 Extends %RegisteredObject [ SqlTableName = PA_Test ]
{

Property PARowId As %Integer [ Required, SqlColumnNumber = 2, SqlFieldName = PA_RowId ];

/// 病人姓名
Property PAName As %String [ Required, SqlColumnNumber = 3, SqlFieldName = PA_Name ];

/// 病人身份证号
Property PACardNo As %Integer [ SqlFieldName = PA_CardNo ];

/// 病人性别
Property PASexDr As User.CTSex [ SqlFieldName = PA_Sex_Dr ];

}
