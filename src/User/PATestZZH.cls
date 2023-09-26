Class User.PATestZZH Extends %RegisteredObject
{

/// 病人RowId
Property PARowId As %Integer [ SqlColumnNumber = 2, SqlFieldName = PA_RowId ];

/// 病人姓名
Property PAName As %String [ SqlColumnNumber = 3, SqlFieldName = PA_Name ];

/// 病人身份证号
Property PACardNo As %String [ SqlColumnNumber = 4, SqlFieldName = PA_CardNo ];

/// 病人性别
Property PASexDr As User.CTSex [ SqlColumnNumber = 5, SqlFieldName = PA_Sex_Dr ];

}
