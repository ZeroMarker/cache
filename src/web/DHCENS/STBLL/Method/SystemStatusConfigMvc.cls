Class web.DHCENS.STBLL.Method.SystemStatusConfigMvc Extends (%ZEN.Component.page, %CSP.StreamServer)
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
	
	
	///插入方法
	if action="EnsStatusInsert"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusInsert(ReInput)
	}elseif action="EnsStatusCodeInsert"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusCodeInsert(ReInput)
	}elseif action="EnsStatusLogInsert"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusLogInsert(ReInput)
	}elseif action="EnsSystemInsert"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemInsert(ReInput)
	}elseif action="EnsSystemLinkStatusInsert"{	
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemLinkStatusInsert(ReInput)
	}elseif action="EnsSystemTypeInsert"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemTypeInsert(ReInput)
	}elseif action="EnsStatusInsert"{	
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusInsert(ReInput)
	}elseif action="EHLMTableInsert"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)
		set result=##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).EHLMTableInsert(ReInput)
	}elseif action="ExcelImportTable"{		
	
		set result=##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).ExcelImportTable(InputStr)
		w result
		q $$$OK
	}elseif action="HISTableFlag"{
		set result=##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).HISTableFlag(InputStr)
		set ^sherry("result")=result
		w result
		q $$$OK
	}
	///删除方法
	elseif action="EnsStatusCodeDelete"{	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusCodeDelete(InputStr)
	}elseif action="EnsStatusDelete"{	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusDelete(InputStr)
	}elseif action="EnsStatusLogDelete"{	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusLogDelete(InputStr)
	}elseif action="EnsSystemDelete"{	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemDelete(InputStr)
	}elseif action="EnsSystemLinkStatusDelete"{	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemLinkStatusDelete(InputStr)
	}elseif action="EnsSystemTypeDelete"{	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemTypeDelete(InputStr)
	}elseif action="EHLMTableDelete"{
		set result=##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).EHLMTableDelete(InputStr)
		
	}
	///修改方法
	elseif action="EnsStatusCodeUpdate"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusCodeUpdate(ReInput)
	}elseif action="EnsStatusLogUpdate"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusLogUpdate(ReInput)
	}elseif action="EnsStatusUpdate"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsStatusUpdate(ReInput)
	}elseif action="EnsSystemLinkStatusUpdate"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemLinkStatusUpdate(ReInput)
	}elseif action="EnsSystemTypeUpdate"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemTypeUpdate(ReInput)
	}elseif action="EnsSystemUpdate"{
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputStr)	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).EnsSystemUpdate(ReInput)
	}elseif action="EHLMTableUpdate"{
		set InputContentStr=$p(InputStr,"^",2)
		set InputIDStr=$p(InputStr,"^",1)	
		set ReInput=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).ReInputStr(InputContentStr)
		set AllStr=InputIDStr_"^"_ReInput
		set result=##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).EHLMTableUpdate(AllStr)
	}
	///查询方法
	elseif action="GetEnsStatusCode"{	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).GetEnsStatusCode(InputStr,Flag,page,rows)
	}elseif action="GetEnsSystemType"{	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).GetEnsSystemType(InputStr,Flag,page,rows)
	}elseif action="GetEnsSystem"{	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).GetEnsSystem(InputStr,Flag,page,rows)
	}elseif action="GetEnsSystemLinkStatus"{	
		set result=##class(web.DHCENS.STBLL.Method.SystemStatusConfig).GetEnsSystemLinkStatus(InputStr,Flag,page,rows)
	}elseif action="GetEHLMTableInfo"{		
		set result=##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).GetEHLMTableInfo(InputStr,page,rows)
	}elseif action="GetHISTable"{
		set result=##class(web.DHCENS.STBLL.Method.EnsHISLookUpMDMTable).GetHISTable(InputStr,page,rows)
	}else{
		set result= "-1_未找到相应的action"	
	}
	do result.Rewind()
	//w result.Read()  流修改为串
	do result.OutputToDevice()
	q $$$OK
}

}
