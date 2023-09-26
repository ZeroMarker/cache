/// 电子病历综合查询配置项目表
Class EPRmeta.Query.QueryItem Extends (%Persistent, User.Abstract) [ ClassType = persistent, ProcedureBlock ]
{

/// 项目名称唯一索引
Index IdxName On (CategoryID, Name) [ Unique ];

/// 项目代码唯一索引
Index IdxCode On (CategoryID, Code) [ Unique ];

/// 项目所在分类索引
Index IdxCategoryID On CategoryID;

/// 项目在其原生系统中的Code，如医嘱ID，检验项目别名等
Property Code As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目描述（主要用于查询结果返回列）
Property Title As %String(MAXLEN = 100, TRUNCATE = 1) [ Required ];

/// 项目顺序编号
Property Sequence As %Integer;

/// 项目字段类型（字符、数字等，暂时保留）
Property QueryItemTypeID As %Integer [ Required ];

/// 项目内部父节点（暂时没遇到，保留）
Property ParentID As %Integer [ Required ];

/// 项目分类
Property CategoryID As %Integer [ Required ];

/// 是否有效
Property IsActive As %String(DISPLAYLIST = ",Yes,No", TRUNCATE = 1, VALUELIST = ",Y,N");

/// 备注
Property Remark As %String(MAXLEN = 200);

/// 字典代码
Property StdDic As %String(MAXLEN = 100, TRUNCATE = 1);

/// 规则
Property Rules As %String(TRUNCATE = 1);

Storage Default
{
<Data name="QueryItemDefaultData">
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
<Value>Title</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>QueryItemTypeID</Value>
</Value>
<Value name="7">
<Value>ParentID</Value>
</Value>
<Value name="8">
<Value>CategoryID</Value>
</Value>
<Value name="9">
<Value>IsActive</Value>
</Value>
<Value name="10">
<Value>Remark</Value>
</Value>
<Value name="11">
<Value>StdDic</Value>
</Value>
<Value name="12">
<Value>Rules</Value>
</Value>
</Data>
<DataLocation>^DHCEPRM.QueryItemD</DataLocation>
<DefaultData>QueryItemDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRM.QueryItemD</IdLocation>
<IndexLocation>^DHCEPRM.QueryItemI</IndexLocation>
<StreamLocation>^DHCEPRM.QueryItemS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
