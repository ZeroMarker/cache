/// Creator    : wk 
/// CreatDate  : 2018-03-09
/// Desc       : 指标日志维护方法
Class web.DHCWL.V1.KPI.LogFunction Extends %RegisteredObject
{

/// Creator    : wk
/// CreatDate  : 2018-07-02
/// Desc       : 删除日志的局部配置
/// Other      : do ##Class(web.DHCWL.V1.KPI.LogFunction).DeleteKPILogConfig("K0694")
ClassMethod DeleteKPILogConfig(kpisCodeStr)
{
	//	日志记录模块
	s loginOperator=$g(%session.Data("LOGON.USERNAME"))
	//s ^TEMPDHCWL("wk","log")=loginOperator
	s loginLoginTypeDr=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDefinition")
	//	日志记录模块
	
	// 删除时可删除多条数据
	set length=$l(kpisCodeStr,";")
	set errorInfo="删除失败的指标代码："
	for nod=1:1:length {
		set tip="ok"
		set kpiCode=$p(kpisCodeStr,";",nod)
		set kpiId=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCode)
		
		//	日志记录模块
		s loginPrePropertyList="指标已激活的日志配置项："
		s appLibLoginType="" f  s appLibLoginType=$o(^DHCWL.MKPI.APPLibraryI("AppForCodeI","LOGINTYPE",appLibLoginType)) q:appLibLoginType=""  d
		.s loginTypeDr=$o(^DHCWL.MKPI.APPLibraryI("AppForCodeI","LOGINTYPE",appLibLoginType,""))
		.s loginText=$li(^DHCWL.MKPI.APPLibraryD(loginTypeDr),4)
		.q:'$d(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",loginTypeDr,kpiId))
		.s mkpiLoginRowId=$o(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",loginTypeDr,kpiId,""))
		.q:mkpiLoginRowId=""
		.s activeFlag=$li(^DHCWL.MKPI.MKPILoginD(mkpiLoginRowId),4)
		.i activeFlag="true" s loginPrePropertyList=loginPrePropertyList_loginText_","
		//	日志记录模块
		
		set status=##class(DHCWL.MKPILogin.MKPILoginService).MKPILoginDelete(kpiId)
		if status'=0 {
			set errorInfo=errorInfo_kpiCode_","
			set tip="error"
		}
		
		//	日志记录模块
		s loginMKPIIdList=kpiId
		s loginPostPropertyList="指标日志配置项已删除"
		s jsonStr="{Operator:'"_loginOperator_"',MKPIIdList:'"_loginMKPIIdList_"',LoginTypeDr:'"_loginLoginTypeDr_"',PrePropertyList:'"_loginPrePropertyList_"',PostPropertyList:'"_loginPostPropertyList_"'}"
		s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDefinition", "")
		i (("ok"=tip)&&(1=shouldBeLogged)) {
			s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
			s status=loginService.LoginStart("KpiLogDefinition","")	;这里给个初值，最终取值根据LoginContent()方法确定
			s status=loginService.LoginContent(jsonStr)
			s status=loginService.LoginEnd()
		}
		//	日志记录模块
	}
	i ("删除失败的指标代码："'=errorInfo) {
		s tip=errorInfo
		//w "{success:false,tip:删除过程中出错的指标代码：'"_tip_"'}"
		q "删除过程中出错的指标代码："_tip
	}
	elseif ("删除失败的指标代码："=errorInfo){
		s tip="ok"
		//w "{success:true,tip:'"_tip_"'}"
		q "删除成功"
	}
}

/// Creator    : wk
/// CreatDate  : 2018-07-04
/// Desc       : 获取除了已配置指标外的其他指标
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.LogFunction","GetAllKPINOCFGQuery",kpiIDs)
Query GetAllKPINOCFGQuery(kpiCodes As %String, filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:指标ID,kpiCode:%String:指标编码,kpiName:%String:指标名称,creator:%String:创建者,flName:%String:类型名称") [ SqlProc ]
{
}

ClassMethod GetAllKPINOCFGQueryExecute(ByRef qHandle As %Binary, kpiCodes As %String = "", filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
 	s ind=1
 	s:filterValue'="" filterValue=$ZCVT(filterValue,"U")
 	
	//s sql="SELECT a.ID,MKPI_Code,MKPI_Name,MKPI_User,b.MKPIFL_Name FROM DHCWL_MKPI.DHCWLMKPI a,DHCWL_MKPI.DHCWLMKPIFL b WHERE a.MKPI_Cate=b.ID"
	s sql="SELECT a.ID,MKPI_Code,MKPI_Name,MKPI_User,b.MKPIFL_Name FROM DHCWL_MKPI.DHCWLMKPI a LEFT JOIN DHCWL_MKPI.DHCWLMKPIFL b ON a.MKPI_Cate=b.ID"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	s deli=",",str="['',''],"
	While(rs.Next()){
		s ID=rs.Data("ID")
		s kpiCode=rs.Data("MKPI_Code")
		s kpiName=rs.Data("MKPI_Name")
		s creator=rs.Data("MKPI_User")
		s flName=rs.Data("MKPIFL_Name")
		continue:kpiCodes[kpiCode
		continue:((filterValue'="")&&($zcvt(kpiCode,"U")'[filterValue)&&($zcvt(kpiName,"U")'[filterValue)&&($zcvt(creator,"U")'[filterValue)&&($zcvt(flName,"U")'[filterValue))
		s ^CacheTemp(repid,ind)=$lb(rs.Data("ID"),rs.Data("MKPI_Code"),rs.Data("MKPI_Name"),rs.Data("MKPI_User"),rs.Data("MKPIFL_Name"))
		s ind=ind+1
	}
	d rs.Close()
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-07-03
/// Desc       : 新增日志局部配置
/// Other      : do ##Class(web.DHCWL.V1.KPI.LogFunction).AddKPILogCfg()
ClassMethod AddKPILogCfg(kpiCode, defineValue, processValue, queryValue, errorValue)
{
	set kpiId=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCode)
	s array("MKPIDr")=kpiId
	///	当所选择的指标Id不为空，且该指标不存在日志配置才插入一条新的日志配置
	if (""'=array("MKPIDr")) set isCfgExist=$d(^DHCWL.MKPI.MKPILoginI("MKPIDr",array("MKPIDr")))
	else  set isCfgExist=1
	set type("KpiLogDefinition")=defineValue
	set type("KpiLogDataProcess")=processValue
	set type("KpiLogDataQuery")=queryValue
	set type("KpiLogTaskErr")=errorValue
	
	set nod="", nod=$o(type(nod)), tip=0
	while(""'=nod)&&(0=isCfgExist){
		set array("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||"_nod)
		if (array("LoginTypeDr")="") {
			set nod=$o(type(nod))
			continue	
		}
		set array("ActiveFlag")=type(nod)
		set status=##class(DHCWL.MKPILogin.MKPILoginService).MKPILoginAdd(.array)
		set nod=$o(type(nod))
		if status'=0 set tip=status
	}
	if (0'=isCfgExist){
		s tip="您指定的指标不存在或已有日志配置，您不能再为其增加日志配置项！"
		//w "{success:true,tip:'"_"您指定的指标不存在或已有日志配置，您不能再为其增加日志配置项！"_"'}"
	}elseif (0=tip){
		set tip="ok"
		//w "{success:true,tip:'"_tip_"'}"
	}else{
		s tip="新增指标日志配置时发生错误，错误代码为："_tip
		//w "{success:false,tip:新增指标日志配置时发生错误，错误代码为：'"_tip_"'}"	
	}
	
	//	日志记录模块
	s loginOperator=""
	s loginLoginTypeDr=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDefinition")
	s loginMKPIIdList=array("MKPIDr")
	
	//	日志记录模块
	s loginPrePropertyList="指标已激活的日志配置项："
	i type("KpiLogDefinition")="true" s loginPrePropertyList=loginPrePropertyList_"指标定义日志,"
	i type("KpiLogDataProcess")="true" s loginPrePropertyList=loginPrePropertyList_"数据处理日志,"
	i type("KpiLogDataQuery")="true" s loginPrePropertyList=loginPrePropertyList_"数据查询日志,"
	i type("KpiLogTaskErr")="true" s loginPrePropertyList=loginPrePropertyList_"任务错误日志,"
	
	s jsonStr="{Operator:'"_loginOperator_"',MKPIIdList:'"_loginMKPIIdList_"',LoginTypeDr:'"_loginLoginTypeDr_"',PrePropertyList:'"_loginPrePropertyList_"'}"
	
	s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDefinition", array("MKPIDr"))
	i (("ok"=tip)&&(1=shouldBeLogged)) {
		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
		s status=loginService.LoginStart("KpiLogDefinition","",0)	;这里给个初值，最终取值根据LoginContent()方法确定
		s status=loginService.LoginContent(jsonStr)
		s status=loginService.LoginEnd()
	}
	q tip
}

/// Creator    : wk
/// CreatDate  : 2018-07-03
/// Desc       : 更新日志局部配置(将多个指标的配置分开保存)
/// Other      : do ##Class(web.DHCWL.V1.KPI.LogFunction).UpDateKPILogMain()
ClassMethod UpDateKPILogMain(logConfigRules, type As %String = "")
{
	q:logConfigRules="" "获取配置信息失败"
	s ruleLen=$l(logConfigRules,"||")
	s sc=""
	for i=1:1:ruleLen {
		s logConfigRule=$p(logConfigRules,"||",i)
		s kpiCode=$p(logConfigRule,",",1)
		s defineLog=$p(logConfigRule,",",2)
		s handlerLog=$p(logConfigRule,",",3)
		s inquireLog=$p(logConfigRule,",",4)
		s errorLog=$p(logConfigRule,",",5)
		if (type="add"){
			s sc=##Class(web.DHCWL.V1.KPI.LogFunction).AddKPILogCfg(kpiCode,defineLog,handlerLog,inquireLog,errorLog)
		}else{
			s sc=##Class(web.DHCWL.V1.KPI.LogFunction).UpDateKPILogConfig(kpiCode,defineLog,handlerLog,inquireLog,errorLog)
		}
		q:(sc'="ok")
	}
	if (sc="ok"){
		q "保存成功"
	}else{
		q "保存失败"
	}
}

/// Creator    : wk
/// CreatDate  : 2018-07-03
/// Desc       : 更新日志局部配置
/// Other      : do ##Class(web.DHCWL.V1.KPI.LogFunction).UpDateKPILogConfig()
ClassMethod UpDateKPILogConfig(kpiCode As %String, defineLog As %String, handlerLog As %String, inquireLog As %String, errorLog As %String)
{
	set kpiId=##class(DHCWL.MKPIService.ConfigService).GetKPIIdStrByCode(kpiCode)
	s array("MKPIDr")=kpiId
	//	日志记录模块
	s loginOperator=""
	s loginLoginTypeDr=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||KpiLogDefinition")
	s loginMKPIIdList=array("MKPIDr")
	
	s loginPrePropertyList="指标已激活的日志配置项："
	s appLibLoginType="" f  s appLibLoginType=$o(^DHCWL.MKPI.APPLibraryI("AppForCodeI","LOGINTYPE",appLibLoginType)) q:appLibLoginType=""  d
	.s loginTypeDr=$o(^DHCWL.MKPI.APPLibraryI("AppForCodeI","LOGINTYPE",appLibLoginType,""))
	.s loginText=$li(^DHCWL.MKPI.APPLibraryD(loginTypeDr),4)
	.q:'$d(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",loginTypeDr,loginMKPIIdList))
	.s mkpiLoginRowId=$o(^DHCWL.MKPI.MKPILoginI("LoginTypeMKPIDr",loginTypeDr,loginMKPIIdList,""))
	.q:mkpiLoginRowId=""
	.s activeFlag=$li(^DHCWL.MKPI.MKPILoginD(mkpiLoginRowId),4)
	.i activeFlag="true" s loginPrePropertyList=loginPrePropertyList_loginText_","
	//	日志记录模块
	
	set type("KpiLogDefinition")=defineLog
	set type("KpiLogDataProcess")=handlerLog
	set type("KpiLogDataQuery")=inquireLog
	set type("KpiLogTaskErr")=errorLog
	
	set nod="", nod=$o(type(nod)), tip=0
	while(""'=nod){
		set array("LoginTypeDr")=##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||"_nod)
		set array("ActiveFlag")=type(nod)
		set status=##class(DHCWL.MKPILogin.MKPILoginService).MKPILoginUpdate(.array)
		set nod=$o(type(nod))
		if status'=0 set tip=status
	}
	
	if tip=0 set tip="ok"
	
	
	//	日志记录模块
	s loginPostPropertyList="指标已激活的日志配置项："
	i type("KpiLogDefinition")="true" s loginPostPropertyList=loginPostPropertyList_"指标定义日志,"
	i type("KpiLogDataProcess")="true" s loginPostPropertyList=loginPostPropertyList_"数据处理日志,"
	i type("KpiLogDataQuery")="true" s loginPostPropertyList=loginPostPropertyList_"数据查询日志,"
	i type("KpiLogTaskErr")="true" s loginPostPropertyList=loginPostPropertyList_"任务错误日志,"
	
	s jsonStr="{Operator:'"_loginOperator_"',MKPIIdList:'"_loginMKPIIdList_"',LoginTypeDr:'"_loginLoginTypeDr_"',PrePropertyList:'"_loginPrePropertyList_"',PostPropertyList:'"_loginPostPropertyList_"'}"
	
	s shouldBeLogged=##class(DHCWL.MKPILogin.MKPILoginService).ShouldBeLogged("KpiLogDefinition", array("MKPIDr"))
	
	i (("ok"=tip)&&(1=shouldBeLogged)&&(loginPrePropertyList'=loginPostPropertyList)) {
		s loginService=##class(DHCWL.MKPILogin.LoginService).%New()
		s status=loginService.LoginStart("KpiLogDefinition","")	;这里给个初值，最终取值根据LoginContent()方法确定
		s status=loginService.LoginContent(jsonStr)
		s status=loginService.LoginEnd()
	}
	
	q tip
}

/// Creator    : wk
/// CreatData  : 2018-07-05
/// CreatDesc  : 日志展示query
/// Other      : do ##Class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.LogFunction","")
Query GetLogInforQuery(loginType As %String = "", startDate As %String = "", endDate As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,loginDate:%String:日志日期,loginSTime:%String:开始日期,loginETime:%String:结束日期,operator:%String:操作用户,loginTypeDr:%String:日志类型,calledFunction:%String:调用方法,MKPIIdList:%String:指标列表,prePropertyList:%String:原属性,PostPropertyList:%String:新属性,ParaKpiRule:%String:取数规则,paraFilterRule:%String:过滤规则,paraDateScope:%String:日期属性,paraOther:%String:其他参数,operateState:%String:操作后的状态,OtherContent:%String:其他信息") [ SqlProc ]
{
}

ClassMethod GetLogInforQueryExecute(ByRef qHandle As %Binary, loginType As %String = "", startDate As %String = "", endDate As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s sDate="",eDate=""
    i (startDate'="")&&(endDate'="") s sDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(startDate),eDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
   	//s:endDate="" endDate=$p($h,",",1)
   	//s:startDate="" startDate=endDate-90
   	i (sDate'="")&&(eDate'="")&&((sDate-eDate)>0) q $$$OK
   	do ##class(web.DHCWL.V1.KPI.LogFunction).GetLogInforCfg(loginType,sDate,eDate,.data)
   	s order=""
   	for {
	   	s order=$o(data(order))
	   	q:order=""
	   	s ^CacheTemp(repid,ind)=$lb(data(order,"ID"),data(order,"LoginDate"),data(order,"LoginSTime"),data(order,"LoginETime"),data(order,"Operator"),data(order,"LoginTypeDr"),data(order,"CalledFunction"),data(order,"MKPIIdList"),data(order,"PrePropertyList"),data(order,"PostPropertyList"),data(order,"ParaKpiRule"),data(order,"ParaFilterRule"),data(order,"ParaDateScope"),data(order,"ParaOther"),data(order,"OperateState"),data(order,"OtherContent"))
		s ind=ind+1
   	}
	Quit $$$OK
}

/// do ##Class(web.DHCWL.V1.KPI.LogFunction).test() 
ClassMethod GetLogInforCfg(loginType, sDate, eDate, ByRef arrs)
{
	//set startDate="",endDate=""
	set:loginType="" loginType="KpiLogDefinition"
	set kpiId=""
	set loginTypeCode = ##class(DHCWL.MKPI.APPLibrary).GetIdByCode("LoginType||"_loginType)
	q:(loginTypeCode="") 0
	//i (startDate'="")&&(endDate'="") s sDate=##class(DHCWL.CommonUtil.DateUtil).DateHtmlToLogical(startDate),eDate=##class(websys.Conversions).DateHtmlToLogical(endDate)
	//q:endDate<startDate 0
	s propertyList="ID^LoginDate^LoginSTime^LoginETime^Operator^LoginTypeDr^CalledFunction^MKPIIdList^PrePropertyList^PostPropertyList^ParaKpiRule^ParaFilterRule^ParaDateScope^ParaOther^OperateState^OtherContent"
	s len=$l(propertyList,"^"), counter=0
	
	s loginDate="" f  s loginDate=$o(^DHCWL.MKPI.LoginInfoI("LoginTypeDate",loginTypeCode,loginDate),-1) q:loginDate=""  d
	.q:($g(sDate)'="")&&($g(eDate)'="")&&((loginDate<$g(sDate))||(loginDate>$g(eDate))) 
	.s loginRowId="" f  s loginRowId=$o(^DHCWL.MKPI.LoginInfoI("LoginTypeDate",loginTypeCode,loginDate,loginRowId),-1) q:loginRowId=""  d
	..s iskpiIdIncluded="FALSE"	;指定的指标是否在当前的这条日志的指标列表(表DHCWL_MKPI.LoginInfo中的MKPIIdList)中
	..i (kpiId'="") d
	...s mkpiIdList=$lg(^DHCWL.MKPI.LoginInfoD(loginRowId),8)
	...s lenOfMkpiIdList=$l(mkpiIdList,",")
	...f pointer=1:1:lenOfMkpiIdList d
	....s currentMkpi=$p(mkpiIdList,",",pointer)
	....i (currentMkpi=kpiId) s iskpiIdIncluded="TRUE", pointer=lenOfMkpiIdList
	..q:(kpiId'="")&&(iskpiIdIncluded="FALSE")
	..s counter=counter+1
	..s arrs(counter,"ID")=loginRowId
	..f nod=2:1:len d
	...s currentProperty=$p(propertyList,"^",nod)
	...s currentValue=$li(^DHCWL.MKPI.LoginInfoD(loginRowId),nod)
	...;i (nod=2) s currentValue=$zd(currentValue,3)   ////++//modify by wk~2017-03-03~公司时间控件标准化
	...i (nod=2) s currentValue=##class(DHCWL.CommonUtil.DateUtil).DateLogicalToHtml(currentValue)
	...i (nod=3)||(nod=4) s currentValue=$zt(currentValue,1)
	...i (nod=6) s currentValue=$li(^DHCWL.MKPI.APPLibraryD(currentValue),4)
	...s arrs(counter,currentProperty)=$tr(currentValue,"^","∧")
}

}
