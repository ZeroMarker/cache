/// 基础数据平台-导入配置表
/// 父表
Class User.BDPIMConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_IMConfig ]
{

///  ParRef
Relationship ChildField As User.BDPIMFieldConfig [ Cardinality = children, Inverse = ParRef ];

/// 中文名称
Property IMCTableDesc As %String(MAXLEN = "") [ Required ];

/// 实体类名
Property IMCTableName As %String(MAXLEN = "") [ Required ];

/// rowID名（entity）
Property IMCIDName As %String(MAXLEN = "");

/// 保存的类
Property IMCSaveClass As %String(MAXLEN = "");

/// 保存方法名
Property IMCSaveMethod As %String(MAXLEN = "");

/// Entity类名
Property IMCSaveEntity As %String(MAXLEN = "");

/// 导入时 修改时用于校验 获取rowid的索引
Property IMCGetRowId As %String(MAXLEN = "");

/// 关联Gof配置
Property IMCLinkGofDr As User.BDPEILink;

/// 关联Excel配置
Property IMCLinkExcelDr As User.BDPEILink;

/// 父菜单指针
Property IMCParentDr As User.BDPIMConfig;

/// 导入说明 2016-11-21
Property IMCText As %String(MAXLEN = "");

/// 导出-获取Global  2021-02-19
Property EXCXGlobal As %String(MAXLEN = "");

/// 导出-是否是子表
Property EXCIsChildTable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N" ];

/// 导出-获取父表Global
Property EXCParRefGlobal As %String(MAXLEN = "");

Index IMCLinkGDrI On IMCLinkGofDr;

Index IMCLinkEDrI On IMCLinkExcelDr;

Index UniqueTableName On IMCTableName [ Unique ];

Index TableNameDescIndex On (IMCTableName As Exact, IMCTableDesc As Exact);

Index TableDescNameIndex On (IMCTableDesc As Exact, IMCTableName As Exact);

Index UniqueTableDesc On IMCTableDesc [ Unique ];

/// 父菜单生成的索引
Index ParIdx On IMCParentDr;

Storage Default
{
<Data name="BDPIMConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>IMCTableDesc</Value>
</Value>
<Value name="3">
<Value>IMCTableName</Value>
</Value>
<Value name="4">
<Value>IMCIDName</Value>
</Value>
<Value name="5">
<Value>IMCSaveClass</Value>
</Value>
<Value name="6">
<Value>IMCSaveMethod</Value>
</Value>
<Value name="7">
<Value>IMCSaveEntity</Value>
</Value>
<Value name="8">
<Value>IMCGetRowId</Value>
</Value>
<Value name="9">
<Value>IMCLinkGofDr</Value>
</Value>
<Value name="10">
<Value>IMCLinkExcelDr</Value>
</Value>
<Value name="11">
<Value>IMCParentDr</Value>
</Value>
<Value name="12">
<Value>IMCText</Value>
</Value>
<Value name="13">
<Value>EXCXGlobal</Value>
</Value>
<Value name="14">
<Value>EXCIsChildTable</Value>
</Value>
<Value name="15">
<Value>EXCParRefGlobal</Value>
</Value>
</Data>
<DataLocation>^User.BDPIMConfigD</DataLocation>
<DefaultData>BDPIMConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPIMConfigD</IdLocation>
<IndexLocation>^User.BDPIMConfigI</IndexLocation>
<StreamLocation>^User.BDPIMConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
