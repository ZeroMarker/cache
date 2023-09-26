/// 个人长期健康问题
Class CHSS.PersonLongTermProblem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = ProblemRowId, SqlTableName = PersonLongTermProblem ]
{

Index PersonRowIdParrefIndex On PersonRowIdParref;

/// Parent Reference
Relationship PersonRowIdParref As CHSS.PersonHealthRecordMain [ Cardinality = parent, Inverse = ChildPersonLongTermProblem, Required, SqlFieldName = PersonRowIdParref ];

/// 个人档案主键
/// Property PersonRowIdParref As CHSS.PersonHealthRecordMain [ Required ];
/// 问题名称
Property ProblemName As %Library.String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = ProblemName ];

/// ICD-10
Property ICD10 As User.MRCICDDx [ SqlColumnNumber = 4, SqlFieldName = ICD10 ];

/// 影响
Property Effection As %Library.String(COLLATION = "Exact", MAXLEN = 100, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = Effection ];

/// 发生日期
Property DateOfStart As %Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = DateOfStart ];

/// 记录日期
Property DateRegister As %Date(FORMAT = 1) [ SqlColumnNumber = 7, SqlFieldName = DateRegister ];

/// 接诊医生
Property Register As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Register ];

/// 备注
Property REMARK As %String(COLLATION = "Exact", MAXLEN = 60, TRUNCATE = 0) [ SqlColumnNumber = 9, SqlFieldName = REMARK ];

/// 解决日期
Property DateOfDeal As %Date;

/// 处理情况
Property Deal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 转归
Property LapseTo As CHSS.DictLapseTo;

/// 建档日期
Property DateOfCreate As %Date;

// ICD10和PersonRowId

Index ICD10Index On (ICD10, PersonRowIdParref);

/// 记录日期
Index RegisterDateIndex On DateRegister;

Storage Default
{
<Data name="PersonLongTermProblemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Active</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>EndDate</Value>
</Value>
<Value name="6">
<Value>Sort</Value>
</Value>
<Value name="7">
<Value>StartDate</Value>
</Value>
<Value name="8">
<Value>DateOfStart</Value>
</Value>
<Value name="9">
<Value>DateRegister</Value>
</Value>
<Value name="10">
<Value>Effection</Value>
</Value>
<Value name="11">
<Value>ICD10</Value>
</Value>
<Value name="12">
<Value>ProblemName</Value>
</Value>
<Value name="13">
<Value>REMARK</Value>
</Value>
<Value name="14">
<Value>Register</Value>
</Value>
<Value name="15">
<Value>DateOfCreate</Value>
</Value>
<Value name="16">
<Value>DateOfDeal</Value>
</Value>
<Value name="17">
<Value>Deal</Value>
</Value>
<Value name="18">
<Value>LapseTo</Value>
</Value>
<Value name="19">
<Value>PersonRowIdParref</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonLongTermProblemD</DataLocation>
<DefaultData>PersonLongTermProblemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonLongTermProblemD</IdLocation>
<IndexLocation>^CHSS.PersonLongTermProblemI</IndexLocation>
<StreamLocation>^CHSS.PersonLongTermProblemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
