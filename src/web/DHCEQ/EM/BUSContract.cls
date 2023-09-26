Import SQLUser

/// ////  作废	Mozy0234	2019-11-26		使用web.DHCEQ.Con.BUSContract
/// 创建人:Mozy 2018-10-1
/// 合同管理
Class web.DHCEQ.EM.BUSContract Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/*
/// Creator：      Mozy
/// CreatDate：    2018-10-17
/// Description:   合同类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSContract","ContractTypeList")
Query ContractTypeList(ContractType As %String = "") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod ContractTypeListExecute(ByRef qHandle As %Binary, ContractType As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	;s ^DHCEQMozy("ContractType")=ContractType
	s rowid=0
	s Code="01"
	s Desc="采购合同"
	d OutputRowContractTypeList
	s rowid=1
	s Code="02"
	s Desc="保修合同"
	d OutputRowContractTypeList
	s rowid=2
	s Code="03"
	s Desc="协议合同"
	d OutputRowContractTypeList
	s rowid=3
	s Code="04"
	s Desc="投放合同"
	d OutputRowContractTypeList
	
	Quit $$$OK
OutputRowContractTypeList
	Quit:(ContractType'="")&&(ContractType'=rowid)
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod ContractTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ContractTypeListExecute ]
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

ClassMethod ContractTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ContractTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      Mozy
/// CreatDate：    2018-10-17
/// Description:   合同明细来源类型
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSContract","GetContractSourceType")
Query GetContractSourceType(ContractType As %String = "0") As %Query(ROWSPEC = "TDesc:%String,TRowID:%String,TCode:%String")
{
}

ClassMethod GetContractSourceTypeExecute(ByRef qHandle As %Binary, ContractType As %String = "0") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;i ContractType="" Quit $$$OK
 	
 	s index=1
 	s GetSourceType=##class(web.DHCEQCommon).GetSysInfo("103001")
	if (ContractType="")||(ContractType=0)
	{
		//0:采购合同
		//合同设备选择方式 0:不用计划 1:必须计划 2:二者都可以
		if GetSourceType=0
		{
			;CustomValue="2^招标&3^设备项";
			s rowid=2
			s Code="01"
			s Desc="招标"
			d OutputRowGetContractSourceType
			s rowid=3
			s Code="02"
			s Desc="设备项"
			d OutputRowGetContractSourceType
		}
		elseif GetSourceType=1
		{
			;CustomValue="1^计划&2^招标";
			s rowid=1
			s Code="01"
			s Desc="计划"
			d OutputRowGetContractSourceType
			s rowid=2
			s Code="02"
			s Desc="招标"
			d OutputRowGetContractSourceType
		}
		else
		{
			;CustomValue="1^计划&2^招标&3^设备项";
			s rowid=1
			s Code="01"
			s Desc="计划"
			d OutputRowGetContractSourceType
			s rowid=2
			s Code="02"
			s Desc="招标"
			d OutputRowGetContractSourceType
			s rowid=3
			s Code="03"
			s Desc="设备项"
			d OutputRowGetContractSourceType
		}
	}
	if ContractType=1
	{
		//1:保修合同 
		;CustomValue="1^入库明细&2^设备";
		;s rowid=1
		;s Code="01"
		;s Desc="入库明细"
		s rowid=2
		s Code="02"
		s Desc="设备"
		d OutputRowGetContractSourceType
	}
 	if ContractType=2
	{
		//2:协议采购合同
		s rowid=1
		s Code="01"
		s Desc="计划"
		d OutputRowGetContractSourceType
		s rowid=2
		s Code="02"
		s Desc="招标"
		d OutputRowGetContractSourceType
		s rowid=3
		s Code="03"
		s Desc="设备项"
		d OutputRowGetContractSourceType
	}
	if ContractType=3
	{
		//3:投放合同
		//CustomValue="1^入库明细&2^设备";
	}
	
	Quit $$$OK
OutputRowGetContractSourceType
	Set Data=$lb(Desc,rowid,Code)
  	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetContractSourceTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractSourceTypeExecute ]
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

ClassMethod GetContractSourceTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractSourceTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSContract","GetContractList",205)
Query GetContractList(RowID) As %Query(ROWSPEC = "CTLRowID:%String,CTLSourceType_Desc:%String,CTLSourceType:%String,CTLSourceID_Desc:%String,CTLSourceID:%String,CTLModelDR_MDesc:%String,CTLModelDR:%String,CTLManuFactoryDR_MFName:%String,CTLManuFactoryDR:%String,CTLPriceFee:%String,CTLQuantityNum:%String,CTLTotalFee:%String,CTLContractArriveDate:%String,CTLArriveDate:%String,CTLArriveQuantityNum:%String,CTLRemark:%String,CTLGuaranteePeriodNum:%String,CTLItemDR:%String,CTLHold1:%String,CTLHold2:%String,CTLHold3:%String,CTLHold4:%String,CTLHold5:%String,TRow:%String,TJob:%String,CTLName:%String,CTLUnit:%String,CTLFileNo:%String,CTLBrandDR:%String,CTLBrandDR_BDesc:%String,CTLImportFlag:%String,CTLGuaranteeContent:%String,CTLMaintCountType:%String,CTLMaintTimes:%String")
{
}

ClassMethod GetContractListExecute(ByRef qHandle As %Binary, RowID) As %Status
{
 	new repid, index,rowid
 	new rowid,TRow,TotalFlag,TotalQty,Total
	Set (TotalQty,Total)=0
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
		f  s rowid=$o(^DHCEQContractList(0,"Contract",RowID,rowid)) quit:rowid=""  d
		.d ResetVariablesGetContractList
		.s TRowID = rowid
		.s TRow=TRow+1
		.Set ContractDR=$p($g(^DHCEQContractList(rowid)),"^",1)
		.;Set CLStatus=$p($g(^DHCEQContract(ContractDR)),"^",24)       //过滤非审核状态的设备
		.;q:CLStatus'=2
		.Set ContractType=$p($g(^DHCEQContract(ContractDR)),"^",39)
		.s TSourceTypeDR = $p($g(^DHCEQContractList(rowid)),"^",5)
		.s TSourceType=$CASE(TSourceTypeDR,"1":"计划","2":"招标","3":"设备项","4":"设备","":"")
		.s TCommonName = $p($g(^DHCEQContractList(rowid)),"^",2)
		.s TSourceIDDR = $p($g(^DHCEQContractList(rowid)),"^",17)
		.If (ContractType=0)||(ContractType=2) d
		..s TSourceType= $CASE(TSourceTypeDR,"1":"计划","2":"招标","3":"设备项","":"")
		..i TSourceTypeDR=1 s TSourceID=$Piece($Get(^DHCEQBuyPlanList(TSourceIDDR)),"^",2)
		..i TSourceTypeDR=2 s TSourceID=$Piece($Get(^DHCEQIFBBag(TSourceIDDR)),"^",13)
		..i TSourceTypeDR=3 s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",$p($g(^DHCEQContractList(rowid)),"^",18))),"^",1)
		.If ContractType=1 Do
		..If TSourceTypeDR=1 Do
		...Set TSourceType="入库明细"
		...Set TSourceID=$Piece($Get(^DHCEQInStockList(TSourceIDDR)),"^",5)
		..If TSourceTypeDR=2 Do
		...Set TSourceType="设备"
		...Set TSourceID=$Piece($Get(^DHCEQEquip(TSourceIDDR)),"^",71)
		...Set TUnitDR=$Piece($Get(^DHCEQEquip(TSourceIDDR)),"^",5)
		...If TUnitDR '="" Set TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		...Set TFileNo=$p($g(^DHCEQEquip(TSourceIDDR)),"^",85)
		.s TCommonName = $p($g(^DHCEQContractList(rowid)),"^",2)
		.s TModelDR = $p($g(^DHCEQContractList(rowid)),"^",3)
		.i TModelDR '=""  d
		..s TModel = $p($g(^DHCEQCCode("DHCEQCModel",TModelDR)),"^",2)
		.s TManuFactoryDR = $p($g(^DHCEQContractList(rowid)),"^",4)
		.i TManuFactoryDR '=""  d
		..s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
		.s TPriceFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(rowid)),"^",6),"")
		.s TQuantityNum = $p($g(^DHCEQContractList(rowid)),"^",7)
		.s TTotalFee = ##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQContractList(rowid)),"^",8),"")
		.s TotalQty=TotalQty+TQuantityNum
		.s Total=Total+TTotalFee
		.s TRemark = $p($g(^DHCEQContractList(rowid)),"^",9)
		.s TContractArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractList(rowid)),"^",10),"date")
		.s TArriveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQContractList(rowid)),"^",11),"date")
		.s TArriveQuantityNum = $p($g(^DHCEQContractList(rowid)),"^",12)
		.s TGuaranteePeriodNum = $p($g(^DHCEQContractList(rowid)),"^",16)
		.s TItemDR=$p($g(^DHCEQContractList(rowid)),"^",18)
		.
		.i TItemDR'="" d
		..;s TSourceID=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)	//取消来源取值设备名称
		..Set TUnitDR=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",7)
		..Set TUnit = ##class(web.DHCEQCommon).GetTrakNameByID("uom",TUnitDR)
		.s TBrandDR = $p($g(^DHCEQContractList(rowid)),"^",19)
		.s TImportFlag = $p($g(^DHCEQContractList(rowid)),"^",20)
		.s TGuaranteeContent = $p($g(^DHCEQContractList(rowid)),"^",21)
		.s TMaintCountType = $p($g(^DHCEQContractList(rowid)),"^",22)
		.s TMaintTimes = $p($g(^DHCEQContractList(rowid)),"^",23)
		.s THold1 = $p($g(^DHCEQContractList(rowid)),"^",24)
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
	quit	
OutputRowGetContractList
	Set Data=$lb(TRowID,TSourceType,TSourceTypeDR,TSourceID,TSourceIDDR,TModel,TModelDR,TManuFactory,TManuFactoryDR,TPriceFee,TQuantityNum,TTotalFee,TContractArriveDate,TArriveDate,TArriveQuantityNum,TRemark,TGuaranteePeriodNum,TItemDR,THold1,THold2,THold3,THold4,THold5,TRow,TJob,TCommonName,TUnit,TFileNo,TBrandDR,TBrand,TImportFlag,TGuaranteeContent,TMaintCountType,TMaintTimes)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetContractList
	Set (TRowID,TSourceType,TSourceTypeDR,TSourceID,TSourceIDDR,TModel,TModelDR,TManuFactory,TManuFactoryDR,TPriceFee,TQuantityNum,TTotalFee,TContractArriveDate,TArriveDate,TArriveQuantityNum,TRemark,TGuaranteePeriodNum,TItemDR,THold1,THold2,THold3,THold4,THold5,TCommonName,TUnit,TFileNo,TBrandDR,TBrand,TImportFlag,TGuaranteeContent,TMaintCountType,TMaintTimes)=""
	quit
}

ClassMethod GetContractListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractListExecute ]
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

ClassMethod GetContractListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSContract).SaveData("","","")
ClassMethod SaveData(data, dataList, DelRowid)
{
	s $ZT="ERRORContrcat"
	k PLIST,RowID
	
	s User=%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$P($H,",",2)
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQContract",JsonData,.PLIST)
	s RowID = JsonData.CTRowID
	;i PLIST(2)="" Set PLIST(2)=PLIST(3)_"合同"	;ContractName
	s PLIST(25) ="0"				;Status
	s PLIST(30) = User				;UpdateUserDR
	s PLIST(31) = Date				;UpdateDate
	s PLIST(32) = Time				;UpdateTime
	
 	TSTART
	if RowID'=""
	{
		&SQL(Update SQLUSER.DHC_EQContract Values :PLIST() where CT_RowID = :RowID)
	}
	else
	{
		s Flag=##class(web.DHCEQCommon).GetSysInfo("103002")
		if (Flag="1")
		{
			s PLIST(3)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQContract",+$H)
		}
		&SQL(insert into SQLUSER.DHC_EQContract Values :PLIST())
		s RowID=$g(%ROWID)
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##Class(web.DHCEQ.EM.BUSContract).DeleteContractList(RowID,DelRowid)
 	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
 	s SQLCODE=##Class(web.DHCEQ.EM.BUSContract).SaveContractList(RowID,dataList)
 	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
	
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORContrcat
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:写入合同明细
/// w ##Class(web.DHCEQ.EM.BUSContract).SaveContractList("8","1^4^3^传真机^124^1880^8^5^5^25^备注^04/03/2011^^^^^^&2^^2^笔记本电脑^1^^8^5000^10^50000^^^^^^^^")
ClassMethod SaveContractList(RowID, dataList)
{
	k PLIST
	s SQLCODE=0
	s SupportRowIDs=""		;有效的明细记录ID
	s User=%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$P($H,",",2)
	s Length=$L(dataList,"&")
	s CTTotalFee=0
	for k=1:1:Length
	{
		q:SQLCODE'=0
		s valList=$p(dataList,"&",k)
		q:valList=""
		k PLIST,ISLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQContractList",JsonData,.PLIST)
		s CTLRowID = JsonData.CTLRowID
		s PLIST(2)=RowID				;CTL_ContractDR
		s PLIST(14)=User  				;CTL_UpdateUserDR
		s PLIST(15)=Date  				;CTL_UpdateDate
		s PLIST(16)=Time				;CTL_UpdateTime
		s PLIST(9)=PLIST(7)*PLIST(8)
	    if CTLRowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQContractList Values :PLIST() where CTL_RowID = :CTLRowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQContractList Values :PLIST())
			s CTLRowID=$g(%ROWID)
		}
		i SQLCODE'=0 q
		s CTTotalFee=CTTotalFee+PLIST(9)	//JsonData.CTLTotalFee
		if SupportRowIDs=""
		{
			s SupportRowIDs=CTLRowID
		}
		else
		{
			s SupportRowIDs=SupportRowIDs_","_CTLRowID
		}
	}
	i SQLCODE'=0 q SQLCODE
	i $p($g(^DHCEQContract(RowID)),"^",39)=0 &SQL(update sqluser.DHC_EQContract set CT_TotalFee=:CTTotalFee where CT_RowID=:RowID)	;更新采购合同的总金额
	;删除无效的明细记录
	s CTLRowID=0
	f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",RowID,CTLRowID)) quit:(CTLRowID="")||(SQLCODE'=0)  d
	.i (","_SupportRowIDs_",")'[(","_CTLRowID_",") &SQL(delete from SQLUSER.DHC_EQContractList where CTL_RowID = :CTLRowID)
	q SQLCODE
}

/// 描述:删除
/// w ##Class(web.DHCEQ.EM.BUSContract).DeleteData()
ClassMethod DeleteData(RowID As %String = "")
{
	i RowID="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	new ApproveTypeDR
	s ApproveTypeDR=##class(web.DHCEQApproveList).GetApproveType("8")
	Set $ZT="ERRORDelete"
	TSTART		
	&SQL(delete from  sqluser.DHC_EQApproveInfo where AI_SourceID=:RowID and AI_ApproveTypeDR=:ApproveTypeDR)
	i (SQLCODE'=0)&&(SQLCODE'=100)
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	&SQL(delete from  sqluser.DHC_EQApproveList where AL_SourceID=:RowID and AL_ApproveTypeDR=:ApproveTypeDR)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	&SQL(delete from  sqluser.DHC_EQContractList where CTL_ContractDR=:RowID)
 	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
 	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
 	}
	&SQL(delete from sqluser.DHC_EQContract where CT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	s SQLCODE=##Class(web.DHCEQPayPlan).DeleteData("",1,RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	
 	TCOMMIT
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORDelete
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// 描述:删除合同明细
/// w ##Class(web.DHCEQ.EM.BUSContract).DeleteContractList("231","-1")
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
			&SQL(delete from sqluser.DHC_EQContractList where CTL_RowID=:CTLRowID)
			i SQLCODE s Flag=CTLRowID_"^更新操作失败"
		}
	}
	q Flag
}

/// w ##Class(web.DHCEQ.EM.BUSContract).GetOneContract(207)
ClassMethod GetOneContract(RowID As %Library.String = "", ApproveRoleDR As %Library.String = "", action As %Library.String = "", step As %Library.String = "")
{
	s $ZT="ERRORGetOneContract"
	// CT_RowID CT_ContractName CT_ContractNo CT_QuantityNum CT_TotalFee CT_PreFeeFee CT_PayedTotalFee CT_SignDate CT_SignLocDR CT_DeliveryDate CT_ArriveDate 
	// CT_StartDate CT_EndDate CT_ClaimPeriodNum CT_Service CT_PayTypeDR CT_PayItem CT_CheckStandard CT_ProviderDR CT_ProviderTel CT_ProviderHandler CT_BreakItem 
	// CT_NeedHandlerDR CT_GuaranteePeriodNum CT_Status CT_Remark CT_SubmitUserDR CT_SubmitDate CT_SubmitTime CT_UpdateUserDR CT_UpdateDate CT_UpdateTime 
	// CT_AuditUserDR CT_AuditDate CT_AuditTime CT_ArriveMonthNum CT_ServiceDR CT_ServiceHandler CT_ServiceTel CT_ContractType CT_ArriveItem CT_QualityItem 
	// CT_RefuseReason CT_RefuseUserDR CT_RefuseDate CT_RefuseTime CT_IFBNo CT_CurrencyDR CT_BuyTypeDR CT_SubType CT_ContractStatus CT_ManagerLocDR CT_FileNo
	// CT_Hold1 CT_Hold2 CT_Hold3 CT_Hold4 CT_Hold5 
	s ObjContract=##Class(User.DHCEQContract).%OpenId(RowID)
	s ContractInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjContract)
	
	d ContractInfo.%Set("ContractType",ObjContract.CTContractType)
	d ContractInfo.%Set("ContractTypeList",##Class(web.DHCEQ.EM.BUSContract).GetContractType(ObjContract.CTContractType))
	d ContractInfo.%Set("CTProviderDR_VDesc",##class(web.DHCEQCommon).GetTrakNameByID("prov",ObjContract.CTProviderDR))
	d ContractInfo.%Set("CTSignLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjContract.CTSignLocDR))
	d ContractInfo.%Set("CTManagerLocDR_CTLOCDesc",##class(web.DHCEQCommon).GetTrakNameByID("dept",ObjContract.CTManagerLocDR))
	d ContractInfo.%Set("CTBuyTypeDR_BTDesc",ObjContract.CTBuyTypeDR.BTDesc)
	d ContractInfo.%Set("CTServiceDR_SVName",ObjContract.CTServiceDR.SVName)
	d ContractInfo.%Set("CTPayTypeDR_CTPM",##class(web.DHCEQCommon).GetTrakNameByID("ctpm",ObjContract.CTPayTypeDR))
	d ContractInfo.%Set("CTNeedHandlerDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjContract.CTNeedHandlerDR))
	d ContractInfo.%Set("CTSubmitUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjContract.CTSubmitUserDR))
	d ContractInfo.%Set("CTUpdateUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjContract.CTUpdateUserDR))
	d ContractInfo.%Set("CTAuditUserDR_SSUSRName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjContract.CTAuditUserDR))
	d ContractInfo.%Set("CTGuaranteePeriodNum",ObjContract.CTGuaranteePeriodNum)
	
	s AppInfo=##class(web.DHCEQApprove).GetApproveInfoBySourceID("8",RowID,ApproveRoleDR)
	d ContractInfo.%Set("AIRowID",$p(AppInfo,"^",1))
	d ContractInfo.%Set("ApproveSetDR",$p(AppInfo,"^",2))
	d ContractInfo.%Set("NextRoleDR",$p(AppInfo,"^",3))
	d ContractInfo.%Set("NextFlowStep",$p(AppInfo,"^",4))
	d ContractInfo.%Set("ApproveStatus",$p(AppInfo,"^",5))
	d ContractInfo.%Set("ApproveRoleDR",$p(AppInfo,"^",6))
	d ContractInfo.%Set("CancelFlag",$p(AppInfo,"^",7))
	d ContractInfo.%Set("CancelToFlowDR",$p(AppInfo,"^",8))
	d ContractInfo.%Set("ApproveRole",$p(AppInfo,"^",9))
	d ContractInfo.%Set("NextRole",$p(AppInfo,"^",10))
	
	/*s CanChangeValue=""
	i action'="" s CanChangeValue=##Class(web.DHCEQCApproveFlow).CheckApproveFlagAbove("8",action,rowid,2)
	s MultipleRoleFlag=0
	i ($p(CanChangeValue,"^",3)'="")&&((","_$p(CanChangeValue,"^",3))[(","_step_",")) d
	.s MultipleRoleFlag=1
	d ContractInfo.%Set("MultipleRoleFlag",MultipleRoleFlag)
	***
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,ContractInfo)
ERRORGetOneContract
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSContract).GetContractType(1)
ClassMethod GetContractType(ContractType)
{
	Quit $CASE(ContractType,"0":"采购合同","1":"保修合同","3":"协议合同","4":"投放合同",:"没有定义")
}

/// Mozy	2018-10-19
/// 描述: 合同单明细来源query
/// 入参:SourceType		1:计划		2:招标		3:设备项	4:设备台帐
/// 			SourceDesc	查询名称条件
/// 				SourceID	来源明细ID
/// 访问表
/// 出参：  
/// 返回值:
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSContract","GetContractSource",1)
Query GetContractSource(SourceType As %String = "", SourceDesc As %String = "", SourceID As %String = "", CTLRowID As %String = "") As %Query(ROWSPEC = "TSourceID:%String,TItemDR:%String,TName:%String,TModelDR:%String,TModel:%String,TManuFacDR:%String,TManuFac:%String,TPriceFee:%String,TQuantityNum:%String,TTotalFee:%String,TNo:%String,TUnit:%String")
{
}

ClassMethod GetContractSourceExecute(ByRef qHandle As %Binary, SourceType As %String = "", SourceDesc As %String = "", SourceID As %String = "", CTLRowID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQMozy("GetContractSource")=SourceType_","_SourceDesc_","_SourceID_","_CTLRowID
	// 类型  来源  通用名  型号  制造厂家  数量  单位  单价  总价
	Set index=1
	i SourceType=1
	{
		;1计划		BussType:用到计划明细的业务 1:招标 2:合同 3:验收
		Set rowid=0
		For  Set rowid=$Order(^DHCEQBuyPlanList(rowid)) Quit:rowid=""  Do
		.Quit:(SourceID'="")&&(SourceID'=rowid)
		.Do ResetGetContractSource
		.Set CTLSourceID = rowid
		.Set TBPDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",1)
		.;招标、合同、验收中,仅能使用状态为审核的计划明细
		.Quit:$p($g(^DHCEQBuyPlan(TBPDR)),"^",6)'=2
		.
		.if TBPDR'="" Do
		..Set CTLName=$Piece($Get(^DHCEQBuyPlan(TBPDR)),"^",1)
		..Set No=$Piece($Get(^DHCEQBuyPlan(TBPDR)),"^",25)
		.if CTLName'="" Set CTLName=CTLName_"->"
		.Set CTLName=CTLName_$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",2)
		.Quit:(SourceDesc'="")&&(CTLName'[SourceDesc)
		.Set CTLModelDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",3)
		.Set CTLModel=##class(web.DHCEQCommon).GetTrakNameByID("model",CTLModelDR)
		.Set CTLManuFacDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",4)
		.Set CTLManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",CTLManuFacDR)
		.Set CTLPriceFee=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",6)
		.Set CTLQuantityNum=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",7)
		.
		.;业务为招标时,检索其他招标中已经使用该计划明细的数量
		.;业务为合同时,如果该计划明细已有对应招标记录则合同可用数应减去招标占用数,合同应从招标处选取数据
		.Set BussListID=0
		.For  Set BussListID=$Order(^DHCEQIFBBag(0,"Extend",2,CTLSourceID,BussListID)) Quit:BussListID=""  Do
		..Set CTLQuantityNum=CTLQuantityNum-$Piece($Get(^DHCEQIFBBag(BussListID)),"^",5)
		.
		.;业务为招标时,除上面减去其它招标中已经占用的计划明细数量外还需要减去合同来自计划的明细数量
		.;业务为合同时,除上面减去招标中已经使用该计划明细的数量再减去其他合同中使用的计划明细数量
		.Set BussListID=0
		.For  Set BussListID=$Order(^DHCEQContractList(0,"SourceID",1,CTLSourceID,BussListID))  Quit:BussListID=""  Do
		..Quit:(CTLRowID=BussListID)
		..Set CTLQuantityNum=CTLQuantityNum-$Piece($Get(^DHCEQContractList(BussListID)),"^",7)
		.
		.Quit:CTLQuantityNum<1
		.Set CTLTotalFee=CTLQuantityNum*CTLPriceFee
		.Set CTLItemDR=$Piece($Get(^DHCEQBuyPlanList(rowid)),"^",18)
		.If CTLItemDR'="" Set Unit=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",CTLItemDR)),"^",7)
		.Set Unit=##class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
		.Do OutputRowGetContractSource
	}
	elseif SourceType=2
	{
		;2招标
		Set itemid=0
		For  Set itemid=$Order(^DHCEQIFBBag(0,"Item",itemid)) Quit:itemid=""  Do
		.Set TItem=$Piece($Get(^DHCEQCCode("DHCEQCMasterItem",itemid)),"^",1)
		.quit:(SourceDesc'="")&&(TItem'[SourceDesc)
		.Set rowid=0
		.For  Set rowid=$Order(^DHCEQIFBBag(0,"Item",itemid,rowid)) Quit:rowid=""  Do
		..Quit:(SourceID'="")&&(SourceID'=rowid)
		..;set (IFBDR,TBagNo,TWinPrice)=""
		..i (SourceID="")||(SourceID'=rowid) quit:$D(^DHCEQContractList(0,"SourceID",2,rowid))
		..Set IFBDR=$Piece($Get(^DHCEQIFBBag(rowid)),"^",1)
		..Quit:$Piece($Get(^DHCEQIFB(IFBDR)),"^",43)'=2
		..;Set TBagNo=$Piece($Get(^DHCEQIFBBag(rowid)),"^",2)
		..
		..Set ifblistid=0
		..For  Set ifblistid=$Order(^DHCEQIFBList(0,"IFBBag",rowid,ifblistid)) Quit:ifblistid=""  Do
		...Do ResetGetContractSource
		...Set WinFlag=$Piece($Get(^DHCEQIFBList(ifblistid)),"^",8)
		...quit:WinFlag'="Y"
		...Set CTLSourceID = rowid
		...Set No=$Piece($Get(^DHCEQIFB(IFBDR)),"^",3)
		...Set CTLItemDR=itemid
		...Set CTLName=$Piece($Get(^DHCEQIFBBag(rowid)),"^",13)
		...Set CTLManuFacDR=$Piece($Get(^DHCEQIFBList(ifblistid)),"^",3)
		...Set CTLManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",CTLManuFacDR)
		...Set CTLModelDR	=$Piece($Get(^DHCEQIFBList(ifblistid)),"^",4)
		...Set CTLModel=##class(web.DHCEQCommon).GetTrakNameByID("model",CTLModelDR)
		...Set CTLPriceFee=$Piece($Get(^DHCEQIFBBag(rowid)),"^",11)
		...Set CTLQuantityNum=$Piece($Get(^DHCEQIFBBag(rowid)),"^",5)
		...Set CTLTotalFee=CTLQuantityNum*CTLPriceFee
		...Set Unit=$Piece($Get(^DHCEQIFBBag(rowid)),"^",4)
		...Set Unit=##class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
		...Do OutputRowGetContractSource
	}
	elseif SourceType=3
	{
		;3设备项
		s Hospital=##Class(web.DHCEQCommon).GetHospital()
		i Hospital'=""
		{
			s TEquipTypeDR=0
			f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR)) quit:TEquipTypeDR=""  d
			.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
			.s rowid=0
			.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"Hospital",Hospital,TEquipTypeDR,rowid)) quit:rowid=""  d
			..d BuildDataGetItem
		}
		else
		{
			s TEquipTypeDR=0
			f  s TEquipTypeDR=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR)) quit:TEquipTypeDR=""  d
			.q:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)'=0
			.s rowid=0
			.f  s rowid=$o(^DHCEQCCode("DHCEQCMasterItem",0,"EquipType",TEquipTypeDR,rowid)) quit:rowid=""  d
			..d BuildDataGetItem
		}
	}
	else	;if SourceType=4
	{
		;4设备
		s rowid=0
		f  s rowid=$o(^DHCEQEquip(rowid)) q:rowid=""  d
		.Quit:(SourceID'="")&&(SourceID'=rowid)
		.q:$p($g(^DHCEQEquip(rowid)),"^",59)'="N"
		.q:##Class(web.DHCEQCommon).EquipTypeIsIn($p($g(^DHCEQEquip(rowid)),"^",63))
		.q:(($p($g(^DHCEQEquip(rowid)),"^",38)="3")||($p($g(^DHCEQEquip(rowid)),"^",38)="4"))
		.q:##class(web.DHCEQCommon).LocIsInEQ("",$p($g(^DHCEQEquip(rowid)),"^",67))
		.q:($p($g(^DHCEQEquip(rowid)),"^",60)="0")||($p($g(^DHCEQEquip(rowid)),"^",60)="3")
		.d ResetGetContractSource
		.s CTLSourceID=rowid
		.s CTLItemDR=$p($g(^DHCEQEquip(rowid)),"^",7)
		.s CTLName=$p($g(^DHCEQEquip(rowid)),"^",1)
		.quit:(SourceDesc'="")&&(CTLName'[SourceDesc)&&($p($g(^DHCEQEquip(rowid)),"^",71)'[SourceDesc)
		.s CTLModelDR = $p($g(^DHCEQEquip(rowid)),"^",3)
		.Set CTLModel=##class(web.DHCEQCommon).GetTrakNameByID("model",CTLModelDR)
		.s CTLManuFacDR = $p($g(^DHCEQEquip(rowid)),"^",26)
		.Set CTLManuFac=##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",CTLManuFacDR)
		.s CTLPriceFee=$p($g(^DHCEQEquip(rowid)),"^",27)
		.s CTLQuantityNum=1
		.s CTLTotalFee=CTLPriceFee
		.s No=$p($g(^DHCEQEquip(rowid)),"^",71)
		.s Unit = ##class(web.DHCEQCommon).GetTrakNameByID("uom", $p($g(^DHCEQEquip(rowid)),"^",5))
		.;s FileNo=$p($g(^DHCEQEquip(rowid)),"^",85)
		.d OutputRowGetContractSource
	}
	
	Quit $$$OK
OutputRowGetContractSource
	Set CTLPriceFee=##Class(web.DHCEQCommon).FormatNumber(CTLPriceFee,"")
	Set CTLTotalFee=##Class(web.DHCEQCommon).FormatNumber(CTLTotalFee,"")
	Set Data=$lb(CTLSourceID,CTLItemDR,CTLName,CTLModelDR,CTLModel,CTLManuFacDR,CTLManuFac,CTLPriceFee,CTLQuantityNum,CTLTotalFee,No,Unit)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetContractSource
	Set (CTLSourceID,CTLItemDR,CTLName,CTLModelDR,CTLModel,CTLManuFacDR,CTLManuFac,CTLPriceFee,CTLQuantityNum,CTLTotalFee,No,Unit)=""
	Quit
BuildDataGetItem
	d ResetGetContractSource
	Quit:(SourceID'="")&&(SourceID'=rowid)
	s CTLSourceID = rowid
	s CTLItemDR = rowid
	s TFlag = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",8)
	q:TFlag="Y"
	s CTLName = $p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",1)
	s No=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",2)
	q:(SourceDesc'="")&&($ZCONVERT(CTLName ,"U")'[$ZCONVERT(SourceDesc,"U"))
	
	s Unit=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",7)
	s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",Unit)
	;Quit:(##Class(web.DHCEQCommon).CheckManageLimit("","","",TEquipTypeDR,TStatCatDR,TCatDR,"","",rowid)) 
	q:($p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",12)="Y")
	;s THold2=$p($g(^DHCEQCCode("DHCEQCMasterItem",rowid)),"^",11)
	;i THold2'="" s THold2Desc=$P($g(^CT("HOSP",THold2)),"^",2)
	d OutputRowGetContractSource
	
	Quit
}

ClassMethod GetContractSourceFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetContractSourceExecute ]
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

ClassMethod GetContractSourceClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetContractSourceExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 创建:Mozy 2018-10-25  
/// 目的:复制合同
/// 描述:复制合同信息
/// 输入:被复制的合同信息
/// 返回值: 成功返回复制后的合同RowID
/// 状态：
/// w ##Class(web.DHCEQ.EM.BUSContract).CopyContract(82)
ClassMethod CopyContract(CTRowID As %String = "")
{
	;s ^DHCEQMozy("CopyContract")=CTRowID
	i CTRowID="" Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1100",ErrorMsg)
	n NewCTRowID
	k PLIST
	//s Status="0"       //状态设定
	//s ContractNo=      //新合同号
	Set $ZT="ERRORCopyContrcat"
	TSTART
	    &SQL(select * into :PLIST() from sqluser.DHC_EQContract where CT_RowID=:CTRowID)
	    if SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
	    s (PLIST(33),PLIST(34),PLIST(35),PLIST(27),PLIST(28),PLIST(29))=""    //将提交和审核相关信息置空
	    s PLIST(30)=%session.Get("LOGON.USERID")                              //修改更新人为当前登录人             
	    s PLIST(3)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQContract",+$H) //取新合同号    
	    s PLIST(25)="0"                                                       //状态置新增
	    s PLIST(1)=""                                                         //RowID置空
	    &SQL(insert into sqluser.DHC_EQContract values :PLIST())
		if SQLCODE'=0
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		s NewCTRowID=$G(%ROWID)
		
		s CTLRowID=""
        f  s CTLRowID=$o(^DHCEQContractList(0,"Contract",CTRowID,CTLRowID)) quit:((CTLRowID="")||(SQLCODE'=0))  d
        .s SQLCODE=##Class(web.DHCEQ.EM.BUSContract).CopyContractList(NewCTRowID,CTLRowID)
        if SQLCODE'=0 
        {
           TROLLBACK
           Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
        }
 	TCOMMIT
 	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,CTRowID)
ERRORCopyContrcat
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSContract).CopyContractList("12","13")
ClassMethod CopyContractList(CTRowID, CTLRowID)
{
	k PLISTMX
	&SQL(select * into :PLISTMX() from sqluser.DHC_EQContractList Where CTL_RowID=:CTLRowID)
	s PLISTMX(1)=""                           //RowID置空
	s PLISTMX(2)=CTRowID                      //取复制后的合同主表ID
	&SQL(Insert Into SQLUSER.DHC_EQContractList Values :PLISTMX())
	
	q SQLCODE
}

/// Add:Mozy 2018-10-24
/// 描述:提交
/// w ##Class(web.DHCEQ.EM.BUSContract).SubmitData("5^24^^2252^1^^拒绝原因")
ClassMethod SubmitData(RowID)
{
	new User,Date,Time,ApproveType,ApproveSet,TotalFee
	new LastFlag,NextStep,NextRole,Num,ApproveFlow,AutoAuditFlag,AuditFlag
	k PLIST
	s Date=+$H
	s Time=$P($H,",",2)
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	; Mozy0234	2019-11-26
	Set $ZT="ERRORSubmit"
	
	s Status=$p($g(^DHCEQContract(RowID)),"^",24)
	if Status'="0" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1100",RowID)   //该记录状态不符合,不能执行操作!
	if (##Class(web.DHCEQPayPlan).CheckPayPlan(1,RowID)="-2") q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1100",RowID)
	
	s TotalFee=$p($g(^DHCEQContract(RowID)),"^",4)
	s ApproveType=##class(web.DHCEQApproveList).GetApproveType("8")
	s ApproveSet=##class(web.DHCEQCApproveSet).JudgeApproveSet(ApproveType, "", "", "", TotalFee,"","")
	i ApproveSet="" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9021",RowID)
	s ApproveFlow=##class(web.DHCEQCApproveSet).GetNextStep(ApproveSet, ApproveType, RowID, 0, "")
	s AutoAuditFlag=$p(^DHCEQCCode("DHCEQCApproveSet",ApproveSet),"^",9)
	s LastFlag=$P(ApproveFlow,"^",1)
	s NextStep=$P(ApproveFlow,"^",2)
	s NextRole=$P(ApproveFlow,"^",3)
	s AppInfoStatus="1"
	
	s PLIST(25) = "1"	;Status 	
	s PLIST(27) = User	;SubmitUserDR
	s PLIST(28) = Date	;SubmitDate
	s PLIST(29) = Time	;SubmitTime
	//检测是否最后一步,是则自动审核
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
	 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",RowID)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,"","",AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",RowID)
	}
	&SQL(update sqluser.DHC_EQContract values :PLIST() where CT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1100",RowID)
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("94", RowID, User, ApproveFlow_"^"_ApproveSet, "N","",AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",RowID)
	}
 	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORSubmit 
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Add:Mozy 2018-10-24
/// 描述:反提交
/// w ##Class(web.DHCEQ.EM.BUSContract).CancelSubmitData("")
ClassMethod CancelSubmitData(val, CurRole)
{
	new User,Date,Time,RowID,ApproveSet,CancelToFlowDR,ApproveInfoID
	Set $ZT="ERRORCancel"
	k PLIST,AppInfo
	s Date=+$H
	s Time=$P($H,",",2)
	
	s RowID=$P(val,"^",1)
	s User=$p(val,"^",2)
	s ApproveSet=$P(val,"^",3)
	s CancelToFlowDR=$P(val,"^",4)	
	;s Opinion=$p(val,"^",5)
	s RefuseReason= $p(val,"^",6)
	
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
	
	//取消提交的拒绝原因也写在DHC_EQApproveList表中,表增加一个审批标记:统一/拒绝 
	Set ApproveSet=##class(web.DHCEQApproveList).GetApproveSet("8", RowID)
	Set RoleStep=##class(web.DHCEQCApproveSet).GetStepByRole(ApproveSet,CurRole)
	;生成审批记录
	Set SQLCODE=##class(web.DHCEQApproveList).UpdateData(ApproveType,RowID,RefuseReason,"",CurRole,RoleStep,User,"1")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",RowID)
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,ApproveRoleDR,Step,"","",Status,"Y")
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",RowID)
	}
	&SQL(update sqluser.DHC_EQContract values :PLIST() where CT_RowID=:RowID)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",RowID)
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
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",RowID)
		}
	}
 	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
ERRORCancel 
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",ErrorMsg)
}

/// Add:Mozy 2018-10-24
/// 描述:审核
/// w ##Class(web.DHCEQ.EM.BUSContract).AuditData("8^24^^^1^^","4","0","")
ClassMethod AuditData(val, CurRole, RoleStep, editFieldsInfo)
{
	new User,Date,Time,RowID,ApproveType,ApproveSet,Actions
	new LastFlag,NextStep,NextRole,Num,ApproveFlow,AutoAuditFlag
	Set $ZT="ERRORAudit"
	k PLIST
	s RowID=$P(val,"^",1)
	s Status=$p($g(^DHCEQContract(RowID)),"^",24)
	if Status'="1" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9000",RowID)   //该记录状态不符合,不能执行操作!
	s User=$p(val,"^",2)
  	s Opinion=$p(val,"^",5)
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
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9001",RowID)
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
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9002",RowID)
		}
	}
	s SQLCODE=##class(web.DHCEQApprove).SaveApproveInfo(ApproveSet,RowID,NextRole,NextStep,RoleStep,CurRole,AppInfoStatus)
	If SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9003",RowID)
	}
	//可编辑字段更新
	i editFieldsInfo'=""
	{
		s SQLCODE=##Class(web.DHCEQApprove).EditRoleReqFields(editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9004",RowID)
		}
	}
	s Actions=##Class(web.DHCEQCApproveAction).GetApproveActions(ApproveSet, RoleStep, CurRole)
	if Actions'=""				//执行当前角色要执行的动作
	{
		s SQLCODE=##Class(web.DHCEQCApproveAction).DoActions(RowID,User,Actions,editFieldsInfo)
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9005",RowID)
		}
	}
	s SQLCODE=##Class(web.DHCEQMessages).CreateBussInfo("94", RowID, User, ApproveFlow_"^"_ApproveSet, "N",CurRole,AuditFlag)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9006",RowID)
	}
	TCOMMIT
 	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORAudit
	Set ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9007",ErrorMsg)
}

/// add by  2018-05-29 ZY0169 
/// 表结构修改和增加了字段
/// 合同明细综合查询query
/// d ##Class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSContract","ContractList","")
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
	*****
	
	s vFileNo=""
	f  s vFileNo=$o(^DHCEQContract(0,"FileNo",vFileNo),-1)  q:vFileNo=""  d
	.q:(FileNo'="")&&(vFileNo'[FileNo)
	.s rowid=0
	.f  s rowid=$o(^DHCEQContract(0,"FileNo",vFileNo,rowid))  q:rowid=""  d
	..s TContractType=$p($g(^DHCEQContract(rowid)),"^",39)
	..q:(ContractTypeDR'="")&&(ContractTypeDR'=TContractType)
	..//s TContractNo=$p($g(^DHCEQContract(rowid)),"^",39)
	..//q:(ContractNo'="")&&(ContractNo'=TContractNo)
	..i TContractType=1  d
	...s MXRowID=""
	...s DatalistMX=""
	...d FillOneContarctListData
	..e  d
	...s MXRowID=0
	...f  s MXRowID=$o(^DHCEQContractList(0,"Contract",rowid,MXRowID))  q:MXRowID=""  d
	....d FillOneContarctListData
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
	Set Data=$lb(TRowID,TContractName,TContractNo,TSignDate,TSignLocDR,TSignLoc,TPreFeeFee,TPayedTotalFee,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TCheckStandard,TProviderDR,TProvider,TProviderTel,TProviderHandler,TBreakItem,TGuaranteePeriodNum,TStatus,TArriveMonthNum,TServiceDR,TService,TContractType,TFileNo,TRowIDMX,TName,TPrice,TQuantityNum,TTotal,THold1)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("ContractList",curuser,gnum)=TContractName_"^"_TContractNo_"^"_TSignDate_"^"_TSignLoc_"^"_TPreFeeFee_"^"_TPayedTotalFee_"^"_TDeliveryDate_"^"_TArriveDate_"^"_TStartDate_"^"_TEndDate_"^"_TClaimPeriodNum_"^"_TService_"^"_TCheckStandard_"^"_TProvider_"^"_TProviderTel_"^"_TProviderHandler_"^"_TBreakItem_"^"_TGuaranteePeriodNum_"^"_TArriveMonthNum_"^"_TService_"^"_TContractType_"^"_TFileNo_"^"_TName_"^"_TPrice_"^"_TQuantityNum_"^"_TTotal_"^"_THold1
	Set gnum=gnum+1
	quit
ResetVariablesContarctListData
	Set (TRowID,TContractName,TContractNo,TSignDate,TSignLocDR,TSignLoc,TPreFeeFee,TPayedTotalFee,TDeliveryDate,TArriveDate,TStartDate,TEndDate,TClaimPeriodNum,TService,TCheckStandard,TProviderDR,TProvider,TProviderTel,TProviderHandler,TBreakItem,TGuaranteePeriodNum,TStatus,TArriveMonthNum,TServiceDR,TService,TContractType,TFileNo,TRowIDMX,TName,TPrice,TQuantityNum,TTotal,THold1)=""
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

// Modify by Mozy 2018-11-6	588850

/// 保修合同明细设备查询
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSContract","GetEquipList","^StatusDR=2^SignLocDR=")
Query GetEquipList(vData As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TABCType:%String,TCode:%String,TDesc:%String,TInstallLocDR:%String,TInstallDate:%String,TLeaveFactoryNo:%String,TLeaveFactoryDate:%String,TOpenCheckDate:%String,TCheckDate:%String,TMakeDate:%String,TComputerFlag:%String,TOriginalFee:%String,TNetFee:%String,TNetRemainFee:%String,TGroupDR:%String,TLimitYearsNum:%String,TContractListDR:%String,TDepreMethodDR:%String,TRemark:%String,TDepreTotalFee:%String,TDesignWorkLoadNum:%String,TStatus:%String,TManageUserDR:%String,TMaintUserDR:%String,TProviderHandler:%String,TProviderTel:%String,TAppendFeeTotalFee:%String,TStartDate:%String,TTransAssetDate:%String,TGuaranteeFlag:%String,TInputFlag:%String,TTestFlag:%String,TMedicalFlag:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TAddUserDR:%String,TAddDate:%String,TAddTime:%String,TUpdateUserDR:%String,TUpdateDate:%String,TUpdateTime:%String,TCurrencyDR:%String,TInvalidFlag:%String,TStockStatus:%String,TMemoryCode:%String,TUrgencyFlag:%String,TStoreLocDR:%String,TStartDepreMonth:%String,TServiceDR:%String,TInStockListDR:%String,TNo:%String,TModel:%String,TEquiCat:%String,TUnit:%String,TInstallLoc:%String,TCountry:%String,TManageLoc:%String,TManageLevel:%String,TUseLoc:%String,TOrigin:%String,TFromDept:%String,TToDept:%String,TBuyType:%String,TEquipTechLevel:%String,TProvider:%String,TManuFactory:%String,TGroup:%String,TContractList:%String,TDepreMethod:%String,TWorkLoadUnit:%String,TManageUser:%String,TMaintUser:%String,TAddUser:%String,TUpdateUser:%String,TCurrency:%String,TEquipType:%String,TPurchaseType:%String,TPurposeType:%String,TKeeper:%String,TStoreLoc:%String,TService:%String,TInStockList:%String,TQuantity:%String,TBatchFlag:%String,TDisplayStatus:%String,TDisplayStockStatus:%String,TLocation:%String,TGuaranteePeriodNum:%String,TStatCatDR:%String,TStatCat:%String,TFileNo:%String,TRentLocDR:%String,TRentStatus:%String,TFaultStatus:%String,TDisuseDate:%String,TAccountNo:%String,Thold6:%String,Thold7:%String,Thold8:%String,Thold9:%String,Thold10:%String,TAdvanceDisFlag:%String,TInStockNo:%String,TCommonName:%String,TFundsInfo:%String,TPayNo:%String,TUnusualRemark:%String,TRow:%String,TSignDate:%String,CTRowID:%String")
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
	.s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
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
	;s TPurposeTypeDR = $p(EquipData,"^",65)
	i TPurposeTypeDR '=""  d
	.s TPurposeType = $p($g(^DHCEQCCode("DHCEQCPurposeType",TPurposeTypeDR)),"^",2)
	s TKeeperDR = $p(EquipData,"^",66)
	s TKeeper = ##Class(web.DHCEQCommon).GetTrakNameByID("user", TKeeperDR)
	s TStoreLocDR = $p(EquipData,"^",67)
	s TStoreLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept", TStoreLocDR)
	s TStartDepreMonth = $p(EquipData,"^",68)
	s TServiceDR = $p(EquipData,"^",69)
	i TServiceDR '=""  d
	.s TService = $p($g(^DHCEQCCode("DHCEQCService",TServiceDR)),"^",1)
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
	s TGuaranteePeriodNum = $p($g(^DHCEQContract(CTRowID)),"^",13)	;$p(EquipData,"^",73)
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
	Set Data=$lb(TRowID,TName,TABCType,TCode,TDesc,TInstallLocDR,TInstallDate,TLeaveFactoryNo,TLeaveFactoryDate,TOpenCheckDate,TCheckDate,TMakeDate,TComputerFlag,TOriginalFee,TNetFee,TNetRemainFee,TGroupDR,TLimitYearsNum,TContractListDR,TDepreMethodDR,TRemark,TDepreTotalFee,TDesignWorkLoadNum,TStatus,TManageUserDR,TMaintUserDR,TProviderHandler,TProviderTel,TAppendFeeTotalFee,TStartDate,TTransAssetDate,TGuaranteeFlag,TInputFlag,TTestFlag,TMedicalFlag,TGuaranteeStartDate,TGuaranteeEndDate,TAddUserDR,TAddDate,TAddTime,TUpdateUserDR,TUpdateDate,TUpdateTime,TCurrencyDR,TInvalidFlag,TStockStatus,TMemoryCode,TUrgencyFlag,TStoreLocDR,TStartDepreMonth,TServiceDR,TInStockListDR,TNo,TModel,TEquiCat,TUnit,TInstallLoc,TCountry,TManageLoc,TManageLevel,TUseLoc,TOrigin,TFromDept,TToDept,TBuyType,TEquipTechLevel,TProvider,TManuFactory,TGroup,TContractList,TDepreMethod,TWorkLoadUnit,TManageUser,TMaintUser,TAddUser,TUpdateUser,TCurrency,TEquipType,TPurchaseType,TPurposeType,TKeeper,TStoreLoc,TService,TInStockList,TQuantity,TBatchFlag,TDisplayStatus,TDisplayStockStatus,TLocation,TGuaranteePeriodNum,TStatCatDR,TStatCat,TFileNo,TRentLocDR,TRentStatus,TFaultStatus,TDisuseDate,TAccountNo,Thold6,Thold7,Thold8,Thold9,Thold10,TAdvanceDisFlag,TInStockNo,TCommonName,TFundsInfo,TPayNo,TUnusualRemark,TRow,TSignDate,CTRowID)
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
*/
}
