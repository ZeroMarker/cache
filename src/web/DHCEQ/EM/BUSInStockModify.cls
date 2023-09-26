/// 名称: web.DHCEQ.EM.BUSInStockModify
/// 描述: 入库单修改日期,(北京市新要求)
/// 编写者：ZY
/// 编写日期: 2021-05-17
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSInStockModify Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Description:   获取业务主单信息
/// Input：        BussType:业务类型代码 BussNo:业务单单号
/// Return：       表数据解析 json返回
/// w ##Class(web.DHCEQ.EM.BUSInStockModify).GetBusinessMain("94","RK2021060003")
ClassMethod GetBusinessMain(BussType As %Library.String = "", BussNo As %Library.String = "")
{
	i (BussType="")||((BussNo="")) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
	if BussType="21"
	{
		s BussID=$o(^DHCEQInStock(0,"InStockNo",BussNo,""))
		i BussID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","单号不存在!")
		s BussStatus=$p($g(^DHCEQInStock(BussID)),"^",10)
		i BussStatus'="2" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","未审核单据不支持本功能!")
		s InStockInfo=##Class(web.DHCEQ.EM.BUSInStock).GetOneInStock(BussID,"")
		s InStockInfo=##class(web.DHCEQ.Plat.JsonObject).FromJSON(InStockInfo)	//CZF0131 2020-01-20
		i InStockInfo.%Get("SQLCODE")=0 s InStockInfo=InStockInfo.%Get("Data")
		d InStockInfo.%Set("BussID",BussID)
		d InStockInfo.%Set("NewISInDate",$g(^DHCEQInStock(BussID,"EX","NewInDate")))
		q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,InStockInfo)
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
}

ClassMethod SaveBusinessMain(BussType As %Library.String = "", BussNo As %Library.String = "", NewISInDate As %Library.String = "")
{
	i (BussType="")||((BussNo="")) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
	if BussType="21"
	{
		s BussID=$o(^DHCEQInStock(0,"InStockNo",BussNo,""))
		i BussID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","单号不存在!")
		s CurData=+$H
		s tmpISInDate=##Class(web.DHCEQCommon).TransValueFromPage(NewISInDate,"date")
		i (tmpISInDate>CurData) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","调整的日期不能晚于当前日期")
		s ^DHCEQInStock(BussID,"EX","NewInDate")=NewISInDate
		q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0)
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
}

/// Creator：      ZX
/// CreatDate：    2019-08-29
/// Description:   获取入库明细
/// Input：        InStockNo:入库单号
/// modify by wl 2020-02-19 WL0052 增加输出THold5
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSInStockModify","GetInStockList","RK2021050001")
Query GetInStockList(InStockNo) As %Query(ROWSPEC = "TStatCat:%String,TItemDR:%String,TInvoiceNos:%String,TInvoiceDate:%String,TInvoiceFee:%String,TRowID:%String,TInStockDR:%String,TEquipName:%String,TOriginalFee:%String,TQuantityNum:%String,TTotal:%String,THold1:%String,TRemark:%String,TAppendFee:%String,TLimitYearsNum:%String,TManuFactory:%String,TModel:%String,TUnit:%String,TEquipCat:%String,THold5:%String,TEnableFlag:%String,EQRowID:%String,EQNo:%String,TStoreLoc:%String,EQOriginalFee:%String,EQNetFee:%String,EQDepreTotalFee:%String,EQTransAssetDate:%String,TNewTransAssetDate:%String,TNewDepreTotalFee:%String,EQDepreSetID:%String,EQDepreMonths:%String,FundsDepreInfo:%String")
{
}

ClassMethod GetInStockListExecute(ByRef qHandle As %Binary, InStockNo) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i InStockNo="" Quit $$$OK
	s InStockDR=$o(^DHCEQInStock(0,"InStockNo",InStockNo,""))
	i InStockDR="" Quit $$$OK
	s TNewTransAssetDate=$g(^DHCEQInStock(InStockDR,"EX","NewInDate"))
	s TRowID=0
	s InStockList=0
	f  s InStockList=$o(^DHCEQInStockList(0,"InStock",InStockDR,InStockList))  quit:InStockList=""  d
	.s InStockListData=$g(^DHCEQInStockList(InStockList))
	.s TInStockDR = $p(InStockListData,"^",1)
	.s TEquipName = $p(InStockListData,"^",5)
	.s TManuFactoryDR = $p(InStockListData,"^",6)
	.i TManuFactoryDR '=""  d
	..s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)		//modified by CZF103 20200408
	.s TOriginalFee = $p(InStockListData,"^",7)
	.s TQuantityNum = $p(InStockListData,"^",8)
	.s TTotal=TOriginalFee*TQuantityNum
	.s TModelDR = $p(InStockListData,"^",9)
	.i TModelDR '=""  d
	..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TUnitDR = $p(InStockListData,"^",10)
	.i TUnitDR '=""  d
	..s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",(TUnitDR))
	.s THold1 = $p(InStockListData,"^",11)
	.s TRemark = $p(InStockListData,"^",12)
	.s TAppendFee = $p(InStockListData,"^",13)
	.s TEquipCatDR = $p(InStockListData,"^",14)
	.i TEquipCatDR '=""  d
	..s TEquipCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	.s TLimitYearsNum = $p(InStockListData,"^",15)
	.s TItemDR=$p(InStockListData,"^",16)
	.
	.s TStatCatDR=$p(InStockListData,"^",17)
	.s TSourceType=$p(InStockListData,"^",18)
	.s TSourceID=$p(InStockListData,"^",19)
	.s THold2=$p(InStockListData,"^",20)
	.s THold3=$p(InStockListData,"^",21)
	.s THold4=$p(InStockListData,"^",22)
	.s THold5=$p(InStockListData,"^",23)
	.i THold5'="" s THold5=$p($g(^DHCEQCCode("DHCEQCExpenditures",THold5)),"^",2)
	.i TStatCatDR'="" d
	..s TStatCat=$P(^DHCEQCCode("DHCEQCStatCat",TStatCatDR),"^",2)
	.s return=##Class(web.DHCEQInvoice).GetInvoiceInfos(1,InStockList)
	.s TInvoiceNos=$p(return,"^",1)
	.s TInvoiceDate=$p(return,"^",2)
	.s TInvoiceFee=$p(return,"^",3)
	.
	.s vStoreLocDR=0
	.f  s vStoreLocDR=$o(^DHCEQEquip(0,"InStockList",InStockList,vStoreLocDR))  quit:vStoreLocDR=""  d
	..s TStoreLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",(vStoreLocDR))
	..s EquipID=0
	..f  s EquipID=$o(^DHCEQEquip(0,"InStockList",InStockList,vStoreLocDR,EquipID))  quit:EquipID=""  d
	...s TEnableFlag="Y"
	...i TRowID'=InStockList  s TEnableFlag="N"
	...s TRowID = InStockList
	...s EQRowID=EquipID
	...s EQNo=$p(^DHCEQEquip(EquipID),"^",71)
	...s EQOriginalFee=$p(^DHCEQEquip(EquipID),"^",27)
	...s EQNetFee=$p(^DHCEQEquip(EquipID),"^",28)
	...s EQDepreTotalFee=$p(^DHCEQEquip(EquipID),"^",35)
	...s EQTransAssetDate=##class(web.DHCEQCommon).TransValueToPage($p(^DHCEQEquip(EquipID),"^",45),"date")
	...s (DepreSetInfo,FundsDepreInfo,DepreSetInfo,EQDepreSetID,TNewDepreTotalFee,EQDepreMonths)=""
	...
	...i TNewTransAssetDate'="" d
	....s DepreSetInfo=##Class(web.DHCEQMonthDepre).GetDepreSetInfo(EquipID,+$H,1,"1","1")
	....
	....s FundsDepreInfo=$p(DepreSetInfo,"&",2)
	....s DepreSetInfo=$p(DepreSetInfo,"&",1)
	....s EQDepreSetID=$p(DepreSetInfo,"^",2)
	....s TNewDepreTotalFee=$p(DepreSetInfo,"^",3)
	....s EQDepreMonths=$p(DepreSetInfo,"^",4)
	....
	...d OutputRowGetInStockList

	Quit $$$OK
OutputRowGetInStockList
	s Data=$lb(TStatCat,TItemDR,TInvoiceNos,TInvoiceDate,TInvoiceFee,TRowID,TInStockDR,TEquipName,TOriginalFee,TQuantityNum,TTotal,THold1,TRemark,TAppendFee,TLimitYearsNum,TManuFactory,TModel,TUnit,TEquipCat,THold5,TEnableFlag,EQRowID,EQNo,TStoreLoc,EQOriginalFee,EQNetFee,EQDepreTotalFee,EQTransAssetDate,TNewTransAssetDate,TNewDepreTotalFee,EQDepreSetID,EQDepreMonths,FundsDepreInfo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
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

ClassMethod ModifyEquipInfoByInStockDate(BussType As %Library.String = "", BussNo As %Library.String = "", dataList As %Library.String = "")
{
	new ChangeDate,BussID,NewInDate,SplitRowCode,SplitNumCode,Length,i,j
	
	s $ZT="ERRORUPdateIsStockDate"
	TSTART
	
	s ChangeDate=+$h
	i (BussType="")||((BussNo="")) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
	if BussType="21"
	{
		s BussID=$o(^DHCEQInStock(0,"InStockNo",BussNo,""))
		i BussID="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012","")
		s NewInDate=$g(^DHCEQInStock(BussID,"EX","NewInDate"))
		s NewInDate=##class(web.DHCEQCommon).TransValueFromPage(NewInDate,"date")
		&SQL(Update SQLUSER.DHC_EQInStock Set IS_InDate=:NewInDate where IS_RowID = :BussID)
	}
	
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"修改入库单入账日期失败!")
	}
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set SplitNumCode=##class(web.DHCEQCommon).GetSysInfo("990026")
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		k PLIST
		q:SQLCODE'=0
		s valList=	$p(dataList,SplitRowCode,i)  //add by zx 2019-07-24 分隔符号处理
		q:valList=""
		s EquipID=$p(valList,SplitNumCode,1)
		s EQNewDepreTotalFee=$p(valList,SplitNumCode,2)
		s EQDepreSet=$p(valList,SplitNumCode,3)
		s EQDepreMonths=$p(valList,SplitNumCode,4)
		s FundsDepreInfo=$p(valList,SplitNumCode,5)
		s EQOriginalFee=$p(^DHCEQEquip(EquipID),"^",27)
		s EQOldDepreFee=$p(^DHCEQEquip(EquipID),"^",35)
		s ChangeFee=0
		s ChangeDepreFee=EQNewDepreTotalFee-EQOldDepreFee
		s EQNewNetFee=EQOriginalFee-EQNewDepreTotalFee
		i EQNewNetFee<0
		{
			s SQLCODE=-9012
			s ErrorDesc="调整之后资产净值不能小于0"
		}
		q:SQLCODE'=0
		;s ^ZY(EQRowID)=ChangeDate_"^"_ChangeFee_"^"_ChangeDepreFee_"^"_EQDepreMonths
		s SQLCODE=##class(web.DHCEQ.EM.BUSInStockModify).AotuChangeAccount(EquipID,ChangeDate,NewInDate,ChangeFee,ChangeDepreFee,EQDepreMonths)
	}
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	
ERRORUPdateIsStockDate
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSInStockModify).AotuChangeAccount(853,65884,0,100,1)
ClassMethod AotuChangeAccount(EquipID, ChangeDate, NewInDate, ChangeFee, ChangeDepreFee, EQDepreMonths)
{
	new User,Curdate,Curtime,SQLCODE,CAID
	new EQOriginalFee,EQNetFee,EQNetRemainFee,EQDepreTotalFee,EQStoreLocDR,EQStoreLocDR
	new EQUseLocDR,EQEquipTypeDR,EQStatCatDR,EQStatus
	s SQLCODE=0
	k PLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	s Curdate=+$h
 	s Curtime=$p($h,",",2)
	s EQUseLocDR=$p(^DHCEQEquip(EquipID),"^",19)
	s EQOriginalFee=$p(^DHCEQEquip(EquipID),"^",27)
	s EQNetFee=$p(^DHCEQEquip(EquipID),"^",28)
	s EQNetRemainFee=$p(^DHCEQEquip(EquipID),"^",29)
	s EQDepreTotalFee=$p(^DHCEQEquip(EquipID),"^",35)
 	s EQStatus=$p($g(^DHCEQEquip(EquipID)),"^",38)
	s EQEquipTypeDR=$p(^DHCEQEquip(EquipID),"^",63)
	s EQStoreLocDR=$p(^DHCEQEquip(EquipID),"^",67)
	s EQNo=$p(^DHCEQEquip(EquipID),"^",71)
	s EQStatCatDR=$p(^DHCEQEquip(EquipID),"^",75)
 	s PLIST(2) = EquipID
 	s PLIST(3) = ChangeFee
 	s PLIST(4) = EQOriginalFee+ChangeFee
 	s PLIST(5) = EQOriginalFee+ChangeFee-ChangeDepreFee		///modified by ZY0276 20210722
 	s PLIST(6) = EQDepreTotalFee+ChangeDepreFee
 	s PLIST(9) = "调整入库日期"
 	s PLIST(10) =+$h
 	;s PLIST(11) = $p(val,"^",11)	;Remark
 	s PLIST(12) = 0					;Status
 	s PLIST(13) = User
	s PLIST(14) = Curdate
	s PLIST(15) = Curtime
 	s PLIST(25) = EQOriginalFee
 	s PLIST(26) = EQNetFee-ChangeDepreFee	;NetFee
 	s PLIST(27) = EQNetRemainFee	;NetRemainFee
 	s PLIST(29) = EQStoreLocDR	;StoreLocDR
 	s PLIST(30) = EQUseLocDR	;UseLocDR
 	s PLIST(31) = EQEquipTypeDR	;EquipTypeDR
 	s PLIST(32) = EQStatCatDR	;StatCatDR
 	s PLIST(34) = ChangeDepreFee		;调整累计折旧
 	s PLIST(35) = 0			;调整月份
	
	;保存调账单
	s count=0
	&SQL(Select count(*) into :count from SQLUSER.DHC_EQChangeAccount Where CA_EquipDR=:EquipID and CA_Status<2)
	if count>0  s SQLCODE=EQNo_"尚有调账记录未审核,不能新增"
	i SQLCODE'=0 q SQLCODE
	&SQL(Insert Into SQLUSER.DHC_EQChangeAccount Values :PLIST())
	i SQLCODE'=0 q SQLCODE
	Set CAID=$g(%ROWID)
	
	;保存资金来源调账信息
 	s FTRowID=0
	f  s FTRowID=$o(^DHCEQCCode("DHCEQCFundsType",FTRowID))  q:(FTRowID="")||(SQLCODE'=0)  d
 	.s FTInvalidFlag=$p($g(^DHCEQCCode("DHCEQCFundsType",FTRowID)),"^",4)
 	.q:FTInvalidFlag="Y"
 	.s FRowID=$o(^DHCEQFunds("0","EquipType",EquipID,FTRowID,0))
 	.q:FRowID=""
 	.s FundsData=$g(^DHCEQFunds(FRowID))
 	.s PreFundsFee=$p(FundsData,"^",3)
 	.q:+PreFundsFee=0
 	.s PreFundsDepreFee=$p(FundsData,"^",13)
 	.s FinaceItemID=$p(FundsData,"",20)
 	.s FunctionCatID=$p(FundsData,"",21)
	.s changefundsdepre=PreFundsFee*ChangeDepreFee/EQOriginalFee
	.s changefundsdepre=##Class(web.DHCEQCommon).FormatNumber(changefundsdepre,"",2)
	.k FPLIST
	.
	.s FPLIST(3) = FTRowID	;FundsTypeDR
	.s FPLIST(4) = 0	;Fee
	.s FPLIST(8) =User
	.s FPLIST(9) =Curdate
	.s FPLIST(10) = Curtime
	.s FPLIST(11) ="N"
	.s FPLIST(14) =changefundsdepre	;F_DepreTotal	///Mozy0148
	.s FPLIST(15) =7				;F_SourceType
	.s FPLIST(16) =CAID				;F_SourceID
	.s FPLIST(21) =FinaceItemID
	.s FPLIST(22) =FunctionCatID
	.&SQL(Insert Into SQLUSER.DHC_EQFunds Values :FPLIST())
	i SQLCODE'=0 q SQLCODE
	
 	s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(7,CAID,ChangeFee)
 	i SQLCODE'=0 q SQLCODE
 	k PLISTMX
 	s PLISTMX(15)="1"			;SourceType
 	s PLISTMX(16)=EquipID			;SourceID
 	s PLISTMX(2)=EquipID
 	s PLISTMX(7)="0"
 	s PLISTMX(8)=1
	s PLISTMX(9)=Curdate
	s PLISTMX(10)=Curtime
	s PLISTMX(11)="N"
	
	;更新设备资金来源表
	s CAFundsRowID=0
	f  s CAFundsRowID=$o(^DHCEQFunds("0","Source","7",CAID,CAFundsRowID))  q:((CAFundsRowID="")||(SQLCODE'=0))  d
	.q:$p($g(^DHCEQFunds(CAFundsRowID)),"^",10)="Y"
	.s FTypeDR=$p($g(^DHCEQFunds(CAFundsRowID)),"^",2)	;FundsType
	.s PLISTMX(3)=FTypeDR
	.s TFundsInfo=##Class(web.DHCEQ.EM.BUSFunds).GetSourceFunds("1",EquipID,EQOriginalFee,FTypeDR)
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
	i SQLCODE'=0 q SQLCODE
	
 	;更新调账表
 	s EQNewOriginalFee=EQOriginalFee+ChangeFee
 	s EQNewNetFee=EQNetFee-ChangeFee
 	s RemainFeeRate=##class(web.DHCEQCommon).GetSysInfo("990029")
 	s EQNetRemainFee=##Class(web.DHCEQCommon).FormatNumber(EQNewOriginalFee*RemainFeeRate/100,"",2)
 	If ChangeDepreFee'=0
 	{
 		Set EQNewDepreTotal=EQOriginalFee-EQNetFee+ChangeDepreFee
 		Set EQNewNetFee=EQNetFee-ChangeDepreFee
 	}
 	i EQNewNetFee<0 s EQNewNetFee=0
 	s EQNewDepreTotal=EQNewOriginalFee-EQNewNetFee
 	&SQL(Update SQLUSER.DHC_EQChangeAccount set CA_Status=2,CA_AuditUserDR=User,CA_AuditDate=+:Curdate,CA_AuditTime=:Curtime,CA_Hold1=:EQStatus where CA_RowID = :CAID)
 	i SQLCODE'=0 q SQLCODE
 	
 	;更新生命周期表
 	k LI
 	s LI(2)=EquipID  //设备
	s LI(4)=EQUseLocDR   //原使用科室
	s LI(5)=$p($g(^DHCEQEquip(EquipID)),"^",17) //原管理科室
	s LI(6)=EQStoreLocDR  //原库房
	s LI(7)=$p($g(^DHCEQEquip(EquipID)),"^",27)  //原值
	s LI(8)=$p($g(^DHCEQEquip(EquipID)),"^",28)  //原净值
	s LI(14)=$p($g(^DHCEQChangeAccount(CAID)),"^",8)  //变动原因
	s LI(15)=$p($g(^DHCEQChangeAccount(CAID)),"^",6)  //变动描述
	s LI(16)=Curdate			//变动日期
	s LI(17)=Curtime	//变动时间
	s LI(19)="C"			//生命周期类型
	s LI(20)=51				//来源类型
	s LI(21)=CAID			//来源ID
	s LI(23)=$p($g(^DHCEQChangeAccount(CAID)),"^",10)  //备注
	s LI(27)=User				//更新人
	s LI(28)=Curdate			//更新日期
	s LI(29)=Curtime	//更新时间
	
	;更新DHCEQEquip表
 	&SQL(Update SQLUSER.DHC_EQEquip set EQ_TransAssetDate=:NewInDate,EQ_OriginalFee=:EQNewOriginalFee,EQ_NetFee=:EQNewNetFee,EQ_NetRemainFee=:EQNetRemainFee,EQ_DepreTotalFee=:EQNewDepreTotal where EQ_RowID = :EquipID)
 	i SQLCODE'=0 q SQLCODE
	s LI(9)=$p($g(^DHCEQEquip(EquipID)),"^",19)   	//变动后使用科室
	s LI(10)=$p($g(^DHCEQEquip(EquipID)),"^",17) 	//变动后管理科室
	s LI(11)=$p($g(^DHCEQEquip(EquipID)),"^",67)  	//变动后库房
	s LI(12)=$p($g(^DHCEQEquip(EquipID)),"^",27)  	//变动后原值
	s LI(13)=$p($g(^DHCEQEquip(EquipID)),"^",28)  	//变动后净值
	&sql(Insert Into SQLUSER.DHC_EQLifeInfo Values :LI())
	i SQLCODE'=0 q SQLCODE
	
	;更新DHCEQDepreSet表
	s DepreSetID=$Order(^DHCEQDepreSet(0,"Source",1,0,EquipID,0))
	s DSDepreTotalFee=ChangeDepreFee+$Piece($Get(^DHCEQDepreSet(DepreSetID)),"^",23)
	
	s DepreDate=##Class(web.DHCEQMonthDepre).GetAccountMonth($ZD(ChangeDate,1))
	s DepreDate=$zd($zdh(DepreDate,1),3)
	s PreDepreMonth=$p(DepreDate,"-",1,2)
	s PreDepreMonth=##Class(web.DHCEQReport).GetPreMonth(PreDepreMonth)
	&SQL(update sqluser.DHC_EQDepreSet set DS_PreDepreMonth=:PreDepreMonth,DS_DepreTotalFee=:DSDepreTotalFee,DS_DepreTotal=:EQDepreMonths where DS_RowID=:DepreSetID)
	i SQLCODE'=0 q SQLCODE
	
	;更新DHC_EQBillInfo表
 	s SQLCODE=##Class(web.DHCEQBusinessCommon).GetBillInfoStr(7,CAID)
	q SQLCODE
}

}
