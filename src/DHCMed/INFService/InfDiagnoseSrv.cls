/// 名称: DHCMed.INFService.InfDiagnose
/// 描述: DHCMed.INF.InfDiagnose疾病的常用操作
/// 编写者：ChenJB
/// 编写日期: 2010-05-11
Class DHCMed.INFService.InfDiagnoseSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  查询疾病的信息
/// Table：       DHCMed.INF.InfDiagnose
/// Input：       Alias ： 别名
/// output:       符合条件的项            
/// Return：      
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfDiagnoseSrv","QryInfDiaByAlias","")
Query QryInfDiaByAlias(Alias As %String = "") As %Query(ROWSPEC = "Rowid:%String,ICD:%String,DiseaseName:%String,Type:%String,Active:%String,Alias:%String,ResumeText:%String")
{
}

ClassMethod QryInfDiaByAliasExecute(ByRef qHandle As %Binary, Alias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//^DHCMed.INF.InfDiagnoseD
 	//^DHCMed.INF.InfDiagnoseI("Alias",{Alias},{RowID})
 	//1:Rowid 2: ICD 3:DiseaseName 4:Type 5:Active 6:Alias 7:ResumeText
 	s Alias=$$ALPHAUP^SSUTIL4(Alias)
 	if (Alias="")
 	{
	 	s myid=$o(^DHCMed.INF.InfDiagnoseD(""))
 	    while (myid'="")
 	    {
	     s myInfDia=##class(DHCMed.INF.InfDiagnose).%OpenId(myid)
	     if ($IsObject(myInfDia))
	     {        
 	        q:'$IsObject(myInfDia)
 	        s ICD=myInfDia.ICD
 	        s DiseaseName=myInfDia.DiseaseName
 	        s Type=myInfDia.Type
 	        s Active=myInfDia.Active
 	        s Alias=myInfDia.Alias
 	        s ResumeText=myInfDia.ResumeText
 	        s Data=$lb(myid,ICD,DiseaseName,Type,Active,Alias,ResumeText)
 	        s ^CacheTemp(repid,ind)=Data
 	        s ind=ind+1
		  } 	
	      s myid=$o(^DHCMed.INF.InfDiagnoseD(myid))
	 	}
	}
 	else
 	{
 	s idxAlias=" "_Alias
 	i $d(^DHCMed.INF.InfDiagnoseI("Alias",idxAlias)) d
 	.s tmpRowid=""
 	.f  s tmpRowid=$o(^DHCMed.INF.InfDiagnoseI("Alias",idxAlias,tmpRowid)) q:(+tmpRowid=0)  d
 	..s myInfDia=##class(DHCMed.INF.InfDiagnose).%OpenId(tmpRowid)
 	..q:'$IsObject(myInfDia)
 	..s ICD=myInfDia.ICD
 	..s DiseaseName=myInfDia.DiseaseName
 	..s Type=myInfDia.Type
 	..s Active=myInfDia.Active
 	..s Alias=myInfDia.Alias
 	..s ResumeText=myInfDia.ResumeText
 	..s Data=$lb(tmpRowid,ICD,DiseaseName,Type,Active,Alias,ResumeText)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	f  s idxAlias=$o(^DHCMed.INF.InfDiagnoseI("Alias",idxAlias)) q:idxAlias'[Alias  d
 	.s tmpRowid=""
 	.f  s tmpRowid=$o(^DHCMed.INF.InfDiagnoseI("Alias",idxAlias,tmpRowid)) q:(+tmpRowid=0)  d
 	..s myInfDia=##class(DHCMed.INF.InfDiagnose).%OpenId(tmpRowid)
 	..q:'$IsObject(myInfDia)
 	..s ICD=myInfDia.ICD
 	..s DiseaseName=myInfDia.DiseaseName
 	..s Type=myInfDia.Type
 	..s Active=myInfDia.Active
 	..s ResumeText=myInfDia.ResumeText
 	..s Data=$lb(tmpRowid,ICD,DiseaseName,Type,Active,ResumeText)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	}
 	
	Quit $$$OK
}

ClassMethod QryInfDiaByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfDiaByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfDiaByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfDiaByAliasExecute ]
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
