/// 名称: web.DHCEQ.RM.BUSShareResource
/// 描述: 设备租赁共享资源
/// 编写者：ZX
/// 编写日期: 2019-12-19
/// 产品组：设备管理
Class web.DHCEQ.RM.BUSShareResource Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2019-12-17
/// Description:   共享资源明细查询
/// Input：
/// Modify by zx 2020-04-20 BUG ZX0084
/// 增加参数 RentStatus '0':'在库','1':'租赁中','2':'租赁预约'
///          EquipStatus '0':'完好', '1':'故障','2':'报废'
Query ShareResource(ShareType As %String = "", EquipDR As %String = "", RentLocDR As %String = "", LocID As %String = "", UserID As %String = "", CurJob, RentStatus As %String = "", EquipStatus As %String = "", IsLoanOut As %String = "") As %Query(ROWSPEC = "RERowID:%String,REPutOnSetDR:%String,REShareType:%String,REEquipDR:%String,RESubID:%String,RESubName:%String,REHospitalDR:%String,REHospitalDR_HOSPDesc:%String,RELocDR:%String,RELocDR_DeptDesc:%String,REManageLocDR:%String,REManageLocDR_DeptDesc:%String,REOuterType:%String,REEquipName:%String,REEquipNo:%String,REModelDR:%String,REModelDR_MDesc:%String,RELeaveFactoryNo:%String,RERentLocDR:%String,RERentLocDR_DeptDesc:%String,RERentStatus:%String,REWashFlag:%String,REInspectFlag:%String,REEquipStatus:%String,REPutOnFlag:%String,REHold1:%String,REHold2:%String,REHold3:%String,REHold4:%String,REHold5:%String,REActionCode:%String,REActionDesc:%String,REBussID:%String,RERoles:%String,RESelfSource:%String")
{
}

ClassMethod ShareResourceExecute(ByRef qHandle As %Binary, ShareType As %String = "", EquipDR As %String = "", RentLocDR As %String = "", LocID As %String = "", UserID As %String = "", CurJob, RentStatus As %String = "", EquipStatus As %String = "", IsLoanOut As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	Do ##Class(web.DHCEQCommon).KillTempGlobal("ShareResource")  //临时global汇总
	i LocID="" s LocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s (TotalNum,TotalStockNum,TotalLoanNum,TotalRentNum,FaultNum)=0 //Modify by zx 2020-04-20 BUG ZX0084
	s LocIDType=##class("web.DHCEQ.RM.BUSShareResource").CheckLocType(LocID)  //判断当前登录科室是否是租赁中心
	
	f  s rowid=$o(^DHCEQSShareResource(rowid))  quit:rowid=""  d
	.d ResetVariablesShareResource
	.q:$p($g(^DHCEQSShareResource(rowid)),"^",19)="N"
	.s TRowID=rowid
	.s TPutOnSetDR=$p($g(^DHCEQSShareResource(rowid)),"^",1)
	.s TShareType=$p($g(^DHCEQSShareResource(rowid)),"^",2)
	.s TShareType =$CASE(TShareType,"0":"设备", "1":"Room","":"")
	.s TEquipDR=$p($g(^DHCEQSShareResource(rowid)),"^",3)
	.q:(EquipDR'="")&&(EquipDR'=TEquipDR)
	.s TSubID=$p($g(^DHCEQSShareResource(rowid)),"^",4)
	.s TSubName=$p($g(^DHCEQSShareResource(rowid)),"^",5)
	.s THospitalDR=$p($g(^DHCEQSShareResource(rowid)),"^",6)
	.i THospitalDR'="" s THospital=$Piece($Get(^CT("HOSP",THospitalDR)),"^",2)
	.s TLocDR=$p($g(^DHCEQSShareResource(rowid)),"^",7)
	.i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.;Modify by zx 2020-04-27 
	.s TSelfSource="非自有"
	.i (LocID'="")&&(LocID=TLocDR) s TSelfSource="自有"
	.s TManageLocDR=$p($g(^DHCEQSShareResource(rowid)),"^",8)
	.i TManageLocDR'="" s TManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	.s TOuterType=$p($g(^DHCEQSShareResource(rowid)),"^",9)
	.i TOuterType'="" s TOuterType =$CASE(TOuterType,"0":"院内共享", "1":"院区共享","2":"院外共享")
	.s TEquipName=$p($g(^DHCEQSShareResource(rowid)),"^",10)
	.s TEquipNo=$p($g(^DHCEQSShareResource(rowid)),"^",11)
	.s TModelDR=$p($g(^DHCEQSShareResource(rowid)),"^",12)
	.i TModelDR'="" s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.s TLeaveFactoryNo=$p($g(^DHCEQSShareResource(rowid)),"^",13)
	.s TRentLocDR=$p($g(^DHCEQSShareResource(rowid)),"^",14)
	.q:(RentLocDR'="")&&(RentLocDR'=TRentLocDR)
	.q:(LocIDType'="1")&&((TLocDR'=LocID)&&(TRentLocDR'=LocID)) //非租赁中心只显示当科室共享设设备或租赁设备
	.q:(IsLoanOut="1")&&(TLocDR'=LocID)
	.i TRentLocDR'="" s TRentLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRentLocDR)
	.//Modify by zx 2020-12-08 过滤条件提前,避免数据合计错误 BUG ZX0120
	.s TEquipStatus=$p($g(^DHCEQSShareResource(rowid)),"^",18)
	.q:(EquipStatus'="")&&(EquipStatus'=TEquipStatus) //Modify by zx 2020-04-20 BUG ZX0084
	.i TEquipStatus="1" s FaultNum=FaultNum+1 //Modify by zx 2020-04-20 BUG ZX0084
	.q:TEquipStatus="2"  //Modify by zx 2020-08-27 BUG ZX0105 过滤状态报废资源
	.s TEquipStatus =$CASE(TEquipStatus,"0":"完好", "1":"故障","2":"报废","":"")
	.s TRentStatus=$p($g(^DHCEQSShareResource(rowid)),"^",15)
	.q:(RentStatus'="")&&(RentStatus'=TRentStatus) //Modify by zx 2020-04-20 BUG ZX0084
	.i TRentStatus="0" s TotalStockNum=TotalStockNum+1
	.i TRentStatus="1" d
	..i TLocDR=LocID s TotalLoanNum=TotalLoanNum+1 
	..i TRentLocDR=LocID s TotalRentNum=TotalRentNum+1
	.s TRentStatus =$CASE(TRentStatus,"0":"在库", "1":"租赁中","2":"预约租赁","":"")
	.;Modify by zx 2020-04-27 
	.i TPutOnSetDR'="" s TShareItemDR=$p($g(^DHCEQSPutOnSet(TPutOnSetDR)),"^",22)
	.i TShareItemDR'="" d
	..s TIsWashFlag=$p($g(^DHCEQSCShareItem(TShareItemDR)),"^",6)
	..s TIsInspectFlag=$p($g(^DHCEQSCShareItem(TShareItemDR)),"^",7)
	.i TIsWashFlag="Y" d
	..s TWashFlag=$p($g(^DHCEQSShareResource(rowid)),"^",16)
	.s TWashFlag =$CASE(TWashFlag,"N":"未处理", "Y":"已处理","":"不需处理")
	.i TIsInspectFlag="Y" d
	..s TInspectFlag=$p($g(^DHCEQSShareResource(rowid)),"^",17)
	.s TInspectFlag =$CASE(TInspectFlag,"N":"未处理", "Y":"已处理","":"不需处理")
	.s TPutOnFlag=$p($g(^DHCEQSShareResource(rowid)),"^",19)
	.s THold1=$p($g(^DHCEQSShareResource(rowid)),"^",20)
	.s THold2=$p($g(^DHCEQSShareResource(rowid)),"^",21)
	.s THold3=$p($g(^DHCEQSShareResource(rowid)),"^",22)
	.s THold4=$p($g(^DHCEQSShareResource(rowid)),"^",23)
	.s THold5=$p($g(^DHCEQSShareResource(rowid)),"^",24)
	.s TotalNum=TotalNum+1
	.;Modify by zx Bug ZX0084 增加动作输出生成操作按钮 
	.s TOprateInfo=##class("web.DHCEQ.RM.BUSShareResource").ShareResourceOprate(rowid,UserID)
	.s TBussID=$p(TOprateInfo,"^",1)
	.i TBussID'="" d
	..s TActionDR=$p(TOprateInfo,"^",2)
	..s TRoles=","_$p(TOprateInfo,"^",3)
	..s TActionLength=$l(TActionDR,",")
	..f Cur=1:1:TActionLength d
	...s CurActionDR=$p(TActionDR,",",Cur)
	...q:CurActionDR=""
	...s TActionCode=TActionCode_","
	...s TActionDesc=TActionDesc_","
	...s TActionCode=TActionCode_$p($g(^DHCEQCCode("DHCEQCAction",CurActionDR)),"^",1)
	...s TActionDesc=TActionDesc_$p($g(^DHCEQCCode("DHCEQCAction",CurActionDR)),"^",2)
	.d OutputRowShareResource
	
	s ^DHCEQTemp("ShareResource",+$H,CurJob)=TotalNum_"^"_TotalStockNum_"^"_TotalLoanNum_"^"_TotalRentNum_"^"_FaultNum //Modify by zx 2020-04-20 BUG ZX0084
	Quit $$$OK
OutputRowShareResource
	s Data=$lb(TRowID,TPutOnSetDR,TShareType,TEquipDR,TSubID,TSubName,THospitalDR,THospital,TLocDR,TLoc,TManageLocDR,TManageLoc,TOuterType,TEquipName,TEquipNo,TModelDR,TModel,TLeaveFactoryNo,TRentLocDR,TRentLoc,TRentStatus,TWashFlag,TInspectFlag,TEquipStatus,TPutOnFlag,THold1,THold2,THold3,THold4,THold5,TActionCode,TActionDesc,TBussID,TRoles,TSelfSource)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesShareResource
	s (TRowID,TPutOnSetDR,TShareType,TEquipDR,TSubID,TSubName,THospitalDR,THospital,TLocDR,TLoc,TManageLocDR,TManageLoc,TOuterType,TEquipName,TEquipNo,TModelDR,TModel,TLeaveFactoryNo,TRentLocDR,TRentLoc,TRentStatus,TWashFlag,TInspectFlag,TEquipStatus,TPutOnFlag,THold1,THold2,THold3,THold4,THold5,TOprateInfo,TActionCode,TActionDesc,TBussID,TRoles,TIsWashFlag,TIsInspectFlag,TSelfSource,TShareItemDR)=""
	quit
}

ClassMethod ShareResourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ShareResourceExecute ]
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

ClassMethod ShareResourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ShareResourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      ZX
/// CreatDate：    2019-12-23
/// Description:   可供上架设备信息查询
/// Input：PutOnSetDR:上架设置ID 必填, ParaEquip:设备信息 可是名称或编号, ParaItemDR:设备项ID, ParaModelDR:机型ID, ParaLocDR:科室ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSShareResource","GetEquipListBySet","2","","","")
Query GetEquipListBySet(ParaPutOnSetDR As %String = "", ParaEquip As %String = "", ParaItemDR As %String = "", ParaModelDR As %String = "", ParaLocDR As %String = "", ParaLocID As %String = "") As %Query(ROWSPEC = "TPutOnSetDR:%String,TEquipDR:%String,TEquipNo:%String,TEquipName:%String,TModel:%String,TItem:%String,TStoreLoc:%String,TLeaveFactoryNo:%String,TManuFactory:%String,TStartDate:%String")
{
}

ClassMethod GetEquipListBySetExecute(ByRef qHandle As %Binary, ParaPutOnSetDR As %String = "", ParaEquip As %String = "", ParaItemDR As %String = "", ParaModelDR As %String = "", ParaLocDR As %String = "", ParaLocID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	i ParaLocID="" s ParaLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	s LocIDType=##class("web.DHCEQ.RM.BUSShareResource").CheckLocType(ParaLocID)
	
	i (LocIDType="1")&&(ParaPutOnSetDR="") Quit $$$OK
	s (EquipDR,ItemDR,ModelDR,LocDR)=""
	i LocIDType="0" d
	.s LocDR=ParaLocID
	e  d
	.s EquipDR=$p($g(^DHCEQSPutOnSet(ParaPutOnSetDR)),"^",2)
	.s ItemDR=$p($g(^DHCEQSPutOnSet(ParaPutOnSetDR)),"^",4)
	.s ModelDR=$p($g(^DHCEQSPutOnSet(ParaPutOnSetDR)),"^",5)
	.s LocDR=$p($g(^DHCEQSPutOnSet(ParaPutOnSetDR)),"^",7)
	
	i EquipDR'="" d
	.d BuildDataEquipList
	e  i LocDR'="" d
	.s CurEquipDR=0
	.f  s CurEquipDR=$o(^DHCEQEquip(0,"StoreLoc",LocDR,CurEquipDR)) q:CurEquipDR=""  d
	..s CurItemDR=$p($g(^DHCEQEquip(CurEquipDR)),"^",7)
	..q:(ItemDR'="")&&(ItemDR'=CurItemDR)
	..s CurModelDR=$p($g(^DHCEQEquip(CurEquipDR)),"^",3)
	..q:(ModelDR'="")&&(ModelDR'=CurModelDR)
	..s EquipDR=CurEquipDR
	..d BuildDataEquipList
	e  i ItemDR'="" d
	.s CurLocDR=0
	.f  s CurLocDR=$o(^DHCEQEquip(0,"StoreLocItem",CurLocDR)) q:CurLocDR=""  d
	..s CurEquipDR=0
	..f  s CurEquipDR=$o(^DHCEQEquip(0,"StoreLocItem",CurLocDR,ItemDR,CurEquipDR)) q:CurEquipDR=""  d
	...s CurModelDR=$p($g(^DHCEQEquip(CurEquipDR)),"^",3)
	...q:(ModelDR'="")&&(ModelDR'=CurModelDR)
	...s EquipDR=CurEquipDR
	...d BuildDataEquipList
	
	Quit $$$OK
BuildDataEquipList
	d ResetVariablesGetEquipListBySet
	s TPutOnSetDR=ParaPutOnSetDR
	i LocIDType="0" d
	.s TPutOnSetDR=##class("web.DHCEQ.RM.BUSShareResource").CheckIsInPutOnSet(EquipDR,"")
	q:+TPutOnSetDR=0
	s TEquipDR=EquipDR
	q:$p($g(^DHCEQEquip(EquipDR)),"^",59)="Y"   // Modfied by zc0122 2022-10-12 过滤无效设备
	q:'(($p($g(^DHCEQEquip(EquipDR)),"^",60)="1")&&($p($g(^DHCEQEquip(EquipDR)),"^",38)<=2))   // Modfied by zc0122 2022-10-12 过滤未入库、退货、减少与报废设备
	q:+##Class(web.DHCEQ.RM.BUSShareResource).CheckAlreadyOnPut(EquipDR)'="0"
	s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s TEquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	q:(ParaEquip'="")&&($ZCONVERT(TEquipName,"U")'[ParaEquip)&&($ZCONVERT(TEquipNo,"U")'[ParaEquip)
	s TModelDR=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	q:(ParaModelDR'="")&&(ParaModelDR'=TModelDR)
	i TModelDR'="" s TModel=##class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	s TItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
	q:(ParaItemDR'="")&&(ParaItemDR'=TItemDR)
	i TItemDR'="" s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	s TStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	q:(ParaLocDR'="")&&(ParaLocDR'=TStoreLocDR)
	i TStoreLocDR'="" s TStoreLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	s TLeaveFactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
	s TManuFactoryDR=$p($g(^DHCEQEquip(EquipDR)),"^",26)
	i TManuFactoryDR'="" s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	s TStartDate=$p($g(^DHCEQEquip(EquipDR)),"^",44)
	i TStartDate'="" s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	d OutputRowGetEquipListBySet
	quit
OutputRowGetEquipListBySet
	s Data=$lb(TPutOnSetDR,TEquipDR,TEquipNo,TEquipName,TModel,TItem,TStoreLoc,TLeaveFactoryNo,TManuFactory,TStartDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquipListBySet
	s (TPutOnSetDR,TEquipDR,TEquipNo,TEquipName,TModelDR,TModel,TItemDR,TItem,TStoreLocDR,TStoreLoc,TLeaveFactoryNo,TManuFactoryDR,TManuFactory,TStartDate)=""
	quit
}

ClassMethod GetEquipListBySetFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipListBySetExecute ]
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

ClassMethod GetEquipListBySetClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipListBySetExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      ZX
/// CreatDate：    2019-12-23
/// Description:   检测设备是否已经上架
/// Input：        ParaEquipDR:设备ID
/// Return：       0:未上架,1:上架
/// w ##Class(web.DHCEQ.RM.BUSShareResource).CheckAlreadyOnPut(1)
ClassMethod CheckAlreadyOnPut(ParaEquipDR As %Library.String = "")
{
	n ReturnFlag,ShareResourceDR,PutOnFlag
	s (ReturnFlag,ShareResourceDR,PutOnFlag)=""
	s ReturnFlag=0
	i ParaEquipDR="" q ReturnFlag
	s ShareResourceDR=0
	f  s ShareResourceDR=$o(^DHCEQSShareResource(0,"Equip",ParaEquipDR,ShareResourceDR)) q:ShareResourceDR=""  d
	.s PutOnFlag=$p($g(^DHCEQSShareResource(ShareResourceDR)),"^",19)
	.i PutOnFlag="Y" s ReturnFlag=1
	
	q ReturnFlag
}

/// Creator：      ZX
/// CreatDate：    2019-12-26
/// Description:   设备上架处理
/// Input：        ParaEquipDR:设备ID
/// Return：       
/// w ##Class(web.DHCEQ.RM.BUSShareResource).SaveShareResource("1","33")
ClassMethod SaveShareResource(ParaPutOnSetDR As %Library.String = "", ParaEquipDR As %Library.String = "")
{
	i (ParaPutOnSetDR="")||(ParaEquipDR="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-3401") //无效上架设置
	k PLIST,RowID
	s IsPutOn=##Class(web.DHCEQ.RM.BUSShareResource).CheckAlreadyOnPut(ParaEquipDR)
	i IsPutOn="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-3402") //资源已上架设置
	s RowID=""
	&SQL(Select RE_RowID into :RowID from SQLUSER.DHC_EQSShareResource where RE_EquipDR=:ParaEquipDR)

	s PLIST(2)=ParaPutOnSetDR                           // RE_PutOnSetDR
	s PLIST(3)=$p($g(^DHCEQSPutOnSet(ParaPutOnSetDR)),"^",1)     // RE_ShareType
	s PLIST(5)=$p($g(^DHCEQSPutOnSet(ParaPutOnSetDR)),"^",3)     // RE_SubID
	//Modify by zx 2020-04-10 BUG ZX0083
	i PLIST(5)'="" s PLIST(6)=$p($g(^DHCEQBuildingUnit(PLIST(5))),"^",2)     // RE_SubName  
	s PLIST(7)=$p($g(^DHCEQSPutOnSet(ParaPutOnSetDR)),"^",6)     // RE_HospitalDR
	s PLIST(8)=$p($g(^DHCEQEquip(ParaEquipDR)),"^",67)           // RE_LocDR
	s PLIST(9)=$p($g(^DHCEQSPutOnSet(ParaPutOnSetDR)),"^",8)     // RE_ManageLocDR
	s PLIST(10)=$p($g(^DHCEQSPutOnSet(ParaPutOnSetDR)),"^",10)   // RE_OuterType
	s PLIST(11)=$p($g(^DHCEQEquip(ParaEquipDR)),"^",1)  // RE_EquipName
	s PLIST(12)=$p($g(^DHCEQEquip(ParaEquipDR)),"^",71) // RE_EquipNo
	s PLIST(13)=$p($g(^DHCEQEquip(ParaEquipDR)),"^",3)  // RE_ModelDR
	s PLIST(14)=$p($g(^DHCEQEquip(ParaEquipDR)),"^",10) // RE_LeaveFactoryNo
	s PLIST(16)="0"                                     // RE_RentStatus
	//Modified by QW20200624 Bug:QW0068 begin 共享资源-根据台账设置资源状态
	s EQAdvanceDisFlag=$p($g(^DHCEQEquip(ParaEquipDR)),"^",93)
	s EQStatus = $p($g(^DHCEQEquip(ParaEquipDR)),"^",38)
	if +EQStatus=3  s PLIST(19)="2"
	else  if +EQAdvanceDisFlag=3 s PLIST(19)="1"
	else  s PLIST(19)="0"                                     // RE_EquipStatus
	//Modified by QW20200624 Bug:QW0068 end
	s PLIST(20)="Y"                                     // RE_PutOnFlag
	
	i RowID=""
	{
		s PLIST(4)=ParaEquipDR
		//Modify by zx 2020-08-04 BUG ZX0099 新增资源设置清洗和检测
		s PLIST(17)="Y"                                     // RE_WashFlag
		s PLIST(18)="Y"                                     // RE_InspectFlag
		&SQL(Insert Into SQLUSER.DHC_EQSShareResource Values :PLIST())
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQSShareResource  Values :PLIST()  where RE_RowID=:RowID)
	}
	i SQLCODE
 	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
}

/// Creator：      ZX
/// CreatDate：    2019-12-26
/// Description:   获取租赁待办数量合计,包含新增未提交
/// Input：        GroupID:类组 UserID:用户id
/// Return：       待办数量
/// w ##Class(web.DHCEQ.RM.BUSShareResource).GetBussAlertNum("85","71")
ClassMethod GetBussAlertNum(GroupID, UserID)
{
	new RoleIDs
	s RoleIDs=""
	
	i (GroupID="")||(UserID="") Quit ""
	s (RentWaitNum,UnSubmitNum)=0
	s RoleIDs=##Class(web.DHCEQCGroupRole).GetRolebyGroup(GroupID)
	i RoleIDs'="" s RoleIDs=","_RoleIDs_","
	s RentWaitNum=##Class(web.DHCEQMessages).GetBussAertNum("64",GroupID,UserID,RoleIDs)
	
	&SQL(SELECT count(1) into :UnSubmitNum FROM SQLUSER.DHC_EQSRent WHERE R_Status=0 and R_RequestUserDR=:UserID)
	q RentWaitNum+UnSubmitNum
}

/// Mozy	2020-1-19	共享资源业务操作
/// 入参：	BussType：业务类型
/// 				0：无 11:开箱验收 12:安装调试验收 21:入库 22:转移 23:减少 31:维修 32保养 33检查 34报废 35折旧 41使用 51设备调帐 52设备台帐 
/// 				61工程管理 62科研课题 63证件 63-1供应商资质 63-2生产厂商资质 63-3计量证书 64租赁
/// 				71保养预警 72检查预警 72-1计量检查 72-2巡检 73保修到期
/// 				81维修监控 91采购申请 92采购计划 93采购招标 94采购合同 95保修合同
/// 				A01:配件入库  A02:配件转移  A03:配件退货  A04:配件减少
/// 		BussID:业务ID
/// 		StatusFlag:(业务单)状态标志		0完好;1故障;2报废
/// 返回：0：成功
/// 		其他：失败
/// w ##Class(web.DHCEQ.RM.BUSShareResource).ChangeShareResource("1","33")
ClassMethod ChangeShareResource(BussType As %String = "", BussID As %String = "", StatusFlag As %String = "", EquipID As %String = "")
{
	i (BussType="")||(BussID="") Quit 0
	n EquipDR, ShareResourceDR, OptFlag, MRHold3, equipRowIDs, count, k
	s OptFlag=0
	
	i BussType=22
	{
		/*
		##Class(web.DHCEQ.RM.BUSShareResource).ChangeStoreMove(3,0)
		
		i $Piece($Get(^DHCEQStoreMoveList(BussID)),"^",3)="Y" d
		.s equipRowIDs=$Get(^DHCEQStoreMoveList(BussID,"EX","RowIDs"))
		e  d
		.s equipRowIDs=$Piece($Get(^DHCEQStoreMoveList(BussID)),"^",2)
		s count=$l(equipRowIDs,",")
		f k=1:1:count q:OptFlag'=0  d
		.s EquipDR=$p(equipRowIDs,",",k)
		.s ShareResourceDR=$o(^DHCEQSShareResource(0,"Equip",EquipDR,""))
		.q:ShareResourceDR=""
		.&SQL(Update SQLUSER.DHC_EQSShareResource Set RE_PutOnFlag='N' where RE_RowID=:ShareResourceDR)
		.s OptFlag=SQLCODE*/
	}
	i BussType=31
	{
		s EquipDR=+$Piece($Get(^DHCEQMExObj(+$Piece($Get(^DHCEQMMaintRequest(BussID)),"^",5))),"^",5)
		s ShareResourceDR=$o(^DHCEQSShareResource(0,"Equip",EquipDR,""))
		i ShareResourceDR'=""
		{
			; 0完好;1故障;2报废
			&SQL(Update SQLUSER.DHC_EQSShareResource Set RE_EquipStatus=:StatusFlag where RE_RowID=:ShareResourceDR)
			s OptFlag=SQLCODE
		}
	}
	i BussType=34
	{
		; 报废
		//Modify by zx 2020-08-28 BUG ZX0105 处理批量报废情况及报废恢复
		s DisuseEquipDRs=##Class(web.DHCEQBatchDisuseRequest).GetDisuseEquipIDs(BussID)
		;s EquipDR=+$p($g(^DHCEQDisuseRequestList(BussID)),"^",2)
		s OnFlag="Y"
		i StatusFlag="2" s OnFlag="N"
		if EquipID'=""				//modified by czf 2020-01-14 begin CZF0129
		{
			i (","_DisuseEquipDRs_",")'[(","_EquipID_",") q -9200		//操作失败,报废单不包含设备
			s ShareResourceDR=$o(^DHCEQSShareResource(0,"Equip",EquipID,""))
			i ShareResourceDR'="" d
			.&SQL(Update SQLUSER.DHC_EQSShareResource Set RE_EquipStatus=:StatusFlag,RE_PutOnFlag=:OnFlag where RE_RowID=:ShareResourceDR)
			.s OptFlag=SQLCODE
		}
		else			//modified by czf 2020-01-14 end CZF0129
		{
			s Len=$l(DisuseEquipDRs,",")
			for i=1:1:Len q:(OptFlag'=0)  d
			.s DisuseEquipDR=$p(DisuseEquipDRs,",",i)
			.s ShareResourceDR=$o(^DHCEQSShareResource(0,"Equip",DisuseEquipDR,""))
			.i ShareResourceDR'="" d
			..&SQL(Update SQLUSER.DHC_EQSShareResource Set RE_EquipStatus=:StatusFlag,RE_PutOnFlag=:OnFlag where RE_RowID=:ShareResourceDR)
			..s OptFlag=SQLCODE
		}
	}
	q OptFlag
}

/// Mozy	2020-1-19	转移业务设备下架处理
/// 入参：	
/// 	StoreMoveDR:转移单ID
/// 		Flag:检测类型	0:检测设置		1:下架自动设备(AutoPutOnFlag)		2:全部下架
/// 返回：空：不需要提示
/// 		其他：提示信息
/// w ##Class(web.DHCEQ.RM.BUSShareResource).ChangeStoreMove(13,0)
ClassMethod ChangeStoreMove(StoreMoveDR As %String = "", Flag As %String = "0")
{
	i (StoreMoveDR="")||(Flag="") Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0)
	;过滤非审核状态转移单		SM_Status
	i $Piece($Get(^DHCEQStoreMove(StoreMoveDR)),"^",13)'=2 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0)
	
	Set $ZT="ERRORCheckStoreMove"
	n Info,StoreMoveListID,SQLCODE,equipRowIDs,count,k,EquipDR
	s Info=""
	s SQLCODE=0
	; 上架设置是自动上架的直接修改资源表数据 不是的或提醒下架
	; 上架设置里面要分情况,按设备项的提示是否下架 按设备的直接改资源表的信息
	
	i (Flag'=0) TSTART
	
	s StoreMoveListID=0
	f  s StoreMoveListID=$o(^DHCEQStoreMoveList(0,"StoreMove",StoreMoveDR,StoreMoveListID)) q:(StoreMoveListID="")||(SQLCODE'=0)  d
	.;检测转移明细设备上架设置情况
	.i $Piece($Get(^DHCEQStoreMoveList(StoreMoveListID)),"^",3)="Y" d
	..s equipRowIDs=$Get(^DHCEQStoreMoveList(StoreMoveListID,"EX","RowIDs"))
	.e  d
	..s equipRowIDs=$Piece($Get(^DHCEQStoreMoveList(StoreMoveListID)),"^",2)
	.
	.s count=$l(equipRowIDs,",")
	.f k=1:1:count q:(SQLCODE'=0)  d
	..s EquipDR=$p(equipRowIDs,",",k)
	..s ShareResourceDR=$o(^DHCEQSShareResource(0,"Equip",EquipDR,""))
	..q:ShareResourceDR=""
	..s REPutOnSetDR=$Piece($Get(^DHCEQSShareResource(ShareResourceDR)),"^",1)
	..s AutoPutOnFlag=+$Piece($Get(^DHCEQSPutOnSet(REPutOnSetDR)),"^",9)		;;;;;;		0:否 1:是  自动上架
	..
	..if (Flag=0) d
	...;检测上架设置的设备,生成非上架的设备名称提示
	...q:AutoPutOnFlag=1
	...i Info'="" s Info=Info_","
	...s Info=Info_##Class(web.DHCEQCommon).GetTrakNameByID("masteritem", $Piece($Get(^DHCEQSPutOnSet(REPutOnSetDR)),"^",4))
	..
	..if (Flag=1) d
	...;只处理上架设置是自动上架的设备,直接修改资源表数据
	...q:AutoPutOnFlag=0
	...&SQL(Update SQLUSER.DHC_EQSShareResource Set RE_PutOnFlag='N' where RE_RowID=:ShareResourceDR)
	..
	..if (Flag=2) d
	...;全部下架,直接修改资源表数据
	...&SQL(Update SQLUSER.DHC_EQSShareResource Set RE_PutOnFlag='N' where RE_RowID=:ShareResourceDR)

	
	i (Flag'=0)
 	{
	 	i (SQLCODE'=0)
	 	{
			TROLLBACK
	 	}
	 	else
	 	{
	 		TCOMMIT
	 	}
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,StoreMoveDR)
 	}
	else
	{
		i (Info'="")
	 	{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",Info)
	 	}
	 	else
	 	{
	 		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0)
	 	}
	}
	
ERRORCheckStoreMove
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// add by csj 20200121 
/// 描述：租赁设备发生维修、维护调用方法生成对照记录
/// 入参：EquipDR 设备id, SourceType 业务类型 1维修,2保养,3质控,4清洗消毒
/// w ##class("web.DHCEQ.RM.BUSShareResource").CreateRentMaintMap("1",1)
ClassMethod CreateRentMaintMap(EquipDR, SourceType, SourceID As %String = "", UserID As %String = "")
{
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$h
	s Time=$p($h,",",2)
	s ShareResourceDR=$o(^DHCEQSShareResource(0,"Equip",EquipDR,""))
	i ShareResourceDR="" q 0
	s RentID=0
	i SourceType="4" d
	.s CurRentID=""
	.f  s CurRentID=$o(^DHCEQSRent(0,"ShareResource",ShareResourceDR,CurRentID),"-1") q:(CurRentID="")||(RentID'=0)  d
	..q:$p($g(^DHCEQSRent(CurRentID)),"^",36)'="3"
	..s RentID=CurRentID
	e  d
	.s RentID=##Class(web.DHCEQ.RM.BUSRent).CheckEquipRentStatus(ShareResourceDR)
	i +RentID="0" q 0
	&SQL(Insert into SQLUSER.DHC_EQSRentMaintMap (RMM_RentDR,RMM_Type,RMM_BussID,RMM_AddUser,RMM_AddDate,RMM_AddTime) values (:RentID ,:SourceType,:SourceID,:UserID,:Date,:Time))
	
	q SQLCODE
}

/// add by csj 20200121 
/// 描述：租赁对照
/// Input：LocID，UserID
/// d ##class("%ResultSet").RunQuery("web.DHCEQ.RM.BUSShareResource","RentMaintMap")
Query RentMaintMap(LocID As %String = "", UserID As %String = "") As %Query(ROWSPEC = "RMMRowID:%String,RMMRentDR:%String:%String,RMMType:%String,RMMTypeDesc:%String,RMMMaintReason:%String,RMMMaintReasonDesc:%String,RMMBussID:%String,RMMMaintContent:%String,RMMResultStatus:%String,RMMResultStatusDesc:%String,RMMMaintResult:%String,RMMAddUser:%String,RMMAddDate:%String,RMMAddTime:%String,RMMRemark:%String,RMMHold1:%String,RMMHold2:%String,RMMHold3")
{
}

ClassMethod RentMaintMapExecute(ByRef qHandle As %Binary, LocID As %String = "", UserID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	i LocID="" s LocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	f  s rowid=$o(^DHCEQSRentMaintMap(rowid))  quit:rowid=""  d
	.d ResetVariablesRentMaintMap
	.s RMMRowID=rowid
	.s RMMRentDR=$p($g(^DHCEQSRentMaintMap(rowid)),"^",1)
	.s RMMType=$p($g(^DHCEQSRentMaintMap(rowid)),"^",2)
	.s RMMTypeDesc=$Case(RMMType,"1":"维修","2":"保养",3:"质控","4":"清洗消毒","":"")
	.s RMMMaintReason=$p($g(^DHCEQSRentMaintMap(rowid)),"^",3)
	.s RMMMaintReasonDesc=$Case(RMMResultStatus,"1":"科室原因","2":"自然因素","":"")
	.s RMMBussID=$p($g(^DHCEQSRentMaintMap(rowid)),"^",4)
	.s RMMMaintContent=$p($g(^DHCEQSRentMaintMap(rowid)),"^",5)
	.s RMMResultStatus=$p($g(^DHCEQSRentMaintMap(rowid)),"^",6)
	.s RMMResultStatusDesc=$Case(RMMResultStatus,"1":"完好","2":"有缺陷",3:"故障","":"")
	.s RMMMaintResult=$p($g(^DHCEQSRentMaintMap(rowid)),"^",7)
	.s RMMAddUser=$p($g(^DHCEQSRentMaintMap(rowid)),"^",8)
	.i RMMAddUser'="" s RMMAddUser=##class(web.DHCEQCommon).GetTrakNameByID("user",RMMAddUser)
	.s RMMAddDate=$p($g(^DHCEQSRentMaintMap(rowid)),"^",9)
	.i RMMAddDate'="" s RMMAddDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	.s RMMAddTime=$p($g(^DHCEQSRentMaintMap(rowid)),"^",10)
	.i RMMAddTime'="" s RMMAddTime=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	.s RMMRemark=$p($g(^DHCEQSRentMaintMap(rowid)),"^",11)
	.s RMMHold1=$p($g(^DHCEQSRentMaintMap(rowid)),"^",12)
	.s RMMHold2=$p($g(^DHCEQSRentMaintMap(rowid)),"^",13)
	.s RMMHold3=$p($g(^DHCEQSRentMaintMap(rowid)),"^",14)
	.d OutputRowRentMaintMap
	Quit $$$OK
OutputRowRentMaintMap
	s Data=$lb(RMMRowID,RMMRentDR,RMMType,RMMTypeDesc,RMMMaintReason,RMMMaintReasonDesc,RMMBussID,RMMMaintContent,RMMResultStatus,RMMResultStatusDesc,RMMMaintResult,RMMAddUser,RMMAddDate,RMMAddTime,RMMRemark,RMMHold1,RMMHold2,RMMHold3)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesRentMaintMap
	s (RMMRowID,RMMRentDR,RMMType,RMMTypeDesc,RMMMaintReason,RMMMaintReasonDesc,RMMBussID,RMMMaintContent,RMMResultStatus,RMMResultStatusDesc,RMMMaintResult,RMMAddUser,RMMAddDate,RMMAddTime,RMMRemark,RMMHold1,RMMHold2,RMMHold3)=""
	quit
}

ClassMethod RentMaintMapFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RentMaintMapExecute ]
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

ClassMethod RentMaintMapClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = RentMaintMapExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by zx 20200121 
/// 描述：租赁设备完成后对设备进行清洗消毒、检测等操作
/// 入参：ShareResourceDR 共享资源id, Type 操作类型 1 清洗消毒; 2 检测
/// w ##class("web.DHCEQ.RM.BUSShareResource").ChangeShareResourceStatus("1",1)
ClassMethod ChangeShareResourceStatus(ShareResourceDR, Type)
{
	s $ZT="ERRORShareResourceStatus"
	i (ShareResourceDR="")||(Type="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1")
	TSTART
	i Type="1"
	{
		&SQL(update sqluser.DHC_EQSShareResource set RE_WashFlag='Y' where RE_RowID=:ShareResourceDR)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s EquipDR=$p($g(^DHCEQSShareResource(ShareResourceDR)),"^",3)
		s SQLCODE=##class("web.DHCEQ.RM.BUSShareResource").CreateRentMaintMap(EquipDR,"4")
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	elseif Type="2"
	{
		&SQL(update sqluser.DHC_EQSShareResource set RE_InspectFlag='Y' where RE_RowID=:ShareResourceDR)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ShareResourceDR)
	
ERRORShareResourceStatus
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// add by csj 20200121 
/// 描述：共享资源下架操作
/// 入参：ShareResourceDR 共享资源id
/// w ##class("web.DHCEQ.RM.BUSShareResource").PutOffShareResource("1")
ClassMethod PutOffShareResource(ShareResourceDR)
{
	i ShareResourceDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1")
	&SQL(update sqluser.DHC_EQSShareResource set RE_PutOnFlag='N' where RE_RowID=:ShareResourceDR)
	i SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ShareResourceDR)
}

/// add by zx 2020-02-14
/// 描述：判断当前科室是否是租赁中心
/// 入参：CurLocDR 科室ID
/// 输出：TypeFlag, 0 否, 1 是
/// w ##class("web.DHCEQ.RM.BUSShareResource").CheckLocType("1")
ClassMethod CheckLocType(CurLocDR)
{
	n TypeFlag,LocTypeDR,StoreLocDR
	s TypeFlag=0
	i CurLocDR="" q TypeFlag
	s LocTypeDR=0
	f  s LocTypeDR=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0301",LocTypeDR)) q:(LocTypeDR="")||(TypeFlag=1)  d
	.s StoreLocDR=0
	.f  s StoreLocDR=$o(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocTypeDR,StoreLocDR)) q:(StoreLocDR="")||(TypeFlag=1)  d
	..i CurLocDR=StoreLocDR s TypeFlag=1
	..q:TypeFlag=1
	
	q TypeFlag
}

/// add by zx 2020-02-14
/// 描述：共享资源汇总数据获取
/// 入参：CurJob 当前进程号
/// w ##class("web.DHCEQ.RM.BUSShareResource").GetTotalInfo("1")
ClassMethod GetTotalInfo(CurJob)
{
	i CurJob="" q ""
	q $g(^DHCEQTemp("ShareResource",+$H,CurJob))
}

/// add by zx 2020-03-11
/// 描述：检查设备是否符合上架设置
/// 入参：ParaEquipID 设备ID
/// 返回值：0:不符合设置;其他:符合设置
/// w ##class("web.DHCEQ.RM.BUSShareResource").CheckIsInPutOnSet("44","1213")
ClassMethod CheckIsInPutOnSet(ParaEquipID As %String = "", ParaItemID As %String = "", CurModelDR As %String = "", CurStoreLocDR As %String = "")
{
	i (ParaEquipID="")&&(ParaItemID="") q "0"
	n OnsetFlag,CurItemDR,CurModelDR,CurStoreLocDR,POSDR,POSEquipDR,POSModelDR,POSStoreLocDR
	s (OnsetFlag,CurItemDR,CurModelDR,CurStoreLocDR,POSDR,POSEquipDR,POSModelDR,POSStoreLocDR)=""
	s OnsetFlag="0"
	i ParaEquipID'="" d
	.s CurItemDR=$p($g(^DHCEQEquip(ParaEquipID)),"^",7)
	.s CurModelDR=$p($g(^DHCEQEquip(ParaEquipID)),"^",3)
	.s CurStoreLocDR=$p($g(^DHCEQEquip(ParaEquipID)),"^",67)
	e  d
	.s CurItemDR=ParaItemID
	s POSDR=0
	f  s POSDR=$o(^DHCEQSPutOnSet(0,"Item",CurItemDR,POSDR)) q:(POSDR="")||(OnsetFlag'="0")  d
	.q:($p($g(^DHCEQSPutOnSet(POSDR)),"^",13))="3"
	.s POSEquipDR=$p($g(^DHCEQSPutOnSet(POSDR)),"^",2)
	.q:(POSEquipDR'="")&&(POSEquipDR'=ParaEquipID)
	.s POSModelDR=$p($g(^DHCEQSPutOnSet(POSDR)),"^",5)
	.q:(POSModelDR'="")&&(POSModelDR'=CurModelDR)
	.s POSStoreLocDR=$p($g(^DHCEQSPutOnSet(POSDR)),"^",7)
	.q:(POSStoreLocDR'="")&&(POSStoreLocDR'=CurStoreLocDR)
	.s OnsetFlag=POSDR
	//设备项修改后情况
	i (OnsetFlag=0)&&(ParaEquipID'="") d
	.s POSDR=$o(^DHCEQSPutOnSet(0,"Equip",ParaEquipID,""))
	.i POSDR'="" d
	..q:($p($g(^DHCEQSPutOnSet(POSDR)),"^",13))="3"
	..s OnsetFlag=POSDR
	
	q OnsetFlag
}

/// add by zx 2020-04-20
/// 描述：根据租赁资源判断登录用户是否可操作及操作动作
/// 入参：ParaEquipID 设备ID
/// 返回值：0:不符合设置;其他:符合设置
/// w ##class("web.DHCEQ.RM.BUSShareResource").ShareResourceOprate("4","71")
ClassMethod ShareResourceOprate(SRRowID As %String = "", CurUserID As %String = "")
{
	s (ActionDR,BussID,Roles)=""
	s RentID=0
	f  s RentID=$o(^DHCEQSRent(0,"ShareResource",SRRowID,RentID)) q:(RentID="")||(BussID'="")  d
	.s RetntStatus=$p($g(^DHCEQSRent(RentID)),"^",36)
	.q:(RetntStatus'="1")&&(RetntStatus'="2")
	.s MsgID=0
	.f  s MsgID=$o(^DHCEQMessages(0,"MessageType","1","64",RentID,MsgID)) q:(MsgID="")||(BussID'="")  d
	..q:($p($g(^DHCEQMessages(MsgID)),"^",21))="Y"
	..s MsgRecInfoID=0
	..f  s MsgRecInfoID=$o(^DHCEQMessagesRecInfo(0,"Message",MsgID,MsgRecInfoID)) q:(MsgRecInfoID="")||(BussID'="")  d
	...s ReceiveUserDR=$p($g(^DHCEQMessagesRecInfo(MsgRecInfoID)),"^",2)
	...q:ReceiveUserDR'=CurUserID
	...s ActionDR=$p($g(^DHCEQMessagesRecInfo(MsgRecInfoID)),"^",10)
	...s BussID=RentID
	...s Roles=$p($g(^DHCEQMessagesRecInfo(MsgRecInfoID)),"^",4)
	
	q BussID_"^"_ActionDR_"^"_Roles
}

}
