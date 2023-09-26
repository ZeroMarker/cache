Class DHCWL.BaseDataQuery.QryStatData.ServOfOutputIF Extends %RegisteredObject
{

//配置数据

Property aryOutCfg As array Of %String;

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

/// Creator：      	王峥
/// CreatDate：    	2017-6-23
/// Description:   	设置配置数据
/// Table：       	无
/// Input：         数组格式的配置数据。
/// Output： 
/// Return： 		
/// Others：        
Method GetAryOutCfgArgs(key As %String) As %String
{
	q ..aryOutCfg.GetAt(key)
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

Method DoOutput()
{
}

}
