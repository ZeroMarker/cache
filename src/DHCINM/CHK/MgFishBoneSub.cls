/// Creater:wangpf
/// Descriptions:鱼骨图子表
/// Date:2021-04-13
Class DHCINM.CHK.MgFishBoneSub Extends %Persistent
{

Relationship Parref As DHCINM.CHK.MgFishBone [ Cardinality = parent, Inverse = ChildSub ];

/// 父节点
Property SubParent As DHCINM.CHK.MgFishBoneSub [ SqlColumnNumber = 2, SqlFieldName = SubParent ];

/// 排序
Property SubSort As %String [ SqlColumnNumber = 3, SqlFieldName = SubSort ];

/// 问题描述
Property SubDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 4, SqlFieldName = SubDesc ];

/// 是否要因
Property SubPrimary As %String [ SqlColumnNumber = 5, SqlFieldName = SubPrimary ];

Index Par On SubParent;

Index Sort On (Parref, SubSort);

Storage Default
{
<Data name="MgFishBoneSubDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>SubParent</Value>
</Value>
<Value name="3">
<Value>SubSort</Value>
</Value>
<Value name="4">
<Value>SubDesc</Value>
</Value>
<Value name="5">
<Value>SubPrimary</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgFishBoneSubD</DataLocation>
<DefaultData>MgFishBoneSubDefaultData</DefaultData>
<IdLocation>{%%PARENT}("ChildSub")</IdLocation>
<IndexLocation>^DHCINM.CHK.MgFishBoneSubI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgFishBoneSubS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
