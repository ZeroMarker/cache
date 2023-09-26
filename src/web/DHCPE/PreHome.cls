/// 团队预约主场设定业务处理类
Class web.DHCPE.PreHome Extends (%RegisteredObject, %XML.Adaptor)
{

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreHome","SerchHomeInfo","1497")
Query SerchHomeInfo(PGADMDr As %String = "", Type As %String = "") As %Query(ROWSPEC = "TPADMDr:%String,THomeRowID:%String,TBeginDate:%String,TEndDate:%String,TMaleNum:%String,TFemaleNum:%String,TDate:%String,TRemark:%String")
{
}

ClassMethod SerchHomeInfoExecute(ByRef qHandle As %Binary, PGADMDr As %String = "", Type As %String = "") As %Status
{
	
	Set repid = $I(^CacheTemp)
	s ind = 1
	s HomeGroup=""
	s HomeGroup=##class(web.DHCPE.PreHome).GetHomeFlag(PGADMDr,"G")
	s HomeRowId = ""
	f  s HomeRowId = $o(^User.DHCPEPreHomeInfoI("PGADMDrIndex",PGADMDr,HomeRowId)) q:HomeRowId=""  do
	.;$LG(^User.DHCPEPreManagerD(NumID),4)
	.s CurType=$LG(^User.DHCPEPreHomeInfoD(HomeRowId),11)
	.q:CurType'=Type
	.s BeginDate = $LG(^User.DHCPEPreHomeInfoD(HomeRowId),3)
	.;i BeginDate'="" s BeginDate = $zd(BeginDate,4)
	.i BeginDate'="" s BeginDate =##class(websys.Conversions).DateLogicalToHtml(BeginDate)
	.s EndDate = $LG(^User.DHCPEPreHomeInfoD(HomeRowId),4)
	.;i EndDate'="" s EndDate = $zd(EndDate,4)
	.i EndDate'="" s EndDate = ##class(websys.Conversions).DateLogicalToHtml(EndDate)
	.s MaleNum = $LG(^User.DHCPEPreHomeInfoD(HomeRowId),5)
	.s FemaleNum = $LG(^User.DHCPEPreHomeInfoD(HomeRowId),6)
	.s Date = $LG(^User.DHCPEPreHomeInfoD(HomeRowId),10)
	.s DateTmp = Date
	.i Date'="" s Date = ##class(websys.Conversions).DateLogicalToHtml(Date)
	.s TRemark=$LG(^User.DHCPEPreHomeInfoD(HomeRowId),12)
	.s ^TMPHOMEDATA($j,DateTmp)=PGADMDr_"^"_HomeRowId_"^"_BeginDate_"^"_EndDate_"^"_MaleNum_"^"_FemaleNum_"^"_Date_"^"_TRemark
	
	s tmpDate=""
	f  s tmpDate = $o(^TMPHOMEDATA($j,tmpDate)) q:tmpDate=""  do
	.s PGADMDr = $p(^TMPHOMEDATA($j,tmpDate),"^",1)
	.s HomeRowId = $p(^TMPHOMEDATA($j,tmpDate),"^",2)
	.s BeginDate = $p(^TMPHOMEDATA($j,tmpDate),"^",3)
	.s EndDate = $p(^TMPHOMEDATA($j,tmpDate),"^",4)
	.s MaleNum = $p(^TMPHOMEDATA($j,tmpDate),"^",5)
	.s FemaleNum = $p(^TMPHOMEDATA($j,tmpDate),"^",6)
	.s Date = $p(^TMPHOMEDATA($j,tmpDate),"^",7)
	.s TRemark=$p(^TMPHOMEDATA($j,tmpDate),"^",8)
	.d OutputRow1
	
	k ^TMPHOMEDATA
	Set qHandle = $lb(0,repid,0)
	Quit $$$OK
OutputRow1
	//Set Data = $lb(PGADMDr,HomeRowId,BeginDate,EndDate,MaleNum,FemaleNum,Date,TRemark_HomeGroup)
	Set Data = $lb(PGADMDr,HomeRowId,BeginDate,EndDate,MaleNum,FemaleNum,Date,TRemark)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod SerchHomeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchHomeInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	//
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 	Set AtEnd=1
 	Set Row=""
 	}
 	Else      {				// fetch row
 	Set Row=^CacheTemp(repid,ind)
 	}
 	// , PatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String, CONTEXT As %String
 	// Save QHandlePatientNo As %String, SurName As %String, CurrentDept As %String, CurrentBed As %String, CurrentWard As %String, CurrentDoctor As %String, StartDate As %Date, EndDate As %Date, CurrentAdmType As %String	
 	s qHandle=$lb(AtEnd,repid,ind)
 	Quit $$$OK
}

ClassMethod SerchHomeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchHomeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// w ##class("web.DHCPEPreHome").UpdateMethod("1333","","63480","63481","222-333")
ClassMethod UpdateMethod(PADMDr, RowId, BeginDate, EndDate, Num, Remark As %String = "")
{
	s MaleNum = $p(Num,"-",1)
	s FemaleNum = $p(Num,"-",2)
	s ResultCode = ""
	
	i BeginDate'="" s BeginDate = ##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	i EndDate'="" s EndDate = ##class(websys.Conversions).DateHtmlToLogical(EndDate)
	i EndDate<BeginDate  quit "4"
	s Remark=##class(web.DHCPE.Public.Setting).Replace(Remark," ","")
	
	;f  s HomeRowId = $o(^User.DHCPEPreHomeInfoI("PGADMDrIndex",PADMDr,HomeRowId)) q:HomeRowId=""  do
	.;quit:((RowId '= "") && (HomeRowId = RowId))
	.;s BDateIn = $LG(^User.DHCPEPreHomeInfoD(HomeRowId),3)
	.;s EDate = $LG(^User.DHCPEPreHomeInfoD(HomeRowId),4)
	.;i ((BeginDate >= BDateIn) && (BeginDate <= EDate))  s ResultCode = "1"
	.;i ((EndDate >= BDateIn) && (EndDate <= EDate))  s ResultCode = "1"
	;if (ResultCode = "1")
	;{
		;quit "1"	
	;}
	
	s Type=$P(PADMDr,"^",2)
	s PADMDr=$P(PADMDr,"^",1)
	/*
	s PreEndDate=$P(^DHCPEPreGADM(PADMDr),"^",3)
	q:(PreEndDate'="")&&(EndDate>PreEndDate) "5"
	s validQty=..ValidGHomeQty(PADMDr,BeginDate,EndDate,Num)
	q:+validQty<0 "6"
	q:($p(validQty,"^",2)<0) "7"
*/

	s flag=0
	i Type="C" d
	.s LocID=$LG(^User.DHCPEContractD(PADMDr),8)
	e  d
	.s LocID=$P(^DHCPEPreGADM(PADMDr),"^",23)
	.s PreEndDate=$P(^DHCPEPreGADM(PADMDr),"^",3)
	.s PreBeginDate=$P(^DHCPEPreGADM(PADMDr),"^",2)
	.i (PreEndDate'="")&&(EndDate>PreEndDate) s ResultCode="5",flag=1
	.i (PreBeginDate'="")&&(BeginDate<PreBeginDate) s ResultCode="8",flag=1
	.s validQty=..ValidGHomeQty(PADMDr,BeginDate,EndDate,Num)
	.i +validQty<0 s ResultCode="6",flag=1
	.i ($p(validQty,"^",2)<0) s ResultCode="7",flag=1
	i (flag=1)&&(Type'="C") q ResultCode

	s UserID=%session.Get("LOGON.USERID")
	s UpdateDate=+$H
	s UpdateTime=$p($H,",",2)
	s result=""
	for date=BeginDate:1:EndDate  do
	.;q:(($zd(date,10)=6)||($zd(date,10)=0))&&(EndDate-BeginDate>0)
	.;q:'$D(^User.DHCPEPreManagerI("LocDateIndex",LocID,date))
	.s UseHomeRowId=""
	.s HomeRowId = ""
	.f  s HomeRowId = $o(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PADMDr,date,HomeRowId)) q:(HomeRowId="")||(UseHomeRowId'="")  d
	..s CurType=$LG(^User.DHCPEPreHomeInfoD(HomeRowId),11)
	..q:CurType'=Type
	..s UseHomeRowId=HomeRowId
 	.s HomeRowId=UseHomeRowId
 	.i HomeRowId = ""  do
	..s HomeInfoObj = ##class(User.DHCPEPreHomeInfo).%New()
	.e  do
	..s HomeInfoObj = ##class(User.DHCPEPreHomeInfo).%OpenId(HomeRowId)
	
	.s HomeInfoObj.PGADMDr=PADMDr
	.s HomeInfoObj.PGADMHomeDate = date
	.s HomeInfoObj.PGADMHomeMaleNum = MaleNum
	.s HomeInfoObj.PGADMHomeFemaleNum = FemaleNum
	.s HomeInfoObj.PGADMUpdateDate = UpdateDate
	.s HomeInfoObj.PGADMUpdateTime = UpdateTime
	.d HomeInfoObj.PGADMUpdateUserDRSetObjectId(UserID)
	.s HomeInfoObj.PGADMType=Type
	.s HomeInfoObj.PGADMHomeRemark=Remark
	.set sc=HomeInfoObj.%Save()
	.s ID = HomeInfoObj.%Id()
	.d HomeInfoObj.%Close()	

	.s SubCount=0
	.s TimeSub = ""
	.f  s TimeSub = $o(^User.DHCPEPreHomeInfoD(ID,"PGTimeInfo",TimeSub)) q:TimeSub=""  do
	..s SubCount=SubCount+1
	
	.i (SubCount'=0) do
	..s a=1
	..s TimeSub = ""
	..f  s TimeSub = $o(^User.DHCPEPreHomeInfoD(ID,"PGTimeInfo",TimeSub)) q:TimeSub=""  do
	...s SubId = ID_"||"_TimeSub
	...s subObj=##class(User.DHCPEPreHomeTimeInfo).%OpenId(SubId)
	...i (a#SubCount=1) s subObj.PHNumMale=((MaleNum\SubCount)+(MaleNum#SubCount)),subObj.PHNumFemale=((FemaleNum\SubCount)+(FemaleNum#SubCount))
	...i (a#SubCount'=1) s subObj.PHNumMale=(MaleNum\SubCount),subObj.PHNumFemale=(FemaleNum\SubCount)
	...s scSub=subObj.%Save()
	...d subObj.%Close()
	...s a=a+1
	.e  do
	..f i=1:1:3  d
	...s FirstMaleNum = (MaleNum\3)+(MaleNum#3),FirstFemaleNum = (FemaleNum\3)+(FemaleNum#3)
	...s SecondMaleNum = (MaleNum\3),SecondFemaleNum = (FemaleNum\3)
	...s obj=##class(User.DHCPEPreHomeTimeInfo).%New()
	...d obj.PHTParRefSetObjectId(ID)
	...i (i=1) do
	....s obj.PHStartTime = 28801
	....s obj.PHEndTime = 30600
	....s obj.PHNumMale = FirstMaleNum
	....s obj.PHNumFemale = FirstFemaleNum
	...i (i'=1) s obj.PHNumMale = SecondMaleNum,obj.PHNumFemale = SecondFemaleNum
	...i (i=2) s obj.PHStartTime = 30601,obj.PHEndTime = 32400
	...i (i=3) s obj.PHStartTime = 32401,obj.PHEndTime = 34200
	...s scSub=obj.%Save()
	...d obj.%Close()
	
	.i $System.Status.IsError(sc)  do
	..d $System.Status.DisplayError(sc)
	..s result = "2"
	.e  do
	..s result = "3"
	
	
	quit result
}

/// w ##class("web.DHCPE.PreHome").DeleteMethod("4")
ClassMethod DeleteMethod(RowId)
{
	set count = 0
	&sql(select count(*) into :count  from SQLUSER.DHC_PE_PreHomeInfo where PGADM_Home_RowId=:RowId)
	if (count = 0)
	{
		quit "1"
	}
	
	set result=##class(User.DHCPEPreHomeInfo).%DeleteId(RowId)
	
	if ($System.Status.IsError(result))
	{
		d $System.Status.DisplayError(result)
		quit "2"
	}
	else
	{
		quit "3"	
	}
}

/// w ##class("web.DHCPE.PreHome").UpdateMethodTimeInfo()
ClassMethod UpdateMethodTimeInfo()
{
		s obj=##class(User.DHCPEPreHomeTimeInfo).%New()
		d obj.PHTParRefSetObjectId(3)
		s obj.PHStartTime = 28801
		s obj.PHEndTime = 30600
		s obj.PHNumMale = 1
		s obj.PHNumFemale = 2
		set result=obj.%Save()
		d obj.%Close()
		q result
}

ClassMethod Replace(OldDate, NewDate)
{
	i OldDate'="" s OldDate=##class(websys.Conversions).DateHtmlToLogical(OldDate)
    i NewDate'=""  s NewDate=##class(websys.Conversions).DateHtmlToLogical(NewDate)

	s PreHomeID=""
	f  s PreHomeID=$O(^User.DHCPEPreHomeInfoI("PGADMHomeDateIndex",OldDate,PreHomeID)) q:PreHomeID=""  d
	.s PreGADMID=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),2)
	.s OldType=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),11)
	.i OldType="G" d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",PreGADMID)
	.e  d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("Contract",PreGADMID)
	.q:LocFlag="1"
	.&SQL(Update Sqluser.DHC_PE_PreHomeInfo set PGADM_Home_Date=:NewDate where PGADM_Home_RowId=:PreHomeID)
	;q SQLCODE
}

// d ##class(web.DHCPE.PreHome).Create("2014-12-06","07/12/2014",1)

ClassMethod Create(OldDate, NewDate, UserID)
{
	i OldDate'="" s OldDate=##class(websys.Conversions).DateHtmlToLogical(OldDate)
    i NewDate'="" s NewDate=##class(websys.Conversions).DateHtmlToLogical(NewDate)

	
	s Date=+$H
	s Time=$P($H,",",2)
	;s LocID=%session.Get("LOGON.CTLOCID")
	
	s PreHomeID=""
	f  s PreHomeID=$O(^User.DHCPEPreHomeInfoI("PGADMHomeDateIndex",OldDate,PreHomeID)) q:PreHomeID=""  d
	.s PreGADMID=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),2)
	.s OldType=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),11)
	.i OldType="G" d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PGADM",PreGADMID)
	.e  d
	..s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("Contract",PreGADMID)
	.q:LocFlag="1"
	.b ;PreHomeID
	.s obj=##class(User.DHCPEPreHomeInfo).%OpenId(PreHomeID)
	.s NewObj=##class(User.DHCPEPreHomeInfo).%New()
	.s NewObj.PGADMDr=obj.PGADMDr
	.s NewObj.PGADMHomeBeginDate=obj.PGADMHomeBeginDate
	.s NewObj.PGADMHomeDate=NewDate
	.s NewObj.PGADMHomeEndDate=obj.PGADMHomeEndDate
	.s NewObj.PGADMHomeFemaleNum=obj.PGADMHomeFemaleNum
	.s NewObj.PGADMHomeMaleNum=obj.PGADMHomeMaleNum
	.s NewObj.PGADMUpdateDate=Date
	.s NewObj.PGADMUpdateTime=Time
	.d NewObj.PGADMUpdateUserDRSetObjectId(UserID)
	.s NewObj.PGADMType=obj.PGADMType
	.s ChildLength=obj.PGTimeInfo.Count()
	.f i=1:1:ChildLength d
	..s OldChild=obj.PGTimeInfo.GetAt(i)
	..s NewChild=##class(User.DHCPEPreHomeTimeInfo).%New()
	..s NewChild.PHEndTime=OldChild.PHEndTime
	..s NewChild.PHNumFemale=OldChild.PHNumFemale
	..s NewChild.PHNumMale=OldChild.PHNumMale
	..s NewChild.PHStartTime=OldChild.PHStartTime
	..d NewObj.PGTimeInfo.Insert(NewChild)
	.s sc=NewObj.%Save()
	.d obj.%Close()
	q 0
}

// 得到是否设置过主场##class(web.DHCPE.PreHome).GetHomeFlag(1,"G")

ClassMethod GetHomeFlag(SourceID, Type)
{
	s RetHomeID=""
	s HomeID=""
	f  s HomeID=$O(^User.DHCPEPreHomeInfoI("PGADMDrIndex",SourceID,HomeID)) q:(HomeID="")||(RetHomeID'="")  d
	.s OldType=$LG(^User.DHCPEPreHomeInfoD(HomeID),11)
	.q:OldType'=Type
	.s RetHomeID=HomeID
	i RetHomeID'=""
	{
		q:Type="C" "合同主场"
		q:Type="G" "团体主场"
	}
	else
	{
		i Type="G"
		{
			s ContractID=$P($g(^DHCPEPreGADM(SourceID)),"^",25)
			q:ContractID'="" ..GetHomeFlag(ContractID,"C")
		}
	}
	q ""
}

// 根据团体得到最后一个主场ID

ClassMethod GetLastHomeIDByGADM(PreGADM)
{
	s RetHomeID=""
	q:PreGADM="" RetHomeID
	s Date=""
	f  s Date=$O(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PreGADM,Date),-1) q:(Date="")||(RetHomeID'="")  d
	.s PreHomeID=""
	.f  s PreHomeID=$O(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PreGADM,Date,PreHomeID),-1) q:(PreHomeID="")||(RetHomeID'="")  d
	..s OldType=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),11)
	..q:OldType'="G"
	..s RetHomeID=PreHomeID
	q:RetHomeID'="" RetHomeID
	s ContractID=$P(^DHCPEPreGADM(PreGADM),"^",25)
	q:ContractID="" RetHomeID
	s RetHomeID=..GetLastHomeIDByContract(ContractID)
	q RetHomeID
}

// 根据合同得到最后的主场ID

ClassMethod GetLastHomeIDByContract(ContractID)
{
	s RetHomeID=""
	s Date=""
	f  s Date=$O(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",ContractID,Date),-1) q:(Date="")||(RetHomeID'="")  d
	.s PreHomeID=""
	.f  s PreHomeID=$O(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",ContractID,Date,PreHomeID),-1) q:(PreHomeID="")||(RetHomeID'="")  d
	..s OldType=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),11)
	..q:OldType'="C"
	..s RetHomeID=PreHomeID
	q RetHomeID
}

// 根据团体ID得到某天的主场ID

ClassMethod GetHomeIDByGADM(PreGADM, Date)
{
	s RetHomeID=""
	s PreHomeID=""
	f  s PreHomeID=$O(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",PreGADM,Date,PreHomeID)) q:(PreHomeID="")||(RetHomeID'="")  d
	.s PreGADMID=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),2)
	.s OldType=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),11)
	.q:OldType'="G"
	.s RetHomeID=PreHomeID
	q:RetHomeID'="" RetHomeID
	s ContractID=$P(^DHCPEPreGADM(PreGADM),"^",25)
	q:ContractID="" ""
	s RetHomeID=..GetHomeIDByContract(ContractID,Date)
	q RetHomeID
}

// 根据合同得到某天的主场ID

ClassMethod GetHomeIDByContract(ContractID, Date)
{
	s RetHomeID=""
	s PreHomeID=""
	f  s PreHomeID=$O(^User.DHCPEPreHomeInfoI("DateRPGADMDrIndex",ContractID,Date,PreHomeID)) q:(PreHomeID="")||(RetHomeID'="")  d
	.s PreGADMID=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),2)
	.s OldType=$LG(^User.DHCPEPreHomeInfoD(PreHomeID),11)
	.q:OldType'="C"
	.s RetHomeID=PreHomeID
	q RetHomeID
}

/// d ##class(web.DHCPE.PreHome).OutTotalPreNum()
ClassMethod OutTotalPreNum(GADMDr)
{
	q:GADMDr=""
	s MaleNum=0
	s FemaleNum=0
	s HomeRowId = ""
	f  s HomeRowId = $o(^User.DHCPEPreHomeInfoI("PGADMDrIndex",GADMDr,HomeRowId)) q:HomeRowId=""  d
	.s HomeDate=$lg(^User.DHCPEPreHomeInfoD(HomeRowId),10)
	.s MaleNum=MaleNum+$lg(^User.DHCPEPreHomeInfoD(HomeRowId),5)
	.s FemaleNum=FemaleNum+$lg(^User.DHCPEPreHomeInfoD(HomeRowId),6)
	s outInfo="<b>合计 &nbsp;男：<font color=blue>"_MaleNum_"</font> &nbsp;&nbsp; 女：<font color=red>"_FemaleNum_"</b></font>"
	w outInfo
}

/// 检验团体成员数量与主场设置名额
/// w ##class(web.DHCPE.PreHome).ValidGHomeQty(115,"64471","64490","9-9")
ClassMethod ValidGHomeQty(PADMDr, BeginDate, EndDate, Num)
{
	s MaleNum = $p(Num,"-",1)
	s FemaleNum = $p(Num,"-",2)
	;i BeginDate'="" s BeginDate = ##class(websys.Conversions).DateHtmlToLogical(BeginDate)
	;i EndDate'="" s EndDate = ##class(websys.Conversions).DateHtmlToLogical(EndDate)
	i (BeginDate'="")&(EndDate'="")
	{
		s MaleNum=MaleNum*(EndDate-BeginDate+1)
		s FemaleNum=FemaleNum*(EndDate-BeginDate+1)
	}
	s PreMaleNum=0
	s PreFemaleNum=0
	//团体成员数量
	s PreIADMDR=""
	f  s PreIADMDR=$O(^DHCPEPreIADM(0,"PGADM",PADMDr,PreIADMDR)) q:PreIADMDR=""  d
	.s status=$p(^DHCPEPreIADM(PreIADMDR),"^",8)
	.q:status="CANCELPE"
	.s PIBIDR=$p(^DHCPEPreIADM(PreIADMDR),"^",1)
	.s sexDR=$P(^DHCPEPreIBI(PIBIDR),"^",3)
	.s sexDesc=$p(^CT("SEX",sexDR),"^",2)
	.s:sexDesc="男" PreMaleNum=PreMaleNum+1
	.s:sexDesc="女" PreFemaleNum=PreFemaleNum+1
	//主场名额
	s HomeRowId = ""
	f  s HomeRowId = $o(^User.DHCPEPreHomeInfoI("PGADMDrIndex",PADMDr,HomeRowId)) q:HomeRowId=""  d
	.s HomeDate=$lg(^User.DHCPEPreHomeInfoD(HomeRowId),10)
	.q:((BeginDate=HomeDate)||(BeginDate<HomeDate))&&((HomeDate=EndDate)||(HomeDate<EndDate))
	.s MaleNum=MaleNum+$lg(^User.DHCPEPreHomeInfoD(HomeRowId),5)
	.s FemaleNum=FemaleNum+$lg(^User.DHCPEPreHomeInfoD(HomeRowId),6)
	s retMaleNum=MaleNum-PreMaleNum
	s retFemaleNum=FemaleNum-PreFemaleNum
	q retMaleNum_"^"_retFemaleNum
}

}
