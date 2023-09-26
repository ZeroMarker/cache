/// d ##class(DHCWL.DM.T.CubeFetchConfig).%BuildIndices()
Class DHCWL.DM.T.CubeFetchConfig Extends %Persistent
{

Property CubeBase As CubeBase;

Property StatisticsWay As ThemeDims;

Property AndFilter As %String;

Index MainI On (CubeBase, StatisticsWay);

Index CubeI On CubeBase [ Unique ];

ClassMethod FetchConfig(cubeCode, statisticsWay, andFilter = "") As %Status
{
	s cube=##class(CubeBase).GetByCode(cubeCode)
	q:cube="" $$$ERROR("The cube with code "_cubeCode_" is not defined!")
	s cubeId=cube.%Id()
	s stDim=cube.ThemeBase.GetDim(statisticsWay)
	q:stDim="" $$$ERROR("The StatisticsWay "_statisticsWay_" is not defined in !"_cube.ThemeBase.GetPath())
	s stid=stDim.%Id()
	q:$d(^DHCWL.DM.T.CubeFetchConfigI("MainI",cubeId,stid)) $$$ERROR("The CubeFetchConfig has been configured with "_cubeCode_" and "_statisticsWay)
	s config=##class(CubeFetchConfig).%New()
	s config.CubeBase=cube,config.StatisticsWay=stDim,config.AndFilter=andFilter
	q config.%Save()
}

// s obj=##class(DHCWL.DM.T.CubeFetchConfig).GetByCode("DHCWorkLoad_OrdDate")

ClassMethod GetByCode(code) As CubeFetchConfig
{
	s cube=##class(CubeBase).GetByCode(code)
	q:cube="" ""
	s cid=cube.%Id()
	q:'$d(^DHCWL.DM.T.CubeFetchConfigI("CubeI",cid)) ""
	s id=$o(^DHCWL.DM.T.CubeFetchConfigI("CubeI",cid,""))
	q ##class(CubeFetchConfig).%OpenId(id)
}

Method GetMetaSQL() As %String
{
	s str="SELECT "
	s dimList=..CubeBase.GetDims()
	f i=1:1:dimList.Count(){
		s:i>1 str=str_" , "
		s str=str_dimList.GetAt(i).DimPro.Code
	}
	s metricList=..CubeBase.GetMetrics()
	f i=1:1:metricList.Count(){
		s str=str_" , "
		s str=str_metricList.GetAt(i).MetricPro.Code
	}
	s str=str_" FROM "_..CubeBase.ThemeBase.GetSQLRef()
	s str=str_" WHERE 1=0"
	q str
}

// s obj=##class(DHCWL.DM.T.CubeFetchConfig).GetByCode("DHCWorkLoad_OrdDate")

// w obj.GetFetchSQL()

Method GetFetchSQL() As %String
{
	s str="SELECT "
	s dimList=..CubeBase.GetDims()
	f i=1:1:dimList.Count(){
		s:i>1 str=str_" , "
		s str=str_dimList.GetAt(i).DimPro.Code
	}
	s metricList=..CubeBase.GetMetrics()
	f i=1:1:metricList.Count(){
		s str=str_" , "
		s str=str_metricList.GetAt(i).MetricPro.Code
	}
	//不走Theme adaptor了，还未优化，直接走Meta adaptor 20180907
	//s str=str_" FROM theme."_..CubeBase.ThemeBase.GetSQLRef()
	s str=str_" FROM ("_..CubeBase.ThemeBase.GetFetchSQL()_")"
	s str=str_" WHERE "_..StatisticsWay.Code_" = ( @scheduleDate)"
	s:..AndFilter'="" str=str_" AND "_..AndFilter
	q str
}

Storage Default
{
<Data name="CubeFetchConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>CubeBase</Value>
</Value>
<Value name="3">
<Value>StatisticsWay</Value>
</Value>
<Value name="4">
<Value>AndFilter</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.CubeFetchConfigD</DataLocation>
<DefaultData>CubeFetchConfigDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.CubeFetchConfigD</IdLocation>
<IndexLocation>^DHCWL.DM.T.CubeFetchConfigI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.CubeFetchConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
