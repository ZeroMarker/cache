Import SQLUser

Class web.DHCAdmEmStat Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 52;

Query FindAdmEmStat(locId As %String, regNo As %String, userId As %String, admType As %String, fDate As %String, tDate As %String, ctcpId As %String, needAdsouDesc As %String, needDdestDsec As %String) As %Query(ROWSPEC = "admDate:%String,admTime:%String,patRegNo:%String,patientName:%String,sex:%String,birthday:%String,age:%String,ssDesc:%String,paperStName:%String,tel:%String,admLocDesc:%String,firstCtcpDesc:%String,mrciDesc:%String,adsouDesc:%String,ddestDsec:%String")
{
}

ClassMethod FindAdmEmStatExecute(ByRef qHandle As %Binary, locId As %String = "", regNo As %String = "", userId As %String = "", admType As %String = "", fDate As %String = "", tDate As %String = "", ctcpId As %String = "", needAdsouDesc As %String = "", needDdestDsec As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
    s dayAhead=0 ;7

    //按病人入院时间查找
    //locId对住院病人为病区,对其它是科室
    //i (locId="")&(regNo="")     s qHandle=$lb(0,repid,0)	q $$$OK

    //i userId="", admType="", fDate="", tDate=""
    s userId=1
    k PLIST
    s EpisodeID=$p(regNo,"^",2) //ypz 060726
    s regNo=$p(regNo,"^",1)  
    i EpisodeID'="" d
        .s curAdmType=$p(^PAADM(EpisodeID),"^",2)
        .i (curAdmType'="")&(admType'[curAdmType) q
        .s papmiId=+^PAADM(EpisodeID)
        .s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        .s admIdStr=EpisodeID_"^"_patName
        .d GetAdmEmInfo
    i EpisodeID'="" s qHandle=$lb(0,repid,0)	q $$$OK  //ypz 060726

    i regNo'="" d
        .s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
        .q:papmiId=""
        .i admType["O" d  //ypz 060721
            ..s EpisodeID="" //,adjusted=0 //倒序找
            ..f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","O",EpisodeID),-1) q:EpisodeID=""  d  
                ...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
                ...i pavisit'="A" q   ;
                ...s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
                ...//i (adjusted=0)&(admDate<fDate) s adjusted=1,fDate=admDate
                ...//s adjusted=1
                ...s admLocId=$p($g(^PAADM(EpisodeID)),"^",4)
                ...q:admLocId=""
                ...s admLocDesc=$p(^CTLOC(admLocId),"^",2)
                ...//ypz debug//q:(admLocDesc'["急诊")
                ...q:admDate+dayAhead<fDate
                ...q:admDate>tDate
                ...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
                ...d GetAdmEmInfo
                ...//s ^ypzTmp(EpisodeID,1)=fDate_"/"_admDate
                ...//s ^TMP("NurExec",userId,"Patient",-EpisodeID)=EpisodeID_"^"_patName
        .i admType["E" d
            ..s EpisodeID=""
            ..f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","E",EpisodeID),-1) q:EpisodeID=""  d  
                ...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
                ...i pavisit'="A" q   ;
                ...s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
                ...//i (adjusted=0)&(admDate<fDate) s adjusted=1,fDate=admDate
                ...//s adjusted=1
                ...q:admDate+dayAhead<fDate
                ...q:admDate>tDate
                ...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
                ...d GetAdmEmInfo
                ...//s ^ypzTmp(EpisodeID,1)=fDate_"/"_admDate
                ...//s ^TMP("NurExec",userId,"Patient",-EpisodeID)=EpisodeID_"^"_patName
    i regNo'="" s qHandle=$lb(0,repid,0) q $$$OK //有登记号直接退出
    //i locId="" s qHandle=$lb(0,repid,0)	q $$$OK  //按病人科室查
    s fDate=fDate-dayAhead
    f curDate=fDate:1:tDate d
        .s EpisodeID=""
        .f  s EpisodeID=$o(^PAADMi("PAADM_AdmDate",curDate,EpisodeID)) q:EpisodeID=""  d
            ..//w 8_$p(^PAADM(EpisodeID),"^",2)
            ..//q:$p(^PAADM(EpisodeID),"^",2)'=admType
            ..q:admType'[$p(^PAADM(EpisodeID),"^",2)  //ypz 060721
            ..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
            ..i pavisit'="A" q   ;
            ..//w $p($g(^PAADM(EpisodeID)),"^",4)_","
            ..i locId'="",$p($g(^PAADM(EpisodeID)),"^",4)'=locId  q
            ..s patName=$p($g(^PAPER(+^PAADM(EpisodeID),"ALL")),"^",1)
            ..//s ^TMP("NurExec",userId,"Patient",-EpisodeID)=EpisodeID_"^"_patName //为排序
            ..d GetAdmEmInfo

    s qHandle=$lb(0,repid,0)
	q $$$OK
GetAdmEmInfo
    s admDate=$zd($p(^PAADM(EpisodeID),"^",6),3)
    s admTime=$zt($p(^PAADM(EpisodeID),"^",7),2)
    s patRegNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
    s patInfo=##Class(web.DHCCLCom).PatInfo("^"_EpisodeID)
    //regNo_"^"_ctlocDesc_"^"_$g(room)_"^"_$g(sex)_"^"_$g(patName)_"^"_$g(safetyNetCardNo)_"^"_$g(bedCode)_"^"_$g(age)_"岁^"_$g(wardDesc)_"^"_homeAddres_"^"_homeTel_"  "_workTel_"  "_handtel_"^"_$G(DocDes)_"^"_MedCareNo
	s patientName=$p(patInfo,"^",5)
	s sex=$p(patInfo,"^",4) //n
	s age=$p(patInfo,"^",8)
	s papmiId=+^PAADM(EpisodeID)
	s birthday=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	i birthday'="" s birthday=$zd(birthday,3) //n
	s ssId=$p($g(^PAPER(papmiId,"PER",1)),"^",10) // PAPER_SocialStatus_DR
	s ssDesc=""
	i ssId'="" s ssDesc=$p(^CT("SS",ssId),"^",2) //n
	s paperStName=$p(patInfo,"^",10)
	s tel=$p(patInfo,"^",11)
    s admLocDesc=$p(patInfo,"^",2)
    s transSub=0,firstCtcpId=0
    f  s transSub=$o(^PAADM(EpisodeID,"TRANS",transSub)) q:(transSub="")!(firstCtcpId'=0)  d
        .s firstCtcpId=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",5)
    i ctcpId'="",firstCtcpId'=ctcpId q
    s firstCtcpDesc=$P($g(^CTPCP(firstCtcpId,1)),"^",2) //n
    s mradmId=$P(^PAADM(EpisodeID),"^",61)
  	s mrdiaSub=0,mrciDesc=""
  	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
  		.s mrcidId=$p(^MR(mradmId,"DIA",mrdiaSub),"^") //
  		.q:mrcidId=""
  		.i mrciDesc'="" s mrciDesc=mrciDesc_","
  		.s mrciDesc=mrciDesc_$p($g(^MRC("ID",mrcidId)),"^",2)
    s adsouId=$p(^PAADM(EpisodeID),"^",10)
    s adsouDesc="" 
    i adsouId'="" s adsouDesc=$p(^PAC("ADSOU",adsouId),"^",2)
    i needAdsouDesc'="",needAdsouDesc'=adsouDesc q
    
    s ddestId=$p(^MR(mradmId,"PRO",1),"^",51)
    s ddestDsec=""
    i ddestId'="" s ddestDsec=$p(^PAC("DDEST",ddestId),"^",2)
    i needDdestDsec'="",needDdestDsec'=ddestDsec q

    //s patVisitStat=$p(^DHCPACVisitStatus($p($g(^DHCADMVisitStatus(avsId)),"^",2)),"^",2)
    //q:patVisitStat=""
    //q:(visitStat'="")&(visitStat'=patVisitStat)
    
    s userDesc=$p(^SSU("SSUSR",userId),"^",2)
    s wardId="" //$p(^DHCADMVisitStatus(avsId),"^",10)
    s inWardDesc=""
    i wardId'="" s inWardDesc=$p(^PAWARD(wardId),"^",2)
    d OutRowEpisode
    q

OutRowEpisode
	s Data=$lb(admDate,admTime,patRegNo,patientName,sex,birthday,age,ssDesc,paperStName,tel,admLocDesc,firstCtcpDesc,mrciDesc,adsouDesc,ddestDsec)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAdmEmStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmEmStatExecute ]
{
	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindAdmEmStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmEmStatExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

}
