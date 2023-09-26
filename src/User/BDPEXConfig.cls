/// 导出配置表
/// 父表
Class User.BDPEXConfig Extends (%Persistent, User.Abstract) [ ClassType = persistent, SqlTableName = BDP_EXConfig ]
{

///  ParRef
Relationship ChildField As User.BDPEXFieldConfig [ Cardinality = children, Inverse = ParRef ];

/// 中文名称
Property EXCTableDesc As %String(MAXLEN = "") [ Required ];

/// 实体类名
Property EXCTableName As %String(MAXLEN = "") [ Required ];

/// rowID名（entity）
Property EXCIDName As %String(MAXLEN = "");

/// 例如， $o(^IHBI.KBaseDefineD(xrowid))
Property EXCXGlobal As %String(MAXLEN = "");

/// 关联Gof
Property EXCLinkGofDr As User.BDPEILink;

/// 关联Excel
Property EXCLinkExcelDr As User.BDPEILink;

/// 是否是子表
Property EXCIsChildTable As %String(DISPLAYLIST = ",Yes,No", MAXLEN = 3, TRUNCATE = 1, VALUELIST = ",Y,N") [ InitialExpression = "N" ];

/// 获取父表Global
Property EXCParRefGlobal As %String(MAXLEN = "");

Index EXCLinkGDrI On EXCLinkGofDr;

Index EXCLinkEDrI On EXCLinkExcelDr;

Index UniqueTableName On EXCTableName [ Unique ];

Index TableNameDescIndex On (EXCTableName As Exact, EXCTableDesc As Exact);

Index TableDescNameIndex On (EXCTableDesc As Exact, EXCTableName As Exact);

Index UniqueTableDesc On EXCTableDesc [ Unique ];

Storage Default
{
<Data name="BDPEXConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>EXCTableDesc</Value>
</Value>
<Value name="3">
<Value>EXCTableName</Value>
</Value>
<Value name="4">
<Value>EXCIDName</Value>
</Value>
<Value name="5">
<Value>EXCXGlobal</Value>
</Value>
<Value name="6">
<Value>EXCLinkGofDr</Value>
</Value>
<Value name="7">
<Value>EXCLinkExcelDr</Value>
</Value>
<Value name="8">
<Value>EXCIsChildTable</Value>
</Value>
<Value name="9">
<Value>EXCParRefGlobal</Value>
</Value>
</Data>
<DataLocation>^User.BDPEXConfigD</DataLocation>
<DefaultData>BDPEXConfigDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^User.BDPEXConfigD</IdLocation>
<IndexLocation>^User.BDPEXConfigI</IndexLocation>
<StreamLocation>^User.BDPEXConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
