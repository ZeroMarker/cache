Import SQLUser

Class web.DHCEQCheckAffix Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 92;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "AF_RowID";

Parameter SQLDESCRIPTION = "AF_RowID";

Parameter SQLROWID = "AF_RowID";

ClassMethod GetAffixByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result= ^DHCEQCheckAffix(rowid)
	s resultex=resultex_"^"	;EquipDR
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCheckEquip($p(result,"^",1))),"^",1)
	s resultex=resultex_"^"	;AffixDR
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAffix",$p(result,"^",2))),"^",2)
	s resultex=resultex_"^"	;AffixCatDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCAffixCat",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",6))),"^",1)
	s resultex=resultex_"^"	;ReceiverDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",8))
	s $p(result,"^",10)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",10),"date")	;LeaveDate
	s resultex=resultex_"^"	;CurrencyDR
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cur",$p(result,"^",13))
	q result_resultex_"^"_$G(^DHCEQDataEx("EQCheckAffix","Sequence",rowid))
}

ClassMethod SaveData(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "", user As %Library.String = "", isDel As %Library.String = "")
{
 k PLIST,rowid
 s rowid=$p(val,"^",1)
 i (+isDel=1)
 {
 	&SQL(update SQLUSER.DHC_EQCheckAffix set AF_InvalidFlag='Y' where AF_RowID = :rowid)
 	if SQLCODE  q SQLCODE
 	q rowid
 }
 s PLIST(1) = $p(val,"^",1)	;RowID
 s PLIST(2) = $p(val,"^",2)	;EquipDR
 s PLIST(3) = $p(val,"^",3)	;AffixDR
 s PLIST(4) = $p(val,"^",4)	;AffixCatDR
 s PLIST(5) = $p(val,"^",5)	;PartSpec
 s PLIST(6) = $p(val,"^",6)	;PartModel
 s PLIST(7) = $p(val,"^",7)	;ManuFactoryDR
 s PLIST(8) = $p(val,"^",8)	;QuantityNum
 s PLIST(9) = $p(val,"^",9)	;ReceiverDR
 s PLIST(10) = $p(val,"^",10)	;LeaveFacNo
 s PLIST(11) = $p(val,"^",11)	;LeaveDate
 i $p(val,"^",11)'=""  s PLIST(11) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",11),"date")	;LeaveDate
 s PLIST(12) = $p(val,"^",12)	;PriceFee
 s PLIST(13) = $p(val,"^",13)	;Remark
 s PLIST(14) = $p(val,"^",14)	;CurrencyDR 
 k PLIST(1)
  if (rowid'="") 
 {
	 &SQL(Update SQLUSER.DHC_EQCheckAffix Values :PLIST() where AF_RowID = :rowid) 	 
 }
 else
 {	 
 	s PLIST(15) = "N"			;AF_DisuseFlag
 	s PLIST(16) = "N"			;AF_InvalidFlag
	 &SQL(Insert Into SQLUSER.DHC_EQCheckAffix Values :PLIST())
 }
 if SQLCODE  q SQLCODE
 Set ID=$g(%ROWID)
 s ^DHCEQDataEx("EQCheckAffix","Sequence",ID)=$p(val,"^",15)
 q ID
}

Query GetAffix(EquipDR As %String) As %Query(ROWSPEC = "TRowID:%String,TEquipDR:%String,TAffixDR:%String,TAffixCatDR:%String,TPartSpec:%String,TPartModel:%String,TManuFactoryDR:%String,TQuantityNum:%String,TReceiverDR:%String,TLeaveFacNo:%String,TLeaveDate:%String,TPriceFee:%String,TRemark:%String,TCurrencyDR:%String,TEquip:%String,TAffix:%String,TAffixCat:%String,TManuFactory:%String,TReceiver:%String,TCurrency:%String,TDisuseFlag:%String")
{
}

ClassMethod GetAffixExecute(ByRef qHandle As %Binary, EquipDR As %String) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetAffix
	Quit $$$OK
BuildDataGetAffix
	f  s rowid=$o(^DHCEQCheckAffix(rowid))  quit:rowid=""  d
	.d ResetVariablesGetAffix
	.q:$p($g(^DHCEQCheckAffix(rowid)),"^",15)'="N"
	.s TRowID = rowid
	.s TEquipDR = $p($g(^DHCEQCheckAffix(rowid)),"^",1)
	.q:(TEquipDR'=EquipDR)||(EquipDR="")
	.i TEquipDR '=""  d
	..s TEquip = $p($g(^DHCEQEquip(TEquipDR)),"^",1)
	.s TAffixDR = $p($g(^DHCEQCheckAffix(rowid)),"^",2)
	.i TAffixDR '=""  d
	..s TAffix = $p($g(^DHCEQCCode("DHCEQCAffix",TAffixDR)),"^",2)
	.s TAffixCatDR = $p($g(^DHCEQCheckAffix(rowid)),"^",3)
	.i TAffixCatDR '=""  d
	..s TAffixCat = $p($g(^DHCEQCCode("DHCEQCAffixCat",TAffixCatDR)),"^",2)
	.s TPartSpec = $p($g(^DHCEQCheckAffix(rowid)),"^",4)
	.s TPartModel = $p($g(^DHCEQCheckAffix(rowid)),"^",5)
	.s TManuFactoryDR = $p($g(^DHCEQCheckAffix(rowid)),"^",6)
	.i TManuFactoryDR '=""  d
	..s TManuFactory = $p($g(^DHCEQCCode("DHCEQCManufacturer",TManuFactoryDR)),"^",1)
	.s TQuantityNum = $p($g(^DHCEQCheckAffix(rowid)),"^",7)
	.s TReceiverDR = $p($g(^DHCEQCheckAffix(rowid)),"^",8)
	.i TReceiverDR '=""  d
	..s TReceiver = ##Class(web.DHCEQCommon).GetTrakNameByID("user",TReceiverDR)
	.s TLeaveFacNo = $p($g(^DHCEQCheckAffix(rowid)),"^",9)
	.s TLeaveDate = ##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQCheckAffix(rowid)),"^",10),"date")
	.s TPriceFee = $p($g(^DHCEQCheckAffix(rowid)),"^",11)
	.s TRemark = $p($g(^DHCEQCheckAffix(rowid)),"^",12)
	.s TCurrencyDR = $p($g(^DHCEQCheckAffix(rowid)),"^",13)
	.i TCurrencyDR '=""  d
	..s TCurrency = ##Class(web.DHCEQCommon).GetTrakNameByID("cur",TCurrencyDR)
	.s TDisuseFlag=$p($g(^DHCEQCheckAffix(rowid)),"^",14)
	.//i TDisuseFlag'=""  d
	.//.s TDisuseFlag=##Class(web.DHCEQCommon).TransValueToPage(TDisuseFlag,"bool")
	.d OutputRowGetAffix
	quit
OutputRowGetAffix
	s Data=$lb(TRowID,TEquipDR,TAffixDR,TAffixCatDR,TPartSpec,TPartModel,TManuFactoryDR,TQuantityNum,TReceiverDR,TLeaveFacNo,TLeaveDate,TPriceFee,TRemark,TCurrencyDR,TEquip,TAffix,TAffixCat,TManuFactory,TReceiver,TCurrency,TDisuseFlag)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetAffix
	s (TRowID,TEquipDR,TAffixDR,TAffixCatDR,TPartSpec,TPartModel,TManuFactoryDR,TQuantityNum,TReceiverDR,TLeaveFacNo,TLeaveDate,TPriceFee,TRemark,TCurrencyDR,TEquip,TAffix,TAffixCat,TManuFactory,TReceiver,TCurrency,TDisuseFlag)=""
	quit
}

ClassMethod GetAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetAffixExecute ]
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
	s equipdr=$p($g(^DHCEQCheckAffix(rowid)),"^",1)
	s month=""
	s depresetid=$o(^DHCEQDepreSet(0,"EquipMain",equipdr,"Y",0))
	i depresetid="" q -1003
	i $p($g(^DHCEQCheckAffix(rowid)),"^",14)="Y"  q -1002
	TSTART
	&SQL(Update SQLUSER.DHC_EQCheckAffix set AF_DisuseFlag='Y',AF_UpdateUserDR=:User,AF_UpdateDate=:Date,AF_UpdateTime=:Time,AF_Remark=:remark where AF_RowID = :rowid)
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

/// /
ClassMethod GetAffixsInfoByEquip(EquipDR)
{
	new affixRowId,affixsInfo
	if EquipDR="" q ""
	s affixsInfo=""
	s affixRowId=0
	f  s affixRowId=$o(^DHCEQCheckAffix(0,"Equip",EquipDR,affixRowId))  quit:affixRowId=""  d
	.if affixsInfo'="" s affixsInfo=affixsInfo_"&"
	.s affixsInfo=affixsInfo_..GetAffixByID("","",affixRowId)
	
	q affixsInfo
}

/*
Query GetAffixByEquip(para) As %SQLQuery(ROWSPEC = "AffixDesc:%String,Model:%String,ManuFactory:%String,QtyNum:%String,Price:%String,LeaveFacNo:%String")
{
	select AF_AffixDR->A_Desc as AffixDesc,AF_PartModel as Model,AF_ManuFactoryDR->MF_Name as ManuFactory,AF_QuantityNum as  QtyNum,AF_PriceFee as Price,AF_LeaveFacNo as LeaveFacNo 
	from DHC_EQCheckAffix where AF_EquipDR=:para
}
*/
Query GetAffixByEquip(para) As %SQLQuery(ROWSPEC = "AffixDesc:%String,Model:%String,QtyNum:%String,Price:%String")
{
	select AF_AffixDR->A_Desc as AffixDesc,AF_PartModel as Model,AF_QuantityNum as  QtyNum,AF_PriceFee as Price 
	from DHC_EQCheckAffix where AF_EquipDR=:para
}

/// w ##class(web.DHCEQCheckAffix).GetAffixInfo("10378")
ClassMethod GetAffixInfo(EquipDR)
{
	new affixRowId,affixsInfo,Total
	if EquipDR="" q ""
	s affixsInfo=""
	s affixRowId=0
	s Total=0
	f  s affixRowId=$o(^DHCEQCheckAffix(0,"Equip",EquipDR,affixRowId))  quit:affixRowId=""  d
	.s InvalidFlag=$p($G(^DHCEQCheckAffix(affixRowId)),"^",15)
	.q:InvalidFlag="Y"
	.s affixSequence=$G(^DHCEQDataEx("EQCheckAffix","Sequence",affixRowId))
	.q:affixSequence=""
	.if affixsInfo'="" s affixsInfo=affixsInfo_"&&"
	.s affixNameID=$p($G(^DHCEQCheckAffix(affixRowId)),"^",2)
	.s affixName=$p($g(^DHCEQCCode("DHCEQCAffix",affixNameID)),"^",2)
	.s affixMode=$p($G(^DHCEQCheckAffix(affixRowId)),"^",5)
	.s affixNum=+$p($G(^DHCEQCheckAffix(affixRowId)),"^",7)
	.s Total=Total+1
	.i +affixNum>1 s affixName=affixName_"("_affixNum_")"
	.s affixsInfo=affixsInfo_affixName_"^"_affixSequence_"^"_affixMode_"^"_affixNum
	
	q affixsInfo_"%%"_Total
}

ClassMethod GetEquipInfo(EquipId)
{
	s UseLocId=$p($G(^DHCEQEquip(EquipId)),"^",19)
	s QZ="科室:"
	i UseLocId="" d 
	.s QZ="库房:"
	.s UseLocId=$p($G(^DHCEQEquip(EquipId)),"^",67)
	;i UseLocId'="" s UseLocId=$p($g(^CTLOC(UseLocId)),"^",2) //modify by jyp 2019-10-18 CTLOC调整
	i UseLocId'="" s UseLocId=##class(web.DHCEQCommon).GetTrakNameByID("dept",UseLocId)   //modify by jyp 2019-10-18 CTLOC调整
	s UseLocId=QZ_UseLocId
	//s Keeper=$p($G(^DHCEQEquip(EquipId)),"^",66)
	//i Keeper'="" d
	//.s Keeper=##class(web.DHCEQCommon).GetTrakNameByID("user",Keeper)
	//.s ItemName=$p($G(^DHCEQEquip(EquipId)),"^",61)
	//.s UseLocId=Keeper_" "_ItemName
	s ItemName=$p($G(^DHCEQEquip(EquipId)),"^",61)
	i ItemName'="" s UseLocId=ItemName
	s EquipName=$p($G(^DHCEQEquip(EquipId)),"^",1)
	s EquipNo=$p($G(^DHCEQEquip(EquipId)),"^",71)
	q EquipName_"^"_EquipNo_"^"_UseLocId
}

}
