/// 创建者：李阳
/// 传染病监控
/// 创建日期：2011-06-25
/// 
Class DHCMed.EPDService.Controlsrv Extends DHCMed.Abstract [ Not ProcedureBlock ]
{

/// Creator：     LiYang
/// CreatDate：   2011-06-25
/// Description:  查询监控主题及其下属项目      
/// Return：      tree需要的ResultSet
/// do ##class(%ResultSet).RunQuery("DHCMed.EPDService.Controlsrv","QueryAllForTree",1)
Query QueryAllForTree(Arg As %String = "") As %Query(ROWSPEC = "id:%String,text:%String,leaf:%String,checked:%String")
{
}

ClassMethod QueryAllForTreeExecute(ByRef qHandle As %Binary, Arg As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set type=$p(Arg,"-",1)
	If (type="Subject"){
		Set SubjectID=$p(Arg,"-",2)
		Set ID=""
		For {
			Set ID=$o(^DHCMed.CCi("ItemCat",0,"SubjectIndex",SubjectID,ID))
			Quit:ID=""
			Set objItmCat=##class(DHCMed.CC.ItemCat).GetObjById(ID)
			Set data=$lb("")
			Set $li(data,1)="ItemCat-"_objItmCat.%Id()
			Set $li(data,2)=objItmCat.ICDesc
			Set $li(data,3)=0
			Set $li(data,4)="true"
			Set ^CacheTemp(repid,ind)=data
			Set ind=ind+1
		}
	}
	If (type="ItemCat"){
		Set ItemCat=$p(Arg,"-",2)
		Set Code=""
		For {
			Set Code=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",ItemCat,Code))
			Quit:Code=""
			Set ID=""
			For {
				Set ID=$o(^DHCMed.CCi("ISubCat",0,"ISCCodeIndex",ItemCat,Code,ID))
				Quit:ID=""
				Set objItmSubCat=##class(DHCMed.CC.ItemSubCat).GetObjById(ID)
				Set data=$lb("")
				Set $li(data,1)="ItemSubCat-"_objItmSubCat.%Id()
				Set $li(data,2)=objItmSubCat.ISCDesc
				Set $li(data,3)=0
				Set $li(data,4)="true"
				Set ^CacheTemp(repid,ind)=data
				Set ind=ind+1				
			}
		}				
	}
	If (type="ItemSubCat"){
		Set ItemSubCat=$p(Arg,"-",2)
		Set ID=""
		For {
			Set ID=$o(^DHCMed.CCi("ItemDic",0,"IDSubCatDrIndex",ItemSubCat,ID))
			Quit:ID=""
			Set objItm=##class(DHCMed.CC.ItemDic).GetObjById(ID)
			Set data=$lb("")
			Set $li(data,1)="ItemDic-"_objItm.%Id()
			Set $li(data,2)=objItm.IDDesc
			Set $li(data,3)=1
			Set $li(data,4)="true"
			Set ^CacheTemp(repid,ind)=data
			Set ind=ind+1				
		}		
	}	
	Quit $$$OK
}

ClassMethod QueryAllForTreeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryAllForTreeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryAllForTreeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryAllForTreeExecute ]
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
