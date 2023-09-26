Class CHSS.HealthEducationMaterial Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RowId, SqlTableName = HealthEducationMaterial ]
{

Index CommunityCodeIndex On CommunityCode;

//刊物主题

Property Title As %String(MAXLEN = 100, TRUNCATE = 1);

//面向人群

Property People As %String(MAXLEN = 100, TRUNCATE = 1);

//主办单位

Property Unit As %String(MAXLEN = 100, TRUNCATE = 1);

//发放时间

Property SendDate As %Date;

//发放数量

Property SendNum As %Numeric;

//开始日期

Property DateOfStart As %Date;

//目的

Property Target As %String(MAXLEN = 100, TRUNCATE = 1);

//内容

Property Content As %String(MAXLEN = 100, TRUNCATE = 1);

//总结

Property Summarize As %String(MAXLEN = 100, TRUNCATE = 1);

//备注

Property Remark As %String(MAXLEN = 100, TRUNCATE = 1);

//创建时间

Property CreateDate As %Date;

//创建人员

Property StaffOfCreate As %String(MAXLEN = 50, TRUNCATE = 1);

//社区编码

Property CommunityCode As %String(MAXLEN = 50, TRUNCATE = 1);

Storage Default
{
<Data name="HealthEducationMaterialDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CommunityCode</Value>
</Value>
<Value name="3">
<Value>Content</Value>
</Value>
<Value name="4">
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>DateOfStart</Value>
</Value>
<Value name="6">
<Value>People</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
<Value name="8">
<Value>SendDate</Value>
</Value>
<Value name="9">
<Value>SendNum</Value>
</Value>
<Value name="10">
<Value>StaffOfCreate</Value>
</Value>
<Value name="11">
<Value>Summarize</Value>
</Value>
<Value name="12">
<Value>Target</Value>
</Value>
<Value name="13">
<Value>Title</Value>
</Value>
<Value name="14">
<Value>Unit</Value>
</Value>
</Data>
<DataLocation>^CHSS.HealthEducationMaterialD</DataLocation>
<DefaultData>HealthEducationMaterialDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.HealthEducationMaterialD</IdLocation>
<IndexLocation>^CHSS.HealthEducationMaterialI</IndexLocation>
<StreamLocation>^CHSS.HealthEducationMaterialS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
