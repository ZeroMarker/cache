Class DHCWL.DM.T.ZForJavaProj Extends %RegisteredObject
{

Property CubeBase As CubeBase;

Property CubeDims As CubeDims;

Property CubeDStruct As CubeDStruct;

Property CubeDStructMap As CubeDStructMap;

Property CubeMetrics As CubeMetrics;

Property DataLog As DataLog;

Property DataSourceConfig As DataSourceConfig;

Property DataType As DataType;

Property DimBase As DimBase;

Property DimDataIndex As DimDataIndex;

Property DimDStruct As DimDStruct;

Property DimDStructMap As DimDStructMap;

Property DimProperty As DimProperty;

Property KeyValueConfig As KeyValueConfig;

Property MetaTableBase As MetaTableBase;

Property MetaTablePro As MetaTablePro;

Property Namespace As Namespace;

Property ThemeBase As ThemeBase;

Property ThemeDataLog As ThemeDataLog;

Property ThemeDims As ThemeDims;

Property ThemeDStruct As ThemeDStruct;

Property ThemeDStructMap As ThemeDStructMap;

Property ThemeFetchConfig As ThemeFetchConfig;

Property ThemeFetchFilter As ThemeFetchFilter;

Property ThemeMetrics As ThemeMetrics;

Property ThemeTaskConfig As ThemeTaskConfig;

Property TypeConfig As TypeConfig;

Property ParsedDimStruct As DHCWL.DM.Core.ParsedDimStruct;

Property ParsedFunctionCallStruct As DHCWL.DM.Core.ParsedFunctionCallStruct;

Property ParsedMetricStruct As DHCWL.DM.Core.ParsedMetricStruct;

Property iterator As DHCWL.DM.Core.Iterator;

Property parser As DHCWL.DM.Core.CQLParser;

Property RaqService As DHCWL.DM.I.RaqService;

Property ComputedThemeBase As DHCWL.DM.R.ComputedThemeBase;

Property Executor As DHCWL.DM.I.Executor;

Property CubeFetchConfig As DHCWL.DM.T.CubeFetchConfig;

Projection NullForProj As %Projection.Java;

// d ##class(DHCWL.DM.T.ZForJavaProj).Test()

ClassMethod Test()
{
	w %compiledmethod.ClientName
}

}
