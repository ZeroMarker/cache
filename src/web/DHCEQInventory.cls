Import SQLUser

Class web.DHCEQInventory Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 1;

ClassMethod SaveInventory(IsDel, InventoryDR As %String = "", StoreLocDR As %String = "", UseLocDR As %String = "", EquipTypeIDs As %String = "", StatCatDR As %String = "", OriginDR As %String = "", FilterInfo As %String = "", ManageLocDR As %String = "")
{
	new user,curDate,curTime
	new InventoryNo,RowID
	
	s user=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	///modified by ZY0233 2020-06-17  院区有参数
	//s CurHospID=HospitalDR
	//i CurHospID="" s CurHospID=%session.Get("LOGON.HOSPID")	//20170103 Mozy0174
	
	s curDate=+$H
	s curTime=+$p($H,",",2)
	
	TStart
	
	k PLIST	
	s PLIST(3)=StoreLocDR
	s PLIST(4)=UseLocDR
	s PLIST(5)=EquipTypeIDs
	s PLIST(6)=StatCatDR
	s PLIST(7)=OriginDR
	s PLIST(15)=ManageLocDR //2010-11-04 DJ
	s PLIST(11)=0
	///modified by ZY0233 2020-06-17  增加字段信息
	s PLIST(16)=HospitalDR	;//20170103 Mozy0174
	s PLIST(17)=##class(web.DHCEQCommon).TransValueFromPage(ExpectDate,"date")
	s PLIST(21)=SelfFlag
	s PLIST(22)=LocIncludeFlag
	
	if InventoryDR=""
	{
		s InventoryNo=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQInventory",+$H)
		s PLIST(2)=InventoryNo
		s PLIST(8)=curDate
		s PLIST(9)=curTime
		s PLIST(10)=user
		&SQL(Insert into sqluser.DHC_EQInventory values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			q "-1^"_SQLCODE
		}
		s RowID=$G(%ROWID)
		//保存过滤条件
		if FilterInfo'=""
		{
			s Count=$l(FilterInfo,"|")
			s Flag=0
			for i=1:1:Count
			{
				s IFI(2)=RowID
				s IFI(3)=$p($p(FilterInfo,"|",i),":",1)
				s IFI(4)=$p($p(FilterInfo,"|",i),":",2)
				&SQL(Insert into sqluser.DHC_EQInventoryFilterInfo values :IFI())
				i SQLCODE
				{
					s Flag=1
					s i=Count+1
				}
			}
			i Flag=1
			{
				TROLLBACK
				q "-1^保存过滤条件失败"
			}
		}
	}
	else
	{
		s RowID=InventoryDR
		&SQL(Update sqluser.DHC_EQInventory values :PLIST() Where I_RowID=:InventoryDR)
		i SQLCODE
		{
			TROLLBACK
			q "-1^"_SQLCODE
		}
		//更新过滤条件
		if FilterInfo'=""
		{
			s IFICount=0
			s Count=$l(FilterInfo,"|")
			s Flag=0
			for i=1:1:Count
			{
				s IFI(2)=InventoryDR
				s IFI(3)=$p($p(FilterInfo,"|",i),":",1)
				s IFI(4)=$p($p(FilterInfo,"|",i),":",2)
				&SQL(Select Count(*) Into :IFICount From sqluser.DHC_EQInventoryFilterInfo Where IFI_InventoryDR=:InventoryDR and IFI_InventoryCondition=:IFI(3))
				i IFICount<=0
				{
					&SQL(Insert into sqluser.DHC_EQInventoryFilterInfo values :IFI())
				}
				else
				{
					&SQL(Update sqluser.DHC_EQInventoryFilterInfo values :IFI() Where IFI_InventoryDR=:InventoryDR and IFI_InventoryCondition=:IFI(3))
				}
				i SQLCODE
				{
					s Flag=1
					s i=Count+1
				}
			}
			i Flag=1
			{
				TROLLBACK
				q "-1^更新过滤条件失败"
			}
		}
	}
	
	i SQLCODE
	{
		TROLLBACK
		q "-1^"_SQLCODE
	}
	else
	{
		TCommit
		q "0^"_RowID_"^"
	}
}

/// 帐盘
/// Modified By QW20180927 bug号:QW0015 增加预报废判断
ClassMethod FreezeInventory(InventoryDR As %String, StoreLocDR As %String = "", UseLocDR As %String = "", EquipTypeIDs As %String = "", StatCatDR As %String = "", OriginDR As %String = "", FilterInfo As %String = "", ManageLocDR As %String = "", QXType As %String = "", HospitalDR As %String = "", ExpectDate As %String = "", SelfFlag As %String = "", LocIncludeFlag As %String = "")
{
	new user,curDate,curTime,IncludeFlag  ;Modified By QW20180927 bug号:QW0015
	new rowid
	new StockStatus
	
	if (InventoryDR="") q ""
	
	s user=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set CurGroupID=%session.Get("LOGON.GROUPID")
	///modified by ZY0233 2020-06-17  院区有参数
	s CurHospID=HospitalDR
	i CurHospID="" s CurHospID=%session.Get("LOGON.HOSPID")	//20170103 Mozy0174
	
	s curDate=+$H
	s curTime=+$p($H,",",2)
	s InventoryNo=""
	
	TStart
	k PLIST
	//2010-11-03 DJ begin
	s PLIST(3)=StoreLocDR
	s PLIST(4)=UseLocDR
	s PLIST(5)=EquipTypeIDs
	s PLIST(6)=StatCatDR
	s PLIST(7)=OriginDR
	s PLIST(11)=1
	s PLIST(15)=ManageLocDR
	s PLIST(16)=CurHospID	;//20170103 Mozy0174
	s PLIST(18)=curDate
	s PLIST(19)=curTime
	s PLIST(20)=user
	
	///modified by ZY0233 2020-06-17  增加字段信息
	s PLIST(17)=##class(web.DHCEQCommon).TransValueFromPage(ExpectDate,"date")
	s PLIST(21)=SelfFlag
	s PLIST(22)=LocIncludeFlag
	
	&SQL(Update sqluser.DHC_EQInventory values :PLIST() where I_RowID=:InventoryDR)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	//更新过滤条件 2010-11-03 DJ
	if FilterInfo'=""
	{
		s IFICount=0
		s Count=$l(FilterInfo,"|")
		s Flag=0
		for i=1:1:Count
		{
			s IFI(2)=InventoryDR
			s IFI(3)=$p($p(FilterInfo,"|",i),":",1)
			s IFI(4)=$p($p(FilterInfo,"|",i),":",2)
			&SQL(Select Count(*) Into :IFICount From sqluser.DHC_EQInventoryFilterInfo Where IFI_InventoryDR=:InventoryDR and IFI_InventoryCondition=:IFI(3))
			i IFICount<=0
			{
				&SQL(Insert into sqluser.DHC_EQInventoryFilterInfo values :IFI())
			}
			else
			{
				&SQL(Update sqluser.DHC_EQInventoryFilterInfo values :IFI() Where IFI_InventoryDR=:InventoryDR and IFI_InventoryCondition=:IFI(3))
			}
			i SQLCODE
			{
				s Flag=1
				s i=Count+1
			}
		}
		i Flag=1
		{
			TROLLBACK
			q SQLCODE
		}
	}
	
	k PLIST
	s PLIST(2)=InventoryDR
	
	s EquipTypeIDs=","_EquipTypeIDs_","
	//Add By QW20180927 bug号:QW0015增加参数判断盘点是否包含预报废设备
	s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")

	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:((rowid="")||(SQLCODE'=0))  d
	.Set TInvalidFlag = $Piece($Get(^DHCEQEquip(rowid)),"^",59)
	.Quit:TInvalidFlag'="N"
	.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	.q:((StockStatus=0)||(StockStatus=3))		///尚未入库或已经出库的设备
	.q:$p($g(^DHCEQEquip(rowid)),"^",38)=3		///报废的设备
	.//q:((EquipTypeDR'="")&&(EquipTypeDR'=$p($g(^DHCEQEquip(rowid)),"^",63)))
	.s TEquipTypeDR=","_$p($g(^DHCEQEquip(rowid)),"^",63)_","
	.q:EquipTypeIDs'[TEquipTypeDR
	.q:((StatCatDR'="")&&(StatCatDR'=$p($g(^DHCEQEquip(rowid)),"^",75)))
	.///modified by ZY0233 2020-06-17  增加是否包含子科室和院区的条件
	.;q:((StoreLocDR'="")&&(StoreLocDR'=$p($g(^DHCEQEquip(rowid)),"^",67)))
	.s TStoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
	.q:((LocIncludeFlag'="1")&&(StoreLocDR'="")&&(StoreLocDR'=TStoreLocDR))
	.q:((LocIncludeFlag="1")&&(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,TStoreLocDR,"1")'="1"))
	.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
	.q:((HospitalDR'="")&&(HospitalDR'=THospitalDR))
	.
	.Quit:(##Class(web.DHCEQCommon).CheckManageLimit(user,CurGroupID,"",$p($g(^DHCEQEquip(rowid)),"^",63),$p($g(^DHCEQEquip(rowid)),"^",75),$p($g(^DHCEQEquip(rowid)),"^",4),$p($g(^DHCEQEquip(rowid)),"^",67),rowid,$p($g(^DHCEQEquip(rowid)),"^",7)))
	.s Flag=0
	.i ($p($g(^DHCEQEquip(rowid)),"^",67)'="")  d
	..s Flag=##class(web.DHCEQCommon).LocIsInEQ(QXType,$p($g(^DHCEQEquip(rowid)),"^",67))
	.q:Flag'=0
	.q:((UseLocDR'="")&&(UseLocDR'=$p($g(^DHCEQEquip(rowid)),"^",19)))
	.q:((OriginDR'="")&&(OriginDR'=$p($g(^DHCEQEquip(rowid)),"^",20)))
	.//Add By QW20180927 bug号:QW0015增加参数判断盘点是否包含预报废设备
	.Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(rowid)),"^",93)="2")
	.s PLIST(3)=rowid								///BillEquipDR
	.s PLIST(5)=$p($g(^DHCEQEquip(rowid)),"^",67)	///StoreLocDR
	.s PLIST(6)=$p($g(^DHCEQEquip(rowid)),"^",19)	///UseLocDR
	.s PLIST(9)=+$p($g(^DHCEQEquip(rowid)),"^",27)	///OriginalFee
	.s PLIST(10)=+$p($g(^DHCEQEquip(rowid)),"^",28)	///NetFee
	.s PLIST(11)=+$p($g(^DHCEQEquip(rowid)),"^",35)	///DepreTotalFee
	.s PLIST(15)=""
	.;-------------------------------------------------------------
	.s TEquipName=$p($g(^DHCEQEquip(rowid)),"^",1)
	.s OriginalFee=$p($g(^DHCEQEquip(rowid)),"^",27)
	.s TransassetDate=$p($g(^DHCEQEquip(rowid)),"^",45)
	.s InStockListDR=$p($g(^DHCEQEquip(rowid)),"^",70)
	.i (TransassetDate="")&&(InStockListDR'="")  d
	..s ISRowID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
	..i ISRowID'="" s TransassetDate=$p($g(^DHCEQInStock(ISRowID)),13)
	.s (FName,FOriginalFeeS,FOriginalFeeE,FStartDate,FEndDate)=""
	.s ConditionName=0
	.f  s ConditionName=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditionName)) q:ConditionName=""  d
	..s ID=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditionName,0))
	..s FValue=$p($g(^DHCEQInventoryFilterInfo(ID)),"^",3)
	..i ConditionName="EquipName" s FName=$ZCONVERT(FValue,"U")
	..i ConditionName="OriginalFeeStart" s FOriginalFeeS=FValue
	..i ConditionName="OriginalFeeEnd" s FOriginalFeeE=FValue
	..i (ConditionName="StartDate") s FStartDate=##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")  ;Modified by QW20170302日期格式统一调整 原&&(FValue'="") s FStartDate=$ZDH(FValue,4)
	..i (ConditionName="EndDate")  s FEndDate=##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")  ;Modified by QW20170302日期格式统一调整 原&&(FValue'="") s FEndDate=$ZDH(FValue,4)
	.q:(FName'="")&&(TEquipName'[FName)
	.q:(FOriginalFeeS'="")&&(OriginalFee<FOriginalFeeS)
	.q:(FOriginalFeeE'="")&&(OriginalFee>FOriginalFeeE)
	.q:(FStartDate'="")&&(TransassetDate<FStartDate)
	.q:(FEndDate'="")&&(TransassetDate>FEndDate)
	.
	.&SQL(Insert into sqluser.DHC_EQInventoryList values :PLIST())
	.q:SQLCODE'=0
	///modified by ZY0233 2020-06-17
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s SQLCODE=##class(web.DHCEQInventory).UpdateInventoryAudit(InventoryDR)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCommit
	q SQLCODE
}

/// modified by ZY0233 2020-06-17
/// 盘点冻结的时候生成盘点审核信息表数据
ClassMethod UpdateInventoryAudit(InventoryDR)
{
	new BillStoreLocDR,TotalNum,DiffeNum,ProfitNum,LoseNum,NotInventoryNum,BillEquipDR,rowid,SQLCODE
	k IAPLIST
	s IAPLIST(2)=InventoryDR
	s (BillStoreLocDR,SQLCODE)=0
	f  s BillStoreLocDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,BillStoreLocDR))  quit:((BillStoreLocDR="")||(SQLCODE'=0))  d
	.s (TotalNum,DiffeNum,ProfitNum,LoseNum,NotInventoryNum)=0
	.s BillEquipDR=0
	.f  s BillEquipDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,BillStoreLocDR,BillEquipDR))  quit:((BillEquipDR=""))  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,BillStoreLocDR,BillEquipDR,rowid))  quit:((rowid=""))  d
	...s TotalNum=TotalNum+1
	...///1:账物一致|2:科室不符|3:盘亏|4:盘盈
	...s TStatus=+$p($g(^DHCEQInventoryList(rowid)),"^",14)
	...i TStatus=0  d
	....s NotInventoryNum=NotInventoryNum+1
	...e  i TStatus=2  d
	....s DiffeNum=DiffeNum+1
	...e  i TStatus=3  d
	....s ProfitNum=ProfitNum+1
	...e  i TStatus=4  d
	....s LoseNum=LoseNum+1
	.///写数据
	.s IAPLIST(3)=BillStoreLocDR
	.s IAPLIST(4)=TotalNum	//账目数量
	.s IAPLIST(5)=DiffeNum	//差异数量
	.s IAPLIST(6)=ProfitNum	//盘盈数量
	.s IAPLIST(7)=LoseNum	//盘亏数量
	.s IAPLIST(8)=NotInventoryNum	//未盘数量
	.s IAPLIST(9)=0
	.s IAPLIST(10)=""	//remark
	.s IAPLIST(11)=""	//Hold1
	.s IAPLIST(12)=""	//Hold2
	.s IAPLIST(13)=""	//Hold3
	.s IAPLIST(14)=""	//Hold4
	.s IAPLIST(15)=""	//Hold5
	.s tmp=""
	.&SQL(select IA_RowID into :tmp from sqluser.DHC_EQInventoryAudit where IA_InventoryDR=:IAPLIST(2) and IA_LocDR=:IAPLIST(3))
	.i tmp="" d
	..&SQL(Insert into sqluser.DHC_EQInventoryAudit values :IAPLIST())
	.e  d
	..&SQL(update sqluser.DHC_EQInventoryAudit values :IAPLIST() where IA_RowID=:tmp)
	q SQLCODE
}

/// Mozy0254		1099780		2020-3-5	增加库房参数StoreLocDR
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","QueryInventory")
Query QueryInventory(BeginDate As %String, EndDate As %String, InventoryNo As %String, QXType As %String = "", StatusDR As %String = "", ReadOnly As %String = "", HospitalDR As %String = "", StoreLocDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TInventoryNo:%String,TStoreLocDR:%String,TUseLocDR:%String,TEquipTypeDR:%String,TStatCatDR:%String,TOriginDR:%String,TDate:%String,TTime:%String,TUserDR:%String,TStatus:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TFreezeDate:%String,TFreezeTime:%String,TFreezeUser:%String,TStoreLoc:%String,TUseLoc:%String,TEquipType:%String,TStatCat:%String,TOrigin:%String,TManageLoc:%String,TRow:%String,THospital:%String")
{
}

ClassMethod QueryInventoryExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, InventoryNo As %String, QXType As %String = "", StatusDR As %String = "", ReadOnly As %String = "", HospitalDR As %String = "", StoreLocDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s TRow=0
	s data=""
	;s CurHospID=%session.Get("LOGON.HOSPID")
	i BeginDate="" s BeginDate=0
	e  s BeginDate=##class(web.DHCEQCommon).TransValueFromPage(BeginDate,"date")  //HISUI改造 add by MWZ 2018-10-10
	i EndDate="" s EndDate=+$H
	e  s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")  //HISUI改造 add by MWZ 2018-10-10
	
	s rowid=0
	f  s rowid=$o(^DHCEQInventory(rowid))  quit:rowid=""  d
	.d ResetVariablesQueryInventory
	.s data=$g(^DHCEQInventory(rowid))
	.s TRowID=rowid
	.s TInventoryNo=$p(data,"^",1)
	.
	.q:((InventoryNo'="")&&(TInventoryNo'[InventoryNo))
	.s TStoreLocDR=$p(data,"^",2)
	.;Mozy0254		1099780		2020-3-5
	.q:(StoreLocDR'="")&&(TStoreLocDR'=StoreLocDR)
	.;quit:((CurHospID'="")&&($p(data,"^",15)'=CurHospID)) ;QW20161214 分院区
	.s TUseLocDR=$p(data,"^",3)
	.s TEquipTypeDR=$p(data,"^",4)
	.//Start Add By HZY 2013-12-10 HZY0042 过滤类组
	.s qFlag=0
	.i TEquipTypeDR'="" d
	..s length=$L(TEquipTypeDR,",")
	..f i=1:1:length q:qFlag=1  d
	...s EquipTypeDR=$p(TEquipTypeDR,",",i)
	...i (0'=##class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,CurGroupID))  d  
	....s qFlag=1
	.q:qFlag=1
	.//End Add By HZY 2013-12-10 HZY0042 过滤类组
	.s TStatCatDR=$p(data,"^",5)
	.s TOriginDR=$p(data,"^",6)
	.s TDate=$p(data,"^",7)
	.
	.q:((BeginDate'="")&&(BeginDate>TDate))
	.q:((EndDate'="")&&(EndDate<TDate))
	.s TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date") ;Modified by QW20170302日期格式统一调整 原i TDate'="" s TDate=$ZD(TDate,3)
	.s TTime=$p(data,"^",8)
	.s TTime=##Class(web.DHCEQCommon).TransValueToPage(TTime,"time") ;Modified by QW20170302日期格式统一调整 原i TTime'="" s TTime=$ZT(TTime)
	.s TUserDR=$p(data,"^",9)
	.s TStatus=$p(data,"^",10)
	.quit:(StatusDR'="")&(StatusDR'=TStatus)	//modified by zy 2015-08-25 ZY0136
	.s TStatus=##Class(web.DHCEQInStockNew).GetInStockStatus(TStatus)
	.s TRemark=$p(data,"^",11)
	.s THold1=$p(data,"^",12)
	.s THold2=$p(data,"^",13)
	.s THold3=$p(data,"^",14)
	.s Flag=0 //2010-11-04 DJ begin
	.i THold3'=""  d
	..s Flag=##class(web.DHCEQCommon).LocIsInEQ(QXType,THold3,CurLocID)
	..s TManageLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",THold3)
	.q:Flag'=0 //2010-11-04 DJ end
	.s THold4=$p(data,"^",15)
	.s THold5=$p(data,"^",16)
	.s TFreezeDate=$p(data,"^",17)
	.s TFreezeDate=##class(web.DHCEQCommon).TransValueToPage(TFreezeDate,"date") ;Modified by QW20170302日期格式统一调整 原i TFreezeDate'="" s TFreezeDate=$ZD(TFreezeDate,3)
	.s TFreezeTime=$p(data,"^",18)
	.s TFreezeTime=##Class(web.DHCEQCommon).TransValueToPage(TFreezeTime,"time") ;Modified by QW20170302日期格式统一调整 原i TFreezeTime'="" s TFreezeTime=$ZT(TFreezeTime)
	.s TFreezeUser=$p(data,"^",19)
	.i TFreezeUser'="" s TFreezeUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TFreezeUser)
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	.s TRow=TRow+1		//Add By DJ 2015-09-21 DJ0165
	.// Mozy0251	1099778		2020-3-2
	.s THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
	.i THospitalDR="" s THospitalDR=$p(data,"^",15)		;未选择库房的盘点单取建单院区
	.q:(HospitalDR'="")&&(HospitalDR'=THospitalDR)
	.s THospital=$p($g(^CT("HOSP",+THospitalDR)),"^",2)
	.d OutputRowQueryInventory
	
	Quit $$$OK

OutputRowQueryInventory
	Set Data=$lb(TRowID,TInventoryNo,TStoreLocDR,TUseLocDR,TEquipTypeDR,TStatCatDR,TOriginDR,TDate,TTime,TUserDR,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TFreezeDate,TFreezeTime,TFreezeUser,TStoreLoc,TUseLoc,TEquipType,TStatCat,TOrigin,TManageLoc,TRow,THospital)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesQueryInventory
	s (TRowID,TInventoryNo,TStoreLocDR,TUseLocDR,TEquipTypeDR,TStatCatDR,TOriginDR,TDate,TTime,TUserDR,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TFreezeDate,TFreezeTime,TFreezeUser,TStoreLoc,TUseLoc,TEquipType,TStatCat,TOrigin,TManageLoc,THospital)=""
	quit
}

ClassMethod QueryInventoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInventoryExecute ]
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

ClassMethod QueryInventoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInventoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryInventoryList(InventoryDR) As %Query(ROWSPEC = "TRowID:%String,TInventoryDR:%String,TBillEquipDR:%String,TActerEquipDR:%String,TBillStoreLocDR:%String,TBillUseLocDR:%String,TActerStoreLocDR:%String,TActerUseLocDR:%String,TBillOriginalFee:%String,TBillNetFee:%String,TBillDepreTotalFee:%String,TUserDR:%String,TDate:%String,TTime:%String,TStatus:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TBillName:%String,TActerName:%String,TBillNo:%String,TActerNo:%String")
{
	Select IL_RowID TRowID,IL_InventoryDR TInventoryDR,
		   IL_BillEquipDR TBillEquipDR,IL_ActerEquipDR TActerEquipDR,
		   IL_BillStoreLocDR TBillStoreLocDR,IL_BillUseLocDR TBillUseLocDR,
		   IL_ActerStoreLocDR TActerStoreLocDR,IL_ActerUseLocDR TActerUseLocDR,
		   IL_BillOriginalFee TBillOriginalFee,IL_BillNetFee TBillNetFee,
		   IL_BillDepreTotalFee TBillDepreTotalFee,IL_UserDR TTUserDR,
		   IL_Date TDate,IL_Time TTime,IL_Status TStatus,
		   IL_Remark TRemark,IL_Hold1 THold1,IL_Hold2 THold2,IL_Hold3 THold3,
		   IL_Hold4 THold4,IL_Hold5 THold5,
		   IL_BillEquipDR->EQ_Name TBillName,IL_ActerEquipDR->EQ_Name TActerName,
		   IL_BillEquipDR->EQ_No TBillNo,IL_ActerEquipDR->EQ_No TActerNo
	from sqluser.DHC_EQInventoryList Where IL_InventoryDR=:InventoryDR
}

/// modified by ZY0233 2020-06-17  增加是否包含子科室和院区的条件
/// ;Modified By QW20180313 需求号:551829 历史盘点单(StatusDR=2)时 显示全部盘点设备;改变d OutputRowQueryList位置
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","QueryList","","","","1,2,3,4")
Query QueryList(InventoryDR As %String = "", StoreLocDR As %String = "", UseLocDR As %String = "", EquipTypeIDs As %String = "", StatCatDR As %String = "", OriginDR As %String = "", onlyShowDiff As %String = "", FilterInfo As %String = "", ManageLocDR As %String = "", QXType As %String = "", StatusDR As %String = "", ReadOnly As %String = "", EquipTypes As %String = "", StoreLoc As %String = "", HospitalDR As %String = "", LocIncludeFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TInventoryDR:%String,TBillEquipDR:%String,TActerEquipDR:%String,TBillStoreLocDR:%String,TBillUseLocDR:%String,TActerStoreLocDR:%String,TActerUseLocDR:%String,TBillOriginalFee:%String,TBillNetFee:%String,TBillDepreTotalFee:%String,TUserDR:%String,TDate:%String,TTime:%String,TStatus:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TBillName:%String,TActerName:%String,TBillNo:%String,TActerNo:%String,TModel:%String,TEquiCat:%String,TEquipType:%String,TStatCat:%String,TUnit:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TProvider:%String,TLimitYearsNum:%String,TDepreMethod:%String,TEquipRemark:%String,TBillStoreLoc:%String,TBillUseLoc:%String,TActerStoreLoc:%String,TActerUseLoc:%String,TManuFactory:%String,TOrigin:%String,TUser:%String,TJob:%String,TPlace:%String,TResultType:%String,TRow:%String,TFileNo:%String,TStartDate:%String,TNum:%String,TAdvanceDisFlag:%String,TKeeperDR:%String,TKeeper:%String,TLocationDR:%String,TLocation:%String") [ SqlProc ]
{
}

ClassMethod QueryListExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", StoreLocDR As %String = "", UseLocDR As %String = "", EquipTypeIDs As %String = "", StatCatDR As %String = "", OriginDR As %String = "", onlyShowDiff As %String = "", FilterInfo As %String = "", ManageLocDR As %String = "", QXType As %String = "", StatusDR As %String = "", ReadOnly As %String = "", EquipTypes As %String = "", StoreLoc As %String = "", HospitalDR As %String = "", LocIncludeFlag As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
	s index=1
	s Tmpindex=1
	s rowid=0
	s TRow=0
	new tmpNode,IncludeFlag
	new TRowID,TInventoryDR,TBillEquipDR,TActerEquipDR,TBillStoreLocDR,TBillUseLocDR,TActerStoreLocDR,TActerUseLocDR,TBillOriginalFee,TBillNetFee,TBillDepreTotalFee,TUserDR,TDate,TTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TBillName,TActerName,TBillNo,TActerNo
	new TModel,TEquiCat,TEquipType,TStatCat,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TProvider,TLimitYearsNum,TDepreMethod,TEquipRemark
	new TBillStoreLoc,TBillUseLoc,TActerStoreLoc,TActerUseLoc,TManuFactory,TOrigin,TUser,TPlace
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set CurGroupID=%session.Get("LOGON.GROUPID")
	s Job=$j
	k ^DHCEQTemp("DHCEQInventoryListInfo",curuser,+$H,Job)
	s gnum=1
	
	//增加参数判断盘点是否包含预报废设备，直接取EQ_Hold8字段的值来判断设备的预报废
	s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")	//盘点是否包含预报废设备
	
	s tmpNode="InventoryList"
	d ##Class(web.DHCEQCommon).KillTempGlobal(tmpNode)
	Set FilterInfo=##Class(web.DHCEQCommon).UnEscape(FilterInfo)
	if ((InventoryDR'="")&&(+$p($g(^DHCEQInventory(InventoryDR)),"^",10)>0))
	{
		s rowid=0
		f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid))  quit:((rowid=""))  d
		.d ResetVarQueryList
		.s TRowID=rowid
		.s TInventoryDR=InventoryDR
		.s TBillEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
		.s TActerEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",3)
		.s TBillStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",4)
		.s TBillUseLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",5)
		.s TActerStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",6)
		.s TActerUseLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",7)
		.s TBillOriginalFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryList(rowid)),"^",8),"")
		.s TBillNetFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryList(rowid)),"^",9),"")
		.s TBillDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQInventoryList(rowid)),"^",10),"")
		.s TUserDR=$p($g(^DHCEQInventoryList(rowid)),"^",11)
		.s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
		.s TDate=$p($g(^DHCEQInventoryList(rowid)),"^",12)
		.s TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date") ;Modified by QW20170302日期格式统一调整 原i TDate'="" s TDate=$ZD(TDate,3)
		.s TTime=$p($g(^DHCEQInventoryList(rowid)),"^",13)
		.s TTime=##Class(web.DHCEQCommon).TransValueToPage(TTime,"time") ;Modified by QW20170302日期格式统一调整 原i TTime'="" s TTime=$ZT(TTime)
		.s TStatus=$p($g(^DHCEQInventoryList(rowid)),"^",14)
		.s TRemark=$p($g(^DHCEQInventoryList(rowid)),"^",15)
		.s THold1=$p($g(^DHCEQInventoryList(rowid)),"^",16)
		.s THold2=$p($g(^DHCEQInventoryList(rowid)),"^",17)
		.s THold3=$p($g(^DHCEQInventoryList(rowid)),"^",18)
		.s THold4=$p($g(^DHCEQInventoryList(rowid)),"^",19)
		.s THold5=$p($g(^DHCEQInventoryList(rowid)),"^",20)
		.
		.s diffFlag=0
		.i onlyShowDiff="on"  d
		..i TBillEquipDR="" s diffFlag=1
		..i TActerEquipDR="" s diffFlag=1
		..i TBillStoreLocDR'=TActerStoreLocDR s diffFlag=1
		..///i TBillUseLocDR'=TActerUseLocDR s diffFlag=1
		.q:((onlyShowDiff="on")&&(diffFlag'=1))
		.
		.s EquipDR=TBillEquipDR
		.if TBillEquipDR="" s EquipDR=TActerEquipDR
		.s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
		.///modified by ZY0233 2020-06-17
		.s FindILIRowID=""
		.s ILIRowID=0
		.f  s ILIRowID=$o(^DHCEQInventoryListInfo(0,"InventoryList",rowid,ILIRowID))  q:ILIRowID=""||ILIRowID'=""  d
		..q:$p($g(^DHCEQInventoryListInfo(ILIRowID)),"^",5)="Y"
		..s FindILIRowID=ILIRowID
		.
		.d FillEquipInfo	
	}
	else
	{
		s EquipTypeIDs=","_EquipTypeIDs_","
		s rowid=0
		f  s rowid=$o(^DHCEQEquip(rowid))  quit:((rowid=""))  d
		.;2013-11-11  Mozy0112	过滤无效设备
		.Set EQInvalidFlag=$Piece($Get(^DHCEQEquip(rowid)),"^",59)
		.Quit:EQInvalidFlag'="N"
		.s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
		.q:((StockStatus=0)||(StockStatus=3))		///尚未入库或已经出库的设备
		.q:$p($g(^DHCEQEquip(rowid)),"^",38)=3		///报废的设备
		.
		.//q:((EquipTypeDR'="")&&(EquipTypeDR'=$p($g(^DHCEQEquip(rowid)),"^",63)))
		.s TEquipTypeDR=","_$p($g(^DHCEQEquip(rowid)),"^",63)_","
		.q:EquipTypeIDs'[TEquipTypeDR
		.q:((StatCatDR'="")&&(StatCatDR'=$p($g(^DHCEQEquip(rowid)),"^",75)))
		.///modified by ZY0233 2020-06-17  增加是否包含子科室和院区的条件
		.;q:((StoreLocDR'="")&&(StoreLocDR'=$p($g(^DHCEQEquip(rowid)),"^",67)))
		.s TStoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
		.q:((LocIncludeFlag'="1")&&(StoreLocDR'="")&&(StoreLocDR'=TStoreLocDR))
		.q:((LocIncludeFlag="1")&&(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,TStoreLocDR,"1")'="1"))
		.Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)
		.q:((HospitalDR'="")&&(HospitalDR'=THospitalDR))
		.
		.Quit:(##Class(web.DHCEQCommon).CheckManageLimit(curuser,CurGroupID,"",$p($g(^DHCEQEquip(rowid)),"^",63),$p($g(^DHCEQEquip(rowid)),"^",75),$p($g(^DHCEQEquip(rowid)),"^",4),$p($g(^DHCEQEquip(rowid)),"^",67),rowid,$p($g(^DHCEQEquip(rowid)),"^",7)))
		.s Flag=0
		.i ($p($g(^DHCEQEquip(rowid)),"^",67)'="")  d
		..s Flag=##class(web.DHCEQCommon).LocIsInEQ(QXType,$p($g(^DHCEQEquip(rowid)),"^",67))
		.q:Flag'=0
		.q:((UseLocDR'="")&&(UseLocDR'=$p($g(^DHCEQEquip(rowid)),"^",19)))
		.q:((OriginDR'="")&&(OriginDR'=$p($g(^DHCEQEquip(rowid)),"^",20)))
		.d ResetVarQueryList
		.s TInventoryDR=InventoryDR
		.s TBillEquipDR=rowid
		.s TBillStoreLocDR=$p($g(^DHCEQEquip(rowid)),"^",67)
		.s TBillUseLocDR=$p($g(^DHCEQEquip(rowid)),"^",19)
		.s TBillOriginalFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQEquip(rowid)),"^",27),"")
		.s TBillNetFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQEquip(rowid)),"^",28),"")
		.s TBillDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(+$p($g(^DHCEQEquip(rowid)),"^",35),"")
		.
		.s EquipDR=rowid
		.q:EquipDR=""	//2010-05-26 党军 begin
		.s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
		.s EqCode=$ZCONVERT($p($g(^DHCEQEquip(EquipDR)),"^",6),"U")
		.s OriginalFee=$p($g(^DHCEQEquip(EquipDR)),"^",27)
		.s TransassetDate=$p($g(^DHCEQEquip(EquipDR)),"^",45)
		.s InStockListDR=$p($g(^DHCEQEquip(EquipDR)),"^",70)
		.i (TransassetDate="")&&(InStockListDR'="")  d
		..s ISRowID=$p($g(^DHCEQInStockList(InStockListDR)),"^",1)
		..i ISRowID'="" s TransassetDate=$p($g(^DHCEQInStock(ISRowID)),13)
		.s (FName,FOriginalFeeS,FOriginalFeeE,FStartDate,FEndDate)=""
		.i FilterInfo'="" d
		..s FName=$ZCONVERT($p($p(FilterInfo,"|",1),":",2),"U")
		..s FOriginalFeeS=$p($p(FilterInfo,"|",2),":",2)
		..s FOriginalFeeE=$p($p(FilterInfo,"|",3),":",2)
		..s FStartDate=##class(web.DHCEQCommon).TransValueFromPage($p($p(FilterInfo,"|",4),":",2),"date")  ;Modified by QW20170302日期格式统一调整 原i $p($p(FilterInfo,"|",4),":",2)'="" s FStartDate=$ZDH($p($p(FilterInfo,"|",4),":",2),4)
		..s FEndDate=##class(web.DHCEQCommon).TransValueFromPage($p($p(FilterInfo,"|",5),":",2),"date")  ;Modified by QW20170302日期格式统一调整 原i $p($p(FilterInfo,"|",5),":",2)'="" s FEndDate=$ZDH($p($p(FilterInfo,"|",5),":",2),4)
		.e  d
		..i InventoryDR'=""  d
		...s ConditionName=0
		...f  s ConditionName=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditionName)) q:ConditionName=""  d
		....s ID=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditionName,0))
		....s FValue=$p($g(^DHCEQInventoryFilterInfo(ID)),"^",3)
		....i ConditionName="EquipName" s FName=$ZCONVERT(FValue,"U")
		....i ConditionName="OriginalFeeStart" s FOriginalFeeS=FValue
		....i ConditionName="OriginalFeeEnd" s FOriginalFeeE=FValue
		....i (ConditionName="StartDate")  s FStartDate=##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")  ;Modified by QW20170302日期格式统一调整 原&&(FValue'="") s FStartDate=$ZDH(FValue,4)
		....i (ConditionName="EndDate")  s FEndDate= ##class(web.DHCEQCommon).TransValueFromPage(FValue,"date")  ;Modified by QW20170302日期格式统一调整 原&&(FValue'="") s FEndDate=$ZDH(FValue,4)
		.q:(FName'="")&&(TEquipName'[FName)
		.q:(FOriginalFeeS'="")&&(OriginalFee<FOriginalFeeS)
		.q:(FOriginalFeeE'="")&&(OriginalFee>FOriginalFeeE)
		.q:(FStartDate'="")&&(TransassetDate<FStartDate)
		.q:(FEndDate'="")&&(TransassetDate>FEndDate) //2010-05-26 党军 end
		.d FillEquipInfo
	}
	Quit $$$OK
	
FillEquipInfo
	q:EquipDR=""
	//add by zy 2013-06-04 zy0107
	//增加参数判断盘点是否包含预报废设备，直接取EQ_Hold8字段的值来判断设备的预报废
	Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(EquipDR)),"^",93)="2")
	
	s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s TEquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	s TModel=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	i TModel '=""  s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	s TEquiCat=$p($g(^DHCEQEquip(EquipDR)),"^",4)
	i TEquiCat'="" s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCat)),"^",2)
	s TEquipType=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	i TEquipType '=""  s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipType)),"^",2)
	s TStatCat=$p($g(^DHCEQEquip(EquipDR)),"^",75)
	i TStatCat'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCat)),"^",2)
	s TUnit = $p($g(^DHCEQEquip(EquipDR)),"^",5) 
	i TUnit '="" s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	s TLeaveFactoryNo = $p($g(^DHCEQEquip(EquipDR)),"^",10)
	s TLeaveFactoryDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipDR)),"^",11),"date")
	s TProvider = $p($g(^DHCEQEquip(EquipDR)),"^",25)
	i TProvider '="" s TProvider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	s TLimitYearsNum = $p($g(^DHCEQEquip(EquipDR)),"^",31)
	s TDepreMethod = $p($g(^DHCEQEquip(EquipDR)),"^",33)
	i TDepreMethod '="" s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethod)),"^",2)
	s TEquipRemark = $p($g(^DHCEQEquip(EquipDR)),"^",34)
	
	i TBillEquipDR'="" s TBillName=$p($g(^DHCEQEquip(TBillEquipDR)),"^",1)
	i TActerEquipDR'="" s TActerName=$p($g(^DHCEQEquip(TActerEquipDR)),"^",1)
	i TBillEquipDR'="" s TBillNo=$p($g(^DHCEQEquip(TBillEquipDR)),"^",71)
	i TActerEquipDR'="" s TActerNo=$p($g(^DHCEQEquip(TActerEquipDR)),"^",71)
	
	i TBillEquipDR=""
	{
		s TBillName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
		s TBillNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	}
	s TBillStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillStoreLocDR)
	s TBillUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillUseLocDR)
	s TActerStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerStoreLocDR)
	s TActerUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerUseLocDR)
	s TManuFactory = $p($g(^DHCEQEquip(EquipDR)),"^",26)
	i TManuFactory '="" s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactory) //CZF0093
	s TOrigin = $p($g(^DHCEQEquip(EquipDR)),"^",20)
	i TOrigin '="" s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOrigin)),"^",2)
	Set TFileNo=$Piece($Get(^DHCEQEquip(EquipDR)),"^",85)
	s TPlace=$p($g(^DHCEQEquip(EquipDR)),"^",72)
	s TStartDate=$p($g(^DHCEQEquip(EquipDR)),"^",44)
	s TNum=1
    ;Modified By QW20180927bug号:QW0015 修改判断顺序,TActerStoreLoc为空时直接设为未盘点,以防出现TBillStoreLoc为空时状态变为一致
	if (TActerStoreLoc="")
	{	s TResultType="未盘点"	}
	elseif (TBillStoreLoc=TActerStoreLoc)
	{	s TResultType="一致"	}
	else
	{	s TResultType="科室不一致"	}
	;End By QW20180927
	s TAdvanceDisFlag=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus($p($g(^DHCEQEquip(EquipDR)),"^",93))	// Mozy0247	1190783	2020-02-17	增加异常状态信息
	
	///modified by ZY0233 2020-06-17
	s TKeeperDR = $p($g(^DHCEQEquip(EquipDR)),"^",66)
	s TLocationDR = $p($g(^DHCEQEquip(EquipDR)),"^",72)
	i FindILIRowID'=""
	{
		s TKeeperDR=$p($g(^DHCEQInventoryListInfo(FindILIRowID)),"^",2)
		s TLocationDR=$p($g(^DHCEQInventoryListInfo(FindILIRowID)),"^",3)
		s TLeaveFactoryNo=$p($g(^DHCEQInventoryListInfo(FindILIRowID)),"^",4)
	}
	
	s TKeeper = ##class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
	s TLocation = ##class(web.DHCEQCommon).GetTrakNameByID("location",TLocationDR)
	
	d OutputRowQueryList    //add By QW20180313 需求号:551829
	quit
	
OutputRowQueryList
	Quit:(StatusDR'=2)&&(TResultType'="未盘点")  //add By QW20180313 需求号:551829
	s TRow=TRow+1
	s ^DHCEQTemp(tmpNode,+$H,$j,index)=TRowID_"^"_TInventoryDR_"^"_TBillEquipDR_"^"_TActerEquipDR_"^"_TBillStoreLocDR_"^"_TBillUseLocDR_"^"_TActerStoreLocDR_"^"_TActerUseLocDR_"^"_TBillOriginalFee_"^"_TBillNetFee_"^"_TBillDepreTotalFee_"^"_TUserDR_"^"_TDate_"^"_TTime_"^"_TStatus_"^"_TRemark_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TBillName_"^"_TActerName_"^"_TBillNo_"^"_TActerNo_"^"_TModel_"^"_TEquiCat_"^"_TEquipType_"^"_TStatCat_"^"_TUnit_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TProvider_"^"_TLimitYearsNum_"^"_TDepreMethod_"^"_TEquipRemark_"^"_TBillStoreLoc_"^"_TBillUseLoc_"^"_TActerStoreLoc_"^"_TActerUseLoc_"^"_TManuFactory_"^"_TOrigin_"^"_TUser_"^"_TPlace_"^"_TResultType_"^"_TRow_"^"_TFileNo_"^"_TStartDate_"^"_TNum_"^"_TAdvanceDisFlag_"^"_TKeeperDR_"^"_TKeeper_"^"_TLocationDR_"^"_TLocation
	s Data=$lb(TRowID,TInventoryDR,TBillEquipDR,TActerEquipDR,TBillStoreLocDR,TBillUseLocDR,TActerStoreLocDR,TActerUseLocDR,TBillOriginalFee,TBillNetFee,TBillDepreTotalFee,TUserDR,TDate,TTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TBillName,TActerName,TBillNo,TActerNo,TModel,TEquiCat,TEquipType,TStatCat,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TProvider,TLimitYearsNum,TDepreMethod,TEquipRemark,TBillStoreLoc,TBillUseLoc,TActerStoreLoc,TActerUseLoc,TManuFactory,TOrigin,TUser,$j,TPlace,TResultType,TRow,TFileNo,TStartDate,TNum,TAdvanceDisFlag,TKeeperDR,TKeeper,TLocationDR,TLocation)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s ^DHCEQTemp("DHCEQInventoryListInfo",curuser,+$H,Job,gnum)=TRowID_"^"_TInventoryDR_"^"_TBillEquipDR
	s gnum=gnum+1
	s Tmpindex=Tmpindex+1
	quit
	
ResetVarQueryList
	set (TRowID,TInventoryDR,TBillEquipDR,TActerEquipDR,TBillStoreLocDR,TBillUseLocDR,TActerStoreLocDR,TActerUseLocDR,TBillOriginalFee,TBillNetFee,TBillDepreTotalFee,TUserDR,TDate,TTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TBillName,TActerName,TBillNo,TActerNo,TModel,TEquiCat,TEquipType,TStatCat,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TProvider,TLimitYearsNum,TDepreMethod,TEquipRemark,TBillStoreLoc,TBillUseLoc,TActerStoreLoc,TActerUseLoc,TManuFactory,TOrigin,TUser,TPlace,TResultType,TFileNo,TStartDate,TNum,TAdvanceDisFlag,TKeeperDR,TKeeper,TLocationDR,TLocation)=""
	quit
}

ClassMethod QueryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryListExecute ]
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

ClassMethod QueryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetOneDetail(InventoryDR)
{
	new result,resultexx
	if InventoryDR="" q ""
	s result=$g(^DHCEQInventory(InventoryDR))
	s resultex=""
	i $p(result,"^",2)'="" s resultex=##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",2))
	s resultex=resultex_"^"
	i $p(result,"^",3)'="" s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	s resultex=resultex_"^"
	i $p(result,"^",4)'="" s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^",5)'="" s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",5))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^",6)'="" s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",6))),"^",2)
	
	s resultex=resultex_"^"
	i $p(result,"^",7)'="" s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date") ;Modified by QW20170302日期格式统一调整 原 $ZD($p(result,"^",7),3)
	s resultex=resultex_"^"
	i $p(result,"^",8)'="" s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",8),"time") ;Modified by QW20170302日期格式统一调整 原$zt($p(result,"^",8))
	s resultex=resultex_"^"
	i $p(result,"^",17)'="" s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",17),"date") ;Modified by QW20170302日期格式统一调整 原$ZD($p(result,"^",17),3)
	s resultex=resultex_"^"
	i $p(result,"^",18)'="" s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"time") ;Modified by QW20170302日期格式统一调整 原$zt($p(result,"^",18))
	s resultex=resultex_"^"
	i $p(result,"^",14)'="" s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",14))
	/// Mozy	2015-10-27	获取未盘点设备数量		2016-10-12	需求号:265808	设置未盘点数默认值为空
	Set UnCheckNum=""
	Set rowid=0
	For  Set rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid)) Quit:((rowid=""))  d
	.;Add By QW20180313 需求号:551793 判断是否包含预报废设备
	.s TBillEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
	.q:TBillEquipDR=""
	.s EquipDR=TBillEquipDR
	.;if TBillEquipDR="" s EquipDR=TActerEquipDR
	.s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")
	.Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(EquipDR)),"^",93)="2")
	.;Add By QW20180313 需求号:551793 判断是否包含预报废设备
	.if $p($g(^DHCEQInventoryList(rowid)),"^",6)="" Set UnCheckNum=+UnCheckNum+1
	q result_"^"_resultex_"^"_UnCheckNum
}

/// return:
/// ResultType: 0 台帐中没有此设备  1 该设备已经盘点  2 找到该设备  3 盘点帐中无此设备  4 盘点帐中无此设备,并已经盘点
/// w ##Class(web.DHCEQInventory).GetInfoByEquipNo("20","2030618000003","","","477")
ClassMethod GetInfoByEquipNo(InventoryDR, EquipNo, StoreLocDR, UseLocDR, InventoryLocDR)
{
	new ResultType
	new EquipDR,InventoryListDR
	new EquipName,Model,BillStoreLocDR,BillUseLocDR,ActerStoreLocDR,ActerUseLocDR,BillOriginalFee,BillNetFee,BillDepreTotalFee,BillStoreLoc,BillUseLoc,ActerStoreLoc,ActerUseLoc,ILUserDR,ILUser,ILocType,Remark,LIUseStatus,LIPurpose,LILossReasonDR,LIUseStatusDesc,LIPurposeDesc,LILossReason
	s (EquipName,Model,BillStoreLocDR,BillUseLocDR,ActerStoreLocDR,ActerUseLocDR,BillOriginalFee,BillNetFee,BillDepreTotalFee,BillStoreLoc,BillUseLoc,ActerStoreLoc,ActerUseLoc,ILUserDR,ILUser,ILocType,Remark,LIUseStatus,LIPurpose,LILossReasonDR,LIUseStatusDesc,LIPurposeDesc,LILossReason)=""
	s (Location,LeaveFacNo,InventoryListDR,BindObjDR,BindNo,Keeper,InvlistinfoDR,LocationDR,KeeperDR,IVLStatus,IVLStatusDesc,ILStatus,ConditionDR,Condition,Remark)=""		//modified by czf 20200630
	s EquipDR=$o(^DHCEQEquip(0,"No",EquipNo,0))
	//zy20211102
	i EquipDR ="" d
	.s EquipNo= ##Class(web.DHCEQCommon).Replace(EquipNo,"|","")
	.s EquipDR=$o(^DHCEQEquip(0,"No",EquipNo,0))
	
	i EquipDR=""
	{
		s ResultType=0
	}
	else 
	{
		s InventoryListDR=$o(^DHCEQInventoryList(0,"BillEquip",InventoryDR,EquipDR,0)) 
		i (InventoryListDR'="")
		{
			i ($p($g(^DHCEQInventoryList(InventoryListDR)),"^",14)'="")		//modified by czf 20200713
			{	s ResultType=1	}
			else
			{	s ResultType=2	}
			
			s BillStoreLocDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",4)
			s BillUseLocDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",5)
			s ActerStoreLocDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",6)
			s ActerUseLocDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",7)
			s BillOriginalFee=+$p($g(^DHCEQInventoryList(InventoryListDR)),"^",8)
			s BillNetFee=+$p($g(^DHCEQInventoryList(InventoryListDR)),"^",9)
			s BillDepreTotalFee=+$p($g(^DHCEQInventoryList(InventoryListDR)),"^",10)
			s ILUserDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",11)
			s ILUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",ILUserDR)
			s BillStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",BillStoreLocDR)
			s BillUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",BillUseLocDR)
			s ActerStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",ActerStoreLocDR)
			s ActerUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",ActerUseLocDR)
			s Remark=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",15)
			s LIUseStatus=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",25)
			s LIPurpose= $p($g(^DHCEQInventoryList(InventoryListDR)),"^",26)
			s LILossReasonDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",27)
		}
		else
		{
			s InventoryListDR=$o(^DHCEQInventoryList(0,"ActerEquip",InventoryDR,EquipDR,0))
			if InventoryListDR=""
			{	s PlanInfo=##Class(web.DHCEQ.EM.BUSInventory).CheckInventoryPlanResultType(InventoryDR,EquipDR)
				s ResultType=$p(PlanInfo,"^",1)	
				s InventoryListDR=$p(PlanInfo,"^",2)
				i InventoryListDR'=""
				{
					s BillStoreLocDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",4)
					s BillUseLocDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",5)
					s ActerStoreLocDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",6)
					s ActerUseLocDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",7)
					s BillOriginalFee=+$p($g(^DHCEQInventoryList(InventoryListDR)),"^",8)
					s BillNetFee=+$p($g(^DHCEQInventoryList(InventoryListDR)),"^",9)
					s BillDepreTotalFee=+$p($g(^DHCEQInventoryList(InventoryListDR)),"^",10)
					s ILUserDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",11)
					s Remark=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",15)
					
				}
				else
				{
					s BillStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
					s BillUseLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",19)
					//s ActerStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",4)
					//s ActerUseLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",4)
					s BillOriginalFee=+$p($g(^DHCEQEquip(EquipDR)),"^",27)
					s BillNetFee=+$p($g(^DHCEQEquip(EquipDR)),"^",28)
					s BillDepreTotalFee=+$p($g(^DHCEQEquip(EquipDR)),"^",35)
				}
				s BillStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",BillStoreLocDR)
				s BillUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",BillUseLocDR)
				s ActerStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",ActerStoreLocDR)
				s ActerUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",ActerUseLocDR)
				s ILUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",ILUserDR)	
			}
			else
			{	s ResultType=4	}
		}
		
		s EquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
		s Model=$p($g(^DHCEQEquip(EquipDR)),"^",3)
		i Model'="" s Model=$p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
		s EQStoreLocDR=$p($g(^DHCEQEquip(EquipDR)),"^",67)
		/*
		i EQStoreLocDR=InventoryLocDR s IVLStatus=1		//账物一致			//modified by czf 20200710 begin
		e  s IVLStatus=2		//账实不符
		*/
		s ConditionDR=""
		if InventoryListDR'="" s ConditionDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",21)	//20200716 czf 默认完好
		i ConditionDR="" s ConditionDR=0
		
		//首次盘点时，显示设备表的信息，再次盘点时，显示盘点信息调整表的内容
		i InventoryListDR'=""
		{
			s IVStatus=$p($g(^DHCEQInventory(InventoryDR)),"^",10)
			i IVStatus=2 s IVLStatus=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",14)
			e  s IVLStatus=1		//默认为账物一致
			if ($p($g(^DHCEQInventoryList(InventoryListDR)),"^",14)'="") s IVLStatus=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",14)     //add by jyp 2022-07-31
			//if ResultType=6 s IVLStatus=2
			s ILStatus=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",14)		//modified by czf 20200710
			s (IVLInvalidFlag)=""
			s InvlistinfoDR=$o(^DHCEQInventoryListInfo(0,"IList",InventoryListDR,""))
			i InvlistinfoDR'="" s IVLInvalidFlag=$p($g(^DHCEQInventoryListInfo(InvlistinfoDR)),"^",5)  //Modify by zx 2020-07-14
			if ((InvlistinfoDR'="")&&(IVLInvalidFlag'="Y"))	//盘点调整表有效时才显示调整表信息,否则显示台账表信息 czf 20200714
			{
				s LocationDR=$p($g(^DHCEQInventoryListInfo(InvlistinfoDR)),"^",3)		
				s LeaveFacNo=$p($g(^DHCEQInventoryListInfo(InvlistinfoDR)),"^",4)
				s KeeperDR=$p($g(^DHCEQInventoryListInfo(InvlistinfoDR)),"^",2)
			}
			else
			{
				s LocationDR=$p($g(^DHCEQEquip(EquipDR)),"^",72)
				s LeaveFacNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
				s KeeperDR=$p($g(^DHCEQEquip(EquipDR)),"^",66)
				/*modified by czf 20200721 盘点人取移动端登录用户
				s keepervalue=##class(web.DHCEQCommon).GetSysInfo("992009")	//科室自盘的时候保管人为空的情况下保管人默认为盘点人 0:不启用  1:启用 20200715
				i keepervalue=1
				{
					i KeeperDR=""
					{
						s KeeperDR=$p($g(^DHCEQInventory(InventoryDR)),"^",9)		//盘点人 czf 
					}
				}*/
			}
		}
		s Location=##Class(web.DHCEQCommon).GetTrakNameByID("location",LocationDR)
		s Keeper=##Class(web.DHCEQCommon).GetTrakNameByID("user",KeeperDR)		//modified by czf 20200710 end
		s IVLStatusDesc=$case(IVLStatus,1:"账物一致",2:"科室不符",3:"盘亏",4:"盘盈",5:"有报废单",:"")
		s Condition=$case(ConditionDR,0:"完好",1:"待报废",2:"有缺损",:"")		//czf 20200716
		s ILocType=##Class(web.DHCEQCommon).GetTrakNameByID("depttype",BillStoreLocDR)
		i LIUseStatus'="" s LIUseStatusDesc=$CASE(LIUseStatus,"1":"在用","2":"拆封未使用","3":"未拆封","4":"积压闲置","5":"已盘亏","":"")
		i LIPurpose'="" s LIPurposeDesc=$CASE(LIPurpose,"1":"医院日常使用","2":"储备物资","":"")
		i LILossReasonDR'="" s LILossReason=$p($g(^DHCEQCCode("DHCEQCLossReason",LILossReasonDR)),"^",2)
	}
	s InFlag=##Class(web.DHCEQ.EM.BUSInventory).CheckInventoryLocStatus(InventoryDR,InventoryLocDR)
	i InFlag=1 s ResultType=7
	q ResultType_"^"_EquipName_"^"_Model_"^"_BillStoreLocDR_"^"_BillUseLocDR_"^"_ActerStoreLocDR_"^"_ActerUseLocDR_"^"_BillOriginalFee_"^"_BillNetFee_"^"_BillDepreTotalFee_"^"_BillStoreLoc_"^"_BillUseLoc_"^"_ActerStoreLoc_"^"_ActerUseLoc_"^"_EquipDR_"^"_Location_"^"_LeaveFacNo_"^"_InventoryListDR_"^"_BindObjDR_"^"_BindNo_"^"_Keeper_"^"_InvlistinfoDR_"^"_LocationDR_"^"_KeeperDR_"^"_IVLStatus_"^"_IVLStatusDesc_"^"_ILStatus_"^"_ConditionDR_"^"_Condition_"^"_ILocType_"^"_ILUser_"^"_Remark_"^"_LIUseStatus_"^"_LIPurpose_"^"_LILossReasonDR_"^"_LIUseStatusDesc_"^"_LIPurposeDesc_"^"_LILossReason
}

/// /
ClassMethod AuditActerEquip(InventoryDR, StoreLocDR, UseLocDR, EquipNo, user As %String = "")
{
	new curDate,curTime
	new EquipDR,InventoryListDR
	if EquipNo="" q ""
	s EquipDR=$o(^DHCEQEquip(0,"No",EquipNo,0))
	
	if InventoryDR="" q ""
	
	if user="" s user=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s curDate=+$H
	s curTime=+$p($H,",",2)
	
	s InventoryListDR=""
	i EquipDR'="" d
	.s InventoryListDR=$o(^DHCEQInventoryList(0,"BillEquip",InventoryDR,EquipDR,0))
	.i InventoryListDR="" s InventoryListDR=$o(^DHCEQInventoryList(0,"ActerEquip",InventoryDR,EquipDR,0))
	
	
	k PLIST
	s PLIST(4)=EquipDR
	s PLIST(7)=StoreLocDR
	s PLIST(8)=UseLocDR
	s PLIST(12)=user
	s PLIST(13)=curDate
	s PLIST(14)=curTime
	
	s PLIST(15)=1	;Status
	
	s PLIST(21)=EquipNo		;Hold5
	
	TStart
	i InventoryListDR=""
	{
		s PLIST(2)=InventoryDR
		&SQL(Insert into sqluser.DHC_EQInventoryList values :PLIST())
	}
	else
	{
		&SQL(Update sqluser.DHC_EQInventoryList values :PLIST() Where IL_RowID=:InventoryListDR)
	}
	i SQLCODE
	{	TRollBack	}
	else
	{	TCommit	}
	q SQLCODE
}

Query QueryInventoryNew(BeginDate As %String, EndDate As %String, InventoryNo As %String) As %Query(ROWSPEC = "TRowID:%String,TInventoryNo:%String,TStoreLocDR:%String,TUseLocDR:%String,TEquipTypeDR:%String,TStatCatDR:%String,TOriginDR:%String,TDate:%String,TTime:%String,TUserDR:%String,TStatus:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TFreezeDate:%String,TFreezeTime:%String,TFreezeUser:%String,TStoreLoc:%String,TUseLoc:%String,TEquipType:%String,TStatCat:%String,TOrigin:%String")
{
}

ClassMethod QueryInventoryNewExecute(ByRef qHandle As %Binary, BeginDate As %String, EndDate As %String, InventoryNo As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s data=""
	
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	
	s rowid=0
	f  s rowid=$o(^DHCEQInventory(rowid))  quit:rowid=""  d
	.d ResetVariablesQueryInventoryNew
	.s data=$g(^DHCEQInventory(rowid))
	.s TRowID=rowid
	.s TInventoryNo=$p(data,"^",1)
	.
	.q:((InventoryNo'="")&&(TInventoryNo'[InventoryNo))
	.
	.s TStoreLocDR=$p(data,"^",2)
	.s TUseLocDR=$p(data,"^",3)
	.s TEquipTypeDR=$p(data,"^",4)
	.s TStatCatDR=$p(data,"^",5)
	.s TOriginDR=$p(data,"^",6)
	.s TDate=$p(data,"^",7)
	.
	.q:((BeginDate'="")&&(BeginDate>TDate))
	.q:((EndDate'="")&&(EndDate<TDate))
	.
	.s TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date") ;Modified by QW20170302日期格式统一调整 原i TDate'="" s TDate=$ZD(TDate,3)
	.s TTime=$p(data,"^",8)
	.s TTime=##Class(web.DHCEQCommon).TransValueToPage(TTime,"time") ;Modified by QW20170302日期格式统一调整 原i TTime'="" s TTime=$ZT(TTime)
	.s TUserDR=$p(data,"^",9)
	.s TStatus=$p(data,"^",10)
	.q:TStatus'=1	///只取提交未完成的盘点单
	.s TRemark=$p(data,"^",11)
	.s THold1=$p(data,"^",12)
	.s THold2=$p(data,"^",13)
	.s THold3=$p(data,"^",14)
	.s THold4=$p(data,"^",15)
	.s THold5=$p(data,"^",16)
	.s TFreezeDate=$p(data,"^",17)
	.s TFreezeDate=##class(web.DHCEQCommon).TransValueToPage(TFreezeDate,"date") ;Modified by QW20170302日期格式统一调整 原i TFreezeDate'="" s TFreezeDate=$ZD(TFreezeDate,3)
	.s TFreezeTime=$p(data,"^",18)
	.s TFreezeTime=##Class(web.DHCEQCommon).TransValueToPage(TFreezeTime,"time") ;Modified by QW20170302日期格式统一调整 原i TFreezeTime'="" s TFreezeTime=$ZT(TFreezeTime)
	.s TFreezeUser=$p(data,"^",19)
	.i TFreezeUser'="" s TFreezeUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TFreezeUser)
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	.i TEquipTypeDR'="" s TEquipType=$p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	.i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.i TOriginDR'="" s TOrigin=$p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	.d OutputRowQueryInventoryNew
	
	Quit $$$OK

OutputRowQueryInventoryNew
	s Data=$lb(TRowID,TInventoryNo,TStoreLocDR,TUseLocDR,TEquipTypeDR,TStatCatDR,TOriginDR,TDate,TTime,TUserDR,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TFreezeDate,TFreezeTime,TFreezeUser,TStoreLoc,TUseLoc,TEquipType,TStatCat,TOrigin)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesQueryInventoryNew
	s (TRowID,TInventoryNo,TStoreLocDR,TUseLocDR,TEquipTypeDR,TStatCatDR,TOriginDR,TDate,TTime,TUserDR,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TFreezeDate,TFreezeTime,TFreezeUser,TStoreLoc,TUseLoc,TEquipType,TStatCat,TOrigin)=""
	quit
}

ClassMethod QueryInventoryNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryInventoryNewExecute ]
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

ClassMethod QueryInventoryNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryInventoryNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetNextLoc(InventoryDR, CurLocDR)
{
	new result
	if InventoryDR="" q ""
	s result=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,CurLocDR))
	q result
}

/// 2019-08-29 	Mozy0224
/// w ##Class(web.DHCEQInventory).GetNextListInfo(1,"","",0)
ClassMethod GetNextListInfo(InventoryDR, LocDR, EquipDR, RowID)
{
	new NewEquipDR,NewRowID
	new Name,Model,Manufactory,No,Unit,EquipCat,StoreLoc,UseLocDR,UseLoc,OriginalFee,Origin,StorePlace
	new CheckDate,OpenCheckDate,Country,ManageUser,InDate,EquipType,LeaveFactoryNo,Provider
	s (Name,Model,Manufactory,No,Unit,EquipCat,StoreLoc,UseLocDR,UseLoc,OriginalFee,Origin,StorePlace)=""
	s (CheckDate,OpenCheckDate,Country,ManageUser,InDate,EquipType,LeaveFactoryNo,Provider)=""
	i (InventoryDR="")||(LocDR="") q ""
	if EquipDR=""
	{
		s EquipDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,LocDR,EquipDR))
		s RowID=""
	}
	if EquipDR="" q ""
	s NewRowID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,LocDR,EquipDR,RowID))
	i (NewRowID'="")
	{
		s NewEquipDR=EquipDR
	}
	else
	{
		s NewEquipDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,LocDR,EquipDR))
		i (NewEquipDR'="") s NewRowID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,LocDR,NewEquipDR,0))
	}
	i ((NewEquipDR="")||(NewRowID="")) q ""
	
	;s ^DHCEQTemp("JDL")=LocDR_"&"_NewEquipDR_"&"_NewRowID
	s Name=$p($g(^DHCEQEquip(NewEquipDR)),"^",1)
	s Model=$p($g(^DHCEQEquip(NewEquipDR)),"^",3)
	i Model'="" s Model=$p($g(^DHCEQCCode("DHCEQCModel",Model)),"^",2)
	s Manufactory=$p($g(^DHCEQEquip(NewEquipDR)),"^",26)
	i Manufactory'="" s Manufactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",Manufactory) //CZF0093
	s No=$p($g(^DHCEQEquip(NewEquipDR)),"^",71)
	s Unit=$p($g(^DHCEQEquip(NewEquipDR)),"^",5)
	i Unit'="" s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
	s EquipCat=$p($g(^DHCEQEquip(NewEquipDR)),"^",4)
	i EquipCat'="" s EquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",EquipCat)),"^",2)
	s StoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",LocDR)
	s UseLocDR=$p($g(^DHCEQEquip(NewEquipDR)),"^",19)
	i UseLocDR'="" s UseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocDR)
	s OriginalFee=$p($g(^DHCEQEquip(NewEquipDR)),"^",27)
	s Origin=$p($g(^DHCEQEquip(NewEquipDR)),"^",20)
	i Origin'="" s Origin=$p($g(^DHCEQCCode("DHCEQCOrigin",Origin)),"^",2)
	s StorePlace=$p($g(^DHCEQEquip(NewEquipDR)),"^",72)
	s OpenCheckDate=$p($g(^DHCEQEquip(NewEquipDR)),"^",12)
	i OpenCheckDate'="" s OpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage(OpenCheckDate,"date")
	s CheckDate=$p($g(^DHCEQEquip(NewEquipDR)),"^",13)
	i CheckDate'="" s CheckDate=##Class(web.DHCEQCommon).TransValueToPage(CheckDate,"date")
	s Country=$p($g(^DHCEQEquip(NewEquipDR)),"^",16)
	i Country'="" s Country=##Class(web.DHCEQCommon).GetTrakNameByID("cou",Country)
	s ManageUser=$p($g(^DHCEQEquip(NewEquipDR)),"^",39)
	i ManageUser'="" s ManageUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",ManageUser)
	s InDate=$p($g(^DHCEQEquip(NewEquipDR)),"^",45)
	i InDate="" s InDate=$p($g(^DHCEQEquip(NewEquipDR)),"^",53)
	i InDate'="" s InDate=##Class(web.DHCEQCommon).TransValueToPage(InDate,"date")
	s EquipType=$p($g(^DHCEQEquip(NewEquipDR)),"^",63)
	s EquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",EquipType)
	s LeaveFactoryNo=$p($g(^DHCEQEquip(NewEquipDR)),"^",10)
	s Provider=$p($g(^DHCEQEquip(NewEquipDR)),"^",25)
	s Provider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",Provider)
	
	q NewEquipDR_"^"_NewRowID_"^"_Name_"^"_Model_"^"_Manufactory_"^"_No_"^"_Unit_"^"_EquipCat_"^"_StoreLoc_"^"_UseLocDR_"^"_UseLoc_"^"_OriginalFee_"^"_Origin_"^"_StorePlace_"^"_CheckDate_"^"_OpenCheckDate_"^"_Country_"^"_ManageUser_"^"_InDate_"^"_EquipType_"^"_LeaveFactoryNo_"^"_Provider
}

/// 获取设备表中的所有科室或者根据盘点获取科室信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","GetInventoryLoc")
Query GetInventoryLoc(InventoryDR As %String = "", mInput As %String = "") As %Query(ROWSPEC = "TLocID:%String,TDesc:%String,TJob:%String")
{
}

ClassMethod GetInventoryLocExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", mInput As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s data=""
	
	s tmpNode="InventoryDownLoc"
	d ##Class(web.DHCEQCommon).KillTempGlobal(tmpNode)
	
	s TJob=$j
	s TDate=+$H
	s rowid=0
	if (InventoryDR="")  d
	.f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	..s StockStatus=$p($g(^DHCEQEquip(rowid)),"^",60)
	..q:((StockStatus=0)||(StockStatus=3))		///尚未入库或已经出库的设备
	..q:$p($g(^DHCEQEquip(rowid)),"^",38)=3		///报废的设备
	..s TLocID=$p($g(^DHCEQEquip(rowid)),"^",67)
	..d AddLoc
	e  d
	.f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,rowid))  quit:rowid=""  d
	..s TLocID=rowid
	..d AddLoc	
	Quit $$$OK
AddLoc
	q:TLocID=""
	if '$d(^DHCEQTemp(tmpNode,TDate,TJob,TLocID))  d
	.s TDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocID)
	.s mInput=$ZCONVERT(mInput,"U")
	.q:(mInput'="")&&($ZCONVERT(TDesc,"U")'[mInput)
	.;s len=$Length(TDesc,"-")
	.;s TDesc= $Piece(TDesc,"-",len\2+1,len)
	.s ^DHCEQTemp(tmpNode,TDate,TJob,TLocID)=TDesc
	.d OutputRowGetInventoryLoc
	quit
OutputRowGetInventoryLoc
	s Data=$lb(TLocID,TDesc,TJob)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
ResetVariablesGetInventoryLoc
	s (TLocID,TDesc)=""
	quit
}

ClassMethod GetInventoryLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInventoryLocExecute ]
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

ClassMethod GetInventoryLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInventoryLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取指定盘点表中的设备信息
/// Modified By QW2021 bug号:QW00 PDA盘点: 增加输出 ,TVendor,TSN,TItem
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","GetEquipList",44)
Query GetEquipList(InventoryDR, LocDR As %String = "") As %Query(ROWSPEC = "TEquipDR:%String,TBillLocID:%String,TEquipNo:%String,TEquipName:%String,TModel:%String,TModelDR:%String,TManufacturer:%String,TManufacturerDR:%String,TOriginalFee:%String,TLocation:%String,TLocationDR:%String,TActLocID:%String,TInDate:%String,TFileNo:%String,TJob:%String,TActLocName:%String,TOldNo:%String,TVendor:%String,TVendorDR:%String,TSN:%String,TItemDR:%String")
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, InventoryDR, LocDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s data=""
	
	s tmpNode="InventoryDownEquipList"
	d ##Class(web.DHCEQCommon).KillTempGlobal(tmpNode)
	
	s TJob=$j
	s TDate=+$H

	s storeLocDR=0
	f  s storeLocDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,storeLocDR))  quit:storeLocDR=""  d
	.q:((LocDR'="")&&(LocDR'=storeLocDR))
	.s equipDR =0
	.f  s equipDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,storeLocDR,equipDR))  quit:equipDR=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,storeLocDR,equipDR,rowid))  quit:rowid=""  d
	...d AddEquip	

	Quit $$$OK
AddEquip
	if '$d(^DHCEQTemp(tmpNode,TDate,TJob,equipDR))  d
	.d ResetVariablesGetEquipList
	.s TEquipDR=equipDR
	.s TBillLocID=storeLocDR
	.s TBillLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillLocID)
	.s TActLocID=$p($g(^DHCEQInventoryList(rowid)),"^",6)
	.i TActLocID'="" s TActLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActLocID)
	.s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TModelDR=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.i TModelDR '="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2) ;Modified By QW2021 bug号:QW00 PDA盘点: 修改输出格式
	.s TManufacturerDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
	.i TManufacturerDR'="" s TManufacturer=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManufacturerDR) ;Modified By QW2021 bug号:QW00 PDA盘点: 修改输出格式
	.s TOriginalFee=$p($g(^DHCEQEquip(TEquipDR)),"^",27)
	.s TLocationDR=$p($g(^DHCEQEquip(TEquipDR)),"^",72)
	.i TLocationDR'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)  ;Modified By QW2021 bug号:QW00 PDA盘点: 修改输出格式
	.s TInDate=$p($g(^DHCEQEquip(TEquipDR)),"^",45)
	.i TInDate="" s TInDate=$p($g(^DHCEQEquip(TEquipDR)),"^",53)
	.s TInDate=##class(web.DHCEQCommon).TransValueToPage(TInDate,"date") ;Modified by QW20170302日期格式统一调整 原i TInDate'="" s TInDate=$ZD(TInDate,3)
	.s TManageUser=$p($g(^DHCEQEquip(TEquipDR)),"^",39)
	.i TManageUser'="" s TManageUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TManageUser)
	.s TFileNo=$p($g(^DHCEQEquip(TEquipDR)),"^",85)  //add by zx 2015-12-08
	.s TOldNo=$p($g(^DHCEQEquip(TEquipDR)),"^",91) ;Add by QW20191008 BUG:QW0027 PDA盘点: 增加输出 TOldNo
	.;Modified By QW2021 bug号:QW00 PDA盘点: 增加输出 TVendor,TSN,TItem begin
	.s TVendorDR=$p($g(^DHCEQEquip(TEquipDR)),"^",25)
	.i TVendorDR'="" s TVendor=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TVendorDR)
	.s TSN=$p($g(^DHCEQEquip(TEquipDR)),"^",10)
	.s TItemDR=$p($g(^DHCEQEquip(TEquipDR)),"^",7)
	.;Modified By QW2021 bug号:QW00 PDA盘点: 增加输出 TVendor,TSN,TItem end
	.s ^DHCEQTemp(tmpNode,TDate,TJob,TEquipDR)=TEquipDR_"^"_TBillLocID_"^"_TBillLocDesc_"^"_TEquipNo_"^"_TEquipName_"^"_TModel_"^"_TManufacturer_"^"_TOriginalFee_"^"_TLocationDR_"^"_TActLocID_"^"_TActLocDesc_"^"_TInDate
	.;s ^DHCEQTemp(tmpNode,TDate,TJob,TEquipDR)=TEquipDR_"^"_TBillLocID_"^"_TBillLocDesc_"^"_TEquipNo_"^"_TEquipName_"^"_TModel_"^"_TManufacturer_"^"_TOriginalFee_"^"TLocationDR"^"_TActLocID_"^"_TActLocDesc_"^"_TInDate
	.d OutputRowGetEquipList
	quit
OutputRowGetEquipList
	s Data=$lb(TEquipDR,TBillLocID,TEquipNo,TEquipName,TModel,TModelDR,TManufacturer,TManufacturerDR,TOriginalFee,TLocation,TLocationDR,TActLocID,TInDate,TFileNo,TJob,"",TOldNo,TVendor,TVendorDR,TSN,TItemDR) ;Modified By QW2021 bug号:QW00 PDA盘点: 增加输出 ,TVendor,TSN,TItem
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
ResetVariablesGetEquipList
	s (TEquipDR,TBillLocID,TBillLocDesc,TEquipNo,TEquipName,TModel,TModelDR,TManufacturer,TManufacturerDR,TOriginalFee,TLocation,TLocationDR,TActLocID,TActLocDesc,TInDate,TFileNo,TOldNo,TVendor,TVendorDR,TSN,TItemDR)="" ;Modified By QW2021 bug号:QW00 PDA盘点: 增加输出 ,TVendor,TSN,TItem
	quit
}

ClassMethod GetEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipListExecute ]
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

ClassMethod GetEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modified by QW20191008 BUG:QW0027 PDA盘点: 增加输出 TMixFlag
Query QueryShortInventory(BeginDate As %String = "", EndDate As %String = "", InventoryNo As %String = "", CurGroupID As %String = "", CurHosptailID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TInventoryNo:%String,TStoreLoc:%String,TUseLocDR:%String,TDate:%String,TFreezeDate:%String,TFreezeUser:%String,TMixFlag:%String")
{
}

ClassMethod QueryShortInventoryExecute(ByRef qHandle As %Binary, BeginDate As %String = "", EndDate As %String = "", InventoryNo As %String = "", CurGroupID As %String = "", CurHosptailID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s data=""
	
	i BeginDate="" s BeginDate=0
	i EndDate="" s EndDate=+$H
	
	s rowid=0
	f  s rowid=$o(^DHCEQInventory(rowid))  quit:rowid=""  d
	.d ResetVariablesQueryShortInventory
	.s data=$g(^DHCEQInventory(rowid))
	.s TRowID=rowid
	.s TInventoryNo=$p(data,"^",1)
	.
	.q:((InventoryNo'="")&&(TInventoryNo'[InventoryNo))
	.
	.s TStoreLoc=$p(data,"^",2)
	.;quit:((CurHosptailID'="")&&($p(data,"^",15)'=CurHosptailID)) ;QW20161214 分院区 ;Add By QW2021 bug号:QW00 begin 
	.s TStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLoc)
	.s TUseLoc=$p(data,"^",3)
	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	.s TEquipTypeDR=$p(data,"^",4)
	.s TStatCatDR=$p(data,"^",5)
	.s TOriginDR=$p(data,"^",6)
	.s TDate=$p(data,"^",7)
	.//Start Add By QW 2016-12-08 过滤类组
	.s qFlag=0
	.i TEquipTypeDR'="" d
	..s length=$L(TEquipTypeDR,",")
	..f i=1:1:length q:qFlag=1  d
	...s EquipTypeDR=$p(TEquipTypeDR,",",i)
	...i (0'=##class(web.DHCEQCommon).EquipTypeIsIn(EquipTypeDR,CurGroupID))  d  
	....s qFlag=1
	.q:qFlag=1
	.//End Add By QW 2016-12-08 过滤类组
	.q:((BeginDate'="")&&(BeginDate>TDate))
	.q:((EndDate'="")&&(EndDate<TDate))
	.
	.s TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date") ;Modified by QW20170302日期格式统一调整 原i TDate'="" s TDate=$ZD(TDate,3)
	.s TUserDR=$p(data,"^",9)
	.s TStatus=$p(data,"^",10)
	.q:TStatus'=1   //只取已经定盘,尚未盘完的盘点单。0:新增|1:提交|2:盘点完成
	.s TRemark=$p(data,"^",11)
	.s TFreezeDate=$p(data,"^",17)
	.s TFreezeDate=##class(web.DHCEQCommon).TransValueToPage(TFreezeDate,"date") ;Modified by QW20170302日期格式统一调整 原i TFreezeDate'="" s TFreezeDate=$ZD(TFreezeDate,3)
	.s TFreezeUser=$p(data,"^",19)
	.i TFreezeUser'="" s TFreezeUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TFreezeUser)
	.s TMixFlag=##class(web.DHCEQCommon).GetSysInfo("402001")  ;Add by QW20191008 BUG:QW0027 盘点:医院资产设备中，旧设备是否仍粘贴并保留使用旧编号
	.d OutputRowQueryShortInventory
	
	Quit $$$OK

OutputRowQueryShortInventory
	s Data=$lb(TRowID,TInventoryNo,TStoreLoc,TUseLoc,TDate,TFreezeDate,TFreezeUser,TMixFlag) ;Modified by QW20191008 BUG:QW0027 PDA盘点:增加输出 TMixFlag
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesQueryShortInventory
	s (TRowID,TInventoryNo,TStoreLoc,TUseLoc,TDate,TFreezeDate,TFreezeUser,TMixFlag)="" ;Modified by QW20191008 BUG:QW0027 PDA盘点:增加输出 TMixFlag
	quit
}

ClassMethod QueryShortInventoryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryShortInventoryExecute ]
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

ClassMethod QueryShortInventoryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryShortInventoryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取指定盘点表中的设备信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","GetEquipIndex")
Query GetEquipIndex(InventoryDR) As %Query(ROWSPEC = "No:%String,Loc:%String")
{
}

ClassMethod GetEquipIndexExecute(ByRef qHandle As %Binary, InventoryDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s data=""
	
	s tmpNode="InventoryDownEquipIndex"
	d ##Class(web.DHCEQCommon).KillTempGlobal(tmpNode)
	
	s TJob=$j
	s TDate=+$H

	s storeLocDR=0
	f  s storeLocDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,storeLocDR))  quit:storeLocDR=""  d
	.s equipDR =0
	.f  s equipDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,storeLocDR,equipDR))  quit:equipDR=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,storeLocDR,equipDR,rowid))  quit:rowid=""  d
	...d AddEquipIndex

	Quit $$$OK
AddEquipIndex
	if '$d(^DHCEQTemp(tmpNode,TDate,TJob,equipDR))  d
	.d ResetVariablesGetEquipIndex
	.s TEquipDR=equipDR
	.s TBillLocID=storeLocDR
	.s TBillLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillLocID)
	.s TActLocID=$p($g(^DHCEQInventoryList(rowid)),"^",6)
	.i TActLocID'="" s TActLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActLocID)
	.s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TModel=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.s TManufacturer=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
	.i TManufacturer'="" s TManufacturer=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManufacturer) //CZF0093
	.s TOriginalFee=$p($g(^DHCEQEquip(TEquipDR)),"^",27)
	.s TPlace=$p($g(^DHCEQEquip(TEquipDR)),"^",72)
	.s TInDate=$p($g(^DHCEQEquip(TEquipDR)),"^",45)
	.i TInDate="" s TInDate=$p($g(^DHCEQEquip(TEquipDR)),"^",53)
	.i TInDate'="" s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	.s TManageUser=$p($g(^DHCEQEquip(TEquipDR)),"^",39)
	.i TManageUser'="" s TManageUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TManageUser)
	.s ^DHCEQTemp(tmpNode,TDate,TJob,TEquipDR)=TEquipDR_"^"_TBillLocID_"^"_TBillLocDesc_"^"_TEquipNo_"^"_TEquipName_"^"_TModel_"^"_TManufacturer_"^"_TOriginalFee_"^"_TPlace_"^"_TActLocID_"^"_TActLocDesc_"^"_TInDate
	.;s ^DHCEQTemp(tmpNode,TDate,TJob,TEquipDR)=TEquipDR_"^"_TBillLocID_"^"_TBillLocDesc_"^"_TEquipNo_"^"_TEquipName_"^"_TModel_"^"_TManufacturer_"^"_TOriginalFee_"^"_TPlace_"^"_TActLocID_"^"_TActLocDesc_"^"_TInDate
	.d OutputRowGetEquipIndex
	quit
OutputRowGetEquipIndex
	s Data=$lb(TEquipNo,TBillLocID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
ResetVariablesGetEquipIndex
	s (TEquipDR,TBillLocID,TBillLocDesc,TEquipNo,TEquipName,TModel,TManufacturer,TOriginalFee,TPlace,TActLocID,TActLocDesc,TInDate)=""
	quit
}

ClassMethod GetEquipIndexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipIndexExecute ]
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

ClassMethod GetEquipIndexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipIndexExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 获取指定盘点表中的设备附件信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","GetAffixList")
Query GetAffixList(InventoryDR, LocDR As %String = "") As %Query(ROWSPEC = "TEquipDR:%String,TAffixID:%String,TAffixName:%String,TModel:%String,TManufactory:%String,TQuantity:%String,TPrice:%String,TJob:%String")
{
}

ClassMethod GetAffixListExecute(ByRef qHandle As %Binary, InventoryDR, LocDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s data=""
	
	s tmpNode="InventoryDownAffix"
	d ##Class(web.DHCEQCommon).KillTempGlobal(tmpNode)
	
	s TJob=$j
	s TDate=+$H

	s storeLocDR=0
	f  s storeLocDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,storeLocDR))  quit:storeLocDR=""  d
	.q:((LocDR'="")&&(LocDR'=storeLocDR))
	.s equipDR =0
	.f  s equipDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,storeLocDR,equipDR))  quit:equipDR=""  d
	..s rowid=0
	..f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,storeLocDR,equipDR,rowid))  quit:rowid=""  d
	...s TEquipDR=equipDR
	...s TAffixID=0
	...f  s TAffixID=$o(^DHCEQAffix(0,"Equip",TEquipDR,TAffixID))  quit:TAffixID=""  d
	....q:$p($g(^DHCEQAffix(TAffixID)),"^",14)="Y"	//报废的不显示
	....q:$p($g(^DHCEQAffix(TAffixID)),"^",15)="Y"	//删除的不显示
	....s TAffixName=$p($g(^DHCEQAffix(TAffixID)),"^",4)
	....if TEquipDR=11792 b
	....s TModel=$p($g(^DHCEQAffix(TAffixID)),"^",5)
	....s TManufactory=$p($g(^DHCEQAffix(TAffixID)),"^",6)
	....s TQuantity=$p($g(^DHCEQAffix(TAffixID)),"^",7)
	....s TPrice=$p($g(^DHCEQAffix(TAffixID)),"^",11)
	....d AddAffix
	Quit $$$OK
AddAffix
	if '$d(^DHCEQTemp(tmpNode,TDate,TJob,TEquipDR,TAffixID))  d
	.s ^DHCEQTemp(tmpNode,TDate,TJob,TEquipDR,TAffixID)=TEquipDR_"^"_TAffixID_"^"_TAffixName_"^"_TModel_"^"_TManufactory_"^"_TQuantity_"^"_TPrice
	.d OutputRowGetAffixList
	quit
OutputRowGetAffixList
	s Data=$lb(TEquipDR,TAffixID,TAffixName,TModel,TManufactory,TQuantity,TPrice,TJob)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
}

ClassMethod GetAffixListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAffixListExecute ]
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

ClassMethod GetAffixListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAffixListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UpLoadInventoryResult(InventoryDR, StoreLocDR, UseLocDR, EquipID, EquipNo, EquipName, ReasonType As %String = "", User As %String = "", InventoryDate As %String = "", InventoryTime As %String = "")
{
	new InventoryListDR,num
	
	;s ^DHCEQTemp("jdl")=InventoryDR_"^"_StoreLocDR_"^"_UseLocDR_"^"_EquipID_"^"_EquipNo_"^"_EquipName_"^"_ReasonType_"^"_User_"^"_InventoryDate_"^"_InventoryTime
	
	if InventoryDR="" q ""
	
	;if User="" s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	if InventoryDate="" s InventoryDate=+$H
	if InventoryTime="" s InventoryTime=+$p($H,",",2)
	
	s InventoryListDR=""
	if EquipID'="" s InventoryListDR=$o(^DHCEQInventoryList(0,"BillEquip",InventoryDR,EquipID,0))
	
	//add by jdl 2010-12-21 临时用
	;if InventoryListDR="" q ""
		
	k PLIST
	i EquipID'="" s PLIST(4)=EquipID
	s PLIST(7)=StoreLocDR
	s PLIST(8)=UseLocDR
	s PLIST(12)=User
	s PLIST(13)=InventoryDate
	s PLIST(14)=InventoryTime
	
	;Add By QW2021 bug号:QW00 begin 
	s billLocDR=$p($g(^DHCEQInventoryList(InventoryListDR)),"^",4)  
	if StoreLocDR=billLocDR  s PLIST(15)=1	;Status
	else  s PLIST(15)=2	;Status
	;Add By QW2021 bug号:QW00 end
	s PLIST(19)=ReasonType		;Hold3
	s PLIST(20)=EquipName		;Hold4
	s PLIST(21)=EquipNo		;Hold5
	s PLIST(22)= "0"           ;Condition ;Add By QW2021 bug号:QW00
	
	TStart
	i InventoryListDR=""
	{
		s PLIST(2)=InventoryDR
		&SQL(Insert into sqluser.DHC_EQInventoryList values :PLIST())
	}
	else
	{
		&SQL(Update sqluser.DHC_EQInventoryList values :PLIST() Where IL_RowID=:InventoryListDR)
	}
	i SQLCODE
	{	TRollBack	}
	else
	{
		i EquipID'=""
		{
			s num=$o(^DHCEQInventory(InventoryDR,"EX","Equip",EquipID,""),-1)+1
			s ^DHCEQInventory(InventoryDR,"EX","Equip",EquipID,num)=StoreLocDR_"^"_$H
		}
		elseif EquipNo'=""
		{
			s num=$o(^DHCEQInventory(InventoryDR,"EX","New","No",EquipNo,""),-1)+1
			s ^DHCEQInventory(InventoryDR,"EX","New","No",EquipNo,num)=StoreLocDR_"^"_$H
		}
		else
		{
			s num=$o(^DHCEQInventory(InventoryDR,"EX","New","Name",EquipName,""),-1)+1
			s ^DHCEQInventory(InventoryDR,"EX","New","Name",EquipName,num)=StoreLocDR_"^"_$H
		}
		TCommit	
	}
	q SQLCODE
}

ClassMethod CheckEquipResult(InventoryDR, LocDR, EquipDR)
{
	new rowid
	s rowid=$o(^DHCEQInventoryList(0,"BillEquip",InventoryDR,EquipDR,0))
	
	//add by jdl 2010-12-21 临时用
	;if rowid="" q ""
	
	i $p($g(^DHCEQInventoryList(rowid)),"^",6)=""
	{
		q ""
	}
	elseif $p($g(^DHCEQInventoryList(rowid)),"^",6)=LocDR 
	{
		q 0
	}
	else
	{
		q $p($g(^DHCEQInventoryList(rowid)),"^",6)
	}
}

ClassMethod CheckLocResult(InventoryDR, LocDR)
{
	new equipDR,rowid
	new total,accordQty,diffQty,nullQty
	
	s (total,accordQty,diffQty,nullQty)=0
	s equipDR =0
	f  s equipDR=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,LocDR,equipDR))  quit:equipDR=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,LocDR,equipDR,rowid))  quit:rowid=""  d
	..s total=total+1
	..if $p($g(^DHCEQInventoryList(rowid)),"^",6)'=""  d
	...if $p($g(^DHCEQInventoryList(rowid)),"^",6)=LocDR  d
	....s accordQty=accordQty+1
	...e  d
	....s diffQty=diffQty+1
	..e  d
	...s nullQty=nullQty+1
	q total_"^"_accordQty_"^"_diffQty_"^"_nullQty
}

ClassMethod UpLoadBatchResult(InventoryDR, BillLocDR, BatchInfos)
{
	new num,info,results,result,resultinfo  ;Modified By QW2021 bug号:QW00
	new EquipID,locDR,UserDR    ;Modified By QW20210511 BUG:QW0105 增加盘点人
	s results=""
	s num=$l(BatchInfos,"%")	
	
	for i=1:1:num
	{
		s info=$p(BatchInfos,"%",i)
		
		s EquipID=$p(info,"^",1)
		s locDR=$p(info,"^",2)
		s UserDR=$p(info,"^",3) ;Add  By QW20210511 BUG:QW0105 增加盘点人
		;Add By QW2021 bug号:QW00 begin
		s Vendor=$p(info,"^",4)
		s Manufacturer=$p(info,"^",5)
		s Location=$p(info,"^",6)
		s Model=$p(info,"^",7)
		s SN=$p(info,"^",8)
		;Add By QW2021 bug号:QW00 end
		s result=##Class(web.DHCEQInventory).UpLoadInventoryResult(InventoryDR,locDR,locDR,EquipID,"","","",UserDR)  ;Modified By QW20210511 BUG:QW0105 增加盘点人
		;;Add By QW2021 bug号:QW00 begin
		s InventoryListDR=""
		s ILIRowID=""
		if EquipID'="" s InventoryListDR=$o(^DHCEQInventoryList(0,"BillEquip",InventoryDR,EquipID,0))
		if InventoryListDR'="" s ILIRowID=$o(^DHCEQInventoryListInfo(0,"IList",InventoryListDR,""))
		s DataInfo= ILIRowID_"^"_InventoryListDR_"^"_Location_"^"_SN_"^"_UserDR_"^"_Manufacturer_"^"_Model_"^"_Vendor_"^"_EquipID
		s resultinfo= ##Class(web.DHCEQInventory).CheckBaseInfo(DataInfo)
		;Add By QW2021 bug号:QW00 end
		i results'="" s results=results_"^"
		s results=results_result_":"_resultinfo   ;Modified By QW2021 bug号:QW00 
	}
	q results
}

ClassMethod CheckBatchResult(InventoryDR, BatchInfos)
{
	new num,info,results,result
	new EquipID,locDR
	
	s results=""
	s num=$l(BatchInfos,"%")
	s ^DHCEQTemp("jdl")=BatchInfos
	
	for i=1:1:num
	{
		s info=$p(BatchInfos,"%",i)
		
		s EquipID=$p(info,"^",1)
		s locDR=$p(info,"^",2)
		s result=##Class(web.DHCEQInventory).CheckEquipResult(InventoryDR,locDR,EquipID)
		i results'="" s results=results_"^"
		s results=results_result
	}
	q results
}

Query ResultList(InventoryDR As %String = "", StoreLocDR As %String = "", UseLocDR As %String = "", EquipTypeIDs As %String = "", StatCatDR As %String = "", OriginDR As %String = "", onlyShowDiff As %String = "") As %Query(ROWSPEC = "TRowID:%String,TInventoryDR:%String,TBillEquipDR:%String,TActerEquipDR:%String,TBillStoreLocDR:%String,TBillUseLocDR:%String,TActerStoreLocDR:%String,TActerUseLocDR:%String,TBillOriginalFee:%String,TBillNetFee:%String,TBillDepreTotalFee:%String,TUserDR:%String,TDate:%String,TTime:%String,TStatus:%String,TRemark:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TBillName:%String,TActerName:%String,TBillNo:%String,TActerNo:%String,TModel:%String,TEquiCat:%String,TEquipType:%String,TStatCat:%String,TUnit:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TProvider:%String,TLimitYearsNum:%String,TDepreMethod:%String,TEquipRemark:%String,TBillStoreLoc:%String,TBillUseLoc:%String,TActerStoreLoc:%String,TActerUseLoc:%String,TManuFactory:%String,TOrigin:%String,TUser:%String,TJob:%String,TPlace:%String,TResultType:%String,TRow:%String")
{
}

ClassMethod ResultListExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", StoreLocDR As %String = "", UseLocDR As %String = "", EquipTypeIDs As %String = "", StatCatDR As %String = "", OriginDR As %String = "", onlyShowDiff As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	new tmpNode
	new TRowID,TInventoryDR,TBillEquipDR,TActerEquipDR,TBillStoreLocDR,TBillUseLocDR,TActerStoreLocDR,TActerUseLocDR,TBillOriginalFee,TBillNetFee,TBillDepreTotalFee,TUserDR,TDate,TTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TBillName,TActerName,TBillNo,TActerNo
	new TModel,TEquiCat,TEquipType,TStatCat,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TProvider,TLimitYearsNum,TDepreMethod,TEquipRemark
	new TBillStoreLoc,TBillUseLoc,TActerStoreLoc,TActerUseLoc,TManuFactory,TOrigin,TUser,TPlace
	new billStoreLocID,equipID,IncludeFlag
	
	//add by zy 2013-06-04 zy0107
	//增加参数判断盘点是否包含预报废设备，直接取EQ_Hold8字段的值来判断设备的预报废
	s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")	//盘点是否包含预报废设备
	s tmpNode="DHCEQInventory.ResultList"
	d ##Class(web.DHCEQCommon).KillTempGlobal(tmpNode)
	
	if ((InventoryDR'="")&&(+$p($g(^DHCEQInventory(InventoryDR)),"^",10)>0))
	{
		s billStoreLocID=0
		f  s billStoreLocID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID))  quit:((billStoreLocID=""))  d
		.s TBillStoreLocDR=billStoreLocID
		.//modified by ZY  20200625
		.//q:(StoreLocDR'="")&&(StoreLocDR'=TBillStoreLocDR)
		.q:(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,TBillStoreLocDR,"1")'="1")
		.s TBillUseLocDR=billStoreLocID
		.s (TTotalQty,TAmount,TDiffQty,TDiffAmount,TLoseQty,TLoseAmount,TAccordQty,TAccordAmount)=0
		.s equipID=0
		.f  s equipID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID,equipID))  quit:((equipID=""))  d
		..s TBillEquipDR=equipID	
		..s rowid=0
		..f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID,equipID,rowid))  quit:((rowid=""))  d
		...d ResetVarResultList
		...s TRowID=rowid
		...s TInventoryDR=InventoryDR
		...s TBillEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2)
		...s TActerEquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",3)
		...s TBillStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",4)
		...s TBillUseLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",5)
		...s TActerStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",6)
		...s TActerUseLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",7)
		...s TBillOriginalFee=+$p($g(^DHCEQInventoryList(rowid)),"^",8)
		...s TBillNetFee=+$p($g(^DHCEQInventoryList(rowid)),"^",9)
		...s TBillDepreTotalFee=+$p($g(^DHCEQInventoryList(rowid)),"^",10)
		...s TUserDR=$p($g(^DHCEQInventoryList(rowid)),"^",11)
		...s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
		...s TDate=$p($g(^DHCEQInventoryList(rowid)),"^",12)
		...s TDate=##class(web.DHCEQCommon).TransValueToPage(TDate,"date") ;Modified by QW20170302日期格式统一调整 原i TDate'="" s TDate=$ZD(TDate,3)
		...s TTime=$p($g(^DHCEQInventoryList(rowid)),"^",13)
		...s TTime=##Class(web.DHCEQCommon).TransValueToPage(TTime,"time") ;Modified by QW20170302日期格式统一调整 原i TTime'="" s TTime=$ZT(TTime)
		...s TStatus=$p($g(^DHCEQInventoryList(rowid)),"^",14)
		...s TRemark=$p($g(^DHCEQInventoryList(rowid)),"^",15)
		...s THold1=$p($g(^DHCEQInventoryList(rowid)),"^",16)
		...s THold2=$p($g(^DHCEQInventoryList(rowid)),"^",17)
		...s THold3=$p($g(^DHCEQInventoryList(rowid)),"^",18)
		...s THold4=$p($g(^DHCEQInventoryList(rowid)),"^",19)
		...s THold5=$p($g(^DHCEQInventoryList(rowid)),"^",20)
		...
		...s diffFlag=0
		...i onlyShowDiff="on"  d
		....i TBillEquipDR="" s diffFlag=1
		....i TActerEquipDR="" s diffFlag=1
		....i TBillStoreLocDR'=TActerStoreLocDR s diffFlag=1
		....///i TBillUseLocDR'=TActerUseLocDR s diffFlag=1
		...q:((onlyShowDiff="on")&&(diffFlag'=1))
		...
		...s EquipDR=TBillEquipDR
		...if TBillEquipDR="" s EquipDR=TActerEquipDR
		...//add by zy 2013-06-04 zy0107
		...//增加参数判断盘点是否包含预报废设备，直接取EQ_Hold8字段的值来判断设备的预报废
		...Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(EquipDR)),"^",93)="2")
		...d FillEquipInfoResultList
		...d OutputRowResultList
		//Modified By QW20180927    bug号:QW0019盘盈从盘盈表输出		
		s Erowid=0
		f  s Erowid=$o(^DHCEQInventoryException(0,"Inventory",InventoryDR,Erowid)) q:Erowid=""  d
		.d ResetVarResultList
		.s TBillName=$p($g(^DHCEQInventoryException(Erowid)),"^",2)
		.s TBillNo=$p($g(^DHCEQInventoryException(Erowid)),"^",3)
		.s TActerStoreLocDR=$p($g(^DHCEQInventoryException(Erowid)),"^",9)
		.s TActerStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("deptcode",TActerUseLocDR)
		.s TResultType="盘盈"
		.d OutputRowResultList
		//End By QW20180927       
	}
	
	Quit $$$OK
		
FillEquipInfoResultList
	q:EquipDR=""
	s TEquipName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s TEquipNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	s TModel=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	i TModel '=""  s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	s TEquiCat=$p($g(^DHCEQEquip(EquipDR)),"^",4)
	i TEquiCat'="" s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCat)),"^",2)
	s TEquipType=$p($g(^DHCEQEquip(EquipDR)),"^",63)
	i TEquipType '=""  s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipType)),"^",2)
	s TStatCat=$p($g(^DHCEQEquip(EquipDR)),"^",75)
	i TStatCat'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCat)),"^",2)
	s TUnit = $p($g(^DHCEQEquip(EquipDR)),"^",5) 
	i TUnit '="" s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	s TLeaveFactoryNo = $p($g(^DHCEQEquip(EquipDR)),"^",10)
	s TLeaveFactoryDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(EquipDR)),"^",11),"date")
	s TProvider = $p($g(^DHCEQEquip(EquipDR)),"^",25)
	i TProvider '="" s TProvider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
	s TLimitYearsNum = $p($g(^DHCEQEquip(EquipDR)),"^",31)
	s TDepreMethod = $p($g(^DHCEQEquip(EquipDR)),"^",33)
	i TDepreMethod '="" s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethod)),"^",2)
	s TEquipRemark = $p($g(^DHCEQEquip(EquipDR)),"^",34)
	
	i TBillEquipDR'="" s TBillName=$p($g(^DHCEQEquip(TBillEquipDR)),"^",1)
	i TActerEquipDR'="" s TActerName=$p($g(^DHCEQEquip(TActerEquipDR)),"^",1)
	i TBillEquipDR'="" s TBillNo=$p($g(^DHCEQEquip(TBillEquipDR)),"^",71)
	i TActerEquipDR'="" s TActerNo=$p($g(^DHCEQEquip(TActerEquipDR)),"^",71)
	
	i TBillEquipDR=""
	{
		s TBillName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
		s TBillNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	}
	
	s TBillStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillStoreLocDR)
	s TBillUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillUseLocDR)
	s TActerStoreLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerStoreLocDR)
	s TActerUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerUseLocDR)
	s TManuFactory = $p($g(^DHCEQEquip(EquipDR)),"^",26)
	i TManuFactory '="" s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactory) //CZF0093
	s TOrigin = $p($g(^DHCEQEquip(EquipDR)),"^",20)
	i TOrigin '="" s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOrigin)),"^",2)
	
	s TPlace=$p($g(^DHCEQEquip(EquipDR)),"^",72)
	if (TBillStoreLoc=TActerStoreLoc)
	{	s TResultType="一致"	}
	elseif (TActerStoreLoc="")
	{	s TResultType="未盘点"	}
	else
	{	s TResultType="科室不一致"	}
	
	quit
	
OutputRowResultList
	s TRow=index
	s ^DHCEQTemp(tmpNode,+$H,$j,index)=TRowID_"^"_TInventoryDR_"^"_TBillEquipDR_"^"_TActerEquipDR_"^"_TBillStoreLocDR_"^"_TBillUseLocDR_"^"_TActerStoreLocDR_"^"_TActerUseLocDR_"^"_TBillOriginalFee_"^"_TBillNetFee_"^"_TBillDepreTotalFee_"^"_TUserDR_"^"_TDate_"^"_TTime_"^"_TStatus_"^"_TRemark_"^"_THold1_"^"_THold2_"^"_THold3_"^"_THold4_"^"_THold5_"^"_TBillName_"^"_TActerName_"^"_TBillNo_"^"_TActerNo_"^"_TModel_"^"_TEquiCat_"^"_TEquipType_"^"_TStatCat_"^"_TUnit_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TProvider_"^"_TLimitYearsNum_"^"_TDepreMethod_"^"_TEquipRemark_"^"_TBillStoreLoc_"^"_TBillUseLoc_"^"_TActerStoreLoc_"^"_TActerUseLoc_"^"_TManuFactory_"^"_TOrigin_"^"_TUser_"^"_TPlace_"^"_TResultType
	s Data=$lb(TRowID,TInventoryDR,TBillEquipDR,TActerEquipDR,TBillStoreLocDR,TBillUseLocDR,TActerStoreLocDR,TActerUseLocDR,TBillOriginalFee,TBillNetFee,TBillDepreTotalFee,TUserDR,TDate,TTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TBillName,TActerName,TBillNo,TActerNo,TModel,TEquiCat,TEquipType,TStatCat,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TProvider,TLimitYearsNum,TDepreMethod,TEquipRemark,TBillStoreLoc,TBillUseLoc,TActerStoreLoc,TActerUseLoc,TManuFactory,TOrigin,TUser,$j,TPlace,TResultType,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
	
ResetVarResultList
	set (TRowID,TInventoryDR,TBillEquipDR,TActerEquipDR,TBillStoreLocDR,TBillUseLocDR,TActerStoreLocDR,TActerUseLocDR,TBillOriginalFee,TBillNetFee,TBillDepreTotalFee,TUserDR,TDate,TTime,TStatus,TRemark,THold1,THold2,THold3,THold4,THold5,TBillName,TActerName,TBillNo,TActerNo,TModel,TEquiCat,TEquipType,TStatCat,TUnit,TLeaveFactoryNo,TLeaveFactoryDate,TProvider,TLimitYearsNum,TDepreMethod,TEquipRemark,TBillStoreLoc,TBillUseLoc,TActerStoreLoc,TActerUseLoc,TManuFactory,TOrigin,TUser,TPlace,TResultType,TRow)=""
	quit
}

ClassMethod ResultListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ResultListExecute ]
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

ClassMethod ResultListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ResultListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// modified by ZY  20200625
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","ResultStat","")
Query ResultStat(InventoryDR As %String = "", StoreLocDR As %String = "") As %Query(ROWSPEC = "TLocID:%String,TLocName:%String,TTotalQty:%String,TAmount:%String,TDiffQty:%String,TDiffAmount:%String,TLoseQty:%String,TLoseAmount:%String,TAccordQty:%String,TAccordAmount:%String,TJob:%String,TRow:%String")
{
}

ClassMethod ResultStatExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", StoreLocDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	
	new tmpNode
	new billStoreLocID,equipID,rowid,IncludeFlag
	new TLocID,TLocName,TTotalQty,TAmount,TDiffQty,TDiffAmount,TLoseQty,TLoseAmount,TAccordQty,TAccordAmount,TJob
	new originalFee
	new TTotalQtySum,TAmountSum,TDiffQtySum,TDiffAmountSum,TLoseQtySum,TLoseAmountSum,TAccordQtySum,TAccordAmountSum
	
	//add by zy 2013-06-04 zy0107
	//增加参数判断盘点是否包含预报废设备，直接取EQ_Hold8字段的值来判断设备的预报废
	s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")	//盘点是否包含预报废设备
	s tmpNode="DHCEQInventory.ResultStat"
	d ##Class(web.DHCEQCommon).KillTempGlobal(tmpNode)
	s TJob=$j
	
	if ((InventoryDR'="")&&(+$p($g(^DHCEQInventory(InventoryDR)),"^",10)>0))
	{
		s (TTotalQtySum,TAmountSum,TDiffQtySum,TDiffAmountSum,TLoseQtySum,TLoseAmountSum,TAccordQtySum,TAccordAmountSum)=0
		s billStoreLocID=0
		f  s billStoreLocID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID))  quit:((billStoreLocID=""))  d
		.//modified by ZY  20200625
		.//q:(StoreLocDR'="")&&(StoreLocDR'=billStoreLocID)
		.q:(StoreLocDR'="")&&(##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(StoreLocDR,billStoreLocID,"1")'="1")
		.s TLocID=billStoreLocID
		.s TLocName=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocID)
		.s (TTotalQty,TAmount,TDiffQty,TDiffAmount,TLoseQty,TLoseAmount,TAccordQty,TAccordAmount)=0
		.s equipID=0
		.f  s equipID=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID,equipID))  quit:((equipID=""))  d
		..
		..//add by zy 2013-06-04 zy0107
		..//增加参数判断盘点是否包含预报废设备，直接取EQ_Hold8字段的值来判断设备的预报废
		..Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(equipID)),"^",93)="2")
		..s rowid=0
		..f  s rowid=$o(^DHCEQInventoryList(0,"StoreLoc",InventoryDR,billStoreLocID,equipID,rowid))  quit:((rowid=""))  d
		...s TTotalQty=TTotalQty+1
		...s TTotalQtySum=TTotalQtySum+1
		...s originalFee=+$p($g(^DHCEQInventoryList(rowid)),"^",8)
		...s TAmount=TAmount+originalFee
		...s TAmountSum=TAmountSum+originalFee
		...i TLocID=$p($g(^DHCEQInventoryList(rowid)),"^",6) d
		....s TAccordQty=TAccordQty+1
		....s TAccordAmount=TAccordAmount+originalFee
		....s TAccordQtySum=TAccordQtySum+1
		....s TAccordAmountSum=TAccordAmountSum+originalFee
		....// MZY0048	2020-08-21	修正差异数及未盘数统计
		...e  d
		....s TDiffQty=TDiffQty+1
		....s TDiffAmount=TDiffAmount+originalFee
		....s TDiffQtySum=TDiffQtySum+1
		....s TDiffAmountSum=TDiffAmountSum+originalFee
		...if $p($g(^DHCEQInventoryList(rowid)),"^",14)="" d
		....s TLoseQty=TLoseQty+1
		....s TLoseAmount=TLoseAmount+originalFee
		....s TLoseQtySum=TLoseQtySum+1
		....s TLoseAmountSum=TLoseAmountSum+originalFee
		.d OutputRowResultStat
		
		s TLocID=""
		s TLocName=""
		s TLocName="合计"
		s TTotalQty=TTotalQtySum
		s TAmount=TAmountSum
		s TDiffQty=TDiffQtySum
		s TDiffAmount=TDiffAmountSum
		s TLoseQty=TLoseQtySum
		s TLoseAmount=TLoseAmountSum
		s TAccordQty=TAccordQtySum
		s TAccordAmount=TAccordAmountSum
		d OutputRowResultStat
	}
	Quit $$$OK
	
OutputRowResultStat
	s TRow=index
	s ^DHCEQTemp(tmpNode,+$H,TJob,index)=TLocID_"^"_TLocName_"^"_TTotalQty_"^"_TAmount_"^"_TDiffQty_"^"_TDiffAmount_"^"_TLoseQty_"^"_TLoseAmount_"^"_TAccordQty_"^"_TAccordAmount_"^"_TJob
	s Data=$lb(TLocID,TLocName,TTotalQty,TAmount,TDiffQty,TDiffAmount,TLoseQty,TLoseAmount,TAccordQty,TAccordAmount,TJob,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ResultStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ResultStatExecute ]
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

ClassMethod ResultStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ResultStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 新增:2010-05-31 党军 DJ0046
/// 描述:获取当前盘点的过滤条件
ClassMethod GetInventoryFilterInfo(InventoryDR)
{
	s Status="0:"_$p($g(^DHCEQInventory(InventoryDR)),"^",10)
	s FilterInfo=""
	s ConditonName=0
	f  s ConditonName=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditonName)) quit:ConditonName=""  d
	.s ID=$o(^DHCEQInventoryFilterInfo(0,"Inventory",InventoryDR,ConditonName,0))
	.s Value=$p($g(^DHCEQInventoryFilterInfo(ID)),"^",3)
	.s FilterInfo=FilterInfo_ConditonName_":"_Value_"|"
	i FilterInfo="" q Status
	q Status_"|"_FilterInfo
}

ClassMethod UpdateInventory(InventoryDR, IsDel)
{
	k PLIST
	TSTART
	i IsDel=1
	{

		&SQL(Delete from sqluser.DHC_EQInventoryFilterInfo Where IFI_InventoryDR=:InventoryDR)
		i (SQLCODE'=0)&&(SQLCODE'=100)
		{
			TROLLBACK
			q SQLCODE
		}
		&SQL(Delete from sqluser.DHC_EQInventoryList Where IL_InventoryDR=:InventoryDR)
		i (SQLCODE'=0)&&(SQLCODE'=100)
		{
			TROLLBACK
			q SQLCODE
		}		
		&SQL(Delete from sqluser.DHC_EQInventory Where I_RowID=:InventoryDR and I_Status=0)
	}
	i IsDel=2
	{
		// MZY0042	1410910		2020-8-4
		s Flag=0		;未盘点标识
		s rowid=0
		f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid)) q:(rowid="")||(Flag=1)  d
		.i $p($g(^DHCEQInventoryList(rowid)),"^",6)="" s Flag=1		;IL_ActerStoreLocDR
		i (##class(web.DHCEQCommon).GetSysInfo("992005")=1)&&(Flag=1) q -9000
		
		s PLIST(11)=2
		s PLIST(13)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
		s PLIST(14)=+$H
		&SQL(Update sqluser.DHC_EQInventory values :PLIST() Where I_RowID=:InventoryDR)
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q InventoryDR
}

/// add by:GBX 2015-1-28 14:44:03  GBX0034
ClassMethod GetList(gnum, rows As %Library.String = "", job)
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s str=^DHCEQTemp("DHCEQInventoryListInfo",curuser,+$H,job,gnum)
	if rows'=""
	{		
		for i=1:1:rows-1
		{
			s str=str_$c(2)_^DHCEQTemp("DHCEQInventoryListInfo",curuser,+$H,job,gnum+i)
		}
	}
 	//s str=^DHCEQTemp("Equip",+$H,$j,gnum)
  	q str
}

/// add by:GBX 2015-1-28 14:44:03  GBX0034
ClassMethod GetNum(node As %Library.String = "", job)
{
	s curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s gnum=$o(^DHCEQTemp("DHCEQInventoryListInfo",curuser,+$H,job,""),-1)
 	//s gnum=$o(^DHCEQTemp("Equip",+$H,$j,""),-1)
  	q gnum
}

/// modified by zy 2015-08-25 ZY0136
/// w ##Class(web.DHCEQInventory).SaveInventoryResult("1^1^1^dddd&2^3^3^dddd")
ClassMethod SaveInventoryResult(valList, ListInfo As %String = "")
{
	new len,i,SQLCODE,info,ILRowID,InventoryDR
	s InventoryDR=""
	s $ZT="ERRORSaveInventoryResult"			//modified by czf 2020-06-30 begin
	s ivlisyscode=##class(web.DHCEQCommon).GetSysInfo("992006")		//盘点业务明细表是否启用完好状态信息,设备信息调整,上传图片 0:不启用  1:启用
	
	s ILIRowID=""	
	TSTART
	s (len,i,SQLCODE)=0
	s len=$l(valList,"&")	
	for i=1:1:len
	{
		k PLIST
		q:SQLCODE'=0
		s info=$p(valList,"&",i)
		s list=$p(ListInfo,"&",i)
		s ILRowID=$p(info,"^",1)
		q:ILRowID=""
		s InventoryDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",1)		//add by czf 20200714
		s InventoryLocDR=$p(info,"^",2)
		s PLIST(4)=$p($g(^DHCEQInventoryList(ILRowID)),"^",2)
		s PLIST(7)=$p(info,"^",2)
		s PLIST(8)=$p(info,"^",3)
		;modified by czf 20200629 begin
		s User=$p(info,"^",7)
		i User="" s User=%session.Get("LOGON.USERID")
		s User=##Class(web.DHCEQCommon).getMapIDBySource("user",User)
		s PLIST(12)=User	;IL_UserDR
		s PLIST(13)=+$H
		s PLIST(14)=+$p($H,",",2)
		s PLIST(16)=$p(info,"^",4)		;Reamrk
		s PLIST(15)=$p(info,"^",5)		;ILStatus
		s PLIST(22)=$p(info,"^",6)		;Condition
		;modified by czf 20200629 end
		
		;modifyed by zx 20220730
		s PLIST(26)=$p(info,"^",8)		;UseStatus
		s PLIST(27)=$p(info,"^",9)		;Purpose
		s PLIST(28)=$p(info,"^",10)		;LossReasonDR
		s ResultType= $p(info,"^",11)
		
		if ((ResultType'=5)&&(ResultType'=6))
		{
			&SQL(Update sqluser.DHC_EQInventoryList values :PLIST() Where IL_RowID=:ILRowID)
			i SQLCODE=100 s SQLCODE=0
			q:SQLCODE'=0
		}
		else
		{
			s BillEquipDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",2)
			s BillStoreLocDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",4)
			s ReInventoryDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",1)
			s InFlag=##Class(web.DHCEQ.EM.BUSInventory).CheckInventoryLocStatus(ReInventoryDR,BillStoreLocDR)
			if (InFlag=0)
			{
				&SQL(Update sqluser.DHC_EQInventoryList values :PLIST() Where IL_RowID=:ILRowID)
				i SQLCODE=100 s SQLCODE=0
				q:SQLCODE'=0
				s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(ReInventoryDR,BillStoreLocDR)
				q:SQLCODE'=0
				s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(ReInventoryDR,BillStoreLocDR,1) //add by jyp2022-09-21
				q:SQLCODE'=0
			}
			s ELLocation=$p(list,"^",4)
			s ELocationDR=""
			i ELLocation'=""
			{
				&SQL(select L_RowID into :ELocationDR from sqluser.DHC_EQCLocation Where L_Desc=:ELLocation)
				i SQLCODE=100 s SQLCODE=0
				i ELocationDR=""
				{
					s ELocationcode=##class(web.DHCEQCHanZiEncoding).GetEncoding(ELLocation,4,"","U")
					&SQL(insert into sqluser.DHC_EQCLocation set L_Code=:ELocationcode,L_Desc=:ELLocation)
					i SQLCODE q
					s ELocationDR=$g(%ROWID)
				}
			}
			s IEDisposeStatus=""
			s IEStatus=""
			if (ReInventoryDR'="")&&(InventoryDR'="")
			{
				if ($p($g(^DHCEQInventory(InventoryDR)),"^",22)=$p($g(^DHCEQInventory(ReInventoryDR)),"^",22))
				{
					if (InventoryLocDR'=$p($g(^DHCEQEquip(BillEquipDR)),"^",69))
					{
						s IEDisposeStatus=2
						s IEStatus=1
					}
					else
					{
						s IEDisposeStatus=1
						s IEStatus=2
					}
				}
				else
				{
					if (InventoryLocDR'=$p($g(^DHCEQEquip(BillEquipDR)),"^",69))
					{
						s IEDisposeStatus=7
						s IEStatus=3
					}
					else
					{
						s IEDisposeStatus=1
						s IEStatus=2
					}
				}
			}
			else
			{
				s IEDisposeStatus=6
				s IEStatus=2
			}
			s ExceptionInfo=$p($g(^DHCEQEquip(BillEquipDR)),"^",1)_"^"_$p($g(^DHCEQEquip(BillEquipDR)),"^",71)_"^"_$p($g(^DHCEQEquip(BillEquipDR)),"^",27)_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("model",$p($g(^DHCEQEquip(BillEquipDR)),"^",3))_"^"_$p($g(^DHCEQEquip(BillEquipDR)),"^",44)_"^"_$p($g(^DHCEQEquip(BillEquipDR)),"^",45)_"^"_$p($g(^DHCEQEquip(BillEquipDR)),"^",19)_"^"_InventoryLocDR_"^"_$p($g(^DHCEQEquip(BillEquipDR)),"^",26)_"^"_$p($g(^DHCEQEquip(BillEquipDR)),"^",25)_"^"_ELocationDR_"^"_$p($g(^DHCEQEquip(BillEquipDR)),"^",10)_"^^^^1^^^^^"_$p(info,"^",8)_"^"_$p(info,"^",9)_"^"_BillEquipDR_"^"_##Class(web.DHCEQCommon).GetTrakNameByID("brand",$p($g(^DHCEQEquip(BillEquipDR)),"^",93))_"^"_$p(list,"^",3)_"^2^"_$p($g(^DHCEQEquip(BillEquipDR)),"^",63)_"^"_IEDisposeStatus_"^^"_IEStatus_"^^"_User
			s SQLCODE=##Class(web.DHCEQInventory).SaveExceptionResult(InventoryDR,ExceptionInfo)
			q:SQLCODE'=0
			s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR,InventoryLocDR)
			q:SQLCODE'=0
			s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR,InventoryLocDR,1)  //add by jyp2022-09-21
			q:SQLCODE'=0
		}
		
		i ivlisyscode=1
		{
			s list=$p(ListInfo,"&",i)
			s ILIRowID=$p(list,"^",1)
			s EquipDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",2)
			s LocationDR=$p($g(^DHCEQEquip(EquipDR)),"^",72)
			s LeaveFacNo=$p($g(^DHCEQEquip(EquipDR)),"^",10)
			s KeeperDR=$p($g(^DHCEQEquip(EquipDR)),"^",66)
			s ILIKeeperDR=$p(list,"^",3)		;ILI_KeeperDR
			s ILILocation=$p(list,"^",4)		;ILI_LocationDR		//modified by czf 20200710 begin
			s ILILeaveFactoryNo=$p(list,"^",5)	;ILI_LeaveFactoryNo
			s $p(list,"^",7)=ILILocation
			s ILILocationDR=""
			i ILILocation'=""
			{
				&SQL(select L_RowID into :ILILocationDR from sqluser.DHC_EQCLocation Where L_Desc=:ILILocation)
				i SQLCODE=100 s SQLCODE=0
				i ILILocationDR=""
				{
					s Locationcode=##class(web.DHCEQCHanZiEncoding).GetEncoding(ILILocation,4,"","U")
					&SQL(insert into sqluser.DHC_EQCLocation set L_Code=:Locationcode,L_Desc=:ILILocation)
					i SQLCODE q
					s ILILocationDR=$g(%ROWID)
				}
			}
			s $p(list,"^",4)=ILILocationDR		//modified by czf 20200710 end
			//i KeeperDR=ILIKeeperDR s $p(list,"^",3)=""
			//i LocationDR=ILILocationDR s $p(list,"^",4)=""
			//i LeaveFacNo=ILILeaveFactoryNo s $p(list,"^",5)=""
			//当盘点调整信息和台帐一致时无效已存在的调整记录
			i ((KeeperDR=ILIKeeperDR)&&(LocationDR=ILILocationDR)&&(LeaveFacNo=ILILeaveFactoryNo))	
			{
				i ILIRowID'=""
				{
					&SQL(Update SQLUSER.DHC_EQInventoryListInfo set ILI_InvalidFlag='Y' where ILI_RowID = :ILIRowID)
				}
			}
			else
			{
				s ILIRowID=##Class(web.DHCEQ.EM.BUSInventory).SaveListInfo(list)
				i ILIRowID<0 s SQLCODE=ILIRowID
			}
			q:SQLCODE'=0
		}
	}
	i SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	//modified by czf 20200714
	i InventoryDR'="" s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR)
	i SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	i InventoryDR'="" s SQLCODE = ##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR,"",1)  //add by jyp2022-09-21
	i SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	TCOMMIT
	Quit SQLCODE_"^"_ILIRowID
	
ERRORSaveInventoryResult
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit -9000			//modified by czf 2020-06-30 end
}

/// modified by zx 2016-04-06 ZY0036
/// 保存盘盈明细
/// /Modified By QW20180927 bug号:QW0017 盘盈类型保存到Hold1字段
ClassMethod UpLoadExceptionResult(InventoryDR, BatchInfos)
{
	new num,info,results,result
	new EquipName, EquipNo, Model, UseLocDR, StoreLocDR, Remark,ExceptionType ;Modified By QW20171208 bug号:QW0017 盘盈类型保存到Hold1字段
	s results=""
	s num=$l(BatchInfos,"%")	
	
	for i=1:1:num
	{
		s info=$p(BatchInfos,"%",i)
		
		s EquipName=$p(info,"^",1)
		s EquipNo=$p(info,"^",2)
		s Model=$p(info,"^",3)
		s UseLocDR=$p(info,"^",4)
		s StoreLocDR=$p(info,"^",5)
		s Remark=$p(info,"^",6)
		;Modified By QW20171208 bug号:QW0017 盘盈类型保存到Hold1字段
		s ExceptionType=$p(info,"^",7)  ;hold1 ->ExceptionType
		s valList=EquipName_"^"_EquipNo_"^^"_Model_"^^^"_UseLocDR_"^"_StoreLocDR_"^^^^^^^"_Remark_"^"_ExceptionType_"^^^^"
		;End  By QW20171208 
		s result=##Class(web.DHCEQInventory).SaveExceptionResult(InventoryDR,valList)
		i results'="" s results=results_"^"
		s results=results_result
	}
	q results
}

/// modified by zx 2016-04-06 ZY0036
/// 保存盘盈明细
ClassMethod SaveExceptionResult(InventoryDR, val)
{
	k PLIST
	if InventoryDR="" q ""
	s IERowID=""
	if ($p(val,"^",2)'="")
	{
		s IERowID=$o(^DHCEQInventoryException(0,"EquipNo",$p(val,"^",2),0))
	}
	s PLIST(2)=InventoryDR //IE_InventoryDR
    s PLIST(3)=$p(val,"^",1) //IE_EquipName
    s PLIST(4)=$p(val,"^",2)  //IE_EquipNo
    s PLIST(5)=$p(val,"^",3)  //IE_OriginalFee
    s PLIST(6)=$p(val,"^",4)  //IE_Model
    s PLIST(7)=$p(val,"^",5)  //IE_StartDate
    s PLIST(8)=$p(val,"^",6)  //IE_TransAssetDate
    s PLIST(9)=$p(val,"^",7)  //IE_UserLocDR
    s PLIST(10)=$p(val,"^",8)  //IE_StoreLocDR
    s PLIST(11)=$p(val,"^",9)  //IE_ManuFactoryDR
    s PLIST(12)=$p(val,"^",10)  //IE_ProviderDR
    s PLIST(13)=$p(val,"^",11)  //IE_Place
    s PLIST(14)=$p(val,"^",12)  //IE_LeaveFactoryNo
    s PLIST(15)=+$H  //IE_Date
    s PLIST(16)=+$p($H,",",2)  //IE_Time
    s PLIST(17)=$p(val,"^",15)  //IE_Remark
    s PLIST(18)=$p(val,"^",16)  //IE_Hold1
    s PLIST(19)=$p(val,"^",17)  //IE_Hold2
    s PLIST(20)=$p(val,"^",18)  //IE_Hold3
    s PLIST(21)=$p(val,"^",19)  //IE_Hold4
    s PLIST(22)=$p(val,"^",20)  //IE_Hold5
    s PLIST(23)=$p(val,"^",21)  //IE_UseStatus
    s PLIST(24)=$p(val,"^",22)  //IE_Purpose
    s PLIST(25)=$p(val,"^",23)  //IE_ActerEquipDR
    s PLIST(26)=$p(val,"^",24)  //IE_Brand
    s PLIST(27)=$p(val,"^",25)  //IE_KeeperDR
    s PLIST(28)=$p(val,"^",26)  //IE_ProfitReasonDR
   	s PLIST(29)=$p(val,"^",27)  //IE_EquipTypeDR
   	s PLIST(30)=$p(val,"^",28)  //IE_DisposeStatus
   	s PLIST(31)=$p(val,"^",29)  //IE_DisposeResult
   	s PLIST(32)=$p(val,"^",30)  //IE_Status
   	s PLIST(33)=$p(val,"^",31)  //IE_User
    i IERowID=""
    {
    	&SQL(Insert into sqluser.DHC_EQInventoryException values :PLIST())
    }
    else
    {
	  	&SQL(update sqluser.DHC_EQInventoryException values :PLIST() where IE_RowID=:IERowID)  
	}
    
    q SQLCODE
}

/*************
*需求号:457270 Add by QW20170928
*判断盘点单状态是否可下载上传
*************/
ClassMethod CheckInventoryStatus(InventoryDR)
{
	s result=""
	s result=$p($g(^DHCEQInventory(InventoryDR)),"^",10)
	q result
}

ClassMethod GetUnCheckNum(vJob As %String = "")
{
	i vJob="" q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	q $o(^DHCEQTemp("DHCEQInventoryListInfo",User,+$H,vJob,""),-1)
}

/// Add By QW20180927 QW0018
/// 获取pc端维护的广播消息设置
/// 入参:Type:0-获取扫码广播,其他待定
/// 出参:TRowID-id  TName-广播名称 TKey-取消息key值
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","QueryPDABroadcast")
Query QueryPDABroadcast(Type As %String = "0") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TKey:%String")
{
}

ClassMethod QueryPDABroadcastExecute(ByRef qHandle As %Binary, Type As %String = "0") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCPDABroadcast",0,"BroadcastType",Type,rowid))  quit:rowid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQCPDABroadcast",rowid)),"^",8)="N"
	.q:$p($g(^DHCEQCCode("DHCEQCPDABroadcast",rowid)),"^",9)="Y"
	.d ResetVariablesQueryPDABroadcast
	.s TRowID=rowid
	.s TName=$p($g(^DHCEQCCode("DHCEQCPDABroadcast",rowid)),"^",2) //广播名称
	.s TKey=$p($g(^DHCEQCCode("DHCEQCPDABroadcast",rowid)),"^",3) //取广播消息key值
	.d OutputRowQueryPDABroadcast
	
	Quit $$$OK

OutputRowQueryPDABroadcast
	s Data=$lb(TRowID,TName,TKey)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesQueryPDABroadcast
	s (TRowID,TName,TKey)=""
	quit
}

ClassMethod QueryPDABroadcastFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPDABroadcastExecute ]
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

ClassMethod QueryPDABroadcastClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPDABroadcastExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By DJ 2019-07-04
/// 描述:按科室生成全院所有科室盘点单
/// d ##Class(web.DHCEQInventory).UpdLocInventory()
ClassMethod UpdLocInventory()
{
	s GroupETIDS=##Class(web.DHCEQCommon).GetEquipTypesByGroup()
	s GroupETIDS=##Class(web.DHCEQCommon).Replace(GroupETIDS,"^",",")
	s SQLCODE=0
	s EQStoreLocDR=0
	f  s EQStoreLocDR=$o(^DHCEQEquip(0,"StoreEquipType","N",1,EQStoreLocDR))  q:(EQStoreLocDR="")||(SQLCODE'=0)  d
	.;检测是否存在当前科室未完成盘点单
	.s FindRowID=0
	.s IRowID=0
	.f  s IRowID=$o(^DHCEQInventory(0,"StoreLoc",EQStoreLocDR,IRowID))  q:(IRowID="")||(FindRowID'=0)  d
	..s IStatus=$p($g(^DHCEQInventory(IRowID)),"^",10)
	..q:IStatus=2
	..s FindRowID=IRowID
	.q:FindRowID'=0
	.s LocInventoryInfo=##Class(web.DHCEQInventory).SaveInventory(0,"",EQStoreLocDR,"",GroupETIDS,"","","","")
	.i +LocInventoryInfo<0	s SQLCODE=LocInventoryInfo
	.q:SQLCODE'=0
	.s LocInventoryDR=$p(LocInventoryInfo,"^",2)
	.s SQLCODE=##Class(web.DHCEQInventory).FreezeInventory(LocInventoryDR,EQStoreLocDR,"",GroupETIDS,"","","","","")
	.i SQLCODE s SQLCODE="-1^确认盘点单失败!"
	
	q SQLCODE
}

/// add by sjh 2019-11-25  盘点单润乾打印 BUG00018
/// modify by mwz 2020-03-08 MWZ0029 修改判断逻辑，增加输出字段TInventoryNo,TBillOriginalFee:,TFreezeDate  增加润乾session参数   MWZ0064 :增加HospitalDR参数
/// TRowID,TName,TModel,TManufactory,TNo,TUnit,TStoreLoc,TInDate,TInventoryNo
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","InventoryPrint","1","","1")
Query InventoryPrint(InventoryDR As %String = "", PrintLocDR As %String = "", StoreLocDR As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", HospitalDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TModel:%String,TManufactory:%String,TNo:%String,TUnit:%String,TInDate:%String,TActerStoreLoc:%String,TBillStoreLoc:%String,TResultType:%String,PrintLocDRTitle:%String,InventoryNoTitle:%String,TInventoryNo:%String,TBillOriginalFee:%String,TFreezeDate:%String,TStatusDesc:%String,TInventoryNum:%String,TILConditionDesc:%String,TRemark:%String,TDisApprove:%String,TNum:%String") [ SqlProc ]
{
}

ClassMethod InventoryPrintExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", PrintLocDR As %String = "", StoreLocDR As %String = "", StartDate As %String = "", EndDate As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "", HospitalDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s (PrintLocDRTitle,InventoryNoTitle)=""  // modify  by wl 2020-02-25 WL0056 begin 
	//modify by mwz 2020-03-08 MWZ0029 begin
	s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")  
	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")  
 	i StartDate="" s StartDate=0
 	i EndDate="" s EndDate=+$H
	//modify by mwz 2020-03-08 MWZ0029 end
	i PrintLocDR'=""  d  
	.s StoreLocDR=PrintLocDR		
	.s PrintLocDRTitle="科室: "_##Class(web.DHCEQCommon).GetTrakNameByID("dept",PrintLocDR)
	i InventoryDR'="" d 
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,rowid)) q:rowid=""  d
	..d ResetVariablesInventoryPrint
	..//modify by mwz 2020-03-08 MWZ0029 begin
	..s InventoryNoTitle="盘点单号: "_$p($g(^DHCEQInventory(InventoryDR)),"^",1)
	..s TInventoryNo=$p($g(^DHCEQInventory(InventoryDR)),"^",1)
	..//modify by mwz 2020-03-08 MWZ0029 end
	..s EquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2) q:EquipDR=""
	..s TName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	..s TModel=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	..i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	..s TManufactory=$p($g(^DHCEQEquip(EquipDR)),"^",26)
	..i TManufactory'="" s TManufactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManufactory) //CZF0093
	..//modify by mwz 2020-03-08 MWZ0029 begin
	..s TFreezeDate=$p($g(^DHCEQInventory(InventoryDR)),"^",17)
	..q:(StartDate'="")&&(StartDate>TFreezeDate)
	..q:(EndDate'="")&&(EndDate<TFreezeDate)
	..i TFreezeDate'="" s TFreezeDate=##Class(web.DHCEQCommon).TransValueToPage(TFreezeDate,"date")
	..//modify by mwz 2020-03-08 MWZ0029 end
	..s TNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	..s TUnit=$p($g(^DHCEQEquip(EquipDR)),"^",5)
	..i TUnit'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	..s TInDate=$p($g(^DHCEQEquip(EquipDR)),"^",45)
	..i TInDate="" s TInDate=$p($g(^DHCEQEquip(EquipDR)),"^",53)
	..i TInDate'="" s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	..s TBillOriginalFee=+$p($g(^DHCEQInventoryList(rowid)),"^",8)
	..s TActerStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",6)	
	..s TBillStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",4)
	..//add by mwz 20221101 MWZ0064
	..s THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TBillStoreLocDR)
	..q:(HospitalDR'="")&&(THospitalDR'="")&&(HospitalDR'=THospitalDR)
	..q:(PrintLocDR'="")&&(TBillStoreLocDR'=PrintLocDR)
	..q:(StoreLocDR'="")&&(TBillStoreLocDR'=StoreLocDR)
	..i TActerStoreLocDR'="" s TActerStoreLoc= ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerStoreLocDR)
	..i TBillStoreLocDR'="" s TBillStoreLoc= ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillStoreLocDR) 
	..s TRowID=rowid
	..i (TBillStoreLoc=TActerStoreLoc) d 
	...s TResultType="一致"	
	..e  i (TActerStoreLoc="")  d
	...s TResultType="未盘点"	
	..e  d
	...s TResultType="科室不一致"
	..s TStatus=$p($g(^DHCEQInventoryList(rowid)),"^",14)  //TStatusDesc,TInventoryNum,TILConditionDesc,TRemark,TDisApprove
	..s TStatusDesc=$CASE(TStatus,"1":"账务一致","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","":"")
	..i (TStatus=1)||(TStatus=2) s TInventoryNum=1
	..i (TStatus=3)||(TStatus=4) s TInventoryNum=0
	..s TILCondition=$p($g(^DHCEQInventoryList(rowid)),"^",21)
	..s TILConditionDesc=$CASE(TILCondition,"0":"在用","1":"待报废","2":"闲置","":"")
	..s TRemark=$p($g(^DHCEQInventoryList(rowid)),"^",15)
	..s TAdvanceDisFlag=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus($p($g(^DHCEQEquip(EquipDR)),"^",93))	// 异常状态信息
	..s (DRLRowID,DRRowID,ApproveRoleDR,TDisApprove)=""
	..s DRLRowID=$order(^DHCEQDisuseRequestList(0,"EquipDR",EquipDR,DRLRowID))
	..i DRLRowID'=""  d
	...s DRRowID=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",1)
	...i DRRowID'=""  d
	....s TDisApprove=##Class(web.DHCEQBatchDisuseRequest).GetDisuseApproveRole(DRRowID)
	..d OutputRowInventoryPrint
	////modify by mwz 2020-03-08 MWZ0029 begin
	e  d 		 
	.s rowid=0
	.f  s rowid=$o(^DHCEQInventoryList(rowid)) q:rowid=""  d
	..d ResetVariablesInventoryPrint
	..s InventoryDR=$p($g(^DHCEQInventoryList(rowid)),"^",1)
	..s TInventoryNo=$p($g(^DHCEQInventory(InventoryDR)),"^",1)
	..s EquipDR=$p($g(^DHCEQInventoryList(rowid)),"^",2) q:EquipDR=""
	..s TName=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	..s TModel=$p($g(^DHCEQEquip(EquipDR)),"^",3)
	..i TModel'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	..s TManufactory=$p($g(^DHCEQEquip(EquipDR)),"^",26)
	..i TManufactory'="" s TManufactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManufactory) //CZF0093
	..s TFreezeDate=$p($g(^DHCEQInventory(InventoryDR)),"^",17)
	..q:(StartDate'="")&&(StartDate>TFreezeDate)
	..q:(EndDate'="")&&(EndDate<TFreezeDate)
	..i TFreezeDate'="" s TFreezeDate=##Class(web.DHCEQCommon).TransValueToPage(TFreezeDate,"date")
	..s TNo=$p($g(^DHCEQEquip(EquipDR)),"^",71)
	..s TUnit=$p($g(^DHCEQEquip(EquipDR)),"^",5)
	..i TUnit'="" s TUnit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnit)
	..s TInDate=$p($g(^DHCEQEquip(EquipDR)),"^",45)
	..i TInDate="" s TInDate=$p($g(^DHCEQEquip(EquipDR)),"^",53)
	..i TInDate'="" s TInDate=##Class(web.DHCEQCommon).TransValueToPage(TInDate,"date")
	..s TBillOriginalFee=+$p($g(^DHCEQInventoryList(rowid)),"^",8)
	..s TActerStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",6)	
	..q:(PrintLocDR'="")&&(TActerStoreLocDR'=PrintLocDR)
	..s TBillStoreLocDR=$p($g(^DHCEQInventoryList(rowid)),"^",4)
	..//add by mwz 20221101 MWZ0064
	..s THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TBillStoreLocDR)
	..q:(HospitalDR'="")&&(THospitalDR'="")&&(HospitalDR'=THospitalDR)
	..i TActerStoreLocDR'="" s TActerStoreLoc= ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActerStoreLocDR)
	..i TBillStoreLocDR'="" s TBillStoreLoc= ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillStoreLocDR) 
	..s TRowID=rowid
	..i (TBillStoreLoc=TActerStoreLoc) d 
	...s TResultType="一致"	
	..e  i (TActerStoreLoc="")  d
	...s TResultType="未盘点"	
	..e  d
	...s TResultType="科室不一致"
	..s TStatus=$p($g(^DHCEQInventoryList(rowid)),"^",14)  //TStatusDesc,TInventoryNum,TILConditionDesc,TRemark,TDisApprove
	..// MZY0154	3280859		2023-03-03
	..s TNum=1
	..s TStatusDesc=$CASE(TStatus,"1":"账实相符","2":"科室不符","3":"盘亏","4":"待查找","5":"有报废单","":"")
	..i (TStatus=1)||(TStatus=2) s TInventoryNum=1
	..i (TStatus=3)||(TStatus=4) s TInventoryNum=0
	..s TILCondition=$p($g(^DHCEQInventoryList(rowid)),"^",21)
	..s TILConditionDesc=$CASE(TILCondition,"0":"在用","1":"待报废","2":"闲置","":"")
	..s TRemark=$p($g(^DHCEQInventoryList(rowid)),"^",15)
	..s TAdvanceDisFlag=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus($p($g(^DHCEQEquip(EquipDR)),"^",93))	// 异常状态信息
	..s (DRLRowID,DRRowID,ApproveRoleDR,TDisApprove)=""
	..s DRLRowID=$order(^DHCEQDisuseRequestList(0,"EquipDR",EquipDR,DRLRowID))
	..i DRLRowID'=""  d
	...s DRRowID=$p($g(^DHCEQDisuseRequestList(DRLRowID)),"^",1)
	...i DRRowID'=""  d
	....s TDisApprove=##Class(web.DHCEQBatchDisuseRequest).GetDisuseApproveRole(DRRowID)
	..d OutputRowInventoryPrint
	//modify by mwz 2020-03-08 MWZ0029 end
	quit $$$OK
OutputRowInventoryPrint
	///add by ZY0265 20210526
	s TLocation=$Piece($Get(^DHCEQEquip(EquipDR)),"^",72)
	i TLocation'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",1)
	s Data=$lb(TRowID,TName,TModel,TManufactory,TNo,TUnit,TInDate,TActerStoreLoc,TBillStoreLoc,TResultType,PrintLocDRTitle,InventoryNoTitle,TInventoryNo,TBillOriginalFee,TFreezeDate,TStatusDesc,TInventoryNum,TILConditionDesc,TRemark,TDisApprove,TNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
ResetVariablesInventoryPrint
	s (TRowID,TName,TModel,TManufactory,TNo,TUnit,TInDate,TActerStoreLoc,TBillStoreLoc,TResultType,TInventoryNo,TBillOriginalFee,TFreezeDate,TStatusDesc,TInventoryNum,TILConditionDesc,TRemark,TDisApprove,TNum)="" //modify by wl 2020-02-25 WL0056	end
	quit
}

ClassMethod InventoryPrintFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InventoryPrintExecute ]
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

ClassMethod InventoryPrintClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InventoryPrintExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQInventory).GetOneInventory(1)
ClassMethod GetOneInventory(RowID)
{
	s $ZT="ERRORGetOneInventory"
	s ObjInventory=##Class(User.DHCEQInventory).%OpenId(RowID)
	s InventoryInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjInventory)
	d InventoryInfo.%Set("IStoreLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",InventoryInfo.IStoreLocDR))
	d InventoryInfo.%Set("IUseLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",InventoryInfo.IUseLocDR))
	d InventoryInfo.%Set("IEquipTypeDR_ETDesc",InventoryInfo.IEquipTypeDR.ETDesc)
	d InventoryInfo.%Set("IStatCatDR_SCDesc",InventoryInfo.IStatCatDR.SCDesc)
	d InventoryInfo.%Set("IOriginDR_ODesc",InventoryInfo.IOriginDR.ODesc)
	d InventoryInfo.%Set("IUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",InventoryInfo.IUserDR))
	d InventoryInfo.%Set("IManageLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",InventoryInfo.IManageLocDR))
	i (InventoryInfo.IHospitalDR'="") d InventoryInfo.%Set("IHospitalDR_CTLOCDesc",$p($g(^CT("HOSP",InventoryInfo.IHospitalDR)),"^",2))
	d InventoryInfo.%Set("IFreezeUser_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",InventoryInfo.IFreezeUser))
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,InventoryInfo)
ERRORGetOneInventory
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// add by zx 2018-11-29 取消盘点
/// w ##Class(web.DHCEQInventory).CancelInventoryResult("1")
ClassMethod CancelInventoryResult(ILRowID)
{
	k PLIST			//add by czf 20200630 begin
	s SQLCODE=0			
	s $ZT="ERRORCancelInventoryResult"		//modified by czf 2020-07-14 begin

	s PLIST(4)=""
	s PLIST(7)=""
	s PLIST(8)=""
	s PLIST(12)=""
	s PLIST(13)=""
	s PLIST(14)=""
	s PLIST(15)=""
	s PLIST(16)=""
	s PLIST(22)=""
	
	TSTART
	&SQL(Update sqluser.DHC_EQInventoryList values :PLIST() Where IL_RowID=:ILRowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	if ILRowID'=""
	{
		s InvlistinfoDR=""
		s InvlistinfoID=""
		f  s InvlistinfoID=$o(^DHCEQInventoryListInfo(0,"IList",ILRowID,InvlistinfoID)) q:(InvlistinfoID="")||(InvlistinfoDR'="")  d
		.q:$p($g(^DHCEQInventoryListInfo(InvlistinfoID)),"^",5)="Y"
		.s InvlistinfoDR=InvlistinfoID
		i InvlistinfoDR'=""
		{
			&SQL(Update SQLUSER.DHC_EQInventoryListInfo set ILI_InvalidFlag='Y' where ILI_RowID = :InvlistinfoDR)
			i SQLCODE
			{
				TROLLBACK
				q SQLCODE
			}
		}
	}			//add by czf 20200630 end
	
	s InventoryDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",1)	
	s SQLCODE=##Class(web.DHCEQ.EM.BUSInventory).UpdateInventoryAudit(InventoryDR)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	TCOMMIT
	Quit SQLCODE
	
ERRORCancelInventoryResult
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit -9000			//modified by czf 2020-07-14 end
}

/// Modify by zx 2020-07-03 差异列表
/// 获取指定盘点表中的设备信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQInventory","GetInventoryDiffer","211","","","1","257","446","7","2","")
Query GetInventoryDiffer(InventoryDR As %String = "", InventoryLocDR As %String = "", differStatu As %String = "", ManageLocFlag As %String = "", CTLocID As %String = "", CurGroupID As %String = "", CurHospID As %String = "", InvalidFlag As %String = "", EquipTypeDR As %String = "", Equip As %String = "", Model As %String = "") As %Query(ROWSPEC = "TEquipDR:%String,TBillLocID:%String,TBillLocDesc:%String,TEquipNo:%String,TEquipName:%String,TModel:%String,TManufacturer:%String,TPlace:%String,TActLocID:%String,TActLocDesc:%String,TFileNo:%String,TLeaveFactoryNo:%String,TResultType:%String,TLocation:%String,TInventoryListDR:%String")
{
}

ClassMethod GetInventoryDifferExecute(ByRef qHandle As %Binary, InventoryDR As %String = "", InventoryLocDR As %String = "", differStatu As %String = "", ManageLocFlag As %String = "", CTLocID As %String = "", CurGroupID As %String = "", CurHospID As %String = "", InvalidFlag As %String = "", EquipTypeDR As %String = "", Equip As %String = "", Model As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i InventoryDR="" Quit $$$OK
	s IncludeFlag=##class(web.DHCEQCommon).GetSysInfo("990022")
	//Modify by zx 2020-07-12
	s LocIncludeFlag=$p($g(^DHCEQInventory(InventoryDR)),"^",21)
	s ILRowID=0
	f  s ILRowID=$o(^DHCEQInventoryList(0,"Inventory",InventoryDR,ILRowID))  quit:ILRowID=""  d
	.d ResetVariablesGetInventoryDiffer
	.s TInventoryListDR=ILRowID
	.q:$p($g(^DHCEQInventory($p($g(^DHCEQInventoryList(ILRowID)),"^",1))),"^",10)="0"
	.q:(InventoryLocDR'="")&&($p($g(^DHCEQInventoryList(ILRowID)),"^",5)'=InventoryLocDR)
	.q:(ManageLocFlag="0")&&($p($g(^DHCEQInventoryList(ILRowID)),"^",5)="")
	.//Modify by zx 2020-07-12
	.q:(ManageLocFlag'="1")&&(LocIncludeFlag'="Y")&&($p($g(^DHCEQInventoryList(ILRowID)),"^",5)'=CTLocID)
	.q:(ManageLocFlag'="1")&&(LocIncludeFlag="Y")&&((##Class(web.DHCEQ.EM.BUSEquip).CheckIsChildLoc(CTLocID,$p($g(^DHCEQInventoryList(ILRowID)),"^",5),"1")'="1"))
	.s TEquipDR=$p($g(^DHCEQInventoryList(ILRowID)),"^",2)
	.Q:(IncludeFlag="1")&&($p($g(^DHCEQEquip(TEquipDR)),"^",93)="2")
	.// begin add by jyp 2022-08-03
	.s Equip=##Class(web.DHCEQCommon).UnEscape(Equip)
	.s Equip=$ZCONVERT(Equip,"U")
	.s NewEQCode=$p($g(^DHCEQEquip(TEquipDR)),"^",6)
	.s NewName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s No=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.q:($ZCONVERT(No,"U")'[Equip)&&($ZCONVERT(NewEQCode,"U")'[Equip)&&($ZCONVERT(NewName,"U")'[Equip)
	.s TEquipType=$p($g(^DHCEQEquip(TEquipDR)),"^",63)
	.q:(EquipTypeDR'="")&&(EquipTypeDR'=TEquipType)
	.// end add by jyp 2022-08-03
	.s TBillLocID=$p($g(^DHCEQInventoryList(ILRowID)),"^",4)
	.q:TBillLocID=""
	.s TBillLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TBillLocID)
	.s TActLocID=$p($g(^DHCEQInventoryList(ILRowID)),"^",6)
	.//Modify by zx 2020-07-03
	.//"1":"账物一致","2":"科室不符","3":"盘亏","4":"待查找","":""
	.s TStatus=$p($g(^DHCEQInventoryList(ILRowID)),"^",14)	
	.//Modify by zy 2021-11-08
	.//differStatu:1,账物一致;11,不一致;  12,未盘  2,科室不符 3,盘亏
	.q:(differStatu'="")&&(differStatu'="11")&&(differStatu'="12")&&(differStatu'=TStatus)
	.q:(differStatu="11")&&(TStatus="1") //不一致时过滤已盘
	.q:(differStatu="12")&&(TActLocID'="") //未盘时过滤无盘点科室
	.s TResultType=$CASE(TStatus,"1":"账物一致","2":"科室不符","3":"盘亏","4":"盘盈","5":"有报废单","":"")
	.i (TStatus="")&&(TActLocID="") s TResultType="未盘"
	.i TActLocID'="" s TActLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TActLocID)
	.s TEquipNo=$p($g(^DHCEQEquip(TEquipDR)),"^",71)
	.s TEquipName=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TModel=$p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.i TModel '="" s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModel)),"^",2)
	.q:(Model'="")&&($ZCONVERT(TModel,"U")'[$ZCONVERT(Model,"U"))
	.s TManufacturer=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
	.i TManufacturer'="" s TManufacturer=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManufacturer)),"^",1)
	.s TPlace=$p($g(^DHCEQEquip(TEquipDR)),"^",72)
	.i TPlace'="" s TPlace=$p($g(^DHCEQCCode("DHCEQCLocation",TPlace)),"^",2)  ;QW20161212  转换存放地点
	.s TFileNo=$p($g(^DHCEQEquip(TEquipDR)),"^",85)  //add by zx 2015-12-08
	.s TLeaveFactoryNo=$p($g(^DHCEQEquip(TEquipDR)),"^",10)
	.s TInventoryListInfo=##Class(web.DHCEQ.EM.BUSInventory).GetOneListInfo(ILRowID)
	.s TLocationDR=$p(TInventoryListInfo,"^",7)
	.i TLocationDR'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	.d OutputRowGetInventoryDiffer
	Quit $$$OK
OutputRowGetInventoryDiffer
	s Data=$lb(TEquipDR,TBillLocID,TBillLocDesc,TEquipNo,TEquipName,TModel,TManufacturer,TPlace,TActLocID,TActLocDesc,TFileNo,TLeaveFactoryNo,TResultType,TLocation,TInventoryListDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
ResetVariablesGetInventoryDiffer
	s (TEquipDR,TBillLocID,TBillLocDesc,TEquipNo,TEquipName,TModel,TManufacturer,TPlace,TActLocID,TActLocDesc,TFileNo,TLeaveFactoryNo,TResultType,TInventoryListInfo,TLocationDR,TLocation,TInventoryListDR)=""
	quit
}

ClassMethod GetInventoryDifferFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetInventoryDifferExecute ]
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

ClassMethod GetInventoryDifferClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetInventoryDifferExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Add By QW2021 bug号:QW00
ClassMethod CheckBaseInfo(basedata As %String = "")
{
	new (basedata)
	k BBPLIST
	s SQLCODE=0
	s RowID=$p(basedata,"^",1)
	i RowID="" q -9001
	;s BPLIST(2)=$p(basedata,"^",2)	;ILI_InventoryListDR
	s Location=$p(basedata,"^",3)
	s BPLIST(4)=$p(Location,":",1)	;ILI_LocationDR
	i BPLIST(4)="" s BPLIST(4)=##Class(web.DHCEQCLocation).UpdLocation(##class(web.DHCEQCHanZiEncoding).GetEncoding($p(Location,":",2),4,"","U")_"^"_$p(Location,":",2))
	s BPLIST(5)=$p(basedata,"^",4)	;ILI_LeaveFactoryNo
	s userid=$p(basedata,"^",5)	
	s BPLIST(7) = userid		;UpdateUserDR
	s BPLIST(8) = +$H			;UpdateDate
	s BPLIST(9) = $P($H,",",2)	;UpdateTime
	s Hold1=$p(basedata,"^",6)
	s BPLIST(10)=$p(Hold1,":",1)	;ILI_Hold1 生产厂商
	
	i BPLIST(10)="" s BPLIST(10)=##Class(web.DHCEQForTrak).UpdProvider(##class(web.DHCEQCHanZiEncoding).GetEncoding($p(Hold1,":",2),4,"","U")_"^"_$p(Hold1,":",2)_"^^^3",userid)
	s Hold2=$p(basedata,"^",7)
	s BPLIST(11)=$p(Hold2,":",1)	;ILI_Hold2 机型
	i BPLIST(11)="" 
	{
		s (ItemDR,OriginalFee)=""
		
		if $p(basedata,"^",9)'=""
		{
			s ItemDR=$p($g(^DHCEQEquip($p(basedata,"^",9))),"^",7)
			s OriginalFee=$p($g(^DHCEQEquip($p(basedata,"^",9))),"^",27)
		}
		s BPLIST(11)=##Class(web.DHCEQCModel).UpdModel($p(Hold2,":",2)_"^"_OriginalFee,ItemDR)
	}
	s Hold3=$p(basedata,"^",8)
	s BPLIST(12)=$p(Hold3,":",1)	;ILI_Hold3 供应商
	i BPLIST(12)="" s BPLIST(12)=##Class(web.DHCEQForTrak).UpdProvider(##class(web.DHCEQCHanZiEncoding).GetEncoding($p(Hold3,":",2),4,"","U")_"^"_$p(Hold3,":",2),userid)
	&SQL(Update SQLUSER.DHC_EQInventoryListInfo Values :BPLIST() where ILI_RowID = :RowID)
	q SQLCODE
}

Query QueryEquipList() As %Query(ROWSPEC = "TEquipDR:%String,TNo:%String,TName:%String,TItemDR:%String,TStoreLocDR:%String,TVendorDR:%String,TManuFacturerDR:%String,TModelDR:%String,TLocationDR:%String")
{
}

ClassMethod QueryEquipListExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  q:rowid=""  d
	.d ResetVariablesQueryEquipList
	.s TEquipDR=rowid
	.s EquipData=$g(^DHCEQEquip(rowid))
	.q:$p(EquipData,"^",59)="Y"
	.s EQStockStatus=$p(EquipData,"^",60)
	.s EQStatus=$p(EquipData,"^",38)
 	.q:'((EQStockStatus'="3")&&(EQStatus<=2))
 	.s TNo=$p(EquipData,"^",71)
 	.s TItemDR=$p(EquipData,"^",7)
 	.i TItemDR'=""  d
	.s TName=$ZCONVERT($p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1),"U")
 	.s TStoreLocDR=$p(EquipData,"^",67)
 	.s TVendorDR=$p(EquipData,"^",25)
 	.s TManuFacturerDR=$p(EquipData,"^",26)
 	.s TModelDR=$p(EquipData,"^",3)
 	.s TLocationDR=$p(EquipData,"^",72)
	.d OutputRowQueryEquipList
	Quit $$$OK
OutputRowQueryEquipList
	s Data=$lb(TEquipDR,TNo,TName,TItemDR,TStoreLocDR,TVendorDR,TManuFacturerDR,TModelDR,TLocationDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
ResetVariablesQueryEquipList
	s (TEquipDR,TNo,TName,TItemDR,TStoreLocDR,TVendorDR,TManuFacturerDR,TModelDR,TLocationDR)=""
	quit
}

ClassMethod QueryEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEquipListExecute ]
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

ClassMethod QueryEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QueryBindList() As %Query(ROWSPEC = "TBindObjDR:%String,TSourceType:%String,TSourceID:%String,TBindType:%String,TBindID:%String,TBindNo:%String,TBindUserDR:%String")
{
}

ClassMethod QueryBindListExecute(ByRef qHandle As %Binary) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1

	s rowid=0
	f  s rowid=$o(^DHCEQBindObj(rowid))  q:rowid=""  d
	.d ResetVariablesQueryBindList
	.s TBindObjDR=rowid
	.s BindData=$g(^DHCEQBindObj(rowid))
	.q:$p(BindData,"^",13)="Y"
 	.s TSourceType=$p(BindData,"^",1)
 	.s TSourceID=$p(BindData,"^",2)
 	.s TBindType=$p(BindData,"^",3)
 	.s TBindID=$p(BindData,"^",4)
 	.s TBindNo=$p(BindData,"^",5)
 	.s TBindUserDR=$p(BindData,"^",6)
	.d OutputRowQueryBindList
	Quit $$$OK
OutputRowQueryBindList
	s Data=$lb(TBindObjDR,TSourceType,TSourceID,TBindType,TBindID,TBindNo,TBindUserDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1	
	quit
ResetVariablesQueryBindList
	s (TBindObjDR,TSourceType,TSourceID,TBindType,TBindID,TBindNo,TBindUserDR)=""
	quit
}

ClassMethod QueryBindListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBindListExecute ]
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

ClassMethod QueryBindListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryBindListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UpLoadBatchBind(BatchInfos)
{
	new num,info,results,result  
	s results=""
	s num=$l(BatchInfos,"%")	
	for i=1:1:num
	{
		s info=$p(BatchInfos,"%",i)
		s result=##Class(web.DHCEQInventory).UpLoadBind(info)
		i results'="" s results=results_"^"
		s results=results_result
	}
	q results
}

/// w ##Class(web.DHCEQInventory).UpLoadBind("^1^8^1^13437159247^78")
ClassMethod UpLoadBind(val)
{
	new (val)
	s EPC=""
	s User=$P(val,"^",6)
	s Date=+$H
	s Time=$P($H,",",2)
	k PLIST
	s PLIST(2)=$P(val,"^",2)
	s PLIST(3)=$P(val,"^",3)
	s PLIST(4)=$P(val,"^",4)
	s PLIST(6)=$P(val,"^",5)
	s PLIST(7)=User
	s PLIST(8)=Date
	s PLIST(9)=Time
	s PLIST(14)="N"
	TStart
	&SQL(Select BO_BindNo Into :EPC from SQLUSER.DHC_EQBindObj Where BO_InvalidFlag='N' and ((BO_SourceType=:PLIST(2) and  BO_SourceID=:PLIST(3)) or BO_BindNo=:PLIST(6)) )
	
	i EPC'=""
	{	
		if EPC'=PLIST(6)
		{
			&SQL(Update SQLUSER.DHC_EQBindObj Set BO_InvalidFlag='Y',BO_UnBindUserDR=:User,BO_ToDate=:Date,BO_ToTime=:Time where BO_InvalidFlag='N' and ((BO_SourceType=:PLIST(2) and  BO_SourceID=:PLIST(3)) or BO_BindNo=:PLIST(6)))
			i SQLCODE
			{	
				TRollBack
				q SQLCODE	
			}
		}else{
			q -1001
		}
	}
	&SQL(Insert into sqluser.DHC_EQBindObj values :PLIST())
	i SQLCODE
	{	
		TRollBack
		q SQLCODE	
	}
	TCommit	
	q SQLCODE
}

}
