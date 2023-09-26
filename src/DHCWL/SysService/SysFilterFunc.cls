/// 	提供对DHCWL_MKPI.SysFilterFunc表数据维护的支持
Class DHCWL.SysService.SysFilterFunc Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 	s obj=##class(DHCWL.SysService.SysFilterFunc).BuildFilterFuncObj()
ClassMethod BuildFilterFuncObj(id = "", code = "", prototype = "", execCode = "", funcDesc = "") As DHCWL.MKPI.SysFilterFunc
{
	n (id,code,prototype,execCode,funcDesc)
	if (""=$g(id)){
		s obj=##class(DHCWL.MKPI.SysFilterFunc).%New()
	}else{
		s obj=##class(DHCWL.MKPI.SysFilterFunc).%OpenId(id)
	}
	s obj.FilterFuncCode=$g(code)
	s obj.FilterFuncPrototype=$g(prototype)
	s obj.FilterFuncExecCode=$g(execCode)
	s obj.FilterFuncFuncDesc=$g(funcDesc)
	q obj
}

ClassMethod AssertExistence(obj As DHCWL.MKPI.SysFilterFunc) As %String
{
	n (obj)
	q:(""=obj) 1
	i (""'=obj.%Id()) {
		//这里不要用对象的属性来判断，因为内存中同一个进程只允许创建该实体类的一个对象。？一致性保证吧
		s id=obj.%Id()
		s lastFilterFuncCode=$lg(^DHCWL.MKPI.SysFilterFuncD(id),2)
		s lastFilterFuncExecCode=$lg(^DHCWL.MKPI.SysFilterFuncD(id),4)
		
		//modify by wz.2014-4-9
		s lfFuncCode=$tr(lastFilterFuncCode,"‘","'")
		s lfFuncCode=$tr(lfFuncCode,"’","'")
		s objFFCode=$tr(obj.FilterFuncCode,"’","'")
		s objFFCode=$tr(objFFCode,"‘","'")		
		q:($zcvt(lfFuncCode,"U")'=$zcvt(objFFCode,"U")) "您不能修改已经建立的过滤函数名称！"
		//q:($zcvt(obj.FilterFuncCode,"U")'=$zcvt(lastFilterFuncCode,"U")) "您不能修改已经建立的过滤函数名称！"
		//q:($zcvt(obj.FilterFuncExecCode,"U")'=$zcvt(lastFilterFuncExecCode,"U")) "您不能修改已经建立的过滤函数执行代码！"
	}else{
		q:$d(^DHCWL.MKPI.SysFilterFuncI("Code"," "_$zcvt(obj.FilterFuncCode,"U"))) "过滤函数名称已经被占用！"
		//q:$d(^DHCWL.MKPI.SysFilterFuncI("ExecCode"," "_$zcvt(obj.FilterFuncExecCode,"U"))) "过滤函数执行代码已经被占用！"
	}
	q 1
}

ClassMethod Insert(obj As DHCWL.MKPI.SysFilterFunc) As %Status
{
	n (obj)
	q:(""=obj) "Insert需要一个DHCWL.MKPI.SysFilterFunc对象"
	s execCode=obj.FilterFuncExecCode
	q:(""'=$g(execCode))&&($f($g(execCode),"DHCWL.Filters.CustomFilterFunc")) "不允许在系统定义过滤函数的类中添加您自己的过滤函数！"
	q:(""=obj.FilterFuncCode) "您必须为过滤函数指定一个函数名称！"
	q:(""=obj.FilterFuncExecCode) "您必须为过滤函数指定一个函数执行代码"
	s result=##class(DHCWL.SysService.SysFilterFunc).AssertExistence(obj)
	q:(1'=result) result
	d obj.%Save()
	q 1
}

ClassMethod Update(obj As DHCWL.MKPI.SysFilterFunc) As %Status
{
	n (obj)
	q:(""=obj) "Update需要一个DHCWL.MKPI.SysFilterFunc对象"
	s execCode=obj.FilterFuncExecCode
	q:(""'=$g(execCode))&&($f($g(execCode),"DHCWL.Filters.CustomFilterFunc")) "系统定义的过滤函数不允许修改其执行代码！"
	s result=##class(DHCWL.SysService.SysFilterFunc).AssertExistence(obj)
	q:(1'=result) result
	d obj.%Save()
	q 1
}

ClassMethod GetFilterFuncIdByCode(code) As %String
{
	n (code)
	q:(""=code) ""
	s code=$zcvt(code,"U")
	q:'$d(^DHCWL.MKPI.SysFilterFuncI("Code"," "_code)) ""
	q $o(^DHCWL.MKPI.SysFilterFuncI("Code"," "_code,""))
}

ClassMethod GetFilterFuncByCode(code) As DHCWL.MKPI.SysFilterFunc
{
	n (code)
	q:(""=code) ""
	s filterFuncId=##class(DHCWL.SysService.SysFilterFunc).GetFilterFuncIdByCode(code)
	q ##class(DHCWL.MKPI.SysFilterFunc).%OpenId(filterFuncId)
}

ClassMethod GetFilterFunc(code = "", prototype = "", execCode = "") As %ListOfObjects
{
	n (code,prototype,execCode)
	s objList=##Class(%Library.ListOfObjects).%New()
	
	if (""=code){
		s filterFuncId=$o(^DHCWL.MKPI.SysFilterFuncD(""))
		d{
			s obj=##class(DHCWL.MKPI.SysFilterFunc).%OpenId(filterFuncId)
			q:(""'=$g(prototype))&&($g(prototype)'=obj.FilterFuncPrototype)
			q:(""'=$g(execCode))&&($g(execCode)'=obj.FilterFuncExecCode)
			d objList.Insert(obj)
			s filterFuncId=$o(^DHCWL.MKPI.SysFilterFuncD(filterFuncId))
		}while(""'=filterFuncId)
	}else{
		s obj=##class(DHCWL.SysService.SysFilterFunc).GetFilterFuncByCode(code)
		q:(""'=$g(prototype))&&($g(prototype)'=obj.FilterFuncPrototype)
		q:(""'=$g(execCode))&&($g(execCode)'=obj.FilterFuncExecCode)
		d objList.Insert(obj)
	}
	q objList
}

/// 	s json=##class(DHCWL.SysService.SysFilterFunc).QueryFilterFunc("","","","")
ClassMethod QueryFilterFunc(code = "", prototype = "", execCode = "", funcDesc = "") As DHCWL.util.Json
{
	n (code,prototype,execCode,funcDesc)
	k filterFunc
	s code=$tr(code,"‘","'"), code=$tr(code,"’","'")
	s num=1
	if (""=code){
		s filterFuncId=""
		do{
			s filterFuncId=$o(^DHCWL.MKPI.SysFilterFuncD(filterFuncId))
			q:(""=filterFuncId)
			s obj=##class(DHCWL.MKPI.SysFilterFunc).%OpenId(filterFuncId)
			continue:(""=obj)
			continue:(""'=$g(prototype))&&($g(prototype)'=obj.FilterFuncPrototype)
			continue:(""'=$g(execCode))&&($g(execCode)'=obj.FilterFuncExecCode)
			continue:(""'=$g(funcDesc))&&($g(funcDesc)'=obj.FilterFuncFuncDesc)
			s filterFunc(num,"FilterFuncID")=filterFuncId
			s obj.FilterFuncCode=$tr(obj.FilterFuncCode,"'","‘")
			s filterFunc(num,"FilterFuncCode")=obj.FilterFuncCode
			s filterFunc(num,"FilterFuncPrototype")=obj.FilterFuncPrototype
			s obj.FilterFuncExecCode=$tr(obj.FilterFuncExecCode,"^","∧")
			s filterFunc(num,"FilterFuncExecCode")=obj.FilterFuncExecCode
			s filterFunc(num,"FilterFuncFuncDesc")=obj.FilterFuncFuncDesc
			s num=num+1
		}while(""'=filterFuncId)
	}else{
		s obj=##class(DHCWL.MKPI.SysFilterFunc).%New()
		s obj=##class(DHCWL.SysService.SysFilterFunc).GetFilterFuncByCode(code)
		q:(""=obj) ""
		q:(""'=$g(prototype))&&($g(prototype)'=obj.FilterFuncPrototype) ""
		q:(""'=$g(execCode))&&($g(execCode)'=obj.FilterFuncExecCode) ""
		q:(""'=$g(funcDesc))&&($g(funcDesc)'=obj.FilterFuncFuncDesc)
		//s indexCode=$zcvt(obj.FilterFuncCode,"U")
		s filterFunc(num,"FilterFuncID")=$o(^DHCWL.MKPI.SysFilterFuncI("Code"," "_$zcvt(obj.FilterFuncCode,"U"),""))
		s obj.FilterFuncCode=$tr(obj.FilterFuncCode,"'","‘")
		s filterFunc(num,"FilterFuncCode")=obj.FilterFuncCode
		s filterFunc(num,"FilterFuncPrototype")=obj.FilterFuncPrototype
		s obj.FilterFuncExecCode=$tr(obj.FilterFuncExecCode,"^","∧")
		s filterFunc(num,"FilterFuncExecCode")=obj.FilterFuncExecCode
		s filterFunc(num,"FilterFuncFuncDesc")=obj.FilterFuncFuncDesc
	}
	q:($d(filterFunc)) ##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.filterFunc)
	q ""
}

/// Creator     : wk
/// CreatDate   : 2018-07-10
/// CreatDesc   : 将当前库中的执行代码更新成标准数据
/// Other       : do ##Class(DHCWL.SysService.SysFilterFunc).Config()
ClassMethod Config() As %Status
{
	s sc=##class(DHCWL.SysService.SysFilterFunc).ConfigExeCodeFunc()
	k ^DHCWL.MKPI.SysFilterFuncI,^DHCWL.MKPI.SysFilterFuncD
	s sc=##class(DHCWL.SysService.SysFilterFunc).ConfigFilterFunc()
	q 1
}

/// Creator     : wk
/// CreatDate   : 2018-07-10
/// CreatDesc   : 将当前库中的执行代码更新成标准数据
/// Other       : do ##Class(DHCWL.SysService.SysFilterFunc).ConfigExeCodeFunc()
ClassMethod ConfigExeCodeFunc() As %Status
{
	k exeCodeList
	s exeID=""
	for {
		s exeID=$o(^DHCWL.MKPI.ExecuteCodeD(exeID))
		q:exeID=""
		s exeCode=$lg(^DHCWL.MKPI.ExecuteCodeD(exeID),3)
		if (('$d(^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode",exeCode))&&($d(^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode"))))||($d(exeCodeList(exeCode)))){
			&sql(delete from DHCWL_MKPI.MKPI_ExecuteCode where ID=:exeID)
			q:SQLCODE'=0	
		}
		s exeCodeList(exeCode)=""
	}
	s exeCode=""
	for {
		s exeCode=$o(^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode",exeCode))
		q:exeCode=""
		//q:'$d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",exeCode))
		s inforList=^DHCWL.MKPI.ExecuteCodeConfig("FunExeCode",exeCode)
		s secCode=$p(inforList,":",1)
		s exeType=$p(inforList,":",2)
		s actFlag=$p(inforList,":",3)
		s verValue=$p(inforList,":",4)
		s desc=$p(inforList,":",5)
		if ($d(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",exeCode))){
			s exeID=$o(^DHCWL.MKPI.ExecuteCodeI("ExcCodeTypeI","TAS",exeCode,""))
			if (exeID'=""){
				&sql(update DHCWL_MKPI.MKPI_ExecuteCode set ExeCode_Type=:exeType,ExcCode_SubType=:secCode,ExcCode_DefaultFlag=:actFlag,ExcCode_Version=:verValue,ExcCode_Applicable=:desc,ExcCode_Description=:desc where ID=:exeID)
			}
		}else{
			&sql(insert into DHCWL_MKPI.MKPI_ExecuteCode (ExeCode_Type,ExcCode_SubType,ExcCode_DefaultFlag,ExcCode_Version,ExcCode_Applicable,ExcCode_Description,ExcCode_Write) values (:exeType,:secCode,:actFlag,:verValue,:desc,:desc,:exeCode))
		}
		q:SQLCODE'=0
 }
 q 1
}

/// 	配置指标系统内置定义的过滤函数
/// 	w ##class(DHCWL.SysService.SysFilterFunc).ConfigFilterFunc()
ClassMethod ConfigFilterFunc() As %Status
{
	s code=""
	do{
		s code=$o(^DHCWLMKPIFilterConf("FILTER",code)), execCode=""
		q:(""=code)
		s tagName=$o(^DHCWLMKPIFilterConf("FILTER",code,""))
		if ("CUSTOM"=tagName){
			s execCode=$p($g(^DHCWLMKPIFilterConf("FILTER",code,tagName)),":",1)
			s desc=$p($g(^DHCWLMKPIFilterConf("FILTER",code,tagName)),":",2)
		}elseif("INTERNAL"=tagName){
			s execCode=$p($g(^DHCWLMKPIFilterConf("FILTER",code,tagName)),":",1)
			s desc=$p($g(^DHCWLMKPIFilterConf("FILTER",code,tagName)),":",2)
		}
		if (0'=$d(^DHCWL.MKPI.SysFilterFuncI("Code"," "_$zcvt(code,"U")))){
			s id=$O(^DHCWL.MKPI.SysFilterFuncI("Code"," "_$zcvt(code,"U"),""))
			;w "id="_id,!
			&sql(delete from DHCWL_MKPI.SysFilterFunc where id=:id)
		;}else{
			;continue:0'=$d(^DHCWL.MKPI.SysFilterFuncI("Code"," "_$zcvt(code,"U")))
		}
		s mPList(2)=$g(code)
		s mPList(3)=$g(tagName)
		s mPList(4)=$g(execCode)
		s mPList(5)=$g(desc)
		&sql(insert into DHCWL_MKPI.SysFilterFunc values mPList())
		i (0'=SQLCODE) w SQLCODE_"  :  "_code,!
	}while(""'=code)
	q 1
}

}
