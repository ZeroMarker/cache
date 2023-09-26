/// Creater:wangpf
/// Descriptions:鱼骨图父表
/// Date:2021-04-13
Class DHCINM.CHK.MgFishBone Extends %Persistent
{

Relationship ChildSub As DHCINM.CHK.MgFishBoneSub [ Cardinality = children, Inverse = Parref ];

/// 检查结果
Property Result As DHCINM.CHK.MgCheckResult [ SqlColumnNumber = 2, SqlFieldName = Result ];

/// 问题描述
Property QuesDesc As %String(MAXLEN = 1000) [ SqlColumnNumber = 3, SqlFieldName = QuesDesc ];

Index Result On Result;

Storage Default
{
<Data name="MgFishBoneDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Result</Value>
</Value>
<Value name="3">
<Value>QuesDesc</Value>
</Value>
</Data>
<DataLocation>^DHCINM.CHK.MgFishBoneD</DataLocation>
<DefaultData>MgFishBoneDefaultData</DefaultData>
<IdLocation>^DHCINM.CHK.MgFishBoneD</IdLocation>
<IndexLocation>^DHCINM.CHK.MgFishBoneI</IndexLocation>
<StreamLocation>^DHCINM.CHK.MgFishBoneS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
