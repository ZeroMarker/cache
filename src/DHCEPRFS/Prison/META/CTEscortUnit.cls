/// 监狱相关信息表
/// Creator：liushuang
/// date:2018-01-23
Class DHCEPRFS.Prison.META.CTEscortUnit Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 监狱代码
Property Code As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 监狱描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 拼音
Property AliasName As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 联系方式
Property Contect As %String(TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 负责人(监狱长)
Property Leader As %String(TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 7 ];

/// 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 8 ];

/// 最后修改日期
Property LastModifyDate As %Date [ SqlColumnNumber = 9 ];

/// 最后修改时间
Property LastModifyTime As %Time [ SqlColumnNumber = 10 ];

/// 起始日期
Property DateActiveFrom As %Date [ SqlColumnNumber = 11 ];

/// 结束日期
Property DateActiveTo As %Date [ SqlColumnNumber = 12 ];

/// 是否有效判别("Y/N")
Property IsActive As %String(TRUNCATE = 1) [ SqlColumnNumber = 13 ];

/// 来源（默认DHC）
Property Source As %String(TRUNCATE = 1) [ SqlColumnNumber = 14 ];

/// 序号
Property OrderNum As %Integer [ SqlColumnNumber = 15 ];

/// 监狱表的子表监区表
Relationship TheCTEscortUnitRegion As DHCEPRFS.Prison.META.CTEscortUnitRegion [ Cardinality = children, Inverse = TheCTEscortUnit ];

Index IdxCode On Code;

Storage Default
{
<Data name="CTEscortUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Code</Value>
</Value>
<Value name="3">
<Value>Description</Value>
</Value>
<Value name="4">
<Value>AliasName</Value>
</Value>
<Value name="5">
<Value>Contect</Value>
</Value>
<Value name="6">
<Value>Leader</Value>
</Value>
<Value name="7">
<Value>CreateDate</Value>
</Value>
<Value name="8">
<Value>CreateTime</Value>
</Value>
<Value name="9">
<Value>LastModifyDate</Value>
</Value>
<Value name="10">
<Value>LastModifyTime</Value>
</Value>
<Value name="11">
<Value>DateActiveFrom</Value>
</Value>
<Value name="12">
<Value>DateActiveTo</Value>
</Value>
<Value name="13">
<Value>IsActive</Value>
</Value>
<Value name="14">
<Value>Source</Value>
</Value>
<Value name="15">
<Value>OrderNum</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.Prison.META.CTEUD</DataLocation>
<DefaultData>CTEscortUnitDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.Prison.META.CTEUD</IdLocation>
<IndexLocation>^DHCEPRFS.Prison.META.CTEUI</IndexLocation>
<StreamLocation>^DHCEPRFS.Prison.META.CTEUS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
