/// add by ZY0211
Class web.DHCEQ.BA.BUSBenefitSummary Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSBenefitSummary","GetBenefitSummary","")
Query GetBenefitSummary(pYear As %String = "", pUserDR As %String = "") As %Query(ROWSPEC = "BSRowID:%String,BSYear:%String,BSSummary:%String,BSUserDR:%String,BSUserDR_SSUSRName:%String,BSDate:%String,BSStatus:%String,BSStatusdesc:%String,BSHold1:%String,BSHold2:%String,BSHold3:%String,BSHold4:%String,BSHold5:%String") [ SqlProc ]
{
}

ClassMethod GetBenefitSummaryExecute(ByRef qHandle As %Binary, pYear As %String = "", pUserDR As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
 	//if pYear="" quit $$$OK
	s index=1
	s rowid=0
	f  s rowid=$o(^DHCEQBenefitSummary(rowid))  quit:rowid=""  d
	.s (TRowID,TYear,TSummary,TUserDR,TUser,TDate,TStatus,TStatusdesc,THold1,THold2,THold3,THold4,THold5)=""
	.s DataList=$G(^DHCEQBenefitSummary(rowid))
    .s TRowID=rowid
    .q:$p(DataList,"^",15)="Y"
    .s TYear=$p(DataList,"^",1)
    .q:(pYear'="")&&(pYear'=TYear)
    .s TSummary=$p(DataList,"^",2)
    .s TUserDR=$p(DataList,"^",3)
    .q:(pUserDR'="")&&(pUserDR'=UserDR)
    .s TUser=##class(web.DHCEQCommon).GetTrakNameByID("user",TUserDR)
    .s TDate=##class(web.DHCEQCommon).TransValueToPage($p(DataList,"^",4),"date")
    .s TStatus=$p(DataList,"^",5)
    .s TStatusdesc=##class(web.DHCEQCommon).GetEditStatusDisplay(TStatus)
    .s THold1=$p(DataList,"^",16)
    .s THold2=$p(DataList,"^",17)
    .s THold3=$p(DataList,"^",18)
    .s THold4=$p(DataList,"^",19)
    .s THold5=$p(DataList,"^",20)
	.d OutputRowBenefitSummary
	
	quit $$$OK
OutputRowBenefitSummary
	s Data=$lb(TRowID,TYear,TSummary,TUserDR,TUser,TDate,TStatus,TStatusdesc,THold1,THold2,THold3,THold4,THold5)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBenefitSummaryFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitSummaryExecute ]
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

ClassMethod GetBenefitSummaryClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitSummaryExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSBenefitSummary","GetBenefitSummaryList","","")
Query GetBenefitSummaryList(RowID As %String = "", Year As %String = "") As %Query(ROWSPEC = "UCRowID:%String,UCBenefitSummaryDR:%String,UCEquipDR:%String,UCTotalScore:%String,UCBenefitAnalysis:%String,UCUseEvaluation:%String,UCBriefEvaluation:%String,UCOverallEvaluation:%String,UCEquip:%String") [ SqlProc ]
{
}

ClassMethod GetBenefitSummaryListExecute(ByRef qHandle As %Binary, RowID As %String = "", Year As %String = "") As %Status
{
 	new repid, index,rowid
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s Status=""
	i RowID'="" d
	.s Year=$p($G(^DHCEQBenefitSummary(RowID)),"^",1)
	.s Status=$p($G(^DHCEQBenefitSummary(RowID)),"^",5)
	//i (RowID="")&&(Year="") s Year=$p($ZD($h,3),"-",1)
	i Year="" quit $$$OK
 	s EquipID=0
 	f  s EquipID=$o(^DHCEQBenefitEquipList(0,"Equip",EquipID)) q:EquipID=""  d
 	.s (TEquipDR,TInitYear,TPreWorkLoad,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5)=""
 	.s TEquipDR=EquipID
    .//设备基本信息
    .s EquipData=$g(^DHCEQEquip(TEquipDR))
    .s TEquip=$p(EquipData,"^",1)
	.s TModel = ##class(web.DHCEQCommon).GetTrakNameByID("model",$p(EquipData,"^",3))
	.s TLeaveFactoryNo = $p(EquipData,"^",10)
	.s TUseLoc = ##class(web.DHCEQCommon).GetTrakNameByID("dept",$p(EquipData,"^",19))
	.s TOriginalFee =##Class(web.DHCEQCommon).FormatNumber($p(EquipData,"^",27),"1") 
	.s TLimitYearsNum = $p(EquipData,"^",31)
	.s TStartDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",44),"date")
	.s TTransAssetDate = ##class(web.DHCEQCommon).TransValueToPage($p(EquipData,"^",45),"date")
	.s TNo = $p(EquipData,"^",71)
 	.s BELRowID=$o(^DHCEQBenefitEquipList(0,"Equip",EquipID,0))
 	.s BenefitEquipListData=$g(^DHCEQBenefitEquipList(BELRowID))
 	.s TInitYear=$p(BenefitEquipListData,"^",2)
 	.s TPreWorkLoad=$p(BenefitEquipListData,"^",3)
 	.s TNewFunction=$p(BenefitEquipListData,"^",4)
 	.s TSpecialService=$p(BenefitEquipListData,"^",5)
 	.s TOtherSocial=$p(BenefitEquipListData,"^",6)
 	.s TGraduateNum=$p(BenefitEquipListData,"^",7)
 	.s TStaffNum=$p(BenefitEquipListData,"^",8)
 	.s TOtherTasks=$p(BenefitEquipListData,"^",9)
 	.s THold1=$p(BenefitEquipListData,"^",10)
 	.s THold2=$p(BenefitEquipListData,"^",11)
 	.s THold3=$p(BenefitEquipListData,"^",12)
 	.s THold4=$p(BenefitEquipListData,"^",13)
 	.s THold5=$p(BenefitEquipListData,"^",14)
 	.
 	.s (UseContextData,TRowID,TExpectedSatis,TActualSatis,TPatientSatis,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime)=""
 	.s (TBenefitSummaryDR,TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TUCHold1,TUCHold2,TUCHold3,TUCHold4,TUCHold5)=""
 	.
 	.s TRowID=$o(^DHCEQUseContext(0,"EquipYearMonth",EquipID,Year,0,0))
 	.
 	.i TRowID '="" d
 	..s UseContextData=$g(^DHCEQUseContext(TRowID))
 	..q:$p(UseContextData,"^",44)="Y"
 	..q:$p(UseContextData,"^",45)'="2"
 	..q:(Status=2)&&($p(UseContextData,"^",1)'=RowID)
 	..s TBenefitSummaryDR=$p(UseContextData,"^",1)
 	..s TExpectedSatis=$p(UseContextData,"^",5)
 	..s TActualSatis=$p(UseContextData,"^",6)
 	..s TPatientSatis=$p(UseContextData,"^",7)
 	..i TNewFunction="" s TNewFunction=$p(UseContextData,"^",8)
 	..i TSpecialService="" s TSpecialService=$p(UseContextData,"^",9)
 	..i TOtherSocial="" s TOtherSocial=$p(UseContextData,"^",10)
 	..i TGraduateNum="" s TGraduateNum=$p(UseContextData,"^",11)
 	..i TStaffNum="" s TStaffNum=$p(UseContextData,"^",12)
 	..i TOtherTasks="" s TOtherTasks=$p(UseContextData,"^",13)
 	..s TTotalScore=+$p(UseContextData,"^",14)
 	..s TBenefitAnalysis=$p(UseContextData,"^",15)
 	..s TUseEvaluation=$p(UseContextData,"^",16)
 	..s TBriefEvaluation=$p(UseContextData,"^",17)
 	..s TOverallEvaluation=$p(UseContextData,"^",18)
 	..s TIncome=$p(UseContextData,"^",19)
 	..s TPersonTime=$p(UseContextData,"^",20)
 	..s TActualWorkLoad=$p(UseContextData,"^",21)
 	..s TPositiveCases=$p(UseContextData,"^",22)
 	..s TRunTime=$p(UseContextData,"^",23)
 	..s TFailureTimes=$p(UseContextData,"^",24)
 	..s TMaintTimes=$p(UseContextData,"^",25)
 	..s TPMTimes=$p(UseContextData,"^",26)
 	..s TDetectionTimes=$p(UseContextData,"^",27)
 	..s TWaitingTimes=$p(UseContextData,"^",28)
 	..s TAverageWorkHour=$p(UseContextData,"^",29)
 	..s TActualWorkDays=$p(UseContextData,"^",30)
 	..s TFailureDays=$p(UseContextData,"^",31)
 	..s TUCHold1=$p(UseContextData,"^",46)
 	..s TUCHold2=$p(UseContextData,"^",47)
 	..s TUCHold3=$p(UseContextData,"^",48)
 	..s TUCHold4=$p(UseContextData,"^",49)
 	..s TUCHold5=$p(UseContextData,"^",50)
	..d OutputRowBenefitSummaryList
 	
	quit $$$OK
OutputRowBenefitSummaryList
	s Data=$lb(TRowID,TBenefitSummaryDR,TEquipDR,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TEquip)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBenefitSummaryListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitSummaryListExecute ]
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

ClassMethod GetBenefitSummaryListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitSummaryListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// 描述：根据参数rowid取出表中的信息
/// 访问表:DHC_EQBenefitSummary
/// Modified by CSY  2017-08-24
/// w ##Class(web.DHCEQ.BA.BUSBenefitSummary).GetOneBenefitSummary(1)
ClassMethod GetOneBenefitSummary(RowID As %Library.String = "")
{
	s $ZT="ERRORGetOneSummary"
	s ObjSummary=##Class(User.DHCEQBenefitSummary).%OpenId(RowID)
	s BenefitSummary=##Class(web.DHCEQ.Lib.Common).GetJsonTableRecord(ObjSummary)
	d BenefitSummary.%Set("BSRowID",RowID)
	d BenefitSummary.%Set("BSUserDR_SSName",##class(web.DHCEQCommon).GetTrakNameByID("user",ObjSummary.BSUserDR))
	
	q ##Class(web.DHCEQ.Lib.Common).ReturnJson(0,BenefitSummary)
ERRORGetOneSummary
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Lib.Common).ReturnJson("-1000",ErrorMsg)
}

/// 新增或更新
/// rowid为空新增,不为空则是更新
/// Modified by CSY  2017-08-24
/// w ##Class(web.DHCEQ.BA.BUSBenefitSummary).SaveData("1^2017^测试^1^2017-08-24^^^^^",0)
ClassMethod SaveData(data, dataList As %String = "", del As %String = "")
{
	s $ZT="ERRORSave"
	k PLIST,RowID
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
	s Date=+$H
	s Time=$p($H,",",2)
	TSTART
	if del=1
	{
		s RowID=data
		&SQL(Update SQLUSER.DHC_EQBenefitSummary set BS_InvalidFlag='Y' where BS_RowID = :RowID)
		s RowID=""
	}
	else
	{
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(data)
	    s PLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBenefitSummary",JsonData,.PLIST)
		s RowID = JsonData.BSRowID
		s PLIST(6) = "0"	;Status
	 	s PLIST(7) = User	;UserDR
	 	s PLIST(8) = Date	;RDate
	 	s PLIST(9) = Time	;Date
		s PLIST(16) = "N"
	    if RowID'=""
	    {
			&SQL(Update SQLUSER.DHC_EQBenefitSummary Values :PLIST() where BS_RowID = :RowID)
		}
		else
		{
			&SQL(insert into SQLUSER.DHC_EQBenefitSummary Values :PLIST())
			s RowID=$g(%ROWID)
		}
		i SQLCODE
		{
			TROLLBACK
			q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",SQLCODE)
		}
		k MXPLIST
		s UCRowIDs=""
		Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-07-24 分隔符号处理
		s Length=$L(dataList,SplitRowCode)
		for i=1:1:Length
		{
			q:SQLCODE'=0
			s valList=	$p(dataList,SplitRowCode,i)  //add by zx 2019-07-24 分隔符号处理
			q:valList=""
			k MXPLIST,UCRowID
			s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
			s MXPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQUseContext",JsonData,.MXPLIST)
			s Opt = JsonData.Opt
			i Opt="Y"  d
			.s MXPLIST(2)=RowID
			e  d
			.s MXPLIST(2)=""
			s UCRowID = JsonData.UCRowID
			i UCRowID'=""
			{
				&SQL(Update SQLUSER.DHC_EQUseContext Values :MXPLIST() where UC_RowID = :UCRowID)
			}
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
	
ERRORSave
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

/// 提交
/// w ##Class(web.DHCEQ.BA.BUSBenefitSummary).SubmitData(2,1)
ClassMethod SubmitData(RowID)
{
	n rowid,Date,Time,InvalidFlag
    k PLIST
	s User=##Class(web.DHCEQCommon).getMapIDBySource("user",%session.Get("LOGON.USERID"))
    s Date=+$H
    s Time=$p($H,",",2)
    i RowID'=""
 	{
	 	s InvalidFlag=$Piece($G(^DHCEQBenefitSummary(RowID)),"^",15)
	 	i InvalidFlag="Y" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","无效单据")
 	}
	;Status该记录状态不符合,不能执行操作!
	if $p($g(^DHCEQBenefitSummary(RowID)),"^",5)'="0" q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300","状态不对")
	 s PLIST(6) = "2"	    ;Status
	 s PLIST(10) = User	    ;SubmitUserDR
	 s PLIST(11) = Date	    ;SubmitDate
	 s PLIST(12) = Time		;SubmitTime 
	 &SQL(Update SQLUSER.DHC_EQBenefitSummary Values :PLIST() where BS_RowID = :RowID)
	 i SQLCODE=100 s SQLCODE=0
	 q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,RowID)
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQ.BA.BUSBenefitSummary","GetBenefitItemInfo","2")
Query GetBenefitItemInfo(UseContextDR As %String = "") As %Query(ROWSPEC = "BIIBenefitItemDR:%String,BICode:%String,BIDesc:%String,BIMinScore:%String,BIMaxScore:%String,BIRemark:%String,BIInvalidFlag:%String,BIIRowID:%String,BIIScore:%String,BIIResume:%String,BIIRemark:%String")
{
}

ClassMethod GetBenefitItemInfoExecute(ByRef qHandle As %Binary, UseContextDR As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	Set qHandle=$lb(0,repid,0)
	s index=1
	s rowid=0
    f  s rowid=$o(^DHCEQCCode("DHCEQCBenefitItem",rowid))  quit:rowid=""  d
    .s (TRowID,TCode,TDesc,TMinScore,TMaxScore,TRemark,TInvalidFlag,result)=""
    .s TRowID=rowid
    .s result=^DHCEQCCode("DHCEQCBenefitItem",rowid)
    .s TCode=$p(result,"^",1)      //代码描述 
    .s TDesc=$p(result,"^",2)      //描述
    .s TMinScore=$p(result,"^",3)  //最小分值
    .s TMaxScore=$p(result,"^",4)  //最大分值
    .s TRemark=$p(result,"^",5)    //备注
    .s Flag=0
    .s TInvalidFlag=$p(result,"^",6)  //无效标志
    .s TBFIIID=0
    .f  s TBFIIID=$o(^DHCEQBenefitItemInfo(0,"BenefitItemInfo",UseContextDR,TRowID,TBFIIID))  quit:TBFIIID=""  d
   	..s (TBFIScore,TBFIResume,TBFIRemark,TBFIRowID)=""
   	..s TBFIRowID=TBFIIID
    ..s TBFIScore=$p($g(^DHCEQBenefitItemInfo(TBFIIID)),"^",3)  //分数
    ..s TBFIResume=$p($g(^DHCEQBenefitItemInfo(TBFIIID)),"^",4) //简述
    ..s TBFIRemark=$p($g(^DHCEQBenefitItemInfo(TBFIIID)),"^",5) //备注
    ..s Flag=1
	..d OutputRowBenefitItemInfo
	.s (TBFIScore,TBFIResume,TBFIRemark,TBFIRowID)=""
	.i Flag=0  d OutputRowBenefitItemInfo
	quit $$$OK
OutputRowBenefitItemInfo
	s Data=$lb(TRowID,TCode,TDesc,TMinScore,TMaxScore,TRemark,TInvalidFlag,TBFIRowID,TBFIScore,TBFIResume,TBFIRemark)
	Set ^CacheTemp(repid,index)=Data
	Set index=index+1
	quit
}

ClassMethod GetBenefitItemInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBenefitItemInfoExecute ]
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

ClassMethod GetBenefitItemInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBenefitItemInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##Class(web.DHCEQBenefitItemInfo).Save("7^43^5^20^^")
ClassMethod SaveBenefitItemInfo(dataList, UCRowID As %Library.String = "")
{
	new SQLCODE,UCRowIDs,SplitRowCode,Length,valList,JsonData,totalScore
	k MXPLIST
	s SQLCODE=0
	s UCRowIDs=""
	s $ZT="ERRORSaveBenefitItemInfo"
	Set SplitRowCode=##class(web.DHCEQCommon).GetSysInfo("990025")  //add by zx 2019-07-24 分隔符号处理
	s Length=$L(dataList,SplitRowCode)
	TSTART
	for i=1:1:Length
	{
		q:SQLCODE'=0
		s valList=	$p(dataList,SplitRowCode,i)  //add by zx 2019-07-24 分隔符号处理
		q:valList=""
		k MXPLIST,BIIRowID
		s JsonData = ##Class(web.DHCEQ.Plat.LIBCommon).StringToJson(valList)
		s MXPLIST=##Class(web.DHCEQ.Plat.LIBCommon).JsonToPlist("User.DHCEQBenefitItemInfo",JsonData,.MXPLIST)
		s BIIRowID = JsonData.BIIRowID
		s MXPLIST(2)=UCRowID
		i BIIRowID'=""
		{
			&SQL(Update SQLUSER.DHC_EQBenefitItemInfo Values :MXPLIST() where BII_RowID =:BIIRowID)	 
			i SQLCODE=100 s SQLCODE=0
		}
		else
		{
			&SQL(Insert Into SQLUSER.DHC_EQBenefitItemInfo Values :MXPLIST())
		}
	}
	
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",SQLCODE)
	}
	s totalScore=0
	&SQL(select sum(BII_Score) into:totalScore from SQLUSER.DHC_EQBenefitItemInfo  where BII_UseContextDR = :UCRowID)
	&SQL(Update SQLUSER.DHC_EQUseContext set UC_TotalScore=:totalScore where UC_RowID = :UCRowID) 	
	i SQLCODE=100 s SQLCODE=0
	i SQLCODE
	{
		TROLLBACK
		q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",SQLCODE)
	}
	TCOMMIT
	q ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson(0,UCRowID)
	
ERRORSaveBenefitItemInfo
	TROLLBACK
	s ErrorMsg=$ZE
	Quit ##Class(web.DHCEQ.Plat.LIBCommon).ReturnJson("-1300",ErrorMsg)
}

}
