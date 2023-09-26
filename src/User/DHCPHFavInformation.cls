/// Desc:       收藏夹病历信息
/// Creator:    Candy
/// CreateDate: 2014-11-18
Class User.DHCPHFavInformation Extends (%Persistent, %XML.Adaptor, User.Abstract)
{

/// 患者NO
Property PatientNo As %String;

/// 患者姓名
Property PatientName As %String;

/// 患者性别
Property PatientGender As %String;

/// 患者出生日期
Property PatientBOD As %Date;

/// 备注
Property Memo As %String(MAXLEN = 32767, TRUNCATE = 1);

/// 收藏目录
Property CatalogID As %String;

/// 类型
Property Type As %String;

/// 次序
Property Sequence As %Integer;

/// 病例收藏用户ID
Property FavUserID As %Integer;

Relationship FavInformation As User.DHCPHFavRecord [ Cardinality = children, Inverse = ParRef ];

Index IdxMain On (FavUserID, PatientNo);

Index IdxUserCatalogSequence On (FavUserID, CatalogID, Sequence);

Storage Default
{
<Data name="FavInformationDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>PatientNo</Value>
</Value>
<Value name="3">
<Value>PatientName</Value>
</Value>
<Value name="4">
<Value>PatientGender</Value>
</Value>
<Value name="5">
<Value>PatientBOD</Value>
</Value>
<Value name="6">
<Value>Memo</Value>
</Value>
<Value name="7">
<Value>CatalogID</Value>
</Value>
<Value name="8">
<Value>Type</Value>
</Value>
<Value name="9">
<Value>Sequence</Value>
</Value>
<Value name="10">
<Value>FavUserID</Value>
</Value>
</Data>
<DataLocation>^DHCPHF.FavInformationD</DataLocation>
<DefaultData>FavInformationDefaultData</DefaultData>
<IdLocation>^DHCPHF.FavInformationD</IdLocation>
<IndexLocation>^DHCPHF.FavInformationI</IndexLocation>
<StreamLocation>^DHCPHF.FavInformationS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
