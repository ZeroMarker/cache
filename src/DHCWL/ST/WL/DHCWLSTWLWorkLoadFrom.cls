/// 	Class DHCWL_ST_WL.DHCWLSTWLWorkLoadFrom Extends %Persistent
/// 		^DHCWLWLFromD	^DHCWLWLFromI
Class DHCWL.ST.WL.DHCWLSTWLWorkLoadFrom Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLSTWLWorkLoadFrom ]
{

/// 	统计项目ID
Property WLFStatDr As %String [ SqlColumnNumber = 2, SqlFieldName = WLF_StatDr ];

/// 	就诊类型	
Property WLFDataType As %String [ SqlColumnNumber = 3, SqlFieldName = WLF_DataType ];

/// 	统计口径ID
Property WLFFromType As DHCWL.ST.WL.DHCWLSTWLDataFromType [ SqlColumnNumber = 4, SqlFieldName = WLF_FromType ];

/// 	条目标志	标记是统计项目、条目、明细
Property WLFFlag As %String [ SqlColumnNumber = 5, SqlFieldName = WLF_Flag ];

/// 	维护日期
Property WLFDate As %Date [ SqlColumnNumber = 6, SqlFieldName = WLF_Date ];

/// 	维护人员
Property WLFUser As %String [ SqlColumnNumber = 7, SqlFieldName = WLF_User ];

/// 	其他 
Property WLFOther As %String [ SqlColumnNumber = 8, SqlFieldName = WLF_Other ];

Index StatDr On WLFStatDr;

Index StatDrDataType On (WLFStatDr, WLFDataType);

Index StatDrFlag On (WLFFlag, WLFStatDr);

Index FromType On WLFFromType;

Index FromDataType On (WLFFromType, WLFDataType);

Storage Default
{
<Data name="DHCWLSTWLWorkLoadFromDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>WLFStatDr</Value>
</Value>
<Value name="3">
<Value>WLFDataType</Value>
</Value>
<Value name="4">
<Value>WLFFromType</Value>
</Value>
<Value name="5">
<Value>WLFFlag</Value>
</Value>
<Value name="6">
<Value>WLFDate</Value>
</Value>
<Value name="7">
<Value>WLFUser</Value>
</Value>
<Value name="8">
<Value>WLFOther</Value>
</Value>
</Data>
<DataLocation>^DHCWLWLFromD</DataLocation>
<DefaultData>WLFromDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWLWLFromD</IdLocation>
<IndexLocation>^DHCWLWLFromI</IndexLocation>
<StreamLocation>^DHCWL.ST.WL.DHCWLSTWLWoCE48S</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
