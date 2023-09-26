Class web.DHCEQCheckEquip Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 26;

Parameter SQLDATEFROM;

Parameter SQLDATETO;

Parameter SQLCODE = "EQ_Code";

Parameter SQLDESCRIPTION = "EQ_RowID";

Parameter SQLROWID = "EQ_RowID";

Parameter GlobalLen = 80;

ClassMethod GetOtherListInfo(equipdr)
{
	s result=""
	i equipdr="" q ""
	s firstFlag=0
	s listid=0
	f  s listid=$o(^DHCEQCheckAffix(0,"Equip",equipdr,listid)) q:listid=""  d
	.q:$p(^DHCEQCheckAffix(listid),"^",15)'="N"
	.s listname=$p($g(^DHCEQCCode("DHCEQCAffix",$p(^DHCEQCheckAffix(listid),"^",2))),"^",2)
	.i firstFlag=0  d
	..s firstFlag=1
	.e  d
	..s result=result_"&"
	.s result=result_listname_"^"_$p(^DHCEQCheckAffix(listid),"^",5)_"^"_$p(^DHCEQCheckAffix(listid),"^",7)_"^"_$p(^DHCEQCheckAffix(listid),"^",11)
	
	s result=result_"@"
	s firstFlag=0
	s listid=0
	f  s listid=$o(^DHCEQDoc(0,"Equip",equipdr,listid)) q:listid=""  d
	.s listname=$p($g(^DHCEQDoc(listid)),"^",2)
	.i firstFlag=0  d
	..s firstFlag=1
	.e  d
	..s result=result_"&"
	.s result=result_listname	
	q result
}

ClassMethod GetEquipByID(itmjs As %Library.String = "", itmjsex As %Library.String = "", rowid As %Library.String = "")
{
	new result,resultex,i,count,EquipTechLevel
	s EquipTechLevel=""
	s (result,resultex)=""
	s result= $G(^DHCEQCheckEquip(rowid))
	set count=..#GlobalLen-$l(result,"^")
	for i=count:-1:1 { s result=result_"^"}
	s resultex=resultex_"^"	;ModelDR
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCModel",$p(result,"^",3))),"^",2)
	s resultex=resultex_"^"	;EquiCatDR
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipeCat",$p(result,"^",4))),"^",2)
	s resultex=resultex_"^"	;UnitDR
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",5))
	s resultex=resultex_"^"	;InstallLocDR
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",8))
	s $p(result,"^",9)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")	;InstallDate	
	s $p(result,"^",11)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",11),"date")	;LeaveFactoryDate
	s $p(result,"^",12)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",12),"date")	;OpenCheckDate
	s $p(result,"^",13)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",13),"date")	;CheckDate
	s $p(result,"^",14)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",14),"date")	;MakeDate
	s $p(result,"^",15)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",15),"bool")	;ComputerFlag
	s resultex=resultex_"^"	;CountryDR
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("cou",$p(result,"^",16))
	s resultex=resultex_"^"	;ManageLocDR
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",17))
	s resultex=resultex_"^"	;ManageLevelDR
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManageLevel",$p(result,"^",18))),"^",2)
	s resultex=resultex_"^"	;UseLocDR
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",19))
	s resultex=resultex_"^"	;OriginDR
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCOrigin",$p(result,"^",20))),"^",2)
	s resultex=resultex_"^"	;FromDeptDR
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",21))),"^",2)
	s resultex=resultex_"^"	;ToDeptDR
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCFromToDept",$p(result,"^",22))),"^",2)
	s resultex=resultex_"^"	;BuyTypeDR
	i $p(result,"^",23)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBuyType",$p(result,"^",23))),"^",2)
	s resultex=resultex_"^"	;ProviderDR
	i $p(result,"^",25)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("prov",$p(result,"^",25))
	s resultex=resultex_"^"	;ManuFactoryDR
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCManufacturer",$p(result,"^",26))),"^",1)
	s resultex=resultex_"^"	;GroupDR
	i $p(result,"^",30)'=""  d
	.s resultex=resultex_$p($g(^DHCEQGroup($p(result,"^",30))),"^",2)
	s resultex=resultex_"^"	;ContractListDR
	i $p(result,"^",32)'=""  d
	.s contractdr=$p($g(^DHCEQContractList($p(result,"^",32))),"^",1)	
	.s resultex=resultex_$p($g(^DHCEQContract(contractdr)),"^",1)
	.//s resultex=resultex_$p($g(^DHCEQContractList($p(result,"^",32))),"^",2)
	s resultex=resultex_"^"	;DepreMethodDR
	i $p(result,"^",33)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCDepreMethod",$p(result,"^",33))),"^",2)
	s resultex=resultex_"^"	;WorkLoadUnitDR
	i $p(result,"^",37)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("uom",$p(result,"^",37))
	s resultex=resultex_"^"	;ManageUserDR
	i $p(result,"^",39)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",39))
	s resultex=resultex_"^"	;MaintUserDR
	i $p(result,"^",40)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",40))
	s $p(result,"^",44)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",44),"date")	;StartDate
	s $p(result,"^",45)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",45),"date")	;TransAssetDate
	s $p(result,"^",46)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",46),"bool")	;GuaranteeFlag
	s $p(result,"^",47)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",47),"bool")	;InputFlag
	s $p(result,"^",48)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",48),"bool")	;TestFlag
	s $p(result,"^",49)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",49),"bool")	;MedicalFlag
	s $p(result,"^",50)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",50),"date")	;GuaranteeStartDate
	s $p(result,"^",51)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",51),"date")	;GuaranteeEndDate
	s resultex=resultex_"^"	;AddUserDR
	i $p(result,"^",52)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",52))
	s $p(result,"^",53)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",53),"date")	;AddDate
	s resultex=resultex_"^"	;UpdateUserDR
	i $p(result,"^",55)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",55))
	s $p(result,"^",56)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",56),"date")	;UpdateDate
	///
	s $p(result,"^",62)=##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",62),"bool")	;UrgencyFlag
	s resultex=resultex_"^"	;EquipTypeDR
	i $p(result,"^",63)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCEquipType",$p(result,"^",63))),"^",2)
	s resultex=resultex_"^"	;PurchaseTypeDR
	i $p(result,"^",64)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurchaseType",$p(result,"^",64))),"^",2)
	s resultex=resultex_"^"	;PurposeTypeDR
	i $p(result,"^",65)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCPurposeType",$p(result,"^",65))),"^",2)
	s resultex=resultex_"^"	;KeeperDR
	i $p(result,"^",66)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",66))
	s resultex=resultex_"^"	;StoreLocDR
	i $p(result,"^",67)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",67))
	s resultex=resultex_"^"	;ServiceDR
	i $p(result,"^",69)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCService",$p(result,"^",69))),"^",1)
	s resultex=resultex_"^"	;InStockListDR
	i $p(result,"^",70)'=""  d
	.s resultex=resultex_$p($g(^DHCEQInStockList($p(result,"^",70))),"^",1)
	
	///////
	//状态
	s resultex=resultex_"^"_##class(web.DHCEQEquip).GetEquipStatusDisplay($p(result,"^",38))
	//加
	s resultex=resultex_"^"
	i $p(result,"^",24)'=""  d 
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCTechLevel",$p(result,"^",24))),"^",2)
	s resultex=resultex_"^"	;StatCatDR
	i $p(result,"^",75)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCStatCat",$p(result,"^",75))),"^",2)
	s resultex=resultex_"^"
	s result=result_resultex
	s result=##Class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

ClassMethod GetContractNo(equipdr)
{
	s contractno=""
	if equipdr'=""
	{
		s contractListDR=$p($g(^DHCEQCheckEquip(equipdr)),"^",32)
		if (contractListDR'="")
		{
			s contractno=$p(^DHCEQContract($p(^DHCEQContractList(contractListDR),"^",1)),"^",2)
		}
	}
	q contractno
}

Query GetEquip(StatCatDR, EquipTypeDR, Equip, Origin, Provider) As %Query(ROWSPEC = "Name:%String,HIDDEN:%String,EquipNum:%String,Model:%String,LeaveFactoryNo:%String")
{
}

ClassMethod GetEquipClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetEquipExecute ]
{
	Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

// vEquipName As %String = "", vEquipNo As %String = "", vModelDR As %String = "", vManageLocDR As %String = "", vUseLocDR As %String = "", vStatus As %String = "", vLeaveFactoryNo As %String = ""

ClassMethod GetEquipExecute(ByRef qHandle As %Binary, StatCatDR, EquipTypeDR, Equip, Origin, Provider) As %Status
{
 	new repid, index,rowid,Flag,ISLRowID,ISRowID,StockStatu,EqStatus
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set Equip=$ZCONVERT(Equip,"U")
	s index=1
	s rowid=0
	d BuildDataGetEquip
	Quit $$$OK
BuildDataGetEquip
	f  s rowid=$o(^DHCEQCheckEquip(0,"StockStatus","0",rowid)) q:rowid=""  d
	.q:$o(^DHCEQInStockList(0,"Equip",rowid,0))'=""
	.d ResetVariablesGetEquip
	.d GetOneEquipData
	
	quit
GetOneEquipData
	s RowID = rowid
	s Name = $ZCONVERT($p($g(^DHCEQCheckEquip(rowid)),"^",1),"U")
	s Code = $ZCONVERT($p($g(^DHCEQCheckEquip(rowid)),"^",6),"U")
	s EquipNo=$p($g(^DHCEQCheckEquip(rowid)),"^",71)
	s ModelDR=$p($g(^DHCEQCheckEquip(rowid)),"^",3)
	i ModelDR'="" s Model=$p(^DHCEQCCode("DHCEQCModel",ModelDR),"^",2)
	s LeaveFactoryNo = $ZCONVERT($p($g(^DHCEQCheckEquip(rowid)),"^",10),"U")
	s TStatCatDR=$p($g(^DHCEQCheckEquip(rowid)),"^",75)
	q:(TStatCatDR'="")&&(TStatCatDR'=StatCatDR)&&(StatCatDR'="")
	q:(Equip'="")&&((Name'[Equip)&(Code'[Equip))     ;&(Model'[Equip)&(UseLoc'[Equip))
	s EqStatus=$p($g(^DHCEQCheckEquip(rowid)),"^",38)
	s TEquipTypeDR=$p($g(^DHCEQCheckEquip(rowid)),"^",63)
	q:(TEquipTypeDR'="")&&(TEquipTypeDR'=EquipTypeDR)&&(EquipTypeDR'="")
	s TOriginDR=$p($g(^DHCEQCheckEquip(rowid)),"^",20)
	q:(TOriginDR'="")&&(TOriginDR'=Origin)&&(Origin'="")
	s TProviderDR=$p($g(^DHCEQCheckEquip(rowid)),"^",25)
	q:(TProviderDR'="")&&(TProviderDR'=Provider)&&(Provider'="")
	d OutputRowGetEquip
	quit
OutputRowGetEquip
	s Data=$lb(Name,RowID,EquipNo,Model,LeaveFactoryNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetEquip
	s (Name,RowID,EquipNo,Model,LeaveFactoryNo,Code)=""
	quit
}

ClassMethod GetEquipFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetEquipExecute ]
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

}
