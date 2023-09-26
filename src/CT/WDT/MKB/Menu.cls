/// 名称: CT.WDT.MKB.Menu
/// 描述: 菜单定义表
/// 编写者：钟荣枫
/// 编写日期: 2021-9-2
Class CT.WDT.MKB.Menu Extends (%Persistent, User.Abstract)
{

Relationship ChildItem As CT.WDT.MKB.FunctionalElement [ Cardinality = children, Inverse = ParRef ];

/// 菜单代码,要求唯一
Property Code As %String(MAXLEN = 100) [ Required ];

/// 菜单名称,中文描述
Property Caption As %String(MAXLEN = 200) [ Required ];

/// 菜单指向的功能定义
Property LinkFuntionDR As User.BDPExecutables;

/// 对应的URL解析地址,默认的是
Property LinkUrl As web.BDP.sys.String;

/// 本菜单默认的图标，默认是+,打开是-
Property Image As web.BDP.sys.String;

/// 点击本菜单时，可以执行的Cache服务器端的类方法
/// 先留着这个定义
Property Method As web.BDP.sys.String;

/// 显示顺序,可以使用1,2,3或者A、B、C等字符定义，使用Ascii码来标识大小
Property Sequence As %String;

/// 菜单快捷键
Property ShortcutKey As %String;

/// 在弹出窗口或者增加Tab的方式显示当前菜单功能
Property ShowInNewWindow As %String;

/// 父菜单指针
Property ParentMenuDr As CT.WDT.MKB.Menu;

/// 最后的更新日期
Property UpdateDate As %Date;

/// 最后的更新时间
Property UpdateTime As %Time;

/// 最后的更新用户
Property UpdateUser As User.SSUser;

/// 值表达式，暂时留着
Property ValueExpression As web.BDP.sys.String;

/// 菜单激活状态标志，分别用来控制数据维护菜单、功能元素菜单、基础数据授权等菜单是否激活。2014.7.16 caihaozhe
Property ActiveFlag As %String;

/// 组件名称 2014.7.24 caihaozhe
Property CompName As %String;

/// 产品线指针 2015.10.27 guxueping
Property ProductLineDr As User.DHCProductLine;

/// 首拼 2017.10.10 guxueping
Property FirstPYCODE As %String(MAXLEN = 200);

/// 全拼 2017.10.10 guxueping
Property WholePYCODE As %String(MAXLEN = "");

/// 是否属于医用知识库 2018.04.03 chenying
Property IsMKBMenu As %String;

Index UniqueCodeIndex On Code [ Unique ];

Index ParMenuIdx On ParentMenuDr;

/// 父菜单+顺序生成的索引
Index ParSeqIdx On (ParentMenuDr, Sequence);

/// 父菜单+顺序生成的索引 (去掉空格),2018.04.01 chenghegui
Index ParSeqIndex On (ParentMenuDr As Exact, Sequence As Exact);

Storage Default
{
<Data name="MenuDefaultData">
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
<Value>LinkFuntionDR</Value>
</Value>
<Value name="5">
<Value>LinkUrl</Value>
</Value>
<Value name="6">
<Value>Image</Value>
</Value>
<Value name="7">
<Value>Method</Value>
</Value>
<Value name="8">
<Value>Sequence</Value>
</Value>
<Value name="9">
<Value>ShortcutKey</Value>
</Value>
<Value name="10">
<Value>ShowInNewWindow</Value>
</Value>
<Value name="11">
<Value>ParentMenuDr</Value>
</Value>
<Value name="12">
<Value>UpdateDate</Value>
</Value>
<Value name="13">
<Value>UpdateTime</Value>
</Value>
<Value name="14">
<Value>UpdateUser</Value>
</Value>
<Value name="15">
<Value>ValueExpression</Value>
</Value>
<Value name="16">
<Value>ActiveFlag</Value>
</Value>
<Value name="17">
<Value>CompName</Value>
</Value>
<Value name="18">
<Value>ProductLineDr</Value>
</Value>
<Value name="19">
<Value>FirstPYCODE</Value>
</Value>
<Value name="20">
<Value>WholePYCODE</Value>
</Value>
<Value name="21">
<Value>IsMKBMenu</Value>
</Value>
</Data>
<DataLocation>^CT.WDT.MKB.MenuD</DataLocation>
<DefaultData>MenuDefaultData</DefaultData>
<IdLocation>^CT.WDT.MKB.MenuD</IdLocation>
<IndexLocation>^CT.WDT.MKB.MenuI</IndexLocation>
<StreamLocation>^CT.WDT.MKB.MenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
