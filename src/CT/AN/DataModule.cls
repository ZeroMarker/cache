/// 数据模块
Class CT.AN.DataModule Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DataModule ]
{

/// 模块代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 模块名称
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 父模块
Property ParentModule As CT.AN.DataModule [ SqlColumnNumber = 4 ];

/// 模块链接页面的URL(相对地址)
Property URL As %String [ SqlColumnNumber = 5 ];

/// 是否菜单模块
Property MenuModule As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ SqlColumnNumber = 6 ];

/// 是否激活
Property Active As %String(DISPLAYLIST = ",是,否", MAXLEN = 2, VALUELIST = ",Y,N") [ InitialExpression = "Y", SqlColumnNumber = 7 ];

/// 图标
Property Icon As %String [ SqlColumnNumber = 8 ];

/// 序号
Property SeqNo As %Integer [ SqlColumnNumber = 9 ];

/// 激活日期
Property ActiveDate As %Date [ InitialExpression = {+$h}, SqlColumnNumber = 10 ];

/// 失效日期
Property ExpireDate As %Date [ SqlColumnNumber = 11 ];

/// CA签名开关
Property CASign As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 12 ];

/// 是否需要归档
Property Archive As %String(DISPLAYLIST = ",是,否", VALUELIST = ",Y,N") [ SqlColumnNumber = 13 ];

/// 浏览URL
Property DetailUrl As %String(MAXLEN = 200) [ SqlColumnNumber = 14 ];

/// 归档代码
Property ArchiveCode As %String [ SqlColumnNumber = 15 ];

/// 可编辑状态
Property EditStatus As %String [ SqlColumnNumber = 16 ];

/// 关联模块
Property RelateModule As CT.AN.DataModule [ SqlColumnNumber = 17 ];

/// 模块代码唯一索引
Index ICode On Code [ Unique ];

/// 父模块索引
Index Parent On ParentModule;

Storage Default
{
<Data name="DataModuleDefaultData">
<Value name="1">
<Value>Code</Value>
</Value>
<Value name="2">
<Value>Description</Value>
</Value>
<Value name="3">
<Value>ParentModule</Value>
</Value>
<Value name="4">
<Value>URL</Value>
</Value>
<Value name="5">
<Value>MenuModule</Value>
</Value>
<Value name="6">
<Value>Active</Value>
</Value>
<Value name="7">
<Value>Icon</Value>
</Value>
<Value name="8">
<Value>SeqNo</Value>
</Value>
<Value name="9">
<Value>ActiveDate</Value>
</Value>
<Value name="10">
<Value>ExpireDate</Value>
</Value>
<Value name="11">
<Value>CASign</Value>
</Value>
<Value name="12">
<Value>Archive</Value>
</Value>
<Value name="13">
<Value>DetailUrl</Value>
</Value>
<Value name="14">
<Value>ArchiveCode</Value>
</Value>
<Value name="15">
<Value>EditStatus</Value>
</Value>
<Value name="16">
<Value>RelateModule</Value>
</Value>
</Data>
<DataLocation>^CT.AN.DataModuleD</DataLocation>
<DefaultData>DataModuleDefaultData</DefaultData>
<IdLocation>^CT.AN.DataModuleD</IdLocation>
<IndexLocation>^CT.AN.DataModuleI</IndexLocation>
<StreamLocation>^CT.AN.DataModuleS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
