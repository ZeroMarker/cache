Class web.DHCDT3D.Floor Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod SaveFloors(Data)
{
	s Iterator = Data.%GetIterator()
    //json遍历
    while Iterator.%GetNext(.key,.val) 
    {
	    s RowJson=val	
	    s JsonData = ##class(web.DHCDT3D.Floor).SaveFloorJson(RowJson)
	}
	//w "ok"
	Quit JsonData
}

ClassMethod SaveFloor(dataList, userName)
{
	k PLIST
	s SQLCODE=0
	s ISLRowIDs=""
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025") 
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=	$p(dataList,SplitRowCode,i)
		q:valList=""
		k PLIST,FRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBUFloor",JsonData,.PLIST)
		s FRowID = JsonData.FRowID
	    if FRowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQBUFloor Values :PLIST() where F_RowID = :FRowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQBUFloor Values :PLIST())
			s FRowID=$g(%ROWID)
		}
		
		
	}	
	q SQLCODE
}

ClassMethod SaveFloorJson(JsonData)
{
	
	
	s FRowID=""
	s BURowID = ""
	S SQLCODE=0
	s BuildKey = JsonData.BuildKey
	i BuildKey'="" s BuildingID=$Order(^DHCEQBUBuilding(0,"BuildKey",BuildKey,0))
	i BuildingID="" s SQLCODE=-1111
	i SQLCODE 
	{
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}
	d JsonData.%Set("FBuildingDR",BuildingID)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBUFloor",JsonData,.PLIST)
	
	&SQL(select F_RowID into :FRowID from SQLUSER.DHC_EQBUFloor where F_BuildingDR=:JsonData.FBuildingDR and F_FloorIndex=:JsonData.FFloorIndex and F_FloorNo=:JsonData.FFloorNo)

	
    if FRowID'=""
    {
		&SQL(Update SQLUSER.DHC_EQBUFloor Values :PLIST() where F_RowID = :FRowID)
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQBUFloor Values :PLIST())
		s FRowID=$g(%ROWID)
	}
	if SQLCODE
	{
		s SQLCODE=##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}
	else
	{
		s SQLCODE=##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,FRowID)
	}
	quit SQLCODE
}

ClassMethod SaveFloorOld(Data)
{
	
	//S Data=Data.%ToJSON()
	//s sddd=Data."12"
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	
	s SQLCODE=0
	s Length=$L(Data,",")
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=	$p(Data,",",i)  
		q:valList=""
		s (BuildingID,FRowID)=""
		k PLIST,BURowID,BUPRowID,BuildKey
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s BURowID = ""
		s BuildKey = JsonData.BuildKey
		i BuildKey'="" s BuildingID=$Order(^DHCEQBUBuilding(0,"BuildKey"," "_BuildKey,0))
		i BuildingID="" s SQLCODE=-100
		q:SQLCODE'=0
		d JsonData.%Set("FBuildingDR",BuildingID)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBUFloor",JsonData,.PLIST)
		&SQL(select F_RowID into :FRowID from SQLUSER.DHC_EQBUFloor where F_BuildingDR=:JsonData.FBuildingDR and F_FloorIndex=:JsonData.FFloorIndex and F_FloorNo=:JsonData.FFloorNo)

		
	    if FRowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQBUFloor Values :PLIST() where F_RowID = :FRowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQBUFloor Values :PLIST())
			s FRowID=$g(%ROWID)
		}
		if SQLCODE
		{
			s SQLCODE=##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
		}
		else
		{
			s SQLCODE=##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,FRowID)
		}
		

	}
	
	Quit "qqqqq"
}

/// ----------------------------------
/// 创建:lmm  2020-09-21
/// 描述:   查询各设备属性设备数量
/// 	入参:Building:建筑
/// 		 Floor:楼层
/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.Floor","GetFloor","B1","1")
/// ----------------------------------
Query GetFloor(BuildKey As %String = "", BuildingDR As %String = "", FloorNo As %String = "") As %Query(ROWSPEC = "FRowID:%String,FFloorNo:%String,FFloorUseLoc:%String,FFloorIndex:%String,FFloorNum:%String,FPurposeDesc:%String,FBuildingArea:%String,FUtilizationArea:%String,FHeight:%String,FPurpose:%String")
{
}

ClassMethod GetFloorExecute(ByRef qHandle As %Binary, BuildKey As %String = "", BuildingDR As %String = "", FloorNo As %String = "") As %Status
{
	//new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	//s ^lmm("dddd")=BuildKey_"^"_BuildingDR_"^"_FloorNo
	i (BuildKey="")&&(BuildingDR="")	Quit $$$OK
	i (BuildKey'="")&&(BuildingDR="") s BuildingDR=$Order(^DHCEQBUBuilding(0,"BuildKey",BuildKey,0))
	i BuildingDR="" Quit $$$OK
	
	s FloorIndex=""
	f  s FloorIndex=$o(^DHCEQBUFloor(0,"BuildingFloorIndex",BuildingDR,FloorIndex),-1) quit:FloorIndex=""  d
	.s rowid=0
	.f  s rowid=$o(^DHCEQBUFloor(0,"BuildingFloorIndex",BuildingDR,FloorIndex,rowid)) quit:rowid=""  d
	..s (TRowID,TFloorNo,TFloorUseLoc,TFloorIndex,TPurposeID)=""
	..s TRowID=rowid
	..s TFloorIndex=$p($g(^DHCEQBUFloor(rowid)),"^",2)
	..s TFloorNum=$p($g(^DHCEQBUFloor(rowid)),"^",3)
	..s TFloorNo=$p($g(^DHCEQBUFloor(rowid)),"^",4)
	..q:(FloorNo'="")&&(FloorNo'=TFloorNo)
	..s TFloorBuildingArea=$p($g(^DHCEQBUFloor(rowid)),"^",5)_"平方米"
	..s TFloorUtilizationArea=$p($g(^DHCEQBUFloor(rowid)),"^",6)_"平方米"
	..s TFloorHeight=$p($g(^DHCEQBUFloor(rowid)),"^",7)
	..s TPurposeID=$p($g(^DHCEQBUFloor(rowid)),"^",8)
	..i TPurposeID'="" s TPurpose=$p($g(^DHCEQCCode("DHCEQCLandPurpose",TPurposeID)),"^",2)
	..s BURowID=0
	..s TFloorUseLoc=""
	..f  s BURowID=$o(^DHCEQBUBuildingUnit(0,"BuildingFloor",BuildingDR,TFloorIndex,BURowID)) quit:BURowID=""  d
	...s TUnitUseLocDR=$p($g(^DHCEQBUBuildingUnit(BURowID)),"^",9)
	...q:(TUnitUseLocDR="")
	...;i TUnitUseLocDR'="" s TDepartmentDR=$o(^DHCEQCCode("DHCEQCDepartment",0,"ExID","Y","1",TUnitUseLocDR,0))
	...;i TDepartmentDR'="" s TUnitUseLoc=$p($g(^DHCEQCCode("DHCEQCDepartment",TDepartmentDR)),"^",2)
	...s TUnitUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept", TUnitUseLocDR)
	...i TFloorUseLoc=""  d
	....s TFloorUseLoc=TUnitUseLoc
	...e  i ((","_TFloorUseLoc_",")'[(","_TUnitUseLoc_","))  d
	....s TFloorUseLoc=TFloorUseLoc_","_TUnitUseLoc
	..d OutputRowGetFloor
	
	
	Quit $$$OK
OutputRowGetFloor
	Set Data=$lb(TRowID,TFloorNo,TFloorUseLoc,TFloorIndex,TFloorNum,TPurpose,TFloorBuildingArea,TFloorUtilizationArea,TFloorHeight,TPurposeID)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
}

ClassMethod GetFloorFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFloorExecute ]
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

ClassMethod GetFloorClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFloorExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCDT3D.Floor).GetFloorIndex()
ClassMethod GetFloorIndex(BuildingDR)
{
	if BuildingDR="" q "0"
	s floorindex=0
	s rowid=0
	f  s rowid=$o(^DHCEQBUFloor(0,"Building",BuildingDR,rowid)) quit:rowid=""  d
	.s floorindex=floorindex+1

	q floorindex
}

/// Command:w ##class(web.DHCDT3D.Floor).DeleteData("4","1")
ClassMethod DeleteData(RowID As %String = "", BuildDR As %String = "") As %String
{
	 s FloorIndex=""
	s BuildUnitFlag=##class(web.DHCDT3D.Floor).CheckBuildUnit(RowID,BuildDR)
	Set $ZT="ERRORDelete"	
	TSTART	
	if (BuildUnitFlag=1)
	{
		s FloorIndex=$p($g(^DHCEQBUFloor(RowID)),"^",2)
		&sql(Delete from sqluser.DHC_EQBUBuildingUnit where BU_FloorIndex=:FloorIndex and BU_BuildingDR=:BuildDR)
		i SQLCODE=100 s SQLCODE=0
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE_"^"_RowID
		} 
	}
	
	
	&sql(Delete from sqluser.DHC_EQBUFloor where F_RowID=:RowID)
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE_"^"_RowID
	}
			
	
	
	TCOMMIT
	q SQLCODE
ERRORDelete 
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	TROLLBACK		         //回滚事务
 	Quit "ERRORDelete"_ErrorMsg     //返回错误消息 ;
}

ClassMethod CheckBuildUnit(RowID As %String = "", BuildDR As %String = "") As %String
{
	s BuildUnitFlag=0
	if (RowID="")||(BuildDR="") q BuildUnitFlag
	s FloorIndex=$p($g(^DHCEQBUFloor(RowID)),"^",2)
	if (FloorIndex="") q BuildUnitFlag
	if ($d(^DHCEQBUBuildingUnit(0,"BuildingFloor",BuildDR,FloorIndex)))
	{
		s BuildUnitFlag=1
	}
	
	
	q BuildUnitFlag
}

/// 描述:   获取楼层数据  Modefied by zc0132 2023-3-28
/// 	入参:Building:建筑
/// 		 Floor:楼层
/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.Floor","GetFloorNew","B2","","")
/// ----------------------------------
Query GetFloorNew(FloorNo As %String = "", FBuildingDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,FBuilding:%String,FFloorNum:%String") [ SqlProc ]
{
}

ClassMethod GetFloorNewExecute(ByRef qHandle As %Binary, FloorNo As %String = "", FBuildingDR As %String = "") As %Status
{
	//new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i FBuildingDR="" Quit $$$OK
	
	s rowid=0
	f  s rowid=$o(^DHCDT3DFloor(0,"Building",FBuildingDR,rowid)) quit:rowid=""  d
	.s (TRowID,TFloorNo,TBuilding,TBuildingDR,TFloorNum)=""
	.s TRowID=rowid
	.s TBuildingDR=$p($g(^DHCDT3DFloor(rowid)),"^",1)
	.s TFloorNum=$p($g(^DHCDT3DFloor(rowid)),"^",3)
	.s TFloorNo=$p($g(^DHCDT3DFloor(rowid)),"^",4)
	.q:(FloorNo'="")&&(FloorNo'=TFloorNo)
	.s TBuilding=$Piece($Get(^DHCDT3DBuilding(TBuildingDR)),"^",2)
	.d OutputRowGetFloorNew
	
	Quit $$$OK
OutputRowGetFloorNew
	Set Data=$lb(TRowID,TFloorNo,TBuilding,TFloorNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	
	quit
}

ClassMethod GetFloorNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetFloorNewExecute ]
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

ClassMethod GetFloorNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetFloorNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

}
