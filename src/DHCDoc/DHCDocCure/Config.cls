Class DHCDoc.DHCDocCure.Config Extends DHCDoc.Util.RegisteredObject
{

ClassMethod getDefaultData(value As %String, HospID As %String = "") As %String
{
	s rtn=##class(web.DHCDocConfig).GetConfigNode(value,HospID) ;$g(^DHCDocConfig(value))
	s rtn=##class(ext.util.String).EvalJSON(rtn)
	s rtn="{"_"""result"""_":"_""""_rtn_""""_"}"
	q rtn
}

/// w ##class(DHCDoc.DHCDocCure.Config).getCureConfigData(2)
ClassMethod getCureConfigData(HospID As %String)
{
	s DHCDocCureNeedTriage=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureNeedTriage",HospID)
	s DHCDocCureAppDoseQty=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureAppDoseQty",HospID)
	s DHCDocCureAppHiddenOtherUser=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureAppHiddenOtherUser",HospID)
	s DHCDocCureAppointAllowExec=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureAppointAllowExec",HospID)
	s DHCDocCureAppQryNotWithTab=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureAppQryNotWithTab",HospID)
	s DHCDocCureWorkQrySelf=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureWorkQrySelf",HospID)
	s DHCDocCureAdviseInsertOrd=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureAdviseInsertOrd",HospID)
	s DHCDocCureUseCall=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureUseCall",HospID)
	
	s Json={}
	s Json.DHCDocCureNeedTriage=DHCDocCureNeedTriage
	s Json.DHCDocCureAppDoseQty=DHCDocCureAppDoseQty
	s Json.DHCDocCureAppHiddenOtherUser=DHCDocCureAppHiddenOtherUser
	s Json.DHCDocCureAppointAllowExec=DHCDocCureAppointAllowExec
	s Json.DHCDocCureAppQryNotWithTab=DHCDocCureAppQryNotWithTab
	s Json.DHCDocCureWorkQrySelf=DHCDocCureWorkQrySelf
	s Json.DHCDocCureAdviseInsertOrd=DHCDocCureAdviseInsertOrd
	s Json.DHCDocCureUseCall=DHCDocCureUseCall

	Q Json.%ToJSON()
}

Query FindLoc(Loc As %String, CureFlag As %String = "", Hospital As %String = "", Type As %String = "", Val As %String = "", OpenForAllHosp As %String = "", SessionStr As %String = "") As %Query(ROWSPEC = "LocRowID:%String,LocDesc:%String,LocContactName:%String,LocNeedTriage:%String,LocNeedReport:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindLoc","","1","2","ITEM","1||22","")
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindLoc","","1",3)
ClassMethod FindLocExecute(ByRef QHandle As %Binary, Loc As %String, CureFlag As %String = "", Hospital As %String = "", Type As %String = "", Val As %String = "", OpenForAllHosp As %String = "", SessionStr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ^tmplog("FindLocExecute")=$lb(Loc,CureFlag,Hospital,Type,Val,OpenForAllHosp)
	if Hospital=""{
		s Hospital=$p(SessionStr,"^",4)
	}
	s langid=$p(SessionStr,"^",6)
	s ind=1
	if Type'=""{
		Q ..FindLocNewExecute(.QHandle,Loc,CureFlag,Hospital,Type,Val,OpenForAllHosp,SessionStr)	
	}
	s Loc=$ZCVT(Loc,"U")
	s rowid=0 f  s rowid=$o(^CTLOC(rowid)) q:rowid=""  d
	.s ActiveFlag=##class(DHCDoc.DHCDocCure.Common).CheckActiveLoc(rowid)
	.Q:ActiveFlag'="Y"
	.s CTHosp=$p($g(^CTLOC(rowid)),"^",22)
	.Q:(Hospital'="")&&(Hospital'=CTHosp)
	.q:(CureFlag'="")&&(##class(DHCDoc.DHCDocCure.Apply).GetCureLocFlag(rowid,"","",Hospital)'=1)
	.s CTWardFlag=$p($g(^CTLOC(rowid)),"^",5)
	.s CTLOCType=$p(^CTLOC(rowid),"^",13)
    .Q:(CureFlag="")&&("^E^EM^OP^"'[("^"_CTLOCType_"^")) ;(CTWardFlag="Y") 
	.s CTDesc=$p($g(^CTLOC(rowid)),"^",2)
	.s CTDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",CTDesc,langid)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(rowid)),"^",1)
	.;用作放助记码的地方
	.s CTContactName=$p($g(^CTLOC(rowid)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.if CTContactName="" s CTContactName=CTCode
	.Q:(Loc'="")&&((CTDesc'[(Loc))&&(CTContactName'[(Loc)))
	.s CureLocNeedTriage="",CureLocNeedReport=""
	.Do OutputRowFindLoc
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindLoc
	set Data=$lb(rowid,CTDesc,CTContactName,CureLocNeedTriage,CureLocNeedReport)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindLocExecute ]
{
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else{	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindLocNewExecute(ByRef QHandle As %Binary, Loc As %String, CureFlag As %String = "", Hospital As %String = "", Type As %String = "", Val As %String = "", OpenForAllHosp As %String = "", SessionStr As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	if (Val="") {
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if Hospital=""{
		s Hospital=$p(SessionStr,"^",4)
	}
	s langid=$p(SessionStr,"^",6)
	s CatDr=""
	if Type="CAT"{
		s CatDr=+$p(^DHCDocCureArcCat(+Val,"LIC",$p(Val,"||",2)),"^",1)
		s LocStr=##class(web.DHCARCOrdSets).GetLocRecLocByItemCat(CatDr,OpenForAllHosp)
		if (LocStr'=""){
			d OutPutData
			Set QHandle=$lb(0,repid,0)
			Quit $$$OK
		}
	}elseif Type="ITEM"{
		s ItemDr=$p(^DHCDocCureArcCat(+Val,"LIM",$p(Val,"||",2)),"^",1)
		if (ItemDr'["||") {
			s CatDr=$p(^ARCOS(ItemDr),"^",9)
			s LocStr=##class(web.DHCARCOrdSets).GetLocRecLocByItemCat(CatDr,OpenForAllHosp)
			if (LocStr'=""){
				d OutPutData
				Set QHandle=$lb(0,repid,0)
				Quit $$$OK
			}
		}else{
			s LocStr=##class(web.DHCARCOrdSets).GetLocRecLocByItem(ItemDr,OpenForAllHosp)
			if (LocStr'=""){
				d OutPutData
				Set QHandle=$lb(0,repid,0)
				Quit $$$OK
			}
			if (ItemDr["||") s CatDr=$P($g(^ARCIM(+ItemDr,$p(ItemDr,"||",2),1)),"^",10 )
			else  s CatDr=$p($g(^ARCOS(ItemDr)),"^",3)
			if (CatDr="") {
				Set QHandle=$lb(0,repid,0)
				Quit $$$OK
			}
			s LocStr=##class(web.DHCARCOrdSets).GetLocRecLocByItemCat(CatDr,OpenForAllHosp)
			if (LocStr'=""){
				d OutPutData
				Set QHandle=$lb(0,repid,0)
				Quit $$$OK
			}
		}
	}

    s OrderCat=$P($g(^ARC("IC",CatDr)),"^",8)
	if (OrderCat="") {
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s LocStr=##class(web.DHCARCOrdSets).GetLocRecLocByCat(OrderCat,OpenForAllHosp)
	if (LocStr'=""){
		d OutPutData
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
   	Set QHandle=$lb(0,repid,0)
   	Quit $$$OK
OutPutData
	for i=1:1:$l(LocStr,$c(2)) {
		s oneLocStr=$p(LocStr,$c(2),i)
		s LocRowId=$p(oneLocStr,$c(1),1)
		s LocDesc=$p(oneLocStr,$c(1),2)
		s DefaultFlag=$p(oneLocStr,$c(1),3)
		if (DefaultFlag="Y") s DefaultFlag=1
		e  s DefaultFlag=0
		s CTCode=$p($g(^CTLOC(LocRowId)),"^",1)
		s CTContactName=$p($g(^CTLOC(LocRowId)),"^",43)
		s CTWardFlag=$p($g(^CTLOC(LocRowId)),"^",5)
		s CTHosp=$p($g(^CTLOC(LocRowId)),"^",22)
		Q:(OpenForAllHosp'=1)&&(Hospital'="")&&(Hospital'=CTHosp)
		s CTContactName=$ZCVT(CTContactName,"U")
		if CTContactName="" s CTContactName=CTCode
		continue:##CLASS(web.DHCOPAdmReg).CheckLocDesc(LocRowId,Loc)'=1
		;continue:(Loc'="")&&((LocDesc'[(Loc))&&(CTContactName'[(Loc)))
		s CureLocNeedTriage="",CureLocNeedReport=""
		Do OutputRowFindLocNew
	}
	Quit
OutputRowFindLocNew
    set Data=$lb($g(LocRowId),$g(LocDesc),$g(CTContactName),$g(CureLocNeedTriage),$g(CureLocNeedReport))
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

Query FindCureLinkLoc(RowIDLocRowID As %String) As %Query(ROWSPEC = "RowID:%String,LinkLocRowID:%String,LocDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindCureLinkLoc","44")
ClassMethod FindCureLinkLocExecute(ByRef QHandle As %Binary, LocRowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ^tmpnk("FindCureLinkLocExecute")=LocRowID
	s ind=1
	if (LocRowID=""){
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s rowid=0 f  s rowid=$o(^DHCDocCureLinkLoci(0,"MAINLOC",LocRowID,rowid)) q:rowid=""  d
	.s LinkLocID=$p(^DHCDocCureLinkLoc(rowid),"^",2)
	.s CTDesc=$p($g(^CTLOC(LinkLocID)),"^",2)
	.s CTDesc=$ZCVT(CTDesc,"U")
	.s CTCode=$p($g(^CTLOC(LinkLocID)),"^",1)
	.s CTContactName=$p($g(^CTLOC(LinkLocID)),"^",43)
	.s CTContactName=$ZCVT(CTContactName,"U")
	.Do OutputRowFindLoc
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindLoc
	set Data=$lb(rowid,LinkLocID,CTDesc)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindCureLinkLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindCureLinkLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCureLinkLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureLinkLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// Desc:	取治疗科室扩展设置
/// Input:	DCARowId 治疗申请菜单ID CureLocID 判断科室id HospId 院区ID
/// 		Type 取用类型(Report 报到,Reconfirm 治疗执行启用双签,Triage 分诊,AppAllowExec 预约直接执行,AppDoseQty 按单次预约)
/// Output:	1 启用 0 未启用
/// w ##class(DHCDoc.DHCDocCure.Config).GetCureLocConfig("",7)
ClassMethod GetCureLocConfig(DCARowId As %String, NodeName As %String, CureLocID As %String = "", HospId As %String = "")
{
	;Modify:20221012  默认全部预约允许直接执行，开医嘱正常生成执行记录
	if (NodeName="CureLocAppAllowExec") || (NodeName="CureLocAppDoseQty"){
		Q 1	
	}
	if (DCARowId'="")&&(CureLocID=""){
		Set OrderId=$p($g(^DHCDocCure(DCARowId)),"^",2)
		Set CurerRecLocID=$p($g(^OEORD(+OrderId,"I",$p(OrderId,"||",2),3)),"^",6)
		Set CureLocID=CurerRecLocID
	}
	if CureLocID'="",HospId="" {
		s HospId=$p($g(^CTLOC(CureLocID)),"^",22)	
	}
	if ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	
	if (NodeName="")!(CureLocID=""){
		Q 0	
	}
	s NodeSeq=$case(NodeName,
		"CureLocNeedReport":2,
		"CureLocNeedTriage":3,
		"CureLocReconfirm":4,
		"CureLocAppAllowExec":5,
		"CureLocAppDoseQty":6,
		"CureLocAppHiddenOtherUser":7,
		"CureLocWorkQrySelf":8,
		"CureLocRelateAssTemp":9,
		:""
	)
	if NodeSeq=""{
		Q 0	
	}
	
	s ret=0
	s RowId=$o(^DHCDocCureLEi(0,"Loc",CureLocID,""))
	if RowId'=""{
		if NodeSeq=9{
			s ret=..GetCureLocRelateAssTemp(CureLocID,HospId)
		}else{
			s NeedFlag=$p($g(^DHCDocCureLE(RowId)),"^",NodeSeq)
			s ret=$case(NeedFlag,"Y":1,:0)
		}
	}
	
	Q ret
}

ClassMethod GetCureLocRelateAssTemp(CureLocID As %String = "", HospId As %String = "")
{
	if (CureLocID=""){
		Q ""
	}
	if CureLocID'="",HospId="" {
		s HospId=$p($g(^CTLOC(CureLocID)),"^",22)	
	}
	s LANGID=..%LanguageID()
	if ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s ret=""
	s RowId=$o(^DHCDocCureLEi(0,"Loc",CureLocID,""))
	if RowId'=""{
		s RelateTemp=$p($g(^DHCDocCureLE(RowId)),"^",9)
		if RelateTemp'=""{
			for loop=1:1:$l(RelateTemp,","){
				s mRelateTemp=$p(RelateTemp,",",loop)
				s mRelateTempDesc=$p($g(^DHCDocAppBLMap(mRelateTemp)),"^",2)
				s mRelateTempDesc=##class(User.DHCDocAppBLMap).GetTranByDesc("APPMapName",mRelateTempDesc,LANGID)
				s mRelateTempActive=$p($g(^DHCDocAppBLMap(mRelateTemp)),"^",4)
				continue:mRelateTempActive="N"
				if ret="" s ret=mRelateTemp
				else  s ret=ret_","_mRelateTemp
			}
		}
	}
	
	Q ret
}

/// Update DHC_DocCureLocExpand 数据
ClassMethod SaveCureLocConfig(CureLocID As %String, ConfigInfo As %String) As %String
{
	Q:(CureLocID="") "-100"	
	d ##class(DHCDoc.Util.FromJSON).FromJSONToArr(ConfigInfo,.ConfigArr)
	s RowId=$o(^DHCDocCureLEi(0,"Loc",CureLocID,""))
	k PLIST
	
	s PLIST(3)=$g(ConfigArr("CureLocNeedReport"))
	s PLIST(4)=$g(ConfigArr("CureLocNeedTriage"))
	s PLIST(5)=$g(ConfigArr("CureLocReconfirm"))
	s PLIST(6)=$g(ConfigArr("CureLocAppAllowExec"))
	s PLIST(7)=$g(ConfigArr("CureLocAppDoseQty"))
	s PLIST(8)=$g(ConfigArr("CureLocAppHiddenOtherUser"))
	s PLIST(9)=$g(ConfigArr("CureLocWorkQrySelf"))
	s PLIST(10)=$g(ConfigArr("CureLocRelateAssTemp"))
	if RowId=""{
		s PLIST(2)=CureLocID
		&sql(insert into SQLUser.DHC_DocCureLocExpand VALUES :PLIST())
	}else{
		&sql(update SQLUser.DHC_DocCureLocExpand VALUES :PLIST() where DDCLE_RowID=:RowId)
	}
	q SQLCODE
}

ClassMethod SaveCureLocExpand(CureLocID As %String, ReportFlag As %String, TriageFlag As %String) As %String
{
	Q:(CureLocID="") "-100"	
	s RowId=$o(^DHCDocCureLEi(0,"Loc",CureLocID,""))
	if RowId=""{
		&sql(insert into SQLUser.DHC_DocCureLocExpand (DDCLE_LocDr, DDCLE_ReportFlag, DDCLE_TriageFlag) values (:CureLocID, :ReportFlag, :TriageFlag))
	}else{
		&sql(update SQLUser.DHC_DocCureLocExpand set DDCLE_ReportFlag=:ReportFlag, DDCLE_TriageFlag=:TriageFlag where DDCLE_RowID=:RowId)
	}
	
	q SQLCODE
}

ClassMethod insertLinkLoc(MainLocID, LinkLocID)
{
	if MainLocID="" q "-100"
	if LinkLocID="" q "-100"
	if MainLocID=LinkLocID q "-101"
	if $d(^DHCDocCureLinkLoci(0,"LINKLOC",LinkLocID,MainLocID)) q "-1"
	if '$d(^CTLOC(+LinkLocID))||(+LinkLocID=0) q "-2"
	s RowID=""
	if RowID=""{
		s obj=##class(User.DHCDocCureLinkLoc).%New()
	}else{
		s obj=##class(User.DHCDocCureLinkLoc).%OpenId(RowID)	
	}
	if $IsObject(obj){
		d obj.DDCLLMainLocDrSetObjectId(MainLocID)
		d obj.DDCLLLinkLocDrSetObjectId(LinkLocID)
		s sc=obj.%Save()
	    If $$$ISERR(sc) Quit "-102"
	    d obj.%Close()
	}
	Q 0
}

ClassMethod deleteLink(RowID)
{
	if RowID="" q "-100"
	&sql(delete SqlUser.DHC_DocCureLinkLoc where DDCLL_RowID=:RowID)
	Q SQLCODE
}

ClassMethod SaveLoc(LocId As %String) As %String
{
	Q:LocId="" 100
	i '$d(^DHCDocConfig("DHCDocCureLocRoom",LocId)) s ^DHCDocConfig("DHCDocCureLocRoom",LocId)=""
	q 0
}

ClassMethod DeleteLoc(LocId As %String)
{
	Q:LocId="" 100
	Q:'$D(^DHCDocConfig("DHCDocCureLocRoom",LocId)) 100
	k ^DHCDocConfig("DHCDocCureLocRoom",LocId)
	q 0
}

/// 功能：查询治疗科室
/// 返回：科室名称，科室Rowid
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","QueryCureLoc","2")
Query QueryCureLoc(HospID As %String = "", LogLocID As %String = "") As %Query(ROWSPEC = "LocDesc:%String,LocId:%String,LocContactName:%String")
{
}

ClassMethod QueryCureLocExecute(ByRef qHandle As %Binary, HospID As %String = "", LogLocID As %String = "") As %Status
{
	s ind=0
	s langid=..%LanguageID()
	k GetCureLocArr
	s DHCDocCureLocStr=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureLocStr",HospID) ;$g(^DHCDocConfig("DHCDocCureLocStr"))
	for i=1:1:$l(DHCDocCureLocStr,"^")  d
	.s CureLocId=$p(DHCDocCureLocStr,"^",i)
	.Q:CureLocId="" 
	.Do OutCureLoc
	s ParRef=""
	for {
		s ParRef=$o(^DHCDocCureArcCat(0,"LICCATLOC",ParRef))
		Q:ParRef=""
		s ChildSub=""
		for {
			s ChildSub=$o(^DHCDocCureArcCat(0,"LICCATLOC",ParRef,ChildSub))
			Q:ChildSub=""
			s CureLocId=0
			for{
				s CureLocId=$o(^DHCDocCureArcCat(0,"LICCATLOC",ParRef,ChildSub,CureLocId))
				Q:CureLocId=""
				Do OutCureLoc
			}
		}
	}
	s ParRef=""
	for {
		s ParRef=$o(^DHCDocCureArcCat(0,"LIMMASTLOC",ParRef))
		Q:ParRef=""
		s ChildSub=""
		for {
			s ChildSub=$o(^DHCDocCureArcCat(0,"LIMMASTLOC",ParRef,ChildSub))
			Q:ChildSub=""
			s CureLocId=0
			for{
				s CureLocId=$o(^DHCDocCureArcCat(0,"LIMMASTLOC",ParRef,ChildSub,CureLocId))
				Q:CureLocId=""
				Do OutCureLoc
			}
		}
	}
	Quit $$$OK
OutCureLoc
	if (LogLocID'="")&&(LogLocID'=CureLocId){
		quit	
	}
	s CTLocDesc=$p(^CTLOC(CureLocId),"^",2)
	s CTLocDesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",CTLocDesc,langid)
	s CTCode=$p($g(^CTLOC(CureLocId)),"^",1)
	s CTContactName=$p($g(^CTLOC(CureLocId)),"^",43)
	s CTContactName=$ZCVT(CTContactName,"U")
	if CTContactName="" s CTContactName=CTCode
	
	s CTHosp=$p($g(^CTLOC(CureLocId)),"^",22)
	if (HospID'="")&&(HospID'=CTHosp){
		quit	
	}
	if $d(GetCureLocArr(CureLocId)){
		quit	
	}
	set GetCureLocArr(CureLocId)=""
 	set qHandle($I(ind))=$lb(CTLocDesc,CureLocId,CTContactName)
	quit
}

ClassMethod QueryCureLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCureLocExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// 功能：查询本科室可以预约的资源
/// 参数：LocID:科室ROWID
/// 返回：资源列表 
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","QueryResource","63")
Query QueryResource(LocID As %String) As %Query(ROWSPEC = "TResDesc:%String,TRowid:%String,TDocRowid:%String")
{
}

ClassMethod QueryResourceExecute(ByRef qHandle As %Binary, LocID As %String) As %Status
{
	if LocID=""{
		Quit $$$OK
	}
	s langid=..%LanguageID()
	s RowId=""
	for{
		s RowId=$o(^RB("RES",0,"CTLOC",LocID,RowId)) q:RowId=""
		s CTCPDR=$p(^RB("RES",RowId),"^",2)
		continue:CTCPDR="" 
		continue:'$d(^CTPCP(CTCPDR,1))
		s ActiveFlag=##class(DHCDoc.DHCDocCure.Common).CheckActiveDoc(CTCPDR)
		continue:(ActiveFlag'="Y")
		s ResDesc=$p(^CTPCP(CTCPDR,1),"^",2)
		s ResDesc=##class(User.CTCareProv).GetTranByDesc("CTPCPDesc",ResDesc,langid)
		Do OutputResRow
	}
	Quit $$$OK
OutputResRow
	set Data=$lb($g(ResDesc),RowId,CTCPDR)
	set qHandle($I(ind))=Data
	quit
}

ClassMethod QueryResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryResourceExecute ]
{
 	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

Query FindCatList() As %Query(ROWSPEC = "ARCICRowId:%String,ARCICDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCatListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindCatList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s ARCICRowId=0
 	f  s ARCICRowId=$o(^ARC("IC",ARCICRowId)) q:ARCICRowId=""  d
 	.s ARCICDesc=$p(^ARC("IC",ARCICRowId),"^",2)
 	.s selected=0
 	.s DHCDocCureItemCatStr=$g(^DHCDocConfig("DHCDocCureItemCat"))
 	.s:("^"_DHCDocCureItemCatStr_"^")[("^"_ARCICRowId_"^") selected=1
	.Do OutputRowFindCatList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindCatList
	set Data=$lb($g(ARCICRowId),$g(ARCICDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindCatListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCatListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCatListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListExecute ]
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

ClassMethod FindCatListBroker()
{
	s qstr=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:FindCatList")
	If rset.QueryIsValid() { 
		Set Status=rset.Execute()
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s ARCICRowId=rset.Data("ARCICRowId")
			i ARCICRowId="" continue
			s ARCICDesc=rset.Data("ARCICDesc")
			s selected=rset.Data("selected")
			if qstr="" s qstr=ARCICRowId_$c(2)_ARCICDesc_$c(2)_selected
			else  s qstr=qstr_$c(1)_ARCICRowId_$c(2)_ARCICDesc_$c(2)_selected
		}
	}
	q qstr
}

ClassMethod FindLocListBroker(HospId As %String = "")
{
	s qstr=""
	Set rset=##Class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:FindLocList")
	If rset.QueryIsValid() { 
		;治疗常规设置-默认治疗科室需要跨院区，故此院区参数传空
		Set Status=rset.Execute("","")
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		While (rset.Next()) {
			s LocRowId=rset.Data("LocRowId")
			i LocRowId="" continue
			s LocDesc=rset.Data("LocDesc")
			s selected=rset.Data("selected")
			s selected=0
			s DHCDocCureLocStr=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureLocStr",HospId)
 			s:("^"_DHCDocCureLocStr_"^")[("^"_LocRowId_"^") selected=1
			if qstr="" s qstr=LocRowId_$c(2)_LocDesc_$c(2)_selected
			else  s qstr=qstr_$c(1)_LocRowId_$c(2)_LocDesc_$c(2)_selected
		}
	}
	q qstr
}

Query FindLocList(desc As %String = "", HospId As %String = "") As %Query(ROWSPEC = "LocRowId:%String,LocDesc:%String,selected:%Boolean,LocCode:%String")
{
}

ClassMethod FindLocListExecute(ByRef qHandle As %Binary, desc As %String = "", HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindLocList")
	Set repid=$I(^CacheTemp)
	k ^TMP($J,"DocCureFindLocList")
    Set ind=1
    s Desc="" f  s Desc=$o(^CTLOC(0,"Desc",Desc)) q:Desc=""  d
    .s LocRowId=0 f  s LocRowId=$o(^CTLOC(0,"Desc",Desc,LocRowId)) q:LocRowId=""  d
 	..q:'$d(^CTLOC(LocRowId))
 	..s LocHospDr=$p(^CTLOC(LocRowId),"^",22)
	..Q:(LocHospDr'=HospId)&&(HospId'="")
	..s ActiveFlag=##class(DHCDoc.DHCDocCure.Common).CheckActiveLoc(LocRowId)
	..Q:(ActiveFlag'="Y")
	..s CTLOCType=$p(^CTLOC(LocRowId),"^",13)
    ..q:(CTLOCType'="E")&&(CTLOCType'="W")
 	..s LocDesc=$p(^CTLOC(LocRowId),"^",2)
 	..s selected=0
 	..s DHCDocCureLocStr=##class(web.DHCDocConfig).GetConfigNode("DHCDocCureLocStr",HospId)
 	..s:("^"_DHCDocCureLocStr_"^")[("^"_LocRowId_"^") selected=1
 	..s CTAliasTem=""
	..i $l(LocDesc,"-")>1 s CTAliasTem=$P(LocDesc,"-",1) s LocDesc=$P(LocDesc,"-",2)
	..s CTAlias=$P(^CTLOC(LocRowId),"^",43)
	..i CTAlias="" s CTAlias=CTAliasTem
	..Q:(desc'="")&&('##class(web.DHCOPAdmReg).CheckLocDesc(LocRowId,desc))
	..s CTLOCMarkNO=##class(web.DHCINSUPort).GetCNCODE(LocDesc,4,"") ;##class(web.DHCBL.BDP.BDPSort).GetSortNum("User.CTLoc","正式",LocRowId)
	..i CTLOCMarkNO="" s CTLOCMarkNO="999"
    ..s ^TMP($J,"DocCureFindLocList",CTLOCMarkNO,LocRowId)=LocDesc_"^"_selected_"^"_CTAlias //建立临时Globle
	..;Do OutputRowFindLocList
	//按照序号排序
	s seq="" for {
		s seq=$O(^TMP($j,"DocCureFindLocList",seq))
		Quit:seq=""
		s seq1="" for {
			s seq1=$O(^TMP($J,"DocCureFindLocList",seq,seq1))
			Quit:seq1=""
			s temp=^TMP($j,"DocCureFindLocList",seq,seq1)
			s CTRowId=seq1
			s CTDesc=$P(temp,"^",1)
			s selected=$P(temp,"^",2)
			s LocCode=$P(temp,"^",3)
			d OutputRowFindLocList		
		}
	}

	K ^TMP($J,"DocCureFindLocList")
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindLocList
	set Data=$lb($g(CTRowId),$g(CTDesc),$g(selected),$g(LocCode))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCatListExecute ]
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

Query FindCardType() As %Query(ROWSPEC = "CardTypeId:%String,CardTypeDesc:%String,selected:%Boolean")
{
}

ClassMethod FindCardTypeExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("web.DHCDocCureApp","FindCardType")
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s myTypeID=0 f  s myTypeID=$o(^DHCCARDTYPEDef(myTypeID)) q:(myTypeID="")  d
	.s mydes=$p(^DHCCARDTYPEDef(myTypeID),"^", 2)
	.s myActiveFlag=$p(^DHCCARDTYPEDef(myTypeID),"^", 11)		;CTD_ActiveFlag
	.q:(myActiveFlag'="IE")
	.s myDateTo=+$p(^DHCCARDTYPEDef(myTypeID),"^", 10)		;CTD_DateTo
	.q:((+myDateTo'=0)&(myDateTo<+$h))			;失效日
	.s myDefault=$p(^DHCCARDTYPEDef(myTypeID),"^", 8)
	.i myDefault="Y" s Default=1
	.else  s Default=0
	.Do OutputRowCardType
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowCardType
	Set Data=$lb(myTypeID,mydes,Default)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

ClassMethod FindCardTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCardTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindCardTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCardTypeExecute ]
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

ClassMethod GetPatientIDByNo(PatientNo As %String)
{
	s PatientID=""
	i (PatientNo'="") {
		s PatientID=$O(^PAPERi("PAPMI_PatNo",PatientNo,0))
	}
	Q PatientID
}

ClassMethod GetPatientIDByCardNo(CardNo As %String, cardType As %String = "")
{
	s NewPatientID=""
	i (CardNo'="") {
		s ExpStr=""_$c(2)_cardType_$C(2)_"PatInfo"
		s ret=##class(web.UDHCAccManageCLSIF).getaccinfofromcardno(CardNo,"",ExpStr)
		s retcode=$P(ret,"^",1)
		if (retcode="-201")!(retcode="0"){
			s NewPatientID=$P(ret,"^",8)
		}
	}
	Q NewPatientID
}

ClassMethod GetCardTypeInfo(myTypeID As %String) As %String
{
	Q:myTypeID="" ""
	Q $g(^DHCCARDTYPEDef(myTypeID))
}

/// Creator：      	nikang
/// CreatDate：    	2019-05-28
/// Description:	查询治疗分类
/// Table：        DHC_DocCureArcCat 
/// Others：       w ##class(DHCDoc.DHCDocCure.Config).QueryArcCat("10","1","")
ClassMethod QueryArcCat(rows As %String, page As %String, params As %String) As %String
{

	s end=page*rows
	s start=(page-1)*rows+1
	
	k DHCDocCureArr
	s code=$p(params,"^",1)
	s desc=$p(params,"^",2)
	s hospid=$p(params,"^",3)
	s h=0,count=0
	s acrowid=""
	f  s acrowid=$o(^DHCDocCureArcCat(acrowid)) q:acrowid=""  d
	.q:acrowid=0
	.s catcode=$p(^DHCDocCureArcCat(acrowid),"^",1)
	.s catdesc=$p(^DHCDocCureArcCat(acrowid),"^",2)
	.s HospDr=+$p(^DHCDocCureArcCat(acrowid),"^",3)
	.Q:(hospid'="")&&(hospid'=HospDr)
	.s HospDesc=""
	.s:HospDr'=0 HospDesc=$p(^CT("HOSP",HospDr),"^",2)
	.q:(code'="")&(catcode'[code)
	.q:(desc'="")&(catdesc'[desc)
	.s h=h+1
	.s tempstr=acrowid_"^"_catcode_"^"_catdesc_"^"_HospDesc_"^"_HospDr
	.s DHCDocCureArr(h)=tempstr
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonEmptySign(h))
		q Stream.Read()
	}
	
	///转换数据为Json格式
	s title="acrowid^catcode^catdesc^hospdesc^hospdr"
	d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonStartSign(h))
	s index=""
	f  s index=$o(DHCDocCureArr(index)) q:index=""  d
	.s mdate=$g(DHCDocCureArr(index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData(title,mdate))
	.e  d
	..d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData(title,mdate))
	d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonEndSign())
	q Stream.Read()
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Description:： 保存治疗分类
/// Table：        DHC_DocCureArcCat 
/// Others：       w ##class(DHCDoc.DHCDocCure.Config).SaveArcCat("52^21^224^3")
ClassMethod SaveArcCat(params As %String) As %String
{
	s ^tmpnk("SaveArcCat")=params
  	s Err=0
  	Ts
	s len=$L(params,"&&")
	f i=1:1:len q:Err'=0  d
	.s tmpstr=$p(params,"&&",i)
	.s Err=..CheckRepeat(tmpstr)
	.q:Err'=0
	.i $p(tmpstr,"^",1)'="" q:Err'=0  d
	..s Err=..UpdArcCat(tmpstr)
	.e  d
	..s Err=..AddArcCat(tmpstr)
	if 'Err{
		Tc	
	}else{
		Tro	
	}
	q Err
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Description:： 增加治疗分类表
/// Table：        DHC_DocCureArcCat 
/// Others：       w ##class(DHCDoc.DHCDocCure.Config).AddArcCat("^005^ds^CT")
ClassMethod AddArcCat(params As %String) As %String
{
	s catcode=$p(params,"^",2)     /// 分类代码
	s catdesc=$p(params,"^",3)	   /// 分类描述
	s hospDr=$p(params,"^",4)	   /// 医院ID
	&sql(insert into SqlUser.DHC_DocCureArcCat (DCAC_CatCode,DCAC_CatDesc,DCAC_Hosp_Dr) values (:catcode,:catdesc,:hospDr))
	q SQLCODE
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Description:： 更新治疗分类表
/// Table：        DHC_DocCureArcCat 
/// Others：       w ##class(DHCDoc.DHCDocCure.Config).UpdArcCat("1^001^ds^普通床位")
ClassMethod UpdArcCat(params As %String) As %String
{
	s acrowid=$p(params,"^",1)		/// 分类ID
	s catcode=$p(params,"^",2)		/// 分类代码
	s catdesc=$p(params,"^",3)		/// 分类描述
	s hospDr=$p(params,"^",4)		/// 医院ID
	&sql(update SqlUser.DHC_DocCureArcCat set DCAC_CatCode=:catcode,DCAC_CatDesc=:catdesc ,DCAC_Hosp_Dr=:hospDr where DCAC_RowID=:acrowid )
	q SQLCODE
}

/// CreatDate: 2019-05-28
/// Descript:  检查代码、描述是否重复
ClassMethod CheckRepeat(ItmTempStr As %String) As %String
{
	s ret=0
	s ID=$p(ItmTempStr,"^",1)   	///ID
	s ICode=$p(ItmTempStr,"^",2)   	///代码
	s IDesc=$p(ItmTempStr,"^",3)   	///描述
	s hospDr=$p(ItmTempStr,"^",4)		///医院ID
	i $d(^DHCDocCureArcCat(0,"Code",$$ALPHAUP^SSUTIL4(ICode))) d
	.s CatID=""
	.f  s CatID=$o(^DHCDocCureArcCat(0,"Code",$$ALPHAUP^SSUTIL4(ICode),CatID)) q:(CatID="")||(ret'=0)  d
	..Q:(ID'="")&&(CatID=ID)
	..s HospID=$p(^DHCDocCureArcCat(CatID),"^",3)
	..q:HospID'=hospDr
	..s ret=-1
	i $d(^DHCDocCureArcCat(0,"Desc",$$ALPHAUP^SSUTIL4(IDesc)))  d
	.s CatID=""
	.f  s CatID=$o(^DHCDocCureArcCat(0,"Desc",$$ALPHAUP^SSUTIL4(IDesc),CatID))  q:(CatID="")||(ret'=0)  d
	..Q:(ID'="")&&(CatID=ID)
	..s HospID=$p(^DHCDocCureArcCat(CatID),"^",3)
	..q:HospID'=hospDr
	..s ret=-2
	q ret
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Description:： 删除治疗分类表
/// Table：        DHC_DocCureArcCat 
/// thers：       w ##class(DHCDoc.DHCDocCure.Config).DelArcCat(2)
ClassMethod DelArcCat(params As %String) As %String
{
	s ret=0
	s ret=..isRelateCat(params)    		///  调用函数，判断分类是否关联医嘱子类
	q:ret'=0 ret
	&sql(delete from SqlUser.DHC_DocCureArcCat where DCAC_RowID=:params)
	q SQLCODE
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Descript : 判断分类是否关联医嘱子类
/// Input    : 分类ID
/// Return   : 0:不存在 ，其他:存在
/// Others   : w ##class(DHCDoc.DHCDocCure.Config).isRelateCat()
ClassMethod isRelateCat(CatRowId As %String) As %String
{
	s ret=0
	s ChildSub=$o(^DHCDocCureArcCat(CatRowId,"LIC",0))
	s:ChildSub'="" ret="-5"
	q ret
}

/// w ##class(DHCDoc.DHCDocCure.Config).jsonArcItemCat()
ClassMethod jsonArcItemCat(HospId As %String = "") As %String
{
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr = "SELECT ARCIC_RowId, ARCIC_Desc FROM Arc_ItemCat"
	s sqlStr = sqlStr_" Where ARCIC_OrderType not in ('L','R')"
    d result.Prepare(sqlStr)
	d result.Execute()
	s count = 0
	s Stream=##class(%Stream.GlobalCharacter).%New()
	d Stream.Write("[")
	
	While(result.Next())
	{	
		s RowID = result.Data("ARCIC_RowId")
		s Desc = result.Data("ARCIC_Desc")
		continue:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItemCat",RowID,HospId)="N"
		s tmp=RowID_"^"_Desc
		s count = count+1
		I count=1 d
		.d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData("value^text",tmp))
		e  d
		.d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData("value^text",tmp))
	}
	d Stream.Write("]")
	Q Stream.Read()
}

/// Descript   : 查询分类子表
/// Table      ：DHC_DocCureArcCatLinkItemCat
/// Input      : 分类ID
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).QueryCatLink(10,1,"") 
ClassMethod QueryCatLink(rows, page, CatRowId) As %String
{
	Q:CatRowId="" ##class(DHCDoc.DHCDocCure.Util).getJsonEmptySign(0)
	s end=page*rows
	s start=(page-1)*rows+1
	
	k DHCDocCureArr
	
	s h=0,count=0
	s ChildSub=0
	f  s ChildSub=$o(^DHCDocCureArcCat(CatRowId,"LIC",ChildSub)) q:ChildSub=""  d
	.s CatDr=+$p(^DHCDocCureArcCat(CatRowId,"LIC",ChildSub),"^",1)   /// 医嘱子类ID
	.s CatDesc=""
	.q:'$d(^ARC("IC",CatDr))
	.s:CatDr'=0 CatDesc=$p(^ARC("IC",CatDr),"^",2)        /// 医嘱子类描述
	.s CatLinkID=CatRowId_"||"_ChildSub					  /// 分类子表ID
	.s h=h+1
	.s tempstr=CatLinkID_"^"_CatDesc_"^"_CatDr
	.s DHCDocCureArr(h)=tempstr
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonEmptySign(h))
		q Stream.Read()
	}
	
	///转换数据为Json格式
	s title="CatLinkID^CatDesc^CatDr"
	d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonStartSign(h))
	s index=""
	f  s index=$o(DHCDocCureArr(index)) q:index=""  d
	.s mdate=$g(DHCDocCureArr(index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData(title,mdate))
	.e  d
	..d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData(title,mdate))
	d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonEndSign())
	q Stream.Read()
}

/// CreatDate  ：2019-05-29
/// Descript   : 保存分类子表
/// Table      ：DHC_DocCureArcCat,DHC_DocCureArcCatLinkItemCat
/// Input      : 子表ID^分类ID^医嘱子类描述^医嘱子类ID
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).SaveLIC("49||2^49^治疗介入^21^2")
ClassMethod SaveLIC(params As %String) As %String
{
	s ^tmpnk("SaveLIC")=params
  	s ret=0
  	Ts
	s len=$L(params,"&&")
	f i=1:1:len{
		q:ret'=0
		s tmpstr=$p(params,"&&",i)
		s ItemCatId=$p(tmpstr,"^",4)
		continue:ItemCatId=""
		s ItemCatDesc=$p(^ARC("IC",ItemCatId),"^",2)
		s ret=..isExistSamearcCat(tmpstr)    /// 判断相同的分类，是否关联相同的医嘱子类
		if (ret'=0){
			s ret=ret_"^["_ItemCatDesc_"]已关联相同分类，请重新选择！"	
		}else{
			i $p(tmpstr,"^",1)'=""{
				s ret=..UpdCatLink(tmpstr)
			}else{
				s ret=..SaveCatLink(tmpstr)
			}
			if (ret'=0){
				s ret=ret_"^["_ItemCatDesc_"]保存失败,错误代码:"_ret	
			}
		}
	}
	if ret=0{
		Tc	
	}else{
		Tro	
	}
	q ret
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Descript   : 判断相同的分类，是否关联相同的医嘱子类
/// Table      ：DHC_DocCureArcCat,DHC_DocCureArcCatLinkItemCat
/// Input      : 子表ID^分类ID^医嘱子类描述^医嘱子类ID
/// Return     : 0:不存在 ，其他：存在
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).isExistSamearcCat("^1^胆道镜^116")
ClassMethod isExistSamearcCat(tmpstr As %String) As %String
{
	s ret=0
	s DCACRowID=$p(tmpstr,"^",1) //表DHC_DocCureArcCat的Rowid
	s arcId=$p(tmpstr,"^",4)	 /// 医嘱子类ID
	s Hospdr=$p(tmpstr,"^",5)	 /// 医院ID
	s ExaCatID=0
	f  s ExaCatID=$o(^DHCDocCureArcCat(ExaCatID)) q:(ExaCatID="")||(ret'=0)  d
	.s HospID=$p(^DHCDocCureArcCat(ExaCatID),"^",3)	
	.q:HospID'=Hospdr
	.s ChildSub=0
	.f  s ChildSub=$o(^DHCDocCureArcCat(ExaCatID,"LIC",ChildSub)) q:(ChildSub="")||(ret'=0)  d
	..Q:(DCACRowID'="")&&(DCACRowID=(ExaCatID_"||"_ChildSub))
	..s OrdCatDr=$p(^DHCDocCureArcCat(ExaCatID,"LIC",ChildSub),"^",1)  /// 医嘱子类ID
	..q:arcId'=OrdCatDr
	..s ret="-11"
	q ret
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Descript   : 保存分类子表
/// Table      ：DHC_DocCureArcCatLinkItemCat
/// Input      : 子表ID^分类ID^医嘱子类描述^医嘱子类ID
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).SaveCatLink(1,115)
ClassMethod SaveCatLink(params As %String) As %String
{
	s ItmID=$p(params,"^",2)		/// 分类ID
	s CatLinkDr=$p(params,"^",4)	/// 医嘱子类ID
	&sql(insert into SqlUser.DHC_DocCureArcCatLinkItemCat(DCACLIC_ParRef,DCACLIC_ItemCat_Dr) values(:ItmID,:CatLinkDr))
	q SQLCODE
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Descript   : 更新分类子表
/// Table      ：DHC_DocCureArcCatLinkItemCat
/// Input      : 子表ID^分类ID^医嘱子类描述^医嘱子类ID
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).UpdCatLink()
ClassMethod UpdCatLink(params As %String) As %String
{
	s CatLinkID=$p(params,"^",1)	/// 子表ID
	s ItmID=$p(params,"^",2)		/// 分类ID
	s CatDr=$p(params,"^",4)		/// 医嘱子类ID
	&sql(update SqlUser.DHC_DocCureArcCatLinkItemCat set DCACLIC_ParRef=:ItmID,DCACLIC_ItemCat_Dr=:CatDr where DCACLIC_RowID=:CatLinkID )
	q SQLCODE
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Descript   : 删除分类子表
/// Table      ：DHC_DocCureArcCatLinkItemCat
/// Input      : 子表ID
ClassMethod DelCatLink(CatLinkId As %String) As %String
{
	&sql(delete from SqlUser.DHC_DocCureArcCatLinkItemCat where DCACLIC_RowID=:CatLinkId)
	q SQLCODE
}

/// Creator：      nikang
/// CreatDate：    2019-05-28
/// Description：  医嘱项别名检索
/// Table：        ARC_ItmMast ARC_Alias     
/// Others：       w ##Class(DHCDoc.DHCDocCure.Config).QueryArcItmDetail("100","1","wss",1,"")
ClassMethod QueryArcItmDetail(rows As %String, page As %String, Input As %String, HospID As %String, q As %String = "", NotShowARCOS As %String = "") As %String
{
	s ^tmpnk("QueryArcItmDetail")=Input_"^"_HospID_"^"_q
	i q'="" s Input=q
	i Input="" w ##class(web.DHCSTPHCMCOMMON).getJsonEmptySign(0)
	q:Input="" ""
	
	s Input="%"_$$ALPHAUP^SSUTIL4(Input)_"%"
	s result = ##class(%Library.ResultSet).%New()
	s sqlStr ="select distinct alias_arcim_dr,ALIAS_ARCOS_DR from arc_alias "_
    	"where %ALPHAUP(alias_text) like '"_Input_"' or  %ALPHAUP(ALIAS_Desc) like '"_Input_"'" 
    d result.Prepare(sqlStr)
    s sc=result.Execute()
    s err=$$$ISERR(sc)
    if $$$ISERR(sc) d DisplayError^%apiOBJ(sc) q ""
    
    K DHCDocCureArr
	s EndPage=page*rows 
	s StPage=((page-1)*rows)+1
    s Num = 0
    while(result.Next()){
	    s arcitemId = result.Data("ALIAS_ARCIM_DR")
	    s arcosId = result.Data("ALIAS_ARCOS_DR")
	    continue:(NotShowARCOS="Y")&&(arcosId'="")
	    if arcitemId'=""{
		    s itmmastid=$p(arcitemId,"||",1)
		    s itmmastver=$p(arcitemId,"||",2)
		    q:+itmmastver=0
	        continue:'$d(^ARCIM(itmmastid,itmmastver))
	        continue:##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("ARC_ItmMast",arcitemId,HospID)="N"
	        s arcEndDate=$p($g(^ARCIM(itmmastid,itmmastver,7)),"^",1)
			continue:(arcEndDate'="")&&(arcEndDate'>+$H)
			s arcitmcode=$p(^ARCIM(itmmastid,itmmastver,1),"^",1) //医嘱项代码
			s arcitmdesc=$p(^ARCIM(itmmastid,itmmastver,1),"^",2) //医嘱项名称
			s arcitmprice=##Class(web.UDHCJFPRICE).GetOrderPrice("","",arcitemId,+$h,"","","","",HospID)
			s arcitmprice=+$p(arcitmprice,"^") 					//医嘱项价格
			i $p(arcitmprice,".")="" s arcitmprice=0_arcitmprice  //小于0的价格前补0
			s ServerMaterial=$p($g(^ARCIM(itmmastid,itmmastver,7)),"^",6)
			//continue:(ServerMaterial'="Service")&(ServerMaterial'="S")
			s arcitmCat=$p($g(^ARCIM(itmmastid,itmmastver,1)),"^",10)
			s arcitmCat=$p(^ARC("IC",arcitmCat),"^",2)
	        s ListData = arcitemId_"^"_arcitmcode_"^"_arcitmdesc_"^"_arcitmprice_"^"_arcitmCat_"^"_"ARCIM"
	    }
	    if arcosId'=""{
		    &SQL(SELECT ARCOS_RowId,ARCOS_Desc,ARCOS_Code,ARCOS_LabTrakTestSet,ARCOS_DefPriority_DR,ARCOS_DurationDR,ARCOS_FrequencyDR,ARCOS_OrdCat_DR,ARCOS_OrdSubCat_DR->ARCIC_Desc,
		    	   SQLUser.DHC_UserFavItems.Fav_UseHosp_Dr
			       INTO :rowid,:desc,:code,:labsetrowid,:prior,:durrowid,:freqcode,:ordcatid,:subcatdesc,
			       :FavUseHospDr
			       FROM SQLUser.ARC_OrdSets,SQLUser.DHC_UserFavItems 
			       WHERE SQLUser.ARC_OrdSets.ARCOS_RowId=:arcosId and SQLUser.ARC_OrdSets.ARCOS_Rowid=SQLUser.DHC_UserFavItems.Fav_ItemRowid)
			i 'SQLCODE{
				continue:(HospID'="")&&($g(FavUseHospDr)'="")&&(HospID'=$g(FavUseHospDr))
				s HosipitalStr=##class(web.DHCDocOrderEntry).ArcosCanUserHosipital(+arcosId)
				continue:(HosipitalStr'="")&&(("^"_HosipitalStr_"^")'[("^"_HospID_"^"))
				Set ARCOSEffDateTo=$p($g(^ARCOS(+arcosId)),"^",16) 	
		 		continue:(ARCOSEffDateTo'="")&&(ARCOSEffDateTo<+$h)
			    s retval=$$getOSItemIDs(arcosId)
			    s OSItemIDs=$p(retval,$C(4),1)
				s OSPrice=$fn($p(retval,$C(4),2),"",4)
			}else{
				continue	
			}
		    s ListData = arcosId_"^"_code_"^"_desc_"^"_OSPrice_"^"_subcatdesc_"^"_"ARCOS"
		}
        s Num=Num+1
		s DHCDocCureArr(Num)=ListData
    }
  	i Num="0" w ##class(DHCDoc.DHCDocCure.Util).getJsonEmptySign(0)
	q:Num="0" ""

	s maxrow=Num
	i EndPage>maxrow S EndPage=maxrow
	
	s ListTitle="itmID^itmCode^itmDesc^itmPrice^itmCat"
	w ##class(DHCDoc.DHCDocCure.Util).getJsonStartSign(Num)

	s quitflag=0
	s Num=0
	s index=""
	f  s index=$o(DHCDocCureArr(index)) q:(index="")||(quitflag=1)  d
	.s ListData=DHCDocCureArr(index)
	.s Num=Num+1
	.q:Num<StPage
	.s:Num=EndPage quitflag=1
	.i Num=StPage d
	..w ##class(DHCDoc.DHCDocCure.Util).getJsonData(ListTitle,ListData)
	.else  d
	..w ","_##class(DHCDoc.DHCDocCure.Util).getJsonData(ListTitle,ListData)
	
	w ##class(DHCDoc.DHCDocCure.Util).getJsonEndSign()
	q ""
getOSItemIDs(ARCOSRowid)
	do ##class(web.DHCDocOrderEntry).OpenGetAllOrderSetItem(ARCOSRowid)
	s n=0,ARCOSPrice=0
	s OSItemIDs=""
	s SttDate=+$h
	s PatType="",InsType="",PriorRowid="",InstrRowid="",LinkTo="",OEPrice=""
	s count=0  f  s count=$o(^CacheTemp("ARCOI",$j,count)) q:count=""  d 
	.s item=0 f  s item=$o(^CacheTemp("ARCOI",$j,count,item)) q:item=""  s s=^(item) d
	..s ARCIMRowid=$p(s,"^",1)
	..s ARCOSItemQty=$p(s,"^",2)
	..s ARCIMDesc=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),1)),"^",2)
	..s retPrice=##class(web.DHCDocOrderEntry).GetOrderPrice(PatType, InsType, ARCIMRowid, SttDate, PriorRowid, InstrRowid, LinkTo, OEPrice)
	..;w retPrice,!
	..s Price=$P(retPrice,"^",1)
	..s ARCOSPrice=ARCOSPrice+$fn(Price*ARCOSItemQty,"",4)
	..s n=n+1
	..i n=1  s OSItemIDs=ARCIMRowid_$C(14)_ARCIMDesc
	..e  s OSItemIDs=OSItemIDs_$C(12)_ARCIMRowid_$C(14)_ARCIMDesc
	i OSItemIDs'="" s OSItemIDs=OSItemIDs_$C(4)_ARCOSPrice
	q OSItemIDs
}

/// Creator    ：nikang
/// CreatDate  ：2019-05-28
/// Descript   : 查询关联医嘱项子表
/// Table      ：DHC_DocCureArcCatLinkItemMast
/// Input      : 子表id
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).QueryCatLinkArcItm(10,1,49) 
ClassMethod QueryCatLinkArcItm(rows, page, ArcCatId) As %String
{
	Q:ArcCatId="" ##class(DHCDoc.DHCDocCure.Util).getJsonEmptySign(0)
	s end=page*rows
	s start=(page-1)*rows+1
	
	k DHCDocCureArr
	s h=0,count=0
	s ChildSub=0
	f  s ChildSub=$o(^DHCDocCureArcCat(ArcCatId,"LIM",ChildSub)) q:ChildSub=""  d
	.s AcRowId=ArcCatId_"||"_ChildSub
	.s ArcDr=$p(^DHCDocCureArcCat(ArcCatId,"LIM",ChildSub),"^",1)
	.if $l(ArcDr,"||")>1 d
	..s ArcimSub=$p(ArcDr,"||",1)
	..s ArcimVer=$p(ArcDr,"||",2)
	..s ArcDesc=$p($g(^ARCIM(ArcimSub,ArcimVer,1)),"^",2)
	..s ArcCode=$p($g(^ARCIM(ArcimSub,ArcimVer,1)),"^",1)
	.else  d
	..s ArcCode=$p($g(^ARCOS(ArcDr)),"^",1)
	..s ArcDesc=$p($g(^ARCOS(ArcDr)),"^",2)
	.Q:ArcDesc=""
	.s h=h+1
	.s tempstr=AcRowId_"^"_ArcDr_"^"_ArcCode_"^"_ArcDesc
	.s DHCDocCureArr(h)=tempstr
	
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonEmptySign(h))
		q Stream.Read()
	}
	
	///转换数据为Json格式
	s title="CatLinkID^ArcDr^ArcCode^ArcDesc"
	d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonStartSign(h))
	s index=""
	f  s index=$o(DHCDocCureArr(index)) q:index=""  d
	.s mdata=$g(DHCDocCureArr(index))
	.s count = count+1
	.q:(count<start)||(count>end)
	.i count=start d
	..d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData(title,mdata))
	.e  d
	..d Stream.Write(","_##class(DHCDoc.DHCDocCure.Util).getJsonData(title,mdata))
	d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonEndSign())
	q Stream.Read()
}

/// Creator    ：nikang
/// CreatDate  ：2019-05-28
/// Descript   : 判断相同的分类，是否关联相同的医嘱项
/// Table      ：DHC_DocCureArcCat,DHC_DocCureArcCatLinkItemMast
/// Input      : 分类关联医嘱项子表id^医嘱项id^检查分类ID^冰冻标志
/// Return     : 0:不存在 ，其他：存在
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).isExistSamearcCat("^1^胆道镜^116")
ClassMethod isExistSameCatArcItm(tmpstr As %String) As %String
{
	s ret=0
	s ACRowID=$p(tmpstr,"^",1)
	s ArcID=$p(tmpstr,"^",2)	 /// 医嘱项id
	s CatID=$p(tmpstr,"^",3)	 /// 医嘱分类id
	s Hospdr=$p(tmpstr,"^",4)	 /// 医院ID
	q:CatID="" 0

	s ExaCatID=0
	f  s ExaCatID=$o(^DHCDocCureArcCat(ExaCatID)) q:(ExaCatID="")||(ret'=0)  d
	.s HospID=$p(^DHCDocCureArcCat(ExaCatID),"^",3)	
	.q:HospID'=Hospdr
	.s ChildSub=0
	.f  s ChildSub=$o(^DHCDocCureArcCat(ExaCatID,"LIM",ChildSub)) q:(ChildSub="")||(ret'=0)  d
	..s tmpArcID=$p(^DHCDocCureArcCat(ExaCatID,"LIM",ChildSub),"^",1)
	..q:tmpArcID'=ArcID
	..s tmpACRowID=ExaCatID_"||"_ChildSub
	..Q:(ACRowID'="")&&(ACRowID=tmpACRowID)
	..Q:(ACRowID="")&&(CatID'=ExaCatID)
	..s ret="-11"
	q ret
}

/// Creator    ：nikang
/// CreatDate  ：2019-05-28
/// Descript   : 保存医嘱项子表
/// Table      ：DHC_DocCureArcCat,DHC_DocCureArcCatLinkItemMast
/// Input      : 分类关联医嘱项子表id^医嘱项id^检查分类ID
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).SaveLinkArc("^404||1^1^Y")
ClassMethod SaveLinkArc(params As %String) As %String
{
	s ^tmpnk("SaveLinkArc")=params
	Ts
  	s ret=0
	s len=$L(params,"&&")
	for i=1:1:len{
		q:ret'=0
		s tmpstr=$p(params,"&&",i)
		s LinkRowid=$p(tmpstr,"^",2)
		continue:LinkRowid=""
		if $l(LinkRowid,"||")>1{
			s LinkDesc=$p($g(^ARCIM(+LinkRowid,$p(LinkRowid,"||",2),1)),"^",2)
		}else{
			s LinkDesc=$p(^ARCOS(LinkRowid),"^",2)	
		}
		s ret=..isExistSameCatArcItm(tmpstr)    /// 判断相同的分类，是否关联相同的医嘱项
		if (ret'=0){
			s ret=ret_"^["_LinkDesc_"]已关联相同分类，请重新选择！"	
		}else{
			i $p(tmpstr,"^",1)'=""{
				s ret=..UpdLinkArcItm(tmpstr)
			}else{
				s ret=..SaveLinkArcItm(tmpstr)
			}
			if (ret'=0){
				s ret=ret_"^["_LinkDesc_"]保存失败,错误代码:"_ret	
			}
		}
	}
	if ret=0{
		Tc	
	}else{
		Tro	
	}
	q ret
}

/// Creator    ：nikang
/// CreatDate  ：2019-05-28
/// Descript   : 保存关联医嘱项子表
/// Table      ：DHC_DocCureArcCatLinkItemMast
/// Input      : 分类关联医嘱项子表id^医嘱项id^检查分类ID^冰冻标志
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).SaveLinkArcItm("^404||1^1^Y")
ClassMethod SaveLinkArcItm(params As %String) As %String
{
	s arcItm=$p(params,"^",2)		/// 医嘱项id
	s catID=$p(params,"^",3)		/// 分类ID
	&sql(insert into SqlUser.DHC_DocCureArcCatLinkItemMast(DCACLIM_ParRef,DCACLIM_ArcItm_Dr) values(:catID,:arcItm))
	q SQLCODE
}

/// Creator    ：nikang
/// CreatDate  ：2019-05-28
/// Descript   : 更新关联医嘱项子表
/// Table      ：DHC_DocCureArcCatLinkItemMast
/// Input      : 分类关联医嘱项子表id^医嘱项id^检查分类ID^冰冻标志
/// Return     : 0:保存成功 ，其他：保存失败
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).UpdLinkArcItm("1||1^404||1^1^Y")
ClassMethod UpdLinkArcItm(params As %String) As %String
{
	s acRowID=$p(params,"^",1)
	s arcItm=$p(params,"^",2)		/// 医嘱项id
	s catID=$p(params,"^",3)		/// 分类ID
	&sql(update SqlUser.DHC_DocCureArcCatLinkItemMast set DCACLIM_ParRef=:catID,DCACLIM_ArcItm_Dr=:arcItm where DCACLIM_RowID=:acRowID )
	q SQLCODE
}

/// Creator    ：nikang
/// CreatDate  ：2019-05-28
/// Descript   : 删除分类子表
/// Table      ：DHC_DocCureArcCatLinkItemMast
/// Input      : 子表ID
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).DelCatLinkArcItm("1||1")
ClassMethod DelCatLinkArcItm(AcRowId As %String) As %String
{
	s ArcimRowId=$p(^DHCDocCureArcCat(+AcRowId,"LIM",$p(AcRowId,"||",2)),"^",1)
	&sql(delete from SqlUser.DHC_DocCureArcCatLinkItemMast where DCACLIM_RowID=:AcRowId)
	if ('SQLCODE) {
		&sql(update SqlUser.DHC_DocCureItemSet set DDCIS_Active='N' where DDCIS_ItmMast_DR=:ArcimRowId)
	}
	q SQLCODE
}

/// Creator    ：nikang
/// CreatDate  ：2019-05-29
/// Descript   : 删除分类子表
/// Table      ：DHC_DocCureArcCatLinkItemCat_Loc DHC_DocCureArcCatLinkItemMast_Loc
/// Input      : 
/// Others     ：w ##class(DHCDoc.DHCDocCure.Config).insertArcCatLoc("1||11",44,"CAT")
ClassMethod insertArcCatLoc(MainID As %String, CureLocRowID As %String, Type As %String)
{
	s ^tmpnk("insertLinkLoc")=MainID_"^"_CureLocRowID_"^"_Type
	if MainID="" q "-100"
	if CureLocRowID="" q "-100"
	if '$d(^CTLOC(+CureLocRowID))||(+CureLocRowID=0) q "-2"
	if Type="CAT"{
		if $d(^DHCDocCureArcCat(0,"LICCATLOC",+MainID,$P(MainID,"||",2),CureLocRowID)) q "-1"
		s obj=##class(User.DHCDocCureArcCatLinkItemCatLoc).%New(MainID)
		if $IsObject(obj){
			d obj.DCACLICLOCParRefSetObjectId(MainID)
			d obj.DCACLICLOCDeptDrSetObjectId(CureLocRowID)
			s sc=obj.%Save()
		    If $$$ISERR(sc) Quit "-102"
		    d obj.%Close()
		}
	}elseif Type="ITEM"{
		if $d(^DHCDocCureArcCat(0,"LIMMASTLOC",+MainID,$P(MainID,"||",2),CureLocRowID)) q "-1"
		s obj=##class(User.DHCDocCureArcCatLinkItemMastLoc).%New(MainID)
			if $IsObject(obj){
			d obj.DCACLIMLOCParRefSetObjectId(MainID)
			d obj.DCACLIMLOCDeptDrSetObjectId(CureLocRowID)
			s sc=obj.%Save()
		    d obj.%Close()
		    If $$$ISERR(sc) Quit "-102"
		}
	}
	
	Q 0
}

ClassMethod deleteArcCatLoc(RowID As %String, Type As %String) As %String
{
	if RowID="" q "-100"
	if Type="CAT"{
		&sql(delete SqlUser.DHC_DocCureArcCatLinkItemCat_Loc where DCACLICLOC_RowID=:RowID)
	}else{
		&sql(delete SqlUser.DHC_DocCureArcCatLinkItemMast_Loc where DCACLIMLOC_RowID=:RowID)	
	}
	Q SQLCODE
}

Query FindArcCatCureLoc(Type As %String, RowID As %String) As %Query(ROWSPEC = "RowID:%String,CureLocRowID:%String,LocDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindCureLinkLoc","44")
ClassMethod FindArcCatCureLocExecute(ByRef QHandle As %Binary, Type As %String, RowID As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ^tmpnk("FindArcCatCureLoc")=Type_"&"_RowID
	s ind=1
	if (RowID=""){
		Set QHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	if Type="CAT"{
		s Child=0
		for {
			s Child=$o(^DHCDocCureArcCat(+RowID,"LIC",$P(RowID,"||",2),"L",Child))  Q:Child=""
			s ID=RowID_"||"_Child
			s DeptDr=$p(^DHCDocCureArcCat(+RowID,"LIC",$P(RowID,"||",2),"L",Child),"^",1)
			continue:DeptDr=""
			s CTDesc=$p($g(^CTLOC(DeptDr)),"^",2)
			s CTDesc=$ZCVT(CTDesc,"U")
			Do OutputRowArcCatCureLoc
		}
	}elseif Type="ITEM"{
		s Child=0
		for {
			s Child=$o(^DHCDocCureArcCat(+RowID,"LIM",$P(RowID,"||",2),"L",Child))  Q:Child=""
			s ID=RowID_"||"_Child
			s DeptDr=$p(^DHCDocCureArcCat(+RowID,"LIM",$P(RowID,"||",2),"L",Child),"^",1)
			continue:DeptDr=""
			s CTDesc=$p($g(^CTLOC(DeptDr)),"^",2)
			s CTDesc=$ZCVT(CTDesc,"U")
			Do OutputRowArcCatCureLoc
		}
	}
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowArcCatCureLoc
	set Data=$lb(ID,DeptDr,CTDesc)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindArcCatCureLocClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindArcCatCureLocExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindArcCatCureLocFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindArcCatCureLocExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetDoseStr(itemrowid As %String, PackUOMRowid As %String = "", DoseQty As %String = "", DosUOMRowid As %String = "", HospID As %String = "")
{
	s OrderDoseStr=""
	s OrderType=""
	s ItemCatDr=$P(^ARCIM(+itemrowid,$P(itemrowid,"||",2),1),"^",10) 
	s:ItemCatDr'="" OrderType=$P(^ARC("IC",ItemCatDr),"^",7)
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(itemrowid)
	s PHUseEqQty=##Class(web.DHCDocConfig).GetConfigNode("PHUseEqQty",HospID)
	if (DrgformRowid'=""){
		s PHCDRowid=$P(DrgformRowid,"||",1)
	  	s ChildSub=$P(DrgformRowid,"||",2)
		s FormDoseQty=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",5) ;Pharmacy base UOM
		s FormDoseUOMRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,2)),"^",4)
		s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
		s OrderDoseStr=FormDoseQty_"#"_FormDoseUOMDesc_"#"_FormDoseUOMRowid
		s leq=0  f  s leq=$o(^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)) q:leq=""  d
		.s eqrec=^PHCD(PHCDRowid,"DF",ChildSub,"EQ",leq)
		.s FormDoseUOMRowid=$p(eqrec,"^"),eqqty=$p(eqrec,"^",2),eqdefaultqty=$p(eqrec,"^",3)
		.if eqdefaultqty'="" s FormDoseQty=eqdefaultqty
		.e  d
		..i PHUseEqQty=1 s FormDoseQty=eqqty
		..e  s FormDoseQty=""
		.s FormDoseUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(FormDoseUOMRowid)
		.i (FormDoseQty'="")&(FormDoseQty<1)&(FormDoseQty'=0) s FormDoseQty="0"_FormDoseQty
		.s OrderDoseStr=FormDoseQty_"#"_FormDoseUOMDesc_"#"_FormDoseUOMRowid_","_OrderDoseStr
	}
	if ((OrderType'="R")&&(PackUOMRowid="")){
		s PackUOMRowid=$p($g(^ARCIM(+itemrowid,$p(itemrowid,"||",2),8)),"^",14) 	
	}	
	if (OrderDoseStr="")&&(PackUOMRowid'=""){
		s PackUOMRowidDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(PackUOMRowid)
		s OrderDoseStr=""_"#"_PackUOMRowidDesc_"#"_PackUOMRowid
	}
	if DoseQty'=""{
		s DosUOMDesc=##class(web.DHCDocOrderCommon).GetUOMDesc(DosUOMRowid)
		s OrderDoseStr=DoseQty_"#"_DosUOMDesc_"#"_DosUOMRowid_","_OrderDoseStr
	}
	Q OrderDoseStr
}

Query GetCureItemTree(EpisodeID As %String, UserID As %String = "", GroupID As %String = "", LocID As %String = "", HospID As %String = "", QryArcDesc As %String = "", config As %String = "", queryall As %String = "", ApplyOrAss As %String = "") As %Query(ROWSPEC = "id:%String,pId:%String,name:%String,eleid:%String,RealStock:%String")
{
}

/// Description:治疗项目设置和治疗申请单界面查询治疗项目信息
/// Input:	config:空值-治疗申请界面展示激活的治疗医嘱项;非空-治疗医嘱项配置界面检索，显示治疗基础配置所有医嘱项
/// 		queryall:
/// 			(config:空值治疗申请界面)		"N"-需判断医嘱项权限
/// 			(config:非空治疗医嘱项配置界面)	"N"-仅展示已配置的治疗医嘱项(无论是否激活)
/// 		ApplyOrAss:CureAss查询评估项目，其他查询治疗项目
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","GetCureItemTree","1624","12175","29","113","2","zl","","","CureApply")
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","GetCureItemTree","","","","","2","","Y","N")
ClassMethod GetCureItemTreeExecute(ByRef QHandle As %Binary, EpisodeID As %String, UserID As %String = "", GroupID As %String = "", LocID As %String = "", HospID As %String = "", QryArcDesc As %String = "", config As %String = "", queryall As %String = "", ApplyOrAss As %String = "") As %Status
{
	s ^tmpnk("GetCureItemTree")=$lb(EpisodeID,UserID,GroupID,LocID,HospID,QryArcDesc,config,queryall,ApplyOrAss)
	s ind=0
	s i=1
	Set langid=20
    if ($d(%session)){
        set langid=+$g(%session.Data("LOGON.LANGID"))
    }
    s EpisodeType="",PatientID=""
	if EpisodeID'=""{
		s EpisodeType=$P($G(^PAADM(EpisodeID)),"^",2)
		s PatientID=$P(^PAADM(EpisodeID),"^",1)
    }
    if ApplyOrAss="CureAss"{
	    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
		;s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCureAssScale",HospID,+$H)
		s rset=##class(%ResultSet).%New("web.PilotProject.DHCDocPilotProject:FindDefineData")
		do rset.Execute("治疗工作站","治疗评定量表分类")
		s columns = rset.GetColumnCount()
		While (rset.Next()) {
			s DCASCatID=rset.GetData(3)
			s DCASCatCode=rset.GetData(2)
			s DCASCatDesc=rset.GetData(1)
			;continue:(ScaleCat'="")&&(ScaleCat'=DCASCatID)
			s tbidlen=2-$L(i)
	    	s tbidValue=$E("00",1,tbidlen)_i
	    	s tabname=DCASCatDesc
	    	s eleid=""
	    	s id=tbidValue
	    	s name=tabname
	    	s pId="0"
	    	s RealStock=""
	    	s ARCOSRowid="",ARCOSItemInfo=""
			do OutputRowCureItemTree
			s i=i+1
			s j=1
			s AssScaleID=0
			for{
				s AssScaleID=$o(^User.DHCDocCureAssScaleI("DCASCatIndex"," "_DCASCatID,AssScaleID))
				Q:AssScaleID=""
				s DCASHospID=$lg(^User.DHCDocCureAssScaleD(AssScaleID),6)
				s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureAssScale",AssScaleID,HospID)
				continue:HospShowDataFlag="N"
				s DCASCode=$lg(^User.DHCDocCureAssScaleD(AssScaleID),2)
				s DCASDesc=$lg(^User.DHCDocCureAssScaleD(AssScaleID),3)
				s nameId=DCASDesc
		        s idlen=2-$L(j)
			    s idValue=tbidValue_$E("00",1,idlen)_j
			    s j=j+1
			    s k=1
			    s AssScaleSetSub=0
			    for{
			    	s AssScaleSetSub=$o(^User.DHCDocCureAssScaleD(AssScaleID,"ChildDHCDocCureAssScaleSet",AssScaleSetSub)) Q:AssScaleSetSub=""
			    	s KeyType=$lg(^User.DHCDocCureAssScaleD(AssScaleID,"ChildDHCDocCureAssScaleSet",AssScaleSetSub),2)
			    	continue:KeyType'="ARCIM"
			    	s HospDr=$lg(^User.DHCDocCureAssScaleD(AssScaleID,"ChildDHCDocCureAssScaleSet",AssScaleSetSub),4)
					continue:(HospID'="")&&(HospDr'=HospID)
			    	s itemrowid=$lg(^User.DHCDocCureAssScaleD(AssScaleID,"ChildDHCDocCureAssScaleSet",AssScaleSetSub),3)
					s itemvalue="",arcdesc=""
			    	continue:$$CheckOutputRow(itemrowid)=0
			    	d GetOutputInfo
                    s itemlen=2-$L(k)
			        s itemValue=idValue_$E("0000",1,itemlen)_k
		            s eleid=itemvalue
					s id=itemValue
					s name=arcdesc
					s pId=idValue
					s k=k+1
					d OutputRowCureItemTree
			    }
			    i k>1{
				   	s eleid=AssScaleID
					s id=idValue
					s name=nameId
					s pId=tbidValue
					s RealStock="1"
					d OutputRowCureItemTree
				}
			}
		}
    }else{
		s ArcCatID=0
		for{
			s ArcCatID=$o(^DHCDocCureArcCat(ArcCatID)) Q:ArcCatID=""
			s ArcCatDesc=$p(^DHCDocCureArcCat(ArcCatID),"^",2)
			s ArcCatHosp=$p(^DHCDocCureArcCat(ArcCatID),"^",3)
			continue:(HospID'="")&&(HospID'=ArcCatHosp)
			s ArcCatDesc=##class(User.DHCDocCureArcCat).GetTranByDesc("DCACCatDesc",ArcCatDesc,langid)
			s tbidlen=2-$L(i)
	    	s tbidValue=$E("00",1,tbidlen)_i
	    	s tabname=ArcCatDesc
	    	s eleid=""
	    	s id=tbidValue
	    	s name=tabname
	    	s pId="0"
	    	s RealStock=""
	    	s ARCOSRowid="",ARCOSItemInfo=""
			do OutputRowCureItemTree
			s i=i+1
			s j=1
			s CatChildSub=0
			for {
				s CatChildSub=$o(^DHCDocCureArcCat(ArcCatID,"LIC",CatChildSub)) q:CatChildSub=""  d
				s ItemCatDr=+$p(^DHCDocCureArcCat(ArcCatID,"LIC",CatChildSub),"^",1)
				s ItemCatDesc=$p(^ARC("IC",ItemCatDr),"^",2)
				s ItemCatDesc=##class(User.ARCItemCat).GetTranByDesc("ARCICDesc",ItemCatDesc,langid)
				s nameId=ItemCatDesc
		        s idlen=2-$L(j)
			    s idValue=tbidValue_$E("00",1,idlen)_j
			    s j=j+1
			    s k=1
			    s ArcParSub=0
			    for{
			    	s ArcParSub=$o(^ARCIM(0,"ARCIC_DR",ItemCatDr,ArcParSub)) Q:ArcParSub=""
				    s ArcChildSub=0
				    for{
				    	s ArcChildSub=$o(^ARCIM(0,"ARCIC_DR",ItemCatDr,ArcParSub,ArcChildSub)) Q:ArcChildSub=""
				    	s itemvalue="",arcdesc=""
				    	s itemrowid=ArcParSub_"||"_ArcChildSub
				    	continue:$$CheckOutputRow(itemrowid)=0
				    	d GetOutputInfo
	                    s itemlen=2-$L(k)
				        s itemValue=idValue_$E("0000",1,itemlen)_k
			            s eleid=itemvalue
						s id=itemValue
						s name=arcdesc
						s pId=idValue
						s k=k+1
						d OutputRowCureItemTree
				    }
			    }
			    i k>1{
				   	s eleid=""
					s id=idValue
					s name=nameId
					s pId=tbidValue
					s RealStock=""
					d OutputRowCureItemTree
				}
			}
			s ArcChildSub=0
			for {
				s ArcChildSub=$o(^DHCDocCureArcCat(ArcCatID,"LIM",ArcChildSub)) q:ArcChildSub=""
				s ItemMastDr=$p(^DHCDocCureArcCat(ArcCatID,"LIM",ArcChildSub),"^",1)
				s itemvalue="",arcdesc=""
				s itemrowid=ItemMastDr
				if $l(itemrowid,"||")>1{
			    	continue:$$CheckOutputRow(itemrowid)=0
			    	d GetOutputInfo
		            s itemlen=4-$L(j)
			        s idValue=tbidValue_$E("0000",1,itemlen)_j
					s eleid=itemvalue
					s id=idValue
					s name=arcdesc
					s pId=tbidValue
					d OutputRowCureItemTree
					s j=j+1
				}else{
					s ARCOSRowid=itemrowid
					continue:$$CheckARCOSOutputRow(ARCOSRowid)=0
					s ItemCatDesc=$p(^ARCOS(ARCOSRowid),"^",2)
					s nameId=ItemCatDesc
			        s idlen=2-$L(j)
				    s idValue=tbidValue_$E("00",1,idlen)_j
				    s j=j+1
				    s k=1
				    
				    do OpenGetAllOrderSetItem(ARCOSRowid)
					s n=0,ARCOSPrice=0
					s OSItemIDs=""
					s count=0  
					f {
						s count=$o(CacheTemp("ARCOSItem",$j,count)) q:count=""
						s item=0
						f {
							s item=$o(CacheTemp("ARCOSItem",$j,count,item)) q:item=""  d
							s ARCOSItemInfo=CacheTemp("ARCOSItem",$j,count,item)
							s itemrowid=$p(ARCOSItemInfo,"^",1)
					    	continue:$$CheckOutputRow(itemrowid)=0
					    	d GetOutputInfo
		                    s itemlen=2-$L(k)
					        s itemValue=idValue_$E("0000",1,itemlen)_k
				            s eleid=itemvalue
							s id=itemValue
							s name=arcdesc
							s pId=idValue
							s k=k+1
							d OutputRowCureItemTree
					    }
				    }
				    i k>1{
					   	s eleid=""
						s id=idValue
						s name=nameId_"[医嘱套]"
						s pId=tbidValue
						s RealStock=""
						d OutputRowCureItemTree
					}
				}
			}
		}
    }
	
	Quit $$$OK
OutputRowCureItemTree
	s name=##class(web.DHCDocUtil).EvalJSON(name)
	s eleid=$REPLACE(eleid,$c(4),"^")
    s eleid=##class(web.DHCDocUtil).EvalJSON(eleid)
	s Data=$lb(id,pId,name,eleid,RealStock)
 	s QHandle($I(ind))=Data
	quit
OpenGetAllOrderSetItem(ARCOSRowid)
	K CacheTemp("ARCOSItem",$j)
	d GetAllOrderSetItem(ARCOSRowid)
	Q
GetAllOrderSetItem(ARCOSRowid)
	;n (ARCOSRowid)
	q:$g(ARCOSRowid)=""  
	s ARCOSDateRowid=##class(web.DHCDocOrderEntry).GetOrderSetDate(ARCOSRowid) 
	q:'ARCOSDateRowid  
	d GetOrderSetItem(ARCOSRowid,ARCOSDateRowid)
	;下面是调出医嘱套里的医嘱套?属于嵌套调用
	s tARCOSRowid=ARCOSRowid
	s it=0 
	for{
		s it=$o(^ARCOS(tARCOSRowid,"DATE",ARCOSDateRowid,"OS",it)) q:it=""
		s os=^(it)
		continue:(+os=tARCOSRowid)
		d GetAllOrderSetItem(+os)
	}
	Q 0
GetOrderSetItem(ARCOSRowid , ARCOSDateRowid)
	;n (ARCOSRowid , ARCOSDateRowid)
	s item=0 f  s item=$o(^ARCOS(ARCOSRowid,"DATE",ARCOSDateRowid,"ITM",item)) q:item=""  s s=^(item) d
	.s ARCIMRowid=$p(s,"^",1)
	.q:##class(web.DHCDocOrderEntry).ValARCItem(ARCIMRowid)
	.s ARCOSItemQty=$p(s,"^",2)
	.if ARCOSItemQty="" s ARCOSItemQty=1
	.s count=$o(^TMP("ARCOSItem",$j,""),-1)+1
	.s CacheTemp("ARCOSItem",$j,count,item)=s
	Q 0
CheckARCOSOutputRow(arcosrowid)
	if ##class(web.DHCDocOrderEntry).ValARCOS(arcosrowid)'=0{
		Q 0	
	}
	if config=""{
		s ValOrdFlag=##class(web.DHCDocOrderEntry).ValOrd("ARCOS",GroupID, arcosrowid, "", "", UserID,LocID,"","",PatientID)
		i ValOrdFlag=0{
			Q 0		
		}	
	}
	Q 1
GetOutputInfo
	s arcdesc=##class(web.DHCDocOrderCommon).GetFormateOrderName(itemrowid)
	s arcdesc=##class(User.ARCItmMast).GetTranByDesc("ARCIMDesc",arcdesc,langid)
	s ItemCatDr=$p(^ARCIM(+itemrowid,$p(itemrowid,"||",2),1),"^",10)
	s Baseuomdesc=""
	s FormDurRowid=""
	s ordertype=$P(^ARC("IC",ItemCatDr),"^",7)
	s inci=$o(^INCI(0,"ARCIM_DR",+itemrowid,""))
	if inci'="" {
		s baseuom=$p(^INCI(inci,1),"^",10)
		i baseuom'="" s Baseuomdesc=$P($g(^CT("UOM",baseuom)),"^",2)
	}
	s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(itemrowid,HospID)
	s PHPrescType=""
	s RealStock=0
	if config=""{
		;治疗申请界面按照库存显示
		i ordertype="R"{
			s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDr,HospID,itemrowid)
			i PHPrescType="" s PHPrescType="1"
	    	s RealStock=##Class(web.DHCDocOrderEntry).GetRealStock(EpisodeID,itemrowid) ;判断库存
		}else{
	    	s RealStock=1
	    	s PHPrescType=##class(web.DHCDocOrderCommon).GetPHPrescType(ItemCatDr,HospID,itemrowid)
		}
	}else{
		;治疗医嘱项配置界面按照是否为治疗医嘱（已配置且激活）显示
		if DDCISRowid'=""{
			s DDCISActive=$p(^DHCDocCureItemSet(DDCISRowid),"^",10)	
			if DDCISActive="Y" s RealStock=1
		}else{
			s RealStock=-1	
		}
	}
	
	s OrderDoseStr=""
	s FormDurDesc="",FormDurRowid="",FormDurFactor="1"
	s FormFreqDesc="",FormFreqRowid="",FormFreqFactor="1",FormFreqInterval="",FormFreqWeekFlag="",FreeTimeFreqFlag=""
	s DrgformRowid=##class(web.DHCDocOrderEntry).GetDrgForm(itemrowid)
	if (config=""){
		s osItemDurRowid="",osItemFreqRowid="",osItemDoseQty="",osItemDoseUOMRowid=""
		if ApplyOrAss="CureAss"{
			s ONCEFreqRowid=$O(^PHCFR(0,"Code","ONCE",0))
			i ONCEFreqRowid'="" s FormFreqRowid=ONCEFreqRowid
			s FormDurRowid=##Class(web.DHCDocConfig).GetConfigNode("IPDefaultDuration",HospID)
		}else{
			if $g(ARCOSItemInfo)'=""{
				s osItemQty=$p(ARCOSItemInfo,"^",2)
				s osItemDurRowid=$p(ARCOSItemInfo,"^",7)
				s osItemFreqRowid=$p(ARCOSItemInfo,"^",8)
				s osItemInstrRowid=$p(ARCOSItemInfo,"^",9)
				s osItemDoseUOMRowid=$p(ARCOSItemInfo,"^",10)
				s osItemDoseQty=$p(ARCOSItemInfo,"^",13)
				s osItemNO=$p(ARCOSItemInfo,"^",20)
				;s osItemBillUOMRowid=$p($g(^ARCIM(+ARCIMRowid,$p(ARCIMRowid,"||",2),8)),"^",14)
			}
			if (DrgformRowid'=""){
				s PHCDRowid=$P(DrgformRowid,"||",1)
			  	s ChildSub=$P(DrgformRowid,"||",2)
				s FormDurRowid=$p($g(^PHCD(PHCDRowid,"DF",ChildSub,1)),"^",8)
			}
			//取得可以录入频次疗程的非药品医嘱的默认设置
			if PHPrescType="4" {
				s FormFreqFactor=1
				s FormFreqRowid= $P($G(^ARC("IC",ItemCatDr,"DHC")),"^",3)
				i FormFreqRowid="" s FormFreqRowid=##class(web.DHCDocConfig).GetConfigNode("FrequencedItemFreq",HospID)
				i osItemFreqRowid'="" s FormFreqRowid=osItemFreqRowid
				if EpisodeType'="I" {
					s FormDurRowid=##class(web.DHCDocConfig).GetConfigNode("FrequencedItemDur",HospID)
				}
			}
			if (EpisodeType="I"){
				//住院默认一天
				s defFormDurRowid=##Class(web.DHCDocConfig).GetConfigNode("IPDefaultDuration",HospID)
				if (FormDurRowid'=defFormDurRowid){
					s FormDurRowid=defFormDurRowid
				}
			}elseif osItemDurRowid'=""{
				s FormDurRowid=osItemDurRowid
			}
		}
		s OrderDoseStr=..GetDoseStr(itemrowid,"",osItemDoseQty,osItemDoseUOMRowid,HospID)
	}
	i FormFreqRowid'="" {
		s FormFreqDesc=$P($g(^PHCFR(FormFreqRowid)),"^",3)
		s FormFreqFactor=$P($g(^PHCFR(FormFreqRowid)),"^",2)
		s FormFreqInterval=$P($g(^PHCFR(FormFreqRowid)),"^",5)
		s FormFreqWeekFlag=$P($g(^PHCFR(FormFreqRowid)),"^",9)
		s FreeTimeFreqFlag=$P(^PHCFR(FormFreqRowid),"^",13)
		s FormFreqDesc=##class(User.PHCFreq).GetTranByDesc("PHCFRDesc1",FormFreqDesc,langid)
	}
	i FormDurRowid'="" {
		s FormDurDesc=$P($g(^PHCDU(FormDurRowid)),"^",3)
		s FormDurFactor=$P($g(^PHCDU(FormDurRowid)),"^",2)
		s FormDurDesc=##class(User.PHCDuration).GetTranByDesc("PHCDUDesc1",FormDurDesc,langid)
	}
	if (ordertype="L")||(##class(web.DHCDocOrderCommon).GetItemServiceFlag(itemrowid)=1){
		s FormDurDesc="",FormDurRowid="",FormDurFactor=""
	}
	s DefDurStr=FormDurDesc_"#"_FormDurRowid_"#"_FormDurFactor
	s DefFreqStr=FormFreqDesc_"#"_FormFreqRowid_"#"_FormFreqFactor_"#"_FormFreqInterval_"#"_FormFreqWeekFlag_"#"_FreeTimeFreqFlag
	s INCIRowid=##class(web.DHCDocOrderEntry).GetINCI(+itemrowid)
	s PackUOMRowid=##Class(DHCDoc.DHCDocCure.Common).GetBillUOMRowID(itemrowid,EpisodeType)
	
	s ConFac=1	
	if (INCIRowid'="") {
		s ConFac=##class(web.DHCDocOrderEntry).GetConFac(itemrowid,INCIRowid,PackUOMRowid)
	}
	s DrugFormRowid=##class(web.DHCDocOrderEntry).GetDrgForm(itemrowid)
	s ARCOSItemInfo=$tr($g(ARCOSItemInfo),"^",$c(1))
	s itemvalue="ARCIM"_$C(4)_$g(ARCOSRowid)_$C(4)_itemrowid_$C(4,4,4,4)_Baseuomdesc_$C(4)_FormDurRowid_$C(4)_ordertype_$C(4,4,4,4,4,4,4,4)
	s itemvalue=itemvalue_$C(4)_DDCISRowid_$C(4)_PHPrescType_$C(4)_OrderDoseStr_$C(4)_arcdesc_$C(4)_DefDurStr_$C(4)_ConFac_$C(4)_DrugFormRowid
	s itemvalue=itemvalue_$C(4)_$g(ARCOSItemInfo)_$C(4)_$g(DefFreqStr)_$C(4)_$g(AssScaleID)
	Quit
CheckOutputRow(itemrowid)
	;独立医嘱
	s OrderOnItsOwn=$p($g(^ARCIM(+itemrowid,1,7)),"^",13)
	i OrderOnItsOwn'["Y"{
		Q 0		
	}
	
	if ##class(web.DHCDocOrderEntry).ValARCItem(itemrowid)'=0{
		Q 0	
	}
	if QryArcDesc'=""{
		s QryArcDesc=$$ALPHAUP^SSUTIL4(QryArcDesc)
		s arcdesc=##class(web.DHCDocOrderCommon).GetFormateOrderName(itemrowid)
		s PHCCDescPY=##class(web.DHCINSUPort).GetCNCODE(arcdesc,4,"")  ;返回汉字的编码信息
		if (QryArcDesc'="")&&(arcdesc'[QryArcDesc)&&(PHCCDescPY'[QryArcDesc){
			Q 0	
		}
	}
	
	s DDCISRowid=##class(DHCDoc.DHCDocCure.CureItemSet).GetDDCISIDByItem(itemrowid,HospID)
	if config=""{
		if ApplyOrAss'="CureAss"{
			if DDCISRowid=""{
				Q 0	
			}else{
				s DDCISActive=$p(^DHCDocCureItemSet(DDCISRowid),"^",10)	
				if DDCISActive'="Y"{
					Q 0	
				}
			}
		}
		if queryall="N"{
			;判断开医嘱/医嘱套权限
			s ValOrdFlag=##class(web.DHCDocOrderEntry).ValOrd("ARCIM",GroupID, itemrowid, "", "", UserID,LocID,"","",PatientID)
			i ValOrdFlag=0{
				Q 0		
			}
		}
	}else{
		if queryall="N"{
			if DDCISRowid=""{
				Q 0	
			}	
		}	
	}
	
	
	Q 1
}

ClassMethod GetCureItemTreeFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCureItemTreeExecute ]
{
	s ind=$O(QHandle(""))
	if ind{
		s Row=QHandle(ind)
		k QHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// d ##class(DHCDoc.DHCDocCure.Config).BuildMenuJson("^^^^^^Y")
ClassMethod BuildMenuJson(para As %String = "") As %String
{
	s ^tmpnk("BuildMenuJson")=para
	if para="" s para="^^^^^^Y"
	s EpisodeID=$p(para,"^",1)
	s UserID=$p(para,"^",2)
	s GroupID=$p(para,"^",3)
	s LocID=$p(para,"^",4)
	s Hospital=$p(para,"^",5)
	s QryArcDesc=$p(para,"^",6)
	s config=$p(para,"^",7)
	s queryall=$p(para,"^",8)
	s ApplyOrAss=$p(para,"^",9)
	s langid=$p(para,"^",10)
	if langid=""{
		s langid=20
	    if ($d(%session)){
	        set langid=+$g(%session.Data("LOGON.LANGID"))
	    }
	}
	Set rset=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:GetCureItemTree")
	do rset.Execute(EpisodeID,UserID,GroupID,LocID,Hospital,QryArcDesc,config,queryall,ApplyOrAss)
	Set columns = rset.GetColumnCount()
	set row=0
	While (rset.Next()) {
		set id=rset.GetData(1)
		set pId=rset.GetData(2)
		set name=rset.GetData(3)
		set eleid=rset.GetData(4)
		set RealStock=rset.GetData(5)
		set ^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId,id)=name_$c(3)_eleid_$c(3)_RealStock
	}
	
	s json=""
	if '$d(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson")){
		w "[]"
		q
	}
	Set Itemstream=##class(%Stream.GlobalCharacter).%New()
	do Itemstream.Rewind()
	do Itemstream.Write("[{")
	s pId="" 
	for  s pId=$o(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId)) q:pId=""  d
	.Q:$l(pId)>1
	.s ChildFlag=0
	.s Id=0
	.for  s Id=$o(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId,Id)) q:Id=""  d
	..;一级节点，治疗分类
	..s NodeValue=^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId,Id)
	..s name=$p(NodeValue,$c(3),1)
	..s name=$$ReplaceStr(name)
	..s eleid=$p(NodeValue,$c(3),2)
	..s eleid=$$ReplaceStr(eleid)
	..s RealStock=$p(NodeValue,$c(3),3)
	..s attributes=""
	..d Itemstream.Write(""""_"id"_""":"""_Id_""",")
	..d Itemstream.Write(""""_"text"_""":"""_name_""",")
	..d Itemstream.Write(""""_"RealStock"_""":"""_RealStock_""",")
	..d Itemstream.Write(""""_"eleid"_""":"""_eleid_""",")
	..d Itemstream.Write(""""_"attributes"_""":"""_attributes_"""")
	..s pId1=Id
	..s Id1=0
	..i $O(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId1,Id1))'="" d
	...s NodeState="open"
	...d Itemstream.Write(",")
	...d Itemstream.Write(""""_"state"_""":"""_NodeState_""",")
	...d Itemstream.Write(""""_"children"_""":[{" )
	...for  s Id1=$o(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId1,Id1)) q:Id1=""  d
	....;二级节点，治疗分类下子类及医嘱
	....s NodeValue=^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId1,Id1)
	....s name=$p(NodeValue,$c(3),1)
	....s name=$$ReplaceStr(name)
	....s eleid=$p(NodeValue,$c(3),2)
	....s eleid=$$ReplaceStr(eleid)
	....s RealStock=$p(NodeValue,$c(3),3)
	....s attributes=""
	....d Itemstream.Write(""""_"id"_""":"""_Id1_""",")
	....d Itemstream.Write(""""_"text"_""":"""_name_""",")
	....d Itemstream.Write(""""_"RealStock"_""":"""_RealStock_""",")
	....d Itemstream.Write(""""_"eleid"_""":"""_eleid_""",")
	....d Itemstream.Write(""""_"attributes"_""":"""_attributes_"""")
	....s pId2=Id1
	....s Id2=0
	....i $O(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId2,Id2))'="" d
	.....s NodeState="closed"
	.....if QryArcDesc'="" s NodeState="open"
	.....d Itemstream.Write(",")
	.....d Itemstream.Write(""""_"state"_""":"""_NodeState_""",")
	.....d Itemstream.Write(""""_"children"_""":[{" )
	.....for  s Id2=$o(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId2,Id2)) q:Id2=""  d
	......;三级节点，治疗子类下的医嘱项
	......s NodeValue=^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId2,Id2)
	......s name=$p(NodeValue,$c(3),1)
	......s name=$$ReplaceStr(name)
	......s eleid=$p(NodeValue,$c(3),2)
	......s eleid=$$ReplaceStr(eleid)
	......s RealStock=$p(NodeValue,$c(3),3)
	......s:+RealStock=0 attributes="{'color':'red'}"
	......d Itemstream.Write(""""_"id"_""":"""_$p(eleid,"^",3)_"^"_Id1_""",")
	......d Itemstream.Write(""""_"text"_""":"""_name_""",")
	......d Itemstream.Write(""""_"RealStock"_""":"""_RealStock_""",")
	......d Itemstream.Write(""""_"eleid"_""":"""_eleid_""",")
	......d Itemstream.Write(""""_"attributes"_""":"""_attributes_"""")
	......s Id2Nex=$O(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId2,Id2))
	......if Id2Nex'="" d
	.......d Itemstream.Write("},{")
	.....d Itemstream.Write("}]") 						
	.....s Id1Nex=$O(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId1,Id1))
	.....if Id1Nex'="" d
	......d Itemstream.Write("},{")
	....e  d
	.....s Id1Nex=$O(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId1,Id1))
	.....i Id1Nex'="" d
	......d Itemstream.Write("},{")
	.....e  
	......d Itemstream.Write("}")
	...d Itemstream.Write("}")	
	...s IdNex=$o(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId,Id))
	...i IdNex'="" d
	....d Itemstream.Write("]},{")
	...e  d
	....d Itemstream.Write("]")
	..e  d
	...s IdNex=$o(^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson",pId,Id))
	...i IdNex'="" d
	....d Itemstream.Write("},{")
	...e  
	....d Itemstream.Write("}")
	d Itemstream.Write("}]")
	k ^TMP($j,"DHCDoc.DHCDocCure.Config","BuildMenuJson")
	d Itemstream.Rewind()
	While (Itemstream.AtEnd = 0) 
	{
		Set len = 1024
		set json= Itemstream.Read(len)
		w json
	}	
	Q
ReplaceStr(instr)
	s outvalue=$replace(instr,"\","")
	s outvalue=$replace(outvalue,"'","")
	q outvalue
}

/// Creator：      nikang
/// CreatDate：    2020-12-02
/// Description:： 新增治疗人体部位表
/// Table：        DHC_DocCureBodyConfig 
/// Others：       w ##class(DHCDoc.DHCDocCure.Config).UpdArcCat("1^001^ds^普通床位")
ClassMethod SaveCureBody(BodyImageId As %String, params As %String) As %String
{
	s ^tmpnk("SaveCureBody")=$lb(BodyImageId,params)
	s ret=..CheckCureBody(BodyImageId,params)
	q:ret'=0 ret
	s BodyPointDesc=$p(params,"^",1)
	s BodyPointValue=$p(params,"^",2)
	s hospDr=$p(params,"^",3)
	&sql(insert into SqlUser.DHC_DocCureBodyConfig set 
		DDCBC_BodyImageId=:BodyImageId,
		DDCBC_BodyPointDesc=:BodyPointDesc ,
		DDCBC_BodyPointValue=:BodyPointValue)
	q SQLCODE
}

/// CreatDate: 2020-12-02
/// Descript:  检查治疗人体部位 描述是否重复
ClassMethod CheckCureBody(BodyImageId As %String, ItmTempStr As %String) As %String
{
	s ret=0
	s BodyPointDesc=$p(ItmTempStr,"^",1)
	s BodyPointValue=$p(ItmTempStr,"^",2)
	s hospDr=$p(ItmTempStr,"^",3)
	i $d(^DHCDocCureBCi(0,"ImageId",BodyImageId)) d
	.s CatID=""
	.f  s CatID=$o(^DHCDocCureBCi(0,"ImageId",BodyImageId,CatID)) q:(CatID="")||(ret'=0)  d
	..s PointDesc=$p(^DHCDocCureBC(CatID),"^",2)
	..q:PointDesc'=BodyPointDesc
	..s ret=-1
	
	q ret
}

/// Creator：      nikang
/// CreatDate：    2020-12-02
/// Description:： 删除治疗人体部位表
/// Table：        DHC_DocCureBodyConfig 
/// thers：       w ##class(DHCDoc.DHCDocCure.Config).DelCureBody(2)
ClassMethod DelCureBody(Id As %String) As %String
{
	s ret=0
	&sql(delete from SqlUser.DHC_DocCureBodyConfig where DDCBC_RowID=:Id)
	q SQLCODE
}

Query QueryCureBody(BodyImageId As %String = "", Sex As %String = "", BodySetStr As %String = "") As %Query(ROWSPEC = "Id:%String,BodyImageId:%String,BodyImage:%String,BodyPointDesc:%String,BodyPointValue:%String,BodyNote:%String")
{
}

/// Creator:nk
/// CreateDate:20200104
/// Desc:BodySetStr不为空，则根据保存过的部位信息展示；否则取配置部位信息
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","QueryCureBody","","女","背面$$$1$$$back-pic-diagonal-c0$$$1$$$4###正面$$$2$$$front-pic-diagonal-c1$$$2$$$5###正面$$$1$$$front-pic-diagonal-c0$$$3$$$6") 
ClassMethod QueryCureBodyExecute(ByRef qHandle As %Binary, BodyImageId As %String = "", Sex As %String = "", BodySetStr As %String = "") As %Status
{
	s ^tmpnk("QueryCureBody")=$lb(BodyImageId,Sex,BodySetStr)
	s BodyImage="",BodyPointDemo=""
	if BodySetStr'=""{
		s len=$l(BodySetStr,"###")
		for loop=1:1:len{
			s aBodySetStr=$p(BodySetStr,"###",loop)
			s BodyImage=$p(aBodySetStr,"$$$",1)
			s ID=$p(aBodySetStr,"$$$",2)
			s BodyImageId=$p(aBodySetStr,"$$$",3)
			s BodyPointDesc=$p(aBodySetStr,"$$$",4)
			s BodyPointDemo=$p(aBodySetStr,"$$$",5)
			s BodyPointValue=""
			d OutputCureBody
		}
	}
 	elseif BodyImageId'=""{
		i $d(^DHCDocCureBCi(0,"ImageId",BodyImageId)) d
		.s ID=""
		.f  s ID=$o(^DHCDocCureBCi(0,"ImageId",BodyImageId,ID)) q:(ID="")  d
		..s BodyImageId=$p(^DHCDocCureBC(ID),"^",1)
		..s BodyPointDesc=$p(^DHCDocCureBC(ID),"^",2)
		..s BodyPointValue=$p(^DHCDocCureBC(ID),"^",3)
		..d OutputCureBody
	}else{
		s ID=""
		f  s ID=$o(^DHCDocCureBC(ID)) q:(ID="")  d
		.s BodyImageId=$p(^DHCDocCureBC(ID),"^",1)
		.s BodyPointDesc=$p(^DHCDocCureBC(ID),"^",2)
		.s BodyPointValue=$p(^DHCDocCureBC(ID),"^",3)
		.d OutputCureBody
	}
 	Quit $$$OK
OutputCureBody
	set:BodyImage="" BodyImage=$case(BodyImageId,"male-front-pic":"男性正面图","male-back-pic":"男性背面图","female-front-pic":"女性正面图","female-back-pic":"女性背面图",:"")
	Q:(BodySetStr="")&&(Sex'="")&&(BodyImage'[Sex)
	set Data=$lb(ID,BodyImageId,BodyImage,BodyPointDesc,BodyPointValue,BodyPointDemo)
	set qHandle(BodyImageId,$I(ind))=Data
	quit
}

ClassMethod QueryCureBodyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryCureBodyExecute ]
{
	s Id=$O(qHandle(""))
	if Id'=""{
		s ind=$O(qHandle(Id,""))
		if ind'=""{
			s Row=qHandle(Id,ind)
			k qHandle(Id,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

/// Creator：      nikang
/// CreatDate：    2020-12-02
/// Description:： 查询治疗人体部位表
/// Table：        DHC_DocCureBodyConfig 
/// thers：       w ##class(DHCDoc.DHCDocCure.Config).GetCureBodyConfig("female-front-pic")
ClassMethod GetCureBodyConfig(BodyImageId As %String = "")
{
	s HtmlStr=""
	k BodyPointArr
	Set rs=##class(%ResultSet).%New("DHCDoc.DHCDocCure.Config:QueryCureBody")
	Set Status=0,h=0
	If rs.QueryIsValid() { 
		Set Status=rs.Execute(BodyImageId)
		If 'Status Quit
		While rs.Next() {	
			set ID=rs.GetData(1)
			set BodyImageId=rs.GetData(2)
			set BodyPointDesc=rs.GetData(4)
			set BodyPointValue=rs.GetData(5)
			set BodyPointValue=$tr(BodyPointValue,"@",",")
			set areaHtml="<area shape=""poly"" className=""area-body-img"" id=""BodyPoint_"_ID_""" coords="""_BodyPointValue_""" title="""_BodyPointDesc_""" alt="""_BodyPointDesc_""" href=""#""/></area>"
			if '$d(BodyPointArr(BodyImageId)){
				set BodyPointArr(BodyImageId)=areaHtml
			}else{
				set BodyPointArr(BodyImageId)=BodyPointArr(BodyImageId)_$c(13)_areaHtml
			}
			s h=h+1
			;if HtmlStr="" s HtmlStr=areaHtml
			;else  s HtmlStr=HtmlStr_$c(13)_areaHtml
		}
	}
	s Stream=##class(%Stream.GlobalCharacter).%New()
	i h=0{
		d Stream.Write("{}")
		q Stream.Read()
	}
	
	///转换数据为Json格式
	s title="",index=""
	f {
		s index=$o(BodyPointArr(index)) q:index=""
		s myIndex=$tr(index,"-","")
		if title="" s title=myIndex
		else  s title=title_"^"_myIndex
	}
	s index="",mdata=""
	f {
		s index=$o(BodyPointArr(index)) q:index=""
		if mdata="" s mdata=$g(BodyPointArr(index))
		else  s mdata=mdata_"^"_$g(BodyPointArr(index))
	}
	d Stream.Write(##class(DHCDoc.DHCDocCure.Util).getJsonData(title,mdata))
	q Stream.Read()
}

/// Creator：      nikang
/// CreatDate：    2022-08-02
/// Description:： 获取治疗参数配置表
/// Table：        DHC_DocCure_ConfigPara 
/// Others：       w ##class(DHCDoc.DHCDocCure.Config).GetCureConfigPara("CureDefRecordTemp",2)
ClassMethod GetCureConfigPara(CPCode As %String, CPHospID As %String)
{
	s ConfigPara=""
	i $d(^User.DHCDocCureConfigParaI("CPCodeIndex"," "_$$ALPHAUP^SSUTIL4(CPCode))) d
	s ID=""
	for{
		s ID=$o(^User.DHCDocCureConfigParaI("CPCodeIndex"," "_$$ALPHAUP^SSUTIL4(CPCode),ID))
		q:(ID="")
		s CPActive=$lg(^User.DHCDocCureConfigParaD(ID),6)
		continue:CPActive'="Y"
		s HospID=$lg(^User.DHCDocCureConfigParaD(ID),7)
		continue:HospID'=CPHospID
		s ConfigPara=$lg(^User.DHCDocCureConfigParaD(ID),4)
	}
	Q ConfigPara
}

/// Creator：      nikang
/// CreatDate：    2022-08-02
/// Description:： 新增治疗参数配置表
/// Table：        DHC_DocCure_ConfigPara 
/// Others：       w ##class(DHCDoc.DHCDocCure.Config).SaveCureConfigPara("")
ClassMethod SaveCureConfigPara(RowID As %String, params As %String) As %String
{

	s CPCode=$p(params,"^",1)
	s CPDesc=$p(params,"^",2)
	s CPValue=$p(params,"^",3)
	s CPNote=$p(params,"^",4)
	s CPActive=$p(params,"^",5)
	s CPHospID=$p(params,"^",6)
	
	s ret=0
	i $d(^User.DHCDocCureConfigParaI("CPCodeIndex"," "_$$ALPHAUP^SSUTIL4(CPCode))) d
	.s ID=""
	.f  s ID=$o(^User.DHCDocCureConfigParaI("CPCodeIndex"," "_$$ALPHAUP^SSUTIL4(CPCode),ID)) q:(ID="")||(ret'=0)  d
	..Q:(RowID'="")&&(ID=RowID)
	..s HospID=$lg(^User.DHCDocCureConfigParaD(ID),7)
	..q:HospID'=CPHospID
	..s ret=-1
	if ret'=0{
		Q ret	
	}
	
	K PLIST
	s PLIST(2)=CPCode
	s PLIST(3)=CPDesc
	s PLIST(4)=CPValue
	s PLIST(5)=CPNote
	s PLIST(6)=CPActive
	s PLIST(7)=CPHospID
	if RowID=""{
		&sql(insert into SqlUser.DHC_DocCure_ConfigPara values :PLIST())
	}else{
		&sql(update SqlUser.DHC_DocCure_ConfigPara values :PLIST() where ID=:RowID)	
	}
	q SQLCODE
}

Query FindCureConfigPara(Code As %String = "", HospID As %String = "") As %Query(ROWSPEC = "RowID:%String,CPCode:%String,CPDesc:%String,CPValue:%String,CPNote:%String,CPActive:%String,CPHospID:%String")
{
}

/// Creator:nk
/// CreateDate:20200104
/// Desc:BodySetStr不为空，则根据保存过的部位信息展示；否则取配置部位信息
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","QueryCureBody","","女","背面$$$1$$$back-pic-diagonal-c0$$$1$$$4###正面$$$2$$$front-pic-diagonal-c1$$$2$$$5###正面$$$1$$$front-pic-diagonal-c0$$$3$$$6") 
ClassMethod FindCureConfigParaExecute(ByRef qHandle As %Binary, Code As %String = "", HospID As %String = "") As %Status
{
	s ID=""
	for{
		s ID=$o(^User.DHCDocCureConfigParaD(ID))
		q:(ID="")
		s CPCode=$lg(^User.DHCDocCureConfigParaD(ID),2)
		s CPDesc=$lg(^User.DHCDocCureConfigParaD(ID),3)
		s CPValue=$lg(^User.DHCDocCureConfigParaD(ID),4)
		s CPNote=$lg(^User.DHCDocCureConfigParaD(ID),5)
		s CPActive=$lg(^User.DHCDocCureConfigParaD(ID),6)
		s CPHospID=$lg(^User.DHCDocCureConfigParaD(ID),7)
		continue:(HospID'="")&&(HospID'=CPHospID)
		d OutputCureCP
	}
 	Quit $$$OK
OutputCureCP
	set Data=$lb(ID,CPCode,CPDesc,CPValue,CPNote,CPActive,CPHospID)
	set qHandle(CPCode,$I(ind))=Data
	quit
}

ClassMethod FindCureConfigParaFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCureConfigParaExecute ]
{
	s Id=$O(qHandle(""))
	if Id'=""{
		s ind=$O(qHandle(Id,""))
		if ind'=""{
			s Row=qHandle(Id,ind)
			k qHandle(Id,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

ClassMethod insertCfg(MainID As %String, CfgType As %String, CfgValue As %String, Type As %String)
{
	s ^tmpnk("insertLinkLoc")=MainID_"^"_CfgType_"^"_CfgValue_"^"_Type
	if MainID="" q "-100"
	if (CfgType="")!(CfgValue="") q "-100"
	
	if Type="CAT"{
		if $d(^DHCDocCureArcCat(0,"LICCFG",+MainID,$P(MainID,"||",2),CfgType,CfgValue)) q "-1"
		s obj=##class(User.DHCDocCureArcCatLinkItemCatLoc).%New(MainID)
		if $IsObject(obj){
			d obj.DCACLICLOCParRefSetObjectId(MainID)
			s obj.DCACLICCfgType=CfgType
			s obj.DCACLICCfgValue=CfgValue
			s sc=obj.%Save()
		    If $$$ISERR(sc) Quit "-102"
		    d obj.%Close()
		}
	}elseif Type="ITEM"{
		if $d(^DHCDocCureArcCat(0,"LIMCFG",+MainID,$P(MainID,"||",2),CfgType,CfgValue)) q "-1"
		s obj=##class(User.DHCDocCureArcCatLinkItemMastLoc).%New(MainID)
			if $IsObject(obj){
			d obj.DCACLIMLOCParRefSetObjectId(MainID)
			s obj.DCACLIMCfgType=CfgType
			s obj.DCACLIMCfgValue=CfgValue
			s sc=obj.%Save()
		    d obj.%Close()
		    If $$$ISERR(sc) Quit "-102"
		}
	}
	
	Q 0
}

Query FindCfgInfo(Type As %String, RowID As %String, CfgType As %String) As %Query(ROWSPEC = "RowID:%String,TypeCode:%String,TypeDesc:%String,CfgValue:%String,CfgDesc:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindCureLinkLoc","44")
ClassMethod FindCfgInfoExecute(ByRef QHandle As %Binary, Type As %String, RowID As %String, CfgType As %String) As %Status
{
	if (RowID=""){
		Quit $$$OK
	}
	if Type="CAT"{
		s NodeName="LIC"
		d GetCfgInfo
	}elseif Type="ITEM"{
		s NodeName="LIM"
		d GetCfgInfo
	}
	Quit $$$OK
GetCfgInfo	
	s Child=0
	for {
		s Child=$o(^DHCDocCureArcCat(+RowID,NodeName,$P(RowID,"||",2),"L",Child))  Q:Child=""
		s ID=RowID_"||"_Child
		s gCfgType=$p(^DHCDocCureArcCat(+RowID,NodeName,$P(RowID,"||",2),"L",Child),"^",2)
		continue:("^"_CfgType_"^")'[("^"_gCfgType_"^")
		s CfgValue=$p(^DHCDocCureArcCat(+RowID,NodeName,$P(RowID,"||",2),"L",Child),"^",3)
		s CfgDesc=$case(gCfgType,"CP":$p($G(^CT("CPT",CfgValue)),"^",2),"U":$p($G(^SSU("SSUSR",CfgValue)),"^",2),:"")
		Do OutputRowCfgInfo
	}
	Quit
OutputRowCfgInfo
	s gCfgTypeDesc=$case(gCfgType,"CP":"医护人员类型","U":"用户",:"")
	set Data=$lb(ID,gCfgType,gCfgTypeDesc,CfgValue,CfgDesc)
	Set QHandle(gCfgType,$i(ind))=Data	
	quit
}

ClassMethod FindCfgInfoFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCfgInfoExecute ]
{
	s Id=$O(QHandle(""))
	if Id'=""{
		s ind=$O(QHandle(Id,""))
		if ind'=""{
			s Row=QHandle(Id,ind)
			k QHandle(Id,ind)
			Quit $$$OK
		}
	}
	s AtEnd=1
	Quit $$$OK
}

Query FindCfgVal(Type As %String, HospitalId As %String) As %Query(ROWSPEC = "RowId:%String,Desc:%String,Code:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.Config","FindCfgVal","T",2)
ClassMethod FindCfgValExecute(ByRef QHandle As %Binary, Type As %String, HospitalId As %String) As %Status
{
	if (Type=""){
		Quit $$$OK
	}
	if Type="CP"{
		s rs=##Class(%ResultSet).%New("web.DHCBL.CT.CTCarPrvTp:GetDataForCmb1")
		i rs.QueryIsValid() { 
			Set Status=rs.Execute("","","","","")
			If 'Status Quit
			While rs.Next() {
				s RowId=rs.GetDataByName("CTCPTRowId")
				s Desc=rs.GetDataByName("CTCPTDesc")
				s Code=rs.GetDataByName("CTCPTCode")
				Do OutputRowCfgVal
			}
		}
	}elseif Type="U"{
		s RowId=0
		for{
			s RowId=$o(^SSU("SSUSR",RowId)) q:RowId=""
			s ActiveFlag=##class(DHCDoc.DHCDocCure.Common).CheckActiveUser(RowId)
			continue:ActiveFlag'="Y"
			s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_User",RowId,HospitalId)
			continue:flag="N"
			s Desc=$p(^SSU("SSUSR",RowId),"^",2)
			s Code=$p(^SSU("SSUSR",RowId),"^",1)
			Do OutputRowCfgVal	
		}
	}
	Quit $$$OK
OutputRowCfgVal
	set Data=$lb(RowId,Desc,Code)
	Set QHandle($I(ind))=Data	
	quit
}

ClassMethod FindCfgValFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCfgValExecute ]
{
	s ind=$O(QHandle(""))
	if ind'=""{
		s Row=QHandle(ind)
		k QHandle(ind)
		Quit $$$OK
	}
	s AtEnd=1
	Quit $$$OK
}

/// CreatDate:    20220705
/// Description:  校验用户或医护人员类型是否符合治疗分类里医嘱子类、医嘱项维护的医护人员限制类型
/// Input:        OEOrderID:医嘱明细表RowId,	ArcimRowid：医嘱项ID,	UserID:用户ID
/// Return:       1:符合 0:不符合
/// Others:       w ##class(DHCDoc.DHCDocCure.Config).CheckCureCfgLimit("","5542||1",1,2)
ClassMethod CheckCureCfgLimit(OrderID = "", ArcimRowid = "", UserID As %String, HospID As %String)
{
	s Flag=1
	q:(OrderID="")&&(ArcimRowid="") Flag
	if (ArcimRowid=""){
		s ArcimRowid=$p($g(^OEORD(+OrderID,"I",$p(OrderID,"||",2),1)),"^",2)
	}
	s (CarePrvTpIDStr,CfgUserIDStr)=""
	if $d(^DHCDocCureArcCat(0,"LIMMAST1",ArcimRowid)){
		s NodeName="LIM"
		s ParRef="" 
		for{
			s ParRef=$o(^DHCDocCureArcCat(0,"LIMMAST1",ArcimRowid,ParRef)) Q:ParRef=""
			s ArcCatHosp=$p(^DHCDocCureArcCat(ParRef),"^",3)
			continue:(HospID'=ArcCatHosp)	
			s ChildSub=0
			for{
				s ChildSub=$o(^DHCDocCureArcCat(0,"LIMMAST1",ArcimRowid,ParRef,"I",ChildSub)) Q:ChildSub=""
				d GetCfgValue
			}
		}
	}
	if (CfgUserIDStr="")&&(CarePrvTpIDStr=""){
		s ItemCatRowid=$p(^ARCIM(+ArcimRowid,$p(ArcimRowid,"||",2),1),"^",10)
		if $d(^DHCDocCureArcCat(0,"LICCAT1",ItemCatRowid)){
			s NodeName="LIC"
			s ParRef="" 
			for{
				s ParRef=$o(^DHCDocCureArcCat(0,"LICCAT1",ItemCatRowid,ParRef)) Q:ParRef=""
				s ArcCatHosp=$p(^DHCDocCureArcCat(ParRef),"^",3)
				continue:(HospID'=ArcCatHosp)	
				s ChildSub=0
				for{
					s ChildSub=$o(^DHCDocCureArcCat(0,"LICCAT1",ItemCatRowid,ParRef,"I",ChildSub)) Q:ChildSub=""
					d GetCfgValue
				}
			}
		}	
	}	
	b ;未配置默认全部符合
	if (CfgUserIDStr="")&&(CarePrvTpIDStr=""){
		s Flag=1
	}else{
		s Flag=0
		if CfgUserIDStr'=""{
			if (("^"_CfgUserIDStr_"^")[("^"_UserID_"^")){
				s Flag=1
			}	
		}	
		if (Flag=0)&&(CarePrvTpIDStr'=""){
			s DoctorId=##class(web.SSUser).GetDefaultCareProvider(UserID)
			s CareProcTypeDr=""
			s:DoctorId'="" CareProcTypeDr=$p(^CTPCP(DoctorId,1),"^",4)
			if (CareProcTypeDr'="")&&(("^"_CarePrvTpIDStr_"^")[("^"_CareProcTypeDr_"^")){
				s Flag=1
			}	
		}	
	}	
	Q Flag					
GetCfgValue						
	s ChildId=0
	for{
		s ChildId=$o(^DHCDocCureArcCat(ParRef,NodeName,ChildSub,"L",ChildId)) Q:ChildId=""
		s CfgType=$p(^DHCDocCureArcCat(ParRef,NodeName,ChildSub,"L",ChildId),"^",2)
		s CfgValue=$p(^DHCDocCureArcCat(ParRef,NodeName,ChildSub,"L",ChildId),"^",3)
		continue:(CfgType="")!(CfgValue="")
		if CfgType="CP"{
			if CarePrvTpIDStr=""{
				s CarePrvTpIDStr=CfgValue	
			}else{
				s CarePrvTpIDStr=CarePrvTpIDStr_"^"_CfgValue		
			}
		}elseif CfgType="U"{
			if CfgUserIDStr=""{
				s CfgUserIDStr=CfgValue	
			}else{
				s CfgUserIDStr=CfgUserIDStr_"^"_CfgValue		
			}
		}
	} 	
	Quit
}

}
