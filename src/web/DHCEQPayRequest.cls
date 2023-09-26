Class web.DHCEQPayRequest Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by zy 2015-08-21 ZY0135
/// w ##Class(web.DHCEQPayRequest).StatusList("Status",155,%request.Get("Type"))
ClassMethod StatusList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	i (Type="")||(Type="0")||(Type="4") w "<option value=0>"_##Class(web.DHCEQPayRequest).GetStatus(0)_"</option>"
	i Type'="2" w "<option value=1>"_##Class(web.DHCEQPayRequest).GetStatus(1)_"</option>"
	w "<option value=2>"_##Class(web.DHCEQPayRequest).GetStatus(2)_"</option>"
	w "<option value=3>"_##Class(web.DHCEQPayRequest).GetStatus(3)_"</option>"
	w "</select>",!
}

/// d ##Class(web.DHCEQPayRequest).BussTypeList("SourceType",135,%request.Get("PayType"))
ClassMethod BussTypeList(name, width, PayType) As %String
{
	;;下拉列表
	w ##class(web.DHCEQCommon).GetDefaultStyle(name,"")	;modified by csj 2020-02-18
	if PayType=1			//modified by CZF0059 begin 2020-02-20
	{
		w "<option value=11>合同总单</option>"
		w "<option value=12>合同明细</option>"
		w "<option value=13>验收明细</option>"
		w "<option value=14>入库明细</option>"
		w "<option value=16>退货明细</option>"
	}
	elseif PayType=2
	{
		w "<option value=21>维保合同总单</option>"
		w "<option value=22>维保合同明细'</option>"
	}
	elseif PayType=3
	{
		w "<option value=31>配件入库</option>"
		w "<option value=32>配件退货</option>"
	}
	elseif PayType=4
	{
		w "<option value=41>调账</option>"
	}
	elseif PayType=5
	{
		w "<option value=51>保养</option>"
		w "<option value=52>检查</option>"
		w "<option value=53>维修</option>"
	}							//modified by CZF0059 end 2020-02-20
	w "</select>",!
}

ClassMethod GetStatus(Status)
{
	Quit $CASE(Status,"0":"新增","1":"提交","2":"审核","3":"作废",:"没有定义")
}

/// 20150922  Mozy0166
/// 描述:凭单明细来源类型
/// w ##Class(web.DHCEQPayRequest).GetSourceType(1)
ClassMethod GetSourceType(Type As %String = "")
{
	Quit:Type="" ""
	Quit:Type=11 "合同总单"
	Quit:Type=12 "合同明细"
	Quit:Type=13 "验收明细"
	Quit:Type=14 "入库明细"
	Quit:Type=15 "首次出库明细"
	Quit:Type=16 "退货明细"
	Quit:Type=21 "维保合同总单"
	Quit:Type=22 "维保合同明细"
	Quit:Type=31 "配件入库"
	Quit:Type=32 "首次配件出库"
	Quit:Type=33 "配件退货"
	Quit:Type=41 "调账"
	Quit:Type=51 "保养"
	Quit:Type=52 "检查"
	Quit:Type=53 "维修"
	Quit:$E(Type,1,1)=9 $p($g(^DHCEQCCode("DHCEQCPayCostType",$E(Type,2,$L(Type)))),"^",2)
	Quit "没有定义"
}

/// w ##Class(web.DHCEQPayRequest).GetOnePayRequest(1)
ClassMethod GetOnePayRequest(rowid)
{
	new result,resultex,tmp
	Set (result,resultex)=""
	Set result=^DHCEQPayRequest(rowid)
	Set $Piece(result,"^",2)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",2),"date")	;PN_MakeDate
	Set resultex=resultex_"^"	;AN_LocDR
	If $Piece(result,"^",3)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$Piece(result,"^",3))
	Set resultex=resultex_"^"	;AN_ProviderDR
	If $Piece(result,"^",4)'=""  Do
	.Set resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$Piece(result,"^",4))
	Set $Piece(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",7),"date")	;PN_AccountDate
	Set resultex=resultex_"^"	;PN_TotalFee
	If $Piece(result,"^",8)'="" Do
	.Set tmp=##Class(web.DHCEQCommon).RMBDXXZH("","",$Piece(result,"^",8))	;大写金额
	.Set resultex=resultex_##Class(web.DHCEQCommon).Trim(tmp)
	.;Set $Piece(result,"^",8)=$Fn($Piece(result,"^",8),",",2)
	Set resultex=resultex_"^"	;PN_AuditUserDR
	If $Piece(result,"^",20)'="" Do
	.Set resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user", $Piece(result,"^",20))
	Set $Piece(result,"^",30)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",30),"bool")
	Set $Piece(result,"^",32)=##Class(web.DHCEQCommon).TransValueToPage($Piece(result,"^",32),"bool")	//Mozy0203	20180224
	Set resultex=resultex_"^"	;Other
	;s Str=##Class(web.DHCEQPayRequest).GetPayRequestInfo(rowid)
	s Str=""
	If Str'="" Do
	.Set resultex=resultex_Str
	Set resultex=resultex_"^"
	If $Piece(result,"^",9)'="" Do
	.Set resultex=resultex_$Piece($Get(^DHCEQCCode("DHCEQCPurposeType",$Piece(result,"^",9))),"^",2)
	
	Set result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	Quit result_resultex
}

/// w ##Class(web.DHCEQPayRequest).GetPayRequestInfo(1)
ClassMethod GetPayRequestInfo(RowID)
{
	k ^DHCEQTemp("PaymentNotice","EquipType")
	Set (sumFee,sumQty,sumDanJu)=0
	s InStockIDS=""
	Set PNLRowID=0
	For  Set PNLRowID=$Order(^DHCEQPaymentNoticeList(0,"PaymentNoticeDR",RowID,PNLRowID)) Quit:PNLRowID=""  Do
	.Set ExSourceType=$Piece($Get(^DHCEQPaymentNoticeList(PNLRowID)),"^",4)
	.Set ExSourceID=$Piece($Get(^DHCEQPaymentNoticeList(PNLRowID)),"^",5)
	.i ExSourceType="1"  d
	..s InStockID=$Piece($Get(^DHCEQInStockList(ExSourceID)),"^",1)
	..i InStockIDS=""  d
	...s InStockIDS=","_InStockID_","
	..e  d
	...i InStockIDS'[InStockID s InStockIDS=InStockIDS_InStockID_","
	..S EquipType=$Piece($Get(^DHCEQInStock(InStockID)),"^",20)
	..i EquipType'="" s EquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",2)
	..s QuantityNum=$p($g(^DHCEQInStockList(InStockID)),"^",8) //数量
	..s OriginalFee=$p($g(^DHCEQInStockList(InStockID)),"^",7) //单价
	..;s EquipName=$p($g(^DHCEQInStockList(InStockID)),"^",5) //设备名称
	..s InvoiceNos=$p(##Class(web.DHCEQPay).CheckInvoice("1",ExSourceID,"","",""),"^",4)
	..s Hold1=$p($g(^DHCEQInStockList(InStockID)),"^",11) //备注
	..s AllFee=QuantityNum*OriginalFee
	..s DataList=$g(^DHCEQTemp("PaymentNotice","EquipType",EquipType))
	..s $p(DataList,"$",1)=$p(DataList,"$",1)+AllFee
	..s $p(DataList,"$",2)=$p(DataList,"$",2)+QuantityNum
	..s $p(DataList,"$",3)=$p(DataList,"$",3)+Hold1
	..i InvoiceNos'="" d
	...i $p(DataList,"$",4)=""  d
	....s $p(DataList,"$",4)=InvoiceNos
	...e  d
	....s $p(DataList,"$",4)=$p(DataList,"$",4)_","_InvoiceNos
	..s ^DHCEQTemp("PaymentNotice","EquipType",EquipType)=DataList
	.e  d
	..
	s Str=""
	
	s EquipType=0
	f  s EquipType=$o(^DHCEQTemp("PaymentNotice","EquipType",EquipType))  quit:EquipType=""  d
	.s DataList=$g(^DHCEQTemp("PaymentNotice","EquipType",EquipType))
	.i Str="" d
	..s Str=EquipType_"$"_DataList
	.e  d
	..s Str=Str_"#"_EquipType_"$"_DataList
	s InStockIDS=$e(InStockIDS,2,$l(InStockIDS)-1)
	s Str=Str_"#"_InStockIDS  
	k ^DHCEQTemp("PaymentNotice","EquipType")
	quit Str
}

/// w ##Class(web.DHCEQPayRequest).GetList(1)
ClassMethod GetList(PaymentNoticeDR As %Library.String = "")
{
	Quit:PaymentNoticeDR="" ""
	new (PaymentNoticeDR)
	Set Data=""
	Set Num=0
	
	Set (sumFee,sumQty)=0
	Set Rowid=0
	For  Set Rowid=$Order(^DHCEQPayRequestList(0,"PaymentNoticeDR",PaymentNoticeDR,Rowid)) Quit:Rowid=""  Do
	.s (EquipName,ManuFactory,Model,Unit,QuantityNum,OriginalFee,AllFee,InvoiceNos,Remark,EquipNo,ContractNo,EquipDR)=""
	.Set ExSourceType=$Piece($Get(^DHCEQPayRequestList(Rowid)),"^",4)
	.Set ExSourceID=$Piece($Get(^DHCEQPayRequestList(Rowid)),"^",5)
	.i ExSourceType="1"  d
	..s InStockID=$Piece($Get(^DHCEQInStockList(ExSourceID)),"^",1)
	..S EquipType=$Piece($Get(^DHCEQInStock(InStockID)),"^",20)
	..i EquipType'="" s EquipType=$Piece($Get(^DHCEQCCode("DHCEQCEquipType",EquipType)),"^",2)
	..s EquipName=$p($g(^DHCEQInStockList(ExSourceID)),"^",5) //设备名称
	..s ManuFactoryDR=$p($g(^DHCEQInStockList(ExSourceID)),"^",6) //生产厂商
	..i ManuFactoryDR '=""  d
	...s ManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManufacturerDR) //CZF0093
	..
	..s ModelDR=$p($g(^DHCEQInStockList(InStockID)),"^",9) //规格
	..i ModelDR '=""  d
	...s Model = $p($g(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	..s UnitDR=$p($g(^DHCEQInStockList(ExSourceID)),"^",10) //单位
	..i UnitDR '=""  d
	...s Unit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	..s QuantityNum=$p($g(^DHCEQInStockList(ExSourceID)),"^",8) //数量
	..s OriginalFee=$p($g(^DHCEQInStockList(ExSourceID)),"^",7) //单价
	..s InvoiceNos=$p(##Class(web.DHCEQInvoice).GetInvoiceInfos(ExSourceType,ExSourceID),"^",1) //发票号
	..s Remark=$p($g(^DHCEQInStockList(ExSourceID)),"^",12) //备注
	..s AllFee=QuantityNum*OriginalFee
	..s EquipNo=""
	..s ContractNo=""
	..s EquipDR=$p($g(^DHCEQInStockList(ExSourceID)),"^",2)
	..i EquipDR'=""  d
	...s EquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	...s ContractNo=##class(web.DHCEQEquip).GetContractNo(EquipDR)
	..s sumFee=sumFee+AllFee
	..s sumQty=sumQty+QuantityNum
	.e  d
	..
	.       //设备名称      生产厂商      规格    单位   数量         单价          金额    发票号       备注
	.s Data=Data_":"_EquipName_"^"_ManuFactory_"^"_Model_"^"_Unit_"^"_QuantityNum_"^"_OriginalFee_"^"_AllFee_"^"_InvoiceNos_"^"_Remark_"^"_EquipNo_"^"_ContractNo_"^"_EquipDR_"^"_EquipType
	.s Num=Num+1
	i Data'=""  d
	.s Data=Data_":"_"合计^^^^"_sumQty_"^^"_sumFee_"^^^^^"
	.s Num=Num+1
	q Data_"_"_Num
}

/// 创建:Mozy 2013-9-13
/// 设备付款通知单查找
/// d ##class(%ResultSet).RunQuery("web.DHCEQPayRequest","GetPayRequest","","0078453")
Query GetPayRequest(PayRequestNo As %String = "", InvoiceNo As %String = "", LocDR As %String = "", StatusDR As %String = "", ProviderDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N", PayFromType As %String = "", Type As %String = "") As %Query(ROWSPEC = "TJob:%String,TRowID:%String,TPayRequestNo:%String,TMakeDate:%String,TLoc:%String,TProvider:%String,TBank:%String,TBankAccount:%String,TAccountDate:%String,TTotalFee:%String,TPurposeType:%String,TPayMode:%String,TAgent:%String,TStatus:%String,TRemark:%String,TPayFromType:%String,TSourceType:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String,TSourceTypeVal:%String")
{
}

ClassMethod GetPayRequestExecute(ByRef qHandle As %Binary, PayRequestNo As %String = "", InvoiceNo As %String = "", LocDR As %String = "", StatusDR As %String = "", ProviderDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N", PayFromType As %String = "", Type As %String = "") As %Status
{
 	new repid, index, rowid, flag, id, no, TJob, PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=2
 	Set TRow=1
 	Set TJob=$Job
 	Kill ^DHCEQTemp("GetPayRequest",TJob)
 	i LocDR="" Set LocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
 	Set PNum=1
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	
	Set TotalFee=0
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQPayRequest(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetPayRequest
	.s TInvalidFlag=$p($g(^DHCEQPayRequest(rowid)),"^",26)
	.q:TInvalidFlag="Y"
	.s TPayRequestNo=$p($g(^DHCEQPayRequest(rowid)),"^",1)
	.q:(PayRequestNo'="")&&(TPayRequestNo'=PayRequestNo)
	.s TRowID=rowid
	.s TMakeDate=$p($g(^DHCEQPayRequest(rowid)),"^",2)
	.q:(StartDate'="")&&(TMakeDate<StartDate)
	.q:(EndDate'="")&&(TMakeDate>EndDate)
	.i TMakeDate'="" s TMakeDate=##Class(web.DHCEQCommon).TransValueToPage(TMakeDate,"date")
	.s TLoc=$p($g(^DHCEQPayRequest(rowid)),"^",3)
	.q:(LocDR'="")&&(TLoc'=LocDR)
	.i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
	.s TProvider=$p($g(^DHCEQPayRequest(rowid)),"^",4)
	.q:(ProviderDR'="")&&(TProvider'=ProviderDR)
	.i TProvider'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	.s TBank=$p($g(^DHCEQPayRequest(rowid)),"^",5)
	.s TBankAccount=$p($g(^DHCEQPayRequest(rowid)),"^",6)
	.s TAccountDate=$p($g(^DHCEQPayRequest(rowid)),"^",7)
	.i TAccountDate'="" s TAccountDate=##Class(web.DHCEQCommon).TransValueToPage(TAccountDate,"date")
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQPayRequest(rowid)),"^",8))
	.s TPurposeType=$p($g(^DHCEQPayRequest(rowid)),"^",9)
	.i TPurposeType'="" s TPurposeType=""
	.s TPayMode=$p($g(^DHCEQPayRequest(rowid)),"^",10)
	.i TPayMode'="" s TPayMode=$Case(TPayMode,"1":"现金","2":"支票","3":"汇款",:"未定义")
	.s TAgent=$p($g(^DHCEQPayRequest(rowid)),"^",11)
	.s TStatus=$p($g(^DHCEQPayRequest(rowid)),"^",12)
	.q:TStatus=3
	.q:(StatusDR'="")&&(TStatus'=StatusDR)
	.s TStatus=##class(web.DHCEQPayRequest).GetStatus(TStatus)
	.s TRemark=$p($g(^DHCEQPayRequest(rowid)),"^",13)
	.s TPayFromType=$p($g(^DHCEQPayRequest(rowid)),"^",27)
	.s TPayFromType=$Case(TPayFromType,"1":"新购设备","2":"维保合同","3":"配件","4":"调账付款","5":"维护费用","9":"其他费用")
	.s TSourceType=$p($g(^DHCEQPayRequest(rowid)),"^",28)
	.;q:(SourceType'="")&&(TSourceType'=SourceType)	//add by csj 2020-02-18 业务类型过滤
	.s TSourceTypeVal=""
	.;start by csj 2020-02-20 添加发票过滤
	.s PRInvoiceFind=0
	.s PRecordDR=0
	.f  s PRecordDR=$o(^DHCEQPayRecord(0,"Invoice",rowid,PRecordDR))  q:(PRecordDR="")||(PRInvoiceFind'=0)  d
	..s TSourceID= $Piece($Get(^DHCEQPayRecord(PRecordDR)),"^",16)
	..s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",$p($g(^DHCEQStoreMoveList(TSourceID)),"^",4),"","","")
	..q:$p(TInvoiceInfo,"^",1)=0
	..s TInvoiceNo=$p(TInvoiceInfo,"^",4)
	..i (InvoiceNo'="")&&(TInvoiceNo[InvoiceNo) s PRInvoiceFind=1
	.
	.;增加获取配件转移单和设备转移单单发票号	Mozy	587884	2018-11-29
	.i (TSourceType=32)&&(PRInvoiceFind=0) d
	..s TSourceID=0
	..f  s TSourceID=$o(^DHCEQPayRequest(rowid,"EX",11,TSourceID)) q:(TSourceID="")||(PRInvoiceFind'=0)  d
	...s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",15)	;入库明细AISL_InStockListDR
	...i AMSLAISListDR'="" d
	....s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("3",AMSLAISListDR,"","","")
	....i $p(TInvoiceInfo,"^",1)=1 d
	.....s TInvoiceNo=$p(TInvoiceInfo,"^",4)
	.....i (InvoiceNo'="")&&(TInvoiceNo[InvoiceNo) s PRInvoiceFind=1
	.
	.i (TSourceType=15)&&(PRInvoiceFind=0) d
	..s TSourceID=0
	..f  s TSourceID=$o(^DHCEQPayRequest(rowid,"EX",12,TSourceID)) q:(TSourceID="")||(PRInvoiceFind'=0)  d
	...s EquipDR=+$Get(^DHCEQStoreMoveList(TSourceID,"EX","RowIDs"))
	...s TOpenCheckDate= ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipDR)),"^",12),"date")	//add by csj 20191224 验收日期
	...i $p($g(^DHCEQEquip(EquipDR)),"^",70)'="" d
	....s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",$p($g(^DHCEQEquip(EquipDR)),"^",70),"","","")
	....i $p(TInvoiceInfo,"^",1)=1 d
	.....s TInvoiceNo=$p(TInvoiceInfo,"^",4)
	.....i (InvoiceNo'="")&&(TInvoiceNo[InvoiceNo) s PRInvoiceFind=1
	.q:(InvoiceNo'="")&&(PRInvoiceFind=0)
	.;end by csj 2020-02-20
	.s TSourceType=##Class(web.DHCEQPayRequest).GetSourceType(TSourceType)
	.d OutputRowGetPayRequest
	
	/*老版本付款查询页面代码
	Set rowid=0
	For  Set rowid=$Order(^DHCEQPayRequest(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetPayRequest
	.s PRInvoiceFind=0
	.s PRecordDR=0
	.f  s PRecordDR=$o(^DHCEQPayRecord(0,"Invoice",rowid,PRecordDR))  q:(PRecordDR="")||(PRInvoiceFind'=0)  d
	..s TSourceID= $Piece($Get(^DHCEQPayRecord(PRecordDR)),"^",16)
	..s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",$p($g(^DHCEQStoreMoveList(TSourceID)),"^",4),"","","")
	..q:$p(TInvoiceInfo,"^",1)=0
	..s TInvoiceNo=$p(TInvoiceInfo,"^",4)
	..i (InvoiceNo'="")&&(TInvoiceNo[InvoiceNo) s PRInvoiceFind=1
	.
	.;增加获取配件转移单和设备转移单单发票号	Mozy	587884	2018-11-29
	.s PRSourceType=$Piece($Get(^DHCEQPayRequest(rowid)),"^",28)
	.i (PRSourceType=11)&&(PRInvoiceFind=0) d
	..s TSourceID=0
	..f  s TSourceID=$o(^DHCEQPayRequest(rowid,"EX",11,TSourceID)) q:(TSourceID="")||(PRInvoiceFind'=0)  d
	...s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",15)	;入库明细AISL_InStockListDR
	...i AMSLAISListDR'="" d
	....s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("3",AMSLAISListDR,"","","")
	....i $p(TInvoiceInfo,"^",1)=1 d
	.....s TInvoiceNo=$p(TInvoiceInfo,"^",4)
	.....i (InvoiceNo'="")&&(TInvoiceNo[InvoiceNo) s PRInvoiceFind=1
	.
	.i (PRSourceType=12)&&(PRInvoiceFind=0) d
	..s TSourceID=0
	..f  s TSourceID=$o(^DHCEQPayRequest(rowid,"EX",12,TSourceID)) q:(TSourceID="")||(PRInvoiceFind'=0)  d
	...s EquipDR=+$Get(^DHCEQStoreMoveList(TSourceID,"EX","RowIDs"))
	...i $p($g(^DHCEQEquip(EquipDR)),"^",70)'="" d
	....s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",$p($g(^DHCEQEquip(EquipDR)),"^",70),"","","")
	....i $p(TInvoiceInfo,"^",1)=1 d
	.....s TInvoiceNo=$p(TInvoiceInfo,"^",4)
	.....i (InvoiceNo'="")&&(TInvoiceNo[InvoiceNo) s PRInvoiceFind=1
	.q:(InvoiceNo'="")&&(PRInvoiceFind=0)
	.
	.Set TRowID = rowid
	.Set TInvalidFlag = $Piece($Get(^DHCEQPayRequest(rowid)),"^",26)
	.Quit:TInvalidFlag'="N"
	.Set TPayRequestNo = $Piece($Get(^DHCEQPayRequest(rowid)),"^",1)
	.Quit:(PayRequestNo'="")&(TPayRequestNo'[PayRequestNo)
	.Set TMakeDate = $Piece($Get(^DHCEQPayRequest(rowid)),"^",2)
	.Quit:(TMakeDate>EndDate)||(TMakeDate<StartDate)
	.Set TMakeDate = ##class(web.DHCEQCommon).TransValueToPage(TMakeDate,"date")
	.Set TLocDR = $Piece($Get(^DHCEQPayRequest(rowid)),"^",3)
	.Quit:(LocDR'="")&(TLocDR'=LocDR)
	.If TLocDR'="" Set TLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	.Set TProviderDR = $Piece($Get(^DHCEQPayRequest(rowid)),"^",4)
	.Quit:(ProviderDR'="")&(TProviderDR'=ProviderDR)
	.If TProviderDR '="" Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.Set TBank = $Piece($Get(^DHCEQPayRequest(rowid)),"^",5)
	.Set TBankAccount = $Piece($Get(^DHCEQPayRequest(rowid)),"^",6)
	.Set TAccountDate = $Piece($Get(^DHCEQPayRequest(rowid)),"^",7)
	.Set TAccountDate = ##class(web.DHCEQCommon).TransValueToPage(TAccountDate,"date")
	.Set TTotalFee = $Piece($Get(^DHCEQPayRequest(rowid)),"^",8)
	.If TTotalFee'="" Set TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	.Set TPurposeType = $Piece($Get(^DHCEQPayRequest(rowid)),"^",9)
	.Set TPurposeType = ##Class(web.DHCEQPayRequest).GetPurposeType(TPurposeType)
	.Set TPayMode = $Piece($Get(^DHCEQPayRequest(rowid)),"^",10)
	.Set TPayMode = ##Class(web.DHCEQPayRequest).GetPayMode(TPayMode)
	.Set TAgent = $Piece($Get(^DHCEQPayRequest(rowid)),"^",11)	;经办人
	.Set TStatus = $Piece($Get(^DHCEQPayRequest(rowid)),"^",12)
	.;q:TStatus="3"		; add by kdf 2017-11-14  需求号：474027
	.Quit:(Status'="")&&(Status'=TStatus)
	.Set TStatus=##class(web.DHCEQPayRequest).GetStatus(TStatus)
	.Set TRemark = $Piece($Get(^DHCEQPayRequest(rowid)),"^",13)
	.Set TPayFromType = $Piece($Get(^DHCEQPayRequest(rowid)),"^",27)
	.Quit:(PayFromType'="")&&(PayFromType'=TPayFromType)
	.;Mozy0203	20180224
	.Set TSourceTypeVal=$Piece($Get(^DHCEQPayRequest(rowid)),"^",28)
	.Set TSourceType = ##Class(web.DHCEQPayRequest).GetSourceType(+TSourceTypeVal)
	.Set THold1 = $Piece($Get(^DHCEQPayRequest(rowid)),"^",29)
	.Set THold2 = $Piece($Get(^DHCEQPayRequest(rowid)),"^",30)
	.Set THold3 = $Piece($Get(^DHCEQPayRequest(rowid)),"^",31)
	.;Mozy0203	20180224
	.Set THold4 = 0
	.If $Piece($Get(^DHCEQPayRequest(rowid)),"^",32)="Y" Set THold4 = 1
	.Set THold5 = $Piece($Get(^DHCEQPayRequest(rowid)),"^",33)
	.Set TotalFee=TotalFee+TTotalFee
	.Do OutputRowGetPayRequest
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0
		d ResetVariablesGetPayRequest
		Set TRow="合计:"
		Set TTotalFee=TotalFee
		Set TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
		Set Data=$lb(TJob,TRowID,TPayRequestNo,TMakeDate,TLoc,TProvider,TBank,TBankAccount,TAccountDate,TTotalFee,TPurposeType,TPayMode,TAgent,TStatus,TRemark,TPayFromType,TSourceType,THold1,THold2,THold3,THold4,THold5,TRow,TSourceTypeVal)
		Set ^CacheTemp(repid,index)=Data
		Set ^DHCEQTemp("GetPayRequest",TJob,PNum)=TRowID_"^"_TPayRequestNo_"^"_TAccountDate_"^"_TLoc_"^"_TProvider_"^"_TTotalFee_"^"_TStatus_"^"_TRemark_"^"_TPayFromType_"^"_TSourceType_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5
	}
	*/
	Quit $$$OK
OutputRowGetPayRequest
	Set Data=$lb(TJob,TRowID,TPayRequestNo,TMakeDate,TLoc,TProvider,TBank,TBankAccount,TAccountDate,TTotalFee,TPurposeType,TPayMode,TAgent,TStatus,TRemark,TPayFromType,TSourceType,THold1,THold2,THold3,THold4,THold5,TRow,TSourceTypeVal,TInvoiceNo,TOpenCheckDate)	//modified by csj 2020-02-18 标准版-付款查询添加添加发票号及验收日期出参
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s TRow=TRow+1
	Set ^DHCEQTemp("GetPayRequest",TJob,PNum)=TRowID_"^"_TPayRequestNo_"^"_TAccountDate_"^"_TLoc_"^"_TProvider_"^"_TTotalFee_"^"_TStatus_"^"_TRemark_"^"_TPayFromType_"^"_TSourceType_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TInvoiceNo_"^"_TOpenCheckDate	//modified by csj 2020-02-18 标准版-付款查询添加添加发票号及验收日期出参
	Set PNum=PNum+1
	
	Quit
ResetVariablesGetPayRequest
	Set (TRowID,TPayRequestNo,TMakeDate,TLoc,TProvider,TBank,TBankAccount,TAccountDate,TTotalFee,TPurposeType,TPayMode,TAgent,TStatus,TRemark,TPayFromType,TSourceType,THold1,THold2,THold3,THold4,THold5,TInvoiceNo,TOpenCheckDate)=""	//modified by csj 2020-02-18 标准版-付款查询添加添加发票号及验收日期出参
	Quit
}

ClassMethod GetPayRequestFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayRequestExecute ]
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

ClassMethod GetPayRequestClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayRequestExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 描述:付款通知单业务明细查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQPayRequest","GetPayRequestList","",12,1,1678)
Query GetPayRequestList(RowID As %String = "", SourceType As %String = "", PayFromType As %String = "", ProviderDR As %String = "", Hold4 As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRow:%String,TSourceType:%String,TSourceID:%String,TSourceNo:%String,TDate:%String,TEquipName:%String,TOriginalFee:%String,TQuantityNum:%String,TTotalFee:%String,TPaedFee:%String,TNeedPayFee:%String,TAmountFee:%String,TRemark:%String,TReduceQtyNum:%String,TFlag:%String,TInvoiceNo:%String,TInvoiceDate:%String,TLoc:%String,TAMSLHold3:%String,TListInfo:%String,TEquipType:%String,TProviderDR:%String")
{
}

ClassMethod GetPayRequestListExecute(ByRef qHandle As %Binary, RowID As %String = "", SourceType As %String = "", PayFromType As %String = "", ProviderDR As %String = "", Hold4 As %String = "") As %Status
{
 	new repid, index, TotalQty, Total, TotalFlag, SourceInfo
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set (TotalQty,Total)=0
	;s ^DHCEQMozy("GetPayRequestList")=RowID_","_SourceType_","_PayFromType_","_ProviderDR
	Set index=1
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	If TotalFlag="1" Set index=2
	//20150929 ZY0145付款申请单错误修改,查找不保存信息;
	//最终审核的时候保存付款记录的信息
	s Status=""
	Set TRow=0
	if RowID'=""
	{
		s Status=$Piece($Get(^DHCEQPayRequest(RowID)),"^",12)
		s PayFromType=$Piece($Get(^DHCEQPayRequest(RowID)),"^",27)
		s StoreLocDR=$Piece($Get(^DHCEQPayRequest(RowID)),"^",3)
		s ProviderDR=$Piece($Get(^DHCEQPayRequest(RowID)),"^",4)
	}
	i ProviderDR="" Quit $$$OK
	if +Status<2
	{
		if PayFromType=1
		{
			if SourceType=1
			{
				; "设备入库明细"
				s ISRowID=0
				f  s ISRowID=$o(^DHCEQInStock(0,"Provider",ProviderDR,ISRowID))  q:ISRowID=""  d
				.q:$Piece($Get(^DHCEQInStock(ISRowID)),"^",25)="Y"
				.s TEquipTypeDR=$Piece($Get(^DHCEQInStock(ISRowID)),"^",20)
				.q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
				.set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
				.s ISLRowID=0
				.f  s ISLRowID=$o(^DHCEQInStockList(0,"InStock",ISRowID,ISLRowID))  q:ISLRowID=""  d
				..q:$get(^DHCEQInStockList(ISLRowID,"PayRequestInvalidFlag"))
				..q:$p($g(^DHCEQInStockList(ISLRowID)),"^",22)'=""		;过滤附属设备	;Mozy	587884	2018-11-28
				..d ResetVariablesGetPayRequestList
				..s TSourceType="1"	;1:入库单
				..s TSourceID=ISLRowID
				..s TSourceNo=$p(^DHCEQInStock(ISRowID),"^",14)
				..
				..s TEquipTypeDR=$Piece($Get(^DHCEQInStock(ISRowID)),"^",20)   ;add by kdf 2017-11-14 需求号：468398
				..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR) ;add by kdf 2017-11-14 需求号：468398
				..s TEquipName = $p($g(^DHCEQInStockList(ISLRowID)),"^",5)
				..s TModelDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",9)
				..i TModelDR'="" s TModel=$p(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
				..s TUnitDR=$p($g(^DHCEQInStockList(ISLRowID)),"^",10)
				..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
				..s TDate=$p($g(^DHCEQInStock($p($g(^DHCEQInStockList(ISLRowID)),"^",1))),"^",1)
				..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
				..s TOriginalFee=$p($g(^DHCEQInStockList(ISLRowID)),"^",7)
				..s TQuantityNum=$p($g(^DHCEQInStockList(ISLRowID)),"^",8)
				..s TReduceQtyNum=0
				..s LocID=0
				..f  s LocID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,LocID)) q:LocID=""  d
				...s EquipID=0
				...f  s EquipID=$o(^DHCEQEquip(0,"InStockList",ISLRowID,LocID,EquipID)) q:EquipID=""  d
				....s TProviderDR=$p($g(^DHCEQEquip(EquipID)),"^",25)	;provderDR
				....q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
				....s TInvalidFlag=$p($g(^DHCEQEquip(EquipID)),"^",59)
				....q:TInvalidFlag="Y"
				....s TStockStatus=$p($g(^DHCEQEquip(EquipID)),"^",60)
				....q:TStockStatus'="3"
				....s TReduceQtyNum=TReduceQtyNum+1
				..s PayInfo=##Class(web.DHCEQPay).CheckPayInfo("1",ISLRowID,"","","","")
				..q:$p(PayInfo,"^",2)>=((TQuantityNum-TReduceQtyNum)*TOriginalFee)
				..s TTotalFee=(TQuantityNum-TReduceQtyNum)*TOriginalFee
				..s TPaedFee=$p(PayInfo,"^",2)
				..s TNeedPayFee=TTotalFee-TPaedFee
				..;s TQuantityNum=TQuantityNum-TReduceQtyNum
				..s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",ISLRowID,"","","")
				..q:$p(TInvoiceInfo,"^",1)=0
				..s TInvoiceNo=$p(TInvoiceInfo,"^",4)
				..;s TInvoiceNum=$l(TInvoice,",")
				..;if ($l(TInvoice,",")>1) s TInvoice=$p(TInvoice,",",1)_"..."
				..//if ($l(TInvoice,",")>1) s TInvoice=$p(TInvoice,",",1)_"..."
				..s TInvoiceDate=$p(TInvoiceInfo,"^",5)
				..i (RowID'="")&&$Data(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))>0  d
				...s TAmountFee=$g(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))
				...s TFlag="Y"
				..q:((+Status=1)&&(TFlag'="Y"))
				..Do OutputRowGetPayRequestList
			}
			elseif SourceType=12
			{
				; "转移明细(首次)"
				s SMRowID=0
				f  s SMRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID)) q:SMRowID=""  d
				.s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)		;SMEquipTypeDR
				.q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
				.set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
				.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)'="N"	;SMInvalidFlag
				.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)'=2	;SMStatus
				.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",12)'=0	;SMMoveType
				.s SMLRowID=0
				.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID)) q:SMLRowID=""  d
				..;q:$get(^DHCEQStoreMoveList(SMLRowID,"PayRequestInvalidFlag"))
				..q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",14)="Y"		;SMLHold2
				..q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",15)'=""		;SMLHold3	过滤附属设备	;Mozy	587884	2018-11-28
				..s EquipDRs=$Get(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
				..q:EquipDRs=""
				..i $p($g(^DHCEQStoreMoveList(SMLRowID)),"^",3)="Y" d
				...;批量
				...s isldr=$p($g(^DHCEQEquip($p(EquipDRs,",",1))),"^",70)
				...s isdr=$p($g(^DHCEQInStockList(isldr)),"^",1)
				...s TProviderDR=$p($g(^DHCEQInStock(isdr)),"^",17)
				..e  d
				...;单台
				...s isldr=$p($g(^DHCEQEquip(EquipDRs)),"^",70)
				...i isldr="" d	
				....s TProviderDR=$p($g(^DHCEQEquip(EquipDRs)),"^",25)	;provderDR
				...e  d
				....s isdr=$p($g(^DHCEQInStockList(isldr)),"^",1)
				....s TProviderDR=$p($g(^DHCEQInStock(isdr)),"^",17)
				..q:ProviderDR'=TProviderDR
				..;返回转移单明细的首次出库的设备DR
				..s equiplist=##Class(web.DHCEQPayRequest).GetEquipList(SMLRowID)
				..q:equiplist=""
				..
				..d ResetVariablesGetPayRequestList
				..s TSourceType="12"	;12:"转移明细(首次)"
				..s TSourceID=SMLRowID
				..s TSourceNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
				..
				..s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)     ;add by kdf 2017-11-14 需求号：468398
				..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR) ;add by kdf 2017-11-14 需求号：468398
				..i $p($g(^DHCEQStoreMoveList(SMLRowID)),"^",3)="Y" d
				...;批量
				...s isldr=$p($g(^DHCEQEquip($p(equiplist,",",1))),"^",70)
				...s TEquipName=$p($g(^DHCEQInStockList(isldr)),"^",5)
				...s TOriginalFee=$p($g(^DHCEQInStockList(isldr)),"^",7)
				...s TUnitDR=$p($g(^DHCEQInStockList(isldr)),"^",10)
				..e  d
				...;单台
				...s isldr=$p($g(^DHCEQEquip(equiplist)),"^",70)
				...i isldr="" d	
				....s TEquipName=$p($g(^DHCEQEquip(equiplist)),"^",1)
				....s TUnitDR=$p($g(^DHCEQEquip(equiplist)),"^",5)
				....s TOriginalFee=$p($g(^DHCEQEquip(equiplist)),"^",27)
				...e  d
				....s TEquipName=$p($g(^DHCEQInStockList(isldr)),"^",5)
				....s TOriginalFee=$p($g(^DHCEQInStockList(isldr)),"^",7)
				....s TUnitDR=$p($g(^DHCEQInStockList(isldr)),"^",10)
				..s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
				..i TModelDR'="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
				..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
				..s TDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
				..i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
				..s TQuantityNum=$length(equiplist,",")
				..
				..s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(12,SMLRowID,"","","","")
				..q:$p(PayInfo,"^",2)>=(TQuantityNum*TOriginalFee)
				..s TTotalFee=TQuantityNum*TOriginalFee
				..s TPaedFee=$p(PayInfo,"^",2)
				..s TNeedPayFee=TTotalFee-TPaedFee
				..i isldr'="" d
				...s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",isldr,"","","")
				...q:$p(TInvoiceInfo,"^",1)=0
				...s TInvoiceNo=$p(TInvoiceInfo,"^",4)
				..s TLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
				..i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
				..
				..i (RowID'="")&&$Data(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))>0  d
				...;q:(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID,"List")'="")&($Get(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID,"List"))'=equiplist)
				...s TAmountFee=$g(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))
				...s TFlag="Y"
				..q:((+Status=1)&&(TFlag'="Y"))
				..s TListInfo=equiplist
				..Do OutputRowGetPayRequestList
			}
			elseif SourceType=13
			{
				; "附件"
				
			}
			else
			{
				
			}
		}
		elseif PayFromType=2
		{
			
		}
		elseif PayFromType=3
		{
			//Mozy	2018-2-24	注释旧版保修合同付款申请
			/*if SourceType=8
			{
				// ^DHCEQContractList	保修合同明细
				s CTLRowID=0
				f  s CTLRowID=$o(^DHCEQContractList(CTLRowID)) q:CTLRowID=""  d
				.q:$get(^DHCEQContractList(CTLRowID,"PayRequestInvalidFlag"))
				.s CTRowID=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",1)
				.s ContractType=$Piece($Get(^DHCEQContract(CTRowID)),"^",39)
				.q:ContractType'=1		; 0:采购1:维修
				.;需求序号:	413798		Mozy	20170731	修正Status值不被重置
				.;s Status=$Piece($Get(^DHCEQContract(CTRowID)),"^",24)
				.q:$Piece($Get(^DHCEQContract(CTRowID)),"^",24)'=2
				.s TProviderDR=$Piece($Get(^DHCEQContract(CTRowID)),"^",18)
				.q:ProviderDR'=TProviderDR
				.s CTLST=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",5)	;1入库明细	2设备
				.s CTLSI=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",17)
				.s TEquipTypeDR=""
				.i CTLST=2 s TEquipTypeDR=$p($g(^DHCEQEquip(CTLSI)),"^",63)
				.q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
				.set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
				.
				.d ResetVariablesGetPayRequestList
				.s TSourceType="8"	;8:保修合同明细
				.s TSourceID=CTLRowID
				.i CTLST=2 s TEquipTypeDR=$p($g(^DHCEQEquip(CTLSI)),"^",63)    ;add by kdf 2017-11-15 需求号：468398
				.set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR) ;add by kdf 2017-11-15 需求号：468398
				.s TSourceNo=$Piece($Get(^DHCEQContract(CTRowID)),"^",2)
				.s TEquipName = $Piece($Get(^DHCEQContractList(CTLRowID)),"^",2)
				.s TModelDR = $Piece($Get(^DHCEQContractList(CTLRowID)),"^",3)
				.i TModelDR'="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
				.s TUnitDR=$p($g(^DHCEQEquip(CTLSI)),"^",5)
				.i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
				.s TDate=$p($g(^DHCEQContract(CTRowID)),"^",7)	;合同签订日期
				.s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
				.;s TOriginalFee=$p($g(^DHCEQContractList(CTLRowID)),"^",6)	;原值
				.s TOriginalFee=$Piece($Get(^DHCEQContract(CTRowID)),"^",5)	;买保金额
				.s TQuantityNum=$p($g(^DHCEQContractList(CTLRowID)),"^",7)
				.
				.s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(8,CTLRowID,"","","","")
				.q:$p(PayInfo,"^",2)>=(TQuantityNum*TOriginalFee)
				.s TTotalFee=TQuantityNum*TOriginalFee
				.s TPaedFee=$p(PayInfo,"^",2)
				.s TNeedPayFee=TTotalFee-TPaedFee
				.Set TInvoiceNo=##Class(web.DHCEQEquip).GetInvoiceNo(CTLSI,0)
				.;Set len = $Length(TInvoiceNo,"&")
				.;for i=1:1:len d
				.;.If $Piece($Piece(TInvoiceNo,"&",i),"^",1)[InvoiceNo Set passed=1
				.;q:passed'=1
				.s TLoc=$p($g(^DHCEQEquip(CTLSI)),"^",67)
				.i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
				.
				.i (RowID'="")&&$Data(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))>0  d
				..s TAmountFee=$g(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))
				..s TFlag="Y"
				.q:((+Status=1)&&(TFlag'="Y"))
				.Do OutputRowGetPayRequestList
			}*/
			if SourceType=8
			{
				// ^DHCEQContract	保修合同	/// 20170324 Mozy0183
				if Hold4=1
				{
					;按保修合同制定的付款计划取值	^DHCEQPayPlan	付款计划
					s SID=""
					f  s SID=$o(^DHCEQPayPlan(0,"Source",1,SID)) quit:SID=""  d
					.Set (TEquipTypeDR,TInvalidFlag)=""
					.Quit:$Piece($Get(^DHCEQContract(SID)),"^",24)'=2	;Status
					.Set TProviderDR=$Piece($Get(^DHCEQContract(SID)),"^",18)
					.q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
			 		.s ContractListDR=""
				 	.f  s ContractListDR=$o(^DHCEQContractList(0,"Contract",SID,ContractListDR)) quit:(ContractListDR="")||(TInvalidFlag="Y")  d
				 	..;;;Mozy	2018-3-19	567237	修正保修合同明细的类组取值
					..s ContractListSType = $p($g(^DHCEQContractList(ContractListDR)),"^",5)	;1:计划 2:招标 3:设备项 4:设备 5:入库明细
				 	..s ContractListSID = $p($g(^DHCEQContractList(ContractListDR)),"^",17)
				 	..i ContractListSType=1 d
				 	...Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(ContractListSID)),"^",1))),"^",12)
				 	..else  if ContractListSType=2 d
				 	...Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(ContractListSID)),"^",3)	//Mozy	567216	201-3-26	增加类组取值
					...Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
				 	..else  if ContractListSType=3 d
				 	...Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",ContractListSID)),"^",3)
				 	..else  if ContractListSType=4 d
				 	...Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",63)
				 	..else  if ContractListSType=5 d
				 	...Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(ContractListSID)),"^",1))),"^",20)
				 	..i ##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR)=1 s TInvalidFlag="Y"
					.q:TInvalidFlag="Y"
					.q:##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR)
					.Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
					.
					.s PPRowID=0
					.f  s PPRowID=$o(^DHCEQPayPlan(0,"Source",1,SID,PPRowID)) quit:(PPRowID="")  d
					..q:$get(^DHCEQPayPlan(PPRowID,"PayRequestInvalidFlag"))
					..s GlobalData=$g(^DHCEQPayRequest(+RowID,"EX",+SourceType,PPRowID,"List"))	;20180424 Mozy0205
					..d ResetVariablesGetPayRequestList
					..;	,,,,,TOriginalFee,,TTotalFee,TPaedFee,TNeedPayFee,TAmountFee,TRemark,TReduceQtyNum,TFlag,TInvoiceNo,TInvoiceDate,TLocDR,TLoc,TAMSLHold3,TListInfo,TEquipType,TProviderDR,TProvider,TFileNo,TAgentDR,TAgent,TPayModeDR,TPayMode
					..s TSourceType="8"	;8:保修合同-付款计划
					..s TSourceID=PPRowID
					..s TEquipName=$p($g(^DHCEQPayPlan(TSourceID)),"^",1)
					..s TOriginalFee=$p($g(^DHCEQPayPlan(TSourceID)),"^",10)	;PP_PayAmount
					..Set TSourceNo=$p($g(^DHCEQContract(SID)),"^",2)
					..Set TEquipName=$p($g(^DHCEQContract(SID)),"^",1)_"("_TEquipName
					..If TOriginalFee="" Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(SID)),"^",4),0)*0.01*$p($g(^DHCEQPayPlan(TSourceID)),"^",9)
					..Set TEquipName=TEquipName_"计划支付日期:"_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayPlan(TSourceID)),"^",6),"date")_")"
					..Set TProviderDR=$Piece($Get(^DHCEQContract(SID)),"^",18)
					..s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商
					..s TInvoiceNo=$Piece(GlobalData,"^",3)		;20180424 Mozy0205
					..s TDate=$p($g(^DHCEQPayPlan(TSourceID)),"^",6)
					..i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
					..s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p($g(^DHCEQContract(SID)),"^",8))	;合同签订部门
					..i ContractListSType=2 s TFileNo=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",85)
					..s TQuantityNum=1
					..
					..s PayInfo=##Class(web.DHCEQPay).CheckPayInfo("8",TSourceID,"","","",TSourceID)
					..q:$p(PayInfo,"^",2)>=TOriginalFee
					..s TTotalFee=TOriginalFee
					..s TPaedFee=$p(PayInfo,"^",2)
					..s TNeedPayFee=TTotalFee-TPaedFee
					..i (RowID'="")&&$Data(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))>0  d
					...s TAmountFee=$g(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))
					...s TFlag="Y"
					..q:((+Status=1)&&(TFlag'="Y"))
					..Do OutputRowGetPayRequestList
				}
				else
				{
					s CTRowID=0
					f  s CTRowID=$o(^DHCEQContract(CTRowID)) q:CTRowID=""  d
					.q:$get(^DHCEQContract(CTRowID,"PayRequestInvalidFlag"))
					.d ResetVariablesGetPayRequestList
					.s ContractType=$Piece($Get(^DHCEQContract(CTRowID)),"^",39)
					.q:ContractType'=1		; 0:采购1:维修
					.q:$Piece($Get(^DHCEQContract(CTRowID)),"^",24)'=2
					.s TProviderDR=$Piece($Get(^DHCEQContract(CTRowID)),"^",18)
					.q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
					.
					.s EquipTypeFlag=0
					.s CTLRowID=0
					.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:(CTLRowID="")||(EquipTypeFlag'=0)  d
					..;;;Mozy	2018-3-19	567237	修正保修合同明细的类组取值
					..s CTLST=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",5)	;;1:计划 2:招标 3:设备项 4:设备 5:入库明细
					..s CTLSI=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",17)
					..s TEquipTypeDR=""
					..i CTLST=1 d
				 	...Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(CTLSI)),"^",1))),"^",12)
				 	..else  if CTLST=2 d
				 	...Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(CTLSI)),"^",3)		//Mozy	567216	201-3-26	增加类组取值
					...Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
				 	..else  if CTLST=3 d
				 	...Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",CTLSI)),"^",3)
				 	..else  if CTLST=4 d
				 	...Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(CTLSI)),"^",63)
				 	..else  if CTLST=5 d
				 	...Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(CTLSI)),"^",1))),"^",20)
					..s EquipTypeFlag=##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR)
					.q:EquipTypeFlag'=0
					.
					.s TSourceType="8"	;8:保修合同
					.s TSourceID=CTRowID
					.s TSourceNo=$Piece($Get(^DHCEQContract(CTRowID)),"^",2)
					.s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商
					.s TEquipName = $Piece($Get(^DHCEQContract(CTRowID)),"^",1)
					.;s TModelDR = $Piece($Get(^DHCEQContractList(CTLRowID)),"^",3)
					.;i TModelDR'="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
					.;s TUnitDR=$p($g(^DHCEQEquip(CTLSI)),"^",5)
					.;i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
					.s TDate=$p($g(^DHCEQContract(CTRowID)),"^",7)	;合同签订日期
					.i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
					.;s TOriginalFee=$p($g(^DHCEQContractList(CTLRowID)),"^",6)	;原值
					.s TOriginalFee=$Piece($Get(^DHCEQContract(CTRowID)),"^",5)	;买保金额
					.s TQuantityNum=1	;$p($g(^DHCEQContractList(CTLRowID)),"^",7)
					.
					.s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(8,CTRowID,"","","","")
					.q:$p(PayInfo,"^",2)>=(TQuantityNum*TOriginalFee)
					.s TTotalFee=TQuantityNum*TOriginalFee
					.s TPaedFee=$p(PayInfo,"^",2)
					.s TNeedPayFee=TTotalFee-TPaedFee
					.;Set TInvoiceNo=##Class(web.DHCEQEquip).GetInvoiceNo(CTLSI,0)
					.;Set len = $Length(TInvoiceNo,"&")
					.;for i=1:1:len d
					.;.If $Piece($Piece(TInvoiceNo,"&",i),"^",1)[InvoiceNo Set passed=1
					.;q:passed'=1
					.;q:(Invoice'="")&&(TInvoiceNo'[Invoice)
					.s TLoc=$p($g(^DHCEQContract(CTRowID)),"^",8)   ;合同签订部门
					.i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
					.s GlobalData=$g(^DHCEQPayRequest(+RowID,"EX",SourceType,CTRowID,"List"))
					.s TFileNo=$Piece(GlobalData,"^",4)
					.s TLocDR=$Piece(GlobalData,"^",5)
					.i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
					.
					.i (RowID'="")&&$Data(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))>0  d
					..s TAmountFee=$g(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))
					..s TFlag="Y"
					.q:((+Status=1)&&(TFlag'="Y"))
					.Do OutputRowGetPayRequestList
				}
			}
			elseif SourceType=11
			{
				// ^DHCEQAMoveStockList	配件出库明细
				s AMSLRowID=0
				f  s AMSLRowID=$o(^DHCEQAMoveStockList(AMSLRowID)) q:AMSLRowID=""  d
				.q:$get(^DHCEQAMoveStockList(AMSLRowID,"PayRequestInvalidFlag"))
				.s AMSRowID=$Piece($Get(^DHCEQAMoveStockList(AMSLRowID)),"^",1)
				.s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)
				.q:##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
				.set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
				.s TAMSMoveType=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",14)
				.q:TAMSMoveType'=0
				.s TAMSStatus=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",28)
				.q:TAMSStatus'=2
				.s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(AMSLRowID)),"^",15)	;入库明细AISL_InStockListDR
				.Quit:AMSLAISListDR=""
				.s AISRowID=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",1)
				.q:AISRowID=""         //add by mwz 20180313 需求号：551254
				.s TProviderDR=$Piece($Get(^DHCEQAInStock(AISRowID)),"^",8)
				.q:ProviderDR'=TProviderDR
				.d ResetVariablesGetPayRequestList
				.s TSourceType="11"	;11:配件出库明细
				.s TSourceID=AMSLRowID
				.s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)    ;add by kdf 2017-11-15 需求号：468398
				.i TAccessoryTypeDR'="" s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR) ;add by kdf 2017-11-15 需求号：468398
				.s TSourceNo=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",1)
				.s TEquipName = $p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",4)
				.s TModel=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",5)
				.s TUnitDR=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",6)
				.i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
				.s TDate=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",7)
				.i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
				.s TOriginalFee=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",10)
				.s TQuantityNum=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",11)
				.
				.s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(11,AMSLRowID,"","","","")
				.q:$p(PayInfo,"^",2)>=(TQuantityNum*TOriginalFee)
				.s TTotalFee=TQuantityNum*TOriginalFee
				.s TPaedFee=$p(PayInfo,"^",2)
				.s TNeedPayFee=TTotalFee-TPaedFee
				.
				.s TInvoiceNo=$p($g(^DHCEQAInStockList(AMSLAISListDR)),"^",19)	;Mozy	587950	2018-11-28
				.s TLoc=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",5)
				.i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
				.s TAMSLHold3=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",20)	;呈批件号	Mozy	588024	2018-11-28
				.
				.i (RowID'="")&&$Data(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))>0  d
				..s TAmountFee=$g(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))
				..s TFlag="Y"
				.q:((+Status=1)&&(TFlag'="Y"))
				.Do OutputRowGetPayRequestList
			}
		}
	}
	else
	{
		Set rowid=0 
		For  Set rowid=$Order(^DHCEQPayRecord(0,"PayRequest",RowID,rowid)) Quit:rowid=""  Do
		.Do ResetVariablesGetPayRequestList
		.s flag=0
		.s DataList =$G(^DHCEQPayRecord(rowid))
		.s TRowID = rowid
		.s TAmountFee=+$P(DataList,"^",3)
		.s TRemark=$P(DataList,"^",9)
		.s TTotalFee=$P(DataList,"^",11)
		.s TPaedFee=$p(DataList,"^",12)
		.s TNeedPayFee=$p(DataList,"^",13)
		.s TSourceType=$P(DataList,"^",15)
		.s TSourceID=$P(DataList,"^",16)
		.s TPayPlanDR=$P(DataList,"^",17)	;Mozy0203	20180224
		.
		.;来源类型是入库明细
		.i TSourceType=1 Do
		..Set ISRowID=$P($G(^DHCEQInStockList(TSourceID)),"^",1)
		..s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",TSourceID,"","","")
        ..;q:$p(TInvoiceInfo,"^",1)=0
	    ..s TInvoiceNo=$p(TInvoiceInfo,"^",4)  //modify by mwz 20180313 需求号：550672
	    ..s TInvoiceDate=$p(TInvoiceInfo,"^",5)
		..s TSourceNo=$P($G(^DHCEQInStock(ISRowID)),"^",14)
		..s TDate=$P($G(^DHCEQInStock(ISRowID)),"^",1)
		..s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		..s TEquipTypeDR=$P($G(^DHCEQInStock(ISRowID)),"^",20)
		..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		..s TEquipName=$P($G(^DHCEQInStockList(TSourceID)),"^",5)
		..s TOriginalFee=+$P($G(^DHCEQInStockList(TSourceID)),"^",7)
		..s TQuantityNum=$P($G(^DHCEQInStockList(TSourceID)),"^",8)
		.q:flag'=0
		.
		.;来源类型是保修合同	Mozy0203	20180224	
		.i TSourceType=8 Do
		..i TPayPlanDR'="" d
		...i $Piece($Get(^DHCEQPayPlan(TSourceID)),"^",2)=1 d
		....;按保修合同制定的付款计划取值	^DHCEQPayPlan	付款计划
		....s SID=$Piece($Get(^DHCEQPayPlan(TSourceID)),"^",3)
		....s GlobalData=$Get(^DHCEQPayRecord(TSourceID,"List"))	;20180424 Mozy0205
		....Set TProviderDR=$Piece($Get(^DHCEQContract(SID)),"^",18)
		....Set TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商
		....s ContractListDR=""
		....f  s ContractListDR=$o(^DHCEQContractList(0,"Contract",SID,ContractListDR)) quit:(ContractListDR="")||(flag'=0)  d
		.....;//Mozy	567216	201-3-26	增加类组取值
		.....s ContractListSType = $p($g(^DHCEQContractList(ContractListDR)),"^",5)	;1:计划 2:招标 3:设备项 4:设备 5:入库明细
		.....s ContractListSID = $p($g(^DHCEQContractList(ContractListDR)),"^",17)
		.....i ContractListSType=1 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(ContractListSID)),"^",1))),"^",12)
		.....else  if ContractListSType=2 d
		......Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(ContractListSID)),"^",3)
		......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
		.....else  if ContractListSType=3 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",ContractListSID)),"^",3)
		.....else  if ContractListSType=4 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",63)
		.....else  if ContractListSType=5 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(ContractListSID)),"^",1))),"^",20)
		.....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR)
		....;; End
		....Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		....s TEquipName=$p($g(^DHCEQPayPlan(TSourceID)),"^",1)
		....s TOriginalFee=$p($g(^DHCEQPayPlan(TSourceID)),"^",10)	;PP_PayAmount
		....Set TSourceNo=$p($g(^DHCEQContract(SID)),"^",2)
		....Set TEquipName=$p($g(^DHCEQContract(SID)),"^",1)_"("_TEquipName
		....Set TEquipName=TEquipName_"计划支付日期:"_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayPlan(TSourceID)),"^",6),"date")_")"
		....If TOriginalFee="" Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(SID)),"^",4),0)*0.01*$p($g(^DHCEQPayPlan(TSourceID)),"^",9)
		....s TQuantityNum=1
		....;s TDate=$p($g(^DHCEQPayPlan(TSourceID)),"^",6)
		....;i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		....s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p($g(^DHCEQContract(SID)),"^",8))	;合同签订部门
		....i ContractListSType=2 s TFileNo=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",85)
		....s TInvoiceNo=$Piece(GlobalData,"^",3)	;20180424 Mozy0205
		....s PayInfo=##Class(web.DHCEQPay).CheckPayInfo("8",TSourceID,"","","",TSourceID)
		....s TTotalFee=TOriginalFee
		....s TPaedFee=$p(PayInfo,"^",2)
		....s TNeedPayFee=TTotalFee-TPaedFee
		..e  d
		...s CTLRowID=0
		...f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",TSourceID,CTLRowID)) q:(CTLRowID="")||(flag'=0)  d
		....s CTLST=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",5)	;1入库明细	2设备
		....s CTLSI=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",17)
		....;;;Mozy	2018-3-26	567216	修正保修合同明细的类组取值
		....s TEquipTypeDR=""
		....i CTLST=1 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(CTLSI)),"^",1))),"^",12)
		....else  if CTLST=2 d
		.....Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(CTLSI)),"^",3)
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
		....else  if CTLST=3 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",CTLSI)),"^",3)
		....else  if CTLST=4 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(CTLSI)),"^",63)
		....else  if CTLST=5 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(CTLSI)),"^",1))),"^",20)
		....set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		...
		...s TSourceNo=$Piece($Get(^DHCEQContract(TSourceID)),"^",2)
		...s TEquipName = $Piece($Get(^DHCEQContract(TSourceID)),"^",1)
		...s TProviderDR = $Piece($Get(^DHCEQContract(TSourceID)),"^",18)
		...s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		...;s TDate=$p($g(^DHCEQContract(TSourceID)),"^",7)	;合同签订日期
		...;s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		...s TOriginalFee=$Piece($Get(^DHCEQContract(TSourceID)),"^",5)	;买保金额
		...s TQuantityNum=1
		...s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(8,TSourceID,"","","","")
		...s TTotalFee=TQuantityNum*TOriginalFee
		...s TPaedFee=$p(PayInfo,"^",2)
		...s TNeedPayFee=TTotalFee-TPaedFee
		...s TLoc=$p($g(^DHCEQContract(TSourceID)),"^",8)   ;合同签订部门
		...s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
		...s GlobalData=$Get(^DHCEQPayRecord(rowid,"List"))
		...s TFileNo=$Piece(GlobalData,"^",4)
		...s TLocDR=$Piece(GlobalData,"^",5)
		...i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
		.q:flag'=0
		.
		.;来源类型是配件转移明细
		.i TSourceType=11 Do
		..s AMSRowID=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",1)
		..s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)
		..s flag=##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
		..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
		..s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",15)	;入库明细AISL_InStockListDR
		..s AISRowID=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",1)
		..q:AISRowID=""         //add by mwz 20180313 需求号：551254
		..s TSourceNo=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",1)
		..s TEquipName = $p($g(^DHCEQAMoveStockList(TSourceID)),"^",4)
		..s TUnitDR=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",6)
		..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		..s TDate=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",7)
		..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		..s TOriginalFee=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",10)
		..s TQuantityNum=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",11)
		..s TInvoiceNo=$p($g(^DHCEQAInStockList(AMSLAISListDR)),"^",19)		;Mozy	587950	2018-11-28
		..s TLoc=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",5)
		..i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
		..s TAMSLHold3=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",20)		;Mozy	588024	2018-11-28
		.q:flag'=0
		.
		.;来源类型是转移明细(首次)
		.i TSourceType=12 Do
		..s SMRowID=$Piece($Get(^DHCEQStoreMoveList(TSourceID)),"^",1)
		..s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)		;SMEquipTypeDR
		..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		..s TSourceNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
		..s TEquipName = $p($g(^DHCEQStoreMoveList(TSourceID)),"^",5)
		..s TUnitDR=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",10)
		..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		..s TDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
		..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		..s TOriginalFee=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",7)
		..s TQuantityNum=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",8)
		..i $Get(^DHCEQPayRecord(rowid,"List"))'="" s TQuantityNum=$length($Get(^DHCEQPayRecord(rowid,"List")),",")
		..i $p($g(^DHCEQStoreMoveList(TSourceID)),"^",3)="Y" d	;SML_BatchFlag
		...s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",$p($g(^DHCEQStoreMoveList(TSourceID)),"^",4),"","","")
        ...q:$p(TInvoiceInfo,"^",1)=0
	    ...s TInvoiceNo=$p(TInvoiceInfo,"^",4)    //modify by mwz 20180313 需求号：550672
		..s TLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
		..i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
		.q:flag'=0
		.
		.s Total=Total+TAmountFee
		.s TFlag="Y"
		.d OutputRowGetPayRequestList
	}
	Quit $$$OK	
OutputRowGetPayRequestList
	s TRow=TRow+1
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	s TPaedFee=##Class(web.DHCEQCommon).FormatNumber(TPaedFee,"")
	s TNeedPayFee=##Class(web.DHCEQCommon).FormatNumber(TNeedPayFee,"")
	s TAmountFee=##Class(web.DHCEQCommon).FormatNumber(TAmountFee,"")
	i TProviderDR="" s TProviderDR=ProviderDR  //add by mwz 需求号551659
	Set Data=$lb(TRowID,TRow,TSourceType,TSourceID,TSourceNo,TDate,TEquipName,TOriginalFee,TQuantityNum,TTotalFee,TPaedFee,TNeedPayFee,TAmountFee,TRemark,TReduceQtyNum,TFlag,TInvoiceNo,TInvoiceDate,TLoc,TAMSLHold3,TListInfo,TEquipType,TProviderDR)    ////modify by mwz 20180313 需求号：550672
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetPayRequestList
	Set (DataList,TRowID,TEquipTypeDR,TSourceType,TSourceID,TSourceNo,TDate,TEquipName,TOriginalFee,TQuantityNum,TTotalFee,TPaedFee,TNeedPayFee,TAmountFee,TRemark,TReduceQtyNum,TFlag,TInvoiceNo,TInvoiceDate,TLoc,TAMSLHold3,TListInfo,TEquipType,TProviderDR)=""
	Quit
}

ClassMethod GetPayRequestListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayRequestListExecute ]
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

ClassMethod GetPayRequestListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayRequestListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQPayRequest).SaveData("4^22613080006^29/08/2013^226^5^2^01/08/2013^^^^^1116^2227^3338^4449^5550","","")
ClassMethod SaveData(val, valList, DelRowid)
{
	Set $ZT="ERRORSave"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	new (val, valList, DelRowid, User)
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	Set RowID=$Piece(val,"^",1)
	
	Set PLIST(2) = $Piece(val,"^",2)	;PN_NoticeNo
	Set PLIST(3) = $Piece(val,"^",3)	;PN_MakeDate
	If $Piece(val,"^",3)'=""  Set PLIST(3) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",3),"date")
	Set PLIST(4) = $Piece(val,"^",4)	;PN_LocDR
	Set PLIST(5) = $Piece(val,"^",5)	;PN_ProviderDR
	Set PLIST(6) = $Piece(val,"^",6)	;PN_Bank
	Set PLIST(7) = $Piece(val,"^",7)	;PN_BankAccount
 	Set PLIST(8) = $Piece(val,"^",8)	;PN_AccountDate
 	Set PLIST(8) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",8),"date")
 	Set PLIST(9) = ##class(web.DHCEQCommon).Replace($Piece(val,"^",9),",","")	;AN_TotalFee 	
 	Set PLIST(10) = $Piece(val,"^",10)	;PN_PurposeType	
 	Set PLIST(11) = $Piece(val,"^",11)	;PN_TypeMode
 	Set PLIST(12) = $Piece(val,"^",12)	;PN_Agent
 	Set PLIST(13) = 0					;PN_Status
 	Set PLIST(14) = $Piece(val,"^",13)	;PN_Remark
 	Set PLIST(15) = User
 	Set PLIST(16) = Date
 	Set PLIST(17) = Time
 	Set PLIST(27) = "N"					;PN_InvalidFlag
 	Set PLIST(28) = $Piece(val,"^",14)	;PayType	付款业务类型	设备1，维修2，配件3
 	Set PLIST(29) = $Piece(val,"^",15)	;SourceType	业务类型
 	Set PLIST(30) = $Piece(val,"^",16)	;Hold1
 	Set PLIST(31) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",17),"bool")	;Hold2
 	Set PLIST(32) = $Piece(val,"^",18)	;Hold3
 	Set PLIST(33) = ##class(web.DHCEQCommon).TransValueFromPage($Piece(val,"^",19),"bool")	;Hold4	Mozy0203	20180224
 	Set PLIST(34) = $Piece(val,"^",20)	;Hold5
	TSTART	
 	if RowID=""
 	{
		If PLIST(2)="" Set PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQPayRequest",Date,$Piece(val,"^",4))
		&SQL(insert into sqluser.DHC_EQPayRequest values :PLIST())
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
		Set RowID=$Get(%ROWID)
 	}
 	else
 	{
		&SQL(update sqluser.DHC_EQPayRequest values :PLIST() where PR_RowID=:RowID)
		If SQLCODE
		{
			TROLLBACK
			Quit SQLCODE
		}
 	}
 	Set SQLCODE=##Class(web.DHCEQPayRequest).SavePayRecordList(RowID,valList,User)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
 	Set ID=RowID
 	Quit ID
ERRORSave 
	TRollBack
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "<ERRORSave>"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQPayRequest).SavePayRecordList(1,"1^^1^275^1^275^1^123.00^^^^^^&2^^1^276^1^276^1^1234.00^^^^^^",1)
ClassMethod SavePayRecordList(RowID As %String = "", val As %String = "", User As %String = "")
{
	Quit:RowID="" -1
	Quit:val="" 0
	
	new Length,Flag,i
	new valList,TSourceType,TSourceID,TotalFee,id
	Kill PLIST
		
	Set Length=$l(val,"&")
	;Set PLIST(2)=RowID		Mozy	588043	2018-11-28	PR_InvoiceDR字段存储错误
	Set Status=$Piece($Get(^DHCEQPayRequest(RowID)),"^",12)
	s BankAccount=$Piece($Get(^DHCEQPayRequest(RowID)),"^",6)
	s MakeDate=$Piece($Get(^DHCEQPayRequest(RowID)),"^",2)
	s PayMode=$Piece($Get(^DHCEQPayRequest(RowID)),"^",10)
	s Agent=$Piece($Get(^DHCEQPayRequest(RowID)),"^",11)
	Set Flag=0
	For i=1:1:Length
	{
		;					1		2			3			4				5			6				7			8				9			10				11			12				13				14			15			16			17
		; valList=valList+TFlag+"^"+TRow+"^"+TRowID+"^"+TSourceType+"^"+TSourceID+"^"+TAmountFee+"^"+TTotalFee+"^"+TPaedFee+"^"+TNeedPayFee+"^"+TRemark+"^"+TListInfo+"^"+TProviderDR+"^"+TInvoiceNo+"^"+TFileNo+"^"+TLocDR+"^"+TAgentDR+"^"+TPayModeDR;
		Quit:Flag'=0
		Set valList=$Piece(val,"&",i)
		set PayFlag=$Piece(valList,"^",1)		;是否是选中的付款记录
		Set PRRowID=$Piece(valList,"^",3)  		;PR_RowID
		Set PLIST(3)=PayMode					;PR_PayMode
		Set PLIST(4)=$Piece(valList,"^",6)  	;PR_PayFee
		Set PLIST(5)=MakeDate					;PR_PayDate
		//Set PLIST(6)=""  						;PR_PayNo
		Set PLIST(7)=BankAccount				;PR_CustomNo
		//Set PLIST(8)=""						;PR_CertificateDR
		Set PLIST(9)=Agent					  	;PR_PayUserDR
		Set PLIST(10)=$Piece(valList,"^",10)  	;PR_Reamrk
		Set PLIST(11)=RowID						;Hold1
 		Set PLIST(12)=$Piece(valList,"^",7)		;Hold2
 		Set PLIST(13)=$Piece(valList,"^",8)		;Hold3
 		Set PLIST(14)=$Piece(valList,"^",9)		;Hold4
 		//Set PLIST(15)=""						;Hold5
 		Set PLIST(16)=$Piece(valList,"^",4)		;PR_SourceType
 		Set PLIST(17)=$Piece(valList,"^",5)		;PR_SourceID
 		Set PLIST(18)=""
 		i $p($g(^DHCEQPayRequest(RowID)),"^",32)="Y" Set PLIST(18)=$Piece(valList,"^",5)	;PR_PayPlanDR	Mozy0203	20180224
 		Set PLIST(19)="1"						;PR_Status
 		Set PLIST(20)=User						;PR_SubmitUserDR
 		Set PLIST(21)=+$H						;PR_SubmitDate
 		Set PLIST(22)=$Piece($H,",",2)			;PR_SubmitTime
 		if Status=0
 		{
	 		if PayFlag="true"
 			{
				;20180424 Mozy0205
	 			s ^DHCEQPayRequest(RowID,"EX",PLIST(16),+PLIST(17))=PLIST(4)
	 			s ^DHCEQPayRequest(RowID,"EX",PLIST(16),+PLIST(17),"List")=$Piece(valList,"^",11)_"^"_$Piece(valList,"^",12)_"^"_$Piece(valList,"^",13)_"^"_$Piece(valList,"^",14)_"^"_$Piece(valList,"^",15)_"^"_$Piece(valList,"^",16)_"^"_$Piece(valList,"^",17)
	 		}
	 		else
	 		{
		 		k ^DHCEQPayRequest(RowID,"EX",PLIST(16),+PLIST(17))	;20180424 Mozy0205
		 	}
	 	}
	 	elseif Status=2
	 	{
		 	if PayFlag="false"  continue	//没有勾选的就不用存
		 	;Mozy	588043	2018-11-28	PR_InvoiceDR 字段存储错误,增加获取和配件转移单业务单发票号
		 	i PLIST(16)=11
		 	{
				;配件出库明细
				s tmpListDR=+$Piece($Get(^DHCEQAMoveStockList(PLIST(17))),"^",15)
				s tmpIUMDR=$o(^DHCEQInvoiceUseMap(0,"Source",3,tmpListDR,""))
				i tmpIUMDR'="" s PLIST(2)=$Piece($Get(^DHCEQInvoiceUseMap(tmpIUMDR)),"^",2)
		 	}
		 	i PLIST(16)=12
		 	{
				;转移明细(首次)
				s tmpEquipDR=+$Get(^DHCEQStoreMoveList(PLIST(17),"EX","RowIDs"))
				s tmpListDR=+$p($g(^DHCEQEquip(tmpEquipDR)),"^",70)
				s tmpIUMDR=$o(^DHCEQInvoiceUseMap(0,"Source",1,tmpListDR,""))
				i tmpIUMDR'="" s PLIST(2)=$Piece($Get(^DHCEQInvoiceUseMap(tmpIUMDR)),"^",2)
		 	}
		 	Set PLIST(19)="2"
			if (PRRowID="")
			{
				&SQL(Insert Into SQLUSER.DHC_EQPayRecord Values :PLIST())
				Set PRLRowID=$Get(%ROWID)
			}
			else
			{
				&SQL(update sqluser.DHC_EQPayRecord Values :PLIST() where PR_RowID=:PRRowID)
			}
			i SQLCODE
	 		{
				Set Flag=SQLCODE
	 		}
	 		s rowid=$Get(%ROWID)
	 		i $Get(^DHCEQPayRequest(RowID,"EX",PLIST(16),PLIST(17),"List"))'="" s ^DHCEQPayRecord(rowid,"List")=$Get(^DHCEQPayRequest(RowID,"EX",PLIST(16),PLIST(17),"List"))
	 		k ^DHCEQPayRequest(RowID,"EX",PLIST(16),PLIST(17))
	 		Quit:Flag'=0
		}
		i $o(^DHCEQPayRequest(RowID,"EX",""))="" k ^DHCEQPayRequest(RowID,"EX")  //20150929 ZY0145 最终审核的时候保存付款记录的信息
	}
	
	Quit Flag
}

/// w ##Class(web.DHCEQPayRequest).SubmitData("4")
ClassMethod SubmitData(RowID As %String = "")
{
	If RowID="" Quit ""
	Set $ZT="ERRORSubmitData"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQPayRequest Set PR_Status=1,PR_SubmitUserDR=:User,PR_SubmitDate=:Date,PR_SubmitTime=:Time where PR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	
 	Quit RowID
ERRORSubmitData 
	TRollBack
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORSubmitData"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQPayRequest).DeleteData("6")
ClassMethod DeleteData(RowID As %String = "")
{
	If RowID="" Quit ""
	Set $ZT="ERRORDelete"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	&SQL(Update SQLUSER.DHC_EQPayRequest Set PR_InvalidFlag='Y',PR_UpdateUserDR=:User,PR_UpdateDate=:Date,PR_UpdateTime=:Time where PR_RowID=:RowID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	k ^DHCEQPayRequest(RowID,"EX")	;删除明细
	TCOMMIT
	
 	Quit SQLCODE
ERRORDelete 
	TRollBack
	Set ErrorMsg=$ZE	     		//得到系统返回的错误消息
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息
}

/// w ##Class(web.DHCEQPaymentNotice).AuditData("4")
ClassMethod AuditData(RowID As %String = "", valList)
{
	If RowID="" Quit ""
	Set $ZT="ERRORGetAudit"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	
	&SQL(Update SQLUSER.DHC_EQPayRequest Set PR_Status=2,PR_AuditUserDR=:User,PR_AuditDate=:Date,PR_AuditTime=:Time where PR_RowID=:RowID)
	//s SQLCODE=0
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	//20150929 ZY0145 最终审核的时候保存付款记录的信息
 	Set SQLCODE=##Class(web.DHCEQPayRequest).SavePayRecordList(RowID,valList,User)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	
 	Quit RowID
ERRORGetAudit 
	TRollBack
	Set ErrorMsg=$ZE	     			//得到系统返回的错误消息
 	Quit "ERRORGetAudit"_ErrorMsg     	//返回错误消息
}

/// w ##Class(web.DHCEQPaymentNotice).CancelSubmitData("4")
ClassMethod CancelSubmitData(RowID As %String = "", InvalidFlag)
{
	If RowID="" Quit ""
	Set $ZT="ERRORCancelSubmitData"
	Set User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set Date=+$H
	Set Time=$Piece($H,",",2)
	
	TSTART
	if InvalidFlag="1"
	{
		&SQL(Update SQLUSER.DHC_EQPayRequest Set PR_Status=3,PR_DisUseUserDR=:User,PR_DisUseDate=:Date,PR_DisUseTime=:Time where PR_RowID=:RowID)
	}
	else
	{
		&SQL(Update SQLUSER.DHC_EQPayRequest Set PR_Status=0 where PR_RowID=:RowID)
	}
	if SQLCODE=100 s SQLCODE=0
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	//写付款记录的审核信息。
	//&SQL(Update SQLUSER.DHC_EQPayRecord Set PR_Status=3,PR_CancelUserDR=:User,PR_CancelDate=:Date,PR_CancelTime=:Time,PR_InvalidFlag='Y' where PR_Hold1=:RowID)
	
	if SQLCODE=100 s SQLCODE=0
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
 	Quit RowID
ERRORCancelSubmitData 
	TRollBack
	Set ErrorMsg=$ZE	     				//得到系统返回的错误消息
 	Quit "ERRORCancelSubmitData"_ErrorMsg   //返回错误消息
}

/// w ##Class(web.DHCEQPayRequest).CheckSourceID(2,1,275,123)
ClassMethod CheckSourceID(PayRequestID, SourceType, SourceID, NeedPayFee)
{
	new rowid,PayRequestDR,PayRequestNo,Flag,Nos
	s Nos=""
	s (Flag,rowid)=0
	//20150929 ZY0145 最终审核的时候保存付款记录的信息
	//s ^DHCEQPayRequest(RowID,"EX",PLIST(16),PLIST(17))=PLIST(4)
	f  s rowid=$o(^DHCEQPayRequest(rowid))  quit:rowid=""  d
	.quit:$D(^DHCEQPayRequest(rowid,"EX"))=0
	.q:rowid=PayRequestID			//Add By DJ 2015-12-23
	.if $D(^DHCEQPayRequest(rowid,"EX",SourceType, SourceID))>0  d
	..s PayRequestNo=$p($g(^DHCEQPayRequest(rowid)),"^",1)
	..s Flag=Flag+1
	..i Nos=""  d
	...s Nos=PayRequestNo
	..e  d
	...s Nos=Nos_","_PayRequestNo
	/*
	f  s rowid=$o(^DHCEQPayRecord(0,"Source",SourceType,SourceID,rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQPayRecord(rowid)),"^",29)="Y"
	.q:$p($g(^DHCEQPayRecord(rowid)),"^",18)="2"
	.s PayRequestDR=$p($g(^DHCEQPayRecord(rowid)),"^",10)
	.q:($p($g(^DHCEQPayRecord(rowid)),"^",10)=PayRequestID)
	.s PayRequestNo=$p($g(^DHCEQPayRequest(PayRequestDR)),"^",1)
	.s Flag=Flag+1
	.i Nos=""  d
	..s Nos=PayRequestNo
	.e  d
	..s Nos=Nos_","_PayRequestNo
	*/
	
	quit Flag_"^"_Nos
}

/// 检测明细记录是否在别的申请单
/// w ##Class(web.DHCEQPayRequest).CheckSourceIDIsFind(6,3,6)
ClassMethod CheckSourceIDIsFind(PayRequestID, SourceType, SourceID)
{
	new rowid,PayRequestDR,Flag
	s (Flag,rowid)=0
	f  s rowid=$o(^DHCEQPayRecord(0,"Source",SourceType,SourceID,rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQPayRecord(rowid)),"^",29)="Y"
	.q:$p($g(^DHCEQPayRecord(rowid)),"^",18)="3"
	.s PayRequestDR=$p($g(^DHCEQPayRecord(rowid)),"^",10)
	.q:($p($g(^DHCEQPayRecord(rowid)),"^",10)=PayRequestID)
	.s Flag=Flag+1
	
	quit Flag
}

/// Mozy	2015-8-5	重写
/// w ##Class(web.DHCEQPayRequest).GetListNew(3)
ClassMethod GetListNew(PayRequestDR As %Library.String = "")
{
	Quit:PayRequestDR="" ""
	Set Data=""
	Set Num=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	Set (sumFee,sumQty,sumPayFee)=0
	Set TempID=$I(^DHCEQTemp("web.DHCEQPayRequest",+$H))
	
	Set rowid=0 
	For  Set rowid=$Order(^DHCEQPayRecord(rowid)) Quit:rowid=""  Do
	.Quit:$Piece($Get(^DHCEQPayRecord(rowid)),"^",10)'=PayRequestDR
	.Set DataList=$Get(^DHCEQPayRecord(rowid))
	.Set TSourceTypeDR=$Piece(DataList,"^",15)
	.Set TPayFee=+$Piece(DataList,"^",3)
	.Set TSourceID=$P(DataList,"^",16)
	.Set TPayPlanDR=$P(DataList,"^",17)	;Mozy0203	20180224
	.Set (TUseLoc,TEquipName,TModel,TUnit,TQuantityNum,TOriginalFee,TAmount,TExpenditures,TLocation,flag,TEquipTypeDR,TAccessoryTypeDR)=""
	.
	.;来源类型是入库单
	.i TSourceTypeDR=1 Do
	..Set ISRowID=$P($G(^DHCEQInStockList(TSourceID)),"^",1)
	..s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",TSourceID,"","","")
    ..;q:$p(TInvoiceInfo,"^",1)=0
    ..s TInvoiceNo=$p(TInvoiceInfo,"^",4)
    ..s TInvoiceDate=$p(TInvoiceInfo,"^",5)
	..s TSourceNo=$P($G(^DHCEQInStock(ISRowID)),"^",14)
	..s TDate=$P($G(^DHCEQInStock(ISRowID)),"^",1)
	..s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..s TEquipTypeDR=$P($G(^DHCEQInStock(ISRowID)),"^",20)
	..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	..s TEquipName=$P($G(^DHCEQInStockList(TSourceID)),"^",5)
	..s TOriginalFee=+$P($G(^DHCEQInStockList(TSourceID)),"^",7)
	..s TQuantityNum=$P($G(^DHCEQInStockList(TSourceID)),"^",8)
	..Set TAmount=$fn(TPayFee,"",2)
	..Set TUseLoc = $P($G(^DHCEQInStock(ISRowID)),"^",2)  //申购科室
	..If TUseLoc'="" Set TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..Set TModel=$P($G(^DHCEQInStockList(TSourceID)),"^",9)
	..If TModel'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	..Set TUnit=$P($G(^DHCEQInStockList(TSourceID)),"^",10)
	..If TUnit'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	..If $P($G(^DHCEQInStockList(TSourceID)),"^",18)=2 Do
	...Set TLocation=$Piece($Get(^DHCEQOpenCheckList($P($G(^DHCEQInStockList(TSourceID)),"^",19))),"^",26)
	...If TLocation'="" Set TLocation=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	...Set TExpenditures=$Piece($Get(^DHCEQOpenCheckList($P($G(^DHCEQInStockList(TSourceID)),"^",19))),"^",59)
	...If TExpenditures'="" Set TExpenditures=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TExpenditures)),"^",2)
	.Quit:flag=1
	.
	.;来源类型是采购合同	374639	Mozy	20170518
	.i TSourceTypeDR=2 Do
	..s CTRowID=$P($G(^DHCEQContractList(TSourceID)),"^",1)
	..s CTLST=$Piece($Get(^DHCEQContractList(TSourceID)),"^",5)	;1计划	2招标  3设备项
	..s CTLSI=$Piece($Get(^DHCEQContractList(TSourceID)),"^",17)
	..i CTLST=1 s TEquipTypeDR=$p($g(^DHCEQBuyPlan(CTLSI)),"^",12)
	..i CTLST=2 d
	..s TExtendTypeDR = $Piece($Get(^DHCEQIFBBag(CTLSI)),"^",9)
	..s TExtendID = $Piece($Get(^DHCEQIFBBag(CTLSI)),"^",10)
	..If TExtendTypeDR=2 Do
	...s TExtendName=$Piece($Get(^DHCEQBuyPlanList(TExtendID)),"^",1)	;采购计划
	...s TEquipTypeDR=$p($g(^DHCEQBuyPlan(TExtendName)),"^",12)
	..i CTLST=3 s TEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",CTLSI)),"^",3)              
	..s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	..s TSourceNo=$Piece($Get(^DHCEQContract(CTRowID)),"^",2)
	..s TEquipName = $Piece($Get(^DHCEQContractList(TSourceID)),"^",2)
	..s TModelDR = $Piece($Get(^DHCEQContractList(TSourceID)),"^",3)
	..i TModelDR'="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s CTLSI=$Piece($Get(^DHCEQContractList(TSourceID)),"^",17)
	..s TUnitDR=$p($g(^DHCEQEquip(CTLSI)),"^",5)
	..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TOriginalFee=$p($g(^DHCEQContractList(TSourceID)),"^",6)	;原值
	..s TQuantityNum=$p($g(^DHCEQContractList(TSourceID)),"^",7)
	..s TUseLoc=$p($g(^DHCEQContract(CTRowID)),"^",8)   ;合同签订部门
	..s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..s TDate=$p($g(^DHCEQContract(CTRowID)),"^",7)	;合同签订日期
	..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	.Quit:flag=1
	.
	.;来源类型是验收单
	.If TSourceTypeDR=3 Do
	..Set OCRRowID=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",1)
	..Set TSourceNo=$Piece($Get(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)
	..Set TDate=$Piece($Get(^DHCEQOpenCheckRequest(OCRRowID)),"^",10)
	..Set TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..Set TEquipTypeDR=$Piece($Get(^DHCEQOpenCheckRequest(OCRRowID)),"^",2)
	..Set flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	..Set TEquipName = $Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",2)
	..Set TOriginalFee=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",17)
	..Set TQuantityNum=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",16)
	..Set TLocation=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",26)
	..If TLocation'="" Set TLocation=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	..Set TExpenditures=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",59)
	..If TExpenditures'="" Set TExpenditures=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TExpenditures)),"^",2)
	..Set TUseLoc = $Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",33)  //使用科室
	..If TUseLoc'="" Set TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..Set TModel=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",5)
	..If TModel'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	..Set TUnit=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",7)
	..If TUnit'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	..Set TAmount=$fn(TOriginalFee*TQuantityNum,"",2)
	.Quit:flag=1
	.
	.;来源类型是保修合同	Mozy0203	20180224
	.i TSourceTypeDR=8 Do
	..i TPayPlanDR'="" d
	...i $Piece($Get(^DHCEQPayPlan(TSourceID)),"^",2)=1 d
	....;按保修合同制定的付款计划取值	^DHCEQPayPlan	付款计划
	....s SID=$Piece($Get(^DHCEQPayPlan(TSourceID)),"^",3)
	....Set TProviderDR=$Piece($Get(^DHCEQContract(SID)),"^",18)
	....Set TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商
	....s ContractListDR=""
	....f  s ContractListDR=$o(^DHCEQContractList(0,"Contract",SID,ContractListDR)) quit:(ContractListDR="")||(flag'=0)  d
	.....;;;Mozy	2018-3-26	567216	修正保修合同明细的类组取值
	.....s ContractListSType = $p($g(^DHCEQContractList(ContractListDR)),"^",5)	;1:计划 2:招标 3:设备项 4:设备 5:入库明细
	.....s ContractListSID = $p($g(^DHCEQContractList(ContractListDR)),"^",17)
	.....i ContractListSType=1 d
	......Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(ContractListSID)),"^",1))),"^",12)
	.....else  if ContractListSType=2 d
	......Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(ContractListSID)),"^",3)
	......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
	.....else  if ContractListSType=3 d
	......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",ContractListSID)),"^",3)
	.....else  if ContractListSType=4 d
	......Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",63)
	.....else  if ContractListSType=5 d
	......Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(ContractListSID)),"^",1))),"^",20)
	.....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR)
	....;; End
	....Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	....s TEquipName=$p($g(^DHCEQPayPlan(TSourceID)),"^",1)
	....s TOriginalFee=$p($g(^DHCEQPayPlan(TSourceID)),"^",10)	;PP_PayAmount
	....Set TSourceNo=$p($g(^DHCEQContract(SID)),"^",2)
	....Set TEquipName=$p($g(^DHCEQContract(SID)),"^",1)_"("_TEquipName
	....Set TEquipName=TEquipName_"计划支付日期:"_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayPlan(TSourceID)),"^",6),"date")_")"
	....If TOriginalFee="" Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(SID)),"^",4),0)*0.01*$p($g(^DHCEQPayPlan(TSourceID)),"^",9)
	....s TQuantityNum=1
	....;s TDate=$p($g(^DHCEQPayPlan(TSourceID)),"^",6)
	....;i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	....s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p($g(^DHCEQContract(SID)),"^",8))	;合同签订部门
	....i ContractListSType=2 s TFileNo=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",85)
	....s PayInfo=##Class(web.DHCEQPay).CheckPayInfo("8",TSourceID,"","","",TSourceID)
	....s TTotalFee=TOriginalFee
	....s TPaedFee=$p(PayInfo,"^",2)
	....s TNeedPayFee=TTotalFee-TPaedFee
	..e  d
	...s CTLRowID=0
	...f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",TSourceID,CTLRowID)) q:(CTLRowID="")||(flag'=0)  d
	....s CTLST=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",5)	;1入库明细	2设备
	....s CTLSI=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",17)
	....;;;Mozy	2018-3-26	567216	修正保修合同明细的类组取值
	....s TEquipTypeDR=""
	....i CTLST=1 d
	.....Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(CTLSI)),"^",1))),"^",12)
	....else  if CTLST=2 d
	.....Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(CTLSI)),"^",3)
	.....Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
	....else  if CTLST=3 d
	.....Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",CTLSI)),"^",3)
	....else  if CTLST=4 d
	.....Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(CTLSI)),"^",63)
	....else  if CTLST=5 d
	.....Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(CTLSI)),"^",1))),"^",20)
	....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR)
	....;; End
	...s TSourceNo=$Piece($Get(^DHCEQContract(TSourceID)),"^",2)
	...s TEquipName = $Piece($Get(^DHCEQContract(TSourceID)),"^",1)
	...s TProviderDR = $Piece($Get(^DHCEQContract(TSourceID)),"^",18)
	...s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	...;s TDate=$p($g(^DHCEQContract(TSourceID)),"^",7)	;合同签订日期
	...;s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	...s TOriginalFee=$Piece($Get(^DHCEQContract(TSourceID)),"^",5)	;买保金额
	...s TQuantityNum=1
	...s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(8,TSourceID,"","","","")
	...s TTotalFee=TQuantityNum*TOriginalFee
	...s TPaedFee=$p(PayInfo,"^",2)
	...s TNeedPayFee=TTotalFee-TPaedFee
	...s TLoc=$p($g(^DHCEQContract(TSourceID)),"^",8)   ;合同签订部门
	...s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
	...s GlobalData=$Get(^DHCEQPayRecord(rowid,"List"))
	...s TFileNo=$Piece(GlobalData,"^",4)
	...s TLocDR=$Piece(GlobalData,"^",5)
	...i TLocDR'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.Quit:flag=1
	.
	.;配件入库明细
	.i TSourceTypeDR=9 Do
	..s AISRowID=$P($G(^DHCEQAInStockList(TSourceID)),"^",1)
	..s TEquipTypeDR=$Piece($Get(^DHCEQAInStock(AISRowID)),"^",2)
	..s flag=##class(web.DHCEQACommon).AccessoryTypeIsIn(TEquipTypeDR)
	..
	..s TSourceNo=$p(^DHCEQAInStock(AISRowID),"^",6)
	..s TEquipName = $p($g(^DHCEQAInStockList(TSourceID)),"^",4)
	..s TModel=$p($g(^DHCEQAInStockList(TSourceID)),"^",5)
	..s TUnitDR=$p($g(^DHCEQAInStockList(TSourceID)),"^",6)
	..s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TDate=$p($g(^DHCEQAInStock(TSourceID)),"^",1)
	..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..s TOriginalFee=$p($g(^DHCEQAInStockList(TSourceID)),"^",8)
	..s TQuantityNum=$p($g(^DHCEQAInStockList(TSourceID)),"^",9)
	..s TInvoiceNo=$p($g(^DHCEQAInStockList(TSourceID)),"^",19)
	..;过滤退货减少的配件
	..s TReduceQtyNum=0
	..s ARLRowID=0
	..f  s ARLRowID=$o(^DHCEQAReduceList(ARLRowID)) q:ARLRowID=""  d
	...q:$Piece($Get(^DHCEQAReduce($Piece($Get(^DHCEQAReduceList(ARLRowID)),"^",1))),"^",23)'=2
	...s StockDetailDR=$Piece($Get(^DHCEQAReduceList(ARLRowID)),"^",5)
	...q:$Piece($Get(^DHCEQAStockDetail(StockDetailDR)),"^",3)'=TSourceID
	...s TReduceQtyNum=TReduceQtyNum+$Piece($Get(^DHCEQAReduceList(ARLRowID)),"^",10)
	..s TTotalFee=(TQuantityNum-TReduceQtyNum)*TOriginalFee
	..s TQuantityNum=TQuantityNum-TReduceQtyNum
	..s TUseLoc=$p($g(^DHCEQAInStock(AISRowID)),"^",3)
	..s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	.Quit:flag=1
	.
	.;来源类型是配件转移单
	.i TSourceTypeDR=11 Do
	..s AMSRowID=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",1)
	..s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)
	..s flag=##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
	..s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",15)	;入库明细AISL_InStockListDR
	..s AISRowID=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",1)
	..s TSourceNo=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",1)
	..s TEquipName = $p($g(^DHCEQAMoveStockList(TSourceID)),"^",4)
	..s TUnitDR=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",6)
	..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TDate=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",7)
	..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..s TOriginalFee=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",10)
	..s TQuantityNum=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",11)
	..s TInvoiceNo=$p($g(^DHCEQAInStockList(AMSLAISListDR)),"^",19)
	..s TUseLoc=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",5)
	..i TUseLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..Set TModel=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",5)
	..s TAMSLHold3=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",20)	;Mozy	588024	2018-11-28
	.Quit:flag=1
	.
	.;来源类型是转移明细(首次)
	.i TSourceTypeDR=12 Do
	..s SMRowID=$Piece($Get(^DHCEQStoreMoveList(TSourceID)),"^",1)
	..s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)		;SMEquipTypeDR
	..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	..s TSourceNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	..s TEquipName = $p($g(^DHCEQStoreMoveList(TSourceID)),"^",5)
	..s TUnitDR=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",10)
	..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
	..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..s TOriginalFee=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",7)
	..s TQuantityNum=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",8)
	..i $Get(^DHCEQPayRecord(rowid,"List"))'="" s TQuantityNum=$length($Get(^DHCEQPayRecord(rowid,"List")),",")
	..i $p($g(^DHCEQStoreMoveList(TSourceID)),"^",3)="Y" d	;SML_BatchFlag
	...s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",$p($g(^DHCEQStoreMoveList(TSourceID)),"^",4),"","","")
    ...q:$p(TInvoiceInfo,"^",1)=0
	...s TInvoiceNo=$p(TInvoiceInfo,"^",4)
	..s TUseLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
	..i TUseLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..Set TModel=$P($G(^DHCEQStoreMoveList(TSourceID)),"^",9)
	..If TModel'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	..s EquipDRs=+$Get(^DHCEQStoreMoveList(TSourceID,"EX","RowIDs"))
	..i EquipDRs>0 d
	...s OCLRowID=$Piece($Get(^DHCEQEquip(EquipDRs)),"^",77)
	...i OCLRowID'="" d
	....Set TLocation=$Piece($Get(^DHCEQOpenCheckList(OCLRowID)),"^",26)
	....If TLocation'="" Set TLocation=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	....Set TExpenditures=$Piece($Get(^DHCEQOpenCheckList(OCLRowID)),"^",59)
	....If TExpenditures'="" Set TExpenditures=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TExpenditures)),"^",2)
	.Quit:flag=1
	.
	.;If TUseLoc="" Set TUseLoc="zzzzz-南方医院"
	.;If TEquipName="" Set TEquipName="东华软件"
	.Set ^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID,TUseLoc,TEquipName,TSourceID)=TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TAmount_"^"_TExpenditures_"^"_TLocation_"^"_TPayFee_"^"_TEquipTypeDR
	.i TEquipTypeDR="" s ^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID,TUseLoc,TEquipName,TSourceID)=^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID,TUseLoc,TEquipName,TSourceID)_TAccessoryTypeDR
	
	/// 拼串输出
	Set TUseLoc="" 
	For  Set TUseLoc=$Order(^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID,TUseLoc)) Quit:TUseLoc=""  Do
	.Set TEquipName="" 
	.For  Set TEquipName=$Order(^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID,TUseLoc,TEquipName)) Quit:TEquipName=""  Do
	..Set ID="" 
	..For  Set ID=$Order(^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID,TUseLoc,TEquipName,ID)) Quit:ID=""  Do
	...Set DataList=$Get(^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID,TUseLoc,TEquipName,ID))
	...Set tmpTUseLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TUseLoc,"-")
	...Set Data=Data_SplitRowCode_tmpTUseLoc_"^"_TEquipName_"^"_DataList
	...Set Num=Num+1
	...Set sumQty=sumQty+$Piece(DataList,"^",3)
	...Set sumFee=sumFee+$Piece(DataList,"^",5)
	...Set sumPayFee=sumPayFee+$Piece(DataList,"^",8)
	
	If Data'="" Do
	.Set sumFee=$Fn(sumFee,",",2)
	.Set sumPayFee=$Fn(sumPayFee,",",2)
	.Set Data=Data_SplitRowCode_"合计^^^^"_sumQty_"^^"_sumFee_"^^^"_sumPayFee
	.Set Num=Num+1
	Kill ^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID)
	Quit Data_SplitNumCode_Num
}

/// Creator：      WL
/// CreatDate：    2019-11-20
/// Description:   润乾打印(付款管理--请领报销单)
/// Input：        PayRequestDR:付款申请ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQPayRequest","GetNewPrint","7")
Query GetNewPrint(PayRequestDR As %String = "") As %Query(ROWSPEC = "PRPayRequestNo:%String,PRMakeDate:%String,PRLocDR_UName:%String,PRProviderDR_VName:%String") [ SqlProc ]
{
}

ClassMethod GetNewPrintExecute(ByRef qHandle As %Binary, PayRequestDR As %String = "", CurGroupID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
	Quit:PayRequestDR="" ""
	i PayRequestDR'=""  d
	.s (TPayRequestNo,TMakeDate,TLocDR,TLoc,TProviderDR,TProvider)=""
	.s TPayRequestNo=$p($g(^DHCEQPayRequest(PayRequestDR)),"^",1) //付款单号
	.s TMakeDate=$p($g(^DHCEQPayRequest(PayRequestDR)),"^",2) //制单日期
	.i TMakeDate'="" s TMakeDate=##Class(web.DHCEQCommon).TransValueToPage(TMakeDate,"datetime")
	.s TLocDR=$p($g(^DHCEQPayRequest(PayRequestDR)),"^",3) //使用科室
	.i TLocDR'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.i TLocDR="571" s TLoc="设备器材科"
	.s TProviderDR= $p($g(^DHCEQPayRequest(PayRequestDR)),"^",4)
	.i TProviderDR'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR) //供应商
 	.d OutputRowGetNewPrint

 Set qHandle=$lb(0,repid,0)
 Quit $$$OK	 
OutputRowGetNewPrint
 set Data=$lb(TPayRequestNo,TMakeDate,TLoc,TProvider) 
 set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetNewPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetNewPrintExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
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

ClassMethod GetNewPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetNewPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      WL
/// CreatDate：    2019-11-20
/// Description:   润乾打印(付款管理--请领报销单明细)
/// Input：        PayRequestDR:付款申请ID
/// d ##class(%ResultSet).RunQuery("web.DHCEQPayRequest","GetListNewPrint","7","85")
Query GetListNewPrint(PayRequestDR As %String = "", CurGroupID As %String = "") As %Query(ROWSPEC = "Num:%String,TUseLoc:%String,TModel:%String,TEquipName:%String,TUnit:%String,TQuantityNum:%String,TOriginalFee:%String,TAmount:%String,TExpenditures:%String,TLocation: %String") [ SqlProc ]
{
}

ClassMethod GetListNewPrintExecute(ByRef qHandle As %Binary, PayRequestDR As %String = "", CurGroupID As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
 	s ind=1
	Quit:PayRequestDR="" ""
	Set Data=""
	Set Num=1
	Set (sumFee,sumQty,sumPayFee)=0
	Set TempID=$I(^DHCEQTemp("web.DHCEQPayRequest",+$H))
	Set rowid=0 
	For  Set rowid=$Order(^DHCEQPayRecord(rowid)) Quit:rowid=""  Do
	.Quit:$Piece($Get(^DHCEQPayRecord(rowid)),"^",10)'=PayRequestDR
	.Set DataList=$Get(^DHCEQPayRecord(rowid))
	.Set TSourceTypeDR=$Piece(DataList,"^",15)
	.Set TPayFee=+$Piece(DataList,"^",3)
	.Set TSourceID=$P(DataList,"^",16)
	.Set TPayPlanDR=$P(DataList,"^",17)	;Mozy0203	20180224
	.Set (TUseLoc,TEquipName,TModel,TUnit,TQuantityNum,TOriginalFee,TAmount,TExpenditures,TLocation,flag,TEquipTypeDR,TAccessoryTypeDR)=""
	.;来源类型是入库单
	.i TSourceTypeDR=1 Do
	..Set ISRowID=$P($G(^DHCEQInStockList(TSourceID)),"^",1)
	..s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",TSourceID,"","","")
    ..;q:$p(TInvoiceInfo,"^",1)=0
    ..s TInvoiceNo=$p(TInvoiceInfo,"^",4)
    ..s TInvoiceDate=$p(TInvoiceInfo,"^",5)
	..s TSourceNo=$P($G(^DHCEQInStock(ISRowID)),"^",14)
	..s TDate=$P($G(^DHCEQInStock(ISRowID)),"^",1)
	..s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..s TEquipTypeDR=$P($G(^DHCEQInStock(ISRowID)),"^",20)
	..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	..s TEquipName=$P($G(^DHCEQInStockList(TSourceID)),"^",5)
	..s TOriginalFee=+$P($G(^DHCEQInStockList(TSourceID)),"^",7)
	..s TQuantityNum=$P($G(^DHCEQInStockList(TSourceID)),"^",8)
	..Set TAmount=$fn(TPayFee,"",2)
	..Set TUseLoc = $P($G(^DHCEQInStock(ISRowID)),"^",2)  //申购科室
	..If TUseLoc'="" Set TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..Set TModel=$P($G(^DHCEQInStockList(TSourceID)),"^",9)
	..If TModel'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	..Set TUnit=$P($G(^DHCEQInStockList(TSourceID)),"^",10)
	..If TUnit'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	..If $P($G(^DHCEQInStockList(TSourceID)),"^",18)=2 Do
	...Set TLocation=$Piece($Get(^DHCEQOpenCheckList($P($G(^DHCEQInStockList(TSourceID)),"^",19))),"^",26)
	...If TLocation'="" Set TLocation=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	...Set TExpenditures=$Piece($Get(^DHCEQOpenCheckList($P($G(^DHCEQInStockList(TSourceID)),"^",19))),"^",59)
	...If TExpenditures'="" Set TExpenditures=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TExpenditures)),"^",2)
	.Quit:flag=1
	.
	.;来源类型是采购合同	374639	Mozy	20170518
	.i TSourceTypeDR=2 Do
	..s CTRowID=$P($G(^DHCEQContractList(TSourceID)),"^",1)
	..s CTLST=$Piece($Get(^DHCEQContractList(TSourceID)),"^",5)	;1计划	2招标  3设备项
	..s CTLSI=$Piece($Get(^DHCEQContractList(TSourceID)),"^",17)
	..i CTLST=1 s TEquipTypeDR=$p($g(^DHCEQBuyPlan(CTLSI)),"^",12)
	..i CTLST=2 d
	..s TExtendTypeDR = $Piece($Get(^DHCEQIFBBag(CTLSI)),"^",9)
	..s TExtendID = $Piece($Get(^DHCEQIFBBag(CTLSI)),"^",10)
	..If TExtendTypeDR=2 Do
	...s TExtendName=$Piece($Get(^DHCEQBuyPlanList(TExtendID)),"^",1)	;采购计划
	...s TEquipTypeDR=$p($g(^DHCEQBuyPlan(TExtendName)),"^",12)
	..i CTLST=3 s TEquipTypeDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",CTLSI)),"^",3)              
	..s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	..s TSourceNo=$Piece($Get(^DHCEQContract(CTRowID)),"^",2)
	..s TEquipName = $Piece($Get(^DHCEQContractList(TSourceID)),"^",2)
	..s TModelDR = $Piece($Get(^DHCEQContractList(TSourceID)),"^",3)
	..i TModelDR'="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	..s CTLSI=$Piece($Get(^DHCEQContractList(TSourceID)),"^",17)
	..s TUnitDR=$p($g(^DHCEQEquip(CTLSI)),"^",5)
	..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TOriginalFee=$p($g(^DHCEQContractList(TSourceID)),"^",6)	;原值
	..s TQuantityNum=$p($g(^DHCEQContractList(TSourceID)),"^",7)
	..s TUseLoc=$p($g(^DHCEQContract(CTRowID)),"^",8)   ;合同签订部门
	..s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..s TDate=$p($g(^DHCEQContract(CTRowID)),"^",7)	;合同签订日期
	..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	.Quit:flag=1
	.
	.;来源类型是验收单
	.If TSourceTypeDR=3 Do
	..Set OCRRowID=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",1)
	..Set TSourceNo=$Piece($Get(^DHCEQOpenCheckRequest(OCRRowID)),"^",37)
	..Set TDate=$Piece($Get(^DHCEQOpenCheckRequest(OCRRowID)),"^",10)
	..Set TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..Set TEquipTypeDR=$Piece($Get(^DHCEQOpenCheckRequest(OCRRowID)),"^",2)
	..Set flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	..Set TEquipName = $Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",2)
	..Set TOriginalFee=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",17)
	..Set TQuantityNum=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",16)
	..Set TLocation=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",26)
	..If TLocation'="" Set TLocation=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	..Set TExpenditures=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",59)
	..If TExpenditures'="" Set TExpenditures=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TExpenditures)),"^",2)
	..Set TUseLoc = $Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",33)  //使用科室
	..If TUseLoc'="" Set TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..Set TModel=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",5)
	..If TModel'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	..Set TUnit=$Piece($Get(^DHCEQOpenCheckList(TSourceID)),"^",7)
	..If TUnit'="" Set TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	..Set TAmount=$fn(TOriginalFee*TQuantityNum,"",2)
	.Quit:flag=1
	.
	.;来源类型是保修合同	Mozy0203	20180224
	.i TSourceTypeDR=8 Do
	..i TPayPlanDR'="" d
	...i $Piece($Get(^DHCEQPayPlan(TSourceID)),"^",2)=1 d
	....;按保修合同制定的付款计划取值	^DHCEQPayPlan	付款计划
	....s SID=$Piece($Get(^DHCEQPayPlan(TSourceID)),"^",3)
	....Set TProviderDR=$Piece($Get(^DHCEQContract(SID)),"^",18)
	....Set TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商
	....s ContractListDR=""
	....f  s ContractListDR=$o(^DHCEQContractList(0,"Contract",SID,ContractListDR)) quit:(ContractListDR="")||(flag'=0)  d
	.....;;;Mozy	2018-3-26	567216	修正保修合同明细的类组取值
	.....s ContractListSType = $p($g(^DHCEQContractList(ContractListDR)),"^",5)	;1:计划 2:招标 3:设备项 4:设备 5:入库明细
	.....s ContractListSID = $p($g(^DHCEQContractList(ContractListDR)),"^",17)
	.....i ContractListSType=1 d
	......Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(ContractListSID)),"^",1))),"^",12)
	.....else  if ContractListSType=2 d
	......Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(ContractListSID)),"^",3)
	......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
	.....else  if ContractListSType=3 d
	......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",ContractListSID)),"^",3)
	.....else  if ContractListSType=4 d
	......Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",63)
	.....else  if ContractListSType=5 d
	......Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(ContractListSID)),"^",1))),"^",20)
	.....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR,CurGroupID)
	....;; End
	....Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
	....s TEquipName=$p($g(^DHCEQPayPlan(TSourceID)),"^",1)
	....s TOriginalFee=$p($g(^DHCEQPayPlan(TSourceID)),"^",10)	;PP_PayAmount
	....Set TSourceNo=$p($g(^DHCEQContract(SID)),"^",2)
	....Set TEquipName=$p($g(^DHCEQContract(SID)),"^",1)_"("_TEquipName
	....Set TEquipName=TEquipName_"计划支付日期:"_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayPlan(TSourceID)),"^",6),"date")_")"
	....If TOriginalFee="" Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(SID)),"^",4),0)*0.01*$p($g(^DHCEQPayPlan(TSourceID)),"^",9)
	....s TQuantityNum=1
	....;s TDate=$p($g(^DHCEQPayPlan(TSourceID)),"^",6)
	....;i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	....s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p($g(^DHCEQContract(SID)),"^",8))	;合同签订部门
	....i ContractListSType=2 s TFileNo=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",85)
	....s PayInfo=##Class(web.DHCEQPay).CheckPayInfo("8",TSourceID,"","","",TSourceID)
	....s TTotalFee=TOriginalFee
	....s TPaedFee=$p(PayInfo,"^",2)
	....s TNeedPayFee=TTotalFee-TPaedFee
	..e  d
	...s CTLRowID=0
	...f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",TSourceID,CTLRowID)) q:(CTLRowID="")||(flag'=0)  d
	....s CTLST=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",5)	;1入库明细	2设备
	....s CTLSI=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",17)
	....;;;Mozy	2018-3-26	567216	修正保修合同明细的类组取值
	....s TEquipTypeDR=""
	....i CTLST=1 d
	.....Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(CTLSI)),"^",1))),"^",12)
	....else  if CTLST=2 d
	.....Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(CTLSI)),"^",3)
	.....Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
	....else  if CTLST=3 d
	.....Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",CTLSI)),"^",3)
	....else  if CTLST=4 d
	.....Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(CTLSI)),"^",63)
	....else  if CTLST=5 d
	.....Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(CTLSI)),"^",1))),"^",20)
	....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR,CurGroupID)
	....;; End
	...s TSourceNo=$Piece($Get(^DHCEQContract(TSourceID)),"^",2)
	...s TEquipName = $Piece($Get(^DHCEQContract(TSourceID)),"^",1)
	...s TProviderDR = $Piece($Get(^DHCEQContract(TSourceID)),"^",18)
	...s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	...;s TDate=$p($g(^DHCEQContract(TSourceID)),"^",7)	;合同签订日期
	...;s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	...s TOriginalFee=$Piece($Get(^DHCEQContract(TSourceID)),"^",5)	;买保金额
	...s TQuantityNum=1
	...s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(8,TSourceID,"","","","")
	...s TTotalFee=TQuantityNum*TOriginalFee
	...s TPaedFee=$p(PayInfo,"^",2)
	...s TNeedPayFee=TTotalFee-TPaedFee
	...s TLoc=$p($g(^DHCEQContract(TSourceID)),"^",8)   ;合同签订部门
	...s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
	...s GlobalData=$Get(^DHCEQPayRecord(rowid,"List"))
	...s TFileNo=$Piece(GlobalData,"^",4)
	...s TLocDR=$Piece(GlobalData,"^",5)
	...i TLocDR'="" s TUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.Quit:flag=1
	.
	.;配件入库明细
	.i TSourceTypeDR=9 Do
	..s AISRowID=$P($G(^DHCEQAInStockList(TSourceID)),"^",1)
	..s TEquipTypeDR=$Piece($Get(^DHCEQAInStock(AISRowID)),"^",2)
	..s flag=##class(web.DHCEQACommon).AccessoryTypeIsIn(TEquipTypeDR,CurGroupID)
	..
	..s TSourceNo=$p(^DHCEQAInStock(AISRowID),"^",6)
	..s TEquipName = $p($g(^DHCEQAInStockList(TSourceID)),"^",4)
	..s TModel=$p($g(^DHCEQAInStockList(TSourceID)),"^",5)
	..s TUnitDR=$p($g(^DHCEQAInStockList(TSourceID)),"^",6)
	..s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TDate=$p($g(^DHCEQAInStock(TSourceID)),"^",1)
	..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..s TOriginalFee=$p($g(^DHCEQAInStockList(TSourceID)),"^",8)
	..s TQuantityNum=$p($g(^DHCEQAInStockList(TSourceID)),"^",9)
	..s TInvoiceNo=$p($g(^DHCEQAInStockList(TSourceID)),"^",19)
	..;过滤退货减少的配件
	..s TReduceQtyNum=0
	..s ARLRowID=0
	..f  s ARLRowID=$o(^DHCEQAReduceList(ARLRowID)) q:ARLRowID=""  d
	...q:$Piece($Get(^DHCEQAReduce($Piece($Get(^DHCEQAReduceList(ARLRowID)),"^",1))),"^",23)'=2
	...s StockDetailDR=$Piece($Get(^DHCEQAReduceList(ARLRowID)),"^",5)
	...q:$Piece($Get(^DHCEQAStockDetail(StockDetailDR)),"^",3)'=TSourceID
	...s TReduceQtyNum=TReduceQtyNum+$Piece($Get(^DHCEQAReduceList(ARLRowID)),"^",10)
	..s TTotalFee=(TQuantityNum-TReduceQtyNum)*TOriginalFee
	..s TQuantityNum=TQuantityNum-TReduceQtyNum
	..s TUseLoc=$p($g(^DHCEQAInStock(AISRowID)),"^",3)
	..s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	.Quit:flag=1
	.
	.;来源类型是配件转移单
	.i TSourceTypeDR=11 Do
	..s AMSRowID=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",1)
	..s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)
	..s flag=##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR,CurGroupID)
	..s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",15)	;入库明细AISL_InStockListDR
	..s AISRowID=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",1)
	..s TSourceNo=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",1)
	..s TEquipName = $p($g(^DHCEQAMoveStockList(TSourceID)),"^",4)
	..s TUnitDR=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",6)
	..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TDate=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",7)
	..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..s TOriginalFee=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",10)
	..s TQuantityNum=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",11)
	..s TInvoiceNo=$p($g(^DHCEQAInStockList(AMSLAISListDR)),"^",19)
	..s TUseLoc=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",5)
	..i TUseLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..Set TModel=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",5)
	..s TAMSLHold3=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",20)	;Mozy	588024	2018-11-28
	.Quit:flag=1
	.
	.;来源类型是转移明细(首次)
	.i TSourceTypeDR=12 Do
	..s SMRowID=$Piece($Get(^DHCEQStoreMoveList(TSourceID)),"^",1)
	..s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)		;SMEquipTypeDR
	..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	..s TSourceNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	..s TEquipName = $p($g(^DHCEQStoreMoveList(TSourceID)),"^",5)
	..s TUnitDR=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",10)
	..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	..s TDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
	..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	..s TOriginalFee=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",7)
	..s TQuantityNum=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",8)
	..i $Get(^DHCEQPayRecord(rowid,"List"))'="" s TQuantityNum=$length($Get(^DHCEQPayRecord(rowid,"List")),",")
	..i $p($g(^DHCEQStoreMoveList(TSourceID)),"^",3)="Y" d	;SML_BatchFlag
	...s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",$p($g(^DHCEQStoreMoveList(TSourceID)),"^",4),"","","")
    ...q:$p(TInvoiceInfo,"^",1)=0
	...s TInvoiceNo=$p(TInvoiceInfo,"^",4)
	..s TUseLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
	..i TUseLoc'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	..Set TModel=$P($G(^DHCEQStoreMoveList(TSourceID)),"^",9)
	..If TModel'="" Set TModel=$Piece($Get(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	..s EquipDRs=+$Get(^DHCEQStoreMoveList(TSourceID,"EX","RowIDs"))
	..i EquipDRs>0 d
	...s OCLRowID=$Piece($Get(^DHCEQEquip(EquipDRs)),"^",77)
	...i OCLRowID'="" d
	....Set TLocation=$Piece($Get(^DHCEQOpenCheckList(OCLRowID)),"^",26)
	....If TLocation'="" Set TLocation=$Piece($Get(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	....Set TExpenditures=$Piece($Get(^DHCEQOpenCheckList(OCLRowID)),"^",59)
	....If TExpenditures'="" Set TExpenditures=$Piece($Get(^DHCEQCCode("DHCEQCExpenditures",TExpenditures)),"^",2)
	.Quit:flag=1
	.Set ^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID,TUseLoc,TEquipName,TSourceID)=TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TAmount_"^"_TExpenditures_"^"_TLocation_"^"_TPayFee_"^"_TEquipTypeDR
	.i TEquipTypeDR="" s ^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID,TUseLoc,TEquipName,TSourceID)=^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID,TUseLoc,TEquipName,TSourceID)_TAccessoryTypeDR
 	.s TAmount=TQuantityNum*TOriginalFee
 	.i TAmount'="" s TAmount=##class(web.DHCEQCommon).FormatNumber(TAmount,"")
 	.i TOriginalFee'="" s TAmount=##class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
 	.d OutputRowGetListNewPrint
 	.s Num=Num+1
 	Kill ^DHCEQTemp("web.DHCEQPayRequest",+$H,TempID)
 Set qHandle=$lb(0,repid,0)
 Quit $$$OK	 
OutputRowGetListNewPrint
 set Data=$lb(Num,TUseLoc,TModel,TEquipName,TUnit,TQuantityNum,TOriginalFee,TAmount,TExpenditures,TLocation) 
 set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod GetListNewPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetListNewPrintExecute ]
{
	 Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind=""
	 {
	  //if there are no more rows,finish fetching...
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

ClassMethod GetListNewPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetListNewPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 支付方式
/// d ##Class(web.DHCEQPayRequest).PayModeList("PayMode",135)
ClassMethod PayModeList(name, width, PayType As %Library.String = "") As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	;w "<option value=></option>"
	/*
	w "<option value=0>现金</option>"
	w "<option value=1>支票</option>"
	w "<option value=2>银行卡</option>"
	w "<option value=3>汇款</option>"
	*/
	//动态获取表记录Add By DJ 2017-02-07
	s PMRowID=0
	f  s PMRowID=$o(^DHCEQCCode("DHCEQCPayMode",PMRowID))  q:PMRowID=""  d
	.s PMInvalidFlag=$p($g(^DHCEQCCode("DHCEQCPayMode",PMRowID)),"^",4)
	.q:PMInvalidFlag="Y"
	.s PMDesc=$p($g(^DHCEQCCode("DHCEQCPayMode",PMRowID)),"^",2)
	.w "<option value="_PMRowID_">"_PMDesc_"</option>"
}

/// w ##Class(web.DHCEQPayRequest).GetPayMode("")
ClassMethod GetPayMode(PayMode)
{
	//Quit $CASE(PayMode,"0":"现金","1":"支票","2":"银行卡","3":"汇款","4":"",:"")
	i PayMode="" q ""
	q $p($g(^DHCEQCCode("DHCEQCPayMode",PayMode)),"^",2)
}

/// 付款用途
/// d ##Class(web.DHCEQPayRequest).PurposeTypeList("PurposeType",135)
ClassMethod PurposeTypeList(name, width, PurposeType As %Library.String = "") As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>配件购置费</option>"
	w "<option value=1>保养费</option>"
	w "<option value=2>医用气体款</option>"
	w "<option value=3>计量检测费</option>"
	w "<option value=4>环评费</option>"
}

/// w ##Class(web.DHCEQPayRequest).GetPurposeType("")
ClassMethod GetPurposeType(PurposeType)
{
	Quit $CASE(PurposeType,"0":"配件购置费","1":"保养费","2":"医用气体款","3":"计量检测费","4":"环评费","5":"",:"")
}

/// 返回转移单明细的首次出库的设备DR
/// w ##Class(web.DHCEQPayRequest).GetEquipList()
ClassMethod GetEquipList(SMLRowID As %Library.String = "")
{
	if SMLRowID="" q ""
	new EquipDRs,count,i,EquipDR,vLifeInfoDR,equiplist
	s EquipDRs=$Get(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
	Set equiplist=""
	Set count=$length(EquipDRs,",")
	For i=1:1:count Do
	.Set EquipDR=$Piece(EquipDRs,",",i)
	.If EquipDR'=""  Do
	..q:$Piece($Get(^DHCEQEquip(EquipDR)),"^",59)'="N"
	..s vLifeInfoDR=$o(^DHCEQLifeInfo(0,"EquipSource",22,EquipDR,SMLRowID,0))
	..q:##class(web.DHCEQStoreMoveList).CheckFirstMove(vLifeInfoDR,EquipDR)'=1	;判断该设备是否首次出库
	..i equiplist'="" s equiplist=equiplist_","
	..s equiplist=equiplist_EquipDR
	q equiplist
}

/// 查看设备是不是已经存在其他的转移单或退货减少单中，是，返回1；否则，返回0
/// w ##Class(web.DHCEQPayRequest).CheckEquipDR("","183","114",)
ClassMethod CheckEquipDR(MXRowID, EquipDR, FromLocDR, Type)
{
	new (MXRowID, EquipDR, FromLocDR,Type)
	i EquipDR="" q 0
	s EquipDR=","_EquipDR_","
	s Flag=0
	
	//检测来源科室新增，提交状态退货减少单据是否已经存在当前设备(不包括当前退货减少明细记录)
	s Status=""
	f  s Status=$o(^DHCEQReturn(0,"StatusReturnLoc",Status))  q:(Status="")||(Flag'=0)  d
	.q:(Status'=0)&&(Status'=1)
	.s rowid=0
	.f  s rowid=$o(^DHCEQReturn(0,"StatusReturnLoc",Status,FromLocDR,rowid)) q:(rowid="")||(Flag'=0)  d
	..s RInvalidFlag=$p($g(^DHCEQReturn(rowid)),"^",28)
	..q:RInvalidFlag="Y"
	..s mxrowid=0
	..f  s mxrowid=$o(^DHCEQReturnList(0,"Return",rowid,mxrowid)) q:(mxrowid="")||(Flag'=0)  d
	...q:(MXRowID'="")&&(MXRowID=mxrowid)&&(Type=2)
	...s RowIDs=$g(^DHCEQReturnList(mxrowid,"EX","RowIDs"))
	...i (","_RowIDs_",")[EquipDR s Flag=1
	q Flag
}

/// 无效付款申请相关明细(处置无效单据)
/// w ##Class(web.DHCEQPayRequest).InvalidSourceList("","183","114",)
ClassMethod InvalidSourceList(PayFromType As %String = "", SourceType As %String = "", SourceID As %String = "", PayPlanFlag As %String = "")
{
	i (PayFromType="")||(SourceType="")||(SourceID="") q 0
	
	if +PayFromType=1
	{
		if +SourceType=1
		{
			; "设备入库明细"
			s ^DHCEQInStockList(SourceID,"PayRequestInvalidFlag")=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))_","_$H
		}
		elseif +SourceType=12
		{
			; "转移明细(首次)"
			;s ^DHCEQStoreMoveList(SourceID,"PayRequestInvalidFlag")=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))_","_$H
			&SQL(Update SQLUSER.DHC_EQStoreMoveList Set SML_Hold2='Y' where SML_RowID=:SourceID)
		}
		elseif +SourceType=13
		{
			; "附件"
			
		}
		else
		{
			
		}
	}
	elseif +PayFromType=2
	{
		
	}
	elseif +PayFromType=3
	{
		if +SourceType=8
		{
			; ^DHCEQContractList	保修合同明细
			;s ^DHCEQContractList(SourceID,"PayRequestInvalidFlag")=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))_","_$H
			i PayPlanFlag=1 d
			.s ^DHCEQPayPlan(SourceID,"PayRequestInvalidFlag")=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))_","_$H
			e  d
			.s ^DHCEQContract(SourceID,"PayRequestInvalidFlag")=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))_","_$H
		}
		elseif +SourceType=11
		{
			; ^DHCEQAMoveStockList	配件出库明细
			s ^DHCEQAMoveStockList(SourceID,"PayRequestInvalidFlag")=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))_","_$H
		}
	}
	
	
	
	q SourceID
}

/// 创建:Mozy 2016-7-20
/// 设备付款通知单明细查询
/// Modified by csj 2020-02-19 标准版 添加业务类型及类组过滤，添加付款导出
/// d ##class(%ResultSet).RunQuery("web.DHCEQPayRequest","GetPayRequest","","0078453")
/// modified by sjh SJH0043 添加申请日期查询条件
Query GetPayRequestListDetail(PayRequestNo As %String = "", InvoiceNo As %String = "", LocDR As %String = "", Name As %String = "", ProviderDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N", PayFromType As %String = "", BussNo As %String = "", SourceType As %String = "", PayEquipTypeDR As %String = "", RequestStartDate As %String = "", RequestEndDate As %String = "") As %Query(ROWSPEC = "TJob:%String,TRowID:%String,TRow:%String,TPayRequestNo:%String,TMakeDate:%String,TLoc:%String,TProvider:%String,TBank:%String,TBankAccount:%String,TAccountDate:%String,TTotalFee:%String,TPurposeType:%String,TPayMode:%String,TAgent:%String,TStatus:%String,TRemark:%String,TPayFromType:%String,TSourceType:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TSourceNo:%String,TEquipName:%String,TUnit:%String,TEquipType:%String,TOriginalFee:%String,TQuantityNum:%String,type:%String,TInvoiceNo:%String,TStatusDR:%String")
{
}

ClassMethod GetPayRequestListDetailExecute(ByRef qHandle As %Binary, PayRequestNo As %String = "", InvoiceNo As %String = "", LocDR As %String = "", Name As %String = "", ProviderDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvalidFlag As %String = "N", PayFromType As %String = "", BussNo As %String = "", SourceType As %String = "", PayEquipTypeDR As %String = "", RequestStartDate As %String = "", RequestEndDate As %String = "") As %Status
{
 	new repid, index, rowid, flag, id, no, TJob, PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=1
 	Set TRow=1
 	Set TJob=$Job
 	;Kill ^DHCEQTemp("GetPayRequestListDetail",TJob)
	Do ##Class(web.DHCEQCommon).KillTempGlobal("GetPayRequestListDetail")	//Modified by csj 2020-02-19
 	i LocDR="" Set LocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
 	Set PNum=1
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
	
	If RequestStartDate="" Set RequestStartDate=0
	If RequestEndDate="" Set RequestEndDate=+$h
	s RequestStartDate=##Class(web.DHCEQCommon).TransValueFromPage(RequestStartDate,"date")
	s RequestEndDate=##Class(web.DHCEQCommon).TransValueFromPage(RequestEndDate,"date")
	
	Set TotalFee=0
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQPayRequest(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesListDetail
	.s TInvalidFlag=$p($g(^DHCEQPayRequest(rowid)),"^",26)
	.q:TInvalidFlag="Y"
	.s TStatus=$p($g(^DHCEQPayRequest(rowid)),"^",12)
	.q:TStatus'=2
	.s TPayRequestNo=$p($g(^DHCEQPayRequest(rowid)),"^",1)
	.q:(PayRequestNo'="")&&(TPayRequestNo'=PayRequestNo)
	.s TMakeDate=$p($g(^DHCEQPayRequest(rowid)),"^",2)
	.q:(RequestStartDate'="")&&(TMakeDate<RequestStartDate)
	.q:(RequestEndDate'="")&&(TMakeDate>RequestEndDate)
	.i TMakeDate'="" s TMakeDate=##Class(web.DHCEQCommon).TransValueToPage(TMakeDate,"date")
	.s TLoc=$p($g(^DHCEQPayRequest(rowid)),"^",3)
	.q:(LocDR'="")&&(TLoc'=LocDR)
	.i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
	.s TProvider=$p($g(^DHCEQPayRequest(rowid)),"^",4)
	.q:(ProviderDR'="")&&(TProvider'=ProviderDR)
	.i TProvider'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	.s TBank=$p($g(^DHCEQPayRequest(rowid)),"^",5)
	.s TBankAccount=$p($g(^DHCEQPayRequest(rowid)),"^",6)
	.s TAccountDate=$p($g(^DHCEQPayRequest(rowid)),"^",7)
	.q:(StartDate'="")&&(TAccountDate<StartDate) //modified by sjh SJH0042 2020-12-15 修改日期过滤为付款日期
	.q:(EndDate'="")&&(TAccountDate>EndDate) //modified by sjh SJH0042 2020-12-15 修改日期过滤为付款日期
	.i TAccountDate'="" s TAccountDate=##Class(web.DHCEQCommon).TransValueToPage(TAccountDate,"date")
	.s TTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQPayRequest(rowid)),"^",8))
	.s TPayMode=$p($g(^DHCEQPayRequest(rowid)),"^",10)
	.i TPayMode'="" s TPayMode=$Case(TPayMode,"1":"现金","2":"支票","3":"汇款",:"未定义")
	.s TAgent=$p($g(^DHCEQPayRequest(rowid)),"^",11)
	.s TRemark=$p($g(^DHCEQPayRequest(rowid)),"^",13)
	.s TPayFromType=$p($g(^DHCEQPayRequest(rowid)),"^",27)
	.s TPayFromType=$Case(TPayFromType,"1":"新购设备","2":"维保合同","3":"配件","4":"调账付款","5":"维护费用","9":"其他费用")
	.s TSourceType=$p($g(^DHCEQPayRequest(rowid)),"^",28)
	.q:(SourceType'="")&&(SourceType'=TSourceType)	//add by CZF0059 2020-02-20
	.s TSourceType=##Class(web.DHCEQPayRequest).GetSourceType(TSourceType)
	.s TRowID=rowid
	.s TStatus=##class(web.DHCEQPayRequest).GetStatus(TStatus)
	.s PRecordID=0
	.f  s PRecordID=$o(^DHCEQPayRecord(0,"PayRequest",TRowID,PRecordID))  q:PRecordID=""  d
	..s PRecordInvalidFlag=$p($g(^DHCEQPayRecord(PRecordID)),"^",14)
	..q:PRecordInvalidFlag="Y"
	..s TSourceNo=$p($g(^DHCEQPayRecord(PRecordID)),"^",15)
	..q:(BussNo'="")&&(BussNo'=TSourceNo)		//add by CZF0058 2020-02-20
	..s TQuantityNum=$p($g(^DHCEQPayRecord(PRecordID)),"^",7)
	..s TEquipName=$p($g(^DHCEQPayRecord(PRecordID)),"^",6)
	..q:(Name'="")&&(TEquipName'[Name)
	..s TOriginalFee=$p($g(^DHCEQPayRecord(PRecordID)),"^",8)
	..s TEquipType=$p($g(^DHCEQPayRecord(PRecordID)),"^",4)
	..q:(PayEquipTypeDR'="")&&(TEquipType'=PayEquipTypeDR)	//add by csj 2020-02-19
	..i TEquipType'="" s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipType)
	..d OutputRowListDetail
	
	Quit $$$OK
	
	/*
 	new repid, index, rowid, flag, id, no, TJob, PNum, tmpAccountDate
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	Set index=2
 	Set TRow=1
 	Set TJob=$Job
 	Kill ^DHCEQTemp("PayRequestAccountDate",TJob)		;Mozy	643330	2018-11-30
 	Do ##Class(web.DHCEQCommon).KillTempGlobal("GetPayRequestListDetail")
 	;i LocDR="" Set LocDR=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))	Mozy	587905	2018-11-28
 	Set PNum=1
	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$h
	Set TotalFee=0
	Set TotalNum=0
	;s ^DHCEQMozy("GetPayRequestListDetail")=PayRequestNo_","_InvoiceNo_","_LocDR_","_Name_","_ProviderDR_","_StartDate_","_EndDate_","_InvalidFlag_","_PayFromType
	
	;Mozy	643330	2018-11-30	建立付款日期索引
	Set rowid=0 
	For  Set rowid=$Order(^DHCEQPayRecord(rowid)) Quit:rowid=""  Do
	.s TRowID = $P($G(^DHCEQPayRecord(rowid)),"^",10)
	.q:TRowID=""
	.Set tmpAccountDate = +$Piece($Get(^DHCEQPayRequest(TRowID)),"^",7)
	.Set ^DHCEQTemp("PayRequestAccountDate",TJob,tmpAccountDate,0,rowid)=""
	
	Set tmpAccountDate=""
	For  Set tmpAccountDate=$Order(^DHCEQTemp("PayRequestAccountDate",TJob,tmpAccountDate)) Quit:tmpAccountDate=""  Do
	.Set tmp=""
	.For  Set tmp=$Order(^DHCEQTemp("PayRequestAccountDate",TJob,tmpAccountDate,tmp)) Quit:tmp=""  Do
	..Set rowid=0 
	..For  Set rowid=$Order(^DHCEQTemp("PayRequestAccountDate",TJob,tmpAccountDate,tmp,rowid)) Quit:rowid=""  Do
	...Do ResetVariablesListDetail
	...s flag=0
	...s DataList =$G(^DHCEQPayRecord(rowid))
	...;Mozy	643330	2018-11-30
	...Set TRowID = $P(DataList,"^",10)
	...Set TSourceType=$Piece(DataList,"^",15)
	...Set TSourceID=$P(DataList,"^",16)
	...Set TPayPlanDR = $P(DataList,"^",17)	;Mozy0203	20180224
	...Set TInvalidFlag = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",26)
	...Quit:TInvalidFlag="Y"
	...Set TPayRequestNo = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",1)
	...Quit:(PayRequestNo'="")&(TPayRequestNo'=PayRequestNo)         //add by czf 2016-10-20 需求号：273671
	...Set TMakeDate = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",2)
	...Quit:(TMakeDate>EndDate)||(TMakeDate<StartDate)
	...Set TMakeDate = ##class(web.DHCEQCommon).TransValueToPage(TMakeDate,"date")
	...Set TLocDR = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",3)
	...Quit:(LocDR'="")&(TLocDR'=LocDR)
	...If TLocDR'="" Set TLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TLocDR)
	...Set TProviderDR = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",4)
	...Quit:(ProviderDR'="")&(TProviderDR'=ProviderDR)
	...If TProviderDR '="" Set TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	...Set TBank = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",5)
	...Set TBankAccount = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",6)
	...Set TAccountDate = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",7)
	...Set TAccountDate = ##class(web.DHCEQCommon).TransValueToPage(TAccountDate,"date")
	...Set TTotalFee = $P(DataList,"^",3)	;$Piece($Get(^DHCEQPayRequest(TRowID)),"^",8)
	...If TTotalFee'="" Set TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
	...Set TPurposeType = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",9)
	...Set TPurposeType = ##Class(web.DHCEQPayRequest).GetPurposeType(TPurposeType)
	...Set TPayMode = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",10)
	...Set TPayMode = ##Class(web.DHCEQPayRequest).GetPayMode(TPayMode)
	...Set TAgent = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",11)	;经办人
	...Set TStatusDR = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",12)
	...q:TStatusDR=3
	...Set TStatus=##class(web.DHCEQPayRequest).GetStatus(TStatusDR)
	...Set TRemark = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",13)
	...Set TPayFromType = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",27)
	...Quit:(PayFromType'="")&&(PayFromType'=TPayFromType)
	...Set THold1 = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",29)
	...Set THold2 = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",30)
	...Set THold3 = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",31)
	...Set THold4 = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",32)
	...Set THold5 = $Piece($Get(^DHCEQPayRequest(TRowID)),"^",33)
	...;Set TotalFee=TotalFee+TTotalFee	;Mozy	588043	2018-11-28
	...
	...;来源类型是入库明细
	...i TSourceType=1 Do
	....Set ISRowID=$P($G(^DHCEQInStockList(TSourceID)),"^",1)
	....s TEquipTypeDR=$P($G(^DHCEQInStock(ISRowID)),"^",20)
	....s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	....s TSourceNo=$p(^DHCEQInStock(ISRowID),"^",14)
	....s TEquipName=$P($G(^DHCEQInStockList(TSourceID)),"^",5)
	....s TUnitDR=$p($g(^DHCEQInStockList(TSourceID)),"^",10) //单位
	....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	....s TOriginalFee=+$P($G(^DHCEQInStockList(TSourceID)),"^",7)
	....s TQuantityNum=$P($G(^DHCEQInStockList(TSourceID)),"^",8)
	....s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",TSourceID,"","","")
	....i $p(TInvoiceInfo,"^",1) s TInvoiceNo=$p(TInvoiceInfo,"^",4)
	...q:flag'=0
	...
	...;来源类型是保修合同	Mozy0203	20180224
	...i TSourceType=8 Do
	....i TPayPlanDR'="" d
	.....i $Piece($Get(^DHCEQPayPlan(TSourceID)),"^",2)=1 d
	......;按保修合同制定的付款计划取值	^DHCEQPayPlan	付款计划
	......s SID=$Piece($Get(^DHCEQPayPlan(TSourceID)),"^",3)
	......Set TProviderDR=$Piece($Get(^DHCEQContract(SID)),"^",18)
	......Set TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商
	......s ContractListDR=""
	......f  s ContractListDR=$o(^DHCEQContractList(0,"Contract",SID,ContractListDR)) quit:(ContractListDR="")||(flag'=0)  d
	.......;;;Mozy	2018-3-19	567237	修正保修合同明细的类组取值
	.......s ContractListSType = $p($g(^DHCEQContractList(ContractListDR)),"^",5)	;1:计划 2:招标 3:设备项 4:设备 5:入库明细
	.......s ContractListSID = $p($g(^DHCEQContractList(ContractListDR)),"^",17)
	.......i ContractListSType=1 d
	........Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(ContractListSID)),"^",1))),"^",12)
	.......else  if ContractListSType=2 d
	........Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(ContractListSID)),"^",3)	//Mozy	567216	201-3-26	增加类组取值
	........Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
	.......else  if ContractListSType=3 d
	........Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",ContractListSID)),"^",3)
	.......else  if ContractListSType=4 d
	........Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",63)
	.......else  if ContractListSType=5 d
	........Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(ContractListSID)),"^",1))),"^",20)
	.......s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	......Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", +TEquipTypeDR)
	......s TEquipName=$p($g(^DHCEQPayPlan(TSourceID)),"^",1)
	......s TOriginalFee=$p($g(^DHCEQPayPlan(TSourceID)),"^",10)	;PP_PayAmount
	......Set TSourceNo=$p($g(^DHCEQContract(SID)),"^",2)
	......Set TEquipName=$p($g(^DHCEQContract(SID)),"^",1)_"("_TEquipName
	......Set TEquipName=TEquipName_"计划支付日期:"_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayPlan(TSourceID)),"^",6),"date")_")"
	......If TOriginalFee="" Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(SID)),"^",4),0)*0.01*$p($g(^DHCEQPayPlan(TSourceID)),"^",9)
	......;s TDate=$p($g(^DHCEQPayPlan(TSourceID)),"^",6)
	......;i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	......s TUseLocDR=$p($g(^DHCEQContract(SID)),"^",8)
	......s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUseLocDR)	;合同签订部门
	....e  d
	.....s CTLRowID=0
	.....f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",TSourceID,CTLRowID)) q:(CTLRowID="")||(flag'=0)  d
	......s CTLST=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",5)	;;1:计划 2:招标 3:设备项 4:设备 5:入库明细
	......s CTLSI=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",17)
	......;;;Mozy	2018-3-26	567216	修正保修合同明细的类组取值
	......s TEquipTypeDR=""
	......i CTLST=1 d
	.......Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(CTLSI)),"^",1))),"^",12)
	......else  if CTLST=2 d
	.......Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(CTLSI)),"^",3)
	.......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
	......else  if CTLST=3 d
	.......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",CTLSI)),"^",3)
	......else  if CTLST=4 d
	.......Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(CTLSI)),"^",63)
	......else  if CTLST=5 d
	.......Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(CTLSI)),"^",1))),"^",20)
	......s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	......s flag=##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR)
	.....
	.....s TEquipName = $Piece($Get(^DHCEQContract(TSourceID)),"^",1)
	.....s TSourceNo=$Piece($Get(^DHCEQContract(TSourceID)),"^",2)
	.....s TOriginalFee=$Piece($Get(^DHCEQContract(TSourceID)),"^",5)	;买保金额
	.....s TUseLocDR=$p($g(^DHCEQContract(TSourceID)),"^",8)  			;合同签订部门
	.....s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.....s TProviderDR = $Piece($Get(^DHCEQContract(TSourceID)),"^",18)
	.....s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	...q:flag'=0
	...
	...;来源类型是配件转移明细
	...i TSourceType=11 Do
	....s AMSRowID=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",1)
	....s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)
	....s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType",TAccessoryTypeDR)
	....s flag=##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
	....s TSourceNo=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",1)
	....s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",15)	;入库明细AISL_InStockListDR
	....s AISRowID=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",1)
	....s TEquipName = $p($g(^DHCEQAMoveStockList(TSourceID)),"^",4)
	....s TUnitDR=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",6)
	....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	....s TOriginalFee=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",10)
	....s TQuantityNum=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",11)
	....i AMSLAISListDR'="" s TInvoiceNo=$p($g(^DHCEQAInStockList(AMSLAISListDR)),"^",19)
	...q:flag'=0
	...
	...;来源类型是转移明细(首次)
	...i TSourceType=12 Do
	....s SMRowID=$Piece($Get(^DHCEQStoreMoveList(TSourceID)),"^",1)
	....s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)		;SMEquipTypeDR
	....s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipTypeDR)
	....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	....s TSourceNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
	....s TEquipName = $p($g(^DHCEQStoreMoveList(TSourceID)),"^",5)
	....s TUnitDR=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",10)
	....i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	....s TOriginalFee=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",7)
	....s TQuantityNum=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",8)
	....i $p($g(^DHCEQStoreMoveList(TSourceID)),"^",3)="Y" d	;SML_BatchFlag
	.....s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",$p($g(^DHCEQStoreMoveList(TSourceID)),"^",4),"","","")
    .....i $p(TInvoiceInfo,"^",1) s TInvoiceNo=$p(TInvoiceInfo,"^",4)
	...q:flag'=0
	...q:(InvoiceNo'="")&&(TInvoiceNo'[InvoiceNo)
	...q:(Name'="")&&(TEquipName'[Name)
	...;Mozy	588043	2018-11-28
	...Set TotalFee=TotalFee+TTotalFee
	...Set TotalNum=TotalNum+TQuantityNum
	...d OutputRowListDetail
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0
		d ResetVariablesListDetail
		Set TRow="合计:"
		Set TTotalFee=TotalFee
		Set TQuantityNum=TotalNum
		Set TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",2)
		Set Data=$lb(TJob,TRowID,TRow,TPayRequestNo,TMakeDate,TLoc,TProvider,TBank,TBankAccount,TAccountDate,TTotalFee,TPurposeType,TPayMode,TAgent,TStatus,TRemark,TPayFromType,TSourceType,THold1,THold2,THold3,THold4,THold5,TSourceNo,TEquipName,TUnit,TEquipType,TOriginalFee,TQuantityNum,type,TInvoiceNo,TStatusDR)
		Set ^CacheTemp(repid,index)=Data
		;Set ^DHCEQTemp("GetPayRequest",TJob,PNum)=TRowID_"^"_TPayRequestNo_"^"_TAccountDate_"^"_TLoc_"^"_TProvider_"^"_TTotalFee_"^"_TStatus_"^"_TRemark_"^"_TPayFromType_"^"_TSourceType_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5
	}
	Kill ^DHCEQTemp("PayRequestAccountDate",TJob)		;Mozy	643330	2018-11-30
	Quit $$$OK
	*/
OutputRowListDetail
	//Set type=##Class(web.DHCEQPayRequest).GetSourceType(TSourceType)
	Set Data=$lb(TJob,TRowID,TRow,TPayRequestNo,TMakeDate,TLoc,TProvider,TBank,TBankAccount,TAccountDate,TTotalFee,TPurposeType,TPayMode,TAgent,TStatus,TRemark,TPayFromType,TSourceType,THold1,THold2,THold3,THold4,THold5,TSourceNo,TEquipName,TUnit,TEquipType,TOriginalFee,TQuantityNum,type,TInvoiceNo,TStatusDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set TRow=TRow+1
	Set ^DHCEQTemp("GetPayRequestListDetail",+$H,TJob,PNum)=TRowID_"^"_TPayRequestNo_"^"_TAccountDate_"^"_TLoc_"^"_TProvider_"^"_TTotalFee_"^"_TStatus_"^"_TRemark_"^"_TPayFromType_"^"_type_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TEquipName_"^"_TEquipType_"^"_TNo_"^"_TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TQuantityFee_"^"_TInvoiceNo_"^"_TOpenCheckDate
	Set PNum=PNum+1
	
	Quit
ResetVariablesListDetail
	Set (TRowID,TPayRequestNo,TMakeDate,TLoc,TProvider,TBank,TBankAccount,TAccountDate,TTotalFee,TPurposeType,TPayMode,TAgent,TStatus,TRemark,TPayFromType,THold1,THold2,THold3,THold4,THold5,TSourceNo,TEquipName,TUnit,TEquipType,TOriginalFee,TQuantityNum,type,TInvoiceNo,TStatusDR,TNo,TModel,TModelDR,TQuantityFee,TQuantityFee,TOpenCheckDate)=""
	Quit
}

ClassMethod GetPayRequestListDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPayRequestListDetailExecute ]
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

ClassMethod GetPayRequestListDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPayRequestListDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 描述:部分付、未付付款通知单业务明细查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQPayRequest","GetUnPayList","","12",1,"","","","Y")
Query GetUnPayList(RowID As %String = "", SourceType As %String = "", PayFromType As %String = "", ProviderDR As %String = "", Hold4 As %String = "", RetentionFlag As %String = "", WarnFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TRow:%String,TSourceType:%String,TSourceID:%String,TSourceNo:%String,TDate:%String,TEquipName:%String,TOriginalFee:%String,TQuantityNum:%String,TTotalFee:%String,TPaedFee:%String,TNeedPayFee:%String,TAmountFee:%String,TRemark:%String,TReduceQtyNum:%String,TFlag:%String,TInvoiceNo:%String,TInvoiceDate:%String,TLoc:%String,TAMSLHold3:%String,TListInfo:%String,TEquipType:%String,TProviderDR:%String,TGuaranteeDate:%String,TGuaranteeFee:%String,TRate:%String,TOpenCheckDate:%String,TProvider:%String,TJob:%String,TOpenCheckAuditDate:%String,TOpenCheckOrigin:%String,TOpenCheckRemark:%String,TUseLoc:%String")
{
}

ClassMethod GetUnPayListExecute(ByRef qHandle As %Binary, RowID As %String = "", SourceType As %String = "", PayFromType As %String = "", ProviderDR As %String = "", Hold4 As %String = "", RetentionFlag As %String = "", WarnFlag As %String = "") As %Status
{
 	new repid, index, TotalQty, Total, TotalFlag, SourceInfo
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set (TotalQty,Total)=0
	;s ^DHCEQMozy("GetUnPayList")=RowID_","_SourceType_","_PayFromType_","_ProviderDR
	Set index=1
	Set TJob=$Job
 	Do ##Class(web.DHCEQCommon).KillTempGlobal("UnPayRequestList")

	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	If TotalFlag="1" Set index=2
	//20150929 ZY0145付款申请单错误修改,查找不保存信息;
	//最终审核的时候保存付款记录的信息
	s Status=""
	Set TRow=0
	if RowID'=""
	{
		s Status=$Piece($Get(^DHCEQPayRequest(RowID)),"^",12)
		s PayFromType=$Piece($Get(^DHCEQPayRequest(RowID)),"^",27)
		s StoreLocDR=$Piece($Get(^DHCEQPayRequest(RowID)),"^",3)
		s ProviderDR=$Piece($Get(^DHCEQPayRequest(RowID)),"^",4)
	}
	;i ProviderDR="" Quit $$$OK
	if +Status<2
	{
		if PayFromType=1
		{
			if SourceType=12
			{
				; "转移明细(首次)"
				k ^DHCEQTEMP("GetUnPayList")
				s SMRowID=0
				f  s SMRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID)) q:SMRowID=""  d
				.s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)		;SMEquipTypeDR
				.;q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
				.q:(%session.Get("LOGON.GROUPID")="83")&&((TEquipTypeDR="11")||(TEquipTypeDR="14"))
				.set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
				.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",27)'="N"	;SMInvalidFlag
				.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",13)'=2	;SMStatus
				.q:$p($g(^DHCEQStoreMove(SMRowID)),"^",12)'=0	;SMMoveType
				.s SMLRowID=0
				.f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",SMRowID,SMLRowID)) q:SMLRowID=""  d
				..d ResetVariablesGetUnPayList
				..;q:$get(^DHCEQStoreMoveList(SMLRowID,"PayRequestInvalidFlag"))
				..q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",14)="Y"		;SMLHold2
				..q:$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",15)'=""		;SMLHold3	过滤附属设备	;Mozy	587884	2018-11-28
				..s EquipDRs=$Get(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
				..q:EquipDRs=""
				..i $p($g(^DHCEQStoreMoveList(SMLRowID)),"^",3)="Y" d
				...;批量
				...s isldr=$p($g(^DHCEQEquip($p(EquipDRs,",",1))),"^",70)
				...s isdr=$p($g(^DHCEQInStockList(isldr)),"^",1)
				...s TProviderDR=$p($g(^DHCEQInStock(isdr)),"^",17)
				..e  d
				...;单台
				...s isldr=$p($g(^DHCEQEquip(EquipDRs)),"^",70)
				...i isldr="" d	
				....s TProviderDR=$p($g(^DHCEQEquip(EquipDRs)),"^",25)	;provderDR
				...e  d
				....s isdr=$p($g(^DHCEQInStockList(isldr)),"^",1)
				....s TProviderDR=$p($g(^DHCEQInStock(isdr)),"^",17)
				..q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
				..i TProviderDR'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商	add by csj 2020-03-23
				..;返回转移单明细的首次出库的设备DR
				..s equiplist=##Class(web.DHCEQPayRequest).GetEquipList(SMLRowID)
				..q:equiplist=""
				..
				..;
				..s TSourceType="12"	;12:"转移明细(首次)"
				..s TSourceID=SMLRowID
				..s TSourceNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
				..
				..s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)     ;add by kdf 2017-11-14 需求号：468398
				..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR) ;add by kdf 2017-11-14 需求号：468398
				..i $p($g(^DHCEQStoreMoveList(SMLRowID)),"^",3)="Y" d
				...;批量
				...s isldr=$p($g(^DHCEQEquip($p(equiplist,",",1))),"^",70)
				...s TOpenCheckDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip($p(equiplist,",",1))),"^",12),"date")	//add by csj 20200111 验收日期
				...s TEquipName=$p($g(^DHCEQInStockList(isldr)),"^",5)
				...s TOriginalFee=$p($g(^DHCEQInStockList(isldr)),"^",7)
				...s TUnitDR=$p($g(^DHCEQInStockList(isldr)),"^",10)
				..e  d
				...;单台
				...s isldr=$p($g(^DHCEQEquip(equiplist)),"^",70)
				...s TOpenCheckDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(equiplist)),"^",12),"date")	//add by csj 20200111 验收日期
				...i isldr="" d	
				....s TEquipName=$p($g(^DHCEQEquip(equiplist)),"^",1)
				....s TUnitDR=$p($g(^DHCEQEquip(equiplist)),"^",5)
				....s TOriginalFee=$p($g(^DHCEQEquip(equiplist)),"^",27)
				...e  d
				....s TEquipName=$p($g(^DHCEQInStockList(isldr)),"^",5)
				....s TOriginalFee=$p($g(^DHCEQInStockList(isldr)),"^",7)
				....s TUnitDR=$p($g(^DHCEQInStockList(isldr)),"^",10)
				..i isldr'="" d
				...s (TCurOpenCheckListDR,TCurOpenCheckDR,TOpenCheckOriginDR)=""
				...s TCurOpenCheckListDR=$p($g(^DHCEQInStockList(isldr)),"^",19)
				...i TCurOpenCheckListDR'="" d
				....s TCurOpenCheckDR=$p($g(^DHCEQOpenCheckList(TCurOpenCheckListDR)),"^",1)
				....s TUseLoc=$p($g(^DHCEQOpenCheckList(TCurOpenCheckListDR)),"^",33)
				....s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
				...i TCurOpenCheckDR'="" d
				....s TOpenCheckAuditDate=$p($g(^DHCEQOpenCheckRequest(TCurOpenCheckDR)),"^",26)
				....s TOpenCheckOriginDR=$p($g(^DHCEQOpenCheckRequest(TCurOpenCheckDR)),"^",8)
				....i TOpenCheckOriginDR'="" s TOpenCheckOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOpenCheckOriginDR)),"^",2)
				....s TOpenCheckRemark=$p($g(^DHCEQOpenCheckRequest(TCurOpenCheckDR)),"^",21)
				..s TModelDR=$p($g(^DHCEQStoreMoveList(SMLRowID)),"^",9)
				..i TModelDR'="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
				..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
				..s TDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
				..i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
				..s TQuantityNum=$length(equiplist,",")
				..
				..s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(12,SMLRowID,"","","","")
				..s TGuaranteeDate=$p(PayInfo,"^",6)
				..;w TGuaranteeDate ,! 
				..q:$p(PayInfo,"^",2)>=(TQuantityNum*TOriginalFee)
				..q:(RetentionFlag'="")&&(TQuantityNum*TOriginalFee-$p(PayInfo,"^",2)'=0)	//add by csj 2020-3-24 质保金
				..q:(WarnFlag'="")&&(TGuaranteeDate'="")&&(TGuaranteeDate-(+$h)<30)	//add by csj 2020-03-19 质保预警标志
				..s TTotalFee=TQuantityNum*TOriginalFee
				..s TPaedFee=$p(PayInfo,"^",2)
				..s TNeedPayFee=TTotalFee-TPaedFee
				..s TAddFlag=0
				..i isldr'="" d
				...s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",isldr,"","","")
				...s TInvoiceNo=$p(TInvoiceInfo,"^",4)
				..;q:(isldr'="")&&($p(TInvoiceInfo,"^",1)=0)	//add by csj 20200107 不显示未审核发票单据
				..q:TInvoiceNo=""	//add  by csj 2020-05-07 哈医大需求 过滤没有发票号的(不用付款)
				..s TLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
				..i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
				..
				..i (RowID'="")&&$Data(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))>0  d
				...s PayRequestInfo=$g(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))
				...s TAmountFee=$p(PayRequestInfo,"^",1)
				...s TGuaranteeFee=$p(PayRequestInfo,"^",2)
				...s TGuaranteeDate=$p(PayRequestInfo,"^",3)
				...
				...s TRate=$p(PayRequestInfo,"^",4)
				...
				...s TFlag="Y"
				...s TAddFlag=1
				..s TGuaranteeDate=##Class(web.DHCEQCommon).Trim(TGuaranteeDate)
				..i TGuaranteeDate="" d
				...s TGuaranteeInfo=##Class(web.DHCEQPayRequest).CheckGuaranteeDate(TSourceType,TSourceID)
				...i $p(TGuaranteeInfo,"^",1)=1 s TGuaranteeFee=$p(TGuaranteeInfo,"^",3)
				...s TGuaranteeDate=$p(TGuaranteeInfo,"^",2)
				...i TGuaranteeDate'="" d
				....s TGuaranteeDate=$ZD($p(TGuaranteeInfo,"^",2),3)
				..q:(RowID'="")&&(TAddFlag=0)
				..q:((+Status=1)&&(TFlag'="Y"))
				..s TListInfo=equiplist
				..s TOpenCheckDate=$zdh(TOpenCheckDate,"3")
				..s ^DHCEQTEMP("GetUnPayList",TOpenCheckDate,TSourceID)=TRowID_"^"_TRow_"^"_TSourceType_"^"_TSourceID_"^"_TSourceNo_"^"_TDate_"^"_TEquipName_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TTotalFee_"^"_TPaedFee_"^"_TNeedPayFee_"^"_TAmountFee_"^"_TRemark_"^"_TReduceQtyNum_"^"_TFlag_"^"_TInvoiceNo_"^"_TInvoiceDate_"^"_TLoc_"^"_TAMSLHold3_"^"_TListInfo_"^"_TEquipType_"^"_TProvider_"^"_TGuaranteeDate_"^"_TGuaranteeFee_"^"_TRate_"^"_TOpenCheckDate_"^"_TOpenCheckAuditDate_"^"_TOpenCheckOrigin_"^"_TOpenCheckRemark
				..;s TOpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date")
				..;Do OutputRowGetUnPayList
				//add by csj 20200113 根据验收日期排序
				s OpenCheckDate=""
				f  s OpenCheckDate=$o(^DHCEQTEMP("GetUnPayList",OpenCheckDate))  q:OpenCheckDate=""  d
				.s SourceID=0
				.f  s SourceID=$o(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID))  q:SourceID=""  d
				..d ResetVariablesGetUnPayList
				..s TRowID=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",1)
				..s TRow=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",2)
				..s TSourceType=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",3)
				..s TSourceID=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",4)
				..s TSourceNo=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",5)
				..s TDate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",6)
				..s TEquipName=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",7)
				..s TOriginalFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",8)
				..s TQuantityNum=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",9)
				..s TTotalFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",10)
				..s TPaedFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",11)
				..s TNeedPayFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",12)
				..s TAmountFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",13)
				..s TRemark=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",14)
				..s TReduceQtyNum=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",15)
				..s TFlag=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",16)
				..s TInvoiceNo=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",17)
				..s TInvoiceDate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",18)
				..s TLoc=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",19)
				..s TAMSLHold3=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",20)
				..s TListInfo=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",21)
				..s TEquipType=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",22)
				..s TProvider=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",23)
				..s TGuaranteeDate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",24)
				..s TGuaranteeFee=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",25)
				..s TRate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",26)
				..s TOpenCheckDate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",27)
				..s TOpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckDate,"date")
				..s TOpenCheckAuditDate=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",28)
				..s TOpenCheckAuditDate=##Class(web.DHCEQCommon).TransValueToPage(TOpenCheckAuditDate,"date")
				..s TOpenCheckOrigin=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",29)
				..s TOpenCheckRemark=$p(^DHCEQTEMP("GetUnPayList",OpenCheckDate,SourceID),"^",30)
				..d OutputRowGetUnPayList
			}
			elseif SourceType=11
			{
				// ^DHCEQAMoveStockList	配件出库明细
				s AMSLRowID=0
				f  s AMSLRowID=$o(^DHCEQAMoveStockList(AMSLRowID)) q:AMSLRowID=""  d
				.d ResetVariablesGetUnPayList
				.q:$get(^DHCEQAMoveStockList(AMSLRowID,"PayRequestInvalidFlag"))
				.s AMSRowID=$Piece($Get(^DHCEQAMoveStockList(AMSLRowID)),"^",1)
				.s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)
				.q:##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
				.set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
				.s TAMSMoveType=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",14)
				.q:TAMSMoveType'=0
				.s TAMSStatus=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",28)
				.q:TAMSStatus'=2
				.s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(AMSLRowID)),"^",15)	;入库明细AISL_InStockListDR
				.Quit:AMSLAISListDR=""
				.s AISRowID=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",1)
				.q:AISRowID=""         //add by mwz 20180313 需求号：551254
				.s TProviderDR=$Piece($Get(^DHCEQAInStock(AISRowID)),"^",8)
				.q:(ProviderDR'="")&&(ProviderDR'=TProviderDR)
				.i TProviderDR'="" s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商	add by csj 2020-03-23
				.s TSourceType="11"	;11:配件出库明细
				.s TSourceID=AMSLRowID
				.s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)    ;add by kdf 2017-11-15 需求号：468398
				.i TAccessoryTypeDR'="" s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR) ;add by kdf 2017-11-15 需求号：468398
				.s TSourceNo=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",1)
				.s TEquipName = $p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",4)
				.s TModel=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",5)
				.s TUnitDR=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",6)
				.i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
				.s TDate=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",7)
				.i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
				.s TOriginalFee=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",10)
				.s TQuantityNum=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",11)
				.
				.s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(11,AMSLRowID,"","","","")
				.s TGuaranteeDate=$p(PayInfo,"^",6)
				.q:$p(PayInfo,"^",2)>=(TQuantityNum*TOriginalFee)
				.q:(RetentionFlag'="")&&(TQuantityNum*TOriginalFee-$p(PayInfo,"^",2)'=0)	//add by csj 2020-3-24 质保金
				.q:(WarnFlag'="")&&(TGuaranteeDate'="")&&(TGuaranteeDate-(+$h)<30)	//add by csj 2020-03-19 质保预警标志
				.s TTotalFee=TQuantityNum*TOriginalFee
				.s TPaedFee=$p(PayInfo,"^",2)
				.s TNeedPayFee=TTotalFee-TPaedFee
				.s TAddFlag=0
				.
				.s TInvoiceNo=$p($g(^DHCEQAInStockList(AMSLAISListDR)),"^",19)	;Mozy	587950	2018-11-28
				.s TLoc=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",5)
				.i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
				.s TAMSLHold3=$p($g(^DHCEQAMoveStockList(AMSLRowID)),"^",20)	;呈批件号	Mozy	588024	2018-11-28
				.
				.i (RowID'="")&&$Data(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))>0  d
				..s PayRequestInfo=$g(^DHCEQPayRequest(RowID,"EX",TSourceType,TSourceID))
				..s TAmountFee=$p(PayRequestInfo,"^",1)
				..s TGuaranteeFee=$p(PayRequestInfo,"^",2)
				..s TGuaranteeDate=$p(PayRequestInfo,"^",3)
				..s TRate=$p(PayRequestInfo,"^",4)
				..s TFlag="Y"
				..s TAddFlag=1
				..s TGuaranteeDate=##Class(web.DHCEQCommon).Trim(TGuaranteeDate)
				.i TGuaranteeDate="" d
				..s TGuaranteeInfo=##Class(web.DHCEQPayRequest).CheckGuaranteeDate(TSourceType,TSourceID)
				..i $p(TGuaranteeInfo,"^",1)=1 s TGuaranteeFee=$p(TGuaranteeInfo,"^",3)
				..s TGuaranteeDate=$p(TGuaranteeInfo,"^",2)
				..i TGuaranteeDate'="" d
				...s TGuaranteeDate=$ZD($p(TGuaranteeInfo,"^",2),4)
				..s TFlag="Y"
				.q:((+Status=1)&&(TFlag'="Y"))
				.Do OutputRowGetUnPayList
			}
			else
			{
				
			}
		}
		elseif PayFromType=2
		{
			
		}
		elseif PayFromType=3
		{
			
		}
	}
	else
	{
		Set rowid=0 
		For  Set rowid=$Order(^DHCEQPayRecord(0,"PayRequest",RowID,rowid)) Quit:rowid=""  Do
		.Do ResetVariablesGetUnPayList
		.s flag=0
		.s DataList =$G(^DHCEQPayRecord(rowid))
		.s TRowID = rowid
		.s TAmountFee=+$P(DataList,"^",3)
		.s TRemark=$P(DataList,"^",9)
		.s TTotalFee=$P(DataList,"^",11)
		.s TPaedFee=$p(DataList,"^",12)
		.s TNeedPayFee=$p(DataList,"^",13)
		.s TSourceType=$P(DataList,"^",15)
		.s TSourceID=$P(DataList,"^",16)
		.s TPayPlanDR=$P(DataList,"^",17)	;Mozy0203	20180224
		.
		.;来源类型是入库明细
		.i TSourceType=1 Do
		..Set ISRowID=$P($G(^DHCEQInStockList(TSourceID)),"^",1)
		..s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",TSourceID,"","","")
        ..;q:$p(TInvoiceInfo,"^",1)=0
	    ..s TInvoiceNo=$p(TInvoiceInfo,"^",4)  //modify by mwz 20180313 需求号：550672
	    ..s TInvoiceDate=$p(TInvoiceInfo,"^",5)
		..s TSourceNo=$P($G(^DHCEQInStock(ISRowID)),"^",14)
		..s TDate=$P($G(^DHCEQInStock(ISRowID)),"^",1)
		..s TDate = ##class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		..s TEquipTypeDR=$P($G(^DHCEQInStock(ISRowID)),"^",20)
		..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		..s TEquipName=$P($G(^DHCEQInStockList(TSourceID)),"^",5)
		..s TOriginalFee=+$P($G(^DHCEQInStockList(TSourceID)),"^",7)
		..s TQuantityNum=$P($G(^DHCEQInStockList(TSourceID)),"^",8)
		.q:flag'=0
		.
		.;来源类型是保修合同	Mozy0203	20180224	
		.i TSourceType=8 Do
		..i TPayPlanDR'="" d
		...i $Piece($Get(^DHCEQPayPlan(TSourceID)),"^",2)=1 d
		....;按保修合同制定的付款计划取值	^DHCEQPayPlan	付款计划
		....s SID=$Piece($Get(^DHCEQPayPlan(TSourceID)),"^",3)
		....s GlobalData=$Get(^DHCEQPayRecord(TSourceID,"List"))	;20180424 Mozy0205
		....Set TProviderDR=$Piece($Get(^DHCEQContract(SID)),"^",18)
		....Set TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	//供应商
		....s ContractListDR=""
		....f  s ContractListDR=$o(^DHCEQContractList(0,"Contract",SID,ContractListDR)) quit:(ContractListDR="")||(flag'=0)  d
		.....;//Mozy	567216	201-3-26	增加类组取值
		.....s ContractListSType = $p($g(^DHCEQContractList(ContractListDR)),"^",5)	;1:计划 2:招标 3:设备项 4:设备 5:入库明细
		.....s ContractListSID = $p($g(^DHCEQContractList(ContractListDR)),"^",17)
		.....i ContractListSType=1 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(ContractListSID)),"^",1))),"^",12)
		.....else  if ContractListSType=2 d
		......Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(ContractListSID)),"^",3)
		......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
		.....else  if ContractListSType=3 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",ContractListSID)),"^",3)
		.....else  if ContractListSType=4 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",63)
		.....else  if ContractListSType=5 d
		......Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(ContractListSID)),"^",1))),"^",20)
		.....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(+TEquipTypeDR)
		....;; End
		....Set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		....s TEquipName=$p($g(^DHCEQPayPlan(TSourceID)),"^",1)
		....s TOriginalFee=$p($g(^DHCEQPayPlan(TSourceID)),"^",10)	;PP_PayAmount
		....Set TSourceNo=$p($g(^DHCEQContract(SID)),"^",2)
		....Set TEquipName=$p($g(^DHCEQContract(SID)),"^",1)_"("_TEquipName
		....Set TEquipName=TEquipName_"计划支付日期:"_##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQPayPlan(TSourceID)),"^",6),"date")_")"
		....If TOriginalFee="" Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(SID)),"^",4),0)*0.01*$p($g(^DHCEQPayPlan(TSourceID)),"^",9)
		....s TQuantityNum=1
		....;s TDate=$p($g(^DHCEQPayPlan(TSourceID)),"^",6)
		....;i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		....s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p($g(^DHCEQContract(SID)),"^",8))	;合同签订部门
		....i ContractListSType=2 s TFileNo=$Piece($Get(^DHCEQEquip(ContractListSID)),"^",85)
		....s TInvoiceNo=$Piece(GlobalData,"^",3)	;20180424 Mozy0205
		....s PayInfo=##Class(web.DHCEQPay).CheckPayInfo("8",TSourceID,"","","",TSourceID)
		....s TTotalFee=TOriginalFee
		....s TPaedFee=$p(PayInfo,"^",2)
		....s TNeedPayFee=TTotalFee-TPaedFee
		..e  d
		...s CTLRowID=0
		...f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",TSourceID,CTLRowID)) q:(CTLRowID="")||(flag'=0)  d
		....s CTLST=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",5)	;1入库明细	2设备
		....s CTLSI=$Piece($Get(^DHCEQContractList(CTLRowID)),"^",17)
		....;;;Mozy	2018-3-26	567216	修正保修合同明细的类组取值
		....s TEquipTypeDR=""
		....i CTLST=1 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQBuyPlan($Piece($Get(^DHCEQBuyPlanList(CTLSI)),"^",1))),"^",12)
		....else  if CTLST=2 d
		.....Set IFBBagItemDR = +$Piece($Get(^DHCEQIFBBag(CTLSI)),"^",3)
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",IFBBagItemDR)),"^",3)
		....else  if CTLST=3 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",CTLSI)),"^",3)
		....else  if CTLST=4 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(CTLSI)),"^",63)
		....else  if CTLST=5 d
		.....Set TEquipTypeDR=$Piece($Get(^DHCEQInStock($Piece($Get(^DHCEQInStockList(CTLSI)),"^",1))),"^",20)
		....set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		....s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		...
		...s TSourceNo=$Piece($Get(^DHCEQContract(TSourceID)),"^",2)
		...s TEquipName = $Piece($Get(^DHCEQContract(TSourceID)),"^",1)
		...s TProviderDR = $Piece($Get(^DHCEQContract(TSourceID)),"^",18)
		...s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
		...;s TDate=$p($g(^DHCEQContract(TSourceID)),"^",7)	;合同签订日期
		...;s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		...s TOriginalFee=$Piece($Get(^DHCEQContract(TSourceID)),"^",5)	;买保金额
		...s TQuantityNum=1
		...s PayInfo=##Class(web.DHCEQPay).CheckPayInfo(8,TSourceID,"","","","")
		...s TTotalFee=TQuantityNum*TOriginalFee
		...s TPaedFee=$p(PayInfo,"^",2)
		...s TNeedPayFee=TTotalFee-TPaedFee
		...s TLoc=$p($g(^DHCEQContract(TSourceID)),"^",8)   ;合同签订部门
		...s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
		...s GlobalData=$Get(^DHCEQPayRecord(rowid,"List"))
		...s TFileNo=$Piece(GlobalData,"^",4)
		...s TLocDR=$Piece(GlobalData,"^",5)
		...i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
		.q:flag'=0
		.
		.;来源类型是配件转移明细
		.i TSourceType=11 Do
		..s AMSRowID=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",1)
		..s TAccessoryTypeDR=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",2)
		..s flag=##class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR)
		..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("AccessoryType", TAccessoryTypeDR)
		..s AMSLAISListDR=$Piece($Get(^DHCEQAMoveStockList(TSourceID)),"^",15)	;入库明细AISL_InStockListDR
		..s AISRowID=$Piece($Get(^DHCEQAInStockList(AMSLAISListDR)),"^",1)
		..q:AISRowID=""         //add by mwz 20180313 需求号：551254
		..s TSourceNo=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",1)
		..s TEquipName = $p($g(^DHCEQAMoveStockList(TSourceID)),"^",4)
		..s TUnitDR=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",6)
		..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		..s TDate=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",7)
		..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		..s TOriginalFee=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",10)
		..s TQuantityNum=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",11)
		..s TInvoiceNo=$p($g(^DHCEQAInStockList(AMSLAISListDR)),"^",19)		;Mozy	587950	2018-11-28
		..s TLoc=$p($g(^DHCEQAMoveStock(AMSRowID)),"^",5)
		..i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
		..s TAMSLHold3=$p($g(^DHCEQAMoveStockList(TSourceID)),"^",20)		;Mozy	588024	2018-11-28
		.q:flag'=0
		.
		.;来源类型是转移明细(首次)
		.i TSourceType=12 Do
		..s SMRowID=$Piece($Get(^DHCEQStoreMoveList(TSourceID)),"^",1)
		..s TEquipTypeDR=$p($g(^DHCEQStoreMove(SMRowID)),"^",16)		;SMEquipTypeDR
		..s flag=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		..set TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype", TEquipTypeDR)
		..s TSourceNo=$p($g(^DHCEQStoreMove(SMRowID)),"^",1)
		..s TEquipName = $p($g(^DHCEQStoreMoveList(TSourceID)),"^",5)
		..s TUnitDR=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",10)
		..i TUnitDR'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		..s TDate=$p($g(^DHCEQStoreMove(SMRowID)),"^",10)
		..s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
		..s TOriginalFee=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",7)
		..s TQuantityNum=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",8)
		..i $Get(^DHCEQPayRecord(rowid,"List"))'="" s TQuantityNum=$length($Get(^DHCEQPayRecord(rowid,"List")),",")
		..i $p($g(^DHCEQStoreMoveList(TSourceID)),"^",3)="Y" d	;SML_BatchFlag
		...s TInvoiceInfo=##Class(web.DHCEQPay).CheckInvoice("1",$p($g(^DHCEQStoreMoveList(TSourceID)),"^",4),"","","")
        ...q:$p(TInvoiceInfo,"^",1)=0
	    ...s TInvoiceNo=$p(TInvoiceInfo,"^",4)    //modify by mwz 20180313 需求号：550672
		..s TLoc=$p($g(^DHCEQStoreMove(SMRowID)),"^",3)
		..i TLoc'="" s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLoc)
		.q:flag'=0
		.
		.;q:##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
		.s TAmountFee=$P(DataList,"^",3)
		.s TRemark=$P(DataList,"^",9)
		.s TGuaranteeFee=$P(DataList,"^",14)
		.s TGuaranteeDate=$P(DataList,"^",32)
		.s TRate=$P(DataList,"^",33)	//add by csj 20200108 质保金比例
		.s Total=Total+TAmountFee
		.s TFlag="Y"
		.d OutputRowGetUnPayList
	}
#;	d ResetVariablesGetUnPayList
#;	s TEquipName="合计："
#;	s TQuantityNum=TotalQty
#;	s TTotalFee=Total
#;	d OutputRowGetUnPayList

	Quit $$$OK
OutputRowGetUnPayList
	s TRow=TRow+1
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	s TPaedFee=##Class(web.DHCEQCommon).FormatNumber(TPaedFee,"")
	s TNeedPayFee=##Class(web.DHCEQCommon).FormatNumber(TNeedPayFee,"")
	s TAmountFee=##Class(web.DHCEQCommon).FormatNumber(TAmountFee,"")
	i TProviderDR="" s TProviderDR=ProviderDR  //add by mwz 需求号551659
#;	s TotalQty=TotalQty+TQuantityNum //总数量
#;	s Total=Total+TNeedPayFee	//需付总金额

	Set Data=$lb(TRowID,TRow,TSourceType,TSourceID,TSourceNo,TDate,TEquipName,TOriginalFee,TQuantityNum,TTotalFee,TPaedFee,TNeedPayFee,TAmountFee,TRemark,TReduceQtyNum,TFlag,TInvoiceNo,TInvoiceDate,TLoc,TAMSLHold3,TListInfo,TEquipType,TProviderDR,TGuaranteeDate,TGuaranteeFee,TRate,TOpenCheckDate,TProvider,TJob,TOpenCheckAuditDate,TOpenCheckOrigin,TOpenCheckRemark,TUseLoc)    ////modify by mwz 20180313 需求号：550672
	Set ^CacheTemp(repid,index)=Data
	Set ^DHCEQTemp("UnPayRequestList",+$H,TJob,index)=TRowID_"^"_TSourceType_"^"_TSourceNo_"^"_TDate_"^"_TEquipName_"^"_TOriginalFee_"^"_TQuantityNum_"^"_TTotalFee_"^"_TPaedFee_"^"_TNeedPayFee_"^"_TAmountFee_"^"_TRemark_"^"_TReduceQtyNum_"^"_TInvoiceNo_"^"_TInvoiceDate_"^"_TLoc_"^"_TEquipType_"^"_TGuaranteeDate_"^"_TGuaranteeFee_"^"_TRate_"^"_TOpenCheckDate_"^"_TProvider_"^"_TOpenCheckAuditDate_"^"_TOpenCheckOrigin_"^"_TOpenCheckRemark_"^"_TUseLoc

	Set index=index+1
	Quit
ResetVariablesGetUnPayList
	Set (DataList,TRowID,TEquipTypeDR,TSourceType,TSourceID,TSourceNo,TDate,TEquipName,TOriginalFee,TQuantityNum,TTotalFee,TPaedFee,TNeedPayFee,TAmountFee,TRemark,TReduceQtyNum,TFlag,TInvoiceNo,TInvoiceDate,TLoc,TAMSLHold3,TListInfo,TEquipType,TProviderDR,TProvider,TGuaranteeDate,TGuaranteeFee,TRate,TOpenCheckDate,TOpenCheckAuditDate,TOpenCheckOriginDR,TOpenCheckOrigin,TOpenCheckRemark,TUseLoc)=""
	Quit
}

ClassMethod GetUnPayListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetUnPayListExecute ]
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

ClassMethod GetUnPayListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetUnPayListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by csj 2020-05-06 返回总数量、总需付金额
/// d ##class(web.DHCEQPayRequest).GetSumUnPayInfo()
ClassMethod GetSumUnPayInfo(Job)
{
	s info=""
	s (Count,TotalFee)=0
	s nrowid=0
	i Job'="" 
	{
		f  s nrowid=$o(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)) q:nrowid=""  d
		.s TotalFee=TotalFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",10),"")
		.s Count=Count+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",7),"")
	}
  	s info="总数量:"_Count_"&nbsp;&nbsp;&nbsp;总需付金额:"_TotalFee_"元"   
  	q info
}

/// add by csj 2020-05-06 返回总数量、总需付金额
/// d ##class(web.DHCEQPayRequest).GetSumUnPayInfoSimple()
ClassMethod GetSumUnPayInfoSimple(Job)
{
	s info=""
	s (Count,TotalFee,TotalNeedPay,TotalPaed)=0
	s nrowid=0
	i Job'="" 
	{
		f  s nrowid=$o(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)) q:nrowid=""  d
		.s TotalNeedPay=TotalNeedPay+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",10),"")
		.s Count=Count+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",7),"")
		.s TotalFee=TotalFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",8),"")
		.s TotalPaed=TotalPaed+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("UnPayRequestList",+$H,Job,nrowid)),"^",9),"")
	}
  	s info=Count_"^"_TotalFee_"^"_TotalNeedPay_"^"_TotalPaed
  	q info
}

/// add by zx 2015-10-23
/// 判断质保日期,日期范围内返回日期,其他返回空
/// w ##Class(web.DHCEQPayRequest).CheckGuaranteeDate(11,15)
ClassMethod CheckGuaranteeDate(SourceType, SourceID)
{
	n TGuaranteeDate,PRowID,TDate,TFee,TFlag
	s (TGuaranteeDate,TDate,TFee)=""
	s TFlag=0
	s PRowID=0
	f  s PRowID=$o(^DHCEQPayRecord(0,"Source",SourceType,SourceID,PRowID)) q:PRowID=""  d
	.s TInvalidFlag=$p(^DHCEQPayRecord(PRowID),"^",29)
	.q:TInvalidFlag="Y"
	.s TDate=$p(^DHCEQPayRecord(PRowID),"^",32)
	.s TDate=##Class(web.DHCEQCommon).Trim(TDate)
	.i TDate'="" s TDate=$zdh(TDate,3)
	.s TGuaranteeDate=TDate
	.s TFee=$p(^DHCEQPayRecord(PRowID),"^",14)
	.i TDate>+$h s TFlag=1  // 
	
	q TFlag_"^"_TGuaranteeDate_"^"_TFee
}

/// MZY0068			2021-02-02
/// 南方医院	根据首次出库单向供应商联系人发送业务办理提醒短信通知
/// 在打印单据或者界面增加按钮
/// RowID:付款申请单ID
/// SecondFlag:二次发送标识
/// PhoneNo:指定手机号
/// d ##Class(web.DHCEQPayRequest).SendMessage(3395)
ClassMethod SendMessage(RowID As %Library.String = "", SecondFlag As %Library.String = "0", PhoneNo As %Library.String = "")
{
	i RowID="" q ""
	
	d ##Class(web.DHCEQCommon).KillTempGlobal("SendMessage")
	Set Job=$j
	s PayRequestDR=""
	s PayRequestNo=""
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQPayRecord(0,"PayRequest",RowID,rowid)) Quit:rowid=""  Do
	.s PayRequestDR=$P($G(^DHCEQPayRecord(rowid)),"^",10)
	.s TSourceType=$P($G(^DHCEQPayRecord(rowid)),"^",15)
	.s TSourceID=$P($G(^DHCEQPayRecord(rowid)),"^",16)
	.;来源类型是转移明细(首次)
	.i TSourceType=12 Do
	..s SMRowID=$Piece($Get(^DHCEQStoreMoveList(TSourceID)),"^",1)
	..s EquipName = $p($g(^DHCEQStoreMoveList(TSourceID)),"^",5)
	..s QuantityNum=$p($g(^DHCEQStoreMoveList(TSourceID)),"^",8)
	..s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom", $p($g(^DHCEQStoreMoveList(TSourceID)),"^",10))
	..i $Piece($Get(^DHCEQPayRecord(rowid,"List")),"^",1)'="" s QuantityNum=$length($Piece($Get(^DHCEQPayRecord(rowid,"List")),"^",1),",")
	..s Loc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", $p($g(^DHCEQStoreMove(SMRowID)),"^",3))
	..
	..s EquipIDs=$Get(^DHCEQStoreMoveList(TSourceID,"EX","RowIDs"))
	..s No=""
	..s Len=$l(EquipIDs,",")
	..f i=1:1:Len  d
	...s EquipID=$p(EquipIDs,",",i)
	...q:EquipID=""
	...i No'="" s No=No_","
	...;s No=No_$Piece($Get(^DHCEQEquip(EquipID)),"^",71)	;设备编号
	...s No=No_$Piece($Get(^DHCEQEquip(EquipID)),"^",85)	;档案号
	..
	..s EQOpenCheckListDR=$Piece($Get(^DHCEQEquip(+EquipIDs)),"^",77)
	..i PhoneNo="" s PhoneNo=$p($g(^DHCEQOpenCheckRequest($p($g(^DHCEQOpenCheckList(EQOpenCheckListDR)),"^",1))),"^",7)		;OCRProviderTel
	..s ^DHCEQTemp("SendMessage",+$H,Job,PhoneNo,EQOpenCheckListDR,TSourceID)=EquipName_"("_No_") "_QuantityNum_Unit_"("_Loc_")"
	i PayRequestDR'="" s PayRequestNo=$P($G(^DHCEQPayRequest(PayRequestDR)),"^",1)
	
	Set PhoneNo=""
	For  Set PhoneNo=$Order(^DHCEQTemp("SendMessage",+$H,Job,PhoneNo)) Quit:PhoneNo=""  Do
	.s SendMsgInfo=""	//按手机号发送短信消息
	.Set EQOpenCheckListDR=""
	.For  Set EQOpenCheckListDR=$Order(^DHCEQTemp("SendMessage",+$H,Job,PhoneNo,EQOpenCheckListDR)) Quit:EQOpenCheckListDR=""  Do
	..s OCLOpenCheckRequestDR=$p($g(^DHCEQOpenCheckList(EQOpenCheckListDR)),"^",1)
	..s Provider=$p($g(^DHCEQOpenCheckRequest(OCLOpenCheckRequestDR)),"^",5)
	..s Provider=##class(web.DHCEQCommon).GetTrakNameByID("prov",Provider)		//供应商
	..s ReceiveUser=$p($g(^DHCEQOpenCheckRequest(OCLOpenCheckRequestDR)),"^",6)		;OCRProviderHandler
	..
	..Set SourceID=""
	..For  Set SourceID=$Order(^DHCEQTemp("SendMessage",+$H,Job,PhoneNo,EQOpenCheckListDR,SourceID)) Quit:SourceID=""  Do
	...i SendMsgInfo'="" s SendMsgInfo=SendMsgInfo_$CHAR(13)
	...s SendMsgInfo=SendMsgInfo_$g(^DHCEQTemp("SendMessage",+$H,Job,PhoneNo,EQOpenCheckListDR,SourceID))
	.
	.i +SecondFlag=0 d
	..s SendMsgInfo="【南方医院】尊敬的"_ReceiveUser_"(先生/女士),贵公司("_Provider_")向我单位提供的设备现已办完验收手续,请于工作日至南方医院后勤保障楼5楼515室(020-61642150 李老师)领取仪器设备验收请领报销单("_PayRequestNo_")及设备标签,以办理后续回款手续!相关设备为:"_SendMsgInfo
	.e  d
	..s SendMsgInfo="【南方医院】尊敬的"_ReceiveUser_"(先生/女士),请于工作日至南方医院后勤保障楼5楼515室(020-61642150 李老师)领取仪器设备验收请领报销单("_PayRequestNo_").携带发票(原件),购置审批流程(原件)和仪器设备验收请领报销单方可至本院医务处(150栋15楼)办理后续回款手续!"
	.;w ReceiveUser_":"_PhoneNo_":"_SendMsgInfo,!
	.w ##Class(web.DHCEQMessageSendInfo).AddData("1^^^"_ReceiveUser_"^"_SendMsgInfo_"^"_PhoneNo)	;发送短信15989089044	_PhoneNo	13660127852
	.;消息记录
	.i +SecondFlag=0 d
	..s ^DHCEQPayRequest(RowID,"SendMessage",$H,PhoneNo)=SendMsgInfo
	.e  d
	..s ^DHCEQPayRequest(RowID,"SecondMessage",$H,PhoneNo)=SendMsgInfo
}

}
