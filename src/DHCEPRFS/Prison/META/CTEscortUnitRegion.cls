/// 监区相关信息表
/// Creator：liushuang
/// date:2018-01-23
Class DHCEPRFS.Prison.META.CTEscortUnitRegion Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 监区代码
Property Code As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 监区描述
Property Description As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 创建日期
Property CreateDate As %Date [ SqlColumnNumber = 4 ];

/// 创建时间
Property CreateTime As %Time [ SqlColumnNumber = 5 ];

/// 最后修改日期
Property LastModifyDate As %Date [ SqlColumnNumber = 6 ];

/// 最后修改时间
Property LastModifyTime As %Time [ SqlColumnNumber = 7 ];

/// 起始日期
Property DateActiveFrom As %Date [ SqlColumnNumber = 8 ];

/// 结束日期
Property DateActiveTo As %Date [ SqlColumnNumber = 9 ];

/// 是否有效判别("Y/N")
Property IsActive As %String(TRUNCATE = 1) [ SqlColumnNumber = 10 ];

/// 来源（默认DHC）
Property Source As %String(TRUNCATE = 1) [ SqlColumnNumber = 11 ];

/// 序号
Property OrderNum As %Integer [ SqlColumnNumber = 12 ];

/// 监区父表是监狱表
Relationship TheCTEscortUnit As DHCEPRFS.Prison.META.CTEscortUnit [ Cardinality = parent, Inverse = TheCTEscortUnitRegion ];

Storage Default
{
<Data name="CTEscortUnitRegionDefaultData">
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
<Value>CreateDate</Value>
</Value>
<Value name="5">
<Value>CreateTime</Value>
</Value>
<Value name="6">
<Value>LastModifyDate</Value>
</Value>
<Value name="7">
<Value>LastModifyTime</Value>
</Value>
<Value name="8">
<Value>DateActiveFrom</Value>
</Value>
<Value name="9">
<Value>DateActiveTo</Value>
</Value>
<Value name="10">
<Value>IsActive</Value>
</Value>
<Value name="11">
<Value>Source</Value>
</Value>
<Value name="12">
<Value>OrderNum</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.Prison.META.CTEURD</DataLocation>
<DefaultData>CTEscortUnitRegionDefaultData</DefaultData>
<IdLocation>^DHCEPRFS.Prison.META.CTEURD</IdLocation>
<IndexLocation>^DHCEPRFS.Prison.META.CTEURI</IndexLocation>
<StreamLocation>^DHCEPRFS.Prison.META.CTEURS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
