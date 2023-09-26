/// CRBSI干预核查表
Class DHCMed.NINF.Aim.CRBSI Extends (%Persistent, DHCMed.Abstract) [ ClassType = persistent, Not ProcedureBlock ]
{

/// 就诊ID
Property PaadmDR As %String(TRUNCATE = 1) [ Required ];

/// 电子病历实例数据rowid
Property InstanceDataID As %String(TRUNCATE = 1) [ Required ];

/// 转入日期
Property InICUDate As %String(TRUNCATE = 1) [ Required ];

/// 定期更换穿刺点敷料(无菌纱布)
Property Update2D As %Date;

/// 定期更换穿刺点敷料(专用贴膜)
Property Update7D As %Time;

/// 敷料应更换则立即更换
Property ShouldChanged As %String(TRUNCATE = 1);

/// 操作时手相关的操作是否合格
Property HandAction As %String(TRUNCATE = 1);

/// 三通锁闭清洁
Property ThreeClean As %Date;

/// 留置导管日常护理
Property PipeDayCare As %String(TRUNCATE = 1);

/// 怀疑导管感染时拔出导管
Property InfPipeCancel As %String(TRUNCATE = 1);

/// 每日是否评估置管的必要性
Property PipeNecEVA As %String(TRUNCATE = 1);

/// 更换输液导管不超过96h
Property UpdateUn96h As %String(TRUNCATE = 1);

Index IndexPaadm On (PaadmDR, InstanceDataID) [ Unique ];

Storage Default
{
<Data name="CRBSIDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>HandAction</Value>
</Value>
<Value name="3">
<Value>InICUDate</Value>
</Value>
<Value name="4">
<Value>InfPipeCancel</Value>
</Value>
<Value name="5">
<Value>PaadmDR</Value>
</Value>
<Value name="6">
<Value>PipeDayCare</Value>
</Value>
<Value name="7">
<Value>PipeNecEVA</Value>
</Value>
<Value name="8">
<Value>ShouldChanged</Value>
</Value>
<Value name="9">
<Value>ThreeClean</Value>
</Value>
<Value name="10">
<Value>Update2D</Value>
</Value>
<Value name="11">
<Value>Update7D</Value>
</Value>
<Value name="12">
<Value>UpdateUn96h</Value>
</Value>
<Value name="13">
<Value>InstanceDataID</Value>
</Value>
</Data>
<DataLocation>^DHCMed.NINF.Aim.CRBSID</DataLocation>
<DefaultData>CRBSIDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.NINF.Aim.CRBSID</IdLocation>
<IndexLocation>^DHCMed.NINF.Aim.CRBSII</IndexLocation>
<StreamLocation>^DHCMed.NINF.Aim.CRBSIS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
