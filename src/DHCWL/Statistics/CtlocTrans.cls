/// DHCWL_Statistics.CtlocTrans  科室对照 d ##class(DHCWL.Statistics.CtlocTrans).%BuildIndices()
Class DHCWL.Statistics.CtlocTrans Extends %Persistent [ SqlTableName = CtlocTrans ]
{

/// his科室Id
Property CtlocTransRowID As %Integer [ SqlColumnNumber = 2, SqlFieldName = CtlocTrans_RowID ];

/// his科室代码
Property CtlocTransCode As %String [ SqlColumnNumber = 3, SqlFieldName = CtlocTrans_Code ];

/// his科室描述
Property CtlocTransDesc As %String [ SqlColumnNumber = 4, SqlFieldName = CtlocTrans_Desc ];

/// 上报科室代码
Property CtlocTransSbCode As %String [ SqlColumnNumber = 5, SqlFieldName = CtlocTrans_SbCode ];

/// 上报科室描述
Property CtlocTransSbDesc As %String [ SqlColumnNumber = 6, SqlFieldName = CtlocTrans_SbDesc ];

/// 统计科室代码
Property CtlocTransTjCode As %String [ SqlColumnNumber = 7, SqlFieldName = CtlocTrans_TjCode ];

/// 统计科室描述
Property CtlocTransTjDesc As %String [ SqlColumnNumber = 8, SqlFieldName = CtlocTrans_TjDesc ];

/// 科室类型
Property CtlocTransType As %String [ SqlColumnNumber = 9, SqlFieldName = CtlocTrans_Type ];

Index CtlocTransRowID On CtlocTransRowID As Exact;

Index CtlocTransCode On CtlocTransCode As Exact;

Index CtlocTransDesc On CtlocTransDesc As Exact;

Index CtlocTransSbCode On CtlocTransSbCode As Exact;

Index CtlocTransSbDesc On CtlocTransSbDesc As Exact;

Index CtlocTransTjCode On CtlocTransTjCode As Exact;

Index CtlocTransTjDesc On CtlocTransTjDesc As Exact;

Index CtlocTransType On CtlocTransType As Exact;

Storage Default
{
<Data name="CtlocTransDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CtlocTransRowID</Value>
</Value>
<Value name="3">
<Value>CtlocTransCode</Value>
</Value>
<Value name="4">
<Value>CtlocTransDesc</Value>
</Value>
<Value name="5">
<Value>CtlocTransSbCode</Value>
</Value>
<Value name="6">
<Value>CtlocTransSbDesc</Value>
</Value>
<Value name="7">
<Value>CtlocTransTjCode</Value>
</Value>
<Value name="8">
<Value>CtlocTransTjDesc</Value>
</Value>
<Value name="9">
<Value>CtlocTransType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.Statistics.CtlocTransD</DataLocation>
<DefaultData>CtlocTransDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.Statistics.CtlocTransD</IdLocation>
<IndexLocation>^DHCWL.Statistics.CtlocTransI</IndexLocation>
<StreamLocation>^DHCWL.Statistics.CtlocTransS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
