/// 名称: DHCWMR.ClassMethodService
/// 描述: 运行类方法
/// 编写者：zhufei
/// 编写日期: 2014-08-26
Class DHCWMR.ClassMethodService Extends DHCWMR.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// w ##class(DHCWMR.ClassMethodService).StaticObject("DHCWMR.Abstract")
ClassMethod StaticObject(strClassName) As %String
{
	// s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(strClassName)      // P7以下使用
	s cdef = ##class(%Library.CompiledClass).%OpenId(strClassName)              // P8以上
	s ret=""
	s cr=$c(9)
	s ret=ret_ "var objTmp = { aafn : function(){return true;}"_cr
	s intMethodCnt=cdef.Methods.Count()
	f i=1:1:intMethodCnt  d
	.s objMethod=cdef.Methods.GetAt(i)
	.q:objMethod.ClassMethod=0 //Modified By LiYang 2012-06-30 只序列化类方法，不序列化实例方法
	.s strMethodName=$tr(objMethod.Name,"%","_") //处理函数中包含“%”的情况 ADD By LiYang 2010-4-17
	.q:((strMethodName["IsValid")!(strMethodName["DisplayToLogical")!(strMethodName["GetStored")!(strMethodName["Normalize")) //Modified By LiYang 2012-06-30 处理编译后自动生成的函数
	.q:((strMethodName["LogicalToXSD")!(strMethodName["OdbcToLogical")!(strMethodName["XSDToLogical")!(strMethodName["LogicalToDisplay")) //Modified By LiYang 2012-06-30 处理编译后自动生成的函数
	.q:((strMethodName["LogicalToDisplay")!(strMethodName["LogicalToOdbc")!(strMethodName["_")!(strMethodName["XML")) //Modified By LiYang 2012-06-30 处理编译后自动生成的函数
	.;w strMethodName_"  "_objMethod.ClassName_"  "_objMethod.ClassMethod_" "_objMethod.ReturnType,!
	.s strReturnType=objMethod.ReturnType
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
	 
	 s cr=$c(9)
	 i $IsObject(ret)=0  d
	 .i $l(ret,$c(0))=1  d
	 ..s ret="<RESULT>OK</RESULT>"_ret
	 .e  d
	 ..s ret=$p(ret,$c(0),2)
	 e  d
	 .i ret.%ClassName(1)="%Library.ListOfObjects"  d
	 ..s retStr="<RESULT>OK</RESULT>["_cr
	 ..s intCnt=ret.Count()
	 ..f i=1:1:intCnt  d
	 ...s tmpObj=ret.GetAt(i)
	 ...s retStr=retStr_..SerializeObject(tmpObj)
	 ...s:i<intCnt retStr=retStr_","_cr
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
	// s cdef = ##class(%Dictionary.ClassDefinition).%OpenId(obj.%ClassName(1))      // P7以下使用
	s cdef = ##class(%Library.CompiledClass).%OpenId(obj.%ClassName(1))              // P8以上
	s RowID=""
	s cr=$c(9)
	//s:cdef.Storages.Count()>0 RowID=obj.%Id() //Add By LiYang 2010-4-17 处理没有存储的对象
	//s:cdef.Super["%Persistent" RowID=obj.%Id()      //P8以上
	s:cdef.Persistent=1 RowID=obj.%Id()               //P7以下使用
	s ret="<ResultObject>var objTmp = {"_cr_"RowID : '"_RowID_"'"
	s intPropertyCnt=cdef.Properties.Count()
	f i=1:1:intPropertyCnt  d
	.//Modified By LiYang 2011-06-18 如果某个属性是对象，则返回其Rowid，否则返回其值
	.s objProperty=cdef.Properties.GetAt(i)
	.q:objProperty.Private=1 //私有属性不能序列化
	.s ret=ret_","_cr
	.s strPropertyName=$tr(objProperty.Name,"%","_")
	.s strType=objProperty.Type
	.s %strValue=$ZObjProperty(obj,objProperty.Name)
	.i $IsObject(%strValue)  d
	..s objProClass=##class(%Dictionary.ClassDefinition).%OpenId(%strValue.%ClassName(1))
	..;w %strValue.%ClassName(1)_"    "_objProClass
	..q:$IsObject(objProClass)=0 
	..s:objProClass.Super["%Persistent" %strValue=%strValue.%Id()
	..;s expression="s %strValue=obj."_strPropertyName_".%Id()"
	.s:((strType["Date")&&(%strValue'="")) %strValue=$zd(%strValue,3)
	.s:((strType["Time")&&(%strValue'="")) %strValue=$zt(%strValue,1)
	.s strValue=..ReplaceString(%strValue,$c(13),"\r")
	.s strValue=..ReplaceString(strValue,$c(10),"\n")
	.s strValue=..ReplaceString(strValue,"'","\'")
	.s ret=ret_strPropertyName_":'"_strValue_"'"
	//.w strPropertyName_":'"_strValue_"'",!
	s ret=ret_"};"
	d cdef.%Close()
	k cdef
	q ret
}

Storage Default
{
}

}
