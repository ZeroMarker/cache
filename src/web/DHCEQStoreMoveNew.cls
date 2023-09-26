/// -------------------------------
/// 修改:DJ 2010-10-26 
/// 描述:修改CheckStoreMoveLoc方法,增加库房调配控制
/// -------------------------------
/// 创建:zy 2010-03-26  No ZY0019
/// 描述:设备转移
/// --------------------------------
Class web.DHCEQStoreMoveNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter GlobalLen = 23;

ClassMethod MoveTypeList(name, width, Type) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")
	;w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>库房分配</option>"
	w "<option value=1>科室调配</option>"
	w "<option value=3>科室退库</option>"
	//w "<option value=4>库房调配</option>" //2010-10-26 DJ
	w "</select>",!
}

///    ----------------------------------
///    修改:zy 2010-03-26  No ZY0019
///    描述:设备转移单查找
///    flag为1时取被服类组
///    ----------------------------------
/// modify by jyp 2018-08-19 Hisui改造：对日期进行格式转换处理
/// modified by czf 2019-12-16 CZF0051 增加入参CancelOper 
/// Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
Query GetStoreMove(QXType, WaitAD, FromLocDR, ToLocDR, StartDate, EndDate, Status, MoveType, ApproveRole, StoreMoveNo, EquipNo, InvalidFlag As %String = "N", flag As %String = "", CancelOper As %String = "", HospitalDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TStoreMoveNo:%String,TFromLocDR:%String,TToLocDR:%String,TMakerDR:%String,TMakeDate:%String,TAckUserDR:%String,TAckDate:%String,TAckTime:%String,TInAckUserDR:%String,TInAckDate:%String,TInAckTime:%String,TMoveType:%String,TStatus:%String,TRemark:%String,TFromLoc:%String,TToLoc:%String,TMaker:%String,TAckUser:%String,TInAckUser:%String,TReciver:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String,TRow:%String,TListInfo:%String,TApprovals:%String")
{
}

ClassMethod GetStoreMoveExecute(ByRef qHandle As %Binary, QXType, WaitAD, FromLocDR, ToLocDR, StartDate, EndDate, Status, MoveType, ApproveRole, StoreMoveNo, EquipNo, InvalidFlag As %String = "N", flag As %String = "", CancelOper As %String = "", HospitalDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s CurLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept", %session.Get("LOGON.CTLOCID"))

 	i StartDate=""  d
 	.s StartDate=0
 	e  d
 	.s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")-1
 	i EndDate=""  d
 	.s EndDate=+$H
 	e  d
 	.s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	//end add by jyp 2018-08-09
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
	s EquipTypeValues=""
	i flag="1"  s EquipTypeValues=##class(web.DHCEQCommon).GetSysInfo("990024")
	i EquipTypeValues'="" s EquipTypeValues=","_EquipTypeValues_","
	s index=1
	s rowid=0
	s TRow=0
	d BuildDataGetStoreMove
	Quit $$$OK
BuildDataGetStoreMove
	f  s rowid=$o(^DHCEQStoreMove(rowid))  quit:rowid=""  d
	.d ResetVariablesGetStoreMove
	.s TRowID = rowid
	.s SMFlag=$p($g(^DHCEQStoreMove(rowid)),"^",27)
	.i SMFlag="" s SMFlag="N"	
	.s TStatus = $p($g(^DHCEQStoreMove(rowid)),"^",13)
	.q:(CancelOper="Y")&&(TStatus'=3)&&(InvalidFlag'="")&&(InvalidFlag'=SMFlag)	//modified by CZF0060 转移作废界面过滤未作废的无效单据
	.q:(CancelOper'="Y")&&(InvalidFlag'="")&&(InvalidFlag'=SMFlag)		//modified by CZF0060 2020-02-20 非转移作废界面过滤所有无效单据
	.s TStoreMoveNo = $p($g(^DHCEQStoreMove(rowid)),"^",1)
	.q:(StoreMoveNo'="")&&($e(TStoreMoveNo,1,$l(StoreMoveNo))'=StoreMoveNo)
	.s Find=##Class(web.DHCEQInStockNew).CheckOrderEqNo("StoreMove",rowid,EquipNo)
	.q:(EquipNo'="")&&(Find=0)
	.s TEquipTypeDR=$p($g(^DHCEQStoreMove(rowid)),"^",16) //modefy BY:GBX
	.q:(flag'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
	.s TFromLocDR = $p($g(^DHCEQStoreMove(rowid)),"^",2)
	.q:(FromLocDR'="")&&(FromLocDR'=TFromLocDR)
	.s TToLocDR = $p($g(^DHCEQStoreMove(rowid)),"^",3)
	.q:(ToLocDR'="")&&(ToLocDR'=TToLocDR)	
	.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TToLocDR) ;Add QW20210629 BUG:QW0131
	.q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
	.s Flag=0
	.i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TFromLocDR))) s Flag=Flag+1 //2010-10-26 DJ
	.i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TToLocDR))) s Flag=Flag+1 //2010-10-26 DJ
	.q:Flag=2
	.i StartDate="" s StartDate=0
	.i EndDate="" s EndDate=+$h
	.q:($p($g(^DHCEQStoreMove(rowid)),"^",5)>EndDate)||($p($g(^DHCEQStoreMove(rowid)),"^",5)<StartDate)	
	.s TMoveType = $p($g(^DHCEQStoreMove(rowid)),"^",12)
	.q:(MoveType'="")&&(MoveType'=TMoveType)
	.q:(Status'="")&&(TStatus'=Status)
	.q:(WaitAD="on")&&(TStatus="0")	
	.s TEquipTypeDR=$p($g(^DHCEQStoreMove(rowid)),"^",16)
	.q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR) //安全组可访问类组	
	.i TFromLocDR '=""  d
	..s TFromLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TFromLocDR) //add by zx 2018-08-16
	.i TToLocDR '=""  d
	..s TToLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TToLocDR) //add by zx 2018-08-16
	.s TMakerDR = $p($g(^DHCEQStoreMove(rowid)),"^",4)
	.i TMakerDR '=""  d
	..s TMaker = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TMakerDR) //add by zx 2018-08-16
	.s TMakeDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(rowid)),"^",5),"date")
	.s TAckUserDR = $p($g(^DHCEQStoreMove(rowid)),"^",6)
	.i TAckUserDR '=""  d
	..s TAckUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAckUserDR) //add by zx 2018-08-16
	.s TAckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(rowid)),"^",7),"date")
	.s TAckTime = $p($g(^DHCEQStoreMove(rowid)),"^",8)
	.s TInAckUserDR = $p($g(^DHCEQStoreMove(rowid)),"^",9)
	.i TInAckUserDR '=""  d
	..s TInAckUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TInAckUserDR) //add by zx 2018-08-16
	.s TInAckDate = ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQStoreMove(rowid)),"^",10),"date")
	.s TInAckTime = $p($g(^DHCEQStoreMove(rowid)),"^",11)
	.s TMoveType = $CASE(TMoveType,"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配",:"没有定义") //modify by wl 2020-03-13 WL0062
	.s TStatus = $CASE(TStatus,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")		//add by CZF 0060 2020-02-20
	.s TRemark = $p($g(^DHCEQStoreMove(rowid)),"^",14)
	.s TReciverDR=$p($g(^DHCEQStoreMove(rowid)),"^",15)
	.i TReciverDR'="" s TReciver=##Class(web.DHCEQCommon).GetTrakNameByID("user", TReciverDR) //add by zx 2018-08-16
	.i TEquipTypeDR '=""  d
	..s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TStatCatDR=$p($g(^DHCEQStoreMove(rowid)),"^",17)
	.//Modified By QW20191213 需求号:1127741 
	.i TStatCatDR =""  d
	..s tmpList=+$o(^DHCEQStoreMoveList("0","StoreMove",rowid,""))
	..i $p($g(^DHCEQStoreMoveList(tmpList)),"^",3)="Y" d
	...s tmpDR=$p($g(^DHCEQStoreMoveList(tmpList)),"^",4)
	...i tmpDR'="" s TStatCatDR=$p($g(^DHCEQInStockList(tmpDR)),"^",17) 
	..i TStatCatDR =""  d 
	...s tmpDR=$p($g(^DHCEQStoreMoveList(tmpList)),"^",2)
	...i tmpDR'="" s TStatCatDR=$p($g(^DHCEQEquip(tmpDR)),"^",75)
	.//Modified By QW20191213 需求号:1127741 
	.s TStatCat = ##Class(web.DHCEQCommon).GetTrakNameByID("statcat", TStatCatDR)
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.s TApprovals="无"
	.s (CurRole,NextStepID,AppSetDR)=""
	.i AIRowID'="" d
	..s AppSetDR=$p(^DHCEQApproveInfo(AIRowID),"^",3)
	..s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	..s TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	..i TApproveRole'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	//add by CZF0080 2020-02-24
	..s NextStepID=$p(^DHCEQApproveInfo(AIRowID),"^",5)		//czf 20210526
	.i $p($g(^DHCEQStoreMove(rowid)),"^",13)=0 s TApprovals="" //modified by czf 1214221 2020-03-05
	.q:((WaitAD="on")&&(CurRole'="")&&(CurRole'=ApproveRole))
	.s (AppFlowID,HospLimit)=""		//czf 2021-09-01 begin
	.i (AppSetDR'="")&&(NextStepID'="") d
	..s AppFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSetDR,NextStepID,""))
	..i AppFlowID'="" s HospLimit=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AppFlowID)),"^",20)
	.q:(WaitAD="on")&&(ApproveRole=CurRole)&&(##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(THospitalDR,"","","",HospLimit)) //czf 2021-09-01 end
	.// MZY0070		1756582		2021-02-20
	.s ApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
	.s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, TEquipTypeDR, "", "", "","", "MoveType,DHCEQStoreMove,"_$p($g(^DHCEQStoreMove(rowid)),"^",12))
	.s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, rowid, NextStepID, "")		//czf 20210526
	.s ActionDR=+$P(ApproveFlow,"^",6)
	.;Modify by zx 2021-12-29 根据QXType过滤
	.;q:(WaitAD="on")&&($p($g(^DHCEQCCode("DHCEQCAction",ActionDR)),"^",1)="Move_Receive")&&(##Class(web.DHCEQCommon).ISPreLoc(TToLocDR,CurLocDR)=0)  ;Add By QW20210706 BUG:QW0138
	.
	.// Mozy0231	访问资金来源类型
	.;Mozy0247		1190772		2020-02-17
	.s TMPCount=0
	.s Flag=0
	.s lrowid=0 
	.f  s lrowid=$o(^DHCEQStoreMoveList(0,"StoreMove",rowid,lrowid)) quit:(lrowid="")||(Flag'=0)  d
	..s Flag=##class(web.DHCEQCommon).FundsTypeIsIn(4,lrowid)
	..s TMPCount=TMPCount+1		;计数,只显示前两条
	..i TMPCount<3 d
	...i TListInfo'="" s TListInfo=TListInfo_";"
	...s TListInfo=TListInfo_$p($g(^DHCEQStoreMoveList(lrowid)),"^",5)_","_$p($g(^DHCEQStoreMoveList(lrowid)),"^",7)_","_$p($g(^DHCEQStoreMoveList(lrowid)),"^",8)_##class(web.DHCEQCommon).GetTrakNameByID("uom",$p($g(^DHCEQStoreMoveList(lrowid)),"^",10))
	.i TMPCount>2 s TListInfo=TListInfo_";..."
	.q:Flag'=0
	.s TRow=TRow+1
	.d OutputRowGetStoreMove
	quit
OutputRowGetStoreMove
	s Data=$lb(TRowID,TStoreMoveNo,TFromLocDR,TToLocDR,TMakerDR,TMakeDate,TAckUserDR,TAckDate,TAckTime,TInAckUserDR,TInAckDate,TInAckTime,TMoveType,TStatus,TRemark,TFromLoc,TToLoc,TMaker,TAckUser,TInAckUser,TReciver,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TRow,TListInfo,TApprovals)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMove
	s (TRowID,TStoreMoveNo,TFromLocDR,TToLocDR,TMakerDR,TMakeDate,TAckUserDR,TAckDate,TAckTime,TInAckUserDR,TInAckDate,TInAckTime,TMoveType,TStatus,TRemark,TFromLoc,TToLoc,TMaker,TAckUser,TInAckUser,TReciver,TReciverDR,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TListInfo,TApprovals)=""
	quit
}

ClassMethod GetStoreMoveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveExecute ]
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

ClassMethod GetStoreMoveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

///    ----------------------------------
///    修改:zy 2010-03-26  No ZY0019
///    描述:设备转移单明细信息
///    ----------------------------------
Query GetStoreMoveList(RowID) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEquip:%String,TBatchFlag:%String,TInStockListDR:%String,TManuFactoryDR:%String,TManuFactory:%String,TOriginalFee:%String,TQuantityNum:%String,TTotalFee:%String,TModelDR:%String,TModel:%String,TUnitDR:%String,TUnit:%String,TRemark:%String,TMoveNum:%String,TRow:%String,TJob:%String,TFlag:%String,TLocation:%String,TLocationDR:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TCommonName:%String")
{
}

ClassMethod GetStoreMoveListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
 	new repid, index,rowid,TRow
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s Job=$J
 	i RowID'="" s StoreLoc=$p($g(^DHCEQStoreMove(RowID)),"^",2)
 	i RowID'="" s SMEquipType=$p($g(^DHCEQStoreMove(RowID)),"^",16)
 	i RowID'="" s SMStatCat=$p($g(^DHCEQStoreMove(RowID)),"^",17)
	s (TotalQty,Amount,TotalLoc)=0
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	s TRow=0
	d BuildDataGetStoreMoveList
	Quit $$$OK
BuildDataGetStoreMoveList
	i RowID'=""
	{
		f  s rowid=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,rowid))  quit:rowid=""  d
		.d ResetVariablesGetStoreMoveList
		.s TRowID = rowid
		.s TRow=TRow+1
		.s TEquipDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",2)
		.i TEquipDR'="" s TMoveNum=1
		.s TBatchFlag = $p($g(^DHCEQStoreMoveList(rowid)),"^",3)
		.s TInStockListDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",4)
		.i (TInStockListDR '="")&&(TBatchFlag="Y")  d
		..s TSourceType = $p($g(^DHCEQInStockList(TInStockListDR)),"^",18)  ;SourceType
		..s TSourceID = $p($g(^DHCEQInStockList(TInStockListDR)),"^",19)  	;SourceID
		..i (TSourceType=1) s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",3)
		..i (TSourceType=2) s EquipTypeDR=$p($g(^DHCEQOpenCheckList(TSourceID)),"^",3)
		..s TMoveNum=..GetTotalMoveQuantity(StoreLoc,TInStockListDR,EquipTypeDR,SMStatCat)
		..s MovedQuantity=..GetMoveListQuantity(TInStockListDR,rowid,"StoreMove")
		..s TMoveNum=TMoveNum-MovedQuantity
		.s TCommonName = $p($g(^DHCEQStoreMoveList(rowid)),"^",5)	//2013-06-24 DJ0118 begin
		.i TInStockListDR'=""  d
		..s TEquip=$p($g(^DHCEQInStockList(TInStockListDR)),"^",16)
		.e  d
		..s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",7)
		.i TEquip'="" s TEquip=$p($g(^DHCEQCCode("DHCEQCMasterItem",TEquip)),"^",1) //2013-06-24 DJ0118 end
		.s TManuFactoryDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",6)
		.i TManuFactoryDR '=""  d
		..s TManuFactory =##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) // $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
		.s TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(rowid)),"^",7),"")
		.s TQuantityNum = $p($g(^DHCEQStoreMoveList(rowid)),"^",8)
		.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee*TQuantityNum,"")
		.;s TotalQty=TotalQty+TQuantityNum	// Mozy0217  2018-11-01
		.;s Amount=Amount+TTotalFee
		.s TModelDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",9)
		.i TModelDR '=""  d
		..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		.s TUnitDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",10)
		.i TUnitDR '=""  d
		..s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		.s TRemark = $p($g(^DHCEQStoreMoveList(rowid)),"^",11)
		.s TJob=Job
		.i TEquipDR'="" d
		..s TFlag="1"
		.//add by zy 2012-04-13 ZY0092  出库明细增加存放地点和保留字段
		.s TLocationDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",12)
		.i TLocationDR'="" s TLocation = $p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
		.s THold1 = $p($g(^DHCEQStoreMoveList(rowid)),"^",13)
		.s THold2 = $p($g(^DHCEQStoreMoveList(rowid)),"^",14)
		.s THold3 = $p($g(^DHCEQStoreMoveList(rowid)),"^",15)
		.s THold4 = $p($g(^DHCEQStoreMoveList(rowid)),"^",16)
		.s THold5 = $p($g(^DHCEQStoreMoveList(rowid)),"^",17)
		.i THold3="" d
		..;过滤配置设备统计	// Mozy0217  2018-11-01
		..s TotalQty=TotalQty+TQuantityNum
		..s Amount=Amount+TTotalFee
		.d OutputRowGetStoreMoveList
	}
	i TRow=0 d
	.d ResetVariablesGetStoreMoveList
	.s TRow=1
	.s TJob=Job
	.d OutputRowGetStoreMoveList
	i TotalFlag="1" s TotalLoc=1
	i TotalFlag="2" s TotalLoc=index+1
	i TotalLoc'=0
	{
		d ResetVariablesGetStoreMoveList
		s TRowID=-1
		s TRow="合计"
		s TQuantityNum=TotalQty
		s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(Amount,"")
		s index=TotalLoc
		s TJob=Job
		d OutputRowGetStoreMoveList
	}
	quit
OutputRowGetStoreMoveList
	s Data=$lb(TRowID,TEquipDR,TEquip,TBatchFlag,TInStockListDR,TManuFactoryDR,TManuFactory,TOriginalFee,TQuantityNum,TTotalFee,TModelDR,TModel,TUnitDR,TUnit,TRemark,TMoveNum,TRow,TJob,TFlag,TLocation,TLocationDR,THold1,THold2,THold3,THold4,THold5,TCommonName)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMoveList
	s (TRowID,TEquipDR,TEquip,TBatchFlag,TInStockListDR,TManuFactoryDR,TManuFactory,TOriginalFee,TQuantityNum,TTotalFee,TModelDR,TModel,TUnitDR,TUnit,TRemark,TMoveNum,TJob,TFlag,TLocation,TLocationDR,THold1,THold2,THold3,THold4,THold5,TCommonName)=""
	quit
}

ClassMethod GetStoreMoveListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveListExecute ]
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

ClassMethod GetStoreMoveListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Mozy0217  2018-11-01	 增加附属设备信息输入
/// 		Modified by JDL 2011-8-25  JDL0093
/// 		重写此方法，调整逻辑，批量时设备编号信息应为空
/// 		解决单据中，不能单台转移多个同批设备的问题	
/// 		入参：	RowID：转移明细或退货明细RowID
/// 				FromLocDR：转移自库房
/// 				EquipTypeDR：类组
/// 				StatCatDR：类型
/// 				StockStatus：库房状态
/// 				ProviderDR：供应商
/// 				ListType：1转移 2退货
/// 				Equip：过滤条件，可以是名称、代码、出厂编号、入库单号
/// 				InStockNo：入库单号
/// 				UseLocDR：减少单时用到，直接从使用部门减少 
/// 				TFlag：是否单台方式检索，true是，其他否///		
/// 				Type: 为1时取被服类组		
///    ----------------------------------
///    修改:zy 2009-12-02  No ZY0019
///    描述:转移设备查找
///    ----------------------------------
///    Modefied by zc 2014-9-23 zc0007
///    在GetInStockList中添加TCommonName参数
///    w ##class(%ResultSet).RunQuery("web.DHCEQStoreMoveNew","GetInStockList","","","","","","","","","15010400011")
Query GetInStockList(RowID, FromLocDR, EquipTypeDR, StatCatDR, StockStatus, ProviderDR, ListType, Equip, InStockNo, UseLocDR As %String = "", TFlag As %String = "", Type As %String = "", AllListInfo As %String = "") As %Query(ROWSPEC = "Name:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,Model:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,Quantity:%String,OriginalFee:%String,ISNo:%String,EquipNo:%String,HIDDEN:%String,RequestLoc:%String,TLocationDR:%String,TLocation:%String,TInDate:%String,TCommonName:%String,TRemark:%String,FileNo:%String,THasConfig:%String,TConfigDR:%String")
{
}

ClassMethod GetInStockListExecute(ByRef qHandle As %Binary, RowID, FromLocDR, EquipTypeDR, StatCatDR, StockStatus, ProviderDR, ListType, Equip, InStockNo, UseLocDR As %String = "", TFlag As %String = "", Type As %String = "", AllListInfo As %String = "") As %Status
{
 	new repid, index,rowid
	s repid=$I(^CacheTemp)
 	s qHandle=$lb(0,repid,0)
	s index=1
	S Equip=$ZCONVERT(Equip,"U")
	i FromLocDR="" q $$$OK
	i StockStatus="" q $$$OK
	
	i UseLocDR'="" s FromLocDR=UseLocDR
	s EquipTypeValues=""
	i Type="1"  s EquipTypeValues=##class(web.DHCEQCommon).GetSysInfo("990024")
	i EquipTypeValues'="" s EquipTypeValues=","_EquipTypeValues_","
	//Add By DJ 2017-11-20
	s TCurListRow=$p(AllListInfo,"=",1)
	s TJob=$p(AllListInfo,"=",2)
	s TAllListInfo=$p(AllListInfo,"=",3)
	s TAllListCount=$L(TAllListInfo,"&")
	
	s TEquipTypeDR=0	
	f  s TEquipTypeDR=$o(^DHCEQEquip(0,"StoreInStock",FromLocDR,TEquipTypeDR)) q:TEquipTypeDR=""  d
	.q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.q:+result'=0
	.s TInStockListID=""
	.f  s TInStockListID=$o(^DHCEQEquip(0,"StoreInStock",FromLocDR,TEquipTypeDR,StockStatus,"N",TInStockListID)) q:TInStockListID=""  d
	..s (TInStockNo,TInvoiceNo)=""
	..i TInStockListID>0 d
	...s TInStockNo=$P($G(^DHCEQInStock($p($g(^DHCEQInStockList(TInStockListID)),"^",1))),"^",14)
	...q:##Class(web.DHCEQFinance2019).BussFilter(21,TInStockListID)'=0   //Add By QW 2019-01-14  bug:QW0025  比较设备项与业务单据类组是否一致
	...q:(InStockNo'="")&&(TInStockNo'[InStockNo)
	...s TInvoiceNo=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,TInStockListID)
	...s TInvoiceNo=$p(TInvoiceNo,"^",1)
	..q:(InStockNo'="")&&(TInStockNo'[InStockNo)
	..
	..i TFlag="true"  d
	...s InStockListID=0
	..e  d
	...s InStockListID=TInStockListID
	..
	..s Num=0
	..s EquipID=""
	..s TEquipDR=0
	..f  s TEquipDR=$o(^DHCEQEquip(0,"StoreInStock",FromLocDR,TEquipTypeDR,StockStatus,"N",TInStockListID,TEquipDR)) q:TEquipDR=""  d
	...d ResetVariablesGetInStockList
	...s CurFlag=0		//Add By DJ 2017-11-20 begin
	...s CurListNo=0
	...f CurListNo=1:1:TAllListCount  d
	....q:CurFlag'=0
	....s CurListInfo=$p(TAllListInfo,"&",CurListNo)
	....q:CurListInfo=""
	....s TCurListID=$p(CurListInfo,"^",1)
	....s TCurMXRowID=$p(CurListInfo,"^",2)
	....i TCurListRow'=TCurListID  d
	.....i TCurMXRowID'=""  d
	......s TCurRowIDs=$g(^TEMPEQ("MXList",TJob,TCurMXRowID))
	.....e  d
	......s TCurRowIDs=$g(^TEMPEQ("MXList","EX",TJob,TCurListID))
	.....i (","_TCurRowIDs_",")[(","_TEquipDR_",") s CurFlag=1
	...q:CurFlag'=0		//Add By DJ 2017-11-20 end
	...s TProviderDR=$p($g(^DHCEQEquip(TEquipDR)),"^",25)		;provderDR
	...q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	...s TStatus=$p($g(^DHCEQEquip(TEquipDR)),"^",38)		;TStatus
	...q:(TStatus="3")||(TStatus="4")
	...s TStatCatDR=$p($g(^DHCEQEquip(TEquipDR)),"^",75)
	...q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)
	...s TEquipTypeDR=$p($g(^DHCEQEquip(TEquipDR)),"^",63) //modefy BY:GBX
	...;q:(Type'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))  //modefy BY:ZC  2015-03-25
	...;s TName = $ZCONVERT($p($g(^DHCEQEquip(TEquipDR)),"^",1),"U")  //modefy BY:ZC  2015-03-25
	...s TName=$p($g(^DHCEQEquip(TEquipDR)),"^",7) //2013-06-24 DJ0118 begin
	...i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1)
	...s TName=$ZCONVERT(TName,"U")	//2013-06-24 DJ0118 end
	...s TCode=$p($g(^DHCEQEquip(TEquipDR)),"^",6)					;Code
	...s TLeaveFactoryNo=$p($g(^DHCEQEquip(TEquipDR)),"^",10)		;LeaveFactoryNo
	...s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	...q:(Equip'="")&&(TName'[Equip)&&($ZCONVERT(TCode,"U")'[Equip)&&($ZCONVERT(TLeaveFactoryNo,"U")'[Equip)&&($ZCONVERT(TEquipNo,"U")'[Equip)&&($ZCONVERT(TInStockNo,"U")'[Equip)
	...
	...q:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR(RowID,TEquipDR,FromLocDR,ListType)'=0
	...;InStockListID为0时,按单台显示
	...//add by zy 2012-04-13 ZY0092  出库明细增加存放地点信息
	...s TLocationDR=$p($g(^DHCEQEquip(TEquipDR)),"^",72)
	...i TLocationDR'="" s TLocation = $p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	...i InStockListID=0  d
	....s Num=1
	....s EquipID=TEquipDR
	....d EquipInfo
	...e  d
	....s Num=Num+1
	....;只有一台时,也按单台处理
	....i Num=1 s EquipID=TEquipDR
	....i Num>1 s EquipID=""
	..;批量的,按入库明细显示
	..i ((InStockListID>0)&&(Num>0))  d
	...d EquipInfo
	
	Quit $$$OK
EquipInfo
	;单台取设备信息
	i EquipID'=""  d
	.s InStockListID=0
	.s TCommonName = $p($g(^DHCEQEquip(EquipID)),"^",1)	//2013-06-24 DJ0118 begin
	.s TName=$p($g(^DHCEQEquip(EquipID)),"^",7)
	.i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1)
	.i $Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",24)'="" s TCommonName="(附)"_TCommonName	;// Mozy0217  2018-11-01
	.s TCode=$p($g(^DHCEQEquip(EquipID)),"^",6)					;Code
	.s TLeaveFactoryNo=$p($g(^DHCEQEquip(EquipID)),"^",10)		;LeaveFactoryNo
	.s TProviderDR=$p($g(^DHCEQEquip(EquipID)),"^",25)		;provderDR
	.s TStatus=$p($g(^DHCEQEquip(EquipID)),"^",38)		;TStatus
	.s TStatCatDR=$p($g(^DHCEQEquip(EquipID)),"^",75)
	.s TEquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
	.s TModelDR=$p($g(^DHCEQEquip(EquipID)),"^",3)
	.s TUnitDR=$p($g(^DHCEQEquip(EquipID)),"^",5)
	.s TManuFactoryDR=$p($g(^DHCEQEquip(EquipID)),"^",26)
	.s TOriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
	.s TInDate=$p($g(^DHCEQEquip(EquipID)),"^",45)
	.s ISLRowID=$p($g(^DHCEQEquip(EquipID)),"^",70)
	.s TRemark=""
	.i ISLRowID'=""  d
	..s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	..s TRemark=$p($g(^DHCEQInStockList(ISLRowID)),"^",12)
	..;s TRemark=$p($g(^DHCEQInStock(ISRowID)),"^",11)
	.;// Mozy0217  2018-11-01
	.;i ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(2,EquipID)'="" s THasConfig="Y"		;;;;;;预留
	.i THasConfig'="Y" d
	..s TOpenCheckListDR=$p($g(^DHCEQEquip(EquipID)),"^",77)
	..i ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1,TOpenCheckListDR)'="" s THasConfig="Y"
	.s TConfigDR=$Piece($Get(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)				; EQHold13
	.i TConfigDR'="" s THasConfig="N"									; 过滤配置设备
	e  d
	.;批量取入库明细信息
	.s EquipID=""
	.s TCommonName = $p($g(^DHCEQInStockList(InStockListID)),"^",5)	//2013-06-24 DJ0118 begin
	.s TName=$p($g(^DHCEQInStockList(InStockListID)),"^",16)
	.i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1) //2013-06-24 DJ0118 end
	.i $p($g(^DHCEQInStockList(TInStockListID)),"^",22)'="" s TCommonName="(附)"_TCommonName	// Mozy0217  2018-11-01	配置设备
	.s TCode=""
	.s TLeaveFactoryNo=""
	.s TProviderDR=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",17)
	.s TStatus=""
	.s TStatCatDR=$p($g(^DHCEQInStockList(InStockListID)),"^",17)
	.s TEquipNo=""
	.s TModelDR=$p($g(^DHCEQInStockList(InStockListID)),"^",9)
	.s TUnitDR=$p($g(^DHCEQInStockList(InStockListID)),"^",10)
	.s TManuFactoryDR=$p($g(^DHCEQInStockList(InStockListID)),"^",6)
	.s TOriginalFee=$p($g(^DHCEQInStockList(InStockListID)),"^",7)
	.s TInDate=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(InStockListID)),"^",1))),"^",1)
	.s ISRowID=$p($g(^DHCEQInStockList(InStockListID)),"^",1)
	.s TRemark=$p($g(^DHCEQInStockList(InStockListID)),"^",12)
	.;// Mozy0217  2018-11-01
	.s TOpenCheckListDR=$p($g(^DHCEQInStockList(InStockListID)),"^",19)
	.i ##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1,TOpenCheckListDR)'="" s THasConfig="Y"
	.s TConfigDR=$Piece($Get(^DHCEQInStockList(InStockListID)),"^",22)
	.i TConfigDR'="" s THasConfig="N"
	
	s TQuantity=Num
	i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	i (+InStockListID'=0)  d //2012-03-12 DJ begin
	.s OCLDR=$p($g(^DHCEQInStockList(InStockListID)),"^",19)
	.i OCLDR'=""  d
	..s RequestLocDR=$p($g(^DHCEQOpenCheckList(OCLDR)),"^",33)
	..i RequestLocDR'="" s RequestLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", RequestLocDR)
	i TInDate'="" s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	d OutputRowGetInStockList
	quit
OutputRowGetInStockList
	s Data=$lb(TName,EquipID,InStockListID,TModelDR,TModel,TManuFactoryDR,TManuFactory,TUnitDR,TUnit,TQuantity,TOriginalFee,TInStockNo,TEquipNo,TInvoiceNo,RequestLoc,TLocationDR,TLocation,TInDate,TCommonName,TRemark,FileNo,THasConfig,TConfigDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockList
	s (TName,TModelDR,TModel,TManuFactoryDR,TManuFactory,TUnitDR,TUnit,TOriginalFee,TEquipNo,RequestLoc,TLocationDR,TLocation,TInDate,TCommonName,TRemark,FileNo,TOpenCheckListDR,TConfigDR)=""
	s THasConfig="N"	;无配置设备
	quit
}

ClassMethod GetInStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockListExecute ]
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

ClassMethod GetInStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQStoreMoveNew).GetOneStoreMove("197")
ClassMethod GetOneStoreMove(rowid)
{
	new (rowid)
	s (result,resultex,FromLocCode,ToLocCode)=""
	s result= ^DHCEQStoreMove(rowid)
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	;FromLocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	.s FromLocCode=$p(^CTLOC($p(result,"^",2)),"^",1)
	s resultex=resultex_"^"	;ToLocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	.s ToLocCode=$p(^CTLOC($p(result,"^",3)),"^",1)
	s resultex=resultex_"^"	;MakerDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",4))
	s $p(result,"^",5)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")	;MakeDate
	s resultex=resultex_"^"	;AckUserDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",6))
	s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;AckDate
	s resultex=resultex_"^"	;InAckUserDR
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",9))
	s $p(result,"^",10)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date") ;InAckDate
	s resultex=resultex_"^"	;ReciverDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",15))
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",16))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",17))),"^",2)
	s apprInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("14",rowid)
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result_resultex_"^"_FromLocCode_"^"_ToLocCode_"^"_$CASE($p(result,"^",12),"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退货","4":"库房调配",:"没有定义")_"^"_apprInfo //2010-10-26 DJ
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:取台账中可以转移的设备数量
/// w ##Class(web.DHCEQStoreMoveNew).GetTotalMoveQuantity("1276","426","1","5")
/// ----------------------------------
ClassMethod GetTotalMoveQuantity(Stock, InStockList, EquipType, StatCat)
{
	s Total=0
	s EQRowID=0									//1276	1					301
	f  s EQRowID=$O(^DHCEQEquip(0,"StoreInStock",Stock,EquipType,"1","N",InStockList,EQRowID)) q:EQRowID=""  d
	.s Total=Total+1
	q Total
}

/// add by csj 20190830
/// 描述:由GetTotalMoveQuantity改写而来，取没有通过审核的设备数量(即单据占用数量)
/// 添加入参：Type:MXRowID类型，1转移单 2退货单 
/// 	  	  MXRowID:单据明细id
/// w ##Class(web.DHCEQStoreMoveNew).GetTotalOccupyQuantity("1276","426","1","5","2","93")
ClassMethod GetTotalOccupyQuantity(Stock, InStockList, EquipType, StatCat, Type As %String = "", MXRowID As %String = "")
{
	s Total=0
	s EQRowID=0									//1276	1					301
	f  s EQRowID=$O(^DHCEQEquip(0,"StoreInStock",Stock,EquipType,"1","N",InStockList,EQRowID)) q:EQRowID=""  d
	.i (Type'="")&&(##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR(MXRowID,EQRowID,Stock,Type)'=0) s Total=Total+1
	q Total
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:取转移单中没有通过审核的设备数量
/// w ##Class(web.DHCEQStoreMoveNew).GetMoveListQuantity("364","")
/// ----------------------------------
ClassMethod GetMoveListQuantity(InStockList, RowID, OrderType)
{
	new (InStockList, RowID,OrderType)
	s (Total,SMTotal,RTotal)=0
	s SMLRowID=0
	f  s SMLRowID=$O(^DHCEQStoreMoveList(0,"InStockList",InStockList,SMLRowID)) q:SMLRowID=""  d
	.s TSMRowID= $p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
	.//add by zy 2012-04-13 ZY0092  获取转移和退货数量时，去掉无效单据
	.q:$p($g(^DHCEQStoreMove(TSMRowID)),"^",27)="Y"
	.q:(SMLRowID=RowID)&&(RowID'="")&&(OrderType="StoreMove")
	.s TSMStatus= $p($g(^DHCEQStoreMove(TSMRowID)),"^",13)
	.q:TSMStatus="2"
	.s SMQuantity= $p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
	.s SMTotal=SMTotal+SMQuantity
	s RLRowID=0
	f  s RLRowID=$O(^DHCEQReturnList(0,"InStockList",InStockList,RLRowID)) q:RLRowID=""  d
	.s TRRowID= $p($g(^DHCEQReturnList(RLRowID)),"^",1)
	.//add by zy 2012-04-13 ZY0092  获取转移和退货数量时，去掉无效单据
	.q:$p($g(^DHCEQReturn(TRRowID)),"^",28)="Y"
	.q:(RLRowID=RowID)&&(RowID'="")&&(OrderType="Return")
	.s TRStatus= $p($g(^DHCEQReturn(TRRowID)),"^",13)
	.q:TRStatus="2"
	.s RQuantity= $p($g(^DHCEQReturnList(RLRowID)),"^",5)
	.s RTotal=RTotal+RQuantity
	s Total=SMTotal+RTotal
	q Total
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:新增、更新
/// w ##Class(web.DHCEQStoreMoveNew).SaveData("258^1276^2^0^^^1^^1^^^2248","1^371^^364^担架车^^90^5^^1601^","0,-1")
/// ----------------------------------
ClassMethod SaveData(val, valList, DelRowid)
{
	new RowID
	k PLIST
	Set $ZT="ERRORSave"
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID = $p(val,"^",1)	;RowID
	s User=$p(val,"^",9)
	s PLIST(3) = $p(val,"^",2)	;FromLocDR
	s PLIST(4) = $p(val,"^",3)	;ToLocDR
	s PLIST(5) = User			;MakerDR
	s PLIST(6) = Date			;MakeDate
	s PLIST(13) = $p(val,"^",4)	;MoveType
	s PLIST(14) = "0"			;Status
	s PLIST(15) = $p(val,"^",5)	;Remark
	s PLIST(16) = $p(val,"^",6)	;ReciverDR
	s PLIST(17) = $p(val,"^",7)	;EquipTypeDR
	s PLIST(18) = $p(val,"^",8) ;StatCatDR
	s PLIST(28) = "N"
	s Job = $p(val,"^",12) 		;$job
	i RowID'="" //2011-10-31 DJ DJ0098
	{
		s InvalidFlag=$p($g(^DHCEQStoreMove(RowID)),"^",27)
		i InvalidFlag="Y" q -1015
	}
	TSTART
	if RowID=""
	{
		s MoveTypeCode=..GetMoveTypeCode($p(val,"^",4))
		s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQStoreMove",+$H,"",$p(val,"^",7),"","",MoveTypeCode)
		&SQL(insert into sqluser.DHC_EQStoreMove values :PLIST())
	}
	else
	{
		&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)

	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s RowID=$G(%ROWID)	
 	s SQLCODE=..JudgeSMLQuantityNum(RowID,Job,valList)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	s SQLCODE=..DeleteStoreMoveList(RowID,DelRowid)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	s SQLCODE=..SaveStoreMoveList(RowID,Job,valList)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	
 	;Modified by JDL 2011-8-25 JDL0094 检查是否设备已经被其他单据占用
 	s SQLCODE=##Class(web.DHCEQStoreMoveNew).CheckOrder(1,RowID)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	
 	TCOMMIT
 	q RowID
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:删除
/// w ##Class(web.DHCEQStoreMoveNew).DeleteData("")
/// ----------------------------------
ClassMethod DeleteData(val)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	;Modified By JDL 2011-10-12 JDL0098 保留变量User
	new (val,User)
	s RowID=$P(val,"^",1)
	s ApproveSet=$P(val,"^",11)
	Set $ZT="ERRORDelete"
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART
	&SQL(Update SQLUSER.DHC_EQStoreMove Set SM_InvalidFlag='Y',SM_CancelUser=:User,SM_CancelDate=:Date,SM_CancelTime=:Time where SM_RowID=:RowID)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	TCOMMIT
 	q SQLCODE
ERRORDelete 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:提交
/// w ##Class(web.DHCEQStoreMoveNew).SubmitData("206^1276^4^0^^^1^5^1^^29^")
/// ----------------------------------
ClassMethod SubmitData(val)
{
	new (val, %session)
	k PLIST
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORSubmit"
	s RowID = $p(val,"^",1)	;RowID
	i RowID'="" //2011-10-31 DJ DJ0098
	{
		s InvalidFlag=$p($g(^DHCEQStoreMove(RowID)),"^",27)
		i InvalidFlag="Y" q -1015
	}
	s User=$p(val,"^",9)
	s Job = $p(val,"^",12) 		;$job
	s EquipTypeDR=$p($g(^DHCEQStoreMove(RowID)),"^",16)
	s StatCatDR=$p($g(^DHCEQStoreMove(RowID)),"^",17)
	s MoveType=$p($g(^DHCEQStoreMove(RowID)),"^",12)
	///modified by zy 2015-04-14 zy0126  增加转移的时候库房管理科室的判断
	s FormLocDR=$p($g(^DHCEQStoreMove(RowID)),"^",2)
	s ToLocDR=$p($g(^DHCEQStoreMove(RowID)),"^",3)
	s Loc1=FormLocDR
	s Loc2=ToLocDR
	s CheckType=0
	i MoveType=1 s CheckType=1
	i MoveType=3
	{
		s Loc1=ToLocDR
		s Loc2=FormLocDR
	}
	s ManageLocFlag=##Class(web.DHCEQCStoreManageLoc).CheckManageLoc(CheckType,Loc1,Loc2)
	i ManageLocFlag'=1 quit -1016  //科室不属于当前院区!
	///end by zy 2015-04-14
	s PLIST(5) = User //$p(val,"^",5)	;MakerDR
 	s PLIST(6) = Date
	s PLIST(14) = "1"					;Status
	//判断总单与明细单类组，类型是否一致
	s ReturnEquipType=##CLASS(web.DHCEQInStockNew).EquipTypeIsUniqueNew(RowID,EquipTypeDR,"StoreMove")
	i ReturnEquipType<0 q ReturnEquipType
	i ReturnEquipType=0 s ReturnEquipType=""
	s PLIST(17)=ReturnEquipType
	s Flag=##class(web.DHCEQCommon).GetSysInfo("301007")   //是否需要单据设备类型一致
	if Flag=1
	{
		s ReturnType=..StatCatIsUniqueNew(RowID,StatCatDR)
		i ReturnType<0 q ReturnType
		i ReturnType=0 s ReturnType=""
		s PLIST(18)=ReturnType
	}
	s ApproveCondition="MoveType,DHCEQStoreMove,"_MoveType
	s EquipType=EquipTypeDR
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, "", "", "","",ApproveCondition)
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	s AppInfoStatus="1"
	//检测是否最后一步,是则自动审核 Add By DJ 2010-08-24
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s PLIST(10)=User
		s PLIST(11)=Date
		s PLIST(14)="2"
		s AppInfoStatus="2"
	}
	TSTART	
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"14",User)
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}	
	&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	//最终审核调用 Add By DJ 2010-08-24
	i NextStep="" s SQLCODE=..LastStepAction(RowID,User)
	i SQLCODE'=0 //2011-05-27 DJ
	{
		TROLLBACK
		q SQLCODE
	}
	;Modified by jdl 2011-3-9  jdl0073
	s AuditFlag=0
	i NextStep="" s AuditFlag=1
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("22", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	TCOMMIT
 	q RowID
ERRORSubmit 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:反提交
/// ----------------------------------
/// w ##Class(web.DHCEQStoreMoveNew).CancelSubmitData("")
ClassMethod CancelSubmitData(val, CurRole)
{
	new (val,CurRole,%session)
	Set $ZT="ERRORCancel"
	k PLIST
	s RowID=$P(val,"^",1)
	s User=$P(val,"^",9)
	s CancelToFlowDR=$P(val,"^",10)
	s ApproveSet=$P(val,"^",11)
	s Date=+$H
	s PLIST(5) = User //$p(val,"^",5)	;MakerDR
 	s PLIST(6) = Date
 	s PLIST(14) = "0"
 	
 	s ApproveRoleDR=""
 	s Step=""
 	s Status="0"
	TSTART
	if (CancelToFlowDR'="")
	{
		s PLIST(14)="1"
	 	s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
	 	s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
	 	s Status="1"
	}
	
	//add by zy 2011-03-16 
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
	
	//2015-10-08 ZY0146   取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("14", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;Modified by jdl 2011-3-9  jdl0073
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("22", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
		
 	TCOMMIT
 	q RowID
ERRORCancel 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// 创建:zy 2010-03-26  No ZY0018
/// 描述:审核
/// w ##Class(web.DHCEQStoreMoveNew).AuditData("180^1276^112^0^sfsf^^1^^1^^29","7","1","180^sfsf,7@252^dgdg,7^dgdg,8&253^dgdg,7^dgdg,8")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo)
{
	new (val,CurRole,RoleStep,editFieldsInfo,%session)
	n RowID,User,Date
	n ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	
	Set $ZT="ERRORAudit"
	k PLIST
	s RowID=$P(val,"^",1)
	s User=$P(val,"^",9)
	s Date=+$H
	//s EquipType=$p($g(^DHCEQStoreMove(RowID)),"^",16)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("14", RowID)
	i ApproveSet="" q -4007	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"
	
	TSTART	
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ($p($g(^DHCEQStoreMove(RowID)),"^",13)=2)
		{
			TROLLBACK
			q -1010
		}
		s AppInfoStatus="2"
		
		s Date=+$H
		s PLIST(10)=User
		s PLIST(11)=Date
		s PLIST(14)="2"
		&SQL(update sqluser.DHC_EQStoreMove values :PLIST() where SM_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	
	;20111014  Mozy0061	转移审核增加保存生成审批的记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
		
	//add by zy 2011-03-16 
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	
	//可编辑字段更新 Add By DJ 2010-08-24
	i editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	
	//最终审核调用 Add By DJ 2010-08-24
	i NextStep="" s SQLCODE=..LastStepAction(RowID,User)
	i SQLCODE'=0 //2011-05-27 DJ
	{
		TROLLBACK
		q SQLCODE
	}
	
	;Modified by jdl 2011-3-9  jdl0073
	s AuditFlag=0
	i NextStep="" s AuditFlag=1
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("22", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
 	q RowID

ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

/// Add By DJ 2010-08-24
/// 审批最后一步操作
ClassMethod LastStepAction(RowID, User)
{
	s SQLCODE=##class(web.DHCEQStoreMoveNew).InsertChangeStock(RowID,User)		//写入设备变动信息
	i SQLCODE q SQLOCDE
	s SQLCODE=##class(web.DHCEQStoreMoveNew).InsertEQLifeInfo(RowID,User)		//生命周期信息
	;Modified by JDL 2012-1-4 JDL0108
	i SQLCODE q SQLCODE
	//Function:Funds	2012-2-16 生成资金来源信息
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID))  quit:(SMLRowID="")||(SQLCODE'=0)  d
	.s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfo(4, SMLRowID)
	.;Mozy0089	2012-10-17
	.Quit:SQLCODE'=0
	.Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(4, SMLRowID)
	q SQLCODE
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:判断批量转移的设备数量与选择的RowIDs是否一致
/// w ##Class(web.DHCEQStoreMoveNew).JudgeSMLQuantityNum("258","","1^371^^364^担架车^^90^5^^1601^")
/// ----------------------------------
ClassMethod JudgeSMLQuantityNum(SMRowID, Job, val)
{
	new (SMRowID, Job, val)
	i SMRowID="" q -1
	i val="" q 0
	s Flag=0
	s StoreLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)		;StoreLocDR
	s MoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)		;MoveType
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=	$p(val,"&",i)
		
		s index= $p(valList,"^",1)  		;index
		s SMLRowID= $p(valList,"^",2)  		;SMLRowID
		s InStockListDR=$p(valList,"^",4)
		
		;Modified by JDL 2011-08-15 JDL0091 单台时,也应记录EquipDR
		i $p(valList,"^",3)'=""
		{			
			if SMLRowID=""  //新增明细
			{
				s ^TEMPEQ("MXList","EX",Job,index)=$p(valList,"^",3)
			}
			else
			{
				s ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=$p(valList,"^",3)
				k ^TEMPEQ("MXList",Job,SMLRowID)
			}
			continue //单台设备不处理
		}
		s QuantityNum=$p(valList,"^",8)  	;SML_TQuantityNum
 		s RowIDs=""
		s Len=0
 		if SMLRowID=""  //新增明细
 		{
 			s RowIDs=$g(^TEMPEQ("MXList","EX",Job,index))
 		}
 		else
 		{
	 		s RowIDs=$g(^TEMPEQ("MXList",Job,SMLRowID))
	 		;Modified by JDL 2011-08-15 JDL0091 当InStockListDR相同时,才取原来的rowids
 			i ((RowIDs="")&&(InStockListDR=$p(^DHCEQStoreMoveList(SMLRowID),"^",4))) s RowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	 	}
	 	if RowIDs'="" s Len=$l(RowIDs,",")
	 	if (Len'=QuantityNum)
	 	{
			s Flag=##Class(web.DHCEQUpdateEquipsByList).GetRowIDsByQuantityNum(InStockListDR,QuantityNum,SMLRowID,StoreLocDR,Job,index,"1")
		}
		else
		{
			if (SMLRowID'="")&&($Data(^TEMPEQ("MXList",Job,SMLRowID)))
			{
				s ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=$g(^TEMPEQ("MXList",Job,SMLRowID))
				k ^TEMPEQ("MXList",Job,SMLRowID)
			}
		}
	}
	q Flag
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:写入转移单明细
/// w ##Class(web.DHCEQStoreMoveNew).SaveStoreMoveList("241","3812","1^365^^361^担架车^2^30^2^922^1601")
/// ----------------------------------
ClassMethod SaveStoreMoveList(SMRowID, Job, val)
{
	new (SMRowID, Job, val)
	i SMRowID="" q -1
	i val="" q 0
	s Flag=0
	s PLISTMX(2)=SMRowID  				;InStockDR
	s StoreLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)		;StoreLocDR
	s MoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)		;MoveType
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=	$p(val,"&",i)
		s index= $p(valList,"^",1)  		;index
		s SMLRowID= $p(valList,"^",2)  		;SMLRowID
		s PLISTMX(3)=$p(valList,"^",3)  	;SML_EquipDR
		i $p(valList,"^",3)="" s PLISTMX(4)="Y"		;SML_BatchFlag
		i $p(valList,"^",3)'="" s PLISTMX(4)=""		;SML_BatchFlag
		s PLISTMX(5)=$p(valList,"^",4)		;SML_InStockListDR
		s PLISTMX(6)=$p(valList,"^",18)  	;SML_Equip	//2013-06-24 DJ0118
		s PLISTMX(7)=$p(valList,"^",6)  	;SML_TManuFactoryDR
		s PLISTMX(8)=$p(valList,"^",7)  	;SML_TOriginalFee
		s PLISTMX(9)=$p(valList,"^",8)  	;SML_TQuantityNum
		s PLISTMX(10)=$p(valList,"^",9)  	;SML_TModelDR
		s PLISTMX(11)=$p(valList,"^",10)  	;SML_TUnitDR
		s PLISTMX(12)=$p(valList,"^",11)  	;SML_TRemark
		//add by zy 2012-04-13 ZY0092  出库明细增加存放地点和保留字段
		s PLISTMX(13)=$p(valList,"^",12)  	;LocationDR
 		s PLISTMX(14)=$p(valList,"^",13)		;Hold1
 		s PLISTMX(15)=$p(valList,"^",14)		;Hold2
 		s PLISTMX(16)=$p(valList,"^",15)		;Hold3
 		s PLISTMX(17)=$p(valList,"^",16)		;Hold4
 		s PLISTMX(18)=$p(valList,"^",17)		;Hold5
		
		s InStockListDR=PLISTMX(5)
		s QuantityNum=PLISTMX(9)
		if (SMLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQStoreMoveList Values :PLISTMX())
			s SMLRowID=$G(%ROWID)
 			if ($p(valList,"^",3)="")  //批量记录 //2011-05-27 DJ Begin
 			{
	 			s ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=$g(^TEMPEQ("MXList","EX",Job,index))
	 		}
	 		else
	 		{
		 		s ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")=$p(valList,"^",3)
	 		}
	 		k ^TEMPEQ("MXList","EX",Job,index) //2011-05-27 DJ end
		}
		else
		{
			&SQL(update sqluser.DHC_EQStoreMoveList values :PLISTMX() where SML_RowID=:SMLRowID)
		}
		//检测原值变化 2011-08-10 DJ begin
		s ListEQ=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
		s ListCount=$L(ListEQ,",")
		for j=1:1:ListCount
		{
			q:Flag'=0
			s EQID=$p(ListEQ,",",j)			
			s EQOriginalFee=$p($g(^DHCEQEquip(EQID)),"^",27)
			i +EQOriginalFee'=+$p(valList,"^",7)		//Modify DJ 2015-08-19 DJ0157
			{
				s Flag=index_"^设备原值已发生变动,不可批量处理!"
			}
		}
		//2011-08-10 DJ end
		i SQLCODE s Flag=index_"^更新明细记录失败!"
	}
	q Flag
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:删除转移明细
/// w ##Class(web.DHCEQStoreMoveNew).DeleteStoreMoveList("231",",0,-1")
/// ----------------------------------
ClassMethod DeleteStoreMoveList(SMRowID, DelRowid)
{
	new Length,SMLRowID,Flag,i
	s Flag=0
	i SMRowID="" q -1
	i DelRowid="" q 0
	s Length=$l(DelRowid,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s SMLRowID=$p(DelRowid,",",i)
		if (SMLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQStoreMoveList where SML_RowID=:SMLRowID)
			i SQLCODE s Flag=SMLRowID_"^更新操作失败"
 			k ^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")
		}
	}
	q Flag
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:写设备的生命周期信息
/// w ##Class(web.DHCEQStoreMoveNew).InsertEQLifeInfo("117")
/// ----------------------------------
ClassMethod InsertEQLifeInfo(RowID, User)
{
	new (RowID, User)
	q:RowID=""
	s Date=+$H
	s Time=$P($H,",",2)
	s Flag=0
	s FromLoc=$P(^DHCEQStoreMove(RowID),"^",2)		;供给部门
	s ToLoc=$P(^DHCEQStoreMove(RowID),"^",3)		;接收部门
	s MoveType=$P(^DHCEQStoreMove(RowID),"^",12)	;转移类型
	s Status=$P(^DHCEQStoreMove(RowID),"^",13)		;状态
	
	s LI(16)=Date				//变动日期
	s LI(17)=Time				//变动时间
 	s LI(19)="C"				//生命周期类型
 	s LI(20)=22					//来源类型
 	s LI(22)=MoveType			//来源辅助类型
 	s LI(27)=User				//更新人
 	s LI(28)=Date				//更新日期
 	s LI(29)=Time				//更新时间
	
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID))  quit:(SMLRowID="")||(Flag'=0)  d
	.s BatchFlag=$P(^DHCEQStoreMoveList(SMLRowID),"^",3)
	.i BatchFlag="Y" d
	..s RowIDs=$G(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	..s equipRowIDs=RowIDs
	.e  d
	..s EquipDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",2)
	..s equipRowIDs=EquipDR
	.//add by zy 2012-04-13 ZY0092  把出库明细的存放地点和备注信息更新到台帐上面
	.s Remark=$P(^DHCEQStoreMoveList(SMLRowID),"^",11)
	.s LocationDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",12)
	.s count=$l(equipRowIDs,",")
	.f i=1:1:count d
	..q:Flag'=0
	..s EquipDR=$p(equipRowIDs,",",i)
	..i EquipDR'=""  d
	...s LI(2)=EquipDR
	...s LI(4)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   	//原使用科室 
	...s LI(5)=$p($g(^DHCEQEquip(EquipDR)),"^",17)  	//原管理科室
	...s LI(6)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  	//原库房
	...s LI(7)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  	//原值
	...s LI(8)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  	//原净值
	...;2011-08-10 DJ begin
	...i LI(7)'=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7) s Flag="["_$p($g(^DHCEQEquip(EquipDR)),"^",1)_"]原值有发生变化,不可批量处理!"
	...q:Flag'=0
	...;2011-08-10 DJ end
	...//add by zy 2012-04-13 ZY0092  把出库明细的存放地点和备注信息更新到台帐上面
	...s Flag=..UpdateEquip(MoveType,RowID,EquipDR,User,Remark,LocationDR)
	...q:Flag'=0
	...s LI(9)=$p($g(^DHCEQEquip(EquipDR)),"^",19)  	//变动后使用科室 
 	...s LI(10)=$p($g(^DHCEQEquip(EquipDR)),"^",17) 	//变动后管理科室
 	...s LI(11)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  	//变动后库房
 	...s LI(12)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  	//变动后原值
 	...s LI(13)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  	//变动后净值 
 	...s LI(21)=SMLRowID 								//来源ID
 	...s LI(23)=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",11) //备注
 	...&SQL(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	...i SQLCODE s Flag=SQLCODE
	q Flag
}

// add by zy 2012-04-13 ZY0092  把出库明细的存放地点和备注信息更新到台帐上面

ClassMethod UpdateEquip(MoveType, RowID, EquipDR, User, Remark, LocationDR)
{
	n (MoveType,RowID,EquipDR,User,Remark,LocationDR)	
	k EQPL
	//modified by zy 2014-1-7 zy0109
	//转移出库时，如何处理设备启用日期',
	//'0:首次出库自动更新启用日期(启用日期为空时) 1:每次出库皆自动更新启用日期'
	s updateSDateFlag=##class(web.DHCEQCommon).GetSysInfo("302011") 
	s ToLoc=$p($g(^DHCEQStoreMove(RowID)),"^",3)
	s MoveType =$p($g(^DHCEQStoreMove(RowID)),"^",12)
	/********************************************/ //2011-05-26 DJ begin
	s EQName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s EQNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	s EQInvalidFlag=$p($g(^DHCEQEquip(EquipDR)),"^",59)
	i EQInvalidFlag="Y"  q EQName_"["_EQNo_"]设备已无效!"
	s EQStockStatus=$p($g(^DHCEQEquip(EquipDR)),"^",60)
	s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	i (EQStockStatus'="1")||(EQStatus=3)  q EQName_"["_EQNo_"]库房状态不符合条件!"
	s FromLoc=$p($g(^DHCEQStoreMove(RowID)),"^",2)
	s EQStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	i FromLoc'=EQStoreLocDR  q EQName_"["_EQNo_"]所在库房不是供给部门!"
	/********************************************/ //2011-05-26 DJ end
	s EQPL(20)=ToLoc		;使用科室
	i MoveType="0" s EQPL(39)=1			;设备状态	0:新增|1:启用|2:封存|3:报废|4:其他
	//midified by zy 2015-7-1 ZY0134 修改设备状态为0:在库|1:启用|2:停用|3:报废|4:其他
	i MoveType="3" s EQPL(39)=0

	i MoveType="4" k EQPL(20) //2011-01-21 DJ
	//modified by zy 2014-1-7 zy0109 
	//转移类型为出库时才更新启用日期
	if (MoveType="0")||(MoveType="1")
	{
		s EQPL(104)=+$H		//领用日期 Add By DJ DJ0126
		if updateSDateFlag=1
		{
			s EQPL(45)=+$H		;启用日期
		}
		else
		{
			i $p($g(^DHCEQEquip(EquipDR)),"^",44)="" s EQPL(45)=+$H		;启用日期
		}
	}
	s EQPL(56)=User  			;更新人
	s EQPL(57)=+$H  				;更新日期
	s EQPL(58)=$P($H,",",2)  	;更新时间
	s EQPL(61)=1  		;0:新增|1:入库|2:转移出库|3:出库
	s EQPL(68)=ToLoc		;库房
	;i Remark'="" s EQPL(35)=Remark
	i LocationDR'="" s EQPL(73)=LocationDR
	i MoveType=3  d
	.s EQPL(73)=""
	.s EQPL(20)=""
	&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EquipDR)
 	q SQLCODE
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:库房变动信息
/// w ##Class(web.DHCEQStoreMoveNew).InsertChangeStock("180","1")
/// ----------------------------------
ClassMethod InsertChangeStock(RowID, User)
{
	new (RowID, User)
	q:RowID=""
	s Date=+$H
	s Flag=0
	s FromLoc=$P(^DHCEQStoreMove(RowID),"^",2)
	s ToLoc=$P(^DHCEQStoreMove(RowID),"^",3)
	s SMLRowID=0
	f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID))  quit:(SMLRowID="")||(Flag'=0)  d
	.s BatchFlag=$P(^DHCEQStoreMoveList(SMLRowID),"^",3)
	.i BatchFlag="Y" d
	..s RowIDs=$G(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	..s equipRowIDs=RowIDs
	.e  d
	..s EquipDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",2)
	..s equipRowIDs=EquipDR
	.s count=$l(equipRowIDs,",")
	.f i=1:1:count d
	..q:Flag'=0
	..s EquipDR=$p(equipRowIDs,",",i)
	..i EquipDR'=""  d
	...s CSPL(2)=EquipDR
	...s CSPL(3)=FromLoc
	...s CSPL(4)=ToLoc
	...s CSPL(5)=SMLRowID
	...s CSPL(6)="1"
	...s CSPL(7)=Date
	...s CSPL(8)=User
	...s CSPL(9)=Date
	...s CSPL(10)=Date
	...s SQLCODE=0
	...&SQL(Insert into sqluser.DHC_EQChangeStock values :CSPL())
	...i SQLCODE s Flag=SQLCODE
	q Flag
}

/// ----------------------------------
/// 创建: add by jdl 2009-04-13
/// 判断入库单设备类型的唯一性
/// w ##Class(web.DHCEQStoreMoveNew).StatCatIsUniqueNew("206","5")
/// ----------------------------------
ClassMethod StatCatIsUniqueNew(RowID, StatCatID)
{
	new (RowID, StatCatID)
	s diffrentFlag=0
	s noStatCatFlag=0
	s ReturnType=1
	s ListStatCatID=""
	s StatID=""
	s SMLRowID=0
	f  s SMLRowID=$O(^DHCEQStoreMoveList(0,"StoreMove",RowID,SMLRowID)) q:(SMLRowID="")||(diffrentFlag=1)||(noStatCatFlag=1)  d
	.s EquipDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",2)
	.i EquipDR="" d
	..s InStockListDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",4)
	..i InStockListDR'="" s StatCat=$P(^DHCEQInStockList(InStockListDR),"^",17)
	.e  d
	..s StatCat=$P(^DHCEQEquip(EquipDR),"^",75)
	.i StatCat="" s noStatCatFlag=1
	.i ListStatCatID="" s ListStatCatID=StatCat
	.i StatCat'=ListStatCatID s diffrentFlag=1

	q:(##class(web.DHCEQCommon).GetSysInfo("301007")=1)&&(diffrentFlag=1) -1001		;Mozy	2019-5-13	896229
	q:noStatCatFlag=1 -1004
	q:(ListStatCatID'=StatCatID)&&(StatCatID'="") -1002
	
	q ListStatCatID
}

/// Add By DJ 2010-08-30
/// 根据入库明细获取生成的转移信息
/// w ##Class(web.DHCEQStoreMoveNew).GetSMInfoByISL("","10","1","")
/// add by lmm 2017-08-08 404562 增加入参：vFromLocDR
ClassMethod GetSMInfoByISL(EquipDR, InStockListDR, MoveType, vFromLocDR As %String = "")
{
	n User,FromLocDR,ToLocDR,EquipTypeDR,StatCatDR
		
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i (InStockListDR="ZY")||(InStockListDR=0) //单台信息  //2011-05-27 DJ
	{
		s FromLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
		s ToLocDR=""
		;Mozy0096  20130403  重新获取入库单的申购科室
		If $Piece($Get(^DHCEQEquip(EquipDR)),"^",70)'=""
		{
			Set InStockDR=$Piece($Get(^DHCEQInStockList($Piece($Get(^DHCEQEquip(EquipDR)),"^",70))),"^",1)
			Set ToLocDR=$Piece($Get(^DHCEQInStock(InStockDR)),"^",18)
		}
		s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
		s StatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
	}
	else //批量信息
	{
		s InStockDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
		s FromLocDR=$p($g(^DHCEQInStock(InStockDR)),"^",2)
		s ToLocDR=$p($g(^DHCEQInStock(InStockDR)),"^",18)
		s EquipTypeDR=$p($g(^DHCEQInStock(InStockDR)),"^",20)
		s StatCatDR=$p($g(^DHCEQInStock(InStockDR)),"^",21)
		i ((MoveType'=0)&&(MoveType'=4)) s FromLocDR=vFromLocDR //add by lmm 2017-08-17 404562
	}

	;Mozy0096	2013-4-3	增加MoveType
	i MoveType'=0 s ToLocDR=""
	q "^"_FromLocDR_"^"_ToLocDR_"^"_MoveType_"^^^"_EquipTypeDR_"^"_StatCatDR_"^"_User_"^^^"
}

ClassMethod CheckStoreMoveLoc(RowID)
{
	n (RowID)
	s MoveType=$p($g(^DHCEQStoreMove(RowID)),"^",12)
	s FromLocDR=$p($g(^DHCEQStoreMove(RowID)),"^",2)
	s ToLocDR=$p($g(^DHCEQStoreMove(RowID)),"^",3)
	i FromLocDR="" q "供给部门未保存,请先更新数据"
	i ToLocDR="" q "接收部门未保存,请先更新数据"
	i FromLocDR=ToLocDR q "供给部门与接收部门相同!"
	s FromLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",FromLocDR)
	s ToLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",ToLocDR)
	i ((MoveType="0")||(MoveType="4")) //库房分配
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0101",FromLocDR)
		i Flag'=0 q "供给部门不是库房"
	}
	else
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0102",FromLocDR)
		i Flag'=0 q "供给部门不是科室"
	}
	i ((MoveType="3")||(MoveType="4")) //科室退库
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0101",ToLocDR)
		i Flag'=0 q "接收部门不是库房"
	}
	else
	{
		s Flag=##Class(web.DHCEQCommon).CheckLocType("0102",ToLocDR)
		i Flag'=0 q "接收部门不是科室"
	}
	s CheckFlag=##class(web.DHCEQCommon).GetSysInfo("990012")
	i (CheckFlag="")||(CheckFlag=0) q ""
	//判断当前库房管理科室
	i MoveType="0"
	{
		s Flag=$D( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",ToLocDR,FromLocDR))
		i Flag=0 q ToLocDesc_"不在"_FromLocDesc_"管理范围内"
	}
	i MoveType="1" //判断科室调配时供给部门与接收部门是否属于同一库房
	{
		s FromStore=$o( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",FromLocDR,0))
		i FromStore="" q "库房管理科室中未设置供给部门的所属管理库房"
		s ToStore=$o( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",ToLocDR,0))
		i ToStore="" q "库房管理科室中未设置接收部门的所属管理库房"
		i FromStore'=ToStore q FromLocDesc_" 和 "_ToLocDesc_"不在同一库房管理下"
	}
	i MoveType="3"
	{
		s Flag=$D( ^DHCEQCCode("DHCEQCStoreManageLoc",0,"Loc",FromLocDR,ToLocDR))
		i Flag=0 q FromLocDesc_"不在"_ToLocDesc_"管理范围内"
	}
	q ""
}

ClassMethod GetPreviousUseLoc(EQRowID)
{
	n (EQRowID)
	s CSRowID=""
	s Flag=0
	s PreviousUseLoc=""
	f  s CSRowID=$o(^DHCEQChangeStock(0,"Equip",EQRowID,CSRowID),-1)  q:(CSRowID="")||(Flag'=0)  d
	.s CSChangeType=$p($g(^DHCEQChangeStock(CSRowID)),"^",5)
	.q:CSChangeType'=1
	.s CSSourceID=$p($g(^DHCEQChangeStock(CSRowID)),"^",4)
	.s SMRowID=$p($g(^DHCEQStoreMoveList(CSSourceID)),"^",1)
	.s CSFromLocDR=$p($g(^DHCEQChangeStock(CSRowID)),"^",2)
	.s SMMoveType=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)
	.i ((SMMoveType=1)||(SMMoveType=3))  d
	..s PreviousUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",CSFromLocDR)
	..s Flag=1
	q PreviousUseLoc
}

/// Modified by JDL 2011-8-25 JDL0094 检查单据数据是否有效
/// 		 主要是否设备已经被其他单据占用
/// 入参：SourceType:1转移单  2退货减少单
/// 		 SourceID:对应业务单据ID
/// 返回：0有效
/// 		 其他无效
ClassMethod CheckOrder(SourceType, SourceID)
{
	n ListID,EquipIDs,EquipID,Len,i,Flag,FromLocDR,Index
	s Index=0
	s Flag=0
	s ListID=0
	i SourceID="" q "0"
	i SourceType=1  d
	.s SMInvalidFlag=$p($g(^DHCEQStoreMove(SourceID)),"^",27)
	.q:SMInvalidFlag="Y"
	.s FromLocDR=$p($g(^DHCEQStoreMove(SourceID)),"^",2)
	.f  s ListID=$o(^DHCEQStoreMoveList(0,"StoreMove",SourceID,ListID))  quit:(ListID="")||(Flag'=0)  d
	..s EquipIDs = $g(^DHCEQStoreMoveList(ListID,"EX","RowIDs"))
	..s Len=$l(EquipIDs,",")
	..s Index=Index+1
	..f i=1:1:Len quit:(Flag'=0)  d
	...s EquipID=$p(EquipIDs,",",i)
	...q:EquipID=""
	...s Flag=##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR(ListID,EquipID,FromLocDR,SourceType)
	...i Flag'=0 s Flag=Index_"^"_$p(^DHCEQEquip(EquipID),"^",1)_"("_$p($g(^DHCEQEquip(EquipID)),"^",71)_")设备已经重复占用,请检查本单据或其他单据!"
	e  d
	.s RInvalidFlag=$p($g(^DHCEQReturn(SourceID)),"^",28)
	.q:RInvalidFlag="Y"
	.s FromLocDR=$p($g(^DHCEQReturn(SourceID)),"^",2)
	.f  s ListID=$o(^DHCEQReturnList(0,"Return",SourceID,ListID))  quit:(ListID="")||(Flag'=0)  d
	..s EquipIDs = $g(^DHCEQReturnList(ListID,"EX","RowIDs"))
	..s Len=$l(EquipIDs,",")
	..s Index=Index+1
	..f i=1:1:Len quit:(Flag'=0)  d
	...s EquipID=$p(EquipIDs,",",i)
	...q:EquipID=""
	...s Flag=##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR(ListID,EquipID,FromLocDR,SourceType)
	...i Flag'=0 s Flag=Index_"^"_$p(^DHCEQEquip(EquipID),"^",1)_"("_$p($g(^DHCEQEquip(EquipID)),"^",71)_")设备已经重复占用,请检查本单据或其他单据!"
	q Flag
}

/// Function:Funds	2012-2-28 生成资金来源信息
/// Mozy0077	2012-1-17
/// w ##class(web.DHCEQStoreMoveNew).GetEquipTypeByInStockList(703)
ClassMethod GetEquipTypeByInStockList(TInStockListDR)
{
	new StoreLocDR,RowID
	Set RowID=0
	Set StoreLocDR=0
	For  Set StoreLocDR=$Order(^DHCEQEquip(0,"InStockList",TInStockListDR,StoreLocDR)) Quit:(StoreLocDR="")||(RowID>0)  Do
	.Set RowID=$Order(^DHCEQEquip(0,"InStockList",TInStockListDR,StoreLocDR,0))
	
	If RowID>0 Quit $Piece(^DHCEQEquip(RowID),"^",63)_"^"_$Piece(^DHCEQEquip(RowID),"^",75)
	Quit ""
}

/// add by 2012-7-5 
/// 检查出库设备是否租借和预报废
/// 返回值   ResultFlag:0,没有租借和预报废
///                     -1016,有租借和预报废
/// w ##class(web.DHCEQStoreMoveNew).CheckEquipIDs()
ClassMethod CheckEquipIDs(SMRowID)
{
	new SMLRowID,ResultFlag,approveroleid,EquipIDs,EquipID
	new DRLRowID,DRRowID,ApproveRoleDR
	s approveroleid=##class(web.DHCEQCommon).GetSysInfo("601003")		//哪个角色审批时作为院内审批完成
	s (SMLRowID,ResultFlag)=0
	f  s SMLRowID=$O(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID)) q:(SMLRowID="")||(ResultFlag'=0)  d
	.s EquipIDs=^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs")	
	.d CheckEquipID
	i ResultFlag'=0 q -1016
	q ResultFlag
CheckEquipID
	s Len=$L(EquipIDs,",")
	for i=1:1:Len
	{
		q:ResultFlag'=0
		s EquipID=$p(EquipIDs,",",i)
		i $p($G(^DHCEQEquip(EquipID)),"^",86)'=""  s ResultFlag=1
		q:ResultFlag'=0
		i $D(^DHCEQDisuseRequestList(0,"EquipDR",EquipID))
		{
			s (DRLRowID,DRRowID,ApproveRoleDR)=""
			s DRLRowID=$order(^DHCEQDisuseRequestList(0,"EquipDR",EquipID,DRLRowID))
			i DRLRowID'="" 
			{
				s DRRowID=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",1)
				i DRRowID'=""
				{
					s ApproveRoleDR=$p($g(^DHCEQDisuseRequest(DRRowID)),"^",31)
					i ApproveRoleDR=approveroleid s ResultFlag=1
				}
			}
		}
	}
	q
}

/// Mozy0114 2013-12-16 
/// 		入参：	RowID：转移明细或退货明细RowID
/// 				ListType：1转移 2退货
/// 				EquipNo：过滤条件--设备编号
/// d ##class(%ResultSet).RunQuery("web.DHCEQStoreMoveNew","GetEquipInfo","1998010532217080001")
Query GetEquipInfo(EquipNo As %String = "", RowID As %String = "", ListType As %String = "1") As %Query(ROWSPEC = "TEquipNo:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,TName:%String,TOriginalFee:%String,TModel:%String,TProvider:%String,TManuFactory:%String,TLeaveFactoryNo:%String,TFromLoc:%String,TStatus:%String,TEquipType:%String,TStatCat:%String,TUnit:%String,TInStockNo:%String,TInDate:%String,TLocation:%String")
{
}

ClassMethod GetEquipInfoExecute(ByRef qHandle As %Binary, EquipNo As %String = "", RowID As %String = "", ListType As %String = "1") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	If EquipNo="" Quit $$$OK
	Set EquipID=$Order(^DHCEQEquip(0,"No",EquipNo,""))
	If EquipID="" Quit $$$OK
	Do ResetVariablesGetEquipInfo
	
	Set TEquipTypeDR = $Piece($Get(^DHCEQEquip(EquipID)),"^",63)
	Quit:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)) $$$OK
	Set TInvalidFlag = $Piece($Get(^DHCEQEquip(EquipID)),"^",59)
	Quit:(TInvalidFlag'="N") $$$OK
	Set TStatus = +$Piece($Get(^DHCEQEquip(EquipID)),"^",38)
	Quit:(TStatus>2) $$$OK
	Set TStockStatus = +$Piece($Get(^DHCEQEquip(EquipID)),"^",60)
	Quit:(TStockStatus=0)||(TStockStatus=3) $$$OK
	Set TFromLocDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",67)	;EQStoreLocDR
	Quit:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR(RowID,EquipID,TFromLocDR,ListType)'=0 $$$OK
	
	Set TName = $Piece($Get(^DHCEQEquip(EquipID)),"^",1)
	Set TLeaveFactoryNo=$Piece($Get(^DHCEQEquip(EquipID)),"^",10)
	Set TProviderDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",25)
	Set TStatCatDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",75)
	Set TEquipNo=$Piece($Get(^DHCEQEquip(EquipID)),"^",71)
	Set TModelDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",3)
	Set TUnitDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",5)
	Set TManuFactoryDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",26)
	Set TOriginalFee=$Piece($Get(^DHCEQEquip(EquipID)),"^",27)
	Set TInDate=$Piece($Get(^DHCEQEquip(EquipID)),"^",45)
	Set TInStockListID=$Piece($Get(^DHCEQEquip(EquipID)),"^",70)
	Set TLocationDR=$Piece($Get(^DHCEQEquip(EquipID)),"^",72)
	Set TMoveType=0		;默认为库房分配
	Set TypeDR=$Order(^DHCEQCCode("DHCEQCLocGroupType","0","Code","0102",0))
	If $Data(^DHCEQCCode("DHCEQCLocType","0","LocType",TypeDR,TFromLocDR)) Set TMoveType=3
	
	If TStatus'="" Set TStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay(TStatus)
	If TInStockListID'="" Set TInStockNo=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(TInStockListID)),"^",1))),"^",14)
	If TFromLocDR'="" Set TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	If TEquipTypeDR'="" Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	If TStatCatDR'="" Set TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCatDR)
	If TProviderDR'="" Set TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	If TModelDR'="" Set TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	If TManuFactoryDR'="" Set TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$Piece(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR),"^",1) //CZF0093
	If TUnitDR'="" Set TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	If TInDate'="" Set TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	If TLocationDR'="" Set TLocation = $Piece($Get(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	
	Do OutputRowGetEquipInfo
	
	Quit $$$OK
OutputRowGetEquipInfo
	Set Data=$lb(TEquipNo,EquipID,TFromLocDR,TEquipTypeDR,TStatCatDR,TProviderDR,TManuFactoryDR,TModelDR,TUnitDR,TLocationDR,TMoveType,TName,TOriginalFee,TModel,TProvider,TManuFactory,TLeaveFactoryNo,TFromLoc,TStatus,TEquipType,TStatCat,TUnit,TInStockNo,TInDate,TLocation)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetEquipInfo
	Set (TEquipNo,TFromLocDR,TEquipTypeDR,TStatCatDR,TProviderDR,TManuFactoryDR,TModelDR,TUnitDR,TLocationDR,TMoveType,TName,TOriginalFee,TModel,TProvider,TManuFactory,TLeaveFactoryNo,TFromLoc,TStatus,TEquipType,TStatCat,TUnit,TInStockNo,TInDate,TLocation)=""
	Quit
}

ClassMethod GetEquipInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipInfoExecute ]
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

ClassMethod GetEquipInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 转移出库汇总
/// Modefied by zc 2015-07-07  zc 0025
/// d ##class(%ResultSet).RunQuery("web.DHCEQStoreMoveNew","StoreMoveStat","2022-12-01","2022-12-08","","","329","434","","","")
Query StoreMoveStat(vStartDate As %String = "", vEndDate As %String = "", ToLocDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", Name As %String = "", MinValue As %String = "", MaxValue As %String = "", IsFixedEQ As %String = "", pEquipTypeDR As %String = "", pUseLocDR As %String = "", ProviderDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TStoreMoveNo:%String,TFromLoc:%String,TToLoc:%String,TInDate:%String,TActDate:%String,TReciver:%String,TEquipName:%String,TModel:%String,TUnit:%String,TOriginalFee:%String,TQuantity:%String,TAmount:%String,TEquipCatCode:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TQty:%String,TTotalFee:%String,TRemark:%String") [ SqlProc ]
{
}

ClassMethod StoreMoveStatExecute(ByRef qHandle As %Binary, vStartDate As %String = "", vEndDate As %String = "", ToLocDR As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", Name As %String = "", MinValue As %String = "", MaxValue As %String = "", IsFixedEQ As %String = "", pEquipTypeDR As %String = "", pUseLocDR As %String = "", ProviderDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	//i ((vStartDate="")&&(vEndDate="")) Quit $$$OK
 	
 	s TQty=0
 	s TTotalFee=0
 	i vStartDate=""  d
 	.s BeginDate=0
 	e  d
 	.s BeginDate=##class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")-1
 	i vEndDate=""  d
 	.s EndDate=+$H
 	e  d
 	.s EndDate=##class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
 	
 	k ^DHCEQTempSMTKList
 	s StockDate=BeginDate
 	f  s StockDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate)) q:((StockDate="")||(StockDate>EndDate))  d
 	.s StatCatDR=""
 	.f  s StatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR)) q:StatCatDR=""  d
 	..s SMRowID=0
 	..f  s SMRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,StockDate,StatCatDR,0,SMRowID)) q:SMRowID=""  d
 	...d ResetVariablesGetStoreMoveStat
 	...s TInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
 	...q:TInvalidFlag'="N"
 	...s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
 	...q:(pEquipTypeDR'="")&&(pEquipTypeDR'=TEquipTypeDR)
 	...q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID,"",""))
 	...s TStoreMoveNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
 	...s TFromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)
 	...s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
 	...s TToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
 	...q:(ToLocDR'="")&&(TToLocDR'=ToLocDR)
 	...q:(pUseLocDR'="")&&(TToLocDR'=pUseLocDR)
 	...s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
 	...s TInDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",5)
 	...;i TInDate'="" s TInDate=$ZD(TInDate,3)
 	...//日期格式统一调整 mwz 2017-3-2
 	...s TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
 	...s TActDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
 	...;i TActDate'="" s TActDate=$ZD(TActDate,3)
 	...s TActDate=##class(web.DHCEQCommon).TransValueToPage(TActDate,"date")
 	...s TReciverDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",15)
 	...i TReciverDR'="" s TReciver=##Class(web.DHCEQCommon).GetTrakNameByID("user",TReciverDR)
	...i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
 	...s SMLRowID=0
 	...f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:SMLRowID=""  d
 	....s (TRowID,TEquipName,TProviderDR,TProvider,TModelDR,TModel,TUnitDR,TUnit,TQuantity,TOriginalFee,TAmount,TTotalFee,TRemark)=""
 	....s TRowID=SMLRowID
 	....q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",15)'=""		//过滤附属设备
 	....s TEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
 	....q:(Name'="")&&(TEquipName'[Name)
 	....s equipRowIDs=$Get(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
 	....s TEquipDR=+equipRowIDs
 	....s TProviderDR=$p($g(^DHCEQEquip(TEquipDR)),"^",25)
 	....q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
 	....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
 	....s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
 	....i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
 	....s TUnitDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",10)
 	....s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
 	....s EquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
 	....s InStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
 	....i EquipDR'=""  d
 	.....s TStatCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",75)
 	.....s ItemDR=$p($g(^DHCEQEquip(EquipDR)),"^",7)
 	.....;s TEquipCatDR=$p($g(^DHCEQEquip(EquipDR)),"^",4)
 	....e  d
 	.....s TStatCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",17)
 	.....s ItemDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",16)
 	.....;s TEquipCatDR=$p($g(^DHCEQInStockList(InStockListDR)),"^",14)
 	....i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
 	....s TEquipCatDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",10)
 	....i TEquipCatDR'=""  d
 	.....s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",2)
 	.....s TEquipCat=$p($g(^DHCEQCCode("DHCEQCTree",TEquipCatDR)),"^",3)
 	....;i TEquipCatDR'=""  d
 	....;.s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
 	....;.s TEquipCatCode=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",1)
 	....s TQuantity=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
 	....s TActualNum=0
 	....d ##Class(web.DHCEQStoreMoveNew).GetStoreMoveListLinkTKID(SMLRowID)
 	....s SMLEQRowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
 	....f j=1:1:$l(SMLEQRowIDs,",") d
 	.....s pEQID=$p(SMLEQRowIDs,",",j)
 	.....s TKListID=$g(^DHCEQTempSMTKList("TKList",SMLRowID,pEQID))
 	.....i TKListID'=""  d
 	......;当前设备存在退库记录
 	.....e  s TActualNum=TActualNum+1
	....s TQuantity=TActualNum
	....q:TQuantity=0
 	....s TQty=TQuantity+TQty
 	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7),"",2)
 	....q:(MinValue'="")&(MinValue>TOriginalFee)
	....q:(MaxValue'="")&(MaxValue<TOriginalFee)
 	....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TQuantity*TOriginalFee,"",2)
 	....s TTotalFee=TTotalFee+TAmount
 	....s TRemark=$p($g(^DHCEQStoreMove(SMRowID)),"^",14)
 	....d OutputRowGetStoreMoveStat

 	k ^DHCEQTempSMTKList
	Quit $$$OK
OutputRowGetStoreMoveStat
	s Data=$lb(TRowID,TStoreMoveNo,TFromLoc,TToLoc,TInDate,TActDate,TReciver,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TStatCat,TEquipCat,TQty,TTotalFee,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMoveStat
	s (TRowID,TStoreMoveNo,TFromLoc,TToLoc,TInDate,TActDate,TReciver,TEquipName,TModel,TUnit,TOriginalFee,TQuantity,TAmount,TEquipCatCode,TEquipType,TStatCat,TEquipCat,TQty,TTotalFee,TProviderDR,TProvider,TEquipDR,TRemark)=""
	quit
}

ClassMethod StoreMoveStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StoreMoveStatExecute ]
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

ClassMethod StoreMoveStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StoreMoveStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

ClassMethod GetMoveTypeCode(MoveType)
{
	;q $CASE(MoveType,"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退货","4":"库房调配",:"没有定义")
	q $CASE(MoveType,"0":"CK","1":"TP","2":"ZF","3":"FK","4":"ZY",:"ZY")
}

/*// Mozy0217  2018-11-01	迁移至web.DHCEQ.EM.BUSStoreMove
/// 描述:根据来源生成其设备配置的转移单明细
/// 入参： SourceType：		0:入库单明细ID		1:设备DR
/// 			OCLRowid:验收明细ID
/// w ##Class(web.DHCEQStoreMoveNew).GetSMLForConfig(0, 707, 571)
/// w ##Class(web.DHCEQStoreMoveNew).GetSMLForConfig(1, 45459, 571)
ClassMethod GetSMLForConfig(SourceType As %String = "", SourceID As %String = "", FromLocDR As %String = "", index As %String = "0")
{
	i (SourceType="")||(SourceID="") q ""
	
	//valList=&index+"^^"+EquipDR+"^"+InStockListDR+"^"+TName+"^"+TManuFactoryDR+"^"+TOriginalFee+"^"+TQuantity+"^"+TModelDR+"^"+TUnitDR+"^^"+TLocationDR+"^^^^^^"+TCommonName
	n valList, OCLRowid, ConfigDRs, ConfigDR, Length, i, ISRowID, tmpISLRowID, StoreLocDR, RowIDs, tmpEquipID, Hold13
	s valList=""
	s Num=index		;序号计数器
	i SourceType=0
	{
		i $p($g(^DHCEQInStockList(SourceID)),"^",18)'=2 q 0		;过滤非来自验收明细的入库记录
		i $p($g(^DHCEQInStockList(SourceID)),"^",22)'="" q 0	;设备配置的入库明细不需要再次生成转移明细记录
		s OCLRowid=$p($g(^DHCEQInStockList(SourceID)),"^",19)
		i OCLRowid="" q 0
		s ConfigDRs=##Class(web.DHCEQ.EM.BUSConfig).GetConfigDRs(1, OCLRowid)
		i ConfigDRs="" q 0
		s ISRowID=$p($g(^DHCEQInStockList(SourceID)),"^",1)
		s Length=$l(ConfigDRs,",")
		
		for i=1:1:Length
		{
			s ConfigDR=	$p(ConfigDRs,",",i)
			Set tmpISLRowID=0
			For  Set tmpISLRowID=$Order(^DHCEQInStockList(0,"InStock",ISRowID,tmpISLRowID)) Quit:(tmpISLRowID="")  Do
			.Quit:$p($g(^DHCEQInStockList(tmpISLRowID)),"^",22)'=ConfigDR
			.
			.;拼设备ID串存储临时节点
			.Set RowIDs=""
			.Set StoreLocDR=""
			.For  Set StoreLocDR=$Order(^DHCEQEquip(0,"InStockList",tmpISLRowID,StoreLocDR)) Quit:(StoreLocDR="")  Do
			..Quit:(FromLocDR'="")&&(StoreLocDR'=FromLocDR)
			..Set tmpEquipID=0
			..For  Set tmpEquipID=$Order(^DHCEQEquip(0,"InStockList",tmpISLRowID,StoreLocDR,tmpEquipID)) Quit:(tmpEquipID="")  Do
			...Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="3")||($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="4")
			...Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",59)'="N")
			...Quit:##class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(tmpEquipID)),"^",63))
			...
			...;查看设备是不是已经存在其他的转移单
			...Quit:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR("",tmpEquipID,StoreLocDR,1)'=0
			...If RowIDs'="" Set RowIDs=RowIDs_","
			...Set RowIDs=RowIDs_tmpEquipID
			.Quit:RowIDs=""
			.
			.s Num=Num+1
			.i valList'="" s valList=valList_"&"
			.s valList=valList_Num_"^^^"_tmpISLRowID_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",5)
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",6)	;;SML_TManuFactoryDR
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",7)	;;SML_TOriginalFee
			.s valList=valList_"^"_$l(RowIDs,",")	;$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",8)  	;SML_TQuantityNum
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",9)	;;SML_TModelDR
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",10)	;;SML_TUnitDR
			.s valList=valList_"^^"
			.If ($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",18)=2) s valList=valList_$Piece($Get(^DHCEQOpenCheckList($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",19))),"^",26)  	;LocationDR
			.s valList=valList_"^^^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",22)
			.s valList=valList_"^^^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",5)
			.s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("model",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",9))
			.s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",6))
			.s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",10))
			.s valList=valList_"^"
			.If ($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",18)=2) s valList=valList_##Class(web.DHCEQCommon).GetTrakNameByID("location",$Piece($Get(^DHCEQOpenCheckList($Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",19))),"^",26))
		}
	}
	elseif SourceType=1
	{
		Set Hold13=0
		For  Set Hold13=$Order(^DHCEQEquip(0,"Hold13",Hold13)) Quit:(Hold13="")  Do
		.Set tmpEquipID=0
		.For  Set tmpEquipID=$Order(^DHCEQEquip(0,"Hold13",Hold13,tmpEquipID)) Quit:(tmpEquipID="")  Do
		..Quit:$Piece($Get(^DHCEQEquip(tmpEquipID,"OtherInfo")),"^",24)'=SourceID		; EQHold11		过滤主设备
		..Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="3")||($p($g(^DHCEQEquip(tmpEquipID)),"^",38)="4")
		..Quit:($p($g(^DHCEQEquip(tmpEquipID)),"^",59)'="N")
		..Quit:##class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(tmpEquipID)),"^",63))
		..
		..Set StoreLocDR=$p($g(^DHCEQEquip(tmpEquipID)),"^",67)
		..Quit:(StoreLocDR'=FromLocDR)
		..;查看设备是不是已经存在其他的转移单
		..Quit:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR("",tmpEquipID,StoreLocDR,1)'=0
		..
		..Set RowIDs=tmpEquipID
		..s Num=Num+1
		..i valList'="" s valList=valList_"&"
		..s valList=valList_Num_"^^"_tmpEquipID_"^^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",1)
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",26)	;;SML_TManuFactoryDR
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",27)	;;SML_TOriginalFee
		..s valList=valList_"^"_$l(RowIDs,",")	;$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",8)  	;SML_TQuantityNum
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",3)	;;SML_TModelDR
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",5)	;;SML_TUnitDR
		..s valList=valList_"^^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",72) ;LocationDR
		..s valList=valList_"^^^"_$Piece($Get(^DHCEQEquip(tmpEquipID,"OtherInfo")),"^",26)		;ConfigDR
		..s valList=valList_"^^^(附)"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",1)
		..s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("model",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",3))
		..s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",26))
		..s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",5))
		..s valList=valList_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("location",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",72))
	}
	
	Quit valList
}*/
/// modified by ZY0286 20211210
/// 转移单打印内容全部从后台query输出
/// HISUI改造需重新调整 曾超
/// add by kdf 2018-01-11
/// 用于转移单润乾打印
/// d ##class(%ResultSet).RunQuery("web.DHCEQStoreMoveNew","GetStoreMoveListPrint",14)
Query GetStoreMoveListPrint(RowID As %String = "", EQTitle As %String = "", FromLoc As %String = "", ToLoc As %String = "", AckDate As %String = "", StoreMoveNo As %String = "", AckUser As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TManuFactory:%String,TOriginalFee:%String,TQuantityNum:%String,TTotalFee:%String,TModel:%String,TUnit:%String,TRemark:%String,TStoreMoveNo:%String,TFromLoc:%String,TToLoc:%String,TMaker:%String,TMakeDate:%String,TMoveType:%String,TEquipType:%String,TTitle:%String,TEquipNo:%String") [ SqlProc ]
{
}

ClassMethod GetStoreMoveListPrintExecute(ByRef qHandle As %Binary, RowID As %String = "", EQTitle As %String = "", FromLoc As %String = "", ToLoc As %String = "", AckDate As %String = "", StoreMoveNo As %String = "", AckUser As %String = "") As %Status
{
 	new repid, index,rowid,TRow
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	// MZY0113		2435462		2022-01-25	增加标题输出
	s TTitle=""
	i EQTitle'="" s TTitle=EQTitle
	s rowid=0
	i RowID'=""  d
	.s StoreMoveData=$g(^DHCEQStoreMove(RowID))
	.s TStoreMoveNo=$p(StoreMoveData,"^",1)
	.s TFromLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(StoreMoveData,"^",2))
	.s TToLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(StoreMoveData,"^",3))
	.s TMaker=##class(web.DHCEQCommon).GetTrakNameByID("user",$p(StoreMoveData,"^",4))
	.s TMakeDate=##class(web.DHCEQCommon).TransValueToPage($p(StoreMoveData,"^",5),"date")
	.s TMoveType=$p(StoreMoveData,"^",12)	//$CASE($p(StoreMoveData,"^",12),"0":"库房分配","1":"科室调配","2":"报废转废品库","3":"科室退库","4":"库房调配") //Modify by wl 2019-10-31 1071547
	.// MZY0113		2435462		2022-01-25
	.i TTitle="" d
	..s TTitle="设备转移单"
	..if (TMoveType="0") s TTitle="设备出库单"
	..if (TMoveType="3") s TTitle="设备退库单"
	.s TEquipType=##class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p(StoreMoveData,"^",16))
	.//TStoreMoveNo,TFromLoc,TToLoc,TMaker,TMakeDate,TMoveType,TEquipType
	.f  s rowid=$o(^DHCEQStoreMoveList(0,"StoreMove",RowID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetStoreMoveListPrint
	..;TRowID ,TEquip ,TManuFactory ,TOriginalFee ,TQuantityNum ,TTotalFee ,TModel ,TUnit ,TRemark
	..s TRowID = rowid
	..s TEquipDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",2)
	..s TInStockListDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",4)
	..i TInStockListDR'=""  d
	...s TEquip=$p($g(^DHCEQInStockList(TInStockListDR)),"^",5)
	..e  d
	...s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	..s TManuFactoryDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",6)
	..i TManuFactoryDR '=""  d
	...s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	..s TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(rowid)),"^",7),"")
	..s TQuantityNum = $p($g(^DHCEQStoreMoveList(rowid)),"^",8)
	..s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee*TQuantityNum,"")
	..s TModelDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",9)
	..i TModelDR '=""  d
	...s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TUnitDR = $p($g(^DHCEQStoreMoveList(rowid)),"^",10)
	..i TUnitDR '=""  d
	...s TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TRemark = $p($g(^DHCEQStoreMoveList(rowid)),"^",11)
	..s TEquipNo=##class(web.DHCEQCommon).GetEquipNos(22,rowid,"","EquipNo")		//czf 2022-04-21
	..d OutputRowGetStoreMoveListPrint 
	Quit $$$OK
		
OutputRowGetStoreMoveListPrint
	s Data=$lb(TRowID ,TEquip ,TManuFactory ,TOriginalFee ,TQuantityNum ,TTotalFee ,TModel ,TUnit ,TRemark,TStoreMoveNo,TFromLoc,TToLoc,TMaker,TMakeDate,TMoveType,TEquipType,TTitle,TEquipNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStoreMoveListPrint
	s (TRowID ,TEquip ,TManuFactory ,TOriginalFee ,TQuantityNum ,TTotalFee ,TModel ,TUnit ,TRemark,TEquipNo)=""
	quit
}

ClassMethod GetStoreMoveListPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStoreMoveListPrintExecute ]
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

ClassMethod GetStoreMoveListPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStoreMoveListPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// ///////////////////////////////////////////////////////////////
Query EquipAttrByID(vEquipAttrDR) As %SQLQuery(ROWSPEC = "Description:%String:名称,HIDDEN:%String,Code:%String:编码") [ SqlProc ]
{
SELECT EA_Name,
	   EA_RowID,
	   EA_Code
FROM sqluser.DHC_EQCEquipAttribute
where EA_InvalidFlag = 'N' and EA_RowID=:vEquipAttrDR
}

/// Add By DJ 2020-02-04
/// 描述:南大二附院防控疫情设备投入使用情况统计
/// d ##class(%ResultSet).RunQuery("web.DHCEQStoreMoveNew","GetEpidemicEQ","2001-01-01","2020-02-04")
Query GetEpidemicEQ(vEquipAttrDR As %String = "", vStatType As %String = "", vStartDate As %String = "", vEndDate As %String = "", vMoveType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TStoreMoveNo:%String,TMoveType:%String,TFromLoc:%String,TToLoc:%String,TEquipName:%String,TModel:%String,TNum:%String,TOriginalFee:%String,TAmount:%String,TMoveTypeDR:%String,TFromLocDR:%String,TToLocDR:%String") [ SqlProc ]
{
}

ClassMethod GetEpidemicEQExecute(ByRef qHandle As %Binary, vEquipAttrDR As %String = "", vStatType As %String = "", vStartDate As %String = "", vEndDate As %String = "", vMoveType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (vEquipAttrDR="")||(vStatType="")||(vStartDate="")||(vEndDate="")  Quit $$$OK
	
	s SDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
	s EDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
	s ETRowID=0
	f  s ETRowID=$o(^DHCEQStoreMove(0,"TypeDate",ETRowID)) q:ETRowID=""  d
	.q:##Class(web.DHCEQCommon).EquipTypeIsIn(ETRowID,CurGroupID)="1"
	.s BillDate=SDate-1
	.f  s BillDate=$o(^DHCEQStoreMove(0,"TypeDate",ETRowID,BillDate)) q:((BillDate="")||(BillDate>EDate))  d
	..s SMRowID=0
	..f  s SMRowID=$o(^DHCEQStoreMove(0,"TypeDate",ETRowID,BillDate,SMRowID)) q:(SMRowID="")  d
	...s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	...q:SMInvalidFlag="Y"
	...s SMStatus=$p($g(^DHCEQStoreMove(SMRowID)),"^",13)
	...q:SMStatus'=2
	...d ResetVariablesGetEpidemicEQ
	...s TStoreMoveNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	...s TMoveTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",12)	//MoveTypeDR
	...q:(TMoveTypeDR'=0)&&(TMoveTypeDR'=3)
	...s TMoveType=$Case(TMoveTypeDR,"0":"库房分配","3":"科室退库")
	...s TFromLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",2)		//FromLocDR
	...s TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
	...s TToLocDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)		//ToLocDR
	...s TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
	...s SMLRowID=0
	...f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID)) q:SMLRowID=""  d
	....s TRowID=SMLRowID
	....s SMLEquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
	....s SMLInStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
	....s (ItemDR,OCLRowID)=""
	....i SMLEquipDR'=""  d
	.....s ItemDR=$p($g(^DHCEQEquip(SMLEquipDR)),"^",7)
	.....s OCLRowID=$p($g(^DHCEQEquip(SMLEquipDR)),"^",77)
	....e  d
	.....s ItemDR=$p($g(^DHCEQInStockList(SMLInStockListDR)),"^",16)
	.....s OCLSourceType=$p($g(^DHCEQInStockList(SMLInStockListDR)),"^",18)
	.....i OCLSourceType="2" s OCLRowID=$p($g(^DHCEQInStockList(SMLInStockListDR)),"^",19)
	....q:(vStatType=1)&&(ItemDR="")
	....q:(vStatType=2)&&(OCLRowID="")
	....i vStatType=1 s SourceID=ItemDR
	....i vStatType=2 s SourceID=OCLRowID
	....i vStatType=3 s SourceID=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	....s Count=$L(SourceID,",")
	....s (Find,EQCount)=0
	....s i=0
	....f i=1:1:Count  d
	.....s CurID=$p(SourceID,",",i)
	.....s EARowID=0
	.....f  s EARowID=$o(^DHCEQEquipAttributeList(0,"SourceAttribute",vStatType,CurID,vEquipAttrDR,EARowID))  q:(EARowID="")||(Find'=0)  d
	......q:$p($g(^DHCEQEquipAttributeList(EARowID)),"^",6)="Y"
	......s Find=EARowID
	.....i (vStatType=3)&&(Find'=0)  d
	......s EQCount=EQCount+1
	......s Find=0
	....q:(vStatType'=3)&&(Find=0)
	....q:(vStatType=3)&&(EQCount=0)
	....s TEquipName=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",5)
	....s TNum=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",8)
	....i vStatType=3 s TNum=EQCount
	....i TMoveTypeDR=3 s TNum=0-TNum
	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQStoreMoveList(SMLRowID)),"^",7))
	....s TAmount=##Class(web.DHCEQCommon).FormatNumber(TNum*TOriginalFee)
	....s TModel=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
	....s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModel)
	....d OutputRowGetEpidemicEQ
	
	Quit $$$OK
OutputRowGetEpidemicEQ
	s Data=$lb(TRowID,TStoreMoveNo,TMoveType,TFromLoc,TToLoc,TEquipName,TModel,TNum,TOriginalFee,TAmount,TMoveTypeDR,TFromLocDR,TToLocDR)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEpidemicEQ
	s (TRowID,TStoreMoveNo,TMoveType,TFromLoc,TToLoc,TEquipName,TModel,TNum,TOriginalFee,TAmount,TMoveTypeDR,TFromLocDR,TToLocDR)=""
	quit
}

ClassMethod GetEpidemicEQFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEpidemicEQExecute ]
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

ClassMethod GetEpidemicEQClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEpidemicEQExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By CZF 20210319
/// 检查设备是否已经出库过
/// w ##class(web.DHCEQStoreMoveNew).CheckEQStoreMoved()
ClassMethod CheckEQStoreMoved(SMLRwoID)
{
	s FindFlag=0
	i SMLRwoID="" q 0
	s SMLEQRowIDs=$g(^DHCEQStoreMoveList(SMLRwoID,"EX","RowIDs"))
	i SMLEQRowIDs="" q 0
	
	s SMEQLen=$l(SMLEQRowIDs,",")
	f ii=1:1:SMEQLen
	{
		s SMEQID=$p(SMLEQRowIDs,",",ii)
		d CheckEQInStoreMove
		q:FindFlag'=0
	}
	
	q FindFlag
	
CheckEQInStoreMove
	s SMLDR=SMLRwoID
	f  s SMLDR=$o(^DHCEQStoreMoveList(SMLDR),-1) q:(SMLDR="")||(FindFlag'=0)  d
	.s SMDR=$p($g(^DHCEQStoreMoveList(SMLDR)),"^",1)
	.q:SMDR=""
	.q:$p($g(^DHCEQStoreMove(SMDR)),"^",27)="Y"
	.q:$p($g(^DHCEQStoreMove(SMDR)),"^",13)'=2
 	.q:$p($g(^DHCEQStoreMove(SMDR)),"^",12)'=0	//转移类型
 	.s EQRowIDs= $g(^DHCEQStoreMoveList(SMLDR,"EX","RowIDs"))
 	.i (","_EQRowIDs_",")[(","_SMEQID_",") s FindFlag=1
	quit
}

/// modified by ZY  20220928
/// 批量转移设备处理.
/// add by czf 1967013 2021-06-07
/// d ##class(%ResultSet).RunQuery("web.DHCEQStoreMoveNew","GetImportSMEquipList","10684","","77")
Query GetImportSMEquipList(Job As %String = "", DisplayFlag As %String = "", User As %String = "") As %Query(ROWSPEC = "Job:%String,TEquipName:%String,TModel:%String,TNo:%String,TFileNo:%String,TLeaveFactoryNo:%String,TFromLoc:%String,TToLoc:%String,TStatus:%String,TEquipTypeDR:%String,TEquipType:%String,TTransAssetDate:%String,TOriginalFee:%String,TNetFee:%String,TDepreTotalFee:%String,TFlag:%String,TFlagRemark:%String,TLocation:%String,TReceiver:%String")
{
}

ClassMethod GetImportSMEquipListExecute(ByRef qHandle As %Binary, Job As %String = "", DisplayFlag As %String = "", User As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	i User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s index=2
	s (TotalQyt,TotalOriginalFee,TotalNetFee,TotalDepreFee)=0

	i $Data(^TempDHCEQ("StoreMoveEquipIDs",User,Job))
	{
		s StoreLocID=0
		f  s StoreLocID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,Job,StoreLocID)) q:StoreLocID=""  d
		.s ToLocID=0
		.f  s ToLocID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,Job,StoreLocID,ToLocID)) q:ToLocID=""  d
		..s EquipTypeID=0
		..f  s EquipTypeID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,Job,StoreLocID,ToLocID,EquipTypeID)) q:EquipTypeID=""  d
		...s ReciverID=""
		...f  s ReciverID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,Job,StoreLocID,ToLocID,EquipTypeID,ReciverID))  q:ReciverID=""  d
		....s LocationID=""
		....f  s LocationID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,Job,StoreLocID,ToLocID,EquipTypeID,ReciverID,LocationID))  q:LocationID=""  d
		.....s TEquipID=0
		.....f  s TEquipID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,Job,StoreLocID,ToLocID,EquipTypeID,ReciverID,LocationID,TEquipID)) q:TEquipID=""  d
		......s CheckResult=$g(^TempDHCEQ("StoreMoveEquipIDs",User,Job,StoreLocID,ToLocID,EquipTypeID,ReciverID,LocationID,TEquipID))
		......s TFlag=$p(CheckResult,"^",1)
		......q:(DisplayFlag'="")&&(DisplayFlag'=TFlag)
		......d ResetVariableGetImportSMEquipList
		......s TFlagRemark=$p(CheckResult,"^",2)	//2006368 czf 20210707
		......s TFromLocDR=StoreLocID
		......s TToLocDR=ToLocID
		......s TEquipTypeDR=EquipTypeID
		......s TLocationDR=LocationID
		......s TReceiverDR=ReciverID
		......s TFromLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TFromLocDR)
		......s TToLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TToLocDR)
		......s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
		......s TLocation=##Class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
		......s TReceiver=##Class(web.DHCEQCommon).GetTrakNameByID("user",TReceiverDR)
		......s EquipData=$g(^DHCEQEquip(TEquipID))
		......s TEquipName=$p(EquipData,"^",1)
		......s TModelDR = $p(EquipData,"^",3)
		......s TModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
		......s TOriginalFee =##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"")
		......s TNetFee =##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",28),"")
		......s TDepreTotalFee =##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",35),"")
		......s TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",45),"date")
		......s TNo = $p(EquipData,"^",71)
		......s TFileNo = $p(EquipData,"^",85)
		......s TLeaveFactoryNo = $p(EquipData,"^",10)
		......s TStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay($p(EquipData,"^",38))
		......s TotalQyt=TotalQyt+1
		......s TotalOriginalFee=TotalOriginalFee+TOriginalFee
		......s TotalNetFee=TotalNetFee+TNetFee
		......s TotalDepreFee=TotalDepreFee+TDepreTotalFee
		......d OutputRowGetImportSMEquipList
	}
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s index=1
		i TotalFlag="2" s index=index+1
		i TotalFlag="3" s index=0
		d ResetVariableGetImportSMEquipList
		s TNo="合计"
		s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TotalOriginalFee,"")
		s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TotalNetFee,"")
		s TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalDepreFee,"")
		s TEquipName="数量:"_TotalQyt
		d OutputRowGetImportSMEquipList
	}
	Quit $$$OK
	
OutputRowGetImportSMEquipList
	s Data=$lb(Job,TEquipName,TModel,TNo,TFileNo,TLeaveFactoryNo,TFromLoc,TToLoc,TStatus,TEquipTypeDR,TEquipType,TTransAssetDate,TOriginalFee,TNetFee,TDepreTotalFee,TFlag,TFlagRemark,TLocation,TReceiver)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariableGetImportSMEquipList
	s (TEquipName,TModel,TNo,TFileNo,TLeaveFactoryNo,TFromLocDR,TFromLoc,TToLocDR,TToLoc,TStatus,TEquipType,TTransAssetDate,TOriginalFee,TNetFee,TDepreTotalFee,TFlag,TFlagRemark,TLocation,TLocation,TReceiverDR,TReceiver)=""
	quit
}

ClassMethod GetImportSMEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetImportSMEquipListExecute ]
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

ClassMethod GetImportSMEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetImportSMEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by ZY  20220928
/// Creator:	add by czf 2021-06-08
/// Description:批量导入转移设备
/// Input:		val:EquipID1^ToLocID1^ReceiverID1^LocationID1$$EquipID2^ToLocID2^ReceiverID2^LocationID2
/// Command:	w ##Class(web.DHCEQStoreMoveNew).ImportStoreMoveEquip(3816,1)
ClassMethod ImportStoreMoveEquip(Job, val)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	k ^TempDHCEQ("StoreMoveEquipIDs",User)
	new EquipNo,EquipIDs,EquipID,EquipTypeID,StoreLocID,InStockListID,Len,i,Flag
	s Flag=0
	s ErrMsgs=""
	s Len=$L(val,"$$")
	for i=1:1:Len
	{
		s EquipInfo=$p(val,"$$",i)
		continue:EquipInfo=""
		s EquipID=$p(EquipInfo,"^",1)
		continue:EquipID=""
		s ToLocID=$p(EquipInfo,"^",2)
		continue:ToLocID=""
		s ReceiverID=$p(EquipInfo,"^",3)
		i ReceiverID="" s ReceiverID=0
		s LocationID=$p(EquipInfo,"^",4)
		i LocationID="" s LocationID=0
		s EquipTypeID=$p(^DHCEQEquip(EquipID),"^",63)
		s StoreLocID=$p(^DHCEQEquip(EquipID),"^",67)
 		/// Modefied By ZC0133 2023-4-20 判断改成后台处理 begin
 		continue:ToLocID=StoreLocID
 		s ToLocType=##Class(web.DHCEQCommon).CheckLocTypeNew(ToLocID)
 		continue:ToLocType=""
 		/// Modefied By ZC0133 2023-4-20 判断改成后台处理 end
 		
		;查看设备是不是已经存在其他的单据中
		s CheckResult=##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR("1","",EquipID,StoreLocID,"","Y")
		i +$p(CheckResult,"^",1)=1
		{
			 s ^TempDHCEQ("StoreMoveEquipIDs",User,Job,StoreLocID,ToLocID,EquipTypeID,ReceiverID,LocationID,EquipID)=CheckResult
			 s Flag=Flag+1
			 i $p(CheckResult,"^",2)'=""
			 {
			 	i ErrMsgs'="" s ErrMsgs=ErrMsgs_";"
			 	s ErrMsgs=ErrMsgs_$p(CheckResult,"^",2)
			 }
		}
		else
		{
			s ^TempDHCEQ("StoreMoveEquipIDs",User,Job,StoreLocID,ToLocID,EquipTypeID,ReceiverID,LocationID,EquipID)=""
		}
	}
	q Flag_"^"_ErrMsgs
}

/// modified by ZY  20220928
/// Creator:	add by czf 2021-06-08
/// Description:批量转移设备处理.
/// Input:		Job:			记录导入数据的唯一jobID
/// 			OperationType:	操作类型：1,生成单据申请;2,生成提交转移单;3,生成审批完成的单据
/// 			KindFlag:0:单台 1:批量
/// Command:w ##Class(web.DHCEQStoreMoveNew).BuildStoreMoveRequest("26972","1","0")
ClassMethod BuildStoreMoveRequest(vJob, OperationType, KindFlag As %String = "1")
{
	s SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))

	s Date=+$H
	s ErrorFlag=0	//保存有错时返回代码
	
	i (vJob="")||(OperationType="" ) q "没有数据!"
	i '$Data(^TempDHCEQ("StoreMoveEquipIDs",User,vJob)) q "没有数据!"
	s StoreLocID=0
	f  s StoreLocID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID))  q:(StoreLocID="")||(ErrorFlag'=0)  d
	.s ToLocID=0
	.f  s ToLocID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID,ToLocID)) q:(ToLocID="")||(ErrorFlag'=0)  d
	..s EquipTypeID=0
	..f  s EquipTypeID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID,ToLocID,EquipTypeID))  q:(EquipTypeID="")||(ErrorFlag'=0)  d
	...s ReciverID=""
	...f  s ReciverID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID,ToLocID,EquipTypeID,ReciverID))  q:(ReciverID="")||(ErrorFlag'=0)  d
	....s LocationID=""
	....f  s LocationID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID,ToLocID,EquipTypeID,ReciverID,LocationID))  q:(LocationID="")||(ErrorFlag'=0)  d
	.....i KindFlag=0 d	;单台
	......s RowIndex=0
	......s EquipID=0
	......f  s EquipID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID,ToLocID,EquipTypeID,ReciverID,LocationID,EquipID))  q:(EquipID="")||(ErrorFlag'=0)  d
	.......s CheckResult=$g(^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID,ToLocID,EquipTypeID,ReciverID,LocationID,EquipID))
	.......q:CheckResult'=""
	.......;处理设备在其他转移单占用的问题
	.......;i CheckResult'="" s ErrorFlag=##Class(web.DHCEQBatchDisuseRequest).DealEquipInOtherRequest(EquipID)
	.......q:ErrorFlag'=0
	.......d ResetVariablesStoreMoveRequest
	.......s RowIndex=RowIndex+1
	.......d GetStoreMoveList
	.......d SaveStoreMoveRequest
	.......q:ErrorFlag'=0
	.......k ^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID,ToLocID,EquipTypeID,ReciverID,LocationID,EquipID)
	.....e  i KindFlag=2 d	;批量
	......s RowIndex=0
 	......d ResetVariablesStoreMoveRequest
	......s EquipID=0
	......f  s EquipID=$o(^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID,ToLocID,EquipTypeID,ReciverID,LocationID,EquipID))  q:(EquipID="")||(ErrorFlag'=0)  d
	.......s CheckResult=$g(^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID,ToLocID,EquipTypeID,ReciverID,LocationID,EquipID))
	.......q:CheckResult'=""
	.......;处理设备在其他转移单占用的问题
	.......;i CheckResult'="" s ErrorFlag=##Class(web.DHCEQBatchDisuseRequest).DealEquipInOtherRequest(EquipID)
	.......q:ErrorFlag'=0
	.......s RowIndex=RowIndex+1
 	.......d GetStoreMoveList
 	......q:SMLInfoObj=""	//2006413 czf 20210707
	......d SaveStoreMoveRequest
	......q:ErrorFlag'=0
	......k ^TempDHCEQ("StoreMoveEquipIDs",User,vJob,StoreLocID,ToLocID,EquipTypeID,ReciverID,LocationID)
	
	q ErrorFlag
	
ResetVariablesStoreMoveRequest
	s (SMRowID,SMLInfoObj)=""
	q
GetStoreMoveList
	s EquipName=$p($g(^DHCEQEquip(EquipID)),"^",1)
	s ManuFactoryID=$p($g(^DHCEQEquip(EquipID)),"^",26)
	s ModelID=$p($g(^DHCEQEquip(EquipID)),"^",3)
	s OriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
	s QuantityNum=1
	s UnitID=$p($g(^DHCEQEquip(EquipID)),"^",5)
	
	s SMLObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	d SMLObj.%Set("SMLEquipDR",EquipID)
 	d SMLObj.%Set("SMLEquipName",EquipName)
 	d SMLObj.%Set("SMLLocationDR",LocationID)
 	d SMLObj.%Set("SMLManuFactoryDR",ManuFactoryID)
 	d SMLObj.%Set("SMLModelDR",ModelID)
 	d SMLObj.%Set("SMLOriginalFee",OriginalFee)
 	d SMLObj.%Set("SMLQuantityNum",QuantityNum)
 	d SMLObj.%Set("SMLUnitDR",UnitID)
 	d SMLObj.%Set("SMLIndex",RowIndex)
 	
 	i SMLInfoObj="" s SMLInfoObj=SMLObj.%ToJSON()
 	e  s SMLInfoObj=SMLInfoObj_SplitRowCode_SMLObj.%ToJSON()
	q
SaveStoreMoveRequest
 	s SMObj=##class(web.DHCEQ.Plat.JsonObject).%New()
 	s MoveType=""
 	s FromLocType=##Class(web.DHCEQCommon).CheckLocTypeNew(StoreLocID)
 	s ToLocType=##Class(web.DHCEQCommon).CheckLocTypeNew(ToLocID)
 	s:(FromLocType="")||(ToLocType="") ErrorFlag="科室类型不能为空，请设置科室类型!"
 	q:ErrorFlag'=0
 	s:(FromLocType="1")&&(ToLocType="2") MoveType=0		;库房分配
 	s:(FromLocType="2")&&(ToLocType="2") MoveType=1		;科室调拨
 	s:(FromLocType="2")&&(ToLocType="1") MoveType=3		;科室退库
 	s:(FromLocType="1")&&(ToLocType="1") MoveType=4		;库房分配
 	s:MoveType="" ErrorFlag="转移类型错误，请检查设备科室和接收科室类型!"
 	q:ErrorFlag'=0
 	
 	d SMObj.%Set("SMMoveType",MoveType)
 	d SMObj.%Set("SMFromLocDR",StoreLocID)
 	d SMObj.%Set("SMToLocDR",ToLocID)
 	d SMObj.%Set("SMReciverDR",ReciverID)
 	d SMObj.%Set("SMEquipTypeDR",EquipTypeID)
	d SMObj.%Set("SMStoreMoveNo","")
	d SMObj.%Set("SMJob",vJob)
	
 	;保存转移单
 	s RtnStr=##class(web.DHCEQ.EM.BUSStoreMove).SaveData(SMObj.%ToJSON(), SMLInfoObj, 0)	//更新
 	s RtnObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(RtnStr)
 	i RtnObj.SQLCODE'=0 s ErrorFlag=RtnObj.Data_"转移单更新失败！"
 	q:ErrorFlag'=0
	s SMRowID=RtnObj.Data
	
	;提交转移单
 	if OperationType>1 
	{
		Set RtnStr=##class(web.DHCEQ.EM.BUSStoreMove).SubmitData(SMRowID)	//提交
	 	s RtnObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(RtnStr)
 		i RtnObj.SQLCODE'=0 s ErrorFlag=RtnObj.Data_"转移单提交失败！"
	}
 	q:ErrorFlag'=0
 	
	;审核转移单
	if OperationType>2
	{
	 	s buildApproveType=##class(web.DHCEQApproveList).GetApproveType("14")
		s buildApproveSet=##class(web.DHCEQApproveList).GetApproveSet("14", SMRowID)
		i buildApproveSet="" s ErrorFlag=-4007	
		q:ErrorFlag'=0
		s AFStep=0
		f  s AFStep=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",buildApproveSet,AFStep))  q:(AFStep="")||(ErrorFlag'=0)  d
		.s AFRowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",buildApproveSet,AFStep,0))
		.s (AFRoleDR,AFLastFlag)=""
		.i AFRowID'=""  d
		..s AFRoleDR=$p(^DHCEQCCode("DHCEQCApproveFlow",AFRowID),"^",2)
		..s AFLastFlag=$p(^DHCEQCCode("DHCEQCApproveFlow",AFRowID),"^",4)
		.s RtnStr=##class(web.DHCEQ.EM.BUSStoreMove).AuditData(SMRowID,AFRoleDR,AFStep,"","")
		.s RtnObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(RtnStr)
		.i RtnObj.SQLCODE'=0 s ErrorFlag=RtnObj.Data
		
	 	i ErrorFlag'=0 q ErrorFlag_"转移单审核失败！"
	}
 	q
}

/// Creator:czf
/// CreateDate:2021-06-08
/// Description:获取设备库房科室ID
/// OutPut:科室ID
ClassMethod GetEQStoreLocID(EquipID) As %String
{
	q $p(^DHCEQEquip(EquipID),"^",67)
}

/// add by czf 2022-06-29
/// 获取出库明细对应的退库数量和总金额
/// w ##Class(web.DHCEQStoreMoveNew).GetReturnInfoOfSMList(1046,"")
ClassMethod GetReturnInfoOfSMList(SMLRowID, vEQID As %String = "")
{
	new (SMLRowID,vEQID)
	s (num,amount,outnum,outamount)=0
	s (vEQRowIDs,vMoveType,vSMDate,vToLocDR)=""
	i SMLRowID'="" d
	.s vEQRowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	.s vSMRowID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
	.s vMoveType=$p($g(^DHCEQStoreMove(vSMRowID)),"^",12)
	.s vSMDate=$p($g(^DHCEQStoreMove(vSMRowID)),"^",10)		//出库日期
	.s vToLocDR=$p($g(^DHCEQStoreMove(vSMRowID)),"^",3)		//接收科室
	i vEQID'="" d
	.s vSMDate=$p($g(^DHCEQEquip(vEQID)),"^",44)			//出库日期
	.s vToLocDR=$p($g(^DHCEQStoreMove(vSMRowID)),"^",3)		//接收科室
	i vMoveType'=0 q num_"^"_amount_"^"_outnum_"^"_outamount		//仅针对出库明细
	
	if (SMLRowID>0)
	{
		s vStockDate=0
		f  s vStockDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,vStockDate)) q:(vStockDate="")||(vStockDate>vSMDate)  d
	 	.s vStatCatDR=""
	 	.f  s vStatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,vStockDate,vStatCatDR)) q:vStatCatDR=""  d
	 	..s SRowID=0
	 	..f  s SRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,vStockDate,vStatCatDR,3,SRowID)) q:SRowID=""  d
	 	...s TInvalidFlag=$p($g(^DHCEQStoreMove(SRowID)),"^",27)
	 	...q:TInvalidFlag'="N"
	 	...q:(vToLocDR'="")&&($p($g(^DHCEQStoreMove(SRowID)),"^",2)'=vToLocDR)
		...s SLRowID=0
 		...f  s SLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SRowID,SLRowID))  q:SLRowID=""  d
 		....s SLQuantity=$p($g(^DHCEQStoreMoveList(SLRowID)),"^",8)
		....s SLOriginalFee=$p($g(^DHCEQStoreMoveList(SLRowID)),"^",7)
		....s EQRowIDs=$g(^DHCEQStoreMoveList(SLRowID,"EX","RowIDs"))
		....f i=1:1:$l(EQRowIDs,",")  d
		.....s EQID=$p(EQRowIDs,",",i)
		.....q:(vEQRowIDs'="")&&((","_vEQRowIDs_",")'[(","_EQID_","))
		.....q:(vEQID'="")&&(EQID'=vEQID)
		.....s num=num+1
		.....s amount=SLOriginalFee*1+amount
		
		s vStockDate=0
		f  s vStockDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,vStockDate)) q:(vStockDate="")||(vStockDate>vSMDate)  d
	 	.s vStatCatDR=""
	 	.f  s vStatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,vStockDate,vStatCatDR)) q:vStatCatDR=""  d
	 	..s SRowID=0
	 	..f  s SRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,vStockDate,vStatCatDR,0,SRowID)) q:SRowID=""  d
	 	...s TInvalidFlag=$p($g(^DHCEQStoreMove(SRowID)),"^",27)
	 	...q:TInvalidFlag'="N"
	 	...q:(vToLocDR'="")&&($p($g(^DHCEQStoreMove(SRowID)),"^",3)'=vToLocDR)
		...s SLRowID=0
 		...f  s SLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SRowID,SLRowID))  q:SLRowID=""  d
 		....q:SLRowID=SMLRowID
 		....s SLQuantity=$p($g(^DHCEQStoreMoveList(SLRowID)),"^",8)
		....s SLOriginalFee=$p($g(^DHCEQStoreMoveList(SLRowID)),"^",7)
		....s EQRowIDs=$g(^DHCEQStoreMoveList(SLRowID,"EX","RowIDs"))
		....f i=1:1:$l(EQRowIDs,",")  d
		.....s EQID=$p(EQRowIDs,",",i)
		.....q:(vEQRowIDs'="")&&((","_vEQRowIDs_",")'[(","_EQID_","))
		.....q:(vEQID'="")&&(EQID'=vEQID)
		.....s outnum=outnum+1
		.....s outamount=SLOriginalFee*1+outamount
	}
	q num_"^"_amount_"^"_outnum_"^"_outamount
}

/// add by czf 2022-06-29
/// 获取出库明细对应的退库明细
/// d ##Class(web.DHCEQStoreMoveNew).GetStoreMoveListLinkTKID(1046,26244)
ClassMethod GetStoreMoveListLinkTKID(SMLRowID, vEQID As %String = "")
{
	n (SMLRowID, vEQID)
	i SMLRowID'=""
	{
		s vSMRowID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
		s vMoveType=$p($g(^DHCEQStoreMove(vSMRowID)),"^",12)
		i vMoveType'=0 q
		s vEQRowIDs=$g(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
		f i=1:1:$l(vEQRowIDs,",")  d
		.s SMLEQID=$p(vEQRowIDs,",",i)
		.q:(vEQID'="")&&(vEQID'=SMLEQID)
		.s vStockDate=0
		.f  s vStockDate=$o(^DHCEQStoreMove(0,"InAckDateStat",2,vStockDate)) q:(vStockDate="")  d
	 	..s vStatCatDR=""
	 	..f  s vStatCatDR=$o(^DHCEQStoreMove(0,"InAckDateStat",2,vStockDate,vStatCatDR)) q:vStatCatDR=""  d
	 	...s SRowID=0
	 	...f  s SRowID=$o(^DHCEQStoreMove(0,"InAckDateStat",2,vStockDate,vStatCatDR,3,SRowID)) q:SRowID=""  d
	 	....s TInvalidFlag=$p($g(^DHCEQStoreMove(SRowID)),"^",27)
	 	....q:TInvalidFlag'="N"
		....s SLRowID=0
 		....f  s SLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SRowID,SLRowID))  q:SLRowID=""  d
		.....s EQRowIDs=$g(^DHCEQStoreMoveList(SLRowID,"EX","RowIDs"))
		.....q:((","_EQRowIDs_",")'[(","_SMLEQID_","))
		.....;判断当前转移明细的设备是否已存在对应退库记录ID，不存在则记录^DHCEQTempSMTKList
		.....s pFlag=0
		.....s pSMLRowID=""
		.....f  s pSMLRowID=$o(^DHCEQTempSMTKList("TKList",pSMLRowID)) q:(pSMLRowID="")||(pFlag=1)  d
		......i $g(^DHCEQTempSMTKList("TKList",pSMLRowID,SMLEQID))=SLRowID s pFlag=1
		.....q:pFlag=1
		.....s ^DHCEQTempSMTKList("TKList",SMLRowID,SMLEQID)=SLRowID
	}
}

}
