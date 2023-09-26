Class web.DHCEQ.EM.BUSReturn Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

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
///    d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSReturn","GetInStockList","","393","2","","1","4","2","","","","false","","")
Query GetInStockList(RowID, FromLocDR, EquipTypeDR, StatCatDR, StockStatus, ProviderDR, ListType, Equip, InStockNo, UseLocDR As %String = "", TFlag As %String = "", Type As %String = "", AllListInfo As %String = "") As %Query(ROWSPEC = "TName:%String,TEquipID:%String,TInStockListID:%String,TModelDR:%String,TModel:%String,TManuFactoryDR:%String,TManuFactory:%String,TUnitDR:%String,TUnit:%String,TQuantity:%String,TOriginalFee:%String,TInStockNo:%String,TEquipNo:%String,TInvoiceNo:%String,TRequestLoc:%String,TLocationDR:%String,TLocation:%String,TInDate:%String,TCommonName:%String,TRemark:%String")
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
	.i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1) //2013-06-24 DJ0118 end
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
	e  d
	.;批量取入库明细信息
	.s EquipID=""
	.s TCommonName = $p($g(^DHCEQInStockList(InStockListID)),"^",5)	//2013-06-24 DJ0118 begin
	.s TName=$p($g(^DHCEQInStockList(InStockListID)),"^",16)
	.i TName'="" s TName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1) //2013-06-24 DJ0118 end
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
	s Data=$lb(TName,EquipID,InStockListID,TModelDR,TModel,TManuFactoryDR,TManuFactory,TUnitDR,TUnit,TQuantity,TOriginalFee,TInStockNo,TEquipNo,TInvoiceNo,RequestLoc,TLocationDR,TLocation,TInDate,TCommonName,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockList
	s (TName,TModelDR,TModel,TManuFactoryDR,TManuFactory,TUnitDR,TUnit,TOriginalFee,TEquipNo,RequestLoc,TLocationDR,TLocation,TInDate,TCommonName,TRemark)=""
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

/// Modefied by zc0125 2022-12-12 增加入参vInventoryListDR和vInventoryExceptionDR
ClassMethod SaveData(data, dataList, DelIs, vInventoryListDR As %Library.String = "", vInventoryExceptionDR As %Library.String = "")
{
    s $ZT="ERRORReturn"
    k PLIST,RowID,SQLCODE
    s SQLCODE=0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Date=+$H
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s RowID = JsonData.RRowID
	TSTART
	if DelIs=1
	{
		s RowID=data
		&SQL(Update SQLUSER.DHC_EQReturn set R_InvalidFlag='Y' where R_RowID = :RowID)
        //modified by ZY 20220926 2757106 删除明细占用节点记录
        i SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
        s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss("","23",RowID,1)
        i SQLCODE
        {
            TROLLBACK
            Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除明细占用节点记录")
        }
        //end by ZY 20220926 2757106 删除明细占用节点记录
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQReturn",JsonData,.PLIST)
		s RowID = JsonData.RRowID
		s Job = JsonData.RJob
	 	s PLIST(6) = User	;RequestUserDR
	 	s PLIST(7) = Date	;RequestDate
		s PLIST(14) = "0"	;Status
		s PLIST(29) = "N"
		if RowID=""
		{
			s OutTypeCode=$p(^DHCEQCCode("DHCEQCOutType",JsonData.ROutTypeDR),"^",1)		
	 		s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQReturn",+$H,"",JsonData.REquipTypeDR,"","","",OutTypeCode)
	 		&SQL(insert into sqluser.DHC_EQReturn values :PLIST())
		}
		else
		{
			&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
		}
		s RowID=$G(%ROWID)
		i SQLCODE
 		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		} 	
		
 		s SQLCODE=..JudgeRLQuantityNum(RowID,Job,dataList)
 		i SQLCODE
 		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
 		s SQLCODE=..SaveReturnList(RowID,Job,dataList)
 		i SQLCODE
 		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
 	
 		;Modified by JDL 2011-8-25 JDL0094 检查是否设备已经被其他单据占用
 		s SQLCODE=##Class(web.DHCEQStoreMoveNew).CheckOrder(2,RowID)
 		i SQLCODE
 		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
 		//Modefied by zc0125 2022-12-12 增加盘点信息记录 begin	
 		s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).SaveBussInfoByInventory(vInventoryExceptionDR,vInventoryListDR,23,RowID)
 		i SQLCODE
 		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 		}
 		//Modefied by zc0125 2022-12-12 增加盘点信息记录 end	
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORReturn
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSReturn).GetOneReturn(122,"","","")
ClassMethod GetOneReturn(RowID As %Library.String = "", ApproveRoleDR As %Library.String, action As %Library.String = "", step As %Library.String = "")
{
	s $ZT="ERRORGetOneReturn"
	s ObjReturn=##Class(User.DHCEQReturn).%OpenId(RowID)
	s ReturnInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjReturn)
	d ReturnInfo.%Set("RReturnLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjReturn.RReturnLocDR))
	d ReturnInfo.%Set("ROutTypeDR_OTDesc",ObjReturn.ROutTypeDR.OTDesc)
	d ReturnInfo.%Set("RProviderDR_VDesc",ObjReturn.RProviderDR.VName)
	d ReturnInfo.%Set("REquipTypeDR_ETDesc",ObjReturn.REquipTypeDR.ETDesc)
	d ReturnInfo.%Set("RCancelUser_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjReturn.RCancelUser))
	d ReturnInfo.%Set("RMakerDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjReturn.RMakerDR))
	d ReturnInfo.%Set("RUseLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjReturn.RUseLocDR))
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("15",RowID,ApproveRoleDR)
	d ReturnInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d ReturnInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d ReturnInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d ReturnInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d ReturnInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d ReturnInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d ReturnInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d ReturnInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d ReturnInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d ReturnInfo.%Set("NextRole",$p(AppInfo,"^",10))
	s CanChangeValue=""
	i action'="" s CanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("15",action,rowid,2)
	s MultipleRoleFlag=0
	i ($p(CanChangeValue,"^",3)'="")&&((","_$p(CanChangeValue,"^",3))[(","_step_",")) d
	.s MultipleRoleFlag=1
	d ReturnInfo.%Set("MultipleRoleFlag",MultipleRoleFlag)
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,ReturnInfo)
ERRORGetOneReturn
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// ----------------------------------
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述:提交
/// w ##Class(web.DHCEQReturnNew).SubmitData("49^1276^1493^24/08/2010^^1^^1^^^^^1^^")
/// modified by czf 1247213 增加恢复折旧标志ResumeDepreFlag
/// ----------------------------------
ClassMethod SubmitData(val, AutoCancelDepre As %String = "0", ResumeDepreFlag As %String = "0")
{
	new (val, AutoCancelDepre, %session,ResumeDepreFlag)  //add by zx 2016-02-25 Bug ZX0034 消息取不到session
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORSubmit"
	s RowID = $p(val,"^",1)	;RowID
	i RowID="" q ""
	s InvalidFlag=$p($g(^DHCEQReturn(RowID)),"^",28) //2011-10-31 DJ DJ0098
	i InvalidFlag="Y" q -1015 //2011-10-31 DJ DJ0098
	//add by zy 20120316  zy0091
	s ReturnProvider=##class(web.DHCEQ.EM.BUSInStock).ProviderIsUniqueNew("Return",RowID)
	i ReturnProvider<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnProvider,"与台账供应商不一致") ;Add by QW20220426 增加错误信息 BUG:QW0158
	
	s User=$p(val,"^",13)
	s ReturnLocDR = $p(val,"^",2)	;ReturnLocDR
	s EquipTypeDR = $p(val,"^",6)	;EquipTypeDR
	s StatCatDR = $p(val,"^",7)		;StatCatDR
	s UseLocDR=$p($g(^DHCEQReturn(RowID)),"^",24) ;UseLocDR
	s Job = $p(val,"^",16) 		;$job
	s OutTypeDR =$p($g(^DHCEQReturn(RowID)),"^",17)		;OutTypeDR
	s PLIST(6) = User 				;MakerDR
 	s PLIST(7) = Date
	s PLIST(14) = "1"				;Status
	s LocType=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0101",0))
  	i ('$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,ReturnLocDR))&&(OutTypeDR=1)) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1005)   //判断退货单中的科室类型是否属于库房  //modify by jyp 2018-12-26 修改设备可从科室减少
	//modified by wy 2020-8-18 1472506 屏蔽库房管理下科室
	//s Find=1
	//i UseLocDR'="" s Find=$d(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",ReturnLocDR,UseLocDR))
	//i Find=0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1009) //当存在使用科室时判断是否属于库房管理下科室
	s ReturnEquipType=##CLASS(web.DHCEQ.EM.BUSInStock).EquipTypeIsUniqueNew(RowID,EquipTypeDR,"Return")
	;Modified By QW20210916 BUG:QW0149 明确错误信息 begin
	i ReturnEquipType<0 	
	{
		s ErrMsg=""
		i ReturnEquipType=-1006 s ErrMsg="明细设备的类组不一致!"
		i ReturnEquipType=-1007 s ErrMsg="明细与单据的类组不一致!"
		i ReturnEquipType=-1008 s ErrMsg="设备与单据的使用科室不一致!"
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnEquipType,ErrMsg) 
	}
	;Modified By QW20210916 BUG:QW0149 end
	s Flag=##class(web.DHCEQCommon).GetSysInfo("301007")   //单据中设备类型是否需要一致
	//modified by wy 2020-10-26 单据中设备类型检测方法,传入StatCatDR为空
	if (Flag=1)
	{
		s ReturnType=..StatCatIsUniqueNew(RowID,StatCatDR)
		i ReturnType<0 	//modified by wy 2020-12-1 1614675
		{
			s ErrMsg=""
			i ReturnType=-1001 s ErrMsg="明细设备类型不一致!"
			i ReturnType=-1002 s ErrMsg="明细设备类型与总单不一致!"
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(ReturnType,ErrMsg) //modified by wy 2020-12-1 1614675  转化json格式输出
		}
	}
	
	s ApproveCondition="OutTypeDR,DHCEQReturn,"_OutTypeDR
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("15")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR,"","","","",ApproveCondition)
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-4007)
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"		;Status
	
	s AuditFlag=0		//判断是否是最后一步,0:否;1:是
	//add by zy 2011-03-16 
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s AppInfoStatus="2"
	}
	
	TSTART
	//删除已经审批过的意见
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"15",User)
	i SQLCODE
	{
		TROLLBACK
	 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	if AuditFlag=1  //没有设置审批流,就直接审核
 	{
		s SQLCODE=##Class(web.DHCEQ.EM.BUSReturn).LastAuditAction(RowID, User, Date, AutoCancelDepre,ResumeDepreFlag)	//DJ0137 // modified by czf 1247213
		if SQLCODE'=0 //2011-05-27 DJ
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
 	}
 	else
 	{
	 	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	    If SQLCODE
	    {
		    TROLLBACK
		    Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	    }
		&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
 	}
 	;Modified by jdl 2011-3-9  jdl0073
 	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("23", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
 	TCOMMIT
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORSubmit 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg) //返回错误消息 ;
}

ClassMethod StatCatIsUniqueNew(RowID, StatCatID)
{
	new (RowID, StatCatID)
	
	s ResultFlag=0
	s PreStatCatID=0	
	
	s ListStatCatID=""
	s RLRowID=0	
	f  s RLRowID=$O(^DHCEQReturnList(0,"Return",RowID,RLRowID)) q:(RLRowID="")||(ResultFlag'=0)  d
	.s BatchFlag=$P(^DHCEQReturnList(RLRowID),"^",2)
	.s InStockListDR=$P(^DHCEQReturnList(RLRowID),"^",3)
	.s EquipDR=$P(^DHCEQReturnList(RLRowID),"^",4)
	.i (BatchFlag="Y")&&(InStockListDR'="")  d //2011-05-26 DJ
	..s ListStatCatID=$P(^DHCEQInStockList(InStockListDR),"^",17)
	.e  i EquipDR'="" d
	..s ListStatCatID=$P(^DHCEQEquip(EquipDR),"^",75)
	.i (PreStatCatID=0) s PreStatCatID=ListStatCatID
	..;明细中类型不一致
	.i (PreStatCatID'=ListStatCatID) d
	..s ResultFlag=-1001
	.e  i ((StatCatID'="")&&(StatCatID'=ListStatCatID))  d
	...;明细中类型与单据类型不一致
	..s ResultFlag=-1002
	i ResultFlag'=0 q ResultFlag	
	q ListStatCatID
}

/// ----------------------------------
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述：增加设备退货生命周期信息记录
/// w ##Class(web.DHCEQ.EM.BUSReturn).LastAuditAction(4,10248,65496,"0","1")
/// ----------------------------------
ClassMethod LastAuditAction(RowID, User, Date, AutoCancelDepre, ResumeDepreFlag)
{
	new RLRowID,StoreLocDR,EquipTypeDR,SQLCODE,EquipDR,equipRowIDs
	k PLIST			//modified by czf 1247213 begin
	i RowID="" q ""
	//增加冲减累计折旧 DJ0137
	i AutoCancelDepre="1"
	{
		s SQLCODE=..AutoCancelDepre(RowID)
		i SQLCODE q SQLCODE
	}
	k PLIST
	//增加恢复折旧 modified by czf 1247213
	i ResumeDepreFlag = "1"
	{
		s SQLCODE=..ResumeDepre(RowID)	
		i SQLCODE q SQLCODE
	}
	k PLIST			//modified by czf 1247213 end
	//修改申请单的状态
	s PLIST(8)=User		;AckUserDR
	s PLIST(9)=Date		;AckDate
	s PLIST(11)=User		;BillAckUserDR
	s PLIST(12)=Date		;BillAckDate
	s PLIST(14)="2"			;Status
	i $p($g(^DHCEQReturn(RowID)),"^",13)=2 q -1010
	&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
	i SQLCODE q SQLCODE
	// Modefied by zc0125 2022-12-12 最终业务处理结果记录 begin
	s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).SaveDisposeResultByBussType(23,RowID)
	i SQLCODE q SQLCODE
	// Modefied by zc0125 2022-12-12 最终业务处理结果记录 end
	//修改设备的信息
	s StoreLocDR=$P(^DHCEQReturn(RowID),"^",2)
	s EquipTypeDR=$P(^DHCEQReturn(RowID),"^",15)
	s SQLCODE=0
	s RLRowID=0
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RowID,RLRowID))  quit:(RLRowID="")||(SQLCODE'=0)  d
	.s BatchFlag=$P(^DHCEQReturnList(RLRowID),"^",2)
	.s InStockListDR=$P(^DHCEQReturnList(RLRowID),"^",3)
	.;modified by wy 2020-3-29 需求1247862
	.s equipRowIDs=$G(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
	.;i (BatchFlag="Y")&(InStockListDR'="")  d   //批量设备
	..;s equipRowIDs=$G(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
	.;e  d
	..;s equipRowIDs=$P(^DHCEQReturnList(RLRowID),"^",4)
	.s count=$l(equipRowIDs,",")
	.f i=1:1:count d
	..q:SQLCODE'=0
	..s EquipDR=$p(equipRowIDs,",",i)
	..i EquipDR'=""  d
	...s SQLCODE=..SaveOtherInfo(EquipDR,RLRowID,RowID,User)
	.;//Function:Funds	2012-2-16 生成资金来源信息
	.;Modified by JDL 2012-1-4 JDL0108
	.q:SQLCODE'=0
	.s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfo(5, RLRowID)
	.;Mozy0089	2012-10-17
	.Quit:SQLCODE'=0
	.Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(5, RLRowID)
    /// modified by ZY 20220926 2757106
    i SQLCODE q SQLCODE
    s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss("","23",RowID,1)
    q SQLCODE
}

ClassMethod SaveOtherInfo(EquipDR, RLRowID, RRowID, User)
{
	new Date,Time,EquipName
	i (EquipDR="")||(RLRowID="")||(RRowID="") q ""
	k LI
	s (Date,Time,EquipName)=""
	s Date=+$H
	s Time=$P($H,",",2)
	
	s EquipName=$P(^DHCEQEquip(EquipDR),"^",1)
	//修改生命周期
	s LI(2)=EquipDR  								//设备
	s LI(4)=$p($g(^DHCEQEquip(EquipDR)),"^",19)   	//原使用科室 
	s LI(5)=$p($g(^DHCEQEquip(EquipDR)),"^",17) 	//原管理科室
	s LI(6)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  	//原库房
	s LI(7)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  	//原值
	s LI(8)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  	//原净值
	s ReasonDR=$p($g(^DHCEQReturnList(RLRowID)),"^",8) //2010-10-12 Add By DJ
	i ReasonDR'="" s LI(14)=$p($g(^DHCEQCCode("DHCEQCReturnReason",ReasonDR)),"^",2) //退货原因
	s LI(16)=$p($g(^DHCEQReturn(RRowID)),"^",4)		//变动日期    modify by jyp 2020-03-03   JYP0021  将生命周期变动日期设置为减少日期
	s LI(17)=Time									//变动时间
 	s LI(18)=$p($g(^DHCEQReturnList(RLRowID)),"^",10) //费用
 	s LI(19)="C"									//生命周期类型
 	s LI(20)=23										//来源类型
 	s LI(21)=RLRowID 								//来源ID
 	s LI(22)=$p($g(^DHCEQReturn(RRowID)),"^",17) 	//来源辅助类型
 	s LI(23)=$p($g(^DHCEQReturnList(RLRowID)),"^",9) //备注
 	s LI(27)=User									//更新人
 	s LI(28)=Date									//更新日期
 	s LI(29)=Time									//更新时间
 	/************************************************************/ //2011-05-27 DJ Begin
	s EQName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s EQNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	s EQInvalidFlag=$p($g(^DHCEQEquip(EquipDR)),"^",59)
	i EQInvalidFlag="Y"  q EQName_"["_EQNo_"]设备已无效!"
	s EQStockStatus=$p($g(^DHCEQEquip(EquipDR)),"^",60)
	s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	i (EQStockStatus'="1")||(EQStatus=3)  q EQName_"["_EQNo_"]库房状态不符合条件!"
	s ReturnLoc=$p($g(^DHCEQReturn(RRowID)),"^",24) //减少单使用科室
	if ReturnLoc=""  s ReturnLoc=$p($g(^DHCEQReturn(RRowID)),"^",2)
	s EQStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	i ReturnLoc'=EQStoreLocDR  q EQName_"["_EQNo_"]所在库房不符合条件!"
 	/************************************************************/ //2011-05-27 DJ end
	//2011-08-10 DJ begin
	i $fn(LI(7),"",2)'=$fn($p($g(^DHCEQReturnList(RLRowID)),"^",6),"",2) q "["_$p($g(^DHCEQEquip(EquipDR)),"^",1)_"]原值有发生变化,不可批量处理!"
	//2011-08-10 DJ end
	//修改台账
 	s SQLCODE=..SaveEquip(EquipDR,"2",RRowID,User)
	i SQLCODE'=0 q SQLCODE
	
	s LI(9)=$p($g(^DHCEQEquip(EquipDR)),"^",19)  	//变动后使用科室 
 	s LI(10)=$p($g(^DHCEQEquip(EquipDR)),"^",17) 	//变动后管理科室
 	s LI(11)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  	//变动后库房
 	s LI(12)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  	//变动后原值
 	s LI(13)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  	//变动后净值
 	&SQL(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
 	i SQLCODE'=0 q SQLCODE=EquipName_"更新生命周期表信息失败!"
 	
 	//修改库房变动表
 	s SQLCODE=..SaveChangeStock(EquipDR,"2",RLRowID,User)
 	q SQLCODE
}

/// Add By DJ 2015-01-21 DJ0137
/// 描述:自动执行退货冲减折旧操作
ClassMethod AutoCancelDepre(vRRowID As %String = "")
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s CurDate=+$H
	s CurTime=$P($H,",",2)
	i vRRowID="" q 0
	s SQLCODE=0
	s RLRowID=0
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",vRRowID,RLRowID))  q:(RLRowID="")||(SQLCODE'=0)  d
	.s EQRowIDs=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
	.s EQCount=$L(EQRowIDs,",")
	.f i=1:1:EQCount  d
	..q:SQLCODE'=0
	..s EQRowID=$p(EQRowIDs,",",i)
	..s CurMonth=$E($ZD(+$H,3),1,7)
	..s CurMonthDepre=""
	..s MDCount=0
	..s MDRowID=""
	..f  s MDRowID=$o(^DHCEQMonthDepre(0,"Equip",EQRowID,MDRowID),-1)  q:(MDRowID="")||(MDCount'=0)  d
	...s MDStatus=$p($g(^DHCEQMonthDepre(MDRowID)),"^",20)
	...q:MDStatus="3"
	...s MDMainFlag=$p($g(^DHCEQMonthDepre(MDRowID)),"^",3)
	...q:MDMainFlag'="Y"
	...s MDDepreMonth=$p($g(^DHCEQMonthDepre(MDRowID)),"^",6)
	...i MDDepreMonth=CurMonth  d
	....s CurMonthDepre=1
	...e  d
	....s MDCount=1
	..i MDCount'=0  d	//存在多个月份的折旧
	...;检测该设备是否存在未审核调账记录
	...s EQCARowID=0
	...f  s EQCARowID=$o(^DHCEQChangeAccount(0,"Equip",EQRowID,EQCARowID))  q:(EQCARowID="")||(SQLCODE'=0)  d
	....s EQCAStatus=$p($g(^DHCEQChangeAccount(EQCARowID)),"^",11)
	....q:EQCAStatus>=2
	....s EQNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	....s SQLCODE=-1019_"["_EQNo_"]"
	...q:SQLCODE'=0
	...;增加累计折旧调账记录
	...k CAPLIST
	...s CAPLIST(2)=EQRowID
	...s CAPLIST(3)=0
	...s EQDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",35),"",2)		//EQDepreTotalFee
	...s EQOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",27),"",2)		//EQOriginalFee
	...s EQNetFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQEquip(EQRowID)),"^",28),"",2)				//EQNetFee
	...s CAPLIST(29)=$p($g(^DHCEQEquip(EQRowID)),"^",67)						//EQStoreLocDR
	...s CAPLIST(30)=$p($g(^DHCEQEquip(EQRowID)),"^",19)						//EQUseLocDR
	...s CAPLIST(31)=$p($g(^DHCEQEquip(EQRowID)),"^",63)						//EQEquipTypeDR
	...s CAPLIST(32)=$p($g(^DHCEQEquip(EQRowID)),"^",75)						//EQStatCatDR
	...s CAPLIST(33)=$p($g(^DHCEQEquip(EQRowID)),"^",38)						//EQStatus
	...s CAPLSIT(4)=EQOriginalFee
	...s CAPLIST(5)=EQOriginalFee		//Modify By DJ 2017-12-20 此方法内PLIST名称改为CAPLIST以及净值冲减之后等于原值
	...s CAPLIST(6)=0
	...s CAPLIST(9)="退货自动冲减累计折旧"
	...s CAPLIST(10)=CurDate
	...s CAPLIST(12)=2
	...s CAPLIST(13)=User
	...s CAPLIST(14)=CurDate
	...s CAPLIST(15)=CurTime
	...s CAPLIST(22)=User
	...s CAPLIST(23)=CurDate
	...s CAPLIST(24)=CurTime
	...s CAPLIST(25)=EQOriginalFee
	...s CAPLIST(26)=EQNetFee
	...s CAPLIST(34)=0-EQDepreTotalFee
	...&SQL(Insert Into SQLUSER.DHC_EQChangeAccount values :CAPLIST())
	...q:SQLCODE'=0
	...s CARowID=$G(%ROWID)
	...;增加调账记录对应资金来源信息及修改设备对应资金来源
	...s FRowID=0
	...f  s FRowID=$o(^DHCEQFunds("0","Source",1,EQRowID,FRowID))  q:(FRowID="")||(SQLCODE'=0)  d
	....k FPLIST
	....s FPLIST(3)=$p($g(^DHCEQFunds(FRowID)),"^",2)					//FundsTypeDR
	....s FPLIST(4)=0
	....s FPLIST(7)=0
	....s FPLIST(8)=User
	....s FPLIST(9)=CurDate
	....s FPLIST(10)=CurTime
	....s FPLIST(11)="N"
	....s FFundsFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",3),"",2)				//FundsFee
	....s FFundsDepreTotal=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQFunds(FRowID)),"^",13),"",2)		//FundsDepreTotal
	....s FPLIST(14)=0-FFundsDepreTotal     ; modified by kdf 2018-03-13 需求号：562448
	....s FPLIST(15)="7"
	....s FPLIST(16)=CARowID
	....s FPLIST(19)=FFundsFee
	....s FPLIST(20)=FFundsDepreTotal
	....&SQL(Insert Into SQLUSER.DHC_EQFunds values :FPLIST())
	....q:SQLCODE'=0
	....&SQL(Update SQLUSER.DHC_EQFunds Set F_DepreTotal=0 Where F_RowID=:FRowID)
	..e  d
	...i CurMonthDepre'=""  d	//只有当月有折旧
	....&SQL(Update SQLUSER.DHC_EQMonthDepre Set MD_Status=3,MD_UpdateUserDR=:User,MD_UpdateDate=:CurDate,MD_UpdateTime=:CurTime Where MD_EquipDR=:EQRowID And MD_MainFlag='Y' And MD_Status<>3)
	....q:SQLCODE'=0
	....&SQL(Update SQLUSER.DHC_EQFunds Set F_DepreTotal=Null Where F_SourceType=1 and F_SourceID=:EQRowID)
	..q:SQLCODE'=0
	..&SQL(Update SQLUSER.DHC_EQEquip Set EQ_NetFee=EQ_OriginalFee,EQ_DepreTotalFee=0 Where EQ_RowID=:EQRowID)
	..q:SQLCODE'=0
	..&SQL(Update SQLUSER.DHC_EQDepreSet Set DS_DepreTotal=Null,DS_DepreTotalFee=Null,DS_PreDepreMonth=Null Where DS_EquipDR=:EQRowID and DS_MainFlag='Y')

	
	q SQLCODE
}

/// ----------------------------------
/// 创建: add by zy 2010-08-24
/// 修改台账
/// 入参:EquipDR,设备RowID
/// 	 SourceType,0:新增入库1:转移2:退货
/// 	 SourceID,变动的来源ID
/// 	 User,当前用户
/// 返回值:0,更新成功
/// ----------------------------------
ClassMethod SaveEquip(EquipDR, SourceType, SourceID, User)
{
	new StoreLocDR,Status,StockStatus,Date,EquipName
	i (EquipDR="")||(SourceType="")||(SourceID="") q ""
	s (StoreLocDR,Status,StockStatus,Date,EquipName)=""
	k EQPL
	s Date=+$H
	s EquipName=$P(^DHCEQEquip(EquipDR),"^",1)
	if SourceType=0 		//0:新增入库
	{
		
	}
	elseif SourceType=1 	//1:转移
	{
		
	}
	elseif SourceType=2  	//2:退货
	{
		s StoreLocDR=$P(^DHCEQReturn(SourceID),"^",2)		//库房
		s Status="2"									//封存
		s StockStatus="3"								//出库
		s EQPL(20)=""									//使用科室
		s EQPL(23)=$P(^DHCEQReturn(SourceID),"^",18)		//设备去向
		s EQPL(73)=""									//存放地点
	}
	s EQPL(39)=Status								//Status
	s EQPL(61)=StockStatus							//StockStatus
	s EQPL(68)=StoreLocDR							//库房
	&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EquipDR)
 	i SQLCODE'=0 q SQLCODE=EquipName_"更新台账表信息失败!"
 	q SQLCODE
}

/// ----------------------------------
/// 创建: add by zy 2010-08-24
/// 记录设备库房变动信息
/// 入参:EquipDR,设备RowID
/// 	 SourceType,0:新增入库1:转移2:退货3:调拨出库4:转让出库
/// 	 SourceID,变动的来源ID
/// 	 User,当前用户
/// 返回值:0,更新成功
/// ----------------------------------
ClassMethod SaveChangeStock(EquipDR, SourceType, SourceID, User)
{
	new FromLoc,ToLoc,Date,EquipName,ReturnType
	i (EquipDR="")||(SourceType="")||(SourceID="") q ""
	s (FromLoc,ToLoc,Date,EquipName)=""
	s ReturnType="1" //add by zx 2019-0-10 默认退货
	k CSPL
	s Date=+$H
	s EquipName=$P(^DHCEQEquip(EquipDR),"^",1)
	if SourceType=0 		//0:新增入库
	{
		s ToLoc=$P(^DHCEQInStock($p($g(^DHCEQInStockList(SourceID)),"^",1)),"^",2)
	}
	elseif SourceType=1 	//1:转移
	{
		s FromLoc=$P(^DHCEQStoreMove($p($g(^DHCEQStoreMoveList(SourceID)),"^",1)),"^",2)
		s ToLoc = $P(^DHCEQStoreMove($p($g(^DHCEQStoreMoveList(SourceID)),"^",1)),"^",3)
	}
	elseif SourceType=2  	//2:退货
	{
		s FromLoc=$P(^DHCEQReturn($p($g(^DHCEQReturnList(SourceID)),"^",1)),"^",2)
		s ReturnType=$P(^DHCEQReturn($p($g(^DHCEQReturnList(SourceID)),"^",1)),"^",17)
	}
	else
	{
		q ""
	}
	i ReturnType'="1" s SourceType="3"  //add by zx 2019-01-10 不为退货时库房变动类型为'3'
	s CSPL(2)=EquipDR								//equipdr
	s CSPL(3)=FromLoc								//FromLoc
	s CSPL(4)=ToLoc								 	//ToLocDR
	s CSPL(5)=SourceID								//SourceID
	s CSPL(6)=SourceType							//ChangeType
	s CSPL(7)=Date									//ChangeDate
	s CSPL(8)=User									//AuditUserDR
	s CSPL(9)=Date									//AuditDate
	s CSPL(10)=Date								  	//BillAuditDate
	&SQL(Insert into sqluser.DHC_EQChangeStock values :CSPL())
	s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
 	i SQLCODE'=0 s SQLCODE=EquipName_":更新库房变动表信息失败!"
 	q SQLCODE
}

/*****************************************************************/
/// Add By DJ 2015-01-21 DJ0137
/// 描述:检测退货明细记录中设备是否存在折旧
/// 返回值:空表示无折旧,  -1表示存在当月折旧,  -2表示存在多个月份的折旧
ClassMethod CheckReturnDepre(vRRowID As %String = "")
{
	i vRRowID="" q ""
	s CurMonthDepre=""
	s CurMonth=$E($ZD(+$H,3),1,7)
	s Find=0
	s RLRowID=0
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",vRRowID,RLRowID))  q:(RLRowID="")||(Find'=0)  d
	.s EQRowIDs=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
	.s EQCount=$L(EQRowIDs,",")
	.f i=1:1:EQCount  d
	..q:Find'=0
	..s EQRowID=$p(EQRowIDs,",",i)
	..s MDRowID=""
	..f  s MDRowID=$o(^DHCEQMonthDepre(0,"Equip",EQRowID,MDRowID),-1)  q:(MDRowID="")||(Find'=0)  d
	...s MDStatus=$p($g(^DHCEQMonthDepre(MDRowID)),"^",20)
	...q:MDStatus="3"
	...s MDMainFlag=$p($g(^DHCEQMonthDepre(MDRowID)),"^",3)
	...q:MDMainFlag'="Y"
	...s MDDepreMonth=$p($g(^DHCEQMonthDepre(MDRowID)),"^",6)
	...i (MDDepreMonth'=CurMonth)  d
	....s Find=EQRowID
	...e  d
	....i CurMonthDepre="" s CurMonthDepre=EQRowID
	
	i Find'=0  q "-2"
	i CurMonthDepre'="" q "-1"
	
	q ""
}

/// Add By DJ DJ0137
/// 描述:获取某种业务当前单据是否最后一步操作
ClassMethod GetLastStepFlag(vApproveTypeCode, vRRowID, vCurStep, vCurRoleDR)
{
	i vRRowID="" q ""
	i vApproveTypeCode="" q ""
	s (EquipTypeDR,ApproveCondition)=""
	i vApproveTypeCode="15"
	{
		s OutTypeDR =$p($g(^DHCEQReturn(vRRowID)),"^",17)
		s EquipTypeDR=$p($g(^DHCEQReturn(vRRowID)),"^",15)
		s ApproveCondition="OutTypeDR,DHCEQReturn,"_OutTypeDR
	}
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType(vApproveTypeCode)
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR,"","","","",ApproveCondition)
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, vRRowID, 0, "")	//提交
	i ((vCurRoleDR'="")&&(vCurStep'=""))
	{
		s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, vRRowID, vCurStep, vCurRoleDR)	//审核
	}
	
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	i ((AutoAuditFlag="Y")&&(NextStep="")) q "Y"
	q "N"
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:判断批量转移的设备数量与选择的RowIDs是否一致
/// w ##Class(web.DHCEQReturnNew).JudgeRLQuantityNum("258","","1^371^^364^担架车^^90^5^^1601^")
/// ----------------------------------
ClassMethod JudgeRLQuantityNum(RRowID, Job, DataList)
{
	new (RRowID, Job, DataList)
	
	i RRowID="" q -1
	i DataList="" q 0
	s Flag=0
	s ReturnLocDR=$p($g(^DHCEQReturn(RRowID)),"^",2)		;ReturnLocDR
	s UseLocDR=$p($g(^DHCEQReturn(RRowID)),"^",24) ;UseLocDR
	i UseLocDR'="" s ReturnLocDR=UseLocDR
	//modified by ZY0240 
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$l(DataList,SplitRowCode)
	
	for DataListLength=1:1:Length
	{
		q:Flag'=0
		s valList=	$p(DataList,SplitRowCode,DataListLength)
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s index= DataListLength  		;index
		;i $p(valList,"^",3)="" continue //单台设备不处理
		s RLRowID= JsonData.RLRowID  		;SMLRowID
		s InStockListDR=JsonData.RLInStockListDR		
		
		;Modified by JDL 2011-08-15 JDL0091 单台时,也应记录EquipDR
		i JsonData.RLEquipDR'=""
		{
			if RLRowID=""  //新增明细
			{
				s ^TEMPEQ("MXList","EX",Job,index)=JsonData.RLEquipDR
			}
			else
			{
				s ^DHCEQReturnList(RLRowID,"EX","RowIDs")=JsonData.RLEquipDR
				k ^TEMPEQ("MXList",Job,RLRowID)
			}
			continue //单台设备不处理
		}
		
		s ReturnQtyNum=JsonData.RLReturnQtyNum 	;ReturnQtyNum
 		s RowIDs=""
		s Len=0
 		if RLRowID=""  //新增明细
 		{
 			s RowIDs=$g(^TEMPEQ("MXList","EX",Job,index))
 		}
 		else
 		{
	 		s RowIDs=$g(^TEMPEQ("MXList",Job,RLRowID))
	 		;Modified by JDL 2011-08-15 JDL0091 当InStockListDR相同时,才取原来的rowids
 			i ((RowIDs="")&&(InStockListDR=$p(^DHCEQReturnList(RLRowID),"^",3))) s RowIDs=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
	 	}
	 	if RowIDs'="" s Len=$l(RowIDs,",")
	 	if (Len'=ReturnQtyNum)
	 	{
			s Flag=##Class(web.DHCEQUpdateEquipsByList).GetRowIDsByQuantityNum(InStockListDR,ReturnQtyNum,RLRowID,ReturnLocDR,Job,index,"2")
		}
		else
		{
			if (RLRowID'="")&&($Data(^TEMPEQ("MXList",Job,RLRowID)))
			{
				s ^DHCEQReturnList(RLRowID,"EX","RowIDs")=$g(^TEMPEQ("MXList",Job,RLRowID))
				k ^TEMPEQ("MXList",Job,RLRowID)
			}
		}
	}
	q Flag
}

/// ----------------------------------
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述:写入转移单明细
/// w ##Class(web.DHCEQReturnNew).SaveReturnList("","1^84^^...&1^85^...")
/// ----------------------------------
ClassMethod SaveReturnList(RRowID, Job, DataList)
{
	new (RRowID, Job, DataList)
	i DataList="" q 0
	i RRowID="" q -1
	s Flag=0
	s RLRowIDs=""
	//modified by ZY0240 
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$l(DataList,SplitRowCode)
	
	for DataListLength=1:1:Length
	{
		s index=DataListLength
		q:Flag'=0
		s valList=	$p(DataList,SplitRowCode,DataListLength)
		k PLIST,RLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQReturnList",JsonData,.PLIST)
		s RLRowID = JsonData.RLRowID
		s PLIST(2)=RRowID  
		if (RLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQReturnList Values :PLIST())
			i SQLCODE 
			{
				s Flag=index_"^新增明细记录失败!"
			}
			else
			{
				s RLRowID=$G(%ROWID)
	 			if (JsonData.RLEquipDR="")  //批量记录 //2011-05-27 DJ
	 			{
		 			s ^DHCEQReturnList(RLRowID,"EX","RowIDs")=$g(^TEMPEQ("MXList","EX",Job,index))
		 		}
		 		else
		 		{
			 		s ^DHCEQReturnList(RLRowID,"EX","RowIDs")=JsonData.RLEquipDR
		 		}
		 		k ^TEMPEQ("MXList","EX",Job,index)
			}
		}
		else
		{
			&SQL(update sqluser.DHC_EQReturnList values :PLIST() where RL_RowID=:RLRowID)
			i SQLCODE s Flag=index_"^更新明细记录失败!"
		}
		
		if RLRowIDs=""
		{
			s RLRowIDs=RLRowID
		}
		else
		{
			s RLRowIDs=RLRowIDs_","_RLRowID
		}
		//add by wy 2020-10-12 退货记录发票 1561593
	   	s SQLCODE=##Class(web.DHCEQ.EM.BUSReturn).UpdateInvoiceInfo(RLRowID, JsonData.InvoiceNos, JsonData.InvoiceDate, JsonData.InvoiceFee)	
		i SQLCODE s Flag=index_"^插入退货发票失败!"
		//检测原值变化 2011-08-10 DJ begin
		s ListEQ=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
		s ListCount=$L(ListEQ,",")
		for j=1:1:ListCount
		{
			q:Flag'=0
			s EQID=$p(ListEQ,",",j)
			s EQOriginalFee=$p($g(^DHCEQEquip(EQID)),"^",27)
			i +EQOriginalFee'=+JsonData.RLReturnFee		//Modify DJ 2015-09-10 DJ0163
			{
				s Flag=index_"^设备原值已发生变动,不可批量处理!"
			}
		}
        ///modified by ZY 20220926 2757106
        q:Flag'=0
        s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEQ,"23",RRowID,0)
        i SQLCODE s Flag=index_"^记录业务占用信息失败!"
        q:Flag'=0
		// Mozy0217  2018-11-01		更新退货明细的配置DR(临时增加)
		s EQID=$p(ListEQ,",",1)
		s tmpRLHold2=$Piece($Get(^DHCEQEquip(EQID,"OtherInfo")),"^",26)
		i tmpRLHold2'="" &SQL(update sqluser.DHC_EQReturnList set RL_Hold2=:tmpRLHold2 where RL_RowID=:RLRowID)
	}
	s RLRowID=0
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID))  quit:(RLRowID="")||(SQLCODE'=0)  d
    .i (","_RLRowIDs_",")'[(","_RLRowID_",")  d
    ..&SQL(delete from SQLUSER.DHC_EQReturnList where RL_RowID = :RLRowID)
    ..q:SQLCODE'=0
    ..s ListEQ=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
    ..s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEQ,"23",RRowID,1)
    i SQLCODE s Flag=index_"^删除未传入的退货单明细记录失败!"
	
	q Flag
}

/// ----------------------------------
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述:删除转移明细
/// w ##Class(web.DHCEQReturnNew).DeleteReturnList(" ,0,0,0")
/// ----------------------------------
ClassMethod DeleteReturnList(DelRowid)
{
	new Length,RLRowID,Flag
	i DelRowid="" q 0
	s Flag=0
	s Length=$l(DelRowid,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s RLRowID=$p(DelRowid,",",i)
		if (RLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQReturnList where RL_RowID=:RLRowID)
			i SQLCODE s Flag=RLRowID_"^更新操作失败"
            ///modified by ZY 20220926 2757106
            s RRowID=$p($g(^DHCEQReturnList(RLRowID)),"^",1) 
            s ListEquip=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
            s SQLCODE=##Class(web.DHCEQ.EM.BUSEquip).TieUpEquipByBuss(ListEquip,"23",RRowID,1)
            i SQLCODE s Flag=RLRowID_"^记录业务占用信息失败!"
 			k ^DHCEQReturnList(RLRowID,"EX","RowIDs")
		}
	}
	q Flag
}

Query GetReturnReason(RRDesc) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
SELECT RR_Desc,
	   RR_RowID,
	   RR_Code
FROM sqluser.DHC_EQCReturnReason
where RR_InvalidFlag = 'N' and RR_Desc like nvl(:RRDesc,'')||'%'
}

Query GetOutType(OTDesc) As %SQLQuery(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
SELECT OT_Desc,
	   OT_RowID,
	   OT_Code
FROM sqluser.DHC_EQCOutType
where OT_InvalidFlag = 'N' And OT_Code<>'BF' And OT_Code<>'TH' and OT_Desc like nvl(:para,'')||'%'
}

/// ----------------------------------
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述:反提交
/// w ##Class(web.DHCEQReturnNew).CancelSubmitData("50^1276^1493^24/08/2010^备注^1^^1^^^^^1^124^31")
/// ----------------------------------
ClassMethod CancelSubmitData(val, CurRole)
{
	new (val,CurRole, %session)  //add by zx 2016-02-25 Bug ZX0034 消息取不到session
	Set $ZT="ERRORCancel"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	s User=$P(val,"^",13)
	s CancelToFlowDR=$P(val,"^",14)
	s Date=+$H
	//获取取消到上一步的信息,没有设置取消到第几步,就取消到更新状态
	s Status="0"
	s ApproveRoleDR=""
	s Step=""
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}
	
	s PLIST(6) = User //$p(val,"^",5)	;MakerDR
 	s PLIST(7) = Date
 	s PLIST(14) =Status
	TSTART
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("15")
	
	//2015-10-08 ZY0146   取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("15", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;Modified by jdl 2011-3-9  jdl0073
	s ApproveFlow=""
	i CancelToFlowDR'=""
	{
		s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("23", RowID, User, ApproveFlow, "Y",CurRole)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
 	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORCancel 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)     //返回错误消息 ;
}

/// ----------------------------------
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述:管理审核
/// w ##Class(web.DHCEQ.EM.BUSReturn).AuditData("4^327^^2020-04-27^^4^^7^^^^^10248^172^29^4032^","18","2","","0","1")
/// modified by czf 1247213 增加折旧恢复标志ResumeDepreFlag
ClassMethod AuditData(val, CurRole, RoleStep, EditFieldsInfo, AutoCancelDepre As %String = "0", ResumeDepreFlag As %String = "0")
{
	new RowID,Date,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,Actions
	k PLIST
	s (RowID,Date,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,Actions)=""
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	s Date=+$H
	s User=$P(val,"^",13)
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("15")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("15", RowID)
	i ApproveSet="" q -4007	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"		;Status	
	
	s AuditFlag=0		//判断是否是最后一步,0:否;1:是
	i ((NextStep="")||(LastFlag="Y"))
	{
		s AuditFlag=1
		s AppInfoStatus="2"
	}
	TSTART	
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep)
	if SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	//编辑要修改的字段
	if EditFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(EditFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	//做定义要做的操作
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,EditFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	//后一步审核的操作
	;s ^DHCEQTemp("jdl","100827")="AuditFlag:"_AuditFlag
	;b "AuditFlag"
	i AuditFlag=1
	{
		s AppInfo(9)="2"		;Status	
		//s SQLCODE=##Class(web.DHCEQReturnNew).LastAuditAction(RowID, User, Date, AutoCancelDepre)	//DJ0137
		s SQLCODE=##Class(web.DHCEQ.EM.BUSReturn).LastAuditAction(RowID, User, Date, AutoCancelDepre,ResumeDepreFlag) //add by zx 调用位置错误 //modified by czf 1247213
		if SQLCODE'=0 //2011-05-27 DJ
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	}
	;记录单据当前审批状态
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_SourceID=:RowID and  AI_ApproveTypeDR=:ApproveType)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	;b "TCOMMIT"
	;Modified by jdl 2011-3-9  jdl0073
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("23", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	TCOMMIT
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)

ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)     //返回错误消息 ;
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSReturn","ReturnListNew","6")
Query ReturnListNew(RowID As %String = "") As %Query(ROWSPEC = "RLUnit:%String,RLTotalFee:%String,RLReturnNum:%String,RLStock:%String,RLRowID:%String,RLReturnDR:%String,RLBatchFlag:%String,RLEquip:%String,RLModel:%String,RLManuFactory:%String,RLReturnQtyNum:%String,RLReturnFee:%String,RLInvoiceNo:%String,RLReturnReason:%String,RLRemark:%String,RLRow:%String,RLInStockListDR:%String,RLReturnReasonDR:%String,RLJob:%String,RLDealFee:%String,RLHold1:%String,RLHold2:%String,RLHold3:%String,RLFlag:%String,RLEquipDR:%String,RLUnitDR:%String,InvoiceNos:%String,InvoiceDate:%String,InvoiceFee:%String")
{
}

ClassMethod ReturnListNewExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new (qHandle,RowID)
	//new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Job=$J
	s (TRow,TotalQty,Amount)=0
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	if RowID'=""  d
	.s RLRowID=$o(^DHCEQReturnList(0,"Return",RowID,0))
	.s StoreLoc=$p($g(^DHCEQReturn(RowID)),"^",2) //退货科室
	.s EquipType=$p($g(^DHCEQReturn(RowID)),"^",15) //类组
	.s StatCat=$p($g(^DHCEQReturn(RowID)),"^",16) //统计分类
	.s UseLocDR=$p($g(^DHCEQReturn(RowID)),"^",24) //add by wy 2020-9-26 1523426
	.s rowid=0
	.f  s rowid=$o(^DHCEQReturnList(0,"Return",RowID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetReturnListNew
	..s TRow=TRow+1
	..s TRowID = rowid							//rowid
	..s TReturnDR=$p($g(^DHCEQReturnList(rowid)),"^",1) //退货单
	..s StatCat=$p($g(^DHCEQReturn(RowID)),"^",16) //统计分类
	..//modified by ZY0230 20200513	//界面元素叫"单台",直接输出与界面意思相反
	..s TBatchFlag=$p($g(^DHCEQReturnList(rowid)),"^",2) //批标志
	..i TBatchFlag="Y" d
	...s TBatchFlag="N"
	..e  d
	...s TBatchFlag="Y"
	..s TInStockListDR=$p($g(^DHCEQReturnList(rowid)),"^",3) //入库单号
	..s TEquipDR=$p($g(^DHCEQReturnList(rowid)),"^",4) 
	..i TEquipDR'="" s TFlag="1"
	..i (TEquipDR'="") d		//modified by czf 1232276
	...s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1) //设备名称
	...s TStock=$p($g(^DHCEQEquip(TEquipDR)),"^",67) //库房
	...s TStock=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStock)
	...s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3) //机型
	...s TUnitDR = $p($g(^DHCEQEquip(TEquipDR)),"^",5) //单位 
	...i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	...s TManuFactoryDR = $p($g(^DHCEQEquip(TEquipDR)),"^",26) //生产厂商
	...i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	...s TReturnNum=1	//add by csj 20190828 单台设备可减少数量为1 需求号：997646
	..i (TInStockListDR'="") d		//modified by czf 1232276
	...s TSourceType = $p($g(^DHCEQInStockList(TInStockListDR)),"^",18)  ;SourceType
	...s TSourceID = $p($g(^DHCEQInStockList(TInStockListDR)),"^",19)  	;SourceID
	...;Mozy0242	1155353		2020-01-02	修改类组取值
	...;i (TSourceType=1) s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",3)
	...;i (TSourceType=2) s EquipTypeDR=$p($g(^DHCEQOpenCheckList(TSourceID)),"^",3)
	...s islitemdr=$p($g(^DHCEQInStockList(TInStockListDR)),"^",16)
	...s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",islitemdr)),"^",3)
	...;Add By DJ 2017-10-24
	...i TSourceType=""  d
	....s TInStockRowID=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	....s TEquipTypeDR=$p($g(^DHCEQInStock(TInStockRowID)),"^",20)
	...s TReturnNum=##class(web.DHCEQStoreMoveNew).GetTotalMoveQuantity(StoreLoc,TInStockListDR,EquipTypeDR,StatCat)
	...;add by wy 2020-9-26 1523426 科室减少时设备科室为使用科室
	...i UseLocDR'="" s TReturnNum=##class(web.DHCEQStoreMoveNew).GetTotalMoveQuantity(UseLocDR,TInStockListDR,EquipTypeDR,StatCat)
	...s MovedQuantity=##class(web.DHCEQStoreMoveNew).GetTotalOccupyQuantity(StoreLoc,TInStockListDR,EquipTypeDR,StatCat,"2",rowid)	//modified by csj 20190829 获取单据占用数量,旧方法未排除报废单据占用数量 需求号：997732
	...s TReturnNum=TReturnNum-MovedQuantity
	...s TEquip=$p($g(^DHCEQInStockList(TInStockListDR)),"^",5) //设备名称
	...s TModelDR =$p($g(^DHCEQInStockList(TInStockListDR)),"^",9) //机型
	...i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	...s TUnitDR= $p($g(^DHCEQInStockList(TInStockListDR)),"^",10)	//单位 
	...s TManuFactoryDR =$p($g(^DHCEQInStockList(TInStockListDR)),"^",6) //生产厂商
	...i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR) //$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	..s TReturnQtyNum=$p($g(^DHCEQReturnList(rowid)),"^",5) //退货数量
	..s TReturnFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQReturnList(rowid)),"^",6),"") //退货金额
	..s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TReturnQtyNum*TReturnFee,"")
	..
	..s TotalQty=TotalQty+TReturnQtyNum
	..s Amount=Amount+TTotalFee
	..
	..s TInvoiceNo=$p($g(^DHCEQReturnList(rowid)),"^",7) //发票号
	..s TReturnReasonDR=$p($g(^DHCEQReturnList(rowid)),"^",8) //退货原因
	..i TReturnReasonDR'="" s TReturnReason=$p($g(^DHCEQCCode("DHCEQCReturnReason",TReturnReasonDR)),"^",2) //结果
	..s TRemark=$p($g(^DHCEQReturnList(rowid)),"^",9) //备注
	..s TDealFee=$p($g(^DHCEQReturnList(rowid)),"^",10) //处置费用
	..s THold1=$p($g(^DHCEQReturnList(rowid)),"^",11) //Hold1
	..s THold2=$p($g(^DHCEQReturnList(rowid)),"^",12) //Hold2
	..s THold3=$p($g(^DHCEQReturnList(rowid)),"^",13) //Hold3
	..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR) //
	..s TJob=Job
	..;add by wy 2020-10-12 退货增加发票 1561593 
	..s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(2,rowid)
	..s InvoiceNos=$p(return,"^",1)
	..s InvoiceDate=$p(return,"^",2)
	..s InvoiceFee=$p(return,"^",3)

	..d OutputRowGetReturnListNew
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetReturnListNew
	.s TRow=1
	.s TJob=Job
	.d OutputRowGetReturnListNew
	;处理合计行
	i TotalFlag>0  d
	.d ResetVariablesGetReturnListNew
	.s TRowID=-1
	.s TRow="合计"
	.s TReturnQtyNum=TotalQty
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(Amount,"")
	.i TotalFlag="1"  d
	..s index=1
	.e  d
	..s index=index+1
	.s TJob=Job
	.;d OutputRowGetReturnListNew
	Quit $$$OK
	
OutputRowGetReturnListNew
   s Data=$lb(TUnit,TTotalFee,TReturnNum,TStock,TRowID,TReturnDR,TBatchFlag,TEquip,TModel,TManuFactory,TReturnQtyNum,TReturnFee,TInvoiceNo,TReturnReason,TRemark,TRow,TInStockListDR,TReturnReasonDR,TJob,TDealFee,THold1,THold2,THold3,TFlag,TEquipDR,TUnitDR,InvoiceNos,InvoiceDate,InvoiceFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetReturnListNew
	s (TUnit,TTotalFee,TReturnNum,TStock,TRowID,TReturnDR,TBatchFlag,TEquip,TModel,TManuFactory,TReturnQtyNum,TReturnFee,TInvoiceNo,TReturnReason,TRemark,TInStockListDR,TReturnReasonDR,TJob,TDealFee,THold1,THold2,THold3,TFlag,TEquipDR,TUnitDR,InvoiceNos,InvoiceDate,InvoiceFee)=""
	quit
}

ClassMethod ReturnListNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReturnListNewExecute ]
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

ClassMethod ReturnListNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReturnListNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// add by czf 1247213 2020-04-27
/// 退货恢复设备月折旧、快照、月报、台帐相关折旧信息
ClassMethod ResumeDepre(vRRowID As %String = "")
{
	i vRRowID = "" q 0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s SQLCODE=0
	s RLRowID=0
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",vRRowID,RLRowID))  q:(RLRowID="")||(SQLCODE'=0)  d
	.s EQRowIDs=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
	.s EQCount=$L(EQRowIDs,",")
	.f i=1:1:EQCount  d
	..q:SQLCODE'=0
	..s EQRowID=$p(EQRowIDs,",",i)
	..s vVal=EQRowID_"^1^^"_"退货折旧恢复^"_User
	..s SQLCODE=##Class(web.DHCEQMonthDepre).ExecuteAdjustDataNew(vVal,1)
	..q:SQLCODE'=0
	
	q SQLCODE
}

/// ----------------------------------
/// 创建:add by wy 2020-10-12 1561593
/// 描述:修改发票信息
/// 入参：RLRowID退货明细ID Invoice, InvoiceDate, InvoiceFee, IUMType
/// 访问表:DHC_EQInvoice,DHC_EQInvoiceUseMap
/// w ##Class(web.DHCEQ.EM.BUSReturn).UpdateInvoiceInfo
ClassMethod UpdateInvoiceInfo(RLRowID, Invoice, InvoiceDate, InvoiceFee, IUMType As %String = "")
{
	s (OldInvoiceID,OldInvoiceNo,OldInvoiceDate,OldInvoiceFee)=""
	s IUMType=2
	s RRowID=$P(^DHCEQReturnList(RLRowID),"^",1)
	s ProviderID=$P(^DHCEQReturn(RRowID),"^",3)
	s RStatus=$P(^DHCEQReturn(RRowID),"^",13)
	
	s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",IUMType,RLRowID,0))
	s InvoiceDate=##class(web.DHCEQCommon).TransValueFromPage(InvoiceDate,"date")
	k INPLIST
	s INPLIST(3)=Invoice
	s INPLIST(4)=InvoiceDate
	s INPLIST(5)=InvoiceFee
	s INPLIST(11)="1" 
	s INPLIST(6)=ProviderID
	s INPLIST(17)="N"
	
	;获取原来的发票信息
	i IUMRowID'=""
	{		
		s OldInvoiceID=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
		s OldInvoiceNo=$p(^DHCEQInvoice(OldInvoiceID),"^",2)
		s OldInvoiceDate=$p(^DHCEQInvoice(OldInvoiceID),"^",3)
		s OldInvoiceFee=$p(^DHCEQInvoice(OldInvoiceID),"^",4)
	}
	;获取新的发票ID
	s InvoiceID=""
	i Invoice'=""
	{
		s vRowID=0
		f  s vRowID=$o(^DHCEQInvoice(0,"InvoiceNo",Invoice,vRowID)) q:((vRowID="")||(InvoiceID'=""))  d
		.q:$p(^DHCEQInvoice(vRowID),"^",16)'="N"
		.i ProviderID=$p(^DHCEQInvoice(vRowID),"^",5) s InvoiceID=vRowID	
	}
	
	i InvoiceID'=""
	{
		s Times=##class(web.DHCEQInvoice).InvoiceUsedTimes(IUMType,RLRowID,InvoiceID)
		i Times>0
		{
			///modified by ZY0238 去掉日期和费用的判断。
			;该发票与原有信息不符!
			//i InvoiceDate'=$p(^DHCEQInvoice(InvoiceID),"^",3) q -1008
			//i InvoiceFee'=$p(^DHCEQInvoice(InvoiceID),"^",4) q -1008				
		}
		;发票已经提交
		i $p(^DHCEQInvoice(InvoiceID),"^",10)="2" q -1009
		&SQL(update sqluser.DHC_EQInvoice values INPLIST() where IV_RowID=:InvoiceID)
	}
	else
	{
		i Invoice'=""
		{
			&SQL(insert into sqluser.DHC_EQInvoice values INPLIST())
			if SQLCODE q SQLCODE
			s InvoiceID=$G(%ROWID)
			;q "InvoiceID"_InvoiceID
		}
	}	
	
	;处理原来发票		
	i (OldInvoiceID'="")&&(OldInvoiceID'=InvoiceID)
	{
		;删除对照
		&SQL(delete from sqluser.DHC_EQInvoiceUseMap where IUM_RowID=:IUMRowID)
		if SQLCODE<0 q SQLCODE
		s Times=##class(web.DHCEQInvoice).InvoiceUsedTimes(IUMType,RLRowID,OldInvoiceID)
		;没有其他单据使用则删除发票
		i Times=0
		{
			&SQL(delete from sqluser.DHC_EQInvoice where IV_RowID=:OldInvoiceID)
		}
		if SQLCODE<0 q SQLCODE			
	}
	;增加新发票对照
	i ((InvoiceID'="")&&(OldInvoiceID'=InvoiceID))
	{
		k INMPLIST
		s INMPLIST(2)=RLRowID
		s INMPLIST(3)=InvoiceID
		s INMPLIST(4)=IUMType
		&SQL(insert into sqluser.DHC_EQInvoiceUseMap values INMPLIST())
		if SQLCODE
		{
			q SQLCODE
		}
	}	
	q 0
}

/// 创建:add by zc0126 2022-12-26 2162208
/// 描述:作废退货与减少单信息
/// 入参：RowID 退货与减少单ID 
/// w ##Class(web.DHCEQ.EM.BUSReturn).ResumeReturn(16)
ClassMethod ResumeReturn(RowID)
{
	s RAuditDate=$p($g(^DHCEQReturn(RowID)),"^",11)
	s YearMonth=##Class(web.DHCEQReport).GetReportMonthByDate(RAuditDate)
	s CurYearMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H) 
	s MonthNum=##Class(web.DHCEQCommon).DateDiff("m",$ZD($ZDH(YearMonth_"-01",3),1),$ZD($ZDH(CurYearMonth_"-01",3),1))
	i (MonthNum>1)||(MonthNum=1) q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1001","此操作只作废当月录入数据!")
	k PLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set $ZT="ERRORResumeReturn"
	//修改申请单的状态
	s PLIST(26)=User	;RCancelUser
	s PLIST(27)=+$h		;RCancelDate
	s PLIST(28)=$p($h,",",2)		;RCancelTime
	s PLIST(29)="Y"		;RInvalidFlag
	s PLIST(14)="3"			;Status
	TSTART
	//作废业务单据
	&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
	if SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
		
	s SQLCODE=0
	s RLRowID=0
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RowID,RLRowID))  quit:(RLRowID="")||(SQLCODE'=0)  d
	.s BatchFlag=$P(^DHCEQReturnList(RLRowID),"^",2)
	.s InStockListDR=$P(^DHCEQReturnList(RLRowID),"^",3)
	.i (BatchFlag="Y")&(InStockListDR'="")  d   //批量设备
	..s equipRowIDs=$G(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
	.e  d
	..s equipRowIDs=$P(^DHCEQReturnList(RLRowID),"^",4)
	.s count=$l(equipRowIDs,",")
	.f i=1:1:count d
	..q:SQLCODE'=0
	..s EquipDR=$p(equipRowIDs,",",i)
	..i EquipDR'=""  d
	...;恢复设备信息
	...s SQLCODE=##Class(web.DHCEQ.EM.BUSReturn).ResumeOtherInfo(EquipDR,RLRowID,RowID)
	...q:SQLCODE'=0
	...s SQLCODE=##Class(web.DHCEQ.EM.BUSReturn).ResumeChangeAccount(EquipDR,RowID)
	...q:SQLCODE'=0
	.;删除业务生成的资金来源信息
	.s SQLCODE=##class(web.DHCEQ.EM.BUSReturn).DeleteFundsInfo(5, RLRowID)
	.q:SQLCODE'=0
	if SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORResumeReturn
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// 创建:add by zc0126 2022-12-26 2162208
/// 描述:恢复其他信息(删除生命周期，恢复台账，恢复库房变动表)
/// 入参：EquipDR 设备ID  RLRowID 退货与减少明细ID RRowID 退货与减少单ID
/// w ##Class(web.DHCEQ.EM.BUSReturn).ResumeOtherInfo(1,23,,16)
ClassMethod ResumeOtherInfo(EquipDR, RLRowID, RRowID)
{
	i (EquipDR="")||(RLRowID="")||(RRowID="") q 0
	//删除退货生命周期信息
	&SQL(delete from SQLUSER.DHC_EQLifeInfo where LI_SourceType="23" and LI_SourceID=:RLRowID and LI_EquipDR=:EquipDR)
	i SQLCODE'=0 q SQLCODE=$p($g(^DHCEQEquip(EquipDR)),"^",1)_"更新生命周期表信息失败!"
	//修改台账
 	s SQLCODE=##Class(web.DHCEQ.EM.BUSReturn).ResumeEquipInfo(EquipDR,"2",RRowID)
	i SQLCODE'=0 q SQLCODE
 	
 	//修改库房变动表
 	s SQLCODE=##Class(web.DHCEQ.EM.BUSReturn).DeleteChangeStock(EquipDR,"2",RLRowID)
 	q SQLCODE
}

/// 创建:add by zc0126 2022-12-26 2162208
/// 描述:恢复台账
/// 入参：EquipDR 设备ID SourceType 来源类型 SourceID 来源ID
/// w ##Class(web.DHCEQ.EM.BUSReturn).ResumeEquipInfo(1,2,12)
ClassMethod ResumeEquipInfo(EquipDR, SourceType, SourceID)
{
	new StoreLocDR,Status,StockStatus,UseLocDR
	i (EquipDR="")||(SourceType="")||(SourceID="") q ""
	s (StoreLocDR,Status,StockStatus,UseLocDR)=""
	k EQPL
	s StoreLocDR=$p($g(^DHCEQReturn(SourceID)),"^",2)
	s UseLocDR=$p($g(^DHCEQReturn(SourceID)),"^",25)
	i UseLocDR'="" d
	.s StoreLocDR=UseLocDR
	.s Status=1
	e  d
	.s Status=0
	s StockStatus=1
	s EQPL(20)=UseLocDR	
	s EQPL(39)=Status								//Status
	s EQPL(61)=StockStatus							//StockStatus
	s EQPL(68)=StoreLocDR							//库房
	&SQL(update sqluser.DHC_EQEquip values :EQPL() where EQ_RowID=:EquipDR)
 	i SQLCODE'=0 q SQLCODE="-9040"
 	q SQLCODE
}

/// 创建:add by zc0126 2022-12-26 2162208
/// 描述:删除库房变动表记录
/// 入参：EquipDR 设备ID SourceType 来源类型 SourceID 来源ID
/// w ##Class(web.DHCEQ.EM.BUSReturn).DeleteChangeStock(1,2,12)
ClassMethod DeleteChangeStock(EquipDR, SourceType, SourceID)
{
	i (EquipDR="")||(SourceType="")||(SourceID="") q 0
	&SQL(delete from SQLUSER.DHC_EQChangeStock where CS_ChangeType=:SourceType and CS_SourceID=:SourceID and CS_EquipDR=:EquipDR)
 	i SQLCODE'=0 s SQLCODE=$p($g(^DHCEQEquip(EquipDR)),"^",1)_"更新库房变动表信息失败!"
 	q SQLCODE
}

/// 创建:add by zc0126 2022-12-26 2162208
/// 描述:删除资金来源信息记录
/// 入参：SourceType 来源类型 SourceID 来源ID
/// w ##Class(web.DHCEQ.EM.BUSReturn).DeleteFundsInfo(2,12)
ClassMethod DeleteFundsInfo(SourceType, SourceID)
{
	i (SourceType="")||(SourceID="") q 0
	&SQL(delete from SQLUSER.DHC_EQFunds where F_SourceType=:SourceType and F_SourceID=:SourceID)
 	i SQLCODE'=0 s SQLCODE="删除资金来源信息失败!"
 	q SQLCODE
}

/// 创建:add by zc0126 2022-12-26 2162208
/// 描述:恢复退货折旧冲减
/// 入参：EquipDR 设备ID RRowID
/// w ##Class(web.DHCEQ.EM.BUSReturn).ResumeChangeAccount(2,12)
ClassMethod ResumeChangeAccount(EquipDR, RRowID)
{
	i (EquipDR="")||(RLRowID="")||(RRowID="") q 0
	s RBillAckDate=$p($g(^DHCEQReturn(RRowID)),"^",2)
	s REquipType=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	s EQCARowID=0
	f  s EQCARowID=$o(^DHCEQChangeAccount(0,"TypeDate",REquipType,RBillAckDate,EQCARowID))  q:(EQCARowID="")||(SQLCODE'=0)  d
	.q:$p($g(^DHCEQChangeAccount(EQCARowID)),"^",1)'=EquipDR
	.q:$p($g(^DHCEQChangeAccount(EQCARowID)),"^",8)'="退货自动冲减累计折旧"
	.&SQL(update sqluser.DHC_EQChangeAccount set CA_Status="3" where CA_RowID=:EQCARowID)
	.q:SQLCODE'=0
	q SQLCODE
}

/// add by txr 2023-03-15
/// 台账批量减少
/// 逻辑：按照同一类组生成一张减少单的规则生成新增状态的减少单。单据信息记录在临时golable中
/// 入参：RFromLocDR：减少使用科室库房，默认取EquipIDs第一个设备的科室;
///       EquipIDs：设备ID串'1,2,3,4'
/// 	  OutTypeDR：减少类型,默认调拨
/// 出参：返回RRowIDs. 生成的减少单ID拼串返回。
ClassMethod BatchReturn(RFromLocDR, EquipIDs, OutTypeDR As %String = "3")
{
	new Job,User,Date,Time,ErrorMess,Len,EquipDR,Str,SQLCODE
	new EQStatus,EquipTypeDR,StoreLocDR,EQNo,RRowIDs,SplitRowCode
    Set $ZT="ERRORBatchSave"
	s Job=$j
	k ^DHCEQTemp("BatchReturnEquipIDs",Job)
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025") 
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s ErrorMess=""
	s OutTypeDR="3"
	
	//czf 2021-06-25 begin
	i RFromLocDR="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"库房不能为空!")
	s FromHospDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(RFromLocDR)
	i FromHospDR="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"库房所在院区不能为空!")
	//czf 2021-06-25 end
		
	s Len=$l(EquipIDs,",")
 	f i=1:1:Len 
 	{
	 	q:ErrorMess'=""
	 	s EquipDR=$p(EquipIDs,",",i)
	 	s Str=##Class(web.DHCEQBatchDisuseRequest).CheckEquipDR("","",EquipDR,"","","Y")
	 	i $p(Str,"^",1)=1 s ErrorMess=$p(Str,"^",2)
	 	q:$p(Str,"^",1)=1
	 	s EQStatus=$p($g(^DHCEQEquip(EquipDR)),"^",38)
	 	s EquipTypeDR=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	 	s StoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
	 	s EQNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	 	//s ProviderDR=$p($g(^DHCEQEquip(EquipDR)),"^",25)  批量不同供应商，供应商为空
	 	i RFromLocDR'=StoreLocDR  s ErrorMess="设备编号"_EQNo_"使用科室是"_##Class(web.DHCEQCommon).getMapIDBySource("deptname",StoreLocDR)_",不在转出科室."
	 	q:ErrorMess'=""
	 	i (EQStatus'=0)&&(EQStatus'=1)&&(EQStatus'=2) s ErrorMess="设备编号"_EQNo_"状态不是'启用''停用''在库'"
	 	q:ErrorMess'=""
	 	
	 	s ^DHCEQTemp("BatchReturnEquipIDs",Job,"EquipList",EquipTypeDR,EquipDR)=""
	}
	if ErrorMess'=""
	{
		k ^DHCEQTemp("BatchReturnEquipIDs",Job)
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMess)
	}
    else
	{
		TSTART
		s RRowIDs=""
		k PLIST,PLISTMX
		s SQLCODE=0
		s EquipTypeDR=0
		s OutTypeCode=$p(^DHCEQCCode("DHCEQCOutType",OutTypeDR),"^",1)
		f  s EquipTypeDR=$o(^DHCEQTemp("BatchReturnEquipIDs",Job,"EquipList",EquipTypeDR))  q:(EquipTypeDR="")||(SQLCODE'=0)  d
		.s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQReturn",Date,"",EquipTypeDR,"","",OutTypeCode)
		.s PLIST(3) = RFromLocDR	;ReturnLocDR
		.s PLIST(4) = ""	    ;供应商
		.s PLIST(5) = Date			;减少日期
		.s PLIST(6) = User			;MakerDR
		.s PLIST(7) = Date			;MakeDate
		.s PLIST(14) = "0"			;Status
		.s PLIST(15) = "台账批量减少"	;Remark
		.s PLIST(16) = EquipTypeDR	;EquipTypeDR
		.s PLIST(17) = "" ;StatCatDR
		.s PLIST(18) = OutTypeDR	;OutType
		.s PLIST(29) = "N"
		.&SQL(insert into sqluser.DHC_EQReturn values :PLIST())
		.s RRowID=$G(%ROWID)
		.q:SQLCODE'=0
		.s PLISTMX(2)=RRowID
		.s EquipDR=""
		.f  s EquipDR=$o(^DHCEQTemp("BatchReturnEquipIDs",Job,"EquipList",EquipTypeDR,EquipDR)) q:(EquipDR="")||(SQLCODE'=0)  d
		..s EquipData=$g(^DHCEQEquip(EquipDR))
		..s PLISTMX(3)="N"		;RL_BatchFlag
		..s PLISTMX(4)=""		;RL_InStockListDR
		..s PLISTMX(5)=EquipDR	;RL_EquipDR
		..s PLISTMX(6)=1		;RL_ReturnQtyNum
		..s PLISTMX(7)=$p(EquipData,"^",27)		;RL_ReturnFee
		..s PLISTMX(8)=""	;发票号
		..&SQL(Insert Into SQLUSER.DHC_EQReturnList Values :PLISTMX())
		..s RLRowID=$G(%ROWID)
		..s ^DHCEQReturnList(RLRowID,"EX","RowIDs")=EquipDR
		.i RRowIDs="" d
		..s RRowIDs=RRowID
		.e  d
		..s RRowIDs=RRowIDs_SplitRowCode_RRowID
	 	i SQLCODE
	 	{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 	}
	 	
	 	TCOMMIT
	 	k ^DHCEQTemp("BatchReturnEquipIDs",Job)
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RRowIDs)
    }
ERRORBatchSave
    	TROLLBACK
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// add by txr 2023-03-15
/// 批量减少单明细
/// 入参：减少明细ID串。
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSReturn","GetBatchReturn","")
Query GetBatchReturn(RRowIDs As %String = "") As %Query(ROWSPEC = "RRowID:%String,RReturnNo:%String,REquipType:%String")
{
}

ClassMethod GetBatchReturnExecute(ByRef qHandle As %Binary, RRowIDs As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i RRowIDs="" Quit $$$OK
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025") 
	s Len=$l(RRowIDs,SplitRowCode)
 	f i=1:1:Len d
 	.s RRowID=$p(RRowIDs,SplitRowCode,i)
	.s RReturnNo=$p($g(^DHCEQReturn(RRowID)),"^",1)
	.s REquipType=$p($g(^DHCEQReturn(RRowID)),"^",15)
	.s REquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",REquipType)
	.d OutputRowGetBatchReturn
	
	Quit $$$OK
OutputRowGetBatchReturn
	Set Data=$lb(RRowID,RReturnNo,REquipType)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBatchReturnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBatchReturnExecute ]
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

ClassMethod GetBatchReturnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBatchReturnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
