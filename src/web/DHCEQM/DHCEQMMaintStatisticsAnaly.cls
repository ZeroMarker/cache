/// Created By HZY 2013-9-23 HZY0059
Class web.DHCEQM.DHCEQMMaintStatisticsAnaly Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Created By HZY 2013-9-25
/// Desc:科室维修信息统计：统计维修次数、消耗配件金额、维修消耗的工时信息。
Query GetLocMaintInfo(LocDR As %String, StartDate As %String, EndDate As %String, QXType) As %Query(ROWSPEC = "TLoc:%String,TTimes:%String,TTotalFee:%String,TMaintHour:%String,TRow:%String")
{
}

ClassMethod GetLocMaintInfoExecute(ByRef qHandle As %Binary, LocDR As %String, StartDate As %String, EndDate As %String, QXType) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s num=0
	s TRow=1  //add by zx 2015-09-15 Bug ZX0032
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$H
	k ^TempDHCEQ("DHCEQMMaintRequest")
	Set AccessoryFee=0
	Set MaintTime=0
	
	d BuildGetLocMaintInfo
	s mlocdr=0
	f  s mlocdr=$o(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,mlocdr)) q:mlocdr=""  d
	.d ResetVariablesGetLocMaintInfo
	.s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",mlocdr)
	.s TTimes=$p(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,mlocdr),"^",1)	//次数	//Add By DJ 2015-07-14 DJ0147 begin
	.s TTotalFee=$p(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,mlocdr),"^",2)
	.s TMaintHour=$p(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,mlocdr),"^",3)		//Add By DJ 2015-07-14 DJ0147 end
	.d OutputRowGetLocMaintInfo
	
	Quit $$$OK
BuildGetLocMaintInfo
	s MLocDR=0
	f  s MLocDR=$o(^DHCEQMMaintRequest(0,"ObjLoc",MLocDR)) q:MLocDR=""  d
	.q:(LocDR'="")&&(LocDR'=MLocDR)
	.q:(##class(web.DHCEQCommon).LocIsInEQ(QXType,MLocDR))
	.s Date=0
	.f  s Date=$o(^DHCEQMMaintRequest(0,"ObjLoc",MLocDR,Date)) q:Date=""  d
	..q:(Date<StartDate)||(Date>EndDate)
	..s rowid=0
	..f  s rowid=$o(^DHCEQMMaintRequest(0,"ObjLoc",MLocDR,Date,rowid))  q:rowid=""  d
	...s MRInfo=$g(^DHCEQMMaintRequest(rowid))
	...q:($p(MRInfo,"^",41)'="2") 		//状态
	...s AccessoryFee=$p(MRInfo,"^",60) //维修费
	...s MaintHour=$p(MRInfo,"^",39) 	//维修工时
	...;i MaintHour="" s MaintHour=$p(MRInfo,"^",16)-$p(MRInfo,"^",24)		//Add By DJ 2016-12-21
	...i $d(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,MLocDR))  d
	....s $p(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,MLocDR),"^",1)=1+$p(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,MLocDR),"^",1)
	....s $p(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,MLocDR),"^",2)=AccessoryFee+$p(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,MLocDR),"^",2)
	....s $p(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,MLocDR),"^",3)=MaintHour+$p(^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,MLocDR),"^",3)
	...e  d
	....s ^TempDHCEQ("DHCEQMMaintRequest",+$H,$J,MLocDR)=1_"^"_AccessoryFee_"^"_MaintHour
	quit

OutputRowGetLocMaintInfo
	Set Data=$lb(TLoc,TTimes,TTotalFee,TMaintHour,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s num=num+1
	s TRow=TRow+1
	set ^TempDHCEQ("DHCEQMMaintRequest","Export",+$H,User,num)=TLoc_"^"_TTimes_"^"_TTotalFee_"^"_TMaintHour
	
	quit
ResetVariablesGetLocMaintInfo
	s (TLoc,TTimes,TTotalFee,TMaintHour)=""
	quit
}

ClassMethod GetLocMaintInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetLocMaintInfoExecute ]
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

ClassMethod GetLocMaintInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetLocMaintInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetLocMaintInfoExport(num)
{
	i num<0 q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))	
	i num=0 q $o(^TempDHCEQ("DHCEQMMaintRequest","Export",+$H,User,""),-1)
	q $g(^TempDHCEQ("DHCEQMMaintRequest","Export",+$H,User,num))
}

/// Created By HZY 
/// Desc:外包单位维修统计：统计维修次数、消耗配件金额、维修消耗的工时信息。
Query GetServiceMaintInfo(ServiceDR As %String, StartDate As %String, EndDate As %String, QXType) As %Query(ROWSPEC = "TService:%String,TTimes:%String,TTotalFee:%String,TMaintHour:%String,TRow:%String")
{
}

ClassMethod GetServiceMaintInfoExecute(ByRef qHandle As %Binary, ServiceDR As %String, StartDate As %String, EndDate As %String, QXType) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s index=1
	s num=0
	s TRow=1 //add by zx 2015-09-15 Bug ZX0032
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$H
	k ^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo")
	Set AccessoryFee=0
	Set MaintTime=0
	
	d BuildGetServiceMaintInfo
	s mServiceDR=0
	f  s mServiceDR=$o(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR)) q:mServiceDR=""  d
	.d ResetVariablesGetServiceMaintInfo
	.s TService=##class(web.DHCEQCommon).GetTrakNameByID("cservice",mServiceDR) //CZF0093	//modified by czf  需求号：354934
	.s TTimes=$p(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR),"^",1)
	.s TTotalFee=$p(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR),"^",2)
	.s TMaintHour=$p(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR),"^",3)
	.d OutputRowGetServiceMaintInfo
	
	Quit $$$OK
BuildGetServiceMaintInfo
	s mServiceDR=0
	f  s mServiceDR=$o(^DHCEQMMaintRequest(0,"Service",mServiceDR)) q:mServiceDR=""  d
	.q:(ServiceDR'="")&&(ServiceDR'=mServiceDR)
	.s Date=0
	.f  s Date=$o(^DHCEQMMaintRequest(0,"Service",mServiceDR,Date)) q:Date=""  d
	..q:(Date<StartDate)||(Date>EndDate)
	..s rowid=0
	..f  s rowid=$o(^DHCEQMMaintRequest(0,"Service",mServiceDR,Date,rowid))  q:rowid=""  d
	...s MRInfo=$g(^DHCEQMMaintRequest(rowid))
	...q:($p(MRInfo,"^",41)'="2") 		//状态
	...s MLocDR=$p(MRInfo,"^",6)
	...q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,MLocDR)))
	...s AccessoryFee=$p(MRInfo,"^",60)
	...s MaintHour=$p(MRInfo,"^",39)
	...i MaintHour="" s MaintHour=$Piece(MRInfo,"^",16)-$Piece(MRInfo,"^",24) //modified by czf 576201
	...i $d(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR))  d
	....s $p(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR),"^",1)=1+$p(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR),"^",1)
	....s $p(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR),"^",2)=AccessoryFee+$p(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR),"^",2)
	....s $p(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR),"^",3)=MaintHour+$p(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR),"^",3)
	...e  d
	....s ^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo",+$H,$J,mServiceDR)=1_"^"_AccessoryFee_"^"_MaintHour
	quit

OutputRowGetServiceMaintInfo
	Set Data=$lb(TService,TTimes,TTotalFee,TMaintHour,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s num=num+1
	s TRow=TRow+1
	s ^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo","Export",+$H,User,num)=TService_"^"_TTimes_"^"_TTotalFee_"^"_TMaintHour
	quit
ResetVariablesGetServiceMaintInfo
	s (TService,TTimes,TTotalFee,TMaintHour)=""
	quit
}

ClassMethod GetServiceMaintInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetServiceMaintInfoExecute ]
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

ClassMethod GetServiceMaintInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetServiceMaintInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetServiceMaintInfoExport(num)
{
	i num<0 q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i num=0 q $o(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo","Export",+$H,User,""),-1)
	q $g(^TempDHCEQ("DHCEQMMaintRequest","GetServiceMaintInfo","Export",+$H,User,num))
}

/// Created By HZY 
/// 消耗材料统计：统计各材料的消耗情况，根据统计，可以连接查看该材料该时间段的消耗明细。
/// DHC_EQMMaintPart
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintStatisticsAnaly","GetMaintPartInfo","","","","0","")
Query GetMaintPartInfo(AccessoryDR As %String, StartDate As %String, EndDate As %String, QXType, DetailFlag) As %Query(ROWSPEC = "TAccessoryDR:%String,TAccessory:%String,TQuantity:%String,TPrice:%String,TTotalFee:%String,TRow:%String")
{
}

ClassMethod GetMaintPartInfoExecute(ByRef qHandle As %Binary, AccessoryDR As %String, StartDate As %String, EndDate As %String, QXType, DetailFlag) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s num=0
	s TRow=1 //add by zx 2015-09-15 Bug ZX0032
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$H
	k ^TempDHCEQ("DHCEQMMaintPart","GetMaintPart")
	Set AccessoryFee=0
	Set MaintTime=0
	
	d BuildGetMaintPart
	i 1'=DetailFlag 
	{
		s mAccessoryDR=0
		f  s mAccessoryDR=$o(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart",+$H,$J,mAccessoryDR)) q:mAccessoryDR=""  d
		.d ResetVariablesGetMaintPart
		.s TAccessoryDR=mAccessoryDR
		.s TAccessory=$p($g(^DHCEQCCode("DHCEQCAccessory",mAccessoryDR)),"^",2)
		.s TQuantity=$p(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart",+$H,$J,mAccessoryDR),"^",1)
		.s TPrice=$p(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart",+$H,$J,mAccessoryDR),"^",2)
		.s TTotalFee=$p(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart",+$H,$J,mAccessoryDR),"^",3)
		.d OutputRowGetMaintPart
	}
	Quit $$$OK
BuildGetMaintPart
	//^DHCEQMMaintPart(0,"Accessory",MTP_AccessoryDR,MTP_StoreRoomDR,MTP_ProviderDR,MTP_RowID)
	s mAccessoryDR=0
	f  s mAccessoryDR=$o(^DHCEQMMaintPart(0,"Accessory",mAccessoryDR)) q:mAccessoryDR=""  d
	.q:(AccessoryDR'="")&&(AccessoryDR'=mAccessoryDR)
	.s mStoreRoomDR=0
	.f  s mStoreRoomDR=$o(^DHCEQMMaintPart(0,"Accessory",mAccessoryDR,mStoreRoomDR)) q:mStoreRoomDR=""  d
	..s mProviderDR=0
	..f  s mProviderDR=$o(^DHCEQMMaintPart(0,"Accessory",mAccessoryDR,mStoreRoomDR,mProviderDR)) q:mProviderDR=""  d
	...s rowid=0
	...f  s rowid=$o(^DHCEQMMaintPart(0,"Accessory",mAccessoryDR,mStoreRoomDR,mProviderDR,rowid)) q:rowid=""  d
	....s MPInfo=$g(^DHCEQMMaintPart(rowid))
	....s MaintRequestDR=$p(MPInfo,"^",9)
	....s MRInfo=$g(^DHCEQMMaintRequest(MaintRequestDR))
	....q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,$p(MRInfo,"^",6))))
	....q:($p(MRInfo,"^",41)'="2") 		//状态
	....s MRDate=$p(MRInfo,"^",18)
	....q:(MRDate<StartDate)||(MRDate>EndDate)
	....s MPAccessoryDR=$p(MPInfo,"^",2)
	....s MPQuantity=$p(MPInfo,"^",3)
	....s MPPrice=$p(MPInfo,"^",4)
	....s MPTotalFee=$p(MPInfo,"^",5)
	....i 1'=DetailFlag  d   //不是输出明细 则汇总信息
	.....i $d(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart",+$H,$J,mAccessoryDR))  d
	......s $p(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart",+$H,$J,mAccessoryDR),"^",1)=MPQuantity+$p(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart",+$H,$J,mAccessoryDR),"^",1)
	......s $p(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart",+$H,$J,mAccessoryDR),"^",3)=MPTotalFee+$p(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart",+$H,$J,mAccessoryDR),"^",3)
	.....e  d
	......s ^TempDHCEQ("DHCEQMMaintPart","GetMaintPart",+$H,$J,mAccessoryDR)=MPQuantity_"^"_MPPrice_"^"_MPTotalFee
	....e  d  //输出明细信息
	.....s TAccessoryDR=mAccessoryDR
	.....s TAccessory=$p($g(^DHCEQCCode("DHCEQCAccessory",mAccessoryDR)),"^",2)
	.....s TQuantity=MPQuantity
	.....s TPrice=MPPrice
	.....s TTotalFee=MPTotalFee
	.....d OutputRowGetMaintPart
	quit

OutputRowGetMaintPart
	Set Data=$lb(TAccessoryDR,TAccessory,TQuantity,TPrice,TTotalFee,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s num=num+1
	s TRow=TRow+1
	s ^TempDHCEQ("DHCEQMMaintPart","GetMaintPart","Export",+$H,User,num)=TAccessory_"^"_TQuantity_"^"_TPrice_"^"_TTotalFee
	quit
ResetVariablesGetMaintPart
	s (TAccessoryDR,TAccessory,TQuantity,TPrice,TTotalFee)=""
	quit
}

ClassMethod GetMaintPartInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintPartInfoExecute ]
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

ClassMethod GetMaintPartInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintPartInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMaintPartInfoExport(num)
{
	i num<0 q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i num=0 q $o(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart","Export",+$H,User,""),-1)
	q $g(^TempDHCEQ("DHCEQMMaintPart","GetMaintPart","Export",+$H,User,num))
}

/// Created By HZY 
/// 工程师维修工作统计：工程师,统计维修次数、消耗配件金额、维修消耗的工时信息以及维修质量、服务态度、服务及时性平均评分。
/// DHC_EQMMaintRequest
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintStatisticsAnaly","GetMaintEngineerInfo","","","","")
Query GetMaintEngineerInfo(EngineerDR As %String, StartDate As %String, EndDate As %String, QXType) As %Query(ROWSPEC = "TEngineerDR:%String,TEngineer:%String,TTimes:%String,TAccessoryFee:%String,THours:%String,TMaintQualityScore:%String,TAttitudeScore:%String,TTimeLinessScore:%String,TRow:%String")
{
}

ClassMethod GetMaintEngineerInfoExecute(ByRef qHandle As %Binary, EngineerDR As %String, StartDate As %String, EndDate As %String, QXType) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s num=0
	s TRow=1 //add by zx 2015-09-15 Bug ZX0032
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$H
	k ^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer")
	s mEngineerDR=0
	
	d BuildGetMaintEngineer
	
	s mEngineerDR=0
	f  s mEngineerDR=$o(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR)) q:mEngineerDR=""  d
	.d ResetVariablesGetMaintEngineer
	.s TEngineerDR=mEngineerDR
	.s TEngineer=##Class(web.DHCEQCommon).GetTrakNameByID("user",mEngineerDR)	//指派工程师
	.s Value=$g(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR))
	.s TTimes=$p(Value,"^",1)
	.s TAccessoryFee=$p(Value,"^",2)
	.s THours=$p(Value,"^",3)
	.s TMaintQualityScore=##Class(web.DHCEQCommon).FormatNumber($p(Value,"^",4)/TTimes,"")
	.s TAttitudeScore=##Class(web.DHCEQCommon).FormatNumber($p(Value,"^",5)/TTimes,"")
	.s TTimeLinessScore=##Class(web.DHCEQCommon).FormatNumber($p(Value,"^",6)/TTimes,"")
	.d OutputRowGetMaintEngineer
	
	Quit $$$OK
BuildGetMaintEngineer
	//^DHCEQMMaintRequest()
	//MR_AssignDR
	s rowid=0
	f  s rowid=$o(^DHCEQMMaintRequest(rowid)) q:rowid=""  d
	.s data=$g(^DHCEQMMaintRequest(rowid))
	.s TStatus=$p(data,"^",41)		//状态
	.q:TStatus'=2			//Add By DJ 2016-12-21
	.s TInvalidFlag=$p(data,"^",57)	//无效标志
	.q:(TStatus="3")||(TInvalidFlag="Y")
	.s TEngineerDR=$p(data,"^",26)	//指派工程师
	.q:TEngineerDR=""   //add by zx 2015-09-14 Bug ZX000032
	.q:(EngineerDR'="")&&(EngineerDR'=TEngineerDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,$p(data,"^",6))))
	.s MRDate=$p(data,"^",18)
	.q:(MRDate<StartDate)||(MRDate>EndDate)
	.s mEngineerDR=TEngineerDR
	.s TEngineer=##Class(web.DHCEQCommon).GetTrakNameByID("user",TEngineerDR)	//指派工程师
	.s TTimes=1	//维修次数 s val=rs.GetDataByName("")
	.s TAccessoryFee=..GetMaintAccessoryFee(rowid)	//消耗配件金额
	.s THours=$p(data,"^",39)	//维修消耗的工时
	.;i THours="" s THours=$p(data,"^",16)-$p(data,"^",24)		//Add By DJ 2016-12-21
	.s TMaintQualityScore=..GetMaintEvaluateScore(rowid,"1")	//维修质量评分
	.s TAttitudeScore =..GetMaintEvaluateScore(rowid,"2")	//服务态度评分、
	.s TTimeLinessScore =..GetMaintEvaluateScore(rowid,"3")	//服务及时性评分
	.i $d(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR))  d
	..s $p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",1)=TTimes+$p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",1)
	..s $p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",2)=TAccessoryFee+$p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",2)
	..s $p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",3)=THours+$p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",3)
	..s $p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",4)=TMaintQualityScore+$p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",4)
	..s $p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",5)=TAttitudeScore+$p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",5)
	..s $p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",6)=TTimeLinessScore+$p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR),"^",6)
	.e  d
	..s ^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer",+$H,User,mEngineerDR)=TTimes_"^"_TAccessoryFee_"^"_THours_"^"_TMaintQualityScore_"^"_TAttitudeScore_"^"_TTimeLinessScore
	quit
	
OutputRowGetMaintEngineer
	Set Data=$lb(TEngineerDR,TEngineer,TTimes,TAccessoryFee,THours,TMaintQualityScore,TAttitudeScore,TTimeLinessScore,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s num=num+1
	s TRow=TRow+1
	s ^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer","Export",+$H,User,num)=TEngineer_"^"_TTimes_"^"_TAccessoryFee_"^"_THours_"^"_TMaintQualityScore_"^"_TAttitudeScore_"^"_TTimeLinessScore
	quit
	
ResetVariablesGetMaintEngineer
	s (TStatus,TInvalidFlag,TEngineerDR,TEngineer)=""
	s (TTimes,TAccessoryFee,THours,TMaintQualityScore,TAttitudeScore,TTimeLinessScore)=0
	quit
}

ClassMethod GetMaintEngineerInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintEngineerInfoExecute ]
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

ClassMethod GetMaintEngineerInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintEngineerInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMaintEngineerInfoExport(num)
{
	i num<0 q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i num=0 q $o(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer","Export",+$H,User,""),-1)
	q $g(^TempDHCEQ("DHCEQMMaintRequest","GetMaintEngineer","Export",+$H,User,num))
}

/// 消耗配件金额
/// DHC_EQMMaintPart
ClassMethod GetMaintAccessoryFee(maintRequestDR)
{
	//DHC_EQMMaintPart
	s MaintTotalFee=0
	i maintRequestDR>0
	{
		//MTP_MaintRequestDR
		s MPRowID=0
		f  s MPRowID=$o(^DHCEQMMaintPart(0,"MaintRequest",maintRequestDR,MPRowID)) q:MPRowID=""  d
		.s MaintTotalFee=MaintTotalFee+$p($g(^DHCEQMMaintPart(MPRowID)),"^",5)
	}
	q MaintTotalFee
}

/// 根据'评价类型'获取'维护服务评价'的得分.
/// DHC_EQEvaluate
/// Modify BY:GBX 2015-03-17 15:30:15  修改了表结构
/// DHC_EQMEvaluate->DHC_EQEvaluate ^DHCEQMEvaluate->^DHCEQEvaluate
ClassMethod GetMaintEvaluateScore(maintRequestDR, evaluateTypeDR)
{
	s MaintEvaluateScore=0
	i ((maintRequestDR<1)||(evaluateTypeDR<1))
	{
		q 0
	}
	else{
		s ERowID=0
		f  s ERowID=$o(^DHCEQEvaluate(0,"SourceType","1",maintRequestDR,evaluateTypeDR,ERowID)) q:ERowID=""  d
		.s MaintEvaluateScore=$p($g(^DHCEQEvaluate(ERowID)),"^",4)
		
		q MaintEvaluateScore
	}
}

/// 维修对象维修统计：统计某维修对象 的维修次数、消耗配件金额、维修消耗的工时信息。
/// DHC_EQMExObj
Query GetMaintObjectInfo(ObjectDR As %String, StartDate As %String, EndDate As %String, QXType) As %Query(ROWSPEC = "TObjectDR:%String,TObject:%String,TTimes:%String,TAccessoryFee:%String,THours:%String,TRow:%String")
{
}

ClassMethod GetMaintObjectInfoExecute(ByRef qHandle As %Binary, ObjectDR As %String, StartDate As %String, EndDate As %String, QXType) As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s num=0
	s TRow=1 //add by zx 2015-09-15 Bug ZX0032
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i StartDate="" s StartDate=0
	i EndDate="" s EndDate=+$H
	k ^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject")
	
	d BuildGetMaintObject
	
	s ExObjDR=0
	f  s ExObjDR=$o(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject",+$H,User,ExObjDR)) q:ExObjDR=""  d
	.d ResetVariablesGetMaintObject
	.s TObjectDR=ExObjDR
	.s TObject=$p($g(^DHCEQMExObj(ExObjDR)),"^",1)
	.s Value=$g(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject",+$H,User,ExObjDR))
	.s TTimes=$p(Value,"^",1)
	.s TAccessoryFee=$p(Value,"^",2)
	.s THours=$p(Value,"^",3)
	.d OutputRowGetMaintObject
	
	Quit $$$OK
BuildGetMaintObject
	//^DHCEQMMaintRequest()
	//MR_ExObjDR
	s rowid=""
	f  s rowid=$o(^DHCEQMMaintRequest(rowid)) q:rowid=""  d
	.s data=$g(^DHCEQMMaintRequest(rowid))
	.s TStatus=$p(data,"^",41)		//状态
	.s TInvalidFlag=$p(data,"^",57)	//无效标志
	.q:(TStatus="3")||(TInvalidFlag="Y")
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,$p(data,"^",6))))
	.s MRDate=$p(data,"^",18)
	.q:(MRDate<StartDate)||(MRDate>EndDate)
	.s TExObjDR=$p(data,"^",5) 						//维修对象
	.q:TExObjDR=""     //add by zx 2015-09-14 BugZX0032
	.q:(ObjectDR'="")&&(ObjectDR'=TExObjDR)
	.s TTimes=1										//维修次数 s val=rs.GetDataByName("")
	.s TAccessoryFee=..GetMaintAccessoryFee(rowid)	//消耗配件金额
	.s THours=$p(data,"^",39)						//维修消耗的工时
	.;i ((TStatus=2)&&(THours="")) s THours=$Piece(data,"^",16)-$Piece(data,"^",24) //统计实际工时 modified by czf 576239 时间以小时计 20180408
	.i $d(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject",+$H,User,TExObjDR))  d
	..s $p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject",+$H,User,TExObjDR),"^",1)=TTimes+$p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject",+$H,User,TExObjDR),"^",1)
	..s $p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject",+$H,User,TExObjDR),"^",2)=TAccessoryFee+$p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject",+$H,User,TExObjDR),"^",2)
	..s $p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject",+$H,User,TExObjDR),"^",3)=THours+$p(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject",+$H,User,TExObjDR),"^",3)
	.e  d
	..s ^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject",+$H,User,TExObjDR)=TTimes_"^"_TAccessoryFee_"^"_THours
	quit
	
OutputRowGetMaintObject
	Set Data=$lb(TObjectDR,TObject,TTimes,TAccessoryFee,THours,TRow)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	s num=num+1
	s TRow=TRow+1
	s ^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject","Export",+$H,User,num)=TObject_"^"_TTimes_"^"_TAccessoryFee_"^"_THours
	quit
	
ResetVariablesGetMaintObject
	s (TStatus,TInvalidFlag,TObjectDR,TObject)=""
	s (TTimes,TAccessoryFee,THours)=0
	quit
}

ClassMethod GetMaintObjectInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaintObjectInfoExecute ]
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

ClassMethod GetMaintObjectInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaintObjectInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMaintObjectInfoExport(num)
{
	i num<0 q ""
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	i num=0 q $o(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject","Export",+$H,User,""),-1)
	q $g(^TempDHCEQ("DHCEQMMaintRequest","GetMaintObject","Export",+$H,User,num))
}

ClassMethod GetMExObjClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMExObjExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMExObjExecute(ByRef qHandle As %Binary, ObjectName As %String = "", LocDR As %String = "", ExType As %String = "", ExID As %String = "", ObjType As %String = "", QXType) As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
	d BuildDataGetMExObj
	Quit $$$OK
BuildDataGetMExObj
	f  s rowid=$o(^DHCEQMExObj(rowid))  quit:rowid=""  d
	.d ResetVariablesGetMExObj
	.s TRowID = rowid	//rowid
	.s Value=$g(^DHCEQMExObj(rowid))
	.q:"Y"=$p(Value,"^",14) //InvalidFlag
	.s TName=$p(Value,"^",1)
	.s TNo=$p(Value,"^",2)
	.q:(ObjectName'="")&&((TName'[ObjectName)&&(TNo'[ObjectName))
	.s TLocDR=$p(Value,"^",3)
	.q:(LocDR'="")&&(LocDR'=TLocDR)
	.q:(1=(##class(web.DHCEQCommon).LocIsInEQ(QXType,TLocDR)))
	.s TExTypeDR=$p(Value,"^",4)
	.q:(ExType'="")&&(ExType'=TExTypeDR)
	.s TExID=$p(Value,"^",5)
	.q:(ExID'="")&&(ExID'=TExID)
	.s TObjTypeDR=$p(Value,"^",6)
	.q:(ObjType'="")&&(ObjType'=TObjTypeDR)
	.s TLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDR)
	.s TExType=..GetExType(TExTypeDR)
	.i TObjTypeDR'="" s TObjType=$p($g(^DHCEQCCode("DHCEQMCObjType",TObjTypeDR)),"^",2)
	.s TRemark=$p(Value,"^",7)
	.s TCreateDate=$p(Value,"^",8)
	.s TCreateUserDR=$p(Value,"^",9)
	.s TCreateUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TCreateUserDR)
	.s TUpdateDate=$p(Value,"^",10)
	.s TUpdateUserDR=$p(Value,"^",11)
	.s TUpdateUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TUpdateUserDR)
	.d OutputRowGetMExObj
	quit
OutputRowGetMExObj
	s Data=$lb(TRowID,TName,TNo,TLocDR,TLoc,TExTypeDR,TExType,TExID,TObjTypeDR,TObjType,TRemark,TCreateDate,TCreateUserDR,TCreateUser,TUpdateDate,TUpdateUserDR,TUpdateUser)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMExObj
	s (Value,TRowID,TName,TNo,TLocDR,TLoc,TExTypeDR,TExType,TExID,TObjTypeDR,TObjType,TRemark,TCreateDate,TCreateUserDR,TCreateUser,TUpdateDate,TUpdateUserDR,TUpdateUser)=""
	quit
}

ClassMethod GetMExObjFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMExObjExecute ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCEQMMaintStatisticsAnaly","GetMExObj","","","","","")
Query GetMExObj(ObjectName As %String = "", LocDR As %String = "", ExType As %String = "", ExID As %String = "", ObjType As %String = "", QXType) As %Query(ROWSPEC = "TRowID:%String,TName:%String,TNo:%String,TLocDR:%String,TLoc:%String,TExTypeDR:%String,TExType:%String,TExID:%String,TObjTypeDR:%String,TObjType:%String,TRemark:%String,TCreateDate:%String,TCreateUserDR:%String,TCreateUser:%String,TUpdateDate:%String,TUpdateUserDR:%String,TUpdateUser:%String")
{
}

/// 扩展类型
ClassMethod GetExType(ExType)
{
	q $Case(ExType,"1":"设备","9":"其他","":"")
}

/// 对象类型
ClassMethod GetObjType(ObjType)
{
	q $Case(ObjType,"1":"设备","2":"房间","3":"设施","9":"其他","":"")
}

/******************************************************************/
/// Add By ZX 2015-07-20
/// 描述:工程师月工作量统计
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintStatisticsAnaly","MaintEngineerWorkNum","1","2015-06","2015-07")
Query MaintEngineerWorkNum(EngineerDR As %String = "", StartMonth As %String = "", EndMonth As %String = "") As %Query(ROWSPEC = "Month:%String, WorkNum:%String") [ SqlProc ]
{
}

ClassMethod MaintEngineerWorkNumExecute(ByRef qHandle As %Binary, EngineerDR As %String = "", StartMonth As %String = "", EndMonth As %String = "") As %Status
{
	new repid, index, rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	i (StartMonth="")||(EndMonth="") Quit $$$OK
	i ($ZDH(StartMonth_"-01",3)>$ZDH(EndMonth_"-01",3)) Quit $$$OK
	s vstartYear=+$p(StartMonth,"-",1)
	s vstartMonth=+$p(StartMonth,"-",2)
	s vendYear=+$p(EndMonth,"-",1)
	s vendMonth=+$p(EndMonth,"-",2)
	s MonthNum=(vendYear*12+vendMonth)-(vstartYear*12+vstartMonth)
	for monthnum=0:1:MonthNum d
	.s WorkNum=0
	.s Month=##Class(web.DHCEQCommon).MonthStrAdd("M",monthnum,StartMonth)
	.s BeginDate=##Class(web.DHCEQReport).GetReportDate(Month,"1","")
	.s EndDate=##Class(web.DHCEQReport).GetReportDate(Month,"2","")
	.s rowid=0
	.f  s rowid=$o(^DHCEQMMaintRequest(rowid)) q:rowid=""  d
	..s TInvalidFlag=$p($g(^DHCEQMMaintRequest(rowid)),"^",57)
	..q:TInvalidFlag'="N"
	..;begin add by jyp 2020-03-12 JYP0023
	..s TStatus=$p($g(^DHCEQMMaintRequest(rowid)),"^",41)
	..q:TStatus=3
	..;end add by jyp 2020-03-12 JYP0023
	..s TAcceptUserDR=$p($g(^DHCEQMMaintRequest(rowid)),"^",26)
	..q:(EngineerDR'="")&&(EngineerDR'=TAcceptUserDR)
	..s TAuditDate=$p($g(^DHCEQMMaintRequest(rowid)),"^",52)
	..q:(TAuditDate<BeginDate)||(TAuditDate>EndDate)
	..s WorkNum=WorkNum+1
	.d OutputRowGetMaintEngineerWorkNum

	Quit $$$OK
OutputRowGetMaintEngineerWorkNum

	s Data=$lb(Month,WorkNum)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetMaintEngineerWorkNum
	s (Month,BeginDate,EndDate,TInvalidFlag,TAcceptUserDR,TAuditDate)=""
	quit
}

ClassMethod MaintEngineerWorkNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintEngineerWorkNumExecute ]
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

ClassMethod MaintEngineerWorkNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintEngineerWorkNumExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintStatisticsAnaly","MaintRequestDetail")
Query MaintRequestDetail(vEquipDR As %String = "", vEquipNo As %String = "", vEquipName As %String = "", vModelDR As %String = "", vFromOriginalFee As %String = "", vToOriginalFee As %String = "", vItemDR As %String = "", vEquipTypeDR As %String = "", vStatCatDR As %String = "", vEquipCatDR As %String = "", vLocDR As %String = "", vSDate As %String = "", vEDate As %String = "", vFromMaintAmount As %String = "", vToMaintAmount As %String = "", vMaintUserDR As %String = "", vMaintGroupDR As %String = "", vInsurFlag As %String = "", vProviderDR As %String = "", vManufactoryDR As %String = "", vServiceDR As %String = "", QXType As %String = "", CurLocID As %String = "", CurGroupID As %String = "", vLoc As %String = "", vFromYear As %String = "", vToYear As %String = "", CurHospID As %String = "", CurUserID As %String = "", MGroupFlag As %String = "") As %SQLQuery(ROWSPEC = "TEquipNo:%String,TEquipName:%String,TModel:%String,TOriginalFee:%String,TItem:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TUseLoc:%String,TProvider:%String,TManuFactory:%String,TService:%String,TMaintNum:%String,TMaintFee:%String,TMaintAmount:%String,TAccessoryNum:%String,TAccessoryAmount:%String,TAcceptDate:%String,TAcceptTime:%String,TAuditDate:%String,TAuditTime:%String,TEstimateWorkHour:%String,TSysComputerHour:%String,TAccessoryRequestSDate:%String,TAccessoryRequestSTime:%String,TAccessoryRequestEDate:%String,TAccessoryRequestETime:%String,TMaintRequestNo:%String,TInsurFlag:%String,TMaintUser:%String,TMaintGroup:%String,TAuditYear:%String,TEquipDR:%String,TABCType:%String,TFileNo:%String") [ SqlProc ]
{
}

ClassMethod MaintRequestDetailExecute(ByRef qHandle As %Binary, vEquipDR As %String = "", vEquipNo As %String = "", vEquipName As %String = "", vModelDR As %String = "", vFromOriginalFee As %String = "", vToOriginalFee As %String = "", vItemDR As %String = "", vEquipTypeDR As %String = "", vStatCatDR As %String = "", vEquipCatDR As %String = "", vLocDR As %String = "", vSDate As %String = "", vEDate As %String = "", vFromMaintAmount As %String = "", vToMaintAmount As %String = "", vMaintUserDR As %String = "", vMaintGroupDR As %String = "", vInsurFlag As %String = "", vProviderDR As %String = "", vManufactoryDR As %String = "", vServiceDR As %String = "", QXType As %String = "", CurLocID As %String = "", CurGroupID As %String = "", vLoc As %String = "", vFromYear As %String = "", vToYear As %String = "", CurHospID As %String = "", CurUserID As %String = "", MGroupFlag As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s BeginDate=0
 	s EndDate=+$H
 	;i vSDate'="" s BeginDate=$ZDH(vSDate,3)
 	;i vEDate'="" s EndDate=$ZDH(vEDate,3)
 	;日期格式统一调整
 	s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vSDate,"date")
 	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEDate,"date")
 	s YearFlag=0
 	s index=1
 	s MRRowID=0
 	f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Status",2,MRRowID))  q:MRRowID=""  d
 	.d ResetMaintRequestDetail
 	.s MRInvalidFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)
 	.q:MRInvalidFlag="Y"
 	.s SourceTypeDR=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",63)
 	.s TExObjDR = $p($g(^DHCEQMMaintRequest(MRRowID)),"^",5)
 	.s TOriginalFee=0
 	.s Flag=0
 	.i TExObjDR'=""  d
 	..i (SourceTypeDR=1)||(SourceTypeDR=2)||(SourceTypeDR=3)  d		//Modify DJ 2019-06-06 modify by zyq 2023-02-22
 	...s TExObjDR=$p($g(^DHCEQMExObj(TExObjDR)),"^",5)
 	...i ((vEquipDR'="")&&(TExObjDR'=vEquipDR)) s Flag=1
 	...q:Flag'=0
 	...i TExObjDR'=""  d
 	....;20190215	Mozy0219
 	....s TEquipDR=TExObjDR
 	....s TEquipNo=$p($g(^DHCEQEquip(TExObjDR)),"^",71)			//设备编号
 	....s TEquipName=$p($g(^DHCEQEquip(TExObjDR)),"^",1)		//设备名称
 	....s TABCType=$p($g(^DHCEQEquip(TExObjDR)),"^",2)			//价值类型
 	....s TModel=$p($g(^DHCEQEquip(TExObjDR)),"^",3)			//规格型号
 	....s TItem=$p($g(^DHCEQEquip(TExObjDR)),"^",7)				//设备项
 	....s TStatCat=$p($g(^DHCEQEquip(TExObjDR)),"^",75)			//设备类型
 	....s TEquipCat=$p($g(^DHCEQEquip(TExObjDR)),"^",4)			//设备分类
 	....s TProvider=$p($g(^DHCEQEquip(TExObjDR)),"^",25)		//供应商
 	....s TManuFactory=$p($g(^DHCEQEquip(TExObjDR)),"^",26)		//生产厂家
 	....s TOriginalFee=$p($g(^DHCEQEquip(TExObjDR)),"^",27)		//原值
 	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee)
 	....s TFileNo=$p($g(^DHCEQEquip(TExObjDR)),"^",85)
 	..;e  i SourceTypeDR=2  d   //add by zx 2016-06-15 begin
 	..;.i TExObjDR'=""  d
 	..;..s TEquipName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TExObjDR)),"^",1)
 	..;..s TItem=TExObjDR
 	..;..s TStatCat=$p($g(^DHCEQCCode("DHCEQCMasterItem",TExObjDR)),"^",5)
 	..;..s TEquipCat=$p($g(^DHCEQCCode("DHCEQCMasterItem",TExObjDR)),"^",4) //add by zx 2016-06-15 end
 	..e  d
 	...s TEquipName=$p($g(^DHCEQMExObj(TExObjDR)),"^",1)
 	.q:Flag'=0
 	.q:((vEquipNo'="")&&(TEquipNo'=vEquipNo))
 	.q:((vEquipName'="")&&(TEquipName'=vEquipName))
 	.q:((vModelDR'="")&&(TModel'=vModelDR))
 	.q:((vItemDR'="")&&(TItem'=vItemDR))
 	.q:((vStatCatDR'="")&&(TStatCat'=vStatCatDR))
 	.q:((vEquipCatDR'="")&&(TEquipCat'=vEquipCatDR))
 	.q:((vProviderDR'="")&&(TProvider'=vProviderDR))
 	.q:((vManufactoryDR'="")&&(TManuFactory'=vManufactoryDR))
 	.q:((vFromOriginalFee'="")&&(TOriginalFee<vFromOriginalFee))
 	.q:((vToOriginalFee'="")&&(TOriginalFee>vToOriginalFee))
 	.s TEquipType=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",3)			//设备类组
 	.q:((vEquipTypeDR'="")&&(TEquipType'=vEquipTypeDR))
 	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipType,CurGroupID,"","2")		//Modify DJ 2019-06-06
 	.q:+result'=0
 	.s TUseLoc=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",6)				//使用科室
 	.q:((vLocDR'="")&&(TUseLoc'=vLocDR))
 	.s TService=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",31)				//维修商
 	.q:((vServiceDR'="")&&(TService'=vServiceDR))
 	.s TMaintRequestNo=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",1)		//维修单号
 	.s TInsurFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",66)			//在保标志
 	.i TInsurFlag="" s TInsurFlag="N"	//Add By DJ 2016-11-28
 	.;20190215	Mozy0219	增加自修业务取值
 	.s TMaintModeDR=+$p($g(^DHCEQMMaintRequest(MRRowID)),"^",28)			//维修方式
 	.s TNewMaintModrDR=0
 	.i (","_##class(web.DHCEQCommon).GetSysInfo("503005")_",")[(","_TMaintModeDR_",") s TNewMaintModrDR=1
 	.s TInsurFlag=TInsurFlag_"-"_TNewMaintModrDR
 	.q:((vInsurFlag'="")&&(TInsurFlag'[vInsurFlag))
 	.s TMaintUser=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",26)			//维修人员
 	.q:((vMaintUserDR'="")&&(TMaintUser'=vMaintUserDR))
 	.s TMaintGroup=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",70)			//维修组
 	.q:((vMaintGroupDR'="")&&(TMaintGroup'=vMaintGroupDR))
 	.s TMaintNum="1"													//维修次数
 	.s TMaintFee=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",58)			//人工费
 	.s TMaintAmount=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",60)			//维修总费用
 	.s TMaintAmount=##Class(web.DHCEQCommon).FormatNumber(TMaintAmount)
 	.q:((vFromMaintAmount'="")&&(TMaintAmount<vFromMaintAmount))
 	.q:((vToMaintAmount'="")&&(TMaintAmount>vToMaintAmount))
 	.s TAuditDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",52)			//维修审核日期
 	.q:((BeginDate'="")&&(TAuditDate<BeginDate))
 	.q:((EndDate'="")&&(TAuditDate>EndDate))
 	.s TAuditYear=$E($ZD(TAuditDate,3),1,4)								//年份
 	.q:((vFromYear'="")&&(TAuditYear<vFromYear))
 	.q:((vToYear'="")&&(TAuditYear>vToYear))
 	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
 	.q:((vLoc'="")&&(TUseLoc'[vLoc))
 	.s TAccessoryNum=$p(..GetMaintPartNum(MRRowID),"^",1)				//配件总数量
 	.s TAccessoryAmount=##class(web.DHCEQCommon).FormatNumber(##Class(web.DHCEQM.DHCEQMMaintRequest).GetTotalFee(MRRowID,1),"")	//$p($g(^DHCEQMMaintRequest(MRRowID)),"^",59)		//配件总费用
 	.s TAcceptDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",24)			//维修受理日期
 	.s TAcceptTime=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",25)			//维修受理时间
 	.s TAuditTime=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",53)			//维修审核时间
 	.s TEstimateWorkHour=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",38)	//工时
 	.s TSysComputerHour=..GetComputerHour(MRRowID)	//系统计算工时(小时)
 	.s MPRequestInfo=..GetMaintPartRequestInfo(MRRowID)
 	.s TAccessoryRequestSDate=+$p(MPRequestInfo,"^",1)		//配件申请提交日期
 	.s TAccessoryRequestSTime=+$p(MPRequestInfo,"^",2)		//配件申请提交时间
 	.s TAccessoryRequestEDate=+$p(MPRequestInfo,"^",3)		//配件申请通过日期
 	.s TAccessoryRequestETime=+$p(MPRequestInfo,"^",4)		//配件申请通过时间
 	.s TAccessoryRequestSDate=##Class(web.DHCEQCommon).TransValueToPage(TAccessoryRequestSDate,"date")
 	.s TAccessoryRequestSTime=##Class(web.DHCEQCommon).TransValueToPage(TAccessoryRequestSTime,"time")
 	.s TAccessoryRequestEDate=##Class(web.DHCEQCommon).TransValueToPage(TAccessoryRequestEDate,"date")
 	.s TAccessoryRequestETime=##Class(web.DHCEQCommon).TransValueToPage(TAccessoryRequestETime,"time")
 	.s TAuditDate=##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
 	.s TAuditTime=##Class(web.DHCEQCommon).TransValueToPage(TAuditTime,"time")
 	.s TAcceptDate=##Class(web.DHCEQCommon).TransValueToPage(TAcceptDate,"date")
 	.s TAcceptTime=##Class(web.DHCEQCommon).TransValueToPage(TAcceptTime,"time")
 	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipType)
 	.s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCat)
 	.s TEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCat)
 	.s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
 	.s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactory)
 	.s TService=##Class(web.DHCEQCommon).GetTrakNameByID("cservice",TService)
 	.s TUseLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TUseLoc,"-")
 	.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModel)
 	.s TItem=##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItem)
 	.s TMaintUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUser)
 	.s TMaintGroup=##Class(web.DHCEQCommon).GetTrakNameByID("maintgroup",TMaintGroup)
 	.s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee)
 	.s TAccessoryAmount=##Class(web.DHCEQCommon).FormatNumber(TAccessoryAmount)
 	.d OutPutMaintRequestDetail
 	.i YearFlag=0  d		;年度查询时年度条件为空时默认显示至少3年的数据(构建初始年份数据)
 	..s YearFlag=1
 	..s CurYear=+$E($ZD(+$H,3),1,4)
 	..s CurFromYear=+vFromYear
 	..s CurToYear=+vToYear
 	..i vFromYear="" s CurFromYear=CurYear-2
 	..i vToYear="" s CurToYear=CurYear
 	..s Year=0
 	..f Year=CurFromYear:1:CurToYear  d
 	...s TAuditYear=Year
 	...s (TMaintNum,TMaintFee,TMaintAmount,TAccessoryNum,TAccessoryAmount,TEstimateWorkHour,TSysComputerHour)=0
 	...d OutPutMaintRequestDetail
 	
	Quit $$$OK
OutPutMaintRequestDetail
	If TABCType="" Set TABCType="D"
	s Data=$lb(TEquipNo,TEquipName,TModel,TOriginalFee,TItem,TEquipType,TStatCat,TEquipCat,TUseLoc,TProvider,TManuFactory,TService,TMaintNum,TMaintFee,TMaintAmount,TAccessoryNum,TAccessoryAmount,TAcceptDate,TAcceptTime,TAuditDate,TAuditTime,TEstimateWorkHour,TSysComputerHour,TAccessoryRequestSDate,TAccessoryRequestSTime,TAccessoryRequestEDate,TAccessoryRequestETime,TMaintRequestNo,TInsurFlag,TMaintUser,TMaintGroup,TAuditYear,TEquipDR,TABCType,TFileNo)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetMaintRequestDetail
	s (TEquipNo,TEquipName,TModel,TOriginalFee,TItem,TEquipType,TStatCat,TEquipCat,TUseLoc,TProvider,TManuFactory,TService,TMaintNum,TMaintFee,TMaintAmount,TAccessoryNum,TAccessoryAmount,TAcceptDate,TAcceptTime,TAuditDate,TAuditTime,TEstimateWorkHour,TSysComputerHour,TAccessoryRequestSDate,TAccessoryRequestSTime,TAccessoryRequestEDate,TAccessoryRequestETime,TMaintRequestNo,TInsurFlag,TMaintUser,TMaintGroup,TAuditYear,TEquipDR,TABCType,TFileNo)=""
	quit
}

ClassMethod MaintRequestDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintRequestDetailExecute ]
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

ClassMethod MaintRequestDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintRequestDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// MZY0059	1524192,1561624		2020-10-26		调整增加《科室维修汇总统计(配件)》报表
/// AllFalg:显示标志	空:只显示有配件的维修记录	非空:显示全部记录
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintStatisticsAnaly","MaintRequestPartDetail","","","","","","","","","","","","","2020-10-27","","","","","","","","","",202,85,"","","",1)
Query MaintRequestPartDetail(vEquipDR As %String = "", vEquipNo As %String = "", vEquipName As %String = "", vModelDR As %String = "", vFromOriginalFee As %String = "", vToOriginalFee As %String = "", vItemDR As %String = "", vEquipTypeDR As %String = "", vStatCatDR As %String = "", vEquipCatDR As %String = "", vLocDR As %String = "", vSDate As %String = "", vEDate As %String = "", vFromMaintAmount As %String = "", vToMaintAmount As %String = "", vMaintUserDR As %String = "", vMaintGroupDR As %String = "", vInsurFlag As %String = "", vProviderDR As %String = "", vManufactoryDR As %String = "", vServiceDR As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", vLoc As %String = "", vFromYear As %String = "", vToYear As %String = "", AllFalg As %String = "") As %SQLQuery(ROWSPEC = "TEquipNo:%String,TEquipName:%String,TModel:%String,TOriginalFee:%String,TItem:%String,TEquipType:%String,TStatCat:%String,TEquipCat:%String,TUseLoc:%String,TProvider:%String,TManuFactory:%String,TService:%String,TMaintNum:%String,TMaintFee:%String,TMaintAmount:%String,TAccessoryNum:%String,TAccessoryAmount:%String,TAcceptDate:%String,TAcceptTime:%String,TAuditDate:%String,TAuditTime:%String,TEstimateWorkHour:%String,TSysComputerHour:%String,TAccessoryRequestSDate:%String,TAccessoryRequestSTime:%String,TAccessoryRequestEDate:%String,TAccessoryRequestETime:%String,TMaintRequestNo:%String,TInsurFlag:%String,TMaintUser:%String,TMaintGroup:%String,TMPartName:%String,TMPartModel:%String,TMPartNum:%String,TMPartPrice:%String,TMPartAmount:%String,TMPManufacturer:%String,TMPProvider:%String,TAuditYear:%String,TLeaveFactoryNo:%String,TRequestDate:%String,TFaultCaseRemark:%String") [ SqlProc ]
{
}

ClassMethod MaintRequestPartDetailExecute(ByRef qHandle As %Binary, vEquipDR As %String = "", vEquipNo As %String = "", vEquipName As %String = "", vModelDR As %String = "", vFromOriginalFee As %String = "", vToOriginalFee As %String = "", vItemDR As %String = "", vEquipTypeDR As %String = "", vStatCatDR As %String = "", vEquipCatDR As %String = "", vLocDR As %String = "", vSDate As %String = "", vEDate As %String = "", vFromMaintAmount As %String = "", vToMaintAmount As %String = "", vMaintUserDR As %String = "", vMaintGroupDR As %String = "", vInsurFlag As %String = "", vProviderDR As %String = "", vManufactoryDR As %String = "", vServiceDR As %String = "", QXType As %String = "", CurLocDR As %String = "", CurGroupDR As %String = "", vLoc As %String = "", vFromYear As %String = "", vToYear As %String = "", AllFalg As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s BeginDate=0
 	s EndDate=+$H
 	;i vSDate'="" s BeginDate=$ZDH(vSDate,3)
 	;i vEDate'="" s EndDate=$ZDH(vEDate,3)
 	;日期格式统一调整
 	s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vSDate,"date")
 	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEDate,"date")
 	
 	s index=1
 	s MRRowID=0
 	f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Status",2,MRRowID))  q:MRRowID=""  d
 	.d ResetMaintRequestPartDetail
 	.s MRInvalidFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)
 	.q:MRInvalidFlag="Y"
 	.s SourceTypeDR=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",63)
 	.s TExObjDR = $p($g(^DHCEQMMaintRequest(MRRowID)),"^",5)
 	.s TOriginalFee=0
 	.s Flag=0
 	.i TExObjDR'=""  d
 	..i SourceTypeDR=1  d
 	...s TExObjDR=$p($g(^DHCEQMExObj(TExObjDR)),"^",5)
 	...i ((vEquipDR'="")&&(TExObjDR'=vEquipDR)) s Flag=1
 	...q:Flag'=0
 	...i TExObjDR'=""  d
 	....s TEquipNo=$p($g(^DHCEQEquip(TExObjDR)),"^",71)			//设备编号
 	....s TEquipName=$p($g(^DHCEQEquip(TExObjDR)),"^",1)		//设备名称
 	....s TModel=$p($g(^DHCEQEquip(TExObjDR)),"^",3)			//规格型号
 	....s TItem=$p($g(^DHCEQEquip(TExObjDR)),"^",7)				//设备项
 	....s TStatCat=$p($g(^DHCEQEquip(TExObjDR)),"^",75)			//设备类型
 	....s TEquipCat=$p($g(^DHCEQEquip(TExObjDR)),"^",4)			//设备分类
 	....s TProvider=$p($g(^DHCEQEquip(TExObjDR)),"^",25)		//供应商
 	....s TManuFactory=$p($g(^DHCEQEquip(TExObjDR)),"^",26)		//生产厂家
 	....s TOriginalFee=$p($g(^DHCEQEquip(TExObjDR)),"^",27)		//原值
 	....s TOriginalFee=##Class(web.DHCEQCommon).FormatNumber(TOriginalFee)
 	....s TLeaveFactoryNo=$p($g(^DHCEQEquip(TExObjDR)),"^",10)	//出厂编号	 MZY0059	1524192,1561624		2020-10-26
 	..e  i SourceTypeDR=2  d   //add by zx 2016-06-15 begin
 	...i TExObjDR'=""  d
 	....s TEquipName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TExObjDR)),"^",1)
 	....s TItem=TExObjDR
 	....s TStatCat=$p($g(^DHCEQCCode("DHCEQCMasterItem",TExObjDR)),"^",5)
 	....s TEquipCat=$p($g(^DHCEQCCode("DHCEQCMasterItem",TExObjDR)),"^",4) //add by zx 2016-06-15 end
 	..e  d
 	...s TEquipName=$p($g(^DHCEQMExObj(TExObjDR)),"^",1)
 	.q:Flag'=0
 	.q:((vEquipNo'="")&&(TEquipNo'=vEquipNo))
 	.q:((vEquipName'="")&&(TEquipName'=vEquipName))
 	.q:((vModelDR'="")&&(TModel'=vModelDR))
 	.q:((vItemDR'="")&&(TItem'=vItemDR))
 	.q:((vStatCatDR'="")&&(TStatCat'=vStatCatDR))
 	.q:((vEquipCatDR'="")&&(TEquipCat'=vEquipCatDR))
 	.q:((vProviderDR'="")&&(TProvider'=vProviderDR))
 	.q:((vManufactoryDR'="")&&(TManuFactory'=vManufactoryDR))
 	.q:((vFromOriginalFee'="")&&(TOriginalFee<vFromOriginalFee))
 	.q:((vToOriginalFee'="")&&(TOriginalFee>vToOriginalFee))
 	.s TEquipType=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",3)			//设备类组
 	.q:((vEquipTypeDR'="")&&(TEquipType'=vEquipTypeDR))
 	.s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipType,CurGroupDR)
 	.q:+result'=0
 	.s TUseLoc=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",6)				//使用科室
 	.q:((vLocDR'="")&&(TUseLoc'=vLocDR))
 	.s TService=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",31)				//维修商
 	.q:((vServiceDR'="")&&(TService'=vServiceDR))
 	.s TMaintRequestNo=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",1)		//维修单号
 	.s TInsurFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",66)			//在保标志
 	.q:((vInsurFlag'="")&&(TInsurFlag'=vInsurFlag))
 	.s TMaintUser=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",26)			//维修人员
 	.q:((vMaintUserDR'="")&&(TMaintUser'=vMaintUserDR))
 	.s TMaintGroup=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",70)			//维修组
 	.q:((vMaintGroupDR'="")&&(TMaintGroup'=vMaintGroupDR))
 	.s TMaintNum="1"													//维修次数
 	.s TMaintFee=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",58)			//人工费
 	.s TMaintAmount=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",60)			//维修总费用
 	.s TMaintAmount=##Class(web.DHCEQCommon).FormatNumber(TMaintAmount)
 	.q:((vFromMaintAmount'="")&&(TMaintAmount<vFromMaintAmount))
 	.q:((vToMaintAmount'="")&&(TMaintAmount>vToMaintAmount))
 	.s TAuditDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",52)			//维修审核日期
 	.q:((BeginDate'="")&&(TAuditDate<BeginDate))
 	.q:((EndDate'="")&&(TAuditDate>EndDate))
 	.s TAuditYear=$E($ZD(TAuditDate,3),1,4)								//年份
 	.q:((vFromYear'="")&&(TAuditYear<vFromYear))
 	.q:((vToYear'="")&&(TAuditYear>vToYear))
 	.s TAccessoryNum=$p(..GetMaintPartNum(MRRowID),"^",1)				//配件总数量
 	.s TAccessoryAmount=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",59)		//配件总费用
 	.// MZY0059	1524192,1561624		2020-10-26
	.s TFaultCaseRemark=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",11)		//现象备注
 	.s TRequestDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",18)			//维修申请日期
 	.s TAcceptDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",24)			//维修受理日期
 	.s TAcceptTime=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",25)			//维修受理时间
 	.s TAuditTime=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",53)			//维修审核时间
 	.s TEstimateWorkHour=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",38)	//工时
 	.s TSysComputerHour=..GetComputerHour(MRRowID)	//系统计算工时(小时)
 	.s MPRequestInfo=..GetMaintPartRequestInfo(MRRowID)
 	.s TAccessoryRequestSDate=+$p(MPRequestInfo,"^",1)		//配件申请提交日期
 	.s TAccessoryRequestSTime=+$p(MPRequestInfo,"^",2)		//配件申请提交时间
 	.s TAccessoryRequestEDate=+$p(MPRequestInfo,"^",3)		//配件申请通过日期
 	.s TAccessoryRequestETime=+$p(MPRequestInfo,"^",4)		//配件申请通过时间
 	.s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")		// MZY0059	1524192,1561624		2020-10-26
 	.s TAccessoryRequestSDate=##Class(web.DHCEQCommon).TransValueToPage(TAccessoryRequestSDate,"date")
 	.s TAccessoryRequestSTime=##Class(web.DHCEQCommon).TransValueToPage(TAccessoryRequestSTime,"time")
 	.s TAccessoryRequestEDate=##Class(web.DHCEQCommon).TransValueToPage(TAccessoryRequestEDate,"date")
 	.s TAccessoryRequestETime=##Class(web.DHCEQCommon).TransValueToPage(TAccessoryRequestETime,"time")
 	.s TAuditDate=##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
 	.s TAuditTime=##Class(web.DHCEQCommon).TransValueToPage(TAuditTime,"time")
 	.s TAcceptDate=##Class(web.DHCEQCommon).TransValueToPage(TAcceptDate,"date")
 	.s TAcceptTime=##Class(web.DHCEQCommon).TransValueToPage(TAcceptTime,"time")
 	.s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipType)
 	.s TStatCat=##Class(web.DHCEQCommon).GetTrakNameByID("statcat",TStatCat)
 	.s TEquipCat=##Class(web.DHCEQCommon).GetTrakNameByID("equipcat",TEquipCat)
 	.s TProvider=##Class(web.DHCEQCommon).GetTrakNameByID("prov",TProvider)
 	.s TManuFactory=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TManuFactory)
 	.s TService=##Class(web.DHCEQCommon).GetTrakNameByID("cservice",TService)
 	.s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
 	.;q:((vLoc'="")&&(TUseLoc'[vLoc))	// MZY0059	1524192,1561624		2020-10-26	参数vLoc异常
 	.s TUseLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TUseLoc,"-")
 	.s TModel=##Class(web.DHCEQCommon).GetTrakNameByID("model",TModel)
 	.s TItem=##Class(web.DHCEQCommon).GetTrakNameByID("masteritem",TItem)
 	.s TMaintUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUser)
 	.s TMaintGroup=##Class(web.DHCEQCommon).GetTrakNameByID("maintgroup",TMaintUser)
 	.s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee)
 	.s TAccessoryAmount=##Class(web.DHCEQCommon).FormatNumber(TAccessoryAmount)
 	.s FindFalg=0	;配件记录数		// MZY0059	1524192,1561624		2020-10-26
 	.s MPRowID=0
 	.f  s MPRowID=$o(^DHCEQMMaintPart(0,"MaintRequest",MRRowID,MPRowID))  q:MPRowID=""  d
	..s TMTPRowID=MPRowID
	..s TMTPStockDetailDR=""  // added by LMH 20220815 2778908 增加变量，记录配件库存DR
	..s TMPartModel=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",14)
	..s TMPartNum=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",3)
	..s TMPartPrice=##Class(web.DHCEQCommon).FormatNumber($P($G(^DHCEQMMaintPart(TMTPRowID)),"^",4),"",2)
	..s TMPartAmount=##Class(web.DHCEQCommon).FormatNumber($P($G(^DHCEQMMaintPart(TMTPRowID)),"^",5),"",2)
	..s TMPManufacturer=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",15)
	..i TMPManufacturer'="" s TMPManufacturer=##Class(web.DHCEQCommon).GetTrakNameByID("manufacturer",TMPManufacturer) //CZF0093
	..s TMPProvider=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",16)
	..i TMPProvider'="" s TMPProvider=$p($g(^DHCEQCCode("DHCEQCVendor",TMPProvider)),"^",2)
	..s TMPartName=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",19)	// MZY0059	1524192,1561624		2020-10-26
	..s TMTPStockDetailDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",13)     //modified by LMH 20220815  2778908
	..i TMTPStockDetailDR'=""  d
	...s TMPartName=$p($g(^DHCEQAStockDetail(TMTPStockDetailDR)),"^",5)
	...s TSerialNo=$p($g(^DHCEQAStockDetail(TMTPStockDetailDR)),"^",10)	 //modified by LMH 20220815  2778908
	..s TMTPMaintDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",1)
	..s TMTPRemark=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",6)
	..s TMTPMaintItemDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",17)
	..s FindFalg=FindFalg+1		// MZY0059	1524192,1561624		2020-10-26
 	..d OutPutMaintRequestPartDetail
 	.// MZY0059	1524192,1561624		2020-10-26
 	.i (FindFalg=0)&&(AllFalg'="") d
 	..s TMPartName="--"
 	..d OutPutMaintRequestPartDetail
 	
	Quit $$$OK
OutPutMaintRequestPartDetail
	Set Data=$lb(TEquipNo,TEquipName,TModel,TOriginalFee,TItem,TEquipType,TStatCat,TEquipCat,TUseLoc,TProvider,TManuFactory,TService,TMaintNum,TMaintFee,TMaintAmount,TAccessoryNum,TAccessoryAmount,TAcceptDate,TAcceptTime,TAuditDate,TAuditTime,TEstimateWorkHour,TSysComputerHour,TAccessoryRequestSDate,TAccessoryRequestSTime,TAccessoryRequestEDate,TAccessoryRequestETime,TMaintRequestNo,TInsurFlag,TMaintUser,TMaintGroup,TMPartName,TMPartModel,TMPartNum,TMPartPrice,TMPartAmount,TMPManufacturer,TMPProvider,TAuditYear,TLeaveFactoryNo,TRequestDate,TFaultCaseRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetMaintRequestPartDetail
	s (TEquipNo,TEquipName,TModel,TOriginalFee,TItem,TEquipType,TStatCat,TEquipCat,TUseLoc,TProvider,TManuFactory,TService,TMaintNum,TMaintFee,TMaintAmount,TAccessoryNum,TAccessoryAmount,TAcceptDate,TAcceptTime,TAuditDate,TAuditTime,TEstimateWorkHour,TSysComputerHour,TAccessoryRequestSDate,TAccessoryRequestSTime,TAccessoryRequestEDate,TAccessoryRequestETime,TMaintRequestNo,TInsurFlag,TMaintUser,TMaintGroup,TMPartName,TMPartModel,TMPartNum,TMPartPrice,TMPartAmount,TMPManufacturer,TMPProvider,TAuditYear,TLeaveFactoryNo,TRequestDate,TFaultCaseRemark)=""
	quit
}

ClassMethod MaintRequestPartDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintRequestPartDetailExecute ]
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

ClassMethod MaintRequestPartDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintRequestPartDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 计算维修单从受理动作到完成动作所花的时间(返回值单位为小时),如产生配件确认则去掉科室确认所话的时间
ClassMethod GetComputerHour(vMRRowID As %String = "")
{
	i vMRRowID="" q 0
	s Return=0
	;s AuditDate=$p($g(^DHCEQMMaintRequest(vMRRowID)),"^",52)			//维修审核日期
	;s AuditTime=+$p($g(^DHCEQMMaintRequest(vMRRowID)),"^",53)			//维修审核时间
	s AuditDate=$p($g(^DHCEQMMaintRequest(vMRRowID)),"^",16)			//维修完成日期
	s AuditTime=+$p($g(^DHCEQMMaintRequest(vMRRowID)),"^",17)			//维修完成时间
 	s AcceptDate=$p($g(^DHCEQMMaintRequest(vMRRowID)),"^",24)			//维修受理日期
 	s AcceptTime=+$p($g(^DHCEQMMaintRequest(vMRRowID)),"^",25)			//维修受理时间
 	s Return=##Class(web.DHCEQCommon).DateDiff("s",$ZD(AcceptDate,1),$ZD(AuditDate,1))
 	s Return=Return-AcceptTime+AuditTime
 	//配件申请及通过时间
 	s MPRequestInfo=..GetMaintPartRequestInfo(vMRRowID)
 	s MPRequestDate=+$p(MPRequestInfo,"^",1)
 	s MPRequestTime=+$p(MPRequestInfo,"^",2)
 	s MPPassDate=+$p(MPRequestInfo,"^",3)
 	s MPPassTime=+$p(MPRequestInfo,"^",4)
 	s MPReturn=##Class(web.DHCEQCommon).DateDiff("s",$ZD(MPRequestDate,1),$ZD(MPPassDate,1))
 	s MPReturn=MPReturn-MPRequestTime+MPPassTime
 	
 	s Return=Return-MPReturn
 	i Return<0 s Return=0
 	s Return=##Class(web.DHCEQCommon).FormatNumber(Return/3600,"",2)
 	q Return
}

ClassMethod GetMaintPartNum(vMRRowID As %String = "")
{
	i vMRRowID="" q "0^0"
	s MaintPartNum=0
	s MaintPartAmount=0
	s rowid=0
	f  s rowid=$o(^DHCEQMMaintPart(0,"MaintRequest",vMRRowID,rowid))  Quit:rowid=""  Do
	.s TMTPRowID=rowid
	.s TMTPMaintDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",1)
	.s TMTPAccessoryDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",2)
	.i TMTPAccessoryDR'=""  d
	..s TMTPAccessory=$p($g(^DHCEQAStockDetail(TMTPAccessoryDR)),"^",5)
	..s TSerialNo=$p($g(^DHCEQAStockDetail(TMTPAccessoryDR)),"^",10)
	.s TMTPQuantityNum=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",3)
	.s MaintPartNum=MaintPartNum+TMTPQuantityNum
	.s TMTPPriceFee=##Class(web.DHCEQCommon).FormatNumber($P($G(^DHCEQMMaintPart(TMTPRowID)),"^",4),"",2)
	.s TMTPTotalFee=##Class(web.DHCEQCommon).FormatNumber($P($G(^DHCEQMMaintPart(TMTPRowID)),"^",5),"",2)
	.s MaintPartAmount=MaintPartAmount+TMTPTotalFee
	.s TMTPRemark=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",6)
	.s TMTPStoreRoomDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",7)
	.s TMTPFeeFlag=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",8)
	.s TMTIMaintRequestDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",9)
	.s TMTPModel=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",14)
	.s TMTPManufacturerDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",15)
	.s TMTPProviderDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",16)
	.s TMTPMaintItemDR=$P($G(^DHCEQMMaintPart(TMTPRowID)),"^",17)
	
	q MaintPartNum_"^"_MaintPartAmount
}

ClassMethod GetMaintPartRequestInfo(vMRRowID As %String = "")
{
	i vMRRowID="" q "^^^"
	;配件最早申请时间和配件最后通过时间
 	s MinRequestDate=0
 	s MinRequestTime=0
 	s MaxPassDate=0
 	s MaxPassTime=0
 	s MPRowid=0		//modified by czf 20200628 begin
 	f  s MPRowid=$o(^DHCEQMMaintPart(0,"MaintRequest",vMRRowID,MPRowid))  q:MPRowid=""  d
 	.s MPRequestInfo=$p($g(^DHCEQMMaintPart(MPRowid,"ConfirmData")),";",1)
 	.q:MPRequestInfo=""
 	.s MPPassInfo=$p($g(^DHCEQMMaintPart(MPRowid,"ConfirmData")),";",2)	 //modified by czf 20200628 end
 	.q:MPPassInfo=""
 	.s MPRequestDate=+$p(MPRequestInfo,"^",3)
 	.s MPRequestTime=+$p(MPRequestInfo,"^",4)
 	.s MPPassDate=+$p(MPRequestInfo,"^",3)
 	.s MPPassTime=+$p(MPRequestInfo,"^",4)
 	.i ((MinRequestDate=0)||(MinRequestDate>MPRequestDate))  d
 	..s MinRequestDate=MPRequestDate
 	..s MinRequestTime=MPRequestTime
 	.i MinRequestDate=MPRequestDate  d
 	..i MinRequestTime>MPRequestTime s MinRequestTime=MPRequestTime
 	.i MaxPassDate<MPPassDate  d
 	..s MaxPassDate=MPPassDate
 	..s MaxPassTime=MPPassTime
 	.i MaxPassDate=MPPassDate  d
 	..i MaxPassTime<MPPassTime s MaxPassTime=MPPassTime
 	
 	q MinRequestDate_"^"_MinRequestTime_"^"_MaxPassDate_"^"_MaxPassTime
}

/***************************************************************************/
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintStatisticsAnaly","MaintAndInspectDetail")
Query MaintAndInspectDetail(vPlanDR As %String = "", vPlan As %String = "", vSourceTypeDR As %String = "", vEquipDR As %String = "", vEquipName As %String = "", vEquipNo As %String = "", vModelDR As %String = "", vMaintUserDR As %String = "", vMaintLocDR As %String = "", vMaintLoc As %String = "", vMaintTypeDR As %String = "", vStartDate As %String = "", vEndDate As %String = "", vStatusDR As %String = "", vFromYear As %String = "", vToYear As %String = "", vUseLocDR As %String = "", vUseLoc As %String = "", vMeasureFlag As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %SQLQuery(ROWSPEC = "TBussTypeDR:%String,TBussType:%String,TMaintTypeDR:%String,TMaintType:%String,TMaintModeDR:%String,TMaintMode:%String,TMaintLoc:%String,TUseLoc:%String,TEquipDR:%String,TEquipNo:%String,TEquipName:%String,TMaintUser:%String,TMaintNum:%String,TMaintFee:%String,TAmountFee:%String,TPlan:%String,TPlanDR:%String,TMaintDate:%String,TRemark:%String,TMeasureDept:%String,TMeasureUsers:%String,TMeasureHandler:%String,TMeasureTel:%String,TMeasureFlag:%String,TAuditYear:%String,TStatus:%String,TAuditDate:%String,TAuditTime:%String") [ SqlProc ]
{
}

ClassMethod MaintAndInspectDetailExecute(ByRef qHandle As %Binary, vPlanDR As %String = "", vPlan As %String = "", vSourceTypeDR As %String = "", vEquipDR As %String = "", vEquipName As %String = "", vEquipNo As %String = "", vModelDR As %String = "", vMaintUserDR As %String = "", vMaintLocDR As %String = "", vMaintLoc As %String = "", vMaintTypeDR As %String = "", vStartDate As %String = "", vEndDate As %String = "", vStatusDR As %String = "", vFromYear As %String = "", vToYear As %String = "", vUseLocDR As %String = "", vUseLoc As %String = "", vMeasureFlag As %String = "", QXType As %String = "", CurGroupID As %String = "", CurLocID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	
 	s BeginDate=0
 	s EndDate=+$H
 	;i vStartDate'="" s BeginDate=$ZDH(vStartDate,3)
 	;i vEndDate'="" s EndDate=$ZDH(vEndDate,3)
 	;日期格式统一调整
 	s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
 	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
 	
 	s index=1
 	s YearFlag=0
 	s MTTypeDR=0
 	f  s MTTypeDR=$o(^DHCEQMaint(0,"SourceID",MTTypeDR))  q:MTTypeDR=""  d
 	.q:((MTTypeDR'=1)&&(MTTypeDR'=2))	//只显示保养和检查
 	.q:(vSourceTypeDR'="")&&(MTTypeDR'=vSourceTypeDR)
 	.s SourceID=""
 	.f  s SourceID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,SourceID))  q:SourceID=""  d
	..s TPlanDR=""
	..s TPlan=""
	..i SourceID'=0  d
	...s TPlanDR=SourceID
	...s TPlan=$p($g(^DHCEQMaintPlan(SourceID)),"^",1)
	..q:(vPlanDR'="")&&(TPlanDR'=vPlanDR)
	..q:(vPlan'="")&&(TPlan'[vPlan)
 	..s EQRowID=0
 	..f  s EQRowID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,SourceID,EQRowID))  q:EQRowID=""  d
 	...q:(vEquipDR'="")&&(EQRowID'=vEquipDR)
	...s TEquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	...q:(vEquipNo'="")&&(TEquipNo'=vEquipNo)
	...s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	...q:(vEquipName'="")&&(TEquipName'[vEquipName)
	...s TModelDR = $p($g(^DHCEQEquip(EQRowID)),"^",3)
	...q:(vModelDR'="")&&(TModelDR'=vModelDR)
	...s TEquipTypeDR=$p($g(^DHCEQEquip(EQRowID)),"^",63)
	...s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,CurGroupID)
	...q:+result'=0
 	...s MRowID=0
 	...f  s MRowID=$o(^DHCEQMaint(0,"SourceID",MTTypeDR,SourceID,EQRowID,MRowID))  q:MRowID=""  d
 	....d ResetMaintAndInspectDetail
 	....s InvalidFlag=$p($g(^DHCEQMaint(MRowID)),"^",39)
 	....q:InvalidFlag="Y"
 	....s TMaintTypeDR=$p($g(^DHCEQMaint(MRowID)),"^",4)
	....q:(vMaintTypeDR'="")&&(TMaintTypeDR'=vMaintTypeDR)	
 	....s TMaintLoc=$p($g(^DHCEQMaint(MRowID)),"^",6)
	....q:(vMaintLocDR'="")&&(TMaintLoc'=vMaintLocDR)
	....s TUseLoc=$p($g(^DHCEQMaint(MRowID)),"^",12)
	....q:(vUseLocDR'="")&&(TUseLoc'=vUseLocDR)	
	....s TMaintUser=$p($g(^DHCEQMaint(MRowID)),"^",7)
	....q:(vMaintUserDR'="")&&(TMaintUser'=vMaintUserDR)
	....s TMeasureFlag=$p($g(^DHCEQMaint(MRowID)),"^",30)
	....q:(vMeasureFlag'="")&&(TMeasureFlag'=vMeasureFlag)
	....s TStatus=$p($g(^DHCEQMaint(MRowID)),"^",13)
	....q:(vStatusDR'="")&&(TStatus'=vStatusDR)
	....s TAuditDate=$p($g(^DHCEQMaint(MRowID)),"^",19)
 	....q:((BeginDate'="")&&(TAuditDate<BeginDate))
 	....q:((EndDate'="")&&(TAuditDate>EndDate))
	....s TAuditYear=+$E($ZD(TAuditDate,3),1,4)
 	....q:((vFromYear'="")&&(TAuditYear<vFromYear))
 	....q:((vToYear'="")&&(TAuditYear>vToYear))
	....s TUseLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TUseLoc)
	....q:(vUseLoc'="")&&(TUseLoc'[vUseLoc)
	....s TMaintLoc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TMaintLoc)
	....q:(vMaintLoc'="")&&(TMaintLoc'[vMaintLoc)
	....s TBussTypeDR=MTTypeDR
	....s TMaintModeDR=$p($g(^DHCEQMaint(MRowID)),"^",8)
	....s TBussType=$CASE(MTTypeDR,"1":"保养","2":"检查","3":"维修","":"")
	....i TMaintTypeDR'="" s TMaintType=$p($g(^DHCEQCCode("DHCEQCMaintType",TMaintTypeDR)),"^",2)
	....i TMaintModeDR'="" s TMaintMode=$p($g(^DHCEQCCode("DHCEQMCMaintMode",TMaintModeDR)),"^",2)   //modify by lmm 2020-04-27 1292923
	....s TEquipDR=EQRowID
	....s TEquipNo=$p($g(^DHCEQEquip(EQRowID)),"^",71)
	....s TEquipName=$p($g(^DHCEQEquip(EQRowID)),"^",1)
	....s TModelDR = $p($g(^DHCEQEquip(EQRowID)),"^",3)
	....s TMaintNum=1
	....s TMaintFee=$p($g(^DHCEQMaint(MRowID)),"^",24)
	....s TAmountFee=$p($g(^DHCEQMaint(MRowID)),"^",9)
	....i SourceID'=0  d
	.....s TPlanDR=SourceID
	.....s TPlan=$p($g(^DHCEQMaintPlan(SourceID)),"^",1)
	....s TMaintDate=$p($g(^DHCEQMaint(MRowID)),"^",5)
	....s TRemark=$p($g(^DHCEQMaint(MRowID)),"^",14)
	....i MTTypeDR=1  d
	.....s TMeasureDept=$p($g(^DHCEQMaint(MRowID)),"^",35)		//检查31保养35
	.....s TMeasureDept=##Class(web.DHCEQCommon).GetTrakNameByID("cservice",TMeasureDept)
	.....s TMeasureUsers=$p($g(^DHCEQMaint(MRowID)),"^",38)		//检查34保养38
	.....s TMeasureHandler=$p($g(^DHCEQMaint(MRowID)),"^",36)	//检查32保养36
	.....s TMeasureTel=$p($g(^DHCEQMaint(MRowID)),"^",37)		//检查33保养37
	....i MTTypeDR=2  d
	.....s TMeasureDept=$p($g(^DHCEQMaint(MRowID)),"^",31)		//检查31保养35
	.....i TMeasureDept'="" s TMeasureDept=$p($g(^DHCEQCCode("DHCEQCMeasureDept",TMeasureDept)),"^",1)
	.....s TMeasureUsers=$p($g(^DHCEQMaint(MRowID)),"^",34)		//检查34保养38
	.....s TMeasureHandler=$p($g(^DHCEQMaint(MRowID)),"^",32)	//检查32保养36
	.....s TMeasureTel=$p($g(^DHCEQMaint(MRowID)),"^",33)		//检查33保养37
	....s TAuditTime=$p($g(^DHCEQMaint(MRowID)),"^",20)
	....s TMaintDate=##Class(web.DHCEQCommon).TransValueToPage(TMaintDate,"date")
	....s TAuditDate=##Class(web.DHCEQCommon).TransValueToPage(TAuditDate,"date")
	....s TAuditTime=##Class(web.DHCEQCommon).TransValueToPage(TAuditTime,"time")
	....s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"审核","":"")
	....s TMaintFee=##Class(web.DHCEQCommon).FormatNumber(TMaintFee)
	....s TAmountFee=##Class(web.DHCEQCommon).FormatNumber(TAmountFee)
	....s TUseLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TUseLoc,"-")
	....s TMaintLoc=##class(web.DHCEQCommon).GetSplitDataByFlag(TMaintLoc,"-")
	....s TMaintUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUser)
 	....d OutPutMaintAndInspectDetail
 	....i YearFlag=0  d		;年度查询时年度条件为空时默认显示3年内数据
 	.....s YearFlag=1
 	.....s CurYear=+$E($ZD(+$H,3),1,4)
 	.....s CurFromYear=+vFromYear
 	.....s CurToYear=+vToYear
 	.....i vFromYear="" s CurFromYear=CurYear-3
 	.....i vToYear="" s CurToYear=CurYear
 	.....s Year=0
 	.....f Year=CurFromYear:1:CurToYear  d
 	......s TAuditYear=Year
 	......s (TMaintNum,TMaintFee,TAmountFee)=0
 	......d OutPutMaintAndInspectDetail
 	
 	
	Quit $$$OK
OutPutMaintAndInspectDetail
	s Data=$lb(TBussTypeDR,TBussType,TMaintTypeDR,TMaintType,TMaintModeDR,TMaintMode,TMaintLoc,TUseLoc,TEquipDR,TEquipNo,TEquipName,TMaintUser,TMaintNum,TMaintFee,TAmountFee,TPlan,TPlanDR,TMaintDate,TRemark,TMeasureDept,TMeasureUsers,TMeasureHandler,TMeasureTel,TMeasureFlag,TAuditYear,TStatus,TAuditDate,TAuditTime)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetMaintAndInspectDetail
	s (TBussTypeDR,TBussType,TMaintTypeDR,TMaintType,TMaintModeDR,TMaintMode,TMaintLoc,TUseLoc,TEquipDR,TEquipNo,TEquipName,TMaintUser,TMaintNum,TMaintFee,TAmountFee,TPlan,TPlanDR,TMaintDate,TRemark,TMeasureDept,TMeasureUsers,TMeasureHandler,TMeasureTel,TMeasureFlag,TAuditYear,TStatus,TAuditDate,TAuditTime)=""
	quit
}

ClassMethod MaintAndInspectDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = MaintAndInspectDetailExecute ]
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

ClassMethod MaintAndInspectDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = MaintAndInspectDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// 20190215	Mozy0219	入参vIncludeFinishDR:	Y:包含已完成的业务单	其他:不包含已完成的业务单
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintStatisticsAnaly","GetBussProcessStat")
Query GetBussProcessStat(vBussTypeIDs As %String = "", vLocDR As %String = "", vMaintUserDR As %String = "", vActionDR As %String = "", vStatus As %String = "", vStartDate As %String = "", vEndDate As %String = "", vEquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", QXType As %String = "", CurHospID As %String = "", CurUserID As %String = "", vIncludeFinishDR As %String = "Y") As %Query(ROWSPEC = "TBussType:%String,TMRRowID:%String,TLocDesc:%String,TEQNo:%String,TEQName:%String,TMaintUser:%String,TAction:%String,TStatus:%String,TNum:%String,TMaintFee:%String,TOtherFee:%String,TTotalFee:%String,TEquipType:%String,TRequestDate:%String,TActionDR:%String") [ SqlProc ]
{
}

ClassMethod GetBussProcessStatExecute(ByRef qHandle As %Binary, vBussTypeIDs As %String = "", vLocDR As %String = "", vMaintUserDR As %String = "", vActionDR As %String = "", vStatus As %String = "", vStartDate As %String = "", vEndDate As %String = "", vEquipTypeDR As %String = "", CurGroupID As %String = "", CurLocID As %String = "", QXType As %String = "", CurHospID As %String = "", CurUserID As %String = "", vIncludeFinishDR As %String = "Y") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	s BeginDate=0
 	s EndDate=+$H
 	;i vStartDate'="" s BeginDate=$ZDH(vStartDate,3)
 	;i vEndDate'="" s EndDate=$ZDH(vEndDate,3)
 	;日期格式统一调整
 	s BeginDate=##Class(web.DHCEQCommon).TransValueFromPage(vStartDate,"date")
 	s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(vEndDate,"date")
 	s index=1
 	s MRStatus=""
 	f  s MRStatus=$o(^DHCEQMMaintRequest(0,"Status",MRStatus))  q:MRStatus=""  d
 	.q:(vStatus'="")&&(MRStatus'=vStatus)
 	.q:(vIncludeFinishDR'="Y")&&(MRStatus=2)
 	.q:MRStatus=3     //add by jyp 2020-03-12 JYP0023
 	.s MRRowID=0
 	.f  s MRRowID=$o(^DHCEQMMaintRequest(0,"Status",MRStatus,MRRowID))  q:MRRowID=""  d
 	..d ResetGetBussProcessStat
 	..s TBussType="维修"
 	..s TMRRowID=MRRowID
 	..s MRInvalidFlag=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",57)
 	..q:MRInvalidFlag="Y"
 	..s SourceTypeDR=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",63)
 	..s TExObjDR = $p($g(^DHCEQMMaintRequest(MRRowID)),"^",5)
 	..i TExObjDR'=""  d
 	...i (SourceTypeDR=1)||(SourceTypeDR=2)  d		//Modify By DJ 2019-06-06
 	....s TExObjDR=$p($g(^DHCEQMExObj(TExObjDR)),"^",5)
 	....i TExObjDR'=""  d
 	.....s TEQNo=$p($g(^DHCEQEquip(TExObjDR)),"^",71)			//设备编号
 	.....s TEQName=$p($g(^DHCEQEquip(TExObjDR)),"^",1)			//设备名称
 	...;e  i SourceTypeDR=2  d   //add by zx 2016-06-15 
 	...;.s TEQName=$p($g(^DHCEQCCode("DHCEQCMasterItem",TExObjDR)),"^",1)
 	...e  d
 	....s TEQName=$p($g(^DHCEQMExObj(TExObjDR)),"^",1)
 	..s TEquipType=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",3)			//设备类组
 	..q:((vEquipTypeDR'="")&&(TEquipType'=vEquipTypeDR))
 	..;s result=##class(web.DHCEQCommon).EquipTypeIsIn(TEquipType,CurGroupID)
 	..;q:+result'=0
	..s TLocDesc=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",6)				//使用科室
	..q:(vLocDR'="")&&(TLocDesc'=vLocDR)
 	..s TMaintUser=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",26)			//维修人员
 	..q:(vMaintUserDR'="")&&(TMaintUser'=vMaintUserDR)
 	..s TActionDR=$o(^DHCEQApproveList(0,"Source","25",MRRowID,""),-1)
 	..i ((TActionDR="")||(MRStatus=0)) s TActionDR="-1"
 	..i TActionDR'="-1" s TActionDR=$p($g(^DHCEQApproveList(TActionDR)),"^",11)
 	..q:(vActionDR'="")&&(TActionDR'=vActionDR)
 	..s TStatus=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",41)
 	..q:(vStatus'="")&&(TStatus'=vStatus)
 	..s TRequestDate=$p($g(^DHCEQMMaintRequest(MRRowID)),"^",18)
 	..q:(BeginDate'="")&&(TRequestDate<BeginDate)
 	..q:(EndDate'="")&&(TRequestDate>EndDate)
 	..s TNum="1"
 	..s TStatus=$CASE(TStatus,"0":"新增","1":"提交","2":"审核","":"")
 	..;i TRequestDate'="" s TRequestDate=$ZD(TRequestDate,3)
 	..;日期格式统一调整
 	..s TRequestDate=##Class(web.DHCEQCommon).TransValueToPage(TRequestDate,"date")
 	..s TLocDesc=##Class(web.DHCEQCommon).GetTrakNameByID("dept",TLocDesc)
 	..s TLocDesc=##class(web.DHCEQCommon).GetSplitDataByFlag(TLocDesc,"-")
 	..i TMaintUser'="" s TMaintUser=##Class(web.DHCEQCommon).GetTrakNameByID("user",TMaintUser)
 	..i TMaintUser="" s TMaintUser="[未分配]"
 	..s TMaintFee=$fn($p($g(^DHCEQMMaintRequest(MRRowID)),"^",58),"",2)			//人工费
 	..s TOtherFee=$fn($p($g(^DHCEQMMaintRequest(MRRowID)),"^",59),"",2)			//配件总费用
 	..s TTotalFee=$fn($p($g(^DHCEQMMaintRequest(MRRowID)),"^",60),"",2)			//维修总费用
 	..s TEquipType=##Class(web.DHCEQCommon).GetTrakNameByID("equiptype",TEquipType)
 	..i TActionDR="-1" s TAction="新增"
 	..i TActionDR="0" s TAction="提交"
 	..i TActionDR>0  d
 	...s TAction=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",2)
 	...s TActionSort=$p($g(^DHCEQCCode("DHCEQCAction",TActionDR)),"^",3)
 	...i TActionSort'="" s TActionDR=TActionSort
	..i MRStatus=2  d
	...s TActionDR=99
	...s TAction="处理完成"
 	..d OutputGetBussProcessStat
	
	Quit $$$OK
	
OutputGetBussProcessStat
   s Data=$lb(TBussType,TMRRowID,TLocDesc,TEQNo,TEQName,TMaintUser,TAction,TStatus,TNum,TMaintFee,TOtherFee,TTotalFee,TEquipType,TRequestDate,TActionDR)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetGetBussProcessStat
	s (TBussType,TMRRowID,TLocDesc,TEQNo,TEQName,TMaintUser,TAction,TStatus,TNum,TMaintFee,TOtherFee,TTotalFee,TEquipType,TRequestDate,TActionDR)=""
	quit
}

ClassMethod GetBussProcessStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBussProcessStatExecute ]
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

ClassMethod GetBussProcessStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBussProcessStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)

	Quit $$$OK
}

/// Mozy	2018-1-3
/// 入参UserType:	维修组类型
/// w ##Class(web.DHCEQM.DHCEQMMaintStatisticsAnaly).GetEngineerStage()
ClassMethod GetEngineerStage(UserType As %String = "1")
{
	s Job=$Job
	s (UserList,QtyList,TotalFeeList,TotalISFeeList,TotalMSFeeList,MaintNumList,TotalWorkHourList)=""
	s CurYearDate=$p($zd($h),"/",3)
	s CurYearDate=$zdh(CurYearDate_"-01-01",3)	;本年度元旦
	
	k ^TempDHCEQ("EQUser",Job)
	s growid=0
	f  s growid=$o(^DHCEQCCode("DHCEQMCMaintGroup",growid)) quit:growid=""  d
	.q:$p($g(^DHCEQCCode("DHCEQMCMaintGroup",growid)),"^",9)'="N"
	.q:$p($g(^DHCEQCCode("DHCEQMCMaintGroup",growid)),"^",1)'=UserType
	.
	.s rowid=0
	.f  s rowid=$o(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintGroup",growid,rowid)) q:rowid=""  d
	..q:$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",6)'="N"
	..s userid=$p($g(^DHCEQCCode("DHCEQMCMaintGroupList",rowid)),"^",2)
	..s userdata=$g(^SSU("SSUSR",userid))
	..q:userdata=""
	..
	..s initials=$p(userdata,"^",1)
	..s username=$p(userdata,"^",2)
	..s userloc=$p(userdata,"^",4)
	..q:$d(^TempDHCEQ("EQUser",Job,$ZCONVERT(initials,"U"),userid))
	..quit:##Class(web.DHCEQCommon).HospitalIsInclude(userloc)=0
	..q:'$d(^DHCEQCCode("DHCEQMCMaintGroupList",0,"MaintMember","N",userid))		;过滤非维修组成员
	..
	..s ^TempDHCEQ("EQUser",Job,##class(web.DHCEQCHanZiEncoding).GetEncoding(username,4,"","U"),userid)=username_":"_initials
	
	s username=""
	f  s username=$o(^TempDHCEQ("EQUser",Job,username)) q:username=""  d
	.s userid=0
	.f  s userid=$o(^TempDHCEQ("EQUser",Job,username,userid)) q:userid=""  d
	..s initials=$g(^TempDHCEQ("EQUser",Job,username,userid))
	..i UserList'="" s UserList=UserList_"^"
	..s UserList=UserList_userid_":"_initials
	..
	..d GetManageEquipInfo
	..s QtyList=QtyList_Qty
	..s QtyList=QtyList_"^"
	..
	..s TotalFeeList=TotalFeeList_##Class(web.DHCEQCommon).FormatNumber(TotalFee,"")
	..s TotalFeeList=TotalFeeList_"^"
	..
	..d GetAccessoryData
	..s TotalISFeeList=TotalISFeeList_##Class(web.DHCEQCommon).FormatNumber(TotalInStockFee,"")
	..s TotalISFeeList=TotalISFeeList_"^"
	..
	..s TotalMSFeeList=TotalMSFeeList_##Class(web.DHCEQCommon).FormatNumber(TotalAMoveStockFee,"")
	..s TotalMSFeeList=TotalMSFeeList_"^"
	..
	..d GetMaintData
	..s MaintNumList=MaintNumList_MaintNum
	..s MaintNumList=MaintNumList_"^"
	..
	..s TotalWorkHourList=TotalWorkHourList_##Class(web.DHCEQCommon).FormatNumber(TotalWorkHour,"")
	..s TotalWorkHourList=TotalWorkHourList_"^"
	
	k ^TempDHCEQ("EQUser",Job)
	
	s EngineerStageData=UserList_"&"_QtyList_"&"_TotalFeeList_"&"_TotalISFeeList_"&"_TotalMSFeeList_"&"_MaintNumList_"&"_TotalWorkHourList
	q EngineerStageData
	
GetManageEquipInfo
	;统计工程师管理设备数量及总值
	s Qty=0
	s TotalFee=0
	
	s TStoreLocDR = 0
	f  s TStoreLocDR=$o(^DHCEQEquip("0","StoreInStock",TStoreLocDR)) quit:TStoreLocDR=""  d
	.s TEquipTypeDR = 0
	.f  s TEquipTypeDR=$o(^DHCEQEquip("0","StoreInStock",TStoreLocDR,TEquipTypeDR)) quit:TEquipTypeDR=""  d
	..s ISLRowID=""
	..f  s ISLRowID=$o(^DHCEQEquip("0","StoreInStock",TStoreLocDR,TEquipTypeDR,1,"N",ISLRowID)) quit:ISLRowID=""  d
	...s TEquipID=0
	...f  s TEquipID=$o(^DHCEQEquip("0","StoreInStock",TStoreLocDR,TEquipTypeDR,1,"N",ISLRowID,TEquipID)) quit:TEquipID=""  d
	....s EQGlobal=$Get(^DHCEQEquip(TEquipID))
	....q:$p(EQGlobal,"^",38)>2
	....q:$p(EQGlobal,"^",93)=2	;THold8		 过滤预报废设备
	....s TStatCatDR = $p(EQGlobal,"^",75)
	....s TEquiCatDR = $p(EQGlobal,"^",4)
	....s TItemDR = $p(EQGlobal,"^",7)
	....
	....s TGroupID=0
	....f  s TGroupID=$o(^DHCEQCCode("DHCEQCManageLimit","0","User",userid,TGroupID)) quit:TGroupID=""  d
	.....q:(##Class(web.DHCEQCommon).EquipTypeIsIn(TEquipTypeDR,TGroupID))
	.....s TRoleDR=""
	.....f  s TRoleDR=$o(^DHCEQCCode("DHCEQCManageLimit","0","User",userid,TGroupID,TRoleDR)) quit:TRoleDR=""  d
	......Quit:(##Class(web.DHCEQCommon).CheckManageLimit(userid,TGroupID,TRoleDR,TEquipTypeDR,TStatCatDR,TEquiCatDR,TStoreLocDR,TEquipID,TItemDR))
	......s Qty=Qty+1
	......s TotalFee=TotalFee+$p(EQGlobal,"^",27)
	Quit
GetAccessoryData
	;统计工程师本年度配件入库和出库总额
	s TotalInStockFee=0
	s TotalAMoveStockFee=0
	
	s AuditDate = CurYearDate-1
	f  s AuditDate=$o(^DHCEQAInStock(0,"TypeDate",1,AuditDate)) quit:AuditDate=""  d
	.s AISRowID = 0
	.f  s AISRowID=$o(^DHCEQAInStock(0,"TypeDate",1,AuditDate,AISRowID)) quit:AISRowID=""  d
	..q:$p($g(^DHCEQAInStock(AISRowID)),"^",11)'=userid
	..
	..s AISLRowID=""
	..f  s AISLRowID=$o(^DHCEQAInStockList(0,"AInStock",AISRowID,AISLRowID)) quit:AISLRowID=""  d
	...s TotalInStockFee=TotalInStockFee+$p($g(^DHCEQAInStockList(AISLRowID)),"^",10)
	
	s ASMRowID=""
	f  s ASMRowID=$o(^DHCEQAMoveStock(ASMRowID)) quit:ASMRowID=""  d
	.q:$p($g(^DHCEQAMoveStock(ASMRowID)),"^",17)<CurYearDate
	.q:$p($g(^DHCEQAMoveStock(ASMRowID)),"^",28)'=2
	.q:$p($g(^DHCEQAMoveStock(ASMRowID)),"^",15)'=userid
	.
	.s ASMLRowID=""
	.f  s ASMLRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",ASMRowID,ASMLRowID)) quit:ASMLRowID=""  d
	..s TotalAMoveStockFee=TotalAMoveStockFee+(-1*$p($g(^DHCEQAMoveStockList(ASMLRowID)),"^",12))
	
	Quit
GetMaintData
	;统计工程师本年度维修设备数量和汇总工时
	Set MaintNum=0
	Set TotalWorkHour=0
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQMMaintRequest(rowid))  Quit:rowid=""  Do
	.Quit:$p($g(^DHCEQMMaintRequest(rowid)),"^",57)="Y"
	.;Set TStatus = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",41)
	.;Quit:($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",52)<CurYearDate)	;MR_AuditDate
	.Quit:($Piece($Get(^DHCEQMMaintRequest(rowid)),"^",16)<CurYearDate)		;MR_EndDate
	.Quit:$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",26)'=userid
	.
	.Set MaintNum=MaintNum+1
	.Set TotalWorkHour = TotalWorkHour+$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",39)
	
	Quit
}

/// 维修工程师业务一览
/// Mozy0212	2018-9-29
/// w ##Class(web.DHCEQM.DHCEQMMaintStatisticsAnaly).GetEngineerStat(2547)
ClassMethod GetEngineerStat(UserID As %String = "")
{
	i UserID="" q ""
	;s ^DHCEQMozy("GetEngineerStat")=UserID
	Set Job=$Job
	Kill ^TempDHCEQ("GetEngineerStat",Job)
	
	Set rowid=0
	For  Set rowid=$Order(^DHCEQMMaintRequest(rowid))  Quit:rowid=""  Do
	.Quit:$p($g(^DHCEQMMaintRequest(rowid)),"^",57)="Y"
	.;Set TStatus = $Piece($Get(^DHCEQMMaintRequest(rowid)),"^",41)
	.;Set AuditDate=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",52)			;MR_AuditDate
	.Set EndDate=$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",16)			;MR_EndDate
	.Quit:EndDate=""
	.Quit:$Piece($Get(^DHCEQMMaintRequest(rowid)),"^",26)'=UserID
	.
	.Set Month=$zd(EndDate,3)
	.Set Month=$p(Month,"-",1,2)
	.
	.If '$Data(^TempDHCEQ("GetEngineerStat",Job,Month)) Set ^TempDHCEQ("GetEngineerStat",Job,Month)=0
	.Set ^TempDHCEQ("GetEngineerStat",Job,Month)=1+^TempDHCEQ("GetEngineerStat",Job,Month)
	
	s ASMRowID=""
	f  s ASMRowID=$o(^DHCEQAMoveStock(ASMRowID)) quit:ASMRowID=""  d
	.q:$p($g(^DHCEQAMoveStock(ASMRowID)),"^",28)'=2
	.q:$p($g(^DHCEQAMoveStock(ASMRowID)),"^",15)'=UserID
	.Set EndDate=$Piece($Get(^DHCEQAMoveStock(ASMRowID)),"^",17)			;AMS_AuditDate
	.Set Month=$zd(EndDate,3)
	.Set Month=$p(Month,"-",1,2)
	.
	.If '$Data(^TempDHCEQ("GetEngineerStat",Job,Month)) Set ^TempDHCEQ("GetEngineerStat",Job,Month)=0_"^"_0
	.s ASMLRowID=""
	.f  s ASMLRowID=$o(^DHCEQAMoveStockList(0,"MoveStock",ASMRowID,ASMLRowID)) quit:ASMLRowID=""  d
	..Set $Piece(^TempDHCEQ("GetEngineerStat",Job,Month),"^",2)=+$Piece($Get(^TempDHCEQ("GetEngineerStat",Job,Month)),"^",2)+$p($g(^DHCEQAMoveStockList(ASMLRowID)),"^",12)
	
	Set (MonthList,MaintNumList,TotalMSFeeList)=""
	Set NextMonth=$Order(^TempDHCEQ("GetEngineerStat",Job,""))
	If NextMonth="" Quit ""
	Set LastMonth=$Order(^TempDHCEQ("GetEngineerStat",Job,""),-1)
	Set Flag=0
	DO {
		;WRITE !,NextMonth
		If MonthList'="" Set MonthList=MonthList_"^"
		Set MonthList=MonthList_NextMonth
		
		If NextMonth'=$Order(^TempDHCEQ("GetEngineerStat",Job,"")) Set MaintNumList=MaintNumList_"^"
		Set tmpData=+$Get(^TempDHCEQ("GetEngineerStat",Job,NextMonth))
		Set MaintNumList=MaintNumList_tmpData
		
		If NextMonth'=$Order(^TempDHCEQ("GetEngineerStat",Job,"")) Set TotalMSFeeList=TotalMSFeeList_"^"
		Set tmpData=+$Piece($Get(^TempDHCEQ("GetEngineerStat",Job,NextMonth)),"^",2)
		Set TotalMSFeeList=TotalMSFeeList_tmpData
		
     	If $p(NextMonth,"-",2)=12
     	{
	     	Set NextMonth=$p(NextMonth,"-",1)+1
	     	Set NextMonth=NextMonth_"-01"
     	}
     	else
     	{
	     	Set tmpData=1+$p(NextMonth,"-",2)
	     	If tmpData<10 Set tmpData="0"_tmpData
	     	Set $p(NextMonth,"-",2)=tmpData
    	}
	} WHILE $zdh(NextMonth_"-01",3)<=$zdh(LastMonth_"-01",3)
   
	Kill ^TempDHCEQ("GetEngineerStat",Job)
	s EngineerStat=MonthList_"&"_MaintNumList_"&"_TotalMSFeeList
	q EngineerStat
}

///  MZY0152	3203598		2023-02-06
/// 预防性维护工作完成率
/// d ##class(%ResultSet).RunQuery("web.DHCEQM.DHCEQMMaintStatisticsAnaly","PMExecuteStat","01/05/2022","","","",230,2,4677)
Query PMExecuteStat(StartDate As %String = "", EndDate As %String = "", UserID As %String = "", QXType As %String = "", CurGroupID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Query(ROWSPEC = "Row:%String,MGDR:%String,MGDesc:%String,PEBeginUserDR:%String,PEBeginUser:%String,PEPlanExecuteNo:%String,PERemark:%String,PEBeginDate:%String,MonthStr:%String,PEExecutedNum:%String,PETotalNum:%String") [ SqlProc ]
{
}

ClassMethod PMExecuteStatExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "", UserID As %String = "", QXType As %String = "", CurGroupID As %String = "", CurHospID As %String = "", CurUserID As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	//s ^TEMPMozy("PMExecuteStat")=StartDate_","_EndDate_","_UserID_","_QXType_","_CurGroupID_","_CurHospID_","_CurUserID
	If (StartDate="")&&(EndDate="") Quit $$$OK
	i StartDate="" d
	.s StartDate=0
	e  d
	.s StartDate=##Class(web.DHCEQCommon).TransValueFromPage(StartDate,"date")
	i EndDate="" d
	.s EndDate=+$H
	e  d
	.s EndDate=##Class(web.DHCEQCommon).TransValueFromPage(EndDate,"date")
 	i QXType=2 s UserID=CurUserID
 	
	s Row=0
	s index=1
	
	s MaintPlanDR=0
 	f  s MaintPlanDR=$o(^DHCEQPlanExecute(0,"MaintPlan",MaintPlanDR)) q:MaintPlanDR=""  d
 	.q:$p($g(^DHCEQMaintPlan(MaintPlanDR)),"^",2)'=1
 	.
 	.s PERowID=0
 	.f  s PERowID=$o(^DHCEQPlanExecute(0,"MaintPlan",MaintPlanDR,PERowID)) q:PERowID=""  d
 	..q:$p($g(^DHCEQPlanExecute(PERowID)),"^",6)=2
 	..s PEPlanExecuteNo=$p($g(^DHCEQPlanExecute(PERowID)),"^",1)
 	..s PETotalNum=$p($g(^DHCEQPlanExecute(PERowID)),"^",4)
 	..s PEExecutedNum=$p($g(^DHCEQPlanExecute(PERowID)),"^",5)
 	..s PEBeginDate=$p($g(^DHCEQPlanExecute(PERowID)),"^",7)
 	..q:((StartDate'="")&&(PEBeginDate<StartDate))
 	..q:((EndDate'="")&&(PEBeginDate>EndDate))
 	..s MonthStr=$E($ZD(PEBeginDate,3),1,7)
 	..s PEBeginDate = ##Class(web.DHCEQCommon).TransValueToPage(PEBeginDate,"date")
 	..s PEBeginUserDR=$p($g(^DHCEQPlanExecute(PERowID)),"^",9)
 	..q:(UserID'="")&&(PEBeginUserDR'=UserID)
 	..s PEBeginUser=##Class(web.DHCEQCommon).GetTrakNameByID("user", PEBeginUserDR)
 	..s PERemark=$p($g(^DHCEQPlanExecute(PERowID)),"^",10)
 	..s MaintGroup = ##Class(web.DHCEQMCMaintGroupList).GetMaintGroupByUser(PEBeginUserDR)
	..s MGDR=$p(MaintGroup,"^",1)
	..s MGDesc=$p(MaintGroup,"^",2)
	..q:MGDR=""
 	..
 	..d OutputRowPMExecuteStat
	
	Quit $$$OK
OutputRowPMExecuteStat
	Set Row=Row+1
	Set Data=$lb(Row,MGDR,MGDesc,PEBeginUserDR,PEBeginUser,PEPlanExecuteNo,PERemark,PEBeginDate,MonthStr,PEExecutedNum,PETotalNum)
 	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod PMExecuteStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = PMExecuteStatExecute ]
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

ClassMethod PMExecuteStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = PMExecuteStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
