/// 名称: DHCMed.INFService.InfPathogenDicSrv
/// 描述: DHCMed.INF.InfPathogenDic 病原体字典的常用操作
/// 编写者：ChenJB
/// 编写日期: 2010-05-18
Class DHCMed.INFService.InfPathogenDicSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：     ChenJB
/// CreatDate：   2010-05-11
/// Description:  查询病原体的信息
/// Table：       DHCMed.INF.InfPathogenDic
/// Input：       Alias ： 别名
/// output:       符合条件的项            
/// Return： 1: Rowid 2: Code 3: Description 4: Active 5: ResumeText  
/// D ##class(%ResultSet).RunQuery("DHCMed.INFService.InfDiagnoseSrv","QryInfDiaByAlias","")
Query QryInfPatByAlias(Alias As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Description:%String,Active:%String,ResumeText:%String")
{
}

ClassMethod QryInfPatByAliasExecute(ByRef qHandle As %Binary, Alias As %String = "") As %Status
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
	 	s myid=$o(^DHCMed.INF.InfPathogenDicD(""))
 	    while (myid'="")
 	    {
	     s myInfDia=##class(DHCMed.INF.InfPathogenDic).%OpenId(myid)
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
	      s myid=$o(^DHCMed.INF.InfPathogenDicD(myid))
	 	}
	}
 	else
 	{
 	s idxAlias=" "_Alias
 	i $d(^DHCMed.INF.InfPathogenDicI("Code",idxAlias)) d
 	.s tmpRowid=""
 	.f  s tmpRowid=$o(^DHCMed.INF.InfPathogenDicI("Code",idxAlias,tmpRowid)) q:(+tmpRowid=0)  d
 	..s myInfDia=##class(DHCMed.INF.InfPathogenDic).%OpenId(tmpRowid)
 	..q:'$IsObject(myInfDia)
 	..s Code=myInfDia.Code
 	..s Description=myInfDia.Description
 	..s Active=myInfDia.Active
 	..s ResumeText=myInfDia.ResumeText
 	..s Data=$lb(tmpRowid, Code, Description, Active, ResumeText)
 	..s ^CacheTemp(repid,ind)=Data
 	..s ind=ind+1
 	f  s idxAlias=$o(^DHCMed.INF.InfPathogenDicI("Code",idxAlias)) q:idxAlias'[Alias  d
 	.s tmpRowid=""
 	.f  s tmpRowid=$o(^DHCMed.INF.InfPathogenDicI("Code",idxAlias,tmpRowid)) q:(+tmpRowid=0)  d
 	..s myInfDia=##class(DHCMed.INF.InfPathogenDic).%OpenId(tmpRowid)
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

ClassMethod QryInfPatByAliasClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryInfPatByAliasExecute ]
{
	Set repid=$LIST(qHandle,2)
 	;Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryInfPatByAliasFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryInfPatByAliasExecute ]
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

/// Creator：     ChenJB
/// CreatDate：   2010-06-12
/// Description:  更新感染报告 辅助检查 病原体及抗菌药物
/// Table：       DHCMed.INF.PyObj
/// Input：       各属性列表 ^分隔
/// Return：      成功：返回id，失败：返回<0的代码
/// 1: Rowid 2: InfPathDr 3: Object 4: Flag
ClassMethod UpdateGermAnti(InStr As %String, InfPathDr As %String) As %String
{
 
	new (InStr,InfPathDr)
	set id=0
	//set ID=$p(InStr,InfPathDr,1)
	f i=1:1:$l(InStr,$c(3)) d
	.s StrGermAnti=$p(InStr,$c(3),i)
	.s StrGerm=$p(StrGermAnti,$c(2),1)
	.s StrAnti=$p(StrGermAnti,$c(2),2)
	.s StrGFlag=$p(StrGermAnti,$c(2),3)
	.s GermID=$p(StrGerm,"^",1)
	.s GFlagCode=$p(StrGFlag,"^",1)
	.s PyID=$o(^DHCMed.INF.PyObjI("PathDrObjIdx",InfPathDr,GermID,""))
	.i +PyID=0 d
	..//添加数据
	..s PyID=##class(DHCMed.INF.PyObj).Update("^"_InfPathDr_"^"_GermID_"^"_GFlagCode_"^^","^")
	.e  d
	..s PyID=##class(DHCMed.INF.PyObj).Update(PyID_"^"_InfPathDr_"^"_GermID_"^"_GFlagCode_"^^","^")
	.q:+PyID<1
	.q:StrAnti=""
	.f j=1:1:$l(StrAnti,$c(1)) d
	..s StrAntis=$p(StrAnti,$c(1),j)
	..s AntiID=$p(StrAntis,"^",1)
	..s AFlagCode=$p(StrAntis,"^",3)
	..s PyObjAntiID=$o(^DHCMed.INF.PyObjDrugI("PathDrDrugIdx",PyID,AntiID,""))
	..i +PyObjAntiID=0 d
	...s PyObjAntiID=##class(DHCMed.INF.PyObjDrug).Update("^"_PyID_"^"_AntiID_"^"_AFlagCode_"^^","^")
	..e  d
	...s PyObjAntiID=##class(DHCMed.INF.PyObjDrug).Update(PyObjAntiID_"^"_PyID_"^"_AntiID_"^"_AFlagCode_"^^","^")
	s id=1
	q id
}

}
