/// // k ^DHCWL.MKPI.MMgrKPICfgI  d ##class(DHCWL.MKPI.MMgrKPICfg).%BuildIndices()
///   DHCWL_MKPI.MMgrKPICfg
Class DHCWL.MKPI.MMgrKPICfg Extends %Persistent [ ClassType = persistent, SqlRowIdName = KPICfg_RowID, SqlTableName = MMgrKPICfg ]
{

Parameter EXTENTSIZE = 250;

Property KPICfgCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 2, SqlFieldName = KPICfg_Code ];

Property KPIDatasetCfgCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 3, SqlFieldName = KPICfg_DatasetCode ];

Property KPIRptCode As %Library.String(COLLATION = "Exact", MAXLEN = 50, TRUNCATE = 0) [ SqlColumnNumber = 4, SqlFieldName = KPICfg_RptCode ];

Property KPITreeCode As %Library.String(COLLATION = "Exact", MAXLEN = 255, TRUNCATE = 0) [ SqlColumnNumber = 5, SqlFieldName = KPICfg_TreeCode ];

Index TRDKIdx On (KPITreeCode, KPIRptCode, KPIDatasetCfgCode, KPICfgCode);

Index KTRDIdx On (KPICfgCode, KPITreeCode, KPIRptCode, KPIDatasetCfgCode);

Storage Default
{
<Data name="MMgrKPICfgDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>KPICfgCode</Value>
</Value>
<Value name="3">
<Value>KPIDatasetCfgCode</Value>
</Value>
<Value name="4">
<Value>KPIRptCode</Value>
</Value>
<Value name="5">
<Value>KPITreeCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MMgrKPICfgD</DataLocation>
<DefaultData>MMgrKPICfgDefaultData</DefaultData>
<ExtentSize>250</ExtentSize>
<IdLocation>^DHCWL.MKPI.MMgrKPICfgD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MMgrKPICfgI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MMgrKPICfgS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
