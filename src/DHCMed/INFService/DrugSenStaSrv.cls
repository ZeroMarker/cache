/// 作者：李阳
/// 创建日期：2011-08-15
/// 抗菌素敏感情况查询
Class DHCMed.INFService.DrugSenStaSrv Extends DHCMed.Abstract [ ClassType = "", Not ProcedureBlock ]
{

/// 查询细菌
/// d ##class(%Library.ResultSet).RunQuery("DHCMed.INFService.DrugSenStaSrv","QueryBug","","")
Query QueryBug(Alias As %String, IsActive As %String) As %Query(ROWSPEC = "Code:%String:代码,BugName:%String:细菌名称")
{
}

ClassMethod QueryBugExecute(ByRef qHandle As %Binary, Alias As %String, IsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)  
	Set BugsCode=""
	For {
		Set BugsCode=$o(^TTAB("BUG",BugsCode))	
		Quit:BugsCode=""
		Set DrugInfo=$g(^TTAB("BUG",BugsCode))
		Continue:DrugInfo=""
		Set BugsDesc=$Piece(DrugInfo,"\",1)
		Continue:((Alias'="")&((BugsDesc'[Alias)&(BugsCode'[Alias)))
		Set BugsActive=$Piece(DrugInfo,"\",11)
		Continue:(IsActive'="")&(IsActive'=BugsActive)
		Continue:(BugsCode="")!(BugsDesc="")
		Set data=$lb("")
		Set $li(data,1)=BugsCode
		Set $li(data,2)=BugsDesc
		Set ^CacheTemp(repid,ind)=data
		Set ind=ind+1
	}
	
	Quit $$$OK
}

ClassMethod QueryBugClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBugExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryBugFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBugExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// d ##class(%Library.ResultSet).RunQuery("DHCMed.INFService.DrugSenStaSrv","QryAntibioticsDic","","美","Y")
Query QryAntibioticsDic(Code As %String, Alias As %String, IsActive As %String) As %Query(ROWSPEC = "Code:%String,Desc:%String")
{
}

ClassMethod QryAntibioticsDicExecute(ByRef qHandle As %Binary, Code As %String, Alias As %String, IsActive As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
 	Set IsActive=$Select(IsActive["Y":"Y",IsActive["N":"N",1:"")
	Set Config=##Class(websys.Configuration).%OpenId(1)
	Set LABDATA=Config.LabDataNamespace
	Set AntID="",AntCodeList=""
	For {
		Set AntID=$o(^TTAB("ANT",AntID))
		Quit:AntID=""
		
		Set AntActive=$p($g(^TTAB("ANT",AntID)),"\",4)
		Continue:(IsActive'="")&&(IsActive'=AntActive)
		Set AntDesc=$p($g(^TTAB("ANT",AntID)),"\",1)
		Set AntCode=$p($g(^[LABDATA]DHCANTIBIOTICS(AntID)),"\",3)
		//Set:AntCode="" AntCode=AntID
		Continue:AntCode=""
		Continue:((Alias'="")&&(AntDesc'[Alias)&&(AntCode'[Alias))
		Continue:(Code'="")&&(AntCode'=Code)
		Continue:$listfind(AntCodeList,AntCode)>0
		Set AntCodeList=AntCodeList_$lb(AntCode)
		
		Set Data=$lb(AntCode,AntDesc)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Quit $$$OK
}

ClassMethod QryAntibioticsDicClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAntibioticsDicExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryAntibioticsDicFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAntibioticsDicExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

/// d ##Class(%ResultSet).RunQuery("DHCMed.INFService.DrugSenStaSrv","QryDrugSenExp")
Query QryDrugSenExp() As %Query(ROWSPEC = "ItemID:%String,ItemDesc:%String,ItemExpress:%String")
{
}

ClassMethod QryDrugSenExpExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
	Set ind=1
	Set qHandle=$lb(0,repid,0)
	
	Set ItemID=0
	For {
		Set ItemID=$o(^DHCMed.INF.DrugSenExp(ItemID))
		Quit:ItemID=""
		Set objItem=$g(^DHCMed.INF.DrugSenExp(ItemID))
		Set ItemDesc=$list(objItem,1)
		Set ItemExpress=$list(objItem,2)
		Set ItemExpress1=""
		For index=1:1:$l(ItemExpress,"\") {
			Set ItemExpress1=ItemExpress1_"\\"_$p(ItemExpress,"\",index)
		}
		Set:ItemExpress1'="" ItemExpress1=$e(ItemExpress1,3,$l(ItemExpress1))
		Set ItemExpress=ItemExpress1
		
		Set Data=$lb(ItemID,ItemDesc,ItemExpress)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
		
	Quit $$$OK
}

ClassMethod QryDrugSenExpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryDrugSenExpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QryDrugSenExpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryDrugSenExpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	
	Quit $$$OK
}

ClassMethod SaveDrugSenExp(argInput As %String, argSeparete As %String) As %String
{
	New (argInput,argSeparete)
	Set return=-1
	
	Set:argSeparete="" argSeparete="^"
	Set ItemDesc=$p(argInput,argSeparete,1)
	Set ItemExpress=$p(argInput,argSeparete,2)
	Quit:(ItemDesc="")||(ItemExpress="") return
	
	Set num=$i(^DHCMed.INF.DrugSenExp)
	Set ^DHCMed.INF.DrugSenExp(num)=$lb(ItemDesc,ItemExpress)
	Set return=num
	
	Quit return
}

ClassMethod DelDrugSenExp(argID As %String) As %String
{
	New (argID)
	Set return=0
	Quit:'$d(^DHCMed.INF.DrugSenExp(argID)) return
	Kill ^DHCMed.INF.DrugSenExp(argID)
	Set return=1
	Quit return
}

/// w ##Class(DHCMed.INFService.DrugSenStaSrv).Translate()
ClassMethod Translate(string As %String, identifier As %String, associator As %String) As %String
{
	New (string,identifier,associator)
	Set return=""
	Quit:(string="")||(identifier="")||(associator="") return
	
	For Ind=1:1:$l(string,identifier)
	{
		Set tmp=$p(string,identifier,Ind)
		If return="" {
			Set return=tmp
		}Else{
			Set return=return_associator_tmp
		}
	}
	
	Quit return
}

}
