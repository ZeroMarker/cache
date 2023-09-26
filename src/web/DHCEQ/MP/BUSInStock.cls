Import SQLUser

/// 创建人:Mozy 2019-9-15
/// 配件管理HisUI改造	Maintenance Parts
Class web.DHCEQ.MP.BUSInStock Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// MZY0071	1760016		2021-04-08	增加入库明细关联维修单设备信息
/// Mozy	1064169		2019-10-26	Mozy0227	增加序列号输出列SerialNoInfo
/// 配件入库业务单入库明细记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSInStock","GetAInStockList",1)
Query GetAInStockList(RowID) As %Query(ROWSPEC = "AISLRowID:%String,AISLAInStockDR:%String,AISLItemDR:%String,AISLCode:%String,AISLDesc:%String,AISLModel:%String,AISLBaseUOMDR:%String,AISLBaseUOMDR_UOMDesc:%String,AISLManuFactoryDR_MDesc:%String,AISLManuFactoryDR:%String,AISLPrice:%String,AISLQuantityNum:%String,TTotalFee:%String,AISLAmount:%String,AISLBatchNo:%String,AISLSourceType:%String,AISLSourceID:%String,AISLEstimateFlag:%String,AISLSerialFlag:%String,AISLBatchFlag:%String,AISLProDate:%String,AISLExpiryDate:%String,AISLInvoiceNos:%String,AISLRemark:%String,TManagementFlag:%String,AISJob:%String,AISLHold1:%String,AISLHold2:%String,AISLHold3:%String,AISLHold4:%String,AISLHold5:%String,AISLHold6:%String,AISLHold7:%String,TMRRowID:%String,TRequestNo:%String,SerialNoInfo:%String,AISLHold3Desc:%String,TContractNo:%String,EQName:%String,EQNo:%String,EQUseLoc:%String")
{
}

ClassMethod GetAInStockListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
	New repid, index,rowid,id
	Set repid=$Increment(^CacheTemp)
 	Set qHandle=$ListBuild(0,repid,0)
	Set index=1
	Set Job=$Job
	Set (TotalQty,Total)=0
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	IF TotalFlag="1" Set index=2
	
	if (RowID="")
	{
		d ResetVariablesGetAInStockList
		s TJob=Job
		d OutputRowGetAInStockList
	}
	else
	{
		Set rowid=0
		f  s rowid=$o(^DHCEQAInStockList(0,"AInStock",RowID,rowid)) quit:rowid=""   d
		.d ResetVariablesGetAInStockList
		.s TRowID=rowid
		.s TAInStockDR = $p($g(^DHCEQAInStockList(rowid)),"^",1)
		.s TItemDR=$p(^DHCEQAInStockList(rowid),"^",2)
		.s TCode=$p(^DHCEQAInStockList(rowid),"^",3)
		.s TDesc=$p(^DHCEQAInStockList(rowid),"^",4)
		.s TModel=$p(^DHCEQAInStockList(rowid),"^",5)
		.s TBaseUOMDR=$p(^DHCEQAInStockList(rowid),"^",6)
		.s TBaseUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TBaseUOMDR)
		.s TManuFactoryDR=$p(^DHCEQAInStockList(rowid),"^",7)
		.s TManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)
		.s TPrice=$p(^DHCEQAInStockList(rowid),"^",8)
		.s TPrice=##Class(web.DHCEQCommon).FormatNumber(TPrice,"",2)	// Mozy		2019-10-18
		.s TQuantityNum=$p(^DHCEQAInStockList(rowid),"^",9)
		.s TQuantityNum=##Class(web.DHCEQCommon).FormatNumber(TQuantityNum,"",2)
		.i TPrice'="" s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(TPrice*TQuantityNum,"",2)
		.s TotalQty=TotalQty+TQuantityNum
		.s Total=Total+TTotalFee
		.s TAmount=$p(^DHCEQAInStockList(rowid),"^",10)
		.s TBatchNo=$p(^DHCEQAInStockList(rowid),"^",11)
		.s TSourceType=$p(^DHCEQAInStockList(rowid),"^",12)
		.s TSourceID=$p(^DHCEQAInStockList(rowid),"^",13)
		.s TEstimateFlag=$p(^DHCEQAInStockList(rowid),"^",14)
		.s TSerialFlag=$p(^DHCEQAInStockList(rowid),"^",15)
		.s TBatchFlag=$p(^DHCEQAInStockList(rowid),"^",16)
		.i TBatchFlag="Y" s TManagementFlag=0
		.i TSerialFlag="Y" s TManagementFlag=1
		.;i TSerialFlag'="" s TSerialFlag=##class(web.DHCEQCommon).TransValueToPage(TSerialFlag,"bool")
		.;i TBatchFlag'="" s TBatchFlag=##class(web.DHCEQCommon).TransValueToPage(TBatchFlag,"bool")
		.s TProDate=$p(^DHCEQAInStockList(rowid),"^",17)
		.s TProDate= ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStockList(rowid)),"^",17),"date")
		.s TExpiryDate=$p(^DHCEQAInStockList(rowid),"^",18)
		.s TExpiryDate= ##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStockList(rowid)),"^",18),"date")
		.;Modified By QW20210917 BUG:QW0153 begin 修改取发票数量及相关信息
		.s InvoiceInfo=##Class(web.DHCEQInvoice).GetInvoiceInfos(3,rowid)
		.s InvoiceLen=$l(InvoiceInfo,"&")
		.for i=1:1:InvoiceLen d
		..s Invoice=$p(InvoiceInfo,"&",i)
		..i TInvoiceNos'="" s TInvoiceNos=TInvoiceNos_","
		..s TInvoiceNos=TInvoiceNos_$p(Invoice,"^",1)
		.;Modified By QW20210917 BUG:QW0153 end
		.s TRemark=$p(^DHCEQAInStockList(rowid),"^",20)
		.s THold1=$p(^DHCEQAInStockList(rowid),"^",21)
		.s THold2=$p(^DHCEQAInStockList(rowid),"^",22)
		.s THold3=$p(^DHCEQAInStockList(rowid),"^",23)
		.i THold3'="" s THold3Desc=$Piece($Get(^DHCEQCCode("DHCEQCFundsType",THold3)),"^",2)	//Mozy0231	配件资金
		.s THold4=$p(^DHCEQAInStockList(rowid),"^",24)
		.s THold5=$p(^DHCEQAInStockList(rowid),"^",25)
		.i THold5'="" s TContractNo=$p($g(^DHCEQContract($p($g(^DHCEQContractList(THold5)),"^",1))),"^",2)	// MZY0040	1408950		2020-7-21	合同号
		.s TPZDate=##class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAInStockList(rowid)),"^",26),"date")	//凭证日期
		.s TPZRemark=$p(^DHCEQAInStockList(rowid),"^",27)		//凭证备注
		.s SerialNoInfo=$Get(^DHCEQAInStockList(rowid,"EX","SerialNoInfo"))		//Mozy	1064169	2019-10-26	Mozy0227	序列号
		.s id=$o(^DHCEQMMaintPart(0,"AInStockList",rowid,""))
		.; Mozy003019	1296220	2020-04-28	增加待购标志判断
		.i (id'="")&&($p($g(^DHCEQMMaintPart(id)),"^",12)="Y") d
		..s TMRRowID=$p($g(^DHCEQMMaintPart(id)),"^",9)			;MTP_MaintRequestDR
		..s TRequestNo=$p($g(^DHCEQMMaintRequest(TMRRowID)),"^",1)
		..// MZY0071	1760016		2021-04-08
		..s TExObjDR = $Piece($Get(^DHCEQMMaintRequest(TMRRowID)),"^",5)
		..s TSourceTypeDR=$Piece($Get(^DHCEQMMaintRequest(TMRRowID)),"^",63)
		..i ((TSourceTypeDR=1)||(TSourceTypeDR=2))  d
		...s EQRowID=+$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",5)
		...s EQName=$Piece($Get(^DHCEQEquip(EQRowID)),"^",1)
		...s EQNo=$Piece($Get(^DHCEQEquip(EQRowID)),"^",71)
		...s EQUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept", $Piece($Get(^DHCEQEquip(EQRowID)),"^",19))
		..e  d
		...s EQName=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",1)
		...s EQNo=$Piece($Get(^DHCEQMExObj(TExObjDR)),"^",2)
		...s EQUseLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept", $Piece($Get(^DHCEQMExObj(TExObjDR)),"^",3))
		.
		.s TJob=Job
		.d OutputRowGetAInStockList
	}
	Quit $$$OK
OutputRowGetAInStockList
    Set Data=$ListBuild(TRowID,TAInStockDR,TItemDR,TCode,TDesc,TModel,TBaseUOMDR,TBaseUOM,TManuFactory,TManuFactoryDR,TPrice,TQuantityNum,TTotalFee,TAmount,TBatchNo,TSourceType,TSourceID,TEstimateFlag,TSerialFlag,TBatchFlag,TProDate,TExpiryDate,TInvoiceNos,TRemark,TManagementFlag,TJob,THold1,THold2,THold3,THold4,THold5,TPZDate,TPZRemark,TMRRowID,TRequestNo,SerialNoInfo,THold3Desc,TContractNo,EQName,EQNo,EQUseLoc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetAInStockList
	Set (TRowID,TAInStockDR,TItemDR,TCode,TDesc,TModel,TBaseUOMDR,TBaseUOM,TManuFactory,TManuFactoryDR,TPrice,TQuantityNum,TAmount,TBatchNo,TSourceType,TSourceID,TEstimateFlag,TSerialFlag,TBatchFlag,TProDate,TExpiryDate,TInvoiceNos,TRemark,TManagementFlag,TJob,THold1,THold2,THold3,THold4,THold5,TPZDate,TPZRemark,TMRRowID,TRequestNo,SerialNoInfo,THold3Desc,TContractNo,EQName,EQNo,EQUseLoc)=""
	Set TTotalFee=0
	Quit
}

ClassMethod GetAInStockListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAInStockListExecute ]
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

ClassMethod GetAInStockListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAInStockListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 入库业务类型列表
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.MP.BUSInStock","GetInType","")
Query GetInType(Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TDesc:%String")
{
}

ClassMethod GetInTypeExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	
	s ID=0
	s TDesc="采购"
	d OutputRowGetInType
	s ID=1
	s TDesc="盘盈"
	;d OutputRowGetInType
	s ID=2
	s TDesc="接受捐赠"
	d OutputRowGetInType
	s ID=3
	s TDesc="分解"
	;d OutputRowGetInType
	s ID=9
	s TDesc="其他"
	d OutputRowGetInType
	
	Quit $$$OK
OutputRowGetInType
	Set Data=$lb(ID,TDesc)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetInTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInTypeExecute ]
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

ClassMethod GetInTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 配件入库业务单数据填充取值
/// w ##Class(web.DHCEQ.MP.BUSInStock).GetOneAInStock(42)
ClassMethod GetOneAInStock(RowID As %Library.String = "", ApproveRoleDR As %Library.String = "")
{
	s $ZT="ERRORGetOneAInStock"
	// AISRowID,AISInDate,AISAccessoryTypeDR,AISLocDR,AISRequestUserDR,AISRequestDate,AISInStockNo,AISInType,AISProviderDR,AISSourceID,AISBuyLocDR
	// AISBuyUserDR,AISRejectReason,AISRejectUserDR,AISRejectDate,AISRejectTime,AISStatus,AISAddUserDR,AISAddDate,AISAddTime,AISSubmitUserDR,
	// AISSubmitDate,AISSubmitTime,AISAuditUserDR,AISAuditDate,AISAuditTime,AISRemark,AISHold1,AISHold2,AISHold3,AISHold4,AISHold5,
	// AISHold6,AISHold7,AISHold8,AISHold9,AISHold10,AISHold11
	
	s ObjAInStock=##Class(User.DHCEQAInStock).%OpenId(RowID)
	s AInStockInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjAInStock)
	d AInStockInfo.%Set("AISInType_Desc", $CASE(ObjAInStock.AISInType,"0":"采购","1":"盘盈","2":"接受捐赠","3":"分解","9":"其他",:"没有定义"))
	d AInStockInfo.%Set("AISAccessoryTypeDR_ATDesc",ObjAInStock.AISAccessoryTypeDR.ATDesc)
	d AInStockInfo.%Set("AISBuyLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjAInStock.AISBuyLocDR))
	d AInStockInfo.%Set("AISBuyUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjAInStock.AISBuyUserDR))
	d AInStockInfo.%Set("AISLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjAInStock.AISLocDR))
	d AInStockInfo.%Set("AISProviderDR_VDesc",ObjAInStock.AISProviderDR.VName)
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("10",RowID,ApproveRoleDR)
	d AInStockInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d AInStockInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d AInStockInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d AInStockInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d AInStockInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d AInStockInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d AInStockInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d AInStockInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d AInStockInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d AInStockInfo.%Set("NextRole",$p(AppInfo,"^",10))
	s AISHold3=##class(web.DHCEQCommon).TransValueFromPage(ObjAInStock.AISHold3,"date")
	d AInStockInfo.%Set("AISHold3",##class(web.DHCEQCommon).TransValueToPage(AISHold3,"date"))
	
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,AInStockInfo)
ERRORGetOneAInStock
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// 描述:新增,更新数据
/// w ##Class(web.DHCEQ.MP.BUSInStock).SaveData()
ClassMethod SaveData(val, valList)
{
	new (val, valList, %session)
	Set $ZT="ERRORSave"
	;s ^DHCEQMozy("SaveData")=val_","_ valList
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Date=+$H
	s Time=$P($H,",",2)
	k PLIST
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(val)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQAInStock",JsonData,.PLIST)
	s RowID = JsonData.AISRowID
 	s Job = JsonData.AISJob
 	s PLIST(5)=User  					;AIS_RequestUserDR
	TSTART
 	if RowID=""
 	{
	 	s PLIST(6)=PLIST(2)
		i PLIST(7)="" s PLIST(7)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAInStock",Date,PLIST(4),PLIST(3))
		s PLIST(17)=0
		s PLIST(18)=User  				;AIS_AddUserDR
		s PLIST(19)=Date  				;AIS_AddDate
		s PLIST(20)=Time				;AIS_AddTime
		s PLIST(28)="N"					;AIS_Hold1		自动建单未编辑标志
		&SQL(insert into sqluser.DHC_EQAInStock values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "插入主单记录失败")	;Mozy		2019-10-18
		}
		s RowID=$G(%ROWID)
 	}
 	else
 	{
	 	// Mozy		2019-10-21
	 	i $P(^DHCEQAInStock(RowID),"^",27)="Y" s PLIST(7)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQAInStock",Date,PLIST(4),PLIST(3))
	 	s PLIST(28)="N"
		&SQL(update sqluser.DHC_EQAInStock values :PLIST() where AIS_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "更新主单记录失败")	;Mozy		2019-10-18
		}
 	}
 	s SQLCODE=##CLASS(web.DHCEQ.MP.BUSInStock).SaveInStockList(RowID,valList,Job)
	i SQLCODE
	{
		TROLLBACK
		// Mozy003008	1266895		2020-04-09		修正描述
		i (SQLCODE=-1008) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "发票日期或金额与原有信息不符!")
		i (SQLCODE=-1009) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "原有发票已经提交!")
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "保存明细记录失败")		;Mozy		2019-10-18
	}
 	
	TCOMMIT
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
 	
ERRORSave 
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:保存入库单明细
/// 入参： AISRowID		入库单ID
/// w ##Class(web.DHCEQ.MP.BUSInStock).SaveInStockList(33,"1^100^10403&1^100^10403")
ClassMethod SaveInStockList(AISRowID, valstring, Job)
{
	i AISRowID="" q -1
	i valstring="" q 0
	new SQLCODE,Length,valList,AISLRowID,i,InvoiceNos,InvoiceDate,InvoiceFee,AISLRowIDs
	Set AISLRowIDs=""
	Set SQLCODE=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	Set Length=$l(valstring,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=$p(valstring,SplitRowCode,i)
		q:valList=""
		k PLISTMX,AISLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLISTMX=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQAInStockList",JsonData,.PLISTMX)
		s AISLRowID = JsonData.AISLRowID
		s PLISTMX(2) = AISRowID  			;InStockDR
		s PLISTMX(13) = 1					;AISL_PZType
 		s PLISTMX(14) = JsonData.AISLItemDR	;AISLPZID
		; q $CASE(TManagementFlag,"0":"批号管理","1":"序列号管理","":"")
		s PLISTMX(17)="Y"  ;BatchFlag
		i PLISTMX(16)="Y" s PLISTMX(17)="N"
		//s PLISTMX(25)=##Class(web.DHCEQCommon).TransValueFromPage(PLISTMX(25), "date")	//Modefied by zc0132 2023-3-29 发票日期转化错误
		// MZY0040	1408950		2020-7-21
		i PLISTMX(26)'=""
		{
			;AISLHold5		采购合同明细数量-入库明细数量-入库单占用数
			i ($p($g(^DHCEQContractList(PLISTMX(26))),"^",7)-PLISTMX(10)-##Class(web.DHCEQ.MP.BUSInStock).GetAInListQuantity(PLISTMX(26),AISLRowID))<0
			{
				s SQLCODE=-1001
				q
			}
		}
 		; Mozy003003	1247579		2020-3-27
 		;s InvoiceNos=PLISTMX(20)
 		;s InvoiceDate=""
 		;s InvoiceFee=""
		if (AISLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQAInStockList Values :PLISTMX())
			s AISLRowID=$G(%ROWID)
		}
		else
		{
			&SQL(update sqluser.DHC_EQAInStockList values :PLISTMX() where AISL_RowID=:AISLRowID)
		}
		q:SQLCODE'=0
		//Mozy	1064169	2019-10-26	Mozy0227	保存序列号
		s JsonData.SerialNoInfo=$TRANSLATE(JsonData.SerialNoInfo,"，",",")
 		s ^DHCEQAInStockList(AISLRowID,"EX","SerialNoInfo")=JsonData.SerialNoInfo
		;s SQLCODE=##Class(web.DHCEQ.MP.BUSInStock).UpdateInvoiceInfo(AISLRowID, InvoiceNos, InvoiceDate, InvoiceFee)// Mozy003003	1247579		2020-3-27
		if AISLRowIDs'="" s AISLRowIDs=AISLRowIDs_","
		s AISLRowIDs=AISLRowIDs_AISLRowID
	}
	; 删除未处理的入库明细
	s AISLRowID=0
	f  s AISLRowID=$o(^DHCEQAInStockList(0,"AInStock",AISRowID,AISLRowID)) quit:(AISLRowID="")||(SQLCODE'=0)  d
	.i (","_AISLRowIDs_",")'[(","_AISLRowID_",") &SQL(delete from SQLUSER.DHC_EQAInStockList where AISL_RowID = :AISLRowID)
	
	// Mozy003003	1247579		2020-3-27	发票处理
	i SQLCODE'=0 q SQLCODE
	k ^DHCEQTemp("TempInvoice",$j)
	k ^DHCEQTemp("TempInvoiceFee",$j)
	s AISLRowID=0
	f  s AISLRowID=$o(^DHCEQAInStockList(0,"AInStock",AISRowID,AISLRowID)) quit:(AISLRowID="")  d
	.s InvoiceNos=$p(^DHCEQAInStockList(AISLRowID),"^",19)
	.q:InvoiceNos=""
	.s ^DHCEQTemp("TempInvoice",$j,InvoiceNos,AISLRowID)=""
	.s ^DHCEQTemp("TempInvoiceFee",$j,InvoiceNos)=+$p(^DHCEQAInStockList(AISLRowID),"^",10)+$g(^DHCEQTemp("TempInvoiceFee",$j,InvoiceNos))
 	
	Set InvoiceNos=""
	For  Set InvoiceNos=$Order(^DHCEQTemp("TempInvoice",$j,InvoiceNos)) Quit:(InvoiceNos="")||(SQLCODE'=0)  Do
	.Set AISLRowID=""
	.For  Set AISLRowID=$Order(^DHCEQTemp("TempInvoice",$j,InvoiceNos,AISLRowID)) Quit:(AISLRowID="")||(SQLCODE'=0)  Do
	..Set InvoiceDate=$P(^DHCEQAInStockList(AISLRowID),"^",24)	;AISL_Hold4
	..s InvoiceFee=$g(^DHCEQTemp("TempInvoiceFee",$j,InvoiceNos))
	..s SQLCODE=##Class(web.DHCEQ.MP.BUSInStock).UpdateInvoiceInfo(AISLRowID, InvoiceNos, InvoiceDate, InvoiceFee)
	q SQLCODE
}

/// 描述:修改发票信息
/// 访问表:DHC_EQInvoice,DHC_EQInvoiceUseMap
/// w ##Class(web.DHCEQ.MP.BUSInStock).UpdateInvoiceInfo()
ClassMethod UpdateInvoiceInfo(AISLRowID, InvoiceNos, InvoiceDate, InvoiceFee)
{
	new AISRowID,ProviderID,ISStatus,IUMRowID,InvoiceID
	new OldInvoiceID,OldInvoiceNo,OldInvoiceDate,OldInvoiceFee,RowID,Times
	
	s (OldInvoiceID,OldInvoiceNo,OldInvoiceDate,OldInvoiceFee)=""
	s Flag=0
	s AISRowID=$P(^DHCEQAInStockList(AISLRowID),"^",1)
	s ProviderID=$P(^DHCEQAInStock(AISRowID),"^",8)
	s ISStatus=$P(^DHCEQAInStock(AISRowID),"^",16)
	s IUMRowID=0
	;s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","2",AISLRowID,IUMRowID))
	s InvoiceDate=##class(web.DHCEQCommon).TransValueFromPage(InvoiceDate,"date")
	s num=$l(InvoiceNos,",")
	s num=1
	for j=1:1:num
	{
		q:Flag'=0
		k INPLIST
		;s INPLIST(3)=$p(InvoiceNos,",",j)
		s INPLIST(3)=InvoiceNos
		s INPLIST(4)=InvoiceDate
		s INPLIST(5)=InvoiceFee
		s INPLIST(11)="0" //Status
		s INPLIST(6)=ProviderID
		s INPLIST(17)="N"
		; IUM_Type	1:入库明细 2:退货明细 3:配件入库明细 6:验收(自动入库引起) 7:维修项目 9:付款记录
		s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Source","3",AISLRowID,IUMRowID))
		;i INPLIST(3)'="" s IvRowID=$o(^DHCEQInvoice(0,"InvoiceNo",INPLIST(3),0))
		;i IvRowID'="" s IUMRowID=$o(^DHCEQInvoiceUseMap(0,"Invoice",IvRowID,0))
		
		;获取原来的发票信息
		i IUMRowID'=""
		{		
			s OldInvoiceID=$p(^DHCEQInvoiceUseMap(IUMRowID),"^",2)
			//s OldInvoiceNo=$p(^DHCEQInvoice(OldInvoiceID),"^",2)
			//s OldInvoiceDate=$p(^DHCEQInvoice(OldInvoiceID),"^",3)
			//s OldInvoiceFee=$p(^DHCEQInvoice(OldInvoiceID),"^",4)
		}
		;获取新的发票ID
		s InvoiceID=""
		i INPLIST(3)'=""
		{
			s RowID=0
			f  s RowID=$o(^DHCEQInvoice(0,"InvoiceNo",INPLIST(3),RowID)) q:((RowID="")||(InvoiceID'=""))  d
			.q:$p(^DHCEQInvoice(RowID),"^",16)'="N"
			.i ProviderID=$p(^DHCEQInvoice(RowID),"^",5) s InvoiceID=RowID		
		}
	
		i InvoiceID'=""
		{
			s Times=##class(web.DHCEQInvoice).InvoiceUsedTimes(3,AISLRowID,InvoiceID)
			i Times>0
			{
				// Mozy003008	1266895		2020-04-09		该发票与原有信息不符!
				i (InvoiceDate'=$p(^DHCEQInvoice(InvoiceID),"^",3))&&($p(^DHCEQInvoice(InvoiceID),"^",3)'="") s Flag=-1008
				;i (InvoiceFee'=$p(^DHCEQInvoice(InvoiceID),"^",4))&&($p(^DHCEQInvoice(InvoiceID),"^",4)'="") s Flag=-1008	Mozy003015	1266905		2020-04-23	不做金额判断处理
			}
			;发票已经提交
			i $p(^DHCEQInvoice(InvoiceID),"^",10)="2" s Flag=-1009
			&SQL(update sqluser.DHC_EQInvoice values :INPLIST() where IV_RowID=:InvoiceID)
		}
		else
		{
			i INPLIST(3)'=""
			{
				&SQL(insert into sqluser.DHC_EQInvoice values :INPLIST())
				if SQLCODE s Flag=SQLCODE
				s InvoiceID=$G(%ROWID)
				;q "InvoiceID"_InvoiceID
			}
		}	
	
		;处理原来发票		
		i (OldInvoiceID'="")&&(OldInvoiceID'=InvoiceID)
		{
			;删除对照
			&SQL(delete from sqluser.DHC_EQInvoiceUseMap where IUM_RowID=:IUMRowID)
			if SQLCODE<0 s Flag=SQLCODE
			s Times=##class(web.DHCEQInvoice).InvoiceUsedTimes(3,AISLRowID,OldInvoiceID)
			;没有其他单据使用则删除发票
			i Times=0
			{
				&SQL(delete from sqluser.DHC_EQInvoice where IV_RowID=:OldInvoiceID)
			}
			if SQLCODE<0 s Flag=SQLCODE		
		}
		;增加新发票对照
		i ((InvoiceID'="")&&(OldInvoiceID'=InvoiceID))
		{
			k INMPLIST
			s INMPLIST(2)=AISLRowID
			s INMPLIST(3)=InvoiceID
			s INMPLIST(4)="3"
			&SQL(insert into sqluser.DHC_EQInvoiceUseMap values :INMPLIST())
			if SQLCODE
			{
				s Flag=SQLCODE
			}
		}
	}
	q Flag
}

/// 描述:删除入库业务单
/// w ##Class(web.DHCEQ.MP.BUSInStock).DeleteData(RowID)
ClassMethod DeleteData(RowID)
{
	Set $ZT="ERRORDelete"
	i RowID="" q ""
	s SQLCODE=0
	&SQL(update SQLUSER.DHC_EQAInStock set AIS_Status='3' where AIS_RowID=:RowID)
	i SQLCODE Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "删除主单记录失败")		;Mozy		2019-10-18
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORDelete 
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:提交入库单
/// w ##Class(web.DHCEQ.MP.BUSInStock).SubmitData(40)
ClassMethod SubmitData(RowID, Job)
{
	new (RowID, Job, %session)
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单	Mozy		2019-10-18
	i $p($g(^DHCEQAInStock(RowID)),"^",27)="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-7401)	;Hold1	Mozy		2019-10-18
	
	Set $ZT="ERRORSubmit"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Date=+$H
	s LocDR=$p($g(^DHCEQAInStock(RowID)),"^",3)
	s LocType=$o(^DHCEQCCode("DHCEQCLocGroupType",0,"Code","0302",0))
  	i '$d(^DHCEQCCode("DHCEQCLocType",0,"LocType",LocType,LocDR)) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-7404)	//Mozy		2019-10-18
  	//Mozy0253		2020-3-4	增加状态过滤
  	s Status=$p($g(^DHCEQAInStock(RowID)),"^",16) //状态
	if Status'="0" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)
	s AccessoryTypeDR=$p($g(^DHCEQAInStock(RowID)),"^",2)
	s ReturnAccessoryType=##Class(web.DHCEQ.MP.BUSInStock).AccessoryTypeIsUniqueNew(RowID,AccessoryTypeDR,"InStock")	
	i $p(ReturnAccessoryType,"^",1)<0 Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson($p(ReturnAccessoryType,"^",1))		//Mozy		2019-10-18
	
	s ApproveType=##Class(web.DHCEQApproveList).GetApproveType("10")
	s ApproveSet=##Class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, AccessoryTypeDR, "", "", "","")
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9021)	//Mozy		2019-10-18
	s ApproveFlow=##Class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s PLIST(17) = 1		;Status
	s PLIST(21) = User	;SubmitUserDR
 	s PLIST(22) = Date	;SubmitDate
 	s PLIST(23) = $P($H,",",2)
	
	s AppInfoStatus="1"		;Status
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s PLIST(17)="2"		;Status
		s PLIST(24)=User	;BillAuditUserDR
		s PLIST(25)=Date	;BillAuditDate
		s AppInfoStatus="2"		;Status
	}
	
	TSTART
	s SQLCODE=##Class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"10",User)
	i SQLCODE
	{
		TROLLBACK
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"删除审批记录失败")	//Mozy		2019-10-18
	}
	s SQLCODE=##Class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存审批记录失败")	//Mozy		2019-10-18
	}
	&SQL(update sqluser.DHC_EQAInStock values :PLIST() where AIS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"更新配件入库单失败")	//Mozy		2019-10-18
	}
	;最后一步需要调用审核方法
	if AuditFlag=1
	{
		//Mozy	1064169	2019-10-26	Mozy0227	删除入库单号参数
		;s AInStockNo=$P($G(^DHCEQAInStock(RowID)),"^",6)
		s SQLCODE=##Class(web.DHCEQ.MP.BUSInStock).LastAuditAction(RowID, User, Date, Job)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作失败!")	//Mozy		2019-10-18
		}		
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A01", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"生成消息失败")	//Mozy		2019-10-18
	}
	
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
 	
ERRORSubmit 
	TRollBack	
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// 描述:取消提交
/// w ##Class(web.DHCEQ.MP.BUSInStock).CancelSubmitData(42,2,"")
ClassMethod CancelSubmitData(RowID, CurRole, CancelToFlowDR)
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单	Mozy		2019-10-18
	new (RowID, CurRole, CancelToFlowDR, %session)
	Set $ZT="ERRORCancel"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Date=+$H
	//Mozy0253		2020-3-4	增加状态过滤
  	s Status=$p($g(^DHCEQAInStock(RowID)),"^",16) //状态
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)
	;获取取消到上一步的信息
	s Status="0"
	s ApproveRoleDR=""
	s Step=""
	if (CancelToFlowDR'="")
	{
		s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
		s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}
	;S PLIST(13)=RejectReason
	s PLIST(14)=User	;RejectUserDR
	s PLIST(15)=Date	;RejectDate
	s PLIST(16)=$P($H,",",2)
	s PLIST(17)=Status
	
	TSTART
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("10")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("10", RowID)
	s RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存审批流失败")	//Mozy		2019-10-18
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存审批记录失败")		//Mozy		2019-10-18
	}
	&SQL(update sqluser.DHC_EQAInStock values :PLIST() where AIS_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "更新主单失败")	//Mozy		2019-10-18
	}
	else
	{
		s ApproveFlow=""
		i CancelToFlowDR'=""
		{
			s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
		}
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A01", RowID, User, ApproveFlow, "Y",CurRole)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"生成消息失败")	//Mozy		2019-10-18
		}
	}
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
 	
ERRORCancel
	TRollBack
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// 描述:审核
/// w ##Class(web.DHCEQ.MP.BUSInStock).AuditData(42,1796,2,1)
ClassMethod AuditData(RowID, Job, CurRole, RoleStep)
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9001)	;无业务单	Mozy		2019-10-18
	new (RowID, Job, CurRole, RoleStep, %session)
	n ApproveType,ApproveSet,ApproveFlow,AutoAuditFlag,LastFlag,NextStep,NextRole
	n User,Date,AuditFlag
	Set $ZT="ERRORAudit"
	
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Date=+$H
	//Mozy0253		2020-3-4	增加状态过滤
  	s Status=$p($g(^DHCEQAInStock(RowID)),"^",16) //状态
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-2015)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("10")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("10",RowID)
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9021)	//Mozy		2019-10-18
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	s AppInfoStatus="1"	;Status	
	
	TSTART
	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		i ($p($g(^DHCEQAInStock(RowID)),"^",16)=2)
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9002)	;Mozy		2019-10-18
		}
		s AuditFlag=1
		s PLIST(17)="2"
		s PLIST(24)=User	;AuditUserDR
		s PLIST(25)=Date	;AuditDate
		s PLIST(26)=$P($H,",",2)
		&SQL(update sqluser.DHC_EQAInStock values :PLIST() where AIS_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "更新主单失败")	//Mozy		2019-10-18
		}
		s AppInfoStatus="2"	;Status
	}
	
	;生成审批记录
	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,"","",CurRole,RoleStep)
	if SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE, "更新审批流失败")	//Mozy		2019-10-18
	}
	
	;记录单据当前审批状态
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"保存审批记录失败")	//Mozy		2019-10-18
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"执行动作失败!")	//Mozy		2019-10-18
		}
	}
	;最后一步需要调用审核方法
	;s AInStockNo=$P($G(^DHCEQAInStock(RowID)),"^",6)	//Mozy	1064169	2019-10-26	Mozy0227	删除入库单号参数
	if AuditFlag=1
	{
		s SQLCODE=##Class(web.DHCEQ.MP.BUSInStock).LastAuditAction(RowID, User, Date, Job)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"操作失败!")	//Mozy		2019-10-18
		}
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("A01", RowID, User, ApproveFlow_"^"_ApproveSet, "N", CurRole, AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"生成消息失败")	//Mozy		2019-10-18
	}
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0, RowID)
ERRORAudit
	TRollBack
	Set ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// 描述：最终审核时需调用此方法,执行审核中需要处理的数据
/// w ##Class(web.DHCEQ.MP.BUSInStock).LastAuditAction(52,1,61963,Job)
ClassMethod LastAuditAction(RowID, User, Date, Job)
{
	s SQLCODE=##Class(web.DHCEQ.MP.BUSInStock).SaveAStock(RowID)
	i SQLCODE Quit SQLCODE 	//Mozy	1064169	2019-10-26	Mozy0227	"保存配件库存失败"
	s SQLCODE=##Class(web.DHCEQ.MP.BUSInStock).ChangeStock(RowID,User,Date,Job)
	i SQLCODE Quit SQLCODE	//Mozy	1064169	2019-10-26	Mozy0227	"保存配件变动信息失败"
	//add by csj 2020-03-04 配件发票状态改变
	s SQLCODE=##Class(web.DHCEQ.MP.BUSInStock).BillUpdateAInvoice(RowID)
	If SQLCODE Quit SQLCODE
	Quit 0
}

/// Mozy	1064169	2019-10-26	Mozy0227优化
/// 描述：更新设备配件库存
/// 访问表:DHC_EQAStock、DHC_EQAStockList
/// 输入：RowID：入库单ID
/// 输出：无
/// 返回：SQLCODE
/// 备注：
/// d ##Class(web.DHCEQ.MP.BUSInStock).SaveAStock(30)
ClassMethod SaveAStock(AInStockDR As %Library.String = "")
{
	New rowid,id,ASRowID,SQLCODE
	Set LocDR=$Piece($Get(^DHCEQAInStock(AInStockDR)),"^",3)
	Set (Amount,Stock,SQLCODE)=0
	
	Set rowid=""
	For  Set rowid=$Order(^DHCEQAInStockList(0,"AInStock",AInStockDR,rowid)) Quit:(rowid="")||(SQLCODE'=0)  Do
	.Set AccessoryDR=$Piece($Get(^DHCEQAInStockList(rowid)),"^",2)
	.Set Price=$Piece($Get(^DHCEQAInStockList(rowid)),"^",8)
	.Set ASRowID=""
	.Set id=""
	.For  Set id=$Order(^DHCEQAStock(0,"Loc",LocDR,id))  Quit:id=""  Do
	..If ($Piece($Get(^DHCEQAStock(id)),"^",2)=AccessoryDR) Set ASRowID=id
	.K PLIST
	.If (ASRowID="") Do
	..Set PLIST(2)=LocDR										;AS_LocDR
	..Set PLIST(3)=AccessoryDR									;AS_ItemDR
	..;Set Code=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",AccessoryDR)),"^",1)
	..Set PLIST(4)=$Piece($Get(^DHCEQAInStockList(rowid)),"^",3)	;AS_Code
	..;Set Desc=$Piece($Get(^DHCEQCCode("DHCEQCAccessory",AccessoryDR)),"^",2)
	..Set PLIST(5)=$Piece($Get(^DHCEQAInStockList(rowid)),"^",4)	;AS_Desc
	..Set PLIST(6)=$Piece($Get(^DHCEQAInStock(AInStockDR)),"^",2)	;AS_AccessoryTypeDR
	..Set PLIST(7)=$Piece($Get(^DHCEQAInStockList(rowid)),"^",18)	;ExpiryDate
	..Set PLIST(8)=+$Piece($Get(^DHCEQAInStockList(rowid)),"^",8)	;AS_FinalBPrice
	..Set PLIST(9)=PLIST(8)										;AS_WtdBPrice
	..Set PLIST(11)=+$Piece($Get(^DHCEQAInStockList(rowid)),"^",9)	;AS_Stock
	..Set PLIST(10)=PLIST(11)*PLIST(8)							;AS_Amount
	..&SQL(Insert into sqluser.DHC_EQAStock values :PLIST())
	.Else  Do
	..Set Stock=+$Piece($Get(^DHCEQAStock(ASRowID)),"^",10)
	..Set Amount=+$Piece($Get(^DHCEQAStock(ASRowID)),"^",9)
	..Set PLIST(8)=+$Piece($Get(^DHCEQAInStockList(rowid)),"^",8) 	;AS_FinalBPrice
	..Set PLIST(11)=Stock+$Piece($Get(^DHCEQAInStockList(rowid)),"^",9)	;AS_Stock
	..Set PLIST(10)=Amount+(+$Piece($Get(^DHCEQAInStockList(rowid)),"^",9)*PLIST(8))	;AS_Amount
	..If PLIST(11)'=0 Set PLIST(9)=PLIST(10)/PLIST(11)			;AS_WtdBPrice
	..If PLIST(9)'="" Set PLIST(9)=##Class(web.DHCEQCommon).FormatNumber(PLIST(9),"",4)
	..&SQL(Update sqluser.DHC_EQAStock values :PLIST() where AS_RowID = :ASRowID)
	
	Quit SQLCODE
}

/// 配件变动信息
/// w ##Class(web.DHCEQ.MP.BUSInStock).ChangeStock(RowID,User,Date,Job)
ClassMethod ChangeStock(RowID, User, Date, Job)
{
	new (RowID, User, Date, Job, ASDR)
	s AcPL(2)=$P(^DHCEQAInStock(RowID),"^",3) //库房
	s j=0
	s CSSQLCODE=0
	s AISLRowID=""
	f  s AISLRowID=$o(^DHCEQAInStockList(0,"AInStock",RowID,AISLRowID)) quit:(AISLRowID="")||(CSSQLCODE'=0)  d
	.s AcPL(4)=AISLRowID //入库明细
	.s Num=$P(^DHCEQAInStockList(AISLRowID),"^",9) //配件数量
	.s SourceType=$p(^DHCEQAInStockList(AISLRowID),"^",12)
	.s SourceID=$P(^DHCEQAInStockList(AISLRowID),"^",13)
	.
	.s AcPL(15)=$P(^DHCEQAInStockList(AISLRowID),"^",7) //生产厂商
	.s AcPL(8)=$P(^DHCEQAInStockList(AISLRowID),"^",18) //过期日期
	.s AcPL(9)=$P(^DHCEQAInStockList(AISLRowID),"^",8) //配件原值
	.s AcPL(16)=$P(^DHCEQAInStockList(AISLRowID),"^",5) //配件机型
	.s AcPL(14)=$P(^DHCEQAInStockList(AISLRowID),"^",6) //配件单位
	.s AcPL(24)=$P(^DHCEQAInStockList(AISLRowID),"^",13)
	.s AcPL(7)=$P(^DHCEQAInStockList(AISLRowID),"^",11) //批号
	.s AcPL(3)=$P(^DHCEQAInStockList(AISLRowID),"^",2) //配件项
	.s AcPL(29)=$P(^DHCEQAInStockList(AISLRowID),"^",22) //ASD_Location
	.s AcPL(30)=$P(^DHCEQAInStockList(AISLRowID),"^",21) //ASD_BillPage
	.i AcPL(3)'="" s AcPL(5)=$P(^DHCEQAInStockList(AISLRowID),"^",3) //Code
	.i AcPL(3)'="" s AcPL(6)=$P(^DHCEQAInStockList(AISLRowID),"^",4) //配件名称
	.s AcPL(17)=$P(^DHCEQAInStock(RowID),"^",8) //供应商
	.s AcPL(12)=$P(^DHCEQAInStock(RowID),"^",2) //类组
	.s AcPL(23)=$P(^DHCEQAInStock(RowID),"^",7) //intype
	.//Mozy	1064169	2019-10-26	Mozy0227	修正获取配件库存表ID
	.Set AcPL(22)=""
	.Set id=""
	.For  Set id=$Order(^DHCEQAStock(0,"Accessory",AcPL(3),id)) Quit:id=""  Do
	..If ($Piece($Get(^DHCEQAStock(id)),"^",1)=AcPL(2)) Set AcPL(22)=id
	.s InStockListDR=$P(^DHCEQAInStockList(AISLRowID),"^",1)
	.s AcPL(13)="0"
	.s AcPL(31)=$P(^DHCEQAInStockList(AISLRowID),"^",23)	// Mozy0231	访问资金来源类型
	.s AcRowID=0
	.s BatchFlag=$P(^DHCEQAInStockList(AISLRowID),"^",16) //是否批号处理
	.i BatchFlag="N"  d
	..s AcPL(7)=""
	..;插入设备变动信息,更新或插入设备信息
	..s AcPL(18)=1
	..s CSPLIST(3)=$P(^DHCEQAInStock(RowID),"^",3) //ToLocDR
	..s CSPLIST(4)=AcPL(3) //配件项
	..s CSPLIST(5)=AcPL(12) //AccessoryTypeDR
	..s CSPLIST(6)=AcPL(14) //BaseUOMDR
	..s CSPLIST(8)=Num  //BaseStock
	..s CSPLIST(9)=AcPL(9) //Price
	..s CSPLIST(10)="0" //变动类型
	..s CSPLIST(11)=AISLRowID	//变动来源
	..s CSPLIST(12)=Num //Stock
	..s CSPLIST(13)=User	//AuditUserDR
	..s CSPLIST(15)=Date	//AuditDate 	
	..&SQL(insert into sqluser.DHC_EQAChangeStock values :CSPLIST())
	..s CSSQLCODE=SQLCODE
	..q:CSSQLCODE'=0
	..s PLIST(2)=$G(%ROWID)
	..For i = 1:1:Num q:CSSQLCODE'=0  d
	...s AcPL(10) =##class(web.DHCEQCommon).Replace($P($g(^DHCEQAInStockList(AISLRowID,"EX","SerialNoInfo")), ",", i),$C(13,10),"")	//Mozy	1064169	2019-10-26	Mozy0227
	...;设备项插入设备表记录
	...i SourceType="1"  d
	....&SQL(insert into sqluser.DHC_EQAStockDetail values :AcPL())
	....s CSSQLCODE=SQLCODE
	....q:CSSQLCODE'=0
	....s AcRowID=$G(%ROWID)
	....s CSSQLCODE=##Class(web.DHCEQ.MP.BUSInStock).UpdateAccessoryNo(AcRowID,+$H)
	....q:CSSQLCODE'=0
	....s PLIST(3)=AcRowID
	....s PLIST(5)=Num
	....s PLIST(6)="1"
	....&SQL(insert into sqluser.DHC_EQAChangeStockDetail values :PLIST())
	....s CSSQLCODE=SQLCODE
	....q:CSSQLCODE'=0
	.e  d
	..s AcPL(10)=""
	..s AcPL(18)=Num
	..&SQL(insert into sqluser.DHC_EQAStockDetail values :AcPL())
	..s CSSQLCODE=SQLCODE
	..q:CSSQLCODE'=0
	..s AcRowID=$G(%ROWID)
	..;插入配件变动信息
	..s CSPLIST(3)=$P(^DHCEQAInStock(RowID),"^",3) //ToLocDR
	..s CSPLIST(4)=AcPL(3) //配件项
	..s CSPLIST(5)=AcPL(12) //AccessoryTypeDR
	..s CSPLIST(6)=AcPL(14) //BaseUOMDR
	..s CSPLIST(8)=Num  //BaseStock
	..s CSPLIST(9)=AcPL(9) //Price
	..s CSPLIST(10)="0" //变动类型
	..s CSPLIST(11)=AISLRowID	//变动来源
	..s CSPLIST(12)=Num //Stock
	..s CSPLIST(13)=User	//AuditUserDR
	..s CSPLIST(15)=Date	//AuditDate 	
	..
	..&SQL(insert into sqluser.DHC_EQAChangeStock values :CSPLIST())
	..s CSSQLCODE=SQLCODE
	..q:CSSQLCODE'=0
	..s PLIST(2)=$G(%ROWID)
	..s PLIST(3)=AcRowID
	..s PLIST(5)=Num
	..s PLIST(6)=Num
	..&SQL(insert into sqluser.DHC_EQAChangeStockDetail values :PLIST())
	..s CSSQLCODE=SQLCODE
	..q:CSSQLCODE'=0
	q CSSQLCODE
}

/// 描述:判断入库单类组的唯一性
/// 返回值：-7402:明细的类组不一致		-7403:明细与单据的类组不一致
/// w ##Class(web.DHCEQ.MP.BUSInStock).AccessoryTypeIsUniqueNewTypeIsUniqueNew("63","1","StoreMove")
ClassMethod AccessoryTypeIsUniqueNew(RowID, AccessoryTypeID, vType)
{
	new ResultFlag,PreAccessoryTypeID,AccessoryTypeDR
	new AISLRowID,SMLRowID,RLRowID,SourceType,SourceID
	
	s ResultFlag=0	
	s PreAccessoryTypeID=0
	s AccessoryTypeDR=""
	if (vType="InStock")	//入库单明细的判断
	{
		s AISLRowID=0
		f  s AISLRowID=$O(^DHCEQAInStockList(0,"AInStock",RowID,AISLRowID)) q:(AISLRowID="")||(ResultFlag'=0)  d
		.s SourceType=$P(^DHCEQAInStockList(AISLRowID),"^",12)
		.s SourceID=$P(^DHCEQAInStockList(AISLRowID),"^",13)
		.i SourceID="" s ResultFlag=-9000
		.q:(ResultFlag'=0)
		.;i SourceType="0" s AccessoryTypeDR=$p($g(^DHCEQAccessory(SourceID)),"^",14) 	//配件
		.i SourceType="1" s AccessoryTypeDR=$p($g(^DHCEQCCode("DHCEQCAccessory",SourceID)),"^",14)  //配件项
		.d CheckAccessoryType
	}
	i ResultFlag=-7402 q ResultFlag_"^明细的类组不一致"
	i ResultFlag=-7403 q ResultFlag_"^明细与单据的类组不一致"
	q AccessoryTypeDR	
CheckAccessoryType
	i PreAccessoryTypeID=0 s PreAccessoryTypeID=AccessoryTypeDR
	i PreAccessoryTypeID'=AccessoryTypeDR  d
	.s ResultFlag=-7402
	e  i (AccessoryTypeID'="")&&(AccessoryTypeID'=AccessoryTypeDR)  d
	.s ResultFlag=-7403
	q
}

/// 更新配件编号
/// w ##Class(web.DHCEQ.MP.BUSInStock).UpdateAccessoryNo()
ClassMethod UpdateAccessoryNo(rowid, curdate)
{
	new accessoryno
	s accessoryno = ##Class(web.DHCEQ.MP.BUSInStock).GetNextNo(rowid,curdate)
	i accessoryno="" q ""
	&SQL(Update SQLUSER.DHC_EQAStockDetail set ASD_No=:accessoryno Where ASD_RowID=:rowid)
	if SQLCODE q SQLCODE
	q 0
}

/// w ##Class(web.DHCEQ.MP.BUSInStock).GetNextNo("47", +$H)
ClassMethod GetNextNo(rowid, curdate)
{
	new accessorytype,accessorycatdr,storelocdr
	s (accessorytype,accessorycatdr,storelocdr)=""
	&SQL(select ASD_AccessoryTypeDR->AT_Code,ASD_ItemDR->A_CatDR,ASD_LocDR into :accessorytype,:accessorycatdr,:storelocdr from SQLUSER.DHC_EQAStockDetail where ASD_RowID=:rowid)
	i SQLCODE  q ""
	s accessorycatno=##Class(web.DHCEQ.MP.BUSInStock).GetAccessoryCatCode(accessorycatdr)
	///生成编号时去掉分类编码中的"-"
	;s accessorycatno=##Class(web.DHCEQCommon).Replace(accessorycatno,"-","")	
	s nextno=##Class(web.DHCEQCCounter).GetNextNo("DHC_EQCAccessory",curdate,storelocdr,accessorytype,"",accessorycatno)	
	;s nextno=##Class(web.DHCEQCCounter).GetNextNo("DHC_EQAInStock",curdate,storelocdr,"","","")
	q nextno
}

/// w ##Class(web.DHCEQ.MP.BUSInStock).GetNextNo("47")
ClassMethod GetAccessoryCatCode(accessorycatdr)
{
	new accessorycode,flag
	s accessorycode=""
	while((accessorycode="")&&(accessorycatdr'=""))
	{
		s flag=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",accessorycatdr)),"^",5)
		if flag="Y"  d 
		.s accessorycode=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",accessorycatdr)),"^",2)
		e  d
		.s accessorycatdr=$p($g(^DHCEQCCode("DHCEQCAccessoryCat",accessorycatdr)),"^",1)
	}
	q accessorycode
}

/// add by csj 2020-03-04 修改发票信息
/// ----------------------------------
/// w ##Class(web.DHCEQ.MP.BUSInStock).BillUpdateAInvoice(10)
ClassMethod BillUpdateAInvoice(AISRowID)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s AISLRowID=0
	s CSSQLCODE=0
	f  s AISLRowID=$o(^DHCEQAInStockList(0,"AInStock",AISRowID,AISLRowID)) quit:(AISLRowID="")||(CSSQLCODE'=0)  d
	.s InvoiceID=$o(^DHCEQInvoiceUseMap(0,"Source","3",AISLRowID,0))
	.i InvoiceID'="" d 
	..s InvoiceDR=$p(^DHCEQInvoiceUseMap(InvoiceID),"^",2)
	..&SQL(update sqluser.DHC_EQInvoice set IV_Status='1',IV_SubmitUserDR=:User,IV_SubmitDate=:Date,IV_SubmitTime=:Time where IV_RowID=:InvoiceDR)
	..s CSSQLCODE=SQLCODE
	..q:CSSQLCODE'=0
	q CSSQLCODE
}

/// MZY0040	1408950		2020-7-21
/// 获取配件入库单占用合同的配件数量
/// 入参RowID		配件采购合同明细ID
/// 		AISLRowID	当前配件入库明细ID
/// w ##Class(web.DHCEQ.MP.BUSInStock).GetAInListQuantity(5,"")
ClassMethod GetAInListQuantity(RowID, AISLRowID)
{
	i RowID="" q 0
	n rowid,Total
	s Total=0
	s rowid=0
	f  s rowid=$O(^DHCEQAInStockList(rowid)) q:rowid=""  d
	.q:RowID'=$p($g(^DHCEQAInStockList(rowid)),"^",25)		;AISLHold5
	.q:rowid=AISLRowID
	.q:$p($g(^DHCEQAInStock($p($g(^DHCEQAInStockList(rowid)),"^",1))),"^",16)=3		;去掉作废单据
	.s Total=Total+$p($g(^DHCEQAInStockList(rowid)),"^",9)
	
	q Total
}

}
