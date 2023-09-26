/// creator:lulin
/// createdate:2019-12-04
/// description:模板类
Class DHCNS.Config.NsModel Extends %Persistent
{

Relationship ChildSub As DHCNS.Config.NsModelSub [ Cardinality = children, Inverse = Parref ];

/// 模板类别
Property ModelType As DHCNS.Config.NsTypeSet [ SqlColumnNumber = 2, SqlFieldName = ModelType ];

/// 模板用途[E:填报；C:统计]
Property ModelUse As %String [ SqlColumnNumber = 3, SqlFieldName = ModelUse ];

/// 频率-D:日、W:周、M:月、Q:季、H:半年、Y:年
Property Rate As %String [ SqlColumnNumber = 4, SqlFieldName = Rate ];

/// 模板名称
Property ModelDesc As %String [ SqlColumnNumber = 5, SqlFieldName = ModelDesc ];

/// 适用范围类型
Property UseType As %String [ SqlColumnNumber = 6, SqlFieldName = UseType ];

/// 使用范围
Property UseLimit As list Of %String [ SqlColumnNumber = 7, SqlFieldName = UseLimit ];

/// 启用日期
Property StDate As %Date [ SqlColumnNumber = 8, SqlFieldName = StDate ];

/// 停用日期
Property EndDate As %Date [ SqlColumnNumber = 9, SqlFieldName = EndDate ];

/// 是否分类Y:是，N/""：否
Property IsClassify As %String [ SqlColumnNumber = 10, SqlFieldName = IsClassify ];

Storage Default
{
<Data name="NsModelDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ModelType</Value>
</Value>
<Value name="3">
<Value>ModelUse</Value>
</Value>
<Value name="4">
<Value>Rate</Value>
</Value>
<Value name="5">
<Value>ModelDesc</Value>
</Value>
<Value name="6">
<Value>UseType</Value>
</Value>
<Value name="7">
<Value>UseLimit</Value>
</Value>
<Value name="8">
<Value>StDate</Value>
</Value>
<Value name="9">
<Value>EndDate</Value>
</Value>
<Value name="10">
<Value>IsClassify</Value>
</Value>
</Data>
<DataLocation>^DHCNS.Config.NsModelD</DataLocation>
<DefaultData>NsModelDefaultData</DefaultData>
<IdLocation>^DHCNS.Config.NsModelD</IdLocation>
<IndexLocation>^DHCNS.Config.NsModelI</IndexLocation>
<StreamLocation>^DHCNS.Config.NsModelS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
