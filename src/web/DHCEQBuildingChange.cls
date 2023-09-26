/// Create By HZY 2013-7-12
/// Desc:房屋的改建和扩建.
Class web.DHCEQBuildingChange Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

ClassMethod SaveData(val As %Library.String = "", doType As %Library.String = "")
{
	n (val,doType)
	k PLIST,rowid
	s rowid=$p(val,"^",1)
	s User=$p(val,"^",44) //##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	if ((+doType=1)&&(rowid'=""))	//作废
	{
		&SQL(Update SQLUSER.DHC_EQBuildingChange(BC_Status,BC_DropUserDR,BC_DropDate,BC_DropTime) Values('3',:User,:Date,:Time) Where BC_RowID=:rowid )
		if SQLCODE
	 	{
		 	q SQLCODE
	 	}
	 	q rowid
	}
	elseif((+doType=3)&&(rowid'=""))	//提交and审核
	{
		&SQL(Update SQLUSER.DHC_EQBuildingChange(BC_Status,BC_SubmitUserDR,BC_SubmitDate,BC_SubmitTime,BC_AuditUserDR,BC_AuditDate,BC_AuditTime) Values('2',:User,:Date,:Time,:User,:Date,:Time) Where BC_RowID=:rowid)
		if SQLCODE
	 	{
		 	q SQLCODE
	 	}
	 	q rowid
	}
	
	s PLIST(2) = $p(val,"^",2)		;BC_EquipDR
	s PLIST(3) = $p(val,"^",3)		;BC_ChangeType
	s PLIST(4) = $p(val,"^",4)		;BC_ChangeDate
	i PLIST(4)'=""  s PLIST(4) = ##Class(web.DHCEQCommon).TransValueFromPage(PLIST(4),"date")
	s PLIST(5) = $p(val,"^",5)		;BC_ProjectItem
	s PLIST(6) = $p(val,"^",6)		;BC_StartDate
	i PLIST(6)'=""  s PLIST(6) = ##Class(web.DHCEQCommon).TransValueFromPage(PLIST(6),"date")
	s PLIST(7) = $p(val,"^",7)		;BC_FinishedDate
	i PLIST(7)'=""  s PLIST(7) = ##Class(web.DHCEQCommon).TransValueFromPage(PLIST(7),"date")
	s PLIST(8) = $p(val,"^",8)		;BC_Company
	s PLIST(9) = $p(val,"^",9)		;BC_ProjectFee
	s PLIST(10) = $p(val,"^",10)	;BC_CheckDate
	i PLIST(10)'=""  s PLIST(10) = ##Class(web.DHCEQCommon).TransValueFromPage(PLIST(10),"date")
	s PLIST(11) = $p(val,"^",11)	;BC_CheckUser
	s PLIST(12) = $p(val,"^",12)	;BC_FromStructDR
	s PLIST(13) = $p(val,"^",13)	;BC_ToStructDR
	s PLIST(14) = $p(val,"^",14)	;BC_FromBuildingArea
	s PLIST(15) = $p(val,"^",15)	;BC_ToBuildingArea
	s PLIST(16) = $p(val,"^",16)	;BC_FromUtilizationArea
	s PLIST(17) = $p(val,"^",17)	;BC_ToUtilizationArea
	s PLIST(18) = $p(val,"^",18)	;BC_FromSubArea
	s PLIST(19) = $p(val,"^",19)	;BC_ToSubArea
	s PLIST(20) = $p(val,"^",20)	;BC_FromFloorNum
	s PLIST(21) = $p(val,"^",21)	;BC_ToFloorNum
	s PLIST(22) = $p(val,"^",22)	;BC_FromUnderFloorNum
	s PLIST(23) = $p(val,"^",23)	;BC_ToUnderFloorNum
	s PLIST(24) = $p(val,"^",24)	;BC_FromLandArea
	s PLIST(25) = $p(val,"^",25)	;BC_ToLandArea
	s PLIST(26) = $p(val,"^",26)	;BC_Hold1
	s PLIST(27) = $p(val,"^",27)	;BC_Hold2
	s PLIST(28) = $p(val,"^",28)	;BC_Hold3
	s PLIST(29) = $p(val,"^",29)	;BC_Hold4
	s PLIST(30) = $p(val,"^",30)	;BC_Hold5
	s PLIST(31) = $p(val,"^",31)	;BC_Status
	s PLIST(32) = $p(val,"^",32)	;BC_CreateUserDR
	s PLIST(33) = $p(val,"^",33)	;BC_CreateDate
	s PLIST(34) = $p(val,"^",34)	;BC_CreateTime
	s PLIST(35) = $p(val,"^",35)	;BC_SubmitUserDR
	s PLIST(36) = $p(val,"^",36)	;BC_SubmitDate
	s PLIST(37) = $p(val,"^",37)	;BC_SubmitTime
	s PLIST(38) = $p(val,"^",38)	;BC_AuditUserDR
	s PLIST(39) = $p(val,"^",39)	;BC_AuditDate
	s PLIST(40) = $p(val,"^",40)	;BC_AuditTime
	s PLIST(41) = $p(val,"^",41)	;BC_DropUserDR
	s PLIST(42) = $p(val,"^",42)	;BC_DropDate
	s PLIST(43) = $p(val,"^",43)	;BC_DropTime
	
	if (doType=2)	//新增or更新
	{
		if (rowid="")
		{
			s PLIST(31) = "0"		;BC_Status
			s PLIST(32) = User		;BC_CreateUserDR
			s PLIST(33) = Date		;BC_CreateDate
			s PLIST(34) = Time		;BC_CreateTime
			&SQL(Insert Into SQLUSER.DHC_EQBuildingChange Values :PLIST())
		}
		else{
			&SQL(Update SQLUSER.DHC_EQBuildingChange Values :PLIST() Where BC_RowID=:rowid)
		}
	
	}
	if SQLCODE
	{
		q SQLCODE
	}
	Set ID=$g(%ROWID)
	q ID
}

/// 63004^63038^63004^63036
/// w ##class(%ResultSet).RunQuery("web.DHCEQBuildingChange","BuildingChange","","",63004,63038,63004,63036,"")
Query BuildingChange(Equip As %String = "", ChangeType, StartChangeDate, EndChangeDate, StartCheckDate, EndCheckDate, Status) As %Query(ROWSPEC = "TRowID:%String,TEquip:%String,TEquipDR:%String,TChangeType:%String,TChangeTypeDR:%String,TChangeDate:%String,TProjectItem:%String,TStartDate:%String,TFinishedDate:%String,TCompany:%String,TProjectFee:%String,TCheckDate:%String,TCheckUser:%String,TFromStruct:%String,TFromStructDR:%String,TToStruct:%String,TToStructDR:%String,TFromBuildingArea:%String,TToBuildingArea:%String,TFromUtilizationArea:%String,TToUtilizationArea:%String,TFromSubArea:%String,TToSubArea:%String,TFromFloorNum:%String,TToFloorNum:%String,TFromUnderFloorNum:%String,TToUnderFloorNum:%String,TFromLandArea:%String,TToLandArea:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TStatus:%String,TCreateUserDR:%String,TCreateUser:%String,TCreateDate:%String,TCreateTime:%String,TSubmitUserDR:%String,TSubmitUser:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditUser:%String,TAuditDate:%String,TAuditTime:%String,TDropUser:%String,TDropUserDR:%String,TDropDate:%String,TDropTime:%String")
{
}

/// 查询.
ClassMethod BuildingChangeExecute(ByRef qHandle As %Binary, Equip As %String = "", ChangeType, StartChangeDate, EndChangeDate, StartCheckDate, EndCheckDate, Status) As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	;s ^DHCEQ715(1)=Equip_"^"_ChangeType_"^"_StartChangeDate_"^"_EndChangeDate_"^"_StartCheckDate_"^"_EndCheckDate_"^"_Status
 	i StartChangeDate="" s StartChangeDate=0
 	i EndChangeDate="" s EndChangeDate=+$H
 	i StartCheckDate="" s StartCheckDate=0
 	i EndCheckDate s EndCheckDate=+$H
	s index=2
	s rowid=0
	f  s rowid=$o(^DHCEQBuildingChange(rowid)) q:rowid=""  d
	.d BuildDataBuildingChange
		
	Quit $$$OK
BuildDataBuildingChange
	d ResetVariablesBuildingChange
	s TRowID=rowid
	s TEquipDR=$p($g(^DHCEQBuildingChange(rowid)),"^",1)
	s TEquip=$p($g(^DHCEQEquip(TEquipDR)),"^",1)
	q:(Equip'="")&&(Equip'=TEquip)
	s TChangeTypeDR=$p($g(^DHCEQBuildingChange(rowid)),"^",2) 
	q:(ChangeType'="")&&(ChangeType'=TChangeTypeDR)
	s TChangeType=$CASE(TChangeTypeDR,"1":"改建","2":"扩建",:"")
	s TChangeDate=$p($g(^DHCEQBuildingChange(rowid)),"^",3)
	//q:(TChangeDate'="")&&((TChangeDate<StartChangeDate)||(EndChangeDate<TChangeDate))
	q:((TChangeDate<StartChangeDate)!(TChangeDate>EndChangeDate))
	i TChangeDate'="" s TChangeDate=##class(web.DHCEQCommon).TransValueToPage(TChangeDate,"date")
	s TProjectItem=$p($g(^DHCEQBuildingChange(rowid)),"^",4)
	s TStartDate=$p($g(^DHCEQBuildingChange(rowid)),"^",5)
	i TStartDate'="" s TStartDate=##class(web.DHCEQCommon).TransValueToPage(TStartDate,"date")
	s TFinishedDate=$p($g(^DHCEQBuildingChange(rowid)),"^",6)
	i TFinishedDate'="" s TFinishedDate=##class(web.DHCEQCommon).TransValueToPage(TFinishedDate,"date")
	s TCompany=$p($g(^DHCEQBuildingChange(rowid)),"^",7)
	s TProjectFee=$p($g(^DHCEQBuildingChange(rowid)),"^",8)
	s TCheckDate=$p($g(^DHCEQBuildingChange(rowid)),"^",9)
	//q:((TCheckDate<StartCheckDate)!(TCheckDate>EndCheckDate))
	i TCheckDate'="" s TCheckDate=##class(web.DHCEQCommon).TransValueToPage(TCheckDate,"date")
	s TCheckUser=$p($g(^DHCEQBuildingChange(rowid)),"^",10)
	s TFromStructDR=$p($g(^DHCEQBuildingChange(rowid)),"^",11)
	i TFromStructDR'="" s TFromStruct=$p($g(^DHCEQCCode("DHCEQCBuildingStruct",TFromStructDR)),"^",2)
	s TToStructDR=$p($g(^DHCEQBuildingChange(rowid)),"^",12)
	i TToStructDR'="" s TToStruct=$p($g(^DHCEQCCode("DHCEQCBuildingStruct",TToStructDR)),"^",2)
	s TFromBuildingArea=$p($g(^DHCEQBuildingChange(rowid)),"^",13)
	s TToBuildingArea=$p($g(^DHCEQBuildingChange(rowid)),"^",14)
	s TFromUtilizationArea=$p($g(^DHCEQBuildingChange(rowid)),"^",15)
	s TToUtilizationArea=$p($g(^DHCEQBuildingChange(rowid)),"^",16)
	s TFromSubArea=$p($g(^DHCEQBuildingChange(rowid)),"^",17)
	s TToSubArea=$p($g(^DHCEQBuildingChange(rowid)),"^",18)
	s TFromFloorNum=$p($g(^DHCEQBuildingChange(rowid)),"^",19)
	s TToFloorNum=$p($g(^DHCEQBuildingChange(rowid)),"^",20)
	s TFromUnderFloorNum=$p($g(^DHCEQBuildingChange(rowid)),"^",21)
	s TToUnderFloorNum=$p($g(^DHCEQBuildingChange(rowid)),"^",22)
	s TFromLandArea=$p($g(^DHCEQBuildingChange(rowid)),"^",23)
	s TToLandArea=$p($g(^DHCEQBuildingChange(rowid)),"^",24)
	s THold1=$p($g(^DHCEQBuildingChange(rowid)),"^",25)
	s THold2=$p($g(^DHCEQBuildingChange(rowid)),"^",26)
	s THold3=$p($g(^DHCEQBuildingChange(rowid)),"^",27)
	s THold4=$p($g(^DHCEQBuildingChange(rowid)),"^",28)
	s THold5=$p($g(^DHCEQBuildingChange(rowid)),"^",29)
	s TStatus=$p($g(^DHCEQBuildingChange(rowid)),"^",30)
	q:(Status'="")&&(Status'=TStatus)
	s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"审核","3":"作废","":"")
	s TCreateUserDR=$p($g(^DHCEQBuildingChange(rowid)),"^",31)
	i TCreateUserDR'="" s TCreateUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TCreateUserDR)
	s TCreateDate=$p($g(^DHCEQBuildingChange(rowid)),"^",32)
	s TCreateTime=$p($g(^DHCEQBuildingChange(rowid)),"^",33)
	s TSubmitUserDR=$p($g(^DHCEQBuildingChange(rowid)),"^",34)
	i TSubmitUserDR'="" s TSubmitUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	s TSubmitDate=$p($g(^DHCEQBuildingChange(rowid)),"^",35)
	s TSubmitTime=$p($g(^DHCEQBuildingChange(rowid)),"^",36)
	s TAuditUserDR=$p($g(^DHCEQBuildingChange(rowid)),"^",37)
	i TAuditUserDR'="" s TAuditUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate=$p($g(^DHCEQBuildingChange(rowid)),"^",38)
	s TAuditTime=$p($g(^DHCEQBuildingChange(rowid)),"^",39)
	s TDropUserDR=$p($g(^DHCEQBuildingChange(rowid)),"^",40)
	i TDropUserDR'="" s TDropUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TDropUserDR)
	s TDropDate=$p($g(^DHCEQBuildingChange(rowid)),"^",41)
	s TDropTime=$p($g(^DHCEQBuildingChange(rowid)),"^",42)

	d OutputRowBuildingChange
	quit
OutputRowBuildingChange
	Set Data=$lb(TRowID,TEquip,TEquipDR,TChangeType,TChangeTypeDR,TChangeDate,TProjectItem,TStartDate,TFinishedDate,TCompany,TProjectFee,TCheckDate,TCheckUser,
	TFromStruct,TFromStructDR,TToStruct,TToStructDR,TFromBuildingArea,TToBuildingArea,TFromUtilizationArea,TToUtilizationArea,TFromSubArea,
	TToSubArea,TFromFloorNum,TToFloorNum,TFromUnderFloorNum,TToUnderFloorNum,TFromLandArea,TToLandArea,THold1,THold2,THold3,THold4,THold5,
	TStatus,TCreateUserDR,TCreateUser,TCreateDate,TCreateTime,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,
	TAuditUser,TAuditDate,TAuditTime,TDropUser,TDropUserDR,TDropDate,TDropTime)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBuildingChange
	s (TRowID,TEquip,TEquipDR,TChangeType,TChangeTypeDR,TChangeDate,TProjectItem,TStartDate,TFinishedDate,TCompany,TProjectFee,TCheckDate,TCheckUser,
	TFromStruct,TFromStructDR,TToStruct,TToStructDR,TFromBuildingArea,TToBuildingArea,TFromUtilizationArea,TToUtilizationArea,TFromSubArea,
	TToSubArea,TFromFloorNum,TToFloorNum,TFromUnderFloorNum,TToUnderFloorNum,TFromLandArea,TToLandArea,THold1,THold2,THold3,THold4,THold5,
	TStatus,TCreateUserDR,TCreateUser,TCreateDate,TCreateTime,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,
	TAuditUser,TAuditDate,TAuditTime,TDropUser,TDropUserDR,TDropDate,TDropTime)=""
	quit
}

ClassMethod BuildingChangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildingChangeExecute ]
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

ClassMethod BuildingChangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildingChangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetChangeType(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	if Type=1 w "<option value=></option>"
	w "<option value=1>改建</option>"
	w "<option value=2>扩建</option>"
	w "</select>",!
}

ClassMethod GetChangeStatus(name, width, Type) As %String
{
	;;下拉列表
	w "<select name='"_name_"' id='"_name_"' style='width:"_width_"' HEIGHT=0>"
	if Type=1 w "<option value=></option>"
	w "<option value=0>新增</option>"
	//w "<option value=1>提交</option>"
	w "<option value=2>审核</option>"
	w "<option value=3>作废</option>"
	w "</select>",!
}

Query GetBuilding(Building As %String = "") As %Query(ROWSPEC = "TRowID:%String,TBuildingName:%String,TStructDR:%String,TStruct:%String,TBuildingArea:%String,TUtilizationArea:%String,TSubArea:%String,TFloorNum:%String,TUnderFloorNum:%String")
{
}

ClassMethod GetBuildingExecute(ByRef qHandle As %Binary, Building As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s rowid=0
	s EquipTypeDR=##class(web.DHCEQCommon).GetSysInfo("401003")	//属于房屋建筑物的类组
	s StoreLocDR=0
	f  s StoreLocDR=$o(^DHCEQEquip(0,"StoreLocStatCat",StoreLocDR)) q:StoreLocDR=""  d
	.s StatCatDR=0
	.f  s StatCatDR=$o(^DHCEQEquip(0,"StoreLocStatCat",StoreLocDR,EquipTypeDR,StatCatDR)) q:StatCatDR=""  d
	..f  s rowid=$o(^DHCEQEquip(0,"StoreLocStatCat",StoreLocDR,EquipTypeDR,StatCatDR,rowid)) q:rowid=""  d
	...d BuildDataBuilding
	
	Quit $$$OK
BuildDataBuilding
	d ResetVariablesBuilding
	s TRowID=rowid
	s TBuildingName=$p($g(^DHCEQEquip(rowid)),"^",1) 
	q:(Building'="")&&(TBuildingName'[Building)
	s buildDR=$o(^DHCEQBuilding(0,"EquipDR",rowid,0))
	i buildDR'=""  d		//Add By DJ 2015-07-14 DJ0147
	.s TStructDR=$p($g(^DHCEQBuilding(buildDR)),"^",2)
	.s TStruct=$p($g(^DHCEQCBuildingStruct(buildDR)),"^",2)
	.s TBuildingArea=$p($g(^DHCEQBuilding(buildDR)),"^",3)
	.s TUtilizationArea=$p($g(^DHCEQBuilding(buildDR)),"^",4)
	.s TSubArea=$p($g(^DHCEQBuilding(buildDR)),"^",5)
	.s TFloorNum=$p($g(^DHCEQBuilding(buildDR)),"^",19)
	.s TUnderFloorNum=$p($g(^DHCEQBuilding(buildDR)),"^",20)
	
	d OutputRowBuilding
	quit
OutputRowBuilding
	Set Data=$lb(TRowID,TBuildingName,TStructDR,TStruct,TBuildingArea,TUtilizationArea,TSubArea,TFloorNum,TUnderFloorNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBuilding
	s (TRowID,TBuildingName,TStructDR,TStruct,TBuildingArea,TUtilizationArea,TSubArea,TFloorNum,TUnderFloorNum)=""
	quit
}

ClassMethod GetBuildingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuildingExecute ]
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

ClassMethod GetBuildingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuildingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBuildingChangeDetail(rowid)
{
	i rowid="" q ""
	new result,resultex
	s result=^DHCEQBuildingChange(rowid)
	s resultex=rowid_"^"
	i $p(result,"^", 1)'="" d
	.s resultex=resultex_$p($g(^DHCEQEquip($p(result,"^", 1))),"^", 1)
	s resultex=resultex_"^"
	i $p(result,"^", 3)'="" d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",3),"date")
	s resultex=resultex_"^"
	i $p(result,"^", 5)'="" d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",5),"date")
	s resultex=resultex_"^"
	i $p(result,"^", 6)'="" d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",6),"date")
	s resultex=resultex_"^"
	i $p(result,"^", 9)'="" d
	.s resultex=resultex_##class(web.DHCEQCommon).TransValueToPage($p(result,"^",9),"date")
	s resultex=resultex_"^"
	i $p(result,"^", 11)'="" d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBuildingStruct",$p(result,"^", 11))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^", 12)'="" d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCBuildingStruct",$p(result,"^", 12))),"^",2)
	
	s resultex=result_"^"_resultex
	s resultex=##class(web.DHCEQCommon).Replace(resultex,$C(13,10),"\n")
	q resultex
}

Query LookUp(para) As %SQLQuery(ROWSPEC = "Description:%String,HIDDEN:%String,Code:%String")
{
SELECT BS_Desc,
	   BS_RowID,
	   BS_Code
FROM sqluser.DHC_EQCBuildingStruct
where BS_InvalidFlag = 'N' and BS_Desc like nvl(:para,'')||'%'
}

}
