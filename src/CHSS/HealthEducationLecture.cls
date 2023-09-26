Class CHSS.HealthEducationLecture Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = LectureRowId, SqlTableName = HealthEducationLecture ]
{

Index CommunityCodeIndex On CommunityCode;

Index TitleIndex On LectureTitel;

//演讲主题

Property LectureTitel As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = LectureTitel ];

//演讲者

Property LectureName As %String(MAXLEN = 60, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = LectureName ];

//演讲地点

Property LectureAddress As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = LectureAddress ];

//演讲日期

Property LectureDATE As %Date(FORMAT = 1) [ SqlColumnNumber = 5, SqlFieldName = LectureDATE ];

//演讲时间

Property LectureTime As %Date(FORMAT = 1) [ SqlColumnNumber = 6, SqlFieldName = LectureTime ];

//面向人群

Property People As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = People ];

//主办单位

Property Unit As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Unit ];

//内容

Property PlanContent As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 9, SqlFieldName = PlanContent ];

//目的

Property PlanTarget As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 10, SqlFieldName = PlanTarget ];

//备注

Property Remark As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Remark ];

//总结

Property Summarize As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 12, SqlFieldName = Summarize ];

//创建日期

Property DateOfCreate As %Date(FORMAT = 1) [ SqlColumnNumber = 13, SqlFieldName = DateOfCreate ];

//创建人员

Property StaffOfCreate As %String(TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = StaffOfCreate ];

//社区编码

Property CommunityCode As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 15, SqlFieldName = CommunityCode ];

Storage Default
{
<Data name="HealthEducationLectureDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>LectureAddress</Value>
</Value>
<Value name="3">
<Value>LectureDATE</Value>
</Value>
<Value name="4">
<Value>LectureName</Value>
</Value>
<Value name="5">
<Value>LectureTitel</Value>
</Value>
<Value name="6">
<Value>LectureTime</Value>
</Value>
<Value name="7">
<Value>CommunityCode</Value>
</Value>
<Value name="8">
<Value>DateOfCreate</Value>
</Value>
<Value name="9">
<Value>People</Value>
</Value>
<Value name="10">
<Value>PlanContent</Value>
</Value>
<Value name="11">
<Value>PlanTarget</Value>
</Value>
<Value name="12">
<Value>Remark</Value>
</Value>
<Value name="13">
<Value>StaffOfCreate</Value>
</Value>
<Value name="14">
<Value>Summarize</Value>
</Value>
<Value name="15">
<Value>Unit</Value>
</Value>
</Data>
<DataLocation>^CHSS.HealthEducationLectureD</DataLocation>
<DefaultData>HealthEducationLectureDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.HealthEducationLectureD</IdLocation>
<IndexLocation>^CHSS.HealthEducationLectureI</IndexLocation>
<StreamLocation>^CHSS.HealthEducationLectureS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
