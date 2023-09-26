/// 护理计划获取数据类
Class web.DHCNurPlanGetData Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod MethodExcute(className As %String, methodName As %String) As %String
{
	
	s x="s ret=##class("_className_")."_methodName_"("
	s ParaCount=..GetParaCount(className,methodName)
	f i=1:1:ParaCount
	{
		s ParaName=..GetParaName(className,methodName,i)
		//s ^Tmp("MethodExcute")=ParaCount_"^"_ParaName
		s ParaValue=$g(%request.Data(ParaName,1))
		s x=x_""""_ParaValue_""""
		i i'=ParaCount s x=x_","
	}
	s x=x_")"
	x x
	w ret
	q ""
}

ClassMethod QueryExcute(className As %String, QueryName As %String) As %String
{
	s rs=##class(%Library.ResultSet).%New(className_":"_QueryName)
	s x="d rs.Execute("
	s parametersNum=rs.GetParamCount()
	f i=1:1:parametersNum 
	{
		s parameterName=rs.GetParamName(i)
		s parameterVal=$g(%request.Data(parameterName,1))
		s x=x_""""_parameterVal_""""
		i i'=parametersNum s x=x_","
	}
	s x=x_")"
	x x
	d ..GetQueryData1(rs)
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
	//s ^TMP("101")=start_"|"_limit

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

ClassMethod GetQueryData1(rs As %Library.ResultSet) As %String
{
	w "{"_"""rows"""_":"_"["
	s results=0
	s page=$G(%request.Data("page",1))
	s rows=$G(%request.Data("rows",1))
	i rows'="" s limit=+rows
	i (page'="")&(rows'="") s start=(+page-1)*(+rows)
	if $g(start)="" s start=0
	if $g(limit)=""  s limit=100
	//s ^TMP("101")=start_"|"_limit

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
				w """"_columnName_""":"""_columnValue_""""
				i i'=columnNum w ","
			}
			w "}"
			s outResults=outResults+1
		}
		s results=results+1
		
	}
	w "],"_"""total"""_":"_results_"}"
	q ""
}

ClassMethod GetParaCount(className As %String, methodName As %String) As %String
{
	n (className,methodName)
	s Parr=$g(^oddCOM(className,"m",methodName,60))
	//$ll---$lb
	s ParrNum=$ll(Parr)
	q ParrNum
}

ClassMethod GetParaName(className As %String, methodName As %String, No As %Integer) As %String
{
	n (className,methodName,No)
	s ParrList=$g(^oddCOM(className,"m",methodName,60))
	s Parr=$li(ParrList,No)
	s ParrName=$li(Parr,1)
	q ParrName
}

}
