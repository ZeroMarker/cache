/// DHCWL_MRIPDayTask.OrdItmDet   d ##class(DHCWL.MRIPDayTask.OrdItmDet).%BuildIndices()
Class DHCWL.MRIPDayTask.OrdItmDet Extends %Persistent [ SqlRowIdName = OrdItmDet_RowID, SqlTableName = OrdItmDet ]
{

/// 医嘱项id
Property OrdItmDetARCItmMastDR As User.ARCItmMast [ SqlColumnNumber = 2, SqlFieldName = OrdItmDet_ARCItmMastDR ];

/// 自建医嘱统计项id
Property OrdItmDetOrdItmtDR As DHCWL.MRIPDayTask.OrdItm [ SqlColumnNumber = 3, SqlFieldName = OrdItmDet_OrdItmtDR ];

/// 创建日期
Property OrdItmDetCreateDate As %Date [ SqlColumnNumber = 4, SqlFieldName = OrdItmDet_CreateDate ];

/// 创建时间
Property OrdItmDetCreateTime As %Time [ SqlColumnNumber = 5, SqlFieldName = OrdItmDet_CreateTime ];

Index OrdItmDetARCItmMastDRIndex On (OrdItmDetARCItmMastDR, OrdItmDetCreateDate, OrdItmDetCreateTime);

Index OrdItmDetItmMastOrdItmIndex On (OrdItmDetARCItmMastDR, OrdItmDetOrdItmtDR);

Index OrdItmDetOrdItmtDRIndex On (OrdItmDetOrdItmtDR, OrdItmDetCreateDate, OrdItmDetCreateTime);

Storage Default
{
<Data name="OrdItmDetDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>OrdItmDetARCItmMastDR</Value>
</Value>
<Value name="3">
<Value>OrdItmDetOrdItmtDR</Value>
</Value>
<Value name="4">
<Value>OrdItmDetCreateDate</Value>
</Value>
<Value name="5">
<Value>OrdItmDetCreateTime</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MRIPDayTask.OrdItmDetD</DataLocation>
<DefaultData>OrdItmDetDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MRIPDayTask.OrdItmDetD</IdLocation>
<IndexLocation>^DHCWL.MRIPDayTask.OrdItmDetI</IndexLocation>
<StreamLocation>^DHCWL.MRIPDayTask.OrdItmDetS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
