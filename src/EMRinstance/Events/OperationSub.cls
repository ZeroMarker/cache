/// 名称:EMRinstance.Events.Operation                          
/// 描述:实例数据-医疗活动事件-手术\操作信息子表
/// 编写者：Candyxu
/// 编写日期: 2016-01-21
Class EMRinstance.Events.OperationSub Extends (%Persistent, %XML.Adaptor)
{

Index IdxOperRef On OperRef;

Index IdxOperID On OperID;

Relationship OperRef As EMRinstance.Events.Operation [ Cardinality = parent, Inverse = OperSub ];

/// 手术码表Id
Property OperID As %String;

/// 手术手术名称
Property Oper As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 手术备注
Property OperMemo As %String(MAXLEN = 2000, TRUNCATE = 1);

/// 手术等级ID
Property OperLevelID As %String;

/// 手术等级描述
Property OperLevel As %String;

/// 切口ID
Property OperBladeTypeID As %String;

/// 切口描述
Property OperBladeType As %String;

/// 手术手术编码
Property OperCode As %String;

/// 拟施手术码表Id
Property PlanOperID As %String;

/// 拟施手术手术名称
Property PlanOperName As %String(MAXLEN = 500, TRUNCATE = 1);

Storage Default
{
<Data name="OperationSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OperID</Value>
</Value>
<Value name="3">
<Value>Oper</Value>
</Value>
<Value name="4">
<Value>OperMemo</Value>
</Value>
<Value name="5">
<Value>OperLevelID</Value>
</Value>
<Value name="6">
<Value>OperLevel</Value>
</Value>
<Value name="7">
<Value>OperBladeTypeID</Value>
</Value>
<Value name="8">
<Value>OperBladeType</Value>
</Value>
<Value name="9">
<Value>OperCode</Value>
</Value>
<Value name="10">
<Value>PlanOperID</Value>
</Value>
<Value name="11">
<Value>PlanOperName</Value>
</Value>
</Data>
<DataLocation>{%%PARENT}("OperSub")</DataLocation>
<DefaultData>OperationSubDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>{%%PARENT}("OperSub")</IdLocation>
<IndexLocation>^DHCEMRI.Events.OperationSubI</IndexLocation>
<StreamLocation>^DHCEMRI.Events.OperationSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
