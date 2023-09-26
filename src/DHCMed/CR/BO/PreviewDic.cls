/// 名称: DHCMed.CR.BO.PreviewDic
/// 描述: 解析字典
/// 编写者：wuqk
/// 编写日期: 2012-11-30
Class DHCMed.CR.BO.PreviewDic Extends %CSP.Page [ Not ProcedureBlock ]
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
	//m ^tmpcrf($j,$h,"PreviewDic")=%request.Data
	set Preview = + %request.Get("Preview",1)
	//set ^tmpcrf($j,$h,"Preview")=Preview
	set dicCode = %request.Get("dicCode",1)
	set WhereConditions=%request.Get("WhereConditions",1)
	//set Preview=%request.Get("Preview",1)
	// &WhereConditions=&Preview=1
	//set dicCode="Ctloc"
	//set WhereConditions="@text1^E"
	//set Preview=0
	
	set objDic = ##class(DHCMed.CR.BO.Dictionary).getObjectByCode(dicCode)
	if ('$IsObject(objDic)){ //Modified By LiYang 2013-11-06 没有配置字典时给出提示
		w "{Result:false,Message:'错误！此处没有配置字典项目，请联系管理员！'}"
		quit $$$OK
	}
	set rs = ..RunQuery()
	
	if Preview = 1 {
		d ..renderPage(rs,objDic)
	}
	else{
		d ..outputData(rs)
	}

	Quit $$$OK
ErrorTrap
	w "{Result:false,Message:'"_$ZE_"'}"
	Quit $$$OK
}

/// d ##class(DHCMed.CR.BO.PreviewDic).RunQuery()
/// 
ClassMethod RunQuery() As %ResultSet [ Private ]
{
	if WhereConditions'="" {
		for i=1:1:$l(WhereConditions,"^"){
			set val = $p(WhereConditions,"^",i)
			set:val["@" val=""
			set execute="set P"_i_"="""_val_""""
			x execute
		}
	}
	s ClassName = objDic.className
	s QueryName = objDic.queryName
	
	s qdef=##class(%Dictionary.QueryDefinition).%OpenId(ClassName_"||"_QueryName)
	q:'$IsObject(qdef)
	s formalSpec=qdef.FormalSpec
	s ArgCnt=0
	s:formalSpec'="" ArgCnt=$l(formalSpec,",")
	s rs=##class(%ResultSet).%New(ClassName_":"_QueryName)
	s startRecordNo="" //$g(%request.Data("start",1))
	s limitRecordCnt="" //$g(%request.Data("limit",1))

	n execute,i
	s execute="set %sc=$zobjmethod(rs,""Execute"""
	f i=1:1:ArgCnt  d 
	.s ArgName="P"_i
	.s execute=execute_",$g("_ArgName_")"
	s execute=execute_")"
	set ^tmpcrf($j,$h,"execute")=execute
	x execute
	
	q rs
}

ClassMethod outputData(rs As %ResultSet) As %Status [ Private ]
{
 
	s startRecordNo="" //$g(%request.Data("start",1))
	s limitRecordCnt="" //$g(%request.Data("limit",1))
	
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
	 q $$$OK
}

ClassMethod renderPage(rs As %ResultSet, objDic As DHCMed.CR.PO.Dic) As %Status [ Private ]
{
 
	s columns=rs.GetColumnCount()

 	&html<<html>
	<head>
	<title>>
	w objDic.dicName
	&html<</title>
	</head>
	<body style='background-color:#E9F2F7'>
	    <style type="text/css">
        td
        {
	        font-size:11px;
            background-color:White;
        }
    </style>
	<div id="grid"  style="text-align:center; padding-top:0px">
	<table border='0' cellpadding='' cellspacing='1' style='background-color:Green'>
	<tr>>
	for i=1:1:columns {
		&html<<th align=left style='background-color:White'>>
		w rs.GetColumnName(i)
		&html<</th>>
	}
	&html<</tr>>
	for {
		quit:rs.Next()=0
		&html<<tr>>
		for i=1:1:columns {
			&html<<td>>
			w ..getValue(rs.GetData(i))
			&html<</td>>
		}
		&html<</tr>>
	} 
	
	&html<</table></div></body>
	</html>>
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
	s return=..ReplaceString(return,$c(13),"")  // \n
	s return=..ReplaceString(return,$c(10),"")  // \r
	s return=..ReplaceString(return,$c(2),"<$C2>")
	s return=..ReplaceString(return,$c(5),"<$C5>")
	s return=..ReplaceString(return,$c(7),"<$C7>")
	quit return
}

}
