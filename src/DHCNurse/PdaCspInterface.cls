Class DHCNurse.PdaCspInterface Extends %SOAP.WebService [ ClassType = "", ProcedureBlock ]
{

Parameter SERVICENAME = "PdaClsInterface";

/// TODO: change this to actual network address.
/// URL for invoking the WebService.
Parameter LOCATION = "http://172.26.201.3/trakcarelive/trak/web";

/// TODO: change this to actual SOAP namespace.
/// SOAP Namespace for the WebService
Parameter NAMESPACE = "http://www.dhcc.com.cn";

/// TODO: add arguments and implementation.
/// Test
ClassMethod Logon(userid, pinnumber) As %String [ WebMethod ]
{
	s ret=##Class(web.DHCPdaNurComm).Logon(userid, pinnumber)
	w ret
	q 0
}

ClassMethod NurInit(UserId As %String) As %String [ WebMethod ]
{
	//初始化
	s ret=##class(web.DHCPdaComm).Init(UserId)
	s ret=##class(web.DHCPdaNurComm).GetSystTime()
	s emr=##class(web.DHCPdaNurComm).GetEmrInterface()
	w ret_"|"_emr
	q 0
}

ClassMethod GetUserGrp(User As %String, logloc As %String) As %String [ WebMethod ]
{
    //2008-11-11
	s grp=##class(web.DHCPdaNurComm).GetUserGrp(User,logloc)
	w grp
	q 0
}

ClassMethod GetQueryData(QueryName As %String, Par1 As %String) As %String [ WebMethod ]
{
    //s ^TMP(0)=$LB(QueryName,Par1)
	if Par1="0" s Par1=""
    s ret=##class(web.DHCNURPDAQUEXCUTE).GetQueryData(QueryName,Par1)
    w ret
 	q 0
}

ClassMethod ChangeBed(Adm As %String, BedDr As %String, PreBedDr As %String, User As %String) As %String [ WebMethod ]
{
	//s ^TMP(0)=$LB(Adm, BedDr, PreBedDr, User)
	s ret=##class(web.DHCPdaComm).UpdateBed(Adm, BedDr, PreBedDr, User)
	w ret
	q 0
}

ClassMethod GetCurrAdm(RegNo As %String) As %String [ WebMethod ]
{
	s a=$I(^qtmp("zgyd_in",RegNo))
	//进入函数时间
	s ^qtmp("zgyd_in",RegNo,a)=$ZD(+$H,3)_"^"_$ZT($P($H,",",2))
	
	s Adm=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(RegNo)
    s Ret="-1"
	if Adm'="" {
		s str=##class(web.DHCPdaComm).NurPatInfo(Adm)
		s Ret=Adm_"$"_str
		w Ret
		}
		
	s a=$I(^qtmp("zgyd_out",RegNo))
	///出函数时间
	s ^qtmp("zgyd_out",RegNo,a)=$ZD(+$H,3)_"^"_$ZT($P($H,",",2))

	q Ret
}

ClassMethod GetObInOutTime(Adm As %String, Date As %String, Grp As %String) As %String [ WebMethod ]
{
	s itmstr=##class(web.DHCPdaComm).GetObserTime(Adm,Date,Grp)
	w itmstr
	q 0
}

ClassMethod GetObserData(Adm As %String, CDate As %String, CTime As %String, Grp As %String) As %String [ WebMethod ]
{
 	//s ^TMP(0)=$LB(Adm,CDate,CTime,Grp)
 	s CDate=$ZDH(CDate,3)
 	if CTime'="" s CTime=$ZTH(CTime,3)
 	e  s CTime=$P($H,",",2)
 	s result=##class(web.DHCNURPDAQUEXCUTE).GetObserData(Adm, CDate, CTime,Grp)
 	w result
 	q 0
}

ClassMethod InsertData(datastr As %String, Grp As %String = "-1") As %String [ WebMethod ]
{
	s ln=$L(datastr,"|")
	s setstr=##class(web.DHCPdaObserData).GetSingleTempdata()
	s tempid=$P(setstr,"^",3)
	s wultempid=$P(setstr,"^",1)
	for i=1:1:ln-1
	{
		s Value=""
    	s str=$P(datastr,"|",i)
    	s RowId=$P(str,"^",1)
		s StrItem=$P(str,"^",2)
		s StrDate=$P(str,"^",3)
    	s StrTime=$P(str,"^",4)
    	if (StrTime="-1") s StrTime=$ZT($P($H,",",2),3)
		s StrUser=$P(str,"^",5)
		s Value=$P(str,"^",6)
		s StrGroup=$P(str,"^",7)
		if StrItem=wultempid
		{
			s ret=##class(web.DHCTHREEE).InsertDesc(RowId, tempid, StrDate, StrTime, StrUser, Value) ;,StrGroup
		}
		s ret=##class(web.DHCTHREEE).InsertData(RowId, StrItem, StrDate, StrTime, StrUser, Value) ;,StrGroup
	}
	w ret
	q 0
}

ClassMethod GetNextPatRegNo(RegNo As %String = "") As %String [ WebMethod ]
{
   s ret=##class(web.DHCPdaComm).GetNextPatRegNo(RegNo)
   w ret
   q 0
}

ClassMethod GetReasonNotAvail(QueryName As %String) As %String [ WebMethod ]
{
	//s ^TMP(0)=QueryName	 
    s ret=##class(web.DHCNURPDAQUEXCUTE).GetQueryData(QueryName,"")
	w ret
	q 0
}

ClassMethod GetDataOrdItem(WardLoc As %String, Adm As %String, Excute As %String, UnExcute As %String, scroll As %String, UserId As %String, VarTyp) As %String [ WebMethod ]
{
	//New result
  	if Adm'="0" s Adm=##class(web.DHCNURPDAQUEXCUTE).GetCurrAdm(Adm)
  	if (WardLoc="")&(Adm="") q -1
  	if VarTyp="-1" s VarTyp=""
  	s ^TMP2=$LB(WardLoc,Adm ,Excute,UnExcute,scroll,UserId,VarTyp)
  	s RetStr=##class(web.DHCNURPDAQUEXCUTE).GetOrdData(WardLoc,Adm ,Excute,UnExcute,scroll,UserId,VarTyp)
 	
 	w RetStr
 	q 0
}

ClassMethod GetPdaHead(Parr As %String = "") As %String [ WebMethod ]
{
	s ret=##class(web.DHCNURPDAQUEXCUTE).GetPdaHead()
	w ret
	q 0
}

ClassMethod ExcuteOrd(Parr As %String) As %String [ WebMethod ]
{
	
	s ln=$L(Parr,"!")
	
	s ret=0
	for i=1:1:ln
	{
		s paritem=$P(Parr,"!",i)
		if (paritem="") continue
		s execTyp=$p(paritem,"^",1)
		s userid=$P(paritem,"^",4)
		s rowid=$P(paritem,"^",5)
		s skinflag=$P(paritem,"^",7)
		s userdeptid=""
		s userdeptid=$P(paritem,"^",8)
		;i skinflag'="" d
		i execTyp="Y" s ret=##class(web.DHCLCNUREXCUTE).UpdateOrdGroup("",rowid,"F",userid,userdeptid,"","","","")
		i execTyp="X" s ret=##class(web.DHCLCNUREXCUTE).SetDisconOrder(rowid,userid)
		;e  d
		;.s ret=##class(web.DHCLCNUREXCUTE).SetSkinTestResult(rowid,userid,skinflag,"F",userdeptid,"","","","")
	}
	w ret
	q 0
}

ClassMethod SetDisconOrd(OrdRow As %String, User As %String) As %String [ WebMethod ]
{
	s ln=$L(OrdRow,"!")
	//s ^TMP(0)=$H
	for i=1:1:ln
	{
		s Orw=$P(OrdRow,"!",i)
     	s oeorirow=$P(OrdRow,"||",1)_"||"_$P(OrdRow,"||",2)
	 	s ret=##class(web.DHCPdaNurComm).SetDisconOrder(oeorirow,User)
	}
	w ret
	q 0
}

ClassMethod UnExcute(oeoriId As %String, arcicId As %String, oecprDesc As %String, userId As %String) As %String [ WebMethod ]
{
	s ln=$L(oeoriId,"!")
	
	for i=1:1:ln-1
	{
     s Orw=$P(oeoriId,"!",i)
     
	 s ret=##class(web.DHCLCNUREXCUTE).UpdateOrdGroup("",Orw,"C",userId,"","","","","")
	}
	w ret
	q 0
}

ClassMethod UndoDisconOrd(OrdRow As %String, User As %String) As %String [ WebMethod ]
{
	s ln=$L(OrdRow,"!")
	//s ^TMP(0)=$H
	for i=1:1:ln
	{
     s Orw=$P(OrdRow,"!",i)
	 s ret=##class(web.DHCPdaNurComm).UndoDisconOrder(Orw,User)
	}
	w ret
	q 0
}

ClassMethod GetUserId(UserCode As %String, Pin As %String) As %String [ WebMethod ]
{
	s ret=##class(web.DHCPdaNurComm).Logon(UserCode,Pin)
	w ret
	q 0
}

ClassMethod GetExecUserInfo(UserCode As %String) As %String [ WebMethod ]
{
	s ret=##class(web.DHCPdaNurComm).ExecUserInfo(UserCode)
	w ret
	q 0
}

ClassMethod GetOtherData(EpisodeID As %String = "") As %String [ WebMethod ]
{
   s ret=##class(web.DHCPdaObserData).GetOtherData(EpisodeID)
   w ret
   q 0
}

ClassMethod DeleteOtherData(rowid As %String = "") As %String [ WebMethod ]
{
   s ret=##class(web.DHCPdaObserData).DeleteOtherData(rowid)
   w ret
   q 0
}

ClassMethod InsertOtherData(EpisodeID As %String = "", eventDate As %String = "", eventTime As %String = "", eventType As %String = "", insertUser As %String = "") As %String [ WebMethod ]
{
   s ret=##class(web.DHCPdaObserData).InsertOtherData(EpisodeID,eventDate,eventTime,eventType,insertUser)
   q ret
}

ClassMethod GetPatInfo(Row As %String) As %String [ WebMethod ]
{
	//s ^TMP(0)=Para
	s ret=##class(web.DHCPdaComm).NurPatInfo(Row)
	w ret
	q 0
}

ClassMethod GetOrdData(parr As %String) As %String [ WebMethod ]
{
    // 短嘱
   //Adm As %String, StartDate As %String, EndDate As %String, ChangeDate As %String, stop As %String = "0"
	s ret=##class(web.DHCPdaTempOrd).GetOrddta(parr)
    w ret
    q 0
}

ClassMethod GetRadiaNote(Row As %String) As %String [ WebMethod ]
{
	//取报告
   s ret=##class(web.DHCPdaTempOrd).GetRadiaNote(Row)
   s ret=$TR(ret,$c(10)," ")
   s ret=$TR(ret,$c(1)," ")
   w ret
   q 0
}

ClassMethod GetCodeData(UserId As %String, GrpCode As %String) As %String [ WebMethod ]
{
	s querytyp=##class(web.DHCNURPDAQUEXCUTE).GetQueryTyp(GrpCode,UserId)
	w querytyp
	q 0
}

ClassMethod SetDanJuDate(parr As %String, user As %String) As %String [ WebMethod ]
{
	s ret=##class(web.DHCNURPDAQUEXCUTE).SetVarTyp(parr,user)
  	w 0
  	q 0
}

ClassMethod GetArcimBasinfo(ORW) As %String [ WebMethod ]
{
    //医嘱信息
	s Oew=$P(ORW,"||"),Chl=$P(ORW,"||",2)
	s exechl=$P(ORW,"||",3)
	s ret=##class(web.DHCPdaLongTimeOrd).GetArcimBasinfo(Oew,Chl,exechl)
	w ret
	q 0
}

ClassMethod GetCode(user) As %String [ WebMethod ]
{
	set retStr=""
	//GetPhcinGetOrdStatGetOecpr
	s retStr=..GetQueryData("web.DHCPdaNurComm:GetOrcat",user)_"!"_..GetQueryData("web.DHCPdaNurComm:GetPhcin",user)_"!"_..GetQueryData("web.DHCPdaNurComm:GetOecpr",user)_"!"_..GetQueryData("web.DHCPdaNurComm:GetPhFreq",user)
    w retStr
    q 0
}

ClassMethod GetArcim(CATCode As %String, Item As %String, GroupRID As %String, EpisodeId As %String) As %String [ WebMethod ]
{
	s ret=##class(web.DHCPdaNurComm).GetArcim(CATCode,Item , GroupRID , EpisodeId)
	w ret
	q 0
}

ClassMethod GetEPARCIMDetail(EpisodeID As %String, InsType As %String, OrderDepRowid As %String, ArcimRowid As %String) As %String [ WebMethod ]
{
	s ArcDetail=##class(web.DHCDocOrderCommon).GetEPARCIMDetail(EpisodeID, "", "", ArcimRowid )
	w ArcDetail
	q 0
}

ClassMethod SaveTempOrdStr(Adm, OrdStr) As %String [ WebMethod ]
{
    s ret=##class(web.DHCDOCPDAENTRY).SaveTempOrdStr(Adm, OrdStr)
    w ret
    q 0
}

ClassMethod GetTemOrd(Adm, Id) As %String [ WebMethod ]
{
	q ^TMP("PDATEMPORD",Adm,Id)
}

ClassMethod UpdateTempOrd(Adm As %String, Id As %String, OrdItem As %String) As %String [ WebMethod ]
{
	s ret=##class(web.DHCDOCPDAENTRY).UpdateTempOrd(Adm, Id , OrdItem)
	w ret
	q 0
}

ClassMethod GetlabOritem(LabEpisode As %String, Adm As %String, messageFlag As %String = "0") As %String [ WebMethod ]
{
	//s messageFlag=0
	s ret=##class(web.DHCPdaNurComm).GetlabOritem(LabEpisode,Adm,messageFlag)
	w ret
	q 0
}

ClassMethod GetRelationOrd(RowId, No, Adm, messageFlag As %String = "0") As %String [ WebMethod ]
{
	//s messageFlag=0
	s ret=##class(web.DHCPdaNurComm).GetRelationOrd(RowId, No, Adm,messageFlag)
	w ret
	q 0
}

ClassMethod GetOrdNo(Adm As %String) As %String [ WebMethod ]
{
	s count=##class(web.DHCNURPDAQUEXCUTE).GetOrdNo(Adm)
	w count
	q 0
}

ClassMethod ScanExcute(RowId, User, userdeptid) As %String [ WebMethod ]
{
	s ret=##class(web.DHCPdaNurComm).ScanExcute(RowId, User, userdeptid)
	w ret
	q 0
}

ClassMethod ScanExcuteLabOrd(LabEpisode, user, userdeptid) As %String [ WebMethod ]
{
	s ret=##class(web.DHCPdaNurComm).ScanExcuteLabOrd(LabEpisode, user,userdeptid)
	w ret
	q 0
}

ClassMethod GetPatValue(Adm As %String, StDate As %String, EndDate As %String) As %String [ WebMethod ]
{
	s StDate=$ZDH(StDate,3)
	s EndDate=$ZDH(EndDate,3)
	s ret=##class(web.DHCPdaComm).GetPatValue(Adm, StDate, EndDate)
	w ret
	q 0
}

ClassMethod PDAVersion(address = "", version = "") As %String [ WebMethod ]
{
	s flag=0
	i (address'="")&($l(address,".")=4) d
	.s updateAddressStr=$g(^DHCCLNurseExecAddress("DHCNur","Address"))
	.;i updateAddressStr="" s updateAddressStr="0.0.0.0-255.255.255.255"
	.s num=$l(updateAddressStr,"^")
	.f i=1:1:num d
	..q:flag=1
	..s updateAddress=$p(updateAddressStr,"^",i)
	..q:updateAddress=""
	..s minUpdateAddress=$p(updateAddress,"-",1)
	..q:minUpdateAddress=""
	..q:$l(minUpdateAddress,".")'=4
	..s maxUpdateAddress=$p(updateAddress,"-",2)
	..q:maxUpdateAddress=""
	..q:$l(maxUpdateAddress,".")'=4
	..s minUpdateAddressA=$p(minUpdateAddress,".",1)
	..s minUpdateAddressB=$p(minUpdateAddress,".",2)
	..s minUpdateAddressC=$p(minUpdateAddress,".",3)
	..s minUpdateAddressD=$p(minUpdateAddress,".",4)
	..s maxUpdateAddressA=$p(maxUpdateAddress,".",1)
	..s maxUpdateAddressB=$p(maxUpdateAddress,".",2)
	..s maxUpdateAddressC=$p(maxUpdateAddress,".",3)
	..s maxUpdateAddressD=$p(maxUpdateAddress,".",4)
	..s addressA=$p(address,".",1)
	..s addressB=$p(address,".",2)
	..s addressC=$p(address,".",3)
	..s addressD=$p(address,".",4)
	..s intMinUpdateAddress=minUpdateAddressA*256*256*256+minUpdateAddressB*256*256+minUpdateAddressC*256+minUpdateAddressD
	..s intMaxUpdateAddress=maxUpdateAddressA*256*256*256+maxUpdateAddressB*256*256+maxUpdateAddressC*256+maxUpdateAddressD
	..s intAddress=addressA*256*256*256+addressB*256*256+addressC*256+addressD
	..i (intAddress>=intMinUpdateAddress)&(intAddress<=intMaxUpdateAddress) d
	...s flag=1
	i flag=1 s ret="1.0.0.3" //最新版本号
	e  d
	.s ret="1.0.0.2"  //当前旧版本号
	.i version'="" s ret=version
	w ret
	q 0
}

ClassMethod deltempord(Adm, Id) As %String [ WebMethod ]
{
	s ret=##Class(web.DHCDOCPDAENTRY).deltempord(Adm, Id)
	w ret
	q 0
}

ClassMethod GetEventTyp(Parr As %String = "") As %String [ WebMethod ]
{
   s ret=##class(web.DHCPdaObserData).GetEventTyp()
   w ret
   q 0
}

ClassMethod MultiSetRel(Adm, nostr) As %String [ WebMethod ]
{
	s ret=##class(web.DHCDOCPDAENTRY).MultiSetRel(Adm, nostr)
	w ret
	q 0
}

ClassMethod InsertOrderItem(Adm As %String, OrdItemStr As %String, User As %String, Loc As %String, Doc As %String) As %String [ WebMethod ]
{
	s ret=##class(web.DHCDOCPDAENTRY).InsertOrderItem(Adm,OrdItemStr,User,Loc,Doc)
	w ret
	q 0
}

/// added by panshuai 2013-03-11 
ClassMethod GetDepModel(LocId As %String) As %String [ WebMethod ]
{
	//初始化
	s ret=##class(web.DHCNurseRecordComm).GetDepModel(LocId)
	w ret
	q 0
}

}
