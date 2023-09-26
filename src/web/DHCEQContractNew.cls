/// 创建人:zy 2011-03-14  No ZY0065
/// 合同管理
Class web.DHCEQContractNew Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// modified by ZY0197  增加管理科室参数
/// GR0054 20151201 新增ContractType查询条件，默认值0，查询采购合同，当入参为1时查询维修合同
/// modified by CZF0088 1217951 增加参数CancelOper 2020-03-06
Query GetContract(QXType, ContractName, SignLocDR, ProviderDR, StartDate, EndDate, StatusDR, ApproveRole, Type, WaitAD, ContractNo, Provider As %String = "", ContractType, FileNo As %String = "", ManageLocDR As %String = "", CancelOper As %String = "") As %Query(ROWSPEC = "TRowID:%String,TContractName:%String,TContractNo:%String,TQuantityNum:%String,TTotalFee:%String,TPreFeeFee:%String,TPayedTotalFee:%String,TSignDate:%String,TSignLocDR:%String,TDeliveryDate:%String,TArriveDate:%String,TStartDate:%String,TEndDate:%String,TClaimPeriodNum:%String,TService:%String,TPayTypeDR:%String,TPayItem:%String,TCheckStandard:%String,TProviderDR:%String,TProviderTel:%String,TProviderHandler:%String,TBreakItem:%String,TNeedHandlerDR:%String,TGuaranteePeriodNum:%String,TStatus:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TSignLoc:%String,TPayType:%String,TProvider:%String,TNeedHandler:%String,TAddUser:%String,TUpdateUser:%String,TAuditUser:%String,TArriveMonthNum:%String,TServiceProDR:%String,TServiceHandler:%String,TServiceTel:%String,TServicePro:%String,TApproveSetDR:%String,TApproveRole:%String,TRow:%String,TContractType:%String,TFileNo:%String,TApprovals:%String,THold5:%String")
{
}

ClassMethod GetContractExecute(ByRef qHandle As %Binary, QXType, ContractName, SignLocDR, ProviderDR, StartDate, EndDate, StatusDR, ApproveRole As %Library.String = "", Type As %Library.String = "", WaitAD As %Library.String = "", ContractNo, Provider As %String = "", ContractType, FileNo As %String = "", ManageLocDR As %String = "", CancelOper As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
	i StartDate="" s StartDate=0
	e  s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")	//add by csj 20180711
	i EndDate="" s EndDate=+$H
	e  s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")	//add by csj 20180711
	
	s rowid=0
	f  s rowid=$o(^DHCEQContract(rowid)) q:rowid=""  d
	.d ResetVariablesGetContract
	.s TContractName = $p($g(^DHCEQContract(rowid)),"^",1)
	.q:(ContractName'="")&&(TContractName'[ContractName)
	.s TContractNo = $p($g(^DHCEQContract(rowid)),"^",2)
	.q:(ContractNo'="")&&(TContractNo'[ContractNo)
	.s TSignDate =$p($g(^DHCEQContract(rowid)),"^",7)
	.q:(TSignDate>EndDate)||(TSignDate<StartDate)
	.s TSignDate = ##Class(web.DHCEQCommon).TransValueToPage(TSignDate,"date")
	.s TSignLocDR = $p($g(^DHCEQContract(rowid)),"^",8)
	.q:(SignLocDR'="")&&(TSignLocDR'=SignLocDR)
    .q:((TSignLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ("",TSignLocDR)))  //modified by ZY 20221009  2939642
	.s THospitalDR = ##Class(web.DHCEQ.Plat.LIBCommon).GetHospitalByDeptID(TSignLocDR)
	.s TProviderDR = $p($g(^DHCEQContract(rowid)),"^",18)
	.q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	.i TProviderDR '=""  d
	..s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)	;Mozy0097	2013-4-16
	.q:(Provider'="")&&(TProvider'[Provider)
	.s TStatus= $p($g(^DHCEQContract(rowid)),"^",24)
	.q:(StatusDR'="")&&(TStatus'=StatusDR)
	.s TContractType=$p($g(^DHCEQContract(rowid)),"^",39)
	.q:(ContractType'="")&&(TContractType'=ContractType) //Mozy	2018-10-30 合同类型
	.q:(CancelOper="Y")&&((TStatus=0)||(TStatus=1))	//modified by CZF0088 作废界面过滤新增和提交的单据 1215414
	.q:(CancelOper'="Y")&&(TStatus=3)		//modified by CZF0088  非作废界面过滤已作废单据
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.s TApprovals="无"
	.s (AppSetDR,NextStepID)=""
	.i AIRowID'="" d
	..s AppSetDR=$p(^DHCEQApproveInfo(AIRowID),"^",3)		//czf 2021-09-01
	..s NextStepID=$p(^DHCEQApproveInfo(AIRowID),"^",5)
	..s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	..i $Piece(^DHCEQApproveInfo(AIRowID),"^",7)'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",$Piece(^DHCEQApproveInfo(AIRowID),"^",7)),"^",2)
	.i $p($g(^DHCEQContract(rowid)),"^",24)=0 s TApprovals="" //modified by czf 1214221 2020-03-05
	.i ((WaitAD="on")&&(CurRole'="")) q:CurRole'=ApproveRole
	.s (AppFlowID,HospLimit)=""		//czf 2021-09-01 begin
	.i (AppSetDR'="")&&(NextStepID'="") d
	..s AppFlowID=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveStep",AppSetDR,NextStepID,""))
	..i AppFlowID'="" s HospLimit=$p($g(^DHCEQCCode("DHCEQCApproveFlow",AppFlowID)),"^",20)
	.q:(WaitAD="on")&&(ApproveRole=CurRole)&&(##Class(web.DHCEQ.Util.BDPCommonUtil).GetShowBussDataFlag(THospitalDR,"","","",HospLimit)) //czf 2021-09-01 end
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("8",rowid)
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",10)
	..s TApproveStep=$p(ApproveInfo,"^",5)
	.s TRowID = rowid
	.s TContractNo = $p($g(^DHCEQContract(rowid)),"^",2)
	.s (TQuantityNum,TTotalFee)=0
	.s CTLRowID=0
	.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",rowid,CTLRowID)) q:CTLRowID=""  d
	..s (TNum,TTotal)=0
	..s TNum = $p($g(^DHCEQContractList(CTLRowID)),"^",7)
	..s TTotal = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(CTLRowID)),"^",8),"")
	..s TQuantityNum =TQuantityNum+TNum
	..s TTotalFee =TTotalFee+TTotal
	.i TContractType'=0 s TTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(rowid)),"^",4),"")	;合同主单总值	 MZY0057	1497996		2020-10-09
	.s TPreFeeFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(rowid)),"^",5),"")
	.s TPayedTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(rowid)),"^",6),"")
	.i TSignLocDR '=""  d
	..s TSignLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TSignLocDR)
	.s TDeliveryDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",9),"date")
	.s TArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",10),"date")
	.s TStartDate =##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",11),"date")
	.s TEndDate =##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",12),"date")
	.s TClaimPeriodNum = $p($g(^DHCEQContract(rowid)),"^",13)
	.s TService = $p($g(^DHCEQContract(rowid)),"^",14)
	.s TPayTypeDR = $p($g(^DHCEQContract(rowid)),"^",15)
	.i TPayTypeDR '=""  d
	..s TPayType = $p($g(^CT("CTPM",TPayTypeDR)),"^",2)
	.s TPayItem = $p($g(^DHCEQContract(rowid)),"^",16)
	.s TCheckStandard = $p($g(^DHCEQContract(rowid)),"^",17)
	.s TProviderTel = $p($g(^DHCEQContract(rowid)),"^",19)
	.s TProviderHandler = $p($g(^DHCEQContract(rowid)),"^",20)
	.s TBreakItem = $p($g(^DHCEQContract(rowid)),"^",21)
	.s TNeedHandlerDR = $p($g(^DHCEQContract(rowid)),"^",22)
	.i TNeedHandlerDR '=""  d
	..s TNeedHandler = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TNeedHandlerDR)
	.s TGuaranteePeriodNum = $p($g(^DHCEQContract(rowid)),"^",23)
	.s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	.s TRemark = $p($g(^DHCEQContract(rowid)),"^",25)
	.s TAddUserDR = $p($g(^DHCEQContract(rowid)),"^",26)
	.i TAddUserDR '=""  d
	..s TAddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAddUserDR)
	.s TAddDate =##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",27),"date")
	.s TAddTime = $p($g(^DHCEQContract(rowid)),"^",28)
	.s TUpdateUserDR = $p($g(^DHCEQContract(rowid)),"^",29)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",30),"date")
	.s TUpdateTime = $p($g(^DHCEQContract(rowid)),"^",31)
	.s TAuditUserDR = $p($g(^DHCEQContract(rowid)),"^",32)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAuditUserDR)
	.s TAuditDate =##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",33),"date")
	.s TAuditTime = $p($g(^DHCEQContract(rowid)),"^",34)
	.s TArriveMonthNum = $p($g(^DHCEQContract(rowid)),"^",35)
	.s TServiceProDR = $p($g(^DHCEQContract(rowid)),"^",36)
	.i TServiceProDR '=""  d
	..s TServicePro = ##Class(web.DHCEQCommon).GetTrakNameByID("cservice", TServiceProDR)	//$p($g(^DHCEQCCode("DHCEQCService",TServiceProDR)),"^",1)	//CZF0093
	.s TServiceHandler = $p($g(^DHCEQContract(rowid)),"^",37)
	.s TServiceTel = $p($g(^DHCEQContract(rowid)),"^",38)
	.s TApproveSetDR=$p($g(^DHCEQContract(rowid)),"^",42)
	.s TManageLocDR=$p($g(^DHCEQContract(rowid)),"^",51)  //管理部门 modified by ZY0197  增加管理科室参数
	.q:(ManageLocDR'="")&&(ManageLocDR'=TManageLocDR)
	.s TFileNo=$p($g(^DHCEQContract(rowid)),"^",52)  //档案号 add by mwz 20180319
	.q:(FileNo'="")&&(FileNo'=TFileNo)
	.s THold5=$Piece($G(^DHCEQContract(rowid)),"^",57)	//czf 1914903 合同审批类型
	.d OutputRowGetContract
	/*// Mozy0253	1214436		2020-3-4	??
	.s AIRowID=$Order(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.s TApprovals="无"
	.i AIRowID'="" Do
	..s CurRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",4)
	..s TApproveRole=$Piece(^DHCEQApproveInfo(AIRowID),"^",7)
	..i TApproveRole'="" s TApprovals=$p(^DHCEQCCode("DHCEQCApproveRole",TApproveRole),"^",2)	//add by CZF0080 2020-02-24
	*/
	
	quit $$$OK
OutputRowGetContract
	Set TRow=index	// 20150914  Mozy0165 序号
	s Data=$lb(TRowID,TContractName,TContractNo,TQuantityNum,TTotalFee,TPreFeeFee,TPayedTotalFee,TSignDate,TSignLocDR,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TPayTypeDR,TPayItem,TCheckStandard,TProviderDR,TProviderTel,TProviderHandler,TBreakItem,TNeedHandlerDR,TGuaranteePeriodNum,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TSignLoc,TPayType,TProvider,TNeedHandler,TAddUser,TUpdateUser,TAuditUser,TArriveMonthNum,TServiceProDR,TServiceHandler,TServiceTel,TServicePro,TApproveSetDR,TApproveRole,TRow,TContractType,TFileNo,TApprovals,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContract
	s (TRowID,TContractName,TContractNo,TQuantityNum,TTotalFee,TPreFeeFee,TPayedTotalFee,TSignDate,TSignLocDR,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TPayTypeDR,TPayItem,TCheckStandard,TProviderDR,TProviderTel,TProviderHandler,TBreakItem,TNeedHandlerDR,TGuaranteePeriodNum,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TSignLoc,TPayType,TProvider,TNeedHandler,TAddUser,TUpdateUser,TAuditUser,TArriveMonthNum,TServiceProDR,TServiceHandler,TServiceTel,TServicePro,TApproveSetDR,TApproveRole,TRow,TContractType,TFileNo,TApprovals,THold5)=""
	quit
}

ClassMethod GetContractFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractExecute ]
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

ClassMethod GetContractClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// modified by  2018-05-29 ZY0169 
/// 增加明细表字段
/// d ##class(%ResultSet).RunQuery("web.DHCEQContractNew","GetContractList","111")
Query GetContractList(RowID) As %Query(ROWSPEC = "TRowID:%String,TSourceType:%String,TSourceTypeDR:%String,TSourceID:%String,TSourceIDDR:%String,TModel:%String,TModelDR:%String,TManuFactory:%String,TManuFactoryDR:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TContractArriveDate:%String,TArriveDate:%String,TArriveQuantityNum:%String,TRemark:%String,TGuaranteePeriodNum:%String,TItemDR:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TRow:%String,TJob:%String,TCommonName:%String,TUnit:%String,TFileNo:%String,TBrandDR:%String,TBrand:%String,TImportFlag:%String,TGuaranteeContent:%String,TMaintCountType:%String,TMaintTimes:%String")
{
}

ClassMethod GetContractListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
 	new repid, index,rowid
 	new rowid,TRow,TotalFlag,TotalQty,Total
	s (TotalQty,Total)=0
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Job=$J
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	i TotalFlag="1"  s index=2
	s TRow=0
	s rowid=0
	d BuildDataGetContractList
	Quit $$$OK
BuildDataGetContractList
	i RowID'=""
	{
		f  s rowid=$o(^DHCEQContractList(0,"Contract",RowID,rowid))  quit:rowid=""  d
		.d ResetVariablesGetContractList
		.s TRowID = rowid
		.s TRow=TRow+1
		.Set ContractDR=$p($g(^DHCEQContractList(rowid)),"^",1)
		.;Set CLStatus=$p($g(^DHCEQContract(ContractDR)),"^",24)       //过滤非审核状态的设备，modified by czf 2017-03-31
		.;q:CLStatus'=2
		.Set ContractType=$p($g(^DHCEQContract(ContractDR)),"^",39)
		.s TSourceTypeDR = $p($g(^DHCEQContractList(rowid)),"^",5)
		.s TSourceType= $CASE(TSourceTypeDR,"1":"计划","2":"招标","3":"设备项","":"")
		.s TCommonName = $p($g(^DHCEQContractList(rowid)),"^",2) //2013-06-24 DJ0118
		.s TSourceIDDR = $p($g(^DHCEQContractList(rowid)),"^",17)
		.If ContractType=0 d
		..s TSourceType= $CASE(TSourceTypeDR,"1":"计划","2":"招标","3":"设备项","":"")
		..i TSourceTypeDR=1 s TSourceID=$Piece($Get(^DHCEQBuyPlanList(TSourceIDDR)),"^",2) //add by mwz 20180337 需求号539466
		..i TSourceTypeDR=2 s TSourceID=$Piece($Get(^DHCEQIFBBag(TSourceIDDR)),"^",13)
		..i TSourceTypeDR=3 s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TSourceIDDR)),"^",1)
		.Else  Do
		..If TSourceTypeDR=1 Do
		...Set TSourceType="入库明细"
		...Set TSourceID=$Piece($Get(^DHCEQInStockList(TSourceIDDR)),"^",5)
		..If TSourceTypeDR=2 Do
		...Set TSourceType="设备"
		...Set TSourceID=$Piece($Get(^DHCEQEquip(TSourceIDDR)),"^",71)
		...Set TUnitDR=$Piece($Get(^DHCEQEquip(TSourceIDDR)),"^",5)
		...If TUnitDR '="" Set TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		...Set TFileNo=$p($g(^DHCEQEquip(TSourceIDDR)),"^",85)	//Mozy	2017-2-2
		.s TCommonName = $p($g(^DHCEQContractList(rowid)),"^",2)
		.s TModelDR = $p($g(^DHCEQContractList(rowid)),"^",3)
		.i TModelDR '=""  d
		..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		.s TManuFactoryDR = $p($g(^DHCEQContractList(rowid)),"^",4)
		.i TManuFactoryDR '=""  d
		..s TManuFactory =##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)	// $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)	//CZF0093
		.s TPriceFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(rowid)),"^",6),"")
		.s TQuantityNum = $p($g(^DHCEQContractList(rowid)),"^",7)
		.s TTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(rowid)),"^",8),"")
		.s TotalQty=TotalQty+TQuantityNum
		.s Total=Total+TTotalFee
		.s TRemark = $p($g(^DHCEQContractList(rowid)),"^",9)
		.s TContractArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractList(rowid)),"^",10),"date")
		.s TArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractList(rowid)),"^",11),"date")
		.s TArriveQuantityNum = $p($g(^DHCEQContractList(rowid)),"^",12)
		.///modified by  2018-05-29 ZY0169 
		.s TGuaranteePeriodNum = $p($g(^DHCEQContractList(rowid)),"^",16)
		.s TItemDR=$p($g(^DHCEQContractList(rowid)),"^",18)
		.
		.i TItemDR'="" d
		..;s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)	//Mozy	2017-10-11 462084	取消来源取值设备名称
		..Set TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
		..If TUnitDR '="" Set TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		.///modified by  2018-05-29 ZY0169 
		.s TBrandDR = $p($g(^DHCEQContractList(rowid)),"^",19)
		.i TBrandDR '="" Set TBrand = $p($g(^DHCEQCCode("DHCEQCBrand",TBrandDR)),"^",3)
		.s TImportFlag = $p($g(^DHCEQContractList(rowid)),"^",20)
		.s TGuaranteeContent = $p($g(^DHCEQContractList(rowid)),"^",21)
		.s TMaintCountType = $p($g(^DHCEQContractList(rowid)),"^",22)
		.s TMaintTimes = $p($g(^DHCEQContractList(rowid)),"^",23)
		.
		.s THold1 = $p($g(^DHCEQContractList(rowid)),"^",24)
		.s Total=Total+THold1
		.s THold2 = $p($g(^DHCEQContractList(rowid)),"^",25)
		.s THold3 = $p($g(^DHCEQContractList(rowid)),"^",26)
		.s THold4 = $p($g(^DHCEQContractList(rowid)),"^",27)
		.s THold5 = $p($g(^DHCEQContractList(rowid)),"^",28)
		.s TJob=Job
		.d OutputRowGetContractList
	}
	i TRow=0 d
	.d ResetVariablesGetContractList
	.s TRow=1
	.s TJob=Job
	.d OutputRowGetContractList
	s TotalLoc=0		//Add By DJ 2017-10-18
	i TotalFlag="1" s TotalLoc=1
	i TotalFlag="2" s TotalLoc=index+1
	i TotalLoc'=0
	{
		d ResetVariablesGetContractList
		s TRowID=-1
		s TRow="合计"
		s TQuantityNum=TotalQty
		s TTotalFee=##Class(web.DHCEQCommon).FormatNumber(Total,"")
		s index=TotalLoc
		s TJob=Job
		d OutputRowGetContractList
	}
	quit	
OutputRowGetContractList
	s Data=$lb(TRowID,TSourceType,TSourceTypeDR,TSourceID,TSourceIDDR,TModel,TModelDR,TManuFactory,TManuFactoryDR,TPriceFee,TQuantityNum,TTotalFee,TContractArriveDate,TArriveDate,TArriveQuantityNum,TRemark,TGuaranteePeriodNum,TItemDR,THold1,THold2,THold3,THold4,THold5,TRow,TJob,TCommonName,TUnit,TFileNo,TBrandDR,TBrand,TImportFlag,TGuaranteeContent,TMaintCountType,TMaintTimes)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractList
	s (TRowID,TSourceType,TSourceTypeDR,TSourceID,TSourceIDDR,TModel,TModelDR,TManuFactory,TManuFactoryDR,TPriceFee,TQuantityNum,TTotalFee,TContractArriveDate,TArriveDate,TArriveQuantityNum,TRemark,TGuaranteePeriodNum,TItemDR,THold1,THold2,THold3,THold4,THold5,TCommonName,TUnit,TFileNo,TBrandDR,TBrand,TImportFlag,TGuaranteeContent,TMaintCountType,TMaintTimes)=""
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

/// ----------------------------------
/// add:zy 2010-03-14  No ZY0065
/// 描述:新增、更新
/// w ##Class(web.DHCEQContractNew).SaveData("^合同名称^合同号^^^^0^03/03/2011^114^^^^^^^^^^1^^^^^^0^^^^^^0^^^^^^^^^^^","1^1^3^笔记本电脑^^430^8^5^6^30^^^^^^^^","0,-1")
/// ----------------------------------
ClassMethod SaveData(val, valList, DelRowid)
{
	new RowID,User,Date,Time,Job
	k PLIST
	Set $ZT="ERRORSave"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID = $p(val,"^",1)	;RowID
	s PLIST(2) = $p(val,"^",2)	;ContractName
	i PLIST(2)="" Set PLIST(2)=$p(val,"^",3)_"合同"
	s PLIST(3) = $p(val,"^",3)	;ContractNo
	s PLIST(4) = $p(val,"^",4)	;QuantityNum
	s PLIST(5) = $p(val,"^",5)	;TotalFee
	s PLIST(6) = $p(val,"^",6)	;PreFeeFee
	s PLIST(7) = $p(val,"^",7)	;PayedTotalFee
	s PLIST(8) =##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",8),"date")	;SignDate
	s PLIST(9) = $p(val,"^",9)	;SignLocDR
	s PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",10),"date")	;DeliveryDate
	s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;ArriveDate
	s PLIST(12) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",12),"date")	;StartDate
	s PLIST(13) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",13),"date")	;EndDate
	s PLIST(14) = $p(val,"^",14)	;ClaimPeriodNum
	s PLIST(15) = $p(val,"^",15)	;Service
	s PLIST(16) = $p(val,"^",16)	;PayTypeDR
	s PLIST(17) = $p(val,"^",17)	;PayItem
	s PLIST(18) = $p(val,"^",18)	;CheckStandard
	s PLIST(19) = $p(val,"^",19)	;ProviderDR
	s PLIST(20) = $p(val,"^",20)	;ProviderTel
	s PLIST(21) = $p(val,"^",21)	;ProviderHandler
	s PLIST(22) = $p(val,"^",22)	;BreakItem
	s PLIST(23) = $p(val,"^",23)	;NeedHandlerDR
	s PLIST(24) = $p(val,"^",24)	;GuaranteePeriodNum
	s PLIST(25) ="0"	;Status
	s PLIST(26) = $p(val,"^",26)	;Remark
	/*s PLIST(27) = $p(val,"^",27)	;SubmitUserDR
	s PLIST(28) = $p(val,"^",28)	;SubmitDate
	i $p(val,"^",28)'=""  s PLIST(28) = ..TransValueFromPage($p(val,"^",28),"date")	;SubmitDate
	s PLIST(29) = $p(val,"^",29)	;SubmitTime
	*/
	s PLIST(30) = User				;UpdateUserDR
	s PLIST(31) = Date				;UpdateDate
	s PLIST(32) = Time				;UpdateTime
	/*
	s PLIST(33) = $p(val,"^",33)	;AuditUserDR
	s PLIST(34) = $p(val,"^",34)	;AuditDate
	i $p(val,"^",34)'=""  s PLIST(34) = ..TransValueFromPage($p(val,"^",34),"date")	;AuditDate
	s PLIST(35) = $p(val,"^",35)	;AuditTime*/
	
	s PLIST(36) = $p(val,"^",27)	;ArriveMonthNum
	s PLIST(37) = $p(val,"^",28)	;ServiceDR
	s PLIST(38) = $p(val,"^",29)	;ServiceHandler
	s PLIST(39) = $p(val,"^",30)	;ServiceTel
	s PLIST(40) = $p(val,"^",31)	;ContractType
	s PLIST(41) = $p(val,"^",32)	;ArriveItrem
	s PLIST(42) = $p(val,"^",33)	;QualityItem
	/*
	s PLIST(43) = $p(val,"^",34)	;RefuseReason
	s PLIST(44) = $p(val,"^",34)	;RefuseUserDR
	s PLIST(45) = $p(val,"^",34)	;RefuseDate
	s PLIST(46) = $p(val,"^",34)	;RefuseTime
	*/
	s PLIST(47) = $p(val,"^",34)	;IFBNo
	s PLIST(48) = $p(val,"^",35)	;CurrencyDR
	///modified by  2018-05-29 ZY0169 
	s PLIST(49) = $p(val,"^",36)	;BuyTypeDR
	i $p(val,"^",37)'=""  s PLIST(50) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",37),"date")	//GuaranteeStartDate
	i $p(val,"^",38)'=""  s PLIST(51) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",38),"date")	//GuaranteeEndDate
	s PLIST(52) = $p(val,"^",39)	;ManagerLocDR
	s PLIST(53) = $p(val,"^",40)	;ManagerLocDR
	
	s PLIST(54) = $p(val,"^",41)	;Hold1
	s PLIST(55) = $p(val,"^",42)	;Hold2
	s PLIST(56) = $p(val,"^",43)	;Hold3
	s PLIST(57) = $p(val,"^",44)	;Hold4
	s PLIST(58) = $p(val,"^",45)	;Hold5
	
	s Job = $p(val,"^",45) 		;$job
	TSTART
	if RowID=""
	{
		s Flag=##class(web.DHCEQCommon).GetSysInfo("103002")
		if (Flag="1")
		{
			s PLIST(3)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQContract",+$H)
		}
		&SQL(insert into sqluser.DHC_EQContract values :PLIST())
		s RowID=$G(%ROWID)
	}
	else
	{
		&SQL(update sqluser.DHC_EQContract values :PLIST() where CT_RowID=:RowID)

	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	s SQLCODE=..DeleteContractList(RowID,DelRowid)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	s SQLCODE=..SaveContractList(RowID,Job,valList)
 	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
 	TCOMMIT
 	q RowID
ERRORSave 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// Add:zy 2010-03-14  No ZY0065
/// 描述:删除
/// w ##Class(web.DHCEQContractNew).DeleteData("9^^^516^1^^")
/// ----------------------------------
ClassMethod DeleteData(val)
{
	new RowID,ApproveSet
	s RowID=$P(val,"^",1)
	s ApproveTypeDR=##class(web.DHCEQApproveList).GetApproveType("8")
	Set $ZT="ERRORDelete"
	TSTART		
	&SQL(delete from  sqluser.DHC_EQApproveInfo where AI_SourceID=:RowID and  AI_ApproveTypeDR=:ApproveTypeDR)
	i (SQLCODE'=0)&&(SQLCODE'=100)
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(delete from  sqluser.DHC_EQApproveList where AL_SourceID=:RowID and  AL_ApproveTypeDR=:ApproveTypeDR)
	i SQLCODE=100  s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	&SQL(delete from  sqluser.DHC_EQContractList where CTL_ContractDR=:RowID)
 	i SQLCODE=100  s SQLCODE=0
	i SQLCODE
 	{
		TROLLBACK
		q SQLCODE
 	}
	&SQL(delete from sqluser.DHC_EQContract where CT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
	;Add by jdl 2011-5-11 JDL0081
	s SQLCODE=##Class(web.DHCEQPayPlan).DeleteData("",1,RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	
 	TCOMMIT
 	q SQLCODE
ERRORDelete 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// Add:zy 2010-03-14  No ZY0065
/// 描述:提交
/// w ##Class(web.DHCEQContractNew).SubmitData("5^24^^2252^1^^拒绝原因")
/// ----------------------------------
ClassMethod SubmitData(val)
{
	new User,Date,Time,RowID,Job,ApproveType,ApproveSet,TotalFee
	new LastFlag,NextStep,NextRole,Num,ApproveFlow,AutoAuditFlag,AuditFlag
	k PLIST
	s Date=+$H
	s Time=$P($H,",",2)
	Set $ZT="ERRORSubmit"
	s RowID = $p(val,"^",1)	;RowID
	s Status=$p($g(^DHCEQContract(RowID)),"^",24)
	if Status'="0" q -2015   //该记录状态不符合,不能执行操作!
	s Job = $p(val,"^",4) 		;$job
	s User= $p(val,"^",5)
	
	;Add by jdl 2011-5-11 JDL0081
	if (##Class(web.DHCEQPayPlan).CheckPayPlan(1,RowID)="-2") q -1010
	
	s TotalFee=""
	s id=0
	for  set id=$order(^DHCEQContractList(0,"Contract",RowID,id))  quit:id=""  d
	.Set Fee=0
	.Set Fee=$p($g(^DHCEQContractList(id)),"^",8)
	.Set TotalFee=TotalFee+Fee	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", TotalFee,"","")
	i ApproveSet="" q -4007
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"
	
	s PLIST(25) = "1"		;Status 	
	s PLIST(27) = User	;SubmitUserDR
	s PLIST(28) = Date	;SubmitDate
	s PLIST(29) = Time	;SubmitTime
	//检测是否最后一步,是则自动审核 Add By DJ 2010-08-24
	s AuditFlag=0
	i (AutoAuditFlag="Y")&&(NextStep="")
	{
		s AuditFlag=1
		s PLIST(25)="2"
		s PLIST(33) = User	;AuditUserDR
		s PLIST(34) = Date	;AuditDate
		s PLIST(35) = Time	;AuditTime
		s AppInfoStatus="2"
	}
		
	TSTART	
	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,RowID,"8",User)
	i SQLCODE
	{
		TROLLBACK
	 	q SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQContract values :PLIST() where CT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("94", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
 	TCOMMIT
 	q RowID
ERRORSubmit 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORSubmit"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// Add:zy 2010-03-14  No ZY0065
/// 描述:反提交
/// w ##Class(web.DHCEQContractNew).CancelSubmitData("")
/// ----------------------------------
ClassMethod CancelSubmitData(val, CurRole)
{
	new User,Date,Time,RowID,ApproveSet,CancelToFlowDR,ApproveInfoID
	Set $ZT="ERRORCancel"
	k PLIST,AppInfo
	s Date=+$H
	s Time=$P($H,",",2)
	s RowID=$P(val,"^",1)
	s ApproveSet=$P(val,"^",2)
	s CancelToFlowDR=$P(val,"^",3)	
	s User= $p(val,"^",5)
	s RefuseReason= $p(val,"^",7)
	
 	s PLIST(25) = "0"			;Status	
	//s PLIST(43) =RefuseReason	;RefuseReason
	//s PLIST(44) = User			;RefuseUserDR
	//s PLIST(45) = Date			;RefuseDate
	//s PLIST(46) = Time			;RefuseTime
    	s Status="0"
 	s ApproveRoleDR=""
	s Step=""
	TSTART
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
	if (CancelToFlowDR'="")
	{
		s PLIST(25)="1"
	 	s ApproveRoleDR=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",2)
	 	s Step=$p($g(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR)),"^",3)
		s Status="1"
	}
	
	//2015-10-08 ZY0146   取消提交的拒绝原因也写在DHC_EQApproveList表中。表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("8", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RefuseReason,"",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	&SQL(update sqluser.DHC_EQContract values :PLIST() where CT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	else
	{
		s ApproveFlow=""
		i CancelToFlowDR'=""
		{
			s ApproveFlow="N^"_Step_"^"_ApproveRoleDR_"^"_$p(^DHCEQCCode("DHCEQCApproveFlow",CancelToFlowDR),"^",7,11)_"^"_ApproveSet
		}
		s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("94", RowID, User, ApproveFlow, "Y",CurRole)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
 	TCOMMIT
 	q RowID
ERRORCancel 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORCancel"_ErrorMsg     //返回错误消息 ;
}

/// Add:zy 2010-03-14  No ZY0065
/// 描述:审核
/// w ##Class(web.DHCEQContractNew).AuditData("8^24^^^1^^","4","0","")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo)
{
	new User,Date,Time,RowID,ApproveType,ApproveSet,Actions
	new LastFlag,NextStep,NextRole,Num,ApproveFlow,AutoAuditFlag
	Set $ZT="ERRORAudit"
	k PLIST
	s RowID=$P(val,"^",1)
	s Status=$p($g(^DHCEQContract(RowID)),"^",24)
	if Status'="1" q -2015   //该记录状态不符合,不能执行操作!
	s User= $p(val,"^",5)
  	s Opinion=$p(val,"^",6)
	s Date=+$H
	s Time=$P($H,",",2)
	
	
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
	s ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("8", RowID)
	i ApproveSet="" q -4007	
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, RoleStep, CurRole)
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	
	s AppInfoStatus="1"
	
	TSTART	
	
 	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, RowID, Opinion, "", CurRole, RoleStep)
 	if SQLCODE
 	{
	 	TROLLBACK
		q SQLCODE
 	}
 	s AuditFlag=0
	i ((NextStep="")||(LastFlag="Y"))
	{
		s AuditFlag=1
		s AppInfoStatus="2"
		
		s PLIST(33) = User	;AuditUserDR
		s PLIST(34) = Date	;AuditDate
		s PLIST(35) = Time	;AuditTime
		s PLIST(25)="2"
		&SQL(update sqluser.DHC_EQContract values :PLIST() where CT_RowID=:RowID)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}
	//可编辑字段更新
	i editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("94", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
 	q RowID
	
ERRORAudit
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORAudit"_ErrorMsg     //返回错误消息 ;
}

/// ----------------------------------
/// Add:zy 2010-03-14  No ZY0065
/// 描述:写入转移单明细
/// w ##Class(web.DHCEQContractNew).SaveContractList("8","516","1^4^3^传真机^124^1880^8^5^5^25^备注^04/03/2011^^^^^^&2^^2^笔记本电脑^1^^8^5000^10^50000^^^^^^^^")
/// ----------------------------------
ClassMethod SaveContractList(rowid, Job, val)
{
	new Flag,index,Length,CTLRowID,SQLCODE,User,Date,Time,CTTotalFee
	k PLISTMX
	i rowid="" q -1
	i val="" q 0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s Flag=0
	s PLISTMX(2)=rowid  				;ContractDR
	s Length=$l(val,"&")
	s CTTotalFee=0					;Mozy0203	20180224
	for i=1:1:Length
	{
		//1^1^3^笔记本电脑^^430^8^5^6^30^tttt^04/03/2011^^^^^^
		//TSourceType+"^"+TSourceID+"^"+TSourceIDDR+"^"+TModelDR+"^"+TManuFactoryDR+"^"+TPriceFee+"^"+TQuantityNum+"^"+TTotalFee+"^"+TRemark+"^"+
		//TContractArriveDate+"^"+TItemDR+"^"+THold1+"^"+THold2+"^"+THold3+"^"+THold4+"^"+THold5+"^"+THold6;
		q:Flag'=0
		s valList=	$p(val,"&",i)
		s index= $p(valList,"^",1)  		;index
		s CTLRowID= $p(valList,"^",2)  		;CTLRowID
		s PLISTMX(3)=$p(valList,"^",25)  	;CTL_Name	//2013-06-24 DJ0118
		s PLISTMX(4)=$p(valList,"^",6)		;CTL_ModelDR
		s PLISTMX(5)=$p(valList,"^",7)		;CTL_ManuFacDR
		s PLISTMX(6)=$p(valList,"^",3)  	;CTL_SourceType
		s PLISTMX(7)=$p(valList,"^",8)  	;CTL_PriceFee
		s PLISTMX(8)=##Class(web.DHCEQCommon).Trim($p(valList,"^",9))  	;CTL_QuantityNum
		s PLISTMX(9)=$p(valList,"^",10)  	;CTL_TotalFee
		s PLISTMX(10)=$p(valList,"^",11)  	;CTL_Remark
		s PLISTMX(11)=$p(valList,"^",12)
		i PLISTMX(11)'=""  s PLISTMX(11)=##Class(web.DHCEQCommon).TransValueFromPage($p(valList,"^",12),"date")	;CTL_ContractArriveDate
		//s PLISTMX(12)=$p(valList,"^",11)  ;CTL_ArriveDate
		//s PLISTMX(13)=$p(valList,"^",11)  ;CTL_ArriveQuantityNum
		s PLISTMX(14)=User  				;CTL_UpdateUserDR
		s PLISTMX(15)=Date  				;CTL_UpdateDate
		s PLISTMX(16)=Time				  	;CTL_UpdateTime
		
		s PLISTMX(17)=$p(valList,"^",13)  	;CTL_Hold6  //2013-06-24 DJ0118
		s PLISTMX(18)=$p(valList,"^",5)  	;CTL_SourceID
		s PLISTMX(19)=$p(valList,"^",14)  	;CTL_ItemDR		Mozy	2011-4-7
		
		s PLISTMX(20)=$p(valList,"^",15)  	;CTL_BrandDR
		s PLISTMX(21)="N"  	;CTL_ImportFlag
		s PLISTMX(22)=$p(valList,"^",17)  	;CTL_GuaranteeContent
		s PLISTMX(23)=$p(valList,"^",18)  	;CTL_MaintCountType
		s PLISTMX(24)=$p(valList,"^",19)  	;CTL_MaintTimes
		
		s PLISTMX(25)=$p(valList,"^",20)  	;CTL_Hold1
		s PLISTMX(26)=$p(valList,"^",21)  	;CTL_Hold2
		s PLISTMX(27)=$p(valList,"^",22)  	;CTL_Hold3
		s PLISTMX(28)=$p(valList,"^",23)  	;CTL_Hold4
		s PLISTMX(29)=$p(valList,"^",24)  	;CTL_Hold5
		if (CTLRowID="")
		{
			&SQL(Insert Into SQLUSER.DHC_EQContractList Values :PLISTMX())
		}
		else
		{
			&SQL(update sqluser.DHC_EQContractList values :PLISTMX() where CTL_RowID=:CTLRowID)
		}
		i SQLCODE s Flag=index_"^更新明细记录失败!"
		s CTTotalFee=CTTotalFee+$p(valList,"^",10)	//Mozy0203	20180224
	}
	//Mozy0203	20180224	???????????
	i $p($g(^DHCEQContract(rowid)),"^",39)=0 &SQL(update sqluser.DHC_EQContract set CT_TotalFee=:CTTotalFee where CT_RowID=:rowid)	;更新采购合同的总金额
	q Flag
}

/// ----------------------------------
/// Add:zy 2010-03-14  No ZY0065
/// 描述:删除转移明细
/// w ##Class(web.DHCEQContractNew).DeleteContractList("231",",0,-1")
/// ----------------------------------
ClassMethod DeleteContractList(rowid, DelRowid)
{
	new Length,CTLRowID,Flag,i
	s Flag=0
	i rowid="" q -1
	i DelRowid="" q 0
	s Length=$l(DelRowid,",")
	for i=1:1:Length
	{
		q:Flag'=0
		s CTLRowID=$p(DelRowid,",",i)
		if (CTLRowID>0)
		{
			&SQL(delete from  sqluser.DHC_EQContractList where CTL_RowID=:CTLRowID)
			i SQLCODE s Flag=CTLRowID_"^更新操作失败"
		}
	}
	q Flag
}

/// Add:zy 2010-03-14  No ZY0065
/// 合同显示
/// w ##Class(web.DHCEQContractNew).GetOneContract(8)
/// ----------------------------------
ClassMethod GetOneContract(rowid)
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQContract(rowid)
	Set $Piece(result,"^",4)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",4),"")
	Set $Piece(result,"^",5)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",5),"")
	Set $Piece(result,"^",6)=##Class(web.DHCEQCommon).FormatNumber($Piece(result,"^",6),"")
	s $p(result,"^",7)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",7),"date")	;SignDate
	s resultex=resultex_"^"	;SignLocDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",8))
	s $p(result,"^",9)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;DeliveryDate
	s $p(result,"^",10)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")	;ArriveDate
	s $p(result,"^",11)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;StartDate
	s $p(result,"^",12)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;EndDate
	s resultex=resultex_"^"	;PayTypeDR
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("ctpm",$p(result,"^",15))
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",18))
	s resultex=resultex_"^"	;NeedHandlerDR
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",22))
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",26))
	s $p(result,"^",27)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",27),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",29)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",29))
	s $p(result,"^",30)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",30),"date")	;UpdateDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",32)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",32))
	s $p(result,"^",33)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",33),"date")	;AuditDate
	s resultex=resultex_"^"	;ServiceDR
	i $p(result,"^",36)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",$p(result,"^",36))),"^",1)
	///modified by  2018-05-29 ZY0169 
	s resultex=resultex_"^"	;BuyTypeDR
	i $p(result,"^",48)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBuyType",$p(result,"^",48))),"^",2)
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",51)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",51))
	s $p(result,"^",49)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",49),"date")	;CT_GuaranteeStartDate
	s $p(result,"^",50)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",50),"date")	;CT_GuaranteeEndDate
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("8",rowid)
	S ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
	s Opinion=##Class(web.DHCEQApproveList).GetApproveListOpinion(ApproveType,rowid)
	s result=result_resultex_"^"_AppInfo_"^"_Opinion
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

/// Add:zy 2010-03-14  No ZY0065
/// 招标包查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQContractNew","GetIFBList","","","")
Query GetIFBList(VendorDR As %Library.String = "", ItemDesc As %Library.String = "", SouceID As %Library.String = "") As %Query(ROWSPEC = "hidden:%String,TBagNo:%String,TItem:%String,hidden:%String,TModel:%String,hidden:%String,TManuFactory:%String,TWinPrice:%String,TWinQty:%String,hidden:%String,TCommonName:%String,TUnit:%String")
{
}

ClassMethod GetIFBListExecute(ByRef qHandle As %Binary, VendorDR As %Library.String = "", ItemDesc As %Library.String = "", SouceID As %Library.String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set itemid=0
	For  Set itemid=$Order(^DHCEQIFBBag(0,"Item",itemid))  Quit:itemid=""  Do
	.Set TItem=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",itemid)),"^",1)
	.quit:(ItemDesc'="")&&(TItem'[ItemDesc)
	.Set rowid=0
	.For  Set rowid=$Order(^DHCEQIFBBag(0,"Item",itemid,rowid))  Quit:rowid=""  Do
	..set (Status,IFBDR,TBagNo,TWinPrice)=""
	..;Mozy	594563	2018-9-29
	..;i (SouceID="")||(SouceID'=rowid) quit:$D(^DHCEQContractList(0,"SourceID",2,rowid))
	..q:(SouceID'="")&&(SouceID'=rowid)
	..;判断招标包是否已经存在于合同中
	..s findflag=0
	..s tmpCTRowID=0
	..f  s tmpCTRowID=$o(^DHCEQContract(tmpCTRowID)) q:(tmpCTRowID="")||(findflag'=0)  d
	...q:(VendorDR'="")&&($p($g(^DHCEQContract(tmpCTRowID)),"^",18)'=VendorDR)
	...;0>采购	1>保修
	...q:($p($g(^DHCEQContract(tmpCTRowID)),"^",39)'="0")
	...s tmpCTLRowID=0
	...f  s tmpCTLRowID=$o(^DHCEQContractList(0,"Contract",tmpCTRowID,tmpCTLRowID)) q:(tmpCTLRowID="")||(findflag'=0)  d
	....q:$p($g(^DHCEQContractList(tmpCTLRowID)),"^",5)'=2
	....i $p($g(^DHCEQContractList(tmpCTLRowID)),"^",17)=rowid s findflag=1
	..Quit:findflag'=0
	..
	..Set IFBDR=$Piece($Get(^DHCEQIFBBag(rowid)),"^",1)
	..Set Status=$Piece($Get(^DHCEQIFB(IFBDR)),"^",43)
	..Quit:Status'=2
	..Set TBagNo=$Piece($Get(^DHCEQIFBBag(rowid)),"^",2)
	..Set TWinPrice=$Piece($Get(^DHCEQIFBBag(rowid)),"^",11)
	..Set TWinQty=$Piece($Get(^DHCEQIFBBag(rowid)),"^",5)
	..Set ifblistid=0
	..For  Set ifblistid=$Order(^DHCEQIFBList(0,"IFBBag",rowid,ifblistid))  Quit:ifblistid=""  Do
	...Do ResetVariablesGetIFBList
	...Set TVendorDR=$Piece($Get(^DHCEQIFBList(ifblistid)),"^",2)
	...quit:(VendorDR'="")&&(VendorDR'=TVendorDR)
	...Set WinFlag=$Piece($Get(^DHCEQIFBList(ifblistid)),"^",8)
	...quit:WinFlag'="Y"
	...Set TRowID = rowid
	...Set TCommonName=$Piece($Get(^DHCEQIFBBag(rowid)),"^",13) //2013-06-24 DJ0118
	...Set TManuFactoryDR=$Piece($Get(^DHCEQIFBList(ifblistid)),"^",3)
	...If TManuFactoryDR'="" Set TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)	//$Piece($Get(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	...Set TModelDR	=$Piece($Get(^DHCEQIFBList(ifblistid)),"^",4)
	...If TModelDR '="" Set TModel = $Piece($Get(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	...;20150918  Mozy0166
	...Set TUnitDR=$Piece($Get(^DHCEQIFBBag(rowid)),"^",4)
	...If TUnitDR '="" Set TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	...Do OutputRowGetIFBList
	
	Quit $$$OK
OutputRowGetIFBList
	Set Data=$lb(TRowID,TBagNo,TItem,TModelDR,TModel,TManuFactoryDR,TManuFactory,TWinPrice,TWinQty,itemid,TCommonName,TUnit)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
ResetVariablesGetIFBList
	Set (TRowID,TModelDR,TModel,TManuFactoryDR,TManuFactory,TCommonName,TUnit)=""
	Quit
}

ClassMethod GetIFBListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetIFBListExecute ]
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

ClassMethod GetIFBListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetIFBListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetContractListInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", ContractListDR)
{
 	//s Name=$p($G(^DHCEQContractList(ContractListDR)),"^",2)
	s (ModelDR,Model,ContractDR,ProviderDR,Provider,ManuFactoryDR,ManuFactory,EquipCat,EquipCatDR)=""
	s (TestFlag,PriceFee,BuyPlanListDR,ServiceHandler,ServiceTel,UrgencyFlag,ItemDR,UnitDR,Unit,Code)=""
	s (ServiceDR,Service,EquipTypeDR,EquipType,PurchaseTypeDR,PurchaseType,PurposeTypeDR,PurposeType)=""
	s (StatCatDR,StatCat,ContractNo)="" //2009-11-25 党军 DJ0037
	s ModelDR=$p($G(^DHCEQContractList(ContractListDR)),"^",3)
	i ModelDR'="" s Model=$p($G(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	s ContractDR=$p($G(^DHCEQContractList(ContractListDR)),"^",1)
	s ProviderDR=$p($G(^DHCEQContract(ContractDR)),"^",18)
	i ProviderDR'="" s Provider=##class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	s ManuFactoryDR=$p($G(^DHCEQContractList(ContractListDR)),"^",4)
	i ManuFactoryDR'="" s ManuFactory=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",ManuFactoryDR)		//modified by czf 1256286
	s TestFlag=$p($G(^DHCEQContractList(ContractListDR)),"^",5)
	s PriceFee=$p($G(^DHCEQContractList(ContractListDR)),"^",6)
	
	;Modified by JDL 2011-05-18  JDL0081
	s BuyPlanListDR=""
	i $p($G(^DHCEQContractList(ContractListDR)),"^",5)=1  d
	.s BuyPlanListDR=$p($G(^DHCEQContractList(ContractListDR)),"^",17)
	
	s ItemDR=$p($G(^DHCEQContractList(ContractListDR)),"^",18)
	i ItemDR'="" d
	.s UnitDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7)
	.s Code=$P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2)
	.s StatCatDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5) //2009-11-25 党军 DJ0037
	.i StatCatDR'="" s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2) //2009-11-25 党军 DJ0037
	.s EquipTypeDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
	.i EquipTypeDR'="" s EquipType=$P($G(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s EquipCatDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
	.i EquipCatDR'="" s EquipCat=$P($G(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR)),"^",2)
	i UnitDR'="" s Unit=##class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	s ProviderHandler=$P($G(^DHCEQContract(ContractDR)),"^",20)
	s ProviderTel=$P($G(^DHCEQContract(ContractDR)),"^",19)
	s ServiceHandler=$P($G(^DHCEQContract(ContractDR)),"^",37)
	s ServiceTel=$P($G(^DHCEQContract(ContractDR)),"^",38)
	///Modified 2007-02-27
	i BuyPlanListDR'="" d
	.s BuyPlanID=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",1)
	.s UrgencyFlag=$P($G(^DHCEQBuyPlan(BuyPlanID)),"^",33)
	.s PurchaseTypeDR=$P($G(^DHCEQBuyPlan(BuyPlanID)),"^",28)
	.i PurchaseTypeDR'="" s PurchaseType=$P($G(^DHCEQCCode("DHCEQCPurchaseType",PurchaseTypeDR)),"^",2)
	.s PurposeTypeDR=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",20)
	.i PurposeTypeDR'="" s PurposeType=$P($G(^DHCEQCCode("DHCEQCPurposeType",PurposeTypeDR)),"^",2)
	///end 
	s ServiceDR=$p($G(^DHCEQContract(ContractDR)),"^",36)
	i ServiceDR'="" s Service=$P($G(^DHCEQCCode("DHCEQCService",ServiceDR)),"^",1)
	s Return=""
	s Return=Return_ContractListDR_"^"_ContractDR_"^"_ModelDR_"^"_Model_"^"_ManuFactoryDR_"^"_ManuFactory_"^"_ProviderDR_"^"_Provider_"^"_TestFlag
	s Return=Return_"^"_PriceFee_"^"_ProviderHandler_"^"_ProviderTel_"^"_UrgencyFlag_"^"_EquipTypeDR
	s Return=Return_"^"_EquipType_"^"_PurchaseTypeDR_"^"_PurchaseType_"^"_PurposeTypeDR_"^"_PurposeType
	s Return=Return_"^"_ServiceDR_"^"_Service_"^"_ServiceHandler_"^"_ServiceTel_"^"_ItemDR_"^"_EquipCatDR_"^"_EquipCat_"^"_UnitDR_"^"_Unit_"^"_Code
	s Return=Return_"^"_StatCatDR_"^"_StatCat //2009-11-25 党军 DJ0037
	
	;Modified by jdl 2012-3-7 JDL0120
	s LimitYears=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(EquipCatDR,StatCatDR)
	s Return=Return_"^"_LimitYears
	s ContractNo=$P($G(^DHCEQContract(ContractDR)),"^",2)   //Modefied by zc 2014-09-15 ZC0006
	s Return=Return_"^"_ContractNo //2013-4-30 ZY
	s CommonName = $p($g(^DHCEQContractList(ContractListDR)),"^",2)	//2013-06-24 DJ0118
	s Return=Return_"^"_CommonName //2013-06-24 DJ0118
	Set GuaranteePeriodNum=$p($g(^DHCEQContractList(ContractListDR)),"^",16)	//取明细保修期 czf 2021-01-30 1759064
	i GuaranteePeriodNum=""  Set GuaranteePeriodNum=$Piece($Get(^DHCEQContract(ContractDR)),"^",23)	///20150825  Mozy0163	保修期
	Set Return=Return_"^"_GuaranteePeriodNum
	//modified by wy 2020-4-22 1286572 档案号取值
	set FileNo=$Piece($Get(^DHCEQContract(ContractDR)),"^",52)
	Set Return=Return_"^"_FileNo
	
	/// modified by zy0273 20210705
	s (TQuantityNum,CLLRowID,TCLLBuyLocDR,TCLLBuyLoc,CLLQuantity)=""
	s TQuantityNum=$p($G(^DHCEQContractList(ContractListDR)),"^",7)
	s CLLFlag=0
	s CLLRowID=$o(^DHCEQContractListLoc(0,"ContractList",ContractListDR,CLLRowID))
	i CLLRowID'="" d
	.s TCLLBuyLocDR=$p($g(^DHCEQContractListLoc(CLLRowID)),"^",4)
	.s TCLLBuyLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TCLLBuyLocDR)
	.s CLLQuantity=$p($g(^DHCEQContractListLoc(CLLRowID)),"^",5)
	.i (TQuantityNum=CLLQuantity)  Set Return=Return_"^"_TCLLBuyLocDR_"^"_TCLLBuyLoc
	Set Return=Return_"^"_TCLLBuyLocDR_"^"_TCLLBuyLoc
	
	q Return
}

ClassMethod ContractTypeList(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	i Type=0 d
	.w "<option value=></option>"
	.w "<option value=0>采购合同</option>"
	.w "<option value=2>协议采购合同</option>"
	.w "<option value=3>投放合同</option>"
	e  i Type=1 d
	.w "<option value=1>保修合同</option>"
	e  i Type=2 d
	.w "<option value=2>协议采购合同</option>"
	e  i Type=3 d
	.w "<option value=3>投放合同</option>"
	e  d
	.w "<option value=></option>"
	.w "<option value=0>采购合同</option>"
	.w "<option value=2>协议采购合同</option>"
	.w "<option value=3>投放合同</option>"
	
	w "</select>",!
}

/// modified by  2018-05-29 ZY0169 
/// w ##Class(web.DHCEQContractNew).GetContractType(1)
ClassMethod GetContractType(ContractType)
{
	Quit $CASE(ContractType,"0":"采购合同","1":"保修合同","2":"协议采购","3":"投放合同",:"没有定义")
}

/// GR0054 买保合同明细查询界面调用
/// w ##Class(%ResultSet).RunQuery("web.DHCEQContractNew","GetContractDetail","","","","",0,63928,"","","","","","","1")
/// modified by czf 2017-03-06 加上入参CurLocID,CurGroupID,QXType
/// add by lmm 2017-05-03 371478
Query GetContractDetail(ContractName, SignLocDR, ProviderDR, StartDate, EndDate, StatusDR, ContractNo, ContractType, EquipName As %String = "", CurLocID As %String = "", CurGroupID As %String = "", QXType As %String = "", CurHospID As %String = "", CurUserID As %String = "", ReportFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TContractName:%String,TContractNo:%String,TNum:%String,TTotal:%String,TPreFeeFee:%String,TPayedTotalFee:%String,TSignDate:%String,TSignLocDR:%String,TDeliveryDate:%String,TArriveDate:%String,TStartDate:%String,TEndDate:%String,TClaimPeriodNum:%String,TService:%String,TPayTypeDR:%String,TPayItem:%String,TCheckStandard:%String,TProviderDR:%String,TProviderTel:%String,TProviderHandler:%String,TBreakItem:%String,TNeedHandlerDR:%String,TGuaranteePeriodNum:%String,TStatus:%String,TRemark:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TAuditUserDR:%String,TAuditDate:%String,TAuditTime:%String,TSignLoc:%String,TPayType:%String,TProvider:%String,TNeedHandler:%String,TAddUser:%String,TUpdateUser:%String,TAuditUser:%String,TArriveMonthNum:%String,TServiceProDR:%String,TServiceHandler:%String,TServiceTel:%String,TServicePro:%String,TRow:%String,TContractType:%String,TName:%String,TApproveRole:%String") [ SqlProc ]
{
}

ClassMethod GetContractDetailExecute(ByRef qHandle As %Binary, ContractName, SignLocDR, ProviderDR, StartDate, EndDate, StatusDR, ContractNo, ContractType, EquipName As %String = "", CurLocID As %String = "", CurGroupID As %String = "", QXType As %String = "", CurHospID As %String = "", CurUserID As %String = "", ReportFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i ReportFlag=""
	{
		i StartDate="" s StartDate=0
		i EndDate="" s EndDate=+$H
	}
	else
	{
		i StartDate=""
		{
			s StartDate=0
		}
		else
		{
			s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
		}
		i EndDate=""
		{
			s EndDate=+$H
		}
		else
		{
			s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
		}
	}
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8") ///add by lmm 2017-05-03 371478
	Set TRow=0
	s rowid=0
	f  s rowid=$o(^DHCEQContract(rowid)) q:rowid=""  d
	.d ResetVariablesGetContractDetail
	.s TContractName = $p($g(^DHCEQContract(rowid)),"^",1)
	.q:(ContractName'="")&&(TContractName'[ContractName)
	.s TContractNo = $p($g(^DHCEQContract(rowid)),"^",2)
	.q:(ContractNo'="")&&(TContractNo'[ContractNo)
	.s TSignDate =$p($g(^DHCEQContract(rowid)),"^",7)
	.q:(TSignDate>EndDate)||(TSignDate<StartDate)
	.s TSignDate = ##Class(web.DHCEQCommon).TransValueToPage(TSignDate,"date")
	.s TSignLocDR = $p($g(^DHCEQContract(rowid)),"^",8)
	.q:(SignLocDR'="")&&(TSignLocDR'=SignLocDR)
	.;q:((TSignLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TSignLocDR)))
	.s TProviderDR = $p($g(^DHCEQContract(rowid)),"^",18)
	.q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	.i TProviderDR '=""  d
	..s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TStatus= $p($g(^DHCEQContract(rowid)),"^",24)
	.q:(StatusDR'="")&&(TStatus'=StatusDR)
	.s TContractType=$p($g(^DHCEQContract(rowid)),"^",39)
	.;q:(TContractType'="0")
	.q:((ContractType'="")&&(ContractType'=TContractType))
	.///add by lmm 2017-05-03 begin 371478
	.
	.s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,rowid,0))
	.i AIRowID'="" s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	.s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("8",rowid)
	.i ApproveInfo'=""  d
	..s TApproveRole=$p(ApproveInfo,"^",9)
	..s TApproveStep=$p(ApproveInfo,"^",5)	
	.
	.///add by lmm 2017-05-03 end 371478
	.s TRowID = rowid
	.s TContractNo = $p($g(^DHCEQContract(rowid)),"^",2)
	.s TPreFeeFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(rowid)),"^",5),"")
	.s TPayedTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContract(rowid)),"^",6),"")
	.i TSignLocDR '=""  d
	..s TSignLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TSignLocDR)
	.s TDeliveryDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",9),"date")
	.s TArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",10),"date")
	.s TStartDate =##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",11),"date")
	.s TEndDate =##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",12),"date")
	.s TClaimPeriodNum = $p($g(^DHCEQContract(rowid)),"^",13)
	.s TService = $p($g(^DHCEQContract(rowid)),"^",14)
	.s TPayTypeDR = $p($g(^DHCEQContract(rowid)),"^",15)
	.i TPayTypeDR '=""  d
	..s TPayType = $p($g(^CT("CTPM",TPayTypeDR)),"^",2)
	.s TPayItem = $p($g(^DHCEQContract(rowid)),"^",16)
	.s TCheckStandard = $p($g(^DHCEQContract(rowid)),"^",17)
	.s TProviderTel = $p($g(^DHCEQContract(rowid)),"^",19)
	.s TProviderHandler = $p($g(^DHCEQContract(rowid)),"^",20)
	.s TBreakItem = $p($g(^DHCEQContract(rowid)),"^",21)
	.s TNeedHandlerDR = $p($g(^DHCEQContract(rowid)),"^",22)
	.i TNeedHandlerDR '=""  d
	..s TNeedHandler = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TNeedHandlerDR)
	.s TGuaranteePeriodNum = $p($g(^DHCEQContract(rowid)),"^",23)
	.s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
        .//modified by wb 2017-5-5 需求号：371446
	.;s TRemark = $p($g(^DHCEQContract(rowid)),"^",25)   
        .//end by wb
	.s TAddUserDR = $p($g(^DHCEQContract(rowid)),"^",26)
	.i TAddUserDR '=""  d
	..s TAddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAddUserDR)
	.s TAddDate =##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",27),"date")
	.s TAddTime = $p($g(^DHCEQContract(rowid)),"^",28)
	.s TUpdateUserDR = $p($g(^DHCEQContract(rowid)),"^",29)
	.i TUpdateUserDR '=""  d
	..s TUpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TUpdateUserDR)
	.s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",30),"date")
	.s TUpdateTime = $p($g(^DHCEQContract(rowid)),"^",31)
	.s TAuditUserDR = $p($g(^DHCEQContract(rowid)),"^",32)
	.i TAuditUserDR '=""  d
	..s TAuditUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TAuditUserDR)
	.s TAuditDate =##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",33),"date")
	.s TAuditTime = $p($g(^DHCEQContract(rowid)),"^",34)
	.s TArriveMonthNum = $p($g(^DHCEQContract(rowid)),"^",35)
	.s TServiceProDR = $p($g(^DHCEQContract(rowid)),"^",36)
	.i TServiceProDR '=""  d
	..s TServicePro =##Class(web.DHCEQCommon).GetTrakNameByID("cservice", TServiceProDR)	//$p($g(^DHCEQCCode("DHCEQCService",TServiceProDR)),"^",1) //CZF0093
	.s TServiceHandler = $p($g(^DHCEQContract(rowid)),"^",37)
	.s TServiceTel = $p($g(^DHCEQContract(rowid)),"^",38)
	.s TApproveSetDR=$p($g(^DHCEQContract(rowid)),"^",42)
	.s (TQuantityNum,TTotalFee)=0
	.s CTLRowID=0
	.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",rowid,CTLRowID)) q:CTLRowID=""  d
	..s (TNum,TTotal)=0
	..s TNum = $p($g(^DHCEQContractList(CTLRowID)),"^",7)
	..s TTotal = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(CTLRowID)),"^",8),"")
	..//Modified by wb 2017-5-5  需求号：371446 由获取合同明细备注改为获取合同明细列表里的备注
	..s TRemark = $p($g(^DHCEQContractList(CTLRowID)),"^",9)
	..//end by wb-2017-5-5
	..s TName=$p($g(^DHCEQContractList(CTLRowID)),"^",2)
	..q:((EquipName'="")&&(TName'[EquipName))
	..d OutputRowGetContractDetail
	quit $$$OK
OutputRowGetContractDetail
	Set TRow=TRow+1
	s Data=$lb(TRowID,TContractName,TContractNo,TNum,TTotal,TPreFeeFee,TPayedTotalFee,TSignDate,TSignLocDR,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TPayTypeDR,TPayItem,TCheckStandard,TProviderDR,TProviderTel,TProviderHandler,TBreakItem,TNeedHandlerDR,TGuaranteePeriodNum,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TSignLoc,TPayType,TProvider,TNeedHandler,TAddUser,TUpdateUser,TAuditUser,TArriveMonthNum,TServiceProDR,TServiceHandler,TServiceTel,TServicePro,TRow,TContractType,TName,TApproveRole) ///add by lmm 2017-05-03 371478
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractDetail
	s (TRowID,TContractName,TContractNo,TNum,TTotal,TPreFeeFee,TPayedTotalFee,TSignDate,TSignLocDR,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TPayTypeDR,TPayItem,TCheckStandard,TProviderDR,TProviderTel,TProviderHandler,TBreakItem,TNeedHandlerDR,TGuaranteePeriodNum,TStatus,TRemark,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TAuditUserDR,TAuditDate,TAuditTime,TSignLoc,TPayType,TProvider,TNeedHandler,TAddUser,TUpdateUser,TAuditUser,TArriveMonthNum,TServiceProDR,TServiceHandler,TServiceTel,TServicePro,TContractType,TName,TApproveRole)=""  ///add by lmm 2017-05-03 371478
	quit
}

ClassMethod GetContractDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractDetailExecute ]
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

ClassMethod GetContractDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Modify by Mozy 2018-11-6	588850
/// 保修合同明细设备查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQContractNew","GetEquipList","^StatusDR=2^SignLocDR=")
Query GetEquipList(vData As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,TBatchFlag:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TLocation:%String,TGuaranteePeriodNum:%String,TStatCatDR:%String,TStatCat:%String,TFileNo:%String,TRentLocDR:%String,TRentStatus:%String,TFaultStatus:%String,TDisuseDate:%String,TAccountNo:%String,Thold6:%String,Thold7:%String,Thold8:%String,Thold9:%String,Thold10:%String,TAdvanceDisFlag:%String,TInStockNo:%String,TCommonName:%String,TFundsInfo:%String,TPayNo:%String,TUnusualRemark:%String,TRow:%String,TSignDate:%String")
{
}

ClassMethod GetEquipListExecute(ByRef qHandle As %Binary, vData As %String = "") As %Status
{
	//d ..KillTempGlobal("Equip")
	//midified by zy 2015-7-1 ZY0134  不需要这个来判断数据,改成直接以设备异常状态来判断.
	//s approveroleid=##class(web.DHCEQCommon).GetSysInfo("601003")		//哪个角色审批时作为院内审批完成
 	new repid, index, rowid,vStoreLocDR,TotalNum,TotalFee
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("GetEquipList")=vData
 	Set TotalNum=0
 	Set TotalFee=0
 	Set (TotalNetFee,TotalNetRemainFee,TotalDepreTotalFee)=0
 	Set index=2
	;Set CurLocID=##Class(web.DHCEQCommon).getMapIDBySource("dept",%session.Get("LOGON.CTLOCID"))
	Set CurGroupID=%session.Get("LOGON.GROUPID")
	Set gnum=1
	;Set curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	;k ^DHCEQTemp("EquipList",curuser)
 	
 	Set vData=##Class(web.DHCEQCommon).UnEscape(vData)
 	Set ContractType=##Class(web.DHCEQCommon).GetDataByName(vData,"ContractType")
	Set ContractName=##Class(web.DHCEQCommon).GetDataByName(vData,"ContractName")
 	Set ContractNo=##Class(web.DHCEQCommon).GetDataByName(vData,"ContractNo")
	Set StartDate=##Class(web.DHCEQCommon).GetDataByName(vData,"StartDate")
 	If StartDate'="" Set StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")	;签订日期
	Set EndDate=##Class(web.DHCEQCommon).GetDataByName(vData,"EndDate")
 	If EndDate'="" Set EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	If StartDate="" Set StartDate=0
	If EndDate="" Set EndDate=+$H
 	Set SignLocDR=##Class(web.DHCEQCommon).GetDataByName(vData,"SignLocDR")
 	Set ProviderDR=##Class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
 	Set StatusDR=##Class(web.DHCEQCommon).GetDataByName(vData,"StatusDR")
 	Set EquipName=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipName")
	Set QXType=##Class(web.DHCEQCommon).GetDataByName(vData,"QXType")
	Set EquipDR=##Class(web.DHCEQCommon).GetDataByName(vData,"EquipDR")
	
	s CTRowID=0
	f  s CTRowID=$o(^DHCEQContract(CTRowID)) q:CTRowID=""  d
	.d ResetVariablesGetContractDetail
	.s TContractType=$p($g(^DHCEQContract(CTRowID)),"^",39)		;0采购合同		1保修合同	3协议合同	4投放合同
	.q:(ContractType'="")&(TContractType'=ContractType)
	.s TContractName = $p($g(^DHCEQContract(CTRowID)),"^",1)
	.q:(ContractName'="")&&(TContractName'[ContractName)
	.
	.s TContractNo = $p($g(^DHCEQContract(CTRowID)),"^",2)
	.q:(ContractNo'="")&&(TContractNo'[ContractNo)
	.s TSignDate =$p($g(^DHCEQContract(CTRowID)),"^",7)
	.q:(TSignDate>EndDate)||(TSignDate<StartDate)
	.s TSignDate = ##Class(web.DHCEQCommon).TransValueToPage(TSignDate,"date")
	.s TSignLocDR = $p($g(^DHCEQContract(CTRowID)),"^",8)
	.q:(SignLocDR'="")&&(TSignLocDR'=SignLocDR)
	.;q:((TSignLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TSignLocDR)))
	.;s TProviderDR = $p($g(^DHCEQContract(CTRowID)),"^",18)
	.;q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	.;s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TStatus=$p($g(^DHCEQContract(CTRowID)),"^",24)
	.q:(StatusDR'="")&&(TStatus'=StatusDR)
	.
	.;s AIRowID=$o(^DHCEQApproveInfo(0,"SourceID",ApproveType,CTRowID,0))
	.;i AIRowID'="" s CurRole=$p(^DHCEQApproveInfo(AIRowID),"^",4)
	.;i ((WaitAD="on")&&(CurRole'="")) q:CurRole'=ApproveRole
	.;s ApproveInfo=##Class(web.DHCEQApprove).GetApproveInfoBySourceID("8",CTRowID)
	.;i ApproveInfo'=""  d
	.;.s TApproveRole=$p(ApproveInfo,"^",9)
	.;.s TApproveStep=$p(ApproveInfo,"^",5)
	.
	.s CTLRowID=0
	.f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) q:CTLRowID=""  d
	..q:(EquipName'="")&&($ZCONVERT($p($g(^DHCEQContractList(CTLRowID)),"^",2),"U")'[$ZCONVERT(EquipName,"U"))
	..s SourceType=$p($g(^DHCEQContractList(CTLRowID)),"^",5)
	..s SourceID=$p($g(^DHCEQContractList(CTLRowID)),"^",17)
	..i SourceType=4 d
	...s rowid=SourceID
	...d FillOneDataGetEquipList
	
	s TotalFlag=##class(web.DHCEQCommon).GetSysInfo("401001")
	i (TotalFlag'="")&&(TotalFlag'="0")
	{
		i TotalFlag="1" s TotalLoc=1
		i TotalFlag="2" s TotalLoc=index+1
		i TotalFlag="3" s TotalLoc=0
		d ResetVariablesGetEquipList
		s TRow="合计:"
		s TQuantity=TotalNum
		s TOriginalFee=TotalFee
		
		Set TNetFee=##Class(web.DHCEQCommon).FormatNumber(TotalNetFee,"")
		Set TNetRemainFee=##Class(web.DHCEQCommon).FormatNumber(TotalNetRemainFee,"")
		Set TDepreTotalFee=##Class(web.DHCEQCommon).FormatNumber(TotalDepreTotalFee,"")
		
		//格式化金额为小数点两位
		i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
		Set Data=$lb(TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TInStockNo,TCommonName,TFundsInfo,TPayNo,TUnusualRemark,TRow,TSignDate)
		Set ^CacheTemp(repid,TotalLoc)=Data
		;Set ^DHCEQTemp("EquipList",curuser,gnum)=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TSignDate
	}
	
	Quit $$$OK
FillOneDataGetEquipList
	d ResetVariablesGetEquipList
	d CheckGetEquipList
	q:passed=0
	d SetVariablesGetEquipList
	d OutputRowGetEquipList
	quit
ResetVariablesGetEquipList
	s (TRowID,TName,TABCType,TModelDR,TEquiCatDR,TUnitDR,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TCountryDR,TManageLocDR,TManageLevelDR,TUseLocDR,TOriginDR,TFromDeptDR,TToDeptDR,TBuyTypeDR,TEquipTechLevelDR,TProviderDR,TManuFactoryDR,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TWorkLoadUnitDR,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TEquipTypeDR,TPurchaseTypeDR,TPurposeTypeDR,TKeeperDR,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TDisplayStatus,TDisplayStockStatus)=""
	s (TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TStoreMoveNo,TInStockNo,TCommonName,THospitalDR,TFundsInfo,TPayNo,TUnusualRemark,TRow,TSignDate)=""
	s TBatchFlag="N"
	quit
CheckGetEquipList
	s passed=0
	i (EquipDR'="")&&(EquipDR'=rowid) quit
	s EquipData=$g(^DHCEQEquip(rowid))
	s TUseLocDR = $p(EquipData,"^",19)
	s TProviderDR = $p(EquipData,"^",25)
	i (ProviderDR'="")&&(TProviderDR'=ProviderDR) quit
	s TInvalidFlag = $p(EquipData,"^",59)
	i TInvalidFlag'="N" quit
	s TStatus = $p(EquipData,"^",38)
	i (TStatus=3) quit
	s TStoreLocDR = $p(EquipData,"^",67)
	;i (1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TStoreLocDR,CurLocID,CurGroupID))) quit
	Set TEquipTypeDR=$p(EquipData,"^",63)
	i ("1"=##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR, CurGroupID)) quit
	
	s passed=1
	quit

SetVariablesGetEquipList
	s TQuantity = 1
	s TotalNum=TotalNum+TQuantity
	s TRowID = rowid
	s EquipData=$g(^DHCEQEquip(rowid))
	s TCommonName = $p(EquipData,"^",1)
	s TName = $p(EquipData,"^",1)
	s TABCType = $p(EquipData,"^",2)
	s TModelDR = $p(EquipData,"^",3)
	s TModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model",TModelDR)
	s TEquiCatDR = $p(EquipData,"^",4)
	i TEquiCatDR '=""  d
	.s TEquiCat = $p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquiCatDR)),"^",2)
	s TUnitDR = $p(EquipData,"^",5)
	s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
	s TItemDR=$p(EquipData,"^",7)
	i TItemDR'="" s TName=$ZCONVERT($p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1),"U")
	s TInstallLocDR = $p(EquipData,"^",8)
	s TInstallLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TInstallLocDR)
	s TInstallDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",9),"date")
	s TLeaveFactoryNo = $p(EquipData,"^",10)
	s TLeaveFactoryDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",11),"date")
	s TOpenCheckDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",12),"date")
	s TCheckDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",13),"date")
	s TMakeDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",14),"date")
	s TComputerFlag = $p(EquipData,"^",15)
	s TCountryDR = $p(EquipData,"^",16)
	s TCountry = ##Class(web.DHCEQCommon).GetTrakNameByID("cou",TCountryDR)
	s TManageLocDR = $p(EquipData,"^",17)
	s TManageLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	s TManageLevelDR = $p(EquipData,"^",18)
	i TManageLevelDR '=""  d
	.s TManageLevel = $p($g(^DHCEQCCode("DHCEQCManageLevel",TManageLevelDR)),"^",2)
	s TUseLocDR = $p(EquipData,"^",19)
	s TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TOriginDR = $p(EquipData,"^",20)
	i TOriginDR '=""  d
	.s TOrigin = $p($g(^DHCEQCCode("DHCEQCOrigin",TOriginDR)),"^",2)
	s TFromDeptDR = $p(EquipData,"^",21)
	i TFromDeptDR '=""  d
	.s TFromDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TFromDeptDR)),"^",2)
	s TToDeptDR = $p(EquipData,"^",22)
	i TToDeptDR '=""  d
	.s TToDept = $p($g(^DHCEQCCode("DHCEQCFromToDept",TToDeptDR)),"^",2)
	s TBuyTypeDR = $p(EquipData,"^",23)
	i TBuyTypeDR '=""  d
	.s TBuyType = $p($g(^DHCEQCCode("DHCEQCBuyType",TBuyTypeDR)),"^",2)
	s TEquipTechLevelDR = $p(EquipData,"^",24)
	i TEquipTechLevelDR '=""  d
	.s TEquipTechLevel = $p($g(^DHCEQCCode("DHCEQCTechLevel",TEquipTechLevelDR)),"^",2)
	s TProviderDR = $p(EquipData,"^",25)
	s TProvider =##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TManuFactoryDR = $p(EquipData,"^",26)
	i TManuFactoryDR '=""  d
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)	//$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) //CZF0093
	s TOriginalFee = $p(EquipData,"^",27)
	s TotalFee=TotalFee+TOriginalFee
	
	s TNetFee = $p(EquipData,"^",28)
	s TNetRemainFee = $p(EquipData,"^",29)
	s TGroupDR = $p(EquipData,"^",30)
	i TGroupDR '=""  d
	.s TGroup =$p($g(^DHCEQGroup(TGroupDR)),"^",2)
	s TLimitYearsNum = $p(EquipData,"^",31)
	;s TContractListDR = $p(EquipData,"^",32)	采购合同
	;i TContractListDR '=""  d
	;.s TContractList = $p($g(^DHCEQContractList(TContractListDR)),"^",1)
	s TContractList=TContractName
	s TDepreMethodDR = $p(EquipData,"^",33)
	i TDepreMethodDR '=""  d
	.s TDepreMethod = $p($g(^DHCEQCCode("DHCEQCDepreMethod",TDepreMethodDR)),"^",2)
	s TRemark = $p(EquipData,"^",34)
	s TDepreTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",35),"")
	s TotalNetFee=TotalNetFee+TNetFee
	s TotalNetRemainFee=TotalNetRemainFee+TNetRemainFee
	s TotalDepreTotalFee=TotalDepreTotalFee+TDepreTotalFee
	s TDesignWorkLoadNum = $p(EquipData,"^",36)
	s TWorkLoadUnitDR = $p(EquipData,"^",37)
	s TWorkLoadUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TWorkLoadUnitDR)
	;s TStatus = $p(EquipData,"^",38)
	;s TDisplayStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay(TStatus)
	s TDisplayStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay($p($g(^DHCEQContract(CTRowID)),"^",24))	;合同状态
	s TManageUserDR = $p(EquipData,"^",39)
	s TManageUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TManageUserDR)
	s TMaintUserDR = $p(EquipData,"^",40)
	s TMaintUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUserDR)
	s TProviderHandler = $p(EquipData,"^",41)
	s TProviderTel = $p(EquipData,"^",42)	
	s TAppendFeeTotalFee = $p(EquipData,"^",43)
	s TStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")
	s TTransAssetDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",45),"date")
	s TGuaranteeFlag = $p(EquipData,"^",46)
	s TInputFlag = $p(EquipData,"^",47)
	s TTestFlag = $p(EquipData,"^",48)
	s TMedicalFlag = $p(EquipData,"^",49)
	;s TGuaranteeStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",50),"date")
	;s TGuaranteeEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",51),"date")
	s TGuaranteeStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(CTRowID)),"^",11),"date")
	s TGuaranteeEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(CTRowID)),"^",12),"date")
	s TAddUserDR = $p(EquipData,"^",52)
	s TAddUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TAddUserDR)
	s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",53),"date")
	s TAddTime = $p(EquipData,"^",54)
	s TUpdateUserDR = $p(EquipData,"^",55)
	s TUpdateUser = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	s TUpdateDate = ##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",56),"date")
	s TUpdateTime = $p(EquipData,"^",57)
	s TCurrencyDR = $p(EquipData,"^",58)
	s TCurrency = ##Class(web.DHCEQCommon).GetTrakNameByID("cur",TCurrencyDR)
	s TInvalidFlag = $p(EquipData,"^",59)
	s TStockStatus = $p(EquipData,"^",60)
	s TDisplayStockStatus=##Class(web.DHCEQEquip).GetEquipStockStatusDisplay(TStockStatus)
	s TMemoryCode = $p(EquipData,"^",61)
	s TUrgencyFlag = $p(EquipData,"^",62)
	;s TEquipTypeDR = $p(EquipData,"^",63)
	s TEquipType = $p($g(^DHCEQCCode("DHCEQCEquipType",TEquipTypeDR)),"^",2)
	s TPurchaseTypeDR = $p(EquipData,"^",64)
	i TPurchaseTypeDR '=""  d
	.s TPurchaseType = $p($g(^DHCEQCCode("DHCEQCPurchaseType",TPurchaseTypeDR)),"^",2)
	s TPurposeTypeDR = $p(EquipData,"^",65)		// Mozy003013	1274689 	2020-04-18
	i TPurposeTypeDR '=""  d
	.s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	s TKeeperDR = $p(EquipData,"^",66)
	s TKeeper = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TKeeperDR)
	s TStoreLocDR = $p(EquipData,"^",67)
	s TStoreLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TStoreLocDR)
	s TStartDepreMonth = $p(EquipData,"^",68)
	s TServiceDR = $p(EquipData,"^",69)
	i TServiceDR '=""  d
	.s TService =##Class(web.DHCEQCommon).GetTrakNameByID("cservice", TServiceDR)	// $p($g(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",1)	//CZF0093
	s TInStockListDR = $p(EquipData,"^",70)
	i TTransAssetDate="" d //无转资日期显示入库审核日期
	.i TInStockListDR '=""  d
	..s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	..s TTransAssetDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQInStock(TInStockList)),"^",13),"date")
	i TInStockListDR '=""  d
	.s TInStockList = $p($g(^DHCEQInStockList(TInStockListDR)),"^",1)
	.i TInStockList'="" s TInStockList = $p($g(^DHCEQInStock(TInStockList)),"^",14)
	.s TPayNo=##class(web.DHCEQPayRecord).GetPayNo("1",TInStockListDR)
	s TNo = $p(EquipData,"^",71)
	s TLocationDR = $p(EquipData,"^",72)
	i TLocationDR'="" s TLocation=$p($g(^DHCEQCCode("DHCEQCLocation",TLocationDR)),"^",2)
	// Mozy003013	1274689 	2020-04-18
	s TGuaranteePeriodNum=$p($g(^DHCEQContractList(CTLRowID)),"^",16)	;  CTL_Hold6->保修期
	i TGuaranteePeriodNum="" s TGuaranteePeriodNum=$p($g(^DHCEQContract(CTRowID)),"^",23)
	i TGuaranteePeriodNum="" s TGuaranteePeriodNum=$p(EquipData,"^",73)
	
	s TStatCatDR=$p(EquipData,"^",75)
	i TStatCatDR'="" d
	.s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	
	s TFileNo=$p(EquipData,"^",85)
	s TRentLocDR=$p(EquipData,"^",86)
	s TRentStatus=$p(EquipData,"^",87)
	s TFaultStatus=$p(EquipData,"^",88)
	s TDisuseDate=$p(EquipData,"^",89)
	i TDisuseDate'="" s TDisuseDate=##Class(web.DHCEQCommon).TransValueToPage(TDisuseDate,"date")
	s TAccountNo=$p(EquipData,"^",90)
	s Thold6=$p(EquipData,"^",91)
	s Thold7=$p(EquipData,"^",92)
	s Thold8=$p(EquipData,"^",93)
	
	s Thold8=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus(Thold8)
	s TAdvanceDisFlag=Thold8
	s TUnusualRemark=$p(EquipData,"^",104)
	s TUnusualRemark=$p($Get(^DHCEQEquip(rowid,"OtherInfo")),"^",9)
	s Thold9=$p(EquipData,"^",94)
	i Thold9'="" s Thold9=$p($g(^DHCEQCCode("DHCEQCBrand",Thold9)),"^",3)
	s Thold10=$p(EquipData,"^",95)
	s TFundsInfo=##Class(web.DHCEQEquip).GetFundsInfo(TRowID) //资金来源描述信息的显示
	
	quit
OutputRowGetEquipList
	//格式化金额为小数点两位
	i TOriginalFee'="" s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"")
	i TNetFee'="" s TNetFee=##Class(web.DHCEQCommon).FormatNumber(TNetFee,"")
	i TNetRemainFee'="" s TNetRemainFee=##Class(web.DHCEQCommon).FormatNumber(TNetRemainFee,"")
	i TLimitYearsNum'="" s TLimitYearsNum=##Class(web.DHCEQCommon).FormatNumber(TLimitYearsNum,"")
	Set TRow=gnum
	Set Data=$lb(TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TInStockNo,TCommonName,TFundsInfo,TPayNo,TUnusualRemark,TRow,TSignDate)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	;s ^DHCEQTemp("EquipList",curuser,gnum)=TName_"^"_TModel_"^"_TEquiCat_"^"_TUnit_"^"_TCode_"^"_TDesc_"^"_TInstallLoc_"^"_TInstallDate_"^"_TLeaveFactoryNo_"^"_TLeaveFactoryDate_"^"_TCheckDate_"^"_TOpenCheckDate_"^"_TMakeDate_"^"_TCountry_"^"_TUseLoc_"^"_TOrigin_"^"_TFromDept_"^"_TToDept_"^"_TBuyType_"^"_TProvider_"^"_TManuFactory_"^"_TOriginalFee_"^"_TNetFee_"^"_TNetRemainFee_"^"_TLimitYearsNum_"^"_TContractList_"^"_TDepreMethod_"^"_TRemark_"^"_TDepreTotalFee_"^"_TDesignWorkLoadNum_"^"_TWorkLoadUnit_"^"_TManageUser_"^"_TMaintUser_"^"_TProviderHandler_"^"_TProviderTel_"^"_TAppendFeeTotalFee_"^"_TStartDate_"^"_TTransAssetDate_"^"_TGuaranteeFlag_"^"_TTestFlag_"^"_TMedicalFlag_"^"_TGuaranteeStartDate_"^"_TGuaranteeEndDate_"^"_TBatchFlag_"^"_TQuantity_"^"_TMemoryCode_"^"_TUrgencyFlag_"^"_TEquipType_"^"_TPurchaseType_"^"_TPurposeType_"^"_TKeeper_"^"_TStoreLoc_"^"_TStartDepreMonth_"^"_TService_"^"_TInStockList_"^"_TNo_"^"_TDisplayStatus_"^"_TDisplayStockStatus_"^"_TLocation_"^"_TGuaranteePeriodNum_"^"_TStoreLocDR_"^"_TStatCat_"^^"_TRowID_"^"_TFileNo_"^"_TRentLocDR_"^"_TRentStatus_"^"_TFaultStatus_"^"_TDisuseDate_"^"_TAccountNo_"^"_Thold6_"^"_Thold7_"^"_Thold8_"^"_Thold9_"^"_Thold10_"^"_TAdvanceDisFlag_"^"_TInStockNo_"^"_TCommonName_"^"_TFundsInfo_"^"_TPayNo_"^"_TUnusualRemark_"^"_TRow_"^"_TSignDate
	s gnum=gnum+1
	quit
}

ClassMethod GetEquipListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipListExecute ]
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

ClassMethod GetEquipListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// /modified by  JYP 2017-04-26  
/// /合同号是唯一字段，不能复制，状态需要变更为新增状态。
/// /----------------
/// 创建:JYP 2017-04-25  
/// 目的:复制合同
/// 描述:复制合同信息
/// 输入:被复制的合同信息
/// 返回值: 成功返回复制后的合同RowID
/// 状态：
/// w ##Class(web.DHCEQContractNew).CopyContract("12")
ClassMethod CopyContract(val)
{
	s rowid=$p(val,"^",1)
	k PLIST
	//s Status="0"                                                                 //状态设定
	//s ContractNo=      //新合同号
	Set $ZT="ERRORCopy"
	new CTRowID,CTLRowID
	s (CTRowID,CTLRowID)=""
	TSTART
	    &SQL(select * into :PLIST() from sqluser.DHC_EQContract where CT_RowID=:rowid)  //modify  by jyp 20170726
	    
	    if SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
	    s (PLIST(33),PLIST(34),PLIST(35),PLIST(27),PLIST(28),PLIST(29))=""    //将提交和审核相关信息置空
	    s PLIST(30)=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))                              //修改更新人为当前登录人             
	    s PLIST(3)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQContract",+$H) //取新合同号    
	    s PLIST(25)="0"                                                       //状态置新增
	    s PLIST(1)=""                                                         //RowID置空
	    &SQL(insert into sqluser.DHC_EQContract values :PLIST())
		if SQLCODE'=0
		{
			TROLLBACK
			q SQLCODE
		}
		s CTRowID=$G(%ROWID)
        f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",rowid,CTLRowID))  quit:((CTLRowID="")||(SQLCODE'=0))  d
        .s SQLCODE=..CopyContractList(CTRowID,CTLRowID)
        if SQLCODE'=0 
        {
           TROLLBACK
           q SQLCODE
        }

        
 	TCOMMIT
 	q SQLCODE_"^"_CTRowID
ERRORCopy 
	Set ErrorMsg=$ZE	          //得到系统返回的错误消息
 	TROLLBACK		              //回滚事务
 	Quit "ERRORCopy"_ErrorMsg     //返回错误消息 ;
}

/// /modified by  JYP 2017-04-26  
/// /合同号是唯一字段，不能复制，状态需要变更为新增状态。
/// /----------------
/// 创建:JYP 2017-04-25  
/// 目的:复制合同内设备明细信息
/// 描述:在复制合同时调用，复制合同内设备明细信息
/// 输入:被复制合同的rowid，复制后合同的rowid
/// 返回值: 返回SQLCODE
/// 状态：
/// w ##Class(web.DHCEQContractNew)CopyContractList("12","13")
ClassMethod CopyContractList(rowid, CTLRowID)
{
	k PLISTMX
	&SQL(select * into :PLISTMX() from sqluser.DHC_EQContractList Where CTL_RowID=:CTLRowID)
	s PLISTMX(2)=rowid                                          //取复制后的合同主表ID
	s PLISTMX(1)=""                                             //RowID置空
	k PLISTMX(12)
	k PLISTMX(13)
	&SQL(Insert Into SQLUSER.DHC_EQContractList Values :PLISTMX())
	q SQLCODE
}

// w ##Class(web.DHCEQContractNew).SaveArriveRecord

ClassMethod SaveArriveRecord(val As %String = "", valList)
{
	new User,Date,Time,rowid,ID
	Set $ZT="ERRORSaveArriveRecord"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
 	s Date=+$H
	s Time=$P($H,",",2)

	s PLISTA(3)=$p(val,"^",1)   //供应商
	s PLISTA(4)=Date         //$p(val,"^",2)  到货日期
	/*后期新增界面用
	s PLISTA(5)=$p(val,"^",3)    //送货人
	s PLISTA(6)=$p(val,"^",4)    //送货联系人
	s PLISTA(7)=$p(val,"^",5)    //送货人联系电话
	s PLISTA(8)=$p(val,"^",6)    //接收人
	s PLISTA(9)=$p(val,"^",7)    //接收地点
	s PLISTA(10)=$p(val,"^",8)   //包装总件数
	*/
	s PLISTA(15)=User   //
	s PLISTA(16)=Date   //
	s PLISTA(17)=Time   //
	TSTART	
	;s PLIST(1)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQArrive",Date)
	&SQL(Insert Into SQLUSER.DHC_EQArrive Values :PLISTA())
	if SQLCODE
 	{
	 	TROLLBACK
	 	q SQLCODE
 	}
 	s rowid=$G(%ROWID)
 	s ID=rowid
 	s SQLCODE=##Class(web.DHCEQContractNew).SaveArriveList(ID,valList)
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q ID
ERRORSaveArriveRecord
 	TROLLBACK		         //回滚事务
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSaveArriveRecord"_ErrorMsg     //返回错误消息 ;
}

ClassMethod SaveArriveList(ArriveID, val, ArriveLocDR As %Library.String = "")
{
	new Length,ALRowID,ContractListID,OpenCheckRequestID,ID,Flag
	k PLISTAL
	i ArriveID="" q ""
	s PLISTAL(2)=ArriveID  				;ArriveDR
	
	s Length=$l(val,"&")
	s Flag=0
	for i=1:1:Length
	{
		q:Flag'=0
		s valList=	$p(val,"&",i)
		;保存到货明细
		s PLISTAL(3)=$p(val,"^",1)    //1:合同明细
		s PLISTAL(4)=$p(val,"^",2)         //对应业务ID   1：合同明细ID;
		s ContractListID=$p(val,"^",2)
		s PLISTAL(5)= $p(val,"^",3)   //2  到货数量 $p(val,"^",9)
		s ArriveListNum=$p(val,"^",3)
		/*后期新增界面用 
		s PLISTAL(6)= $p(val,"^",10)    //包装数量
		s PLISTAL(7)= $p(val,"^",11)   //存放地点
		*/
		s PLISTAL(8)="1"               //到货状态
		s PLISTAL(10)="N"
		/*后期新增界面用
		s PLISTAL(14)= $p(val,"^",12)   //验收组
		s PLISTAL(15)= $p(val,"^",13)  //验收人
		*/
	 	&SQL(Insert Into SQLUSER.DHC_EQArriveList Values :PLISTAL())
		i SQLCODE
 		{
			s Flag=SQLCODE
 		}
 		q:Flag'=0
 		s ALRowID=$G(%ROWID)
 		s ID=ALRowID
	    s OpenCheckRequestID=##Class(web.DHCEQContractNew).SaveOpenCheckRequest(ContractListID,ArriveListNum,ArriveLocDR)
		i OpenCheckRequestID'>0
 		{
			s Flag=OpenCheckRequestID
 		}
 		q:Flag'=0
 		//Modify By QW 2017-07-20 通知验收不提交
		/*s OpenCheckRequestID= ##Class(web.DHCEQContractNew).SubmitOpenCheckRequest(OpenCheckRequestID)
		i OpenCheckRequestID'>0
 		{
			s Flag=OpenCheckRequestID
 		}
 		q:Flag'=0*/
 		//
 		if ID'=""
		{
 			&SQL(Update SQLUSER.DHC_EQArriveList Set AL_OpenCheckListDR=:OpenCheckRequestID where AL_RowID=:ID)
	 		i SQLCODE
	 		{
				s Flag=SQLCODE
	 		}
		}
 		q:Flag'=0
	}
	q Flag
}

/// modified by ZY0221 2020-04-14 取值错误
/// w ##Class(web.DHCEQContractNew).SaveOpenCheckRequest(6,1)
ClassMethod SaveOpenCheckRequest(ContractListID, ArriveListNum, ArriveLocDR As %Library.String = "")
{
	
	new val,TContractDR,TContractNo,TItemDR,TGuaranteePeriodNum,TDepreMethodDR,TLimitYears,TOriginDR,TExpendituresDR
	new TProviderDR,TProviderHandler,TProviderTel,TServiceDR,TServiceHandler,TServiceTel,TEquipCatDR,TStatCatDR,TEquipTypeDR,TUnitDR,TName,TCode
	new TFileNo
	i ContractListID="" q -1
	s (val,TContractDR,TContractNo,TItemDR,TGuaranteePeriodNum,TDepreMethodDR,TLimitYears,TOriginDR,TExpendituresDR)=""
	s (TProviderDR,TProviderHandler,TProviderTel,TServiceDR,TServiceHandler,TServiceTel,TEquipCatDR,TStatCatDR,TEquipTypeDR,TUnitDR,TName,TCode)=""
	s TFileNo=""
	s result= ^DHCEQContractList(ContractListID)
	s TContractDR=$p(result,"^",1)
	s TContractNo=$p($g(^DHCEQContract(TContractDR)),"^",2)
	s TProviderDR=$p($g(^DHCEQContract(TContractDR)),"^",18)
	s TProviderHandler=$P($G(^DHCEQContract(TContractDR)),"^",20)
	s TProviderTel=$P($G(^DHCEQContract(TContractDR)),"^",19)
	s TServiceDR=$p($G(^DHCEQContract(TContractDR)),"^",36)
	s TServiceHandler=$P($G(^DHCEQContract(TContractDR)),"^",37)
	s TServiceTel=$P($G(^DHCEQContract(TContractDR)),"^",38)
	s TGuaranteePeriodNum=$p(result,"^",16)     ;  CTL_Hold6->保修期 $Piece($Get(^DHCEQContract(TContractDR)),"^",23)
	s TExpendituresDR=$Piece($Get(^DHCEQContract(TContractDR)),"^",23)
	s TDepreMethodDR=##class(web.DHCEQCommon).GetSysInfo(301002)
	s TOriginDR=##class(web.DHCEQCommon).GetSysInfo(301008)
	s TItemDR=$p(result,"^",18)
	i TItemDR'="" d
	.s TUnitDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
	.s TName=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	.s TCode=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",2)
	.s TStatCatDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",5) //2009-11-25 党军 DJ0037
	.s TEquipTypeDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",3)
	.s TEquipCatDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",4)
	s TLimitYears=##Class(web.DHCEQCEquipeCat).GetYearsByCatID(TEquipCatDR,TStatCatDR)
	s TPurchaseTypeDR=##class(web.DHCEQCommon).GetSysInfo(301009)
	s TFileNo=$P($G(^DHCEQContract(TContractDR)),"^",52)  //add by sjh 2019-10-31  BUG00016
	//add by ZY0213
	s (UseLocDR,BuyRequestListID,BuyRequestID)=""
	//"1":"计划","2":"招标","3":"设备项","4":"设备","5":"入库明细","":""
	s SourceType = $p(result,"^",5)
	s SourceID = $p(result,"^",17)
	i SourceType=1 d
	.s BuyRequestListID=$Piece($Get(^DHCEQBuyPlanList(SourceID)),"^",10)
	e  i SourceType=2 d
	.//0：设备项 1采购申请 2采购计划
	.s SourceType=$Piece($Get(^DHCEQIFBBag(SourceID)),"^",9)
	.s SourceID=$Piece($Get(^DHCEQIFBBag(SourceID)),"^",10)
	.i SourceType=1 d
	..s BuyRequestListID=SourceID
	.e  i SourceType=2  d
	..s BuyRequestListID=$Piece($Get(^DHCEQBuyPlanList(SourceID)),"^",10)
	i BuyRequestListID'="" s BuyRequestID=$Piece($Get(^DHCEQBuyRequestList(BuyRequestListID)),"^",1)
	i BuyRequestID'="" s UseLocDR=$Piece($Get(^DHCEQBuyRequest(BuyRequestID)),"^",4)
	//end by ZY0213
	i ArriveLocDR'="" s UseLocDR=ArriveLocDR	// MZY0058	2020-10-18
	
    s val=val_"^"_TName  //2
    s val=val_"^"_TCode //3
    s val=val_"^"_TPurchaseTypeDR  //4
    s val=val_"^"_TEquipTypeDR  //5
    s val=val_"^"_TStatCatDR  //6
    s val=val_"^"_TEquipCatDR  //7
    s val=val_"^^^^^^"_TUnitDR  //13
	s val=val_"^"_""  //14  规格             	
    s val=val_"^"_""  //15   国别
    //s val=val_"^^"_$p(result,"^",7)  //17 验收数量为到货数量需要从到货记录中获取
    s val=val_"^^"_ArriveListNum  //验收数量为到货数量需要从到货记录中获取
    s val=val_"^^^"_TProviderDR //20    供应商          	
    s val=val_"^"_TProviderHandler  //21  供应商联系人
    s val=val_"^"_TProviderTel  //22       供应商联系电话
    s val=val_"^"_$p(result,"^",4) // 生产产商         	
    s val=val_"^^"_""  //25  出厂日期
    s val=val_"^"_TServiceDR  //26   服务商
    s val=val_"^^"_$p(result,"^",16) 	///	保修期
    s val=val_"^"_$p(result,"^",6) //29 原值
    s val=val_"^^"_TOriginDR  //31  设备来源
    s val=val_"^"_UseLocDR	//$p(result,"^",20) //32  使用科室	modified by ZY0213
    s val=val_"^"_TLimitYears  //33  使用年限
    s val=val_"^"_TDepreMethodDR  //34  折旧方法
    s val=val_"^^^^^^^^^^^^^^^^^^^^^^^"_ContractListID    //57 ContractListID
    s val=val_"^"_TContractNo    //58 合同号
    s val=val_"^"_"0"  //59      验收类型
    s val=val_"^^^"_TItemDR  //62  设备项
    s val=val_"^^^^"_$p(result,"^",24)     //注册证号  modified by sjh 2019-10-31 BUG00016
    s val=val_"^^^"_TExpendituresDR  //69	经费来源需要从合同来
    s val=val_"^^^^"_1 //68  sourcetype
    s val=val_"^"_ContractListID   //69 sourceid
    s val=val_"^^^^"_TServiceHandler  //78  服务商联系人
    s val=val_"^"_TServiceTel  ///  79服务商联系电话
    s val=val_"^^"_$p(result,"^",2) //81  商用名
  	s val=val_"^^^^"_"0"  //85 入账形式
  	s val=val_"^^^^^^^^"
	s val=val_TFileNo  //add by sjh 2019-10-31 BUG00016
	
	k rowid
	s rowid=$p(val,"^",1)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	s Date=+$H
	s Time=$P($H,",",2)
	s CurRole=$p(val,"^",3)	
	//s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")

	/************设备批量审批总单****************/
	s PLIST(2)=$p(val,"^",59) 
	s PLIST(3)=$p(val,"^",5)
	s PLIST(4)=$p(val,"^",4)
	s PLIST(5)=$p(val,"^",6)
	s PLIST(6)=$p(val,"^",20)   ;Provider
	s PLIST(7)=$p(val,"^",21)
	s PLIST(8)=$p(val,"^",22)
	s PLIST(9)=$p(val,"^",31)
	s PLIST(10)=$p(val,"^",41)
	;20150807  Mozy0157
	s PLIST(11) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",61),"date")
	s PLIST(12) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",60),"date")
	s PLIST(13)=$p(val,"^",53)
	s PLIST(14)=$p(val,"^",50)
	s PLIST(15)=$p(val,"^",51)
	s PLIST(16)=$p(val,"^",47)
	s PLIST(17)=$p(val,"^",56)
	s PLIST(18)=$p(val,"^",52)
	s PLIST(19)=$p(val,"^",48)
	s PLIST(20)=$p(val,"^",49)
	s PLIST(21)="0"
	s PLIST(22)=$p(val,"^",55)
	s PLIST(29)=$p(val,"^",54)

	//s PLIST(38)=$p(val,"^",76)		//RequestHold1  存验收单号
	s PLIST(39)=$p(val,"^",77)		//RequestHold2 
	s PLIST(40)=""  //$p(val,"^",78)		//RequestHold3
	s PLIST(41)=""  //$p(val,"^",79)		//RequestHold4
	s PLIST(42)=$p(val,"^",80)		//RequestHold5
	s PLIST(46)="N"					//InvalidFlag
	/************设备批量审批细单****************/
	s PLISTMX(3)=$p(val,"^",81)		//2013-06-24 DJ0118
	s PLISTMX(4)=$p(val,"^",5)
	s PLISTMX(5)=$p(val,"^",11)
	s PLISTMX(6)=$p(val,"^",14)
	s PLISTMX(7)=$p(val,"^",7)
	s PLISTMX(8)=$p(val,"^",13)
	s PLISTMX(9)=$p(val,"^",3)
	s PLISTMX(10)=$p(val,"^",62)
	s PLISTMX(11) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",24),"date")	;20150807  Mozy0157
	s PLISTMX(12)=$p(val,"^",15)
	//s PLISTMX(13)=""
	s PLISTMX(14)=$p(val,"^",9)
	//s PLISTMX(15)=""
	s PLISTMX(16)=$p(val,"^",23)      ;ManuFactory
	s PLISTMX(17)=$p(val,"^",17)
	s PLISTMX(18)=$p(val,"^",29)
	s PLISTMX(19)=$p(val,"^",30)
	s PLISTMX(20)=$p(val,"^",33)
	s PLISTMX(21)=$p(val,"^",34)
	s PLISTMX(22)=$p(val,"^",16)
	s PLISTMX(23)=$p(val,"^",8)
	s PLISTMX(24)=$p(val,"^",4)
	s PLISTMX(25)=$p(val,"^",18)
	s PLISTMX(26)=$p(val,"^",26)
	s PLISTMX(27)=$p(val,"^",27)
	s PLISTMX(28)=$p(val,"^",28)
	s PLISTMX(29)=$p(val,"^",6)
	s PLISTMX(30)=$p(val,"^",37)
	s PLISTMX(31)=$p(val,"^",38)
	s PLISTMX(32)=$p(val,"^",10)
	//s PLISTMX(33)=""
	s PLISTMX(34)=$p(val,"^",32)
	s PLISTMX(35)=$p(val,"^",55)
	s PLISTMX(36)=$p(val,"^",19)
	s PLISTMX(37)=$p(val,"^",58)
	s PLISTMX(38)=$p(val,"^",57)
 	;20150807  Mozy0157
 	i $p(val,"^",45)'=""  s PLISTMX(39) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",45),"bool") ;
 	i $p(val,"^",44)'=""  s PLISTMX(40) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",44),"bool") ;
 	i $p(val,"^",46)'=""  s PLISTMX(41) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",46),"bool") ;
 	i $p(val,"^",43)'=""  s PLISTMX(42) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",43),"bool") ;
 	i $p(val,"^",42)'=""  s PLISTMX(43) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",42),"bool") ;
 	s PLISTMX(44) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",39),"date")
 	s PLISTMX(45) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",40),"date")
 	s PLISTMX(46) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",61),"date")
 	s PLISTMX(47) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",60),"date")
 	s PLISTMX(48)=$p(val,"^",36)
 	s PLISTMX(49) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",35),"date")
 	s PLISTMX(50) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",25),"date")
 	
	s PLISTMX(51)=$p(val,"^",12) 
	//Add ZY 2009-10-30 ZY0014 
	s PLISTMX(56)=$p(val,"^",65)  
	s PLISTMX(57)=$p(val,"^",66)  
	s PLISTMX(58)=$p(val,"^",67)  
	s PLISTMX(59)=$p(val,"^",68)  
	s PLISTMX(60)=$p(val,"^",69) 
	//End ZY 2009-10-30 ZY0014 
	s LeaveFactoryIDs=$TRANSLATE($p(val,"^",64),"，",",")	//201702-04	Mozy
	/********************************************/ //2009-11-25 党军 begin DJ0037
	i $p(val,"^",70)'=""  s PLISTMX(61) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",70),"bool") ;
	i $p(val,"^",71)'=""  s PLISTMX(62) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",71),"bool") ;
	i $p(val,"^",72)'=""  s PLISTMX(63) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",72),"bool") ;
	s PLISTMX(64)=$p(val,"^",73) ;sourcetype
	s PLISTMX(65)=$p(val,"^",74) ;sourceid
	s PLISTMX(66)=$p(val,"^",75)
	
	//add by GBX 2014-11-18
	s PLISTMX(67)=$p(val,"^",82)  //价值类型
	s PLISTMX(68)=$p(val,"^",83)  //使用方向
	s PLISTMX(69)=$p(val,"^",84)  //UserDR
	s PLISTMX(70)=$p(val,"^",85)  //入账形式
	s PLISTMX(71)=$p(val,"^",86)  //项目预算编号
	//end by GBX 2014-11-18
	//add by GBX 2014-11-24
	s PLISTMX(72)=$p(val,"^",87)  //会计凭证号
	//end by GBX 2014-11-24
	i $p(val,"^",88)'="" s PLISTMX(73) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",88),"bool")	//Hold6		放射标志
	i $p(val,"^",89)'="" s PLISTMX(74) = ##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",89),"bool")	//Hold7		中医标志	//Modify DJ 2017-01-20
	s PLISTMX(75)=$p(val,"^",90)  //Hold8
	s PLISTMX(76)=$p(val,"^",91)  //Hold9
	s PLISTMX(77)=$p(val,"^",92)  //Hold10
	s PLISTMX(78)=$p(val,"^",78)  //OCL_ServiceHandler
	s PLISTMX(79)=$p(val,"^",79)  //OCL_ServiceTel
	s FileNo=$TRANSLATE($p(val,"^",93),"，",",")	//201702-04	Mozy
 	/********************************************/ //2009-11-25 党军 end DJ0037
 	i (rowid="")  //新增按钮操作
 	{
		s PLIST(38)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQOpenCheckRequest",Date,"",$p(val,"^",5))
	 	&SQL(Insert Into SQLUSER.DHC_EQOpenCheckRequest Values :PLIST())
	 	if SQLCODE
	 	{
		 	q SQLCODE
	 	}
	 	s OCRRowID=$G(%ROWID)
	 	s PLISTMX(2)=OCRRowID
	 	&SQL(Insert Into SQLUSER.DHC_EQOpenCheckList Values :PLISTMX())
	 	if SQLCODE
	 	{
		 	q SQLCODE
		}
		s OCLRowID=$G(%ROWID) //2009-08-17 党军
		s ^DHCEQOpenCheckList(OCLRowID,"EX")=LeaveFactoryIDs //2009-08-17 党军
		Set ^DHCEQOpenCheckList(OCLRowID,"FileNo")=FileNo	//20150819  Mozy0159
		/*************************************************/ //2009-11-25 党军 begin DJ0037
		
		s return=##Class(web.DHCEQOpenCheckRequest).SourceUpdate(PLISTMX(64),PLISTMX(65),PLISTMX(17),1)
		if return
		{
			q return
		}
		/*************************************************/ //2009-11-25 党军 end DJ0037
		//Function:Funds	2012-2-16 生成资金来源信息
		;Modified By JDL 2012-2-15 JDL0116
		s OCLAmount=$p(^DHCEQOpenCheckList(OCLRowID),"^",16)*$p(^DHCEQOpenCheckList(OCLRowID),"^",17)
		s return=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(0,OCLRowID,OCLAmount)
		if return
		{
			q return
		}
		// Mozy0233		2019-11-25	1096373	 把合同明细对应的DHC_EQCContractConfig的内容写到验收单明细对应的表中/DHC_EQAffix/DHC_EQDoc/DHC_EQConfig
		if (PLISTMX(64)=1)||(PLISTMX(64)=4)
		{
			Set return=##Class(web.DHCEQContractConfig).SaveConfigBySource(PLISTMX(65),OCLRowID)
			if return
			{
				TROLLBACK
				Quit return
			}
		}
 	}
 	q OCRRowID
}

ClassMethod SubmitOpenCheckRequest(rowid As %Library.String = "")
{
 ;k rowid
 ;s rowid=$p(val,"^",1)
 s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
 s Date=+$H
 s Time=$P($H,",",2)
 s CurRole=$p(val,"^",3)	
 s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
 ;Add by jdl 2011-5-11 JDL0081
 if (##Class(web.DHCEQPayPlan).CheckPayPlan(2,rowid)="-2") q -1010
 s Status=$p($g(^DHCEQOpenCheckRequest(rowid)),"^",20) //状态
 if Status'="0" q -2015   //该记录状态不符合,不能执行操作!
 n PLISTTJ
 s PLISTTJ(21)="1"
 s PLISTTJ(23)=User
 s PLISTTJ(24)=Date
 s PLISTTJ(25)=Time
 s ocrrowid=rowid
 s EquipType=$P(^DHCEQOpenCheckRequest(rowid),"^",2)
 s PurchaseType=$P(^DHCEQOpenCheckRequest(rowid),"^",3)
 s YearFlag=""
 s oclrowid=$o(^DHCEQOpenCheckList(0,"OpenCheckRequest",rowid,0))
 s MaxPrice=$P(^DHCEQOpenCheckList(oclrowid),"^",17)
 s SpecialType=##Class(web.DHCEQOpenCheckRequest).GetSpecialType(oclrowid)
 s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
 i ApproveSet="" q -4007

 s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,ocrrowid,"7",User)
 i SQLCODE
 {

	q SQLCODE
 }
 s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, ocrrowid, 0, "")
 s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 s LastFlag=$P(ApproveFlow,"^",1)
 s NextStep=$P(ApproveFlow,"^",2)
 s NextRole=$P(ApproveFlow,"^",3)
 s AppInfoStatus="1"	 

 s PLISTTJ(33)=ApproveSet
 s PLISTTJ(34)=NextRole
 s PLISTTJ(35)=NextStep
 s PLISTTJ(36)=""
 s PLISTTJ(37)=""
 s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,rowid,NextRole,NextStep,"","",AppInfoStatus)
 If SQLCODE
 {
	 Quit SQLCODE
 }
 &SQL(Update SQLUSER.DHC_EQOpenCheckRequest Values :PLISTTJ() where OCR_RowID=:ocrrowid)
 if SQLCODE
 {
	q SQLCODE
 }
 ;Modified by jdl 2011-3-8  jdl0073
 s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("11", ocrrowid, User, ApproveFlow_"^"_ApproveSet, "N","")
 i SQLCODE
 {
	q SQLCODE
 }
 s OCLAmount=$p(^DHCEQOpenCheckList(oclrowid),"^",16)*$p(^DHCEQOpenCheckList(oclrowid),"^",17)
 s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(0,oclrowid,OCLAmount)
 if SQLCODE
 {
	 q SQLCODE
 }
 q ocrrowid
}

/// add by  2018-05-29 ZY0169 
/// 表结构修改和增加了字段
/// 合同明细综合查询query
/// d ##Class(%ResultSet).RunQuery("web.DHCEQContractNew","ContractList","")
Query ContractList(vData As %String) As %Query(ROWSPEC = "TRowID:%String,TContractName:%String,TContractNo:%String,TSignDate:%String,TSignLocDR:%String,TSignLoc:%String,TPreFeeFee:%String,TPayedTotalFee:%String,TDeliveryDate:%String,TArriveDate:%String,TStartDate:%String,TEndDate:%String,TClaimPeriodNum:%String,TService:%String,TCheckStandard:%String,TProviderDR:%String,TProvider:%String,TProviderTel:%String,TProviderHandler:%String,TBreakItem:%String,TGuaranteePeriodNum:%String,TStatus:%String,TArriveMonthNum:%String,TServiceDR:%String,TService:%String,TContractType:%String,TFileNo:%String,TRowIDMX:%String,TName:%String,TPrice:%String,TQuantityNum:%String,TTotal:%String,THold1:%String") [ SqlProc ]
{
}

ClassMethod ContractListExecute(ByRef qHandle As %Binary, vData As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s gnum=1
	s curuser=%session.Get("LOGON.USERID")
	k ^DHCEQTemp("EquipList",curuser)
 	Set vData=##class(web.DHCEQCommon).UnEscape(vData)
 	Set ContractTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"ContractTypeDR")
 	Set Name=##class(web.DHCEQCommon).GetDataByName(vData,"Name")
 	Set ContractName=##class(web.DHCEQCommon).GetDataByName(vData,"ContractName")
 	Set ContractNo=##class(web.DHCEQCommon).GetDataByName(vData,"ContractNo")
 	Set SignLocDR=##class(web.DHCEQCommon).GetDataByName(vData,"SignLocDR")
 	Set ProviderDR=##class(web.DHCEQCommon).GetDataByName(vData,"ProviderDR")
 	Set ModelDR=##class(web.DHCEQCommon).GetDataByName(vData,"ModelDR") 	
 	Set BuyTypeDR=##class(web.DHCEQCommon).GetDataByName(vData,"BuyTypeDR") 	
 	Set FileNo=##class(web.DHCEQCommon).GetDataByName(vData,"FileNo")
 	Set FromOriginalFee=##class(web.DHCEQCommon).GetDataByName(vData,"FromOriginalFee")
 	Set ToOriginalFee=##class(web.DHCEQCommon).GetDataByName(vData,"ToOriginalFee")
 	Set SignBeginDate=##class(web.DHCEQCommon).GetDataByName(vData,"SignBeginDate")
 	Set SignEndDate=##class(web.DHCEQCommon).GetDataByName(vData,"SignEndDate")
	s SignBeginDate=##Class(web.DHCEQCommon).TransValueFromPage(SignBeginDate,"date")
	s SignEndDate=##Class(web.DHCEQCommon).TransValueFromPage(SignEndDate,"date")
	i SignBeginDate="" s SignBeginDate=0
	i SignEndDate="" s SignEndDate=+$H
 	
 	Set OpenCheckBeginDate=##class(web.DHCEQCommon).GetDataByName(vData,"OpenCheckBeginDate")
 	Set OpenCheckEndDate=##class(web.DHCEQCommon).GetDataByName(vData,"OpenCheckEndDate")
 	//Set No=$ZCONVERT(##class(web.DHCEQCommon).GetDataByName(vData,"No"),"U")
	//s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	//i StartDate="" s StartDate=0
	//i EndDate="" s EndDate=+$H
	/*
	s vContractNo=0
	f  s vContractNo=$o(^DHCEQContract(0,"ContractNo",vContractNo))  q:vContractNo=""  d
	.q:(ContractNo'="")&&(vContractNo'[ContractNo)
	.s rowid=0
	.f  s rowid=$o(^DHCEQContract(0,"ContractNo",vContractNo,rowid))  q:rowid=""  d
	*/
	
	s vFileNo=""
	f  s vFileNo=$o(^DHCEQContract(0,"FileNo",vFileNo),-1)  q:vFileNo=""  d
	.q:(FileNo'="")&&(vFileNo'[FileNo)
	.s rowid=0
	.f  s rowid=$o(^DHCEQContract(0,"FileNo",vFileNo,rowid))  q:rowid=""  d
	..s TContractType=$p($g(^DHCEQContract(rowid)),"^",39)
	..q:(ContractTypeDR'="")&&(ContractTypeDR'=TContractType)
	..//s TContractNo=$p($g(^DHCEQContract(rowid)),"^",39)
	..//q:(ContractNo'="")&&(ContractNo'=TContractNo)
	..s MXRowID=0
	..f  s MXRowID=$o(^DHCEQContractList(0,"Contract",rowid,MXRowID))  q:MXRowID=""  d
	...d FillOneContarctListData
	/*..i TContractType=1  d
	...s MXRowID=""
	...s DatalistMX=""
	...d FillOneContarctListData
	..e  d
	...s MXRowID=0
	...f  s MXRowID=$o(^DHCEQContractList(0,"Contract",rowid,MXRowID))  q:MXRowID=""  d
	....d FillOneContarctListData*/
	Quit $$$OK
FillOneContarctListData
	d ResetVariablesContarctListData
	s Datalist=$g(^DHCEQContract(rowid))
	i MXRowID'="" s DatalistMX=$g(^DHCEQContractList(MXRowID))
	d CheckContarctListData
	q:passed=0
	d SetVariablesContarctListData
	quit

CheckContarctListData
	s passed=0
	s TContractName = $p(Datalist,"^",1)
	i (ContractName'="")&&(TContractName'[ContractName) quit
	//s TContractNo = $p(Datalist,"^",2)
	//i (ContractNo'="")&&(TContractNo'[ContractNo) quit
	
	s TSignDate =$p(Datalist,"^",7)
	i (TSignDate'="")&((TSignDate>SignEndDate)||(TSignDate<SignBeginDate)) quit
	
	s TSignLocDR =$p(Datalist,"^",8)
	i (SignLocDR'="")&&(TSignLocDR'=SignLocDR) quit
	;q:((TSignLocDR'="")&&(##Class(web.DHCEQCommon).LocIsInEQ(QXType,TSignLocDR)))
	
	s TProviderDR =$p(Datalist,"^",18)
	i (ProviderDR'="")&&(TProviderDR'=ProviderDR) quit
	s TStatus= $p(Datalist,"^",24)
	//i (StatusDR'="")&&(TStatus'=StatusDR) quit
	i TStatus'=2 quit
	s TContractTypeDR =$p(Datalist,"^",39)
	//i TContractTypeDR=1 quit
	//i (ContractTypeDR'="")&&(TContractTypeDR'=ContractTypeDR) quit
	s TBuyTypeDR =$p(Datalist,"^",48)
	i (BuyTypeDR'="")&&(TBuyTypeDR'=BuyTypeDR) quit
	
	s TName=$p(DatalistMX,"^",2)
	i ((Name'="")&&(TName'[Name)) quit
	
	s TPrice=$p(DatalistMX,"^",6)
	i ((TPrice>ToOriginalFee)&&(ToOriginalFee'=""))||((TPrice<FromOriginalFee)&&(FromOriginalFee'="")) quit
	
	s passed=1
	quit
	
SetVariablesContarctListData
	s TRowID = rowid
	s TContractName = $p(Datalist,"^",1)
	s TContractNo = $p(Datalist,"^",2)
	s TSignDate = ##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",7),"date")
	s TSignLocDR = $p(Datalist,"^",8)
	s TSignLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TSignLocDR)
	s TPreFeeFee = ##Class(web.DHCEQCommon).FormatNumber($p(Datalist,"^",5),"")
	s TPayedTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p(Datalist,"^",6),"")
	s TDeliveryDate = ##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",9),"date")
	s TArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",10),"date")
	s TStartDate =##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",11),"date")
	s TEndDate =##Class(web.DHCEQCommon).TransValueToPage($p(Datalist,"^",12),"date")
	s TClaimPeriodNum = $p(Datalist,"^",13)
	s TService = $p(Datalist,"^",14)
	s TCheckStandard = $p(Datalist,"^",17)
	s TProviderDR = $p(Datalist,"^",18)
	s TProvider = ##class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	s TProviderTel = $p(Datalist,"^",19)
	s TProviderHandler = $p(Datalist,"^",20)
	s TBreakItem = $p(Datalist,"^",21)
	s TGuaranteePeriodNum = $p(Datalist,"^",23)
	s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay($p(Datalist,"^",24))
	s TArriveMonthNum = $p(Datalist,"^",35)
	s TServiceDR = $p(Datalist,"^",36)
	s TService = ##class(web.DHCEQCommon).GetTrakNameByID("cservice",TServiceDR)
	s TContractType=$p(Datalist,"^",39)
	s TContractType=##Class(web.DHCEQContractNew).GetContractType(TContractType)
	s TFileNo=$p(Datalist,"^",52)
	if MXRowID'=""
	{
		s TRowIDMX = MXRowID
		s TName=$p(DatalistMX,"^",2)
		s TPrice = ##Class(web.DHCEQCommon).FormatNumber($p(DatalistMX,"^",6),"")
		s TQuantityNum = $p(DatalistMX,"^",7)
		s TTotal = ##Class(web.DHCEQCommon).FormatNumber($p(DatalistMX,"^",8),"")
		s THold1 = ##Class(web.DHCEQCommon).FormatNumber($p(DatalistMX,"^",24),"")
		d OutputRowContarctListData
	}
	else
	{
		s TQuantityNum=0
		s TTotal=0
		s TRowIDMX=0
		f  s TRowIDMX = $o(^DHCEQContractList(0,"Contract",rowid,TRowIDMX)) q:TRowIDMX=""  d
		.s TQuantityNum=TQuantityNum+1
		.s TTotal=TTotal+$p($g(^DHCEQContractList(TRowIDMX)),"^",8)
		s TTotal = ##Class(web.DHCEQCommon).FormatNumber(TTotal,"")
		
		s TRowIDMX = $o(^DHCEQContractList(0,"Contract",rowid,0))
		i TRowIDMX'="" s TName=$p($g(^DHCEQContractList(TRowIDMX)),"^",2)
		s TPrice = ##Class(web.DHCEQCommon).FormatNumber(0,"")
		d OutputRowContarctListData
	}
	quit
	
OutputRowContarctListData
	s Data=$lb(TRowID,TContractName,TContractNo,TSignDate,TSignLocDR,TSignLoc,TPreFeeFee,TPayedTotalFee,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TCheckStandard,TProviderDR,TProvider,TProviderTel,TProviderHandler,TBreakItem,TGuaranteePeriodNum,TStatus,TArriveMonthNum,TServiceDR,TService,TContractType,TFileNo,TRowIDMX,TName,TPrice,TQuantityNum,TTotal,THold1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s ^DHCEQTemp("ContractList",curuser,gnum)=TContractName_"^"_TContractNo_"^"_TSignDate_"^"_TSignLoc_"^"_TPreFeeFee_"^"_TPayedTotalFee_"^"_TDeliveryDate_"^"_TArriveDate_"^"_TStartDate_"^"_TEndDate_"^"_TClaimPeriodNum_"^"_TService_"^"_TCheckStandard_"^"_TProvider_"^"_TProviderTel_"^"_TProviderHandler_"^"_TBreakItem_"^"_TGuaranteePeriodNum_"^"_TArriveMonthNum_"^"_TService_"^"_TContractType_"^"_TFileNo_"^"_TName_"^"_TPrice_"^"_TQuantityNum_"^"_TTotal_"^"_THold1
	s gnum=gnum+1
	quit
ResetVariablesContarctListData
	s (TRowID,TContractName,TContractNo,TSignDate,TSignLocDR,TSignLoc,TPreFeeFee,TPayedTotalFee,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TCheckStandard,TProviderDR,TProvider,TProviderTel,TProviderHandler,TBreakItem,TGuaranteePeriodNum,TStatus,TArriveMonthNum,TServiceDR,TService,TContractType,TFileNo,TRowIDMX,TName,TPrice,TQuantityNum,TTotal,THold1)=""
	quit
}

ClassMethod ContractListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ContractListExecute ]
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

ClassMethod ContractListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ContractListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 合同明细对应设备明细综合查询query
/// d ##Class(%ResultSet).RunQuery("web.DHCEQContractNew","ContractListEquip","1","33")
Query ContractListEquip(SourceType As %String = "", SourceID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TModel:%String,TUnit:%String,TEquipType:%String,TStatCat:%String,TEquiCat:%String,TUseLoc:%String,TOriginalFee:%String,TStatus:%String,TNo:%String,TLeaveFactoryNo:%String,TLocation:%String,TRentStatus:%String,TFaultStatus:%String,TAdvanceDisFlag:%String,TDisuseDate:%String,TUnusualRemark:%String,TFundsInfo:%String") [ SqlProc ]
{
}

ClassMethod ContractListEquipExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceID As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i SourceType=1
	{
		s ContractDR=$p($G(^DHCEQContractList(SourceID)),"^",1)
		s ContractType=$p($G(^DHCEQContract(ContractDR)),"^",39)
		if (ContractType=1)
		{
			s rowid=0
			f  s rowid=$o(^DHCEQContractList(0,"Contract",ContractDR,rowid))  q:rowid=""  d
			.s EquipID=$p($g(^DHCEQContractList(rowid)),"^",17)
			.s EquipData=$g(^DHCEQEquip(EquipID))
			.d BuildOneEquipData
		}
		else
		{
			if $Data(^DHCEQEquip(0,"ContractList",SourceID))
			{
				s EquipID=0
				f  s EquipID =$o(^DHCEQEquip(0,"ContractList",SourceID,EquipID)) q:EquipID=""  d
				.d BuildOneEquipData
			}
			else
			{
				
			}
		}
	}
	Quit $$$OK
	
BuildOneEquipData
	s EquipData=$g(^DHCEQEquip(EquipID))
	s TInvalidFlag = $p(EquipData,"^",59)
	q:TInvalidFlag'="N"
	s TStockStatus=$p(EquipData,"^",60)
	q:TStockStatus="0"
	
	s TRowID = EquipID
	s TName = $p(EquipData,"^",1)
	s TModel = ##Class(web.DHCEQCommon).GetTrakNameByID("model",$p(EquipData,"^",3))
	s TEquiCat = ##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",$p(EquipData,"^",4))
	s TUnit = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(EquipData,"^",5))
	s TLeaveFactoryNo = $p(EquipData,"^",10)
	s TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(EquipData,"^",19))
	s TOriginalFee = $p(EquipData,"^",27)
	s TStatus=##Class(web.DHCEQEquip).GetEquipStatusDisplay($p(EquipData,"^",38))
	s TEquipType = ##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",$p(EquipData,"^",63))
	s TNo=$p(EquipData,"^",71)
	s TLocation = ##Class(web.DHCEQCommon).GetTrakNameByID("location",$p(EquipData,"^",72))
	s TStatCat = ##Class(web.DHCEQCommon).GetTrakNameByID("statcat",$p(EquipData,"^",75))  //modify by wl 2019-9-2 参数修正
	s TRentStatus=$p(EquipData,"^",87)
	s TFaultStatus=$p(EquipData,"^",88)
	s TDisuseDate=##Class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",89),"date")
	s TAdvanceDisFlag=##Class(web.DHCEQChangeInfo).GetEquipUnusualStatus($p(EquipData,"^",93))
	s TUnusualRemark=$p($Get(^DHCEQEquip(TRowID,"OtherInfo")),"^",9)
	s TFundsInfo=##Class(web.DHCEQEquip).GetFundsInfo(TRowID)
	d OutputRowContractListEquip
	quit
OutputRowContractListEquip
	s Data=$lb(TRowID,TName,TModel,TUnit,TEquipType,TStatCat,TEquiCat,TUseLoc,TOriginalFee,TStatus,TNo,TLeaveFactoryNo,TLocation,TRentStatus,TFaultStatus,TAdvanceDisFlag,TDisuseDate,TUnusualRemark,TFundsInfo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesContractListEquip
	s (TRowID,TName,TModel,TUnit,TEquipType,TStatCat,TEquiCat,TUseLoc,TOriginalFee,TStatus,TNo,TLeaveFactoryNo,TLocation,TRentStatus,TFaultStatus,TAdvanceDisFlag,TDisuseDate,TUnusualRemark,TFundsInfo)=""
	quit
}

ClassMethod ContractListEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ContractListEquipExecute ]
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

ClassMethod ContractListEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ContractListEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetList(node As %Library.String = "", job, gnum, rows As %Library.String = "")
{
	s curuser=%session.Get("LOGON.USERID")
	s str=^DHCEQTemp("ContractList",curuser,gnum)
	if rows'=""
	{
		for i=1:1:rows-1
		{
			s str=str_$c(2)_^DHCEQTemp("ContractList",curuser,gnum+i)
		}
	}
 	//s str=^DHCEQTemp("Equip",+$H,$j,gnum)
  	q str
}

ClassMethod GetNum(node As %Library.String = "", job)
{
	s curuser=%session.Get("LOGON.USERID")
	s gnum=$o(^DHCEQTemp("ContractList",curuser,""),-1)
  	q gnum
}

}
