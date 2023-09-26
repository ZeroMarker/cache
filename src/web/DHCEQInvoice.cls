/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:入库明细的发票信息管理
/// --------------------------------
Class web.DHCEQInvoice Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod InvoiceInfoList(name, width) As %String
{
	;;
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>为  空</option>"
	w "<option value=1>不为空</option>"
	w "<option value=2>不完整</option>"
	w "<option value=3>完  整</option>"
	w "</select>",!
}

ClassMethod PayRecordInfoList(name, width) As %String
{
	;;
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	w "<option value=></option>"
	w "<option value=0>为  空</option>"
	w "<option value=1>不为空</option>"
	w "<option value=2>不完整</option>"
	w "<option value=3>完  整</option>"
	w "</select>",!
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:根据发票号查询发票
/// --------------------------------
Query GetInvoice(InvoiceNo, ProvderDR) As %Query(ROWSPEC = "TNo:%String,Hidden:%String,TCode:%String,TDate:%String,TAmountFee:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,TProvider:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String,Hidden:%String")
{
}

ClassMethod GetInvoiceExecute(ByRef qHandle As %Binary, InvoiceNo, ProvderDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s InvoiceNo=$ZCONVERT(InvoiceNo,"U")
	d BuildDataGetInvoice
	Quit $$$OK
BuildDataGetInvoice
	s rowid=0
	f  s rowid=$o(^DHCEQInvoice(rowid)) q:rowid=""  d
	.d ResetVariablesGetInvoice
	.s TInvalidFlag=$p($g(^DHCEQInvoice(rowid)),"^",16)
	.q:TInvalidFlag="Y"
	.s TRowID=rowid
	.s TCode=$p($g(^DHCEQInvoice(rowid)),"^",1)
	.s TNo=$p($g(^DHCEQInvoice(rowid)),"^",2)
	.q:(InvoiceNo'="")&($ZCONVERT(TNo,"U")'[InvoiceNo)
	.s TDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInvoice(rowid)),"^",3),"date")
	.s TAmountFee=$p($g(^DHCEQInvoice(rowid)),"^",4)
	.s TTypeDR=$p($g(^DHCEQInvoice(rowid)),"^",6)
	.i TTypeDR'="" s TInvoiceType=$P(^DHCEQCCode("DHCEQCInvoiceType",TTypeDR),"^",2)
	.s TCertificateDR=$p($g(^DHCEQInvoice(rowid)),"^",15)
	.i TCertificateDR'=""  s TCertificateNo=$p($g(^DHCEQCertificate(TCertificateDR)),"^",2)
  	.s TProviderDR=$p($g(^DHCEQInvoice(rowid)),"^",5)	;ProviderDR
  	.q:(ProvderDR'="")&&(TProviderDR'=ProvderDR)
  	.i TProviderDR'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
  	.s TCustomer=$p($g(^DHCEQInvoice(rowid)),"^",7)
  	.s TInvoiceDept=$p($g(^DHCEQInvoice(rowid)),"^",8)
  	.s TPayedAmountFee=$p($g(^DHCEQInvoice(rowid)),"^",9)
  	.s TStatus=$p($g(^DHCEQInvoice(rowid)),"^",10)
  	.s TRemark=$p($g(^DHCEQInvoice(rowid)),"^",14)
  	.s THold1=$p($g(^DHCEQInvoice(rowid)),"^",17)
  	.s THold2=$p($g(^DHCEQInvoice(rowid)),"^",18)
  	.s THold3=$p($g(^DHCEQInvoice(rowid)),"^",19)
  	.s THold4=$p($g(^DHCEQInvoice(rowid)),"^",20)
  	.s THold5=$p($g(^DHCEQInvoice(rowid)),"^",21)
	.d OutputRowGetInvoice
	quit
OutputRowGetInvoice
	s Data=$lb(TNo,TRowID,TCode,TDate,TAmountFee,TTypeDR,TInvoiceType,TCertificateDR,TCertificateNo,TProviderDR,TProvider,TCustomer,TInvoiceDept,TPayedAmountFee,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInvoice
	s (TNo,TRowID,TCode,TDate,TAmountFee,TTypeDR,TInvoiceType,TCertificateDR,TCertificateNo,TProviderDR,TProvider,TCustomer,TInvoiceDept,TPayedAmountFee,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetInvoiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInvoiceExecute ]
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

ClassMethod GetInvoiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInvoiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:入库明细查询
/// --------------------------------
Query GetInStockDetail(ISNo, LocDR, Status, StartDate, EndDate, InvoiceNos, MinPrice, MaxPrice, ProviderDR, Name, EquipTypeDR, InvoiceInfoDR, PayRecordInfoDR, QXType As %String = "") As %Query(ROWSPEC = "TISRowID:%String,TProviderDR:%String,TProvider:%String,TInDate:%String,TISNo:%String,TLocDR:%String,TLoc:%String,TStatCatDR:%String,TStatCat:%String,TEquipTypeDR:%String,TEquipType:%String,TStatus:%String,TEquipName:%String,TModelDR:%String,TModel:%String,TOriginalFee:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TInvoice:%String,TTotalFee:%String,TEquipCat:%String,TUseYearsNum:%String,TISLRowID:%String")
{
}

ClassMethod GetInStockDetailExecute(ByRef qHandle As %Binary, ISNo, LocDR, Status, StartDate, EndDate, InvoiceNos, MinPrice, MaxPrice, ProviderDR, Name, EquipTypeDR, InvoiceInfoDR, PayRecordInfoDR, QXType As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	s InvoiceNos=$ZCONVERT(InvoiceNos,"U")
	d BuildDataGetInStockDetail
	Quit $$$OK
BuildDataGetInStockDetail
	s ISRowID=0
	f  s ISRowID=$o(^DHCEQInStock(ISRowID))  quit:ISRowID=""  d
	.q:$p($g(^DHCEQInStock(ISRowID)),"^",25)'="N"	//add by CZF0061 2020-02-20
	.s TInDate=$p($g(^DHCEQInStock(ISRowID)),"^",1)
	.q:(TInDate>EndDate)||(TInDate<StartDate)
	.s TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	.s TLocDR=$p(^DHCEQInStock(ISRowID),"^",2)
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR))) //2010-10-26 DJ
	.i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TStatusDR=$p(^DHCEQInStock(ISRowID),"^",10)
	.q:(Status'="")&&(TStatusDR'=Status)
	.s TISNo=$p(^DHCEQInStock(ISRowID),"^",14)
	.q:TISNo=""		//Add By DJ 2015-07-14 DJ0147
	.q:(ISNo'="")&&(TISNo'[ISNo)
	.s TProviderDR=$p(^DHCEQInStock(ISRowID),"^",17)
	.q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	.s TEquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
	.q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	.s rowid=0
	.f  s rowid=$o(^DHCEQInStockList(0,"InStock",ISRowID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetInStockDetail
	..s TEquipName=$p(^DHCEQInStockList(rowid),"^",5)
	..q:(Name'="")&&(TEquipName'[Name)
	..s TPrice=$p(^DHCEQInStockList(rowid),"^",7)
	..q:(MinPrice="")&&(MaxPrice'="")&&(TPrice>MaxPrice)
	..q:(MinPrice'="")&&(MaxPrice="")&&(TPrice<MinPrice)
	..q:(MinPrice'="")&&(MaxPrice'="")&&((TPrice<MinPrice)||(TPrice>MaxPrice))
	..d GetOneInStockDetail
	quit
GetOneInStockDetail
	s TISRowID=ISRowID
	s TISLRowID=rowid
	s TInDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(TISRowID)),"^",1),"date")
	s TLoc=$p($g(^CTLOC($p(^DHCEQInStock(ISRowID),"^",2))),"^",2)
	s TISNo=$p(^DHCEQInStock(ISRowID),"^",14)
	s TProviderDR=$p(^DHCEQInStock(TISRowID),"^",17)
	s TProvider=##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TStatCatDR=$p($g(^DHCEQInStock(TISRowID)),"^",21)
	;q:(StatCatDR'="")&&(TStatCatDR'=StatCatDR)
	i TStatCatDR '="" s TStatCat = $p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TEquipTypeDR=$p($g(^DHCEQInStock(TISRowID)),"^",20)
	q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	q:+result'=0
	i TEquipTypeDR '="" s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TStatus=$p($g(^DHCEQInStock(TISRowID)),"^",10)
	s TStatus = $CASE(TStatus,"0":"新增","1":"提交","2":"审核",:"没有定义")
	s TModelDR=$p(^DHCEQInStockList(rowid),"^",9)
	i TModelDR'="" d
	.s TModel=$P(^DHCEQCCode("DHCEQCModel",TModelDR),"^",2)
	s TUseYearsNum=$p(^DHCEQInStockList(rowid),"^",15)
	s TOriginalFee=$p(^DHCEQInStockList(rowid),"^",7)
	s TQuantityNum=$p(^DHCEQInStockList(rowid),"^",8)
	s TTotalFee=TOriginalFee*TQuantityNum
	s TEquipCatDR=$p(^DHCEQInStockList(rowid),"^",14)
	i TEquipCatDR'="" s TEquipCat=$P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	s TUnitDR=$p(^DHCEQInStockList(rowid),"^",10)
	i TUnitDR'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	//发票信息
	s StrInvoice=""
	s FirstInvoice=""
	s Num=0
	s Amount=0
	s IUMRowID=0
	f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","1",rowid,IUMRowID)) q:(IUMRowID="")  d
	.s InvoiceDR=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
	.i InvoiceDR'="" d
	..s InvalidFlag=$P(^DHCEQInvoice(InvoiceDR),"^",16)
	..q:InvalidFlag="Y"
	..s Invoice=$P(^DHCEQInvoice(InvoiceDR),"^",2)
	..s InvoiceFee=$P(^DHCEQInvoice(InvoiceDR),"^",4)
	..s Amount=Amount+InvoiceFee
	..i Num=0 s FirstInvoice=Invoice
	..s Num=Num+1
	..i StrInvoice'="" s StrInvoice=StrInvoice_","_Invoice
	..e  s StrInvoice=Invoice
	i InvoiceInfoDR=0 q:StrInvoice'=""
	i InvoiceInfoDR=1 q:StrInvoice=""
	i InvoiceInfoDR=2 q:(StrInvoice="")||(TTotalFee<=Amount)
	i InvoiceInfoDR=3 q:(StrInvoice="")||(TTotalFee>Amount>0)
	//发票号
	q:((","_StrInvoice_",")'[(","_InvoiceNos_","))&(InvoiceNos'="")
	i InvoiceNos'=""  s FirstInvoice=InvoiceNos
	s TInvoice=FirstInvoice
	i (FirstInvoice'="")&(Num>1) s TInvoice=FirstInvoice_"..."
	//支付信息
	i ((PayRecordInfoDR=1)||(PayRecordInfoDR=2)||(PayRecordInfoDR=3)) q:StrInvoice=""
	s Flag=0
	s Amount=0
	s IUMRowID=0
	f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","1",rowid,IUMRowID)) q:(IUMRowID="")||(Flag=1)  d
	.s InvoiceDR=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
	.i InvoiceDR'="" d
	..s InvalidFlag=$P(^DHCEQInvoice(InvoiceDR),"^",16)
	..q:InvalidFlag="Y"
	..i (PayRecordInfoDR=0)&($Data(^DHCEQPayRecord(0,"Invoice",InvoiceDR))'=0) s Flag=1
	..i (PayRecordInfoDR=1)&($Data(^DHCEQPayRecord(0,"Invoice",InvoiceDR))=0) s Flag=1
	..i ((PayRecordInfoDR=2)||(PayRecordInfoDR=3))&($Data(^DHCEQPayRecord(0,"Invoice",InvoiceDR))=0) s Flag=1
	..q:Flag=1
	..s TotlaPayFee=0
	..s PRRowID=0
	..for  s PRRowID=$o(^DHCEQPayRecord(0,"Invoice",InvoiceDR,PRRowID)) q:PRRowID=""  d
	...s PayFee=$P(^DHCEQPayRecord(PRRowID),"^",3)
	...s TotlaPayFee=TotlaPayFee+PayFee
	..i (PayRecordInfoDR=2)&(InvoiceFee=TotlaPayFee) s Flag=1
	..i (PayRecordInfoDR=3)&(InvoiceFee'=TotlaPayFee) s Flag=1
	q:Flag=1
	
	d OutputRowGetInStockDetail
	quit
OutputRowGetInStockDetail
	s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISLRowID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockDetail
	s (TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISLRowID)=""
	quit
}

ClassMethod GetInStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockDetailExecute ]
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

ClassMethod GetInStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:根据入库明细查询到当前明细相关联的发票信息
/// --------------------------------
Query GetInvoiceInfo(SourceType, SourceID) As %Query(ROWSPEC = "TInvoiceUseMapDR:%String,TInvoiceNoDR:%String,TCode:%String,TInvoiceNo:%String,TDate:%String,TAmountFee:%String,TProviderDR:%String,TProvider:%String,TInvoiceTypeDR:%String,TInvoiceType:%String,TCustomer:%String,TInvoiceDept:%String,TPayedAmountFee:%String,TStatus:%String,TRemark:%String,TCertificateNoDR:%String,TCertificateType:%String,TCertificateNo:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String")
{
}

ClassMethod GetInvoiceInfoExecute(ByRef qHandle As %Binary, SourceType, SourceID) As %Status
{
 	new repid,index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s TRow=0
	q:SourceType=""
	q:SourceID=""
	d BuildDataGetInvoiceInfo
	Quit $$$OK
BuildDataGetInvoiceInfo
  	s IUMRowID=0
  	f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",SourceType,SourceID,IUMRowID)) q:IUMRowID=""  d
  	.d ResetVariablesGetInvoiceInfo
  	.s TInvoiceUseMapDR=IUMRowID
  	.s TInvoiceNoDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",2)
  	.i TInvoiceNoDR'="" d
	..s TInvalidFlag=##Class(web.DHCEQCommon).TransValueToPage($P(^DHCEQInvoice(TInvoiceNoDR),"^",16),"bool")
	..q:TInvalidFlag=1
  	..s TCode=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",1)			;code
  	..s TInvoiceNo=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",2)  	;no
  	..s TDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",3),"date")
  	..s TAmountFee=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",4)	;AmountFee
  	..s TProviderDR=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",5)	;ProviderDR
  	..i TProviderDR'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
  	..s TInvoiceTypeDR=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",6)		;发票类型
  	..i TInvoiceTypeDR'="" s TInvoiceType=$P(^DHCEQCCode("DHCEQCInvoiceType",TInvoiceTypeDR),"^",2)
  	..s TCustomer=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",7)				;客户
  	..s TInvoiceDept=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",8)			;开票单位
  	..s TPayedAmountFee=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",9)		;已付金额
  	..s TStatus=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",10)				;状态
  	..s TRemark=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",14)				;备注
  	..s CertificateDR=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",15)		;凭证
  	..i CertificateDR'="" d
  	...s TCertificateNoDR=CertificateDR
  	...;s TCertificateType=$p($g(^DHCEQCertificate(CertificateDR)),"^",1)
  	...s TCertificateNo=$p($g(^DHCEQCertificate(CertificateDR)),"^",2)
  	...;s TCertificateDate=$p($g(^DHCEQCertificate(CertificateDR)),"^",3)
  	...;i TCertificateDate'="" s TCertificateDate=##class(web.DHCEQCommon).TransValueToPage(TCertificateDate,"date")
  	...;s TCertificateFee=$p($g(^DHCEQCertificate(CertificateDR)),"^",5)
  	..s THold1=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",17)
  	..s THold2=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",18)
  	..s THold3=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",19)
  	..s THold4=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",20)
  	..s THold5=$p($g(^DHCEQInvoice(TInvoiceNoDR)),"^",21)
  	..d OutputRowGetInvoiceInfo
	quit
OutputRowGetInvoiceInfo
	s TRow=TRow+1
	s Data=$lb(TInvoiceUseMapDR,TInvoiceNoDR,TCode,TInvoiceNo,TDate,TAmountFee,TProviderDR,TProvider,TInvoiceTypeDR,TInvoiceType,TCustomer,TInvoiceDept,TPayedAmountFee,TStatus,TRemark,TCertificateNoDR,TCertificateType,TCertificateNo,THold1,THold2,THold3,THold4,THold5,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInvoiceInfo
	s (TInvoiceUseMapDR,TInvoiceNoDR,TCode,TInvoiceNo,TDate,TAmountFee,TProviderDR,TProvider,TInvoiceTypeDR,TInvoiceType,TCustomer,TInvoiceDept,TPayedAmountFee,TStatus,TRemark,TCertificateNoDR,TCertificateType,TCertificateNo,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod GetInvoiceInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInvoiceInfoExecute ]
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

ClassMethod GetInvoiceInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInvoiceInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:添加、修改、删除当前入库明细的发票信息
/// --------------------------------
/// w ##Class(web.DHCEQInvoice).UpdateData("^InvoiceUseMapDR=155^SourceID=2^SourceType=1^InvoiceNoDR=121^InvoiceCode=234^InvoiceNo=13453458^Date=30/08/2010^AmountFee=5000^ProviderDR=2610^InvoiceTypeDR=^Customer=客户^InvoiceDept=开票单位^PayedAmountFee=200^Remark=备注备注^CertificateDR=19^Flag=true",0)
ClassMethod UpdateData(Val, Type)
{
	new InvoiceUseMapDR,RowID,InStockDR,Provider,Flag,CertificateDR,PRRowID,Date,Time,SourceID,SourceType
	k PLISTIUM,PLISTI,PLISTPR
	s Date=+$H
	s Flag=""
	s Time=$P($H,",",2)
	Set $ZT="ERROR"
	if ##class(web.DHCEQCommon).ExistsElement(Val,"InvoiceUseMapDR")=1
	{   s InvoiceUseMapDR =##class(web.DHCEQCommon).GetDataByName(Val,"InvoiceUseMapDR")}
	if ##class(web.DHCEQCommon).ExistsElement(Val,"InvoiceNoDR")=1
	{
		s RowID =##class(web.DHCEQCommon).GetDataByName(Val,"InvoiceNoDR")	;InvoiceNoDR
		s PLISTIUM(3)=RowID
	}
	TSTART
	i +Type=0		//新增或更新
	{		
		if ##class(web.DHCEQCommon).ExistsElement(Val,"SourceID")=1
		{
			s PLISTIUM(2)=##class(web.DHCEQCommon).GetDataByName(Val,"SourceID")
			s SourceID=PLISTIUM(2)
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"SourceType")=1
		{
			s PLISTIUM(4)=##class(web.DHCEQCommon).GetDataByName(Val,"SourceType")
			s SourceType=PLISTIUM(4)
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"InvoiceCode")=1
		{
			s PLISTI(2)=##class(web.DHCEQCommon).GetDataByName(Val,"InvoiceCode")
			s InvoiceCode=PLISTI(2)
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"InvoiceNo")=1
		{
			s PLISTI(3)=##class(web.DHCEQCommon).GetDataByName(Val,"InvoiceNo")
			s InvoiceNo=PLISTI(3)
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Date")=1
		{
			s PLISTI(4)=##Class(web.DHCEQCommon).GetDataByName(Val,"Date")
			s PLISTI(4)=##Class(web.DHCEQCommon).TransValueFromPage(PLISTI(4),"date")	;Date
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"AmountFee")=1
		{
			s PLISTI(5)=##class(web.DHCEQCommon).GetDataByName(Val,"AmountFee")
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"ProviderDR")=1
		{
			s PLISTI(6)=##class(web.DHCEQCommon).GetDataByName(Val,"ProviderDR")
			s ProviderDR=PLISTI(6)
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"InvoiceTypeDR")=1
		{	s PLISTI(7)=##class(web.DHCEQCommon).GetDataByName(Val,"InvoiceTypeDR")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Customer")=1
		{	s PLISTI(8)=##class(web.DHCEQCommon).GetDataByName(Val,"Customer")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"InvoiceDept")=1
		{	s PLISTI(9)=##class(web.DHCEQCommon).GetDataByName(Val,"InvoiceDept")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"PayedAmountFee")=1
		{	s PLISTI(10)=##class(web.DHCEQCommon).GetDataByName(Val,"PayedAmountFee")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Status")=1
		{	s PLISTI(11)=##class(web.DHCEQCommon).GetDataByName(Val,"Status")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"SubmitUerDR")=1
		{	s PLISTI(12)=##class(web.DHCEQCommon).GetDataByName(Val,"SubmitUerDR")}
		s PLISTI(13)=Date			;SubmitDate
		s PLISTI(14)=Time			;SubmitTime
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Remark")=1
		{	s PLISTI(15)=##class(web.DHCEQCommon).GetDataByName(Val,"Remark")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"CertificateDR")=1
		{
			s PLISTI(16)=##class(web.DHCEQCommon).GetDataByName(Val,"CertificateDR")
			s CertificateDR=PLISTI(16)
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"InValidFlag")=1
		{
			s PLISTI(17)=##class(web.DHCEQCommon).GetDataByName(Val,"InValidFlag")
			s PLISTI(17)=##class(web.DHCEQCommon).TransValueFromPage(PLISTI(17),"bool")	;InValidFlag
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Hold1")=1
		{	s PLISTI(18)=##class(web.DHCEQCommon).GetDataByName(Val,"Hold1")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Hold2")=1
		{	s PLISTI(19)=##class(web.DHCEQCommon).GetDataByName(Val,"Hold2")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Hold3")=1
		{	s PLISTI(20)=##class(web.DHCEQCommon).GetDataByName(Val,"Hold3")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Hold4")=1
		{	s PLISTI(21)=##class(web.DHCEQCommon).GetDataByName(Val,"Hold4")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Hold5")=1
		{	s PLISTI(22)=##class(web.DHCEQCommon).GetDataByName(Val,"Hold5")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Flag")=1
		{
			s Flag=##class(web.DHCEQCommon).GetDataByName(Val,"Flag")
			s Flag=##class(web.DHCEQCommon).TransValueFromPage(Flag,"bool")	;Flag
		}
		if RowID=""		//新增发票和发票使用记录
		{
			&SQL(insert into sqluser.DHC_EQInvoice values :PLISTI())
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
			s RowID=$G(%ROWID)
			s PLISTIUM(3)=RowID
			&SQL(insert into sqluser.DHC_EQInvoiceUseMap values :PLISTIUM())
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
			if InvoiceUseMapDR'=""
			{
				&SQL(delete from sqluser.DHC_EQInvoiceUseMap  where IUM_RowID=:InvoiceUseMapDR)
				i SQLCODE
				{
					TROLLBACK
					q SQLCODE
				}
			}
			
		}
		else		//更新发票和发票使用信息
		{
			&SQL(update sqluser.DHC_EQInvoice values :PLISTI() where IV_RowID=:RowID)
			i SQLCODE=100  s SQLCODE=0
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
			if InvoiceUseMapDR=""
			{
				s SQLCODE=0
				s IUMRowID=0
				for  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",SourceType,SourceID,IUMRowID))  q:IUMRowID=""||SQLCODE'=0  d
				.s InvoiceNoDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",2)
			  	.i InvoiceNoDR'="" d
				..s InvalidFlag=$P(^DHCEQInvoice(InvoiceNoDR),"^",16)
				..q:InvalidFlag="Y"
			  	..s Status=$p($g(^DHCEQInvoice(InvoiceNoDR)),"^",10)	;Status
			  	..q:Status=1||Status=2
			  	..s No=$p($g(^DHCEQInvoice(InvoiceNoDR)),"^",2)			;No
			  	..i No=$p($g(^DHCEQInvoice(RowID)),"^",2) s SQLCODE="不能重复添加发票号!"
				if SQLCODE=0
				{
					&SQL(insert into sqluser.DHC_EQInvoiceUseMap values :PLISTIUM())
				}
			}
			else
			{
				&SQL(update sqluser.DHC_EQInvoiceUseMap values :PLISTIUM() where IUM_RowID=:InvoiceUseMapDR)
			}
			i SQLCODE=100  s SQLCODE=0
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
		if (Flag="Y")		//全额付款时,自动增加一条支付记录
		{
			s PLISTPR(2)=RowID			;InvoiceNoDR
			s PLISTPR(4)=PLISTI(5)		;PayFee
			s PLISTPR(5)=PLISTI(4)
			s PLISTPR(8)=CertificateDR
			s Total=0
			s PRRowID=0
			for  s PRRowID=$o(^DHCEQPayRecord(0,"Invoice",RowID,PRRowID)) q:(PRRowID="")||(Total=1)  d
			.s CertificateID=$p($g(^DHCEQPayRecord(PRRowID)),"^",7)  ;CertificateDR
			.i (CertificateDR'="")&(CertificateID=CertificateDR) s Total=1
			/*
			Mozy0242	2020-01-02	1150896		表结构调整
			if Total=0
			{
				&SQL(insert into sqluser.DHC_EQPayRecord values :PLISTPR())
			}
			else
			{
				&SQL(update sqluser.DHC_EQPayRecord values :PLISTPR() where PR_InvoiceDR=:RowID)
			}
			i SQLCODE=100  s SQLCODE=0
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}*/
		}
	}
	else			//删除时仅删除发票的使用记录
	{
		if (InvoiceUseMapDR'="")
		{
			&SQL(delete from sqluser.DHC_EQInvoiceUseMap where IUM_RowID=:InvoiceUseMapDR)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
	}
 	TCOMMIT
 	q SQLCODE
ERROR
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERROR"_ErrorMsg  	 //返回错误消息 ;
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:根据发票rowid取发票信息
/// --------------------------------
/// w ##Class(web.DHCEQInvoice).GetOneInvoiceInfo("93")
ClassMethod GetOneInvoiceInfo(rowid)
{
	new result,ApproveRole,Flag
	s Flag=0
	s (result,resultex)=""
	s result=^DHCEQInvoice(rowid)
	s resultex=resultex_"^"	;date
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"date")
	
	s resultex=resultex_"^"	;provider
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",5))
	
	s resultex=resultex_"^"	;type
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$P(^DHCEQCCode("DHCEQCInvoiceType",$p(result,"^",6)),"^",2)
	
	s resultex=resultex_"^"	;SubmituDate
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")
	
	s resultex=resultex_"^"	;certificateno
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCertificate($p(result,"^",15))),"^",2)
	
	s resultex=resultex_"^"	;全额付款
	i $d(^DHCEQPayRecord(0,"Invoice",rowid))&($p(result,"^",4)'="")  d
	.s Flag=0
	.s Amount=0
	.s id=0
	.for  s id=$o(^DHCEQPayRecord(0,"Invoice",rowid,id)) q:id=""  d
	..s PayFee=$P($g(^DHCEQPayRecord(id)),"^",3)
	..s Amount=Amount+PayFee
	.i Amount=$p(result,"^",4) s Flag=1
	s resultex=resultex_Flag
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:修改发票发票信息
/// --------------------------------
/// w ##Class(web.DHCEQInvoice).UpdateData("1^8^1^1^23423^19/04/2010^8984^2^^true",0)
ClassMethod SaveDate(Val, Type)
{
	new User,Date,Time
	k PLISTI
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORInvoice"
	if ##class(web.DHCEQCommon).ExistsElement(Val,"RowID")=1
	{  s RowID =##class(web.DHCEQCommon).GetDataByName(Val,"RowID")}	;RowID
	TSTART
	i +Type=0
	{
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Code")=1
		{ s PLISTI(2)=##class(web.DHCEQCommon).GetDataByName(Val,"Code")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"No")=1
		{ s PLISTI(3)=##class(web.DHCEQCommon).GetDataByName(Val,"No")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Date")=1
		{
			s PLISTI(4)=##Class(web.DHCEQCommon).GetDataByName(Val,"Date")
			s PLISTI(4)=##Class(web.DHCEQCommon).TransValueFromPage(PLISTI(4),"date")	;Date
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"AmountFee")=1
		{  s PLISTI(5)=##class(web.DHCEQCommon).GetDataByName(Val,"AmountFee")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"ProviderDR")=1
		{  s PLISTI(6)=##class(web.DHCEQCommon).GetDataByName(Val,"ProviderDR")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"InvoiceTypeDR")=1
		{	s PLISTI(7)=##class(web.DHCEQCommon).GetDataByName(Val,"InvoiceTypeDR")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Customer")=1
		{	s PLISTI(8)=##class(web.DHCEQCommon).GetDataByName(Val,"Customer")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"InvoiceDept")=1
		{	s PLISTI(9)=##class(web.DHCEQCommon).GetDataByName(Val,"InvoiceDept")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"PayedAmountFee")=1
		{	s PLISTI(10)=##class(web.DHCEQCommon).GetDataByName(Val,"PayedAmountFee")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Status")=1
		{	s PLISTI(11)=##class(web.DHCEQCommon).GetDataByName(Val,"Status")}
		s PLISTI(12)=User			;SubmitUerDR
		s PLISTI(13)=Date			;SubmitDate
		s PLISTI(14)=Time			;SubmitTime
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Remark")=1
		{	s PLISTI(15)=##class(web.DHCEQCommon).GetDataByName(Val,"Remark")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"CertificateDR")=1
		{ s PLISTI(16)=##class(web.DHCEQCommon).GetDataByName(Val,"CertificateDR")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"InValidFlag")=1
		{
			s PLISTI(17)=##class(web.DHCEQCommon).GetDataByName(Val,"InValidFlag")
			s PLISTI(17)=##class(web.DHCEQCommon).TransValueFromPage(PLISTI(17),"bool")	;InValidFlag
		}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Hold1")=1
		{	s PLISTI(18)=##class(web.DHCEQCommon).GetDataByName(Val,"Hold1")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Hold2")=1
		{	s PLISTI(19)=##class(web.DHCEQCommon).GetDataByName(Val,"Hold2")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Hold3")=1
		{	s PLISTI(20)=##class(web.DHCEQCommon).GetDataByName(Val,"Hold3")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Hold4")=1
		{	s PLISTI(21)=##class(web.DHCEQCommon).GetDataByName(Val,"Hold4")}
		if ##class(web.DHCEQCommon).ExistsElement(Val,"Hold5")=1
		{	s PLISTI(22)=##class(web.DHCEQCommon).GetDataByName(Val,"Hold5")}
		if RowID=""
		{
			&SQL(insert into sqluser.DHC_EQInvoice values :PLISTI())
			s RowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQInvoice values :PLISTI() where IV_RowID=:RowID)
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	else
	{
		&SQL(update sqluser.DHC_EQInvoice Set IV_InvalidFlag='Y' where IV_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
 	TCOMMIT
 	q SQLCODE
ERRORInvoice
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORInvoice"_ErrorMsg   	 //返回错误消息 ;
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:查询与一个发票相关的所有入库明细
/// --------------------------------
Query GetInStockListByInvoice(RowID) As %Query(ROWSPEC = "TInStockListDR:%String,TInStockDR:%String,TEquipName:%String,TInStockNo:%String,TOriginalFee:%String,TQuantityNum:%String")
{
}

ClassMethod GetInStockListByInvoiceExecute(ByRef qHandle As %Binary, RowID) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	q:RowID=""
	s IUMRowID=0
	for  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Invoice",1,RowID,IUMRowID)) q:IUMRowID=""  d
	.d ResetVariablesGetInStockListByInvoice
	.s TInStockListDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",1)
	.i TInStockListDR'=""  d
	..s TInStockDR=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	..i TInStockDR'=""  s TInStockNo=$p($g(^DHCEQInStock(TInStockDR)),"^",14)
	..s TEquipName=$p($g(^DHCEQInStockList(TInStockListDR)),"^",5)
	..s TOriginalFee=$p($g(^DHCEQInStockList(TInStockListDR)),"^",7)
	..s TQuantityNum=$p($g(^DHCEQInStockList(TInStockListDR)),"^",8)
	..d OutputRowGetInStockListByInvoice
	Quit $$$OK
OutputRowGetInStockListByInvoice
	s Data=$lb(TInStockListDR,TInStockDR,TEquipName,TInStockNo,TOriginalFee,TQuantityNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockListByInvoice
	s (TInStockListDR,TInStockDR,TEquipName,TInStockNo,TOriginalFee,TQuantityNum)=""
	quit
}

ClassMethod GetInStockListByInvoiceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockListByInvoiceExecute ]
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

ClassMethod GetInStockListByInvoiceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockListByInvoiceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:没有添加发票信息的入库明细取发票金额为入库明细的总金额
/// --------------------------------
/// w ##Class(web.DHCEQInvoice).GetAmountFee(%request.Get("SourceType"),%request.Get("SourceID"))
ClassMethod GetAmountFee(SourceType, SourceID)
{
	new (SourceType,SourceID)
	q:SourceType="" ""
	q:SourceID="" ""
	s AmountFee=""
	if $Data(^DHCEQInvoiceUseMap(0,"Source",SourceType,SourceID))=0
	{
		if SourceType="1"
		{
			s OriginalFee=$p($g(^DHCEQInStockList(SourceID)),"^",7)
			s QuantityNum=$p($g(^DHCEQInStockList(SourceID)),"^",8)
			s AmountFee=OriginalFee*QuantityNum
		}
	}
	q AmountFee
}

/*
/// 创    建:ZY  2010-04-26  No.ZY0022
/// 描    述:根据发票号查询与当前发票相关联的入库明细有几条,一条时可以直接修改信息。
/// --------------------------------
/// w ##Class(web.DHCEQInvoice).CheckInvoiceNo("121","13453458","2610")
ClassMethod CheckInvoiceNo(InvoiceID, InvoiceNo, ProviderID)
{
	new Total,rowid,Num,Flag,IUMRowID,InvoiceDR,ProviderDR,InvalidFlag
	i InvoiceNo="" q ""
	s Flag=""
	s Total=0
	if InvoiceNo'=""  //查看发票号和发票ID是不是对的上
	{
		s (InvoiceDR,ProviderDR,InvalidFlag)=""
		s rowid=0
		f  s rowid=$o(^DHCEQInvoice(0,"InvoiceNo",InvoiceNo,rowid))  q:(rowid="")||(Total'=0)  d
		.s ProviderDR=$p($g(^DHCEQInvoice(rowid)),"^",5)	;IV_ProvderDR
		.q:(ProviderID'="")&(ProviderID'=ProviderDR)
		.s InvalidFlag=$p($g(^DHCEQInvoice(rowid)),"^",16) 	;IV_InvalidFlag
		.q:InvalidFlag="Y"
		.s Total=Total+1
		.s InvoiceDR=rowid
		if (Total=1)&(InvoiceID'=InvoiceDR)&(InvoiceID'="") q Flag		;发票号和发票ID对不上
		if (Total=1)&(InvoiceID="") q Flag		;新增的发票号和库中的发票号一样
		if (Total=0)&(InvoiceID'="") q 0		;发票号和发票ID对不上,直接新增发票
		if (Total=0)&(InvoiceID="") q 1			;发票号和发票ID对不上
	}
	if InvoiceID'=""  //检查当前发票被使用的次数
	{
		s Num=0
		s IUMRowID=0
		for  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Invoice",1,InvoiceID,IUMRowID)) q:IUMRowID=""  d
		.s Num=Num+1
		if Num=0||Num=1 s Flag=1	;没有使用或者一个单使用
		if Num>1 s Flag=-1			;多处使用
	}
	q Flag   //Flag=-1,是有多处使用发票记录,不能更新;;Flag=1,是没有发票记录或少于两个单使用;
}
*/
/// 入参：InvoiceID：发票ID
/// 		 InvoiceNo：发票号
/// 		 ProviderID：供应商
/// 		 CanEdit:发票是否有共用,共用时不可编辑
/// 	返回:0 正常 
/// 		其他 异常
/// 		 -1011:该发票号已经被使用,请选择发票
/// 		 -1012:发票信息与数据库中的发票信息不一致
/// w ##Class(web.DHCEQInvoice).CheckInvoiceNo(177,1111111,1,0)
ClassMethod CheckInvoiceNo(InvoiceID, InvoiceNo, ProviderID, CanEdit)
{
	n rowid,UseFlag
	i InvoiceNo="" q "0"
	
	;检查发票号是否有其他发票占用
	s rowid=0
	s UseFlag=0
	f  s rowid=$o(^DHCEQInvoice(0,"InvoiceNo",InvoiceNo,rowid))  q:(rowid="")||(UseFlag'=0)  d
	.q:(ProviderID'="")&(ProviderID'=$p($g(^DHCEQInvoice(rowid)),"^",5))	;IV_ProvderDR
	.q:$p($g(^DHCEQInvoice(rowid)),"^",16)="Y"		;IV_InvalidFlag
	.i InvoiceID'=rowid s UseFlag=1
	i UseFlag=1 q -1011
	
	;发票信息不可编辑时，核对发票信息是否与数据库中的发票信息一致
	if ((InvoiceID'="")&&(CanEdit=0))
	{
		if $p($g(^DHCEQInvoice(InvoiceID)),"^",2)'=InvoiceNo q -1012
	}
	q 0
}

/// modified by ZY0243 同仁的需求：入库增加发票数量显示,暂时用hold1
/// 取发票信息
/// w ##Class(web.DHCEQInvoice).GetInvoiceInfos(1,75)
ClassMethod GetInvoiceInfos(SourceType, SourceID)
{
	if SourceType="" q ""
	if SourceID="" q ""
	new IUMRowID,IVRowID
	new InvocieNo,Date,AmountFee,InvocieNos,Status
	s (InvocieNo,Date,AmountFee,InvocieNos)=""
	s IUMRowID=0
	for  s IUMRowID= $O(^DHCEQInvoiceUseMap(0,"Source",SourceType,SourceID,IUMRowID)) q:IUMRowID=""  d
	.i IUMRowID'="" d
	..s InvocieDR=$p($g(^DHCEQInvoiceUseMap(IUMRowID)),"^",2)
	..i InvocieDR'="" d
	...s Status=$p($g(^DHCEQInvoice(InvocieDR)),"^",10) 		//status
	...;q:Status'="0"										//新增
	...s InvocieNo=$p($g(^DHCEQInvoice(InvocieDR)),"^",2) 	//InvocieNo
	...s Date=$p($g(^DHCEQInvoice(InvocieDR)),"^",3) 		//Date
	...i Date'="" s Date=##class(web.DHCEQCommon).TransValueToPage(Date,"date")
	...s AmountFee=$p($g(^DHCEQInvoice(InvocieDR)),"^",4) 	//AmountFee
	...s Quantity=$p($g(^DHCEQInvoice(InvocieDR)),"^",17) 	//Hold1  
	...i InvocieNos'="" d
	....s InvocieNos=InvocieNos_"&"
	...s InvocieNos=InvocieNos_InvocieNo_"^"_Date_"^"_AmountFee_"^"_IUMRowID_"^"_InvocieDR_"^"_Quantity
	q InvocieNos
}

/// 获取该发票在其他单据中使用的次数
/// 入参：
/// 		SourceType：原单据类型
/// 		SourceID：原单据明细ID
/// 		InvoiceID：发票ID
/// 返回值：
/// 		Times:返回在SourceType，SourceID对应的单据外应用的次数。
/// 		      当传入的是付款记录时，判断如果有付款记录对应的入库明细与发票对照记录,不计入
ClassMethod InvoiceUsedTimes(SourceType, SourceID, InvoiceID)
{
	n Times,IUMRowID,ISLRowID,Flag
	if InvoiceID="" q "0^0"
	
	;付款记录时,记录付款记录对应的入库明细
	s ISLRowID=""
	s Flag=0
	if (SourceType="9")&(SourceID'="")
	{
		if ($p($g(^DHCEQPayRecord(SourceID)),"^",15)=1) s ISLRowID=$p($g(^DHCEQPayRecord(SourceID)),"^",16)
	}
	
	s Times=0
	s IUMRowID=0
	for  s IUMRowID= $O(^DHCEQInvoiceUseMap(0,"Invoice",InvoiceID,IUMRowID)) q:IUMRowID=""  d
	.q:(($p(^DHCEQInvoiceUseMap(IUMRowID),"^",1)=SourceID)&&($p(^DHCEQInvoiceUseMap(IUMRowID),"^",3)=SourceType))
	.i (SourceType="9")&(ISLRowID'="")  d
	..i ($p(^DHCEQInvoiceUseMap(IUMRowID),"^",3)=1)&&($p(^DHCEQInvoiceUseMap(IUMRowID),"^",1)=ISLRowID) s Flag=1
	.s Times=Times+1
	
	q Times_"^"_Flag
	q Times-Flag
}

/// 根据发票取凭证
/// w ##Class(web.DHCEQInvoice).GetCertiByInvoice()
ClassMethod GetCertiByInvoice(InvoiceDR)
{
	if InvoiceDR="" q ""
	q $p($g(^DHCEQInvoice(InvoiceDR)),"^",15)
}

Storage Default
{
<Data name="DHCEQInvoiceDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQInvoiceD</DataLocation>
<DefaultData>DHCEQInvoiceDefaultData</DefaultData>
<IdLocation>^web.DHCEQInvoiceD</IdLocation>
<IndexLocation>^web.DHCEQInvoiceI</IndexLocation>
<StreamLocation>^web.DHCEQInvoiceS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
