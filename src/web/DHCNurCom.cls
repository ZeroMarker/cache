Import SQLUser

Include Nur.DateFormat

/// 护士执行公共:参数设置,执行,查询
Class web.DHCNurCom Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Not ProcedureBlock ]
{

Parameter BUILD = 907;

/// Creator:      ozl
/// CreateDate:   2017-11-02
/// Description:  获取传入日期的全院转科记录情况
/// Input:        日期
/// Return:       患者Id，住院次数，出病区Code，入病区Code，发生时间。
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCNurCom","GetTransConditions","64477")
Query GetTransConditions(TRANSDate As %String = "") As %Query(ROWSPEC = "PATIENTID:%String,VISITID:%String,OUTDEPT:%String,INDEPT:%String,LOGDATETIME:%String")
{
}

ClassMethod GetTransConditionsExecute(ByRef qHandle As %Binary, TRANSDate As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s:TRANSDate="" TRANSDate=+$h
 	S:TRANSDate["-" TRANSDate=$zdh(TRANSDate,3)
 	s:TRANSDate["/" TRANSDate=$zdh(TRANSDate,2)
 	k TMPsort
	s TRANSTime="",PreWard="",CurWard="",HavePrintAdm=""
	f  s TRANSTime=$o(^PAADMi("TransDateTime",TRANSDate,TRANSTime)) q:(TRANSTime="")  d
	.s PAADMId="" f  s PAADMId=$o(^PAADMi("TransDateTime",TRANSDate,TRANSTime,PAADMId)) q:(PAADMId="")  d
	..s InHosSub=##Class(web.DHCWMRCodingInterface).getPaadmIP(PAADMId)
	..s PAPMIDR=$p($g(^PAADM(PAADMId)),"^",1)
	..s AdmDate=$p($g(^PAADM(PAADMId)),"^",6)
	..i (AdmDate=TRANSDate)&(HavePrintAdm'[("^"_PAADMId_"^")) d
	...s OUTDep=""
	...s FirstTransWard=..GetFirstTransWard(PAADMId)
	...s INTDep=+FirstTransWard
	...s:INTDep'="" INTDep=$p($g(^PAWARD(INTDep)),"^",1)
	...s HappenDate=$p(FirstTransWard,"^",2)
	...s HavePrintAdm=HavePrintAdm_"^"_PAADMId_"^"
	...s TMPsort(PAPMIDR,HappenDate)= PAPMIDR_"^"_InHosSub_"^"_OUTDep_"^"_INTDep_"^"_HappenDate
	..s TRANSSub="" f  s TRANSSub=$o(^PAADMi("TransDateTime",TRANSDate,TRANSTime,PAADMId,TRANSSub)) q:(TRANSSub="")  d
	...s TRANSWard=$p($g(^PAADM(PAADMId,"TRANS",TRANSSub)),"^",9)
	...q:(TRANSWard="")
	...q:($p($g(^PAADM(PAADMId,"TRANS",TRANSSub)),"^",8)'="")
	...s IFTranDesc=..IFTransWard(PAADMId,TRANSSub)
	...i $p(IFTranDesc,"^")="Y" d
	....s OUTDep=$p($g(^PAWARD($p(IFTranDesc,"^",2))),"^",1)
	....s INTDep=$p($g(^PAWARD($p(IFTranDesc,"^",3))),"^",1)
	....s HappenDate=$p(IFTranDesc,"^",4)
	....s TMPsort(PAPMIDR,HappenDate)= PAPMIDR_"^"_InHosSub_"^"_OUTDep_"^"_INTDep_"^"_HappenDate
	...
	..
	.
	s PAADM="" f  s PAADM=$o(^PAADMi("DischDate",TRANSDate,PAADM)) q:(PAADM="")  d
	.s InHosSub=##Class(web.DHCWMRCodingInterface).getPaadmIP(PAADM)
	.s PAPMIDR=$p($g(^PAADM(PAADM)),"^",1)
	.s OUTDep=$p($g(^PAWARD($p($g(^PAADM(PAADM)),"^",70))),"^",1)
	.s INTDep=""
	.s DischDate=$p($g(^PAADM(PAADM)),"^",17)
	.s DischTime=$p($g(^PAADM(PAADM)),"^",18)
	.s HappenDate=$zd(DischDate,3)_" "_$zt(DischTime)
	.s TMPsort(PAPMIDR,HappenDate)= PAPMIDR_"^"_InHosSub_"^"_OUTDep_"^"_INTDep_"^"_HappenDate
	
	s PAADMIdDesc="" f  s PAADMIdDesc=$o(TMPsort(PAADMIdDesc)) q:(PAADMIdDesc="")  d
	.s DateAndTime="" f  s DateAndTime=$o(TMPsort(PAADMIdDesc,DateAndTime)) q:(DateAndTime="")  d
	..s PAPMIDR=$p(TMPsort(PAADMIdDesc,DateAndTime),"^",1)
	..s InHosSub=$p(TMPsort(PAADMIdDesc,DateAndTime),"^",2)
	..s OUTDep=$p(TMPsort(PAADMIdDesc,DateAndTime),"^",3)
	..s INTDep=$p(TMPsort(PAADMIdDesc,DateAndTime),"^",4)
	..s HappenDate=$p(TMPsort(PAADMIdDesc,DateAndTime),"^",5)
	..d OutputRow9
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
	set Data=$lb(PAPMIDR,InHosSub,OUTDep,INTDep,HappenDate)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetTransConditionsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetTransConditionsExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod GetTransConditionsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetTransConditionsExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetFirstTransWard(PAADM) As %String
{
	n (PAADM)
	q:(PAADM="") ""
	s FirstWard=""
	s TRANSSub="" f  s TRANSSub=$o(^PAADM(PAADM,"TRANS",TRANSSub)) q:(TRANSSub="")!(FirstWard'="")  d
	.s TRANSWard=$p($g(^PAADM(PAADM,"TRANS",TRANSSub)),"^",9)
	.q:(TRANSWard="")
	.s FirstWard=TRANSWard
	.s StDate=$p($g(^PAADM(PAADM,"TRANS",TRANSSub)),"^",1)
	.s StTime=$p($g(^PAADM(PAADM,"TRANS",TRANSSub)),"^",2)
	q FirstWard_"^"_$zd(StDate,3)_" "_$zt(StTime)
}

ClassMethod IFTransWard(PAADM, CurTRANSSub) As %String
{
	n (PAADM,CurTRANSSub)
	q:(PAADM="") "N"
	s PreTRANSSub="",IFTRANS="N",OUTDep="",INDep=""
	s TRANSSub="" f  s TRANSSub=$o(^PAADM(PAADM,"TRANS",TRANSSub)) q:(TRANSSub="")!(IFTRANS="Y")  d
	.s TRANSWard=$p($g(^PAADM(PAADM,"TRANS",TRANSSub)),"^",9)
	.q:(TRANSWard="")
	.q:($p($g(^PAADM(PAADM,"TRANS",TRANSSub)),"^",8)'="")
	.i (CurTRANSSub=TRANSSub)&(PreTRANSSub'="") d
	..i $p($g(^PAADM(PAADM,"TRANS",CurTRANSSub)),"^",9)'=$p($g(^PAADM(PAADM,"TRANS",PreTRANSSub)),"^",9) d
	...s IFTRANS="Y"
	...s OUTDep=$p($g(^PAADM(PAADM,"TRANS",PreTRANSSub)),"^",9)
	...s INDep=$p($g(^PAADM(PAADM,"TRANS",CurTRANSSub)),"^",9)
	.s PreTRANSSub=TRANSSub
	.s FirstWard=TRANSWard
	s StDate=$p($g(^PAADM(PAADM,"TRANS",CurTRANSSub)),"^",1)
	s StTime=$p($g(^PAADM(PAADM,"TRANS",CurTRANSSub)),"^",2)
	q IFTRANS_"^"_OUTDep_"^"_INDep_"^"_$zd(StDate,3)_" "_$zt(StTime)
}

Query FindAllBInWardRes(WardDesc As %String, WardID As %String, Bed As %String, EpisodeID As %String, AvailableBeds As %String, DateFrom As %Library.Date, TimeFrom As %Library.Time, Room As %String, SortOrder As %String, AdmType As %String, Location As %String) As %Library.Query(CONTAINID = 0, ROWSPEC = "PACBedDesc:%String,PACWardDesc:%String,PACRoomDesc:%String,BedType:%String,statDesc:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,PACRoomType:%String,HIDDEN:%String,RestrictReason:%String,RestrictDateFrom:%String,RestrictTimeFrom:%String,RestrictDateTo:%String,RestrictTimeTo:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String,HIDDEN:%String")
{
}

ClassMethod FindAllBInWardResClose(QHandle As %Library.Binary) As %Library.Status [ PlaceAfter = FindAllBInWardResFetch ]
{
	n repid
	Set repid=$LIST(QHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// SB 30/08/02 (24407): This Lookup was copied from FindAvailBInWarRes. Site wants to see all beds with a status against each one.
/// 
ClassMethod FindAllBInWardResExecute(ByRef QHandle As %Library.Binary, WardDesc As %Library.String, OrigWardID As %Library.String, BedCode As %Library.String, EpisodeID As %Library.String, AvailableBeds As %Library.String, DateFrom As %Library.Date, TimeFrom As %Library.Time, RoomDesc As %Library.String = "a", SortOrder As %String = "", AdmType As %String = "", Location As %String = "") As %Library.Status
{
	n repid
	s repid=$I(^CacheTemp)
	s ind=1
    
    // PACBedDesc,PACWardDesc,PACRoomDesc,BedType,statDesc,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,PACRoomType,HIDDEN,RestrictReason,RestrictDateFrom,RestrictTimeFrom,RestrictDateTo,RestrictTimeTo,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN,HIDDEN
	;所选病区的床位信息, HIDDEN 的位置(不知道),后面那些不知道什么意思
	//i WardDesc="" s QHandle=$lb(0,repid1,0) q $$$OK
	s:%request.Get("WardID")'="" WardID=%request.Get("WardID") 
	s INBED=$P(WardDesc,"^",2)
	s WardDesc=$P(WardDesc,"^",1)
	s:WardDesc'="" WardID=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(WardDesc),0))
	i $g(WardID)="" s QHandle=$lb(0,repid,0) q $$$OK
	i ($g(WardID)=""){
		set WardID=$O(^PAWARD(0))
		while (WardID'="")
		{
			d findbyward(WardID)
			set WardID=$O(^PAWARD(WardID))
		}
	}
	else
	{
		s WardDesc = $p(^PAWARD(WardID),"^",2)
		d findbyward(WardID)
	}
	s QHandle=$lb(0,repid,0)
	q $$$OK
findbyward(WardID)
	s wardLinkLoc=$p($G(^PAWARD(WardID)),"^",5)
	q:wardLinkLoc="" ""
	s locType=$p(^CTLOC(wardLinkLoc),"^",13)
	q:(locType'="EM")&&(AdmType="E") ""
	s PACWardDesc=WardDesc
	s bedsub=0 f  {
		s bedsub=$o(^PAWARD(WardID,"BED",bedsub)) 
		q:bedsub=""
		s (PACBedDesc,PACRoomDesc,BedType,statDesc,PACRoomType,RestrictReason,RestrictDateFrom,RestrictTimeFrom,RestrictDateTo,RestrictTimeTo)=""
		s PACBedDesc=$p(^PAWARD(WardID,"BED",bedsub),"^",1)
		s PACRoomID=$p(^PAWARD(WardID,"BED",bedsub),"^",3)
		s:PACRoomID'="" PACRoomDesc=$p($g(^PAROOM(PACRoomID)),"^",2)
		s BedTypeID=$p(^PAWARD(WardID,"BED",bedsub),"^",2)
		s:BedTypeID'="" BedType=$p($g(^PAC("BEDTP",BedTypeID)),"^",2)
		s RcFlag=$p(^PAWARD(WardID,"BED",bedsub),"^",4)
		continue:(RcFlag="N") ;未激活的床
		s PACRoomTypeID=""
		s:PACRoomID'="" PACRoomTypeID=$p($G(^PAROOM(PACRoomID)),"^",3)	
		s:PACRoomTypeID'="" PACRoomType=$p($G(^PAC("ROOMT",PACRoomTypeID)),"^",2)
	
		s BedID=WardID_"||"_bedsub
		;
		&sql(select BED_Available into :available from SQLUser.PAC_Bed WHERE BED_RowId = :BedID)
		s:EpisodeID'="" statDesc=$s(available="N":"占用",1:"空")
		s statDesc=""
		s unavail=##class(web.PACBedStatusChange).IsUnavailBedStatus(BedID,.statDesc)
		
		;如果床位上已经安排病人,就不需要显示
		s adm=$o(^PAWARDA(+WardID,"BED",+$p(BedID,"||",2),"ADM",0))
		continue:(INBED'="INBED")&&(adm'="")
		continue:(INBED="INBED")&&(adm="")
		;PAC_BedAvailRestriction
		s avrbedsub=0 f {
			s avrbedsub=$o(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub)) 
			q:avrbedsub=""
			s RestrictReasonDR=$p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",3)
			s RestrictReason=$p(^PAC("RNAV",RestrictReasonDR),"^",2)
			s RestrictDateFrom=$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",1),3)
			s RestrictTimeFrom=$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",4),3)
			s RestrictDateTo=$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",2),3)
			s RestrictTimeTo=$zd($p(^PAWARD(WardID,"BED",bedsub,"AVR",avrbedsub),"^",5),3)
		}
		;PAC_BedStatusChange, availRestriction表中没存记录, 从状态表中取数据,wanghc
		if (statDesc'=""){
			s statubedsub=$o(^PAWARDA(WardID,"BED",bedsub,"STAT",""),-1) 
			if statubedsub>0{
				Set tmpstatdata = $g(^PAWARDA(WardID,"BED",bedsub,"STAT",statubedsub))
				s RestrictReasonDR=$p(tmpstatdata,"^",7)
				s RestrictReason=$p(^PAC("RNAV",RestrictReasonDR),"^",2)
				s RestrictDateFrom=$p(tmpstatdata,"^",1)
				IF (RestrictDateFrom'="") SET RestrictDateFrom=$zd(RestrictDateFrom,3)
				s RestrictTimeFrom=$p(tmpstatdata,"^",2)
				IF (RestrictTimeFrom'="") SET RestrictTimeFrom=$zT(RestrictTimeFrom)
				s RestrictDateTo=$p(tmpstatdata,"^",5)
				IF (RestrictDateTo'="") SET RestrictDateTo=$zD(RestrictDateTo,3)
				s RestrictTimeTo=$p(tmpstatdata,"^",6)
				IF (RestrictTimeTo'="") SET RestrictTimeTo=$zT(RestrictTimeTo)
			}
			
		}
		d outputrow
	}
	Q
outputrow
	s ^CacheTemp(repid,ind)=$lb(PACBedDesc,PACWardDesc,PACRoomDesc,BedType,statDesc,WardID_"||"_bedsub,WardID,BedTypeID,PACRoomID,PACRoomTypeID,PACRoomType,WardID_"||"_bedsub_"||"_avrbedsub,RestrictReason,RestrictDateFrom,RestrictTimeFrom,RestrictDateTo,RestrictTimeTo)
	s ind=ind+1
	q
}

/// SB 30/08/02 (24407): This Lookup was copied from FindAvailBInWarRes. Site wants to see all beds with a status against each one.
ClassMethod FindAllBInWardResFetch(ByRef QHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = FindAllBInWardResExecute ]
{
	n repid
	Set AtEnd=$LIST(QHandle,1)
 	Set repid=$LIST(QHandle,2)
 	Set ind=$LIST(QHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s QHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 取处方号/日期/医生
ClassMethod GetPrescInfo(oeoriId As %String) As %String
{
    //w ##class(web.DHCNurCom).GetPrescInfo("464||21||1")
    s oeordId=$P(oeoriId,"||",1)
    s oeoriSub=$P(oeoriId,"||",2)
    s prescCP=""
    s userId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    i userId'="" d
    .s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
    .q:ctpcpId=""
    .s prescCP=$p($g(^CTPCP(ctpcpId,1)),"^",2)
    s prescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
    q:prescNo="" "^^"_prescCP_"^"_$$$ZD(+$h,3)
    s prescId=$O(^PAQUE1(0,"PrescNo",prescNo,0))
    q:prescId="" "^^^"_$$$ZD(+$h,3)
    s prescDate=$P(^PAQUE1(prescId),"^",7)
    i prescDate'="" s prescDate=$$$ZD(prescDate,3)
    //s prescTime=$P(^PAQUE1(prescId),"^",8)
    //i prescTime'="" s prescTime=$ZT(prescTime,2)
    s prescCP=""
    s prescCPDr=$P(^PAQUE1(prescId),"^",5)
    i prescCPDr'="" d
    .s prescCP=$p($g(^CTPCP(prescCPDr,1)),"^",2)
    q prescNo_"^"_prescDate_"^"_prescCP_"^"_$$$ZD(+$h,3)
}

/// 根据工号取医护分组
ClassMethod getCTPCPGroupByUserCode(userCode As %String) As %String
{
	//W ##class(web.DHCNurCom).getCTPCPGroupByUserCode(userCode)
	q:userCode="" ""
	s group=""
	s ssrowid=$O(^SSU("SSUSR",0,"SSUSR_Initials",userCode,""))
	i ssrowid'=""  {
		s CPId=$P(^SSU("SSUSR",ssrowid),"^",14) //根据userId取出医护人员ID
		i CPId'="" {
			s locId=""
			f {
				s locId=$O(^CTLOC(0,"CTPCP",CPId,locId)) //根据医护人员ID遍历科室ID
				q:locId=""
				s groupSubId=""  //s ctmurowid=$O(^CTLOC(0,"CTPCP",CPId,locId,"MU","")) //取出组ID
				f {
					s groupSubId=$O(^CTLOC(0,"CTPCP",CPId,locId,"MU",groupSubId))
					q:groupSubId=""
					s mucprowid=""
					f {
						s mucprowid=$O(^CTLOC(0,"CTPCP",CPId,locId,"MU",groupSubId,"CP",mucprowid))
						q:mucprowid=""
						s mucpendate=$P(^CTLOC(locId,"MU",groupSubId,"CP",mucprowid),"^",6)
						i (mucpendate'="")&&(mucpendate>0)
						{
							continue:mucpendate<(+$h)
						}
						i groupSubId'="" {
							s group=$P(^CTLOC(locId,"MU",groupSubId),"^",2) //取出组  //  ," ("_group_")"
						}
					}
				}
			}
		}
	}
	q group
}

ClassMethod GetTypVar(queryTypeCode As %String, HospitalRowId As %String)
{
    q:(queryTypeCode="")!(HospitalRowId="") ""
    s num=$l(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"VarId"),"^")
    s varIdStr=^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"VarId")
    f i=1:1:num
    {   s id=$p(varIdStr,"^",i)
	    q:id=""
	    s var=$p(^DHCCLNurseExec("Var",id),"^",1)
        s $p(str,"^",i)=var
   	}
 	q str
}

ClassMethod Duityao(oriOreId) As %String
{
	n (oriOreId)
		s oeordId=+oriOreId
		s oeoriSub=$p(oriOreId,"||",2)
		s oeoreSub=$p(oriOreId,"||",3)
		s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
		s ^tmp("a")=oeoriId
	&sql(update OE_OrdExec set OEORE_SignFile =1 where OEORE_RowId=:oeoriId)
	q:SQLCODE
}

// 取消到静配的退药申请

ClassMethod CancelDuityao(oriOreId) As %String
{
	n (oriOreId)
	    s flag=""
		s oeordId=+oriOreId
		s oeoriSub=$p(oriOreId,"||",2)
		s oeoreSub=$p(oriOreId,"||",3)
		s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
		s ^tmp("a")=oeoriId
	&sql(update OE_OrdExec set OEORE_SignFile =:flag where OEORE_RowId=:oeoriId)
	q:SQLCODE
}

ClassMethod GetTy(oriOreId) As %String
{
	n (oriOreId)
		s oeordId=+oriOreId
		s oeoriSub=$p(oriOreId,"||",2)
		s oeoreSub=$p(oriOreId,"||",3)
		s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
		s SignFile=""
	&sql(select OEORE_SignFile into :SignFile from OE_OrdExec where OEORE_RowId=:oeoriId)
	 q SignFile
}

ClassMethod Dabao(oriOreId) As %String
{
	n (oriOreId)
    s oeordId=+oriOreId
    s oeoriSub=$p(oriOreId,"||",2)
    s oeoriSubs=$p(oriOreId,"||",3)
    s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoriSubs
	&sql(update OE_OrdExec set OEORE_Signature=1 where OEORE_RowId=:oeoriId)
	i SQLCODE s ok= "插入失败!"
}

// 取消打包

ClassMethod Canceldabao(oriOreId) As %String
{
	n (oriOreId)
	s flag=""
    s oeordId=+oriOreId
    s oeoriSub=$p(oriOreId,"||",2)
    s oeoriSubs=$p(oriOreId,"||",3)
    s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoriSubs
	&sql(update OE_OrdExec set OEORE_Signature=:flag where OEORE_RowId=:oeoriId)
	i SQLCODE s ok= "取消失败!"
}

ClassMethod GetQueryTypeCode(queryTypeDesc As %String)
{
	//ypz 061126
    q:queryTypeDesc="" ""
    s queryTypeCode=0,resStr=""
    f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",queryTypeCode)) q:queryTypeCode=""  d
        .//w queryTypeCode_","_$p(^DHCCLNurseExec("VarDef",queryTypeCode),"^"),!
        .i queryTypeDesc=$p(^DHCCLNurseExec("VarDef",queryTypeCode),"^") s resStr=queryTypeCode
	q resStr
}

ClassMethod GetVarStr(queryTypeCode As %String)
{
    q:queryTypeCode="" ""
    s num=$l(^DHCCLNurseExec("VarDef",queryTypeCode,"VarId"),"^")
    s varIdStr=^DHCCLNurseExec("VarDef",queryTypeCode,"VarId")
    f i=1:1:num
    {
	    s id=$p(varIdStr,"^",i)
	    q:id=""
	    s var=$p(^DHCCLNurseExec("Var",id),"^",2)
        s $p(str,"^",i)=var
   	}
 	q str
}

ClassMethod GetVarCols(typeCode)
{
	i typeCode="" q 0
	q:$g(^DHCCLNurseExec("VarDef",typeCode,"VarId"))="" 0
	q $l(^DHCCLNurseExec("VarDef",typeCode,"VarId"),"^")
}

Query GetQueryType(ssgrp As %String, userId As %String) As %Query(ROWSPEC = "desc:%String,rw:%String")
{
}

ClassMethod GetQueryTypeExecute(ByRef qHandle As %Binary, ssgrp As %String = "", userId As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
	s queryTypeStr=""
	i ssgrp="" d  //ypz 061103
    	.i (userId'="") s ssgrp=$p(^SSU("SSUSR",userId),"^",5)
	
	i $g(^DHCCLNurseExec("UserGroupAccess","Type",ssgrp))'="" s queryTypeStr=$g(^DHCCLNurseExec("UserGroupAccess","Type",ssgrp))
	i $g(queryTypeStr)="" s num=0
	e  s num=$l($g(queryTypeStr),"^")
	
	f i=1:1:num
	{
		s str=$p(queryTypeStr,"^",i)
		s tmpType=$p(str,"|")
		s HospitalRowId=$p(tmpType,"@",1)
		s queryTypeCode=$p(tmpType,"@",2)
		s typeStr=""
		i HospitalRowId'="",queryTypeCode'="" d
		.q:'$d(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode))
		.s typeStr=$p(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode),"^",1)
		.s typeCode=HospitalRowId_"@"_queryTypeCode
		d OutRowtyp
	}
	i (userId="")
	{
	    s HospitalRowId=""
	    f  s HospitalRowId=$o(^DHCCLNurseExec("VarDef",HospitalRowId)) q:HospitalRowId=""  d
	    .s queryTypeCode=0
	    .f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode)) q:queryTypeCode=""  d
	        ..s typeStr=$p(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode),"^",1)
	        ..s typeCode=HospitalRowId_"@"_queryTypeCode
            ..d OutRowtyp
	}
    s qHandle=$lb(0,repid,0)
	q $$$OK
  
OutRowtyp
	s Data=$lb(typeStr,typeCode)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod GetQueryTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetQueryTypeExecute ]
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

ClassMethod GetQueryTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetQueryTypeExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// 取处置名称
ClassMethod GetDisposeDesc(code)
{
    q:code="" ""
	s DisposeDesc=""
	s disposeId=0
	f  s disposeId=$o(^DHCCLNurseExec("DisposeStat",disposeId)) q:disposeId=""  d
	    .i $p(^DHCCLNurseExec("DisposeStat",disposeId),"^",2)=code s DisposeDesc=$p(^DHCCLNurseExec("DisposeStat",disposeId),"^",1)
	s dts=$$$zd(+$h,3)_" "_$zt($p($h,",",2),2)
	q DisposeDesc_"|"_dts
}

ClassMethod GetTitle(queryTypeCode As %String, HospitalRowId As %String)
{
    //&js<alert("#(queryTypeCode)#"+" ok ");>
    q:(queryTypeCode="")!($G(HospitalRowId)="") ""
    s varStr=^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"VarId")
    s num=$l(varStr,"^")
    f ivar=1:1:num d
        .s $p(titles,"!",ivar)=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",1)
        .s $p(vars,"!",ivar)=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",2)
    q num_"^"_$g(titles)_"^"_$g(vars)
}

/// 取变量值类别
ClassMethod TypeVarGet(code As %String)
{
	q $g(^DHCCLNurseExec("VarDef",code,"VarId"))
}

ClassMethod GetVarType(code As %String, HospitalRowId As %String)
{
	q:(code="")!(HospitalRowId="") ""
	q ^DHCCLNurseExec("VarDef",HospitalRowId,code)
}

/// 取查询类别
ClassMethod GetType()
{
	s HospitalRowId="",queryTypeCode=0,num=0
	f  s HospitalRowId=$o(^DHCCLNurseExec("VarDef",HospitalRowId)) q:HospitalRowId=""  d
	.f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode)) q:queryTypeCode=""  d
	    ..s num=num+1
	    ..s typeStr=queryTypeCode_"^"_^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode)
	    ..s $p(resStr,"!",num)=typeStr
	q $g(resStr)
}

/// 取全部变量项
ClassMethod GetAllVar() As %String
{
	s var=0
	f  s var=$o(^DHCCLNurseExec("Var",var)) q:var=""  d
	    .s varStr=^DHCCLNurseExec("Var",var)_"^"_var
	    .s $p(resStr,"!",var)=varStr
	q $g(resStr)
}

/// 取得处置状态
ClassMethod GetDisposeStat()
{
	s disposeStatId=0
	f  s disposeStatId=$o(^DHCCLNurseExec("DisposeStat",disposeStatId)) q:disposeStatId=""  d
	    .s varStr=disposeStatId_"^"_^DHCCLNurseExec("DisposeStat",disposeStatId)
	    .s $p(resStr,"!",disposeStatId)=varStr
	q $g(resStr)
}

/// 取处置状态代码
ClassMethod GetDisposeStatCode(codeStr)
{
	s resCode=""
	s codeNum=$l(codeStr,"^")
	//&js<alert("sigle  "+"#(codeStr)#"+"/"+"#(codeNum)#"+"/");>
	f ipos=1:1:codeNum d
	    .s codeId=$p(codeStr,"^",ipos)
	    .i codeId="" q
	    .s $p(resCode,"^",ipos)=$p($g(^DHCCLNurseExec("DisposeStat",codeId)),"^",2)
	q resCode
}

/// /////////////////////////////////////////////////////////////////////
/// 将需要处理的病人数据存于Global中
/// ClassMethod FindPatient(wardId As %String, regNo As %String, userId As %String)
ClassMethod FindPatient(locOrWardId As %String, regNo As %String, userId As %String, admType As %String, fDate As %String, tDate As %String, wardProGroupId As %String = "")
{
    //按病人入院时间查找
    //w "w="_locOrWardId,"//", "reg="_regNo,"/",!
    //locOrWardId对住院病人为病区,对其它是科室
    k PLIST
    k ^TMP("NurExec",userId,"Patient")
    s ^TMP("NurExec",userId,"Patient")=""
    s EpisodeID=$p(regNo,"^",2) //ypz 060726
    s regNo=$p(regNo,"^",1)  
    i EpisodeID'="" d
        .s curAdmType=$p(^PAADM(EpisodeID),"^",2)
        .i (curAdmType'="")&(admType'[curAdmType) q
        .s papmiId=+^PAADM(EpisodeID)
        .s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
        .s ^TMP("NurExec",userId,"Patient",-EpisodeID)=EpisodeID_"^"_patName
    i EpisodeID'="" q 2  //ypz 060726

    i admType'="I" d
        .i regNo'="" d
            ..s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
            ..q:papmiId=""
            ..i admType["O" d  //ypz 060721
            	...s EpisodeID="" //,adjusted=0 //倒序找
            	...f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","O",EpisodeID),-1) q:EpisodeID=""  d  
                	....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
                	....i (pavisit'="A")&(pavisit'="D") q   ;
                	....s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
                	....//i (adjusted=0)&(admDate<fDate) s adjusted=1,fDate=admDate
                	....//s adjusted=1
                	....q:admDate+7<fDate
                	....q:admDate>tDate
                	....s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
                	....//s ^TMPNurOPDebug(EpisodeID,1)=fDate_"/"_admDate
                	....s ^TMP("NurExec",userId,"Patient",-EpisodeID)=EpisodeID_"^"_patName
            ..i admType["E" d
            	...s EpisodeID=""
            	...f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","E",EpisodeID),-1) q:EpisodeID=""  d  
                	....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
                	....i (pavisit'="A")&(pavisit'="D") q   ;
                	....s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
                	....//i (adjusted=0)&(admDate<fDate) s adjusted=1,fDate=admDate
                	....//s adjusted=1
                	....q:admDate+7<fDate
                	....q:admDate>tDate
                	....s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
                	....//s ^TMPNurOPDebug(EpisodeID,1)=fDate_"/"_admDate
                	....s ^TMP("NurExec",userId,"Patient",-EpisodeID)=EpisodeID_"^"_patName
        .i regNo'="" q //有登记号直接退出
        .i locOrWardId="" q  //按病人科室查
        .
        .//ypz 2009-4-14 add
        .s linkLocIdStr=##Class(web.DHCCLCom).GetLinkLocId(locOrWardId)
        .i linkLocIdStr'="" s linkLocIdStr=linkLocIdStr_"^"
        .s linkLocIdStr=linkLocIdStr_locOrWardId
        .s fDate=fDate-7
        .f curDate=fDate:1:tDate d
            ..s EpisodeID=""
            ..f  s EpisodeID=$o(^PAADMi("PAADM_AdmDate",curDate,EpisodeID)) q:EpisodeID=""  d
                ...//q:$p(^PAADM(EpisodeID),"^",2)'=admType
                ...q:admType'[$p(^PAADM(EpisodeID),"^",2)  //ypz 060721
                ...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
                ...i pavisit'="A" q   ;
                ...q:(("^"_linkLocIdStr_"^")'[("^"_$p($g(^PAADM(EpisodeID)),"^",4)_"^"))  //ypz 20090414
                ...s patName=$p($g(^PAPER(+^PAADM(EpisodeID),"ALL")),"^",1)
                ...s ^TMP("NurExec",userId,"Patient",-EpisodeID)=EpisodeID_"^"_patName //为排序
    i admType'="I" q 2 
    i regNo'="" d
        .s papmiId=0 f  s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),papmiId)) q:papmiId=""  d 
            ..s EpisodeID=0 f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","I",EpisodeID)) q:EpisodeID=""  d
                ...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
                ...i pavisit'="A" q  //="D" q   ;xu 04/04/23 Discharged
                ...
                ...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
                ...//s rowid=EpisodeID
                ...s ^TMP("NurExec",userId,"Patient",EpisodeID)=EpisodeID_"^"_patName
    i regNo'="" q 1
    i (locOrWardId'="") d
        .s paroom=0 f  s paroom=$o(^PAADMi("CurrWard",locOrWardId,paroom)) q:paroom=""  d
            ..s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",locOrWardId,paroom,EpisodeID)) q:EpisodeID=""  d
                ...s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
                ...i pavisit'="A" q
                ...s admno=$p($g(^PAADM(EpisodeID)),"^",81)
                ...s papmiId=$p($g(^PAADM(EpisodeID)),"^",1)
                ...s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
                ...s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
                ...s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
                ...s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
                ...s paAdmBedDr=locOrWardId_"||"_bedSub
                ...s bedWarProGroupDr=$O(^DHCWardProGroupBed(0,"PacBedDr",paAdmBedDr,""))
                ...q:(wardProGroupId'="")&(bedWarProGroupDr="")
                ...i bedWarProGroupDr'="" s warProGroupDr=$P($G(^DHCWardProGroupBed(bedWarProGroupDr)),"^",1)
                ...e  s warProGroupDr=""
                ...q:(wardProGroupId'="")&(warProGroupDr'=wardProGroupId)
                ...//&js<alert("#(bedSub)#"+"/bed 1 EpisodeID/"+"#(EpisodeID)#");>
                ...q:bedSub=""
                ...s bedCode=$p($g(^PAWARD(locOrWardId,"BED",bedSub)),"^",1)
                ...q:bedCode="" ;防止床位码表被删
                ...s ^TMP("NurExec",userId,"Patient",bedCode)=EpisodeID_"^"_patName //用床位号好找
    q 2
}

/// 找所有病人
ClassMethod GetAllPatient(userId As %String)
{
    s patStr="",patNum=0
    s bedCode="" f  s bedCode=$o(^TMP("NurExec",userId,"Patient",bedCode)) q:bedCode=""  d
        .s EpisodeID=$p($g(^TMP("NurExec",userId,"Patient",bedCode)),"^",1)
        .s patname=$p($g(^TMP("NurExec",userId,"Patient",bedCode)),"^",2)
        .s patNum=patNum+1
        .s $p(patStr,"^",patNum)=EpisodeID_"!"_patname
    q patStr
}

/// 取执行设置时间
ClassMethod GetExecStTime(oeoriId As %String)
{
    &sql(declare pexst cursor for select oeore_exsttime  from oe_ordexec where oeore_oeori_parref=:oeoriId)
	s timeStr=""
	&sql(open pexst)
	f  &sql(fetch pexst into:execTime)  q:SQLCODE  d
	    .s timeStr=timeStr_","_$zt(+execTime)
	&sql(close pexst)
	q timeStr
}

ClassMethod GetCQOrdTime()
{
	n startTimef,endTimeT 
	k P1
	i $d(^DHCCLNurseExec("CQORD"))'=0  d
	    .s startTimef=$g(^DHCCLNurseExec("CQORD","STARTIME"))
	    .s endTimeT=$g(^DHCCLNurseExec("CQORD","ENDTIME"))
	    .s P1=$zt(+startTimef)_$c(23)_$zt(+endTimeT)
	e  d
	    .s startTimef="23:00:00"
	    .s endTimeT="02:00:59"
	    .s P1=startTimef_$c(23)_endTimeT
	q P1
}

/// 取病人社会地位(医保)
ClassMethod GetPatMedicare(EpisodeID As %String)
{
    s papersonId=$p($g(^PAADM($g(EpisodeID))),"^",1)
	q:$g(papersonId)="" ""
	s SocialStatus=$p($g(^PAPER($g(papersonId),"PER",1)),"^",10)
	q:$g(SocialStatus)="" ""
	s SocialDESC=$p($g(^CT("SS",SocialStatus)),"^",2)
	q $g(SocialDESC)
}

ClassMethod GetLoc(oeoriId)
{
	n (oeoriId)
	s oeordId=+oeoriId
	s oeoriSub=$p(oeoriId,"||",2)
    s EpisodeID=$p($g(^OEORD(oeordId)),"^",1)
	s ctlocId=$p(^PAADM(EpisodeID),"^",4)
	s userId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    ;w !,userId
	q:userId="" ""
	q:'$d(^SSU("SSUSR",userId)) ""
	s ctpcpId=$p(^SSU("SSUSR",userId),"^",14)
	q:ctpcpId="" "" ;s Notes=$g(^OEORD(Oew,"I", OrdSub,"DEP",1))

	q:'$d(^CTPCP(ctpcpId,1)) ""
	s ctpctId=$p(^CTPCP(ctpcpId,1),"^",4)
	i ctpctId'="" s ctpctIType=$p($g(^CT("CPT",ctpctId)),"^",4)
	s locId="" f  s locId=$o(^RB("RES",0,"CTPCP",ctpcpId,locId)) q:(locId="")!(locId=ctlocId)  d
	q locId //_"^"_ctpctIType
}

Query FindOrditem(wardId As %String, regNo As %String, userId As %String, startDate As %String, endDate As %String, queryTypeCode As %String, gap As %String, locId As %String, admType As %String, exeFlag As %String, HospitalRowId As %String, HOSPID As %String = "") As %Query(ROWSPEC = "prtFlag,regNo,bedCode,patName,patIdentity,age,orcatDesc,seqNo,arcimDesc,oecprDesc,ordStatDesc,labNo,doseQtyUnit,phcfrCode,phOrdQtyUnit,phcinDesc,notes,execStat,execDateTime,execCtcpDesc,ctcpDesc,disposeStatDesc,reclocDesc,sttDateTime,xDateTime,execXUserDesc,prescNo,price,totalAmount,execXDateTime,xCtcpDesc,createDateTime,oeoriId,placerCode,disposeStatCode,tmpPrtFlag,Durat,placerNo,skinTestDateTime,EpisodeID,specDesc,tmpSeqNo,EncryptLevel,PatLevel,specCollDateTime")
{
}

ClassMethod FindOrditemExecute(ByRef qHandle As %Binary, wardId As %String, regNo As %String, userId As %String, startDate As %String, endDate As %String, queryTypeCode As %String, gap As %String, locId As %String, admType As %String, exeFlag As %String, HospitalRowId As %String, HOSPID As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	
 	//s wardId=$p(wardId,"|",1)
 	//s locId=$p(wardId,"|",2)
 	//s queryTypeCode="Default"  ##class(%ResultSet).RunQuery("web.DHCNurCom","FindOrditem","","0000002852","10211","65297","65297","SYDO","","","OE","0","0","2")
 	s ^TEMPSC("FindOrditem")=$lb(wardId, regNo , userId , startDate , endDate , queryTypeCode , gap , locId , admType , exeFlag, HospitalRowId, HOSPID)
 	//w wardId,"/",regNo,"/",userId,"/",startDate,"/",endDate,"/",queryTypeCode,"/",gap,"/",locId,"/",admType,"/",exeFlag,!
 	i userId=""  s qHandle=$lb(0,repid,0) q $$$OK
 	//ypz 060302 begin
 	i queryTypeCode="",HospitalRowId="" q // s queryTypeCode="Default"
 	s curRegNo=$p(regNo,"^",1) //ypz 060728
 	i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug("date")=startDate_"/"_endDate
 	s EpisodeID=$p(regNo,"^",2)
 	s EpisodeID=""
 	i EpisodeID'="" s startDate=$p($g(^PAADM(EpisodeID)),"^",6)
 	i (admType'="I")&(regNo'="")&(EpisodeID="") d   //ypz 060702
 	    .s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
        .q:papmiId=""
        .s minDate=startDate
        .i admType["O" d
        	..s EpisodeID=""  //ypz 060718
        	..f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","O",EpisodeID),-1) q:EpisodeID=""  d
        		...i EpisodeID'="" d 
        			....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
        			....i pavisit'="A" q   ;
        			....s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
        			....s EpisodeID=0
        			....i minDate>admDate s minDate=admDate
        .i admType["E" d
        	..s EpisodeID=""
        	..f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","E",EpisodeID),-1) q:EpisodeID=""  d
        		...i EpisodeID'="" d 
        			....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
        			....i pavisit'="A" q   ;
        			....s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
        			....s EpisodeID=0
        			....i minDate>admDate s minDate=admDate
        .i minDate<startDate s startDate=minDate
	i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug("date")=^TMPNurOPDebug("date")_" afterAdm: "_startDate_"/"_endDate
     /*	i (admType'="I")&(regNo'="") d   //ypz 060702
 	    .s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
        .q:papmiId=""
        .s EpisodeID=$o(^PAPERdr(papmiId,"ADM",admType,""),-1)
        .q:EpisodeID=""  
        .s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
        .i pavisit'="A" q   ;
        .s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
        .i (admDate<startDate) s startDate=admDate	*/

    i admType'="I" s retStr=..FindPatient(locId,regNo,userId,admType,startDate,endDate) 
 	i admType="I" s retStr=..FindPatient(wardId,regNo,userId,admType,startDate,endDate) 
    //ypz 060302 end
    ////s a=##CLASS(web.udhcclnurseexec).FindPatient(wardId,regNo,userId) //ypz 060302
    ///////s patstr=##CLASS(web.udhcclnurseexec).GetAllPatient(userId)//ypz 060302
    s patstr=..GetAllPatient(userId)
    //w "patstr="_patstr,!
    s num=$l(patstr,"^")
    i patstr="" s num=0 //ypz 070108
    s varStr=$G(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"VarId"))
    q:varStr=""
    s varCount=$l(varStr,"^") ;对应项
    //s ^mtemp("query")=1
    s varId=0 ;初始化全部变量值  //不可与上面的部分合并:看是否在^varStr^中!!
    f  s varId=$o(^DHCCLNurseExec("Var",varId)) q:varId=""  d
        .s varName=$p(^DHCCLNurseExec("Var",varId),"^",2)
        .s data(varName)=""
    s seqCount=0
    f i=1:1:num
    {
     	s pat=$p(patstr,"^",i)
     	s EpisodeID=$p(pat,"!",1)
     	q:EpisodeID=""
     	s PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
    	s EncryptLevel=$p(PatEncryptLevel,"^",1)
    	s PatLevel=$p(PatEncryptLevel,"^",2) 
     	i $g(^TMPNurOPDebug)="Y" k ^TMPNurOPDebug(EpisodeID)
     	s lisnum=..GetOrderItem("","",EpisodeID,startDate,endDate,userId,wardId,queryTypeCode,gap,locId,exeFlag,HospitalRowId,HOSPID)
     	i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID)=lisnum
     	//w EpisodeID," ",startDate," ",endDate," ",userId," ",wardId," ",queryTypeCode," gap=",gap," ",locId," num=",lisnum," ",exeFlag,"/",!
     	f j=1:1:lisnum
     	{
	        s ordstr=..GetData("","",j)
	        f ivar=1:1:varCount 
	        {
		        s varName=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",2)
                s data(varName)=$p(ordstr,"!",ivar)
            } 
            s oeoriId=$p(ordstr,"!",ivar+1)
            //s arcicId=$p(ordstr,"!",ivar+2) // 
            s placerCode=$p(ordstr,"!",ivar+2) // 
            s disposeStatCode=$p(ordstr,"!",ivar+3)
            s tmpPrtFlag=$p(ordstr,"!",ivar+4)
            
            s oeordId=$P(oeoriId,"||",1),oeoriSub=$P(oeoriId,"||",2),oeoreSub=$P(oeoriId,"||",3)
			s tmpSeqNo=..getflag(oeoriId)
			i oeoreSub="" s oeoreSub=0
			s ordLoc=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
			s OrderDep=""
			i ordLoc'="" s OrderDep=$p(^CTLOC(ordLoc),"^",2)
			//s ^Temp("wanghc",oeoriSub)=oeordId_"||"_oeoriSub
			
			s abnInfo=##class(ABN.dao.DHCDocAllergyInterface).GetSkinInfo(oeordId_"||"_oeoriSub)
			i +abnInfo'=0 d
			.s abnId=$p(abnInfo,"^",1)
			.s abnType=$p(abnInfo,"^",3)
			.q:$g(abn(abnId,abnType))'=""
			.s abn(abnId,abnType)=abnInfo
			.s data("arcimDesc")=$p(abnInfo,"^",2)
			.s oeoriId=abnId_"^"_abnType
			.d OutRow
			continue:+abnInfo'=0
			i oeordId'="",oeoriSub'="" d
			.s subflag=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
    		.i subflag="" d
    		..i oeoreSub="" s oeoreSub=0
    		..s ^TMP("NurExecOrderAttach",userId,EpisodeID,oeordId,oeoriSub,oeoreSub)=""
            s seqCount = seqCount+1
            s data("seqNo") = seqCount
            d OutRow
	    }
	}
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutRow
	s Data=$lb(data("prtFlag"),data("regNo"),data("bedCode"),data("patName"),data("patIdentity"),data("age"),data("orcatDesc"),data("seqNo"),data("arcimDesc"),data("oecprDesc"),data("ordStatDesc"),data("labNo"),data("doseQtyUnit"),data("phcfrCode"),data("phOrdQtyUnit"),data("phcinDesc"),data("notes"),data("execStat"),data("execDateTime"),data("execCtcpDesc"),data("ctcpDesc"),data("disposeStatDesc"),data("reclocDesc"),data("sttDateTime"),data("xDateTime"),data("execXUserDesc"),data("prescNo"),data("price"),data("totalAmount"),data("execXDateTime"),data("xCtcpDesc"),data("createDateTime"),oeoriId,placerCode,disposeStatCode,tmpPrtFlag,data("Durat"),data("placerNo"),data("skinTestDateTime"),EpisodeID,data("specDesc"),tmpSeqNo,EncryptLevel,PatLevel,data("specCollDateTime"))
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindOrditemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrditemExecute ]
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

ClassMethod FindOrditemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrditemExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// 按指定项取病人或病区(科室)的医嘱
ClassMethod GetOrderItem(itmjs As %Library.String = "", itmjsex As %Library.String = "", EpisodeID As %String, fDateStr As %String, tDateStr As %String, userId As %String, wardId As %String, queryTypeCode As %String, gap As %String, locId As %String, exeFlag As %String, HospitalRowId As %String, HOSPID As %String = "")
{
  	//d ##Class(web.DHCLCNUREXCUTE).GetOrderItem("","",11,"","",1,89,"Default","")
    //n (EpisodeID, fDateStr, tDateStr, userId, wardId, queryTypeCode, gap)
    i EpisodeID="" q -2
    i queryTypeCode="",HospitalRowId="" q -1
    s admType=$p(^PAADM(EpisodeID),"^",2) //ypz 060302
    q:admType="" -3 //ypz 060302
    //s wardId=$p(wardId,"|",1)
    //s locId=$p(wardId,"|",2)
    
    k ^TMP($j,"NurseExec"),^TMP($j,"NurseExecSeqNoSort"),^TMP($j,"NurseExecGroup"),tPos,val
    s num=0
    d ..GetPatLoc(EpisodeID)
    s varStr=$G(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"VarId"))
    q:varStr="" -1
    s varCount=$l(varStr,"^") ;对应项
    f ivar=1:1:varCount d 
        .s varName=$p(^DHCCLNurseExec("Var",$p(varStr,"^",ivar)),"^",2)
        .s tPos(varName)=ivar
    
    s varId=0 ;初始化全部变量值  //不可与上面的部分合并:看是否在^varStr^中!!
    f  s varId=$o(^DHCCLNurseExec("Var",varId)) q:varId=""  d
        .s varName=$p(^DHCCLNurseExec("Var",varId),"^",2)
        .s val(varName)=""
        .//i ("^"_varStr_"^")[("^"_varId_"^") s tPos(varName)=varId
    
    s patOrder=$p(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode),"^",3)
    
    n MidCQtime,startTimef,endTimeT 
    s today=$p($h,",",1)  
    s fromDate=+fDateStr 
    i $l(fDateStr,"/")=3 s fromDate=$$$zdh(fDateStr,4)
    i fDateStr="" s fromDate=+$h
    s toDate=+tDateStr
    i $l(tDateStr,"/")=3 s toDate=$$$zdh(tDateStr,4)
    i tDateStr="" s toDate=+$h
    i fromDate>toDate q -3
    //ypz 061115
    s STime=$g(^TMP("NurExec",userId,"TimeStart"))
    i STime="" s STime=0
    s ETime=$g(^TMP("NurExec",userId,"TimeEnd"))
    i ETime="" s ETime=86400
    s MidCQtime=..GetCQOrdTime()
    s startTimef=$p(MidCQtime,$c(23),1),startTimef=$zth(startTimef,3)
    s endTimeT=$p(MidCQtime,$c(23),2),endTimeT=$zth(endTimeT,3)
    i gap'="" d   ;是否是自动刷新查询
        .s STime=$zth(gap,3),fromDate=today,ETime=86400,toDate=today
    s SDT=fromDate_","_STime
    s EDT=toDate_","_ETime
    ////s oecatIdStr=$g(^TMP("NurExec",userId,"OECat"))_"^"
    ////s oecprIdStr=$g(^TMP("NurExec",userId,"OEPriority"))_"^"
    ////s ordStatIdStr=$g(^TMP("NurExec",userId,"OrderStatus"))_"^"
    ////s phcinIdStr=$g(^TMP("NurExec",userId,"Instruc"))_"^"
    //s disposeStatCodeStr="^"_..GetDisposeStatCode($g(^DHCCLNurseExec("VarDef",queryTypeCode,"DisposeStat")))_"^"
    s oecatIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"OrCat"))_"^"
    s oecprIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"OecPr"))_"^"
    s ordStatIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"OrdStat"))_"^"
    s phcinIdStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"PhcIn"))_"^"
    s specCodeStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"Spec"))_"^"
    s recLocStr="^"_$g(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"RecLoc"))_"^"
    
    //取新产品组单据配置 fengliang
    s ExecFormID = ##Class(Nur.OPPDA.Inject).GetExecFormID(queryTypeCode)
	q:+ExecFormID=0 "未找到单据"
	//下面是单据对应的查询范围
	s oecatIdStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecCat")_"#" //医嘱分类
    s oecprIdStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecPro")_"#" //优先级
    s ordStatIdStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecStat")_"#" //医嘱状态
    s phcinIdStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecPhi")_"#"  //用药途径
    s specCodeStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecSpec")_"#"  //
    s recLocStr="#"_##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecRecLoc")_"#" //接收科室
	
    s oecatIdStr=$replace(oecatIdStr,"#","^")
    s oecprIdStr=$replace(oecprIdStr,"#","^")
    s ordStatIdStr=$replace(ordStatIdStr,"#","^")
    s phcinIdStr=$replace(phcinIdStr,"#","^")
    s specCodeStr=$replace(specCodeStr,"#","^")
    s recLocStr=$replace(recLocStr,"#","^")
    //end
    
    
    //&js<alert("here out order "+"#(ordStatIdStr)#"+" admid="+"#(EpisodeID)#");>
    s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
    
    //s AmtReult=##class(web.DHCSTPCHCOLLS2).IFGivePHC(EpisodeID,curWardId,0) //0819
    //w "AmtReult=",AmtReult,!
    ////s ^DHCTTTT=EpisodeID_"|"_curWardId_"|"_$g(AmtReult)
     //AmtReult=-1 欠费； 1不欠费；
    k ^AMT
    s ^AMT($j,"lackofFee")=$g(AmtReult)
    s ^AMT($j)=EpisodeID_" "_curWardId
    s oeordId=0 f  s oeordId=$o(^OEORD(0,"Adm",EpisodeID,oeordId)) q:oeordId=""  d
        .//&js<alert("here in order "+"#(EpisodeID)#"+"/"+"#(oeordId)#");>
        .s oeoriSub=0 f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
         ..////i wardId="" s wardId=$p($g(^PAADM(EpisodeID)),"^",70)  //YPZ 050628
            ..////i wardId="" q
            ..//s ^mtemp(oeordId)=AmtReult
            ..//s oeoriId=oeordId_"||"_oeoriSub
            ..//s res=..Getdocloc(EpisodeID,oeordId,oeoriSub)
            ..//q:res="N"
            ..q:'$d(^OEORD(oeordId,"I",oeoriSub,1))
            ..s OrdDepId = $p(^OEORD(oeordId,"I",oeoriSub,1),"^",3)
            ..i OrdDepId'="" s OrdHospId = $p($g(^CTLOC(OrdDepId)),"^",22)
            ..s CurHospId = OrdHospId
            ..i HOSPID'="" s CurHospId = HOSPID ;$p($g(^SSU("SSUSR",userId)),"^",98)
            ..q:CurHospId'=OrdHospId
            ..i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub)="/1"
            ..i (admType'="I")&($p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",32)="Y") q //退药不执行 ypz 060615
            ..s docloc=..GetLoc(oeordId_"||"_oeoriSub)
            ..//s ^DDD(oeordId,oeoriSub)=docloc_"|"_locId
            ..//s ^DDD(oeordId,oeoriSub)=docloc  //_"|"_locId
            ..//皮试标志
            ..s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
            ..i (admType="I")&($g(docloc)'=$g(locId))&($g(locId)'="") q //住院转科ypz 060302
            ..//q:((admType'="I")&($p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)'="P")&(skinTestFlag'="Y")) //非住院未交费的皮试病人YPZ
            ..s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
            ..i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub)="/2"
            ..q:(admType'="I")&(oeoriBilled'="B")&(oeoriBilled'="TB")&(oeoriBilled'="P") //非住院的有医嘱
            ..s flag=0
            ..s OrdRecDepId=$P($G(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
            ..q:(OrdRecDepId'=locId)&(locId'="")
            ..s ordstat=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
	        ..q:(ordstat="D")!(ordstat="U")!(ordstat="C")&(oeoriBilled'="P")
            ..s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)   //keep duplicate
            ..s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)  //keep duplicate
            ..s omitUnPaidDay=$g(^DHCCLSet("Exec","OmitUnPaidDay"))
            ..i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub)="/3"
            ..q:(omitUnPaidDay>0)&(admType="O")&(oeoriBilled'="P")&($h-sttDate>omitUnPaidDay)
            ..s orddate1=sttDate,ordtime1=sttTime
            ..s oeoriDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
            ..s oeoriTimeOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
            ..i gap'="" d   ;是否是自动刷新查询
                ...s orddate1=oeoriDate,ordtime1=oeoriTimeOrd
            ..;;s ordDT=oeoriDate_","_oeoriTimeOrd
            ..//s usrdat=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",3)
            ..i gap="" d
                ...; for  (orddate1=fromDate)&(ordtime1>STime)    "">1 'xuqy 2005-02-03
                ...i ((orddate1>fromDate)&(orddate1<toDate))!((orddate1=fromDate)&(ordtime1'<STime))!((orddate1=toDate)&(ordtime1<ETime)) s flag=1
                ...;i ((oeoriDate>fromDate)&(oeoriDate<toDate))!((oeoriDate=fromDate)&(oeoriTimeOrd>STime))!((oeoriDate=toDate)&(oeoriTimeOrd<ETime)) s flag=1
            ..i gap'="" d
                ...i ((orddate1=fromDate)&(ordtime1>STime))&((orddate1=toDate)&(ordtime1<ETime)) s flag=1
                ...;i ((oeoriDate=fromDate)&(oeoriTimeOrd>STime))&((oeoriDate=toDate)&(ordtime1<ETime)) s flag=1
            ..i (flag=0)&(admType="I") q  //qse20060324
            ..s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
            ..s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
            ..&sql(select arcim_desc,ARCIM_ItemCat_DR,ARCIM_BillingUOM_Dr into :val("arcimDesc"),:arcicId,:packUomId from arc_itmmast where arcim_rowid=:arcimId)
            ..i arcicId'="" s arcicId=+arcicId,orcatId=$p($g(^ARC("IC",arcicId)),"^",8) 
            ..s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
            ..s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) ;OEORI_Instr_DR
            ..i (ordStatIdStr'[("^"_ordStatId_"^"))&(ordStatId'="") q
            ..i (oecprIdStr'[("^"_oecprId_"^"))&(oecprId'="") q
            ..i (phcinIdStr'[("^"_phcinId_"^"))&(phcinId'="") q
            ..s SubCatFlag=$g(^DHCCLSet("Exec","OrderSubCat"))
            ..i (SubCatFlag'="Y")&(oecatIdStr'[("^"_orcatId_"^"))&(orcatId'="") q
            ..i (SubCatFlag="Y")&(oecatIdStr'[("^"_arcicId_"^"))&(arcicId'="") q
            ..s specCode=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^")
            ..i (specCodeStr'[("^"_specCode_"^"))&(specCode'="") q
            ..s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
            ..i (recLocStr'[("^"_reclocId_"^"))&(reclocId'="") q
            ..s specCode=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^")
            ..i (specCodeStr'[("^"_specCode_"^"))&(specCode'="") q
            ..i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub)="/4"
            ..s rStr=..GetOrderItemSingle(EpisodeID,wardId,oeordId,oeoriSub,queryTypeCode,.val,.tPos,fromDate,toDate,exeFlag,HospitalRowId)
           
    //ypz 060617 begin
    s groupOriId=""
    f  s groupOriId=$o(^TMP($j,"NurseExecGroup",groupOriId)) q:groupOriId=""  d 
        .s tmpDateTime=""
        .f  s tmpDateTime=$o(^TMP($j,"NurseExecGroup",groupOriId,tmpDateTime)) q:tmpDateTime=""  d 
            ..s sortOriSub=""
            ..f  s sortOriSub=$o(^TMP($j,"NurseExecGroup",groupOriId,tmpDateTime,sortOriSub)) q:sortOriSub=""  d 
                ...s ^TMP($j,"NurseExec",0)=$g(^TMP($j,"NurseExec",0))+1
                ...s ^TMP($j,"NurseExec",^TMP($j,"NurseExec",0))=^TMP($j,"NurseExecGroup",groupOriId,tmpDateTime,sortOriSub)
    //m ^TMPNurOPDebug(1000+$g(^TMPNurOPDebug(0)),1)=^TMP($j,"NurseExecGroup")
    //m ^TMPNurOPDebug(1000+$g(^TMPNurOPDebug(0)),2)=^TMP($j,"NurseExec")
    k ^TMP($j,"NurseExecGroup")
    
    //ypz 060617 end

    i admType'="I" q +$g(^TMP($j,"NurseExec",0))
    i patOrder="Y" d  //按病人排序赋值
        .q:$d(^TMP($j,"NurseExecSeqNoSort"))<2
        .s EpisodeID=""
        .f  s EpisodeID=$o(^TMP($j,"NurseExecSeqNoSort",EpisodeID)) q:EpisodeID=""  d
            ..s sttDate=""
            ..f  s sttDate=$o(^TMP($j,"NurseExecSeqNoSort",EpisodeID,sttDate)) q:sttDate=""  d
            ...s seqNo=""
            ...f  s seqNo=$o(^TMP($j,"NurseExecSeqNoSort",EpisodeID,sttDate,seqNo)) q:seqNo=""  d
            ....s sq=""
            ....f  s sq=$o(^TMP($j,"NurseExecSeqNoSort",EpisodeID,sttDate,seqNo,sq)) q:sq=""  d
            .....s num=num+1,^TMP($j,"NurseExec",num)=^TMP($j,"NurseExecSeqNoSort",EpisodeID,sttDate,seqNo,sq)
            
      s retval=itmjs_"('"_$ZCVT(num,"O","JS")_"');"
      i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(num,"O","JS")_"');"
    
    // &javascript<#(retval)#>

    q +$g(^TMP($j,"NurseExec",0))
}

/// 排序成组医嘱
ClassMethod sortTemp()
{
	s oeoriID=""
    f  s oeoriID=$o(^TMP($j,"NurseExecGroup",oeoriID)) q:oeoriID=""  d 
    .s oeordID=+oeoriID
    .s ordSeqID=$p($g(^OEORD(oeordID,"I",oeoriSub,11)),"^",39)
	.s tmpDateTime=""	
	.f  s tmpDateTime=$o(^TMP($j,"NurseExecGroup",groupOriId,tmpDateTime)) q:tmpDateTime=""  d 
	..s sortOriSub=""
	..f  s sortOriSub=$o(^TMP($j,"NurseExecGroup",groupOriId,tmpDateTime,sortOriSub)) q:sortOriSub=""  d
}

/// 按指定项取病人的一条医嘱内容
ClassMethod GetOrderItemSingle(EpisodeID, wardId, oeordId, oeoriSub, queryTypeCode, val, tPos, FrDate, ToDate, exeFlag, HospitalRowId)
{
	//wardId对住院病人为病区,门诊病人为科室
    n (EpisodeID, wardId, oeordId, oeoriSub, queryTypeCode, val, tPos,FrDate, ToDate, exeFlag, HospitalRowId)
    s curWardId=wardId
    //s ^HHH=wardId
    i curWardId="" s curWardId=$p($g(^PAADM(EpisodeID)),"^",70)
    s admType=$p($g(^PAADM(EpisodeID)),"^",2) //ypz 060302  
    i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub)="/11"
    i admType="" q "" //ypz 060302
    i (admType="I")&(curWardId="") q ""  //ypz 060302
    //&js<alert("sigle  "+"#(EpisodeID)#"+"/"+"#(tPos("patName"))#"+"/"+"#(queryTypeCode)#");>
    //s OecprImmed="即刻"  ;"Routine"  ;;;
    //s OecprTemp="临时"
    //s OecprLong="长期"
    //s ordStatVerf="核实"  ;"Verified" ;;
    //s ordStatDiscon="停止" ;;"D/C (Discontinued)"  ;;
    //s OecprQuyao="取药"
    //s OecprNoFee="自备药"
    
    s unitUomId="",usrdat="",unitDesc="",execDate="",arcicId="",orcatId=""
    s pmark="N",execXDate="",execXTime="",packUomId=""    
	
    s oeoriId=oeordId_"||"_oeoriSub
    s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)   //keep duplicate
    s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)  //keep duplicate
    s bedSub=$p($p($g(^PAADM(EpisodeID)),"^",73),"||",2)
    i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub)="/12"
    i (admType="I")&(bedSub="") q "" //ypz  060302

    s oeoriDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
    s oeoriTimeOrd=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
    
    s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    &sql(select arcim_desc,ARCIM_ItemCat_DR,ARCIM_BillingUOM_Dr into :val("arcimDesc"),:arcicId,:packUomId from arc_itmmast where arcim_rowid=:arcimId)
    s newInspect="" //##Class(web.DHCEMInterface).GetExaReqItemDesc(oeordId_"||"_oeoriSub)
    i newInspect'="" d
    .s val("arcimDesc")= newInspect
    i arcicId'="" s arcicId=+arcicId,orcatId=$p($g(^ARC("IC",arcicId)),"^",8) 
    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) ;OEORI_Instr_DR
    s usrdat=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",3)

    s disposeStatCodeStr="^"_..GetDisposeStatCode($g(^DHCCLNurseExec("VarDef",HospitalRowId,queryTypeCode,"DisposeStat")))_"^"
    //&js<alert("here out Id "+"#(disposeStatCodeStr)#");>
    
    //取新产品组单据配置 fenlgiang 2020-07-09
    s ExecFormID = ##Class(Nur.OPPDA.Inject).GetExecFormID(queryTypeCode)
    s disposeStatCodeStr="#"_##Class(web.DHCEMNurExe).GetDisposeStatCode(##Class(web.DHCEMNurExe).GetExecFormItmValue(ExecFormID,"ExecDis"))_"#" 	//处置状态
	s disposeStatCodeStr=$replace(disposeStatCodeStr,"#","^")
    //end
    
    
    s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId)
    i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub)="/13"
    q:oecprCode="" 0    
    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)  //070204
    
    i ordStatId'="" s val("ordStatDesc")=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
    i oecprId'="" s val("oecprDesc")=$p($g(^OECPR(oecprId)),"^",2)
    i phcinId'="" s val("phcinDesc")=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s:##class(Nur.CommonInterface.Order).ifPhcinSkinTest(oeordId,oeoriSub)=1 skinTestFlag="Y"
    s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
    //ypz 06128 begin
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode="",actDesc=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
    i actDesc'="" s val("arcimDesc")=val("arcimDesc")_"(皮试:"_actDesc_")"
    //ypz 06128
    i ((skinTestFlag="Y")!(actCode="YY"))&(abnorm'="N")  s val("phcinDesc")=val("phcinDesc")_"(皮试"_actDesc_")"  //ypz rem 061128
    //s val("seqNo")=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",4)
    s val("seqNo")=oeoriSub  //ypz 060619
    s seqNochl=val("seqNo")
    s val("labNo")=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
    s val("packUomQty")=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)
    s packUomId=+packUomId,val("packUomDesc")=""  //ypz 060903
    i (packUomId'=0)&(val("packUomQty")'="") d 
        .s val("packUomDesc")=$p(^CT("UOM",packUomId),"^",2)
    s dipUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",13)
    i (+dipUomId)'=0 s val("packUomDesc")=$p($g(^CT("UOM",dipUomId)),"^",2)
    
    s val("notes")=$g(^OEORD(oeordId,"I",oeoriSub,"DEP",1))_" "_$g(^OEORD(oeordId,"I",oeoriSub,"DEP",2))_$g(^OEORD(oeordId,"I",oeoriSub,"DEP",3))_$g(^OEORD(oeordId,"I",oeoriSub,"DEP",4))_" "_$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",8)                    ;xuqy 04/08/04
    //s ctcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",11)  //ypz rem 060620
    s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)  //ypz 060620
    s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    i ctcpId'="" s val("ctcpDesc")=$p($g(^CTPCP(ctcpId,1)),"^",2)
    s val("ctcpDesc")=$p(^SSU("SSUSR",+userAddId),"^",2)
    i (val("ctcpDesc")="")&(ctcpId'="") s val("ctcpDesc")=$p($g(^CTPCP(ctcpId,8)),"^",12)  ////????
    ////s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
    s papmiId=+^PAADM($p($g(^OEORD(oeordId)),"^",1))
    s val("regNo")=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
    s val("patName")=$p($g(^PAPER(papmiId,"ALL")),"^",1)
    s val("patIdentity")=..GetPatMedicare(EpisodeID)
    s sex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
    s birth=$p($g(^PAPER(papmiId,"ALL")),"^",6)
    s val("age")=##class(web.DHCBillInterface).GetPapmiAge(papmiId,EpisodeID)
    s roomId=$p(^PAADM($p($g(^OEORD(oeordId)),"^",1)),"^",69)
    i (roomId'="") s room=$p(^PAROOM(roomId),"^",2)
    //&js<alert("come in oeore else "+"#(curWardId)#"+"/"+"#(EpisodeID)#"+"/");>
    i admType="I" s val("bedCode")=$g(room)_"-"_$p($g(^PAWARD(curWardId,"BED",bedSub)),"^",1)
    i orcatId'="" s val("orcatDesc")=$p($g(^OEC("ORCAT",orcatId)),"^",2)
    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    i reclocId'="" s val("reclocDesc")=$p($g(^CTLOC(reclocId)),"^",2)
    s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
    i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
    i (doseQty'="")&(unitDesc'="") s val("doseQtyUnit")=doseQty_" "_unitDesc
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    i phcfrId'="" s val("phcfrCode")=$p($g(^PHCFR(phcfrId)),"^",3) //ypz 070418 统一取
    i phcfrId'="" d
	. s WeekFlag=$P(^PHCFR(phcfrId),"^",9)
	. i WeekFlag="Y" d
	. . s OrderFreqWeek=$p($g(^OEORD(+oeordId,"I",oeoriSub,"DHC")),"^",55)
	. . s val("phcfrCode")=val("phcfrCode")_" "_$TR(OrderFreqWeek,"|","")
    s val("prescNo")=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
    s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
    i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
    //i (phOrdQty'="")&(unitDesc'="") s val("phOrdQtyUnit")=phOrdQty_" "_unitDesc
   i val("packUomQty")'=""  s val("phOrdQtyUnit")=val("packUomQty")_" "_$g(val("packUomDesc")) 
     i (phOrdQty'="") s val("phOrdQtyUnit")=phOrdQty_" "_unitDesc
    
    //ypz 070428 rem//i val("oecprDesc")[OecprTemp d
    s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25)
    
    ;i $zabs(oeoriPrice)<0.00001 s OrdPaid=1   // 0计费医嘱让执行打印 + wxl 090301
    ;e  s OrdPaid=0
    s OrdPaid=0
    
    //ypz 070914//s val("totalAmount")=phOrdQty*val("price")
    //i +doseQty'=0 s val("totalAmount")=$fn(val("totalAmount")/doseQty,"",2)
    //ypz 070914//i val("packUomQty")'="" s val("totalAmount")=val("packUomQty")*val("price")
    s xDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",34)
    ;;i xDate'="" s xDate=$zd(xDate,3)
    s xTime=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",15)
    ;;i xTime'="" s xTime=$zt(+xTime)
    s xCtcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",29)
    i xCtcpId'="" d
        .s val("xCtcpDesc")=$p($g(^CTPCP(xCtcpId,1)),"^",3)
    e  d  //从子表中加入停医嘱人,ypz 060705
        .i xDate'="" d
            ..s ordStatSub=^OEORD(oeordId,"I",oeoriSub,"ST",0)
            ..s ordStatStr=^OEORD(oeordId,"I",oeoriSub,"ST",ordStatSub)
            ..i $p(^OEC("OSTAT",$p(ordStatStr,"^",3)),"^",1)="D" d
                ...s xUserId=$p(ordStatStr,"^",4) //??
                ...s xCtcpId=$p(^SSU("SSUSR",+xUserId),"^",14)
    			...i xCtcpId'="" s val("xCtcpDesc")=$p($g(^CTPCP(xCtcpId,1)),"^",2)
    s SeqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39) //OEORI_OEORI_DR qshe add 05-08-22
    i SeqNo'="",$d(^OEORDi(0,"OEORI",oeordId,SeqNo,oeoriSub))<1 s ^OEORDi(0,"OEORI",oeordId,SeqNo,oeoriSub)=""  //ypz 07121
    i SeqNo'="" d
    	.s val("arcimDesc")="____"_val("arcimDesc")  //_$p(SeqNo,"||",2) ypz 060617 val("arcimDesc")="____"_sortOriSub_val("arcimDesc")
    s sortOriSub=oeoriSub
    s groupOriId=SeqNo
    i groupOriId="" s groupOriId=oeoriId,sortOriSub=0  //主医嘱
    i $d(^OEORD(oeordId,"I",oeoriSub,2)) s durationId=$p(^OEORD(oeordId,"I",oeoriSub,2),"^",6)
    i $g(durationId)'="" s durat=$p($g(^PHCDU(durationId)),"^",3)  //持续周期 Oeori_Durat_Dr-->PHC_Duration
    //s ^FF(oeordId,"I",oeoriSub)=$g(durat)
    s val("Durat")=$g(durat)
    s val("placerNo")=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",36)
    s discon="" //$g(^DHCCLNurseExec("DISCON","OrdItem",oeoriId))
    s exsttime=..GetExecStTime(oeoriId) ///??未用?
    ;s nurseSign="  "
    i (admType="I")&($g(^AMT($j,"lackofFee"))=-1) s disposeStatCode="LackOfFee"  ;要执行的医嘱
    e  s disposeStatCode="Needless"
    ;&(orcatId'=90)&(orcatId'=79)  90 护士计费　　材料  (val("execCtcpDesc")'="" 则执行过）
    ////i (val("oecprDesc")[OecprImmed)&(val("ordStatDesc")[ordStatVerf)&(orcatId'=90)&(orcatId'=79)&(val("execCtcpDesc")="") s disposeStatCode="Y"  ;要执行的医嘱
    i (oecprCode="STAT")&((ordStatCode="V")!(ordStatCode="E"))&(val("execCtcpDesc")="") d
    .i (admType="I")&($g(^AMT($j,"lackofFee"))=-1) s disposeStatCode="LackOfFee"  ;要执行的医嘱
    .e  s disposeStatCode="Immediate"  ;要执行的医嘱
    ;i (val("oecprDesc")[OecprLong)&(val("ordStatDesc")[ordStatVerf)  s disposeStatCode="M" 新开长嘱^M  需执行即刻^Y
    i ((oecprCode="S")!(oecprCode="OMST"))&(ordStatCode="V")  d  ;xuqy 2005-02-03不需处理^P  需处理检验^B
	    .s fillerno=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)  ;Oeori_Fillerno      临时需执行^S  需处理停止医嘱^X
	    .i fillerno="" d
	    ..i (admType="I")&($g(^AMT($j,"lackofFee"))=-1) s disposeStatCode="LackOfFee"  ;要执行的医嘱
        ..e  s disposeStatCode="LongNew"  ;要执行的医嘱                                已执行或处理^A 已处理停止医嘱^C        
        .; "23:59:59"=86399                                                              欠费^L
        .;i (endTimeT>startTimef)&(endTimeT'>86399)&((oeoriTimeOrd<startTimef)!(oeoriTimeOrd>endTimeT))  d
        .;.s disposeStatCode="M"  ;要执行的医嘱
        .;i (endTimeT<startTimef)&(oeoriTimeOrd>endTimeT)&(oeoriTimeOrd<startTimef)  d
        .;.s disposeStatCode="M"  ;要执行的医嘱
    ;i (val("oecprDesc")[OecprImmed)&(val("ordStatDesc")[ordStatVerf)&(val("orcatDesc")="检验")&(val("execCtcpDesc")="") s disposeStatCode="B"  ;要执行的医嘱
    i (oecprCode="STAT")&(ordStatCode'="D")&(val("orcatDesc")["检验")&(val("execCtcpDesc")="") d
    .i (admType="I")&($g(^AMT($j,"lackofFee"))=-1) s disposeStatCode="LackOfFee"  ;要执行的医嘱
    .e  s disposeStatCode="TempTest" 
    ////i (val("oecprDesc")[OecprTemp)&(val("ordStatDesc")'[ordStatDiscon)&(orcatId'=90)&(orcatId'=79)&(val("execCtcpDesc")="") s disposeStatCode="S"  ;要执行的医嘱
    i ((oecprCode="NORM")!(oecprCode="OM"))&(ordStatCode'="D")&(val("execCtcpDesc")="") d
    .i (admType="I")&($g(^AMT($j,"lackofFee"))=-1) s disposeStatCode="LackOfFee"  ;要执行的医嘱
    .e  s disposeStatCode="Temp"  ;要执行的医嘱
    //&js<alert("here execdesc "+"#(oeoriId)#"+"||"+"#(usrdat)#"+"||"+"#(val("execCtcpDesc"))#");>
    //i ($g(usrdat)'="")!(val("execCtcpDesc")'="") s disposeStatCode="Exec"  ;已执行或处理的医嘱
    i (val("execCtcpDesc")'="") s disposeStatCode="Exec"  ;已执行或处理的医嘱
    i (ordStatCode="D")&(discon="") s disposeStatCode="Discontinue"   ;停止未处理医嘱
    //ypz unuse//i ($g(^DHCCLNurseExec("DISCON","OrdItem",oeoriId))'="") s disposeStatCode="ExecDiscon"  ;停止医嘱已处理
    ////i '$d(^TMP($j,"printed"))&(disposeStatCodeStr'[("^"_disposeStatCode_"^")) q "" //ypz rem 0606626
    ////s val("disposeStatDesc")=$p(..GetDisposeDesc(disposeStatCode),"|",1)
    //&js<alert("here execdesc "+"#(disposeStatCode)#"+"||"+"#(oeoriSub)#");>
    //unused//s pmark=$g(^DHCCLNurseExec("Printed",oeoriId))
    //unused//i (pmark["Y") s val("prtFlag")=val("prtFlag")_"Y"  //????显示多个?
    //unused//i (pmark["T") s val("prtFlag")=val("prtFlag")_"T"  //????两个都显示?
   
    i oecprCode="STAT" s val("phcfrCode")="ST"  ;by xin ///???
    
    s val("createDateTime")=##Class(web.DHCCLCom).FormatDate(oeoriDate)_" "_##Class(web.DHCCLCom).FormatTime(oeoriTimeOrd)
    s val("sttDateTime")=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_$zt(sttTime,2)
    s val("xDateTime")=##Class(web.DHCCLCom).FormatDate(xDate)_" "_##Class(web.DHCCLCom).FormatTime(xTime)
    s val("execXDateTime")=##Class(web.DHCCLCom).FormatDate(execXDate)_" "_##Class(web.DHCCLCom).FormatTime(execXTime)
    
    //ypz 060519 begin
    i ordStatCode'="D"  //非停止医嘱不显示
    {
	    s val("execXDateTime")=""
	    s val("execXUserDesc")=""
	    s val("xCtcpDesc")=""
	    s val("xDateTime")=""
    }
    i val("execCtcpDesc")=""  s val("execDateTime")=""  ;未关联医护人员不显示执行时间
    //ypz 060519 end

    s specCode=$p($g(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)),"^")
    //i specCode'="" s val("specDesc")=$p($g(^TTAB("SPEC",specCode)),"\",1)
    i specCode'="" s val("specDesc")=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(specCode,""),$c(2),2)

    //病理
    s blLabNo=##Class(web.DHCAPPPisInterface).GetRepRowIdByOeordID(oeordId_"||"_oeoriSub) ;##class(web.DHCPisApplicationSheet).GetRowIdByOrderDr(oeordId_"||"_oeoriSub) ;
    i blLabNo'="" d
    .s val("labNo")=blLabNo
    .s specDateInfo=""
    .s specDesc=##Class(web.DHCAPPPisInterface).GetSpeNameByRepID(blLabNo)
    .s val("specDesc")=$Replace(specDesc,"!","^")   ;##Class(web.DHCAPPPisInterface).GetSpeNameByRepID(blLabNo) ;##class(web.DHCPisApplicationSheet).GetSpecimensinfo(blLabNo) ;##Class(web.DHCAPPPisInterface).GetSpeNameByRepID(blLabNo) ;##class(web.DHCPisApplicationSheet).GetSpecimensinfo(blLabNo)
    s placerCode="" //ypz 061113
    i (queryTypeCode["JYDO")&($g(^DHCCLSet("Exec","PlacerNo"))="Y") d  //ypz jst 060915
       .s placerStr=..GetSpecContainerCode(oeoriId)
       .i $p(placerStr,"^",5)'="" s placerCode=$p(placerStr,"^",5)
       .//s disposeStatCode=placerColor
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    i (ordStatCode="D")&(discon="")&(oeoriBilled="P") s disposeStatCode="Temp"  //20180320
    s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    s payMode=""  //##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
    //i (ordStatCode'="D")&(oecprCode'="OM")&(oecprCode'="OMST")&((oeoriBilled="B")!(oeoriBilled="TB")) s disposeStatCode="UnPaid"
   
    s skinTestDate="",skinTestTime=""
    i (skinTestFlag="Y")!(actCode="YY") d  //ypz 060618
        .s skinTestCtcpDesc=""
        .s skinTestAuditCtcpDesc=""
        .s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
        .i dhcoriId'="" d
            ..s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
            ..i skinTestCtcpId="" q
            ..s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
            ..s skinTestDate=$p(^DHCORDItem(dhcoriId),"^",3)
            ..s skinTestTime=$p(^DHCORDItem(dhcoriId),"^",4)
             ..s skinTestAuditCtcpId=$p(^DHCORDItem(dhcoriId),"^",13)
            ..i skinTestAuditCtcpId="" q
            ..s skinTestAuditCtcpDesc=$p($g(^CTPCP(skinTestAuditCtcpId,1)),"^",2)
        .i (abnorm="N") d
        ..s val("arcimDesc")=val("arcimDesc")_" (-)"_skinTestCtcpDesc_" "_skinTestAuditCtcpDesc ;q
        ..s disposeStatCode="SkinTestNorm"
        .i (abnorm="Y") d
        ..s val("arcimDesc")=val("arcimDesc")_" (+)"_skinTestCtcpDesc_" "_skinTestAuditCtcpDesc
        ..s disposeStatCode="SkinTestAbnorm" ;s disposeStatCode="SkinTest"
        .i (abnorm="") d
        ..s val("arcimDesc")=val("arcimDesc")_" ( )"
        ..s disposeStatCode="SkinTest"
    /*s ordSeqID=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	i ordSeqID'="" d
	.s mainoeordId=+ordSeqID
	.s mainoeoriSub=$p(ordSeqID,"||",2)
	.s skinTestFlag=$p($g(^OEORD(mainoeordId,"I",mainoeoriSub,5)),"^",2)
    .s abnorm=$p($g(^OEORD(mainoeordId,"I",mainoeoriSub,11)),"^",3)
    .s actId=$p($g(^OEORD(mainoeordId,"I",mainoeoriSub,11)),"^",21)
    .s actCode="",actDesc=""
    .i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
    .i (skinTestFlag="Y")!(actCode="YY") d  //ypz 060618
    ..i (abnorm="N") d
    ...s disposeStatCode="SkinTestNorm"
    ..i (abnorm="Y") d
    ...s disposeStatCode="SkinTest"
    ..i (abnorm="") d
    ...s disposeStatCode="SkinTest"*/
    
    s val("skinTestDateTime")=##Class(web.DHCCLCom).FormatDate(skinTestDate)_" "_##Class(web.DHCCLCom).FormatTime(skinTestTime)
    
    i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub)="/14"
    i disposeStatCodeStr'[("^"_disposeStatCode_"^") q "" //'$d(^TMP($j,"printed"))&(
    s val("disposeStatDesc")=$p(..GetDisposeDesc(disposeStatCode),"|",1)

    i reclocId'="" s hospital=$p($g(^CTLOC(reclocId)),"^",22)

    i $d(^OEORD(oeordId,"I",oeoriSub,"X"))<10 d //无执行医嘱:处置治疗类
        .i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub)="/21"
        .
        .q:((sttDate<FrDate)!(sttDate>ToDate))&(admType'="I")  //qse 060324
        .i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub)="/22"
        .q:(exeFlag=1)&(admType'="I")
        .s val("price")=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice,hospital)
        .s val("price")=$fn(val("price"),"",2)
				.i (((stayFlag'=1)!(payMode=0))&(ordStatCode'="D")&(oecprCode'["OM")&((oeoriBilled="B")!(oeoriBilled="TB"))&(OrdPaid=0))&((+val("price"))'=0)&(disposeStatCode'="SkinTest")&(disposeStatCode'="SkinTestNorm") s disposeStatCode="UnPaid"
				.s val("disposeStatCode")=disposeStatCode
    	  .s val("disposeStatDesc")=$p(..GetDisposeDesc(disposeStatCode),"|",1) 
        .s idStr=oeoriId_"!"_placerCode_"!"_disposeStatCode_"!"_val("prtFlag")
    	.s orderBaseQty=##Class(web.DHCCLCom).GetOrderBaseQty(oeoriId)
    	.i ((admType="O")||(admType="E"))&&(orderBaseQty=0) s orderBaseQty=..GetOrderBaseQtyMZ(oeoriId)
    	.s val("totalAmount")=$fn(orderBaseQty*val("price"),"",2)
        .d ..SaveTempData(.val,.tPos,sttDate,sttTime,groupOriId,sortOriSub,0,idStr,EpisodeID,seqNochl)
   	s oeoreSub=0,skinTested=0 //有执行医嘱
    f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
        .s oreStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)
        .s sttDate=$p(oreStr,"^",1),sttTime=$p(oreStr,"^",2) //qse 060324
    	.s expStr="^"_oeordId_"||"_oeoriSub_"^"_"^"_EpisodeID_"^"_reclocId
    	.s val("price")=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice,hospital,expStr)
    	.s val("price")=$fn(val("price"),"",2)
			.i (((stayFlag'=1)!(payMode=0))&(ordStatCode'="D")&(oecprCode'["OM")&((oeoriBilled="B")!(oeoriBilled="TB"))&(OrdPaid=0))&((+val("price"))'=0)&(disposeStatCode'="SkinTest")&(disposeStatCode'="SkinTestNorm")&(disposeStatCode'="SkinTestAbnorm") s disposeStatCode="UnPaid"
    	.s orderBaseQty=##Class(web.DHCCLCom).GetOrderBaseQty(oeoriId)
    	.i ((admType="O")||(admType="E"))&&(orderBaseQty=0) s orderBaseQty=..GetOrderBaseQtyMZ(oeoriId)
    	.s val("totalAmount")=$fn(orderBaseQty*val("price"),"",2)
        .i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub,oeoreSub)="/31"
        .q:((sttDate<FrDate)!(sttDate>ToDate))&(admType'="I") //按执行时间过滤
        .s val("sttDateTime")=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_##Class(web.DHCCLCom).FormatTime(sttTime)
        .i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub,oeoreSub)="/32"
        .q:(exeFlag=1)&($p(oreStr,"^",15)="")&(admType'="I") //qse 060324
        .i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub,oeoreSub)="/33"
        .q:(exeFlag=0)&($p(oreStr,"^",15)'="")&(admType'="I")
        
        .s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
        .s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
        .s pmark=""
        .i dhcoreId'="" d
            ..s pmark=$p($g(^DHCOrdExec(dhcoreId)),"^",3)
            ..i (pmark["M") s val("prtFlag")=val("prtFlag")_"M"  //显示多日的长嘱单 ypz 061226
            ..i (pmark["Y") s val("prtFlag")=val("prtFlag")_"Y"  //????显示多个?
            ..i (pmark["T") s val("prtFlag")=val("prtFlag")_"T"  //????两个都显示?
            ..i (pmark["P") s val("prtFlag")=val("prtFlag")_"P" 
        .i $p(oreStr,"^",15)'="" d
            ..s val("execCtcpDesc")=$p($g(^CTPCP($p(oreStr,"^",15),1)),"^",2) //根据医院情况定
            ..i $p(oreStr,"^",19)>0 d
                ...s val("execDateTime")=##Class(web.DHCCLCom).FormatDate($p(oreStr,"^",19))_" "_##Class(web.DHCCLCom).FormatTime($p(oreStr,"^",20))
                ...s statId=$p(oreStr,"^",16)
                ...i statId'="" s val("execStat")=$p($g(^OEC("STAT",statId)),"^",2)
            ..s disposeStatCode="Exec" //ypz 060617????
            ..s val("disposeStatDesc")=$p(..GetDisposeDesc(disposeStatCode),"|",1)        
    	.s payMode="" //##class(web.DHCBillInterface).IStayPayModeByEpisodeID()  //押金模式判断2017-02-24
    	.i (payMode=1)&(disposeStatCode="UnPaid")  d
    	.s val("disposeStatCode")=disposeStatCode
    	.s val("disposeStatDesc")=$p(..GetDisposeDesc(disposeStatCode),"|",1) 
        .//i (queryTypeCode["JYDO")&($g(^DHCCLSet("Exec","PlacerNo"))="Y") s disposeStatCode=placerColor  //ypz jst 060915
        .i $g(^TMPNurOPDebug)="Y" s ^TMPNurOPDebug(EpisodeID,oeordId,oeoriSub,oeoreSub)="/34"
        .i (queryTypeCode="PSDO")&(skinTested=1) q //ypz 060627
        .i queryTypeCode="PSDO" s skinTested=1  //ypz 060617
        .s specCollDate=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",11)
    	.s specCollTime=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",12)
    	.s val("specCollDateTime")=##CLASS(web.DHCLCNUREXCUTE).FormatDate(specCollDate)_" "_##CLASS(web.DHCLCNUREXCUTE).FormatTime(specCollTime)
        .s val("prtFlag")=$P($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"NUR")),"^",1)
        .s idStr=oeoriId_"||"_oeoreSub_"!"_placerCode_"!"_disposeStatCode_"!"_val("prtFlag")
        .d ..SaveTempData(.val,.tPos,sttDate,sttTime,groupOriId,sortOriSub,oeoreSub,idStr,EpisodeID,seqNochl)
        .;;;;;;;;s resStr=""
        .;;;;;;;;f ivar=1:1:^DHCCLNurseExec("Var",0) d
        	..;;;;;;;;s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
        	..;;;;;;;;i $g(tPos(varName))'="" s $p(resStr,"!",tPos(varName))=val(varName)
        .;;;;;;;;s tmpDateTime=sttDate+(sttTime/100000)  //ypz060618
        .;;;;;;;;s tmpOreSeq=sortOriSub+(oeoreSub/100)  //ypz060618
        .;;;;;;;;i resStr'="" d
        	..;;;;;;;;s resStr=resStr_"!"_oeoriId_"||"_oeoreSub_"!"_arcicId_"!"_disposeStatCode_"!"_val("prtFlag")  //tmpDisposeStat
        	..;;;;s ^TMP($j,"NurseExecSeqNoSort",EpisodeID,sttDate,tmpOreSeq,seqNochl)=resStr
        	..//s ^TMP($j,"NurseExec",0)=$g(^TMP($j,"NurseExec",0))+1  //ypz 060617
        	..//s ^TMP($j,"NurseExec",^TMP($j,"NurseExec",0))=resStr  //ypz 060617
        	..;;;;s ^TMP($j,"NurseExecGroup",groupOriId,tmpDateTime,tmpOreSeq)=resStr
        	..//s ^TMPNurOPDebug(0)=$g(^TMPNurOPDebug(0))+1
        	..//s ^TMPNurOPDebug(^TMPNurOPDebug(0))=oeoriId_"||"_oeoreSub_"    "_groupOriId_"/"_tmpDateTime_"/"_tmpOreSeq_"/"_resStr
        	..//w " /count="_^TMP($j,"NurseExec",0)_" :sub="_oeoriId_"||"_oeoreSub,!
    ;s val("disposeStatDesc")=$p(..GetDisposeDesc(disposeStatCode),"|",1)
    f ivar=1:1:^DHCCLNurseExec("Var",0) d //清空变量内容
        .s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
        .s val(varName)="" 
    //ypz 060303 end
    /*f ivar=1:1:^DHCCLNurseExec("Var",0) d
        .s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
        .i $g(tPos(varName))'="" s $p(resStr,"!",tPos(varName))=val(varName)
        .s val(varName)=""  //清空变量内容
    //&js<alert("here  "+"#(sttDate)#"+"/"+"#(sortOriSub)#"+"/"+"#(resStr)#");>
    i resStr'="" d
        .s resStr=resStr_"!"_oeoriId_"!"_arcicId_"!"_disposeStatCode_"!"_tmpPrtFlag
        .s ^TMP($j,"NurseExecSeqNoSort",EpisodeID,sttDate,sortOriSub,seqNochl)=resStr
    //&js<alert("here execdesc "+"#(resStr)#"+"/");>
    q resStr*/  //ypz rem 060303
    q 0
}

ClassMethod SaveTempData(val, tPos, sttDate, sttTime, groupOriId, sortOriSub, oeoreSub, idStr, EpisodeID, seqNochl)
{
	n (val,tPos,sttDate,sttTime,groupOriId,sortOriSub,oeoreSub,idStr,EpisodeID,seqNochl)
	s resStr=""
    f ivar=1:1:^DHCCLNurseExec("Var",0) d
        .s varName=$p(^DHCCLNurseExec("Var",ivar),"^",2)
        .i $g(tPos(varName))'="" s $p(resStr,"!",tPos(varName))=val(varName)
    s tmpDateTime=sttDate+(sttTime/100000)  //ypz060618
    s tmpOreSeq=sortOriSub+(oeoreSub/100)  //ypz060618
    s tempOeoreID=$p(idStr,"!",1)
    s tmpSeqExecNo=..getflag(tempOeoreID)			
    i resStr'="" d
       	.s resStr=resStr_"!"_idStr  //tmpDisposeStat
        .s ^TMP($j,"NurseExecSeqNoSort",EpisodeID,sttDate,tmpOreSeq,seqNochl)=resStr 
        .//s ^TMP($j,"NurseExec",0)=$g(^TMP($j,"NurseExec",0))+1  //ypz 060617
        .//s ^TMP($j,"NurseExec",^TMP($j,"NurseExec",0))=resStr  //ypz 060617
        .;s ^TMP($j,"NurseExecGroup",groupOriId,tmpDateTime,tmpOreSeq)=resStr
        .s ^TMP($j,"NurseExecGroup",tmpSeqExecNo,tmpDateTime,tmpOreSeq)=resStr
        .//s ^TMPNurOPDebug(0)=$g(^TMPNurOPDebug(0))+1
        .//s ^TMPNurOPDebug(^TMPNurOPDebug(0))=oeoriId_"||"_oeoreSub_"    "_groupOriId_"/"_tmpDateTime_"/"_tmpOreSeq_"/"_resStr
        .//s ^TMPNurOPDebug(^TMPNurOPDebug(0))=groupOriId_"/"_tmpDateTime_"/"_tmpOreSeq_"    "_"/"_oeoreSub_"/"_resStr
        .//w " /count="_^TMP($j,"NurseExec",0)_" :sub="_oeoriId_"||"_oeoreSub,!
    //q 0
}

ClassMethod SetSkinTestResult0225(oriOreId, userId, flag) As %String
{
    //皮试处理
    n (oriOreId,userId,flag)
    s oeordId=+oriOreId
    s oeoriSub=$p(oriOreId,"||",2)
    s oeoriId=oeordId_"||"_oeoriSub
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
    i (skinTestFlag'="Y")&(actCode'="YY")&(actCode'="MS") q "非皮试医嘱!"
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    i (oeoriBilled="P")&(actCode'="YY")&(actCode'="MS") q "已结算医嘱不能置皮试结果!" //ypz 061128
    //ypz 060924 begin
	s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)  //070204
	i ordStatCode="D" q "停止医嘱不能置皮试结果!"
    s preFlag=$p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)
    i preFlag=flag q "所置状态与原来相同,未改变皮试状态!"
    //由阳性改为阴性时，已执行医嘱可以撤消
	i (preFlag'="Y")&(..IfExecOrder(oeoriId)=1)  q "医嘱已执行，不能置皮试结果!" //070413
	
	s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2),skinTestInstr=""
	i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr"))
	s phcinId=+$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    s dispStat=##class(web.DHCCLCom).GetDispensingStat(oeoriId,"N") //070911
    //s dispStat="",oeoreSub=""
    //f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
	//    .s dspSub=0
	//   	.f  s dspSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")  d
	//       	..s dspStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)
	//       	..i $p(dspStr,"^",6)'="",dispStat'="C" s dispStat=$p(dspStr,"^",6)  //ypz 070318 add '="C"
	s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(dispStat="")&(arcicOrderType="R") q "无发药状态!"
	//i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(actCode'="YY")&(actCode'="MS")&(dispStat="C") q "不能对已发药医嘱操作!"  //ypz
	//ypz 060924

    ////i $p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)'="" q "已有皮试状态,不能修改!"
 	//&sql(update oe_orditem set OEORI_Abnormal=:flag where oeori_rowid=:rowid)
	s ctcpId=$p(^SSU("SSUSR",userId),"^",14)
	s curDate=+$h,curTime=$p($h,",",2)
	//置皮试结果时,向皮试病人列表中置皮试时间
	s resStr=0
	i admType="O" d
	.s TestAdmDr=$p($g(^OEORD(oeordId)),"^",1)
	.s parr="TestAdmDr|"_TestAdmDr_"^TestDate|"_curDate_"^TestTime|"_curTime_"^RecUser|"_userId
	.s resStr=##class(User.DHCNurSkinTestList).Save("",parr)
	.;s resStr=##class(User.DHCNurSkinTestList).Save("",parr,"test")
	
	i resStr'=0 q $g(resStr)
	////多次置结果的控制?//同一次
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestCtcp_Dr,DHCORI_SkinTestDate,DHCORI_SkinTestTime) values(:oeoriId,:ctcpId,:curDate,:curTime))
	e  &sql(update DHC_OE_OrdItem set DHCORI_SkinTestCtcp_Dr=:ctcpId,DHCORI_SkinTestDate=:curDate,DHCORI_SkinTestTime=:curTime where DHCORI_OEORI_Dr=:oeoriId)
	s $p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)=flag
	s resStr=0
	i arcicOrderType="R" s resStr=##class(web.DHCCLCom).UpdatePatAllergy(oeoriId,userId,flag)
	i resStr'=0 q resStr
	i admType="I" s insertOrder=..InsertSkinTestOrder(userId, oriOreId,"","",flag)
    q:insertOrder'=0 insertOrder
	i admType'="I" q "操作成功!"
	i flag="Y" s resStr=..UpdateOrdGroup("Y",oeoriId,userId,1)
	i flag'="Y",preFlag="Y" s resStr=..UpdateOrdGroup("Y",oeoriId,userId,0)
	i resStr=0  q "操作成功!"
	q resStr
}

ClassMethod SetSkinTestResult(oriOreId, userId, flag) As %String
{
    //皮试处理 ##class(web.DHCNurCom).SetSkinTestResult("369||2||1","10211","N")
    n (oriOreId,userId,flag)
    s ^tempsc("SetSkinTestResult")=$lb(oriOreId,userId,flag)
    s oeordId=+oriOreId
    s oeoriSub=$p(oriOreId,"||",2)
    s oeoriId=oeordId_"||"_oeoriSub
    s insertOrder=0
    s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2)
    s admId=+^OEORD(oeordId)
	;s DepID=$p(^PAADM(admId),"^",70)
	;s ConDepID=$p($g(^PAWARD(DepID)),"^",5) 
    ;i admType="I" s insertOrder=..InsertSkinTestOrder(userId, oriOreId,"","",flag)
    ;q:insertOrder'=0 insertOrder
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s phcinSkinTest=##class(Nur.CommonInterface.Order).ifPhcinSkinTest(oeordId,oeoriSub)
    s:phcinSkinTest=1 skinTestFlag="Y"
    s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    s prtId=""
    i stayFlag'=1 s prtId=##class(DHCCLCom).GetPrtId(oeoriId)
    i ((skinTestFlag="Y")&&(phcinSkinTest=1))&&(stayFlag'=1)&(prtId="") q oeoriId_$p(..GetArcim(oeoriId),"^",1)_"未找到病人发票!不能操作!"

   
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
    i (skinTestFlag'="Y")&(actCode'="YY")&(actCode'="MS") q "非皮试医嘱!"
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    s payMode=""  //##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
    q:(((payMode'=1)&(stayFlag=1))!(stayFlag'=1))&(oeoriBilled'="P")&(actCode="YY") "原液未交费不能置皮试结果"
    ;i (oeoriBilled="P")&(actCode'="YY")&(actCode'="MS") q "已结算医嘱不能置皮试结果!" //ypz 061128
    //ypz 060924 begin
	s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)  //070204
	i ordStatCode="D" q "停止医嘱不能置皮试结果!"
    s preFlag=$p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)
    i preFlag=flag q "所置状态与原来相同,未改变皮试状态!"
    //由阳性改为阴性时，已执行医嘱可以撤消
	i (preFlag'="Y")&(..IfExecOrder(oeoriId)=1)  q "医嘱已执行，不能置皮试结果!" //070413
	
	s skinTestInstr=""
	i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr"))
	s phcinId=+$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    s dispStat=##class(web.DHCCLCom).GetDispensingStat(oeoriId,"N") //070911
    //s dispStat="",oeoreSub=""
    //f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
	//    .s dspSub=0
	//   	.f  s dspSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")  d
	//       	..s dspStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)
	//       	..i $p(dspStr,"^",6)'="",dispStat'="C" s dispStat=$p(dspStr,"^",6)  //ypz 070318 add '="C"
	s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	;i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(dispStat="")&(arcicOrderType="R") q "无发药状态!"
	//i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(actCode'="YY")&(actCode'="MS")&(dispStat="C") q "不能对已发药医嘱操作!"  //ypz
	//ypz 060924

    ////i $p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)'="" q "已有皮试状态,不能修改!"
 	//&sql(update oe_orditem set OEORI_Abnormal=:flag where oeori_rowid=:rowid)
	s ctcpId=$p(^SSU("SSUSR",userId),"^",14)
	s curDate=+$h,curTime=$p($h,",",2)
	//置皮试结果时,向皮试病人列表中置皮试时间
	s resStr=0
	i admType="O" d
	.s TestAdmDr=$p($g(^OEORD(oeordId)),"^",1)
	.s parr="TestAdmDr|"_TestAdmDr_"^TestDate|"_curDate_"^TestTime|"_curTime_"^RecUser|"_userId
	.s resStr=##class(User.DHCNurSkinTestList).Save("",parr)
	.;s resStr=##class(User.DHCNurSkinTestList).Save("",parr,"test")
	
	i resStr'=0 q $g(resStr)
	d ..GetFirstOeoreId(oeoriId,"Insert")
	s resStr=##class(web.DHCLCNUREXCUTE).UpdateSkinTestResult(oriOreId,flag,ctcpId,+$h,$p($h,",",2))
	////多次置结果的控制?//同一次
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestCtcp_Dr,DHCORI_SkinTestDate,DHCORI_SkinTestTime) values(:oeoriId,:ctcpId,:curDate,:curTime))
	e  &sql(update DHC_OE_OrdItem set DHCORI_SkinTestCtcp_Dr=:ctcpId,DHCORI_SkinTestDate=:curDate,DHCORI_SkinTestTime=:curTime where DHCORI_OEORI_Dr=:oeoriId)
	s $p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)=flag
	s resStr=0
	i arcicOrderType="R" s resStr=##class(web.DHCCLCom).UpdatePatAllergy(oeoriId,userId,flag)
	i resStr'=0 q resStr
	

	i (phcinSkinTest=1) s resStr=..UpdateOrdGroup("Y",oeoriId,userId,1)
	i (phcinSkinTest=1) d
	.s child=0 
	.s child=$O(^OEORDi(0,"OEORI",oeordId,oeordId_"||"_oeoriSub,child)) q:(child="")
	.s childOeoreID=oeordId_"||"_child_"||"_$p(oriOreId,"||",3)
	.s resStr=..UpdateOrdGroup("Y",childOeoreID,userId,1)
	i (phcinSkinTest=1) d
	.s ordSeqID=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	.i ordSeqID'="" d
	..s mainOeoreID=ordSeqID_"||"_$p(oriOreId,"||",3)
	..s resStr=..UpdateOrdGroup("Y",mainOeoreID,userId,1)
	//i flag="Y" s resStr=..UpdateOrdGroup("Y",oeoriId,userId,0)
	//i flag'="Y",preFlag="Y" s resStr=..UpdateOrdGroup("Y",oeoriId,userId,0)
	i resStr=0  q "操作成功!"
	q resStr
}

ClassMethod GetData(itmjs As %Library.String = "", itmjsex As %Library.String = "", number As %String)
{
    s str=$g(^TMP($j,"NurseExec",number))
    s retval=itmjs_"('"_$ZCVT(str,"O","JS")_"');"
    i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(str,"O","JS")_"');"
    //&javascript<#(retval)#>
	q str
}

ClassMethod GetFreqTime(freq, dateConStr, delimiter, date, dateStartTime) As %String
{
	//取频次时间,如果有日期date则输出日期,如果频次时间小于dateStartTime
	n (freq, delimiter,dateConStr, date, dateStartTime)
	q:$g(freq)="" ""
	//s frw=""  s frw=$o(^PHCFR(0,"Code",$$ALPHAUP^SSUTIL4(freq),frw),-1)
	s frw=""  s frw=$o(^PHCFR(0,"Desc1",$$ALPHAUP^SSUTIL4(freq),frw),-1)
 	if frw'=""
 	{	
 		k ^TMP("NurFreq",$j)
		s chl=0  f  s chl=$o(^PHCFR(frw,"DT",chl))  q:chl=""  d
	 		.s frtDate=""
	 		.i date'="" d
	 		    ..i ^PHCFR(frw,"DT",chl)<dateStartTime s frtDate=$$$zd(date+1,3)_" "
	 		    ..e  s frtDate=$$$zd(date,3)_" "
	 		    ..s frtDate=$tr(frtDate,"-",dateConStr)
	 		.s timeStr=$zt(^PHCFR(frw,"DT",chl),2)
	 		.i ^PHCFR(frw,"DT",chl)>86300 s timeStr="24:00"
	 		.//s $p(timeStr,":",1)=+$p(timeStr,":",1)
	 		.//i $p(timeStr,":",2)'>0 s timeStr=$p(timeStr,":",1)
	 		.s tmpList(frtDate_timeStr)=""
	 	s frtDateTime="",frtDateTimeStr=""
	 	f  s frtDateTime=$o(tmpList(frtDateTime)) q:frtDateTime=""  d
	 		.i frtDateTimeStr'="" s frtDateTimeStr=frtDateTimeStr_delimiter
	 		.s frtDateTimeStr=$G(frtDateTimeStr)_frtDateTime
	}
  	q $G(frtDateTimeStr)
}

ClassMethod OrdPrintInfo(oeoreIdStr, longNewOrdAdd = "") As %String
{
	//单病人的一次输液,多条检验取单
	n (oeoreIdStr, longNewOrdAdd)
	q:oeoreIdStr="" ""
	s count=$l(oeoreIdStr,"^")
	s patStr=##class(web.DHCCLCom).PatInfo($p(oeoreIdStr,"^"))
	q:patStr="" ""
	s patName=$p(patStr,"^",5)
   	s regNo=$p(patStr,"^",1)
   	s bedCode=$p(patStr,"^",7)
   	s orditemStr=""
	f i=1:1:count d
		.s oeoreId=$p(oeoreIdStr,"^",i)
		.s oeordId=+oeoreId
		.s oeoriSub=$p(oeoreId,"||",2)
		.s oeoreSub=$p(oeoreId,"||",3)
		.q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'=""
		.s oeoriId=oeordId_"||"_oeoriSub
		.s arcimStr=..GetArcim(oeoriId)
		.s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
		.s placerNo=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",36)
		.s arcimDesc=$p(arcimStr,"^",1)
		.q:arcimDesc=""
		.s dose=$p(arcimStr,"^",2)
		.s oecprDesc=$p(arcimStr,"^",3)
		.s phcfrCode=$p(arcimStr,"^",4)
		.s phcinDesc=$p(arcimStr,"^",5)
		.s oriNote=$p(arcimStr,"^",6)
		.//s arcimStr=arcimDesc_"^"_dose_"^"_$g(oecprDesc)_"^"_$g(phcfrCode)_"^"_$g(phcinDesc)_"^"_oriNote
		.s specNote=..GetSpecNote(oeoriId)
		.s dosePackQty=..GetDosePackQty(oeoriId)
		.i bedCode'="",dosePackQty<1 s dosePackQty=1
		.s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
		.s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
		.//s orditemStr=orditemStr_"|"_..GetFreqTime(phcfrCode, $c(5), sttDate, dateStartTime)
		.//s ^TMPNurOPDebug=oeoriId_"/"_longNewOrdAdd
		.s specDesc=""
		.i $d(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)) d
  			..s specCode=$p(^OEORD(oeordId,"I",oeoriSub,"SPEC",1),"^")
  			..q:specCode=""
  			..s specDesc=$p(^TTAB("SPEC",specCode),"\")
		.i oeoreSub'="" d
			..s oeoreStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)
			..s sttDate=$p(oeoreStr,"^",1)
			..s sttTime=$p(oeoreStr,"^",2)
			..s seatNo=$p(oeoreStr,"^",22) 
			..s execCtcpId=$p(oeoreStr,"^",15)
			..i $p(oeoreStr,"^",19)'="" d
				...s execDate=$$$zd($p(oeoreStr,"^",19),3)
				...s execTime=$zt($p(oeoreStr,"^",20),2)
			..i execCtcpId'="" s execCtcpDesc=$p($g(^CTPCP(execCtcpId,1)),"^",2)
			..s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
			..i dhcoreId'="" d
				...s specCollUserId=$p(^DHCOrdExec(dhcoreId),"^",12)
				...i specCollUserId'="" d
					....s specCollCtcpId=$p(^SSU("SSUSR",+specCollUserId),"^",14)
					....i specCollCtcpId="" q
					....s specCollCtcpDesc=$p($g(^CTPCP(specCollCtcpId,1)),"^",2)
					....s specCollDate=$$$zd($p(^DHCOrdExec(dhcoreId),"^",13),3)
					....s specCollTime=$zt($p(^DHCOrdExec(dhcoreId),"^",14),2)
		.s execDateTime=""
		.i ($g(execDate)'="")&($g(execTime)'="") s execDateTime=##Class(web.DHCCLCom).FormatDate(execDate)_" "_##Class(web.DHCCLCom).FormatTime(execTime)
		.//0322//s dateStartTime=$g(^DHCCLSet("Exec","DateStartTime"))
		.s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
		.q:oecprId=""
		.s oecprCode=$p($g(^OECPR(oecprId)),"^")
		.s sttDateTime=""
		.i bedCode'="" d
		    ..s printMark=$p(longNewOrdAdd,"^",2)  //ypz 070315
		    ..i printMark'["Y" s sttDateTime=##Class(web.DHCNurCom).GetExecDateTime(oeoriId,"-", $c(5), longNewOrdAdd) q
		    ..s sttDateTime=##Class(web.DHCNurCom).GetExecDateTime(oeoriId,"-", $c(5), "^Y")
		    ..i printMark'["A" q
		    ..s addExecDateTime=##Class(web.DHCNurCom).GetExecDateTime(oeoriId,"-", $c(5), "true^Y")
		    ..i sttDateTime="" s sttDateTime=addExecDateTime q
		    ..i addExecDateTime="" q
		    ..s sttDateTime=addExecDateTime_$c(5)_sttDateTime
		.i sttDateTime="" d
		    ..i (bedCode'="")&($p(longNewOrdAdd,"^")="true") q
		    ..s sttDateTime=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_##Class(web.DHCCLCom).FormatTime(sttTime)
		.s pbId=0,pboSub=""
		.s pbId=$o(^DHCPBi(0,"OEORI",oeoriId,""))
		.i pbId'="" d
			..q:$p(^DHCPB(pbId),"^",16)'="P"
			..s pboSub=$o(^DHCPBi(0,"OEORI",oeoriId,pbId,""))
			..q:pboSub=""
			..s dispFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,6)),"^",7)
			..s qty=+$p(^DHCPB(pbId,"O",pboSub),"^",5)
			..q:qty=0
			..s totalAmount=+$p(^DHCPB(pbId,"O",pboSub),"^",8)
			..s tmpOreSub=0,totalTimes=0,execTimes=0
			..f  s tmpOreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",tmpOreSub)) q:tmpOreSub=""  d
	    		...s totalTimes=totalTimes+1
	    		...i $p(^OEORD(oeordId,"I",oeoriSub,"X",tmpOreSub),"^",15)'="" s execTimes=execTimes+1
			..q:totalTimes=0
			..s execQty=qty/totalTimes
			..s execAmount=totalAmount/totalTimes
			..s totalQty=execQty*totalTimes
			..s haveExecQty=execQty*execTimes
		.s OrderDoc=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
		.i OrderDoc'="" s OrderDoc=$p(^SSU("SSUSR",+OrderDoc),"^",2)
		.s OrderSpec=..GetOrderSpec(oeoreId)
		.s $p(tmpStr,$c(4),1)=arcimDesc
		.s $p(tmpStr,$c(4),2)=dose
		.s $p(tmpStr,$c(4),3)=oecprDesc  //ypz 070204
		.s $p(tmpStr,$c(4),4)=phcfrCode  //ypz 070204
		.s $p(tmpStr,$c(4),5)=phcinDesc
		.s $p(tmpStr,$c(4),6)=oriNote
		.s $p(tmpStr,$c(4),7)=labNo
		.s $p(tmpStr,$c(4),8)=placerNo
		.s $p(tmpStr,$c(4),9)=specDesc
		.s $p(tmpStr,$c(4),10)=specNote
		.s $p(tmpStr,$c(4),11)=dosePackQty
		.s $p(tmpStr,$c(4),12)=+$g(haveExecQty)_"/"_+$g(totalQty)
		.s $p(tmpStr,$c(4),13)=$g(seatNo)
		.s $p(tmpStr,$c(4),14)=$g(execCtcpDesc)
		.s $p(tmpStr,$c(4),15)=execDateTime
		.s $p(tmpStr,$c(4),16)=$g(specCollCtcpDesc)
		.s $p(tmpStr,$c(4),17)=$g(specCollDate)_" "_$g(specCollTime)
		.s $p(tmpStr,$c(4),18)=sttDateTime
		.s $p(tmpStr,$c(4),19)=OrderDoc
		.s $p(tmpStr,$c(4),20)=OrderSpec
		.i $g(orditemStr)'="" s orditemStr=orditemStr_$c(3) //ypz 070204
		.s orditemStr=orditemStr_tmpStr
		.s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:curOriSub=""  d
			..s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_curOriSub)  //070204
			..i ordStatCode="D" q
			..s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeordId_"||"_curOriSub)
            ..q:arcicOrderType'="R"
			..//q:(oeoreSub'="")&&($d(^OEORD(oeordId,"I",curOriSub,"X",oeoreSub)))=0
			..s arcimStr=..GetArcim(oeordId_"||"_curOriSub)  //s arcimId=$p($g(^OEORD(oeordId,"I",curOriSub,1)),"^",2)
			..s OrderSpec=..GetOrderSpec(oeordId_"||"_curOriSub)
			..s $p(SubOrdStr,$c(4),1)=$p(arcimStr,"^",1)
			..s $p(SubOrdStr,$c(4),2)=$p(arcimStr,"^",2)
			..s $p(SubOrdStr,$c(4),20)=OrderSpec
			..s orditemStr=orditemStr_$c(3)_SubOrdStr
			..//s orditemStr=orditemStr_$c(3)_$p(arcimStr,"^",1)_$c(4)_$p(arcimStr,"^",2)  //ypz 070204 "!"->$c(3)
	q:orditemStr="" ""
	s $p(resStr,"^",1)=orditemStr
   	s $p(resStr,"^",2)=$p(patStr,"^",1) //regNo 
	s $p(resStr,"^",3)=$p(patStr,"^",5) //patName
   	s $p(resStr,"^",4)=$p(patStr,"^",7) //bedCode
   	s $p(resStr,"^",5)=$p(patStr,"^",4) //sex
   	s $p(resStr,"^",6)=$p(patStr,"^",8) //age
   	s $p(resStr,"^",7)=$p(patStr,"^",2) //ctlocDesc
   	s $p(resStr,"^",8)=$p(patStr,"^",9) //wardDesc
	s $p(resStr,"^",9)=$$$zd(+$h,3)_" "_$zt($p($h,",",2),2)
    s $p(resStr,"^",10)=##Class(web.DHCCLCom).GetHospital()   
    q $g(resStr)
}

ClassMethod LabPrintInfo(oeoreIdStr) As %String
{
	n (oeoreIdStr, longNewOrdAdd)
	s count=$l(oeoreIdStr,"^")
	q:oeoreIdStr="" ""
	s resStr=""
	f i=1:1:count d
		.s oeoreId=$p(oeoreIdStr,"^",i)
		.s oeordId=+oeoreId
		.s oeoriSub=$p(oeoreId,"||",2)
		.q:(oeordId="")!(oeoriSub="")
		.s oeoreSub=$p(oeoreId,"||",3)
		.s orditemStr=""
		.s oeoriId=oeordId_"||"_oeoriSub
		.s patStr=##class(web.DHCCLCom).PatInfo(oeoriId)
   		.s $p(orditemStr,$c(3),1)=$p(patStr,"^",1) //regNo
		.s $p(orditemStr,$c(3),2)=$p(patStr,"^",5) //patName
   		.s $p(orditemStr,$c(3),3)=$p(patStr,"^",7) //bedCode
   		.s $p(orditemStr,$c(3),4)=$p(patStr,"^",8) //age
   		.s $p(orditemStr,$c(3),5)=$p(patStr,"^",4) //sex
   		.s $p(orditemStr,$c(3),6)=$p(patStr,"^",2) //ctlocDesc
   		.s $p(orditemStr,$c(3),7)=$p(patStr,"^",9) //wardDesc
   		.
		.s arcimStr=..GetArcim(oeoriId)
		.s $p(orditemStr,$c(3),8)=$p(arcimStr,"^",1)
		.s $p(orditemStr,$c(3),9)=$p(arcimStr,"^",2)
		.s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
		.q:labNo=""
		.s $p(orditemStr,$c(3),10)=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20) //labNo
		.s $p(orditemStr,$c(3),11)=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",36) //placerNo
		.s specNote=""
		.i $p(patStr,"^",7)="" s specNote=..GetSpecNote(oeoriId) //门诊取单
		.s $p(orditemStr,$c(3),12)=specNote  //ypz 070204
		.s specDesc=""
		.i $d(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)) d
  			..s specCode=$p(^OEORD(oeordId,"I",oeoriSub,"SPEC",1),"^")
  			..q:specCode=""
  			..s specDesc=$p(^TTAB("SPEC",specCode),"\")
		.s $p(orditemStr,$c(3),13)=specDesc
		.s $p(orditemStr,$c(3),14)=..GetLabelDesc(oeoriId)
		.s execCtcpDesc="",execDateTime=""
		.i oeoreSub'="" d
			..s oeoreStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)
			..s execCtcpId=$p(oeoreStr,"^",15)
			..i execCtcpId="" q
			..i execCtcpId'="" s execCtcpDesc=$p($g(^CTPCP(execCtcpId,1)),"^",2)
			..i $p(Oeori,"^",19)'="" d
				...s execDate=$$$zd($p(oeoreStr,"^",19),3)
				...s execTime=$zt($p(oeoreStr,"^",20))
				...s execDateTime=execDate_" "_execTime
		.s $p(orditemStr,$c(3),15)=execCtcpDesc
		.s $p(orditemStr,$c(3),16)=execDateTime
		.s $p(orditemStr,$c(3),17)=$$$zd(+$h,3)_" "_$zt($p($h,",",2),2)
		.
		.i $g(resStr)'="" s resStr=resStr_"^" //ypz 070204
		.s resStr=resStr_orditemStr

    q $g(resStr)
}

/// ##class(web.DHCNurCom).UpdateOrdGroup("2019-03-12 09:49:09","742||4||1^^6^^ZSDO^^^","10211","1","1","6","")
ClassMethod UpdateOrdGroup(setSkinTest, oreStr, userId, setExecFlag, excuteAndPrintFlag = "", currLoc = "", currWard = "")
{
    //exDateTime 参数更新为setSkinTest,为"Y"是置皮试结果调用
    //setExecFlag=1 执行,=0撤消
    //执行关联医嘱	param="Y^"+basedose+"^"+curExecStatDesc+"^"+userId+"^"+oeoriId+"^"+arcicId;
    //^OEORDi(0,"NotExecE",{OE_Order.OEORD_RowId},{OEORE_ExStDate},
    //   +{OEORE_ExStTime},{OE_OrdItem.OEORI_Childsub},{OEORE_Childsub})
    n (setSkinTest,oreStr, userId,setExecFlag,excuteAndPrintFlag,currLoc,currWard)
    ;i currLoc=""&&$d(%session) s currLoc=%session.Get("LOGON.CTLOCID")
    ;i currWard=""&&$d(%session) s currLoc=%session.Get("LOGON.WARDID")
    S ^tempsc("UpdateOrdGroup")=$lb(setSkinTest,oreStr, userId,setExecFlag,excuteAndPrintFlag,currLoc,currWard)
    s oeoreId=$p(oreStr,"^",1)
    s seatNo=$p(oreStr,"^",2)
    s userDeptId=$p(oreStr,"^",3)  //ypz 070125
    //ypz 070213 begin
    s statDesc=$p(oreStr,"^",4) 
    i statDesc="" d //门诊不弹出界面，为空的情况
        .s statId=$o(^OEC("STAT",0))
        .s statDesc=$p(^OEC("STAT",statId),"^",2)
    //ypz 070213
    s queryTypeCode=$p(oreStr,"^",5)  //ypz 070528
    s execDate=$p(oreStr,"^",6)
    s execTime=$p(oreStr,"^",7)
    s DrugCell=$p(oreStr,"^",8) // + wxl 090301
    //s ^TMPNurOPDebug("execS")=oreStr_"|"_execDate_"|"_execTime
    s oeordId=+oeoreId,oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s oeoriId=oeordId_"||"_oeoriSub
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s phcinSkinTest=##class(Nur.CommonInterface.Order).ifPhcinSkinTest(oeordId,oeoriSub)
    s:phcinSkinTest=1 skinTestFlag="Y"
    s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
    s mainOeoriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
    q:(setSkinTest'="Y")&(mainOeoriId'="")&(setExecFlag=1) 0 //非置皮试的从医嘱不执行
    ;q:(setSkinTest'="Y")&(mainOeoriId'="")&(setExecFlag'=1)&(abnorm'="Y") 0 //非置皮试非皮试阳性从医嘱不能撤消
    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)  //070204
    s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
    i ordStatCode="E",setExecFlag'="1",arcicOrderType'="R" q "医嘱状态为执行,不能撤消!" //ypz 070204
    i ordStatCode="D",setExecFlag'="1" q "医嘱状态为停止,不能撤消!"
    //ypz 070213 begin
    s skinTest="",resStr=0
    s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2) //,skinTestInstr="" //ypz 070318
    //i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr")) //ypz 070318
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    //i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(skinTestFlag="Y")&(abnorm="") s resStr="请先置皮试结果!"
    q:(skinTestFlag="Y")&((abnorm="")!(abnorm=" "))&(setExecFlag=1) "请先置皮试结果!" ;s resStr="请先置皮试结果!"
	//ypz 070413 主医嘱不控制//i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(skinTestFlag="Y")&(abnorm="Y") s resStr="皮试阳性!"
    s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId) //ypz 070411
    q:oecprCode="" "医嘱优先级为空!" //ypz 070411    
    
    i (setSkinTest'="Y")&(setExecFlag=1) s resStr=##Class(web.DHCCLCom).CanExecSkinTestOrd(oeoriId)
    i (resStr'=0) q resStr

    //ypz 070413//s exDate=$zdh($p(exDateTime," "),3)
    //ypz 070413//s exTime=$zth($p(exDateTime," ",2))
    s arcimStr=..GetArcim(oeoriId)
    s dose=$p(arcimStr,"^",2) //ypz 070204
    //s oecprDesc=$p(arcimStr,"^",3) //ypz 070413
    //s para="Y^"_dose_"^完成^"_userId_"^"_oeoreId_"^"_""_"^"_seatNo_"^"_userDeptId
    s para="Y^"_dose_"^"_statDesc_"^"_userId_"^"_oeoreId_"^^"_seatNo_"^"_userDeptId_"^"_queryTypeCode_"^"_execDate_"^"_execTime //ypz 070213改进
    i setExecFlag="1" d
        .//ypz 070105 begin
        .;i (setSkinTest'="Y")&(skinTestFlag="Y")&(abnorm="Y") q
        .s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2) //ypz 061113
        .i arcimId="" s resStr="无医嘱项!" q  //ypz 061113
        .s arcicId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10) //ypz 061113
        .s arcicOrdType=$p(^ARC("IC",arcicId),"^",7)
        .s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
        .s EpisodeID=+^OEORD(oeordId),feeRetStr=""
        .s printFlag=##class(web.DHCNurCom).getPrintFlag(oeoriId)
        .i (excuteAndPrintFlag="")&(arcicOrdType="L")&&(printFlag'["P") s resStr="请先打印检验条码再执行!" q
        .s userDeptId=$p($G(^PAADM(EpisodeID)),"^",4)
        .s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    	.s payMode=""  //##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
    	.s orderDep=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",3)
        .s checkLocDeposit=##Class(web.UDHCJFARREARSMANAGE).CheckLoc(orderDep)
        .//i arcicOrdType'="R" s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, oeoriId_$c(2)_phOrdQty,"NE")
        .i (payMode=1)&&(checkLocDeposit=0)&(stayFlag=1) s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, oeoriId_$c(2)_phOrdQty,"NE")
        .i ($p(feeRetStr,"^",5)="C")&($p(feeRetStr,"^",7)="N") s resStr="费用不足,不能执行!" q
        .i ($p(feeRetStr,"^",5)="W")&($p(feeRetStr,"^",7)="N") s resStr="费用不足,不能执行!" q
        .s feeflag="1"              //lrl
        .;i ($p(feeRetStr,"^",5)="C")&($p(feeRetStr,"^",7)="Y") d     //lrl
            .;.s feeflag=##Class(web.UDHCJFARREARSMANAGE).CheckOrderE($p(feeRetStr,"^",3), arcimId)  //lrl
        .i feeflag="0" s resStr="费用不足,不能执行!" q                   //lrl
        .//ypz 070105 end
        .s resStr=..UpdateExecStat("","",para,"")
        .d ..updateCurrLocWard(oeoreId,currLoc,currWard)
        .i resStr=0 s resStr=..UpdateDHCPAPatMas(oeoriId,DrugCell,userId) // + 修改DHC_PA_PatMas扩展表 wxl 090301
        .d ..UpdatespecCollDatetime(oeoriId,userId)  ///更新采血时间
		.s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)   
		.i $g(labNo)'="" d ##Class(DHCLIS.DHCReceiveProcess).SaveVisitNumber(labNo,userId,"","","2")  //检验组接口调用
		 e  d
        .s resStr=..UndoUpdateExecStat(oeoreId,"","",userId) //ypz 070413 oecprDesc,userId)
        .d ..updateCurrLocWard(oeoreId,currLoc,currWard)
        .d ..CancelspecCollDatetime(oeoreId)   ///撤销执行时撤销采血时间        
        .i (skinTestFlag="Y")&&(abnorm'="")&&(abnorm'=" ")&(phcinSkinTest=1) d 
        ..s ctcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
        ..d ##class(web.DHCLCNUREXCUTE).UpdateSkinTestResult(oeoreId, "", ctcpId, execDate, execTime)
        .//s ^Gd=oeoreId_"   "_oecprDesc_"  "_userId
    i resStr'=0 q resStr
    i (setSkinTest="Y") q resStr //ypz 070413 置皮试为主医嘱时，从医嘱不执行
    //s ^TMPNurOPDebug(oeordId,oeoriSub)=oeoriId
    i resStr=0 s rtn=##Class(web.UDHCJFBILL).BILLN(+^OEORD(oeordId),userId,oeoriId) //ypz 070105
    s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")!(resStr'=0)  d
        .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId) //ypz 070204
        .q:ordStatCode="D" //ypz 070204 跳过停止的 070310 rem
        .q:ordStatCode="U" //ljw 091124 跳过作废的
        .//s ^TMPNurOPDebug(oeordId,curOriSub)=oeoriId
        .s arcimStr=..GetArcim(oeordId_"||"_curOriSub)
        .s dose=$p(arcimStr,"^",2) //ypz 070204
        .//s oecprDesc=$p(arcimStr,"^",3) //ypz 070413
        .//ypz 080908 rem//i oeoreSub="" s oeoreSub=$o(^OEORD(oeordId,"I",curOriSub,"X",0)) //ypz 070413//$o(^OEORDi(0,"NotExecE",oeordId,exDate,exTime,curOriSub,0))
        .//ypz 080908 rem//i admType="I",setExecFlag="1" s oeoreSub=""
        .s curOreId=oeordId_"||"_curOriSub_"||"_oeoreSub  //s arcimId=$p($g(^OEORD(oeordId,"I",curOriSub,1)),"^",2)
        .//s para="Y^"_dose_"^完成^"_userId_"^"_curOreId_"^"_""_"^"_seatNo  //
        .s para="Y^"_dose_"^"_statDesc_"^"_userId_"^"_curOreId_"^^"_seatNo_"^"_userDeptId_"^"_queryTypeCode_"^"_execDate_"^"_execTime  //ypz 070213改进
        .
        .i setExecFlag="1" d
            ..s resStr=..UpdateExecStat("","",para,"")
            ..d ..updateCurrLocWard(curOreId,currLoc,currWard)
        .e  d
            ..s resStr=..UndoUpdateExecStat(curOreId,"","",userId) //ypz 070413 oecprDesc, userId)
    		..d ..updateCurrLocWard(curOreId,currLoc,currWard)
    	i (setExecFlag'=1)&(abnorm'="") d
    	.s mainOeoreId=mainOeoriId_"||"_$p(oeoreId,"||",3)
    	.s mainoreStr=mainOeoreId_"^"_seatNo_"^"_userDeptId_"^"_statDesc
    	.d ..UpdateOrdGroup(setSkinTest, mainoreStr, userId, setExecFlag, excuteAndPrintFlag , currLoc , currWard )
    	
    q resStr
}

ClassMethod GetArcim(oeoriId)
{
    n (oeoriId)
    q:oeoriId="" ""
    s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	s scrip=$p(arcimId,"||")
	s ver=$p(arcimId,"||",2)
	s arcimDescAll=$p(^ARCIM(scrip,ver,1),"^",2)
	s arcimDesc=arcimDescAll  //$p(arcimDescAll,"(",1)
	s arcimDesc=$p(arcimDesc,"#",1)
	s arcimDesc=$p(arcimDesc,"$",1)
	;s arcimDesc=$p(arcimDesc,"*",1)  //dj20111021
	s arcimDesc=$p(arcimDesc,"@",1)
	;s arcimDesc=$p(arcimDesc,"[",1)
	;s arcimDesc=$p(arcimDesc,"(",1)
	i $p(arcimDescAll,"-",2)'="" s arcimDesc=arcimDesc_"("_$p(arcimDescAll,"-",2)  //ypz 060903
	
	s seqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
    i seqNo'="" s arcimDesc="____"_arcimDesc  //ypz 060617 val("arcimDesc")="____"_sortOriSub_val("arcimDesc")
    s ordEffDesc=##Class(web.DHCNurCom).GetOrdEffDesc(oeoriId) //ypz 070621
    i (ordEffDesc'="")&(ordEffDesc'=0) s arcimDesc=arcimDesc_"("_ordEffDesc_")" //ypz 070621

	//显示皮试
	s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
	s:##class(Nur.CommonInterface.Order).ifPhcinSkinTest(oeordId,oeoriSub)=1 skinTestFlag="Y" 
    s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
    //ypz 061128 begin
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode="",actDesc=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
    i actDesc'="" s arcimDesc=arcimDesc_"(皮试:"_actDesc_")"
    //ypz 061128
    i (skinTestFlag="Y")!(actCode="YY") d  //ypz 061128
        .s skinTestCtcpDesc=""
        .s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
        .i dhcoriId'="" d
            ..s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)
            ..i skinTestCtcpId'="" s skinTestCtcpDesc=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
        .i (abnorm="N") s arcimDesc=arcimDesc_" (-)" q  //_skinTestCtcpDesc q
        .i (abnorm="Y") s arcimDesc=arcimDesc_" (+)"  //_skinTestCtcpDesc
        .i (abnorm="") s arcimDesc=arcimDesc_" ( )"
	s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    s unitUomId="",unitDesc="" //ypz 060427
    i doseQty'="" d
        .s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
        .i $p(doseQty,".",1)="" s doseQty="0"_doseQty
    i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    s dose=doseQty_" "_unitDesc
    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
    i oecprId'="" s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	i phcfrId'="" s phcfrCode=$p(^PHCFR(phcfrId),"^",3) //ypz 070418 统一取
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7) ;OEORI_Instr_DR
    i phcinId'="" s phcinDesc=$p($g(^PHCIN(phcinId)),"^",2)  ////,phcinCode=$p($g(^PHCIN(phcinId)),"^",1)

    s oriNote=""
    f i=1:1:+$g(^OEORD(oeordId,"I",oeoriSub,"DEP",0)) d
    	.i oriNote'="" s oriNote=oriNote_" "
    	.s oriNote=oriNote_(^OEORD(oeordId,"I",oeoriSub,"DEP",i))
    s arcimStr=arcimDesc_"^"_dose_"^"_$g(oecprDesc)_"^"_$g(phcfrCode)_"^"_$g(phcinDesc)_"^"_oriNote  //ypz 070204"|"->"^"
    q arcimStr
}

ClassMethod UpdateExecStat(itmjs As %Library.String = "", itmjsex As %Library.String = "", param As %String, skinTestCode As %String)
{
    //n oeordId,oeoriSub,ok,arcicId,oeoriId,unit,num,uom,uomid,stat,statid,usr,ssusr,ctpcpId,dat,tim,ret  ;xuqy 2005-04-20
    n (itmjs,itmjsex,param,skinTestCode)
    s newid=""
    s skinTestCode=$g(skinTestCode)
    s ok=1
    s exeMark=$p(param,"^",1)  ;标记:Y/S/X 
    s oeoriId=$p(param,"^",4)    ;Oeori_rowid
    s arcicId=$p(param,"^",5)   ;判断是否为输血类或其它处置/治疗类 
    
    s now=$zt($p($h,",",2))
    
    i exeMark="X" d            ;如果是停止医嘱
        .s men=$p(param,"^",3)
        .&sql(select ssusr_name into :per from ss_user where ssusr_initials=:men)
        .s ret=$$select^MVBOEITM(oeoriId)  ;取出原有数据
        .s PLIST(122)=per_"^"_now   ;添加记录到字段oeori_userauthorise
        .s ok=$$update^MVBOEITM(oeoriId)   ;添加记录完成
    
    i exeMark="S" d            ;如果是长期医嘱或处置/治疗类 
        .i (arcicId=90)!(arcicId=228) d  ;如果是输血类或其它处置/治疗类?在此执行
            ..s statid=7    ;完成状态设为完成(7为完成)
            ..s usr=$p(param,"^",3)   ;执行人姓名和ctpcpId码
            ..&sql(select SSUSR_CareProv_DR,SSUSR_Name into :ctpcpId,:userName from ss_user where ssusr_initials=:usr)
            ..s dat=+$h,tim=$p($h,",",2)   ;执行的日期和时间
            ..s PLIST(26)=dat,PLIST(26)=dat,PLIST(27)=tim,PLIST(35)=$h,PLIST(37)=ctpcpId,PLIST(40)=7
            ..s PLIST(41)=0,PLIST(42)=0,PLIST(43)="TB"_$c(1)_"To Bill",PLIST(46)=dat,PLIST(47)=tim
            ..s ok=$$insert^MVBOEEXE(oeoriId)
        .e  d
            ..s men=$p(param,"^",3)
            ..&sql(select ssusr_name into :per from ss_user where ssusr_initials=:men)
            ..s ret=$$select^MVBOEITM(oeoriId)  ;取出原有数据
            ..s PLIST(122)=per_"^"_now   ;添加记录到字段oeori_userauthorise
            ..s ok=$$update^MVBOEITM(oeoriId)   ;添加记录完成
    ;如果是即刻医嘱或处置/治疗类    ;Y^1^完成^777^8412||395^49
    i exeMark="Y" d 
        .s ok=0
        .s userId=$p(param,"^",4)  //,usr=$g(usr)   ;执行人姓名和ctpcpId码
        .//s arcicId=$p(param,"^",6)
        .s oeoriId=$p(param,"^",5)         ;医嘱RowId或医嘱执行RowId
        .s seatNo=$p(param,"^",7)
        .s userDeptId=$p(param,"^",8) //ypz 070125
        .s queryTypeCode=$p(param,"^",9) //ypz 070528
        .s curDate=+$h,curTime=$p($h,",",2)   ;执行的日期和时间
        .s execDate=$p(param,"^",10)
        .i execDate'=""  s execDate=$$$zdh(execDate,4)
        .i execDate="" s execDate=curDate
        .s execTime=$p(param,"^",11)
        .i execTime'="" s execTime=$zth(execTime)
        .i execTime="" s execTime=curTime
        .s execTime=+execTime
        .i ((execDate>curDate)!((execDate=curDate)&(execTime>curTime))) d
            ..s execDate=curDate,execTime=curTime
        .s wardId=""
        .i userDeptId'="" s wardId=$O(^PAWARD(0,"WARD_LocationDR",userDeptId,""),-1)
        .s oeordId=$p($g(oeoriId),"||",1)
        .s oeoriSub=$p($g(oeoriId),"||",2)
        .s oeoreSub=$p($g(oeoriId),"||",3)  //ypz 060308
        .s oeoriId=oeordId_"||"_oeoriSub //ypz 060308
        .i ($g(oeordId)="")!($g(oeoriSub)="") s ok="医嘱项不能为空!" q
		.s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
		.s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
		.;i (oeordId="62")&(oeoriSub="2") s ^tmeo245(1)=execDate_"^"_sttDate_"^"_execTime_"^"_sttTime
		.//i ((execDate<sttDate)!((execDate=sttDate)&(execTime<sttTime))) s ok="执行时间不应大于开始时间!" q
        .s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2) //ypz 061113
        .i arcimId="" s ok="无医嘱项!" q  //ypz 061113
        .s arcicId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10) //ypz 061113
        .s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2)
        .s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8) //ypz 060707自备药
        .i oecprId="" s ok="无医嘱优先级!" q
        .s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId) //ypz 070413
        .i oecprCode="" s ok="无医嘱优先级!" q //ypz 070413
        .//s oecprDesc=$p($g(^OECPR(oecprId)),"^",2) //ypz 070413
        .//s ^TMPNurOPDebug(oeoriId,1)="/1:"
        .s canDo=0
        .//i (admType'="I")&(oecprDesc'["自备药") s canDo=..CanUpdateExec(oeoriId,userId) //ypz 070413
        .s ordstat=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)
    	.s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
	    .q:((ordstat="D")&(oeoriBilled'="P"))!(ordstat="U")!(ordstat="C")
        .i (admType'="I")&(oecprCode'["OM")&(oecprCode'["OMST") s canDo=..CanUpdateExec(oeoriId,userId) //ypz 070413
        .i (canDo'=0)&(canDo'="-1")&(canDo'="-2") s ok=canDo q
        .s unit=$p(param,"^",2)
        .s num=+$p(unit," ",1)
        .s uom=$p(unit," ",2)
        .i (num[".")&(num<1) s num="."_$p($g(num),".",2)
        .;&sql(select ctuom_rowid into :uomid from ct_uom where ctuom_desc=:uom)
        .;s uomid=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(uom),"")) ,uomid=$g(uomid)
        .;s uomid=$o(^CT("UOM",0,"Desc",uom,"")) ,uomid=$g(uomid)
        .i uom="" d
            ..s uomid=""
        .e  d
            ..s uomid=$o(^CT("UOM",0,"Desc",$$UPPER^SSUTIL4(uom),"")) ,uomid=$g(uomid)
        .s stat=$p(param,"^",3),stat=$g(stat) ;完成状态
        .;&sql(select stat_rowid into :statid from OEC_Order_AdminStatus where stat_desc=:stat)
        .////????s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
        .////????i (dhcoriId'="")&($p(^DHCORDItem(dhcoriId,1),"^",1)="A") s ok="该医嘱已通过退费审核!不能执行!" q
        .//s ^TMPNurOPDebug(oeoriId,2)="/2"
        .
        .s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)  //皮试
        .s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
        .//ypz 061128 begin
        .s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
        .s actCode=""
        .i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
        .//ypz 061128
        .//s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2) //,skinTestInstr=""
        .//i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr"))
        .s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
        .
        .//i ((skinTestFlag="Y")!(actCode="YY"))&(stat'="过敏")&(abnorm="") d
            .//.////s setRet=..SetSkinTestResult(oeordId_"||"_oeoriSub,"N")
        .//ypz 070914//i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&((skinTestFlag="Y")!(actCode="YY"))&(abnorm="")  s ok="未皮试医嘱不能执行!"  q
        .s statid=$o(^OEC("STAT",0,"Desc",$$ALPHAUP^SSUTIL4(stat),""))
        .
        .//&js<alert("come in class "+"#(userId)#"+"/");>
        .;&sql(select ssusr_careprov_dr,ssusr_name into :ctpcpId,:userName from ss_user where ssusr_initials=:usr)
        .//s ssusr=$o(^SSU("SSUSR",0,"SSUSR_Initials",$$ALPHAUP^SSUTIL4(usr),""))
        .//s ssusr=$g(ssusr)
        .s ctpcpId=$p(^SSU("SSUSR",userId),"^",14) //SSUSR_CareProv_DR
        .//s ^TMPNurOPDebug(oeoriId)=^TMPNurOPDebug(oeoriId)_"3/"_ctpcpId
        .i ctpcpId="" s ok="请以医护人员身份登录后操作!" q //ypz 060430 用户不是医护人员时提示
        .;s userName=$p(^SSU("SSUSR",ssusr),"^",2)
        .
        .s feeRetStr="",EpisodeID=+^OEORD(oeordId)
        .i admType="I" d 
        	..q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'=""
        	
        	..i oeoreSub'="" d
        	...s insAttStr=..GetAttOrdStr(oeoriId_"||"_oeoreSub)
        	..e  s insAttStr=..GetAttOrdStr(oeoriId)
        	..q:insAttStr=""
        	..//s ^TMPNurOPDebug(oeordId_"||"_oeoriSub,32)=insAttStr
        	..s addAmount=0
        	..f iAtt=1:1:$l(insAttStr,"^") d
        		...s attItem=$p(insAttStr,"^",iAtt)
        		...s insArcimId=$p(attItem,$c(2))
        		...s insQty=$p(attItem,$c(2),2)
        		...s patType=$p(^PAADM(EpisodeID,1),"^",6)
        		...s insType=$p(^PAADM(EpisodeID,1),"^",7)
        		...s retPrice=##class(web.UDHCJFPRICE).GetOrderPrice(patType,insType,insArcimId,+$h,"","","","")
        		...s addAmount=addAmount+(insQty*retPrice)
        	..//s ^TMPNurOPDebug(oeordId_"||"_oeoriSub,"add")=addAmount
        	..s feeRetStr=##Class(web.UDHCJFARREARSMANAGE).CheckArrears(EpisodeID, addAmount,"OE")
        .//s ^TMPNurOPDebug(oeordId_"||"_oeoriSub,4)=feeRetStr
        .i ($p(feeRetStr,"^",5)="C")&($p(feeRetStr,"^",7)="N") s ok="费用不足,不能执行!" q
        .
        .i ($o(^OEORD(oeordId,"I",oeoriSub,"X",0))="")!((oeoreSub'="")&&('$d(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)))) d  //无执行记录
            ..//&js<alert("come in oeore i "+"#(oeordId)#"+"/"+"#(oeoriSub)#");>
            ..s PLIST(0)=oeoriId
            ..s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate //ypz 060428
            ..s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime //ypz 060428
            ..;s PLIST(35)=$h   ;OEORE_StDateTime
            ..s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
            ..s PLIST(40)=statid   ;状态OEORE_Order_Status_DR
            ..s PLIST(41)=0    ;OEORE_PhQtyIss
            ..s PLIST(42)=num      ;剂量OEORE_QtyAdmin
            ..s PLIST(43)="TB"  ;_$c(1)_"To Bill"  ;OEORE_Billed
            ..s PLIST(44)=uomid    ;单位OEORE_CTUOM_DR
            ..s PLIST(46)=execDate      ;日期OEORE_DateExecuted
            ..s PLIST(47)=execTime      ;时间OEORE_TimeExecuted
            ..s PLIST(50)=seatNo   ;OEORE_SignFile 座位号
            ..//s ok=$$insert^MVBOEEXE(oeoriId) ;
            ..&sql(insert into OE_OrdExec Values PLIST())
            ..i SQLCODE s ok="执行记录插入有误!"
            ..s oeoreId=$g(%ROWID)
        .e  d  //有执行记录
        ..i admType="I",oeoreSub="" d  //住院非PDA执行
        ...s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))  q:oeoreSub=""  d
        ....s oeoreId=oeoriId_"||"_oeoreSub  //不是1了
        ....s curCtcpId=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)   ;//1 changed to oeoreSub !! OEORE_CTPCP_DR
        ....i $g(curCtcpId)="" d
        .....s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
        .....//s PLIST(40)=statid   ;状态OEORE_Order_Status_DR
        .....s PLIST(42)=num      ;剂量OEORE_QtyAdmin
        .....s PLIST(44)=uomid    ;单位OEORE_CTUOM_DR
        .....s PLIST(46)=execDate      ;日期OEORE_DateExecuted 
        .....s PLIST(47)=execTime      ;时间OEORE_TimeExecuted
        .....s PLIST(50)=seatNo   ;OEORE_SignFile 座位号 //ypz 060531    //OEORE_Order_Status_DR=:statid,
        .....&sql(update Oe_ordexec set OEORE_CTPCP_DR=:ctpcpId,
                   OEORE_QtyAdmin=:num,OEORE_CTUOM_DR=:uomid,
                   OEORE_DateExecuted=:execDate,
                   OEORE_TimeExecuted=:execTime,
                   OEORE_SignFile=:seatNo
                    where oeore_rowid=:oeoreId)
        .....i SQLCODE s ok="执行记录修改有误!"
        .....i SQLCODE=0 s $P(^OEORD($P(oeoreId,"||",1),"I",$P(oeoreId,"||",2),"X",$P(oeoreId,"||",3)),"^",16)=statid
        .....s ok=..UpdateDHCOeordExec(oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode)
        .....i ok'=0 q
        ..e  d  ////住院PDA执行或门急诊
        ...i oeoreSub="" s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
        ...s oeoreId=oeoriId_"||"_oeoreSub  //不是1了
        ...//w "oeoreId="_oeoreId,!
        ...//s ret=$$select^MVBOEEXE(oeoreId)  ;取出原有数据
        ...//s ^TMPNurOPDebug(oeordId,oeoriSub,11)=oeordId_"/"_oeoriSub_"/"_oeoreSub
        ...s curCtcpId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",15)   ;//1 changed to oeoreSub !! OEORE_CTPCP_DR
        ...//&js<alert("come in oeore else "+"#(oeordId)#"+"/"+"#(oeoriSub)#"+"/"+"#(curCtcpId)#"+"/");>
        ...;i $g(PLIST(37))="" d
        ...i $g(curCtcpId)="" d
        ....;i (num[".")&(num<1) s num="."_$p($g(num),".",3)
        ....s PLIST(37)=ctpcpId      ;执行人OEORE_CTPCP_DR
        ....s PLIST(40)=statid   ;状态OEORE_Order_Status_DR
        ....s PLIST(42)=num      ;剂量OEORE_QtyAdmin
        ....s PLIST(44)=uomid    ;单位OEORE_CTUOM_DR
        ....s PLIST(46)=execDate      ;日期OEORE_DateExecuted 
        ....s PLIST(47)=execTime      ;时间OEORE_TimeExecuted
        ....s PLIST(50)=seatNo   ;OEORE_SignFile 座位号 //ypz 060531
        ....//&js<alert("come in oeori else "+"#(num)#"+"/"+"#(ctpcpId)#"+"/"+"#(statid_" "_uomid_" "_dat_"-"_tim)#"+"/");>
        ....////ypz add .
        ....//s ok=$$update^MVBOEEXE(oeoreId)     ;更新数据
        ....&sql(update Oe_ordexec set OEORE_CTPCP_DR=:ctpcpId,OEORE_Order_Status_DR=:statid,
                   OEORE_QtyAdmin=:num,OEORE_CTUOM_DR=:uomid,
                   OEORE_DateExecuted=:execDate,
                   OEORE_TimeExecuted=:execTime,
                   OEORE_SignFile=:seatNo
                    where oeore_rowid=:oeoreId)
        ....i SQLCODE s ok="执行记录修改有误!"
        .//s ^TMPNurOPDebug(oeoriId)=^TMPNurOPDebug(oeoriId)_"/4"_ok
        .i ok'=0 q
        .s resStr=0
        .i (admType'="I")&(oeoreSub'="")&(canDo=0)&(oecprCode'["OM")&(oecprCode'["OMST") s resStr=..AdjustStock(oeoreId) //ypz 070413
        .i (resStr'=-1)&(resStr'=-2) s ok=resStr
        .i admType="I" d 
        ..s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
        ..s oeoreId=oeoriId_"||"_oeoreSub
        .i ok'=0 q
        .s ok=..UpdateDHCOeordExec(oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode)
        .//i oeoreId'="" d //修改执行扩展表
        	.//.s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
        	.//.i dhcoreId="" d
        	    .//..&sql(insert into DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_Ssuser_Dr,DHCORE_OEORE_Date,DHCORE_OEORE_Time,DHCORE_CTLOC_Dr,DHCORE_QueryCode) Values(:oeoreId,:userId,:curDate,:curTime,:userDeptId,:queryTypeCode))
        	.//.e  d
        	    .//..&sql(update DHC_OE_OrdExec set DHCORE_Ssuser_Dr=:userId,DHCORE_OEORE_Date=:curDate,DHCORE_OEORE_Time=:curTime,DHCORE_CTLOC_Dr=:userDeptId,DHCORE_QueryCode=:queryTypeCode where DHCORE_RowId=:dhcoreId)
        	.//.s ok=SQLCODE
        .i ok'=0 q
        .i admType="I" d 
        	..q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'=""
        	..q:insAttStr=""
         	..s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
         	..q:phcinId=""
        	..s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
        	..q:phcfrId=""
        	..s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
        	..//s ^TMPNurOPDebug(oeordId,oeoriSub,34)=arcimId_"/"_userDeptId
       		..TStart
        	..s isAbort=0
        	..f iInst=1:1:$l(insAttStr,"^")  d
        		...s insItem=$p(insAttStr,"^",iInst)
        		...s arcimId=$p(insItem,$c(2)),qty=$p(insItem,$c(2),2)
        		...//s ^TMPNurOPDebug(oeordId,oeoriSub,35)=userId_"/"_oeordId_"/"_arcimId_"/"_qty_"/"_userDeptId
        		...;s retInsord=##Class(web.DHCCLCom).InsertOrdItem(userId, oeordId, arcimId,3,qty,userDeptId, "", "", "","")
        		...//s ^TMPNurOPDebug(oeordId,oeoriSub,36)=retInsord
        		...;i retInsord'=0 s isAbort=1
        								
					
        		...s retInsord=..InsertOrdItems(userId, oeordId, arcimId,3,qty,userDeptId, "", "", "","","Y")
        		...//s ^TMPNurOPDebug(oeordId,oeoriSub,36)=retInsord
        		...//i retInsord'=0 s isAbort=1
				...//返回用法关联医嘱RowID//执行医嘱与新插入医嘱关联^DHCNurExecAttachOrd
        		...s retok=$P(retInsord,"^",1)
        		...s AttOrdId=$P(retInsord,"^",2)
        		...i retok=0 d
        		....i oeoreSub'="" d
        		.....s ^DHCNurExecAttachOrd(oeordId_"||"_oeoriSub_"||"_oeoreSub,AttOrdId)=""
        		....e  s ^DHCNurExecAttachOrd(oeordId_"||"_oeoriSub,AttOrdId)=""
        		...i retok'=0 s isAbort=1
        	
        	..i isAbort TRollBack  s insTimes=0 q
        	..TCommit
        	..s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
        	..s insTimes=phfactor-maxPhfactor
        	..i insTimes<0 s insTimes=0
        	..i insTimes>0 s ^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",phfactor)=$g(inattList("F"))
        	..q //下面程序不执行
        	..//s ^TMPNurOPDebug(oeoriId)=^TMPNurOPDebug(oeoriId)_"/5"
        	..//k ^TMPNurOPDebug
        	..k inattList
        	..s inattId="",itmmstStr=""
        	..f  s inattId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",phcinId,inattId))  q:inattId=""   d
        	    ...s inattType=$p(^DHCOEInstrAttachOrd(inattId),"^",7)
        	    ...q:inattType=""
        	    ...s inPhcfrId=$p(^DHCOEInstrAttachOrd(inattId),"^",2)
        	    ...q:(inPhcfrId'="")&(phcfrId'=inPhcfrId) //频次不对
        	    ...i $d(inattList(inattType,+inPhcfrId))=0 s inattList(inattType,+inPhcfrId)=""
        	    ...i inattList(inattType,+inPhcfrId)'="" s inattList(inattType,+inPhcfrId)=inattList(inattType,+inPhcfrId)_"^"
        	    ...s inattList(inattType,+inPhcfrId)=$g(inattList(inattType,+inPhcfrId))_inattId
        	    ...
        	..//m ^TMPNurOPDebug("inList")=inattList
        	..s inattType=""
        	..f  s inattType=$o(inattList(inattType)) q:(inattType="")!(ok'=0)  d
        		...i $d(inattList(inattType,0)) s inattList(inattType)=inattList(inattType,0)  //未指定频次
        		...i $d(inattList(inattType,phcfrId)) s inattList(inattType)=inattList(inattType,phcfrId)  //有指定频次
        		...//s ^TMPNurOPDebug("in")=$g(^TMPNurOPDebug("in"))_"///"_oeoriId_":"_inattType_"/"_inattList(inattType)_"/"_phcinId_"/"_phfactor_"/"_userId_"/"_oeordId_"/"_userDeptId
        	..s ok=..insertAttOrd(.inattList,phcinId,phfactor,userId, oeordId,userDeptId)

        //s retval=itmjs_"('"_$ZCVT(ok,"O","JS")_"');"  //ypz 060615
        //i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(ok,"O","JS")_"');"  //060615
        //&javascript<#(retval)#>  //060615
    q ok
}

ClassMethod GetAttOrdStr0307(oeoriId)
{
	//w ##Class(web.DHCNurCom).GetAttOrdStr("388422||28")
	n (oeoriId)
	q:oeoriId=""
	s oeordId=+oeoriId,oeoriSub=$p($g(oeoriId),"||",2)
	q:(oeordId=0)!(oeoriSub="") ""
    s oeoriId=oeordId_"||"_oeoriSub
	//s ^TMPNurOPDebug(oeoriId)=^TMPNurOPDebug(oeoriId)_"/5"
    ;q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="" "" // noted wxl 090411
    
    //k ^TMPNurOPDebug
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    q:phcinId="" ""
    s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2) ,skinTestInstr="" // + wxl 090411
    i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr")) // + wxl 090411
	q:($p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="")&(("^"_skinTestInstr_"^")'[("^"_+phcinId_"^")) // + wxl 090411
    //i ("^"_$g(^DHCCLNurseExec("VarDef","CQYZQY","PhcIn"))_"^")'[("^"_phcinId_"^") q ""
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    q:phcfrId="" ""
    ;---------------by yys 2009.12.11 每周几次的用法不能直接取频率要素---------------
    s WeekFlag=$P($g(^PHCFR(+$g(phcfrId),"DHC")),"^",1)
    i WeekFlag=1 s phfactor=1
    e  s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
    ;s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
    ;---------------------------------------------------------------------------------
    k inattList
    //s ^TMPNurOPDebug("att",1)=phcinId_"/"_phcfrId_"/"_^PHCFR(phcfrId)
    s inattId="",itmmstStr=""
    s adm=+($p(^OEORD(oeordId),"^")) //lijingwei 20091109
    s patloc=+($p(^PAADM(adm),"^",70)) //lijingwei 20091109
    s patloclink=$p($g(^PAWARD(patloc)),"^",5) 
    f  s inattId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",phcinId,inattId))  q:inattId=""   d
        .s inattType=$p(^DHCOEInstrAttachOrd(inattId),"^",7)
        .q:inattType=""
        .s inattloc=$p(^DHCOEInstrAttachOrd(inattId),"^",8) //lijingwei 20091109
        .q:(inattloc'="")&(inattloc[patloclink) //lijingwei 20091109
        .//按维护的病区插入用法关联的医嘱
        .s execlocId=$p(^DHCOEInstrAttachOrd(inattId),"^",9)
        .//q:(execlocId'="")&(execlocId'=patloclink)
        .q:execlocId'=patloclink
        .s inPhcfrId=$p(^DHCOEInstrAttachOrd(inattId),"^",2)
        .q:(inPhcfrId'="")&(phcfrId'=inPhcfrId) //频次不对
        .//s ^TMPNurOPDebug("att",2)="in/ok"
        .i $d(inattList(inattType,+inPhcfrId))=0 s inattList(inattType,+inPhcfrId)=""
        .i inattList(inattType,+inPhcfrId)'="" s inattList(inattType,+inPhcfrId)=inattList(inattType,+inPhcfrId)_"^"
        .s inattList(inattType,+inPhcfrId)=$g(inattList(inattType,+inPhcfrId))_inattId
	//s ^TMPNurOPDebug("att",3)=phcinId_"/"_phcfrId_"/"_^PHCFR(phcfrId)
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:(inattType="")  d
        .i $d(inattList(inattType,0)) s inattList(inattType)=inattList(inattType,0)  //未指定频次
        .i $d(inattList(inattType,phcfrId)) s inattList(inattType)=inattList(inattType,phcfrId)  //有指定频次
        .//s ^TMPNurOPDebug("in")=$g(^TMPNurOPDebug("in"))_"///"_oeoriId_":"_inattType_"/"_inattList(inattType)_"/"_phcinId_"/"_phfactor_"/"_userId_"/"_oeordId_"/"_userDeptId

    ;b /////inner
    i ('$d(^DHCInstrAttOrd(+$h))) k ^DHCInstrAttOrd($h-7) //清除一周前数据
	s insTimes=0
    //s inattType="F"
    //s inattIdStr=$g(inattList(inattType))
    k insOrdList,normInsOrdList
    s prefiTimes=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"D",""),-1)
    i $g(prefiTimes)="" s oneTimes=1
    e  s oneTimes=0
    s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
	s insTimes=phfactor-maxPhfactor
    i insTimes<0 s insTimes=0
    s normTimes=phfactor
    //s ^xxxx("lol",oeordId)=insTimes_"#"_normTimes_"#"_phfactor_"#"_maxPhfactor
    //w "maxPhfactor="_maxPhfactor_"/"_insTimes_"/"_normTimes,!
    i $d(inattList("F")) s inattList("F","times")=insTimes,normTimes=normTimes-insTimes
    i $d(inattList("N")) s inattList("N","times")=normTimes
    i $d(inattList("D")) s inattList("D","times")=oneTimes
    //m ^TMPNurOPDebug("att",4)=inattList
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:inattType=""  d
    	.q:$g(inattList(inattType,"times"))<1
    	.//q:$g(inattList(inattType))=""
    	.f iAtt=1:1:$l(inattList(inattType),"^") d
        	..s inattId=$p(inattList(inattType),"^",iAtt)
        	..q:inattId=""
        	..s arcimId=$p(^DHCOEInstrAttachOrd(inattId),"^",4)
        	..q:arcimId=""
        	..s qty=inattList(inattType,"times")*$p(^DHCOEInstrAttachOrd(inattId),"^",5)
        	..q:+qty=0
        	..s insOrdList(inattType,arcimId)=$g(insOrdList(inattType,arcimId))+qty
	//m ^TMPNurOPDebug("att",5)=insOrdList
    s inattType="",retStr=""
    f  s inattType=$o(insOrdList(inattType)) q:(inattType="")  d
    	.s arcimId=""
    	.f  s arcimId=$o(insOrdList(inattType,arcimId)) q:(arcimId="")  d
        	..s qty=insOrdList(inattType,arcimId)
        	..//w inattType_"/"_qty_"/"_arcimId_"//"_retStr,!
        	..i retStr'="" s retStr=retStr_"^"
        	..s retStr=retStr_arcimId_$c(2)_qty //s ^TMPNurOPDebug("res",inattType,arcimId)=qty
    q retStr
}

ClassMethod GetAttOrdStr20140303(oeoriId)
{
	//w ##Class(web.DHCNurCom).GetAttOrdStr("388422||28")
	n (oeoriId)
	q:oeoriId=""
	s oeordId=+oeoriId,oeoriSub=$p($g(oeoriId),"||",2)
	q:(oeordId=0)!(oeoriSub="") ""
    s oeoriId=oeordId_"||"_oeoriSub
	//s ^TMPNurOPDebug(oeoriId)=^TMPNurOPDebug(oeoriId)_"/5"
    ;q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="" "" // noted wxl 090411
    
    //k ^TMPNurOPDebug
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    q:phcinId="" ""
    s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2) ,skinTestInstr="" // + wxl 090411
    i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr")) // + wxl 090411
	q:($p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="")&(("^"_skinTestInstr_"^")'[("^"_+phcinId_"^")) // + wxl 090411
    //i ("^"_$g(^DHCCLNurseExec("VarDef","CQYZQY","PhcIn"))_"^")'[("^"_phcinId_"^") q ""
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    q:phcfrId="" ""
    ;---------------by yys 2009.12.11 每周几次的用法不能直接取频率要素---------------
    s WeekFlag=$P($g(^PHCFR(+$g(phcfrId),"DHC")),"^",1)
    i WeekFlag=1 s phfactor=1
    e  s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
    ;s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
    ;---------------------------------------------------------------------------------
    k inattList
    //s ^TMPNurOPDebug("att",1)=phcinId_"/"_phcfrId_"/"_^PHCFR(phcfrId)
    s inattId="",itmmstStr=""
    s adm=+($p(^OEORD(oeordId),"^")) //lijingwei 20091109
    s patloc=+($p(^PAADM(adm),"^",70)) //lijingwei 20091109
    s patloclink=$p($g(^PAWARD(patloc)),"^",5) 
    f  s inattId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",phcinId,inattId))  q:inattId=""   d
        .s inattType=$p(^DHCOEInstrAttachOrd(inattId),"^",7)
        .q:inattType=""
        .s inattloc=$p(^DHCOEInstrAttachOrd(inattId),"^",8) //lijingwei 20091109
        .q:(inattloc'="")&(inattloc[patloclink) //lijingwei 20091109
        .//按维护的病区插入用法关联的医嘱
        .s execlocId=$p(^DHCOEInstrAttachOrd(inattId),"^",9)
        .//q:(execlocId'="")&(execlocId'=patloclink)
        .q:execlocId'=patloclink
        .s inPhcfrId=$p(^DHCOEInstrAttachOrd(inattId),"^",2)
        .q:(inPhcfrId'="")&(phcfrId'=inPhcfrId) //频次不对
        .//s ^TMPNurOPDebug("att",2)="in/ok"
        .i $d(inattList(inattType,+inPhcfrId))=0 s inattList(inattType,+inPhcfrId)=""
        .i inattList(inattType,+inPhcfrId)'="" s inattList(inattType,+inPhcfrId)=inattList(inattType,+inPhcfrId)_"^"
        .s inattList(inattType,+inPhcfrId)=$g(inattList(inattType,+inPhcfrId))_inattId
	//s ^TMPNurOPDebug("att",3)=phcinId_"/"_phcfrId_"/"_^PHCFR(phcfrId)
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:(inattType="")  d
        .i $d(inattList(inattType,0)) s inattList(inattType)=inattList(inattType,0)  //未指定频次
        .i $d(inattList(inattType,phcfrId)) s inattList(inattType)=inattList(inattType,phcfrId)  //有指定频次
        .//s ^TMPNurOPDebug("in")=$g(^TMPNurOPDebug("in"))_"///"_oeoriId_":"_inattType_"/"_inattList(inattType)_"/"_phcinId_"/"_phfactor_"/"_userId_"/"_oeordId_"/"_userDeptId

    ;b /////inner
    i ('$d(^DHCInstrAttOrd(+$h))) k ^DHCInstrAttOrd($h-7) //清除一周前数据
	s insTimes=0
    //s inattType="F"
    //s inattIdStr=$g(inattList(inattType))
    k insOrdList,normInsOrdList
    s prefiTimes=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
    i $g(prefiTimes)="" s oneTimes=1
    e  s oneTimes=0
    s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
	s insTimes=phfactor-maxPhfactor
    i insTimes<0 s insTimes=0
    s normTimes=phfactor
    //s ^xxxx("lol",oeordId)=insTimes_"#"_normTimes_"#"_phfactor_"#"_maxPhfactor
    //w "maxPhfactor="_maxPhfactor_"/"_insTimes_"/"_normTimes,!
    i $d(inattList("F")) s inattList("F","times")=insTimes,normTimes=normTimes-insTimes
    i $d(inattList("N")) s inattList("N","times")=normTimes
    i $d(inattList("D")) s inattList("D","times")=oneTimes
    //m ^TMPNurOPDebug("att",4)=inattList
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:inattType=""  d
    	.q:$g(inattList(inattType,"times"))<1
    	.//q:$g(inattList(inattType))=""
    	.f iAtt=1:1:$l(inattList(inattType),"^") d
        	..s inattId=$p(inattList(inattType),"^",iAtt)
        	..q:inattId=""
        	..s arcimId=$p(^DHCOEInstrAttachOrd(inattId),"^",4)
        	..q:arcimId=""
        	..s qty=inattList(inattType,"times")*$p(^DHCOEInstrAttachOrd(inattId),"^",5)
        	..q:+qty=0
        	..s insOrdList(inattType,arcimId)=$g(insOrdList(inattType,arcimId))+qty
	//m ^TMPNurOPDebug("att",5)=insOrdList
    s inattType="",retStr=""
    f  s inattType=$o(insOrdList(inattType)) q:(inattType="")  d
    	.s arcimId=""
    	.f  s arcimId=$o(insOrdList(inattType,arcimId)) q:(arcimId="")  d
        	..;s qty=insOrdList(inattType,arcimId)
        	..s qty=1
        	..//w inattType_"/"_qty_"/"_arcimId_"//"_retStr,!
        	..i retStr'="" s retStr=retStr_"^"
        	..s retStr=retStr_arcimId_$c(2)_qty //s ^TMPNurOPDebug("res",inattType,arcimId)=qty
    q retStr
}

ClassMethod GetAttOrdStr1(oeoriId)
{
	//w ##Class(web.DHCNurCom).GetAttOrdStr("388422||28")
	n (oeoriId)
	q:oeoriId=""
	s oeordId=+oeoriId,oeoriSub=$p($g(oeoriId),"||",2)
	q:(oeordId=0)!(oeoriSub="") ""
    s oeoriId=oeordId_"||"_oeoriSub
	//s ^TMPNurOPDebug(oeoriId)=^TMPNurOPDebug(oeoriId)_"/5"
    q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="" ""
    //k ^TMPNurOPDebug
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    q:phcinId="" ""
    //i ("^"_$g(^DHCCLNurseExec("VarDef","CQYZQY","PhcIn"))_"^")'[("^"_phcinId_"^") q ""
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    q:phcfrId="" ""
    s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
    k inattList
    //s ^TMPNurOPDebug("att",1)=phcinId_"/"_phcfrId_"/"_^PHCFR(phcfrId)
    s inattId="",itmmstStr=""
    f  s inattId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",phcinId,inattId))  q:inattId=""   d
        .s inattType=$p(^DHCOEInstrAttachOrd(inattId),"^",7)
        .q:inattType=""
        .s inPhcfrId=$p(^DHCOEInstrAttachOrd(inattId),"^",2)
        .q:(inPhcfrId'="")&(phcfrId'=inPhcfrId) //频次不对
        .//s ^TMPNurOPDebug("att",2)="in/ok"
        .i $d(inattList(inattType,+inPhcfrId))=0 s inattList(inattType,+inPhcfrId)=""
        .i inattList(inattType,+inPhcfrId)'="" s inattList(inattType,+inPhcfrId)=inattList(inattType,+inPhcfrId)_"^"
        .s inattList(inattType,+inPhcfrId)=$g(inattList(inattType,+inPhcfrId))_inattId
	//s ^TMPNurOPDebug("att",3)=phcinId_"/"_phcfrId_"/"_^PHCFR(phcfrId)
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:(inattType="")  d
        .i $d(inattList(inattType,0)) s inattList(inattType)=inattList(inattType,0)  //未指定频次
        .i $d(inattList(inattType,phcfrId)) s inattList(inattType)=inattList(inattType,phcfrId)  //有指定频次
        .//s ^TMPNurOPDebug("in")=$g(^TMPNurOPDebug("in"))_"///"_oeoriId_":"_inattType_"/"_inattList(inattType)_"/"_phcinId_"/"_phfactor_"/"_userId_"/"_oeordId_"/"_userDeptId

    /////inner
    i ('$d(^DHCInstrAttOrd(+$h))) k ^DHCInstrAttOrd($h-7) //清除一周前数据
	s insTimes=0
    //s inattType="F"
    //s inattIdStr=$g(inattList(inattType))
    k insOrdList,normInsOrdList
    s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
	s insTimes=phfactor-maxPhfactor
    i insTimes<0 s insTimes=0
    s normTimes=phfactor
    //w "maxPhfactor="_maxPhfactor_"/"_insTimes_"/"_normTimes,!
    i $d(inattList("F")) s inattList("F","times")=insTimes,normTimes=normTimes-insTimes
    i $d(inattList("N")) s inattList("N","times")=normTimes
    //m ^TMPNurOPDebug("att",4)=inattList
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:inattType=""  d
    	.q:$g(inattList(inattType,"times"))<1
    	.//q:$g(inattList(inattType))=""
    	.f iAtt=1:1:$l(inattList(inattType),"^") d
        	..s inattId=$p(inattList(inattType),"^",iAtt)
        	..q:inattId=""
        	..s arcimId=$p(^DHCOEInstrAttachOrd(inattId),"^",4)
        	..q:arcimId=""
        	..s qty=inattList(inattType,"times")*$p(^DHCOEInstrAttachOrd(inattId),"^",5)
        	..q:+qty=0
        	..s insOrdList(inattType,arcimId)=$g(insOrdList(inattType,arcimId))+qty
	//m ^TMPNurOPDebug("att",5)=insOrdList
    s inattType="",retStr=""
    f  s inattType=$o(insOrdList(inattType)) q:(inattType="")  d
    	.s arcimId=""
    	.f  s arcimId=$o(insOrdList(inattType,arcimId)) q:(arcimId="")  d
        	..s qty=insOrdList(inattType,arcimId)
        	..//w inattType_"/"_qty_"/"_arcimId_"//"_retStr,!
        	..i retStr'="" s retStr=retStr_"^"
        	..s retStr=retStr_arcimId_$c(2)_qty //s ^TMPNurOPDebug("res",inattType,arcimId)=qty
    q retStr
}

ClassMethod GetAttOrdStr(oeoriId)
{
	n (oeoriId)
	q:oeoriId=""
	s oeordId=+oeoriId,oeoriSub=$p($g(oeoriId),"||",2),chl=$p($g(oeoriId),"||",3)
	q:(oeordId=0)!(oeoriSub="") ""
    s oeoriId=oeordId_"||"_oeoriSub_"||"_chl
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    q:phcinId="" ""
    s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2) ,skinTestInstr="" // + wxl 090411
    i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr")) // + wxl 090411
	q:($p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)'="")&(("^"_skinTestInstr_"^")'[("^"_+phcinId_"^")) // + wxl 090411
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    q:phcfrId="" ""
    ;---------------by yys 2009.12.11 每周几次的用法不能直接取频率要素---------------
    s WeekFlag=$P($g(^PHCFR(+$g(phcfrId),"DHC")),"^",1)
    i WeekFlag=1 s phfactor=1
    e  s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
    ;s phfactor=$p($g(^PHCFR(phcfrId)),"^",2)
    ;---------------------------------------------------------------------------------
    k inattList
    s inattId="",itmmstStr=""
    s adm=+($p(^OEORD(oeordId),"^")) //lijingwei 20091109
    s patloc=+($p(^PAADM(adm),"^",70)) //lijingwei 20091109
    s patloclink=$p($g(^PAWARD(patloc)),"^",5) 
    f  s inattId=$o(^DHCOEInstrAttachOrd(0,"PHCInstr",phcinId,inattId))  q:inattId=""   d
        .s inattType=$p(^DHCOEInstrAttachOrd(inattId),"^",7)
        .q:inattType=""
        .s inattloc=$p(^DHCOEInstrAttachOrd(inattId),"^",8) //lijingwei 20091109
        .q:(inattloc'="")&(inattloc[patloclink) //lijingwei 20091109
        .//按维护的病区插入用法关联的医嘱
        .s execlocId=$p(^DHCOEInstrAttachOrd(inattId),"^",9)
        .q:(execlocId'="")&(execlocId'=patloclink)
        .s inPhcfrId=$p(^DHCOEInstrAttachOrd(inattId),"^",2)
        .q:(inPhcfrId'="")&(phcfrId'=inPhcfrId) //频次不对
        .i $d(inattList(inattType,+inPhcfrId))=0 s inattList(inattType,+inPhcfrId)=""
        .i inattList(inattType,+inPhcfrId)'="" s inattList(inattType,+inPhcfrId)=inattList(inattType,+inPhcfrId)_"^"
        .s inattList(inattType,+inPhcfrId)=$g(inattList(inattType,+inPhcfrId))_inattId
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:(inattType="")  d
        .i $d(inattList(inattType,0)) s inattList(inattType)=inattList(inattType,0)  //未指定频次
        .i $d(inattList(inattType,phcfrId)) s inattList(inattType)=inattList(inattType,phcfrId)  //有指定频次
    i ('$d(^DHCInstrAttOrd(+$h))) k ^DHCInstrAttOrd($h-7) //清除一周前数据
	s insTimes=0
    k insOrdList,normInsOrdList
    s prefiTimes=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
    i $g(prefiTimes)="" s oneTimes=1
    e  s oneTimes=0
    s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
	s insTimes=phfactor-maxPhfactor
    i insTimes<0 s insTimes=0
    s normTimes=1
    
    i $d(inattList("F")) s inattList("F","times")=insTimes,normTimes=normTimes-insTimes
    i $d(inattList("N")) s inattList("N","times")=normTimes
    i $d(inattList("D")) s inattList("D","times")=oneTimes
    i insTimes>0 s ^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",phfactor)=$g(inattList("F"))

    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:inattType=""  d
    	.q:$g(inattList(inattType,"times"))<1
    	.f iAtt=1:1:$l(inattList(inattType),"^") d
        	..s inattId=$p(inattList(inattType),"^",iAtt)
        	..q:inattId=""
        	..s arcimId=$p(^DHCOEInstrAttachOrd(inattId),"^",4)
        	..q:arcimId=""
        	..s number=$p(^DHCOEInstrAttachOrd(inattId),"^",5)
        	..s qty=inattList(inattType,"times")*number
        	..q:+qty=0
        	..s insOrdList(inattType,arcimId)=$g(insOrdList(inattType,arcimId))+qty
    s inattType="",retStr=""
    f  s inattType=$o(insOrdList(inattType)) q:(inattType="")  d
    	.s arcimId=""
    	.f  s arcimId=$o(insOrdList(inattType,arcimId)) q:(arcimId="")  d
        	..s qty=insOrdList(inattType,arcimId)
        	..i retStr'="" s retStr=retStr_"^"

        	..s retStr=retStr_arcimId_$c(2)_qty //s ^TMPNurOPDebug("res",inattType,arcimId)=qty
    q retStr
}

ClassMethod insertAttOrd(inattList, phcinId, phfactor, userId, oeordId, userDeptId)
{
    i ('$d(^DHCInstrAttOrd(+$h))) k ^DHCInstrAttOrd($h-7) //清除一周前数据
    
	s insTimes=0
    //s inattType="F"
    //s inattIdStr=$g(inattList(inattType))
    k insOrdList,normInsOrdList
    s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
	s insTimes=phfactor-maxPhfactor
    i insTimes<0 s insTimes=0
    s normTimes=phfactor-insTimes
    i $d(inattList("F")) s inattList("F","times")=insTimes
    i $d(inattList("N")) s inattList("N","times")=normTimes
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:inattType=""  d
    	.q:$g(inattList(inattType,"times"))<1
    	.//q:$g(inattList(inattType))=""
    	.f iAtt=1:1:$l(inattList(inattType),"^") d
        	..s inattId=$p(inattList(inattType),"^",iAtt)
        	..q:inattId=""
        	..s arcimId=$p(^DHCOEInstrAttachOrd(inattId),"^",4)
        	..q:arcimId=""
        	..s qty=inattList(inattType,"times")*$p(^DHCOEInstrAttachOrd(inattId),"^",5)
        	..q:+qty=0
        	..s insOrdList(inattType,arcimId)=$g(insOrdList(inattType,arcimId))+qty
    //s ^TMPNurOPDebug("ins")=insOrdList
    //m ^TMPNurOPDebug("insAtt")=inattList

    TStart
    s inattType="",isAbort=0
    f  s inattType=$o(insOrdList(inattType)) q:(inattType="")!(isAbort)  d
    	.s arcimId=""
    	.f  s arcimId=$o(insOrdList(inattType,arcimId)) q:(arcimId="")!(isAbort)  d
        	..s qty=insOrdList(inattType,arcimId)
        	..//s ^TMPNurOPDebug("res",inattType,arcimId)=qty
        	..s retInsord=..InsertOrdItems(userId, oeordId, arcimId,3,1,userDeptId, "", "", "","")
        	..i retInsord'=0 s isAbort=1
    i isAbort TRollBack  s insTimes=0 q
    TCommit
    i insTimes>0 s ^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",phfactor)=$g(inattList("F"))
	q 0
}

ClassMethod InsertOrdItems(userId, oeordId, arcimId, oecprId, qty, userDeptId, anaId, anaOpId, billDesc, notes, ifRetRowID = "N") As %String
{
	q:(userId="")!(oeordId="")!(arcimId="")!(oecprId="")!(userDeptId="") -1
	s oldNameSpace=$ZNSPACE
	s dataNameSpace=$LIST(^websys.ConfigurationD(1),12)
	zn dataNameSpace
    //w $zn,!
    //w userId_","_oeordId_","_arcimId_","_userDeptId_","_notes
	k PLIST
	s PLIST(4)=arcimId
	s PLIST(6)=userDeptId  ;OEORI_OrdDept_DR
	s PLIST(10)=1   ;OEC_OrderStatus：1核4停6执
	s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)
	s PLIST(14)=ctcpId  //careProvId ;OEORI_Doctor_DR:
	s PLIST(17)=+$h ;  OEORI_SttDat
	s PLIST(18)=$p($h,",",2)  ;OEORI_SttTim
	s PLIST(23)=oecprId   ;OEORI_Priority_DR:OEC_Priority：3临时，5长期
	s PLIST(29)=qty ;OEORI_PhQtyOrd
	s PLIST(45)=billDesc //OEORI_BillDesc
	s PLIST(55)="Y"  ;OEORI_CoverMainIns  Y
	s PLIST(56)="N"  ;OEORI_PortEquipReq  N
	s PLIST(57)="N"  ;OEORI_AdministerSkinTest N
	s PLIST(75)=userDeptId  //OEORI_RecDep_DR
	s PLIST(76)="TB" //OEORI_Billed

	s PLIST(77)=$$GetSeqNo1(oeordId,+$h)  ;OEORI_SeqNo，每天排序//
	  
	s PLIST(81)=+$h    ;OEORI_Date
	s PLIST(90)=$p($h,",",2)    ;OEORI_TimeOrd
	s PLIST(106)=anaId
	s PLIST(107)=anaOpId
	s PLIST(111)="A" ;OEORI_ResultFlag A
	s PLIST(120)=userId ;OEORI_UserAdd
	s PLIST(121)=userDeptId  ;OEORI_UserDepartment_DR
	s PLIST(141)=userId ;OEORI_UserUpdate！
	s admId=+^OEORD(oeordId)
	s PLIST(161)=$p(^PAADM(admId),"^",4) //OEORI_AdmLoc_DR：病人科室
	s AdmDocCodeDR=$p(^PAADM(admId),"^",9)
	s PLIST(53)=notes //OEORI_DepProcNotes
	s res=$$insert^MVBOEIT0(oeordId,"Y")	
	s oeitm=""
	i res=0 d
	.s oeitm=%ROWID
	.s res=$$InsertDsp^DHCDocOrderCommon(oeitm)
	s $p(^OEORD(+oeitm,"I",$p(oeitm,"||",2),"DHC"),"^",15)=$$GetMedUnitByLoc^DHCDocOrderCommon(AdmDocCodeDR,PLIST(161),PLIST(161),AdmDocCodeDR,oeitm)
	zn oldNameSpace  ; Restore the namespace
	i ifRetRowID="Y" q res_"^"_$G(oeitm)
	q res
GetSeqNo1(oeordId,sttdate)
	;生成序列号,原来的程序有点累最
	;Set err=$$lastseq^MVBOEORD(ord,sttdate)
	;Set LastSeqNo=PLIST(1)
	Set LastSeqNo=$o(^OEORDi(0,"StDtSeqNo",oeordId,sttdate,""),-1)
    i LastSeqNo["." s LastSeqNo=$p(LastSeqNo,".")
	Set SeqNo=+LastSeqNo+1
	Q SeqNo
}

ClassMethod insertAttOrd0307(inattList, phcinId, phfactor, userId, oeordId, userDeptId)
{
    i ('$d(^DHCInstrAttOrd(+$h))) k ^DHCInstrAttOrd($h-7) //清除一周前数据
    
	s insTimes=0
    //s inattType="F"
    //s inattIdStr=$g(inattList(inattType))
    k insOrdList,normInsOrdList
    s maxPhfactor=$o(^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",""),-1)
	s insTimes=phfactor-maxPhfactor
    i insTimes<0 s insTimes=0
    s normTimes=phfactor-insTimes
    i $d(inattList("F")) s inattList("F","times")=insTimes
    i $d(inattList("N")) s inattList("N","times")=normTimes
    s inattType=""
    f  s inattType=$o(inattList(inattType)) q:inattType=""  d
    	.q:$g(inattList(inattType,"times"))<1
    	.//q:$g(inattList(inattType))=""
    	.f iAtt=1:1:$l(inattList(inattType),"^") d
        	..s inattId=$p(inattList(inattType),"^",iAtt)
        	..q:inattId=""
        	..s arcimId=$p(^DHCOEInstrAttachOrd(inattId),"^",4)
        	..q:arcimId=""
        	..s qty=inattList(inattType,"times")*$p(^DHCOEInstrAttachOrd(inattId),"^",5)
        	..q:+qty=0
        	..s insOrdList(inattType,arcimId)=$g(insOrdList(inattType,arcimId))+qty
    //s ^TMPNurOPDebug("ins")=insOrdList
    //m ^TMPNurOPDebug("insAtt")=inattList

    TStart
    s inattType="",isAbort=0
    f  s inattType=$o(insOrdList(inattType)) q:(inattType="")!(isAbort)  d
    	.s arcimId=""
    	.f  s arcimId=$o(insOrdList(inattType,arcimId)) q:(arcimId="")!(isAbort)  d
        	..s qty=insOrdList(inattType,arcimId)
        	..//s ^TMPNurOPDebug("res",inattType,arcimId)=qty
        	..s retInsord=##Class(web.DHCCLCom).InsertOrdItem(userId, oeordId, arcimId,3,qty,userDeptId, "", "", "","")
        	..i retInsord'=0 s isAbort=1
    i isAbort TRollBack  s insTimes=0 q
    TCommit
    i insTimes>0 s ^DHCInstrAttOrd(+$h,+^OEORD(oeordId),phcinId,"F",phfactor)=$g(inattList("F"))
	q 0
}

/// ##class(web.DHCNurCom).CanUpdateExec("742||4||1",10211)
ClassMethod CanUpdateExec(oeoriId, userId)
{
	n (oeoriId,userId)
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
	s resStr=0
	//s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
	//s ordStatDesc=""
	//i ordStatId'="" s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
	//i ordStatDesc["停止" q "停止医嘱不能操作!"
	s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
	s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
	i (ordStatCode="D")&(oeoriBilled'="P") q "停止医嘱不能操作!"

	s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
	s prtId=""
	i stayFlag'=1 d
	.s prtId=##class(DHCCLCom).GetPrtId(oeoriId)
	i (stayFlag'=1)&(prtId="") q oeoriId_$p(..GetArcim(oeoriId),"^",1)_"未找到病人发票!不能操作!"

	s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
	s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
	s:##class(Nur.CommonInterface.Order).ifPhcinSkinTest(oeordId,oeoriSub)=1 skinTestFlag="Y" 
	s actCode=""
	i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
	i (skinTestFlag="Y")&(actCode'="YY") q 0

	s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
	s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
	q:phlId="" -1  //not affect
	s execFlag=$p(^DHCPHLOC(phlId),"^",7)
	i execFlag'=1 q -2  //not affect

	s phwId=$o(^DHCPHWINi(phlId,""))
	s prescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
	s phpId=$o(^DHCPHPERi("USR",userId,""))  //FDBMS error??
	i phpId="" q "未设定药房用户,不能操作!"
	q resStr
}

ClassMethod AdjustStock(oeoreId)
{
    //ypz 060602
	s oeordId=$p(oeoreId,"||",1),oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
    q:phlId="" -1
    s prtId=##class(DHCCLCom).GetPrtId(oeoriId)
    q:prtId="" -2
    s resStr=0
    s execFlag=$p(^DHCPHLOC(phlId),"^",7)
    i execFlag=1 d
        .//s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
        .//s ordStatDesc=""
        .//i ordStatId'="" s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
        .//i ordStatDesc["停止" s resStr="停止医嘱不执行!" q
        .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
        .i ordStatCode="D" s resStr="停止医嘱不执行!" q
        .s phwId=$o(^DHCPHWINi(phlId,""))
        .s prescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
        .s phpId=$o(^DHCPHPERi("USR",userId,""))  //FDBMS error??
        .i phpId="" s resStr="你缺少药房人员身份!" q
        .s retStr=##class(web.DHCNurOPExec).InsertPHDisp(prtId,phlId,phwId,phpId,phpId,prescNo,"",oeoreId)
        .i retStr s resStr="插入发药记录错误!" q
        .
        .s retStr=##class(web.DHCNurOPExec).UpdatePyd("","",prtId, phlId, phpId, phpId,prescNo,"",oeoreId)
        .i retStr s resStr="减库存错误!" q
    i resStr=0 d
        .s oeoreSub=0,oeoreStatus="P"
		.f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
		    ..s dspSub=0
	    	..f  s dspSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")  d
	        	...i $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub),"^",6)="C" s oeoreStatus="C"
		.i oeoreStatus'="C" d
		    ..s $p(^OEORD(oeordId,"I",oeoriSub,6),"^",7)="1"
			..s retStr=##class(web.DHCOutPhDisp).collect(oeordId,oeoriSub)
			..i retStr s resStr="置发药状态错误!"
    q resStr
}

/// 	;撤消已处理记录
ClassMethod UndoUpdateExecStat(oeoreId, arcicId, oecprDesc, userId)
{
 //入参arcicId, oecprDesc不起作用 070413
	n (oeoreId, arcicId, oecprDesc, userId)
	s oeordId=$p($g(oeoreId),"||",1) //oeoriId为医嘱或医嘱执行的RowId
	s oeoriSub=$p($g(oeoreId),"||",2)
	s oeoreSub=$p($g(oeoreId),"||",3) //ypz 060308
	s oeoriId=oeordId_"||"_oeoriSub //ypz 060308
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2) //ypz 070413
    i arcimId="" q "无医嘱项!" //ypz 070413
    s arcicId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10) //ypz 070413
	s oecprCode=##Class(web.DHCCLCom).GetOecprCode(oeoriId) //ypz 070413
	q:oecprCode="" "无医嘱优先级!" //ypz 070413
	
	s ctcpName=""
	&sql(select ssusr_careprov_dr->ctpcp_desc into :ctcpName from ss_user where ssusr_RowId=:userId)
	k PLIST
	s resStr=0
	//&js<alert("ctcpName="+"#($g(ctcpName))#"+"/");>
	////i oecprDesc["长期" d   ;长期医嘱删除处理
	////    .//s ret=$$select^MVBOEITM(oeoriId)  ;取出原有数据
	////    .s userAuthoriseDesc=$p($g(^OEORD(+oeoriId,"I",$p(oeoriId,"^",2),7)),"^",3)
	////    .&js<alert("userAuthoriseDesc="+"#(userAuthoriseDesc)#");>
	////    .////i userAuthoriseDesc'[ctcpName  d
	////        .////.s resStr=-2 ;如果不是同一执行人?设置标记
	////    .i userAuthoriseDesc[ctcpName d
	////        ..s userAuthoriseDesc=""   ;添加记录到字段oeori_userauthorise 清空原有记录?恢复到未处理状态
	////        ..&sql(update OE_OrdItem set OEORI_UserAuthorise=:userAuthoriseDesc where oeori_RowId=:oeoriId)   ;添加记录完成
	//ypz 070413 rem //i (oecprDesc'["即刻")&(oecprDesc'["临时")&(oecprDesc'["长期")&(oecprDesc'["自备药")&(oecprDesc'["取药")  q "该状态医嘱不能撤消!"
	//&js<alert("arcicId="+"#(arcicId)#");>
	i arcicId=-90 d   //;待改!!!!????(arcicId=90)!(arcicId=228)  d   ;查询是否为即刻执行医嘱?删除记录
	    .&sql(select oeore_rowid,oeore_ctpcp_dr->ctpcp_desc into :oeoreId,:ctcpDesc from oe_ordexec where oeore_oeori_parref=:oeoriId)
	    .i $g(ctcpDesc)'[ctcpName d
	        ..s resStr=-2
	    .e  d
	        ..//ypz 070413 rem 禁止这种方式//d delete^MVBOEEXE(oeoreId)
	//i arcicId'=-90 d  //;以下为执行程序
	//ypz 080908 rem//i oeoreSub="" s oeoreSub=$o(^OEORD(+oeoriId,"I",oeoriSub,"X",0)) //ypz
	//ypz 080908 rem//i oeoreSub="" q "该医嘱未执行过!" 
	//ypz 080908 rem//s oeoreId=oeoriId_"||"_oeoreSub
	
	s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2)
    //s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8) //ypz 060707自备药
    //i oecprId="" q "无医嘱优先级!"
    //s oecprDesc=$p($g(^OECPR(oecprId)),"^",2)  //ypz 070413
    s canDo=0
    //i (admType'="I")&(oecprDesc'["自备药") s canDo=..CanUpdateExec(oeoriId,userId)
    s ordstat=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
	q:(ordstat="D")!(ordstat="U")!(ordstat="C") "0"
    i (admType'="I")&(oecprCode'["OM")&(oecprCode'["OMST") s canDo=..CanUpdateExec(oeoriId,userId)  //ypz 070413
    i (canDo'=0)&(canDo'="-1")&(canDo'="-2") s ok=canDo q ok
	
	&sql(select oeore_ctpcp_dr->ctpcp_desc into :ctcpDesc from oe_ordexec where oeore_rowid=:oeoreId)
	i 2<1 d
	    .s resStr="只有原执行人能撤消操作!"
	e  d
	    .s billFlag="I",nullStr=""
	    .
	    .i oeoreSub'="" d  //住院PDA执行或门急诊
	        ..s oeoreId=oeoriId_"||"_oeoreSub
	        ..&sql(update Oe_ordexec set OEORE_CTPCP_DR=:nullStr,OEORE_Order_Status_DR=:nullStr,OEORE_QtyAdmin=:nullStr,OEORE_CTUOM_DR=:nullStr,OEORE_DateExecuted=:nullStr,OEORE_TimeExecuted=:nullStr,OEORE_Billed=:billFlag where oeore_rowid=:oeoreId)
	        ..i SQLCODE s resStr="医嘱撤消执行失败!"
	        ..i resStr'=0 q 
	        ..s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2)
	        ..i (admType'="I")&(canDo=0)&(oecprCode'["OM")&(oecprCode'["OMST") s retStr=..RetrunStock(oeoreId,userId) //ypz 070413
	        ..i resStr'=0 q 
	        ..
        	..s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
        	..i dhcoreId'="" d //修改医嘱执行扩展表
        	    ...&sql(update DHC_OE_OrdExec set DHCORE_Ssuser_Dr=:nullStr,DHCORE_OEORE_Date=:nullStr,DHCORE_OEORE_Time=:nullStr,DHCORE_CTLOC_Dr=:nullStr where DHCORE_RowId=:dhcoreId)
        	    ...s resStr=SQLCODE
         ..i resStr'=0 s resStr="修改医嘱执行扩展表有误!"
     .e  d  //住院非PDA执行
         ..s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))  q:oeoreSub=""  d
	            ...s oeoreId=oeoriId_"||"_oeoreSub
	            ...&sql(update Oe_ordexec set OEORE_CTPCP_DR=:nullStr,OEORE_Order_Status_DR=:nullStr,OEORE_QtyAdmin=:nullStr,OEORE_CTUOM_DR=:nullStr,OEORE_DateExecuted=:nullStr,OEORE_TimeExecuted=:nullStr,OEORE_Billed=:billFlag where oeore_rowid=:oeoreId)
	            ...i SQLCODE s resStr="医嘱撤消执行失败!"
	            ...i resStr'=0 q 
	            ...
        	    ...s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
        	    ...i dhcoreId'="" d //修改医嘱执行扩展表
        	        ....&sql(update DHC_OE_OrdExec set DHCORE_Ssuser_Dr=:nullStr,DHCORE_OEORE_Date=:nullStr,DHCORE_OEORE_Time=:nullStr,DHCORE_CTLOC_Dr=:nullStr where DHCORE_RowId=:dhcoreId)
        	        ....s resStr=SQLCODE
             ...i resStr'=0 s resStr="修改医嘱执行扩展表有误!"
	q resStr
}

ClassMethod RetrunStock(oeoreId, userId)
{
	s oeordId=$p(oeoreId,"||",1),oeoriSub=$p(oeoreId,"||",2),oeoreSub=$p(oeoreId,"||",3)
    s oeoriId=oeordId_"||"_oeoriSub

    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    s phlId=$o(^DHCPHLOCi("LOC",reclocId,""))
    q:phlId="" -1
    s resStr=0
    s execFlag=$p(^DHCPHLOC(phlId),"^",7)
    i execFlag=1 d
        .//s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
        .//s ordStatDesc=""
        .//i ordStatId'="" s ordStatDesc=$p($g(^OEC("OSTAT",ordStatId)),"^",2)
        .//i ordStatDesc["停止" s resStr="停止医嘱不能撤消执行!" q
        .s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
        .i ordStatCode="D" s resStr="停止医嘱不能撤消执行!" q
        .s prtId=##class(DHCCLCom).GetPrtId(oeoriId)
        .i prtId="" s resStr="未找到病人发票!不能退库存!" q
        .s phwId=$o(^DHCPHWINi(phlId,""))
        .s prescNo=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",14)
        .s phpId=$o(^DHCPHPERi("USR",userId,""))  //FDBMS error??
        .i phpId="" s resStr="非药房用户,不能退药!" q
		.s phdId="",count=0
		.f  s phdId=$o(^DHCPHDISPi("PRT",phlId,prtId,phdId)) q:(phdId="")!(count>0)  d
			..s phdPrescNo=$p(^DHCPHDISP(phdId,2),"^",1)
	  		..q:phdPrescNo'=prescNo
	  		..s phdiSub=""
	  		..f  s phdiSub=$o(^DHCPHDI(phdId,"PHDI",phdiSub)) q:(phdiSub="")!(count>0)  d
	    		...s curOreId=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",11) //ypz
	    		...q:curOreId'=oeoreId  //ypz 按执行走
	    		...s qty=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",4)
	    		...s retQty=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",6)
	    		...i retQty=qty q
	    		...s retUomId=$p(^DHCPHDI(phdId,"PHDI",phdiSub),"^",8)
	    		...s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
	    		...////i oeordId=1325 w phdId_"||"_phdiSub,! q
	    		...s phretId=##CLASS(web.DHCNurOPExec).DoReturn(reclocId, userId,phdId_"||"_phdiSub, "", "","","")
	    		...i phretId<1 s resStr="退药错误!",count=1 q
	    		...s retStr=##CLASS(web.DHCNurOPExec).DoRetItm(phretId,phdId_"||"_phdiSub)
	    		...i retStr s resStr="返库存错误!",count=1 q
	q resStr
}

ClassMethod SpecName(oeoriId)
{
 //取标本类型
	s paorder=$p(oeoriId,"||",1)
	s itemsub=$p(oeoriId,"||",2)
	s SPECChildsub=0
	s SPECDesc="",tempSPECCode="",tempSPECDesc=""
	s admLoc=$p($g(^OEORD(paorder,"I",itemsub,9)),"^",2)
	s hospCode=""
	i admLoc'="" s hospCode=$p(^CT("HOSP",$p(^CTLOC(admLoc),"^",22)),"^",1)
	;i $d(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub))'=0 d
	s SPECChildsub=0 f  s SPECChildsub=$o(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub)) q:SPECChildsub=""  d
	.s tempSPECCode=$g(^OEORD(paorder,"I",itemsub,"SPEC",SPECChildsub))
	.s tempSPECCode=$p(tempSPECCode,"^",1)
	.s tempSPECDesc=$p(##Class(DHCLIS.DHCCommon).GetSpecimen(tempSPECCode,hospCode),$c(2),2)
	.;s tempSPECDesc=$p(^["LabData"]TTAB("SPEC",tempSPECCode),"\",1)
	.i SPECDesc="" s SPECDesc=tempSPECDesc
	.e  s SPECDesc=SPECDesc_","_tempSPECDesc
	q $g(SPECDesc)
}

ClassMethod kmtemp()
{
 	//删除query 查询标志
	//k ^mtemp("query")
	q $J
}

ClassMethod GetPatLoc(EpisodeID As %String)
{
  	n (EpisodeID)
  	s locId=""  f  s locId=$o(^PAADMi("TransLoc",EpisodeID,locId)) q:locId=""  d
  		.s ^TMP($J,"loc",EpisodeID,locId)="" 
  	s ^TMP("AdmLoc")=$J
  	q
}

ClassMethod SetPlacerNo(userId, oeoreId, placerNo, clearFlag = "N") As %String
{
	//新增参数 userId,061113
	//置检验瓶号
	q:$g(oeoreId)="" "医嘱不能为空!"
	q:$g(placerNo)="" "瓶号不能为空!"
	
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoriId=oeordId_"||"_oeoriSub
    
    s EpisodeID=+^OEORD(oeordId)
    q:EpisodeID=0 "医嘱未关联病人就诊!"
    s admType=$p(^PAADM(EpisodeID),"^",2)
    s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    i (admType'="I")&(oeoriBilled'="P")&(stayFlag'=1) q "未收费医嘱!"
	s PFlage=1                                                               //WKZ 080111 S
	i ($d(^OEORDi(0,"PlacerNo",placerNo))>2)  d
	.s PFlage=..getPlacerFlage(placerNo)              
	s CPFlage=-1
	i (PFlage=0)&(clearFlag'="Y") d
	.s CPFlage=..clearPlacerFlage(placerNo)
	q:(clearFlag'="Y")&(PFlage=0)&(CPFlage<0) "清除停止医嘱的关联条码失败!"  //WKZ 080111 E
	i ($d(^OEORDi(0,"PlacerNo",placerNo))>2)&(clearFlag'="Y") q "已有该瓶号!"
	i (placerNo'=$p(^OEORD(oeordId,"I",oeoriSub,3),"^",36))&(clearFlag="Y") q "无此瓶号!"
	i ($d(^OEORDi(0,"PlacerNo",placerNo))<2)&(clearFlag="Y") q 0
	s oriLabEpisodeNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)  ;OEORI_LabEpisodeNo
	i oriLabEpisodeNo="" q "该医嘱没有检验号!"
	i clearFlag'="Y",$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",36)'="" q "该医嘱已有条码号!"

	//s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR  //ypz 061113
    //s ordStatDesc=$p($g(^OEC("OSTAT",+ordStatId)),"^",2) //ypz 061113
    //i ordStatDesc["执行" q "医嘱状态为执行,不能置条码!" //ypz 061113
    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeordId_"||"_oeoriSub)  //070204
    i ordStatCode="D" q "医嘱状态为停止,不能置条码!"
    i ordStatCode="E" q "医嘱状态为执行,不能置条码!"
    
    s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
    i oeoreSub'="" i $p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)'="" q "护士已执行,不能置条码!"

	//s placerStr=..GetSpecContainerCode(oeoriId)
	//q:placerStr="" "标本容器标签未定义!"
	//s placerColor=$p(placerStr,"^",1)
	//s placerCat=$p(placerStr,"^",2)
	//q:placerCat="" "标本容器标签未定义分类!"
	//i (placerCat'="")&($p(placerNo,placerCat,1)'="") q "瓶号分类不对!"
		
	//s oldNameSpace=$ZNSPACE
	//s dataNameSpace=$LIST(^websys.ConfigurationD(1),12)
	//zn dataNameSpace
	;
	s curOriSub=0,err="",oeoriIdStr=""
	//f  s curOriSub=$o(^OEORD(oeordId,"I",curOriSub)) q:curOriSub=""  d
	f  s curOriSub=$O(^OEORD(0,"EpisNo",oriLabEpisodeNo,oeordId,curOriSub)) q:curOriSub=""  d
	    .s curLabEpisodeNo=$p($g(^OEORD(oeordId,"I",curOriSub,3)),"^",20)
	    .//q:curLabEpisodeNo'=oriLabEpisodeNo
	    .s oeoriId=oeordId_"||"_curOriSub
	    .//s err=$$select^MVBOEITM(oeoriId)
	    .k PLIST
	    .&sql(SELECT * INTO PLIST() FROM OE_OrdItem WHERE OEORI_RowId=:oeoriId)
	    .s PLIST(215)=placerNo         ;OEORI_PlacerNo
	    .i clearFlag="Y" s PLIST(215)=""
	    .//i err=0 s err=$$update^MVBOEITM(oeoriId)
	    .i 'SQLCODE d
	        ..&sql(UPDATE OE_OrdItem VALUES PLIST() WHERE OEORI_RowId=:oeoriId)
	    .s err=SQLCODE
	    .i err'=0 q
	    .i oeoriIdStr'="" s oeoriIdStr=oeoriIdStr_"^"
	    .s oeoriIdStr=oeoriIdStr_oeoriId
	//zn oldNameSpace  ; Restore the namespace
	i err=0,oeoriIdStr'="" d
	   	.s num=$l(oeoriIdStr,"^")
	   	.f i=1:1:num d
	   	    ..s oeoriId=$p(oeoriIdStr,"^",i)
	   	    ..s oeordId=+oeoriId
	   	    ..s oeoriSub=$p(oeoriId,"||",2)
	   	    ..s oeoreId=""
	        ..i oeoreSub="" d
	    	    ...i $o(^OEORD(oeordId,"I",oeoriSub,"X",0))="" d
            	    ....k PLIST
            	    ....s PLIST(0)=oeoriId
            	    ....s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate //ypz 060428
            	    ....s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime //ypz 060428
            	    ....s PLIST(41)=0
            	    ....s PLIST(43)="TB"
            	    ....&sql(insert into OE_OrdExec Values PLIST())
            	    ....i SQLCODE s err="执行记录插入有误!" q
            	    ....s oeoreId=$g(%ROWID)
            ..e  d
    		    ...s oeoreId=oeoriId_"||"_oeoreSub  
            ..i err'=0 q //ypz 070206
            ..i ($p(oeoreId,"||",1)="")!($p(oeoreId,"||",2)="")!($p(oeoreId,"||",3)="") q
            ..s curDate=+$h,curTime=$p($h,",",2)
            ..i clearFlag="Y" s userId="",curDate="",curTime=""
            ..s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
            ..i dhcoreId'="" d
                ...&sql(update DHC_OE_OrdExec set DHCORE_SpecCollUser=:userId,DHCORE_SpecCollDate=:curDate,DHCORE_SpecCollTime=:curTime where DHCORE_RowId=:dhcoreId)
            ..e  d
                ...&sql(insert into DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_SpecCollUser,DHCORE_SpecCollDate,DHCORE_SpecCollTime) Values(:oeoreId,:userId,:curDate,:curTime))
            ..s err=SQLCODE
	q err
}

ClassMethod getPlacerFlage(placerNo) As %String
{
	//add by WKZ 080111
	s flage=0
	s LabEpisodeNo=""
	i ($d(^OEORDi(0,"PlacerNo",placerNo))<2) q 1
	f  s LabEpisodeNo=$O(^OEORDi(0,"PlacerNo",placerNo,LabEpisodeNo)) q:LabEpisodeNo=""  d
	.s OeordId=""
	.f  s OeordId=$O(^OEORDi(0,"PlacerNo",placerNo,LabEpisodeNo,OeordId))  q:OeordId=""  d
	..s OeordSub=""
	..f  s OeordSub=$O(^OEORDi(0,"PlacerNo",placerNo,LabEpisodeNo,OeordId,OeordSub))  q:OeordSub=""  d
	...s itemStatDR=$P($G(^OEORD(OeordId,"I",OeordSub,1)),"^",13)
	...s itemStatCode=$P($G(^OEC("OSTAT",itemStatDR)),"^",1)
	...i itemStatCode'="D" s flage=1
	q flage
}

ClassMethod clearPlacerFlage(placerNo) As %String
{
	//add by WKZ 080111
	s flage=0
	s LabEpisodeNo=""
	f  s LabEpisodeNo=$O(^OEORDi(0,"PlacerNo",placerNo,LabEpisodeNo)) q:LabEpisodeNo=""  d
	.s OeordId=""
	.f  s OeordId=$O(^OEORDi(0,"PlacerNo",placerNo,LabEpisodeNo,OeordId))  q:OeordId=""  d
	..s OeordSub=""
	..f  s OeordSub=$O(^OEORDi(0,"PlacerNo",placerNo,LabEpisodeNo,OeordId,OeordSub))  q:OeordSub=""  d
	...s OeorID=OeordId_"||"_OeordSub
	...k PLIST
	...&sql(SELECT * INTO PLIST() FROM OE_OrdItem WHERE OEORI_RowId=:OeorID)
	...s PLIST(215)=""
	...i 'SQLCODE d
	....&sql(UPDATE OE_OrdItem VALUES PLIST() WHERE OEORI_RowId=:OeorID)
	q SQLCODE
}

ClassMethod GetFirstOeoreId(oeoriId, type = "") As %String
{
   //type为Query只查询,否则要插入医嘱执行表
	n (oeoriId, type)
	i $g(oeoriId)="" q ""
	s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
	s oeoriId=oeordId_"||"_oeoriSub

	s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	i type="Query",oeoreSub="" q ""
	s oeoreId=""
	i oeoreSub="" d
        .k PLIST
        .s PLIST(0)=oeoriId
        .s PLIST(26)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)  ;OEORE_ExStDate
        .s PLIST(27)=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10) ;OEORE_ExStTime
        .s PLIST(41)=0
        .s PLIST(43)="TB"
        .&sql(insert into OE_OrdExec Values PLIST())
        .i SQLCODE q
        .s oeoreId=$g(%ROWID)
	e  d
    	.s oeoreId=oeoriId_"||"_oeoreSub
    q oeoreId
}

ClassMethod GetPlacerNo(oeoriId) As %String
{
 	//查找检验瓶号
	q:$g(oeoriId)="" ""
	s oeordId=+oeoriId
	s oeoriSub=$p(oeoriId,"||",2)
	q $p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",36)
}

ClassMethod GetSpecContainerCode(oeoriId)
{
    n (oeoriId)
    s retno=""
    s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    q:oeordId="" retno
    q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) retno
    s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
    q:arcimId="" retno
    s arcsub=$p(arcimId,"||",2)
    q:arcsub="" retno
    s excode=""
    s chl="" f  s chl=$o(^ARCIM(+arcimId,arcsub,"EXT",chl)) q:chl=""  d
    	.s tod=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",2)
    	.q:(tod'="")&(tod<+$h)
    	.s excode=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",4)
  	q:excode="" retno

  	//ypz 070131 begin
  	i '$d(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)) q retno
  	s specCode=$p(^OEORD(oeordId,"I",oeoriSub,"SPEC",1),"^")
  	q:specCode="" retno
  	s hospitalId=""
	s userDepartmentDR=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
	i userDepartmentDR'="" s hospitalId=$p(^CTLOC(userDepartmentDR),"^",22)
	s hospitalCode=##class(web.DHCDocOrderCommon).GetCurrentSYSHospitalCode(hospitalId)
   	i $d(^DHCLISBSVersion(1)) d   ///liuzf 获取容器代码名称 
 	.s retval=##Class(DHCLIS.DHCCommon).GetTSContainer(excode,specCode,$g(hospitalCode))
 	.b //12
  	.s ContainerCode=$p(retval,$c(2),2)
  	.s ContainerDesc=$p(retval,$c(2),3)
  	.s specesNum=$p(retval,$c(2),7)
	.s Volumn=$p(retval,$c(2),4)
	.s Color=$p(retval,$c(2),5)
	.s ContainerDR=$p(retval,$c(2),1)
	.s Notes=$p(retval,$c(2),6)
	.s len=$l(ContainerCode)
  	.s retno=$e(ContainerCode,1,1)_"^"_$e(ContainerCode,2,len)_"^"_ContainerDesc_"^"_Volumn_"^"_Color_"^"_ContainerDR_"^"_specesNum_"^"_Notes  //G^01^试管^容量^#ffff
  	/*e  d
  	.s curCtconId="",ctconId=""
  	.f  s curCtconId=$o(^TTAB("TS",excode,"SC",curCtconId)) q:(curCtconId="")  d
  	. .i $d(^TTAB("TS",excode,"SC",curCtconId,specCode))>0 s ctconId=curCtconId
  	.//ypz 070131
	.//s ctconId=$o(^TTAB("TS",excode,"SC","")) //ypz 070131
	.i ctconId'="" d  //ypz 061115
	. .s ctlabId=$p(^TTAB("CON",ctconId),"\",2)
	. .s len=$l(ctlabId)
	. .s retno=$e(ctlabId,1,1)_"^"_$e(ctlabId,2,len)
	*/
	q retno
}

ClassMethod GetSpecContainerCodeOld(oeoriId)
{
    n (oeoriId)
    s retno=""
    s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    q:oeordId="" retno
    q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) retno
    s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
    q:arcimId="" retno
    s arcsub=$p(arcimId,"||",2)
    q:arcsub="" retno
    s excode=""
    s chl="" f  s chl=$o(^ARCIM(+arcimId,arcsub,"EXT",chl)) q:chl=""  d
    	.s tod=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",2)
    	.q:(tod'="")&(tod<+$h)
    	.s excode=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",4)
  	q:excode="" retno

  	//ypz 070131 begin
  	i '$d(^OEORD(oeordId,"I",oeoriSub,"SPEC",1)) q retno
  	s specCode=$p(^OEORD(oeordId,"I",oeoriSub,"SPEC",1),"^")
  	q:specCode="" retno
  	s curCtconId="",ctconId=""
  	f  s curCtconId=$o(^TTAB("TS",excode,"SC",curCtconId)) q:(curCtconId="")  d
  	    .i $d(^TTAB("TS",excode,"SC",curCtconId,specCode))>0 s ctconId=curCtconId
  	//ypz 070131
	//s ctconId=$o(^TTAB("TS",excode,"SC","")) //ypz 070131
	i ctconId'="" d  //ypz 061115
		.s ctlabId=$p(^TTAB("CON",ctconId),"\",2)
		.s len=$l(ctlabId)
		.s retno=$e(ctlabId,1,1)_"^"_$e(ctlabId,2,len)
	q retno
}

ClassMethod GetSpecNote(oeoriId)
{
    n (oeoriId)
    s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    s retStr=""
    q:oeordId="" retStr
    q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) retStr
    s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
    q:arcimId="" retStr
    s arcsub=$p(arcimId,"||",2)
    q:arcsub="" retStr
    s excode=""
    s chl="" f  s chl=$o(^ARCIM(+arcimId,arcsub,"EXT",chl)) q:chl=""  d
    	.s tod=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",2)
    	.q:(tod'="")&(tod<+$h)
    	.s excode=$p(^ARCIM(+arcimId,arcsub,"EXT",chl),"^",4)
  	q:excode="" retStr
    //s oldnamespace=$ZNSPACE
    //s datanamespace=$LIST(^websys.ConfigurationD(1),21)
	//zn datanamespace
	s retStr=$p(^TTAB("TS",excode),"\",33)
	//zn oldnamespace
	q retStr
}

ClassMethod InsertLabOrd(oeoriIdStr)
{
	s count=$l(oeoriIdStr,"^")
	f i=1:1:count d
		.s oeoriId=$p(oeoriIdStr,"^",i)
		.s placerStr=..GetSpecContainerCode(oeoriId)
		.s placerCat=$p(placerStr,"^",2)
		.i "^01^02^03^05^06^07^08^"[("^"_placerCat_"^") d
		    .//insert
	q 0
}

ClassMethod CheckOut(papmiId, admIdStr, oeoriIdStr, patPaySum, userId, userGroupId, logLocId, accManId)
{
	n (papmiId, admIdStr, oeoriIdStr, patPaySum, userId, userGroupId, logLocId, accManId)
	//s oeoriIdStr="^965||3^965||4^965||5^965||6^774||6^774||7^774||8^378||3^"
	//n (PAPMIDR, ADMStrInfo, OEORDStr, PatPaySum, UserRID, gloc, ULoadLocDR, AccMRowID, ExpStr)	
	////s ^TMPNurOPDebug=papmiId_"!"_admIdStr_"!"_oeoriIdStr_"!"_patPaySum_"!"_userId_"!"_userGroupId_"!"_logLocId_"!"_accManId
	s retStr=##Class(web.udhcOPBillIF).OPOEORDBILLINL(papmiId, admIdStr, oeoriIdStr, patPaySum, userId, userGroupId, logLocId, accManId,"")
	q retStr
}

ClassMethod CheckAccount(oeoriIdStr)
{
	n (oeoriIdStr)
	//s oeoriIdStr="^965||3^965||4^965||5^965||6^774||6^774||7^774||8^378||3^"
	//暂未考虑多个病人的异常，由JS控制

	s count=$l(oeoriIdStr,"^")
	s admIdStr=""
	f i=1:1:count d
		.s oeoriId=$p(oeoriIdStr,"^",i)
		.q:oeoriId=""
		.s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
		.s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
        .i (oeoriBilled'="B")&(oeoriBilled'="TB") s $p(oeoriIdStr,"^",i)="" q
		.s EpisodeID=+^OEORD(oeordId)
		.i ("^"_admIdStr)'[("^"_EpisodeID_"^") s admIdStr=admIdStr_EpisodeID_"^"
		.s placerStr=..GetSpecContainerCode(oeoriId)
		.s placerCat=$p(placerStr,"^",2)
		.;w " "_placerStr
		.i "^01^02^03^05^06^07^08^"[("^"_placerCat_"^") d
		    ..;w "."
		    ..s oeoriSub=0,labOriSub=""
		    ..f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
		        ...s arcimId=$p(^OEORD(oeordId,"I",oeoriSub,1),"^",2)
		        ...s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
            	...q:(oeoriBilled'="B")&(oeoriBilled'="TB")
		        ...s labOriSub=oeoriSub
		    ..i (labOriSub'="") d
		        ...s labOriId=oeordId_"||"_labOriSub
		        ...i oeoriIdStr'[("^"_labOriId_"^") s oeoriIdStr=oeoriIdStr_labOriId_"^"
	i admIdStr'="^"	s papmiId=+^PAADM(+admIdStr)
	s billSum=##Class(web.udhcOPBillIF).GetOEORDSum(oeoriIdStr)
	;w !,oeoriIdStr,!
	;w admIdStr,!
	;w billSum,!
	q billSum_"!"_oeoriIdStr_"!"_admIdStr_"!"_papmiId
}

ClassMethod GetDosePackQty(oeoriId) As %String
{
	//取医嘱单次剂量的整包装数
	q:oeoriId="" -1
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
	s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    i doseQty="" q -2
    s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
    q:unitUomId="" -3
	//s unitUomId=934
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	//s arcimId="184||1"
    q:arcimId="" -4
   	i ("^"_$g(^DHCCLSet("Exec","SingleDoseQtyArcim"))_"^")'[("^"_+arcimId_"^") q 1  //非来立信、辛疏
    s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
    q:phcdfId="" -5
    s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
    s baseUomId=$p(^PHCD(phcdId,"DF",phcdfSub,2),"^",4)
    s eqQty=1
    i baseUomId'=unitUomId d
        .s eqId=0,eqQty=0
        .f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
            ..s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
            ..i eqUomId=unitUomId s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
    i eqQty=0 q -6
    s dQty=doseQty/eqQty
    i $p(dQty,".",2)>0 s dQty=$p(dQty,".",1)+1
    
    //s inciId=$o(^INCI(0,"ARCIM_DR",+arcimId,""))
    //s baseUomId=$p(^INCI(inciId,1),"^",10)  //s purUomId=$p(^INCI(inciId,3),"^",6)
    //q:purUomId="" -6
    s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
    q:packUomId="" -7
    s factor=1
    i baseUomId'=packUomId d
        .s ctcfId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
		.i ctcfId'="" s factor=$p(^CT("CTCF",ctcfId),"^",3)
	q:+factor=0 -8
	s packDoseQty=dQty/factor  ;包装单位转换
	i $p(packDoseQty,".",2)>0 s packDoseQty=$p(packDoseQty,".",1)+1
	q packDoseQty
}

ClassMethod ChangeEndDate(varType, startDate, endDate) As %String
{
	i startDate="" s startDate=+$h
	i endDate="" s endDate=+$h
	i startDate'=endDate q endDate
	i varType'["ZCQ" q endDate
	i $$$zd(startDate,10)'=^DHCCLSet("Exec","WeekSheet") q endDate
	q startDate+6
}

ClassMethod IfSingleLongOrder(varType, startDate, endDate, sttDate) As %String
{
	i startDate="" s startDate=+$h
	i endDate="" s endDate=+$h
	//i endDate-startDate'=6 q "N"
	i varType'["ZCQ" q "N"
	i sttDate=startDate q "Y"
	//i $zd(startDate,10)'=^DHCCLSet("Exec","WeekSheet") q "N"
	q "Y"
}

ClassMethod IfExecOrder(oeoreId)
{
 //医嘱是否执行 1执行 0 未执行
 n (oeoreId)
	q:oeoreId="" ""
	s orcatId=##Class(web.DHCCLCom).GetOrdCatId(oeoreId)
	q:orcatId="" ""
	q:("^"_$g(^DHCCLSet("Exec","UnNeedExecCat"))_"^")[("^"_orcatId_"^") 1
    s oeordId=+oeoreId
    s oeoriSub=$p(oeoreId,"||",2)
	s oeoreSub=$p(oeoreId,"||",3)
	//s oeoreSub=$p(oeoreId,"||",3)取不到值传进来数据格式错误
	i oeoreSub="" d
	.s oeoreSub=0 s oeoreSub=$O(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:oeoreSub=""  d
	.s oeoreSub=oeoreSub
	q:oeoreSub="" ""
	s ostatCode=""
	s ostatId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"BILL")),"^",1)
	i $g(ostatId)'="" s ostatCode=$p(^OEC("OSTAT",ostatId),"^",1)
	//i (ostatId=4)&($D(^DHCCLNurseExec("DISCON","OrdItem",oeordId_"||"_oeoriSub))) s isExec=1
	s execStatusId=$p($g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)),"^",16) //执行状态
	s execStatusCode=""
    i execStatusId'="" s execStatusCode=$p($g(^OEC("STAT",execStatusId)),"^",1)   
    i (execStatusCode="F")!(execStatusCode="D")!(execStatusCode="R") q 1
    i (ostatCode="C")!(ostatCode="I")!(ostatCode="U") q 1
    q 0
   /*
	i (ostatId=4) q isExec
	i (ostatId'=1)&(ostatId'=6) q 1
	s oeoreSub=""
 	f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")!(isExec=1)  d
 		.q:'$d(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))
 		.s execDate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",19)   ;执行日期
 		.s execCpcpId=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)     ;执行人
 		.i (execDate'="")&(execCpcpId'="") d
 			..s isExec=1   ;此医嘱已经被执行 
 	q isExec  */
}

ClassMethod GetLabelDesc(oeoriId)
{
	s placerStr=..GetSpecContainerCode(oeoriId)
	q:(placerStr="")!(placerStr="^") ""
	s ctlbId=$p(placerStr,"^")_$p(placerStr,"^",2)
	i $d(^DHCLISBSVersion(1)) d
	.s ContainerDR=$p(placerStr,"^",6)
	.s ctlbDescription=$lg($g(^dbo.BTContainerD(ContainerDR)),7)
	e  d  s ctlbDescription=$p(^TTAB("LB",ctlbId),"\")
	q ctlbDescription
}

ClassMethod GetExecDateTime(oeoriId, dateConStr, delimiter, longNewOrdAdd) As %String
{
	n (oeoriId,dateConStr,delimiter,longNewOrdAdd)
	i $g(oeoriId)="" q ""
	s printMark=$p(longNewOrdAdd,"^",2)  //ypz 070315
	s longNewOrdAdd=$p(longNewOrdAdd,"^") //ypz 070315
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    q:phcfrId="" ""
    s phcinId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    q:phcinId="" ""
	q:(longNewOrdAdd="true")&(("^"_$g(^DHCCLNurseExec("VarDef","CQYZQY","PhcIn"))_"^")'[("^"_phcinId_"^")) ""
	s phcfrCode=$p(^PHCFR(phcfrId),"^",3) //ypz 070418 统一取
	q:phcfrCode="" ""
    s dateStartTime=$g(^DHCCLSet("Exec","DateStartTime")) //s dateStartTime=$g(^DHCCLSet("Exec","PrintStartTime"))
    i printMark="Y" s dateStartTime=$g(^DHCCLSet("Exec","PrintStartTime"))  //ypz 070315
	s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
	s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)
	
	s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
	q:oecprId="" ""
	s oecprCode=$p($g(^OECPR(oecprId)),"^")
	//w oecprCode_"/"_longNewOrdAdd
	i ((oecprCode'="S")&(oecprCode'="OMST")&(longNewOrdAdd'="true")) q ##Class(web.DHCNurCom).GetFreqTime(phcfrCode,dateConStr,delimiter,sttDate,dateStartTime)
	i ((oecprCode'="S")&(oecprCode'="OMST")&(longNewOrdAdd="true")) q ""
	
    s fillerno=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",12)
    q:(fillerno'="")&(longNewOrdAdd="true") "" //非新长嘱,查新医嘱补药
    i ((fillerno'="")&(longNewOrdAdd'="true")) q ##Class(web.DHCNurCom).GetFreqTime(phcfrCode,dateConStr,delimiter,sttDate,dateStartTime)

    i (sttTime'>dateStartTime)&(longNewOrdAdd'="true") q ##Class(web.DHCNurCom).GetFreqTime(phcfrCode,dateConStr,delimiter,sttDate,dateStartTime) //当天正常长嘱
	i (sttTime>dateStartTime)&(longNewOrdAdd="true") q "" //多的,不需要补药
	s execStartDate=sttDate
	////////i (sttDate=ordDate)&(ordTime>dateStartTime) s execStartDate=execStartDate+1 //跨到第二天
	i sttTime>dateStartTime s execStartDate=execStartDate+1 //跨到第二天
	s ordDateExecStr=##Class(web.DHCNurCom).GetFreqTime(phcfrCode,dateConStr,delimiter,sttDate,sttTime)
	s execDateStr=##Class(web.DHCNurCom).GetFreqTime(phcfrCode,dateConStr,delimiter,execStartDate,dateStartTime)
    s addFreqStr=##Class(web.DHCCLCom).ExtractString(execDateStr,ordDateExecStr,delimiter,"N")
	q addFreqStr
}

ClassMethod GetXOrdExecInfo(oeoriId) As %String
{
    n (oeoriId)
    s dhcoriId=$o(^DHCORDItem(0,oeoriId,"")) //ypz 070207
	i dhcoriId'="" d //ypz 070207
		.s execXUserId=$p(^DHCORDItem(dhcoriId),"^",6),execXDate=$p(^DHCORDItem(dhcoriId),"^",7),execXTime=$p(^DHCORDItem(dhcoriId),"^",8)
	q $g(execXUserId)_"^"_$g(execXDate)_"^"_$g(execXTime)
}

ClassMethod SetPrintFlag(wardId, userId, queryTypeCode, oeoriIdStr) As %String
{
 	n (wardId, userId, queryTypeCode, oeoriIdStr)
 	q:(userId="")!(queryTypeCode="")!(oeoriIdStr="") -1
	s num=$l(oeoriIdStr,"^")
    s curDate=+$h,curTime=$p($h,",",2)
	//i $d(^DHCCLNurseExec("Printed",pDate,pTime))>0	s pTime=pTime+1
	//s ^DHCCLNurseExec("Printed",pDate,pTime,wardId)=queryTypeCode_"^"_userId
	s err=0
	f i=1:1:num d
	    .s oeoriId=$p(oeoriIdStr,"^",i)
	    .q:oeoriId=""
	    .s oeoreId=..GetFirstOeoreId(oeoriId,"Insert")
	    .//s ^TMPNurOPDebug("ore",oeoriId,1)=oeoreId
	    .q:oeoreId=""
		.i queryTypeCode="LabJY" d
		..s dhcorePrinted="P"
		.e  i queryTypeCode="ZCQ" d
		..s dhcorePrinted="M"
		.e  i (queryTypeCode'="ZCQ")&(queryTypeCode'="LabJY") d
		..s dhcorePrinted="Y"
	    .s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
	    .//s ^TMPNurOPDebug("ore",oeoriId,2)=dhcoreId
	    .i wardId="" d
	    ..s wardId=$p(^PAADM($p(^OEORD(+oeoreId),"^")),"^",70)
	    .i dhcoreId="" d
        	..&sql(insert into DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_Printed,DHCORE_Ward_Dr,DHCORE_QueryCode,DHCORE_PrintUser_Dr,DHCORE_PrintDate,DHCORE_PrintTime) Values(:oeoreId,:dhcorePrinted,:wardId,:queryTypeCode,:userId,:curDate,:curTime))
        .e  d
	    	..s dhcorePrinted=$p(^DHCOrdExec(dhcoreId),"^",3)
			..i (queryTypeCode="LabJY")&(dhcorePrinted'["P") d
			...s dhcorePrinted=dhcorePrinted_"P"
			..e  i (queryTypeCode="ZCQ")&(dhcorePrinted'["M") d
			...s dhcorePrinted=dhcorePrinted_"M"
			..e  i (queryTypeCode'="LabJY")&(queryTypeCode'="ZCQ")&(dhcorePrinted'["Y") d
			...s dhcorePrinted=dhcorePrinted_"Y"
	    	..s curQueryTypeCode=queryTypeCode
	    	..i queryTypeCode="ZCQ",$p(^DHCOrdExec(dhcoreId),"^",6)'="" s curQueryTypeCode=$p(^DHCOrdExec(dhcoreId),"^",6)
	    	..i $p(^DHCOrdExec(dhcoreId),"^",5)'="" s wardId=$p(^DHCOrdExec(dhcoreId),"^",5)
	    	..&sql(update DHC_OE_OrdExec set DHCORE_Printed=:dhcorePrinted,DHCORE_Ward_Dr=:wardId,DHCORE_QueryCode=:curQueryTypeCode,DHCORE_PrintUser_Dr=:userId,DHCORE_PrintDate=:curDate,DHCORE_PrintTime=:curTime where DHCORE_RowId=:dhcoreId)
	    	..s err=SQLCODE
	    	.i err'=0 s err="置打印标志错!" q
    q err
}

ClassMethod OrdWardLinkDoc(wardId, needCtcptType, ctcpLocIdStr, oeoriId)
{
    n (wardId,needCtcptType,ctcpLocIdStr,oeoriId)
    s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
    s wardLinkDoc="N"
    s EpisodeID=+^OEORD(oeordId)
    q:EpisodeID=0 -1
    q:wardId="" -2
    s patWardId=$p($g(^PAADM(EpisodeID)),"^",70)
    q:patWardId="" -3
    i ctcpLocIdStr="" s ctcpLocIdStr=##Class(web.DHCCLCom).GetWardLinkLocId(wardId,"")
    q:ctcpLocIdStr="" -4 //病区未关联科室
	s wardCtlocId=$p($g(^PAWARD(wardId)),"^",5)
	i (needCtcptType'="DOCTOR") s ctcpLocIdStr=wardCtlocId_"^"_ctcpLocIdStr
   	s userId=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    q:userId="" "R" //ypz 070723 滚动医嘱
    s admLocId=$p(^PAADM(EpisodeID),"^",4)
    q:admLocId="" -5
	s ctcpId=$P($g(^SSU("SSUSR",userId)),"^",14)
	q:ctcpId="" -6
    s ctcptId=$P($G(^CTPCP(ctcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" -7
    s ctcptType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp
	q:(needCtcptType'="")&(ctcptType'=needCtcptType) -8
	s docLocId=""
	f  s docLocId=$o(^RB("RES",0,"CTPCP",ctcpId,docLocId)) q:docLocId=""  d //ypz 070723
		.i ("^"_ctcpLocIdStr_"^")[("^"_docLocId_"^") s wardLinkDoc="Y" //ypz 070723
 q wardLinkDoc
}

Query LookUpRejectSpec(queryRegNo As %String = "", wardId As %String = "", fromDate As %String = "", toDate As %String = "") As %Query(ROWSPEC = "regNo:%String,patName:%String,arcimDesc:%String,patLocDesc:%String,labNo:%String,rejectDate:%String,rejectTime:%String,rejectUser:%String,rejectReason:%String,oeoriId:%String,patWard:%String,rejStat:%String")
{
}

ClassMethod LookUpRejectSpecExecute(ByRef qHandle As %Binary, queryRegNo As %String = "", wardId As %String = "", fromDate As %String = "", toDate As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	
 	//i (queryRegNo="")&(wardId="") s qHandle=$lb(0,repid,0) q $$$OK
 	i queryRegNo'="" d
 	    .s regNoLen=$l(queryRegNo)
 	    .f i=regNoLen:1:7 s queryRegNo=0_queryRegNo
 	
 	s Config=##Class(websys.Configuration).%OpenId(1)
	s LABDATA=Config.LabDataNamespace
	
 	//$p(^["LabData"]TTAB("SPEC",tempSPECCode),"\",1)
 	s labNo=""
 	f  s labNo=$o(^[LABDATA]DHCRS(labNo)) q:labNo=""  d
 	    .s cttsCode=""
 	    .f  s cttsCode=$o(^[LABDATA]DHCRS(labNo,cttsCode)) q:cttsCode=""  d
 	        ..s drsId=""
 	        ..f  s drsId=$o(^[LABDATA]DHCRS(labNo,cttsCode,drsId)) q:drsId=""  d
	            ...s drsStr=^[LABDATA]DHCRS(labNo,cttsCode,drsId)
	            ...s rejStatDr=$p(drsStr,"\",10)
	            ...q:(rejStatDr'=0)&(rejStatDr'=2)
	            ...i rejStatDr=0 s rejStat="拒收"
	            ...i rejStatDr=2 s rejStat="护士阅读"
	            ...s regNo=$p(drsStr,"\",1)
	            ...q:(queryRegNo'=regNo)&(queryRegNo'="")
	            ...s patName=$p(drsStr,"\",2)
	            ...s patLocId=$p(drsStr,"\",3)
	            ...i patLocId'=""  s patLocDesc=$P($G(^CTLOC(patLocId)),"^",2)
	            ...e  s patLocDesc=""
	            ...s:patLocDesc="" patLocDesc=$p(drsStr,"\",3)  ///存的就是名称
	            ...q:$p(drsStr,"\",4)<(+$H-7)
	            ...s rejectDate=$$$zd($p(drsStr,"\",4),3)
	            ...s rejectTime=$zt($p(drsStr,"\",5),2)
	            ...s rejectUser=$p(drsStr,"\",6)
	            ...s rejectReason=$p(drsStr,"\",11)
	            ...s patWardId=$p(drsStr,"\",12)
	            ...i patWardId'="" s patWard=$P($G(^PAWARD(patWardId)),"^",2)
	            ...e  s patWard=""
	            ...s:patWard="" patWard=$p(drsStr,"\",12)
	            ...s oeordId=$o(^OEORD(0,"EpisNo",labNo,""))
	            ...s oeoriSub=$o(^OEORD(0,"EpisNo",labNo,+oeordId,""))
	            ...i oeordId'="",oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	            ...e  s oeoriId=""
	            ...q:oeoriId=""
	            ...s arcimDesc=$p(..GetArcim(oeoriId),"^")
	            ...d OutputRow4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow4
	s Data=$lb(regNo,patName,arcimDesc,patLocDesc,labNo,rejectDate,rejectTime,rejectUser,rejectReason,oeoriId,patWard,rejStat)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpRejectSpecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpRejectSpecExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
	//
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				// if there are no more rows, finish fetching
 		s AtEnd=1
 		s Row=""
 	}
 	else      {				// fetch row
 		s Row=^CacheTemp(repid,ind)
 	}
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpRejectSpecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpRejectSpecExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetOperAlert(EpisodeID, oeoriId, printDate) As %String
{
	q:((EpisodeID="")&(oeoriId=""))!(printDate="") ""
    i EpisodeID="" d
	    .s EpisodeID=+^OEORD(+oeoriId)
	i EpisodeID=0 q ""
	s oeordId=$o(^OEORD(0,"Adm",EpisodeID,""))
	q:oeordId="" ""
	s printDate=$$$zdh(printDate,3)
	s retStr=""
	s oeoriSub=0,oeoriIdStr=""
	f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:oeoriSub=""  d
    	.s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    	.q:("^"_$g(^DHCCLSet("AnOp","AppArcimId"))_"^")'[("^"_arcimId_"^")
		.s oeoriId=oeordId_"||"_oeoriSub
		.s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
    	.q:ordStatCode'="V"
    	.s operAlertStr=""
    	.s oeoriNotes=$g(^OEORD(oeordId,"I",oeoriSub,"DEP",1))
    	.s operDate=$$$zd(printDate,3)
    	.i (oeoriNotes[operDate) s operAlertStr=$p(operDate,"-",2,3)_"手术"
    	.s operDate=$$$zd(printDate+1,3)
    	.i (oeoriNotes[operDate) s operAlertStr=$p(operDate,"-",2,3)_"手术"
	    .q:operAlertStr=""
	    .s operAlertStr=$tr(operAlertStr,"-",".")
	    .i retStr'="" s retStr=retStr_","
	    .s retStr=retStr_operAlertStr
	q retStr
}

ClassMethod GetOrdEffDesc(oeoriId)
{
	n (oeoriId)
	q:(oeoriId="") ""
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
   	q:oeoriSub="" ""
	i ..IneffectOrd(oeoriId)="Y" q "已停用"
	
    s resStr=""
	s mainOriId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	i ..IneffectOrd(mainOriId)="Y" q "关联主医嘱已停用"
	
	i mainOriId'="" s oeoriId=mainOriId
    s curOriSub="" f  s curOriSub=$o(^OEORDi(0,"OEORI",oeordId,oeoriId,curOriSub)) q:(curOriSub="")  d
    	.i ..IneffectOrd(oeordId_"||"_curOriSub)="Y" s resStr="关联子医嘱已停用" //ypz 070621
	q resStr
}

ClassMethod IneffectOrd(oeoriId)
{
	n (oeoriId)
	q:(oeoriId="") ""
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
   	q:oeoriSub="" ""
	s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	q:arcimId="" "N"
    s arcimEffDateTo=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),7),"^")
    i (arcimEffDateTo'="")&(arcimEffDateTo<sttDate) q "Y"
	q "N"
}

ClassMethod OrdLocLinkDoc(locId, needCtcptType, oeoriId)
{
    n (locId,needCtcptType,oeoriId)
    s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2)
    q:oeoriId="" -1
    s EpisodeID=+^OEORD(oeordId)
    q:EpisodeID=0 -2
    q:locId="" -3
    s locLinkDoc="N"
    s ctcpLocIdStr=##Class(web.DHCCLCom).GetLinkLocId(locId)
    i ctcpLocIdStr'="" s ctcpLocIdStr=ctcpLocIdStr_"^"
    s ctcpLocIdStr=ctcpLocIdStr_locId
	s userId=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    q:userId="" "R"
	s userDeptId=$P($G(^OEORD(oeordId,"I",oeoriSub,7)),"^",2)
    q:userDeptId="" "R"
	s ctcpId=$P(^SSU("SSUSR",userId),"^",14)
	q:ctcpId="" -6
    s ctcptId=$P(^CTPCP(ctcpId,1),"^",4)  ;CTPCP_CarPrvTp_DR
	q:ctcptId="" -7
    s ctcptType=$P(^CT("CPT",ctcptId),"^",4)  ;CT_CarPrvTp
	q:(needCtcptType'="")&(ctcptType'=needCtcptType) -8
	s docLocId=""
	f  s docLocId=$o(^RB("RES",0,"CTPCP",ctcpId,docLocId)) q:docLocId=""  d
		.i ("^"_ctcpLocIdStr_"^")[("^"_docLocId_"^") s locLinkDoc="Y"
 q locLinkDoc
}

ClassMethod GetSpecCollInfo(oeoreId)
{
	n (oeoreId)
	s specCollStr=""
	s oeordId=+oeoreId
	s oeoriSub=$p(oeoreId,"||",2)
	s oeoreSub=$p(oeoreId,"||",3)
	q:(oeordId="")!(oeoriSub="") specCollStr
	i oeoreSub="" s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
	q:oeoreSub="" specCollStr
	s oeoreId=oeordId_"||"_oeoriSub_"||"_oeoreSub
	s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
	i dhcoreId'="" d
		.s specCollUserId=$p(^DHCOrdExec(dhcoreId),"^",12)
		.i specCollUserId'="" d
			..s specCollCtcpId=$p(^SSU("SSUSR",+specCollUserId),"^",14)
			..i specCollCtcpId="" q
			..s specCollCtcpDesc=$p($g(^CTPCP(specCollCtcpId,1)),"^",2)
			..s specCollDate=$$$zd($p(^DHCOrdExec(dhcoreId),"^",13),3)
			..s specCollTime=$zt($p(^DHCOrdExec(dhcoreId),"^",14),2)
			..s specCollStr=specCollCtcpId_"^"_specCollCtcpDesc_"^"_specCollDate_"^"_specCollTime
	q specCollStr
}

ClassMethod GetPrintTitle(queryTypeCode = "0@CQSYD") As %String
{
	s HospitalRowId=$p(queryTypeCode,"@",1)
    s TypeCode=$p(queryTypeCode,"@",2)
    i (HospitalRowId="")!(TypeCode="") q ""
	s valStr="",captionStr="医嘱|剂量|频次",lenStr="3000|400|500",codeStr="arcimDesc|doseQtyUnit|phcfrCode"
	if '$D(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode)) {
		if $D(^DHCCLNurseExec("VarSetColumnPrtDefTyp")) 
		{
			s queryTypeCode=^DHCCLNurseExec("VarSetColumnPrtDefTyp")
			s HospitalRowId=$p(queryTypeCode,"@",1)
    		s TypeCode=$p(queryTypeCode,"@",2)
    		i (HospitalRowId="")!(TypeCode="") q "" 
		}
	}
	s no=""  f  s no=$O(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no)) q:no=""  d
		.s caption=$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|")
		.s len=$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|",2)
		.s code=$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|",4)
		.s seqno=+$P(^DHCCLNurseExec("VarSetColumnPrt",HospitalRowId,TypeCode,no),"|",5)
		.i seqno>0 d
		    ..s $P(captionStr,"|",seqno)=caption
		    ..s $P(lenStr,"|",seqno)=len
		    ..s $P(codeStr,"|",seqno)=code
	s valStr=captionStr_"^"_lenStr_"^"_codeStr
	q valStr
}

/* add by wkz 080229 for RejectSpecien  */
Query FindRejectSpec(EpisodeID As %String = "") As %Query(ROWSPEC = "RegNo:%String,PatName:%String,ArcimDesc:%String,LabNo:%String,RejectDate:%String,RejectTime:%String,RejectUser:%String,RejectReason:%String")
{
}

ClassMethod FindRejectSpecExecute(ByRef qHandle As %Binary, EpisodeID As %String = "") As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	i (EpisodeID="") s qHandle=$lb(0,repid,0) q $$$OK
    s PaitentID=$p(^PAADM(EpisodeID),"^",1)
    s RegNo1=$p($G(^PAPER(PaitentID,"PAT",1)),"^",1)
 	s Config=##Class(websys.Configuration).%OpenId(1)
	s LABDATA=Config.LabDataNamespace
	s labNo=""
	s Status=0
 	f  s labNo=$o(^[LABDATA]DHCRSi(1,Status,labNo)) q:labNo=""  d
 	.s cttsCode=""
 	.f  s cttsCode=$o(^[LABDATA]DHCRSi(1,Status,labNo,cttsCode)) q:cttsCode=""  d
 	..s drsId=""
 	..f  s drsId=$o(^[LABDATA]DHCRSi(1,Status,labNo,cttsCode,drsId)) q:drsId=""  d
	...s drsStr=^[LABDATA]DHCRS(labNo,cttsCode,drsId)
	...s RegNo=$p(drsStr,"\",1)
	...q:(RegNo1'=RegNo)&(RegNo'="")
	...s PatName=$p(drsStr,"\",2)
	...s RejectDate=$$$zd($p(drsStr,"\",4),3)
	...s RejectTime=$zt($p(drsStr,"\",5),2)
	...s RejectUser=$p(drsStr,"\",6)
	...s RejectReason=$p(drsStr,"\",11)
	...s oeordId=$o(^OEORD(0,"EpisNo",labNo,""))
	...s oeoriSub=$o(^OEORD(0,"EpisNo",labNo,+oeordId,""))
	...i oeordId'="",oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	...e  s oeoriId=""
	...q:oeoriId=""
	...s ArcimDesc=$p(..GetArcim(oeoriId),"^")
	...d OutputRej
 	s qHandle=$lb(0,repid,0)
	q $$$OK 
OutputRej
	s Data=$lb(RegNo,PatName,ArcimDesc,labNo,RejectDate,RejectTime,RejectUser,RejectReason)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindRejectSpecFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindRejectSpecExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {
 		s AtEnd=1
 		s Row=""
 	}
 	else {
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindRejectSpecClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindRejectSpecExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

Query FindMasterItem(ARCIMDesc As %String) As %Query(ROWSPEC = "ArcimDesc:%String,ArcimDR:%String")
{
}

/*
ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, ARCIMDesc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (ARCIMDesc'="") s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,""),-1)
	..q:AlisDR=""
	..s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	..s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	..s ArcimDesc=AlisDesc_"-"_ArcimDesc
	..q:ArcimDesc'[ARCIMDesc
	..//q:$p(ArcimDesc,ARCIMDesc,1)'=""
	..Do OutputRow5
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(ArcimDesc,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}
*/
ClassMethod FindMasterItemExecute(ByRef qHandle As %Binary, ARCIMDesc As %String) As %Status
{
	//s ^gyongao(1)=ARCIMDesc
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    i (ARCIMDesc'="") s ARCIMDesc=$$ALPHAUP^SSUTIL4(ARCIMDesc)
    k ^TempExistOrdItem($j)
 	s ArcimID=0 
 	f  s ArcimID=$o(^ARCIM(ArcimID)) q:ArcimID=""  d
	.s ArcimSubID=0 f  s ArcimSubID=$o(^ARCIM(ArcimID,ArcimSubID)) q:ArcimSubID=""  d
	..s ArcimDR=ArcimID_"||"_ArcimSubID
	..s AlisDR="" f  s AlisDR=$O(^ARC("ALIAS",0,"ARCIM",ArcimDR,AlisDR)) q:AlisDR=""  d
	...q:AlisDR=""
	...q:$d(^TempExistOrdItem($j,ArcimDR))
	...s AlisDesc=$$ALPHAUP^SSUTIL4($p(^ARC("ALIAS",AlisDR),"^",6))
	...s ArcimDesc=$p(^ARCIM(ArcimID,ArcimSubID,1),"^",2)
	...s ArcimDesc=AlisDesc_"-"_ArcimDesc
	...q:ArcimDesc'[ARCIMDesc
	...s dateFrom=$p($p(^ARCIM(ArcimID,ArcimSubID,1),"^",13),",",1)
	...s dateTo=$p(^ARCIM(ArcimID,ArcimSubID,7),"^",1)
	...s h=+$h
	...q:((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'=""))
	...//q:$p(ArcimDesc,ARCIMDesc,1)'=""
	...s ^TempExistOrdItem($j,ArcimDR)=1
	...Do OutputRow5
	k ^TempExistOrdItem($j)
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow5
	set Data=$lb(ArcimDesc,ArcimDR)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindMasterItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindMasterItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindMasterItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod UpdateDHCOeordExec(oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode) As %String
{
	   n (oeoreId, userId, curDate, curTime, userDeptId, queryTypeCode)
    i oeoreId="" q 0  //d //修改执行扩展表
    s dhcoreId=$o(^DHCOrdExec(0,"OEOREDR",oeoreId,""))
    i dhcoreId="" d
        .&sql(insert into DHC_OE_OrdExec (DHCORE_OEORE_Dr,DHCORE_Ssuser_Dr,DHCORE_OEORE_Date,DHCORE_OEORE_Time,DHCORE_CTLOC_Dr,DHCORE_QueryCode) Values(:oeoreId,:userId,:curDate,:curTime,:userDeptId,:queryTypeCode))
    e  d
        .&sql(update DHC_OE_OrdExec set DHCORE_Ssuser_Dr=:userId,DHCORE_OEORE_Date=:curDate,DHCORE_OEORE_Time=:curTime,DHCORE_CTLOC_Dr=:userDeptId,DHCORE_QueryCode=:queryTypeCode where DHCORE_RowId=:dhcoreId)
    q SQLCODE
}

/// 修改DHC_PA_PatMas 门诊输液 注射单执行
ClassMethod UpdateDHCPAPatMas(oeoriId, DrugCell, userId) As %String
{
	n (oeoriId, DrugCell, userId)
    i oeoriId="" q ""
    s curDate=+$h,curTime=$p($h,",",2)
    s EpisodeID=+^OEORD(+oeoriId)
    q:EpisodeID="" "无就诊ID!"
    s PaitentID=$p(^PAADM(EpisodeID),"^",1)
	&sql(update DHC_PA_PatMas set PAPMI_DrugCell=:DrugCell,PAPMI_DrugCellUser_Dr=:userId,PAPMI_DrugCellDate=:curDate,PAPMI_DrugCellTime=:curTime where PAPMI_RowId=:PaitentID)
    q SQLCODE
}

Query FindOrditemAttach(regNo As %String, userId As %String, startDate As %String, endDate As %String, admType As %String, DetailFlag As %String, ordId As %String) As %Query(ROWSPEC = "admDeptDesc,orcatDesc,arcimDesc,phOrdQtyUnit,price,totalAmount,ctcpDesc,reclocDesc,createDateTime,sttDateTime,ordStatDesc,phcduDesc1,oeoriId,disposeStatCode,execCtcpDesc,execDateTime,execStat,seqNo,phcfrCode,disposeStatDesc")
{
}

/// d ##class(%ResultSet).RunQuery("web.DHCNurCom","FindOrditemAttach","0000000036^5626","4636","64567","64567","OE","on","5507||3||1")
ClassMethod FindOrditemAttachExecute(ByRef qHandle As %Binary, regNo As %String, userId As %String, startDate As %String, endDate As %String, admType As %String, DetailFlag As %String, ordId As %String) As %Status
{
	;s ^zhaozehui("order")=$lb(regNo , userId , startDate , endDate , admType , DetailFlag , ordId)
	s repid=$i(^CacheTemp)
 	s ind=1
 	i userId=""  s qHandle=$lb(0,repid,0) q $$$OK
 	i regNo=""  s qHandle=$lb(0,repid,0) q $$$OK
 	i ordId=""  s qHandle=$lb(0,repid,0) q $$$OK
 	s mainOrdId=""
 	s mainOrdExecSub=""
 	i ordId'="" d
	.s mainOrdId=+ordId
	.s mainOrdSub=$p(ordId,"||",2)
	.s mainOrdExecSub=$p(ordId,"||",3)
	.q:(mainOrdId="")!(mainOrdSub="")
	.s relOrdId=$p(^OEORD(mainOrdId,"I",mainOrdSub,11),"^",39)
	.i relOrdId="" s mainOrdId=mainOrdId_"||"_mainOrdSub
	.e  s mainOrdId=relOrdId

 	s curRegNo=$p(regNo,"^",1) //ypz 060728
 	s EpisodeID=$p(regNo,"^",2)
 	i regNo'="" s regNo=curRegNo
 	i EpisodeID'="" s startDate=$p($g(^PAADM(EpisodeID)),"^",6)
 	i (admType'="I")&(regNo'="")&(EpisodeID="") d   //ypz 060702
 	    .s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
        .q:papmiId=""
        .s minDate=startDate
        .i admType["O" d
        	..s EpisodeID=""  //ypz 060718
        	..f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","O",EpisodeID),-1) q:EpisodeID=""  d
        		...i EpisodeID'="" d 
        			....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
        			....i pavisit'="A" q   ;
        			....s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
        			....s EpisodeID=0
        			....i minDate>admDate s minDate=admDate
        .i admType["E" d
        	..s EpisodeID=""
        	..f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","E",EpisodeID),-1) q:EpisodeID=""  d
        		...i EpisodeID'="" d 
        			....s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
        			....i pavisit'="A" q   ;
        			....s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
        			....s EpisodeID=0
        			....i minDate>admDate s minDate=admDate
        .i minDate<startDate s startDate=minDate
    s retStr=..FindPatient("",regNo_"^"_EpisodeID,userId,admType,startDate,endDate) 
    s patstr=..GetAllPatient(userId)
    s num=$l(patstr,"^")
    i patstr="" s num=0
    k ^TMP("NurExecNurseOrder",userId)
  	
    f i=1:1:num
    {
	    
     	s pat=$p(patstr,"^",i)
     	s EpisodeID=$p(pat,"!",1)
     	
     	q:EpisodeID=""
	
	    s curAdmType=$p(^PAADM(EpisodeID),"^",2) //ypz 060302
	    q:"OE"'[curAdmType
	    /*s today=$p($h,",",1)  
	    s fromDate=+fDateStr 
	    i $l(fDateStr,"/")=3 s fromDate=$zdh(fDateStr,4)
	    i fDateStr="" s fromDate=+$h
	    s toDate=+tDateStr
	    i $l(tDateStr,"/")=3 s toDate=$zdh(tDateStr,4)
	    i tDateStr="" s toDate=+$h
	    i fromDate>toDate q
	    */
	    s admDeptId=$p(^PAADM(EpisodeID),"^",4)
	    i admDeptId'="" s admDeptDesc=$p($g(^CTLOC(+admDeptId)),"^",2)
	  
        s oeordId=0 f  s oeordId=$o(^TMP("NurExecOrderAttach",userId,EpisodeID,oeordId)) q:oeordId=""  d
        .s mainOeoriSub=0  f  s mainOeoriSub=$o(^TMP("NurExecOrderAttach",userId,EpisodeID,oeordId,mainOeoriSub)) q:mainOeoriSub=""  d
		..s mainOeoriDr=oeordId_"||"_mainOeoriSub
        ..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"OEORI",oeordId,mainOeoriDr,oeoriSub)) q:oeoriSub=""  d
 		...d GetOneOrderInfo
 		//查询是否有护士补录的费用
		f ordSttDate=startDate:1:endDate  d
		.s oeordId=0 f  s oeordId=$o(^OEORD(0,"Adm",EpisodeID,oeordId)) q:oeordId=""  d
    	..s oeoriSub=0 f  s oeoriSub=$o(^OEORDi(0,"StDt",ordSttDate,oeordId,oeoriSub)) q:oeoriSub=""  d
        ...d GetNurseOrder(oeordId,oeoriSub)
    }
	//查询护士补录的费用
	s needCtcptType="NURSE"
	s num=0
	s oeordId=0 f  s oeordId=$o(^TMP("NurExecNurseOrder",userId,oeordId)) q:oeordId=""  d
	.s oeoriSub=0 f  s oeoriSub=$o(^TMP("NurExecNurseOrder",userId,oeordId,oeoriSub)) q:oeoriSub=""  d
	..i num=0 d
	...s admDeptDesc="",orcatDesc="",arcimDesc="",phOrdQtyUnit="",price="",totalAmount="",ctcpDesc="",reclocDesc="",createDateTime="",sttDateTime="",ordStatDesc="",phcduDesc1="",oeoriId="",disposeStatCode="",execCtcpDesc="",execDateTime="",execStat="",seqNo="",phcfrCode="",disposeStatDesc=""
	...s arcimDesc="以下为护士或收费处补录的费用",disposeStatCode="LackOfFee"
	...d OutRowTitle
	..d GetOneOrderInfo
	..s num=num+1
	//清临时GLobal
	k ^TMP("NurExecNurseOrder",userId)
	
    s qHandle=$lb(0,repid,0)
	q $$$OK
GetOneOrderInfo
	
	q:(oeordId="")!(oeoriSub="")
	s relOrdId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)
	q:(relOrdId'=mainOrdId)&(mainOrdId'="")
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
	
    s arcicId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10)
    ;q:("^"_$g(^DHCCLSet("Exec","TitleOrdSubCat"))_"^")'[("^"_arcicId_"^")
    s oeoriId=oeordId_"||"_oeoriSub
    q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)=""
    s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
   
	q:arcicOrderType="R"
	s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13)  ;OEORI_ItemStat_DR
	s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^")
	q:ordStatCode'="V"

    s ordStatDesc=$p($g(^OEC("OSTAT",+ordStatId)),"^",2)
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    q:(oeoriBilled'="B")&(oeoriBilled'="TB")&(oeoriBilled'="P") //非住院的有医嘱
    s sttDate=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",9)   //keep duplicate
    s sttTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",10)  //keep duplicate
    s omitUnPaidDay=$g(^DHCCLSet("Exec","OmitUnPaidDay"))
    q:(omitUnPaidDay>0)&(admType="O")&(oeoriBilled'="P")&($h-sttDate>omitUnPaidDay)
    s createDate=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",7)
    s createTime=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",17)
    //i ((createDate<fromDate)!(createDate>toDate)) q
    s packUomQty=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)
    s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
    s arcimDesc=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",2)
    s packUomId=+packUomId,packUomDesc=""
    i (packUomId'=0)&(packUomQty'="") d 
    .s packUomDesc=$p(^CT("UOM",packUomId),"^",2)
    s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    s ctcpId=$p(^SSU("SSUSR",+userAddId),"^",14)
    //q:ctcpId=""
    //判断是否是护士补录或收费处所录医嘱
    s IfNeedCtcptOrder=0
    i ctcpId'="" d
    .s ctcpDesc=$p($g(^CTPCP(+ctcpId,1)),"^",2)
	.s ctcptId=$P($G(^CTPCP(ctcpId,1)),"^",4)  		;CTPCP_CarPrvTp_DR
	.q:ctcptId=""
	.s ctcptType=$P($g(^CT("CPT",ctcptId)),"^",4)  	;CT_CarPrvTp
	.i $G(needCtcptType)'="",ctcptType=$G(needCtcptType) d
	..s IfNeedCtcptOrder=1
	e  d
	.s IfNeedCtcptOrder=1
    q:($G(needCtcptType)'="")&(IfNeedCtcptOrder=0)
    s orcatId=$p($g(^ARC("IC",+arcicId)),"^",8) 
    s orcatDesc=$p($g(^OEC("ORCAT",+orcatId)),"^",2)
    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    s reclocDesc=$p($g(^CTLOC(+reclocId)),"^",2)
    i reclocDesc["-" s reclocDesc=$p($p($g(^CTLOC(+reclocId)),"^",2),"-",2)
    s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    s unitUomId="",unitDesc=""
    i doseQty'="" s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
    i unitUomId'="" s unitDesc=$p($g(^CT("UOM",unitUomId)),"^",2)
    i (doseQty'="")&($p(doseQty,".")="") s doseQty="0"_doseQty
    i (doseQty'="")&(unitDesc'="") s doseQtyUnit=doseQty_" "_unitDesc
    s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
    s returnQtyStr=##class(web.DHCBillInterface).GetPartRefundQty(oeordId_"||"_oeoriSub,"")
	s returnQty1=+($p(returnQtyStr,"^",2))
	s returnQty2=+($p(returnQtyStr,"^",3))
	s returnQty=returnQty1+returnQty2
	s phOrdQty=phOrdQty-returnQty
    s phOrdQtyUnit=""
    i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
    i (phOrdQty'="") s phOrdQtyUnit=phOrdQty_" "_unitDesc
    //i packUomQty'=""  s phOrdQtyUnit=packUomQty_" "_$g(packUomDesc) //整包数量不使用
    s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25)
    s reclocId=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",6)
    s hospital=$p($g(^CTLOC(reclocId)),"^",22)
    s admId=+^OEORD(oeordId)
   
   
    
    
    
    //s price=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice)
    //s price=$fn(price,"",2)
    s orderBaseQty=##Class(web.DHCCLCom).GetOrderBaseQty(oeoriId)
    //s totalAmount=$fn(orderBaseQty*price,"",2)
    s phcduId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",6)
    s phcduDesc1=$p($G(^PHCDU(+phcduId)),"^",3)  //持续周期 Oeori_Durat_Dr-->PHC_Duration
	s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
	i (phcfrId'="")&&((+phcfrId)'=0) s phcfrCode=$p(^PHCFR(phcfrId),"^",3)
	e  s phcfrCode=""
    s createDateTime=##Class(web.DHCCLCom).FormatDate(createDate)_" "_##Class(web.DHCCLCom).FormatTime(createTime)
    s sttDateTime=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_##Class(web.DHCCLCom).FormatTime(sttTime)
    s disposeStatCode="Temp"
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    s payMode="" //##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
	s oecprCode=$p($g(^OECPR(oecprId)),"^")
    //i (ordStatCode'="D")&(oecprCode'="OM")&(oecprCode'="OMST")&((oeoriBilled="B")!(oeoriBilled="TB")) s disposeStatCode="UnPaid"
    i ((stayFlag'=1)!(payMode=0))&(ordStatCode'="D")&(oecprCode'="OM")&(oecprCode'="OMCQZT")&(oecprCode'="OMLSZT")&(oecprCode'="OMST")&((oeoriBilled="B")!(oeoriBilled="TB")) s disposeStatCode="UnPaid"   // 修改 wxl 090301
    ;i (oeoriBilled="B")!(oeoriBilled="TB") s disposeStatCode="UnPaid"
    s execCtcpDesc="已执行"_$$GetExecNum(oeordId,oeoriSub)_"次"
    s seqNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",4)
    s disposeStatDesc=$s(disposeStatCode="Temp":"已收费",disposeStatCode="UnPaid":"未收费",1:"")
    i DetailFlag="on" d
    .s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
    .q:oeoreSub'=""
    .i $d(^OEORD(oeordId,"I",oeoriSub,"X"))<10 d //无执行医嘱:处置治疗类
   	..q:((sttDate<startDate)!(sttDate>endDate))&(admType'="I")  //qse 060324
    ..s price=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice,hospital)
    ..s price=$fn(price,"",2)
    ..s orderBaseQty=##Class(web.DHCCLCom).GetOrderBaseQty(oeoriId)
    ..i ((admType="O")||(admType="E"))&&(orderBaseQty=0) s orderBaseQty=..GetOrderBaseQtyMZ(oeoriId)
    ..s totalAmount=$fn(orderBaseQty*price,"",2)
    ..s phOrdQtyUnit=orderBaseQty_" "_$g(packUomDesc)
    .d OutRowTitle
    ;q:DetailFlag'="on"	//只显示医嘱项,不显示执行记录
    //显示费用医嘱执行记录
    s oeoreSub=0 f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))  q:oeoreSub=""  d
    .q:(mainOrdExecSub'="")&&(mainOrdExecSub'=oeoreSub)
    .s oreStr=$g(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub))
    .s sttDate=$p(oreStr,"^",1),sttTime=$p(oreStr,"^",2)
    .s expStr="^"_oeordId_"||"_oeoriSub_"^"_oeordId_"||"_oeoriSub_"||"_oeoreSub_"^"_admId_"^"_reclocId
    .s price=+##CLASS(web.UDHCJFPRICE).GetOrderPrice("","",arcimId,sttDate,"","","",oeoriPrice,hospital,expStr)
    .s price=$fn(price,"",2)
    .s sttDateTime=##Class(web.DHCCLCom).FormatDate(sttDate)_" "_##Class(web.DHCCLCom).FormatTime(sttTime)
	.i $p(oreStr,"^",15)'="" d
	..s disposeStatCode="Exec"
	..s execCtcpDesc=$p($g(^CTPCP($p(oreStr,"^",15),1)),"^",2)
	.e  d
	..s disposeStatCode="Temp"
	..s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
	..i ((stayFlag'=1)!(payMode=0))&(ordStatCode'="D")&(oecprCode'="OM")&(oecprCode'="OMCQZT")&(oecprCode'="OMLSZT")&(oecprCode'="OMST")&((oeoriBilled="B")!(oeoriBilled="TB")) s disposeStatCode="UnPaid" 
    ..;i (oeoriBilled="B")!(oeoriBilled="TB") s disposeStatCode="UnPaid"
	..s execCtcpDesc=""
    .i $p(oreStr,"^",19)>0 s execDateTime=##Class(web.DHCCLCom).FormatDate($p(oreStr,"^",19))_" "_##Class(web.DHCCLCom).FormatTime($p(oreStr,"^",20))
    .e  s execDateTime=""
	.s statId=$p(oreStr,"^",16)
	.i statId'="" s execStat=$p($g(^OEC("STAT",statId)),"^",2)
	.e  s execStat=""
	.;s phOrdQtyUnit=$p(oreStr,"^",4)_" "_$g(packUomDesc)

    .s phOrdQty=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",12)
    .i (phOrdQty'="")&(phOrdQty<1) s phOrdQty="0"_phOrdQty
    .i (phOrdQty'="") s phOrdQtyUnit=phOrdQty_" "_$g(packUomDesc)


	.s orderBaseQty=##Class(web.DHCCLCom).GetOrderBaseQty(oeordId_"||"_oeoriSub)
    .s totalAmount=$fn(orderBaseQty*price,"",2)
	.//s totalAmount=$fn($p(oreStr,"^",4)*price,"",2)
    .s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
    .d OutRowTitle
	q
		
OutRowTitle
 	
	s Data=$lb(admDeptDesc,orcatDesc,arcimDesc,phOrdQtyUnit,price,totalAmount,ctcpDesc,reclocDesc,createDateTime,sttDateTime,ordStatDesc,phcduDesc1,oeoriId,disposeStatCode,execCtcpDesc,execDateTime,execStat,seqNo,phcfrCode,disposeStatDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
GetExecNum(oeordId,oeoriSub)
	s num=0
	s curOeoreSub=0 f  s curOeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",curOeoreSub))  q:curOeoreSub=""  d
	.s execCtcp=$P($g(^OEORD(oeordId,"I",oeoriSub,"X",curOeoreSub)),"^",15)
	.i execCtcp'="" s num=num+1
	q num
GetNurseOrder(oeordId,oeoriSub)
	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    s arcicId=$p(^ARCIM(+arcimId,$p(arcimId,"||",2),1),"^",10)
    ;q:("^"_$g(^DHCCLSet("Exec","TitleOrdSubCat"))_"^")'[("^"_arcicId_"^")
    s oeoriId=oeordId_"||"_oeoriSub
    q:$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",39)=""
    s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	q:arcicOrderType="R"
    s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)
    q:ordStatCode'="V"
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    q:(oeoriBilled'="B")&(oeoriBilled'="TB")&(oeoriBilled'="P") //非住院的有医嘱
    s userAddId=$p($g(^OEORD(oeordId,"I",oeoriSub,7)),"^",1)
    s ctcpId=$p($g(^SSU("SSUSR",+userAddId)),"^",14)
	i ctcpId'="" d
	.s ctcptId=$P($G(^CTPCP(ctcpId,1)),"^",4)
	.i ctcptId'="" d
	..s ctcptType=$P($g(^CT("CPT",ctcptId)),"^",4)  	;CT_CarPrvTp
	..i ctcptType="NURSE" d
	...s ^TMP("NurExecNurseOrder",userId,oeordId,oeoriSub)=""
	e  d
	.s ^TMP("NurExecNurseOrder",userId,oeordId,oeoriSub)=""
	q
}

ClassMethod FindOrditemAttachFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindOrditemAttachExecute ]
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

ClassMethod FindOrditemAttachClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindOrditemAttachExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

/// Creator: wangxinlei
/// CreatDate: 2009-07-28
/// Description: 查询本病区的病人
/// Table：PA_Adm,PA_PatMas,PA_Person,PAC_Ward,PAC_Bed
/// Input：WardID: 病区指针
/// Return：输出登记号regNo,病人姓名patName,病人床位bedCode,病人就诊IDEpisodeID
Query FindCurWardPat(WardID As %String) As %Query(ROWSPEC = "登记号:%String,姓 名:%String,床号:%String,EpisodeID:%String")
{
}

ClassMethod FindCurWardPatExecute(ByRef qHandle As %Binary, WardID As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i WardID="" d    //patRegNo:%String,patName:%String,bedCode:%String,EpisodeID:%String
	.s logonLocId=%session.Data("LOGON.CTLOCID")
	.s logonLocType=$p($g(^CTLOC(logonLocId)),"^",13)
	.i logonLocType="W" d
	..s WardID=$o(^PAWARD(0,"WARD_LocationDR",logonLocId,""))
	.i logonLocType="E" d
	..s chl="" f  s chl=$O(^CTLOC(logonLocId,"LINK",chl)) q:chl=""  d
	...s link=$P(^CTLOC(logonLocId,"LINK",chl),"^",1)
	...s logonLocType=$p($g(^CTLOC(link)),"^",13)
	...i logonLocType="W" s WardID=$o(^PAWARD(0,"WARD_LocationDR",link,"")) 
	i WardID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	..s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..q:(curWardId="")!(curBedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
    ..q:bedCode=""
    ..s tmp(bedCode)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID //Modify by liulei 20091118
    s no="" f  s no=$o(tmp(no)) q:no=""  d
    .s patRegNo=$P(tmp(no),"^",1)
    .s patName=$P(tmp(no),"^",2)
    .s bedCode=$P(tmp(no),"^",3)
    .s EpisodeID=$P(tmp(no),"^",4)
	.d OutRowReg
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowReg
	s Data=$lb(patRegNo,patName,bedCode,EpisodeID)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCurWardPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurWardPatExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCurWardPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurWardPatExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

ClassMethod GetDate(morenzhi) As %String
{
	s queryTypeCode=""
	s dedate=+$h 
	f  s queryTypeCode=$o(^DHCCLNurseExec("VarDef",queryTypeCode)) q:queryTypeCode=""  d
	 .s code=queryTypeCode
	 .q:code'=morenzhi
	 .s prechkdays=$p(^DHCCLNurseExec("VarDef",queryTypeCode),"^",5)
	 .;s prechkdays=$p(prechkdays," ",2)
	 .s dedate=dedate-(+$g(prechkdays))
	 .s ddate=$$$zd(dedate,4)
    q $g(ddate)
}

/// 取药品规格
/// INC_Itm,DHC_ItmAddionInfo
ClassMethod GetOrderSpec(oeoriId) As %String
{
	//w ##class(web.DHCNurCom).GetOrderSpec("30||22")
	q:oeoriId="" ""
	s oeordId=+oeoriId
    s oeoriSub=$p(oeoriId,"||",2)
	q:'$d(^OEORD(oeordId,"I",oeoriSub,1)) ""
 	s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
 	q:arcimId="" ""
	s Spec=""
	s incDr=$O(^INCI(0,"ARCIM_DR",+arcimId,""))
	i incDr'="" d
	.s INFORowId=$O(^DHCITMINFO(0,"INCI",incDr,0))
	.i INFORowId'="" s Spec=$P($G(^DHCITMINFO(INFORowId)),"^",27)
 	q Spec
}

ClassMethod updatepersoninfo(EpisodeId As %String, address As %String, lxman As %String, homtel As %String, SecondName As %String, SecondMobPhone As %String, sex As %String, personId As %String, birthday As %String)
{
	n (EpisodeId,address,lxman,homtel,SecondName,SecondMobPhone,sex,personId,birthday)
	q:EpisodeId="" -1
	s papmiId=+$g(^PAADM(EpisodeId))
	q:papmiId="" -2
	;s ^tmpe234er(2)=papmiId_"^"_EpisodeId_"^"_address_"^"_lxman_"^"_homtel_"^"_SecondName_"^"_SecondMobPhone
	s $p(^PAPER(papmiId,"ALL"),"^",4)=homtel
	;&sql(update  pa_person  set paper_stname=:address,paper_foreignid=:lxman where paper_rowid=:papmiId)
	;s ^tmpe234er(3)=SQLCODE
	S ^PAPER(papmiId,"PER","ADD",1)=address     
	s $p(^PAPER(papmiId,"PER",2),"^",13)=lxman
	s $p(^PAPER(papmiId,"DHC"),"^",9)=SecondName
	s $p(^PAPER(papmiId,"DHC"),"^",11)=SecondMobPhone
	i sex'="" d
	.s $p(^PAPER(papmiId,"ALL"),"^",7)=$O(^CT("SEX",0,"Desc",sex,""))
	i birthday'="" d
	.s $p(^PAPER(papmiId,"ALL"),"^",6)=$$$ZDH(birthday,3)
	i personId'="" d
	.s $p(^PAPER(papmiId,"ALL"),"^",9)=personId
	q 0
}

ClassMethod InsertSkinTestOrder(userId, oeoriId, ConAppID, InOut, abnormalFlag) As %String
{
	 q:abnormalFlag=""
	 s length=0
	 s NurseB=""
	 i $D(^tmp("skin",oeoriId)) d
	 .s Oew=$p(^tmp("skin",oeoriId),"^",1)
	 .s sttdate=$o(^OEORDi(0,"StDtSeqNo",$p(Oew,"||",1),""),-1)

	 .s OrdSub=$o(^OEORDi(0,"StDtSeqNo",$p(Oew,"||",1),sttdate,$p(Oew,"||",2),""))

	 .s note=$o(^OEORD($p(Oew,"||",1),"I",OrdSub,"DEP",""),-1)

	 .s length=$l((^OEORD($p(Oew,"||",1),"I",OrdSub,"DEP",note))," ")
	 q:(length=3) "皮试结果已经生效，不能重置" 
	 i $D(^tmp("skin",oeoriId))&&($P(^tmp("skin",oeoriId),"^",2)'=userId) d
	 .s NurseBId=$p(^SSU("SSUSR",userId),"^",14)
	 .i NurseBId'="" s NurseB=$P($g(^CTPCP(NurseBId,1)),"^",2)
	 .s Oew=$p(^tmp("skin",oeoriId),"^",1)
	 .s sttdate=$o(^OEORDi(0,"StDtSeqNo",$p(Oew,"||",1),""),-1)
	 .s OrdSub=$o(^OEORDi(0,"StDtSeqNo",$p(Oew,"||",1),sttdate,$p(Oew,"||",2),""))
	 .s note=$o(^OEORD($p(Oew,"||",1),"I",OrdSub,"DEP",""),-1)
	 .s ^OEORD($p(Oew,"||",1),"I",OrdSub,"DEP",note)=$p(^OEORD($p(Oew,"||",1),"I",OrdSub,"DEP",note)," ",1)_" "_NurseB
	 i $D(^tmp("skin",oeoriId))&&($P(^tmp("skin",oeoriId),"^",2)=userId) d
	 .s $P(^tmp("skin",oeoriId),"^",3)=abnormalFlag 
	 .s Oew=$p(^tmp("skin",oeoriId),"^",1)
	 .s sttdate=$o(^OEORDi(0,"StDtSeqNo",$p(Oew,"||",1),""),-1)
	 .s OrdSub=$o(^OEORDi(0,"StDtSeqNo",$p(Oew,"||",1),sttdate,$p(Oew,"||",2),""))

	 .s note=$o(^OEORD($p(Oew,"||",1),"I",OrdSub,"DEP",""),-1)

	 .s notes=^OEORD($p(Oew,"||",1),"I",OrdSub,"DEP",note)
	 .i (abnormalFlag="Y")&&(notes["-") s ^OEORD($p(Oew,"||",1),"I",OrdSub,"DEP",note)=$TR(notes,"-","+")
	 .i (abnormalFlag="N")&&(notes["+") s ^OEORD($p(Oew,"||",1),"I",OrdSub,"DEP",note)=$TR(notes,"+","-")
	 q:$D(^tmp("skin",oeoriId))  //&&((($P(^tmp("skin",oeoriId),"^",2)'=userId)&&($P(^tmp("skin",oeoriId),"^",3)=abnormalFlag))||(($P(^tmp("skin",oeoriId),"^",2)=userId))) 0
	 s oeordId=$p(oeoriId,"||",1)
	 s EpisodeID=$p($g(^OEORD(oeordId)),"^",1)
	 s arcimId=$g(^DHCCLSet("Skintest","skintestArcimId"))
	 s retInsord=0
	 q:arcimId="" "没有医嘱项目ID(arcimId)，插入皮试医嘱错误!"
	 q:userId="" "没有用户ID(userId)，插入皮试医嘱错误!"
     q:EpisodeID="" "没有EpisodeID，插入皮试医嘱错误！"
     TSTART
     s NurseAId=$p(^SSU("SSUSR",userId),"^",14)
	 i NurseAId'="" s NurseA=$P($g(^CTPCP(NurseAId,1)),"^",2)
     s userDeptId=$p(^PAADM(EpisodeID),"^",4)
     i userDeptId'="",$D(^DHCCLSet("Skintest","AppLocId",userDeptId))'=0 d
	 //s arcimId=$g(^DHCCLSet("Skintest","AppLocId",userDeptId,abnormalFlag))
     s anaId=""      ;OEORI_Anaest_DR        OR_Anaesthesia
     s Ret3=""       ;OEORI_AnaOper_DR       OR_Anaest_Operation
     s billDesc=""   ;OEORI_BillDesc
     s Oew=$p(oeoriId,"||",1)
     s sub=$p(oeoriId,"||",2)
     s ArcimDR=$P($G(^OEORD(Oew,"I",sub,1)),"^",2)
     s ARCIMRowid=$P(ArcimDR,"||",1)
	 s ARCIMSub=$P(ArcimDR,"||",2)
	 s ARCIMD=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)
	 s user=$P($G(^OEORD(Oew,"I",sub,7)),"^",1)
     i abnormalFlag="Y" s ret="(+)"
     e  s ret="(-)"
     s oeoriDepProcNotes=ARCIMD_"皮试"_ret_" "_NurseA_" "_NurseB    ;s PLIST(53)=notes //OEORI_DepProcNotes
     s retInsord=..InsertOrdItem(user, oeordId, arcimId,3,1, userDeptId, anaId, Ret3, "",oeoriDepProcNotes,"","Y",oeoriId,abnormalFlag)
     i +retInsord'=0 TRollBack  q "插入皮试医嘱错误!"
    TCOMMIT
    q 0
}

ClassMethod InsertOrdItem(userId, oeordId, arcimId, oecprId, qty, userDeptId, anaId, anaOpId, billDesc, notes, ConDepID, ifRetRowID = "N", oeoriId, abnormalFlag) As %String
{
	q:(userId="")!(oeordId="")!(arcimId="")!(oecprId="")!(userDeptId="") -1
	//s ^temp("zzz")=userId_"^"_oeordId_"^"_arcimId_"^"_oecprId_"^"_qty_"^"_userDeptId_"^"_anaId_"^"_anaOpId_"^"_billDesc_"^"_notes_"^"_ConDepID_"^"_ifRetRowID
	s oldNameSpace=$ZNSPACE
	s dataNameSpace=$LIST(^websys.ConfigurationD(1),12)
	zn dataNameSpace
    //w $zn,!
    //w userId_","_oeordId_","_arcimId_","_userDeptId_","_notes
	k PLIST
	s PLIST(4)=arcimId
	s PLIST(6)=userDeptId  ;OEORI_OrdDept_DR
	s PLIST(10)=1   ;OEC_OrderStatus：1核4停6执
	s ctcpId=$p(^SSU("SSUSR",+userId),"^",14)
	s PLIST(14)=ctcpId  //careProvId ;OEORI_Doctor_DR:
	s PLIST(17)=+$h ;  OEORI_SttDat
	s PLIST(18)=$p($h,",",2) ;OEORI_SttTim
	s PLIST(23)=oecprId   ;OEORI_Priority_DR:OEC_Priority：3临时，5长期
	s PLIST(29)=qty ;OEORI_PhQtyOrd
	s PLIST(45)=billDesc //OEORI_BillDesc
	s PLIST(55)="Y"  ;OEORI_CoverMainIns  Y
	s PLIST(56)="N"  ;OEORI_PortEquipReq  N
	s PLIST(57)="N"  ;OEORI_AdministerSkinTest N
	s PLIST(75)=ConDepID  //OEORI_RecDep_DR
	s PLIST(76)="TB" //OEORI_Billed

	s PLIST(77)=$$GetSeqNo(oeordId,+$h)  ;OEORI_SeqNo，每天排序//
	  
	s PLIST(81)=+$h    ;OEORI_Date
	s PLIST(90)=$p($h,",",2)    ;OEORI_TimeOrd
	s PLIST(106)=anaId
	s PLIST(107)=anaOpId
	s PLIST(111)="A" ;OEORI_ResultFlag A
	s PLIST(120)=userId ;OEORI_UserAdd
	s PLIST(121)=userDeptId  ;OEORI_UserDepartment_DR
	s PLIST(141)=userId ;OEORI_UserUpdate！
	s admId=+^OEORD(oeordId)
	s PLIST(161)=$p(^PAADM(admId),"^",4) //OEORI_AdmLoc_DR：病人科室
	s PLIST(53)=notes //OEORI_DepProcNotes
	s res=$$insert^MVBOEIT0(oeordId,"Y")
	s oeitm=""
	i res=0 s oeitm=%ROWID
	zn oldNameSpace  ; Restore the namespace
	//s ^ypzTmp("app","in")=res_"/"_oeordId_"/"_%ROWID
	i ifRetRowID="Y" q res_"^"_$G(oeitm)
	q res
GetSeqNo(oeordId,sttdate)
	;生成序列号,原来的程序有点累最
	;Set err=$$lastseq^MVBOEORD(ord,sttdate)
	;Set LastSeqNo=PLIST(1)
	Set LastSeqNo=$o(^OEORDi(0,"StDtSeqNo",oeordId,sttdate,""),-1)
    i LastSeqNo["." s LastSeqNo=$p(LastSeqNo,".")
	Set SeqNo=+LastSeqNo+1
	s oeoriId1=oeordId_"||"_SeqNo
	s ^tmp("skin",oeoriId)=oeoriId1_"^"_userId_"^"_abnormalFlag
	Q SeqNo
}

ClassMethod InsertSkinTestOrder22(userId, oeoriId, ConAppID, InOut, abnormalFlag) As %String
{
	 s ^tep(oeoriId)=userId_"^"_abnormalFlag
	 q:abnormalFlag="" 	 
	 s oeordId=$p(oeoriId,"||",1)
	 s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	 s EpisodeID=$p($g(^OEORD(oeordId)),"^",1)
	 s arcimId=$g(^DHCCLSet("Skintest","skintestArcimId"))
	 s retInsord=0
	 s NurseB=""
	 q:arcimId="" "没有医嘱项目ID(arcimId)，插入皮试医嘱错误!"
	 q:userId="" "没有用户ID(userId)，插入皮试医嘱错误!"
     q:EpisodeID="" "没有EpisodeID，插入皮试医嘱错误！"
     TSTART
     s NurseDr=$p(^SSU("SSUSR",userId),"^",14)
     s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
     i dhcoriId'="" d 
      .;s skinTestCtcpId=$p(^DHCORDItem(dhcoriId),"^",2)

      .;i skinTestCtcpId="" q
      .;s NurseA=$p($g(^CTPCP(skinTestCtcpId,1)),"^",2)
      .i NurseDr'="" s NurseA=$P($g(^CTPCP(NurseDr,1)),"^",2)

      .s skinTestAuditCtcpId=$p(^DHCORDItem(dhcoriId),"^",13)
      .i skinTestAuditCtcpId="" q
      .s NurseB=$p($g(^CTPCP(skinTestAuditCtcpId,1)),"^",2)
	  .;i NurseB'="" s NurseA=NurseA_","_NurseB 
     ;i NurseDr'="" s NurseA=$P($g(^CTPCP(NurseDr,1)),"^",2)
     s userDeptId=$p(^PAADM(EpisodeID),"^",4)
     i userDeptId'="",$D(^DHCCLSet("Skintest","AppLocId",userDeptId))'=0 d
	 //s arcimId=$g(^DHCCLSet("Skintest","AppLocId",userDeptId,abnormalFlag))
     s anaId=""      ;OEORI_Anaest_DR        OR_Anaesthesia
     s Ret3=""       ;OEORI_AnaOper_DR       OR_Anaest_Operation
     s billDesc=""   ;OEORI_BillDesc
     s Oew=$p(oeoriId,"||",1)
     s sub=$p(oeoriId,"||",2)
     s ArcimDR=$P($G(^OEORD(Oew,"I",sub,1)),"^",2)
     s ARCIMRowid=$P(ArcimDR,"||",1)
	 s ARCIMSub=$P(ArcimDR,"||",2)
	 s ARCIMD=$P($G(^ARCIM(ARCIMRowid,ARCIMSub,1)),"^",2)
     i abnormalFlag="Y" s ret="(+)"
     e  s ret="(-)"
     s oeoriDepProcNotes=ARCIMD_"皮试"_ret_" "_NurseA   ;s PLIST(53)=notes //OEORI_DepProcNotes
     ;s user=$P($G(^OEORD(Oew,"I",sub,7)),"^",1)
     s retInsord=..InsertOrdItem(userId, oeordId, arcimId,3,1, userDeptId, anaId, Ret3, "",oeoriDepProcNotes,"","Y",oeoriId,abnormalFlag)
     i +retInsord'=0 TRollBack  q "插入皮试医嘱错误!"
    TCOMMIT
    q 0
}

// 护理病历病人列表 2017.2.27 ()

// d ##class(%ResultSet).RunQuery("web.DHCNurCom","FindCurWardPats","5")

/// 血糖单
ClassMethod FindCurWardPatsExecute(ByRef qHandle As %Binary, WardID As %String) As %Status
{
	s repid=$i(^CacheTemp)
	i WardID="" d
	.s logonLocId=%session.Data("LOGON.CTLOCID")
	.s logonLocType=$p($g(^CTLOC(logonLocId)),"^",13)
	.i (logonLocType="W")!(logonLocType="EM") d
	..s WardID=$o(^PAWARD(0,"WARD_LocationDR",logonLocId,""))
	.i logonLocType="E" d
	..s chl="" f  s chl=$O(^CTLOC(logonLocId,"LINK",chl)) q:chl=""  d
	...s link=$P(^CTLOC(logonLocId,"LINK",chl),"^",1)
	...s logonLocType=$p($g(^CTLOC(link)),"^",13)
	...i logonLocType="W" s WardID=$o(^PAWARD(0,"WARD_LocationDR",link,"")) 
	i WardID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	s ind=1
	k HBChildArray
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	..s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..q:(curWardId="")!(curBedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1)
    ..q:bedCode=""
    ..s bedname=bedCode_"床"
    ..s MotherAdm=$p($g(^PAADM(EpisodeID)),"^",75)
   
	..i MotherAdm'=""  d
	...//b ;22
	...i '$d(HBChildArray(MotherAdm,bedname,EpisodeID))  d  //2017.2.27解决婴儿丢失问题
	....//b ;
	....s HBChildArray(MotherAdm,bedname,EpisodeID)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID
	..q:MotherAdm'=""
    ..s tmp(bedname)=patRegNo_"^"_patName_"^"_bedCode_"^"_EpisodeID //Modify by liulei 20091118
    s no="" f  s no=$o(tmp(no)) q:no=""  d
    .s patRegNo=$P(tmp(no),"^",1)
    .s patName=$P(tmp(no),"^",2)
    .s bedCode=$P(tmp(no),"^",3)
    .s EpisodeID=$P(tmp(no),"^",4)
	.d OutRowReg1
	.i $d(HBChildArray(EpisodeID))  d
	..b ;1
	..s madm=EpisodeID
	..s rw="" f  s rw=$o(HBChildArray(madm,rw)) q:rw=""  d
	...s rw2="" f  s rw2=$o(HBChildArray(madm,rw,rw2)) q:rw2=""  d
	....s patRegNo=$P(HBChildArray(madm,rw,rw2),"^",1)
    ....s patName=$P(HBChildArray(madm,rw,rw2),"^",2)
    ....s bedCode=$P(HBChildArray(madm,rw,rw2),"^",3)
    ....s EpisodeID=$P(HBChildArray(madm,rw,rw2),"^",4)
	....d OutRowReg1
	s chl="" f  s chl=$o(^PAWARDA(WardID,"WADM",chl)) q:chl=""  d
	.q:'$d(^PAWARDA(WardID,"WADM",chl))
	.q:chl=0
	.s EpisodeID=$p(^PAWARDA(WardID,"WADM",chl),"^")
	.s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	.s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
	.s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1)
	.s bedCode="等候区"
	.d OutRowReg1
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowReg1
	s Data=$lb(patRegNo,patName,bedCode,EpisodeID)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCurWardPatsFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurWardPatsExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCurWardPatsClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurWardPatsExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

Query FindCurWardPats(WardID As %String) As %Query(ROWSPEC = "patRegNo:%String,patName:%String,bedCode:%String,EpisodeID:%String")
{
}

/// 门急诊执行医嘱界面,刷卡后显示病人有医嘱的单据
/// 输液单/注射单/治疗单
ClassMethod GetPatOrdBtn(ssgrp As %String, wardId As %String, regNo As %String, userId As %String, startDate As %String, endDate As %String, queryTypeCode As %String, gap As %String, locId As %String, admType As %String, exeFlag As %String, HospitalRowId As %String) As %String
{

	//w ##class(web.DHCNurCom).GetPatOrdBtn(204,"","0000111133^77352",69,"13/07/2011","13/07/2011","Default","","","O",0,0)
	i startDate'="" s startDate=$$$ZDH(startDate,4)
	i endDate'="" s endDate=$$$ZDH(endDate,4)
	s retType=""
	//循环安全组中的单据
	s rset=##class(%ResultSet).%New("web.DHCNurCom:GetQueryType")
	do rset.Execute(ssgrp, userId)
	while (rset.Next()) {
		//s typeDesc=rset.GetData(1)
		s typeCode=rset.GetData(2)
		s HospitalRowId=$P(typeCode,"@",1)
		s queryTypeCode=$P(typeCode,"@",2)
		if (HospitalRowId="")!(queryTypeCode="") continue 		
		//根据单据代码与界面的登记号等入参,查询病人此单据中是否有医嘱
		s rsetord=##class(%ResultSet).%New("web.DHCNurCom:FindOrditem")
		do rsetord.Execute(wardId,regNo,userId,startDate,endDate,queryTypeCode,gap,locId,admType,exeFlag,HospitalRowId)
		while (rsetord.Next()) {
			b //2
			if retType'[typeCode s retType=retType_typeCode_"^" q
		}	
		d rsetord.Close()
	}
	d rset.Close()
	q retType
}

ClassMethod SetSkinTestResultXH(oriOreId, userId, flag, SkinDate As %String = "", SkinTime As %String = "", skinNote = "") As %String
{
    //皮试处理
    n (oriOreId,userId,flag,SkinDate,SkinTime,skinNote)
    s oeordId=+oriOreId
    s oeoriSub=$p(oriOreId,"||",2)
    s oeoriId=oeordId_"||"_oeoriSub
    s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
    s phcinSkinTest=##class(Nur.CommonInterface.Order).ifPhcinSkinTest(oeordId,oeoriSub)
    s:phcinSkinTest=1 skinTestFlag="Y" 
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1)
    //i (skinTestFlag'="Y")&(actCode'="YY")&(actCode'="MS") q "非皮试医嘱!"
    s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
    s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    i stayFlag'=1 s prtId=##class(DHCCLCom).GetPrtId(oeoriId)
    i ((skinTestFlag="Y")&&(phcinSkinTest=1))&&(stayFlag'=1)&(prtId="") q oeoriId_$p(..GetArcim(oeoriId),"^",1)_"未找到病人发票!不能操作!"
    s payMode=""  //##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
    q:(((payMode'=1)&(stayFlag=1))!(stayFlag'=1))&(oeoriBilled'="P")&(actCode="YY") "原液未交费不能置皮试结果"
    i (oeoriBilled="P")&(actCode'="YY")&(actCode'="MS") q "已结算医嘱不能置皮试结果!" //ypz 061128
    
   	//ypz 060924 begin
	s ordStatCode=##Class(web.DHCCLCom).GetOrdStatCode(oeoriId)  //070204
	i ordStatCode="D" q "停止医嘱不能置皮试结果!"
    s preFlag=$p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)
    //i preFlag=flag q "所置状态与原来相同,未改变皮试状态!"
	s IfPPDOrder=##class(web.DHCNurSkinTestList).GetIfPPDOrder(oriOreId)
	i IfPPDOrder'=1,preFlag=flag q "所置状态与原来相同,未改变皮试状态!"   
    //由阳性改为阴性时，已执行医嘱可以撤消
	//i (preFlag'="Y")&(..IfExecOrder(oeoriId)=1)  q "医嘱已执行，不能置皮试结果!" //070413
	
	s admType=$p(^PAADM(+^OEORD(oeordId)),"^",2),skinTestInstr=""
	i admType="I" s skinTestInstr=$g(^DHCCLSet("Exec","SkinTestInstr"))
	s phcinId=+$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",7)
    s dispStat=##class(web.DHCCLCom).GetDispensingStat(oeoriId,"N") //070911
    //s dispStat="",oeoreSub=""
    //f  s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub)) q:(oeoreSub="")  d
	//    .s dspSub=0
	//   	.f  s dspSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)) q:(dspSub="")  d
	//       	..s dspStr=^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub,"D",dspSub)
	//       	..i $p(dspStr,"^",6)'="",dispStat'="C" s dispStat=$p(dspStr,"^",6)  //ypz 070318 add '=C"
	s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	;i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(dispStat="")&(arcicOrderType="R") q "无发药状态!"
	//i (("^"_skinTestInstr_"^")'[("^"_+phcinId_"^"))&(actCode'="YY")&(actCode'="MS")&(dispStat="C") q "不能对已发药医嘱操作!"  //ypz
	//ypz 060924

    ////i $p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)'="" q "已有皮试状态,不能修改!"
 	//&sql(update oe_orditem set OEORI_Abnormal=:flag where oeori_rowid=:rowid)
	s ctcpId=$p(^SSU("SSUSR",userId),"^",14)
	s curDate=+$h,curTime=$p($h,",",2)
	//PPD试验结果写入医嘱备注20110704
	i $D(skinNote) s resStr=..UpdateOrderNote(oriOreId,skinNote)
	
	////多次置结果的控制?//同一次
	s dhcoriId=$o(^DHCORDItem(0,oeoriId,""))
	i dhcoriId="" &sql(insert into DHC_OE_OrdItem(DHCORI_OEORI_Dr,DHCORI_SkinTestCtcp_Dr,DHCORI_SkinTestDate,DHCORI_SkinTestTime) values(:oeoriId,:ctcpId,:curDate,:curTime))
	e  &sql(update DHC_OE_OrdItem set DHCORI_SkinTestCtcp_Dr=:ctcpId,DHCORI_SkinTestDate=:curDate,DHCORI_SkinTestTime=:curTime where DHCORI_OEORI_Dr=:oeoriId)
	s $p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)=flag
	s ^OEORDi(0,"Abnorm",oeordId,oeoriSub)=""
	s resStr=0
	i arcicOrderType="R" s resStr=##class(web.DHCCLCom).UpdatePatAllergy(oeoriId,userId,flag)
	i resStr'=0 q resStr
	
	//i admType'="I" q "操作成功!"
	//i flag="Y" s resStr=..UpdateOrdGroup("Y",oeoriId,userId,1)
	i (##class(Nur.CommonInterface.Order).ifPhcinSkinTest(oeordId,oeoriSub)=1) s resStr=..UpdateOrdGroup("Y",oeoriId,userId,1)
	//i flag'="Y",preFlag="Y" s resStr=..UpdateOrdGroup("Y",oeoriId,userId,0)
	i resStr=0  q "操作成功!"
	q resStr
}

/// 修改医嘱备注/PPD试验结果
/// ^DHCCLSet("Exec","PPDArcimDr")
ClassMethod UpdateOrderNote(oeoriId, skinNote) As %String
{
	s IfPPDOrder=##class(web.DHCNurSkinTestList).GetIfPPDOrder(oeoriId)
	q:IfPPDOrder'=1 0
	s oeordId=$P(oeoriId,"||",1)
	s oeoriSub=$P(oeoriId,"||",2)	
	s maxIndex=+$G(^OEORD(oeordId,"I",oeoriSub,"DEP",0))
	s lastNote=$G(^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex))
	b ;1
	i (lastNote="")!(lastNote["皮肤硬结")!(lastNote["局部水泡")!(lastNote["坏死")!(lastNote["淋巴管炎")!(lastNote["红肿") d
	.s ^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex)=skinNote
	e  d
	.s maxIndex=maxIndex+1
	.s ^OEORD(oeordId,"I",oeoriSub,"DEP",0)=maxIndex
	.s ^OEORD(oeordId,"I",oeoriSub,"DEP",maxIndex)=skinNote
	q 0
}

Query FindCurWardPatInfo(WardID As %String) As %Query(ROWSPEC = "bedCode:%String,patName:%String,Medicare:%String,patAge:%String,patSex:%String,AdmDate:%String,food:%String,regNo:%String,MainNurse:%String,MainDoc:%String,EncryptLevel:%String,PatLevel:%String,SecretCode:%String,EpisodeID:%String,PatientID:%String")
{
}

ClassMethod FindCurWardPatInfoExecute(ByRef qHandle As %Binary, WardID As %String) As %Status
{
	s repid=$i(^CacheTemp)
	s ind=1
	//s ^PanTemp("FindCurWardPatInfo")=WardID
	i WardID="" d
 	.s logonLocId=%session.Data("LOGON.CTLOCID")
 	.//s ^PanTemp("FindCurWardPatInfo1")=logonLocId
 	.s logonLocType=$p($g(^CTLOC(logonLocId)),"^",13)
	.i logonLocType="W" d
	..s WardID=$o(^PAWARD(0,"WARD_LocationDR",logonLocId,""))
	//s ^PanTemp("FindCurWardPatInfo2")=WardID
	i WardID="" s ind=1 s qHandle=$lb(0,repid,0) Quit $$$OK
	s curRoomId=0 f  s curRoomId=$o(^PAADMi("CurrWard",WardID,curRoomId)) q:curRoomId=""  d
	.s EpisodeID=0 f  s EpisodeID=$o(^PAADMi("CurrWard",WardID,curRoomId,EpisodeID)) q:EpisodeID=""  d
	..s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    ..i pavisit'="A" q
    ..s AdmDatetTime=##class(web.DHCDischargeHistory).GetAdminDateTime(EpisodeID)
	..s AdmDate=$p(AdmDatetTime,"^",1)
	..s AdmTime=$p(AdmDatetTime,"^",2)
	..i AdmDate'="" s AdmDate=$$$ZD(AdmDate,3)
	..i AdmTime'="" s AdmTime=$ZT(AdmTime)
    ..;s AdmDate=$ZD($p($g(^PAADM(EpisodeID)),"^",6),3) //入院日期
	..s PatientID=$p($g(^PAADM(EpisodeID)),"^",1)
	..s patRegNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1) //登记号
	..s patName=$p($g(^PAPER(PatientID,"ALL")),"^",1) //姓名
	..s patBornDate=$p($g(^PAPER(PatientID,"ALL")),"^",6)
	..s patAge=##class(web.DHCBillInterface).GetPapmiAge((+^PAADM(EpisodeID)),EpisodeID)	
	..s Medicare=##class(web.DHCWMRService).IGetMrNoByEpisodeID(EpisodeID)
    ..s:(Medicare="-2")!(Medicare="-1") Medicare=""
	..s SexID=$p($g(^PAPER(PatientID,"ALL")),"^",7)
	..s patSex=$p($g(^CT("SEX",SexID)),"^",2) //性别
	..s bedSub=$p($g(^PAADM(EpisodeID)),"^",73)
	..q:bedSub=""
	..s curWardId=$P(bedSub,"||",1)
	..s curBedSub=$P(bedSub,"||",2)
	..q:(curWardId="")!(curBedSub="")
	..s bedCode=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",1) //床号
 	..q:bedCode=""
 	..s food=##class(web.DHCLCNUREXCUTE).GetItemCatOrd(EpisodeID,"无费用嘱托(饮食)")
 	..s Loc=$P($g(^PAADM(EpisodeID)),"^",4)
 	..s doc=$p(^PAADM(EpisodeID),"^",9)
	..i doc'="" s DocDes=$P($g(^CTPCP(doc,1)),"^",2)
	..i doc="" s DocDes=""
	..s HeadDocDescUnite=""
    ..i ((doc'="")&&(Loc'="")) s HeadDocDescUnite=##class(web.DHCDocInPatientList).GetHadeUniteDoc(doc,Loc)
    ..//i ((doc'="")&&(Loc="")) s HeadDocDescUnite=$g(DocDes)
    ..i HeadDocDescUnite=$g(DocDes) s HeadDocDescUnite=""
    ..i HeadDocDescUnite'="" s HeadDocDescUnite="组长:"_HeadDocDescUnite
	..s MainNur1=$p(##Class(web.DHCMainNurse).GetWardNurse(EpisodeID),"^",3)
	..s MainNur2=$p(##Class(web.DHCMainNurse).GetWardNurse(EpisodeID),"^",5)
 	..s MainNurse=MainNur1_" "_MainNur2
 	..Set PatEncryptLevel=##class(web.DHCCLCom).GetPatEncryptLevel("",EpisodeID)
    ..Set EncryptLevel=$p(PatEncryptLevel,"^",1)
    ..Set PatLevel=$p(PatEncryptLevel,"^",2) 
    ..Set SecretCode=$p(PatEncryptLevel,"^",3) 
 	..;s Data(bedCode_curBedSub)=bedCode_"^"_patName_"^"_patSex_"^"_patAge_"^"_Medicare_"^"_AdmDate_"^"_food_"^"_patRegNo_"^"_MainNurse_"^"_HeadDocDescUnite_" "_$g(DocDes)
 	..;s Data(bedCode_curBedSub)=Data(bedCode_curBedSub)_"^"_EncryptLevel_"^"_PatLevel_"^"_EpisodeID_"^"_PatientID_"^"_SecretCode
 	..s x=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",15)
    ..s y=$p($g(^PAWARD(curWardId,"BED",curBedSub)),"^",16)
    ..s:x="" x=curWardId
    ..s:y="" y=curBedSub
    ..s Data(y,x)=bedCode_"^"_patName_"^"_patSex_"^"_patAge_"^"_Medicare_"^"_AdmDate_"^"_food_"^"_patRegNo_"^"_MainNurse_"^"_$g(DocDes)_" "_HeadDocDescUnite
    ..s Data(y,x)=Data(y,x)_"^"_EncryptLevel_"^"_PatLevel_"^"_EpisodeID_"^"_PatientID_"^"_SecretCode
 	s r="" f  s r=$O(Data(r)) q:r=""  d
 	.s rsub="" f  s rsub=$O(Data(r,rsub)) q:rsub=""  d
 	..s bedCode=$P(Data(r,rsub),"^",1)
 	..s patName=$P(Data(r,rsub),"^",2)
 	..s patSex=$P(Data(r,rsub),"^",3)
 	..s patAge=$P(Data(r,rsub),"^",4)
 	..s Medicare=$P(Data(r,rsub),"^",5)
 	..s AdmDate=$P(Data(r,rsub),"^",6)
 	..s food=$P(Data(r,rsub),"^",7)
 	..s regNo=$P(Data(r,rsub),"^",8)
 	..s MainNurse=$P(Data(r,rsub),"^",9)
 	..s MainDoc=$P(Data(r,rsub),"^",10)
 	..s EncryptLevel=$P(Data(r,rsub),"^",11)
 	..s PatLevel=$P(Data(r,rsub),"^",12)
 	..s EpisodeID=$P(Data(r,rsub),"^",13)
 	..s PatientID=$P(Data(r,rsub),"^",14)
 	..s SecretCode=$P(Data(r,rsub),"^",15)
	..d OutRowInfo
	s qHandle=$lb(0,repid,0)
	q $$$OK

OutRowInfo
	s Data=$lb(bedCode,patName,Medicare,patAge,patSex,AdmDate,food,regNo,MainNurse,MainDoc,EncryptLevel,PatLevel,SecretCode,EpisodeID,PatientID)
	s ^CacheTemp(repid,ind)=Data
	s ind=ind+1
	q
}

ClassMethod FindCurWardPatInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCurWardPatInfoExecute ]
{
	s AtEnd=$li(qHandle,1)
	s repid=$li(qHandle,2)
	s ind=$li(qHandle,3)
	s ind=$o(^CacheTemp(repid,ind))
	i ind="" {				// if there are no more rows, finish fetching
		s AtEnd=1
		s Row=""
	}
	else {			
		s Row=^CacheTemp(repid,ind)
	}
	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod FindCurWardPatInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCurWardPatInfoExecute ]
{
	s repid=$li(qHandle,2)
	k ^CacheTemp(repid)
	q $$$OK
}

Query FindWardItem(CtLocDesc As %String = "", Ward As %String = "", HospID) As %Query(ROWSPEC = "Ward:%String,Code:%String,WardDr:%String")
{
}

ClassMethod FindWardItemExecute(ByRef qHandle As %Binary, CtLocDesc As %String = "", Ward As %String = "", HospID) As %Status
{
	s ^tempsc("FindWardItemExecute")=$lb(HospID)
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	i HospID="" Set qHandle=$lb(0,repid,0) q $$$OK
	s linkCtloc=""
 	s CtLocDr=""
 	i CtLocDesc'="" d
 	.s CtLocDr=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(CtLocDesc),""))
 	.q:CtLocDr=""
 	.s linkCtloc=""
 	.s childSub=0
 	.f  s childSub=$o(^CTLOC(CtLocDr,"LINK",childSub)) q:childSub=""  d
 	..s $p(linkCtloc,"^",$l(linkCtloc,"^")+1)=^CTLOC(CtLocDr,"LINK",childSub)
 	..s linkCtloc=linkCtloc_"^"
 	s WardDr=0
 	f  s WardDr=$o(^PAWARD(WardDr)) q:(WardDr="")||(+WardDr=0)  d
 	.s WardDesc=$p(^PAWARD(WardDr),"^",2)
 	.s WardCode=$p(^PAWARD(WardDr),"^",1)
 	.s LinkCtLoc=$p(^PAWARD(WardDr),"^",5)
 	.s LinkCtLoc="^"_LinkCtLoc_"^"
 	.s CTLocDr= $p($g(^PAWARD(WardDr)),"^",5)
 	.s CTLocCode= $p($g(^CTLOC(CTLocDr)),"^",43)
 	.q:(CtLocDr'="")&(linkCtloc'[LinkCtLoc)
 	.q:(Ward'="")&(WardDesc'[$$ALPHAUP^SSUTIL4(Ward))&(CTLocCode'[$$ALPHAUP^SSUTIL4(Ward))
 	.s ifShow=##class(web.DHCBL.BDP.BDPMappingHOSP).GetHospShowDataFlag("PAC_Ward",WardDr,HospID)
 	.q:ifShow'="Y"
 	.d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(WardDesc,WardCode,WardDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindWardItemFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindWardItemExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindWardItemClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindWardItemExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod getflag(oeoriId) As %String
{
	s ret=""
	s ord=+oeoriId,chl=$p(oeoriId,"||",2),ordsub=$p(oeoriId,"||",3)
	s sqno=$p(^OEORD(ord,"I",chl,11),"^",39)
	i sqno="" d
	.s ret=oeoriId
	e  d
	.i ordsub="" s ret=sqno
	.e  s ret=sqno_"||"_ordsub
	q ret
}

// 执行并打印获取执行人和执行时间

ClassMethod GetPrintdata(oeoriId) As %String
{
	n (oeoriId)
	q:(oeoriId="")!($l(oeoriId,"||")=2) ""
	s ret=""
	s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
    s execdate=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",19)
    s exectime=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",20)
    s val("execDateTime")=##Class(web.DHCCLCom).FormatDate(execdate)_" "_##Class(web.DHCCLCom).FormatTime(exectime)  //执行时间
    s CtcpDR=$p(^OEORD(oeordId,"I",oeoriSub,"X",oeoreSub),"^",15)
    i CtcpDR'="" s val("execCtcpDesc")=$p($g(^CTPCP(CtcpDR,1)),"^",2)  //执行人
    s:$g(val("execCtcpDesc"))'="" ret="execCtcpDesc"_"|"_val("execCtcpDesc")_"^"_"execDateTime"_"|"_val("execDateTime")
    q ret
}

ClassMethod Updateordstr(oeriestr, userDept, userId, querytypCode)
{
	s err=0
	s l=$l(oeriestr,"^")
	
	f i=1:1:l  d
	.s oeorid=$p(oeriestr,"^",i)
	.q:oeorid=""
	.s resStr=##class(web.DHCLCNUREXCUTE).UpdateOrdGroup("",oeorid,"F",userId,userDept,querytypCode,"","","")
	.i resStr'=0 s err=resStr
	.i (querytypCode["JYD")&(resStr=0) d
	.s ret=##class(web.DHCNurSpecerNo).UpdateSpacer(oeorid,userId)  //检验单执行更新采血时间操作

	q $g(err)
}

ClassMethod setdiscdstr(oeriestr, userId) As %String
{
    s err=0
    s ^TMP("ord")=$LB(oeriestr, execinfo, userId, setExecFlag)
    s l=$l(oeriestr,"^")
    s tmp=""
    f i=1:1:l  d
    .s oeorid=$p(oeriestr,"^",i)
    .q:oeorid=""
    .s resStr=##class(web.DHCLCNUREXCUTE).SetDisconOrder(oeorid,userId)
    .i resStr'=0 s err=resStr
    q $g(err)
}

ClassMethod SetSkinordstr(oeriestr, userId, flag, querytypCode, locId)
{
	s ^FLLCC=oeriestr_"!"_userId_"!"_flag
	s err=0
	s l=$l(oeriestr,"^")
	s tmp=""
	f i=1:1:l  d
	.s oeorid=$p(oeriestr,"^",i)
	.q:oeorid=""
	.s tmp(+oeorid)=""
	.s nextOrd=+oeorid
	.s oreStr=oeorid
	.s resStr=##class(web.DHCLCNUREXCUTE).SetSkinTestResult(oreStr, userId, flag,"F",locId,querytypCode,"","","")
	.i resStr'=0 s err=resStr
	s rw=""  f  s rw=$O(tmp(rw)) q:rw=""  d
	.//s rtn=##Class(web.UDHCJFBILL).BILLN(+^OEORD(rw),"","") 
	q $g(err)
}

/// /获取需处理医嘱处理类型
/// /d ##class(%ResultSet).RunQuery("web.DHCNurCom","getSeeType")
Query getSeeType() As %Query(ROWSPEC = "SeeTypeDesc:%String,SeeTypeId:%String")
{
}

ClassMethod getSeeTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
    for i=1:1:3
	{
	 s SeeTypeId=$s(i=1:"A",i=2:"R",i=3:"F",1:"")
	 s SeeTypeDesc=$s(i=1:"接受",i=2:"拒绝",i=3:"完成",1:"")
	 Do OutputSeeType
	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputSeeType
	set Data=$lb(SeeTypeDesc,SeeTypeId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod getSeeTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = getSeeTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod getSeeTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = getSeeTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// /门诊护士执行时更新采血时间
ClassMethod UpdatespecCollDatetime(oeoriId As %String, userId As %String)
{
 
   n (oeoriId,userId)
   s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
   s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
   q:labNo="" ""   ///标本号为空的认为不是检验医嘱
   i oeoreSub="" s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
   q:oeoreSub="" ""
   s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
   s curDate=+$h,curTime=$p($h,",",2)
   ts
   s obj=##class(User.OEOrdExecExt).%OpenId(oeoriId)
   i '$Isobject(obj) tro  q ""
   s SpecCollUserDR=obj.OEORESpecCollUserDR
   i SpecCollUserDR'="" tro  q ""  ///已经采血过的不再更新
   s obj.OEORESpecCollUserDR=##class(User.SSUser).%OpenId(userId)
   s obj.OEORESpecCollDate=curDate
   s obj.OEORESpecCollTime=curTime
   b ;123
   s sc=obj.%Save()
   i $$$ISERR(sc)
   {
	   s ret=$System.Status.GetErrorText(sc)
	   tro
	   q ret
   }
   tc
   q 0
}

/// /门诊护士撤销执行时将采血时间置空
ClassMethod CancelspecCollDatetime(oeoriId As %String)
{
   n (oeoriId)
   s oeordId=+oeoriId,oeoriSub=$p(oeoriId,"||",2),oeoreSub=$p(oeoriId,"||",3)
   s labNo=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",20)
   q:labNo="" ""   ///标本号为空的认为不是检验医嘱
   i oeoreSub="" s oeoreSub=$o(^OEORD(oeordId,"I",oeoriSub,"X",0))
   q:oeoreSub="" ""
   s oeoriId=oeordId_"||"_oeoriSub_"||"_oeoreSub
   s nullValue=""
   ts
   s obj=##class(User.OEOrdExecExt).%OpenId(oeoriId)
   i '$Isobject(obj) tro  q ""
   s obj.OEORESpecCollUserDR=nullValue
   s obj.OEORESpecCollDate=nullValue
   s obj.OEORESpecCollTime=nullValue
   s sc=obj.%Save()
   i $$$ISERR(sc)
   {
	   s ret=$System.Status.GetErrorText(sc)
	   tro
	   q ret
   }
   tc
   q 0
}

ClassMethod getPrintFlag(oeoriId)
{
	s obj=##class(User.OEOrdExecExt).%OpenId(oeoriId)
	q:'$Isobject(obj) ""
	s printFlag=obj.OEOREPrinted
	q printFlag
}

/// /门诊打印置标记
/// ##class(web.DHCNurCom).SetPrintFlagNew(90,69,"SYDO","312||5||1^312||6||1","Y")
ClassMethod SetPrintFlagNew(wardId, userId, queryTypeCode, oeoriIdStr, dhcorePrinted = "") As %String
{
	
 	n (wardId, userId, queryTypeCode, oeoriIdStr,dhcorePrinted)
 	q:(userId="")!(queryTypeCode="")!(oeoriIdStr="") -1
	s num=$l(oeoriIdStr,"^")
    s curDate=+$h,curTime=$p($h,",",2)
	s err=0
	f i=1:1:num d
	    .s oeoriId=$p(oeoriIdStr,"^",i)
	    .q:oeoriId=""
	    .i $l(oeoriId,"||")<3 d
	    ..s oeoreId=..GetFirstOeoreId(oeoriId,"Insert")
	    ..q:oeoreId=""
	    .e  d
	    ..s oeoreId=oeoriId
	    .k obj
	    .s obj=##class(User.OEOrdExecExt).%OpenId(oeoreId)
	    .q:'$Isobject(obj)
	    .s Oldprinted=obj.OEOREPrinted
	    .i Oldprinted'[dhcorePrinted  d
	    ..s dhcorePrintedFlag=Oldprinted_dhcorePrinted
	    ..s obj.OEOREPrinted=dhcorePrintedFlag
	    .e  d
	    ..s obj.OEOREPrinted=Oldprinted
	    .s obj.OEOREPrintDate=curDate
	    .s obj.OEOREPrintTime=curTime
	    .i userId'="" d obj.OEOREPrintUserDRSetObjectId(userId)
	    .s obj.OEOREQueryCode=queryTypeCode
	    .s sc=obj.%Save()
        .i $$$ISERR(sc) d
	    ..s err=$System.Status.GetErrorText(sc)
	    .d obj.%Close()
    q err
}

ClassMethod getLinkWard(LocID)
{
	s ret=""
	s chl=0 f  s chl=$O(^CTLOC(LocID,"LINK",chl)) q:(chl="")!(ret'="")  d
	.s link=$P(^CTLOC(LocID,"LINK",chl),"^",1)
	.s logonLocType=$p($g(^CTLOC(link)),"^",13)
	.i logonLocType="W" d
	..s WardId=$o(^PAWARD(0,"WARD_LocationDR",link,"")) 
	..s WardDesc=$p(^PAWARD(WardId),"^",2)
	..s WardCode=$p(^PAWARD(WardId),"^",1)
	..s ret=WardDesc_"^"_WardCode
	Q ret
}

/// /取收费员录入的医嘱数量
ClassMethod GetOrderBaseQtyMZ(oeoriId) As %String
{
	//取医嘱计价数量
	q:oeoriId="" 0
	s oeordId=$p(oeoriId,"||",1),oeoriSub=$p(oeoriId,"||",2)
    s arcimId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",2)
    q:arcimId="" 0
	s phOrdQty = 0
	s dispensingID = ""
	f  s dispensingID=$o(^DHCOEDISQTY(0,"OEORI",oeoriId,dispensingID)) q:dispensingID=""  d
	.s phOrdQty = $p($G(^DHCOEDISQTY(dispensingID)),"^",5)
	s arcicOrderType=##Class(web.DHCCLCom).GetOrdSubCatType(oeoriId)
	b ;-1
	q:arcicOrderType'="R" phOrdQty
	
	s doseQty=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",1)
    i doseQty="" q phOrdQty
    s phcfrFactor=1
    s phcfrId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",4)
    i phcfrId="" q phOrdQty
    s phcfrFactor=$p(^PHCFR(phcfrId),"^",2)

	//s unitUomId=934
    s phcdfId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),1)),"^",12)
    b ;0
    q:phcdfId="" phOrdQty
    s phcdId=+phcdfId,phcdfSub=$p(phcdfId,"||",2)
    s baseUomId=$p($g(^PHCD(phcdId,"DF",phcdfSub,2)),"^",4)
    
    s qtyPackUom=$p($g(^OEORD(oeordId,"I",oeoriSub,9)),"^",4)
    s packUomId=$p($g(^ARCIM(+arcimId,$p(arcimId,"||",2),8)),"^",14)
    i $g(^OEORD(oeordId,"I",oeoriSub,"DHC"))'="" s packUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",13)
    //w packUomId_","_qtyPackUom_"/",!
    s packDoseQty=0
    i +qtyPackUom'=0,packUomId'="" d
        .s factor=1
        .i baseUomId'=packUomId d
            ..s ctcfId=$o(^CT("CTCF",0,"UOM",packUomId,baseUomId,""))
		    ..i ctcfId'="" s factor=$p(^CT("CTCF",ctcfId),"^",3)
		.//w "factor="_factor,!
	    .q:+factor=0
		.s packDoseQty=qtyPackUom*factor ;;dQty/factor  ;包装单位转换
		.i $p(packDoseQty,".",2)>0 s packDoseQty=$p(packDoseQty,".",1)+1
		b ;1
	i packDoseQty'=0 q packDoseQty
    
	s phcduId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",6)
	s phcduFactor=1
	i phcduId'="" s phcduFactor=$p(^PHCDU(phcduId),"^",2)
	b ;2
	i +phcduFactor=0 q phOrdQty
    s unitUomId=$p($g(^OEORD(oeordId,"I",oeoriSub,2)),"^",3)
    //w oeoriSub_"||"_unitUomId_"/"_baseUomId_"/"_packUomId_"/"
    b ;3
    q:unitUomId="" phOrdQty
    s eqQty=1
    i baseUomId'=unitUomId d
        .s eqId=0,eqQty=0
        .f  s eqId=$o(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)) q:eqId=""  d
            ..s eqUomId=+^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId)
            ..i eqUomId=unitUomId s eqQty=$p(^PHCD(phcdId,"DF",phcdfSub,"EQ",eqId),"^",2)
            b ;4
    i eqQty=0 q phOrdQty
    s dQty=doseQty/eqQty
    i $p(dQty,".",2)>0 s dQty=$p(dQty,".",1)+1
    //w "eqQty="_eqQty_"/"_dQty_"/"_phcfrFactor,!
    s qty=dQty*phcfrFactor*phcduFactor
    b ;5
   	q qty
}

/// 判断是否是原液皮试
/// test: ##Class(web.DHCNurCom).IsSTSolution("1149||3||1")
ClassMethod IsSTSolution(oeoriId) As %String
{
	q:oeoriId="" "N"
	s ret="N"
	s oeordId=$P($G(oeoriId),"||",1)
	s oeoriSub=$P($G(oeoriId),"||",2)
	s skinTestFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,5)),"^",2)
	q:skinTestFlag'="Y" "N"
    s abnorm=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",3)
    //ypz 06128 begin
    s actId=$p($g(^OEORD(oeordId,"I",oeoriSub,11)),"^",21)
    s actCode="",actDesc=""
    i actId'="" s actCode=$p(^OEC("ACT",actId),"^",1),actDesc=$p(^OEC("ACT",actId),"^",2)
    i actDesc="原液"  s ret="Y"
    q ret
}

/// 判断医嘱收费状态
/// Test:w ##class(web.DHCNurCom).IsUnPaid("1155||3","SkinTestNorm")
ClassMethod IsUnPaid(oeoriId, disposeStatCode = "")
{
	s oeordId=$P($G(oeoriId),"||",1)
	s oeoriSub=$P($G(oeoriId),"||",2)
    s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    s payMode=##class(web.DHCBillInterface).IStayPayModeByEpisodeID()
    
    s ordStatId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",13) ;OEORI_ItemStat_DR
	s ordStatCode=$p($g(^OEC("OSTAT",+ordStatId)),"^")

    s oecprId=$p($g(^OEORD(oeordId,"I",oeoriSub,1)),"^",8)
	s oecprCode=$p($g(^OECPR(oecprId)),"^")
	s oeoriBilled=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",5)
	s oeoriPrice=$p($g(^OEORD(oeordId,"I",oeoriSub,3)),"^",25)
	i (((stayFlag'=1)!(payMode=0))&(ordStatCode'="D")&(oecprCode'="OM")&(oecprCode'="OMCQZT")&(oecprCode'="OMLSZT")&(oecprCode'="OMST")&((oeoriBilled="B")!(oeoriBilled="TB")))&((+oeoriPrice)'=0) d
	.s disposeStatCode="UnPaid"
	q disposeStatCode
}

/// 获取皮试结果
/// Test:w ##Class(web.DHCNurCom).SkinTestResult("1155||4")
ClassMethod SkinTestResult(oeoriId)
{
	q:oeoriId="" ""
	s oeordId=$P($G(oeoriId),"||",1)
	s oeoriSub=$P($G(oeoriId),"||",2)
	s preFlag=$p(^OEORD(oeordId,"I",oeoriSub,11),"^",3)
	q preFlag
}

/// Creator：   SongChao
/// CreatDate： 2018.3.12
/// Description： 保存当前执行科室和病区
/// Table： 
/// Input：
/// Output：
/// Others： 
ClassMethod updateCurrLocWard(oeoriId, currLoc, currWard)
{
 
   n (oeoriId,currLoc,currWard)
   s ^tempsc("updateCurrLocWard")=$lb(oeoriId, currLoc, currWard)
   s obj=##class(User.OEOrdExecExt).%OpenId(oeoriId)
   i '$Isobject(obj) q ""
   i currLoc'="" s obj.OEORECTLOCDR=##class(User.CTLoc).%OpenId(currLoc)
   e  s obj.OEORECTLOCDR=""
   i currWard'="" s obj.OEOREWardDR=##class(User.PACWard).%OpenId(currWard)
   e  s obj.OEOREWardDR=""
   s sc=obj.%Save()
   i $$$ISERR(sc)
   {
	   s ret=$System.Status.GetErrorText(sc)
	   q ret
   }
   q 0
}

/// CreateDate:   20220711
/// Description:  粤北-分娩统计
/// Input:        StDate EdDate CtLoc
/// Return:       基本信息
/// Other:        d ##class(%ResultSet).RunQuery("web.DHCNurCom","GetMaternityStatisticsList","2022-06-01","2022-07-01")
Query GetMaternityStatisticsList(paramJson) As %Query(ROWSPEC = "episodeId,patName,regNo,age,BMI,sysPressure,diaPressure,PAPPA,PAPPAMmom,FHCG,FHCGMom,TXBGAS1,TXBGAS2,pregnancy,parity,gesWeek,babyWeight,diag") [ SqlProc ]
{
}

ClassMethod GetMaternityStatisticsListExecute(ByRef qHandle As %Binary, paramJson) As %Status
{
 	Set repid=$I(^CacheTemp)
 	b
 	If $g(ind)="" Set ind=1
 	set qHandle=$lb(0,repid,0)
    s paramMap = ##class(Nur.JSON).Decode(paramJson)
    s StartDate = paramMap.GetAt("StartDate")
    s EndDate = paramMap.GetAt("EndDate")
 	Quit:(StartDate="")!(EndDate="") $$$OK

 
 	Set:StartDate["-" StartDate=$zdh(StartDate,3)
 	Set:EndDate["-" EndDate=$zdh(EndDate,3)
 	For date=StartDate:1:EndDate {
	 	s admTime=""
	 	f {
		 	s admTime=$o(^PAADMi("TypeDate","I",date,admTime))
		 	q:(admTime="")
		 	s episodeId=""
		 	f {
			 	s episodeId=$o(^PAADMi("TypeDate","I",date,admTime,episodeId))
			 	q:(episodeId="")
			 	continue:('$D(^PAADMi("Mother",episodeId)))
			 	s (patName,regNo,age,BMI,sysPressure,diaPressure,PAPPA,PAPPAMmom,FHCG,FHCGMom,TXBGAS1,TXBGAS2,pregnancy,parity,gesWeek,babyWeight,diag)=""
			 	s papmiId=+^PAADM(episodeId)
			 	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
			 	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
			 	B:regNo="02937638" ;12
				s age=##class(web.DHCBillInterface).GetPapmiAge(papmiId,episodeId)
				s height=##class(Nur.CommonInterface.Temperature).getFirstItemValue(episodeId, "height")
				s weight=##class(Nur.CommonInterface.Temperature).getFirstItemValue(episodeId, "weight")
				i ((weight'="")&&(height'="")&&(+height'=0)) {
					s height=height*0.01
					s BMI=$fn(weight/(height*height),"",2)
				}
				s sysPressure=##class(Nur.CommonInterface.Temperature).getFirstItemValue(episodeId, "sysPressure")
				s diaPressure=##class(Nur.CommonInterface.Temperature).getFirstItemValue(episodeId, "diaPressure")
				s PAPPA=..getLisInfoByAdm(episodeId,"PAPPA")
				s PAPPAMmom=..getLisInfoByAdm(episodeId,"PAPPAMoM")
				s FHCG=..getLisInfoByAdm(episodeId,"fβhCG")
				s FHCGMom=..getLisInfoByAdm(episodeId,"fβhCGMoM")
				s TXBGAS1=..getLisInfoByAdm(episodeId,"hcy")
				s TXBGAS2=..getPasInfoByAdm(episodeId,"220302005-02")
				s pregParity=##class(Nur.IP.Delivery).GetMotherGP(episodeId)
				s pregnancy=$p(pregParity,"^",1)
				s parity=$p(pregParity,"^",2)
				s mradm=$p(^PAADM(episodeId),"^",61)
    			s diag=##class(web.DHCMGNurComm).Diag(mradm,"DIS") //取出院诊断
                Set babies=##class(Nur.NIS.Common.QueryBrokerNew).GetListFromQuery("Nur.IP.Delivery","findBaby",episodeId)
                For i=1:1:babies.Count() {
                    s baby=babies.GetAt(i)
                    i "L"=baby.GetAt("outComeCode") {
                        s babyInfo=##class(Nur.IP.Delivery).getBabyDeliveryInfo(episodeId,baby.GetAt("pregDelBabyID"))
                        s babyWeight=babyInfo.GetAt("birthWeight")
                        s gesWeek=babyInfo.GetAt("pregWeeks")
                        s pregDays=babyInfo.GetAt("pregDays")
                        i pregDays'="" {
                            s gesWeek=gesWeek_"+"_pregDays
                        }
                    }else{
                        s gesWeek=""
                        s babyWeight=""
                    }
                    Do OutputRowStatistics
                }
			 }
		 }
 	}
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowStatistics
	set Data=$lb(episodeId,patName,regNo,age,BMI,sysPressure,diaPressure,PAPPA,PAPPAMmom,FHCG,FHCGMom,TXBGAS1,TXBGAS2,pregnancy,parity,gesWeek,babyWeight,diag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetMaternityStatisticsListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetMaternityStatisticsListExecute ]
{
	n (qHandle)
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetMaternityStatisticsListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetMaternityStatisticsListExecute ]
{
	n (qHandle,Row,AtEnd)
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// w ##class(web.DHCNurCom).getLisInfoByAdm("17748898","C951")
ClassMethod getLisInfoByAdm(episodeId, code)
{
	n (episodeId,code)
	s rtn=""
	s papmiId=+^PAADM(episodeId)
	s Atype="I^O^E"
	f i=1:1:$l(Atype,"^")
	{
		s type=$p(Atype,"^",i)
		s admId=""
		f{
			s admId=$o(^PAPERdr(papmiId,"ADM",type,admId),-1)
			q:(admId="")
			continue:(admId>episodeId)
			q:$D(^PAADMi("Mother",admId))&&(admId'=episodeId)
			s value=##class(LabService.TCResults).GetTCReesultByAdmNo(admId,code)
			s value=$p(value,$Char(2),3)
			continue:(value="")
			s rtn=$CASE(rtn,"":value,:(rtn_";"_value))
			
		}
	}
	q rtn
}

/// ##class(web.DHCNurCom).getPasInfoByAdm("16315522","220302005-02")
ClassMethod getPasInfoByAdm(episodeId, code)
{
	n (episodeId,code)
	s rtn=""
	s papmiId=+^PAADM(episodeId)
	s Atype="I^O^E"
	f i=1:1:$l(Atype,"^")
	{
		s type=$p(Atype,"^",i)
		s admId=""
		f{
			s admId=$o(^PAPERdr(papmiId,"ADM",type,admId),-1)
			q:(admId="")
			;i admId="16094056" b ;01
			continue:(admId>episodeId)
			q:$D(^PAADMi("Mother",admId))&&(admId'=episodeId)
			s value=..getPASInfo(admId,code)
			continue:(value="")
			s rtn=$CASE(rtn,"":value,:(rtn_";"_value))
			
		}
	}
	q rtn
}

/// w ##class(web.DHCNurCom).getPASInfo("17891948","220302005-02")
ClassMethod getPASInfo(episodeId, code)
{
	n (episodeId, code)
	s value=""
	
	Try
	{
		s value=##class(RISService.InvokeRISService).GetDescribeByPaadmdrandStudyCodeCacheWS(episodeId,code)
		s value=$p(value,"孕妇子宫动脉血流指数",2)
		s value=$p(value,"RI",1)
		s value=$p(value,"PI：",2)
		
	}
	Catch exceptionvar
	{
		s value=""
	}
	q value
}

}
