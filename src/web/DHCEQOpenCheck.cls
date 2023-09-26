Class web.DHCEQOpenCheck Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 211;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "OC_RowID";

Parameter SQLDESCRIPTION = "OC_RowID";

Parameter SQLROWID = "OC_RowID";

Query GetOpenCheck(ReplacesAD, ApproveRole, Type, WaitAD, EquipDR, ManuFactoryDR, ProviderDR, ManageLocDR, UseLocDR, StatusDR, StartDate, EndDate) As %Query(ROWSPEC = "TContractListDR:%String,TContractDR:%String,TContract:%String,TRowID:%String,TEquipDR:%String,TGroupDR:%String,TManageLocDR:%String,TUseLocDR:%String,TOpenState:%String,TCheckResultDR:%String,TCheckResultRemark:%String,TCheckUser:%String,TStatus:%String,TRemark:%String,TEquipCatDR:%String,TModelDR:%String,TModel:%String,TComputerFlag:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TAuditUserDR:%String,TOpenCheckDate:%String,TOpenCheckDate:%String,TEquip:%String,TGroup:%String,TManageLoc:%String,TUseLoc:%String,TCheckResult:%String,TEquipCat:%String,TManuFactoryDR:%String,TManuFactory:%String,TProviderDR:%String,TProvider:%String,TTestFlag:%String,TMedicalFlag:%String,TCheckDate:%String,TPackTypeDR:%String,TPackType:%String,TPackNum:%String,TStatcatDR:%String,TStatCat:%String,TApprovesetDR:%String")
{
}

ClassMethod GetOpenCheckExecute(ByRef qHandle As %Binary, ReplacesAD, ApproveRole, Type, WaitAD, EquipDR, ManuFactoryDR, ProviderDR, ManageLocDR, UseLocDR, StatusDR, StartDate, EndDate) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetOpenCheck
	Quit $$$OK
BuildDataGetOpenCheck
	if WaitAD'="on"
	{
		if ReplacesAD="on"
		{
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
			s CurUser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
			s ALRowID=0
			f  s ALRowID=$o(^DHCEQApproveList(0,"Role",ApproveType,ApproveRole,ALRowID)) q:ALRowID=""  d
			.s ADUser=$p(^DHCEQApproveList(ALRowID),"^",6)
			.q:ADUser=CurUser
			.s rowid=$p(^DHCEQApproveList(ALRowID),"^",2)
			.d ResetVariablesGetOpenCheck
			.d GetOneOpenCheck
		}
		else
		{
			f  s rowid=$o(^DHCEQOpenCheck(rowid))  quit:rowid=""  d
			.d ResetVariablesGetOpenCheck
			.d GetOneOpenCheck
		}
	}
	else
	{
		if Type="1"
		{
			f  s rowid=$o(^DHCEQOpenCheck(0,"ApproveRole",1,ApproveRole,rowid))  quit:rowid=""  d
			.d ResetVariablesGetOpenCheck
			.d GetOneOpenCheck
			s rowid=0
			s ApproveSet=0
			s ApproveFlow=0
			s ApproveFlowStep=""
			s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
			f  s ApproveSet=$o(^DHCEQCCode("DHCEQCApproveSet",0,"ApproveType",ApproveType,ApproveSet))  quit:ApproveSet=""  d
			.f   s ApproveFlow=$o(^DHCEQCCode("DHCEQCApproveFlow",0,"ApproveRole",ApproveSet,ApproveRole,ApproveFlow))  quit:ApproveFlow=""  d
			..s ApproveFowStep=$p(^DHCEQCCode("DHCEQCApproveFlow",ApproveFlow),"^",3)
			..f   s rowid=$o(^DHCEQOpenCheck(0,"ApproveSet",1,ApproveSet,ApproveFowStep,rowid))  quit:rowid=""  d
			...s Role=$p(^DHCEQOpenCheck(rowid),"^",27)
			...q:Role'=""
			...s Approved=##class(web.DHCEQCApproveSet).HasApprove(ApproveType, rowid, ApproveFowStep, ApproveRole)
			...q:Approved>0
			...d ResetVariablesGetOpenCheck
			...d GetOneOpenCheck
		}
		if Type="2"
		{
			s rowid=0
			s NextStep=""
			f  s rowid=$o(^DHCEQOpenCheck(0,"Status",1,rowid))  quit:rowid=""  d
			.s NextStep=$p($G(^DHCEQOpenCheck(rowid)),"^",28)
			.q:NextStep'=""
			.d ResetVariablesGetOpenCheck
			.d GetOneOpenCheck
		}
	}
	quit

GetOneOpenCheck
	s TRowID = rowid
	q:(ManuFactoryDR="")&&(EquipDR="")&&(ProviderDR="")&&(ManageLocDR="")&&(StartDate="")&&(EndDate="")&&(UseLocDR="")&&(StatusDR="")
	s TEquipDR = $p($g(^DHCEQOpenCheck(rowid)),"^",1)
	q:(EquipDR'="")&&(TEquipDR'=EquipDR)
	i TEquipDR '=""  d
	.//
	.s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TStatCatDR=$p($g(^DHCEQEquip(TEquipDR)),"^",75)
	.i TStatCatDR'="" s TStatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",TStatCatDR)),"^",2)
	.s TEquipCatDR = $p($g(^DHCEQEquip(TEquipDR)),"^",4)
	.i TEquipCatDR'="" s TEquipCat=$p($g(^DHCEQCCode("DHCEQCEquipeCat",TEquipCatDR)),"^",2)
	.s TModelDR = $p($g(^DHCEQEquip(TEquipDR)),"^",3)
	.i TModelDR'="" s TModel=$p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TLeaveFactoryNo = $p($g(^DHCEQEquip(TEquipDR)),"^",10)
	.s TLeaveFactoryDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(TEquipDR)),"^",11),"date")
	.s TOpenCheckDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(TEquipDR)),"^",12),"date")
	.s TComputerFlag=$p($g(^DHCEQEquip(TEquipDR)),"^",15)
	.s TManuFactoryDR=$p($g(^DHCEQEquip(TEquipDR)),"^",26)
	.i TManuFactoryDR'="" s TManuFactory=$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	.s TProviderDR=$p($g(^DHCEQEquip(TEquipDR)),"^",25)
	.i TProviderDR'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TTestFlag=$p($g(^DHCEQEquip(TEquipDR)),"^",48)
	.s TMedicalFlag=$p($g(^DHCEQEquip(TEquipDR)),"^",49)
	.s TCheckDate= ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQEquip(TEquipDR)),"^",13),"date")
	.s TContractListDR=$p($g(^DHCEQEquip(TEquipDR)),"^",32)
	.i TContractListDR'="" s TContractDR=$p($g(^DHCEQContractList(TContractListDR)),"^",1)
	.i TContractDR'="" s TContract=$p($g(^DHCEQContract(TContractDR)),"^",1)
	.//
	q:(ManuFactoryDR'="")&&(TManuFactoryDR'=ManuFactoryDR)
	q:(ProviderDR'="")&&(TProviderDR'=ProviderDR)
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$H
	q:($p($g(^DHCEQEquip(TEquipDR)),"^",12)>EndDate)||($p($g(^DHCEQEquip(TEquipDR)),"^",12)<StartDate)
	s TGroupDR = $p($g(^DHCEQOpenCheck(rowid)),"^",2)
	i TGroupDR '=""  d
	.s TGroup = $p($g(^DHCEQGroup(TGroupDR)),"^",2)
	s TManageLocDR = $p($g(^DHCEQOpenCheck(rowid)),"^",3)
	q:(ManageLocDR'="")&&(TManageLocDR'=ManageLocDR)
	i TManageLocDR '=""  d
	.s TManageLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TManageLocDR)
	s TUseLocDR = $p($g(^DHCEQOpenCheck(rowid)),"^",4)
	q:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	i TUseLocDR '=""  d
	.s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TOpenState = $p($g(^DHCEQOpenCheck(rowid)),"^",5)
	s TCheckResultDR = $p($g(^DHCEQOpenCheck(rowid)),"^",6)
	i TCheckResultDR '=""  d
	.s TCheckResult = $p($g(^DHCEQCCode("DHCEQCCheckResult",TCheckResultDR)),"^",2)
	s TCheckResultRemark = $p($g(^DHCEQOpenCheck(rowid)),"^",7)
	s TCheckUser = $p($g(^DHCEQOpenCheck(rowid)),"^",8)
	s TStatus = $p($g(^DHCEQOpenCheck(rowid)),"^",9)
	q:(StatusDR'="")&&(TStatus'=StatusDR)
	s TStatus=##Class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
	s TRemark = $p($g(^DHCEQOpenCheck(rowid)),"^",10)
	s TPackTypeDR = $p($g(^DHCEQOpenCheck(rowid)),"^",20)
	i TPackTypeDR '=""  d
	.s TPackType = $p($g(^DHCEQCCode("DHCEQCPackType",TPackTypeDR)),"^",2)
	s TPackNum = $p($g(^DHCEQOpenCheck(rowid)),"^",21)
	s TApprovesetDR=$p($g(^DHCEQOpenCheck(rowid)),"^",26)
	d OutputRowGetOpenCheck
	quit
OutputRowGetOpenCheck
	s Data=$lb(TContractListDR,TContractDR,TContract,TRowID,TEquipDR,TGroupDR,TManageLocDR,TUseLocDR,TOpenState,TCheckResultDR,TCheckResultRemark,TCheckUser,TStatus,TRemark,TEquipCatDR,TModelDR,TModel,TComputerFlag,TLeaveFactoryNo,TLeaveFactoryDate,TAuditUserDR,TOpenCheckDate,TOpenCheckDate,TEquip,TGroup,TManageLoc,TUseLoc,TCheckResult,TEquipCat,TManuFactoryDR,TManuFactory,TProviderDR,TProvider,TTestFlag,TMedicalFlag,TCheckDate,TPackTypeDR,TPackType,TPackNum,TStatCatDR,TStatCat,TApprovesetDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetOpenCheck
	s (TPackTypeDR,TPackType,TPackNum,TContractListDR,TContractDR,TContract,TRowID,TEquipDR,TGroupDR,TManageLocDR,TUseLocDR,TOpenState,TCheckResultDR,TCheckResultRemark,TCheckUser,TStatus,TRemark,TEquipCatDR,TModelDR,TModel,TComputerFlag,TLeaveFactoryNo,TLeaveFactoryDate,TAuditUserDR,TOpenCheckDate,TOpenCheckDate,TEquip,TGroup,TManageLoc,TUseLoc,TCheckResult,TEquipCat,TManuFactoryDR,TManuFactory,TProviderDR,TProvider,TTestFlag,TMedicalFlag,TCheckDate,TStatCatDR,TStatCat,TApprovesetDR)=""
	quit
}

ClassMethod GetOpenCheckFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOpenCheckExecute ]
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

ClassMethod GetOpenCheckClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOpenCheckExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetArriveTotalNum(CID)
{
	s Num=0
	s CLID=0
	f  s CLID=$o(^DHCEQContractList(0,"Contract",CID,CLID)) q:CLID=""  d
	.s ArriveNum=$P(^DHCEQContractList(CLID),"^",12)
	.i ArriveNum="" s ArriveNum=0
	.s Num=Num+ArriveNum
	q Num
}

Query GetContract(Contract) As %Query(ROWSPEC = "ContractName:%String,HIDDEN:%String,ContractNo:%String,QuantityNum:%String,TArriveNum:%String,SignDate:%String,Remark:%String,SignLoc:%String,Provider:%String")
{
}

ClassMethod GetContractExecute(ByRef qHandle As %Binary, Contract) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetContract
	Quit $$$OK
BuildDataGetContract
	f  s rowid=$o(^DHCEQContract(rowid))  quit:rowid=""  d
	.d ResetVariablesGetContract
	.s TRowID = rowid
	.s TContractName = $p($g(^DHCEQContract(rowid)),"^",1)
	.q:(Contract'="")&&(TContractName'[Contract)
	.s TContractNo = $p($g(^DHCEQContract(rowid)),"^",2)
	.s TQuantityNum = $p($g(^DHCEQContract(rowid)),"^",3)
	.s TArriveNum=..GetArriveTotalNum(rowid)
	.q:TArriveNum'<TQuantityNum
	.i TArriveNum=0 s TArriveNum=""
	.s TSignDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContract(rowid)),"^",7),"date")
	.s TSignLocDR = $p($g(^DHCEQContract(rowid)),"^",8)
	.i TSignLocDR '=""  d
	..s TSignLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",TSignLocDR)
	.s TProviderDR = $p($g(^DHCEQContract(rowid)),"^",18)
	.i TProviderDR '=""  d
	..s TProvider = ##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProviderDR)
	.s TStatus = $p($g(^DHCEQContract(rowid)),"^",24)
	.q:TStatus'="2"
	.s TRemark = $p($g(^DHCEQContract(rowid)),"^",25)
	.d OutputRowGetContract
	quit
OutputRowGetContract
	s Data=$lb(TContractName,TRowID,TContractNo,TQuantityNum,TArriveNum,TSignDate,TRemark,TSignLoc,TProvider)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContract
	s (TSignLocDR,TProviderDR,TStatus,TRowID,TContractName,TContractNo,TQuantityNum,TArriveNum,TSignDate,TRemark,TSignLoc,TProvider)=""
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

Query GetContractList(ContractDR) As %Query(ROWSPEC = "TName:%String,HIDDEN:%String,TTestFlag:%String,TModel:%String,TManuFac:%String")
{
}

ClassMethod GetContractListExecute(ByRef qHandle As %Binary, ContractDR) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetContractList
	Quit $$$OK
BuildDataGetContractList
	q:ContractDR=""
	f  s rowid=$o(^DHCEQContractList(0,"Contract",ContractDR,rowid))  quit:rowid=""  d
	.d ResetVariablesGetContractList
	.s TRowID = rowid
	.s TContractDR = $p($g(^DHCEQContractList(rowid)),"^",1)
	.q:(ContractDR'="")&&(TContractDR'=ContractDR)
	.i TContractDR '=""  d
	..s TContract = $p($g(^DHCEQContract(TContractDR)),"^",1)
	..s TStatus = $p($g(^DHCEQContract(TContractDR)),"^",24)
	.q:TStatus'="2"
	.s TName = $p($g(^DHCEQContractList(rowid)),"^",2)
	.s TModelDR = $p($g(^DHCEQContractList(rowid)),"^",3)
	.i TModelDR '=""  d
	..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
	.s TManuFacDR = $p($g(^DHCEQContractList(rowid)),"^",4)
	.i TManuFacDR '=""  d
	..s TManuFac = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFacDR)),"^",1)
	.s TTestFlag = $p($g(^DHCEQContractList(rowid)),"^",5)
	.s ArriveNum=..GetArriveNum("","",rowid)
	.q:ArriveNum'>0
	.d OutputRowGetContractList
	quit
OutputRowGetContractList
	s Data=$lb(TName,TRowID,TTestFlag,TModel,TManuFac)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractList
	s (TStatus,TRowID,TContractDR,TName,TModelDR,TManuFacDR,TTestFlag,TPriceFee,TQuantityNum,TTotalFee,TRemark,TContractArriveDate,TArriveDate,TArriveQuantityNum,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TContract,TModel,TManuFac,TUpdateUser,TCurrency)=""
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

Query GetStatus(Type, CancelOper As %String = "") As %Query(ROWSPEC = "Status:%String:状态,ID:%String:编码")
{
}

ClassMethod GetStatusExecute(ByRef qHandle As %Binary, Type, CancelOper As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	//s rowid=0
	d BuildDataGetStatus
	Quit $$$OK
BuildDataGetStatus
	i CancelOper="Y" 	//modified by CZF0088 增加作废状态 1215414 begin
	{
		s ID="2"
		s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay(ID)
		d OutputRowGetStatus
		s ID="3"
		s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay(ID)
		d OutputRowGetStatus
	}
	else
	{
		i Type'="1" d
		.s ID="0"
		.s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay(ID)
		.d OutputRowGetStatus
		s ID="1"
		s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay(ID)
		d OutputRowGetStatus
		s ID="2"
		s Status=##Class(web.DHCEQCommon).GetEditStatusDisplay(ID)
		d OutputRowGetStatus
	}		//modified by CZF0088 增加作废状态 1215414 end
	quit
OutputRowGetStatus
	s Data=$lb(Status,ID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetStatus
	s (Status,ID)=""
	quit
}

ClassMethod GetStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetStatusExecute ]
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

ClassMethod GetStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetStatusExecute ]
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
	s (StatCatDR,StatCat)="" //2009-11-25 党军 DJ0037
	s ModelDR=$p($G(^DHCEQContractList(ContractListDR)),"^",3)
	i ModelDR'="" s Model=$p($G(^DHCEQCCode("DHCEQCModel",ModelDR)),"^",2)
	s ContractDR=$p($G(^DHCEQContractList(ContractListDR)),"^",1)
	s ProviderDR=$p($G(^DHCEQContract(ContractDR)),"^",18)
	i ProviderDR'="" s Provider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	s ManuFactoryDR=$p($G(^DHCEQContractList(ContractListDR)),"^",4)
	i ManuFactoryDR'="" s ManuFactory=$p($G(^DHCEQCCode("DHCEQCManufacturer",ManuFactoryDR)),"^",1)
	s TestFlag=$p($G(^DHCEQContractList(ContractListDR)),"^",5)
	s PriceFee=$p($G(^DHCEQContractList(ContractListDR)),"^",6)
	s BuyPlanListDR=$p($G(^DHCEQContractList(ContractListDR)),"^",17)
	s ItemDR=$p($G(^DHCEQContractList(ContractListDR)),"^",18)
	i ItemDR'="" d
	.s UnitDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",7)
	.s Code=$P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",2)
	.s StatCatDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",5) //2009-11-25 党军 DJ0037
	.i StatCatDR'="" s StatCat=$p($g(^DHCEQCCode("DHCEQCStatCat",StatCatDR)),"^",2) //2009-11-25 党军 DJ0037
	i UnitDR'="" s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",UnitDR)
	s ProviderHandler=$P($G(^DHCEQContract(ContractDR)),"^",20)
	s ProviderTel=$P($G(^DHCEQContract(ContractDR)),"^",19)
	s ServiceHandler=$P($G(^DHCEQContract(ContractDR)),"^",37)
	s ServiceTel=$P($G(^DHCEQContract(ContractDR)),"^",38)
	///Modified 2007-02-27
	i BuyPlanListDR'="" d
	.s BuyPlanID=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",1)
	.s UrgencyFlag=$P($G(^DHCEQBuyPlan(BuyPlanID)),"^",33)
	.s EquipTypeDR=$P($G(^DHCEQBuyPlan(BuyPlanID)),"^",12)
	.i EquipTypeDR'="" s EquipType=$P($G(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s PurchaseTypeDR=$P($G(^DHCEQBuyPlan(BuyPlanID)),"^",28)
	.i PurchaseTypeDR'="" s PurchaseType=$P($G(^DHCEQCCode("DHCEQCPurchaseType",PurchaseTypeDR)),"^",2)
	.s PurposeTypeDR=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",20)
	.i PurposeTypeDR'="" s PurposeType=$P($G(^DHCEQCCode("DHCEQCPurposeType",PurposeTypeDR)),"^",2)
	.s EquipCatDR=$P($G(^DHCEQBuyPlanList(BuyPlanListDR)),"^",16)
	.i EquipCatDR'="" s EquipCat=$P($G(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR)),"^",2)
	e  i ItemDR'="" d
	.s EquipTypeDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",3)
	.i EquipTypeDR'="" s EquipType=$P($G(^DHCEQCCode("DHCEQCEquipType",EquipTypeDR)),"^",2)
	.s EquipCatDR=$P($G(^DHCEQCCode("DHCEQCMasterItem",ItemDR)),"^",4)
	.i EquipCatDR'="" s EquipCat=$P($G(^DHCEQCCode("DHCEQCEquipeCat",EquipCatDR)),"^",2)
	///end 
	s ServiceDR=$p($G(^DHCEQContract(ContractDR)),"^",36)
	i ServiceDR'="" s Service=$P($G(^DHCEQCCode("DHCEQCService",ServiceDR)),"^",1)
	s Return=""
	s Return=Return_ContractListDR_"^"_ContractDR_"^"_ModelDR_"^"_Model_"^"_ManuFactoryDR_"^"_ManuFactory_"^"_ProviderDR_"^"_Provider_"^"_TestFlag
	s Return=Return_"^"_PriceFee_"^"_ProviderHandler_"^"_ProviderTel_"^"_UrgencyFlag_"^"_EquipTypeDR
	s Return=Return_"^"_EquipType_"^"_PurchaseTypeDR_"^"_PurchaseType_"^"_PurposeTypeDR_"^"_PurposeType
	s Return=Return_"^"_ServiceDR_"^"_Service_"^"_ServiceHandler_"^"_ServiceTel_"^"_ItemDR_"^"_EquipCatDR_"^"_EquipCat_"^"_UnitDR_"^"_Unit_"^"_Code
	s Return=Return_"^"_StatCatDR_"^"_StatCat //2009-11-25 党军 DJ0037
	q Return
}

ClassMethod UpdateOpenCheck(itmjs As %Library.String = "", itmjsex As %Library.String = "", OCRowID, val, AppType, EquipDR, TranFlag)
{
	//+AppType=0更新，插入
	//+AppType=1提交
	//+AppType=2审核
	//+AppType=3删除
	//+AppType=4反提交
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("7")
	if +AppType=0 
	{
		s PLIST(1) = $p(val,"^",1)     ;RowID
 		s PLIST(2) = $p(val,"^",2)     ;EquipDR
 		s PLIST(3) = $p(val,"^",3)     ;GroupDR
 		s PLIST(4) = $p(val,"^",4)     ;ManageLocDR
 		s PLIST(5) = $p(val,"^",5)     ;UseLocDR
 		s PLIST(6) = $p(val,"^",6)     ;OpenState
 		s PLIST(7) = $p(val,"^",7)     ;CheckResultDR
 		s PLIST(8) = $p(val,"^",8)     ;CheckResultRemark
 		s PLIST(9) = $p(val,"^",9)     ;CheckUser
 		s PLIST(10) = +AppType //$p(val,"^",10)   ;Status
 		s PLIST(11) = $p(val,"^",11)   ;Remark
 		s PLIST(21) = $p(val,"^",38)   ;PackType
 		s PLIST(22) = $p(val,"^",39)   ;PackNum
 		s PLIST(32) = $p(val,"^",37)	;Name
 		s PLIST(33) = $p(val,"^",13)	;ModelDR
 		s PLIST(34) = $p(val,"^",16)	;EquiCatDR
 		s PLIST(35) = $p(val,"^",15)	;UnitDR
 		s PLIST(36) = $p(val,"^",41)	;Code
 		s PLIST(37) = $p(val,"^",50)	;ItemDR
 		s PLIST(38) = $p(val,"^",21)	;LeaveFactoryNo
 		s PLIST(39) = $p(val,"^",22)	;LeaveFactoryDate
 		i $p(val,"^",22)'=""  s PLIST(39) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"date")	;LeaveFactoryDate
 		s PLIST(40) = $p(val,"^",33)	;OpenCheckDate
 		i $p(val,"^",33)'=""  s PLIST(40) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",33),"date")	;OpenCheckDate
 		s PLIST(41) = $p(val,"^",20)	;CountryDR
 		s PLIST(42) = $p(val,"^",28)	;OriginDR
 		s PLIST(43) = $p(val,"^",29)	;FromDeptDR
 		s PLIST(44) = $p(val,"^",23)	;ProviderDR
 		s PLIST(45) = $p(val,"^",14)	;ManuFactoryDR
 		s PLIST(46) = $p(val,"^",26)	;OriginalFee
 		s PLIST(47) = $p(val,"^",26)	;NetFee
 		s PLIST(48) = $p(val,"^",43)	;EquipTypeDR
 		s PLIST(49) = $p(val,"^",44)	;PurchaseTypeDR
 		s PLIST(50) = $p(val,"^",51)	;StatCatDR
 		
 		s PLIST(51) = $p(val,"^",52)	;Hold1
 		s PLIST(52) = $p(val,"^",53)	;Hold2
 		s PLIST(53) = $p(val,"^",54)	;Hold3
 		s PLIST(54) = $p(val,"^",55)	;Hold4
 		s PLIST(55) = $p(val,"^",56)	;Hold5
 		
 		s RowID=PLIST(1)
 		k PLIST(1)
 		s PI(2) = $p(val,"^",37)	;Name
		s PI(4) = $p(val,"^",13)	;ModelDR
 		s PI(5) = $p(val,"^",16)	;EquiCatDR
 		s PI(6) = $p(val,"^",15)	;UnitDR
 		s PI(11) = $p(val,"^",21)	;LeaveFactoryNo
 		s PI(12) = $p(val,"^",22)
 		i $p(val,"^",22)'=""  s PI(12) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",22),"date")	;LeaveFactoryDate
 		s PI(13) = $p(val,"^",33)
 		i $p(val,"^",33)'=""  s PI(13) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",33),"date")	;OpenCheckDate
 		s PI(16) = $p(val,"^",17)
 		i $p(val,"^",17)'=""  s PI(16) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"bool")	;ComputerFlag 
 		s PI(17) = $p(val,"^",20)	;CountryDR
 		s PI(18) = $p(val,"^",4)	;ManageLocDR
 		s PI(19) = $p(val,"^",31)	;ManageLevelDR
 		s PI(20) = $p(val,"^",5)	;UseLocDR
 		s PI(21) = $p(val,"^",28)	;OriginDR
 		s PI(22) = $p(val,"^",29)	;FromDeptDR
		s PI(24) = $p(val,"^",30)	;BuyTypeDR
 		s PI(25) = $p(val,"^",32)	;EquipTechLevelDR 
 		s PI(26) = $p(val,"^",23)	;ProviderDR
 		s PI(27) = $p(val,"^",14)	;ManuFactoryDR
 		s PI(28) = $p(val,"^",26)	;OriginalFee
 		s PI(29) = $p(val,"^",26)	;NetFee
		s PI(31) = $p(val,"^",3)	;GroupDR
		s PI(33) = $p(val,"^",12)	;ContractListDR
		s PI(39)=0 ;Status
		s PI(42) = $p(val,"^",24)	;ContactUser
 		s PI(43) = $p(val,"^",25)	;ContactMode
		s PI(47) = $p(val,"^",34)
 		i $p(val,"^",34)'=""  s PI(47) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",34),"bool")	;GuaranteeFlag
 		s PI(48) = "N"
 		s PI(49) = $p(val,"^",19)
 		i $p(val,"^",19)'=""  s PI(49) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",19),"bool")	;TestFlag
 		s PI(50) = $p(val,"^",18)
 		i $p(val,"^",18)'=""  s PI(50) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",18),"bool")	;MedicalFlag
 		s PI(51) = $p(val,"^",35)
 		i $p(val,"^",35)'=""  s PI(51) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",35),"date")	;GuaranteeStartDate
		s PI(52) = $p(val,"^",36)
 		i $p(val,"^",36)'=""  s PI(52) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",36),"date")	;GuaranteeEndDate 
 		s PI(72) = $p(val,"^",40) //Code------------
 		s PI(7) = $p(val,"^",41) //MemeryCode-----------------
 		s PI(63) = $p(val,"^",42) //UrgencyFlag
 		i $p(val,"^",42)'=""  s PI(63) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",42),"bool")
 		s PI(64) = $p(val,"^",43) //EquipType
 		s PI(65) = $p(val,"^",44) //PurchaseTypeDR
 		s PI(66) = $p(val,"^",45) //PurposeTypeDR
 		s PI(67) = $p(val,"^",46) //keeperDR
 		s PI(70) = $p(val,"^",47) //ServiceDR
 		s PI(73) = $p(val,"^",48) //ServiceHandler
 		s PI(74) = $p(val,"^",49) //ServiceTel
 		s PI(8) = $p(val,"^",50) //ItemDR
 		s PI(76) = $p(val,"^",51) //StatCatDR
 		s PI(60) = "Y"
 		if RowID=""
 		{
	 		s PLIST(12)=User
	 		s PLIST(13)=Date
	 		s PLIST(14)=Time
	 		s PI(53)=PLIST(12)
	 		s PI(54)=PLIST(13)
	 		s PI(55)=PLIST(14)
	 		;s PI(72) = ##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQEquip")
	 		TSTART
	 		&sql(insert into sqluser.DHC_EQEquip values :PI())
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
	 		i PI(72)=""
	 		{
		 		s updateNo= ##CLASS(web.DHCEQEquip).UpdateEquipNo(ID,Date)
	 			i updateNo'=0 
	 			{
		 			TRollBack
		 			q updateNo
				}
		 	}
		 	if PI(33)'=""
		 	{
	 			s SQLCODE=..InsertAffixByContract(ID,PI(33))
	 			if SQLCODE<0
	 			{
		 			TROLLBACK
		 			q SQLCODE
	 			}
		 	}
	 		s PLIST(2)=ID
	 		&sql(insert into sqluser.DHC_EQOpenCheck values :PLIST())
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
	 		TCOMMIT
	 		q ID_"^"_PLIST(2)
 		}
 		else
 		{
	 		s PLIST(15)=User
	 		s PLIST(16)=Date
	 		s PLIST(17)=Time
	 		s PI(56)=PLIST(15)
	 		s PI(57)=PLIST(16)
	 		s PI(58)=PLIST(17)
	 		TSTART
	 		&sql(update sqluser.DHC_EQOpenCheck values :PLIST() where OC_RowID=:RowID)
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		s ID=$G(%ROWID)
	 		&sql(update sqluser.DHC_EQEquip values :PI() where EQ_RowID=:PLIST(2))
	 		if SQLCODE
	 		{
		 		TROLLBACK
		 		q SQLCODE
	 		}
	 		TCOMMIT
	 		q ID_"^"_PLIST(2)
 		}
		
	}
	if +AppType=1
	{
		s PLIST(10)=+AppType
		s EquipType=$P(^DHCEQOpenCheck(OCRowID),"^",47)
	 	s PurchaseType=$P(^DHCEQOpenCheck(OCRowID),"^",48)
	 	s YearFlag=""
	 	s MaxPrice=$P(^DHCEQOpenCheck(OCRowID),"^",45)
	 	s SpecialType=..GetSpecialType(OCRowID)
	 	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, EquipType, PurchaseType, SpecialType, MaxPrice,YearFlag)
	 	i ApproveSet="" q -4007
	 	TSTART
	 	s SQLCODE=##class(web.DHCEQApproveList).DeleteApproveList(ApproveSet,OCRowID,"7",User)
	 	i SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
	 	
	 	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, OCRowID, 0, "")
	 	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
		s LastFlag=$P(ApproveFlow,"^",1)
	 	s NextStep=$P(ApproveFlow,"^",2)
	 	s NextRole=$P(ApproveFlow,"^",3)
	 	i AutoAuditFlag="Y"
	 	{
		 	i NextStep="" s PLIST(10)="2"
		 	i LastFlag="Y" s PLIST(10)="2"
		 	i (NextStep="")||(LastFlag="Y")
		 	{
			 	s EquipID=$P(^DHCEQOpenCheck(OCRowID),"^",1)
			 	s ContractList=$P(^DHCEQEquip(EquipID),"^",32)
		 		s SQLCODE=..UpdateOpenCheck("","", OCRowID, ContractList, "2", EquipID,"N")
	 			if SQLCODE<0
	 			{
		 			TROLLBACK
		 			q SQLCODE
	 			}
		 	}
	 	}
	 	s PLIST(27)=ApproveSet
	 	s PLIST(28)=NextRole
	 	s PLIST(29)=NextStep
	 	s PLIST(30)=""
	 	s PLIST(31)=""
		&sql(update sqluser.DHC_EQOpenCheck values :PLIST() where OC_RowID=:OCRowID)
		s ID=$G(%ROWID)
		if SQLCODE
	 	{
			TROLLBACK
			q SQLCODE
	 	}
	 	TCOMMIT
	 	q ID
	}
	if +AppType=2
	{
		s PLIST(10)=+AppType
		s PLIST(18)=User
	 	s PLIST(19)=Date
	 	s PLIST(20)=Time
	 	s PLIST(61)="0"
	 	s PI(60)="N"
	 	s PI(56)=PLIST(18)
	 	s PI(57)=PLIST(19)
	 	s PI(58)=PLIST(20)
	 	s PI(61)="0"
	 	s ContractListDR=val
	 	i TranFlag="Y" TSTART
	 	if ContractListDR'=""
	 	{
	 		&sql(update sqluser.DHC_EQContractList set CTL_ArriveQuantityNum=CTL_ArriveQuantityNum+1 where CTL_RowID=:val)
	 		if SQLCODE
	 		{
			 	i TranFlag="Y" TROLLBACK
			 	q SQLCODE
	 		}
	 		s BPLID=$p(^DHCEQContractList(ContractListDR),"^",17)
	 		if (BPLID'="")
	 		{
	 			s SQLCODE=..UpdateBPLArriveNum(1,BPLID)
	 			if SQLCODE
	 			{
			 		i TranFlag="Y" TROLLBACK
			 		q -1001
	 			}
	 		}
	 	}
	 	&sql(update sqluser.DHC_EQEquip values :PI() where EQ_RowID=:EquipDR)
	 	if SQLCODE
	 	{
		 	i TranFlag="Y" TROLLBACK
		 	q SQLCODE
	 	}
		&sql(update sqluser.DHC_EQOpenCheck values :PLIST() where OC_RowID=:OCRowID)
		s ID=$G(%ROWID)
		if SQLCODE
	 	{
			i TranFlag="Y" TROLLBACK
			q SQLCODE
	 	}
	 	i TranFlag="Y" TCOMMIT
	 	q ID
	}
	if +AppType=3
	{
		TSTART
	 	&sql(update sqluser.DHC_EQEquip set EQ_InvalidFlag='Y' where EQ_RowID=:EquipDR)
	 	if SQLCODE
	 	{
		 	TROLLBACK
		 	q SQLCODE
	 	}
		&sql(delete from sqluser.DHC_EQOpenCheck where OC_RowID=:OCRowID)
		s ID=$G(%ROWID)
		if SQLCODE
	 	{
			TROLLBACK
			q SQLCODE
	 	}
	 	TCOMMIT
	 	q ""
	}
	if +AppType=4
	{
		s PLIST(10)="0"
	 	s PLIST(23)=val
	 	s PLIST(24)=User
	 	s PLIST(25)=Date
	 	s PLIST(26)=Time
	 	TSTART
	 	&sql(update sqluser.DHC_EQOpenCheck values :PLIST() where OC_ROWID=:OCRowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	TCOMMIT
	 	q OCRowID
	}
	if +AppType=5
	{
		s PLIST(31)=$p(val,"^",1)  //Role
		s PLIST(30)=$p(val,"^",2)  //Step
		s Opinion=$p(val,"^",3)  //Opinion
		s Remark=$p(val,"^",4)
		s ApproveSet=$P(^DHCEQOpenCheck(OCRowID),"^",26)
		s NextApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, OCRowID, PLIST(30), PLIST(31))
 		s LastFlag=$p(NextApproveFlow,"^",1)
 		s PLIST(29)=$p(NextApproveFlow,"^",2)  //NextStep
 		s PLIST(28)=$p(NextApproveFlow,"^",3)  //NextRole
 		s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
 		TSTART
 		i AutoAuditFlag="Y"
	 	{
		 	i PLIST(29)="" s PLIST(10)="2"
		 	i LastFlag="Y" s PLIST(10)="2"
		 	i (PLIST(29)="")||(LastFlag="Y")
		 	{
		 		s EquipID=$P(^DHCEQOpenCheck(OCRowID),"^",1)
			 	s ContractList=$P(^DHCEQEquip(EquipID),"^",32)
		 		s SQLCODE=..UpdateOpenCheck("","", OCRowID, ContractList, "2", EquipID,"N")
	 			if SQLCODE<0
	 			{
		 			TROLLBACK
		 			q SQLCODE
	 			}
		 	}
	 	}
	 	s SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType, OCRowID, Opinion, Remark, PLIST(31), PLIST(30))
		if SQLCODE
		{
	 		TROLLBACK
			q SQLCODE
		}
	 	&sql(update sqluser.DHC_EQOpenCheck values :PLIST() where OC_ROWID=:OCRowID)
	 	if SQLCODE
	 	{
		 	TROLLBACK
			q SQLCODE
	 	}
	 	TCOMMIT
	 	q OCRowID
	}
}

ClassMethod GetSpecialType(OCID)
{
	s SpecialType=""
	s EquipCat=$P(^DHCEQOpenCheck(OCID),"^",33)
	i EquipCat'="" s SpecialType=$P(^DHCEQCCode("DHCEQCEquipeCat",EquipCat),"^",5)
	i SpecialType'="" q SpecialType
	q 0
}

ClassMethod UpdateBPLArriveNum(Num, BPLID)
{
	s ArriveNum=$p(^DHCEQBuyPlanList(BPLID),"^",17)
	s ExecNum=$p(^DHCEQBuyPlanList(BPLID),"^",7)
	i ArriveNum="" s ArriveNum=0
	s Num=Num+ArriveNum
	i Num>ExecNum q ExecNum-Num
	&SQL(update sqluser.DHC_EQBuyPlanList set BPL_ArriveNum=:Num where BPL_RowID=:BPLID)
	q SQLCODE
}

ClassMethod InsertAffixByContract(EquipID, ContractListID)
{
	new User,Date,Time
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	&SQL(Insert Into SQLUser.DHC_EQAffix (AF_EquipDR,AF_AffixDR,AF_AffixCatDR,AF_PartSpec,AF_PartModel,AF_ManuFactoryDR,AF_QuantityNum,AF_ReceiverDR,AF_LeaveFacNo,AF_LeaveDate,AF_PriceFee,AF_Remark,AF_CurrencyDR,AF_DisuseFlag,AF_InvalidFlag,AF_UpdateUserDR,AF_UpdateDate,AF_UpdateTime) 
	select :EquipID,CA_AffixDR,CA_AffixCatDR,CA_PartSpec,CA_PartModel,CA_ManuFactoryDR,CA_QuantityNum,CA_ReceiverDR,CA_LeaveFacNo,CA_LeaveDate,CA_PriceFee,CA_Remark,CA_CurrencyDR,'N','N',:User,:Date,:Time from SQLUser.DHC_EQContractAffix where CA_ContractListDR=:ContractListID)
	q SQLCODE
}

ClassMethod GetArriveNum(itmjs As %Library.String = "", itmjsex As %Library.String = "", ContractListDR)
{
	s Num=$p($G(^DHCEQContractList(ContractListDR)),"^",7)
	s ArrNum=$p($G(^DHCEQContractList(ContractListDR)),"^",12)
	i ArrNum="" s ArrNum=0
	q Num-ArrNum
}

ClassMethod GetOneOpenCheck(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid)
{
	new result,resultex,Equip,ContractDR,Contract,ContractNo
	s ContractDR=""
	s Contract=""
	s ContractNo=""
	s (result,resultex)=""
	s result= ^DHCEQOpenCheck(rowid)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	.s ContractListDR=$p($g(^DHCEQEquip($p(result,"^",1))),"^",32)
	.i ContractListDR'="" d
	..s ContractDR=$p($g(^DHCEQContractList(ContractListDR)),"^",1)
	..i ContractDR'=""  d
	...s Contract=$p($g(^DHCEQContract(ContractDR)),"^",1)
	...s ContractNo=$p($g(^DHCEQContract(ContractDR)),"^",2)
	s resultex=resultex_"^"	;GroupDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQGroup($p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",3))
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",4))
	s resultex=resultex_"^"	;CheckResultDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCCheckResult",$p(result,"^",6))),"^",2)
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",11))
	s $p(result,"^",12)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",14))
	s $p(result,"^",15)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"date")	;UpdateDate
	s resultex=resultex_"^"	;AuditUserDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",17))
	s $p(result,"^",18)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"date")    ;AuditDate
	s resultex=resultex_"^"	;PackTypeDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPackType",$p(result,"^",20))),"^",2)
	s resultex=resultex_"^"	;RejectUserDR
	i $p(result,"^",23)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",23))
	s $p(result,"^",24)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",24),"date")	;RejectDate
	s resultex=resultex_"^"	;ApproveSetDR
	s resultex=resultex_"^"	;NextRoleDR
	//i $p(result,"^",27)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQCApproveRole($p(result,"^",27))),"^",XX)
	s resultex=resultex_"^"	;ApproveRoleDR
	//i $p(result,"^",30)'=""  d
	//.s resultex=resultex_$p($g(^DHCEQCApproveRole($p(result,"^",30))),"^",XX)
	s resultex=resultex_"^"	;ModelDR
	i $p(result,"^",32)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",32))),"^",2)
	s resultex=resultex_"^"	;EquiCatDR
	i $p(result,"^",33)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",33))),"^",2)
	s resultex=resultex_"^"	;UnitDR
	i $p(result,"^",34)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",34))
	s resultex=resultex_"^"	;ItemDR
	i $p(result,"^",36)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCMasterItem",$p(result,"^",36))),"^",2)
	s $p(result,"^",38)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",38),"date")	;LeaveFactoryDate
	s $p(result,"^",39)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",39),"date")	;OpenCheckDate
	s resultex=resultex_"^"	;CountryDR
	i $p(result,"^",40)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cou",$p(result,"^",40))
	s resultex=resultex_"^"	;OriginDR
	i $p(result,"^",41)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",41))),"^",2)
	s resultex=resultex_"^"	;FromDeptDR
	i $p(result,"^",42)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",42))),"^",2)
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",43)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",43))
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",44)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",44))),"^",1)
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",47)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",47))),"^",2)
	s resultex=resultex_"^"	;PurchaseTypeDR
	i $p(result,"^",48)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",$p(result,"^",48))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",49)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",49))),"^",2)
	s resultex=resultex_"^"_ContractDR_"^"_Contract_"^"_ContractNo
	
	//add by jdl 2009-9-25  JDL0036
	//格式化金额为小数点两位
	i $p(result,"^",45)'="" s $p(result,"^",45)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",45),"",2)	;OriginalFee
	i $p(result,"^",46)'="" s $p(result,"^",46)=##Class(web.DHCEQCommon).FormatNumber($p(result,"^",46),"",2)	;NetFee
	
	s result=result_resultex
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
	/*i $p(result,"^",1)'=""  d
	.s Equip=^DHCEQEquip($p(result,"^",1))
	.s resultex=resultex_"^"
	.s resultex=resultex_$p(Equip,"^",3) ;ModelDR
	.s resultex=resultex_"^"
	.i $p(Equip,"^",3)'="" s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(Equip,"^",3))),"^",2) ;Model
	.s resultex=resultex_"^"
	.s resultex=resultex_$p(Equip,"^",5) ;UnitDR
	.s resultex=resultex_"^"
	. i $p(Equip,"^",5)'="" d
	..s UnitDR=$p($g(^DHCEQCCode("DHCEQCUOM",$p(Equip,"^",5))),"^",1) ;UnitDR 
	..s resultex=resultex_$p($g(^CT("UOM",UnitDR)),"^",2) ;Unit 
	.s resultex=resultex_"^"
	.s resultex=resultex_$p(Equip,"^",4) ;EquipCatDR
	.s resultex=resultex_"^"
	.i $p(Equip,"^",4)'="" s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(Equip,"^",4))),"^",2) ;EquipCat
	*/
}

ClassMethod GetApproveSet(OCID)
{
	i OCID="" q ""
	q $P($g(^DHCEQOpenCheck(OCID)),"^",26)
}

ClassMethod GetOtherListInfo(checkRowId)
{
	i checkRowId="" q ""
	s equipdr=$p($g(^DHCEQOpenCheck(checkRowId)),"^",1)
	q ##Class(web.DHCEQEquip).GetOtherListInfo(equipdr)
}

}
