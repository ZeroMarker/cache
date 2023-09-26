Class web.DHCEQ.RM.SCItemAffix Extends %RegisteredObject [ Not ProcedureBlock ]
{

/// Add by CSJ 2020-04-30
/// 描述：根据资源项目、附件以及附件型号查找资源项目和附件维护表信息
/// 入参：IAShareItemDR :设备项RowID，IAAffixDR：设备项附件RowID,IAModel:设备附件型号
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.SCItemAffix","GetItemAffix","1","","")
Query GetItemAffix(IAShareItemDR As %String = "", IAAffixDR As %String = "", IAModel As %String = "") As %Query(ROWSPEC = "IARowID:%String,IAShareItemDR:%String,IAShareItemDesc:%String,IAAffixDR:%String,IAAffixDesc:%String,IAModel:%String,IAQuantity:%String,IARemark:%String,IAPrice:%String,IAInvalidFlag:%String,IAHold1:%String,IAHold2:%String,IAHold3:%String")
{
}

ClassMethod GetItemAffixExecute(ByRef qHandle As %Binary, IAShareItemDR As %String = "", IAAffixDR As %String = "", IAModel As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	if IAShareItemDR'=""  d
	.f  s rowid=$o(^DHCEQSCItemAffix(0,"IAShareItemDR",IAShareItemDR,rowid)) q:rowid=""  d SetGetItemAffix
	else  d
	.f  s rowid=$o(^DHCEQSCItemAffix(rowid))  quit:rowid=""  d SetGetItemAffix
	Quit $$$OK
SetGetItemAffix
	d ResetVariablesGetItemAffix
	s TIARowID = rowid	//rowid
	s TIAShareItemDR=$p($g(^DHCEQSCItemAffix(TIARowID)),"^",1) //共享资源项目外键
	q:(IAShareItemDR'="")&&(TIAShareItemDR'=IAShareItemDR)
	i TIAShareItemDR'="" s TIAShareItemDesc=$p($g(^DHCEQSCShareItem(TIAShareItemDR)),"^",3)  //共享资源描述
	s TIAAffixDR=$p($g(^DHCEQSCItemAffix(TIARowID)),"^",2) //资源项附件外键
	q:(IAAffixDR'="")&&(TIAAffixDR'=IAAffixDR)
	i TIAAffixDR'="" s TIAAffixDesc=$p($g(^DHCEQCCode("DHCEQCAffix",TIAAffixDR)),"^",2) //资源项附件描述
	s TIAModel=$P($g(^DHCEQSCItemAffix(TIARowID)),"^",3)
	q:(IAModel'="")&&(TIAModel'[IAModel)
	s TIAQuantity=$P($g(^DHCEQSCItemAffix(TIARowID)),"^",4)
	s TIARemark=$P($g(^DHCEQSCItemAffix(TIARowID)),"^",5)
	s TIAPrice=##Class(web.DHCEQCommon).FormatNumber($P($g(^DHCEQSCItemAffix(TIARowID)),"^",6),"",2)
	s TIAInvalidFlag=$P($g(^DHCEQSCItemAffix(TIARowID)),"^",7)
	q:TIAInvalidFlag="Y"
	s TIAHold1=$P($g(^DHCEQSCItemAffix(TIARowID)),"^",8)
	s TIAHold2=$P($g(^DHCEQSCItemAffix(TIARowID)),"^",9)
	s TIAHold3=$P($g(^DHCEQSCItemAffix(TIARowID)),"^",10)
	d OutputRowGetItemAffix
	quit
	
OutputRowGetItemAffix
	//TIARowID:%String,TIAShareItemDR:%String,TIAItemDesc:%String,TIAAffixDR:%String,TIAAffixDesc:%String,TIAModel:%String,TIAQuantity:%String,TIARemark:%String,TIAInvalidFlag:%String
	s Data=$lb(TIARowID,TIAShareItemDR,TIAShareItemDesc,TIAAffixDR,TIAAffixDesc,TIAModel,TIAQuantity,TIARemark,TIAPrice,TIAInvalidFlag,TIAHold1,TIAHold2,TIAHold3)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetItemAffix
	Set (TIARowID,TIAShareItemDR,TIAShareItemDesc,TIAAffixDR,TIAAffixDesc,TIAModel,TIAQuantity,TIARemark,TIAPrice,TIAInvalidFlag,TIAHold1,TIAHold2,TIAHold3)=""
	Quit
}

ClassMethod GetItemAffixFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status
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

ClassMethod GetItemAffixClose(ByRef qHandle As %Binary) As %Status
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##class(web.DHCEQ.RM.SCItemAffix).SaveData("{""IAShareItemDR_Desc"":""共享资源项目"",""IAAffixDR_Desc"":""附件1"",""IAModel"":""1"",""IAQuantity"":""2"",""IAPrice"":""3"",""IARemark"":""4"",""PutOnSetDR"":""3"",""IARowID"":"""",""IAShareItemDR"":""1"",""IAAffixDR"":""1""}")
ClassMethod SaveData(Data)
{
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
    s Result=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSCItemAffix",JsonData,.PLIST)
	s RowID = JsonData.IARowID
	s IAShareItemDR=JsonData.IAShareItemDR
	s IAAffixDR=JsonData.IAAffixDR
	s PLIST(8)="N"
	s tmpid="" 
	
	if (RowID="")
	{ 
		&SQL(select IA_RowID into :tmpid from sqluser.DHC_EQSCItemAffix where IA_ShareItemDR=:IAShareItemDR and IA_AffixDR=:IAAffixDR and IA_InvalidFlag='N')
		if tmpid'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9200,"新增数据有重复") ;重复记录
		b ;2
		&SQL(Insert into sqluser.DHC_EQSCItemAffix Values :PLIST())
		if SQLCODE  Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"新增失败")
		Set ID=$g(%ROWID)
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ID)
	}
	else 
	{
		&SQL(select IA_RowID into :tmpid from sqluser.DHC_EQSCItemAffix where IA_ShareItemDR=:IAShareItemDR and IA_AffixDR=:IAAffixDR and IA_InvalidFlag='N')
		if ((tmpid'="")&&(tmpid'=RowID)) Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-9200,"保存数据有重复")	;重复记录!(Undefined!rowid)
		&SQL(Update sqluser.DHC_EQSCItemAffix Values :PLIST() where IA_RowID = :RowID)
		Set ID=$g(%ROWID)
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ID)
	}
}

/// w ##class(web.DHCEQ.RM.SCItemAffix).DeleteData("17")
ClassMethod DeleteData(Rowid As %String)
{
	i (Rowid'="") 
	{
		&SQL(Update sqluser.DHC_EQSCItemAffix set IA_InvalidFlag='Y' where IA_RowID = :Rowid)
		
	}
	Set ID=$g(%ROWID)
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,ID)
}

}
