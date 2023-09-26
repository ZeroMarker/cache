/// add by csj 2020-04-29 新规范附件web类
Class web.DHCEQ.Plat.CTAffix Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 11;

Parameter SQLCODE = "A_Code";

Parameter SQLDATEFROM;

Parameter SQLDESCRIPTION = "A_Desc";

Parameter SQLDATETO;

Parameter SQLROWID = "A_RowID";

Parameter SQLFILTER = " (A_InvalidFlag = 'N') ";

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT A_Desc,
	   A_RowID,
	   A_Code
FROM sqluser.DHC_EQCAffix
where A_InvalidFlag = 'N' and A_Desc like nvl(:para,'')||'%'
}

/// Add by CSJ 2017-09-12
/// 描述：根据附件代码和附件名称查找附件维护表信息
/// 入参：ACode：附件代码，ADesc：附件名称
/// d ##class(%ResultSet).RunQuery("web.DHCEQCAffix","EQCAffix","","")
Query EQCAffix(ACode As %String = "", ADesc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TCode:%String,TDesc:%String,TRemark:%String,TInvalidFlag:%String")
{
}

ClassMethod EQCAffixExecute(ByRef qHandle As %Binary, ACode As %String = "", ADesc As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQCCode("DHCEQCAffix",rowid)) q:rowid=""  d
	.s TARowID=rowid
	.s TACode=$P($g(^DHCEQCCode("DHCEQCAffix",rowid)),"^",1)
	.q:(ACode'="")&&(TACode'[ACode)
	.s TADesc=$P($g(^DHCEQCCode("DHCEQCAffix",rowid)),"^",2)
	.q:(ADesc'="")&&(TADesc'[ADesc)&&(($ZCONVERT(TACode,"U")'[ADesc))&&((TACode'[ADesc))
	.s TARemark=$P($g(^DHCEQCCode("DHCEQCAffix",rowid)),"^",3)
	.s TAInvalidFlag=$P($g(^DHCEQCCode("DHCEQCAffix",rowid)),"^",4)
	.d OutputRowGetMasterItem
	Quit $$$OK
	
OutputRowGetMasterItem
	s Data=$lb(TARowID,TACode,TADesc,TARemark,TAInvalidFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod EQCAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
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

ClassMethod EQCAffixClose(ByRef qHandle As %Binary) As %Status
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// zx 2020-05-15
/// 目的:系统自动录入附件
/// 描述:检测存放地点表是否存在当前数据.是则返回RowID,否则新增记录并返回RowID
/// 输入: Data:附件名称
/// 输出: 无
/// 返回值: 成功返回RowID, 失败返回错误代码
/// w ##Class(web.DHCEQ.Plat.CTAffix).UpdAffix("稳压电源")
ClassMethod UpdAffix(Data)
{
	Set (ARowID,Code)=""
	Set Desc=$ZCONVERT(Data,"U")
	s CodeInfo=##class(web.DHCEQ.Plat.CTCHanZiEncoding).GetEncoding(Desc,4,"","U")
	s CodeInfo=##class(web.DHCEQ.Plat.JsonObject).FromJSON(CodeInfo)	//CZF0131 2020-01-20
	i CodeInfo.%Get("SQLCODE")=0 s Code=CodeInfo.%Get("Data")
	Set SQLCODE=0
	If Desc="" Quit ""
	&SQL(Select A_RowID Into :ARowID from SQLUSER.DHC_EQCAffix Where A_InvalidFlag='N' and A_Desc=:Desc)
	if ARowID=""
	{
		&SQL(Insert Into SQLUSER.DHC_EQCAffix(A_Code,A_Desc,A_InvalidFlag) Values(:Code,:Desc,'N'))
		if SQLCODE
		{
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
		}
		Set ARowID=$Get(%ROWID)
	}
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ARowID)
}

/*************************************************************************************/
/// Add By DJ 2021-07-12
/// Modified By QW20211224 增加参数TRemark
Query GetEQAffix(EQRowID As %String = "") As %Query(ROWSPEC = "TRowID:%String,TNo:%String,TDesc:%String,TModel:%String,TRemark:%String")
{
}

ClassMethod GetEQAffixExecute(ByRef qHandle As %Binary, EQRowID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	
	i EQRowID="" Quit $$$OK
	
	; Modified By QW20211224 begin
	Set ocldr=$Piece($Get(^DHCEQEquip(EQRowID)),"^",77)
	s EQNo=$Piece($Get(^DHCEQEquip(EQRowID)),"^",71)
	If ocldr'=""
	{
		If $Data(^DHCEQAffix(0,"CheckListDR",ocldr))
		{
			Set affixRowId=0
			s i=0
			For  Set affixRowId=$Order(^DHCEQAffix(0,"CheckListDR",ocldr,affixRowId))  Quit:affixRowId=""  Do
			.Quit:$Piece($Get(^DHCEQAffix(affixRowId)),"^",15)'="N"
			.Quit:$o(^DHCEQAffix(0,"OldRowID",EQRowID,affixRowId,0))>0
			.s i=i+1
			.s TRowID=affixRowId
			.s TNo=EQNo_$p($g(^DHCEQAffix(affixRowId)),"^",29)_i
			.i $d(^DHCEQAffix(affixRowId,"EX")) s TNo=$g(^DHCEQAffix(affixRowId,"EX"))
			.s TDesc=$p($g(^DHCEQAffix(affixRowId)),"^",4)
			.s TModel=$p($g(^DHCEQAffix(affixRowId)),"^",5)
			.d OutputRowGetEQAffix
	
		}
	}
	 ;Modified By QW20211224 end
	s ARowID=0
	s i=0 ; Modified By QW20211224
	f  s ARowID=$o(^DHCEQAffix(0,"Equip",EQRowID,ARowID))  q:ARowID=""  d
	.q:$p($g(^DHCEQAffix(ARowID)),"^",15)="Y"		//MZY0096	2144097		2021-09-16
	.s TRowID=ARowID
	.s i=i+1 ; Modified By QW20211224
	.s TNo=EQNo_$p($g(^DHCEQAffix(ARowID)),"^",9)_i  ;Modified By QW20211224
	.i $d(^DHCEQAffix(ARowID,"EX")) s TNo=$g(^DHCEQAffix(ARowID,"EX"))	// MZY0094	2083597		2021-09-13
	.s TDesc=$p($g(^DHCEQAffix(ARowID)),"^",4)
	.s TModel=$p($g(^DHCEQAffix(ARowID)),"^",5)
	.s TRemark=$p($g(^DHCEQAffix(ARowID)),"^",12)
	.d OutputRowGetEQAffix
	
	Quit $$$OK
OutputRowGetEQAffix
	s Data=$lb(TRowID,TNo,TDesc,TModel,TRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetEQAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
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

ClassMethod GetEQAffixClose(ByRef qHandle As %Binary) As %Status
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// add by wy 2022-6-27
/// GetAffix从web.DHCEQAffix迁移到web.DHCEQ.Plat.CTAffix
/// 描述:GetAffix查询增加验收单ID传入参数,实现设备附件信息与验收单附件信息综合处理
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.Plat.CTAffix","GetAffix","",42,1)
Query GetAffix(EquipDR As %String = "", CheckListDR As %String = "", ConfigFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TAffixDR:%String,TAffixCatDR:%String,TPartSpec:%String,TPartModel:%String,TManuFactoryDR:%String,TQuantityNum:%String,TReceiverDR:%String,TLeaveFacNo:%String,TLeaveDate:%String,TPriceFee:%String,TRemark:%String,TCurrencyDR:%String,TEquip:%String,TAffix:%String,TAffixCat:%String,TManuFactory:%String,TReceiver:%String,TCurrency:%String,TDisuseFlag:%String,TSourceType:%String,TProvider:%String,TTotalFee:%String,TRow:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TAddDate:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TSplitFlag:%String,TInvoiceNo:%String")
{
}

ClassMethod GetAffixExecute(ByRef qHandle As %Binary, EquipDR As %String = "", CheckListDR As %String = "", ConfigFlag As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	s TRow=0
	
	Set TotalFlag=##class(web.DHCEQCommon).GetSysInfo("301006")
	If TotalFlag="1" Set index=2
	Set TotalNum=0
	Set TotalFee=0
	d BuildDataGetAffix
	Quit $$$OK
BuildDataGetAffix
	i CheckListDR'="" d //验收单附件信息
	.f  s rowid=$o(^DHCEQAffix(0,"CheckListDR",CheckListDR,rowid)) q:rowid=""  d
	..;验收明细对应为主设备的附件,附属设备的附件不在其中列出	Mozy	914928	2019-7-11
	..q:ConfigFlag'=""
	..d ResetVariablesGetAffix
	..q:$p($g(^DHCEQAffix(rowid)),"^",15)'="N"
	..s TRowID=rowid
	..s TSourceType="验收单"
	..d GetListInfo
	..d OutputRowGetAffix
	else  if EquipDR'="" d	;Mozy	980018	2019-8-5
	.s SourceID=$p($g(^DHCEQEquip(EquipDR)),"^",77)
	.;s ParentDR=$p($g(^DHCEQEquip(EquipDR,"OtherInfo")),"^",24)	//add by csj 20190508 主设备ID modified by csj 20190524 节点取错了
	.;q:ParentDR'=""	//add by csj 20190508 附属设备不显示附件信息	Mozy	914928	2019-7-11	注释
	.i SourceID'="" d
	..f  s rowid=$o(^DHCEQAffix(0,"CheckListDR",SourceID,rowid)) q:rowid=""  d
	...q:ConfigFlag'=""
	...d ResetVariablesGetAffix
	...s TRowID=rowid
	...s TSourceType="验收单"
	...s NewRowid=$o(^DHCEQAffix(0,"OldRowID",EquipDR,rowid,0))
	...Quit:($D(^DHCEQAffix(0,"OldRowID",EquipDR,rowid)))		;过滤已经生成设备附件的验收单附件记录
	...i NewRowid'="" d
	....s TRowID=NewRowid
	....s TSourceType="改自验收单"
	...q:$p($g(^DHCEQAffix(TRowID)),"^",15)'="N"
	...d GetListInfo
	...d OutputRowGetAffix
	.s NewRowid=0
	.f  s NewRowid=$o(^DHCEQAffix(0,"Equip",EquipDR,NewRowid)) q:NewRowid=""  d
	..d ResetVariablesGetAffix
	..s TRowID=NewRowid
	..s TSourceType="设备"
	..q:$p($g(^DHCEQAffix(TRowID)),"^",15)'="N"
	..;q:$p($g(^DHCEQAffix(TRowID)),"^",21)'=""	;执行标识	0:新增|1:修改|2:删除
	..d GetListInfo
	..d OutputRowGetAffix
	
	If (TotalFlag>0)&&(TotalFlag<3)
	{
		If TotalFlag="1" Set index=1
		Do ResetVariablesGetAffix
		Set TRow="合计:"
		Set TQuantityNum=TotalNum
		Set TTotalFee=TotalFee
		d OutputRowGetAffix
	}
	
	quit
GetListInfo
	s TAffixDR = $p($g(^DHCEQAffix(TRowID)),"^",2)
	i TAffixDR '=""  d
	.s TAffix = $p($g(^DHCEQCCode("DHCEQCAffix",TAffixDR)),"^",2)
	s TAffixCatDR = $p($g(^DHCEQAffix(TRowID)),"^",3)
	i TAffixCatDR '=""  d
	.s TAffixCat = $p($g(^DHCEQCCode("DHCEQCAffixCat",TAffixCatDR)),"^",2)
	s TPartSpec = $p($g(^DHCEQAffix(TRowID)),"^",4)
	s TPartModel = $p($g(^DHCEQAffix(TRowID)),"^",5)
	s TManuFactoryDR = $p($g(^DHCEQAffix(TRowID)),"^",6)
	i TManuFactoryDR '=""  d
	.s TManuFactory = ##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactoryDR)	//$p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1) 	//modified by CZF0093
	s TQuantityNum = +$p($g(^DHCEQAffix(TRowID)),"^",7)
	s TReceiverDR = $p($g(^DHCEQAffix(TRowID)),"^",8)
	i TReceiverDR '=""  d
	.s TReceiver = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TReceiverDR)
	s TLeaveFacNo = $p($g(^DHCEQAffix(TRowID)),"^",9)
	s TLeaveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAffix(TRowID)),"^",29),"date")	//Mozy	2019-7-12
	s TPriceFee = +$p($g(^DHCEQAffix(TRowID)),"^",11)
	Set TTotalFee=TPriceFee*TQuantityNum
	Set TotalFee=TotalFee+TTotalFee
	Set TotalNum=TotalNum+TQuantityNum
	s TRemark = $p($g(^DHCEQAffix(TRowID)),"^",12)
	s TCurrencyDR = $p($g(^DHCEQAffix(TRowID)),"^",13)
	i TCurrencyDR '="" s TCurrency = ##Class(web.DHCEQCommon).GetTrakNameByID("uom",TCurrencyDR)
	s TDisuseFlag=$p($g(^DHCEQAffix(TRowID)),"^",14)
	s ProviderDR=$p($g(^DHCEQAffix(TRowID)),"^",24)
	i ProviderDR'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)
	//Mozy	2019-7-12
	s TGuaranteeStartDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAffix(TRowID)),"^",25),"date")
	s TGuaranteeEndDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAffix(TRowID)),"^",26),"date")
	s TSplitFlag = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAffix(TRowID)),"^",27),"bool")
	i $d(^DHCEQAffix(TRowID,"EX")) s TLeaveFacNo=$g(^DHCEQAffix(TRowID,"EX"))
	s TAddDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQAffix(TRowID)),"^",10),"date")
	s TInvoiceNo=$p($g(^DHCEQAffix(TRowID)),"^",28)
	s THold1=$p($g(^DHCEQAffix(TRowID)),"^",30)
	s THold2=$p($g(^DHCEQAffix(TRowID)),"^",31)
	s THold3=$p($g(^DHCEQAffix(TRowID)),"^",32)
	s THold4=$p($g(^DHCEQAffix(TRowID)),"^",33)
	s THold5=$p($g(^DHCEQAffix(TRowID)),"^",34)
	
	Set TRow=TRow+1
	quit
OutputRowGetAffix
	Set Data=$lb(TRowID,TEquipDR,TAffixDR,TAffixCatDR,TPartSpec,TPartModel,TManuFactoryDR,TQuantityNum,TReceiverDR,TLeaveFacNo,TLeaveDate,TPriceFee,TRemark,TCurrencyDR,TEquip,TAffix,TAffixCat,TManuFactory,TReceiver,TCurrency,TDisuseFlag,TSourceType,TProvider,TTotalFee,TRow,THold1,THold2,THold3,THold4,THold5,TAddDate,TGuaranteeStartDate,TGuaranteeEndDate,TSplitFlag,TInvoiceNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAffix
	s (TRowID,TEquipDR,TAffixDR,TAffixCatDR,TPartSpec,TPartModel,TManuFactoryDR,TQuantityNum,TReceiverDR,TLeaveFacNo,TLeaveDate,TPriceFee,TRemark,TCurrencyDR,TEquip,TAffix,TAffixCat,TManuFactory,TReceiver,TCurrency,TDisuseFlag,TSourceType,TProvider,TTotalFee,THold1,THold2,THold3,THold4,THold5,TAddDate,TGuaranteeStartDate,TGuaranteeEndDate,TSplitFlag,TInvoiceNo)=""
	quit
}

ClassMethod GetAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAffixExecute ]
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

ClassMethod GetAffixClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAffixExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// add by wy 2022-6-27
/// GetAffixList从DHCEQAffix迁移到web.DHCEQ.Plat.CTAffix
/// d ##class(%ResultSet).RunQuery("web.DHCEQAffix","GetAffixList","")
Query GetAffixList(desc As %Library.String = "") As %Query(ROWSPEC = "TRow:%String:序号,TPartSpec:%String:附件名称,TEncoding:%String:简称,TPartModel:%String:附件型号,Hidden:%String,TUnit:%String:单位")
{
}

ClassMethod GetAffixListExecute(ByRef qHandle As %Binary, desc As %Library.String = "") As %Status
{
 	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	s TRow=0
	Set TempID=$I(^DHCEQTemp("web.DHCEQAffix.GetAffixList",+$H))
	Do ##Class(web.DHCEQCommon).KillTempGlobalNew("web.DHCEQAffix.GetAffixList",TempID)
	Set desc=$ZCONVERT(desc,"U")
	
	s RowID=""
	f  s RowID=$o(^DHCEQAffix(RowID))  quit:RowID=""  d
	.Quit:$p($g(^DHCEQAffix(RowID)),"^",15)'="N"
	.s PartSpec=$p($g(^DHCEQAffix(RowID)),"^",4)
	.s Encoding=##class(web.DHCEQCHanZiEncoding).GetEncoding(PartSpec)
	.q:(desc'="")&&(PartSpec'[desc)&&(Encoding'[desc)
	.s PartModel=$p($g(^DHCEQAffix(RowID)),"^",5)
	.s CurrencyDR=$p($g(^DHCEQAffix(RowID)),"^",13)
	.i PartModel="" d
	..Set ^DHCEQTemp("web.DHCEQAffix.GetAffixList",+$H,TempID,Encoding,PartSpec,-99999,+CurrencyDR)=""
	.e  d
	..Set ^DHCEQTemp("web.DHCEQAffix.GetAffixList",+$H,TempID,Encoding,PartSpec,PartModel,+CurrencyDR)=""
	
	s Encoding=""
	f  s Encoding=$o(^DHCEQTemp("web.DHCEQAffix.GetAffixList",+$H,TempID,Encoding)) quit:Encoding=""  d
	.s PartSpec=""
	.f  s PartSpec=$o(^DHCEQTemp("web.DHCEQAffix.GetAffixList",+$H,TempID,Encoding,PartSpec)) quit:PartSpec=""  d
	..s tmpPartModel=""
	..f  s tmpPartModel=$o(^DHCEQTemp("web.DHCEQAffix.GetAffixList",+$H,TempID,Encoding,PartSpec,tmpPartModel)) quit:tmpPartModel=""  d
	...s PartModel=tmpPartModel
	...i tmpPartModel=-99999 s PartModel=""
	...s CurrencyDR=""
	...f  s CurrencyDR=$o(^DHCEQTemp("web.DHCEQAffix.GetAffixList",+$H,TempID,Encoding,PartSpec,tmpPartModel,CurrencyDR)) quit:CurrencyDR=""  d
	....s Unit=""
	....i CurrencyDR'=0 s Unit=##Class(web.DHCEQCommon).GetTrakNameByID("uom",CurrencyDR)
	....d OutputRowGetAffixList
	
	Quit $$$OK
	
OutputRowGetAffixList
	s TRow=TRow+1
	Set Data=$lb(TRow,PartSpec,Encoding,PartModel,CurrencyDR,Unit)
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

ClassMethod GetAffixListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAffixListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
