/// Creator:lulin
/// Descriptions:护士培训
/// Date:
Class DHCINM.Tea.NurseTrain Extends %Persistent
{

/// 级别
Property TranLevel As %String [ SqlColumnNumber = 2, SqlFieldName = TranLevel ];

/// 培训项目
Property TranProject As %String [ SqlColumnNumber = 3, SqlFieldName = TranProject ];

/// 培训类型
Property TranType As %String [ SqlColumnNumber = 4, SqlFieldName = TranType ];

/// 专业组培训
Property TranProfession As %String [ SqlColumnNumber = 5, SqlFieldName = TranProfession ];

/// 培训方式
Property TranMode As %String [ SqlColumnNumber = 6, SqlFieldName = TranMode ];

/// 培训内容
Property TranContext As %String [ SqlColumnNumber = 7, SqlFieldName = TranContext ];

/// 负责人
Property TranCharge As %String [ SqlColumnNumber = 8, SqlFieldName = TranCharge ];

/// 培训人
Property TranNurse As %String [ SqlColumnNumber = 9, SqlFieldName = TranNurse ];

/// 备注
Property TranRemark As %String [ SqlColumnNumber = 10, SqlFieldName = TranRemark ];

/// 开始日期
Property TranStDate As %Date [ SqlColumnNumber = 11, SqlFieldName = TranStDate ];

/// 结束日期
Property TranEndDate As %Date [ SqlColumnNumber = 12, SqlFieldName = TranEndDate ];

/// 创建日期
Property TranCreatDate As %Date [ SqlColumnNumber = 13, SqlFieldName = TranCreatDate ];

/// 创建人
Property TranCrator As %String [ SqlColumnNumber = 14, SqlFieldName = TranCrator ];

/// 状态 N:保存，Y:发布
Property TranStatus As %String [ SqlColumnNumber = 15, SqlFieldName = TranStatus ];

/// 是否已完成,Y:完成
Property TranIsFinish As %String [ SqlColumnNumber = 16, SqlFieldName = TranIsFinish ];

/// 培训日期
Property TranDate As %Date [ SqlColumnNumber = 17, SqlFieldName = TranDate ];

/// 培训人群范围类型
Property TranRangeType As %String [ SqlColumnNumber = 18, SqlFieldName = TranRangeType ];

/// 培训人群范围
Property TranRange As %String [ SqlColumnNumber = 19, SqlFieldName = TranRange ];

/// 培训人群
Property TranPerson As %String(MAXLEN = 1000) [ SqlColumnNumber = 20, SqlFieldName = TranPerson ];

Index TranDate On TranDate;

Storage Default
{
<Data name="NurseTrainDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>TranLevel</Value>
</Value>
<Value name="3">
<Value>TranProject</Value>
</Value>
<Value name="4">
<Value>TranType</Value>
</Value>
<Value name="5">
<Value>TranProfession</Value>
</Value>
<Value name="6">
<Value>TranMode</Value>
</Value>
<Value name="7">
<Value>TranContext</Value>
</Value>
<Value name="8">
<Value>TranCharge</Value>
</Value>
<Value name="9">
<Value>TranNurse</Value>
</Value>
<Value name="10">
<Value>TranRemark</Value>
</Value>
<Value name="11">
<Value>TranStDate</Value>
</Value>
<Value name="12">
<Value>TranEndDate</Value>
</Value>
<Value name="13">
<Value>TranCreatDate</Value>
</Value>
<Value name="14">
<Value>TranCrator</Value>
</Value>
<Value name="15">
<Value>TranStatus</Value>
</Value>
<Value name="16">
<Value>TranIsFinish</Value>
</Value>
<Value name="17">
<Value>TranDate</Value>
</Value>
<Value name="18">
<Value>TranRangeType</Value>
</Value>
<Value name="19">
<Value>TranRange</Value>
</Value>
<Value name="20">
<Value>TranPerson</Value>
</Value>
</Data>
<DataLocation>^DHCINM.Tea.NurseTrainD</DataLocation>
<DefaultData>NurseTrainDefaultData</DefaultData>
<IdLocation>^DHCINM.Tea.NurseTrainD</IdLocation>
<IndexLocation>^DHCINM.Tea.NurseTrainI</IndexLocation>
<StreamLocation>^DHCINM.Tea.NurseTrainS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
