Class web.DHCEQM.DHCEQMMaintPart Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter GlobalLen = 18;

/// w ##Class(web.DHCEQM.DHCEQMMaintPart).SaveData("^^5149^2^550^1100^^^^60^1^^N^^/^5693^^^^PM7000血氧探头 512F^",2,"","")
ClassMethod SaveData(val, isDel As %Library.String = "", user As %Library.String = "", loc As %Library.String = "")
{
	k PLIST,RowID
	;s ^DHCEQMozy("SaveData")=val_","_isDel_","_user_","_loc
    	s RowID=$p(val,"^",1)
	s PLIST(2)=$p(val,"^",2)		// MTP_MaintDR
	s PLIST(3)=$p(val,"^",3)		// MTP_AccessoryDR	配件项
	s PLIST(4)=$p(val,"^",4)		// MTP_QuantityNum	数量
	s PLIST(5)=$p(val,"^",5)		// MTP_PriceFee
	s PLIST(6)=$p(val,"^",6)		// MTP_TotalFee
	s PLIST(7)=$p(val,"^",7)		// MTP_Remark
	s PLIST(8)=$p(val,"^",8)		// MTP_StoreRoomDR
	s PLIST(9)=$p(val,"^",9)		// MTP_FeeFlag
	s PLIST(10)=$p(val,"^",10)		// MTP_MaintRequestDR	维修申请单RowID
	s PLIST(11)=$p(val,"^",11)		// MTP_AccessryTypeDR	配件类组
	s PLIST(12)=$p(val,"^",12)		// MTP_AMSListDR		配件出库明细RowID
	s PLIST(13)=$p(val,"^",13)		// MTP_PurchaseFlag		待购标志
	s PLIST(14)=$p(val,"^",14)		// MTP_StockDetailDR
	s PLIST(15)=$p(val,"^",15)		// MTP_Model
	s PLIST(16)=$p(val,"^",16)		// MTP_ManufacturerDR
	s PLIST(17)=$p(val,"^",17)		// MTP_ProviderDR
	s PLIST(18)=$p(val,"^",18)		// MTP_MaintItemDR
	s PLIST(19)=$p(val,"^",19)		// MTP_AISListDR
	s PLIST(20)=$p(val,"^",20)		// MTP_Desc
	i PLIST(20)="" s PLIST(20)=$p(val,"^",27)	// 20191117 Mozy0232
	s PLIST(21)=$p(val,"^",21)		// MTP_InvoiceNos		发票号
	s PLIST(22)=$p(val,"^",22)		// MTP_OfferPrice Modify by zx BUG ZX0078
	s PLIST(23)=$p(val,"^",23)		// MTP_AccessoryOriginalDR Modify by zx 2020-02-27 BUG ZX0078
	s PLIST(24)=$p(val,"^",24)		// MTP_Hold3  czf 用于存储物资请领单ID
	s PLIST(25)=$p(val,"^",25)		// MTP_Hold4
	s PLIST(26)=$p(val,"^",26)		// MTP_Hold5
	s PLIST(27)=##Class(web.DHCEQCommon).GetSysInfo("503006")		// MTP_Hold6 配件录入方式 czf 2020-09-25
	
	s SQLCODE=0
	TSTART
	i (+isDel=2)
	{
	  if RowID=""
	  {
		  /*/判断是否重复
		  i (PLIST(13)="Y")&&($D(^DHCEQMMaintPart(0,"PurchaseFlag","Y",PLIST(10),PLIST(3))))
		  {
			  TROLLBACK
			  q -1200
		  }*/
		  i (PLIST(13)="N")&&($D(^DHCEQMMaintPart(0,"AStockDetail",PLIST(10),+PLIST(14)))&&(PLIST(27)'="DHC-STM"))	//CZF0091 2020-09-25
		  {
			  TROLLBACK
			  q -1201
		  }
		  &SQL(insert into SQLUSER.DHC_EQMMaintPart values:PLIST())
		  s RowID=$Get(%ROWID)
	  }
	  else 
	  {
		  /*/判断是否重复				^DHCEQMMaintPart(0,"PurchaseFlag","Y",51,8147,1) = "" 
		  i (PLIST(13)="Y")&($d(^DHCEQMMaintPart(0,"PurchaseFlag","Y",PLIST(10),PLIST(3))))&(RowID'=$o(^DHCEQMMaintPart(0,"PurchaseFlag","Y",PLIST(10),PLIST(3),0)))
		  {
			  TROLLBACK
			  q -1200
		  }*/
		  i PLIST(27)'="DHC-STM"	//CZF0091 2020-09-25
		  {
			  i (PLIST(13)="N")&&($d(^DHCEQMMaintPart(0,"AStockDetail",PLIST(10),+PLIST(14))))&&(RowID'=$o(^DHCEQMMaintPart(0,"AStockDetail",PLIST(10),+PLIST(14),0)))
			  {
				  TROLLBACK
				  q -1201
			  }
		  }
		  &SQL(update SQLUSER.DHC_EQMMaintPart values:PLIST() where MTP_RowID=:RowID)
	  }
	}
	i (+isDel=1)
	{
		i (RowID '="")
		{
			/*Set TMTIMaintRequestDR=$P($G(^DHCEQMMaintPart(RowID)),"^",9)
			Set return=##class(web.DHCEQM.DHCEQMMaintPart).CancelManage(TMTIMaintRequestDR,RowID)
			if return
			{
				TROLLBACK
				q return
			}*/
			// MZY0067	1706437		2021-01-20	删除配件时增加DelFlag标识,根据配件关联的入库单和转移单状态判断是否可以删除维修配件记录
			//i ($P($G(^DHCEQMMaintPart(RowID)),"^",12)="Y")&&($P($G(^DHCEQMMaintPart(RowID)),"^",18)'="") Quit -1   ////Modiedy by zc0057 代购配件已制入库单不能删除
			Set DelFlag=0		;可删除标识
			Set MaintRequestDR=$P($G(^DHCEQMMaintPart(RowID)),"^",9)
			i ##Class(web.DHCEQM.DHCEQMMaintPart).CheckBussPrint(MaintRequestDR)'="" Quit -1101
			;;Mozy	2018-3-21	区分维修单里配件进行删除时一并删除关联的入库明细和出库明细
			i $P($G(^DHCEQMMaintPart(RowID)),"^",12)="Y" d
			.Set AISLRowID=$P($G(^DHCEQMMaintPart(RowID)),"^",18)
			.if AISLRowID'="" d
			..Set tmpStatus=+$Piece($Get(^DHCEQAInStock($Piece($Get(^DHCEQAInStockList(AISLRowID)),"^",1))),"^",16)
			..If (tmpStatus=0)||(tmpStatus=3) Do
			...d ##Class(web.DHCEQAInStockList).DeleteInStockList(AISLRowID)	;新增或作废状态可删除明细
			..Else  Do
			...Set DelFlag=-1		;不能删除
			e  d
			.Set ASMLRowID=$P($G(^DHCEQMMaintPart(RowID)),"^",11)
			.if ASMLRowID'="" d
			..Set ASMRowID=$P($G(^DHCEQAMoveStockList(ASMLRowID)),"^",1)
			..Set tmpStatus=+$Piece($Get(^DHCEQAMoveStock(ASMRowID)),"^",28)
			..If (tmpStatus=0)||(tmpStatus=3) Do
			...d ##Class(web.DHCEQAMoveStock).DeleteAMoveStockList(ASMRowID,ASMLRowID)	;新增或作废状态可删除明细
			..Else  Do
			...Set DelFlag=-1		;不能删除
			i DelFlag=0
			{
				&SQL(delete from SQLUSER.DHC_EQMMaintPart where MTP_RowID=:RowID)
				k ^DHCEQMMaintPart(RowID)
			}
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q RowID
}

/// MZY0118	2542893		2022-03-28	增加配件单位
/// MZY0063	1580112		2020-12-11	增加"配件类组"
/// Modify by zx 2020-02-27 BUG ZX0078 增加配件来源、报价处理
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintPart","MaintPart","2","",12214)
Query MaintPart(MaintRequestDR As %String = "", MaintItemDR As %String = "", User As %String = "") As %Query(ROWSPEC = "TMTPRowID:%String,TMTPMaintDR:%String,TMTPAccessoryDR:%String,TMTPAccessory:%String,TMTPQuantityNum:%String,TMTPPriceFee:%String,TMTPTotalFee:%String,TMTPRemark:%String,TMTPStoreRoomDR:%String,TMTPFeeFlag:%String,TMTIMaintRequestDR:%String,TMTPHold2:%String,TMTPHold3:%String,TMTPHold4:%String,TMTPHold5:%String,TMTPModel:%String,TMTPManufacturerDR:%String,TMTPManufacturer:%String,TMTPProviderDR:%String,TMTPProvider:%String,TMTPMaintItem:%String,TSerialNo:%String,TRow:%String,TConfirmData:%String,TInvoiceNos:%String,TMTPOfferPrice:%String,TMTPAccessoryOriginalDR:%String,TMTPAccessoryOriginal:%String,TMTPAccessoryType:%String,TMTPPurchaseFlag:%String,TMTPHold4Desc:%String")
{
}

ClassMethod MaintPartExecute(ByRef qHandle As %Binary, MaintRequestDR As %String = "", MaintItemDR As %String = "", User As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	Set TRow=0
	Set TotalFee=0
	// MZY0039	1416082		2020-7-20
	i User="" Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	d ##Class(web.DHCEQCommon).KillTempGlobalNew("MaintPartNum", User)
	
	i MaintRequestDR="" Quit $$$OK //add by zx 2016-09-20 维修id为空时bug ZX0036
	Set rowid=0
	For  Set rowid=$Order(^DHCEQMMaintPart(0,"MaintRequest",MaintRequestDR,rowid))  Quit:rowid=""  Do
	.Do ResetVariablesGetMaintPart
	.Set TMTPRowID=rowid
	.Set TMTPMaintDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",1)
	.Set TMTPAccessoryDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",2)
	.;s TMTPAccessory=$p($g(^DHCEQAStockDetail(TMTPAccessoryDR)),"^",5)		//Modify DJ 2014-09-23
	.;s TSerialNo=$p($g(^DHCEQAStockDetail(TMTPAccessoryDR)),"^",10)
	.Set TMTPQuantityNum=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",3)
	.Set TMTPPriceFee=##Class(web.DHCEQCommon).FormatNumber($P($G(^DHCEQMMaintPart(TMTPRowID)),"^",4),"",2)
	.Set TMTPTotalFee=##Class(web.DHCEQCommon).FormatNumber($P($G(^DHCEQMMaintPart(TMTPRowID)),"^",5),"",2)
	.Set TMTPRemark=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",6)
	.Set TMTPStoreRoomDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",7)
	.Set TMTPFeeFlag=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",8)
	.Set TMTIMaintRequestDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",9)
	.Set TAccessoryTypeDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",10)	// 20191117 Mozy0232
	.Set TAMSListDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",11)	// 20191117 Mozy0232
	.; MZY0118	2542893		2022-03-28
	.Set TMTPPurchaseFlag=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",12)		;待购
	.Set TMTPStockDetailDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",13)	;配件库存明细表ID
	.If TMTPStockDetailDR'="" Set TSerialNo=$p($g(^DHCEQAStockDetail(TMTPStockDetailDR)),"^",9)
	.Set TMTPModel=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",14)
	.Set TMTPManufacturerDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",15)
	.i TMTPManufacturerDR'="" s TMTPManufacturer=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TMTPManufacturerDR)  //CZF0093
	.Set TMTPProviderDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",16)
	.i TMTPProviderDR'="" s TMTPProvider=$Piece($Get(^DHCEQCCode("DHCEQCVendor",TMTPProviderDR)),"^",2)
	.// 20191117 Mozy0232
	.Set TMTPAISListDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",17)
	.Set TMTPMaintItemDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",18)
	.Quit:(MaintItemDR'="")&&(MaintItemDR'=TMTPMaintItemDR)
	.Set TMTPAccessory=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",19)	;MTP_Desc
	.Set TInvoiceNos=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",20)
	.;Modify by zx 2020-02-27 BUG ZX0078
	.;s TMTPAccessoryOriginalDR=$p($g(^DHCEQMMaintPart(TMTPRowID)),"^",22)			//modified by czf 2021-04-21 1880336 begin
	.;i TMTPAccessoryOriginalDR'="" s TMTPAccessoryOriginal=$p($g(^DHCEQCCode("DHCEQCAccessoryOriginal",TMTPAccessoryOriginalDR)),"^",2)
	.Set TMTPOfferPrice=##Class(web.DHCEQCommon).FormatNumber($P($G(^DHCEQMMaintPart(TMTPRowID)),"^",21),"",2)
	.; MZY0118	2542893		2022-03-28
	.Set TMTPHold4 = $P($G(^DHCEQMMaintPart(TMTPRowID)),"^",24)
	.Set TMTPHold4Desc=##Class(web.DHCEQCommon).GetTrakNameByID("uom", TMTPHold4)
	.Set TMTPHold5 = $P($G(^DHCEQMMaintPart(TMTPRowID)),"^",25)
	.Set TMTPHold6 = $P($G(^DHCEQMMaintPart(TMTPRowID)),"^",26)		//配件录入方式	czf 2020-09-25 begin CZF0091
	.i TMTPHold6="DHC-STM" d
	..s TMTPAccessoryOriginal="物资材料库"
	..s TMTPAccessory=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",19)
  	..s groupInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp($P($G(^DHCEQMMaintPart(TMTPRowID)),"^",2))  ;库存项类组信息
	..s TAccessoryType=$p(groupInfo,"^",2)
	.e  d
	..s TMTPAccessoryOriginal="设备配件库"		//modified by czf 2021-04-21 1880336  end
	..i TMTPAccessoryDR'="" s TMTPAccessory=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",TMTPAccessoryDR)),"^",2)
	..i TAccessoryTypeDR'="" s TAccessoryType=$p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
	..If $Data(^DHCEQMMaintPart(rowid,"ConfirmData")) Do
	...Set ConfirmData=$P($G(^DHCEQMMaintPart(rowid,"ConfirmData")),";",2)
	...If ConfirmData'="" Do
	....Set TConfirmData=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(ConfirmData,",",1))
	....Set TConfirmData=##class(web.DHCEQCommon).GetSplitDataByFlag(TConfirmData,"-")
	....Set TConfirmData=TConfirmData_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(ConfirmData,",",2))
	....Set TConfirmData=TConfirmData_"在"_##Class(web.DHCEQCommon).TransValueToPage($p(ConfirmData,",",3),"CHNDate")_"确认同意使用(购买)该项配件."		//CZF0091 2020-09-25 end
	.d OutputRowGetMaintPart
    Quit $$$OK
	
OutputRowGetMaintPart
	Set ^TempDHCEQ("MaintPartNum",+$H,User)=1+$g(^TempDHCEQ("MaintPartNum",+$H,User))	// MZY0039	1416082		2020-7-20	维修配件记录数
	Set TRow=TRow+1
   	Set Data=$lb(TMTPRowID,TMTPMaintDR,TMTPAccessoryDR,TMTPAccessory,TMTPQuantityNum,TMTPPriceFee,TMTPTotalFee,TMTPRemark,TMTPStoreRoomDR,TMTPFeeFlag,TMTIMaintRequestDR,TMTPHold2,TMTPHold3,TMTPHold4,TMTPHold5,TMTPModel,TMTPManufacturerDR,TMTPManufacturer,TMTPProviderDR,TMTPProvider,TMTPMaintItem,TSerialNo,TRow,TConfirmData,TInvoiceNos,TMTPOfferPrice,TMTPAccessoryOriginalDR,TMTPAccessoryOriginal,TAccessoryType,TMTPPurchaseFlag,TMTPHold4Desc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintPart
	s (TMTPRowID,TMTPMaintDR,TMTPAccessoryDR,TMTPAccessory,TMTPQuantityNum,TMTPPriceFee,TMTPTotalFee,TMTPRemark,TMTPStoreRoomDR,TMTPFeeFlag,TMTIMaintRequestDR,TMTPHold2,TMTPHold3,TMTPHold4,TMTPHold5,TMTPModel,TMTPManufacturerDR,TMTPManufacturer,TMTPProviderDR,TMTPProvider,TMTPMaintItem,TSerialNo,TConfirmData,TInvoiceNos,TMTPOfferPrice,TMTPAccessoryOriginalDR,TMTPAccessoryOriginal,TMTPHold6,TAccessoryType,TMTPPurchaseFlag,TMTPHold4Desc)=""
	quit
}

ClassMethod MaintPartFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintPartExecute ]
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

ClassMethod MaintPartClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintPartExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneMaintPart(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
  new result,resultex
  s (result,resultex)=""
  s result=^DHCEQMMaintPart(rowid)
  s MTPInputType=$Piece(result,"^",26)	//CZF0091 2020-09-25 begin 配件录入方式
  set count=..#GlobalLen-$l(result,"^")
  for i=count:-1:1 { s result=result_"^"}
  Set resultex=resultex_"^"	
  If $Piece(result,"^",2)'=""  Do
  .i MTPInputType="DHC-STM" d
  ..s resultex=resultex_$Piece(result,"^",19)
  .e  d
  ..s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCAccessory",$P(result,"^",2))),"^",2)
  //Mozy	572345	201-3-26	数值格式化
  If $Piece(result,"^",4)'="" Set $Piece(result,"^",4) = ##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",4),0)
  If $Piece(result,"^",5)'="" Set $Piece(result,"^",5) = ##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",5),0)
  Set resultex=resultex_"^"	
  If $Piece(result,"^",7)'=""  Do
  .s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",7))
  Set resultex=resultex_"^"	
  If $Piece(result,"^",15)'=""  Do
  .s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$Piece(result,"^",15))  //CZF0093
  Set resultex=resultex_"^"	
  If $Piece(result,"^",16)'=""  Do
  .s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCVendor",$P(result,"^",16))),"^",2)
  Set resultex=resultex_"^"	
  If $Piece(result,"^",10)'=""  Do
  .i MTPInputType="DHC-STM" d
  ..s groupInfo=##class(web.DHCSTMHUI.Common.DrugInfoCommon).GetIncStkCatGrp($p(result,"^",2))  ;库存项类组信息
  ..s Type=$p(groupInfo,"^",2)	;类组名称
  ..s resultex=resultex_Type
  .e  s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAccessoryType",$p(result,"^",10))),"^",2)
  Set SerialNo=""		// MZY0080	1943178		2021-06-03	配件序列号
  Set resultex=resultex_"^"		; CanUseNum
  If ($Piece(result,"^",12)="N")&&(MTPInputType'="DHC-STM")  Do
  .s MaintRequestDR=$Piece(result,"^",9)
  .s StockDetailDR=$Piece(result,"^",13)
  .s TStock=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",17)
  .;i $Piece(result,"^",10)=1 Set LocDR=##Class(web.DHCEQCommon).GetFirstIDByLocType("0302")	;维修配件设置为零件仓库
  .s LocDR=##Class(web.DHCEQCommon).GetFirstIDByLocType("0302")
  .s FreezeNum=##class(web.DHCEQAReduce).CheckAccessoryDR(StockDetailDR,LocDR,rowid,2)      ///被占用的数量
  .s CanUseNum=TStock-FreezeNum                 ///可退数量
  .Set SerialNo=$p($g(^DHCEQAStockDetail(StockDetailDR)),"^",9)		// MZY0080	1943178		2021-06-03	配件序列号
  .s resultex=resultex_CanUseNum
  //Modify by zx 2020-02-27 BUG ZX0078
  Set resultex=resultex_"^"	
  If $Piece(result,"^",22)'=""  Do
  .s resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCAccessoryOriginal",$P(result,"^",22))),"^",2)
  Set resultex=resultex_"^"_SerialNo	// MZY0080	1943178		2021-06-03	配件序列号
  Set resultex=resultex_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("uom", $Piece(result,"^",24))	; MZY0118	2542893		2022-03-28
  
  s result=rowid_"^"_result_"^"_resultex
  q result
}

/// Add By DJ 2014-09-24
/// 描述:自动生成出库总单
/// w ##Class(web.DHCEQM.DHCEQMMaintPart).AutoSaveAStoreMove(1,13,131,0,15)
ClassMethod AutoSaveAStoreMove(ASMLRowID, vRequestNo, vAccessoryTypeDR, vFromLocDR, vToLocDR, vMoveType, vUser)
{
	n Date,Time,LocDR,ASMRowID,SQLCODE
	
	s Date=+$H
	s Time=$p($H,",",2)
	s SQLCODE=0	;20190311 Mozy0221
	K ASMPLIST
	
	s ASMPLIST(3) = vAccessoryTypeDR	;AccessoryTypeDR
	s ASMPLIST(5) = vFromLocDR		;FromLocDR
	s ASMPLIST(6) = vToLocDR		;ToLocDR
	s ASMPLIST(7) = vUser			;MakerDR
	s ASMPLIST(8) = Date			;MakeDate
	s ASMPLIST(9) = Time  			;MakeTime
	;s ASMPLIST(12) = vUser			;SubmitDR
	;s ASMPLIST(13) = Date			;SubmitDate
	;s ASMPLIST(14) = Time  		;SubmitTime
	s ASMPLIST(15) = vMoveType		;MoveType
	s ASMPLIST(16) = vUser			;ReciverDR
	;s ASMPLIST(17) = vUser			;AuditDR
	;s ASMPLIST(18) = Date			;AuditDate
	;s ASMPLIST(19) = Time  		;AuditTime
	s ASMPLIST(29) = "0"			;Status		新增状态
	;s ASMPLIST(30) = vRequestNo_"维修配件自动生成"			;Remark
	s ASMPLIST(31) = "Y"				;Hold1		Mozy0189	2017-5-26	自动建单未编辑标志
	s LocDR=vFromLocDR
	i vMoveType=2 s LocDR=vToLocDR
	// MZY0063	1580112		2020-12-11
	i ASMLRowID="" d
	.;s ASMPLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAMoveStock",Date,LocDR)
	.s ASMPLIST(2) = ##Class(web.DHCEQCommon).GetTrakNameByID("user", vUser)_$zd($h,3)_" "_$zt($piece($h,",",2))_" 建单"
	.&SQL(insert into sqluser.DHC_EQAMoveStock values :ASMPLIST())
	.s ASMRowID=$Get(%ROWID)
	e  d
	.s ASMRowID=$Piece($Get(^DHCEQAMoveStockList(ASMLRowID)),"^",1)
	.i $Piece($Get(^DHCEQAMoveStock(ASMRowID)),"^",28)'=0 d
	..s SQLCODE=-9002
	.e  d
	..&SQL(update sqluser.DHC_EQAMoveStock values :ASMPLIST() where AMS_RowID=:ASMRowID)
	i SQLCODE q SQLCODE
	
	q ASMRowID
}

/// Add By DJ 2014-09-24
/// 描述:自动生成出库明细记录
/// w ##Class(web.DHCEQM.DHCEQMMaintPart).AutoSaveAStoreMove(1,4,2)
ClassMethod AutoSaveAStoreMoveList(ASMLRowID, vRequestNo, vASMRowID, vASDRowID, vQuantity, vMMPRowID)
{
	n ASMMoveType,ASDStatus,ASDStockNum,TAInStockListDR,SQLCODE
	K ASML
	s SQLCODE=0	;20190311 Mozy0221
	
	s ASMMoveType=$p($g(^DHCEQAMoveStock(vASMRowID)),"^",14)
	s ASDStatus=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",12)
	i ((ASMMoveType=0)&&(ASDStatus'=0)) q -9000	//出库是否已经使用或退货减少
	i ((ASMMoveType=2)&&(ASDStatus'=1)) q -9001	//是否已经退库退货减少
	s ASDStockNum=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",17)
	i (ASDStockNum<vQuantity) q -9215			//库存不足时
	s ASML(2)=vASMRowID				;AMSL_MoveStockDR
	s ASML(3)=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",2)  		;AMSL_ItemDR
	s ASML(4)=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",4)		;AMSL_Code
	s ASML(5)=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",5)		;AMSL_Desc
	s ASML(6)=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",15)		;AMSL_Model
	s ASML(7)=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",13)  	;AMSL_BaseUOMDR
	s ASML(8)=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",14)  	;AMSL_ManuFactoryDR
	s TAInStockListDR=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",3)
	i TAInStockListDR'="" d
	.s ASML(9)=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",16)	;AMSL_BatchFlag
	.s ASML(10)=$p($g(^DHCEQAInStockList(TAInStockListDR)),"^",15)	;AMSL_SerialFlag
	e  d
	.s ASML(9)=$p($g(^DHCEQCAccessory(ASML(3))),"^",88)			;AMSL_BatchFlag
	.s ASML(10)=$p($g(^DHCEQCAccessory(ASML(3))),"^",35)		;AMSL_SerialFlag
	s ASML(11)=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",8)  	;AMSL_Price
	s ASML(12)=vQuantity  	;AMSL_QuantityNum
	s ASML(13)=##Class(web.DHCEQCommon).FormatNumber(ASML(11)*ASML(12),"")  ;AMSL_Amount
	s ASML(14)=vRequestNo_"维修配件自动生成"  	;AMSL_Remark
	s ASML(15)=vASDRowID  			;AMSL_StockDetailDR
	s ASML(16)=TAInStockListDR  	;AMSL_Hold2
	// 20191117 Mozy0232	存储设备DR
	s ASML(17)=$P($G(^DHCEQMMaintPart(vMMPRowID)),"^",9)
	i ASML(17)'="" d
	.s TmpExObjDR = $Piece($Get(^DHCEQMMaintRequest(ASML(17))),"^",5)
	.i TmpExObjDR'="" d
	..s SourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(ASML(17))),"^",63)
	..i (SourceTypeDR=1)||(SourceTypeDR=2) s ASML(17)=$Piece($Get(^DHCEQMExObj(TmpExObjDR)),"^",5)
	s ASML(18)=vMMPRowID
	//Modify by zx 2020-02-27 库存获取
	;Set ASML(23)=$P($G(^DHCEQMMaintPart(vMMPRowID)),"^",21)	///增加库存数	Mozy	566327	201-3-16
	s CurASRowID=$p($g(^DHCEQAStockDetail(vASDRowID)),"^",21)
	i CurASRowID'="" d
	.s ASML(23)=$p($g(^DHCEQAStock(CurASRowID)),"^",10)
	// MZY0063	1580112		2020-12-11
	i ASMLRowID="" d
	.&SQL(insert into sqluser.DHC_EQAMoveStockList values :ASML())
	.s ASMLRowID=$Get(%ROWID)
	e  d
	.&SQL(update sqluser.DHC_EQAMoveStockList values :ASML() where AMSL_RowID=:ASMLRowID)
	i SQLCODE q SQLCODE
	
	//序列号管理登记序列号
	i ASML(10)="Y" s ^DHCEQAMoveStockList(ASMLRowID,"EX","RowIDs")=vASDRowID
	q ASMLRowID
}

/// add by zx 2014-12-16
/// 获取配件信息
/// w ##Class(web.DHCEQM.DHCEQMMaintPart).GetMaintAccessoryDetail(26)
ClassMethod GetMaintAccessoryDetail(MaintRequestDR)
{
	i MaintRequestDR="" q ""
	s (TAccessoryEX,TModelEX,TPriceFeeEX,TQuantityNumEX)=""
	s TPriceTotal=0
	s TPriceFeeNum=0
	s MaintPartDR=0
	f  s MaintPartDR=$o(^DHCEQMMaintPart(0,"MaintRequest",MaintRequestDR,MaintPartDR)) q:MaintPartDR=""  d
	.s TAStockDetailDR=$p($g(^DHCEQMMaintPart(MaintPartDR)),"^",2)
	.i TAStockDetailDR'="" s TAccessoryDR=$p($g(^DHCEQAStockDetail(TAStockDetailDR)),"^",2)
	.i TAccessoryDR'="" d
	..s (TAccessory,TModel)=""
	..s TAccessory=$p($g(^DHCEQCCode("DHCEQCAccessory",TAccessoryDR)),"^",2)
	..s TAccessoryEX=TAccessoryEX_TAccessory_","
	..s TModelDR=$p($g(^DHCEQCCode("DHCEQCAccessory",TAccessoryDR)),"^",4)
	..i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s TModelEX=TModelEX_TModel_","
	.s TPriceFee=$p($g(^DHCEQMMaintPart(MaintPartDR)),"^",4)
	.s TPriceFeeEX=TPriceFeeEX_TPriceFee_","
	.s TQuantityNum=$p($g(^DHCEQMMaintPart(MaintPartDR)),"^",3)
	.s TQuantityNumEX=TQuantityNumEX_TQuantityNum_","
	.s TPriceFeeNum=TPriceFee*TQuantityNum
	.s TPriceTotal=TPriceTotal+TPriceFeeNum
	
	q TAccessoryEX_"^"_TModelEX_"^"_TPriceFeeEX_"^"_TQuantityNumEX_"^"_TPriceTotal
}

/// 20190311 Mozy0221	修正入参
/// 设置临时节点存储待审批配件数量
/// 设置类型	Type	空:待确认设置操作		其他:设置确认操作
///      返回值	0:成功	其他:失败
/// w ##class(web.DHCEQM.DHCEQMMaintPart).ConfirmMaintPart(9,1)
/// modified by czf 2020-09-25 CZF0091确认配件时增加物资生成请领单功能
ClassMethod ConfirmMaintPart(MaintRequestDR As %String = "", Type As %String = "", UserID As %String = "", LocID As %String = "") As %String
{
	If MaintRequestDR="" Quit -1
	s (List,MPReqID)=""
	i UserID="" s UserID=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i LocID="" s LocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	
	s ErrFlag=0
	s ListObj=##class(%ListOfDataTypes).%New()		//czf 2021-01-30 1747240
	Set MMPRowID=0
	For  Set MMPRowID=$Order(^DHCEQMMaintPart(0,"MaintRequest",MaintRequestDR,MMPRowID)) Quit:(MMPRowID="")||(MPReqID'="")||(ErrFlag'=0)  Do
	.;提交信息
	.If (Type="") Do
	..Set ^DHCEQMMaintPart(MMPRowID,"ConfirmQuantity")=0
	..Set ^DHCEQMMaintPart(MMPRowID,"ConfirmData")=LocID_","_UserID_","_$H
	.;确认信息
	.If (Type'="") Do
	..Set ^DHCEQMMaintPart(MMPRowID,"ConfirmQuantity")=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",3)
	..Set ^DHCEQMMaintPart(MMPRowID,"ConfirmData")=$Get(^DHCEQMMaintPart(MMPRowID,"ConfirmData"))_";"_LocID_","_UserID_","_$H
	..s MTPInputType=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",26)
	..i MTPInputType="DHC-STM" d
	...s StockLocID=""
	...s rowid=$o(^DHCEQCCode("DHCEQCSysSet",0,"Code","503006",0))
	...i rowid'="" s StockLocID=$p($g(^DHCEQCCode("DHCEQCSysSet",rowid)),"^",5)	
	...i StockLocID="" s ErrFlag=-5601	//物资库房ID未设置
	...q:ErrFlag'=0
	...s InciId=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",2)	//物资库存项ID
	...i InciId="" s ErrFlag=-5602	//物资库存项ID不能为空!
	...q:ErrFlag'=0
	...s BUomId=$p(^INCI(InciId,1),"^",10)	//物资库存项单位
	...s Num=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",3)
	...s MaintRequestNo=$Piece($Get(^DHCEQMMaintRequest(MaintRequestDR)),"^",1)
	...s Remark="维修单:"_MaintRequestNo_"维修用配件"
	...s AType=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",10)	//类组ID
	...s Model=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",14)	//规格型号
	...;s ListData="^"_InciId_"^"_BUomId_"^"_Num_"^"_Remark_"^"_AType_"^"_Model	 //czf 2021-01-30 1747240 begin
	...;i List="" s List=ListData
	...;e  s List=List_$c(1)_ListData
	...;s req=StockLocID_"^"_LocID_"^"_UserID_"^"_AType
	...s ListDataObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	...s ListDataObj.Inci=InciId
	...s ListDataObj.Uom=BUomId
	...s ListDataObj.Qty=Num
	...s ListDataObj.ReqRemarks=Remark
	...s ListDataObj.Scg=AType
	...s ListDataObj.SpecDesc=Model
	...d ListObj.Insert(ListDataObj)
	...s List=##class(web.DHCEQ.Plat.JsonObject).ArrayToJsonStr(ListObj)
	...s ReqObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	...s ReqObj.SupLoc=StockLocID
	...s ReqObj.ReqLoc=LocID
	...s ReqObj.gUserId=UserID
	...s ReqObj.ScgStk=AType
	...s req=ReqObj.%ToJSON()
	...s MPReqStr=##class(web.DHCEQ.Interface.Outer.DHCSTMServiceForFixedAssets).CreatReq("",req,List)	//生成物资请领单 //czf 2021-01-30 1747240 end
	...s MPReqObj=##class(web.DHCEQ.Plat.JsonObject).FromJSON(MPReqStr)
	...i MPReqObj.success<0 s ErrFlag=-5603	//物资请领单生成失败!
	...q:ErrFlag'=0
	...s MPReqID=MPReqObj.rowid
	...&SQL(update SQLUSER.DHC_EQMMaintPart set MTP_Hold3=:MPReqID)
	...i SQLCODE s ErrFlag=-5604		;物资请领单ID保存失败
	...q:ErrFlag'=0
	
	i ErrFlag="" quit ErrFlag
	q 0
}

/// 删除存储待审批配件数量的临时节点
/// w ##class(web.DHCEQM.DHCEQMMaintPart).CancelConfirmMaintPart(1)
ClassMethod CancelConfirmMaintPart(RowID As %String = "") As %String
{
	If RowID="" Quit -1
	
	Set MMPRowID=0
	For  Set MMPRowID=$Order(^DHCEQMMaintPart(0,"MaintRequest",RowID,MMPRowID)) Quit:(MMPRowID="")  Do
	.Kill ^DHCEQMMaintPart(MMPRowID,"ConfirmQuantity")
	.Kill ^DHCEQMMaintPart(MMPRowID,"ConfirmData")
	
	Quit RowID
}

/// 检测该维修单是否有待审核的配件
/// 1:有		0:无
/// w ##class(web.DHCEQM.DHCEQMMaintPart).CheckMaintPartQuantity(18)
ClassMethod CheckMaintPartQuantity(RowID As %String = "") As %String
{
	new Flag,MMPRowID
	Set Flag=0
	If RowID="" Quit Flag
	
	Set MMPRowID=0
	For  Set MMPRowID=$Order(^DHCEQMMaintPart(0,"MaintRequest",RowID,MMPRowID)) Quit:(MMPRowID="")||(Flag'=0)  Do
	.Quit:'$Data(^DHCEQMMaintPart(MMPRowID,"ConfirmQuantity"))
	.
	.If $P($G(^DHCEQMMaintPart(MMPRowID)),"^",3)'=+$G(^DHCEQMMaintPart(MMPRowID,"ConfirmQuantity")) Set Flag=1	;待购配件设置数量为0
	
	Quit Flag
}

/// MZY0063	1580112		2020-12-11	调整配件提交处理
/// Mozy	572515	2018-3-29	修改原入参变量RowID为MRRowID
/// 提交配件信息:待购的配件生成配件入库单
/// 				 库存已有的配件生成配件转移库单
///      返回值	0:失败	其他:成功
/// w ##class(web.DHCEQM.DHCEQMMaintPart).SubmitManage(26,202,78)
ClassMethod SubmitManage(MRRowID As %String = "", FromLocDR As %String = "", CurUser As %String = "") As %String
{
	If MRRowID="" Quit 0
	new AISRowID, AISLRowID, ASMRowID, ASMLRowID, AccessoryTypeDR
	Set SQLCODE=0
	;Set ^DHCEQMozy("SubmitManage")=MRRowID_","_FromLocDR_","_CurUser
	
	TSTART
	Set User=CurUser	;##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	;If FromLocDR="" Set FromLocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	Set FromLocDR= ##Class(web.DHCEQCommon).GetFirstIDByLocType("0302")		;Mozy	2016-12-21
	
	Set RequestNo=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",1)
	Set ToLocDR=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",6)	;MR_ObjLocDR	设备使用科室
	Set MMPRowID=0
	For  Set MMPRowID=$Order(^DHCEQMMaintPart(0,"MaintRequest",MRRowID,MMPRowID)) Quit:(MMPRowID="")||(SQLCODE<0)  Do
	.Set AccessoryTypeDR=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",10)
	.Set InvoiceNos=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",20)
	.If ($P($G(^DHCEQMMaintPart(MMPRowID)),"^",12)="Y") Do
	..;待购配件自动生成入库库单及明细
	..Set AISLRowID=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",18)
	..If $p($g(^DHCEQAInStock(+$p($g(^DHCEQAInStockList(+AISLRowID)),"^",1))),"^",16)=3 Set AISLRowID=""	;MZY0118	2535858		2022-03-28
	..Set AISRowID=##Class(web.DHCEQM.DHCEQMMaintPart).AutoSaveAInStock(AISLRowID,RequestNo,MMPRowID,FromLocDR,ToLocDR,User,InvoiceNos)
	..Quit:AISRowID<0
	..Set AISLRowID=##Class(web.DHCEQM.DHCEQMMaintPart).AutoSaveAInStockList(AISLRowID,RequestNo,AISRowID,MMPRowID)
	..Quit:AISLRowID<0
	..;存储入库单明细
	..&SQL(Update SQLUSER.DHC_EQMMaintPart Set MTP_AISListDR=:AISLRowID Where MTP_RowID=:MMPRowID)
	.Else  Do
	..;库存配件自动生成出库单
	..Set ASMLRowID=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",11)
	..If $p($g(^DHCEQAMoveStock(+$p($g(^DHCEQAMoveStockList(+ASMLRowID)),"^",1))),"^",28)=3 Set ASMLRowID=""	;MZY0118	2535858		2022-03-28
	..Set ASMRowID=##Class(web.DHCEQM.DHCEQMMaintPart).AutoSaveAStoreMove(ASMLRowID, RequestNo, AccessoryTypeDR, FromLocDR, ToLocDR, 0, User)
	..Quit:ASMRowID<0
	..Set QuantityNum=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",3)
	..Set ASDRowID=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",13)
	..Set ASMLRowID=##Class(web.DHCEQM.DHCEQMMaintPart).AutoSaveAStoreMoveList(ASMLRowID, RequestNo, ASMRowID, ASDRowID, QuantityNum, MMPRowID)
	..Quit:ASMLRowID<0
	..;存储转移单明细
	..&SQL(Update SQLUSER.DHC_EQMMaintPart Set MTP_AMSListDR=:ASMLRowID Where MTP_RowID=:MMPRowID)
	
	i SQLCODE<0
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
	Quit MRRowID
}

/// Mozy	572515	2018-3-29	修改原入参变量RowID为MRRowID
/// 删除存储待审批配件数量的临时节点
/// w ##class(web.DHCEQM.DHCEQMMaintPart).CancelManage(129)
ClassMethod CancelManage(MRRowID As %String = "", paraMMPRowID As %String = "") As %String
{
	If MRRowID="" Quit 0
	New Flag,MMPRowID,AISLRowID,ASMLRowID,listDR
	TSTART
	Set Flag=0
	Set MMPRowID=0
	For  Set MMPRowID=$Order(^DHCEQMMaintPart(0,"MaintRequest",MRRowID,MMPRowID)) Quit:(MMPRowID="")||(Flag'=0)  Do
	.Quit:(paraMMPRowID'="")&(paraMMPRowID'=MMPRowID)
	.If $Piece($Get(^DHCEQMMaintPart(MMPRowID)),"^",12)="Y" Do
	..;待购配件处理生成的入库单
	..Set AISLRowID=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",18)
	..Quit:AISLRowID=""
	..Set listDR=$Piece($Get(^DHCEQAInStockList(AISLRowID)),"^",1)
	..Set Status=$Piece($Get(^DHCEQAInStock(listDR)),"^",16)
	..If (Status'=0)&&(Status'=3) Set Flag="请与配件管理员联系处理入库单:"_$Piece($Get(^DHCEQAInStock(listDR)),"^",6)
	..Quit:Flag'=0
	..Set Flag=##Class(web.DHCEQAInStockList).DeleteData(listDR)
	..;需求序号:	416831		Mozy	20170803	清空维修配件记录表入库单明细信息
	..Quit:Flag'=0
	..&SQL(Update SQLUSER.DHC_EQMMaintPart Set MTP_AISListDR=null where MTP_RowID=:MMPRowID)
	..Set Flag=SQLCODE
	..Set ^DHCEQAInStock(listDR,"CancelManage")=Flag_":"_##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))_","_##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))_","_$H
	.Else  Do
	..Set ASMLRowID=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",11)
	..Quit:ASMLRowID=""
	..Set listDR=$Piece($Get(^DHCEQAMoveStockList(ASMLRowID)),"^",1)
	..Set Status=$Piece($Get(^DHCEQAMoveStock(listDR)),"^",28)
	..If (Status'=0)&&(Status'=3) Set Flag="请与配件管理员联系处理转移单:"_$Piece($Get(^DHCEQAMoveStock(listDR)),"^",1)
	..Quit:Flag'=0
	..Set Flag=##Class(web.DHCEQAMoveStock).DeleteData(listDR)
	..;需求序号:	416831		Mozy	20170803	清空维修配件记录表转移单明细信息
	..Quit:Flag'=0
	..&SQL(Update SQLUSER.DHC_EQMMaintPart Set MTP_AMSListDR=null where MTP_RowID=:MMPRowID)
	..Set Flag=SQLCODE
	..Set ^DHCEQAMoveStock(listDR,"CancelManage")=Flag_":"_##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))_","_##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))_","_$H
	
	If Flag
	{
		TROLLBACK
		Quit Flag
	}
	
	TCOMMIT
	Quit Flag
}

/// 描述:自动生成配件入库总单
/// w ##Class(web.DHCEQM.DHCEQMMaintPart).AutoSaveAInStock(1,131,131,15)
ClassMethod AutoSaveAInStock(AISLRowID, vRequestNo, vMMPRowID, vFromLocDR, vToLocDR, vUser, mainInvoiceNos)
{
	n Date,Time,LocDR,AISRowID,SQLCODE
	s Date=+$H
	s Time=$p($H,",",2)
	s SQLCODE=0	/// 20190311 Mozy0221
	K PLIST
	
	;s ^DHCEQMozy("AutoSaveAInStock")=AISLRowID_","_vRequestNo_","_vMMPRowID_","_vFromLocDR_","_vToLocDR_","_vUser
	s PLIST(2) = Date			;InDate
 	s PLIST(3) = $Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",10)	;AccessoryTypeDR
 	s PLIST(4) = vFromLocDR		;LocDR	SBLJCK-设备零件仓库
 	s PLIST(5) = vUser			;RequestUserDR
    s PLIST(6) = Date			;RequestDate
 	;s PLIST(7) = $p(val,"^",7)	;InStockNo
 	s PLIST(8) = 0	;InType		采购,盘盈,捐赠,分解,其他
 	s PLIST(9) = $Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",16)	;ProviderDR
 	;s PLIST(10) = $p(val,"^",10)	;SourceID 	
 	s PLIST(11) = vToLocDR			;BuyLocDR
 	s PLIST(12) = vUser				;BuyUserDR
 	s PLIST(17) = "0"				;Status
 	s PLIST(18) = vUser				;AddUserDR
 	s PLIST(19) = Date				;AddDate
 	s PLIST(20) = Time				;AddTime
 	;S PLIST(27) = vRequestNo_"维修配件自动生成"	;Remark
 	s PLIST(28) = "Y"				;Hold1		Mozy0189	2017-5-26	自动建单未编辑标志
 	// MZY0063	1580112		2020-12-11
	s PLIST(29) = mainInvoiceNos	;Hold2
 	
 	i AISLRowID="" d
	.//Set PLIST(7)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAInStock",Date,vFromLocDR)
	.Set PLIST(7) = ##Class(web.DHCEQCommon).GetTrakNameByID("user", vUser)_$zd($h,3)_" "_$zt($piece($h,",",2))_" 建单"_vMMPRowID
	.&SQL(insert into sqluser.DHC_EQAInStock values :PLIST())
	.s AISRowID=$Get(%ROWID)
	e  d
	.s AISRowID=$Piece($Get(^DHCEQAInStockList(AISLRowID)),"^",1)
	.i $Piece($Get(^DHCEQAInStock(AISRowID)),"^",16)'=0 d
	..s SQLCODE=-9002
	.e  d
	..&SQL(update sqluser.DHC_EQAInStock values :PLIST() where AIS_RowID=:AISRowID)
	i SQLCODE q SQLCODE
	Set ^DHCEQAInStock(AISRowID,"InvoiceNos")=mainInvoiceNos
	
	q AISRowID
}

/// 描述:自动生成入库明细记录
/// w ##Class(web.DHCEQM.DHCEQMMaintPart).AutoSaveAInStockList(1,4,2)
ClassMethod AutoSaveAInStockList(AISLRowID, vRequestNo, vISRowID, vMMPRowID)
{
	n SQLCODE
	K PLISTMX
	s SQLCODE=0	/// 20190311 Mozy0221
	
	s PLISTMX(2)=vISRowID
	s PLISTMX(3) = $Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",2)				;ItemDR
 	i PLISTMX(3)'="" s PLISTMX(4) = $P($Get(^DHCEQCCode("DHCEQCAccessory",PLISTMX(3))),"^",1) 	;Code
 	;s PLISTMX(5) = $P($Get(^DHCEQCCode("DHCEQCAccessory",PLISTMX(3))),"^",2)	;Desc
 	s PLISTMX(5) = $Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",19)				;Desc
 	s PLISTMX(6) = $Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",14)				;Model
 	s PLISTMX(7) = $Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",24)				;MTP_Hold4	MZY0118	2542893		2022-03-28
 	i PLISTMX(3)'="" s PLISTMX(7) = $P($Get(^DHCEQCCode("DHCEQCAccessory",PLISTMX(3))),"^",5)	;BaseUOMDR
 	s PLISTMX(8) = $Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",15)				;ManuFactoryDR
 	s PLISTMX(9) = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",4),"",2)	;Price
 	s PLISTMX(10) = $Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",3)	;QuantityNum
 	s PLISTMX(11) = ##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",5),"",2)	;Amount
 	s PLISTMX(13) = 1			;SourceType	默认配件项入库
 	s PLISTMX(14) = PLISTMX(3)	;SourceID
 	;;s PLISTMX(15) = $p(valList,"^",)	;EstimateFlag
 	s PLISTMX(16)="N"
	i PLISTMX(3)'="" s PLISTMX(16)=$P($Get(^DHCEQCCode("DHCEQCAccessory",PLISTMX(3))),"^",35)  ;SerialFlag
 	s PLISTMX(17)="Y"  			;BatchFlag
 	i (PLISTMX(16)="Y") s PLISTMX(17)="N"
 	s PLISTMX(20)=$Piece($Get(^DHCEQMMaintPart(vMMPRowID)),"^",20)
	s PLISTMX(21) = vRequestNo_"维修配件自动生成"	;Remark
	// MZY0063	1580112		2020-12-11
	i AISLRowID="" d
	.&SQL(Insert Into SQLUSER.DHC_EQAInStockList Values :PLISTMX())
	e  d
	.&SQL(update sqluser.DHC_EQAInStockList values :PLISTMX() where AISL_RowID=:AISLRowID)
	
	i SQLCODE q SQLCODE
	
	q $Get(%ROWID)
}

/// 20190311 Mozy0221	修正入参
/// Mozy	20160615
/// RowID	维修单DR
/// w ##Class(web.DHCEQM.DHCEQMMaintPart).CheckBussPrint(73)
ClassMethod CheckBussPrint(MaintRequestDR As %String = "")
{
	i MaintRequestDR="" q ""
	s Info=""
	
	Set MMPRowID=0
	For  Set MMPRowID=$Order(^DHCEQMMaintPart(0,"MaintRequest",MaintRequestDR,MMPRowID)) Quit:(MMPRowID="")  Do
	.s Flag=0
	.If $Piece($Get(^DHCEQMMaintPart(MMPRowID)),"^",12)="Y" Do
	..Set AISLRowID=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",18)
	..Quit:AISLRowID=""
	..Set listDR=+$Piece($Get(^DHCEQAInStockList(AISLRowID)),"^",1)			;Mozy	2018-3-16	强制转换为数值
	..Set Flag = ##Class(web.DHCEQM.DHCEQMMaintPart).BussPrintInfo("A01",listDR)
	.Else  Do
	..Set ASMLRowID=$P($G(^DHCEQMMaintPart(MMPRowID)),"^",11)
	..Quit:ASMLRowID=""
	..Set listDR=+$Piece($Get(^DHCEQAMoveStockList(ASMLRowID)),"^",1)		;Mozy	2018-3-16	强制转换为数值
	..Set Flag = ##Class(web.DHCEQM.DHCEQMMaintPart).BussPrintInfo("A02",listDR)
	.
	.i Flag'=0 d
	..i Info'="" s Info=Info_";"
	..s Info=Info_"( "_$P($G(^DHCEQMMaintPart(MMPRowID)),"^",19)_" )相关业务单已经打印处置.本次维修配件如需修改请与配件管理员联系."
	
	Quit Info
}

/// Mozy	20160615	检测业务单据是否已经打印出单据
/// 返回值	0:未打印	其它:DHC_EQOperateLog表ID 
/// w ##Class(web.DHCEQM.DHCEQMMaintPart).BussPrintInfo("A02","114")
ClassMethod BussPrintInfo(SourceType As %String = "", SourceID As %String = "")
{
	;检测单据有效性,无效单据设置未打印
	i SourceType="A01"
	{
		;配件入库单
		i '$d(^DHCEQAInStock(SourceID)) q 0
		i $P($G(^DHCEQAInStock(SourceID)),"^",16)=3 q 0
	}
	i SourceType="A02"
	{
		;配件转移单
		i '$d(^DHCEQAMoveStock(SourceID)) q 0
		i $P($G(^DHCEQAMoveStock(SourceID)),"^",28)=3 q 0
	}
	
	; ^DHCEQOperateLog(0,"Source",1,"A02",123,14270) = ""
	q +$o(^DHCEQOperateLog(0,"Source",1,SourceType,+SourceID,""))
}

/// MZY0039	1416082		2020-7-20
/// 维修配件记录数
/// w ##Class(web.DHCEQM.DHCEQMMaintPart).GetMaintPartNum()
ClassMethod GetMaintPartNum()
{
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Quit +$g(^TempDHCEQ("MaintPartNum",+$H,User)) //modify by zyq 2023-04-23
}

}
