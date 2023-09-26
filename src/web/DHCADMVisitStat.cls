Import SQLUser

Include Nur.DateFormat

Class web.DHCADMVisitStat Extends (%Library.RegisteredObject, websys.Abstract) [ ClassType = "", Inheritance = right, Not ProcedureBlock ]
{

Parameter BUILD = 338;

// 判断病人当前是否有非急诊留观医嘱

ClassMethod IfPatHaveStayOrder(EpisodeID) As %String
{
	s stayFlag=1
	s oeordId=0 f  s oeordId=$o(^OEORD(0,"Adm",EpisodeID,oeordId)) q:oeordId=""  d
    .s oeoriSub=0 f  s oeoriSub=$o(^OEORD(oeordId,"I",oeoriSub)) q:(oeoriSub="")!(stayFlag'=1)  d
    ..s stayFlag=$p($g(^OEORD(oeordId,"I",oeoriSub,"DHC")),"^",17)
    s ret=0
    i stayFlag'=1 s ret=1
    q ret
}

ClassMethod GetStayStatus(Adm) As %String
{
	//w ##class(web.DHCADMVisitStat).GetStayStatus(467136)
	n (Adm)
	s ii=0
    s rtn=-1
    q:(Adm="") rtn
   
    s Admtype=$p($g(^PAADM(Adm)),"^",2)
    q:(Admtype'="E" ) rtn
    s AdmRea=$p($g(^PAADM(Adm,1)),"^",7)
    q:$g(AdmRea)="" rtn		//PAC_AdmReason收费类型
    s InsurFlag=+$p($g(^PAC("ADMREA",+AdmRea)),"^",9)
	s BedCodeDr=$p($g(^PAADM(Adm)),"^",73)
	;q:(BedCodeDr="")!(BedCodeDr=0) rtn	//	无床位
    s PatAllStatusCode=""
    s PatCurStatusDr=""
	f  s PatCurStatusDr=$o(^DHCADMVisitStatus(0,"PAADM",Adm,PatCurStatusDr)) q:(PatCurStatusDr="")  d
	.s PatCurStatusCTid=$p($g(^DHCADMVisitStatus(PatCurStatusDr)),"^",2)
	.q:PatCurStatusCTid=""
	.s PatCurStatusCode=$p($g(^DHCPACVisitStatus(PatCurStatusCTid)),"^",1)
	.s PatCurStatusCode=$zcvt(PatCurStatusCode,"U")
	.s ii=ii+1
	.i PatAllStatusCode="" d
	..s PatAllStatusCode=PatCurStatusCode
	.e  d
	..s PatAllStatusCode=PatAllStatusCode_"^"_PatCurStatusCode
	
	q:((PatAllStatusCode'["STAY")&&(PatAllStatusCode'["SALVAGE")) rtn  //状态变更中不包含留观或抢救
	
	i (($p(PatAllStatusCode,"^",ii)="STAY")||($p(PatAllStatusCode,"^",ii)="SALVAGE")) s rtn=1   //留观状态,当前为留观或抢救
	e  s rtn=2 //曾经留观	
	q rtn
}

ClassMethod GetIfStaying(Adm)
{
	n (Adm)
	s papmiId=+^PAADM(Adm)
	s EpisodeID=""
	s ret=0
	f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","E",EpisodeID),-1) q:((EpisodeID="")!(ret=1))  d  
    .s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    .q:EpisodeID=Adm
    .;q:(pavisit'="A")
    .s rtn=..GetStayStatus(EpisodeID)
    .s:rtn=1 ret=1
    q ret
}

ClassMethod GetIfHaveNoPayOrder(Adm)
{
	n (Adm)
	s papmiId=+^PAADM(Adm)
	s EpisodeID=""
	s ret=0
	f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","E",EpisodeID),-1) q:((EpisodeID="")!(ret=1))  d  
    .s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    .q:EpisodeID=Adm
    .;q:(pavisit'="A")
    .s rtn=..GetStayStatus(EpisodeID)
    .
    .q:(rtn'=1)&(rtn'=2)
    .;s JFRet=##class(web.UDHCJFBaseCommon).JudgeBillNum(EpisodeID)
    .s JFRet=##class(web.UDHCJFBaseCommon).JudgeUnPaidBillNum(EpisodeID)
    .s:JFRet>0 ret=1
    q ret
}

ClassMethod GetPatCurStat(EpisodeID = "") As %String
{
	n (EpisodeID,%session)
	i EpisodeID="" q ""
	s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	q:avsId="" ""
	s pvsId=$P(^DHCADMVisitStatus(avsId),"^",2)
	q $P(^DHCPACVisitStatus(pvsId),"^",1)_"^"_##class(web.DHCEMCommonUtil).GetTransDesc("User.DHCPACVisitStatus","PVSDesc","",$P(^DHCPACVisitStatus(pvsId),"^",2))
   	;q $P(^DHCPACVisitStatus(pvsId),"^",1,2)
}

ClassMethod GetUserAccessStat(patType = "", userId = "") As %String
{
	i userId="" q ""
   	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	i ctpcpId="" q ""
   	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	i ctcptId="" q ""
   	s ctcpIntType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	i ctcpIntType="DOCTOR" s validPos=7 
	i ctcpIntType="NURSE" s validPos=8
	i $g(validPos)="" q ""
	s resStr=""
   	s pvsId=0 f  s pvsId=$O(^DHCPACVisitStatus(pvsId)) q:pvsId=""  d
   		.s typ=$P(^DHCPACVisitStatus(pvsId),"^",3)
   		.q:(typ'=patType)&(patType'="")
   		.s dateFrom=$P(^DHCPACVisitStatus(pvsId),"^",5)
   		.s dateTo=$P(^DHCPACVisitStatus(pvsId),"^",6)
   		.q:(dateFrom>+$h)&&(dateFrom'="")
   		.q:(dateTo<+$h)&&(dateTo'="")
  		.s code=$P(^DHCPACVisitStatus(pvsId),"^",1)
   		.s desc=$P(^DHCPACVisitStatus(pvsId),"^",2)
   		.i $P(^DHCPACVisitStatus(pvsId),"^",validPos)="Y" d
   			..i resStr'="" s resStr=resStr_"^"
   			..s resStr=resStr_code_"!"_desc
	q resStr
}

ClassMethod SetStayStatus(EpisodeID = "", userId = "", ctlocId = "", wardId = "", bedId = "") As %String
{
	q:(EpisodeID="") "无病人信息!"
	q:(userId="") "无用户信息!"
	q:(ctlocId="") "无科室信息!"
	i wardId="" d
	    .s ctlocType=$p($g(^CTLOC(ctlocId)),"^",13)
		.i (ctlocType="EM") d
			..s wardId=0
			..s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,wardId))
		.e  d
			..i (ctlocType="E") d  
			..s linksub=0
			..s linksub=$o(^CTLOC(ctlocId,"LINK",linksub))
			..i $g(linksub)'="" d
				...s linkCtlocId=$p($g(^CTLOC(ctlocId,"LINK",linksub)),"^",1)
				...i $g(linkCtlocId)'="" d
					....s linkCtlocType=$p($g(^CTLOC(linkCtlocId)),"^",13)
					....i $g(linkCtlocType)="EM" d 
						.....s wardId=0
						.....s wardId=$o(^PAWARD(0,"WARD_LocationDR",linkCtlocId,wardId))
	q:(wardId="") "无病区信息!"
	//s ^ypzTmp("stay")=ctlocId_"/"_wardId_"/"_bedId
	//s wardId=123 
	//^PAWARDA(0,"ADM",{ADM_PAADM_DR},{PAC_Ward.WARD_RowID},{PAC_Bed.BED_Childsub},{ADM_Childsub})
	//^PAWARDA(0,"WADM",{WADM_PAADM_DR},{PAC_Ward.WARD_RowID},{WADM_Childsub})
	//
	s curWardId=$o(^PAWARDA(0,"ADM",EpisodeID,""))
	i curWardId'="" q "病人已经在病区床位上"
	s curWardId=$o(^PAWARDA(0,"WADM",EpisodeID,""))
	i curWardId'="" q "病人已经在病区等待区"
	s roomId="",bedSub=""
	s statDesc=""
	i bedId'="" d ##class(web.PACBedStatusChange).IsUnavailBedStatus(bedId,.statDesc)
	i statDesc'="" q "该床位已经被占用"
	i bedId'="" s bedSub=$p(bedId,"||",2)
	i bedSub'="" s roomId=$p(^PAWARD(+bedId,"BED",bedSub),"^",3)
	&sql(update PA_ADM set PAADM_CurrentWard_Dr=:wardId,PAADM_CurrentRoom_DR=:roomId where PAADM_RowId=:EpisodeID)
	i SQLCODE q "更新病区信息出错!"
	;&sql(update PA_ADM set PAADM_CurrentWard_Dr=:wardId,PAADM_CurrentRoom_DR=:roomId where PAADM_RowId=:EpisodeID)
	;i SQLCODE q "更新病区信息出错!"
	s curDate=+$h,curTime=$p($h,",",2)
	s reqstId=$o(^PAC("REQST",0,"Code","T",""))
	s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
	&sql(insert into PA_AdmTransaction (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
		TRANS_Ward_DR,TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
		TRANS_TransType_DR,TRANS_Room_DR,TRANS_Bed_DR)  
		Values (:EpisodeID,:curDate,:curTime,:wardId,:reqstId,:curDate,:curTime,:userId,:transtypId,:roomId,:bedId))
	i SQLCODE q "插入转病区信息出错!"
	s transId=$g(%ROWID)
	q:transId="" ""
	s bookedStatus="O"
	if bedSub'="" 
	{
		&sql(insert into PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
			Values (:bedId,:EpisodeID,:bookedStatus,:transId))
		i SQLCODE q "插入床位信息出错!"
		&sql(update PA_Adm (PAADM_CurrentBed_DR) Values (:bedId) Where PAADM_RowId=:EpisodeID)
	}
	else
	{
		&sql(insert into PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR)
			Values (:wardId,:EpisodeID,:bookedStatus,:transId))
		i SQLCODE q "插入病区信息出错!"
	}
	
	&sql(Update PA_AdmExt (PAADM_AdminDate,PAADM_AdminTime) Values (:curDate,:curTime) Where PAADM_RowId=:EpisodeID)
        i SQLCODE q "修改病人入院日期和时间错误!"
    
	s locId=$p(^PAWARD(wardId),"^",5)
	q:locId="" ""
	s cptSub=$o(^CTLOC(locId,"CPT",0))
	q:cptSub="" 0
	s caretypId=$p($g(^CTLOC(locId,"CPT",cptSub)),"^")
	q:caretypId="" 0
	s caretypCode=$p(^PAC("CARETYP",caretypId),"^")
	q:caretypCode="" 0
	s ctacuId=$o(^CT("ACU",0,"Code",caretypCode,""))
	q:ctacuId="" 0
	&sql(Update PA_Adm (PAADM_Priority_DR) Values (:ctacuId) Where PAADM_RowId=:EpisodeID)
    i SQLCODE q "修改病人等级出错!"
    
	q 0
}

Query GetPatStat(patType = "", userId = "") As %Query(ROWSPEC = "code,desc")
{
}

ClassMethod GetPatStatExecute(ByRef qHandle As %Binary, patType = "", userId = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set qHandle=$lb(0,repid,0)
 	s ind=1
   	/*i userId="" quit $$$OK
	s ctpcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	i ctpcpId="" quit $$$OK
	s ctcptId=$P($g(^CTPCP(ctpcpId,1)),"^",4)  ;CTPCP_CarPrvTp_DR
	i ctcptId="" quit $$$OK
	s ctcpIntType=$P($g(^CT("CPT",ctcptId)),"^",4)  ;CT_CarPrvTp:CTCPT_InternalType
	i ctcpIntType="DOCTOR" s validPos=7 
	i ctcpIntType="NURSE" s validPos=8
	i $g(validPos)="" quit $$$OK
   	*/
   	s pvsId=0 f  s pvsId=$O(^DHCPACVisitStatus(pvsId)) q:pvsId=""  d
   	.s type=$P(^DHCPACVisitStatus(pvsId),"^",3)
   	.q:(type'=patType)&(patType'="")
  	.s code=$P(^DHCPACVisitStatus(pvsId),"^",1)
   	.s desc=$P(^DHCPACVisitStatus(pvsId),"^",2)
   	.s dateFrom=$P(^DHCPACVisitStatus(pvsId),"^",5)
   	.s dateTo=$P(^DHCPACVisitStatus(pvsId),"^",6)
   	.s h=+$h
	  .q:((h<dateFrom)&&(dateFrom'=""))!((h>dateTo)&&(dateTo'=""))
   	.//i $P(^DHCPACVisitStatus(pvsId),"^",validPos)="Y" Do Outputcat2
   	.Do Outputcat2
    //Set qHandle=$lb(0,repid,0)
	Quit $$$OK
Outputcat2
	set Data=$lb(code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetPatStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPatStatExecute ]
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

ClassMethod GetPatStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPatStatExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod dischg() As %String
{
	s rName="",rIndex="",rValue=""
	s rData=""
	for  s rName=$o(%request.Data(rName))  q:rName=""  d 
	. s rIndex=""
	. for  s rIndex=$o(%request.Data(rName,rIndex))  q:rIndex=""  d
	. . s rValue=%request.Data(rName,rIndex)
	. . s rData=rData _ $c(10,13)_ "(" _rName_","_rIndex_")="_rValue
	. . s ^TMP("request",rName)=rValue
	
	s ^Bob("temp",$zn)=rData
	q ""
}

ClassMethod InsertVis(EpisodeID, visStatCode, avsDateStr, avsTimeStr, userId, wardDesc, cancelFlag = 0, notes = "") As %String
{
   	n (EpisodeID,visStatCode,avsDateStr,avsTimeStr,userId,wardDesc,cancelFlag,notes)
   	
   	 s curStat=$P(..GetPatCurStat(EpisodeID),"^")
   	i ((visStatCode="Stay")!(visStatCode="Salvage")) d
    .s ifHaveNoPay=##class(web.DHCBillInterface).GetnotPayOrderByRegno("",EpisodeID)
    e  s ifHaveNoPay=0
    i (curStat="Stay")!(curStat="Salvage") s ifHaveNoPay=0
    //（0：走普通收费模式，1：走押金模式）
    s payMode=##class(web.DHCEMCommonUtil).IGetStayPayModeByAdmID(EpisodeID)
	i (cancelFlag=0)&($g(ifHaveNoPay)>1)&(payMode=1) q "本次就诊有未结算的医嘱,押金模式下如果留观需停医嘱或者交费!"
	
   	s avsDate=$$$ZDH(avsDateStr,4)
   	s avsTime=$ZTH(avsTimeStr)
   	s wardId=""
   	i wardDesc'="" s wardId=$o(^PAWARD(0,"WARD_Desc",$$ALPHAUP^SSUTIL4(wardDesc),""))
    ;q ..InsertVisitStat(EpisodeID, visStatCode, avsDate, avsTime, userId, wardId)
    s ret="" //wxl 081201 Start
    s visStatId=$o(^DHCPACVisitStatus(0,"Code",$$ALPHAUP^SSUTIL4(visStatCode),""))
   	s PreVisitStatId=""
   	s PreVisitStatId=$p($G(^DHCPACVisitStatus(visStatId)),"^",9)
    i PreVisitStatId="" s ret=0
    e  d
    .s avsrowId=""
    .f  s avsrowId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsrowId),-1) q:avsrowId=""  d
    ..s avsVisStatCode=$p($G(^DHCADMVisitStatus(avsrowId)),"^",2)
    ..i avsVisStatCode=PreVisitStatId s ret=0
    
    i ret=0 q ..InsertVisitStat(EpisodeID, visStatCode, avsDate, avsTime, userId, wardId ,notes)
    e  d
    .s PreVisitStatDesc=""
    .i PreVisitStatId'="" s PreVisitStatDesc=$p($G(^DHCPACVisitStatus(PreVisitStatId)),"^",2)  
   	q "先置病人状态为"_PreVisitStatDesc //wxl 081201 End
}

ClassMethod InsertVisitStat(EpisodeID, visStatCode, avsDate, avsTime, userId = "", wardId = "", notes = "") As %String
{
   	n (EpisodeID,visStatCode,avsDate,avsTime,userId,wardId,notes)
   	s:avsDate="" avsDate=+$h
   	s:avsTime="" avsTime=$p($h,",",2)
   	s visStatId=$o(^DHCPACVisitStatus(0,"Code",$$ALPHAUP^SSUTIL4(visStatCode),""))
	s admLocId=$P(^PAADM(EpisodeID),"^",4)
	s date=+$H
	s time=$P($H,",",2)
	&sql(insert into DHC_ADMVisitStatus(AVS_Paadm_Dr,AVS_VisitStatus,AVS_Date,AVS_Time,
    	AVS_User_Dr,AVS_Location,AVS_CreateDate,AVS_CreateTime,AVS_CreateUser,AVS_Ward_Dr,AVS_Note) 
    	values (:EpisodeID,:visStatId,:avsDate,:avsTime,:userId,:admLocId,:date,:time,:userId,:wardId,:notes))
    q SQLCODE
}

Query FindAdmVisitStat(EpisodeID As %String, fromDate As %String, toDate As %String, visitStat As %String) As %Query(ROWSPEC = "patRegNo:%String,patientName:%String,admLocDesc:%String,patVisitStat:%String,statDate:%String,statTime:%String,inWardDesc:%String,userDesc:%String")
{
}

ClassMethod FindAdmVisitStatExecute(ByRef qHandle As %Binary, EpisodeID As %String = "", fromDate As %String = "", toDate As %String = "", visitStat As %String = "") As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
    i EpisodeID'="" d
        .s avsId="-1"
        .f  s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId)) q:avsId=""  d
            ..d OutEpisodeVisitStat
    e  d
        .q:visitStat=""
        .f curDate=fromDate:1:toDate d
        	..s pvsId=$o(^DHCPACVisitStatus(0,"Desc",$$ALPHAUP^SSUTIL4(visitStat),""))
        	..s avsId=""
        	..f  s avsId=$o(^DHCADMVisitStatus(0,"DateStatus",curDate,pvsId,avsId)) q:avsId=""  d
        	    ...d OutEpisodeVisitStat
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutEpisodeVisitStat
    s patVisitStat=$p(^DHCPACVisitStatus($p($g(^DHCADMVisitStatus(avsId)),"^",2)),"^",2)
    q:patVisitStat=""
    q:(visitStat'="")&(visitStat'=patVisitStat)
    s EpisodeID=$p(^DHCADMVisitStatus(avsId),"^",1)
    q:EpisodeID=""
    s patRegNo=##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
    s patientName=##Class(web.DHCCLCom).GetNamebyEpisodeID(EpisodeID)
    s statDate=$$$zd($p(^DHCADMVisitStatus(avsId),"^",5),3)
    s statTime=$zt($p(^DHCADMVisitStatus(avsId),"^",6),2)
    s admLocDesc=$p(^CTLOC($p(^DHCADMVisitStatus(avsId),"^",3)),"^",2)
    s userDesc=$p(^SSU("SSUSR",$p(^DHCADMVisitStatus(avsId),"^",4)),"^",2)
    s wardId=$p(^DHCADMVisitStatus(avsId),"^",10)
    s inWardDesc=""
    i wardId'="" s inWardDesc=$p(^PAWARD(wardId),"^",2)
    d OutRowEpisode
	q
OutRowEpisode
	s Data=$lb(patRegNo,patientName,admLocDesc,patVisitStat,statDate,statTime,inWardDesc,userDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAdmVisitStatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmVisitStatExecute ]
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

ClassMethod FindAdmVisitStatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmVisitStatExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

Query FindAdmVisitReg(locDesc As %String, regNo As %String, ctcpId As %String, fromDate As %String, toDate As %String, admType As %String, visitStat As %String) As %Query(ROWSPEC = "patRegNo:%String,patientName:%String,patVisitStat:%String,admDate:%String,admTime:%String,ssDesc:%String,paperStName:%String,tel:%String,admLocDesc:%String,firstCtcpDesc:%String,mrciDesc:%String,inWardDesc:%String,userDesc:%String,seqNo:%String,ACUDESC:%String,sex:%String,age:%String,EmergCond:%String")
{
}

ClassMethod FindAdmVisitRegExecute(ByRef qHandle As %Binary, locDesc As %String = "", regNo As %String = "", ctcpId As %String = "", fromDate As %String = "", toDate As %String = "", admType As %String = "E", visitStat As %String) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	s locId=""
 	k ^DHCNurADMVistTemp
	i locDesc'="" s locId=$o(^CTLOC(0,"Desc",$$ALPHAUP^SSUTIL4(locDesc),""))
	
	//i (locId="")&(regNo="")&(toDate'=fromDate) s qHandle=$lb(0,repid,0) q $$$OK
	i toDate<fromDate s qHandle=$lb(0,repid,0) q $$$OK
	i admType="" s qHandle=$lb(0,repid,0) q $$$OK

	s seqNo=0
    s dayAhead=0
    i regNo'="" d
    .s papmiId=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),"")) 
    .q:papmiId=""
	.s EpisodeID=""
	.f  s EpisodeID=$o(^PAPERdr(papmiId,"ADM","E",EpisodeID),-1) q:EpisodeID=""  d  
    ..d OutEpisodeVisitReg
    e  f curDate=fromDate:1:toDate d
    .s EpisodeID=""
    .f  s EpisodeID=$o(^PAADMi("PAADM_AdmDate",curDate,EpisodeID)) q:EpisodeID=""  d
    ..d OutEpisodeVisitReg
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutEpisodeVisitReg
    q:EpisodeID=""
    s patType=$p($g(^PAADM(EpisodeID)),"^",2)
    q:admType'[patType
    //i ##Class(web.DHCCLCom).IfActualDoc(EpisodeID)'="Y" q
    s pavisit=$p($g(^PAADM(EpisodeID)),"^",20)
    i "AD"'[pavisit q
    s admDate=$p($g(^PAADM(EpisodeID)),"^",6)
	//q:admDate+dayAhead<fromDate
	//q:admDate>toDate
    s avsId="-1"
    s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),"-1")
    s patVisitStat=""
    i avsId'="" s patVisitStat=$p(^DHCPACVisitStatus($p($g(^DHCADMVisitStatus(avsId)),"^",2)),"^",2)
    q:(visitStat'="")&(visitStat'=patVisitStat)
    s admLocId=""
    i avsId'="" s admLocId=$p(^DHCADMVisitStatus(avsId),"^",3)
    i admLocId="" s admLocId=$p($G(^PAADM(EpisodeID)),"^",4)
    q:(locId'="")&(locId'=admLocId)
    ;q:$o(^PAC("ADMLOC",0,"AdmType",admType,+admLocId,""))=""
    s admLocDesc=""
    i admLocId'="" s admLocDesc=$p(^CTLOC(admLocId),"^",2)
    s patInfo=##Class(web.DHCCLCom).PatInfo("^"_EpisodeID)
    s patRegNo=$p(patInfo,"^",1)  //##Class(web.DHCCLCom).GetRegNobyEpisodeID(EpisodeID)
    //s patientName=##Class(web.DHCCLCom).GetNamebyEpisodeID(EpisodeID)
	s patientName=$p(patInfo,"^",5)
	s sex=$p(patInfo,"^",4)
	s age=$p(patInfo,"^",8)
    s paperStName=$p(patInfo,"^",10)
	s tel=$p(patInfo,"^",11)
    s admDate=$$$zd($p(^PAADM(EpisodeID),"^",6),3)
    s admTime=$zt($p(^PAADM(EpisodeID),"^",7),2)
    s userDesc=""
    i avsId'="" s userDesc=$p(^SSU("SSUSR",$p(^DHCADMVisitStatus(avsId),"^",4)),"^",2)
    s wardId=""
    i avsId'="" s wardId=$p(^DHCADMVisitStatus(avsId),"^",10)
    s inWardDesc=""
    i wardId'="" s inWardDesc=$p(^PAWARD(wardId),"^",2)
    i wardId="",patVisitStat="留观" s wardId=$o(^CTLOC(admLocId,"LINK",0,"Loc",0))
    i wardId'="" s inWardDesc=$p($G(^CTLOC(wardId)),"^",2)
    s papmiId=+^PAADM(EpisodeID)
    s ssId=$p($g(^PAPER(papmiId,"PER",1)),"^",10) // PAPER_SocialStatus_DR
	s ssDesc=""
	i ssId'="" s ssDesc=$p(^CT("SS",ssId),"^",2) //n
	s papmiId=+^PAADM(EpisodeID)
	s birthday=$p($g(^PAPER(papmiId,"ALL")),"^",6)
	i birthday'="" s birthday=$$$zd(birthday,3) //n
	s ssId=$p($g(^PAPER(papmiId,"PER",1)),"^",10) // PAPER_SocialStatus_DR
	s ssDesc=""
	i ssId'="" s ssDesc=$p(^CT("SS",ssId),"^",2) //n
    s transSub=0,firstCtcpId=0
    f  s transSub=$o(^PAADM(EpisodeID,"TRANS",transSub)) q:(transSub="")!(firstCtcpId'=0)  d
        .s firstCtcpId=$p(^PAADM(EpisodeID,"TRANS",transSub),"^",5)
    i firstCtcpId=""  s firstCtcpId=$p(^PAADM(EpisodeID),"^",9)
    s firstCtcpDesc=$P($g(^CTPCP(firstCtcpId,1)),"^",2)
    i ctcpId'="",firstCtcpId'=ctcpId q
    s mradmId=$P(^PAADM(EpisodeID),"^",61)
  	s mrdiaSub=0,mrciDesc=""
  	f  s mrdiaSub=$O(^MR(mradmId,"DIA",mrdiaSub)) q:(mrdiaSub="")  d
  		.s mrcidId=$p(^MR(mradmId,"DIA",mrdiaSub),"^") //
  		.q:mrcidId=""
  		.i mrciDesc'="" s mrciDesc=mrciDesc_","
  		.s mrciDesc=mrciDesc_$p($g(^MRC("ID",mrcidId)),"^",2)
    s adsouId=$p(^PAADM(EpisodeID),"^",10)
    //s adsouDesc="" 
    //i adsouId'="" s adsouDesc=$p(^PAC("ADSOU",adsouId),"^",2)
    //i needAdsouDesc'="",needAdsouDesc'=adsouDesc q
    s ACUDESC=""
    s ACUDR=$P(^PAADM(EpisodeID),"^",33)
	i ACUDR'=""	s ACUDESC=$P(^CT("ACU",ACUDR),"^",2)
	s EmergCond=""          //症状描述
	s EMCChild=""
	s MRADMDR=$P($G(^PAADM(EpisodeID)),"^",61)
	s ^WKZTemp(EpisodeID)=MRADMDR
	f  s EMCChild=$O(^MR(MRADMDR,"EMC",EMCChild)) q:EMCChild=""  d
	.q:EMCChild=0
	.s EmergCondDR=^MR(MRADMDR,"EMC",EMCChild)
	.q:EmergCondDR=""
	.s EmergCond=EmergCond_" "_$P($G(^MRC("EMC",EmergCondDR)),"^",2)
    s seqNo=seqNo+1
    s ^DHCNurADMVistTemp(seqNo)=patRegNo_"^"_patientName_"^"_sex_"^"_age_"^"_paperStName_"^"_tel_"^"_ssDesc_"^"_patVisitStat_"^"_ACUDESC_"^"_admDate_"^"_admTime_"^"_admLocDesc_"^"_inWardDesc_"^"_firstCtcpDesc_"^"_mrciDesc_"^"_userDesc_"^"_EmergCond
    d OutRowReg
	q
OutRowReg
	s Data=$lb(patRegNo,patientName,patVisitStat,admDate,admTime,ssDesc,paperStName,tel,admLocDesc,firstCtcpDesc,mrciDesc,inWardDesc,userDesc,seqNo,ACUDESC,sex,age,EmergCond)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindAdmVisitRegFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindAdmVisitRegExecute ]
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

ClassMethod FindAdmVisitRegClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindAdmVisitRegExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

ClassMethod GetItem(i As %String)
{
	q ^DHCNurADMVistTemp(i)
}

ClassMethod GetItemNum()
{
	q $O(^DHCNurADMVistTemp(""),-1)
}

ClassMethod GetPath()
{
	&sql(select pathtoreports into :reportPath from websys.configuration)
	q reportPath
}

Query FindEmergencyPat(wardId As %String, regNo As %String, userId As %String, fDate As %String, tDate As %String, locId As %String, admType As %String) As %Query(ROWSPEC = "patName,admDate,admTime,admNo,patLocDesc,ctcpDesc,wardDesc,visitStatDesc")
{
}

ClassMethod FindEmergencyPatExecute(ByRef qHandle As %Binary, wardId As %String, regNo As %String, userId As %String, fDate As %String, tDate As %String, locId As %String, admType As %String) As %Status
{
	s repid=$i(^CacheTemp)
 	s ind=1
 	i (userId="")!(admType="")  s qHandle=$lb(0,repid,0) q $$$OK
 	s locId="",wardId=""
 	
    i admType'="I" s retStr=##Class(web.DHCNurCom).FindPatient(locId,regNo,userId,admType,fDate,tDate) 
 	i admType="I" s retStr=##Class(web.DHCNurCom).FindPatient(wardId,regNo,userId,admType,fDate,tDate) 
    
    s nagEpisodeID=""
    f  s nagEpisodeID=$o(^DHCCLNurseExec(userId,"Patient",nagEpisodeID)) q:nagEpisodeID=""  d
    	.s EpisodeID=$p(^DHCCLNurseExec(userId,"Patient",nagEpisodeID),"^",1)
    	.s patName=$p(^DHCCLNurseExec(userId,"Patient",nagEpisodeID),"^",2)
    	.s admDate=$p(^PAADM(EpisodeID),"^",6)
    	.q:admDate=""
    	.i admDate'="" s admDate=$$$zd(admDate,3)
    	.s admTime=$p(^PAADM(EpisodeID),"^",7)
    	.i admTime'="" s admTime=$zt(admTime,2)
    	.s admNo=$p(^PAADM(EpisodeID),"^",81)
    	.s ctcpId=$p(^PAADM(EpisodeID),"^",9)
    	.s ctcpDesc=""
    	.i ctcpId'="" s ctcpDesc=$p($g(^CTPCP(ctcpId,1)),"^",2)
    	.s patLocDesc=$p($g(^CTLOC(+$p($g(^PAADM(EpisodeID)),"^",4))),"^",2)
    	.//q:patLoc=""
    	.s wardDesc=$p($g(^PAWARD(+$p($g(^PAADM(EpisodeID)),"^",70))),"^",2)
    	.//s ^ypzTmp(24)=patName_"/"_$g(admDate)_"/"_patLocDesc_"/"_wardDesc
    	.s retStr=..GetPatCurStat(EpisodeID)
    	.s visitStatDesc=$p(retStr,"^",2)
    	.d OutRow
    s qHandle=$lb(0,repid,0)
	q $$$OK
OutRow
	s Data=$lb(patName,admDate,admTime,admNo,patLocDesc,ctcpDesc,wardDesc,visitStatDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindEmergencyPatFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindEmergencyPatExecute ]
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

ClassMethod FindEmergencyPatClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindEmergencyPatExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
    q $$$OK
}

// Paadm_DischgDate22,Paadm_DischgTime23,Paadm_VisitStatus25,paadm_current99,Paadm_billFlag(100),Paadm_updatedate216,Paadm_updateTime217

ClassMethod PatAdmDischg(EpisodeID, dateStr, timeStr, userId) As %String
{
	n (EpisodeID,dateStr,timeStr,userId)
	/*&sql(select * into PLIST() from pa_adm where paadm_rowid=:EpisodeID)
	s PLIST(22)=$ZDH(dateStr,4)
	s PLIST(23)=$ZTH(timeStr)
	s PLIST(25)="D"
	s PLIST(99)="N"
	s PLIST(100)="N"
	s PLIST(216)=+$H
	s PLIST(217)=$P($H,",",2)
	&sql(Update pa_adm values PLIST() where Paadm_rowid=:EpisodeID)
	q SQLCODE*/
	//s EpisodeID=1017
	s PatientID=$P(^PAADM(EpisodeID),"^",1)
	s %request.Data("PAADMDischgDate")="16/07/2006"
	s %request.Data("PAADMDischgTime")="14:04"
	s %request.Data("PAADMAdmTime")="09:44"
	s %request.Data("PAADMAdmDate")="28/06/2006"
	s %request.Data("LocID")="839"
	s %request.Data("ID")="1017"
	s %request.Data("EpisodeID")=EpisodeID
	s %request.Data("PAADMAdmDate")="28/06/2006"
	s %request.Data("PAADMType")="E"
	s %request.Data("PAADMVisitStatus")="A"
	s %request.Data("UserID")=1
	s %request.Data("CurrentDate")="16/07/2006"
	s %request.Data("CurrentTime")="14:04"
	s %request.Data("CodeTableValidationDate")=60444
	s %request.Data("CTDate")=60444
	s %request.Data("AdmDate")="28/06/2006"
	s %request.Data("AdmTime")="09:44"
	s %request.Data("AllowDisWOFin")="Y"
	s %request.Data("PATCF")="^^^14^12^24^^^^"
	s %request.Data("PatientID")=202
	s %request.Data("TEVENT")="d191iupdate1"
	s %request.Data("TRELOADID")="6988082"
	s %request.Data("TWKFL")=43
	s %request.Data("TWKFLI")=1
	s %request.Data("mradm")=1017
	s %request.Data("paadm2panokdr")=""
	s %request.Data("payCode")=""
	s %request.Data("payorCategory")=""
	s %request.Data("AllowDisWOFin")="Y"
	s %request.Data("BoldLinks")="0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0"
	s %request.Data("BoldPtLinks")="0^0^0^0^0^0^0^0^0^0^0^0^0^0^0^0"
	s %request.Data("CTPCPCode")=""
	s %request.Data("DoctorChanged")=0
	s %request.Data("EMCDescString")=""
	s %request.Data("FamDoctorDetails")="^^^^^^^^^^^^"
	s %request.Data("FamREFDCode")=""
	s %request.Data("HiddenCheckbox")=""
	s %request.Data("InjuryExist")=""
	s %request.Data("InsurID")=""
	s %request.Data("InsurPayor2Code")=""
	s %request.Data("InsurPayorID")=""
	s %request.Data("IsFemale")=""
	s %request.Data("MRCIDCode")=""
	s %request.Data("MRCIDRowId")=""
	s %request.Data("MRObjFindRowID")=""
	s %request.Data("MRSubjectFindingsRowID")=""
	s %request.Data("MRSysReviewRowID")=""
	s %request.Data("MultiActiveGP")=""
	s %request.Data("PAADMEstimDischargeDate")=""
	s %request.Data("PAADMEstimDischargeTime")=""
	s %request.Data("PAADMRefDocClinicDR")=""
	s %request.Data("PAPERDeceasedFlag")=""
	s %request.Data("PAPERFamilyDoctorClinicDR")=""
	s %request.Data("PIN")=""
	s %request.Data("PanelTypeRestriction")=""
	s %request.Data("PayorRestriction")=""
	s %request.Data("REFDCode")=""
	s %request.Data("REFDEPDesc")=""
	s %request.Data("RETRADesc")=""
	s %request.Data("SaveFileName")=""
	s %request.Data("SaveFilePath")=""
	s %request.Data("SaveFileSubDir")=""
	s %request.Data("TOVERRIDE")=""
	s %request.Data("TRDDesc")=""
	s %request.Data("TRANSPDesc")=""
	s %request.Data("TREPORT")=""
	s %request.Data("TWKFL")=""
	s %request.Data("TWKFLI")=1
	s %request.Data("TWKFLJ")=""
	s %request.Data("TWKFLL")=""
	s %request.Data("doctorCode")=""
	s %request.Data("familyDrCode")=""
	s %request.Data("hiddenLinks")=0
	s %request.Data("hiddenLock")=1
	s %request.Data("isDeceased")=""
	s %request.Data("payCode")=""
	s %request.Data("symptom")=""
	s %request.Data("trafficID")=""
	s %request.Data("tohidden")=""
	s %request.Data("viewDr")=""
	s a=..aa()
	s a=##CLASS(web.PAAdm).HtmlEmergSave("d191iupdate1",PatientID)
}

ClassMethod UndoDischarge(EpisodeID = "", userId = "") As %String
{
	q:EpisodeID="" "无病人就诊信息!"
	q:userId="" "无用户信息!"
	q:$p(^PAADM(EpisodeID),"^",2)'="E" 0
	q:$p(^PAADM(EpisodeID),"^",20)="D" 0
	s avsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,""),-1)
	q:avsId="" ""
	s pvsId=$P(^DHCADMVisitStatus(avsId),"^",2)
	i $P(^DHCPACVisitStatus(pvsId),"^",1)["Discharge" d
	    .s preAvsId=$o(^DHCADMVisitStatus(0,"PAADM",EpisodeID,avsId),-1)
	    .i preAvsId="" d
	    	..&sql(delete from DHC_ADMVisitStatus where AVS_RowId=:avsId)
	    	..s retStr=SQLCODE
	    .e  d
	        ..s pvsId=$P(^DHCADMVisitStatus(preAvsId),"^",2)
	        ..s visStatCode=$P(^DHCPACVisitStatus(pvsId),"^",1)
	        ..s retStr=..InsertVisitStat(EpisodeID, visStatCode, +$h, $p($h,",",2), userId)
	q retStr
}

ClassMethod aa() As %String
{
	s ^T("dd")=%request.Data("mradm")
	q 0
}

Query LookUpCtloc(desc As %String) As %Query(ROWSPEC = "ctlocDesc:%String,ctlocId:%String")
{
}

ClassMethod LookUpCtlocExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s ctlocId=0
	f  s ctlocId=$o(^CTLOC(ctlocId)) q:ctlocId=""  d
	.s ctlocDesc=$p(^CTLOC(ctlocId),"^",2)
	.s ctlocDesc=$$ALPHAUP^SSUTIL4(ctlocDesc)
	.i (desc'="")&($p(ctlocDesc,desc,1)'="") q
	.d OutputRow4
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow4
	s Data=$lb(ctlocDesc,ctlocId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod LookUpCtlocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = LookUpCtlocExecute ]
{
 	s AtEnd=$li(qHandle,1)
 	s repid=$li(qHandle,2)
 	s ind=$li(qHandle,3)
 	s ind=$o(^CacheTemp(repid,ind))
 	i ind="" {				
 		s AtEnd=1
 		s Row=""
 	}
 	else      {			
 		s Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	q $$$OK
}

ClassMethod LookUpCtlocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = LookUpCtlocExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

ClassMethod GetWorkflowID(userID) As %String
{
	s CTPCPDR=$P($G(^SSU("SSUSR",userID)),"^",14)
	s CarPrvTpDR=$P($G(^CTPCP(CTPCPDR,1)),"^",4)
	s CTCPTType=$P($G(^CT("CPT",CarPrvTpDR)),"^",4) 
	i CTCPTType="NURSE" s WorkFlowDesc="Floor Plan"
	i CTCPTType="DOCTOR" s WorkFlowDesc="DHCDocEmergencyPatientList"
	s WorkFlowID=##Class(websys.WorkFlow).GetIdFromCodeOrDescription(WorkFlowDesc)
	q WorkFlowID
}

ClassMethod GetACU(EpisodeID As %String) As %String
{
	q:($g(EpisodeID)="") 0
	s ACUDR=$P(^PAADM(EpisodeID),"^",33)
	i ACUDR="" q 0
	s ACUDESC=$P(^CT("ACU",ACUDR),"^",2)
	q ACUDESC
}

ClassMethod GetLocAcuity(locDesc As %String) As %String
{
	q:locDesc="" ""
	s locDesc=$$ALPHAUP^SSUTIL4(locDesc)
	s locId=$o(^CTLOC(0,"Desc",locDesc,""))
	q:locId="" ""
	s cptSub=$o(^CTLOC(locId,"CPT",0))
	q:cptSub="" ""
	s caretypId=$p($g(^CTLOC(locId,"CPT",cptSub)),"^")
	q:caretypId="" ""
	s caretypCode=$p(^PAC("CARETYP",caretypId),"^")
	q:caretypCode="" ""
	s ctacuId=$o(^CT("ACU",0,"Code",caretypCode,""))
	q:ctacuId="" ""
	s ctacuDesc=$P(^CT("ACU",ctacuId),"^",2)
	q ctacuDesc
}

ClassMethod AdmMove(EpisodeID = "", userId = "", wardDesc = "", bedId = "") As %String
{
	q:(EpisodeID="") "无病人信息!"
	q:(userId="") "无用户信息!"
	s wardId=""
	i wardDesc'="" d
	    .s wardDesc=$$ALPHAUP^SSUTIL4(wardDesc)
	    .s wardId=$o(^PAWARD(0,"WARD_Desc",wardDesc,""))
	i bedId'="" s wardId=+bedId
	q:(wardId="") "无病区信息!"
	&sql(update PA_ADM set PAADM_CurrentWard_Dr=:wardId where PAADM_RowId=:EpisodeID)
	i SQLCODE q "更新病区信息出错!"
	s roomId="",bedSub=""
	i bedId'="" s bedSub=$p(bedId,"||",2)
	i bedSub'="" s roomId=$p(^PAWARD(+bedId,"BED",bedSub),"^",3)
	s curDate=+$h,curTime=$p($h,",",2)
	s reqstId=$o(^PAC("REQST",0,"Code","T",""))
	s transtypId=$o(^PAC("TRANSTYP",0,"Code","M",""))
	s preTransSub="",transSub=0
	f  s preTransSub=$o(^PAADM(EpisodeID,"TRANS",preTransSub),-1) q:(preTransSub="")!(transSub>0)  d
	    .i $p(^PAADM(EpisodeID,"TRANS",preTransSub),"^",21)=transtypId s transSub=preTransSub
	s ^ypzTmp("tran")=transSub
	i transSub>0 d
	    .s preTransId=EpisodeID_"||"_transSub
	    .s preReqstId=$o(^PAC("REQST",0,"Code","D",""))
	    .s ^ypzTmp("tran")=preReqstId_"/"_transSub_"/"_preTransId //
	    .&sql(update PA_AdmTransaction set TRANS_Status_DR=:preReqstId,TRANS_EndDate=:curDate,TRANS_EndTime=:curTime where TRANS_RowId=:preTransId)
	&sql(insert into PA_AdmTransaction (TRANS_ParRef,TRANS_StartDate,TRANS_StartTime,
		TRANS_Ward_DR,TRANS_Status_DR,TRANS_UpdateDate,TRANS_UpdateTime,TRANS_UpdateUser_DR,
		TRANS_TransType_DR,TRANS_Room_DR,TRANS_Bed_DR)  
		Values (:EpisodeID,:curDate,:curTime,:wardId,:reqstId,:curDate,:curTime,:userId,:transtypId,:roomId,:bedId))
	i SQLCODE q "插入转病区信息出错!"
	s transId=$g(%ROWID)
	q:transId="" ""
	s bookedStatus="O"
	if bedSub'="" 
	{
		i $o(^PAWARDA(0,"ADM",EpisodeID,""))'="" &sql(delete from PAC_BedAdm where ADM_PAADM_DR=:EpisodeID)
		&sql(insert into PAC_BedAdm (ADM_ParRef,ADM_PAADM_DR,ADM_BookedStatus,ADM_Trans_DR)
			Values (:bedId,:EpisodeID,:bookedStatus,:transId))
		i SQLCODE q "插入床位信息出错!"
		&sql(update PA_Adm (PAADM_CurrentBed_DR) Values (:bedId) Where PAADM_RowId=:EpisodeID)
	}
	else
	{
		i $o(^PAWARDA(0,"WADM",EpisodeID,""))'="" &sql(delete from PAC_WardAdm where WADM_PAADM_DR=:EpisodeID)
		&sql(insert into PAC_WardAdm (WADM_ParRef,WADM_PAADM_DR,WADM_BookedStatus,WADM_Trans_DR)
			Values (:wardId,:EpisodeID,:bookedStatus,:transId))
		i SQLCODE q "插入病区信息出错!"
	}
	s locId=$p(^PAWARD(wardId),"^",5)
	q:locId="" ""
	s cptSub=$o(^CTLOC(locId,"CPT",0))
	q:cptSub="" 0
	s caretypId=$p($g(^CTLOC(locId,"CPT",cptSub)),"^")
	q:caretypId="" 0
	s caretypCode=$p(^PAC("CARETYP",caretypId),"^")
	q:caretypCode="" 0
	s ctacuId=$o(^CT("ACU",0,"Code",caretypCode,""))
	q:ctacuId="" 0
	&sql(update PA_Adm (PAADM_Priority_DR) Values (:ctacuId) Where PAADM_RowId=:EpisodeID)
    i SQLCODE q "修改病人等级出错!"
	q 0
}

ClassMethod SetDeceasedStatus(EpisodeID = "", avsDateStr, avsTimeStr) As %String
{
	q:EpisodeID="" "无病人就诊信息!"
	s papmiId=$p(^PAADM(EpisodeID),"^",1)
	
	s DeceasedFlag=""
	s DeceasedDate=""
   	s DeceasedTime=""
	s DeceasedFlag=$p(^PAPER(papmiId,"ALL"),"^",12)
	s DeceasedDate=$p(^PAPER(papmiId,"ALL"),"^",13)
	s DeceasedTime=$p(^PAPER(papmiId,"ALL"),"^",8)
	q:(DeceasedFlag'="")!(DeceasedDate'="")!(DeceasedTime'="") 0  
	
	s DeceasedFlag="Y"
	s DeceasedDate=$$$ZDH(avsDateStr,4)
   	s DeceasedTime=$ZTH(avsTimeStr)
	&sql(update PA_Person set PAPER_Deceased=:DeceasedFlag,PAPER_Deceased_Date=:DeceasedDate,PAPER_DeceasedTime=:DeceasedTime where PAPER_RowId=:papmiId)	
	i SQLCODE q "记录病人死亡状态日期时间出错!"
	q 0
}

/*ClassMethod GetStayStatus(Adm) As %String
{
	//w ##class(web.DHCADMVisitStat).GetStayStatus(467136)
	n (Adm)
	s ii=0
    s rtn=-1
    q:(Adm="") rtn
   
    s Admtype=$p($g(^PAADM(Adm)),"^",2)
    ;b
    q:(Admtype'="E" ) rtn
    s AdmRea=$p($g(^PAADM(Adm,1)),"^",7)
    q:$g(AdmRea)="" rtn		//PAC_AdmReason收费类型
    s InsurFlag=+$p($g(^PAC("ADMREA",+AdmRea)),"^",9)
    ;q:(InsurFlag=0) rtn		//非医保
	s BedCodeDr=$p($g(^PAADM(Adm)),"^",73)
	;s ^TmpWudan(Adm,2)=Adm
	;b  //非医保
	q:(BedCodeDr="")!(BedCodeDr=0) rtn	//	无床位
	;s ^TmpWudan(Adm,3)=Adm
	;b ;BedCodeDr
     s PatAllStatusCode=""
    s PatCurStatusDr=""
	f  s PatCurStatusDr=$o(^DHCADMVisitStatus(0,"PAADM",Adm,PatCurStatusDr)) q:(PatCurStatusDr="")  d
	.s PatCurStatusCTid=$p($g(^DHCADMVisitStatus(PatCurStatusDr)),"^",2)
	.q:PatCurStatusCTid=""
	.s PatCurStatusCode=$p($g(^DHCPACVisitStatus(PatCurStatusCTid)),"^",1)
	.s PatCurStatusCode=$zcvt(PatCurStatusCode,"U")
	.s ii=ii+1
	.i PatAllStatusCode="" d
	..s PatAllStatusCode=PatCurStatusCode
	.e  d
	..s PatAllStatusCode=PatAllStatusCode_"^"_PatCurStatusCode
	
	q:((PatAllStatusCode'["STAY")&(PatAllStatusCode'["SALVAGE")) rtn  //状态变更中不包含留观或抢救
	
	i (($p(PatAllStatusCode,"^",ii)="STAY")!($p(PatAllStatusCode,"^",ii)="SALVAGE")) s rtn=1   //留观状态,当前为留观或抢救
	e  s rtn=2 //曾经留观	
	q rtn
}*/

///         医生站/计费接口
///         返回值 1:当前状态为留观,2:曾经留观但当前非留观,-1:非留观

}
