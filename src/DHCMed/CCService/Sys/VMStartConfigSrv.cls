/// <H3>启动设置</H3>
/// <H4>创建者：李阳</H4>
/// <H4>创建日期：2012-08-04</H4>
Class DHCMed.CCService.Sys.VMStartConfigSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     liuyh
/// CreatDate：   2010-09-26
/// Description:  查询监控启动配置页面信息 改于2012-07-30
/// Table：       DHCMed.CC.SubVMStartConfig
/// Input：SubjectID       
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.CCService.Sys.VMStartConfigSrv","QryBySubject","2","")
Query QryBySubject(SubjectID As %String, RunType As %String) As %Query(ROWSPEC = "rowid:%String,SubjectID:%Integer,Code:%String,Description:%String,RunType:%String,IsActive:%String,StartIndex:%String,Expression:%String,ResumeText:%String,VarName:%String")
{
}

ClassMethod QryBySubjectExecute(ByRef qHandle As %Binary, SubjectID As %String, RunType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1	
	Set qHandle=$lb(0,repid,0)
	
	Quit:SubjectID="" $$$OK
	
	Set tmpRunType=""
	For { 
		Set tmpRunType=$o(^DHCMed.CCi("StartConfig","IndexSubjectActiveStartIndex",SubjectID,tmpRunType))
		Quit:tmpRunType=""
		Continue:(($Extract(tmpRunType,2,$l(tmpRunType))'=RunType)&&(RunType'=""))
		Set StartIndex=0
		For {
			set StartIndex=$o(^DHCMed.CCi("StartConfig","IndexSubjectActiveStartIndex",SubjectID,tmpRunType,1,StartIndex))
			quit:StartIndex=""
			Set RowID=""
			For {
				set RowID=$o(^DHCMed.CCi("StartConfig","IndexSubjectActiveStartIndex",SubjectID,tmpRunType,1,StartIndex,RowID))
				quit:RowID="" ///通过SubjectID，RunType找到StartIndex从而找到rowid
				set obj=##class(DHCMed.CC.SubjectVMStartConfig).%OpenId(RowID)  
				quit:'$IsObject(obj)
				do obj.%Close()	
				///查询rowid获取的对应的启动配置页面信息
				set $li(data,1)=RowID //
				set $li(data,2)=obj.SubjectID //SubjectID
				set $li(data,3)=obj.Code //Code
				set $li(data,4)=obj.Description //Description
				set $li(data,5)=obj.RunType  //RunType
				set $li(data,6)=obj.IsActive //IsActive
				set $li(data,7)=obj.StartIndex //StartIndex
				set $li(data,8)=obj.Expression //Expression
				set $li(data,9)=obj.ResumeText //ResumeText
				set $li(data,10)=obj.VarName //VarName
				set ^CacheTemp(repid,ind)=data
				Set ind=ind+1
			}
		}
	}
	Quit $$$OK
}

ClassMethod QryBySubjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBySubjectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBySubjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBySubjectExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     likai
/// CreatDate：   2012-07-05
/// Description:  查询类别信息
/// Table：       DHCMed.CC.SubVMStartConfig
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubVMStartConfigSrv","QryStartConfig")
Query QryStartConfig() As %Query(ROWSPEC = "rowid:%String,Code:%String,Description:%String,VarName:%String,IsActive:%String,Expression:%String,RunType:%String,StartIndex:%String")
{
}

ClassMethod QryStartConfigExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	s rowid=""
	For {
		set rowid=$o(^DHCMed.CCi("StartConfig",rowid)) 
		Quit:rowid=""  d
		set obj=##class(DHCMed.CC.SubjectVMStartConfig).%OpenId(rowid)  ///取出
		Continue:'$IsObject(obj)
		set $li(data,1)=rowid
		set $li(data,2)=obj.Code
		set $li(data,3)=obj.Description
		set $li(data,4)=obj.VarName 
		set $li(data,5)=$s(obj.IsActive=1:"是",1:"否")
		set $li(data,6)=obj.Expression
		set $li(data,7)=obj.RunType
		set $li(data,8)=obj.StartIndex
		If $IsObject(obj){
		set ^CacheTemp(repid,ind)=data
    	Set ind=ind+1
		}
	}
	
	Quit $$$OK
}

ClassMethod QryStartConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryStartConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryStartConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryStartConfigExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Creator：     likai
/// CreatDate：   2012-07-05
/// Description:  查询监控主题类别信息改于2012-07-31
/// Table：       DHCMed.CC.Subject
/// Input：       
/// d ##class(%ResultSet).RunQuery("DHCMed.CCService.SubVMStartConfigSrv","QuerySubjectCatInfo")
Query QuerySubjectCatInfo() As %Query(ROWSPEC = "rowid:%String,Title:%String,Code:%String,Desc:%String,IsActive:%String,IsActiveDesc:%String,ResumeText:%String")
{
}

ClassMethod QuerySubjectCatInfoExecute(ByRef qHandle As %Binary) As %Status
{
	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0) 
	set rowid=""
	for {
		set rowid=$o(^DHCMed.CC.SubjectD(rowid))
		quit:rowid=""  
		set obj=##class(DHCMed.CC.Subject).%OpenId(rowid)
		quit:'$IsObject(obj)
		set $li(data,1)=rowid
		set $li(data,2)=obj.Title
		set $li(data,3)=obj.Code
		set $li(data,4)=obj.Description
		set $li(data,5)=obj.IsActive
		set $li(data,6)="否"
		set:obj.IsActive=1 $li(data,6)="是"
		set $li(data,7)=obj.ResumeText
 		set ^CacheTemp(repid,ind)=data
 		set ind=ind+1
	}
	q $$$OK
}

ClassMethod QuerySubjectCatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySubjectCatInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QuerySubjectCatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySubjectCatInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
