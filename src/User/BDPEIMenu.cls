/// 名称: User.BDPEIMenu
/// 描述: 导入导出菜单表
/// 编写者：谷雪萍
/// 编写日期: 2016-11-03
Class User.BDPEIMenu Extends (%Persistent, User.Abstract) [ ClassType = persistent, Owner = {_SYSTEM}, SqlTableName = BDP_EIMenu ]
{

/// 菜单代码,要求唯一
Property Code As %String(MAXLEN = 100) [ Required ];

/// 菜单名称,中文描述
Property Caption As %String(MAXLEN = 200) [ Required ];

/// 父菜单指针
Property ParentMenuDr As User.BDPEIMenu;

/// 显示顺序,可以使用1,2,3或者A、B、C等字符定义，使用Ascii码来标识大小
Property Sequence As %String;

/// 本菜单默认的图标，默认是+,打开是-
Property Image As web.BDP.sys.String;

/// 表名
Property TableName As %String(MAXLEN = "");

/// 类名
Property ClassName As %String(MAXLEN = "");

/// Kglobal 2016-11-21
Property Kglobal As %String(MAXLEN = "");

/// 显示在导入菜单 2016-11-22
Property ImportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// 显示在导出菜单 2016-11-22
Property ExportFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// 是否加锁 2016-11-25
Property LockFlag As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N");

/// 指向表结构登记，可以获取此菜单的公私有属性 2020-06-01chenying
Property LinkTableDr As User.BDPTableList;

Index UniqueCodeIndex On Code [ Unique ];

Index ParMenuIdx On ParentMenuDr;

/// 父菜单+顺序生成的索引
Index ParSeqIdx On (ParentMenuDr, Sequence);

/// 表名+类名生成的索引
Index TableIdx On (TableName As Exact, ClassName As Exact);

/// 表名生成的索引
Index TableNameIdx On TableName As Exact;

Storage Default
{
<Data name="BDPEIMenuDefaultData">
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
<Value>ParentMenuDr</Value>
</Value>
<Value name="5">
<Value>Sequence</Value>
</Value>
<Value name="6">
<Value>Image</Value>
</Value>
<Value name="7">
<Value>TableName</Value>
</Value>
<Value name="8">
<Value>ClassName</Value>
</Value>
<Value name="9">
<Value>Kglobal</Value>
</Value>
<Value name="10">
<Value>ImportFlag</Value>
</Value>
<Value name="11">
<Value>ExportFlag</Value>
</Value>
<Value name="12">
<Value>LockFlag</Value>
</Value>
<Value name="13">
<Value>LinkTableDr</Value>
</Value>
</Data>
<DataLocation>^User.BDPEIMenuD</DataLocation>
<DefaultData>BDPEIMenuDefaultData</DefaultData>
<IdLocation>^User.BDPEIMenuD</IdLocation>
<IndexLocation>^User.BDPEIMenuI</IndexLocation>
<StreamLocation>^User.BDPEIMenuS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
