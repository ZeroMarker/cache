Class DHCDoc.OPDoc.CMOrderEntry Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query LookUpInstr(Desc As %String, PAAdmType As %String = "") As %Query(ROWSPEC = "HIDDEN:%String,Desc:%String,Code:%String")
{
}

ClassMethod LookUpInstrExecute(ByRef qHandle As %Binary, Desc As %String, PAAdmType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	if (EpisodeID'="") {
	 	
	}
 	s PHCINRowId=0
 	f  s PHCINRowId=$o(^PHCIN(PHCINRowId)) q:PHCINRowId=""  d
 	.s PHCINDesc2=$p(^PHCIN(PHCINRowId),"^",3)
 	.Q:PHCINDesc2'="饮片"
 	.s PHCINActiveFlag=$p(^PHCIN(PHCINRowId),"^",4)
 	.Q:PHCINActiveFlag="N"
 	.s AvailableType=$P(^PHCIN(PHCINRowId),"^",5)
	.Q:(PAAdmType'="")&&(AvailableType'="")&&(AvailableType'[PAAdmType)
 	.s PHCINDesc1=$p(^PHCIN(PHCINRowId),"^",2)
 	.s Code=$p(^PHCIN(PHCINRowId),"^",1)
	.Do OutputRow6
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
	set Data=$lb(PHCINRowId,PHCINDesc1,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpInstrFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpInstrExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpInstrClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpInstrExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*Query LookUpDuration(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "PHCDURowid:%String,PHCDUDesc,PHCDUCode,PHCDUFactor:%String")
{
	SELECT PHCDU_Rowid,PHCDU_Desc1, PHCDU_Code, PHCDU_Factor
	FROM SQLUser.PHC_Duration
	WHERE   ((PHCDU_Desc1  %STARTSWITH  :desc) or (PHCDU_Factor=:desc)) and PHCDU_Desc2='饮片' 
	ORDER   BY PHCDU_Code
}*/
Query LookUpDuration(Desc As %String) As %Query(ROWSPEC = "PHCDURowid:%String,PHCDUDesc,PHCDUCode,PHCDUFactor:%String")
{
}

ClassMethod LookUpDurationExecute(ByRef qHandle As %Binary, Desc As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s PHCDURowId=0
 	f  s PHCDURowId=$o(^PHCDU(PHCDURowId)) q:PHCDURowId=""  d
 	.s PHCDUDesc2=$p(^PHCDU(PHCDURowId),"^",4)
 	.Q:PHCDUDesc2'="饮片"
 	.s PHCDUDateFrom=$p(^PHCDU(PHCDURowId),"^",5)
 	.Q:(PHCDUDateFrom'="")&&(PHCDUDateFrom>+$h)
 	.s PHCDUDateTo=$p(^PHCDU(PHCDURowId),"^",6)
 	.Q:(PHCDUDateTo'="")&&(PHCDUDateTo<+$h)
 	.s PHCDUDesc=$p(^PHCDU(PHCDURowId),"^",3)
 	.s PHCDUCode=$p(^PHCDU(PHCDURowId),"^",1)
 	.s PHCDUFactor=$p(^PHCDU(PHCDURowId),"^",2)
	.Do OutputRow9
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(PHCDURowId,PHCDUDesc,PHCDUCode,PHCDUFactor)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpDurationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpDurationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpDurationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpDurationExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*Query LookUpFrequence(desc) As %Library.SQLQuery(CONTAINID = 3, ROWSPEC = "PHCFRDesc,PHCFRCode,PHCFRFactor:%String,PHCFRDays:%String,PHCFRRowid:%String")
{
	SELECT PHCFR_Desc1, PHCFR_Code, PHCFR_Factor,PHCFR_Days,PHCFR_Rowid
	FROM SQLUser.PHC_Freq
	WHERE  (PHCFR_Code=:desc or PHCFR_Desc1  %STARTSWITH  :desc) and (%ALPHAUP PHCFR_Desc2='饮片')
	ORDER   BY PHCFR_Code
}*/
Query LookUpFrequence(Desc As %String, PAAdmType As %String = "") As %Query(ROWSPEC = "PHCFRDesc,PHCFRCode,PHCFRFactor:%String,PHCFRDays:%String,PHCFRRowid:%String")
{
}

ClassMethod LookUpFrequenceExecute(ByRef qHandle As %Binary, Desc As %String, PAAdmType As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s PHCFRRowId=0
 	f  s PHCFRRowId=$o(^PHCFR(PHCFRRowId)) q:PHCFRRowId=""  d
 	.s PHCFRDesc2=$p(^PHCFR(PHCFRRowId),"^",4)
 	.Q:PHCFRDesc2'="饮片"
 	.s AvailableType=$P(^PHCFR(PHCFRRowId),"^",7)
	.Q:(PAAdmType'="")&&(AvailableType'="")&&(AvailableType'[PAAdmType)
 	.s PHCFRDesc1=$p(^PHCFR(PHCFRRowId),"^",3)
 	.s PHCFRCode=$p(^PHCFR(PHCFRRowId),"^",1)
 	.s PHCFRFactor=$p(^PHCFR(PHCFRRowId),"^",2)
 	.s PHCFRDays=$p(^PHCFR(PHCFRRowId),"^",5)
	.Do OutputRow7
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
	set Data=$lb(PHCFRDesc1,PHCFRCode,PHCFRFactor,PHCFRDays,PHCFRRowId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpFrequenceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpFrequenceExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpFrequenceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpFrequenceExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// w ##class(DHCDoc.OPDoc.CMOrderEntry).GetCNMedItemPhSpecInstr()

ClassMethod GetCNMedItemPhSpecInstr(HospId As %String = "") As %String
{
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	s PhSpecInstrList=":"
	s CNMedItemPhSpecInstr=..%GetConfig("CNMedItemPhSpecInstr",HospId)
	Q:CNMedItemPhSpecInstr=0 PhSpecInstrList
	for i=1:1:$l(CNMedItemPhSpecInstr,"^") d
	.s OneCNMedItemPhSpecInstr=$p(CNMedItemPhSpecInstr,"^",i)
	.s SpecInstrRowid=$p(OneCNMedItemPhSpecInstr,$c(1),1)
	.s SpecInstrDesc=$p(OneCNMedItemPhSpecInstr,$c(1),2)
	.s SpecInstrDesc=##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",SpecInstrDesc)
	.s PhSpecInstrList=PhSpecInstrList_";"_SpecInstrRowid_":"_SpecInstrDesc
	Q PhSpecInstrList
}

// w ##class(DHCDoc.OPDoc.CMOrderEntry).GetCNMedCookMode()

ClassMethod GetCNMedCookMode() As %String
{
	s ret=""
	s CNMedCookModeStr=..%GetConfig("CNMedCookMode")
	f i=1:1:$l(CNMedCookModeStr,"^") d
	.s OneCNMedCookMode=$p(CNMedCookModeStr,"^",i)
	.s CookModeRowid=$p(OneCNMedCookMode,$c(1),1)
	.s CookModeDesc=$p(OneCNMedCookMode,$c(1),2)
	.s oneret=""""_##class(web.DHCDocUtil).EvalJSON(CookModeRowid)_"""" //""""_"CookModeRowid"_""":"""_
	.//s oneret=oneret_","_""""_"CookModeDesc"_""":"""_##class(web.DHCDocUtil).EvalJSON(CookModeDesc)_""""
	.s oneret=oneret_","_""""_##class(web.DHCDocUtil).EvalJSON(CookModeDesc)_""""
	.s oneret="{"_oneret_"}"
	.i ret="" d
	..s ret="["_oneret
	.else  d
	..s ret=ret_","_oneret
	q ret_"]"
}

Query CNMedCookModeList() As %Query(ROWSPEC = "CookModeRowid:%String,CookModeDesc:%String")
{
}

ClassMethod CNMedCookModeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CNMedCookModeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod CNMedCookModeListExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s CNMedCookModeStr=..%GetConfig("CNMedCookMode")
	f i=1:1:$l(CNMedCookModeStr,"^") d
	.s OneCNMedCookMode=$p(CNMedCookModeStr,"^",i)
	.s CookModeRowid=$p(OneCNMedCookMode,$c(1),1)
	.s CookModeDesc=$p(OneCNMedCookMode,$c(1),2)
 	.Do OutputRow4
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow4
	set Data=$lb(CookModeRowid,CookModeDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod CNMedCookModeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CNMedCookModeListExecute ]
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

Query LookUpOrderPrior(EpisodeType As %String) As %Query(ROWSPEC = "HIDDEN:%String,Desc:%String,Code:%String")
{
}

ClassMethod LookUpOrderPriorExecute(ByRef qHandle As %Binary, EpisodeType As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s CMPriorStr=..%GetConfig("CNMedPrior")
	if CMPriorStr=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK	
	}
	s Count=$LENGTH(CMPriorStr,"^")
	For i = 1:1:Count {
		s PriorRowid=$P(CMPriorStr,"^",i)
		s PriorDesc=$P(^OECPR(PriorRowid),"^",2)
		s PriorCode=$P(^OECPR(PriorRowid),"^",1)
		if (EpisodeType'="I")&&(PriorCode'="NORM") continue
		if (EpisodeType="I")&&(PriorCode="NORM") continue
		d OutputRowPrior
	}
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowPrior
	set Data=$lb(PriorRowid,PriorDesc,PriorCode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod LookUpOrderPriorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpOrderPriorExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod LookUpOrderPriorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpOrderPriorExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(DHCDoc.OPDoc.CMOrderEntry).GetCMComList("IE","")
ClassMethod GetCMComList(ComboName As %String, ExpStr As %String = "") As %String
{
	s JsonObj=[]
	Set langid=..%LanguageID()
	if (ComboName="PrescDuration") {
		Set rset=##class(%ResultSet).%New("DHCDoc.OPDoc.CMOrderEntry.LookUpDuration")
		d rset.Execute("")
		While (rset.Next()) {
			s OneJsonData={}
	        d OneJsonData.%Set("PHCDURowid",rset.Data("PHCDURowid"))
	        s PHCDUDesc=rset.Data("PHCDUDesc")
	        s PHCDUDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",PHCDUDesc,langid)
			d OneJsonData.%Set("PHCDUDesc",PHCDUDesc)
			d OneJsonData.%Set("PHCDUCode",rset.Data("PHCDUCode"))
			d OneJsonData.%Set("PHCDUFactor",rset.Data("PHCDUFactor"))
			do JsonObj.%Push(OneJsonData,"")
		}
	}elseif (ComboName="PrescInstruction"){
		s EpisodeID=$p(ExpStr,"^",1)
		s PAAdmType=$p($g(^PAADM(EpisodeID)),"^",2)
		Set rset=##class(%ResultSet).%New("DHCDoc.OPDoc.CMOrderEntry.LookUpInstr")
		d rset.Execute("",PAAdmType)
		While (rset.Next()) {
			s OneJsonData={}
	        d OneJsonData.%Set("HIDDEN",rset.Data("HIDDEN"))
	        s Desc=rset.Data("Desc")
	        s Desc=##class(User.PHCInstruc).GetTranByDesc("PHCINDesc1",Desc,langid)
			d OneJsonData.%Set("Desc",Desc)
			d OneJsonData.%Set("Code",rset.Data("Code"))
			do JsonObj.%Push(OneJsonData,"")
		}
	}elseif (ComboName="PrescFrequence"){
		s EpisodeID=$p(ExpStr,"^",1)
		s PAAdmType=$p($g(^PAADM(EpisodeID)),"^",2)
		Set rset=##class(%ResultSet).%New("DHCDoc.OPDoc.CMOrderEntry.LookUpFrequence")
		d rset.Execute("",PAAdmType)
		While (rset.Next()) {
			s OneJsonData={}
			s PHCFRDesc=rset.Data("PHCFRDesc")
			s PHCFRDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",PHCFRDesc,langid)
	        d OneJsonData.%Set("PHCFRDesc",PHCFRDesc)
			d OneJsonData.%Set("PHCFRCode",rset.Data("PHCFRCode"))
			d OneJsonData.%Set("PHCFRFactor",rset.Data("PHCFRFactor"))
			d OneJsonData.%Set("PHCFRDays",rset.Data("PHCFRDays"))
			d OneJsonData.%Set("PHCFRRowid",rset.Data("PHCFRRowid"))
			do JsonObj.%Push(OneJsonData,"")
		}
	}elseif (ComboName="PrescPrior"){
		s PAAdmType=$p(ExpStr,"^",1)
		Set rset=##class(%ResultSet).%New("DHCDoc.OPDoc.CMOrderEntry.LookUpOrderPrior")
		d rset.Execute(PAAdmType)
		While (rset.Next()) {
			s OneJsonData={}
	        d OneJsonData.%Set("HIDDEN",rset.Data("HIDDEN"))
	        s Desc=rset.Data("Desc")
	        s Desc=##class(User.OECPriority).GetTranByDesc("OECPRDesc",Desc,langid)
	        s Desc=##class(web.DHCDocUtil).EvalJSON(Desc)
			d OneJsonData.%Set("Desc",Desc)
			d OneJsonData.%Set("Code",rset.Data("Code"))
			do JsonObj.%Push(OneJsonData,"")
		}
	}elseif (ComboName="AddLongOrder"){
		 ;插入的附加长期医嘱-显示到医嘱单
 		 s AddLongOrder=##class(DHCDoc.DHCDocConfig.DocConfig).FindAddLongArcim()
		 for i=1:1:$l(AddLongOrder,"!") {
			s oneAddLongOrder=$p(AddLongOrder,"!",i)
			continue:oneAddLongOrder=""
			s OneJsonData={}
	        d OneJsonData.%Set("value",$p(oneAddLongOrder,"^",1))
	        s desc=$p(oneAddLongOrder,"^",2)
	        s desc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",desc,langid)
			d OneJsonData.%Set("desc",desc)
			do JsonObj.%Push(OneJsonData,"")
		 }
	}elseif (ComboName="CookMode"){
		s LogonHospId=%session.Get("LOGON.HOSPID")
		s EpisodeID=$p(ExpStr,"^",1)
		s InstrRowID=$p(ExpStr,"^",2)
		s PrescNo=$p(ExpStr,"^",3)
		if (InstrRowID="")&&(PrescNo'=""){
			s QUE1RowID=$O(^PAQUE1(0,"PrescNo",PrescNo,0))
			s InstrRowID=$P($G(^PAQUE1(+QUE1RowID,"DHC")),"^",11)
		}
		Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocConfig.DocConfig.FindCookMode")
		d rset.Execute(EpisodeID,LogonHospId,InstrRowID)
		While (rset.Next()) {
			s OneJsonData={}
	        d OneJsonData.%Set("RowID",rset.Data("RowID"))
	        s Desc=rset.Data("Desc")
	        s Desc=##class(websys.Translation).Get("opdoc.oeorder.cmlistcustom.csp",Desc)
			d OneJsonData.%Set("Desc",Desc)
			s Recloc=$tr(rset.Data("RecLoc"),$C(1),"@")
			s Recloc=$tr(Recloc,$C(2),"!")
			s CookModeReclocStr=""
			s OpenHospCookModeReclocStr=Recloc
			for locIndex=1:1:$l(Recloc,"!") {
				s oneRecloc=$p(Recloc,"!",locIndex)
				s locRowId=$p(oneRecloc,"@",1)
				continue:(locRowId="")||('$d(^CTLOC(locRowId)))
				s locHospDr=$p(^CTLOC(locRowId),"^",22)
				if (locHospDr=LogonHospId) {
					if CookModeReclocStr="" s CookModeReclocStr=oneRecloc
					else  s CookModeReclocStr=CookModeReclocStr_"!"_oneRecloc
				}
			}
			d OneJsonData.%Set("CookModeReclocStr",CookModeReclocStr)
			d OneJsonData.%Set("OpenHospCookModeReclocStr",Recloc)
			//d OneJsonData.%Set("RecLoc",Recloc)
			do JsonObj.%Push(OneJsonData,"")
		}
	}
	d rset.Close()
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	s JsonStr=""
	While 'obj.AtEnd { 
		s JsonStr=JsonStr_obj.ReadLine(,.sc,.eol)
	}
	q JsonStr
}

}
