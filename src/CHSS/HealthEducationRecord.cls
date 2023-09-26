Class CHSS.HealthEducationRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RecordRowId, SqlTableName = HealthEducationRecord ]
{

Index CommunityCodeIndex On CommunityCode;

//活动时间

Property HETime As %Date;

//活动地点

Property HEPlace As %String(MAXLEN = 50);

//活动形式

Property HEType As CHSS.DictHERecordType;

//主办单位

Property Unit As %String(MAXLEN = 50);

//合作伙伴

Property CollaborateUnit As %String(MAXLEN = 50);

//参与人数

Property PersonNum As %Numeric;

//宣传品种类

Property PromoType As %Numeric;

//宣传品数量

Property PromoNum As %Numeric;

//活动主题

Property Theme As %String(MAXLEN = 1000);

//宣教人

Property Name As %String(MAXLEN = 50);

//活动小结

Property Summarize As %String(MAXLEN = 200);

//活动评价

Property Appraise As %String(MAXLEN = 200);

//存档材料类型（多选）

Property MaterialType As %String(MAXLEN = 50);

//负责人

Property Principal As %String(MAXLEN = 50);

//填表日期

Property DateOfCreate As %Date;

//社区编码

Property CommunityCode As %String(MAXLEN = 50);

Storage Default
{
<Data name="HealthEducationRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Appraise</Value>
</Value>
<Value name="3">
<Value>CollaborateUnit</Value>
</Value>
<Value name="4">
<Value>CommunityCode</Value>
</Value>
<Value name="5">
<Value>DateOfCreate</Value>
</Value>
<Value name="6">
<Value>HEPlace</Value>
</Value>
<Value name="7">
<Value>HETime</Value>
</Value>
<Value name="8">
<Value>HEType</Value>
</Value>
<Value name="9">
<Value>MaterialType</Value>
</Value>
<Value name="10">
<Value>Name</Value>
</Value>
<Value name="11">
<Value>PersonNum</Value>
</Value>
<Value name="12">
<Value>Principal</Value>
</Value>
<Value name="13">
<Value>PromoNum</Value>
</Value>
<Value name="14">
<Value>PromoType</Value>
</Value>
<Value name="15">
<Value>Summarize</Value>
</Value>
<Value name="16">
<Value>Theme</Value>
</Value>
<Value name="17">
<Value>Unit</Value>
</Value>
</Data>
<DataLocation>^CHSS.HealthEducationRecordD</DataLocation>
<DefaultData>HealthEducationRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.HealthEducationRecordD</IdLocation>
<IndexLocation>^CHSS.HealthEducationRecordI</IndexLocation>
<StreamLocation>^CHSS.HealthEducationRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
