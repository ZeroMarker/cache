/// 名称: 码表数据日志管理
/// 编写者：郝珊珊
/// 编写日期: 2013-8-6
Class dhc.sync.udata.SyncChangeLog Extends (%SerialObject, %RegisteredObject) [ ClassType = serial, Not ProcedureBlock ]
{

/// Creator：
/// CreatDate: 2013-8-6
/// Description：添加码表数据日志
/// Table：User.BDPDataChangeLog
/// LastUpdate:2013-8-6
/// Other: d ##class(dhc.sync.udata.SyncChangeLog).SaveLog("1","2","3","4","5","U","1","1","w")
ClassMethod SaveLog(TableName, ClassName, ClassNameDesc, ObjectReference, ObjectDesc, OperateType, NewValue, userId, uname) As %String
{
	n (TableName,ClassName, ClassNameDesc, ObjectReference, ObjectDesc, OperateType, NewValue,userId,uname)
	
	s result=""
	i TableName="" s result="表名不能为空!"
	e  i ClassName="" s result="类名不能为空!"
	e  i OperateType="" s result="修改类型不能为空!"
	e  i '$d(%session) s result="获取不到session!"
	e  d
		Ts
		s obj=##class(dhc.sync.data.ChangeLog).%New()
		s obj.TableName = TableName
		s obj.ClassName = ClassName
		s obj.ClassNameDesc = ClassNameDesc    //类描述
		s obj.ObjectReference = ObjectReference
		s obj.ObjectDesc = ObjectDesc  //对象描述
		d obj.UpdateUserDRSetObjectId(userId)
		s obj.UpdateUserName = uname
		s obj.OperateType = OperateType
		s obj.NewValue = NewValue
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			;w "ok"
			Tc
			s result="添加成功!"
		}else{
			;w "f"
			Trollback
			s result="添加失败!"
		}
	q result
}

/// Creator：Hao Shanshan
/// CreatDate: 2013-1-30
/// Description：根据ID删除日志
/// Table： dhc.sync.data.ChangeLog
/// Return：成功返回"0"；失败返回"1"
ClassMethod Delete(str) As %String
{
	n (str)
	for i=1:1:$length(str,"^")-1
	{
		s id=$p(str,"^",i)
		s sc=##class(dhc.sync.data.ChangeLog).%DeleteId(id)
	}
	if $$$ISOK(sc)
	{
		s result = 0
	}
	else
	{
		s result = 1
	}
	q result
}

/// Creator: Hao Shanshan
/// CreatDate: 2013-06-04
/// Description: 查询符合条件的记录
/// Table: dhc_sync_data.Sync_User
/// Input: searchField-查询字段;searchValue-查询值;sortField-排序字段;sortDir-排序方向;Start-起始行;Limit-行数;
/// Output: 
/// Return: 返回查询到的记录的Json串
/// others:w ##class(dhc.sync.udata.SyncChangeLog).List("","","","2013-08-09",0,25)
ClassMethod List(cname, Odesc, updUname, upddate, name, start, limit) As %String
{
	n (cname, Odesc,updUname, upddate,name,start,limit)
	
	i upddate'="" 	s upddate=$zdh(upddate,3)
	s sqlStr="select *,UpdateUserDR->SSUSR_Initials as uname from dhc_sync_data.Sync_ChangeLog where %id>0 "
	i cname'="" 	s sqlStr=sqlStr_" and ClassName like '%"_cname_"%' or ClassNameDesc like '%"_cname_"%' "
	i Odesc'="" 	s sqlStr=sqlStr_" and ObjectDesc like '%"_Odesc_"%'"
	i updUname'="" 	s sqlStr=sqlStr_" and UpdateUserName like '%"_updUname_"%'"
	i upddate'="" 	s sqlStr=sqlStr_" and UpdateDate = '"_upddate_"'"
	i name'=""		s sqlStr=sqlStr_" and UpdateUserDR->SSUSR_Initials like '%"_name_"%'"
	
	s sqlStr=sqlStr_" order by %ID desc"
	;w sqlStr,!
	
	s result=##class(%Library.ResultSet).%New()
	d result.Prepare(sqlStr)
	d result.Execute()
	
	s count=0
	s resultString=""
	s end=start+limit-1
	
	s json=##class(herp.comm.JsonObj).%New()
	s jsonTitle="rowid^TableName^ClassName^ObjectReference^UpdateUserDR^UpdateUserName"
		_"^UpdateDate^UpdateTime^OperateType^NewValue^ClassNameDesc^ObjectDesc"
	;w jsonTitle,!
	
	s UserCode=""
	While(result.Next())
	{
		s rowid=result.Data("ID")
		s TableName=result.Data("TableName")
		s ClassName=result.Data("ClassName")
		s ObjectReference=result.Data("ObjectReference")
		s UpdateUserDR=result.Data("uname")
		s UpdateUserName=result.Data("UpdateUserName")
		s UpdateDate=result.Data("UpdateDate")
		s UpdateDate=$zd(UpdateDate,3)
		s UpdateTime=result.Data("UpdateTime")
		s UpdateTime=$zt(UpdateTime,3)
		s OperateType=result.Data("OperateType")
		s NewValue=result.Data("NewValue")
		s ClassNameDesc=result.Data("ClassNameDesc")
		s ObjectDesc=result.Data("ObjectDesc")
		
		s tmp=rowid_"^"_TableName_"^"_ClassName_"^"_ObjectReference_"^"_UpdateUserDR
		_"^"_UpdateUserName_"^"_UpdateDate_"^"_UpdateTime_"^"_OperateType_"^"_NewValue
		_"^"_ClassNameDesc_"^"_ObjectDesc
		;w tmp,!
		i (count>=start)&(count<=end) d
		.d json.InsertRowData(tmp)
		s count=count+1
	}

	d result.Close()
	s resultString = json.getJsonData(jsonTitle,count)
 	k json
	q resultString
}

Storage Default
{
<StreamLocation>^dhc.sync.udata.SyncChangeLogS</StreamLocation>
<Type>%Storage.Serial</Type>
}

}
