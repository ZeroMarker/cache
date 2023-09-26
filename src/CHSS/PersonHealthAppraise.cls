Class CHSS.PersonHealthAppraise Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = HealthAppraiseRowId, SqlTableName = PersonHealthAppraise ]
{

/// 个人档案主键 
Property PersonRowIdParref As CHSS.PersonHealthRecordMain [ Required ];

/// 随访日期
Property DateCheck As %Date(FORMAT = 1);

/// 随访地点
Property CheckAdd As %String(MAXLEN = 60, TRUNCATE = 1);

/// 随访医生
Property CheckDoctor As %String(MAXLEN = 60, TRUNCATE = 1);

/// 居民自我评价
Property EvaluationScore As %Float;

/// 既往慢性病控制情况
Property ChronicControl As CHSS.DictChronicControl;

/// 年检生理情况	
Property Physiology As CHSS.DictPhysiology;

/// 生理异常情况
Property PhysiologyInfo As %String(MAXLEN = 60, TRUNCATE = 1);

/// 生理状况处理
Property PhysiologyCure As CHSS.DictPhysiologyCure;

/// 心理状态
Property Mentality As CHSS.DictMentality;

/// 心理状况处理
Property MentalityCure As CHSS.DictPhysiologyCure;

/// 危险因素
Property DangerInfo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 健康指导
Property HealthSuggest As %String(MAXLEN = 100, TRUNCATE = 1);

/// 体检结果
Property CheckResult As %String(MAXLEN = 100, TRUNCATE = 1);

/// 体检异常
Property CheckResultInfo As %String(MAXLEN = 100, TRUNCATE = 1);

/// 定期随访
Property PeriodicalCheck As CHSS.DictPeriodicalCheck;

/// 危险因素控制
Property DangerControl As %String(MAXLEN = 100, TRUNCATE = 1);

/// 生活质量评分
Property LiveQualityScore As %Float;

/// 处理
Property Deal As %String(MAXLEN = 300, TRUNCATE = 1);

/// 更新日期
Property DateOfUpdate As %Date(FORMAT = 1);

/// 更新人员
Property StaffOfUpdate As User.SSUser;

/// 个人健康相关ID
Property RelateROWIDDR As %Integer;

Property YearCheckRowId As %Integer;

Index PersonRowIdParrefIndex On PersonRowIdParref;

Storage Default
{
<Data name="PersonHealthAppraiseDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CheckAdd</Value>
</Value>
<Value name="3">
<Value>CheckDoctor</Value>
</Value>
<Value name="4">
<Value>ChronicControl</Value>
</Value>
<Value name="5">
<Value>DangerControl</Value>
</Value>
<Value name="6">
<Value>DangerInfo</Value>
</Value>
<Value name="7">
<Value>DateCheck</Value>
</Value>
<Value name="8">
<Value>DateOfUpdate</Value>
</Value>
<Value name="9">
<Value>Deal</Value>
</Value>
<Value name="10">
<Value>EvaluationScore</Value>
</Value>
<Value name="11">
<Value>LiveQualityScore</Value>
</Value>
<Value name="12">
<Value>Mentality</Value>
</Value>
<Value name="13">
<Value>MentalityCure</Value>
</Value>
<Value name="14">
<Value>PeriodicalCheck</Value>
</Value>
<Value name="15">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="16">
<Value>Physiology</Value>
</Value>
<Value name="17">
<Value>PhysiologyCure</Value>
</Value>
<Value name="18">
<Value>PhysiologyInfo</Value>
</Value>
<Value name="19">
<Value>RelateROWIDDR</Value>
</Value>
<Value name="20">
<Value>StaffOfUpdate</Value>
</Value>
<Value name="21">
<Value>YearCheckRowId</Value>
</Value>
<Value name="22">
<Value>HealthSuggest</Value>
</Value>
<Value name="23">
<Value>CheckResult</Value>
</Value>
<Value name="24">
<Value>CheckResultInfo</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonHealthAppraiseD</DataLocation>
<DefaultData>PersonHealthAppraiseDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonHealthAppraiseD</IdLocation>
<IndexLocation>^CHSS.PersonHealthAppraiseI</IndexLocation>
<StreamLocation>^CHSS.PersonHealthAppraiseS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
