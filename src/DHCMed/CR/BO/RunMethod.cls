/// 名称: DHCMed.CR.BO.RunMethod
/// 描述: 运行类方法
/// 编写者：wuqk
/// 编写日期: 2012-11-29
Class DHCMed.CR.BO.RunMethod Extends %CSP.Page [ Not ProcedureBlock ]
{

/// Specifies the default character set for the page.  This can be overriden using the
/// &lt;CSP:CONTENT CHARSET=&gt; tag, or by setting the <b>%response</b>.CharSet property
/// in the <method>OnPreHTTP</method> method.  If this parameter is not specified, then
/// for Unicode systems the default charset is utf-8 and for 8-bit systems it is the
/// system default charset.
Parameter CHARSET = "utf-8";

ClassMethod OnPage() As %Status
{
	set $ZT="ErrorTrap"
	set strClassName=%request.Get("ClassName",1)
	set strMethodName=%request.Get("MethodName",1)
	if '##class(%Dictionary.CompiledClass).%ExistsId(strClassName) || '##class(%Dictionary.CompiledMethod).%ExistsId(strClassName_"||"_strMethodName) {
		set ret="{Result:false,Message:'Not Found method "_strClassName_"."_strMethodName_"'}"
		w ret
		quit $$$OK
	}

	//w !,"strClassName="_strClassName
	//w !,"strMethodName="_strMethodName
	set dcm=##class(%Dictionary.CompiledMethod).%OpenId(strClassName_"||"_strMethodName)
	quit:'$IsObject(dcm)
	
	//w !,"strClassName1="_strClassName
	//w !,"strMethodName1="_strMethodName
	
	set formalSpec=dcm.FormalSpec
	set ArgCnt=0
	set:formalSpec'="" ArgCnt=$l(formalSpec,",")
	set strReturnType=dcm.ReturnType
	d dcm.%Close()
	k dcm 
	set execute="",i=""
	set execute="s ret=$ZOBJCLASSMETHOD(strClassName,strMethodName"
	k PLIST
	for i=1:1:ArgCnt {
		set strArgName="P"_i
		set PLIST(i)=%request.Get(strArgName,1)
		set execute=execute_",PLIST("_i_")"
	}
	set execute=execute_")"
	//w !,"strClassName="_strClassName
	//w !,"strMethodName="_strMethodName
	x execute
	set objJSON = ##class(DHCMed.CR.Util.JsonObject).%New()
	if $IsObject(ret)=0 {
		set ret="{Result:true,DataObject:"_ret_"}"
	}
	else {
		if ret.%ClassName(1)="%Library.ListOfObjects"  {
			set retStr="{Result:true,DataObject:["
			set intCnt=ret.Count()
			for i=1:1:intCnt {
				set tmpObj=ret.GetAt(i)
				d objJSON.FromObject(tmpObj)
				set josnString = objJSON.Json()
				set retStr=retStr_josnString
				set:i<intCnt retStr=retStr_","
			}
			d ret.%Close()
			k ret
			set ret=retStr_"]}"
		}
		else {
			d objJSON.FromObject(ret)
			set josnString = objJSON.Json()
			set ret="{Result:true,DataObject:"_josnString_"}"
		}
	}
	w ret

	Quit $$$OK
ErrorTrap
	set ret="{Result:false,Message:'"_$ZE_"'}"
	w ret
	Quit $$$OK
}

}
