Class web.DHCEQ.RM.CTResourcePrice Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZC
/// CreatDate：    2020-04-30
/// Description:   租赁定价数据保存
/// Input：        data:前台获取字符串 {"RPHospitalDR_Desc":"","RPSourceType":"2","RPSource":"血压监护仪","RPModelDR_Desc":"","RHPPriceTypeDR_Desc":"评价","RHPFromDate":"2020-05-08","RHPMode":"2","RHPUomQuantity":"1","RHPUOMDR_Desc":"次","RHPPrice":"1.00","RPHospitalDR":"","RPSourceID":"1","RPModelDR":"","RHPPriceTypeDR":"3","RHPUOMDR":"47","RPRowID":"1","RHPRowID":"1"}  Type 操作类型：(1：删除),(2：新增),(其他:保存)
/// Return：       Json数据 {"SQLCODE":SQLCODE,"RowID":RowID或错误码}
/// w ##Class(web.DHCEQ.RM.CTResourcePrice).SaveData({"RPHospitalDR_Desc":"","RPSourceType":"2","RPSource":"血压监护仪","RPModelDR_Desc":"","RHPPriceTypeDR_Desc":"评价","RHPFromDate":"2020-05-08","RHPMode":"2","RHPUomQuantity":"1","RHPUOMDR_Desc":"次","RHPPrice":"1.00","RPHospitalDR":"","RPSourceID":"1","RPModelDR":"","RHPPriceTypeDR":"3","RHPUOMDR":"47","RPRowID":"1","RHPRowID":"1"},"")
ClassMethod SaveData(Data, Type As %String = "")
{
	s $ZT="ERRORResourcePrice"
	k PLIST,RowID,LPLIST
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSResourcePrice",JsonData,.PLIST)
	s LPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSResourceHistoryPrice",JsonData,.LPLIST)
	s RowID = JsonData.RPRowID
	s RHPRowID = JsonData.RHPRowID
	s FromDate = ##Class(web.DHCEQCommon).TransValueFromPage(JsonData.RHPFromDate,"date")
	s HospitalDR = JsonData.RPHospitalDR
	s SourceType = JsonData.RPSourceType
	s SourceID = JsonData.RPSourceID
	s ModelDR = JsonData.RPModelDR
	TSTART
	if (Type="1")
	{
		&SQL(update sqluser.DHC_EQSResourcePrice set RP_InvalidFlag='Y' where RP_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	ELSE
	{
		s TmpID=##Class(web.DHCEQ.RM.CTResourcePrice).GetRPBySource(SourceType,SourceID,HospitalDR,ModelDR)
		if (RowID'="")&&(TmpID=RowID)
	    {
		    s RTmpID=##Class(web.DHCEQ.RM.CTResourcePrice).GetRHPByResourcePrice(RowID)  //Modify by zc 2020-06-24 ZC0077 去掉方法GetRHPByResourcePrice入参FromDate
			if (RHPRowID'="")&&(RTmpID=RHPRowID)
			{
				if (##Class(web.DHCEQCommon).FormatNumber(JsonData.RHPPrice,"")'=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSResourceHistoryPrice(RHPRowID)),"^",6),""))
				{
					s ToDate=FromDate
					&SQL(Update SQLUSER.DHC_EQSResourceHistoryPrice set RHP_ToDate=:ToDate,RHP_ActiveFlag='N' where RHP_RowID = :RHPRowID)
					i SQLCODE
					{
						TROLLBACK
						Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
					}
					s LPLIST(2)=RowID
					s LPLIST(10)="Y"	
					&SQL(insert into SQLUSER.DHC_EQSResourceHistoryPrice Values :LPLIST())
				}
				else
				{
					&SQL(Update SQLUSER.DHC_EQSResourceHistoryPrice Values :LPLIST() where RHP_RowID = :RHPRowID)
				}
			}
			elseif (RHPRowID'="")&&(RTmpID'=RHPRowID)
			{
				if (RTmpID="")
				{
					s ToDate=FromDate
					&SQL(Update SQLUSER.DHC_EQSResourceHistoryPrice set RHP_ToDate=:ToDate,RHP_ActiveFlag='N' where RHP_RowID = :RHPRowID)
					i SQLCODE
					{
						TROLLBACK
						Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
					}
					s LPLIST(2)=RowID
					s LPLIST(10)="Y"	
					&SQL(insert into SQLUSER.DHC_EQSResourceHistoryPrice Values :LPLIST())
				}
				else
				{
					&SQL(Update SQLUSER.DHC_EQSResourceHistoryPrice Values :LPLIST() where RHP_RowID = :RHPRowID)
				}
			}
		
		}
		elseif (RowID'="")&&(TmpID'=RowID)
		{	
			if (TmpID="")
			{
				s PLIST(6)="N"
				&SQL(insert into SQLUSER.DHC_EQSResourcePrice Values :PLIST())
				i SQLCODE
				{
					TROLLBACK
					Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
				}
			}
			s RowID=$g(%ROWID)
			s LPLIST(2)=RowID	
			s LPLIST(10)="Y"
			&SQL(insert into SQLUSER.DHC_EQSResourceHistoryPrice Values :LPLIST())
		}
		elseif (RowID="")&&(TmpID'="")
		{
			s RowID=TmpID
			s LPLIST(2)=RowID	
			s LPLIST(10)="Y"
			&SQL(insert into SQLUSER.DHC_EQSResourceHistoryPrice Values :LPLIST())
		}
		elseif (RowID="")&&(TmpID="")
		{
			s PLIST(6)="N"
			&SQL(insert into SQLUSER.DHC_EQSResourcePrice Values :PLIST())
			i SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
			s RowID=$g(%ROWID)
			s LPLIST(2)=RowID
			s LPLIST(10)="Y"	
			&SQL(insert into SQLUSER.DHC_EQSResourceHistoryPrice Values :LPLIST())
		}
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
	
ERRORResourcePrice
	TROLLBACK 
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// Creator：      ZC
/// CreatDate：    2020-04-30
/// Description:   解析单条租赁定价信息
/// Table：        DHC_EQSResourceHistoryPrice,DHC_EQSResourceHistoryPrice
/// Input：        RowID:租赁定价ID
/// Return：       表数据解析 json返回{"field":"value","field":"value",...}
/// w ##Class(web.DHCEQ.RM.CTResourcePrice).GetOneResourcePrice(1)
ClassMethod GetOneResourcePrice(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneResourcePrice"
	s ObjResourcePrice=##Class(User.DHCEQSResourcePrice).%OpenId(RowID)
	s RHPRowID="" 
	&SQL(Select RHP_RowID Into :RHPRowID from SQLUSER.DHC_EQSResourceHistoryPrice Where RHP_ResourcePriceDR=:RowID and RHP_ActiveFlag<>'N')
	s ObjResourceHistoryPrice=##Class(User.DHCEQSResourceHistoryPrice).%OpenId(RHPRowID)
	s ResourcePriceInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjResourcePrice)
	i ObjResourcePrice.RPHospitalDR'="" d ResourcePriceInfo.%Set("RPHospitalDR_Desc",$Piece($Get(^CT("HOSP",ObjResourcePrice.RPHospitalDR)),"^",2))
	i ObjResourcePrice.RPSourceType="3" d 
	.d ResourcePriceInfo.%Set("RPSource",##class(web.DHCEQCommon).GetTrakNameByID("masteritem",ObjResourcePrice.RPSourceID))
	e  i ObjResourcePrice.RPSourceType="2" d 
	.d ResourcePriceInfo.%Set("RPSource",$p($g(^DHCEQEquip(ObjResourcePrice.RPSourceID)),"^",1))
	e  i ObjResourcePrice.RPSourceType="1" d 
	.d ResourcePriceInfo.%Set("RPSource",$p($g(^DHCEQSCShareItemCat(ObjResourcePrice.RPSourceID)),"^",2))
	d ResourcePriceInfo.%Set("RPModelDR_Desc",##class(web.DHCEQCommon).GetTrakNameByID("model",ObjResourcePrice.RPModelDR))
	i ObjResourceHistoryPrice.RHPPriceTypeDR'="" d ResourcePriceInfo.%Set("RHPPriceTypeDR_Desc",$p($g(^DHCEQSCPriceType(ObjResourceHistoryPrice.RHPPriceTypeDR)),"^",2))
	i ObjResourceHistoryPrice.RHPUOMDR'="" d ResourcePriceInfo.%Set("RHPUOMDR_Desc",##class(web.DHCEQCommon).GetTrakNameByID("uom",ObjResourceHistoryPrice.RHPUOMDR))
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,ResourcePriceInfo)
ERRORGetOneResourcePrice
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.CTResourcePrice","GetResourcePrice","0","","","327","71","")
Query GetResourcePrice(HospitalDR As %String = "", SourceType As %String = "", SourceID As %String = "", ModelDR As %String = "") As %Query(ROWSPEC = "RPRowID:%String,RPHospitalDR:%String,RPHospitalDR_Desc:%String,RPSourceType:%String,RPSourceTypeDesc:%String,RPSourceID:%String,RPSource:%String,RPModelDR:%String,RPModelDR_Desc:%String,RHPRowID:%String,RHPPriceTypeDR:%String,RHPPriceTypeDR_Desc:%String,RHPMode:%String,RHPModeDesc:%String,RPHModePrice:%String,RHPUomQuantity:%String,RHPUOMDR:%String,RHPUOMDR_Desc:%String,RHPPrice:%String:%String,RHPFromDate:%String,RHPToDate:%String")
{
}

ClassMethod GetResourcePriceExecute(ByRef qHandle As %Binary, HospitalDR As %String = "", SourceType As %String = "", SourceID As %String = "", ModelDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0

	f  s rowid=$o(^DHCEQSResourcePrice(rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQSResourcePrice(rowid)),"^",5)="Y"
	.q:(HospitalDR'="")&&($p($g(^DHCEQSResourcePrice(rowid)),"^",1)'=HospitalDR)
	.q:(SourceType'="")&&($p($g(^DHCEQSResourcePrice(rowid)),"^",2)'=SourceType)
	.q:(SourceID'="")&&($p($g(^DHCEQSResourcePrice(rowid)),"^",3)'=SourceID)
	.q:(ModelDR'="")&&($p($g(^DHCEQSResourcePrice(rowid)),"^",4)'=ModelDR)
	.s rhprowid=0
	.f  s rhprowid=$o(^DHCEQSResourceHistoryPrice(0,"ResourcePrice",rowid,rhprowid)) q:rhprowid=""  d
	..d ResetVariablesGetResourcePrice
	..q:$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",9)="N"
	..s TPriceTypeDR=$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",2)
	..i TPriceTypeDR'="" s TPriceType=$p($g(^DHCEQSCPriceType(TPriceTypeDR)),"^",2)
	..s TMode=$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",3)
	..s TModeDesc =$CASE(TMode,"1":"租赁时长", "2":"工作量","":"")
	..s TUomQuantity=$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",4)
	..s TUOMDR=$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",5)
	..s TUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUOMDR)
	..s TPrice=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",6),"")
	..s TModePrice=TUomQuantity_"/"_TUOM
	..s TFromDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",7),"date")
	..s TToDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",8),"date")
	..s THospitalDR=$p($g(^DHCEQSResourcePrice(rowid)),"^",1)
	..q:(THospitalDR'="")&&(##Class(web.DHCEQCommon).CheckHOSLimit(THospitalDR)=0) ;Add by QW20200507
	..i THospitalDR'="" s THospital = $Piece($Get(^CT("HOSP",THospitalDR)),"^",2)
	..s TSourceType=$p($g(^DHCEQSResourcePrice(rowid)),"^",2)
	..s TSourceID=$p($g(^DHCEQSResourcePrice(rowid)),"^",3)
	..i TSourceType=3 d
	...s TSourceIDDesc=##class(web.DHCEQCommon).GetTrakNameByID("masteritem",TSourceID)
	..e  i TSourceType=2 d
	...s TSourceIDDesc=$p($g(^DHCEQSShareResource(TSourceID)),"^",10) //Modify by zc 2020-06-11
	..e  i TSourceType=1 d
	...s TSourceIDDesc=$Piece($Get(^DHCEQSCShareItem(TSourceID)),"^",3) //Modify by zc 2020-06-11
	..s TSourceTypeDesc =$CASE(TSourceType,"1":"资源项目", "2":"资源", "3":"设备项","":"")
	..s TModelDR=$p($g(^DHCEQSResourcePrice(rowid)),"^",4)
	..s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	..s TRowID = rowid
	..s TRRowID=rhprowid
	..d OutputRowGetResourcePrice
	Quit $$$OK
OutputRowGetResourcePrice
	s Data=$lb(TRowID,THospitalDR,THospital,TSourceType,TSourceTypeDesc,TSourceID,TSourceIDDesc,TModelDR,TModel,TRRowID,TPriceTypeDR,TPriceType,TMode,TModeDesc,TModePrice,TUomQuantity,TUOMDR,TUOM,TPrice,TFromDate,TToDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetResourcePrice
	s (TRowID,THospitalDR,THospital,TSourceType,TSourceTypeDesc,TSourceID,TSourceIDDesc,TModelDR,TModel,TRRowID,TPriceTypeDR,TPriceType,TMode,TModeDesc,TModePrice,TUomQuantity,TUOMDR,TUOM,TPrice,TFromDate,TToDate)=""
	quit
}

ClassMethod GetResourcePriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResourcePriceExecute ]
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

ClassMethod GetResourcePriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResourcePriceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.CTResourcePrice","GetResourceHistoryPrice","0","","","327","71","")
Query GetResourceHistoryPrice(ResourcePriceDR As %String = "") As %Query(ROWSPEC = "RHPRowID:%String,RHPPriceTypeDR:%String,RHPPriceTypeDR_Desc:%String,RHPMode:%String,RHPModeDesc:%String,RHPUomQuantity:%String,RHPUOMDR:%String,RHPUOMDR_Desc:%String,RHPPrice:%String:%String,RHPFromDate:%String,RHPToDate:%String")
{
}

ClassMethod GetResourceHistoryPriceExecute(ByRef qHandle As %Binary, ResourcePriceDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i ResourcePriceDR="" Quit $$$OK
	s rhprowid=0
	f  s rhprowid=$o(^DHCEQSResourceHistoryPrice(0,"ResourcePrice",ResourcePriceDR,rhprowid)) q:rhprowid=""  d
	.d ResetVariablesGetResourceHistoryPrice
	.;q:$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",9)="N"
	.s TPriceTypeDR=$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",2)
	.i TPriceTypeDR'="" s TPriceType=$p($g(^DHCEQSCPriceType(TPriceTypeDR)),"^",2)
	.s TMode=$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",3)
	.s TModeDesc =$CASE(TMode,"1":"租赁时长", "2":"工作量","":"")
	.s TUomQuantity=$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",4)
	.s TUOMDR=$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",5)
	.s TUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUOMDR)
	.s TPrice=$p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",6)
	.s TFromDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",7),"date")
	.s TToDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSResourceHistoryPrice(rhprowid)),"^",8),"date")
	.s TRRowID=rhprowid
	.d OutputRowGetResourceHistoryPrice
	Quit $$$OK
OutputRowGetResourceHistoryPrice
	s Data=$lb(TRRowID,TPriceTypeDR,TPriceType,TMode,TModeDesc,TUomQuantity,TUOMDR,TUOM,TPrice,TFromDate,TToDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetResourceHistoryPrice
	s (TRRowID,TPriceTypeDR,TPriceType,TMode,TModeDesc,TUomQuantity,TUOMDR,TUOM,TPrice,TFromDate,TToDate)=""
	quit
}

ClassMethod GetResourceHistoryPriceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResourceHistoryPriceExecute ]
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

ClassMethod GetResourceHistoryPriceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResourceHistoryPriceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By zx 2020-03-13
/// 描述:取租赁设备的价格定义信息
/// 入参：ShareResourceDR 资源ID
/// 返回：未找到对应的租赁价格定义,则返回""
/// 	  否则返回相应信息	EquipRentID
/// w ##Class(web.DHCEQ.RM.CTResourcePrice).GetResourcePriceInfo("1")
ClassMethod GetResourcePriceInfo(ShareResourceDR)
{
	n EquipRentID,Item,Model,ERRowID,RPID
	s (EquipRentID,Item,Model,ERRowID,RPID)=""	
	i ShareResourceDR="" q ""
	;取设备定义的租赁价格
	s RPID=$o(^DHCEQSResourcePrice(0,"Source",2,ShareResourceDR,0))
	i (RPID'="")&&($p($g(^DHCEQSResourcePrice(RPID)),"^",5)="N") q RPID
	;如果未定义,则取设备项上的定义
	s EquipDR=$p($g(^DHCEQSShareResource(ShareResourceDR)),"^",3)
	s Model= $p($g(^DHCEQSShareResource(ShareResourceDR)),"^",12)
	i EquipDR'="" d
	.s Item=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	.q:Item=""
	.s ERRowID=0
	.f  s ERRowID=$o(^DHCEQSResourcePrice(0,"Source",3,Item,ERRowID))  quit:((ERRowID="")||(RPID'=""))  d
	..q:$p($g(^DHCEQSResourcePrice(ERRowID)),"^",5)="Y"
	..s ERModel=$p($g(^DHCEQSResourcePrice(ERRowID)),"^",4)
	..q:(ERModel'="")&&(ERModel'=Model)
	..s RPID=ERRowID
	i RPID'="" q RPID
	
	;如果未定义,则取资源项目上的定义
	s PutOnSetDR=$p($g(^DHCEQSShareResource(ShareResourceDR)),"^",1)
	i PutOnSetDR'="" d
	.s ShareItem=$p($g(^DHCEQSPutOnSet(PutOnSetDR)),"^",22)
	.q:ShareItem=""
	.s ERRowID=0
	.f  s ERRowID=$o(^DHCEQSResourcePrice(0,"Source",1,ShareItem,ERRowID))  quit:((ERRowID="")||(RPID'=""))  d
	..q:$p($g(^DHCEQSResourcePrice(ERRowID)),"^",5)="Y"
	..s ERModel=$p($g(^DHCEQSResourcePrice(ERRowID)),"^",4)
	..q:(ERModel'="")&&(ERModel'=Model)
	..s RPID=ERRowID
	
	q RPID
}

/// Add By zc 2020-04-30
/// 描述:取租赁设备的价格ID
/// 入参：SourceType 对象类型 SourceID 对象ID HospitalDR 院区ID ModelDR 机型ID
/// 返回：未找到对应的租赁价格ID,则返回""
/// 	  否则返回相应信息	vRPRowID
/// w ##Class(web.DHCEQ.RM.CTResourcePrice).GetRPBySource("2","1","","")
ClassMethod GetRPBySource(SourceType, SourceID, HospitalDR, ModelDR)
{
	s vRPRowID=""
	i (SourceType="")||(SourceID="") q ""
	s vERRowID=0
	f  s vERRowID=$o(^DHCEQSResourcePrice(0,"Source",SourceType,SourceID,vERRowID))  quit:vERRowID=""  d
	.q:$p($g(^DHCEQSResourcePrice(vERRowID)),"^",5)="Y"
	.q:$p($g(^DHCEQSResourcePrice(vERRowID)),"^",1)'=HospitalDR
	.q:$p($g(^DHCEQSResourcePrice(vERRowID)),"^",4)'=ModelDR
	.s vRPRowID=vERRowID
	q vRPRowID
}

// Modify by zc 2020-06-24 ZC0077 去掉方法GetRHPByResourcePrice入参FromDate

/// w ##Class(web.DHCEQ.RM.CTResourcePrice).GetRHPByResourcePrice("1")
ClassMethod GetRHPByResourcePrice(ResourcePriceDR)
{
	s vRHPRowID=""
	i ResourcePriceDR="" q ""  //Modify by zc 2020-06-24 ZC0077 去掉方法GetRHPByResourcePrice入参FromDate
	s vEHRowID=0
	f  s vEHRowID=$o(^DHCEQSResourceHistoryPrice(0,"ResourcePrice",ResourcePriceDR,vEHRowID)) q:vEHRowID=""  d
	.q:$p($g(^DHCEQSResourceHistoryPrice(vEHRowID)),"^",9)="N"
	.;q:$p($g(^DHCEQSResourceHistoryPrice(vEHRowID)),"^",7)'=FromDate  //Modify by zc 2020-06-24 ZC0077 去掉方法GetRHPByResourcePrice入参FromDate
	.s vRHPRowID=vEHRowID
	q vRHPRowID
}

}
