Class dhc.sync.udata.uSyncLog Extends %SerialObject [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator: Hao Shanshan
/// CreatDate: 2013-09-24
/// Description: 查询用户名
/// Table: dhc_sync_data.Sync_User
/// Input: Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.uSyncLog).UserList(0,10,"陈")
ClassMethod UserList(start, limit, str)
{
	n (start, limit, str)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Sync_Code,Sync_Name from dhc_sync_data.Sync_User"
	i str'="" d
	.s sqlStr = sqlStr_" where  (LOWER(Sync_Name)  LIKE '%"_str_"%' "_" or  UPPER(Sync_Name) LIKE  '%"_str_"%')"
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	
	While(result.Next()){
		s rowid = result.Data("Sync_Code")
		s name = result.Data("Sync_Name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-09-24
/// Description: 查询系统名称
/// Table: dhc_sync_data.Sync_System
/// Input: Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.uSyncLog).SystemList(0,10,"")
ClassMethod SystemList(start, limit, str)
{
	n (start, limit, str)

	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "select Code,Name from dhc_sync_data.Sync_System "
	i str'="" d
	.s sqlStr = sqlStr_" where  (LOWER(Name)  LIKE '%"_str_"%' "_" or  UPPER(Name) LIKE  '%"_str_"%')"
	
	d result.Prepare(sqlStr)
	d result.Execute()

	s count = 0
	s resultString = ""
	s end = start+limit
	s json = ##class(herp.comm.JsonObj).%New()
	
	While(result.Next()){
		s rowid = result.Data("Code")
		s name = result.Data("Name")
		s tmp=rowid_"^"_name
		s count = count+1
		i (count>start)&(count<=end) d
		.d json.InsertRowData(tmp)
	}
	
	d result.Close()
	s resultString = json.getJsonData("rowid^name",count)
 	k json
	q resultString
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-09-24
/// Description: 查询符合条件的记录
/// Table: dhc_sync_data.Sync_SyncLog
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.uSyncLog).List("","","","",0,10)
ClassMethod List(user, system, sortField, sortDir, start, limit) As %String
{
 	n (user,system, sortField, sortDir, start, limit,%request)
 	write "{rows:"
 	set json = ##class(ext.util.JsonObject).ClassQuery2Json("dhc.sync.udata.uSyncLog","Find",start,limit,.total,user,system)
	write ",results:"_total_"}"
	q ""
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-09-24
/// Description: 插入一条记录
/// Table: dhc_sync_data.Sync_SyncLog
/// Input: Info -信息 UserCode -用户编码 SysCode -系统编码	data -数据
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.uSyncLog).InsertRec("add","LLD0172","OA","dcvdvdsvdvdv")
ClassMethod InsertRec(Info, UserCode, SysCode, data) As %String
{

    n (Info,UserCode,SysCode,data)
	
	&sql(insert into dhc_sync_data.Sync_SyncLog
	(Info,UserCode,SysCode,data) values(:Info,:UserCode,:SysCode,:data))
	
	q SQLCODE
}

/// Creator：Hao Shanshan
/// CreatDate：2013-09-24
/// Description: 更新记录
/// Others：w ##class(dhc.sync.udata.uSyncLog).UpdateRec(1,"add","OA","CCJ0018","啊啊啊啊")
ClassMethod UpdateRec(rowid, Info, UserCode, SysCode, data) As %String
{
 	n (rowid,Info,UserCode,SysCode,data)
    k PLIST
	
 	i Info      '=""  s Plist(2) = Info 
	i UserCode  '=""  s Plist(3) = UserCode   
	i SysCode   '=""  s Plist(4) = SysCode 
	i data      '=""  s Plist(5) = data	
	
	
	&SQL(UPDATE  dhc_sync_data.Sync_SyncLog VALUES Plist() where %ID=:rowid)
	
	q SQLCODE
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-09-24
/// Description：根据ID删除日志
/// Table： dhc_sync_data.Sync_SyncLog
/// Return：
/// Others: w ##class(dhc.sync.udata.uSyncLog).Delete("14")
ClassMethod Delete(rowid) As %String
{
 	n (rowid)
 	
	&SQL(delete  dhc_sync_data.Sync_SyncLog  where Rowid=:rowid)
	
	q SQLCODE
}

/// Creator : 佘斌
/// CreatDate : 2011-6-30
/// Description : 替换双引号
/// Input : 处理字串
/// Output ：
/// Return ：处理后字串
/// Others ：
ClassMethod ReplaceJS(str As %String) As %String [ WebMethod ]
{
	set str = $tr(str,$c(0))
	set str = ..ReplaceStr(str, "<","&lt;")
	set str = ..ReplaceStr(str, ">","&gt;")
	set str = ..ReplaceStr(str, ",","&gt;")
	set str = ..ReplaceStr(str, ":","&gt;")
	set str = ..ReplaceStr(str, ";","&gt;")
	set str = ..ReplaceStr(str, "\","\\")
	set str = ..ReplaceStr(str, """","\""")
	
	set str = ..ReplaceStr(str, "&#x0;","")
	set str = ..ReplaceStr(str, "&#x1;","")
	set str = ..ReplaceStr(str, "&#x2;","")
	set str = ..ReplaceStr(str, "&#x3;","")
	set str = ..ReplaceStr(str, "&#x4;","")
	set str = ..ReplaceStr(str, "&#x5;","")
	set str = ..ReplaceStr(str, "&#x6;","")
	set str = ..ReplaceStr(str, "&#x7;","")
	set str = ..ReplaceStr(str, "&#x8;","")
	set str = ..ReplaceStr(str, "&#x9;","")
	set str = ..ReplaceStr(str, "&#x10;","")
	set str = ..ReplaceStr(str, "&#x11;","")
	set str = ..ReplaceStr(str, "&#x12;","")
	set str = ..ReplaceStr(str, "&#x13;","")
	set str = ..ReplaceStr(str, "&#x14;","")
	set str = ..ReplaceStr(str, "&#x15;","")
	set str = ..ReplaceStr(str, "&#x16;","")
	set str = ..ReplaceStr(str, "&#x17;","")
	set str = ..ReplaceStr(str, "&#x18;","")
	set str = ..ReplaceStr(str, "&#x19;","")
	set str = ..ReplaceStr(str, "&#x1A;","")
	set str = ..ReplaceStr(str, "&#x1B;","")
	set str = ..ReplaceStr(str, "&#x1C;","")
	set str = ..ReplaceStr(str, "&#x1D;","")
	set str = ..ReplaceStr(str, "&#x1E;","")
	set str = ..ReplaceStr(str, "&#x1F;","")
	
	q str
}

/// Creator : 佘斌
/// CreatDate : 2011-6-30
/// Description : 字符串替换方法
/// Input : str: 原来的全部字符串。oldStr: 准备替换的字符串。newStr：新的字符串
/// Output ：
/// Return ：处理后字串
/// Others ：
ClassMethod ReplaceStr(str As %String, oldStr As %String, newStr As %String) As %String
{
	n (str,oldStr,newStr)
	set count = $Length(str, oldStr)
	if count > 1
	{
		set tmpRetVal = ""
		for I = 1:1:count
		{
			set tmpRetVal = tmpRetVal_$p(str,oldStr,I)_newStr
		}
		set str = $extract(tmpRetVal,1,$Length(tmpRetVal)-$l(newStr))
	}
	q str
}

/// 对JSON数据字符特殊字符处理
/// JSON 中的特殊字符
/// $c(13)
/// $c(10)
/// \
/// '
ClassMethod EvalJSON(instr As %String) As %String
{
	q ##class(ext.util.String).EvalJSON(instr)
}

Query Find(user, system) As %SQLQuery(CONTAINID = 1, ROWSPEC = "rowid:%String,Info:%String,UserCode:%String,SysCode:%String,data:%String")
{
	select rowid,Info,UserCode,SysCode,data from dhc_sync_data.Sync_SyncLog 
	where ((UserCode=:user) or (:user is null) or (:user="")) 
	and ((SysCode=:system) or (:system is null) or (:system="")) order by rowid desc
}

Storage Default
{
<StreamLocation>^dhc.sync.udata.uSyncLogS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
