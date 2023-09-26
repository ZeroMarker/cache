Class CHSS.ImmunityBacterinRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = RecordRowId, SqlTableName = ImmunityBacterinRecord ]
{

//疫苗类别

Property ImmunityClassId As CHSS.DictBacterinVsClass;

//接种证编号

Property ImmuCardRowId As CHSS.ChildPlanedImmuCard;

//接种日期

Property ImmunityDate As %Date;

//疫苗批号

Property ImmunityPatch As %String(MAXLEN = 20);

//生产单位

Property ImmunityUnit As %String(MAXLEN = 30);

//接种医生

Property Doctor As %String(MAXLEN = 20);

//操作员

Property Operator As %String(MAXLEN = 10);

//录入时间

Property SysDate As %Date;

//录入单位

Property CommunityCode As %String(MAXLEN = 50);

//接种状态

Property ImmunityStatus As %String(MAXLEN = 5);

//预约时间

Property PreviewDate As %Date;

//剂次

Property ImmunityTimes As %Numeric;

Storage Default
{
<Data name="ImmunityBacterinRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CommunityCode</Value>
</Value>
<Value name="3">
<Value>Doctor</Value>
</Value>
<Value name="4">
<Value>ImmuCardRowId</Value>
</Value>
<Value name="5">
<Value>ImmunityClassId</Value>
</Value>
<Value name="6">
<Value>ImmunityDate</Value>
</Value>
<Value name="7">
<Value>ImmunityPatch</Value>
</Value>
<Value name="8">
<Value>ImmunityStatus</Value>
</Value>
<Value name="9">
<Value>ImmunityUnit</Value>
</Value>
<Value name="10">
<Value>Operator</Value>
</Value>
<Value name="11">
<Value>PreviewDate</Value>
</Value>
<Value name="12">
<Value>SysDate</Value>
</Value>
<Value name="13">
<Value>ImmunityTimes</Value>
</Value>
</Data>
<DataLocation>^CHSS.ImmunityBacterinRecordD</DataLocation>
<DefaultData>ImmunityBacterinRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.ImmunityBacterinRecordD</IdLocation>
<IndexLocation>^CHSS.ImmunityBacterinRecordI</IndexLocation>
<StreamLocation>^CHSS.ImmunityBacterinRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
