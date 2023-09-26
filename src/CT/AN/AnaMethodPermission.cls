/// 麻醉方法对应插管项目的可见性配置
Class CT.AN.AnaMethodPermission Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = AnaMethodPermission ]
{

/// 麻醉方法
Property AnaMethod As %String [ SqlColumnNumber = 2 ];

/// 麻醉导管
Property Catheter As %String(DISPLAYLIST = ",Visible,Hidden", VALUELIST = ",V,H") [ SqlColumnNumber = 3 ];

/// 麻醉导管型号
Property CatheterType As %String(DISPLAYLIST = ",Visible,Hidden", VALUELIST = ",V,H") [ SqlColumnNumber = 4 ];

/// 麻醉插管途径
Property CatheterPath As %String(DISPLAYLIST = ",Visible,Hidden", VALUELIST = ",V,H") [ SqlColumnNumber = 5 ];

/// 麻醉插管工具
Property CatheterTool As %String(DISPLAYLIST = ",Visible,Hidden", VALUELIST = ",V,H") [ SqlColumnNumber = 6 ];

/// 麻醉置管方向
Property CatheterDirection As %String(DISPLAYLIST = ",Visible,Hidden", VALUELIST = ",V,H") [ SqlColumnNumber = 7 ];

/// 麻醉穿刺间隙
Property PunctureSpace As %String(DISPLAYLIST = ",Visible,Hidden", VALUELIST = ",V,H") [ SqlColumnNumber = 8 ];

/// 麻醉定位方法
Property PositionMethod As %String(DISPLAYLIST = ",Visible,Hidden", VALUELIST = ",V,H") [ SqlColumnNumber = 9 ];

/// 麻醉置管深度
Property CatheterDepth As %String(DISPLAYLIST = ",Visible,Hidden", VALUELIST = ",V,H") [ SqlColumnNumber = 10 ];

/// 神经阻滞入路
Property NerveBlockSite As %String(DISPLAYLIST = ",Visible,Hidden", VALUELIST = ",V,H") [ SqlColumnNumber = 11 ];

/// 麻醉方法索引
Index IAnaMethod On AnaMethod;

Storage Default
{
<Data name="AnaMethodPermissionDefaultData">
<Value name="1">
<Value>AnaMethod</Value>
</Value>
<Value name="2">
<Value>Catheter</Value>
</Value>
<Value name="3">
<Value>CatheterType</Value>
</Value>
<Value name="4">
<Value>CatheterPath</Value>
</Value>
<Value name="5">
<Value>CatheterTool</Value>
</Value>
<Value name="6">
<Value>CatheterDirection</Value>
</Value>
<Value name="7">
<Value>PunctureSpace</Value>
</Value>
<Value name="8">
<Value>PositionMethod</Value>
</Value>
<Value name="9">
<Value>CatheterDepth</Value>
</Value>
<Value name="10">
<Value>NerveBlockSite</Value>
</Value>
</Data>
<DataLocation>^CT.AN.AnaMethodPermissionD</DataLocation>
<DefaultData>AnaMethodPermissionDefaultData</DefaultData>
<IdLocation>^CT.AN.AnaMethodPermissionD</IdLocation>
<IndexLocation>^CT.AN.AnaMethodPermissionI</IndexLocation>
<StreamLocation>^CT.AN.AnaMethodPermissionS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
