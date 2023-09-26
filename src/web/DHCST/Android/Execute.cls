/// creator:yunhaibao
/// createdate:20160926
/// description:获取类,方法的类型参数等信息/执行方法以及query
Class web.DHCST.Android.Execute Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// 执行Query
ClassMethod ExecuteQuery(className As %String, classQuery As %String) As %String
{
	s rs=##class(%Library.ResultSet).%New(className_":"_classQuery)
	s x="d rs.Execute("
	s parametersNum=rs.GetParamCount()
	f i=1:1:parametersNum {
		s parameterName=rs.GetParamName(i)
		s parameterVal=$g(%request.Data(parameterName,1))
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"
	x x
	d ..GetQueryData(rs)
	q ""
}

ClassMethod GetQueryData(rs As %Library.ResultSet) As %String
{
	w "{rows:["
	s results=0
	s start=$G(%request.Data("start",1))
	s limit=$G(%request.Data("limit",1))
	if start="" s start=0
	if limit=""  s limit=100
	s outResults=0
	while rs.Next()'=0{
		i (results>=+start)&(results<+(start+limit)){
			i outResults'=0 w ","
			s columnNum=rs.GetColumnCount()
			w "{"
			f i=1:1:columnNum {
				s columnName=rs.GetColumnHeader(i)
				if (columnName="HIDDEN")
		        {
			       s columnName=columnName_i
		        }

				s columnValue=rs.GetData(i)
				s columnValue=$zcvt(columnValue,"O","JS")
				//s columnValue=columnValue_results
				w "'"_columnName_"':'"_columnValue_"'"
				i i'=columnNum w ","
			}
			w "}"
			s outResults=outResults+1
		}
		s results=results+1
		
	}
	w "],results:"_results_"}"
	q ""
}

/// 执行方法
/// w ##class(web.DHCST.Android.Execute).MethodExcute("web.DHCSTCOMMONSRV","GetSysDate")
ClassMethod ExecuteMethod(className As %String, methodName As %String) As %String
{
	s x="s ret=##class("_className_")."_methodName_"("
	s parametersNum=..GetParamCount(className,methodName)
	f i=1:1:parametersNum{
		s parameterName=..GetParamName(className,methodName,i)
		s parameterVal=$g(%request.Data(parameterName,1))
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"
	x x
	w ret
	q ""
}

ClassMethod GenerateMetaData(className As %String, classQuery As %String) As %String
{
	s rs=##class(%Library.ResultSet).%New(className_":"_classQuery)
	s columnNum=rs.GetColumnCount()
	s ret="{root:'rows',totalProperty:'results',fields:["
	f i=1:1:columnNum {
		s columnName=rs.GetColumnHeader(i)
		s ret=ret_"{'name':'"_columnName_"','mapping':'"_columnName_"'}"
		i i'=columnNum s ret=ret_","
	}
	s ret=ret_"]}"
	q ret
}

/// description:获取方法第N个参数名
ClassMethod GetParamName(className As %String, classMethod As %String, n As %Integer)
{
	n (className,classMethod,n)
	s methodParameter=^oddCOM(className,"m",classMethod,60)
	s parameterNum=$ll(methodParameter)
	s parameter=$li(methodParameter,n)
	s parameterName=$li(parameter,1)
	q parameterName
}

/// 获取方法参数个数
ClassMethod GetParamCount(className As %String, classMethod As %String)
{
	n (className,classMethod)
	s methodParameter=$G(^oddCOM(className,"m",classMethod,60))
	s parameterNum=$ll(methodParameter)
	q parameterNum
}

/// description:获取方法返回值类型
/// w ##class(web.DHCST.Android.Execute).GetMethodType("web.DHCST.Android.Common","GetMethodType")
ClassMethod GetMethodType(className As %String, methodName As %String) As %String
{
	q $g(^oddCOM(className,"m",methodName,42))
}

}
