/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	报表输出接口基类
Class DHCWL.DataQuery.ServOfOutputIF Extends %RegisteredObject
{

//配置数据

Property aryOutCfg As array Of %String;

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	报表输出接口
/// Table：       	无
/// Input：         
/// Output： 
/// Return：
/// 	other:	行式报表会把下面数据放到数组aryOutV里：
/// 			aryOutV("rowInx")=行序号
/// 			aryOutV("cellDesc")=单元格描述
/// 			aryOutV("cellOrder")=单元格序号
/// 			aryOutV("cellValue")=单元格值
/// 			aryOutV("cellValueType")=值类型，包括：number，string
/// 			aryOutV("ColIsAggregate")=是否汇总
/// 			aryOutV("colType")=维度还是度量，包括：measure，dim
/// 			交叉报表会把下面数据放到数组里：
/// 			aryOutV(行列标识,行或列序号,"value")=行或列的值
/// 			aryOutV(行列标识,行或列序号,"desc")=行或列描述
Method DoOutput(ByRef aryOutV)
{
}

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	设置配置数据
/// Table：       	无
/// Input：         数组格式的配置数据。
/// Output： 
/// Return： 		
/// Others：        
Method SetAryOutCfgArgs(ByRef outCfg)
{
	s arg=""
	f {
		s arg=$o(outCfg(arg))	
		q:$g(arg)=""
		d ..aryOutCfg.SetAt(outCfg(arg),arg)
		//s ..aryOutCfg(arg)=outCfg(arg)
	}
}

Method %OnNew(ByRef outCfg) As %Status
{
	s arg=""
	f {
		s arg=$o(outCfg(arg))	
		q:$g(arg)=""
		d ..aryOutCfg.SetAt(outCfg(arg),arg)
		//s ..aryOutCfg(arg)=outCfg(arg)
	}
    Quit $$$OK
}

}
