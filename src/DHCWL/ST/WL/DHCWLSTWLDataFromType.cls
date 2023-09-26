/// 	DHCWL_ST_WL.DHCWLSTWLDataFromType  d ##class(DHCWL.ST.WL.DHCWLSTWLDataFromType).%BuildIndices()
/// 		^DHCWLDFTypeD;^DHCWLDFTypeI
Class DHCWL.ST.WL.DHCWLSTWLDataFromType Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLSTWLDataFromType ]
{

/// 	统计口径代码
Property DateFromTypeCode As %String [ SqlColumnNumber = 2, SqlFieldName = DFT_Code ];

/// 	统计口径描述	
Property DateFromTypeDesc As %String [ SqlColumnNumber = 3, SqlFieldName = DFT_Desc ];

/// 	统计口径执行代码
Property DateFromTypeExCode As %String [ SqlColumnNumber = 4, SqlFieldName = DFT_ExCode ];

/// 	统计口径关联指标代码
Property DateFromTypeKPICode As %String [ SqlColumnNumber = 5, SqlFieldName = DFT_KPICode ];

/// 	其他
Property DateFromTypeOther As %String [ SqlColumnNumber = 6, SqlFieldName = DFT_Other ];

Index DFTCode On DateFromTypeCode;

Index DFTDesc On DateFromTypeDesc;

Storage Default
{
<Data name="DHCWLSTWLDataFromTypeDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>DateFromTypeCode</Value>
</Value>
<Value name="3">
<Value>DateFromTypeDesc</Value>
</Value>
<Value name="4">
<Value>DateFromTypeExCode</Value>
</Value>
<Value name="5">
<Value>DateFromTypeKPICode</Value>
</Value>
<Value name="6">
<Value>DateFromTypeOther</Value>
</Value>
</Data>
<DataLocation>^DHCWLDFTypeD</DataLocation>
<DefaultData>DHCWLSTWLDataFromTypeDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWLDFTypeD</IdLocation>
<IndexLocation>^DHCWLDFTypeI</IndexLocation>
<StreamLocation>^DHCWL.ST.WL.DHCWLSTWLDa7FCAS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
