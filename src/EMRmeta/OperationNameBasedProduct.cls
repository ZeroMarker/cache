/// 名称:EMRmeta.OperationNameBasedProduct
/// 描述:各产品模块操作病历名称配置表
/// 编写者：liuyunfei
/// 编写日期: 2020-05-21
Class EMRmeta.OperationNameBasedProduct Extends %Persistent
{

/// 动作
Property Action As %String;

/// 产品模块
Property ProductSource As %String;

/// 操作日志名称
Property OperationName As %String;

Index IdxProductSource On (ProductSource, Action);

Storage Default
{
<Data name="OperationNameBasedProductDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Action</Value>
</Value>
<Value name="3">
<Value>ProductSource</Value>
</Value>
<Value name="4">
<Value>OperationName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.OperationNameD</DataLocation>
<DefaultData>OperationNameBasedProductDefaultData</DefaultData>
<IdLocation>^DHCEMRM.OperationNameD</IdLocation>
<IndexLocation>^DHCEMRM.OperationNameI</IndexLocation>
<StreamLocation>^DHCEMRM.OperationNameS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
