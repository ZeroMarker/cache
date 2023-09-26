/// DHCWL_MRIPDayTask.OrdItm   d ##class(DHCWL.MRIPDayTask.OrdItm).%BuildIndices()
Class DHCWL.MRIPDayTask.OrdItm Extends %Persistent [ ClassType = persistent, SqlRowIdName = OrdItm_RowID, SqlTableName = OrdItm ]
{

/// 编码
Property OrdItmCode As %String(COLLATION = "Exact") [ SqlColumnNumber = 2, SqlFieldName = OrdItm_Code ];

/// 描述
Property OrdItmDesc As %String [ SqlColumnNumber = 3, SqlFieldName = OrdItm_Desc ];

/// 作废时间
Property OrdItmDiscardDate As %Date [ SqlColumnNumber = 4, SqlFieldName = OrdItm_DiscardDate ];

/// 创建人
Property OrdItmCreator As %String [ SqlColumnNumber = 5, SqlFieldName = OrdItm_Creator ];

///  索引
Index OrdItmCodeIndex On OrdItmCode;

Storage Default
{
<Data name="OrdItmDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrdItmCode</Value>
</Value>
<Value name="3">
<Value>OrdItmDesc</Value>
</Value>
<Value name="4">
<Value>OrdItmDiscardDate</Value>
</Value>
<Value name="5">
<Value>OrdItmCreator</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDayTask.OrdItmD</DataLocation>
<DefaultData>OrdItmDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDayTask.OrdItmD</IdLocation>
<IndexLocation>^DHCWL.MRIPDayTask.OrdItmI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDayTask.OrdItmS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
