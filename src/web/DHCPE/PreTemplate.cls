/// 预约限制模版
Class web.DHCPE.PreTemplate Extends (%RegisteredObject, %XML.Adaptor)
{

/// 1^I^1-2^123-234^^40-^40-^^$1^G^3-4^80-^80-55^80-^80-^^$2^I^^^^^^^$2^G^^^^^^^$3^I^^^^^^^$3^G^^^^^^^
/// w ##class(web.DHCPE.PreTemplate).Update(572,5918,"1^I^12-12^12-12^12-12^12-12^12-12^^$1^G^12-12^12-12^12-12^12-12^12-12^^$2^I^^^^^^^$2^G^^^^^^^$3^I^^^^^^^$3^G^^^^^^^")
ClassMethod Update(LocID, UserID, InfoStr)
{
	
	
	s Count=$L(InfoStr,"$")
	s Date=+$H
	s Time=$P($H,",",2)
	f i=1:1:Count  d
	.s OneInfo=$P(InfoStr,"$",i)
	.s VIPLevel=$P(OneInfo,"^",1)
	.s Type=$P(OneInfo,"^",2)
	.s OneCount=$L(OneInfo,"^")
	.f j=3:1:OneCount  d
	..s Num=$P(OneInfo,"^",j)
	..s MaleNum="",FemaleNum=""
	..s:Num'="" MaleNum = $p(Num,"-",1),FemaleNum = $p(Num,"-",2)
	..s WeekNum=j-2
	..s:WeekNum=7 WeekNum=0
	..s ID=..GetOneID(LocID,VIPLevel,WeekNum,Type)
	..i ID="" d
	...s obj=##class(User.DHCPEPreTemplate).%New()
	...s timeObj=##class(User.DHCPEPreTimeTemplate).%New()
	...d obj.PTLocDRSetObjectId(LocID)
	...s obj.PTType=Type
	...s obj.PTVIPLevel=VIPLevel
	...s obj.PTWeekNum=WeekNum
	...;d obj.PTTimeChild.Insert(timeObj)
	..e  d
	...s obj=##class(User.DHCPEPreTemplate).%OpenId(ID)
	..;d ##class(User.DHCPEPreTemplate).%BuildIndices()
	..s obj.PTNumMale = MaleNum
	..s obj.PTNumFemale = FemaleNum
	..s obj.PTUpdateDate=Date
	..s obj.PTUpdateTime=Time
	..d obj.PTUpdateUserDRSetObjectId(UserID)
	..s sc=obj.%Save()
	..s ID=obj.%Id()
	..d obj.%Close()
	
	..s SubCount=0
	..s TemplateSub = ""
	..f  s TemplateSub = $o(^User.DHCPEPreTemplateD(ID,"PTTimeChild",TemplateSub)) q:TemplateSub=""  do
	...s SubCount=SubCount+1
	
	..i (SubCount'=0) do
	...s a=1
	...s TemplateSub = ""
	...f  s TemplateSub = $o(^User.DHCPEPreTemplateD(ID,"PTTimeChild",TemplateSub)) q:TemplateSub=""  do
	....s SubId = ID_"||"_TemplateSub
	....s subObj=##class(User.DHCPEPreTimeTemplate).%OpenId(SubId)
	....i (a#SubCount=1) s subObj.PTTNumMale=((MaleNum\SubCount)+(MaleNum#SubCount)),subObj.PTTNumFemale=((FemaleNum\SubCount)+(FemaleNum#SubCount))
	....i (a#SubCount'=1) s subObj.PTTNumMale=(MaleNum\SubCount),subObj.PTTNumFemale=(FemaleNum\SubCount)
	....s scSub=subObj.%Save()
	....d subObj.%Close()
	....s a=a+1
	
	
	..e  do
	...s SubCount=3
	...s a=1
	...for i=1:1:3  do
	....s subObj=##class(User.DHCPEPreTimeTemplate).%New()
	....d subObj.PTTParRefSetObjectId(ID)
	....i (i=1)  do
	.....s subObj.PTTStartTime=28801
	.....s subObj.PTTEndTime=30600
	....i (i=2)  do
	.....s subObj.PTTStartTime=30601
	.....s subObj.PTTEndTime=32400
	....i (i=3)  do
	.....s subObj.PTTStartTime=32401
	.....s subObj.PTTEndTime=34200
	....i (a#SubCount=1) s subObj.PTTNumMale=((MaleNum\SubCount)+(MaleNum#SubCount)),subObj.PTTNumFemale=((FemaleNum\SubCount)+(FemaleNum#SubCount))
	....i (a#SubCount'=1) s subObj.PTTNumMale=(MaleNum\SubCount),subObj.PTTNumFemale=(FemaleNum\SubCount)
	....s scSub=subObj.%Save()
	....d subObj.%Close()
	....s a=a+1
	
	
	...;s ListInfo=^User.DHCPEPreTemplateD(ID,"PTTimeChild",TemplateSub)
	...;i (a#SubCount=1) s ListInfo(1)="",ListInfo(2)=$LG(ListInfo,2),ListInfo(3)=$LG(ListInfo,3),ListInfo(4)=((MaleNum\SubCount)+(MaleNum#SubCount)),ListInfo(5)=((FemaleNum\SubCount)+(FemaleNum#SubCount))
	...;i (a#SubCount'=1) s ListInfo(1)="",ListInfo(2)=$LG(ListInfo,2),ListInfo(3)=$LG(ListInfo,3),ListInfo(4)=(MaleNum\SubCount),ListInfo(5)=(FemaleNum\SubCount)
	
	
	...;s ^User.DHCPEPreTemplateD(ID,"PTTimeChild",TemplateSub)=$lb(ListInfo(1),ListInfo(2),ListInfo(3),ListInfo(4),ListInfo(5))
	q sc
}

/// w ##class(web.DHCPE.PreTemplate).UpdateTimeInfo("","1","","28801^30600^16^")
ClassMethod UpdateTimeInfo(Type, ParRef, ID, Info)
{
	s StartTime=$P(Info,"^",1)
	//s:StartTime[(":") StartTime=$ZTH(StartTime)
	s:StartTime[(":") StartTime=##class(websys.Conversions).TimeHtmlToLogical(StartTime)
	s EndTime=$P(Info,"^",2)
	//s:EndTime[(":") EndTime=$ZTH(EndTime)
	s:EndTime[(":") EndTime=##class(websys.Conversions).TimeHtmlToLogical(EndTime)
	q:StartTime>EndTime "-1^开始时间不能大于结束时间"
	s NumMale=$P(Info,"^",3)
	s NumFemale=$P(Info,"^",4)
	s obj=""
	i Type="M" d
	.i ID="" d
	..s obj=##class(User.DHCPEPreTimeManager).%New()
	..d obj.PTMParRefSetObjectId(ParRef)
	..s obj.PTMStartTime=StartTime
	..;s obj.PTMNum=0
	..s obj.PTMEndTime=EndTime
	..s obj.PTMNumMale=NumMale
	..s obj.PTMNumFemale=NumFemale
	
	.e  d
	..s obj=##class(User.DHCPEPreTimeManager).%OpenId(ID)
	.s obj.PTMStartTime=StartTime
	.s obj.PTMEndTime=EndTime
	.;s obj.PTMNum=0
	.s obj.PTMNumMale=NumMale
	.s obj.PTMNumFemale=NumFemale
	i Type="T" d
	.i ID="" d
	..s obj=##class(User.DHCPEPreTimeTemplate).%New()
	..d obj.PTTParRefSetObjectId(ParRef)
	..s obj.PTTStartTime=StartTime
	..s obj.PTTEndTime=EndTime
	..;s obj.PTMNum=0
	..s obj.PTTNumMale=NumMale
	..s obj.PTTNumFemale=NumFemale
	.e  d
	..s obj=##class(User.DHCPEPreTimeTemplate).%OpenId(ID)
	.s obj.PTTStartTime=StartTime
	.s obj.PTTEndTime=EndTime
	.;s obj.PTMNum=0
	.s obj.PTTNumMale=NumMale
	.s obj.PTTNumFemale=NumFemale
	i Type="H" d
	.i ID="" d
	..s obj=##class(User.DHCPEPreHomeTimeInfo).%New()
	..d obj.PHTParRefSetObjectId(ParRef)
	..s obj.PHStartTime=StartTime
	..s obj.PHEndTime=EndTime
	..s obj.PHNumMale=NumMale
	..s obj.PHNumFemale=NumFemale
	.e  d
	..s obj=##class(User.DHCPEPreHomeTimeInfo).%OpenId(ID)
	.s obj.PHStartTime=StartTime
	.s obj.PHEndTime=EndTime
	.s obj.PHNumMale=NumMale
	.s obj.PHNumFemale=NumFemale
	s sc=obj.%Save()
	d obj.%Close()
	q sc
}

ClassMethod CreateTimeInfo(ParRef, TemplateID)
{
	;d ##class(web.DHCPE.PreTemplate).CreateTimeInfo(99,1)
	&sql(Delete From Sqluser.DHC_PE_PreTimeManager where PTMParRef=:ParRef)
	s Sub=0
	f  s Sub=$O(^User.DHCPEPreTemplateD(TemplateID,"PTTimeChild",Sub)) q:Sub=""  d
 	.s ID=TemplateID_"||"_Sub
 	.s ListInfo=^User.DHCPEPreTemplateD(TemplateID,"PTTimeChild",Sub)
 	.s Info=$LG(ListInfo,2)_"^"_$LG(ListInfo,3)_"^"_$LG(ListInfo,5)_"^"_$LG(ListInfo,6)
 	.d ..UpdateTimeInfo("M",ParRef,"",Info)
 	q
}

ClassMethod DeleteTimeInfo(Type, ID)
{
	
	i Type="M" d
	.&SQL(Delete From Sqluser.DHC_PE_PreTimeManager where ID=:ID)
	i Type="T" d
	.&SQL(Delete From Sqluser.DHC_PE_PreTimeTemplate where ID=:ID)
	i Type="H" d
	.&SQL(Delete From Sqluser.DHC_PE_HomeTimeInfo where ID=:ID)
	q SQLCODE
}

ClassMethod CreateRecord(LocID, UserID, StartDate, EndDate)
{
	;d ##class(web.DHCPE.PreTemplate).CreateRecord(53,5918,"01/10/2014","31/10/2014")
	q:(StartDate="")||(EndDate="") "-1^日期都不能为空"
	s StartDate=##class(websys.Conversions).DateHtmlToLogical(StartDate)
	s EndDate=##class(websys.Conversions).DateHtmlToLogical(EndDate)
	s err=""
	f Date=StartDate:1:EndDate  d
	.s existFlag=..ExistNetPreRecord(Date,LocID)
	.s:(existFlag=1)&&(err'="") err=err_"、"_$ZD(Date,3)
	.s:(existFlag=1)&&(err="") err=$ZD(Date,3)
	
	q:err'="" "-2^"_err_"已存在网上预约记录，不允许批量生成限额"
	f Date=StartDate:1:EndDate  d
	.s WeekNum=$ZD(Date,10)
	.s VIPID=""
	.f  s VIPID=$O(^User.DHCPEPreTemplateI("LocWeekNumIndex",LocID,WeekNum,VIPID)) q:VIPID=""  d
	..s Type=""
	..f  s Type=$O(^User.DHCPEPreTemplateI("LocWeekNumIndex",LocID,WeekNum,VIPID,Type)) q:Type=""  d
	...s Num=..GetOneNum(LocID,VIPID,WeekNum,Type)
	...q:Num=""
	...s Str=Date_"^"_VIPID_"^"_Type_"^"_Num
	...s ret=..UpdateRecord(LocID, UserID, Str)
	...s ID=..GetRecordID(LocID,Date,VIPID,Type)
	...s WeekNum=$ZD(Date,10)
	...s TemplateID=..GetOneID(LocID,VIPID,WeekNum,Type)
	...d ..CreateTimeInfo(ID,TemplateID)
	q "OVER"
}

// 更新设置记录 Str=Date^VIPLevel^Type^Num

ClassMethod UpdateRecord(LocID, UserID, Str)
{
	s Date=$P(Str,"^",1)
	s VIPLevel=$P(Str,"^",2)
	s Type=$P(Str,"^",3)
	s Num=$P(Str,"^",4)
	s MaleNum="",FemaleNum=""
	s:Num'="" MaleNum = $p(Num,"-",1)
	s:Num'="" FemaleNum = $p(Num,"-",2)
	s ID=..GetRecordID(LocID,Date,VIPLevel,Type)
	i ID="" d
	.s obj=##class(User.DHCPEPreManager).%New()
	.s obj.PMDate=Date
	.d obj.PMLocDRSetObjectId(LocID)
	.s obj.PMType=Type
	.s obj.PMVIPLevel=VIPLevel
	e  d
	.s obj=##class(User.DHCPEPreManager).%OpenId(ID)
	s obj.PMUpdateDate=+$H
	s obj.PMUpdateTime=$P($H,",",2)
	d obj.PMUpdateUserDRSetObjectId(UserID)
	s obj.PMNumMale=MaleNum
	s obj.PMNumFemale=FemaleNum
	s sc=obj.%Save()
	d obj.%Close()
	q sc
}

// 得到设置数量

ClassMethod GetRecordNum(LocID, Date, VIPLevel, Type)
{
	s OneID=..GetRecordID(LocID,Date,VIPLevel,Type)
	q:OneID="" ""
	s MaleNum = $LG(^User.DHCPEPreManagerD(OneID),11)
	s FemaleNum = $LG(^User.DHCPEPreManagerD(OneID),12)
	if ((MaleNum="")&&(FemaleNum="")) quit ""
	q MaleNum_"-"_FemaleNum
}

// 得到设置ID

ClassMethod GetRecordID(LocID, Date, VIPLevel, Type)
{
	q $O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date,VIPLevel,Type,""))
}

// 得到模版数量

ClassMethod GetOneNum(LocID, VIPLevel, WeekNum, Type)
{
	s OneID=..GetOneID(LocID,VIPLevel,WeekNum,Type)
	q:OneID="" ""
	s MaleNum = $LG(^User.DHCPEPreTemplateD(OneID),10)
	s FemaleNum = $LG(^User.DHCPEPreTemplateD(OneID),11)
	;i ((MaleNum="")&&(FemaleNum="")) quit ""
	q MaleNum_"-"_FemaleNum
}

// 得到模版ID

ClassMethod GetOneID(LocID, VIPLevel, WeekNum, Type)
{
	q $O(^User.DHCPEPreTemplateI("LocWeekNumIndex",LocID,WeekNum,VIPLevel,Type,""))
}

ClassMethod GetHadCreateDate(LocID)
{
	;s val=##class(web.DHCPE.PreTemplate).GetHadCreateDate(53)
	s Date=""
	s Date=$O(^User.DHCPEPreManagerI("LocDateIndex",LocID,Date),-1)
	s:Date="" Date=+$H
	
	s Date=+Date+1
	q ##class(websys.Conversions).DateLogicalToHtml(Date)
}

/// Debug: d ##class(%ResultSet).RunQuery("web.DHCPE.PreTemplate","SerchPreNum")
Query SerchPreNum() As %Query(ROWSPEC = "VIPID:%String,VIPDesc:%String:类型,NUM1:%String:周一,NUM2:%String:周二,NUM3:%String:周三,NUM4:%String:周四,NUM5:%String:周五,NUM6:%String:周六,NUM0:%String:周日,Type:%String:类型")
{
}

ClassMethod SerchPreNumExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s LocID=%session.Get("LOGON.CTLOCID")
 	
 	/*
 	s ID=""
 	f  s ID=$O(^DHCPEVIPLevel("VIP",ID)) q:ID=""  d
 	.s Desc=$P(^DHCPEVIPLevel("VIP",ID),"^",2)
 	.S Active=$P(^DHCPEVIPLevel("VIP",ID),"^",4)
 	.q:Active'="Y"
 	*/
 	s ID=""
 	f  s ID=$o(^CT.PE.VIPLevelD(ID)) q:ID=""  d
	.s Desc=$lg($g(^CT.PE.VIPLevelD(ID)),3)
	.s Active=$lg($g(^CT.PE.VIPLevelD(ID)),4)
	.q:Active'="Y"
 	.i (ID=4)  do
 	..s Type="O"
 	..s VIPDesc=Desc
 	..s Num1=..GetOneNum(LocID,ID,1,Type)
 	..s Num2=..GetOneNum(LocID,ID,2,Type)
 	..s Num3=..GetOneNum(LocID,ID,3,Type)
 	..s Num4=..GetOneNum(LocID,ID,4,Type)
 	..s Num5=..GetOneNum(LocID,ID,5,Type)
 	..s Num6=..GetOneNum(LocID,ID,6,Type)
 	..s Num0=..GetOneNum(LocID,ID,0,Type)  //周日
 	..d FindBuild
 	.e  do
 	..s Type="I"
 	..s VIPDesc=Desc_"个人"
 	..s Num1=..GetOneNum(LocID,ID,1,Type)
 	..s Num2=..GetOneNum(LocID,ID,2,Type)
 	..s Num3=..GetOneNum(LocID,ID,3,Type)
 	..s Num4=..GetOneNum(LocID,ID,4,Type)
 	..s Num5=..GetOneNum(LocID,ID,5,Type)
 	..s Num6=..GetOneNum(LocID,ID,6,Type)
 	..s Num0=..GetOneNum(LocID,ID,0,Type)  //周日
 	..d FindBuild
 	..s Type="G"
 	..s VIPDesc=Desc_"团体"
 	..s Num1=..GetOneNum(LocID,ID,1,Type)
 	..s Num2=..GetOneNum(LocID,ID,2,Type)
 	..s Num3=..GetOneNum(LocID,ID,3,Type)
 	..s Num4=..GetOneNum(LocID,ID,4,Type)
 	..s Num5=..GetOneNum(LocID,ID,5,Type)
 	..s Num6=..GetOneNum(LocID,ID,6,Type)
 	..s Num0=..GetOneNum(LocID,ID,0,Type)  //周日
 	..d FindBuild
 	
 	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
FindBuild      
	set Data=$lb(ID,VIPDesc,Num1,Num2,Num3,Num4,Num5,Num6,Num0,Type)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchPreNumFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchPreNumExecute ]
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

ClassMethod SerchPreNumClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchPreNumExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.PreTemplate","SerchTimeInfo",2,710)
Query SerchTimeInfo(Type As %String = "", ParRef As %String = "") As %Query(ROWSPEC = "TParRef:%String,TID:%String,TStartTime:%String,TEndTime:%String,TNumMale:%String,TNumFemale:%String")
{
}

ClassMethod SerchTimeInfoExecute(ByRef qHandle As %Binary, Type As %String = "", ParRef As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s Sub=0
 	i Type="M" d
 	.f  s Sub=$O(^User.DHCPEPreManagerD(ParRef,"PMTimeChild",Sub)) q:Sub=""  d
 	..s ID=ParRef_"||"_Sub
 	..s ListInfo=^User.DHCPEPreManagerD(ParRef,"PMTimeChild",Sub)
 	..d OneBuild
 	i Type="T" do
 	.f  s Sub=$O(^User.DHCPEPreTemplateD(ParRef,"PTTimeChild",Sub)) q:Sub=""  d
 	..s ID=ParRef_"||"_Sub
 	..s ListInfo=^User.DHCPEPreTemplateD(ParRef,"PTTimeChild",Sub)
	..d OneBuild
	i Type="H" do
	.f  s Sub=$O(^User.DHCPEPreHomeInfoD(ParRef,"PGTimeInfo",Sub)) q:Sub=""  d
 	..s ID=ParRef_"||"_Sub
 	..s ListInfo=^User.DHCPEPreHomeInfoD(ParRef,"PGTimeInfo",Sub)
	..d OneBuild2
	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OneBuild
	s StartTime=$LG(ListInfo,2)
	//s StartTime=$ZT(StartTime)
	s StartTime=##class(websys.Conversions).TimeLogicalToHtml(StartTime)
	s EndTime=$LG(ListInfo,3)
	//s EndTime=$ZT(EndTime)
	s EndTime=##class(websys.Conversions).TimeLogicalToHtml(EndTime)
	s NumMale=$LG(ListInfo,5)
	s NumFemale=$LG(ListInfo,6)
	d FindBuild
	q
OneBuild2
	s StartTime=$LG(ListInfo,2)
	s StartTime=##class(websys.Conversions).TimeLogicalToHtml(StartTime)
	s EndTime=$LG(ListInfo,3)
	s EndTime=##class(websys.Conversions).TimeLogicalToHtml(EndTime)
	s NumMale=$LG(ListInfo,4)
	s NumFemale=$LG(ListInfo,5)
	d FindBuild
	q
FindBuild      
	set Data=$lb(ParRef,ID,StartTime,EndTime,NumMale,NumFemale)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SerchTimeInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SerchTimeInfoExecute ]
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

ClassMethod SerchTimeInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SerchTimeInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
	 Kill ^CacheTemp(repid)
	 Quit $$$OK
}

/// w ##class(web.DHCPE.PreTemplate).SearchPeopleCount(601)
ClassMethod SearchPeopleCount(ID, Type)
{
	i (Type="M") do
	.s obj=##class(User.DHCPEPreManager).%OpenId(ID)
	.s Num = obj.PMNumMale_"-"_obj.PMNumFemale
	i (Type="T") do
	.s obj=##class(User.DHCPEPreTemplate).%OpenId(ID)
	.s Num = obj.PTNumMale_"-"_obj.PTNumFemale
	i (Type="H") do
	.s obj=##class(User.DHCPEPreHomeInfo).%OpenId(ID)
	.s Num = obj.PGADMHomeMaleNum_"-"_obj.PGADMHomeFemaleNum
	quit Num
}

/// 检查是否存在网上预约记录  1：存在  0：不存在
/// w ##class(web.DHCPE.PreTemplate).ExistNetPreRecord(64656,263)
ClassMethod ExistNetPreRecord(Date, LocID)
{
	s Flag=0
	s NetPreID=""
	f  s NetPreID=$O(^User.DHCPENetPreRecordI("PreDateIndex",Date,NetPreID)) q:(NetPreID="")||(Flag=1)  d
	.s status=$lg(^User.DHCPENetPreRecordD(NetPreID),7)
	.q:(status=2)||(status=3)||(status=6)
	.s curLocID=$lg(^User.DHCPENetPreRecordD(NetPreID),17)
	.q:curLocID'=LocID
	.s preType=$lg(^User.DHCPENetPreRecordD(NetPreID),22)
	.q:preType="H"
	.s Flag=1
	q Flag
}

}
