Import SQLUser

Class web.DHCMedClinicalReport.ProjectCtl Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 1;

ClassMethod QryProjectClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryProjectExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod QryProjectExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	Set qHandle=$lb(0,repid,0)
	s Rowid=0
	f  s Rowid=$o(^DHCMClin.ProjectD(Rowid)) q:Rowid=""  d
	.//w Rowid,!
	.s s=##class(User.DHCMedClinicalReport.Project).GetById(Rowid)
    .d BuildData
	Quit $$$OK
BuildData
	//set Data=$lb(id,code,desc,InsDesc,ICD9CM_Code)
	set Data=$lb("")
 	f iBuild=1:1:6 d
 	.s $li(Data,iBuild)=$p(s,"^",iBuild)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QryProjectFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryProjectExecute ]
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

/// 根据别名查询HIS诊断字典
/// d ##Class(%ResultSet).RunQuery("web.DHCMedInjuryRep","QryInjDiagByAlias","11")
Query QryProject() As %Query(ROWSPEC = "Rowid:%String,Code:%String,Description:%String,TemplateID:%String,Active:%String,Resume:%String")
{
}

}
