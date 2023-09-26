Class DHCWL.MKPIService.FilterConfig Extends %RegisteredObject
{

// d ##class(DHCWL.MKPIService.FilterConfig).Config()

/// Creator by lhh
/// Date 2013-08-07
ClassMethod Config()
{
	k ^DHCWLMKPIFilterConf
	s ^DHCWLMKPIFilterConf("FILTER","<","INTERNAL")="<:小于",^DHCWLMKPIFilterConf("FILTER","<=","INTERNAL")="<=:小于等于"
	s ^DHCWLMKPIFilterConf("FILTER",">","INTERNAL")=">:大于",^DHCWLMKPIFilterConf("FILTER",">=","INTERNAL")=">=:大于等于"
	s ^DHCWLMKPIFilterConf("FILTER","'<","INTERNAL")="'<:不小于"
	s ^DHCWLMKPIFilterConf("FILTER","'>","INTERNAL")="'>:不大于"
	s ^DHCWLMKPIFilterConf("FILTER","=","INTERNAL")="=:等于",^DHCWLMKPIFilterConf("FILTER","'=","INTERNAL")="'=:不等于"
	s ^DHCWLMKPIFilterConf("FILTER","[","INTERNAL")="[:包含",^DHCWLMKPIFilterConf("FILTER","'[","INTERNAL")="'[:不包含"
	s ^DHCWLMKPIFilterConf("FILTER","FirstLike","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).FirstLike:解析后的维度属性值是否以过滤参数开头"
	s ^DHCWLMKPIFilterConf("FILTER","EqualIgNull","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).EqualIgNull:判断参数是否相同,忽略空"
	s ^DHCWLMKPIFilterConf("FILTER","SW","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).FirstLike:解析后的维度属性值是否以过滤参数开头"
	s ^DHCWLMKPIFilterConf("FILTER","EW","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).EndWith:解析后的维度属性值是否以过滤参数结尾"
	s ^DHCWLMKPIFilterConf("FILTER","SWN","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).FirstLikeNull:解析后的维度属性值是否以过滤参数开头,忽略空"
	s ^DHCWLMKPIFilterConf("FILTER","EWN","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).EndWithNull:解析后的维度属性值是否以过滤参数结尾,忽略空"
	s ^DHCWLMKPIFilterConf("FILTER","SWC","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).FirstLikeNullCase:参数变大写,解析后的维度属性值是否以过滤参数开头,忽略空"
	s ^DHCWLMKPIFilterConf("FILTER","EWC","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).EndWithCaseNull:参数变大写,解析后的维度属性值是否以过滤参数结尾,忽略空"
	s ^DHCWLMKPIFilterConf("FILTER","=N","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).EqualNull:判断参数是否相同,忽略空"
	s ^DHCWLMKPIFilterConf("FILTER","=C","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).EqualCase:参数变大写，检查是否相同"
	s ^DHCWLMKPIFilterConf("FILTER","=CN","CUSTOM")="##class(DHCWL.Filters.CustomFilterFunc).EqualCaseNull:参数变大写,检查是否相同,忽略空"
	s ^DHCWLMKPIFilterConf("FILTER","CheckContain","CUSTOM")="##class(DHCWL.MKPIService.ExtendMKPIQuery).CheckContain:检查参数列表中的元素是否有元素包含在维度中，有返回true否则false"
	s ^DHCWLMKPIFilterConf("FILTER","NoContain","CUSTOM")="##class(DHCWL.MKPIService.ExtendMKPIQuery).NoContain:检查参数列表中的元素是否有元素包含在维度中，有返回false否则true"
	
	k ^DHCWL.MKPI.ExecuteCodeConfig
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatYesterdayData^DHCWLAutoCreatMKPIData")="D:TAS:Y:1.0:指标日区间任务,返回昨天的日期区间"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastMonDataAt1^DHCWLAutoCreatMKPIData")="M:TAS:Y:1.0:指标月区间任务，每月的1号返回上月的月区间日期"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastMonDataAt2^DHCWLAutoCreatMKPIData")="M:TAS:N:1.0:指标月任务执行代码,每月2号运行返回上月的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastMonDataAt3^DHCWLAutoCreatMKPIData")="M:TAS:N:1.0:指标月任务执行代码,每月3号运行返回上月的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastMonDataAt31^DHCWLAutoCreatMKPIData")="M:TAS:N:1.0:指标月任务执行代码,每月31号运行返回上月的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatMonPortalDataAt1^DHCWLAutoCreatMKPIPortalData")="M:TAS:N:1.0:指标月区间，每天都生成当月指标"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastQuaDateAt01^DHCWLAutoCreatMKPIData")="Q:TAS:Y:1.0:指标季任务执行代码,季度结束后1号运行返回上季度的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastQuaDateAt02^DHCWLAutoCreatMKPIData")="Q:TAS:N:1.0:指标季任务执行代码,季度结束后2号运行返回上季度的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastYearDataAt0101^DHCWLAutoCreatMKPIData")="Y:TAS:Y:1.0:指标年任务执行代码,每年1月1号运行返回去年的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastYearDataAt0102^DHCWLAutoCreatMKPIData")="Y:TAS:N:1.0:指标年任务执行代码,每年1月2号运行返回去年的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastYearDataAt0109^DHCWLAutoCreatMKPIData")="Y:TAS:N:1.0:指标年任务执行代码,每年1月9号运行返回去年的区间Id"
}

/*/// Creator    : wk
/// CreatDate  : 2018-07-10
/// CreatDesc  : 标准执行代码维护
ClassMethod FunConfig()
{
	k ^DHCWL.MKPI.ExecuteCodeConfig
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatYesterdayData^DHCWLAutoCreatMKPIData")="D:TAS:Y:1.0:指标日区间任务,返回昨天的日期区间"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastMonDataAt1^DHCWLAutoCreatMKPIData")="M:TAS:Y:1.0:指标月区间任务，每月的1号返回上月的月区间日期"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastMonDataAt2^DHCWLAutoCreatMKPIData")="M:TAS:N:1.0:指标月任务执行代码,每月2号运行返回上月的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastMonDataAt3^DHCWLAutoCreatMKPIData")="M:TAS:N:1.0:指标月任务执行代码,每月3号运行返回上月的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastMonDataAt31^DHCWLAutoCreatMKPIData")="M:TAS:N:1.0:指标月任务执行代码,每月31号运行返回上月的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatMonPortalDataAt1^DHCWLAutoCreatMKPIPortalData")="M:TAS:N:1.0:指标月区间，每天都生成当月指标"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastQuaDateAt01^DHCWLAutoCreatMKPIData")="Q:TAS:Y:1.0:指标季任务执行代码,季度结束后1号运行返回上季度的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastQuaDateAt02^DHCWLAutoCreatMKPIData")="Q:TAS:N:1.0:指标季任务执行代码,季度结束后2号运行返回上季度的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastYearDataAt0101^DHCWLAutoCreatMKPIData")="Q:TAS:Y:1.0:指标年任务执行代码,每年1月1号运行返回去年的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastYearDataAt0102^DHCWLAutoCreatMKPIData")="Q:TAS:N:1.0:指标年任务执行代码,每年1月2号运行返回去年的区间Id"
	s ^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode","CreatLastYearDataAt0109^DHCWLAutoCreatMKPIData")="Q:TAS:N:1.0:指标年任务执行代码,每年1月9号运行返回去年的区间Id"
}*/
}
