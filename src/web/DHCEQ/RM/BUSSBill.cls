Class web.DHCEQ.RM.BUSSBill Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// Creator：      QW
/// CreatDate：    2020-05-16
/// Description:   获取账单明细或者要生成账单明细
/// Input：        BillDR:账单id
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSSBill","GetRentBillList","","2020-05-01","2020-05-16","00:00","23:59")
Query GetRentBillList(BillDR As %String = "", BillStartDate As %String = "", BillEndDate As %String = "", BillStartTime As %String = "", BillEndTime As %String = "", FromHospitalDR As %String = "", ToHospitalDR As %String = "", ShareType As %String = "") As %Query(ROWSPEC = "BLRowID:%String,BLRentDR:%String,BLFromLocDR:%String,BLRequestLocDR:%String,BLShareType:%String,BLShareItemDR:%String,BLStartDate:%String,BLStartTime:%String,BLEndDate:%String,BLEndTime:%String,BLDuration:%String,BLUomQuantity:%String,BLUOMDR:%String,BLPrice:%String,BLTotalFee:%String,BLCostFee:%String,BLRequestLocDR_DeptDesc:%String,RRequestUserDR:%String,RRequestUserDR_UName:%String,BLShareType_Desc:%String,BLShareItemDR_SIDesc:%String,BLUOMDR_UOMDesc:%String,BLStartDateTime:%String,BLEndDateTime:%String")
{
}

ClassMethod GetRentBillListExecute(ByRef qHandle As %Binary, BillDR As %String = "", BillStartDate As %String = "", BillEndDate As %String = "", BillStartTime As %String = "", BillEndTime As %String = "", FromHospitalDR As %String = "", ToHospitalDR As %String = "", ShareType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if (BillDR="")&&((BillStartDate="")||(BillEndDate="")) QUIT $$$OK
	s BillStartDate=##Class(web.DHCEQCommon).TransValueFromPage(BillStartDate,"date")
	s BillEndDate=##Class(web.DHCEQCommon).TransValueFromPage(BillEndDate,"date")
	s BillStartTime=##Class(web.DHCEQCommon).TransValueFromPage(BillStartTime,"time")
	s BillEndTime=##Class(web.DHCEQCommon).TransValueFromPage(BillEndTime,"time")
	if (BillDR="")
	{
		s RFRentDR=0
		f  s RFRentDR=$o(^DHCEQSRentFee(0,"Rent",RFRentDR)) q:RFRentDR=""  d
		.d ResetVariablesGetRentBillList
		.s TRentDR=RFRentDR
		.s TFromLocDR=$p($g(^DHCEQSRent(TRentDR)),"^",3)  ///Modefied by zc0086 2020-11-11 取值错误修改
		.s TRequestLocDR=$p($g(^DHCEQSRent(TRentDR)),"^",2)  ///Modefied by zc0086 2020-11-11 取值错误修改
		.i TRequestLocDR'="" s TRequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
		.s TRequestUserDR=$p($g(^DHCEQSRent(TRentDR)),"^",4)
		.i TRequestUserDR'="" s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
		.s TShareItemDR=$p($g(^DHCEQSRent(TRentDR)),"^",32)
		.i TShareItemDR'="" d
		..Set TShareItem=$Piece($Get(^DHCEQSCShareItem(TShareItemDR)),"^",3)
		..Set TShareTypeDR=$Piece($Get(^DHCEQSCShareItem(TShareItemDR)),"^",1)
		..Set TShareType=$CASE(TShareTypeDR,"1":"设备","":"")
		.s TStartDate=$p($g(^DHCEQSRent(TRentDR)),"^",10)
		.s TStartTime=$p($g(^DHCEQSRent(TRentDR)),"^",11)
		.q:TStartDate>BillEndDate
		.i BillStartDate>TStartDate d
		..s TStartDate=BillStartDate
		..s TStartTime=BillStartTime
		.s TEndDate=$p($g(^DHCEQSRent(TRentDR)),"^",23)
		.q:(TEndDate'="")&&(TEndDate<BillStartDate)
		.s TEndTime=$p($g(^DHCEQSRent(TRentDR)),"^",24)
		.i TEndDate="" d
		..s TEndDate=BillEndDate
		..s TEndTime=BillEndTime
		.s TStartDateTime=##Class(web.DHCEQCommon).TransValueToPage(TStartDate_","_TStartTime,"datetime")
		.s TEndDateTime=##Class(web.DHCEQCommon).TransValueToPage(TEndDate_","_TEndTime,"datetime")
		.s TDuration=##Class(web.DHCEQ.RM.BUSRent).GetDiffHour(TStartDate,TStartTime,TEndDate,TEndTime)
		.s TPrice=##Class(web.DHCEQ.RM.BUSRent).RentFeeCount(TRentDR)
		.i $p(TPrice,"^",5)="天" s TDuration=##Class(web.DHCEQCommon).FormatNumber(TDuration/24,"")  //Modefied by zc0084 2020-10-14 按天收费调用时长除以24
		.s TPrice=+$p(TPrice,"^",3)
		.s TCostFee=0
		.s TTotalFee=0
		.s RFRowID=0
		.f  s RFRowID=$o(^DHCEQSRentFee(0,"Rent",RFRentDR,RFRowID)) q:(RFRowID="")  d
		..q:$p($g(^DHCEQSRentFee(RFRowID)),"^",3)=0
		..//Modefied by zc0084 2020-10-14 日及清单生成日期与开始日期与结束日期的判断 begin
		..s RMakeDate=$p($g(^DHCEQSRentFee(RFRowID)),"^",3)
		..q:$p($g(^DHCEQSRent(TRentDR)),"^",10)>RMakeDate
		..q:(RMakeDate>BillEndDate)&&(RMakeDate'="")
		..q:(RMakeDate<BillStartDate)&&(RMakeDate'="")
		..//Modefied by zc0084 2020-10-14 日及清单生成日期与开始日期与结束日期的判断 end
		..s TUomQuantity=$p($g(^DHCEQSRentFee(RFRowID)),"^",6)
		..s TUOMDR=$p($g(^DHCEQSRentFee(RFRowID)),"^",7)
		..i TUOMDR'=""  s TUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUOMDR)
		..s TTotalFee=TTotalFee+##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRentFee(RFRowID)),"^",8)*$p($g(^DHCEQSRentFee(RFRowID)),"^",9),"") //Modefied by zc0084 2020-10-14  字符串转换成数值
		..s TCostFee=TCostFee+$p($g(^DHCEQSRentFee(RFRowID)),"^",11)
		.d OutputRowGetRentBillList
	}else{
		s BillListDR=0
		f  s BillListDR=$o(^DHCEQSBillList(0,"Bill",BillDR,BillListDR)) q:BillListDR=""  d
		.d ResetVariablesGetRentBillList
		.s TRowID=BillListDR
		.s TRentDR=$p($g(^DHCEQSBillList(BillListDR)),"^",2)
		.s TFromLocDR=$p($g(^DHCEQSBillList(BillListDR)),"^",4)  ///Modefied by zc0086 2020-11-11 取值错误修改
		.s TRequestLocDR=$p($g(^DHCEQSBillList(BillListDR)),"^",3) ///Modefied by zc0086 2020-11-11 取值错误修改
		.i TRequestLocDR'="" s TRequestLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TRequestLocDR)
		.s TRequestUserDR=$p($g(^DHCEQSRent(TRentDR)),"^",4)
		.i TRequestUserDR'="" s TRequestUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TRequestUserDR)
		.s TShareTypeDR=$p($g(^DHCEQSBillList(BillListDR)),"^",5)
		.s TShareType=$CASE(TShareTypeDR,"1":"设备","":"")
		.Set TShareItemDR=$p($g(^DHCEQSBillList(BillListDR)),"^",6)
		.i TShareItemDR'="" Set TShareItem=$Piece($Get(^DHCEQSCShareItem(TShareItemDR)),"^",3)
		.s TStartDate=$p($g(^DHCEQSBillList(BillListDR)),"^",7)
		.s TStartTime=$p($g(^DHCEQSBillList(BillListDR)),"^",8)
		.s TEndDate=$p($g(^DHCEQSBillList(BillListDR)),"^",9)
		.s TEndTime=$p($g(^DHCEQSBillList(BillListDR)),"^",10)
		.s TStartDateTime=##Class(web.DHCEQCommon).TransValueToPage(TStartDate_","_TStartTime,"datetime")
		.s TEndDateTime=##Class(web.DHCEQCommon).TransValueToPage(TEndDate_","_TEndTime,"datetime")
		.s TDuration=$p($g(^DHCEQSBillList(BillListDR)),"^",11)
		.s TUomQuantity=$p($g(^DHCEQSBillList(BillListDR)),"^",12)
		.s TUOMDR=$p($g(^DHCEQSBillList(BillListDR)),"^",13)
		.i TUOMDR'=""  s TUOM=##class(web.DHCEQCommon).GetTrakNameByID("uom",TUOMDR)
		.s TPrice=$p($g(^DHCEQSBillList(BillListDR)),"^",14)
		.s TTotalFee=$p($g(^DHCEQSBillList(BillListDR)),"^",14)
		.s TCostFee=$p($g(^DHCEQSBillList(BillListDR)),"^",16)
		.d OutputRowGetRentBillList
	}
	Quit $$$OK
OutputRowGetRentBillList
	s Data=$lb(TRowID,TRentDR,TFromLocDR,TRequestLocDR,TShareTypeDR,TShareItemDR,TStartDate,TStartTime,TEndDate,TEndTime,TDuration,TUomQuantity,TUOMDR,TPrice,TTotalFee,TCostFee,TRequestLoc,TRequestUserDR,TRequestUser,TShareType,TShareItem,TUOM,TStartDateTime,TEndDateTime)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRentBillList
	s (TRowID,TRentDR,TFromLocDR,TRequestLocDR,TShareTypeDR,TShareItemDR,TStartDate,TStartTime,TEndDate,TEndTime,TDuration,TUomQuantity,TUOMDR,TPrice,TTotalFee,TCostFee,TRequestLoc,TRequestUserDR,TRequestUser,TShareType,TShareItem,TUOM,TStartDateTime,TEndDateTime)=""
	quit
}

ClassMethod GetRentBillListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentBillListExecute ]
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

ClassMethod GetRentBillListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentBillListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：      QW
/// CreatDate：    2020-05-16
/// Description:   获取账单
/// Input：        BillDR:账单id
/// d ##class(%ResultSet).RunQuery("web.DHCEQ.RM.BUSSBill","GetRentBill","","")
Query GetRentBill(BillStartDate As %String = "", BillEndDate As %String = "", FromHospitalDR As %String = "", ToHospitalDR As %String = "", ShareType As %String = "") As %Query(ROWSPEC = "TBillDR:%String,TBillNo:%String,TFromHospital:%String,TToHospital:%String,TShareType:%String,TStartDate:%String,TEndDate:%String,TPayLoc:%String,TChargeLoc:%String,TTotalFee:%String,TCostFee:%String")
{
}

ClassMethod GetRentBillExecute(ByRef qHandle As %Binary, BillStartDate As %String = "", BillEndDate As %String = "", FromHospitalDR As %String = "", ToHospitalDR As %String = "", ShareType As %String = "") As %Status
{
	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	if (BillStartDate="")||(BillEndDate="") QUIT $$$OK
	s BillStartDate=##Class(web.DHCEQCommon).TransValueFromPage(BillStartDate,"date")
	s BillEndDate=##Class(web.DHCEQCommon).TransValueFromPage(BillEndDate,"date")
	s BillDR=0
	f  s BillDR=$o(^DHCEQSBill(BillDR)) q:BillDR=""  d
	.q:$p($g(^DHCEQSBill(BillDR)),"^",17)="Y" //Modefied by zc0088 2020-12-07 单据查询不到问题处理
	.q:BillStartDate>$p($g(^DHCEQSBill(BillDR)),"^",5)
	.q:BillEndDate<$p($g(^DHCEQSBill(BillDR)),"^",6)
	.d ResetVariablesGetRentBill
	.s TBillDR=BillDR
	.s TBillNo=$p($g(^DHCEQSBill(BillDR)),"^",1)
	.s TFromHospitalDR=$p($g(^DHCEQSBill(BillDR)),"^",2)
	.i TFromHospitalDR'=""  Set TFromHospital=$Piece($Get(^CT("HOSP",TFromHospitalDR)),"^",2)
	.s TToHospitalDR=$p($g(^DHCEQSBill(BillDR)),"^",3)
	.i TToHospitalDR'=""  Set TToHospital=$Piece($Get(^CT("HOSP",TToHospitalDR)),"^",2)
	.s TShareTypeDR=$p($g(^DHCEQSBill(BillDR)),"^",4)
	.i TShareTypeDR'="" s TShareType=$CASE(TShareTypeDR,"1":"设备","":"")
	.s TStartDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSBill(BillDR)),"^",5),"date")
	.s TEndDate=##Class(web.DHCEQCommon).TransValueToPage($p($g(^DHCEQSBill(BillDR)),"^",6),"date")
	.s TPayLocDR=$p($g(^DHCEQSBill(BillDR)),"^",7)
	.i TPayLocDR'="" s TPayLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TPayLocDR)
	.s TChargeLocDR=$p($g(^DHCEQSBill(BillDR)),"^",8)
	.i TChargeLocDR'="" s TChargeLoc=##class(web.DHCEQCommon).GetTrakNameByID("dept",TChargeLocDR)
	.s TTotalFee=$p($g(^DHCEQSBill(BillDR)),"^",9)
	.s TCostFee=$p($g(^DHCEQSBill(BillDR)),"^",10)
	.d OutputRowGetRentBill
	Quit $$$OK
OutputRowGetRentBill
	s Data=$lb(TBillDR,TBillNo,TFromHospital,TToHospital,TShareType,TStartDate,TEndDate,TPayLoc,TChargeLoc,TTotalFee,TCostFee)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
ResetVariablesGetRentBill
	s (TBillDR,TBillNo,TFromHospitalDR,TFromHospital,TToHospitalDR,TToHospital,TShareTypeDR,TShareType,TStartDate,TEndDate,TPayLocDR,TPayLoc,TChargeLocDR,TChargeLoc,TTotalFee,TCostFee)=""
	quit
}

ClassMethod GetRentBillFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRentBillExecute ]
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

ClassMethod GetRentBillClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRentBillExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// MonthStr月份,Type=1返回开始日期,Type=2返回结束日期
/// w ##Class(web.DHCEQ.RM.BUSSBill).GetMonthDate("2008-01",1)
ClassMethod GetMonthDate(MonthStr, Type)
{
	new getdate
	s Year=$P(MonthStr,"-",1)
	s Month=$P(MonthStr,"-",2)
	if (Type=1)
	{
		s getdate=Year_"-"_Month_"-01"
		s getdate=$ZDH(getdate,3)
	}
	else
	{
		if (Month=12)
		{
			s Year=+Year+1
			s Month="1"
		}
		else
		{
			s Month=+Month+1
		}
		s getdate=Year_"-"_Month_"-01"
		s getdate=$ZDH(getdate,3)-1
	}
	q ##Class(web.DHCEQCommon).TransValueToPage(getdate,"date")
}

ClassMethod SaveBill(data, datalist)
{
	s $ZT="ERRORSaveBill"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	k PLIST
	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSBill",JsonData,.PLIST)
	s RowID = JsonData.BRowID
	s PLIST(13) = User					;B_BillMakerDR
	s PLIST(14) = Date					;B_BillMakeDate
	s PLIST(15) = Time					;B_BillMakeTime
	s PLIST(16) = "2"					;B_Status
	s PLIST(18) = "N"					;B_InvalidFlag
	TSTART
    if RowID'=""
    {
		&SQL(Update SQLUSER.DHC_EQSBill Values :PLIST() where B_RowID = :RowID)
	}
	else
	{
		i PLIST(2)="" d
		.s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQSBill",Date,"","","","","")
		
		&SQL(insert into SQLUSER.DHC_EQSBill Values :PLIST())
	}
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 }
	s RowID=$g(%ROWID)
	s SQLCODE=##Class(web.DHCEQ.RM.BUSSBill).SaveBillList(RowID,datalist)
	i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 }
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORSaveBill
	s ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

ClassMethod SaveBillList(BRowID, DataList)
{
	new (BRowID,DataList)
	i BRowID="" q -1
	i DataList="" q 0
	s Flag=0
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")
	s Length=$l(DataList,SplitRowCode)
	for k=1:1:Length
	{
		q:Flag'=0
		s valList=$p(DataList,SplitRowCode,k) 
		q:valList=""
		k PLIST,BLRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSBillList",JsonData,.PLIST)
		s PLIST(2)=BRowID
		s PLIST(18)="N"
		&SQL(insert into SQLUSER.DHC_EQSBillList Values :PLIST())
		i SQLCODE s Flag=SQLCODE

	}
	q Flag
}

ClassMethod GetOneBill(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneBill"
	s ObjBill=##Class(User.DHCEQSBill).%OpenId(RowID)
	s BillInfo=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjBill)
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,BillInfo)
ERRORGetOneBill
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1300",ErrorMsg)
}

// Modefied by zc0084 2020-10-14 租赁日结费用清单保存

/// w ##Class(web.DHCEQ.RM.BUSSBill).SaveBillNew("{""BBillNo"":"""",""BStartDate"":""2020-08-01"",""BStartTime"":""00:00"",""BEndDate"":""2020-09-30"",""BEndTime"":""23:59"",""BillDR"":"""",""BFromHospitalDR"":"""",""BToHospitalDR"":"""",""BShareType"":"""",""BPayLocDR"":"""",""BChargeLocDR"":"""",""BTotalFee"":""71525573730468720"",""BCostFee"":""2640"",""BIsShare"":""N"",""BRemark"":"""",""SplitNumCode"":""$CHAR(4)"",""SplitRowCode"":""$CHAR(3)""}",2)
ClassMethod SaveBillNew(Data, DelIs)
{
	s $ZT="ERRORSaveBillNew"
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$P($H,",",2)
	k PLIST,RowID
	s SQLCODE=0
	TSTART
	if DelIs=1
	{
		s RowID=Data
		&SQL(update SQLUSER.DHC_EQSBill set B_InvalidFlag='Y' where B_RowID=:RowID)
	}
	else
	{
    	s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(Data)
		s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQSBill",JsonData,.PLIST)
		s RowID = JsonData.BRowID
		s BStartDate=JsonData.BStartDate
		s BEndDate=JsonData.BEndDate

		s StartMonth=##Class(web.DHCEQReport).GetReportMonthByDate(##Class(web.DHCEQCommon).TransValueFromPage(BStartDate,"date"))
		s EndMonth=##Class(web.DHCEQReport).GetReportMonthByDate(##Class(web.DHCEQCommon).TransValueFromPage(BEndDate,"date"))
		i StartMonth'=EndMonth Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-3405)
		
		s OldRowID=""
		&SQL(select B_RowID into :OldRowID from sqluser.DHC_EQSBill where B_Hold1=:StartMonth and B_InvalidFlag<>'Y')
		i SQLCODE=100 s SQLCODE=0
		i OldRowID'="" Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(-3406)
		s PLIST(13) = User					;B_BillMakerDR
		s PLIST(14) = Date					;B_BillMakeDate
		s PLIST(15) = Time					;B_BillMakeTime
		s PLIST(16) = "2"					;B_Status
		s PLIST(18) = "N"					;B_InvalidFlag
		s PLIST(19) = StartMonth
		i PLIST(2)="" d
		.s PLIST(2)=##CLASS(web.DHCEQCCounter).GetNextNo("DHC_EQSBill",Date,"","","","","")
			
		&SQL(insert into SQLUSER.DHC_EQSBill Values :PLIST())
		i SQLCODE
		{
			TROLLBACK
			Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 	}
		s RowID=$g(%ROWID)
		s SQLCODE=##Class(web.DHCEQ.RM.BUSSBill).SaveBillListNew(RowID,StartMonth)
	 }
	 i SQLCODE
	{
		TROLLBACK
		Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE)
	 }
	TCOMMIT
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(SQLCODE,RowID)
ERRORSaveBillNew
	s ErrorMsg=$ZE
	TROLLBACK
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

// Modefied by zc0084 2020-10-14 租赁日结费用清单明细保存

ClassMethod SaveBillListNew(BRowID, vMonthStr)
{
	new (BRowID,vMonthStr)
	i BRowID="" q -1
	i vMonthStr="" q 0
	s Flag=0
	s BeginDate=##Class(web.DHCEQReport).GetReportDate(vMonthStr,"1","")
	s EndDate=##Class(web.DHCEQReport).GetReportDate(vMonthStr,"2","")
	k ^DHCEQTemp("SaveBillListNew")
	s TotalFee=0
	s TotalCostFee=0
	s RFRentDR=0
	f  s RFRentDR=$o(^DHCEQSRentFee(0,"Rent",RFRentDR)) q:(RFRentDR="" )||(Flag'=0)  d
	.s RFRowID=0
	.f  s RFRowID=$o(^DHCEQSRentFee(0,"Rent",RFRentDR,RFRowID)) q:(RFRowID="")||(Flag'=0)  d
	..s RMakeDate=$p($g(^DHCEQSRentFee(RFRowID)),"^",3)
	..q:(RMakeDate>EndDate)&&(RMakeDate'="")
	..q:(RMakeDate<BeginDate)&&(RMakeDate'="")
	..s RTotalFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRentFee(RFRowID)),"^",8)*$p($g(^DHCEQSRentFee(RFRowID)),"^",9),"",2)
	..s TotalFee=TotalFee+RTotalFee
	..s RCostFee=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRentFee(RFRowID)),"^",11),"",2)
	..s TotalCostFee=TotalCostFee+RCostFee
	..s RWorkLoad=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSRentFee(RFRowID)),"^",8),"",2)
	..s ^DHCEQTemp("SaveBillListNew",RFRentDR)=""
	..s ^DHCEQTemp("SaveBillListNew",RFRentDR,"RTotalFee")=$g(^DHCEQTemp("SaveBillListNew",RFRentDR,"RTotalFee"))+RTotalFee
	..s ^DHCEQTemp("SaveBillListNew",RFRentDR,"RCostFee")=$g(^DHCEQTemp("SaveBillListNew",RFRentDR,"RCostFee"))+RCostFee
	..s ^DHCEQTemp("SaveBillListNew",RFRentDR,"RWorkLoad")=$g(^DHCEQTemp("SaveBillListNew",RFRentDR,"RWorkLoad"))+RWorkLoad
	
	&SQL(Update SQLUSER.DHC_EQSBill set B_TotalFee=:TotalFee,B_CostFee=:TotalCostFee where B_RowID = :BRowID)
	i SQLCODE s Flag=SQLCODE
	
	s RenID=0
	f  s RenID=$o(^DHCEQTemp("SaveBillListNew",RenID)) q:(RenID="" )||(Flag'=0)  d
	.s RentFee=##Class(web.DHCEQCommon).FormatNumber($g(^DHCEQTemp("SaveBillListNew",RenID,"RTotalFee")),"",2)
	.s RentCostFee=##Class(web.DHCEQCommon).FormatNumber($g(^DHCEQTemp("SaveBillListNew",RenID,"RCostFee")),"",2)
	.s WorkLoad=##Class(web.DHCEQCommon).FormatNumber($g(^DHCEQTemp("SaveBillListNew",RenID,"RWorkLoad")),"",2)
	.s vSHPRowID=$p($g(^DHCEQSRent(RenID)),"^",33)
	.q:vSHPRowID=""
	.s UomQuantity=$p($g(^DHCEQSResourceHistoryPrice(vSHPRowID)),"^",4)
	.s UOMDR=$p($g(^DHCEQSResourceHistoryPrice(vSHPRowID)),"^",5)
	.s Price=##Class(web.DHCEQCommon).FormatNumber($p($g(^DHCEQSResourceHistoryPrice(vSHPRowID)),"^",6),"",2)
	.s PriType=$p($g(^DHCEQSResourceHistoryPrice(vSHPRowID)),"^",2)
	.k NPLIST
	.s NPLIST(2)=BRowID
	.s NPLIST(3)=RenID
	.s NPLIST(4)=$p($g(^DHCEQSRent(RenID)),"^",2)
	.s NPLIST(5)=$p($g(^DHCEQSRent(RenID)),"^",3)
	.s NPLIST(6)="1"
	.s NPLIST(7)=$p($g(^DHCEQSRent(RenID)),"^",32)
	.s NPLIST(8)=$p($g(^DHCEQSRent(RenID)),"^",10)
	.s NPLIST(9)=$p($g(^DHCEQSRent(RenID)),"^",11)
	.s REndDate=$p($g(^DHCEQSRent(RenID)),"^",23)
	.s REndTime=$p($g(^DHCEQSRent(RenID)),"^",24)
	.i REndDate>EndDate d
	..s REndDate=""
	..s REndTime=""
	.s NPLIST(10)=REndDate
	.s NPLIST(11)=REndTime
	.s NPLIST(12)=WorkLoad
	.s NPLIST(13)=UomQuantity
	.s NPLIST(14)=UOMDR
	.s NPLIST(15)=Price
	.s NPLIST(16)=RentFee
	.s NPLIST(17)=RentCostFee
	.s NPLIST(18)="N"
	.&SQL(insert into SQLUSER.DHC_EQSBillList Values :NPLIST())
	.i SQLCODE s Flag=SQLCODE
	.q:Flag'=0
	
	k ^DHCEQTemp("SaveBillListNew")
	
	q Flag
}

}
