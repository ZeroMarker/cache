Import SQLUser

/// ---------------------------------------------
/// Modified By DJ 2011-06-01
/// Discription:GetAffixDetail查询中供应商未解析,使用科室未清空
/// ----------------------------------------------
/// Modified by DJ 2010-03-19 DJ0042
/// Discription:附件增加供应商信息
/// ----------------------------------------------
/// Modified by JDL 2009-06-5  JDL0013
/// Modified method:GetAffix,GetAffixByID
/// 用币种代替作为设备单位
/// ---------------------------------------------
Class web.DHCEQAffix Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 96;

ClassMethod GetAffixByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQAffix(rowid)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;AffixDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAffix",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;AffixCatDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAffixCat",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("manufacturer",$p(result,"^",6))	//$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",6))),"^",1)	//modified by CZF0093
	s resultex=resultex_"^"	;ReceiverDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",8))
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")	;AddDate	//Mozy	2019-7-12
	s resultex=resultex_"^"	;CurrencyDR
	i $p(result,"^",13)'=""  d
	.;s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cur",$p(result,"^",13))
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",13))
	s ProviderDR=$p($g(^DHCEQAffix(rowid)),"^",24)
	s Provider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)	// MZY0098	2021-10-15
	s $p(result,"^",25)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",25),"date")
	s $p(result,"^",26)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",26),"date")
	s $p(result,"^",27)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",27),"bool")
	s $p(result,"^",29)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",29),"date")		//Mozy	2019-7-12
	s LeaveFacNoInfo=$p(result,"^",9)
	i $d(^DHCEQAffix(rowid,"EX")) s LeaveFacNoInfo=$g(^DHCEQAffix(rowid,"EX"))
	q result_resultex_"^"_ProviderDR_"^"_Provider_"^"_LeaveFacNoInfo
}

/// 修改:2009-08-19 党军 begin
/// 描述:设备与验收单附件信息操作,设备更改对应验收单附件时,验收单附件不发生变化
///     而增加一条设备操作验收单记录。
ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", CheckListDR As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s SQLCODE=0
 s rowid=$p(val,"^",1)
 i rowid'="" s OCLDR=$p($g(^DHCEQAffix(rowid)),"^",19)
 s EquipDR=$p(val,"^",2)
 s PLIST(2) = $p(val,"^",2)	;EquipDR
 TSTART
 i (+isDel=1)
 {
	 i (CheckListDR'="")||(OCLDR="") //验收单或设备删除自己本身的附件
	 {
		 &SQL(update SQLUSER.DHC_EQAffix set AF_InvalidFlag='Y' where AF_RowID = :rowid)
	 }
	 if SQLCODE
	 {
		 TROLLBACK
		 q SQLCODE
	 }
	 i (OCLDR'="")&&(EquipDR'="")
	 {
		 s PLIST(15)="N"
		 s PLIST(16)="Y"
		 s PLIST(21)=rowid
		 s PLIST(22)="2" 
		 &SQL(Insert Into SQLUSER.DHC_EQAffix Values :PLIST())
	 }
 	 if SQLCODE
 	 {
	 	 TROLLBACK
	 	 q SQLCODE
 	 }
	&SQL(update SQLUSER.DHC_EQFunds set F_InvalidFlag='Y' where F_SourceType=2 and F_SourceID = :rowid)
 	 if (SQLCODE)&(SQLCODE'=100)
 	 {
	 	 TROLLBACK
	 	 q SQLCODE
 	 }
 	 TCOMMIT
 	 q rowid
 }
 s PLIST(3) = $p(val,"^",3)	;AffixDR
 s PLIST(4) = $p(val,"^",4)	;AffixCatDR
 s PLIST(5) = $p(val,"^",5)	;PartSpec
 s PLIST(6) = $p(val,"^",6)	;PartModel
 s PLIST(7) = $p(val,"^",7)	;ManuFactoryDR
 s PLIST(8) = $p(val,"^",8)	;QuantityNum
 s PLIST(9) = $p(val,"^",9)	;ReceiverDR
 s PLIST(10) = $p(val,"^",10)	;LeaveFacNo
 s PLIST(11) = $p(val,"^",11)	;LeaveDate
 i $p(val,"^",11)'=""  s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;AddDate	增加日期	//Mozy	2019-7-12
 s PLIST(12) = $p(val,"^",12)	;PriceFee
 s PLIST(13) = $p(val,"^",13)	;Remark
 s PLIST(14) = $p(val,"^",14)	;CurrencyDR 
 s PLIST(15) = "N"			;AF_DisuseFlag
 s PLIST(16) = "N"			;AF_InvalidFlag
 s PLIST(20) = CheckListDR  ;AF_CheckListDR
 s PLIST(25)=$p(val,"^",15) ;ProviderDR
  //Mozy	2019-7-12
 s PLIST(26)=$p(val,"^",16)
 i $p(val,"^",16)'=""  s PLIST(26) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",16),"date")	;GuaranteeStartDate	保修开始日期
 s PLIST(27)=$p(val,"^",17)
 i $p(val,"^",17)'=""  s PLIST(27) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",17),"date")	;GuaranteeEndDate	保修截止日期
 s PLIST(28)=$p(val,"^",18)
 i $p(val,"^",18)'=""  s PLIST(28) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",18),"bool")	;SplitFlag	拆分标记
 s LeaveFacNoInfo=$TRANSLATE($p(val,"^",19),"，",",")	//Mozy	2017-2-2
 s PLIST(29)=$p(val,"^",20)		;InvoiceNo
 s PLIST(30)=$p(val,"^",21)
 i $p(val,"^",21)'=""  s PLIST(30) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",21),"date")	;LeaveDate	出厂日期
 s PLIST(32)=$p(val,"^",22)		;医疗注册证号
 s PLIST(33)=$p(val,"^",23)		;建议年限
 
 if (rowid'="") 
 {
	 i (CheckListDR'="")||(OCLDR="") //验收单或设备更新自己本身的附件
	 {
		 &SQL(Update SQLUSER.DHC_EQAffix Values :PLIST() where AF_RowID = :rowid) 
	 }
	 if SQLCODE
	 {
		 TROLLBACK
		 q SQLCODE
	 }
	 i (OCLDR'="")&&(EquipDR'="")
	 {
		 ;Add By QW20210629 BUG:QW0130 增加序号 begin
		 s nextno=""
 	 	 &SQL(select AF_Hold1 into :nextno from sqluser.DHC_EQAffix where AF_RowID = :rowid)
	 	 s PLIST(31)=nextno
	 	 ;Add By QW20210629 BUG:QW0130 增加序号 end
		 s PLIST(21)=rowid
		 s PLIST(22)="1" 
		 &SQL(Insert Into SQLUSER.DHC_EQAffix Values :PLIST())
	 }
 }
 else
 {	 
 	 ;Add By QW20210629 BUG:QW0130 增加序号 begin
 	 s enextno=""
 	 s nnextno=""
 	 &SQL(select max(AF_Hold1) into :nnextno from sqluser.DHC_EQAffix where AF_CheckListDR = :CheckListDR and AF_SplitFlag='N')
 	 &SQL(select max(AF_Hold1) into :enextno from sqluser.DHC_EQAffix where AF_EquipDR = :EquipDR)
	 s PLIST(31)=nnextno+1
	 if enextno>nnextno  s PLIST(31)=enextno+1
	 ;Add By QW20210629 BUG:QW0130 增加序号 end
	 &SQL(Insert Into SQLUSER.DHC_EQAffix Values :PLIST())
 }
 if SQLCODE
 {
	 TROLLBACK
	 q SQLCODE
 }
 Set ID=$g(%ROWID)
 If LeaveFacNoInfo'="" Do
 .Set ^DHCEQAffix(ID,"EX")=LeaveFacNoInfo
 Else  Do
 .Kill ^DHCEQAffix(ID,"EX")
 s AffixAmount=$p(val,"^",8)*$p(val,"^",12)	;;QuantityNum*PriceFee
 s SQLCODE=##Class(web.DHCEQ.EM.BUSFunds).ChangeFundsBySourceIDNew(2,ID,AffixAmount)
 if SQLCODE
 {
	 TROLLBACK
	 q SQLCODE
 }
 TCOMMIT
 q ID
}

/// ConfigFlag:来源配置设备标志
/// 修改:2009-08-19 党军 begin
/// 描述:GetAffix查询增加验收单ID传入参数,实现设备附件信息与验收单附件信息综合处理
/// d ##class(%ResultSet).RunQuery("web.DHCEQAffix","GetAffix",43019)
/// d ##class(%ResultSet).RunQuery("web.DHCEQAffix","GetAffix","",42,1)
Query GetAffix(EquipDR As %String = "", CheckListDR As %String = "", ConfigFlag As %String = "") As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TAffixDR:%String,TAffixCatDR:%String,TPartSpec:%String,TPartModel:%String,TManuFactoryDR:%String,TQuantityNum:%String,TReceiverDR:%String,TLeaveFacNo:%String,TLeaveDate:%String,TPriceFee:%String,TRemark:%String,TCurrencyDR:%String,TEquip:%String,TAffix:%String,TAffixCat:%String,TManuFactory:%String,TReceiver:%String,TCurrency:%String,TDisuseFlag:%String,TSourceType:%String,TProvider:%String,TTotalFee:%String,TRow:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TAddDate:%String,TGuaranteeStartDate:%String,TGuaranteeEndDate:%String,TSplitFlag:%String,TInvoiceNo:%String,TRegisterNo:%String,TLimitYears:%String")
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
	s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",ProviderDR)		// MZY0098	2021-10-15
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
	s TRegisterNo=$p($g(^DHCEQAffix(TRowID)),"^",31)
	s TLimitYears=$p($g(^DHCEQAffix(TRowID)),"^",32)
	
	Set TRow=TRow+1
	quit
OutputRowGetAffix
	Set Data=$lb(TRowID,TEquipDR,TAffixDR,TAffixCatDR,TPartSpec,TPartModel,TManuFactoryDR,TQuantityNum,TReceiverDR,TLeaveFacNo,TLeaveDate,TPriceFee,TRemark,TCurrencyDR,TEquip,TAffix,TAffixCat,TManuFactory,TReceiver,TCurrency,TDisuseFlag,TSourceType,TProvider,TTotalFee,TRow,THold1,THold2,THold3,THold4,THold5,TAddDate,TGuaranteeStartDate,TGuaranteeEndDate,TSplitFlag,TInvoiceNo,TRegisterNo,TLimitYears)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAffix
	s (TRowID,TEquipDR,TAffixDR,TAffixCatDR,TPartSpec,TPartModel,TManuFactoryDR,TQuantityNum,TReceiverDR,TLeaveFacNo,TLeaveDate,TPriceFee,TRemark,TCurrencyDR,TEquip,TAffix,TAffixCat,TManuFactory,TReceiver,TCurrency,TDisuseFlag,TSourceType,TProvider,TTotalFee,THold1,THold2,THold3,THold4,THold5,TAddDate,TGuaranteeStartDate,TGuaranteeEndDate,TSplitFlag,TInvoiceNo,TRegisterNo,TLimitYears)=""
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

ClassMethod DisuseAffix(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid, remark)
{
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	s equipdr=$p($g(^DHCEQAffix(rowid)),"^",1)
	s month=""
	s depresetid=$o(^DHCEQDepreSet(0,"EquipMain",equipdr,"Y",0))
	i depresetid="" q -1003
	i $p($g(^DHCEQAffix(rowid)),"^",14)="Y"  q -1002
	TSTART
	&SQL(Update SQLUSER.DHC_EQAffix set AF_DisuseFlag='Y',AF_UpdateUserDR=:User,AF_UpdateDate=:Date,AF_UpdateTime=:Time,AF_Remark=:remark where AF_RowID = :rowid)
	i SQLCODE'=0
	{	TROLLBACK
		q SQLCODE}
	s SQLCODE=##class(web.DHCEQMonthDepreset).GenerateMonthDepre(equipdr, month, depresetid,"N","2",rowid)
	i SQLCODE'=0
	{	TROLLBACK
		q SQLCODE}
	TCOMMIT
	q 0
}

/// 获取设备附件信息
/// w ##Class(web.DHCEQAffix).GetAffixsInfoByEquip(42999)
ClassMethod GetAffixsInfoByEquip(EquipDR)
{
	new affixRowId,affixsInfo,oclddr
	if EquipDR="" q ""
	s affixsInfo=""
	Set ocldr=$Piece($Get(^DHCEQEquip(EquipDR)),"^",77)
	If ocldr'=""
	{
		If $Data(^DHCEQAffix(0,"CheckListDR",ocldr))
		{
			Set affixRowId=""
			For  Set affixRowId=$Order(^DHCEQAffix(0,"CheckListDR",ocldr,affixRowId))  Quit:affixRowId=""  Do
			.Quit:$Piece($Get(^DHCEQAffix(affixRowId)),"^",15)'="N"
			.Quit:$o(^DHCEQAffix(0,"OldRowID",EquipDR,affixRowId,0))>0
			.If affixsInfo'="" Set affixsInfo=affixsInfo_"&"
			.Set affixsInfo=affixsInfo_..GetAffixByID("","",affixRowId)
		}
	}
	s affixRowId=0
	f  s affixRowId=$o(^DHCEQAffix(0,"Equip",EquipDR,affixRowId))  quit:affixRowId=""  d
	.q:$p($g(^DHCEQAffix(affixRowId)),"^",15)'="N"
	.if affixsInfo'="" s affixsInfo=affixsInfo_"&"
	.Set affixsInfo=affixsInfo_..GetAffixByID("","",affixRowId)
	q affixsInfo
}

/// czf 2022-10-08
/// 根据验收单获取附件信息
/// w ##Class(web.DHCEQAffix).GetAffixsInfoByOpenCheck(1)
ClassMethod GetAffixsInfoByOpenCheck(OCLDR)
{
	s affixsInfo=""
	i OCLDR="" q ""
	If $Data(^DHCEQAffix(0,"CheckListDR",OCLDR))
	{
		Set affixRowId=""
		For  Set affixRowId=$Order(^DHCEQAffix(0,"CheckListDR",OCLDR,affixRowId))  Quit:affixRowId=""  Do
		.Quit:$Piece($Get(^DHCEQAffix(affixRowId)),"^",15)'="N"
		.If affixsInfo'="" Set affixsInfo=affixsInfo_"&"
		.Set affixsInfo=affixsInfo_..GetAffixByID("","",affixRowId)
	}
	q affixsInfo
}

Query GetAffixByEquip(para) As %SQLQuery(ROWSPEC = "AffixDesc:%String,Model:%String,QtyNum:%String,Price:%String")
{
	select AF_AffixDR->A_Desc as AffixDesc,AF_PartModel as Model,AF_QuantityNum as  QtyNum,AF_PriceFee as Price 
	from SQLUSER.dhc_eqaffix where AF_EquipDR=:para
}

/// add by jdl 2009-06-24 JDL0007
/// 判断增加附件是否需要提示或直接变更
ClassMethod GetChangeAccountFlag(affixid)
{
	if affixid="" q 0
	s flag=##class(web.DHCEQCommon).GetSysInfo("401004")
	if ((flag=0)||(flag="")) q 0
	s equipdr=$p($g(^DHCEQAffix(affixid)),"^",1)
	if equipdr="" q 0
	if ($p($g(^DHCEQEquip(equipdr)),"^",60)="1")||($p($g(^DHCEQEquip(equipdr)),"^",60)="2")
	{
		q flag
	}
	else
	{
		q 0
	}
}

/// add by jdl 2009-06-24 JDL0007
ClassMethod ChangeAccountByAffix(affixid)
{
	if affixid="" q ""
	s affixinfo=$g(^DHCEQAffix(affixid))
	if affixinfo="" q ""
	
	s RowID=""
	s EquipDR=$p(affixinfo,"^",1)
	s qty=+$p(affixinfo,"^",7)
	s price=+$p(affixinfo,"^",11)
	s ChangeFee=qty*price
	;q "数量:"_qty_" 单价:"_price_" 金额:"_ChangeFee_" 设备:"_EquipDR
	if (ChangeFee="")||(ChangeFee=0) q ""
	if (EquipDR="") q ""
	s ChangeDate=##Class(web.DHCEQCommon).TransValueToPage(+$h,"date")
	s ChangeReason="增加附件:"_$p(affixinfo,"^",4)_";数量:"_$p(affixinfo,"^",7)_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(affixinfo,"^",13))_",共计金额:"_ChangeFee
	
	s ChangeItem=""
	s ChangeReasonDR=""
	s TotalDepreFee=$p(^DHCEQEquip(EquipDR),"^",35)
	
	s Remark=""	
	s Status=""
	
	s OriginalFee=$p(^DHCEQEquip(EquipDR),"^",27)
	s NetFee=$p(^DHCEQEquip(EquipDR),"^",28)
	s NetRemainFee=$p(^DHCEQEquip(EquipDR),"^",29)
	s ChangedNetRemainFee=NetRemainFee
	
	s ChangedOriginalFee=+OriginalFee+ChangeFee
	s ChangedNetFee=+NetFee+ChangeFee
	
	s changeAccountData=""_"^"_EquipDR_"^"_ChangeFee_"^"_ChangedOriginalFee_"^"_ChangedNetFee_"^"_TotalDepreFee_"^"_ChangeItem_"^"_ChangeReasonDR_"^"_ChangeReason_"^"_ChangeDate_"^"_Remark_"^"_Status
	s changeAccountData=changeAccountData_"^^^^^^^^^^^^"
	s changeAccountData=changeAccountData_"^"_OriginalFee_"^"_NetFee_"^"_NetRemainFee_"^"_ChangedNetRemainFee
	s changeAccountData=changeAccountData_"^Y^,"_affixid_":Y,"
	s changeAccountId=##Class(web.DHCEQChangeAccount).SaveData("","",changeAccountData)
	
	q changeAccountId
}

/// ##Class(web.DHCEQAffix).GetLinkIcon(rs.GetDataByName("TEquipDR"),rs.GetDataByName("TSourceType"),rs.GetDataByName("TSourceID"))
ClassMethod GetLinkIcon(EquipDR As %Library.String, SourceType As %Library.String, SourceID As %Library.String)
{
	i EquipDR'="" q "webemr/regalert2.gif"
	i (SourceType'=1)&&(SourceID'="") q "webemr/regalert2.gif"
	q ""
}

/// MZY0098	2021-10-15	增加输出附件数量TQuantityNum
/// 创建：Mozy 2010-4-26
/// 描述：返回设备附件查询(台帐)
/// 访问表:DHC_EQAffix
/// 输入：Desc：描述
/// 输出：无
/// 返回：成功返回记录，否则返回出错信息
/// 备注： TRowID,TEquipDR,TEQName,TEQNo,TOriginalFee,TChangeFee,TAffixName,TAffixLeaveFacNo,TAffixFee,TAffixModel
/// d ##class(%ResultSet).RunQuery("web.DHCEQAffix","GetAffixDetail","","417","","","","","","","","","")
Query GetAffixDetail(EQName, EQNo, AffixName, AffixLeaveFacNo, AffixFeeFrom, AffixFeeTo, Hold2, StartDate, EndDate, Provider, UseLocDR) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TEQName:%String,TEQNo:%String,TOriginalFee:%String,TChangeFee:%String,TAffixName:%String,TAffixLeaveFacNo:%String,TAffixFee:%String,TAffixModel:%String,TLeaveDate:%String,TProvider:%String,TUseLoc:%String,TRow:%String,TFileNo:%String,TCommonName:%String,TQuantityNum:%String,TJob:%String")
{
}

ClassMethod GetAffixDetailExecute(ByRef qHandle As %Binary, EQName, EQNo, AffixName, AffixLeaveFacNo, AffixFeeFrom, AffixFeeTo, Hold2, StartDate, EndDate, Provider, UseLocDR) As %Status
{
 	new repid, index,rowid,flag
	Set repid=$I(^CacheTemp)
 	Set qHandle=$ListBuild(0,repid,0)
	Set index=1
	Set rowid=0
	Set gnum=1
	
	s StartDate=##class(web.DHCEQCommon).TransValueFromPage(StartDate,"date") //add by sjh 2019-12-04 BUG00019 ---begin
	s EndDate=##class(web.DHCEQCommon).TransValueFromPage(EndDate,"date") //add by sjh 2019-12-04 BUG00019 ---end  日期转换
	
	If StartDate="" Set StartDate=0
 	If EndDate="" Set EndDate=+$H
 	Set curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
 	Kill ^DHCEQTemp("AffixDetail",curuser)
	// MZY0145	3081069		2022-11-30
	Kill ^DHCEQTemp("EQAffixDetail",curuser)
	Set Job=$job
 	Set TRow=0
	Do BuildDataGetAffixDetail
	Quit $$$OK
BuildDataGetAffixDetail
	For  Set rowid=$Order(^DHCEQAffix(rowid)) Quit:rowid=""  Do
	.Do ResetVariablesGetAffixDetail
	.Quit:$Piece($Get(^DHCEQAffix(rowid)),"^",15)'="N"
	.Set TRowID=rowid
	.
	.Set TEquipDR=$Piece($Get(^DHCEQAffix(TRowID)),"^",1)
	.If TEquipDR'="" Do
	..;入库完成生成台帐信息
	..Do GetAffixDetailInfo
	.Else  Do
	..;验收单的附件信息(旧数据)
	..;验收单设备的附件显示
	..Set CheckListDR=$Piece($Get(^DHCEQAffix(TRowID)),"^",19)
	..;Set TEquip=$Piece($Get(^DHCEQOpenCheckList(CheckListDR)),"^", 2) //设备
	..Set TEquipDR=0
	..For  Set TEquipDR=$Order(^DHCEQEquip(0,"OpenCheckList",CheckListDR,TEquipDR)) Quit:TEquipDR=""  Do
	...Quit:($D(^DHCEQAffix(0,"OldRowID",TEquipDR,TRowID)))		;过滤已经生成设备附件的验收单附件记录
	...Quit:$p($g(^DHCEQEquip(TEquipDR,"OtherInfo")),"^",24)'=""	;Mozy	914928	2019-7-11
	...Do GetAffixDetailInfo
	Quit
	
GetAffixDetailInfo
	Set TCommonName=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",1)
	Set TItemDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",7)
	i TItemDR'="" s TEQName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TItemDR)),"^",1)
	Set TEQNo=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",71)
	Set TOriginalFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQEquip(TEquipDR)),"^",27),"")
	Set TInvalidFlag=$p($g(^DHCEQEquip(TEquipDR)),"^",59)
	Quit:TInvalidFlag="Y"		;无效设备
	Set TStockStatus=$p($g(^DHCEQEquip(TEquipDR)),"^",60)
	Set TChangeFee=##Class(web.DHCEQCommon).FormatNumber(##Class(web.DHCEQEquip).GetChangedAmount(TEquipDR),"")
	Quit:(EQName'="")&&(TCommonName'[EQName)
	Quit:(EQNo'="")&&(TEQNo'[EQNo)
	Quit:(TStockStatus=0)		;过滤验收未生成台帐的设备附件
	Set TAffixName=$Piece($Get(^DHCEQAffix(TRowID)),"^",4)
	Quit:(AffixName'="")&&(TAffixName'[AffixName)
	Set TAffixModel=$Piece($Get(^DHCEQAffix(TRowID)),"^",5)
	Set TAffixLeaveFacNo=$Piece($Get(^DHCEQAffix(TRowID)),"^",9)
	i TAffixLeaveFacNo="" s TAffixLeaveFacNo=$g(^DHCEQAffix(TRowID,"EX")) ///279541  Add BY BRB 2016-11-04 增加从(^DHCEQAffix(TRowID)),"^",9)获取不到的设备编号
	Quit:(AffixLeaveFacNo'="")&&(TAffixLeaveFacNo'[AffixLeaveFacNo)
	Set TAffixFee=##Class(web.DHCEQCommon).FormatNumber($Piece($Get(^DHCEQAffix(TRowID)),"^",11),"")
	If TAffixFee="" Set TAffixFee=0
	Quit:(AffixFeeFrom'="")&&(TAffixFee<AffixFeeFrom)
	Quit:(AffixFeeTo'="")&&(TAffixFee>AffixFeeTo)
	Set THold2=$Piece($Get(^DHCEQAffix(TRowID)),"^",26)
	Quit:(Hold2="on")&&(THold2'="Y")
	Set flag="N"
	Set TLeaveDate=$Piece($Get(^DHCEQAffix(TRowID)),"^",10)
	Quit:(TLeaveDate>EndDate)
	Quit:(StartDate'="")&&(TLeaveDate<StartDate)
	If TLeaveDate'="" Set TLeaveDate=##Class(web.DHCEQCommon).TransValueToPage(TLeaveDate,"date")
	Set TProvider=$p($g(^DHCEQAffix(TRowID)),"^",24)	;AF_ProviderDR	 MZY0098	2021-10-15
	Quit:(Provider'="")&&(TProvider'[Provider)
	If TProvider'="" s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider) //2011-06-01 DJ
	Set TUseLocDR = $Piece($Get(^DHCEQEquip(TEquipDR)),"^",19)
	Quit:(UseLocDR'="")&&(TUseLocDR'=UseLocDR)
	If TUseLocDR '="" Set TUseLoc = ##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	Set TEquipTypeDR=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",63)
	Quit:##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR)
	Set TFileNo=$Piece($Get(^DHCEQEquip(TEquipDR)),"^",85)
	Set TQuantityNum=$Piece($Get(^DHCEQAffix(TRowID)),"^",7)	// MZY0098	2021-10-15
	Do OutputRowGetAffixDetail
	Quit
	
ResetVariablesGetAffixDetail
	Set (TRowID,TEquipDR,TEQName,TEQNo,TOriginalFee,TChangeFee,TAffixName,TAffixLeaveFacNo,TAffixFee,TAffixModel,TLeaveDate,TProvider,TUseLoc,TFileNo,TCommonName,TQuantityNum)=""
	Quit
OutputRowGetAffixDetail
	Set TRow=TRow+1
	Set Data=$ListBuild(TRowID,TEquipDR,TEQName,TEQNo,TOriginalFee,TChangeFee,TAffixName,TAffixLeaveFacNo,TAffixFee,TAffixModel,TLeaveDate,TProvider,TUseLoc,TRow,TFileNo,TCommonName,TQuantityNum,Job)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Set ^DHCEQTemp("AffixDetail",curuser,gnum)=TRowID_"^"_TEquipDR_"^"_TEQName_"^"_TEQNo_"^"_TOriginalFee_"^"_TChangeFee_"^"_TAffixName_"^"_TAffixLeaveFacNo_"^"_TAffixFee_"^"_TAffixModel_"^"_TLeaveDate_"^"_TProvider_"^"_TUseLoc_"^"_TFileNo_"^"_TCommonName_"^"_TQuantityNum
	Set ^DHCEQTemp("EQAffixDetail",curuser,Job,gnum)=$g(^DHCEQTemp("AffixDetail",curuser,gnum))		// MZY0145	3081069		2022-11-30
	Set gnum=gnum+1
	Quit
}

ClassMethod GetAffixDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAffixDetailExecute ]
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
	Set qHandle=$ListBuild(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetAffixDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetAffixDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 	Mozy0025
ClassMethod GetNum()
{
	Set curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set gnum=$Order(^DHCEQTemp("AffixDetail",curuser,""),-1)
 	
  	Quit gnum
}

/// 	Mozy0025
ClassMethod GetList(gnum)
{
	Set curuser=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	Set str=^DHCEQTemp("AffixDetail",curuser,gnum)
	
  	Quit str
}

/// 创建:MoZY 2011-5-11
/// 目的:复制附件
/// 描述:复制选中附件的全部信息
/// 输入:
/// 输出:
/// 返回值: 成功返回复制后的附件单RowID
/// w ##Class(web.DHCEQAffix).CopyAffix("12")
ClassMethod CopyAffix(rowid)
{
	New AFRowID
	
	TSTART
		&SQL(Insert Into sqluser.DHC_EQAffix
			(AF_EquipDR,AF_AffixDR,AF_AffixCatDR,AF_PartSpec,AF_PartModel,AF_ManuFactoryDR,
		 	AF_QuantityNum,AF_ReceiverDR,AF_LeaveFacNo,AF_LeaveDate,AF_PriceFee,
		 	AF_Remark,AF_CurrencyDR,AF_DisuseFlag,AF_InvalidFlag,
		 	AF_CheckListDR,AF_OldRowID,AF_OperFlag)
			Select AF_EquipDR,AF_AffixDR,AF_AffixCatDR,AF_PartSpec,AF_PartModel,AF_ManuFactoryDR,
		 	AF_QuantityNum,AF_ReceiverDR,AF_LeaveFacNo,AF_LeaveDate,AF_PriceFee,
		 	AF_Remark,AF_CurrencyDR,AF_DisuseFlag,AF_InvalidFlag,
		 	AF_CheckListDR,AF_OldRowID,AF_OperFlag
 			From sqluser.DHC_EQAffix Where AF_RowID=:rowid)
 		Set AFRowID=$G(%ROWID)
	If SQLCODE
	{
		TROLLBACK
		Quit SQLCODE
	}			

 	TCOMMIT
 	Quit AFRowID
}

/// Mozy	2016-6-27
/// 获取设备所有附件DR
/// w ##Class(web.DHCEQAffix).GetAffixDRsByEquip(42999)
ClassMethod GetAffixDRsByEquip(EquipDR As %Library.String = "")
{
	new affixRowId,affixsInfo,oclddr
	if EquipDR="" q ""
	s affixsInfo=""
	Set ocldr=$Piece($Get(^DHCEQEquip(EquipDR)),"^",77)
	If ocldr'=""
	{
		If $Data(^DHCEQAffix(0,"CheckListDR",ocldr))
		{
			Set affixRowId=""
			For  Set affixRowId=$Order(^DHCEQAffix(0,"CheckListDR",ocldr,affixRowId))  Quit:affixRowId=""  Do
			.Quit:$Piece($Get(^DHCEQAffix(affixRowId)),"^",15)'="N"
			.Quit:$o(^DHCEQAffix(0,"OldRowID",EquipDR,affixRowId,0))>0
			.If affixsInfo'="" Set affixsInfo=affixsInfo_"^"
			.Set affixsInfo=affixsInfo_affixRowId
		}
	}
	s affixRowId=0
	f  s affixRowId=$o(^DHCEQAffix(0,"Equip",EquipDR,affixRowId))  quit:affixRowId=""  d
	.q:$p($g(^DHCEQAffix(affixRowId)),"^",15)'="N"
	.if affixsInfo'="" s affixsInfo=affixsInfo_"^"
	.Set affixsInfo=affixsInfo_affixRowId
	q affixsInfo
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQAffix","GetAffixList","")
Query GetAffixList(desc As %Library.String = "") As %Query(ROWSPEC = "TRow:%String:序号,PartSpec:%String:附件名称,Encoding:%String:简称,PartModel:%String:附件型号,Hidden:%String,Unit:%String:单位")
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

/// Add By QW20210629 BUG:QW0130 补充hold1序号
/// w ##Class(web.DHCEQAffix).SaveAffixSortAll()
ClassMethod SaveAffixSortAll()
{
	s SQLCODE=0
	s error=""
	s rowid=0
	f  s rowid=$o(^DHCEQEquip(rowid))  quit:rowid=""  d
	.q:SQLCODE'=0
	.Set ocldr=$Piece($Get(^DHCEQEquip(rowid)),"^",77)
	.s num=1
	.If ocldr'=""  d
	..If $Data(^DHCEQAffix(0,"CheckListDR",ocldr)) d
	...Set affixRowId=""
	...For  Set affixRowId=$Order(^DHCEQAffix(0,"CheckListDR",ocldr,affixRowId))  Quit:affixRowId=""  Do
	....q:SQLCODE'=0
	....Quit:$Piece($Get(^DHCEQAffix(affixRowId)),"^",15)'="N"
	....Quit:$o(^DHCEQAffix(0,"OldRowID",ocldr,affixRowId,0))>0
	....&SQL(update SQLUSER.DHC_EQAffix set AF_Hold1=:num where AF_RowID = :affixRowId)
	....if SQLCODE s error=$Piece($Get(^DHCEQEquip(rowid)),"^",71)_":"_$Piece($Get(^DHCEQAffix(affixRowId)),"^",4)
	....s num=num+1
	.s affixRowId=0
	.f  s affixRowId=$o(^DHCEQAffix(0,"Equip",rowid,affixRowId))  quit:affixRowId=""  d
	..q:SQLCODE'=0
	..q:$p($g(^DHCEQAffix(affixRowId)),"^",15)'="N"
	..&SQL(update SQLUSER.DHC_EQAffix set AF_Hold1=:num where AF_RowID = :affixRowId)
	..if SQLCODE s error=$Piece($Get(^DHCEQEquip(rowid)),"^",71)_":"_$Piece($Get(^DHCEQAffix(affixRowId)),"^",4)
	..s num=num+1
	if SQLCODE  quit error
	quit "sucess"
}

/// MZY0098	2021-10-15	增加设备DR参数
/// 创建:Mozy	2021-08-02 
/// 描述:附件对象
/// w ##Class(web.DHCEQAffix).GetOneAffix(5,4)
ClassMethod GetOneAffix(RowID As %Library.String = "", AffSequence As %Library.String = "", EquipDR As %Library.String = "")
{
	s $ZT="ERRORGetOneAffix"
	s ObjAffix=##Class(User.DHCEQAffix).%OpenId(RowID)
	s AffixInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjAffix)
	
	d AffixInfo.%Set("AFAddDate",##class(web.DHCEQCommon).TransValueToPage(ObjAffix.AFAddDate, "date"))
	d AffixInfo.%Set("AFCurrencyDR_UOMDesc",##class(web.DHCEQCommon).GetTrakNameByID("uom",ObjAffix.AFCurrencyDR))
	d AffixInfo.%Set("AFGuaranteeEndDate",##class(web.DHCEQCommon).TransValueToPage(ObjAffix.AFGuaranteeEndDate, "date"))
	d AffixInfo.%Set("AFGuaranteeStartDate",##class(web.DHCEQCommon).TransValueToPage(ObjAffix.AFGuaranteeStartDate, "date"))
	d AffixInfo.%Set("AFLeaveDate",##class(web.DHCEQCommon).TransValueToPage(ObjAffix.AFLeaveDate, "date"))
	; 附件编号		objEquip.EQNo+"_"+AFHold1+"_"+AffSequence
	s AFNo=ObjAffix.AFEquipDR.EQNo
	i AFNo="" s AFNo=$Piece($Get(^DHCEQEquip(+EquipDR)),"^",71)	// MZY0098	2021-10-15
	;Add By QW20211112 BUG:QW0155 begin
	i ObjAffix.AFHold1'="" s AFNo=AFNo_"_"_ObjAffix.AFHold1
	i AffSequence'="" s AFNo=AFNo_"_"_AffSequence
	;Add By QW20211112 BUG:QW0155 end
	d AffixInfo.%Set("AFNo", AFNo)
	// MZY0098	2021-10-15	修正附件出厂编号取值
	i ObjAffix.AFLeaveFacNo=""
	{
		s AFLeaveFacNo=$g(^DHCEQAffix(RowID,"EX"))
		i AFLeaveFacNo'="" d AffixInfo.%Set("AFLeaveFacNo", $p(AFLeaveFacNo,",",AffSequence))
	}
	d AffixInfo.%Set("AFManuFactoryDR_MFName",ObjAffix.AFManuFactoryDR.VName)
	d AffixInfo.%Set("AFProviderDR_VName",ObjAffix.AFProviderDR.VName)
	
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,AffixInfo)
ERRORGetOneAffix
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-9012", ErrorMsg)
}

}
