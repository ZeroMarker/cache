/// 名称: web.DHCEQ.Plat.LIBBusinessModify
/// 描述: 资产单据信息修改
/// 编写者：ZX
/// 编写日期: 2019-08-29
/// 产品组：设备管理
Class web.DHCEQ.Plat.LIBBusinessModify Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      ZX
/// CreatDate：    2019-08-29
/// Description:   获取业务主单信息
/// Input：        BussType:业务类型代码 BussNo:业务单单号
/// Return：       表数据解析 json返回
/// w ##Class(web.DHCEQ.Plat.LIBBusinessModify).GetBusinessMain("11","YS2020090003")
/// modified by czf 2020-08-16 增加BussID
ClassMethod GetBusinessMain(BussType As %Library.String = "", BussNo As %Library.String = "", BussID As %Library.String = "", DCRRowID As %Library.String = "")
{
	i (BussType="")||((BussNo="")&&(BussID="")) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
	if BussType="21"
	{
		i BussID="" s BussID=$o(^DHCEQInStock(0,"InStockNo",BussNo,""))
		i BussID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
		s InStockInfo=##Class(web.DHCEQ.EM.BUSInStock).GetOneInStock(BussID,"")
		s InStockInfo=##class(web.DHCEQ.Plat.JsonObject).FromJSON(InStockInfo)	//CZF0131 2020-01-20
		i InStockInfo.%Get("SQLCODE")=0 s InStockInfo=InStockInfo.%Get("Data")
		d InStockInfo.%Set("BussID",BussID)
		s Find=0	//add by czf begin 2020-08-18
		i (DCRRowID="")
		{
			s (DCRID,DCRStatus)=""
			f  s DCRID=$o(^DHCEQDataChangeRequest(0,"TableName","DHC_EQInStock",BussID,DCRID)) q:(DCRID="")||(Find=1)  d
			.q:$p($g(^DHCEQDataChangeRequest(DCRID)),"^",14)="Y"
			.q:$p($g(^DHCEQDataChangeRequest(DCRID)),"^",13)="2"
			.s Find=1
			.s DCRRowID=DCRID
			.s DCRStatus=$p($g(^DHCEQDataChangeRequest(DCRID)),"^",13)
			d InStockInfo.%Set("DCRRowID",DCRRowID)
			d InStockInfo.%Set("DCRStatus",DCRStatus)	//add by czf end 2020-08-18
		}
		q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,InStockInfo)
	}
	elseif BussType="11"
	{
		s BussNo=" "_BussNo
		i BussID="" s BussID=$o(^DHCEQOpenCheckRequest(0,"RequestNo",BussNo,""))
		i BussID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
		s OpenCheckInfo=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetOneOpenCheckRequest(BussID,"")
		s OpenCheckInfo=##class(web.DHCEQ.Plat.JsonObject).FromJSON(OpenCheckInfo)	//CZF0131 2020-01-20
		i OpenCheckInfo.%Get("SQLCODE")=0 s OpenCheckInfo=OpenCheckInfo.%Get("Data")
		d OpenCheckInfo.%Set("BussID",BussID)
		s OCLID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",BussID,""))
		i OCLID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
		s OpenCheckList=##Class(web.DHCEQ.EM.BUSOpenCheckRequest).GetOneOpenCheckList(OCLID)
		s OpenCheckList=##class(web.DHCEQ.Plat.JsonObject).FromJSON(OpenCheckList)	//CZF0131 2020-01-20
		i OpenCheckList.%Get("SQLCODE")=0 s OpenCheckList=OpenCheckList.%Get("Data")
		d OpenCheckInfo.%Set("OpenCheckList",OpenCheckList)
		d OpenCheckInfo.%Set("OCLRowID",OCLID)
		s Amount=$p($g(^DHCEQOpenCheckList(OCLID)),"^",16)*$p($g(^DHCEQOpenCheckList(OCLID)),"^",17)
		s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
		s datachangeflag=""		;czf 2021-06-11 1983205 begin
		i $o(^DHCEQTempFunds(0,"Source","0",OCLID,0))'="" s datachangeflag="Y"
		s SelfFundsInfo=##Class(web.DHCEQ.EM.BUSFunds).GetSourceFunds(0,OCLID,Amount,SelfFundsType,"1",datachangeflag)
		s OtherFundInfo=##Class(web.DHCEQ.EM.BUSFunds).GetSourceFunds(0,OCLID,Amount,"","1",datachangeflag)	;czf 2021-06-11 1983205 end
		d OpenCheckInfo.%Set("SelfFunds",##Class(web.DHCEQCommon).FormatNumber($p(SelfFundsInfo,"^",1),"",2))
		d OpenCheckInfo.%Set("OtherFunds",##Class(web.DHCEQCommon).FormatNumber(Amount-$p(SelfFundsInfo,"^",1),"",2))		//czf 2020-12-16 1618144
		s SelfFundsInfo=##class(web.DHCEQCommon).Replace(SelfFundsInfo,"^","#")	;czf 2021-02-04
		s OtherFundInfo=##class(web.DHCEQCommon).Replace(OtherFundInfo,"^","#")
		d OpenCheckInfo.%Set("SelfFundsInfo",SelfFundsInfo)	
		d OpenCheckInfo.%Set("OtherFundInfo",OtherFundInfo)
		s Find=0
		i (DCRRowID="")
		{
			s (DCRID,DCRStatus)=""
			f  s DCRID=$o(^DHCEQDataChangeRequest(0,"TableName","DHC_EQOpenCheckRequest",BussID,DCRID)) q:(DCRID="")||(Find=1)  d
			.q:$p($g(^DHCEQDataChangeRequest(DCRID)),"^",14)="Y"
			.q:$p($g(^DHCEQDataChangeRequest(DCRID)),"^",13)="2"
			.s Find=1
			.s DCRRowID=DCRID
			.s DCRStatus=$p($g(^DHCEQDataChangeRequest(DCRID)),"^",13)
			d OpenCheckInfo.%Set("DCRRowID",DCRRowID)
			d OpenCheckInfo.%Set("DCRStatus",DCRStatus)	//add by czf end 2020-08-18
		}
		q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,OpenCheckInfo)
	}
	///add by ZY0252 20210301
	elseif BussType="94"
	{
		i BussID="" s BussID=$o(^DHCEQContract(0,"ContractNo",BussNo,""))
		i BussID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
		s ContractInfo=##Class(web.DHCEQ.Con.BUSContract).GetOneContractNew(BussID,"")
		s ContractInfo=##class(web.DHCEQ.Plat.JsonObject).FromJSON(ContractInfo)	//CZF0131 2020-01-20
		i ContractInfo.%Get("SQLCODE")=0 s ContractInfo=ContractInfo.%Get("Data")
		d ContractInfo.%Set("BussID",BussID)
		s Find=0	//add by czf begin 2020-08-18
		i (DCRRowID="")
		{
			s (DCRID,DCRStatus)=""
			f  s DCRID=$o(^DHCEQDataChangeRequest(0,"TableName","DHC_EQContract",BussID,DCRID)) q:(DCRID="")||(Find=1)  d
			.q:$p($g(^DHCEQDataChangeRequest(DCRID)),"^",14)="Y"
			.q:$p($g(^DHCEQDataChangeRequest(DCRID)),"^",13)="2"
			.s Find=1
			.s DCRRowID=DCRID
			.s DCRStatus=$p($g(^DHCEQDataChangeRequest(DCRID)),"^",13)
			d ContractInfo.%Set("DCRRowID",DCRRowID)
			d ContractInfo.%Set("DCRStatus",DCRStatus)	//add by czf end 2020-08-18
		}
		q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,ContractInfo)
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
}

/// Creator：      ZX
/// CreatDate：    2019-08-29
/// Description:   获取入库明细
/// Input：        InStockNo:入库单号
/// modify by wl 2020-02-19 WL0052 增加输出THold5
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBBusinessModify","GetInStockList","RK2020090002")
Query GetInStockList(InStockNo) As %Query(ROWSPEC = "TStatCat:%String,TItemDR:%String,TInvoiceNos:%String,TInvoiceDate:%String,TInvoiceFee:%String,TRowID:%String,TInStockDR:%String,TEquipName:%String,TOriginalFee:%String,TQuantityNum:%String,TTotal:%String,THold1:%String,TRemark:%String,TAppendFee:%String,TLimitYearsNum:%String,TManuFactory:%String,TModel:%String,TUnit:%String,TEquipCat:%String,THold5:%String,TDCRRowID:%String,TDCRStatus:%String")
{
}

ClassMethod GetInStockListExecute(ByRef qHandle As %Binary, InStockNo) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	d BuildDataGetInStockList
	Quit $$$OK
BuildDataGetInStockList
	q:InStockNo=""
	s InStockDR=$o(^DHCEQInStock(0,"InStockNo",InStockNo,""))
	q:InStockDR=""
	f  s rowid=$o(^DHCEQInStockList(0,"InStock",InStockDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetInStockList
	.s TRowID = rowid
	.s TInStockDR = $p($g(^DHCEQInStockList(rowid)),"^",1)
	.s TEquipName = $p($g(^DHCEQInStockList(rowid)),"^",5)
	.s TManuFactoryDR = $p($g(^DHCEQInStockList(rowid)),"^",6)
	.i TManuFactoryDR '=""  d
	..s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//modified by CZF103 20200408
	.s TOriginalFee = $p($g(^DHCEQInStockList(rowid)),"^",7)
	.s TQuantityNum = $p($g(^DHCEQInStockList(rowid)),"^",8)
	.s TTotal=TOriginalFee*TQuantityNum
	.s TModelDR = $p($g(^DHCEQInStockList(rowid)),"^",9)
	.i TModelDR '=""  d
	..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TUnitDR = $p($g(^DHCEQInStockList(rowid)),"^",10)
	.i TUnitDR '=""  d
	..s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",(TUnitDR))
	.s THold1 = $p($g(^DHCEQInStockList(rowid)),"^",11)
	.s TRemark = $p($g(^DHCEQInStockList(rowid)),"^",12)
	.s TAppendFee = $p($g(^DHCEQInStockList(rowid)),"^",13)
	.s TEquipCatDR = $p($g(^DHCEQInStockList(rowid)),"^",14)
	.i TEquipCatDR '=""  d
	..s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	.s TLimitYearsNum = $p($g(^DHCEQInStockList(rowid)),"^",15)
	.s TItemDR=$p($g(^DHCEQInStockList(rowid)),"^",16)
	.
	.s TStatCatDR=$p($g(^DHCEQInStockList(rowid)),"^",17)
	.s TSourceType=$p($g(^DHCEQInStockList(rowid)),"^",18)
	.s TSourceID=$p($g(^DHCEQInStockList(rowid)),"^",19)
	.s THold2=$p($g(^DHCEQInStockList(rowid)),"^",20)
	.s THold3=$p($g(^DHCEQInStockList(rowid)),"^",21)
	.s THold4=$p($g(^DHCEQInStockList(rowid)),"^",22)
	.s THold5=$p($g(^DHCEQInStockList(rowid)),"^",23)
	.i THold5'="" s THold5=$p($g(^DHCEQCCode("DHCEQCExpenditures",THold5)),"^",2)
	.i TStatCatDR'="" d
	..s TStatCat=$P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	.s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,rowid)
	.s TInvoiceNos=$p(return,"^",1)
	.s TInvoiceDate=$p(return,"^",2)
	.s TInvoiceFee=$p(return,"^",3)
	.s Find=0		//add by czf 2020-08-18 begin
	.s DCRID=""
	.f  s DCRID=$o(^DHCEQDataChangeRequest(0,"TableName","DHC_EQInStockList",rowid,DCRID)) q:(DCRID="")||(Find=1)  d
	..q:$p($g(^DHCEQDataChangeRequest(DCRID)),"^",14)="Y"
	..q:$p($g(^DHCEQDataChangeRequest(DCRID)),"^",13)="2"
	..s Find=1
	..s TDCRRowID=DCRID
	..s TDCRStatus=$p($g(^DHCEQDataChangeRequest(DCRID)),"^",13)	//add by czf 2020-08-18 end
	.d OutputRowGetInStockList
		
	quit
OutputRowGetInStockList
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	i TAppendFee'="" s TAppendFee=##Class(web.DHCEQCommon).FormatNumber(TAppendFee,"",2)
	i TTotal'="" s TTotal=##Class(web.DHCEQCommon).FormatNumber(TTotal,"",2)
	
	// modify by wl 2020-02-19 WL0052 增加输出THold5
	s Data=$lb(TStatCat,TItemDR,TInvoiceNos,TInvoiceDate,TInvoiceFee,TRowID,TInStockDR,TEquipName,TOriginalFee,TQuantityNum,TTotal,THold1,TRemark,TAppendFee,TLimitYearsNum,TManuFactory,TModel,TUnit,TEquipCat,THold5,TDCRRowID,TDCRStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockList
	s (TStatCatDR,TStatCat,TItemDR,TInvoiceNos,TInvoiceDate,TInvoiceFee,TRowID,TInStockDR,TBatchFlag,TEquipName,TManuFactoryDR,TOriginalFee,TQuantityNum,TTotal,TModelDR,TUnitDR,THold1,TRemark,TAppendFee,TEquipCatDR,TLimitYearsNum,TManuFactory,TModel,TUnit,TEquipCat,TDCRRowID,TDCRStatus)=""
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

/// Creator：      ZX
/// CreatDate：    2019-08-29
/// Description:   获取入库单明细信息
/// Input：        ListID:入库单明细RowID
/// Return：       表数据解析 json返回
/// w ##Class(web.DHCEQ.Plat.LIBBusinessModify).GetOneInStockList("")
ClassMethod GetOneInStockList(ListID As %Library.String = "")
{
	s $ZT="ERRORGetOneInStockList"
	s ObjInStockList=##Class(User.DHCEQInStockList).%OpenId(ListID)
	s InStockListInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjInStockList)
	d InStockListInfo.%Set("ISLManuFactoryDR_MFName",ObjInStockList.ISLManuFactoryDR.VName)		//modified by CZF0103 20200408
	d InStockListInfo.%Set("ISLModelDR_MDesc",ObjInStockList.ISLModelDR.MDesc)
	d InStockListInfo.%Set("ISLUnitDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",ObjInStockList.ISLUnitDR))
	d InStockListInfo.%Set("ISLEquipCatDR_ECDesc",ObjInStockList.ISLEquipCatDR.ECDesc)
	d InStockListInfo.%Set("ISLStatCatDR_SCDesc",ObjInStockList.ISLStatCatDR.SCDesc)
	i InStockListInfo.ISLHold5'="" d InStockListInfo.%Set("ISLHold5_EDesc",$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",InStockListInfo.ISLHold5)),"^",2))
	s InvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,ListID)
	s TInvoiceNos=$p(InvoiceInfo,"^",1)
	d InStockListInfo.%Set("ISLInvoiceNos",TInvoiceNos)
	//类组用于类型下拉框
	s EquipTypeDR=$p($g(^DHCEQInStock(InStockListInfo.ISLInStockDR)),"^",20)
	d InStockListInfo.%Set("ISEquipTypeDR",EquipTypeDR)
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,InStockListInfo)
ERRORGetOneInStockList
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// Creator：      ZX
/// CreatDate：    2019-08-29
/// Description:   修改业务单信息入口方法
/// Input：        BussType:相关业务类型 BussID:相关业务表ID FieldName:需修表字段 Value:新值 MainFlag:是否是主表
/// Return：       表数据解析 json返回
/// w ##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateBusinessByType("")
ClassMethod UpdateBusinessByType(BussType As %Library.String = "", BussID As %Library.String = "", FieldName As %Library.String = "", Value As %Library.String = "", MainFlag As %Library.String = "", DealTypes As %Library.String = "")
{
	s SQLCODE=0
	i BussID="" q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200","入库单"_FieldName_"字段信息来源不能为空")   //add by wy 2019-12-6 需求1122024 BussID为空时不能更新字段信息
	if BussType="21" 
	{
		//Add By DJ 2019-11-06 begin
		i MainFlag="Y"  d
		.s ISStatus=$p($g(^DHCEQInStock(BussID)),"^",10)
		.s ISAuditDate=$p($g(^DHCEQInStock(BussID)),"^",13)
		.s ISLRowID=$o(^DHCEQInStockList(0,"InStock",BussID,0))
		e  d
		.s ISRowID=$p($g(^DHCEQInStockList(BussID)),"^",1)
		.s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
		.s ISAuditDate=$p($g(^DHCEQInStock(ISRowID)),"^",13)
		.s ISLRowID=BussID
		//判断是否当月单据(新增,提交单据可直接修改。审核单据校验是否为当月单据)
		i ISStatus="2"
		{
			s CurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
			s BussMonth=##Class(web.DHCEQReport).GetReportMonthByDate(ISAuditDate)
			i CurMonth'=BussMonth q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200","非当月审核单据不能修改.")
			//判断是否已入账(已入账不允许修改,未入账则可修改)
			s Flag=0
			s AccountListID=0
			f  s AccountListID=$o(^DHCEQAccountList(0,"InStockList",ISLRowID,AccountListID))  q:(AccountListID="")||(Flag=1)  d
			.q:$p($g(^DHCEQAccountList(AccountListID)),"^",10)="Y"
			.s Flag=1
			
			i Flag=1 q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200","已入账单据不能修改.")
		}
		//Add By DJ 2019-11-06 end
		s SQLCODE=##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateInStockBusiness(BussID,FieldName,Value,MainFlag,DealTypes)
	}
	if BussType="11"
	{
		
	}
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,SQLCODE)
}

/// Creator：      ZX
/// CreatDate：    2019-08-29
/// Description:   通过入库修改相关业务单据信息
/// Input：        BussID:入库表相关ID FieldName:需修改入库表字段 Value:新值 MainFlag:是否是主表
/// Return：       SQLCoDE:修改表数据后SQLCODE
/// w ##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateBusinessByType("")
ClassMethod UpdateInStockBusiness(BussID As %Library.String = "", FieldName As %Library.String = "", Value As %Library.String = "", MainFlag As %Library.String = "", DealTypes As %Library.String = "")
{
	;需要调整验收单时,源头从验收单开始处理
	s SQLCODE=0
	if MainFlag="Y"
	{
		s OldObject=##Class(User.DHCEQInStock).%OpenId(BussID)
		s NewObject=OldObject
		
		if FieldName="ISBuyLocDR"
		{
			;采购部门
			&SQL(Update SQLUSER.DHC_EQInStock Set IS_BuyLocDR=:Value where IS_RowID = :BussID)
			i SQLCODE q SQLCODE
			s NewObject.ISBuyLocDR=Value
			d SaveUpdateLog
		}
		elseif FieldName="ISBuyUserDR"
		{
			;采购人
			&SQL(Update SQLUSER.DHC_EQInStock Set IS_BuyUserDR=:Value where IS_RowID = :BussID)
			i SQLCODE q SQLCODE
			s NewObject.ISBuyUserDR=Value
			d SaveUpdateLog
		}
		elseif FieldName="ISInDate"
		{
			;制单日期
			s Value=##Class(web.DHCEQCommon).TransValueFromPage(Value,"date")
			&SQL(Update SQLUSER.DHC_EQInStock Set IS_InDate=:Value where IS_RowID = :BussID)
			i SQLCODE q SQLCODE
			s NewObject.ISInDate=Value
			d SaveUpdateLog
		}
		else
		{
			if FieldName="ISEquipTypeDR"
			{
				s NewObject.ISEquipTypeDR=##Class(User.DHCEQCEquipType).%OpenId(Value)
			}
			elseif FieldName="ISProviderDR"
			{
				s NewObject.ISProviderDR=##Class(User.DHCEQCVendor).%OpenId(Value)
			}
			elseif FieldName="ISOriginDR"
			{
				s NewObject.ISOriginDR=##Class(User.DHCEQCOrigin).%OpenId(Value)
			}
			d SaveUpdateLog
			s BussListID=0
			f  s BussListID=$o(^DHCEQInStockList(0,"InStock",BussID,BussListID)) q:(BussListID="")||(SQLCODE'=0)  d
			.d DoUpdateBySource
			.q:SQLCODE'=0
		}
	}
	else
	{
		s OldObject=##Class(User.DHCEQInStockList).%OpenId(BussID)
		s OldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject).%ToJSON()
		if FieldName="ISLRemark"
		{
			;备注
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_Remark=:Value where ISL_RowID = :BussID)
			i SQLCODE q SQLCODE
			s NewObject=OldObject
			s NewObject.ISLRemark=Value
			d SaveUpdateLogList
		}
		elseif FieldName="ISLInvoiceNos"
		{
			;发票号
			s OldObjectInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(OldObject)
			s InvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,BussID)
			s TInvoiceNos=$p(InvoiceInfo,"^",1)
			s TInvoiceDate=$p(InvoiceInfo,"^",2) 	//add by csj 2020-04-29 需求号：1296911
			s TInvoiceFee=$p(InvoiceInfo,"^",3)	//add by csj 2020-04-29 需求号：1296911
			d OldObjectInfo.%Set("InvoiceNos",TInvoiceNos)
			s OldValue=OldObjectInfo.%ToJSON()
			s SQLCODE=##Class(web.DHCEQ.EM.BUSInStock).UpdateInvoiceInfo(BussID, Value, TInvoiceDate, TInvoiceFee)	//modified by csj 2020-04-29 需求号：1296911
			i SQLCODE q SQLCODE
			d OldObjectInfo.%Set("InvoiceNos",Value)
			s NewValue=OldObjectInfo.%ToJSON()
			d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_EQInStockList","User.DHCEQInStockList", "资产入库明细",BussID,"入库明细","U",NewValue,OldValue)
		}
		else
		{
			s BussListID=BussID
			d DoUpdateBySource
			i SQLCODE q SQLCODE
			s NewObject=OldObject
			if FieldName="ISLEquipName"
			{
				s NewObject.ISLEquipName=Value
			}
			elseif FieldName="ISLModelDR"
			{
				s NewObject.ISLModelDR=##Class(User.DHCEQCModel).%OpenId(Value)
			}
			elseif FieldName="ISLUnitDR"
			{
				s NewObject.ISLUnitDR=Value
			}
			elseif FieldName="ISLOriginalFee"
			{
				s NewObject.ISLOriginalFee=Value
			}
			elseif FieldName="ISLManuFactoryDR"
			{
				//s NewObject.ISLManuFactoryDR=##Class(User.DHCEQCManufacturer).%OpenId(Value)
				s NewObject.ISLManuFactoryDR=##Class(User.DHCEQCVendor).%OpenId(Value)	//modified by CZF103 20200408
			}
			elseif FieldName="ISLStatCatDR"
			{
				s NewObject.ISLStatCatDR=##Class(User.DHCEQCStatCat).%OpenId(Value)
			}
			elseif FieldName="ISLEquipCatDR"
			{
				s NewObject.ISLEquipCatDR=##Class(User.DHCEQCEquipeCat).%OpenId(Value)
			}
			elseif FieldName="ISLLimitYearsNum"
			{
				s NewObject.ISLLimitYearsNum=Value
			}
			elseif FieldName="ISLHold5"
			{
				s NewObject.ISLHold5=Value
			}
			d SaveUpdateLogList
		}
	}
	q SQLCODE
	
SaveUpdateLog
	;更新主单记录----------------
	s OldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject).%ToJSON()
	s NewValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(NewObject).%ToJSON()
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_EQInStock","User.DHCEQInStock", "资产入库单",BussID,"入库单","U",NewValue,OldValue)
	quit
	
SaveUpdateLogList
	;更新明细记录----------------
	s NewValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(NewObject).%ToJSON()
	d ##class(web.DHCBL.BDP.BDPDataChangeLog).SaveLogForOther("DHC_EQInStockList","User.DHCEQInStockList", "资产入库明细",BussID,"入库明细","U",NewValue,OldValue)
	quit

DoUpdateBySource
	s SourceTypeID=$p($g(^DHCEQInStockList(BussListID)),"^",19)
	d GetOpenCheckFieldNameByInStock
	q:(SourceTypeID="")||(OpenCheckFieldName="")
	s SQLCODE=##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateOpenCheckBusiness(SourceTypeID,OpenCheckFieldName,Value,DealTypes)
	quit
GetOpenCheckFieldNameByInStock
	s OpenCheckFieldName=$CASE(FieldName,
              "ISEquipTypeDR":"OCLEquipTypeDR","ISProviderDR":"OCRProviderDR","ISOriginDR":"OCROriginDR","ISLEquipName":"OCLName",
              "ISLModelDR":"OCLModelDR","ISLUnitDR":"OCLUnitDR","ISLOriginalFee":"OCLOriginalFee","ISLManuFactoryDR":"OCLManuFactoryDR",
              "ISLStatCatDR":"OCLStatCatDR","ISLEquipCatDR":"OCLEquiCatDR","ISLLimitYearsNum":"OCLLimitYearsNum","ISLHold5":"OCLHold5")
	quit
}

/// Creator：      ZX
/// CreatDate：    2019-08-29
/// Description:   通过验收修改相关业务单据信息
/// Input：        BussID:验收明细DHC_EQOpenCheckList表ID FieldName:需修改验收表字段 Value:新值
/// Return：       表数据解析 json返回
/// w ##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateOpenCheckBusiness("6","OCLName","测试数据")
/// Modify By ZX 2019-10-22 调整事物回滚中SQLCODE返回方式及根据验收单修改台账时是否是附属设备的判断处理 ZX0070
ClassMethod UpdateOpenCheckBusiness(BussID As %Library.String = "", FieldName As %Library.String = "", Value As %Library.String = "", DealTypes As %Library.String = "")
{
	s $ZT="ERROROpenCheckBusiness"
	s OCRRowID=$p($g(^DHCEQOpenCheckList(BussID)),"^",1)
	//获取入库单id及入库明细单id
	s (ISLRowID,ISRowID)=""
	s CurISLRowID=0
	//验收来源类型为'2'
	f  s CurISLRowID=$o(^DHCEQInStockList(0,"Source","2",BussID,CurISLRowID)) q:(CurISLRowID="")||(ISRowID'="")  d
	.q:$p($g(^DHCEQInStockList(CurISLRowID)),"^",22)'="" //过滤掉附属设备
	.s CurISRowID=$p($g(^DHCEQInStockList(CurISLRowID)),"^",1)
	.q:$p($g(^DHCEQInStock(CurISRowID)),"^",25)'="N"
	.s ISRowID=CurISRowID
	.s ISLRowID=CurISLRowID
	//获取转移单id
	s StoreMoveIDs=##Class(web.DHCEQ.Plat.LIBBusinessModify).GetSMRowIDsByOCLRowID(BussID)
	
	TSTART
	if FieldName="OCLEquipTypeDR"
	{
		//设备类组
		&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_EquipTypeDR=:Value where OCL_RowID = :BussID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_EquipTypeDR=:Value where OCR_RowID = :OCRRowID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStock Set IS_EquipTypeDR=:Value where IS_RowID = :ISRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		i StoreMoveIDs'=""
		{
			s SMLen=$l(StoreMoveIDs,",")
			f i=1:1:SMLen q:SQLCODE'=0  d
			.s StoreMoveID=$p(StoreMoveIDs,",",i)
			.&SQL(Update SQLUSER.DHC_EQStoreMove Set SM_EquipTypeDR=:Value where SM_RowID = :StoreMoveID)
			.q:SQLCODE'=0
			
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
	}
	elseif(FieldName="OCRProviderDR")
	{
		//供货商
		&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_ProviderDR=:Value where OCR_RowID = :OCRRowID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStock Set IS_ProviderDR=:Value where IS_RowID = :ISRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_ProviderDR=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	elseif(FieldName="OCROriginDR")
	{
		//设备来源
		&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_OriginDR=:Value where OCR_RowID = :OCRRowID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStock Set IS_OriginDR=:Value where IS_RowID = :ISRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_OriginDR=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		
	}
	elseif(FieldName="OCLName")
	{
		//设备名称
		&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_Name=:Value where OCL_RowID = :BussID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISLRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_EquipName=:Value where ISL_RowID = :ISLRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_Name=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i StoreMoveIDs'=""
		{
			s SMLen=$l(StoreMoveIDs,",")
			f i=1:1:SMLen q:SQLCODE'=0  d
			.s StoreMoveID=$p(StoreMoveIDs,",",i)
			.s StoreMoveListID=0
			.f  s StoreMoveListID=$o(^DHCEQStoreMoveList(0,"StoreMove",StoreMoveID,StoreMoveListID)) q:(StoreMoveListID="")||(SQLCODE'=0)  d
			..q:$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",15)'="" //过滤掉附属设备
			..&SQL(Update SQLUSER.DHC_EQStoreMoveList Set SML_EquipName=:Value where SML_RowID = :StoreMoveListID)
			..q:SQLCODE'=0
			
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
	}
	elseif(FieldName="OCLModelDR")
	{
		//规格型号
		&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_ModelDR=:Value where OCL_RowID = :BussID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISLRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_ModelDR=:Value where ISL_RowID = :ISLRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_ModelDR=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i StoreMoveIDs'=""
		{
			s SMLen=$l(StoreMoveIDs,",")
			f i=1:1:SMLen q:SQLCODE'=0  d
			.s StoreMoveID=$p(StoreMoveIDs,",",i)
			.s StoreMoveListID=0
			.f  s StoreMoveListID=$o(^DHCEQStoreMoveList(0,"StoreMove",StoreMoveID,StoreMoveListID)) q:(StoreMoveListID="")||(SQLCODE'=0)  d
			..q:$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",15)'="" //过滤掉附属设备
			..&SQL(Update SQLUSER.DHC_EQStoreMoveList Set SML_ModelDR=:Value where SML_RowID = :StoreMoveListID)
			..q:SQLCODE'=0
			
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
	}
	elseif(FieldName="OCLUnitDR")
	{
		//单位
		&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_UnitDR=:Value where OCL_RowID = :BussID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISLRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_UnitDR=:Value where ISL_RowID = :ISLRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_UnitDR=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i StoreMoveIDs'=""
		{
			s SMLen=$l(StoreMoveIDs,",")
			f i=1:1:SMLen q:SQLCODE'=0  d
			.s StoreMoveID=$p(StoreMoveIDs,",",i)
			.s StoreMoveListID=0
			.f  s StoreMoveListID=$o(^DHCEQStoreMoveList(0,"StoreMove",StoreMoveID,StoreMoveListID)) q:(StoreMoveListID="")||(SQLCODE'=0)  d
			..q:$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",15)'="" //过滤掉附属设备
			..&SQL(Update SQLUSER.DHC_EQStoreMoveList Set SML_UnitDR=:Value where SML_RowID = :StoreMoveListID)
			..q:SQLCODE'=0
			
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
	}
	elseif(FieldName="OCLOriginalFee")
	{
		//原值
		&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_OriginalFee=:Value where OCL_RowID = :BussID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISLRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_OriginalFee=:Value where ISL_RowID = :ISLRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_OriginalFee=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i StoreMoveIDs'=""
		{
			s SMLen=$l(StoreMoveIDs,",")
			f i=1:1:SMLen q:SQLCODE'=0  d
			.s StoreMoveID=$p(StoreMoveIDs,",",i)
			.s StoreMoveListID=0
			.f  s StoreMoveListID=$o(^DHCEQStoreMoveList(0,"StoreMove",StoreMoveID,StoreMoveListID)) q:(StoreMoveListID="")||(SQLCODE'=0)  d
			..q:$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",15)'="" //过滤掉附属设备
			..&SQL(Update SQLUSER.DHC_EQStoreMoveList Set SML_OriginalFee=:Value where SML_RowID = :StoreMoveListID)
			..q:SQLCODE'=0
			
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
	}
	elseif(FieldName="OCLManuFactoryDR")
	{
		//生产厂商
		&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_ManuFactoryDR=:Value where OCL_RowID = :BussID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISLRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_ManuFactoryDR=:Value where ISL_RowID = :ISLRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_ManuFactoryDR=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i StoreMoveIDs'=""
		{
			s SMLen=$l(StoreMoveIDs,",")
			f i=1:1:SMLen q:SQLCODE'=0  d
			.s StoreMoveID=$p(StoreMoveIDs,",",i)
			.s StoreMoveListID=0
			.f  s StoreMoveListID=$o(^DHCEQStoreMoveList(0,"StoreMove",StoreMoveID,StoreMoveListID)) q:(StoreMoveListID="")||(SQLCODE'=0)  d
			..q:$p($g(^DHCEQStoreMoveList(StoreMoveListID)),"^",15)'="" //过滤掉附属设备
			..&SQL(Update SQLUSER.DHC_EQStoreMoveList Set SML_ManuFactoryDR=:Value where SML_RowID = :StoreMoveListID)
			..q:SQLCODE'=0
			
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
	}
	elseif(FieldName="OCLStatCatDR")
	{
		//设备类型
		&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_StatCatDR=:Value where OCL_RowID = :BussID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Set OCR_StatCatDR=:Value where OCR_RowID = :OCRRowID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISLRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_StatCatDR=:Value where ISL_RowID = :ISLRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		i ISRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStock Set IS_StatCatDR=:Value where IS_RowID = :ISRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_StatCatDR=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i StoreMoveIDs'=""
		{
			s SMLen=$l(StoreMoveIDs,",")
			f i=1:1:SMLen q:SQLCODE'=0  d
			.s StoreMoveID=$p(StoreMoveIDs,",",i)
			.&SQL(Update SQLUSER.DHC_EQStoreMove Set SM_StatCatDR=:Value where SM_RowID = :StoreMoveID)
			.q:SQLCODE'=0
			
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
	}
	elseif(FieldName="OCLEquiCatDR")
	{
		//使用年限
		&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_EquiCatDR=:Value where OCL_RowID = :BussID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISLRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_EquipCatDR=:Value where ISL_RowID = :ISLRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_EquiCatDR=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	elseif(FieldName="OCLLimitYearsNum")
	{
		//使用年限
		&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_LimitYearsNum=:Value where OCL_RowID = :BussID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISLRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_LimitYearsNum=:Value where ISL_RowID = :ISLRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_LimitYearsNum=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	elseif(FieldName="OCLHold5")
	{
		//经费来源
		&SQL(Update SQLUSER.DHC_EQOpenCheckList Set OCL_Hold5=:Value where OCL_RowID = :BussID)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		i ISLRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQInStockList Set ISL_Hold5=:Value where ISL_RowID = :ISLRowID)
			i SQLCODE
			{
				TROLLBACK
				Quit SQLCODE
			}
		}
		&SQL(Update SQLUSER.DHC_EQEquip Set EQ_Hold10=:Value where EQ_OpenCheckListDR = :BussID and EQ_Hold13 is null)
		i SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
	}
	TCOMMIT
	q SQLCODE
ERROROpenCheckBusiness
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// Creator：      ZX
/// CreatDate：    2019-08-30
/// Description:   根据验收明细id获取相关转移单id
/// Input：        SourceOCLRowID:来源验收明细id
/// Return：       SMRowIDs 转移明细单id串 以','分割
/// w ##Class(web.DHCEQ.Plat.LIBBusinessModify).GetSMRowIDsByOCLRowID("1")
ClassMethod GetSMRowIDsByOCLRowID(SourceOCLRowID) As %String
{
	s SMRowIDs=""
	s SMLRowIDs=""
	i SourceOCLRowID="" q ""
	s SourceISLRowID=0
	f  s SourceISLRowID=$o(^DHCEQInStockList(0,"Source","2",SourceOCLRowID,SourceISLRowID)) q:SourceISLRowID=""  d
	.q:$p($g(^DHCEQInStockList(SourceISLRowID)),"^",22)'="" //过滤掉附属设备
	.s SourceISRowID=$p($g(^DHCEQInStockList(SourceISLRowID)),"^",1)
	.q:$p($g(^DHCEQInStock(SourceISRowID)),"^",25)'="N"
	.s SMLRowID=0
	.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"InStockList",SourceISLRowID,SMLRowID)) q:SMLRowID=""  d
	..d GetSMRowIDs
	
	s SourceEQRowID=0
	f  s SourceEQRowID=$o(^DHCEQEquip(0,"OpenCheckList",SourceOCLRowID,SourceEQRowID)) q:SourceEQRowID=""  d
	.q:$p($g(^DHCEQEquip(SourceEQRowID,"OtherInfo")),"^",26)'="" //过滤掉附属设备
	.s SMLRowID=0
	.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"Equip",SourceEQRowID,SMLRowID)) q:SMLRowID=""  d
	..d GetSMRowIDs
	
	q SMRowIDs
	
GetSMRowIDs
	s SMRowID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
	q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)'="N"
	q:(","_SMRowIDs_",")[(","_SMRowID_",")
	i SMRowIDs'="" s SMRowIDs=SMRowIDs_","
	s SMRowIDs=SMRowIDs_SMRowID
	
	quit
}

/// Creator：      ZX
/// CreatDate：    2019-09-02
/// Description:   获取修改字段关联的业务单信息
/// Input：        BussType:业务类型 BussID:业务id FieldName:字段名 MainFlag:主单标志
/// Return：       相关业务的单号 json格式
/// w ##Class(web.DHCEQ.Plat.LIBBusinessModify).GetUniteBuss("94","15","","N")
ClassMethod GetUniteBuss(BussType As %String = "", BussID As %String = "", FieldName As %String = "", MainFlag As %String = "")
{
	s Result=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	i BussID="" q ""    //add by wy 2019-11-26 需求1098460
	if (BussType="21")
	{
		s (OpenCheckNos,EquipNos,ContractNos,IFBNos,BuyPlanNos,ISNos,SMNos)=""		//2010754 czf 20210707
		//获取入库明细id
		s ISLRowIDs=""
		i MainFlag="Y" d
		.s ISLRowID=0
		.f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",BussID,ISLRowID)) q:ISLRowID=""  d
		..q:$p($g(^DHCEQInStockList(ISLRowID)),"^",22)'="" //过滤掉附属设备
		..i ISLRowIDs'="" s ISLRowIDs=ISLRowIDs_","
		..s ISLRowIDs=ISLRowIDs_ISLRowID
		e  d
		.s ISLRowIDs=BussID
		//获取验收明细id
		s OCLRowIDs=""
		s ISLLen=$l(ISLRowIDs,",")
		f i=1:1:ISLLen d
		.s CurISLRowID=$p(ISLRowIDs,",",i)
		.q:CurISLRowID=""
		.s ISLSourceType=$p($g(^DHCEQInStockList(CurISLRowID)),"^",18)
		.s ISLSourceID=$p($g(^DHCEQInStockList(CurISLRowID)),"^",19)
		.i ISLSourceType=2 d
		..s OCLRowID=ISLSourceID
		..i OCLRowIDs'="" s OCLRowIDs=OCLRowIDs_","
		..s OCLRowIDs=OCLRowIDs_OCLRowID
		.e  i ISLSourceType=0 d
		..s EquipNo=$p($g(^DHCEQEquip(ISLSourceID)),"^",71)
		..i (EquipNos'="")&&((","_EquipNos_",")'[(","_EquipNo_",")) s EquipNos=EquipNos_","
		..s EquipNos=EquipNos_EquipNo
		
		//获取验收单号
		s OCLLen=$l(OCLRowIDs,",")
		s CurOCRRowIDs=""
		f OCLNum=1:1:OCLLen d
		.s OpenCheckListID=$p(OCLRowIDs,",",OCLNum)
		.q:OpenCheckListID=""
		.s OpenCheckRequestID=$p($g(^DHCEQOpenCheckList(OpenCheckListID)),"^",1)
		.q:OpenCheckRequestID=""
		.s OpenCheckNo=$p($g(^DHCEQOpenCheckRequest(OpenCheckRequestID)),"^",37)
		.i OpenCheckNos'="" s OpenCheckNos=OpenCheckNos_","
		.s OpenCheckNos=OpenCheckNos_OpenCheckNo
		.d GetInfoByOpenCheck		//modified by czf 20200910 begin
		
		s OpenCheckNos=##Class(web.DHCEQCommon).GetContinueNo(OpenCheckNos)
		d Result.%Set("OpenCheckNos",OpenCheckNos)
		s EquipNos=##Class(web.DHCEQCommon).GetContinueNo(EquipNos)
		d Result.%Set("EquipNos",EquipNos)
		d Result.%Set("ContractNos",ContractNos)
		d Result.%Set("IFBNos",IFBNos)
		d Result.%Set("BuyPlanNos",BuyPlanNos)
		s SMNos=##Class(web.DHCEQCommon).GetContinueNo(SMNos)
		d Result.%Set("SMNos",SMNos)
	}
	if (BussType="11")
	{
		s (EquipNos,ContractNos,IFBNos,BuyPlanNos,ISNos,SMNos)=""
		s OpenCheckListID=0
		f  s OpenCheckListID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",BussID,OpenCheckListID)) q:OpenCheckListID=""  d
		.d GetInfoByOpenCheck
		
		s EquipNos=##Class(web.DHCEQCommon).GetContinueNo(EquipNos)
		d Result.%Set("EquipNos",EquipNos)
		d Result.%Set("ContractNos",ContractNos)
		d Result.%Set("IFBNos",IFBNos)
		d Result.%Set("BuyPlanNos",BuyPlanNos)
		d Result.%Set("ISNos",ISNos)
		s SMNos=##Class(web.DHCEQCommon).GetContinueNo(SMNos)	;czf 2021-02-05
		d Result.%Set("SMNos",SMNos)
	}
	///add by ZY0252 20210301
	if (BussType="94")
	{
		//获取验收明细id
		s OCLRowIDs=""
		i MainFlag="Y" d
		.s CTLRowID=0
		.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",BussID,CTLRowID)) q:CTLRowID=""  d
		..s OCLRowID=0
		..f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source",1,CTLRowID,OCLRowID)) q:OCLRowID=""  d
		...s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
		...q:$p($g(^DHCEQOpenCheckList(OCRRowID)),"^",45)="Y"
		...i OCLRowIDs'="" s OCLRowIDs=OCLRowIDs_","
		...s OCLRowIDs=OCLRowIDs_OCLRowID
		e  d
		.s OCLRowID=0
		.f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source",1,BussID,OCLRowID)) q:OCLRowID=""  d
		..s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
		..q:$p($g(^DHCEQOpenCheckList(OCRRowID)),"^",45)="Y"
		..i OCLRowIDs'="" s OCLRowIDs=OCLRowIDs_","
		..s OCLRowIDs=OCLRowIDs_OCLRowID
		
		i OCLRowIDs="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Result)
		s OCLLen=$l(OCLRowIDs,",")
		
		//获取验收单号
		s (ContractNos,OpenCheckNos,EquipNos,IFBNos,BuyPlanNos,ISNos,SMNos)=""
		s CurOCRRowIDs=""
		f OCLNum=1:1:OCLLen d
		.s OpenCheckListID=$p(OCLRowIDs,",",OCLNum)
		.s OpenCheckRequestID=$p($g(^DHCEQOpenCheckList(OpenCheckListID)),"^",1)
		.s OpenCheckNo=$p($g(^DHCEQOpenCheckRequest(OpenCheckRequestID)),"^",37)
		.i OpenCheckNos'="" s OpenCheckNos=OpenCheckNos_","
		.s OpenCheckNos=OpenCheckNos_OpenCheckNo
		.d GetInfoByOpenCheck		//modified by czf 20200910 begin
		
		s OpenCheckNos=##Class(web.DHCEQCommon).GetContinueNo(OpenCheckNos)
		d Result.%Set("OpenCheckNos",OpenCheckNos)
		s EquipNos=##Class(web.DHCEQCommon).GetContinueNo(EquipNos)
		d Result.%Set("EquipNos",EquipNos)
	}
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,Result)
	
GetInfoByOpenCheck
	s EquipID=0
	f  s EquipID=$o(^DHCEQEquip(0,"OpenCheckList",OpenCheckListID,EquipID)) q:EquipID=""  d
	.q:$p($g(^DHCEQEquip(EquipID,"OtherInfo")),"^",26)'="" //过滤掉附属设备
	.s EquipNo=$p($g(^DHCEQEquip(EquipID)),"^",71)
	.i EquipNos'="" s EquipNos=EquipNos_","
	.s EquipNos=EquipNos_EquipNo
	s SourceType=$p($g(^DHCEQOpenCheckList(OpenCheckListID)),"^",63)
	s SourceID=$p($g(^DHCEQOpenCheckList(OpenCheckListID)),"^",64)
	q:(SourceType="")||(SourceID="")
	i (SourceType=1)||(SourceType=4)||(SourceType=5) d
	.s ContractID=$p($g(^DHCEQContractList(SourceID)),"^",1)
	.s ContractNo=$p($g(^DHCEQContract(ContractID)),"^",2)
	.i ContractNos'="" s ContractNos=ContractNo_","
	.s ContractNos=ContractNos_ContractNo
	e  i SourceType=2 d
	.s IFBBagID=$p($g(^DHCEQIFBBag(SourceID)),"^",1)
	.s IFBNo=$p($g(^DHCEQIFB(IFBBagID)),"^",3)
	.i IFBNos'="" s IFBNos=IFBNos_","
	.s IFBNos=IFBNos_IFBNo
	e  i SourceType=3 d
	.s BuyPlanID=$p($g(^DHCEQBuyPlanList(SourceID)),"^",1)
	.s BuyPlanNo=$p($g(^DHCEQBuyPlan(BuyPlanID)),"^",25)
	.i BuyPlanNos'="" s BuyPlanNos=BuyPlanNos_","
	.s BuyPlanNos=BuyPlanNos_BuyPlanNo		//modified by czf 20200910 end
	
	;获取入库单号	czf 2021-02-05 begin 
	s ISLID=0
	f  s ISLID=$o(^DHCEQInStockList(0,"Source",2,OpenCheckListID,ISLID)) q:ISLID=""  d
	.s ISID=$p($g(^DHCEQInStockList(ISLID)),"^",1)
	.q:$p($g(^DHCEQInStock(ISID)),"^",25)="Y"
	.s ISNo=$p($g(^DHCEQInStock(ISID)),"^",14)
	.i ISNos'="" s ISNos=ISNos_","
	.s ISNos=ISNos_ISNo
	
	;获取转移单号	
	s CurSMRowIDs=##Class(web.DHCEQ.Plat.LIBBusinessModify).GetSMRowIDsByOCLRowID(OpenCheckListID)
	q:CurSMRowIDs=""
	s CurSMLen=$l(CurSMRowIDs,",")
	f SMNoNum=1:1:CurSMLen d
	.s SMNoRowID=$p(CurSMRowIDs,",",SMNoNum)
	.q:SMNoRowID=""
	.s SMNo=$p($g(^DHCEQStoreMove(SMNoRowID)),"^",1)
	.q:(","_SMNos_",")[(","_SMNo_",")
	.i SMNos'="" s SMNos=SMNos_","
	.s SMNos=SMNos_SMNo		;czf 2021-02-05 end
	
	quit
}

/// Creator:add by zx 20190902
/// Description:根据验收明细id调整设备原值(程序改造来源:导入数据 'ChangeAccount' 方法)
/// Input:
/// Command:d ##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateByOCLRowID("")
ClassMethod UpdateByOCLRowID(OCLRowID As %String = "", ValueFee As %String = "")
{
 	i OCLRowID="" q ""
 	s EquipRowID=0
 	f  s EquipRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EquipRowID)) q:EquipRowID=""  d
 	.q:$p($g(^DHCEQEquip(EquipRowID,"OtherInfo")),"^",26)'="" //过滤掉附属设备
 	.s EQOriginalFee=$p(^DHCEQEquip(EquipRowID),"^",27)
 	.s ChangedOriginalFee=OriginalFee+ValueFee
	
 	i ChangeType'="Test"
	{
		k PLIST
		
	 	s PLIST(2) = EQID
	 	s PLIST(3) = ChangeFee
	 	s PLIST(4) = ChangedOriginalFee
	 	s PLIST(5) = ChangedNetFee
	 	s PLIST(6) = ChangedDepreTotalFee
	 	s PLIST(9) = Reason
	 	i ChangeDate'=""  s PLIST(10) = $zdh(ChangeDate,3)	;ChangeDate
	 	e  s PLIST(10) =+$h
	 	;s PLIST(11) = $p(val,"^",11)	;Remark
	 	s PLIST(12) = 0					;Status
	 	s PLIST(13) = 1
		s PLIST(14) = +$H
		s PLIST(15) = $P($H,",",2)
	 	s PLIST(25) = OriginalFee
	 	s PLIST(26) = $p(^DHCEQEquip(EQID),"^",28)	;NetFee
	 	s PLIST(27) = $p(^DHCEQEquip(EQID),"^",29)	;NetRemainFee
	 	s PLIST(29) = $p(^DHCEQEquip(EQID),"^",67)	;StoreLocDR
	 	s PLIST(30) = $p(^DHCEQEquip(EQID),"^",19)	;UseLocDR
	 	s PLIST(31) = $p(^DHCEQEquip(EQID),"^",63)	;EquipTypeDR
	 	s PLIST(32) = $p(^DHCEQEquip(EQID),"^",75)	;StatCatDR
	 	s PLIST(34) = ChangeTotalFee		;调整累计折旧
	 	s PLIST(35) = ChangeMonth			;调整月份
	 	
	 	Set $ZT="ERRORAudit"
		TSTART
		;保存调账单
		&SQL(Select CA_RowID from SQLUSER.DHC_EQChangeAccount Where CA_EquipDR=:PLIST(2) and CA_Status<2)
		;if (%ROWCOUNT>0)  s RetStr=..RetErrorValue(RetStr,Name_"尚有调账记录未审核,不能新增") 
		if RetStr q RetStr 
		&SQL(Insert Into SQLUSER.DHC_EQChangeAccount Values :PLIST())
		if SQLCODE 
		{
			TROLLBACK
			;q ..RetErrorValue(RetStr,Name_"插入调账单失败:"_SQLCODE)
		}
		Set CAID=$g(%ROWID)
		
		;保存资金来源调账信息
		s ListCount=$L(changefundsinfo,"||")
		s (ReturnID,flag)=0
		for i=1:1:ListCount
		{
			s List=$p(changefundsinfo,"||",i)
			s ReturnID=##Class(web.DHCEQFunds).UpdateFunds(7,CAID,List)
			i ReturnID<0 s flag=1
		}
		i flag'=0
		{
			TRollBack
			;q ..RetErrorValue(RetStr,Name_"插入资金来源失败:"_ReturnID)
		}
		;执行调账单
		/*if ($p($g(^DHCEQChangeAccount(CAID)),"^",11)=2)
	 	{
		 	;s RetStr=..RetErrorValue(RetStr,Name_"调账单已审核"_CAID)
		 	TRollback
		 	q ..RetErrorValue(RetStr,Name_"该调账单已审核")
	 	}*/
	 	s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(7,CAID,ChangeFee)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	;q ..RetErrorValue(RetStr,Name_"更新资金来源失败:"_SQLCODE)
	 	}
	 	
	 	k PLISTMX
	 	s PLISTMX(15)="1"			;SourceType
	 	s PLISTMX(16)=EQID			;SourceID
	 	s PLISTMX(2)=EQID
	 	s PLISTMX(7)="0"
	 	s PLISTMX(8)=1
		s PLISTMX(9)=+$h
		s PLISTMX(10)=$p($h,",",2)
		s PLISTMX(11)="N"
		
		;更新设备资金来源表
		s CAFundsRowID=0
		f  s CAFundsRowID=$o(^DHCEQFunds("0","Source","7",CAID,CAFundsRowID))  q:((CAFundsRowID="")||(SQLCODE'=0))  d
		.q:$p($g(^DHCEQFunds(CAFundsRowID)),"^",10)="Y"
		.s FTypeDR=$p($g(^DHCEQFunds(CAFundsRowID)),"^",2)	;FundsType
		.s PLISTMX(3)=FTypeDR
		.s TFundsInfo=##Class(web.DHCEQFunds).GetSourceFunds("1",EQID,EQOriginalFee,FTypeDR)
		.s TFundsRowID=$p(TFundsInfo,"^",2)
		.s TFee=+$Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",3)				;调整的资金来源
		.s TDepreTotalFee=+$Piece($Get(^DHCEQFunds(CAFundsRowID)),"^",13)	;调整的累计折旧
		.i TFundsRowID'=""  d
		..s TFee=+TFundsInfo+TFee									;调后资金来源
		..s TDepreTotalFee=+$Piece(TFundsInfo,"^",4)+TDepreTotalFee		;调后累计折旧
		.i TFee<0 s SQLCODE=-3001
		.q:SQLCODE'=0
		.s PLISTMX(4)=TFee
		.s PLISTMX(14)=TDepreTotalFee	
		.
		.i TFundsRowID'=""  d
		..&SQL(Update SQLUSER.DHC_EQFunds Values :PLISTMX() where F_RowID = :TFundsRowID)
		.e  d
		..&SQL(Insert Into SQLUSER.DHC_EQFunds Values :PLISTMX())
	 	if SQLCODE
	 	{
		 	TRollback
		 	;q ..RetErrorValue(RetStr,Name_"更新设备资金来源失败:"_SQLCODE)
	 	}
	 	
	 	;更新调账表
	 	s CADepreTotal=+$Piece($Get(^DHCEQChangeAccount(CAID)),"^",33)	;CA_Hold2
	 	s OriginalFee=$p($g(^DHCEQEquip(EQID)),"^",27)
	 	s NetFee=$p($g(^DHCEQEquip(EQID)),"^",28)
	 	s EQDepreTotalFee=+$Piece($Get(^DHCEQEquip(EQID)),"^",35)
	 	s EQStatus=$p($g(^DHCEQEquip(EQID)),"^",38)
	 	s OriginalFee=OriginalFee+ChangeFee
	 	s NetFee=NetFee+ChangeFee
	 	s NetRemainFee=##Class(web.DHCEQCommon).FormatNumber(OriginalFee*RemainFeeRate/100,"",2)
	 	i NetFee<0 s NetFee=0
	 	s DepreTotal=OriginalFee-NetFee
	 	If CADepreTotal'=0
	 	{
	 		Set DepreTotal=OriginalFee-NetFee+CADepreTotal
	 		Set NetFee=NetFee-CADepreTotal
	 	}
	 	s Curdate=+$h
	 	s Curtime=$p($h,",",2)
	 	&SQL(Update SQLUSER.DHC_EQChangeAccount set CA_Status=2,CA_AuditUserDR=1,CA_AuditDate=+:Curdate,CA_AuditTime=:Curtime,CA_Hold1=:EQStatus where CA_RowID = :CAID)
	 	if SQLCODE 
	 	{
		 	TRollback
		 	;q ..RetErrorValue(RetStr,Name_"更新调账表失败:"_SQLCODE)
	 	}
	 	
	 	;更新生命周期表
	 	s LI(2)=EQID  //设备
		s LI(4)=$p($g(^DHCEQEquip(EQID)),"^",19)   //原使用科室
		s LI(5)=$p($g(^DHCEQEquip(EQID)),"^",17) //原管理科室
		s LI(6)=$p($g(^DHCEQEquip(EQID)),"^",67)  //原库房
		s LI(7)=$p($g(^DHCEQEquip(EQID)),"^",27)  //原值
		s LI(8)=$p($g(^DHCEQEquip(EQID)),"^",28)  //原净值
		s LI(14)=$p($g(^DHCEQChangeAccount(CAID)),"^",8)  //变动原因
		s LI(15)=$p($g(^DHCEQChangeAccount(CAID)),"^",6)  //变动描述
		s LI(16)=+$H			//变动日期
		s LI(17)=$p($h,",",2)	//变动时间
		s LI(19)="C"			//生命周期类型
		s LI(20)=51				//来源类型
		s LI(21)=CAID			//来源ID
		s LI(23)=$p($g(^DHCEQChangeAccount(CAID)),"^",10)  //备注
		s LI(27)=1				//更新人
		s LI(28)=+$H			//更新日期
		s LI(29)=$p($h,",",2)	//更新时间
		
		;更新DHCEQEquip表
	 	&SQL(Update SQLUSER.DHC_EQEquip set EQ_NetFee=:NetFee,EQ_OriginalFee=:OriginalFee,EQ_NetRemainFee=:NetRemainFee,EQ_DepreTotalFee=:DepreTotal where EQ_RowID = :EQID)
	 	if SQLCODE 
	 	{
		 	TRollback
		 	;q ..RetErrorValue(RetStr,Name_"更新台账失败:"_SQLCODE)
	 	}
		s LI(9)=$p($g(^DHCEQEquip(EQID)),"^",19)   	//变动后使用科室
		s LI(10)=$p($g(^DHCEQEquip(EQID)),"^",17) 	//变动后管理科室
		s LI(11)=$p($g(^DHCEQEquip(EQID)),"^",67)  	//变动后库房
		s LI(12)=$p($g(^DHCEQEquip(EQID)),"^",27)  	//变动后原值
		s LI(13)=$p($g(^DHCEQEquip(EQID)),"^",28)  	//变动后净值
		&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
		if SQLCODE
		{
			TRollBack
			;q ..RetErrorValue(RetStr,Name_"更新生命周期失败:"_SQLCODE)
		}
		;更新DHCEQDepreSet表
		s DepreSetID=$Order(^DHCEQDepreSet(0,"Source",1,0,EQID,0))
		s DSDepreTotalFee=CADepreTotal+$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",23)
		&SQL(update sqluser.DHC_EQDepreSet set DS_DepreTotalFee=:DSDepreTotalFee where DS_RowID=:DepreSetID)
	 	if SQLCODE
		{
			TRollBack
			;q ..RetErrorValue(RetStr,Name_"更新DepreSet失败:"_SQLCODE)
		}
		;更新DHC_EQBillInfo表
	 	s SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(7,CAID)
	 	if SQLCODE
		{
			TRollBack
			;Quit ..RetErrorValue(RetStr,Name_"更新DHC_EQBillInfo失败:"_SQLCODE)
		}
	 	TCommit
	 	q "OK"
ERRORAudit
		TRollBack	
		Set ErrorMsg=$ZE	//得到系统返回的错误消息
		q "调账失败"		;操作失败
	}
	q:RetStr="" "OK"
	q RetStr
	
GetChangeFundsInfo
 	s fundscount=$l(FundsInfo,",")
	f i=1:1:fundscount  d
	.s curfunds=$p(FundsInfo,",",i)
	.s fundstype=$p(curfunds,"=",1)
	.s fundstypeid=##Class(web.DHCEQImportDataTool).GetFundsType(fundstype)
	.q:fundstypeid'=FTRowID
	.s AfterFundsFee=+$p(curfunds,"=",2)		;变动后资金来源
	.i (ISByFundsRate="Y") d		;按资金来源比例调整资金来源累计折旧
	..i ChangedOriginalFee=0 s TFDepre=0
	..e  s TFDepre=AfterFundsFee*ChangedDepreTotalFee/ChangedOriginalFee
	..s TFDepre=##Class(web.DHCEQCommon).FormatNumber(TFDepre,"",2)
	..s ChangedFundsDepreTotal=fundstype_"="_TFDepre
	.s fundsdeprelen=$l(ChangedFundsDepreTotal,",")
	.f j=1:1:fundsdeprelen d
	..s curfundsdepre=$p(ChangedFundsDepreTotal,",",j)
	..s deprefundstype=$p(curfundsdepre,"=",1)
	..s deprefundtypeid=##Class(web.DHCEQImportDataTool).GetFundsType(deprefundstype)
	..q:deprefundtypeid'=FTRowID
	..s AfterDepreTotal=$p(curfundsdepre,"=",2)		;变动后资金来源累计折旧
	
	quit
}

/// Creator:czf
/// CreatDate:2020-08-16
/// Description:重写业务单调整方法
/// Input:BussType:相关业务类型 BussID:相关业务表ID  DataList:需修改表字段Json串 MainFlag:是否是主表
/// OutPut:表数据解析 json返回
/// Command:w ##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateBusinessByTypeNew("11","42","{""OCRHold1"":""YS2020090006"",""OCLSourceType"":""1"",""OCLSourceID_Desc"":""电冰箱"",""OCRCheckDate"":""2020-09-02"",""OCREquipTypeDR_ETDesc"":""通用设备"",""OCRStatCatDR_SCDesc"":""电气设备"",""OCLEquiCatDR_ECDesc"":""制冷电器"",""OCLModelDR_MDesc"":""BCD-212A"",""OCLName"":""电冰箱"",""OCLOriginalFee"":""6700.00"",""OCLQuantity"":""2.00"",""OCLUnitDR_UOMDesc"":""台"",""OCLUseLocDR_CTLOCDesc"":""中药库"",""OCLLocationDR_LDesc"":""15L"",""OCLContractNo"":""HT2020080010"",""OCLHold2"":""Reg1278212"",""OCRProviderDR_VDesc"":""苏宁易购"",""OCRProviderHandler"":""张宇"",""OCRProviderTel"":""128932312"",""OCLManuFactoryDR_MDesc"":""海尔集团"",""OCLLeaveFactoryDate"":""2020-08-30"",""OCROpenCheckDate"":""2020-09-01"",""OCLGuaranteePeriodNum"":""12.00"",""OCLCountryDR_CTCOUDesc"":""中国"",""OCROriginDR_ODesc"":""购置"",""OCLPurchaseTypeDR_PTDesc"":""新增设备"",""OCLPurposeTypeDR_PTDesc"":""医疗"",""OCLBuyTypeDR_BTDesc"":""政府招标"",""OCLDepreMethodDR_DMDesc"":""平均年限法"",""OCLLimitYearsNum"":""5.00"",""OCLHold5_EDesc"":""设备费"",""SelfFunds"":""13400.00"",""OtherFunds"":""0.00"",""BussID"":""42"",""BussType"":""11"",""MainFlag"":""N"",""DCRRowID"":""3"",""DCRStatus"":""0"",""WaitAD"":""0"",""Type"":""0"",""OCLRowID"":""42"",""OCLSourceID"":""20"",""OCREquipTypeDR"":""2"",""OCRStatCatDR"":""14"",""OCLEquiCatDR"":""700"",""OCLModelDR"":""700"",""OCLUnitDR"":""4"",""OCLUseLocDR"":""213"",""OCLLocationDR"":""3"",""OCLManuFactoryDR"":""363"",""OCLCountryDR"":""1"",""OCROriginDR"":""1"",""OCLPurchaseTypeDR"":""1"",""OCLPurposeTypeDR"":""1"",""OCLBuyTypeDR"":""1"",""OCLDepreMethodDR"":""1"",""OCLHold5"":""1"",""OCLEquipTypeDR"":""2"",""OCLStatCatDR"":""14"",""GetSelfFundsID"":""1"",""OCLLeaveFactoryNos"":""1211,1222"",""OCLFileNos"":""1344,1355"",""OCRConfigState"":""相符"",""OCRFileState"":""操作说明书，发票"",""OCRPackageState"":""外观完好"",""OCLRemark"":""xxx验收"",""OCRRunningState"":""良好""}","N","")
ClassMethod UpdateBusinessByTypeNew(BussType As %Library.String = "", BussID As %Library.String = "", DataList As %Library.String = "", MainFlag As %Library.String = "", DealTypes As %Library.String = "")
{
    s SQLCODE=0
    //modified by ZY20230314 bug:3318758
    s CurFlag=1
	
	s DataJson = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(DataList)
	s DCRRowID=DataJson.DCRRowID
	if BussType="21" 
	{
		i MainFlag="Y"  d
		.s ISStatus=$p($g(^DHCEQInStock(BussID)),"^",10)
		.s ISAuditDate=$p($g(^DHCEQInStock(BussID)),"^",13)
		.s ISLRowID=$o(^DHCEQInStockList(0,"InStock",BussID,0))
		e  d
		.s ISRowID=$p($g(^DHCEQInStockList(BussID)),"^",1)
		.s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
		.s ISAuditDate=$p($g(^DHCEQInStock(ISRowID)),"^",13)
		.s ISLRowID=BussID
		//判断是否当月单据(新增,提交单据可直接修改,审核单据校验是否为当月单据)
		i ISStatus="2"
		{
			s CurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
			s BussMonth=##Class(web.DHCEQReport).GetReportMonthByDate(ISAuditDate)
	    //modified by ZY20230314 bug:3318758
            //i CurMonth'=BussMonth q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200","非当月审核单据不能修改.")
            i CurMonth'=BussMonth s CurFlag=0
	    /*
            //判断是否已入账(已入账不允许修改,未入账则可修改)
            s Flag=0
            s AccountListID=0
            f  s AccountListID=$o(^DHCEQAccountList(0,"InStockList",ISLRowID,AccountListID))  q:(AccountListID="")||(Flag=1)  d
            .q:$p($g(^DHCEQAccountList(AccountListID)),"^",10)="Y"
            .s Flag=1
            
            i Flag=1 q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200","已入账单据不能修改.")
	    */
		}
		
		i MainFlag="Y" s OldObject=##Class(User.DHCEQInStock).%OpenId(BussID)
		e  s OldObject=##Class(User.DHCEQInStockList).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		i MainFlag'="Y" d			//czf 20201216
		.s InvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,BussID)
		.s TInvoiceNos=$p(InvoiceInfo,"^",1)
		.d OldObj.%Set("ISLInvoiceNos",TInvoiceNos)
        //modified by ZY20230314 bug:3318758
        s ErrDesc=""
		s NewObject=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20		//只记录变动值
		s key=""
		For
		{
            q:ErrDesc'=""
			s value=DataJson.GetNext(.key)
			q:key=""
			s ISkey=""
			For
			{
                q:ErrDesc'=""
				s ISvalue=OldObj.GetNext(.ISkey)
				q:ISkey=""
				if ((key=ISkey)&&(value'=ISvalue))
			   	{
			//modified by ZY20230314 bug:3318758
                    if (CurFlag'=1)
                    {
                        i (ISkey="ISOriginDR")  d
                        .s ErrDesc="非当月审核单据不能修改[来源]."
                        e  i (ISkey="ISLLimitYearsNum")  d
                        .s ErrDesc="非当月审核单据不能修改[使用年限]."
                        e  i (ISkey="ISLStatCatDR")  d
                        .s ErrDesc="非当月审核单据不能修改[设备类型]."
                        e  d
                        .d NewObject.%Set(key,value)
                    }
                    else
                    {
				   	d NewObject.%Set(key,value)
				}
			}
		}
        }
        i ErrDesc'="" q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200",ErrDesc)
		/*
		set iter = DataJson.%GetIterator()
	   	while iter.%GetNext(.key , .value ) {
		    set ISIter = OldObj.%GetIterator()
		   	while ISIter.%GetNext(.ISkey , .ISvalue ) {
			   	if ((key=ISkey)&&(value'=ISvalue))
			   	{
				   	d NewObject.%Set(key,value)
				}
		   	}
	    }
	    */
	    i (NewObject.Count()=0) q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200","没有要修改的数据.")	//CZF0131 2021-01-20
	    
	    ;入库变动申请DHC_EQDataChangeRequest
	   	s DCRObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	   	if MainFlag="Y"
		{
			s DCRObj.DCRTableName="DHC_EQInStock"
			s DCRObj.DCRClassName="User.DHCEQInStock"
		}
		else
		{
			s DCRObj.DCRTableName="DHC_EQInStockList"
			s DCRObj.DCRClassName="User.DHCEQInStockList"
		}
		s DCRObj.DCRRowID=DCRRowID
		s DCRObj.DCRBussID=BussID
		s DCRObj.DCROperateType="U"
		s DCRObj.DCROldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject).%ToJSON()
		s DCRObj.DCRNewValue=NewObject.%ToJSON()
		
		s DCRData=DCRObj.%ToJSON()
		s RtnValue=##Class(web.DHCEQ.Plat.LIBDataChangeRequest).SaveData(DCRData,"0")
		i RtnValue<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RtnValue)
		s DCRRowID=RtnValue
	    //s SQLCODE=##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateInStockBusinessNew(BussID,NewObject,MainFlag,DealTypes)	 
	}
	if BussType="11"
	{
		s OCStatus=$p($g(^DHCEQOpenCheckRequest(BussID)),"^",20)
		s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",BussID,""))
		i OCLRowID="" q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200","验收单不存在")
		s RtnInfo=##Class(web.DHCEQ.Plat.LIBBusinessModify).CheckInStockByOpenCheckID(BussID)
		s flag=$p(RtnInfo,"^",1)
		i flag'=0 q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200",$p(RtnInfo,"^",2))
		
		s OCROldObject=##Class(User.DHCEQOpenCheckRequest).%OpenId(BussID)
		s OCROldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OCROldObject)
		s OCRNewObject=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20		//记录变动值
		s OCLOldObject=##Class(User.DHCEQOpenCheckList).%OpenId(OCLRowID)
		s OCLOldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OCLOldObject)
		d OCLOldObj.%Set("OCLFileNos",$g(^DHCEQOpenCheckList(OCLRowID,"FileNo")))
		d OCLOldObj.%Set("OCLLeaveFactoryNos",$g(^DHCEQOpenCheckList(OCLRowID,"EX")))
		d OCLOldObj.%Set("OCLManuFacHandler",$p($g(^DHCEQOpenCheckList(OCLRowID,"MFInfo")),"^",1))	//czf 2021-11-04
		d OCLOldObj.%Set("OCLManuFacTel",$p($g(^DHCEQOpenCheckList(OCLRowID,"MFInfo")),"^",2))
		d OCLOldObj.%Set("OCLTempBar",$g(^DHCEQOpenCheckList(OCLRowID,"TempBar")))
		
		s Amount=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",16)*$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",17)
		s SelfFundsType=##class(web.DHCEQCommon).GetSysInfo("990015")
		s SelfFundsInfo=##Class(web.DHCEQ.EM.BUSFunds).GetSourceFunds(0,OCLID,Amount,SelfFundsType,"1")		//czf 1983205 2021-06-11
		s OtherFundInfo=##Class(web.DHCEQ.EM.BUSFunds).GetSourceFunds(0,OCLID,Amount,"","1")
		s SelfFunds=##Class(web.DHCEQCommon).FormatNumber($p(SelfFundsInfo,"^",1),"",2)	//czf 2020-12-16 1618144
		s OtherFunds=##Class(web.DHCEQCommon).FormatNumber(Amount-SelfFunds,"",2)
		d OCLOldObj.%Set("SelfFunds",SelfFunds)
		d OCLOldObj.%Set("OtherFunds",OtherFunds)
		s SelfFundsInfo=##class(web.DHCEQCommon).Replace(SelfFundsInfo,"^","#")	;czf 2021-02-04 begin
		s OtherFundInfo=##class(web.DHCEQCommon).Replace(OtherFundInfo,"^","#")
		d OCLOldObj.%Set("SelfFundsInfo",SelfFundsInfo)
		d OCLOldObj.%Set("OtherFundInfo",OtherFundInfo)
		
		;获取变动后资金来源信息 
		i $d(^DHCEQTempFunds(0,"Source",0,OCLID))
		{
			s AmountFee=DataJson.OCLOriginalFee*DataJson.OCLQuantity
			s SelfFundsInfo=##Class(web.DHCEQ.EM.BUSFunds).GetSourceFunds(0,OCLID,AmountFee,SelfFundsType,"1","Y")	//czf 1983205 2021-06-11
			s OtherFundInfo=##Class(web.DHCEQ.EM.BUSFunds).GetSourceFunds(0,OCLID,AmountFee,"","1","Y")
			s SelfFundsInfo=##class(web.DHCEQCommon).Replace(SelfFundsInfo,"^","#")
			s OtherFundInfo=##class(web.DHCEQCommon).Replace(OtherFundInfo,"^","#")
			d DataJson.%Set("SelfFundsInfo",SelfFundsInfo)
			d DataJson.%Set("OtherFundInfo",OtherFundInfo)		;czf 2021-02-04 end
		}
		s OCLNewObject=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20		//记录变动值
		
		s key=""	//CZF0131 2021-01-20
		For
		{
			s value=DataJson.GetNext(.key)
			q:key=""
		    i (OCROldObj.%IsDefined(key))&&(value'=OCROldObj.%Get(key)) d OCRNewObject.%Set(key,value)
		    i (OCLOldObj.%IsDefined(key))&&(value'=OCLOldObj.%Get(key)) d OCLNewObject.%Set(key,value)
		}
		/*
		set iter = DataJson.%GetIterator()
	   	while iter.%GetNext(.key , .value ) {
		    i (OCROldObj.%IsDefined(key))&&(value'=OCROldObj.%Get(key)) d OCRNewObject.%Set(key,value)
		    i (OCLOldObj.%IsDefined(key))&&(value'=OCLOldObj.%Get(key)) d OCLNewObject.%Set(key,value)
	    }
	    */
	    i (OCRNewObject.Count()=0)&&(OCLNewObject.Count()=0) q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200","没有要修改的数据.")	//CZF0131 2021-01-20	
	    
	    ;存在调账记录时不能修改原值和资金来源
	    s RtnStr=##Class(web.DHCEQ.Plat.LIBBusinessModify).CheckEquipChangeAccount(BussType,BussID,"")
	    i ((OCLNewObject.%IsDefined("OCLOriginalFee"))||(OCLNewObject.%IsDefined("SelfFunds"))||(OCLNewObject.%IsDefined("OtherFunds")))&&(RtnStr'="")
	    {
		    q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200",RtnStr)
		}
	    
	    s OpenCheckNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	    d OpenCheckNewObj.%Set("OpenCheckRequest",OCRNewObject)
	    d OpenCheckNewObj.%Set("OpenCheckList",OCLNewObject)
	    
	    ;变动申请DHC_EQDataChangeRequest
	   	s DCRObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
		s OpenCheckOldObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
		d OpenCheckOldObj.%Set("OpenCheckRequest",OCROldObj)
		d OpenCheckOldObj.%Set("OpenCheckList",OCLOldObj)
		//d OpenCheckOldObj.%Set("FundsInfo",FundsInfo)
		
		s DCRObj.DCRTableName="DHC_EQOpenCheckRequest"
		s DCRObj.DCRClassName="User.DHCEQOpenCheckRequest"
		s DCRObj.DCRRowID=DCRRowID
		s DCRObj.DCRBussID=BussID
		s DCRObj.DCROperateType="U"
		s DCRObj.DCROldValue=OpenCheckOldObj.%ToJSON()
		s DCRObj.DCRNewValue=OpenCheckNewObj.%ToJSON()
		
		s DCRData=DCRObj.%ToJSON()
		s RtnValue=##Class(web.DHCEQ.Plat.LIBDataChangeRequest).SaveData(DCRData,"0")
		i RtnValue<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RtnValue)
		s DCRRowID=RtnValue
	}
	///add by ZY0252 20210301
	if BussType="94" 
	{
		i MainFlag="Y" s OldObject=##Class(User.DHCEQContract).%OpenId(BussID)
		e  s OldObject=##Class(User.DHCEQContractList).%OpenId(BussID)
		s OldObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
		
		s NewObject=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20		//只记录变动值
		s key=""
		For
		{
			s value=DataJson.GetNext(.key)
			q:key=""
			s ISkey=""
			For
			{
				s ISvalue=OldObj.GetNext(.ISkey)
				q:ISkey=""
				if ((key=ISkey)&&(value'=ISvalue))
			   	{
				   	d NewObject.%Set(key,value)
				}
			}
		}
	    i (NewObject.Count()=0) q ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9200","没有要修改的数据.")	//CZF0131 2021-01-20
	    
	    ;入库变动申请DHC_EQDataChangeRequest
	   	s DCRObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20
	   	if MainFlag="Y"
		{
			s DCRObj.DCRTableName="DHC_EQContract"
			s DCRObj.DCRClassName="User.DHCEQContract"
		}
		else
		{
			s DCRObj.DCRTableName="DHC_EQContractList"
			s DCRObj.DCRClassName="User.DHCEQContractList"
		}
		s DCRObj.DCRRowID=DCRRowID
		s DCRObj.DCRBussID=BussID
		s DCRObj.DCROperateType="U"
		s DCRObj.DCROldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject).%ToJSON()
		s DCRObj.DCRNewValue=NewObject.%ToJSON()
		
		s DCRData=DCRObj.%ToJSON()
		s RtnValue=##Class(web.DHCEQ.Plat.LIBDataChangeRequest).SaveData(DCRData,"0")
		i RtnValue<0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RtnValue)
		s DCRRowID=RtnValue
	    //s SQLCODE=##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateInStockBusinessNew(BussID,NewObject,MainFlag,DealTypes)	 
	}
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,DCRRowID)
}

/// Creator:CZF
/// CreatDate:2020-08-16
/// Description:通过入库修改相关业务单据信息
/// Input：BussID:表相关ID DataInfo:需修改表字段Json字符串  MainFlag:是否是主表
/// OutPut:SQLCode:修改表数据后SQLCODE
/// Command:w ##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateBusinessByType("")
ClassMethod UpdateInStockBusinessNew(BussID As %Library.String = "", DataInfo As %Library.String = "", MainFlag As %Library.String = "", DealTypes As %Library.String = "", DCRRowID As %Library.String = "")
{
	q:(DataInfo="{}")||(BussID="") 100
	s SQLCODE=0
	k OCLPLIST,OCRPLIST,SMLPLIST,SMPLIST,EQPLIST,CTLPLIST,CTPLIST
	n OCLNewObj,OCRNewObj,SMLNewObj,SMNewObj,EQNewObj,CTLNewObj,CTNewObj
	s OCLNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20 begin
	s OCRNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s SMLNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s SMNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s EQNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s CTLNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s CTNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20 end
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	if MainFlag="Y"
	{
		s OldObject=##Class(User.DHCEQInStock).%OpenId(BussID)
	}
	else
	{
		s OldObject=##Class(User.DHCEQInStockList).%OpenId(BussID)
	}
	s NewObject=OldObject
	s DataJson = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(DataInfo)
	s OldTableObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
	s newkey=""		//CZF0131 2021-01-20
	For
	{
		s newvalue=DataJson.GetNext(.newkey)
		q:newkey=""
		s FieldName=newkey
	    s Value=newvalue
	   	d GetUpdInfo
	}
	/*
	set iter = DataJson.%GetIterator()
   	while iter.%GetNext(.key , .newvalue ) {
	    s FieldName=key
	    s Value=newvalue
	   	d GetUpdInfo
   	}
   	*/
   	i SQLCODE q SQLCODE
   	
   	;保存入库表/入库明细表变动信息
	s SQLCODE=NewObject.%Save()
	i $$$ISERR(SQLCODE) q SQLCODE
	d NewObject.%Close()
	
	s SQLCODE=0
    ;保存入库变动日志
	s OldValue=OldTableObj.%ToJSON()
	i MainFlag="Y"
	{
		s TableName="DHC_EQInStock"
		s ClassName="User.DHCEQInStock"
	}
	else
	{
		s TableName="DHC_EQInStockList"
		s ClassName="User.DHCEQInStockList"
	}
	
	s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"U",DataInfo,OldValue,CurUser,DCRRowID)
	i SQLCODE q SQLCODE
	
	;更新关联的验收、转移、设备信息
	s ISLRowIDs=""
	if MainFlag="Y"
	{
		s ISLRowID=0
		f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",BussID,ISLRowID)) q:(ISLRowID="")  d
		.s ISLRowIDs=ISLRowIDs_ISLRowID_","
		.i ISLRowIDs'="" s ISLRowIDs=ISLRowIDs_","_ISLRowID
		.e  s ISLRowIDs=ISLRowID
		
		s BussListID=0
		f  s BussListID=$o(^DHCEQInStockList(0,"InStock",BussID,BussListID)) q:(BussListID="")||(SQLCODE'=0)  d
		.s SourceTypeID=$p($g(^DHCEQInStockList(BussListID)),"^",19)
		.d UpdateBySourceNew
	}
	else
	{
		s BussListID=BussID
		d UpdateBySourceNew
	}
	
	q SQLCODE
	
	;获取更新字段PLIST
GetUpdInfo	
	if MainFlag="Y"
	{
		if FieldName="ISBuyLocDR"
		{
			;采购部门
			s NewObject.ISBuyLocDR=Value
		}
		elseif FieldName="ISBuyUserDR"
		{
			;采购人
			s NewObject.ISBuyUserDR=Value
		}
		elseif FieldName="ISInDate"
		{
			;制单日期
			s Value=##Class(web.DHCEQCommon).TransValueFromPage(Value,"date")
			s NewObject.ISInDate=Value
		}
		else
		{
			if FieldName="ISEquipTypeDR"
			{
				d NewObject.ISEquipTypeDRSetObjectId(Value)
				s OCLPLIST(4)=Value,OCLNewObj.OCLEquipTypeDR=Value
				s OCRPLIST(3)=Value,OCRNewObj.OCREquipTypeDR=Value
				s SMPLIST(17)=Value,SMNewObj.SMEquipTypeDR=Value
				s EQPLIST(64)=Value,EQNewObj.EQEquipTypeDR=Value
			}
			elseif FieldName="ISProviderDR"
			{
				d NewObject.ISProviderDRSetObjectId(Value)
				s OCRPLIST(6)=Value,OCRNewObj.OCRProviderDR=Value
				s EQPLIST(26)=Value,EQNewObj.EQProviderDR=Value
				s CTPLIST(19)=Value,CTNewObj.CTProviderDR=Value
			}
			elseif FieldName="ISOriginDR"
			{
				d NewObject.ISOriginDRSetObjectId(Value)
				s OCRPLIST(9)=Value,OCRNewObj.OCROriginDR=Value
				s EQPLIST(21)=Value,EQNewObj.EQOriginDR=Value
			}
		}
	}
	else
	{
		if FieldName="ISLRemark"
		{
			s NewObject.ISLRemark=Value
		}
		elseif FieldName="ISLInvoiceNos"
		{
			s InvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,BussID)
			s TInvoiceNos=$p(InvoiceInfo,"^",1)
			s TInvoiceDate=$p(InvoiceInfo,"^",2) 
			s TInvoiceFee=$p(InvoiceInfo,"^",3)
			d OldTableObj.%Set("InvoiceNos",TInvoiceNos)
			s SQLCODE=##Class(web.DHCEQ.EM.BUSInStock).UpdateInvoiceInfo(BussID, Value, TInvoiceDate, TInvoiceFee)
			i SQLCODE q SQLCODE
		}
		else
		{
			if FieldName="ISLEquipName"
			{
				s NewObject.ISLEquipName=Value
				s OCLPLIST(3)=Value,OCLNewObj.OCLName=Value
				s SMLPLIST(6)=Value,SMLNewObj.SMLName=Value
				s EQPLIST(2)=Value,EQNewObj.EQName=Value
				s CTLPLIST(3)=Value,CTLNewObj.CTLName=Value
			}
			elseif FieldName="ISLModelDR"
			{
				d NewObject.ISLModelDRSetObjectId(Value)
				s OCLPLIST(6)=Value,OCLNewObj.OCLModelDR=Value
				s SMLPLIST(10)=Value,OCLNewObj.SMLModelDR=Value
				s EQPLIST(4)=Value,OCLNewObj.EQModelDR=Value
				s CTLPLIST(4)=Value,CTLNewObj.CTLModelDR=Value
			}
			elseif FieldName="ISLUnitDR"
			{
				s NewObject.ISLUnitDR=Value
				s OCLPLIST(8)=Value,OCLNewObj.OCLUnitDR=Value
				s SMLPLIST(11)=Value,SMLNewObj.SMLUnitDR=Value
				s EQPLIST(6)=Value,EQNewObj.EQUnitDR=Value				
			}
			elseif FieldName="ISLOriginalFee"
			{
				s NewObject.ISLOriginalFee=Value
				s OCLPLIST(18)=Value,OCLNewObj.OCLOriginalFee=Value
				s SMLPLIST(8)=Value,SMLNewObj.SMLOriginalFee=Value
				s EQPLIST(28)=Value,EQNewObj.EQOriginalFee=Value
				s CTLPLIST(7)=Value,CTLNewObj.CTLPriceFee=Value
			}
			elseif FieldName="ISLManuFactoryDR"
			{
				d NewObject.ISLManuFactoryDRSetObjectId(Value)
				s OCLPLIST(16)=Value,OCLNewObj.OCLManuFactoryDR=Value
				s SMLPLIST(7)=Value,SMLNewObj.SMLManuFactoryDR=Value
				s EQPLIST(27)=Value,EQNewObj.EQManuFactoryDR=Value
				s CTLPLIST(5)=Value,CTLNewObj.CTLManuFactoryDR=Value
			}
			elseif FieldName="ISLStatCatDR"
			{
				d NewObject.ISLStatCatDRSetObjectId(Value)
				s OCRPLIST(5)=Value,OCRNewObj.OCRStatCatDR=Value
				s OCLPLIST(29)=Value,OCLNewObj.OCLStatCatDR=Value
				s SMPLIST(18)=Value,SMNewObj.SMStatCatDR=Value
				s EQPLIST(76)=Value,EQNewObj.EQStatCatDR=Value
			}
			elseif FieldName="ISLEquipCatDR"
			{
				d NewObject.ISLEquipCatDRSetObjectId(Value)
				s OCLPLIST(7)=Value,OCLNewObj.OCLEquiCatDR=Value
				s EQPLIST(5)=Value,EQNewObj.EQEquiCatDR=Value
			}
			elseif FieldName="ISLLimitYearsNum"
			{
				s NewObject.ISLLimitYearsNum=Value
				s OCLPLIST(20)=Value,OCLNewObj.OCLLimitYearsNum=Value
				s EQPLIST(32)=Value,EQNewObj.EQLimitYearsNum=Value
			}
			elseif FieldName="ISLHold5"
			{
				;经费来源
				s NewObject.ISLHold5=Value
				s OCLPLIST(60)=Value,OCLNewObj.OCLHold5=Value
				s EQPLIST(96)=Value,EQNewObj.EQHold10=Value
			}
		}
	}
	quit
	
	;更新关联的验收单、入库单、台帐
UpdateBySourceNew
	;更新验收明细单
	s OCLRowID=$p($g(^DHCEQInStockList(BussListID)),"^",19)
	q:OCLRowID=""
	s OCLOldObj=##Class(User.DHCEQOpenCheckList).%OpenId(OCLRowID)
	s OCLOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OCLOldObj).%ToJSON()
	&SQL(Update SQLUSER.DHC_EQOpenCheckList Values:OCLPLIST() where OCL_RowID = :OCLRowID)
	i SQLCODE q SQLCODE
	s OCLNewValue=OCLNewObj.%ToJSON()
	i (OCLNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQOpenCheckList","User.DHCEQOpenCheckList",OCLRowID,"U",OCLNewValue,OCLOldValue,CurUser,DCRRowID)
	i SQLCODE q SQLCODE
	
	;更新验收单信息
	s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	q:OCRRowID=""
	s OCROldObj=##Class(User.DHCEQOpenCheckRequest).%OpenId(OCRRowID)
	s OCROldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OCROldObj).%ToJSON()
	&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values:OCRPLIST() where OCR_RowID = :OCRRowID)
	i SQLCODE q SQLCODE
	s OCRNewValue=OCRNewObj.%ToJSON()
	i (OCRNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQOpenCheckRequest","User.DHCEQOpenCheckRequest",OCRRowID,"U",OCRNewValue,OCROldValue,CurUser,DCRRowID)
	i SQLCODE q SQLCODE
	
	;更新合同信息
	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	q:(OCLSourceType="")||(OCLSourceID="")
	i (OCLSourceType=1)||(OCLSourceType=4)||(OCLSourceType=5)
	{
		s CTLOldObj=##Class(User.DHCEQContractList).%OpenId(OCLSourceID)
		s CTLOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(CTLOldObj).%ToJSON()
		i CTLNewObj.%IsDefined("CTLPriceFee") d
		.s Quantity = $p($g(^DHCEQContractList(OCLSourceID)),"^",7)
		.s TotalFee = CTLNewObj.%Get("CTLPriceFee")*Quantity
		.s CTLPLIST(9) = TotalFee
		.s CTLNewObj.CTLTotalFee = TotalFee
		&SQL(Update SQLUSER.DHC_EQContractList Values:CTLPLIST() where CTL_RowID = :OCLSourceID)
		i SQLCODE q SQLCODE
		s CTLNewValue=CTLNewObj.%ToJSON()
		i (CTLNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQContractList","User.DHCEQContractList",OCLSourceID,"U",CTLNewValue,CTLOldValue,CurUser,DCRRowID)
		i SQLCODE q SQLCODE
		
		s CTRowID=$p($g(^DHCEQContractList(OCLSourceID)),"^",1)
		s CTOldObj=##Class(User.DHCEQContract).%OpenId(CTRowID)
		s CTOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(CTOldObj).%ToJSON()
		&SQL(Update SQLUSER.DHC_EQContract Values:CTPLIST() where CT_RowID = :CTRowID)
		i SQLCODE q SQLCODE
		s CTNewValue=CTNewObj.%ToJSON()
		i (CTNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQContract","User.DHCEQContract",CTRowID,"U",CTNewValue,CTOldValue,CurUser,DCRRowID)
		i SQLCODE q SQLCODE
	}
	
	;更新设备信息
	s SMIDs=""
	s EQStoreLocID=""
	f  s EQStoreLocID=$o(^DHCEQEquip(0,"InStockList",BussListID,EQStoreLocID)) q:(EQStoreLocID="")||(SQLCODE'=0)  d
	.s EQRowID=""
	.f  s EQRowID=$o(^DHCEQEquip(0,"InStockList",BussListID,EQStoreLocID,EQRowID)) q:(EQRowID="")||(SQLCODE'=0)  d
	..q:$p($g(^DHCEQEquip(EQRowID)),"^",59)'="N"
	..q:$p($g(^DHCEQEquip(EQRowID)),"^",60)>1
	..s EQOldObj=##Class(User.DHCEQEquip).%OpenId(EQRowID)
	..s EQOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(EQOldObj).%ToJSON()
	..&SQL(Update SQLUSER.DHC_EQEquip Values:EQPLIST() where EQ_RowID=:EQRowID)
	..q:SQLCODE'=0
	..s EQNewValue=EQNewObj.%ToJSON()
	..i (EQNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQEquip","User.DHCEQEquip",EQRowID,"U",EQNewValue,EQOldValue,CurUser,DCRRowID)
	..q:SQLCODE'=0
	..s ReturnFlag=0
	..s EQSMLRowID=0
	..f  s EQSMLRowID=$o(^DHCEQStoreMoveList(0,"Equip",EQRowID,EQSMLRowID))  q:(EQSMLRowID="")||(SQLCODE'=0)  d
	...s SMRowID=$p($g(^DHCEQStoreMoveList(EQSMLRowID)),"^",1)
	...s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	...q:SMInvalidFlag="Y"
	...s SMLRowID=0
	...f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:(SMLRowID="")||(SQLCODE'=0)  d
	....s SMInStockListDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
	....s SMEquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
	....i SMInStockListDR="" s SMInStockListDR=$p($g(^DHCEQEquip(SMEquipDR)),"^",70)
	....i (SMLNewObj.%ToJSON()'="{}")&&(ISLRowIDs'="")&&((","_ISLRowIDs_",")'[(","_SMInStockListDR_",")) s SQLCODE="-9200"		//修改转移单时才限制转移单包含多个入库单时不允许修改
	...q:SQLCODE'=0
	...;获取转移单ID串
	...i SMIDs="" s SMIDs=SMRowID
	...e  i (","_SMIDs_",")'[(","_SMRowID_",") s SMIDs=SMIDs_","_SMRowID
	...;更新转移单明细信息
	...s SMLOldObj=##Class(User.DHCEQStoreMoveList).%OpenId(EQSMLRowID)
	...s SMLOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(SMLOldObj).%ToJSON()
	...&SQL(Update SQLUSER.DHC_EQStoreMoveList Values:SMLPLIST() where SML_RowID = :EQSMLRowID)
	...q:SQLCODE'=0
	...s SMLNewValue=SMLNewObj.%ToJSON()
	...i (SMLNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQStoreMoveList","User.DHCEQStoreMoveList",EQSMLRowID,"U",SMLNewValue,SMLOldValue,CurUser,DCRRowID)
	...q:SQLCODE'=0
	i SQLCODE q SQLCODE
	
	;更新转移单信息
	d UpdStoreMoveInfo
	
	s SMIDs=""
	s ISSMLRowID=0
	f  s ISSMLRowID=$o(^DHCEQStoreMoveList(0,"InStockList",BussListID,ISSMLRowID))  q:(ISSMLRowID="")||(+SQLCODE'=0)  d
	.s SMRowID=$p($g(^DHCEQStoreMoveList(ISSMLRowID)),"^",1)
	.s SMInvalidFlag=$p($g(^DHCEQStoreMove(SMRowID)),"^",27)
	.q:SMInvalidFlag="Y"
	.s SMEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)
	.s SMLRowID=0
	.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID))  q:(SMLRowID="")||(+SQLCODE'=0)  d
	..s SMInStockDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",4)
	..s SMEquipDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",2)
	..i SMInStockDR="" s SMInStockDR=$p($g(^DHCEQEquip(SMEquipDR)),"^",70)
	..i (SMNewObj.%ToJSON()'="{}")&&(ISLRowIDs'="")&&((","_ISLRowIDs_",")'[(","_SMInStockDR_",")) s SQLCODE="-9200"		//修改转移单时才限制转移单包含多个入库单时不允许修改
	.q:SQLCODE'=0
	.;获取转移单ID串
	.i SMIDs="" s SMIDs=SMRowID
	.e  i (","_SMIDs_",")'[(","_SMRowID_",") s SMIDs=SMIDs_","_SMRowID
	.;更新转移单明细信息
	.s SMLOldObj=##Class(User.DHCEQStoreMoveList).%OpenId(ISSMLRowID)
	.s SMLOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(SMLOldObj).%ToJSON()
	.&SQL(Update SQLUSER.DHC_EQStoreMoveList Values:SMLPLIST() where SML_RowID = :ISSMLRowID)
	.q:SQLCODE'=0
	.s SMLNewValue=SMLNewObj.%ToJSON()
	.i (SMLNewValue'="{}") d
	..s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQStoreMoveList","User.DHCEQStoreMoveList",ISSMLRowID,"U",SMLNewValue,SMLOldValue,CurUser,DCRRowID)
	.q:SQLCODE'=0
	i SQLCODE q SQLCODE
	
	;更新转移单信息
	d UpdStoreMoveInfo
	quit
	
UpdStoreMoveInfo
	s SMIDLen=$l(SMIDs,",")
	f i=1:1:SMIDLen d
	.s SMDR=$p(SMIDs,",",i)
	.q:SMDR=""
	.s SMOldObj=##Class(User.DHCEQStoreMove).%OpenId(SMDR)
	.s SMOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(SMOldObj).%ToJSON()
	.&SQL(Update SQLUSER.DHC_EQStoreMove Values:SMPLIST() where SM_RowID = :SMDR)
	.q:SQLCODE'=0
	.s SMNewValue=SMNewObj.%ToJSON()
	.i (SMNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQStoreMove","User.DHCEQStoreMove",SMDR,"U",SMNewValue,SMOldValue,CurUser,DCRRowID)
	.q:SQLCODE'=0
	i SQLCODE q SQLCODE
	quit
}

/// Creator:CZF
/// CreatDate:2020-09-10
/// Description:通过验收修改相关业务单据信息
/// Input：BussID:表相关ID DataInfo:需修改表字段Json字符串  MainFlag:是否是主表
/// OutPut:SQLCode:修改表数据后SQLCODE
/// Command:w ##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateOpenCheckBusinessNew("")
ClassMethod UpdateOpenCheckBusinessNew(BussID As %Library.String = "", DataInfo As %Library.String = "", MainFlag As %Library.String = "", DealTypes As %Library.String = "", DCRRowID As %Library.String = "")
{
	q:(DataInfo="{}")||(BussID="") 100
	s SQLCODE=0
	s Date=+$h
	s Time=$p($h,",",2)
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	k EQPLIST,CTLPLIST,CTPLIST,ISLPLIST,ISPLIST,SMLPLIST	//czf 2021-08-18
	n EQNewObj,CTLNewObj,CTNewObj,ISLNewObj,SMLNewObj
	s EQNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20 begin
	s CTNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s CTLNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s ISLNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s ISNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()	//czf 2021-08-18
	s SMLNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20 end
	
	s OCLRowID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",BussID,""))
	i OCLRowID="" q 100
	s OCROldObject=##Class(User.DHCEQOpenCheckRequest).%OpenId(BussID)
	s OCRNewObject=OCROldObject
	s OCROldTableObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OCROldObject)
	
	s OCLOldObject=##Class(User.DHCEQOpenCheckList).%OpenId(OCLRowID)
	s OCLNewObject=OCLOldObject
	s OCLOldTableObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OCLOldObject)
	s OCLOldTableObj.OCLLeaveFactoryNos=$g(^DHCEQOpenCheckList(OCLRowID,"EX"))
	s OCLOldTableObj.OCLFileNos=$g(^DHCEQOpenCheckList(OCLRowID,"FileNo"))
	d OCLOldTableObj.%Set("OCLManuFacHandler",$p($g(^DHCEQOpenCheckList(OCLRowID,"MFInfo")),"^",1))	//czf 2021-11-04
	d OCLOldTableObj.%Set("OCLManuFacTel",$p($g(^DHCEQOpenCheckList(OCLRowID,"MFInfo")),"^",2))
	d OCLOldTableObj.%Set("OCLTempBar",$g(^DHCEQOpenCheckList(OCLRowID,"TempBar")))
		
	s DataJson = ##class(web.DHCEQ.Plat.JsonObject).FromJSON(DataInfo)	//CZF0131 2020-01-20
	
	s OCRDataJson=DataJson.OpenCheckRequest
	s OCLDataJson=DataJson.OpenCheckList
	//s FundsDataJson=DataJson.FundsInfo	//{"FundsInfo":[{"FTRowID":"1","FTFunsTypeDR":"1"},{"FTRowID":"2","FTFunsTypeDR":"2"},{"FTRowID":"3","FTFunsTypeDR":"3"},{}]}
	
	i OCRDataJson.%ToJSON()'="{}"
	{
		s MainFlag="Y"
		s newkey=""		//CZF0131 2021-01-20
		For
		{
			s newvalue=OCRDataJson.GetNext(.newkey)
			q:newkey=""
			s FieldName=newkey
		    s Value=newvalue
		   	d GetOpenCheckUpdInfo
		}
		/*
		set iter = OCRDataJson.%GetIterator()
	   	while iter.%GetNext(.key , .newvalue ) {
		    s FieldName=key
		    s Value=newvalue
		   	d GetOpenCheckUpdInfo
	   	}
	   	*/
	}
	i OCLDataJson.%ToJSON()'="{}"
	{
		s MainFlag=""
		s newkey=""		//CZF0131 2021-01-20
		For
		{
			s newvalue=OCLDataJson.GetNext(.newkey)
			q:newkey=""
			s FieldName=newkey
		    s Value=newvalue
		   	d GetOpenCheckUpdInfo
		}
		/*
		set iter = OCLDataJson.%GetIterator()
	   	while iter.%GetNext(.key , .newvalue ) {
		    s FieldName=key
		    s Value=newvalue
		   	d GetOpenCheckUpdInfo
	   	}
	   	*/
	}
	
   	i SQLCODE q SQLCODE
   	
   	;保存验收单变动信息
	s SQLCODE=OCRNewObject.%Save()
	i $$$ISERR(SQLCODE) q SQLCODE
	d OCRNewObject.%Close()
    ;保存验收单变动日志
    
    i OCRDataJson.%ToJSON()'="{}"
    {
		s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQOpenCheckRequest","User.DHCEQOpenCheckRequest",BussID,"U",OCRDataJson.%ToJSON(),OCROldTableObj.%ToJSON(),CurUser,DCRRowID)
		i SQLCODE q SQLCODE
    }
	;保存验收明细变动信息
	s SQLCODE=OCLNewObject.%Save()
	i $$$ISERR(SQLCODE) q SQLCODE
	d OCLNewObject.%Close()
	
	s SQLCODE=0
    ;保存验收明细变动日志
    i OCLDataJson.%ToJSON()'="{}"
    {
		s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQOpenCheckList","User.DHCEQOpenCheckList",OCLRowID,"U",OCLDataJson.%ToJSON(),OCLOldTableObj.%ToJSON(),CurUser,DCRRowID)
		i SQLCODE q SQLCODE
    }
    
    ;更新关联的合同、设备信息、入库单原值、转移单原值
	d UpdateByOpenCheckInfo

    ;更新验收单资金来源  add by czf 20201030
    i (OCLDataJson.%IsDefined("SelfFundsInfo"))||(OCLDataJson.%IsDefined("OtherFundInfo"))		//czf 2021-02-04
   	{
	   	s FundsInfo=""
	   	s FundsTypeDR=0
		f  s FundsTypeDR=$o(^DHCEQTempFunds(0,"Source","0",OCLRowID,FundsTypeDR)) q:(FundsTypeDR="")||(SQLCODE'=0)  d
		.s RowNo=0
		.f  s RowNo=$o(^DHCEQTempFunds(0,"Source","0",OCLRowID,FundsTypeDR,RowNo)) q:(RowNo="")||(SQLCODE'=0)  d
		..s FundsVal=$g(^DHCEQTempFunds(0,"Source","0",OCLRowID,FundsTypeDR,RowNo))
		..q:$p(FundsVal,"^",10)="Y"
		..s TRowID=$p(FundsVal,"^",22)		//modified by czf 2021-01-06 begin 1706105
		..s TFundsTypeDR=$p(FundsVal,"^",2)
		..s TFee=$p(FundsVal,"^",3)
		..q:(+TFee=0)&&(TRowID="")	
		..s TRemark=$p(FundsVal,"^",11)
		..s TOldRowDR=$p(FundsVal,"^",5)
		..s THold1=$p(FundsVal,"^",17)		//IssueDR 研究课题
		..s TPreFundsFee=$p(FundsVal,"^",18)
		..s TPreDepreTotalFee=$p(FundsVal,"^",19)
		..s TFinaceItemDR=$p(FundsVal,"^",20)
		..s TFunctionCatDR=$p(FundsVal,"^",21)
		..s TNo=$p(FundsVal,"^",23)			//modified by czf 2021-01-06 end 1706105
		..s TDepreTotal=$p(FundsVal,"^",13)
		..s FundsList=TRowID_"^"_TFundsTypeDR_"^"_TFee_"^"_TOldRowDR_"^"_TRemark_"^"_TPreDepreTotalFee_"^"_TFinaceItemDR_"^"_TFunctionCatDR_"^"_TNo_"^"_THold1_"^"_TDepreTotal_"^"_TPreFundsFee
		..s OldFundsObject=##class(web.DHCEQ.Plat.JsonObject).%New()
		..s OldFundsObj=##class(web.DHCEQ.Plat.JsonObject).%New()
		..s FundsID=TRowID
		..i TRowID'="" d
		...s OldFundsObject=##Class(User.DHCEQFunds).%OpenId(TRowID)
		...s OldFundsObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldFundsObject)
		..s OldFundsObjStr=OldFundsObj.%ToJSON()
		..s FundsRowID=##Class(web.DHCEQFunds).UpdateFunds("0",OCLRowID,FundsList,"")
		..i FundsRowID<0 s SQLCODE=FundsRowID
		..q:SQLCODE
		..s NewFundObject=##class(web.DHCEQ.Plat.JsonObject).%New()
		..s NewFundObj=##class(web.DHCEQ.Plat.JsonObject).%New()
		..i FundsRowID'=0 d
		...s NewFundObject=##Class(User.DHCEQFunds).%OpenId(FundsRowID)
		...s NewFundObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(NewFundObject)
		...s NewFundObj.FFundsTypeDR=TFundsTypeDR
		...s NewFundObj.FFee=TFee
		...s NewFundObj.FRemark=TRemark
		...s NewFundObj.FOldRowDR=TOldRowDR
		...s NewFundObj.FDepreTotal=TDepreTotal
		...s NewFundObj.FHold1=THold1
		...s NewFundObj.FHold2=TPreFundsFee
		...s NewFundObj.FHold3=TPreDepreTotalFee
		...s NewFundObj.FHold4=TFinaceItemDR
		...s NewFundObj.FHold5=TFunctionCatDR
		...s FundsID=FundsRowID
		..q:FundsID=""
		..s NewFundObjStr=NewFundObj.%ToJSON()
		..;保存验收单资金来源变动日志
    	..s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQFunds","User.DHCEQFunds",FundsID,"U",NewFundObjStr,OldFundsObjStr,CurUser,DCRRowID)
		..q:SQLCODE
		i SQLCODE q SQLCODE
		
		;更新入库单明细资金来源
		s UpdEQSMLRowIDs=""
		s cISLRowID=0
		f  s cISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLRowID,cISLRowID)) q:(cISLRowID="")||(SQLCODE'=0)  d
		.s cISRowID=$p($g(^DHCEQInStockList(cISLRowID)),"^",1)
		.q:$p($g(^DHCEQInStock(cISRowID)),"^",25)="Y"
		.q:$p($g(^DHCEQInStock(cISRowID)),"^",10)="3"	//过滤作废单据
		.;无效设备资金来源
		.s StoreLocDR=0
		.f  s StoreLocDR=$o(^DHCEQEquip(0,"InStockList",cISLRowID,StoreLocDR)) q:(StoreLocDR="")||(SQLCODE'=0)  d
		..s cEQRowID=0
		..f  s cEQRowID=$o(^DHCEQEquip(0,"InStockList",cISLRowID,StoreLocDR,cEQRowID)) q:(cEQRowID="")||(SQLCODE'=0)  d
		...q:$p($g(^DHCEQEquip(cEQRowID)),"^",59)="Y"
		...s FundsRowID=0
		...f  s FundsRowID=$o(^DHCEQFunds("0","Source",1,cEQRowID,FundsRowID))  q:(FundsRowID="")||(SQLCODE'=0)  d
		....q:$p($g(^DHCEQFunds(FundsRowID)),"^",10)="Y"
		....s OldFundsObject=##Class(User.DHCEQFunds).%OpenId(FundsRowID)
		....s OldFundsObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldFundsObject)
		....s OldFundsObjStr=OldFundsObj.%ToJSON()
		....&SQL(Update SQLUSER.DHC_EQFunds Set F_InvalidFlag='Y' where F_RowID=:FundsRowID)
		....q:SQLCODE'=0
		....s NewFundObj=OldFundsObj
		....s NewFundObj.FInvalidFlag="Y"
		....s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQFunds","User.DHCEQFunds",FundsRowID,"U",NewFundObj.%ToJSON(),OldFundsObjStr,CurUser,DCRRowID)
		.q:SQLCODE'=0
		.s Quantity=+$Piece($Get(^DHCEQInStockList(cISLRowID)),"^",8)
		.s Price=+$Piece($Get(^DHCEQInStockList(cISLRowID)),"^",7)
		.s Amount=Quantity*Price
		.s SourceType=3,SourceID=cISLRowID
		.d UpdFundsInfoBySource
		.q:SQLCODE
		.s SMLRowID=0
		.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"InStockList",cISLRowID,SMLRowID)) q:(SMLRowID="")||(SQLCODE'=0)  d
		..s SMRowID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
		..q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)="Y"
		..q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)="3"
		..i UpdEQSMLRowIDs="" s UpdEQSMLRowIDs=SMLRowID
		..e  i (","_UpdEQSMLRowIDs_",")'[(","_SMLRowID_",") s UpdEQSMLRowIDs=UpdEQSMLRowIDs_","_SMLRowID
		
		;更新设备资金来源
		s SMIDs=""
		s EQRowID=""
		f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID)) q:(EQRowID="")||(SQLCODE'=0)  d
		.q:$p($g(^DHCEQEquip(EQRowID)),"^",59)="Y"
		.s Quantity=1
		.s Price=+$Piece($g(^DHCEQEquip(EQRowID)),"^",27)
		.s Amount=Quantity*Price
		.s SourceType=1,SourceID=EQRowID
		.d UpdFundsInfoBySource
		.q:SQLCODE
		.s EQSMLRowID=0
		.f  s EQSMLRowID=$o(^DHCEQStoreMoveList(0,"Equip",EQRowID,EQSMLRowID))  q:(EQSMLRowID="")||(SQLCODE'=0)  d
		..s SMRowID=$p($g(^DHCEQStoreMoveList(EQSMLRowID)),"^",1)
		..q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)="Y"
		..q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)="3"	
		..i UpdEQSMLRowIDs="" s UpdEQSMLRowIDs=EQSMLRowID
		..e  i (","_UpdEQSMLRowIDs_",")'[(","_EQSMLRowID_",") s UpdEQSMLRowIDs=UpdEQSMLRowIDs_","_EQSMLRowID
		i SQLCODE q SQLCODE
		
		;更新转移单明细资金来源	czf 2020-12-16
		i UpdEQSMLRowIDs'=""
		{
			s SMLLen=$l(UpdEQSMLRowIDs,",")
			f j=1:1:SMLLen d
			.s cSMLRowID=$p(UpdEQSMLRowIDs,",",j)
			.q:cSMLRowID=""
			.s Quantity=+$Piece($Get(^DHCEQStoreMoveList(cSMLRowID)),"^",8)
			.s Price=+$Piece($Get(^DHCEQStoreMoveList(cSMLRowID)),"^",7)
			.s Amount=Quantity*Price
			.s SourceType=4,SourceID=cSMLRowID
			.d UpdFundsInfoBySource
			.q:SQLCODE
			i SQLCODE q SQLCODE
		}
	}
	
	;审核成功，清除临时global内容
	i SQLCODE=0 k ^DHCEQTempFunds(0,"Source","0",OCLRowID)
	
	q SQLCODE

	;无效旧的资金来源记录并生成新的资金来源
UpdFundsInfoBySource
		i SourceType'=1
		{
			s FundsRowID=0
			f  s FundsRowID=$o(^DHCEQFunds("0","Source",SourceType,SourceID,FundsRowID))  q:(FundsRowID="")||(SQLCODE'=0)  d
			.q:$p($g(^DHCEQFunds(FundsRowID)),"^",10)="Y"
			.s OldFundsObject=##Class(User.DHCEQFunds).%OpenId(FundsRowID)
			.s OldFundsObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldFundsObject)
			.s OldFundsObjStr=OldFundsObj.%ToJSON()
			.&SQL(Update SQLUSER.DHC_EQFunds Set F_InvalidFlag='Y' where F_RowID=:FundsRowID)	//无效原来的资金来源
			.q:SQLCODE'=0
			.s NewFundObj=OldFundsObj
			.s NewFundObj.FInvalidFlag="Y"
			.s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQFunds","User.DHCEQFunds",FundsRowID,"U",NewFundObj.%ToJSON(),OldFundsObjStr,CurUser,DCRRowID)
			.q:SQLCODE'=0
			i SQLCODE q SQLCODE
		}

		i SourceType=3
		{
			s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfoByISLID(SourceID,$h)
		}
		elseif SourceType=4
		{
			s SQLCODE=##class(web.DHCEQInStockNew).CreateFundsInfo(SourceType,SourceID)
		}
		i SQLCODE q SQLCODE
		
		s FundsRowID=0
		f  s FundsRowID=$o(^DHCEQFunds("0","Source",SourceType,SourceID,FundsRowID))  q:((FundsRowID=""))||(SQLCODE'=0)  d
		.q:$p($g(^DHCEQFunds(FundsRowID)),"^",10)="Y"
		.s NewFundsObject=##Class(User.DHCEQFunds).%OpenId(FundsRowID)
		.s NewFundsObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(NewFundsObject)
		.s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQFunds","User.DHCEQFunds",FundsRowID,"A",NewFundsObj.%ToJSON(),"{}",CurUser,DCRRowID)
		.q:SQLCODE'=0
		
		quit
		
	;获取更新字段
GetOpenCheckUpdInfo	
	if FieldName="OCRCheckDate"
	{
		s Value=##Class(web.DHCEQCommon).TransValueFromPage(Value,"date")
		s OCRNewObject.OCRCheckDate=Value
	}
	elseif FieldName="OCROpenCheckDate"
	{
		s Value=##Class(web.DHCEQCommon).TransValueFromPage(Value,"date")
		s OCRNewObject.OCROpenCheckDate=Value
	}
	elseif FieldName="OCREquipTypeDR"
	{
		d OCRNewObject.OCREquipTypeDRSetObjectId(Value)
		d OCLNewObject.OCLEquipTypeDRSetObjectId(Value)
		s EQPLIST(64)=Value,EQNewObj.EQEquipTypeDR=Value
	}
	elseif FieldName="OCRStatCatDR"
	{
		d OCRNewObject.OCRStatCatDRSetObjectId(Value)
		d OCLNewObject.OCLStatCatDRSetObjectId(Value)
		s EQPLIST(76)=Value,EQNewObj.EQStatCatDR=Value
		s ISLPLIST(18)=Value,ISLNewObj.ISLStatCatDR=Value	//czf 2021-07-20
	}
	elseif FieldName="OCRProviderDR"
	{
		d OCRNewObject.OCRProviderDRSetObjectId(Value)
		s CTPLIST(19)=Value,CTNewObj.CTProviderDR=Value
		s EQPLIST(26)=Value,EQNewObj.EQProviderDR=Value
	}
	elseif FieldName="OCRProviderHandler"
	{
		s OCRNewObject.OCRProviderHandler=Value
		s CTPLIST(21)=Value,CTNewObj.CTProviderHandler=Value
		s EQPLIST(42)=Value,EQNewObj.EQProviderHandler=Value
	}
	elseif FieldName="OCRProviderTel"
	{
		s OCRNewObject.OCRProviderTel=Value
		s CTPLIST(20)=Value,CTNewObj.CTProviderTel=Value
		s EQPLIST(43)=Value,EQNewObj.EQProviderTel=Value
	}
	elseif FieldName="OCROriginDR"
	{
		d OCRNewObject.OCROriginDRSetObjectId(Value)
		s ISPLIST(16)=Value,ISNewObj.ISLOriginDR=Value		//czf 2021-08-18
		s EQPLIST(21)=Value,EQNewObj.EQOriginDR=Value
	}
	elseif FieldName="OCRConfigState"
	{
		s OCRNewObject.OCRConfigState=Value
	}
	elseif FieldName="OCRRunningState"
	{
		s OCRNewObject.OCRRunningState=Value
	}
	elseif FieldName="OCRFileState"
	{
		s OCRNewObject.OCRFileState=Value
	}
	elseif FieldName="OCRPackageState"
	{
		s OCRNewObject.OCRPackageState=Value
	}
	elseif FieldName="OCRRemark"		//czf 2021-01-25
	{
		s OCRNewObject.OCRRemark=Value
	}
	elseif FieldName="OCLContractNo"
	{
		s OCLNewObject.OCLContractNo=Value
		s EQPLIST(77)=Value,EQNewObj.EQContractNo=Value
	}
	elseif FieldName="OCLHold2"
	{
		;注册证号
		s OCLNewObject.OCLHold2=Value
		s EQPLIST(93)=Value,EQNewObj.EQRegistrationNo=Value
	}
	elseif FieldName="OCLName"
	{
		s OCLNewObject.OCLName=Value
		s EQPLIST(2)=Value,EQNewObj.EQName=Value
		s CTLPLIST(3)=Value,CTLNewObj.CTLName=Value
		s ISLPLIST(6)=Value,ISLNewObj.ISLEquipName=Value		//czf 2021-02-04
		s SMLPLIST(6)=Value,SMLNewObj.SMLEquipName=Value
	}
	elseif FieldName="OCLModelDR"
	{
		d OCLNewObject.OCLModelDRSetObjectId(Value)
		s EQPLIST(4)=Value,EQNewObj.EQModelDR=Value
		s CTLPLIST(4)=Value,CTLNewObj.CTLModelDR=Value
		s ISLPLIST(10)=Value,ISLNewObj.ISLModelDR=Value		//czf 2021-02-04
		s SMLPLIST(10)=Value,SMLNewObj.SMLModelDR=Value
	}
	elseif FieldName="OCLUnitDR"
	{
		s OCLNewObject.OCLUnitDR=Value
		s EQPLIST(6)=Value,EQNewObj.EQUnitDR=Value
		s ISLPLIST(11)=Value,ISLNewObj.ISLUnitDR=Value		//czf 2021-02-04
		s SMLPLIST(11)=Value,SMLNewObj.SMLUnitDR=Value		
	}
	elseif FieldName="OCLOriginalFee"
	{
		s OCLNewObject.OCLOriginalFee=Value
		s EQPLIST(28)=Value,EQNewObj.EQOriginalFee=Value
		s EQPLIST(29)=Value,EQNewObj.EQNetFee=Value
		s CTLPLIST(7)=Value,CTLNewObj.CTLPriceFee=Value
		s ISLPLIST(8)=Value,ISLNewObj.ISLOriginalFee=Value
		s SMLPLIST(8)=Value,SMLNewObj.SMLOriginalFee=Value
	}
	elseif FieldName="OCLManuFactoryDR"
	{
		d OCLNewObject.OCLManuFactoryDRSetObjectId(Value)
		s EQPLIST(27)=Value,EQNewObj.EQManuFactoryDR=Value
		s CTLPLIST(5)=Value,CTLNewObj.CTLManuFactoryDR=Value
		s ISLPLIST(7)=Value,ISLNewObj.ISLManuFactoryDR=Value	//czf 2021-02-04
		s SMLPLIST(7)=Value,SMLNewObj.SMLManuFactoryDR=Value
	}
	elseif FieldName="OCLEquipTypeDR"
	{
		d OCRNewObject.OCREquipTypeDRSetObjectId(Value)
		d OCLNewObject.OCLEquipTypeDRSetObjectId(Value)
		s EQPLIST(64)=Value,EQNewObj.EQEquipTypeDR=Value
	}
	elseif FieldName="OCLStatCatDR"
	{
		d OCRNewObject.OCRStatCatDRSetObjectId(Value)
		d OCLNewObject.OCLStatCatDRSetObjectId(Value)
		s EQPLIST(76)=Value,EQNewObj.EQStatCatDR=Value
		s ISLPLIST(18)=Value,ISLNewObj.ISLStatCatDR=Value	//czf 2021-02-04
	}
	elseif FieldName="OCLEquiCatDR"
	{
		d OCLNewObject.OCLEquiCatDRSetObjectId(Value)  //modify by jyp 2021-06-29
		s EQPLIST(5)=Value,EQNewObj.EQEquiCatDR=Value
		s ISLPLIST(15)=Value,ISLNewObj.ISLEquiCatDR=Value	//czf 2021-02-04
	}
	elseif FieldName="OCLLimitYearsNum"
	{
		s OCLNewObject.OCLLimitYearsNum=Value
		s EQPLIST(32)=Value,EQNewObj.EQLimitYearsNum=Value
		s ISLPLIST(16)=Value,ISLNewObj.ISLLimitYearsNum=Value		//czf 2021-02-04
	}
	elseif FieldName="OCLGuaranteePeriodNum"
	{
		s OCLNewObject.OCLGuaranteePeriodNum=Value
		s EQPLIST(74)=Value,EQNewObj.EQGuaranteePeriodNum=Value
	}
	elseif FieldName="OCLCountryDR"
	{
		s OCLNewObject.OCLCountryDR=Value
		s EQPLIST(17)=Value,EQNewObj.EQCountryDR=Value
	}
	elseif FieldName="OCLHold5"
	{
		;经费来源
		s OCLNewObject.OCLHold5=Value
		s EQPLIST(96)=Value,EQNewObj.EQHold10=Value
		s ISLPLIST(24)=Value,ISLNewObj.ISLHold5=Value		//czf 2021-02-04
	}
	elseif FieldName="OCLPurchaseTypeDR"
	{
        ///modified by ZY 20221107 2886062
        d OCRNewObject.OCRPurchaseTypeDRSetObjectId(Value)
		d OCLNewObject.OCLPurchaseTypeDRSetObjectId(Value)
		s EQPLIST(65)=Value,EQNewObj.EQPurchaseTypeDR=Value
	}
	elseif FieldName="OCLPurposeTypeDR"
	{
		d OCLNewObject.OCLPurposeTypeDRSetObjectId(Value)
		s EQPLIST(66)=Value,EQNewObj.EQPurposeTypeDR=Value
	}
	elseif FieldName="OCLBuyTypeDR"
	{
		d OCLNewObject.OCLBuyTypeDRSetObjectId(Value)
		s EQPLIST(24)=Value,EQNewObj.EQBuyTypeDR=Value
	}
	elseif FieldName="OCLDepreMethodDR"
	{
		d OCLNewObject.OCLDepreMethodDRSetObjectId(Value)
		s EQPLIST(34)=Value,EQNewObj.EQDepreMethodDR=Value
	}
	elseif FieldName="OCLLeaveFactoryNos"
	{
		s ^DHCEQOpenCheckList(OCLRowID,"EX")=Value
		//s OCLNewObject.OCLLeaveFactoryNos=Value
		//s EQPLIST(11)=Value,EQNewObj.EQLeaveFactoryNo=Value
	}
	elseif FieldName="OCLFileNos"
	{
		s ^DHCEQOpenCheckList(OCLRowID,"FileNo")=Value
		//s OCLNewObject.OCLFileNos=Value
		//s EQPLIST(86)=Value,EQNewObj.EQFileNo=Value
	}
	elseif FieldName="OCLManuFacHandler"	//czf 2021-11-04 begin
	{
		s MFInfo=$g(^DHCEQOpenCheckList(OCLRowID,"MFInfo"))
		s $p(MFInfo,"^",1)=Value
		s ^DHCEQOpenCheckList(OCLRowID,"MFInfo")=MFInfo
	}
	elseif FieldName="OCLManuFacTel"
	{
		s MFInfo=$g(^DHCEQOpenCheckList(OCLRowID,"MFInfo"))
		s $p(MFInfo,"^",2)=Value
		s ^DHCEQOpenCheckList(OCLRowID,"MFInfo")=MFInfo
	}
	elseif FieldName="OCLTempBar"
	{
		s ^DHCEQOpenCheckList(OCLRowID,"TempBar")=Value
	}
	elseif FieldName="OCLHold12"
	{
		s OCLNewObject.OCLHold12=Value
		s EQPLIST(100)=Value,EQNewObj.EQPower=Value		//czf 2021-11-04 end
	}
	elseif FieldName="OCLRemark"
	{
		s OCLNewObject.OCLRemark=Value
	}
	elseif FieldName="OCLUseLocDR"
	{
		s OCLNewObject.OCLUseLocDR=Value
		s EQPLIST(20)=Value,EQNewObj.EQUseLocDR=Value
		//add by ZY0273 20210705
		s OCLLRowID=$o(^DHCEQOpenCheckListLoc(0,"OpenCheckList",OCLRowID,0))
		if (OCLLRowID'="")
		{
			&SQL(Update SQLUSER.DHC_EQOpenCheckListLoc set OCLL_BuyLocDR=:Value where OCLL_RowID = :OCLLRowID)
		}
	}
	elseif FieldName="OCLLeaveFactoryDate"
	{
		s Value=##Class(web.DHCEQCommon).TransValueFromPage(Value,"date")
		s OCLNewObject.OCLLeaveFactoryDate=Value
		s EQPLIST(12)=Value,EQNewObj.EQLeaveFactoryDate=Value
	}
	elseif FieldName="OCLLocationDR"
	{
		d OCLNewObject.OCLLocationDRSetObjectId(Value)
		s EQPLIST(73)=Value,EQNewObj.EQLocationDR=Value
	}
	quit
	
UpdateByOpenCheckInfo
	;更新合同信息
	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	q:(OCLSourceType="")||(OCLSourceID="")
	i (OCLSourceType=1)||(OCLSourceType=4)||(OCLSourceType=5)
	{
		s CTLOldObj=##Class(User.DHCEQContractList).%OpenId(OCLSourceID)
		s CTLOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(CTLOldObj).%ToJSON()
		
		i CTLNewObj.%IsDefined("CTLPriceFee") d
		.s Quantity = $p($g(^DHCEQContractList(OCLSourceID)),"^",7)
		.s TotalFee = CTLNewObj.%Get("CTLPriceFee")*Quantity
		.s CTLPLIST(9) = TotalFee
		.s CTLNewObj.CTLTotalFee = TotalFee
		&SQL(Update SQLUSER.DHC_EQContractList Values:CTLPLIST() where CTL_RowID = :OCLSourceID)
		i SQLCODE q SQLCODE
		s CTLNewValue=CTLNewObj.%ToJSON()
		i (CTLNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQContractList","User.DHCEQContractList",OCLSourceID,"U",CTLNewValue,CTLOldValue,CurUser,DCRRowID)
		i SQLCODE q SQLCODE
		
		s CTRowID=$p($g(^DHCEQContractList(OCLSourceID)),"^",1)
		s CTOldObj=##Class(User.DHCEQContract).%OpenId(CTRowID)
		s CTOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(CTOldObj).%ToJSON()
		&SQL(Update SQLUSER.DHC_EQContract Values:CTPLIST() where CT_RowID = :CTRowID)
		i SQLCODE q SQLCODE
		s CTNewValue=CTNewObj.%ToJSON()
		i (CTNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQContract","User.DHCEQContract",CTRowID,"U",CTNewValue,CTOldValue,CurUser,DCRRowID)
		i SQLCODE q SQLCODE
	}
	
	s FileNos=$g(^DHCEQOpenCheckList(OCLRowID,"FileNo"))
	s LeaveFacNos=$g(^DHCEQOpenCheckList(OCLRowID,"EX"))
	s TempBar=$g(^DHCEQOpenCheckList(OCLRowID,"TempBar"))	//czf 2021-11-04
	s SplitFlag=##class(web.DHCEQCommon).GetSysInfo("990035")	//验收时档案号是否拆分
	s EQNum=1
	
	;更新入库信息
	s ISLRowID=0
	f  s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLRowID,ISLRowID)) q:(ISLRowID="")||(SQLCODE'=0)  d
	.s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	.q:$p($g(^DHCEQInStock(ISRowID)),"^",25)="Y"
	.q:$p($g(^DHCEQInStock(ISRowID)),"^",10)="3"	//过滤作废单据
	.s ISLOldObj=##Class(User.DHCEQInStockList).%OpenId(ISLRowID)
	.s ISLOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ISLOldObj).%ToJSON()
	.&SQL(Update SQLUSER.DHC_EQInStockList Values:ISLPLIST() where ISL_RowID = :ISLRowID)
	.q:SQLCODE'=0
	.s ISLNewValue=ISLNewObj.%ToJSON()
	.i (ISLNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQInStockList","User.DHCEQInStockList",ISLRowID,"U",ISLNewValue,ISLOldValue,CurUser,DCRRowID)
	.q:SQLCODE'=0
	.;更新入库主单信息 czf 2021-08-18 begin
	.s ISOldObj=##Class(User.DHCEQInStock).%OpenId(ISRowID)
	.s ISOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(ISOldObj).%ToJSON()
	.&SQL(Update SQLUSER.DHC_EQInStock Values:ISPLIST() where IS_RowID = :ISRowID)
	.q:SQLCODE'=0
	.s ISNewValue=ISNewObj.%ToJSON()
	.i (ISNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQInStock","User.DHCEQInStock",ISRowID,"U",ISNewValue,ISOldValue,CurUser,DCRRowID)
	.q:SQLCODE'=0	;czf 2021-08-18 end
	.;更新转移单明细信息
	.s SMLRowID=0
	.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"InStockList",ISLRowID,SMLRowID)) q:(SMLRowID="")||(SQLCODE'=0)  d
	..s SMRowID=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",1)
	..q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)="Y"
	..q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)="3"
	..s SMLOldObj=##Class(User.DHCEQStoreMoveList).%OpenId(SMLRowID)
	..s SMLOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(SMLOldObj).%ToJSON()
	..&SQL(Update SQLUSER.DHC_EQStoreMoveList Values:SMLPLIST() where SML_RowID = :SMLRowID)
	..q:SQLCODE'=0
	..s SMLNewValue=SMLNewObj.%ToJSON()
	..i (SMLNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQStoreMoveList","User.DHCEQStoreMoveList",SMLRowID,"U",SMLNewValue,SMLOldValue,CurUser,DCRRowID)
	..q:SQLCODE'=0
	
	;更新设备信息
	s SMIDs=""
	s EQRowID=""
	f  s EQRowID=$o(^DHCEQEquip(0,"OpenCheckList",OCLRowID,EQRowID)) q:(EQRowID="")||(SQLCODE'=0)  d
	.s EQOldObj=##Class(User.DHCEQEquip).%OpenId(EQRowID)
	.s EQOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(EQOldObj).%ToJSON()
	.q:$p($g(^DHCEQEquip(EQRowID)),"^",59)'="N"
	.q:$p($g(^DHCEQEquip(EQRowID)),"^",60)=3
	.i SplitFlag=1 s EQPLIST(86) = ##class(web.DHCEQCommon).Replace($Piece(FileNos, ",", EQNum),$C(13,10),"")
	.e  s EQPLIST(86) = FileNos
	.s EQPLIST(11) = ##class(web.DHCEQCommon).Replace($P(LeaveFacNos, ",", EQNum),$C(13,10),"")
	.&SQL(Update SQLUSER.DHC_EQEquip Values:EQPLIST() where EQ_RowID=:EQRowID)
	.q:SQLCODE'=0
	.i EQOldObj.EQLeaveFactoryNo'=$p(^DHCEQEquip(EQRowID),"^",10) s EQNewObj.EQLeaveFactoryNo=$p(^DHCEQEquip(EQRowID),"^",10)
	.i EQOldObj.EQFileNo'=$p(^DHCEQEquip(EQRowID),"^",85) s EQNewObj.EQFileNo=$p(^DHCEQEquip(EQRowID),"^",85)
	.s EQNewValue=EQNewObj.%ToJSON()
	.i (EQNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQEquip","User.DHCEQEquip",EQRowID,"U",EQNewValue,EQOldValue,CurUser,DCRRowID)
	.q:SQLCODE'=0
	.;更新临时码	//czf 2021-11-04 begin
	.s FindBindRowID=0
	.s BOBindNo=##class(web.DHCEQCommon).Replace($P(TempBar, ",", EQNum),$C(13,10),"")
	.s BORowID=0
	.f  s BORowID=$o(^DHCEQBindObj(0,"SourceID","N",1,EQRowID,BORowID)) q:(BORowID="")||(SQLCODE'=0)  d
	..q:$p($g(^DHCEQBindObj(BORowID)),"^",3)'=2
	..s FindBindRowID=1
	..q:$p($g(^DHCEQBindObj(BORowID)),"^",5)=BOBindNo
	..&SQL(Update SQLUSER.DHC_EQBindObj Set BO_BindNo=:BOBindNo,BO_BindUserDR=:CurUser,BO_FromDate=:Date,BO_FromTime=:Time where BO_RowID=:BORowID)
	.i (FindBindRowID=0)&&(BOBindNo'="") d
	..&sql(Insert Into sqluser.DHC_EQBindObj(BO_SourceType,BO_SourceID,BO_BindType,BO_BindNo,BO_BindUserDR,BO_FromDate,BO_FromTime) values('1',:EQRowID,'2',:BOBindNo,:CurUser,:Date,:Time))
	.q:SQLCODE'=0	//czf 2021-11-04 end
	.s EQNum=EQNum+1
	.s EQSMLRowID=0
	.f  s EQSMLRowID=$o(^DHCEQStoreMoveList(0,"Equip",EQRowID,EQSMLRowID))  q:(EQSMLRowID="")||(SQLCODE'=0)  d
	..s SMRowID=$p($g(^DHCEQStoreMoveList(EQSMLRowID)),"^",1)
	..q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)="Y"
	..q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)="3"
	..;更新转移单明细信息
	..s SMLOldObj=##Class(User.DHCEQStoreMoveList).%OpenId(EQSMLRowID)
	..s SMLOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(SMLOldObj).%ToJSON()
	..&SQL(Update SQLUSER.DHC_EQStoreMoveList Values:SMLPLIST() where SML_RowID = :EQSMLRowID)
	..q:SQLCODE'=0
	..s SMLNewValue=SMLNewObj.%ToJSON()
	..i (SMLNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQStoreMoveList","User.DHCEQStoreMoveList",EQSMLRowID,"U",SMLNewValue,SMLOldValue,CurUser,DCRRowID)
	..q:SQLCODE'=0
	
	i SQLCODE q SQLCODE
	
	quit
}

/// Creator:CZF
/// CreatDate:2020-09-10
/// Description:判断验收单关联的入库单是否已跨月或已入账
/// Input：OCRID:验收单RowID
/// OutPut:Flag:0:验收单不存在 1:入库单已跨月 2:已入账
/// Command:w ##Class(web.DHCEQ.Plat.LIBBusinessModify).CheckInStockByOpenCheckID("")
ClassMethod CheckInStockByOpenCheckID(OCRID)
{
	s Flag=0
	s ErrorMsg=""
	s OCLID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",OCRID,""))
	i OCLID="" q "-1^验收单不存在!"
	s ISLRowID=""
	f  s ISLRowID=$o(^DHCEQInStockList(0,"Source",2,OCLID,ISLRowID)) q:(ISLRowID="")||(Flag'=0)    d
	.s ISRowID=$p($g(^DHCEQInStockList(ISLRowID)),"^",1)
	.s ISInvalidFlag=$p($g(^DHCEQInStock(ISRowID)),"^",25)
	.q:ISInvalidFlag'="N"
	.s ISStatus=$p($g(^DHCEQInStock(ISRowID)),"^",10)
	.q:(ISStatus'=2)
	.s ISAuditDate=$p($g(^DHCEQInStock(ISRowID)),"^",7)
	.s CurMonth=##Class(web.DHCEQReport).GetReportMonthByDate(+$H)
	.s BussMonth=##Class(web.DHCEQReport).GetReportMonthByDate(ISAuditDate)
	.i CurMonth'=BussMonth s Flag=1,ErrorMsg="入库单已跨月,不能修改!"
	.q:Flag'=0
	.s AccountListID=0
	.f  s AccountListID=$o(^DHCEQAccountList(0,"InStockList",ISLRowID,AccountListID))  q:(AccountListID="")||(Flag'=0)  d
	..q:$p($g(^DHCEQAccountList(AccountListID)),"^",10)="Y"
	..s Flag=2,ErrorMsg="已入账,不能修改!"
	.q:Flag'=0
	
	q Flag_"^"_ErrorMsg
}

/// add by czf 2020-12-16
/// 判断单据关联设备是否存在调账记录，若存在，无法调整金额及资金来源
/// w ##Class(web.DHCEQ.Plat.LIBBusinessModify).CheckEquipChangeAccount("")
ClassMethod CheckEquipChangeAccount(BussType, BussID, MainFlag As %String = "")
{
	n (ISLRowID,BussType, BussID,MainFlag)
	i (BussType="")||(BussID="") q "业务单类型或业务单ID为空！"
	s RtnMsg="",Find=0
	if BussType="11"
	{
		s OCLID=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",BussID,""))
		i OCLID="" q "验收单不存在！"
		
		s EQID=""
		f  s EQID=$o(^DHCEQEquip(0,"OpenCheckList",OCLID,EQID)) q:(EQID="")||(Find'=0)  d
		.d CheckEQChangeAccount
	}
	elseif BussType="21"
	{
		i MainFlag="Y"
		{
			s ISLRowID=""
			f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",BussID,ISLRowID)) q:(ISLRowID="")||(Find'=0)  d
			.d CheckInStockListEquip
		}
		else
		{
			s ISLRowID=BussID
			d CheckInStockListEquip
		}
	}
	q RtnMsg

CheckInStockListEquip
	s EQStoreLocID=""
	f  s EQStoreLocID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,EQStoreLocID)) q:(EQStoreLocID="")||(Find'=0)  d
	.s EQID=""
	.f  s EQID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,EQStoreLocID,EQID)) q:(EQID="")||(Find'=0)  d
	..d CheckEQChangeAccount
	quit
CheckEQChangeAccount
	s CAID=""
	f  s CAID=$o(^DHCEQChangeAccount(0,"Equip",EQID,CAID)) q:(CAID="")||(Find'=0)  d
	.s CAStatus=$p($g(^DHCEQChangeAccount(CAID)),"^",11)
	.s EQName=$p($g(^DHCEQEquip(EQID)),"^",1)
	.s EQNo=$p($g(^DHCEQEquip(EQID)),"^",71)
	.s Find=1,RtnMsg="设备:"_EQName_"存在调账记录,不能调整金额和资金来源！设备编号:"_EQNo
	quit
}

/// Creator：      ZY0252
/// CreatDate：    2021-01-29
/// Description:   获取合同明细
/// Input：        ContractNo:合同单号
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.LIBBusinessModify","GetContractList","HT2020070001")
Query GetContractList(ContractNo) As %Query(ROWSPEC = "TRowID:%String,TContractDR:%String,TEquipName:%String,TModel:%String,TSourceType:%String,TOriginalFee:%String,TQuantityNum:%String,TTotal:%String,TRemark:%String,TContractArriveDate:%String,TArriveDate:%String,TArriveQuantityNum:%String,TGuaranteePeriodNum:%String,TItem:%String,TDCRRowID:%String,TDCRStatus:%String")
{
}

ClassMethod GetContractListExecute(ByRef qHandle As %Binary, ContractNo) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	q:ContractNo=""
	s ContractDR=$o(^DHCEQContract(0,"ContractNo",ContractNo,""))
	q:ContractDR=""
	f  s rowid=$o(^DHCEQContractList(0,"Contract",ContractDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetContractList
	.s Datalist=$g(^DHCEQContractList(rowid))
	.s TRowID = rowid
	.s TContractDR = $p(Datalist,"^",1)
	.s TEquipName = $p(Datalist,"^",2)
	.s TModelDR = $p(Datalist,"^",3)
	.s TModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	.s TManuFactoryDR = $p(Datalist,"^",4)
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
	.s TSourceTypeDR = $p(Datalist,"^",5)
	.s TSourceType=$CASE(TSourceTypeDR,"1":"计划","2":"招标","3":"设备项","4":"设备","5":"入库明细","6":"配件项","7":"验收单","":"")
	.s TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($p(Datalist,"^",6),"")
	.s TQuantityNum = ##Class(web.DHCEQCommon).FormatNumber($p(Datalist,"^",7),"")
	.s TTotal=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee*TQuantityNum,"")
	.s TRemark = $p(Datalist,"^",9)
	.s TContractArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",10),"date")
	.s TArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",11),"date")
	.s TArriveQuantityNum = $p(Datalist,"^",12)
	.s TGuaranteePeriodNum = $p(Datalist,"^",16)
	.s TItemDR=$p(Datalist,"^",18)
	.
	.i TItemDR'="" d
	..s TItem=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	..;s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)	//取消来源取值设备名称
	..Set TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
	..Set TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	.s TBrandDR = $p(Datalist,"^",19)
	.s TImportFlag = $p(Datalist,"^",20)
	.s TGuaranteeContent = $p(Datalist,"^",21)
	.s TMaintCountType = $p(Datalist,"^",22)
	.s TMaintTimes = $p(Datalist,"^",23)
	.s THold1 = $p(Datalist,"^",24)  //注册证号
	.s THold2 = $p(Datalist,"^",25)
	.s THold2ETDesc=##class(web.DHCEQCommon).GetTrakNameByID("equiptype", THold2)
	.if TSourceTypeDR=6 Set THold2ETDesc=##class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", THold2)
	.s THold3 = $p(Datalist,"^",26)
	.s THold4 = $p(Datalist,"^",27)
	.s THold5 = $p(Datalist,"^",28)
	.s Find=0		//add by czf 2020-08-18 begin
	.s DCRID=""
	.f  s DCRID=$o(^DHCEQDataChangeRequest(0,"TableName","DHC_EQContractList",rowid,DCRID)) q:(DCRID="")||(Find=1)  d
	..q:$p($g(^DHCEQDataChangeRequest(DCRID)),"^",14)="Y"
	..q:$p($g(^DHCEQDataChangeRequest(DCRID)),"^",13)="2"
	..s Find=1
	..s TDCRRowID=DCRID
	..s TDCRStatus=$p($g(^DHCEQDataChangeRequest(DCRID)),"^",13)	//add by czf 2020-08-18 end
	.d OutputRowGetContractList
		
	Quit $$$OK
OutputRowGetContractList
	s Data=$lb(TRowID,TContractDR,TEquipName,TModel,TSourceType,TOriginalFee,TQuantityNum,TTotal,TRemark,TContractArriveDate,TArriveDate,TArriveQuantityNum,TGuaranteePeriodNum,TItem,TDCRRowID,TDCRStatus)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractList
	s (TRowID,TContractDR,TEquipName,TModel,TSourceType,TOriginalFee,TQuantityNum,TTotal,TRemark,TContractArriveDate,TArriveDate,TArriveQuantityNum,TGuaranteePeriodNum,TItem,TDCRRowID,TDCRStatus)=""
	quit
}

ClassMethod GetContractListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractListExecute ]
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

ClassMethod GetContractListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator:ZY
/// CreatDate:2021-01-30
/// Description:通过合同修改相关业务单据信息
/// Input：BussID:表相关ID DataInfo:需修改表字段Json字符串  MainFlag:是否是主表
/// OutPut:SQLCode:修改表数据后SQLCODE
/// Command:w ##Class(web.DHCEQ.Plat.LIBBusinessModify).UpdateContractBusinessNew("")
ClassMethod UpdateContractBusinessNew(BussID As %Library.String = "", DataInfo As %Library.String = "", MainFlag As %Library.String = "", DealTypes As %Library.String = "", DCRRowID As %Library.String = "")
{
	q:(DataInfo="{}")||(BussID="") 100
	s SQLCODE=0
	k OCLPLIST,OCRPLIST,SMLPLIST,SMPLIST,EQPLIST,CTLPLIST,CTPLIST
	n OCLNewObj,OCRNewObj,SMLNewObj,SMNewObj,EQNewObj,CTLNewObj,CTNewObj
	s OCLNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()	//CZF0131 2021-01-20 begin
	s OCRNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s SMLNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s SMNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s EQNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s CTLNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()
	s CTNewObj=##class(web.DHCEQ.Plat.JsonObject).%New()   //CZF0131 2021-01-20 end
	s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	if MainFlag="Y"
	{
		s OldObject=##Class(User.DHCEQContract).%OpenId(BussID)
	}
	else
	{
		s OldObject=##Class(User.DHCEQContractList).%OpenId(BussID)
	}
	s NewObject=OldObject
	s DataJson = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(DataInfo)
	s OldTableObj=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OldObject)
	s newkey=""		//CZF0131 2021-01-20
	For
	{
		s newvalue=DataJson.GetNext(.newkey)
		q:newkey=""
		s FieldName=newkey
	    s Value=newvalue
	   	d GetContractUpdInfo
	}
   	i SQLCODE q SQLCODE
   	
   	;保存入库表/入库明细表变动信息
	s SQLCODE=NewObject.%Save()
	i $$$ISERR(SQLCODE) q SQLCODE
	d NewObject.%Close()
	
	s SQLCODE=0
    ;保存入库变动日志
	s OldValue=OldTableObj.%ToJSON()
	i MainFlag="Y"
	{
		s TableName="DHC_EQContract"
		s ClassName="User.DHCEQContract"
	}
	else
	{
		s TableName="DHC_EQContractList"
		s ClassName="User.DHCEQContractList"
	}
	
	s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog(TableName,ClassName,BussID,"U",DataInfo,OldValue,CurUser,DCRRowID)
	i SQLCODE q SQLCODE
		
	;更新关联的验收
	
	s OCLRowIDs=""
	if MainFlag="Y"
	{
		s CTLRowID=0
		f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",BussID,CTLRowID)) q:CTLRowID=""  d
		.s OCLRowID=0
		.f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source",1,CTLRowID,OCLRowID)) q:OCLRowID=""  d
		..s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
		..q:$p($g(^DHCEQOpenCheckList(OCRRowID)),"^",45)="Y"
		..i OCLRowIDs'="" s OCLRowIDs=OCLRowIDs_","
		..s OCLRowIDs=OCLRowIDs_OCLRowID
		..s BussListID=OCLRowID
		..d UpdateContracctBySourceNew
	}
	else
	{
		s OCLRowID=0
		f  s OCLRowID=$o(^DHCEQOpenCheckList(0,"Source",1,BussID,OCLRowID)) q:OCLRowID=""  d
		.s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
		.q:$p($g(^DHCEQOpenCheckList(OCRRowID)),"^",45)="Y"
		.s BussListID=OCLRowID
		.d UpdateContracctBySourceNew
	}
	
	q SQLCODE
	
	;获取更新字段PLIST
GetContractUpdInfo	
	if MainFlag="Y"
	{
		if FieldName="CTContractName"
		{
			s NewObject.CTContractName =Value
		}
		elseif FieldName="CTSignDate"
		{
			s Value=##Class(web.DHCEQCommon).TransValueFromPage(Value,"date")
			s NewObject.CTSignDate=Value
		}
		elseif FieldName="CTSignLocDR"
		{
			s NewObject.CTSignLocDR =Value
		}
		elseif FieldName="CTProviderHandler"
		{
			s NewObject.CTProviderHandler =Value
			//s OCRPLIST(7)=Value,OCRNewObj.OCRProviderHandler=Value
			//s EQPLIST(42)=Value,EQNewObj.EQProviderHandler=Value
		}
		elseif FieldName="CTProviderTel"
		{
			s NewObject.CTProviderTel =Value
			//s OCRPLIST(8)=Value,OCRNewObj.OCRProviderTel=Value
			//s EQPLIST(43)=Value,EQNewObj.EQProviderTel=Value
		}
		elseif FieldName="CTProviderDR"
		{
			d NewObject.CTProviderDRSetObjectId(Value)
			//s OCRPLIST(6)=Value,OCRNewObj.OCRProviderDR=Value
			//s EQPLIST(26)=Value,EQNewObj.EQProviderDR=Value
			//s CTPLIST(19)=Value,CTNewObj.CTProviderDR=Value
		}
	}
	else
	{
		if FieldName="CTLName"
		{
			s NewObject.CTLName=Value
			s OCLPLIST(3)=Value,OCLNewObj.OCLName=Value
			;s SMLPLIST(6)=Value,SMLNewObj.SMLName=Value
			;s EQPLIST(2)=Value,EQNewObj.EQName=Value
			;s CTLPLIST(3)=Value,CTLNewObj.CTLName=Value
		}
		elseif FieldName="CTLModelDR"
		{
			d NewObject.CTLModelDRSetObjectId(Value)
			s OCLPLIST(6)=Value,OCLNewObj.OCLModelDR=Value
			;s SMLPLIST(10)=Value,OCLNewObj.SMLModelDR=Value
			;s EQPLIST(4)=Value,OCLNewObj.EQModelDR=Value
			;s CTLPLIST(4)=Value,CTLNewObj.CTLModelDR=Value
		}
		elseif FieldName="CTLPriceFee"
		{
			s NewObject.CTLPriceFee=Value
			s OCLPLIST(18)=Value,OCLNewObj.OCLOriginalFee=Value
			;s SMLPLIST(8)=Value,SMLNewObj.SMLOriginalFee=Value
			;s EQPLIST(28)=Value,EQNewObj.EQOriginalFee=Value
			;s CTLPLIST(7)=Value,CTLNewObj.CTLPriceFee=Value
		}
		elseif FieldName="CTLManuFactoryDR"
		{
			d NewObject.CTLManuFactoryDRSetObjectId(Value)
			s OCLPLIST(16)=Value,OCLNewObj.OCLManuFactoryDR=Value
			;s SMLPLIST(7)=Value,SMLNewObj.SMLManuFactoryDR=Value
			;s EQPLIST(27)=Value,EQNewObj.EQManuFactoryDR=Value
			;s CTLPLIST(5)=Value,CTLNewObj.CTLManuFactoryDR=Value
		}
	}
	quit
	
	;更新关联的验收单、入库单、台帐
UpdateContracctBySourceNew
	;更新验收明细单
	s OCLRowID=BussListID
	q:OCLRowID=""
	s OCLOldObj=##Class(User.DHCEQOpenCheckList).%OpenId(OCLRowID)
	s OCLOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OCLOldObj).%ToJSON()
	&SQL(Update SQLUSER.DHC_EQOpenCheckList Values:OCLPLIST() where OCL_RowID = :OCLRowID)
	i SQLCODE q SQLCODE
	s OCLNewValue=OCLNewObj.%ToJSON()
	i (OCLNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQOpenCheckList","User.DHCEQOpenCheckList",OCLRowID,"U",OCLNewValue,OCLOldValue,CurUser,DCRRowID)
	i SQLCODE q SQLCODE
	
	;更新验收单信息
	s OCRRowID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",1)
	q:OCRRowID=""
	s OCROldObj=##Class(User.DHCEQOpenCheckRequest).%OpenId(OCRRowID)
	s OCROldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(OCROldObj).%ToJSON()
	&SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values:OCRPLIST() where OCR_RowID = :OCRRowID)
	i SQLCODE q SQLCODE
	s OCRNewValue=OCRNewObj.%ToJSON()
	i (OCRNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQOpenCheckRequest","User.DHCEQOpenCheckRequest",OCRRowID,"U",OCRNewValue,OCROldValue,CurUser,DCRRowID)
	i SQLCODE q SQLCODE
	
	;更新合同信息
	s OCLSourceType=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",63)
	s OCLSourceID=$p($g(^DHCEQOpenCheckList(OCLRowID)),"^",64)
	q:(OCLSourceType="")||(OCLSourceID="")
	i (OCLSourceType=1)||(OCLSourceType=4)||(OCLSourceType=5)
	{
		s CTLOldObj=##Class(User.DHCEQContractList).%OpenId(OCLSourceID)
		s CTLOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(CTLOldObj).%ToJSON()
		i CTLNewObj.%IsDefined("CTLPriceFee") d
		.s Quantity = $p($g(^DHCEQContractList(OCLSourceID)),"^",7)
		.s TotalFee = CTLNewObj.%Get("CTLPriceFee")*Quantity
		.s CTLPLIST(9) = TotalFee
		.s CTLNewObj.CTLTotalFee = TotalFee
		&SQL(Update SQLUSER.DHC_EQContractList Values:CTLPLIST() where CTL_RowID = :OCLSourceID)
		i SQLCODE q SQLCODE
		s CTLNewValue=CTLNewObj.%ToJSON()
		i (CTLNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQContractList","User.DHCEQContractList",OCLSourceID,"U",CTLNewValue,CTLOldValue,CurUser,DCRRowID)
		i SQLCODE q SQLCODE
		
		s CTRowID=$p($g(^DHCEQContractList(OCLSourceID)),"^",1)
		s CTOldObj=##Class(User.DHCEQContract).%OpenId(CTRowID)
		s CTOldValue=##Class(web.DHCEQ.Plat.LIBCommon).GetJsonTableRecord(CTOldObj).%ToJSON()
		&SQL(Update SQLUSER.DHC_EQContract Values:CTPLIST() where CT_RowID = :CTRowID)
		i SQLCODE q SQLCODE
		s CTNewValue=CTNewObj.%ToJSON()
		i (CTNewValue'="{}") s SQLCODE=##class(web.DHCEQ.Plat.LIBCommon).SaveDataChangeLog("DHC_EQContract","User.DHCEQContract",CTRowID,"U",CTNewValue,CTOldValue,CurUser,DCRRowID)
		i SQLCODE q SQLCODE
	}
}

/// Creator:CZF 1905411
/// CreatDate:2021-06-03
/// Description:判断业务单据是否包含多科室
/// Input：BussType：11：验收单明细 21：入库单明细 94：合同明细 BussID:表相关ID
/// OutPut:
/// Command:w ##Class(web.DHCEQ.Plat.LIBBusinessModify).CheckBussListLoc("")
ClassMethod CheckBussListLoc(BussType, BussID)
{
	s ListLocNum=0
	i BussType=11
	{
		s OCLLRowID=0
		f  s OCLLRowID=$o(^DHCEQOpenCheckListLoc(0,"OpenCheckList",BussID,OCLLRowID)) q:OCLLRowID=""  d
		.s ListLocNum=ListLocNum+1
	}
	elseif BussType=21
	{
		s ISLLRowID=0
		f  s ISLLRowID=$o(^DHCEQInStockListLoc(0,"InStockList",BussID,ISLLRowID)) q:ISLLRowID=""  d
		.s ListLocNum=ListLocNum+1
	}
	elseif BussType=94
	{
		s CTLLRowID=0
		f  s CTLLRowID=$o(^DHCEQContractListLoc(0,"ContractList",BussID,CTLLRowID)) q:CTLLRowID=""  d
		.s ListLocNum=ListLocNum+1
	}
	q ListLocNum
}

}
