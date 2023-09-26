/// 监控中心的接口
/// 创建者：李阳
/// 创建日期：2013-1-5
Class DHCMed.Base.INTService Extends %Persistent [ ClassType = "", Not ProcedureBlock ]
{

/// 查询综合检测结果汇总
/// 功能：分科室统计某个时间段触发的项目数量
/// 参数：
/// 	FromDate：触发的开始日期
/// 	ToDate：触发的结束日期
/// 	SubjectCode：监控主题代码
/// 	KeywordCode：关键字代码列表，用【^】分割
/// 	SubCateCode：监控主题子类代码，用【^】分割
/// 
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.Base.INTService","QryNumber","2013-4-1","2013-4-30","INFCC","","Bacteria")
Query QryNumber(FromDate As %String, ToDate As %String, SubjectCode As %String, KeywordCode As %String, SubCateCode As %String) As %Query(ROWSPEC = "Department:%String:科室,Number:%String:数量")
{
}

ClassMethod QryNumberExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, SubjectCode As %String, KeywordCode As %String, SubCateCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1 	
 	Quit:SubjectCode="" $$$OK
 	Quit:((FromDate="")!(ToDate="")) $$$OK
 	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
 	Quit:$IsObject(objSubject)=0 $$$OK
 	Set SubjectID=objSubject.%Id()
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3) 	

	For tmpDate=FromDate:1:ToDate {
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID))
			Quit:EpisodeID=""
			Set ResultID=""
			For {
				Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID,SubjectID,ResultID))
				Quit:ResultID=""
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				if ($d(^CacheTemp(repid,"Index","SubCatMap",objResult.ItemId))=0) {
					Set objItm=##class(DHCMed.CC.SubjectItm).GetObjById(+objResult.ItemId)
					Set objItmDic=##class(DHCMed.CC.ItemDic).GetObjById(objItm.ItemDic)
					Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(objItmDic.IDSubCatDr)
					Set ^CacheTemp(repid,"Index","SubCatMap",objResult.ItemId)=objSubCat.ISCCode
				}
				if ($d(^CacheTemp(repid,"Index","KeywordMap",objResult.KeyWord))=0) {
					Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(+objResult.KeyWord)
					Set:$IsObject(objKeyword)'=0 ^CacheTemp(repid,"Index","KeywordMap",objResult.KeyWord)=objKeyword.Code
				}				
				Set Code=$g(^CacheTemp(repid,"Index","SubCatMap",objResult.ItemId))
				Set ^CacheTemp(repid,"Index","SubCatCode",EpisodeID,Code)=1
				Set Code=$g(^CacheTemp(repid,"Index","KeywordMap",objResult.KeyWord))
				Set:Code="" Code="无"
				Set ^CacheTemp(repid,"Index","KeywordCode",EpisodeID,Code)=1
			}
		}
	}	
 	
 	Set IndexName=$s(KeywordCode="":"SubCatCode",1:"KeywordCode")
 	Set Code=$s(KeywordCode="":SubCateCode,1:KeywordCode)
 	Set EpisodeID=""
 	For {
 		Set EpisodeID=$o(^CacheTemp(repid,"Index",IndexName,EpisodeID))
 		Quit:EpisodeID=""
 		Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
 		For i=1:1:$l(Code,"^") {
 			Set tmpCode=$p(Code,"^",i)
 			Continue:tmpCode=""
 			Set:$d(^CacheTemp(repid,"Index",IndexName,EpisodeID,tmpCode))'=0 ^CacheTemp(repid,"Index","Dep",objAdm.DepartmentID)=$g(^CacheTemp(repid,"Index","Dep",objAdm.DepartmentID))+1
 		}
 	}
 	
 	Set DepID=""
 	For {
 		Set DepID=$o(^CacheTemp(repid,"Index","Dep",DepID))
 		Quit:DepID=""
 		Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(DepID)
 		Set data=$lb("")
 		Set $li(data,1)=objLoc.Descs
 		Set $li(data,2)=$g(^CacheTemp(repid,"Index","Dep",DepID))
 		Set ^CacheTemp(repid,"Index","Num",$li(data,2),data)=""
 		;Set ind=ind+1    ;wangcs 2013-04-17
 	}
 	Set Num=""
 	For {
	 	Set Num=$o(^CacheTemp(repid,"Index","Num",Num),-1)
	 	Quit:Num=""
	 	Set data=""
	 	For {
	 		Set data=$o(^CacheTemp(repid,"Index","Num",Num,data))
	 		Quit:data=""
	 		Quit:ind>5      ;wangcs 2013-04-17 最多显示5个科室
	 		Set ^CacheTemp(repid,ind)=data
	 		Set ind=ind+1
	 	}
	 	
 	} 	
 	Kill ^CacheTemp(repid,"Index")
	Quit $$$OK
}

ClassMethod QryNumberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryNumberExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryNumberExecute ]
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

/// 查询综合检测结果汇总
/// 功能：分科室统计某个时间段培养出细菌类别数量
/// 参数：
/// 	FromDate：触发的开始日期
/// 	ToDate：触发的结束日期
/// 	SubjectCode：监控主题代码
/// 	KeywordCode：关键字代码列表，用【^】分割
/// 	SubCateCode：监控主题子类代码，用【^】分割
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.Base.INTService","QryBugNumber","2013-4-1","2013-4-30","INFCC","","Bacteria")
Query QryBugNumber(FromDate As %String, ToDate As %String, SubjectCode As %String, KeywordCode As %String, SubCateCode As %String) As %Query(ROWSPEC = "Department:%String:科室,Number:%String:数量")
{
}

ClassMethod QryBugNumberExecute(ByRef qHandle As %Binary, FromDate As %String, ToDate As %String, SubjectCode As %String, KeywordCode As %String, SubCateCode As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1 	
 	Quit:SubjectCode="" $$$OK
 	Quit:((FromDate="")!(ToDate="")) $$$OK
 	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
 	Quit:$IsObject(objSubject)=0 $$$OK
 	Set SubjectID=objSubject.%Id()
	Set:FromDate["/" FromDate=$zdh(FromDate,4)
	Set:ToDate["/" ToDate=$zdh(ToDate,4)
	Set:FromDate["-" FromDate=$zdh(FromDate,3)
	Set:ToDate["-" ToDate=$zdh(ToDate,3) 	

	For tmpDate=FromDate:1:ToDate {
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID))
			Quit:EpisodeID=""
			Set ResultID=""
			For {
				Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID,SubjectID,ResultID))
				Quit:ResultID=""
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				if ($d(^CacheTemp(repid,"Index","SubCatMap",objResult.ItemId))=0) {
					Set objItm=##class(DHCMed.CC.SubjectItm).GetObjById(+objResult.ItemId)
					Set objItmDic=##class(DHCMed.CC.ItemDic).GetObjById(objItm.ItemDic)
					Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(objItmDic.IDSubCatDr)
					Set ^CacheTemp(repid,"Index","SubCatMap",objResult.ItemId)=objSubCat.ISCCode
				}
				if ($d(^CacheTemp(repid,"Index","KeywordMap",objResult.KeyWord))=0) {
					Set objKeyword=##class(DHCMed.CC.KeyWord).GetObjById(+objResult.KeyWord)
					Set:$IsObject(objKeyword)'=0 ^CacheTemp(repid,"Index","KeywordMap",objResult.KeyWord)=objKeyword.Code
				}		
				/**********wangcs 2013-04-18***********/		
				Set objOEItem=##class(DHCMed.Base.OrdItem).GetObjById(objResult.ObjectID)  
			 	Continue:'$IsObject(objOEItem)
			 	Set OEItemStatus=objOEItem.OSTATCode
				Set OSTATDesc=objOEItem.OSTATDesc
			 	Continue:(OSTATDesc'="执行")&&(OSTATDesc'="核实")
			 	Continue:(OEItemStatus="D")||(OEItemStatus="S")  //检查医嘱状态
				
			 	Set TestSetRow=objOEItem.OEORILabEpisodeNo
			 	/*******************End****************/
				Set Value=##class(DHCMed.CCService.Lib.CommonLis).GetBugList(TestSetRow)
				For i=1:1:$l(Value,$c(1)) {
					Set tmpBug=$p(Value,$c(1),i)
					Continue:tmpBug=""
					Set tmpBug=$p(tmpBug,"^",1)
					Set Code=$g(^CacheTemp(repid,"Index","SubCatMap",objResult.ItemId))
					Set ^CacheTemp(repid,"Index","SubCatCode",EpisodeID,Code,tmpBug)=""
					
					Set Code=$g(^CacheTemp(repid,"Index","KeywordMap",objResult.KeyWord))
					Set:Code="" Code="无"
					Set ^CacheTemp(repid,"Index","KeywordCode",EpisodeID,Code,tmpBug)=""				
				}
				

			}
		}
	}	
 	
 	Set IndexName=$s(KeywordCode="":"SubCatCode",1:"KeywordCode")
 	Set Code=$s(KeywordCode="":SubCateCode,1:KeywordCode)
 	Set EpisodeID=""
 	For {
 		Set EpisodeID=$o(^CacheTemp(repid,"Index",IndexName,EpisodeID))
 		Quit:EpisodeID=""
 		Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
 		For i=1:1:$l(Code,"^") {
 			Set tmpCode=$p(Code,"^",i)
 			Continue:tmpCode=""
 			Set bug=""
 			For {
 				Set bug=$o(^CacheTemp(repid,"Index",IndexName,EpisodeID,tmpCode,bug))
 				Quit:bug=""
 				Set ^CacheTemp(repid,"Index","Dep",objAdm.DepartmentID,bug)=""
 			}
 		}
 	}
 	
 	Set DepID=""
 	For {
 		Set DepID=$o(^CacheTemp(repid,"Index","Dep",DepID))
 		Quit:DepID=""
 		Set objLoc=##class(DHCMed.Base.Ctloc).GetObjById(DepID)
 		Set data=$lb("")
 		Set $li(data,1)=objLoc.Descs
 		Set $li(data,2)=0
 		Set bug=""
 		For {
 			Set bug=$o(^CacheTemp(repid,"Index","Dep",objAdm.DepartmentID,bug))
 			Quit:bug=""
 			Set $li(data,2)=$li(data,2)+1
 		}
 		Set ^CacheTemp(repid,"Index","Num",$li(data,2),data)=""
 		;Set ind=ind+1
 	}
 	Set Num=""
 	For {
	 	Set Num=$o(^CacheTemp(repid,"Index","Num",Num),-1)
	 	Quit:Num=""
	 	Set data=""
	 	For {
	 		Set data=$o(^CacheTemp(repid,"Index","Num",Num,data))
	 		Quit:data=""
	 		Quit:ind>5
	 		Set ^CacheTemp(repid,ind)=data
	 		Set ind=ind+1
	 	}
	 	
 	} 	
 	Kill ^CacheTemp(repid,"Index")
	Quit $$$OK
}

ClassMethod QryBugNumberClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBugNumberExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBugNumberFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBugNumberExecute ]
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

Storage Default
{
<Data name="INTServiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^DHCMed.Base.INTServiceD</DataLocation>
<DefaultData>INTServiceDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^DHCMed.Base.INTServiceD</IdLocation>
<IndexLocation>^DHCMed.Base.INTServiceI</IndexLocation>
<StreamLocation>^DHCMed.Base.INTServiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
