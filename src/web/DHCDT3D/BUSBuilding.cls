Class web.DHCDT3D.BUSBuilding Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.BUSBuilding","GetBuildingList")
Query GetBuildingList(Desc As %String = "", EquipDR As %String = "") As %Query(ROWSPEC = "TRowID:%String:TRowID,TEquipDR:%String,TStructDR:%String,TBuildingArea:%String,TUtilizationArea:%String,TSubArea:%String,TPlace:%String,TOwnerFlag:%String,TSelfUseArea:%String,TLendingArea:%String,TRentArea:%String,TWorkArea:%String,TIdleArea:%String,TOtherArea:%String,TLendCompany:%String,TRentCompany:%String,TOwnerCertificate:%String,TCertificateNo:%String,TCertificateDate:%String,TFloorNum:%String,TUnderFloorNum:%String,TBuildName:%String,TBuildKey:%String,TUseState:%String,TFunctionCat:%String,TFunctionSub:%String,TEquipBuildingDR:%String")
{
}

/// // d ##class(%ResultSet).RunQuery("web.DHCDT3D.BUSBuilding","GetBuildingMain")
ClassMethod GetBuildingListExecute(ByRef qHandle As %Binary, Desc As %String = "", EquipDR As %String = "") As %Status
{
 	New repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	
	If EquipDR'="" Do
	.For  Set rowid=$Order(^DHCEQBUBuilding(0,"EquipDR",EquipDR,rowid)) Quit:rowid=""  Do
	..Do BuildDataGetBuildingList
	Else  Do
	.f  s rowid=$o(^DHCEQBUBuilding(rowid))  q:rowid=""  Do
	..Do BuildDataGetBuildingList
	Quit $$$OK
BuildDataGetBuildingList
    Do ResetVariablesGetBuildingList
	Set TRowID=rowid
	Set TEquipDR=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",35)
	Set TStructDR=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",1)
	Set TBuildingArea=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",2)
	Set TUtilizationArea=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",3)
	Set TSubArea=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",4)
	Set TPlace=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",5)
	Set TOwnerFlag=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",6)
	Set TSelfUseArea=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",7)
	Set TLendingArea=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",8)
	Set TRentArea=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",9)
	Set TWorkArea=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",10)
	Set TIdleArea=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",11)
	Set TOtherArea=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",12)
	Set TLendCompany=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",13)
	Set TRentCompany=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",14)
	Set TOwnerCertificate=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",15)
	Set TCertificateNo=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",16)
	Set TCertificateDate=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",17)
	i TCertificateDate'="" s TCertificateDate=##Class(web.DHCEQCommon).TransValueToPage(TCertificateDate,"date")
	Set TFloorNum=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",18)
	Set TUnderFloorNum=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",19)
	Set TBuildName=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",20)
	Set TBuildKey=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",21)
	Set TUseState=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",22)
	Set TFunctionCat=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",23)
	Set TFunctionSub=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",24)
	Set TEquipBuildingDR=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",36)
	d OutputRowGetBuildingList
 	
	Quit
OutputRowGetBuildingList
	Set Data=$ListBuild(TRowID,TEquipDR,TStructDR,TBuildingArea,TUtilizationArea,TSubArea,TPlace,TOwnerFlag,TSelfUseArea,TLendingArea,TRentArea,TWorkArea,TIdleArea,TOtherArea,TLendCompany,TRentCompany,TOwnerCertificate,TCertificateNo,TCertificateDate,TFloorNum,TUnderFloorNum,TBuildName,TBuildKey,TUseState,TFunctionCat,TFunctionSub,TEquipBuildingDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	//Set TRow=TRow+1
	Quit
ResetVariablesGetBuildingList
	Set (TRowID,TEquipDR,TStructDR,TBuildingArea,TUtilizationArea,TSubArea,TPlace,TOwnerFlag,TSelfUseArea,TLendingArea,TRentArea,TWorkArea,TIdleArea,TOtherArea,TLendCompany,TRentCompany,TOwnerCertificate,TCertificateNo,TCertificateDate,TFloorNum,TUnderFloorNum,TBuildName,TBuildKey,TUseState,TFunctionCat,TFunctionSub,TEquipBuildingDR)=""
	Quit
}

ClassMethod GetBuildingListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBuildingListExecute ]
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

ClassMethod GetBuildingListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBuildingListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCDT3D.BUSBuilding).GetOneBuilding(1)
ClassMethod GetOneBuilding(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneBuilding"
	s ObjBuilding=##Class(User.DHCEQBUBuilding).%OpenId(RowID)
	s BuildingInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjBuilding)
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,BuildingInfo)
ERRORGetOneBuilding
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

/// w ##Class(web.DHCDT3D.BUSBuilding).GetBuildingID("B2")
ClassMethod GetBuildingID(desc)
{
	new (desc)
	i desc="" q ""
	s builgingid=""
	&SQL(select B_RowID into:builgingid from sqluser.DHC_EQBUBuilding where B_BuildKey = :desc)
	s ComponentsInfo={}
	d ComponentsInfo.%Set("builgingid",builgingid)
	q ComponentsInfo.%ToJSON()
}

/// add by lmm 2020-07-07
/// desc:保存设备建筑，空间建筑表，根据楼层数生成楼层数据
/// Return：       空间建筑表ID
/// w ##Class(web.DHCDT3D.BUSBuilding).SaveData("{""BName"":""门诊楼"",""BBuildingArea"":""0.00"",""BSubArea"":""1.00"",""BPlace"":""2"",""BUtilizationArea"":""3.00"",""BSelfUseArea"":""4.00"",""BWorkArea"":""5.00"",""BOtherArea"":""6.00"",""BOwnerFlag"":true,""BOwnerCertificate"":""7"",""BCertificateNo"":""8"",""BCertificateDate"":""2021-07-06"",""BFloorNum"":""5.00"",""BUnderFloorNum"":""0"",""BEquipDR"":""1.00"",""ReadOnly"":"""",""BRowID"":""1""}")
ClassMethod SaveData(Data)
{
	k PLIST,RowID
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBUBuilding",JsonData,.PLIST)
	s RowID = JsonData.BRowID
	s BDFloorNum = JsonData.BFloorNum
	s BDUnderFloorNum = JsonData.BUnderFloorNum
	
	s SQLCODE=##Class(web.DHCDT3D.BUSBuilding).SaveEquipBuildingData( JsonData)
	i SQLCODE=100 s SQLCODE=0
	if SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}
	else
	{
	 	s PLIST(160)=$p(SQLCODE,"^",2)
	}
	
	
	
    if RowID'=""
    {
		&SQL(Update SQLUSER.DHC_EQBUBuilding Values :PLIST() where B_RowID = :RowID)
		s PreBDFloorNum=$p($g(^DHCEQBUBuilding(RowID,"OtherInfoB")),"^",18)
		s PreBDUnderFloorNum=$p($g(^DHCEQBUBuilding(RowID,"OtherInfoB")),"^",19)
		
		if (PreBDFloorNum'=BDFloorNum)||(BDUnderFloorNum'=PreBDUnderFloorNum)
		{
			&SQL(Delete SQLUSER.DHC_EQBUFloor where F_BuildingDR=:RowID)
			i SQLCODE=100 s SQLCODE=0			
			&SQL(Delete SQLUSER.DHC_EQBUBuildingUnit where BU_BuildingDR=:RowID)
			i SQLCODE=100 s SQLCODE=0			
		}
		
		
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQBUBuilding Values :PLIST())
		s RowID=$g(%ROWID)
	}
	if SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}
	for FloorIndex=1:1:BDFloorNum  d
	.k PLIST
	.i (BDUnderFloorNum<1)&&((BDUnderFloorNum+FloorIndex-1)>=0)  d
	..s CurFloorNum=BDUnderFloorNum+FloorIndex
	.e  d
	..s CurFloorNum=BDUnderFloorNum+FloorIndex-1
	.s PLIST(2)=RowID
	.s PLIST(3)=FloorIndex
	.s PLIST(4)=CurFloorNum
	.&SQL(Insert Into SQLUSER.DHC_EQBUFloor Values :PLIST())
	if SQLCODE
	{
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,"-9012")
	}
	
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
}

ClassMethod SaveEquipBuildingData(JsonData)
{
	k PLIST
	s EquipBuildingDR=""
 	s PLIST(2)=JsonData.BEquipDR
 	s PLIST(3)=JsonData.BStructDR
 	s PLIST(4)=JsonData.BBuildingArea
 	s PLIST(5)=JsonData.BUtilizationArea
 	s PLIST(6)=JsonData.BSubArea
 	s PLIST(7)=JsonData.BPlace
 	s PLIST(8)=$case(JsonData.BOwnerFlag,"true":"1","false":"0",:"")
 	s PLIST(9)=JsonData.BSelfUseArea
 	s PLIST(10)=JsonData.BLendingArea
 	s PLIST(11)=JsonData.BRentArea
 	s PLIST(12)=JsonData.BWorkArea
 	s PLIST(13)=JsonData.BIdleArea
 	s PLIST(14)=JsonData.BOtherArea
 	s PLIST(15)=JsonData.BLendCompany
 	s PLIST(16)=JsonData.BRentCompany
 	s PLIST(17)=##Class(web.DHCEQCommon).TransValueFromPage(JsonData.BOwnerCertificate,"date")
 	s PLIST(18)=JsonData.BCertificateNo
 	s PLIST(19)=##Class(web.DHCEQCommon).TransValueFromPage(JsonData.BCertificateDate,"date")
 	s PLIST(20)=JsonData.BFloorNum
 	s PLIST(21)=JsonData.BUnderFloorNum
 	s PLIST(22)=JsonData.BBuildName
 	s PLIST(23)=JsonData.BBuildKey
 	s PLIST(24)=JsonData.BUseState
 	s PLIST(25)=JsonData.BFunctionCat
 	s PLIST(26)=JsonData.BFunctionSub
 	s PLIST(29)=JsonData.BOwnerKind
 	s PLIST(30)=JsonData.BOwnershipYear
 	s PLIST(31)=JsonData.BOwner
 	s PLIST(32)=##Class(web.DHCEQCommon).TransValueFromPage(JsonData.BCompletionDate,"date")
 	s PLIST(33)=JsonData.BSelfUseFee
 	s PLIST(34)=JsonData.BLendingFee
 	s PLIST(35)=JsonData.BRentFee
 	s PLIST(36)=JsonData.BWorkFee
 	s PLIST(37)=JsonData.BIdleFee
 	s PLIST(38)=JsonData.BOtherFee
	
	
	
	&SQL(select BD_RowID into:EquipBuildingDR from sqluser.DHC_EQBuilding where BD_EquipDR = :JsonData.BEquipDR)
	if (EquipBuildingDR'="")
	{
		&SQL(Update SQLUSER.DHC_EQBuilding Values :PLIST() where BD_RowID = :EquipBuildingDR)
	}
	else
	{
		&SQL(insert into SQLUSER.DHC_EQBuilding Values :PLIST())
		s EquipBuildingDR=$g(%ROWID)
	}
	q SQLCODE_"^"_EquipBuildingDR
}

/// add by lmm 2021-07-08
/// desc:用于空间建筑放大镜数据
/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.BUSBuilding","GetShortBuilding")
Query GetShortBuilding(Desc As %String = "", EquipDR As %String = "") As %Query(ROWSPEC = "Hidden:%String,TBuildName:%String:名称,Hidden:%String,TBuildingArea:%String:建筑面积,TPlace:%String:地址,Hidden:%String,TFloorNum:%String:楼层数,TUnderFloorNum:%String:地下楼层数")
{
}

/// // d ##class(%ResultSet).RunQuery("web.DHCDT3D.BUSBuilding","GetBuildingMain")
ClassMethod GetShortBuildingExecute(ByRef qHandle As %Binary, Desc As %String = "", EquipDR As %String = "") As %Status
{
 	New repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	
	If EquipDR'="" Do
	.For  Set rowid=$Order(^DHCEQBUBuilding(0,"EquipDR",EquipDR,rowid)) Quit:rowid=""  Do
	..Do BuildDataGetShortBuilding
	Else  Do
	.f  s rowid=$o(^DHCEQBUBuilding(rowid))  q:rowid=""  Do
	..Do BuildDataGetShortBuilding
	Quit $$$OK
BuildDataGetShortBuilding
    Do ResetVariablesGetShortBuilding
	Set TRowID=rowid
	Set TEquipDR=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",35)
	Set TBuildingArea=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",2)
	Set TPlace=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",5)
	Set TOwnerFlag=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",6)
	Set TFloorNum=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",18)
	Set TUnderFloorNum=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",19)
	Set TBuildName=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",20)
	Set TBuildKey=$Piece($Get(^DHCEQBUBuilding(rowid,"OtherInfoB")),"^",21)
	d OutputRowGetShortBuilding
 	
	Quit
OutputRowGetShortBuilding
	Set Data=$ListBuild(TRowID,TBuildName,TBuildKey,TBuildingArea,TPlace,TOwnerFlag,TFloorNum,TUnderFloorNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	//Set TRow=TRow+1
	Quit
ResetVariablesGetShortBuilding
	Set (TRowID,TEquipDR,TStructDR,TBuildingArea,TUtilizationArea,TSubArea,TPlace,TOwnerFlag,TSelfUseArea,TLendingArea,TRentArea,TWorkArea,TIdleArea,TOtherArea,TLendCompany,TRentCompany,TOwnerCertificate,TCertificateNo,TCertificateDate,TFloorNum,TUnderFloorNum,TBuildName,TBuildKey,TUseState,TFunctionCat,TFunctionSub)=""
	Quit
}

ClassMethod GetShortBuildingFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortBuildingExecute ]
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

ClassMethod GetShortBuildingClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortBuildingExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// desc:用于空间建筑放大镜数据  Modefied by zc0132 2023-3-28 
/// 入参：Desc：建筑名称 EquipDR：设备id
/// d ##class(%ResultSet).RunQuery("web.DHCDT3D.BUSBuilding","GetShortBuildingNew","")
Query GetShortBuildingNew(Desc As %String = "") As %Query(ROWSPEC = "TRowID:%String,TName:%String,TBuildKey:%String,TBuildingArea:%String,TPlace:%String,TOwnerFlag:%String,TFloorNum:%String,TUnderFloorNum:%String")
{
}

/// // d ##class(%ResultSet).RunQuery("web.DHCDT3D.BUSBuilding","GetBuildingMain")
ClassMethod GetShortBuildingNewExecute(ByRef qHandle As %Binary, Desc As %String = "") As %Status
{
 	New repid, index,rowid,CurRole
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	Set index=1
	Set rowid=0
	f  s rowid=$o(^DHCDT3DBuilding(rowid))  q:rowid=""  Do
	.Do BuildDataGetShortBuildingNew
	Quit $$$OK
BuildDataGetShortBuildingNew
    Do ResetVariablesGetShortBuildingNew
    q:$Piece($Get(^DHCDT3DBuilding(rowid)),"^",19)'="Y"
    q:(Desc'="")&&($Piece($Get(^DHCDT3DBuilding(rowid)),"^",2)'=Desc)
	Set TRowID=rowid
	Set TBuildName=$Piece($Get(^DHCDT3DBuilding(rowid)),"^",2)
	Set TBuildKey=$Piece($Get(^DHCDT3DBuilding(rowid)),"^",4)
	Set TBuildingArea=$Piece($Get(^DHCDT3DBuilding(rowid)),"^",6)
	Set TPlace=$Piece($Get(^DHCDT3DBuilding(rowid)),"^",9)
	s TFloorNum=$Piece($Get(^DHCDT3DBuilding(rowid)),"^",13)
	s TUnderFloorNum=$Piece($Get(^DHCDT3DBuilding(rowid)),"^",14)
	d OutputRowGetShortBuildingNew
 	
	Quit
OutputRowGetShortBuildingNew
	Set Data=$ListBuild(TRowID,TBuildName,TBuildKey,TBuildingArea,TPlace,TOwnerFlag,TFloorNum,TUnderFloorNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	//Set TRow=TRow+1
	Quit
ResetVariablesGetShortBuildingNew
	Set (TRowID,TEquipDR,TStructDR,TBuildingArea,TUtilizationArea,TSubArea,TPlace,TOwnerFlag,TSelfUseArea,TLendingArea,TRentArea,TWorkArea,TIdleArea,TOtherArea,TLendCompany,TRentCompany,TOwnerCertificate,TCertificateNo,TCertificateDate,TFloorNum,TUnderFloorNum,TBuildName,TBuildKey,TUseState,TFunctionCat,TFunctionSub)=""
	Quit
}

ClassMethod GetShortBuildingNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetShortBuildingNewExecute ]
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

ClassMethod GetShortBuildingNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetShortBuildingNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
