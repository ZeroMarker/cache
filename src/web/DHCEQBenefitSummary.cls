Class web.DHCEQBenefitSummary Extends %Library.RegisteredObject [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

/// 新增或更新
/// rowid为空新增,不为空则是更新
/// Modified by CSY  2017-08-24
/// w ##Class(web.DHCEQBenefitSummary).SaveData("1^2017^测试^1^2017-08-24^^^^^",0)
ClassMethod SaveData(val, listval As %String = "", del As %String = "")
{
	n rowid,User,Date,Time,SQLCODE
	k PLIST
	s SQLCODE=0
	s User=1	//%session.Get("LOGON.USERID")
	s Date=+$H
	s Time=$p($H,",",2)
	s rowid=$p(val,"^",1)
	Set $ZT="ERRORSave"
	TSTART
	if +del=1
	{
		i (rowid'="")
		{
			&SQL(Update sqluser.DHC_EQUseContext set UC_BenefitSummaryDR=null where UC_BenefitSummaryDR = :rowid)
			i SQLCODE=100 s SQLCODE=0
			&SQL(Update sqluser.DHC_EQBenefitSummary set BS_InvalidFlag='Y' where BS_RowID = :rowid)
		}
	}
	else
	{
		s PLIST(2)=$P(val,"^",2) 
		s PLIST(3)=$P(val,"^",3)
		s PLIST(4)=$P(val,"^",4)
		i $p(val,"^",5)'="" s PLIST(5)=$ZDH($p(val,"^",5),3) ;##class(web.DHCEQCommon).TransValueFromPage($p(val,"^",5),"date") 
		s PLIST(6)="0"
		s PLIST(16)="N"
		s PLIST(17)=$P(val,"^",6)
		s PLIST(18)=$P(val,"^",7)
		s PLIST(19)=$P(val,"^",8)
		s PLIST(20)=$P(val,"^",9)
		s PLIST(21)=$P(val,"^",10)
		s PLIST(7) = User
		s PLIST(8) = Date
		s PLIST(9) = Time
		i (rowid="")  
		{
			&SQL(Insert Into SQLUSER.DHC_EQBenefitSummary Values :PLIST())
			Set rowid=$g(%ROWID)
		}
		else  
		{
			&SQL(Update SQLUSER.DHC_EQBenefitSummary Values :PLIST() where BS_RowID = :rowid) 
			i SQLCODE=100 s SQLCODE=0
		}
		i SQLCODE
		{
			TROLLBACK
			q SQLCODE
		}
		s Len=$L(listval,"&")
		for i=1:1:Len
		{
			k UCLIST
			q:SQLCODE'=0
			s List=	$p(listval,"&",i)
			s TUCRowID= $p(List,"^",1)
			s UCLIST(2) = rowid				//BenefitSummaryDR
			s UCLIST(15)= $p(List,"^",2)	//TotalScore 
			s UCLIST(18)= $p(List,"^",3)	//BriefEvaluation
			s UCLIST(19)= $p(List,"^",4)	//OverallEvaluation
			&SQL(Update SQLUSER.DHC_EQUseContext Values :UCLIST() where UC_RowID = :TUCRowID) 
			i SQLCODE=100 s SQLCODE=0
		}
	}
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE_"^"_rowid
ERRORSave
	TRollBack	
	Set ErrorMsg=$ZE	     //得到系统返回的错误消息
 	Quit "ERRORSave"_ErrorMsg     //返回错误消息 ;
}

/// 提交
/// Modified by CSY  2017-08-24
/// w ##Class(web.DHCEQBenefitSummary).SubmitData(2,1)
ClassMethod SubmitData(RowID)
{
	n rowid,Date,Time,InvalidFlag
    k PLIST
	s User=1	//%session.Get("LOGON.USERID")
    s Date=+$H
    s Time=$p($H,",",2)
    i RowID'=""
 	{
	 	s InvalidFlag=$Piece($G(^DHCEQBenefitSummary(RowID)),"^",15)
	 	i InvalidFlag="Y" q "-2201^无效单据不能操作!"
 	}
 	else
 	{
	 	q "-2201^没有单据不能操作!"
	}
	;Status该记录状态不符合,不能执行操作!
	if $p($g(^DHCEQBenefitSummary(RowID)),"^",5)'="0" q -2015
	 s PLIST(6) = "2"	    ;Status
	 s PLIST(10) = User	    ;SubmitUserDR
	 s PLIST(11) = Date	    ;SubmitDate
	 s PLIST(12) = Time		;SubmitTime 
	 &SQL(Update SQLUSER.DHC_EQBenefitSummary Values :PLIST() where BS_RowID = :RowID)
	 i SQLCODE=100 s SQLCODE=0
	 q SQLCODE_"^"_RowID
}

/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitSummary","GetBenefitSummary","")
Query GetBenefitSummary(pYear As %String = "", pUserDR As %String = "") As %Query(ROWSPEC = "TRowID:%String,TYear:%String,TSummary:%String,TUserDR:%String,TUser:%String,TDate:%String,TStatus:%String,TStatusdesc:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String") [ SqlProc ]
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

/// d ##class(%ResultSet).RunQuery("web.DHCEQBenefitSummary","GetBenefitSummaryList","","")
Query GetBenefitSummaryList(RowID As %String = "", Year As %String = "") As %Query(ROWSPEC = "TRowID:%String,TBenefitSummaryDR:%String,TEquipDR:%String,TNewFunction:%String,TSpecialService:%String,TOtherSocial:%String,TGraduateNum:%String,TStaffNum:%String,TOtherTasks:%String,THold1:%String,THold2:%String,THold3:%String,THold4:%String,THold5:%String,TExpectedSatis:%String,TActualSatis:%String,TPatientSatis:%String,TTotalScore:%String,TBenefitAnalysis:%String,TUseEvaluation:%String,TBriefEvaluation:%String,TOverallEvaluation:%String,TIncome:%String,TPersonTime:%String,TActualWorkLoad:%String,TPositiveCases:%String,TRunTime:%String,TFailureTimes:%String,TMaintTimes:%String,TPMTimes:%String,TDetectionTimes:%String,TWaitingTimes:%String,TAverageWorkHour:%String,TActualWorkDays:%String,TFailureDays:%String,TUCHold1:%String,TUCHold2:%String,TUCHold3:%String,TUCHold4:%String,TUCHold5:%String,TEquip:%String,TModel:%String,TLeaveFactoryNo:%String,TUseLoc:%String,TOriginalFee:%String,TLimitYearsNum:%String,TStartDate:%String,TTransAssetDate:%String,TNo:%String") [ SqlProc ]
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
	s Data=$lb(TRowID,TBenefitSummaryDR,TEquipDR,TNewFunction,TSpecialService,TOtherSocial,TGraduateNum,TStaffNum,TOtherTasks,THold1,THold2,THold3,THold4,THold5,TExpectedSatis,TActualSatis,TPatientSatis,TTotalScore,TBenefitAnalysis,TUseEvaluation,TBriefEvaluation,TOverallEvaluation,TIncome,TPersonTime,TActualWorkLoad,TPositiveCases,TRunTime,TFailureTimes,TMaintTimes,TPMTimes,TDetectionTimes,TWaitingTimes,TAverageWorkHour,TActualWorkDays,TFailureDays,TUCHold1,TUCHold2,TUCHold3,TUCHold4,TUCHold5,TEquip,TModel,TLeaveFactoryNo,TUseLoc,TOriginalFee,TLimitYearsNum,TStartDate,TTransAssetDate,TNo)
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
/// w ##Class(web.DHCEQBenefitSummary).GetOneBenefitSummary(1)
ClassMethod GetOneBenefitSummary(rowid As %Library.String = "")
{
	new result,resultex
	s (result,resultex)=""
	if (rowid=0)||(rowid="")  q ""
	s result= $g(^DHCEQBenefitSummary(rowid))
	if result="" q ""
	s resultex=resultex_"^"	
	i $p(result,"^",3)'=""  d
	.s resultex=resultex_##class(web.DHCEQCommon).GetTrakNameByID("user",$p(result,"^",3))
	s $p(result,"^",4)=##class(web.DHCEQCommon).TransValueToPage($p(result,"^",4),"date")
	s resultex=resultex_"^"
	//s $p(result,"^",5)=##class(web.DHCEQCommon).GetEditStatusDisplay($p(result,"^",5))
	s result=result_resultex
	s result=##class(web.DHCEQCommon).Replace(result,$C(13,10),"\n")
	q result
}

}
