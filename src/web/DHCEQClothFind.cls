Class web.DHCEQClothFind Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQClothFind","GetClothList","")
Query GetClothList(UseLocDR As %String, StoreLocDR As %String, ItemDR As %String, Name As %String, Status As %String, ModelDR As %String, StartDate As %String, EndDate As %String, QXType As %String) As %Query(ROWSPEC = "TRowID:%String,TUseLoc:%String,TName:%String,TModel:%String,TEquipType:%String,TEquipCat:%String,TEquipStatCat:%String,TQuantity:%String,TTQuantity:%String,TRequestInfo:%String,TUseLocDR:%String,TModelDR:%String")
{
}

ClassMethod GetClothListExecute(ByRef qHandle As %Binary, UseLocDR As %String, StoreLocDR As %String, ItemDR As %String, Name As %String, Status As %String, ModelDR As %String, StartDate As %String, EndDate As %String, QXType As %String) As %Status
{
	s vEquipTypeIDs=""
	s vEquipTypeIDs=##class(web.DHCEQCommon).GetSysInfo("990024")  //取到被服类组
	new repid, index,rowid,TotalNum,TTotalNum
	
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=2
 	i StartDate="" s StartDate=0  //modify BY:GBX 2014-5-27 时间查询 GBX0011
	i EndDate="" s EndDate=+$h
 	Set TotalNum=0
 	Set TTotalNum=0
 	
 	s CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s CurGroupID=%session.Get("LOGON.GROUPID")
	
	k ^DHCEQTemp("Cloth",0,"fixedQuantity",$j)
	k ^DHCEQTemp("RentCloth",0,"temporaryQuantity",$j)
	k ^DHCEQTemp("RentCloth",0,"Quantity",$j)
	d BuildDataGetClothList
	
 	Quit $$$OK
BuildDataGetClothList
	s TQuantity=0
	s TTQuantity=0
	
	;用库房做索引查询数据
	s StoreLoc=0
	f  s StoreLoc=$o(^DHCEQEquip(0,"StoreLoc",StoreLoc))  quit:StoreLoc=""  d
	.q:(StoreLocDR'="")&&(StoreLocDR'=StoreLoc)
	.s TQuantity=0
	.s rowid=0
	.f  s rowid=$o(^DHCEQEquip(0,"StoreLoc",StoreLoc,rowid))  quit:rowid=""  d
	..d ResetVariablesGetClothList
	..d CheckGetClothList
	..q:passed=0
	..s UseLoc=$p($g(^DHCEQEquip(rowid)),"^",19)
	..i UseLoc=""  d
	...s UseLoc=StoreLoc
	..q:(UseLocDR'="")&&(UseLocDR'=UseLoc)
	..s TransAssetDate=$p($g(^DHCEQEquip(rowid)),"^",45)
	..q:(TransAssetDate>EndDate)||(TransAssetDate<StartDate)
	..s Item=$p($g(^DHCEQEquip(rowid)),"^",7)
	..q:(ItemDR'="")&(ItemDR'=Item)
	..s EquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	..q:(vEquipTypeIDs'="")&&(vEquipTypeIDs'=EquipTypeDR)  //2014-5-12 GBX0007，增加类组限制
	..s ModelDR = $p(EquipData,"^",3)
	..i ModelDR=""  d
	...s ModelDR=1000001
	..i UseLocDR=""  d
	...s UseLoc=StoreLoc
	...s ^DHCEQTemp("Cloth",0,"fixedQuantity",$j,UseLoc,Item,ModelDR)=+$G(^DHCEQTemp("Cloth",0,"fixedQuantity",$j,UseLoc,Item,ModelDR))+1 
	..e  d
	...s ^DHCEQTemp("Cloth",0,"fixedQuantity",$j,UseLoc,Item,ModelDR)=+$G(^DHCEQTemp("Cloth",0,"fixedQuantity",$j,UseLoc,Item,ModelDR))+1 //2014-5-12  GBX0008 修改被服查询的临时global
	
	;临时被服数量信息存储
	s RowID=0
	s TQuantity=0
	s TRequestInfo=""
	f  s RowID=$o(^DHCEQRent(0,"Status",2,RowID))  quit:RowID=""  d
	.s RentData=^DHCEQRent(RowID)
	.s Item=$P(RentData,"^",7)
	.s UseLoc=$P(RentData,"^",2)
	.s RentTypeDR=$P(RentData,"^",40)
	.q:(vEquipTypeIDs'="")&(vEquipTypeIDs'=RentTypeDR)
	.s TStartDate=$P(RentData,"^",10)
	.q:(TStartDate>EndDate)||(TStartDate<StartDate)
	.s ModelDR=$p(RentData,"^",8)
	.i ModelDR=""  d
	..s ModelDR=1000001
	.s TRequestUserDR=$p(RentData,"^",4)
	.;i TRequestUserDR'=""  d
	.;.s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	.s TQuantity=$P(RentData,"^",39)
	.;s TQuantity=+($G(^DHCEQTemp("RentCloth",0,"Quantity",$j,TRequestUserDR))+TQuantity) 
	.d CheckUserInfo
	.i flag=0  d
	..i TRequestInfo=""  d
	...s TRequestInfo=TRequestUserDR_":"_TQuantity
	..e  d
	...s TRequestInfo=TRequestInfo_";"_TRequestUserDR_":"_TQuantity
	.s TTempQuantity=0
	.s TTempQuantity=+$G(^DHCEQTemp("RentCloth",0,"temporaryQuantity",$j,UseLoc,Item,ModelDR))+TQuantity
	.s TempInfo=0
	.s TempInfo=TTempQuantity_"^"_TRequestInfo
	.s ^DHCEQTemp("RentCloth",0,"temporaryQuantity",$j,UseLoc,Item,ModelDR)=TempInfo
	
	//输出	
	s UseLoc=0	
	f  s UseLoc=$o(^DHCEQTemp("Cloth",0,"fixedQuantity",$j,UseLoc))  quit:UseLoc=""  d
	.s Item=0
	.f  s Item=$o(^DHCEQTemp("Cloth",0,"fixedQuantity",$j,UseLoc,Item))	quit:Item=""  d
	..q:(ItemDR'="")&(ItemDR'=Item)
	..s ModelDR=0
	..f  s ModelDR=$o(^DHCEQTemp("Cloth",0,"fixedQuantity",$j,UseLoc,Item,ModelDR))	quit:ModelDR=""  d
	...s TQuantity=+$G(^DHCEQTemp("Cloth",0,"fixedQuantity",$j,UseLoc,Item,ModelDR))
	...s TotalNum=TotalNum+TQuantity
	...i ModelDR=1000001  d
	....s TModel=""
	...e  d
	....s TModel=$p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	...s TTQuantity=$p($g(^DHCEQTemp("RentCloth",0,"temporaryQuantity",$j,UseLoc,Item,ModelDR)),"^",1)
	...i TTQuantity=""  d
	....s TTQuantity=0
	...s TTotalNum=TTotalNum+TTQuantity
	...s TRequestInfo=$p($g(^DHCEQTemp("RentCloth",0,"temporaryQuantity",$j,UseLoc,Item,ModelDR)),"^",2)
	...d TrancelateUserName
	...s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLoc)
	...s TName=$p(^DHCEQCCode("DHCEQCMasterItem",Item),"^",1)
	...s TEquipTypeDR=$p(^DHCEQCCode("DHCEQCMasterItem",Item),"^",3)
	...i TEquipTypeDR'=""  d
	....s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	...s TEquipCatDR=$p(^DHCEQCCode("DHCEQCMasterItem",Item),"^",4)
	...i TEquipCatDR'=""  d
	....s TEquipCat=$P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	...s TEquipStatCatDR=$p(^DHCEQCCode("DHCEQCMasterItem",Item),"^",5)
	...i TEquipStatCatDR'=""  d
	....s TEquipStatCat=$p(^DHCEQCCode("DHCEQCStatCat",TEquipStatCatDR),"^",2)
	...d OutputRowGetClothList
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0 //2011-01-28 DJ
		d ResetVariablesGetClothList
		s TName="合计:"
		s TQuantity=TotalNum
		s TTQuantity=TTotalNum
		s Data=$lb(TRowID,TUseLoc,TName,TModel,TEquipType,TEquipCat,TEquipStatCat,TQuantity,TTQuantity,TRequestInfo,TUseLocDR,TModelDR)
		Set ^CacheTemp(repid,TotalLoc)=Data

	}
	quit
	
	//modify BY:GBX GBX0012 2014-6-12 整合借被服人的信息	
CheckUserInfo
	s row=1
	s flag=0
	s TTRequestInfo=""
	f  s TTRequestInfo=$p(TRequestInfo,";",row)  q:TTRequestInfo=""  d  //mark
	.s TTQuantity=$p(TTRequestInfo,":",2)
	.s TTRequestUserDR=$p(TTRequestInfo,":",1)
	.i (TRequestUserDR'="")&(TRequestUserDR=TTRequestUserDR)  d
	..s TTQuantity=TTQuantity+TQuantity
	..s flag=1
	..s TTRequestInfo=TTRequestUserDR_":"_TTQuantity
	..s $p(TRequestInfo,";",row)=TTRequestInfo
	.s row=row+1
	quit
TrancelateUserName
	s idx=1
	s TTRequestInfo=""
	f  s TTRequestInfo=$p(TRequestInfo,";",idx)  q:TTRequestInfo=""  d
	.s TRequestUserDR=$p(TTRequestInfo,":",1)
	.s TTTQuantity=$p(TTRequestInfo,":",2)
	.i TRequestUserDR'=""  d
	..s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
	..s TTRequestInfo=TRequestUser_":"_TTTQuantity
	.s $p(TRequestInfo,";",idx)=TTRequestInfo
	.s idx=idx+1
	quit
ResetVariablesGetClothList
	//mark
	s (TRowID,TName,TUseLoc,TUseLocDR,TEquipType,TStoreLoc,TModel,TModelDR,TRequestUser,TRequestUserDR,TEquipCat,TEquipCatDR,TEquipStatCat,TEquipStatCatDR,TModelDR,TStoreLocDR,TInvalidFlag,TStatus,THospitalDR,TRequestInfo,TempInfo,TTemQuantity,InvalidFlag,TStatus)=""
	quit
	
CheckGetClothList
	s EquipData=$g(^DHCEQEquip(rowid))
	
	i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,UseLocDR,CurLocID,CurGroupID)))
	{
		Quit $$$OK
	}
	
	s TStatus = $p($g(^DHCEQEquip(rowid)),"^",38)
	i (Status'="")&(Status'=TStatus)
	{
		s passed=0
		quit
	}
	i (Status="3")
	{
		s passed=0
		quit
	}
	
	s TStoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
	i (StoreLocDR'="")&&(StoreLocDR'=TStoreLocDR)
	{
		s passed=0
		quit
	}	
	;s EquipDR = $p($g(^DHCEQEquip(rowid)),"^",1)
	s TUseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	i TUseLocDR=""  d
	.s TUseLocDR=TStoreLocDR
	i (UseLocDR'="")&&(UseLocDR'=TUseLocDR)
	{
		s passed=0
		quit
	}
	
	
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	if InvalidFlag="Y"
	{
		s passed=0
		quit
	}
	
	s TransAssetDate=$p($g(^DHCEQEquip(rowid)),"^",45)
	i (TransAssetDate>EndDate)||(TransAssetDate<StartDate)
	{
		s passed=0
		quit
	}
	
	s EquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (vEquipTypeIDs'="")&(vEquipTypeIDs'=EquipTypeDR)
	{
		s passed=0
		quit
	}

	s passed=1
	quit
	//输出
OutputRowGetClothList
	s Data=$lb(TRowID,TUseLoc,TName,TModel,TEquipType,TEquipCat,TEquipStatCat,TQuantity,TTQuantity,TRequestInfo,TUseLocDR,TModelDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetClothListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetClothListExecute ]
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

ClassMethod GetClothListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetClothListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
