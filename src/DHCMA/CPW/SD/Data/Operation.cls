/// 描述: 单病种与手术相关的数据
Class DHCMA.CPW.SD.Data.Operation Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊ID
Property EpisodeID As %String(TRUNCATE = 1);

/// 记录ID
Property RecordID As %String(TRUNCATE = 1);

/// 手术编码(CM3)
Property OperCode As %String(TRUNCATE = 1);

/// 手术名称
Property OperDesc As %String(MAXLEN = 100, TRUNCATE = 1);

/// 手术类型（急诊、择期、损伤）
Property OperType As %String(TRUNCATE = 1);

/// 手术开始日期
Property SttDate As %String(TRUNCATE = 1);

/// 手术开始时间
Property SttTime As %String(TRUNCATE = 1);

/// 手术开始日期时间
Property SttDateT As %String(TRUNCATE = 1);

/// 手术结束日期
Property EndDate As %String(TRUNCATE = 1);

/// 手术结束时间
Property EndTime As %String(TRUNCATE = 1);

/// 手术结束日期时间
Property EndDateT As %String(TRUNCATE = 1);

/// 手术科室代码
Property DeptCode As %String(TRUNCATE = 1);

/// 手术科室名称
Property DeptDesc As %String(TRUNCATE = 1);

/// 手术医生代码
Property DocCode As %String(TRUNCATE = 1);

/// 手术医生名称
Property DocName As %String(TRUNCATE = 1);

/// 切口等级（Ⅰ、Ⅱ、Ⅲ、Ⅳ、无）
Property CutType As %String(TRUNCATE = 1);

/// 愈合情况(甲、乙、丙、无)
Property CutHealing As %String(TRUNCATE = 1);

/// 麻醉方法
Property Anesthesia As %String(TRUNCATE = 1);

/// ASA（麻醉）评分 （P1、P2、P3、P4、P5、P6）
Property ASAScore As %String(TRUNCATE = 1);

/// 手术日期
Property ActDate As %String(TRUNCATE = 1);

/// 手术开始时间
Property ActTime As %String(TRUNCATE = 1);

/// 术者代码
Property ActUser As %String(TRUNCATE = 1);

/// 术者姓名
Property ActUserDesc As %String(TRUNCATE = 1);

/// 失血量
Property LoseBlood As %String(TRUNCATE = 1);

/// 输血量
Property GotBlood As %String(TRUNCATE = 1);

/// 手术时长>=3小时（是否）
Property Time3h As %String(TRUNCATE = 1);

/// 手术持续时间(分钟)
Property OperMin As %String(TRUNCATE = 1);

/// 术中出血量是否≥1500ml
Property Lose1500 As %String(TRUNCATE = 1);

/// 有无实施手术患者静脉血栓栓塞症风险评估
Property VTEFlg As %String(TRUNCATE = 1);

/// 是否进行手术后镇痛治疗
Property EasePain As %String(TRUNCATE = 1);

/// 非计划再次手术
Property BadReOper As %String(TRUNCATE = 1);

/// 备皮方式 
Property SkinType As %String(TRUNCATE = 1);

Index IdxRecordID On RecordID As Exact;

Index IdxAdm On EpisodeID As Exact;

Storage Default
{
<Data name="OperationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EpisodeID</Value>
</Value>
<Value name="3">
<Value>RecordID</Value>
</Value>
<Value name="4">
<Value>OperCode</Value>
</Value>
<Value name="5">
<Value>OperDesc</Value>
</Value>
<Value name="6">
<Value>OperType</Value>
</Value>
<Value name="7">
<Value>SttDate</Value>
</Value>
<Value name="8">
<Value>SttTime</Value>
</Value>
<Value name="9">
<Value>SttDateT</Value>
</Value>
<Value name="10">
<Value>EndDate</Value>
</Value>
<Value name="11">
<Value>EndTime</Value>
</Value>
<Value name="12">
<Value>EndDateT</Value>
</Value>
<Value name="13">
<Value>DeptCode</Value>
</Value>
<Value name="14">
<Value>DeptDesc</Value>
</Value>
<Value name="15">
<Value>DocCode</Value>
</Value>
<Value name="16">
<Value>DocName</Value>
</Value>
<Value name="17">
<Value>CutType</Value>
</Value>
<Value name="18">
<Value>CutHealing</Value>
</Value>
<Value name="19">
<Value>Anesthesia</Value>
</Value>
<Value name="20">
<Value>ASAScore</Value>
</Value>
<Value name="21">
<Value>ActDate</Value>
</Value>
<Value name="22">
<Value>ActTime</Value>
</Value>
<Value name="23">
<Value>ActUser</Value>
</Value>
<Value name="24">
<Value>ActUserDesc</Value>
</Value>
<Value name="25">
<Value>LoseBlood</Value>
</Value>
<Value name="26">
<Value>GotBlood</Value>
</Value>
<Value name="27">
<Value>Time3h</Value>
</Value>
<Value name="28">
<Value>OperMin</Value>
</Value>
<Value name="29">
<Value>Lose1500</Value>
</Value>
<Value name="30">
<Value>VTEFlg</Value>
</Value>
<Value name="31">
<Value>EasePain</Value>
</Value>
<Value name="32">
<Value>BadReOper</Value>
</Value>
<Value name="33">
<Value>SkinType</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.Data.OperationD</DataLocation>
<DefaultData>OperationDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.Data.OperationD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.Data.OperationI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.Data.OperationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
