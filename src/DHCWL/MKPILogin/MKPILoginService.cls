Class DHCWL.MKPILogin.MKPILoginService Extends %RegisteredObject [ Not ProcedureBlock ]
{

//array用来记录一条新数据的各项属性

ClassMethod MKPILoginAdd(ByRef array) As %Status
{
	n (array)
	k ^DHCWL.MKPI.MKPILoginI
	d ##class(DHCWL.MKPI.MKPILogin).%BuildIndices()
	if ((array("MKPIDr")="")||(array("LoginTypeDr")="")){
		q "指标或日志类型不存在"
	}
	if (('$d(^DHCWL.MKPI.MKPID(array("MKPIDr"))))||('$d(^DHCWL.MKPI.APPLibraryD(array("LoginTypeDr"))))) {
		q "指标或日志类型不存在"
	}
	TStart
	s mPList(2) = array("MKPIDr")
	s mPList(3) = array("LoginTypeDr")
	s mPList(4) = array("ActiveFlag")
	&sql(insert into DHCWL_MKPI.MKPILogin values mPList())
	i $g(SQLCODE)=0 d
	.TCOMMIT
	e  d
	.TROLLBACK
	
	q $g(SQLCODE)
}

//^DHCWL.MKPI.MKPILoginI("MKPIDr")

//kpiId用来记录要删除的数据的指标Id

ClassMethod MKPILoginDelete(kpiId) As %Status
{
	n (kpiId)
	q:(""=kpiId) -1	//删除失败
	q:'$d(^DHCWL.MKPI.MKPILoginI("MKPIDr",kpiId)) 0
	&sql(delete from DHCWL_MKPI.MKPILogin where MKPIDr=:kpiId)
	
	q $g(SQLCODE)
}

ClassMethod MKPILoginUpdate(ByRef array) As %Status
{
	n (array)
	//k ^DHCWL.MKPI.MKPILoginI
	//d ##class(DHCWL.MKPI.MKPILogin).%BuildIndices()
	s flag=0
	s mkpiLoginId=""
	s mkpiDr=array("MKPIDr"), loginTypeDr=array("LoginTypeDr"), value=array("ActiveFlag")
	s mkpiLoginId=$o(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",loginTypeDr,mkpiDr,mkpiLoginId))
	;w "loginTypeDr="_loginTypeDr_"  mkpiDr="_mkpiDr_"   mkpiLoginId="_mkpiLoginId,!
	if ((mkpiLoginId'="")&&($d(^DHCWL.MKPI.MKPILoginD(mkpiLoginId)))){
		&sql(update DHCWL_MKPI.MKPILogin set ActiveFlag=:value where id=:mkpiLoginId)
	}else{
		q "不存在该配置项：loginTypeDr="_loginTypeDr_"  mkpiDr="_mkpiDr
	}
	q flag
}

/// ##class(DHCWL.MKPILogin.MKPILoginService).MKPILoginQuery("1","KpiLogDefinition")
ClassMethod MKPILoginQuery(kpiId = "", logType = "", pageSize = "100") As DHCWL.util.Json
{
	b
	n (kpiId, logType, pageSize)
	s logTypeDr=""
	i (""'=logType) s logTypeDr=$o(^DHCWL.MKPI.APPLibraryI("AppForCodeI",$zcvt("LoginType","U"),$zcvt(logType,"U"),""))
	s counter=0
	s currentKpiId="" f  s currentKpiId=$o(^DHCWL.MKPI.MKPILoginI("MKPIDr",currentKpiId),-1) q:currentKpiId=""  d
	.;q:(""'=logType)&&(0=$d(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",logTypeDr,currentKpiId)))
	.q:(""'=logType)&&(0=(##class(DHCWL.MKPILogin.MKPILoginService).IsActive(logTypeDr,currentKpiId)))
	.q:((kpiId'="")&&(kpiId'=currentKpiId))  	//edited by lhh
	.q:('$d(^DHCWL.MKPI.MKPID(currentKpiId)))   	//edited by lhh
	.s counter=counter+1
	.q:(""'=pageSize)&&(pageSize<counter)
	.s arrs(counter,"kpiCode")=$lg(^DHCWL.MKPI.MKPID(currentKpiId),2)
	.s rowId="" f  s rowId=$o(^DHCWL.MKPI.MKPILoginI("MKPIDr",currentKpiId,rowId),-1) q:rowId=""  d
	..s loginTypeDr=$lg(^DHCWL.MKPI.MKPILoginD(rowId),3)
	..q:((loginTypeDr="")||(+loginTypeDr<0))
	..s loginTypeCode=##class(DHCWL.MKPI.APPLibrary).GetCodeById(loginTypeDr)
	..s loginTypeCode=$p(loginTypeCode,"||",2)
	..;q:(""'=logType)&&(logType'=loginTypeCode)
	..s activeFlag=$lg(^DHCWL.MKPI.MKPILoginD(rowId),4)
	..s arrs(counter,loginTypeCode)=activeFlag
	if ($d(arrs)) s json=##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.arrs)
	q $g(json)
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	断言指定的"日志类型"、"指标"的日志是否存在，如果存在并且激活返回1. 否则返回0
/// Table:			
/// Input:			loginTypeDr:日志类型(DHCWL_MKPI.DHCWLMKPIAPPLibrary表中AppFor="LoginType"的)Id, mkpiDr:指标Id
/// Output:
/// Return:			1:日志配置存在且激活; 0:日志不存在或存在但未激活			
/// HowToUse:		##class(DHCWL.MKPILogin.MKPILoginService).IsActive(17,1)
/// Other:
ClassMethod IsActive(loginTypeDr, mkpiDr) As %Boolean
{
	n (loginTypeDr, mkpiDr)
	/// 不存在指定"日志类型","指标"的日志配置项,则退出
	q:(loginTypeDr="")||(mkpiDr="") 0
	q:'$d(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",loginTypeDr,mkpiDr)) 0
	s mkpiLoginId=$o(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",loginTypeDr,mkpiDr,""))
	q:""=mkpiLoginId 0
	s activeFlag=$lg(^DHCWL.MKPI.MKPILoginD(mkpiLoginId),4)
	s rtnValue=$case(activeFlag,"true":1,"false":0,"":0)
	q rtnValue
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	通过指标日志的局部配置和全局配置，断言是否应该记录指标日志。断言规则如下：
/// 					“如果指标定义了局部配置，那就采用局部配置；如果指标未定义局部配置，
/// 					那就采用全局配置；如果全局配置也未定义则不记录日志。特别的当指标Id为空时，
/// 					查看全局配置，未定义，则不记录日志。”
/// Table:			
/// Input:			loginType:日志类型,可取的值为{"KpiLogDefinition","KpiLogDataProcess","KpiLogDataQuery","KpiLogTaskErr"}
/// 					kpiId:指标Id或Code
/// Output:			
/// Return:			rtnValue:{1:记录日志; 0:不记录日志}
/// HowToUse:		w ##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged(loginType, kpiId)
/// 	Other:			
ClassMethod ShouldBeLogged(loginType, kpiId = "") As %Boolean
{
	n (loginType, kpiId)
	q:(""=loginType) 0
	s rtnValue=0
	s kpiId=##class(DHCWL.Interface.MkpiData).ToKpiId($g(kpiId),",")
	s loginType=$zcvt(loginType,"U"), globalLoginType="GLOBAL"_loginType_"CFG"
	q:(0=$d(^DHCWL.MKPI.APPLibraryI("AppForCodeI","LOGINTYPE",loginType))) 0
	s loginTypeDr=$o(^DHCWL.MKPI.APPLibraryI("AppForCodeI","LOGINTYPE",loginType,""))
	if (""'=($g(kpiId))&&(0'=$d(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",loginTypeDr,kpiId)))) {
		//	查看局部配置确定是否记录日志
		s loginCfgRowId=$o(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",loginTypeDr,kpiId,""))
		s activeFlag=$lg(^DHCWL.MKPI.MKPILoginD(loginCfgRowId),4)
		s rtnValue=$case(activeFlag,"true":1,"false":0,"":0)
	}elseif(0'=$d(^DHCWL.MKPI.SysVariablesI("CodeDateTime",globalLoginType))) {
		//	查看全局配置确定是否记录日志
		s date=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",globalLoginType,""),-1)
		s time=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",globalLoginType,date,""),-1)
		s globalLogCfgRowId=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",globalLoginType,date,time,""),-1)
		s activeFlag=$lg(^DHCWL.MKPI.SysVariablesD(globalLogCfgRowId),4)
		s rtnValue=$case(activeFlag,"true":1,"false":0,"":0)
	}else{
		//	不记录日志
		s rtnValue=0
	}
	q rtnValue
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	kpiCode为空，查询所有未定义日志局部配置的指标；否则：如果kpiCode对应的指标定义了
/// 					日志局部配置,则返回空；否则返回该指标。
/// Table:			
/// Input:			kpiCode:指标编码
/// Output:			
/// Return:			
/// HowToUse:		d ##class(DHCWL.MKPILogin.MKPILoginService).IsNotCfgKpi()
/// 	Other:			用于定义指标日志局部配置时提供待选指标集
ClassMethod IsNotCfgKpi(kpiCode = "") As DHCWL.util.Json
{
	n (kpiCode)
	s id=""
	i ""'=$g(kpiCode) s id=$o(^DHCWL.MKPI.MKPII("MKPICode",$zcvt(kpiCode,"U"),""))
	s num=1
	s kpiId="" f  s kpiId=$o(^DHCWL.MKPI.MKPID(kpiId)) q:kpiId=""  d
	.q:(0'=$d(^DHCWL.MKPI.MKPILoginI("MKPIDr",kpiId)))
	.q:(""'=id)&&(id'=kpiId)
	.s arrs(num,"ID")=kpiId
	.s arrs(num,"kpiCode")=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	.s arrs(num,"kpiName")=$lg(^DHCWL.MKPI.MKPID(kpiId),3)
	.s kpiFlId=$lg(^DHCWL.MKPI.MKPID(kpiId),9)
	.i ((0=+kpiFlId)||('$d(^DHCWL.MKPI.MKPIFLD(kpiFlId)))) s kpiFl=""
	.e  s kpiFl=$lg(^DHCWL.MKPI.MKPIFLD(kpiFlId),3)
	.s arrs(num,"category")=kpiFl
	.s secId=$lg(^DHCWL.MKPI.MKPID(kpiId),11)
	.i ((0=+secId)||('$d(^DHCWL.MKPI.SectionD(secId)))) s section=""
	.e  s section=$lg(^DHCWL.MKPI.SectionD(secId),4)
	.s arrs(num,"section")=section
	.s num=num+1
	if ($d(arrs)) s json=##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.arrs)
	q $g(json)
}

/// Creator:		JEFF
/// CreatDate:		
/// Description:	1、功能增强型方法。原有的方法（IsNotCfgKpi）中参数kpiCode只能包含单个kpi的code。这个方法的参数kpiIds，可以
/// 					包含多个kpi的id，id直接用“,”隔开。
/// Table:			
/// Input:			kpiIds-指标ID
/// Output:			
/// Return:			
/// HowToUse:		d ##class(DHCWL.MKPILogin.MKPILoginService).IsNotCfgKpi2("1,2")
/// 	Other:			用于定义指标日志局部配置时提供待选指标集
ClassMethod IsNotCfgKpi2(kpiIds = "") As DHCWL.util.Json
{
	n (kpiIds)
	q:(kpiIds=-1) ""   	;没有对应的kpiID时，直接返回0
	s len=$l(kpiIds,",")
	s num=1
	f i=1:1:len d
	.s id=$p(kpiIds,",",i)
	.s kpiId="" f  s kpiId=$o(^DHCWL.MKPI.MKPID(kpiId)) q:kpiId=""  d
	..q:(0'=$d(^DHCWL.MKPI.MKPILoginI("MKPIDr",kpiId)))
	..q:(""'=id)&&(id'=kpiId)
	..s arrs(num,"ID")=kpiId
	..s arrs(num,"kpiCode")=$lg(^DHCWL.MKPI.MKPID(kpiId),2)
	..s arrs(num,"kpiName")=$lg(^DHCWL.MKPI.MKPID(kpiId),5)
	..s kpiFlId=$lg(^DHCWL.MKPI.MKPID(kpiId),9)
	..i ((0=+kpiFlId)||('$d(^DHCWL.MKPI.MKPIFLD(kpiFlId)))) s kpiFl=""
	..e  s kpiFl=$lg(^DHCWL.MKPI.MKPIFLD(kpiFlId),3)
	..s arrs(num,"category")=kpiFl
	..s secId=$lg(^DHCWL.MKPI.MKPID(kpiId),11)
	..i ((0=+secId)||('$d(^DHCWL.MKPI.SectionD(secId)))) s section=""
	..e  s section=$lg(^DHCWL.MKPI.SectionD(secId),4)
	..s arrs(num,"section")=section
	..s num=num+1
	if ($d(arrs)) s json=##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.arrs)
	
	q $g(json)
}

/// Creator:		wz
/// CreatDate:		2014-3-21
/// Description:	1、功能增强型方法。原有的方法（MKPILoginQuery）中参数kpiId只能包含单个kpi的ID。这个方法的参数kpiIds，可以
/// 					包含多个kpi的id，id直接用“,”隔开。
/// 					2、返回日志查询结果
/// Table:			
/// Input:			
/// Output:
/// Return:			DHCWL.util.Json对象			
/// HowToUse:		
/// Other:
/// ##class(DHCWL.MKPILogin.MKPILoginService).MKPILoginQuery("1","KpiLogDefinition")
ClassMethod MKPILoginQuery2(kpiIds = "", logType = "", pageSize = "100") As DHCWL.util.Json
{
	n (kpiIds, logType, pageSize)
	s logTypeDr=""
	q:(kpiIds=-1) 0   	;没有对应的kpiID时，直接返回0
	i (""'=logType) s logTypeDr=$o(^DHCWL.MKPI.APPLibraryI("AppForCodeI",$zcvt("LoginType","U"),$zcvt(logType,"U"),""))
	s len=$l(kpiIds,",")
	s counter=0
	f i=1:1:len d
	.s kpiId=$p(kpiIds,",",i)	
	.s currentKpiId="" f  s currentKpiId=$o(^DHCWL.MKPI.MKPILoginI("MKPIDr",currentKpiId),-1) q:currentKpiId=""  d
	..;q:(""'=logType)&&(0=$d(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",logTypeDr,currentKpiId)))
	..q:(""'=logType)&&(0=(##class(DHCWL.MKPILogin.MKPILoginService).IsActive(logTypeDr,currentKpiId)))
	..q:((kpiId'="")&&(kpiId'=currentKpiId))  	//edited by lhh
	..q:('$d(^DHCWL.MKPI.MKPID(currentKpiId)))   	//edited by lhh
	..s counter=counter+1
	..q:(""'=pageSize)&&(pageSize<counter)
	..s arrs(counter,"kpiCode")=$lg(^DHCWL.MKPI.MKPID(currentKpiId),2)
	..s rowId="" f  s rowId=$o(^DHCWL.MKPI.MKPILoginI("MKPIDr",currentKpiId,rowId),-1) q:rowId=""  d
	...s loginTypeDr=$lg(^DHCWL.MKPI.MKPILoginD(rowId),3)
	...q:((loginTypeDr="")||(+loginTypeDr<0))
	...s loginTypeCode=##class(DHCWL.MKPI.APPLibrary).GetCodeById(loginTypeDr)
	...s loginTypeCode=$p(loginTypeCode,"||",2)
	...;q:(""'=logType)&&(logType'=loginTypeCode)
	...s activeFlag=$lg(^DHCWL.MKPI.MKPILoginD(rowId),4)
	...s arrs(counter,loginTypeCode)=activeFlag
	
	
	if ($d(arrs)) s json=##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.arrs)
	q $g(json)
}

ClassMethod MKPILoginErrQuery(kpiIDList = "", CalledFunction = "", ParaKpiRule = "", ParaFilterRule = "", ParaDateScope = "", ParaOther = "")
{
	n (kpiIDList,CalledFunction,ParaKpiRule,ParaFilterRule,ParaDateScope,ParaOther)
	s kpiID=""
	s len=$l(kpiIDList,",")
	f i=1:1:len{
		s kpi=$p(kpiIDList,",",i)	
		continue:kpi=""
		s kpiID=$p(kpi,":",1)
		continue:kpiID=""
		i '$d(kpiIDs) s kpiIDs=kpiID
		e  s kpiIDs=kpiIDs_","_kpiID
	}
	i (kpiIDs'=""){
		s login("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDataQuery")
		s login("CalledFunction")=CalledFunction
		s login("Operator")=""
		s login("MKPIIdList")=kpiIDs
		s login("ParaKpiRule")=""
		s login("ParaFilterRule")=ParaFilterRule
		s login("ParaDateScope")=ParaDateScope
		s login("ParaOther")=ParaKpiRule
		s login("OperateState")="error occured!"
		s login("OtherContent")=ParaOther
		s jsonStr=##class(DHCWL.MKPILogin.LoginService).ArrayToJsonStr(.login)
		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
		s status=loginService.LoginStart("KpiLogDataQuery","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
		s status=loginService.LoginContent(jsonStr)
		s status=loginService.LoginEnd()
	}
}

}
