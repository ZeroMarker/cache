/// DHCWL_MKPI.DHCWLKPIMonthsContract  d ##class(DHCWL.MKPI.MonthContract).%BuildIndices()
Class DHCWL.MKPI.MonthContract Extends %Persistent [ ClassType = persistent, SqlTableName = DHCWLKPIMonthsContract ]
{

Property MonthDr As DHCWL.MKPI.Months [ Required, SqlColumnNumber = 2, SqlFieldName = MonCon_MonthDr ];

Property Type As DHCWL.MKPI.APPLibrary [ Required, SqlColumnNumber = 3, SqlFieldName = MonCon_Type ];

Property MonthIdList As %String(MAXLEN = 512) [ SqlColumnNumber = 4, SqlFieldName = MonCon_MonIdList ];

Index MonthDrTypeI On (MonthDr, Type);

/// d ##class(DHCWL.MKPI.MonthContract).CreateNeed()
ClassMethod CreateNeed()
{
	if (+##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||PP")=0){
		s obj=##class(DHCWL.MKPI.APPLibrary).%New()
		s obj.AppFor="MONCON",obj.Code="PP",obj.Name="上期",obj.Describe="根据month Id计算该日期下的上期的months id"
		d obj.%Save()
	}
	if (+##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||SL")=0){
		s obj=##class(DHCWL.MKPI.APPLibrary).%New()
		s obj.AppFor="MONCON",obj.Code="SL",obj.Name="同期",obj.Describe="根据month Id计算该日期下的去年同期的months id"
		d obj.%Save()
	}
	if (+##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||CM")=0){
		s obj=##class(DHCWL.MKPI.APPLibrary).%New()
		s obj.AppFor="MONCON",obj.Code="CM",obj.Name="本月累计",obj.Describe="根据month Id计算从月初到该日期下的months id"
		d obj.%Save()
	}
	if (+##class(DHCWL.MKPI.APPLibrary).GetIdByCode("MONCON||CY")=0){
		s obj=##class(DHCWL.MKPI.APPLibrary).%New()
		s obj.AppFor="MONCON",obj.Code="CY",obj.Name="本年累计",obj.Describe="根据month Id计算从年初到该月份下的月区间months id"
		d obj.%Save()
	}
}

Storage Default
{
<Data name="MonthContractDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MonthDr</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>MonthIdList</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MonthContractD</DataLocation>
<DefaultData>MonthContractDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCWL.MKPI.MonthContractD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MonthContractI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MonthContractS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

Storage NewStorage1
{
<Data name="MonthContractDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>MonthDr</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>MonthIdList</Value>
</Value>
</Data>
<DataLocation>^DHCWL.MKPI.MonthContractD</DataLocation>
<DefaultData>MonthContractDefaultData</DefaultData>
<IdLocation>^DHCWL.MKPI.MonthContractD</IdLocation>
<IndexLocation>^DHCWL.MKPI.MonthContractI</IndexLocation>
<StreamLocation>^DHCWL.MKPI.MonthContractS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
