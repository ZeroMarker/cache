Class dhc.sync.web.ChangeLog Extends %RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("dhc.sync.web.Loc","Find","","","")
Query Find(TableName, ClassName, UpdateUserName, UpdateDate, OperateType) As websys.Query(CONTAINID = 1, ROWSPEC = "CLogId,CLogTableName,CLogClassName,CLogObjectReference,CLogUpdateUserDR,CLogUpdateUserName,CLogUpdateDate,CLogUpdateTime,CLogOperateType,CLogNewValue,CLogClassNameDesc,CLogObjectDesc")
{
}

ClassMethod FindExecute(ByRef QHandle As %Library.Binary, TableName, ClassName, UpdateUserName, UpdateDate, OperateType) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	set UpdateDate=##class(websys.Conversions).DateHtmlToLogical(UpdateDate)
	;ID	ClassName	ClassNameDesc	NewValue	ObjectDesc	ObjectReference	OperateType	TableName	UpdateDate	UpdateTime	UpdateUserDR	UpdateUserName
	Set CLogId=""
	for {
		Set CLogId = $Order(^dhcsyncChangeLogD(CLogId),-1)
		Quit:CLogId=""
		If $d(^dhcsyncChangeLogD(CLogId),g){
			Set CLogTableName = $lg(g,2)
			Continue:(CLogTableName'="")&&(CLogTableName'[TableName)
			Set CLogClassName = $lg(g,3)
			Continue:(CLogClassName'="")&&(CLogClassName'[ClassName)
			Set CLogUpdateUserName = $lg(g,6) ; CLogUpdateUserName=""
			;Set:CLogUpdateUserDR'="" CLogUpdateUserName=$p(^SSU("SSUSR",CLogUpdateUserDR),"^",2)
			Continue:(UpdateUserName'="")&&(CLogUpdateUserName'[UpdateUserName)
			Set CLogUpdateDate = $lg(g,7)
			Continue:(UpdateDate'="")&&(UpdateDate'=CLogUpdateDate)
			Set $list(g,7)=##class(websys.Conversions).DateLogicalToHtml(CLogUpdateDate)
			;Set $list(g,8)=$zt($list(g,8))
			Set $list(g,8)=##class(websys.Conversions).TimeLogicalToHtml($list(g,8))
			Set CLogOperateType = $list(g,9)
			Continue:(OperateType'="")&&(OperateType'=CLogOperateType)
			Set $list(g,9)=$case(CLogOperateType,"R":"查询","A":"增加","U":"更新","E":"导出","I":"导入",:OperateType)
			Set $list(g,1)=CLogId
			;$LB(CLogId,TableName,ClassName,ObjectReference,UpdateUserDR,UpdateUserName,UpdateDate,UpdateTime,OperateType,NewValue,ClassNameDesc,ObjectDesc)
			Set ^CacheTemp(repid,ind)=g
			Set ind=ind+1
		}
	}
	Set QHandle=$lb(0,repid,0)
	quit $$$OK
}

Query FindOPType() As websys.Query(CONTAINID = 1, ROWSPEC = "OPCode:%String,OPDesc:%String")
{
}

ClassMethod FindOPTypeExecute(ByRef QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = GetIdFromCodeOrDescription ]
{
	
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set QHandle=$lb(0,repid,0)
	Set ^CacheTemp(repid,ind)=$lb("R","查询"),ind=ind+1
	Set ^CacheTemp(repid,ind)=$lb("A","增加"),ind=ind+1
	Set ^CacheTemp(repid,ind)=$lb("U","更新"),ind=ind+1
	Set ^CacheTemp(repid,ind)=$lb("E","导出"),ind=ind+1
	Set ^CacheTemp(repid,ind)=$lb("I","导入"),ind=ind+1
	quit $$$OK
}

ClassMethod SaveLog(TableName, ClassName, ClassNameDesc, ObjectReference, ObjectDesc, OperateType, NewValue) As %String
{
	s result=""
	i TableName="" s result="-100^表名不能为空!"
	e  i ClassName="" s result="-100^类名不能为空!"
	e  i OperateType="" s result="-100^修改类型不能为空!"
	;e  i '$d(%session) s result="-100^获取不到session!"  //oa通过集成平台调用用户登录验证此时没有session 2018-1-30
	e  d
		if $d(%session),$d(%session.Data("LOGON.USERID")){ //oa通过集成平台调用用户登录验证此时没有session 2018-1-30
	    	Set userId = %session.Data("LOGON.USERID")
	    	Set uname = %session.Data("LOGON.USERNAME")
	    }else{
	    	Set userId=1
	    	Set uname="notsession"
	    }
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
		Set result = obj.%Id()
		Set obj=""
	q result
}

}
