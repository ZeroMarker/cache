Class CHSS.WhBirthRecord Extends %Persistent [ ClassType = persistent, Owner = {_SYSTEM}, ProcedureBlock, SqlRowIdName = BirthRowId, SqlTableName = WhBirthRecord ]
{

/// WomanRowId
Property WomanRowId As CHSS.WomenBaseInfo;

/// 分娩日期
Property DateOfBirth As %Date;

/// 分娩孕周
Property BirthGW As %Float;

/// 分娩地点
Property BirthPlace As %String(MAXLEN = 80, TRUNCATE = 1);

/// 分娩方式
Property BirthType As CHSS.DictBirthType;

/// 分娩并发
Property BirthComp As %String(MAXLEN = 100, TRUNCATE = 1);

/// 胎次
Property BirthParity As %String(MAXLEN = 30, TRUNCATE = 1);

/// 总产程(小时)
Property TotalStage As %Numeric;

/// 剖腹产原因
Property CaesareanReason As %String(MAXLEN = 100, TRUNCATE = 1);

/// 胎盘剥离方式
Property PlacentaFallMode As CHSS.DictPlacentaFallMode;

/// 难产
Property Dystocia As CHSS.DictDystocia;

/// 手术产
Property ODFD As CHSS.DictODFD;

/// 会阴裂伤
Property SplitType As CHSS.DictSplitType;

/// 外缝针数
Property OuterFissureNum As %Numeric;

/// 产妇合并症
Property Complication As %String(MAXLEN = 100, TRUNCATE = 1);

/// 其他综合症
Property OtherComplication As %String(MAXLEN = 50, TRUNCATE = 1);

/// 产后出血量
Property BleedNum As %Float;

/// 产后出血原因
Property BleedReason As CHSS.DictBleedReason;

/// 产后出血其它原因详述
Property BleedReasonDes As %String(MAXLEN = 50, TRUNCATE = 1);

/// 胎数
Property FetusNum As %Numeric;

/// 出院日期
Property LeaveDate As %Date;

/// 小结和保健指导
Property Suggestion As %String(MAXLEN = 100, TRUNCATE = 1);

Index WomanRowIdIndex On WomanRowId [ Unique ];

Storage Default
{
<Data name="WhBirthRecordDefaultData">
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
<Value>DateOfBirth</Value>
</Value>
<Value name="8">
<Value>WomanRowId</Value>
</Value>
<Value name="9">
<Value>BleedNum</Value>
</Value>
<Value name="10">
<Value>BleedReason</Value>
</Value>
<Value name="11">
<Value>BleedReasonDes</Value>
</Value>
<Value name="12">
<Value>CaesareanReason</Value>
</Value>
<Value name="13">
<Value>Complication</Value>
</Value>
<Value name="14">
<Value>Dystocia</Value>
</Value>
<Value name="15">
<Value>FetusNum</Value>
</Value>
<Value name="16">
<Value>LeaveDate</Value>
</Value>
<Value name="17">
<Value>ODFD</Value>
</Value>
<Value name="18">
<Value>OtherComplication</Value>
</Value>
<Value name="19">
<Value>OuterFissureNum</Value>
</Value>
<Value name="20">
<Value>PlacentaFallMode</Value>
</Value>
<Value name="21">
<Value>SplitType</Value>
</Value>
<Value name="22">
<Value>Suggestion</Value>
</Value>
<Value name="23">
<Value>TotalStage</Value>
</Value>
</Data>
<DataLocation>^CHSS.WhBirthRecordD</DataLocation>
<DefaultData>WhBirthRecordDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^CHSS.WhBirthRecordD</IdLocation>
<IndexLocation>^CHSS.WhBirthRecordI</IndexLocation>
<StreamLocation>^CHSS.WhBirthRecordS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
