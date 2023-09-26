Class DHCEPRFS.META.B.Province Extends %Persistent
{

/// 省份
/// 编码
Property Code As %String(TRUNCATE = 1);

/// 名称
Property Name As %String(TRUNCATE = 1);

/// 拼音
Property AliasName As %String(TRUNCATE = 1);

/// 拼音首字母
Property AliasNameInitial As %String(TRUNCATE = 1);

/// 描述
Property Description As %String(TRUNCATE = 1);

/// 来源（默认DHC）
Property Source As %String(TRUNCATE = 1);

/// 序号
Property OrderNum As %Integer;

/// 是否启用("Y/N")
Property IsActive As %String;

/// 启用起始日期
Property DateActiveFrom As %Date;

/// 启用终止日期
Property DateActiveTo As %Date;

/// 省份所属国籍ID 
Property NationalID As %String;

/// 省份所属区域ID
Property AreaID As %String;

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最后修改日期
Property LastModifyDate As %Date;

/// 最后修改时间
Property LastModifyTime As %Time;

Index IdxProvinceUnique On Code [ Unique ];

Storage Default
{
<Data name="ProvinceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Name</Value>
</Value>
<Value name="4">
<Value>Order</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>Source</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>OrderNum</Value>
</Value>
<Value name="9">
<Value>ActiveDateFrom</Value>
</Value>
<Value name="10">
<Value>ActiveDateTo</Value>
</Value>
<Value name="11">
<Value>DateActiveFrom</Value>
</Value>
<Value name="12">
<Value>DateActiveTo</Value>
</Value>
<Value name="13">
<Value>NationalID</Value>
</Value>
<Value name="14">
<Value>AreaID</Value>
</Value>
<Value name="15">
<Value>CreateDate</Value>
</Value>
<Value name="16">
<Value>CreateTime</Value>
</Value>
<Value name="17">
<Value>LastModifyDate</Value>
</Value>
<Value name="18">
<Value>LastModifyTime</Value>
</Value>
<Value name="19">
<Value>AliasName</Value>
</Value>
<Value name="20">
<Value>AliasNameInitial</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.B.ProvinceD</DataLocation>
<DefaultData>ProvinceDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.B.ProvinceD</IdLocation>
<IndexLocation>^DHCEPRFS.META.B.ProvinceI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.B.ProvinceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
