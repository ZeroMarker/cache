/// 名称: web.DHCEQ.EM.BUSRentEquip
/// 描述: 设备租赁台账管理
/// 编写者：ZX
/// 编写日期: 2019-07-20
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSRentEquip Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2019-07-20
/// Description:   租赁设备台账查询
/// Table：        DHC_EQRentEquip
/// Input：        RowID:台账ID
/// Return：       表数据解析 json返回
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSRentEquip","RentEquipList")
Query RentEquipList(Desc As %String = "", RentStatus As %String = "", EquipStatus As %String = "") As %Query(ROWSPEC = "TRentEquipID:%String,TEquipDR:%String,TEquipName:%String,TEquipNo:%String,TModel:%String,TManuFactory:%String,TLeaveFactoryNo:%String,TRentLoc:%String,TRentStatus:%String,TWashFlag:%String,TInspectFlag:%String,TEquipStatus:%String")
{
}

ClassMethod RentEquipListExecute(ByRef qHandle As %Binary, Desc As %String = "", RentStatus As %String = "", EquipStatus As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ModelIDs=""
	i Desc'="" s Desc=$ZCONVERT(Desc,"U")
	
	s StoreLocDR="497"  // 租赁中心
	;判断是否为租赁中心
	s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",0))
	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLocDR)) q $$$OK
	
	s ItemDR=0
	f  s ItemDR=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocDR,ItemDR)) q:ItemDR=""  d
	.s ERowID=0
	.f  s ERowID=$o(^DHCEQEquip(0,"StoreLocItem",StoreLocDR,ItemDR,ERowID)) q:ERowID=""  d
	..;过滤无效掉设备
	..q:$p($g(^DHCEQEquip(ERowID)),"^",59)="Y"
	..;只取非报废和其他的
	..q:$p($g(^DHCEQEquip(ERowID)),"^",38)>2
	..;只取在库的
	..q:($p($g(^DHCEQEquip(ERowID)),"^",60)<1)||($p($g(^DHCEQEquip(ERowID)),"^",60)>2)
	..d ResetVariablesRentEquip
	..s FindFlag=0
	..s RentEquipID=0
	..f  s RentEquipID=$o(^DHCEQRentEquip(0,"Equip",ERowID,RentEquipID)) q:RentEquipID=""  d
	...s TRentEquipID=RentEquipID
	...s TWashFlag=$p($g(^DHCEQRentEquip(RentEquipID)),"^",11)
	...s TInspectFlag=$p($g(^DHCEQRentEquip(RentEquipID)),"^",12)
	...s TRentStatus=$p($g(^DHCEQRentEquip(RentEquipID)),"^",10)
	...i (RentStatus'="")&&(RentStatus'=TRentStatus) s FindFlag=1
	...s TEquipStatus=$p($g(^DHCEQRentEquip(RentEquipID)),"^",13)
	...i (EquipStatus'="")&&(EquipStatus'=TEquipStatus) s FindFlag=1
	..q:FindFlag'=0
	..s TRentStatus=$CASE(TRentStatus,"":"在库", "0":"在库", "1":"租借")
	..s TEquipStatus=$CASE(TEquipStatus,"":"待检", "0":"待检", "1":"完好", "2":"故障")
	..s TWashFlag=$CASE(TWashFlag,"":"否", "N":"否", "Y":"是")
	..s TInspectFlag=$CASE(TInspectFlag,"":"否", "N":"否", "Y":"是")
	..s TEquipDR=ERowID
	..s TEquipName=$p($g(^DHCEQEquip(ERowID)),"^",1)
	..q:(Desc'="")&($ZCONVERT(TEquipName,"U")'[Desc)
	..s TEquipNo=$p($g(^DHCEQEquip(ERowID)),"^",71)
	..s TModelDR=$p($g(^DHCEQEquip(ERowID)),"^",3)
	..i TModelDR'="" s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	..s TManuFactoryDR=$p($g(^DHCEQEquip(ERowID)),"^",26)
	..i TManuFactoryDR'="" s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	..s TLeaveFactoryNo=$p($g(^DHCEQEquip(ERowID)),"^",10)
	..s TRentLocDR=$p($g(^DHCEQEquip(ERowID)),"^",86)
	..i TRentLocDR'="" s TRentLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRentLocDR)
	..d OutputRowRentEquip
	
	Quit $$$OK
	
OutputRowRentEquip
    s Data=$lb(TRentEquipID,TEquipDR,TEquipName,TEquipNo,TModel,TManuFactory,TLeaveFactoryNo,TRentLoc,TRentStatus,TWashFlag,TInspectFlag,TEquipStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesRentEquip
	s (TRentEquipID,TEquipDR,TEquipName,TEquipNo,TModelDR,TModel,TManuFactoryDR,TManuFactory,TLeaveFactoryNo,TRentLocDR,TRentLoc,TRentStatus,TWashFlag,TInspectFlag,TEquipStatus)=""
	quit
}

ClassMethod RentEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RentEquipListExecute ]
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

ClassMethod RentEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RentEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod SavaOperateLog(SourceType, SourceID, Remark As %String = "", User As %String = "")
{
	n valList,TSourceType,TSourceID
	k PLIST
	i SourceType=""||SourceID="" q -1
	s Date=+$H
	s Time=$p($H,",",2)
	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Flag=0
	
	s PLIST(2)=SourceType
	s PLIST(3)=SourceID
	s PLIST(6)=Date
	s PLIST(7)=Time
	s PLIST(8)=User
	s PLIST(9)=Remark

	&SQL(Insert Into SQLUSER.DHC_EQOperateLog Values :PLIST())
	s OIRowID=$G(%ROWID)
	
	i SQLCODE s Flag=SQLCODE

	q Flag
}

/// add by zx 2019-07-21
/// DHC_EQRentEquip 租借归还操作租赁设备各状态
/// w ##Class(web.DHCEQ.EM.BUSRentEquip).UpdateRentEquipStatus()
ClassMethod UpdateRentEquipStatus(RentEquipID, EquipRentStatus As %String = "", EquipStatus As %String = "")
{
	i RentEquipID="" q "-1"
	s RentFlag=0
	s CurRentID=""
	&SQL(select RE_RowID into :CurRentID from SQLUSER.DHC_EQRentEquip where RE_EquipDR=:RentEquipID)
	//借出
	i EquipStatus=0 s EquipStatus=1
	e  i EquipStatus=1 s EquipStatus=2
	i EquipRentStatus=1
	{
		i CurRentID="" d
		.&SQL(Insert into SQLUSER.DHC_EQRentEquip(RE_EquipDR,RE_RentStatus,RE_WashFlag,RE_InspectFlag,RE_EquipStatus) values (:RentEquipID,:EquipRentStatus,'Y','Y',:EquipStatus))
		e  d
		.&SQL(Update SQLUSER.DHC_EQRentEquip (RE_RentStatus,RE_EquipStatus) values (:EquipRentStatus,:EquipStatus) where RE_RowID=:CurRentID)
	}
	i EquipRentStatus=0
	{
		i CurRentID="" d
		.&SQL(Insert into SQLUSER.DHC_EQRentEquip(RE_EquipDR,RE_RentStatus,RE_WashFlag,RE_InspectFlag,RE_EquipStatus) values (:RentEquipID,:EquipRentStatus,'N','N','0'))
		e  d
		.&SQL(Update SQLUSER.DHC_EQRentEquip (RE_RentStatus,RE_WashFlag,RE_InspectFlag,RE_EquipStatus) values (:EquipRentStatus,'N','N','0') where RE_RowID=:CurRentID)
	}
	i SQLCODE q SQLCODE
	q RentFlag
}

/// add by zx 2019-07-21
/// DHC_EQRentEquip 设备清洗、检测操作
ClassMethod UpdateRentEquip(RentEquipID, EquipStatus As %String = "", WashFlag As %String = "", InspectFlag As %String = "", User As %String = "")
{
	s CurRentID=""
	Set $ZT="ERRORRenEquipSave"
	&SQL(select RE_RowID into :CurRentID from SQLUSER.DHC_EQRentEquip where RE_EquipDR=:RentEquipID)
	s WashFlag=##Class(web.DHCEQCommon).TransValueFromPage(WashFlag,"bool")
	s InspectFlag=##Class(web.DHCEQCommon).TransValueFromPage(InspectFlag,"bool")
	s EquipStatus=##Class(web.DHCEQCommon).TransValueFromPage(EquipStatus,"bool")
	i EquipStatus="Y" s EquipStatus=1
	e  s EquipStatus=2
	TSTART
	if CurRentID=""
	{
		&SQL(Insert into SQLUSER.DHC_EQRentEquip(RE_EquipDR,RE_WashFlag,RE_InspectFlag,RE_EquipStatus) values (:RentEquipID,:WashFlag,:InspectFlag,:EquipStatus))
		s CurRentID=$G(%ROWID)
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQRentEquip (RE_WashFlag,RE_InspectFlag,RE_EquipStatus) values (:WashFlag,:InspectFlag,:EquipStatus) where RE_RowID=:CurRentID)
	}
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s Remark="EquipID:"_RentEquipID_",WashFlag:"_WashFlag_",:InspectFlag:"_InspectFlag_",EquipStatus:"_EquipStatus
	s SQLCODE=##Class(web.DHCEQ.EM.BUSRentEquip).SavaOperateLog("64-1",CurRentID,Remark,User)
	if SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q CurRentID
ERRORRenEquipSave
 	TROLLBACK		         //回滚事务
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORRenEquipSave"_ErrorMsg     //返回错误消息
}

ClassMethod GetOneRentEquip(EquipID As %Library.String = "")
{
	i EquipID="" q ""
	s RentEquipID=$o(^DHCEQRentEquip(0,"Equip",EquipID,""))
	i RentEquipID="" q ""
	q $g(^DHCEQRentEquip(RentEquipID))
}

/// ##Class(web.DHCEQ.EM.BUSRentEquip).CheckEquipStatus("EquipID")
ClassMethod CheckEquipStatus(vEquipID)
{
	s RentStatusFlag=1
	i vEquipID="" q RentStatusFlag
	s RentEquipID=$o(^DHCEQRentEquip(0,"Equip",vEquipID,""))
	i RentEquipID="" q RentStatusFlag
	i ($p($g(^DHCEQRentEquip(RentEquipID)),"^",11)="Y")&&($p($g(^DHCEQRentEquip(RentEquipID)),"^",12)="Y")&&($p($g(^DHCEQRentEquip(RentEquipID)),"^",13)="1") s RentStatusFlag=0
	
	q RentStatusFlag
}

}
