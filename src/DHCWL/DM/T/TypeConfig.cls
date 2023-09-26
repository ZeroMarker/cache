Class DHCWL.DM.T.TypeConfig Extends %Persistent
{

Property Attached As %String [ Required ];

//只能由字母,数字或者下划线组成，且必须是字母开头

Property Code As %String [ Required ];

Property Name As %String;

Property Description As %String(MAXLEN = 512, TRUNCATE = 1);

Index MainI On (Attached, Code) [ PrimaryKey ];

// d ##class(DHCWL.DM.T.TypeConfig).TestData()

ClassMethod TestData()
{
	&sql(delete DHCWL_DM_T.TypeConfig)
	k ^DHCWL.DM.T.TypeConfigD,^DHCWL.DM.T.TypeConfigI
	s obj=##class(TypeConfig).%New()
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="MT" //meta table
	s obj.Name="原型"
	s obj.Description="在命名空间中，MT（Meta Table）表示原型类型"
	d obj.%Save()
	w obj.%Id(),","
	/*
	s obj=##class(TypeConfig).%New()
	s obj.Attached="NAMESPACE"
	s obj.Code="MF" // meta fact table
	s obj.Name="原型事实表"
	s obj.Description="在命名空间中，MF（Meta Fact Table）表示原型事实表类型"
	d obj.%Save()
	w obj.%Id(),","
	*/
	s obj=##class(TypeConfig).%New()
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="DI" //dimension
	s obj.Name="维度"
	s obj.Description="在命名空间中，DI（Dimension）表示维度类型"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="TH" //theme
	s obj.Name="主题"
	s obj.Description="在命名空间中，TH表示主题类型"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="CU" //cube
	s obj.Name="Cube"
	s obj.Description="在命名空间中，CU（Cube）表示Cube类型"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="SE"
	s obj.Name="服务"
	s obj.Description="在命名空间中，SE（Service）表示服务类型"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="KPI"
	s obj.Name="指标"
	s obj.Description="在命名空间中，KPI表示指标类型"
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="DATASOURCE"  //数据源
	s obj.Code="QUERY"
	s obj.Name="Cache Query数据源类型"
	s obj.Description="在数据源中，Query表示CACHE数据库类型"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="DATASOURCE"  //数据源
	s obj.Code="JDBC"
	s obj.Name="JDBC数据源"
	s obj.Description="在数据源中，JDBC表示通过适配于Java的JDBC驱动连接到的数据库类型"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="DATASOURCE"  //数据源
	s obj.Code="CSV"
	s obj.Name="CSV数据源"
	s obj.Description="在数据源中，CSV表示存放CSV文件的目录数据源类型"
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="DIM"  //维度
	s obj.Code="DPMP"  //directly project from meta property
	s obj.Name="映射定义"
	s obj.Description="在维度中，DPMP表示直接根据原型维表字段映射创建的维度属性类型"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="DIM"  //维度
	s obj.Code="BSED"  //base on select expression defined
	s obj.Name="Select表达式"
	s obj.Description="在维度中，BSED表示基于Select表达式创建的维度属性类型"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="DIM"  //维度
	s obj.Code="STCPROFUN"   // static property function call when creating dim data
	s obj.Name="静态属性函数"
	s obj.Description="对应FUNCTION:STICDIMPRO类型的函数，静态属性函数，当通过生成维度数据的时候调用，可以像普通维度属性一样获取属性值"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="DIM"  //维度
	s obj.Code="DYNPROFUN"   // dynamic property function call when computing property value in cql
	s obj.Name="维度方法（动态属性函数）"
	s obj.Description="对应FUNCTION:DYCDIMPRO的函数，动态属性函数，当通过CQL表达式获取维度属性的值时调用，该属性就像一个方法一样使用"
	d obj.%Save()
	w obj.%Id(),","
	
	
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="META"  //原型
	s obj.Code="LOOKUP"
	s obj.Name="原型维表"
	s obj.Description="在原型中，LOOKUP表示属于维表的类型"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="META"  //原型
	s obj.Code="FACT"
	s obj.Name="原型事实表"
	s obj.Description="在原型中，FACT表示属于事实表的类型"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TD"  //主题
	s obj.Code="RD"
	s obj.Name="基础维维度"
	s obj.Description="在主题维度中，RD表示属于引用基础维度类型的维度字段"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TD"  //主题
	s obj.Code="ED"
	s obj.Name="表达式类型的主题维度"
	s obj.Description="在主题维度中，ED表示属于表达式类型的维度"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TD"  //主题
	s obj.Code="LD"
	s obj.Name="字面值类型的主题维度"
	s obj.Description="在主题维度中，LD表示属于字面值类型的维度"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TD"  //主题
	s obj.Code="D"
	s obj.Name="维度类型字段"
	s obj.Description="废弃；在主题中，D表示属于维度类型的字段"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TD"  //主题
	s obj.Code="M"
	s obj.Name="度量类型字段"
	s obj.Description="在主题中，M表示属于维度类型的字段"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TD"  //主题
	s obj.Code="R"
	s obj.Name="关系主题"
	s obj.Description="在主题中，R表示该字段是对另一个主题主键的一个引用，只支持类似维度这样关系的引用类型"
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="CSM"  //Cube Struct Map
	s obj.Code="DIM"  //directly project from meta property
	s obj.Name="维度Cube数据结构映射"
	s obj.Description="在Cube数据结构映射中，DIM表示维度字段的映射定义"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="CSM"  //Cube Struct Map
	s obj.Code="METRIC"  //directly project from meta property
	s obj.Name="度量Cube数据结构映射"
	s obj.Description="在Cube数据结构映射中，METRIC表示聚合表达式定义的度量字段的映射定义"
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="FUNCTION"  //方法配置
	s obj.Code="FILTER"  //过滤表达式中用到的过滤函数
	s obj.Name="过滤器函数"
	s obj.Description="过滤表达式中用到的过滤函数"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="FUNCTION"  //方法配置
	s obj.Code="AGG"  //聚合函数
	s obj.Name="聚合函数"
	s obj.Description="计算度量用的聚合函数"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="FUNCTION"  //方法配置
	s obj.Code="STICDIMPRO"  //静态维度属性函数 static dim propety function
	s obj.Name="静态维度属性函数"
	s obj.Description="静态维度属性函数，生成维度数据的时候会调用该函数得到属性值并保存"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="FUNCTION"  //方法配置
	s obj.Code="DYCDIMPRO"  //动态维度属性函数 dynamic dim propety function
	s obj.Name="动态维度属性函数（维度方法）"
	s obj.Description="动态维度属性函数，生成维度数据的时候不会对该属性生成数据，在CQL表达式中可以调用该属性"
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="PARAM"  //函数参数类型配置
	s obj.Code="EVALPASSBYPOS"  //eval function pass by position
	s obj.Name="执行时按照参数位置系统自动传值"
	s obj.Description="eval函数被调用时按照参数位置系统获取值后自动填充参数值"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="PARAM"  //函数参数类型配置
	s obj.Code="EVALPASSBYVAR"  //eval function pass by var param
	s obj.Name="执行时按照传入名称系统自动传值"
	s obj.Description="eval函数被调用时按照参数变量名系统获取值后自动填充参数值"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="PARAM"  //参数类型配置
	s obj.Code="CONSTANTINITPASS"  //constent value passed by initExpression
	s obj.Name="初始化时的常量值"
	s obj.Description="在initExpression初始化时系统自动传入常量值参数"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="PARAM"  //函数参数类型配置
	s obj.Code="CONSTANTEVALPASS"  //eval function pass constent value
	s obj.Name="执行时的常量值"
	s obj.Description="eval函数调用时传入常量值参数"
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TD"  //主题
	s obj.Code="R"
	s obj.Name="关系字段"
	s obj.Description="在主题中，R表示该字段是关联另一个主题的字段；20171117增加"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TD"  //主题
	s obj.Code="K"
	s obj.Name="主键字段"
	s obj.Description="在主题中，K表示该字段是主题的主键；20171117增加"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TD"  //维度
	s obj.Code="STCPROFUN"   // static property function call when creating dim data
	s obj.Name="静态调用函数生成非关系维度"
	s obj.Description="作用于ThemeDims的CreateType字段，对应FUNCTION:STICDIMPRO类型的函数，静态函数，当通过次生成主题维度数据后，可以像普通维度一样获取值"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TD"  //维度
	s obj.Code="DYNPROFUN"   // dynamic property function call when computing property value in cql
	s obj.Name="动态调用函数生成非关系维度（动态属性函数）"
	s obj.Description="作用于ThemeDims的CreateType字段，对应FUNCTION:DYCDIMPRO的函数，动态函数，当通过CQL表达式获取维度属性的值时调用，该属性就像一个方法一样使用"
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TM"  //主题
	s obj.Code="EM"
	s obj.Name="表达式类型的主题度量"
	s obj.Description="在主题度量中，EM表示度量是通过SQL表达式的方式生成的度量"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TM"  //主题
	s obj.Code="LM"
	s obj.Name="字面值类型的主题度量"
	s obj.Description="在主题度量中，LD表示属于字面值类型的度量"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TM"  //维度
	s obj.Code="STCPROFUN"   // static property function call when creating dim data
	s obj.Name="静态调用函数生成度量"
	s obj.Description="对应FUNCTION:STICDIMPRO类型的函数，静态函数，当通过次生成主题维度数据后，可以像普通维度一样获取值"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="TM"  //维度
	s obj.Code="DYNPROFUN"   // dynamic property function call when computing property value in cql
	s obj.Name="动态调用函数生成度量"
	s obj.Description="对应FUNCTION:DYCDIMPRO的函数，动态函数，当通过CQL表达式获取度量值时调用，就像一个方法一样使用"
	d obj.%Save()
	w obj.%Id(),","
	
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="FUNCTION"  //函数  主题
	s obj.Code="TSTCFUN"   // theme static function call when creating dim or metric data
	s obj.Name="静态调用函数生成主题的字段（维度或度量）"
	s obj.Description="作用于ThemeDims的CreateType字段静态函数，当通过次生成主题维度数据后，可以像普通维度一样获取值"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="FUNCTION"  //函数  主题
	s obj.Code="TDYNFUN"   // theme dynamic property function call when computing property value in cql
	s obj.Name="动态调用函数生成主题的字段（维度或度量）"
	s obj.Description="作用于ThemeDims的CreateType字段，对应FUNCTION:DYCDIMPRO的函数，动态函数，当通过CQL表达式获取维度属性的值时调用，该属性就像一个方法一样使用"
	d obj.%Save()
	w obj.%Id(),","
	
	/*
	s obj=##class(TypeConfig).%New()
	s obj.Attached="FUNCTION"  //方法配置
	s obj.Code="MROUTINE"  //Routine函数调用
	s obj.Name="M语言中Routine函数调用"
	d obj.%Save()
	w obj.%Id(),","
	s obj=##class(TypeConfig).%New()
	s obj.Attached="FUNDEFTYPE"  //函数定义类型
	s obj.Code="CLASS"  //以类的形式定义，在InitCallExpression中给出初始化方式，需要在FunctionConfig中配置
	s obj.Name="以Class定义的函数类型"
	s obj.Description="以类的形式定义，在InitCallExpression中给出初始化方式，需要在FunctionConfig中配置"
	d obj.%Save()
	w obj.%Id(),","
	
	s obj=##class(TypeConfig).%New()
	s obj.Attached="FUNDEFTYPE"  //函数定义类型
	s obj.Code="ROUTINE"  //以Routine的形式定义，不需要需要在InitCallExpression中配置，Name直接给出调用语句，直接在使用的地方给出调用表达式即可
	s obj.Name="以Routine定义的函数类型"
	s obj.Description="以Routine的形式定义，不需要需要在InitCallExpression中配置，，Name直接给出调用语句，直接在使用的地方给出调用表达式即可，只在函数属性中使用。"
	d obj.%Save()
	w obj.%Id(),","
	*/
}

// w ##class(DHCWL.DM.T.TypeConfig).GetIdByPath("NAMESPACE:DI")

ClassMethod GetIdByPath(typePath) As %String
{
	q:typePath="" ""
	s attached=$p(typePath,":",1)
	s code=$p(typePath,":",2)
	s attached=$zcvt(attached,"U")
	s code=$zcvt(code,"U")
	q:'$d(^DHCWL.DM.T.TypeConfigI("MainI"," "_attached," "_code)) ""
	q $o(^DHCWL.DM.T.TypeConfigI("MainI"," "_attached," "_code,""))
}

// s obj= ##class(DHCWL.DM.T.TypeConfig).GetByPath("NAMESPACE:DI")

ClassMethod GetByPath(typePath) As TypeConfig
{
	q ##class(TypeConfig).%OpenId(..GetIdByPath(typePath))
}

ClassMethod GetTypeCode(typeId) As %String [ CodeMode = expression ]
{
$lg(^DHCWL.DM.T.TypeConfigD(typeId),3)
}

Method GetPath() As %String
{
	q ..Attached_":"_..Code
}

Storage Default
{
<Data name="TypeConfigDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
<Value name="2">
<Value>Attached</Value>
</Value>
<Value name="3">
<Value>Code</Value>
</Value>
<Value name="4">
<Value>Name</Value>
</Value>
<Value name="5">
<Value>Description</Value>
</Value>
</Data>
<DataLocation>^DHCWL.DM.T.TypeConfigD</DataLocation>
<DefaultData>TypeConfigDefaultData</DefaultData>
<IdLocation>^DHCWL.DM.T.TypeConfigD</IdLocation>
<IndexLocation>^DHCWL.DM.T.TypeConfigI</IndexLocation>
<StreamLocation>^DHCWL.DM.T.TypeConfigS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
