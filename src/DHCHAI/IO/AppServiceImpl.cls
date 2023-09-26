/// 名称: DHCHAI.IO.AppServiceImpl
/// 描述: webservice调用Query框架
/// 编写者：陈剑波
/// 编写日期: 2020-04-17
Class DHCHAI.IO.AppServiceImpl Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     chenjb
/// CreatDate：   2020-04-15
/// Description:  调用后台类Query方法入口
/// Input：       
/// Return：      jsonStr
/// w ##class(DHCHAI.IO.AppServiceImpl).QueryExecImpl("DHCHAI.BTS.LocationSrv","QryLoc","6","{""Arg5"":""1"",""Arg4"":""E"",""Arg3"":""I"",""Arg2"":"""",""Arg1"":""1"",""start"":""1"",""limit"":""10"",""Arg6"":""""}")
ClassMethod QueryExecImpl(aClassName As %String, aQueryName As %String, aArgCnt As %String, aArgStr As %String)
{
	New (aClassName,aQueryName,aArgCnt,aArgStr)	
	Set return =""
	Set ClassName=aClassName
	Set QueryName=aQueryName
	Set ArgCnt=+aArgCnt	
	Set rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	Set ArgObj = ##class(%DynamicAbstractObject).%FromJSON(aArgStr)
	//w ArgObj.%ToJSON()

	Set startRecordNo=ArgObj.%Get("start")
	Set limitRecordCnt=ArgObj.%Get("limit")
	Set:startRecordNo="" startRecordNo=0
	Set:limitRecordCnt="" limitRecordCnt=65535

	Set ReturnType=..GetReturnType(ClassName,QueryName)
	n execute,i
	k PLIST
	Set execute="set %sc=$zobjmethod(rs,""Execute"""
	if ArgCnt>0 {
		f i=1:1:ArgCnt  d
		.s ArgName="Arg"_i
		.s PLIST(i)=ArgObj.%Get(ArgName)
		.s execute=execute_",PLIST("_i_")"
	}
	s execute=execute_")"
	x execute
	//s mydesc=##class(%CSP.Page).EscapeHTML($g(t(myArrayIdx)))
	//s mydesc=##class(%CSP.Page).QuoteJS($g(t(myArrayIdx)))
	s cnt=0
	s displayRows=0
	s rowData=""
	Set return="{""data"":["
	s columns=rs.GetColumnCount()
	f  q:rs.Next()=0  d
	.i ((cnt'<startRecordNo)&&(displayRows<limitRecordCnt))!(startRecordNo="")!(limitRecordCnt="")  d
	..Set:displayRows>0 return=return_","
	..Set return=return_"{"
	..s rowData=""
	..f i=1:1:columns  d
	...s:i>1 rowData=rowData_","
	...s fieldInfo=$p(ReturnType,",",i)
	...s fieldType=$p(fieldInfo,":",2)
	...s rowData=rowData_""""_rs.GetColumnName(i)_""" : "
	...s tmpData=rs.GetData(i)
	...s tmpData=##class(%CSP.Page).QuoteJS($g(tmpData))
	...s tmpData=..ReplaceString(tmpData,"\x2F","\/")  //解决json中/报错
	...s tmpData=..ReplaceString(tmpData,"\x00","")    //解决json中不可见空白报错
	...s tmpData=..ReplaceString(tmpData,"\\","")      //解决json中\报错
	...i (($e(tmpData,1,1)="'"))  d
	....s tmpData=..ReplaceString(tmpData,"\'","'")
	....s rowData=rowData_""""_$e(tmpData,2,$l(tmpData)-1)_""""  //用"替换' s rowData=rowData_tmpData
	...e  d
	....s:fieldType="" fieldType="%String"
	....i fieldType="%String"  d //根据返回数据类别增加引号，方便前台数据排序
	.....s rowData=rowData_""""_tmpData_""""    //
	....e  d
	.....s:((tmpData="")&&(fieldType="%Integer")) rowData=rowData_"0"
	.....s:((tmpData="")&&(fieldType="%Float")) rowData=rowData_"0"
	.....s:tmpData'="" rowData=rowData_tmpData
	..Set return=return_rowData
	..Set return=return_"}"
	..s displayRows=displayRows+1
	.s cnt=cnt+1
	Set return=return_"],""recordsTotal"":"""_cnt_""",""displayRows"":"""_displayRows_""",""message"":""获取成功。""}"
	d rs.%Close()
	Quit return
}

/// Creator：     chenjb
/// CreatDate：   2020-04-15
/// Description:  调用后台类方法入口
/// Input：       
/// Return：      jsonStr
/// w ##class(DHCHAI.IO.AppServiceImpl).QueryMethodImpl("DHCHAI.BTS.LocationSrv","MethodExecTestObj","1","{""Arg1"":""1""}")
ClassMethod QueryMethodImpl(aClassName As %String, aQueryName As %String, aArgCnt As %String, aArgStr As %String)
{
	New (aClassName,aQueryName,aArgCnt,aArgStr)	
	Set ClassName=$g(aClassName)
	Set MethodName=$g(aQueryName)
	Set return =""
	Set ArgCnt=+aArgCnt	
	Set ArgObj = ##class(%DynamicAbstractObject).%FromJSON(aArgStr)
	s execute=""
 	s i=""
 	s execute="s ret=$ZOBJCLASSMETHOD(ClassName,MethodName"
 	k PLIST
 	
 	f i=1:1:ArgCnt  d 
 	.s ArgName="Arg"_i
	.s PLIST(i)=ArgObj.%Get(ArgName)
 	.s execute=execute_",PLIST("_i_")"
 	s execute=execute_")"
 	x execute
 	//i $IsObject(ret)'=0  w "-101"
 	//结果只能是字符串或者对象
 	if $IsObject(ret)=0 {	 	
	 	Set return ="{""message"":""成功。"",""data"":"""_ret_"""}"
	}
	else
	{		
		Set objTmp = ##class(DHCHAI.Utils.JsonObject).%New() 
		Set return="{""message"":""成功。"",""data"":"_objTmp.FromObject(ret).Json()_"}"
		//Set return=objTmp.Put("data",ret).Put("message","成功。").Json()
	}	
	Quit return
}

ClassMethod GetReturnType(ClassName As %String, QueryName As %String) As %String
{
	New (ClassName, QueryName)
	Set ret=""
	Set cdef = ##class(%Dictionary.CompiledClass).%OpenId(ClassName)
	set count = cdef.Queries.Count() 
	For i = 1:1:count {
		if (cdef.Queries.GetAt(i).Name=QueryName)
	 	{		 	
	 		Set ret=cdef.Queries.GetAt(i).Parameters.GetAt("ROWSPEC")
		}	 
	}
	k cdef
	Quit ret
}

ClassMethod ReplaceString(Str As %String, OldStr As %String, NewStr As %String) As %String
{
	New (Str, OldStr, NewStr)
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

}
