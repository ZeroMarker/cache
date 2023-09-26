Class DHCWL.DM.T.FunParaConfig Extends %Persistent
{

Property FunctionConfig As FunctionConfig [ Required ];

Property ParaIndex As %Integer [ Required ];

Property Name As %String [ Required ];

Property ValueType As DataType [ Required ];

// 仅当PARAM:CONSTANTINITPASS时有效

Property DefaultValue As %String;

// IsProperty停止使用

Property IsProperty As %Boolean;

Property ParamType As TypeConfig [ Required ];

Index MainI On (FunctionConfig, Name As Exact);

// d ##class(DHCWL.DM.T.FunParaConfig).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.FunParaConfig)
	k ^DHCWL.DM.T.FunParaConfigD,^DHCWL.DM.T.FunParaConfigI
	s fun=##class(FunctionConfig).GetByPath("FILTER:startwith")
	/*s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="value"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR"),obj.IsProperty=0
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:EVALPASSBYPOS")
	d obj.%Save()
	w obj.%Id(),","*/
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="startValue"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR"),obj.IsProperty=0
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	
	s fun=##class(FunctionConfig).GetByPath("FILTER:DateRange")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="startDate"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR"),obj.IsProperty=0
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=2,obj.Name="endDate"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR"),obj.IsProperty=0
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=3,obj.Name="stepWidth"
	s obj.ValueType=##class(DataType).GetByPath("INTEGER"),obj.DefaultValue="1",obj.IsProperty=0
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	
	s fun=##class(DHCWL.DM.T.FunctionConfig).GetByPath("AGG:sum")
	s obj=##class(DHCWL.DM.T.FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="metric"
	s obj.ValueType=##class(DHCWL.DM.T.DataType).GetByPath("DOUBLE"),obj.IsProperty=1
	s obj.ParamType=##class(DHCWL.DM.T.TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	d obj.%Save()
	w obj.%Id(),","
	
	s fun=##class(FunctionConfig).GetByPath("AGG:count")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="metric"
	s obj.ValueType=##class(DataType).GetByPath("DOUBLE"),obj.IsProperty=1
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	d obj.%Save()
	w obj.%Id(),","
	
	s fun=##class(FunctionConfig).GetByPath("DYCDIMPRO:Test")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="Code"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR")
	s obj.DefaultValue="ABC"
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=2,obj.Name="Name"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR")
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=3,obj.Name="Value"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR")
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTEVALPASS")
	d obj.%Save()
	w obj.%Id(),","
	
	s fun=##class(FunctionConfig).GetByPath("STICDIMPRO:Test2")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="Code"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR")
	s obj.DefaultValue="ABC"
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=2,obj.Name="Name"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR")
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	d obj.%Save()
	w obj.%Id(),","
	
	s fun=##class(FunctionConfig).GetByPath("FILTER:contain")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="vlues"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR"),obj.IsProperty=0
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	
	s fun=##class(FunctionConfig).GetByPath("FILTER:[")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="vlue"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR"),obj.IsProperty=0
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	
	
	s fun=##class(FunctionConfig).GetByPath("TDYNFUN:ThemeDynDimFun")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="Code"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR")
	s obj.DefaultValue="ABC"
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=2,obj.Name="MR_ADM"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR")
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=3,obj.Name="dd"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR")
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTEVALPASS")
	d obj.%Save()
	w obj.%Id(),","
	
	
	s fun=##class(FunctionConfig).GetByPath("AGG:avg")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="metric"
	s obj.ValueType=##class(DataType).GetByPath("DOUBLE"),obj.IsProperty=1
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	d obj.%Save()
	w obj.%Id(),","
	
	s fun=##class(FunctionConfig).GetByPath("AGG:median")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="metric"
	s obj.ValueType=##class(DataType).GetByPath("DOUBLE"),obj.IsProperty=1
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	d obj.%Save()
	w obj.%Id(),","
	
	
	s fun=##class(FunctionConfig).GetByPath("FILTER:between")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="startValue"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR"),obj.IsProperty=0
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=2,obj.Name="startValue"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR"),obj.IsProperty=0
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	d obj.%Save()
	w obj.%Id(),","
	/*s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=3,obj.Name="Value"
	s obj.ValueType=##class(DataType).GetByPath("VARCHAR")
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:CONSTANTEVALPASS")
	d obj.%Save()
	w obj.%Id(),","
	*/
	
	s fun=##class(FunctionConfig).GetByPath("AGG:min")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="metric"
	s obj.ValueType=##class(DataType).GetByPath("DOUBLE"),obj.IsProperty=1
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	d obj.%Save()
	w obj.%Id(),","
	
	s fun=##class(FunctionConfig).GetByPath("AGG:max")
	s obj=##class(FunParaConfig).%New()
	s obj.FunctionConfig=fun,obj.ParaIndex=1,obj.Name="metric"
	s obj.ValueType=##class(DataType).GetByPath("DOUBLE"),obj.IsProperty=1
	s obj.ParamType=##class(TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	d obj.%Save()
	w obj.%Id(),","
}

ClassMethod GetParameters(funId) As %ListOfObjects
{
	s list=##class(%ListOfObjects).%New()
	q:'$d(^DHCWL.DM.T.FunParaConfigI("MainI",funId)) list
	s name="" f  s name=$o(^DHCWL.DM.T.FunParaConfigI("MainI",funId,name)) q:name=""  d
	.s id=$o(^DHCWL.DM.T.FunParaConfigI("MainI",funId,name,""))
	.q:'$d(^DHCWL.DM.T.FunParaConfigD(id))
	.s obj=##class(FunParaConfig).%OpenId(id)
	.q:obj=""
	.d list.Insert(obj)
	q list
}

ClassMethod GetParameter(funId, paraName) As FunParaConfig
{
	q:'$d(^DHCWL.DM.T.FunParaConfigI("MainI",funId,paraName)) ""
	s id=$o(^DHCWL.DM.T.FunParaConfigI("MainI",funId,paraName,""))
	q ##class(FunParaConfig).%OpenId(id)
}

Storage Default
{
<Data name="FunParaConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>FunctionConfig</Value>
</Value>
<Value name="3">
<Value>ParaIndex</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>ValueType</Value>
</Value>
<Value name="6">
<Value>DefaultValue</Value>
</Value>
<Value name="7">
<Value>IsProperty</Value>
</Value>
<Value name="8">
<Value>ParamType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.FunParaConfigD</DataLocation>
<DefaultData>FunParaConfigDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.FunParaConfigD</IdLocation>
<IndexLocation>^DHCWL.DM.T.FunParaConfigI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.FunParaConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
