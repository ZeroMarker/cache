/// 名称: User.BDPCTLOCCategory
/// 描述: 基础数据平台  科室层级分类
/// 编写者：陈莹
/// 编写日期: 2019-12-25
Class User.BDPCTLOCCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_CTLOCCategory ]
{

/// 代码,要求唯一
Property Code As %String(MAXLEN = "") [ Required ];

/// 名称,中文描述
Property Caption As %String(MAXLEN = "") [ Required ];

/// 片区(Area)/学科(Subject)/学科分类(SubjectCategory)，要求必填
Property Type As %String [ Required ];

/// 上级分类
Property ParentCatDr As User.BDPCTLOCCategory;

/// 激活状态(Y/N)
Property ActiveFlag As %String;

/// 显示顺序,1,2,3
Property Sequence As %Float;

Index UniqueCodeIndex On Code [ Unique ];

Index TypeCodeIdx On (Type, Code);

Index ParCatIdx On ParentCatDr;

Index CaptionIdx On Caption;

/// 父菜单+顺序生成的索引
Index ParSeqIdx On (ParentCatDr, Sequence As Exact);

Storage Default
{
<Data name="BDPCTLOCCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Caption</Value>
</Value>
<Value name="4">
<Value>Type</Value>
</Value>
<Value name="5">
<Value>ParentCatDr</Value>
</Value>
<Value name="6">
<Value>ActiveFlag</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
</Data>
<DataLocation>^User.BDPCTLOCCategoryD</DataLocation>
<DefaultData>BDPCTLOCCategoryDefaultData</DefaultData>
<IdLocation>^User.BDPCTLOCCategoryD</IdLocation>
<IndexLocation>^User.BDPCTLOCCategoryI</IndexLocation>
<StreamLocation>^User.BDPCTLOCCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
