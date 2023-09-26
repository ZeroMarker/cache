/// 名称: web.DHCEQ.EM.BUSCostAllot
/// 描述: 折旧分摊类方法
/// 编写者：ZY
/// 编写日期: 2022-4-15
/// 产品组：设备管理
Class web.DHCEQ.EM.BUSCostAllot Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.EM.BUSCostAllot","CostAllot","15")
Query CostAllot(CARowID As %String = "") As %Query(ROWSPEC = "CARowID:%String,CATypes:%String,CAHold2:%String,CAAllotType:%String,CAAllotTypeDesc:%String,CALRowID:%String,CALAllotLocDR:%String,CALAllotLoc:%String,CALAllotPercentNum:%String,CALRemark:%String,CALWorkLoadNum:%String,CALHold1:%String,CALHold2:%String,CALHold3:%String,CALHold4:%String,CALHold5:%String")
{
}

ClassMethod CostAllotExecute(ByRef qHandle As %Binary, CARowID As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i CARowID=""
	{
		s (CARowID,CATypes,CAHold2,CAAllotType,CAAllotTypeDesc)=""
		d ResetVariablesGetCostAllot
		d OutputRowGetCostAllot
	}
	else
	{
		s CATypes=$p($g(^DHCEQCostAllot(CARowID)),"^",3)
		s CAHold2=$p($g(^DHCEQCostAllot(CARowID)),"^",17)
		s CAAllotType=$p($g(^DHCEQCostAllot(CARowID)),"^",14)
		s CAAllotTypeDesc=##Class(web.DHCEQFind).GetDisplayAllotType(CAAllotType)
		s ListID=0
		f  s ListID=$o(^DHCEQCostAllotList(0,"CostAllotDR",CARowID,ListID))  quit:ListID=""  d
		.d ResetVariablesGetCostAllot
		.s DataList=$g(^DHCEQCostAllotList(ListID))
		.s CALRowID = ListID	//rowid
		.s CALAllotLocDR=$p(DataList,"^",2)
		.s CALAllotLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",CALAllotLocDR)
		.s CALAllotPercentNum=##class(web.DHCEQCommon).FormatNumber($p(DataList,"^",3),"",2)	/// modified by ZY0303 20220615
		.s CALRemark=$p(DataList,"^",4)
		.s CALWorkLoadNum=##class(web.DHCEQCommon).FormatNumber($p(DataList,"^",5),"",2)	/// modified by ZY0303 20220615
		.s CALHold1=$p(DataList,"^",6)
		.s CALHold2=$p(DataList,"^",7)
		.s CALHold3=$p(DataList,"^",8)
		.s CALHold4=$p(DataList,"^",9)
		.s CALHold5=$p(DataList,"^",10)
		.d OutputRowGetCostAllot
	}
	Quit $$$OK
OutputRowGetCostAllot
	s Data=$lb(CARowID,CATypes,CAHold2,CAAllotType,CAAllotTypeDesc,CALRowID,CALAllotLocDR,CALAllotLoc,CALAllotPercentNum,CALRemark,CALWorkLoadNum,CALHold1,CALHold2,CALHold3,CALHold4,CALHold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetCostAllot
	s (DataList,CALRowID,CALAllotLocDR,CALAllotLoc,CALAllotPercentNum,CALRemark,CALWorkLoadNum,CALHold1,CALHold2,CALHold3,CALHold4,CALHold5)=""
	quit
}

ClassMethod CostAllotFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CostAllotExecute ]
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

ClassMethod CostAllotClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CostAllotExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// w ##Class(web.DHCEQ.EM.BUSCostAllot).SaveData("","",0)
ClassMethod SaveData(data, datalist, DelIs)
{
	new CARowID,User,Date,Time,JsonData,SQLCODE
	s SQLCODE=0
	k PLIST,CARowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=$H
 	s Time=$Piece($H,",",2)
	
	s $ZT="ERRORCostAllot"
	TSTART
	
	if DelIs=1
	{
		s CARowID=data
		&SQL(Update SQLUSER.DHC_EQCostAllot set CA_InvalidFlag='Y' where CA_RowID = :CARowID)
		s CARowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCostAllot",JsonData,.PLIST)
		s CARowID = JsonData.CARowID
		s CATypes = JsonData.CATypes
		s CAHold2 = JsonData.CAHold2
		i CATypes=1 s PLIST(2) = CAHold2
		
		s PLIST(6) = "N"
		s PLIST(7) = 1
		i CARowID=""
		{
		 	s PLIST(8) = User	;UserDR
		 	s PLIST(9) = +Date	;Date
			s PLIST(10) = Time	;Time
			&SQL(insert into SQLUSER.DHC_EQCostAllot Values :PLIST())
			s CARowID=$g(%ROWID)
		}
		else
		{
		 	s PLIST(11) = User	;UserDR
		 	s PLIST(12) = +Date	;Date
			s PLIST(13) = Time	;Time
			&SQL(update SQLUSER.DHC_EQCostAllot Values :PLIST() where CA_RowID = :CARowID)
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s SQLCODE=##Class(web.DHCEQ.EM.BUSCostAllot).SaveDataList(CARowID,datalist)
		
		s CAAllotType=$p($g(^DHCEQCostAllot(CARowID)),"^",2)
		s CATypes=$p($g(^DHCEQCostAllot(CARowID)),"^",3)
		s CAHold1=$p($g(^DHCEQCostAllot(CARowID)),"^",16)	//总值
		s CAHold2=$p($g(^DHCEQCostAllot(CARowID)),"^",17)
		
		//累加明细表总值
		s tmpWorkLoadNum=""
		&SQL(select sum(CAL_WorkLoadNum) into :tmpWorkLoadNum from SQLUSER.DHC_EQCostAllotList where CAL_CostAllotDR = :CARowID)
		i tmpWorkLoadNum>CAHold1
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","分摊值大于总金额!")
		}
		i tmpWorkLoadNum<CAHold1
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","分摊值小于总金额!")
		}
		//固定比例分摊总占比小于等于100
		if CAAllotType=0
		{
			s tmpPercent=""
			&SQL(select sum(CAL_AllotPercentNum) into :tmpPercent from SQLUSER.DHC_EQCostAllotList where CAL_CostAllotDR = :CARowID)
			i tmpPercent>100
			{
				TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","分摊占比总和大于100%")
			}
			elseif tmpPercent=100
			{
				i tmpWorkLoadNum'=CAHold1
				{
					TROLLBACK
					q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","分摊占比总和是100%,分摊值总和与总费用不一致!")
				}
			}
			elseif tmpPercent<100
			{
				TROLLBACK
				q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","分摊占比总和应等于100%")
			}
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,CARowID)
ERRORCostAllot
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// w ##Class(web.DHCEQ.EM.BUSCostAllot).SaveDataList(1,"")
ClassMethod SaveDataList(CARowID, dataList)
{
	new SQLCODE,CALRowIDs,SplitRowCode,Length,valList,CALRowID
	s SQLCODE=0
	s CALRowIDs=""
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$L(dataList,SplitRowCode)
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=	$p(dataList,SplitRowCode,i)
		q:valList=""
		k PLIST,CALRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		
		s CALRowID =JsonData.CALRowID
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQCostAllotList",JsonData,.PLIST)
		s PLIST(2)=CARowID
		
	    if CALRowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQCostAllotList Values :PLIST() where CAL_RowID = :CALRowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQCostAllotList Values :PLIST())
			s CALRowID=$g(%ROWID)
		}
		q:SQLCODE'=0
		if CALRowIDs=""
		{
			s CALRowIDs=CALRowID
		}
		else
		{
			s CALRowIDs=CALRowIDs_","_CALRowID
		}
	}
	i SQLCODE'=0 q SQLCODE
	s CALRowID=0
	f  s CALRowID=$o(^DHCEQCostAllotList(0,"CostAllotDR",CARowID,CALRowID))  quit:(CALRowID="")||(SQLCODE'=0)  d
	.i (","_CALRowIDs_",")'[(","_CALRowID_",")  d
	..&SQL(delete from SQLUSER.DHC_EQCostAllotList where CAL_RowID = :CALRowID)
	..i SQLCODE=100 s SQLCODE=0
	
	q SQLCODE
}

/// w ##Class(web.DHCEQ.EM.BUSCostAllot).CreateCostAllot(3,8)
ClassMethod CreateCostAllot(CATypes, BussID)
{
	new SQLCODE,User,Date,Time,SMLRowID,Findflag
	s SQLCODE=0
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
 	s Time=$Piece($H,",",2)
	if CATypes=3
	{
		s SMLRowID=0
		f  s SMLRowID=$o(^DHCEQStoreMoveList(0,"StoreMove",BussID,SMLRowID))  quit:(SMLRowID="")||(SQLCODE'=0)  d
		.q:'$Data(^DHCEQCostAllot(0,"SourceType",CATypes,SMLRowID))
		.s Findflag=""
		.s CARowID=0
		.f  s CARowID=$o(^DHCEQCostAllot(0,"SourceType",CATypes,SMLRowID,CARowID))  q:(CARowID="")||(Findflag'="")  d
		..s DataList=$g(^DHCEQCostAllot(CARowID))
		..q:$p(DataList,"^",5)="Y"
		..s Findflag=CARowID
		.q:Findflag=""
		.
		.s DataList=$g(^DHCEQCostAllot(Findflag))
		.s CAPLIST(3)=$p(DataList,"^",2)
		.s CAPLIST(4)=1
		.s CAPLIST(5)=$p(DataList,"^",4)
		.s CAPLIST(6)=$p(DataList,"^",5)
		.s CAPLIST(7)=$p(DataList,"^",6)
		.s CAPLIST(8)=User
		.s CAPLIST(9)=Date
		.s CAPLIST(10)=Time
		.
		.s BatchFlag=$P(^DHCEQStoreMoveList(SMLRowID),"^",3)
		.i BatchFlag="Y" d
		..s RowIDs=$G(^DHCEQStoreMoveList(SMLRowID,"EX","RowIDs"))
		..s equipRowIDs=RowIDs
		.e  d
		..s EquipDR=$P(^DHCEQStoreMoveList(SMLRowID),"^",2)
		..s equipRowIDs=EquipDR
		.s count=$l(equipRowIDs,",")
		.
		.f k=1:1:count d
		..q:SQLCODE'=0
		..s EquipDR=$p(equipRowIDs,",",k)
		..i EquipDR'=""  d
		...s CAPLIST(2)=EquipDR
		...s CAPLIST(17)=$p($g(^DHCEQEquip(EquipDR)),"^",27)
		...s CAPLIST(18)=EquipDR
		...&SQL(Insert into sqluser.DHC_EQCostAllot values :CAPLIST())
		...q:SQLCODE'=0
		...s NewCARowID=$g(%ROWID)
		...s CALPLIST(2)=NewCARowID
		...s CostListID=0
		...f  s CostListID=$o(^DHCEQCostAllotList(0,"CostAllotDR",Findflag,CostListID)) q:(CostListID="")||(SQLCODE'=0)  d
		....s CALPLIST(3)=$p($g(^DHCEQCostAllotList(CostListID)),"^",2)
		....s CALPLIST(4)=$p($g(^DHCEQCostAllotList(CostListID)),"^",3)
		....s CALPLIST(6)=$p($g(^DHCEQCostAllotList(CostListID)),"^",5)
		....&SQL(Insert into sqluser.DHC_EQCostAllotList values :CALPLIST())
		....
	}
	q SQLCODE
}

}
