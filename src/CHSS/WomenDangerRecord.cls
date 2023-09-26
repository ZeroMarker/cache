Class CHSS.WomenDangerRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = DangerRowId, SqlTableName = WomenDangerRecord ]
{

//妇女基本信息ID

Property WomanRowId As CHSS.WomenBaseInfo;

//检查日期

Property CheckDate As %Date;

//检查医生

Property CheckDoctor As %String;

//孕周

Property PregWeeks As %Numeric;

//评分

Property Grade As %Float;

//处理

Property Deal As %String;

//预约日期

Property BookingDate As %Date;

Storage Default
{
<Data name="WomenDangerRecordDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BookingDate</Value>
</Value>
<Value name="3">
<Value>CheckDate</Value>
</Value>
<Value name="4">
<Value>CheckDoctor</Value>
</Value>
<Value name="5">
<Value>Deal</Value>
</Value>
<Value name="6">
<Value>Grade</Value>
</Value>
<Value name="7">
<Value>PregWeeks</Value>
</Value>
<Value name="8">
<Value>WomanRowId</Value>
</Value>
</Data>
<DataLocation>^CHSS.WomenDangerRecordD</DataLocation>
<DefaultData>WomenDangerRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WomenDangerRecordD</IdLocation>
<IndexLocation>^CHSS.WomenDangerRecordI</IndexLocation>
<StreamLocation>^CHSS.WomenDangerRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
