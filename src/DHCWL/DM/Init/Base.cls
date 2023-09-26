Class DHCWL.DM.Init.Base Extends %RegisteredObject
{

// d ##class(DHCWL.DM.Init.Base).InitAll()

ClassMethod InitAll()
{
	d ##class(DHCWL.DM.Init.Base).TypeConfig()
	d ##class(DHCWL.DM.Init.Base).Namespace()
	d ##class(DHCWL.DM.Init.Base).DataType()
	//TODO 可进入DataSourceConfig增加新的数据源连接配置
	d ##class(DHCWL.DM.Init.Base).DataSourceConfig()
	d ##class(DHCWL.DM.T.FunctionConfig).TestData()
	d ##class(DHCWL.DM.T.FunParaConfig).TestData()
}

// d ##class(DHCWL.DM.Init.Base).TypeConfig()

ClassMethod TypeConfig()
{
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("NAMESPACE:MT")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="MT" //meta table
	s obj.Name="原型"
	s obj.Description="在命名空间中，MT（Meta Table）表示原型类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("NAMESPACE:DI")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="DI" //dimension
	s obj.Name="维度"
	s obj.Description="在命名空间中，DI（Dimension）表示维度类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("NAMESPACE:TH")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="TH" //theme
	s obj.Name="主题"
	s obj.Description="在命名空间中，TH表示主题类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("NAMESPACE:CU")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="CU" //cube
	s obj.Name="Cube"
	s obj.Description="在命名空间中，CU（Cube）表示Cube类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("NAMESPACE:SE")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="SE"
	s obj.Name="服务"
	s obj.Description="在命名空间中，SE（Service）表示服务类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("NAMESPACE:KPI")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="NAMESPACE" //命名空间
	s obj.Code="KPI"
	s obj.Name="指标"
	s obj.Description="在命名空间中，KPI表示指标类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("DATASOURCE:QUERY")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="DATASOURCE"  //数据源
	s obj.Code="QUERY"
	s obj.Name="Cache Query数据源类型"
	s obj.Description="在数据源中，Query表示CACHE数据库类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("DATASOURCE:JDBC")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="DATASOURCE"  //数据源
	s obj.Code="JDBC"
	s obj.Name="JDBC数据源"
	s obj.Description="在数据源中，JDBC表示通过适配于Java的JDBC驱动连接到的数据库类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("DATASOURCE:CSV")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="DATASOURCE"  //数据源
	s obj.Code="CSV"
	s obj.Name="CSV数据源"
	s obj.Description="在数据源中，CSV表示存放CSV文件的目录数据源类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DPMP")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="DIM"  //维度
	s obj.Code="DPMP"  //directly project from meta property
	s obj.Name="映射定义"
	s obj.Description="在维度中，DPMP表示直接根据原型维表字段映射创建的维度属性类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:BSED")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="DIM"  //维度
	s obj.Code="BSED"  //base on select expression defined
	s obj.Name="Select表达式"
	s obj.Description="在维度中，BSED表示基于Select表达式创建的维度属性类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:STCPROFUN")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="DIM"  //维度
	s obj.Code="STCPROFUN"   // static property function call when creating dim data
	s obj.Name="静态属性函数"
	s obj.Description="对应FUNCTION:STICDIMPRO类型的函数，静态属性函数，当通过生成维度数据的时候调用，可以像普通维度属性一样获取属性值"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYNPROFUN")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="DIM"  //维度
	s obj.Code="DYNPROFUN"   // dynamic property function call when computing property value in cql
	s obj.Name="维度方法（动态属性函数）"
	s obj.Description="对应FUNCTION:DYCDIMPRO的函数，动态属性函数，当通过CQL表达式获取维度属性的值时调用，该属性就像一个方法一样使用"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("DIM:DYCDIMPRO")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="DIM"  //维度
	s obj.Code="DYCDIMPRO"   // dynamic property function call when computing property value in cql
	s obj.Name="维度方法（动态属性函数）"
	s obj.Description="对应FUNCTION:DYCDIMPRO的函数，动态属性函数，当通过CQL表达式获取维度属性的值时调用，该属性就像一个方法一样使用"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("META:LOOKUP")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="META"  //原型
	s obj.Code="LOOKUP"
	s obj.Name="原型维表"
	s obj.Description="在原型中，LOOKUP表示属于维表的类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("META:FACT")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="META"  //原型
	s obj.Code="FACT"
	s obj.Name="原型事实表"
	s obj.Description="在原型中，FACT表示属于事实表的类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:RD")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TD"  //主题
	s obj.Code="RD"
	s obj.Name="基础维维度"
	s obj.Description="在主题维度中，RD表示属于引用基础维度类型的维度字段"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:ED")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TD"  //主题
	s obj.Code="ED"
	s obj.Name="表达式类型的主题维度"
	s obj.Description="在主题维度中，ED表示属于表达式类型的维度"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:LD")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TD"  //主题
	s obj.Code="LD"
	s obj.Name="字面值类型的主题维度"
	s obj.Description="在主题维度中，LD表示属于字面值类型的维度"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:M")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TD"  //主题
	s obj.Code="M"
	s obj.Name="度量类型字段"
	s obj.Description="在主题中，M表示属于维度类型的字段"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:R")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TD"  //主题
	s obj.Code="R"
	s obj.Name="关系主题"
	s obj.Description="在主题中，R表示该字段是对另一个主题主键的一个引用，只支持类似维度这样关系的引用类型"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("CSM:DIM")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="CSM"  //Cube Struct Map
	s obj.Code="DIM"  //directly project from meta property
	s obj.Name="维度Cube数据结构映射"
	s obj.Description="在Cube数据结构映射中，DIM表示维度字段的映射定义"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("CSM:METRIC")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="CSM"  //Cube Struct Map
	s obj.Code="METRIC"  //directly project from meta property
	s obj.Name="度量Cube数据结构映射"
	s obj.Description="在Cube数据结构映射中，METRIC表示聚合表达式定义的度量字段的映射定义"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("FUNCTION:FILTER")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="FUNCTION"  //方法配置
	s obj.Code="FILTER"  //过滤表达式中用到的过滤函数
	s obj.Name="过滤器函数"
	s obj.Description="过滤表达式中用到的过滤函数"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("FUNCTION:AGG")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="FUNCTION"  //方法配置
	s obj.Code="AGG"  //聚合函数
	s obj.Name="聚合函数"
	s obj.Description="计算度量用的聚合函数"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("FUNCTION:STICDIMPRO")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="FUNCTION"  //方法配置
	s obj.Code="STICDIMPRO"  //静态维度属性函数 static dim propety function
	s obj.Name="静态维度属性函数"
	s obj.Description="静态维度属性函数，生成维度数据的时候会调用该函数得到属性值并保存"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("FUNCTION:DYCDIMPRO")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="FUNCTION"  //方法配置
	s obj.Code="DYCDIMPRO"  //动态维度属性函数 dynamic dim propety function
	s obj.Name="动态维度属性函数（维度方法）"
	s obj.Description="动态维度属性函数，生成维度数据的时候不会对该属性生成数据，在CQL表达式中可以调用该属性"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("PARAM:EVALPASSBYPOS")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="PARAM"  //函数参数类型配置
	s obj.Code="EVALPASSBYPOS"  //eval function pass by position
	s obj.Name="执行时按照参数位置系统自动传值"
	s obj.Description="eval函数被调用时按照参数位置系统获取值后自动填充参数值"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("PARAM:EVALPASSBYVAR")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="PARAM"  //函数参数类型配置
	s obj.Code="EVALPASSBYVAR"  //eval function pass by var param
	s obj.Name="执行时按照传入名称系统自动传值"
	s obj.Description="eval函数被调用时按照参数变量名系统获取值后自动填充参数值"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("PARAM:CONSTANTINITPASS")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="PARAM"  //函数参数类型配置
	s obj.Code="CONSTANTINITPASS"  //constent value passed by initExpression
	s obj.Name="初始化时的常量值"
	s obj.Description="在initExpression初始化时系统自动传入常量值参数"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("PARAM:CONSTANTEVALPASS")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="PARAM"  //函数参数类型配置
	s obj.Code="CONSTANTEVALPASS"  //eval function pass constent value
	s obj.Name="执行时的常量值"
	s obj.Description="eval函数调用时传入常量值参数"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:R")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TD"  //主题
	s obj.Code="R"
	s obj.Name="关系字段"
	s obj.Description="在主题中，R表示该字段是关联另一个主题的字段；20171117增加"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:K")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TD"  //主题
	s obj.Code="K"
	s obj.Name="主键字段"
	s obj.Description="在主题中，K表示该字段是主题的主键；20171117增加"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:K")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TD"  //主题
	s obj.Code="K"
	s obj.Name="主键字段"
	s obj.Description="在主题中，K表示该字段是主题的主键；20171117增加"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:STCPROFUN")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TD"  //主题
	s obj.Code="STCPROFUN"   // static property function call when creating dim data
	s obj.Name="静态调用函数生成非关系维度"
	s obj.Description="作用于ThemeDims的CreateType字段，对应FUNCTION:STICDIMPRO类型的函数，静态函数，当通过次生成主题维度数据后，可以像普通维度一样获取值"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TD:DYNPROFUN")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TD"  //主题
	s obj.Code="DYNPROFUN"   // dynamic property function call when computing property value in cql
	s obj.Name="动态调用函数生成非关系维度（动态属性函数）"
	s obj.Description="作用于ThemeDims的CreateType字段，对应FUNCTION:DYCDIMPRO的函数，动态函数，当通过CQL表达式获取维度属性的值时调用，该属性就像一个方法一样使用"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TM:EM")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TM"  //主题
	s obj.Code="EM"
	s obj.Name="表达式类型的主题度量"
	s obj.Description="在主题度量中，EM表示度量是通过SQL表达式的方式生成的度量"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TM:LM")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TM"  //主题
	s obj.Code="LM"
	s obj.Name="字面值类型的主题度量"
	s obj.Description="在主题度量中，LD表示属于字面值类型的度量"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TM:STCPROFUN")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TM"  //主题
	s obj.Code="STCPROFUN"   // static property function call when creating dim data
	s obj.Name="静态调用函数生成度量"
	s obj.Description="对应FUNCTION:STICDIMPRO类型的函数，静态函数，当通过次生成主题维度数据后，可以像普通维度一样获取值"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("TM:DYNPROFUN")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="TM"  //主题
	s obj.Code="DYNPROFUN"   // dynamic property function call when computing property value in cql
	s obj.Name="动态调用函数生成度量"
	s obj.Description="对应FUNCTION:DYCDIMPRO的函数，动态函数，当通过CQL表达式获取度量值时调用，就像一个方法一样使用"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("FUNCTION:TSTCFUN")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="FUNCTION"  //函数  主题
	s obj.Code="TSTCFUN"   // theme static function call when creating dim or metric data
	s obj.Name="静态调用函数生成主题的字段（维度或度量）"
	s obj.Description="作用于ThemeDims的CreateType字段静态函数，当通过次生成主题维度数据后，可以像普通维度一样获取值"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.TypeConfig).GetByPath("FUNCTION:TDYNFUN")
	if obj=""{
		s obj=##class(DHCWL.DM.T.TypeConfig).%New()
	}
	s obj.Attached="FUNCTION"  //函数  主题
	s obj.Code="TDYNFUN"   // theme dynamic property function call when computing property value in cql
	s obj.Name="动态调用函数生成主题的字段（维度或度量）"
	s obj.Description="作用于ThemeDims的CreateType字段，对应FUNCTION:DYCDIMPRO的函数，动态函数，当通过CQL表达式获取维度属性的值时调用，该属性就像一个方法一样使用"
	s status= obj.%Save()
	w:status'=$$$OK status,!
}

// d ##class(DHCWL.DM.Init.Base).Namespace()

ClassMethod Namespace()
{
	s obj=##class(DHCWL.DM.T.Namespace).CreateNamespace("MT:/")
	s obj.Name="原型根目录",obj.Description="定义原型的根目录，其他都定义在该命名空间之下。"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.Namespace).CreateNamespace("DI:/")
	s obj.Name="维度根目录",obj.Description="维度的根目录，其他都定义在该命名空间之下。"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.Namespace).CreateNamespace("TH:/")
	s obj.Name="主题根目录",obj.Description="主题的根目录，其他都定义在该命名空间之下。"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.Namespace).CreateNamespace("SE:/")
	s obj.Name="服务根目录",obj.Description="服务的根目录，其他都定义在该命名空间之下。"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.Namespace).CreateNamespace("TH:/common")
	s obj.Name="公共",obj.Description="公共主题目录"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.Namespace).CreateNamespace("TH:/common/test")
	s obj.Name="公共测试",obj.Description="主题公共测试目录"
	s status= obj.%Save()
	w:status'=$$$OK status,!
}

// d ##class(DHCWL.DM.Init.Base).DataType()

ClassMethod DataType()
{
	s obj=##class(DHCWL.DM.T.DataType).GetByPath("string")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataType).%New()
	}
	s obj.Code="string",obj.Name="字符串",obj.Description="可变长字符串类型",obj.JDBCTypeCodeNum=12
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.DataType).GetByPath("INTEGER")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataType).%New()
	}
	s obj.Code="INTEGER",obj.Name="整数值",obj.Description="4字节长度的整数值",obj.JDBCTypeCodeNum=4
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.DataType).GetByPath("DOUBLE")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataType).%New()
	}
	s obj.Code="DOUBLE",obj.Name="浮点数",obj.Description="8字节长度的浮点数",obj.JDBCTypeCodeNum=8
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.DataType).GetByPath("DATE")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataType).%New()
	}
	s obj.Code="DATE",obj.Name="日期",obj.Description="日期，包含年月日，默认格式yyyy-MM-dd",obj.JDBCTypeCodeNum=91
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.DataType).GetByPath("TIME")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataType).%New()
	}
	s obj.Code="TIME",obj.Name="时间",obj.Description="时间，包含时分秒",obj.JDBCTypeCodeNum=92
	s status= obj.%Save()
	w:status'=$$$OK status,!
	
	s obj=##class(DHCWL.DM.T.DataType).GetByPath("VARCHAR")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataType).%New()
	}
	s obj.Code="VARCHAR",obj.Name="字符串",obj.Description="可变长字符串类型",obj.JDBCTypeCodeNum=12
	s status= obj.%Save()
	w:status'=$$$OK status,!
}

// d ##class(DHCWL.DM.Init.Base).DataSourceConfig()

ClassMethod DataSourceConfig()
{
	s obj=##class(DHCWL.DM.T.DataSourceConfig).GetByPath("JDBC:DHC-APP-LOCAL")
	if obj=""{
		s obj=##class(DHCWL.DM.T.DataSourceConfig).%New()
	}
	s type=##class(DHCWL.DM.T.TypeConfig).GetByPath("DATASOURCE:JDBC")
	s obj.Type=type,obj.Code="DHC-APP-LOCAL",obj.Name="CachéDHCAPP_LOCAL连接配置"
	s obj.Description="连接localhostCaché数据库的DHC-APP命名空间",obj.IsActived="N"
	s obj.UsageStatus="A"
	s status= obj.%Save()
	w:status'=$$$OK status,!
	s status=##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"url","jdbc:Cache://localhost:1972/dhc-app")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"user","_SYSTEM")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"password","SYS")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"driver","com.intersys.jdbc.CacheDriver")
	w:status'=$$$OK status,!
	s status= ##class(DHCWL.DM.T.KeyValueConfig).Put("DataSourceConfig-"_obj.%Id(),"schema","sqluser")
	w:status'=$$$OK status,!
}

}
