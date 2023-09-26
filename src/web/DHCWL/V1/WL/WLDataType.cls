Class web.DHCWL.V1.WL.WLDataType Extends %Persistent [ ClassType = persistent ]
{

/// 	统计口径代码
Property DateTypeCode As %String [ Required, SqlColumnNumber = 2 ];

/// 	统计口径描述	
Property DateTypeDesc As %String [ Required, SqlColumnNumber = 3 ];

/// 	统计口径执行代码
Property DateTypeExCode As %String [ SqlColumnNumber = 4 ];

/// 	统计口径关联指标代码
Property DateTypeKPICode As %String [ SqlColumnNumber = 5 ];

/// 	其他
Property DateTypeOther As %String [ SqlColumnNumber = 6 ];

Index DFTCode On DateTypeCode;

Index DFTDesc On DateTypeDesc;

Storage Default
{
<Data name="WLDataTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateTypeCode</Value>
</Value>
<Value name="3">
<Value>DateTypeDesc</Value>
</Value>
<Value name="4">
<Value>DateTypeExCode</Value>
</Value>
<Value name="5">
<Value>DateTypeKPICode</Value>
</Value>
<Value name="6">
<Value>DateTypeOther</Value>
</Value>
</Data>
<DataLocation>^web.DHCWL.V1.WL.WLDataTypeD</DataLocation>
<DefaultData>WLDataTypeDefaultData</DefaultData>
<IdLocation>^web.DHCWL.V1.WL.WLDataTypeD</IdLocation>
<IndexLocation>^web.DHCWL.V1.WL.WLDataTypeI</IndexLocation>
<StreamLocation>^web.DHCWL.V1.WL.WLDataTypeS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
