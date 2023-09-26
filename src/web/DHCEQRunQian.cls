Class web.DHCEQRunQian Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 33;

/// 得到结存月报的列表
/// add by jdl 2010-10-27
/// 入参：StartMonth:YYYY-MM  该参数必需
/// 	  EndMonth:YYYY-MM	该参数可选，为空时表示与StartMonth一致
Query MonthReportRQ(MonthStr, CurGroupID As %String = "") As %Query(ROWSPEC = "Loc:%String,LocDesc:%String,StatCatID:%String,StatCat:%String,StockBegin:%String,StockIn:%String,StockReturn:%String,StockReduce:%String,StockMoveOut:%String,StockMoveIn:%String,StockEnd:%String,UsedBegin:%String,UsedIn:%String,UsedReturn:%String,UsedMoveIn:%String,UsedMoveOut:%String,Disused:%String,UsedEnd:%String,StartDate:%String,EndDate:%String,MonthStr:%String,TotalEnd:%String,ChangeAccount:%String,Origin:%String,EquipType:%String,TotalDepre:%String,Depre:%String,StockDisused:%String,StoreMoveIn:%String,StoreMoveOut:%String,NetFee:%String,StockChangeAccount:%String,UsedReduce:%String,StockOther:%String,UsedOther:%String,colflag:%String") [ SqlProc ]
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","MonthReportRQ","2014-08","111")
ClassMethod MonthReportRQExecute(ByRef qHandle As %Binary, MonthStr, CurGroupID As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	i CurGroupID="" Quit $$$OK
 	s Year=+$p(MonthStr,"-",1)
 	s Month=+$p(MonthStr,"-",2)
 	i '$d(^DHCEQMonthReportList(0,"Loc",Year,Month)) Quit $$$OK
 	
	s ETIDS=##class(web.DHCEQCommon).GetEquipTypesByGroup(CurGroupID) //2009-10-18 党军
	s EquipTypeIDS="^"_ETIDS_"^"
	
	
	;已经月结的月份则，到月结表中获取
	s EquipType=0
	f  s EquipType=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType)) q:EquipType=""  d
	.q:(EquipTypeIDS'="")&&(EquipTypeIDS'[("^"_EquipType_"^"))
	.s EquipTypeDesc=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",2)
	.s StatCat=0
	.f  s StatCat=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat)) q:StatCat=""  d
	..s StatCatDesc=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCat)),"^",2)
	..s Loc=0
	..f  s Loc=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,Loc)) q:Loc=""  d
	...s colflag=1
	...i $Data(^DHCEQCCode("DHCEQCLocType",0,"LocType",1,Loc))'=0 s colflag=0
	...s LocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",Loc)
	...s rowid=0
	...f  s rowid=$o(^DHCEQMonthReportList(0,"TypeDate",EquipType,Year,Month,StatCat,Loc,rowid)) q:rowid=""  d
	....s ListInfo=$g(^DHCEQMonthReportList(rowid))
	....s Origin=$p(ListInfo,"^",26)
	....s ListInfo=$p(ListInfo,"^",6,19)_"^"_$p(ListInfo,"^",25)_"^"_$p(ListInfo,"^",28,37)
	....d OutputRowMonthReportRQ
 	Quit $$$OK
OutputRowMonthReportRQ
	q:ListInfo=""
	s StockBegin=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",1),"",2)
	s StockIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",2),"",2)
	s StockReturn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",3),"",2)
	s StockReduce=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",4),"",2)
	s StockMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",5),"",2)
	s StockMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",6),"",2)
	s StockEnd=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",7),"",2)		
	s UsedBegin=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",8),"",2)
	s UsedIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",9),"",2)
	s UsedReturn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",10),"",2)
	s UsedMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",11),"",2)
	s UsedMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",12),"",2)
	s Disused=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",13),"",2)
	s UsedEnd=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",14),"",2)
	
	s ChangeAccount=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",15),"",2)

	s TotalDepre=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",16),"",2)
	s Depre=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",17),"",2)
	s StockDisused=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",18),"",2)
	s StoreMoveIn=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",19),"",2)
	s StoreMoveOut=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",20),"",2)
		
	s NetFee=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",21),"",2)	
	
	;Add by JDL 2011-6-22 JDL0086
	s StockChangeAccount=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",22),"",2)
	s UsedReduce=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",23),"",2)
	s StockOther=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",24),"",2)
	s UsedOther=##Class(web.DHCEQCommon).FormatNumber($p(ListInfo,"^",25),"",2)
	
	s TotalEnd=+StockEnd+UsedEnd
	s TotalEnd=##Class(web.DHCEQCommon).FormatNumber(TotalEnd,"",2)
	
	s Data=$lb(Loc,LocDesc,StatCat,StatCatDesc,StockBegin,StockIn,StockReturn,StockReduce,StockMoveOut,StockMoveIn,StockEnd,UsedBegin,UsedIn,UsedReturn,UsedMoveIn,UsedMoveOut,Disused,UsedEnd,StartDate,EndDate,MonthStr,TotalEnd,ChangeAccount,OriginDesc,EquipTypeDesc,TotalDepre,Depre,StockDisused,StoreMoveIn,StoreMoveOut,NetFee,StockChangeAccount,UsedReduce,StockOther,UsedOther,colflag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod MonthReportRQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MonthReportRQExecute ]
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

ClassMethod MonthReportRQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MonthReportRQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","DepreReportRQ","2014-08","","Y","","","1","90")
Query DepreReportRQ(MonthStr As %Library.String = "", UseLocDR As %Library.String = "", IsMainFlag As %Library.String = "Y", QXType As %String = "", FundsTypeDR As %String = "", CTLocID As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "locdr:%String,locdesc:%String,equiptype:%String,equiptypedesc:%String,statcat:%String,statcatdesc:%String,fundstype:%String,fundstypedesc:%String,origin:%String,origindesc:%String,OriginalFee:%String,NetFee:%String,DepreFee:%String,TotalDepreFee:%String,EquipName:%String,No:%String") [ SqlProc ]
{
}

ClassMethod DepreReportRQExecute(ByRef qHandle As %Binary, MonthStr As %Library.String = "", UseLocDR As %Library.String = "", IsMainFlag As %Library.String = "Y", QXType As %String = "", FundsTypeDR As %String = "", CTLocID As %String = "", CurGroupID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	i CTLocID'="" s CTLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",CTLocID)    //Modefied by zc0050  2019-10-19  CTLocID取值对应DHCEQCDepartment表中的值
	;s ^ZY=MonthStr_"^"_IsMainFlag_"^"_QXType_"^"_CTLocID_"^"_CurGroupID
	if MonthStr="" Quit $$$OK
	s job=$j
	s SelfFundsFlag=##class(web.DHCEQCommon).GetSysInfo("990015")
	s ETIDS=##Class(web.DHCEQCommon).GetEquipTypesByGroup(CurGroupID)
	s EquipTypeIDS="^"_ETIDS_"^"
	s locdr=0
	f  s locdr=$o(^DHCEQEquip(0,"StoreLoc",locdr))  quit:locdr=""  d
	.q:(UseLocDR'="")&(locdr'=UseLocDR)
	.s locdesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
	.s locdesc=##Class(web.DHCEQCommon).GetSplitDataByFlag(locdesc,"-")
	.s equipid=0
	.f  s equipid=$o(^DHCEQEquip(0,"StoreLoc",locdr,equipid))  quit:equipid=""  d
	..quit:$p($g(^DHCEQEquip(equipid)),"^",38)>2
	..quit:$p($g(^DHCEQEquip(equipid)),"^",60)'=1
	..s EquipName=$p($g(^DHCEQEquip(equipid)),"^",1)
	..s No=$p($g(^DHCEQEquip(equipid)),"^",71)
	..s equiptype=$p($g(^DHCEQEquip(equipid)),"^",63)
	..q:(EquipTypeIDS'="")&&(EquipTypeIDS'[("^"_equiptype_"^"))
	..s statcat=+$p($g(^DHCEQEquip(equipid)),"^",75)
	..s origin=+$p($g(^DHCEQEquip(equipid)),"^",20)
	..
	..s originalfee=+$p($g(^DHCEQEquip(equipid)),"^",27)
	..s totaldeprefee=+$p($g(^DHCEQEquip(equipid)),"^",35)
	..s netfee=+$p($g(^DHCEQEquip(equipid)),"^",28)
	..
	..s equiptypedesc=$p($g(^DHCEQCCode("DHCEQCEquipType",equiptype)),"^",2)
	..s statcatdesc=$p($g(^DHCEQCCode("DHCEQCStatCat",statcat)),"^",2)
	..s origindesc=$p($g(^DHCEQCCode("DHCEQCOrigin",origin)),"^",2)
	..s (rowid,depredata,deprefee)=""
	..s rowid=$o(^DHCEQMonthDepre(0,"EquipMonth",equipid,MonthStr,0))
	..i rowid'=""  s depredata=$g(^DHCEQMonthDepre(rowid))
	..q:(depredata'="")&($p(depredata,"^",3)'=IsMainFlag)
	..s deprefee=+$p(depredata,"^",14)
	..
	..s CADRowID=0
	..s CADFlag=0
	..i rowid'="" d
	...f  s CADRowID=$o(^DHCEQCostAllotDetail(0,"SourceID",rowid,CADRowID)) q:CADRowID=""  d
	....s CADFlag=CADFlag+1
	....s CurLocDR=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",3)
	....q:((UseLocDR'="")&&(UseLocDR'=CurLocDR))
	....q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,CurLocDR,CTLocID,CurGroupID)))
	....;s locdesc=$p($g(^CTLOC(CurLocDR)),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
	....s locdesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",CurLocDR)   //modify by jyp 2019-10-18 CTLOC调整
	....s locdesc=##Class(web.DHCEQCommon).GetSplitDataByFlag(locdesc,"-")
	....s deprefee=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",5)
	....s fundstype=$p($g(^DHCEQCostAllotDetail(CADRowID)),"^",7)
	....i fundstype="" s fundstype=SelfFundsFlag
	....q:(FundsTypeDR'="")&&(fundstype'=FundsTypeDR)
	....s fundstypedesc=$p($g(^DHCEQCCode("DHCEQCFundsType",fundstype)),"^",2)
	....i $p(depredata,"^",33)'=CurLocDR d
	.....s (tmporiginalfee,tmpnetfee,tmptotaldeprefee)=0
	....e  d
	.....s tmporiginalfee=originalfee
	.....s tmpnetfee=netfee
	.....s tmptotaldeprefee=totaldeprefee
	....s OriginalFee=tmporiginalfee
	....s NetFee=tmpnetfee
	....s DepreFee=deprefee
	....s TotalDepreFee=tmptotaldeprefee
	....d OutputRowDepreReportRQ
	...
	..i CADFlag=0  d
	...q:((UseLocDR'="")&&(UseLocDR'=locdr))
	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,locdr,CTLocID,CurGroupID)))
	...q:(FundsTypeDR'="")&&(SelfFundsFlag'=FundsTypeDR)
	...s fundstype=SelfFundsFlag
	...s fundstypedesc=$p($g(^DHCEQCCode("DHCEQCFundsType",fundstype)),"^",2)
	...s OriginalFee=originalfee
	...s NetFee=netfee
	...s DepreFee=deprefee
	...s TotalDepreFee=totaldeprefee
	..d OutputRowDepreReportRQ
	
	Quit $$$OK
	
OutputRowDepreReportRQ
	s Data=$lb(locdr,locdesc,equiptype,equiptypedesc,statcat,statcatdesc,fundstype,fundstypedesc,origin,origindesc,OriginalFee,NetFee,DepreFee,TotalDepreFee,EquipName,No)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod DepreReportRQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DepreReportRQExecute ]
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

ClassMethod DepreReportRQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DepreReportRQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","EquipListRQ","","","567","85")
Query EquipListRQ(UseLocDR As %Library.String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "locdr:%String,locdesc:%String,EquipName:%String,No:%String,EquipType:%String,StatCat:%String,Origin:%String,Model:%String,EquipCat:%String,Unit:%String,Provider:%String,ManuFactory:%String,StartDate:%String,Originalfee:%String,Totaldeprefee:%String,Netfee:%String,ABCType:%String,Quantity:%String") [ SqlProc ]
{
}

ClassMethod EquipListRQExecute(ByRef qHandle As %Binary, UseLocDR As %Library.String = "", QXType As %String = "", CTLocID As %String = "", CurGroupID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	Set Quantity=1
	s ETIDS=##Class(web.DHCEQCommon).GetEquipTypesByGroup(CurGroupID)
	s EquipTypeIDS="^"_ETIDS_"^"
	
	s locdr=0
	f  s locdr=$o(^DHCEQEquip(0,"StoreLoc",locdr))  quit:locdr=""  d
	.q:(UseLocDR'="")&(locdr'=UseLocDR)
	.s locdesc=##class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
	.s locdesc=##Class(web.DHCEQCommon).GetSplitDataByFlag(locdesc,"-")
	.s equipid=0
	.f  s equipid=$o(^DHCEQEquip(0,"StoreLoc",locdr,equipid))  quit:equipid=""  d
	..quit:$p($g(^DHCEQEquip(equipid)),"^",38)>2
	..quit:$p($g(^DHCEQEquip(equipid)),"^",60)'=1
	..s (EquipTypeDR,StatCatDR,OriginDR,ModelDR,EquipCatDR,UnitDR,ProviderDR,ManuFactoryDR)=""
	..s (EquipName,No,EquipType,StatCat,Origin,Model,EquipCat,Unit,Provider,ManuFactory,StartDate,Originalfee,Totaldeprefee,Netfee)=""
	..s EquipName=$p($g(^DHCEQEquip(equipid)),"^",1)
	..s No=$p($g(^DHCEQEquip(equipid)),"^",71)
	..s EquipTypeDR=$p($g(^DHCEQEquip(equipid)),"^",63)
	..q:(EquipTypeIDS'="")&&(EquipTypeIDS'[("^"_EquipTypeDR_"^"))
	..i EquipTypeDR'="" s EquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	..s StatCatDR=+$p($g(^DHCEQEquip(equipid)),"^",75)
	..i StatCatDR'="" s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	..s OriginDR=+$p($g(^DHCEQEquip(equipid)),"^",20)
	..i OriginDR'="" s Origin=$p($g(^DHCEQCCode("DHCEQCOrigin",OriginDR)),"^",2)
	..s ModelDR = $p($g(^DHCEQEquip(equipid)),"^",3)
	..i ModelDR'="" s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	..s EquipCatDR =$p($g(^DHCEQEquip(equipid)),"^",4)
	..i EquipCatDR'="" s EquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR)),"^",2)
	..s UnitDR = $p($g(^DHCEQEquip(equipid)),"^",5)
	..i UnitDR'="" s Unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	..s ProviderDR = $p($g(^DHCEQEquip(equipid)),"^",25)
	..i ProviderDR'="" s Provider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	..s ManuFactoryDR = $p($g(^DHCEQEquip(equipid)),"^",26)
	..i ManuFactoryDR'="" s ManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR) //CZF0093
	..s StartDate = $p($g(^DHCEQEquip(equipid)),"^",44)
	..i StartDate="" s StartDate =$p($g(^DHCEQEquip(equipid)),"^",45)
	..;i StartDate'="" s StartDate = $ZD(StartDate,3)
	..;日期格式统一调整 mwz 2017-3-2
 	..s StartDate=##class(web.DHCEQCommon).TransValueToPage(StartDate,"date")
	..s Originalfee=+$p($g(^DHCEQEquip(equipid)),"^",27)
	..s Totaldeprefee=+$p($g(^DHCEQEquip(equipid)),"^",35)
	..s Netfee=+$p($g(^DHCEQEquip(equipid)),"^",28)
	..s ABCType=$p($g(^DHCEQEquip(equipid)),"^",2)_"类"
	..d OutputRowEquipListRQ
	Quit $$$OK
OutputRowEquipListRQ
	s Data=$lb(locdr,locdesc,EquipName,No,EquipType,StatCat,Origin,Model,EquipCat,Unit,Provider,ManuFactory,StartDate,Originalfee,Totaldeprefee,Netfee,ABCType,Quantity)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod EquipListRQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EquipListRQExecute ]
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

ClassMethod EquipListRQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EquipListRQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by GR0022 根据菜单Name更新菜单信息
/// W ##CLASS(%ResultSet).RunQuery("web.DHCEQRunQian","BakmenuName","",50514)
Query BakmenuName(SUBMENUNAME As %String = "", ID As %String = "", SEQUENCE As %String = "", CAPTION As %String = "", NAME As %String = "", TYPE As %String = "", IMAGE As %String = "") As %Query(ROWSPEC = "TSubMenuName:%String,TID:%String,TSequence:%String,TCaption:%String,TName:%String,TType:%String,TImage:%String") [ SqlProc ]
{
}

ClassMethod BakmenuNameExecute(ByRef qHandle As %Binary, SUBMENUNAME As %String = "", ID As %String = "", SEQUENCE As %String = "", CAPTION As %String = "", NAME As %String = "", TYPE As %String = "", IMAGE As %String = "") As %Status
{
	new repid,index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
	
	s id=""
	s SubMenuName=""
	f  s id=$order(^websys.MenuD(id),-1) q:id=""  d
	.;q:(id'=ID)&&(ID'="")
	.d BuildMenuDATA
	Quit $$$OK
BuildMenuDATA
	//modify by mwz 20211201 mwz0055  begin
	s SubMenuOf=$LG(^websys.MenuD(id),12)

	i $G(SubMenuOf)="" s SubMenuName=""
	e  d 
	.i $DATA(^websys.MenuD(SubMenuOf))   s SubMenuName=$LG(^websys.MenuD(SubMenuOf),4)	
	.e  s SubMenuName=""			//过滤父菜单已删除的情况
	q:(SubMenuName'[SUBMENUNAME)&&(SUBMENUNAME'="")
	s Sequence=$LG(^websys.MenuD(id),5)
	q:(Sequence'[SEQUENCE)&&(SEQUENCE'="")
	
	s Caption=$LG(^websys.MenuD(id),1)
	q:(Caption'[CAPTION)&&(CAPTION'="")
	
	s Name=$LG(^websys.MenuD(id),4)
	q:(Name'[NAME)&&(NAME'="")
	
	s Type=$LG(^websys.MenuD(id),8)
	q:(Type'=TYPE)&&(TYPE'="")
	
	s Image=$LG(^websys.MenuD(id),2)
	//modify by mwz 20211201 mwz0055  end
	q:(Image'=IMAGE)&&(IMAGE'="")
	i (Name="")&&(Caption="") q	//过滤Name与Caption都为空的菜单
	d OutputMenuDetail
	q
	
	
	
OutputMenuDetail
	s Data=$lb(SubMenuName,id,Sequence,Caption,Name,Type,Image)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod BakmenuNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BakmenuNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod BakmenuNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BakmenuNameExecute ]
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

/*********************************************************************************/
/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","MaintStat","2014-12","2015-01","","","90","410")
Query MaintStat(StartMonth As %String = "", EndMonth As %String = "", UseLocDR As %String = "", Equip As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipName:%String,TEquipNo:%String,TModel:%String,THold1:%String,TOtherFee:%String,TUseLoc:%String,TAckDate:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod MaintStatExecute(ByRef qHandle As %Binary, StartMonth As %String = "", EndMonth As %String = "", UseLocDR As %String = "", Equip As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	
 	i (StartMonth="")||(EndMonth="") Quit $$$OK
 	s BeginDate=##Class(web.DHCEQReport).GetMonthDate(StartMonth,1)
 	s BeginDate=$ZDH(BeginDate,4)
	s EndDate=##Class(web.DHCEQReport).GetMonthDate(EndMonth,2)
	s EndDate=$ZDH(EndDate,4)
	s rowid=0
	f  s rowid=$o(^DHCEQMaintRequest(rowid))  q:rowid=""  d
	.d ResetVariablesMaintStat
	.s TRowID=rowid
	.s InvalidFlag=$p($g(^DHCEQMaintRequest(rowid)),"^",47)
	.q:InvalidFlag="Y"
	.s Status=$p($g(^DHCEQMaintRequest(rowid)),"^",29)
	.q:Status'=2
	.s TAckDate=$p($g(^DHCEQMaintRequest(rowid)),"^",11)
	.q:(TAckDate<BeginDate)||(TAckDate>EndDate)
	.;i TAckDate'="" s TAckDate=$ZD(TAckDate,3)
	.s TAckDate=##class(web.DHCEQCommon).TransValueToPage(TAckDate,"date")
	.s EquipDR=$p($g(^DHCEQMaintRequest(rowid)),"^",1)
	.i EquipDR'="" d
	..s TEquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	..q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
	..s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	..s TEquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	..s ModelDR=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	..i ModelDR'="" s TModel=$P($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	..s TUseLocDR=$p($g(^DHCEQMaintRequest(rowid)),"^",26)
	..i TUseLocDR'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	..s THold1=$p($g(^DHCEQMaintRequest(rowid)),"^",48)
	..s TOtherFee=$p($g(^DHCEQMaintRequest(rowid)),"^",42)
	..s TRemark=$p($g(^DHCEQMaintRequest(rowid)),"^",28)
	..d OutputRowMaintStat
	Quit $$$OK
OutputRowMaintStat
	s Data=$lb(TRowID,TEquipName,TEquipNo,TModel,THold1,TOtherFee,TUseLoc,TAckDate,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesMaintStat
	s (TRowID,TEquipName,TEquipNo,TModel,THold1,TOtherFee,TUseLoc,TAckDate,TRemark)=""
	quit
}

ClassMethod MaintStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintStatExecute ]
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

ClassMethod MaintStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 新增：2014-12-26 ZY 
///  d ##class(%ResultSet).RunQuery("web.DHCEQBenefitAnalyReport","Utilization","","","2014-12","2014-12","111")
Query Utilization(Equip, UseLocID As %Library.String = "", sMonthStr As %Library.String = "", eMonthStr As %Library.String = "", CurGroupID As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TUseLoc:%String,TNo:%String,TLeaveFactoryNo:%String,TOldNo:%String,TUtilizationRate:%String,TUtilization:%String,TUsedUtilization:%String,MonthStr:%String") [ SqlProc ]
{
}

ClassMethod UtilizationExecute(ByRef qHandle As %Binary, Equip, UseLocID As %Library.String = "", sMonthStr As %Library.String = "", eMonthStr As %Library.String = "", CurGroupID As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Equip=$ZCONVERT(Equip,"U")
	i (sMonthStr="")||(eMonthStr="") Quit $$$OK
	i ($ZDH(sMonthStr_"-01",3)>$ZDH(eMonthStr_"-01",3)) Quit $$$OK	
	s Code=0
	f  s Code=$o(^DHCEQEquip(0,"Code",Code))  quit:Code=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(0,"Code",Code,rowid))  quit:rowid=""  d
	..d ResetVariablesUtilization
	..Quit:##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)=0
	..Quit:$p($g(^DHCEQEquip(rowid)),"^",59)'="N"
	..s TRowID=rowid
	..s TName = $p($g(^DHCEQEquip(rowid)),"^",1)
	..s TCode = Code
	..s TDesc = $p($g(^DHCEQEquip(rowid)),"^",7)
	..s TLeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	..s TMemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	..s TOldNo = $p($g(^DHCEQEquip(rowid)),"^",91)
	..s TNo = $p($g(^DHCEQEquip(rowid)),"^",71)
	..quit:(Equip'="")&&(($ZCONVERT(TName,"U")'[Equip)&($ZCONVERT(TLeaveFactoryNo,"U")'[Equip)&(TRowID'=Equip)&($ZCONVERT(TMemoryCode,"U")'[Equip)&($ZCONVERT(TNo,"U")'[Equip)&($ZCONVERT(TCode,"U")'[Equip))
	..
	..s TEquipType=$p($g(^DHCEQEquip(rowid)),"^",63)
	..quit:(TEquipType'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipType,CurGroupID))
	..s TStatus = $p($g(^DHCEQEquip(rowid)),"^",38)
	..quit:(TStatus="2")||(TStatus="3")
	..s TUseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	..quit:(UseLocID'="")&&(TUseLocDR'=UseLocID)
	..i TUseLocDR'="" s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	..s vStart=$ZDH(sMonthStr_"-01",3)
	..s vEnd=$ZDH(eMonthStr_"-01",3)
	..f ID=vStart:1:vEnd  d
	...;当前月份
	...s MonthStr=$E($ZD(ID,3),1,7)
	...;s ^ZY("TUtilizationStr",rowid,MonthStr)=##Class(web.DHCEQAnalysisIndex).UtilizationRate(rowid,MonthStr)
    ...s TUtilizationStr=##Class(web.DHCEQAnalysisIndex).UtilizationRate(rowid,MonthStr)
    ...s TUtilizationRate=$p(TUtilizationStr,"^",1)
	...s TUtilization=$p(TUtilizationStr,"^",2)
	...s TUsedUtilization=$p(TUtilizationStr,"^",3)
	...d OutputRowUtilization
	...s vYear=$E($ZD(ID,3),1,4)
	...s vMonth=$E($ZD(ID,3),6,7)
	...i vMonth=12  d
	....s vYear=vYear+1
	....s vMonth=1
	...e  d
	....s vMonth=vMonth+1
	...s ID=$ZDH(vYear_"-"_vMonth_"-01",3) - 1
	Quit $$$OK
OutputRowUtilization
	s Data=$lb(TRowID,TName,TUseLoc,TNo,TLeaveFactoryNo,TOldNo,TUtilizationRate,TUtilization,TUsedUtilization,MonthStr)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesUtilization
	s (TRowID,TName,TCode,TDesc,TLeaveFactoryNo,TMemoryCode,TNo,TOldNo,TEquipType,TStatus,TUseLocDR,TUseLoc,TUtilizationRate,TUtilization,TUsedUtilization,MonthStr)=""
	quit
}

ClassMethod UtilizationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UtilizationExecute ]
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

ClassMethod UtilizationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = UtilizationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 2015-11-11
/// 供应商评价汇总表(南方医院)
/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","EvaluateSummaryRpt","",85)
Query EvaluateSummaryRpt(ProviderDR As %String = "", CurGroupID As %Library.String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TProvider:%String,TEvaluateType:%String,TCount:%String,TotalFee:%String,TotalScore:%String,TFlag:%String") [ SqlProc ]
{
}

ClassMethod EvaluateSummaryRptExecute(ByRef qHandle As %Binary, ProviderDR As %String = "", CurGroupID As %Library.String = "", StartDate As %String = "", EndDate As %String = "", QXType As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	Set index=1
 	Set TJob=$Job
 	Set TempNode="RunQian.EvaluateSummaryRpt"
 	Kill ^DHCEQTemp(TempNode,TJob)
 	//If StartDate'="" Set StartDate=$ZDH(StartDate,3)
 	//If EndDate'="" Set EndDate=$ZDH(EndDate,3)
 	// 日期格式统一调整 mwz 2017-3-2
 	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	;s ^DHCEQMozy("EvaluateSummaryRpt")=ProviderDR_"^"_CurGroupID_"^"_StartDate_"^"_EndDate
 	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQEvaluate(rowid)) Quit:(rowid="")  Do
	.Set TSourceType = $Piece($Get(^DHCEQEvaluate(rowid)),"^",1)
	.Set TSourceID = $Piece($Get(^DHCEQEvaluate(rowid)),"^",2)
	.Set TEvaluateTypeDR = $Piece($Get(^DHCEQEvaluate(rowid)),"^",3)
	.Set TScore = +$Piece($Get(^DHCEQEvaluate(rowid)),"^",4)
	.Set TAllScore = +$Piece($Get(^DHCEQEvaluate(rowid)),"^",13)
	.Set TStdScore=10*TScore/TAllScore	;转化为10分制
	.
	.Set TFlag=1
	.;入库
	.If TSourceType=21 Do
	..Set TEquipTypeDR=$Piece($Get(^DHCEQInStock(TSourceID)),"^",20)
	..Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	..Set TProviderDR=$Piece($Get(^DHCEQInStock(TSourceID)),"^",17)
	..Quit:(ProviderDR'="")&(ProviderDR'=TProviderDR)
	..If TProviderDR '="" Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov", TProviderDR)
	..Set TBillAuditDate=$Piece($Get(^DHCEQInStock(TSourceID)),"^",13)
	..Quit:(StartDate'="")&(StartDate>TBillAuditDate)
	..Quit:(EndDate'="")&(TBillAuditDate>EndDate)
	..Set islrowid=0
	..For  Set islrowid=$Order(^DHCEQInStockList(0,"InStock",TSourceID,islrowid)) Quit:islrowid=""  Do
	...Set TFee=$Piece($Get(^DHCEQInStockList(islrowid)),"^",7)*$Piece($Get(^DHCEQInStockList(islrowid)),"^",8)
	...Set TFlag=0
	.
	.;维修
	.If TSourceType=31 Do
	..Set TEquipTypeDR=$Piece($Get(^DHCEQMMaintRequest(TSourceID)),"^",3)
	..Quit:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	..Set TAuditDate=$Piece($Get(^DHCEQMMaintRequest(TSourceID)),"^",52)
	..Quit:(StartDate'="")&(StartDate>TAuditDate)
	..Quit:(EndDate'="")&(TAuditDate>EndDate)
	..Set mprowid=0
	..For  Set mprowid=$Order(^DHCEQMMaintPart(0,"MaintRequest",TSourceID,mprowid)) Quit:mprowid=""  Do
	...Set TProviderDR=$Piece($Get(^DHCEQMMaintPart(mprowid)),"^",16)
	...Quit:(ProviderDR'="")&(ProviderDR'=TProviderDR)
	...If TProviderDR '="" Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov", TProviderDR)
	...Set TFee=$Piece($Get(^DHCEQMMaintPart(mprowid)),"^",5)
	...Set TFlag=0
	.
	.Quit:TFlag=1
	.Set TempData=$Get(^DHCEQTemp(TempNode,TJob,TProvider,TEvaluateTypeDR))
	.Set TCount=1+$Piece(TempData,"^",1)
	.Set TotalFee=TFee+$Piece(TempData,"^",2)
	.Set TotalScore=TStdScore+$Piece(TempData,"^",3)
	.;本次评分与前次评分比较出趋势	需求: 282958	Mozy	20161111
	.If +$Piece(TempData,"^",4)>TStdScore Set TFlag=-1
	.If +$Piece(TempData,"^",4)=TStdScore Set TFlag=0
	.If +$Piece(TempData,"^",4)<TStdScore Set TFlag=1
	.
	.Set ^DHCEQTemp(TempNode,TJob,TProvider,TEvaluateTypeDR)=TCount_"^"_TotalFee_"^"_TotalScore_"^"_TStdScore_"^"_TFlag
	
	Set (TCount,TotalFee,TotalScore,TFlag)=0
	Set TProvider=""
	For  Set TProvider=$Order(^DHCEQTemp(TempNode,TJob,TProvider)) Quit:(TProvider="")  Do
	.Set TEvaluateTypeDR=""
	.For  Set TEvaluateTypeDR=$Order(^DHCEQTemp(TempNode,TJob,TProvider,TEvaluateTypeDR)) Quit:(TEvaluateTypeDR="")  Do
	..Set TempData=$Get(^DHCEQTemp(TempNode,TJob,TProvider,TEvaluateTypeDR))
	..Set TEvaluateType = $Piece($Get(^DHCEQCCode("DHCEQCEvaluateType",TEvaluateTypeDR)),"^",2)
	..Set TEvaluateType=TEvaluateType_"(10分)"
	..Set TCount=+$Piece(TempData,"^",1)
	..Set TotalFee=$Piece(TempData,"^",2)
	..Set TotalScore=$Piece(TempData,"^",3)/TCount
	..Set TFlag=$Piece(TempData,"^",5)
	..Do OutputRowEvaluateSummaryRpt
	If index=1 Do OutputRowEvaluateSummaryRpt
	
	Kill ^DHCEQTemp(TempNode,TJob)
	Quit $$$OK
OutputRowEvaluateSummaryRpt
	Set TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
	Set TotalScore=##Class(web.DHCEQCommon).FormatNumber(TotalScore,1,1)
	Set Data=$lb(TProvider,TEvaluateType,TCount,TotalFee,TotalScore,TFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod EvaluateSummaryRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EvaluateSummaryRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod EvaluateSummaryRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EvaluateSummaryRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 2016-8-24
/// 租借设备情况汇总表(南方医院)
/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","EquipRentSummaryRpt","","","")
Query EquipRentSummaryRpt(Name As %Library.String = "", UseLocDR As %Library.String = "", CurGroupID As %Library.String = "") As %Query(ROWSPEC = "TNo:%String,TFileNo:%String,TName:%String,TModel:%String,TQuantity:%String,TOriginalFee:%String,TRentStatus:%String,TLoc:%String") [ SqlProc ]
{
}

ClassMethod EquipRentSummaryRptExecute(ByRef qHandle As %Binary, Name As %Library.String = "", UseLocDR As %Library.String = "", CurGroupID As %Library.String = "") As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	;s ^DHCEQMozy("EquipRentSummaryRpt")=Name_","_UseLocDR_","_CurGroupID
 	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQEquip(rowid)) Quit:(rowid="")  Do
	.Quit:$p(^DHCEQEquip(rowid),"^",38)>3
	.Quit:$p(^DHCEQEquip(rowid),"^",59)="Y"
	.Quit:$p(^DHCEQEquip(rowid),"^",60)="0"
	.Quit:$p(^DHCEQEquip(rowid),"^",60)="3"
	.Quit:##class(web.DHCEQCommon).EquipTypeIsIn($p(^DHCEQEquip(rowid),"^",63),CurGroupID)
	.Quit:##Class(web.DHCEQEquipRent).CheckEquipIsInRent(rowid)
	.
	.d ResetVariablesEquipRentSummaryRpt
	.Set EquipData=$Get(^DHCEQEquip(rowid))
	.
	.Set TNo=$Piece(EquipData,"^",71)
	.Set TFileNo=$Piece(EquipData,"^",85)
	.Set TName=$Piece(EquipData,"^",1)
	.q:(Name'="")&(TName'[Name)
	.Set TModel = "--"
	.Set TModelDR=$Piece(EquipData,"^",3)
	.i TModelDR '="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TQuantity = 1
	.s TOriginalFee = $p(EquipData,"^",27)
	.s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",$Piece(EquipData,"^",67))
	.s TRentLocDR=$p(EquipData,"^",86)	;租借科室
	.q:(UseLocDR'="")&(TRentLocDR'=UseLocDR)
	.i TRentLocDR '="" s TLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TRentLocDR)
	.s TRentStatus = $CASE($p(EquipData,"^",87),"1":"借出",:"在库")
	.
	.d OutputRowEquipRentSummaryRpt
	
	Quit $$$OK
OutputRowEquipRentSummaryRpt
	Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	
	Set Data=$lb(TNo,TFileNo,TName,TModel,TQuantity,TOriginalFee,TRentStatus,TLoc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesEquipRentSummaryRpt
	s (TNo,TFileNo,TName,TModel,TQuantity,TOriginalFee,TRentStatus,TLoc)=""
	quit
}

ClassMethod EquipRentSummaryRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EquipRentSummaryRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod EquipRentSummaryRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EquipRentSummaryRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 2016-8-26
/// 配件入库明细汇总表(按发票号)
/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","AInStockSummaryRpt","","","","",85)
Query AInStockSummaryRpt(StartDate As %String = "", EndDate As %String = "", MinPrice As %String = "", MaxPrice As %String = "", InvoiceNo As %String = "", CurGroupID As %Library.String = "", QXType As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TProvider:%String,TInvoiceNos:%String,TQuantity:%String,TAmount:%String") [ SqlProc ]
{
}

ClassMethod AInStockSummaryRptExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", MinPrice As %String = "", MaxPrice As %String = "", InvoiceNo As %String = "", CurGroupID As %Library.String = "", QXType As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	If (StartDate="")&&(EndDate="") Quit $$$OK
 	
 	Set index=1
 	Set TJob=$Job
 	Set TempNode="RunQian.AInStockSummaryRpt"
 	Set TempNewNode ="New.RunQian.AInStockSummaryRpt"   //add by wl 2019-11-8 WL009  增加节点
 	Kill ^DHCEQTemp(TempNode,TJob)
 	Kill ^DHCEQTemp(TempNewNode,TJob) //add by wl 2019-11-8 WL009
 	i StartDate="" d
	.s StartDate=0
	e  d
	.Set StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate="" d
	.s EndDate=+$H
	e  d
	.Set EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	/*i MonthStr'=""
 	{
 		s StartDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,1)
 		s StartDate=$zdh(StartDate,4)
 		s EndDate=##Class(web.DHCEQReport).GetMonthDate(MonthStr,2)
 		s EndDate=$zdh(EndDate,4)
 	}
 	else
 	{
	 	;Quit $$$OK
 	}*/
 	;s ^DHCEQMozy("AInStockSummaryRpt")=StartDate_","_EndDate_","_MinPrice_","_MaxPrice_","_CurGroupID
 	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQAInStockList(rowid)) Quit:(rowid="")  Do
	.s TAInStockDR = $p($g(^DHCEQAInStockList(rowid)),"^",1)
	.s TAccessoryTypeDR = $p($g(^DHCEQAInStock(TAInStockDR)),"^",2)
	.q:##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID) //add by wl 2019-11-8 WL009 
	.s AISAuditDate = $p($g(^DHCEQAInStock(TAInStockDR)),"^",24)
	.Quit:($p($g(^DHCEQAInStock(TAInStockDR)),"^",16)'=2)	;AISStatus
	.Quit:(StartDate'="")&(StartDate>AISAuditDate)
	.Quit:(EndDate'="")&(AISAuditDate>EndDate)
	.s TProvider=""
	.s TProviderDR = $p($g(^DHCEQAInStock(TAInStockDR)),"^",8)
	.q:TProviderDR=""  				//add by wl 2019-11-8 WL009 加入限制条件
	.If TProviderDR '="" Set TProvider =##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TProviderCode=##class(web.DHCEQCHanZiEncoding).GetEncoding(TProvider,4,"","U")
	.q:TProviderCode=""			//add by wl 2019-11-8 WL009 加入限制条件		
	.i $p(^DHCEQAInStockList(rowid),"^",19)="" d
	..s AISLInvoiceNos=0
	.e  d
	..s AISLInvoiceNos=$p(^DHCEQAInStockList(rowid),"^",19)	
	.s TAmount=$p(^DHCEQAInStockList(rowid),"^",10)
	.s TQuantityNum=1   //add by wl 2019-11-8 WL009 
	.i '$d(^DHCEQTemp(TempNode,TJob,TProviderCode,TProviderDR,AISLInvoiceNos)) s ^DHCEQTemp(TempNode,TJob,TProviderCode,TProviderDR,AISLInvoiceNos)=0
	.Set ^DHCEQTemp(TempNode,TJob,TProviderCode,TProviderDR,AISLInvoiceNos)=TAmount+$g(^DHCEQTemp(TempNode,TJob,TProviderCode,TProviderDR,AISLInvoiceNos))
	.//add by wl 2019-11-8 WL009 begin	
	.i '$d(^DHCEQTemp(TempNewNode,TJob,TProviderCode,TProviderDR,AISLInvoiceNos)) s ^DHCEQTemp(TempNewNode,TJob,TProviderCode,TProviderDR,AISLInvoiceNos)=0
	.Set ^DHCEQTemp(TempNewNode,TJob,TProviderCode,TProviderDR,AISLInvoiceNos)=TQuantityNum+$g(^DHCEQTemp(TempNewNode,TJob,TProviderCode,TProviderDR,AISLInvoiceNos))
	.//add by wl 2019-11-8 WL009 end
	Set TProviderCode=""
	For  Set TProviderCode=$Order(^DHCEQTemp(TempNode,TJob,TProviderCode)) Quit:(TProviderCode="")  Do
	.Set TProviderDR=""
	.For  Set TProviderDR=$Order(^DHCEQTemp(TempNode,TJob,TProviderCode,TProviderDR)) Quit:(TProviderDR="")  Do
	..Set TProvider =##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	..Set TInvoiceNos=""
	..For  Set TInvoiceNos=$Order(^DHCEQTemp(TempNode,TJob,TProviderCode,TProviderDR,TInvoiceNos)) Quit:(TInvoiceNos="")  Do
	...Set TAmount = +$g(^DHCEQTemp(TempNode,TJob,TProviderCode,TProviderDR,TInvoiceNos))  
	...set TQuantityNum=+$g(^DHCEQTemp(TempNewNode,TJob,TProviderCode,TProviderDR,TInvoiceNos)) //add by wl 2019-11-8 WL009
	...q:(InvoiceNo'="")&&(TInvoiceNos'[InvoiceNo)
	...q:(MaxPrice'="")&&(TAmount>MaxPrice)
	...q:(MinPrice'="")&&(TAmount<MinPrice)
	...d OutputRowAInStockSummaryRpt
	Kill ^DHCEQTemp(TempNode,TJob)
	Kill ^DHCEQTemp(TempNewNode,TJob) //add by wl 2019-11-8 WL009
	
	Quit $$$OK
OutputRowAInStockSummaryRpt
	i TInvoiceNos="0"  s TInvoiceNos="----"  //add by wl 2019-11-8 WL009
	Set TAmount=##Class(web.DHCEQCommon).FormatNumber(TAmount,"")
	Set TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"")  //add by wl 2019-11-8 WL009
	Set Data=$lb(TProvider,TInvoiceNos,TQuantityNum,TAmount)				//modify by wl 2019-11-8 WL009
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod AInStockSummaryRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = AInStockSummaryRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod AInStockSummaryRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = AInStockSummaryRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 2016-12-12	Mozy
/// 保修设备明细查询
/// Flag	1:在保	2:过保	0:其它
/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","GuaranteeDateRpt","",1,"",85)
Query GuaranteeDateRpt(toDate As %String = "", Flag As %String = "", LocDR As %String = "", CurGroupID As %Library.String = "") As %Query(ROWSPEC = "No:%String,FileNo:%String,Name:%String,Model:%String,OriginalFee:%String,StoreLoc:%String,Provider:%String,GuaranteePeriodNum:%String,GuaranteeEndDate:%String") [ SqlProc ]
{
}

ClassMethod GuaranteeDateRptExecute(ByRef qHandle As %Binary, toDate As %String = "", Flag As %String = "", LocDR As %String = "", CurGroupID As %Library.String = "") As %Status
{
 	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("GuaranteeDateRpt")=toDate_","_Flag_","_LocDR_","_CurGroupID
 	Set index=1
	i toDate="" d
	.s toDate=+$H
	e  d
	.;Set toDate=$zdh(toDate,3)
	.s toDate=##class(web.DHCEQCommon).TransValueFromPage(toDate,"date")
 	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQEquip(rowid)) Quit:(rowid="")  Do
	.d ResetVariablesGuaranteeDateRpt
	.s EquipData=$g(^DHCEQEquip(rowid))
	.quit:$p(EquipData,"^",59)'="N"
	.quit:$p(EquipData,"^",60)=0	;TStockStatus
	.quit:$p(EquipData,"^",60)=3	;TStockStatus
	.Set TEquipTypeDR=$p(EquipData,"^",63)
	.q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	.s TStatus = $p(EquipData,"^",38)
	.q:TStatus>2
	.
	.s GuaranteeEndDate=$Piece(EquipData,"^",51)
	.q:(Flag'=0)&(GuaranteeEndDate="")
	.q:(Flag=1)&(GuaranteeEndDate<toDate)
	.q:(Flag=2)&(GuaranteeEndDate>=toDate)
	.
	.s StoreLocDR=$p(EquipData,"^",67)
	.q:(LocDR'="")&(LocDR'=StoreLocDR)
	.
	.s No = $ZCONVERT($p(EquipData,"^",71),"U")
	.Set FileNo=$Piece(EquipData,"^",85)
	.s Name = $ZCONVERT($p(EquipData,"^",1),"U")
	.s StoreLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	.s ModelDR = $p(EquipData,"^",3)
	.s Model=##Class(web.DHCEQCommon).GetTrakNameByID("model", ModelDR)
	.s OriginalFee=$p(EquipData,"^",27)
	.s OriginalFee=$fn(OriginalFee,"",2)
	.s Provider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",+$p(EquipData,"^",25))
	.;Set GuaranteeEndDate=$ZD(GuaranteeEndDate,3)
	.s GuaranteeEndDate=##class(web.DHCEQCommon).TransValueToPage(GuaranteeEndDate,"date")
	.Set GuaranteePeriodNum=$Piece($Get(^DHCEQEquip(rowid)),"^",73)
	.i GuaranteePeriodNum'="" s GuaranteePeriodNum=GuaranteePeriodNum_"月"
	.d OutputRowGuaranteeDateRpt
	
	
	Quit $$$OK
OutputRowGuaranteeDateRpt
	Set Data=$lb(No,FileNo,Name,Model,OriginalFee,StoreLoc,Provider,GuaranteePeriodNum,GuaranteeEndDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGuaranteeDateRpt
	s (No,FileNo,Name,ModelDR,Model,OriginalFee,StoreLocDR,StoreLoc,Provider,GuaranteePeriodNum,GuaranteeEndDate)=""
	quit
}

ClassMethod GuaranteeDateRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GuaranteeDateRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GuaranteeDateRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GuaranteeDateRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy	2017-2-7
/// 四川郫县各库房业务明细报表
/// 业务类型	TBussType	0:库房分配	1:科室调配	2:设备入库	3:科室退库	4:减少	5:退货  6:报废
/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","StoreDetailRpt","6","","","","","","","",85,327)
Query StoreDetailRpt(BussType As %String = "", vStartDate As %String = "", vEndDate As %String = "", ProviderDR As %String = "", EquipTypeDR As %String = "", FromLocDR As %String = "", ToLocDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", EquipTypeIDs As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDate:%String,TNo:%String,TManageLoc:%String,TFromLoc:%String,TToLoc:%String,TEquipName:%String,TEquipType:%String,TStatCat:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TManuFactory:%String,TListRemark:%String,TProvider:%String,TEquipNoInfo:%String") [ SqlProc ]
{
}

ClassMethod StoreDetailRptExecute(ByRef qHandle As %Binary, BussType As %String = "", vStartDate As %String = "", vEndDate As %String = "", ProviderDR As %String = "", EquipTypeDR As %String = "", FromLocDR As %String = "", ToLocDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", EquipTypeIDs As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i (BussType="")&(vStartDate="")&(vEndDate="") Quit $$$OK   //需求号：744719 add by MWZ 2018-12-25
 	Set index=1
 	;s ^DHCEQMozy("StoreDetailRpt")=BussType_","_vStartDate_","_vEndDate_","_ProviderDR_","_EquipTypeDR_","_FromLocDR_","_ToLocDR_","_CurGroupID_","_CurLocID
        i EquipTypeIDs'="" s EquipTypeIDs=","_EquipTypeIDs_","
 	i vStartDate="" d
	.s vStartDate=0
	e  d
	.Set vStartDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
	i vEndDate="" d
	.s vEndDate=+$H
	e  d
	.Set vEndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
	
	//入库
	s TBussType=2
	i (BussType="2")
	{
	 	s TEquipTypeDR=0
	 	f  s TEquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR)) q:(TEquipTypeDR="")  d
	 	.//add by ZY20230209 bug:  增加查询条件
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
	 	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
		.q:(EquipTypeIDs'="")&&(EquipTypeIDs'[(","_TEquipTypeDR_","))
	 	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	 	.s TManageLocDR=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",10)
	 	.s TManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	 	.s BillAuditDate=vStartDate-1
	 	.f  s BillAuditDate=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR,BillAuditDate)) q:(BillAuditDate="")||(BillAuditDate>vEndDate)  d
	 	..s ISRowID=0		//入库单rowID
	 	..f  s ISRowID=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR,BillAuditDate,ISRowID)) q:ISRowID=""  d
	 	...q:$p($g(^DHCEQInStock(ISRowID)),"^",10)'=2
                ...q:$p($g(^DHCEQInStock(ISRowID)),"^",25)'="N"
	 	...s vendorid=$p($g(^DHCEQInStock(ISRowID)),"^",17)
	 	...q:(ProviderDR'="")&&(vendorid'=ProviderDR)
	 	...s TNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
		...s TDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(ISRowID)),"^",1),"CHNDate")   //add by wy 2017-5-5
		...s TFromLoc="--"
		...s TToLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQInStock(ISRowID)),"^",2))
	 	...
	 	...s ISLRowID=0
	 	...f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:ISLRowID=""  d
	 	....d ResetVariablesGetStoreDetailRpt
	 	....s TRowID=ISLRowID
	 	....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
	 	....s TEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
	 	....s TModelDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",9)
	 	....s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	 	....s TUnitDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",10)
	 	....s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	 	....s TQuantity=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
	 	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"",2)
	 	....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
	 	....s TManuFactoryDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",6)
		....s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	 	....s TListRemark=$p($g(^DHCEQInStockList(ISLRowID)),"^",12)
	 	....s TStatCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",17)
	 	....s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	 	....s SLID=0
	 	....f  s SLID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,SLID)) q:SLID=""  d
	 	.....s TEquipDR=0
	 	.....f  s TEquipDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,SLID,TEquipDR)) q:TEquipDR=""  d
		......If TEquipNoInfo'="" s TEquipNoInfo=TEquipNoInfo_","
		......s TEquipNoInfo=TEquipNoInfo_$p($g(^DHCEQEquip(TEquipDR)),"^",71)
		....s TEquipNoInfo=##Class(web.DHCEQCommon).GetContinueNo(TEquipNoInfo)
	 	....d OutputRowGetStoreDetailRpt
	}
	
 	//退货
 	s TEquipTypeDR=0
 	f  s TEquipTypeDR=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR)) q:(TEquipTypeDR="")  d
 	.//add by ZY20230209 bug:  增加查询条件
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
        .q:(EquipTypeIDs'="")&&(EquipTypeIDs'[(","_TEquipTypeDR_","))
 	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
 	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
 	.s TManageLocDR=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",10)
 	.s TManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
 	.s OutTypeDR=""
 	.f  s OutTypeDR=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR,OutTypeDR)) q:(OutTypeDR="")  d
 	..s OutTypeCode=$p($g(^DHCEQCCode("DHCEQCOutType",OutTypeDR)),"^",1)
 	..i OutTypeCode="TH" d
 	...s TBussType=5
 	..e  d
 	...s TBussType=4
 	..q:(BussType'="")&&(BussType'=TBussType)
 	..s AckDate=vStartDate-1
 	..f  s AckDate=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR,OutTypeDR,AckDate)) q:((AckDate="")||(AckDate>vEndDate))  d
 	...s RRowID=0
 	...f  s RRowID=$o(^DHCEQReturn(0,"TypeDate",TEquipTypeDR,OutTypeDR,AckDate,RRowID)) q:RRowID=""  d
 	....q:$p($g(^DHCEQReturn(RRowID)),"^",13)'=2
 	....s vendorid=$p($g(^DHCEQReturn(RRowID)),"^",3)
 	....s TNo=$p($g(^DHCEQReturn(RRowID)),"^",1)
	....s TDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQReturn(RRowID)),"^",4),"CHNDate")
	....s TFromLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQReturn(RRowID)),"^",2))
	....s TToLoc="--"
 	....s RLRowID=0
 	....f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID)) q:RLRowID=""  d
 	.....d ResetVariablesGetStoreDetailRpt
 	.....s TRowID=RLRowID	;$p($g(^DHCEQReturnList(RLRowID)),"^",3)
 	.....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)
 	.....s EQRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",4)
 	.....i EQRowID'="" d
 	......s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
 	......s TModelDR=$p($g(^DHCEQEquip(EQRowID)),"^",3)
 	......s TUnitDR=$p($g(^DHCEQEquip(EQRowID)),"^",5)
 	......s TManuFactoryDR=$p($g(^DHCEQEquip(EQRowID)),"^",26)
 	......s TStatCatDR=$p($g(^DHCEQEquip(EQRowID)),"^",75)
 	.....e  d
 	......s InStockListDR=$p($g(^DHCEQReturnList(TRowID)),"^",3)
 	......s TEquipName=$p($g(^DHCEQInStockList(InStockListDR)),"^",5)
 	......s TModelDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",9)
 	......s TUnitDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",10)
 	......s TManuFactoryDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",6)
 	......s TStatCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",17)
 	.....s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.....s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.....s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
 	.....s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
 	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQReturnList(RLRowID)),"^",6),"",2)
 	.....s TQuantity=0-$p($g(^DHCEQReturnList(RLRowID)),"^",5)
 	.....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	.....s TListRemark=$p($g(^DHCEQReturnList(RLRowID)),"^",9)
 	.....//i TProvider="" s TProvider="--"    //modify by jyp 2018-03-16 554051
 	.....Set equipRowIDs=$Get(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
	.....Set count=$length(equipRowIDs,",")
	.....For i=1:1:count Do
	......Set TEquipDR=+$Piece(equipRowIDs,",",i)
	......If TEquipNoInfo'="" s TEquipNoInfo=TEquipNoInfo_","
	......s TEquipNoInfo=TEquipNoInfo_$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.....;begin add by jyp 2018-03-16 554051
	.....s ISLRowID=$p($g(^DHCEQReturnList(TRowID)),"^",3)
	.....i ((ISLRowID="")||(ISLRowID="0"))  d
	......s EquipID=$p($g(^DHCEQReturnList(TRowID)),"^",4)
	......i TProvider="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",$p($g(^DHCEQEquip(EquipID)),"^",25))
	.....e
	......s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	......i TProvider="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",$p($g(^DHCEQInStock(ISRowID)),"^",17))
    .....;end add by jyp 2018-03-16 554051
	.....s TEquipNoInfo=##Class(web.DHCEQCommon).GetContinueNo(TEquipNoInfo)
 	.....d OutputRowGetStoreDetailRpt
 	
 	s InAckDate=vStartDate-1
 	f  s InAckDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,InAckDate)) q:((InAckDate="")||(InAckDate>vEndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,InAckDate,StatCatDR)) q:StatCatDR=""  d
 	..s MoveTypeDR=""
 	..f  s MoveTypeDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,InAckDate,StatCatDR,MoveTypeDR))  q:MoveTypeDR=""  d
 	...s TBussType=MoveTypeDR
 	...q:(BussType'="")&&(BussType'=TBussType)
 	...s SMRowID=0
 	...f  s SMRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,InAckDate,StatCatDR,MoveTypeDR,SMRowID)) q:SMRowID=""  d
        ....q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)'="N"
 	....s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
 	....//add by ZY20230209 bug:  增加查询条件
	....q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
        ....q:(EquipTypeIDs'="")&&(EquipTypeIDs'[(","_TEquipTypeDR_","))
 	....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
 	....s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
 	....s TManageLocDR=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",10)
 	....s TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	....s TDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(SMRowID)),"^",5),"CHNDate")
 	....s TFromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
 	....q:(FromLocDR'="")&&(TFromLocDR'=FromLocDR)
 	....s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
 	....s TToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
 	....q:(ToLocDR'="")&&(TToLocDR'=ToLocDR)
 	....s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
 	....s TNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
 	....
 	....s SMLRowID=0
 	....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID)) q:SMLRowID=""  d
 	.....d ResetVariablesGetStoreDetailRpt
 	.....s TRowID=SMLRowID
 	.....s TEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
 	.....s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
 	.....s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
 	.....s TUnitDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",10)
 	.....s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
 	.....s TQuantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
 	.....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
 	.....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	.....s TManuFactoryDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",6)
 	.....s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
 	.....s TListRemark=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",11)
	.....
	.....Set equipRowIDs=$Get(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	.....Set count=$length(equipRowIDs,",")
	.....For i=1:1:count Do
	......Set TEquipDR=+$Piece(equipRowIDs,",",i)
	......i TProvider="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",$p($g(^DHCEQEquip(TEquipDR)),"^",25))
	......If TEquipNoInfo'="" s TEquipNoInfo=TEquipNoInfo_","
	......s TEquipNoInfo=TEquipNoInfo_$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.....s TEquipNoInfo=##Class(web.DHCEQCommon).GetContinueNo(TEquipNoInfo)
 	.....d OutputRowGetStoreDetailRpt
 	
 	s TBussType=6		//add by czf 2020-05-21 begin 1281409
 	i (BussType="6")
	{
	 	s TEquipTypeDR=0
	 	f  s TEquipTypeDR=$o(^DHCEQDisuseRequest(0,"TypeDate",TEquipTypeDR)) q:(TEquipTypeDR="")  d
	 	.//add by ZY20230209 bug:  增加查询条件
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
                .q:(EquipTypeIDs'="")&&(EquipTypeIDs'[(","_TEquipTypeDR_","))
	 	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID))
	 	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	 	.s TManageLocDR=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",10)
	 	.s TManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	 	.s BillAuditDate=vStartDate-1
	 	.f  s BillAuditDate=$o(^DHCEQDisuseRequest(0,"TypeDate",TEquipTypeDR,BillAuditDate)) q:(BillAuditDate="")||(BillAuditDate>vEndDate)  d
	 	..s DRRowID=0		//入库单rowID
	 	..f  s DRRowID=$o(^DHCEQDisuseRequest(0,"TypeDate",TEquipTypeDR,BillAuditDate,DRRowID)) q:DRRowID=""  d
	 	...q:$p($g(^DHCEQDisuseRequest(DRRowID)),"^",10)'=2
	 	...q:$p($g(^DHCEQDisuseRequest(DRRowID)),"^",53)'="N"
	 	...s TNo=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",33)
		...s TDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQDisuseRequest(DRRowID)),"^",21),"CHNDate")
		...// MZY0094	2110055		2021-09-13	修正来源库房取值
		...s TToLoc="--"
		...s TFromLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQDisuseRequest(DRRowID)),"^",34))
	 	...s DRLRowID=0
	 	...f  s DRLRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",DRRowID,DRLRowID)) q:DRLRowID=""  d
	 	....d ResetVariablesGetStoreDetailRpt
	 	....s TRowID=DRLRowID
	 	....s TEquipDR=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",2)
	 	....s vendorid=$p($g(^DHCEQEquip(TEquipDR)),"^",25)
	 	....q:(ProviderDR'="")&&(vendorid'=ProviderDR)
	 	....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
	 	....s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	 	....s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	 	....s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	 	....s TUnitDR=$p($g(^DHCEQEquip(TEquipDR)),"^",5)
	 	....s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	 	....s TQuantity=1
	 	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(TEquipDR)),"^",27),"",2)
	 	....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
	 	....s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
		....s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	 	....s TListRemark=""
	 	....s TStatCatDR=$p($g(^DHCEQEquip(TEquipDR)),"^",75)
	 	....s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
		....s TEquipNoInfo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
		....s TEquipNoInfo=##Class(web.DHCEQCommon).GetContinueNo(TEquipNoInfo)
	 	....d OutputRowGetStoreDetailRpt
	}		//add by czf 2020-05-21 end 1281409
	Quit $$$OK
OutputRowGetStoreDetailRpt
	Set Data=$lb(TRowID,TDate,TNo,TManageLoc,TFromLoc,TToLoc,TEquipName,TEquipType,TStatCat,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TManuFactory,TListRemark,TProvider,TEquipNoInfo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreDetailRpt
	Set (TRowID,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TManuFactory,TListRemark,TStatCat,TProvider,TEquipNoInfo)=""
	quit
}

ClassMethod StoreDetailRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StoreDetailRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod StoreDetailRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StoreDetailRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// czf 2022-04-27
/// 入库明细报表
/// 业务类型	TBussType	0:库房分配	1:科室调配	2:设备入库	3:科室退库	4:减少	5:退货  6:报废
/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","InStockListRpt","2022-04-01","2022-04-27","","","","","","329","434","2","13296")
Query InStockListRpt(vStartDate As %String = "", vEndDate As %String = "", ProviderDR As %String = "", EquipTypeDR As %String = "", FromLocDR As %String = "", ToLocDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDate:%String,TNo:%String,TManageLoc:%String,TFromLoc:%String,TToLoc:%String,TEquipName:%String,TEquipType:%String,TStatCat:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TManuFactory:%String,TListRemark:%String,TProvider:%String,TEquipNoInfo:%String,TBillAuditDate:%String,TUseLoc:%String,TLeaveFacNo:%String,TStoreLoc:%String") [ SqlProc ]
{
}

ClassMethod InStockListRptExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", ProviderDR As %String = "", EquipTypeDR As %String = "", FromLocDR As %String = "", ToLocDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	i (vStartDate="")&&(vEndDate="") Quit $$$OK
 	Set index=1
 	//s ^DHCEQMozy("StoreDetailRpt")=vStartDate_","_vEndDate_","_ProviderDR_","_EquipTypeDR_","_FromLocDR_","_ToLocDR_","_CurGroupID_","_CurLocID
 	i vStartDate="" d
	.s vStartDate=0
	e  d
	.Set vStartDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
	i vEndDate="" d
	.s vEndDate=+$H
	e  d
	.Set vEndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
	
	//入库
 	s TEquipTypeDR=0
 	f  s TEquipTypeDR=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR)) q:(TEquipTypeDR="")  d
 	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID,"","",1))
 	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
 	.s TManageLocDR=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",10)
 	.s TManageLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
 	.s BillAuditDate=vStartDate-1
 	.f  s BillAuditDate=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR,BillAuditDate)) q:(BillAuditDate="")||(BillAuditDate>vEndDate)  d
 	..s ISRowID=0		//入库单rowID
 	..f  s ISRowID=$o(^DHCEQInStock(0,"TypeDate",TEquipTypeDR,BillAuditDate,ISRowID)) q:ISRowID=""  d
 	...q:$p($g(^DHCEQInStock(ISRowID)),"^",10)'=2
 	...s vendorid=$p($g(^DHCEQInStock(ISRowID)),"^",17)
 	...q:(ProviderDR'="")&&(vendorid'=ProviderDR)
 	...s TNo=$p($g(^DHCEQInStock(ISRowID)),"^",14)
	...s TDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(ISRowID)),"^",1),"date")   //"CHNDate" add by wy 2017-5-5
	...s TFromLoc="--"
	...s TToLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQInStock(ISRowID)),"^",2))
 	...
 	...s ISLRowID=0
 	...f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID)) q:ISLRowID=""  d
 	....s SLID=0
 	....f  s SLID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,SLID)) q:SLID=""  d
 	.....s TEquipDR=0
 	.....f  s TEquipDR=$o(^DHCEQEquip(0,"InStockList",ISLRowID,SLID,TEquipDR)) q:TEquipDR=""  d
 	......d ResetInStockListRpt
 	......q:$p($g(^DHCEQEquip(TEquipDR)),"^",59)="Y"
 	......s TRowID=TEquipDR
 	......s TBillAuditDate=##class(web.DHCEQCommon).TransValueToPage(BillAuditDate,"date")
 	......s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",vendorid)	//供应商
 	......s TEquipName=$p($g(^DHCEQInStockList(ISLRowID)),"^",5)
 	......s TModelDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",9)
 	......s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
 	......s TUnitDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",10)
 	......s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
 	......s TQuantity=1		//$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
 	......s TReduceValue=##Class(web.DHCEQInStockList).GetReturnInfoOfInstockList(ISLRowID,TEquipDR)
	......s TReduceNum=$p(TReduceValue,"^",1)
	......s TQuantity=TQuantity-TReduceNum
	......q:TQuantity=0
 	......s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQInStockList(ISLRowID)),"^",7),"",2)
 	......s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	......s TManuFactoryDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",6)
	......s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
 	......s TListRemark=$p($g(^DHCEQInStockList(ISLRowID)),"^",12)
 	......s TStatCatDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",17)
 	......s TStatCat=##class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
 	......s TEquipNoInfo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
 	......s TUseLocDR=$p($g(^DHCEQEquip(TEquipDR)),"^",19)
 	......s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
 	......s TLeaveFacNo=$p($g(^DHCEQEquip(TEquipDR)),"^",10)
 	......s TStoreLocDR=$p($g(^DHCEQEquip(TEquipDR)),"^",67)
 	......s TStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	......;i TEquipNoInfo'="" s TEquipNoInfo=TEquipNoInfo_","
	......;s TEquipNoInfo=TEquipNoInfo_$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	......;s TEquipNoInfo=##Class(web.DHCEQCommon).GetContinueNo(TEquipNoInfo)
 	......d OutputInStockListRpt

	Quit $$$OK
OutputInStockListRpt
	Set Data=$lb(TRowID,TDate,TNo,TManageLoc,TFromLoc,TToLoc,TEquipName,TEquipType,TStatCat,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TManuFactory,TListRemark,TProvider,TEquipNoInfo,TBillAuditDate,TUseLoc,TLeaveFacNo,TStoreLoc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetInStockListRpt
	Set (TRowID,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TManuFactory,TListRemark,TStatCat,TProvider,TEquipNoInfo,TUseLocDR,TUseLoc,TLeaveFacNo,TStoreLocDR,TStoreLoc)=""
	quit
}

ClassMethod InStockListRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InStockListRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod InStockListRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InStockListRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// czf 2022-04-27
/// 转移明细报表
/// 业务类型	TBussType	0:库房分配	1:科室调配	3:科室退库
/// IndexOfFlag：0或"",不包含出库 1:包含入出库不同月的设备
/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","StoreMoveListRpt","1","2022-04-01","2022-04-27","","","","","","329","434","2","13296")
Query StoreMoveListRpt(BussType As %String = "", vStartDate As %String = "", vEndDate As %String = "", ProviderDR As %String = "", EquipTypeDR As %String = "", FromLocDR As %String = "", ToLocDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", IndexOfFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDate:%String,TNo:%String,TManageLoc:%String,TFromLoc:%String,TToLoc:%String,TEquipName:%String,TEquipType:%String,TStatCat:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TManuFactory:%String,TListRemark:%String,TProvider:%String,TEquipNoInfo:%String,TBillAuditDate:%String,TTransAssetDate:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod StoreMoveListRptExecute(ByRef qHandle As %Binary, BussType As %String = "", vStartDate As %String = "", vEndDate As %String = "", ProviderDR As %String = "", EquipTypeDR As %String = "", FromLocDR As %String = "", ToLocDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", IndexOfFlag As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	i (vStartDate="")&&(vEndDate="") Quit $$$OK
 	Set index=1
 	//s ^DHCEQMozy("StoreDetailRpt")=$lb(BussType,vStartDate,vEndDate,ProviderDR,EquipTypeDR,FromLocDR,ToLocDR,QXType,CurGroupID,CurLocID,CurHospID,CurUserID)
 	i vStartDate="" d
	.s vStartDate=0
	e  d
	.Set vStartDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
	i vEndDate="" d
	.s vEndDate=+$H
	e  d
	.Set vEndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
	
	//转移
	s InAckDate=vStartDate-1
 	f  s InAckDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,InAckDate)) q:((InAckDate="")||(InAckDate>vEndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,InAckDate,StatCatDR)) q:StatCatDR=""  d
 	..s MoveTypeDR=""
 	..f  s MoveTypeDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,InAckDate,StatCatDR,MoveTypeDR))  q:MoveTypeDR=""  d
 	...s TBussType=MoveTypeDR
 	...q:(IndexOfFlag'=1)&&(BussType'="")&&(BussType'=TBussType)
 	...q:(IndexOfFlag=1)&&((TBussType'=0)&&(TBussType'=1))
 	...s SMRowID=0
 	...f  s SMRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,InAckDate,StatCatDR,MoveTypeDR,SMRowID)) q:SMRowID=""  d
 	....s TBillAuditDate=##class(web.DHCEQCommon).TransValueToPage(InAckDate,"date")
 	....s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
 	....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID,"","",1))
 	....s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
 	....s TManageLocDR=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",10)
 	....s TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	....s TDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(SMRowID)),"^",5),"date")	//"CHNDate"
 	....s TFromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
 	....q:(FromLocDR'="")&&(TFromLocDR'=FromLocDR)
 	....s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
 	....s TToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
 	....q:(ToLocDR'="")&&(TToLocDR'=ToLocDR)
 	....s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
 	....s TNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
 	....s TRemark=$p($g(^DHCEQStoreMove(SMRowID)),"^",14)
 	....s SMLRowID=0
 	....f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID)) q:SMLRowID=""  d
	.....s equipRowIDs=$Get(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	.....s count=$length(equipRowIDs,",")
	.....f i=1:1:count Do
 	......d ResetStoreMoveListRpt
	......s TEquipDR=+$Piece(equipRowIDs,",",i)
 	......s TRowID=TEquipDR
	......s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",$p($g(^DHCEQEquip(TEquipDR)),"^",25))
	......s TEquipNoInfo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	......s TTransAssetDate=$p($g(^DHCEQEquip(TEquipDR)),"^",45)
	......q:(IndexOfFlag=1)&&(TBussType=0)&&($p($zd(TTransAssetDate,3),"-",1,2)=$p($zd(InAckDate,3),"-",1,2))		//过滤出库设备中入库当月就出库的设备
	......s TTransAssetDate=##class(web.DHCEQCommon).TransValueToPage(TTransAssetDate,"date")
 	......s TEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
 	......s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
 	......s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
 	......s TUnitDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",10)
 	......s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
 	......s TQuantity=1	//$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
 	......s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
 	......s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	......s TManuFactoryDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",6)
 	......s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
 	......s TListRemark=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",11)
	......;If TEquipNoInfo'="" s TEquipNoInfo=TEquipNoInfo_","
	......;s TEquipNoInfo=TEquipNoInfo_$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	......;s TEquipNoInfo=##Class(web.DHCEQCommon).GetContinueNo(TEquipNoInfo)
 	......d OutputStoreMoveListRpt

	Quit $$$OK
OutputStoreMoveListRpt
	Set Data=$lb(TRowID,TDate,TNo,TManageLoc,TFromLoc,TToLoc,TEquipName,TEquipType,TStatCat,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TManuFactory,TListRemark,TProvider,TEquipNoInfo,TBillAuditDate,TTransAssetDate,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetStoreMoveListRpt
	Set (TRowID,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TManuFactory,TListRemark,TStatCat,TProvider,TEquipNoInfo,TTransAssetDate)=""
	quit
}

ClassMethod StoreMoveListRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StoreMoveListRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod StoreMoveListRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StoreMoveListRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// MZY0142	3064937		2022-11-11
/// 固定资产明细账
/// 入参：MonthStr:YYYY-MM  该参数必需
/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","FixedAssetsRpt","2022-10","",85)
Query FixedAssetsRpt(MonthStr, EquipTypeDR As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "index:%String,TYear:%String,TMonth:%String,TDate:%String,TEQNo:%String,TEQName:%String,TMoveType:%String,TAbstract:%String,TODebit:%String,TOCreditor:%String,TOSurplus:%String") [ SqlProc ]
{
}

ClassMethod FixedAssetsRptExecute(ByRef qHandle As %Binary, MonthStr, EquipTypeDR As %String = "", CurGroupID As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	;s ^DHCEQMozy("FixedAssetsRpt")=MonthStr_","_EquipTypeDR_","_CurGroupID
 	i MonthStr="" Quit $$$OK
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	s SnapID=SnapID-1
	i SnapID<1 Quit $$$OK
	
	Set StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	Set EndDate=$p(StartDate,"^",2)
	Set StartDate=$p(StartDate,"^",1)
	Set index=1
	Set TempID=$I(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H))
	Do ##Class(web.DHCEQCommon).KillTempGlobalNew("web.DHCEQRunQian.FixedAssetsRpt",TempID)
	;;Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^"_TODebit_"^"_TOCreditor_"^"_TOSurplus
	s TotalFee=0
	s CurOSurplus=0
	s LastYearOSurplus=0
	s LastYearMonthStr=(+MonthStr-1)_"-12"
	s LastYearSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(LastYearMonthStr)
	i LastYearSnapID>0
	{
		s rowid=0
		f  s rowid=$o(^DHCEQSnapShot(LastYearSnapID,"Equip",rowid)) quit:rowid=""  d
		.s gblData=$g(^DHCEQSnapShot(LastYearSnapID,"Equip",rowid))
		.q:$p(gblData,"^",59)="Y"
		.q:$p(gblData,"^",60)=0
		.q:$p(gblData,"^",60)=3
		.q:$p(gblData,"^",38)=3
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=$p(gblData,"^",63))
	 	.q:##Class(web.DHCEQCommon).EquipTypeIsIn($p(gblData,"^",63),CurGroupID)
	 	.s LastYearOSurplus=LastYearOSurplus+$p(gblData,"^",27)
	}
 	
 	
	d ResetVariablesFixedAssetsRpt
	s TYear=$p(MonthStr,"-",1)
	s TMonth=$p(MonthStr,"-",2)
	s TDate="01"
	s TAbstract="上期结转"
	s rowid=0
	f  s rowid=$o(^DHCEQSnapShot(SnapID,"Equip",rowid)) quit:rowid=""  d
	.s gblData=$g(^DHCEQSnapShot(SnapID,"Equip",rowid))
	.q:$p(gblData,"^",59)="Y"
	.q:$p(gblData,"^",60)=0
	.q:$p(gblData,"^",60)=3
	.q:$p(gblData,"^",38)=3
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=$p(gblData,"^",63))
 	.q:##Class(web.DHCEQCommon).EquipTypeIsIn($p(gblData,"^",63),CurGroupID)
 	.s TOSurplus=TOSurplus+$p(gblData,"^",27)
 	s LastOSurplus=TOSurplus
 	d OutputRowFixedAssetsRpt
 	
	
	;0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细 9:数据调整
	//汇总入库信息
	s SourceType="3"
	s TMoveType="购置入库"
	s EquipType=0
	f  s EquipType=$o(^DHCEQInStock(0,"TypeDate",EquipType)) q:EquipType=""  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,CurGroupID)
	.s BillDate=StartDate-1
	.//入账时间可能是在入库之后的跨月,开始日期需要看所有入库单
	.f  s BillDate=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate)) q:(BillDate="")||(BillDate>EndDate)  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInStock(0,"TypeDate",EquipType,BillDate,rowid)) q:(rowid="")  d
	...q:$p($g(^DHCEQInStock(rowid)),"^",25)="Y"
	...q:$p($g(^DHCEQInStock(rowid)),"^",10)'=2
	...q:$p($g(^DHCEQInStock(rowid)),"^",14)=""
	...s tmpBillDate=$zd(BillDate,3)
	...s TYear=$p(tmpBillDate,"-",1)
	...s TMonth=+$p(tmpBillDate,"-",2)
	...s TDate=+$p(tmpBillDate,"-",3)
	...s ListRowID=0
	...f  s ListRowID=$o(^DHCEQInStockList(0,"InStock",rowid,ListRowID)) q:(ListRowID="")  d
	....q:$p($g(^DHCEQInStockList(ListRowID)),"^",22)'=""
	....; ^DHCEQEquip("0","InStockList","0","1","67")
	....s CurStoreLocDR=0
	....f  s CurStoreLocDR=$o(^DHCEQEquip(0,"InStockList",ListRowID,CurStoreLocDR)) q:CurStoreLocDR=""  d
	.....s EQDR=0
	.....f  s EQDR=$o(^DHCEQEquip(0,"InStockList",ListRowID,CurStoreLocDR,EQDR)) q:EQDR=""  d
	......Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^"_$p($g(^DHCEQInStockList(ListRowID)),"^",7)
	
	
	//汇总减少信息
	s SourceType="5"
	s EquipType=0
	f  s EquipType=$o(^DHCEQReturn(0,"TypeDate",EquipType)) q:EquipType=""  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,CurGroupID)
	.s OutType=0
	.f  s OutType=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType)) q:OutType=""  d
	..s TMoveType=$p($g(^DHCEQCCode("DHCEQCOutType",OutType)),"^",2)
	..s BillDate=StartDate-1
	..f  s BillDate=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType,BillDate)) q:(BillDate="")||(BillDate>EndDate)  d
	...s rowid=0
	...f  s rowid=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType,BillDate,rowid)) q:(rowid="")  d
	....q:$p($g(^DHCEQReturn(rowid)),"^",28)="Y"
	....q:$p($g(^DHCEQReturn(rowid)),"^",13)'=2
	....s tmpBillDate=$zd(BillDate,3)
	....s TYear=$p(tmpBillDate,"-",1)
	....s TMonth=+$p(tmpBillDate,"-",2)
	....s TDate=+$p(tmpBillDate,"-",3)
	....s ListRowID=0
	....f  s ListRowID=$o(^DHCEQReturnList(0,"Return",rowid,ListRowID)) q:(ListRowID="")  d
	.....q:($p($g(^DHCEQReturnList(ListRowID)),"^",12)'="")
	.....s equipRowIDs=$G(^DHCEQReturnList(ListRowID,"EX","RowIDs"))
	.....s count=$l(equipRowIDs,",")
	.....f i=1:1:count d
	......s EQDR=$p(equipRowIDs,",",i)
	......q:$Piece($Get(^DHCEQEquip(EQDR,"OtherInfo")),"^",26)'=""
	......Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^^"_$p($g(^DHCEQReturnList(ListRowID)),"^",6)
	
	
	//汇总当期设备报废信息
	s SourceType="6"
	s TMoveType="报废"
	s EquipType=0
	f  s EquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType)) q:EquipType=""  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,CurGroupID)
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid=""))  d
	...q:$p($g(^DHCEQDisuseRequest(rowid)),"^",53)="Y"
	...q:$p($g(^DHCEQDisuseRequest(rowid)),"^",10)'=2
	...s tmpBillDate=$zd(BillDate,3)
	...s TYear=$p(tmpBillDate,"-",1)
	...s TMonth=+$p(tmpBillDate,"-",2)
	...s TDate=+$p(tmpBillDate,"-",3)
	...s ListRowID=0
	...f  s ListRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,ListRowID)) q:(ListRowID="")  d
	....s EQDR=$p($g(^DHCEQDisuseRequestList(ListRowID)),"^",2)
	....q:$Piece($Get(^DHCEQEquip(EQDR,"OtherInfo")),"^",26)'=""
	....Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^^"_$p($g(^DHCEQEquip(EQDR)),"^",27)
	
	
	//汇总当期原值变动信息
	s SourceType="7"
	s TMoveType="调账"
	s EquipType=0
	f  s EquipType=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType)) q:EquipType=""  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,CurGroupID)
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType,BillDate)) q:(BillDate="")||(BillDate>EndDate)  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid=""))  d
	...q:$p($g(^DHCEQChangeAccount(rowid)),"^",2)=0
	...q:$p($g(^DHCEQChangeAccount(rowid)),"^",11)'=2
	...s tmpBillDate=$zd(BillDate,3)
	...s TYear=$p(tmpBillDate,"-",1)
	...s TMonth=+$p(tmpBillDate,"-",2)
	...s TDate=+$p(tmpBillDate,"-",3)
	...s EQDR=$p($g(^DHCEQChangeAccount(rowid)),"^",1)
	...q:$Piece($Get(^DHCEQEquip(EQDR,"OtherInfo")),"^",26)'=""
	...Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,rowid)=TMoveType_"^"_$p($g(^DHCEQChangeAccount(rowid)),"^",2)
	...i $p($g(^DHCEQChangeAccount(rowid)),"^",2)<0 Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,rowid)=TMoveType_"^^"_(-$p($g(^DHCEQChangeAccount(rowid)),"^",2))
	
	
	;汇总处理其他调整的数据,只取影响报表数据的
	s SourceType="9"
	s BillDate=StartDate-1
	f  s BillDate=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate)) q:(BillDate="")||(BillDate>EndDate)  d
	.s AdjustType=0
	.f  s AdjustType=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType)) q:((AdjustType=""))  d
	..s TMoveType=$CASE(AdjustType,"1":"调整数据","2":"新增数据","3":"删除数据","4":"取消报废","9":"其他调整","":"")
	..s rowid=0
	..f  s rowid=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType,rowid)) q:((rowid=""))  d
	...quit:$p($g(^DHCEQAdjustData(rowid)),"^",11)'="1"
	...s tmpBillDate=$zd(BillDate,3)
	...s TYear=$p(tmpBillDate,"-",1)
	...s TMonth=+$p(tmpBillDate,"-",2)
	...s TDate=+$p(tmpBillDate,"-",3)
	...s ListRowID=0
	...f  s ListRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",rowid,ListRowID)) q:((ListRowID=""))  d
	....q:(AdjustType=2)&&(EquipTypeDR'="")&&(EquipTypeDR'=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9))
	....q:(AdjustType=2)&&##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQAdjustDataList(ListRowID)),"^",9),CurGroupID)
	....q:(AdjustType=3)&&(EquipTypeDR'="")&&(EquipTypeDR'=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",4))
	....q:(AdjustType=3)&&##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQAdjustDataList(ListRowID)),"^",4),CurGroupID)
	....q:(AdjustType=4)&&(EquipTypeDR'="")&&(EquipTypeDR'=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9))
	....q:(AdjustType=4)&&##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQAdjustDataList(ListRowID)),"^",9),CurGroupID)
	....s EQDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",2)
	....q:$Piece($Get(^DHCEQEquip(EQDR,"OtherInfo")),"^",26)'=""
	....
	....i AdjustType=2 Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^"_$p($g(^DHCEQAdjustDataList(rowid)),"^",14)
	....i AdjustType=3 Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^^"_$p($g(^DHCEQAdjustDataList(rowid)),"^",14)
	....i AdjustType=4 Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^"_$p($g(^DHCEQAdjustDataList(rowid)),"^",14)
	
	
	d ResetVariablesFixedAssetsRpt
	s TYear=0
	f  s TYear=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear)) q:(TYear="")  d
	.s TMonth=0
	.f  s TMonth=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth)) q:(TMonth="")  d
	..s TDate=0
	..f  s TDate=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate)) q:(TDate="")  d
	...s EQDR=0
	...f  s EQDR=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR)) q:(EQDR="")  d
	....s TEQNo=$p($g(^DHCEQEquip(EQDR)),"^",71)
	....s TEQName=$p($g(^DHCEQEquip(EQDR)),"^",1)
	....s SourceType=0
	....f  s SourceType=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType)) q:(SourceType="")  d
	.....s ListRowID=0
	.....f  s ListRowID=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)) q:(ListRowID="")  d
	......s TMoveType=$p($g(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)),"^",1)
	......s TODebit=$p($g(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)),"^",2)
	......s TOCreditor=$p($g(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)),"^",3)
	......s LastOSurplus=LastOSurplus+TODebit-TOCreditor
	......s TOSurplus=LastOSurplus
	......d OutputRowFixedAssetsRpt
	
	
	d ResetVariablesFixedAssetsRpt
	s TYear=$p(MonthStr,"-",1)
	s TMonth=$p(MonthStr,"-",2)
	s TDate="--"
	s TAbstract="本月合计"
	s TODebit=TotalFee
	d OutputRowFixedAssetsRpt
	
	;w "CurOSurplus:"_CurOSurplus,!
	s LastYearOSurplus=CurOSurplus-LastYearOSurplus
	d ResetVariablesFixedAssetsRpt
	s TYear=$p(MonthStr,"-",1)
	s TMonth=$p(MonthStr,"-",2)
	s TDate="--"
	s TAbstract="本年累计"
	s TODebit=LastYearOSurplus
	d OutputRowFixedAssetsRpt
	
	
 	Quit $$$OK

OutputRowFixedAssetsRpt
	s TotalFee=TotalFee+TODebit
	s TotalFee=TotalFee-TOCreditor
	i TOSurplus>0 s CurOSurplus=TOSurplus
	i TODebit'="" Set TODebit=##Class(web.DHCEQCommon).FormatNumber(TODebit,"")
	i TOCreditor'="" Set TOCreditor=##Class(web.DHCEQCommon).FormatNumber(TOCreditor,"")
	i TOSurplus'="" Set TOSurplus=##Class(web.DHCEQCommon).FormatNumber(TOSurplus,"")
	Set Data=$lb(index,TYear,##Class(web.DHCEQCCounter).LPAD(TMonth,"0",2),##Class(web.DHCEQCCounter).LPAD(TDate,"0",2),TEQNo,TEQName,TMoveType,TAbstract,TODebit,TOCreditor,TOSurplus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesFixedAssetsRpt
	Set (TYear,TMonth,TDate,TEQNo,TEQName,TMoveType,TAbstract,TODebit,TOCreditor,TOSurplus)=""
	Quit
}

ClassMethod FixedAssetsRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FixedAssetsRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FixedAssetsRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FixedAssetsRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// MZY0142	3064937		2022-11-11
/// 固定资产折旧明细账
/// 入参：MonthStr:YYYY-MM  该参数必需
/// d ##class(%ResultSet).RunQuery("web.DHCEQRunQian","FixedAssetsDepreRpt","2022-06","5",85)
Query FixedAssetsDepreRpt(MonthStr, EquipTypeDR As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "index:%String,TYear:%String,TMonth:%String,TDate:%String,TEQNo:%String,TEQName:%String,TMoveType:%String,TAbstract:%String,TODebit:%String,TOCreditor:%String,TOSurplus:%String") [ SqlProc ]
{
}

ClassMethod FixedAssetsDepreRptExecute(ByRef qHandle As %Binary, MonthStr, EquipTypeDR As %String = "", CurGroupID As %String = "") As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	;s ^DHCEQMozy("FixedAssetsDepreRpt")=MonthStr_","_EquipTypeDR_","_CurGroupID
 	i MonthStr="" Quit $$$OK
	s SnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(MonthStr)
	s SnapID=SnapID-1
	i SnapID<1 Quit $$$OK
	
	Set StartDate=##Class(web.DHCEQReport).GetReportDate(MonthStr,"","")
	Set EndDate=$p(StartDate,"^",2)
	Set StartDate=$p(StartDate,"^",1)
	Set index=1
	Set TempID=$I(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H))
	Do ##Class(web.DHCEQCommon).KillTempGlobalNew("web.DHCEQRunQian.FixedAssetsDepreRpt",TempID)
	;;Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^"_TODebit_"^"_TOCreditor_"^"_TOSurplus
	
	
	s TotalFee=0
	s CurOSurplus=0
	s LastYearOSurplus=0
	s LastYearMonthStr=(+MonthStr-1)_"-12"
	s LastYearSnapID=##Class(web.DHCEQSnapShot).GetSnapIDByMonth(LastYearMonthStr)
	i LastYearSnapID>0
	{
		s rowid=0
		f  s rowid=$o(^DHCEQSnapShot(LastYearSnapID,"Equip",rowid)) quit:rowid=""  d
		.s gblData=$g(^DHCEQSnapShot(LastYearSnapID,"Equip",rowid))
		.q:$p(gblData,"^",59)="Y"
		.q:$p(gblData,"^",60)=0
		.q:$p(gblData,"^",60)=3
		.q:$p(gblData,"^",38)=3
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=$p(gblData,"^",63))
	 	.q:##Class(web.DHCEQCommon).EquipTypeIsIn($p(gblData,"^",63),CurGroupID)
	 	.s LastYearOSurplus=LastYearOSurplus+$p(gblData,"^",35)
	}
	
	
	d ResetVariablesFixedAssetsDepreRpt
	s TYear=$p(MonthStr,"-",1)
	s TMonth=$p(MonthStr,"-",2)
	s TDate="01"
	s TAbstract="上期结转"
	s rowid=0
	f  s rowid=$o(^DHCEQSnapShot(SnapID,"Equip",rowid)) quit:rowid=""  d
	.s gblData=$g(^DHCEQSnapShot(SnapID,"Equip",rowid))
	.q:$p(gblData,"^",59)="Y"
	.q:$p(gblData,"^",60)=0
	.q:$p(gblData,"^",60)=3
	.q:$p(gblData,"^",38)=3
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=$p(gblData,"^",63))
 	.q:##Class(web.DHCEQCommon).EquipTypeIsIn($p(gblData,"^",63),CurGroupID)
 	.s TOSurplus=TOSurplus+$p(gblData,"^",35)
 	s LastOSurplus=TOSurplus
 	d OutputRowFixedAssetsDepreRpt
 	
 	
	;0:验收明细 1:设备 2:附件 3:入库明细 4:转移明细 5:退货明细 6:报废明细 7:调账明细 9:数据调整
	//^DHCEQMonthDepre(0,"AuditDate",{MD_MainFlag},{MD_AuditDate},{MD_RowID})	折旧
	d ResetVariablesFixedAssetsDepreRpt
	s SourceType="10"
	s TAbstract="计提折旧"
	s BillDate=StartDate-1
	f  s BillDate=$o(^DHCEQMonthDepre(0,"AuditDate","Y",BillDate)) q:(BillDate="")||(BillDate>EndDate)  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQMonthDepre(0,"AuditDate","Y",BillDate,rowid)) q:(rowid="")  d
	..q:$p($g(^DHCEQMonthDepre(rowid)),"^",20)=3
	..q:$p($g(^DHCEQMonthDepre(rowid)),"^",43)="Y"
	..Set EQDR=$p($g(^DHCEQMonthDepre(rowid)),"^",1)
	..Set EquipType=$Piece($Get(^DHCEQEquip(EQDR)),"^",63)
	..Set BIRowID=$Order(^DHCEQBillInfo(0,"SourceType",10,rowid,0))
	..If BIRowID'="" Set EquipType=$Piece($Get(^DHCEQBillInfo(BIRowID)),"^",3)
	..q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	..q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,CurGroupID)
	..s tmpBillDate=$zd(BillDate,3)
	..s TYear=$p(tmpBillDate,"-",1)
	..s TMonth=+$p(tmpBillDate,"-",2)
	..s TDate=+$p(tmpBillDate,"-",3)
	..Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,rowid)=TMoveType_"^"_TAbstract_"^^"_$p($g(^DHCEQMonthDepre(rowid)),"^",14)
	
	
	//汇总退货减少信息
	s SourceType="5"
	s EquipType=0
	f  s EquipType=$o(^DHCEQReturn(0,"TypeDate",EquipType)) q:EquipType=""  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,CurGroupID)
	.s OutType=0
	.f  s OutType=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType)) q:OutType=""  d
	..s TMoveType=$p($g(^DHCEQCCode("DHCEQCOutType",OutType)),"^",2)
	..s BillDate=StartDate-1
	..f  s BillDate=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType,BillDate)) q:(BillDate="")||(BillDate>EndDate)  d
	...s rowid=0
	...f  s rowid=$o(^DHCEQReturn(0,"TypeDate",EquipType,OutType,BillDate,rowid)) q:(rowid="")  d
	....q:$p($g(^DHCEQReturn(rowid)),"^",28)="Y"
	....q:$p($g(^DHCEQReturn(rowid)),"^",13)'=2
	....s tmpBillDate=$zd(BillDate,3)
	....s TYear=$p(tmpBillDate,"-",1)
	....s TMonth=+$p(tmpBillDate,"-",2)
	....s TDate=+$p(tmpBillDate,"-",3)
	....s ListRowID=0
	....f  s ListRowID=$o(^DHCEQReturnList(0,"Return",rowid,ListRowID)) q:(ListRowID="")  d
	.....q:($p($g(^DHCEQReturnList(ListRowID)),"^",12)'="")
	.....s equipRowIDs=$G(^DHCEQReturnList(ListRowID,"EX","RowIDs"))
	.....s count=$l(equipRowIDs,",")
	.....f i=1:1:count d
	......s EQDR=$p(equipRowIDs,",",i)
	......q:$Piece($Get(^DHCEQEquip(EQDR,"OtherInfo")),"^",26)'=""
	......q:+$Piece($Get(^DHCEQEquip(EQDR)),"^",35)=0
	......Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^^"_$Piece($Get(^DHCEQEquip(EQDR)),"^",35)
	
	
	//汇总当期设备报废信息
	s SourceType="6"
	s TMoveType="报废"
	s EquipType=0
	f  s EquipType=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType)) q:EquipType=""  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,CurGroupID)
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate)) q:((BillDate="")||(BillDate>EndDate))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQDisuseRequest(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid=""))  d
	...q:$p($g(^DHCEQDisuseRequest(rowid)),"^",53)="Y"
	...q:$p($g(^DHCEQDisuseRequest(rowid)),"^",10)'=2
	...s tmpBillDate=$zd(BillDate,3)
	...s TYear=$p(tmpBillDate,"-",1)
	...s TMonth=+$p(tmpBillDate,"-",2)
	...s TDate=+$p(tmpBillDate,"-",3)
	...s ListRowID=0
	...f  s ListRowID=$o(^DHCEQDisuseRequestList(0,"DisuseRequest",rowid,ListRowID)) q:(ListRowID="")  d
	....s EQDR=$p($g(^DHCEQDisuseRequestList(ListRowID)),"^",2)
	....q:$Piece($Get(^DHCEQEquip(EQDR,"OtherInfo")),"^",26)'=""
	....q:+$Piece($Get(^DHCEQEquip(EQDR)),"^",35)=0
	....Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^^"_$Piece($Get(^DHCEQEquip(EQDR)),"^",35)
	
	
	//汇总当期原值变动信息
	s SourceType="7"
	s TMoveType="调账"
	s EquipType=0
	f  s EquipType=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType)) q:EquipType=""  d
	.;q:##Class(web.DHCEQCommon).IdInIds(EquipType,EquipTypeIDs)=0
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=EquipType)
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType,CurGroupID)
	.s BillDate=StartDate-1
	.f  s BillDate=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType,BillDate)) q:(BillDate="")||(BillDate>EndDate)  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQChangeAccount(0,"TypeDate",EquipType,BillDate,rowid)) q:((rowid=""))  d
	...q:+$p($g(^DHCEQChangeAccount(rowid)),"^",33)=0
	...q:$p($g(^DHCEQChangeAccount(rowid)),"^",11)'=2
	...s tmpBillDate=$zd(BillDate,3)
	...s TYear=$p(tmpBillDate,"-",1)
	...s TMonth=+$p(tmpBillDate,"-",2)
	...s TDate=+$p(tmpBillDate,"-",3)
	...s EQDR=$p($g(^DHCEQChangeAccount(rowid)),"^",1)
	...q:$Piece($Get(^DHCEQEquip(EQDR,"OtherInfo")),"^",26)'=""
	...Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,rowid)=TMoveType_"^^"_$p($g(^DHCEQChangeAccount(rowid)),"^",33)
	...i $p($g(^DHCEQChangeAccount(rowid)),"^",33)<0 Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,rowid)=TMoveType_"^^^"_(-$p($g(^DHCEQChangeAccount(rowid)),"^",33))
	
	
	;汇总处理其他调整的数据,只取影响报表数据的
	s SourceType="9"
	s BillDate=StartDate-1
	f  s BillDate=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate)) q:(BillDate="")||(BillDate>EndDate)  d
	.s AdjustType=0
	.f  s AdjustType=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType)) q:((AdjustType=""))  d
	..s TMoveType=$CASE(AdjustType,"1":"调整数据","2":"新增数据","3":"删除数据","4":"取消报废","9":"其他调整","":"")
	..s rowid=0
	..f  s rowid=$o(^DHCEQAdjustData(0,"FlagDate","Y",BillDate,AdjustType,rowid)) q:((rowid=""))  d
	...quit:$p($g(^DHCEQAdjustData(rowid)),"^",11)'="1"
	...s tmpBillDate=$zd(BillDate,3)
	...s TYear=$p(tmpBillDate,"-",1)
	...s TMonth=+$p(tmpBillDate,"-",2)
	...s TDate=+$p(tmpBillDate,"-",3)
	...s ListRowID=0
	...f  s ListRowID=$o(^DHCEQAdjustDataList(0,"AdjustData",rowid,ListRowID)) q:((ListRowID=""))  d
	....q:(AdjustType=2)&&(EquipTypeDR'="")&&(EquipTypeDR'=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9))
	....q:(AdjustType=2)&&##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQAdjustDataList(ListRowID)),"^",9),CurGroupID)
	....q:(AdjustType=3)&&(EquipTypeDR'="")&&(EquipTypeDR'=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",4))
	....q:(AdjustType=3)&&##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQAdjustDataList(ListRowID)),"^",4),CurGroupID)
	....q:(AdjustType=4)&&(EquipTypeDR'="")&&(EquipTypeDR'=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",9))
	....q:(AdjustType=4)&&##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQAdjustDataList(ListRowID)),"^",9),CurGroupID)
	....s EQDR=$p($g(^DHCEQAdjustDataList(ListRowID)),"^",2)
	....q:$Piece($Get(^DHCEQEquip(EQDR,"OtherInfo")),"^",26)'=""
	....
	....i AdjustType=2 Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^^^"_$p($g(^DHCEQAdjustDataList(rowid)),"^",14)
	....i AdjustType=3 Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^^"_$p($g(^DHCEQAdjustDataList(rowid)),"^",14)
	....i AdjustType=4 Set ^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)=TMoveType_"^^^"_$p($g(^DHCEQAdjustDataList(rowid)),"^",14)
	
	
	d ResetVariablesFixedAssetsDepreRpt
	s TYear=0
	f  s TYear=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear)) q:(TYear="")  d
	.s TMonth=0
	.f  s TMonth=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth)) q:(TMonth="")  d
	..s TDate=0
	..f  s TDate=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate)) q:(TDate="")  d
	...s EQDR=0
	...f  s EQDR=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR)) q:(EQDR="")  d
	....;q:8443'=EQDR
	....s TEQNo=$p($g(^DHCEQEquip(EQDR)),"^",71)
	....s TEQName=$p($g(^DHCEQEquip(EQDR)),"^",1)
	....s SourceType=0
	....f  s SourceType=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType)) q:(SourceType="")  d
	.....s ListRowID=0
	.....f  s ListRowID=$o(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)) q:(ListRowID="")  d
	......s TMoveType=$p($g(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)),"^",1)
	......s TAbstract=$p($g(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)),"^",2)
	......s TODebit=$p($g(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)),"^",3)
	......s TOCreditor=$p($g(^DHCEQTemp("web.DHCEQRunQian.FixedAssetsDepreRpt",+$H,TempID,TYear,TMonth,TDate,EQDR,SourceType,ListRowID)),"^",4)
	......s LastOSurplus=LastOSurplus-TODebit+TOCreditor
	......s TOSurplus=LastOSurplus
	......d OutputRowFixedAssetsDepreRpt
	
	
	d ResetVariablesFixedAssetsDepreRpt
	s TYear=$p(MonthStr,"-",1)
	s TMonth=$p(MonthStr,"-",2)
	s TDate="--"
	s TAbstract="本月合计"
	s TOCreditor=TotalFee
	d OutputRowFixedAssetsDepreRpt
	
	s LastYearOSurplus=CurOSurplus-LastYearOSurplus
	d ResetVariablesFixedAssetsDepreRpt
	s TYear=$p(MonthStr,"-",1)
	s TMonth=$p(MonthStr,"-",2)
	s TDate="--"
	s TAbstract="本年累计"
	s TOCreditor=LastYearOSurplus
	d OutputRowFixedAssetsDepreRpt
	
	
 	Quit $$$OK

OutputRowFixedAssetsDepreRpt
	s TotalFee=TotalFee-TODebit
	s TotalFee=TotalFee+TOCreditor
	i TOSurplus>0 s CurOSurplus=TOSurplus
	i TODebit'="" Set TODebit=##Class(web.DHCEQCommon).FormatNumber(TODebit,"")
	i TOCreditor'="" Set TOCreditor=##Class(web.DHCEQCommon).FormatNumber(TOCreditor,"")
	i TOSurplus'="" Set TOSurplus=##Class(web.DHCEQCommon).FormatNumber(TOSurplus,"")
	Set Data=$lb(index,TYear,##Class(web.DHCEQCCounter).LPAD(TMonth,"0",2),##Class(web.DHCEQCCounter).LPAD(TDate,"0",2),TEQNo,TEQName,TMoveType,TAbstract,TODebit,TOCreditor,TOSurplus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesFixedAssetsDepreRpt
	Set (TYear,TMonth,TDate,TEQNo,TEQName,TMoveType,TAbstract,TODebit,TOCreditor,TOSurplus)=""
	Quit
}

ClassMethod FixedAssetsDepreRptFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FixedAssetsDepreRptExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FixedAssetsDepreRptClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FixedAssetsDepreRptExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
