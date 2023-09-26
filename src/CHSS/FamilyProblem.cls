/// 家庭主要问题
Class CHSS.FamilyProblem Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = ProblemRowId, SqlTableName = FamilyProblem ]
{

/// 家庭编号
Property FamilyRowIdParref As CHSS.FamilyHealthRecord;

/// 主要问题
Property ProblemName As %String(MAXLEN = 60, TRUNCATE = 1);

/// 发生日期
Property DateOfStart As %Date;

/// 解决日期
Property DateOfDeal As %Date;

/// 解决方案
Property Deal As %String(MAXLEN = 100, TRUNCATE = 1);

/// 转归
Property Vest As %String(MAXLEN = 100, TRUNCATE = 1);

/// 建档日期
Property DateRegister As %Date;

/// 建档医生
Property Register As %String(MAXLEN = 60, TRUNCATE = 1);

/// 备注
Property REMARK As %String(MAXLEN = 100, TRUNCATE = 1);

Index FamilyRowIdParrefIndex On FamilyRowIdParref;

Storage Default
{
<Data name="FamilyProblemDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateOfDeal</Value>
</Value>
<Value name="3">
<Value>DateOfStart</Value>
</Value>
<Value name="4">
<Value>DateRegister</Value>
</Value>
<Value name="5">
<Value>Deal</Value>
</Value>
<Value name="6">
<Value>FamilyRowIdParref</Value>
</Value>
<Value name="7">
<Value>ProblemName</Value>
</Value>
<Value name="8">
<Value>REMARK</Value>
</Value>
<Value name="9">
<Value>Vest</Value>
</Value>
<Value name="10">
<Value>Register</Value>
</Value>
</Data>
<DataLocation>^CHSS.FamilyProblemD</DataLocation>
<DefaultData>FamilyProblemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.FamilyProblemD</IdLocation>
<IndexLocation>^CHSS.FamilyProblemI</IndexLocation>
<StreamLocation>^CHSS.FamilyProblemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
