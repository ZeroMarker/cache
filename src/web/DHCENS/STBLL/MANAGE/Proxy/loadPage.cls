Class web.DHCENS.STBLL.MANAGE.Proxy.loadPage Extends %CSP.Page
{

Parameter CONTENTTYPE = "text/plain;charset=UTF-8";

ClassMethod OnPage() As %Status
{
	set InputStr="",action="",page="",rows=""
	set InputStr=$G(%request.Data("input",1))
	set action=$g(%request.Data("action",1))
	set page=$g(%request.Data("page",1))
	set rows=$g(%request.Data("rows",1))

	set ReInput="",Flag=""
	set:InputStr="enable" Flag="N"
	set:Flag="N" InputStr=""
	set:page="" Flag="N"
	
	///产品组字典
	if action="WorkGroupDict"{	
		set result=##class(web.DHCENS.STBLL.MANAGE.SystemConfig).WorkGroupDict()
		w result
		q $$$OK
	}
	///院区字典
	elseif action="HospitalDict"{	
		set result=##class(web.DHCENS.STBLL.MANAGE.SystemConfig).HospitalDict(InputStr)
		w result
		q $$$OK
	}
	///系统配置列表
	elseif action="QuerySystemConfig"{	
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.MANAGE.SystemConfig","SystemConfigData",InputStr,page,rows)
		w sc
		q $$$OK
	}
	///新增/编辑配置信息
	elseif action="SystemConfig"{	
		set result=##class(web.DHCENS.STBLL.MANAGE.SystemConfig).SystemConfig(InputStr)
		w result
		q $$$OK
	}
	///系统名称列表
	elseif action="SystemList"{	
		set result=##class(web.DHCENS.STBLL.MANAGE.SystemConfig).SystemList()
		w result
		q $$$OK
	}
	///下拉-系统字典
	elseif action="EnsSystemList"{	
		set result=##class(web.DHCENS.STBLL.MANAGE.SystemConfig).EnsSystemList()
		w result
		q $$$OK
	}
	///下拉-科室字典
	elseif action="CTLocList"{	
		set result=##class(web.DHCENS.STBLL.MANAGE.SystemConfig).CTLocList(InputStr)
		w result
		q $$$OK
	}
	///下拉-目标列表，用于方法列表界面，维护调用目标
	elseif action="TargetList"{	
		set result=##class(web.DHCENS.STBLL.MANAGE.SystemConfig).TargetList()
		w result
		q $$$OK
	}
	///查询系统功能列表
	elseif action="QuerySysFunction"{	
		set sc=##class(web.DHCENS.STBLL.UTIL.CreateJson).GetDataInfoListShowDatagrid("web.DHCENS.STBLL.MANAGE.SystemConfig","SysFunctionData",InputStr,page,rows)
		w sc
		q $$$OK
	}
	///系统功能维护
	elseif action="funConfig"{	
		set result=##class(web.DHCENS.STBLL.MANAGE.SystemConfig).SystemFuncConfig(InputStr)
		w result
		q $$$OK
	}
	do result.OutputToDevice()
	q $$$OK
}

}
