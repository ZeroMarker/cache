Class CHSS.HealthEducationBulletinBoard Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = HealthEducationBulletinBoard ]
{

//主题

Property Titel As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2, SqlFieldName = Titel ];

//位置

Property Address As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 3, SqlFieldName = Address ];

//主办单位

Property Unit As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 4, SqlFieldName = Unit ];

//出栏时间

Property PutDate As %Date [ SqlColumnNumber = 5, SqlFieldName = PutDate ];

//内容

Property PlanContent As %String(MAXLEN = 1000, TRUNCATE = 1) [ SqlColumnNumber = 6, SqlFieldName = PlanContent ];

//目的

Property PlanTarget As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 7, SqlFieldName = PlanTarget ];

//总结

Property Summarize As %String(MAXLEN = 200, TRUNCATE = 1) [ SqlColumnNumber = 8, SqlFieldName = Summarize ];

//开始日期

Property DateOfStart As %Date [ SqlColumnNumber = 9, SqlFieldName = DateOfStart ];

//结束日期

Property DateOfEnd As %Date [ SqlColumnNumber = 10, SqlFieldName = DateOfEnd ];

//备注

Property Remark As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 11, SqlFieldName = Remark ];

//创建日期

Property DateOfCreate As %Date(FORMAT = 1) [ SqlColumnNumber = 12, SqlFieldName = DateOfCreate ];

//创建人员

Property StaffOfCreate As %String(TRUNCATE = 1) [ SqlColumnNumber = 13, SqlFieldName = StaffOfCreate ];

//社区编码

Property CommunityCode As %String(MAXLEN = 50, TRUNCATE = 1) [ SqlColumnNumber = 14, SqlFieldName = CommunityCode ];

Index CommunityCodeIndex On CommunityCode;

Storage Default
{
<Data name="HealthEducationBulletinBoardDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PlanContent</Value>
</Value>
<Value name="3">
<Value>PlanTarget</Value>
</Value>
<Value name="4">
<Value>Position00</Value>
</Value>
<Value name="5">
<Value>PutDate</Value>
</Value>
<Value name="6">
<Value>Summarize</Value>
</Value>
<Value name="7">
<Value>Unit</Value>
</Value>
<Value name="8">
<Value>Address</Value>
</Value>
<Value name="9">
<Value>DateOfEnd</Value>
</Value>
<Value name="10">
<Value>DateOfStart</Value>
</Value>
<Value name="11">
<Value>CommunityCode</Value>
</Value>
<Value name="12">
<Value>DateOfCreate</Value>
</Value>
<Value name="13">
<Value>Remark</Value>
</Value>
<Value name="14">
<Value>StaffOfCreate</Value>
</Value>
<Value name="15">
<Value>Titel</Value>
</Value>
</Data>
<DataLocation>^CHSS.HealthEducatB19D</DataLocation>
<DefaultData>HealthEducationBulletinBoardDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.HealthEducatB19D</IdLocation>
<IndexLocation>^CHSS.HealthEducatB19I</IndexLocation>
<StreamLocation>^CHSS.HealthEducatB19S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
