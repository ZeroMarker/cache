Class CSM.DataInterface Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn/CSM";

/// Name of the WebService.
Parameter SERVICENAME = "DataInterface";

/// 说明：执行SQL查询，无分页
/// 参数：parQueryString: SQL字串
/// 返回值：有结果－JSON串，无结果－空JSON串，错误－错误描述字串
/// gaojb 2010-9
ClassMethod ExecQuery(parQueryString As %String) As %String [ WebMethod ]
{
	q:($d(parQueryString)=0) "null parameter: parQueryString"
	q:(parQueryString="") "empty parameter: parQueryString"
	
	s $zt="errhandler"
	;b "s"
	s parQueryString=..UnEscape(parQueryString)
	
	Set rs=##class(%ResultSet).%New("%DynamicQuery:SQL")
	
	s result=rs.Prepare(parQueryString)
	q:(result'=1) ..CleanErrorMsg(result)
	
	Set columns = rs.GetColumnCount()
	s result=rs.Execute()
	q:(result'=1) ..CleanErrorMsg(result)
	
	set result="[",firstFlag=0,exceedSizeFlag=0
	
	While (rs.Next()) {
		set:(firstFlag=0) result=result_"{"
		set:(firstFlag'=0) result=result_",{"
		set firstFlag=1
		
	  // loop over columns
	  For col = 1:1:columns {
		  	set colName=rs.GetColumnName(col)
	      set:(col<columns) result=result_colName_":"""_rs.Get(colName)_""","
	      set:(col=columns) result=result_colName_":"""_rs.Get(colName)_""""
	  }
	  s result=result_"}"
	  
	  s:($l(result)>28000) exceedSizeFlag=1 ;limit the length of JSON string to 28k(<32k)
	  
	  q:(exceedSizeFlag=1)
	}
	
	Do rs.Close()
	
	q:(exceedSizeFlag=1) "Query result exceeds the max size of 28k"
	
	set result=result_"]"

	q result
	
errhandler
	q ..CleanErrorMsg($ze)
}

/// 说明：执行SQL查询，有分页
/// 参数：parQueryString: SQL字串
///       parPageSize: 每页记录数量
///       parPageNum: 页数
/// 返回值：有结果－JSON串，无结果－空JSON串，错误－错误描述字串
/// gaojb 2010-9
ClassMethod ExecQueryByPage(parQueryString As %String, parPageSize As %Integer, parPageNum As %Integer) As %String [ WebMethod ]
{
	q:($d(parQueryString)=0) "null parameter: parQueryString"
	q:(parQueryString="") "empty parameter: parQueryString"
	q:($d(parPageSize)=0) "null parameter: parPageSize"
	q:(parPageSize=0) "zero parameter: parPageSize"
	q:($d(parPageNum)=0) "null parameter: parPageNum"
	q:(parPageNum=0) "zero parameter: parPageNum"
	
	s $zt="errhandler"
	
	s parQueryString=..UnEscape(parQueryString)
	
	Set rs=##class(%ResultSet).%New("%DynamicQuery:SQL")
	
	s result=rs.Prepare(parQueryString)
	q:(result'=1) ..CleanErrorMsg(result)
	
	Set columns = rs.GetColumnCount()
	s result=rs.Execute()
	q:(result'=1) ..CleanErrorMsg(result)
	
	set result="[",firstFlag=0,exceedSizeFlag=0,counter=0
	
	While (rs.Next()) {
		s counter=counter+1
		continue:(counter'>(parPageSize*(parPageNum-1)))
		q:(counter>(parPageSize*parPageNum))
		
		set:(firstFlag=0) result=result_"{"
		set:(firstFlag'=0) result=result_",{"
		set firstFlag=1
		
	  // loop over columns
	  For col = 1:1:columns {
		  	set colName=rs.GetColumnName(col)
	      set:(col<columns) result=result_colName_":"""_rs.Get(colName)_""","
	      set:(col=columns) result=result_colName_":"""_rs.Get(colName)_""""
	  }
	  s result=result_"}"
	  
	  s:($l(result)>28000) exceedSizeFlag=1 ;limit the length of JSON string to 28k(<32k)
	  
	  q:(exceedSizeFlag=1)
	}
	
	Do rs.Close()
	
	q:(exceedSizeFlag=1) "Query result exceeds the max size of 28k"
	
	set result=result_"]"
	q result
	
errhandler
	q ..CleanErrorMsg($ze)
}

/// 说明：执行非查询SQL命令，无事务
/// 参数：parQueryString: SQL字串
/// 返回值：成功－1，失败－错误描述字串
/// gaojb 2010-9
ClassMethod ExecNonQuery(parQueryString As %String) As %String [ WebMethod ]
{
	q:($d(parQueryString)=0) "null parameter: parQueryString"
	q:(parQueryString="") "empty parameter: parQueryString"

	s $zt="errhandler"
	;s ^csmtest("non query",1)=parQueryString
	s parQueryString=..UnEscape(parQueryString)
	;s ^csmtest("non query",2)=parQueryString
	Set rs=##class(%ResultSet).%New("%DynamicQuery:SQL")
	
	s result=rs.Prepare(parQueryString)
	q:(result'=1) ..CleanErrorMsg(result)
	
	s result=rs.Execute()
	q:(result'=1) ..CleanErrorMsg(result)
	
	q result
	
errhandler
	q ..CleanErrorMsg($ze)
}

/// 说明：批量执行非查询SQL命令，有事务
/// 参数：parQueryString: SQL字串，多条SQL用"~"分隔
/// 返回值：成功－1，失败－错误描述字串
/// gaojb 2010-9
ClassMethod ExecNonQueryBatch(parQueryString As %String) As %String [ WebMethod ]
{
	q:($d(parQueryString)=0) "null parameter: parQueryString"
	q:(parQueryString="") "empty parameter: parQueryString"

	s $zt="errhandler"
	s splitter="~"
	
	Do $System.SQL.Login("_system","SYS")
	
	ts
	
	for i=1:1:$l(parQueryString,splitter) {
		s queryStr=$p(parQueryString,splitter,i)
		s result=""
		s result=..ExecNonQuery(queryStr)
		quit:(result'=1)
	}
	
	if (result'=1) {
		tro
		q result
	}
	
	tc
	
	q result
	
errhandler
	q ..CleanErrorMsg($ze)
}

/// 说明：解码非ASCII字符
/// 参数：InStr: 需要解码的字串
/// 返回值：成功－解码后的字串，失败－"Error"
/// gaojb 2010-9
/// Debug: w ##Class(CSM.DataInterface).UnEscape("insert into CSM.Project (Name,Description,Code,ChargeHospital,ChargeDept,Charger,PrjLevel,StartDate,EndDate,Status) values('%u533B%u9662%u4E34%u5E8A','%u6492%u6253%u7B97%u7684','1001','%u5237%u5237%u5237','%u5446%u5446%u5730','%u5237%u5237%u5237','%u9662%u7EA7','9/7/2010 12:00:00 AM','9/30/2010 12:00:00 AM',NULL)")
ClassMethod UnEscape(InStr As %String) As %String
{
	;b "s"
	s $zt="errhandler"
	;s ^csmtest($h,1)=InStr
	q:(InStr="") ""
	s num=1,tmpNum=1,retStr=""
	;s InStr=$zcvt(InStr,"l")
	;w InStr,!
	
	for num=1:1:$l(InStr,"%") {
		;b "s"
		s char=$p(InStr,"%",num)
		if (num=1)
		{
			s retStr=$e(char,1,$l(char))
		}
		else
		{
			if ($zcvt($e(char,1,1),"U")'="U")
			{
				;b
				s retStr=retStr_$char($zhex($e(char,1,2)))_$e(char,3,$l(char))
			}
			else
			{
				;b
				s retStr=retStr_$char($zhex($e(char,2,5)))_$e(char,6,$l(char))
			}
		}
	}
	
	s retStr=$tr(retStr,"`","%")
	;s ^csmtest($h,2)=retStr
	q retStr
	
errhandler
	q "Error"
}

/// 说明：去除字串中的不可见字符
/// 参数：InStr: 目标字串
/// 返回值：去掉不可见字符的字串
/// gaojb 2010-9
ClassMethod CleanErrorMsg(errMsg As %String) As %String
{
	s result=""
	q:(errMsg="") ""
	
	for i=1:1:$l(errMsg)
	{
		s ascii=$a(errMsg,i)
		if ((ascii>31)&&(ascii<127)&&(ascii'=39)) {
			s result=result_$e(errMsg,i,i)}
	}
	
	q result
}

/// 检查一个表是否存在，不区分大小写
/// 参数：parTableFullName，表的完整名字
/// 返回值：1－存在，0－不存在，-1－出错
ClassMethod IsTableExist(parTableFullName As %String) As %String [ WebMethod ]
{
	q:(parTableFullName="") "-1"
	
	s $zt="errhandle"

	/// 获取CSM包下的所有表，循环比对是否有参数中指定的表名
  s result=""
  s result=$System.OBJ.GetPackageList(.tableList,"CSM")
  q:(result'=1) "-1"
  q:($d(tableList)'=10) "0"

  s tableName=""
  s tableName=$o(tableList(tableName))
  while (tableName'="")
  {
	  q:($zcvt(tableName,"l")=$zcvt(parTableFullName,"l"))
	  s tableName=$o(tableList(tableName))
  }
  
  q:($zcvt(tableName,"l")=$zcvt(parTableFullName,"l")) "1"
  q "0"
  
errhandle
	q "-1"
}

/// 得到系统中所有全名以参数中字符开头的表，用^分割
ClassMethod GetTableByPrefix(parPrefix As %String) As %String [ WebMethod ]
{
	s $zt="errhandle"

	/// 获取CSM包下的所有表，循环比对是否有参数中指定的表名
  q:($System.OBJ.GetPackageList(.tableList,"CSM")'=1) ""

  q:($d(tableList)'=10) ""

  s tableName="",result="["
  s tableName=$o(tableList(tableName))
  while (tableName'="")
  {
	  if $f($zcvt(tableName,"l"),$zcvt(parPrefix,"l"))=($l(parPrefix)+1) {
		  //s result=result_$lb($lb(tableName))
		  if result="[" {
			  s result=result_""""_tableName_""""
		  }else{
			  s result=result_","_""""_tableName_""""
		  }
		  
		}
	  s tableName=$o(tableList(tableName))
  }
  s result=result_"]"
  ;b
  //q ..BuildJSON($lb("TableName"),result)
  q result
  
errhandle
	q "error"
}

/// 得到系统中全名等于参数的类名，参数不区分大小写
ClassMethod GetTableName(parFullName As %String) As %String
{
	s $zt="errhandle"

	/// 获取CSM包下的所有表，循环比对是否有参数中指定的表名
  q:($System.OBJ.GetPackageList(.tableList,"CSM")'=1) ""

  q:($d(tableList)'=10) ""

  s tableName="",result=""
  s tableName=$o(tableList(tableName))
  while (tableName'="")
  {
	  if $zcvt(tableName,"l")=$zcvt(parFullName,"l") {
		  s result=tableName
		}
	  s tableName=$o(tableList(tableName))
  }
  ;b
  q result
  
errhandle
	q "error"
}

/// 构造JSON字串
/// 参数：parNameList－字段名称List，parValueList－字段值的List的List
/// 返回值：JSON串
/// debug：
/// >s a=$lb("a","b","c")
/// >s b=$lb($lb(1,2,3),$lb(4,5,6))
/// >w ##class(CSM.DataInterface).BuildJSON(a,b)
/// >[{a:"1",b:"2",c:"3"},{a:"4",b:"5",c:"6"}]
ClassMethod BuildJSON(parNameList As %List, parValueList As %List) As %String
{
	s $zt="error"
	
	/// 检查参数
	q:($d(parNameList)=0)||($d(parValueList)=0) "parameter null"
	q:((parNameList="")||(parValueList="")) "parameter empty"
	
	s nameLen=$ll(parNameList)
	q:(nameLen=0) "parNameList no item"
	
	s valueLen=$ll(parValueList)
	q:(valueLen=0) "parValueList no item"
	
	/// 拼字串
	s result=""
	for i=1:1:valueLen
	{
		s items=$lg(parValueList,i)
		s itemLen=$ll(items)
		if (itemLen=0) {s result="items length 0" q}
		
		if (itemLen'=nameLen) {s result="items' count not equal to nameList's" q}
		
		s tmp=""
		for j=1:1:itemLen
		{
			s:(tmp'="") tmp=tmp_","_$lg(parNameList,j)_":"""_$lg(items,j)_""""
			s:(tmp="") tmp=$lg(parNameList,j)_":"""_$lg(items,j)_""""
		}
		
		s:(result'="") result=result_",{"_tmp_"}"
		s:(result="") result="{"_tmp_"}"
	}
	
	s result="["_result_"]"
	
	q result
	
error
	q "error"
}

/// 得到指定表名的表的字段信息
/// 参数：类的完整名称，不区分大小写
/// 返回值：[{Name:"AppDesc",Type:"%String",Length:"500"},{Name:"AppName",Type:"%String",Length:"50"},{Name:"AppURL",Type:"%String",Length:"100"}]
ClassMethod GetTableInfo(parTableFullName As %String) As %String [ WebMethod ]
{
	s $zt="errhandle"
	s tmpList=""
	s parTableFullName=..GetTableName(parTableFullName)
	q:(parTableFullName="") ""
	s cdef=##class(%ClassDefinition).%OpenId(parTableFullName)
	
	for i=1:1:cdef.Properties.Count() {
		s aCloumn=cdef.Properties.GetAt(i)
		s tmpList=tmpList_$lb($lb(aCloumn.Name,aCloumn.Type,aCloumn.Parameters.GetAt("MAXLEN")))
	}
		
	d cdef.%Close()
		
	q ..BuildJSON($lb("Name","Type","Length"),tmpList)
errhandle
	q "error"
}

ClassMethod test()
{
	;w ##Class(CSM.DataInterface).UnEscape("select * from CSM.Application where `SQLUPPER(AppName) like '`%25U5B89%25U8D1E%25U533B%25U9662%25U79D1%25U7814%25U9879%25U76EE`' and `SQLUPPER(AppDesc) like '`%25U5B89%25U8D1E%25U533B%25U9662%25U79D1%25U7814%25U9879%25U76EE`' and `SQLUPPER(AppURL) like '`WWW.BAIDU.COM`'")
	;w ##Class(CSM.DataInterface).UnEscape("%U5B89%U8D1E%U533B%U9662%U79D1%U7814%U9879%U76EE")
	;w ##Class(CSM.DataInterface).UnEscape("insert into CSM.Project (Name,Description,Code,ChargeHospital,ChargeDept,Charger,PrjLevel,StartDate,EndDate,Status) values('%u533B%u9662%u4E34%u5E8A','%u6492%u6253%u7B97%u7684','1001','%u5237%u5237%u5237','%u5446%u5446%u5730','%u5237%u5237%u5237','%u9662%u7EA7','9/7/2010 12:00:00 AM','9/30/2010 12:00:00 AM',NULL)")
	;w $System.SQL.Login("_system","SYS"),!
	k SQLCODE
	&sql(create table CSM_CRF.G000001( PatProjGrpID int, NUM int, text1 varchar(100), textarea1 varchar(100), numbertext1 int, datetext1 varchar(50), timetext1 varchar(50), checkbox1 varchar(100)))
	W SQLCODE,!
	q
}

ClassMethod CreateTable() As %Integer
{
 &sql(CREATE TABLE TEST.EMPLOYEE (
    EMPNUM              INT NOT NULL,
    NAMELAST            CHAR (30) NOT NULL,
    NAMEFIRST           CHAR (30) NOT NULL,
    STARTDATE           TIMESTAMP,
    SALARY              MONEY,
    ACCRUEDVACATION     INT,
    ACCRUEDSICKLEAVE    INT,
    CONSTRAINT EMPLOYEEPK PRIMARY KEY (EMPNUM)))
        
 Write "SQL: ",SQLCODE,!
 QUIT SQLCODE
}

}
