/// 自定义页签接口类
Class DHCMed.Base.CustomPageInterface Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 查询昨日的体温异常者数量
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.Base.CustomPageInterface","QryOutOfTemperature")
Query QryOutOfTemperature() As %Query(ROWSPEC = "Department:%String:科室,Number:%String:数量")
{
}

ClassMethod QryOutOfTemperatureExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid1=$I(^CacheTemp)
	Set qHandle=$lb(0,repid1,0)
 	Set ind1=1
 	
 	Kill ^TMP($zn,$j,"QryOutOfTemperature")
 	
 	Set QryName="DHCMed.Base.INTService:QryNumber"
 	Set FromDate=+$h-1
 	Set ToDate=+$h-1
 	Set SubjectCode="INFCC"
 	Set SubCateCode="OutOfTemperature"
 	Set objRs=##class(%Library.ResultSet).%New(QryName)
 	Set ret=objRs.Execute(FromDate,ToDate,SubjectCode,"",SubCateCode)
 	Set colCount=objRs.GetColumnCount()
 	While (objRs.Next())
 	{
		Set data=$lb("")
		Set $li(data,1)=objRs.GetData(1)
		Set $li(data,2)=objRs.GetData(2)
		Set:$li(data,1)="" $li(data,1)="不明"
		Set ^TMP($zn,$j,"QryOutOfTemperature",+$li(data,2),$li(data,1))=data
    }
    Do objRs.%Close()
    
    Set num="",Count=0
    For {
    	Set num=$o(^TMP($zn,$j,"QryOutOfTemperature",num),-1)
    	Quit:num=""
    	Quit:Count>5
    	
    	Set Dep=""
    	For {
	    	Set Dep=$o(^TMP($zn,$j,"QryOutOfTemperature",num,Dep))
	    	Quit:Dep=""
	    	
	    	Set Count=Count+1
	    	Set data=$g(^TMP($zn,$j,"QryOutOfTemperature",num,Dep))
	    	Set ^CacheTemp(repid1,ind1)=data
	    	Set ind1=ind1+1
	    }
    }
    Kill ^TMP($zn,$j,"QryOutOfTemperature")
    
	Quit $$$OK
}

ClassMethod QryOutOfTemperatureClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryOutOfTemperatureExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryOutOfTemperatureFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryOutOfTemperatureExecute ]
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

/// 查询昨日的使用呼吸机的患者数量
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.Base.CustomPageInterface","QryVentilator")
Query QryVentilator() As %Query(ROWSPEC = "Department:%String:科室,Number:%String:数量")
{
}

ClassMethod QryVentilatorExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid1=$I(^CacheTemp)
	Set qHandle=$lb(0,repid1,0)
 	Set ind1=1
 	
 	Kill ^TMP($zn,$j,"QryVentilator")
 	
 	Set QryName="DHCMed.Base.INTService:QryNumber"
 	Set FromDate=+$h-1
 	Set ToDate=+$h-1
 	Set SubjectCode="INFCC"
 	Set SubCateCode="Ventilator"
 	Set objRs=##class(%Library.ResultSet).%New(QryName)
 	Set ret=objRs.Execute(FromDate,ToDate,SubjectCode,"",SubCateCode)
 	Set colCount=objRs.GetColumnCount()
 	While (objRs.Next())
 	{
		Set data=$lb("")
		Set $li(data,1)=objRs.GetData(1)
		Set $li(data,2)=objRs.GetData(2)
		Set:$li(data,1)="" $li(data,1)="不明"
		Set ^TMP($zn,$j,"QryVentilator",+$li(data,2),$li(data,1))=data
    }
    Do objRs.%Close()
    
    Set num="",Count=0
    For {
    	Set num=$o(^TMP($zn,$j,"QryVentilator",num),-1)
    	Quit:num=""
    	Quit:Count>5
    	
    	Set Dep=""
    	For {
	    	Set Dep=$o(^TMP($zn,$j,"QryVentilator",num,Dep))
	    	Quit:Dep=""
	    	
	    	Set Count=Count+1
	    	Set data=$g(^TMP($zn,$j,"QryVentilator",num,Dep))
	    	Set ^CacheTemp(repid1,ind1)=data
	    	Set ind1=ind1+1
	    }
    }
    Kill ^TMP($zn,$j,"QryVentilator")
    
	Quit $$$OK
}

ClassMethod QryVentilatorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryVentilatorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryVentilatorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryVentilatorExecute ]
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

/// 查询昨日的检出微生物的患者数量
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.Base.CustomPageInterface","QryBacteria")
Query QryBacteria() As %Query(ROWSPEC = "Department:%String:科室,Number:%String:数量")
{
}

ClassMethod QryBacteriaExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid1=$I(^CacheTemp)
	Set qHandle=$lb(0,repid1,0)
 	Set ind1=1
 	
 	Kill ^TMP($zn,$j,"QryBacteria")
 	
 	Set QryName="DHCMed.Base.INTService:QryNumber"
 	Set FromDate=+$h-1
 	Set ToDate=+$h-1
 	Set SubjectCode="INFCC"
 	Set SubCateCode="Bacteria"
 	Set objRs=##class(%Library.ResultSet).%New(QryName)
 	Set ret=objRs.Execute(FromDate,ToDate,SubjectCode,"",SubCateCode)
 	Set colCount=objRs.GetColumnCount()
 	While (objRs.Next())
 	{
		Set data=$lb("")
		Set $li(data,1)=objRs.GetData(1)
		Set $li(data,2)=objRs.GetData(2)
		Set:$li(data,1)="" $li(data,1)="不明"
		Set ^TMP($zn,$j,"QryBacteria",+$li(data,2),$li(data,1))=data
    }
    Do objRs.%Close()
    
    Set num="",Count=0
    For {
    	Set num=$o(^TMP($zn,$j,"QryBacteria",num),-1)
    	Quit:num=""
    	Quit:Count>5
    	
    	Set Dep=""
    	For {
	    	Set Dep=$o(^TMP($zn,$j,"QryBacteria",num,Dep))
	    	Quit:Dep=""
	    	
	    	Set Count=Count+1
	    	Set data=$g(^TMP($zn,$j,"QryBacteria",num,Dep))
	    	Set ^CacheTemp(repid1,ind1)=data
	    	Set ind1=ind1+1
	    }
    }
    Kill ^TMP($zn,$j,"QryBacteria")
    
	Quit $$$OK
}

ClassMethod QryBacteriaClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryBacteriaExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryBacteriaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryBacteriaExecute ]
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

/// 查询昨日的检出微生物的种类数量
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.Base.CustomPageInterface","QryBugNumber")
Query QryBugNumber() As %Query(ROWSPEC = "Department:%String:科室,Number:%String:数量")
{
}

ClassMethod QryBugNumberExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid1=$I(^CacheTemp)
	Set qHandle=$lb(0,repid1,0)
 	Set ind1=1 		
 	
 	Kill ^TMP($zn,$j,"QryBugNumber")
 	
 	Set QryName="DHCMed.Base.INTService:QryBugNumber"
 	Set FromDate=+$h-1
 	Set ToDate=+$h-1
 	Set SubjectCode="INFCC"
 	Set SubCateCode="Bacteria"
 	Set objRs=##class(%Library.ResultSet).%New(QryName)
 	Set ret=objRs.Execute(FromDate,ToDate,SubjectCode,"",SubCateCode)
 	Set colCount=objRs.GetColumnCount()
 	While (objRs.Next())
 	{
		Set data=$lb("")
		Set $li(data,1)=objRs.GetData(1)
		Set $li(data,2)=objRs.GetData(2)
		Set:$li(data,1)="" $li(data,1)="不明"
		Set ^TMP($zn,$j,"QryBugNumber",+$li(data,2),$li(data,1))=data
    }
    Do objRs.%Close()
    
    Set num="",Count=0
    For {
    	Set num=$o(^TMP($zn,$j,"QryBugNumber",num),-1)
    	Quit:num=""
    	Quit:Count>5
    	
    	Set Dep=""
    	For {
	    	Set Dep=$o(^TMP($zn,$j,"QryBugNumber",num,Dep))
	    	Quit:Dep=""
	    	
	    	Set Count=Count+1
	    	Set data=$g(^TMP($zn,$j,"QryBugNumber",num,Dep))
	    	Set ^CacheTemp(repid1,ind1)=data
	    	Set ind1=ind1+1
	    }
    }
    Kill ^TMP($zn,$j,"QryBugNumber")
    
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

/// 查询昨日的检出三管患者的数量
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.Base.CustomPageInterface","QrySanGuan")
Query QrySanGuan() As %Query(ROWSPEC = "Department:%String:科室,Number:%String:数量")
{
}

ClassMethod QrySanGuanExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid1=$I(^CacheTemp)
	Set qHandle=$lb(0,repid1,0)
 	Set ind1=1
 	
 	Kill ^TMP($zn,$j,"QrySanGuan")
 	
 	Set QryName="DHCMed.Base.INTService:QryNumber"
 	Set SubjectCode="INFCC"
 	Set SubCateCode="Catheter^VenousCatheter" //在此维护好各种导管对应的【子类代码】
 	Set FromDate=+$h-1
 	Set ToDate=+$h-1
 	Set objRs=##class(%Library.ResultSet).%New(QryName)
 	Set ret=objRs.Execute(FromDate,ToDate,SubjectCode,"",SubCateCode)
 	Set colCount=objRs.GetColumnCount()
 	While (objRs.Next())
 	{
		Set data=$lb("")
		Set $li(data,1)=objRs.GetData(1)
		Set $li(data,2)=objRs.GetData(2)
		Set:$li(data,1)="" $li(data,1)="不明"
		Set ^TMP($zn,$j,"QrySanGuan",+$li(data,2),$li(data,1))=data
    }
    Do objRs.%Close()
    
    Set num="",Count=0
    For {
	    Set num=$o(^TMP($zn,$j,"QrySanGuan",num),-1)
	    Quit:num=""
	    Quit:Count>5
	    
	    Set Dep=""
	    For {
	    	Set Dep=$o(^TMP($zn,$j,"QrySanGuan",num,Dep))
	    	Quit:Dep=""
	    	
	    	Set Count=Count+1
	    	Set data=$g(^TMP($zn,$j,"QrySanGuan",num,Dep))
	    	Set ^CacheTemp(repid1,ind1)=data
	    	Set ind=ind1+1
	    }
	}
 	Kill ^TMP($zn,$j,"QrySanGuan")
 	
	Quit $$$OK
}

ClassMethod QrySanGuanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QrySanGuanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QrySanGuanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QrySanGuanExecute ]
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

/// 获取最近一周时间各科室的发热数量、培养出细菌的患者数量
/// do ##class(%Library.ResultSet).RunQuery("DHCMed.Base.CustomPageInterface","QryFeverAndBug")
Query QryFeverAndBug() As %Query(ROWSPEC = "Department:%String:科室,ActDate:%String:日期,FeverNumber:%String:发热数量,BugNumber:%String:培养出细菌人数")
{
}

ClassMethod QryFeverAndBugExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set qHandle=$lb(0,repid,0)
 	Set ind=1
 	
 	Set SubjectCode="INFCC"
 	Set objSubject=##class(DHCMed.CC.Subject).GetObjByCode(SubjectCode)
 	Quit:'$IsObject(objSubject) $$$OK
 	Set SubjectID=objSubject.%Id()
 	
 	Set FromDate=+$h-8
 	Set ToDate=+$h-1
 	Set FeverSubCateCode="OutOfTemperature" //发热子类的代码
 	Set BugSubCateCode="Bacteria" //检验出细菌的子类代码
 	
	Kill ^TMP($zn,$j,"QryFeverAndBug")
	
	For tmpDate=FromDate:1:ToDate {
		Set EpisodeID=""
		For {
			Set EpisodeID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID))
			Quit:EpisodeID=""
			
			Set objAdm=##class(DHCMed.Base.PatientAdm).GetObjById(EpisodeID)
			Continue:'$IsObject(objAdm)
			Set:objAdm.Department="" objAdm.Department="未知"
			Set DepDesc=objAdm.Department
			
			Set ResultID=""
			For {
				Set ResultID=$o(^DHCMed.CC.CtlResultI("Detail","IndexSubjectEpisodeActDate",tmpDate,EpisodeID,SubjectID,ResultID))
				Quit:ResultID=""
				
				Set objResult=##class(DHCMed.CC.CtlResult).GetObjById(ResultID)
				Continue:'$IsObject(objResult)
				Set RstItemId=objResult.ItemId
				Continue:RstItemId=""
				
				If '$d(^TMP($zn,$j,"QryFeverAndBug","SubCatMap",RstItemId)) {
					Set objItm=##class(DHCMed.CC.SubjectItm).GetObjById(RstItemId)
					Continue:'$IsObject(objItm)
					Set ItemDicID=objItm.ItemDic
					Continue:ItemDicID=""
					Set objItmDic=##class(DHCMed.CC.ItemDic).GetObjById(ItemDicID)
					Continue:'$IsObject(objItmDic)
					Set SubCatDr=objItmDic.IDSubCatDr
					Set objSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(SubCatDr)
					Continue:'$IsObject(objSubCat)
					Set ^TMP($zn,$j,"QryFeverAndBug","SubCatMap",RstItemId)=objSubCat.ISCCode
				}
				
				Set ^TMP($zn,$j,"QryFeverAndBug","Dep",DepDesc)=""
				Set Code=$g(^TMP($zn,$j,"QryFeverAndBug","SubCatMap",RstItemId))
				Set tmp=$g(^TMP($zn,$j,"QryFeverAndBug","Data",tmpDate,DepDesc))
				Set:Code=FeverSubCateCode $p(tmp,"^",1)=$p(tmp,"^",1)+1
				Set:Code=BugSubCateCode $p(tmp,"^",2)=$p(tmp,"^",2)+1
				Set ^TMP($zn,$j,"QryFeverAndBug","Data",tmpDate,DepDesc)=tmp
			}
		}
	}
 	
 	For FromDate=FromDate:1:ToDate {
 		Set DepName=""
 		For {
 			Set DepName=$o(^TMP($zn,$j,"QryFeverAndBug","Dep",DepName))
 			Quit:DepName=""
 			
 			Set tmp=$g(^TMP($zn,$j,"QryFeverAndBug","Data",tmpDate,DepName))
 			
 			Set data=$lb("")
 			Set $li(data,1)=DepName
 			Set $li(data,2)=$zd(tmpDate,3)
 			Set $li(data,3)=$p(tmp,"^",1)
 			Set $li(data,4)=$p(tmp,"^",2)
 			Set ^CacheTemp(repid,ind)=data
 			Set ind=ind+1
 		}
 	}
 	Kill ^TMP($zn,$j,"QryFeverAndBug")
 	
	Quit $$$OK
}

ClassMethod QryFeverAndBugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryFeverAndBugExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryFeverAndBugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryFeverAndBugExecute ]
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
