/// 	提供对DHCWL_MKPI.SysFilterFunc表数据维护的支持
Class DHCWL.SysService.SysVarService Extends %RegisteredObject [ Not ProcedureBlock ]
{

ClassMethod BuildSysVarObj(code = "", desc = "", value = "", user = "") As DHCWL.MKPI.SysVariables
{
	n (code,desc,value,user)
	s obj=##class(DHCWL.MKPI.SysVariables).%New()
	s obj.SysVarCode=$g(code)
	s obj.SysVarDesc=$g(desc)
	s obj.SysVarValue=$g(value)
	s obj.SysVarUser=$g(user)
	s obj.SysVarDate=""
	s obj.SysVarTime=""
	q obj
}

ClassMethod Insert(obj As DHCWL.MKPI.SysVariables) As %Status
{
	n (obj)
	q:(""=obj) "Insert需要一个DHCWL.MKPI.SysVariables对象"
	s code=obj.SysVarCode, value=obj.SysVarValue
	q:(""=code) "您必须为系统参数指定一个代码！"
	q:(""=value) 1	//值为空的系统参数和未定义一样，因此不允许插入空值的系统参数
	s code=$zcvt(code,"U")
	s obj.SysVarDate=$p($h,",",1)
	s obj.SysVarTime=$p($h,",",2)
	if '$d(^DHCWL.MKPI.SysVariablesI("CodeDateTime",code)){
		d obj.%Save()
		q 1
	}else{
		s date=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",code,""),-1)
		s time=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",code,date,""),-1)
		s rowId=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",code,date,time,""),-1)
		s lastValue=$lg(^DHCWL.MKPI.SysVariablesD(rowId),4)
		q:(value=lastValue) "exist"
		d obj.%Save()
		q 1
	}
}

ClassMethod GetObjBySysVarCode(code) As DHCWL.MKPI.SysVariables
{
	n (code)
	q:(""=code) ""
	s code=$zcvt(code,"U")
	q:'$d(^DHCWL.MKPI.SysVariablesI("CodeDateTime",code)) ""
	s date=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",code,""),-1)
	s time=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",code,date,""),-1)
	s rowId=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",code,date,time,""),-1)
	q ##class(DHCWL.MKPI.SysVariables).%OpenId(rowId)
}

/// 	s json=##class(DHCWL.SysService.SysVarService).QuerySysVar()
ClassMethod QuerySysVar(code = "", desc = "", value = "", user = "") As DHCWL.util.Json
{
	n (code,desc,value,user)
	i (""'=code) s code=$zcvt(code,"U")
	s currentCode="", num=1
	do{
		s currentCode=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",currentCode))
		q:(""=currentCode)
		continue:(""'=code)&&(code'=currentCode)
		s date=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",currentCode,""),-1)
		s time=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",currentCode,date,""),-1)
		s rowId=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",currentCode,date,time,""),-1)
		s lastCode=$lg(^DHCWL.MKPI.SysVariablesD(rowId),2)
		s lastDesc=$lg(^DHCWL.MKPI.SysVariablesD(rowId),3)
		continue:(""'=desc)&&(desc'=lastDesc)
		s lastValue=$lg(^DHCWL.MKPI.SysVariablesD(rowId),4)
		continue:(""'=value)&&(value'=lastValue)
		s lastUser=$lg(^DHCWL.MKPI.SysVariablesD(rowId),7)
		//continue:(""'=user)&&(user'=lastUser)  ;--modify by wz.2014-6-18.在安装指标时，安装器加入的默认配置也要显示
		continue:(""'=user)&&(user'=lastUser)&&(lastUser'="Installer")
		s sysVar(num,"SysVarCode")=lastCode
		s sysVar(num,"SysVarDesc")=lastDesc
		s sysVar(num,"SysVarValue")=lastValue
		s sysVar(num,"SysVarUser")=lastUser
		s sysVar(num,"SysVarDate")=date
		s sysVar(num,"SysVarTime")=time
		s num=num+1
	}while(""'=currentCode)
	q:'$d(sysVar) ""
	q ##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.sysVar)
}

/// 	##class(DHCWL.SysService.SysVarService).GetTaskInitStatus()
ClassMethod GetTaskInitStatus() As %String
{
	s code="GlobalTaskInitCfg", value=""
	s obj=##class(DHCWL.SysService.SysVarService).GetObjBySysVarCode(code)
	i (""'=obj) {
		s value=obj.SysVarValue
	}
	q value
}

/// 		s json=##class(DHCWL.SysService.SysVarService).GetTaskInitStatusJson()
ClassMethod GetTaskInitStatusJson() As DHCWL.util.Json
{
	k sysVar
	s sysCode="GLOBALTASKINITCFG"
	q:(0=$d(^DHCWL.MKPI.SysVariablesI("CodeDateTime",sysCode))) ""
	s date=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",sysCode,""),-1)
	s time=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",sysCode,date,""),-1)
	s id=$o(^DHCWL.MKPI.SysVariablesI("CodeDateTime",sysCode,date,time,""))
	s taskActiveFlag=$lg(^DHCWL.MKPI.SysVariablesD(id),4)
	s sysVar(1,"disValue")=taskActiveFlag
	s sysVar(1,"realValue")=taskActiveFlag
	q ##class(DHCWL.MKPILogin.LoginService).MetrixToJson(.sysVar)
}

}
