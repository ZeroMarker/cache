/// Functgion: 多院区业务  配置分类 数据明细
/// CreateDate:2021-07-02
/// Creator:   sunfengchao
Class User.BDPHospSerConfigCategory Extends %Persistent [ SqlTableName = BDP_HospSerConfigCategory ]
{

Relationship ServiceConfigParRef As User.BDPHospitalServiceConfig [ Cardinality = parent, Inverse = ChildConfigCategory ];

/// 项目指向id
Property BDPMHOSPCateReference As %String [ SqlColumnNumber = 2, SqlFieldName = BDPMHOSPCate_Reference ];

Index ReferIdx On (ServiceConfigParRef, BDPMHOSPCateReference As Exact);

Storage Default
{
<Data name="BDPHospSerConfigCategoryDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BDPMHOSPCateReference</Value>
</Value>
</Data>
<DataLocation>^User.BDPHospSerConfigCategoryD</DataLocation>
<DefaultData>BDPHospSerConfigCategoryDefaultData</DefaultData>
<IdLocation>^User.BDPHospSerConfigCategoryD</IdLocation>
<IndexLocation>^User.BDPHospSerConfigCategoryI</IndexLocation>
<StreamLocation>^User.BDPHospSerConfigCategoryS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
