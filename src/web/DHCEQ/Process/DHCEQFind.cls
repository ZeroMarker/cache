Class web.DHCEQ.Process.DHCEQFind Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/**************************************************************************************/
Query ServiceLookUp(para) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
SELECT SV_Name,
	   SV_RowID,
	   SV_Code
FROM sqluser.DHC_EQCService
where SV_InvalidFlag = 'N' and SV_Name like nvl(:para,'')||'%'
}

/*************************************************************************************/
Query MaintGroupLookUp(para) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
SELECT MG_Desc,
	   MG_RowID,
	   MG_Code
FROM sqluser.DHC_EQMCMaintGroup
where MG_InvalidFlag = 'N' and MG_GroupType='1' and MG_Desc like nvl(:para,'')||'%'
}

/********************************************************************************/
Query GetManuFacturer(Manufacturer As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetManuFacturerExecute(ByRef qHandle As %Binary, Manufacturer As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$LB(0,repid,0)
 	Set Manufacturer=##Class(web.DHCEQCommon).UnEscape(Manufacturer)
 	Set Manufacturer=$ZCONVERT(Manufacturer ,"U")
 	
	Set index=1
	Set rowid=0
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCManufacturer",rowid)) Quit:rowid=""  Do
	.Do ResetGetManuFacturer
	.Set TRowID = rowid
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",10)
	.Quit:InvalidFlag="Y"
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",2)
	.Set TName=$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",rowid)),"^",1)
	.Quit:(Manufacturer'="")&&($ZCONVERT(TCode ,"U")'[Manufacturer)&&($ZCONVERT(TName ,"U")'[Manufacturer)
	.Do OutputGetManuFacturer
	Quit $$$OK
OutputGetManuFacturer
	Set Data=$lb(TName,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetGetManuFacturer
	Set (TName,TRowID,TCode)=""
	Quit
}

ClassMethod GetManuFacturerFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetManuFacturerExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
 	If ind=""
 	{
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
 	{
 		Set Row=^CacheTemp(repid,ind)
 	}
	Set qHandle=$LB(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetManuFacturerClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetManuFacturerExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/***************************************************************************************/
Query GetModel(ItemDR, Name) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetModelExecute(ByRef qHandle As %Binary, ItemDR, valName) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetModelList
	Quit $$$OK
BuildDataGetModelList
	f  s rowid=$o(^DHCEQCCode("DHCEQCModel",rowid))  quit:rowid=""  d
	.d ResetVariablesGetModelList
	.s TRowID = rowid
	.s Flag = $p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",5)
	.q:Flag="Y"
	.s TName = $p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",2)
	.s TCode=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",1)
	.q:(valName'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(valName,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(valName,"U")))
	.s Item=$p($g(^DHCEQCCode("DHCEQCModel",rowid)),"^",4)
	.q:(ItemDR'="")&&(ItemDR'=Item)&&(Item'="")
	.d OutputRowGetModelList
	quit
OutputRowGetModelList
	s Data=$lb(TName,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetModelList
	s (TName,TRowID,TCode)=""
	quit
}

ClassMethod GetModelFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetModelExecute ]
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

ClassMethod GetModelClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetModelExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/********************************************************************************************/
Query GetMasterItem(EquipTypeDR, StatCatDR, Name, AssetType As %Library.String = "", FacilityFlag As %String = "0") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TCatDR:%String,TCat:%String,TUnitDR:%String,TUnit:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String,TDepreMethodDR:%String,TDepreMethod:%String,TLimitYearsNum:%String,THold2:%String,THold2Desc:%String")
{
}

ClassMethod GetMasterItemExecute(ByRef qHandle As %Binary, EquipTypeDR, StatCatDR, Name, AssetType As %Library.String = "", FacilityFlag As %String = "0") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	;Modified by JDL 2011-6-15 JDL0083
	s Hospital=##Class(web.DHCEQCommon).GetHospital()
	i Hospital'=""
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR))  quit:TEquipTypeDR=""  d
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.;add by jdl 2010-3-17  JDL0048
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,"","",FacilityFlag)'=0
		.
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR,rowid))  quit:rowid=""  d
		..d ResetVariablesGetItem
		..d BuildDataGetItem
	}
	else
	{
		s TEquipTypeDR=0
		f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR))  quit:TEquipTypeDR=""  d
		.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipTypeDR)
		.;add by jdl 2010-3-17  JDL0048
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,"","",FacilityFlag)'=0
		.
		.s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,rowid))  quit:rowid=""  d
		..d ResetVariablesGetItem
		..d BuildDataGetItem
	}
	
	Quit $$$OK
	
BuildDataGetItem
	s TRowID = rowid
	s TFlag = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)
	q:TFlag="Y"
	s TName = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s TCode=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	q:(Name'="")&&(($ZCONVERT(TName ,"U")'[$ZCONVERT(Name,"U"))&&($ZCONVERT(TCode,"U")'[$ZCONVERT(Name,"U")))
	
	s TStatCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",5)
	q:(StatCatDR'="")&&(TStatCatDR'="")&&(TStatCatDR'=StatCatDR)
	q:(TStatCatDR'="")&(+AssetType>0)&(AssetType'=$Piece(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",5))	/// Mozy0145	20141017
	i TStatCatDR'="" s TStatCat=$P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	s TCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",4)
	i TCatDR'="" d
	.s TCat=$P(^DHCEQCCode("DHCEQCEquipeCat",TCatDR),"^",2)
	.s TLimitYearsNum=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TCatDR,TStatCatDR)	;Modified by jdl 2012-3-7 JDL0120
	.s TDepreMethodDR=##Class(web.DHCEQCEquipeCat).GetDepreMethodByCatID(TCatDR)
	.i TDepreMethodDR'="" d
	..s TDepreMethod=$p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	
	s THold2=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	i THold2'="" s THold2Desc=$P($g(^CT("HOSP",THold2)),"^",2)
	
	d OutputRowGetItem
	quit
OutputRowGetItem
	s Data=$lb(TName,TRowID,TCode,TCatDR,TCat,TUnitDR,TUnit,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TDepreMethodDR,TDepreMethod,TLimitYearsNum,THold2,THold2Desc) //,ModelDR,ManageLocDR,UseLocDR,GroupDR,ManageUserDR,Model,ManageLoc,UseLoc,ManageUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetItem
	s (TName,TRowID,TCode,TCatDR,TCat,TUnitDR,TUnit,TStatCatDR,TStatCat,TDepreMethodDR,TDepreMethod,TLimitYearsNum,THold2,THold2Desc)=""
	quit
}

ClassMethod GetMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMasterItemExecute ]
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

ClassMethod GetMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/*******************************************************************************/
Query GetEquipType(Desc, GroupID As %Library.String = "", Flag As %Library.String = "0", FacilityFlag As %String = "0") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String") [ SqlProc ]
{
}

ClassMethod GetEquipTypeExecute(ByRef qHandle As %Binary, Desc, GroupID As %Library.String = "", Flag As %Library.String = "0", FacilityFlag As %String = "0") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s vEquipTypeIDs=""
	d BuildDataGetEquipType
	Quit $$$OK
BuildDataGetEquipType
	i Flag="1"  s vEquipTypeIDs=##class(web.DHCEQCommon).GetSysInfo("990024")  
	i ""'=vEquipTypeIDs s vEquipTypeIDs=","_vEquipTypeIDs_","   //2014-9-10 HZY0060 
	s Type=##class(web.DHCEQCommon).GetEquipTypesByGroup(GroupID,"",FacilityFlag) //add by zx 2017-03-20 BUG ZX0036
	if (Type="")  //所有类组
	{
		q
	}
	else  //可访问类组
	{
		s i=$l(Type,"^")
		for j=1:1:i
		{
			s rowid=$p(Type,"^",j)
			d ResetVariablesGetEquipType
			d GetOneEquipType
		}
	}
	quit
GetOneEquipType
	s TRowID=rowid
	s TName=$p(^DHCEQCCode("DHCEQCEquipType",TRowID),"^",2)
	s TCode=$p(^DHCEQCCode("DHCEQCEquipType",TRowID),"^",1)
	s Invaild=$p(^DHCEQCCode("DHCEQCEquipType",TRowID),"^",4)
	q:Invaild="Y"
	q:(TName'[Desc)&&(TCode'[Desc)
	q:(vEquipTypeIDs'="")&&(vEquipTypeIDs'[(","_TRowID_","))
	d OutputRowGetEquipType
	quit
OutputRowGetEquipType
	s Data=$lb(TName,TRowID,TCode)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipType
	s (TName,TRowID,TCode)=""
	quit
}

ClassMethod GetEquipTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipTypeExecute ]
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

ClassMethod GetEquipTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/********************************************************************************/
Query StatCatLookUp(para, para1) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TRemark:%String,TLimitYears:%String")
{
SELECT SC_Desc,
	   SC_RowID,
	   SC_Code,
	   SC_Remark,
	   SC_Hold1 
FROM sqluser.DHC_EQCStatCat,sqluser.DHC_EQCEquipType
where (SC_Desc like nvl(:para,'')||'%') and sc_invalidflag='N' and et_rowid=:para1 and sc_Hold4=et_hold1 and sc_rowid not in (select ens_statcatdr from sqluser.DHC_EQETNotAccessSC where ens_equiptypedr=:para1 and ens_notaccessflag='Y')
}

/************************************************************************/
Query EquipCatLookUp(para) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
SELECT EC_Desc,
	   EC_RowID,
	   EC_Code
FROM sqluser.DHC_EQCEquipeCat
where EC_InvalidFlag = 'N' and EC_Desc like nvl(:para,'')||'%'
}

/****************************************************************************************/
ClassMethod GetVendorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetVendorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetVendorExecute(ByRef qHandle As %Binary, Provider As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Provider=##Class(web.DHCEQCommon).UnEscape(Provider)
 	s Provider=$ZCONVERT(Provider ,"U")
	s index=1
	s rowid=0
	d BuildDataGetVendorInfo
	Quit $$$OK
BuildDataGetVendorInfo
	f  s rowid=$o(^DHCEQCCode("DHCEQCVendor",rowid))  quit:rowid=""  d
	.d ResetVariablesGetVendorInfo
	.s TRowID = rowid	//rowid
	.s InvalidFlag=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",19)
	.q:InvalidFlag="Y"
	.s TCode=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",1)
	.s TName=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",2)
	.q:(Provider'="")&&($ZCONVERT(TCode ,"U")'[Provider)&&($ZCONVERT(TName ,"U")'[Provider)
	.s TContPerson=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",8)
	.s TTel=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",9)
	.s TAddress=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",3)
	.s TFax=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",10)
	.s TBank=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",13)
	.s TBankNo=$p($g(^DHCEQCCode("DHCEQCVendor",rowid)),"^",14)
	.d OutputRowGetVendorInfo
	quit
OutputRowGetVendorInfo
   s Data=$lb(TName,TRowID,TCode,TAddress,TContPerson,TTel,TFax,TBank,TBankNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetVendorInfo
	s (TName,TRowID,TCode,TAddress,TContPerson,TTel,TFax,TBank,TBankNo)=""
	quit
}

ClassMethod GetVendorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetVendorExecute ]
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

Query GetVendor(Provider As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TAddress:%String,TContPerson:%String,TTel:%String,TFax:%String,TBank:%String,TBankNo:%String")
{
}

/*********************************************************************************/
Query GetShortEquip(Equip, vUseLoc, vNeedUseLoc, vStockStatuType As %String = "", vBAFlag As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TNo:%String,TUseLoc:%String,TLeaveFactoryNo:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,EquipType:%String,TFileNo:%String")
{
}

ClassMethod GetShortEquipExecute(ByRef qHandle As %Binary, Equip As %String, vUseLoc, vNeedUseLoc, vStockStatuType As %String = "", vBAFlag As %String = "", QXType As %String = "") As %Status
{
 	new repid, index,rowid
 	new passed
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s Equip=##Class(web.DHCEQCommon).UnEscape(Equip)
	s Equip=$ZCONVERT(Equip,"U")
	i ((vNeedUseLoc=1)&&(vUseLoc="")) Quit $$$OK
	d BuildDataGetShortEquip
	Quit $$$OK
BuildDataGetShortEquip
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.d ResetVariablesGetShortEquip
	.s RowID = rowid
	.d CheckDataGetShortEquip
	.q:passed=0
	.;s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	.s ABCType = $p($g(^DHCEQEquip(rowid)),"^",2)
	.s ModelDR = $p($g(^DHCEQEquip(rowid)),"^",3)
	.i ModelDR '=""  d
	..s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	.s EquiCatDR = $p($g(^DHCEQEquip(rowid)),"^",4)
	.i EquiCatDR '=""  d
	..s EquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",EquiCatDR)),"^",2)
	.s EquipTypeDR=$p($g(^DHCEQEquip(rowid)),"^",63) //add by zx 2015-01-16
	.i EquipTypeDR '="" d
	..s EquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s UnitDR = $p($g(^DHCEQEquip(rowid)),"^",5)
	.i UnitDR '=""  d
	..s Unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	.;s Code = $p($g(^DHCEQEquip(rowid)),"^",6)
	.;s Desc = $p($g(^DHCEQEquip(rowid)),"^",7)
	.s InstallLocDR = $p($g(^DHCEQEquip(rowid)),"^",8)
	.i InstallLocDR '=""  d
	..s InstallLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",InstallLocDR)
	.s InstallDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",9),"date")
	.;s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	.s LeaveFactoryDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",11),"date")
	.s OpenCheckDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",12),"date")
	.s CheckDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",13),"date")
	.s MakeDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",14),"date")
	.s ComputerFlag = $p($g(^DHCEQEquip(rowid)),"^",15)
	.s CountryDR = $p($g(^DHCEQEquip(rowid)),"^",16)
	.i CountryDR '=""  d
	..s Country =##Class(web.DHCEQCommon).GetTrakNameByID("cou",CountryDR)
	.s ManageLocDR = $p($g(^DHCEQEquip(rowid)),"^",17)
	.i ManageLocDR '=""  d
	..s ManageLoc =##Class(web.DHCEQCommon).GetTrakNameByID("dept",ManageLocDR) ; $p($g(^CTLOC(ManageLocDR)),"^",2)	
	.s ManageLevelDR = $p($g(^DHCEQEquip(rowid)),"^",18)
	.i ManageLevelDR '=""  d
	..s ManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",ManageLevelDR)),"^",2)
	.//s UseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	.i UseLocDR '=""  d
	..s UseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	.s OriginDR = $p($g(^DHCEQEquip(rowid)),"^",20)
	.i OriginDR '=""  d
	..s Origin = $p($g(^DHCEQCCode("DHCEQCOrigin",OriginDR)),"^",2)
	.s FromDeptDR = $p($g(^DHCEQEquip(rowid)),"^",21)
	.i FromDeptDR '=""  d
	..s FromDept = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",FromDeptDR)
	.s ToDeptDR = $p($g(^DHCEQEquip(rowid)),"^",22)
	.i ToDeptDR '=""  d
	..s ToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",ToDeptDR)),"^",2)
	.s BuyTypeDR = $p($g(^DHCEQEquip(rowid)),"^",23)
	.i BuyTypeDR '=""  d
	..s BuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",BuyTypeDR)),"^",2)
	.s EquipTechLevelDR  = $p($g(^DHCEQEquip(rowid)),"^",24)
	.s ProviderDR = $p($g(^DHCEQEquip(rowid)),"^",25)
	.i ProviderDR '=""  d
	..s Provider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	.s ManuFactoryDR = $p($g(^DHCEQEquip(rowid)),"^",26)
	.i ManuFactoryDR '=""  d
	..s ManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1)
	.s OriginalFee = $p($g(^DHCEQEquip(rowid)),"^",27)
	.s NetFee = $p($g(^DHCEQEquip(rowid)),"^",28)
	.s NetRemainFee = $p($g(^DHCEQEquip(rowid)),"^",29)
	.s GroupDR = $p($g(^DHCEQEquip(rowid)),"^",30)
	.i GroupDR '=""  d
	..s Group = $p($g(^DHCEQGroup(GroupDR)),"^",2)
	.s LimitYearsNum = $p($g(^DHCEQEquip(rowid)),"^",31)
	.s ContractListDR = $p($g(^DHCEQEquip(rowid)),"^",32)
	.i ContractListDR '=""  d
	..s ContractList = $p($g(^DHCEQContractList(ContractListDR)),"^",1)
	.s DepreMethodDR = $p($g(^DHCEQEquip(rowid)),"^",33)
	.i DepreMethodDR '=""  d
	..s DepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",DepreMethodDR)),"^",2)
	.s Remark = $p($g(^DHCEQEquip(rowid)),"^",34)
	.s DepreTotalFee = $p($g(^DHCEQEquip(rowid)),"^",35)
	.s DesignWorkLoadNum = $p($g(^DHCEQEquip(rowid)),"^",36)
	.s WorkLoadUnitDR = $p($g(^DHCEQEquip(rowid)),"^",37)
	.i WorkLoadUnitDR '=""  d
	..s WorkLoadUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",WorkLoadUnitDR)
	.s Status = $p($g(^DHCEQEquip(rowid)),"^",38)
	.s ManageUserDR = $p($g(^DHCEQEquip(rowid)),"^",39)
	.i ManageUserDR '=""  d
	..s ManageUser =##Class(web.DHCEQCommon).GetTrakNameByID("user",ManageUserDR)
	.s MaintUserDR = $p($g(^DHCEQEquip(rowid)),"^",40)
	.i MaintUserDR '=""  d
	..s MaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",MaintUserDR)
	.s ContactUser = $p($g(^DHCEQEquip(rowid)),"^",41)
	.s ContactMode = $p($g(^DHCEQEquip(rowid)),"^",42)
	.s AppendFeeTotalFee = $p($g(^DHCEQEquip(rowid)),"^",43)
	.s StartDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",44),"date")
	.s TransAssetDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",45),"date")
	.s GuaranteeFlag = $p($g(^DHCEQEquip(rowid)),"^",46)
	.s InputFlag = $p($g(^DHCEQEquip(rowid)),"^",47)
	.s TestFlag = $p($g(^DHCEQEquip(rowid)),"^",48)
	.s MedicalFlag = $p($g(^DHCEQEquip(rowid)),"^",49)
	.s GuaranteeStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",50),"date")
	.s GuaranteeEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",51),"date")
	.s AddUserDR = $p($g(^DHCEQEquip(rowid)),"^",52)
	.i AddUserDR '=""  d
	..s AddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",AddUserDR)
	.s AddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",53),"date")
	.s AddTime = $p($g(^DHCEQEquip(rowid)),"^",54)
	.s UpdateUserDR = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",55),"date")
	.i UpdateUserDR '=""  d
	..s UpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",UpdateUserDR)
	.s UpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(rowid)),"^",56),"date")
	.s UpdateTime = $p($g(^DHCEQEquip(rowid)),"^",57)
	.s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	.;s MemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	.s KeeperDR = $p($g(^DHCEQEquip(rowid)),"^",66)
	.i KeeperDR '=""  d
	..s Keeper = $p($g(^SSU("SSUSR",KeeperDR)),"^",2)
	.s StoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	.i StoreLocDR '=""  d
	..;s StoreLoc = $p($g(^CTLOC(StoreLocDR)),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
	..s StoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)   //modify by jyp 2019-10-18 CTLOC调整
	.s StartDepreMonth = $p($g(^DHCEQEquip(rowid)),"^",68)
	.s ServiceDR = $p($g(^DHCEQEquip(rowid)),"^",69)
	.i ServiceDR '=""  d
	..s Service = $p($g(^DHCEQCCode("DHCEQCService",ServiceDR)),"^",1)
	.s InStockListDR = $p($g(^DHCEQEquip(rowid)),"^",70)
	.i InStockListDR '=""  d
	..s InStockList = $p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	.;s No = $p($g(^DHCEQEquip(rowid)),"^",71)
	.s LocationDR = $p($g(^DHCEQEquip(rowid)),"^",72)
	.s GuaranteePeriodNum = $p($g(^DHCEQEquip(rowid)),"^",73)
	.s StatCatDR=$p($g(^DHCEQEquip(rowid)),"^",75)
	.i StatCatDR'="" d
	..s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2)
	.d OutputRowGetShortEquip
	quit
OutputRowGetShortEquip
	s Data=$lb(Name,RowID,No,UseLoc,LeaveFactoryNo,UseLocDR,ModelDR,Model,EquipTypeDR,EquipType,FileNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetShortEquip
	s (Name,ABCType,ModelDR,EquiCatDR,UnitDR,Code,Desc,InstallLocDR,InstallDate,LeaveFactoryNo,LeaveFactoryDate,OpenCheckDate,CheckDate,MakeDate,ComputerFlag,CountryDR,ManageLocDR,ManageLevelDR,UseLocDR,OriginDR,FromDeptDR,ToDeptDR,BuyTypeDR,EquipTechLevelDR ,ProviderDR,ManuFactoryDR,OriginalFee,NetFee,NetRemainFee,GroupDR,LimitYearsNum,ContractListDR,DepreMethodDR,Remark,DepreTotalFee,DesignWorkLoadNum,WorkLoadUnitDR,Status,ManageUserDR,MaintUserDR,ContactUser,ContactMode,AppendFeeTotalFee,StartDate,TransAssetDate,GuaranteeFlag,InputFlag,TestFlag,MedicalFlag,GuaranteeStartDate,GuaranteeEndDate,AddUserDR,AddDate,AddTime,UpdateUserDR,UpdateDate,UpdateTime,Model,EquiCat,Unit,InstallLoc,Country,ManageLoc,ManageLevel,UseLoc,Origin,FromDept,ToDept,BuyType,Provider,ManuFactory,Group,ContractList,DepreMethod,WorkLoadUnit,ManageUser,MaintUser,AddUser,UpdateUser,FileNo)=""
	quit
CheckDataGetShortEquip
	s passed=1
	s InvalidFlag=$p($g(^DHCEQEquip(rowid)),"^",59)
	i InvalidFlag'="N" s passed=0	// Mozy0072		2011-12-07
	
	;Add by jdl 2011-02-19
	i passed=0 q
	
	//新增:2009-12-02 党军 begin DJ0036
	;s BAFlag=$p($g(^DHCEQEquip(rowid)),"^",81)
	;i (vBAFlag'="")&&(BAFlag'=vBAFlag) s passed=0
	//2009-12-02 党军 end DJ0036
	//修改 2011-02-15 zy begin ZY0052
	i (vBAFlag="Y") d
	.s passed=##Class(web.DHCEQBenefitAnalyReport).CheckEquipID(rowid)
	
	;Add by jdl 2011-02-19
	i passed=0 q
	
	//2011-02-15 zy end ZY0052
	s Name = $p($g(^DHCEQEquip(rowid)),"^",1)
	s Code = $p($g(^DHCEQEquip(rowid)),"^",6)
	s Desc = $p($g(^DHCEQEquip(rowid)),"^",7)
	s EquipType=$p($g(^DHCEQEquip(rowid)),"^",63)
	i (EquipType'="")&&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(EquipType)) s passed=0
	s LeaveFactoryNo = $p($g(^DHCEQEquip(rowid)),"^",10)
	s MemoryCode = $p($g(^DHCEQEquip(rowid)),"^",61)
	s No = $p($g(^DHCEQEquip(rowid)),"^",71)
	Set FileNo=$p($g(^DHCEQEquip(rowid)),"^",85)	//20150819  Mozy0159
	i (Equip'="")&&(($ZCONVERT(Name,"U")'[Equip)&($ZCONVERT(LeaveFactoryNo,"U")'[Equip)&(RowID'=Equip)&($ZCONVERT(MemoryCode,"U")'[Equip)&($ZCONVERT(No,"U")'[Equip)&($ZCONVERT(Code,"U")'[Equip)&($ZCONVERT(FileNo,"U")'[Equip))   d
	.s passed=0
	
	;Add by jdl 2011-02-19
	i passed=0 q
	
	///add by 2007-01-18
	s Status = $p($g(^DHCEQEquip(rowid)),"^",38)
	i ((Status="3")||(Status="4")) d //2010-12-29 DJ
	.s passed=0
	
	s UseLocDR = $p($g(^DHCEQEquip(rowid)),"^",19)
	s StoreLocDR = $p($g(^DHCEQEquip(rowid)),"^",67)
	i StoreLocDR'=""  d //2010-10-28 DJ
	.i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,StoreLocDR)))  d 
	..s passed=0
	
	;Add by jdl 2011-02-19
	i passed=0 q
	
	i (vUseLoc'="")
	{
		i ((Status="0")||(Status="2"))
			{	if (vUseLoc'=StoreLocDR) s passed=0}
		elseif  (vUseLoc'=UseLocDR) 
			{	s passed=0}
	}
	
	;Add by jdl 2011-02-19
	i passed=0 q
	
	s StockStatus = $p($g(^DHCEQEquip(rowid)),"^",60)
	i vStockStatuType="" d
	.i ((StockStatus="0")||(StockStatus="3")) s passed=0
	e  d
	.s Flag=##class(web.DHCEQBuyRequest).StringIsIn(vStockStatuType,StockStatus)
	.i Flag="N" s passed=0
	///end
	quit
}

ClassMethod GetShortEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortEquipExecute ]
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

ClassMethod GetShortEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/****************************************************************/
Query MaintTypeLookUp(para, type) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
SELECT MT_Desc,
	   MT_RowID,
	   MT_Code
FROM sqluser.DHC_EQCMaintType
where MT_InvalidFlag = 'N' and MT_Desc like nvl(:para,'')||'%' and MT_Type =:type
}

/********************************************************************************************/
Query GetPlanName(BussType, Name, EquipDR As %String = "", MaintLocDR As %String = "", QXType As %String = "") As %Query(ROWSPEC = "TName:%String,Hidden:%String,TSourceType:%String,TSourceID:%String")
{
}

ClassMethod GetPlanNameExecute(ByRef qHandle As %Binary, BussType, Name, EquipDR, MaintLocDR, QXType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQMaintPlan(0,"Type",BussType,rowid))  quit:rowid=""  d
	.d ResetVariablesGetPlanName
	.s TRowID = rowid
	.Quit:$p($g(^DHCEQMaintPlan(rowid)),"^",36)="Y"
	.Quit:$p($g(^DHCEQMaintPlan(rowid)),"^",26)'="2"
	.s TName = $p($g(^DHCEQMaintPlan(rowid)),"^",1)
	.q:(Name'="")&&(TName'[Name)
	.i EquipDR'="" q:##Class(web.DHCEQMaintPlanNew).CheckPlanByEquipID(rowid,EquipDR)=0
	.s TSourceType = $p($g(^DHCEQMaintPlan(rowid)),"^",3)
	.s TSourceID = $p($g(^DHCEQMaintPlan(rowid)),"^",4)
	.i TSourceType=1  d
	..s TSourceID=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TSourceID)),"^",2)
	.e  i TSourceType=2  d
	..s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",1)
	.e  i TSourceType=3  d
	..s TSourceID=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	.i TSourceType'=""  s TSourceType =$CASE(TSourceType,"1":"设备分类","2":"设备项","3":"设备")
	.s TMaintFee = $p($g(^DHCEQMaintPlan(rowid)),"^",13)
	.S TMaintFee=TMaintFee+##Class(web.DHCEQMaintPlanNew).GetOtherFee(rowid,1)
	.s TMaintLocDR = $p($g(^DHCEQMaintPlan(rowid)),"^",14)
	.q:(TMaintLocDR'=MaintLocDR)&(MaintLocDR'="")
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TMaintLocDR))) //2010-10-28 DJ
	.;i TMaintLocDR '="" s TMaintLoc = $p($g(^CTLOC(TMaintLocDR)),"^",2)  //modify by jyp 2019-10-18 CTLOC调整
	.i TMaintLocDR '="" s TMaintLoc =##class(web.DHCEQCommon).GetTrakNameByID("dept",TMaintLocDR)  //modify by jyp 2019-10-18 CTLOC调整
	.d OutputRowGetPlanName
	Quit $$$OK
OutputRowGetPlanName
	s Data=$lb(TName,TRowID,TSourceType,TSourceID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetPlanName
	s (TRowID,TName,TSourceType,TSourceID)=""
	quit
}

ClassMethod GetPlanNameFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPlanNameExecute ]
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

ClassMethod GetPlanNameClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPlanNameExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy0068	2011-11-09
/// 获取医院信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQFind","GetHospital")
Query GetHospital(Hospital As %Library.String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,Code:%String")
{
}

ClassMethod GetHospitalExecute(ByRef qHandle As %Binary, Hospital As %Library.String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set job=$job
	
	Set rowid=0
	For  Set rowid=$Order(^CT("HOSP",rowid)) Quit:rowid=""  Do
	.Set hospitalid=rowid
	.Set desc=$Piece($Get(^CT("HOSP",hospitalid)),"^",2)
	.Set code=$Piece($Get(^CT("HOSP",hospitalid)),"^",1)
	.Set Hospital=$ZCONVERT(Hospital,"U")
	.Quit:(Hospital'="")&($ZCONVERT(desc,"U")'[Hospital)
	.Set ^DHCEQTemp("HospitalTemp",job,$ZCONVERT(desc,"U"),hospitalid)=""

	Set hospitaldesc=""
	For  Set hospitaldesc=$Order(^DHCEQTemp("HospitalTemp",job,hospitaldesc)) Quit:hospitaldesc=""  Do
	.Set hospitalid=0
	.For  Set hospitalid=$Order(^DHCEQTemp("HospitalTemp",job,hospitaldesc,hospitalid)) Quit:hospitalid=""  Do
	..Set desc=$Piece($Get(^CT("HOSP",hospitalid)),"^",2)
	..Set code=$Piece($Get(^CT("HOSP",hospitalid)),"^",1)
	..Do OutputRowGetHospital
	Kill ^DHCEQTemp("HospitalTemp",job)
	
	Quit $$$OK
OutputRowGetHospital
	Set Data=$lb(desc,hospitalid,code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetHospitalFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetHospitalExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetHospitalClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetHospitalExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取资金来源类型代码信息
Query FundsType(FundsTypeID As %String = "", FundsType As %String = "", FundsTypeIDs As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod FundsTypeExecute(ByRef qHandle As %Binary, FundsTypeID As %String = "", FundsType As %String = "", FundsTypeIDs As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
        i FundsTypeIDs'="" s FundsTypeIDs=","_FundsTypeIDs_","
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCFundsType",rowid))  quit:rowid=""  d
	.q:(FundsTypeID'="")&(FundsTypeID'=rowid)
        .q:(FundsTypeIDs'="")&&(FundsTypeIDs'[(","_rowid_","))
	.s TRowID = rowid	//rowid
	.s TCode = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",1)	//代码
	.s TDesc = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",2)	//描述
	.q:(FundsType'="")&&($ZCONVERT(TDesc,"U")'[FundsType)&&($ZCONVERT(TCode,"U")'[FundsType) //add by jyp 2018-02-26 546003
	.s TRemark = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",3)	//备注
	.s TInvalidFlag = $p($g(^DHCEQCCode("DHCEQCFundsType",rowid)),"^",4) //无效标志
	.q:TInvalidFlag="Y"
	.d OutputRowGetFundsType
	Quit $$$OK
OutputRowGetFundsType
	s Data=$lb(TDesc,TRowID,TCode,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod FundsTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FundsTypeExecute ]
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

ClassMethod FundsTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FundsTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetCountry(Country) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetCountryExecute(ByRef qHandle As %Binary, Country) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Country=$ZCONVERT(Country,"U")	//2014-07-21 DJ0125 国别检索处理
	s rowid=0
	f  s rowid=$o(^CT("COU",rowid))  q:rowid=""  d
	.s Desc=$p($g(^CT("COU",rowid)),"^",2)
	.s Code=$p($g(^CT("COU",rowid)),"^",1)
	.q:(Country'="")&&($ZCONVERT(Desc,"U")'[Country)&&($ZCONVERT(Code,"U")'[Country)
	.d OutputRowGetCountry
	
	//如果为空遍历所有国别
	/*
	if Country=""
	{
		s rowid=0
		f  s rowid=$o(^CT("COU",rowid))  q:rowid=""  d
		.d OutputRowGetCountry
	}
	else
	{
		//根据Code遍历前匹配的国别
		s Country=$ZCONVERT(Country,"U")
		s code=$o(^CT("COU",0,"Code",Country),-1)
		f  s code=$o(^CT("COU",0,"Code",code))  q:((code="")||(code'[Country))  d
		.s rowid=0
		.f  s rowid=$o(^CT("COU",0,"Code",code,rowid))   q:rowid=""  d
		..S ^DHCEQTemp("StoreCountry",$J,rowid)=""
		
		s desc=$o(^CT("COU",0,"Desc",Country),-1)
		f  s desc=$o(^CT("COU",0,"Desc",desc))  q:((desc="")||(desc'[Country))  d
		.s rowid=0
		.f  s rowid=$o(^CT("COU",0,"Desc",desc,rowid))   q:rowid=""  d
		..S ^DHCEQTemp("StoreCountry",$J,rowid)=""
		
		s rowid=0
		f  s rowid=$o(^DHCEQTemp("StoreCountry",$J,rowid))   q:rowid=""  d
		.d OutputRowGetCountry
		
		///删除临时global
		k ^DHCEQTemp("StoreCountry",$J)
	}
	*/
    	Quit $$$OK
OutputRowGetCountry
	s Desc=$p($g(^CT("COU",rowid)),"^",2)
	s Code=$p($g(^CT("COU",rowid)),"^",1)
	
	s Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetCountryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCountryExecute ]
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

ClassMethod GetCountryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCountryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modified By jdl 20150906 v4.1.0 单位改为存储DHC_EQCUOM表中，不再存储CT_UOM中
Query GetUOM(desc As %String, type As %String) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetUOMExecute(ByRef qHandle As %Binary, desc As %String, type As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCUOM","0","UOMType",type,rowid)) q:rowid=""  d
	.s id=rowid				;s id=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",1)
	.;q:id=""
	.s unitdesc=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",4)			;s unitdesc=$p($g(^CT("UOM",id)),"^",2)
	.s unitcode=$p($g(^DHCEQCCode("DHCEQCUOM",rowid)),"^",3)			;s unitcode=$p($g(^CT("UOM",id)),"^",1)
	.q:unitdesc'[desc
 	.Do OutputRowGetGetUOM	 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetGetUOM
	set Data=$lb(unitdesc,id,unitcode)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetUOMFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUOMExecute ]
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

ClassMethod GetUOMClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUOMExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","GetBrand","","")
Query GetBrand(ManuFactoryDR, valName) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetBrandExecute(ByRef qHandle As %Binary, ManuFactoryDR, valName) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetBrandList
	Quit $$$OK
BuildDataGetBrandList
	f  s rowid=$o(^DHCEQCCode("DHCEQCBrand",rowid))  quit:rowid=""  d
	.d ResetVariablesGetBrandList
	.s RowID = rowid
	.s Flag = $p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",5)
	.q:Flag="Y"
	.s Name = $p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",3)
	.s Code=$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",2)
	.q:(valName'="")&&(($ZCONVERT(Name ,"U")'[$ZCONVERT(valName,"U"))&&($ZCONVERT(Code,"U")'[$ZCONVERT(valName,"U")))
	.s ManuFactory=$p($g(^DHCEQCCode("DHCEQCBrand",rowid)),"^",1)
	.q:(ManuFactoryDR'="")&&(ManuFactoryDR'=ManuFactory)&&(ManuFactory'="")
	.d OutputRowGetBrandList
	quit
OutputRowGetBrandList
	s Data=$lb(Name,RowID,Code)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetBrandList
	s (Name,RowID,Code)=""
	quit
}

ClassMethod GetBrandFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBrandExecute ]
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

ClassMethod GetBrandClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBrandExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","GetAssetItemList","","","")
Query GetAssetItemList(Code, Desc, AssetClass) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetAssetItemListExecute(ByRef qHandle As %Binary, Code, Desc, AssetClass) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	s rowid=0
 	f  s rowid=$O(^DHCEQPCCT("DHCEQPCCAssetItem",rowid)) q:rowid=""  d
 	.s (TDesc,TRowID,TCode,TMICycleUnit)=""
 	.s TInvalidFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",14)
 	.q:TInvalidFlag="Y"
 	.s TRowID=rowid
 	.s TCode=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",1)
 	.s TDesc=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",2)
 	.q:(Code'="")&(TCode'[Code)
 	.q:(Desc'="")&(TDesc'[Desc)
 	.s TAssetClassDR=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",3)
 	.q:(AssetClass'="")&(TAssetClassDR'=AssetClass)
 	.i TAssetClassDR'="" s TAssetClass=$P(^DHCEQPCCT("DHCEQPCCAssetClass",TAssetClassDR),"^",2)
 	.s TDrugFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",4)
 	.//q:(DrugFlag="Y")&(TDrugFlag'=DrugFlag)
 	.s TMedicalDeviceFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",5)
 	.//q:(MedicalDeviceFlag="Y")&(TMedicalDeviceFlag'=MedicalDeviceFlag)
 	.s TMeterageFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",6)
 	.//q:(MeterageFlag="Y")&(TMeterageFlag'=MeterageFlag)
 	.i TMeterageFlag="Y" d
 	..s TMICycleNum=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",7)
 	..s TMICycleUnitDR=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",8)
 	..i TMICycleUnitDR'="" s TMICycleUnit=$P(^DHCEQCCode("DHCEQCCycleUnit",TMICycleUnitDR),"^",2)
 	..s TMICycle=TMICycleNum_TMICycleUnit
 	.s TUnitDR=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",9)
 	.//q:(Unit'="")&(TUnitDR'=Unit)
 	.i TUnitDR'="" s TUnit=$P(^DHCEQCCode("DHCEQCUOM",TUnitDR),"^",4)
 	.s TRadiationFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",10)
 	.//q:(RadiationFlag="Y")&(TRadiationFlag'=RadiationFlag)
 	.s TRemark=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",11)
 	.s TDateFrom=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",12)
 	.s TDateTo=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",13)
 	.//q:(DateFrom'="")&(TDateFrom<DateFrom)
 	.//q:(DateTo'="")&(TDateTo>DateTo)
 	.//q:(Remark'="")&(TRemark'[Remark)
 	.i TDateFrom'="" s TDateFrom=##Class(web.DHCEQCommon).TransValueFromPage(TDateFrom,"data")  //add by zx 2017-03-02
 	.i TDateTo'="" s TDateTo=##Class(web.DHCEQCommon).TransValueFromPage(TDateTo,"data")  //add by zx 2017-03-02
 	.s TInfectionFlag=$P(^DHCEQPCCT("DHCEQPCCAssetItem",rowid),"^",15)
 	.d OutputRowGetAssetItemList
 	
	Quit $$$OK
OutputRowGetAssetItemList
	s Data=$lb(TDesc,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetAssetItemListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAssetItemListExecute ]
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

ClassMethod GetAssetItemListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAssetItemListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","GetPCCCompany","","","")
Query GetPCCCompany(Code, Desc, TypeDR) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetPCCCompanyExecute(ByRef qHandle As %Binary, Code, Desc, TypeDR) As %Status
{
 	n repid, index,rowid
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
	s index=1
	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
	s rowid=0	
	f  s rowid=$o(^DHCEQPCCCompany("DHCEQPCCCompany",rowid)) q:rowid=""  d
	.q:(##Class(web.DHCEQPC.DHCEQPCCCompany).CheckCompanyType(TypeDR,rowid))  ;Add By QW20160523
	.s (InvalidFlag,TName,TRowID,TCode)=""
	.s InvalidFlag=$p($g(^DHCEQPCCCompany("DHCEQPCCCompany",rowid)),"^",22)
	.q:InvalidFlag="Y"
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQPCCCompany("DHCEQPCCCompany",rowid)),"^",1)
	.q:(Code'="")&&($ZCONVERT(TCode,"U")'[Code)
	.s TName=$p($g(^DHCEQPCCCompany("DHCEQPCCCompany",rowid)),"^",2)
	.q:(Desc'="")&&($ZCONVERT(TName,"U")'[Desc)
	.d OutputRowGetPCCCompany
	
	Quit $$$OK
OutputRowGetPCCCompany
	s RowID=index
	s Data=$lb(TName,TRowID,TCode)
  	s ^CacheTemp(repid,index)=Data
	s index=index+1
	quit
}

ClassMethod GetPCCCompanyFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPCCCompanyExecute ]
{
	s AtEnd=$LIST(qHandle,1)
 	s repid=$LIST(qHandle,2)
 	s ind=$LIST(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	if ind="" {
 		s AtEnd=1
 		s Row=""
 		}
 	else      {
 		s Row=^CacheTemp(repid,ind)
 		}
	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetPCCCompanyClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPCCCompanyExecute ]
{
	s repid=$LIST(qHandle,2)
 	kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","GetProduct","","")
Query GetProduct(Code, Desc) As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetProductExecute(ByRef qHandle As %Binary, Code, Desc) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	s rowid=0
 	f  s rowid=$O(^DHCEQPCCCompany("DHCEQPCCProduct",rowid)) q:rowid=""  d
 	.s (TRowID,TCode,TDesc)=""
 	.s ProductInfo=^DHCEQPCCCompany("DHCEQPCCProduct",rowid)
 	.s TInvalidFlag=$P(ProductInfo,"^",23)
 	.q:TInvalidFlag="Y"
 	.s TRowID=rowid
 	.s TCode=$P(ProductInfo,"^",1)
 	.q:(Code'="")&(TCode'[Code)
 	.s TName=$P(ProductInfo,"^",2)
 	.q:(Desc'="")&(TName'[Desc)
 	.d OutputRowGetProduct
	Quit $$$OK
OutputRowGetProduct
	s Data=$lb(TName,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetProductClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProductExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetProductFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProductExecute ]
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

/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","GetAssetType","","")
Query GetAssetType() As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetAssetTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	s rowid=0
 	f  s rowid=$O(^DHCEQPCCT("DHCEQPCCAssetType",rowid)) q:rowid=""  d
 	.s (TName,TRowID,TCode)=""
 	.q:$P(^DHCEQPCCT("DHCEQPCCAssetType",rowid),"^",6)="Y"  ;无效标志
 	.s TRowID=rowid
 	.s TCode=$P(^DHCEQPCCT("DHCEQPCCAssetType",rowid),"^",1) ;代码
 	.s TName=$P(^DHCEQPCCT("DHCEQPCCAssetType",rowid),"^",2) ;描述
 	.d OutputRowGetAssetType
	Quit $$$OK
OutputRowGetAssetType
	s Data=$lb(TName,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetAssetTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAssetTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetAssetTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAssetTypeExecute ]
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

/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","GetCompanyType","","")
Query GetCompanyType() As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetCompanyTypeExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	
 	s rowid=0
 	f  s rowid=$O(^DHCEQPCCT("DHCEQPCCCompanyType",rowid)) q:rowid=""  d
 	.s (TName,TRowID,TCode)=""
 	.q:$P(^DHCEQPCCT("DHCEQPCCCompanyType",rowid),"^",6)="Y"  ;无效标志
 	.s TRowID=rowid
 	.s TCode=$P(^DHCEQPCCT("DHCEQPCCCompanyType",rowid),"^",1) ;代码
 	.s TName=$P(^DHCEQPCCT("DHCEQPCCCompanyType",rowid),"^",2) ;描述
 	.d OutputRowGetCompanyType
 	
	Quit $$$OK
OutputRowGetCompanyType
	s Data=$lb(TName,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetCompanyTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCompanyTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCompanyTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCompanyTypeExecute ]
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

/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","FaultCase","","","")
Query FaultCase(Code As %String = "", Desc As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String,TRemark:%String,TInvalidFlage:%String,TJob:%String")
{
}

ClassMethod FaultCaseExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")

	s index=1
	s rowid=0
	
	//s TJob=$j
	
	d BuildDataGetFaultCase
	
	//d ##Class(web.DHCEQCommon).SetPageInfo("DHCEQMCFaultCase.FaultCase",TJob,index-1)
	
	Quit $$$OK
BuildDataGetFaultCase
	f  s rowid=$o(^DHCEQCCode("DHCEQMCFaultCase",rowid))  quit:rowid=""  d
	.d ResetVariablesGetFaultCase
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",1) //代码
	.s TName=$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",2) //描述
	.s LTRemark=$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",3) //备注
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCFaultCase",rowid)),"^",4) //无符号标志
	.q:LTInvalidFlag="Y"
	.q:($ZCONVERT(LTCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(LTDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(LTRemark,"U")'[Remark)&(Remark'="")
	.d OutputRowGetFaultCase
	quit
OutputRowGetFaultCase
   	s Data=$lb(TRowID,TCode,TName,LTRemark,LTInvalidFlag,TJob)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFaultCase
	s (LTRowID,LTCode,LTDesc,LTRemark,LTInvalidFlag)=""
	quit
}

ClassMethod FaultCaseFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FaultCaseExecute ]
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

ClassMethod FaultCaseClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FaultCaseExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","Faultreason","","","")
Query Faultreason(Code As %String = "", Desc As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String,TRemark:%String,TInvalidFlag:%String")
{
}

ClassMethod FaultreasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FaultreasonExecute ]
{
	Set repid=$LIST(qHandle,2)
    Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod FaultreasonExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 Set qHandle=$lb(0,repid,0)
 s Desc=$ZCONVERT(Desc ,"U")		//转换为大写?
 s Code=$ZCONVERT(Code ,"U")
 s Remark=$ZCONVERT(Remark ,"U")

 //s Type=$ZCONVERT(Type ,"U")
	s index=1
	s rowid=0
	d BuildDataGetFaultreason
	Quit $$$OK
BuildDataGetFaultreason
	f  s rowid=$o(^DHCEQCCode("DHCEQMCFaultReason",rowid))  quit:rowid=""  d
	.d ResetVariablesGetFaultreason
	.s TRowID = rowid	//rowid
	.s TCode=$p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",1) //代码	
	.s TDesc=$p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",2) //描述	
	.s TRemark=$p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",3) //备注
	.s TInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",4) //无符号标志
	.//s TType=$p($g(^DHCEQCCode("DHCEQMCFaultReason",rowid)),"^",4) //替换内容
	.q:TInvalidFlag="Y"
	.q:($ZCONVERT(TCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(TDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(TRemark,"U")'[Remark)&(Remark'="")
	.//q:($ZCONVERT(TType,"U")'[Type)&(Type'="")	
	.d OutputRowGetFaultreason
	quit
OutputRowGetFaultreason
    s Data=$lb(TRowID,TCode,TDesc,TRemark,TInvalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetFaultreason
	s (TRowID,TCode,TDesc,TRemark,TInvalidFlag)=""
	quit
}

ClassMethod FaultreasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FaultreasonExecute ]
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

/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","DealMethod","","","")
Query DealMethod(Code As %String = "", Desc As %String = "", Remark As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String,TRemark:%String,TInvalidFlage:%String,TJob:%String")
{
}

ClassMethod DealMethodExecute(ByRef qHandle As %Binary, Code As %String = "", Desc As %String = "", Remark As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
 	s Code=$ZCONVERT(Code ,"U")
 	s Remark=$ZCONVERT(Remark ,"U")

	s index=1
	s rowid=0
	
	//s TJob=$j
	
	d BuildDataGetDealMethod
	
	//d ##Class(web.DHCEQCommon).SetPageInfo("DHCEQMCDealMethod.DealMethod",TJob,index-1)
	
	Quit $$$OK
BuildDataGetDealMethod
	f  s rowid=$o(^DHCEQCCode("DHCEQMCDealMethod",rowid))  quit:rowid=""  d
	.d ResetVariablesGetDealMethod
	.s LTRowID = rowid	//rowid
	.s LTCode=$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",1) //代码
	.s LTDesc=$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",2) //描述
	.s LTRemark=$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",3) //备注
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQMCDealMethod",rowid)),"^",4) //无符号标志
	.q:LTInvalidFlag="Y"
	.q:($ZCONVERT(LTCode,"U")'[Code)&(Code'="")
	.q:($ZCONVERT(LTDesc,"U")'[Desc)&(Desc'="")
	.q:($ZCONVERT(LTRemark,"U")'[Remark)&(Remark'="")
	.d OutputRowGetDealMethod
	quit
OutputRowGetDealMethod
   	s Data=$lb(LTRowID,LTCode,LTDesc,LTRemark,LTInvalidFlag,TJob)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetDealMethod
	s (LTRowID,LTCode,LTDesc,LTRemark,LTInvalidFlag)=""
	quit
}

ClassMethod DealMethodFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DealMethodExecute ]
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

ClassMethod DealMethodClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DealMethodExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// GR0062 20160216	增加存放位置query
/// d ##class(%ResultSet).RunQuery("web.DHCEQCLocation","GetShortLocation","")
Query GetShortLocation(Desc As %String = "", HospitalDR As %String = "", LocDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TName:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String")
{
}

ClassMethod GetShortLocationExecute(ByRef qHandle As %Binary, Desc As %String = "", HospitalDR As %String = "", LocDR As %String = "") As %Status
{
	;new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	Do BuildDataGetShortLocation
	Quit $$$OK
BuildDataGetShortLocation
	For  Set rowid=$Order(^DHCEQCCode("DHCEQCLocation",rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetShortLocation
	.Set TRowID = rowid
	.Set InvalidFlag=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",14)
	.Quit:InvalidFlag="Y"
	.Set TCode=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",1)
	.Set TDesc=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",2)
	.Quit:(Desc'="")&&(TDesc'[Desc)&&(TCode'[Desc)
	.Set TType=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",3)
	.Set TArea=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",4)
	.Set TAddress=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",5)
	.Set TManageLocDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",6)
	.;If TManageLocDR'="" Set TManageLoc=$Piece($Get(^CTLOC(TManageLocDR)),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
	.If TManageLocDR'="" Set TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)   //modify by jyp 2019-10-18 CTLOC调整
	.Set TManageUserDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",7)
	.If TManageUserDR'="" Set TManageUser=$Piece($Get(^SSU("SSUSR",TManageUserDR)),"^",2)
	.Set TPurposeTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",8)
	.If TPurposeTypeDR'="" Set TPurposeType=$Piece($Get(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	.Set TEquipDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",9)
	.If TEquipDR'="" Set TEquip=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	.Set TFloor=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",10)
	.Set TDateActiveFrom=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",11)
	.If TDateActiveFrom'="" Set TDateActiveFrom=##class(web.DHCEQCommon).TransValueToPage(TDateActiveFrom,"date")
	.Set TDateActiveTo=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",12)
	.If TDateActiveTo'="" Set TDateActiveTo=##class(web.DHCEQCommon).TransValueToPage(TDateActiveTo,"date")
	.Set TRemark=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",15)
	.
	.//modiied by ZY 2015-4-27 ZY0125
	.Set THospitalDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",16)	;hold1  Hospital
	.Quit:(HospitalDR'="")&&(THospitalDR'=HospitalDR)
	.if THospitalDR'="" set THospital=$p($g(^CT("HOSP",THospitalDR)),"^",2)
	.Set TLocDR=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",17)	;hold2  Loc
	.Quit:(LocDR'="")&&(TLocDR'=LocDR)
	.Set TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.Set THold3=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",18)	;hold3
	.Set THold4=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",19)	;hold4
	.Set THold5=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TRowID)),"^",20)	;hold5
	.
	.Do OutputRowGetShortLocation
	Quit
OutputRowGetShortLocation
	Set Data=$lb(TRowID,TCode,TDesc,TType,TArea,TAddress,TManageLocDR,TManageLoc,TManageUserDR,TManageUser,TPurposeTypeDR,TPurposeType,TEquipDR,TEquip,TFloor,TDateActiveFrom,TDateActiveTo,TRemark,THospitalDR,THospital,TLocDR,TLoc,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetShortLocation
	Set (TRowID,TCode,TDesc,TType,TArea,TAddress,TManageLocDR,TManageLoc,TManageUserDR,TManageUser,TPurposeTypeDR,TPurposeType,TEquipDR,TEquip,TFloor,TDateActiveFrom,TDateActiveTo,TRemark,THospitalDR,THospital,TLocDR,TLoc,THold3,THold4,THold5)=""
	Quit
}

ClassMethod GetShortLocationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortLocationExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$Order(^CacheTemp(repid,ind))
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

ClassMethod GetShortLocationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortLocationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by zy 2017-4-6  ZY0162
/// 组件查询的基本query
/// 入参：Desc 组件名称的模糊查询条件
/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","GetComponent","")
Query GetComponent(Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCaption:%String,TName:%String")
{
}

ClassMethod GetComponentExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s Desc=$ZCONVERT(Desc ,"U")
	s index=1
	
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCComponent",rowid))  quit:rowid=""  d
	.s (TRowID,TCode,TName)=""
	.s TRowID = rowid	//rowid
	.s TName=$p($g(^DHCEQCCode("DHCEQCComponent",rowid)),"^",1)
	.s TCaption=$p($g(^DHCEQCCode("DHCEQCComponent",rowid)),"^",2)
	.s LTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCComponent",rowid)),"^",12) //无符号标志
	.q:LTInvalidFlag="Y"
	.q:($ZCONVERT(TName,"U")'[Desc)&(Desc'="")
	.d OutputRowGetComponent
	Quit $$$OK
	
OutputRowGetComponent
   	s Data=$lb(TRowID,TCaption,TName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetComponentFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetComponentExecute ]
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

ClassMethod GetComponentClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetComponentExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

// add by zx 2017-03-23

Query OriginLookUp(para) As %SQLQuery(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
	SELECT O_Desc,
		   O_RowID,
		   O_Code
	FROM sqluser.DHC_EQCOrigin
	where O_InvalidFlag = 'N' and O_Desc like nvl(:para,'')||'%'
}

/// add by lmm 2018-10-25
/// 描述：hisui改造 查询人员
/// 入参：type:设备员工类型代码
///       name：员工姓名或工号
///       loc：员工所在科室
///       equiptype：员工可查看类组
///       manageloc：员工指定科室
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","EQUser","","","","","")
/// modify by lmm 2018-09-17 增加出参 TUserLocDR：默认科室id  TUserLoc：默认科室 THospitalDR：医院id THospital：医院
Query EQUser(Type As %String, Name As %String = "", Loc As %String = "", Equiptype As %String = "", Manageloc As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TUserLocDR:%String,TUserLoc:%String,THospitalDR:%String,THospital:%String")
{
}

ClassMethod EQUserExecute(ByRef qHandle As %Binary, Type As %String, Name As %String = "", Loc As %String = "", Equiptype As %String = "", Manageloc As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	
 	s rowid=0
 	s Name=$ZCONVERT(Name,"U")
 	if (Type'="")||(Equiptype'="")
 	{
		if (Type'="")
		{
			s typeid=##Class(web.DHCEQCommon).GetStandardIDByCode("DHCEQCEmployeeType",Type)
			i Type="" s id="" Quit $$$OK
		 	if Equiptype'=""
		 	{
			 	f  s rowid=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EquipType",typeid,Equiptype,rowid)) q:rowid=""  d
			 	.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",3)="Y"
			 	.s userid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",2)
			 	.d GetEQUserList
			}
		 	else
		 	{
			 	f  s rowid=$o(^DHCEQCCode("DHCEQCTypeEmployee",0,"EmployeeType",typeid,rowid)) q:rowid=""  d
			 	.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",3)="Y"
			 	.s userid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",2)
			 	.d GetEQUserList
			}
		}
		else
		{
			f  s rowid=$o(^DHCEQCCode("DHCEQCTypeEmployee",rowid)) q:rowid=""  d
			.q:$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",3)="Y"
			.s userequiptype=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",3)
			.s userid=$p($g(^DHCEQCCode("DHCEQCTypeEmployee",rowid)),"^",2)
			.quit:(Equiptype'="")&&(Equiptype'=userequiptype)
			.d GetEQUserList
		}
	}
 	else
 	{
	 	if Manageloc'=""
		{
			f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:rowid=""  d
		 	.s userid=rowid
		 	.s hisuserid=$p($g(^DHCEQCCode("DHCEQCUser",rowid)),"^",19)
		 	.i $p($g(^SSU("SSUSR",hisuserid)),"^",4)=Manageloc d
		 	..d GetEQUserList
		 	.s chl=0
		 	.f  s chl=$O(^SSU("SSUSR",hisuserid,"OTHLL",chl)) q:(chl="")  d
		    ..q:$P(^SSU("SSUSR",rowid,"OTHLL",chl),"^",2)'="86"	//是否在指定安全组内的用户
		    ..;q:$P(^SSU("SSUSR",hisuserid,"OTHLL",chl),"^",1)'=Manageloc //有指定科室时,判断科室  modify by lmm 2018-10-25 
		    ..d GetEQUserList
		}
	 	else
	 	{
		 	f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:rowid=""  d
		 	.s userid=rowid
		 	.Do GetEQUserList

		}	
		Quit $$$OK
			
 	}
 	
    
GetEQUserList
	//modify by lmm 2018-10-25 begin
	s userdata=$g(^DHCEQCCode("DHCEQCUser",rowid))
	q:userdata=""
	q:($p(userdata,"^",31)="Y") //ADD by JYP 20181009
	s initials=$p(userdata,"^",1)
	s username=$p(userdata,"^",4)
	s userlocid=$p(userdata,"^",14) //modify by JYP 20181009
	i userlocid'="" s userloc=##class(web.DHCEQCommon).GetTrakNameByID("dept",userlocid)
	q:(Loc'="")&&(userloc'=Loc)
	s OrganizeType=$p(userdata,"^",12)
	s (HospitalDR,Hospital)="" //ADD by JYP 20181010
	i OrganizeType="1" s HospitalDR=$p(userdata,"^",13)
	i HospitalDR'="" s Hospital=$p($g(^CT("HOSP",HospitalDR)),"^",2)
	quit:##Class(web.DHCEQCommon).HospitalIsInclude(userloc)=0
	q:(Name'="")&&($ZCONVERT(username,"U")'[Name)&&($ZCONVERT(initials,"U")'[Name)    //&&($e(PYCode,1,$l(Name))'=Name)  //modify by lmm 2018-11-07 暂时注释拼音码筛选
	d OutputRowEQUser
	quit
	
OutputRowEQUser
	set Data=$lb(username,userid,initials,userlocid,userloc,HospitalDR,Hospital)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit

	//modify by lmm 2018-10-25 end
}

ClassMethod EQUserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = EQUserExecute ]
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

ClassMethod EQUserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by lmm 2018-10-25
/// 描述：根据姓名或工号来查找员工 JYP0014
/// 入参：name:姓名
/// do ##Class(%ResultSet).RunQuery("web.DHCEQ.Process.DHCEQFind","User","")
ClassMethod UserClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = EQUserExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UserExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
	
 	If $g(ind)="" Set ind=1
	s rowid=0
	s rowids=""
	s Name=$ZCONVERT(Name,"U")	
	f  s rowid=$o(^DHCEQCCode("DHCEQCUser",rowid)) q:rowid=""  d
	.s userid=rowid
	.s initials=$p(^DHCEQCCode("DHCEQCUser",rowid),"^",1)
	.s username=$p(^DHCEQCCode("DHCEQCUser",rowid),"^",4)
	.s PYCode=$p($g(^DHCEQUserPYTemp(rowid)),"^",2) //2009-09-19 党军
	.q:($ZCONVERT(username,"U")'[Name)&&($e(PYCode,1,$l(Name))'=Name)&&($ZCONVERT(initials,"U")'[Name)
	.Do OutputRowUser
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRowUser
	set Data=$lb(username,userid,initials)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod UserFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = UserExecute ]
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

Query User(Name As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String")
{
}

/// 增加参数notUseFlag:限制是否显示无效科室，""不限制显示全部科室，"Y"不显示无效科室
/// -----------------------------
/// 修改：JDL 2010-7-30
/// LocType：参数为库房类型的关键字，库房类型代码。
/// 		 如：库房为0101，科室为0102，租赁中心为0301
/// -------------------------------
/// 修改：zy 2009-07-22   zy0007
/// 描述:设备入库管理中，库房要从属于库房这一类的科室中选择
/// 增加参数:LocType：科室类型代码
/// 备注:科室类型：1，库房；0，科室
/// modify by lmm 2018-10-25
/// -------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBFind","GetEQLoc","2","","","0102","")
Query GetEQLoc(Type, LocDesc As %Library.String = "", vgroupid As %Library.String = "", LocType As %Library.String = "", notUseFlag As %String = "", UserID As %String = "", CurHosptailID As %String = "", CTLocAllFlag As %String = "") As %Query(ROWSPEC = "TName:%String,TRowID:%String,TCode:%String,TPYM:%String,TTel:%String") [ SqlProc ]
{
}

ClassMethod GetEQLocExecute(ByRef qHandle As %Binary, Type, LocDesc As %Library.String = "", vgroupid As %Library.String = "", LocType As %Library.String = "", notUseFlag As %String = "", UserID As %String = "", CurHosptailID As %String = "", CTLocAllFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s LocTypeID=""
	if LocType'=""     //科室类型
	{
		s LocTypeID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code",LocType,0))
		if LocTypeID="" Quit $$$OK
	}	
	
	if (Type="0")||(Type="")  //所有科室
	{
		s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
		s LGTLocRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0102",0))
		//modify by lmm 2018-10-25 begin
		f  s rowid=$o(^DHCEQCCode("DHCEQCDepartment",rowid)) q:rowid=""  d
		.s locid=rowid
		.s StoreFlag=""
		.s LocFlag=""
		.i LGTStoreRowID'="" s StoreFlag=$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,locid))
		.i LGTLocRowID'="" s LocFlag=$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTLocRowID,locid))
		.q:((CTLocAllFlag'="Y")&&(StoreFlag=0)&&(LocFlag=0))
		.d GetOneLoc
		
		//modify by lmm 2018-10-25 end
	}
	if Type="1"  //安全组科室
	{
		if vgroupid="" s vgroupid=%session.Get("LOGON.GROUPID")
		s LGTStoreRowID=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
		s StoreDR=0
		f  s StoreDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LGTStoreRowID,StoreDR))  q:StoreDR=""  d
		.;modify by lmm 2018-10-25 begin
		.s (OrganizeType,StoreHospDR)=""
		.s OrganizeType=$p($g(^DHCEQCCode("DHCEQCDepartment",StoreDR)),"^",7)   
		.i (OrganizeType=1) s StoreHospDR=$p($g(^DHCEQCCode("DHCEQCDepartment",StoreDR)),"^",8) 
		.;modify by lmm 2018-10-25 end
		.s GroupHospIDs=##Class(web.DHCEQCommon).GetHospIDSByGroup(vgroupid)
		.q:GroupHospIDs'[("^"_StoreHospDR_"^")
		.s locid=StoreDR
		.d GetOneLoc
		.;未在安全组访问库房中，是否在安全组访问库房所管理的科室中
		.s locid=0
		.f  s locid=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",StoreDR,locid)) q:(locid="")||(LocType="0101")  d
		..d GetOneLoc
		/*
		if vgroupid="" s vgroupid=%session.Get("LOGON.GROUPID")
		f  s rowid=$o(^SSU("SSGRP",vgroupid,"ST",0,"Loc",rowid)) q:rowid=""  d
		.s locid=rowid
		.d GetOneLoc
		.;未在安全组访问库房中，是否在安全组访问库房所管理的科室中
		.s locid=0
		.f  s locid=$o(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",rowid,locid)) q:(locid="")  d
		..d GetOneLoc
		*/
	}
	if Type="2" //本科室
	{
		s rowid=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
		s locid=rowid
		d GetOneLoc
	}
	
	
	Quit $$$OK

GetOneLoc	

	//add by zy 2015-04-09 ZY0125 分院区管理,通过科室的医院属性来管理
	s HIIFlag=1		//Add By DJ 2017-03-22
	i '((CurHosptailID=0)&&(LocType="0101"))  d		//转移单为库房调配时接收部门可选择所有库房
	.s HIIFlag=##Class(web.DHCEQCommon).HospitalIsInclude(locid,vgroupid,CurHosptailID)
	quit:HIIFlag=0
	Quit:(##Class(web.DHCEQCommon).CheckManageLimit(UserID,vgroupid,"","","","",locid))
	s code=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",1)
	s desc=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",2)
	s NotUse=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",13)
	q:(notUseFlag'="")&&(NotUse="Y")
	s DATo=$p($g(^DHCEQCCode("DHCEQCDepartment",locid)),"^",18)
	q:((notUseFlag'="")&&(+DATo'=0)&&(+DATo<+$H))
	s LocDesc=$ZCONVERT(LocDesc,"U")
	q:($ZCONVERT(desc,"U")'[LocDesc)&&($ZCONVERT(code,"U")'[LocDesc)
	if LocTypeID'=""     //库房类型
	{
		if '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeID,locid)) q
	}
	s tel= ##Class(web.DHCEQCLocType).GetEQLocDetailByID("", "", locid)	;取科室类型表电话	//201702-04	Mozy
	s tel=$p(tel,"^",17)
	d OutputRowGetEQLoc

	quit
OutputRowGetEQLoc
	s TPYM=$p(desc,"-",1)
	s TRowID=locid
	s TCode=code
	s TName=##class(web.DHCEQCommon).GetSplitDataByFlag(desc,"-")
	s TTel=tel
	s Data=$lb(TName,TRowID,TCode,TPYM,TTel)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetEQLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEQLocExecute ]
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

ClassMethod GetEQLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEQLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
