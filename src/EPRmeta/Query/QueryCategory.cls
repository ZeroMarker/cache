/// 电子病历综合查询配置分类表
Class EPRmeta.Query.QueryCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock ]
{

/// 分类代码唯一索引
Index IdxCode On Code [ Unique ];

/// 子节点索引
Index IdxParentID On ParentID;

/// 分类代码
Property Code As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 分类名称
Property Name As %String(MAXLEN = 500, TRUNCATE = 1) [ Required ];

/// 分类顺序编号
Property Sequence As %Integer;

/// 父节点
Property ParentID As %String(TRUNCATE = 1);

/// 是否有效
Property IsActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 备注
Property Remark As %String(MAXLEN = 200);

Storage Default
{
<Data name="QueryCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Sequence</Value>
</Value>
<Value name="5">
<Value>ParentID</Value>
</Value>
<Value name="6">
<Value>IsActive</Value>
</Value>
<Value name="7">
<Value>Remark</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QueryCategoryD</DataLocation>
<DefaultData>QueryCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QueryCategoryD</IdLocation>
<IndexLocation>^DHCEPRM.QueryCategoryI</IndexLocation>
<StreamLocation>^DHCEPRM.QueryCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
