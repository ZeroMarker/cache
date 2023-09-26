Class DHCEPRFS.META.B.Department Extends %Persistent
{

/// 名称
Property Name As %String(TRUNCATE = 1);

/// 科室代码
Property Code As %String(TRUNCATE = 1);

/// 科室描述
Property Description As %String(TRUNCATE = 1);

/// 启用起始日期
Property DateActiveFrom As %Date;

/// 启用终止日期
Property DateActiveTo As %Date;

/// 是否有效判别("Y/N")
Property IsActive As %String(TRUNCATE = 1);

/// 拼音
Property AliasName As %String(TRUNCATE = 1);

/// 拼音首字母
Property AliasNameInitial As %String(TRUNCATE = 1);

/// 创建日期
Property CreateDate As %Date;

/// 创建时间
Property CreateTime As %Time;

/// 最后修改日期
Property LastModifyDate As %Date;

/// 最后修改时间
Property LastModifyTime As %Time;

/// 来源（默认DHC）
Property Source As %String(TRUNCATE = 1);

/// 序号
Property OrderNum As %Integer;

/// 科室所属院区ID (5.3.1 ID)，无所属院区填空
Property HospitalAreaID As %String(TRUNCATE = 1);

/// 医技科室类别ID (5.3.8 ID) 非医技科室填空
Property TechnologyID As %String(TRUNCATE = 1);

/// 急诊科室判别("Y/N")
Property EmergencyFlag As %String(TRUNCATE = 1);

/// 观察室判别("Y/N")
Property ObserveFlag As %String(TRUNCATE = 1);

/// 中西医判别("Y/N")
Property ChineseFlag As %String(TRUNCATE = 1);

/// 科室HIS中的rowID
Property DepartmentID As %String(TRUNCATE = 1);

/// 科室所属类型
Property CTLocType As %String(TRUNCATE = 1);

Index IdxCTLocType On CTLocType;

Index IdxAliasName On AliasName;

Index IdxAliasNameInitial On AliasNameInitial;

Storage Default
{
<Data name="DepartmentDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>DateActiveFrom</Value>
</Value>
<Value name="6">
<Value>DateActiveTo</Value>
</Value>
<Value name="7">
<Value>IsActive</Value>
</Value>
<Value name="8">
<Value>AliasName</Value>
</Value>
<Value name="9">
<Value>AliasNameInitial</Value>
</Value>
<Value name="10">
<Value>CreateDate</Value>
</Value>
<Value name="11">
<Value>CreateTime</Value>
</Value>
<Value name="12">
<Value>LastModifyDate</Value>
</Value>
<Value name="13">
<Value>LastModifyTime</Value>
</Value>
<Value name="14">
<Value>Source</Value>
</Value>
<Value name="15">
<Value>OrderNum</Value>
</Value>
<Value name="16">
<Value>HospitalAreaID</Value>
</Value>
<Value name="17">
<Value>TechnologyID</Value>
</Value>
<Value name="18">
<Value>EmergencyFlag</Value>
</Value>
<Value name="19">
<Value>ObserveFlag</Value>
</Value>
<Value name="20">
<Value>ChineseFlag</Value>
</Value>
<Value name="21">
<Value>DepartmentID</Value>
</Value>
<Value name="22">
<Value>CTLocType</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.B.DepartmentD</DataLocation>
<DefaultData>DepartmentDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.META.B.DepartmentD</IdLocation>
<IndexLocation>^DHCEPRFS.META.B.DepartmentI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.B.DepartmentS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
