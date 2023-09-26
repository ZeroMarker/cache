/// Creator:lulin
/// Descriptions:应急预案演练
/// Date:2020-07-24
Class DHCINM.Tea.EmrPlanTest Extends %Persistent
{

/// 演练日期
Property TestDate As %Date [ SqlColumnNumber = 2, SqlFieldName = TestDate ];

/// 演练地点
Property TestPlace As %String(MAXLEN = 200) [ SqlColumnNumber = 3, SqlFieldName = TestPlace ];

/// 演练内容
Property TestDesc As %String(MAXLEN = 200) [ SqlColumnNumber = 4, SqlFieldName = TestDesc ];

/// 演练病区
Property TestWard As %Integer [ SqlColumnNumber = 5, SqlFieldName = TestWard ];

/// 参演人员
Property TestDemon As %String(MAXLEN = 200) [ SqlColumnNumber = 6, SqlFieldName = TestDemon ];

/// 参培人员
Property TestTrainer As %String(MAXLEN = 2000) [ SqlColumnNumber = 7, SqlFieldName = TestTrainer ];

/// 演练场景
Property TestScene As %String(MAXLEN = 1000) [ SqlColumnNumber = 8, SqlFieldName = TestScene ];

/// 现场记录
Property TestLog As %String(MAXLEN = 1000) [ SqlColumnNumber = 9, SqlFieldName = TestLog ];

/// 创建人也是提交人
Property Creator As %String [ SqlColumnNumber = 10, SqlFieldName = Creator ];

/// 创建日期
Property CreatDate As %Date [ SqlColumnNumber = 11, SqlFieldName = CreatDate ];

/// 提交日期
Property SubmitDate As %Date [ SqlColumnNumber = 12, SqlFieldName = SubmitDate ];

/// 提交时间
Property SubmitTime As %Time [ SqlColumnNumber = 13, SqlFieldName = SubmitTime ];

/// 状态N:未提交，S:已提交,H:护士长已评价，L:科护士长已评价
Property Status As %String [ SqlColumnNumber = 14, SqlFieldName = Status ];

/// 护士长评价
Property HeadEvaluate As %String(MAXLEN = 1000) [ SqlColumnNumber = 15, SqlFieldName = HeadEvaluate ];

/// 评价护士长
Property HeadNurse As %String [ SqlColumnNumber = 16, SqlFieldName = HeadNurse ];

/// 评价日期
Property HeadDate As %Date [ SqlColumnNumber = 17, SqlFieldName = HeadDate ];

/// 评价时间
Property HeadTime As %Time [ SqlColumnNumber = 18, SqlFieldName = HeadTime ];

/// 科护士长存在不足
Property Shortage As %String(MAXLEN = 1000) [ SqlColumnNumber = 19, SqlFieldName = Shortage ];

/// 科护士长持续改进
Property TestImprove As %String(MAXLEN = 1000) [ SqlColumnNumber = 20, SqlFieldName = TestImprove ];

/// 评价科护士长
Property ZHeadNurse As %String [ SqlColumnNumber = 21, SqlFieldName = ZHeadNurse ];

/// 评价日期
Property ZHeadDate As %Date [ SqlColumnNumber = 22, SqlFieldName = ZHeadDate ];

/// 评价时间
Property ZHeadTime As %Time [ SqlColumnNumber = 23, SqlFieldName = ZHeadTime ];

/// 添加记录附件
Property Refer As %String(MAXLEN = 2000) [ SqlColumnNumber = 24, SqlFieldName = Refer ];

Index Ward On (TestDate, TestWard);

Storage Default
{
<Data name="EmrPlanTestDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TestDate</Value>
</Value>
<Value name="3">
<Value>TestPlace</Value>
</Value>
<Value name="4">
<Value>TestDesc</Value>
</Value>
<Value name="5">
<Value>TestWard</Value>
</Value>
<Value name="6">
<Value>TestDemon</Value>
</Value>
<Value name="7">
<Value>TestTrainer</Value>
</Value>
<Value name="8">
<Value>TestScene</Value>
</Value>
<Value name="9">
<Value>TestLog</Value>
</Value>
<Value name="10">
<Value>Creator</Value>
</Value>
<Value name="11">
<Value>CreatDate</Value>
</Value>
<Value name="12">
<Value>SubmitDate</Value>
</Value>
<Value name="13">
<Value>SubmitTime</Value>
</Value>
<Value name="14">
<Value>Status</Value>
</Value>
<Value name="15">
<Value>HeadEvaluate</Value>
</Value>
<Value name="16">
<Value>HeadNurse</Value>
</Value>
<Value name="17">
<Value>HeadDate</Value>
</Value>
<Value name="18">
<Value>HeadTime</Value>
</Value>
<Value name="19">
<Value>Shortage</Value>
</Value>
<Value name="20">
<Value>TestImprove</Value>
</Value>
<Value name="21">
<Value>ZHeadNurse</Value>
</Value>
<Value name="22">
<Value>ZHeadDate</Value>
</Value>
<Value name="23">
<Value>ZHeadTime</Value>
</Value>
<Value name="24">
<Value>Refer</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.EmrPlanTestD</DataLocation>
<DefaultData>EmrPlanTestDefaultData</DefaultData>
<IdLocation>^DHCINM.Tea.EmrPlanTestD</IdLocation>
<IndexLocation>^DHCINM.Tea.EmrPlanTestI</IndexLocation>
<StreamLocation>^DHCINM.Tea.EmrPlanTestS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
