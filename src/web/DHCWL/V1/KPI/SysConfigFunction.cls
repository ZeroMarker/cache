/// Creator    : wk
/// CreatDate  : 2018-08-30
/// Desc       : 指标系统配置界面功能实现
Class web.DHCWL.V1.KPI.SysConfigFunction Extends %RegisteredObject
{

/// Creator    : wk
/// CreatDate  : 2018-07-16
/// Desc       : 获取过滤函数
/// Other      : do ##class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.SysConfigFunction","GetFilterFunQuery")
Query GetFilterFunQuery(filterValue As %String = "") As websys.Query(ROWSPEC = "ID:%String:ID,funName:%String:过滤名称,funDesc:%String:过滤描述,funType:%String:过滤类型,funExeCode:%String:执行代码") [ SqlProc ]
{
}

ClassMethod GetFilterFunQueryExecute(ByRef qHandle As %Binary, filterValue As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s:filterValue'="" filterValue=$ZCVT(filterValue,"U")
	s filterFuncId=""
	//s ^CacheTemp(repid,ind)=$lb("1","hh","不小于","INTERNAL","tt")
	//s ind=ind+1
	for{
		s filterFuncId=$o(^DHCWL.MKPI.SysFilterFuncD(filterFuncId))
		q:(""=filterFuncId)
		s obj=##class(DHCWL.MKPI.SysFilterFunc).%OpenId(filterFuncId)
		continue:(""=obj)
		s funName=$tr(obj.FilterFuncCode,"'","‘")
		s funType=obj.FilterFuncPrototype
		s funExeCode=$tr(obj.FilterFuncExecCode,"^","∧")
		s:funExeCode="'>" funExeCode="‘>"
		s funDesc=obj.FilterFuncFuncDesc
		continue:((filterValue'="")&&(($ZCVT(funName,"U") '[ filterValue))&&($ZCVT(funType,"U") '[ filterValue)&&($ZCVT(funExeCode,"U") '[ filterValue)&&($ZCVT(funDesc,"U") '[ filterValue))
		s ^CacheTemp(repid,ind)=$lb(filterFuncId,funName,funDesc,funType,funExeCode)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator      : wk
/// CreatDesc    : 新增过滤函数
/// CreatDate    : 2018-07-17
/// Other        : do ##Class(web.DHCWL.V1.KPI.SysConfigFunction).AddFilterFun()
ClassMethod AddFilterFun(code, funcPrototype, execCode, funcDesc)
{
	i $f(execCode,"class(")&&$f(execCode,".") s execCode="##"_execCode
	s obj=##class(DHCWL.SysService.SysFilterFunc).BuildFilterFuncObj("",code,funcPrototype,execCode,funcDesc)
	s result=##class(DHCWL.SysService.SysFilterFunc).Insert(obj)
	if (1=result){
		s result="操作成功"
	}
	q result
}

/// Creator    : wk
/// CreatDate  : 2018-07-06
/// Desc       : 获取执行代码
/// do ##Class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.SysConfigFunction","GetExeCodeQuery")
Query GetExeCodeQuery(filterValue As %String) As websys.Query(ROWSPEC = "subType:%String:执行代码子类型,active:%String:默认激活,desc:%String:描述,exeCode:%String:执行代码") [ SqlProc ]
{
}

ClassMethod GetExeCodeQueryExecute(ByRef qHandle As %Binary, filterValue As %String) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    s:filterValue'="" filterValue=$ZCVT(filterValue,"U")
    s rs=##Class(web.DHCWL.V1.KPI.SysConfigFunction).GetExeCodeInfor()
	While(rs.Next()){
		s type=rs.Data("ExcCode_SubType")
		s secID=$o(^DHCWL.MKPI.SectionI("SecCode",type,""))
		s:secID'="" type=$lg(^DHCWL.MKPI.SectionD(secID),4)
		s flag=rs.Data("ExcCode_DefaultFlag")
		s desc=rs.Data("ExcCode_Description")
		s exeCode=rs.Data("ExcCode_Write")
		continue:(filterValue'="")&&($ZCVT(type,"U") '[ filterValue)&&($ZCVT(flag,"U") '[ filterValue)&&($ZCVT(desc,"U") '[ filterValue)&&($ZCVT(exeCode,"U") '[ filterValue)
		if (flag="Y"){
			s flag="是"
		}else{
			s flag="否"
		}
		s ^CacheTemp(repid,ind)=$lb(type,flag,desc,exeCode)
		s ind=ind+1
	}
	Quit $$$OK
}

/// Creator  : wk
/// CreaDate : 2018-07-18
/// Desc     : 获取执行代码信息
/// Other    : do ##Class(web.DHCWL.V1.KPI.SysConfigFunction).GetExeCodeInfor()
ClassMethod GetExeCodeInfor()
{
	s sql="select ExeCode_Type,ExcCode_Write,ExcCode_Call,ExcCode_Version,ExcCode_CUDate,ExcCode_Creator,ExcCode_GlobalFlag,ExcCode_Applicable,ExcCode_Description,ExcCode_SubType,ExcCode_DefaultFlag from DHCWL_MKPI.MKPI_ExecuteCode order by ExcCode_SubType"
	s rs=##class(%Library.ResultSet).%New()
	d rs.Prepare(sql)
	d rs.Execute()
	q rs
}

/// Creator   : wk
/// CreatDate : 2018-07-18
/// Desc      : 新增执行代码
/// Other     : do ##Class(web.DHCWL.V1.KPI.SysConfigFunction).AddExeCode()
ClassMethod AddExeCode(subType As %String = "", active As %String = "", desc As %String = "", exeCode As %String = "", creator As %String = "")
{
	k exeCodeList
	s exeCodeList("subType")=subType
	s exeCodeList("active")=active
	s exeCodeList("desc")=desc
	s exeCodeList("exeCode")=exeCode
	s exeCodeList("creator")=creator
	q:((subType="")||(active="")||(desc="")||(exeCode="")||(creator="")) "有内容为空不能保存"
	s sc=##Class(web.DHCWL.V1.KPI.SysConfigFunction).AddExeCodeFun(.exeCodeList)
	if (sc="ok"){
		q "新增成功"
	}else{
		q "新增失败,SQLCODE:"_sc
	}
}

/// Creator    : wk
/// CreatDate  : 2018-07-18
/// Desc       : 新增一条记录
/// Other      : do ##Class(web.DHCWL.V1.KPI.SysConfigFunction).AddExeCodeFun()
ClassMethod AddExeCodeFun(ByRef exeCodeList)
{
	s subType=$g(exeCodeList("subType"))
	s active=$g(exeCodeList("active"))
	s desc=$g(exeCodeList("desc"))
	s exeCode=$g(exeCodeList("exeCode"))
	s creator=$g(exeCodeList("creator"))
	s tempExeCode="",flag=""
	for {
		s tempExeCode=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",tempExeCode))
		q:tempExeCode=""
		if ($zcvt(tempExeCode,"U")=$zcvt(exeCode,"U")){
			s flag=1
			q
		}
	}
	q:flag=1 "执行代码已存在,请检查后重试"
	&Sql(insert into DHCWL_MKPI.MKPI_ExecuteCode (ExeCode_Type,ExcCode_SubType,ExcCode_DefaultFlag,ExcCode_Description,ExcCode_Write,ExcCode_Creator) VALUES("TAS",:subType,:active,:desc,:exeCode,:creator))
	if (SQLCODE'=0){
		q SQLCODE
	}else{
		q "ok"
	}
}

/// Creator    : wk
/// CreatDate  : 2018-07-20
/// Desc       : 获取日志全局配置
/// Other      ：do ##Class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.SysConfigFunction","GetLogConfigQuery")
Query GetLogConfigQuery() As websys.Query(ROWSPEC = "code:%String:编码,value:%String:名称") [ SqlProc ]
{
}

ClassMethod GetLogConfigQueryExecute(ByRef qHandle As %Binary) As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1
    do ##class(web.DHCWL.V1.KPI.SysConfigFunction).GetInfor(.data)
    s num=""
    for {
	    s num=$o(data(num))
	    q:num=""
	    s code=data(num,"SysVarCode")
	    s value=data(num,"SysVarValue")
	    s ^CacheTemp(repid,ind)=$lb(code,value)
		s ind=ind+1
	    
    }
	Quit $$$OK
}

/// Creator    : wk
/// CreatDate  : 2018-07-20
/// Desc       : 获取最新的系统配置信息
/// Other      : do ##class(web.DHCWL.V1.KPI.SysConfigFunction).GetInfor()
ClassMethod GetInfor(ByRef sysVar)
{
	k sysVar
	s currentCode="", num=1
	do{
		s currentCode=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",currentCode))
		q:(""=currentCode)
		s date=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",currentCode,""),-1)
		s time=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",currentCode,date,""),-1)
		s rowId=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",currentCode,date,time,""),-1)
		s lastCode=$lg(^DHCWL.MKPI.SysVariablesD(rowId),2)
		s lastDesc=$lg(^DHCWL.MKPI.SysVariablesD(rowId),3)
		s lastValue=$lg(^DHCWL.MKPI.SysVariablesD(rowId),4)
		s lastUser=$lg(^DHCWL.MKPI.SysVariablesD(rowId),7)
		//continue:(""'=user)&&(user'=lastUser)  ;--modify by wz.2014-6-18.在安装指标时，安装器加入的默认配置也要显示
		s sysVar(num,"SysVarCode")=lastCode
		s sysVar(num,"SysVarDesc")=lastDesc
		s sysVar(num,"SysVarValue")=lastValue
		s sysVar(num,"SysVarUser")=lastUser
		s sysVar(num,"SysVarDate")=date
		s sysVar(num,"SysVarTime")=time
		s num=num+1
	}while(""'=currentCode)
}

/// Creator     : wk
/// CreatDate   : 2018-07-20
/// Desc        : 保存日志全局配置
/// Other       : do ##Class(web.DHCWL.V1.KPI.SysConfigFunction).SaveLogConfig()
ClassMethod SaveLogConfig(logConfigs)
{
	if $d(%session.Data("LOGON.USERNAME")) 
	{
		s user=$g(%session.Data("LOGON.USERNAME"))
	}else{
		s user=""
	}
	s result=""
	s len = $l(logConfigs,"||")
	for i=1:1:len{
		s logConfig = $p(logConfigs,"||",i)
		continue:logConfig=""
		s code = $p(logConfig,",",1)
		s desc = $p(logConfig,",",2)
		s value = $p(logConfig,",",3)
		s obj=##class(DHCWL.SysService.SysVarService).BuildSysVarObj(code,desc,value,user)
		s result=##class(DHCWL.SysService.SysVarService).Insert(obj)
		q:(result'=1)&&(result'="exist")
	}
	if ((result=1)||(result="exist")){
		q "保存成功"
	}else{
		q "保存失败"_result
	}
}

/// Creator    : wk
/// CreatDate  ：2018-07-23
/// Desc       : 为所有维度增加统计子组/统计大组维度
/// Other      : do ##Class(web.DHCWL.V1.KPI.SysConfigFunction).AddGrpAndSubgrp()
ClassMethod AddGrpAndSubgrp()
{
	s isSuccess=0
	s dimTypeID=""

	f {
		s dimTypeID=$o(^DHCWL.MKPI.MKPIDimTypeD(dimTypeID))
		q:dimTypeID=""
		
		if $d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID)) {
			if '$d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,"ITEMGRP")) {
				&sql(insert into DHCWL_MKPI.DHCWLDimProperty 
				(DimPro_Code,DimPro_Name,DimPro_Desc,DimPro_ExcCode,DimPro_DimDr,DimPro_DefaultFlag) 
				values ('ItemGrp','统计大组','统计大组','GetMripdayGrpDescAndSort^DHCWLBuildDimDataGetSubGrp',:dimTypeID,'N') )
				if SQLCODE'=0 {
					S isSuccess=SQLCODE
					q
				}
			}else{
				s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,"ITEMGRP",""))
				s dimPrObj=##class(DHCWL.MKPI.DimProperty).%OpenId(dimProID)
				s exeCode=dimPrObj.ExcuteCode
				if ((exeCode="")||(exeCode=$c(0))){
					s dimPrObj.ExcuteCode="GetMripdayGrpDescAndSort^DHCWLBuildDimDataGetSubGrp"
					s result=dimPrObj.%Save()
					if (result'=1){
						s isSuccess=result
						q
					}
				}
			}
            if '$d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,"ITEMBSGRPORDER")){
                &sql(insert into DHCWL_MKPI.DHCWLDimProperty
				(DimPro_Code,DimPro_Name,DimPro_Desc,DimPro_ExcCode,DimPro_DimDr,DimPro_DefaultFlag) 
				values ('ItemBsGrpOrder','统计大组顺序','统计大组顺序','GetBSGrpOrder^DHCWLBuildDimDataGetSubGrp',:dimTypeID,'N') )
				if SQLCODE'=0 {
					S isSuccess=SQLCODE
					q
				}
            }
			if '$d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,"ITEMSUBGRP")) {
				&sql(insert into DHCWL_MKPI.DHCWLDimProperty
				(DimPro_Code,DimPro_Name,DimPro_Desc,DimPro_ExcCode,DimPro_DimDr,DimPro_DefaultFlag) 
				values ('ItemSubGrp','统计子组','统计子组','GetSubGrpByItemDr^DHCWLBuildDimDataGetSubGrp',:dimTypeID,'N') )
				if SQLCODE'=0 {
					S isSuccess=SQLCODE
					q
				}
			}else{
				s dimProID=$o(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,"ITEMSUBGRP",""))
				s dimPrObj=##class(DHCWL.MKPI.DimProperty).%OpenId(dimProID)
				s exeCode=dimPrObj.ExcuteCode
				if ((exeCode="")||(exeCode=$c(0))){
					s dimPrObj.ExcuteCode="GetSubGrpByItemDr^DHCWLBuildDimDataGetSubGrp"
					s result=dimPrObj.%Save()
					if (result'=1){
						s isSuccess=result
						q
					}
				}
			}
			if '$d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,"ITEMSUBGRPDESC")) {
				&sql(insert into DHCWL_MKPI.DHCWLDimProperty
				(DimPro_Code,DimPro_Name,DimPro_Desc,DimPro_ExcCode,DimPro_DimDr,DimPro_DefaultFlag) 
				values ('ItemSubGrpDesc','统计子组描述','统计子组描述','GetBSSubDesc^DHCWLBuildDimDataGetSubGrp',:dimTypeID,'N') )
				if SQLCODE'=0 {
					S isSuccess=SQLCODE
					q
				}
			}
			if '$d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,"ITEMSUBGRPCODE")) {
				&sql(insert into DHCWL_MKPI.DHCWLDimProperty
				(DimPro_Code,DimPro_Name,DimPro_Desc,DimPro_ExcCode,DimPro_DimDr,DimPro_DefaultFlag) 
				values ('ItemSubGrpCode','统计子组代码','统计子组代码','GetBSSubCode^DHCWLBuildDimDataGetSubGrp',:dimTypeID,'N') )
				if SQLCODE'=0 {
					S isSuccess=SQLCODE
					q
				}
			}
			if '$d(^DHCWL.MKPI.DimPropertyI("DimCodeI",dimTypeID,"ITEMSUBGRPORDER")) {
				&sql(insert into DHCWL_MKPI.DHCWLDimProperty
				(DimPro_Code,DimPro_Name,DimPro_Desc,DimPro_ExcCode,DimPro_DimDr,DimPro_DefaultFlag) 
				values ('ItemSubGrpOrder','统计子组顺序','统计子组顺序','GetBSSubOrder^DHCWLBuildDimDataGetSubGrp',:dimTypeID,'N') )
				if SQLCODE'=0 {
					S isSuccess=SQLCODE
					q
				}
			}
		}
		
	}
		
	if isSuccess=0 q "操作成功"
	e  q "操作失败"
}

/// Creator    : wk
/// CreatDate  : 2018-07-23
/// Desc       : 检查指标环境,获取错误信息
/// Other      ：do ##Class(%ResultSet).RunQuery("web.DHCWL.V1.KPI.SysConfigFunction","GetKPIErrInforQuery")
Query GetKPIErrInforQuery(flag As %String = "") As websys.Query(ROWSPEC = "errType:%String:错误类型,errInfor:%String:错误信息") [ SqlProc ]
{
}

ClassMethod GetKPIErrInforQueryExecute(ByRef qHandle As %Binary, flag As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	k ^CacheTemp(repid)
	s qHandle=$lb(0,repid,0)
    s ind=1 
    q:flag'=1 $$$OK
	k errorInforList
	do ##class(DHCWL.util.CheckKpiData).CheckKpi(1,.errorInforList)
	//do ##class(DHCWL.util.CheckKpiData).CheckKpiExCode(1,.errorInforList)
	do ##class(DHCWL.util.CheckKpiData).CheckKpiSectionFlag(1,.errorInforList)
	do ##class(DHCWL.util.CheckKpiData).CheckSection(1,.errorInforList)
	//do ##class(DHCWL.util.CheckKpiData).CheckDimExeCode(1,.errorInforList)
	do ##class(DHCWL.util.CheckKpiData).CheckKpiDimOrder(1,.errorInforList)
	do ##class(DHCWL.Interface.MKPI.KpiData).CheckKpiTaskOrder(.errorInforList)
	set secFlag=##class(DHCWL.MKPIService.ConfigService).GetSectionMaxToMin(.tempSec)
	if (secFlag){
		//s errorInforList("区间检查","已完成")=""
	}else{
		s errorInforList("区间检查","指标区间之间的父子关系维护不正确")=""
	}
	if ($o(errorInforList(""))=""){
		s errorInforList("所有检查已完成","没有发现异常")=""
	}
    s errType=""
    for {
	    s errType=$o(errorInforList(errType))
	    q:errType=""
	    s errInfor=errorInforList(errType)
	   	s ^CacheTemp(repid,ind)=$lb(errType,errInfor)
		s ind=ind+1
    }
    
	Quit $$$OK
}

}
