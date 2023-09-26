/// 名称: web.DHCEQ.EM.BUSSnapShot
/// 描述: 设备台账管理
/// 编写者：ZC
/// 编写日期: 2018-11-22
/// 产品组：设备管理
/// modified  by wy 2019-3-28 需求：855148,855148
Class web.DHCEQ.EM.BUSSnapShot Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// modified by ZY20221107 Bug:2977997  增加列信息的取值和输出
/// Modified By QW20201215  BUG:QW0084 需求号1659462-设备台帐快照-不显示生产厂商、院区和旧系统唯一号信息
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSSnapShot","GetEquipList","^No=^Name=^EquipCatDR=^Code=^UseLocDR=^IncludeFlag=0^MinValue=^MaxValue=^FundsTypeDR=^LocationDR=^BeginInStockDate=^EndInStockDate=^EquipTypeDR=^StatCatDR=^ProviderDR=^ManuFactoryDR=^Status=^InStockNo=^StoreMoveNo=^QXType=0^IsDisused=N^IsOut=N^Chk=^CheckRentFlag=0","0")
/// Modified By QW20210705 BUG:QW0136 增加入参Ejob修正合计错误
/// MZY0121 2588305     2022-04-15  增加打印操作记录：TOperateInfo
Query GetEquipList(vData As %String = "", SnapShotID As %String = "", Ejob As %Library.String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TManuFactoryNo:%String,TManuFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,TBatchFlag:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TLocation:%String,TGuaranteePeriodNum:%String,TStatCatDR:%String,TStatCat:%String,TJob:%String,TRow:%String,TContractNo:%String,TCommonName:%String,TConfigFlag:%String,TFundsInfo:%String,Thold6:%String,THospital:%String,TOperateInfo:%String,Thold5:%String,Thold7:%String,TConfigLicense:%String")
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, vData As %String = "", SnapShotID As %String = "", Ejob As %Library.String = "") As %Status
{
	s gnum=1
	s curDate=+$H
	;20130711  Mozy0102
	Set curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	
	d ##Class(web.DHCEQCommon).KillTempGlobal("SnapEquipList",Ejob)	;Modified By QW20210728 BUG:QW0142	
	
	
 	new repid, index,rowid,vStoreLocDR,TotalNum,TotalFee
 	Set TotalNum=0
 	Set TotalFee=0
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	//Quit $$$OK
 	i (SnapShotID="") Quit $$$OK
 	//i (vData="") Quit $$$OK
 	
 	Set EquipCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipCatDR")
 	Set StoreLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"StoreLocDR")
 	Set UseLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"UseLocDR")
 	Set ManageLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ManageLocDR") 	
 	Set InStockListDR=##Class(web.DHCEQCommon).GetDataByName(vData,"InStockListDR")
 	Set BatchFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"BatchFlag")
 	Set No=$ZCONVERT(##Class(web.DHCEQCommon).GetDataByName(vData,"No"),"U")
 	Set Code=$ZCONVERT(##Class(web.DHCEQCommon).GetDataByName(vData,"Code"),"U")
 	Set Name=$ZCONVERT(##Class(web.DHCEQCommon).GetDataByName(vData,"Name"),"U")
 	Set ModelDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ModelDR")
 	Set Status=##Class(web.DHCEQCommon).GetDataByName(vData,"Status")
 	Set MinValue=##Class(web.DHCEQCommon).GetDataByName(vData,"MinValue")
 	Set MaxValue=##Class(web.DHCEQCommon).GetDataByName(vData,"MaxValue")
 	Set ProviderDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
 	Set ManuFactoryDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ManuFactoryDR")
 	Set EquipTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipTypeDR")
 	Set ServiceDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ServiceDR")
 	Set QXType=##Class(web.DHCEQCommon).GetDataByName(vData,"QXType")
 	Set PurposeTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"PurposeTypeDR")
 	set IncludeFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"IncludeFlag")
 	Set PurchaseTypeDR=##Class(web.DHCEQCommon).GetDataByName(vData,"PurchaseTypeDR")
 	Set OriginDR=##Class(web.DHCEQCommon).GetDataByName(vData,"OriginDR")
 	Set StatCatDR=##Class(web.DHCEQCommon).GetDataByName(vData,"StatCatDR")
 	Set FundsTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"FundsTypeDR")
 	
 	Set BeginInStockDate=##Class(web.DHCEQCommon).GetDataByName(vData,"BeginInStockDate")
 	Set EndInStockDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndInStockDate")
 	i BeginInStockDate'="" s BeginInStockDate=##Class(web.DHCEQCommon).TransValueFromPage(BeginInStockDate,"date")  //add by Mozy 2017-9-15 日期格式统一调用公共方法
 	i EndInStockDate'="" s EndInStockDate=##Class(web.DHCEQCommon).TransValueFromPage(EndInStockDate,"date")
 	
 	Set InvoiceNo=##Class(web.DHCEQCommon).GetDataByName(vData,"InvoiceNo")
 	Set ContractNo=##Class(web.DHCEQCommon).GetDataByName(vData,"ContractNo")
 	Set IsDisused=##Class(web.DHCEQCommon).GetDataByName(vData,"IsDisused")
 	Set IsDisusing=##Class(web.DHCEQCommon).GetDataByName(vData,"IsDisusing")
 	Set IsOut=##Class(web.DHCEQCommon).GetDataByName(vData,"IsOut")
 	Set ComputerFlag=##Class(web.DHCEQCommon).GetDataByName(vData,"ComputerFlag")
 	
 	// Mozy  2009-03-03 增加报废查询的时间段
 	Set BeginDisuseDate=##Class(web.DHCEQCommon).GetDataByName(vData,"BeginDisuseDate")
 	Set EndDisuseDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDisuseDate")
 	i BeginDisuseDate'="" s BeginDisuseDate=##Class(web.DHCEQCommon).TransValueFromPage(BeginDisuseDate,"date") //add by Mozy 2017-9-15 日期格式统一调用公共方法
 	i EndDisuseDate'="" s EndDisuseDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDisuseDate,"date")

	//add by JDL 2009-9-7 JDL0023
	Set MemoryCode=##Class(web.DHCEQCommon).GetDataByName(vData,"MemoryCode")
	
	//add by JDL 2009-9-16 JDL0033
	Set BeginTransAssetDate=##Class(web.DHCEQCommon).GetDataByName(vData,"BeginTransAssetDate")
	Set EndTransAssetDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndTransAssetDate")
	i BeginTransAssetDate'="" s BeginTransAssetDate=##Class(web.DHCEQCommon).TransValueFromPage(BeginTransAssetDate,"date")	 //add by Mozy 2017-9-15 日期格式统一调用公共方法
 	i EndTransAssetDate'="" s EndTransAssetDate=##Class(web.DHCEQCommon).TransValueFromPage(EndTransAssetDate,"date")
	// Mozy0068	2011-11-09
	Set HospitalDR=##Class(web.DHCEQCommon).GetDataByName(vData,"HospitalDR")
	Set LocationDR=##class(web.DHCEQCommon).GetDataByName(vData,"LocationDR")	;add by csj 20191202
	
	s index=2
	s rowid=0

	i SnapShotID="" Quit $$$OK 
	s findnolist=0
	f  s rowid=$o(^DHCEQSnapShot(SnapShotID,"Equip",rowid))  quit:rowid=""  d
	.s gblData=$g(^DHCEQSnapShot(SnapShotID,"Equip",rowid))
    .s gblDataEX=$g(^DHCEQSnapShot(SnapShotID,"Equip",rowid,"OtherInfo"))   //modified by ZY20221107 Bug:2977997
	.d FillOneDataGetEquipList

	Quit $$$OK
	
FillOneDataGetEquipList
	d ResetVariablesGetEquipList
	d CheckGetEquipList
	q:passed=0
	d SetVariablesGetEquipList
	d OutputRowGetEquipList
	quit
ResetVariablesGetEquipList
    s (TRowID,TName,TABCType,TModelDR,TEquiCatDR,TUnitDR,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TCountryDR,TManageLocDR,TManageLevelDR,TUseLocDR,TOriginDR,TFromDeptDR,TToDeptDR,TBuyTypeDR,TEquipTechLevelDR,TProviderDR,TManuFactoryDR,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TWorkLoadUnitDR,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TEquipTypeDR,TPurchaseTypeDR,TPurposeTypeDR,TKeeperDR,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFundsFee,TDisplayStatus,TDisplayStockStatus)=""
    s (TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TStoreMoveNo,TInStockNo,TCommonName,THospitalDR,TFundsInfo,TPayNo,TUnusualRemark,TRow,TContractNo,TConfigFlag,THasDoc,THasFile,TReciveDate,TCurDepreFee,TDepreMonths,TReDepreMonths,FFee1,FFee2,FFee3,FFee4,TOperateInfo,Thold5,Thold7,TConfigLicense)=""  // MZY0121  2588305     2022-04-15
    s TBatchFlag="N"
    quit
CheckGetEquipList
	s passed=1	
	s TInvalidFlag = $p(gblData,"^",59)
	i TInvalidFlag'="N" 
		{s passed=0
	 	q}
	//add begin by jyp 2021-05-24 jyp  JYP0027
	s TParentDR=$p($g(^DHCEQEquip(rowid,"OtherInfo")),"^",24)
	i TParentDR'=""
	{s passed=0
	 	q}
	//add end by jyp 2021-05-24 jyp   JYP0027
	;Modified by jdl 2012-1-6 JDL0109
	;优化查询及查询报错
	///判断是否还未入库
	s TStockStatus=$p(gblData,"^",60)
	i (TStockStatus="0")
		{	s passed=0
			q}
	
	s TStatus = $p(gblData,"^",38)
	i (Status'="")&(Status'=TStatus)
		{s passed=0
		q}
	//是否包含已经报废设备
	i (IsDisused="Y")&(TStatus'=3)
		{s passed=0
		q}
	i (IsDisused="N")&(TStatus=3)
		{s passed=0
		q}
		
	//是否包含已经出库设备
	i (IsOut="Y")&(TStockStatus'="3")
		{	s passed=0
			q}
	i (IsOut="N")&(TStockStatus="3")
		{	s passed=0
			q}
	
	s TEquiCatDR = $p(gblData,"^",4)	
	i (EquipCatDR'="")&(EquipCatDR'=TEquiCatDR)
		{
			i (IncludeFlag'="1")
			{
				s passed=0
			}
			else
			{
				s passed=##class(web.DHCEQCEquipeCat).IsChildPar(EquipCatDR,TEquiCatDR)
			}
			i passed=0 q
		}
	s TStoreLocDR = $p(gblData,"^",67)
	i (StoreLocDR'="")&(StoreLocDR'=TStoreLocDR)  
		{s passed=0
		q}
	s TUseLocDR = $p(gblData,"^",19)
	i (UseLocDR'="")&(UseLocDR'=TUseLocDR)
		{s passed=0
		q}
	;20130711  Mozy0102  modofied by wy 2019-3-28 需求：855148
	i ##Class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR)="1"  
	{
		s passed=0
		q
	}
	;add by Mozy 2011-11-09	Mozy0068
	//Set THospitalDR=$Piece($Get(^CTLOC(TStoreLocDR)),"^",22)    //modify by jyp 2019-10-18 CTLOC调整
	Set THospitalDR=##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TStoreLocDR)     //modify by jyp 2019-10-18 CTLOC调整
	i THospitalDR'="" s THospital=$Piece($Get(^CT("HOSP",THospitalDR)),"^",2)  // Add By QW20201215  BUG:QW0084 需求号1659462-设备台帐快照-不显示生产厂商、院区和旧系统唯一号信息
	If (HospitalDR'="")&(HospitalDR'=THospitalDR)
	{
		Set passed=0
		Quit
	}
	s TManageLocDR = $p(gblData,"^",17)
	i (ManageLocDR'="")&(ManageLocDR'=TManageLocDR)
		{s passed=0
		q}
	s TInStockListDR = $p(gblData,"^",70)
	i (InStockListDR'="")&(InStockListDR'=TInStockListDR)
		{s passed=0
		q}
	if ((BeginInStockDate'="")||(EndInStockDate'=""))	
	{
		i (TInStockListDR="")
		{	s InStockDate=$p(gblData,"^",45)}
		else
		{
			s InStockDate=$p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
			s InStockDate=$p(^DHCEQInStock(InStockDate),"^",13)
		}
		i ((BeginInStockDate'="")&(InStockDate<BeginInStockDate))
		{s passed=0
		q}
		
		i ((EndInStockDate'="")&(InStockDate>EndInStockDate))
		{s passed=0
		q}
	}
	
	//add by JDL 2009-9-16 JDL0033
	if ((BeginTransAssetDate'="")||(EndTransAssetDate'=""))	
	{
		s TransAssetDate=$p(gblData,"^",45)
		i ((BeginTransAssetDate'="")&(TransAssetDate<BeginTransAssetDate))
		{s passed=0
		q}
		
		i ((EndTransAssetDate'="")&(TransAssetDate>EndTransAssetDate))
		{s passed=0
		q}
	}
	
	s TModelDR = $p(gblData,"^",3)
	i (ModelDR'="")&(ModelDR'=TModelDR)
		{s passed=0
		q}
	
	i (TStatus=3)
	{
		if ((BeginDisuseDate'="")||(EndDisuseDate'=""))	
		{
	 		new id
	 		s id=0   
	 		f  s id=$o(^DHCEQDisuseRequestList(id))  quit:id=""  d
	 		.s EquipDR=$p($g(^DHCEQDisuseRequestList(id)),"^",2) 			//设备代码
	 		.i EquipDR'=id q
	 		.s DisuseRequestDR=$p($g(^DHCEQDisuseRequestList(id)),"^",1) 	//报废单
			.s DisuseDate=$p(^DHCEQDisuseRequest(InStockDate),"^",21)		//DR_AuditDate
	
			i ((BeginDisuseDate'="")&(DisuseDate<BeginDisuseDate))
			{
				s passed=0
				q
			}
			i ((EndDisuseDate'="")&(DisuseDate>EndDisuseDate))
			{
				s passed=0
				q
			}
		}
	}
	s TOriginalFee=$p(gblData,"^",27)
	i (MinValue'="")&(MinValue>TOriginalFee)
		{s passed=0
		q}
	i (MaxValue'="")&(MaxValue<TOriginalFee)
		{s passed=0
		q}
	s TProviderDR = $p(gblData,"^",25)
	i (ProviderDR'="")&(ProviderDR'=TProviderDR)
		{s passed=0
		q}
	s TManuFactoryDR = $p(gblData,"^",26)
	i (ManuFactoryDR'="")&(ManuFactoryDR'=TManuFactoryDR)
		{s passed=0
		q}
	s TServiceDR = $p(gblData,"^",69)
	i (ServiceDR'="")&(ServiceDR'=TServiceDR)
		{s passed=0
		q}
	
				
	s TPurchaseTypeDR=$p(gblData,"^",64)
	i (PurchaseTypeDR'="")&(PurchaseTypeDR'=TPurchaseTypeDR)
		{s passed=0
		q}
	s TOriginDR=$p(gblData,"^",20)
	i (OriginDR'="")&(OriginDR'=TOriginDR)
		{s passed=0
		q}	
	///end
	Set TEquipTypeDR=$p(gblData,"^",63)
	i (EquipTypeDR'="")&(EquipTypeDR'=TEquipTypeDR)
		{s passed=0
		q}
	;20130711  Mozy0102
	i (EquipTypeDR="")&("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR))
		{s passed=0
		q}
 	Set TPurposeTypeDR=$p(gblData,"^",65)
 	i (PurposeTypeDR'="")&(PurposeTypeDR'=TPurposeTypeDR)
		{s passed=0
		q}
	s TCode = $ZCONVERT($p(gblData,"^",6),"U")
	s TCommonName = $ZCONVERT($p(gblData,"^",1),"U")	//2013-06-24 DJ0118 begin
	s TName=$p(gblData,"^",7)
	i TName'="" s TName=$ZCONVERT($p($g(^DHCEQCCode("DHCEQCMasterItem",TName)),"^",1),"U") //2013-06-24 DJ0118 end
	s TNo = $ZCONVERT($p(gblData,"^",71),"U")
	i ((TCode'[Code)||(TName'[Name)||(TNo'[No))
		{s passed=0
		q}
	///add 2006-12-25
	s TStatCatDR = $p(gblData,"^",75)
	i (StatCatDR'="")&&(StatCatDR'=TStatCatDR)
	{s passed=0
	q}
	///end
	// add by wl 2019-10-25  1012748  资金来源过滤  
	s FEquipDR= rowid
	s Amount=0
	i (FundsTypeDR'="")
	{
	 	s FRowid = 0
	 	f  s FRowid=$o(^DHCEQSnapShot(SnapShotID,"Funds",FEquipDR,FRowid)) q:(FRowid="")  d   
	 	.q:($p($g(^DHCEQSnapShot(SnapShotID,"Funds",FEquipDR,FRowid)),"^",2)'=FundsTypeDR) 
	 	.s Amount=Amount+$p($g(^DHCEQSnapShot(SnapShotID,"Funds",FEquipDR,FRowid)),"^",3)
		
		i (+Amount=0)
		{
			s passed=0
			q
		}	
	}
	
	i (findnolist=1)&(TInStockListDR'="")
	{
		s passed=0
		q
	}
	
	i (InvoiceNo'="")
	{
		if InvoiceNo'=##Class(web.DHCEQEquip).GetInvoiceNo(rowid)
		{
			s passed=0
			q
		}
	}
	i (ContractNo'="")
	{
		if ContractNo'=##Class(web.DHCEQEquip).GetContractNo(rowid)
		{
			s passed=0
			q
		}
	}
	
	s TComputerFlag = $p(gblData,"^",15)
	i (ComputerFlag'="")&(ComputerFlag'=TComputerFlag)
	{s passed=0
	q}
	s THold1 = $p(gblData,"^",76)
	i (IsDisusing="Y")&(THold1'="1")
	{s passed=0
	q}
	i (IsDisusing="N")&(THold1="1")
	{s passed=0
	q}
	
	//add by JDL 2009-9-7 JDL0023
	s TMemoryCode=$p(gblData,"^",61)
	i (MemoryCode'="")&&(MemoryCode'=TMemoryCode)
	{s passed=0
	q}
	//add by csj 20191202
	s TLocationDR = $p(gblData,"^",72)            //Modefied by zc0055 取值错误问题的处理 
	i (LocationDR'="")&&(TLocationDR'=LocationDR)
	{s passed=0 q}
	
	quit

SetVariablesGetEquipList
	s TQuantity = 1
	s TotalNum=TotalNum+TQuantity
	s TRowID = rowid
	s TName = $p(gblData,"^",1)
	s TABCType = $p(gblData,"^",2)
	s TModelDR = $p(gblData,"^",3)
	i TModelDR '=""  d
	.s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	s TEquiCatDR = $p(gblData,"^",4)
	i TEquiCatDR '=""  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	s TUnitDR = $p(gblData,"^",5)
	i TUnitDR '=""  d
	.s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s TCode = $p(gblData,"^",6)
	s TDesc = $p(gblData,"^",7)
	s TInstallLocDR = $p(gblData,"^",8)
	i TInstallLocDR '=""  d
	.s TInstallLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TInstallLocDR)
	s TInstallDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",9),"date")
	s TLeaveFactoryNo = $p(gblData,"^",10)
	s TLeaveFactoryDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",11),"date")
	s TOpenCheckDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",12),"date")
	s TCheckDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",13),"date")
	s TMakeDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",14),"date")
	s TComputerFlag = $p(gblData,"^",15)
	s TCountryDR = $p(gblData,"^",16)
	i TCountryDR '=""  d
	.s TCountry = ##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	s TManageLocDR = $p(gblData,"^",17)
	i TManageLocDR '=""  d
	.s TManageLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	s TManageLevelDR = $p(gblData,"^",18)
	i TManageLevelDR '=""  d
	.s TManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",TManageLevelDR)),"^",2)
	s TUseLocDR = $p(gblData,"^",19)
	i TUseLocDR '=""  d
	.s TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TOriginDR = $p(gblData,"^",20)
	i TOriginDR '=""  d
	.s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	s TFromDeptDR = $p(gblData,"^",21)
	i TFromDeptDR '=""  d
	.s TFromDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)
	s TToDeptDR = $p(gblData,"^",22)
	i TToDeptDR '=""  d
	.s TToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TToDeptDR)),"^",2)
	s TBuyTypeDR = $p(gblData,"^",23)
	i TBuyTypeDR '=""  d
	.s TBuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)
	s TEquipTechLevelDR = $p(gblData,"^",24)
	i TEquipTechLevelDR '=""  d
	.s TEquipTechLevel = $p($g(^DHCEQCCode("DHCEQCTechLevel",TEquipTechLevelDR)),"^",2)
	s TProviderDR = $p(gblData,"^",25)
	i TProviderDR '=""  d
	.s TProvider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TManuFactoryDR = $p(gblData,"^",26)
	i TManuFactoryDR '=""  d
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)   ;Add By QW20201215 BUG:QW0084 需求号1659462-设备台帐快照-不显示生产厂商、院区和旧系统唯一号信息
	s TOriginalFee = ##Class(web.DHCEQCommon).FormatNumber($p(gblData,"^",27),"")
	s TotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalFee+TOriginalFee,"")
	s TNetFee = ##Class(web.DHCEQCommon).FormatNumber($p(gblData,"^",28),"")
	s TNetRemainFee = ##Class(web.DHCEQCommon).FormatNumber($p(gblData,"^",29),"")
	s TGroupDR = $p(gblData,"^",30)
	i TGroupDR '=""  d
	.s TGroup =$p($g(^DHCEQGroup(TGroupDR)),"^",2)
	s TLimitYearsNum = $p(gblData,"^",31)
	s TContractListDR = $p(gblData,"^",32)
	i TContractListDR '=""  d
	.s TContractList = $p($g(^DHCEQContractList(TContractListDR)),"^",1)
	s TDepreMethodDR = $p(gblData,"^",33)
	i TDepreMethodDR '=""  d
	.s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TRemark = $p(gblData,"^",34)
	s TDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p(gblData,"^",35),"")
	s TDesignWorkLoadNum = $p(gblData,"^",36)
	s TWorkLoadUnitDR = $p(gblData,"^",37)
	i TWorkLoadUnitDR '=""  d
	.s TWorkLoadUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnitDR)
	s TStatus = $p(gblData,"^",38)
	s TDisplayStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay(TStatus)
	s TManageUserDR = $p(gblData,"^",39)
	i TManageUserDR '=""  d
	.s TManageUser = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TManageUserDR)
	s TMaintUserDR = $p(gblData,"^",40)
	i TMaintUserDR '=""  d
	.s TMaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	s TProviderHandler = $p(gblData,"^",41)
	s TProviderTel = $p(gblData,"^",42)	
	s TAppendFeeTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p(gblData,"^",43),"")
	s TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",44),"date")
	s TTransAssetDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",45),"date")
	s TGuaranteeFlag = $p(gblData,"^",46)
	s TInputFlag = $p(gblData,"^",47)
	s TTestFlag = $p(gblData,"^",48)
	s TMedicalFlag = $p(gblData,"^",49)
	s TGuaranteeStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",50),"date")
	s TGuaranteeEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",51),"date")
	s TAddUserDR = $p(gblData,"^",52)
	i TAddUserDR '=""  d
	.s TAddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",53),"date")
	s TAddTime = $p(gblData,"^",54)
	s TUpdateUserDR = $p(gblData,"^",55)
	i TUpdateUserDR '=""  d
	.s TUpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p(gblData,"^",56),"date")
	s TUpdateTime = $p(gblData,"^",57)
	s TCurrencyDR = $p(gblData,"^",58)
	i TCurrencyDR '=""  d
	.s TCurrency = ##Class(web.DHCEQCommon).GetTrakNameByID("cur",TCurrencyDR)
	s TInvalidFlag = $p(gblData,"^",59)
	s TStockStatus = $p(gblData,"^",60)
	s TDisplayStockStatus=##Class(web.DHCEQ.EM.BUSEquip).GetEquipStockStatusDisplay(TStockStatus)
	s TMemoryCode = $p(gblData,"^",61)
	s TUrgencyFlag = $p(gblData,"^",62)
	s TEquipTypeDR = $p(gblData,"^",63)
	i TEquipTypeDR '=""  d
	.s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TPurchaseTypeDR = $p(gblData,"^",64)
	i TPurchaseTypeDR '=""  d
	.s TPurchaseType = $p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	s TPurposeTypeDR = $p(gblData,"^",65)
	i TPurposeTypeDR '=""  d
	.s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	s TKeeperDR = $p(gblData,"^",66)
	i TKeeperDR '=""  d
	.s TKeeper = ##class(web.DHCEQCommon).GetTrakNameByID("user",TKeeperDR)
	s TStoreLocDR = $p(gblData,"^",67)
	i TStoreLocDR '=""  d
	.s TStoreLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TStoreLocDR)
	s TStartDepreMonth = $p(gblData,"^",68)
	s TServiceDR = $p(gblData,"^",69)
	i TServiceDR '=""  d
	.s TService = $p($g(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",1)
	s TInStockListDR = $p(gblData,"^",70)
	i TTransAssetDate="" d //2009-09-19 党军 begin 无转资日期显示入库审核日期
	.i TInStockListDR '=""  d
	..s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	..s TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(TInStockList)),"^",13),"date") //2009-09-19 党军 end
	i TInStockListDR '=""  d
	.s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	.i TInStockList'="" s TInStockNo=$p($g(^DHCEQInStock(TInStockList)),"^",14)  //Modefied by zc0049 2019-01-16  修改入库单明细删除引起的错误
	s TNo = $p(gblData,"^",71)
	/// 20150918  Mozy0166	存放地点
	Set TLocation = $Piece(gblData,"^",72)
	If TLocation'="" Set TLocation = $Piece($Get(^DHCEQCCode("DHCEQCLocation",TLocation)),"^",2)
	Set TGuaranteePeriodNum = $Piece(gblData,"^",73)
	s TStatCatDR=$p(gblData,"^",75)
	i TStatCatDR'="" d
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	s TContractNo = $p(gblData,"^",76)
    s THold5 = $p(gblData,"^",80)  //使用年限//modified by ZY20221107 Bug:2977997
	s TFileNo=$p(gblData,"^",85)
	s TRentLocDR=$p(gblData,"^",86)
	s TRentStatus=$p(gblData,"^",87)
	s TFaultStatus=$p(gblData,"^",88)
	s TDisuseDate=$p(gblData,"^",89)
	i TDisuseDate'="" s TDisuseDate=##Class(web.DHCEQCommon).TransValueToPage(TDisuseDate,"date")
	s TAccountNo=$p(gblData,"^",90)
	s Thold6=$p(gblData,"^",91) //2011-08-08 DJ begin
	s Thold7=$p(gblData,"^",92)
	s Thold8=$p(gblData,"^",93)
	/// 20150918  Mozy0166
	s Thold8=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(Thold8)
	s TAdvanceDisFlag=Thold8
	s Thold9=$p(gblData,"^",94)
	i Thold9'="" s Thold9=$p($g(^DHCEQCCode("DHCEQCBrand",Thold9)),"^",3)
	s Thold10=$p(gblData,"^",95) //2011-08-08 DJ end
	s TFundsFee=TOriginalFee
	s TFundsInfo=##Class(web.DHCEQ.EM.BUSSnapShot).GetSnapFundsInfo(SnapShotID,TRowID) //2014-6-20 HZY0055 增加资金来源描述信息的显示
	s TUnusualRemark=$p(gblData,"^",104)
    //modified by ZY20221107 Bug:2977997
    i $p(gblDataEX,"^",24)'="" s TConfigFlag="Y"   //add by wy 2019-3-28 需求：855127
    s TConfigLicense=$p(gblDataEX,"^",2) 
	// MZY0121	2588305		2022-04-15
	s TBarPrintTimes=+##class(web.DHCEQOperateLog).GetOperateTimes(52,rowid,2)
	s TCardPrintTimes=+##class(web.DHCEQOperateLog).GetOperateTimes(52,rowid,3)
	s LifeSourceID=0,TStoreMoveTimes=0
	f  s LifeSourceID=$o(^DHCEQLifeInfo(0,"EquipSource",22,rowid,LifeSourceID)) quit:(LifeSourceID="")  d
	.s LIRowID=0
	.f  s LIRowID=$o(^DHCEQLifeInfo(0,"EquipSource",22,rowid,LifeSourceID,LIRowID)) quit:(LIRowID="")  d
	..q:($p($g(^DHCEQLifeInfo(LIRowID)),"^",30)="Y")
	..q:($p($g(^DHCEQLifeInfo(LIRowID)),"^",21)'=1)  //仅当科室转移时统计
	..s TStoreMoveTimes=TStoreMoveTimes+1
	s TOperateInfo="打印卡片:"_TCardPrintTimes_"次,打印条码:"_TBarPrintTimes_"次,发生调拨:"_TStoreMoveTimes_"次"
	quit
OutputRowGetEquipList

	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	i TNetFee'="" s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"")
	i TNetRemainFee'="" s TNetRemainFee=##Class(web.DHCEQCommon).FormatNumber(TNetRemainFee,"")
	i TFundsFee'="" s TFundsFee=##Class(web.DHCEQCommon).FormatNumber(TFundsFee,"")		//Add By DJ 2015-07-14 DJ0147
	Set TRow=gnum	// 20150914  Mozy0165 序号
    s Data=$lb(TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,Ejob,TRow,TContractNo,TCommonName,TConfigFlag,TFundsInfo,Thold6,THospital,TOperateInfo,Thold5,Thold7,TConfigLicense) /// MZY0121   2588305     2022-04-15
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s ^TempDHCEQ("SnapEquipList",curDate,Ejob,gnum)=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^"_TFundsFee_"^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TContractNo_"^"_THasDoc_"^"_THasFile_"^"_TReciveDate_"^"_TConfigFlag_"^"_TCurDepreFee_"^"_TDepreMonths_"^"_TReDepreMonths_"^"_FFee1_"^"_FFee2_"^"_FFee3_"^"_FFee4_"^"_TOperateInfo	// MZY0121	2588305		2022-04-15
	s gnum=gnum+1
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

/// Add By DJ 2015-07-14
/// 获取设备快照资金来源信息
ClassMethod GetSnapFundsInfo(vSnapID, vEquipID)
{
	s vReturn=""
	s FRowID=0
	f  s FRowID=$o(^DHCEQSnapShot(vSnapID,"Funds",vEquipID,FRowID))  q:FRowID=""  d
	.s TSnapFundsType=$p($g(^DHCEQSnapShot(vSnapID,"Funds",vEquipID,FRowID)),"^",2)
	.i TSnapFundsType'="" s TSnapFundsType=$p($g(^DHCEQCCode("DHCEQCFundsType",TSnapFundsType)),"^",2)
	.s TSnapFundsFee=$p($g(^DHCEQSnapShot(vSnapID,"Funds",vEquipID,FRowID)),"^",3)
	.q:TSnapFundsFee<=0
	.s vReturn=vReturn_TSnapFundsType_"="_TSnapFundsFee_","
	i vReturn="" q ""
	q $e(vReturn,1,$L(vReturn)-1)
}

/// 创建：zc0038 2018-10-10
/// 描述：hisui改造在jQuery快照页面标签显示合计信息
/// 输入：node：临时global的节点名称
/// 输出：快照台账合计信息
/// w ##Class(web.DHCEQ.EM.BUSSnapShot).GetEquipSumInfo()
/// Modified By QW20210705 BUG:QW0136 增加入参Ejob修正合计错误
ClassMethod GetEquipSumInfo(node As %Library.String = "", Ejob As %Library.String = "")
{
	s info=""
	s (Count,TotalFee,TotalNetFee,TotalDepreFee)=0
	s nrowid=0
	f  s nrowid=$o(^TempDHCEQ("SnapEquipList",+$h,Ejob,nrowid)) q:nrowid=""  d
	.s Count=Count+1
	.s TotalFee=TotalFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^TempDHCEQ("SnapEquipList",+$h,Ejob,nrowid)),"^",22),"")
	.s TotalNetFee=TotalNetFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^TempDHCEQ("SnapEquipList",+$h,Ejob,nrowid)),"^",23),"")
	.s TotalDepreFee=TotalDepreFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^TempDHCEQ("SnapEquipList",+$h,Ejob,nrowid)),"^",29),"")
  	s info="总数量:"_Count_"&nbsp;&nbsp;&nbsp;原值合计:"_TotalFee_"元&nbsp;&nbsp;&nbsp;净值合计:"_TotalNetFee_"元&nbsp;&nbsp;&nbsp;累计折旧合计:"_TotalDepreFee_"元"
  	q info
}

}
