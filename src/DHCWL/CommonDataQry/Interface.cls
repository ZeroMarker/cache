Class DHCWL.CommonDataQry.Interface Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Creator：      	王峥
/// CreatDate：    	2017-8
/// Description:   	通用简单数据查询润乾报表对应的query
/// Table：       	无
/// Input：         startDate:开始日期, endDate：结束日期, routineName：routine名称, functionName：函数名称, nameSpaceName：名字空间, params：参数
/// Output： 
/// Return：		
/// 	d ##class(%ResultSet).RunQuery("DHCWL.CommonDataQry.Interface","SingleQuery","2011-05-18","2013-05-31","DHCWLSinQuery","Test","dhc-app","测试入参")
Query SingleQuery(startDate As %String, endDate As %String, routineName As %String, functionName As %String, nameSpaceName As %String, params As %String) As %Query(ROWSPEC = "order:%String,rowInx:%Integer,colInx:%Integer,dataCell:%String") [ SqlProc ]
{
}

ClassMethod SingleQueryExecute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, routineName As %String, functionName As %String, nameSpaceName As %String, params As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)	
	q:startDate="" $$$OK
	q:endDate="" $$$OK 
	
	//1、拼接参数，除了日期参数，其他参数暂时屏蔽
	s para=$G(startDate)_","_$G(endDate)	///_","_$G(params)
	//2、查询数据
	s ret=..QueryExport(para,routineName,functionName,nameSpaceName)
    
    i $G(ret)="-1" d ErrorReturn
    q:$G(ret)="-1" $$$OK
    
    
    //3、输出数据
    s num=$p($G(ret),"^",1)-1
    q:+$G(num)=0 $$$OK
    s order=0
    f i=0:1:(num) {
    	s rowInx=i+1
    	s len=$L($G(mPLIST(i)),"^")
    	f j=1:1:len {
		    s colInx=$G(j)
		    s dataCell=$P($G(mPLIST(i)),"^",j)
		    s order=$G(order)+1
		    s data=$lb(order,rowInx,colInx,dataCell)
		    d outputrow	    	
    	}	    
    }

    Quit $$$OK	
    
outputrow
    
    Set ^CacheTemp(repid,ind)=data	
	Set ind=ind+1
	q 
	
ErrorReturn
	;k data
	s order="",rowInx=1,colInx=1,dataCell="报表配置有不正确，请确认配置内容后再试!"
	s data=$lb(order,rowInx,colInx,dataCell)
	d outputrow
	q $$$OK
}

ClassMethod SingleQueryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SingleQueryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SingleQueryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SingleQueryExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：      	王峥
/// CreatDate：    	2017-8
/// Description:   	根据方法入参来查询数据，查询结果必须保存在数组mPLIST中
/// Table：       	无
/// Input：         para：参数, routineName：routine名称, functionName：函数名称, nameSpaceName：名字空间
/// Output： 
/// Return：		
ClassMethod QueryExport(para As %String, routineName As %String, functionName As %String, nameSpace As %String) As %Integer
{
	n (para,routineName,functionName,nameSpace, mPLIST)
	k mPLIST
	//1、保存当前的名字空间
	s curSpace=$ZNSPACE
	s $zt="QueryExportErr" 
	//2、解析参数
	f i=1:1:$l(para,",") d
	.i i=1  d 
	..s paraStr=""""_$p(para,",",i)_""""
	.e  d
	..s paraStr=paraStr_","_""""_$p(para,",",i)_""""
	i $g(paraStr)="""""" s paraStr=""
	//3、拼接执行代码
	s funcStr="s reValue=$$"_$g(functionName)_"^"_$g(routineName)_"("_$g(paraStr)_")"
	zn nameSpace
	//4、调用执行代码
	x funcStr
	//5、切换到原来的名字空间
	zn curSpace
	q $g(reValue)
QueryExportErr
	//s P9=$ze 
	q -1
}

Query SingleQuery21(startDate As %String, endDate As %String, rptID As %String) As %Query(ROWSPEC = "order:%String,rowInx:%Integer,colInx:%Integer,dataCell:%String") [ SqlProc ]
{
}

ClassMethod SingleQuery21Execute(ByRef qHandle As %Binary, startDate As %String, endDate As %String, rptID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	Set qHandle=$lb(0,repid,0)	
	q:startDate="" $$$OK
	q:endDate="" $$$OK 	
	
	k rptObj
	s rptObj=##class(DHCWL.CommonDataQry.RptCfg).%OpenId(rptID)
	
	s nameSpaceName=rptObj.NameSpace
	s routineName=rptObj.Routine
	s functionName=rptObj.Fun
	s params=rptObj.OtherParam

	
	k ^TEMPDHCWL("SingleQuery21PARAM")
	s ^TEMPDHCWL("SingleQuery21PARAM","rptID")=rptID
	s ^TEMPDHCWL("SingleQuery21PARAM","routineName")=routineName
	s ^TEMPDHCWL("SingleQuery21PARAM","functionName")=functionName
	s ^TEMPDHCWL("SingleQuery21PARAM","params")=params
	s ^TEMPDHCWL("SingleQuery21PARAM","execDate")=$ZDATETIME($HOROLOG)
	//1、拼接参数，除了日期参数，其他参数暂时屏蔽
	s para=$G(startDate)_","_$G(endDate)	///_","_$G(params)
	if params'="" s para=para_","_params
	//2、查询数据
	s ret=..QueryExport(para,routineName,functionName,nameSpaceName)
    
    i $G(ret)="-1" d ErrorReturn2
    q:$G(ret)="-1" $$$OK
    
    
    //3、输出数据
    s num=$p($G(ret),"^",1)-1
    q:+$G(num)=0 $$$OK
    s order=0
    f i=0:1:(num) {
    	s rowInx=i+1
    	s len=$L($G(mPLIST(i)),"^")
    	f j=1:1:len {
		    s colInx=$G(j)
		    s dataCell=$P($G(mPLIST(i)),"^",j)
		    s order=$G(order)+1
		    s data=$lb(order,rowInx,colInx,dataCell)
		    d outputrow2    	
    	}	    
    }

    Quit $$$OK	
    
outputrow2
    
    Set ^CacheTemp(repid,ind)=data	
	Set ind=ind+1
	q 
	
ErrorReturn2
	;k data
	s order="1",rowInx=1,colInx=1,dataCell="报表配置有不正确，请确认配置内容后再试!"
	s data=$lb(order,rowInx,colInx,dataCell)
	d outputrow
	q $$$OK
}

ClassMethod SingleQuery21Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SingleQuery21Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SingleQuery21Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SingleQuery21Execute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
