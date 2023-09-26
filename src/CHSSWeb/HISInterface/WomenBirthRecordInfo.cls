Class CHSSWeb.HISInterface.WomenBirthRecordInfo Extends %Persistent
{

/// WomanRowId
Property WomanRowId As %Integer;

/// 分娩日期
Property DateOfBirth As %Date;

/// 分娩孕周
Property BirthGW As %Float;

/// 分娩地点
Property BirthPlace As %String(MAXLEN = 80, TRUNCATE = 1);

/// 分娩方式 CHSS.DictBirthType
Property BirthType As %Integer;

Property BirthTypeName As %String;

/// 分娩并发
Property BirthComp As %String(MAXLEN = 100, TRUNCATE = 1);

/// 胎次
Property BirthParity As %String(MAXLEN = 30, TRUNCATE = 1);

/// 总产程(小时)
Property TotalStage As %Numeric;

/// 剖腹产原因
Property CaesareanReason As %String(MAXLEN = 100, TRUNCATE = 1);

/// 胎盘剥离方式 CHSS.DictPlacentaFallMode
Property PlacentaFallMode As %Integer;

Property PlacentaFallModeName As %String;

/// 难产 CHSS.DictDystocia
Property Dystocia As %Integer;

Property DystociaName As %String;

/// 手术产 CHSS.DictODFD
Property ODFD As %Integer;

Property ODFDName As %String;

/// 会阴裂伤 CHSS.DictSplitType
Property SplitType As %Integer;

Property SplitTypeName As %String;

/// 外缝针数
Property OuterFissureNum As %Numeric;

/// 产妇合并症
Property Complication As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其他综合症
Property OtherComplication As %String(MAXLEN = 50, TRUNCATE = 1);

/// 产后出血量
Property BleedNum As %Float;

/// 产后出血原因 CHSS.DictBleedReason
Property BleedReason As %Integer;

Property BleedReasonName As %String;

/// 产后出血其它原因详述
Property BleedReasonDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 胎数
Property FetusNum As %Numeric;

/// 出院日期
Property LeaveDate As %Date;

/// 小结和保健指导
Property Suggestion As %String(MAXLEN = 100, TRUNCATE = 1);

Storage Default
{
<Data name="WomenBirthRecordInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BirthComp</Value>
</Value>
<Value name="3">
<Value>BirthGW</Value>
</Value>
<Value name="4">
<Value>BirthParity</Value>
</Value>
<Value name="5">
<Value>BirthPlace</Value>
</Value>
<Value name="6">
<Value>BirthType</Value>
</Value>
<Value name="7">
<Value>BirthTypeName</Value>
</Value>
<Value name="8">
<Value>BleedNum</Value>
</Value>
<Value name="9">
<Value>BleedReason</Value>
</Value>
<Value name="10">
<Value>BleedReasonDes</Value>
</Value>
<Value name="11">
<Value>BleedReasonName</Value>
</Value>
<Value name="12">
<Value>CaesareanReason</Value>
</Value>
<Value name="13">
<Value>Complication</Value>
</Value>
<Value name="14">
<Value>DateOfBirth</Value>
</Value>
<Value name="15">
<Value>Dystocia</Value>
</Value>
<Value name="16">
<Value>DystociaName</Value>
</Value>
<Value name="17">
<Value>FetusNum</Value>
</Value>
<Value name="18">
<Value>LeaveDate</Value>
</Value>
<Value name="19">
<Value>ODFD</Value>
</Value>
<Value name="20">
<Value>ODFDName</Value>
</Value>
<Value name="21">
<Value>OtherComplication</Value>
</Value>
<Value name="22">
<Value>OuterFissureNum</Value>
</Value>
<Value name="23">
<Value>PlacentaFallMode</Value>
</Value>
<Value name="24">
<Value>PlacentaFallModeName</Value>
</Value>
<Value name="25">
<Value>SplitType</Value>
</Value>
<Value name="26">
<Value>SplitTypeName</Value>
</Value>
<Value name="27">
<Value>Suggestion</Value>
</Value>
<Value name="28">
<Value>TotalStage</Value>
</Value>
<Value name="29">
<Value>WomanRowId</Value>
</Value>
</Data>
<DataLocation>^CHSSWeb.HIS6F2.WomenBirthRe7EAD</DataLocation>
<DefaultData>WomenBirthRecordInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSSWeb.HIS6F2.WomenBirthRe7EAD</IdLocation>
<IndexLocation>^CHSSWeb.HIS6F2.WomenBirthRe7EAI</IndexLocation>
<StreamLocation>^CHSSWeb.HIS6F2.WomenBirthRe7EAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
