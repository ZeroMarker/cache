Import SQLUser

Class web.DHCCTLocMedUnit Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 23;

ClassMethod QueryMedUnit1Close(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryMedUnit1Execute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

/// W ##class(%ResultSet).RunQuery("web.DHCCTLocMedUnit","QueryMedUnit1","14")
ClassMethod QueryMedUnit1Execute(ByRef qHandle As %Binary, CTLocDr As %String = "", Code As %String = "", Desc As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1   
 	i CTLocDr="" d                                                         
	.s CTLocDr="0"
	.f  s CTLocDr=$o(^CTLOC(CTLocDr)) q:CTLocDr=""  d
	..s CTChildsub=0
	..s TCTLocDr=CTLocDr                                                     
	..s TCTCode=$p(^CTLOC(CTLocDr),"^",1)                                   
	..f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub))  q:CTChildsub=""  d  
	...s MURowid=CTLocDr_"||"_CTChildsub
	...s CTMUCode=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",1)
	...q:(Code'="")&&(CTMUCode'[Code)                   
	...s CTMUDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2)  
	...q:(Desc'="")&&(CTMUDesc'[Desc)                 
	...s tmpCTMUActiveFlag=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",3)
	...s:tmpCTMUActiveFlag="Y" CTMUActiveFlag="激活"
	...s:(tmpCTMUActiveFlag'="Y") CTMUActiveFlag="未激活"
	...S TActiveFlag=tmpCTMUActiveFlag
	...s DateFrom=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",4)
	...s:(DateFrom'="") DateFrom=$zd(DateFrom,4)                          
	...s DateTo=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",5)
	...s:(DateTo'="") DateTo=$zd(DateTo,4)

	...d BuildCont1
	e  d
	.q:($d(^CTLOC(CTLocDr))=0)      
	.s CTChildsub=0
	.s TCTLocDr=CTLocDr                                                     
	.s TCTCode=$p(^CTLOC(CTLocDr),"^",1)                                    
	.f  s CTChildsub=$o(^CTLOC(CTLocDr,"MU",CTChildsub))  q:CTChildsub=""  d
	..s MURowid=CTLocDr_"||"_CTChildsub
	..s CTMUCode=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",1)
	..q:(Code'="")&&(CTMUCode'[Code) 
	..s CTMUDesc=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",2)
	..q:(Desc'="")&&(CTMUDesc'[Desc)  
	..s tmpCTMUActiveFlag=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",3)
	..s:tmpCTMUActiveFlag="Y" CTMUActiveFlag="激活"
	..s:(tmpCTMUActiveFlag'="Y") CTMUActiveFlag="未激活"
	..S TActiveFlag=tmpCTMUActiveFlag
	..s DateFrom=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",4)
	..//s DateFrom=$zd(DateFrom,3)
	..s:(DateFrom'="") DateFrom=$zd(DateFrom,4)
	..s DateTo=$p(^CTLOC(CTLocDr,"MU",CTChildsub),"^",5)
	..s:(DateTo'="") DateTo=$zd(DateTo,4)

	..d BuildCont1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
BuildCont1      
	set Data=$lb(CTMUCode,CTMUDesc,CTMUActiveFlag,DateFrom,DateTo,TCTLocDr,TCTCode,TActiveFlag,MURowid)  
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod QueryMedUnit1Fetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryMedUnit1Execute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query QueryMedUnit1(CTLocDr As %String = "", Code As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TCTMUCode:%String,TCTMUDesc:%String,TCTMUActiveFlag:%String,TDateFrom:%String,TDateTo:%String,TCTLocDr:%String,TCTCode:%String,TActiveFlag:%String,TMURowid:%String")
{
}

ClassMethod CTLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CTLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid) 	
 	Quit $$$OK
}

ClassMethod CTLocExecute(ByRef qHandle As %Binary, CTLocDesc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s CTLOCRowID="0"
	s CTLocDesc=$ZCVT(CTLocDesc,"U")
	f  s CTLOCRowID=$o(^CTLOC(CTLOCRowID)) q:CTLOCRowID=""  d 
	.s CTDesc=$p(^CTLOC(CTLOCRowID),"^",2)
	.;w !,"CTLocDesc=",CTLocDesc
	.q:((CTLocDesc'="")&(CTDesc'[CTLocDesc))
	.s CTLocCode=$p(^CTLOC(CTLOCRowID),"^",1)
	.d Build1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Build1      
	set Data=$lb(CTLocCode,CTDesc,CTLOCRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CTLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CTLocExecute ]
{
	
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
	//
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

Query CTLoc(CTLocDesc As %String) As %Query(ROWSPEC = "CTLocCode:%String,CTDesc:%String,CTLOCRowID:%String")
{
}

/// w ##class(web.DHCCTLocMedUnit).Insert("567^bmbmz^Y^07/07/2010^05/09/2010^14")
ClassMethod Del(MURowid As %String) As %String
{
	n (MURowid)
	s CTLocDr=$p(MURowid,"||",1)
	s CTMUChildsub=$p(MURowid,"||",2)
	s flag="N" 
	i $d(^CTLOC(CTLocDr,"MU", CTMUChildsub,"CP"))'=0 s flag="Y"
	q:flag="Y" -100
	&sql(delete from DHC_CTLoc_MedUnit where MU_RowId=:MURowid)
	q flag
}

/// w ##class(web.DHCCTLocMedUnit).Insert("567^bmbmz^Y^07/07/2010^05/09/2010^14")
ClassMethod Insert(InString) As %String
{

	n (InString)
	S PLIST(4)=$p(InString,"^",1)         ///医疗单元代码
	s PLIST(5)=$P(InString,"^",2)         ///医疗单元描述
	s PLIST(6)=$P(InString,"^",3)         ///医疗单元激活标志
	s DateFrom=$P(InString,"^",4)         
	s PLIST(7)=$zdh(DateFrom,4)           ///医疗单元开始日期
	s DateTo=$P(InString,"^",5)           
	s:(DateTo'="") PLIST(8)=$zdh(DateTo,4)             ///医疗单元截止日期
	s PLIST(2)=$P(InString,"^",6)
	&sql(insert into DHC_CTLoc_MedUnit values PLIST())    
	q:SQLCODE SQLCODE
	s flag=$p(%ROWID,$c(1))
	q flag
}

/// InString=Code+"^"+Desc+"^"+ActiveFlag+"^"+DateFrom+"^"+DateTo+"^"+Rowid
/// w ##class(web.DHCCTLocMedUnit).Update("6^zlk^Y^20/07/2010^20/07/2010^14||1")
ClassMethod Update(InString) As %String
{
	n (InString)

    s Rowid=$p(InString,"^",6)          ///医疗单元Rowid
    s COde=$p(InString,"^",1)
	s Desc=$p(InString,"^",2)          ///医疗单元描述
	s ActFlag=$p(InString,"^",3)          ///医疗单元激活标志
	s DateFrom=$p(InString,"^",4) 
	s DateFrom=$zdh(DateFrom,4)            ///医疗单元开始日期
	s DateTo=$p(InString,"^",5)           
	s:(DateTo'="") DateTo=$zdh(DateTo,4) ///医疗单元截止日期
	;s PLIST(6)=$p(InString,"^",6)          ///科室主表指针
	b
	&sql(Update DHC_CTLoc_MedUnit set CTMU_ActiveFlag=:ActFlag, CTMU_Code=:COde,CTMU_Desc=:Desc,CTMU_DateFrom=:DateFrom,CTMU_DateTo=:DateTo where MU_RowId=:Rowid) 
	q:SQLCODE SQLCODE
	q 0
}

ClassMethod getMedUnit(DepID As %String, DocID As %String) As %String
{
	n (DepID,DocID)
	s myrtn=""
	Q:(DocID="") myrtn
	if DepID'="" {
		s MURowid=0
		for {
			s MURowid=$O(^CTLOC(DepID,"MU",MURowid))
			Q:MURowid=""
			s MUCode=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",1)
			s MUDesc=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",2)
			s MUActiveFlag=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",3)
			s MUDateFrom=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",4)
			s MUDateTo=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",5)
			
			if MUActiveFlag'="Y" continue
			if (MUDateFrom'="")&&(MUDateFrom>+$H) continue
			if (MUDateTo'="")&&(MUDateTo<+$H) continue
			
			s MUCRowid=0
			for {
				s MUCRowid=$O(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid))
				Q:MUCRowid=""
				s MUCDocDr=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",1)
				s MUCDateFrom=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",5)
				s MUCDateTo=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",6)
				
				if (MUCDateFrom'="")&&(MUCDateFrom>+$H) continue
				if (MUCDateTo'="")&&(MUCDateTo<+$H) continue
				if MUCDocDr=DocID {
					s myrtn=DepID_"||"_MURowid_"||"_MUCRowid_"^"_MUDesc
				}
				Q:myrtn'=""
			}
		}
	}else{
		;此处应该改成索引
		s DepID=0
		for {
			s DepID=$O(^CTLOC(DepID)) Q:DepID=""
			s MURowid=0
			for {
				s MURowid=$O(^CTLOC(DepID,"MU",MURowid))
				Q:MURowid=""
				s MUCode=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",1)
				s MUDesc=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",2)
				s MUActiveFlag=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",3)
				s MUDateFrom=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",4)
				s MUDateTo=$p($g(^CTLOC(DepID,"MU",MURowid)),"^",5)
				
				if MUActiveFlag'="Y" continue
				if (MUDateFrom'="")&&(MUDateFrom>+$H) continue
				if (MUDateTo'="")&&(MUDateTo<+$H) continue
				
				s MUCRowid=0
				for {
					s MUCRowid=$O(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid))
					Q:MUCRowid=""
					s MUCDocDr=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",1)
					s MUCDateFrom=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",5)
					s MUCDateTo=$P($G(^CTLOC(DepID,"MU",MURowid,"CP",MUCRowid)),"^",6)
					
					if (MUCDateFrom'="")&&(MUCDateFrom>+$H) continue
					if (MUCDateTo'="")&&(MUCDateTo<+$H) continue
					if MUCDocDr=DocID {
						s myrtn=DepID_"||"_MURowid_"||"_MUCRowid_"^"_MUDesc
					}
					Q:myrtn'=""
				}
			}
		}
	}
	
	Q myrtn
}

}
