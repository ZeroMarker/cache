/// Desc:       病历导航操作日志
/// Creator:    yejian
/// CreateDate: 2023-2-2
Class EMRmeta.EMRNavigationLog Extends %Persistent
{

Index IdxTypeDataID On (EmrType, DataID);

Index IdxTypeAction On (EmrType, Action);

/// 类型 方案类型 CATEGORY ，方案项目 ITEM,项目科室 ITEMLOC,项目安全组 ITEMGROUP
Property EmrType As %String(TRUNCATE = 1);

/// 操作数据
Property DataID As %String(MAXLEN = 32000, TRUNCATE = 1);

/// 事件 添加 ADD，更新 UP,删除：DELETE
Property Action As %String(TRUNCATE = 1);

/// 操作日期
Property OperateDate As %Date;

/// 操作时间
Property OperateTime As %Time;

/// 操作者ID
Property UserID As %String(TRUNCATE = 1);

/// 操作者
Property UserName As %String(TRUNCATE = 1);

/// 操作IP地址
Property MachineIP As %String(TRUNCATE = 1);

/// 备注信息
Property Remark As %String(MAXLEN = 5000, TRUNCATE = 1);

Storage Default
{
<Data name="EMRNavigationLogDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EmrType</Value>
</Value>
<Value name="3">
<Value>DataID</Value>
</Value>
<Value name="4">
<Value>Action</Value>
</Value>
<Value name="5">
<Value>OperateDate</Value>
</Value>
<Value name="6">
<Value>OperateTime</Value>
</Value>
<Value name="7">
<Value>UserID</Value>
</Value>
<Value name="8">
<Value>UserName</Value>
</Value>
<Value name="9">
<Value>MachineIP</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.EMRNavigationLogD</DataLocation>
<DefaultData>EMRNavigationLogDefaultData</DefaultData>
<IdLocation>^DHCEMRM.EMRNavigationLogD</IdLocation>
<IndexLocation>^DHCEMRM.EMRNavigationLogI</IndexLocation>
<StreamLocation>^DHCEMRM.EMRNavigationLogS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
