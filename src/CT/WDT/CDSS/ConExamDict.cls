/// Creator:钟荣枫
/// CreatDate:2020-12-22
/// Description：实施综合管理平台-字典对照-对接方检查检验字典表
/// Table：CT.WDT.CDSS.ConExamDict
Class CT.WDT.CDSS.ConExamDict Extends (%Persistent, User.Abstract)
{

/// 代码
Property ExamCode As %String(MAXLEN = "") [ Required ];

/// 描述
Property ExamName As %String(MAXLEN = "") [ Required ];

/// 知识库类型（检查或者检验)
Property ExamType As %String;

/// 样本代码
Property SpecimenCode As %String;

/// 样本名称
Property SpecimenName As %String;

/// 来源（住院/门诊/急诊）
Property Source As %String;

/// 医院
Property HospitalDR As CT.WDT.CDSS.CustomerHosp;

/// 备注
Property Remarks As %String;

/// 状态（未关联/已关联/已确认/已删除）
Property State As %String;

/// 创建时间（药品数据导入或者手动新增的时间）
Property CreateDate As %TimeStamp;

/// 创建人
Property CreateUser As %String;

/// 修改时间（对应的就是所有操作时间,包括删除,确认,关联,取消关联）
Property UpdateDate As %TimeStamp;

/// 修改人
Property UpdateUser As %String;

Index StateDescIndex On (State As Exact, ExamName As Exact, ExamType As Exact);

Index HospCNIndex On (HospitalDR, ExamCode As Exact, ExamName As Exact, ExamType As Exact);

Index HospStateIndex On (HospitalDR, State As Exact);

Index CreateDateIndex On (HospitalDR, CreateDate As Exact);

Index UpdateDateIndex On (HospitalDR, UpdateDate As Exact);

Index HospTypeStateIndex On (HospitalDR, ExamType As Exact, State As Exact);

/// 开始日期	2021-9-3 阚延新 增加开始日期以及结束日期
Property StartDate As %Date;

/// 结束日期
Property EndDate As %Date;

/// 客户类型（检查或者检验)
Property ConExamType As %String;

Storage Default
{
<Data name="ConExamDictDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ExamCode</Value>
</Value>
<Value name="3">
<Value>ExamName</Value>
</Value>
<Value name="4">
<Value>ExamType</Value>
</Value>
<Value name="5">
<Value>SpecimenCode</Value>
</Value>
<Value name="6">
<Value>SpecimenName</Value>
</Value>
<Value name="7">
<Value>Source</Value>
</Value>
<Value name="8">
<Value>HospitalDR</Value>
</Value>
<Value name="9">
<Value>Remarks</Value>
</Value>
<Value name="10">
<Value>State</Value>
</Value>
<Value name="11">
<Value>CreateDate</Value>
</Value>
<Value name="12">
<Value>CreateUser</Value>
</Value>
<Value name="13">
<Value>UpdateDate</Value>
</Value>
<Value name="14">
<Value>UpdateUser</Value>
</Value>
<Value name="15">
<Value>StartDate</Value>
</Value>
<Value name="16">
<Value>EndDate</Value>
</Value>
<Value name="17">
<Value>ConExamType</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.CDSS.ConExamDictD</DataLocation>
<DefaultData>ConExamDictDefaultData</DefaultData>
<IdLocation>^CT.WDT.CDSS.ConExamDictD</IdLocation>
<IndexLocation>^CT.WDT.CDSS.ConExamDictI</IndexLocation>
<StreamLocation>^CT.WDT.CDSS.ConExamDictS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
