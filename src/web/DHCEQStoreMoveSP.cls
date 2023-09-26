/// ----------------------------------------------
/// Modified by JDL 2009-06-5  JDL0014
/// Modified method GetList
/// 增加返回供应商
/// ---------------------------------------------
Class web.DHCEQStoreMoveSP Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 16;

/// w ##Class(web.DHCEQStoreMoveSP).GetPath()
ClassMethod GetPath(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	
	&sql(select pathtoreports into :path from websys.configuration)
	//i (path'="")&&(##class(web.DHCEQCommon).GetSysInfo("990069")=1) s path= "https://"_$p(path,"//",2)	;Mozy	2019-5-29	增加系统参数处理
	q path
}

/// modified by ZY20230228 bug:3295367
/// modified by ZY0215 2020-04-02
/// 修改取值,增加品牌输出
/// w ##Class(web.DHCEQStoreMoveSP).GetList(3)
ClassMethod GetList(rowid As %Library.String = "")
{
 i rowid'="" s StoreLoc=$p($g(^DHCEQStoreMove(rowid)),"^",2)
	s Data=""
	s Num=0
	s Rowid=0
	//modified by zy 0111
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	s (sumFee,sumQty)=0
	if rowid'=""
	{
	f  s Rowid=$o(^DHCEQStoreMoveList(0,"StoreMove",rowid,Rowid))  quit:Rowid=""  d
	.s (TTotalFee,TStockStatus,TStock,TRowID,TStoreMoveDR,TEquipDR,TBatchFlag,TInStockListDR,TEquipName,TManuFactoryDR,TOriginalFee,TQuantityNum,TModelDR,TUnitDR,TRemark,TStoreMove,TEquip,TInStockList,TManuFactory,TModel,TUnit,TMoveNum)=""
	.s TRowID = Rowid
	.s TStoreMoveDR = rowid
	.s TEquipDR = $p($g(^DHCEQStoreMoveList(Rowid)),"^",2)
	.i TEquipDR '=""  d
	..s TStockStatus=$p($g(^DHCEQEquip(TEquipDR)),"^",60)
	..s TStockStatus=$Case(TStockStatus,"0":"新增","1":"入库","2":"转移出库","3":"出库",:"")
	..s TStock=$p($g(^DHCEQEquip(TEquipDR)),"^",67)
	..s TStock=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStock)
	..s OCLRowID=$p($g(^DHCEQEquip(TEquipDR)),"^",77)
	..i OCLRowID'="" d
	...s OCRRowID=$P(^DHCEQOpenCheckList(OCLRowID),"^",1)
	.e  d
	..s TEquipDR=+$G(^DHCEQStoreMoveList(Rowid,"EX","RowIDs"))
	.s TBatchFlag = $p($g(^DHCEQStoreMoveList(Rowid)),"^",3)
	.s TInStockListDR = $p($g(^DHCEQStoreMoveList(Rowid)),"^",4)
	.i TInStockListDR'="" d
	..s ISLSourceType=$p($g(^DHCEQInStockList(TInStockListDR)),"^",18)
	..s ISLSourceID=$p($g(^DHCEQInStockList(TInStockListDR)),"^",19)
	..i ISLSourceType=2  d
	...s OCLRowID=ISLSourceID
	...s OCRRowID=$P(^DHCEQOpenCheckList(OCLRowID),"^",1)
	.
	.//i (TInStockListDR '="")&&(TBatchFlag="Y")  d
	..//s TMoveNum=##class(web.DHCEQStoreMove).GetTotalMoveQuantity(StoreLoc,TInStockListDR)
	.s TEquip = $p($g(^DHCEQStoreMoveList(Rowid)),"^",5)
	.s TManuFactoryDR = $p($g(^DHCEQStoreMoveList(Rowid)),"^",6)
	.//modified by ZY0215 2020-04-02
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	.s TOriginalFee = $p($g(^DHCEQStoreMoveList(Rowid)),"^",7)
	.s TQuantityNum = $p($g(^DHCEQStoreMoveList(Rowid)),"^",8)
	.s TTotalFee=TOriginalFee*TQuantityNum
	.s TModelDR = $p($g(^DHCEQStoreMoveList(Rowid)),"^",9)
	.///modified by ZY0215 2020-04-02
	.s TModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.s TUnitDR = $p($g(^DHCEQStoreMoveList(Rowid)),"^",10)
	.s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TRemark = $p($g(^DHCEQStoreMoveList(Rowid)),"^",11)
	.i TRemark="" s TRemark = $p($g(^DHCEQStoreMove(rowid)),"^",14)
	.s TLocation = ##Class(web.DHCEQCommon).GetTrakNameByID("location", $p($g(^DHCEQStoreMoveList(Rowid)),"^",12))	// MZY0115	2495298		2022-03-10
	.s TProvider=""
	.s EquipNo=""
	.s ContractNo=""
	.s TBrand=""
	.// MZY0115	2495298		2022-03-10
	.s OCRNo=""
	.s OpenCheckDate=""
	.s CheckDate=""
	.s BuyType=""
	.i TEquipDR'=""  d
	..s EquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	..s ContractNo=##class(web.DHCEQEquip).GetContractNo(TEquipDR)
	..s TInStockListDR=$p($g(^DHCEQEquip(TEquipDR)),"^",70)
	..s TProvider=$p($g(^DHCEQEquip(TEquipDR)),"^",25)
	..s TBrand=$p($g(^DHCEQEquip(TEquipDR)),"^",94)
	..s TBrand = ##Class(web.DHCEQCommon).GetTrakNameByID("brand",TBrand)
	..// MZY0115	2495298		2022-03-10
	..s OpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(TEquipDR)),"^",12),"date")
	..s CheckDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(TEquipDR)),"^",13),"date")
	..s EQOpenCheckListDR=$p($g(^DHCEQEquip(TEquipDR)),"^",77)
	..i EQOpenCheckListDR'="" s OCRNo=$p($g(^DHCEQOpenCheckRequest($p($g(^DHCEQOpenCheckList(EQOpenCheckListDR)),"^",1))),"^",37)
	..s BuyType=##Class(web.DHCEQCommon).GetTrakNameByID("buytype", $p($g(^DHCEQOpenCheckList(EQOpenCheckListDR)),"^",13))
	.s sumFee=sumFee+TTotalFee
	.s sumQty=sumQty+TQuantityNum
	.s InDate=""
	.i TInStockListDR'=""  d
	..s InDate=##Class(web.DHCEQInStockList).GetInStockDate(TInStockListDR, 0)
	..//add by jdl 2009-06-05  JDL0014
	..i TProvider=""  d
	...s TInStockDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	...s TProvider=$p($g(^DHCEQInStock(TInStockDR)),"^",17)
	.i TProvider'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	.
	.//add by jdl 2010-4-21
	.s TNos=##Class(web.DHCEQStoreMoveSP).GetEquipNos(0,TRowID)
	.// MZY0115	2495298		2022-03-10
	.i TNos="" d
	..If $Piece(^DHCEQStoreMoveList(Rowid),"^",3)="Y" Do
	...Set equipRowIDs=$Get(^DHCEQStoreMoveList(Rowid,"EX","RowIDs"))
	..Else  Do
	...Set equipRowIDs=$Piece(^DHCEQStoreMoveList(Rowid),"^",2)
	..
	..Set count=$length(equipRowIDs,",")
	..For i=1:1:count Do
	...Set EQDR=$Piece(equipRowIDs,",",i)
	...If EQDR'=""  Do
	....If TNos'="" Set TNos=TNos_","
	....Set TNos=TNos_$Piece($Get(^DHCEQEquip(EQDR)),"^",71)
	..
	..Set TNos=##Class(web.DHCEQCommon).NoToGroupNo(TNos)
	.s TOCRSubmitUser=""
	.i OCRRowID'="" d
	..s ALRowID=0
	..f  s ALRowID=$O(^DHCEQApproveList(0,"Source",7,OCRRowID,ALRowID)) q:(ALRowID="")||(TOCRSubmitUser'="")  d
	...Q:$p($g(^DHCEQApproveList(ALRowID)),"^",9)'=0
	...Q:$p($g(^DHCEQApproveList(ALRowID)),"^",10)'="N"
	...Q:$p($g(^DHCEQApproveList(ALRowID)),"^",11)'=0
	...Q:$p($g(^DHCEQApproveList(ALRowID)),"^",12)'=0
	...s TOCRSubmitUser=$P(^DHCEQApproveList(ALRowID),"^",6)
	.s TOCRSubmitUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TOCRSubmitUser)
	.
	.//              éè±???3?      éú2ú3§éì          ?úDí        μ￥??       êyá?              ?-?μ             ±?×￠
	.s Data=Data_SplitRowCode_TEquip_"^"_TManuFactory_"^"_TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TRemark_"^"_TTotalFee_"^"_EquipNo_"^"_ContractNo_"^"_InDate_"^"_TProvider_"^"_TNos_"^"_TBrand_"^"_TLocation_"^"_OCRNo_"^"_OpenCheckDate_"^"_CheckDate_"^"_BuyType_"^"_TOCRSubmitUser	// MZY0115	2495298		2022-03-10
	.s Num=Num+1
	}
	i Data'=""  d
	.s Data=Data_SplitRowCode_"合计"_"^"_"^"_"^"_"^"_sumQty_"^"_"^"_"^"_sumFee_"^"_"^"_"^"_"^"_"^"
	.s Num=Num+1
	//modified by zy 0111
	q Data_SplitNumCode_Num
}

/// add by jdl 2010-4-21
/// 根据传入的单据明细id，获取相关的设备的编号信息
/// SourceType:0,转移明细 1:入库明细 2：退货明细
/// SourceID：对应的ID
/// w ##Class(web.DHCEQStoreMoveSP).GetEquipNos(0,4)
ClassMethod GetEquipNos(SourceType As %Library.String, SourceID As %Library.String, NoType As %String = "EQNo") As %Status
{
	n (SourceType,SourceID,NoType)
	s EquipNos=""
	s LeaveFacNos=""
	s FileNos=""
	s SortNo=0
	i SourceType="0"
	{
		s EquipDR=$p($g(^DHCEQStoreMoveList(SourceID)),"^",2)
		i EquipDR'=""  d
		.s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
		.s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
		.s FileNo=$p($g(^DHCEQEquip(EquipDR)),"^",85)
		.s SortNo=1
		.s EquipNos=EquipNo
		.s LeaveFacNos=LeavefactoryNo
		.s FileNos=FileNo
	 	e  d
	 	.s rowid=0
	 	.f  s rowid=$o(^DHCEQChangeStock(0,"Source",1,SourceID,rowid)) q:rowid=""  d
	 	..s EquipDR=$p($g(^DHCEQChangeStock(rowid)),"^",1)
	 	..s (EquipNo,LeavefactoryNo,FileNo)=""
	 	..i EquipDR'=""  d
	 	...s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	 	...s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
		...s FileNo=$p($g(^DHCEQEquip(EquipDR)),"^",85)
	 	...s SortNo=SortNo+1
	 	...i EquipNos'="" s EquipNos=EquipNos_","
	 	...s EquipNos=EquipNos_EquipNo            //modify by jyp 2017-11-20 JYP0007
	 	...i LeaveFacNos'="" s LeaveFacNos=LeavefactoryNo_","
	 	...s LeaveFacNos=LeaveFacNos_LeavefactoryNo
	 	...i FileNos'="" s FileNos=FileNos_","
	 	...s FileNos=FileNos_FileNo
	 	
	 }
	 elseif SourceType="1"
	 {
		 s IStoreLocDR=0
		 f  s IStoreLocDR=$o(^DHCEQEquip(0,"InStockList",SourceID,IStoreLocDR))  q:(IStoreLocDR="")  d
		 .s EquipDR=0
		 .f  s EquipDR=$o(^DHCEQEquip(0,"InStockList",SourceID,IStoreLocDR,EquipDR)) q:(EquipDR="")  d
		 ..s (EquipNo,LeavefactoryNo,FileNo)=""
		 ..s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
		 ..s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
		 ..s FileNo=$p($g(^DHCEQEquip(EquipDR)),"^",85)
		 ..i EquipNos'="" s EquipNos=EquipNos_","
	 	 ..s EquipNos=EquipNos_EquipNo 
	 	 ..i LeaveFacNos'="" s LeaveFacNos=LeavefactoryNo_","
	 	 ..s LeaveFacNos=LeaveFacNos_LeavefactoryNo
	 	 ..i FileNos'="" s FileNos=FileNos_","
	 	 ..s FileNos=FileNos_FileNo
	 	 ..s SortNo=SortNo+1
	 }
	 elseif SourceType="2"
	 {
		 s EquipRowIDs=$g(^DHCEQReturnList(SourceID,"EX","RowIDs"))
		 s EQIDLen=$l(EquipRowIDs,",")
		 f i=1:1:EQIDLen d
		 .s EquipDR=$p(EquipRowIDs,",",i)
		 .s (EquipNo,LeavefactoryNo,FileNo)=""
		 .s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
		 .s LeavefactoryNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
		 .s FileNo=$p($g(^DHCEQEquip(EquipDR)),"^",85)
		 .i EquipNos'="" s EquipNos=EquipNos_","
	 	 .s EquipNos=EquipNos_EquipNo 
	 	 .i LeaveFacNos'="" s LeaveFacNos=LeavefactoryNo_","
	 	 .s LeaveFacNos=LeaveFacNos_LeavefactoryNo
	 	 .i FileNos'="" s FileNos=FileNos_","
	 	 .s FileNos=FileNos_FileNo
	 	 .s SortNo=SortNo+1
	 }
	 i NoType="LeaveNo"  q LeaveFacNos
	 i NoType="FileNo" q FileNos
	 q ##Class(web.DHCEQCommon).NoToGroupNo(EquipNos)		//czf 2022-05-22
}

}
