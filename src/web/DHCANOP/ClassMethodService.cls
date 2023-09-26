Import SQLUser

/// 运行类方法
/// 作者：李阳
/// 2010-5-2
Class web.DHCANOP.ClassMethodService Extends web.DHCANOP.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(web.DHCANOP.ClassMethodService).StaticObject("web.DHCANOP.Com")
ClassMethod StaticObject(strClassName) As %String
{
	s ^TMPzt("strClassName")=strClassName
	s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(strClassName)
	s ret=""
	s cr=$c(9)
	s ret=ret_ "var objTmp = { aafn : function(){return true;}"_cr
	s intMethodCnt=cdef.Methods.Count()
	f i=1:1:intMethodCnt  d
	.s strMethodName=$tr(cdef.Methods.GetAt(i).Name,"%","_") //处理函数中包含“%”的情况 ADD By LiYang 2010-4-17
	.s strReturnType=cdef.Methods.GetAt(i).ReturnType
	.s ret=ret_","_strMethodName_" : function(){"_cr
	.s ret=ret_"return ExtTool.RunServerMethod1('"_strClassName_"','"_strMethodName_"',arguments);"_cr
	.s ret=ret_"}"_cr
	s ret=ret_"};"
	d cdef.%Close()
	k cdef
	q ret
}

ClassMethod RunClassMethod(ClassName, MethodName, Arg...)
{
	 s ret=$ZOBJCLASSMETHOD(ClassName,MethodName,Arg...)
	 
	 i $IsObject(ret)=0  d
	 .i $l(ret,$c(0))=1  d
	 ..s ret="<RESULT>OK</RESULT>"_ret
	 .e  d
	 ..s ret=$p(ret,$c(0),2)
	 e  d
	 .i ret.%ClassName(1)="%Library.ListOfObjects"  d
	 ..s retStr="<RESULT>OK</RESULT>["_$c(13)_$c(10)
	 ..s intCnt=ret.Count()
	 ..f i=1:1:intCnt  d
	 ...s tmpObj=ret.GetAt(i)
	 ...s retStr=retStr_..SerializeObject(tmpObj)
	 ...s:i<intCnt retStr=retStr_","_$c(13)_$c(10)
	 ..d ret.%Close()
	 ..k ret
	 ..s ret=retStr_"]"
	 .e  d
	 ..s tmp="<RESULT>OK</RESULT>"_..SerializeObject(ret)
	 ..d ret.%Close()
	 ..k ret
	 ..s ret=tmp
	 
     q ret
}

ClassMethod ReplaceString(Str, OldStr, NewStr) As %String
{
	set intCounter = 1
	while (1)
	{
		set tmp =$e(Str, intCounter, intCounter + $l(OldStr) - 1) 
		if (tmp = OldStr)
		{
			 set $e(Str, intCounter, intCounter + $l(OldStr) - 1) = NewStr
			 set intCounter = intCounter + $l(NewStr) - $l(OldStr)
		}
		quit:intCounter>=$l(Str)
		set intCounter = intCounter + 1
	}
	quit Str
}

ClassMethod SerializeObject(obj) As %String
{
	n (obj)
	s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(obj.%ClassName(1))
	s RowID=""
	s cr=$c(9)
	s:cdef.Storages.Count()>0 RowID=obj.%Id() //Add By LiYang 2010-4-17 处理没有存储的对象
	s ret="<ResultObject>var objTmp = {"_cr_"RowID : '"_RowID_"'"
	s intPropertyCnt=cdef.Properties.Count()
	f i=1:1:intPropertyCnt  d
	.s ret=ret_","_cr
	.s strPropertyName=cdef.Properties.GetAt(i).Name
	.s strType=cdef.Properties.GetAt(i).Type
	.s expression="s %strValue=obj."_strPropertyName
	.x expression
	.s:strType="%Date" %strValue=$zd(%strValue,3)
	.s:strType="%Time" %strValue=$zt(%strValue,1)
	.//s strValue=..ReplaceString(%strValue,$c(13),"\r")
	.//s strValue=..ReplaceString(%strValue,$c(10),"\n")
	.s strValue=..ReplaceString(%strValue,"'","\'")
	.s ret=ret_strPropertyName_":'"_%strValue_"'"
	s ret=ret_"};"
	d cdef.%Close()
	k cdef
	q ret
}

}
