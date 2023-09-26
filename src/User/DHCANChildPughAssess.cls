Class User.DHCANChildPughAssess Extends %Persistent [ SqlRowIdName = RowId, SqlTableName = DHC_AN_ChildPughAssess ]
{

Property OPArrange As User.DHCANOPArrange [ Required, SqlColumnNumber = 2 ];

/// 肝性脑病
Property LiverCondition As %String [ SqlColumnNumber = 3 ];

/// 肝性脑病分数
Property LiverScore As %String [ SqlColumnNumber = 4 ];

/// 腹水
Property Ascite As %String [ SqlColumnNumber = 5 ];

/// 腹水分数
Property AsciteScore As %String [ SqlColumnNumber = 6 ];

/// 总胆红素
Property TBIL As %String [ SqlColumnNumber = 7 ];

/// 总胆红素分数
Property TBILScore As %String [ SqlColumnNumber = 8 ];

/// 白蛋白
Property ALB As %String [ SqlColumnNumber = 9 ];

/// 白蛋白分数
Property ALBScore As %String [ SqlColumnNumber = 10 ];

/// 凝血酶原时间
Property PTCondition As %String [ SqlColumnNumber = 11 ];

/// 凝血酶原时间分数
Property PTScore As %String [ SqlColumnNumber = 12 ];

/// 评估总分
Property TotalScore As %String [ SqlColumnNumber = 13 ];

/// 评估结果
Property Result As %String [ SqlColumnNumber = 14 ];

/// 评估结果扩展描述
Property ResultDesc As %String [ SqlColumnNumber = 15 ];

/// 病情描述
Property Note As %String [ SqlColumnNumber = 16 ];

Property AssessUser As %String [ SqlColumnNumber = 17 ];

Property AssessDate As %Date [ SqlColumnNumber = 18 ];

Property AssessTime As %Time [ SqlColumnNumber = 19 ];

Index Arrange On OPArrange;

Storage Default
{
<Data name="DHCANChildPughAssessDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OPArrange</Value>
</Value>
<Value name="3">
<Value>LiverCondition</Value>
</Value>
<Value name="4">
<Value>LiverScore</Value>
</Value>
<Value name="5">
<Value>Ascite</Value>
</Value>
<Value name="6">
<Value>AsciteScore</Value>
</Value>
<Value name="7">
<Value>TBIL</Value>
</Value>
<Value name="8">
<Value>TBILScore</Value>
</Value>
<Value name="9">
<Value>ALB</Value>
</Value>
<Value name="10">
<Value>ALBScore</Value>
</Value>
<Value name="11">
<Value>PTCondition</Value>
</Value>
<Value name="12">
<Value>PTScore</Value>
</Value>
<Value name="13">
<Value>TotalScore</Value>
</Value>
<Value name="14">
<Value>Result</Value>
</Value>
<Value name="15">
<Value>ResultDesc</Value>
</Value>
<Value name="16">
<Value>Note</Value>
</Value>
<Value name="17">
<Value>AssessUser</Value>
</Value>
<Value name="18">
<Value>AssessDate</Value>
</Value>
<Value name="19">
<Value>AssessTime</Value>
</Value>
</Data>
<DataLocation>^User.DHCANChildPughAssessD</DataLocation>
<DefaultData>DHCANChildPughAssessDefaultData</DefaultData>
<IdLocation>^User.DHCANChildPughAssessD</IdLocation>
<IndexLocation>^User.DHCANChildPughAssessI</IndexLocation>
<StreamLocation>^User.DHCANChildPughAssessS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
