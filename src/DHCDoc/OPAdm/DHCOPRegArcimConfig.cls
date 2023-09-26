Class DHCDoc.OPAdm.DHCOPRegArcimConfig Extends %RegisteredObject
{

/// 挂号设置-》挂号附加条件医嘱设置
ClassMethod Insert(RowID, LocID, MarkID, SexID, AgeRange, Prior, HospID)
{
	if (RowID=""){
		&SQL(insert into SQLUser.DHC_OPRegArcimConfig 
		(OPRegArcimLoc,OPRegArcimMark,OPRegArcimSex,OPRegArcimAgeRang,OPRegArcimPrior,OPRegArcimHospID
		) Values(:LocID,:MarkID,:SexID,:AgeRange,:Prior,:HospID))
	}else{
		&SQL(update SQLUser.DHC_OPRegArcimConfig set OPRegArcimLoc=:LocID ,OPRegArcimMark=:MarkID,
		OPRegArcimSex=:SexID,OPRegArcimAgeRang=:AgeRange,OPRegArcimPrior=:Prior,OPRegArcimHospID=:HospID
		where RowID=:RowID) 	
			}
	s rtn=SQLCODE
	q rtn
}

ClassMethod Delect(RowID)
{
	q:RowID="" ""
	&SQL(DELETE SQLUser.DHC_OPRegArcimConfig where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

Query FindRegArcimConfig(HospID As %String = "") As %Query(ROWSPEC = "RowID:%String ,LocDesc:%String ,LocID:%String ,MarkDesc:%String ,MarkID:%String ,SexDesc:%String ,SexID:%String ,AgeRange:%String,PriorLeven:%String")
{
}

ClassMethod FindRegArcimConfigClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRegArcimConfigExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRegArcimConfigFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRegArcimConfigExecute ]
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

ClassMethod FindRegArcimConfigExecute(ByRef qHandle As %Binary, HospID As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.DHCOPRegArcimConfig","FindRegArcimConfig","4634",110,2)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	s RowID=0
	for{
		s RowID=$O(^DHCOPRegArcimConfig(RowID))
		q:RowID=""
		s hospdr=$P(^DHCOPRegArcimConfig(RowID),"^",7)
		continue:HospID'=hospdr
		s LocDesc=""
		s LocID=$P(^DHCOPRegArcimConfig(RowID),"^",1)
		if (LocID'="") s LocDesc=$p($g(^CTLOC(LocID)),"^",2)
		s MarkDesc=""
		s MarkID=$P(^DHCOPRegArcimConfig(RowID),"^",2)
		if (MarkID'="") s MarkDesc=$p($g(^CTPCP(MarkID,1)),"^",2)
		s SexDesc=""
		s SexID=$P(^DHCOPRegArcimConfig(RowID),"^",3)
		if (SexID'="") s SexDesc=$p($g(^CT("SEX",SexID)),"^",2)
		s AgeRange=$P(^DHCOPRegArcimConfig(RowID),"^",4)
		s PriorLeven=$P(^DHCOPRegArcimConfig(RowID),"^",5)
		set Data=$lb(RowID,LocDesc,LocID,MarkDesc,MarkID,SexDesc,SexID,AgeRange,PriorLeven)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

Query FindRegArcimDesc(RowID As %String = "") As %Query(ROWSPEC = "RowID:%String ,ARCIMRowid:%String ,ARCIMDesc:%String ,Number:%String ")
{
}

ClassMethod FindRegArcimDescClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRegArcimDescExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindRegArcimDescFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRegArcimDescExecute ]
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

ClassMethod FindRegArcimDescExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.OPAdm.DHCOPRegArcimConfig","FindRegArcimConfig","4634",110,2)
	Set repid=$I(^CacheTemp)	
	If $g(ind)="" Set ind=1
	if (RowID=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s ARCIMStr=$P(^DHCOPRegArcimConfig(RowID),"^",6)
	for i=1:1:$L(ARCIMStr,"@"){
		s RowID=i
		s OneStr=$P(ARCIMStr,"@",i)
		continue:OneStr=""
		s ARCIMRowid=$P(OneStr,"!",1)
		s ARCIMDesc=$p($G(^ARCIM(+ARCIMRowid,$P(ARCIMRowid,"||",2),1)),"^",2)
		s Number=$P(OneStr,"!",2)
		set Data=$lb(RowID,ARCIMRowid,ARCIMDesc,Number)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod ARCInsert(RowID, ARCIMStr, indnumber)
{
	if (RowID="") q ""
	s MastARCIMStr=$P(^DHCOPRegArcimConfig(RowID),"^",6)
	if ("@"_MastARCIMStr_"@")[("@"_ARCIMStr_"@") {
		Q "repeat"
	}
	if (indnumber=""){
		s MastARCIMStr=MastARCIMStr_"@"_ARCIMStr
	}else{
		s $P(MastARCIMStr,"@",indnumber)=ARCIMStr
	}
	&SQL(update SQLUser.DHC_OPRegArcimConfig set OPRegArcimStr=:MastARCIMStr where RowID=:RowID) 
	s rtn=SQLCODE
	q rtn
}

// 

ClassMethod ArcDelect(RowID, indnumber)
{
	if (RowID="") q ""
	s MastARCIMStr=$P(^DHCOPRegArcimConfig(RowID),"^",6)
	s $P(MastARCIMStr,"@",indnumber)=""
	s NewMasStr=""
	for i=1:1:$L(MastARCIMStr,"@"){
		s OneStr=$P(MastARCIMStr,"@",i)
		continue:OneStr=""
		if NewMasStr="" s NewMasStr=OneStr
		else  s NewMasStr=NewMasStr+"@"+OneStr
	}
	&SQL(update SQLUser.DHC_OPRegArcimConfig set OPRegArcimStr=:NewMasStr where RowID=:RowID) 
	s rtn=SQLCODE
	q rtn
}

/// 判断是否有额外医嘱
/// ##class(DHCDoc.OPAdm.DHCOPRegArcimConfig).CheckForOtherARCIM(42,1574,571,"2893||1^9681||1")
ClassMethod CheckForOtherARCIM(LocID, MarkID, PatientID, SerIdStr)
{
	q:((LocID="")||(MarkID="")||(PatientID="")) SerIdStr
	s ^tempqujian("CheckForOtherARCIM")=LocID_","_MarkID_","_PatientID_","_SerIdStr
	s Sex=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	s PatDOB=$P(^PAPER(PatientID,"ALL"),"^",6)
	s Age=$$CalAge^at182(PatDOB,+$H,"","","")
	s Age=$p(Age,"|",12)
	s HospID=$p($g(^CTLOC(LocID)),"^",22)
	s MasterPrior=0,MasterRowid=""
	s rtnArcStr=""
	s RowID=0
	for{
		s RowID=$O(^DHCOPRegArcimConfig(RowID))
		q:RowID=""
		s hospdr=$P(^DHCOPRegArcimConfig(RowID),"^",7)
		continue:HospID'=hospdr
		s LocDesc=""
		s ArcLocID=$P(^DHCOPRegArcimConfig(RowID),"^",1)
		continue:((ArcLocID'="")&&(ArcLocID'=LocID))
		s ARCMarkID=$P(^DHCOPRegArcimConfig(RowID),"^",2)
		continue:((ARCMarkID'="")&&(ARCMarkID'=MarkID))
		s SexID=$P(^DHCOPRegArcimConfig(RowID),"^",3)
		continue:((SexID'="")&&(SexID'=Sex))
		s AgeRange=$P(^DHCOPRegArcimConfig(RowID),"^",4)
		if ((AgeRange'="")&&(AgeRange'="-")){
			s samllage=+$P(AgeRange,"-",1)
			s bigage=+$P(AgeRange,"-",2)
			continue:((Age<samllage)||(Age>bigage))
		}
		s PriorLeven=+$P(^DHCOPRegArcimConfig(RowID),"^",5)
		if (PriorLeven>MasterPrior)||((PriorLeven=0)&&(MasterRowid="")){
			s rtnArcStr=$P(^DHCOPRegArcimConfig(RowID),"^",6)
			s MasterPrior=PriorLeven
			s MasterRowid=RowID
		}
	}
	if (rtnArcStr'=""){
		for i=1:1:$L(rtnArcStr,"@"){
			s RowID=i
			s OneStr=$P(rtnArcStr,"@",i)
			continue:OneStr=""
			s ARCIMRowid=$P(OneStr,"!",1)
			s ASCheckStr=##Class(web.DHCDocOrderCommon).GetItemAgeSexRestriction(ARCIMRowid,PatientID,HospID)
			if (+ASCheckStr=1){
				continue
			}
			if (SerIdStr="") s SerIdStr=ARCIMRowid
			else  s SerIdStr=SerIdStr_"^"_ARCIMRowid
		}
	}
	q SerIdStr
}

Query FindAllItem(Alias As %String, StopAfterLongOrder As %String = "", NotAutoStop As %String = "", AppendedArcimFlag As %String = "", LogonWard As %String = "", GroupID As %String = "", TYPE As %String = "", HospId As %String = "") As %Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String,selected:%Boolean,SameFreqDifferentDosesFlag:%String")
{
}

ClassMethod FindAllItemExecute(ByRef qHandle As %Binary, Alias As %String, StopAfterLongOrder As %String = "", NotAutoStop As %String = "", AppendedArcimFlag As %String = "", LogonWard As %String = "", GroupID As %String = "", TYPE As %String = "", HospId As %String = "") As %Status
{
	set ^TMP("FindAllItem")=$lb(Alias, StopAfterLongOrder, NotAutoStop, AppendedArcimFlag, LogonWard, GroupID, TYPE, HospId)
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if (Alias="")&&(StopAfterLongOrder="")&&(NotAutoStop="")&&(AppendedArcimFlag=""){
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	s UserID=%session.Data("LOGON.USERID")
	s LocId=%session.Get("LOGON.CTLOCID")
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	i ($g(GroupID)="")&&($d(%session)) s GroupID=%session.Get("LOGON.GROUPID")
	if (HospId'="") {
		s HospCodeNode="HospDr_"_HospId
	}else{
		s HospCodeNode=""
	}
	s DefHospId=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("ARC_ItmMast",HospId)
	k TempARCMList($j)
	if (AppendedArcimFlag="on")&&(LogonWard'="") {
		s ArcimID=0
		for {
			s ArcimID=$o(^User.DHCDocInstrArcimWardI("AddItemArcimDR","A",LogonWard,ArcimID)) q:ArcimID=""
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimID,DefHospId)="N"
			continue:($d(TempARCMList($j,ArcimID)))
			s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
			continue:ArcimDesc=""
			s selected=0,TempARCMList($j,ArcimID)=1
			s Find=0
			if (Alias'=""){
				s ALIASRowId=0
				for {
					s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ArcimID,ALIASRowId)) Q:(ALIASRowId="")||(Find=1)
					s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
					s ALIASText=$$ALPHAUP^SSUTIL4(ALIASText)
					if ALIASText[Alias s Find=1
				}
			}
			continue:(Alias'="")&&(Find=0)&&($$ALPHAUP^SSUTIL4(ArcimDesc)'[Alias)
			d OutputRowFindAllItem
		}
		/*s Alias=$$ALPHAUP^SSUTIL4(Alias)
		s ArcimID=0
		for {
			s ArcimID=$o(^DHCDocConfig("ArcimWardAdd",LogonWard,ArcimID)) Q:ArcimID=""
			continue:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimID,DefHospId)="N"
			continue:($d(TempARCMList($j,ArcimID)))
			s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
			continue:ArcimDesc=""
			s selected=0,TempARCMList($j,ArcimID)=1
			s Find=0
			if (Alias'=""){
				s ALIASRowId=0
				for {
					s ALIASRowId=$o(^ARC("ALIAS",0,"ARCIM",ArcimID,ALIASRowId)) Q:(ALIASRowId="")||(Find=1)
					s ALIASText=$p($g(^ARC("ALIAS",ALIASRowId)),"^",6)
					s ALIASText=$$ALPHAUP^SSUTIL4(ALIASText)
					if ALIASText[Alias s Find=1
				}
			}
			continue:(Alias'="")&&(Find=0)&&($$ALPHAUP^SSUTIL4(ArcimDesc)'[Alias)
			d OutputRowFindAllItem
		}
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK*/
	}
	s count=0
	Set rs1=##Class(%ResultSet).%New("web.DHCDocOrderEntry:LookUpItem")
	d rs1.Execute(Alias,GroupID,"","",TYPE,"","","","","",UserID,"","",LocId_$C(3)_HospId,"","^1")
	while(rs1.Next()){
		s ArcimDesc=rs1.GetData(1)
		s ArcimID = rs1.GetData(2)
		continue:ArcimID=""
		continue:($d(TempARCMList($j,ArcimID)))
		s ARCIMType=rs1.GetData(4)
		continue:ARCIMType="ARCOS"
		s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		s RegSerBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimID,HospId)
		continue:RegSerBillSubType="NotRegFee"
		s selected=0 ,TempARCMList($j,ArcimID)=1
		d OutputRowFindAllItem
		/*s count=count+1
		if (count>1000){
			q
		}*/
	}
	if (StopAfterLongOrder=1){
		s ArcimID=0
		f  s ArcimID=$o(^DHCDocConfig("StopAfterAllLongOrder",ArcimID)) q:ArcimID=""  d
		.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimID,DefHospId)="N"
		.q:($d(TempARCMList($j,ArcimID)))
		.s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
		.q:ArcimDesc=""
		.s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		.s selected=0,TempARCMList($j,ArcimID)=1
		.s RegSerBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimID,HospId)
		.q:RegSerBillSubType="NotRegFee"
		.d OutputRowFindAllItem
	}
	if (NotAutoStop=1){
		s ArcimID=0
		f  s ArcimID=$o(^DHCDocConfig("NotAutoStopLongOrder",ArcimID)) q:ArcimID=""  d
		.Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("ARC_ItmMast",ArcimID,DefHospId)="N"
		.q:($d(TempARCMList($j,ArcimID)))
		.s ArcimDesc=$p($g(^ARCIM(+ArcimID,$p(ArcimID,"||",2),1)),"^",2)
		.q:ArcimDesc=""
		.s ArcimDesc=##class(web.DHCDocUtil).EvalJSON(ArcimDesc)
		.s selected=0,TempARCMList($j,ArcimID)=1
		.s RegSerBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimID,HospId)
		.q:RegSerBillSubType="NotRegFee"
		.d OutputRowFindAllItem
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindAllItem
	;医嘱只允许开一次标志/同频次不同剂量医嘱标志->此处常用用法选择医嘱项用
	s SameFreqDifferentDosesFlag="N"
	s DARCIMRowid=$o(^DHCItmMast("0","ARCIM",ArcimID,""))
	if (DARCIMRowid'=""){
		s SameFreqDifferentDosesFlag=$P(^DHCItmMast(DARCIMRowid),"^",22)
	}
	Set Data=$lb(ArcimID,ArcimDesc,selected,SameFreqDifferentDosesFlag)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindAllItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAllItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindAllItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAllItemExecute ]
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

}
