/// Ext访问后台通用类
Class web.DHCExtCommon Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// 名称: Excute
/// 描述: 用于调用相应的query
ClassMethod Excute(methodType As %String) As %Status
{
	 	new (%request,%session,methodType)
	 	k ^tmpMethod
	 	set $ZT="Error"
	 	if (methodType = "GridQuery")
		{
			s myrtn=..GridQuery()
		}
		elseif (methodType = "ComonQuery")
		{
			s myrtn=..CommonQuery()
		}
		elseif (methodType = "ClassMethod")
		{
			s myrtn=..ExcuteMethod()
		}
		quit $$$OK
Error
	  w $tr($ZE,"<","\")
      s ^tmpMethod($h,$j,"ERR")=$ZE
	  quit $$$OK
}

/// 名称: OutPutExtScript
/// 描述: 用于输出ExtJS文件
ClassMethod OutPutExtScript(path As %String) As %Status
{
	;Ext Version 3.3.1
	;d ##class(ext.websys.ExtLib).Version321()
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_path_"../scripts_lib/ext3.3.1/resources/css/ext-all.css"" />"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_path_"../scripts_lib/ext3.3.1/adapter/ext/ext-base.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_path_"../scripts_lib/ext3.3.1/ext-all.js""></script>"
	s myCode($i(myCode))= " "_"<script type=""text/javascript"" src="""_path_"../scripts_lib/ext3.3.1/src/locale/ext-lang-zh_CN.js""></script>"
	s myCode($i(myCode))= " "_"<link rel=""stylesheet"" type=""text/css"" href="""_path_"../skin/default/css/websys.ext.3.3.1.css"" charset=""utf-8""/>"
	s myCode($i(myCode))= " "_"<script>var BLANK_IMAGE_URL='"_path_"../scripts_lib/ext3.3.1/resources/images/default/s.gif';</script>"
	
	f myIdx=1:1:myCode {
		w myCode(myIdx),!
	}
}

/// 名称: ExcuteMethod
/// 描述: 用于调用ClassMethod  
ClassMethod ExcuteMethod() As %Status
{
	     new (%request,%session)
		 //set $ZT="Error"
		 set strMethodData=%request.Data("MethodSignature",1)
		 set strClassName=$p(strMethodData,":")
		 set strMethodName=$p(strMethodData,":",2)
		 set Syn=+$g(%request.Data("syn",1))
		 
		 set ret=""
		 set execute=""
		 set i=""
		 set execute="set ret=$ZOBJCLASSMETHOD("""_strClassName_""","""_strMethodName_""""
		 
		 set index = 1
		 set arg="Arg"_index
		 while ($D(%request.Data(arg,1)) '= 0) && ($D(%request.Data(arg,1))'=10)
		 {
			 set val=$g(%request.Data(arg,1))
			 set val=##class(web.DHCExtUtil).ReplaceQuotation(val)
			 set execute=execute_","""_val_""""
			 set index = index +1
			 set arg = "Arg"_index
		 }
		 set execute=execute_")"
		 do ..log()

		 set ret=##class(web.DHCExtCommon).ParseMethod(execute)
		 if Syn do
		 .set ret="OK"_$c(13)_$c(10)_ret
		 //write ret
		 quit $$$OK
		 //Error
		 //w $tr($ZE,"<","\")
		 //s ^tmpMethod($h,$j,"ERR")=$ZE
		 //quit $$$OK
}

/// 名称: ParseMethod
/// 描述: 将对象序列化为json字符串
ClassMethod ParseMethod(str) As %String
{
		 set ret=""
		 x str
		 if $IsObject(ret)=0  {
			 	if ret =0
			 	{
				 	write "({success:'false'})"
			 	}
			 	else
			 	{
			 		write "({success:'true'})"
			 	}
			 }
		 else{
			 set ret=##class(web.DHCExtUti).SerializeObject(ret)
			 if $e(ret,1,1)'="["{
				 set ret="["_ret_"]"
				 }
			  set ret="({data:"_ret_"})"
			  write ret
			 }
		 quit ret
}

/// 名称: CommonQuery
/// 描述: ListBox,Combox控件通过Ajax方式调用，异步返回数据方式	
ClassMethod CommonQuery() As %Status
{
	 	 new (%request,%session)
		 //set $ZT="Error"
		 set strMethodData=%request.Data("MethodSignature",1)
		 set rs=##class(%ResultSet).%New(strMethodData)
		 
	 	 set execute="set %sc=$zobjmethod(rs,""Execute"""
		 set i=""
		 
		 set index = 1
		 set arg="Arg"_index
		 while ($D(%request.Data(arg,1)) '= 0) && ($D(%request.Data(arg,1))'=10)
		 {
			 set val=$g(%request.Data(arg,1))
			 set val=##class(web.DHCExtUtil).ReplaceQuotation(val)
			 set execute=execute_","""_val_""""
			 set index = index +1
			 set arg = "Arg"_index
		 }
		 set execute=execute_")"
		 do ..log()

		 x execute
		
	
		 set displayRows=0
		 set rowData=""
		 write "({data:[",!
		 set columns=rs.GetColumnCount()
		 	
		 while rs.Next() '=0
		 {
		 	set rowData=""
		 	for i=1:1:columns
		 	{
		 		set:i>1 rowData=rowData_","
		 		set rowData=rowData_rs.GetColumnName(i)_":"
		 		set tmpData=rs.GetData(i)
		 		set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,"'","\'")
		 		set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,$c(13),"\n")
		 		set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,$c(10),"\r")
			 	set rowData=rowData_"'"_tmpData_"'"
		 	}
		 		
			 write:displayRows>0 ","
			 write "{"_rowData_"}",!
		 	 set displayRows=displayRows+1
		 }
		 write "],success:true})"
		 do rs.%Close()
		 quit $$$OK
		 //Error
		 //write $ZE
		 //set ^tmpQuery($h,$j,"ERR")=$ZE
		 //quit $$$OK
}

/// 名称: GridQuery
/// 描述: Grid控件通过Ajax方式调用，异步返回数据方式
ClassMethod GridQuery() As %Status
{
	     new (%request,%session)
		 //set $ZT="Error"
		 set strMethodData=%request.Data("MethodSignature",1)
		 set rs=##class(%ResultSet).%New(strMethodData)
		 set execute="set %sc=$zobjmethod(rs,""Execute"""
		 set i=""
		 
		 set index = 1
		 set arg="Arg"_index
		 while ($D(%request.Data(arg,1)) '= 0) && ($D(%request.Data(arg,1))'=10)
		 {
			 set val=$g(%request.Data(arg,1))
			 set val=##class(web.DHCExtUtil).ReplaceQuotation(val)
			 set execute=execute_","""_val_""""
			 set index = index +1
			 set arg = "Arg"_index
		 }
		 set execute=execute_")"
		 do ..log()
		 x execute

		 //根据排序方式输出数据
	 	 set sortCol=$g(%request.Data("sort",1))
	 	 set sortDir=$g(%request.Data("dir",1))
		 if (($ASCII(sortCol)'=-1) && ($ASCII(sortDir)'=-1))
		 {
			 if ($F(sortCol,",")>0)
			 {
				 set jsonResult = ..GetDefaultSort(rs,sortCol)
			 }
			 else{
			 	set jsonResult = ..GetDataBySort(rs)
			 }
		 }
		 else
		 {
			 set jsonResult = ..GetDataNoSort(rs)
		 }
		 write jsonResult
		 quit $$$OK
		 //Error
		 //write $ZE
		 //set ^tmpQuery($h,$j,"ERR")=$ZE
		 //quit $$$OK
}

/// 名称: GetDataNoSort
/// 描述: 将查询出来的数据输出为json字符串（不排序）
ClassMethod GetDataNoSort(rsData As %Library.ResultSet) As %String
{
	//new (%request,%session,rsData)
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
		 		set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,"'","\'")
		 		set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,$c(13),"\n")
		 		set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,$c(10),"\r")
				set rowData=rowData_"'"_tmpData_"'"
			}
			set jsonStr =jsonStr_"{"_rowData_"}"
			set displayRows = displayRows +1
		}
		set cnt=cnt +1
	}
	do rsData.%Close()
	set jsonStr = "({data:["_jsonStr_"],success:true,totalProperty : "_cnt_"})"
	quit jsonStr
}

/// 名称: GetDataBySort
/// 描述: 将查询出来的数据根据单一字段排序并输出为json字符串
ClassMethod GetDataBySort(rsData As %Library.ResultSet) As %String
{
	//new (%request,%session,rsData)
	new startRecordNo,limitRecordCnt,sortCol,sortDir,tempid,columns,cnt,rowData,tmpData,sortData,tempDir,jsonStr,displayRows,index,nextKey,key
	//设定翻页
	s startRecordNo=$g(%request.Data("start",1))
	s limitRecordCnt=$g(%request.Data("limit",1))
	 //设定排序
	 s sortCol=$g(%request.Data("sort",1))
	 s sortDir=$g(%request.Data("dir",1))
	 set tempid=$I(^CacheTempSort)
	 set columns=rsData.GetColumnCount()
	 set cnt=0
	 while rsData.Next() '=0
	 {
		set rowData = ""
		for i=1:1:columns
		{
			set:i>1 rowData=rowData_","
		 	set rowData=rowData_rsData.GetColumnName(i)_":"
		 	set tmpData=rsData.GetData(i)
		 	set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,"'","\'")
		 	set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,$c(13),"\n")
		 	set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,$c(10),"\r")
			set rowData=rowData_"'"_tmpData_"'"
			if (sortCol = rsData.GetColumnName(i))
			{
				set sortData = tmpData
			}
		}
		if sortData = ""
		{
			set sortData = " "
		}
		set ^CacheTempSort(tempid,sortData,cnt)="{"_rowData_"}"
		set cnt=cnt +1
	 }
	 do rsData.%Close()
	 if (cnt = 0)
	 {
		 quit "({data:[],success:true,totalProperty : "_cnt_"})"
	 }
	 if ($ZCONVERT(sortDir,"U") = "DESC")
	 {
		 set tempDir = -1
	 }
	 else
	 {
		 set tempDir = 1
	 }
	set jsonStr = ""
	set displayRows = 0
	set index = 0
	set nextKey = ""
	set key = $o(^CacheTempSort(tempid,""),tempDir)
	while key'="" {
		if (nextKey = "")
		{
			set nextKey = $o(^CacheTempSort(tempid,key,""),tempDir)
		}
		if (nextKey '="")
		{
			if ((index'<startRecordNo)&&(displayRows<limitRecordCnt))
			{
				set:displayRows>0 jsonStr=jsonStr_","
				set jsonStr = jsonStr_^CacheTempSort(tempid,key,nextKey)
				set displayRows = displayRows +1
			}
			set index = index +1
			set nextKey = $o(^CacheTempSort(tempid,key,nextKey),tempDir)
			if (nextKey = "")
			{
				set key = $o(^CacheTempSort(tempid,key),tempDir)
			}
			if (displayRows'<limitRecordCnt)
			{
				quit
			}
		}
	}
	k ^CacheTempSort(tempid)
	set jsonStr = "({data:["_jsonStr_"],success:true,totalProperty : "_cnt_"})"
	quit jsonStr
}

/// 名称: GetDefaultSort
/// 描述: 将查询出来的数据根据多个默认排序字段排序并输出为json字符串
ClassMethod GetDefaultSort(rsData As %Library.ResultSet, sortCol As %String)
{
	//new (%request,%session,rsData,sortCol)
	new tempid,columns,cnt,rowData,tmpData,sortData,jsonStr
	set tempid=$I(^CacheTempSort)
	set columns=rsData.GetColumnCount()
	set cnt=1
	while rsData.Next() '=0
	{
		set rowData = ""
		for i=1:1:columns
		{
			set:i>1 rowData=rowData_","
		 	set rowData=rowData_rsData.GetColumnName(i)_":"
		 	set tmpData=rsData.GetData(i)
		 	set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,"'","\'")
		 	set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,$c(13),"\n")
		 	set tmpData=##class(web.DHCExtUtil).ReplaceString(tmpData,$c(10),"\r")
			set rowData=rowData_"'"_tmpData_"'"
		}

		set sortData = ..GetSortColData(rsData,sortCol)
		do ..SetSortData(sortData,"{"_rowData_"}",tempid,cnt)
		set cnt=cnt +1
	}
	do rsData.%Close()
	set jsonStr = ..GetSortData(sortCol,tempid)
	k ^CacheTempSort(tempid)
	set jsonStr = "({data:["_jsonStr_"],success:true,totalProperty : "_(cnt-1)_"})"
	quit jsonStr
}

/// 名称: SetSortData
/// 描述: 将排序的数据设定到临时表中
ClassMethod SetSortData(sortData As %List, rowDataStr As %String, tempid As %Integer, index As %Integer)
{
	new (sortData,rowDataStr,tempid,index)
	SET count = $LISTLENGTH(sortData)
	set executeScript = "set ^CacheTempSort(tempid,"
	for i=1:1:count
	{
		set executeScript = executeScript_"$LISTGET(sortData,"_i_"),"
	}
	set executeScript = executeScript_index_")= rowDataStr"
	
	x executeScript
}

/// 名称: GetSortData
/// 描述: 取得排序的数据
ClassMethod GetSortColData(rsData As %Library.ResultSet, sortCols As %String) As %List
{
	new (rsData,sortCols)
	SET delim = "|"
	SET count=$LENGTH(sortCols,delim)
	FOR index=1:1:count {
		SET extract = $PIECE(sortCols,delim,index)
		set colName = $PIECE(extract,",",1)
		set colData = rsData.Data(colName)
		set $li(allSortData,index)= colData
	}
	quit allSortData
}

/// 名称: GetSortData
/// 描述: 取得排序的数据
ClassMethod GetSortData(sortCols As %String, tempid As %Integer) As %String
{
	new (%request,%session,tempid,sortCols)
	SET delim = "|"
	SET count=$LENGTH(sortCols,delim)
	FOR index=1:1:count {
		set extract = $PIECE(sortCols,delim,index)
		set sortdir = $PIECE(extract,",",2)
		set $li(allSortDir,index)= sortdir
	}
	
	set $li(sortKeyList,1)=tempid
	set indexNo = 0
	set displayRows = 0
	set jsonStr = ""
	do ..GetSortedData(sortKeyList,allSortDir,1,.indexNo,.displayRows,.jsonStr)
	quit jsonStr
}

/// 名称: SortData
/// 描述: 排序数据
ClassMethod GetSortedData(sortKeyList As %List, sortDirList As %List, sortIndex As %Integer, ByRef indexNo As %Integer, ByRef displayRows As %Integer, ByRef sortString As %String) As %Boolean
{
	new (%request,%session,sortKeyList,sortDirList,sortIndex,indexNo,displayRows,sortString)
	//设定翻页
	set startRecordNo=$g(%request.Data("start",1))
	set limitRecordCnt=$g(%request.Data("limit",1))
	
	set nullStr = ""
	set keyCount = $LISTLENGTH(sortKeyList)
	set sortLength = $LISTLENGTH(sortDirList)
	set sortdir = 1
	if (sortIndex '> sortLength)
	{
		set sortdir = $LISTGET(sortDirList,sortIndex)
	}
	set key = ""
	set sortScript = ..GetSortScript(sortKeyList,sortIndex +1,0)
	set sortScript = "set key= $o("_sortScript_","_sortdir_")"
	x sortScript
	
	set rsFlg = 1
	while key '="" {
		if (sortIndex = (sortLength+1))
		{
			if (displayRows < limitRecordCnt)
			{
				//set nextSortKeyList = sortKeyList
				set $li(sortKeyList,keyCount+1)=key
				if (indexNo '< startRecordNo)
				{
					set:displayRows>0 sortString = sortString_","
					set getDataScript = ..GetSortScript(sortKeyList,sortIndex +1,0)
					set getDataScript = " set rowData = "_getDataScript
					x getDataScript
					set sortString = sortString_rowData
					set displayRows = displayRows +1
				}
				set indexNo = indexNo +1
				set sortScript  = ..GetSortScript(sortKeyList,sortIndex +1,0)
				set sortScript = "set key= $o("_sortScript_","_sortdir_")"
				x sortScript
			}
			else
			{
				set rsFlg = 0
				quit 
			}
		}
		else
		{
			//set nextSortKeyList = sortKeyList
			//set $li(nextSortKeyList,keyCount+1)=key
			set $li(sortKeyList,keyCount+1)=key
			set sortNextIndex = sortIndex +1
			//对下一个子节点排序
			set rsFlg = ..GetSortedData(sortKeyList,sortDirList,sortNextIndex,.indexNo,.displayRows,.sortString)
			if rsFlg = 0
			{
				quit
			}
			else
			{
				//对下一个同层节点排序
				set keyLength =  $LISTLENGTH(sortKeyList)
				
				if (sortIndex > keyLength)
				{
					quit
				}
				set sortScript  = ..GetSortScript(sortKeyList,keyLength,0)
				set sortScript = "set key= $o("_sortScript_","_sortdir_")"
				x sortScript
			}
		}
	}
	quit rsFlg
}

/// 名称: GetSortScript
/// 描述: 取得排序参数脚本
ClassMethod GetSortScript(sortKeyList As %List, sortIndex As %Integer, isNext As %Boolean) As %String
{
	new (sortKeyList,sortIndex,isNext)
	set keyCount = $LISTLENGTH(sortKeyList)
	set sortScript = "^CacheTempSort("
	FOR index=1:1:sortIndex {
		set:index>1 sortScript = sortScript_","
		if (index '> keyCount)
		{
			if (isNext = 1)
			{
				set sortScript = sortScript_"$LISTGET(nextSortKeyList,"_index_")"
			}
			else
			{
				set sortScript = sortScript_"$LISTGET(sortKeyList,"_index_")"
			}
		}
		else
		{
			set sortScript = sortScript_"nullStr"
		}
	}
	set sortScript = sortScript_")"
	quit sortScript
}

/// 名称: log
/// 描述: 记录日志
ClassMethod log()
{
		set ^tmpQuery($h,$j,"QUERY")=strMethodData
		set ^tmpQuery($h,$j,"IP")=$zu(67,15,$j)
		set ^tmpQuery($h,$j,"RUN")=execute
		quit
}

}
