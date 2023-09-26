Import SQLUser

/// 医生工作量统计
Class web.DHCPE.Report.DoctorWorkStatistic Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 433;

ClassMethod SetTempGlobal(KillFlag, DocNo As %Library.String = "", DocDR As %Library.String = "", DocInitials As %Library.String = "", OEItemDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", VIPLevel As %Library.String = "", StationID As %Library.String = "", FindType As %String = "")
{
	//DateBegin As %Library.String = "", DateEnd
	s CurUserID=%session.Get("LOGON.USERID")
	s:DateBegin[("-") DateBegin=$ZDH(DateBegin,3)
	s:DateEnd[("-") DateEnd=$ZDH(DateEnd,3)
	s:DateBegin[("/") DateBegin=$ZDH(DateBegin,4)
	s:DateEnd[("/") DateEnd=$ZDH(DateEnd,4)
	i DateBegin="" s DateBegin=1
	i DateEnd="" s DateEnd=+$H
	
	i KillFlag=1 d
	.k ^DHCPETMPDWA("DoctorWorkStatistic","InfoExport","List",CurUserID)
 	.k ^DHCPETMPDWA(CurUserID)
	.k ^TempDHCPEDocWorkStati(CurUserID)
	s i=0
	s AdmDate=DateBegin-1
	i FindType'="on" d
	.f  s AdmDate=$o(^DHCPERLT(0,"DateUser",AdmDate)) q:(AdmDate="")||(AdmDate>DateEnd)||(i>9)  d
	..s i=i+1
	..s UserID=0
	..f  s UserID=$o(^DHCPERLT(0,"DateUser",AdmDate,UserID)) q:(UserID="")  d
	...s Flag=$D(^DHCPELocWork("DOC",UserID))
	...i Flag=0 s Flag=2
	...s OEOrdItemDr=""
	...f  s OEOrdItemDr=$o(^DHCPERLT(0,"DateUser",AdmDate,UserID,OEOrdItemDr)) q:(OEOrdItemDr="")  d
	....s OEORDRowId=$P($g(OEOrdItemDr),"||",1)
	....s OEORIChildsub=$P($g(OEOrdItemDr),"||",2)
	....s OEORIItemStatDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",13)
	....q:OEORIItemStatDR'="6"
    ....s ItmMastDR=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,1)),"^",2)
    ....s Station=$o(^DHCPEST(0,"STORD_ARCIM",ItmMastDR,0))
	....Q:(""'=OEItemDR)&(ItmMastDR'=OEItemDR)
    ....q:(StationID'="")&(StationID'=Station)
 	....s spec=$P($G(^OEORD(OEORDRowId,"I",OEORIChildsub,3)),"^",20)
 	....s rltid=$o(^DHCPERLT(0,"DateUser",AdmDate,UserID,OEOrdItemDr,0))
 	....s PAADM=$p(^DHCPERLT(rltid),"^",1)
 	....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)        //Add by 090702
  	....q:LocFlag=1
 	....s IADMRowId=$o(^DHCPEIADM(0,"PAADM",PAADM,0))
 	....s PreIADM=$P($g(^DHCPEIADM(IADMRowId)),"^",4)
 	....i PreIADM'=""  s VIPLevelID=$p($g(^DHCPEPreIADM(PreIADM)),"^",18)
 	....q:(VIPLevel'="")&&(VIPLevel'=VIPLevelID)
 	....s GADM=$P($g(^DHCPEIADM(IADMRowId)),"^",2)
 	....q:((GroupDR'="")&&(GroupDR'=GADM))
	....s QFlag=0
	....i spec="" d
	.....s RLTUser=$p($g(^SSU("SSUSR",UserID)),"^",2)	//检查医师名称	SS_User
    .....s SSUSRInitials =$P($G(^SSU("SSUSR",UserID)),"^",1)
    .....s:(DocNo'="")&(SSUSRInitials'=DocNo) QFlag=1
   	.....s:(DocDR'="")&(DocDR'=UserID) QFlag=1
    ....e  d
    .....i UserID="" d
    ......s CurName=""
    ......s UserID=$G(^DHCENSCheckHeal("CHECKTHEAL",spec))
    ......s:DocDR'="" CurName=$P($G(^SSU("SSUSR",DocDR)),"^",1)
    ......s:UserID'[CurName QFlag=1
    ......i DocNo'="" d
    .......s CurUserID=$O(^SSU("SSUSR",0,"SSUSR_Initials",DocNo,0))
    .......s:CurUserID'="" CurName=$P($G(^SSU("SSUSR",CurUserID)),"^",1)
    .......s:UserID'[CurName QFlag=1
    .....e  d
    ......s:(DocNo'="")&(UserID'=DocNo) QFlag=1
    ......i DocDR'="" d
    .......s DocInitials=$P($G(^SSU("SSUSR",DocDR)),"^",1)
    .......s:(DocDR'="")&(UserID'=DocInitials) QFlag=1
    ....q:QFlag=1
    ....s ^DHCPETMPDWA(CurUserID,"Doctor",Flag,UserID,ItmMastDR)=+$G(^DHCPETMPDWA(CurUserID,"Doctor",Flag,UserID,ItmMastDR))+1	
  	....s ^DHCPETMPDWA(CurUserID,"Doctor",Flag,UserID,ItmMastDR,IADMRowId)=1
  	....s ^DHCPETMPDWA(CurUserID,"DoctorList",UserID,ItmMastDR,IADMRowId)=1
  	....s ^DHCPETMPDWA(CurUserID,"Doctor",Flag,UserID)=+$G(^DHCPETMPDWA(CurUserID,"Doctor",Flag,UserID))+1
  	....i GADM'=""   s ^DHCPETMPDWA(CurUserID,"GADM",UserID,ItmMastDR)=+$G(^DHCPETMPDWA(CurUserID,"GADM",UserID,ItmMastDR))+1	
  	....e  s ^DHCPETMPDWA(CurUserID,"IADM",UserID,ItmMastDR)=+$G(^DHCPETMPDWA(CurUserID,"IADM",UserID,ItmMastDR))+1
  	....i VIPLevelID'=""  d
  	.....s ^DHCPETMPDWA(CurUserID,"VIP",UserID,ItmMastDR,VIPLevelID)=+$G(^DHCPETMPDWA(CurUserID,"VIP",UserID,ItmMastDR,VIPLevelID))+1
    .....s ^DHCPETMPDWA(CurUserID,"VIPTotal",VIPLevelID)=+$G(^DHCPETMPDWA(CurUserID,"VIPTotal",VIPLevelID))+1

	e  d
	.f  s AdmDate=$o(^DHCPERLT(0,"DateUser",AdmDate)) q:(AdmDate="")||(AdmDate>DateEnd)||(i>9)  d
	..s UserID=0
	..f  s UserID=$o(^DHCPERLT(0,"DateUser",AdmDate,UserID)) q:(UserID="")  d
	...s OEOrdItemDr=""
	...f  s OEOrdItemDr=$o(^DHCPERLT(0,"DateUser",AdmDate,UserID,OEOrdItemDr)) q:(OEOrdItemDr="")  d
	....s Adm=$P(^OEORD(+OEOrdItemDr),"^",1)
	....s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",Adm)        
  	....q:LocFlag=1
 	....s IADMRowId=$o(^DHCPEIADM(0,"PAADM",Adm,0))
	....q:$D(^TempDHCPEDocWorkStati(CurUserID,UserID,Adm))
	....s ^TempDHCPEDocWorkStati(CurUserID,UserID,Adm)=""
	....s ii=$I(^DHCPETMPDWA(CurUserID,"Doc",UserID))
	....s ^DHCPETMPDWA(CurUserID,"Doc",UserID,IADMRowId)=1
	;k ^TempDHCPEDocWorkStati(CurUserID)
	q:AdmDate>DateEnd ""
	q AdmDate
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.DoctorWorkStatistic","DoctorWorkStatistic","1115","","","61139","61139","")
/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.DoctorWorkStatistic","DoctorWorkStatistic","1115","","","61139","61139","")
Query DoctorWorkStatistic(ShowResult As %String = "0", DocNo As %Library.String = "", DocDR As %Library.String = "", DocInitials As %Library.String = "", OEItemDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", VIPLevel As %Library.String = "", StationID As %Library.String = "", FindType As %String = "") As %Query(ROWSPEC = "DWA_DocNo:%String,DWA_DocName:%String,DWA_ItemDesc:%String,DWA_Amount:%String,DWA_ItemDescDR:%String,DWA_DocID:%String,DWA_FindType:%String")
{
}

ClassMethod DoctorWorkStatisticExecute(ByRef qHandle As %Binary, ShowResult As %String = "0", DocNo As %Library.String = "", DocDR As %Library.String = "", DocInitials As %Library.String = "", OEItemDR As %Library.String = "", DateBegin As %Library.String = "", DateEnd As %Library.String = "", GroupDR As %Library.String = "", VIPLevel As %Library.String = "", StationID As %Library.String = "", FindType As %String = "") As %Status
{
 	//w DocNo_":"_DocDR_":"_OEItemDR_":"_DateBegin_":"_DateEnd_":"_GroupDR,!
    s ind=10000
    s i=2
 	s id=0	
	Set repid=$I(^CacheTemp)
	if ("0"=+ShowResult){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	k ^DHCPETMPDWA("DoctorWorkStatistic","InfoExport","List")
	s CurUserID=%session.Get("LOGON.USERID")
	s CurLocID=%session.Get("LOGON.CTLOCID")
	/*
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab"))
	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion"))
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	*/
	s LabStation=$g(^DHCPESetting("DHCPE","StationId_Lab",CurLocID))
	s LisNewVersion=$g(^DHCPESetting("DHCPE","LisNewVersion",CurLocID))
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",CurLocID)

	
	i DateBegin'="" s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
	i DateEnd'="" s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
	
	i DateBegin="" s DateBegin=1
	i DateEnd="" s DateEnd=+$H
	k ^TEMPDHCPELocWork(CurUserID)
	s Station=""
	//d ##class(web.DHCPE.Report.LocWork).GetLocWork(DateBegin,DateEnd)
	s AdmDate=DateBegin-1
	i FindType'="on"
	{
	s TFindType=""
	s TotalAmount=0
    s TotalGAmount=0
    s TotalIAmount=0
	S TMPUserPRowId=""
    s Flag=""
    f  s Flag=$O(^DHCPETMPDWA(CurUserID,"Doctor",Flag)) q:Flag=""  d
    .f  s TMPUserPRowId=$O(^DHCPETMPDWA(CurUserID,"Doctor",Flag,TMPUserPRowId)) q:TMPUserPRowId=""  d
    ..s DocAmount=0
    ..s DocGAmount=0
    ..s DocIAmount=0
    ..s DocName=""
    ..s TMPItmRowId=""
    ..s str=""
    ..f  s TMPItmRowId=$O(^DHCPETMPDWA(CurUserID,"Doctor",Flag,TMPUserPRowId,TMPItmRowId)) q:TMPItmRowId=""  d
    ...;s Flag=1
    ...s ARCIMSubscript=$P(TMPItmRowId,"||",1)
	...s ARCIMVersion=$P(TMPItmRowId,"||",2)
	...s ItmMastDesc=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
    ...s Amount=$G(^DHCPETMPDWA(CurUserID,"Doctor",Flag,TMPUserPRowId,TMPItmRowId))
    ...;s TotalAmount=TotalAmount+Amount
    ...s GAmount=$G(^DHCPETMPDWA(CurUserID,"GADM",TMPUserPRowId,TMPItmRowId))
    ...s IAmount=$G(^DHCPETMPDWA(CurUserID,"IADM",TMPUserPRowId,TMPItmRowId))
    ...i '$D(^DHCPETMPDWA(CurUserID,"GADM",TMPUserPRowId,TMPItmRowId)) s GAmount=0
    ...i '$D(^DHCPETMPDWA(CurUserID,"IADM",TMPUserPRowId,TMPItmRowId))  s IAmount=0
    ...s DocAmount=DocAmount+Amount
    ...s DocGAmount=DocGAmount+GAmount
    ...s DocIAmount=DocIAmount+IAmount
    ...s TAmount="共:"_Amount_"人"_" "_"其中团体:"_GAmount_"人"_", "_"个人:"_IAmount_"人"
    ...s STRowId=0
    ...s STRowId=$O(^DHCPEST(0,"STORD_ARCIM",TMPItmRowId, STRowId))
	...Q:(""=STRowId)
	...s VIPLevelID=0
	...s VIPData=""
	...f  s VIPLevelID=$o(^DHCPETMPDWA(CurUserID,"VIP",TMPUserPRowId,TMPItmRowId,VIPLevelID))  q:VIPLevelID=""  d
	....S VIPNum=$g(^DHCPETMPDWA(CurUserID,"VIP",TMPUserPRowId,TMPItmRowId,VIPLevelID))
	....s VIPStr=$g(^DHCPEVIPLevel("VIP",VIPLevelID))
	....s VIPDesc=$p(VIPStr,"^",2)
	....i VIPData="" s VIPData=VIPDesc_":"_VIPNum_"人"
	....else  s VIPData=VIPData_" "_VIPDesc_":"_VIPNum_"人"
	....s ^DHCPETMPDWA(CurUserID,"ITotalVIP",TMPUserPRowId,VIPLevelID)=+$g(^DHCPETMPDWA(CurUserID,"ITotalVIP",TMPUserPRowId,VIPLevelID))+VIPNum
	...i VIPData'="" s TAmount=TAmount_"("_VIPData_")"
    ...i (""'=TMPUserPRowId) d
    ....i STRowId'=LabStation d
    .....s SSUSRName=$p($g(^SSU("SSUSR",TMPUserPRowId)),"^",2)	//检查医师名称	SS_User
    .....i str=""  s str=SSUSRName
    .....e  s SSUSRName=""
    .....s SSUSRInitials =$P($g(^SSU("SSUSR",TMPUserPRowId)),"^",1)
    .....i DocName="" s DocName=SSUSRName
    .....d DoctorWorkStatisticOut
    ....e  d
    .....i (LisNewVersion="Y") d
    ......s SSUSRName=$p($g(^SSU("SSUSR",TMPUserPRowId)),"^",2)
    ......i str=""  s str=SSUSRName
    ......e  s SSUSRName=""
    ......s SSUSRInitials =$p($g(^SSU("SSUSR",TMPUserPRowId)),"^",1)
    ......i DocName="" s DocName=SSUSRName
    .....e  d
    ......s SSUSRName=$p($g(^[namespaceLab]SSU("SSUSR",1,TMPUserPRowId)),"^",2)
    ......i str=""  s str=SSUSRName
    ......e  s SSUSRName=""
    ......s SSUSRInitials =$p($g(^[namespaceLab]SSU("SSUSR",1,TMPUserPRowId)),"^",1)
    ......i DocName="" s DocName=SSUSRName


    ..s ITotalVIPData=""
    ..s VIPID=""
    ..f  s VIPID=$o(^DHCPETMPDWA(CurUserID,"ITotalVIP",TMPUserPRowId,VIPID))  q:VIPID=""  d
    ...s ITotalVIP=$g(^DHCPETMPDWA(CurUserID,"ITotalVIP",TMPUserPRowId,VIPID))
    ...s ITotalVIPStr=$g(^DHCPEVIPLevel("VIP",VIPID))
	...s ITotalVIPDesc=$p(ITotalVIPStr,"^",2)
    ...i ITotalVIPData="" s ITotalVIPData=ITotalVIPDesc_":"_ITotalVIP_"人"
	...else  s ITotalVIPData=ITotalVIPData_" "_ITotalVIPDesc_":"_ITotalVIP_"人" 
    ..i ITotalVIPData'="" s DocTotal="共:"_DocAmount_"人"_" "_"其中团体:"_DocGAmount_"人"_", "_"个人:"_DocIAmount_"人"_"("_ITotalVIPData_")"
    ..else  s DocTotal="共:"_DocAmount_"人"_" "_"其中团体:"_DocGAmount_"人"_", "_"个人:"_DocIAmount_"人"
    ..s Data=$LB(SSUSRInitials,DocName,"合计",DocTotal,TMPItmRowId,TMPUserPRowId)
    ..s ^DHCPETMPDWA("DoctorWorkStatistic","InfoExport","List",CurUserID,i)=DocName_"^"_"合计"_"^"_DocTotal     // add by 090730
    ..i $D(^DHCPELocWork("DOC",TMPUserPRowId)) d
    ...s ^DHCPETMPDWA("DoctorWorkStatistic","InfoExport","List",CurUserID,i)=DocName_"^"_"合计"_"^"_DocAmount     // add by 090730
    ..Set ^CacheTemp(repid,i)=Data
    ..s i=i+1
    ..s TotalAmount=TotalAmount+DocAmount
    ..s TotalGAmount=TotalGAmount+DocGAmount
    ..s TotalIAmount=TotalIAmount+DocIAmount
   ///汇总
   ///
    s ind=1
    s TotalVIPData=""
    s VIPID=0
    f  s VIPID=$o(^DHCPETMPDWA(CurUserID,"VIPTotal",VIPID))  q:VIPID=""  d
    .s TotalVIP=$g(^DHCPETMPDWA(CurUserID,"VIPTotal",VIPID))
    .s TotalVIPStr=$g(^DHCPEVIPLevel("VIP",VIPID))
	.s TotalVIPDesc=$p(TotalVIPStr,"^",2)
    .i TotalVIPData="" s TotalVIPData=TotalVIPDesc_":"_TotalVIP_"人"
	.else  s TotalVIPData=TotalVIPData_" "_TotalVIPDesc_":"_TotalVIP_"人" 
    s SSUSRInitials=""
    s SSUSRName=""
    s ItmMastDesc="汇总"
    i TotalVIPData'=""  s TAmount="共:"_TotalAmount_"人"_" "_"其中团体:"_TotalGAmount_"人"_", "_"个人:"_TotalIAmount_"人"_"("_TotalVIPData_")"
    else  s TAmount="共:"_TotalAmount_"人"_" "_"其中团体:"_TotalGAmount_"人"_", "_"个人:"_TotalIAmount_"人"
    s TMPItmRowId=""
    s TMPUserPRowId="0"
   	d DoctorWorkStatisticOut
	}
	
	else{
		s UserID=""
		f  s UserID=$O(^DHCPETMPDWA(CurUserID,"Doc",UserID)) q:UserID=""  d
		.s SSUSRInitials =$P($g(^SSU("SSUSR",UserID)),"^",1)
		.s SSUSRName=$p($g(^SSU("SSUSR",UserID)),"^",2)
		.s:(SSUSRName="")&&(LisNewVersion'="Y") SSUSRName=$p($g(^[namespaceLab]SSU("SSUSR",1,UserID)),"^",2)
		
		.s (ItmMastDesc,TMPItmRowId)=""  //added xy
		.s TMPUserPRowId=UserID  //added xy
		.s TFindType="on"
		.s TAmount=^DHCPETMPDWA(CurUserID,"Doc",UserID)
		.d DoctorWorkStatisticOut
	
	}
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
DoctorWorkStatisticOut
    s Data=$LB(SSUSRInitials,SSUSRName,ItmMastDesc,TAmount,TMPItmRowId,TMPUserPRowId,TFindType)
    s ^DHCPETMPDWA("DoctorWorkStatistic","InfoExport","List",CurUserID,ind)=SSUSRName_"^"_ItmMastDesc_"^"_TAmount
    s SSUSRName=""
    s DocNo=""
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod DoctorWorkStatisticFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = DoctorWorkStatisticExecute ]
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

ClassMethod DoctorWorkStatisticClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = DoctorWorkStatisticExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 查询与体检配置科室有关的所有客户
Query SearchUSERSXT(Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "DocName:%String:姓名,DocDr:%String:ID,Initials:%String:工号")
{
}

ClassMethod SearchUSERSXTExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCPE.Report.DoctorWorkStatistic","SearchUSERSXT","","B","388","3")
    s ^tempdhcpe("SearchUSERSXT")=$lb(Desc,Type,LocID,hospId)
    s ind=1
    s i=2
	Set repid=$I(^CacheTemp)
	
 	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
 	
	s DocDR=0
	f  s DocDR=$o(^SSU("SSUSR",DocDR)) q:(DocDR="")  d
	.s PELocFlag=0
	.s CurData=$g(^SSU("SSUSR",DocDR))
	.s DocName=$p(CurData,"^",2)
	.q:(Desc'="")&&(DocName'[Desc)
	.s Initials=$p(CurData,"^",1)
	.;q:('$d(^DHCPECFDataEx("ChartAssign",DocDR,LocID,288,"Write","NULL")))
	.;q:(($g(^DHCPECFDataEx("ChartAssign",DocDR,LocID,288,"Write","NULL")))'="Y")
	.s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("SS_User",DocDR,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",DocDR,hospId)
	.q:(HOSPshowFlag="N")
	.s DefaultDeptDR=$p(CurData,"^",4) //ss_user表默认登录科室
	.i '$d(^SSU("SSUSR",DocDR,"OTHLL")) d
	..//体检配置科室
    ..s PELocList=$g(^DHCPESetting("DHCPE","PELoc"))
    ..s len=$l(PELocList,"^")
    ..for Locnum=1:1:len d
    ...s PELocListDR=$P(PELocList,"^",Locnum)
    ...i PELocListDR=DefaultDeptDR s PELocFlag=1 
	.//用户设置登录科室 SS_UserOtherLogonLoc（用户子表）
    .s OTHLLSub=""
    .f  s OTHLLSub=$o(^SSU("SSUSR",DocDR,"OTHLL",OTHLLSub)) q:(OTHLLSub="")||(PELocFlag=1)  d
    ..s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",DocDR,"OTHLL",OTHLLSub)),"^",1)
    ..//体检配置科室
    ..s PELocList=$g(^DHCPESetting("DHCPE","PELoc"))
    ..s len=$l(PELocList,"^")
    ..for Locnum=1:1:len d
    ...s PELocListDR=$P(PELocList,"^",Locnum)
    ...i PELocListDR=OTHLLCTLOCDR s PELocFlag=1 
    .q:PELocFlag'=1
	.d DoctorWorkStatisticOut2
   	.s DocName="",CurData="",Initials=""
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK

DoctorWorkStatisticOut2
    s Data=$LB(DocName,DocDR,Initials)
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchUSERSXTFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchUSERSXTExecute ]
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

ClassMethod SearchUSERSXTClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchUSERSXTExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// Description: 查询与登录科室有关的所有客户
Query SearchUSERSXTNew(Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Query(ROWSPEC = "DocName:%String:姓名,DocDr:%String:ID,Initials:%String:工号")
{
}

ClassMethod SearchUSERSXTNewExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", Type As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
	//d ##class(%ResultSet).RunQuery("web.DHCPE.Report.DoctorWorkStatistic","SearchUSERSXTNew","","B","388","3")
	//s ^tempdhcpe("SearchUSERSXT",LocID,hospId)=$lb(Desc,Type,LocID,hospId)
    s ind=1
    s i=2
	Set repid=$I(^CacheTemp)

 	i LocID="" s LocID=%session.Get("LOGON.CTLOCID")
 	
	s DocDR=0
	f  s DocDR=$o(^SSU("SSUSR",DocDR)) q:(DocDR="")  d
	.s PELocFlag=0
	.s CurData=$g(^SSU("SSUSR",DocDR))
	.s DocName=$p(CurData,"^",2)
	.q:(Desc'="")&&(DocName'[Desc)
	.s Initials=$p(CurData,"^",1)
	.s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("SS_User",DocDR,Type,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",DocDR,hospId)
	.q:(HOSPshowFlag="N")
	.s DefaultDeptDR=$p(CurData,"^",4) //ss_user表默认登录科室
	.;i ('$d(^SSU("SSUSR",DocDR,"OTHLL"))&&(DefaultDeptDR=LocID)) s PELocFlag=1
	.i (DefaultDeptDR=LocID) s PELocFlag=1
	.i PELocFlag=0 d
	..//用户设置登录科室 SS_UserOtherLogonLoc（用户子表）
    ..s OTHLLSub=""
    ..f  s OTHLLSub=$o(^SSU("SSUSR",DocDR,"OTHLL",OTHLLSub)) q:(OTHLLSub="")||(PELocFlag=1)  d
    ...s OTHLLCTLOCDR=$p($g(^SSU("SSUSR",DocDR,"OTHLL",OTHLLSub)),"^",1)
    ...i OTHLLCTLOCDR=LocID s PELocFlag=1 
    .q:PELocFlag'=1
	.d DoctorWorkStatisticOutNew
   	.s DocName="",CurData="",Initials=""
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	

	
DoctorWorkStatisticOutNew
    s Data=$LB(DocName,DocDR,Initials)
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchUSERSXTNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchUSERSXTNewExecute ]
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

ClassMethod SearchUSERSXTNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchUSERSXTNewExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/*
Query SearchUSER(Desc As %Library.String = "") As %SQLQuery(ROWSPEC = "SSUSR_Initials:%String,SSUSR_Name:%String, SSUSR_RowId:%String")
{
	select SSUSR_Initials, SSUSR_Name, SSUSR_RowId
	from SS_USER
	where SSUSR_Name %STARTSWITH :Desc
}
*/
Query SearchUSER(Desc As %Library.String = "", hospId As %String = "") As %Query(ROWSPEC = "SSUSR_Initials:%String:用户ID,SSUSR_Name:%String:姓名,SSUSR_RowId:%String:ID")
{
}

ClassMethod SearchUSERExecute(ByRef qHandle As %Binary, Desc As %Library.String = "", hospId As %String = "") As %Status
{
	;w DocNo_":"_DocDR_":"_OEItemDR_":"_DateBegin_":"_DateEnd_":"_GroupDR_":"_StationID,!
    s ind=10000
    s i=2
 	s id=0	
	Set repid=$I(^CacheTemp)
 	/*if (Desc=""){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}*/
 	s Desc=$ZCVT(Desc,"U")
 	s LocID=%session.Get("LOGON.CTLOCID")
 	s hospId=%session.Get("LOGON.HOSPID")
	s DocDR=0
	f  s DocDR=$o(^SSU("SSUSR",DocDR)) q:(DocDR="")  d
	.s CurData=$g(^SSU("SSUSR",DocDR))
	.s DocName=$p(CurData,"^",2)
	.s DocCode=$p(CurData,"^",1)
	.s DocPY=##class(web.DHCINSUPort).GetCNCODE(DocName,4,"")
	.q:(Desc'="")&&((DocName'[Desc)&&(DocPY'[Desc)&&(DocCode'[Desc))
	
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",DocDR,hospId)
	.q:(HOSPshowFlag="N")

	.d SearchUSEROut2
   	.s DocName="",CurData="",DocCode=""
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SearchUSEROut2
    s Data=$LB(DocCode,DocName,DocDR)
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod SearchUSERFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchUSERExecute ]
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

ClassMethod SearchUSERClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchUSERExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.DoctorWorkStatistic","SearchUserNew","GAuditStationS^JGAUDITSTATIONS^GMainAuditStationS^KGMAINAUDITSTATIONS")
/// GAUDITSTATIONS^JGAUDITSTATIONS^GMAINAUDITSTATIONS^KGMAINAUDITSTATIONS
Query SearchUserNew(Type As %String = "", Desc As %Library.String = "", FType As %String = "", LocID As %String = "", hospId As %String = "") As websys.Query(ROWSPEC = "DocName:%String:姓名,DocDr:%String:ID,Initials:%String:工号")
{
}

ClassMethod SearchUserNewExecute(ByRef qHandle As %Binary, Type As %String = "", Desc As %Library.String = "", FType As %String = "", LocID As %String = "", hospId As %String = "") As %Status
{
    s ind=1
	Set repid=$I(^CacheTemp)
 	
 	s Job=$j
 	k ^TempDHCPEAudDoc(Job)
 	s Type=$zcvt(Type,"U")
 	
 	s User=""
 	f  s User=$o(^User.DHCPEAdmRecordManagerI("UserTypeDateIndex",User)) q:User=""  d
 	.s iType=""
 	.f  s iType=$o(^User.DHCPEAdmRecordManagerI("UserTypeDateIndex",User,iType)) q:iType=""  d
 	..q:((Type'="")&&(("^"_Type_"^")'[("^"_iType_"^")))
 	..s UserId=$num(User)
 	..q:UserId=""
 	..s ^TempDHCPEAudDoc(Job,UserId)=""
 	
	s DocDR=0
	f  s DocDR=$o(^TempDHCPEAudDoc(Job,DocDR)) q:(DocDR="")  d
	.s CurData=$g(^SSU("SSUSR",DocDR))
	.s DocName=$p(CurData,"^",2)
	.q:(Desc'="")&&(DocName'[Desc)
	.s Initials=$p(CurData,"^",1)
	.;q:('$d(^DHCPECFDataEx("ChartAssign",DocDR,LocID,288,"Write","NULL")))
	.;q:(($g(^DHCPECFDataEx("ChartAssign",DocDR,LocID,288,"Write","NULL")))'="Y")
	.
	.s DateShowFlag=##class(web.DHCPE.HISUICommon).GetDateShowDataFlag("SS_User",DocDR,FType,LocID)
    .q:DateShowFlag="Y"
    .s HOSPshowFlag=##class(web.DHCPE.HISUICommon).GetHospShowDataFlag("SS_User",DocDR,hospId)
	.q:(HOSPshowFlag="N")

	.d SearchUserNew
   	.s DocName="",CurData="",Initials=""
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
SearchUserNew
    s Data=$LB(DocName,DocDR,Initials)
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

Query DHCPEGBaseInfoList(Desc As %String) As %SQLQuery(ROWSPEC = "GBI_Desc:%String,GBI_Code:%String,GBI_RowId:%String")
{
	select GBI_Desc,GBI_Code,GBI_RowId  
	From DHC_PE_GBaseInfo 
	where GBI_Desc %STARTSWITH :Desc
}

/// 每日科室工作量统计
/// w ##Class(web.DHCPE.Report.DoctorWorkStatistic).DayDoctorWorkStatisticImport("","","2009-9")
ClassMethod DayDoctorWorkStatisticImport(itmjs As %Library.String = "", itmjsex As %Library.String = "", ImportDate As %Library.String = "") As %Status
{
	k ^DHCPETMPDWA
		s LocID=%session.Get("LOGON.CTLOCID")
	/*
	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA")
	s LabID=$G(^DHCPESetting("DHCPE","StationId_Lab"))
	s RisID=$G(^DHCPESetting("DHCPE","StationId_Ris"))
	s OtherID=$G(^DHCPESetting("DHCPE","StationId_Other"))
 	*/
 	s namespaceLab=^DHCPESetting("NAMESPACE","LABDATA",LocID)
	s LabID=$G(^DHCPESetting("DHCPE","StationId_Lab",LocID))
	s RisID=$G(^DHCPESetting("DHCPE","StationId_Ris",LocID))
	s OtherID=$G(^DHCPESetting("DHCPE","StationId_Other",LocID))

 	
 	s Instring=ImportDate
 	s ImportDate=$P(Instring,"^",1)
	s StartDate=$P(Instring,"^",2)
	s EndDate=$P(Instring,"^",3)
 	s:StartDate'="" StartDate=$ZDH(StartDate,4)
 	s:EndDate'="" EndDate=$ZDH(EndDate,4)
 	
 	Q:(""=ImportDate) ""
	s DateBegin=$ZDH(ImportDate_"-01",3)
	//s DateEnd=$ZDH($P(ImportDate,"-",1)_"-"_($P(ImportDate,"-",2)+1)_"-01",3)
	s Year=$P(ImportDate,"-",1)                 // Add by zhouli 2009-01-15
	i $P(ImportDate,"-",2)="12"  s Year=Year+1  // Add by zhouli 2009-01-15
	i $P(ImportDate,"-",2)="12"  s DateEnd=$ZDH($P(Year,"-",1)_"-"_"01"_"-01",3)     // Add by zhouli 2009-01-15
	e  s DateEnd=$ZDH($P(ImportDate,"-",1)_"-"_($P(ImportDate,"-",2)+1)_"-01",3)    // Modify by zhouli 2009-01-15
	s DateEnd=DateEnd-1
 	
 	s:StartDate'="" DateBegin=StartDate
  	s:EndDate'="" DateEnd=EndDate
 	
 	s:(0'=+DateBegin) DateBegin=DateBegin-1
	s IADMAdmDate=+DateBegin
	f  s IADMAdmDate=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate)) q:((""'=DateEnd)&(IADMAdmDate>+DateEnd)||(""=IADMAdmDate))  d
	.
	.//DHC_PE_IADM.{ IADM_AdmTime }
	.s IADMAdmTime=0
	.f  s IADMAdmTime=$O(^DHCPEIADM(0,"AdmDateTime",IADMAdmDate,IADMAdmTime)) q:(""=IADMAdmTime)  d
	..
	..s IAdmRowId=0
	..f  s IAdmRowId=$O(^DHCPEIADM(0,"AdmDateTime", IADMAdmDate, IADMAdmTime,IAdmRowId)) q:(""=IAdmRowId)  d
	...//q:IAdmRowId'="776"
	...s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PEADM",IAdmRowId)          //add 2009-07-07 
  	...q:LocFlag=1
	...// IADM_Status
	...s Status=$P($g(^DHCPEIADM(IAdmRowId)),"^",8)
	...//w !,Status
	...Q:'(("ARRIVED"=Status)||("COMPLETED"=Status))
	...
	...// DHC_PE_StationSummarize.{ SS_ST_DR }
	...s SSSTDR=0
	...//b //
	...f  s SSSTDR=$O(^DHCPESS(0, "IADM", IAdmRowId, SSSTDR)) Q:(SSSTDR="")  d
	....Q:(("^"_LabID_"^")[("^"_SSSTDR_"^"))||(("^"_RisID_"^")[("^"_SSSTDR_"^"))||(("^"_OtherID_"^")[("^"_SSSTDR_"^"))
	....// DHC_PE_StationSummarize.{ SS_RowId }
	....s SSRowId=0
	....f  s SSRowId=$O(^DHCPESS(0, "IADM", IAdmRowId, SSSTDR, SSRowId)) q:SSRowId=""  d
	.....// SS_Status
	.....s SSStatus=$P($G(^DHCPESS(SSRowId,1)),"^",7)
	.....Q:("NA"=SSStatus)||("NoAudit"=SSStatus)
	.....
	.....// DHC_PE_StationSummarize.{ SS_UpdateUser_DR }
	.....s SSUpdateUserDR=$P($G(^DHCPESS(SSRowId,1)),"^",4)
	.....Q:(""=SSUpdateUserDR)
	.....s ^DHCPETMPDWA("Doctor", SSUpdateUserDR)=+$G(^DHCPETMPDWA("Doctor",SSUpdateUserDR))+1
	.....s ^DHCPETMPDWA("Doctor", SSUpdateUserDR, "Day", IADMAdmDate)=+$G(^DHCPETMPDWA("Doctor",SSUpdateUserDR, "Day", IADMAdmDate))+1
	.....s ^DHCPETMPDWA("Tatal", "Day", IADMAdmDate)=+$G(^DHCPETMPDWA("Tatal", "Day", IADMAdmDate))+1
	.....
	
	// 体检医生列表
	s DocList=""
	s DocDR=0
	f  s DocDR=$O(^DHCPETMPDWA("Doctor", DocDR)) q:DocDR=""  d

	.// SS_User.{ SSUSR_Initials }
	.s DocCode=$P($G(^SSU("SSUSR",DocDR)),"^",1)
	.// SS_User.{ SSUSR_Name }
	.//w !,DocName
	.s DocName=$P($G(^SSU("SSUSR",DocDR)),"^",2)
	.// 检验
	.s:(""=DocName) DocName=$p($g(^[namespaceLab]SSU("SSUSR",1,DocDR)),"^",2)
	.//Q:(""=DocName) // 过滤掉用户名为空的
	.s:(""=DocName) DocName="("_DocDR_")"
	.s DocList=DocList_"^"_DocName
	.
	.
	s DocList=DocList

	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(DocList,"O","JS")_"');"
	.&javascript<#(retval)#>
	.	
	s retValue=DocList_";"
	//w !,"体检医生列表:"_DocList,!
	// 体检医生总计
	s DayAmount=""
	f  s DocDR=$O(^DHCPETMPDWA("Doctor", DocDR)) q:DocDR=""  d
	.s Amount=+$G(^DHCPETMPDWA("Doctor", DocDR))
	.s DayAmount=DayAmount_"^"_Amount
	.
	s DayAmount="总计"_DayAmount
	i ""'=itmjs d
	.s retval=itmjs_"('"_$ZCVT(DayAmount,"O","JS")_"');"
	.&javascript<#(retval)#>
	.
	s retValue=retValue_DayAmount_";"
	
	
	s AdmDate=DateBegin+1
	while (AdmDate<+DateEnd) {
		
		s DayAmount=""
		s DocDR=0		
		f  s DocDR=$O(^DHCPETMPDWA("Doctor", DocDR)) q:DocDR=""  d
		.s Amount=+$G(^DHCPETMPDWA("Doctor", DocDR, "Day", AdmDate))
		.s DayAmount=DayAmount_"^"_Amount
		.
		
		s Date=$ZD(AdmDate,3)
		//s DayAmount=Date_"^"_+$G(^DHCPEDWATMP("Doctor", DocDR))_DayAmount
		s DayAmount=Date_DayAmount
		//w "每日情况:"_DayAmount,!

		i ""'=itmjs d
		.s retval=itmjs_"('"_$ZCVT(DayAmount,"O","JS")_"');"
		.&javascript<#(retval)#>
		.
		s retValue=retValue_DayAmount_";"
		s AdmDate=+AdmDate+1
	}
	
	Q retValue
}

Query InfoList(OEItemDR As %Library.String = "", UserID As %Library.String = "", Type As %Library.String = "") As %Query(ROWSPEC = "TRegNo:%String,TPatName:%String,TSex:%String,TTel:%String,TCompany:%String,TGroupName:%String,TARCIMDesc:%String")
{
}

ClassMethod InfoListExecute(ByRef qHandle As %Binary, OEItemDR As %Library.String = "", UserID As %Library.String = "", Type As %Library.String = "") As %Status
{
    Set repid=$I(^CacheTemp)
	s ind=1	
	s CurUserID=%session.Get("LOGON.USERID")
	if (UserID="")&&(OEItemDR="")
	{
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
	}
    if (Type="on") d
    .s IADMRowId=0
    .f  s IADMRowId=$o(^DHCPETMPDWA(CurUserID,"Doc",UserID,IADMRowId))  q:IADMRowId=""  d
    ..s PreIADM=$p($g(^DHCPEIADM(IADMRowId)),"^",4)
    ..q:PreIADM=""
    ..s PIBIDR=$P($g(^DHCPEPreIADM(PreIADM)),"^",1)
    ..q:PIBIDR=""
    ..s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    ..s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    ..s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    ..s SexName=""
    ..i SexDR'=""   s SexName=$p(^CT("SEX",SexDR),"^",2) 
    ..s Tel1=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    ..s Mobil=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    ..s MobilePhone=Mobil
    ..i (""=Mobil)   s MobilePhone=Tel1
    ..s Company=$p($g(^DHCPEPreIBI(PIBIDR)),"^",12)
    ..s GADM=$P($g(^DHCPEIADM(IADMRowId)),"^",2)
    ..i GADM'=""  d
    ...s GBIDR=$P($G(^DHCPEGADM(GADM)),"^",1)
    ...i GBIDR'="" s GDesc=$p($G(^DHCPEGBI(GBIDR)),"^",2)
    ..e  s GDesc=""
 	..d StationWorkInfoOut
   
	if (""=OEItemDR)&&(UserID="0")  d
    .s UserID=0
	.f  s UserID=$O(^DHCPETMPDWA(CurUserID,"DoctorList",UserID))  q:UserID=""  d
	..s ARCIMID=0
    ..f  s ARCIMID=$O(^DHCPETMPDWA(CurUserID,"DoctorList",UserID,ARCIMID))  q:ARCIMID=""  d
    ...q:(OEItemDR'="")&&(OEItemDR'=ARCIMID)
    ...s ARCIMSubscript=$P(ARCIMID,"||",1)
	...s ARCIMVersion=$P(ARCIMID,"||",2)
	...s ItmMastDesc=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
    ...s IADMRowId=0
    ...f  s IADMRowId=$O(^DHCPETMPDWA(CurUserID,"DoctorList",UserID,ARCIMID,IADMRowId)) q:IADMRowId=""  d
    ....s PreIADM=$p($g(^DHCPEIADM(IADMRowId)),"^",4)
    ....q:PreIADM=""
    ....s PIBIDR=$P($g(^DHCPEPreIADM(PreIADM)),"^",1)
    ....q:PIBIDR=""
    ....s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    ....s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    ....s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    ....s SexName=""
    ....i SexDR'=""   s SexName=$p(^CT("SEX",SexDR),"^",2) 
    ....s Tel1=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    ....s Mobil=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    ....s MobilePhone=Mobil
    ....i (""=Mobil)   s MobilePhone=Tel1
    ....s Company=$p($g(^DHCPEPreIBI(PIBIDR)),"^",12)
    ....s GADM=$P($g(^DHCPEIADM(IADMRowId)),"^",2)
    ....i GADM'=""  d
    .....s GBIDR=$P($G(^DHCPEGADM(GADM)),"^",1)
    .....i GBIDR'="" s GDesc=$p($G(^DHCPEGBI(GBIDR)),"^",2)
    ....e  s GDesc=""
 	....d StationWorkInfoOut
 	
	else  d
    .s ARCIMID=0
    .f  s ARCIMID=$O(^DHCPETMPDWA(CurUserID,"DoctorList",UserID,ARCIMID))  q:ARCIMID=""  d
    ..q:(OEItemDR'="")&&(OEItemDR'=ARCIMID)
    ..s ARCIMSubscript=$P(ARCIMID,"||",1)
	..s ARCIMVersion=$P(ARCIMID,"||",2)
	..s ItmMastDesc=$p(^ARCIM(ARCIMSubscript,ARCIMVersion,1),"^",2)
    ..s IADMRowId=0
    ..f  s IADMRowId=$O(^DHCPETMPDWA(CurUserID,"DoctorList",UserID,ARCIMID,IADMRowId)) q:IADMRowId=""  d
    ...s PreIADM=$p($g(^DHCPEIADM(IADMRowId)),"^",4)
    ...q:PreIADM=""
    ...s PIBIDR=$P($g(^DHCPEPreIADM(PreIADM)),"^",1)
    ...q:PIBIDR=""
    ...s PAPMINo=$p($g(^DHCPEPreIBI(PIBIDR)),"^",1)
    ...s Name=$p($g(^DHCPEPreIBI(PIBIDR)),"^",2)
    ...s SexDR=$p($g(^DHCPEPreIBI(PIBIDR)),"^",3)
    ...s SexName=""
    ...i SexDR'=""   s SexName=$p(^CT("SEX",SexDR),"^",2) 
    ...s Tel1=$p($g(^DHCPEPreIBI(PIBIDR)),"^",6)
    ...s Mobil=$p($g(^DHCPEPreIBI(PIBIDR)),"^",8)
    ...s MobilePhone=Mobil
    ...i (""=Mobil)   s MobilePhone=Tel1
    ...s Company=$p($g(^DHCPEPreIBI(PIBIDR)),"^",12)
    ...s GADM=$P($g(^DHCPEIADM(IADMRowId)),"^",2)
    ...i GADM'=""  d
    ....s GBIDR=$P($G(^DHCPEGADM(GADM)),"^",1)
    ....i GBIDR'="" s GDesc=$p($G(^DHCPEGBI(GBIDR)),"^",2)
    ...e  s GDesc=""
 	...d StationWorkInfoOut
   
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
StationWorkInfoOut
	set Data=$lb(PAPMINo,Name,SexName,MobilePhone,Company,GDesc,ItmMastDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod InfoListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = InfoListExecute ]
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

ClassMethod InfoListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = InfoListExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetRowNum() As %Status
{
	s UserID=%session.Get("LOGON.USERID")
	s StrNum=""
	s num=0
	f  s num=$o(^DHCPETMPDWA("DoctorWorkStatistic","InfoExport","List",UserID,num))  q:num=""  d
	.i StrNum=""  s StrNum=num
	.else  s StrNum=StrNum_"^"_num
	q StrNum
}

ClassMethod ExportDocWorkInfo(Num As %Library.String = "") As %Status
{
	q:Num="" ""
	s UserID=%session.Get("LOGON.USERID")
 	s Data=$G(^DHCPETMPDWA("DoctorWorkStatistic","InfoExport","List",UserID,Num))
	Q Data
}

/// d ##class(%ResultSet).RunQuery("web.DHCPE.Report.DoctorWorkStatistic","CheckProgress","66600","62262")
Query CheckProgress(DateBegin As %Library.String = "", DateEnd As %Library.String = "", VIPLevel As %String = "", SexDR As %String = "", RegNo As %String = "", Name As %String = "", GADMID As %String = "", DietFlag As %String = "", ReCheck As %String = "", CheckStatus As %String = "", Depart As %String = "") As %Query(ROWSPEC = "TRegNo:%String,TName:%String,TSex:%String,TPosition:%String,TUnCheckItems:%String,TPAADM:%String,THadPrint:%String,TVIPLevel:%String,TCheckDate:%String,TGroupDesc:%String,TReportStatus:%String,TDietFlag:%String,TPhotoFlag:%String,TPreIADM:%String,TTel:%String,TReportID:%String,THadSendMessage:%String,THPNo:%String,THadRec:%String,TSendAudit:%String,TReportAudit:%String,TMainAudit:%String,TReportPrint:%String,TFetchReport:%String,TAge:%String,PACCardDesc:%String,IDCard:%String,ReCheckFlag")
{
}

ClassMethod CheckProgressExecute(ByRef qHandle As %Binary, DateBegin As %Library.String = "", DateEnd As %Library.String = "", VIPLevel As %String = "", SexDR As %String = "", RegNo As %String = "", Name As %String = "", GADMID As %String = "", DietFlag As %String = "", ReCheck As %String = "", CheckStatus As %String = "", Depart As %String = "") As %Status
{
 	s ind=1
    s i=2
 	s id=0
 	s Job=$J
 	k ^TempDHCPECheckProgress(Job)
 	Set repid=$I(^CacheTemp)
 	if ((""=DateBegin)&&(""=DateEnd)&&(RegNo="")&&(GADMID="")&&(Name="")){
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
 	}
 	
 	i DateBegin'="" s DateBegin=##class(websys.Conversions).DateHtmlToLogical(DateBegin)
	i DateEnd'="" s DateEnd=##class(websys.Conversions).DateHtmlToLogical(DateEnd)
	
	i DateBegin="" s DateBegin=1
	i DateEnd="" s DateEnd=+$H
	if RegNo'=""
	{
		s RegNo=##class(web.DHCPE.DHCPECommon).RegNoMask(RegNo)
		s BaseInfo=$O(^DHCPEPreIBI(0,"PAPMINo",RegNo,0))
		i BaseInfo'=""
		{
			s PIADM=""
			f  s PIADM=$O(^DHCPEPreIADM(0,"PIBI",BaseInfo,PIADM)) q:PIADM=""  d
			.s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
			.q:IADM=""
			.d OneIADMInfo
		}
	}
	elseif Name'=""
	{
		S Name=$$ALPHAUP^SSUTIL4(Name)
		s PreName=$O(^DHCPEPreIBI(0,"Name",Name),-1)
		f  s PreName=$O(^DHCPEPreIBI(0,"Name",PreName)) q:(PreName="")||(PreName'[Name)  d
		.s BaseInfo=0
		.f  s BaseInfo=$O(^DHCPEPreIBI(0,"Name",PreName,BaseInfo)) q:(BaseInfo="")  d
		..s PIADM=""
		..f  s PIADM=$O(^DHCPEPreIADM(0,"PIBI",BaseInfo,PIADM)) q:PIADM=""  d
		...s IADM=$O(^DHCPEIADM(0,"CRMADM",PIADM,0))
		...q:IADM=""
		...d OneIADMInfo
	}
	elseif GADMID'="" 
	{
		if GADMID="ALLI"
		{
        s IADM="0"        
        f  s IADM=$O(^DHCPEIADM(IADM)) q:IADM=""  d
        .s teamid=$P(^DHCPEIADM(IADM),"^",2) q:teamid'=""
        .d OneIADMInfo
		}
		elseif GADMID="ALLG"
		{
		s IADM="0"        
        f  s IADM=$O(^DHCPEIADM(IADM)) q:IADM=""  d
        .s teamid=$P(^DHCPEIADM(IADM),"^",2) q:teamid=""
        .d OneIADMInfo
		}
		else
		{
		s TeamID=""
		f  s TeamID=$O(^DHCPEIADM(0,"GADM",GADMID,TeamID)) q:TeamID=""  d
		.s IADM=""
		.f  s IADM=$O(^DHCPEIADM(0,"GADM",GADMID,TeamID,IADM)) q:IADM=""  d
		..d OneIADMInfo
		}
	}
	else
	{
		s AdmDate=DateBegin-1
		f  s AdmDate=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate)) q:(AdmDate="")||(AdmDate>DateEnd)  d
		.s Time=""
		.f  s Time=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time)) q:(Time="")  d
		..s IADM=0
		..f  s IADM=$O(^DHCPEIADM(0,"AdmDateTime",AdmDate,Time,IADM)) q:(IADM="")  d
		...d OneIADMInfo
	}
	
	/*
	w "共"_(ind-1)_"人"
	s Sex=""
	f  s Sex=$O(^TempDHCPECheckProgress(Job,Sex)) q:Sex=""  d
	.w ","_Sex_$G(^TempDHCPECheckProgress(Job,Sex))_"人"
	*/
   	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OneIADMInfo
	q:IADM=""
	s preiadm=$p($g(^DHCPEIADM(IADM)),"^",4)
	s PAADM=$p($g(^DHCPEIADM(IADM)),"^",1)
	;s RLTID=$O(^DHCPERLT(0,"ADM",PAADM,0))
	s THadSendMessage="0",IFSelect="0"
	
	i $D(^User.DHCPENewSendMessageI("TypeSourceIndex","PAADM",PAADM)) d
 	.s THadSendMessage="1"
 	e  d
 	.s THadSendMessage="0"
 		
 	s ReCheckFlag=$P(^DHCPEPreIADM(preiadm),"^",28)
	i ReCheckFlag="Y" s ReCheckFlag="1"
	e  s ReCheckFlag="0"
	q:(ReCheck'="")&&(ReCheckFlag'=ReCheck)
	s Status=$P($g(^DHCPEIADM(IADM)),"^",8)
	q:Status'="ARRIVED"
	s (TRegNo,TName,TSex,TPosition,TUnCheckItems)=""
	s PAADM=$P($g(^DHCPEIADM(IADM)),"^",1)
	s LocFlag=##class(web.DHCPE.PreCommon).GetLocFlag("PAADM",PAADM)
	q:LocFlag=1
	s PAPMIID=$P($g(^PAADM(PAADM)),"^",1)
	s TRegNo=$P($g(^PAPER(PAPMIID,"PAT",1)),"^",1)
	s TName=$P($g(^PAPER(PAPMIID,"ALL")),"^",1)
	s TSex=$P($g(^PAPER(PAPMIID,"ALL")),"^",7)
	q:(SexDR'="")&&(SexDR'=TSex)
	i TSex'="" d
	.s TSex=$p($g(^CT("SEX",TSex)),"^",2)
	s TAge=""
	S PAPMIRowId=$o(^PAPERi("PAPMI_PatNo",TRegNo,0))
	i PAPMIRowId'="" s TAge=##class(web.DHCBillInterface).GetPapmiAge(PAPMIRowId,PAADM)
	
	s PIBIIDCard="",PACCardTypeDR="",PACCardDesc=""
	S PACCardTypeDR=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",TRegNo,0)),"PAT",3)),"^",7)
	I PACCardTypeDR'=""  S PACCardDesc=$p($g(^PAC("CARD",PACCardTypeDR)),"^",2)
	s PIBIIDCard=$P($G(^PAPER($o(^PAPERi("PAPMI_PatNo",TRegNo,0)),"PAT",3)),"^",6)

	s PreIADM=$p($g(^DHCPEIADM(IADM)),"^",4)
	s TPosition=$G(^DHCPEDataEx("DHCPEPreIADM","Position",PreIADM))
	q:(Depart'="")&&(TPosition'[Depart)
	s TVIPLevelInfo=##class(web.DHCPE.PreCommon).GetVIPLevel("Pre",PreIADM)
	s TVIPLevel=$P(TVIPLevelInfo,"^",1)
	q:(VIPLevel'="")&&(TVIPLevel'=VIPLevel)
	s TVIPLevel=$P(TVIPLevelInfo,"^",2)
	s TCheckDate=$p($g(^DHCPEIADM(IADM)),"^",5)
	q:(TCheckDate<DateBegin)||(TCheckDate>DateEnd)
	s:TCheckDate'="" TCheckDate=##class(websys.Conversions).DateLogicalToHtml(TCheckDate)
	s TGroupID="",GBID="",TGroupDesc=""
	s TGroupID=$p($g(^DHCPEIADM(IADM)),"^",2)
	i TGroupID'="" d
	.s GBID=$P($g(^DHCPEGADM(TGroupID)),"^",1)
	.i GBID'="" s TGroupDesc=$P($g(^DHCPEGBI(GBID)),"^",2)

	
	s TUnCheckItems=##class(web.DHCPE.ResultEdit).GetUnAppedItems("",PAADM,"1","0")
	s TUnCheckItems=$P(TUnCheckItems,"^",2)
	i TUnCheckItems="" s TUnCheckItems="无"
	e  s TUnCheckItems="有"
	
	s HadPrint=$D(^DHCPESpecialReportPrintRecord(PAADM, "DHCPEPISRequest"))
	s THadPrint="N"
	s:HadPrint'=0 THadPrint="Y"
	s TReportStatus=##class(web.DHCPE.FetchReport).GetReportStatus(PAADM)
	q:(CheckStatus="1")&&($P(TReportStatus,"^",CheckStatus)="1")
	q:(CheckStatus="2")&&(($P(TReportStatus,"^",CheckStatus)="1")||($P(TReportStatus,"^",(CheckStatus-1))'="1"))
	q:(CheckStatus="3")&&(($P(TReportStatus,"^",CheckStatus)="1")||($P(TReportStatus,"^",(CheckStatus-1))'="1"))
	q:(CheckStatus="4")&&(($P(TReportStatus,"^",CheckStatus)="1")||($P(TReportStatus,"^",(CheckStatus-1))'="1"))
	q:(CheckStatus="5")&&(($P(TReportStatus,"^",CheckStatus)'="")||($P(TReportStatus,"^",(CheckStatus-1))'="1"))
	q:(CheckStatus="6")&&(($P(TReportStatus,"^",CheckStatus)="1")||($P(TReportStatus,"^",(CheckStatus-1))=""))
	q:(CheckStatus="7")&&($P(TReportStatus,"^",6)'="1")
	
	s THadRec=$p(TReportStatus,"^",1)
	s TSendAudit=$p(TReportStatus,"^",2)
	s TReportAudit=$p(TReportStatus,"^",3)
	s TMainAudit=$p(TReportStatus,"^",4)
	s TReportPrint=$p(TReportStatus,"^",5)
	s TFetchReport=$p(TReportStatus,"^",6)
	s TDietFlag=##class(web.DHCPE.PreIADM).GetDietFlagByID(PreIADM)
	q:(DietFlag'="")&&(+TDietFlag'=DietFlag)
	
	s TPhotoFlag=##class(web.DHCPE.PreIADM).GetPhotoFlag(PreIADM)
	s PreibaseID=$p($g(^DHCPEPreIADM(preiadm)),"^",1)
	s Ibasedata=$g(^DHCPEPreIBI(PreibaseID))
	s TTel=""
	s:$p(Ibasedata,"^",7)'="" TTel=$p(Ibasedata,"^",7)
	s:$p(Ibasedata,"^",6)'="" TTel=$p(Ibasedata,"^",6)
	s:$p(Ibasedata,"^",8)'="" TTel=$p(Ibasedata,"^",8)
	s TReportID=$o(^DHCPERPT(0,"IADM",IADM,0))
	s ^TempDHCPECheckProgress(Job,TSex)=$G(^TempDHCPECheckProgress(Job,TSex))+1
	s THPNo=$p($g(^DHCPEPreIADM(preiadm)),"^",27)
	d CheckProgressOut
	q
	
CheckProgressOut

    /***翻译 start***/
	s TSex=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.CTSex",TSex,"CTSEXDesc","cls")
	s PACCardDesc=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCCredType",PACCardDesc,"CRTDesc","cls")
    s TVIPLevel=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("User.DHCPEVIPLevel",TVIPLevel,"VLDesc","cls")
    s TUnCheckItems=##class(web.DHCPE.CT.Public.PubFun).GetTranslationDesc("dhcpecheckprogress.hisui.csp",TUnCheckItems)
    /***翻译 end***/
    
    s Data=$LB(TRegNo,TName,TSex,TPosition,TUnCheckItems,PAADM,THadPrint,TVIPLevel,TCheckDate,TGroupDesc,TReportStatus,TDietFlag,TPhotoFlag,PreIADM,TTel,TReportID,THadSendMessage,THPNo,THadRec,TSendAudit,TReportAudit,TMainAudit,TReportPrint,TFetchReport,TAge,PACCardDesc,PIBIIDCard,ReCheckFlag)
    Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod CheckProgressFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = CheckProgressExecute ]
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

ClassMethod CheckProgressClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = CheckProgressExecute ]
{
    Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod OutTypeToHTML(ContrlWidth As %String = "") As %String
{
	s:(""=ContrlWidth) ContrlWidth="155"
	
	//下拉列表
	w "<select name='Type' id='Type' style='width:"_ContrlWidth_"' HEIGHT=0  tabIndex=2>",!
	w "<option value=''>"_""_"</option>",!
	s TeamType=""
    w "<option value='"_"个人"_"'>"_"个人"_"</option>",!
    w "<option value='"_"团体"_"'>"_"团体"_"</option>",!
	w "</select>",!
	Quit $$$OK
}

ClassMethod OutCheckStatus(ContrlWidth As %String = "", DefaultValue As %String = "")
{
	;d ##Class(web.DHCPE.Report.DoctorWorkStatistic).OutCheckStatus("130",1)
	s:(""=ContrlWidth) ContrlWidth="155"
	s (NoAsCharged,AsCharged)=""
	//下拉列表
	w "<select name='CheckStatus' id='CheckStatus' style='width:"_ContrlWidth_"' HEIGHT=0 tabIndex=0>",!
	w "<option value=''></option>",!
	i DefaultValue="1" d
	.s Default=" selected"
	e  d
	.s Default=""
	w "<option value='1'"_Default_">未收表</option>",!
	i DefaultValue="2" d
	.s Default=" selected"
	e  d
	.s Default=""
	w "<option value='2'"_Default_">未粘贴</option>",!
	i DefaultValue="3" d
	.s Default=" selected"
	e  d
	.s Default=""
	w "<option value='3'"_Default_">未初检</option>",!
	i DefaultValue="4" d
	.s Default=" selected"
	e  d
	.s Default=""
	w "<option value='4'"_Default_">未复检</option>",!
	i DefaultValue="5" d
	.s Default=" selected"
	e  d
	.s Default=""
	w "<option value='5'"_Default_">未打印</option>",!
	i DefaultValue="6" d
	.s Default=" selected"
	e  d
	.s Default=""
	w "<option value='6'"_Default_">未取</option>",!
	i DefaultValue="7" d
	.s Default=" selected"
	e  d
	.s Default=""
	w "<option value='7'"_Default_">已取</option>",!
	w "</select>",!
	Quit $$$OK
}

}
