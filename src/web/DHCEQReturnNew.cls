/// 创    建:ZY  2010-01-21  No.ZY0021
/// 修改描述:设备减少
/// --------------------------------
Class web.DHCEQReturnNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Add QW20210629 BUG:QW0131 增加输入参数院区HospitalDR
/// Modfied by zc0126 2022-12-26 2162208 增加CancelOper入参
Query Return(QXType, LocDR As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", OutTypeDR As %String = "", ToDeptDR As %String = "", ApproveRole As %String = "", WaitAD As %String = "", ReturnNo, EquipNo, InvalidFlag As %String = "N", Flag As %String = "", HospitalDR As %String = "", CancelOper As %String = "") As %Query(ROWSPEC = "TRowID:%String,TReturnNo:%String,TReturnLoc:%String,TProvider:%String,TReturnDate:%String,TStatus:%String,TRemark:%String,TBillAuditUser:%String,TEquipTypeDR:%String,TEquipType:%String,TStatCatDR:%String,TStatCat:%String,TOutType:%String,TToDept:%String,TApproveStep:%String,TApproveRole:%String,TRow:%String,TQuantity:%String,TTotalFee:%String,TApprovals:%String")
{
}

ClassMethod ReturnExecute(ByRef qHandle As %Binary, QXType, LocDR As %String = "", Status As %String = "", StartDate As %String = "", EndDate As %String = "", OutTypeDR As %String = "", ToDeptDR As %String = "", ApproveRole As %String = "", WaitAD As %String = "", ReturnNo, EquipNo, InvalidFlag As %String = "N", Flag As %String = "", HospitalDR As %String = "", CancelOper As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s OFlag=Flag
	s index=1
	s rowid=0
	s TRow=0
	s EquipTypeValues=""
	i OFlag="1" s EquipTypeValues=##class(web.DHCEQCommon).GetSysInfo("990024") ;add by marui
	i EquipTypeValues'="" s EquipTypeValues=","_EquipTypeValues_","
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$h
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("15")
	f  s rowid=$o(^DHCEQReturn(rowid))  quit:rowid=""  d
	.d ResetVariablesGetInStock
	.s TRowID = rowid
	.s RFlag=$p($g(^DHCEQReturn(rowid)),"^",28)
	.i RFlag="" s RFlag="N"
	.s TStatus = $p($g(^DHCEQReturn(rowid)),"^",13) //状态      //added by LMH20230323
	.q:(TStatus'=3)&&(InvalidFlag'="")&&(InvalidFlag'=RFlag)	//added by LMH20230323 过滤未作废的无效单据
	.s TReturnLocDR = $p($g(^DHCEQReturn(rowid)),"^",2) //退货科室
	.q:(LocDR'="")&&(LocDR'=TReturnLocDR)
	.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TReturnLocDR) ;Add QW20210629 BUG:QW0131
	.q:(HospitalDR'="")&&(HospitalDR'=THospitalDR) ;Add QW20210629 BUG:QW0131
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TReturnLocDR))) //2010-10-26 DJ
	.s ReturnDate=$p($g(^DHCEQReturn(rowid)),"^",4)  //退货日期
	.s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")   /// add by jyp 2018-08-19 Hisui改造：对日期进行格式转换处理
	.s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")    /// add by jyp 2018-08-19 Hisui改造：对日期进行格式转换处理
	.q:(ReturnDate>EndDate)||(ReturnDate<StartDate)
	.;s TStatus = $p($g(^DHCEQReturn(rowid)),"^",13) //状态  //modified by LMH20230323 获取状态提前做判断 //modified by LMH 20230331 修改注释错误 
	.q:(Status'="")&&(TStatus'=Status)
	.s TEquipTypeDR=$p($g(^DHCEQReturn(rowid)),"^",15)
	.q:(OFlag'="")&&(EquipTypeValues'[(","_TEquipTypeDR_","))
	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	.q:+result'=0
	.s TOutType=$p($g(^DHCEQReturn(rowid)),"^",17)
	.q:(OutTypeDR'="")&&(OutTypeDR'=TOutType)
	.q:(OutTypeDR="")&&(1=TOutType)
	.s TToDept=$p($g(^DHCEQReturn(rowid)),"^",18)
	.q:(ToDeptDR'="")&&(ToDeptDR'=TToDept)
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.s TApprovals="无"
	.s (AppSetDR,NextStepID)=""
	.i AIRowID'="" d
	..s AppSetDR=$p(^DHCEQApproveInfo(AIRowID),"^",3)		//czf 2021-09-01
	..s NextStepID=$p(^DHCEQApproveInfo(AIRowID),"^",5)
	..s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	..s TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	..i TApproveRole'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	//add by CZF0080 2020-02-24
	.i $p($g(^DHCEQReturn(rowid)),"^",13)=0 s TApprovals="" //modified by czf 1214221 2020-03-05
	.i ((WaitAD="on")&&(CurRole'="")) q:CurRole'=ApproveRole
	.s (AppFlowID,HospLimit)=""		//czf 2021-09-01 begin
	.i (AppSetDR'="")&&(NextStepID'="") d
	..s AppFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSetDR,NextStepID,""))
	..i AppFlowID'="" s HospLimit=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AppFlowID)),"^",20)
	.q:(WaitAD="on")&&(ApproveRole=CurRole)&&(##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(THospitalDR,"","","",HospLimit)) //czf 2021-09-01 end
	.s TReturnNo = $p($g(^DHCEQReturn(rowid)),"^",1) //退货单号
	.q:(ReturnNo'="")&&(TReturnNo'=ReturnNo) //Add By DJ 2010-08-31 Begin
	.;增加设备编号过滤条件
	.s Find=##Class(web.DHCEQInStockNew).CheckOrderEqNo("Return",rowid,EquipNo)
	.q:(EquipNo'="")&&(Find=0) //Add By DJ 2010-08-31 end
	.s TReturnLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TReturnLocDR)
	.s TProviderDR = $p($g(^DHCEQReturn(rowid)),"^",3) //供应商
	.s TProvider =  ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TReturnDate = ##class(web.DHCEQCommon).TransValueToPage(ReturnDate,"date") //退货日期
	.s TRemark = $p($g(^DHCEQReturn(rowid)),"^",14) //备注
	.s TBillAuditUserDR = $p($g(^DHCEQInStock(rowid)),"^",10) //账目确认人
	.s TBillAuditUser= ##class(web.DHCEQCommon).GetTrakNameByID("user",TProviderDR)
	.i TStatus'="" s TStatus=$Case(TStatus,"0":"新增","1":"提交","2":"审核","3":"账务审核")
	.i TEquipTypeDR '=""  d
	..s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.s TStatCatDR=$p($g(^DHCEQReturn(rowid)),"^",16)
	.i TStatCatDR '=""  d
	..s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.i TOutType'="" s TOutType=$p($g(^DHCEQCCode("DHCEQCOutType",TOutType)),"^",2)
	.i TToDept'="" s TToDept=$p($g(^DHCEQCCode("DHCEQCFromToDept",TToDept)),"^",2)
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("15",rowid) //2010-08-31 DJ begin
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5) //2010-08-31 DJ end
	./// 需求号:281575	Mozy	20161101
	.s TTotal=##class(web.DHCEQReturnNew).GetOneReturnTotalFeeNum(rowid)
	.s TQuantity=$P(TTotal,"^",1)
	.s TTotalFee=$P(TTotal,"^",2)
	.
	.s TRow=TRow+1
	.d OutputRowGetInStock
	Quit $$$OK
OutputRowGetInStock                                 
	s Data=$lb(TRowID,TReturnNo,TReturnLoc,TProvider,TReturnDate,TStatus,TRemark,TBillAuditUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TOutType,TToDept,TApproveStep,TApproveRole,TRow,TQuantity,TTotalFee,TApprovals)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStock
	s (TRowID,TReturnNo,TReturnLoc,TProvider,TReturnDate,TStatus,TRemark,TBillAuditUser,TEquipTypeDR,TEquipType,TStatCatDR,TStatCat,TOutType,TToDept,CurRole,AIRowID,TApproveStep,TApproveRole,TQuantity,TTotalFee,TApprovals)=""
	quit
}

ClassMethod ReturnFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReturnExecute ]
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
 	Set qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod ReturnClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReturnExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQReturnNew","ReturnList",2)
Query ReturnList(RowID As %String = "") As %Query(ROWSPEC = "TTotalFee:%String,TReturnNum:%String,TStock:%String,TRowID:%String,TReturn:%String,TBatchFlag:%String,TEquip:%String,TModel:%String,TManuFactory:%String,TReturnQtyNum:%String,TReturnFee:%String,TInvoiceNo:%String,TReturnReason:%String,TRemark:%String,TRow:%String,TInStockListDR:%String,TReturnReasonDR:%String,TJob:%String,TDealFee:%String,THold1:%String,THold2:%String,THold3:%String,TFlag:%String,TEquipDR:%String,TUnitDR:%String,TUnit:%String")
{
}

ClassMethod ReturnListExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index,rowid
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
	.s rowid=0
	.f  s rowid=$o(^DHCEQReturnList(0,"Return",RowID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetReturnList
	..s TRow=TRow+1
	..s TRowID = rowid							//rowid
	..s TReturnDR=$p($g(^DHCEQReturnList(rowid)),"^",1) //退货单
	..s StatCat=$p($g(^DHCEQReturn(RowID)),"^",16) //统计分类
	..s TBatchFlag=$p($g(^DHCEQReturnList(rowid)),"^",2) //批标志
	..s TInStockListDR=$p($g(^DHCEQReturnList(rowid)),"^",3) //入库单号
	..s TEquipDR=$p($g(^DHCEQReturnList(rowid)),"^",4) 
	..i TEquipDR'="" s TFlag="1"
	..i (TBatchFlag'="Y")&&(TEquipDR'="") d
	...s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1) //设备名称
	...s TStock=$p($g(^DHCEQEquip(TEquipDR)),"^",67) //库房
	...s TStock=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStock)
	...s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3) //机型
	...s TUnitDR = $p($g(^DHCEQEquip(TEquipDR)),"^",5) //单位  //modify by wl 2019-12-24 WL0037
	...i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	...s TManuFactoryDR = $p($g(^DHCEQEquip(TEquipDR)),"^",26) //生产厂商
	...i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//modified by czf 1252357
	..i (TBatchFlag="Y")&&(TInStockListDR'="") d
	...
	...s TSourceType = $p($g(^DHCEQInStockList(TInStockListDR)),"^",18)  ;SourceType
	...s TSourceID = $p($g(^DHCEQInStockList(TInStockListDR)),"^",19)  	;SourceID
	...i (TSourceType=1) s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",3)
	...i (TSourceType=2) s EquipTypeDR=$p($g(^DHCEQOpenCheckList(TSourceID)),"^",3)
	...;Add By DJ 2017-10-24
	...i TSourceType=""  d
	....s TInStockRowID=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	....s TEquipTypeDR=$p($g(^DHCEQInStock(TInStockRowID)),"^",20)
	...s TReturnNum=##class(web.DHCEQStoreMoveNew).GetTotalMoveQuantity(StoreLoc,TInStockListDR,EquipTypeDR,StatCat)
	...s MovedQuantity=##class(web.DHCEQStoreMoveNew).GetMoveListQuantity(TInStockListDR,rowid,"Return")
	...s TReturnNum=TReturnNum-MovedQuantity
	...s TEquip=$p($g(^DHCEQInStockList(TInStockListDR)),"^",5) //设备名称
	...s TModelDR =$p($g(^DHCEQInStockList(TInStockListDR)),"^",9) //机型
	...i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	...s TUnitDR= $p($g(^DHCEQInStockList(TInStockListDR)),"^",10)	//单位 
	...s TManuFactoryDR =$p($g(^DHCEQInStockList(TInStockListDR)),"^",6) //生产厂商
	...i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//modified by czf 1252357
	..s TReturnQtyNum=$p($g(^DHCEQReturnList(rowid)),"^",5) //退货数量
	..s TReturnFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQReturnList(rowid)),"^",6),"") //退货金额
	..s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TReturnQtyNum*TReturnFee,"")
	..// Mozy0217  2018-11-01
	..;s TotalQty=TotalQty+TReturnQtyNum
	..;s Amount=Amount+TTotalFee
	..
	..s TInvoiceNo=$p($g(^DHCEQReturnList(rowid)),"^",7) //发票号
	..s TReturnReasonDR=$p($g(^DHCEQReturnList(rowid)),"^",8) //退货原因
	..i TReturnReasonDR'="" s TReturnReason=$p($g(^DHCEQCCode("DHCEQCReturnReason",TReturnReasonDR)),"^",2) //结果
	..s TRemark=$p($g(^DHCEQReturnList(rowid)),"^",9) //备注
	..s TDealFee=$p($g(^DHCEQReturnList(rowid)),"^",10) //处置费用
	..s THold1=$p($g(^DHCEQReturnList(rowid)),"^",11) //Hold1
	..s THold2=$p($g(^DHCEQReturnList(rowid)),"^",12) //Hold2
	..s THold3=$p($g(^DHCEQReturnList(rowid)),"^",13) //Hold3
	..;// Mozy0217  2018-11-01
	..s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..i THold2="" d
	...s TotalQty=TotalQty+TReturnQtyNum
	...s Amount=Amount+TTotalFee
	..s TJob=Job
	..d OutputRowGetReturnList
	;没有数据时,也返回一个空行,用于编辑
	i TRow=0  d
	.d ResetVariablesGetReturnList
	.s TRow=1
	.s TJob=Job
	.d OutputRowGetReturnList
	;处理合计行
	i TotalFlag>0  d
	.d ResetVariablesGetReturnList
	.s TRowID=-1
	.s TRow="合计"
	.s TReturnQtyNum=TotalQty
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(Amount,"")
	.i TotalFlag="1"  d
	..s index=1
	.e  d
	..s index=index+1
	.s TJob=Job
	.d OutputRowGetReturnList
	Quit $$$OK
	
OutputRowGetReturnList
   s Data=$lb(TTotalFee,TReturnNum,TStock,TRowID,TReturnDR,TBatchFlag,TEquip,TModel,TManuFactory,TReturnQtyNum,TReturnFee,TInvoiceNo,TReturnReason,TRemark,TRow,TInStockListDR,TReturnReasonDR,TJob,TDealFee,THold1,THold2,THold3,TFlag,TEquipDR,TUnitDR,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetReturnList
	s (TTotalFee,TReturnNum,TStock,TRowID,TReturnDR,TBatchFlag,TEquip,TModel,TManuFactory,TReturnQtyNum,TReturnFee,TInvoiceNo,TReturnReason,TRemark,TInStockListDR,TReturnReasonDR,TJob,TDealFee,THold1,THold2,THold3,TFlag,TEquipDR,TUnitDR,TUnit)=""
	quit
}

ClassMethod ReturnListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReturnListExecute ]
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

ClassMethod ReturnListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReturnListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:新增、更新
/// w ##Class(web.DHCEQReturnNew).SaveData("^114^3^07/09/2010^^1^^1^^^^^1^^^3384","1^^78^196^5^^^^^^^^",",0,-1")
/// ----------------------------------
ClassMethod SaveData(val, valList, DelRowid)
{
	new RowID,PLIST
	Set $ZT="ERRORSave"
	s Date=+$H
	s Time=$P($H,",",2)
	s User= $p(val,"^",13)
	s RowID = $p(val,"^",1)		;RowID
 	s PLIST(3) = $p(val,"^",2)	;ReturnLocDR
 	s PLIST(4) = $p(val,"^",3)	;ProviderDR
 	s PLIST(5) = $p(val,"^",4)	;ReturnDate
 	i $p(val,"^",4)'=""  s PLIST(5) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"date")	;ReturnDate
 	s PLIST(6) = User			;MakerDR
 	s PLIST(7) = Date			;MakeDate
	s PLIST(14)="0"				;Status
 	s PLIST(15) = $p(val,"^",5)	;Remark
 	s PLIST(16) = $p(val,"^",6)	;EquipTypeDR
 	s PLIST(17) = $p(val,"^",7)	;StatCatDR
 	s PLIST(18) = $p(val,"^",8)	;OutTypeDR
 	s PLIST(19) = $p(val,"^",9)	;ToDeptDR
 	
 	s PLIST(20) = $p(val,"^",10)	;Hold1
 	s PLIST(21) = $p(val,"^",11)	;Hold2
 	s PLIST(22) = $p(val,"^",12)	;Hold3
	s Job = $p(val,"^",16) 		;$job
	s PLIST(25) = $p(val,"^",17) ;UseLocDR
	s PLIST(29) = "N"
	i RowID'=""
	{
		s InvalidFlag=$p($g(^DHCEQReturn(RowID)),"^",28) //2011-10-31 DJ DJ0098
		i InvalidFlag="Y" q -1015 //2011-10-31 DJ DJ0098
	}
	TSTART
	if RowID=""
	{
		s OutTypeCode=$p(^DHCEQCCode("DHCEQCOutType",$p(val,"^",8)),"^",1)		
	 	s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQReturn",+$H,"",$p(val,"^",6),"","","",OutTypeCode)
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
		q SQLCODE
 	} 	
		
 	s SQLCODE=..JudgeRLQuantityNum(RowID,Job,valList)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	
 	s SQLCODE=..SaveReturnList(RowID,Job,valList)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	s SQLCODE=..DeleteReturnList(DelRowid)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	
 	;Modified by JDL 2011-8-25 JDL0094 检查是否设备已经被其他单据占用
 	s SQLCODE=##Class(web.DHCEQStoreMoveNew).CheckOrder(2,RowID)
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
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述:删除
/// w ##Class(web.DHCEQReturnNew).DeleteData("")
/// ----------------------------------
ClassMethod DeleteData(val)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	;Modified By JDL 2011-10-12 JDL0098 保留变量User
	new (val,User)
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	Set $ZT="ERRORDelete"
	s Date=+$H
	s Time=$P($H,",",2)
	TSTART
	&SQL(Update SQLUSER.DHC_EQReturn Set R_InvalidFlag='Y',R_CancelUser=:User,R_CancelDate=:Date,R_CancelTime=:Time where R_RowID=:RowID)
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
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述:提交
/// w ##Class(web.DHCEQReturnNew).SubmitData("49^1276^1493^24/08/2010^^1^^1^^^^^1^^")
/// ----------------------------------
ClassMethod SubmitData(val, AutoCancelDepre As %String = "0")
{
	new (val, AutoCancelDepre, %session)  //add by zx 2016-02-25 Bug ZX0034 消息取不到session
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORSubmit"
	s RowID = $p(val,"^",1)	;RowID
	i RowID="" q ""
	s InvalidFlag=$p($g(^DHCEQReturn(RowID)),"^",28) //2011-10-31 DJ DJ0098
	i InvalidFlag="Y" q -1015 //2011-10-31 DJ DJ0098
	//add by zy 20120316  zy0091
	s ReturnProvider=##class(web.DHCEQInStockNew).ProviderIsUniqueNew("Return",RowID)
	i ReturnProvider<0 q ReturnProvider
	
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
  	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,ReturnLocDR)) q -1005   //判断退货单中的科室类型是否属于库房
	s Find=1
	i UseLocDR'="" s Find=$d(^DHCEQCCode("DHCEQCStoreManageLoc",0,"StoreLoc",ReturnLocDR,UseLocDR))
	i Find=0 q -1009 //当存在使用科室时判断是否属于库房管理下科室
	s ReturnEquipType=##CLASS(web.DHCEQInStockNew).EquipTypeIsUniqueNew(RowID,EquipTypeDR,"Return")
	i ReturnEquipType<0 q ReturnEquipType
	
	s Flag=##class(web.DHCEQCommon).GetSysInfo("301007")   //单据中设备类型是否需要一致
	if (Flag=1)&(StatCatDR'="")
	{
		s ReturnType=..StatCatIsUniqueNew(RowID,StatCatDR)
		i ReturnType<0 q ReturnType
	}
	
	s ApproveCondition="OutTypeDR,DHCEQReturn,"_OutTypeDR
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("15")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipTypeDR,"","","","",ApproveCondition)
	i ApproveSet="" q -4007
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
	 	q SQLCODE
	}
	if AuditFlag=1  //没有设置审批流,就直接审核
 	{
		s SQLCODE=##Class(web.DHCEQReturnNew).LastAuditAction(RowID, User, Date, AutoCancelDepre)	//DJ0137
		if SQLCODE'=0 //2011-05-27 DJ
		{
			TROLLBACK
			q SQLCODE
		}
 	}
 	else
 	{
	 	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	    If SQLCODE
	    {
		    TROLLBACK
		    Quit SQLCODE
	    }
		&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
 	}
 	;Modified by jdl 2011-3-9  jdl0073
 	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("23", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
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
		Quit SQLCODE
	}
	
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
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
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("23", RowID, User, ApproveFlow, "Y",CurRole)
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

/// ----------------------------------
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述:管理审核
/// w ##Class(web.DHCEQReturnNew).AuditData("52^1276^2616^25/08/2010^^1^^1^^^^^1^130^31",6,2,"")
ClassMethod AuditData(val, CurRole, RoleStep, EditFieldsInfo, AutoCancelDepre As %String = "0")
{
	new RowID,Date,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,Actions
	k PLIST
	s (RowID,Date,ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole,Actions)=""
	Set $ZT="ERRORAudit"
	s RowID=$P(val,"^",1)
	i RowID="" q ""
	s Date=+$H
	s User=$P(val,"^",13)
	;b
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("15")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("15", RowID)
	;b "ApproveSet"
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
		q SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	//编辑要修改的字段
	if EditFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(EditFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
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
			q SQLCODE
		}
	}
	//后一步审核的操作
	;s ^DHCEQTemp("jdl","100827")="AuditFlag:"_AuditFlag
	;b "AuditFlag"
	i AuditFlag=1
	{
		s AppInfo(9)="2"		;Status	
		s SQLCODE=##Class(web.DHCEQReturnNew).LastAuditAction(RowID, User, Date, AutoCancelDepre)	//DJ0137
		if SQLCODE'=0 //2011-05-27 DJ
		{
			TROLLBACK
			q SQLCODE
		}
	}
	;记录单据当前审批状态
	&SQL(update sqluser.DHC_EQApproveInfo values :AppInfo() where AI_SourceID=:RowID and  AI_ApproveTypeDR=:ApproveType)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	;b "TCOMMIT"
	;Modified by jdl 2011-3-9  jdl0073
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("23", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
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

/// ----------------------------------
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述:写入转移单明细
/// w ##Class(web.DHCEQReturnNew).SaveReturnList("","1^84^^...&1^85^...")
/// ----------------------------------
ClassMethod SaveReturnList(RRowID, Job, val)
{
	new Length,RLRowID,Flag,valList
	k PLISTMX
	i val="" q 0
	i RRowID="" q -1
	s Flag=0
	s PLISTMX(2)=RRowID  				;InStockDR
	s Length=$l(val,"&")
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=	$p(val,"&",i)
		s index= $p(valList,"^",1)  		;index
		s RLRowID= $p(valList,"^",2)  		;RLRowID
		i $Piece(valList,"^",4)="" s PLISTMX(3)="Y"		;RL_BatchFlag
		i $Piece(valList,"^",4)'="" s PLISTMX(3)="N"		;RL_BatchFlag
		s PLISTMX(4)=$p(valList,"^",3) 		;RL_InStockListDR
		s PLISTMX(5)=$p(valList,"^",4)		;RL_EquipDR
		s PLISTMX(6)=$p(valList,"^",5)  	;RL_ReturnQtyNum
		s PLISTMX(7)=$p(valList,"^",6)  	;RL_ReturnFee
		s PLISTMX(8)=$p(valList,"^",7)  	;RL_InvoiceNo
		s PLISTMX(9)=$p(valList,"^",8)  	;RL_ReturnReasonDR
		s PLISTMX(10)=$p(valList,"^",9)  	;RL_TRemark
		s PLISTMX(11)=$p(valList,"^",10)  	;RL_DealFee
		s PLISTMX(12)=$p(valList,"^",11)  	;RL_Hold1
		s PLISTMX(13)=$p(valList,"^",12)  	;RL_Hold2
		s PLISTMX(14)=$p(valList,"^",13)  	;RL_Hold3
		if (RLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQReturnList Values :PLISTMX())
			i SQLCODE 
			{
				s Flag=index_"^新增明细记录失败!"
			}
			else
			{
				s RLRowID=$G(%ROWID)
	 			if ($p(valList,"^",4)="")  //批量记录 //2011-05-27 DJ
	 			{
		 			s ^DHCEQReturnList(RLRowID,"EX","RowIDs")=$g(^TEMPEQ("MXList","EX",Job,index))
		 		}
		 		else
		 		{
			 		s ^DHCEQReturnList(RLRowID,"EX","RowIDs")=$p(valList,"^",4)
		 		}
		 		k ^TEMPEQ("MXList","EX",Job,index)
			}
		}
		else
		{
			&SQL(update sqluser.DHC_EQReturnList values :PLISTMX() where RL_RowID=:RLRowID)
			i SQLCODE s Flag=index_"^更新明细记录失败!"
		}
		//检测原值变化 2011-08-10 DJ begin
		s ListEQ=$g(^DHCEQReturnList(RLRowID,"EX","RowIDs"))
		s ListCount=$L(ListEQ,",")
		for j=1:1:ListCount
		{
			q:Flag'=0
			s EQID=$p(ListEQ,",",j)
			s EQOriginalFee=$p($g(^DHCEQEquip(EQID)),"^",27)
			i +EQOriginalFee'=+$p(valList,"^",6)		//Modify DJ 2015-09-10 DJ0163
			{
				s Flag=index_"^设备原值已发生变动,不可批量处理!"
			}
		}
		//2011-08-10 DJ end
	}
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
 			k ^DHCEQReturnList(RLRowID,"EX","RowIDs")
		}
	}
	q Flag
}

/// ----------------------------------
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述：增加设备退货生命周期信息记录
/// w ##Class(web.DHCEQReturnNew).LastAuditAction(52,1,61963)
/// ----------------------------------
ClassMethod LastAuditAction(RowID, User, Date, AutoCancelDepre)
{
	new RLRowID,StoreLocDR,EquipTypeDR,SQLCODE,EquipDR,equipRowIDs
	k PLIST
	i RowID="" q ""
	//增加冲减累计折旧 DJ0137
	i AutoCancelDepre="1"
	{
		s SQLCODE=..AutoCancelDepre(RowID)
		i SQLCODE q SQLCODE
	}
	//修改申请单的状态
	s PLIST(8)=User		;AckUserDR
	s PLIST(9)=Date		;AckDate
	s PLIST(11)=User		;BillAckUserDR
	s PLIST(12)=Date		;BillAckDate
	s PLIST(14)="2"			;Status
	i $p($g(^DHCEQReturn(RowID)),"^",13)=2 q -1010
	&SQL(update sqluser.DHC_EQReturn values :PLIST() where R_RowID=:RowID)
	i SQLCODE q SQLCODE
	
	//修改设备的信息
	s StoreLocDR=$P(^DHCEQReturn(RowID),"^",2)
	s EquipTypeDR=$P(^DHCEQReturn(RowID),"^",15)
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
	...s SQLCODE=..SaveOtherInfo(EquipDR,RLRowID,RowID,User)
	.;//Function:Funds	2012-2-16 生成资金来源信息
	.;Modified by JDL 2012-1-4 JDL0108
	.q:SQLCODE'=0
	.s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfo(5, RLRowID)
	.;Mozy0089	2012-10-17
	.Quit:SQLCODE'=0
	.Set SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(5, RLRowID)
	q SQLCODE
}

/// ----------------------------------
/// 创建:ZY  2010-01-21  No.ZY0021
/// 描述：记录设备的生命周期，台账，库房变动的信息
/// 返回值:0,更新成功
/// ----------------------------------
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
	s LI(16)=Date									//变动日期
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
	i LI(7)'=$p($g(^DHCEQReturnList(RLRowID)),"^",6) q "["_$p($g(^DHCEQEquip(EquipDR)),"^",1)_"]原值有发生变化,不可批量处理!"
	//2011-08-10 DJ end
	//修改台账
 	s SQLCODE=##Class(web.DHCEQReturnNew).SaveEquip(EquipDR,"2",RRowID,User)
	i SQLCODE'=0 q SQLCODE
	
	s LI(9)=$p($g(^DHCEQEquip(EquipDR)),"^",19)  	//变动后使用科室 
 	s LI(10)=$p($g(^DHCEQEquip(EquipDR)),"^",17) 	//变动后管理科室
 	s LI(11)=$p($g(^DHCEQEquip(EquipDR)),"^",67)  	//变动后库房
 	s LI(12)=$p($g(^DHCEQEquip(EquipDR)),"^",27)  	//变动后原值
 	s LI(13)=$p($g(^DHCEQEquip(EquipDR)),"^",28)  	//变动后净值
 	&SQL(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
 	i SQLCODE'=0 q SQLCODE=EquipName_"更新生命周期表信息失败!"
 	
 	//修改库房变动表
 	s SQLCODE=##Class(web.DHCEQReturnNew).SaveChangeStock(EquipDR,"2",RLRowID,User)
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
	new FromLoc,ToLoc,Date,EquipName
	i (EquipDR="")||(SourceType="")||(SourceID="") q ""
	s (FromLoc,ToLoc,Date,EquipName)=""
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
	}
	else
	{
		q ""
	}
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

/// ----------------------------------
/// 创建: add by zy 2010-08-24
/// 判断退货单设备类型的唯一性
/// ----------------------------------
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

/// w ##Class(web.DHCEQStoreMoveNew).GetOneStoreMove("197")
ClassMethod GetOneReturn(rowid)
{
	
	new (rowid)
	s (result,resultex)=""
	s result= ^DHCEQReturn(rowid)
	s resultex=resultex_"^"	;ReturnLocDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",3))
	s $p(result,"^",4)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"date")	;ReturnDate
	s resultex=resultex_"^"	;MakerDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",5))
	s $p(result,"^",6)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")	;MakeDate
	s resultex=resultex_"^"	;AckUserDR
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",7))
	s $p(result,"^",8)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"date")	;AckDate
	s resultex=resultex_"^"	;BillAckUserDR
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",10))
	s $p(result,"^",11)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;BillAckDate
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",15))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",16))),"^",2)
	s resultex=resultex_"^"	;
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOutType",$p(result,"^",17))),"^",2)
	s resultex=resultex_"^"	;
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",18))),"^",2)
	s apprInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("15",rowid)
	i apprInfo'=""  d
	.s resultex=resultex_"^"_apprInfo
	s resultex=resultex_"^"	;
	i $p(result,"^",24)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",24))
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// ----------------------------------
/// 修改:zy 2010-03-26  No ZY0019
/// 描述:判断批量转移的设备数量与选择的RowIDs是否一致
/// w ##Class(web.DHCEQReturnNew).JudgeRLQuantityNum("258","","1^371^^364^担架车^^90^5^^1601^")
/// ----------------------------------
ClassMethod JudgeRLQuantityNum(RRowID, Job, val)
{
	new (RRowID, Job, val)
	
	i RRowID="" q -1
	i val="" q 0
	s Flag=0
	s ReturnLocDR=$p($g(^DHCEQReturn(RRowID)),"^",2)		;ReturnLocDR
	s UseLocDR=$p($g(^DHCEQReturn(RRowID)),"^",24) ;UseLocDR
	i UseLocDR'="" s ReturnLocDR=UseLocDR
	s Length=$l(val,"&")
	
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=	$p(val,"&",i)
		;i $p(valList,"^",3)="" continue //单台设备不处理
		s index= $p(valList,"^",1)  		;index
		s RLRowID= $p(valList,"^",2)  		;SMLRowID
		s InStockListDR=$p(valList,"^",3)		
		
		;Modified by JDL 2011-08-15 JDL0091 单台时,也应记录EquipDR
		i $p(valList,"^",4)'=""
		{			
			if RLRowID=""  //新增明细
			{
				s ^TEMPEQ("MXList","EX",Job,index)=$p(valList,"^",4)
			}
			else
			{
				s ^DHCEQReturnList(RLRowID,"EX","RowIDs")=$p(valList,"^",4)
				k ^TEMPEQ("MXList",Job,RLRowID)
			}
			continue //单台设备不处理
		}
		
		s ReturnQtyNum=$p(valList,"^",5)  	;ReturnQtyNum
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

/// Add By DJ 2015-01-21 DJ0137
/// 描述:自动执行退货冲减折旧操作
ClassMethod AutoCancelDepre(vRRowID As %String = "")
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
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

/// 需求号:281575	Mozy	20161101
/// w ##class(web.DHCEQReturnNew).GetOneReturnTotalFeeNum(36)
ClassMethod GetOneReturnTotalFeeNum(RRowID)
{
	i RRowID="" q ""
	new RLRowID,Fee,Num
	s RLRowID=0
	s Fee=0
	s Num=0
	f  s RLRowID=$o(^DHCEQReturnList(0,"Return",RRowID,RLRowID)) q:RLRowID=""  d
	.s QuantityNum=$P(^DHCEQReturnList(RLRowID),"^",5)
	.s OriginalFee=$P(^DHCEQReturnList(RLRowID),"^",6)
	.s Fee=Fee+(QuantityNum*OriginalFee)
	.s Num=Num+QuantityNum
	i Fee=0  d
	.s Fee=""
	e  d
	.s Fee=##Class(web.DHCEQCommon).FormatNumber(Fee,"")
	i Num=0 s Num=""
	q Num_"^"_Fee
}

/// Mozy0217  2018-11-01
/// 描述:根据来源生成其设备配置的退货单明细
/// 入参： SourceType：		0:入库单明细ID		1:设备DR
/// w ##Class(web.DHCEQReturnNew).GetRLForConfig(0, 774, 571, 1)
/// w ##Class(web.DHCEQReturnNew).GetRLForConfig(1, 45459, 571)
ClassMethod GetRLForConfig(SourceType As %String = "", SourceID As %String = "", FromLocDR As %String = "", index As %String = "0")
{
	i (SourceType="")||(SourceID="") q ""
	;s ^DHCEQMozy("GetRLForConfig")=SourceType_","_SourceID_","_FromLocDR_","_index
	// valList=&index+"^^"+TInStockListDR+"^"+TEquipDR+"^"+TReturnQtyNum+"^"+TReturnFee+"^^^^^^"+THold2+"^"_Equip
	
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
			...Quit:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR("",tmpEquipID,StoreLocDR,2)'=0
			...If RowIDs'="" Set RowIDs=RowIDs_","
			...Set RowIDs=RowIDs_tmpEquipID
			.Quit:RowIDs=""
			.
			.s Num=Num+1
			.i valList'="" s valList=valList_"&"
			.s valList=valList_Num_"^^"_tmpISLRowID_"^^"_$l(RowIDs,",")	;$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",8)  	;RL_ReturnQtyNum
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",7)	;RL_ReturnFee
			.s valList=valList_"^^^^^^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",22)
			.s valList=valList_"^"_$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",5)
			.s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("model",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",9)) //机型
			.s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",6)) //厂商
			.s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("uom",$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",10)) //单位
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
		..Quit:##Class(web.DHCEQUpdateEquipsByList).CheckEquipDR("",tmpEquipID,StoreLocDR,2)'=0
		..
		..Set RowIDs=tmpEquipID
		..s Num=Num+1
		..i valList'="" s valList=valList_"&"
		..s valList=valList_Num_"^^^"_tmpEquipID_"^"_$l(RowIDs,",")	;$Piece($Get(^DHCEQInStockList(tmpISLRowID)),"^",8)  	;RL_ReturnQtyNum
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",27)	;RL_ReturnFee
		..s valList=valList_"^^^^^^"_$Piece($Get(^DHCEQEquip(tmpEquipID,"OtherInfo")),"^",26)		;ConfigDR
		..s valList=valList_"^"_$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",1)
		..s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("model",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",3)) //机型
		..s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",26)) //厂商
		..s valList=valList_"^"_##class(web.DHCEQCommon).GetTrakNameByID("uom",$Piece($Get(^DHCEQEquip(tmpEquipID)),"^",5)) //单位
	}
	
	Quit valList
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQReturnNew","ReturnListNew",2)
Query ReturnListNew(RowID As %String = "") As %Query(ROWSPEC = "RLTotalFee:%String,RLReturnNum:%String,RLStock:%String,RLRowID:%String,RLReturnDR:%String,RLBatchFlag:%String,RLEquip:%String,RLModel:%String,RLManuFactory:%String,RLReturnQtyNum:%String,RLReturnFee:%String,RLInvoiceNo:%String,RLReturnReason:%String,RLRemark:%String,RLRow:%String,RLInStockListDR:%String,RLReturnReasonDR:%String,RLJob:%String,RLDealFee:%String,RLHold1:%String,RLHold2:%String,RLHold3:%String,RLFlag:%String,RLEquipDR:%String,RLUnitDR:%String,RLUnit:%String")
{
}

ClassMethod ReturnListNewExecute(ByRef qHandle As %Binary, RowID As %String = "") As %Status
{
	new repid, index,rowid
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
	.s rowid=0
	.f  s rowid=$o(^DHCEQReturnList(0,"Return",RowID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetReturnListNew
	..s TRow=TRow+1
	..s TRowID = rowid							//rowid
	..s TReturnDR=$p($g(^DHCEQReturnList(rowid)),"^",1) //退货单
	..s StatCat=$p($g(^DHCEQReturn(RowID)),"^",16) //统计分类
	..s TBatchFlag=$p($g(^DHCEQReturnList(rowid)),"^",2) //批标志
	..s TInStockListDR=$p($g(^DHCEQReturnList(rowid)),"^",3) //入库单号
	..s TEquipDR=$p($g(^DHCEQReturnList(rowid)),"^",4) 
	..i TEquipDR'="" s TFlag="1"
	..i (TBatchFlag'="Y")&&(TEquipDR'="") d
	...s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1) //设备名称
	...s TStock=$p($g(^DHCEQEquip(TEquipDR)),"^",67) //库房
	...s TStock=##class(web.DHCEQCommon).GetTrakNameByID("dept",TStock)
	...s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3) //机型
	...s TUnitDR = $p($g(^DHCEQEquip(TEquipDR)),"^",4) //单位 
	...i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	...s TManuFactoryDR = $p($g(^DHCEQEquip(TEquipDR)),"^",26) //生产厂商
	...i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//modified by czf 1252357
	..i (TBatchFlag="Y")&&(TInStockListDR'="") d
	...
	...s TSourceType = $p($g(^DHCEQInStockList(TInStockListDR)),"^",18)  ;SourceType
	...s TSourceID = $p($g(^DHCEQInStockList(TInStockListDR)),"^",19)  	;SourceID
	...i (TSourceType=1) s EquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceID)),"^",3)
	...i (TSourceType=2) s EquipTypeDR=$p($g(^DHCEQOpenCheckList(TSourceID)),"^",3)
	...;Add By DJ 2017-10-24
	...i TSourceType=""  d
	....s TInStockRowID=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	....s TEquipTypeDR=$p($g(^DHCEQInStock(TInStockRowID)),"^",20)
	...s TReturnNum=##class(web.DHCEQStoreMoveNew).GetTotalMoveQuantity(StoreLoc,TInStockListDR,EquipTypeDR,StatCat)
	...s MovedQuantity=##class(web.DHCEQStoreMoveNew).GetMoveListQuantity(TInStockListDR,rowid,"Return")
	...s TReturnNum=TReturnNum-MovedQuantity
	...s TEquip=$p($g(^DHCEQInStockList(TInStockListDR)),"^",5) //设备名称
	...s TModelDR =$p($g(^DHCEQInStockList(TInStockListDR)),"^",9) //机型
	...i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	...s TUnitDR= $p($g(^DHCEQInStockList(TInStockListDR)),"^",10)	//单位 
	...s TManuFactoryDR =$p($g(^DHCEQInStockList(TInStockListDR)),"^",6) //生产厂商
	...i TManuFactoryDR'="" s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//modified by czf 1252357
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
   s Data=$lb(TTotalFee,TReturnNum,TStock,TRowID,TReturnDR,TBatchFlag,TEquip,TModel,TManuFactory,TReturnQtyNum,TReturnFee,TInvoiceNo,TReturnReason,TRemark,TRow,TInStockListDR,TReturnReasonDR,TJob,TDealFee,THold1,THold2,THold3,TFlag,TEquipDR,TUnitDR,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetReturnListNew
	s (TTotalFee,TReturnNum,TStock,TRowID,TReturnDR,TBatchFlag,TEquip,TModel,TManuFactory,TReturnQtyNum,TReturnFee,TInvoiceNo,TReturnReason,TRemark,TInStockListDR,TReturnReasonDR,TJob,TDealFee,THold1,THold2,THold3,TFlag,TEquipDR,TUnitDR,TUnit)=""
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

/// modified by ZY0241 跟进设备id和入库单id来取值,排除TInStockListDR=0的情况
/// HISUI改造需重新调整 曾超
/// add by kdf 2017-01-09
/// 用于减少单、退货单润乾打印
/// d ##class(%ResultSet).RunQuery("web.DHCEQReturnNew","ReturnListPrint",2)
Query ReturnListPrint(RowID As %String = "", RequestNo As %String = "", EquipType As %String = "", FromLoc As %String = "", ReturnDate As %String = "", Maker As %String = "", ToDept As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TModel:%String,TUnit:%String,TManuFactory:%String,TReturnNum:%String,TReturnFee:%String,TTotalFee:%String,TRemark:%String,TEquipNos:%String,TISInvoiceNos:%String,TRLInVoiceNos:%String,TReason:%String") [ SqlProc ]
{
}

ClassMethod ReturnListPrintExecute(ByRef qHandle As %Binary, RowID As %String = "", RequestNo As %String = "", EquipType As %String = "", FromLoc As %String = "", ReturnDate As %String = "", Maker As %String = "", ToDept As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	if RowID'=""  d
	.s RLRowID=$o(^DHCEQReturnList(0,"Return",RowID,0))
	.s StoreLoc=$p($g(^DHCEQReturn(RowID)),"^",2) //退货科室
	.s EquipType=$p($g(^DHCEQReturn(RowID)),"^",15) //类组
	.s StatCat=$p($g(^DHCEQReturn(RowID)),"^",16) //统计分类
	.s rowid=0
	.f  s rowid=$o(^DHCEQReturnList(0,"Return",RowID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetReturnListPrint
	..s TRowID = rowid							    //rowid
	..s TBatchFlag=$p($g(^DHCEQReturnList(rowid)),"^",2) //批标志
	..s TInStockListDR=$p($g(^DHCEQReturnList(rowid)),"^",3) //入库单号
	..s TEquipDR=$p($g(^DHCEQReturnList(rowid)),"^",4) 
	..i TEquipDR'="" s TFlag="1"
	..i TEquipDR>0 d
	...s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1) //设备名称
	...s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3) //机型
	...s TUnitDR = $p($g(^DHCEQEquip(TEquipDR)),"^",5) //单位  //modify by wl 2019-12-24 WL0038
	...s TManuFactoryDR = $p($g(^DHCEQEquip(TEquipDR)),"^",26) //生产厂商
	...s TInStockListDR = $p($g(^DHCEQEquip(TEquipDR)),"^",70)
	...;
	..i TInStockListDR>0 d
	...s TEquip=$p($g(^DHCEQInStockList(TInStockListDR)),"^",5) //设备名称
	...s TModelDR =$p($g(^DHCEQInStockList(TInStockListDR)),"^",9) //机型
	...s TUnitDR= $p($g(^DHCEQInStockList(TInStockListDR)),"^",10)	//单位 
	...s TManuFactoryDR =$p($g(^DHCEQInStockList(TInStockListDR)),"^",6) //生产厂商
	..s TReturnNum=$p($g(^DHCEQReturnList(rowid)),"^",5) //退货数量
	..s TReturnFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQReturnList(rowid)),"^",6),"") //退货单价
	..s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TReturnNum*TReturnFee,"")      //总金额
	..s TRemark=$p($g(^DHCEQReturnList(rowid)),"^",9) //备注
	..i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	..s TEquipNos=##class(web.DHCEQCommon).GetEquipNos("23",TRowID,"","EquipNos")
	..s TISInvoiceNos=##class(web.DHCEQCommon).GetInvoiceNo(1,TInStockListDR)	//入库明细发票号
	..s TRLInVoiceNos=$p($g(^DHCEQReturnList(TRowID)),"^",7)		//退货明细发票号
	..s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(2,TRowID)
	..s TRLInVoiceNos=$p(return,"^",1)
	..s TInvoiceDate=$p(return,"^",2)
	..s TInvoiceFee=$p(return,"^",3)
	..s TReasonDR=$p($g(^DHCEQReturnList(TRowID)),"^",8)
	..i TReasonDR'="" s TReason=$p($g(^DHCEQCCode("DHCEQCReturnReason",TReasonDR)),"^",2)
	..d OutputRowGetReturnListPrint
	Quit $$$OK
	
OutputRowGetReturnListPrint
   s Data=$lb(TRowID,TEquip,TModel, TUnit, TManuFactory ,TReturnNum ,TReturnFee, TTotalFee ,TRemark,TEquipNos,TISInvoiceNos,TRLInVoiceNos,TReason)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetReturnListPrint
	s (TRowID,TEquip,TModel, TUnit, TManuFactory ,TReturnNum ,TReturnFee, TTotalFee ,TRemark,TEquipNos,TISInvoiceNos,TRLInVoiceNos,TReasonDR,TReason)=""
	quit
}

ClassMethod ReturnListPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ReturnListPrintExecute ]
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

ClassMethod ReturnListPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ReturnListPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Mozy0217  2018-11-01
/// 判断报废单是否存在有配置设备
/// 		返回值		Find:空		未匹配到配置记录
/// w ##Class(web.DHCEQReturnNew).CheckConfigDR(2)
ClassMethod CheckConfigDR(RowID As %String = "")
{
	n Find, KindFlag, EquipDR, ListID, len, i, id
	
	s Find=""
	i (RowID="") q Find
	
	s ListID=""
    f  s ListID=$o(^DHCEQReturnList(0,"Return",RowID,ListID)) quit:ListID=""  d
    .s EquipDR = ^DHCEQReturnList(ListID,"EX","RowIDs") ; "46198,46205,46212,46219" 
	.s len=$l(EquipDR,",")
 	.f i=1:1:len d
 	..s id=""
    ..f  s id=$o(^DHCEQEquip(0,"Parent",$p(EquipDR,",",i),id)) quit:id=""  d
	...i Find'="" s Find=Find_","
	...s Find=Find_$Piece($Get(^DHCEQEquip(id,"OtherInfo")),"^",26)
 	
	q Find
}

}
