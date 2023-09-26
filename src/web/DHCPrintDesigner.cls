/// 名称: web.DHCPrintDesigner
/// 描述: 通过Ajax方式调用，异步返回数据方式
/// 入参：%request
///       ExcuteAction: 要执行的操作
///       Arg1...Argn:其它参数，参数名称需要按顺序定义
/// 返回：
///       返回值格式如：
///          当ExcuteAction为Read时：{record:[{ID:'1',XPC_Flag:'...'},{ID:'2',XPC_Flag:'....'}],total:2}
Class web.DHCPrintDesigner Extends %CSP.Page [ Not ProcedureBlock ]
{

/// 名称: OnPage
/// 描述: 处理前端httpRequest
ClassMethod OnPage() As %Status
{
		 new (%request,%session)
		  set $ZT="Error"
		  set excuteAction=$g(%request.Data("ExcuteAction",1))
		  if (excuteAction = "Add")
		  {
			  set reportNote = $g(%request.Data("reportNote",1))
			  set reportXml = $g(%request.Data("reportXml",1))
			  set reportName = $g(%request.Data("reportName",1))
			  set rs = ##class(web.DHCXMLPConfig).AddNewReport(reportXml,reportName,reportNote)
			  write "({data:[id:'" + rs + "'],success:true,totalProperty : 0})"
			  quit $$$OK
			  //quit rs
		  }
		  if (excuteAction = "Update")
		  {
			  set reportNote = $g(%request.Data("reportNote",1))
			  set reportXml = $g(%request.Data("reportXml",1))
			  set reportID = $g(%request.Data("reportID",1))
			  set rs = ##class(web.DHCXMLPConfig).UpdateReport(reportID,reportXml,reportNote)
		  	  quit rs
		  }
		  if (excuteAction = "Delete")
		  {
			  set ^Test123 ="ssss"
			  set reportID = $g(%request.Data("reportID",1))
			  set rs = ##class(web.DHCXMLPConfig).DeleteReportByID(reportID)
		  	  write "({data:null,success:true})"
		  	  quit $$$OK
		  }
		  if (excuteAction = "ReadAll")
		  {
			  set reportName = $g(%request.Data("reportName",1))
			  Set rsList = ##class(%ResultSet).%New("web.DHCXMLPConfig:ReadAllByName")
			  Set sc = rsList.Execute(reportName)
			  set jsonResult = ..GetJsonData(rsList)
			  write jsonResult
		  }
		  if (excuteAction = "ReadOne")
		  {
			  set reportID = $g(%request.Data("reportID",1))
			  set rsxml = ##class(web.DHCXMLPConfig).ReadXmlByID(reportID)
			  write rsxml
		  }
		  quit $$$OK
Error
		 write $ZE
		 set ^tmpQuery($h,$j,"ERR")=$ZE
		 quit $$$OK
}

/// 名称: GetJsonData
/// 描述: 将查询出来的数据输出为json字符串（不排序）
ClassMethod GetJsonData(rsData As %Library.ResultSet) As %String
{
	new startRecordNo,limitRecordCnt,columns,jsonStr,displayRows,cnt,rowData,tmpData
	//设定翻页
	set startRecordNo=$g(%request.Data("start",1))
	set limitRecordCnt=$g(%request.Data("limit",1))
	set columns=rsData.GetColumnCount()
	set cnt=0
	set jsonStr = ""
	set displayRows = 0
	while rsData.Next() '=0
	{
		if ((cnt'<startRecordNo)&&(displayRows<limitRecordCnt))
		{
			set rowData = ""
			set:displayRows>0 jsonStr=jsonStr_","
			for i=1:1:columns
			{
				set:i>1 rowData=rowData_","
		 		set rowData=rowData_rsData.GetColumnName(i)_":"
		 		set tmpData=rsData.GetData(i)
		 		set tmpData=..ReplaceCharacterForJS(tmpData)

				set rowData=rowData_"'"_tmpData_"'"

			}
			set jsonStr =jsonStr_"{"_rowData_"}"
			set displayRows = displayRows +1
		}
		set cnt=cnt +1
	}
	do rsData.%Close()
	if (jsonStr="")
	{
		set jsonStr = "({data:[],success:true,totalProperty : 0})"
	}
	else
	{
		set jsonStr = "({data:["_jsonStr_"],success:true,totalProperty : "_cnt_"})"
	}
	quit jsonStr
}

/// 描述: 替换字符串中的特殊字符
/// 入参：    Str,OldStr,NewStr
ClassMethod ReplaceString(Str, OldStr, NewStr) As %String
{
	new (Str,OldStr,NewStr)
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

/// 描述: 替换字符串中的特殊字符
/// 入参：    strCharacter
ClassMethod ReplaceCharacterForJS(strCharacter As %String) As %String
{
	new (strCharacter)
	set strCharacter=..ReplaceString(strCharacter,"'","\'")
	set strCharacter=..ReplaceString(strCharacter,$c(13),"\n")
	set strCharacter=..ReplaceString(strCharacter,$c(10),"\r")
	quit strCharacter
}

}
