/// Desc:可查询字段
/// Creator:Candy
Class DHCEPRFS.META.QueryFields Extends (%Persistent, %XML.Adaptor) [ ClassType = persistent, ProcedureBlock ]
{

/// 字段名称 (命名要求和DHCEPRFS.BL.BLQueryClassMethod.cls的方法名称一样)
Property FieldName As %String(TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 字段描述
Property FieldDesc As %String(TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 字段类型
Property FieldType As %String(TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 可用接口 格式: 类名称:query方法|参数  取此字典值的方法
Property FieldInterface As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 查询类别ID  DHCEPRFS.META.QueryCategory.cls 的ID
Property CategoryID As %Integer [ SqlColumnNumber = 6 ];

/// 次序号
Property Sequence As %Integer [ SqlColumnNumber = 7 ];

/// 是否有效
Property IsActive As %String(TRUNCATE = 1) [ SqlColumnNumber = 8 ];

Index IdxSequence On (CategoryID, Sequence);

Index IdxCategoryID On CategoryID;

Storage Default
{
<Data name="QueryFieldsDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CategoryID</Value>
</Value>
<Value name="3">
<Value>FieldDesc</Value>
</Value>
<Value name="4">
<Value>FieldInterface</Value>
</Value>
<Value name="5">
<Value>FieldName</Value>
</Value>
<Value name="6">
<Value>FieldType</Value>
</Value>
<Value name="7">
<Value>Sequence</Value>
</Value>
<Value name="8">
<Value>IsActive</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QueryFieldsD</DataLocation>
<DefaultData>QueryFieldsDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QueryFieldsD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QueryFieldsI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QueryFieldsS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
