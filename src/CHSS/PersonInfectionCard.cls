Class CHSS.PersonInfectionCard Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = InfectionCardRowId, SqlTableName = PersonInfectionCard ]
{

/// 社区编码
Index CommunityCodeIndex On CommunityCode;

//个人档案主键

Property PersonRowIdParref As %Library.String(TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = PersonRowIdParref ];

//传染病疾病名称

Property InfectionRowIdParref As %String(TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = InfectionRowIdParref ];

//报告级别

Property GradeRowIdParref As %String(TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = GradeRowIdParref ];

//病例分类

Property TypeRowIdParref As %String(TRUNCATE = 1) [ SqlColumnNumber = 5, SqlFieldName = TypeRowIdParref ];

//卡编号

Property CardCode As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = CardCode ];

//地区编码

Property GeoCode As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = GeoCode ];

//传染病类型

Property InfectionType As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = InfectionType ];

//患者姓名

Property PatientName As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PatientName ];

//家长姓名

Property ParentName As %String(MAXLEN = 30, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = ParentName ];

//联系电话

Property Phone As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Phone ];

//身份证号

Property ICCard As %String(MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = ICCard ];

//性别

Property Sex As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = Sex ];

//出生日期

Property Birth As %Date(FORMAT = 1) [ SqlColumnNumber = 14, SqlFieldName = Birth ];

//实足年龄（年）

Property BirthYear As %String(TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = BirthYear ];

//实足年龄（月）

Property BirthMonth As %String(TRUNCATE = 1) [ SqlColumnNumber = 16, SqlFieldName = BirthMonth ];

//实足年龄（日）

Property BirthDay As %String(TRUNCATE = 1) [ SqlColumnNumber = 17, SqlFieldName = BirthDay ];

//工作单位

Property WorkPlace As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 18, SqlFieldName = WorkPlace ];

//户籍

Property BirthPlace As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 19, SqlFieldName = BirthPlace ];

//现住址

Property CurrentAdd As %String(MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 20, SqlFieldName = CurrentAdd ];

//职业

Property Profession As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 21, SqlFieldName = Profession ];

//发病日期

Property Taken As %Date(FORMAT = 1) [ SqlColumnNumber = 22, SqlFieldName = Taken ];

//诊断日期

Property Diagnose As %Date(FORMAT = 1) [ SqlColumnNumber = 23, SqlFieldName = Diagnose ];

//死亡日期

Property Death As %Date(FORMAT = 1) [ SqlColumnNumber = 24, SqlFieldName = Death ];

//病例分类

Property CaseType As %String(TRUNCATE = 1) [ SqlColumnNumber = 25, SqlFieldName = CaseType ];

//报告单位

Property ReportUnit As %String(MAXLEN = 80, TRUNCATE = 1) [ SqlColumnNumber = 26, SqlFieldName = ReportUnit ];

//填卡日期

Property DateOfRegister As %Date(FORMAT = 1) [ SqlColumnNumber = 27, SqlFieldName = DateOfRegister ];

//填卡医生

Property Register As %String(TRUNCATE = 1) [ SqlColumnNumber = 28, SqlFieldName = Register ];

//接卡日期

Property DateOfReceiveCard As %Date(FORMAT = 1) [ SqlColumnNumber = 29, SqlFieldName = DateOfReceiveCard ];

//社区编码

Property CommunityCode As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 30, SqlFieldName = CommunityCode ];

Storage Default
{
<Data name="PersonInfectionCardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Birth</Value>
</Value>
<Value name="3">
<Value>BirthDay</Value>
</Value>
<Value name="4">
<Value>BirthMonth</Value>
</Value>
<Value name="5">
<Value>BirthYear</Value>
</Value>
<Value name="6">
<Value>CardCode</Value>
</Value>
<Value name="7">
<Value>GeoCode</Value>
</Value>
<Value name="8">
<Value>GradeRowIdParref</Value>
</Value>
<Value name="9">
<Value>ICCard</Value>
</Value>
<Value name="10">
<Value>InfectionRowIdParref</Value>
</Value>
<Value name="11">
<Value>InfectionType</Value>
</Value>
<Value name="12">
<Value>ParentName</Value>
</Value>
<Value name="13">
<Value>PatientName</Value>
</Value>
<Value name="14">
<Value>PersonRowIdParref</Value>
</Value>
<Value name="15">
<Value>Phone</Value>
</Value>
<Value name="16">
<Value>Sex</Value>
</Value>
<Value name="17">
<Value>TypeRowIdParref</Value>
</Value>
<Value name="18">
<Value>BirthPlace</Value>
</Value>
<Value name="19">
<Value>CaseType</Value>
</Value>
<Value name="20">
<Value>CommunityCode</Value>
</Value>
<Value name="21">
<Value>CurrentAdd</Value>
</Value>
<Value name="22">
<Value>DateOfReceiveCard</Value>
</Value>
<Value name="23">
<Value>DateOfRegister</Value>
</Value>
<Value name="24">
<Value>Death</Value>
</Value>
<Value name="25">
<Value>Diagnose</Value>
</Value>
<Value name="26">
<Value>Profession</Value>
</Value>
<Value name="27">
<Value>Register</Value>
</Value>
<Value name="28">
<Value>ReportUnit</Value>
</Value>
<Value name="29">
<Value>Taken</Value>
</Value>
<Value name="30">
<Value>WorkPlace</Value>
</Value>
</Data>
<DataLocation>^CHSS.PersonInfectionCardD</DataLocation>
<DefaultData>PersonInfectionCardDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.PersonInfectionCardD</IdLocation>
<IndexLocation>^CHSS.PersonInfectionCardI</IndexLocation>
<StreamLocation>^CHSS.PersonInfectionCardS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
