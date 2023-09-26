Class DHCWL.DM.T.ThemeDStructMap Extends %Persistent
{

Property ThemeBase As ThemeBase [ Required ];

//可能的类型Path分别为：TD:D（维度）,TD:M（度量）

Property Type As TypeConfig [ Required ];

//存储主题维度(ThemeDims)或者度量(ThemeMetrics)的外键

Property ProCode As %String [ Required ];

Property MapPosition As %Integer;

Index MainI On (ThemeBase, Type, ProCode) [ PrimaryKey ];

// d ##class(DHCWL.DM.T.ThemeDStructMap).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.ThemeDStructMap)
	k ^DHCWL.DM.T.ThemeDStructMapD,^DHCWL.DM.T.ThemeDStructMapI
	s base=##class(ThemeBase).GetByPath("/workload.t")
	
	s obj=##class(ThemeDStructMap).%New()
	s obj.ThemeBase=base,obj.Type=##class(TypeConfig).GetByPath("TD:D"),obj.ProCode="RecDep",obj.MapPosition=1
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDStructMap).%New()
	s obj.ThemeBase=base,obj.Type=##class(TypeConfig).GetByPath("TD:D"),obj.ProCode="RecDepName",obj.MapPosition=2
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDStructMap).%New()
	s obj.ThemeBase=base,obj.Type=##class(TypeConfig).GetByPath("TD:D"),obj.ProCode="PatDepName",obj.MapPosition=3
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDStructMap).%New()
	s obj.ThemeBase=base,obj.Type=##class(TypeConfig).GetByPath("TD:D"),obj.ProCode="WarName",obj.MapPosition=4
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDStructMap).%New()
	s obj.ThemeBase=base,obj.Type=##class(TypeConfig).GetByPath("TD:D"),obj.ProCode="PatDep",obj.MapPosition=5
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDStructMap).%New()
	s obj.ThemeBase=base,obj.Type=##class(TypeConfig).GetByPath("TD:D"),obj.ProCode="AdmType",obj.MapPosition=6
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDStructMap).%New()
	s obj.ThemeBase=base,obj.Type=##class(TypeConfig).GetByPath("TD:D"),obj.ProCode="OrdDate",obj.MapPosition=7
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDStructMap).%New()
	s obj.ThemeBase=base,obj.Type=##class(TypeConfig).GetByPath("TD:M"),obj.ProCode="Quantity",obj.MapPosition=8
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(ThemeDStructMap).%New()
	s obj.ThemeBase=base,obj.Type=##class(TypeConfig).GetByPath("TD:M"),obj.ProCode="Price",obj.MapPosition=9
	d obj.%Save()
	w obj.%Id(),","
}

Storage Default
{
<Data name="ThemeDStructMapDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>ThemeBase</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>ProBase</Value>
</Value>
<Value name="5">
<Value>MapPosition</Value>
</Value>
<Value name="6">
<Value>ProCode</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.ThemeDStructMapD</DataLocation>
<DefaultData>ThemeDStructMapDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.ThemeDStructMapD</IdLocation>
<IndexLocation>^DHCWL.DM.T.ThemeDStructMapI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.ThemeDStructMapS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
