Import SQLUser

/// 名称: 码表数据日志管理
/// 编写者：基础数据平台组-李森
/// 编写日期: 2013-1-29
Class web.DHCBL.CT.BDPDataChangeLog Extends %RegisteredObject [ ProcedureBlock ]
{

/*
/// Creator：李森
/// CreatDate: 2013-1-29
/// Description：查询码表数据日志的内容
/// Table：User.BDPDataChangeLog
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPDataChangeLog","GetList","","","")
Query GetList(ClassN As %String, UserDR As %String, UserName As %String, Date As %String) As %SQLQuery(CONTAINID = 1)
{
	select ID,TableName,ClassName,ObjectReference,UpdateUserDR->SSUSR_Initials as UpdateUserDR,UpdateUserName,
	TO_CHAR(UpdateDate,'MM/DD/YYYY') as UpdateDate,CONVERT(varchar(100),UpdateTime,8) as UpdateTime,
	OperateType,NewValue from BDP_DataChangeLog where (ClassName like '%'_:ClassN_'%' or :ClassN is null) 
	and (UpdateUserDR->SSUSR_Initials like '%'_:UserDR_'%' or :UserDR is null) 
	and (UpdateUserName like '%'_:UserName_'%' or :UserName is null) 
	and (TO_CHAR(UpdateDate,'MM/DD/YYYY')=:Date or :Date is null)
}
*/
/// Creator：李森
/// CreatDate: 2013-1-29
/// Description：添加码表数据日志
/// Table：User.BDPDataChangeLog
/// Other: d ##class(web.DHCBL.CT.BDPDataChangeLog).SaveLog("","","","U","")
ClassMethod SaveLog(TableName As %String, ClassName As %String, ObjectReference As %String, OperateType As %String, NewValue As %String) As %String
{
	s result=""
	if (TableName=""){
		s result="表名不能为空!"
	}elseif(ClassName=""){
		s result="类名不能为空!"
	}elseif(ObjectReference=""){
		s result="对象ID不能为空!"
	}elseif(OperateType=""){
		s result="修改类型不能为空!"
	}elseif '$d(%session){
		s result="获取不到session!"
	}else{
		Ts
		s obj=##class(User.BDPDataChangeLog).%New()
		s obj.TableName = TableName
		s obj.ClassName = ClassName
		s obj.ObjectReference = ObjectReference
		d obj.UpdateUserDRSetObjectId($Get(%session.Data("LOGON.USERID")))
		s obj.UpdateUserName = $Get(%session.Data("LOGON.USERNAME"))
		s obj.OperateType = OperateType
		s:NewValue'="" obj.NewValue = NewValue.JsonS()
		s sc=obj.%Save()
		d obj.%Close()
		If $$$ISOK(sc){
			Tc
			s result="添加成功!"
		}else{
			Trollback
			s result="添加失败!"
		}
	}
	q result
}

/// Creator：李森
/// CreatDate: 2013-1-30
/// Description：根据ID删除日志
/// Table：User.BDPDataChangeLog
/// Return：成功返回"{success:'true',info:'删除成功！'}"；失败返回"{success:'false'和失败原因}
ClassMethod DeleteData(str As %String) As %String
{
	s result="",i="",id=""
	for i=1:1:$length(str,"^")-1
	{
		s id=$p(str,"^",i)
		s sc=##class(User.BDPDataChangeLog).%DeleteId(id)
	}
	if $$$ISOK(sc)
	{
		s result = "{success:'true',info:'删除成功！'}"
	}
	else
	{
		s result = "{success:'false',info:'"_$zconvert(sc,"O","JS")_"'}"  //返回错误信息
	}
	q result
}

/// Creator：李森
/// CreatDate: 2013-1-29
/// Description：查询码表数据日志的内容
/// Table：User.BDPDataChangeLog
/// d ##class(%ResultSet).RunQuery("web.DHCBL.CT.BDPDataChangeLog","GetList","","","","")
Query GetList(ClassN As %String, UserDR As %String, UserName As %String, Date As %String) As %Query(ROWSPEC = "ID:%String,TableName:%String,ClassName:%String,ObjectReference:%String,UpdateUserDR:%String,UpdateUserName:%String,UpdateDate:%String,UpdateTime:%String,OperateType:%String,NewValue:%String")
{
}

ClassMethod GetListExecute(ByRef qHandle As %Binary, ClassN As %String, UserDR As %String, UserName As %String, Date As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	
	s:ClassN'="" ClassN=$$ALPHAUP^SSUTIL4(ClassN) //转换成大写
	s:UserDR'="" UserDR=$$ALPHAUP^SSUTIL4(UserDR) //转换成大写
	s:UserName'="" UserName=$$ALPHAUP^SSUTIL4(UserName) //转换成大写
	s ID=0
	f  s ID=$o(^User.BDPDataChangeLogD(ID)) q:ID=""  d
	.s TableName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),2)
	.s ClassName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),3)
	.s ObjectReference=$LISTGET($G(^User.BDPDataChangeLogD(ID)),4)
	.s UpdateUserDR=$LISTGET($G(^User.BDPDataChangeLogD(ID)),5)
	.s:UpdateUserDR'="" UpdateUserDR=$p($G(^SSU("SSUSR",UpdateUserDR)),"^",1) //获取用户名
	.s UpdateUserName=$LISTGET($G(^User.BDPDataChangeLogD(ID)),6)
	.s UpdateDate=$LISTGET($G(^User.BDPDataChangeLogD(ID)),7)
	.s:UpdateDate'="" UpdateDate=$zd(UpdateDate,1) //转换日期格式
	.s UpdateTime=$LISTGET($G(^User.BDPDataChangeLogD(ID)),8)
	.s:UpdateTime'="" UpdateTime=$zt(UpdateTime,1) //转换时间格式	
	.s OperateType=$LISTGET($G(^User.BDPDataChangeLogD(ID)),9)
	.s NewValue=$LISTGET($G(^User.BDPDataChangeLogD(ID)),10)
	.i ($$ALPHAUP^SSUTIL4(ClassName)[ClassN)&($$ALPHAUP^SSUTIL4(UpdateUserDR)[UserDR)&($$ALPHAUP^SSUTIL4(UpdateUserName)[UserName)&(UpdateDate[Date) d
	..d OutputRow
		
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
    set Data=$lb(ID,TableName,ClassName,ObjectReference,UpdateUserDR,UpdateUserName,UpdateDate,UpdateTime,OperateType,NewValue)
    set ^CacheTemp(repid,ind)=Data
    Set ind=ind+1
    quit
}

ClassMethod GetListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind=""
	{
		//if there are no more rows,finish fetching...
		Set AtEnd=1
		Set Row=""
	}
	Else
	{
		Set Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
