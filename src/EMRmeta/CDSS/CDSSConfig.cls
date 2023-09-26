/// CDSS数据结构配置类
/// creator duan
/// createDate 2020-06-03
Class EMRmeta.CDSS.CDSSConfig Extends %Persistent
{

Index cdssDataID On (CDSSTool, CDSSKeyLevel, Active, Action);

/// CDSS厂商标识
Property CDSSTool As %String [ Required ];

/// 节点关键字
Property CDSSKey As %String;

/// 节点关联关系
Property CDSSKeyLevel As %String;

/// 节点类型
Property CDSSKeyType As %String;

/// 节点值
Property CDSSKeyValue As %String(MAXLEN = 1500);

/// 节点有效范围 0无效 I住院 O门诊 all全部
Property Active As %String;

/// 节点操作范围 save(保存) delete(删除) all(都需要)
Property Action As %String;

/// 病历术语代码
Property HDSDCode As %String(TRUNCATE = 1);

Storage Default
{
<Data name="CDSSConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CDSSKey</Value>
</Value>
<Value name="3">
<Value>CDSSKeyLevel</Value>
</Value>
<Value name="4">
<Value>CDSSKeyType</Value>
</Value>
<Value name="5">
<Value>CDSSKeyValue</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>Action</Value>
</Value>
<Value name="8">
<Value>CDSSTool</Value>
</Value>
<Value name="9">
<Value>HDSDCode</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CDSSConfigD</DataLocation>
<DefaultData>CDSSConfigDefaultData</DefaultData>
<IdLocation>^DHCEMRM.CDSSConfigD</IdLocation>
<IndexLocation>^DHCEMRM.CDSSConfigI</IndexLocation>
<StreamLocation>^DHCEMRM.CDSSConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
