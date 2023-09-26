Class User.DHCANOPOrgan Extends %Persistent [ Owner = {_PUBLIC}, SqlTableName = DHC_AN_OPOrgan ]
{

Property ArrangeId As DHCANOPArrange [ Required ];

Property Type As %String [ SqlColumnNumber = 2 ];

Property DataDate As %Date;

Property DataTime As %Time;

Property UpdateDate As %Date;

Property UpdateTime As %Time;

// 口

Property Mouth As %String;

// 口(其他)

Property MouthOther As %String;

// 牙齿

Property Tooth As %String;

// 舌头

Property Tongue As %String;

// 下巴

Property Jaw As %String;

// 咽

Property Pharynx As %String;

// 肺

Property Lung As %String;

// 神经

Property Nerve As %String;

// 肝脏

Property Liver As %String;

// 脾

Property Spleen As %String;

// 扁桃体

Property TonsilHyper As %String;

// 扁桃体(其他)

Property TonsilHyperOther As %String;

// 上肢

Property UpperLimb As %String;

// 下肢

Property LowerLimb As %String;

// 脊柱

Property Spine As %String;

// 脖子

Property Neck As %String;

// 脖子(其他)

Property NeckOther As %String;

// 皮肤

Property Skin As %String;

// 皮肤(其他)

Property SkinOther As %String;

// 鼻子

Property Nose As %String;

// 鼻子(其他)

Property NoseOther As %String;

// 肌肉系统

Property MuscularSystem As %String;

// 肌肉系统(肌肉)

Property MuscularSystemOther As %String;

// 外周静脉

Property PeripheralVein As %String;

// 甲状腺

Property Hypothyroid As %String;

// 其他器官

Property OrganOther As %String;

Storage Default
{
<Data name="DHCANOPOrganDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ArrangeId</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>DataDate</Value>
</Value>
<Value name="5">
<Value>DataTime</Value>
</Value>
<Value name="6">
<Value>UpdateDate</Value>
</Value>
<Value name="7">
<Value>UpdateTime</Value>
</Value>
<Value name="8">
<Value>Mouth</Value>
</Value>
<Value name="9">
<Value>MouthOther</Value>
</Value>
<Value name="10">
<Value>Tongue</Value>
</Value>
<Value name="11">
<Value>Jaw</Value>
</Value>
<Value name="12">
<Value>Pharynx</Value>
</Value>
<Value name="13">
<Value>Lung</Value>
</Value>
<Value name="14">
<Value>Nerve</Value>
</Value>
<Value name="15">
<Value>Liver</Value>
</Value>
<Value name="16">
<Value>Spleen</Value>
</Value>
<Value name="17">
<Value>TonsilHyper</Value>
</Value>
<Value name="18">
<Value>TonsilHyperOther</Value>
</Value>
<Value name="19">
<Value>UpperLimb</Value>
</Value>
<Value name="20">
<Value>LowerLimb</Value>
</Value>
<Value name="21">
<Value>Spine</Value>
</Value>
<Value name="22">
<Value>Neck</Value>
</Value>
<Value name="23">
<Value>NeckOther</Value>
</Value>
<Value name="24">
<Value>Skin</Value>
</Value>
<Value name="25">
<Value>SkinOther</Value>
</Value>
<Value name="26">
<Value>Nose</Value>
</Value>
<Value name="27">
<Value>NoseOther</Value>
</Value>
<Value name="28">
<Value>MuscularSystem</Value>
</Value>
<Value name="29">
<Value>MuscularSystemOther</Value>
</Value>
<Value name="30">
<Value>PeripheralVein</Value>
</Value>
<Value name="31">
<Value>Hypothyroid</Value>
</Value>
<Value name="32">
<Value>OrganOther</Value>
</Value>
<Value name="33">
<Value>Tooth</Value>
</Value>
</Data>
<DataLocation>^User.DHCANOPOrganD</DataLocation>
<DefaultData>DHCANOPOrganDefaultData</DefaultData>
<IdLocation>^User.DHCANOPOrganD</IdLocation>
<IndexLocation>^User.DHCANOPOrganI</IndexLocation>
<StreamLocation>^User.DHCANOPOrganS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
