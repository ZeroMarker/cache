/// CTOR: QP
/// DATE: 2020-07-15
/// DESC: 化疗项目调整比例
Class DHCDoc.Chemo.BS.Ext.ItemAdj Extends DHCDoc.Util.RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2020-07-01
/// DESC: 保存
/// IN  : 	
/// OUT : 
/// EXEC: w ##class(DHCDoc.Chemo.BS.Ext.ItemAdj).Save("")
ClassMethod Save(ADJAry)
{
	s mRtn=0
	s ADJNum=$o(ADJAry(""),-1)
	Q:ADJNum="" mRtn
	s ID=ADJAry(1)
	i ID="" {
		s a=##class(User.ChemoPlanItemAdj).%New()
	} else{
		s a=##class(User.ChemoPlanItemAdj).%OpenId(ID)
	}
	Q:'$ISObject(a) -130
	d a.PIAItemSetObjectId(ADJAry(2))
	s a.PIAPercent=ADJAry(3)
	s a.PIABSA=ADJAry(4)
	s a.PIAGFR=ADJAry(5)
	s a.PIASC=ADJAry(6)
	s a.PIAHeight=ADJAry(7)
	s a.PIAWeight=ADJAry(8)
	s a.PIAFormula=ADJAry(9)
	s a.PIABSAUnitSTD=ADJAry(10)
	s a.PIABSAUnit=ADJAry(11)
	s a.PIAFinalDose=ADJAry(12)
	d a.PIAArcimSetObjectId(ADJAry(13))
	d a.PIAUserSetObjectId(ADJAry(14))
	d a.PIALocSetObjectId(ADJAry(15))
	s a.PIADate=+$h
	s a.PIATime=$p($h,",",2)
	s a.PIAReason=ADJAry(16)
	s a.PIAIBW=ADJAry(17)
	d a.PIAPLIDSetObjectId(+ADJAry(2))
	s sc=a.%Save()
	if ($$$ISERR(sc)) {
		//d $System.Status.DisplayError(sc)
		s mRtn=-130
	} else {
		s mRtn=a.%Id()
	}
	d a.%Close()
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2020-07-31
/// DESC: 查询调整明细
/// IN  : 
/// OUT :    
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.Chemo.BS.Ext.ItemAdj","QryAdjDetail","133")
Query QryAdjDetail(PLID = "") As %Query(ROWSPEC = "id,ItemDR,Percent,BSA,GFR,SC,Height,Weight,Formula,BSAUnitSTD,BSAUnit,FinalDose,Arcim,ArcimName,User,UserName,Loc,LocName,AdjDate,AdjTime,Reason,IBW")
{
}

ClassMethod QryAdjDetailExecute(ByRef qHandle As %Binary, PLID = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set ind=1
 	s id=""
 	s langid=..%LanguageID()
 	f  s id=$o(^BS.DOC.Chemo.PlanItemAdjI("PLID",PLID,id)) q:id=""  d
 	.s ItemDR=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",1)
 	.s b=##class(User.ChemoPlanItem).%OpenId(ItemDR)
	.Q:'$ISObject(b)
 	.s Percent=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",2)_"%"
 	.s BSA=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",3)
 	.s GFR=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",4)
 	.s SC=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",5)
 	.s Height=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",6)
 	.s Weight=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",7)
 	.s Formula=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",8)
 	.s BSAUnitSTD=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",9)
 	.s BSAUnit=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",10)
 	.s FinalDose=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",11)
 	.s Arcim=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",12)
 	.s ARC=+Arcim,VER=$P(Arcim,"||",2)
 	.s ArcimName=$p(^ARCIM(ARC,VER,1),"^",2)
 	.s ArcimName= ##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",ArcimName,langid)
 	.s User=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",13)
 	.s Loc=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",14)
 	.s UserName=$p(^SSU("SSUSR",User),"^",2)
 	.s UserName= ##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",UserName,langid)
 	.s LocName=$p(^CTLOC(Loc),"^",2)
 	.s LocName= ##class(User.CTLoc).GetTranByDesc("CTLOCDesc",LocName,langid)
 	.s AdjDate=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",15)
 	.s AdjDate=##class(websys.Conversions).DateLogicalToHtml(AdjDate)
 	.s AdjTime=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",16)
 	.s AdjTime=$zt(AdjTime,2)
 	.s Reason=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",17)
 	.s IBW=$P(^BS.DOC.Chemo.PlanItemAdjD(id),"^",19)
 	.d output1
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
output1
	Set Data=$lb(id,ItemDR,Percent,BSA,GFR,SC,Height,Weight,Formula,BSAUnitSTD,BSAUnit,FinalDose,Arcim,ArcimName,User,UserName,Loc,LocName,AdjDate,AdjTime,Reason,IBW)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit $$$OK
}

ClassMethod QryAdjDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QryAdjDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod QryAdjDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QryAdjDetailExecute ]
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
