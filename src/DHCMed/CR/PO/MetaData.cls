/// 名称: DHCMed.CR.PO.MetaData
/// 描述: 自定义表单元素
/// 编写者：wuqk
/// 编写日期: 2012-11-22
Class DHCMed.CR.PO.MetaData Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 关联表单的ID
Property FormID As %Integer;

/// 表单中文名字
Property ColCName As %String;

/// 表单英文文名字
Property ColEName As %String;

/// 数据类型
Property ColDataType As %String;

/// 数据长度
Property ColLength As %String;

Index IndexUnique On (FormID, ColEName) [ Unique ];

Storage Default
{
<Data name="MetaDataDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FormID</Value>
</Value>
<Value name="3">
<Value>ColCName</Value>
</Value>
<Value name="4">
<Value>ColEName</Value>
</Value>
<Value name="5">
<Value>ColDataType</Value>
</Value>
<Value name="6">
<Value>ColLength</Value>
</Value>
</Data>
<DataLocation>^DHCMed.CR.PO.MetaDataD</DataLocation>
<DefaultData>MetaDataDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.CR.PO.MetaDataD</IdLocation>
<IndexLocation>^DHCMed.CR.PO.MetaDataI</IndexLocation>
<StreamLocation>^DHCMed.CR.PO.MetaDataS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
