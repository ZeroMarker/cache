Class dhc.qm.data.JXPat Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, Not ProcedureBlock, SqlRowIdName = JXPat_rowid, SqlTableName = JXPat ]
{

/// JXPat_Adm 就诊号
Property JXPatAdm As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = JXPat_Adm ];

/// JXPat_code 病案号
Property JXPatcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = JXPat_code ];

/// JXPat_name 患者姓名
Property JXPatname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = JXPat_name ];

/// JXPat_Indoccode 管床医生code 
Property JXPatIndoccode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = JXPat_Indoccode ];

/// JXPat_IndocName 管床医生姓名 
Property JXPatIndocName As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 6, SqlFieldName = JXPat_IndocName ];

/// JXPat_operator 手术名称
Property JXPatoperator As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 7, SqlFieldName = JXPat_operator ];

/// JXPat_operatordate 手术日期
Property JXPatoperatordate As %Library.Date [ SqlColumnNumber = 8, SqlFieldName = JXPat_operatordate ];

/// JXPat_operatorcode 主刀医生code
Property JXPatoperatorcode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = JXPat_operatorcode ];

/// JXPat_operdocname  主刀医生名称
Property JXPatoperdocname As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 10, SqlFieldName = JXPat_operdocname ];

/// JXPat_applydate  会诊申请日期
Property JXPatapplydate As %Library.String [ SqlColumnNumber = 11, SqlFieldName = JXPat_applydate ];

/// JXPat_consultdepart 会诊科室ID
Property JXPatconsultdepart As User.RBCDepartmentGroup [ SqlColumnNumber = 12, SqlFieldName = JXPat_consultdepart ];

/// JXPat_consultdoccode 会诊医师code 
Property JXPatconsultdoccode As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 13, SqlFieldName = JXPat_consultdoccode ];

/// JXPat_consultdoc 会诊医师名称
Property JXPatconsultdoc As %Library.String(COLLATION = "Exact", MAXLEN = 30, TRUNCATE = 0) [ SqlColumnNumber = 14, SqlFieldName = JXPat_consultdoc ];

/// JXPat_decedate 死亡日期
Property JXPatdecedate As %Library.Date [ SqlColumnNumber = 15, SqlFieldName = JXPat_decedate ];

/// JXPat_Operation 操作名称
Property JXPatOperation As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 16, SqlFieldName = JXPat_Operation ];

/// JXPat_Operationdate 操作日期
Property JXPatOperationdate As %Library.Date [ SqlColumnNumber = 17, SqlFieldName = JXPat_Operationdate ];

/// JXPat_consultdate 会诊日期
Property JXPatconsultdate As %Library.String [ SqlColumnNumber = 18, SqlFieldName = JXPat_consultdate ];

/// JXPat_consultdate 会诊执行日期
Property JXPatconsultexedate As %Library.String [ SqlColumnNumber = 19, SqlFieldName = JXPat_consultexedate ];

/// JXPat_operatorID 手术id
Property JXPatoperatorID As User.DHCANOPArrange [ SqlColumnNumber = 20, SqlFieldName = JXPat_operatorID ];

/// JXPat_consultID 会诊ID
Property JXPatconsultID As %Library.String [ SqlColumnNumber = 21, SqlFieldName = JXPat_consultID ];

/// JXPat_OperationID 医嘱ID
Property JXPatOperationID As %Library.String [ SqlColumnNumber = 22, SqlFieldName = JXPat_OperationID ];

Index JXPatAdm On JXPatAdm;

Index JXPatcode On JXPatcode;

Index JXPatoperator On (JXPatAdm, JXPatIndoccode, JXPatoperatorcode, JXPatoperatorID);

Index JXPatconsult On (JXPatAdm, JXPatconsultID);

Index JXPatOperation On (JXPatAdm, JXPatIndoccode, JXPatOperationID);

Index JXPatdecedate On (JXPatAdm, JXPatdecedate);

Storage Default
{
<Data name="JXPatDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>JXPatAdm</Value>
</Value>
<Value name="3">
<Value>JXPatcode</Value>
</Value>
<Value name="4">
<Value>JXPatname</Value>
</Value>
<Value name="5">
<Value>JXPatIndoccode</Value>
</Value>
<Value name="6">
<Value>JXPatIndocName</Value>
</Value>
<Value name="7">
<Value>JXPatoperator</Value>
</Value>
<Value name="8">
<Value>JXPatoperatordate</Value>
</Value>
<Value name="9">
<Value>JXPatoperatorcode</Value>
</Value>
<Value name="10">
<Value>JXPatoperdocname</Value>
</Value>
<Value name="11">
<Value>JXPatapplydate</Value>
</Value>
<Value name="12">
<Value>JXPatconsultdepart</Value>
</Value>
<Value name="13">
<Value>JXPatconsultdoccode</Value>
</Value>
<Value name="14">
<Value>JXPatconsultdoc</Value>
</Value>
<Value name="15">
<Value>JXPatdecedate</Value>
</Value>
<Value name="16">
<Value>JXPatOperation</Value>
</Value>
<Value name="17">
<Value>JXPatOperationdate</Value>
</Value>
<Value name="18">
<Value>JXPatconsultdate</Value>
</Value>
<Value name="19">
<Value>JXPatconsultexedate</Value>
</Value>
<Value name="20">
<Value>JXPatoperatorID</Value>
</Value>
<Value name="21">
<Value>JXPatconsultID</Value>
</Value>
<Value name="22">
<Value>JXPatOperationID</Value>
</Value>
</Data>
<DataLocation>^DHCCJXQMJXPatD</DataLocation>
<DefaultData>JXPatDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCCJXQMJXPatD</IdLocation>
<IndexLocation>^DHCCJXQMJXPatI</IndexLocation>
<StreamLocation>^DHCCJXQMJXPatS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
