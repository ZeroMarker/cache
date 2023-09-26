/// 名称: DHCMA.CPW.SD.QCParameter
/// 描述: 单病种质控项目绑定参数
/// 编写者：fcz
/// 编写日期: 2018-09-10
Class DHCMA.CPW.SD.QCParameter Extends %Persistent [ ClassType = persistent, Not ProcedureBlock ]
{

/// 参数代码
Property BTCode As %String(MAXLEN = 50, TRUNCATE = 1) [ Required ];

/// 参数说明
Property BTDesc As %String(MAXLEN = 500, TRUNCATE = 1);

/// 参数类型
Property BTTypeDr As DHCMA.Util.BT.Dictionary;

/// 参数值
Property BTValue As %String(MAXLEN = 50, TRUNCATE = 1);

Index BTCodeIndex On BTCode [ Unique ];

Storage Default
{
<Data name="QCParameterDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>BTCode</Value>
</Value>
<Value name="3">
<Value>BTDesc</Value>
</Value>
<Value name="4">
<Value>BTTypeDr</Value>
</Value>
<Value name="5">
<Value>BTValue</Value>
</Value>
</Data>
<DataLocation>^DHCMA.CPW.SD.QCParameterD</DataLocation>
<DefaultData>QCParameterDefaultData</DefaultData>
<IdLocation>^DHCMA.CPW.SD.QCParameterD</IdLocation>
<IndexLocation>^DHCMA.CPW.SD.QCParameterI</IndexLocation>
<StreamLocation>^DHCMA.CPW.SD.QCParameterS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
