Class DHCEPRFS.META.QRCodeInfo Extends %Persistent [ ClassType = persistent, ProcedureBlock ]
{

/// 项目名称
Property Name As %String(MAXLEN = 100, TRUNCATE = 1) [ SqlColumnNumber = 2 ];

/// 项目描述
Property Description As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 3 ];

/// 项目所属类名
Property ClassName As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 4 ];

/// 项目所属类的属性名
Property ClassProperty As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 5 ];

/// 项目所属类的属性数据类型
Property ClassPropertyType As %String(MAXLEN = 20, TRUNCATE = 1) [ SqlColumnNumber = 6 ];

/// 启用
Property Enable As %String(MAXLEN = 10, TRUNCATE = 1) [ SqlColumnNumber = 7 ];

/// 顺序号
Property Sequence As %Integer [ SqlColumnNumber = 8 ];

/// 用户自定义信息
Property CustemNoteInfo As %String(MAXLEN = 500, TRUNCATE = 1) [ SqlColumnNumber = 9 ];

Index IdxEnableSequence On (Enable, Sequence);

Index IdxSequence On Sequence;

Index IdxClassName On (ClassName, ClassProperty);

Storage Default
{
<Data name="QRCodeInfoDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ClassName</Value>
</Value>
<Value name="3">
<Value>ClassProperty</Value>
</Value>
<Value name="4">
<Value>Description</Value>
</Value>
<Value name="5">
<Value>Name</Value>
</Value>
<Value name="6">
<Value>Sequence</Value>
</Value>
<Value name="7">
<Value>Enable</Value>
</Value>
<Value name="8">
<Value>ClassPropertyType</Value>
</Value>
<Value name="9">
<Value>CustemNoteInfo</Value>
</Value>
</Data>
<DataLocation>^DHCEPRFS.META.QRCodeInfoD</DataLocation>
<DefaultData>QRCodeInfoDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCEPRFS.META.QRCodeInfoD</IdLocation>
<IndexLocation>^DHCEPRFS.META.QRCodeInfoI</IndexLocation>
<StreamLocation>^DHCEPRFS.META.QRCodeInfoS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
