/// 名称: DHCMed.CR.BO.RunMethod
/// 描述: 运行Query方法
/// 编写者：wuqk
/// 编写日期: 2012-11-29
Class DHCMed.CR.BO.RunQuery Extends %CSP.Page [ Not ProcedureBlock ]
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
	s ClassName=%request.Data("ClassName",1)
	s QueryName=%request.Data("QueryName",1)
	s qdef=##class(%Dictionary.QueryDefinition).%OpenId(ClassName_"||"_QueryName)
	q:'$IsObject(qdef) $$$OK
	s formalSpec=qdef.FormalSpec
	m ^tmpcrf($j,$h,"request")=%request.Data
	s ArgCnt=0
	s:formalSpec'="" ArgCnt=$l(formalSpec,",")
	s rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	s startRecordNo=$g(%request.Data("start",1))
	s limitRecordCnt=$g(%request.Data("limit",1))

	 n execute,i
	 k PLIST
	 s execute="set %sc=$zobjmethod(rs,""Execute"""
	 f i=1:1:ArgCnt  d 
	 .s ArgName="P"_i
	 .s PLIST(i)=%request.Get(ArgName,1)
	 .s execute=execute_",PLIST("_i_")"
	 s execute=execute_")"
	set ^tmpcrf($j,$h,"execute")=execute
	 x execute
	 
	
	 s cnt=0
	 s displayRows=0
	 s rowData=""
	 w "{record:[",!
	 s columns=rs.GetColumnCount()
	 f  q:rs.Next()=0  d
	 .i ((cnt'<startRecordNo)&&(displayRows<limitRecordCnt))!(startRecordNo="")!(limitRecordCnt="")  d
	 ..w:displayRows>0 ","
	 ..w "{"
	 ..s rowData=""
	 ..f i=1:1:columns  d
	 ...s:i>1 rowData=rowData_","
	 ...s rowData=rowData_rs.GetColumnName(i)_" : "
	 ...s tmpData=rs.GetData(i)
	 ...s tmpData=..getValue(tmpData)
	 ...s rowData=rowData_"'"_tmpData_"'"
	 ..w rowData
	 ..w "}",!
	 ..s displayRows=displayRows+1
	 .s cnt=cnt+1
	 w "],total : "_cnt_",Result:true}"
	 d rs.%Close()
 
	Quit $$$OK
	
ErrorTrap
	set ret="{Result:false,Message:'"_$ZE_"'}"
	w ret
	Quit $$$OK
}

ClassMethod ReplaceString(Str, OldStr, NewStr) As %String [ Private ]
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

ClassMethod getValue(tmpData) As %String [ Private ]
{
	set return = ""
	s return=..ReplaceString(tmpData,"'","\'")
	s return=..ReplaceString(return,$c(13),"\n")
	s return=..ReplaceString(return,$c(10),"\r")
	s return=..ReplaceString(return,$c(2),"<$C2>")
	s return=..ReplaceString(return,$c(5),"<$C5>")
	s return=..ReplaceString(return,$c(7),"<$C7>")
	quit return
}

}
