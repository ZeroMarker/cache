Class CHSSWeb.HISInterface.WomenDangerScoreInfo Extends %Persistent
{

//DangerRowId

Property DangerRowId As %Integer;

//妇女基本信息ID

Property WomanRowId As %Integer;

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
<Data name="WomenDangerScoreInfoDefaultData">
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
<Value>DangerRowId</Value>
</Value>
<Value name="6">
<Value>Deal</Value>
</Value>
<Value name="7">
<Value>Grade</Value>
</Value>
<Value name="8">
<Value>PregWeeks</Value>
</Value>
<Value name="9">
<Value>WomanRowId</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenDangerS7DFD</DataLocation>
<DefaultData>WomenDangerScoreInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenDangerS7DFD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenDangerS7DFI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenDangerS7DFS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
