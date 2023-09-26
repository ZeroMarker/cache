Class web.DHCEQ.BA.CTServiceConsumable Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.CTServiceConsumable","GetServiceConsumable","1","1","13")
Query GetServiceConsumable(SourceType As %String = "", SourceID As %String = "", ServiceItemID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceID:%String,TServiceItem:%String,TConsumableItem:%String,TUnit:%String,TQuantity:%String,TModel:%String,TQuantityType:%String,TServDetItem:%String,TMonthStatFlag:%String,TCycleNum:%String,TCycleNuit:%String,TType:%String,TSubType:%String,TSubKey:%String,TEquipNo:%String")
{
}

ClassMethod GetServiceConsumableExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "", ServiceItemID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ConsumableID=0
	if $Data(^DHCEQCCode("DHCEQCServiceConsumable",0,"Source",SourceType,SourceID,ServiceItemID))
	{
		f  s ConsumableID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"Source",SourceType,SourceID,ServiceItemID,ConsumableID))  quit:ConsumableID=""  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"Source",SourceType,SourceID,ServiceItemID,ConsumableID,rowid))  quit:rowid=""  d
		..d BuildDataServiceConsumable
	}
	elseif $Data(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServiceConsumable",ServiceItemID))
	{
		f  s ConsumableID=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServiceConsumable",ServiceItemID,ConsumableID))  quit:ConsumableID=""  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQCCode("DHCEQCServiceConsumable",0,"ServiceConsumable",ServiceItemID,ConsumableID,rowid))  quit:rowid=""  d
		..d BuildDataServiceConsumable
	}
	Quit $$$OK
	
BuildDataServiceConsumable
	d ResetVariablesGetServiceConsumable
	s DataList=$g(^DHCEQCCode("DHCEQCServiceConsumable",rowid))
	s TRowID = rowid
	s TSourceType=$p(DataList,"^",1)
	s TSourceID=$p(DataList,"^",2)
	i TSourceType=1 d
	.s TEquipNo=$p($g(^DHCEQEquip(TSourceID)),"^",71)
	.s TSourceID=$p($g(^DHCEQEquip(TSourceID)),"^",1)
	e  i TSourceType=2 d
	.s TSourceID=##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",TSourceID)
	s TSourceType=$Case(TSourceType,"1":"设备","2":"设备项","":"")
	s TServiceItem=##Class(web.DHCEQCommon).GetTrakNameByID("service",$p(DataList,"^",3))
	s TConsumableItem=##Class(web.DHCEQCommon).GetTrakNameByID("consumableitem",$p(DataList,"^",4))
	s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(DataList,"^",5))
	s TQuantity=$p(DataList,"^",6)
	s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p(DataList,"^",7))
	s TQuantityType=$p(DataList,"^",8)
	s TQuantityType=$Case(TQuantityType,"1":"绝对量","2":"相对量","":"")
	s TServDetItem=##Class(web.DHCEQCommon).GetTrakNameByID("servdetitem",$p(DataList,"^",9))
	s TMonthStatFlag=$p(DataList,"^",10)
	s TCycleNum=$p(DataList,"^",11)
	s TCycleNuit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(DataList,"^",12))
	//1:使用  2:质控  3:其他  (耗材统计类型)
	s TType=$Case($p(DataList,"^",13),"1":"使用","2":"质控","3":"其他","":"")
	s TSubType=$p(DataList,"^",14)
	s TSubKey=$p(DataList,"^",15)
	///modified by ZY0256 20210315  为空的时候取耗材项中的扩展类型定义信息
	i TSubType="" d
	.if $p(DataList,"^",4)'="" d
	..s TSubType=$p($g(^DHCEQCCode("DHCEQCConsumableItem",$p(DataList,"^",4))),"^",5)
	..s TSubKey=$p($g(^DHCEQCCode("DHCEQCConsumableItem",$p(DataList,"^",4))),"^",8)	//modified by ZY0282 20211111
	d OutputRowGetServiceConsumable
	Quit
OutputRowGetServiceConsumable
	Set Data=$lb(TRowID,TSourceType,TSourceID,TServiceItem,TConsumableItem,TUnit,TQuantity,TModel,TQuantityType,TServDetItem,TMonthStatFlag,TCycleNum,TCycleNuit,TType,TSubType,TSubKey,TEquipNo)
	Set ^CacheTemp(repid,index)=Data
	Set ^ZY("ServiceConsumable",repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetServiceConsumable
	Set (DataList,TRowID,TSourceType,TSourceID,TServiceItem,TConsumableItem,TUnit,TQuantity,TModel,TQuantityType,TServDetItem,TMonthStatFlag,TCycleNum,TCycleNuit,TType,TSubType,TSubKey,TEquipNo)=""
	Quit
}

ClassMethod GetServiceConsumableFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServiceConsumableExecute ]
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

ClassMethod GetServiceConsumableClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceConsumableExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod SaveData(data, DelIs)
{
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
 	s Time=$Piece($H,",",2)
	if DelIs=1
	{
		s RowID=data
		&SQL(delete from SQLUSER.DHC_EQCServiceConsumable  where SIC_RowID = :RowID)
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCServiceConsumable",JsonData,.PLIST)
	    s PLIST(6)=JsonData.SICUomDR	//modified by ZY 20220809 2708102
		s RowID = JsonData.SICRowID	//modified by ZY0268 20210331
		s tmp=""
		&SQL(select SIC_RowID into :tmp from  SQLUSER.DHC_EQCServiceConsumable  where SIC_ServiceItemDR = :PLIST(4) and SIC_ConsumableItemDR = :PLIST(5))
		if (tmp'="")
	    {
		    if (tmp=RowID)
			{
				&SQL(Update SQLUSER.DHC_EQCServiceConsumable Values :PLIST() where SIC_RowID = :RowID)
			}
			else
			{
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9210")	///modified by ZY0279 20210907
			}
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQCServiceConsumable Values :PLIST())
			s RowID=$g(%ROWID)
		}
	}
	If SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
}

/// Add By ZY0215 2020-04-02
/// 描述:经济测量记录获取
/// w ##Class(web.DHCEQ.BA.CTServiceConsumable).GetOneServiceConsumable(1)
ClassMethod GetOneServiceConsumable(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneServiceConsumable"
	s ObjServiceConsumable=##Class(User.DHCEQCServiceConsumable).%OpenId(RowID)
	s ServiceConsumable=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjServiceConsumable)
	d ServiceConsumable.%Set("SICRowID",RowID)
	d ServiceConsumable.%Set("SICConsumableItemDR_CIDesc",ObjServiceConsumable.SICConsumableItemDR.CIDesc)
	d ServiceConsumable.%Set("SICUOMDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",ObjServiceConsumable.SICUomDR))
	///add by ZY0282 20211111
	i ObjServiceConsumable.SICSubType="" d
	.d ServiceConsumable.%Set("SICSubType",ObjServiceConsumable.SICConsumableItemDR.CIExType)
	.d ServiceConsumable.%Set("SICSubKey",ObjServiceConsumable.SICConsumableItemDR.CIExDesc)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,ServiceConsumable)
ERRORGetOneServiceConsumable
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1000",ErrorMsg)
}

}
