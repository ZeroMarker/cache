Class web.DHCPE.CardMonthReport Extends %Persistent
{

// w ##class(web.DHCPE.CardMonthReport).DeleteReport("133")

ClassMethod DeleteReport(ReportID)
{
	s obj=##class(User.DHCPECardMonthReport).%New()
	s sc=obj.%DeleteId(ReportID)
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		&SQL(Update Sqluser.DHC_PE_APAmountChange set APAC_3='N',APAC_4=null where APAC_4=:ReportID)
		q obj.%Id()
	}
}

ClassMethod CreateReport(User)
{
	s $ZT="CreateCardMonthReportErr"
	s Date=+$H
	s Time=$P($H,",",2)
	s ID=$O(^User.DHCPECardMonthReportD(""),-1)
	i ID="" d
	.s PreAmount=0
	e  d
	.s OldObj=##class(User.DHCPECardMonthReport).%OpenId(ID)
	.s PreAmount=OldObj.CMRCurAmount
	s obj=##class(User.DHCPECardMonthReport).%New()
	d obj.CMRUserDRSetObjectId(User)
	s obj.CMRDate=Date
	s obj.CMRTime=Time
	s obj.CMRPreAmount=PreAmount
	
	s sc=obj.%Save()
	//d obj.%Close()
	s NewID=obj.%Id()
	s obj=##class(User.DHCPECardMonthReport).%OpenId(NewID)
	s AddAmountTotal=0
	s BackAmountTotal=0
	s OutAmountTotal=0
	s CurAmountTotal=0
	s LesAmountTotal=0
	s MIAmountTotal=0
	s MOAmountTotal=0
	s APID="0"
	f  s APID=$O(^DHCPEAP(APID)) q:APID=""  d
	.s ChildObj=##class(User.DHCPECardMonthReportDetail).%New()
	.d ChildObj.CMRDAPDRSetObjectId(APID)
	.;s PreMainID=$O(^User.DHCPECardMonthReportDetailI("APDRIndex",APID,""),-1)
	.i ID="" d
	..s PreAmount=0
	.e  d
	..s PreChildSub=$O(^User.DHCPECardMonthReportI("APDRIndex",APID,ID,""),-1)
	..i PreChildSub="" d
	...s PreAmount=0
	..e  d
	...s OldDetailID=ID_"||"_PreChildSub
	...s OldChildObj=##class(User.DHCPECardMonthReportDetail).%OpenId(OldDetailID)
	...s PreAmount=OldChildObj.CMRDCurAmount
	.s ChildObj.CMRDPreAmount=PreAmount
	.s CurAmount=$P(^DHCPEAP(APID),"^",4)
	.s ChildObj.CMRDCurAmount=CurAmount
	.;s CurAmountTotal=CurAmountTotal+CurAmount
	.s AddAmount=0
	.s BackAmount=0
	.s OutAmount=0
	.s LesAmount=0
	.s MIAmount=0
	.s MOAmount=0
	.s Sub="0"
	.f  s Sub=$O(^DHCPEAP(0,"MonthReport","N",APID,Sub)) q:Sub=""  d
	..s Type=$P(^DHCPEAP(APID,"AC",Sub),"^",1)
	..s Amt=$P(^DHCPEAP(APID,"AC",Sub),"^",2)
	..s ApUser=$P(^DHCPEAP(APID,"AC",Sub),"^",7)
	..q:ApUser'=User
	..i (Type="R")||(Type="B") d
	...s AddAmount=AddAmount+Amt
	..i (Type="RF") d
	...s OutAmount=OutAmount-Amt
	..i (Type="C") d
	...s LesAmount=LesAmount-Amt
	..i (Type="CF") d
	...s BackAmount=BackAmount+Amt
	..i (Type="O") d
	...s MOAmount=MOAmount-Amt
	..i (Type="I") d
	...s MIAmount=MIAmount+Amt
	..s OldACID=APID_"||"_Sub
	..;b ;OldACID
	..&SQL(Update Sqluser.DHC_PE_APAmountChange set APAC_3='Y',APAC_4=:NewID where APAC_RowID=:OldACID)
	..;b ;SQLCODE
	
	.s AddAmountTotal=AddAmountTotal+AddAmount
	.s BackAmountTotal=BackAmountTotal+BackAmount
	.s OutAmountTotal=OutAmountTotal+OutAmount
	.s CurAmountTotal=CurAmountTotal+CurAmount
	.s LesAmountTotal=LesAmountTotal+LesAmount
	.s MIAmountTotal=MIAmountTotal+MIAmount
	.s MOAmountTotal=MOAmountTotal+MOAmount
	.s ChildObj.CMRDAddAmount=AddAmount
	.s ChildObj.CMRDBackAmount=BackAmount
	.s ChildObj.CMRDLesAmount=LesAmount
	.s ChildObj.CMRDMoveInAmount=MIAmount
	.s ChildObj.CMRDMoveOutAmount=MOAmount
	.s ChildObj.CMRDOutAmount=OutAmount
	.d obj.ChildDetail.Insert(ChildObj)
	s obj.CMRAddAmount=AddAmountTotal
	s obj.CMRBackAmount=BackAmountTotal
	s obj.CMRCurAmount=CurAmountTotal
	s obj.CMRLesAmount=LesAmountTotal
	s obj.CMRMoveInAmount=MIAmountTotal
	s obj.CMRMoveOutAmount=MOAmountTotal
	s obj.CMROutAmount=OutAmountTotal
	s sc=obj.%Save()
	d obj.%Close()
	If ($System.Status.IsError(sc))	
	{
		q "-1^"_$System.Status.GetErrorText(sc)
	}else{
		q obj.%Id()
	}
CreateCardMonthReportErr
	q "-1^卡月报生成错误"
}

ClassMethod GetCardInAmt(ReportID)
{
	s Info="",CName="",Name=""
	s TotalInfo="^^^"
	s APID=""
	f  s APID=$O(^DHCPEAP(0,"APAC4",ReportID,APID)) q:APID=""  d
	.s RegNo=$p($g(^DHCPEAP(APID)),"^",1)
	.s CardNo=$p($g(^DHCPEAP(APID)),"^",2)
	.i RegNo'="" d
	..s ID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
	..i ID'="" s CName=$P($g(^PAPER(ID,"ALL")),"^",1)
	..s Name=""
	.e  d 
	..s CName=""
	..s Name=$p($G(^DHCPEDataEx("DHCPEAD","Info",APID)),"^",1)
	.s APACSub=""
	.f  s APACSub=$O(^DHCPEAP(0,"APAC4",ReportID,APID,APACSub)) q:APACSub=""  d
	..s UserName=$P($g(^DHCPEAP(APID,"AC",APACSub)),"^",7)
	..s:UserName'="" UserName=$P($g(^SSU("SSUSR",UserName)),"^",2)
	..s One="^^"
	..s Type=$P($g(^DHCPEAP(APID,"AC",APACSub)),"^",1)
	..q:(Type'="B")&&(Type'="R")
	..s PayMode=$P($g(^DHCPEAP(APID,"AC",APACSub)),"^",10)
	..s Amt=$P($g(^DHCPEAP(APID,"AC",APACSub)),"^",2)
	..s:PayMode="" PayMode=1
	..s PayModeDesc=$p($g(^CT("CTPM",PayMode)),"^",2)
	..i PayModeDesc="现金" s PayMode=1
	..i PayModeDesc="银行卡" s PayMode=2
	..i PayModeDesc="支票" s PayMode=3
	..s $P(One,"^",PayMode)=Amt
	..s $P(TotalInfo,"^",1)=+$P(TotalInfo,"^",1)+Amt
	..s $P(TotalInfo,"^",PayMode+1)=+$P(TotalInfo,"^",PayMode+1)+Amt
	..s Date=$P($g(^DHCPEAP(APID,"AC",APACSub)),"^",5)
	..s Time=$P($g(^DHCPEAP(APID,"AC",APACSub)),"^",6)
	..s DateTime=$zd(Date,3)_" "_$zt(Time,1)
	..i Info=""  d
	...s Info=DateTime_"^"_CardNo_"^"_Name_"^"_RegNo_"^"_CName_"^"_One
	..e  d
	...s Info=Info_"$"_DateTime_"^"_CardNo_"^"_Name_"^"_RegNo_"^"_CName_"^"_One
	q:Info="" ""
	i (Info="") d
	.s Info=Info_"$收费员^"_UserName_"^^^总计："_TotalInfo
	e  d
	.s:(Info'="") Info=Info_"$收费员^"_UserName_"^^^总计："_TotalInfo
	q Info
}

ClassMethod GetReportInfo(ReportID, PreSub, Type As %String = "M", ChangeAmount = "", SSUSER = "")
{
	;w ##class(web.DHCPE.CardMonthReport).GetReportInfo(1,"","D")
	s ret=""
	q:ReportID="" ret
	i Type="M" d
	.s ret=..GetMainReportInfo(ReportID,ChangeAmount,SSUSER)
	e  d
	.s ChildSub=$O(^User.DHCPECardMonthReportD(ReportID,"ChildDetail",PreSub))
	.q:ChildSub=""
	.s ret=..GetChildReportInfo(ReportID,ChildSub)
	.s ret=ChildSub_"^"_ret
	q ret
}

ClassMethod GetChildReportInfo(ReportID, ChildSub)
{
	s RetInfo=""
	s obj=##class(User.DHCPECardMonthReportDetail).%OpenId(ReportID_"||"_ChildSub)
	s APID=obj.CMRDAPDRGetObjectId()
	s RegNo=obj.CMRDAPDR.APRegNo
	s CardNo=obj.CMRDAPDR.APCardNo
	i RegNo'="" d
	.s CardNo=RegNo
	.s PatID=$O(^PAPERi("PAPMI_PatNo",RegNo,0))
	.s Name=""
	.i PatID'="" s Name=$P($g(^PAPER(PatID,"ALL")),"^",1)
	e  d
	.s Info=$G(^DHCPEDataEx("DHCPEAD","Info",APID))
	.s Name=$P(Info,"^",1)
	.;s Sex=$P(Info,"^",2)
	s CardType=obj.CMRDAPDR.APType
	s CardType=##class(web.DHCPE.AdvancePayment).GetCardTypeDesc(CardType)
	s PreAmt=obj.CMRDPreAmount
	s AddAmt=obj.CMRDAddAmount
	s BackAmt=obj.CMRDBackAmount
	s MoveInAmt=obj.CMRDMoveInAmount
	s LesAmt=obj.CMRDLesAmount
	s OutAmt=obj.CMRDOutAmount
	s MoveOutAmt=obj.CMRDMoveOutAmount
	s CurAmt=obj.CMRDCurAmount
	s RetInfo=CardType_"^"_CardNo_"^"_Name_"^"_PreAmt_"^"_AddAmt_"^"_BackAmt_"^"_MoveInAmt_"^"_LesAmt_"^"_OutAmt_"^"_MoveOutAmt_"^"_CurAmt
	q RetInfo
}

ClassMethod GetMainReportInfo(ReportID, ChangeAmount = "", SSUSER = "")
{
	s RetInfo=""
	s OldReportID=$O(^User.DHCPECardMonthReportD(ReportID),-1)
	i (OldReportID="")||(OldReportID=0) d
	.s StartDate=""
	e  d
	.s obj=##class(User.DHCPECardMonthReport).%OpenId(OldReportID)
	.s StartDate=obj.CMRDate
	.s StartTime=obj.CMRTime
	.s StartDate=$ZD(StartDate,3)_" "_$ZT(StartTime)
	s obj=##class(User.DHCPECardMonthReport).%OpenId(ReportID)
	s EndDate=obj.CMRDate
	s EndTime=obj.CMRTime
	s EndDate=$ZD(EndDate,3)_" "_$ZT(EndTime)
	s Date=StartDate_"--"_EndDate
	s User=obj.CMRUserDR.SSUSRName
	s PreAmt=obj.CMRPreAmount
	s AddAmt=obj.CMRAddAmount
	s BackAmt=obj.CMRBackAmount
	s MoveInAmt=obj.CMRMoveInAmount
	s LesAmt=obj.CMRLesAmount
	s OutAmt=obj.CMROutAmount
	s MoveOutAmt=obj.CMRMoveOutAmount
	s CurAmt=obj.CMRCurAmount ;
	s ExpStr=User_"^"_Date_"^"_$ZD($H,3)
	s RetInfo="^^^合计^"_PreAmt_"^"_AddAmt_"^"_BackAmt_"^"_MoveInAmt_"^"_LesAmt_"^"_OutAmt_"^"_MoveOutAmt_"^"_CurAmt_"^"_ExpStr
	q RetInfo
}

/// w ##class(web.DHCPE.CardMonthReport).OutCardStatistic("25/10/2013","25/10/2013")
ClassMethod OutCardStatistic(StartDate, EndDate, UserID As %String = "")
{
	q:((StartDate="")||(EndDate="")) 0
	s StartDate=$zdh(StartDate,4)
	s EndDate=$zdh(EndDate,4)
	s StartDate=StartDate
	s EndDate=EndDate
	s Date=0,ALLAmount=0,Cashamount=0,YHKamount=0,ZPamount=0,Info=""
	s UserName=""
	s:UserID'="" UserName=$p($G(^SSU("SSUSR",UserID)),"^",2)
	f  s Date=$o(^DHCPEAP(0,"Date",Date)) q:(Date="")  d
	.s APRowID=0
	.f  s APRowID=$o(^DHCPEAP(0,"Date",Date,APRowID)) q:(APRowID="")||(Date<StartDate)||(Date>EndDate)  d
	..s CardInfo=$g(^DHCPEAP(APRowID))
	..
	..s CardNo=$p(CardInfo,"^",2)
	..s Name=$p($G(^DHCPEDataEx("DHCPEAD","Info",APRowID)),"^",1)
	..s Sub=0
	..f  s Sub=$o(^DHCPEAP(APRowID,"AC",Sub))  q:(Sub="")   d
	...s CurData=$g(^DHCPEAP(APRowID,"AC",Sub))
	...s OneDate=$p(CurData,"^",5)
	...q:(OneDate<StartDate)||(OneDate>EndDate)
	...s ConsumeAmount=0
	...s ConsumeAmount=$p(CurData,"^",2)
	...q:((ConsumeAmount="")||(ConsumeAmount=0)||(ConsumeAmount<0))
	...s PayModeDr=$p(CurData,"^",10)
	...s Type=$p(CurData,"^",1)
	...q:((Type'="B")&&(Type'="R")&&(Type'="RF"))
	...q:(UserID'="")&&($p(CurData,"^",7)'=UserID)
	...s DateTime=$zd($p(CurData,"^",5),3)_" "_$zt($p(CurData,"^",6),1)
	...i PayModeDr=1  d
	....s Cashamount=Cashamount+ConsumeAmount
	....s OneInfo=DateTime_"^"_CardNo_"^"_Name_"^"_ConsumeAmount_"^^"
	...i PayModeDr=2  d
	....s YHKamount=YHKamount+ConsumeAmount
	....s OneInfo=DateTime_"^"_CardNo_"^"_Name_"^^"_ConsumeAmount_"^"
	...i PayModeDr=3  d
	....s ZPamount=ZPamount+ConsumeAmount
	....s OneInfo=DateTime_"^"_CardNo_"^"_Name_"^^^"_ConsumeAmount
	...i (Info="") d
	....s Info=OneInfo
	...e  d
	....s Info=Info_"$"_OneInfo
	s ALLAmount=Cashamount+YHKamount+ZPamount
	i (Info="") d
	.s Info=Info_"$收费员^"_UserName_"^总计："_ALLAmount_"^"_Cashamount_"^"_YHKamount_"^"_ZPamount
	e  d
	.s:(Info'="") Info=Info_"$收费员^"_UserName_"^总计："_ALLAmount_"^"_Cashamount_"^"_YHKamount_"^"_ZPamount
	q Info
}

/// w ##class(web.DHCPE.CardMonthReport).GetBchaoInfo("4412212")
ClassMethod GetBchaoInfo(PAADM, OEID As %String = "")
{
	s ^DHCXPTest("PE","BC")=PAADM
	s IADM=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
	s PreIADM=$p(^DHCPEIADM(IADM),"^",4)
	s PIADMPIBIDR=$p(^DHCPEPreIADM(PreIADM),"^")
	s GADM=$p(^DHCPEPreIADM(PreIADM),"^",2)
	s HPNo=$p(^DHCPEPreIADM(PreIADM),"^",27)
	i GADM'=""  d
	.s GBaseRowID=$p(^DHCPEPreGADM(GADM),"^")
	.
	.s GName=$p(^DHCPEPreGBI(GBaseRowID),"^",2)
	e  d
	.s GName="个人"
	s PAPMINo=$p(^DHCPEPreIBI(PIADMPIBIDR),"^")
	s PGBITel1=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",6)       //联系电话       //Add
	s PGBITel2=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",7) 
	s TAge=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",4)
	i TAge'="" s TAge=$P(##class(web.DHCLCNUREXCUTE).CalAge(TAge,+$H),"Y",1) //$P(##class(web.DHCLCNUREXCUTE))
	s PIADMPIBIDRSEX=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",3)
	i PIADMPIBIDRSEX'="" s PIADMPIBIDRSEX=$P(^CT("SEX",PIADMPIBIDRSEX),"^",2)
	i PGBITel1'=""  s PGBITel=PGBITel1
	e  s PGBITel=PGBITel2
	s PIADMPIBIDRName=$p($g(^DHCPEPreIBI(PIADMPIBIDR)),"^",2)
	s OEORItemStatDR=$p($g(^OEORD($p(OEID,"||",1),"I",$p(OEID,"||",2),1)),"^",13)
	
	s OSTATDesc=$d(^DHCPEDataEx("DHCPEPreIOrdItem","RefuseCheck",OEID)) //谢绝检查
	s ItmMastDR=$p($g(^OEORD($p(OEID,"||",1),"I",$p(OEID,"||",2),1)),"^",2)
	s ARCIMDesc=$p($g(^ARCIM($p(ItmMastDR,"||",1),$p(ItmMastDR,"||",2),1)),"^",2)

	s PapmiDR=$p($g(^PAADM(PAADM)),"^",1)
	s Medicare=$p($g(^PAPER(PapmiDR,1)),"^",22)
	s DepDR=$p($g(^PAADM(PAADM)),"^",4)
	s DepDesc=$p($g(^CTLOC(DepDR)),"^",2)
	i DepDesc["-" s DepDesc=$p(DepDesc,"-",2)
	s CurrentDate=$zd(+$h,3)
	//s CurrentDate=$p(CurrentDate,"-")_"年"_$p(CurrentDate,"-",2)_"月"_$p(CurrentDate,"-",3)_"日"
	
	//        	登记号		   姓名                年龄     性别               电话        团体                       
	s BaseInfo=PAPMINo_"^"_PIADMPIBIDRName_"^"_TAge_"^"_PIADMPIBIDRSEX_"^"_PGBITel_"^"_GName_"^"_Medicare_"^"_DepDesc_"^"_CurrentDate
	s DocName=""
	s ReportDate=""
	s RLTInfo=""
	s RLTID=0
	f  s RLTID=$o(^DHCPERLT(0,"ADM",PAADM,RLTID)) q:(RLTID="")  d
	.s CurOEID=$p(^DHCPERLT(RLTID),"^",9)
	.q:(OEID'="")&&(OEID'=CurOEID)
	.s Itmmast=$p(^DHCPERLT(RLTID),"^",2)
	.q:(($o(^DHCPEST(0,"STORD_ARCIM",Itmmast,0)))'="9")
	.s ArcDesc=##class(web.DHCPE.DHCPECommon).GetArcDesc(Itmmast)
	.s Result=$p(^DHCPERLT(RLTID),"^",4)
	.s DocUser=$p(^DHCPERLT(RLTID),"^",5)
	.s:DocUser'="" DocName=$P(^SSU("SSUSR",DocUser),"^",2)
	.s ReportDate=$p(^DHCPERLT(RLTID),"^",6)
	.s:ReportDate'="" ReportDate=$zd(ReportDate,3)
	.s Time=$p(^DHCPERLT(RLTID),"^",11)
	.s:Time="" Time=$P($H,",",2)
	.s:Time'="" Time=$ZT(Time)
	.s ReportDate=ReportDate_" "_Time
	.s Result=ArcDesc_"^"_Result
	.i RLTInfo=""  d
	..s RLTInfo=Result
	.e  d
	..s RLTInfo=RLTInfo_"%"_Result
	
	q BaseInfo_"^"_DocName_"^"_ReportDate_"^"_HPNo_"^"_OEORItemStatDR_"^"_ARCIMDesc_"^"_OSTATDesc_"&&"_RLTInfo
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.CardMonthReport", "SearchMonthReport","","")

Query SearchMonthReport(StartDate As %String = "", EndDate As %String = "") As %Query(ROWSPEC = "TID:%String,TUserName:%String,TDate:%String,TPreAmount:%String,TAddAmount:%String,TBackAmount:%String,TMoveInAmount:%String,TLesAmount:%String,TOutAmount:%String,TMoveOutAmount:%String,TCurAmount:%String")
{
}

ClassMethod SearchMonthReportExecute(ByRef qHandle As %Binary, StartDate As %String = "", EndDate As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	
	i StartDate'="" s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate) 
	i EndDate'="" s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate) 
	
	i StartDate="" s StartDate=1
	i EndDate="" s EndDate=+$H
	s Date=StartDate-1
	f  s Date=$O(^User.DHCPECardMonthReportI("DateIndex",Date)) q:(Date="")||(Date>EndDate)  d
	.s ID=0
	.f  s ID=$O(^User.DHCPECardMonthReportI("DateIndex",Date,ID)) q:(ID="")  d
	..s TID=ID
	..s obj=##class(User.DHCPECardMonthReport).%OpenId(TID)
	..s TUserName=obj.CMRUserDR.SSUSRName
	..s TDate=obj.CMRDate
	..s:TDate'="" TDate=##class(websys.Conversions).DateLogicalToHtml(TDate)
 	..s TPreAmount=obj.CMRPreAmount
 	..s TAddAmount=obj.CMRAddAmount
 	..s TBackAmount=obj.CMRBackAmount
 	..s TMoveInAmount=obj.CMRMoveInAmount
 	..s TLesAmount=obj.CMRLesAmount
 	..s TOutAmount=obj.CMROutAmount
 	..s TMoveOutAmount=obj.CMRMoveOutAmount
 	..s TCurAmount=obj.CMRCurAmount
 	..d FindSCBuildDetail
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

FindSCBuildDetail      
	//set Data=$lb(TID,TUserName,TDate,TPreAmount,TAddAmount,TBackAmount,TMoveInAmount,TLesAmount,TOutAmount,TMoveOutAmount,TCurAmount)
	set Data=$lb(TID,TUserName,TDate,$FN(TPreAmount,"",2),$FN(TAddAmount,"",2),$FN(TBackAmount,"",2),$FN(TMoveInAmount,"",2),$FN(TLesAmount,"",2),$FN(TOutAmount,"",2),$FN(TMoveOutAmount,"",2),$FN(TCurAmount,"",2))
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

ClassMethod SearchMonthReportFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMonthReportExecute ]
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

ClassMethod SearchMonthReportClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMonthReportExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

// d ##class(%ResultSet).RunQuery("web.DHCPE.CardMonthReport", "SearchMonthReport","","")

Query SearchMonthReportDetail(ParRef As %String = "", ChangeAmount As %String = "0") As %Query(ROWSPEC = "TSub:%String,TRegNo:%String,TCardNo:%String,TName:%String,TSex:%String,TCardType:%String,TPreAmount:%String,TAddAmount:%String,TBackAmount:%String,TMoveInAmount:%String,TLesAmount:%String,TOutAmount:%String,TMoveOutAmount:%String,TCurAmount:%String")
{
}

ClassMethod SearchMonthReportDetailExecute(ByRef qHandle As %Binary, ParRef As %String = "", ChangeAmount As %String = "0") As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	i ParRef=""{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s (TPreAmountTotal,TAddAmountTotal,TBackAmountTotal,TMoveInAmountTotal,TLesAmountTotal,TOutAmountTotal,TMoveOutAmountTotal,TCurAmountTotal)=0
	s Sub=0
	f  s Sub=$O(^User.DHCPECardMonthReportD(ParRef,"ChildDetail",Sub)) q:(Sub="")  d
	.s ID=ParRef_"||"_Sub
	.s TSub=Sub
	.s obj=##class(User.DHCPECardMonthReportDetail).%OpenId(ID)
	.s APID=obj.CMRDAPDRGetObjectId()
	.s TRegNo=obj.CMRDAPDR.APRegNo
	.s TCardNo=obj.CMRDAPDR.APCardNo
	.i TRegNo'="" d
	..s ID=$O(^PAPERi("PAPMI_PatNo",TRegNo,0))
	..i ID'="" d
	...s TName=$P($g(^PAPER(ID,"ALL")),"^",1)
	...s TSex=$p($g(^PAPER(ID,"ALL")),"^",7)
	...s:TSex'="" TSex=$p($g(^CT("SEX",TSex)),"^",2)

	.e  d
	..s Info=$G(^DHCPEDataEx("DHCPEAD","Info",APID))
	..s TName=$P(Info,"^",1)
	..s TSex=$P(Info,"^",2)
	.s TCardType=obj.CMRDAPDR.APType
	.s TCardType=##class(web.DHCPE.AdvancePayment).GetCardTypeDesc(TCardType)
	.s TPreAmount=obj.CMRDPreAmount
	.s TAddAmount=obj.CMRDAddAmount
	.s TBackAmount=obj.CMRDBackAmount
	.s TMoveInAmount=obj.CMRDMoveInAmount
	.s TLesAmount=obj.CMRDLesAmount
	.s TOutAmount=obj.CMRDOutAmount
	.s TMoveOutAmount=obj.CMRDMoveOutAmount
	.s TCurAmount=obj.CMRDCurAmount
	.q:(ChangeAmount="1")&&(TAddAmount=0)&&(TBackAmount=0)&&(TLesAmount=0)&&(TMoveInAmount=0)&&(TMoveOutAmount=0)
	.d MonthReportDetail
 	.s TPreAmountTotal=TPreAmountTotal+TPreAmount
	.s TAddAmountTotal=TAddAmountTotal+TAddAmount
	.s TBackAmountTotal=TBackAmountTotal+TBackAmount
	.s TMoveInAmountTotal=TMoveInAmountTotal+TMoveInAmount
	.s TLesAmountTotal=TLesAmountTotal+TLesAmount
	.s TOutAmountTotal=TOutAmountTotal+TOutAmount
	.s TMoveOutAmountTotal=TMoveOutAmountTotal+TMoveOutAmount
	.s TCurAmountTotal=TCurAmountTotal+TCurAmount
	
 	
	set Data=$lb("","","合计","","","",$fn(TPreAmountTotal,"",2),$fn(TAddAmountTotal,"",2),$fn(TBackAmountTotal,"",2),$fn(TMoveInAmountTotal,"",2),$fn(TLesAmountTotal,"",2),TOutAmountTotal,$fn(TMoveOutAmountTotal,"",2),$FN(TCurAmountTotal,"",2))
	Set ^CacheTemp(repid,ind)=Data
 	
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

MonthReportDetail      
	
	set Data=$lb(TSub,TRegNo,TCardNo,TName,TSex,TCardType,$fn(TPreAmount,"",2),$fn(TAddAmount,"",2),$fn(TBackAmount,"",2),$fn(TMoveInAmount,"",2),$fn(TLesAmount,"",2),$fn(TOutAmount,"",2),$fn(TMoveOutAmount,"",2),$FN(TCurAmount,"",2))
	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	Quit
}

ClassMethod SearchMonthReportDetailFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMonthReportDetailExecute ]
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

ClassMethod SearchMonthReportDetailClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMonthReportDetailExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetMonthRecordByDate(DateBegin, DateEnd, UserID, UserNo As %String = "")
{
	i DateBegin=""
	{
		s DateBegin=1
	}else{
		s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
	}
	i DateEnd=""
	{
		s DateEnd=+$H
	}else{
		s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
	}
	i UserNo'=""
	{
		s UserNo=$ZCVT(UserNo,"U")
		s UserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",UserNo,0))
		q:UserID="" "-1"
		s UserName=$P(^SSU("SSUSR",UserID),"^",2)
	}
	else
	{
		s UserID=""
		s UserName=""
	}
	s ret=""
	s Date=DateBegin-1
	f  s Date=$O(^User.DHCPECardMonthReportI("DateIndex",Date)) q:(Date="")||(Date>DateEnd)  d
	.s ID=""
	.f  s ID=$O(^User.DHCPECardMonthReportI("DateIndex",Date,ID)) q:(ID="")  d
	..s CurUser=$LG(^User.DHCPECardMonthReportD(ID),2)
	..q:(CurUser'=UserID)&&(UserID'="")
	..i ret="" d
	...s ret=ID
	..e  d
	...s ret=ret_"^"_ID
	q ret_"$"_UserName
}

Storage Default
{
<Data name="CardMonthReportDefaultData">
<Value name="1">
<Value>%%CLASSNAME</Value>
</Value>
</Data>
<DataLocation>^web.DHCPE.CardMonthReportD</DataLocation>
<DefaultData>CardMonthReportDefaultData</DefaultData>
<ExtentSize>100000</ExtentSize>
<IdLocation>^web.DHCPE.CardMonthReportD</IdLocation>
<IndexLocation>^web.DHCPE.CardMonthReportI</IndexLocation>
<StreamLocation>^web.DHCPE.CardMonthReportS</StreamLocation>
<Type>%Storage.Persistent</Type>
}

}
