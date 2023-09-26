/// 名称: DHCMed.INFService.InfAntiDicSrv
/// 描述: DHCMed.INF.InfDiagnose抗菌素字典的常用操作
/// 编写者：ChenJB
/// 编写日期: 2010-05-17
Class DHCMed.INFService.InfAntiDicSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  查询抗生素的信息
/// Table：       DHCMed.INF.InfAntiDic
/// Input：       Alias ： 别名
/// output:       符合条件的项            
/// Return： 1: Rowid 2: Code 3: Description 4: Active 5: ResumeText  
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfDiagnoseSrv","QryInfDiaByAlias","")
Query QryInfAntiByAlias(Alias As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Description:%String,Active:%String,ResumeText:%String")
{
}

ClassMethod QryInfAntiByAliasExecute(ByRef qHandle As %Binary, Alias As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	s ind=1
 	//^DHCMed.INF.InfPathogenDicD
 	//^DHCMed.INF.InfPathogenDicI("Code",{Code},{RowID})
 	//1:Rowid 2: ICD 3:DiseaseName 4:Type 5:Active 6:Alias 7:ResumeText
 	s Alias=$$ALPHAUP^SSUTIL4(Alias)
 	if (Alias="")
 	{
	 	s myid=$o(^DHCMed.INF.InfAntiDicD(""))
 	    while (myid'="")
 	    {
	     s myInfDia=##class(DHCMed.INF.InfAntiDic).%OpenId(myid)
	     if ($IsObject(myInfDia))
	     {        
 	        q:'$IsObject(myInfDia)
 	        s Code=myInfDia.Code
 	        s Description=myInfDia.Description
 	        s Active=myInfDia.Active
 	        s ResumeText=myInfDia.ResumeText
 	        s Data=$lb(myid,Code, Description, Active, ResumeText)
 	        s ^CacheTemp(repid,ind)=Data
 	        s ind=ind+1
		  } 	
	      s myid=$o(^DHCMed.INF.InfAntiDicD(myid))
	 	}
	}
 	else
 	{
 	s idxAlias=" "_Alias
 	i $d(^DHCMed.INF.InfAntiDicI("Code",idxAlias)) d
 	.s tmpRowid=""
 	.f  s tmpRowid=$o(^DHCMed.INF.InfAntiDicI("Code",idxAlias,tmpRowid)) q:(+tmpRowid=0)  d
 	..s myInfDia=##class(DHCMed.INF.InfAntiDic).%OpenId(tmpRowid)
 	..q:'$IsObject(myInfDia)
 	..s Code=myInfDia.Code
 	..s Description=myInfDia.Description
 	..s Active=myInfDia.Active
 	..s ResumeText=myInfDia.ResumeText
 	..s Data=$lb(tmpRowid, Code, Description, Active, ResumeText)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	f  s idxAlias=$o(^DHCMed.INF.InfAntiDicI("Code",idxAlias)) q:idxAlias'[Alias  d
 	.s tmpRowid=""
 	.f  s tmpRowid=$o(^DHCMed.INF.InfAntiDicI("Code",idxAlias,tmpRowid)) q:(+tmpRowid=0)  d
 	..s myInfDia=##class(DHCMed.INF.InfAntiDic).%OpenId(tmpRowid)
 	..q:'$IsObject(myInfDia)
 	..s Code=myInfDia.Code
 	..s Description=myInfDia.Description
 	..s Active=myInfDia.Active
 	..s ResumeText=myInfDia.ResumeText
 	..s Data=$lb(tmpRowid, Code, Description, Active, ResumeText)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	}
 	
	Quit $$$OK
}

ClassMethod QryInfAntiByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfAntiByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	;Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfAntiByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfAntiByAliasExecute ]
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
