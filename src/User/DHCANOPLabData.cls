Class User.DHCANOPLabData Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPLabData ]
{

Property ParentId As User.DHCANOPLIS [ Required ];

Index ParentIdIndex On ParentId As Plus;

// 标准码

Property StandardCode As %String [ Required ];

// 检验结果

Property Value As %String;

// 检验号

Property LabNo As %String;

// 检验结果号

Property LabResultNo As %String;

// 医嘱号

Property OeoriNo As %String;

// 采集标本日期

Property CollectDate As %Date;

// 采集标本时间

Property CollectTime As %Time;

// 接收日期

Property ReceivedDate As %Date;

// 时间

Property ReceivedTime As %Time;

// 结果日期

Property ResultDate As %Date;

// 结果时间

Property ResultTime As %Time;

// 单位

Property UnitCode As %String;

// 正常范围

Property Range As %String;

// 结果

Property Conclusion As %String;

// 微生物类型

Property MicroorganismType As %String;

// 检验科室代码

Property LabLocCode As %String;

Storage Default
{
<Data name="DHCANOPLabDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrangeId</Value>
</Value>
<Value name="3">
<Value>CodeId</Value>
</Value>
<Value name="4">
<Value>Value</Value>
</Value>
<Value name="5">
<Value>Text</Value>
</Value>
<Value name="6">
<Value>Code</Value>
</Value>
<Value name="7">
<Value>Type</Value>
</Value>
<Value name="8">
<Value>DataDate</Value>
</Value>
<Value name="9">
<Value>DataTime</Value>
</Value>
<Value name="10">
<Value>UpdateDate</Value>
</Value>
<Value name="11">
<Value>UpdateTime</Value>
</Value>
<Value name="12">
<Value>LabNo</Value>
</Value>
<Value name="13">
<Value>LabResultNo</Value>
</Value>
<Value name="14">
<Value>OeoriNo</Value>
</Value>
<Value name="15">
<Value>CollectDate</Value>
</Value>
<Value name="16">
<Value>CollectTime</Value>
</Value>
<Value name="17">
<Value>ReceivedDate</Value>
</Value>
<Value name="18">
<Value>ReceivedTime</Value>
</Value>
<Value name="19">
<Value>ResultDate</Value>
</Value>
<Value name="20">
<Value>ResultTime</Value>
</Value>
<Value name="21">
<Value>UnitCode</Value>
</Value>
<Value name="22">
<Value>Range</Value>
</Value>
<Value name="23">
<Value>Conclusion</Value>
</Value>
<Value name="24">
<Value>MicroorganismType</Value>
</Value>
<Value name="25">
<Value>LabLocCode</Value>
</Value>
<Value name="26">
<Value>StandardCode</Value>
</Value>
<Value name="27">
<Value>ParentId</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPLabDataD</DataLocation>
<DefaultData>DHCANOPLabDataDefaultData</DefaultData>
<IdLocation>^User.DHCANOPLabDataD</IdLocation>
<IndexLocation>^User.DHCANOPLabDataI</IndexLocation>
<StreamLocation>^User.DHCANOPLabDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
