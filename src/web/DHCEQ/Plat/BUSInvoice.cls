Class web.DHCEQ.Plat.BUSInvoice Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// add by lmm 2019-09-19
/// desc:发票信息查询
/// input:InvoiceNo:发票号 ProvderDR:供应商id MinAmountFee:最小发票金额 MaxAmountFee:最大发票金额 
///       StartDate,EndDate:开票日期范围 InvoiceStr:发票id串 InStockListStr:关联入库明细id串 
///       ShowType:on 不包含 off 包含入库明细 RequestLocDR:管理科室
/// modified by csj 2020-02-11 标准版-设备入库发票补录程序修改，添加业务参数
/// --------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.BUSInvoice","GetInvoice")
Query GetInvoice(InvoiceNo As %String = "", ProvderDR As %String = "", MinAmountFee As %String = "", MaxAmountFee As %String = "", StartDate As %String = "", EndDate As %String = "", InvoiceStr As %String = "", InStockListStr As %String = "", ShowType As %String = "on", RequestLocDR As %String = "", BussType As %String = "") As %Query(ROWSPEC = "TNo:%String,TRowID:%String,TCode:%String,TDate:%String,TAmountFee:%String,TTypeDR:%String,TInvoiceType:%String,TCertificateDR:%String,TCertificateNo:%String,TProviderDR:%String,TProvider:%String,TCustomer:%String,TInvoiceDept:%String,TPayedAmountFee:%String,TStatus:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TMapFee:%String,TFlag:%String")
{
}

ClassMethod GetInvoiceExecute(ByRef qHandle As %Binary, InvoiceNo As %String = "", ProvderDR As %String = "", MinAmountFee As %String = "", MaxAmountFee As %String = "", StartDate As %String = "", EndDate As %String = "", InvoiceStr As %String = "", InStockListStr As %String = "", ShowType As %String = "on", RequestLocDR As %String = "", BussType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s InvoiceNo=$ZCONVERT(InvoiceNo,"U")
	
	i StartDate'="" s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")	
	i EndDate'="" s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")	
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set CurGroupID=%session.Get("LOGON.GROUPID")
	k ^DHCEQTemp("GetInvoice",curuser)
	s gnum=1
	
	d BuildDataGetInvoice
	Quit $$$OK
BuildDataGetInvoice
	s rowid=0
	f  s rowid=$o(^DHCEQInvoice(rowid)) q:rowid=""  d
	.d ResetVariablesGetInvoice
	.s TInvalidFlag=$p($g(^DHCEQInvoice(rowid)),"^",16)
	.q:TInvalidFlag="Y"
	.s TRowID=rowid
	.q:(InvoiceStr'="")&&((","_InvoiceStr_",")'[(","_TRowID_","))
	.i InStockListStr'="" s InInStockLists=##Class(web.DHCEQ.Plat.BUSInvoice).CheckInStockListMapIs(TRowID,InStockListStr,BussType) //modified by csj 2020-02-11 添加业务参数
	.q:(ShowType="off")&&(InStockListStr'="")&&(InInStockLists="")
	.q:(ShowType="on")&&(InStockListStr'="")&&(InInStockLists'="")
	.s TCode=$p($g(^DHCEQInvoice(rowid)),"^",1)
	.s TNo=$p($g(^DHCEQInvoice(rowid)),"^",2)
	.q:(InvoiceNo'="")&&($ZCONVERT(TNo,"U")'[InvoiceNo)
	.s TDate=$p($g(^DHCEQInvoice(rowid)),"^",3)
	.q:(StartDate'="")&&(StartDate>TDate)
	.q:(EndDate'="")&&(EndDate<TDate)
	.s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	.s TAmountFee=$p($g(^DHCEQInvoice(rowid)),"^",4)
	.s TAmountFee=##Class(web.DHCEQCommon).FormatNumber(TAmountFee,"")
	.q:(MinAmountFee'="")&&(MinAmountFee>TAmountFee)
	.q:(MaxAmountFee'="")&&(MaxAmountFee<TAmountFee)
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
	.s TPayedAmountFee=##Class(web.DHCEQCommon).FormatNumber(TPayedAmountFee,"")
  	.s TStatus=$p($g(^DHCEQInvoice(rowid)),"^",10)
  	.s TRemark=$p($g(^DHCEQInvoice(rowid)),"^",14)
  	.s THold1=$p($g(^DHCEQInvoice(rowid)),"^",17)
  	.;;;;q:(RequestLocDR'="")&&(RequestLocDR'=THold1)	// Mozy003005	1248957		2020-4-1
  	.s THold2=$p($g(^DHCEQInvoice(rowid)),"^",18)
  	.s THold3=$p($g(^DHCEQInvoice(rowid)),"^",19)
  	.s THold4=$p($g(^DHCEQInvoice(rowid)),"^",20)
  	.s THold5=$p($g(^DHCEQInvoice(rowid)),"^",21)
  	.s TMapFee=##Class(web.DHCEQ.Plat.BUSInvoice).GetMapInStockFee(rowid,BussType)	//modified by csj 2020-02-11 添加业务参数
	.d OutputRowGetInvoice
	quit
OutputRowGetInvoice
	s Data=$lb(TNo,TRowID,TCode,TDate,TAmountFee,TTypeDR,TInvoiceType,TCertificateDR,TCertificateNo,TProviderDR,TProvider,TCustomer,TInvoiceDept,TPayedAmountFee,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TMapFee,TFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s ^DHCEQTemp("GetInvoice",curuser,gnum)=TRowID_"^"_TAmountFee_"^"_TMapFee
	s gnum=gnum+1
	quit
ResetVariablesGetInvoice
	s (TNo,TRowID,TCode,TDate,TAmountFee,TTypeDR,TInvoiceType,TCertificateDR,TCertificateNo,TProviderDR,TProvider,TCustomer,TInvoiceDept,TPayedAmountFee,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TMapFee,TFlag)=""
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

/// ----------------------------------
/// add by lmm 2019-07-03
/// desc:新增、更新发票信息
/// modified by csj 2020-02-11 标准版-设备入库发票补录程序修改
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).SaveData("5^^^FP2019022201^^^1882^^^^^^^^^^^")
/// ----------------------------------
ClassMethod SaveData(val, ValList As %String = "", Type As %String = "")
{
	new RowID,User,Date,Time
	k PLIST
	Set $ZT="ERRORSave"
	s User=%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID = $p(val,"^",1)	;RowID
	
	s PLIST(2) = $p(val,"^",2)	;Code
	s PLIST(3) = $p(val,"^",3)	;No
	s PLIST(4) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",4),"date")	;FromDate	;Date
	s PLIST(5) = $p(val,"^",5)	;AmountFee
	s PLIST(6) = $p(val,"^",6)	;ProviderDR
	s PLIST(7) = $p(val,"^",7)	;TypeDR
	s PLIST(8) = $p(val,"^",8)	;Customer
	s PLIST(9) = $p(val,"^",9)	;InvoiceDept
	s PLIST(10) = $p(val,"^",10)	;PayedAmountFee
	s PLIST(11) = "1"	            ;Status	//modified by csj 2020-03-08 补录发票状态为提交
	s PLIST(12) = User          	;SubmitUserDR
	s PLIST(13) = Date	            ;SubmitDate
	s PLIST(14) = Time          	;SubmitTime
	s PLIST(15) = $p(val,"^",11)	;Remark
	s PLIST(16) = $p(val,"^",12)	;CertificateDR
	
	s PLIST(17) = "N"	            ;InvolidFlag
	s PLIST(18) = $p(val,"^",13)	;Hold1
	s PLIST(19) = $p(val,"^",14)	;Hold2
	s PLIST(20) = $p(val,"^",15)	;Hold3
	s PLIST(21) = $p(val,"^",16)	;Hold4
	s PLIST(22) = $p(val,"^",17)	;Hold5
	
		
	TSTART

	if RowID=""
	{
		&SQL(insert into sqluser.DHC_EQInvoice values :PLIST())
		s RowID=$G(%ROWID)
	}
	else
	{
		&SQL(update sqluser.DHC_EQInvoice values :PLIST() where IV_RowID=:RowID)

	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
		
		
	}
	//add by csj 20200107 同时更新配件入库明细发票
	s ValListLen=$l(ValList,",")
	f j=1:1:ValListLen  d
	.s SourceID=$p(ValList,",",j)
	.i Type="3" d	
	..s AInslInvoiceNos = $p(^DHCEQInvoice(RowID),"^",2)
	..s $p(^DHCEQAInStockList(SourceID),"^",19)=AInslInvoiceNos
		
 	TCOMMIT
 	q SQLCODE_"^"_RowID
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// add by lmm 2019-07-03
/// desc:获取单条发票信息
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).GetOneInvoice("1")
ClassMethod GetOneInvoice(RowID As %Library.String)
{
	new result
	s (result)=""
	s result= ^DHCEQInvoice(RowID)
	s result=result_"^"	;Provider			1
	i $p(result,"^",5)'=""  d
	.s result=result_##Class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",5))
	s result=result_"^"	;Date		1
	i $p(result,"^",3)'=""  d
	.s result=result_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"date")	
    s result=result_"^" ;Loc     
    i $p(result,"^",17)'=""  d      
    .s result=result_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",17))
    q result
}

/// add by lmm 2019-07-03
/// desc:入库明细查询
/// input:ISNo:入库单 LocDR:入库科室 StartDate,EndDate:入库审核日期范围 InvoiceNos:发票号串
///       MinPrice,MaxPrice:入库明细金额范围 ProviderDR:供应商id Name:设备名称 EquipTypeDR:类组id 
///       QXType:科室访问权限 InvoiceID:发票id ShowType:on展示 off不展示 InStockListStr:入库明细id串 HasInvoiceType:已关联发票标记
/// modified by csj 2020-03-08 添加发票状态过滤
/// Modify by zx 2020-09-09 Status改为Params,Params为拼串参数 Status^StartAuditDate^EndAuditDate
/// --------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.BUSInvoice","GetInStockDetail","","","","","","","","","","","","","off","2,7")
Query GetInStockDetail(ISNo, LocDR, StartDate, EndDate, InvoiceNos, MinPrice, MaxPrice, ProviderDR, Name, EquipTypeDR, QXType As %String = "", InvoiceID As %String = "", ShowType As %String = "on", InStockListStr As %String = "", HasInvoiceType As %String = "", Params As %String = "") As %Query(ROWSPEC = "TISRowID:%String,TProviderDR:%String,TProvider:%String,TInDate:%String,TISNo:%String,TLocDR:%String,TLoc:%String,TStatCatDR:%String,TStatCat:%String,TEquipTypeDR:%String,TEquipType:%String,TStatus:%String,TEquipName:%String,TModelDR:%String,TModel:%String,TOriginalFee:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TInvoice:%String,TTotalFee:%String,TEquipCat:%String,TUseYearsNum:%String,TISLRowID:%String,TRemark:%String,TBuyLoc:%String,TOrigin:%String") [ SqlProc ]
{
}

ClassMethod GetInStockDetailExecute(ByRef qHandle As %Binary, ISNo, LocDR, StartDate, EndDate, InvoiceNos, MinPrice, MaxPrice, ProviderDR, Name, EquipTypeDR, QXType As %String = "", InvoiceID As %String = "", ShowType As %String = "on", InStockListStr As %String = "", HasInvoiceType As %String = "", Params As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	//Modify by zx 2020-09-09 BUG ZX0108
 	s Status=$p(Params,"^",1)
 	s StartAuditDate=$p(Params,"^",2)
 	s EndAuditDate=$p(Params,"^",3)
 	s TJob=$p(Params,"^",4)  //Modify by zx 2020-12-11 BUG ZX0121 增加job传入
 	i TJob="" s TJob=$Job   //add by lmm 2021-01-27 1749575
 	
 	i StartDate="" s StartDate=0
 	e  s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")	//add by csj 2020-03-18
 	i EndDate="" s EndDate=+$H
 	e  s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")	//add by csj 2020-03-18
 	//Modify by zx 2020-09-09 BUG ZX0108
 	i StartAuditDate="" s StartAuditDate=0
 	e  s StartAuditDate=##Class(web.DHCEQCommon).TransValueFromPage(StartAuditDate,"date")
 	i EndAuditDate="" s EndAuditDate=+$H
 	e  s EndAuditDate=##Class(web.DHCEQCommon).TransValueFromPage(EndAuditDate,"date")
	s InvoiceNos=$ZCONVERT(InvoiceNos,"U")
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	//s Job=$j  //Modify by zx 2020-12-11 BUG ZX0121  job需要无效掉
	k ^DHCEQTemp("GetInStockDetail",curuser)
	//Modify by zx 2020-12-11 BUG ZX0121 临时globla调整
	Do ##Class(web.DHCEQCommon).KillTempGlobal("InStockDetailInvoice")
	k ^DHCEQTemp("InStockDetailPrint",curuser)   //MZY0104	2300670		2021-12-08 添加打印临时global
	
	s gnum=1
	d BuildDataGetInStockDetail
	Quit $$$OK
BuildDataGetInStockDetail
	s ISRowID=0
	f  s ISRowID=$o(^DHCEQInStock(ISRowID))  quit:ISRowID=""  d
	.s TInvalidFlag=$p(^DHCEQInStock(ISRowID),"^",25) 	//add by csj 20200111
	.q:TInvalidFlag="Y"
	.s TInDate=$p($g(^DHCEQInStock(ISRowID)),"^",13)
	.q:(TInDate>EndDate)||(TInDate<StartDate)
	.s TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	.s TLocDR=$p(^DHCEQInStock(ISRowID),"^",2)
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR))) //2010-10-26 DJ
	.i TLocDR'="" s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TStatusDR=$p(^DHCEQInStock(ISRowID),"^",10)
	.q:(TStatusDR'=2)
	.s TISNo=$p(^DHCEQInStock(ISRowID),"^",14)
	.q:TISNo=""		
	.q:(ISNo'="")&&(TISNo'[ISNo)
	.s TProviderDR=$p(^DHCEQInStock(ISRowID),"^",17)
	.q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	.s TEquipTypeDR=$p($g(^DHCEQInStock(ISRowID)),"^",20)
	.q:(EquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)
	.q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
	.s rowid=0
	.f  s rowid=$o(^DHCEQInStockList(0,"InStock",ISRowID,rowid))  quit:rowid=""  d
	..d ResetVariablesGetInStockDetail
	..q:(ShowType="off")&&(InStockListStr'="")&&((","_InStockListStr_",")'[(","_rowid_","))
	..s TEquipName=$p(^DHCEQInStockList(rowid),"^",5)
	..q:(Name'="")&&(TEquipName'[Name)
	..s TPrice=$p(^DHCEQInStockList(rowid),"^",7)
	..s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"")
	..q:(MinPrice="")&&(MaxPrice'="")&&(TPrice>MaxPrice)
	..q:(MinPrice'="")&&(MaxPrice="")&&(TPrice<MinPrice)
	..q:(MinPrice'="")&&(MaxPrice'="")&&((TPrice<MinPrice)||(TPrice>MaxPrice))
	..q:(ShowType="off")&&(InvoiceID="")&&(InStockListStr="")
	..i InvoiceID'="" s TIninvoice=##Class(web.DHCEQ.Plat.BUSInvoice).CheckInvoiceMapIs(InvoiceID,rowid)
	..q:(ShowType="off")&&(InvoiceID'="")&&(TIninvoice="")
	..q:(ShowType="on")&&(InvoiceID'="")&&(TIninvoice'="")
	..q:(HasInvoiceType="1")&&($Data(^DHCEQInvoiceUseMap(0,"Source",1,rowid))=0)
	..q:(HasInvoiceType="2")&&($Data(^DHCEQInvoiceUseMap(0,"Source",1,rowid))'=0)
	..d GetOneInStockDetail
	quit
GetOneInStockDetail
	s TISRowID=ISRowID
	s TISLRowID=rowid
	s TInDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(TISRowID)),"^",13),"date") //modified by csj 2020-10-29 需求号：1559930
	;s TLoc=$p($g(^CTLOC($p(^DHCEQInStock(ISRowID),"^",2))),"^",2)   //modify by jyp 2019-10-18 CTLOC调整
	s TLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(^DHCEQInStock(ISRowID),"^",2))   //modify by jyp 2019-10-18 CTLOC调整
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
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	s TQuantityNum=$p(^DHCEQInStockList(rowid),"^",8)
	s TTotalFee=TOriginalFee*TQuantityNum
	s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"")
	s TEquipCatDR=$p(^DHCEQInStockList(rowid),"^",14)
	i TEquipCatDR'="" s TEquipCat=$P(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR),"^",2)
	s TUnitDR=$p(^DHCEQInStockList(rowid),"^",10)
	i TUnitDR'="" s TUnit=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	//Modify by zx 2020-09-10 BUG ZX0108
	s TRemark=$p(^DHCEQInStockList(rowid),"^",12)
	//发票信息
	s StrInvoice=""
	s FirstInvoice=""
	s Num=0
	s Amount=0
	s IUMRowID=0
	s pass=1	//add by csj 2020-03-04
	f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","1",rowid,IUMRowID)) q:(IUMRowID="")||(pass'=1)  d
	.s InvoiceDR=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
	.i InvoiceDR'="" d
	..s InvalidFlag=$P(^DHCEQInvoice(InvoiceDR),"^",16)
	..q:InvalidFlag="Y"
	..s TInvoiceStatus=$P(^DHCEQInvoice(InvoiceDR),"^",10)	//add by csj 2020-03-04 发票状态过滤
	..i (Status'="")&&(Status'[TInvoiceStatus) s pass=0
	..//Modify by zx 2020-09-09 BUG ZX0108
	..s TAuditDate=+$P(^DHCEQInvoice(InvoiceDR),"^",19)
	..i (TAuditDate<StartAuditDate)||(TAuditDate>EndAuditDate) s pass=0
	..s Invoice=$P(^DHCEQInvoice(InvoiceDR),"^",2)
	..s InvoiceFee=$P(^DHCEQInvoice(InvoiceDR),"^",4)
	..s Amount=Amount+InvoiceFee
	..i Num=0 s FirstInvoice=Invoice
	..s Num=Num+1
	..i StrInvoice'="" s StrInvoice=StrInvoice_","_$ZCONVERT(Invoice,"U")
	..e  s StrInvoice=$ZCONVERT(Invoice,"U")
	q:(Status'="")&&((pass'=1)||(("1,2"[Status)&&(StrInvoice="")))	//add by csj 2020-03-04 发票状态过滤
	//发票号
	q:((","_StrInvoice_",")'[(","_InvoiceNos_","))&(InvoiceNos'="")
	i InvoiceNos'=""  s FirstInvoice=InvoiceNos
	s TInvoice=FirstInvoice
	s TInvoice=StrInvoice
	;i (FirstInvoice'="")&(Num>1) s TInvoice=FirstInvoice_"..."
	//支付信息
	s Flag=0
	s Amount=0
	s IUMRowID=0
	f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","1",rowid,IUMRowID)) q:(IUMRowID="")||(Flag=1)  d
	.s InvoiceDR=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
	.i InvoiceDR'="" d
	..s InvalidFlag=$P(^DHCEQInvoice(InvoiceDR),"^",16)
	..q:InvalidFlag="Y"
	..q:Flag=1
	..s TotlaPayFee=0
	..s PRRowID=0
	..for  s PRRowID=$o(^DHCEQPayRecord(0,"Invoice",InvoiceDR,PRRowID)) q:PRRowID=""  d
	...s PayFee=$P(^DHCEQPayRecord(PRRowID),"^",3)
	...s TotlaPayFee=TotlaPayFee+PayFee
	q:Flag=1
	//Modify by zx 2020-12-10 BUG ZX0122 增加来源
	s TOriginDR=$p($g(^DHCEQInStock(ISRowID)),"^",15)
	i TOriginDR'="" s TOrigin=##class(web.DHCEQCommon).GetTrakNameByID("origin",TOriginDR)
	//Modify by zx 2020-12-10 BUG ZX0122 增加采购部门
	s TBuyLocDR=$p($g(^DHCEQInStock(ISRowID)),"^",18)
	i TBuyLocDR'="" s TBuyLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TBuyLocDR)
	
	d OutputRowGetInStockDetail
	quit
OutputRowGetInStockDetail
	s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISLRowID,TRemark,TBuyLoc,TOrigin)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s ^DHCEQTemp("GetInStockDetail",curuser,gnum)=TISRowID_"^"_TQuantityNum_"^"_TTotalFee
	//Modify by zx 2020-12-11 BUG ZX0121 临时globla调整
	s ^DHCEQTemp("InStockDetailInvoice",+$H,TJob,gnum)=TISRowID_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLoc_"^"_TStatCat_"^"_TEquipType_"^"_TISLRowID_"^"_TEquipName_"^"_TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TInvoice_"^"_TRemark_"^"_TBuyLoc_"^"_TOrigin
	s ^DHCEQTemp("InStockDetailPrint",curuser,gnum)=TISRowID_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLoc_"^"_TStatCat_"^"_TEquipType_"^"_TISLRowID_"^"_TEquipName_"^"_TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TInvoice_"^"_TRemark_"^"_TBuyLoc_"^"_TOrigin	;MZY0104	2300670		2021-12-08
	s gnum=gnum+1
	
	quit
ResetVariablesGetInStockDetail
	s (TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISLRowID,TRemark,TOriginDR,TOrigin,TBuyLocDR,TBuyLoc)=""
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

/// add by csj 2020-02-11 标准版-配件入库添加发票补录功能
/// desc:配件入库明细查询
/// input:ISNo:入库单 LocDR:入库科室 StartDate,EndDate:入库审核日期范围 InvoiceNos:发票号串
///       MinPrice,MaxPrice:入库明细金额范围 ProviderDR:供应商id Name:设备名称 EquipTypeDR:类组id 
///       QXType:科室访问权限 InvoiceID:发票id ShowType:on展示 off不展示 InStockListStr:入库明细id串 HasInvoiceType:已关联发票标记
/// Modify by zx 2020-09-09 Status改为Params,Params为拼串参数 Status^StartAuditDate^EndAuditDate
/// Modify by mwz MWZ0047 2021-04-23 出参增加TBuyLoc
/// --------------------------------
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.BUSInvoice","GetAInStockDetail","","","","","","","","","","","","0,1")
Query GetAInStockDetail(ISNo As %String = "", LocDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvoiceNos As %String = "", MinPrice As %String = "", MaxPrice As %String = "", ProviderDR As %String = "", Name As %String = "", AccessoryTypeDR As %String = "", QXType As %String = "", InStockListStr As %String = "", Params As %String = "", HasInvoiceType As %String = "") As %Query(ROWSPEC = "TISRowID:%String,TProviderDR:%String,TProvider:%String,TInDate:%String,TISNo:%String,TLocDR:%String,TLoc:%String,TStatCatDR:%String,TStatCat:%String,TEquipTypeDR:%String,TEquipType:%String,TStatus:%String,TEquipName:%String,TModelDR:%String,TModel:%String,TOriginalFee:%String,TQuantityNum:%String,TUnitDR:%String,TUnit:%String,TInvoice:%String,TTotalFee:%String,TEquipCat:%String,TUseYearsNum:%String,TISLRowID:%String,TRemark:%String,TBuyLoc:%String")
{
}

ClassMethod GetAInStockDetailExecute(ByRef qHandle As %Binary, ISNo As %String = "", LocDR As %String = "", StartDate As %String = "", EndDate As %String = "", InvoiceNos As %String = "", MinPrice As %String = "", MaxPrice As %String = "", ProviderDR As %String = "", Name As %String = "", AccessoryTypeDR As %String = "", QXType As %String = "", InStockListStr As %String = "", Params As %String = "", HasInvoiceType As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
 	//Modify by zx 2020-09-09 BUG ZX0108
 	s Status=$p(Params,"^",1)
 	s StartAuditDate=$p(Params,"^",2)
 	s EndAuditDate=$p(Params,"^",3)
 	//add by mwz 20230420 MWZ0070 BEGIN
 	s TJob=$p(Params,"^",4)  
 	i TJob="" s TJob=$Job 
	s gnum=1
	//add by mwz 20230420 MWZ0070 END
 	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
 	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	//Modify by zx 2020-09-09 BUG ZX0108
 	i StartAuditDate="" s StartAuditDate=0
 	e  s StartAuditDate=##Class(web.DHCEQCommon).TransValueFromPage(StartAuditDate,"date")
 	i EndAuditDate="" s EndAuditDate=+$H
 	e  s EndAuditDate=##Class(web.DHCEQCommon).TransValueFromPage(EndAuditDate,"date")
	s InvoiceNos=$ZCONVERT(InvoiceNos,"U")
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	d BuildDataGetAInStockDetail
	Quit $$$OK
BuildDataGetAInStockDetail
	s ISRowID=0
	f  s ISRowID=$o(^DHCEQAInStock(ISRowID))  quit:ISRowID=""  d
	.s TInvalidFlag=$p(^DHCEQAInStock(ISRowID),"^",27) 	//add by csj 20200111
	.q:TInvalidFlag="Y"
	.s TLocDR=$p(^DHCEQAInStock(ISRowID),"^",3)
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	.s TStatusDR=$p(^DHCEQAInStock(ISRowID),"^",16)
	.q:(TStatusDR'=2)
	.s TInDate=$p($g(^DHCEQAInStock(ISRowID)),"^",1)
	.q:(StartDate'="")&&(TInDate<StartDate)
	.q:(EndDate'="")&&(TInDate>EndDate)
	.s TAccessoryTypeDR=$p($g(^DHCEQAInStock(ISRowID)),"^",2)
	.q:(AccessoryTypeDR'="")&&(TAccessoryTypeDR'=AccessoryTypeDR)
	.q:(##Class(web.DHCEQACommon).AccessoryTypeIsIn(TAccessoryTypeDR))
	.s rowid=0
	.f  s rowid=$o(^DHCEQAInStockList(0,"AInStock",ISRowID,rowid))  quit:rowid=""  d
	..s TPrice=$p(^DHCEQAInStockList(rowid),"^",8)
	..q:(MaxPrice'="")&&(TPrice>MaxPrice)
	..q:(MinPrice'="")&&(TPrice<MinPrice)
	..q:(HasInvoiceType="1")&&($Data(^DHCEQInvoiceUseMap(0,"Source",1,rowid))'=0)
	..q:(HasInvoiceType="2")&&($Data(^DHCEQInvoiceUseMap(0,"Source",1,rowid))=0)
	..d GetOneAInStockDetail	
	quit
GetOneAInStockDetail
	d ResetVariablesGetInStockDetail
	q:(InStockListStr'="")&&((","_InStockListStr_",")'[(","_rowid_","))
	s TISRowID=ISRowID
	s TISLRowID=rowid
	;q:##class(web.DHCEQCommon).FundsTypeIsIn(10,rowid)	// Mozy0231	访问资金来源类型
	s TProviderDR=$p($g(^DHCEQAInStock(TISRowID)),"^",8)
	q:(ProviderDR'="")&(TProviderDR'=ProviderDR)
	s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TInDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStock(TISRowID)),"^",1),"date")
	s TISNo=$p($g(^DHCEQAInStock(TISRowID)),"^",6) //入库单号
	q:(ISNo'="")&&(TISNo'[ISNo)
	s TLocDR=$p(^DHCEQAInStock(TISRowID),"^",3)
	s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	s TAccessoryTypeDR=$p($g(^DHCEQAInStock(TISRowID)),"^",2)
	q:(AccessoryTypeDR'="")&&(TAccessoryTypeDR'=AccessoryTypeDR)
	i TAccessoryTypeDR '=""  d
	.s TAccessoryType = $p($g(^DHCEQCCode("DHCEQCAccessoryType",TAccessoryTypeDR)),"^",2)
	.s TEquipTypeDR=TAccessoryTypeDR
	.s TEquipType = TAccessoryType
	s TStatus=+$p($g(^DHCEQAInStock(TISRowID)),"^",16)
	q:TStatus>2
	s TAccessory=$ZCONVERT($p(^DHCEQAInStockList(rowid),"^",4),"U") //配件名称
	q:(Name'="")&(TAccessory'[Name)
	s TEquipName=TAccessory
	//add by mwz MWZ0047 2021-04-23 begin
	s TBuyLocDR=$p($g(^DHCEQAInStock(TISRowID)),"^",10) 
	s TBuyLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBuyLocDR)
	//add by mwz MWZ0047 2021-04-23 end
	;s TInvoice=$p(^DHCEQAInStockList(rowid),"^",19) //发票号信息 modify BY：GBX 2014-8-20 10:18:57
	;q:(ChkNoInvoice="Y")&&(TInvoice'="")
	;q:(InvoiceNos'="")&&(TInvoice'[InvoiceNos)
	s TModel=$p(^DHCEQAInStockList(rowid),"^",5)
	s TPrice=$p(^DHCEQAInStockList(rowid),"^",8)
	s TQuantityNum=$p(^DHCEQAInStockList(rowid),"^",9)
	//Modify by zx 2020-09-10 BUG ZX0108
	s TRemark=$p(^DHCEQAInStockList(rowid),"^",20)
	s TTotalFee=TPrice*TQuantityNum
	
	//格式化金额为小数点两位
	i TQuantityNum'="" s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)	//Mozy	2017-2-2
	i TPrice'="" d
	.s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"",4)
	.s TOriginalFee = TPrice
	i TTotalFee'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TTotalFee,"",4)
	i TStatus'=0  d
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("10",TISRowID)
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5)
	s TStatus=##Class(web.DHCEQAInStock).GetAInStockStatusList(TStatus)
	//发票信息
	s StrInvoice=""
	s FirstInvoice=""
	s Num=0
	s Amount=0
	s IUMRowID=0
	s pass=1
	f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","3",rowid,IUMRowID)) q:(IUMRowID="")||(pass'=1)  d
	.s InvoiceDR=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
	.i InvoiceDR'="" d
	..s InvalidFlag=$P(^DHCEQInvoice(InvoiceDR),"^",16)
	..q:InvalidFlag="Y"
	..s TInvoiceStatus=$P(^DHCEQInvoice(InvoiceDR),"^",10)	//add by csj 20200102发票状态
	..i (Status'="")&&(Status'[TInvoiceStatus) s pass=0
	..//Modify by zx 2020-09-09 BUG ZX0108
	..s TAuditDate=+$P(^DHCEQInvoice(InvoiceDR),"^",19)
	..i (TAuditDate<StartAuditDate)||(TAuditDate>EndAuditDate) s pass=0
	..s Invoice=$P(^DHCEQInvoice(InvoiceDR),"^",2)
	..s InvoiceFee=$P(^DHCEQInvoice(InvoiceDR),"^",4)
	..s Amount=Amount+InvoiceFee
	..i Num=0 s FirstInvoice=Invoice
	..s Num=Num+1
	..i StrInvoice'="" s StrInvoice=StrInvoice_","_$ZCONVERT(Invoice,"U")
	..e  s StrInvoice=$ZCONVERT(Invoice,"U")
	q:(Status'="")&&((pass'=1)||((Status=1)&&(StrInvoice="")))
	q:((Status=2)&&(StrInvoice=""))
	//发票号
	q:((","_StrInvoice_",")'[(","_InvoiceNos_","))&(InvoiceNos'="")
	i InvoiceNos'=""  s FirstInvoice=InvoiceNos
	s TInvoice=FirstInvoice
	s TInvoice=StrInvoice
	;i (FirstInvoice'="")&(Num>1) s TInvoice=FirstInvoice_"..."
	//支付信息
	s Flag=0
	s Amount=0
	s IUMRowID=0
	f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","3",rowid,IUMRowID)) q:(IUMRowID="")||(Flag=1)  d
	.s InvoiceDR=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
	.i InvoiceDR'="" d
	..s InvalidFlag=$P(^DHCEQInvoice(InvoiceDR),"^",16)
	..q:InvalidFlag="Y"
	..q:Flag=1
	..s TotlaPayFee=0
	..s PRRowID=0
	..for  s PRRowID=$o(^DHCEQPayRecord(0,"Invoice",InvoiceDR,PRRowID)) q:PRRowID=""  d
	...s PayFee=$P(^DHCEQPayRecord(PRRowID),"^",3)
	...s TotlaPayFee=TotlaPayFee+PayFee
	q:Flag=1
	
	d OutputRowGetAInStockDetail
	quit

OutputRowGetAInStockDetail
	s Data=$lb(TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISLRowID,TRemark,TBuyLoc)
	s ^DHCEQTemp("InStockDetailInvoice",+$H,TJob,gnum)=TISRowID_"^"_TProvider_"^"_TInDate_"^"_TISNo_"^"_TLoc_"^"_TStatCat_"^"_TEquipType_"^"_TISLRowID_"^"_TEquipName_"^"_TModel_"^"_TUnit_"^"_TQuantityNum_"^"_TOriginalFee_"^"_TTotalFee_"^"_TEquipCat_"^"_TUseYearsNum_"^"_TInvoice_"^"_TRemark_"^"_TBuyLoc_"^" //add by mwz 20230420 MWZ0070
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s gnum=gnum+1  //add by mwz 20230420 MWZ0070
	
	quit
ResetVariablesGetAInStockDetail
	s (TISRowID,TProviderDR,TProvider,TInDate,TISNo,TLocDR,TLoc,TStatCatDR,TStatCat,TEquipTypeDR,TEquipType,TStatus,TEquipName,TModelDR,TModel,TOriginalFee,TQuantityNum,TUnitDR,TUnit,TInvoice,TTotalFee,TEquipCat,TUseYearsNum,TISLRowID,TRemark,TBuyLoc)=""
	quit
}

ClassMethod GetAInStockDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAInStockDetailExecute ]
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

ClassMethod GetAInStockDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAInStockDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by lmm 2019-07-22
/// desc:发票与入库明细关联
/// input:InvoiceStr:发票id串 ValList:入库明细id串 Type:关联类型 0：验收单  1：入库明细
/// output:SQLCODE
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).InvoiceMapBuss("5","8,9")
ClassMethod InvoiceMapBuss(InvoiceStr As %String = "", ValList As %String = "", Type As %String = "")
{
	
	i InvoiceStr="" q 0
	new flag
	s flag=0
	s InvoiceLen=$l(InvoiceStr,",")
	f i=1:1:InvoiceLen  d
	.s InvoiceDR=$p(InvoiceStr,",",i)
	.s ValListLen=$l(ValList,",")
	.f j=1:1:ValListLen  d
	..s SourceID=$p(ValList,",",j)
	..s iumrowid=""
	..&SQL(Select IUM_RowID into :iumrowid from SQLUSER.DHC_EQInvoiceUseMap where IUM_InvoiceDR=:InvoiceDR and IUM_Type=:Type and IUM_SourceID=:SourceID)
	..q:(iumrowid'="")
	..s PLISTIUM(3)=InvoiceDR
	..s PLISTIUM(2)=SourceID
	..i Type="3" d	//add by csj 20200107 同时更新配件入库明细发票
	...s AInslInvoiceNos = $p(^DHCEQInvoice(InvoiceDR),"^",2)
	...s $p(^DHCEQAInStockList(SourceID),"^",19)=AInslInvoiceNos
	..s PLISTIUM(4)=Type
	..&SQL(insert into sqluser.DHC_EQInvoiceUseMap values :PLISTIUM())		
	..i SQLCODE s flag=SQLCODE
				
	q flag
}

/// add by lmm 2019-07-22
/// desc:发票与入库明细解除关联
/// input:InvoiceStr:发票id串 ValList:入库明细id串 Type:关联类型 0：验收单  1：入库明细
/// output:SQLCODE
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).CancelInvoiceMapBuss("1")
ClassMethod CancelInvoiceMapBuss(InvoiceStr As %String = "", ValList As %String = "", Type As %String = "")
{
	i InvoiceStr="" q 0
	new flag
	s flag=0
	s InvoiceLen=$l(InvoiceStr,",")
	f i=1:1:InvoiceLen  d
	.s InvoiceDR=$p(InvoiceStr,",",i)
	.s ValListLen=$l(ValList,",")
	.f j=1:1:ValListLen  d
	..s SourceID=$p(ValList,",",j)
	..s iumrowid=""
	..&SQL(Select IUM_RowID into :iumrowid from SQLUSER.DHC_EQInvoiceUseMap where IUM_InvoiceDR=:InvoiceDR and IUM_Type=:Type and IUM_SourceID=:SourceID)
	..q:(iumrowid="")
	..&SQL(delete from sqluser.DHC_EQInvoiceUseMap where IUM_RowID=:iumrowid)	
	..i SQLCODE s flag=SQLCODE
			
	q flag
}

/// add by lmm 2019-07-22
/// desc:发票与入库明细解除关联
/// input:InvoiceStr:发票id串 Type:关联类型 0：验收单  1：入库明细
/// output:SQLCODE
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).CancelInvoiceMapBuss("1")
ClassMethod CancelAllInvoiceMapBuss(InvoiceStr As %String = "", Type As %String = "")
{
	i InvoiceStr="" q 0
	new flag
	s flag=0
	s InvoiceLen=$l(InvoiceStr,",")
	f i=1:1:InvoiceLen  d
	.s InvoiceDR=$p(InvoiceStr,",",i)
	.s iumrowid=""
	.&SQL(Select IUM_RowID into :iumrowid from SQLUSER.DHC_EQInvoiceUseMap where IUM_InvoiceDR=:InvoiceDR and IUM_Type=:Type)
	.q:(iumrowid="")
	.&SQL(delete from sqluser.DHC_EQInvoiceUseMap where IUM_InvoiceDR=:InvoiceDR and IUM_Type=:Type)	
	.i SQLCODE s flag=SQLCODE
			
	q flag
}

/// add by lmm 2019-09-06
/// desc:发票无效
/// input:InvoiceDR:发票id
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).DeleteInvoice("1")
ClassMethod DeleteInvoice(InvoiceDR)
{
	i InvoiceDR="" q 0
	&SQL(Update SQLUSER.DHC_EQInvoice Set IV_InvalidFlag='Y' where IV_RowID=:InvoiceDR)
			
	q SQLCODE_"^"_InvoiceDR
}

/// add by lmm 2019-09-06
/// desc:检测入参发票串中与入库明细相关联发票
/// input:InvoiceStr:发票id串 InStockListID:入库明细id
/// output:voiceids:已关联发票id
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).CheckInvoiceMapIs("1,2,3,4,5,6","1")
ClassMethod CheckInvoiceMapIs(InvoiceStr, InStockListID)
{
	i (InvoiceStr="")||(InStockListID="") q ""
	s voiceids=""
	s Len=$l(InvoiceStr,",")
	f i=1:1:Len  d
	.s Invoiceid=$p(InvoiceStr,",",i)
	.i ($Data(^DHCEQInvoiceUseMap(0,"SourceInvoice",1,Invoiceid,InStockListID)))  d
	..i voiceids=""  d
	...s voiceids=Invoiceid
	..e  d
	...s voiceids=voiceids_","_Invoiceid
			
	q voiceids
}

/// add by lmm 2019-09-06
/// desc:检测入库明细串中与发票相关联的具体明细
/// input:InvoiceDR:发票id InStockListStr:入库明细id串
/// output:instocklistids:已关联入库明细id
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).CheckInStockListMapIs("1","1,2,3,4,5,6")
ClassMethod CheckInStockListMapIs(InvoiceDR, InStockListStr, BusType As %String = "")
{
	i (InvoiceDR="")||(InStockListStr="") q ""
	s instocklistids=""
	s Len=$l(InStockListStr,",")
	f i=1:1:Len  d
	.s InStockListID=$p(InStockListStr,",",i)
	.i ($Data(^DHCEQInvoiceUseMap(0,"SourceInvoice",BusType,InvoiceDR,InStockListID)))  d	;modified by csj 20200106 添加配件业务参数
	..i instocklistids=""  d
	...s instocklistids=InStockListID
	..e  d
	...s instocklistids=instocklistids_","_InStockListID
			
	q instocklistids
}

/// add by lmm 2019-09-06
/// desc:检测入参是否已关联入库明细
/// input:InvoiceDR:发票id 
/// output:0 未关联 1 已关联
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).CheckInvoiceUseMap("1")
ClassMethod CheckInvoiceUseMap(InvoiceDR)
{
	i (InvoiceDR="") q ""
	s flag="0"
	i ($Data(^DHCEQInvoiceUseMap(0,"SourceInvoice",1,InvoiceDR)))  s flag=1
			
	q flag
}

/// add by lmm 2019-09-06
/// desc:检测所有与发票关联入库明细
/// input:InvoiceDR:发票id InStockListStr:入库明细id串 Type:关联type 0验收单 1入库明细
/// output:InStockNos:入库单号
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).GetInStockStrByInv("42","1","8,9")
ClassMethod GetInStockStrByInv(InvoiceDR, Type, InStockListStr)
{
	i (InvoiceDR="")||(Type="") q ""
	s InStockNos=""
	s InStocklistID=0
	f  s InStocklistID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice",Type,InvoiceDR,InStocklistID)) q:(InStocklistID="")  d
	.q:((","_InStockListStr_",")[(","_InStocklistID_","))
	.s TInStockDR=$p($g(^DHCEQInStockList(InStocklistID)),"^",1)
	.s TInStockNo=""
	.i TInStockDR'="" s TInStockNo=$p($g(^DHCEQInStock(TInStockDR)),"^",14)
	.i InStockNos="" d
	..s InStockNos=TInStockNo
	.e  i ((","_InStockNos_",")'[(","_TInStockNo_","))  d
	..s InStockNos=InStockNos_","_TInStockNo
	s len=$l(InStockNos,",")

	;i len>1 s InStockNos=$p(InStockNos,",",1,2)_".."
			
	q InStockNos
}

/// add by lmm 2019-09-06
/// desc:发票已关联明细金额总和
/// input:InvoiceDR:发票id Type:关联type 0验收单 1入库明细
/// output:TotalFee:总金额
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).GetMapInStockFee("12","1")
ClassMethod GetMapInStockFee(InvoiceDR, Type As %String = "")
{
	i (InvoiceDR="") q 0
	s TotalFee=0
	;add by csj 20200106 添加配件业务参数
	i ((Type="1")&&($Data(^DHCEQInvoiceUseMap(0,"SourceInvoice",Type,InvoiceDR))))
	{
		s InStocklistID=0
		f  s InStocklistID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice",Type,InvoiceDR,InStocklistID)) q:(InStocklistID="")  d
		.s TISOriginalFee=$p(^DHCEQInStockList(InStocklistID),"^",7)
		.s TISQuantityNum=$p(^DHCEQInStockList(InStocklistID),"^",8)
		.s TISTotalFee=TISOriginalFee*TISQuantityNum
		.s TotalFee=TotalFee+TISTotalFee
		.s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
	}
	i ((Type="3")&&($Data(^DHCEQInvoiceUseMap(0,"SourceInvoice",Type,InvoiceDR))))
	{
		s InStocklistID=0
		f  s InStocklistID=$o(^DHCEQInvoiceUseMap(0,"SourceInvoice",Type,InvoiceDR,InStocklistID)) q:(InStocklistID="")  d
		.s TISOriginalFee=$p(^DHCEQAInStockList(InStocklistID),"^",8)
		.s TISQuantityNum=$p(^DHCEQAInStockList(InStocklistID),"^",9)
		.s TISTotalFee=TISOriginalFee*TISQuantityNum
		.s TotalFee=TotalFee+TISTotalFee
		.s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
	}
			
	q TotalFee
}

/// add by lmm 2019-09-06
/// desc:入库明细合计信息
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).GetEquipSumInfo()
ClassMethod GetInStockSumInfo(node As %Library.String = "")
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s info=""
	s (Count,TotalFee)=0
	s nrowid=0
	f  s nrowid=$o(^DHCEQTemp("GetInStockDetail",curuser,nrowid)) q:nrowid=""  d
	.s TotalFee=TotalFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("GetInStockDetail",curuser,nrowid)),"^",3),"")
	.s Count=Count+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("GetInStockDetail",curuser,nrowid)),"^",2),"")
  	s info="总数量:"_Count_"&nbsp;&nbsp;&nbsp;总金额:"_TotalFee_"元"   
  	q info
}

/// add by lmm 2019-09-06
/// desc:入库明细合计信息
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).GetEquipSumInfo()
ClassMethod GetInvoiceSumInfo(node As %Library.String = "", ShowFlag As %Library.String = "")
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s info=""
	s (InvoiceFee,TotalFee)=0
	s nrowid=0
	f  s nrowid=$o(^DHCEQTemp("GetInvoice",curuser,nrowid)) q:nrowid=""  d
	.s InvoiceFee=InvoiceFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("GetInvoice",curuser,nrowid)),"^",2),"")
	.s TotalFee=TotalFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQTemp("GetInvoice",curuser,nrowid)),"^",3),"")
  	s info="入库明细金额:"_TotalFee_"元" 
  	i ShowFlag="on"  s info="入库明细金额:"_TotalFee_"元&nbsp;&nbsp;&nbsp;发票金额:"_InvoiceFee_"元" 
  	q info
}

/// add by csj 2020-03-04 发票审核
/// modified by csj 2020-07-20 改为SQL更新发票状态及相关bug处理 需求号：1430703
ClassMethod AuditInvoice(InStockRowIDStr, BussType As %String = "")
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s len = $l(InStockRowIDStr,",")
	s Flag=0
	Set $ZT="ERRORAuditInvoice"
	TStart
	f i=1:1:len  d
	.q:Flag'=0
	.s ISLRowID=$p(InStockRowIDStr,",",i)
	.s IUMRowID=0
	.f  s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source",BussType,ISLRowID,IUMRowID)) q:(IUMRowID="")||(Flag'=0)  d
	..s InvoiceDR=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
	..i InvoiceDR'="" d
	...i $P(^DHCEQInvoice(InvoiceDR),"^",10)=2 s Flag=1
	...q:Flag'=0
	...k PLIST
	...s PLIST(11)=2  ;$P(^DHCEQInvoice(InvoiceDR),"^",10)=2
	...s PLIST(19)=User  ;$P(^DHCEQInvoice(InvoiceDR),"^",18)=User	//审核人
	...s PLIST(20)=Date  ;$P(^DHCEQInvoice(InvoiceDR),"^",19)=Date	//审核日期
	...s PLIST(21)=Time  ;$P(^DHCEQInvoice(InvoiceDR),"^",20)=Time	//审核时间
	...&SQL(update sqluser.DHC_EQInvoice values :PLIST() where IV_RowID=:InvoiceDR)
	...i SQLCODE s Flag=1
	i Flag {
		TROLLBACK
	} 
	else {
		TCommit
	}
	q Flag
ERRORAuditInvoice 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORAuditInvoice"_ErrorMsg     //返回错误消息 ;
}

/// 获取临时Global中的数据
/// Modefied by ZC0081 2020-09-07
ClassMethod GetTempData(TempNode, Job, Index)
{
	q $g(^DHCEQTemp(TempNode,Job,Index))
}

/// 获取临时Global中的数据行数
/// Modefied by ZC0081 2020-09-07
/// w ##Class(web.DHCEQ.Plat.BUSInvoice).GetTempDataRows("InStockDetailPrint",1)
ClassMethod GetTempDataRows(TempNode, Job)
{
	q $o(^DHCEQTemp(TempNode,Job,""),-1)
}

/// Add by CSJ 2020-11-11
/// 入库发票明细查询打印
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.BUSInvoice","GetInStockDetailPrint")
Query GetInStockDetailPrint(CurUser As %String = "") As %Query(ROWSPEC = "TISNo:%String,TInvoice:%String,TName:%String,TModel:%String,TProvider:%String,TInDate:%String,TOriginalFee:%String,TQuantityNum:%String,TTotalFee:%String") [ SqlProc ]
{
}

ClassMethod GetInStockDetailPrintExecute(ByRef qHandle As %Binary, CurUser As %String = "") As %Status
{
 	new repid, index,rowid,Total,TotalFee,PNum
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s index=1
	s gnum=0
	f  s gnum=$o(^DHCEQTemp("InStockDetailPrint",CurUser,gnum)) q:gnum=""  d
	.d ResetVariablesGetInStockDetailPrint
	.s InstockDetail=^DHCEQTemp("InStockDetailPrint",CurUser,gnum)
	.s TISNo=$p(InstockDetail,"^",4)
	.s TInvoice=$p(InstockDetail,"^",17)
	.s TName=$p(InstockDetail,"^",9)
	.s TModel=$p(InstockDetail,"^",10)
	.s TProvider=$p(InstockDetail,"^",2)
	.s TInDate=$p(InstockDetail,"^",3)
	.s TOriginalFee=$p(InstockDetail,"^",13)
	.s TQuantityNum=$p(InstockDetail,"^",12)
	.s TTotalFee=$p(InstockDetail,"^",14)
	.d OutputRowGetInStockDetailPrint
	Quit $$$OK
OutputRowGetInStockDetailPrint
	s Data=$lb(TISNo,TInvoice,TName,TModel,TProvider,TInDate,TOriginalFee,TQuantityNum,TTotalFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetInStockDetailPrint
	s (TISNo,TInvoice,TName,TModel,TProvider,TInDate,TOriginalFee,TQuantityNum,TTotalFee)=""
	quit
}

ClassMethod GetInStockDetailPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInStockDetailPrintExecute ]
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

ClassMethod GetInStockDetailPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInStockDetailPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
