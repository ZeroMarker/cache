/// FunctionConfig下面的函数要么是Routine函数；要么是继承自FunctionInterface的类<br/>
/// 不管是哪种类型都有在FunctionConfig中配置才可以使用，且这些函数的入参都是%List类型
Class DHCWL.DM.T.FunctionConfig Extends %Persistent
{

Property Name As %String [ Required ];

//useing type

Property Type As TypeConfig [ Required ];

Property InitCallExpression As %String;

Property Description As %String(MAXLEN = 512, TRUNCATE = 1);

Property CallExpression As %String(MAXLEN = 512);

/// Filter对应Iterator,Choice,MOperator
/// 只有属性函数可以是MRoutine
Property SubType As %String(DISPLAYLIST = ",Iterator,Choice,MOperator,MRoutine", MAXLEN = 2, TRUNCATE = 1, VALUELIST = ",I,C,MO,MR");

Index MainI On (Type, Name) [ PrimaryKey ];

// d ##class(DHCWL.DM.T.FunctionConfig).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.FunctionConfig)
	k ^DHCWL.DM.T.FunctionConfigD,^DHCWL.DM.T.FunctionConfigI
	s obj=##class(FunctionConfig).%New()
	s obj.Name="StartWith",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="I"
	s obj.InitCallExpression="##class(DHCWL.DM.Function.Filter.StartWith).%New"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="DateRange",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="C"
	s obj.InitCallExpression="##class(DHCWL.DM.Function.Filter.DateRange).%New"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="=",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="MO"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="sum",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:AGG")
	s obj.InitCallExpression="##class(DHCWL.DM.Function.Agg.Sum).%New"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="count",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:AGG")
	s obj.InitCallExpression="##class(DHCWL.DM.Function.Agg.Count).%New"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="Test",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:DYCDIMPRO")
	s obj.SubType="MR"
	s obj.CallExpression="$$Test^TestKPIDataFetch"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="Test2",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:STICDIMPRO")
	s obj.SubType="MR"
	s obj.CallExpression="$$Test2^TestKPIDataFetch"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="contain",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="I"
	s obj.InitCallExpression="##class(DHCWL.DM.Function.Filter.Contain).%New"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="[",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="MO"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="ThemeDynDimFun",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:TDYNFUN")
	s obj.CallExpression="$$Test^TestKPIDataFetch"
	s obj.SubType="MR"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name=">",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="MO"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name=">=",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="MO"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="<",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="MO"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="<=",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="MO"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="avg",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:AGG")
	s obj.InitCallExpression="##class(DHCWL.DM.Function.Agg.Average).%New"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="median",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:AGG")
	s obj.InitCallExpression="##class(DHCWL.DM.Function.Agg.Median).%New"
	s obj.Description="求中位数"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="between",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="MO"
	s obj.Description="求中位数"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="notnull",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="MO"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="isnull",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="MO"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="like",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.SubType="MO"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="NE",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:FILTER")
	s obj.Description="不等于"
	s obj.SubType="MO"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="min",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:AGG")
	s obj.InitCallExpression="##class(DHCWL.DM.Function.Agg.Min).%New"
	s obj.Description="求最小值"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(FunctionConfig).%New()
	s obj.Name="max",obj.Type=##class(TypeConfig).GetByPath("FUNCTION:AGG")
	s obj.InitCallExpression="##class(DHCWL.DM.Function.Agg.Max).%New"
	s obj.Description="求最大值"
	d obj.%Save()
	w obj.%Id(),","
}

ClassMethod GetIdByPath(name) As %String
{
	s type=$p(name,":",1)
	s typeId=##class(TypeConfig).GetIdByPath("FUNCTION:"_$zcvt(type,"U"))
	s fun=" "_$zcvt($p(name,":",2),"U")
	q:'$d(^DHCWL.DM.T.FunctionConfigI("MainI",typeId,fun)) ""
	q $o(^DHCWL.DM.T.FunctionConfigI("MainI",typeId,fun,""))
}

//s obj=##class(DHCWL.DM.T.FunctionConfig).GetByPath("FILTER:notnull")

ClassMethod GetByPath(funPath) As FunctionConfig [ CodeMode = expression ]
{
##class(FunctionConfig).%OpenId(..GetIdByPath(funPath))
}

Method Parameters() As %ListOfObjects [ CodeMode = expression ]
{
##class(FunParaConfig).GetParameters(..%Id())
}

// d ##class(DHCWL.DM.T.FunctionConfig).Test1()

ClassMethod Test1()
{
	s ts=$p($h,",",2)
	f i=1:1:9999999 d
	.d ..fun("abceffakdjfajdfladjkdafdf","fdf")
	w "Spend time:"_($p($h,",",2)-ts)_"s"
}

// d ##class(DHCWL.DM.T.FunctionConfig).Test2()

ClassMethod Test2()
{
	s exeStr="d ##class(DHCWL.DM.T.FunctionConfig).fun(""abceffakdjfajdfladjkdafdf"",""fdf"")"
	s ts=$p($h,",",2)
	f i=1:1:9999999 d
	.x exeStr
	w "Spend time:"_($p($h,",",2)-ts)_"s"
}

// d ##class(DHCWL.DM.T.FunctionConfig).Test3()

ClassMethod Test3()
{
	s ts=$p($h,",",2)
	s params=$lb("abceffakdjfajdfladjkdafdf","fdf")
	f i=1:1:9999999 d
	.d ..fun2(params)
	w "Spend time:"_($p($h,",",2)-ts)_"s"
}

ClassMethod fun(a, b)
{
	q a [ b
}

ClassMethod fun2(list) [ CodeMode = expression ]
{
$list(list,1) [ $list(list,2)
}

Storage Default
{
<Data name="FunctionConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Name</Value>
</Value>
<Value name="3">
<Value>Type</Value>
</Value>
<Value name="4">
<Value>InitCallExpression</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
<Value name="6">
<Value>DefinedType</Value>
</Value>
<Value name="7">
<Value>CallExpression</Value>
</Value>
<Value name="8">
<Value>FunType</Value>
</Value>
<Value name="9">
<Value>SubType</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.FunctionConfigD</DataLocation>
<DefaultData>FunctionConfigDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.FunctionConfigD</IdLocation>
<IndexLocation>^DHCWL.DM.T.FunctionConfigI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.FunctionConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
