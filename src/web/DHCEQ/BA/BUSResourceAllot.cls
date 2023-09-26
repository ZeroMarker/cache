/// add by ZY0285 20211201
/// 处理科室资源成本数据分配到设备的功能方法
Class web.DHCEQ.BA.BUSResourceAllot Extends %Library.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Add by ZY0285 20211201
/// 获取设备某一个资源在一个月应该分配的费用。
/// 入参：ResourceTypeID	资源类型ID
/// 	  LocID	科室ID
/// 	  Year	年度
/// 	  Month	月份
/// 返回：设备在一个资源类型总占的金额
/// w ##Class(web.DHCEQ.BA.BUSResourceAllot).GetAllotFee(1,61,2021,6)
ClassMethod GetAllotFee(ResourceTypeID, EquipID, nYear, nMonth)
{
	s LocID=$p($g(^DHCEQEquip(EquipID)),"^",67)
	s OriginalFee=$p($g(^DHCEQEquip(EquipID)),"^",27)
	
 	s RowidFind=""
 	&SQL(select UC_RowID into :RowidFind from SQLUSER.DHC_EQUseContext where UC_Year=:nYear and UC_Month=:nMonth and UC_EquipDR=:EquipID)

 	i RowidFind="" q 0
 	
 	s AllotMode=""
 	s AllotTotal=0
 	s AllotAmount=0
	s RARowID=0
	f  s RARowID=$o(^DHCEQResourceAllot(0,"ResourceType",ResourceTypeID,LocID,nYear, nMonth,2,RARowID)) q:RARowID=""  d
	.s datalist=$g(^DHCEQResourceAllot(RARowID))
	.q:$p(datalist,"^",12)="Y"
	.s AllotAmount=$p(datalist,"^",5)
	.s AllotMode=$p(datalist,"^",8)
	.s AllotTotal=$p(datalist,"^",9)
	
	i AllotMode=1 d
	.s Fee=OriginalFee
	e  i AllotMode=2 d
	.s Fee=$p($g(^DHCEQUseContext(RowidFind)),"^",19)	//income
	e  i AllotMode=3 d
	.s Fee=$p($g(^DHCEQUseContext(RowidFind)),"^",21)	//workload

	i AllotTotal>0 q ##Class(web.DHCEQCommon).FormatNumber(AllotAmount*Fee/AllotTotal,"",2)
	q 0
}

/// Add by ZY0285 20211201
/// 获取一个科一个月效益设备的总原值，总工作量，总收入
/// 入参：ResourceTypeID	资源类型ID
/// 	  LocID	科室ID
/// 	  Year	年度
/// 	  Month	月份
/// 返回：科室:总原值^总工作量^总收入
/// w ##Class(web.DHCEQ.BA.BUSResourceAllot).GetAllotTotal(URRowID)
ClassMethod GetAllotTotal(ResourceTypeID, LocID, Year, Month)
{
	s (TotalOriginalFee,TotalWorkload,TotalIncome)=0
	
	s EquipDR=0
	f  s EquipDR=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR)) q:EquipDR=""  d
	.s EquipData=$g(^DHCEQEquip(EquipDR))
	.s StoreLocID=$p(EquipData,"^",67)
	.q:(LocID'="")&&(LocID'=StoreLocID)
	.q:##Class(web.DHCEQ.BA.BUSUsedResource).CheckCanUseResource(ResourceTypeID,EquipDR)'=1
	.
	.s rowid=0
	.f  s rowid=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipDR,Year,+Month,rowid)) q:rowid=""  d
	..s datalist=$g(^DHCEQUseContext(rowid))
	..q:$p(datalist,"^",44)="Y"
	..s TotalWorkload=TotalWorkload+$p(datalist,"^",21)
	..s TotalIncome=TotalIncome+$p(datalist,"^",19)
	..
	.
	.s TotalOriginalFee=TotalOriginalFee+$p(EquipData,"^",27)
	q TotalOriginalFee_"^"_TotalIncome_"^"_TotalWorkload
}

ClassMethod SaveData(data, opt)
{
	s $ZT="ERRORSave"
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	TSTART
	if opt=0
	{
		s RowID=data
		&SQL(Update SQLUSER.DHC_EQResourceAllot set RA_InvalidFlag='Y' where RA_RowID = :RowID)
		s RowID=""
	}
	elseif opt=1
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQResourceAllot",JsonData,.PLIST)
		s RowID = JsonData.RARowID
		s PLIST(10) = $p(##Class(web.DHCEQ.BA.BUSResourceAllot).GetAllotTotal(PLIST(5),PLIST(2),PLIST(3),PLIST(4)),"^",3)  //modified by wy 2023-3-24
		s PLIST(12) = "0"
		s PLIST(13) = "N"
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQResourceAllot Values :PLIST() where RA_RowID = :RowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQResourceAllot Values :PLIST())
			s RowID=$g(%ROWID)
		}
	}
	elseif opt=2
	{
		s RowID=data
		s RATotal=+$p($g(^DHCEQResourceAllot(RowID)),"^",9)
		///modified by ZY 20220808 2692035
		if RATotal'>0 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-1300,"效益设备分配总量小于等于0,不能提交.")
		&SQL(Update SQLUSER.DHC_EQResourceAllot set RA_Status='2' where RA_RowID = :RowID)
		s RowID=""
		//modified by wy 2023-03-24 3382268根据提交的科室资源分配重写使用资源信息
		s SQLCODE=0
 	    s EquipID=0
 	    s Year=+$p($ZD($H,3),"-",1)
		s Month=+$p($ZD($H,3),"-",2)
		s Month=Month-1
		i Month=0
		{
			s Month=12
			s Year=Year-1
		}
		f  s EquipID=$o(^DHCEQBenefitEquipList(0,"Equip",EquipID)) q:(EquipID="")||(SQLCODE'=0)  d
		.s ResourceTypeID=0
		.f  s ResourceTypeID=$o(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID))  quit:ResourceTypeID=""||SQLCODE'=0  d
		..q:##Class(web.DHCEQ.BA.BUSUsedResource).CheckCanUseResource(ResourceTypeID,EquipID)'=1
		..s datalist= $g(^DHCEQCCode("DHCEQCResourceType",ResourceTypeID))
		..q:$p(datalist,"^",4)="Y"
		..s ResourceTypeCode=$p(datalist,"^",1)
		..s ResourceData=##Class(web.DHCEQ.BA.BUSUsedResource).GetResourceDataByCode(ResourceTypeCode,EquipID,Year,Month)
		..s ResourceFee=+$p(ResourceData,"^",1)
		..s Times=+$p(ResourceData,"^",2)
		..s Days=+$p(ResourceData,"^",3)
		..s SQLCODE=0	
		..i ResourceFee>0 s SQLCODE=##class(web.DHCEQ.BA.BUSUsedResource).SaveUsedResourceDate(Year,Month,"1",EquipID,ResourceTypeID,ResourceFee)
		..q:SQLCODE'=0
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORSave
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSResourceAllot","GetResourceAllot")
Query GetResourceAllot(LocDR As %String = "", ResourceTypeDR As %String = "", Year As %String = "", Month As %String = "") As %Query(ROWSPEC = "RARowID:%String,RALocDR:%String,RALoc:%String,RAYear:%String,RAMonth:%String,RAResourceTypeDR:%String,RAResourceType:%String,RAAmount:%String,RARate:%String,RAAllotAmount:%String,RAAllotMode:%String,RAAllotModeDesc:%String,RATotal:%String,RARemark:%String,RAStatus:%String,RAStatusDesc:%String,RAHold1:%String,RAHold2:%String,RAHold3:%String,RAHold4:%String,RAHold5:%String")
{
}

ClassMethod GetResourceAllotExecute(ByRef qHandle As %Binary, LocDR As %String = "", ResourceTypeDR As %String = "", Year As %String = "", Month As %String = "") As %Status
{
	//new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQResourceAllot(rowid))  q:rowid=""  d
	.s datalist=$g(^DHCEQResourceAllot(rowid))
	.q:$p(datalist,"^",12)="Y"	//modified by ZY0288 2021-12-30
	.s RARowID=rowid
	.s RALocDR=$p(datalist,"^",1)
	.q:(LocDR'="")&&(LocDR'=RALocDR)
	.s RALoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",RALocDR)
	.s RAYear=$p(datalist,"^",2)
	.q:(Year'="")&&(Year'=RAYear)
	.s RAMonth=$p(datalist,"^",3)
	.q:(Month'="")&&(Month'=RAMonth)
	.s RAResourceTypeDR=$p(datalist,"^",4)
	.q:(ResourceTypeDR'="")&&(ResourceTypeDR'=RAResourceTypeDR)
	.s RAResourceType=$p($g(^DHCEQCCode("DHCEQCResourceType",RAResourceTypeDR)),"^",2)
	.s RAAmount=$p(datalist,"^",5)
	.s RARate=$p(datalist,"^",6)
	.s RAAllotAmount=$p(datalist,"^",7)
	.s RAAllotMode=$p(datalist,"^",8)
	.s RAAllotModeDesc=$Case(RAAllotMode,1:"原值",2:"收入",3:"工作量")
	.s RATotal=$p(datalist,"^",9)
	.s RARemark=$p(datalist,"^",10)
	.s RAStatus=$p(datalist,"^",11)
	.s RAStatusDesc=$Case(RAStatus,0:"新增",1:"提交",2:"审核")
	.s RAHold1=$p(datalist,"^",13)
	.s RAHold2=$p(datalist,"^",14)
	.s RAHold3=$p(datalist,"^",15)
	.s RAHold4=$p(datalist,"^",16)
	.s RAHold5=$p(datalist,"^",17)
	.
	.d OutputRowGetResourceAllot
		
	Quit $$$OK
OutputRowGetResourceAllot
	Set Data=$lb(RARowID,RALocDR,RALoc,RAYear,RAMonth,RAResourceTypeDR,RAResourceType,RAAmount,RARate,RAAllotAmount,RAAllotMode,RAAllotModeDesc,RATotal,RARemark,RAStatus,RAStatusDesc,RAHold1,RAHold2,RAHold3,RAHold4,RAHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	Quit
}

ClassMethod GetResourceAllotFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetResourceAllotExecute ]
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

ClassMethod GetResourceAllotClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetResourceAllotExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
