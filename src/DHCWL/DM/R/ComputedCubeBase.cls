Class DHCWL.DM.R.ComputedCubeBase Extends %RegisteredObject
{

Property ThemeBase As ComputedThemeBase [ Required ];

Property DimNum As %Integer [ Required ];

Property mask As %String [ Private ];

Method %OnNew(theme As ComputedThemeBase) As %Status [ Private, ServerOnly = 1 ]
{
	s ..DimNum=theme.DimList.Count()
	s ..ThemeBase=theme
	s ..mask=$i(^DHCWL.DM.T.GlobalSN("CUBE"))
	q $$$OK
}

Method GetDimSN(dimId) As %Integer
{
	q ..ThemeBase.GetDimById(dimId).Mask()
}

Method GetCubeDimId(themeDimId) As %String
{
    q themeDimId
}

Method Mask() As %String
{
	q ..mask
}

Method GetPath() As %String
{
	q ..ThemeBase.GetPath()
}

Method GetMetricStructMap(metric = "") As %List
{
	q ..ThemeBase.GetMetricStructMap(metric)
}

Method GetDimStruct(dimCode = "") As %List
{
	q ..ThemeBase.GetDimStruct(dimCode)
}

Method GetMetricStruct() As %List
{
	q ..ThemeBase.GetMetricStruct()
}

Method ToString() As %String
{
	q "{""mask"":"""_..Mask()_""",""cubeRefTheme"":"_..ThemeBase.ToString()_"}"
}

}
