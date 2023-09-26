/// 名称: User.BDPItemCategory
/// 描述: 基础数据平台   收费项目分类
/// 编写者：陈莹
/// 编写日期: 2016-4-22
Class User.BDPItemCategory Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlTableName = BDP_ItemCategory ]
{

/// 代码,要求唯一
Property Code As %String(MAXLEN = 100) [ Required ];

/// 名称,中文描述
Property Caption As %String(MAXLEN = 200) [ Required ];

/// 级联树的类型，如收费项目科目类别ItemCat(默认)，收费项目分类DHCTarCate，会计费用大类DHCTarAC，门诊费用分类DHCTarOC，
/// 住院费用分类DHCTarIC，核算费用分类DHCTarEC，病案首页分类DHCTarMC，新病案首页分类DHCTarMCNew
Property Type As %String;

/// 父菜单指针
Property ParentCatDr As User.BDPItemCategory;

/// 激活状态标志
Property ActiveFlag As %String;

/// 显示顺序,1,2,3
Property Sequence As %String;

Index UniqueCodeIndex On Code;

Index ParCatIdx On ParentCatDr;

/// 父菜单+顺序生成的索引
Index ParSeqIdx On (ParentCatDr, Sequence);

Storage Default
{
<Data name="BDPItemCategoryDefaultData">
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
<Value name="8">
<Value>CatLevel</Value>
</Value>
</Data>
<DataLocation>^User.BDPItemCategoryD</DataLocation>
<DefaultData>BDPItemCategoryDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPItemCategoryD</IdLocation>
<IndexLocation>^User.BDPItemCategoryI</IndexLocation>
<StreamLocation>^User.BDPItemCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
