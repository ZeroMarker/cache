Class web.DHCOPRegReports Extends (DHCDoc.Util.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 300;

ClassMethod StatRegbydayClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = StatRegbydayExecute ]
{
 New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod StatRegbydayExecute(ByRef QHandle As %Binary, StDate As %String, EdDate As %String, Ghuse As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   
   i (Ghuse="")!(StDate="")!(EdDate="") Set QHandle=$lb(0,repid,0) Quit $$$OK
   s Sdate=$ZDH(StDate,4)
   s Edate=$ZDH(EdDate,4)
   s TEvdate="",TSum=""
   f pdate=Sdate:1:Edate  d
   .s TSum=0
   .s PRTRowid="" f  s PRTRowid=$o(^DHCINVPRT(0,"Date",pdate,PRTRowid)) q:PRTRowid=""  d
   ..s PRTUsr=$p(^DHCINVPRT(PRTRowid),"^",21)
   ..q:PRTUsr'=Ghuse
   ..;s PRTAcount=$p(^DHCINVPRT(PRTRowid),"^",1)
   ..s PRTPatientShare=$p($g(^DHCINVPRT(+PRTRowid)),"^",16)
   ..s PRTAcount=PRTPatientShare
   ..s TSum=TSum+PRTAcount
   .s TEvdate=$zd(pdate,4)
   .Do OutputRow1
      
 	Set QHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow1
   
	set Data=$lb(TEvdate,TSum)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod StatRegbydayFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatRegbydayExecute ]
{
 New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query StatRegbyday(StDate, EdDate, Ghuse) As %Query(ROWSPEC = "TEvdate:%String,TSum:%String")
{
}

ClassMethod KillTmp()
{
	k ^TmpRegPrt($j)
	k ^TMPRegRpPrt
}

ClassMethod StatAllUsrClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = StatAllUsrExecute ]
{
 New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod StatAllUsrExecute(ByRef QHandle As %Binary, StDate As %String, EdDate As %String, ctloc As %String, userid As %String, SuseID As %String) As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCOPRegReports","StatAllUsr","62584","62584","131","639","639")
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   
   d ..KillTmp()
   i (StDate="")!(EdDate="") Set QHandle=$lb(0,repid,0) Quit $$$OK
   i (ctloc="")!(userid="") Set QHandle=$lb(0,repid,0) Quit $$$OK
   i StDate'="" s StDate=..%ZDH(StDate)
   i EdDate'="" s EdDate=..%ZDH(EdDate)
   ;s Sdate=$ZDH(StDate,4)
   ;s Edate=$ZDH(EdDate,4)
   s ^GWJ("StatAllUsr")=StDate_"^"_EdDate_"^"_ctloc_"^"_userid_"^"_SuseID
   s Sregnum=0,Sregsum=0  //  挂号
   s Srefnum=0,Srefsum=0   //退号
   s Shandnum=0,Shandsum=0  //总数和
   s num=0
   s HZflag=0
   if SuseID="" s HZflag=1
   
   s RegFeeRowid=""
   f  s RegFeeRowid=$o(^User.DHCRegistrationFeeD(RegFeeRowid)) q:RegFeeRowid=""  d
   .s PRTAcount=0
   .s RegDate=$list(^User.DHCRegistrationFeeD(RegFeeRowid),15)
   .q:(RegDate<StDate)||(RegDate>EdDate)
   .s PaadmRowid=$list(^User.DHCRegistrationFeeD(RegFeeRowid),2)
   .s AdmReasondr=$p(^PAADM(PaadmRowid,1),"^",7)
   .s AdmReasonCode=""
   .if AdmReasondr'="" s AdmReasonCode=$p($g(^PAC("ADMREA",AdmReasondr)),"^",1)
   .s PatRowId=$p(^PAADM(PaadmRowid),"^",1)
   .s PatTypeDr=$p(^PAPER(PatRowId,"PER",1),"^",10)
   .s PatTypeCode=""
   .if PatTypeDr'="" s PatTypeCode=$p(^CT("SS",PatTypeDr),"^",1)
   .s workName=$p($g(^PAADM(PaadmRowid,2)),"^",69)
   .s visitStatus=$p(^PAADM(PaadmRowid),"^",20)
   .s createUser=$p(^PAADM(PaadmRowid),"^",43)
   .s createDate=$p(^PAADM(PaadmRowid),"^",41)
   .s createTime=$p(^PAADM(PaadmRowid),"^",42)
   .s updateUser=$p(^PAADM(PaadmRowid,1),"^",44)
   .s updateDate=$p(^PAADM(PaadmRowid,1),"^",42)
   .s updateTime=$p(^PAADM(PaadmRowid,1),"^",43)
   .s PartReturnSum=0
   .s User=$list(^User.DHCRegistrationFeeD(RegFeeRowid),17)
   .q:(User'=SuseID)&&(workName'=SuseID)&&(SuseID'="")
   .//q:(SuseID'="")&&(workName'="")&&(workName'=SuseID)
   .s RegTypeId=$List(^User.DHCRegistrationFeeD(RegFeeRowid),19)
   .s Tarcdr=" "
   .s:RegTypeId'="" Tarcdr=$p(^RBC("SESS",RegTypeId),"^",2)
   .s invPRTRowid=$list(^User.DHCRegistrationFeeD(RegFeeRowid),11)
   .Q:invPRTRowid=""  ;如果ID为空的话说明不是挂号员操作。在当成一个收费项来统计。
   .if invPRTRowid'="",$d(^DHCINVPRT(invPRTRowid)) d
   ..s TempPRTAcount=""
   ..;考虑部分退费情况(病历本费,预约费,附属检查费等)
   ..s OldINVDR=$p($g(^DHCINVPRT(invPRTRowid)),"^",29)
   ..i OldINVDR'="" d
   ...s PRTPatientShare=$p(^DHCINVPRT(OldINVDR),"^",16)
   ...;s PRTAcount=$p(^DHCINVPRT(OldINVDR),"^",1)
   ...s PRTAcount=PRTPatientShare
   ...;s TempPRTAcount=$p(^DHCINVPRT(invPRTRowid),"^",1)
   ...s PRTPatientShare=$p(^DHCINVPRT(invPRTRowid),"^",16)
   ...s TempPRTAcount=PRTPatientShare
   ...s PartReturnSum=PRTAcount-TempPRTAcount
   ...s invPRTRowid=OldINVDR
   ..e  d
   ...;s PRTAcount=$p(^DHCINVPRT(invPRTRowid),"^",1)
   ...s PRTPatientShare=$p($g(^DHCINVPRT(invPRTRowid)),"^",16)
   ...s PRTAcount=PRTPatientShare
   .s ConRowId="",TAppFee=0,TRegFee=0,TCheckFee=0,TOtherFee=0,HBPrice=0
   .if (invPRTRowid'="") s ConRowId=$O(^DHCBCI(0,"INV",invPRTRowid,0)) 
   .s PBRowId=""
   .i ConRowId'="" 	s PBRowId=$P(^DHCBCI(ConRowId),"^",2) 
   .if PBRowId'="" D
   ..s PBOChild=0 f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
   ...s ArcimId=$P($g(^DHCPB(PBRowId,"O",PBOChild)),"^",3)
   ...Q:ArcimId=""
   ...s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
   ...s BillSum=0
   ...s BillSum=$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
   ...i (type="Reg") s TRegFee=TRegFee+BillSum
   ...e  d
   ....i (type="Check") s TCheckFee=TCheckFee+BillSum
   ...s HBPrice=TRegFee+TCheckFee
   .if SuseID="" d
   ..s Tarcdr=" "
   ..//s PRTAcount=""
   .if HZflag=1 s SuseID=User
   .q:((createUser'=SuseID)&&(visitStatus="A")&&(workName=""))    //不是自己挂的,并且没退号
   .q:((visitStatus="C")&&(workName'=SuseID)&&(workName'="")&&(createUser'=SuseID)) //不是自己挂的,也不是自己退的
   .;本人挂号
   .i (createUser=SuseID)  d
   ..;挂号记录
   ..s tregnum=1         ;挂号数量
   ..s tregsum=PRTAcount ;挂号金额
   ..s trefnum=0         ;退号数量
   ..s trefsum=0         ;退号金额
   ..s thandnum=1        ;挂号总数
   ..s thandsum=PRTAcount ;挂号总金额
   .;退号
   .i (visitStatus="C")&&(workName=SuseID) d
   ..;退号记录——退本人号
   ..if createUser=SuseID d
   ...s tregnum=1
   ...s tregsum=PRTAcount
   ...s thandnum=0
   ...s thandsum=0
   ..else  d
   ...;退他人号
   ...s tregnum=0
   ...s tregsum=0
   ...;不是自己挂的号在挂号总金额中减去退号金额
   ...s thandnum=-1
   ...if PartReturnSum s thandsum="-"_PartReturnSum
   ...e  s thandsum="-"_PRTAcount
   ..;自己退的号中计算退号金额
   ..s trefnum=1               ;退号总数
   ..if PartReturnSum'=0  s trefsum="-"_PartReturnSum
   ..e  s trefsum="-"_PRTAcount   ;退号金额
   .;非本人退号
   .if (visitStatus="C")&&(workName'=SuseID)&&(HZflag=1) d     //因为一次就诊在DHCRegistrationFee中只有一条记录，所以挂号员和退号员不一样时很难区分，需要存下来
   ..s tregnumN=0  ;挂号总数量
   ..s tregsumN=0  ;挂号总金额
   ..s trefnumN=1  ;退号数量
   ..if PartReturnSum'=0  s trefsumN="-"_PartReturnSum
   ..e  s trefsumN="-"_PRTAcount
   ..s thandnumN=-1
   ..;需要金额中减去退号钱
   ..if PartReturnSum'=0 s thandsumN="-"_PartReturnSum
   ..e  s thandsumN="-"_PRTAcount
   ..if '$d(^TmpRegPrt($j,"RegStatAllUsr",workName,Tarcdr)) d
   ...s ^TmpRegPrt($j,"RegStatAllUsr",workName,Tarcdr)=Tarcdr_"^"_tregnumN_"^"_tregsumN_"^"_trefnumN_"^"_trefsumN_"^"_thandnumN_"^"_thandsumN_"^"_PRTAcount_"^"_HBPrice
   ...;s ^TmpRegPrt($j,"BYZG",workName,Tarcdr,AdmReasonCode,PaadmRowid)=Tarcdr_"^"_tregnumN_"^"_tregsumN_"^"_trefnumN_"^"_trefsumN_"^"_thandnumN_"^"_thandsumN_"^"_PRTAcount_"^"_HBPrice
   ..e  d
   ...s gregnum=$p(^TmpRegPrt($j,"RegStatAllUsr",workName,Tarcdr),"^",2)
   ...s gregsum=$p(^TmpRegPrt($j,"RegStatAllUsr",workName,Tarcdr),"^",3)
   ...s grefnum=$p(^TmpRegPrt($j,"RegStatAllUsr",workName,Tarcdr),"^",4)
   ...s grefsum=$p(^TmpRegPrt($j,"RegStatAllUsr",workName,Tarcdr),"^",5)
   ...s ghandnum=$p(^TmpRegPrt($j,"RegStatAllUsr",workName,Tarcdr),"^",6)
   ...s ghandsum=$p(^TmpRegPrt($j,"RegStatAllUsr",workName,Tarcdr),"^",7)
   ...s gregnum=gregnum+tregnumN
   ...s gregsum=gregsum+tregsumN
   ...s grefnum=grefnum+trefnumN
   ...s grefsum=grefsum+trefsumN
   ...s ghandnum=ghandnum+thandnumN
   ...s ghandsum=ghandsum+thandsumN
   ...s ^TmpRegPrt($j,"RegStatAllUsr",workName,Tarcdr)=Tarcdr_"^"_gregnum_"^"_gregsum_"^"_grefnum_"^"_grefsum_"^"_ghandnum_"^"_ghandsum_"^"_PRTAcount_"^"_HBPrice
   ...s ^TmpRegPrt($j,"BYZG",workName,Tarcdr,AdmReasonCode,PaadmRowid)=Tarcdr_"^"_gregnum_"^"_gregsum_"^"_grefnum_"^"_grefsum_"^"_ghandnum_"^"_ghandsum_"^"_PRTAcount_"^"_HBPrice
   ..s Sregnum=Sregnum+tregnumN
   ..s Sregsum=Sregsum+tregsumN
   ..s Srefnum=Srefnum+trefnumN
   ..s Srefsum=Srefsum+trefsumN
   ..s Shandnum=Shandnum+thandnumN
   ..s Shandsum=Shandsum+thandsumN
   .;
   .if '$d(^TmpRegPrt($j,"RegStatAllUsr",SuseID,Tarcdr)) d
   ..s ^TmpRegPrt($j,"RegStatAllUsr",SuseID,Tarcdr)=Tarcdr_"^"_tregnum_"^"_tregsum_"^"_trefnum_"^"_trefsum_"^"_thandnum_"^"_thandsum_"^"_PRTAcount_"^"_HBPrice
   ..;特殊处理本院职工
   ..;s ^TmpRegPrt($j,"BYZG",SuseID,Tarcdr,AdmReasonCode,PaadmRowid)=Tarcdr_"^"_tregnum_"^"_tregsum_"^"_trefnum_"^"_trefsum_"^"_thandnum_"^"_thandsum_"^"_PRTAcount_"^"_HBPrice
   .e  d
   ..s gregnum=$p(^TmpRegPrt($j,"RegStatAllUsr",SuseID,Tarcdr),"^",2)
   ..s gregsum=$p(^TmpRegPrt($j,"RegStatAllUsr",SuseID,Tarcdr),"^",3)
   ..s grefnum=$p(^TmpRegPrt($j,"RegStatAllUsr",SuseID,Tarcdr),"^",4)
   ..s grefsum=$p(^TmpRegPrt($j,"RegStatAllUsr",SuseID,Tarcdr),"^",5)
   ..s ghandnum=$p(^TmpRegPrt($j,"RegStatAllUsr",SuseID,Tarcdr),"^",6)
   ..s ghandsum=$p(^TmpRegPrt($j,"RegStatAllUsr",SuseID,Tarcdr),"^",7)
   ..s gregnum=gregnum+tregnum
   ..s gregsum=gregsum+tregsum
   ..s grefnum=grefnum+trefnum
   ..s grefsum=grefsum+trefsum
   ..s ghandnum=ghandnum+thandnum
   ..s ghandsum=ghandsum+thandsum
   ..s ^TmpRegPrt($j,"RegStatAllUsr",SuseID,Tarcdr)=Tarcdr_"^"_gregnum_"^"_gregsum_"^"_grefnum_"^"_grefsum_"^"_ghandnum_"^"_ghandsum_"^"_PRTAcount_"^"_HBPrice
   ..;s ^TmpRegPrt($j,"BYZG",SuseID,Tarcdr,AdmReasonCode,PaadmRowid)=Tarcdr_"^"_gregnum_"^"_gregsum_"^"_grefnum_"^"_grefsum_"^"_ghandnum_"^"_ghandsum_"^"_PRTAcount_"^"_HBPrice
   .s Sregnum=Sregnum+tregnum
   .s Sregsum=Sregsum+tregsum
   .s Srefnum=Srefnum+trefnum
   .s Srefsum=Srefsum+trefsum
   .s Shandnum=Shandnum+thandnum
   .s Shandsum=Shandsum+thandsum
   .if HZflag=1 s SuseID=""
   s HandSum=0
   s TRegType=""
   s pUsr="" f  s pUsr=$o(^TmpRegPrt($j,"RegStatAllUsr",pUsr)) q:pUsr=""  d
   .s pTarc="" f  s pTarc=$o(^TmpRegPrt($j,"RegStatAllUsr",pUsr,pTarc)) q:pTarc=""  d
   ..s TUserCode=$p(^SSU("SSUSR",pUsr),"^",1)
   ..s TUserName=$p(^SSU("SSUSR",pUsr),"^",2)
   ..s TRegType=pTarc
   ..s TRegNum=$p(^TmpRegPrt($j,"RegStatAllUsr",pUsr,pTarc),"^",2)
   ..s TRegSum=$p(^TmpRegPrt($j,"RegStatAllUsr",pUsr,pTarc),"^",3)
   ..s TRefNum=$p(^TmpRegPrt($j,"RegStatAllUsr",pUsr,pTarc),"^",4)
   ..s TRefSum=$p(^TmpRegPrt($j,"RegStatAllUsr",pUsr,pTarc),"^",5)
   ..s THandNum=$p(^TmpRegPrt($j,"RegStatAllUsr",pUsr,pTarc),"^",6)
   ..s THandSum=$p(^TmpRegPrt($j,"RegStatAllUsr",pUsr,pTarc),"^",7)
   ..s TPRTAcount=$p(^TmpRegPrt($j,"RegStatAllUsr",pUsr,pTarc),"^",9)
   ..s THandSum=TRegSum+TRefSum
   ..s HandSum=HandSum+THandSum
   ..s TRegSum=$j(TRegSum,3,2)
   ..s TRefSum=$j(TRefSum,3,2)
   ..s THandSum=$j(THandSum,3,2)
   ..//得到本院职工数,不处理本院职工
   ..s BYnum=0
   ..;s BYnum=..GetBYZGnum(pUsr,pTarc,"12")
   ..Do OutputRow2
   ..s num=num+1
   ..s ^TMPRegRpPrt(ctloc,userid,num)=TUserCode_"^"_TUserName_"^"_TRegType_"^"_TRegNum_"^"_TRegSum_"^"_TRefNum_"^"_TRefSum_"^"_THandNum_"^"_THandSum_"^"_TPRTAcount_"^"_HBPrice
   ;合计
   ;判断是组长权限的时候合计列放在姓名列
   if TRegType=" " d
   .s TUserName="合计"
   .s TRegType=" "
   else  d
   .s TUserName=""
   .s TRegType="合计"
   s TUserCode=""
   s TPRTAcount=""  
   s TRegNum=Sregnum
   s TRegSum=Sregsum
   s TRefNum=Srefnum
   s TRefSum=Srefsum
   s THandNum=Shandnum
   s THandSum=Shandsum
   s TRegSum=$j(TRegSum,3,2)
   s TRefSum=$j(TRefSum,3,2)
   s THandSum=$j(HandSum,3,2)
   ;不处理本院职工
   s BYnum=""
   ;s BYnum=..GetBYZGSum("12")
   Do OutputRow2 
   s num=num+1 
   s ^TMPRegRpPrt(ctloc,userid,num)=TUserCode_"^"_TUserName_"^"_TRegType_"^"_TRegNum_"^"_TRegSum_"^"_TRefNum_"^"_TRefSum_"^"_THandNum_"^"_THandSum_"^"_TPRTAcount	
 	
 	Set QHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow2
    if SuseID="" s TPRTAcount=""
	set Data=$lb(TUserCode,TUserName,TRegType,TRegNum,TRegSum,TRefNum,TRefSum,THandNum,THandSum,TPRTAcount,BYnum)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod StatAllUsrFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatAllUsrExecute ]
{
 New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query StatAllUsr(StDate, EdDate, ctloc, userid, SuseID) As %Query(ROWSPEC = "TUserCode:%String,TUserName:%String,TRegType:%String,TRegNum:%String,TRegSum:%String,TRefNum:%String,TRefSum:%String,THandNum:%String,THandSum:%String,TPRTAcount:%String,BYnum:%String")
{
}

ClassMethod GetBYZGnum(User As %String, pTarc As %String, AdmReason As %String) As %String
{
	n (User,pTarc,AdmReason)
	s BYZGSum=0
	s numAdmID=""
	f  s numAdmID=$o(^TmpRegPrt($j,"BYZG",User,pTarc,AdmReason,numAdmID)) q:numAdmID=""  d
	.s BYZGSum=BYZGSum+1
	
	Q BYZGSum
}

ClassMethod GetBYZGSum(AdmReason As %String) As %String
{
	n (AdmReason)
	s BYZGSum=0
	s User=""
	f  s User=$o(^TmpRegPrt($j,"BYZG",User)) q:User=""  d
	.s pTarc=""
	.f  s pTarc=$o(^TmpRegPrt($j,"BYZG",User,pTarc)) q:pTarc=""  d
	..s numAdmID=""
	..f  s numAdmID=$o(^TmpRegPrt($j,"BYZG",User,pTarc,AdmReason,numAdmID)) q:numAdmID=""  d
	...s BYZGSum=BYZGSum+1
	
	Q BYZGSum
}

ClassMethod RegQueryClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = RegQueryExecute ]
{
 New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod RegQueryExecute(ByRef QHandle As %Binary, StDate As %String, EdDate As %String, StTime As %String, EdTime As %String, SuseID As %String, RLoc As %String, RDoc As %String, RType As %String, Rflag As %String, FeeNullCheck As %String, CardNo As %String, RegNo As %String, PatName As %String, MRRFlag As %String, DRCDRowid As %String, PayMode As %String) As %Status
{
   s ^tempscl("RegQueryExecute")=StDate_"^"_EdDate_"^"_StTime_"^"_EdTime_"^"_SuseID_"^"_RLoc_"^"_RDoc_"^"_RType_"^"_Rflag_"^"_FeeNullCheck_"^"_CardNo_"^"_RegNo_"^"_PatName_"^"_MRRFlag_"^"_DRCDRowid_"^"_PayMode
   ;w ##class(%ResultSet).RunQuery("web.DHCOPRegReports","RegQuery","62952","62952","","","","","","","on","","","","","")
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   s StDate=..%ZDH(StDate)
   s EdDate=..%ZDH(EdDate)
   i (StDate="")!(EdDate="") Set QHandle=$lb(0,repid,0) Quit $$$OK
   s SelfHosp=$p(PayMode,"^",2)
   s TelHome=$p(PayMode,"^",3)
   s MarkDoc=$p(PayMode,"^",4)
   s SessionTypeStr=$p(PayMode,"^",5)
   s TimeRange=$p(PayMode,"^",6)
   s PayMode=$p(PayMode,"^",1)
	
   i StTime'="",StTime[":" s StTime=..%ZTH(StTime,1)
   i EdTime'="",EdTime[":"  s EdTime=..%ZTH(EdTime,1)
   s logonUserID=%session.Get("LOGON.USERID")
   lock ^TMPRegQuery(logonUserID):3
   k ^TMPRegQuery(logonUserID)
   s CardRowId="",PapmiDR="",CFActiveFlag=""
   if CardNo'="" d
   .s CardRowId=""
   .f  s CardRowId=$o(^DHCCARDi("CF",0,"CardNo",CardNo,CardRowId)) q:(CardRowId="")||(CFActiveFlag="N")  d
   ..//q:CardRowId=""
   ..s PapmiDR=$p(^DHCCARD("CF",CardRowId),"^",4)
   ..s CFActiveFlag=$p(^DHCCARD("CF",CardRowId),"^",10)
   if ((CardNo'="")&&(CFActiveFlag'="N")) Set QHandle=$lb(0,repid,0) Quit $$$OK
   s SumNumI=0
   s UsrName=""
   i SuseID'=""  s UsrName=$p(^SSU("SSUSR",SuseID),"^",2)
   f pdate=StDate:1:EdDate  d
   .s TSum=0
   .s PaadmRowid="" f  s PaadmRowid=$o(^PAADMi("PAADM_AdmDate",pdate,PaadmRowid)) q:PaadmRowid=""  d
   ..s PrtAcount=0
   ..s createuser=$p($g(^PAADM(PaadmRowid)),"^",43) ;pa_adm.PAADM_CreateUser
   ..q:createuser=""
   ..s refuser=$p($g(^PAADM(PaadmRowid,2)),"^",69)  ;PAADM_SocialWorkername
   ..q:(createuser'=SuseID)&(SuseID'="") //&(refuser'=SuseID)&(Rflag'="on")
   ..s time=$p($g(^PAADM(PaadmRowid)),"^",7) ;pa_adm.paadm_admtime
   ..q:(pdate=StDate)&(time<StTime)&(StTime'="") ;(pdate=StDate)&
   ..q:(pdate=EdDate)&(time>EdTime)&(EdTime'="") ;(pdate=EdDate)&
   ..s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
   ..s MRFlag=0 ;已就诊退号
   ..i (MRRFlag="on")&&(VisitStatus="C") d
   ...s MRFlag=..HadMR(PaadmRowid) ;已就诊退号
   ..q:(MRRFlag="on")&&(MRFlag=0)
   ..q:(Rflag="on")&(VisitStatus'="C")
   ..q:((Rflag="")&&(MRRFlag=""))&(VisitStatus="C")
   ..//q:(refuser'=SuseID)&(SuseID'="")&(Rflag="on")
   ..s (Uptime,UpDate)=""
   ..s:VisitStatus="C" Uptime=$p($g(^PAADM(PaadmRowid,1)),"^",43) ;paadm.paadm_updatetime
   ..s:VisitStatus="C" UpDate=$p($g(^PAADM(PaadmRowid,1)),"^",42)
   ..s DepCodeDR=$p($g(^PAADM(PaadmRowid)),"^",4) ;pa_adm.PAADM_DepCode_DR
   ..q:(DepCodeDR'=RLoc)&(RLoc'="")
   ..s hospId=""
   ..i DepCodeDR'="" s hospId=$p(^CTLOC(DepCodeDR),"^",22)
   ..q:(SelfHosp'="")&&(hospId'=SelfHosp)
   ..s AdmDocCodeDR=$p($g(^PAADM(PaadmRowid)),"^",9) ;pa_adm.PAADM_AdmDocCodeDR
   ..Set QueRowid=$O(^User.DHCQueueI("QuePaadmDrIndex",PaadmRowid,""))
   ..s AriverDocDR="",TArriveDoc="",TRoom=""
   ..if QueRowid'="" d
   ...Set QueObj=##Class(User.DHCQueue).%OpenId(QueRowid)
   ...Set AriverDocDR=QueObj.QueDocDrGetObjectId()
   ...Set AdmDocCodeDR=QueObj.QueMarkDrGetObjectId()
   ...Set RoomDr=QueObj.QueRoomDrGetObjectId()
   ...if RoomDr'=""  set TRoom =$p(^CTLOC(RoomDr),"^",2)
   ...Do QueObj.%Close()
   ..b ;09323
   ..q:((AriverDocDR'=RDoc)&&(RDoc'="")) //(AriverDocDR'="")&&
   ..q:(AdmDocCodeDR'=MarkDoc)&(MarkDoc'="")
   ..if AriverDocDR'="" s TArriveDoc=$p($g(^CTPCP(AriverDocDR,1)),"^",2)
   ..s PapmiId=$p($g(^PAADM(PaadmRowid)),"^",1) ;pa_patmas.rowid
   ..q:(PapmiDR'="")&(PapmiId'=PapmiDR)
   ..s PapmiNo=$p($g(^PAPER(PapmiId,"PAT",1)),"^",1)
   ..q:(RegNo'="")&(PapmiNo'=RegNo)
   ..s TTelHome=$p($g(^PAPER(PapmiId,"PER",1)),"^",11)
   ..q:(TelHome'="")&(TelHome'=TTelHome)
   ..s RegConDisDR=$p($g(^PAADM(PaadmRowid,"DHC")),"^",25)
   ..s TRCDDesc=""
   ..i RegConDisDR'=""  s TRCDDesc=$p($g(^DHCRCD(RegConDisDR)),"^",2)
   ..q:(DRCDRowid'="")&&(RegConDisDR'=DRCDRowid)
   ..;s invRowid=0 f  s invRowid=$o(^DHCBCI(0,"ADM",PaadmRowid,invRowid)) q:invRowid=""  d
   ..;.Q:'$d(^DHCINVPRT(invRowid))
   ..;.s FariType=$p(^DHCINVPRT(invRowid),"^",34)
   ..;.q:FariType'="R"
   ..;.s PrtAcount=$p(^DHCINVPRT(invRowid),"^",1)
   ..s Admi=PaadmRowid
   ..s RegisFee=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
   ..i RegisFee'=""  d
   ...s RegfeeArcPrice=$List(^User.DHCRegistrationFeeD(RegisFee),4)
   ...s Tarcdrid=$List(^User.DHCRegistrationFeeD(RegisFee),19)
   ...s Tarcdr=""
   ...s:Tarcdrid'="" Tarcdr=$p($g(^RBC("SESS",Tarcdrid)),"^",2)   //出诊级别
   ...s TPayMode=""
   ...s InvoiceDr=$List(^User.DHCRegistrationFeeD(RegisFee),11)
   ...i InvoiceDr'=""  d
   ....s TPayMode=$tr(##class(web.DHCOPAdmReg).GetINVPayMode(InvoiceDr),",",";")
   ...s INVPayMode=""
   ...i PayMode'=""  s INVPayMode=$P($g(^CT("CTPM",PayMode)),"^",2)
   ...q:((PayMode'="")&(TPayMode'[INVPayMode))
   ...s TInvNo=""
   ...s:InvoiceDr'="" TInvNo=$p($g(^DHCINVPRT(+InvoiceDr)),"^",14)
   ...if InvoiceDr'="" s PrtAcount=$p($g(^DHCINVPRT(InvoiceDr)),"^",16)
   ...;q:(PrtAcount=0)&(FeeNullCheck="on") ;lxz如果是便民门诊没有发票记录的话收费后PrtAcount为0改为在最后判断
   ...s RegfeeArcDr=$List(^User.DHCRegistrationFeeD(RegisFee),3)
   ...q:(RegfeeArcDr'=RType)&(RType'="")
   ...s papmidr=$p($g(^PAADM(PaadmRowid)),"^",1) ;pa_adm.paadm_papmi_dr
   ...s TPatName=$p($g(^PAPER(papmidr,"ALL")),"^",1)
   ...q:(PatName'="")&&(TPatName'[PatName)
   ...//s TPatMNo=$p($g(^PAPER(papmidr,"PAT",1)),"^",22) ;PAPMI_Medicare
   ...s TPatMNo=##class(web.DHCDocOrderCommon).GetMrNo("",papmidr,"O") //
   ...s TPatNo=$p($g(^PAPER(papmidr,"PAT",1)),"^",1)
   ...//挂号职称
   ...s RegfeeRBASDr=$list(^User.DHCRegistrationFeeD(RegisFee),18)
   ...s TSessionType=""
   ...s SessionTypeDr=$P($g(^RBAS(+RegfeeRBASDr,$P(RegfeeRBASDr,"||",2),"DHC")),"^",6)
   ...if SessionTypeDr'="" s TSessionType=$P(^RBC("SESS",SessionTypeDr),"^",2)
   ...q:((SessionTypeStr'="")&&(SessionTypeStr'[TSessionType))
   ...s TPatCardNo=##class(DHCDoc.Common.pa).GetAdmRegCard(PaadmRowid)
   ...s:TPatCardNo'="" TPatCardNo=$p(TPatCardNo,"^",1)
   ...s EmployeeFunction="",SecretLevel=""
	...s PatEncryptLevel=##class(web.DHCBL.CARD.UCardPaPatMasInfo).GetPatEncryptLevel(papmidr,.ErrMsg)
	...i PatEncryptLevel'="" d
	....s EmployeeFunction=$p(PatEncryptLevel,"^",2)
	....s SecretLevel=$p(PatEncryptLevel,"^",4)
   ...s TRegLoc=""
   ...i DepCodeDR'=""  d
   ....s TRegLoc=$p($g(^CTLOC(DepCodeDR)),"^",2) 
   ....i $f(TRegLoc,"-")'=0  d
   .....s TRegLoc=$p(TRegLoc,"-",2)
   ...s TRegDoc=""
   ...i AdmDocCodeDR'=""  s TRegDoc=$p($g(^CTPCP(AdmDocCodeDR,1)),"^",2)
   ...s TArcType=""
   ...i RegfeeArcDr'=""  s TArcType=$p($g(^CTLOC(RegfeeArcDr)),"^",2)
   ...s TRegDate=..%ZD(pdate) //$zd(pdate,3)
   ...s ConRowId="",TAppFee=0,TRegFee=0,TCheckFee=0,TOtherFee=0
   ...if (InvoiceDr'="")	s ConRowId=$O(^DHCBCI(0,"INV",InvoiceDr,0)) 
   ...s PBRowId=""
   ...i ConRowId'="" 	s PBRowId=$P(^DHCBCI(ConRowId),"^",2) 
   ...if PBRowId'="" D
   ....s PBOChild=0 f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
   .....Q:($d(^DHCPB(PBRowId,"O",PBOChild))=10)
   .....s ArcimId=$P(^DHCPB(PBRowId,"O",PBOChild),"^",3)
   .....Q:ArcimId=""
   .....s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
   .....s BillSum=0
   .....s BillSum=$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
   .....i type="App" s TAppFee=TAppFee+BillSum
   .....e  d
   ......i (type="Reg") d
   .......s TRegFee=TRegFee+BillSum
   ......e  d
   .......i (type="Check") d
   ........s TCheckFee=TCheckFee+BillSum
   .......e  d
   ........s TOtherFee=TOtherFee+BillSum
   ...if (VisitStatus="C") d
   ....s GetStr=..GetAdmRegSum(PaadmRowid)
   ....s TAppFee=$P(GetStr,"^",7) s TRegFee=$P(GetStr,"^",2) s TCheckFee=$P(GetStr,"^",3)
   ...if (InvoiceDr="") d
   ....s GetStr=..GetBMAdmRegSum(PaadmRowid)
   ....s TAppFee=$P(GetStr,"^",7) s TRegFee=$P(GetStr,"^",2) s TCheckFee=$P(GetStr,"^",3)
   ...s TTotalFee=TAppFee+TRegFee+TCheckFee+TOtherFee
   ...q:(TTotalFee=0)&(FeeNullCheck="on") ;lxz修改为判断总价
   ...;s TTotalFee=$List(^User.DHCRegistrationFeeD(RegisFee),4)  ;RegfeeArcPrice
   ...s TFormFee=$j(TOtherFee,3,2)
   ...;s TExamFee=$List(^User.DHCRegistrationFeeD(RegisFee),9)  ;RegfeeLookPrice
   ...;s TRegFee=TTotalFee-TExamFee
   ...s TRegFee=$j(TRegFee,3,2)
   ...s TExamFee=$j(TCheckFee,3,2)
   ...//此处是解决便民挂号时，选择不收诊查费，但是界面金额显示错误
   ...i InvoiceDr="",+RegfeeArcPrice'=0 s TExamFee=$j(RegfeeArcPrice-TRegFee-TFormFee,3,2) 
   ...s TUsrCode=$p($g(^SSU("SSUSR",$g(createuser))),"^",1) ;ss_user.ssusr_initials
   ...s TUsrName=$p($g(^SSU("SSUSR",$g(createuser))),"^",2) ;ss_user.ssusr_name
   ...s RegTime=$List(^User.DHCRegistrationFeeD(RegisFee),16)
   ...s TRegTime=..%ZT(RegTime,1)
   ...s TRefUsr="",TRefUsrname=""
   ...i refuser'=""  d
   ....s TRefUsr=$p($g(^SSU("SSUSR",refuser)),"^",1) ;$p($g(^SSU("SSUSR",refuser)),"^",1) ;ss_user.ssusr_initials
   ....s TRefUsrname=$p($g(^SSU("SSUSR",refuser)),"^",2)
   ...s TRefTime=""
   ...i Uptime'=""  s TRefTime=..%ZT(Uptime,1)
   ...i UpDate'="" s UpDate=..%ZD(UpDate)
   ...if UpDate'="" s TRefTime=UpDate_" "_TRefTime
   ...s TRegNo=$List(^User.DHCRegistrationFeeD(RegisFee),8)  ;RegfeeNo
   ...s TRegType=""
   ...;s ^GWJ=$d(^User.DHCBeforeRegI("ADM",Admi))
   ...;if $d(^User.DHCBeforeRegI("ADM",Admi))'=0  d
   ...;.s Befreg=$o(^User.DHCBeforeRegI("ADM",Admi,""))
   ...;.s BefregType=$List(^User.DHCBeforeRegD(Befreg),11)
   ...;.i BefregType="1"  s TRegType="即日"
   ...;.i BefregType="2"  s TRegType="网上预约"
   ...;.i BefregType="5"  s TRegType="医生加号"
   ...;建议就诊时段
   ...s RegfeeRBASDr=$list(^User.DHCRegistrationFeeD(RegisFee),18)
   ...s TimRangeDr=$list(^User.DHCRegistrationFeeD(RegisFee),21)
   ...q:((TimRangeDr'=TimeRange)&&(TimeRange'=""))
   ...s TimeRangeDesc=""
   ...s TimeRangeInfo=""
   ...i TimRangeDr'="" s TimeRangeDesc=$P($G(^DHCTimeRange(TimRangeDr)),"^",2)
   ...i (+TRegNo'=0)&&(RegfeeRBASDr'="") d
   ....s TimeRangeInfo=##class(web.DHCRBApptSchedule).GetTimeRangeRegInfo(RegfeeRBASDr,TRegNo,"")
   ...s RegDate=$list(^User.DHCRegistrationFeeD(RegisFee),15)
   ...i RegDate'="" s RegDate=..%ZD(RegDate) //$ZD(RegDate,3)
   ... //挂号类型
   ...i $D(^RBAS("PAADM_DR",PaadmRowid)) d
   ....s resID=$O(^RBAS("PAADM_DR",PaadmRowid,""))
   ....s resSub=$O(^RBAS("PAADM_DR",PaadmRowid,resID,""))
   ....s apptSub=$O(^RBAS("PAADM_DR",PaadmRowid,resID,resSub,""))
   ....s methodDR=$P(^RBAS(resID,resSub,"APPT",apptSub),"^",12)
   ....q:methodDR=""
   ....s TRegType=$P(^RBC("APTM",methodDR),"^",2)
   ...e  s TRegType="即日"
   ...s TAddflag=""
   ...s Regfeetemp2=$Lg(^User.DHCRegistrationFeeD(RegisFee),12)  ;Regfeetemp2
   ...i ((Regfeetemp2="1")||(TRegType["加号")||(TRegNo["+"))  s TAddflag="加号"
   ...e  s TAddflag="普通"
   ...s THandDate=""
   ...s PRTRowid=$List(^User.DHCRegistrationFeeD(RegisFee),11)  ;Regfeetemp1
   ...i PRTRowid'=""  d
   ....s HandinDate=$p($g(^DHCINVPRT(PRTRowid)),"^",11)
   ....i HandinDate'=""  s THandDate=..%ZD(HandinDate) //$zd(HandinDate,3)
   ...s TRegTime=RegDate_" "_TRegTime
   ...s SumNumI=SumNumI+1
   ...s TabReturnReason=""
   ...s ReturnReasonDr=$P($G(^PAADM(PaadmRowid,"DHC")),"^",27)
   ...s:ReturnReasonDr'="" TabReturnReason=$P($G(^ReturnReason(ReturnReasonDr)),"^",2)
   ...s ReturnReason=$P($G(^PAADM(PaadmRowid,"DHC")),"^",71)
   ...s:ReturnReason'="" TabReturnReason=TabReturnReason_"("_ReturnReason_")"
   ...if TimeRangeDesc'="" s TRegDoc=TRegDoc_"("_TimeRangeDesc_")"
   ...s TAdmReasonDesc = ##class(DHCDoc.OPDoc.AjaxInterface).GetAdmReason($g(PaadmRowid))	// 费别描述
   ...s PAPMIDVAnumber=$p($g(^PAPER(papmidr,"PAT",3)),"^",6)
   ...s CredType=""
   ...s myCredTypeID=$p($g(^PAPER(papmidr,"PAT",3)),"^",7)
   ...s:myCredTypeID'="" CredType=$p($g(^PAC("CARD",myCredTypeID)),"^",2)
   ...s CredNo=$p($g(^PAPER(papmidr,"PAT",3)),"^",6)
   ...if CredNo'="" s PAPMIDVAnumber=CredType_":"_CredNo
   ...s TRegSource=##class(DHCDoc.Common.pa).GetAdmRegType(PaadmRowid)
   ...s:TRegSource'="" TRegSource=$p(TRegSource,"^",2)
   ...s ^TMPRegQuery(logonUserID,SumNumI)=TPatNo_"^"_TPatMNo_"^"_TPatName_"^"_TRegLoc_"^"_TRegDoc_"^"_Tarcdr_"^"_TRegDate_"^"_TRegFee_"^"_TFormFee_"^"_TExamFee_"^"_TUsrCode_"^"_TUsrName_"^"_TRegTime_"^"_TRefUsr_"^"_TRefTime_"^"_TRegNo_"^"_TRegType_"^"_TAddflag_"^"_THandDate_"^"_TPatCardNo_"^"_TInvNo_"^"_RegisFee_"^"_TRefUsrname_"^"_EmployeeFunction_"^"_SecretLevel_"^"_TimeRangeInfo_"^"_TabReturnReason_"^"_TRCDDesc_"^"_TPayMode_"^"_TTelHome_"^"_TArriveDoc_"^"_TSessionType_"^"_TRoom_"^"_TAdmReasonDesc_"^"_PAPMIDVAnumber_"^"_TRegSource
   s TTotal=SumNumI
   f k=1:1:TTotal  d
   .s TPatNo=$p(^TMPRegQuery(logonUserID,k),"^",1)
   .s TPatMNo=$p(^TMPRegQuery(logonUserID,k),"^",2)
   .s TPatName=$p(^TMPRegQuery(logonUserID,k),"^",3)
   .s TRegLoc=$p(^TMPRegQuery(logonUserID,k),"^",4)
   .s TRegDoc=$p(^TMPRegQuery(logonUserID,k),"^",5)
   .s TArcType=$p(^TMPRegQuery(logonUserID,k),"^",6)
   .s TRegDate=$p(^TMPRegQuery(logonUserID,k),"^",7)
   .s TRegFee=$p(^TMPRegQuery(logonUserID,k),"^",8)
   .s TFormFee=$p(^TMPRegQuery(logonUserID,k),"^",9)
   .s TExamFee=$p(^TMPRegQuery(logonUserID,k),"^",10)
   .s TUsrCode=$p(^TMPRegQuery(logonUserID,k),"^",11)
   .s TUsrName=$p(^TMPRegQuery(logonUserID,k),"^",12)
   .s TRegTime=$p(^TMPRegQuery(logonUserID,k),"^",13)
   .s TRefUsr=$p(^TMPRegQuery(logonUserID,k),"^",14)
   .s TRefTime=$p(^TMPRegQuery(logonUserID,k),"^",15)
   .s TRegNo=$p(^TMPRegQuery(logonUserID,k),"^",16)
   .s TRegType=$p(^TMPRegQuery(logonUserID,k),"^",17)
   .s TAddflag=$p(^TMPRegQuery(logonUserID,k),"^",18)
   .s THandDate=$p(^TMPRegQuery(logonUserID,k),"^",19)
   .s TPatCardNo=$p(^TMPRegQuery(logonUserID,k),"^",20)
   .s TInvNo=$p(^TMPRegQuery(logonUserID,k),"^",21)
   .s TRegisFee=$p(^TMPRegQuery(logonUserID,k),"^",22)
   .s TRefUsrname=$p(^TMPRegQuery(logonUserID,k),"^",23)
   .s TPoliticalLevel=$p(^TMPRegQuery(logonUserID,k),"^",24)
   .s TSecretLevel=$p(^TMPRegQuery(logonUserID,k),"^",25)
   .s TimeRangeInfo=$p(^TMPRegQuery(logonUserID,k),"^",26)
   .s TabReturnReason=$p(^TMPRegQuery(logonUserID,k),"^",27)
   .s TRCDDesc=$p(^TMPRegQuery(logonUserID,k),"^",28)
   .s TPayMode=$p(^TMPRegQuery(logonUserID,k),"^",29)
   .s TTelHome=$p(^TMPRegQuery(logonUserID,k),"^",30)
   .s TArriveDoc=$p(^TMPRegQuery(logonUserID,k),"^",31)
   .s TSessionType=$p(^TMPRegQuery(logonUserID,k),"^",32)
   .s TRoom=$p(^TMPRegQuery(logonUserID,k),"^",33)
   .s TAdmReasonDesc=$p(^TMPRegQuery(logonUserID,k),"^",34)
   .s PAPMIDVAnumber=$p(^TMPRegQuery(logonUserID,k),"^",35)
   .s TRegSource=$p(^TMPRegQuery(logonUserID,k),"^",36)
   .Do OutputRow3
   
   lock -^TMPRegQuery(logonUserID)
   ;k ^TMPRegQuery($j)   
 	Set QHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow3
	set Data=$lb(TPatCardNo,TPatNo,TPatMNo,TPatName,TRegLoc,TRegDoc,TRegDate,TRegFee,TFormFee,TExamFee,TUsrCode,TUsrName,TRegTime,TRefUsr,TRefUsrname,TRefTime,TRegNo,TRegType,TAddflag,THandDate,TInvNo,TRegisFee,TPoliticalLevel,TSecretLevel,TimeRangeInfo,TabReturnReason,TRCDDesc,TPayMode,TTelHome,TArriveDoc,TSessionType,TRoom,TAdmReasonDesc,PAPMIDVAnumber,TRegSource)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod RegQueryFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegQueryExecute ]
{
 New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query RegQuery(StDate, EdDate, StTime, EdTime, SuseID, RLoc, RDoc, RType, Rflag, FeeNullCheck, CardNo, RegNo, PatName, MRRFlag As %String = "", DRCDRowid As %String = "", PayMode As %String = "") As %Query(ROWSPEC = "TPatCardNo:%String:卡号,TPatNo:%String:登记号,TPatMNo:%String:病案号,TPatName:%String:患者姓名,TRegLoc:%String:科室,TRegDoc:%String:医生(号别),TRegDate:%String:就诊日期,TRegFee:%String:挂号费,TFormFee:%String:工本费,TExamFee:%String:诊疗费,TUsrCode:%String:挂号员,TUsrName:%String:挂号员姓名,TRegTime:%String:挂号时间,TRefUsr:%String:退号员,TRefUsrname:%String:退号员姓名,TRefTime:%String:退号时间,TRegNo:%String:顺序号,TRegType:%String:挂号类型,TAddflag:%String:加号,THandDate:%String:结账日期,TInvNo:%String:发票号,TRegisFee:%String:挂号流水表ID,TPoliticalLevel:%String:患者级别,TSecretLevel:%String:患者密级,TimeRangeInfo:%String:建议就诊时段,TabReturnReason:%String:退号原因,TRCDDesc:%String:优惠,TPayMode:%String:支付方式,TTelHome:%String:联系电话,TArriveDoc:%String:看诊医生,TSessionType:%String:挂号职称,TRoom:%String:诊室,TAdmReasonDesc:%String:就诊费别,PAPMIDVAnumber:%String:证件号码,TRegSource:%String:挂号渠道")
{
}

ClassMethod GetRPtRow(ctloc As %String, userid As %String)
{
 s userName=""
 if userid'="" s userName=$p(^SSU("SSUSR",userid),"^",2)
 s ll=0,t=0
 f  s t=$o(^TMPRegRpPrt(ctloc,userid,t)) q:(t="")!(t=0)  d
   .s ll=t
 q ll_"^"_userName
}

ClassMethod GetRPtRowInf(ctloc As %String, userid As %String, t As %String)
{
 s ret=""
 s ret=$g(^TMPRegRpPrt(ctloc,userid,t))
 q ret
}

ClassMethod OPDoclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPDoclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod OPDoclookupExecute(ByRef qHandle As %Binary, locid As %String, DocDesc As %String, HospID = "") As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
    s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
    s DocDesc=$$ALPHAUP^SSUTIL4(DocDesc)
	s OPDocdesc="",rowid="0"
	i locid'="" d
	.s RowId="0" f  Set RowId=$o(^RB("RES",0,"CTLOC",locid,RowId)) quit:RowId=""  d
	..Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("RB_Resource",RowId,HospID)
	..Set DocDr=""
	..If ($D(^RB("RES",RowId))) do 
	...Set DocDr=$p(^RB("RES",RowId),"^",2)
	..If DocDr="" Quit
	..s ActiveFrom=$p(^RB("RES",RowId),"^",22)
	..Q:(ActiveFrom'="")&&(ActiveFrom>+$h)
	..s ActiveTo=$p(^RB("RES",RowId),"^",23)
	..Q:(ActiveTo'="")&&(ActiveTo<=..%SysDate())
	..Q:('$d(^CTPCP(DocDr,1)))
	..s ActiVeFlag=$p(^CTPCP(DocDr,1),"^",9)
	..Q:ActiVeFlag'="Y"
	..s OPDocdesc=$p(^CTPCP(DocDr,1),"^",2)
	..s OtherDesc=""
	..s OtherDesc=$p($g(^CTPCP(DocDr,3)),"^",28)
	..s OtherDesc=OtherDesc_OPDocdesc
	..s OtherDesc=$$ALPHAUP^SSUTIL4(OtherDesc)
	..q:(DocDesc'="")&&(OtherDesc'[DocDesc)
	..s rowid=DocDr
 	..d OutputRow9
 	e  d
 	.s DocDr=0
 	.f  s DocDr=$o(^CTPCP(DocDr)) q:DocDr=""  d
 	..Q:"N"=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_CareProv",DocDr,HospID)
 	..s ActiVeFlag=$p(^CTPCP(DocDr,1),"^",9)
	..Q:ActiVeFlag'="Y"
 	..s OPDocdesc=$p(^CTPCP(DocDr,1),"^",2)
	..s OtherDesc=""
	..s OtherDesc=$p($g(^CTPCP(DocDr,3)),"^",28)
	..s OtherDesc=OtherDesc_OPDocdesc
	..s OtherDesc=$$ALPHAUP^SSUTIL4(OtherDesc)
	..q:(DocDesc'="")&&(OtherDesc'[DocDesc)
	..s rowid=DocDr
	..d OutputRow9
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
    s Code=$p(^CTPCP(rowid,1),"^",1)
	set Data=$lb(OPDocdesc,rowid,Code)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OPDoclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPDoclookupExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query OPDoclookup(locid As %String, DocDesc As %String = "", HospID = "") As %Query(ROWSPEC = "OPLocdesc:%String,rowid:%String,Code:%String")
{
}

ClassMethod ArtypelookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = ArtypelookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod ArtypelookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    If $g(ind)="" Set ind=1
	s Artypedesc="",rowid="0"
	s rowid="0" f  Set rowid=$o(^CTLOC(0,"LocType","OR",rowid)) quit:rowid=""  d
	.Set Artypedesc=$p($g(^CTLOC(rowid)),"^",2)
	.if desc'=""  d
	..i Artypedesc[desc  d
	...d OutputRow8
	.e  d
	..d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
    
	set Data=$lb(Artypedesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod ArtypelookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = ArtypelookupExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

Query Artypelookup(desc As %String) As %Query(ROWSPEC = "Artypedesc:%String,rowid:%String")
{
}

ClassMethod RegHandQueryClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = RegHandQueryExecute ]
{
 New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod RegHandQueryExecute(ByRef QHandle As %Binary, StDate As %String, EdDate As %String, SuseID As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   ;s ^GWJ=StDate_"^"_EdDate_"^"_StTime_"^"_EdTime_"^"_SuseID_"^"_RLoc_"^"_RDoc_"^"_RType
   i (StDate="")!(EdDate="") Set QHandle=$lb(0,repid,0) Quit $$$OK
   ;s Sdate=$ZDH(StDate,1)
   ;s Edate=$ZDH(EdDate,1)
   ;i StTime'="" s StTime=..%ZTH(StTime,1)
   ;i EdTime'=""  s EdTime=..%ZTH(EdTime,1)
   
   s i=0
   s UsrName=""
   i SuseID'=""  d
   .s TRUserName=$p(^SSU("SSUSR",SuseID),"^",2)
   .s TRUser=$p(^SSU("SSUSR",SuseID),"^",1)
   f pdate=StDate:1:EdDate  d
   .s HISRowid="" f  s HISRowid=$o(^DHCOPInsFootI(0,"Date",pdate,HISRowid)) q:HISRowid=""  d
   ..s Note3=$p(^DHCOPInsFoot(HISRowid),"^",60)
   ..s HISUser=$p(^DHCOPInsFoot(HISRowid),"^",8)
   ..q:HISUser'=SuseID
   ..s THandDate=$p(^DHCOPInsFoot(HISRowid),"^",2)
   ..s THandTime=$p(^DHCOPInsFoot(HISRowid),"^",7)
   ..s THandDate=$ZD(THandDate,3)
   ..s THandTime=..%ZT(THandTime,1)
   ..s HISEndDate=$p(^DHCOPInsFoot(HISRowid),"^",3)
   ..s HISEndTime=$p(^DHCOPInsFoot(HISRowid),"^",4)
   ..s HISStartDate=$p(^DHCOPInsFoot(HISRowid),"^",5)
   ..s HISStartTime=$p(^DHCOPInsFoot(HISRowid),"^",6)
   ..s HISEndDate=$ZD(HISEndDate,3)
   ..s HISStartDate=$zd(HISStartDate,3)
   ..s HISEndTime=..%ZT(HISEndTime,1)
   ..s HISStartTime=..%ZT(HISStartTime,1)
   ..s THandTiminfo=HISStartDate_" "_HISStartTime_"--"_HISEndDate_" "_HISEndTime
   ..s THandNum=0,THandSum=0
   ..s THNorNum=0,THNorSum=0
   ..s THRefNum=0,THRefSum=0
   ..s ToTnum=0
   ..s PRTrowid="" f  s PRTrowid=$o(^DHCINVPRT(0,"Report",HISRowid,PRTrowid)) q:PRTrowid=""  d
   ...;s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1) ;费用总额；操作员收取的现金；
   ...s PRTPatientShare=$p($g(^DHCINVPRT(PRTrowid)),"^",16)
   ...s PRTAcount=PRTPatientShare
   ...s Flag=$p($g(^DHCINVPRT(PRTrowid)),"^",8)  ;票据标志；Normal;Abort;Strike等
   ...s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)		;原票据的RowID
   ...s PrtNO=$p(^DHCINVPRT(PRTrowid),"^",14)
   ...s ToTnum=ToTnum+1
   ...i (Flag="S")&&(PrtinvDr'="")  s iPrtid=" "_PrtinvDr
   ...e  s iPrtid=" "_PRTrowid
   ...;本收款员收取的票据?
   ...i ((Flag="N")||((PrtinvDr="")&&(Flag'="N")))  d
   ....;b  ;;;;;Normal  Invoice
   ....s THNorNum=THNorNum+1
   ....s THNorSum=THNorSum+PRTAcount
   ...;本收款员红冲得单据  退号是红冲   
   ...i (Flag="S")&&(PrtinvDr'="")  d
   ....s THRefNum=THRefNum+1
   ....s THRefSum=THRefSum+PRTAcount
   ..s THandNum=THNorNum-THRefNum
   ..s THandSum=THNorSum+THRefSum
   ..s TRowid=HISRowid
   ..s THandSum=$j(THandSum,3,2)
   ..s THNorSum=$j(THNorSum,3,2)
   ..s THRefSum=$j(THRefSum,3,2)
   ..Do OutputRow4
   
   k ^TMPRegQuery($j)   
 	Set QHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow4
                //TPatNo,TPatMNo,TPatName,TRegLoc,TRegDoc,TArcType,TRegDate,TRegFee,TFormFee,TExamFee,TUsrCode,TUsrName,TRegTime,TRefUsr,TRefTime,TRegNo,TRegType,TAddflag,THandDate)
	set Data=$lb(TRowid,TRUser,TRUserName,THandDate,THandTime,THandNum,THandSum,THNorNum,THNorSum,THRefNum,THRefSum,THandTiminfo,ToTnum)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod RegHandQueryFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegHandQueryExecute ]
{
 New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query RegHandQuery(StDate, EdDate, SuseID) As %Query(ROWSPEC = "TRowid:%String,TRUser:%String,TRUserName:%String,THandDate:%String,THandTime:%String,THandNum:%String,THandSum:%String,THNorNum:%String,THNorSum:%String,THRefNum:%String,THRefSum:%String,THandTiminfo:%String,ToTnum:%String")
{
}

ClassMethod RegNoHandQueryClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = RegNoHandQueryExecute ]
{
 New repid
 Set repid=$li(QHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

ClassMethod RegNoHandQueryExecute(ByRef QHandle As %Binary, StDate As %String, EdDate As %String) As %Status
{
   Set repid=$I(^CacheTemp)
   If $g(ind)="" Set ind=1
   ;s ^GWJ=StDate_"^"_EdDate_"^"_StTime_"^"_EdTime_"^"_SuseID_"^"_RLoc_"^"_RDoc_"^"_RType
   i (StDate="")!(EdDate="") Set QHandle=$lb(0,repid,0) Quit $$$OK
   ;s Sdate=$ZDH(StDate,1)
   ;s Edate=$ZDH(EdDate,1)
   ;i StTime'="" s StTime=..%ZTH(StTime,1)
   ;i EdTime'=""  s EdTime=..%ZTH(EdTime,1)
   k ^tmplist("REGNO",$j)
   s kind=0,ii=0
   f prtdate=StDate:1:EdDate  d
	.s PRTrowid=""  f  s PRTrowid=$o(^DHCINVPRT(0,"Date",prtdate,PRTrowid))  q:PRTrowid=""  d
	..s FairType=$p(^DHCINVPRT(PRTrowid),"^",34)
    ..q:FairType'="R"   ;是否是挂号数据
    ..s Handflag=$p(^DHCINVPRT(PRTrowid),"^",10)
    ..q:Handflag="Y"   ;是否结算；
	..;s PRTAcount=$p(^DHCINVPRT(PRTrowid),"^",1)
	..s PRTPatientShare=$p(^DHCINVPRT(PRTrowid),"^",16)
	..s PRTAcount=PRTPatientShare
	..s PRTUsr=$p(^DHCINVPRT(PRTrowid),"^",21)
	..s Flag=$p(^DHCINVPRT(PRTrowid),"^",8)  ;票据标志
	..s PrtinvDr=$p(^DHCINVPRT(PRTrowid),"^",13)
	..i $d(^tmplist("REGNO",$j,PRTUsr))=0  d
	...s userflag(PRTUsr)="T",username(PRTUsr)=$P(^SSU("SSUSR",PRTUsr),"^",2)
	...s usercode(PRTUsr)=$P(^SSU("SSUSR",PRTUsr),"^",1)
	..i ((Flag="N")||((PrtinvDr="")&&(Flag'="N")))  d
	...i userflag(PRTUsr)="F"  d
	....s sum(PRTUsr)=sum(PRTUsr)+PRTAcount,payqty(PRTUsr)=payqty(PRTUsr)+1
	....s ^tmplist("REGNO",$j,PRTUsr)=usercode(PRTUsr)_"^"_username(PRTUsr)_"^"_sum(PRTUsr)_"^"_payqty(PRTUsr)_"^"_refundqty(PRTUsr)
	...i userflag(PRTUsr)="T"  d
	....s ii=ii+1,ss(ii)=PRTUsr
	....s sum(PRTUsr)=PRTAcount,payqty(PRTUsr)=1,refundqty(PRTUsr)=0
	....s ^tmplist("REGNO",$j,PRTUsr)=usercode(PRTUsr)_"^"_username(PRTUsr)_"^"_sum(PRTUsr)_"^"_payqty(PRTUsr)_"^"_refundqty(PRTUsr)
	....s userflag(PRTUsr)="F"
	..i (Flag="S")&&(PrtinvDr'="")  d
	...i userflag(PRTUsr)="F"  d
	....s sum(PRTUsr)=sum(PRTUsr)+PRTAcount,refundqty(PRTUsr)=refundqty(PRTUsr)+1
	....s ^tmplist("REGNO",$j,PRTUsr)=usercode(PRTUsr)_"^"_username(PRTUsr)_"^"_sum(PRTUsr)_"^"_payqty(PRTUsr)_"^"_refundqty(PRTUsr)
	...i userflag(PRTUsr)="T"  d
	....s ii=ii+1,ss(ii)=PRTUsr
	....s sum(PRTUsr)=PRTAcount,payqty(PRTUsr)=0,refundqty(PRTUsr)=1
	....s ^tmplist("REGNO",$j,PRTUsr)=usercode(PRTUsr)_"^"_username(PRTUsr)_"^"_sum(PRTUsr)_"^"_payqty(PRTUsr)_"^"_refundqty(PRTUsr)
	....s userflag(PRTUsr)="F"
	b
	i ii>0  d
	.f kind=1:1:ii d
	..s TRUser=$p(^tmplist("REGNO",$j,ss(kind)),"^",1)
	..s TRUserName=$p(^tmplist("REGNO",$j,ss(kind)),"^",2)
	..s THandSum=$p(^tmplist("REGNO",$j,ss(kind)),"^",3)
	..s TNorNum=$p(^tmplist("REGNO",$j,ss(kind)),"^",4)
	..s THefNum=$p(^tmplist("REGNO",$j,ss(kind)),"^",5)
	..s THandSum=$j(THandSum,3,2)
   ..Do OutputRow5
   
   k ^tmplist("REGNO",$j)   
 	Set QHandle=$lb(0,repid,0)
 	Quit $$$OK
OutputRow5
                //TPatNo,TPatMNo,TPatName,TRegLoc,TRegDoc,TArcType,TRegDate,TRegFee,TFormFee,TExamFee,TUsrCode,TUsrName,TRegTime,TRefUsr,TRefTime,TRegNo,TRegType,TAddflag,THandDate)
	set Data=$lb(TRUser,TRUserName,THandSum,TNorNum,THefNum)
 	Set ^CacheTemp(repid,ind)=Data	
 	Set ind=ind+1
	quit
}

ClassMethod RegNoHandQueryFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = RegNoHandQueryExecute ]
{
 New repid,ind
 Set AtEnd=$li(QHandle,1)
 Set repid=$li(QHandle,2)
 Set ind=$li(QHandle,3)
 Set ind=$o(^CacheTemp(repid,ind))
 If ind="" {	// if there are no more rows, finish fetching
 Set AtEnd=1
 Set Row=""
 }
 Else      {	// fetch row
 Set Row=^CacheTemp(repid,ind)
 }
 s QHandle=$lb(AtEnd,repid,ind)
 Quit $$$OK
}

Query RegNoHandQuery(StDate, EdDate) As %Query(ROWSPEC = "TRUser:%String,TRUserName:%String,THandSum:%String,TNorNum:%String,THefNum:%String")
{
}

ClassMethod GetUserLocation(ctloc As %String, userid As %String)
{
 s ll=0,t=0
 s CtllDesc=""
 s CtllDr=0 s CtllDr=$o(^CT("LL",0,"Loc1",ctloc,CtllDr))
 if CtllDr'="" s CtllDesc=$p(^CT("LL",CtllDr),"^",2)
 s LocationType=""
 if CtllDesc'=""{
	if CtllDesc="东院科室" set LocationType="E"
 	if CtllDesc="西院科室" set LocationType="W"
 }
 q LocationType
}

ClassMethod HadMR(adm)
{
	n (adm)
	s Flag=0
	s mradm=##Class(web.DHCPAADM).GetMRAdmID(adm)
	s Childsub=$o(^MR(mradm,"DIA",0))
	s:Childsub'="" Flag=1
	q Flag
}

/// creater 	lxz 
/// desc	挂号总表，可以直接使用，兼容其他医院
/// d ##class(%ResultSet).RunQuery("web.DHCOPRegReports","GetRepInfo",62807,62827,"","","","","")
Query GetRepInfo(STDate As %String, EndDate As %String, UserID As %String, RegID As %String, MZ As %String, JZ As %String, TX As %String) As %Query(ROWSPEC = "NO:%String,UserName:%String,AllRegNo:%String,YXGH:%String,BYZGYB:%String,THS:%String,TBR:%String,TTR:%String,SumFee:%String,THFee:%String,JKFee:%String,YBF:%String,YBNO:%String,YBN:%String,ZFN:%String,THZF:%String,THYB:%String,OutDateReturnNO:%String,MRFee:%String,CardFee:%String,RegFee:%String,CheckFee:%String,ReCheckFee:%String,AppFee:%String,HoliFee:%String,OtherFee:%String,StrType:%String")
{
}

ClassMethod GetRepInfoExecute(ByRef qHandle As %Binary, STDate As %String, EndDate As %String, UserID As %String, RegID As %String, MZ As %String, JZ As %String, TX As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=2
 	 //if UserID="" s UserID=%session.Get("LOGON.USERID")
	 if UserID=""  s UserID="20121127"
	 if ((STDate="")&&(EndDate="")) d 
	 .s STDate=..%SysDate() s EndDate=..%SysDate()
	 s RegNO=0 s RegReturnNo=0
	 ;总计使用：挂号数量、退号数量
	 k ^TempGetRepInfo(UserID)
	 k ^TempGetRepInfoGet(UserID)
	 s UserNameGet="" s RegName=""
	 if RegID'="" s RegName=$P(^SSU("SSUSR",RegID),"^",2)
	 if ((UserID'="")&&(UserID'="20121127")) s UserNameGet=$P(^SSU("SSUSR",UserID),"^",2)
	 s ^TempGetRepInfo(UserID)=JZ_"^"_TX_"^"_MZ_"^"_$ZD(STDate,4)_"^"_$ZD(EndDate,4)_"^"_RegName_"^"_UserNameGet_"^"_$ZD(+$H,3)_" "_..%ZT(..%SysTime(),2)
	 f Date=STDate:1:EndDate d
	 .s Time=0 f  s Time=$o(^PAADMi("PAADM_DateTime",Date,Time)) q:Time=""  d
	 ..s PaadmRowid=0 f  s PaadmRowid=$o(^PAADMi("PAADM_DateTime",Date,Time,PaadmRowid)) q:PaadmRowid=""  d
	 ...s CreaterUser=$p($g(^PAADM(PaadmRowid)),"^",43) 
	 ...s Ctloc=$p($g(^PAADM(PaadmRowid)),"^",4) 
	 ...s Desc=$p(^CTLOC(Ctloc),"^",2)
	 ...s FlagOK="" 
	 ...//if ((JZ="on")&&(Desc[("急诊"))) s FlagOK="Y"  //按照科室名称区分
	 ...//if ((TX="on")&&(Desc[("特需"))) s FlagOK="Y" 
	 ...//if ((MZ="on")&&(Desc'[("特需"))&&(Desc'[("急诊"))) s FlagOK="Y"
	 ...if (JZ="on") S FlagOK=..GetCtlocType(Ctloc,"JZ") //特需按照科室名称，急诊按照关联，其他的是门诊
	 ...if (TX="on") S FlagOK=..GetCtlocType(Ctloc,"TX") 
	 ...if (MZ="on") S FlagOK=..GetCtlocType(Ctloc,"MZ") 
	 ...Q:FlagOK'="Y"
	 ...s TUserNameID=$p($g(^PAADM(PaadmRowid,2)),"^",69) ;pa_adm.paadm_socialworkername,
	 ...s SocialStatusDesc=""  s BYZGYB="N" ;本院职工医保卡挂号标识 
	 ...s PAPMIDr=$p($g(^PAADM(PaadmRowid)),"^",1)
	 ...s SocialStatusDr=$P($G(^PAPER(PAPMIDr,"PER",1)),"^",10) //使用ID=4为本院职工
	 ...if SocialStatusDr'="" s SocialStatusDesc=$P($G(^CT("SS",SocialStatusDr)),"^",2)
	 ...s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
	 ...s UpdateDate=$p($g(^PAADM(PaadmRowid,1)),"^",42)
	 ...if (VisitStatus="C") d  ;查询以前的记录如果是隔日退号的，退号时间不在查询时间断内，按照正常号处理
	 ....if (UpdateDate>EndDate) d
	 .....s VisitStatus="A" 
	 ...Q:((VisitStatus="C")&&(TUserNameID="")) ;退号人ID为空
	 ...s RegNO=RegNO+1 ;挂号总数量计算
	 ...if VisitStatus="C" s RegReturnNo=RegReturnNo+1 ;退号总数量
	 ...s Admi=PaadmRowid
	 ...S I=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	 ...if I'="" d
	 ....;lxz验证医保
	 ....s Desc=""
	 ....s RegTypeId=$List(^User.DHCRegistrationFeeD(I),19) //出诊级别 (医生对应的号别)
   	 ....if RegTypeId'="" s Desc=$p(^RBC("SESS",RegTypeId),"^",2)
	 ....s GetInsuAdmDr=$List(^User.DHCRegistrationFeeD(I),24)
	 ....//if ((SocialStatusDesc["本院职工")&&(GetInsuAdmDr'="")) s BYZGYB="Y" ;本院职工医 //放开后统计金额本院职工医为0 可计算出本院职工医保挂号数量
	 ....s RegFee=$List(^User.DHCRegistrationFeeD(I),4) //+$List(^User.DHCRegistrationFeeD(I),9) ;挂号费+诊察费(医药分离后没有侦查费用一项)
	 ....s RegfeeInsuFund=$List(^User.DHCRegistrationFeeD(I),27) ;基金支付
	 ....i RegfeeInsuFund'="" s RegfeeInsuFund=$p(RegfeeInsuFund,"!",2) 
	 ....e  s RegfeeInsuFund=0
	 ....s RegfeeInsuCash=$List(^User.DHCRegistrationFeeD(I),25) ;医保现金支付
	 ....i RegfeeInsuCash'="" s RegfeeInsuCash=$p(RegfeeInsuCash,"!",2) 
	 ....e  s RegfeeInsuCash=0
	 ....s RegfeeInsuCount=$List(^User.DHCRegistrationFeeD(I),26) ;医保账户支付（这个金额在报表中没有统计,只有基金支付)
	 ....i RegfeeInsuCount'="" s RegfeeInsuCount=$p(RegfeeInsuCount,"!",2) 
	 ....e  s RegfeeInsuCount=0
	 ....s Flag="" ;记录号的状态情况
	 ....if (VisitStatus="C")  d
	 .....if (TUserNameID=CreaterUser) s Flag="BR"
	 .....else  s Flag="TR"
	 ....//w VisitStatus_"^"_Flag_"^"_TUserNameID_"^"_CreaterUser,!
	 ....;所有挂出的号分到挂号人的名下
	 ....s Sub=$O(^TempGetRepInfo(UserID,CreaterUser,""),-1)
	 ....if Sub="Return" s Sub=$O(^TempGetRepInfo(UserID,CreaterUser,Sub),-1)+1
	 ....else  s Sub=Sub+1
	 ....s RegFeeStrGet=$$GetTUserID(PaadmRowid,"A",I) ;始终返回初始票据的总金额
	 ....s RegFee=$P(RegFeeStrGet,"*",1) ;使用发票表计算的金额,挂号表中有时候记录不准确
	 ....s ^TempGetRepInfo(UserID,CreaterUser,Sub)=RegFee_"^"_RegfeeInsuFund_"^"_BYZGYB_"^"_Flag_"^"_RegfeeInsuCash_"^"_GetInsuAdmDr_"^"_PaadmRowid_"^"_"INDate"_"^"_Desc_"^"_RegFeeStrGet
	 ....;退出的号分到退号人名下
	 ....if VisitStatus="C"  d 
	 .....s RegFeeStrGet=$$GetTUserID(PaadmRowid,"C",I) ;只返回应该退掉的钱(包含部分退的发票)
	 .....s RegFee=$P(RegFeeStrGet,"*",1) 
	 .....s SubRet=$O(^TempGetRepInfo(UserID,TUserNameID,"Return",""),-1)+1
	 .....s ^TempGetRepInfo(UserID,TUserNameID,"Return",SubRet)=RegFee_"^"_RegfeeInsuFund_"^"_BYZGYB_"^"_Flag_"^"_RegfeeInsuCash_"^"_GetInsuAdmDr_"^"_PaadmRowid_"^"_"INDate"_"^"_Desc_"^"_RegFeeStrGet

 	 ;统计就诊日期在查询日期外的，统计时段内的退号记录
 	 f Date=STDate:1:EndDate d
 	 .s PaadmRowid=0  f  s PaadmRowid=$O(^PAADMi("UpdDate",Date,PaadmRowid)) Q:PaadmRowid=""  d
 	 ..s PaadmDate=$p($g(^PAADM(PaadmRowid)),"^",6)
 	 ..Q:PaadmDate=STDate
 	 ..Q:PaadmDate>STDate
 	 ..s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
 	 ..Q:VisitStatus'="C"
 	 ..s CreaterUser=$p($g(^PAADM(PaadmRowid)),"^",43) 
	 ..s Ctloc=$p($g(^PAADM(PaadmRowid)),"^",4) 
	 ..s Desc=$p(^CTLOC(Ctloc),"^",2)
	 ..s FlagOK="" 
	 ..//if ((JZ="on")&&(Desc[("急诊"))) s FlagOK="Y"
	 ..//if ((TX="on")&&(Desc[("特需"))) s FlagOK="Y" 
	 ..//if ((MZ="on")&&(Desc'[("特需"))&&(Desc'[("急诊"))) s FlagOK="Y"
	 ..if (JZ="on") S FlagOK=..GetCtlocType(Ctloc,"JZ") //特需按照科室名称，急诊按照关联，其他的是门诊
	 ..if (TX="on") S FlagOK=..GetCtlocType(Ctloc,"TX") 
	 ..if (MZ="on") S FlagOK=..GetCtlocType(Ctloc,"MZ") 
	 ..Q:FlagOK'="Y"
	 ..s TUserNameID=$p($g(^PAADM(PaadmRowid,2)),"^",69) ;pa_adm.paadm_socialworkername,
	 ..s SocialStatusDesc=""  s BYZGYB="N" ;本院职工医保卡挂号标识 
	 ..s PAPMIDr=$p($g(^PAADM(PaadmRowid)),"^",1)
	 ..s SocialStatusDr=$P($G(^PAPER(PAPMIDr,"PER",1)),"^",10) //使用ID=4为本院职工
	 ..if SocialStatusDr'="" s SocialStatusDesc=$P($G(^CT("SS",SocialStatusDr)),"^",2)
	 ..Q:((VisitStatus="C")&&(TUserNameID="")) ;退号人ID为空
	 ..//s RegNO=RegNO+1 ;挂号总数量计算 ;统计日期外的隔日退号挂号数量不再增加
	 ..if VisitStatus="C" s RegReturnNo=RegReturnNo+1 ;退号总数量
	 ..s Admi=PaadmRowid
	 ..S I=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	 ..if I'="" d
	 ...;lxz验证医保
	 ...s Desc=""
	 ...s RegTypeId=$List(^User.DHCRegistrationFeeD(I),19) //出诊级别 (医生对应的号别)
   	 ...if RegTypeId'="" s Desc=$p(^RBC("SESS",RegTypeId),"^",2)
	 ...s GetInsuAdmDr=$List(^User.DHCRegistrationFeeD(I),24)
	 ...//if ((SocialStatusDr["本院职工")&&(GetInsuAdmDr'="")) s BYZGYB="Y" ;本院职工医保
	 ...s RegFee=$List(^User.DHCRegistrationFeeD(I),4) //+$List(^User.DHCRegistrationFeeD(I),9) ;挂号费+诊察费(医药分离后没有侦查费用一项)
	 ...s RegfeeInsuFund=$List(^User.DHCRegistrationFeeD(I),27) ;基金支付
	 ...i RegfeeInsuFund'="" s RegfeeInsuFund=$p(RegfeeInsuFund,"!",2) 
	 ...e  s RegfeeInsuFund=0
	 ...s RegfeeInsuCash=$List(^User.DHCRegistrationFeeD(I),25) ;医保现金支付
	 ...i RegfeeInsuCash'="" s RegfeeInsuCash=$p(RegfeeInsuCash,"!",2) 
	 ...e  s RegfeeInsuCash=0
	 ...s RegfeeInsuCount=$List(^User.DHCRegistrationFeeD(I),26) ;医保现金支付
	 ...i RegfeeInsuCount'="" s RegfeeInsuCount=$p(RegfeeInsuCount,"!",2) 
	 ...e  s RegfeeInsuCount=0
	 ...s Flag="" ;记录号的状态情况
	 ...if (VisitStatus="C")  d
	 ....if (TUserNameID=CreaterUser) s Flag="BR"
	 ....else  s Flag="TR"
	 ...if VisitStatus="C"  d
	 ....s RegFeeStrGet=$$GetTUserID(PaadmRowid,"C",I) ;只返回应该退掉的钱(包含部分退的发票)
	 ....s RegFee=$P(RegFeeStrGet,"*",1) 
	 ....s SubRet=$O(^TempGetRepInfo(UserID,TUserNameID,"Return",""),-1)+1
	 ....s ^TempGetRepInfo(UserID,TUserNameID,"Return",SubRet)=RegFee_"^"_RegfeeInsuFund_"^"_BYZGYB_"^"_Flag_"^"_RegfeeInsuCash_"^"_GetInsuAdmDr_"^"_PaadmRowid_"^"_"OutDate"_"^"_Desc_"^"_RegFeeStrGet
 
	 ;统计上边的情况
	 ;合计参数
	 s (AllRegNo1,YXGH1,BYZGYB1,THS1,TBR1,TTR1,SumFee1,THFee1,JKFee1,YBF1,YBNO1,YBN1,ZFN1,THZF1,THYB1,OutDateReturnNO1,NO)=0
	 s (MRFee1,CardFee1,RegFee1,CheckFee1,ReCheckFee1,AppFee1,HoliFee1,OtherFee1)=0
	 s UserReg=0 
	 f  s UserReg=$O(^TempGetRepInfo(UserID,UserReg)) Q:UserReg=""  d
	 .Q:((RegID'=UserReg)&&(RegID'=""))
	 .//个人小结参数
	 .s AllRegNo=0 s YXGH=0 s THS=0 s TBR=0 s TTR=0 s JKFee=0  s THFee=0  s YBF=0  s BYZGYB=0 s SumFee=0 s YBNO=0 s OutDateReturnNO=0
	 .;挂号总数、有效挂号、退号数、退自己所挂号、退的他人的号、交款金额、退款费用、医保费用、本院职工医保卡挂号数、总金额,;个人统计使用
	 .s (YBN,ZFN,THZF,THYB)=0
	 .;费用明细
	 .s (TMRFee,TCardFee,TRegFee,TCheckFee,TReCheckFee,TAppFee,THoliFee,TOtherFee)=0
	 .s (MRFee,CardFee,RegFee,CheckFee,ReCheckFee,AppFee,HoliFee,OtherFee)=0
	 .s UserName=$P(^SSU("SSUSR",UserReg),"^",2)
	 .s SubRet=0 f  s SubRet=$O(^TempGetRepInfo(UserID,UserReg,"Return",SubRet)) Q:SubRet=""  d
	 ..s FeeStr=$G(^TempGetRepInfo(UserID,UserReg,"Return",SubRet))
	 ..s FeeReg=$P(FeeStr,"^",1) ;挂号费用
	 ..s RegfeeInsuFund=$P(FeeStr,"^",2) ;医保医疗费用
	 ..s BYYB=$P(FeeStr,"^",3) ;本院职工医保标识
	 ..s State=$P(FeeStr,"^",4) ;号状态
	 ..s FeeInsuCash=$P(FeeStr,"^",5) ;医保现金支付
	 ..s FeeInsuAdm=$P(FeeStr,"^",6) ;医保流水号
	 ..s AdmRowIDGet=$P(FeeStr,"^",7) ;AdmDr
	 ..s OutDate=$P(FeeStr,"^",8) ;在查询范围外的，时段内退号记录标识
	 ..s Desc=$P(FeeStr,"^",9) ;出诊级别(号别)
	 ..s GetFeeList=$P(FeeStr,"^",10) ;挂号中的每项明细
	 ..if OutDate="OutDate" s OutDateReturnNO=OutDateReturnNO+1
	 ..if State="BR" s TBR=TBR+1 ;退号中自己的号
	 ..if State="TR" s TTR=TTR+1 ;退号中他人的号
	 ..if FeeInsuAdm=""  d
	 ...s THZF=THZF+1
	 ...s THFee=THFee+FeeReg ;退号总金额
	 ..else  d
	 ...s THYB=THYB+1 ;医保患者数量
	 ...if BYYB="Y" ;本院职工医保号金额为0，不退钱
	 ....s THFee=THFee+0
	 ...else  d
	 ....s THFee=THFee+FeeInsuCash
	 ..s TMRFee=TMRFee+$P(GetFeeList,"*",2)
	 ..s TCardFee=TCardFee+$P(GetFeeList,"*",3)
	 ..s TRegFee=TRegFee+$P(GetFeeList,"*",4)
	 ..s TCheckFee=TCheckFee+$P(GetFeeList,"*",5)
	 ..s TReCheckFee=TReCheckFee+$P(GetFeeList,"*",6)
	 ..s TAppFee=TAppFee+$P(GetFeeList,"*",7)
	 ..s THoliFee=THoliFee+$P(GetFeeList,"*",8)
	 ..s TOtherFee=TOtherFee+$P(GetFeeList,"*",9)
	 ..s THS=SubRet ;退号总数
	 .;挂号汇总
	 .k ^TempRegType
	 .s Sub=0  f  s Sub=$O(^TempGetRepInfo(UserID,UserReg,Sub)) Q:Sub=""  d
	 ..s FeeStr=$G(^TempGetRepInfo(UserID,UserReg,Sub))
	 ..Q:FeeStr=""
	 ..s FeeReg=$P(FeeStr,"^",1) ;挂号费用
	 ..s RegfeeInsuFund=$P(FeeStr,"^",2) ;医保医疗费用
	 ..s BYYB=$P(FeeStr,"^",3) ;本院职工医保标识
	 ..s State=$P(FeeStr,"^",4) ;号状态(为空是有效挂号)
	 ..s FeeInsuCash=$P(FeeStr,"^",5) ;医保现金支付
	 ..s FeeInsuAdm=$P(FeeStr,"^",6) ;医保流水号
	 ..s AdmRowIDGet=$P(FeeStr,"^",7) ;AdmDr
	 ..s OutDate=$P(FeeStr,"^",8) ;在查询范围外的，时段内退号记录标识
	 ..s Desc=$P(FeeStr,"^",9) ;出诊级别(号别)
	 ..s GetFeeList=$P(FeeStr,"^",10) ;挂号中的每项明细
	 ..s AllRegNo=Sub ;挂号总数
	 ..i State=""  d
	 ...s YXGH=YXGH+1 ;有效挂号数(去除所有退号)
	 ...s YBF=YBF+RegfeeInsuFund
	 ...s SubType=$O(^TempRegType($J,Desc,""),-1)+1 ;记录每种出诊级别的挂号数量
	 ...s ^TempRegType($J,Desc,SubType)="OK"
	 ..if ((State="")&&(FeeInsuAdm'="")) s YBNO=YBNO+1
	 ..if FeeInsuAdm=""  d
	 ...s ZFN=ZFN+1
	 ...s SumFee=SumFee+FeeReg ;收款总金额
	 ..else  d
	 ...s YBN=YBN+1
	 ...if BYYB="Y"  d  ;本院职工医保挂号统计金额为0，不收钱
	 ....s SumFee=SumFee+0
	 ...else  d
	 ....s SumFee=SumFee+FeeInsuCash
	 ..if (BYYB="Y")&&(State="") d
	 ...s BYZGYB=BYZGYB+1
	 ..s MRFee=MRFee+$P(GetFeeList,"*",2)
	 ..s CardFee=CardFee+$P(GetFeeList,"*",3)
	 ..s RegFee=RegFee+$P(GetFeeList,"*",4)
	 ..s CheckFee=CheckFee+$P(GetFeeList,"*",5)
	 ..s ReCheckFee=ReCheckFee+$P(GetFeeList,"*",6)
	 ..s AppFee=AppFee+$P(GetFeeList,"*",7)
	 ..s HoliFee=HoliFee+$P(GetFeeList,"*",8)
	 ..s OtherFee=OtherFee+$P(GetFeeList,"*",9)
	 .s MRFee=MRFee-TMRFee
	 .s CardFee=CardFee-TCardFee
	 .s RegFee=RegFee-TRegFee
	 .s CheckFee=CheckFee-TCheckFee
	 .s ReCheckFee=ReCheckFee-TReCheckFee
	 .s AppFee=AppFee-TAppFee
	 .s HoliFee=HoliFee-THoliFee
	 .s OtherFee=OtherFee-TOtherFee
	 .s JKFee=SumFee-THFee
	 .s StrType=""
	 .;记录每种出诊级别的挂号数量
	 .s TypeD=0  f  s TypeD=$O(^TempRegType($J,TypeD)) Q:TypeD=""  d
	 ..if StrType=""  s StrType=TypeD_"-"_$O(^TempRegType($J,TypeD,""),-1)
	 ..else  s StrType=StrType_" "_TypeD_"-"_$O(^TempRegType($J,TypeD,""),-1)
	 .s NO=NO+1
	 .s SumFee=$Fn(SumFee,"",2) s THFee=$Fn(THFee,"",2) s JKFee=$Fn(JKFee,"",2) s YBF=$Fn(YBF,"",2)
	 .;统计总量
	 .s AllRegNo1=AllRegNo1+AllRegNo 
	 .s YXGH1=YXGH1+YXGH
	 .s BYZGYB1=BYZGYB1+BYZGYB
	 .s THS1=THS1+THS
	 .s TBR1="" s TTR1=""
	 .s SumFee1=SumFee1+SumFee
	 .s THFee1=THFee1+THFee
	 .s JKFee1=JKFee1+JKFee
	 .s YBF1=YBF1+YBF
	 .s YBNO1=YBNO1+YBNO
	 .s YBN1=YBN1+YBN
	 .s ZFN1=ZFN1+ZFN
	 .s THZF1=THZF1+THZF
	 .s THYB1=THYB1+THYB
	 .s OutDateReturnNO1=OutDateReturnNO1+OutDateReturnNO
	 .s MRFee1=MRFee1+MRFee
	 .s CardFee1=CardFee1+CardFee
	 .s RegFee1=RegFee1+RegFee
	 .s CheckFee1=CheckFee1+CheckFee
	 .s ReCheckFee1=ReCheckFee1+ReCheckFee
	 .s AppFee1=AppFee1+AppFee
	 .s HoliFee1=HoliFee1+HoliFee
	 .s OtherFee1=OtherFee1+OtherFee
	 .s JKFee=SumFee-THFee
	 .;挂号员姓名、挂号总数、有效挂号(号没有被退掉)、本院职工医保挂号、退号总数、退号中自己的号、退号中他人的号、收款总额、退款总额、应交款、医保基金支付费用、医保患者有效挂号数量、医保挂号总数、自费挂号总数、退号中的自费患者、退号中的医保患者、查询查询日期外就诊，但是在时段内退号的患者
	 .//w UserName_"^"_AllRegNo_"^"_YXGH_"^"_BYZGYB_"^"_THS_"^"_TBR_"^"_TTR_"^"_SumFee_"^"_THFee_"^"_JKFee_"^"_YBF_"^"_YBNO_"^"_YBN_"^"_ZFN_"^"_THZF_"^"_THYB_"^"_OutDateReturnNO
	 .//挂号每项费用的明细
	 .Do OutputRow
	 .s Sub=$O(^TempGetRepInfoGet(UserID,""),-1)+1
	 .s ^TempGetRepInfoGet(UserID,Sub)=NO_"^"_UserName_"^"_AllRegNo_"^"_YXGH_"^"_BYZGYB_"^"_THS_"^"_TBR_"^"_TTR_"^"_SumFee_"^"_THFee_"^"_JKFee_"^"_YBF_"^"_YBNO_"^"_YBN_"^"_ZFN_"^"_THZF_"^"_THYB_"^"_OutDateReturnNO_"^"_MRFee_"^"_CardFee_"^"_RegFee_"^"_CheckFee_"^"_ReCheckFee_"^"_AppFee_"^"_HoliFee_"^"_OtherFee_"^"_StrType
	s ind=1
	s NO="" s UserName="合计:"
	s AllRegNo=AllRegNo1
	s YXGH=YXGH1
	s BYZGYB=BYZGYB1
	s THS=THS1
	s TBR=TBR1
	s TTR=TTR1
	s SumFee=SumFee1
	s THFee=THFee1
	s JKFee=JKFee1
	s YBF=YBF1
	s YBNO=YBNO1
	s YBN=YBN1
	s ZFN=ZFN1
	s THZF=THZF1
	s THYB=THYB1
	s OutDateReturnNO=OutDateReturnNO1
	 s MRFee=MRFee1
	 s CardFee=CardFee1
	 s RegFee=RegFee1
	 s CheckFee=CheckFee1
	 s ReCheckFee=ReCheckFee1
	 s AppFee=AppFee1
	 s HoliFee=HoliFee1
	 s OtherFee=OtherFee1
	 s StrType=""
	s SumFee=$Fn(SumFee,"",2) s THFee=$Fn(THFee,"",2) s JKFee=$Fn(JKFee,"",2) s YBF=$Fn(YBF,"",2)
	Do OutputRow
	s Sub=$O(^TempGetRepInfoGet(UserID,""),-1)+1
	s ^TempGetRepInfoGet(UserID,Sub)=NO_"^"_UserName_"^"_AllRegNo_"^"_YXGH_"^"_BYZGYB_"^"_THS_"^"_TBR_"^"_TTR_"^"_SumFee_"^"_THFee_"^"_JKFee_"^"_YBF_"^"_YBNO_"^"_YBN_"^"_ZFN_"^"_THZF_"^"_THYB_"^"_OutDateReturnNO_"^"_MRFee_"^"_CardFee_"^"_RegFee_"^"_CheckFee_"^"_ReCheckFee_"^"_AppFee_"^"_HoliFee_"^"_OtherFee_"^"_StrType
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(NO,UserName,AllRegNo,YXGH,BYZGYB,THS,TBR,TTR,SumFee,THFee,JKFee,YBF,YBNO,YBN,ZFN,THZF,THYB,OutDateReturnNO,MRFee,CardFee,RegFee,CheckFee,ReCheckFee,AppFee,HoliFee,OtherFee,StrType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetTUserID(AmdGet,AdmStatuGet,IDr)
	;得到挂号收费金额，或者退号应退金额
	s FeeStr=""
	s VisitStatusGet=$p($g(^PAADM(AmdGet)),"^",20)
	s InvoiceDr=$List(^User.DHCRegistrationFeeD(IDr),11)
	;b ;"InvoiceDr"
	s PRTFlag=$p($g(^DHCINVPRT(+InvoiceDr)),"^",8)
 	s PRTinitInvDR=$p($g(^DHCINVPRT(+InvoiceDr)),"^",13)
 	s PRTOldINVDR=$p($g(^DHCINVPRT(+InvoiceDr)),"^",29)
 	if VisitStatusGet'="C" d
 	.;本身是有效挂号
 	.S FeeStr=$$GetINVPRTList(+InvoiceDr)
 	else  d
 	.if PRTFlag'="N"  d ;如果记录的票据状态是无效的，说明挂号时全挂全退的直接返回这个票的情况
 	..s FeeStr=$$GetINVPRTList(+InvoiceDr)
 	.else  d
 	..if AdmStatuGet'="C"  d ;退号的按照正常号处理(处理隔日退号的情况使用，或者是部分退费的时候返回初始状况)
 	...s FeeStr=$$GetINVPRTList(+PRTOldINVDR) ;部分退的应该去找原票的记录
 	..else  d  ;退号的返回退号金额(应减去金额)
 	...s FeeStrOldINVDR=$$GetINVPRTList(+PRTOldINVDR) //原票
 	...s FeeStrONowINVDR=$$GetINVPRTList(+InvoiceDr) //现票
 	...s FeeStr=$$INVPRDel(FeeStrOldINVDR,FeeStrONowINVDR)
 	Q FeeStr
INVPRDel(FeeStr1,FeeStr2) 
	;两种票据结果做减操作FeeStr1-FeeStr2
	s Long=$L(FeeStr2,"*")
	s ReturnStr=""
	for i=1:1:Long
	{
		s Itm1=$P(FeeStr1,"*",i)
		s Itm2=$P(FeeStr2,"*",i)
		if ReturnStr="" s ReturnStr=(Itm1-Itm2)
		else  s ReturnStr=ReturnStr_"*"_(Itm1-Itm2)
	}
	Q:ReturnStr="" FeeStr1
	Q ReturnStr		
GetINVPRTList(InvoiceDr)
	;通过发票ID返回这个挂号发票的收费明细
	Q:((InvoiceDr="")||(InvoiceDr=0)) ""
	s (FeeAll,MRFee,CardFee,RegFee,CheckFee,ReCheckFee,AppFee,HoliFee,OtherFee)=0
	s ConRowId="" s FeeAll=0
    if InvoiceDr'=""  d
    .;s FeeAll=$p($g(^DHCINVPRT(+InvoiceDr)),"^",1) ;发票总金额
    .s PRTPatientShare=$p($g(^DHCINVPRT(+InvoiceDr)),"^",16)
    .s FeeAll=PRTPatientShare
    if (InvoiceDr'="")	s ConRowId=$O(^DHCBCI(0,"INV",InvoiceDr,0)) 
    s PBRowId="" 
    i ConRowId'="" 	s PBRowId=$P(^DHCBCI(ConRowId),"^",2)
    ;b ;Test 
    if PBRowId'="" D
    .s PBOChild=0 f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
    ..s ArcimId=$P(^DHCPB(PBRowId,"O",PBOChild),"^",3)
    ..Q:ArcimId=""
    ..s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
    ..s BillSum=0
    ..s BillSum=$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
    ..if type="MR" d ;病历本
    ...s MRFee=MRFee+BillSum
    ..else  if type="Card" d ;卡费
    ...s CardFee=CardFee++BillSum 
    ..else  if type="Reg" d	;挂号费
    ...s RegFee=RegFee++BillSum
    ..else  if type="Check" d ;检查费
    ...s CheckFee=CheckFee++BillSum
    ..else  if type="ReCheck" d ;复查费
    ...s ReCheckFee=ReCheckFee++BillSum
    ..else  if type="App" d ;预约费
    ...s AppFee=AppFee++BillSum
    ..else  if type="Holi" d ;假日费
    ...s HoliFee=HoliFee++BillSum
    ..else  if type="Other" d ;其他费用
    ...s OtherFee=OtherFee++BillSum
    Q FeeAll_"*"_MRFee_"*"_CardFee_"*"_RegFee_"*"_CheckFee_"*"_ReCheckFee_"*"_AppFee_"*"_HoliFee_"*"_OtherFee
}

ClassMethod GetRepInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetRepInfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetRepInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetRepInfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creater	lxz
/// desc	获得科室类型  
/// 没有使用暂时使用就诊科室名字进行统计判断
/// input LocDr 科室ID Type 类型 传出参数Y符合否则不符合
ClassMethod GetCtlocType(LocDr As %String, Type As %String) As %String
{
	Q:LocDr="" ""
	s Flag="" s TXFlag="0"
	if (Type="JZ")
	{
	s EmFlag=$$GetEmFlag(LocDr)
	if EmFlag=1 s Flag="Y"
	}
	if (Type="MZ")
	{
		s EmFlag=$$GetEmFlag(LocDr)
		s DescLoc=$p(^CTLOC(LocDr),"^",2)
		if (DescLoc[("特需")) s TXFlag=1
		if ((EmFlag=0)&&(TXFlag=0)) s Flag="Y"
	}
	if (Type="TX")
	{
		s DescLoc=$p(^CTLOC(LocDr),"^",2)
		if (DescLoc[("特需")) s TXFlag="Y"
	}
	Q Flag
	
GetEmFlag(LocDr)
	s EFlag=0
	set LinkLocDr=0
	Set LinkLocDr=$o(^CTLOC(LocDr,"LINK",0,"Loc",0))
	if LinkLocDr'="" d
	.s LinkLocType=$p(^CTLOC(LinkLocDr),"^",13)
	.i LinkLocType="EM" Set EFlag="1"
	Q EFlag
}

/// creater lxz
/// desc 个人报表
/// w ##class(%ResultSet).RunQuery("web.DHCOPRegReports","GetOneRegINfo",62807,62827,5291,5291,"on","on","on")
Query GetOneRegINfo(STDate As %String, EndDate As %String, UserID As %String, RegID As %String, MZ As %String, JZ As %String, TX As %String, CheckAll As %String) As %Query(ROWSPEC = "NO:%String,UserName:%String,Desc:%String,AllRegNo:%String,YXGH:%String,BYZGYB:%String,THS:%String,TBR:%String,TTR:%String,SumFee:%String,THFee:%String,JKFee:%String,YBF:%String,YBNO:%String,YBN:%String,ZFN:%String,THZF:%String,THYB:%String,OutDateReturnNO:%String,MRFee:%String,CardFee:%String,RegFee:%String,CheckFee:%String,ReCheckFee:%String,AppFee:%String,HoliFee:%String,OtherFee:%String,StrType:%String")
{
}

ClassMethod GetOneRegINfoExecute(ByRef qHandle As %Binary, STDate As %String, EndDate As %String, UserID As %String, RegID As %String, MZ As %String, JZ As %String, TX As %String, CheckAll As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=2
 	s ^TempzongJUIT=STDate_","_EndDate_","_UserID_","_RegID_","_MZ_","_JZ_","_TX
 	if ((UserID="")&&(RegID="")){
 		Set qHandle=$lb(0,repid,0) 
 		Quit $$$OK
 	}
 	if UserID="" s UserID=%session.Get("LOGON.USERID")
 	if (UserID="")
 	{ 
 		//s UserID="201211"
	 	Set qHandle=$lb(0,repid,0) 
 		Quit $$$OK
	 	
	 	}
 	if RegID=""  s RegID=UserID
 	
	 s RegNO=0 s RegReturnNo=0
	 ;总计使用：挂号数量、退号数量

	 k ^TempGetOneRegINfo(UserID)
	 k ^TempGetOneRegINfoGet(UserID)
	 s UserNameGet="" s RegName=""
	 if RegID'="" s RegName=$P(^SSU("SSUSR",RegID),"^",2)
	 if ((UserID'="")&&(UserID'="20121127")) s UserNameGet=$P(^SSU("SSUSR",UserID),"^",2)
	 s ^TempGetOneRegINfo(UserID)=JZ_"^"_TX_"^"_MZ_"^"_$ZD(STDate,4)_"^"_$ZD(EndDate,4)_"^"_RegName_"^"_UserNameGet_"^"_$ZD(+$H,3)_" "_..%ZT(..%SysTime(),2)
	 f Date=STDate:1:EndDate d
	 .s Time=0 f  s Time=$o(^PAADMi("PAADM_DateTime",Date,Time)) q:Time=""  d
	 ..s PaadmRowid=0 f  s PaadmRowid=$o(^PAADMi("PAADM_DateTime",Date,Time,PaadmRowid)) q:PaadmRowid=""  d
	 ...s CreaterUser=$p($g(^PAADM(PaadmRowid)),"^",43) 
	 ...s Ctloc=$p($g(^PAADM(PaadmRowid)),"^",4) 
	 ...s Desc=$p(^CTLOC(Ctloc),"^",2)
	 ...s FlagOK="" 
	 ...//if ((JZ="on")&&(Desc[("急诊"))) s FlagOK="Y"  //按照科室名称区分
	 ...//if ((TX="on")&&(Desc[("特需"))) s FlagOK="Y" 
	 ...//if ((MZ="on")&&(Desc'[("特需"))&&(Desc'[("急诊"))) s FlagOK="Y"
	 ...if (JZ="on") S FlagOK=..GetCtlocType(Ctloc,"JZ") //特需按照科室名称，急诊按照关联，其他的是门诊
	 ...if (TX="on") S FlagOK=..GetCtlocType(Ctloc,"TX") 
	 ...if (MZ="on") S FlagOK=..GetCtlocType(Ctloc,"MZ") 
	 ...Q:FlagOK'="Y"
	 ...s TUserNameID=$p($g(^PAADM(PaadmRowid,2)),"^",69) ;pa_adm.paadm_socialworkername,
	 ...s SocialStatusDesc=""  s BYZGYB="N" ;本院职工医保卡挂号标识 
	 ...s PAPMIDr=$p($g(^PAADM(PaadmRowid)),"^",1)
	 ...s SocialStatusDr=$P($G(^PAPER(PAPMIDr,"PER",1)),"^",10) //使用ID=4为本院职工
	 ...if SocialStatusDr'="" s SocialStatusDesc=$P($G(^CT("SS",SocialStatusDr)),"^",2)
	 ...s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
	 ...s UpdateDate=$p($g(^PAADM(PaadmRowid,1)),"^",42)
	 ...if (VisitStatus="C") d  ;查询以前的记录如果是隔日退号的，退号时间不在查询时间断内，按照正常号处理
	 ....if (UpdateDate>EndDate) d
	 .....s VisitStatus="A" 
	 ...Q:((VisitStatus="C")&&(TUserNameID="")) ;退号人ID为空
	 ...s RegNO=RegNO+1 ;挂号总数量计算
	 ...if VisitStatus="C" s RegReturnNo=RegReturnNo+1 ;退号总数量
	 ...s Admi=PaadmRowid
	 ...S I=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	 ...if I'="" d
	 ....;lxz验证医保
	 ....s Desc="MIS"
	 ....s RegTypeId=$List(^User.DHCRegistrationFeeD(I),19) //出诊级别 (医生对应的号别)
   	 ....if RegTypeId'="" s Desc=$p(^RBC("SESS",RegTypeId),"^",2)
	 ....s GetInsuAdmDr=$List(^User.DHCRegistrationFeeD(I),24)
	 ....//if ((SocialStatusDesc["本院职工")&&(GetInsuAdmDr'="")) s BYZGYB="Y" ;本院职工医 //放开后统计金额本院职工医为0 可计算出本院职工挂号数量
	 ....s RegFee=$List(^User.DHCRegistrationFeeD(I),4) //+$List(^User.DHCRegistrationFeeD(I),9) ;挂号费+诊察费(医药分离后没有侦查费用一项)
	 ....s RegfeeInsuFund=$List(^User.DHCRegistrationFeeD(I),27) ;基金支付
	 ....i RegfeeInsuFund'="" s RegfeeInsuFund=$p(RegfeeInsuFund,"!",2) 
	 ....e  s RegfeeInsuFund=0
	 ....s RegfeeInsuCash=$List(^User.DHCRegistrationFeeD(I),25) ;医保现金支付
	 ....i RegfeeInsuCash'="" s RegfeeInsuCash=$p(RegfeeInsuCash,"!",2) 
	 ....e  s RegfeeInsuCash=0
	 ....s RegfeeInsuCount=$List(^User.DHCRegistrationFeeD(I),26) ;医保账户支付（这个金额在报表中没有统计,只有基金支付)
	 ....i RegfeeInsuCount'="" s RegfeeInsuCount=$p(RegfeeInsuCount,"!",2) 
	 ....e  s RegfeeInsuCount=0
	 ....s Flag="" ;记录号的状态情况
	 ....if (VisitStatus="C")  d
	 .....if (TUserNameID=CreaterUser) s Flag="BR"
	 .....else  s Flag="TR"
	 ....;所有挂出的号分到挂号人的名下
	 ....s Sub=$O(^TempGetOneRegINfo(UserID,CreaterUser,Desc,""),-1)
	 ....if Sub="Return" s Sub=$O(^TempGetOneRegINfo(UserID,CreaterUser,Desc,Sub),-1)+1
	 ....else  s Sub=Sub+1
	 ....s RegFeeStrGet=$$GetTUserID1(PaadmRowid,"A",I) ;始终返回初始票据的总金额
	 ....s RegFee=$P(RegFeeStrGet,"*",1) ;使用发票表计算的金额,挂号表中有时候记录不准确
	 ....s ^TempGetOneRegINfo(UserID,CreaterUser,Desc,Sub)=RegFee_"^"_RegfeeInsuFund_"^"_BYZGYB_"^"_Flag_"^"_RegfeeInsuCash_"^"_GetInsuAdmDr_"^"_PaadmRowid_"^"_"INDate"_"^"_Desc_"^"_RegFeeStrGet
	 ....;退出的号分到退号人名下
	 ....if VisitStatus="C"  d 
	 .....s RegFeeStrGet=$$GetTUserID1(PaadmRowid,"C",I) ;只返回应该退掉的钱(包含部分退的发票)
	 .....s RegFee=$P(RegFeeStrGet,"*",1) 
	 .....s SubRet=$O(^TempGetOneRegINfo(UserID,TUserNameID,Desc,"Return",""),-1)+1
	 .....s ^TempGetOneRegINfo(UserID,TUserNameID,Desc,"Return",SubRet)=RegFee_"^"_RegfeeInsuFund_"^"_BYZGYB_"^"_Flag_"^"_RegfeeInsuCash_"^"_GetInsuAdmDr_"^"_PaadmRowid_"^"_"INDate"_"^"_Desc_"^"_RegFeeStrGet

 	 ;统计就诊日期在查询日期外的，统计时段内的退号记录
 	 f Date=STDate:1:EndDate d
 	 .s PaadmRowid=0  f  s PaadmRowid=$O(^PAADMi("UpdDate",Date,PaadmRowid)) Q:PaadmRowid=""  d
 	 ..s PaadmDate=$p($g(^PAADM(PaadmRowid)),"^",6)
 	 ..Q:PaadmDate=STDate
 	 ..Q:PaadmDate>STDate
 	 ..s VisitStatus=$p($g(^PAADM(PaadmRowid)),"^",20)
 	 ..Q:VisitStatus'="C"
 	 ..s CreaterUser=$p($g(^PAADM(PaadmRowid)),"^",43) 
	 ..s Ctloc=$p($g(^PAADM(PaadmRowid)),"^",4) 
	 ..s Desc=$p(^CTLOC(Ctloc),"^",2)
	 ..s FlagOK="" 
	 ..//if ((JZ="on")&&(Desc[("急诊"))) s FlagOK="Y"
	 ..//if ((TX="on")&&(Desc[("特需"))) s FlagOK="Y" 
	 ..//if ((MZ="on")&&(Desc'[("特需"))&&(Desc'[("急诊"))) s FlagOK="Y"
	 ..if (JZ="on") S FlagOK=..GetCtlocType(Ctloc,"JZ") //特需按照科室名称，急诊按照关联，其他的是门诊
	 ..if (TX="on") S FlagOK=..GetCtlocType(Ctloc,"TX") 
	 ..if (MZ="on") S FlagOK=..GetCtlocType(Ctloc,"MZ") 
	 ..Q:FlagOK'="Y"
	 ..s TUserNameID=$p($g(^PAADM(PaadmRowid,2)),"^",69) ;pa_adm.paadm_socialworkername,
	 ..s SocialStatusDesc=""  s BYZGYB="N" ;本院职工医保卡挂号标识 
	 ..s PAPMIDr=$p($g(^PAADM(PaadmRowid)),"^",1)
	 ..s SocialStatusDr=$P($G(^PAPER(PAPMIDr,"PER",1)),"^",10) //使用ID=4为本院职工
	 ..if SocialStatusDr'="" s SocialStatusDesc=$P($G(^CT("SS",SocialStatusDr)),"^",2)
	 ..Q:((VisitStatus="C")&&(TUserNameID="")) ;退号人ID为空
	 ..//s RegNO=RegNO+1 ;挂号总数量计算 ;统计日期外的隔日退号挂号数量不再增加
	 ..if VisitStatus="C" s RegReturnNo=RegReturnNo+1 ;退号总数量
	 ..s Admi=PaadmRowid
	 ..S I=$O(^User.DHCRegistrationFeeI("ADM",Admi,""))
	 ..if I'="" d
	 ...;lxz验证医保
	 ...s Desc=""
	 ...s RegTypeId=$List(^User.DHCRegistrationFeeD(I),19) //出诊级别 (医生对应的号别)
   	 ...if RegTypeId'="" s Desc=$p(^RBC("SESS",RegTypeId),"^",2)
	 ...s GetInsuAdmDr=$List(^User.DHCRegistrationFeeD(I),24)
	 ...//if ((SocialStatusDr["本院职工")&&(GetInsuAdmDr'="")) s BYZGYB="Y" ;本院职工医保
	 ...s RegFee=$List(^User.DHCRegistrationFeeD(I),4) //+$List(^User.DHCRegistrationFeeD(I),9) ;挂号费+诊察费(医药分离后没有侦查费用一项)
	 ...s RegfeeInsuFund=$List(^User.DHCRegistrationFeeD(I),27) ;基金支付
	 ...i RegfeeInsuFund'="" s RegfeeInsuFund=$p(RegfeeInsuFund,"!",2) 
	 ...e  s RegfeeInsuFund=0
	 ...s RegfeeInsuCash=$List(^User.DHCRegistrationFeeD(I),25) ;医保现金支付
	 ...i RegfeeInsuCash'="" s RegfeeInsuCash=$p(RegfeeInsuCash,"!",2) 
	 ...e  s RegfeeInsuCash=0
	 ...s RegfeeInsuCount=$List(^User.DHCRegistrationFeeD(I),26) ;医保现金支付
	 ...i RegfeeInsuCount'="" s RegfeeInsuCount=$p(RegfeeInsuCount,"!",2) 
	 ...e  s RegfeeInsuCount=0
	 ...s Flag="" ;记录号的状态情况
	 ...if (VisitStatus="C")  d
	 ....if (TUserNameID=CreaterUser) s Flag="BR"
	 ....else  s Flag="TR"
	 ...if VisitStatus="C"  d
	 ....s RegFeeStrGet=$$GetTUserID1(PaadmRowid,"C",I) ;只返回应该退掉的钱(包含部分退的发票)
	 ....s RegFee=$P(RegFeeStrGet,"*",1) 
	 ....s SubRet=$O(^TempGetOneRegINfo(UserID,TUserNameID,Desc,"Return",""),-1)+1
	 ....s ^TempGetOneRegINfo(UserID,TUserNameID,Desc,"Return",SubRet)=RegFee_"^"_RegfeeInsuFund_"^"_BYZGYB_"^"_Flag_"^"_RegfeeInsuCash_"^"_GetInsuAdmDr_"^"_PaadmRowid_"^"_"OutDate"_"^"_Desc_"^"_RegFeeStrGet
 
	 ;统计上边的情况
	 ;合计参数
	 s (AllRegNo1,YXGH1,BYZGYB1,THS1,TBR1,TTR1,SumFee1,THFee1,JKFee1,YBF1,YBNO1,YBN1,ZFN1,THZF1,THYB1,OutDateReturnNO1,NO)=0
	 s (MRFee1,CardFee1,RegFee1,CheckFee1,ReCheckFee1,AppFee1,HoliFee1,OtherFee1)=0
	 s UserReg=0 
	 f  s UserReg=$O(^TempGetOneRegINfo(UserID,UserReg)) Q:UserReg=""  d
	 .Q:((RegID'=UserReg)&&(RegID'="")&&(CheckAll'="on"))
	 .s Desc=0 f  s Desc=$O(^TempGetOneRegINfo(UserID,UserReg,Desc)) Q:Desc=""  d
	 ..//个人小结参数
	 ..s AllRegNo=0 s YXGH=0 s THS=0 s TBR=0 s TTR=0 s JKFee=0  s THFee=0  s YBF=0  s BYZGYB=0 s SumFee=0 s YBNO=0 s OutDateReturnNO=0
	 ..;挂号总数、有效挂号、退号数、退自己所挂号、退的他人的号、交款金额、退款费用、医保费用、本院职工医保卡挂号数、总金额,;个人统计使用
	 ..s (YBN,ZFN,THZF,THYB)=0
	 ..;费用明细
	 ..s (TMRFee,TCardFee,TRegFee,TCheckFee,TReCheckFee,TAppFee,THoliFee,TOtherFee)=0
	 ..s (MRFee,CardFee,RegFee,CheckFee,ReCheckFee,AppFee,HoliFee,OtherFee)=0
	 ..s UserName=$P(^SSU("SSUSR",UserReg),"^",2)
	 ..s SubRet=0 f  s SubRet=$O(^TempGetOneRegINfo(UserID,UserReg,Desc,"Return",SubRet)) Q:SubRet=""  d
	 ...s FeeStr=$G(^TempGetOneRegINfo(UserID,UserReg,Desc,"Return",SubRet))
	 ...s FeeReg=$P(FeeStr,"^",1) ;挂号费用
	 ...s RegfeeInsuFund=$P(FeeStr,"^",2) ;医保医疗费用
	 ...s BYYB=$P(FeeStr,"^",3) ;本院职工医保标识
	 ...s State=$P(FeeStr,"^",4) ;号状态
	 ...s FeeInsuCash=$P(FeeStr,"^",5) ;医保现金支付
	 ...s FeeInsuAdm=$P(FeeStr,"^",6) ;医保流水号
	 ...s AdmRowIDGet=$P(FeeStr,"^",7) ;AdmDr
	 ...s OutDate=$P(FeeStr,"^",8) ;在查询范围外的，时段内退号记录标识
	 ...//s Desc=$P(FeeStr,"^",9) ;出诊级别(号别)
	 ...s GetFeeList=$P(FeeStr,"^",10) ;挂号中的每项明细
	 ...if OutDate="OutDate" s OutDateReturnNO=OutDateReturnNO+1
	 ...if State="BR" s TBR=TBR+1 ;退号中自己的号
	 ...if State="TR" s TTR=TTR+1 ;退号中他人的号
	 ...if FeeInsuAdm=""  d
	 ....s THZF=THZF+1
	 ....s THFee=THFee+FeeReg ;退号总金额
	 ...else  d
	 ....s THYB=THYB+1 ;医保患者数量
	 ....if BYYB="Y" ;本院职工医保号金额为0，不退钱
	 .....s THFee=THFee+0
	 ....else  d
	 .....s THFee=THFee+FeeInsuCash
	 ...s TMRFee=TMRFee+$P(GetFeeList,"*",2)
	 ...s TCardFee=TCardFee+$P(GetFeeList,"*",3)
	 ...s TRegFee=TRegFee+$P(GetFeeList,"*",4)
	 ...s TCheckFee=TCheckFee+$P(GetFeeList,"*",5)
	 ...s TReCheckFee=TReCheckFee+$P(GetFeeList,"*",6)
	 ...s TAppFee=TAppFee+$P(GetFeeList,"*",7)
	 ...s THoliFee=THoliFee+$P(GetFeeList,"*",8)
	 ...s TOtherFee=TOtherFee+$P(GetFeeList,"*",9)
	 ...s THS=SubRet ;退号总数
	 ..;挂号汇总
	 ..k ^TempRegType
	 ..s Sub=0  f  s Sub=$O(^TempGetOneRegINfo(UserID,UserReg,Desc,Sub)) Q:Sub=""  d
	 ...s FeeStr=$G(^TempGetOneRegINfo(UserID,UserReg,Desc,Sub))
	 ...Q:FeeStr=""
	 ...s FeeReg=$P(FeeStr,"^",1) ;挂号费用
	 ...s RegfeeInsuFund=$P(FeeStr,"^",2) ;医保医疗费用
	 ...s BYYB=$P(FeeStr,"^",3) ;本院职工医保标识
	 ...s State=$P(FeeStr,"^",4) ;号状态(为空是有效挂号)
	 ...s FeeInsuCash=$P(FeeStr,"^",5) ;医保现金支付
	 ...s FeeInsuAdm=$P(FeeStr,"^",6) ;医保流水号
	 ...s AdmRowIDGet=$P(FeeStr,"^",7) ;AdmDr
	 ...s OutDate=$P(FeeStr,"^",8) ;在查询范围外的，时段内退号记录标识
	 ...//s Desc=$P(FeeStr,"^",9) ;出诊级别(号别)
	 ...s GetFeeList=$P(FeeStr,"^",10) ;挂号中的每项明细
	 ...s AllRegNo=Sub ;挂号总数
	 ...i State=""  d
	 ....s YXGH=YXGH+1 ;有效挂号数(去除所有退号)
	 ....s YBF=YBF+RegfeeInsuFund
	 ...if ((State="")&&(FeeInsuAdm'="")) s YBNO=YBNO+1
	 ...if FeeInsuAdm=""  d
	 ....s ZFN=ZFN+1
	 ....s SumFee=SumFee+FeeReg ;收款总金额
	 ...else  d
	 ....s YBN=YBN+1
	 ....if BYYB="Y"  d  ;本院职工医保挂号统计金额为0，不收钱
	 .....s SumFee=SumFee+0
	 ....else  d
	 .....s SumFee=SumFee+FeeInsuCash
	 ...if (BYYB="Y")&&(State="") d
	 ....s BYZGYB=BYZGYB+1
	 ...s MRFee=MRFee+$P(GetFeeList,"*",2)
	 ...s CardFee=CardFee+$P(GetFeeList,"*",3)
	 ...s RegFee=RegFee+$P(GetFeeList,"*",4)
	 ...s CheckFee=CheckFee+$P(GetFeeList,"*",5)
	 ...s ReCheckFee=ReCheckFee+$P(GetFeeList,"*",6)
	 ...s AppFee=AppFee+$P(GetFeeList,"*",7)
	 ...s HoliFee=HoliFee+$P(GetFeeList,"*",8)
	 ...s OtherFee=OtherFee+$P(GetFeeList,"*",9)
	 ..s MRFee=MRFee-TMRFee
	 ..s CardFee=CardFee-TCardFee
	 ..s RegFee=RegFee-TRegFee
	 ..s CheckFee=CheckFee-TCheckFee
	 ..s ReCheckFee=ReCheckFee-TReCheckFee
	 ..s AppFee=AppFee-TAppFee
	 ..s HoliFee=HoliFee-THoliFee
	 ..s OtherFee=OtherFee-TOtherFee
	 ..s JKFee=SumFee-THFee
	 ..s StrType=""
	 ..s NO=NO+1
	 ..s SumFee=$Fn(SumFee,"",2) s THFee=$Fn(THFee,"",2) s JKFee=$Fn(JKFee,"",2) s YBF=$Fn(YBF,"",2)
	 ..;统计总量
	 ..s AllRegNo1=AllRegNo1+AllRegNo 
	 ..s YXGH1=YXGH1+YXGH
	 ..s BYZGYB1=BYZGYB1+BYZGYB
	 ..s THS1=THS1+THS
	 ..s TBR1="" s TTR1=""
	 ..s SumFee1=SumFee1+SumFee
	 ..s THFee1=THFee1+THFee
	 ..s JKFee1=JKFee1+JKFee
	 ..s YBF1=YBF1+YBF
	 ..s YBNO1=YBNO1+YBNO
	 ..s YBN1=YBN1+YBN
	 ..s ZFN1=ZFN1+ZFN
	 ..s THZF1=THZF1+THZF
	 ..s THYB1=THYB1+THYB
	 ..s OutDateReturnNO1=OutDateReturnNO1+OutDateReturnNO
	 ..s MRFee1=MRFee1+MRFee
	 ..s CardFee1=CardFee1+CardFee
	 ..s RegFee1=RegFee1+RegFee
	 ..s CheckFee1=CheckFee1+CheckFee
	 ..s ReCheckFee1=ReCheckFee1+ReCheckFee
	 ..s AppFee1=AppFee1+AppFee
	 ..s HoliFee1=HoliFee1+HoliFee
	 ..s OtherFee1=OtherFee1+OtherFee
	 ..s JKFee=SumFee-THFee
	 ..;挂号员姓名、挂号总数、有效挂号(号没有被退掉)、本院职工医保挂号、退号总数、退号中自己的号、退号中他人的号、收款总额、退款总额、应交款、医保基金支付费用、医保患者有效挂号数量、医保挂号总数、自费挂号总数、退号中的自费患者、退号中的医保患者、查询查询日期外就诊，但是在时段内退号的患者
	 ..//w UserName_"^"_AllRegNo_"^"_YXGH_"^"_BYZGYB_"^"_THS_"^"_TBR_"^"_TTR_"^"_SumFee_"^"_THFee_"^"_JKFee_"^"_YBF_"^"_YBNO_"^"_YBN_"^"_ZFN_"^"_THZF_"^"_THYB_"^"_OutDateReturnNO
	 ..//挂号每项费用的明细
	 ..Do OutputRow11
	 ..s Sub=$O(^TempGetOneRegINfoGet(UserID,""),-1)+1
	 ..s ^TempGetOneRegINfoGet(UserID,Sub)=NO_"^"_UserName_"^"_Desc_"^"_AllRegNo_"^"_YXGH_"^"_BYZGYB_"^"_THS_"^"_TBR_"^"_TTR_"^"_SumFee_"^"_THFee_"^"_JKFee_"^"_YBF_"^"_YBNO_"^"_YBN_"^"_ZFN_"^"_THZF_"^"_THYB_"^"_OutDateReturnNO_"^"_MRFee_"^"_CardFee_"^"_RegFee_"^"_CheckFee_"^"_ReCheckFee_"^"_AppFee_"^"_HoliFee_"^"_OtherFee_"^"_StrType
	
	s ind=1
	s NO="" s UserName="合计:" 
	s Desc=""
	s AllRegNo=AllRegNo1
	s YXGH=YXGH1
	s BYZGYB=BYZGYB1
	s THS=THS1
	s TBR=TBR1
	s TTR=TTR1
	s SumFee=SumFee1
	s THFee=THFee1
	s JKFee=JKFee1
	s YBF=YBF1
	s YBNO=YBNO1
	s YBN=YBN1
	s ZFN=ZFN1
	s THZF=THZF1
	s THYB=THYB1
	s OutDateReturnNO=OutDateReturnNO1
	 s MRFee=MRFee1
	 s CardFee=CardFee1
	 s RegFee=RegFee1
	 s CheckFee=CheckFee1
	 s ReCheckFee=ReCheckFee1
	 s AppFee=AppFee1
	 s HoliFee=HoliFee1
	 s OtherFee=OtherFee1
	 s StrType=""
	s SumFee=$Fn(SumFee,"",2) s THFee=$Fn(THFee,"",2) s JKFee=$Fn(JKFee,"",2) s YBF=$Fn(YBF,"",2)
	Do OutputRow11
	s Sub=$O(^TempGetOneRegINfoGet(UserID,""),-1)+1
	s ^TempGetOneRegINfoGet(UserID,Sub)=NO_"^"_UserName_"^"_Desc_"^"_AllRegNo_"^"_YXGH_"^"_BYZGYB_"^"_THS_"^"_TBR_"^"_TTR_"^"_SumFee_"^"_THFee_"^"_JKFee_"^"_YBF_"^"_YBNO_"^"_YBN_"^"_ZFN_"^"_THZF_"^"_THYB_"^"_OutDateReturnNO_"^"_MRFee_"^"_CardFee_"^"_RegFee_"^"_CheckFee_"^"_ReCheckFee_"^"_AppFee_"^"_HoliFee_"^"_OtherFee_"^"_StrType
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow11
	set Data=$lb(NO,UserName,Desc,AllRegNo,YXGH,BYZGYB,THS,TBR,TTR,SumFee,THFee,JKFee,YBF,YBNO,YBN,ZFN,THZF,THYB,OutDateReturnNO,MRFee,CardFee,RegFee,CheckFee,ReCheckFee,AppFee,HoliFee,OtherFee,StrType)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
GetTUserID1(AmdGet,AdmStatuGet,IDr)
	;得到挂号收费金额，或者退号应退金额和部分退剩余金额
	s FeeStr=""
	s VisitStatusGet=$p($g(^PAADM(AmdGet)),"^",20)
	s InvoiceDr=$List(^User.DHCRegistrationFeeD(IDr),11)
	;b ;"InvoiceDr"
	s PRTFlag=$p($g(^DHCINVPRT(+InvoiceDr)),"^",8)
 	s PRTinitInvDR=$p($g(^DHCINVPRT(+InvoiceDr)),"^",13)
 	s PRTOldINVDR=$p($g(^DHCINVPRT(+InvoiceDr)),"^",29)
 	if VisitStatusGet'="C" d
 	.;本身是有效挂号
 	.S FeeStr=$$GetINVPRTList1(+InvoiceDr)
 	else  d
 	.if PRTFlag'="N"  d ;如果记录的票据状态是无效的，说明挂号时全挂全退的直接返回这个票的情况
 	..s FeeStr=$$GetINVPRTList1(+InvoiceDr)
 	.else  d
 	..if AdmStatuGet'="C"  d ;退号的按照正常号处理(处理隔日退号的情况使用，或者是部分退费的时候返回初始状况)
 	...s FeeStr=$$GetINVPRTList(+PRTOldINVDR) ;部分退的应该去找原票的记录
 	..else  d  ;退号的返回退号金额(应减去金额)
 	...s FeeStrOldINVDR=$$GetINVPRTList1(+PRTOldINVDR) //原票
 	...s FeeStrONowINVDR=$$GetINVPRTList1(+InvoiceDr) //现票
 	...s FeeStr=$$INVPRDel1(FeeStrOldINVDR,FeeStrONowINVDR)
 	Q FeeStr
INVPRDel1(FeeStr1,FeeStr2) 
	;两种票据结果做减操作FeeStr1-FeeStr2
	s Long=$L(FeeStr2,"*")
	s ReturnStr=""
	for i=1:1:Long
	{
		s Itm1=$P(FeeStr1,"*",i)
		s Itm2=$P(FeeStr2,"*",i)
		if ReturnStr="" s ReturnStr=(Itm1-Itm2)
		else  s ReturnStr=ReturnStr_"*"_(Itm1-Itm2)
	}
	Q:ReturnStr="" FeeStr1
	Q ReturnStr		
GetINVPRTList1(InvoiceDr)
	;通过发票ID返回这个挂号发票的收费明细
	Q:((InvoiceDr="")||(InvoiceDr=0)) ""
	s (FeeAll,MRFee,CardFee,RegFee,CheckFee,ReCheckFee,AppFee,HoliFee,OtherFee)=0
	s ConRowId="" s FeeAll=0
    if InvoiceDr'=""  d
    .;s FeeAll=$p($g(^DHCINVPRT(+InvoiceDr)),"^",1) ;发票总金额
    .s PRTPatientShare=$p($g(^DHCINVPRT(+InvoiceDr)),"^",16)
    .s FeeAll=PRTPatientShare
    
    if (InvoiceDr'="")	s ConRowId=$O(^DHCBCI(0,"INV",InvoiceDr,0)) 
    s PBRowId="" 
    i ConRowId'="" 	s PBRowId=$P(^DHCBCI(ConRowId),"^",2)
    ;b ;Test 
    if PBRowId'="" D
    .s PBOChild=0 f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
    ..s ArcimId=$P(^DHCPB(PBRowId,"O",PBOChild),"^",3)
    ..Q:ArcimId=""
    ..s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId)
    ..s BillSum=0
    ..s BillSum=$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
    ..if type="MR" d ;病历本
    ...s MRFee=MRFee+BillSum
    ..else  if type="Card" d ;卡费
    ...s CardFee=CardFee++BillSum 
    ..else  if type="Reg" d	;挂号费
    ...s RegFee=RegFee++BillSum
    ..else  if type="Check" d ;检查费
    ...s CheckFee=CheckFee++BillSum
    ..else  if type="ReCheck" d ;复查费
    ...s ReCheckFee=ReCheckFee++BillSum
    ..else  if type="App" d ;预约费
    ...s AppFee=AppFee++BillSum
    ..else  if type="Holi" d ;假日费
    ...s HoliFee=HoliFee++BillSum
    ..else  if type="Other" d ;其他费用
    ...s OtherFee=OtherFee++BillSum
    Q FeeAll_"*"_MRFee_"*"_CardFee_"*"_RegFee_"*"_CheckFee_"*"_ReCheckFee_"*"_AppFee_"*"_HoliFee_"*"_OtherFee
}

ClassMethod GetOneRegINfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetOneRegINfoExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetOneRegINfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetOneRegINfoExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// creater	lxz
/// desc	获得统一报表打印信息
/// input Flag=1 获得打印数据行数  Flag=2 获得打印数据  NO 获得打印数据节点 UserID 用户ID
ClassMethod GetRepInfo(UserID As %String, NO As %String, Flag As %String) As %String
{
	s Str=""
	Q:UserID="" ""
	if (Flag=1)
	{s Str=$O(^TempGetRepInfoGet(UserID,""),-1)}
	if (Flag=2)
	{
		if (NO'="")
		{
			s Str1=$G(^TempGetRepInfo(UserID))
			s Str2=$G(^TempGetRepInfoGet(UserID,NO))
			s Str=Str1_"@"_Str2
	}
	}
	Q Str
}

/// creater	lxz
/// desc	获得个人统一报表打印信息
/// input Flag=1 获得打印数据行数  Flag=2 获得打印数据  NO 获得打印数据节点 UserID 用户ID
ClassMethod GetOneRepInfo(UserID As %String, NO As %String, Flag As %String) As %String
{
	s Str=""
	Q:UserID="" ""
	if (Flag=1)
	{s Str=$O(^TempGetOneRegINfoGet(UserID,""),-1)}
	if (Flag=2)
	{
		if (NO'="")
		{
			s Str1=$G(^TempGetOneRegINfo(UserID))
			s Str2=$G(^TempGetOneRegINfoGet(UserID,NO))
			s Str=Str1_"@"_Str2
	}
	}
	Q Str
}

/// creater   lxz
/// desc     便民挂号如果不走卡消费的话那么挂号表中是不会关联发票信息.   
/// 		    以下方法用来获得这种情况的挂号相关费用,在挂号业务统计中便民挂号如果不走卡消费不统计。交账统计到收费统计业务中。
/// 		  w ##class(web.DHCOPRegReports).GetBMAdmRegSum(118)
ClassMethod GetBMAdmRegSum(Adm As %String) As %String
{
	s HospId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp(Adm),"^",1)
	s MR=0,Card=0,Reg=0,Check=0,ReCheck=0,App=0,Holi=0
	s Sum=0
    	s AdmStatus=$p($g(^PAADM(Adm)),"^",20)
	s DHCBCIRowID=0
	f  s DHCBCIRowID=$O(^DHCBCI(0,"ADM",Adm,DHCBCIRowID)) Q:DHCBCIRowID=""  d
	.s Str=$G(^DHCBCI(DHCBCIRowID))
	.s DHCBCIINVDR=$P(Str,"^",1)
	.s PBRowId=$P(Str,"^",2)
	.Q:DHCBCIINVDR=""
	.s INVFlag=$P($G(^DHCINVPRT(DHCBCIINVDR)),"^",8)
	.;当是有效的挂号时要查找有效的票。
	.;无效的挂号查找原始票不做限制(无效挂号应该不会存在部分退费情况,有有效的发票禁止退号,这样挂号费不存在重计算现象)。
	.Q:((AdmStatus="A")||(AdmStatus="D"))&&(INVFlag'="N")  
    .s PBOChild=0 f  s PBOChild=$O(^DHCPB(PBRowId,"O",PBOChild)) Q:PBOChild=""  d
    ..s ArcimId=$P($G(^DHCPB(PBRowId,"O",PBOChild)),"^",3)
    ..Q:ArcimId=""
    ..s type=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId,HospId)
    ..s BillSum=+$P(^DHCPB(PBRowId,"O",PBOChild),"^",11)
    ..;other会有药品
    ..if type="MR"  s MR=MR+BillSum s Sum=Sum+BillSum
    ..else  if type="Card"  s Card=Card+BillSum s Sum=Sum+BillSum
    ..else  if type="Reg"  s Reg=Reg+BillSum s Sum=Sum+BillSum
    ..else  if type="Check"  s Check=Check+BillSum s Sum=Sum+BillSum
    ..else  if type="ReCheck"  s ReCheck=ReCheck+BillSum s Sum=Sum+BillSum
    ..else  if type="App"  s App=App+BillSum s Sum=Sum+BillSum
    ..else  if type="Holi"  s Holi=Holi+BillSum s Sum=Sum+BillSum
    s Str=Sum_"^"_Reg_"^"_Check_"^"_MR_"^"_Card_"^"_ReCheck_"^"_App_"^"_Holi
    if (Sum=0){
	    q ..GetAdmRegSum(Adm)
	}
    q Str
}

ClassMethod GetAdmRegSum(Adm As %String) As %String
{
	;取价格
	s PatientID=$p(^PAADM(Adm),"^",1)
	s Sum=0
	 s MR=0,Card=0,Reg=0,Check=0,ReCheck=0,App=0,Holi=0
	 s AdmDate=..%SysDate()
	 s AdmReason=$P(^PAADM(Adm,1),"^",7)
	 s Price=0,chrhfee=0,holi=0,AppFee=0,OtherFee=0,ReCheckFee=0
	 s PriceArcId="",chrhfeeArcId="",holiId="",AppFeeId="",OtherFeeId=""
	 s I=$O(^User.DHCRegistrationFeeI("ADM",Adm,""))
	 q:I="" Sum_"^"_Reg_"^"_Check_"^"_MR_"^"_Card_"^"_ReCheck_"^"_App_"^"_Holi
	 s ASRowId=$List(^User.DHCRegistrationFeeD(I),18)
	 q:ASRowId="" Sum_"^"_Reg_"^"_Check_"^"_MR_"^"_Card_"^"_ReCheck_"^"_App_"^"_Holi
	 s HospId=$p(##class(web.DHCOPAdmReg).GetCurrentHosp("","",ASRowId,""),"^",1)
	 s OrdID=$o(^OEORD(0,"Adm",Adm,0))

	 ;取挂号费和诊查费和节假日挂号费信息
	 s SerIdStr=##class(web.DHCOPAdmReg).GetScheduleService(ASRowId,AdmReason,HospId)
	 s SerIdStr=##class(web.DHCOPAdmReg).GetCustomScheduleService(PatientID,ASRowId,SerIdStr)
	 s RegConDisIdPara=PatientID_"^"_ASRowId_"^"_AdmReason_"^"_""
	 s RegConDisId=##class(web.DHCOPAdmReg).GetRegConDisId(RegConDisIdPara)
	 i SerIdStr'="" {
		 f i=1:1:$l(SerIdStr,"^") {
			s ArcimId=$P(SerIdStr,"^",i)
			;此处应先判断医嘱是否存在，避免没有插入医嘱导致的费用不对,如就诊登记不插入诊查费
			s VaildOrdFlag=0
			if OrdID'="" d
			.s StDate=$o(^OEORDi(0,"ARCIM",OrdID,ArcimId,0)) 
			.i StDate'="" s SubID=$o(^OEORDi(0,"ARCIM",OrdID,ArcimId,StDate,0)) 
			.i $g(SubID)'="" d
			..s ItemStatID=$p($g(^OEORD(OrdID,"I",SubID,1)),"^",13)
			..s:ItemStatID'="" StatusCode=$p(^OEC("OSTAT",ItemStatID),"^",1)
			..i $g(StatusCode)="V" s VaildOrdFlag=1
			continue:VaildOrdFlag'=1
			
			 s BillPrice=$p(##Class(web.UDHCJFPRICE).GetOrderPrice("",AdmReason,ArcimId,AdmDate,"","","","",HospId,RegConDisId),"^",4)
			 s RegSerBillSubType=##class(web.DHCOPAdmReg).GetRegArcimBillSubType(ArcimId,HospId)
			 if RegSerBillSubType="Reg"  d 
			 .set Reg=BillPrice+Reg
			 if RegSerBillSubType="Check" d
			 .set Check=BillPrice+Check
			 if RegSerBillSubType="Holi" d
			 .set Holi=BillPrice+Holi
			 if RegSerBillSubType="App" d
			 .set App=BillPrice+App
			 if RegSerBillSubType="Other" d
			 .set Card=BillPrice+Card
			 if RegSerBillSubType="ReCheck" d
			 .set ReCheck=BillPrice+ReCheck
			 if RegSerBillSubType="MR" d
			 .set MR=BillPrice+MR
		 }
	 }
	 s Sum=Reg+Check+MR+Card+ReCheck+App+Holi
	 q Sum_"^"_Reg_"^"_Check_"^"_MR_"^"_Card_"^"_ReCheck_"^"_App_"^"_Holi
}

ClassMethod getRegQueryNum(user, inum)
{
	s str=""
	if inum="" {
		s str=$o(^TMPRegQuery(user,""),-1)
	}else{
		s str=$g(^TMPRegQuery(user,inum))
	}
	Q str
}

Query FindDHCRegConDis() As %Query(ROWSPEC = "DRCDDesc:%String:挂号优惠,DRCDRowid:%String") [ SqlProc ]
{
}

ClassMethod FindDHCRegConDisClose(ByRef QHandle As %Binary) As %Status [ PlaceAfter = FindDHCRegConDisExecute ]
{
	// Clean up by purging the temporary node in ^CacheTemp global
	//New repid
	Set repid=$li(QHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.CTLoc","FindDHCRegConDis")
ClassMethod FindDHCRegConDisExecute(ByRef QHandle As %Binary) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s TDate=..%SysDate()
	s TTime=..%SysTime()
	s DRCDRowid=""
	f  s DRCDRowid=$o(^DHCRCD(DRCDRowid)) q:DRCDRowid=""  d
	.s DRCDCode=$p($g(^DHCRCD(DRCDRowid)),"^",1)
	.s DRCDDesc=$p($g(^DHCRCD(DRCDRowid)),"^",2)
	.q:DRCDDesc=""
	
	.s RCDStartDate=$p($g(^DHCRCD(DRCDRowid)),"^",4)
	.s RCDStartTime=$p($g(^DHCRCD(DRCDRowid)),"^",5)
	.s RCDEndDate=$p($g(^DHCRCD(DRCDRowid)),"^",6)
	.s RCDEndTime=$p($g(^DHCRCD(DRCDRowid)),"^",7)
	
    .q:((RCDStartDate'="")&&(TDate<RCDStartDate))||((RCDEndDate'="")&&(TDate>RCDEndDate))
    .q:((RCDStartDate'="")&&(TDate=RCDStartDate)&&(TTime<RCDStartTime))||((RCDEndDate'="")&&(TDate=RCDEndDate)&&(TTime>RCDEndTime))
	
	
	.Do OutputRow12
	Set QHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow12
	set Data=$lb(DRCDDesc,DRCDRowid)
	Set ^CacheTemp(repid,ind)=Data	
	Set ind=ind+1
	quit
}

ClassMethod FindDHCRegConDisFetch(ByRef QHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindDHCRegConDisExecute ]
{
	//New repid,ind
	Set AtEnd=$li(QHandle,1)
	Set repid=$li(QHandle,2)
	Set ind=$li(QHandle,3)
	
	Set ind=$o(^CacheTemp(repid,ind))
	If ind="" {	// if there are no more rows, finish fetching
		 Set AtEnd=1
		 Set Row=""
	}
	Else      {	// fetch row
		Set Row=^CacheTemp(repid,ind)
	}
	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

}
