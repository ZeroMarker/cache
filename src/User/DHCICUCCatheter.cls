/// 基础数据-导管
Class User.DHCICUCCatheter Extends %Persistent [ Owner = {_SYSTEM}, SqlRowIdName = RowId, SqlTableName = DHC_ICUC_Catheter ]
{

/// 代码
Property Code As %String [ Required, SqlColumnNumber = 2 ];

/// 描述
Property Description As %String [ Required, SqlColumnNumber = 3 ];

/// 类型
Property Category As User.DHCICUCCatheterCategory [ Required, SqlColumnNumber = 4 ];

/// 默认置入位置
Property DefaultPos As User.DHCICUCCatheterPos [ SqlColumnNumber = 5 ];

/// 关联的记录项
Property RecordItem As User.DHCICUCRecordItem [ SqlColumnNumber = 6 ];

/// 状态
Property Status As %String(DISPLAYLIST = ",启用,禁用", VALUELIST = ",Enable,Disable") [ SqlColumnNumber = 7 ];

Index ICategory On Category;

Index IRecordItem On RecordItem;

Storage Default
{
<Data name="DHCICUCCatheterDefaultData">
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
<Value>Category</Value>
</Value>
<Value name="5">
<Value>DefaultPos</Value>
</Value>
<Value name="6">
<Value>RecordItem</Value>
</Value>
<Value name="7">
<Value>Status</Value>
</Value>
</Data>
<DataLocation>^User.DHCICUCCatheterD</DataLocation>
<DefaultData>DHCICUCCatheterDefaultData</DefaultData>
<IdLocation>^User.DHCICUCCatheterD</IdLocation>
<IndexLocation>^User.DHCICUCCatheterI</IndexLocation>
<StreamLocation>^User.DHCICUCCatheterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
