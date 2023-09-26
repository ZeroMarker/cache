/// 麻醉导管
Class CIS.AN.AnaestCatheter Extends %Persistent [ Final, Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = AnaestCatheter ]
{

/// 麻醉信息
Property Anaesthesia As CIS.AN.Anaesthesia [ Required, SqlColumnNumber = 2 ];

/// 导管分类
Property Catheter As CT.AN.Catheter [ SqlColumnNumber = 3 ];

/// 导管型号
Property CatheterType As CT.AN.CatheterType [ SqlColumnNumber = 4 ];

/// 置管深度
Property CatheterDepth As CT.AN.CatheterDepth [ SqlColumnNumber = 5 ];

/// 插管途径(径路)
Property CatheterPath As CT.AN.CatheterPath [ SqlColumnNumber = 6 ];

/// 插管工具
Property CatheterTool As CT.AN.CatheterTool [ SqlColumnNumber = 7 ];

/// 置管方向
Property CatheterDirection As CT.AN.CatheterDirection [ SqlColumnNumber = 8 ];

/// 穿刺间隙
Property PunctureSpace As CT.AN.PunctureSpace [ SqlColumnNumber = 9 ];

/// 定位方法
Property PositionMethod As CT.AN.PositionMethod [ SqlColumnNumber = 10 ];

/// 麻醉方法
Property AnaMethod As %String [ SqlColumnNumber = 11 ];

/// 神经阻滞入路
Property NerveBlockSite As CT.AN.NerveBlockSite [ SqlColumnNumber = 12 ];

/// 自动生成时麻醉方法绑定的收费记录明细
Property ChargeAnaMethodDetail As CIS.AN.ChargeDetail [ SqlColumnNumber = 13 ];

/// 自动生成时导管绑定的收费记录明细
Property ChargeCatheterDetail As CIS.AN.ChargeDetail [ SqlColumnNumber = 14 ];

/// 麻醉信息索引
Index IAna On Anaesthesia;

/// 麻醉信息外键索引
ForeignKey FKAnaesthesia(Anaesthesia) References CIS.AN.Anaesthesia() [ OnDelete = cascade ];

Storage Default
{
<Data name="AnaestCatheterDefaultData">
<Value name="1">
<Value>Anaesthesia</Value>
</Value>
<Value name="2">
<Value>Catheter</Value>
</Value>
<Value name="3">
<Value>CatheterType</Value>
</Value>
<Value name="4">
<Value>CatheterDepth</Value>
</Value>
<Value name="5">
<Value>CatheterPath</Value>
</Value>
<Value name="6">
<Value>CatheterTool</Value>
</Value>
<Value name="7">
<Value>CatheterDirection</Value>
</Value>
<Value name="8">
<Value>PunctureSpace</Value>
</Value>
<Value name="9">
<Value>PositionMethod</Value>
</Value>
<Value name="10">
<Value>AnaMethod</Value>
</Value>
<Value name="11">
<Value>NerveBlockSite</Value>
</Value>
<Value name="12">
<Value>ChargeDetail</Value>
</Value>
<Value name="13">
<Value>ChargeAnaMethodDetail</Value>
</Value>
<Value name="14">
<Value>ChargeCatheterDetail</Value>
</Value>
</Data>
<DataLocation>^CIS.AN.AnaestCatheterD</DataLocation>
<DefaultData>AnaestCatheterDefaultData</DefaultData>
<IdLocation>^CIS.AN.AnaestCatheterD</IdLocation>
<IndexLocation>^CIS.AN.AnaestCatheterI</IndexLocation>
<StreamLocation>^CIS.AN.AnaestCatheterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
