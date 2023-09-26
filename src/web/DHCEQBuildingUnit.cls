/// Created By HZY 2012-10-16
Class web.DHCEQBuildingUnit Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query BuildingUnit(BuildingDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TBuildingDR:%String,TBuildingName:%String,TDesc:%String,TFloor:%String,TDoorNo:%String,TPlace:%String,TBuildingArea:%String,TUtilizationArea:%String,TStuct:%String,TUseLocDR:%String,TUseLoc:%String,TLendTypeDR:%String,TLendType:%String,TCompany:%String,TContractPerson:%String,TPurposeDR:%String,TPurpose:%String,TOriginalFee:%String,TRentFee:%String,TRentFeeType:%String,TBeginDate:%String,TEndDate:%String,TUserDR:%String,TUser:%String,TDate:%String,TSubmitUserDR:%String,TSubmitUser:%String,TSubmitDate:%String,TSubmitTime:%String,TAuditUserDR:%String,TAuditUser:%String,TAuditDate:%String,TAuditTime:%String,TStatus:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String")
{
}

ClassMethod BuildingUnitExecute(ByRef qHandle As %Binary, BuildingDR As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=2
	s rowid=0
	s BuildingAreaTotal=0
	s UtilizationAreaTotal=0
	f  s rowid=$o(^DHCEQBuildingUnit(0,"Building",BuildingDR,rowid)) q:rowid=""  d
	.d BuildDataBuildingUnit
	
	d ResetVariablesBuildingUnit
	s BuildingAreaLeft=$p($g(^DHCEQBuilding(BuildingDR)),"^",3)-BuildingAreaTotal	//未分配建筑面积
	s UtilizationAreaLeft=$p($g(^DHCEQBuilding(BuildingDR)),"^",4)-UtilizationAreaTotal	//未分配使用面积
	s BuildingAreaLeft=##Class(web.DHCEQCommon).FormatNumber(BuildingAreaLeft,"",2)
	s UtilizationAreaLeft=##Class(web.DHCEQCommon).FormatNumber(UtilizationAreaLeft,"",2)
	s BuildingAreaTotal=##Class(web.DHCEQCommon).FormatNumber(BuildingAreaTotal,"",2)
	s UtilizationAreaTotal=##Class(web.DHCEQCommon).FormatNumber(UtilizationAreaTotal,"",2)
	s TBuildingName="合计:"
	s TDesc="未分配:"_BuildingAreaLeft_"/"_UtilizationAreaLeft
	s TBuildingArea=BuildingAreaTotal
	s TUtilizationArea=UtilizationAreaTotal
	s index=1
	d OutputRowBuildingUnit
	
	Quit $$$OK
BuildDataBuildingUnit
	//RowID^BuildingDR^Desc^Floor^DoorNo^Place^BuildingArea^UtilizationArea^Stuct^UseLocDR^LendTypeDR^
	//Company^ContractPerson^PurposeDR^OriginalFee^RentFee^RentFeeType^BeginDate^EndDate^UserDR^Date^
	//SubmitUserDR^AuditUserDR^Status^Hold1^Hold2^Hold3^Hold4^Hold5
	d ResetVariablesBuildingUnit
	s TRowID=rowid
	s TBuildingDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",1)
	s EquipDR=$p($g(^DHCEQBuilding(TBuildingDR)),"^",1)
	s TBuildingName=$p($g(^DHCEQEquip(EquipDR)),"^",1) 
	s TDesc=$p($g(^DHCEQBuildingUnit(rowid)),"^",2)
	s TFloor=$p($g(^DHCEQBuildingUnit(rowid)),"^",3)
	s TDoorNo=$p($g(^DHCEQBuildingUnit(rowid)),"^",4)
	s TPlace=$p($g(^DHCEQBuildingUnit(rowid)),"^",5)
	s TBuildingArea=$p($g(^DHCEQBuildingUnit(rowid)),"^",6)
	s TUtilizationArea=$p($g(^DHCEQBuildingUnit(rowid)),"^",7)
	s TStuct=$p($g(^DHCEQBuildingUnit(rowid)),"^",8)
	s TUseLocDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",9)
	i TUseLocDR'="" s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLocDR)
	s TLendTypeDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",10)
	i TLendTypeDR'="" s TLendType=$p($g(^DHCEQCCode("DHCEQCLendType",TLendTypeDR)),"^",2)
	s TCompany=$p($g(^DHCEQBuildingUnit(rowid)),"^",11)
	s TContractPerson=$p($g(^DHCEQBuildingUnit(rowid)),"^",12)
	s TPurposeDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",13)
	i TPurposeDR'="" s TPurpose=$p($g(^DHCEQCCode("DHCEQCLandPurpose",TPurposeDR)),"^",2)
	s TOriginalFee=$p($g(^DHCEQBuildingUnit(rowid)),"^",14)
	s TRentFee=$p($g(^DHCEQBuildingUnit(rowid)),"^",15)
	s TRentFeeType=$p($g(^DHCEQBuildingUnit(rowid)),"^",16)
	s TBeginDate=$p($g(^DHCEQBuildingUnit(rowid)),"^",17)
	i TBeginDate'="" s TBeginDate=##Class(web.DHCEQCommon).TransValueToPage(TBeginDate,"date")
	s TEndDate=$p($g(^DHCEQBuildingUnit(rowid)),"^",18)
	i TEndDate'="" s TEndDate=##Class(web.DHCEQCommon).TransValueToPage(TEndDate,"date")
	s TUserDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",19)
	i TUserDR'="" s TUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
	s TDate=$p($g(^DHCEQBuildingUnit(rowid)),"^",20)
	i TDate'="" s TDate=##Class(web.DHCEQCommon).TransValueToPage(TDate,"date")
	s TSubmitUserDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",21)
	i TSubmitUserDR'="" s TSubmitUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TSubmitUserDR)
	s TSubmitDate=$p($g(^DHCEQBuildingUnit(rowid)),"^",22)
	i TSubmitDate'="" s TSubmitDate=##Class(web.DHCEQCommon).TransValueToPage(TSubmitDate,"date")
	s TSubmitTime=$p($g(^DHCEQBuildingUnit(rowid)),"^",23)
	s TAuditUserDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",24)
	i TAuditUserDR'="" s TAuditUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TAuditUserDR)
	s TAuditDate=$p($g(^DHCEQBuildingUnit(rowid)),"^",25)
	i TAuditDate'="" s TAuditDate=##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
	s TAuditTime=$p($g(^DHCEQBuildingUnit(rowid)),"^",26)
	s TStatus=$p($g(^DHCEQBuildingUnit(rowid)),"^",27)
	s TStatus=..GetBuildingUnitStatusDisplay(TStatus)
	s THold1=$p($g(^DHCEQBuildingUnit(rowid)),"^",28)
	s THold2=$p($g(^DHCEQBuildingUnit(rowid)),"^",29)
	s THold3=$p($g(^DHCEQBuildingUnit(rowid)),"^",30)
	s THold4=$p($g(^DHCEQBuildingUnit(rowid)),"^",31)
	s THold5=$p($g(^DHCEQBuildingUnit(rowid)),"^",32)
	s TBuildingArea=##Class(web.DHCEQCommon).FormatNumber(TBuildingArea,"",2)
	s TUtilizationArea=##Class(web.DHCEQCommon).FormatNumber(TUtilizationArea,"",2)
	s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee,"",2)
	s TRentFee=##Class(web.DHCEQCommon).FormatNumber(TRentFee,"",2)

	s BuildingAreaTotal=BuildingAreaTotal+TBuildingArea	//已分配建筑面积之和.
	s UtilizationAreaTotal=UtilizationAreaTotal+TUtilizationArea	//已分配使用面积之和.
	d OutputRowBuildingUnit
	quit
OutputRowBuildingUnit
	Set Data=$lb(TRowID,TBuildingDR,TBuildingName,TDesc,TFloor,TDoorNo,TPlace,TBuildingArea,TUtilizationArea,TStuct,TUseLocDR,TUseLoc,TLendTypeDR,TLendType
	,TCompany,TContractPerson,TPurposeDR,TPurpose,TOriginalFee,TRentFee,TRentFeeType,TBeginDate,TEndDate,TUserDR,TUser,TDate
	,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime,TStatus,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBuildingUnit
	s (TRowID,EquipDR,TBuildingDR,TBuildingName,TDesc,TFloor,TDoorNo,TPlace,TBuildingArea,TUtilizationArea,TStuct,TUseLocDR,TUseLoc,TLendTypeDR,TLendType
	,TCompany,TContractPerson,TPurposeDR,TPurpose,TOriginalFee,TRentFee,TRentFeeType,TBeginDate,TEndDate,TUserDR,TUser,TDate
	,TSubmitUserDR,TSubmitUser,TSubmitDate,TSubmitTime,TAuditUserDR,TAuditUser,TAuditDate,TAuditTime,TStatus,THold1,THold2,THold3,THold4,THold5)=""
	quit
}

ClassMethod BuildingUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = BuildingUnitExecute ]
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

ClassMethod BuildingUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = BuildingUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

Query GetBuilding(RowID As %String = "", Desc As %String = "") As %Query(ROWSPEC = "TDesc:%String,HIDDEN:%String,TCode:%String")
{
}

ClassMethod GetBuildingExecute(ByRef qHandle As %Binary, RowID As %String = "", Desc As %String = "") As %Status
{
	new repid, index
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s tmprowid=0
	if (RowID>0)
	{
		s tmprowid=RowID
		d BuildDataBuilding
	}
	else 
	{
		f  s tmprowid=$o(^DHCEQBuilding(tmprowid)) q:(tmprowid="")  d
		.d BuildDataBuilding
	}
	Quit $$$OK
	
BuildDataBuilding
	d ResetVariablesBuilding
	s TRowID=tmprowid
	s EquipDR=$p($g(^DHCEQBuilding(TRowID)),"^",1)
	s TDesc=$p($g(^DHCEQEquip(EquipDR)),"^",1)
	s TCode=$p($g(^DHCEQEquip(EquipDR)),"^",6)
	q:((Desc'="")&&(Desc'=TDesc)&&(Desc'=TCode))
	d OutputRowGetBuilding
	quit
OutputRowGetBuilding
	Set Data=$lb(TDesc,TRowID,TCode)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesBuilding
	s (TRowID,TCode,TDesc)=""
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

ClassMethod GetOneBuildingUnit(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	s result=^DHCEQBuildingUnit(rowid)
	s resultex=rowid   //0
	s resultex=resultex_"^"	//1
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p(result,"^",1) //code
	s resultex=resultex_"^"	//2
	i $p(result,"^",2)'=""  d
	.s resultex=resultex_$p(result,"^",2) //
	s resultex=resultex_"^"	//3
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_$p(result,"^",3) //
	s resultex=resultex_"^"	//4
	i $p(result,"^",4)'=""  d
	.s resultex=resultex_$p(result,"^",4)
	s resultex=resultex_"^"	//5
	i $p(result,"^",5)'=""  d
	.s resultex=resultex_$p(result,"^",5)
	s resultex=resultex_"^"	//6
	i $p(result,"^",6)'=""  d
	.s resultex=resultex_$p(result,"^",6)
	s resultex=resultex_"^"	//7
	i $p(result,"^",7)'=""  d
	.s resultex=resultex_$p(result,"^",7) //
	s resultex=resultex_"^"	//8
	i $p(result,"^",8)'=""  d
	.s resultex=resultex_$p(result,"^",8) //
	s resultex=resultex_"^"	//9
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_$p(result,"^",9) //
	s resultex=resultex_"^"	//10
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$p(result,"^",10) //
	s resultex=resultex_"^"	//11
	i $p(result,"^",11)'=""  d
	.s resultex=resultex_$p(result,"^",11) //
	s resultex=resultex_"^"	//12
	i $p(result,"^",12)'=""  d
	.s resultex=resultex_$p(result,"^",12) //
	s resultex=resultex_"^"	//13
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_$p(result,"^",13) //
	s resultex=resultex_"^"
	i $p(result,"^",14)'=""  d
	.s resultex=resultex_$p(result,"^",14) //
	s resultex=resultex_"^"
	i $p(result,"^",15)'=""  d
	.s resultex=resultex_$p(result,"^",15)
	s resultex=resultex_"^"
	i $p(result,"^",16)'=""  d
	.s resultex=resultex_$p(result,"^",16)
	s resultex=resultex_"^"
	i $p(result,"^",17)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",17),"date")
	s resultex=resultex_"^"
	i $p(result,"^",18)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",18),"date")
	s resultex=resultex_"^"
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_$p(result,"^",19)
	s resultex=resultex_"^"
	i $p(result,"^",20)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).TransValueToPage($p(result,"^",20),"date")
	s resultex=resultex_"^"
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_$p(result,"^",21)
	s resultex=resultex_"^"
	i $p(result,"^",22)'=""  d
	.s resultex=resultex_$p(result,"^",22)
	s resultex=resultex_"^"
	i $p(result,"^",23)'=""  d
	.s resultex=resultex_$p(result,"^",23)
	s resultex=resultex_"^"
	i $p(result,"^",24)'=""  d
	.s resultex=resultex_$p(result,"^",24)
	s resultex=resultex_"^"
	i $p(result,"^",25)'=""  d
	.s resultex=resultex_$p(result,"^",25)
	s resultex=resultex_"^"
	i $p(result,"^",26)'=""  d
	.s resultex=resultex_$p(result,"^",26)
	s resultex=resultex_"^"
	i $p(result,"^",27)'=""  d
	.s resultex=resultex_$p(result,"^",27)
	s resultex=resultex_"^"
	i $p(result,"^",28)'=""  d
	.s resultex=resultex_$p(result,"^",28)
	s resultex=resultex_"^"
	i $p(result,"^",29)'=""  d
	.s resultex=resultex_$p(result,"^",29)
	s resultex=resultex_"^"
	i $p(result,"^",30)'=""  d
	.s resultex=resultex_$p(result,"^",30)
	s resultex=resultex_"^"
	i $p(result,"^",31)'=""  d
	.s resultex=resultex_$p(result,"^",31)
	s resultex=resultex_"^"
	i $p(result,"^",32)'=""  d
	.s resultex=resultex_$p(result,"^",32)
	
	s resultex=resultex_"^"
	i $p(result,"^",1)'=""  d
	.s resultex=resultex_$p($g(^DHCEQEquip($p($g(^DHCEQBuilding($p(result,"^",1))),"^",1))),"^",1)
	s resultex=resultex_"^"
	i $p(result,"^",9)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("dept",$p(result,"^",9))
	s resultex=resultex_"^"
	i $p(result,"^",10)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCLendType",$p(result,"^",10))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^",13)'=""  d
	.s resultex=resultex_$p($g(^DHCEQCCode("DHCEQCLandPurpose",$p(result,"^",13))),"^",2)
	s resultex=resultex_"^"
	i $p(result,"^",19)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",19))
	s resultex=resultex_"^"
	i $p(result,"^",21)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",21))
	s resultex=resultex_"^"
	i $p(result,"^",24)'=""  d
	.s resultex=resultex_##Class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",24))
	
	
	q resultex
}

ClassMethod SaveData(val As %Library.String = "", isDel As %Library.String = "")
{
	 k PLIST,rowid
	 s rowid=$p(val,"^",1)
	 i (+isDel=1)
	 {
		 &SQL(Delete from SQLUSER.DHC_EQBuildingUnit where BU_RowID=:rowid )
	 	 if SQLCODE
	 	 {
		 	 TROLLBACK
		 	 q SQLCODE
	 	 }
	 	 q rowid
	 }
	//RowID^BuildingDR^Desc^Floor^DoorNo^Place^BuildingArea^UtilizationArea^Stuct^UseLocDR^LendTypeDR^
	//Company^ContractPerson^PurposeDR^OriginalFee^RentFee^RentFeeType^BeginDate^EndDate^UserDR^Date^
	//SubmitUserDR^AuditUserDR^Status^Hold1^Hold2^Hold3^Hold4^Hold5

	 s PLIST(2) = $p(val,"^",2)		;BuildingDR
	 s PLIST(3) = $p(val,"^",3)		;Desc
	 s PLIST(4) = $p(val,"^",4)		;Floor
	 s PLIST(5) = $p(val,"^",5)		;DoorNo
	 s PLIST(6) = $p(val,"^",6)		;Place
	 s PLIST(7) = $p(val,"^",7)		;BuildingArea
	 s PLIST(8) = $p(val,"^",8)		;UtilizationArea
	 s PLIST(9) = $p(val,"^",9)		;Stuct
	 s PLIST(10) = $p(val,"^",10)	;UseLocDR
	 s PLIST(11) = $p(val,"^",11)	;LendTypeDR
	 s PLIST(12) = $p(val,"^",12)	;Company
	 s PLIST(13) = $p(val,"^",13)	;ContractPerson
	 s PLIST(14) = $p(val,"^",14)	;PurposeDR
	 s PLIST(15) = $p(val,"^",15)	;OriginalFee
	 s PLIST(16) = $p(val,"^",16)	;RentFee
	 s PLIST(17) = $p(val,"^",17)	;RentFeeType
	 s PLIST(18) = $p(val,"^",18)	;BeginDate
	 i $p(val,"^",18)'=""  s PLIST(18) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",18),"date")
	 s PLIST(19) = $p(val,"^",19)	;EndDate
	 i $p(val,"^",19)'=""  s PLIST(19) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",19),"date")
	 s PLIST(20) = $p(val,"^",20)	;UserDR
	 s PLIST(21) = $p(val,"^",21)	;Date
	 i $p(val,"^",21)'=""  s PLIST(21) = ##Class(web.DHCEQCommon).TransValueFromPage($p(val,"^",21),"date")
	 s PLIST(22) = $p(val,"^",22)	;SubmitUserDR
	 //s PLIST(23) = $p(val,"^",23)	//+$H	;SubmitDate
	 //s PLIST(24) = $p(val,"^",24)	//$P($H,",",2)	;SubmitTime
	 s PLIST(25) = $p(val,"^",25)	;AuditUserDR
	 //s PLIST(26) = $p(val,"^",26)	//+$H	;AuditDate
	 //s PLIST(27) = $p(val,"^",27)	//$P($H,",",2)	;AuditTime
	 //s PLIST(28) = $p(val,"^",28)	;Status
	 s PLIST(29) = $p(val,"^",29)	;Hold1
	 s PLIST(30) = $p(val,"^",30)	;Hold2
	 s PLIST(31) = $p(val,"^",31)	;Hold3
	 s PLIST(32) = $p(val,"^",32)	;Hold4
	 s PLIST(33) = $p(val,"^",33)	;Hold5
	 
	 if (rowid'="") 
	 {
		 s PLIST(28) = "0"	;Status
		 &SQL(Update SQLUSER.DHC_EQBuildingUnit Values :PLIST() where BU_RowID =:rowid) 
	 }
	 else
	 {	 
	 	 s PLIST(28) = "0"	;Status
		 &SQL(Insert Into SQLUSER.DHC_EQBuildingUnit Values :PLIST())
	 }
	 if SQLCODE
	 {
		 q SQLCODE
	 }
	 Set ID=$g(%ROWID)
	 q ID
}

ClassMethod GetBuildingUnitStatusDisplay(status As %Library.String) As %Status
{
	i status=""  q ""
	i +status=0  q "新增"
	i +status=1  q "提交"
	i +status=2  q "审核"
	q "未定义"
}

/// 判断'建筑面积'和'使用面积'的数值是否合理.
ClassMethod JudgeAreaReasonable(BuildingRowID, BURowID, BuildingArea, UtilizationArea)
{
	//.所有科室的'建筑面积'的和不能大于建筑的总面积.
	//.所有科室的'使用面积'的和不能大于建筑的总使用面积.
	s totalBuildingArea=BuildingArea
	s totalUtilizationArea=UtilizationArea
	s rtn=""
	s rowid=0
	f  s rowid=$o(^DHCEQBuildingUnit(0,"Building",BuildingRowID,rowid)) q:rowid=""  d
	.q:((BURowID>0)&&(BURowID=rowid))
	.s totalBuildingArea=totalBuildingArea+$p($g(^DHCEQBuildingUnit(rowid)),"^",6)
	.s totalUtilizationArea=totalUtilizationArea+$p($g(^DHCEQBuildingUnit(rowid)),"^",7)
	
	s BDBuildingArea=$p($g(^DHCEQBuilding(BuildingRowID)),"^",3)
	s BDUtilizationArea=$p($g(^DHCEQBuilding(BuildingRowID)),"^",4)
	if (totalBuildingArea>BDBuildingArea)
	{
		s rtn="科室的'建筑面积'设置过大,请重置."
	}
	if (totalUtilizationArea>BDUtilizationArea)
	{
		if (rtn'="")
		{
			s rtn=rtn_$c(13,10)_"科室的'使用面积'设置过大,请重置."
		}else{
			s rtn="科室的'使用面积'设置过大,请重置."
		}
	}
	q rtn
}

/// 建筑单元分摊成本设置.
ClassMethod BuildingUnitDepreAllot(BuildingDR As %Library.String = "")
{
	//统计出每个科室占的使用面积和,根据科室的面积除以建筑的总使用面积 得到科室占的百分比(精确到0.01%),
	//然后再将BuildingDR,UseLocDR,百分比  传入分摊设置的函数中,一个科室一条记录.
	//且每次作修改后 需要更新该建筑物下的所有分摊设置.
	//百分比四舍五入计算后 差额都记到最后一个科室的账上.
	//^DHCEQBuilding(0,"EquipDR",{BD_EquipDR},{BD_RowID})
	//^DHCEQBuildingUnit(0,"Building",{BU_BuildingDR},{BU_RowID})
	s Date=+$H
	s Job=$J
	s tmpNode="BuildingUnitDepreAllot"
	d ##Class(web.DHCEQCommon).KillTempGlobal(tmpNode)
	s rowid=0	//汇总每个科室占的面积
	f  s rowid=$o(^DHCEQBuildingUnit(0,"Building",BuildingDR,rowid)) q:(rowid="")  d
	.s uselocDR=$p($g(^DHCEQBuildingUnit(rowid)),"^",9)
	.s useArea=+$p($g(^DHCEQBuildingUnit(rowid)),"^",7)
	.i '$D(^DHCEQTemp(tmpNode,Date,Job,uselocDR))  d
	..s ^DHCEQTemp(tmpNode,Date,Job,uselocDR)=useArea
	.e  d
	..s ^DHCEQTemp(tmpNode,Date,Job,uselocDR)=useArea+$g(^DHCEQTemp(tmpNode,Date,Job,uselocDR))
	
	s equipDR=$p($g(^DHCEQBuilding(BuildingDR)),"^",1)
	s totalUseArea=$p($g(^DHCEQBuilding(BuildingDR)),"^",4)	//建筑的总使用面积
	s Types=1
	s AllotType=0
	s tmpAreaTotal=0
	s AllotRate=0
	s tmpAllotRate=0
	s result=0
	s tmpLocDR=0	//计算每个科室的面积占的比例,并更新到分摊表里
	f  s tmpLocDR=$o(^DHCEQTemp(tmpNode,Date,Job,tmpLocDR)) q:(tmpLocDR="")||(result<0)  d
	.s useArea=$g(^DHCEQTemp(tmpNode,Date,Job,tmpLocDR))
	.s tmpAreaTotal=tmpAreaTotal+useArea
	.i (($o(^DHCEQTemp(tmpNode,Date,Job,tmpLocDR))="")&&(tmpAreaTotal=totalUseArea))  d    //若是最后一条且总面积已分配完,则将剩下的百分比全部算到最后一个科室上.
	..s AllotRate=100-tmpAllotRate
	.e  d
	..s AllotRate=##Class(web.DHCEQCommon).FormatNumber((useArea/totalUseArea)*100,"",2)
	..s tmpAllotRate=tmpAllotRate+AllotRate
	.s CALrowid=..GetCAlistIDofEquip(equipDR,Types,AllotType,tmpLocDR)
	.s plist=CALrowid_"^"_Types_"^"_equipDR_"^"_tmpLocDR_"^"_AllotRate_"^"_AllotType
	.s result=##Class(web.DHCEQCostAllot).SaveData("","",plist,0)
	
	q result
}

/// 根据设备ID和科室ID 得到科室的分摊明细的ID
ClassMethod GetCAlistIDofEquip(EquipDR, Types, AllotType, LocDR)
{
	//^DHCEQCostAllot(0,"EquipType",{CA_EquipDR},{CA_Types},{CA_RowID})
	//^DHCEQCostAllotList(0,"AllotLoc",{CAL_CostAllotDR},{CAL_AllotLocDR},{CAL_RowID})
	i ((EquipDR="")||(Types="")||(LocDR=""))  q ""
	s CALrowid=""
	s findCAID=""
	s CAID=0
	f  s CAID=$o(^DHCEQCostAllot(0,"EquipType",EquipDR,Types,CAID)) q:(CAID="")||(findCAID'="")  d
	.s ALTtype=$p($g(^DHCEQCostAllot(CAID)),"^",14)
	.q:(((AllotType'="")&&(AllotType'=ALTtype))||("Y"=$p($g(^DHCEQCostAllot(CAID)),"^",2)))
	.s findCAID=CAID
	
	if findCAID=""
	{
		q ""
	}
	else{
		s CALrowid=$o(^DHCEQCostAllotList(0,"AllotLoc",findCAID,LocDR,0))
		q CALrowid
	}
}

Storage Default
{
<Data name="DHCEQBuildingUnitDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCEQBuildingUnitD</DataLocation>
<DefaultData>DHCEQBuildingUnitDefaultData</DefaultData>
<IdLocation>^web.DHCEQBuildingUnitD</IdLocation>
<IndexLocation>^web.DHCEQBuildingUnitI</IndexLocation>
<StreamLocation>^web.DHCEQBuildingUnitS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
