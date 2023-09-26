Class CHSS.WomenGeneralSurvey Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = SurveyRowId, SqlTableName = WomenGeneralSurvey ]
{

/// 个人档案主键
Property PersonRowId As CHSS.PersonHealthRecordMain;

/// 检查日期
Property DateOfCheck As %Date;

/// 年龄
Property Age As %Integer;

/// 调查者
Property Checker As %String(MAXLEN = 60);

/// 初潮年龄
Property AgeOfMenarche As %Integer;

/// 结婚年龄
Property AgeOfMarriage As %Integer;

/// 初产年龄
Property AgeOfPrimiparity As %Integer;

/// 绝经年龄
Property AgeOfMenopause As %Integer;

/// 节育方式
Property TypeOfBirthControl As %String(MAXLEN = 60);

/// 是否怀孕
Property bPregnancy As %String(MAXLEN = 5);

/// 葡萄胎史
Property GrapeMoleHis As %String(MAXLEN = 5);

/// 难产史
Property DystociaHis As %String(MAXLEN = 5);

/// 末次月经
Property LMP As %Date;

/// 外阴
Property Pudendum As %String(MAXLEN = 60);

/// 分泌物
Property Secretion As %String(MAXLEN = 60);

/// 阴道
Property Vagina As %String(MAXLEN = 60);

/// 子宫颈
Property Cervices As %String(MAXLEN = 60);

/// 子宫
Property Uterus As %String(MAXLEN = 60);

/// 附件
Property Accessories As %String(MAXLEN = 60);

/// 乳腺
Property Galactophore As %String(MAXLEN = 60);

/// B 超
Property BUltrasonic As %String(MAXLEN = 60);

/// 临床诊断
Property ClinicalDiagnosis As %String(MAXLEN = 60);

/// 妇科疾病
Property GynecologicalDis As %String(MAXLEN = 100);

Storage Default
{
<Data name="WomenGeneralSurveyDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Accessories</Value>
</Value>
<Value name="3">
<Value>Age</Value>
</Value>
<Value name="4">
<Value>AgeOfMarriage</Value>
</Value>
<Value name="5">
<Value>AgeOfMenarche</Value>
</Value>
<Value name="6">
<Value>AgeOfMenopause</Value>
</Value>
<Value name="7">
<Value>AgeOfPrimiparity</Value>
</Value>
<Value name="8">
<Value>BUltrasonic</Value>
</Value>
<Value name="9">
<Value>Cervices</Value>
</Value>
<Value name="10">
<Value>Checker</Value>
</Value>
<Value name="11">
<Value>ClinicalDiagnosis</Value>
</Value>
<Value name="12">
<Value>DateOfCheck</Value>
</Value>
<Value name="13">
<Value>DystociaHis</Value>
</Value>
<Value name="14">
<Value>Galactophore</Value>
</Value>
<Value name="15">
<Value>GrapeMoleHis</Value>
</Value>
<Value name="16">
<Value>GynecologicalDis</Value>
</Value>
<Value name="17">
<Value>LMP</Value>
</Value>
<Value name="18">
<Value>PersonRowId</Value>
</Value>
<Value name="19">
<Value>Pudendum</Value>
</Value>
<Value name="20">
<Value>Secretion</Value>
</Value>
<Value name="21">
<Value>TypeOfBirthControl</Value>
</Value>
<Value name="22">
<Value>Uterus</Value>
</Value>
<Value name="23">
<Value>Vagina</Value>
</Value>
<Value name="24">
<Value>bPregnancy</Value>
</Value>
</Data>
<DataLocation>^CHSS.WomenGeneralSurveyD</DataLocation>
<DefaultData>WomenGeneralSurveyDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WomenGeneralSurveyD</IdLocation>
<IndexLocation>^CHSS.WomenGeneralSurveyI</IndexLocation>
<StreamLocation>^CHSS.WomenGeneralSurveyS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
