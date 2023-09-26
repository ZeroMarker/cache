/// 名称: web.DHCEQ.EM.BUSInventory
/// 描述: 设备盘点业务
/// 编写者：Mozy
/// 编写日期: 2020-06-17
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSInventory Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 盘点业务设备明细列表
/// MZY0049		2020-08-25 		盘点明细状态"盘盈"修正为"待查找"等
/// MZY0048		2020-08-21		调整显示标识参数
/// 显示标识DisplayFlag:
/// 			allflag:全部设备(账面)	consistentflag:一致设备	unconsistentflag:不一致设备	uncheckflag:未盘设备	unchecklocflag:科室不符设备		unfindflag:盘亏设备		findflag:待查找设备
/// 				全部(账面)=一致+不一致		不一致=未盘+科室不符+盘亏+待查找
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","InventoryList","","","","1,2,3,4")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","InventoryList",1,"","","","1,2,3,4","","","","",202,0,0,"","false","allflag")
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","InventoryList",219,"",51,"","1,2,3,4,5,14,16","","","","",257,0,1,"","true","uncheckflag","")
Query InventoryList(InventoryDR As %String = "", StoreLocDR As %String = "", IStoreLocDR As %String = "", vData As %String = "", EquipTypeIDs As %String = "", StatCatDR As %String = "", OriginDR As %String = "", onlyShowDiff As %String = "", FilterInfo As %String = "", ManageLocDR As %String = "", QXType As %String = "", StatusDR As %String = "", HospitalDR As %String = "", LocIncludeFlag As %String = "", DisplayFlag As %String = "", InventoryPlanDR As %String = "") As %Query(ROWSPEC = "ILRowID:%String,ILInventoryDR:%String,ILBillEquipDR:%String,ILActerEquipDR:%String,ILBillStoreLocDR:%String,ILBillUseLocDR:%String,ILActerStoreLocDR:%String,ILActerUseLocDR:%String,ILBillOriginalFee:%String,ILBillNetFee:%String,ILBillDepreTotalFee:%String,ILUserDR:%String,ILDate:%String,ILTime:%String,ILStatus:%String,ILRemark:%String,ILHold1:%String,ILHold2:%String,ILHold3:%String,ILHold4:%String,ILHold5:%String,ILCondition:%String,ILProcessFlag:%String,ILBussType:%String,ILBussID:%String,ILBillEquipDR_Name:%String,ILActerEquipDR_Name:%String,ILBillEquipDR_No:%String,ILActerEquipDR_No:%String,TModel:%String,TEquipCat:%String,TEquipType:%String,TStatCat:%String,TUnit:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TProvider:%String,TLimitYearsNum:%String,TDepreMethod:%String,TEquipRemark:%String,ILBillStoreLoc:%String,ILBillUseLoc:%String,ILActerStoreLoc:%String,ILActerUseLoc:%String,TManuFactory:%String,TOrigin:%String,TUser:%String,ILJob:%String,TPlace:%String,TResultType:%String,TFileNo:%String,TStartDate:%String,TNum:%String,TAdvanceDisFlag:%String,ILStatus_Display:%String,ILCondition_Display:%String,ILProcessFlag_Display:%String,ILILocationDR:%String,ILIKeeperDR:%String,LILossReasonDR:%String,LIUseStatus:%String,LIPurpose:%String,ILILeaveFactoryNo:%String,ILILocationDR_LDesc:%String,ILIKeeperDR_SSUSRName:%String,LILossReasonDR_LRDesc:%String,LIUseStatus_USDesc:%String,LIPurpose_PDesc:%String") [ SqlProc ]
{
}

ClassMethod InventoryListExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", StoreLocDR As %String = "", IStoreLocDR As %String = "", vData As %String = "", EquipTypeIDs As %String = "", StatCatDR As %String = "", OriginDR As %String = "", onlyShowDiff As %String = "", FilterInfo As %String = "", ManageLocDR As %String = "", QXType As %String = "", StatusDR As %String = "", HospitalDR As %String = "", LocIncludeFlag As %String = "", DisplayFlag As %String = "", InventoryPlanDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("web.DHCEQ.EM.BUSInventory.InventoryList",1)=InventoryDR_","_StoreLocDR_","_IStoreLocDR_","_vData_","_EquipTypeIDs_","_StatCatDR_","_OriginDR_","_onlyShowDiff_","_FilterInfo_","_ManageLocDR_","_QXType_","_StatusDR_","_HospitalDR_","_LocIncludeFlag_","_DisplayFlag_","_InventoryPlanDR
	s index=1
	s Tmpindex=1
	s rowid=0
	s TRow=0
	new tmpNode,IncludeFlag
	new TRowID,TInventoryDR,TBillEquipDR,TActerEquipDR,TBillStoreLocDR,TBillUseLocDR,TActerStoreLocDR,TActerUseLocDR,TBillOriginalFee,TBillNetFee,TBillDepreTotalFee,TUserDR,TDate,TTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TBillName,TActerName,TBillNo,TActerNo
	new TModel,TEquiCat,TEquipType,TStatCat,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TProvider,TLimitYearsNum,TDepreMethod,TEquipRemark
	new TBillStoreLoc,TBillUseLoc,TActerStoreLoc,TActerUseLoc,TManuFactory,TOrigin,TUser,TPlace
	Set curuser=##Class(web.DHCEQCommon).getMapIDBySource("user", %session.Get("LOGON.USERID"))
	Set locid=##Class(web.DHCEQCommon).getMapIDBySource("dept", %session.Get("LOGON.CTLOCID"))
	Set CurGroupID=%session.Get("LOGON.GROUPID")
	Set Job=$j
	Set gnum=1
	s tmpNode="InventoryList"
    //modified by ZY 20220928
    //k ^DHCEQTemp("DHCEQInventoryListInfo",curuser,+$H,Job)
    d ##class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal("DHCEQInventoryListInfo",Job,curuser)
	s LocIncludeFlag=##Class(web.DHCEQCommon).TransValueFromPage(LocIncludeFlag,"bool")
	// MZY0134	2952670		2022-09-20
	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
	Set UseLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
 	Set BatchFlag=##class(web.DHCEQCommon).GetDataByName(vData,"BatchFlag")		;批量处置标识
 	Set EQNo=##class(web.DHCEQCommon).GetDataByName(vData,"EQNo")
 	Set EQName=##class(web.DHCEQCommon).GetDataByName(vData,"EQName")
	s FacilityEquipType=##class(web.DHCEQCommon).GetSysInfo("990053")  //Modefied by zc0130 简易设备过滤 2023-2-17
	s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")	//增加参数判断盘点是否包含预报废设备，直接取EQ_Hold8字段的值来判断设备的预报废
	s tmpNode="InventoryList"
    //modified by ZY 20220928
    //d ##Class(web.DHCEQCommon).KillTempGlobal(tmpNode)
    d ##class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal(tmpNode,Job,curuser)
	Set FilterInfo=##Class(web.DHCEQCommon).UnEscape(FilterInfo)
	i EquipTypeIDs'="" s EquipTypeIDs=","_EquipTypeIDs_","
	if ((InventoryDR'="")&&(+$p($g(^DHCEQInventory(InventoryDR)),"^",10)>0))
	{
		;i InventoryPlanDR'="" s InventoryDR=""
		; +$p($g(^DHCEQInventory(InventoryDR)),"^",10)>0
		i (InventoryPlanDR="")  d
		.d BuildDataInventoryList
		e  d
		.s InventoryDR=0
		.f  s InventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",InventoryPlanDR,InventoryDR)) q:(InventoryDR="")  d
		..d BuildDataInventoryList
	}
	else
	{
		s rowid=0
		f  s rowid=$o(^DHCEQEquip(rowid))  quit:((rowid=""))  d
		.Set EQInvalidFlag=$Piece($Get(^DHCEQEquip(rowid)),"^",59)
		.Quit:EQInvalidFlag'="N"
		.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
		.q:((StockStatus=0)||(StockStatus=3))		///尚未入库或已经出库的设备
		.q:$p($g(^DHCEQEquip(rowid)),"^",38)=3		///报废的设备
		.
		.//q:((EquipTypeDR'="")&&(EquipTypeDR'=$p($g(^DHCEQEquip(rowid)),"^",63)))
		.s TEquipTypeDR=","_$p($g(^DHCEQEquip(rowid)),"^",63)_","
		.q:((","_FacilityEquipType_",")[TEquipTypeDR)   //Modefied by zc0130 简易设备过滤 2023-2-17
		.q:(EquipTypeIDs'="")&&(EquipTypeIDs'[TEquipTypeDR)
		.q:((StatCatDR'="")&&(StatCatDR'=$p($g(^DHCEQEquip(rowid)),"^",75)))
		.///modified by ZY0236 2020-06-17  增加是否包含子科室和院区的条件
		.;q:((StoreLocDR'="")&&(StoreLocDR'=$p($g(^DHCEQEquip(rowid)),"^",67)))
		.s TStoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
		.q:((LocIncludeFlag'="Y")&&(IStoreLocDR'="")&&(IStoreLocDR'=TStoreLocDR))
		.q:((LocIncludeFlag="Y")&&(IStoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(IStoreLocDR,TStoreLocDR,"1")'="1"))
		.
		.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		.q:((HospitalDR'="")&&(HospitalDR'=THospitalDR))
		.Quit:(##Class(web.DHCEQCommon).CheckManageLimit(curuser,CurGroupID,"",$p($g(^DHCEQEquip(rowid)),"^",63),$p($g(^DHCEQEquip(rowid)),"^",75),$p($g(^DHCEQEquip(rowid)),"^",4),$p($g(^DHCEQEquip(rowid)),"^",67),rowid,$p($g(^DHCEQEquip(rowid)),"^",7)))
		.s Flag=0
		.i ($p($g(^DHCEQEquip(rowid)),"^",67)'="")  d
		..s Flag=##class(web.DHCEQCommon).LocIsInEQ(QXType,$p($g(^DHCEQEquip(rowid)),"^",67),locid)
		.q:Flag'=0
		.q:((UseLocDR'="")&&(UseLocDR'=$p($g(^DHCEQEquip(rowid)),"^",19)))
		.q:((OriginDR'="")&&(OriginDR'=$p($g(^DHCEQEquip(rowid)),"^",20)))
		.d ResetVarInventoryList
		.
		.s TInventoryDR=InventoryDR
		.s TBillEquipDR=rowid
		.s TBillStoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
		.s TBillUseLocDR=$p($g(^DHCEQEquip(rowid)),"^",19)
		.s TBillOriginalFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQEquip(rowid)),"^",27),"")
		.s TBillNetFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQEquip(rowid)),"^",28),"")
		.s TBillDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQEquip(rowid)),"^",35),"")
		.;Add by QW20210430 BUG:QW0103 增加存放地点 begin
		.s TLocationDR=$p($g(^DHCEQEquip(rowid)),"^",72)
		.;Add by QW20210430 BUG:QW0103 增加存放地点 end
		.s EquipDR=rowid
		.q:EquipDR=""
		.s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
		.s EqCode=$ZCONVERT($p($g(^DHCEQEquip(EquipDR)),"^",6),"U")
		.s OriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
		.s TransassetDate=$p($g(^DHCEQEquip(EquipDR)),"^",45)
		.s InStockListDR=$p($g(^DHCEQEquip(EquipDR)),"^",70)
		.i (TransassetDate="")&&(InStockListDR'="")  d
		..s ISRowID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
		..i ISRowID'="" s TransassetDate=$p($g(^DHCEQInStock(ISRowID)),13)
		.s (FName,FOriginalFeeS,FOriginalFeeE,FStartDate,FEndDate,FLocationDR)=""  ;Modify by QW20210430 BUG:QW0103 增加存放地点
		.i FilterInfo'="" d
		..s FName=$ZCONVERT($p($p(FilterInfo,"|",1),":",2),"U")
		..s FOriginalFeeS=$p($p(FilterInfo,"|",2),":",2)
		..s FOriginalFeeE=$p($p(FilterInfo,"|",3),":",2)
		..s FStartDate=##class(web.DHCEQCommon).TransValueFromPage($p($p(FilterInfo,"|",4),":",2),"date")
		..s FEndDate=##class(web.DHCEQCommon).TransValueFromPage($p($p(FilterInfo,"|",5),":",2),"date")
		..s FLocationDR=$p($p(FilterInfo,"|",6),":",2) ;Add by QW20210430 BUG:QW0103 增加存放地点
		.e  d
		..i InventoryDR'=""  d
		...s ConditionName=0
		...f  s ConditionName=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditionName)) q:ConditionName=""  d
		....s ID=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditionName,0))
		....s FValue=$p($g(^DHCEQInventoryFilterInfo(ID)),"^",3)
		....i ConditionName="EquipName" s FName=$ZCONVERT(FValue,"U")
		....i ConditionName="OriginalFeeStart" s FOriginalFeeS=FValue
		....i ConditionName="OriginalFeeEnd" s FOriginalFeeE=FValue
		....i (ConditionName="StartDate")  s FStartDate=##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")
		....i (ConditionName="EndDate")  s FEndDate= ##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")
		....i (ConditionName="LocationDR")  s FLocationDR=FValue ;Add by QW20210430 BUG:QW0103 增加存放地点
		.q:(FName'="")&&(TEquipName'[FName)
		.q:(FOriginalFeeS'="")&&(OriginalFee<FOriginalFeeS)
		.q:(FOriginalFeeE'="")&&(OriginalFee>FOriginalFeeE)
		.q:(FStartDate'="")&&(TransassetDate<FStartDate)
		.q:(FEndDate'="")&&(TransassetDate>FEndDate)
		.q:(FLocationDR'="")&&(TLocationDR'=FLocationDR)  ;Add by QW20210430 BUG:QW0103 增加存放地点
		.d FillEquipInfo
	}
	Quit $$$OK
BuildDataInventoryList
	;FilterInfo
	s rowid=0
	f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid))  quit:(rowid="")  d
	.d ResetVarInventoryList
	.s TRowID=rowid
	.s TInventoryDR=InventoryDR
	.s TBillEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
	.s TActerEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",3)
	.s TBillStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",4)
	.q:((LocIncludeFlag'="Y")&&(IStoreLocDR'="")&&(IStoreLocDR'=TBillStoreLocDR))
	.q:((LocIncludeFlag="Y")&&(IStoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(IStoreLocDR,TBillStoreLocDR,"1")'="1"))
	.///add by ZY0244 20200927 管理科室以科室的角色进入科室盘点结果处理的菜单看数据需要过滤
	.q:((LocIncludeFlag'="Y")&&(StoreLocDR'="")&&(StoreLocDR'=TBillStoreLocDR))
	.q:((LocIncludeFlag="Y")&&(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,TBillStoreLocDR,"1")'="1"))
	.s TBillUseLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",5)
	.s TActerStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",6)
	.s TActerUseLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",7)
	.s TBillOriginalFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryList(rowid)),"^",8),"")
	.s TBillNetFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryList(rowid)),"^",9),"")
	.s TBillDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryList(rowid)),"^",10),"")
	.s TUserDR=$p($g(^DHCEQInventoryList(rowid)),"^",11)
	.s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
	.s TDate=$p($g(^DHCEQInventoryList(rowid)),"^",12)
	.s TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	.s TTime=$p($g(^DHCEQInventoryList(rowid)),"^",13)
	.s TTime=##Class(web.DHCEQCommon).TransValueToPage(TTime,"time")
	.s TStatus=$p($g(^DHCEQInventoryList(rowid)),"^",14)
	.s ILStatusDesc=$CASE(TStatus,"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","":"")
	.s TRemark=$p($g(^DHCEQInventoryList(rowid)),"^",15)
	.s THold1=$p($g(^DHCEQInventoryList(rowid)),"^",16)
	.s THold2=$p($g(^DHCEQInventoryList(rowid)),"^",17)
	.s THold3=$p($g(^DHCEQInventoryList(rowid)),"^",18)
	.s THold4=$p($g(^DHCEQInventoryList(rowid)),"^",19)
	.s THold5=$p($g(^DHCEQInventoryList(rowid)),"^",20)
	.s ILCondition=$p($g(^DHCEQInventoryList(rowid)),"^",21)
	.s ILConditionDesc=$CASE(ILCondition,"0":"完好","1":"待报废","2":"有缺损","":"")
	.s ILProcessFlag=$p($g(^DHCEQInventoryList(rowid)),"^",22)
	.s ILProcessFlagDesc=$CASE(ILProcessFlag,"0":"未处理","1":"处理中","2":"处理完成","":"")
	.s ILBussType=$p($g(^DHCEQInventoryList(rowid)),"^",23)
	.s ILBussID=$p($g(^DHCEQInventoryList(rowid)),"^",24)
	.s LIUseStatus=$p($g(^DHCEQInventoryList(rowid)),"^",25)
	.s LIUseStatusUSDesc=$CASE(LIUseStatus,"1":"在用","2":"拆封未使用","3":"未拆封","4":"积压闲置","5":"已盘亏","":"")
	.s LIPurpose=$p($g(^DHCEQInventoryList(rowid)),"^",26)
	.s LIPurposePDesc=$CASE(LIPurpose,"1":"医院日常使用","2":"储备物资","":"")
	.s LILossReasonDR=$p($g(^DHCEQInventoryList(rowid)),"^",27)
	.s LILossReasonDRLRDesc=$p($g(^DHCEQCCode("DHCEQCLossReason",+LILossReasonDR)),"^",2)
	.s InventoryListInfo=##Class(web.DHCEQ.EM.BUSInventory).GetOneListInfo(rowid)
	.s ILIKeeperDR=$p(InventoryListInfo,"^",6)
	.s ILILocationDR=$p(InventoryListInfo,"^",7)
	.s ILILeaveFactoryNo=$p(InventoryListInfo,"^",8)
	.s ILIKeeperDRSSUSRName=$p(InventoryListInfo,"^",18)
	.s ILILocationDRLDesc=$p(InventoryListInfo,"^",19)
	.
	.s diffFlag=0
	.i onlyShowDiff="on"  d
	..i TBillEquipDR="" s diffFlag=1
	..i TActerEquipDR="" s diffFlag=1
	..i TBillStoreLocDR'=TActerStoreLocDR s diffFlag=1
	..///i TBillUseLocDR'=TActerUseLocDR s diffFlag=1
	.q:((onlyShowDiff="on")&&(diffFlag'=1))
	.
	.s EquipDR=TBillEquipDR
	.if TBillEquipDR="" s EquipDR=TActerEquipDR
	.q:((UseLocDR'="")&&(UseLocDR'=$p($g(^DHCEQEquip(EquipDR)),"^",19)))
	.q:((OriginDR'="")&&(OriginDR'=$p($g(^DHCEQEquip(EquipDR)),"^",20)))
	.q:(EquipTypeIDs'="")&&(EquipTypeIDs'[(","_$p($g(^DHCEQEquip(EquipDR)),"^",63)_","))
	.q:##class(web.DHCEQCommon).LocIsInEQ(QXType,$p($g(^DHCEQEquip(EquipDR)),"^",67),locid)'=0
	.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID($p($g(^DHCEQEquip(EquipDR)),"^",67))
	.q:((HospitalDR'="")&&(HospitalDR'=THospitalDR))
	.q:(StatCatDR'="")&&(StatCatDR'=$p($g(^DHCEQEquip(EquipDR)),"^",75))
	.
	.s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	.s FindILIRowID=""
	.s ILIRowID=0
	.f  s ILIRowID=$o(^DHCEQInventoryListInfo(0,"InventoryList",rowid,ILIRowID))  q:ILIRowID=""||ILIRowID'=""  d
	..q:$p($g(^DHCEQInventoryListInfo(ILIRowID)),"^",5)="Y"
	..s FindILIRowID=ILIRowID
	.
	.d FillEquipInfo
	quit
FillEquipInfo
	q:EquipDR=""
	//增加参数判断盘点是否包含预报废设备，直接取EQ_Hold8字段的值来判断设备的预报废
	Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(EquipDR)),"^",93)="2")
	s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	q:(EQName'="")&&(EQName'=TEquipName)		// MZY0134	2952670		2022-09-20
	s TEquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	q:(EQNo'="")&&(EQNo'=TEquipNo)			// MZY0134	2952670		2022-09-20
	s TModel=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	i TModel'="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	s TEquiCat=$p($g(^DHCEQEquip(EquipDR)),"^",4)
	i TEquiCat'="" s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCat)),"^",2)
	s TEquipType=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	i TEquipType'="" s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipType)),"^",2)
	s TStatCat=$p($g(^DHCEQEquip(EquipDR)),"^",75)
	i TStatCat'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCat)),"^",2)
	s TUnit=$p($g(^DHCEQEquip(EquipDR)),"^",5) 
	s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	s TLeaveFactoryNo = $p($g(^DHCEQEquip(EquipDR)),"^",10)
	s TLeaveFactoryDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipDR)),"^",11),"date")
	s TProvider = $p($g(^DHCEQEquip(EquipDR)),"^",25)
	i TProvider '="" s TProvider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	s TLimitYearsNum = $p($g(^DHCEQEquip(EquipDR)),"^",31)
	s TDepreMethod = $p($g(^DHCEQEquip(EquipDR)),"^",33)
	i TDepreMethod '="" s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethod)),"^",2)
	s TEquipRemark = $p($g(^DHCEQEquip(EquipDR)),"^",34)
	
	i TBillEquipDR'="" s TBillName=$p($g(^DHCEQEquip(TBillEquipDR)),"^",1)
	i TActerEquipDR'="" s TActerName=$p($g(^DHCEQEquip(TActerEquipDR)),"^",1)
	i TBillEquipDR'="" s TBillNo=$p($g(^DHCEQEquip(TBillEquipDR)),"^",71)
	i TActerEquipDR'="" s TActerNo=$p($g(^DHCEQEquip(TActerEquipDR)),"^",71)
	
	i TBillEquipDR=""
	{
		s TBillName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
		s TBillNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	}
	s TBillStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillStoreLocDR)
	s TBillUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillUseLocDR)
	s TActerStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerStoreLocDR)
	;;;i TActerStoreLoc="" s TActerStoreLoc=##Class(web.DHCEQCommon).getMapIDBySource("deptname",%session.Get("LOGON.CTLOCID"))	;设置"实际库房"为当前登录科室
	s TActerUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerUseLocDR)
	s TManuFactory = $p($g(^DHCEQEquip(EquipDR)),"^",26)
	i TManuFactory '="" s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactory)
	s TOrigin = $p($g(^DHCEQEquip(EquipDR)),"^",20)
	i TOrigin '="" s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOrigin)),"^",2)
	Set TFileNo=$Piece($Get(^DHCEQEquip(EquipDR)),"^",85)
	s TPlace=$p($g(^DHCEQEquip(EquipDR)),"^",72)
	s TPlace=##Class(web.DHCEQCommon).GetTrakNameByID("location",TPlace) ;Modify by QW20210430 BUG:QW0103 增加存放地点
	s TStartDate=$p($g(^DHCEQEquip(EquipDR)),"^",44)
	s TNum=1
    ; 修改判断顺序,TActerStoreLoc为空时直接设为未盘点,以防出现TBillStoreLoc为空时状态变为一致
	if (ILStatusDesc="")
	{	s TResultType="未盘点"	}
	else
	{	s TResultType=ILStatusDesc	}
	s TAdvanceDisFlag=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus($p($g(^DHCEQEquip(EquipDR)),"^",93))	// 异常状态信息
	
	// MZY0048	2020-08-21
	;s ILStatusDesc=$CASE(TStatus,"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","":"")
	/// 全部(账面)=一致+不一致		不一致=未盘+科室不符+盘亏+待查找
	;Quit:(DisplayFlag="allflag")				;allflag:全部设备(账面)
	Quit:(DisplayFlag="consistentflag")&&(ILStatusDesc'="账物一致")		;consistentflag:一致设备
	Quit:(DisplayFlag="unconsistentflag")&&(ILStatusDesc="账物一致")	;unconsistentflag:不一致设备
	Quit:(DisplayFlag="uncheckflag")&&(ILStatusDesc'="")				;uncheckflag:未盘设备
	Quit:(DisplayFlag="unchecklocflag")&&(ILStatusDesc'="科室不符")		;unchecklocflag:科室不符设备
	Quit:(DisplayFlag="unfindflag")&&(ILStatusDesc'="盘亏")				;unfindflag:盘亏设备
	Quit:(DisplayFlag="findflag")&&(ILStatusDesc'="待查找")				// MZY0049	2020-08-25
	Quit:(DisplayFlag="disuseflag")&&(ILStatusDesc'="有报废单")
	// MZY0115	2469647		2022-03-10
	s TSelect="N"
	i InventoryDR'="" d
	.i ","_$g(^DHCEQInventory(InventoryDR,"UncheckEquipStr"))_","'[(","_EquipDR_",") s TSelect="Y"
	d OutputRowInventoryList
	quit
	
OutputRowInventoryList
	Set TRow=TRow+1
    //modified by ZY 20220928
    //Set ^DHCEQTemp(tmpNode,+$H,$j,index)=TRowID_"^"_TInventoryDR_"^"_TBillEquipDR_"^"_TActerEquipDR_"^"_TBillStoreLocDR_"^"_TBillUseLocDR_"^"_TActerStoreLocDR_"^"_TActerUseLocDR_"^"_TBillOriginalFee_"^"_TBillNetFee_"^"_TBillDepreTotalFee_"^"_TUserDR_"^"_TDate_"^"_TTime_"^"_TStatus_"^"_TRemark_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TBillName_"^"_TActerName_"^"_TBillNo_"^"_TActerNo_"^"_TModel_"^"_TEquiCat_"^"_TEquipType_"^"_TStatCat_"^"_TUnit_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TProvider_"^"_TLimitYearsNum_"^"_TDepreMethod_"^"_TEquipRemark_"^"_TBillStoreLoc_"^"_TBillUseLoc_"^"_TActerStoreLoc_"^"_TActerUseLoc_"^"_TManuFactory_"^"_TOrigin_"^"_TUser_"^"_TPlace_"^"_TResultType_"^"_TRow_"^"_TFileNo_"^"_TStartDate_"^"_TNum_"^"_TAdvanceDisFlag
    s tmpValue=TRowID_"^"_TInventoryDR_"^"_TBillEquipDR_"^"_TActerEquipDR_"^"_TBillStoreLocDR_"^"_TBillUseLocDR_"^"_TActerStoreLocDR_"^"_TActerUseLocDR_"^"_TBillOriginalFee_"^"_TBillNetFee_"^"_TBillDepreTotalFee_"^"_TUserDR_"^"_TDate_"^"_TTime_"^"_TStatus_"^"_TRemark_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TBillName_"^"_TActerName_"^"_TBillNo_"^"_TActerNo_"^"_TModel_"^"_TEquiCat_"^"_TEquipType_"^"_TStatCat_"^"_TUnit_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TProvider_"^"_TLimitYearsNum_"^"_TDepreMethod_"^"_TEquipRemark_"^"_TBillStoreLoc_"^"_TBillUseLoc_"^"_TActerStoreLoc_"^"_TActerUseLoc_"^"_TManuFactory_"^"_TOrigin_"^"_TUser_"^"_TPlace_"^"_TResultType_"^"_TRow_"^"_TFileNo_"^"_TStartDate_"^"_TNum_"^"_TAdvanceDisFlag
    d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal(tmpNode,+$H,Job,curuser,gnum,tmpValue)
	Set Data=$lb(TRowID,TInventoryDR,TBillEquipDR,TActerEquipDR,TBillStoreLocDR,TBillUseLocDR,TActerStoreLocDR,TActerUseLocDR,TBillOriginalFee,TBillNetFee,TBillDepreTotalFee,TUserDR,TDate,TTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,ILCondition,ILProcessFlag,ILBussType,ILBussID,TBillName,TActerName,TBillNo,TActerNo,TModel,TEquiCat,TEquipType,TStatCat,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TProvider,TLimitYearsNum,TDepreMethod,TEquipRemark,TBillStoreLoc,TBillUseLoc,TActerStoreLoc,TActerUseLoc,TManuFactory,TOrigin,TUser,$j,TPlace,TResultType,TFileNo,TStartDate,TNum,TAdvanceDisFlag,ILStatusDesc,ILConditionDesc,ILProcessFlagDesc,ILILocationDR,ILIKeeperDR,LILossReasonDR,LIUseStatus,LIPurpose,ILILeaveFactoryNo,ILILocationDRLDesc,ILIKeeperDRSSUSRName,LILossReasonDRLRDesc,LIUseStatusUSDesc,LIPurposePDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
    //modified by ZY 20220928
    //Set ^DHCEQTemp("DHCEQInventoryListInfo",curuser,+$H,Job,gnum)=TRowID_"^"_TInventoryDR_"^"_TBillEquipDR
    s tmpValue=TRowID_"^"_TInventoryDR_"^"_TBillEquipDR
    d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal("DHCEQInventoryListInfo",+$H,Job,curuser,gnum,tmpValue)
	Set gnum=gnum+1
	Set Tmpindex=Tmpindex+1
	Quit
	
ResetVarInventoryList
	set (TRowID,TInventoryDR,TBillEquipDR,TActerEquipDR,TBillStoreLocDR,TBillUseLocDR,TActerStoreLocDR,TActerUseLocDR,TBillOriginalFee,TBillNetFee,TBillDepreTotalFee,TUserDR,TDate,TTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TBillName,TActerName,TBillNo,TActerNo,TModel,TEquiCat,TEquipType,TStatCat,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TProvider,TLimitYearsNum,TDepreMethod,TEquipRemark,TBillStoreLoc,TBillUseLoc,TActerStoreLoc,TActerUseLoc,TManuFactory,TOrigin,TUser,TPlace,TResultType,TFileNo,TStartDate,TNum,TAdvanceDisFlag,ILCondition,ILProcessFlag,ILBussType,ILBussID,ILStatusDesc,ILConditionDesc,ILProcessFlagDesc,TLocationDR,ILILocationDR,ILIKeeperDR,LILossReasonDR,LIUseStatus,LIPurpose,ILILeaveFactoryNo,ILILocationDRLDesc,ILIKeeperDRSSUSRName,LILossReasonDRLRDesc,LIUseStatusUSDesc,LIPurposePDesc)="" ;Modify by QW20210430 BUG:QW0103 增加存放地点
	quit
}

ClassMethod InventoryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InventoryListExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod InventoryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InventoryListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Creator：      Mozy
/// CreatDate：    2020-6-17
/// Description:   盘点设备状态
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetStatusList")
Query GetStatusList() As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetStatusListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=1
	s Code="01"
	s Desc="账物一致"
	d OutputRowGetStatusList
	s rowid=2
	s Code="02"
	s Desc="科室不符"
	d OutputRowGetStatusList
	s rowid=3
	s Code="03"
	s Desc="盘亏"
	d OutputRowGetStatusList
	// MZY0049	2020-08-25
	s rowid=4
	s Code="04"
	s Desc="待查找"
	d OutputRowGetStatusList
	s rowid=5
	s Code="05"
	s Desc="有报废单"
	d OutputRowGetStatusList
	
	
	Quit $$$OK
OutputRowGetStatusList
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetStatusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatusListExecute ]
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

ClassMethod GetStatusListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatusListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      Mozy
/// CreatDate：    2020-6-17
/// Description:   盘点设备完好状态
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetConditionList")
Query GetConditionList() As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetConditionListExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=0
	s Code="01"
	s Desc="完好"
	d OutputRowGetConditionList
	s rowid=1
	s Code="02"
	s Desc="待报废"
	d OutputRowGetConditionList
	s rowid=2
	s Code="03"
	s Desc="有缺损"
	d OutputRowGetConditionList
	
	Quit $$$OK
OutputRowGetConditionList
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetConditionListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetConditionListExecute ]
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

ClassMethod GetConditionListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetConditionListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      Mozy
/// CreatDate：    2022-9-5
/// Description:   盘点设备使用状态
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetUseStatus")
Query GetUseStatus() As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetUseStatusExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=1
	s Code="01"
	s Desc="在用"
	d OutputRowGetUseStatus
	s rowid=2
	s Code="02"
	s Desc="拆封未使用"
	d OutputRowGetUseStatus
	s rowid=3
	s Code="03"
	s Desc="未拆封"
	d OutputRowGetUseStatus
	s rowid=4
	s Code="04"
	s Desc="积压闲置"
	d OutputRowGetUseStatus
	s rowid=5
	s Code="05"
	s Desc="已盘亏"
	d OutputRowGetUseStatus
	
	Quit $$$OK
OutputRowGetUseStatus
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetUseStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUseStatusExecute ]
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

ClassMethod GetUseStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUseStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      Mozy
/// CreatDate：    2022-9-5
/// Description:   盘点设备用途
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetPurpose")
Query GetPurpose() As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetPurposeExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=1
	s Code="01"
	s Desc="医院日常使用"
	d OutputRowGetPurpose
	s rowid=2
	s Code="02"
	s Desc="储备物资"
	d OutputRowGetPurpose
	
	Quit $$$OK
OutputRowGetPurpose
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetPurposeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPurposeExecute ]
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

ClassMethod GetPurposeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPurposeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 保存盘点主单 Modify by QW20210430 BUG:QW0103
/// w ##Class(web.DHCEQ.EM.BUSInventory).SaveInventory()
ClassMethod SaveInventory(data, FilterInfo As %Library.String = "")
{
	s $ZT="ERRORSaveInventory"
	k PLIST
	new RowID
	
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s PLIST = ##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQInventory",JsonData,.PLIST)
	s RowID = JsonData.%Get("IRowID")
	
	i PLIST(3)'="" d
	.i $p($g(^DHCEQCCode("DHCEQCDepartment", PLIST(3))),"^",7)=1 s PLIST(16) = $p($g(^DHCEQCCode("DHCEQCDepartment", PLIST(3))),"^",8)	;部门关联的院区
	//e  d		MZY0048	2020-08-21	注释默认院区取值
	//.i PLIST(16)="" s PLIST(16) = %session.Get("LOGON.HOSPID")
	s PLIST(11) = 0			;Status

	
 	TSTART
	if RowID'=""
	{
		&SQL(Update SQLUSER.DHC_EQInventory Values :PLIST() where I_RowID = :RowID)
	}
	else
	{
		s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInventory",+$H)
		s PLIST(8)=+$H
		s PLIST(9)=$P($H,",",2)
		s PLIST(10)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		&SQL(insert into SQLUSER.DHC_EQInventory Values :PLIST())
		s RowID=$g(%ROWID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;Modify by QW20210430 BUG:QW0103 begin
	if FilterInfo'=""
	{
		s IFICount=0
		s Count=$l(FilterInfo,"|")
		s Flag=0
		for i=1:1:Count
		{
			s IFI(2)=RowID
			s IFI(3)=$p($p(FilterInfo,"|",i),":",1)
			s IFI(4)=$p($p(FilterInfo,"|",i),":",2)
			&SQL(Select Count(*) Into :IFICount From sqluser.DHC_EQInventoryFilterInfo Where IFI_InventoryDR=:RowID and IFI_InventoryCondition=:IFI(3))
			i IFICount<=0
			{
				&SQL(Insert into sqluser.DHC_EQInventoryFilterInfo values :IFI())
			}
			else
			{
				&SQL(Update sqluser.DHC_EQInventoryFilterInfo values :IFI() Where IFI_InventoryDR=:RowID and IFI_InventoryCondition=:IFI(3))
			}
			i SQLCODE
			{
				s Flag=1
				s i=Count+1
			}
		}
		i Flag=1
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1")
		}
	}
	;Modify by QW20210430 BUG:QW0103 end
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORSaveInventory
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).GetOneInventory(207)
ClassMethod GetOneInventory(RowID As %Library.String = "", StoreLocDR As %Library.String = "")
{
	s $ZT="ERRORGetOneInventory"
	
	s ObjInventory=##Class(User.DHCEQInventory).%OpenId(RowID)
	s InventoryInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjInventory)
	d InventoryInfo.%Set("IStoreLocDR_CTLOCDesc", ##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjInventory.IStoreLocDR))
	i ObjInventory.IEquipTypeIDs'=""
	{
		s IEquipType=""
		s num=$l(ObjInventory.IEquipTypeIDs,",")
		for i=1:1:num
		{
			s info=$p(ObjInventory.IEquipTypeIDs,",",i)
			i IEquipType'="" s IEquipType=IEquipType_","
			s IEquipType=IEquipType_##class(web.DHCEQCommon).GetTrakNameByID("equiptype", info)
		}
		d InventoryInfo.%Set("IEquipType", IEquipType)
	}
	
	i ObjInventory.IStatus>0
	{
		s LocIncludeFlag=ObjInventory.ILocIncludeFlag
		Set AllCheckNum=""
		Set UnCheckNum=""
		Set rowid=0
		For  Set rowid=$o(^DHCEQInventoryList(0,"Inventory",RowID,rowid)) Quit:rowid=""  d
		.s TBillEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
		.//20200628
		.s TBillStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",4)
		.///add by ZY0244 20200927 需要看是否包含子科室
		.;q:(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,TBillStoreLocDR,"1")'="1")
		.q:((LocIncludeFlag'="Y")&&(StoreLocDR'="")&&(StoreLocDR'=TBillStoreLocDR))
		.q:((LocIncludeFlag="Y")&&(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,TBillStoreLocDR,"1")'="1"))
		.
		.s EquipDR=TBillEquipDR
		.if TBillEquipDR="" s EquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",3)
		.s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")
		.Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(EquipDR)),"^",93)="2")		;判断是否包含预报废设备
		.if $p($g(^DHCEQInventoryList(rowid)),"^",14)="" Set UnCheckNum=1+UnCheckNum
		.Set AllCheckNum=1+AllCheckNum
		d InventoryInfo.%Set("AllCheckNum", AllCheckNum)
		d InventoryInfo.%Set("UnCheckNum", UnCheckNum)
		
		
		s (UnSubmitNum,UnAuditNum)=0
		s IARowIDs=""
		s vStoreLocDR=0
		f  s vStoreLocDR=$o(^DHCEQInventoryAudit(0,"Inventory",RowID,vStoreLocDR)) q:(vStoreLocDR="")  d
		.s IARowID=$o(^DHCEQInventoryAudit(0,"Inventory",RowID,vStoreLocDR,0))
		.q:IARowID=""
		.s IAStatus=$p($g(^DHCEQInventoryAudit(IARowID)),"^",8)
		.i (StoreLocDR'="") d
		..i (##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,vStoreLocDR,"1")="1") d
		...i IARowIDs=""  d
		....s IARowIDs=IARowID
		...e  d
		....s IARowIDs=IARowIDs_"^"_IARowID
		...d InventoryInfo.%Set("IARowID", IARowIDs)
		...d InventoryInfo.%Set("IAStatus", IAStatus)
		.e  d
		..d InventoryInfo.%Set("IAStatus", 1)
		..i IAStatus=0  d
		...s UnSubmitNum=UnSubmitNum+1
		..e  i IAStatus=0 d
		...s UnAuditNum=UnAuditNum+1
		d InventoryInfo.%Set("UnSubmitNum", UnSubmitNum)
		d InventoryInfo.%Set("UnAuditNum", UnAuditNum)
		
	}
	d InventoryInfo.%Set("IManageLocDR_CTLOCDesc", ##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjInventory.IManageLocDR))
	d InventoryInfo.%Set("IHospitalDR_HDesc", $p($g(^CT("HOSP", +ObjInventory.IHospitalDR)),"^",2))
	s PlanName=""
	i ObjInventory.IHold6'="" s PlanName=$p($g(^DHCEQInventoryPlan(ObjInventory.IHold6)),"^",2)
	d InventoryInfo.%Set("IPlan_Name", PlanName)	// MZY0128	2673539,2673540		2022-06-23

	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, InventoryInfo)
ERRORGetOneInventory
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:删除
/// w ##Class(web.DHCEQ.EM.BUSInventory).DeleteData()
/// Modify by zx 2020-07-15 移动端增加user参数
ClassMethod DeleteData(RowID As %String = "", IsDel As %String = "", UserID As %String = "")
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	//Modify by zx 2020-07-15 移动端增加user参数
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set $ZT="ERRORDelete"
	TSTART
	if IsDel=1
	{
		&SQL(Delete from sqluser.DHC_EQInventoryFilterInfo Where IFI_InventoryDR=:RowID)
		i (SQLCODE'=0)&&(SQLCODE'=100)
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		&SQL(Delete from sqluser.DHC_EQInventoryList Where IL_InventoryDR=:RowID)
		i (SQLCODE'=0)&&(SQLCODE'=100)
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}		
		&SQL(Delete from sqluser.DHC_EQInventory Where I_RowID=:RowID and I_Status=0)
		i (SQLCODE'=0)&&(SQLCODE'=100)
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	elseif IsDel=2
	{
		///add by ZY0244 20200927 看是否是科室自盘,非科室自盘的时候随时可以结束
		s SelfFlag= $p($g(^DHCEQInventory(RowID)),"^",20)
		// MZY0042	1410910		2020-8-4
		s Flag=0		;未盘点标识
		s rowid=0
		f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",RowID,rowid)) q:(rowid="")||(Flag=1)  d
		.i ((SelfFlag="Y")&&($p($g(^DHCEQInventoryList(rowid)),"^",6)="")) s Flag=1		;IL_ActerStoreLocDR
		.i $p($g(^DHCEQInventoryList(rowid)),"^",14)="" s Flag=1	;IL_Status		MZY0055	1472392		2020-09-22
		i (##class(web.DHCEQCommon).GetSysInfo("992005")=1)&&(Flag=1) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
		&SQL(Update sqluser.DHC_EQInventoryAudit set IA_Status='2' Where IA_InventoryDR=:RowID)
		i (SQLCODE'=0)&&(SQLCODE'=100)
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}		
		;s PLIST(11)=2
		;s PLIST(13)=UserID  //Modify by zx 2020-07-15 移动端增加user参数
		;s PLIST(14)=+$H
		s Date=+$H
		&SQL(Update sqluser.DHC_EQInventory set I_Status='2',I_Completer=:UserID,I_CompleteDate=:Date Where I_RowID=:RowID)
		i (SQLCODE'=0)&&(SQLCODE'=100)
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		/// 台账同步更新设备信息调整
		//s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).UpdateEquip(RowID)
	}
	
 	TCOMMIT
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORDelete
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 修改DHC_EQInventoryAudit 中的状态 0:新增,1:盘点科室提交,2:管理科室确认
/// w ##Class(web.DHCEQ.EM.BUSInventory).LocInventory()
ClassMethod LocInventory(IARowIDs As %String = "", Status As %String = "")
{
	s $ZT="ERRORLocInventory"
	new SQLCODE
	s SQLCODE=0
	//Modefied by zc0125 2022-12-20 审核记录人员信息 begin
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=+$p($H,",",2)
	i Status'=2 d
	.s User=""
	.s Date=""
	.s Time=""
	//Modefied by zc0125 2022-12-20 审核记录人员信息 end
 	TSTART
 	
 	if IARowIDs'=""
 	{
	 	s Len=$L(IARowIDs,"^")
	 	f i=1:1:Len
	 	{
		 	q:SQLCODE'=0
		 	s RowID=$p(IARowIDs,"^",i)
		 	q:RowID=""
		 	&SQL(Update sqluser.DHC_EQInventoryAudit Set IA_Status=:Status,IA_AuditUserDR=:User,IA_AuditTime=:Time where IA_RowID=:RowID)    //Modefied by zc0125 2022-12-20 审核记录人员信息 
		}
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0)
	
ERRORLocInventory
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).FreezeInventory(7)
ClassMethod FreezeInventory(RowID As %String, FilterInfo As %String = "", QXType As %String = "")
{
	new user,curDate,curTime,IncludeFlag
	new rowid
	new StockStatus
	
	if (RowID="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, RowID)
	
	s user=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s locid=##Class(web.DHCEQCommon).getMapIDBySource("dept", %session.Get("LOGON.CTLOCID"))
	s CurGroupID=%session.Get("LOGON.GROUPID")
	s CurHospID=%session.Get("LOGON.HOSPID")
	s curDate=+$H
	s curTime=+$p($H,",",2)
	
	TStart
	//Modify by zx 2021-12-20 Bug ZX0142  管理部门为建单登录科室
	&SQL(Update sqluser.DHC_EQInventory Set I_Status=1,I_ManageLocDR=:locid,I_FreezeDate=:curDate,I_FreezeTime=:curTime,I_FreezeUser=:user where I_RowID=:RowID)
	;&SQL(Update sqluser.DHC_EQInventory Set I_Status=1,I_FreezeDate=:curDate,I_FreezeTime=:curTime,I_FreezeUser=:user where I_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	/*/更新过滤条件
	if FilterInfo'=""
	{
		s IFICount=0
		s Count=$l(FilterInfo,"|")
		s Flag=0
		for i=1:1:Count
		{
			s IFI(2)=RowID
			s IFI(3)=$p($p(FilterInfo,"|",i),":",1)
			s IFI(4)=$p($p(FilterInfo,"|",i),":",2)
			&SQL(Select Count(*) Into :IFICount From sqluser.DHC_EQInventoryFilterInfo Where IFI_InventoryDR=:RowID and IFI_InventoryCondition=:IFI(3))
			i IFICount<=0
			{
				&SQL(Insert into sqluser.DHC_EQInventoryFilterInfo values :IFI())
			}
			else
			{
				&SQL(Update sqluser.DHC_EQInventoryFilterInfo values :IFI() Where IFI_InventoryDR=:RowID and IFI_InventoryCondition=:IFI(3))
			}
			i SQLCODE
			{
				s Flag=1
				s i=Count+1
			}
		}
		i Flag=1
		{
			TROLLBACK
			q SQLCODE
		}
	}*/
	
	s StoreLocDR=$p($g(^DHCEQInventory(RowID)),"^",2)
	s UseLocDR=$p($g(^DHCEQInventory(RowID)),"^",3)
	s EquipTypeIDs=$p($g(^DHCEQInventory(RowID)),"^",4)
	s StatCatDR=$p($g(^DHCEQInventory(RowID)),"^",5)
	s OriginDR=$p($g(^DHCEQInventory(RowID)),"^",6)
	s HospitalDR=$p($g(^DHCEQInventory(RowID)),"^",15)		// MZY0048	2020-08-21
	s LocIncludeFlag=$p($g(^DHCEQInventory(RowID)),"^",21)
	s EquipTypeIDs=","_EquipTypeIDs_","
	//增加参数判断盘点是否包含预报废设备
	s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")
	k PLIST
	s PLIST(2)=RowID
	
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid)) quit:(rowid="")||(SQLCODE'=0)  d
	.Set TInvalidFlag = $Piece($Get(^DHCEQEquip(rowid)),"^",59)
	.Quit:TInvalidFlag'="N"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:((StockStatus=0)||(StockStatus=3))		///尚未入库或已经出库的设备
	.q:$p($g(^DHCEQEquip(rowid)),"^",38)=3		///报废的设备
	.//q:((EquipTypeDR'="")&&(EquipTypeDR'=$p($g(^DHCEQEquip(rowid)),"^",63)))
	.s TEquipTypeDR=","_$p($g(^DHCEQEquip(rowid)),"^",63)_","
	.q:EquipTypeIDs'[TEquipTypeDR
	.q:((StatCatDR'="")&&(StatCatDR'=$p($g(^DHCEQEquip(rowid)),"^",75)))
	.//q:((StoreLocDR'="")&&(StoreLocDR'=$p($g(^DHCEQEquip(rowid)),"^",67)))
	.s TBillStoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
	.// MZY0048	2020-08-21
	.s THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TBillStoreLocDR)
	.q:(HospitalDR'="")&&(HospitalDR'=THospitalDR)
	.q:((LocIncludeFlag'="Y")&&(StoreLocDR'="")&&(StoreLocDR'=TBillStoreLocDR))
	.q:((LocIncludeFlag="Y")&&(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,TBillStoreLocDR,"1")'="1"))
	.
	.Quit:(##Class(web.DHCEQCommon).CheckManageLimit(user,CurGroupID,"",$p($g(^DHCEQEquip(rowid)),"^",63),$p($g(^DHCEQEquip(rowid)),"^",75),$p($g(^DHCEQEquip(rowid)),"^",4),$p($g(^DHCEQEquip(rowid)),"^",67),rowid,$p($g(^DHCEQEquip(rowid)),"^",7)))
	.s Flag=0
	.i ($p($g(^DHCEQEquip(rowid)),"^",67)'="") s Flag=##class(web.DHCEQCommon).LocIsInEQ(QXType,$p($g(^DHCEQEquip(rowid)),"^",67))
	.q:Flag'=0
	.q:((UseLocDR'="")&&(UseLocDR'=$p($g(^DHCEQEquip(rowid)),"^",19)))
	.q:((OriginDR'="")&&(OriginDR'=$p($g(^DHCEQEquip(rowid)),"^",20)))
	.//增加参数判断盘点是否包含预报废设备
	.Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(rowid)),"^",93)="2")
	.s PLIST(3)=rowid								///BillEquipDR
	.s PLIST(5)=$p($g(^DHCEQEquip(rowid)),"^",67)	///StoreLocDR
	.s PLIST(6)=$p($g(^DHCEQEquip(rowid)),"^",19)	///UseLocDR
	.s PLIST(9)=+$p($g(^DHCEQEquip(rowid)),"^",27)	///OriginalFee
	.s PLIST(10)=+$p($g(^DHCEQEquip(rowid)),"^",28)	///NetFee
	.s PLIST(11)=+$p($g(^DHCEQEquip(rowid)),"^",35)	///DepreTotalFee
	.
	.s TEquipName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.s OriginalFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	.s TransassetDate=$p($g(^DHCEQEquip(rowid)),"^",45)
	.s InStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
	.i (TransassetDate="")&&(InStockListDR'="")  d
	..s ISRowID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	..i ISRowID'="" s TransassetDate=$p($g(^DHCEQInStock(ISRowID)),13)
	.;Add by QW20210519 BUG:QW0112 增加存放地点 begin
	.s TLocationDR=$p($g(^DHCEQEquip(rowid)),"^",72)
	.;Add by QW20210519 BUG:QW0112 增加存放地点 end
	.s (FName,FOriginalFeeS,FOriginalFeeE,FStartDate,FEndDate,FLocationDR)=""  ;Modified by QW20210519 BUG:QW0112 增加冻结存放地点
	.s ConditionName=0
	.f  s ConditionName=$o(^DHCEQInventoryFilterInfo(0,"Inventory",RowID,ConditionName)) q:ConditionName=""  d
	..s ID=$o(^DHCEQInventoryFilterInfo(0,"Inventory",RowID,ConditionName,0))
	..s FValue=$p($g(^DHCEQInventoryFilterInfo(ID)),"^",3)
	..i ConditionName="EquipName" s FName=$ZCONVERT(FValue,"U")
	..i ConditionName="OriginalFeeStart" s FOriginalFeeS=FValue
	..i ConditionName="OriginalFeeEnd" s FOriginalFeeE=FValue
	..i (ConditionName="StartDate") s FStartDate=##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")  ; s FStartDate=$ZDH(FValue,4)
	..i (ConditionName="EndDate") s FEndDate=##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")  ; s FEndDate=$ZDH(FValue,4)
	..i (ConditionName="LocationDR")  s FLocationDR=FValue ;Add by QW20210519 BUG:QW0112 增加冻结存放地点
	.q:(FName'="")&&(TEquipName'[FName)
	.q:(FOriginalFeeS'="")&&(OriginalFee<FOriginalFeeS)
	.q:(FOriginalFeeE'="")&&(OriginalFee>FOriginalFeeE)
	.q:(FStartDate'="")&&(TransassetDate<FStartDate)
	.q:(FEndDate'="")&&(TransassetDate>FEndDate)
	.q:(FLocationDR'="")&&(TLocationDR'=FLocationDR)  ;Add by QW20210519 BUG:QW0112 增加冻结存放地点
	.&SQL(Insert into sqluser.DHC_EQInventoryList values :PLIST())
	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
	s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(RowID)
	i SQLCODE
		{	TROLLBACK	}
	else
		{	TCommit		}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, RowID)
}

/// modified by ZY0236 2020-06-17
/// 盘点冻结的时候生成盘点审核信息表数据
/// w ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(294)
/// modify by jyp 2022-09-21
ClassMethod UpdateInventoryAudit(InventoryDR, StoreLocDR As %String = "", Type As %String = "0")
{
	new BillStoreLocDR,TotalNum,DiffeNum,ProfitNum,LoseNum,NotInventoryNum,BillEquipDR,rowid,SQLCODE
	i InventoryDR="" q 0
	k IAPLIST
	s IAPLIST(2)=InventoryDR
	s (BillStoreLocDR,SQLCODE)=0
	f  s BillStoreLocDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,BillStoreLocDR))  quit:((BillStoreLocDR="")||(SQLCODE'=0))  d
	.//Modify by zx 2020-06-30 提取获取方法
	.;s (TotalNum,DiffeNum,ProfitNum,LoseNum,NotInventoryNum)=0
	.;s BillEquipDR=0
	.;f  s BillEquipDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,BillStoreLocDR,BillEquipDR))  quit:((BillEquipDR=""))  d
	.;.s rowid=0
	.;.f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,BillStoreLocDR,BillEquipDR,rowid))  quit:((rowid=""))  d
	.;..s TotalNum=TotalNum+1
	.;..///1:账物一致|2:科室不符|3:盘亏|4:待查找
	.;..s TStatus=+$p($g(^DHCEQInventoryList(rowid)),"^",14)
	.;..i TStatus=0  d
	.;...s NotInventoryNum=NotInventoryNum+1
	.;..e  i TStatus=2  d
	.;...s DiffeNum=DiffeNum+1
	.;..e  i TStatus=3  d
	.;...s ProfitNum=ProfitNum+1
	.;..e  i TStatus=4  d
	.;...s LoseNum=LoseNum+1
	.q:((StoreLocDR'="")&&(StoreLocDR'=BillStoreLocDR))
	.if Type=0 s ResultInfo=##Class(web.DHCEQ.EM.BUSInventory).InventoryResultStat(InventoryDR,BillStoreLocDR)
	.e  s ResultInfo=##Class(web.DHCEQ.EM.BUSInventory).InventoryResultStatDispose(InventoryDR,BillStoreLocDR)
	.///写数据
	.s IAPLIST(3)=BillStoreLocDR
	.s IAPLIST(4)=+$p(ResultInfo,"^",1)  //TotalNum	//账目数量
	.s IAPLIST(5)=+$p(ResultInfo,"^",2)  //DiffeNum	//差异数量
	.s IAPLIST(6)=+$p(ResultInfo,"^",3)  //ProfitNum	//盘盈数量
	.s IAPLIST(7)=+$p(ResultInfo,"^",4)  //LoseNum	//盘亏数量
	.s IAPLIST(8)=+$p(ResultInfo,"^",5)  //NotInventoryNum	//未盘数量
	.s IAPLIST(9)=0
	.s IAPLIST(10)=""	//remark
	.// MZY0050	1498290		2020-09-01
	.s IAPLIST(11)=+$p(ResultInfo,"^",6)	//Hold1	IConsistentNum:账物一致数
	.s IAPLIST(12)=+$p(ResultInfo,"^",7)	//Hold2	IUnCheckLocNum:科室不符数
	.s IAPLIST(13)=+$p(ResultInfo,"^",8)	//Hold3	IFindNum:待查找数
	.s IAPLIST(14)=+$p(ResultInfo,"^",9)	//Hold4 DisUseNum:有报废单
	.s IAPLIST(15)=""	//Hold5
	.s IAPLIST(16)=Type	//Type
	.s tmp=""
	.&SQL(select IA_RowID into :tmp from sqluser.DHC_EQInventoryAudit where IA_InventoryDR=:IAPLIST(2) and IA_LocDR=:IAPLIST(3) and IA_Type=:IAPLIST(16))
	.i tmp="" d
	..&SQL(Insert into sqluser.DHC_EQInventoryAudit values :IAPLIST())
	.e  d
	..&SQL(update sqluser.DHC_EQInventoryAudit values :IAPLIST() where IA_RowID=:tmp)
	q SQLCODE
}

/// 描述:保存盘点结果
/// w ##Class(web.DHCEQ.EM.BUSInventory).SaveInventoryList("44","1^4^3^传真机^124^1880^8^5^5^25^备注^04/03/2011^^^^^^&2^^2^笔记本电脑^1^^8^5000^10^50000^^^^^^^^")
ClassMethod SaveInventoryList(InventoryDR, dataList)
{
	Set SQLCODE=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set Length=$l(dataList,SplitRowCode)
	Set tmpInventoryDR=""
	TStart
	for k=1:1:Length
	{
		/*
		s valList=$p(dataList,SplitRowCode,k)
		q:valList=""
		k PLIST,ISLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQContractList",JsonData,.PLIST)
		s CTLRowID = JsonData.%Get("CTLRowID")
		s PLIST(2)=RowID				;CTL_ContractDR
		&SQL(Update SQLUSER.DHC_EQContractList Values :PLIST() where CTL_RowID = :CTLRowID)
		i SQLCODE'=0 q*/
		q:SQLCODE'=0
		k PLIST
		s info=$p(dataList,SplitRowCode,k)
		q:info=""
		s ILRowID=$p(info,"^",1)
		s PLIST(4)=$p($g(^DHCEQInventoryList(ILRowID)),"^",2)	;IL_ActerEquipDR
		s PLIST(7)=$p(info,"^",2)		;IL_ActerStoreLocDR
		s PLIST(8)=$p(info,"^",3)		;IL_ActerUseLocDR
		s PLIST(12)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	;IL_UserDR
		s PLIST(13)=+$H
		s PLIST(14)=+$p($H,",",2)
		s PLIST(15)=$p(info,"^",4)		;ILStatus
		s PLIST(16)=$p(info,"^",5)		;ILRemark
		s PLIST(22)=$p(info,"^",6)		;ILCondition
		s PLIST(26)=$p(info,"^",7)		;LIUseStatus
		s PLIST(27)=$p(info,"^",8)		;LIPurpose
		s PLIST(28)=$p(info,"^",9)		;LILossReasonDR
		&SQL(Update sqluser.DHC_EQInventoryList values :PLIST() Where IL_RowID=:ILRowID)
		q:SQLCODE'=0
		;s RowID=$G(%ROWID)
		;rows[i].ILIKeeperDR+"^"+rows[i].ILILocationDR+"^"+rows[i].ILILeaveFactoryNo+"^"+rows[i].ILILocationDR_LDesc;
		s InventoryListInfo=##Class(web.DHCEQ.EM.BUSInventory).GetOneListInfo(ILRowID)
		s data=$p(InventoryListInfo,"^",4)_"^"_ILRowID_"^"_$p(info,"^",10)_"^"_$p(info,"^",11)_"^"_$p(info,"^",12)_"^^"_$p(info,"^",13)
		s result=##Class(web.DHCEQ.EM.BUSInventory).SaveListInfo(data)
		q:result<0
		i tmpInventoryDR="" d
		.s tmpInventoryDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",1)
		e  d
		.i (","_tmpInventoryDR_",")'[(","_$p($g(^DHCEQInventoryList(ILRowID)),"^",1)_",") Set tmpInventoryDR=tmpInventoryDR_","_$p($g(^DHCEQInventoryList(ILRowID)),"^",1)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;i InventoryDR'="" s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR)
	i InventoryDR'="" s tmpInventoryDR=InventoryDR
	s length=$L(tmpInventoryDR,",")
	f i=1:1:length q:SQLCODE'=0  d
	.s InventoryDR=$p(tmpInventoryDR,",",i)
	.s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR)
	.q:SQLCODE'=0
	.s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR,"",1)   //add by jyp 2022-09-21
	
	i SQLCODE
		{	TROLLBACK	}
	else
		{	TCommit		}
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// MZY0050	1498290		2020-09-01	追加输出
/// 	IConsistentNum:账物一致数 IUnCheckLocNum:科室不符数 IFindNum:待查找数
/// 		ITotalNum总数=IConsistentNum账物一致数+IDiffeNum差异数
/// 		IDiffeNum差异数=INotInventoryNum未盘数+IUnCheckLocNum科室不符数+ILoseNum盘亏数+IFindNum待查找数
/// MZY0045	1432837		2020-08-14	增加查询状态参数:CStatus
/// Mozy0254		1099780		2020-3-5	增加库房参数StoreLocDR
/// Modify by zx 2020-07-07 增加IARowID输出
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","QueryInventory","","","","0","1","","478","257","1")
Query QueryInventory(BeginDate As %String, EndDate As %String, InventoryNo As %String, QXType As %String = "", StatusDR As %String = "", HospitalDR As %String = "", StoreLocDR As %String = "", ManageLocDR As %String = "", IAStatusDR As %String = "", CStatus As %String = "", PlanDR As %String = "") As %Query(ROWSPEC = "IRowID:%String,IInventoryNo:%String,IStoreLocDR:%String,IUseLocDR:%String,IEquipTypeDR:%String,IStatCatDR:%String,IOriginDR:%String,IDate:%String,ITime:%String,IUserDR:%String,IStatus:%String,IRemark:%String,ICompleter:%String,ICompleteDate:%String,IManageLocDR:%String,IHospitalDR:%String,IExpectDate:%String,IFreezeDate:%String,IFreezeTime:%String,IFreezeUser:%String,ISelfFlag:%String,ILocIncludeFlag:%String,IHold6:%String,IHold7:%String,IHold8:%String,IHold9:%String,IHold10:%String,IStoreLoc:%String,IUseLoc:%String,IEquipType:%String,IStatCat:%String,IOrigin:%String,IStatusDesc:%String,IManageLoc:%String,IHospital:%String,ITotalNum:%String,IDiffeNum:%String,IProfitNum:%String,ILoseNum:%String,INotInventoryNum:%String,IWarningFlag:%String,IARowIDs:%String,IConsistentNum:%String,IUnCheckLocNum:%String,IFindNum:%String,IHold6:%String,IPlanName:%String")
{
}

ClassMethod QueryInventoryExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, InventoryNo As %String, QXType As %String = "", StatusDR As %String = "", HospitalDR As %String = "", StoreLocDR As %String = "", ManageLocDR As %String = "", IAStatusDR As %String = "", CStatus As %String = "", PlanDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	//s CurHospID=%session.Get("LOGON.HOSPID")
	i BeginDate="" s BeginDate=0
	e  s BeginDate=##class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")
	i EndDate="" s EndDate=+$H
	e  s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	i StoreLocDR'="" s StoreLocDR=##Class(web.DHCEQ.EM.BUSInventory).GetTopLocDR(StoreLocDR)
	// Modify by zx 2020-07-12
	s (ITotalNum,IDiffeNum,IProfitNum,ILoseNum,INotInventoryNum)=0
	s rowid=0
	f  s rowid=$o(^DHCEQInventory(rowid))  quit:rowid=""  d
	.d ResetVariablesQueryInventory
	.s data=$g(^DHCEQInventory(rowid))
	.s IRowID=rowid
	.s IInventoryNo=$p(data,"^",1)
	.q:((InventoryNo'="")&&(IInventoryNo'[InventoryNo))
	.s IHold6=$p(data,"^",22)
	.q:((PlanDR'="")&&(PlanDR'=IHold6))
	.i (IHold6'="") s IPlanName=$p($g(^DHCEQInventoryPlan(IHold6)),"^",2)
	.s IStoreLocDR=$p(data,"^",2)
	.//q:(StoreLocDR'="")&&(IStoreLocDR'=StoreLocDR)	//当IStoreLocDR="",要看明细中对应的科室是否可显示
	.q:(StoreLocDR'="")&&(IStoreLocDR'="")&&(StoreLocDR'=IStoreLocDR)
	.;q:(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,vStoreLocID,"1")'="1")
	.;quit:((CurHospID'="")&&($p(data,"^",15)'=CurHospID))
	.s IUseLocDR=$p(data,"^",3)
	.s IEquipTypeDR=$p(data,"^",4)
	.//过滤类组
	.s qFlag=0
	.i IEquipTypeDR'="" d
	..s length=$L(IEquipTypeDR,",")
	..f i=1:1:length q:qFlag=1  d
	...s EquipTypeDR=$p(IEquipTypeDR,",",i)
	...;i (0'=##class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR))  d  
	...;.s qFlag=1
	.q:qFlag=1
	.
	.s IStatCatDR=$p(data,"^",5)
	.s IOriginDR=$p(data,"^",6)
	.s IDate=$p(data,"^",7)
	.
	.q:((BeginDate'="")&&(BeginDate>IDate))
	.q:((EndDate'="")&&(EndDate<IDate))
	.
	.s IDate=##class(web.DHCEQCommon).TransValueToPage(IDate,"date")
	.s ITime=##Class(web.DHCEQCommon).TransValueToPage($p(data,"^",8),"time")
	.s IUserDR=$p(data,"^",9)
	.s IStatus=$p(data,"^",10)
	./// MZY0045	1432837		2020-08-14
	.q:(CStatus="")&&(StatusDR'=IStatus)
	.q:(CStatus'="")&&(CStatus'="3")&&(CStatus'=IStatus)
	.
	.s IStatusDesc=##Class(web.DHCEQInStockNew).GetInStockStatus(IStatus)
	.s IRemark=$p(data,"^",11)
	.s ICompleter=$p(data,"^",12)
	.s ICompleteDate=##class(web.DHCEQCommon).TransValueToPage($p(data,"^",13),"date")
	.s IManageLocDR=$p(data,"^",14)
	.q:(ManageLocDR'="")&&(ManageLocDR'=IManageLocDR)
	.
	.;s Flag=0
	.;i (IManageLocDR'="")&&(ISelfFlag'="1")  d
	.;.s Flag=##class(web.DHCEQCommon).LocIsInEQ(QXType,IManageLocDR)
	.;q:Flag'=0 
	.s IHospitalDR=$p(data,"^",15)
	.; MZY0048	2020-08-21	注释默认院区取值
	.; MZY0047	1359373		2020-08-19		修正盘点单院区取值:盘点科室->管理部门
	.;i IHospitalDR="" s IHospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(IStoreLocDR)
	.;i IHospitalDR="" s IHospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(IManageLocDR)
	.q:(HospitalDR'="")&&(HospitalDR'=IHospitalDR)
	.s IHospital=$p($g(^CT("HOSP",+IHospitalDR)),"^",2)
	.
	.s ISelfFlag=$p(data,"^",20)
	.s ILocIncludeFlag=$p(data,"^",21)
	.///ZY0236	20200619
	.//提交之后管理科室只要一致的就能显示在管理科室菜单下
	.//新建IAStatusDR=0，盘点提交IAStatusDR=1
	.//临床StoreLocDR'="",同时临床科室只能自盘ISelfFlag=1,
	.//判断StoreLoc科室是一致，根据IAStatusDR参数,控制提交之后的单据状态
	.//需要科室自盘的时候才需要到DHCEQInventoryAudit看结果，这时候管理科室为空
	.;Modify by zx 2020-07-12
	.s (IARowID,IAStatus,vIARowID)=""
	.;s AuditIncludeFlag=0  //Modify by zx 2021-12-20 BUG ZX0142
	.s vStoreLocID=0
	.;Modify by zx 2020-07-13 获取到审核表id后不退出,还需要获取子科室
	.f  s vStoreLocID=$o(^DHCEQInventoryAudit(0,"Inventory",IRowID,vStoreLocID)) q:vStoreLocID=""  d
	..s AuditIncludeFlag=0 //每次遍历都需要确定此次数据是否加入汇总
	..;Modify by zx 2020-07-12
	..s vIARowID=$o(^DHCEQInventoryAudit(0,"Inventory",IRowID,vStoreLocID,0))
	..q:vIARowID=""
	..i StoreLocDR'="" d
	...//临床科室访问需判断
	...i ILocIncludeFlag'="Y" d
	....//当不包含子科室,科室一致时加
	....i StoreLocDR=vStoreLocID d
	.....s AuditIncludeFlag=1
	.....s IARowID=vIARowID
	...e  d
	....//包含子科室
	....i (##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,vStoreLocID,"1")="1") d
	.....s AuditIncludeFlag=1
	..e  d
	...//管理部门访问直接累加
	...s AuditIncludeFlag=1
	..//AuditIncludeFlag=1为符合条件
	..i AuditIncludeFlag=1 d
	...s ITotalNum=+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",3)+ITotalNum
	...s IDiffeNum=+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",4)+IDiffeNum
	...s IProfitNum=+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",5)+IProfitNum
	...s ILoseNum=+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",6)+ILoseNum
	...s INotInventoryNum=+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",7)+INotInventoryNum
	...// MZY0050	1498290		2020-09-01
	...s IConsistentNum=+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",10)+IConsistentNum
	...s IUnCheckLocNum=+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",11)+IUnCheckLocNum
	...s IFindNum=+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",12)+IFindNum
	...i IARowIDs'="" s IARowIDs=IARowIDs_"^"
	...s IARowIDs=IARowIDs_vIARowID
	.
	.i (ISelfFlag="Y")&&(IARowID'="") s IAStatus=$p($g(^DHCEQInventoryAudit(IARowID)),"^",8)
	.i (StoreLocDR'="")&&(IARowIDs="") s IARowIDs=IARowID
	.//q:(ManageLocDR="")&&(IAStatusDR'="")&&(IAStatusDR'=IAStatus)
	.;s ^ZY(IRowID)="StoreLocDR="_StoreLocDR_",IAStatusDR="_IAStatusDR_",IAStatus="_IAStatus_",CStatus="_CStatus
	./// MZY0045	1432837		2020-08-14
	.//q:(StoreLocDR'="")&&(IAStatusDR'="")&&(IAStatusDR'=IAStatus)&&(CStatus="")&&(ISelfFlag'="Y")
	.s IExpectDate=##class(web.DHCEQCommon).TransValueToPage($p(data,"^",16),"date")
	.s IFreezeDate=##class(web.DHCEQCommon).TransValueToPage($p(data,"^",17),"date")
	.s IFreezeTime=##Class(web.DHCEQCommon).TransValueToPage($p(data,"^",18),"time")
	.s IFreezeUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(data,"^",19))
	.s ICompleter=##Class(web.DHCEQCommon).GetTrakNameByID("user",ICompleter)
	.s ISelfFlag=##class(web.DHCEQCommon).TransValueFromPage(ISelfFlag,"bool")
	.s IStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",IStoreLocDR)
	.s IUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",IUseLocDR)
	.s IManageLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",IManageLocDR)
	.s IEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",IEquipTypeDR)
	.s IStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",IStatCatDR)
	.s IOrigin=##Class(web.DHCEQCommon).GetTrakNameByID("origin",IOriginDR)
	.//Modify by zx 2020-07-13 数量获取方式调整为审核表
	.;s IResultInfo=##Class(web.DHCEQ.EM.BUSInventory).InventoryResultStat(rowid,StoreLocDR)
	.;s ITotalNum=+$p(IResultInfo,"^",1)
	.;s IDiffeNum=+$p(IResultInfo,"^",2)
	.;s IProfitNum=+$p(IResultInfo,"^",3)
	.;s ILoseNum=+$p(IResultInfo,"^",4)
	.;s INotInventoryNum=+$p(IResultInfo,"^",5)
	.//Modify by zx 2020-06-30 预警显示 0,正常 1,预警 2,超期
	.s IWarningFlag="0"
	.i $p(data,"^",16)<=+$H d
	..s IWarningFlag="2"
	.e  i ($p(data,"^",16)>+$H)&&($p(data,"^",16)<=+$H+30) d
	..s IWarningFlag="1"
	.s IDiffeNum=ITotalNum-INotInventoryNum
	.d OutputRowQueryInventory
	
	Quit $$$OK

OutputRowQueryInventory
	Set Data=$lb(IRowID,IInventoryNo,IStoreLocDR,IUseLocDR,IEquipTypeDR,IStatCatDR,IOriginDR,IDate,ITime,IUserDR,IStatus,IRemark,ICompleter,ICompleteDate,IManageLocDR,IHospitalDR,IExpectDate,IFreezeDate,IFreezeTime,IFreezeUser,ISelfFlag,ILocIncludeFlag,IHold6,IHold7,IHold8,IHold9,IHold10,IStoreLoc,IUseLoc,IEquipType,IStatCat,IOrigin,IStatusDesc,IManageLoc,IHospital,ITotalNum,IDiffeNum,IProfitNum,ILoseNum,INotInventoryNum,IWarningFlag,IARowIDs,IConsistentNum,IUnCheckLocNum,IFindNum,IHold6,IPlanName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesQueryInventory
	s (IRowID,IInventoryNo,IStoreLocDR,IUseLocDR,IEquipTypeDR,IStatCatDR,IOriginDR,IDate,ITime,IUserDR,IStatus,IRemark,ICompleter,ICompleteDate,IManageLocDR,IHospitalDR,IExpectDate,IFreezeDate,IFreezeTime,IFreezeUser,ISelfFlag,ILocIncludeFlag,IHold6,IHold7,IHold8,IHold9,IHold10,IStoreLoc,IUseLoc,IEquipType,IStatCat,IOrigin,IStatusDesc,IManageLoc,IHospital,IResultInfo,ITotalNum,IDiffeNum,IProfitNum,ILoseNum,INotInventoryNum,IWarningFlag,IARowIDs,IConsistentNum,IUnCheckLocNum,IFindNum,IHold6,IPlanName)=""
	quit
}

ClassMethod QueryInventoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInventoryExecute ]
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

ClassMethod QueryInventoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInventoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetNextLoc(InventoryDR, CurLocDR)
{
	new result
	if InventoryDR="" q ""
	s result=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,CurLocDR))
	q result
}

ClassMethod GetNextListInfo(InventoryDR, LocDR, EquipDR, RowID)
{
	new NewEquipDR,NewRowID
	new Name,Model,Manufactory,No,Unit,EquipCat,StoreLoc,UseLocDR,UseLoc,OriginalFee,Origin,StorePlace
	new CheckDate,OpenCheckDate,Country,ManageUser,InDate,EquipType,LeaveFactoryNo,Provider
	s (Name,Model,Manufactory,No,Unit,EquipCat,StoreLoc,UseLocDR,UseLoc,OriginalFee,Origin,StorePlace)=""
	s (CheckDate,OpenCheckDate,Country,ManageUser,InDate,EquipType,LeaveFactoryNo,Provider)=""
	i (InventoryDR="")||(LocDR="") q ""
	if EquipDR=""
	{
		s EquipDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,LocDR,EquipDR))
		s RowID=""
	}
	if EquipDR="" q ""
	s NewRowID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,LocDR,EquipDR,RowID))
	i (NewRowID'="")
	{
		s NewEquipDR=EquipDR
	}
	else
	{
		s NewEquipDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,LocDR,EquipDR))
		i (NewEquipDR'="") s NewRowID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,LocDR,NewEquipDR,0))
	}
	i ((NewEquipDR="")||(NewRowID="")) q ""
	
	s Name=$p($g(^DHCEQEquip(NewEquipDR)),"^",1)
	s Model=$p($g(^DHCEQEquip(NewEquipDR)),"^",3)
	i Model'="" s Model=$p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	s Manufactory=$p($g(^DHCEQEquip(NewEquipDR)),"^",26)
	i Manufactory'="" s Manufactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",Manufactory) //CZF0093
	s No=$p($g(^DHCEQEquip(NewEquipDR)),"^",71)
	s Unit=$p($g(^DHCEQEquip(NewEquipDR)),"^",5)
	i Unit'="" s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
	s EquipCat=$p($g(^DHCEQEquip(NewEquipDR)),"^",4)
	i EquipCat'="" s EquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipCat)),"^",2)
	s StoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
	s UseLocDR=$p($g(^DHCEQEquip(NewEquipDR)),"^",19)
	i UseLocDR'="" s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	s OriginalFee=$p($g(^DHCEQEquip(NewEquipDR)),"^",27)
	s Origin=$p($g(^DHCEQEquip(NewEquipDR)),"^",20)
	i Origin'="" s Origin=$p($g(^DHCEQCCode("DHCEQCOrigin",Origin)),"^",2)
	s StorePlace=$p($g(^DHCEQEquip(NewEquipDR)),"^",72)
	s OpenCheckDate=$p($g(^DHCEQEquip(NewEquipDR)),"^",12)
	i OpenCheckDate'="" s OpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(OpenCheckDate,"date")
	s CheckDate=$p($g(^DHCEQEquip(NewEquipDR)),"^",13)
	i CheckDate'="" s CheckDate=##Class(web.DHCEQCommon).TransValueToPage(CheckDate,"date")
	s Country=$p($g(^DHCEQEquip(NewEquipDR)),"^",16)
	i Country'="" s Country=##Class(web.DHCEQCommon).GetTrakNameByID("cou",Country)
	s ManageUser=$p($g(^DHCEQEquip(NewEquipDR)),"^",39)
	i ManageUser'="" s ManageUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",ManageUser)
	s InDate=$p($g(^DHCEQEquip(NewEquipDR)),"^",45)
	i InDate="" s InDate=$p($g(^DHCEQEquip(NewEquipDR)),"^",53)
	i InDate'="" s InDate=##Class(web.DHCEQCommon).TransValueToPage(InDate,"date")
	s EquipType=$p($g(^DHCEQEquip(NewEquipDR)),"^",63)
	s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipType)
	s LeaveFactoryNo=$p($g(^DHCEQEquip(NewEquipDR)),"^",10)
	s Provider=$p($g(^DHCEQEquip(NewEquipDR)),"^",25)
	s Provider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",Provider)
	
	q NewEquipDR_"^"_NewRowID_"^"_Name_"^"_Model_"^"_Manufactory_"^"_No_"^"_Unit_"^"_EquipCat_"^"_StoreLoc_"^"_UseLocDR_"^"_UseLoc_"^"_OriginalFee_"^"_Origin_"^"_StorePlace_"^"_CheckDate_"^"_OpenCheckDate_"^"_Country_"^"_ManageUser_"^"_InDate_"^"_EquipType_"^"_LeaveFactoryNo_"^"_Provider
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).GetOneListInfo(28)
ClassMethod GetOneListInfo(RowID)
{
	if (RowID="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, RowID)
	
	s ILIRowID=$O(^DHCEQInventoryListInfo(0,"IList",RowID,""))
	s EquipDR=$p($g(^DHCEQInventoryList(RowID)),"^",2)		;IL_BillEquipDR
	s InventoryListInfo=RowID
	s InventoryListInfo=InventoryListInfo_"^"_$p($g(^DHCEQEquip(EquipDR)),"^",71)_"^"_$p($g(^DHCEQEquip(EquipDR)),"^",1)
	
	i ILIRowID'=""
	{
		s InventoryListInfo=InventoryListInfo_"^"_ILIRowID_"^"_$G(^DHCEQInventoryListInfo(ILIRowID))
		s InventoryListInfo=InventoryListInfo_"^"	;保管人
		i $p(InventoryListInfo,"^",3)'=""  d
		.s InventoryListInfo=InventoryListInfo_##Class(web.DHCEQCommon).GetTrakNameByID("user", $p(InventoryListInfo,"^",6))
		s InventoryListInfo=InventoryListInfo_"^"	;存放地点
		i $p(InventoryListInfo,"^",4)'=""  d
		.s InventoryListInfo=InventoryListInfo_##Class(web.DHCEQCommon).GetTrakNameByID("location", $p(InventoryListInfo,"^",7))
	}
	else
	{
		s InventoryListInfo=InventoryListInfo_"^^^"_$p($g(^DHCEQEquip(EquipDR)),"^",66)_"^"_$p($g(^DHCEQEquip(EquipDR)),"^",72)_"^"_$p($g(^DHCEQEquip(EquipDR)),"^",10)
		s InventoryListInfo=InventoryListInfo_"^^^^^^^^^^"_##Class(web.DHCEQCommon).GetTrakNameByID("user", $p($g(^DHCEQEquip(EquipDR)),"^",66))
		s InventoryListInfo=InventoryListInfo_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("location", $p($g(^DHCEQEquip(EquipDR)),"^",72))
	}
	Quit InventoryListInfo
}

/// 保存设备信息调整表
/// w ##Class(web.DHCEQ.EM.BUSInventory).SaveListInfo("^73^^11111^^1")
ClassMethod SaveListInfo(data As %String = "")
{
	s $ZT="ERRORSaveListInfo"
	
	k PLIST
	s RowID=$p(data,"^",1)
	s PLIST(2)=$p(data,"^",2)	;ILI_InventoryListDR
	s PLIST(3)=$p(data,"^",3)	;ILI_KeeperDR
	s PLIST(4)=$p(data,"^",4)	;ILI_LocationDR
	i PLIST(4)="" s PLIST(4)=##Class(web.DHCEQCLocation).UpdLocation(##class(web.DHCEQCHanZiEncoding).GetEncoding($p(data,"^",7),4,"","U")_"^"_$p(data,"^",7))
	;i PLIST(4)<=0 q -9001
	s PLIST(5)=$p(data,"^",5)	;ILI_LeaveFactoryNo
	s PLIST(6) ="N"				;ILI_InvalidFlag
	s userid=$p(data,"^",6)		//modified by czf 20200703 微信端用户id保存
	i userid="" s userid=%session.Get("LOGON.USERID")
	s PLIST(7) = ##Class(web.DHCEQCommon).getMapIDBySource("user",userid)		;UpdateUserDR
	s PLIST(8) = +$H			;UpdateDate
	s PLIST(9) = $P($H,",",2)	;UpdateTime
	
	TSTART
	if RowID'=""
	{
		&SQL(Update SQLUSER.DHC_EQInventoryListInfo Values :PLIST() where ILI_RowID = :RowID)
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQInventoryListInfo Values :PLIST())
		s RowID=$G(%ROWID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	TCOMMIT
	Quit RowID
	
ERRORSaveListInfo
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit -9000
}

/// MZY0050	1498290		2020-09-01	追加ConsistentNum,UnCheckLocNum,FindNum
/// Author: by zx 2020-06-30
/// Description: 盘点中盘点数据汇总
/// Input: CurInventoryDR:盘点单id, CurStoreLocDR:盘点科室
/// Output: 总数_"^"_差异数_"^"_盘盈数_"^"_盘亏数_"^"_未盘数
/// w ##Class(web.DHCEQ.EM.BUSInventory).InventoryResultStat("1","")
ClassMethod InventoryResultStat(CurInventoryDR As %String = "", CurStoreLocDR As %String = "")
{
	n BillEquipDR,ILRowID,TStatus,TotalNum,DiffeNum,ProfitNum,LoseNum,NotInventoryNum,ConsistentNum,UnCheckLocNum,FindNum,DisUseNum
	s (BillEquipDR,ILRowID,TStatus)=""
	s (TotalNum,DiffeNum,ProfitNum,LoseNum,NotInventoryNum,ConsistentNum,UnCheckLocNum,FindNum,DisUseNum)=0
	
	i CurInventoryDR=0 q TotalNum_"^"_DiffeNum_"^"_ProfitNum_"^"_LoseNum_"^"_NotInventoryNum_"^^^^"_DisUseNum	// MZY0050	1498290		2020-09-01
	i CurStoreLocDR'="" d
	.d BuildInventoryResultStat
	e  d
	.s CurStoreLocDR=0
	.f  s CurStoreLocDR=$o(^DHCEQInventoryList(0,"StoreLoc",CurInventoryDR,CurStoreLocDR))  quit:CurStoreLocDR=""  d
	..d BuildInventoryResultStat
	
	q TotalNum_"^"_DiffeNum_"^"_ProfitNum_"^"_LoseNum_"^"_NotInventoryNum_"^"_ConsistentNum_"^"_UnCheckLocNum_"^"_FindNum_"^"_DisUseNum	// MZY0050	1498290		2020-09-01
BuildInventoryResultStat
	s BillEquipDR=0
	f  s BillEquipDR=$o(^DHCEQInventoryList(0,"StoreLoc",CurInventoryDR,CurStoreLocDR,BillEquipDR))  quit:BillEquipDR=""  d
	.s ILRowID=0
	.f  s ILRowID=$o(^DHCEQInventoryList(0,"StoreLoc",CurInventoryDR,CurStoreLocDR,BillEquipDR,ILRowID))  quit:ILRowID=""  d
	..s TotalNum=TotalNum+1		;账面数量
	..s TStatus=+$p($g(^DHCEQInventoryList(ILRowID)),"^",14)	;1:账物一致|2:科室不符|3:盘亏|4:待查找|5:有报废单
	..// MZY0050	1498290		2020-09-01
	..i TStatus=0 s DiffeNum=DiffeNum+1			;差异数量=未盘数+科室不符数+盘亏数+待查找数
	..i TStatus=2 s DiffeNum=DiffeNum+1
	..i TStatus=3 s DiffeNum=DiffeNum+1
	..i TStatus=4 s DiffeNum=DiffeNum+1			
	..i TStatus=5 s DiffeNum=DiffeNum+1
	..i TStatus=0 s NotInventoryNum=NotInventoryNum+1	;未盘数量
	..i TStatus=1 s ConsistentNum=ConsistentNum+1		;账物一致数
	..i TStatus=2 s UnCheckLocNum=UnCheckLocNum+1		;科室不符数
	..i TStatus=3 s LoseNum=LoseNum+1			;盘亏数量
	..i TStatus=4 s FindNum=FindNum+1			;待查找数
	..i TStatus=5 s DisUseNum=DisUseNum+1
	s IERowID=0
	f  s IERowID=$o(^DHCEQInventoryException(0,"StoreLoc",CurInventoryDR,CurStoreLocDR,IERowID)) quit:IERowID=""  d
	.s ProfitNum=1+ProfitNum	//汇总库房盘盈设备数量
	
	quit
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).UpLoadInventoryResult("",5,"","",6010599000011,"木柜","","71","","","PDD2020060013")
ClassMethod UpLoadInventoryResult(InventoryDR, StoreLocDR, UseLocDR, EquipID, EquipNo, EquipName, ReasonType As %String = "", User As %String = "", InventoryDate As %String = "", InventoryTime As %String = "", InventoryNo As %String = "")
{
	;s ^DHCEQMozy("UpLoadInventoryResult")=InventoryDR_","_StoreLocDR_","_UseLocDR_","_EquipID_","_EquipNo_","_EquipName_","_ReasonType_","_User_","_InventoryDate_","_InventoryTime_","_InventoryNo
	if InventoryDR="" s InventoryDR=$o(^DHCEQInventory(0,"InventoryNo",InventoryNo,0))
	if InventoryDR="" q ""
	
	i EquipID="" s EquipID=$o(^DHCEQEquip(0,"No",EquipNo,0))
	new InventoryListDR,num
	
	if User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	if InventoryDate="" s InventoryDate=+$H
	if InventoryTime="" s InventoryTime=+$p($H,",",2)
	s InventoryListDR=""
	if EquipID'="" s InventoryListDR=$o(^DHCEQInventoryList(0,"BillEquip",InventoryDR,EquipID,0))
	
	k PLIST
	i EquipID'="" s PLIST(4)=EquipID
	s PLIST(7)=StoreLocDR
	s PLIST(8)=UseLocDR
	s PLIST(12)=User
	s PLIST(13)=InventoryDate
	s PLIST(14)=InventoryTime
	s PLIST(15)=1	;Status
	s PLIST(19)=ReasonType		;Hold3
	s PLIST(20)=EquipName		;Hold4
	s PLIST(21)=EquipNo			;Hold5
	
	TStart
	i InventoryListDR=""
	{
		s PLIST(2)=InventoryDR
		&SQL(Insert into sqluser.DHC_EQInventoryList values :PLIST())
	}
	else
	{
		i $p($g(^DHCEQInventoryList(InventoryListDR)),"^",4)'=StoreLocDR s PLIST(15)=2	;Status	 MZY0053	1505534		2020-09-08	根据实际使用科室处理盘点状态
		&SQL(Update sqluser.DHC_EQInventoryList values :PLIST() Where IL_RowID=:InventoryListDR)
	}
	i SQLCODE
	{	TRollBack	}
	else
	{
		i EquipID'=""
		{
			s num=$o(^DHCEQInventory(InventoryDR,"EX","Equip",EquipID,""),-1)+1
			s ^DHCEQInventory(InventoryDR,"EX","Equip",EquipID,num)=StoreLocDR_"^"_$H
		}
		elseif EquipNo'=""
		{
			s num=$o(^DHCEQInventory(InventoryDR,"EX","New","No",EquipNo,""),-1)+1
			s ^DHCEQInventory(InventoryDR,"EX","New","No",EquipNo,num)=StoreLocDR_"^"_$H
		}
		else
		{
			s num=$o(^DHCEQInventory(InventoryDR,"EX","New","Name",EquipName,""),-1)+1
			s ^DHCEQInventory(InventoryDR,"EX","New","Name",EquipName,num)=StoreLocDR_"^"_$H
		}
		TCommit	
	}
	q SQLCODE
}

/// Creator：      zy
/// CreatDate：    2020-6-17
/// Description:   盘点设备状态
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","InventoryAudit","","")
Query InventoryAudit(InventoryDR As %String = "", StoreLocDR As %String = "") As %Query(ROWSPEC = "IARowID:%String,IAInventoryDR:%String,IALocDR:%String,IATotalNum:%String,IADiffeNum:%String,IAProfitNum:%String,IALoseNum:%String,IANotInventoryNum:%String,IAStatus:%String,IARemark:%String,IAHold1:%String,IAHold2:%String,IAHold3:%String,IAHold4:%String,IAHold5:%String,IALoc:%String,IAStatusDesc:%String,TSelect:%String,TInventoryListInfo:%String")
{
}

ClassMethod InventoryAuditExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", StoreLocDR As %String = "") As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i InventoryDR="" Quit $$$OK
	s vStoreLocDR=0
	f  s vStoreLocDR=$o(^DHCEQInventoryAudit(0,"Inventory",InventoryDR,vStoreLocDR)) q:(vStoreLocDR="")  d
	.s IARowID=$o(^DHCEQInventoryAudit(0,"Inventory",InventoryDR,vStoreLocDR,0))
	.q:IARowID=""
	.i (StoreLocDR'="") d
	..i (StoreLocDR=vStoreLocDR) d
	...d OutputRowInventoryAudit
	.e  d
	..d OutputRowInventoryAudit
	Quit $$$OK
OutputRowInventoryAudit
	s IAInventoryDR=InventoryDR
	s IALocDR=$p($g(^DHCEQInventoryAudit(IARowID)),"^",2)
	s IATotalNum=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryAudit(IARowID)),"^",3),"")
	s IADiffeNum=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryAudit(IARowID)),"^",4),"")
	s IAProfitNum=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryAudit(IARowID)),"^",5),"")
	s IALoseNum=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryAudit(IARowID)),"^",6),"")
	s IANotInventoryNum=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryAudit(IARowID)),"^",7),"")
	s IAStatus=$p($g(^DHCEQInventoryAudit(IARowID)),"^",8)
	s IARemark=$p($g(^DHCEQInventoryAudit(IARowID)),"^",9)
	s IAHold1=$p($g(^DHCEQInventoryAudit(IARowID)),"^",10)
	s IAHold2=$p($g(^DHCEQInventoryAudit(IARowID)),"^",11)
	s IAHold3=$p($g(^DHCEQInventoryAudit(IARowID)),"^",12)
	s IAHold4=$p($g(^DHCEQInventoryAudit(IARowID)),"^",13)
	s IAHold5=$p($g(^DHCEQInventoryAudit(IARowID)),"^",14)
	
	s IALoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",IALocDR)
	s IAStatusDesc=$Case(IAStatus,0:"新增",1:"盘点科室提交",2:"管理科室确认")

	Set Data=$lb(IARowID,IAInventoryDR,IALocDR,IATotalNum,IADiffeNum,IAProfitNum,IALoseNum,IANotInventoryNum,IAStatus,IARemark,IAHold1,IAHold2,IAHold3,IAHold4,IAHold5,IALoc,IAStatusDesc,TSelect,TInventoryListInfo)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod InventoryAuditFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InventoryAuditExecute ]
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

ClassMethod InventoryAuditClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InventoryAuditExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 台账同步更新设备信息调整
/// w ##Class(web.DHCEQ.EM.BUSInventory).UpdateEquip(1)
ClassMethod UpdateEquip(CurInventoryDR As %Library.String = "")
{
	i CurInventoryDR="" q 0
	n SQLCODE,ILRowID,ILIRowID,EquipDR
	s SQLCODE=0
	s ILRowID=0
	f  s ILRowID=$o(^DHCEQInventoryList(0,"Inventory",CurInventoryDR,ILRowID)) quit:(ILRowID="")||(SQLCODE'=0)  d
	.s ILIRowID=$o(^DHCEQInventoryListInfo(0,"IList",ILRowID,""))
	.q:ILIRowID=""
	.q:$p($g(^DHCEQInventoryListInfo(ILIRowID)),"^",5)'="N"
	.k EQLIST
	.s EquipDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",2)
	.s EQLIST(67)=$p($g(^DHCEQInventoryListInfo(ILIRowID)),"^",2)
	.s EQLIST(73)=$p($g(^DHCEQInventoryListInfo(ILIRowID)),"^",3)
	.s EQLIST(11)=$p($g(^DHCEQInventoryListInfo(ILIRowID)),"^",4)
	.;Add By QW2021 bug号:QW00 begin
	.s EQLIST(27)=$p($g(^DHCEQInventoryListInfo(ILIRowID)),"^",9)  ;ILI_Hold1 生产厂商
	.s EQLIST(4)=$p($g(^DHCEQInventoryListInfo(ILIRowID)),"^",10) ;ILI_Hold2 机型
	.s EQLIST(26)=$p($g(^DHCEQInventoryListInfo(ILIRowID)),"^",11) ;ILI_Hold3 供应商
	.;Add By QW2021 bug号:QW00 end
	.&SQL(Update sqluser.DHC_EQEquip Values :EQLIST() Where EQ_RowID=:EquipDR)
	q SQLCODE
}

/// 保存盘点主单
/// w ##Class(web.DHCEQ.EM.BUSInventory).SaveInventoryException()
ClassMethod SaveInventoryException(data)
{
	s $ZT="ERRORSaveInventoryException"
	k PLIST
	new RowID
	
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s PLIST = ##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQInventoryException",JsonData,.PLIST)
	s RowID = JsonData.%Get("IERowID")
	s LDesc = JsonData.%Get("IELocationDR_LDesc")
	s PLIST(2) = JsonData.%Get("IEInventoryDR")
	s PLIST(13) = JsonData.%Get("IELocationDR")
	i (PLIST(13)="")&&(LDesc'="") s PLIST(13)=##Class(web.DHCEQCLocation).UpdLocation(##class(web.DHCEQCHanZiEncoding).GetEncoding(LDesc,4,"","U")_"^"_LDesc)
	s PLIST(15)=+$H
	s PLIST(16)=$P($H,",",2)
	
 	TSTART
	if RowID'=""
	{
		&SQL(Update SQLUSER.DHC_EQInventoryException Values :PLIST() where IE_RowID = :RowID)
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQInventoryException Values :PLIST())
		s RowID=$g(%ROWID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	// MZY0056	1517006		2020-09-29		汇总更新盘点审核表中的盘盈设备数量
	s InventoryDR=PLIST(2)
	&SQL(Update sqluser.DHC_EQInventoryAudit set IA_ProfitNum=0 Where IA_InventoryDR=:InventoryDR)		//清空原有盘盈数量
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s StoreLocDR=0
	f  s StoreLocDR=$o(^DHCEQInventoryException(0,"StoreLoc",InventoryDR,StoreLocDR)) quit:(StoreLocDR="")||(SQLCODE'=0)  d
	.s ProfitNum=0
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryException(0,"StoreLoc",InventoryDR,StoreLocDR,rowid)) quit:(rowid="")||(SQLCODE'=0)  d
	..s ProfitNum=1+ProfitNum	//汇总库房盘盈设备数量
	.
	.i ProfitNum>0 d
	..s IARowID=$o(^DHCEQInventoryAudit(0,"TypeInventory","0",InventoryDR,StoreLocDR,0))
	..i IARowID'="" d
	...;更新原有的盘点审核表信息
	...s TotalNum=$p($g(^DHCEQInventoryAudit(IARowID)),"^",3)
	...;;;;s orgProfitNum=$p($g(^DHCEQInventoryAudit(IARowID)),"^",5)	盘点审核表的总数不包含盘盈设备!!!!!!
	...;;;;s TotalNum=TotalNum-orgProfitNum+ProfitNum
	...&SQL(Update sqluser.DHC_EQInventoryAudit set IA_TotalNum=:TotalNum,IA_ProfitNum=:ProfitNum Where IA_RowID=:IARowID)
	..e  d
	...;更新原有的盘点审核表信息
	...k IAPLIST
	...s IAPLIST(2)=InventoryDR
	...s IAPLIST(3)=StoreLocDR
	...s IAPLIST(4)=0  //TotalNum	//账目数量	盘点审核表的总数不包含盘盈设备!!!!!!
	...s IAPLIST(5)=0  //DiffeNum	//差异数量
	...s IAPLIST(6)=ProfitNum  //ProfitNum	//盘盈数量
	...s IAPLIST(7)=0  //LoseNum	//盘亏数量
	...s IAPLIST(8)=0  //NotInventoryNum	//未盘数量
	...s IAPLIST(9)=0  //status
	...;s IAPLIST(10)=""	//remark
	...s IAPLIST(11)=0	//Hold1	IConsistentNum:账物一致数
	...s IAPLIST(12)=0	//Hold2	IUnCheckLocNum:科室不符数
	...s IAPLIST(13)=0	//Hold3	IFindNum:待查找数
	...;s IAPLIST(14)=""	//Hold4
	...;s IAPLIST(15)=""	//Hold5
	...&SQL(Insert into sqluser.DHC_EQInventoryAudit values :IAPLIST())
	.//begin add by jyp 添加盘点审核表处理状态保存  2022-09-21
	.s ProfitNum=0
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryException(0,"StoreLoc",InventoryDR,StoreLocDR,rowid)) quit:(rowid="")||(SQLCODE'=0)  d
	..q:(((+$p($g(^DHCEQInventoryException(rowid)),"^",29))'=6)&&((+$p($g(^DHCEQInventoryException(rowid)),"^",29))'=0))
	..s ProfitNum=1+ProfitNum	//汇总库房盘盈设备数量
	.
	.i ProfitNum>0 d
	..s IARowID=$o(^DHCEQInventoryAudit(0,"TypeInventory","1",InventoryDR,StoreLocDR,0))
	..i IARowID'="" d
	...;更新原有的盘点审核表信息
	...s TotalNum=$p($g(^DHCEQInventoryAudit(IARowID)),"^",3)
	...;;;;s orgProfitNum=$p($g(^DHCEQInventoryAudit(IARowID)),"^",5)	盘点审核表的总数不包含盘盈设备!!!!!!
	...;;;;s TotalNum=TotalNum-orgProfitNum+ProfitNum
	...&SQL(Update sqluser.DHC_EQInventoryAudit set IA_TotalNum=:TotalNum,IA_ProfitNum=:ProfitNum Where IA_RowID=:IARowID)
	..e  d
	...;更新原有的盘点审核表信息
	...k IAPLIST
	...s IAPLIST(2)=InventoryDR
	...s IAPLIST(3)=StoreLocDR
	...s IAPLIST(4)=0  //TotalNum	//账目数量	盘点审核表的总数不包含盘盈设备!!!!!!
	...s IAPLIST(5)=0  //DiffeNum	//差异数量
	...s IAPLIST(6)=ProfitNum  //ProfitNum	//盘盈数量
	...s IAPLIST(7)=0  //LoseNum	//盘亏数量
	...s IAPLIST(8)=0  //NotInventoryNum	//未盘数量
	...s IAPLIST(9)=0  //status
	...;s IAPLIST(10)=""	//remark
	...s IAPLIST(11)=0	//Hold1	IConsistentNum:账物一致数
	...s IAPLIST(12)=0	//Hold2	IUnCheckLocNum:科室不符数
	...s IAPLIST(13)=0	//Hold3	IFindNum:待查找数
	...;s IAPLIST(14)=""	//Hold4
	...;s IAPLIST(15)=""	//Hold5
	...&SQL(Insert into sqluser.DHC_EQInventoryAudit values :IAPLIST())
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;删除盘点审核表中无效的盘盈记录
	&SQL(Delete from sqluser.DHC_EQInventoryAudit Where IA_InventoryDR=:InventoryDR and IA_TotalNum=0 and IA_ProfitNum=0)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORSaveInventoryException
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).GetOneIException(11)
ClassMethod GetOneIException(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneIException"
	
	s ObjIException=##Class(User.DHCEQInventoryException).%OpenId(RowID)
	s IExceptionInfo=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ObjIException)
	
	d IExceptionInfo.%Set("IEUserLocDR_CTLOCDesc", ##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjIException.IEUserLocDR))
	d IExceptionInfo.%Set("IEStoreLocDR_CTLOCDesc", ##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjIException.IEStoreLocDR))
	d IExceptionInfo.%Set("IELocationDR_LDesc", ObjIException.IELocationDR.LDesc)
	d IExceptionInfo.%Set("IEProviderDR_VDesc", ##class(web.DHCEQCommon).GetTrakNameByID("prov",ObjIException.IEProviderDR))
	d IExceptionInfo.%Set("IEManuFactoryDR_MFName", ObjIException.IEManuFactoryDR.VName)   ///Modefied by zc0124 2022-11-02将IEManuFactoryDR_MFDesc改成IEManuFactoryDR_MFName
	
	//Modify by zx 2022-07-30
	d IExceptionInfo.%Set("IEUseStatus_USDesc", $Case(ObjIException.IEUseStatus,1:"在用",2:"拆封未使用",3:"未拆封",4:"积压闲置",5:"已盘亏",:""))
	d IExceptionInfo.%Set("IEPurpose_PDesc", $Case(ObjIException.IEPurpose,1:"医院日常使用",2:"储备物资",:""))
	d IExceptionInfo.%Set("IEActerEquipDR_EQName", ObjIException.IEActerEquipDR.EQName)
	d IExceptionInfo.%Set("IEKeeperDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjIException.IEKeeperDR))
	d IExceptionInfo.%Set("IEProfitReasonDR_PRDesc",ObjIException.IEProfitReasonDR.PRDesc)
	d IExceptionInfo.%Set("IEEquipTypeDR_ETDesc",ObjIException.IEEquipTypeDR.ETDesc)
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, IExceptionInfo)
ERRORGetOneIException
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// MZY0056	1517006		2020-09-29	调整删除盘盈设备记录操作后汇总更新盘点审核表中的盘盈设备数量
/// 描述:删除盘盈记录
/// w ##Class(web.DHCEQ.EM.BUSInventory).DeleteIException()
ClassMethod DeleteIException(IERowID As %String = "")
{
	i IERowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, IERowID)
	
	Set $ZT="ERRORDeleteIE"
	TSTART
	s SQLCODE=0
	s InventoryDR=$p($g(^DHCEQInventoryException(IERowID)),"^",1)
	s StoreLocDR=$p($g(^DHCEQInventoryException(IERowID)),"^",9)
	s IARowID=$o(^DHCEQInventoryAudit(0,"Inventory",InventoryDR,StoreLocDR,0))
	i IARowID'=""
	{
		s ProfitNum=$p($g(^DHCEQInventoryAudit(IARowID)),"^",5)-1
		&SQL(Update sqluser.DHC_EQInventoryAudit set IA_ProfitNum=:ProfitNum Where IA_RowID=:IARowID)
	}
	i SQLCODE'=0
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;删除盘点审核表中无效的盘盈记录
	&SQL(Delete from sqluser.DHC_EQInventoryAudit Where IA_InventoryDR=:InventoryDR and IA_TotalNum=0 and IA_ProfitNum=0)
	i SQLCODE=100 s SQLCODE=0
	i (SQLCODE'=0)
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	&SQL(Delete from sqluser.DHC_EQInventoryException Where IE_RowID=:IERowID)
	i SQLCODE'=0
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR,StoreLocDR,1)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
ERRORDeleteIE
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Modify by QW20210430 BUG:QW0103
/// 盘点过滤条件信息获取
/// w ##Class(web.DHCEQ.EM.BUSInventory).GetInventoryFilterInfo(11)
ClassMethod GetInventoryFilterInfo(InventoryDR)
{
	s Status="0:"_$p($g(^DHCEQInventory(InventoryDR)),"^",10)
	s FilterInfo=""
	s ConditonName=0
	f  s ConditonName=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditonName)) quit:ConditonName=""  d
	.s ID=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditonName,0))
	.s Value=$p($g(^DHCEQInventoryFilterInfo(ID)),"^",3)
	.s FilterInfo=FilterInfo_ConditonName_":"_Value_"|"
	i FilterInfo="" q Status
	q Status_"|"_FilterInfo
}

/// MZY0115	2469647		2022-03-10
/// 设置取消盘点单过滤设备
/// d ##Class(web.DHCEQ.EM.BUSInventory).SetUncheckEquip(1,10,0)
/// d ##Class(web.DHCEQ.EM.BUSInventory).SetUncheckEquip(1,3,1)
ClassMethod SetUncheckEquip(InventoryDR As %String = "", EquipDR As %String = "", Type As %String = "")
{
	;s ^DHCEQMozy("SetUncheckEquip")=InventoryDR _","_ EquipDR _","_ Type
	i (InventoryDR = "")||(EquipDR = "") q 0
	new UncheckEquipStr,StrLen,i,newStr
	s UncheckEquipStr=$g(^DHCEQInventory(InventoryDR,"UncheckEquipStr"))
	i Type=0
	{
		;	-
		i ","_UncheckEquipStr_","[(","_EquipDR_",")
		{
			s newStr=""
			s StrLen=$l(UncheckEquipStr,",")
			for i=1:1:StrLen
			{
				i ($p(UncheckEquipStr,",",i)'=EquipDR)
				{
					i newStr'="" s newStr=newStr_","
					s newStr=newStr_$p(UncheckEquipStr,",",i)
				}
			}
			s ^DHCEQInventory(InventoryDR,"UncheckEquipStr")=newStr
		}
	}
	else
	{
		;	+
		i UncheckEquipStr'="" s ^DHCEQInventory(InventoryDR,"UncheckEquipStr")=^DHCEQInventory(InventoryDR,"UncheckEquipStr")_","
		s ^DHCEQInventory(InventoryDR,"UncheckEquipStr")=$g(^DHCEQInventory(InventoryDR,"UncheckEquipStr"))_EquipDR
	}
	q 0
}

/// Creator：      MZY0128
/// CreatDate：    2022-6-23
/// Description:   盘点计划名称
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetIPlan","")
Query GetIPlan(Name As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String")
{
}

ClassMethod GetIPlanExecute(ByRef qHandle As %Binary, Name As %String = "") As %Status
{
 	new repid,index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s InventoryPlanDR=0
	f  s InventoryPlanDR=$o(^DHCEQInventoryPlan(InventoryPlanDR)) q:(InventoryPlanDR="")  d
	.s (TRowID,TName)=""
	.s IPInvalidFlag=$p($g(^DHCEQInventoryPlan(InventoryPlanDR)),"^",11)
	.q:IPInvalidFlag="Y"
	.s TName=$p($g(^DHCEQInventoryPlan(InventoryPlanDR)),"^",2)
	.s TRowID=InventoryPlanDR
	.q:(Name'="")&&($ZCONVERT(TName,"U")'[$ZCONVERT(Name,"U"))
	.Set Data=$lb(TRowID,TName)
  	.Set ^CacheTemp(repid,index)=Data
	.Set index=index+1
	
	Quit $$$OK
}

ClassMethod GetIPlanFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPlanExecute ]
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

ClassMethod GetIPlanClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPlanExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      MZY0128
/// CreatDate：    2022-6-23
/// Description:   生成盘点单科室DR
/// 入参:
/// 		InventoryDR		盘点单ID
/// 		OptType			选项科室类型(-1：一级科室    -2：台账科室)
/// w ##Class(web.DHCEQ.EM.BUSInventory).GetLocDRStr(142,-1)
ClassMethod GetLocDRStr(InventoryDR As %String = "", OptType As %String = "")
{
	i $D(^DHCEQInventory(InventoryDR,"BatchOptFlag")) q ""
	s user=##Class(web.DHCEQCommon).getMapIDBySource("user", %session.Get("LOGON.USERID"))
	s locid=##Class(web.DHCEQCommon).getMapIDBySource("dept", %session.Get("LOGON.CTLOCID"))
	s CurGroupID=%session.Get("LOGON.GROUPID")
    Set TempID=$I(^TempDHCEQ("web.DHCEQ.EM.BUSInventory.GetLocDRStr",+$H))
	Do ##Class(web.DHCEQCommon).KillTempGlobalNew("web.DHCEQ.EM.BUSInventory.GetLocDRStr",TempID)
	
	s LocDRStr=""
	s StoreLocDR=$p($g(^DHCEQInventory(InventoryDR)),"^",2)
	s UseLocDR=$p($g(^DHCEQInventory(InventoryDR)),"^",3)
	s EquipTypeIDs=$p($g(^DHCEQInventory(InventoryDR)),"^",4)
	s StatCatDR=$p($g(^DHCEQInventory(InventoryDR)),"^",5)
	s OriginDR=$p($g(^DHCEQInventory(InventoryDR)),"^",6)
	s HospitalDR=$p($g(^DHCEQInventory(InventoryDR)),"^",15)
	s LocIncludeFlag=$p($g(^DHCEQInventory(InventoryDR)),"^",21)
	s EquipTypeIDs=","_EquipTypeIDs_","
	s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")		//增加参数判断盘点是否包含预报废设备
	
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid)) quit:(rowid="")  d
	.Quit:(","_$g(^DHCEQInventory(InventoryDR,"UncheckEquipStr"))_",")[(","_rowid_",")
	.Quit:$Piece($Get(^DHCEQEquip(rowid)),"^",59)'="N"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:((StockStatus=0)||(StockStatus=3))		///尚未入库或已经出库的设备
	.q:$p($g(^DHCEQEquip(rowid)),"^",38)=3		///报废的设备
	.
	.s TEquipTypeDR=","_$p($g(^DHCEQEquip(rowid)),"^",63)_","
	.q:EquipTypeIDs'[TEquipTypeDR
	.q:((StatCatDR'="")&&(StatCatDR'=$p($g(^DHCEQEquip(rowid)),"^",75)))
	.
	.s TBillStoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
	.s THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TBillStoreLocDR)
	.q:(HospitalDR'="")&&(HospitalDR'=THospitalDR)
	.q:((LocIncludeFlag'="Y")&&(StoreLocDR'="")&&(StoreLocDR'=TBillStoreLocDR))
	.q:((LocIncludeFlag="Y")&&(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,TBillStoreLocDR,"1")'="1"))
	.
	.Quit:(##Class(web.DHCEQCommon).CheckManageLimit(user,CurGroupID,"",$p($g(^DHCEQEquip(rowid)),"^",63),$p($g(^DHCEQEquip(rowid)),"^",75),$p($g(^DHCEQEquip(rowid)),"^",4),$p($g(^DHCEQEquip(rowid)),"^",67),rowid,$p($g(^DHCEQEquip(rowid)),"^",7)))
	.;w $p($g(^DHCEQEquip(rowid)),"^",67)_","_locid_"="
	.s Flag=0
	.i ($p($g(^DHCEQEquip(rowid)),"^",67)'="") s Flag=##class(web.DHCEQCommon).LocIsInEQ(0,$p($g(^DHCEQEquip(rowid)),"^",67),locid)
	.q:Flag'=0
	.
	.q:((UseLocDR'="")&&(UseLocDR'=$p($g(^DHCEQEquip(rowid)),"^",19)))
	.q:((OriginDR'="")&&(OriginDR'=$p($g(^DHCEQEquip(rowid)),"^",20)))
	.//增加参数判断盘点是否包含预报废设备
	.Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(rowid)),"^",93)="2")
	.
	.s TEquipName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.s OriginalFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	.s TransassetDate=$p($g(^DHCEQEquip(rowid)),"^",45)
	.s TStartDate=$p($g(^DHCEQEquip(rowid)),"^",44)
	.s InStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
	.i (TransassetDate="")&&(InStockListDR'="")  d
	..s ISRowID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	..i ISRowID'="" s TransassetDate=$p($g(^DHCEQInStock(ISRowID)),13)
	.s TLocationDR=$p($g(^DHCEQEquip(rowid)),"^",72)
	.
	.s (FName,FOriginalFeeS,FOriginalFeeE,FStartDate,FEndDate,FLocationDR)=""
	.s ConditionName=0
	.f  s ConditionName=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditionName)) q:ConditionName=""  d
	..s ID=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditionName,0))
	..s FValue=$p($g(^DHCEQInventoryFilterInfo(ID)),"^",3)
	..i ConditionName="EquipName" s FName=$ZCONVERT(FValue,"U")
	..i ConditionName="OriginalFeeStart" s FOriginalFeeS=FValue
	..i ConditionName="OriginalFeeEnd" s FOriginalFeeE=FValue
	..i (ConditionName="StartDate") s FStartDate=##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")  ; s FStartDate=$ZDH(FValue,4)
	..i (ConditionName="EndDate") s FEndDate=##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")  ; s FEndDate=$ZDH(FValue,4)
	..i (ConditionName="LocationDR")  s FLocationDR=FValue
	.
	.q:(FName'="")&&(TEquipName'[FName)
	.q:(FOriginalFeeS'="")&&(OriginalFee<FOriginalFeeS)
	.q:(FOriginalFeeE'="")&&(OriginalFee>FOriginalFeeE)
	.q:(FStartDate'="")&&(TStartDate<FStartDate)
	.q:(FEndDate'="")&&(TStartDate>FEndDate)
	.q:(FLocationDR'="")&&(TLocationDR'=FLocationDR)
	.
	.;	-1：一级科室    -2：台账科室
	.i OptType=-1 d
	..; ^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",0,1)=""
	..s ParTreeID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",0,""))	;获取一级科室的父节点
	..q:ParTreeID=""
	..s TMID=0
	..f  s TMID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"ParTreeID",ParTreeID,TMID)) quit:(TMID="")  d
	...s TreeID=$p($g(^DHCEQCCode("DHCEQCTreeMap",TMID)),"^",3)
	...i ##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(TreeID,TBillStoreLocDR,1)="1" s TBillStoreLocDR=TreeID
	.
    .Set ^TempDHCEQ("web.DHCEQ.EM.BUSInventory.GetLocDRStr",+$H,TempID,TBillStoreLocDR)=""  ;如未匹配到一级科室则取台账科室
	
	s locid=0
    f  s locid=$o(^TempDHCEQ("web.DHCEQ.EM.BUSInventory.GetLocDRStr",+$H,TempID,locid)) quit:(locid="")  d
	.i LocDRStr'="" s LocDRStr=LocDRStr_","
	.s LocDRStr=LocDRStr_locid	;##Class(web.DHCEQCommon).GetTrakNameByID("dept",locid)
	
	q LocDRStr
}

/// Creator：      MZY0128
/// CreatDate：    2022-6-23
/// Description:   根据选项生成批量盘点单
/// 入参:
/// 		BaseInventoryDR		根盘点单ID
/// 		LocDRStr			科室IDs
/// 		OptType				选项科室类型(-1：一级科室    -2：台账科室)
/// w ##Class(web.DHCEQ.EM.BUSInventory).BatchCreateInventory(1,"1,3,12,104,202",-2,0)
/// w ##Class(web.DHCEQ.EM.BUSInventory).BatchCreateInventory(19,"1,3,12,104,202",-1,0)
/// w ##Class(web.DHCEQ.EM.BUSInventory).BatchCreateInventory(56,"5,8,10,11,13,16,18,19,21,23,28,29,31,33,37,46,47,48,51,52,54,61,62,65,67,68,70,74,77,78,80,81,84,85,86,87,88,93,94,95,101,102,105,109,111,112,116,124,125,127,132,137,138,142,144,146,148,149,150,153,158,161,163,165,167,171,175,177,178,193,197,205,211,213,216,217,219,220,233,242,243,245,247,252,253,256,257,269,270,271,272,273,274,275,277,278,283,284,291,292,293,294,297,304,312,324,327,331,332,333,340,343,344,347,348,352,354,355,357,358,361,362,363,364,365,366,367,368,369,370,371,372,374,377,378,379,381,382,384,406,407,418,423,433,436,446,449,450,452,456,457,460,473,476,481,489,643,652,667,674,683,690,696,879,882,883,906,927,974,975,977,978,979,992,1833,1908,1949,2019",-1)
ClassMethod BatchCreateInventory(BaseInventoryDR As %String = "", LocDRStr As %String = "", OptType As %String = "", QXType As %String = "")
{
	s $ZT="ERRORBatchCreateInventory"
	If BaseInventoryDR="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002,"盘点单设置异常!")
	If LocDRStr="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002,"科室设置异常!")
	
	new SQLCODE,Date,Time,UserDR,lengStr,Count,CountLocDR,InventoryNo,IFIID,ConditionName,Result,JsonObject
	s SQLCODE=0
	s Date=+$H
	s Time=$P($H,",",2)
	s UserDR=##Class(web.DHCEQCommon).getMapIDBySource("user", %session.Get("LOGON.USERID"))
	s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept", %session.Get("LOGON.CTLOCID"))
	s CurGroupID=%session.Get("LOGON.GROUPID")
	

	TSTART
	
	; 更新生成盘点单
	s lengStr=$l(LocDRStr,",")
	for Count=1:1:lengStr q:SQLCODE'=0  d
	.s CountLocDR=$p(LocDRStr,",",Count)
	.
	.i Count=1 d
	..&SQL(Update SQLUSER.DHC_EQInventory Set I_StoreLocDR=:CountLocDR where I_RowID = :BaseInventoryDR)
	..i OptType=-1 &SQL(Update SQLUSER.DHC_EQInventory Set I_LocIncludeFlag='Y' where I_RowID = :BaseInventoryDR)
	.e  d
	..s InventoryNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInventory",+$H)
	..&SQL(Insert Into sqluser.DHC_EQInventory(I_InventoryNo, I_StoreLocDR, I_EquipTypeIDs, I_Date, I_Time, I_UserDR, I_Status, I_ManageLocDR, I_HospitalDR, I_ExpectDate, I_SelfFlag, I_LocIncludeFlag, I_Hold6) SELECT :InventoryNo, :CountLocDR, I_EquipTypeIDs, :Date, :Time, :UserDR, '0', I_ManageLocDR, I_HospitalDR, I_ExpectDate, I_SelfFlag, I_LocIncludeFlag, I_Hold6 FROM sqluser.DHC_EQInventory Where I_RowID = :BaseInventoryDR)
	.q:SQLCODE'=0
	.s NewInventoryDR=$G(%ROWID)
	.
	.;插入过滤条件(新盘点单)
	.i NewInventoryDR'=BaseInventoryDR d
	..k IFI
	..s IFI(2)=NewInventoryDR
	..s ConditionName=""
	..f  s ConditionName=$o(^DHCEQInventoryFilterInfo(0,"Inventory",BaseInventoryDR,ConditionName)) quit:(ConditionName="")||(SQLCODE'=0)  d
	...s IFI(3)=ConditionName
	...s IFIID=0
	...f  s IFIID=$o(^DHCEQInventoryFilterInfo(0,"Inventory",BaseInventoryDR,ConditionName,IFIID)) quit:(IFIID="")||(SQLCODE'=0)  d
	....s IFI(4)=$p($g(^DHCEQInventoryFilterInfo(IFIID)),"^",3)
	....&SQL(Insert into sqluser.DHC_EQInventoryFilterInfo values :IFI())
	..i $D(^DHCEQInventory(BaseInventoryDR,"UncheckEquipStr")) s ^DHCEQInventory(NewInventoryDR,"UncheckEquipStr")=^DHCEQInventory(BaseInventoryDR,"UncheckEquipStr")	;过滤设备
	.q:SQLCODE'=0
	.
	.s ^DHCEQInventory(NewInventoryDR,"BatchOptFlag",OptType)=BaseInventoryDR	;批量标识
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	
	; 冻结盘点单
	s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")		//增加参数判断盘点是否包含预报废设备
	; ^DHCEQEquip(0,"StoreEquipType",{EQ_InvalidFlag},{EQ_StockStatus},{EQ_StoreLocDR},{EQ_EquipTypeDR},{EQ_RowID})
	; ^DHCEQEquip(0,"StoreEquipType","N",3,107,2,21)=""
	s StockStatus=0
	f  s StockStatus=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus)) quit:(StockStatus="")||(SQLCODE'=0)  d
	.q:(StockStatus=0)||(StockStatus=3)		//尚未入库或已经出库的设备
	.s TBillStoreLocDR=0
	.f  s TBillStoreLocDR=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,TBillStoreLocDR)) quit:(TBillStoreLocDR="")||(SQLCODE'=0)  d
	..q:##class(web.DHCEQCommon).LocIsInEQ(QXType,TBillStoreLocDR,CurLocDR)'=0
	..s THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TBillStoreLocDR)
	..s TEquipTypeDR=0
	..f  s TEquipTypeDR=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,TBillStoreLocDR,TEquipTypeDR)) quit:(TEquipTypeDR="")||(SQLCODE'=0)  d
	...; 获取计划关联盘点单
	...s RowID=""
	...s NewInventoryDR=0
	...f  s NewInventoryDR=$o(^DHCEQInventory(NewInventoryDR)) q:(NewInventoryDR="")||(RowID'="")  d
	....q:$g(^DHCEQInventory(NewInventoryDR,"BatchOptFlag",OptType))'=BaseInventoryDR
	....s IStoreLocDR=$p($g(^DHCEQInventory(NewInventoryDR)),"^",2)
	....s LocIncludeFlag=$p($g(^DHCEQInventory(NewInventoryDR)),"^",21)
	....q:((LocIncludeFlag'="Y")&&(IStoreLocDR'="")&&(IStoreLocDR'=TBillStoreLocDR))
	....q:((LocIncludeFlag="Y")&&(IStoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(IStoreLocDR,TBillStoreLocDR,"1")'="1"))
	....s EquipTypeIDs=$p($g(^DHCEQInventory(NewInventoryDR)),"^",4)
	....q:(","_EquipTypeIDs_",")'[(","_TEquipTypeDR_",")
	....s HospitalDR=$p($g(^DHCEQInventory(NewInventoryDR)),"^",15)
	....q:(HospitalDR'="")&&(HospitalDR'=THospitalDR)
	....s RowID=NewInventoryDR
	...q:RowID=""
	...
	...k PLIST
	...s PLIST(2)=RowID
	...s eqrowid=0
	...f  s eqrowid=$o(^DHCEQEquip(0,"StoreEquipType","N",StockStatus,TBillStoreLocDR,TEquipTypeDR,eqrowid)) quit:(eqrowid="")||(SQLCODE'=0)  d
	....q:$p($g(^DHCEQEquip(eqrowid)),"^",38)=3		///报废的设备
	....q:(($p($g(^DHCEQInventory(RowID)),"^",5)'="")&&($p($g(^DHCEQInventory(RowID)),"^",5)'=$p($g(^DHCEQEquip(eqrowid)),"^",75)))
	....q:(##Class(web.DHCEQCommon).CheckManageLimit(UserDR,CurGroupID,"",$p($g(^DHCEQEquip(eqrowid)),"^",63),$p($g(^DHCEQEquip(eqrowid)),"^",75),$p($g(^DHCEQEquip(eqrowid)),"^",4),$p($g(^DHCEQEquip(eqrowid)),"^",67),eqrowid,$p($g(^DHCEQEquip(eqrowid)),"^",7)))
	....q:(($p($g(^DHCEQInventory(RowID)),"^",3)'="")&&($p($g(^DHCEQInventory(RowID)),"^",3)'=$p($g(^DHCEQEquip(eqrowid)),"^",19)))
	....q:(($p($g(^DHCEQInventory(RowID)),"^",6)'="")&&($p($g(^DHCEQInventory(RowID)),"^",6)'=$p($g(^DHCEQEquip(eqrowid)),"^",20)))
	....
	....//增加参数判断盘点是否包含预报废设备
	....q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(eqrowid)),"^",93)="2")
	....s PLIST(3)=eqrowid								///BillEquipDR
	....s PLIST(5)=$p($g(^DHCEQEquip(eqrowid)),"^",67)	///StoreLocDR
	....s PLIST(6)=$p($g(^DHCEQEquip(eqrowid)),"^",19)	///UseLocDR
	....s PLIST(9)=+$p($g(^DHCEQEquip(eqrowid)),"^",27)	///OriginalFee
	....s PLIST(10)=+$p($g(^DHCEQEquip(eqrowid)),"^",28)	///NetFee
	....s PLIST(11)=+$p($g(^DHCEQEquip(eqrowid)),"^",35)	///DepreTotalFee
	....
	....s TEquipName=$p($g(^DHCEQEquip(eqrowid)),"^",1)
	....s OriginalFee=$p($g(^DHCEQEquip(eqrowid)),"^",27)
	....s TransassetDate=$p($g(^DHCEQEquip(eqrowid)),"^",45)
	....s InStockListDR=$p($g(^DHCEQEquip(eqrowid)),"^",70)
	....i (TransassetDate="")&&(InStockListDR'="") d
	.....s ISRowID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	.....s TransassetDate=$p($g(^DHCEQInStock(+ISRowID)),13)
	....s TLocationDR=$p($g(^DHCEQEquip(eqrowid)),"^",72)
	....s (FName,FOriginalFeeS,FOriginalFeeE,FStartDate,FEndDate,FLocationDR)=""
	....s ConditionName=0
	....f  s ConditionName=$o(^DHCEQInventoryFilterInfo(0,"Inventory",RowID,ConditionName)) q:ConditionName=""  d
	.....s ID=$o(^DHCEQInventoryFilterInfo(0,"Inventory",RowID,ConditionName,0))
	.....s FValue=$p($g(^DHCEQInventoryFilterInfo(ID)),"^",3)
	.....i ConditionName="EquipName" s FName=$ZCONVERT(FValue,"U")
	.....i ConditionName="OriginalFeeStart" s FOriginalFeeS=FValue
	.....i ConditionName="OriginalFeeEnd" s FOriginalFeeE=FValue
	.....i (ConditionName="StartDate") s FStartDate=##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")  ; s FStartDate=$ZDH(FValue,4)
	.....i (ConditionName="EndDate") s FEndDate=##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")  ; s FEndDate=$ZDH(FValue,4)
	.....i (ConditionName="LocationDR")  s FLocationDR=FValue
	....q:(FName'="")&&(TEquipName'[FName)
	....q:(FOriginalFeeS'="")&&(OriginalFee<FOriginalFeeS)
	....q:(FOriginalFeeE'="")&&(OriginalFee>FOriginalFeeE)
	....q:(FStartDate'="")&&(TransassetDate<FStartDate)
	....q:(FEndDate'="")&&(TransassetDate>FEndDate)
	....q:(FLocationDR'="")&&(TLocationDR'=FLocationDR)
	....&SQL(Insert into sqluser.DHC_EQInventoryList values :PLIST())
	i SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	s NewInventoryDR=0
	f  s NewInventoryDR=$o(^DHCEQInventory(NewInventoryDR)) q:(NewInventoryDR="")||(SQLCODE'=0)  d
	.q:$g(^DHCEQInventory(NewInventoryDR,"BatchOptFlag",OptType))'=BaseInventoryDR
	.&SQL(Update sqluser.DHC_EQInventory Set I_Status=1,I_ManageLocDR=:CurLocDR,I_FreezeDate=:Date,I_FreezeTime=:Time,I_FreezeUser=:UserDR where I_RowID=:NewInventoryDR)
	.q:SQLCODE
	.s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(NewInventoryDR)
	i SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,BaseInventoryDR)
ERRORBatchCreateInventory
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 目的:系统自动录入存放地点
/// 描述:检测存放地点表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: data:存放地点
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// w ##Class(web.DHCEQ.EM.BUSInventory).UpdInventoryPlan("2022年上半年盘点计划")
ClassMethod UpdInventoryPlan(desc)
{
	Set IPRowID=""
	Set desc=$ZCONVERT(desc,"U")
	Set SQLCODE=0

	&SQL(Select IP_RowID Into :IPRowID from SQLUSER.DHC_EQInventoryPlan Where IP_InvalidFlag='N' and IP_Desc=:desc)
	if IPRowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQInventoryPlan(IP_Desc,IP_InvalidFlag) Values(:desc,'N'))
		if SQLCODE
		{
			Quit SQLCODE
		}
		Set IPRowID=$Get(%ROWID)
	}
	Quit IPRowID
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).CheckEquipIsInInventoryPlan(2,"LS2022000001",1)
ClassMethod CheckEquipIsInInventoryPlan(InventoryDR, EquipNo, EquipFlag As %String = "0")
{
	s Flag=0
	s EquipDR=##Class(web.DHCEQEquip).GetEquipIDByNo(EquipNo)
	i EquipDR'="" d
	.s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	.s EquipTypeIds=$p($g(^DHCEQInventory(InventoryDR)),"^",4)
	.i ((","_EquipTypeIds_",")'[(","_EquipTypeDR_",")) s Flag="-1505"
	.q:Flag'=0
	.i $d(^DHCEQInventoryList(0,"BillEquip",InventoryDR,EquipDR)) s Flag="-1506"
	.q:Flag'=0
	.s InventoryPlanDR=$p($g(^DHCEQInventory(InventoryDR)),"^",22)
	.q:InventoryPlanDR=""
	.s NewInventoryDR=0
	.f  s NewInventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",InventoryPlanDR,NewInventoryDR)) quit:(NewInventoryDR="")||(Flag'=0)  d
	..q:NewInventoryDR=InventoryDR
	..q:'$d(^DHCEQInventoryList(0,"BillEquip",NewInventoryDR,EquipDR)) 
	..s Flag="-1507"
	e  d
	.s Flag=##Class(web.DHCEQ.EM.BUSInventory).GetIERowIDByInventoryDR(EquipNo)

	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(Flag)
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).GetIERowIDByInventoryDR("2010105000003")
ClassMethod GetIERowIDByInventoryDR(EquipNo)
{
	s vFlag=0
	s rowid=0
	f  s rowid=$o(^DHCEQInventoryException(0,"EquipNo",EquipNo,rowid))  quit:(rowid="")||(vFlag'=0)  d
	.s vFlag="-1508"
	q vFlag
}

/// modify by lmm 2018-11-06  入参名称更改 valName->ValName
/// /// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetProfitReason","")
Query GetProfitReason(ValName) As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetProfitReasonExecute(ByRef qHandle As %Binary, ValName) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCProfitReason",rowid))  quit:rowid=""  d
	.d ResetVariablesGetProfitReasonList
	.s RowID = rowid
	.s Flag = $p($g(^DHCEQCCode("DHCEQCProfitReason",rowid)),"^",4)
	.q:Flag="Y"
	.s Name = $p($g(^DHCEQCCode("DHCEQCProfitReason",rowid)),"^",2)
	.s Code=$p($g(^DHCEQCCode("DHCEQCProfitReason",rowid)),"^",1)
	.q:(ValName'="")&&(($ZCONVERT(Name ,"U")'[$ZCONVERT(ValName,"U"))&&($ZCONVERT(Code,"U")'[$ZCONVERT(ValName,"U")))
	.d OutputRowGetProfitReasonList
	Quit $$$OK
OutputRowGetProfitReasonList
	Set Data=$lb(Name,RowID,Code)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetProfitReasonList
	s (Name,RowID,Code)=""
	quit
}

ClassMethod GetProfitReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetProfitReasonExecute ]
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

ClassMethod GetProfitReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetProfitReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modify by lmm 2018-11-06  入参名称更改 valName->ValName
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetLossReason","")
Query GetLossReason(ValName) As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetLossReasonExecute(ByRef qHandle As %Binary, ValName) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCLossReason",rowid))  quit:rowid=""  d
	.d ResetVariablesGetLossReasonList
	.s RowID = rowid
	.s Flag = $p($g(^DHCEQCCode("DHCEQCLossReason",rowid)),"^",4)
	.q:Flag="Y"
	.s Name = $p($g(^DHCEQCCode("DHCEQCLossReason",rowid)),"^",2)
	.s Code=$p($g(^DHCEQCCode("DHCEQCLossReason",rowid)),"^",1)
	.q:(ValName'="")&&(($ZCONVERT(Name ,"U")'[$ZCONVERT(ValName,"U"))&&($ZCONVERT(Code,"U")'[$ZCONVERT(ValName,"U")))
	.d OutputRowGetLossReasonList
	Quit $$$OK
OutputRowGetLossReasonList
	Set Data=$lb(Name,RowID,Code)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetLossReasonList
	s (Name,RowID,Code)=""
	quit
}

ClassMethod GetLossReasonFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLossReasonExecute ]
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

ClassMethod GetLossReasonClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLossReasonExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).CheckInventoryPlanResultType(2,11128)
ClassMethod CheckInventoryPlanResultType(InventoryDR, EquipDR)
{
	s vFlag=3
	s vInventoryListDR=""
	s InventoryPlanDR=$p($g(^DHCEQInventory(InventoryDR)),"^",22)
	i InventoryPlanDR="" q 3_"^"_vInventoryListDR
	s NewInventoryDR=0
	f  s NewInventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",InventoryPlanDR,NewInventoryDR)) quit:(NewInventoryDR="")||(vFlag'=3)  d
	.q:NewInventoryDR=InventoryDR
	.q:'$d(^DHCEQInventoryList(0,"BillEquip",NewInventoryDR,EquipDR))
	.s vInventoryListDR=$o(^DHCEQInventoryList(0,"BillEquip",NewInventoryDR,EquipDR,0)) 
	.i $p($g(^DHCEQInventoryList(vInventoryListDR)),"^",14)="" d
	..s vFlag=5
	.e  d
	..s vFlag=6
	q vFlag_"^"_vInventoryListDR
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).CheckInventoryLocStatus(1,213)
ClassMethod CheckInventoryLocStatus(vInventoryDR, vStoreLocDR)
{
	s RFlag=0
	i (vInventoryDR="")||(vStoreLocDR="") q RFlag
	s IARowID=0
	f  s IARowID=$o(^DHCEQInventoryAudit(0,"Inventory",vInventoryDR,vStoreLocDR,IARowID))  quit:(IARowID="")||(RFlag'=0)  d
	.q:$p($g(^DHCEQInventoryAudit(IARowID)),"^",8)'=2
	.s RFlag=1
	q RFlag
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).GetEquipInfoByEquipNo("2400699060011998120002")
ClassMethod GetEquipInfoByEquipNo(EquipNo)
{
	s EquipDR = $Order(^DHCEQEquip(0,"No",EquipNo,0))
	i EquipDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1501")
	s IExceptionInfo=##class(web.DHCEQ.Plat.JsonObject).%New()
	d IExceptionInfo.%Set("IEActerEquipDR",EquipDR)
	d IExceptionInfo.%Set("IEEquipName",$p($g(^DHCEQEquip(EquipDR)),"^",1))
	d IExceptionInfo.%Set("IEEquipNo", $p($g(^DHCEQEquip(EquipDR)),"^",71))
	d IExceptionInfo.%Set("IEOriginalFee", ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EquipDR)),"^",27),""))
	d IExceptionInfo.%Set("IEModel", ##class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(EquipDR)),"^",3)))
	d IExceptionInfo.%Set("IEStartDate", ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipDR)),"^",44),"date"))
	d IExceptionInfo.%Set("IETransAssetDate", ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipDR)),"^",45),"date"))
	d IExceptionInfo.%Set("IEUserLocDR", $p($g(^DHCEQEquip(EquipDR)),"^",19))
	d IExceptionInfo.%Set("IEUserLocDR_CTLOCDesc", $p($g(^DHCEQEquip(EquipDR)),"^",19))
	d IExceptionInfo.%Set("IEStoreLocDR", $p($g(^DHCEQEquip(EquipDR)),"^",67))
	d IExceptionInfo.%Set("IEStoreLocDR_CTLOCDesc", ##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQEquip(EquipDR)),"^",67)))
	d IExceptionInfo.%Set("IEManuFactoryDR", $p($g(^DHCEQEquip(EquipDR)),"^",26))
	d IExceptionInfo.%Set("IEProviderDR", $p($g(^DHCEQEquip(EquipDR)),"^",25))
	d IExceptionInfo.%Set("IEProviderDR_VDesc", ##class(web.DHCEQCommon).GetTrakNameByID("prov",$p($g(^DHCEQEquip(EquipDR)),"^",25)))
	d IExceptionInfo.%Set("IEManuFactoryDR_MFDesc", ##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p($g(^DHCEQEquip(EquipDR)),"^",26)))
	//d IExceptionInfo.%Set("IELocationDR", $p($g(^DHCEQEquip(EquipDR)),"^",72))
	d IExceptionInfo.%Set("IEEquipTypeDR", $p($g(^DHCEQEquip(EquipDR)),"^",63))
	d IExceptionInfo.%Set("IEEquipTypeDR_ETDesc", ##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p($g(^DHCEQEquip(EquipDR)),"^",63)))
	d IExceptionInfo.%Set("IEBrand", ##class(web.DHCEQCommon).GetTrakNameByID("brand",$p($g(^DHCEQEquip(EquipDR)),"^",93)))
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, IExceptionInfo)
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).GetTopLocDR("423")
ClassMethod GetTopLocDR(LocDR)
{
	s TreeID=$o(^DHCEQCCode("DHCEQCTreeMap",0,"TreeID","1",LocDR,0))

	if TreeID="" q LocDR
	f  s ParTreeID=##Class(web.DHCEQCTreeMap).GetOldParTree(TreeID) quit:(ParTreeID=1)  d
	.s TreeID=ParTreeID

	Q $p($g(^DHCEQCCode("DHCEQCTreeMap",TreeID)),"^",3)
}

/// Creator：      MZY
/// CreatDate：    2022-8-11
/// Description:   获取盘点计划或盘点单汇总信息
/// w ##Class(web.DHCEQ.EM.BUSInventory).GetInventoryInfo(17)
/// w ##Class(web.DHCEQ.EM.BUSInventory).GetInventoryInfo("",218)
ClassMethod GetInventoryInfo(InventoryPlanDR As %String = "", InventoryDR As %String = "")
{
	i (InventoryPlanDR="")&&(InventoryDR="") Quit ""
	s (PLabel,PCaption,ExpectDate,ManageLoc,HOSP,EquipTypeDesc,EquipTypeTitle,FreezeDate)=""
	s (Count,TotalNum,NotInventoryNum,InventoryNum,InventoryLocNum,ConsistentNum,UnCheckLocNum,DisUseNum,LoseNum,FindNum,ProfitNum)=0
	;s ^DHCEQMozy("GetInventoryInfo")=InventoryPlanDR_","_InventoryDR
	
	i InventoryPlanDR=""
	{
		s PLabel="盘点单号："
		s PCaption=$p($g(^DHCEQInventory(InventoryDR)),"^",1)
		s ExpectDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInventory(InventoryDR)),"^",16),"date")
		s ManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQInventory(InventoryDR)),"^",14))
		s HOSP=$p($g(^CT("HOSP", +$p($g(^DHCEQInventory(InventoryDR)),"^",15))),"^",2)
		s EquipTypeIDs=$p($g(^DHCEQInventory(InventoryDR)),"^",4)
		s EquipTypeDesc=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",+EquipTypeIDs)
		s Count=$l(EquipTypeIDs,",")
		for i=1:1:Count
		{
			i (","_EquipTypeTitle_",")'[(","_##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p(EquipTypeIDs,",",i))_",")
			{
				i EquipTypeTitle'="" s EquipTypeTitle=EquipTypeTitle_","
				s EquipTypeTitle=EquipTypeTitle_##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p(EquipTypeIDs,",",i))
			}
		}
		s FreezeDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInventory(InventoryDR)),"^",17),"date")_" "_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInventory(InventoryDR)),"^",18),"time")
		s vStoreLocID=0
		f  s vStoreLocID=$o(^DHCEQInventoryAudit(0,"Inventory",InventoryDR,vStoreLocID)) q:vStoreLocID=""  d
		.s vIARowID=$o(^DHCEQInventoryAudit(0,"Inventory",InventoryDR,vStoreLocID,0))
		.q:vIARowID=""
		.s TotalNum=TotalNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",3)
		.s ProfitNum=ProfitNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",5)
		.s LoseNum=LoseNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",6)
		.s NotInventoryNum=NotInventoryNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",7)
		.s InventoryLocNum=1+InventoryLocNum
		.s ConsistentNum=ConsistentNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",10)
		.s UnCheckLocNum=UnCheckLocNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",11)
		.s FindNum=FindNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",12)
		.s DisUseNum=DisUseNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",13)
		s InventoryNum=1
	}
	else
	{
		s PLabel="计划名称："
		s PCaption=$p($g(^DHCEQInventoryPlan(InventoryPlanDR)),"^",2)
		s ExpectDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInventoryPlan(InventoryPlanDR)),"^",5),"date")
		;^DHCEQInventory(0,"InventoryPlan",1,218)=""
		s InventoryDR=0
		f  s InventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",InventoryPlanDR,InventoryDR)) quit:(InventoryDR="")  d
		.i ManageLoc="" s ManageLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQInventory(InventoryDR)),"^",14))
		.i HOSP="" s HOSP=$p($g(^CT("HOSP", +$p($g(^DHCEQInventory(InventoryDR)),"^",15))),"^",2)
		.i EquipTypeDesc="" d
		..s EquipTypeIDs=$p($g(^DHCEQInventory(InventoryDR)),"^",4)
		..i EquipTypeDesc="" s EquipTypeDesc=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",+EquipTypeIDs)
		..i $l(EquipTypeIDs,",")>Count s Count=$l(EquipTypeIDs,",")
		..for i=1:1:Count d
		...q:(","_EquipTypeTitle_",")[(","_##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p(EquipTypeIDs,",",i))_",")
		...i EquipTypeTitle'="" s EquipTypeTitle=EquipTypeTitle_","
		...s EquipTypeTitle=EquipTypeTitle_##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p(EquipTypeIDs,",",i))
		.i FreezeDate="" s FreezeDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInventory(InventoryDR)),"^",17),"date")_" "_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInventory(InventoryDR)),"^",18),"time")
		.s vStoreLocID=0
		.f  s vStoreLocID=$o(^DHCEQInventoryAudit(0,"Inventory",InventoryDR,vStoreLocID)) q:vStoreLocID=""  d
		..s vIARowID=$o(^DHCEQInventoryAudit(0,"Inventory",InventoryDR,vStoreLocID,0))
		..q:vIARowID=""
		..s TotalNum=TotalNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",3)
		..s InventoryLocNum=1+InventoryLocNum
		..s ProfitNum=ProfitNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",5)
		..s LoseNum=LoseNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",6)
		..s NotInventoryNum=NotInventoryNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",7)
		..s ConsistentNum=ConsistentNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",10)
		..s UnCheckLocNum=UnCheckLocNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",11)
		..s FindNum=FindNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",12)
		..s DisUseNum=DisUseNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",13)
		.s InventoryNum=1+InventoryNum
	}
	i Count>1 s EquipTypeDesc=EquipTypeDesc_"..."
	
	q PLabel_"^"_PCaption_"^"_ExpectDate_"^"_ManageLoc_"^"_HOSP_"^"_EquipTypeDesc_"^"_FreezeDate_"^"_InventoryNum_"^"_InventoryLocNum_"^"_TotalNum_"^"_NotInventoryNum_"^"_ConsistentNum_"^"_UnCheckLocNum_"^"_DisUseNum_"^"_LoseNum_"^"_FindNum_"^"_ProfitNum_"^"_EquipTypeTitle
}

/// Creator：      Mozy
/// CreatDate：    2022-8-12
/// Description:   盘点设备状态
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetDisposeStatus")
Query GetDisposeStatus() As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetDisposeStatusExecute(ByRef qHandle As %Binary) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	s rowid=1
	s Code="01"
	s Desc="账物一致"
	d OutputRowGetDisposeStatus
	s rowid=2
	s Code="02"
	s Desc="科室不符"
	d OutputRowGetStatusList
	s rowid=3
	s Code="03"
	s Desc="盘亏"
	d OutputRowGetStatusList
	s rowid=4
	s Code="04"
	s Desc="待查找"
	d OutputRowGetStatusList
	s rowid=5
	s Code="05"
	s Desc="有报废单"
	d OutputRowGetStatusList
	s rowid=6
	s Code="06"
	s Desc="盘盈"
	d OutputRowGetStatusList
	s rowid=7
	s Code="07"
	s Desc="计划外科室不符"
	d OutputRowGetStatusList
	Quit $$$OK
OutputRowGetDisposeStatus
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetDisposeStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDisposeStatusExecute ]
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

ClassMethod GetDisposeStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDisposeStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      MZY
/// CreatDate：    2022-8-11
/// Description:   盘点计划明细
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetIPlanList","",218)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetIPlanList",43,218,"",43)
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetIPlanList","",1,"",222)17,213,,,0,
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetIPlanList",17,213,"","",0)
/// Modfied by zc0125 2022-12-5 增加输出
Query GetIPlanList(pInventoryPlanDR As %String = "", pInventoryDR As %String = "", pEquipTypeIDs As %String = "", pStoreLocDR As %String = "", pStatus As %String = "", pDisposeStatus As %String = "", pEQNo As %String = "", pEQName As %String = "") As %Query(ROWSPEC = "TRow:%String,TInventoryPlanDR:%String,TInventoryDR:%String,TInventoryListDR:%String,TBillEquipDR:%String,TPDesc:%String,TBillEquipDR_No:%String,TBillEquipDR_Name:%String,TModel:%String,TEquipType:%String,TBillStoreLocDR:%String,TActerStoreLocDR:%String,TBillStoreLoc:%String,TActerStoreLoc:%String,TStatus_Display:%String,TCondition_Display:%String,TUseStatus:%String,TDisposeStatus:%String,TDisposeResult:%String,TEquipTypeDR:%String,ILDisposeStatusID:%String,ILDisposeResultID:%String,TBussType:%String,TBussID:%String")
{
}

ClassMethod GetIPlanListExecute(ByRef qHandle As %Binary, pInventoryPlanDR As %String = "", pInventoryDR As %String = "", pEquipTypeIDs As %String = "", pStoreLocDR As %String = "", pStatus As %String = "", pDisposeStatus As %String = "", pEQNo As %String = "", pEQName As %String = "") As %Status
{
 	new repid,index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("GetIPlanList")=pInventoryPlanDR _","_ pInventoryDR _","_ pEquipTypeIDs _","_ pStoreLocDR _","_ pStatus _","_ pDisposeStatus
 	i (pInventoryPlanDR="")&&(pInventoryDR="") Quit $$$OK
	i (pInventoryPlanDR'="")&&($p($g(^DHCEQInventoryPlan(pInventoryPlanDR)),"^",11)="Y") Quit $$$OK
	i pInventoryPlanDR'="" s pInventoryDR=""
	
	s index=1
	s TRow=0
	s InventoryDR=0
	f  s InventoryDR=$o(^DHCEQInventory(InventoryDR)) quit:(InventoryDR="")  d
	.q:(pInventoryDR'="")&&(InventoryDR'=pInventoryDR)
	.q:(pInventoryPlanDR'="")&&($p($g(^DHCEQInventory(InventoryDR)),"^",22)'=pInventoryPlanDR)
	.;q:(pStoreLocDR'="")&&($p($g(^DHCEQInventory(InventoryDR)),"^",2)'=pStoreLocDR)
	.s TInventoryDR=InventoryDR
	.i $p($g(^DHCEQInventory(InventoryDR)),"^",22)'="" s TPDesc=$p($g(^DHCEQInventoryPlan($p($g(^DHCEQInventory(InventoryDR)),"^",22))),"^",2)   //Modefied by zc0125 修正不能存在计划单不显示设备清单
	.
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",TInventoryDR,rowid)) quit:(rowid="")  d
	..q:(pEquipTypeIDs'="")&&((","_pEquipTypeIDs_",")'[(","_$p($g(^DHCEQEquip($p($g(^DHCEQInventoryList(rowid)),"^",2))),"^",63)_","))
	..q:(pDisposeStatus'="")&&($p($g(^DHCEQInventoryList(rowid)),"^",28)'=pDisposeStatus)
	..
	..d ResetVarGetIPlanList
	..s TInventoryListDR=rowid
	..s TBillEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
	..s TBillEquipDRNo=$p($g(^DHCEQEquip(TBillEquipDR)),"^",71)
	..s TBillEquipDRName=$p($g(^DHCEQEquip(TBillEquipDR)),"^",1)
	..// MZY0137	2981128,2981133		2022-10-08	增加编号和名称条件
	..q:(pEQNo'="")&&(TBillEquipDRNo'[pEQNo)
	..q:(pEQName'="")&&(TBillEquipDRName'[pEQName)
	..s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(TBillEquipDR)),"^",3))
	..s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p($g(^DHCEQEquip(TBillEquipDR)),"^",63))
	..s TBillStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",4)
	..q:(pStoreLocDR'="")&&(TBillStoreLocDR'=pStoreLocDR)
	..s TActerStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",6)
	..s TBillStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillStoreLocDR)
	..s TActerStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerStoreLocDR)
	..s TStatus=$p($g(^DHCEQInventoryList(rowid)),"^",14)
	..q:(pStatus'="")&&(+TStatus'=pStatus)
	..s TStatusDisplay=$CASE(TStatus,"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","":"")
	..s ILCondition=$p($g(^DHCEQInventoryList(rowid)),"^",21)
	..s TConditionDisplay=$CASE(ILCondition,"0":"完好","1":"待报废","2":"有缺损","3":"盘亏","":"")
	..s LIUseStatus=$p($g(^DHCEQInventoryList(rowid)),"^",25)
	..s TUseStatus=$CASE(LIUseStatus,"1":"在用","2":"拆封未使用","3":"未拆封","4":"积压闲置","5":"已盘亏","":"")
	..s ILDisposeStatus=$p($g(^DHCEQInventoryList(rowid)),"^",28)
	..q:(pDisposeStatus'="")&&(pDisposeStatus'=ILDisposeStatus)
	..s ILDisposeStatusID=ILDisposeStatus   //Modfied by zc0125 2022-12-5 增加输出
	..s TDisposeStatus=$CASE(ILDisposeStatus,"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","6":"盘盈","7":"计划外科室不符","":"")
	..s ILDisposeResult=$p($g(^DHCEQInventoryList(rowid)),"^",29)
	..s ILDisposeResultID=ILDisposeResult	//Modfied by zc0125 2022-12-5 增加输出
	..s TDisposeResult=$CASE(ILDisposeResult,"1":"账物一致","2":"盘盈入库","3":"科室不符已转科","4":"科室不符不处理","5":"盘亏已减少","6":"报废","":"")
	..; TDisposeOpt	TOpt
	..s TEquipTypeDR=$p($g(^DHCEQEquip(TBillEquipDR)),"^",63)  	//Modfied by zc0125 2022-12-5 增加输出 begin
	..s TBussType=$p($g(^DHCEQInventoryList(rowid)),"^",23)		
	..s TBussID=$p($g(^DHCEQInventoryList(rowid)),"^",24)		//Modfied by zc0125 2022-12-5 增加输出 end
  	..d OutputRowGetIPlanList
	
	Quit $$$OK
OutputRowGetIPlanList
	Set TRow=TRow+1
	Set Data=$lb(TRow,TInventoryPlanDR,TInventoryDR,TInventoryListDR,TBillEquipDR,TPDesc,TBillEquipDRNo,TBillEquipDRName,TModel,TEquipType,TBillStoreLocDR,TActerStoreLocDR,TBillStoreLoc,TActerStoreLoc,TStatusDisplay,TConditionDisplay,TUseStatus,TDisposeStatus,TDisposeResult,TEquipTypeDR,ILDisposeStatusID,ILDisposeResultID,TBussType,TBussID)  //Modfied by zc0125 2022-12-5 增加输出
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	Quit
	
ResetVarGetIPlanList
	Set (TInventoryListDR,TBillEquipDR,TBillEquipDRNo,TBillEquipDRName,TModel,TEquipType,TBillStoreLocDR,TActerStoreLocDR,TBillStoreLoc,TActerStoreLoc,TStatusDisplay,TConditionDisplay,TUseStatus,TDisposeStatus,TDisposeResult,TEquipTypeDR,ILDisposeStatusID,ILDisposeResultID,TBussType,TBussID)=""  //Modfied by zc0125 2022-12-5 增加输出
	Quit
}

ClassMethod GetIPlanListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPlanListExecute ]
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

ClassMethod GetIPlanListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPlanListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      MZY
/// CreatDate：    2022-8-11
/// Description:   计划盘点单汇总
/// 输入: InventoryPlanDR-盘点计划	InventoryDR-盘点单	FilterType-盘点汇总方式(0:按盘点状态汇总,1:按处置状态汇总,2:按处置结果汇总)
/// 输出: 记录列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","GetIPlanSummary","",218,1)
Query GetIPlanSummary(pInventoryPlanDR As %String = "", pInventoryDR As %String = "", pFilterType As %String = "", pDisposeStatus As %String = "") As %Query(ROWSPEC = "TRow:%String,TInventoryDR:%String,TPDesc,TInventoryNo:%String,TBillStoreLoc:%String,TDate:%String,TTime:%String,TStatus_Display:%String,TCompleteDate:%String,TTotalNum:%String,TConsistentNum:%String,TDiffeNum:%String,TUnCheckLocNum:%String,TLoseNum:%String,TFindNum:%String,TDisUseNum:%String,TNotInventoryNum:%String,TProfitNum:%String")
{
}

ClassMethod GetIPlanSummaryExecute(ByRef qHandle As %Binary, pInventoryPlanDR As %String = "", pInventoryDR As %String = "", pFilterType As %String = "", pDisposeStatus As %String = "") As %Status
{
 	new repid,index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("GetIPlanSummary")=pInventoryPlanDR _","_ pInventoryDR _","_ pFilterType_","_pDisposeStatus
 	i (pInventoryPlanDR="")&&(pInventoryDR="") Quit $$$OK
	i (pInventoryPlanDR'="")&&($p($g(^DHCEQInventoryPlan(pInventoryPlanDR)),"^",11)="Y") Quit $$$OK
	i pInventoryPlanDR'="" s pInventoryDR=""
	
	s index=1
	s TRow=0
	s InventoryDR=0
	f  s InventoryDR=$o(^DHCEQInventory(InventoryDR)) quit:(InventoryDR="")  d
	.q:(pInventoryDR'="")&&(InventoryDR'=pInventoryDR)
	.q:(pInventoryPlanDR'="")&&($p($g(^DHCEQInventory(InventoryDR)),"^",22)'=pInventoryPlanDR)
	.d ResetVarGetIPlanSummary
	.s TInventoryDR=InventoryDR
	.i $p($g(^DHCEQInventory(InventoryDR)),"^",22)'="" s TPDesc=$p($g(^DHCEQInventoryPlan($p($g(^DHCEQInventory(InventoryDR)),"^",22))),"^",2)	// MZY0150	3195692,3199935		2023-01-29
	.s TInventoryNo=$p($g(^DHCEQInventory(TInventoryDR)),"^",1)
	.s TBillStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p($g(^DHCEQInventory(TInventoryDR)),"^",2))
	.s TDate=$p($g(^DHCEQInventory(TInventoryDR)),"^",7)
	.s TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	.s TTime=$p($g(^DHCEQInventory(TInventoryDR)),"^",8)
	.s TTime=##Class(web.DHCEQCommon).TransValueToPage(TTime,"time")
	.s TStatus=$p($g(^DHCEQInventory(TInventoryDR)),"^",10)
	.s TStatusDisplay=##Class(web.DHCEQInStockNew).GetInStockStatus(TStatus)
	.s TCompleteDate=$p($g(^DHCEQInventory(TInventoryDR)),"^",13)
	.s TCompleteDate=##class(web.DHCEQCommon).TransValueToPage(TCompleteDate,"date")
	.
	.s vStoreLocID=0
	.f  s vStoreLocID=$o(^DHCEQInventoryAudit(0,"TypeInventory",pFilterType,InventoryDR,vStoreLocID)) q:vStoreLocID=""  d
	..s vIARowID=$o(^DHCEQInventoryAudit(0,"Inventory",InventoryDR,vStoreLocID,0))
	..q:vIARowID=""
	..s TTotalNum=TTotalNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",3)
	..s TDiffeNum=TDiffeNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",4)
	..s TProfitNum=TProfitNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",5)
	..s TLoseNum=TLoseNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",6)
	..s TNotInventoryNum=TNotInventoryNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",7)
	..s TConsistentNum=TConsistentNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",10)
	..s TUnCheckLocNum=TUnCheckLocNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",11)
	..s TFindNum=TFindNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",12)
	..s TDisUseNum=TDisUseNum+$p($g(^DHCEQInventoryAudit(vIARowID)),"^",13)
	.
	.d OutputRowGetIPlanSummary
	.
	/*.q
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",TInventoryDR,rowid)) quit:(rowid="")  d
	..s TTotalNum=TTotalNum+1
	..i pFilterType=1 d
	...; 1-按盘点状态汇总	 "1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单"
	...i $p($g(^DHCEQInventoryList(rowid)),"^",14)=1 d
	....s TConsistentNum=TConsistentNum+1
	...e  d
	....s TDiffeNum=TDiffeNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",14)=2 s TUnCheckLocNum=TUnCheckLocNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",14)=3 s TLoseNum=TLoseNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",14)=4 s TFindNum=TFindNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",14)=5 s TDisUseNum=TDisUseNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",14)="" s TNotInventoryNum=TNotInventoryNum+1
	..
	..i pFilterType=2 d
	...; 2-按处置状态汇总	"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","6":"盘盈","7":"计划外科室不符"
	...i $p($g(^DHCEQInventoryList(rowid)),"^",28)=1 d
	....s TConsistentNum=TConsistentNum+1
	...e  d
	....s TDiffeNum=TDiffeNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",28)=2 s TUnCheckLocNum=TUnCheckLocNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",28)=3 s TLoseNum=TLoseNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",28)=4 s TFindNum=TFindNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",28)=5 s TDisUseNum=TDisUseNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",28)=6 s TProfitNum=TProfitNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",28)=7 s TUnCheckLocNum=TUnCheckLocNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",28)="" s TNotInventoryNum=TNotInventoryNum+1
	..
	..i pFilterType=3 d
	...; 3-按处置结果汇总	"1":"账物一致","2":"盘盈入库","3":"科室不符已转科","4":"科室不符不处理","5":"盘亏已减少","6":"报废"
	...i $p($g(^DHCEQInventoryList(rowid)),"^",29)=1 d
	....s TConsistentNum=TConsistentNum+1
	...e  d
	....s TDiffeNum=TDiffeNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",29)=2 s TProfitNum=TProfitNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",29)=3 s TUnCheckLocNum=TUnCheckLocNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",29)=4 s TUnCheckLocNum=TUnCheckLocNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",29)=5 s TLoseNum=TLoseNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",29)=6 s TDisUseNum=TDisUseNum+1
	...i $p($g(^DHCEQInventoryList(rowid)),"^",29)="" s TNotInventoryNum=TNotInventoryNum+1
	.
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryException(0,"Inventory",TInventoryDR,rowid)) quit:(rowid="")  d
	..s TProfitNum=TProfitNum+1
	.
  	.d OutputRowGetIPlanSummary*/
	
	Quit $$$OK
OutputRowGetIPlanSummary
	Set TRow=TRow+1
	Set Data=$lb(TRow,TInventoryDR,TPDesc,TInventoryNo,TBillStoreLoc,TDate,TTime,TStatusDisplay,TCompleteDate,TTotalNum,TConsistentNum,TDiffeNum,TUnCheckLocNum,TLoseNum,TFindNum,TDisUseNum,TNotInventoryNum,TProfitNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	Quit
	
ResetVarGetIPlanSummary
	Set (TInventoryDR,TPDesc,TInventoryNo,TBillStoreLoc,TDate,TTime,TStatusDisplay,TCompleteDate)=""
	Set (TTotalNum,TConsistentNum,TDiffeNum,TUnCheckLocNum,TLoseNum,TFindNum,TDisUseNum,TNotInventoryNum,TProfitNum)=0
	Quit
}

ClassMethod GetIPlanSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIPlanSummaryExecute ]
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

ClassMethod GetIPlanSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIPlanSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// MZY0090	2021-08-23
/// 盘盈明细表
/// Mozy	2020-7-7
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","QueryInventoryException","",1,17,"","")
/// Modefied by zc0125 2022-12-5 增加输出
Query QueryInventoryException(InventoryDR As %String = "", User As %String = "", InventoryPlanDR As %String = "", InventoryLocDR As %String = "", InventoryNo As %String = "", InventoryStatus As %String = "", EquipNo As %String = "", IEquipTypeIDs As %String = "") As %Query(ROWSPEC = "IERowID:%String,IEInventoryDR:%String,IEInventoryNo:%String,IEEquipName:%String,IEEquipNo:%String,IEOriginalFee:%String,IEModel:%String,IEStartDate:%String,IETransAssetDate:%String,IEUserLocDR:%String,IEUserLoc:%String,IEStoreLocDR:%String,IEStoreLoc:%String,IEManuFactoryDR:%String,IEManuFactory:%String,IEProviderDR:%String,IEProvider:%String,IELocationDR:%String,IELocation:%String,IELeaveFactoryNo:%String,IEDate:%String,IETime:%String,IERemark:%String,IEHold1:%String,IEHold2:%String,IEHold3:%String,IEHold4:%String,IEHold5:%String,TJob:%String,IETempNo:%String,IEInventoryStatus:%String,IEDisposeStatus:%String,IEDisposeResult:%String,IEEquipTypeDR:%String,IEDisposeStatusID:%String,IEDisposeResultID:%String,TBussType:%String,TBussID:%String")
{
}

ClassMethod QueryInventoryExceptionExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", User As %String = "", InventoryPlanDR As %String = "", InventoryLocDR As %String = "", InventoryNo As %String = "", InventoryStatus As %String = "", EquipNo As %String = "", IEquipTypeIDs As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	//i InventoryDR="" Quit $$$OK
 	;s ^DHCEQTempZC("QueryInventoryException")=$lb(InventoryDR , User, InventoryPlanDR, InventoryLocDR,InventoryNo, InventoryStatus, EquipNo)
	s index=1
	
	// czf 2021-08-26
	i User'="" s curuser=User
	e  s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Job=$J
	s gnum=1
	k ^DHCEQTemp("InventoryException",curuser,Job)
	i InventoryNo'="" s InventoryDR=$o(^DHCEQInventory(0,"InventoryNo",InventoryNo,0))
	i InventoryDR'="" d
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryException(0,"Inventory",InventoryDR,rowid))  quit:rowid=""  d
	..d ResetVariablesQueryInventoryException
	..s data=$g(^DHCEQInventoryException(rowid))
	..s IEInventoryDR=$p(data,"^",1)
	..q:(IEquipTypeIDs'="")&&(","_IEquipTypeIDs_","'[(","_$p(data,"^",28)_","))   ///Modefied by zc0125 2022-11-09 类组查询处理
	..q:(InventoryNo'="")&&($p($g(^DHCEQInventory(IEInventoryDR)),"^",1)'=InventoryNo)
	..q:(InventoryPlanDR'="")&&($p($g(^DHCEQInventory(IEInventoryDR)),"^",22)'=InventoryPlanDR)
	..q:(InventoryLocDR'="")&&($p(data,"^",9)'=InventoryLocDR)
	..q:(InventoryStatus="1")&&($p(data,"^",29)'="")
	..q:(InventoryStatus="2")&&($p(data,"^",29)'="6")
	..q:(InventoryStatus="3")&&(($p(data,"^",29)="")||($p(data,"^",29)="6"))
	..d BuildDataList
	e  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryException(rowid))  quit:rowid=""  d
	..d ResetVariablesQueryInventoryException
	..s data=$g(^DHCEQInventoryException(rowid))
	..s IEInventoryDR=$p(data,"^",1)
	..q:(IEquipTypeIDs'="")&&(","_IEquipTypeIDs_","'[(","_$p(data,"^",28)_","))	///Modefied by zc0125 2022-11-09 类组查询处理
	..q:(InventoryNo'="")&&($p($g(^DHCEQInventory(IEInventoryDR)),"^",1)'=InventoryNo)
	..q:(InventoryPlanDR'="")&&(IEInventoryDR="")
	..q:(InventoryPlanDR'="")&&(IEInventoryDR'="")&&($p($g(^DHCEQInventory(IEInventoryDR)),"^",22)'=InventoryPlanDR)
	..q:(InventoryLocDR'="")&&($p(data,"^",9)'=InventoryLocDR)
	..q:(InventoryStatus="1")&&($p(data,"^",29)'="")
	..q:(InventoryStatus="2")&&($p(data,"^",29)'="6")
	..q:(InventoryStatus="3")&&(($p(data,"^",29)'="")||($p(data,"^",29)="6"))
	..d BuildDataList
	
	Quit $$$OK
	
BuildDataList	
	s IERowID=rowid
	s IEInventoryDR=$p(data,"^",1)
	s IEInventoryNo=$p($g(^DHCEQInventory(IEInventoryDR)),"^",1)
	s IEEquipName=$p(data,"^",2)
	;q:(StoreLocDR'="")&&(IStoreLocDR'="")&&(StoreLocDR'=IStoreLocDR)
	s IETempNo=$p(data,"^",3)
	s EquipNo=##Class(web.DHCEQCommon).UnEscape(EquipNo)
	s EquipNo=$ZCONVERT(EquipNo,"U")
	q:($ZCONVERT(IETempNo,"U")'[EquipNo)&&($ZCONVERT(IEEquipName,"U")'[EquipNo)
	i $p(data,"^",24)'="" s IEEquipNo=$p($g(^DHCEQEquip($p(data,"^",24))),"^",71)
	i IETempNo=IEEquipNo s IETempNo=""
	s IEOriginalFee=##class(web.DHCEQCommon).FormatNumber($p(data,"^",4),"")
	s IEModel=$p(data,"^",5)
	s IEStartDate=##class(web.DHCEQCommon).TransValueToPage($p(data,"^",6),"date")
	s IETransAssetDate=##Class(web.DHCEQCommon).TransValueToPage($p(data,"^",7),"date")
	s IEUserLocDR=$p(data,"^",8)
	s IEStoreLocDR=$p(data,"^",9)
	s IEUserLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",IEUserLocDR)
	s IEStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",IEStoreLocDR)
	s IEManuFactoryDR=$p(data,"^",10)
	s IEManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",IEManuFactoryDR)
	s IEProviderDR=$p(data,"^",11)
	s IEProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",IEProviderDR)
	s IELocationDR=$p(data,"^",12)
	s IELocation=##Class(web.DHCEQCommon).GetTrakNameByID("location",IELocationDR)
	s IELeaveFactoryNo=$p(data,"^",13)
	s IEDate=##class(web.DHCEQCommon).TransValueToPage($p(data,"^",14),"date")
	s IETime=##Class(web.DHCEQCommon).TransValueToPage($p(data,"^",15),"time")
	s IERemark=$p(data,"^",16)
	s IEHold1=$p(data,"^",17)
	s IEHold2=$p(data,"^",18)
	s IEHold3=$p(data,"^",19)
	s IEHold4=$p(data,"^",20)
	s IEHold5=$p(data,"^",21)
	s IEInventoryStatus=$case($p(data,"^",31),"":"",1:"科室不符",2:"盘盈",3:"计划外科室不符")
	s IEDisposeStatus=$case($p(data,"^",29),"":"",1:"一致",2:"科室不符",3:"盘亏",4:"待查找",5:"有报废单",6:"盘盈",7:"计划外科室不符")
	s IEDisposeResult=$case($p(data,"^",30),"":"",1:"一致",2:"盘盈入库",3:"科室不符已转科",4:"科室不符不处理",5:"盘亏已减少",6:"报废")
	s IEEquipTypeDR=$p(data,"^",28)    	//Modefied by zc0125 2022-12-5 增加输出 begin
	s IEDisposeStatusID=$p(data,"^",29)	
	s IEDisposeResultID=$p(data,"^",30)	
	s TBussType=$p(data,"^",33)			
	s TBussID=$p(data,"^",34)			//Modefied by zc0125 2022-12-5 增加输出 end
	d OutputRowQueryInventoryException
	q
OutputRowQueryInventoryException
	Set Data=$lb(IERowID,IEInventoryDR,IEInventoryNo,IEEquipName,IEEquipNo,IEOriginalFee,IEModel,IEStartDate,IETransAssetDate,IEUserLocDR,IEUserLoc,IEStoreLocDR,IEStoreLoc,IEManuFactoryDR,IEManuFactory,IEProviderDR,IEProvider,IELocationDR,IELocation,IELeaveFactoryNo,IEDate,IETime,IERemark,IEHold1,IEHold2,IEHold3,IEHold4,IEHold5,Job,IETempNo,IEInventoryStatus,IEDisposeStatus,IEDisposeResult,IEEquipTypeDR,IEDisposeStatusID,IEDisposeResultID,TBussType,TBussID)  //Modefied by zc0125 2022-12-5 增加输出
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("InventoryException",curuser,Job,gnum)=IERowID_"^"_IEInventoryNo_"^"_IEEquipName_"^"_IEEquipNo_"^"_IEOriginalFee_"^"_IEModel_"^"_IEStartDate_"^"_IETransAssetDate_"^"_IEUserLoc_"^"_IEStoreLoc_"^"_IEManuFactory_"^"_IEProvider_"^"_IELocation_"^"_IELeaveFactoryNo_"^"_IEDate_"^"_IETime_"^"_IERemark_"^"_IETempNo_"^"_IEInventoryStatus_"^"_IEDisposeStatus
	Set gnum=gnum+1
	quit
ResetVariablesQueryInventoryException
	Set (IERowID,IEInventoryDR,IEInventoryNo,IEEquipName,IEEquipNo,IEOriginalFee,IEModel,IEStartDate,IETransAssetDate,IEUserLocDR,IEUserLoc,IEStoreLocDR,IEStoreLoc,IEManuFactoryDR,IEManuFactory,IEProviderDR,IEProvider,IELocationDR,IELocation,IELeaveFactoryNo,IEDate,IETime,IERemark,IEHold1,IEHold2,IEHold3,IEHold4,IEHold5,IETempNo,IEInventoryStatus,IEDisposeStatus,IEDisposeResult,IEEquipTypeDR,IEDisposeStatusID,IEDisposeResultID,TBussType,TBussID)=""  //Modefied by zc0125 2022-12-5 增加输出
	quit
}

ClassMethod QueryInventoryExceptionFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInventoryExceptionExecute ]
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

ClassMethod QueryInventoryExceptionClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInventoryExceptionExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class("web.DHCEQ.EM.BUSInventory").ChangeIEInventoryStatus("1",1)
ClassMethod ChangeIEInventoryStatus(IERowID, Type)
{
	s $ZT="ERRORIEInventoryStatus"
	i (IERowID="")||(Type="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1")
	TSTART

	&SQL(update sqluser.DHC_EQInventoryException set IE_DisposeStatus=:Type where IE_RowID=:IERowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s vInventoryDR=$p($g(^DHCEQInventoryException(IERowID)),"^",1)
	s vStoreLocDR=$p($g(^DHCEQInventoryException(IERowID)),"^",9)
	s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(vInventoryDR,vStoreLocDR,1)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,IERowID)
	
ERRORIEInventoryStatus
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 盘点绑定设备明细列表
/// modify by mwz 20221110 MWZ0064增加入参DisplayFlag 盘点状态过滤
/// Modefied by zc0125  增加入参DisplayFlag
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","InventoryBindList","8","","","","","","Y")
Query InventoryBindList(ExceptionID As %String = "", Equip As %String = "", Model As %String = "", StoreLocDR As %String = "", Hold1 As %String = "", EquipTypeIDs As %String = "", InPlan As %String = "Y", DisplayFlag As %String = "") As %Query(ROWSPEC = "TPlanName:%String,TInventoryNo:%String,TEquipNo:%String,TEquipName:%String,TModel:%String,TILStatusDesc:%String,TBillStoreLoc:%String,TPlace:%String,TLeaveFactoryNo:%String,TILRowID:%String,TEquipID:%String") [ SqlProc ]
{
}

ClassMethod InventoryBindListExecute(ByRef qHandle As %Binary, ExceptionID As %String = "", Equip As %String = "", Model As %String = "", StoreLocDR As %String = "", Hold1 As %String = "", EquipTypeIDs As %String = "", InPlan As %String = "Y", DisplayFlag As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	s InPlan=##Class(web.DHCEQCommon).TransValueFromPage(InPlan,"bool")
	s InventoryDR=$p($g(^DHCEQInventoryException(ExceptionID)),"^",1) 
	s InventoryPlanDR=$p($g(^DHCEQInventory(InventoryDR)),"^",22) 
	//modify by mwz 20221110 MWZ0064 BEGIN
	i (InPlan="Y")
	{
		i InventoryPlanDR'=""
		{
		s InventoryDR=0
		f  s InventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",InventoryPlanDR,InventoryDR)) quit:(InventoryDR="")  d
		.s rowid=0
		.f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid))  quit:(rowid="")  d
		..d ResetVarInventoryBindList
		..s TILRowID=rowid
		..s TInventoryDR=InventoryDR
		..s InventoryPlanDR=$p($g(^DHCEQInventory(InventoryDR)),"^",22) 
		..q:(InventoryDR'="")&&(TInventoryDR'=InventoryDR)
		..i InventoryPlanDR'="" s TPlanName=$p($g(^DHCEQInventoryPlan(InventoryPlanDR)),"^",2)  //盘点计划
		..s TInventoryNo=$p($g(^DHCEQInventory(InventoryDR)),"^",1)  //盘点单号
		..s TEquipID=$p($g(^DHCEQInventoryList(rowid)),"^",2)   //equipdr
		..s TBillStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",4)   //storelocdr
		..q:(StoreLocDR'="")&&(TBillStoreLocDR'=StoreLocDR)
		..s TBillUseLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",5)
		..s TActerStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",6)
		..s TActerUseLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",7)
		..s TStatus=$p($g(^DHCEQInventoryList(rowid)),"^",14)
		..q:((TStatus="")||(TStatus=1)||(TStatus=2))  //过滤盘点到的设备
		..s TILStatusDesc=$CASE(TStatus,"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","":"")	
		..q:(DisplayFlag'="")&&(DisplayFlag'=TStatus)   //modify by mwz 20221110 MWZ0064
		..s TEquipName=$p($g(^DHCEQEquip(TEquipID)),"^",1)   //设备名称
		..s TEquipNo=$p($g(^DHCEQEquip(TEquipID)),"^",71)    //设备编号
		..s TModelDR=$p($g(^DHCEQEquip(TEquipID)),"^",3)  
		..q:(Model'="")&&(TModelDR'=Model)
		..s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)  // MZY0150	3195692,3199935		2023-01-29	机型
		..s TLeaveFactoryNo = $p($g(^DHCEQEquip(TEquipID)),"^",10)   //出厂编号
		..q:($ZCONVERT(TEquipNo,"U")'[Equip)&&($ZCONVERT(TEquipName,"U")'[Equip)&&($ZCONVERT(TLeaveFactoryNo,"U")'[Equip)
		..s TBillStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillStoreLocDR)   //账面存放科室
		..s TBillUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillUseLocDR)
		..s TActerStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerStoreLocDR)
		..s TActerUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerUseLocDR)
		..s TPlace=$p($g(^DHCEQEquip(TEquipID)),"^",72)  //存放地点
		..i TPlace'="" s TPlace=$p($g(^DHCEQCCode("DHCEQCLocation",TPlace)),"^",2)  
		..d OutputRowInventoryBindList
		}
		else
		{
			s rowid=0
			f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid))  quit:(rowid="")  d
			.d ResetVarInventoryBindList
			.s TILRowID=rowid
			.s TInventoryDR=InventoryDR
			.s InventoryPlanDR=$p($g(^DHCEQInventory(InventoryDR)),"^",22) 
			.i InventoryPlanDR'="" s TPlanName=$p($g(^DHCEQInventoryPlan(InventoryPlanDR)),"^",2)  //盘点计划
			.s TInventoryNo=$p($g(^DHCEQInventory(InventoryDR)),"^",1)  //盘点单号
			.s TEquipID=$p($g(^DHCEQInventoryList(rowid)),"^",2)   //equipdr
			.s TBillStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",4)   //storelocdr
			.q:(StoreLocDR'="")&&(TBillStoreLocDR'=StoreLocDR)
			.s TBillUseLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",5)
			.s TActerStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",6)
			.s TActerUseLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",7)
			.s TStatus=$p($g(^DHCEQInventoryList(rowid)),"^",14)
			.q:((TStatus="")||(TStatus=1)||(TStatus=2))  //过滤盘点到的设备
			.s TILStatusDesc=$CASE(TStatus,"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","":"")	
			.q:(DisplayFlag'="")&&(DisplayFlag'=TStatus)
			.s TEquipName=$p($g(^DHCEQEquip(TEquipID)),"^",1)   //设备名称
			.s TEquipNo=$p($g(^DHCEQEquip(TEquipID)),"^",71)    //设备编号
			.s TModelDR=$p($g(^DHCEQEquip(TEquipID)),"^",3)  
			.q:(Model'="")&&(TModelDR'=Model)
			.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)  // MZY0150	3195692,3199935		2023-01-29	机型
			.s TLeaveFactoryNo = $p($g(^DHCEQEquip(TEquipID)),"^",10)   //出厂编号
			.q:($ZCONVERT(TEquipNo,"U")'[Equip)&&($ZCONVERT(TEquipName,"U")'[Equip)&&($ZCONVERT(TLeaveFactoryNo,"U")'[Equip)
			.s TBillStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillStoreLocDR)   //账面存放科室
			.s TBillUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillUseLocDR)
			.s TActerStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerStoreLocDR)
			.s TActerUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerUseLocDR)
			.s TPlace=$p($g(^DHCEQEquip(TEquipID)),"^",72)  //存放地点
			.i TPlace'="" s TPlace=$p($g(^DHCEQCCode("DHCEQCLocation",TPlace)),"^",2)  
			.d OutputRowInventoryBindList	
		}
		//modify by mwz 20221110 MWZ0064 END
	  }
	elseif (InPlan="N")||(InPlan="")
	{
		s RowID=0
		f  s RowID=$o(^DHCEQEquip(RowID))	q:RowID=""  d
		.d ResetVarInventoryBindList
		.s TEquipID=RowID
		.s TEquipNo=$p($g(^DHCEQEquip(RowID)),"^",71)  //设备编号
		.s ILRowID=""  //Modefied by zc0125 2022-12-12 增加盘点明细记录id
		.s NewInventoryDR=0,EquipFind=0
		.i InventoryPlanDR'="" d  //Modefied by zc0125 2022-12-12 增加盘点明细记录id输出 begin
		..f  s NewInventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",InventoryPlanDR,NewInventoryDR)) quit:(NewInventoryDR="")  d
		...q:NewInventoryDR=InventoryDR
		...s ILRowID=$o(^DHCEQInventoryList(0,"BillEquip",NewInventoryDR,RowID,""))
		...i $d(^DHCEQInventoryList(0,"BillEquip",NewInventoryDR,RowID)) s EquipFind=1  //判断盘点计划是否包含设备
		.e  d
		..s ILRowID=$o(^DHCEQInventoryList(0,"BillEquip",InventoryDR,RowID,""))  //Modefied by zc0125 2022-12-12 增加盘点明细记录id end
		.q:EquipFind=1   
		.s InvalidFlag=$p($g(^DHCEQEquip(RowID)),"^",59)	
		.q:InvalidFlag="Y"
		.s TStatus=$p($g(^DHCEQEquip(RowID)),"^",38)
		.q:(TStatus>2)
		.s TStockStatus=$p($g(^DHCEQEquip(RowID)),"^",60)
		.q:(TStockStatus'=1)
		.s NewEQCode=$p($g(^DHCEQEquip(RowID)),"^",6)
		.s TEquipName=$p($g(^DHCEQEquip(RowID)),"^",1) //设备名称
		.s TLeaveFactoryNo = $p($g(^DHCEQEquip(RowID)),"^",10) //出厂编号
		.s MemoryCode = $p($g(^DHCEQEquip(RowID)),"^",61)
		.s FileNo=$p($g(^DHCEQEquip(RowID)),"^",85)
		.s TBillStoreLocDR=$p($g(^DHCEQEquip(RowID)),"^",67)
		.q:(StoreLocDR'="")&&(TBillStoreLocDR'=StoreLocDR)  //Modefied by zc0125 增加科室过滤
		.s TBillStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillStoreLocDR)
		.s TModelDR=$p($g(^DHCEQEquip(RowID)),"^",3)  
		.q:(Model'="")&&(TModelDR'=Model)
		.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)  // MZY0150	3195692,3199935		2023-01-29	机型
		.s TPlace=$p($g(^DHCEQEquip(RowID)),"^",72)  //存放地点
		.i TPlace'="" s TPlace=$p($g(^DHCEQCCode("DHCEQCLocation",TPlace)),"^",2)  
		.q:($ZCONVERT(TEquipNo,"U")'[Equip)&&($ZCONVERT(TEquipName,"U")'[Equip)&&($ZCONVERT(TLeaveFactoryNo,"U")'[Equip)&&($ZCONVERT(MemoryCode,"U")'[Equip)&&($ZCONVERT(FileNo,"U")'[Equip)
		.s TILRowID=ILRowID  //Modefied by zc 2022-12-05
		.d OutputRowInventoryBindList
	}
	quit $$$OK
OutputRowInventoryBindList
	Set Data=$lb(TPlanName,TInventoryNo,TEquipNo,TEquipName,TModel,TILStatusDesc,TBillStoreLoc,TPlace,TLeaveFactoryNo,TILRowID,TEquipID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
	
ResetVarInventoryBindList
	set (TPlanName,TInventoryNo,TEquipNo,TEquipName,TModel,TILStatusDesc,TBillStoreLoc,TPlace,TLeaveFactoryNo,TILRowID,TEquipID)=""
	quit
}

ClassMethod InventoryBindListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InventoryBindListExecute ]
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
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod InventoryBindListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InventoryBindListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 绑定设备
/// w ##Class(web.DHCEQ.EM.BUSInventory).BindEquip()
ClassMethod BindEquip(ExceptionID As %Library.String = "", TempNo As %Library.String = "", BindEquipID As %Library.String = "", ILRowID As %Library.String = "")
{
	s $ZT="ERRORSaveData"
	i BindEquipID="" q "选择列编号不能为空"
	i ExceptionID="" q "盘盈ID不能为空"
	i TempNo="" q "临时码不能为空"
	//1.绑定表      2.盘盈表里回写绑定设备ID  3.盘盈表里的盘点状态    4.盘点明细表的盘点状态
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user", %session.Get("LOGON.USERID"))
	s InventoryDR=$p($g(^DHCEQInventoryException(ExceptionID)),"^",1) 
	s IEStoreLocDR=$p($g(^DHCEQInventoryException(ExceptionID)),"^",9) //盘盈存放科室
	//s BillStoreLocDR=$p($g(^DHCEQEquip(BindEquipID)),"^",67)  //台账存放科室
	//Modefied by zc0125 2022-12-12 修正绑定错误 begin
	s (ILInventoryDR,BillStoreLocDR)=""
	i ILRowID'="" d
	.s ILInventoryDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",1)  //盘点明细盘点单DR
	.s BillStoreLocDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",4) //盘点明细账面科室
	//Modefied by zc0125 2022-12-12 修正绑定错误 end
	i InventoryDR'="" s InventoryPlanDR=$p($g(^DHCEQInventory(InventoryDR)),"^",22) 
	i InventoryPlanDR'="" s TPlanName=$p($g(^DHCEQInventoryPlan(InventoryPlanDR)),"^",2)  //盘点计划
	i IEStoreLocDR=BillStoreLocDR s disposeStatus="1"
	e  s disposeStatus="2"
	//修改绑定表数据
	TStart
    k BOPLIST
	s FromDate=+$H
	s FromTime=$p($H,",",2)
	s BOPLIST(2)="1"   //1.设备 2.存放地点
	s BOPLIST(3)=BindEquipID  //设备ID
	s BOPLIST(4)="3"   //1.RFID 2.外部代码 3.临时码
	s BOPLIST(5)=""   //绑定ID
	s BOPLIST(6)=TempNo   //绑定编号
	s BOPLIST(7)=CurUser
	s BOPLIST(8)=FromDate
	s BOPLIST(9)=FromTime
	s BOPLIST(14)="N"
	&SQL(select BO_RowID into :BORowID from SQLUSER.DHC_EQBindObj where BO_InvalidFlag<>'Y' and BO_SourceType='1' and BO_SourceID=:BindEquipID and BO_BindType='3' and BO_BindNo=:TempNo )
	if BORowID=""  
	{
		&SQL(Insert Into SQLUSER.DHC_EQBindObj Values :BOPLIST())
		if SQLCODE  
		{	
			TRollBack
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		//Modefied by zc0125 2022-12-12 修正绑定错误 begin
		if (ILRowID'="")
		{
			&SQL(Update sqluser.DHC_EQInventoryList set il_disposestatus=:disposeStatus Where il_rowid=:ILRowID)
			if SQLCODE  
			{	
				TRollBack
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		}
		//Modefied by zc0125 2022-12-12 修正绑定错误 end
		&SQL(Update sqluser.DHC_EQInventoryException set ie_disposestatus=:disposeStatus Where ie_rowid=:ExceptionID)
		if SQLCODE  
		{	
			TRollBack
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		&SQL(Update sqluser.DHC_EQInventoryException set ie_acterequipdr=:BindEquipID Where ie_rowid=:ExceptionID)
		if SQLCODE  
		{	
			TRollBack
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		//begin add by jyp 2022-09-21
		s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR,IEStoreLocDR,1)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		if (disposeStatus=2)
		{
			s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(ILInventoryDR,BillStoreLocDR,1)
			i SQLCODE
			{
				TROLLBACK
				Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
			}
		}
		//end add by jyp 2022-09-21
    }
    else 
    {
	    //已存在绑定的设备需做？？处理
	    }
	TCommit
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,BindEquipID)
ERRORSaveData
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012", $ZE)
}

/// w ##class("web.DHCEQ.EM.BUSInventory").ChangeIEInventoryStatus("1",1)
ClassMethod UnBindEquip(IERowID, Type)
{
	s $ZT="ERRORUnBindEquip"
	i (IERowID="")||(Type="") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1")
	s ActerEquipDR=$p($g(^DHCEQInventoryException(IERowID)),"^",24)
	i ActerEquipDR="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1")
	s Date=+$h
	s Time=$p($h,",",2)
	s BORowID=$o(^DHCEQBindObj(0,"SourceID","N",1,ActerEquipDR,0))
	TSTART
	
	&SQL(update sqluser.DHC_EQInventoryException set IE_Status='2',IE_ActerEquipDR=NULL,IE_EquipTypeDR=NULL where IE_RowID=:IERowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	&SQL(update sqluser.DHC_EQBindObj set BO_ToDate=:Date,BO_ToTime=:Time,BO_InvalidFlag='Y' where BO_RowID=:BORowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	/*add by jyp 2022-09-21
	s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR,IEStoreLocDR,1)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(ILInventoryDR,BillStoreLocDR,1)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	*/	
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,IERowID)
	
ERRORUnBindEquip
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSInventory).CheckLocinInventory("63","210")
ClassMethod CheckLocinInventory(LocDR, InventoryDR)
{
	s LocObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	set InventoryLocDR=$p($g(^DHCEQInventory(InventoryDR)),"^",2) 
	;w InventoryLocDR,!
	IF InventoryLocDR=""  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("1")
	set LocDR=##Class(web.DHCEQ.EM.BUSInventory).GetTopLocDR(LocDR)
	d LocObj.%Set("LocDR",InventoryLocDR)
	d LocObj.%Set("LocDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",InventoryLocDR))
	if InventoryLocDR=LocDR Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("1")
	else  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("0",LocObj)
}

/// 根据盘点单获取整个盘点单的图片或者某个科室的图片
/// add by mwz 20220818 
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInventory","InventoryListPicInfo","219","51")
/// 入参  InventoryDR：盘点单号  StoreLocDR：台账科室
/// 输出  TPLRowID：图片明细表ID(图片名称),TSuffix(文件后缀),TEquipName,TEQNo,TStoreLoc(台账科室)
Query InventoryListPicInfo(InventoryDR As %String = "", StoreLocDR As %String = "") As %Query(ROWSPEC = "TPLRowID:%String,TSuffix:%String,TEquipName:%String,TEQNo:%String,TStoreLoc:%String") [ SqlProc ]
{
}

ClassMethod InventoryListPicInfoExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", StoreLocDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	Set qHandle=$lb(0,repid,0)	

	;s ^tmp("dhceq","InventoryListPicInfo",$H)=InventoryDR_":"_StoreLocDR
	s ILRowID=0
	f  s ILRowID=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,ILRowID))  quit:(ILRowID="")  d
	.s PicRowID=0
	.f  s PicRowID=$o(^DHCEQPicture(0,"Source","53",ILRowID,PicRowID)) q:PicRowID=""  d
	..q:($p($g(^DHCEQPicture(PicRowID)),"^",7)=2)
	..s PLRowID=0
	..f  s PLRowID=$o(^DHCEQPictureList(0,"Picture",PicRowID,PLRowID)) q:PLRowID=""  d
	...d ResetVariablesInventoryListPicInfo
	...s TPLRowID=PLRowID
	...s TStoreLocDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",4)
	...q:(StoreLocDR'="")&&(TStoreLocDR'=StoreLocDR)  
	...i TStoreLocDR'="" s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TStoreLocDR)
	...s TEquipID=$p($g(^DHCEQInventoryList(ILRowID)),"^",2)  
	...i TEquipID'="" s TEquipName=$p($g(^DHCEQEquip(TEquipID)),"^",1) 
	...i TEquipID'="" s TEQNo=$p($g(^DHCEQEquip(TEquipID)),"^",71)  
	...s TSuffix=$p($g(^DHCEQPictureList(PLRowID)),"^",3)
	...d OutputRowInventoryListPicInfo
    quit $$$OK
OutputRowInventoryListPicInfo
	Set Data=$lb(TPLRowID,TSuffix,TEquipName,TEQNo,TStoreLoc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
ResetVariablesInventoryListPicInfo
	s (TPLRowID,TSuffix,TEquipName,TEQNo,TStoreLoc)=""
	quit
}

ClassMethod InventoryListPicInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InventoryListPicInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod InventoryListPicInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InventoryListPicInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	Set repid=$LIST(qHandle,2)
	Set ind=$LIST(qHandle,3)
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" 
	{				// if there are no more rows, finish fetching
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

// modify by jyp 2022-09-21

ClassMethod UpdateILDisposeStatus(InventoryListDR, DisposeStatus)
{
	s $ZT="ERRORUpdateILDisposeStatus"
	TSTART
	&SQL(Update sqluser.DHC_EQInventoryList set IL_DisposeStatus=:DisposeStatus Where IL_RowID=:InventoryListDR)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s vInventoryDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",1)
	s vStoreLocDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",4)
	s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(vInventoryDR,vStoreLocDR,1)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	
ERRORUpdateILDisposeStatus
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Creator：      MZY
/// CreatDate：    2022-9-5
/// Description:   生成盘点单DR
/// 入参:
/// 		InventoryPlanDR		盘点计划ID
/// w ##Class(web.DHCEQ.EM.BUSInventory).GetInventoryDRStr(17)
ClassMethod GetInventoryDRStr(InventoryPlanDR As %String = "")
{
	n InventoryDRStr,InventoryDR
	s InventoryDRStr=""
	i InventoryPlanDR="" q InventoryDRStr
	s InventoryDR=0
	f  s InventoryDR=$o(^DHCEQInventory(0,"InventoryPlan",InventoryPlanDR,InventoryDR)) quit:(InventoryDR="")  d
	.i InventoryDRStr'="" s InventoryDRStr=InventoryDRStr_","
	.s InventoryDRStr=InventoryDRStr_InventoryDR
	
	q InventoryDRStr
}

/// MZY0133		2612991		2022-09-09
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","ResultStat","")
Query ResultStat(InventoryDR As %String = "", StoreLocDR As %String = "") As %Query(ROWSPEC = "TLocID:%String,TLocName:%String,TTotalQty:%String,TAmount:%String,TDiffQty:%String,TDiffAmount:%String,TLoseQty:%String,TLoseAmount:%String,TAccordQty:%String,TAccordAmount:%String,TJob:%String,TRow:%String")
{
}

ClassMethod ResultStatExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", StoreLocDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	new tmpNode
	new billStoreLocID,equipID,originalFee,rowid,IncludeFlag
	new TLocID,TLocName,TTotalQty,TAmount,TDiffQty,TDiffAmount,TLoseQty,TLoseAmount,TAccordQty,TAccordAmount,TJob
	new TTotalQtySum,TAmountSum,TDiffQtySum,TDiffAmountSum,TLoseQtySum,TLoseAmountSum,TAccordQtySum,TAccordAmountSum
	
	s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")	//盘点是否包含预报废设备
	s tmpNode="DHCEQInventory.ResultStat"
    //modified by ZY 20220928
    //d ##Class(web.DHCEQCommon).KillTempGlobal(tmpNode)
    s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s TJob=$j
    d ##class(web.DHCEQ.Plat.LIBCommon).ClearTempGlobal(tmpNode,TJob,curuser)
	
	if ((InventoryDR'="")&&(+$p($g(^DHCEQInventory(InventoryDR)),"^",10)>0))
	{
		s (TTotalQtySum,TAmountSum,TDiffQtySum,TDiffAmountSum,TLoseQtySum,TLoseAmountSum,TAccordQtySum,TAccordAmountSum)=0
		s billStoreLocID=0
		f  s billStoreLocID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID))  quit:((billStoreLocID=""))  d
		.//q:(StoreLocDR'="")&&(StoreLocDR'=billStoreLocID)
		.q:(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,billStoreLocID,"1")'="1")
		.s TLocID=billStoreLocID
		.s TLocName=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocID)
		.s (TTotalQty,TAmount,TDiffQty,TDiffAmount,TLoseQty,TLoseAmount,TAccordQty,TAccordAmount)=0
		.s equipID=0
		.f  s equipID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID,equipID))  quit:((equipID=""))  d
		..//增加参数判断盘点是否包含预报废设备,直接取EQ_Hold8字段的值来判断设备的预报废
		..Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(equipID)),"^",93)="2")
		..s rowid=0
		..f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID,equipID,rowid))  quit:((rowid=""))  d
		...s TTotalQty=TTotalQty+1
		...s TTotalQtySum=TTotalQtySum+1
		...s originalFee=+$p($g(^DHCEQInventoryList(rowid)),"^",8)
		...s TAmount=TAmount+originalFee
		...s TAmountSum=TAmountSum+originalFee
		...i TLocID=$p($g(^DHCEQInventoryList(rowid)),"^",6) d
		....s TAccordQty=TAccordQty+1
		....s TAccordAmount=TAccordAmount+originalFee
		....s TAccordQtySum=TAccordQtySum+1
		....s TAccordAmountSum=TAccordAmountSum+originalFee
		...e  d
		....s TDiffQty=TDiffQty+1
		....s TDiffAmount=TDiffAmount+originalFee
		....s TDiffQtySum=TDiffQtySum+1
		....s TDiffAmountSum=TDiffAmountSum+originalFee
		...if $p($g(^DHCEQInventoryList(rowid)),"^",14)="" d
		....s TLoseQty=TLoseQty+1
		....s TLoseAmount=TLoseAmount+originalFee
		....s TLoseQtySum=TLoseQtySum+1
		....s TLoseAmountSum=TLoseAmountSum+originalFee
		.d OutputRowResultStat
		
		s TLocID=""
		s TLocName=""
		s TLocName="合计"
		s TTotalQty=TTotalQtySum
		s TAmount=TAmountSum
		s TDiffQty=TDiffQtySum
		s TDiffAmount=TDiffAmountSum
		s TLoseQty=TLoseQtySum
		s TLoseAmount=TLoseAmountSum
		s TAccordQty=TAccordQtySum
		s TAccordAmount=TAccordAmountSum
		d OutputRowResultStat
	}
	Quit $$$OK
	
OutputRowResultStat
	Set TRow=index
    //modified by ZY 20220928
    //Set ^DHCEQTemp(tmpNode,+$H,TJob,index)=TLocID_"^"_TLocName_"^"_TTotalQty_"^"_TAmount_"^"_TDiffQty_"^"_TDiffAmount_"^"_TLoseQty_"^"_TLoseAmount_"^"_TAccordQty_"^"_TAccordAmount_"^"_TJob
    s tmpValue=TLocID_"^"_TLocName_"^"_TTotalQty_"^"_TAmount_"^"_TDiffQty_"^"_TDiffAmount_"^"_TLoseQty_"^"_TLoseAmount_"^"_TAccordQty_"^"_TAccordAmount_"^"_TJob
    d ##class(web.DHCEQ.Plat.LIBCommon).SetTempGlobal(tmpNode,+$H,TJob,curuser,index,tmpValue)
	Set Data=$lb(TLocID,TLocName,TTotalQty,TAmount,TDiffQty,TDiffAmount,TLoseQty,TLoseAmount,TAccordQty,TAccordAmount,TJob,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ResultStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ResultStatExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind=""
	{
		// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else
	{
		// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
		// Save QHandle
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ResultStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ResultStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Author: by JYP 2022-09-21
/// Description: 盘点中盘点数据汇总
/// Input: CurInventoryDR:盘点单id, CurStoreLocDR:盘点科室
/// Output: 总数_"^"_差异数_"^"_盘盈数_"^"_盘亏数_"^"_未盘数
/// w ##Class(web.DHCEQ.EM.BUSInventory).InventoryResultStatDispose("239","135")
ClassMethod InventoryResultStatDispose(CurInventoryDR As %String = "", CurStoreLocDR As %String = "")
{
	n BillEquipDR,ILRowID,TStatus,TotalNum,DiffeNum,ProfitNum,LoseNum,NotInventoryNum,ConsistentNum,UnCheckLocNum,FindNum,DisUseNum
	s (BillEquipDR,ILRowID,TStatus)=""
	s (TotalNum,DiffeNum,ProfitNum,LoseNum,NotInventoryNum,ConsistentNum,UnCheckLocNum,FindNum,DisUseNum)=0
	
	i CurInventoryDR=0 q TotalNum_"^"_DiffeNum_"^"_ProfitNum_"^"_LoseNum_"^"_NotInventoryNum_"^^^^"_DisUseNum	// MZY0050	1498290		2020-09-01
	i CurStoreLocDR'="" d
	.d BuildInventoryResultStatDispose
	e  d
	.s CurStoreLocDR=0
	.f  s CurStoreLocDR=$o(^DHCEQInventoryList(0,"StoreLoc",CurInventoryDR,CurStoreLocDR))  quit:CurStoreLocDR=""  d
	..d BuildInventoryResultStatDispose
	
	q TotalNum_"^"_DiffeNum_"^"_ProfitNum_"^"_LoseNum_"^"_NotInventoryNum_"^"_ConsistentNum_"^"_UnCheckLocNum_"^"_FindNum_"^"_DisUseNum	// MZY0050	1498290		2020-09-01
BuildInventoryResultStatDispose
	s BillEquipDR=0
	f  s BillEquipDR=$o(^DHCEQInventoryList(0,"StoreLoc",CurInventoryDR,CurStoreLocDR,BillEquipDR))  quit:BillEquipDR=""  d
	.s ILRowID=0
	.f  s ILRowID=$o(^DHCEQInventoryList(0,"StoreLoc",CurInventoryDR,CurStoreLocDR,BillEquipDR,ILRowID))  quit:ILRowID=""  d
	..s TotalNum=TotalNum+1		;账面数量
	..s TStatus=+$p($g(^DHCEQInventoryList(ILRowID)),"^",28)
	..i TStatus=0 s TStatus=+$p($g(^DHCEQInventoryList(ILRowID)),"^",14)	;1:账物一致|2:科室不符|3:盘亏|4:待查找|5:有报废单
	..// MZY0050	1498290		2020-09-01
	..i TStatus=0 s DiffeNum=DiffeNum+1			;差异数量=未盘数+科室不符数+盘亏数+待查找数
	..i TStatus=2 s DiffeNum=DiffeNum+1
	..i TStatus=3 s DiffeNum=DiffeNum+1
	..i TStatus=4 s DiffeNum=DiffeNum+1			
	..i TStatus=5 s DiffeNum=DiffeNum+1
	..i TStatus=0 s NotInventoryNum=NotInventoryNum+1	;未盘数量
	..i TStatus=1 s ConsistentNum=ConsistentNum+1		;账物一致数
	..i TStatus=2 s UnCheckLocNum=UnCheckLocNum+1		;科室不符数
	..i TStatus=3 s LoseNum=LoseNum+1			;盘亏数量
	..i TStatus=4 s FindNum=FindNum+1			;待查找数
	..i TStatus=5 s DisUseNum=DisUseNum+1
	s IERowID=0
	f  s IERowID=$o(^DHCEQInventoryException(0,"StoreLoc",CurInventoryDR,CurStoreLocDR,IERowID)) quit:IERowID=""  d
	.q:(((+$p($g(^DHCEQInventoryException(IERowID)),"^",29))'=6)&&((+$p($g(^DHCEQInventoryException(IERowID)),"^",29))'=0))
	.s ProfitNum=1+ProfitNum	//汇总库房盘盈设备数量
	
	quit
}

/// data:"ILStatus^ILCondition"
/// w ##Class(web.DHCEQ.EM.BUSInventory).BatchUpdate("1^",4800)
ClassMethod BatchUpdate(data As %String = "", job As %String = "")
{
	; Set ^DHCEQTemp("InventoryList",+$H,job,index)=TRowID_"^"_TInventoryDR_"^"_TBillEquipDR_"^"_TActerEquipDR_"^"_TBillStoreLocDR_"^"_TBillUseLocDR_"^"_TActerStoreLocDR_"^"_TActerUseLocDR_"^"_TBillOriginalFee_"^"_TBillNetFee_"^"_TBillDepreTotalFee_"^"_TUserDR_"^"_TDate_"^"_TTime_"^"_TStatus_"^"_TRemark_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TBillName_"^"_TActerName_"^"_TBillNo_"^"_TActerNo_"^"_TModel_"^"_TEquiCat_"^"_TEquipType_"^"_TStatCat_"^"_TUnit_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TProvider_"^"_TLimitYearsNum_"^"_TDepreMethod_"^"_TEquipRemark_"^"_TBillStoreLoc_"^"_TBillUseLoc_"^"_TActerStoreLoc_"^"_TActerUseLoc_"^"_TManuFactory_"^"_TOrigin_"^"_TUser_"^"_TPlace_"^"_TResultType_"^"_TRow_"^"_TFileNo_"^"_TStartDate_"^"_TNum_"^"_TAdvanceDisFlag
	;s ^DHCEQMozy("BatchUpdate")=data_","_job
	If data="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002,"盘点状态信息异常!")
	If job="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002,"盘点单数据异常!")
	s $ZE="ERRORBatchUpdate"
	TSTART
	
	; 更新盘点单明细
	s SQLCODE=0
	s index=0
	f  s index=$o(^DHCEQTemp("InventoryList",+$H,job,index)) quit:(index="")||(SQLCODE'=0)  d
	.s ILRowID=+$g(^DHCEQTemp("InventoryList",+$H,job,index))
	.k PLIST
	.s PLIST(15)=$p(data,"^",1)
	.i PLIST(15)=1 s PLIST(7)=$p($g(^DHCEQTemp("InventoryList",+$H,job,index)),"^",5)
	.s PLIST(22)=$p(data,"^",2)
	.&SQL(Update sqluser.DHC_EQInventoryList values :PLIST() Where IL_RowID=:ILRowID)
	
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,job)
ERRORBatchUpdate
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// add by mwz 20221101 
/// 根据盘盈明细获取展示信息
/// 入参：ExceptionID 盘盈表ID
/// 输出：  EquipName_"^"_EquipNo_"^"_Model_"^"_LeaveFactoryNo_"^"_PlanName_"^"_StoreLoc_"^"_Location
/// w ##Class(web.DHCEQ.EM.BUSInventory).GetBindEquipInfo(2)
ClassMethod GetBindEquipInfo(ExceptionID)
{
	s InventoryDR=$p($g(^DHCEQInventoryException(ExceptionID)),"^",1)
	s EquipName=$p($g(^DHCEQInventoryException(ExceptionID)),"^",2)
	s EquipNo=$p($g(^DHCEQInventoryException(ExceptionID)),"^",3)
	s LeaveFactoryNo=$p($g(^DHCEQInventoryException(ExceptionID)),"^",13)  ///Modefied by zc0125 修正取值问题
	s Model=$p($g(^DHCEQInventoryException(ExceptionID)),"^",5)  ///Modefied by zc0125 修正取值问题
	s PlanDR=$p($g(^DHCEQInventory(InventoryDR)),"^",22)
	s StoreLocDR=$p($g(^DHCEQInventoryException(ExceptionID)),"^",9)
	s LocationDR=$p($g(^DHCEQInventoryException(ExceptionID)),"^",12)
	s (PlanName,StoreLoc,Location)=""  ///Modefied by zc0125 修正取值问题
	i PlanDR'="" s PlanName=$p($g(^DHCEQInventoryPlan(PlanDR)),"^",2)
	;i ModelDR'="" s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)  //机型  ///Modefied by zc0125 修正取值问题
	i StoreLocDR'="" s StoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",StoreLocDR)
	i LocationDR'="" s Location=$p($g(^DHCEQCCode("DHCEQCLocation",LocationDR)),"^",2) 
	
	q EquipName_"^"_EquipNo_"^"_Model_"^"_LeaveFactoryNo_"^"_PlanName_"^"_StoreLoc_"^"_Location
}

/// Modefied by zc0125 2022-12-5 业务处理信息记录
/// w ##Class(web.DHCEQ.EM.BUSInventory).SaveBussInfoByInventory(2,11,24)
ClassMethod SaveBussInfoByInventory(vInventoryExceptionDR, vInventoryListDR, vBussType, vBussID)
{
	i (vInventoryExceptionDR="")&&(vInventoryListDR="") q 0
	i (vBussType="")||(vBussID="") q 0
	s SQLCODE=0
	i vInventoryExceptionDR'=""
	{
		&SQL(Update sqluser.DHC_EQInventoryException set IE_BussType=:vBussType,IE_BussID=:vBussID Where IE_RowID=:vInventoryExceptionDR)
	}
	else
	{
		&SQL(Update sqluser.DHC_EQInventoryList set IL_BussType=:vBussType,IL_BussID=:vBussID Where IL_RowID=:vInventoryListDR)
	}
	Quit SQLCODE
}

/// Modefied by zc0125 2022-12-5  业务处理结果更新
/// w ##Class(web.DHCEQ.EM.BUSInventory).SaveDisposeResultByBussType(11,24)
ClassMethod SaveDisposeResultByBussType(BussType, BussID, EquipDR As %Library.String = "")
{
	i (BussType="")||(BussID="") q 0
	s SQLCODE=0
	s (InventoryExceptionDR,InventoryListDR,DisposeResult)=""
	s InventoryListDR=$o(^DHCEQInventoryList(0,"BussID",BussType,BussID,""))
	i InventoryListDR="" s InventoryExceptionDR=$o(^DHCEQInventoryException(0,"BussID",BussType,BussID,""))
	i (InventoryListDR="")&&(InventoryExceptionDR="") q SQLCODE
	if BussType=11 d
	.s DisposeResult=2
	else  if BussType=22 d
	.s DisposeResult=3
	else  if BussType=23 d
	.s DisposeResult=5
	else  if BussType=34 d
	.s DisposeResult=6
	i InventoryListDR'=""
	{
		&SQL(Update sqluser.DHC_EQInventoryList set IL_DisposeResult=:DisposeResult Where IL_RowID=:InventoryListDR)
	}
	else
	{
		&SQL(Update sqluser.DHC_EQInventoryException set IE_DisposeResult=:DisposeResult,IE_ActerEquipDR=:EquipDR Where IE_RowID=:InventoryExceptionDR)
	}
	Quit SQLCODE
}

/// Modefied by zc0125 2022-12-5 盘盈处理状态更新
ClassMethod UpdateIEDisposeStatus(InventoryExceptionDR, DisposeStatus)
{
	&SQL(Update sqluser.DHC_EQInventoryException set IE_DisposeStatus=:DisposeStatus Where IE_RowID=:InventoryExceptionDR)
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// Modefied by zc0125 2022-12-5 盘盈处理结果更新
ClassMethod UpdateIEDisposeResult(InventoryExceptionDR, DisposeResult)
{
	&SQL(Update sqluser.DHC_EQInventoryException set IE_DisposeResult=:DisposeResult Where IE_RowID=:InventoryExceptionDR)
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// Modefied by zc0125 2022-12-5 盘点处理结果更新
ClassMethod UpdateILDisposeResult(InventoryListDR, DisposeResult)
{
	&SQL(Update sqluser.DHC_EQInventoryList set IL_DisposeResult=:DisposeResult Where IL_RowID=:InventoryListDR)
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
}

/// MZY0146	3132818		2022-12-09
/// w ##Class(web.DHCEQ.EM.BUSInventory).GetDaysNum(10)
ClassMethod GetDaysNum(RowID As %Library.String = "")
{
	q:$p($g(^DHCEQInventory(+RowID)),"^",16)'>0 0
	q +$H-$p($g(^DHCEQInventory(+RowID)),"^",16)
}

/// Add by zc0130 科室盘点结果确认 
/// 2023-2-17 
/// w ##Class(web.DHCEQ.EM.BUSInventory).LocInventory()
ClassMethod LocInventoryAudit(InventoryDR As %String = "", LocDR As %String = "", Status As %String = "")
{
	s $ZT="ERRORLocInventoryAudit"
	s SQLCODE=0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=+$p($H,",",2)
	i Status'=2 d
	.s User=""
	.s Date=""
	.s Time=""
	
 	TSTART
 	
 	if LocDR'=""
 	{
		&SQL(Update sqluser.DHC_EQInventoryAudit Set IA_Status=:Status,IA_AuditUserDR=:User,IA_AuditTime=:Time where IA_InventoryDR=:InventoryDR and IA_LocDR=:LocDR)    
		
	}
	else
	{
		&SQL(Update sqluser.DHC_EQInventoryAudit Set IA_Status=:Status,IA_AuditUserDR=:User,IA_AuditTime=:Time where IA_InventoryDR=:InventoryDR )    
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0)
	
ERRORLocInventoryAudit
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Modefied by zc0131 2023-03-03 批量更新盘点信息
/// w ##Class(web.DHCEQ.EM.BUSInventory).BatchUpdateNew("1^",4800)
ClassMethod BatchUpdateNew(data As %String = "", job As %String = "", InventoryListIDs As %String = "")
{
	If data="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002,"盘点状态信息异常!")
	If job="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002,"盘点单数据异常!")
	i InventoryListIDs="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002,"盘点单数据异常!")
	s StoreLocDR=$p(data,"^",3)
	k PLIST
	s $ZE="ERRORBatchUpdateNew"
	s flag=0
	s SQLCODE=0
	TSTART
	s Length=$l(InventoryListIDs,",")
	for i=1:1:Length
	{
		q:flag'=0
		s InventoryListID=$p(InventoryListIDs,",",i)
		q:InventoryListID=""
		s InventoryDR=$p($g(^DHCEQInventoryList(InventoryListID)),"^",1)
		s PLIST(15)=$p(data,"^",1)
		i $p(data,"^",3)'="" s PLIST(7)=$p(data,"^",3)
		i PLIST(15)=1 s PLIST(7)=$p($g(^DHCEQInventoryList(InventoryListID)),"^",5)
		s PLIST(12)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	;IL_UserDR
		s PLIST(13)=+$H
		s PLIST(14)=+$p($H,",",2)
		s PLIST(22)=$p(data,"^",2)
		&SQL(Update sqluser.DHC_EQInventoryList values :PLIST() Where IL_RowID=:InventoryListID)
		
		if SQLCODE  
		{	
			TRollBack
			Set flag=SQLCODE 
		}
		i InventoryDR'="" s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR)
		if SQLCODE  
		{	
			TRollBack
			Set flag=SQLCODE 
		}
	}
	TCOMMIT
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(flag)
ERRORBatchUpdateNew
	TROLLBACK
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Modefied by zc0132 2023-03-29 获取盘点明细ID串
/// w ##Class(web.DHCEQ.EM.BUSInventory).GetInventoryListDRStr(81280)
ClassMethod GetInventoryListDRStr(Job As %String = "")
{
	; ^DHCEQTemp("DHCEQInventoryListInfo",curuser,+$H,Job,gnum)=TRowID_"^"_TInventoryDR_"^"_TBillEquipDR
	i Job="" q ""
	n InventoryListDRStr,curuser,gnum
	s InventoryListDRStr=""
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user", %session.Get("LOGON.USERID"))	; %session.Get("LOGON.USERID")	331
	
	s gnum=0
	f  s gnum=$o(^DHCEQTemp("DHCEQInventoryListInfo",curuser,+$H,Job,gnum)) quit:(gnum="")  d
	.i InventoryListDRStr'="" s InventoryListDRStr=InventoryListDRStr_","
	.s InventoryListDRStr=InventoryListDRStr_$p($g(^DHCEQTemp("DHCEQInventoryListInfo",curuser,+$H,Job,gnum)),"^",1)
	
	q InventoryListDRStr
}

/// Modefied by zc0132 2023-03-29 盘点输入的编号是否存在
/// w ##Class(web.DHCEQ.EM.BUSInventory).CheckEquipNoInException(2,"LS20220720001")
ClassMethod CheckEquipNoInException(IERowID, IEEquipNo)
{
	s vFlag=0
	i IEEquipNo="" q vFlag
	s rowid=0
	f  s rowid=$o(^DHCEQInventoryException(0,"EquipNo",IEEquipNo,rowid))  quit:(rowid="")||(vFlag'=0)  d
	.q:rowid=IERowID
	.s vFlag=1
	q vFlag
}

}
