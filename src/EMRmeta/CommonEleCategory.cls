/// Desc:      公用元素目录表
/// Creator:   yejian
/// CreateDate:2014-4-15
Class EMRmeta.CommonEleCategory Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

Index IdxOnInternalID On InternalID [ Unique ];

/// 名称
Property Name As %String(MAXLEN = 200, TRUNCATE = 1);

/// 描述	
Property Description As %String(MAXLEN = 200, TRUNCATE = 1);

/// 该术语范畴下的术语数目
Property ResChildCount As %Integer;

/// 内部表示符
Property InternalID As %String(TRUNCATE = 1);

/// 父类ID
Property ParentID As %String(TRUNCATE = 1);

/// 模板模板标识符Code 遵循电子病历基本架构中业务活动记录EMRxxx
Property TemCode As %String(MAXLEN = 200, TRUNCATE = 1);

/// 模板描述 DisplayName
Property TemDisplayName As %String(MAXLEN = 200, TRUNCATE = 1);

Storage Default
{
<Data name="CommonEleCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>InternalID</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
<Value name="6">
<Value>Code</Value>
</Value>
<Value name="7">
<Value>ResChildCount</Value>
</Value>
<Value name="8">
<Value>TemCode</Value>
</Value>
<Value name="9">
<Value>TemDisplayName</Value>
</Value>
</Data>
<DataLocation>^DHCEMRM.CommonEleCategoryD</DataLocation>
<DefaultData>CommonEleCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEMRM.CommonEleCategoryD</IdLocation>
<IndexLocation>^DHCEMRM.CommonEleCategoryI</IndexLocation>
<StreamLocation>^DHCEMRM.CommonEleCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
