Import SQLUser

Class web.DHCICUArrange Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// Creator：		-
/// CreatDate：		-
/// Description：	查询重症监护列表
/// Input: 			fromDate:开始日期,toDate:结束日期,regNo:登记号,ctlocId:重症科室ID,
/// 				icuaStatusCode:重症监护记录状态代码,papmiMedicare:住院号,papmiName:姓名
/// 				WardType:病区类型
/// Output: 		对应重症科室正在监护的所有重症记录，
/// 				有登记号、住院号、姓名其中之一则查询此病人对应的所有重症记录
/// 				优先级：登记号 > 住院号 > 姓名 > 当前科室
Query FindICUArrange(fromDate As %String, toDate As %String, regNo As %String = "", ctlocId As %String = "", icuaStatusCode As %String = "", papmiMedicare As %String = "", papmiName As %String = "", WardType As %String = "") As %Query(ROWSPEC = "tStartDateTime:%String,tEndDateTime:%String,tRegNo:%String,tPatName:%String,tAdmLocDesc:%String,tStatus:%String,tBedCode:%String,tDiagDesc:%String,tWardDesc:%String,icuaId:%String,tEpisodeID:%String,tMedCareNo:%String,tIcuaType:%String,tICUANormalStartDate:%String,tICUANormalStartTime:%String,tPatHeight:%String,tPatWeight:%String,tBodySquare:%String,icuBedId:%String,curWardId:%String,tICUAResidentCtcpDr:%String,tICUAResidentCtcpDesc:%String,tICUAAttendingCtcpDr:%String,tICUAAttendingCtcpDesc:%String,mainNurse:%String,mainNurseTwo:%String") [ SqlProc ]
{
}

ClassMethod FindICUArrangeExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", ctlocId As %String = "", icuaStatusCode As %String = "", papmiMedicare As %String = "", papmiName As %String = "", WardType As %String = "") As %Status
{
	b	;1
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
	s ^tempwhl("icu")=fromDate_"^"_toDate_"^"_regNo	_"^"_ctlocId_"^"_icuaStatusCode_"^"_papmiMedicare_"^"_papmiName_"^"_WardType
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	s EpisodeIDList=""
	i regNo'="" s EpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID(regNo,"")
	i papmiMedicare'="",EpisodeIDList="" d
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
		.s papmiId=$o(^PAPERi("Medicare1",papmiMedicare,""))	
		.s EpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID("",papmiId)
	i papmiName'="",EpisodeIDList="" d
		.s papmiName=$$ALPHAUP^SSUTIL4(papmiName)
		.s papmiId=""
		.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiName,papmiId)) q:papmiId=""  d
			..s curPapmiEpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID("",papmiId)
			..i EpisodeIDList'="" s EpisodeIDList=EpisodeIDList_"^"_curPapmiEpisodeIDList
			..e  s EpisodeIDList=curPapmiEpisodeIDList
 	;i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr","eps")=EpisodeIDList
	//w EpisodeIDList,"/"
	s ifSingle="N"
	i regNo="",papmiMedicare="",papmiName="" s ifSingle="Y",tBodySquare=""
	i ctlocId="",EpisodeIDList="" s ctlocId=40
	i ctlocId="" s ctlocId=40
	i EpisodeIDList="",ifSingle="Y" s EpisodeIDList=##class(web.DHCICUCom).FindWardPatient("", ctlocId)
	;i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr","eps")=EpisodeIDList
	s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
	//w wardId,!
	b ;"111"
	i ifSingle="Y",wardId'="" d
		.s icuaBedList=""
		.f date=$h-7:1:+$h d
			..s icuaId=""
			..f  s icuaId=$o(^DHCICUArrange(0,"SDate",date,icuaId)) q:icuaId=""  d
				...q:'$d(^DHCICUArrange(icuaId))
				...s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
				...q:+icuBedId'=wardId
				...s curEpisodeID=+^DHCICUArrange(+icuaId)
				...q:$p($g(^PAADM(curEpisodeID)),"^",73)=""
				...i ("^"_EpisodeIDList_"^")'[curEpisodeID s EpisodeIDList=EpisodeIDList_"^"_curEpisodeID
	//w EpisodeIDList,!
	s wardIdList=wardId
	i wardIdList="" d
		.q:ctlocId=""
		.q:$p($g(^CTLOC(ctlocId)),"^",13)="W"
		.s linkLocIdStr=##class(web.DHCClinicCom).GetLinkLocId(ctlocId)
		.f i=1:1:$l(linkLocIdStr,"^") d
			..s linkLocId=$p(linkLocIdStr,"^",i)
			..q:linkLocId=""
			..q:$p($g(^CTLOC(linkLocId)),"^",13)'="W"
			..s linkWardId=$o(^PAWARD(0,"WARD_LocationDR",linkLocId,0))
			..i wardIdList'="" s wardIdList=wardIdList_"^"
			..s wardIdList=wardIdList_linkWardId
	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr","eps")="/3:"_EpisodeIDList_"?"
	f i=1:1:$l(EpisodeIDList,"^") d
	    .s tEpisodeID=+$p(EpisodeIDList,"^",i)
	    .q:tEpisodeID=0
	    .//w tEpisodeID_"///"_ifSingle_"N"_ctlocId_"#"
	    .s icuaIdList=##class(web.DHCICUCom).GetIcuaId(tEpisodeID, "", "", ifSingle, "N",ctlocId)
	    .f j=1:1:$l(icuaIdList,"^") d
			..s icuaId=+$p(icuaIdList,"^",j)
			..q:icuaId=""
			..s curIcuaStatusCode=$p($g(^DHCICUArrange(+icuaId)),"^",18)
			..i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)="/4:status null?"
			..q:curIcuaStatusCode=""	;20120625
			..s patHeight=$p(^DHCICUArrange(icuaId),"^",24)
			..s patWeight=$p(^DHCICUArrange(icuaId),"^",25)
			..s tBodySquare=..Sqr((patHeight*patWeight)/3600)
			..i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/5:status equal?"
			..q:(icuaStatusCode'="")&(curIcuaStatusCode'=icuaStatusCode)
			..s startDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)
			..i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/6:before start date?"
			..q:(ifSingle'="Y")&(startDate'="")&(startDate>toDate)
			..s endDate=$p($g(^DHCICUArrange(+icuaId)),"^",7)
			..;20130426+dyl
			..;登录用户安全组
			..s groupId=24
			..s canseeday=$g(^DHCCLSet("ICU","CanSeeDays","Finish"))
			..;某些安全组的只能查看7天内的数据
			..q:(+$h>(endDate+canseeday))&(endDate'="")&(groupId="100")
			..i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/7:after end date?"
			..;q:(ifSingle'="Y")&(curIcuaStatusCode'="M")&(endDate'="")&(endDate<fromDate)
			..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
			..
			..;后面加上+20130502
			..s ICUAAdmDr=$p($g(^DHCICUArrange(icuaId)),"^",1)    //只显示床位上有的病人的信息
			..s curWardId=$o(^PAWARDA(0,"ADM",ICUAAdmDr,""))
			..q:((curWardId="")!(("^"_wardIdList_"^")'[("^"_curWardId_"^")))&(groupId="100")&(ifSingle)
			..;s curWardId=$p($g(^PAADM(tEpisodeID)),"^",70)
			..s bedId=$p($g(^PAADM(tEpisodeID)),"^",73)
			..s bedSub=$p(bedId,"||",2)
			..//w wardIdList_"_"_curWardId,!
			..q:(("^"_wardIdList_"^")'[("^"_curWardId_"^"))&(ifSingle="Y")
			..q:(bedSub="")&(ifSingle="Y")
			..//w ifSingle_"/"_icuaId_"/"_ICUAAdmDr_"/"_curWardId_"||"_bedSub,!
			..i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/8:have bed?"
			..//q:(+icuBedId=curWardId)&(+bedSub=0) ;"未定义床位!"
			..s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
			..s icuBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
			..s icuBedTPId=$p($g(^PAWARD(+icuBedId,"BED",+$p(icuBedId,"||",2))),"^",2)
			..s icuMonBed=$p($g(^PAC("BEDTP",+icuBedTPId)),"^",5)
			..i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/9:icu bed?"
			..//q:(+icuBedId=curWardId)&(icuBed'="Y")&(icuMonBed'="Y") //"非重症床!"
			..s icuBedSub=$p(icuBedId,"||",2)
			..s tBedCode=$p($g(^PAWARD(+icuBedId,"BED",+icuBedSub)),"^",1)
			..i tBedCode="" s tBedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
			..s tWardDesc=$P($g(^PAWARD(+bedId)),"^",2)
			..s papmiId=$p($g(^PAADM(tEpisodeID)),"^",1)
			..s tRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
			..i $p(^DHCICUArrange(+icuaId),"^",18)'="F" d
				...s canEdit="Y"
				...i $g(^DHCCLSet("ICU","EditDays","Decease"))>0 d
					....q:$p(^PAPER(papmiId,"ALL"),"^",12)'="Y"
					....s papmiDeceaseDate=$p(^PAPER(papmiId,"ALL"),"^",13) 
					....i (($h-papmiDeceaseDate)>^DHCCLSet("ICU","EditDays","Decease")) s canEdit="N"
				...i $g(^DHCCLSet("ICU","EditDays","Discharge"))>0 d
					....q:$p(^PAADM(tEpisodeID),"^",20)'="D"
					....s paadmDischgDate=$p(^PAADM(tEpisodeID),"^",17)
					....i (($h-paadmDischgDate)>^DHCCLSet("ICU","EditDays","Discharge")) s canEdit="N"
				...i $g(^DHCCLSet("ICU","EditDays","Transaction"))>0 d
					....q:(+icuBedId=curWardId)
					....s retStr=##class(web.DHCClinicCom).GetAdmTransWardList(tEpisodeID, .transWardList)
					....s dateTime="",leaveDate=+$h,ifFind=0
					....f  s dateTime=$o(transWardList(dateTime),-1) q:(dateTime="")!(ifFind)  d
						.....i transWardList(dateTime)=+icuBedId s ifFind=1 q
						.....s leaveDate=$p(dateTime,".")
					....i (($h-leaveDate)>^DHCCLSet("ICU","EditDays","Transaction")) s canEdit="N"
				...i canEdit'="Y" &SQL(update DHC_ICU_Arrange set ICUA_Status='F' where ICUA_RowId=:icuaId)
			..;病案号
			..;s tPapmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	        ..s paadmtype=$p($g(^PAADM(tEpisodeID)),"^",2)
	        ..s tPapmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(tEpisodeID,paadmtype,.ErrMsg)
			..q:(papmiMedicare'="")&(tPapmiMedicare'=papmiMedicare)
			..;w tPapmiMedicare
			..s tStartDateTime=""
			..i startDate'="" d
				...s tStartDateTime=$zd(startDate,3)
				...s startTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
				...s tStartDateTime=tStartDateTime_" "_$zt(startTime)
			..s tEndDateTime=""
			..i endDate'="" d
				...s tEndDateTime=$zd(endDate,3)
				...s endTime=+$p($g(^DHCICUArrange(+icuaId)),"^",9)
				...s tEndDateTime=tEndDateTime_" "_$zt(endTime)
			..;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
			..;病人姓名
			..s tPatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
			..;
			..q:(tPatName'=papmiName)&(papmiName'="")
			..s admLocId=+$p($g(^DHCICUArrange(+icuaId)),"^",2)
			..i admLocId=0,ifSingle="Y" s admLocId=+$p($g(^PAADM(tEpisodeID)),"^",4)
			..s tAdmLocDesc=$p(^CTLOC(admLocId),"^",2)
			..s tStatus=$p($g(^DHCICUArrange(+icuaId)),"^",18)
			..;病人诊断
			..s tDiagDesc=""
			..s tDiagdr=$p($g(^DHCICUArrange(+icuaId)),"^",20)
			..s num=$l(tDiagdr,"|")
			..f k=1:1:num  d
				...s Diagdr=$p(tDiagdr,"|",k)
				...q:Diagdr=""
				...i tDiagDesc="" s tDiagDesc=$p(^MRC("ID",Diagdr),"^",2)
				...e  s tDiagDesc=tDiagDesc_";"_$p(^MRC("ID",Diagdr),"^",2)
			..
  			..s tIcuaType=$p($g(^DHCICUArrange(+icuaId)),"^",5)
			..i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/10:OK!"
			..s tICUANormalStartDate=##class(web.DHCClinicCom).ConvertToDate($p(^DHCICUArrange(icuaId),"^",22),"")
			..s tICUANormalStartTime=##class(web.DHCClinicCom).ConvertToTime($p(^DHCICUArrange(icuaId),"^",23),"")
			..i curWardId="" s curWardId=+icuBedId  //curWardId=%session.Get("LOGON.WARDID")
			..s tICUAResidentCtcpDesc="",tICUAAttendingCtcpDesc=""
			..s tICUAResidentCtcpDr=$p($g(^DHCICUArrange(+icuaId)),"^",28)
			..s tICUAAttendingCtcpDr=$p($g(^DHCICUArrange(+icuaId)),"^",29)
			..i tICUAResidentCtcpDr'="" s tICUAResidentCtcpDesc=$p(##class(web.DHCClinicCom).GetUserTypeName(tICUAResidentCtcpDr),"^",2)
			..i tICUAAttendingCtcpDr'="" s tICUAAttendingCtcpDesc=$p(##class(web.DHCClinicCom).GetUserTypeName(tICUAAttendingCtcpDr),"^",2)
			..s retNurseStr=##class(web.DHCMainNurse).GetWardNurse(tEpisodeID)
			..s ICUAChargeNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",60) //责任护士 LYN 20150427
			..s ICUASupervisorNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",61) //主管护士 LYN 20150427
			..s mainNurse1="",mainNurse="",mainNurse2="",mainNurseTwo=""
			..i ICUAChargeNurseDr'= "" d
			...s mainNurse1=ICUAChargeNurseDr
			...s mainNurse=$p(##class(web.DHCClinicCom).GetUserTypeName(mainNurse1),"^",2)
	
			..i ICUASupervisorNurseDr'= "" d
			...s mainNurse2=ICUASupervisorNurseDr
			...s mainNurseTwo=$p(##class(web.DHCClinicCom).GetUserTypeName(mainNurse2),"^",2)
			..;
			..;
			..;s mainNurse="",mainNurseTwo="",DHCAdmRowId=""
			..;s DHCAdmRowId=$O(^DHCPAAdm(0,"PAAdm",tEpisodeID,DHCAdmRowId),-1)
			..;i DHCAdmRowId'="" d 
			...;s mainNurseDr=$p($g(^DHCPAAdm(DHCAdmRowId)),"^",2)
			...;i mainNurseDr'="" s mainNurse=$P($G(^CTPCP(mainNurseDr,1)),"^",2)
			..;.s mainNurseDr2=$p($g(^DHCPAAdm(DHCAdmRowId)),"^",20)
			...;i mainNurseDr2'="" s mainNurseTwo=$P($G(^CTPCP(mainNurseDr2,1)),"^",2)		
		..s tmpList(+curWardId,0_tBedCode,tEpisodeID_"."_+icuaId)=$lb(tStartDateTime,tEndDateTime,tRegNo,tPatName,tAdmLocDesc,tStatus,tBedCode,tDiagDesc,tWardDesc,icuaId,tEpisodeID,tPapmiMedicare,tIcuaType,tICUANormalStartDate,tICUANormalStartTime,patHeight,patWeight,tBodySquare,icuBedId,curWardId,tICUAResidentCtcpDr,tICUAResidentCtcpDesc,tICUAAttendingCtcpDr,tICUAAttendingCtcpDesc,mainNurse,mainNurseTwo)
	    
	s tBedCode=0,curWardId=""
	f  s curWardId=$o(tmpList(curWardId)) q:curWardId=""  d
	    .f  s tBedCode=$o(tmpList(curWardId,tBedCode)) q:tBedCode=""  d 
		..s icuaId=0
		..f  s icuaId=$o(tmpList(curWardId,tBedCode,icuaId)) q:icuaId=""  d
			...d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=tmpList(curWardId,tBedCode,icuaId) //$lb(tStartDateTime,tEndDateTime,tRegNo,tPatName,tAdmLocDesc,tStatus,tBedCode,tDiagDesc,tWardDesc,icuaId,tEpisodeID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindICUArrangeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUArrangeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUArrangeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUArrangeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：		-
/// CreatDate：		-
/// Description：	存储基础信息
/// Input: 			icuaId:重症记录ID,arrangeInfoStr:重症记录基础信息内容,underlyingDiseaseStr:疾病内容
/// Output: 		保存操作结果状态
/// w ##class(web.DHCICUArrange).SaveBaseLineInfo("1001","N^无器官衰竭^5324^5326^B^菌血症,None^无^2||3^3||3^4||6^10^0^6^0^0^^0^","")
ClassMethod SaveBaseLineInfo(icuaId As %String, arrangeInfoStr As %String = "", underlyingDiseaseStr As %String = "") As %String
{
	;s ^LynG("arrangeInfoStr")=arrangeInfoStr
	;s ^LynG("underlyingDiseaseStr")=underlyingDiseaseStr
	q:(icuaId="")!((arrangeInfoStr="")&&(underlyingDiseaseStr="")) "重症监护安排记录ID或基准线信息或基础疾病信息不能为空"
	;s ^Lyntp("arrangeInfoStr")=arrangeInfoStr
	;s ^Lyntp("underlyingDiseaseStr")=underlyingDiseaseStr
	;===========画面取值的apacheII============
	s nowDate=+$h,nowTime=$p($h,",",2)
	s ^ICUBaseLinesLog(icuaId,nowDate,nowTime,"SaveBaseLine","Before")=$p(arrangeInfoStr,"^",15)
	s ^ICUBaseLinesLog(icuaId,nowDate,nowTime,"SaveBaseLine","Before","arrangeInfoStr")=arrangeInfoStr
	k PLIST
	&sql(select * into :PLIST() from dhc_icu_arrange where %ID=:icuaId)
	i $p(arrangeInfoStr,"^",1)'="" s PLIST(27)=$p(arrangeInfoStr,"^",1)
	i $p(arrangeInfoStr,"^",2)'="" s PLIST(28)=$p(arrangeInfoStr,"^",2)
	i $p(arrangeInfoStr,"^",3)'="" s PLIST(29)=$p(arrangeInfoStr,"^",3)
	i $p(arrangeInfoStr,"^",4)'="" s PLIST(30)=$p(arrangeInfoStr,"^",4)
	i $p(arrangeInfoStr,"^",5)'="" s PLIST(31)=$p(arrangeInfoStr,"^",5)
	i $p(arrangeInfoStr,"^",6)'="" s PLIST(32)=$p(arrangeInfoStr,"^",6)
	i $p(arrangeInfoStr,"^",7)'="" s PLIST(33)=$p(arrangeInfoStr,"^",7)
	i $p(arrangeInfoStr,"^",8)'="" s PLIST(34)=$p(arrangeInfoStr,"^",8)
	i $p(arrangeInfoStr,"^",9)'="" s PLIST(35)=$p(arrangeInfoStr,"^",9)
	i $p(arrangeInfoStr,"^",10)'="" s PLIST(36)=$p(arrangeInfoStr,"^",10)
	i $p(arrangeInfoStr,"^",11)'="" s PLIST(37)=$p(arrangeInfoStr,"^",11)
	i $p(arrangeInfoStr,"^",12)'="" s PLIST(38)=$p(arrangeInfoStr,"^",12)
	i $p(arrangeInfoStr,"^",13)'="" s PLIST(39)=$p(arrangeInfoStr,"^",13)
	i $p(arrangeInfoStr,"^",14)'="" s PLIST(40)=$p(arrangeInfoStr,"^",14)
	i $p(arrangeInfoStr,"^",15)'="" s PLIST(41)=$p(arrangeInfoStr,"^",15)
	i $p(arrangeInfoStr,"^",16)'="" s PLIST(42)=$p(arrangeInfoStr,"^",16)
	i $p(arrangeInfoStr,"^",17)'="" s PLIST(43)=$p(arrangeInfoStr,"^",17)
	b	
	TStart
	&sql(update dhc_icu_arrange values :PLIST() where %ID=:icuaId)
	i (SQLCODE) TRollBack  q "保存基准线信息失败！"_SQLCODE	
	s ^Lyntp("arrangeInfoStr","sqlcode")=SQLCODE
	TCommit	
	
	s underlyingDiseaseCount=$l(underlyingDiseaseStr,"^")
	&SQL(delete from DHC_ICU_UnderlyingDisease where ICUCUD_ICUA_Dr=:icuaId)
	f i=1:1:underlyingDiseaseCount  d
	.s diseaseId=$p(underlyingDiseaseStr,"^",i)
	.q:diseaseId=""
 	.&sql(insert into DHC_ICU_UnderlyingDisease (ICUCUD_ICUA_Dr,ICUCUD_CLCUD_Dr) values (:icuaId,:diseaseId))
	i (SQLCODE) TRollBack  q "保存基础疾病信息失败！"_SQLCODE
	;===========画面取值的apacheII============
	s nowDate=+$h,nowTime=$p($h,",",2)
	s afterApacheII=$p($g(^DHCICUArrange(icuaId)),"^",40)
	s ^ICUBaseLinesLog(icuaId,nowDate,nowTime,"SaveBaseLine","after")=afterApacheII
	//TCommit
	q 0
}

/// Creator：		-
/// CreatDate：		-
/// Description：	新增重症监护记录
/// Input: 			EpisodeID:就诊号,userId:用户ID
/// Output: 		保存操作结果状态
ClassMethod InsertICUArrange(EpisodeID As %String, userId As %String)
{
	q:(EpisodeID="")!(userId="") "就诊号和用户不能为空!"
	s curDate=+$h,curTime=$p($h,",",2)
	k PLIST
	s PLIST(2)=EpisodeID
	s PLIST(3)=$p($g(^PAADM(EpisodeID)),"^",4)
	s PLIST(5)=$p($g(^PAADM(EpisodeID)),"^",73)
	s PLIST(7)=curDate  
	s PLIST(9)=curTime
	s PLIST(12)=userId 
	s PLIST(13)=curDate  
	s PLIST(14)=curTime
	s PLIST(15)=userId 
	s PLIST(16)=curDate  
	s PLIST(17)=curTime
	s PLIST(19)="R"
	&SQL(insert into DHC_ICU_Arrange Values :PLIST())
	q SQLCODE
}

/// Creator：		-
/// CreatDate：		-
/// Description：	查询重症记录状态基础数据
/// Input: 			无
/// Output: 		状态对应描述和代码
Query FindICUStatus() As %Query(ROWSPEC = "statDesc:%String,statCode:%String") [ SqlProc ]
{
}

ClassMethod FindICUStatusExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	//A-申请,D-拒绝,R-接收,M-监护,T-停止,F-完成
	s statDescStr="安排^监护^停止^完成" //"申请^拒绝^安排^监护^停止^完成"
	s statCodeStr="R^M^T^F" //"A^D^R^M^T^F" 
	f i=1:1:4 d
	    .s statDesc=$p(statDescStr,"^",i)
	    .s statCode=$p(statCodeStr,"^",i)
	    .d OutputStat
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputStat
	s Data=$lb(statDesc,statCode)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindICUStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUStatusExecute ]
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

ClassMethod FindICUStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUStatusExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator：		-
/// CreatDate：		-
/// Description：	检查是否有此就诊号对应的重症记录（安排和监护状态）？
/// Input: 			EpisodeID:就诊号
/// Output: 		2:error,1:true,0:false
/// Tips：			与DirectHasSameEpisodeID功能近似，下一版可以考虑合并
ClassMethod HasSameEpisodeID(EpisodeID As %String)
{
	i EpisodeID="" q 2
	i EpisodeID'="" s theEpisodeID=EpisodeID
	s icuaId=0
	s res=0
	f  s icuaId=$o(^DHCICUArrange(icuaId)) q:icuaId=""  d
	.i $p(^DHCICUArrange(icuaId),"^",1)=theEpisodeID,$p(^DHCICUArrange(icuaId),"^",18)="R"  s res=1
	.i $p(^DHCICUArrange(icuaId),"^",1)=theEpisodeID,$p(^DHCICUArrange(icuaId),"^",18)="M"  s res=1
	q res
}

/// Creator：		-
/// CreatDate：		-
/// Description：	求开方值
/// Input: 			任意正数
/// Output: 		开方值
/// Tips：			基础方法，应移动至DHCClinicCom类中
ClassMethod Sqr(Number As %String) As %String
{
	s res=$ZSQR(Number)
	s res=$FNUMBER(res,"",3)
	q res
}

/// Creator：		-
/// CreatDate：		-
/// Description：	删除重症记录
/// Input: 			icuaId:重症记录ID
/// Output: 		删除操作状态代码
ClassMethod DeleteICUArrange(icuaId As %String)
{
    i icuaId="" q 0
    //&SQL(delete from DHC_ICU_Arrange where ICUA_RowId=:icuaId)  //
	&SQL(update DHC_ICU_Arrange set ICUA_Status='D' where ICUA_RowId=:icuaId) //不是真正删除，防止误操作
	q SQLCODE
}

/// Creator：		-
/// CreatDate：		-
/// Description：	直接插入ICU安排记录
/// Input: 			EpisodeID:就诊号,userId:用户ID,startDate:开始日期,startTime:开始时间
/// Output: 		保存操作状态代码和重症记录ID
ClassMethod DirectInsertICUArrange(EpisodeID As %String, userId As %String, startDate As %String, startTime As %String) As %String
{
	q:(EpisodeID="")!(userId="") "就诊号和用户不能为空!"
	s wardId=$p($g(^PAADM(EpisodeID)),"^",70)
	q:wardId="" "该病人无病区信息!"
	q:$p($g(^PAADM(EpisodeID)),"^",73)="" "该病人没有安排到床位上!"
	s retStr=..AdjIcuaStartDateTime(EpisodeID, .startDate, .startTime)
	q:retStr'=0 retStr
	q:(startDate="")!(startTime="") "该病人转病区时间有误!"
	
	s curDate=+$h,curTime=$p($h,",",2)
	k PLIST
	s PLIST(2)=EpisodeID
	s PLIST(3)=$p($g(^PAADM(EpisodeID)),"^",4)
	s PLIST(5)=$p($g(^PAADM(EpisodeID)),"^",73)
	s PLIST(7)=startDate  
	s PLIST(9)=startTime
	s PLIST(12)=userId 
	s PLIST(13)=curDate  
	s PLIST(14)=curTime
	s PLIST(15)=userId 
	s PLIST(16)=curDate  
	s PLIST(17)=curTime
	s PLIST(19)="M"
	&SQL(insert into DHC_ICU_Arrange Values :PLIST())
	s arrangeId=$g(%ROWID)
	q SQLCODE_"^"_arrangeId
}

/// Creator：		-
/// CreatDate：		-
/// Description：	调整监护开始时间：通常监护开始时间不早于入院/转入病区时间。
/// 				早于入病区时间控制：入院病区最多早一天；非入院病区最多早5小时（但不能早于入前一病区时间）
/// Input: 			EpisodeID:就诊号,startDate:开始日期,startTime:开始时间
/// Output: 		无转科记录时返回提示，其他情况返回0
ClassMethod AdjIcuaStartDateTime(EpisodeID As %String, startDate As %String, startTime As %String) As %String
{
	s retStr=##class(web.DHCClinicCom).GetAdmTransWardList(EpisodeID, .transWardList)
	q:retStr'=0 retStr
	q:'$d(transWardList) "该病人无转病区记录!"
	
	s wardInDateTime=$o(transWardList(""),-1)
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s startTime=##class(web.DHCClinicCom).ConvertToTimeH(startTime)
	s startDateTime=startDate+(startTime/100000)
	i startDateTime<wardInDateTime d
		.s wardInDate=$p(wardInDateTime,".",1)
		.s wardInTime=(wardInDateTime-wardInDate)*100000
		.s minTime=wardInTime,minDate=wardInDate
		.s preWardInDateTime=$o(transWardList(wardInDateTime),-1)
		.i preWardInDateTime'="" d //非入院病区
			..s minTime=minTime-18000 //最早提前5小时
			..i minTime<0 d
				...s minTime=minTime+86400
				...s minDate=minDate-1
			..s minDateTime=minDate+(minTime/100000)
			..i preWardInDateTime>minDateTime d //最早时间不早于上次转病区时间
				...s minDate=$p(preWardInDateTime,".",1)
				...s minTime=(preWardInDateTime-minDate)*100000
		.e  s minDate=minDate-1 //入院病区，最早提前一天
		.s minDateTime=minDate+(minTime/100000)
		.i startDateTime<minDateTime d
			..s startDate=minDate,startTime=minTime
	q 0
}

/// Creator：		-
/// CreatDate：		-
/// Description：	直接判断是否存在已经安排的重症记录，如有返回icuaId
/// Input: 			EpisodeID:就诊号
/// Output: 		2:error,1:true,0:false
ClassMethod DirectHasSameEpisodeID(EpisodeID As %String)
{
	i EpisodeID="" q 2
	i EpisodeID'="" s theEpisodeID=EpisodeID
	s icuaId=0
	s arrangeId=0
	s res=0
	f  s icuaId=$o(^DHCICUArrange(icuaId)) q:icuaId=""  d
	.i $p(^DHCICUArrange(icuaId),"^",1)=theEpisodeID,$p(^DHCICUArrange(icuaId),"^",18)="R"  d
	..s res=1
	..s arrangeId=icuaId
	.i $p(^DHCICUArrange(icuaId),"^",1)=theEpisodeID,$p(^DHCICUArrange(icuaId),"^",18)="M"  d
	..s res=1
	..s arrangeId=icuaId
	q res_"^"_arrangeId
}

/// Creator：		-
/// CreatDate：		-
/// Description：	更新重症记录类型
/// Input: 			icuaId:重症记录ID,icuaType:重症记录类型
/// Output: 		更新操作状态代码
ClassMethod UpdateICUArrange(icuaId As %String, icuaType As %String)
{
    i icuaId="" q 0
	&SQL(update DHC_ICU_Arrange set ICUA_Type=:icuaType where ICUA_RowId=:icuaId)
	q SQLCODE
}

/// Creator：		-
/// CreatDate：		-
/// Description：	更新重症记录开始时间
/// Input: 			icuaId:重症记录ID,date:开始日期,time:开始时间
/// Output: 		更新操作状态代码
ClassMethod UpdateNormalStart(icuaId As %String, date As %String, time As %String)
{
	i icuaId="" q 0
	s date=##class(web.DHCClinicCom).ConvertToDateH(date,"")
	s time=##class(web.DHCClinicCom).ConvertToTimeH(time,"")
	i date="" s time=""
	&SQL(update DHC_ICU_Arrange set ICUA_NormalStartDate=:date,ICUA_NormalStartTime=:time where ICUA_RowId=:icuaId)
	q SQLCODE
}

/// Creator：		-
/// CreatDate：		-
/// Description：	统计重症记录医嘱执行数量
/// Input: 			startDate:开始日期,endDate:结束日期,ctlocId:科室ID,ctcpId:医护人员ID,regNo:登记号,
/// 				papmiMedicare:住院号,papmiName:姓名
/// Output: 		按科室、显示大类、显示分类、常用医嘱、用户 统计医嘱执行数量
/// Tips：			统计Query，应统一移动至DHCICUStat类
Query StatICUOrder(startDate As %String = "", endDate As %String = "", ctlocId As %String = "", ctcpId As %String = "", regNo As %String = "", papmiMedicare As %String = "", papmiName As %String = "") As %Query(ROWSPEC = "tWardDesc:%String,tAncvscDesc:%String,tAncvcDesc:%String,tAncoDesc:%String,tQty:%String,tExecOrdQty:%String,tCtcpDesc:%String") [ SqlProc ]
{
}

ClassMethod StatICUOrderExecute(ByRef qHandle As %Binary, startDate As %String = "", endDate As %String = "", ctlocId As %String = "", ctcpId As %String = "", regNo As %String = "", papmiMedicare As %String = "", papmiName As %String = "") As %Status
{
	//开始日期、结束日期，科室、医护人员、项目名称、病人
	//科室、大类、子类、项目、数量、执行医嘱数、医护人员
	//d ##CLASS(%ResultSet).RunQuery("web.DHCICUArrange","StatICUOrder",62100,40)
	s ^tmpYpz("icustat")=startDate_"/"_endDate_"/"_ctlocId_"/"_ctcpId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s startDate=##class(web.DHCClinicCom).ConvertToDateH(startDate)
	s endDate=##class(web.DHCClinicCom).ConvertToDateH(endDate)
	i regNo="" d
		.q:papmiMedicare=""
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
		.s papmiId=$o(^PAPERi("Medicare1",papmiMedicare,""))
		.q:papmiId=""
		.s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s icuaIdList=""
	i regNo="" d
		.q:papmiName=""
		.s papmiName=$$ALPHAUP^SSUTIL4(papmiName)
		.s papmiId=""
		.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiName,papmiId)) q:papmiId=""  d
			..s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
			..s icuaId=##class(web.DHCICUCom).GetIcuaId("", regNo, "", "N", "N")
			..i icuaIdList'="" s icuaIdList=icuaIdList_"^"
			..s icuaIdList=icuaIdList_icuaId
	i icuaIdList="" s icuaIdList=##class(web.DHCICUCom).GetIcuaId("", regNo, "", "N", "N")
	//i ctlocId="",icuaIdList="" s ctlocId=%session.Get("LOGON.CTLOCID")
	i icuaIdList="",ctlocId'="" s icuaIdList=##class(web.DHCICUCom).FindIcuaIdList("", "", ctlocId)
	i icuaIdList="" Set qHandle=$lb(0,repid,0) q $$$OK
	s wardId=""
	i ctlocId'="" s wardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
	
	s fDate=startDate-1
	f curDate=fDate:1:endDate d
	    .f i=1:1:$l(icuaIdList,"^") d
	        ..s icuaId=$p(icuaIdList,"^",i)
	        ..s bedId=$p(^DHCICUArrange(icuaId),"^",4)
	        ..q:(wardId'="")&(wardId'=+bedId)
	        ..s icuoSttTime=""
	        ..f  s icuoSttTime=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime)) q:icuoSttTime=""  d
	            ...s icuoId=""
	            ...f  s icuoId=$o(^DHCICUOrder(0,"SttDateTime",curDate,icuaId,icuoSttTime,icuoId)) q:icuoId=""  d
	                ....q:'$d(^DHCICUOrder(icuoId))
	                ....s icuoStartDate=$p(^DHCICUOrder(icuoId),"^",5)
	                ....s icuoEndDate=$p(^DHCICUOrder(icuoId),"^",7)
	                ....q:"ICD"[$p(^DHCICUOrder(icuoId),"^",25)
	                ....q:icuoEndDate<startDate
	                ....q:icuoStartDate>endDate
	                ....s arcimId=$p(^DHCICUOrder(icuoId),"^",9)	//ICUO_ARCIM_Dr
	                ....s ancoId=$p(^DHCICUOrder(icuoId),"^",2)		//ICUO_ComOrd_Dr
	                ....//q:(needAncoId'="")&(("^"_needAncoId_"^")'[("^"_ancoId_"^"))
	                ....q:(ancoId="")&(arcimId="")
	                ....s tWardDesc=$p(^PAWARD(+bedId),"^",2)
	                ....s oeoreId=$p(^DHCICUOrder(icuoId),"^",3)
	                ....s oeordId=+oeoreId
	                ....s oeoriSub=$p(oeoreId,"||",2)
	                ....s oeoriId=""
	                ....i oeoriSub'="" s oeoriId=oeordId_"||"_oeoriSub
	                ....s userId=$p(^DHCICUOrder(icuoId),"^",4)
	                ....s tCtcpId=$p($g(^SSU("SSUSR",userId)),"^",14)
	                ....q:(ctcpId'="")&(ctcpId'=tCtcpId)
	                ....s ancvcId=$p(^DHCICUOrder(icuoId),"^",16)	//ICUO_ViewCat_Dr
	                ....i oeoriSub'="" s tmp(+bedId,+ancvcId,0,+tCtcpId)=$g(tmp(+bedId,+ancvcId,0,+tCtcpId))+1
	                ....i oeoriSub="" s tmp(+bedId,+ancvcId,ancoId,+tCtcpId)=$g(tmp(+bedId,+ancvcId,ancoId,+tCtcpId))+1
	s bedId=""
	f  s bedId=$o(tmp(bedId)) q:bedId=""  d
	 	.s ancvcId=""
	 	.f  s ancvcId=$o(tmp(bedId,ancvcId)) q:ancvcId=""  d
	     	..s ancoId=""
	     	..f  s ancoId=$o(tmp(bedId,ancvcId,ancoId)) q:ancoId=""  d
	         	...s tCtcpId=""
	         	...f  s tCtcpId=$o(tmp(bedId,ancvcId,ancoId,tCtcpId)) q:tCtcpId=""  d
	             	....s tExecOrdQty="",tQty=""
	             	....s tWardDesc=$p(^PAWARD(+wardId),"^",2)
	                ....s tCtcpDesc=$p(^CTPCP(tCtcpId,1),"^",2)
	                ....s tAncoDesc=$p(^DHCICUC("RecordItem",ancoId),"^",2)
	                ....s tAncvcDesc=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",2)
	                ....i tAncvcDesc["[" s tAncvcDesc=$p(tAncvcDesc,"[")
	                ....s ancvscId=$p($g(^DHCICUC("ViewCat",ancvcId)),"^",10)
	                ....s tAncvscDesc=$p($g(^DHCICUC("VSCat",+ancvscId)),"^",2)
	             	....i ancoId=0 d
	             		.....s tExecOrdQty=tmp(bedId,ancvcId,ancoId,tCtcpId)
	             	....e  d
	             		.....s tQty=tmp(bedId,ancvcId,ancoId,tCtcpId)
	                ....d OutPutOrdStat
 	s qHandle=$lb(0,repid,0)
	q $$$OK

OutPutOrdStat
	s Data=$lb(tWardDesc,tAncvscDesc,tAncvcDesc,tAncoDesc,tQty,tExecOrdQty,tCtcpDesc)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod StatICUOrderFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = StatICUOrderExecute ]
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

ClassMethod StatICUOrderClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = StatICUOrderExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator：		-
/// CreatDate：		-
/// Description：	查询单条重症监护记录
/// Input: 			icuaId:重症监护记录ID
/// Output: 		重症记录表各字段值
Query GetIcuArrangeById(icuaId As %String) As %SQLQuery(CONTAINID = 1) [ SqlProc ]
{
SELECT %ID As Id,
	   icua_adm_dr As EpisodeId,
	   icua_patdept_dr As DeptId,
	   icua_bed_dr As BedId,
	   icua_startdate As StartDate,
	   icua_starttime As StartTime,
	   icua_enddate As EndDate,
	   icua_endtime As EndTime,
	   icua_createuser_dr As CreateUserId,
	   icua_createdate As CreateDate,
	   icua_createtime As CreateTime,
	   icua_updateuser_dr As UpdateUserId,
	   icua_updatedate As UpdateDate,
	   icua_updatetime As UpdateTime,
	   icua_status As Status
	   FROM DHC_ICU_Arrange Where %ID=:icuaId
}

/// Creator：		-
/// CreatDate：		-
/// Description：	获取诊断
/// Input: 			admId:就诊号
/// Output: 		诊断描述
/// Tips：			基础方法，应移动至DHCClinicCom类，或直接调用DHCClinicCom类方法
ClassMethod GetDiag(admId As %String = "")
{

	s $p(str,"^",2)=""
	q:admId="" $p(str,"^",2)
	s mradm=$P(^PAADM(admId),"^",61)
	s retIcdId=""
	s DiagStr=""
	 //考虑到如果加前缀可能把诊断当成自定义，暂时不加，以后改造
	 s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mradm)
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
		.s curDiagStr=$p(diagInfoStr,"^",dnum)
		.s curDigDesc=$p(curDiagStr,"&&",1)
		.s curDigId=$p(curDiagStr,"&&",2)
		.s curDigNote=$p(curDiagStr,"&&",3)
		.s curPreFix=$p(curDiagStr,"&&",4)
		.s curDigType=$p(curDiagStr,"&&",5)
		.s curDigMainFlag=$p(curDiagStr,"&&",6)
		.s newDiagStr=curPreFix_curDigDesc_"^"_curDigId
		.i DiagStr'="" s DiagStr=DiagStr_";"_newDiagStr
		.e  s DiagStr=newDiagStr

	/*
	s mcl=0  
	f  s mcl=$O(^MR(mradm,"DIA",mcl) ) q:(mcl="")  d
		.s icddr=$P(^MR(mradm,"DIA",mcl),"^",1)
		.q:icddr=""
		.s retIcdId=icddr
		.i icddr'=""  d
			..s diagdes=$P(^MRC("ID",icddr),"^",2)
			..s diagdes=diagdes_"^"_icddr
		.i tDiagDesc="" s tDiagDesc=diagdes
		.e  s tDiagDesc=tDiagDesc_";"_diagdes
		*/
	q DiagStr
}

/// Creator：		-
/// CreatDate：		-
/// Description：	更新身高至重症记录
/// Input: 			patHeight:身高,icuaId:重症记录ID
/// Output: 		更新操作状态代码
/// ICUA_PatWeight
ClassMethod InsertHeight(patHeight As %String, icuaId As %String)
{
    i icuaId="" q 0
    ;s ^tmpDyl("ICU",icuaId)=+patHeight
	&SQL(update DHC_ICU_Arrange set ICUA_PatHeight=:patHeight where ICUA_RowId=:icuaId)
	q SQLCODE
}

/// Creator：		-
/// CreatDate：		-
/// Description：	更新体重至重症记录
/// Input: 			patWeight:体重,icuaId:重症记录ID
/// Output: 		更新操作状态代码
ClassMethod InsertWeight(patWeight As %String, icuaId As %String)
{
    i icuaId="" q 0
	&SQL(update DHC_ICU_Arrange set ICUA_PatWeight=:patWeight where ICUA_RowId=:icuaId)
	q SQLCODE
}

/// Creator：		-
/// CreatDate：		-
/// Description：	获取诊断
/// Input: 			MRAdm:就诊号
/// Output: 		诊断描述
/// Tips：			基础方法，且与GetDiag方法意义一致，应合并
ClassMethod GetMRAdmDiagnosis(MRAdm As %String) As %String
{
	 q:$g(MRAdm)="" ""
	 s mrAdmId=$p($g(^PAADM(MRAdm)),"^",61)
	 q:mrAdmId="" ""
	 s DiagStr=""
	 /*
	 s Diagtmp=0
	 f  s Diagtmp=$O(^MR(mrAdmId,"DIA",Diagtmp)) Quit:(Diagtmp="")  Do
		 .s DiagID=$P($g(^MR(mrAdmId,"DIA",Diagtmp)),"^",1)
		 .q:$g(DiagID)=""
		 .s DiagDesc=$P($g(^MRC("ID",DiagID)),"^",2)
		 .s Diag=DiagDesc_"^"_DiagID
		 .i DiagStr'="" s DiagStr=DiagStr_"|"_Diag
		 .e  s DiagStr=Diag
		 */
		 //考虑到如果加前缀可能把诊断当成自定义，暂时不加，以后改造
	 s diagInfoStr=##class(web.DHCANAdaptor).GetDiagInfoByAdmId(mrAdmId)
	s digStrLength=$l(diagInfoStr,"^")
	f dnum=1:1:digStrLength d
		.s curDiagStr=$p(diagInfoStr,"^",dnum)
		.s curDigDesc=$p(curDiagStr,"&&",1)
		.s curDigId=$p(curDiagStr,"&&",2)
		.s curDigNote=$p(curDiagStr,"&&",3)
		.s curPreFix=$p(curDiagStr,"&&",4)
		.s curDigType=$p(curDiagStr,"&&",5)
		.s curDigMainFlag=$p(curDiagStr,"&&",6)
		.s newDiagStr=curPreFix_curDigDesc_"^"_curDigId
		.i DiagStr'="" s DiagStr=DiagStr_"|"_newDiagStr
		.e  s DiagStr=newDiagStr

 q DiagStr
}

/// Creator：		-
/// CreatDate：		-
/// Description：	更新诊断至重症记录
/// Input: 			icuaId:重症记录ID,DiagId:诊断ID
/// Output: 		无
ClassMethod AddDiag(icuaId As %String, DiagId As %String = "") As %String
{
	 q:$g(icuaId)="" ""
	 s $p(^DHCICUArrange(icuaId),"^",20)=DiagId
}

// w ##class(web.DHCICUArrange).GetDiag(20)

/// Creator：		-
/// CreatDate：		-
/// Description：	从重症记录中获取相关诊断
/// Input: 			icuaId:重症记录ID
/// Output: 		诊断ID
ClassMethod GetICUARelatedDiagId(icuaId As %String) As %String
{
	 q:$g(icuaId)="" ""
	 
	 s ret=$p(^DHCICUArrange(+icuaId),"^",20)
	 
	 q ret
}

/// Creator：		-
/// CreatDate：		-
/// Description：	查询速度单位基础数据
/// Input: 			无
/// Output: 		速度单位表各字段值
/// 20120717
/// Tips：			应移动至DHCICUCSpeedUnit类中处理
Query FindANCSpeedUnit() As %Query(ROWSPEC = "tANCSUCode,tANCSUDesc,tANCSUType,tANCSUUomDr,tANCSUFactor,tANCSUByPatWeight,tANCSUBaseSpeedUnitDr,tANCSUId") [ SqlProc ]
{
}

ClassMethod FindANCSpeedUnitExecute(ByRef qHandle As %Binary) As %Status
{
 	s repid=$i(^CacheTemp)
 	i $g(ind)="" s ind=1
 	s tANCSUId=0
	f  s tANCSUId=$o(^DHCICUC("SUnit",tANCSUId)) q:tANCSUId=""  d
	    .s tANCSUCode=$p($g(^DHCICUC("SUnit",tANCSUId)),"^",1)
	    .s tANCSUDesc=$p($g(^DHCICUC("SUnit",tANCSUId)),"^",2)
	    .s tANCSUType=$p($g(^DHCICUC("SUnit",tANCSUId)),"^",3)
	    .s tANCSUUomDr=$p($g(^DHCICUC("SUnit",tANCSUId)),"^",4)
	    .s tANCSUFactor=$p($g(^DHCICUC("SUnit",tANCSUId)),"^",5)
	    .s tANCSUByPatWeight=$p($g(^DHCICUC("SUnit",tANCSUId)),"^",6)
	    .s tANCSUBaseSpeedUnitDr=$p($g(^DHCICUC("SUnit",tANCSUId)),"^",7)
	    .d OutputRow1
 	s qHandle=$lb(0,repid,0)
	q $$$OK
    
OutputRow1
	s Data=$lb(tANCSUCode,tANCSUDesc,tANCSUType,tANCSUUomDr,tANCSUFactor,tANCSUByPatWeight,tANCSUBaseSpeedUnitDr,tANCSUId)
 	s ^CacheTemp(repid,ind)=Data
 	s ind=ind+1
	q
}

ClassMethod FindANCSpeedUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindANCSpeedUnitExecute ]
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

ClassMethod FindANCSpeedUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindANCSpeedUnitExecute ]
{
	s repid=$li(qHandle,2)
 	k ^CacheTemp(repid)
 	q $$$OK
}

/// Creator：		-
/// CreatDate：		-
/// Description：	新增速度单位基础数据
/// Input: 			ANCSUCode:速度单位代码, ANCSUDesc, ANCSUType, ANCSUUomDr, ANCSUFactor, ANCSUByPatWeight, ANCSUBaseSpeedUnitDr
/// Output: 		新增操作状态代码？
/// Tips：			此方法应删除，已不再使用
ClassMethod InsertANCSpeedUnit(ANCSUCode, ANCSUDesc, ANCSUType, ANCSUUomDr, ANCSUFactor, ANCSUByPatWeight, ANCSUBaseSpeedUnitDr) As %String
{
	q:ANCSUCode="" "代码不能为空!"
	q:ANCSUDesc="" "描述不能为空!"
	;q:ANCSUType="" "类型不能为空!"
	;ANCSUCode,ANCSUDesc,ANCSUType,ANCSUUomDr,ANCSUFactor,ANCSUByPatWeight,ANCSUBaseSpeedUnitDr
	s obj = ##class(User.DHCICUCSpeedUnit).%New()
	s obj.ANCSUCode=ANCSUCode
	s obj.ANCSUDesc=ANCSUDesc
	s obj.ANCSUType=ANCSUType
	s obj.ANCSUUomDr=ANCSUUomDr
	s obj.ANCSUFactor=ANCSUFactor
	s obj.ANCSUByPatWeight=ANCSUByPatWeight
	s obj.ANCSUBaseSpeedUnitDr=ANCSUBaseSpeedUnitDr
	s saveStatus=obj.%Save()
	q:(+saveStatus=0) "数据保存失败!"
	s ANCSUId=obj.%Id()
	d obj.%Close()
	q 0
}

/// Creator：		-
/// CreatDate：		-
/// Description：	更新速度单位基础数据
/// Input: 			ANCSUId,ANCSUCode:速度单位代码, ANCSUDesc, ANCSUType, ANCSUUomDr, ANCSUFactor, ANCSUByPatWeight, ANCSUBaseSpeedUnitDr
/// Output: 		更新操作状态代码
/// Tips：			此方法应删除，已不再使用
ClassMethod UpdateANCSpeedUnit(ANCSUId, ANCSUCode, ANCSUDesc, ANCSUType, ANCSUUomDr, ANCSUFactor, ANCSUByPatWeight, ANCSUBaseSpeedUnitDr) As %String
{
	q:ANCSUId="" "RowId不能为空!"
	q:ANCSUCode="" "代码不能为空!"
	q:ANCSUDesc="" "描述不能为空!"
	;q:ANCSUType="" "类型不能为空!"
	;ANCSUCode,ANCSUDesc,ANCSUType,ANCSUUomDr,ANCSUFactor,ANCSUByPatWeight,ANCSUBaseSpeedUnitDr
	q:'##class(User.DHCICUCSpeedUnit).%ExistsId(ANCSUId) "日志码表指针无对应记录!"
	s obj = ##class(User.DHCICUCSpeedUnit).%OpenId(ANCSUId)
	s obj.ANCSUCode=ANCSUCode
	s obj.ANCSUDesc=ANCSUDesc
	s obj.ANCSUType=ANCSUType
	s obj.ANCSUUomDr=ANCSUUomDr
	s obj.ANCSUFactor=ANCSUFactor
	s obj.ANCSUByPatWeight=ANCSUByPatWeight
	s obj.ANCSUBaseSpeedUnitDr=ANCSUBaseSpeedUnitDr
	s updateStatus=obj.%Save()
	q:(+updateStatus=0) "数据修改失败!"
	s ANCSUId=obj.%Id()
	d obj.%Close()
	q 0
}

/// Creator：		-
/// CreatDate：		-
/// Description：	删除日志码表基础数据
/// Input: 			clclogId:?
/// Output: 		更新操作状态代码
/// Tips：			此方法名和其内容不匹配，应删除或修改名称并移动至日志处理类
ClassMethod DeleteANCSpeedUnit(clclogId) As %String
{
	q:clclogId="" "RowId不能为空!"
	q:'##class(User.DHCCLCLog).%ExistsId(clclogId) "日志码表指针无对应记录!"
	s deleteStatus=##class(User.DHCCLCLog).%DeleteId(clclogId)
	q:(+deleteStatus=0) "数据删除失败!"
	q 0
}

/// Creator：		dyl
/// CreatDate：		20120717
/// Description：	查询速度单位类型
/// Input: 			无
/// Output: 		类型代码
/// Tips：			此方法应移动至DHCICUCSpeedUnit类
Query FindICUType() As %Query(ROWSPEC = "Type,Id") [ SqlProc ]
{
}

ClassMethod FindICUTypeExecute(ByRef qHandle As %Binary) As %Status
{
	//V,D,U,VW,DW,UW
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s type="V",ord=1
    d outputType
    s type="D",ord=2
    d outputType
    s type="U",ord=3
    d outputType
    s type="VW",ord=4 
    d outputType  
     s type="DW",ord=5 
    d outputType  
     s type="UW",ord=6 
    d outputType  
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputType
 set Data=$lb(type,ord)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindICUTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUTypeExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：		dyl
/// CreatDate：		20120717
/// Description：	查询速度单位是否关联病人体重
/// Input: 			无
/// Output: 		代码、描述
/// Tips：			此方法应移动至DHCICUCSpeedUnit类
Query FindICUWeightActive() As %Query(ROWSPEC = "Code,Desc") [ SqlProc ]
{
}

ClassMethod FindICUWeightActiveExecute(ByRef qHandle As %Binary) As %Status
{
	//V,D,U,VW,DW,UW
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s Code="Y",Desc="Yes"
    d outputweight
    s Code="N",Desc="No"
    d outputweight
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
   
outputweight
 set Data=$lb(Code,Desc)
 Set ^CacheTemp(repid,ind)=Data
 Set ind=ind+1
 quit
}

ClassMethod FindICUWeightActiveFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUWeightActiveExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUWeightActiveClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUWeightActiveExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：		-
/// CreatDate：		-
/// Description：	查询已开重症监护的床位
/// Input: 			wardId:病区ID,type:床位预定类型？
/// Output: 		床位描述、ID
Query FindBed(wardId As %String, type As %String) As %Query(ROWSPEC = "bedDesc:%String,bedId:%String") [ SqlProc ]
{
}

ClassMethod FindBedExecute(ByRef qHandle As %Binary, wardId As %String, type As %String = "") As %Status
{
	s ^tmpIcu("bed")=wardId_"/"_type
 	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s icuaBedList=""
	f date=$h-1:1:+$h d
		.s icuaId=""
		.f  s icuaId=$o(^DHCICUArrange(0,"SDate",date,icuaId)) q:icuaId=""  d
			..q:'$d(^DHCICUArrange(icuaId))
			..s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
			..q:+icuBedId'=wardId
			..s icuaBedList(icuBedId)=""
	i wardId'=""  d
		.s bedSub=0
		.f  s bedSub=$o(^PAWARD(wardId,"BED",bedSub))  q:bedSub=""  d
			..s bedAdmSub=$o(^PAWARDA(wardId,"BED",bedSub,"ADM",0))
			..s admBookedStatus=""
			..i bedAdmSub'="" d
				...s admBookedStatus=$p(^PAWARDA(wardId,"BED",bedSub,"ADM",bedAdmSub),"^",2)
			..q:(type'="")&(type'[admBookedStatus)
			..s bedDesc=$p(^PAWARD(wardId,"BED",bedSub),"^",1)
			..s bedId=wardId_"||"_bedSub
			..q:$d(icuaBedList(bedId))
			..d OutputRow2
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow2
	set Data=$lb(bedDesc,bedId)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindBedFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindBedExecute ]
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

ClassMethod FindBedClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindBedExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Creator：		-
/// CreatDate：		-
/// Description：	获取重症监护记录对应床位ID
/// Input: 			icuaId:重症监护记录ID
/// Output: 		床位ID
ClassMethod GetBedId(icuaId)
{
	// w ##Class(User.DHCICUArrange).GetBedId(icuaId)
	s obj=##class(User.DHCICUArrange).%OpenId(icuaId)
	q:obj="" ""
	s bedId=""
	q obj.ICUABedDr
}

/// Creator：      	lyn
/// CreatDate：    	2015-05-13
/// Description： 	根据就诊号查询主管护士。
/// Table：        	PA_Adm
/// Input：        	tEpisodeID就诊号
/// 				
/// Output：        主管护士ID!主管护士^主管护士2ID!主	管护士2
/// w ##class(web.DHCICUArrange).GetMainNurse("10252632")
ClassMethod GetMainNurse(tEpisodeID As %String) As %String
{
	s mainNurseDr="",mainNurseDr2="",mainNurse="",mainNurseTwo="",DHCAdmRowId=""
	s DHCAdmRowId=$O(^DHCPAAdm(0,"PAAdm",tEpisodeID,DHCAdmRowId),-1)
	q:DHCAdmRowId="" ""
	i DHCAdmRowId'="" d 
	.s mainNurseDr=$p($g(^DHCPAAdm(DHCAdmRowId)),"^",2)
	.i mainNurseDr'="" s mainNurse=$P($G(^CTPCP(mainNurseDr,1)),"^",2)
	.s mainNurseDr2=$p($g(^DHCPAAdm(DHCAdmRowId)),"^",20)
	.i mainNurseDr2'="" s mainNurseTwo=$P($G(^CTPCP(mainNurseDr2,1)),"^",2)	
	q mainNurseDr_"!"_mainNurse_"^"_mainNurseDr2_"!"_mainNurseTwo
}

/// creater:	Lyn
/// date:		20150525
/// description:保存病人的基本信息
/// table:		DHC_ICU_PatMaster
/// w ##class(web.DHCICUArrange).SavePatMasterInfo("158^65^1448^1639^1497^1480^01110003^M^1^1^U^^^2013/11/7 16:37:00^H^N^^2015/6/23 15:09:38^T^B","^李秀华^1960/2/26 0:00:00^0^2^Y^","1362")
ClassMethod SavePatMasterInfo(argStr, argStrPM, ArranageId) As %String
{
 	q:ArranageId="" "安排ID不能为空"
 	q:argStr="" ""
 	q:argStrPM=""
 	//s argStr = height + "^" + weight + "^" + ResidentCtcp + "^" + AttendingCtcp + "^" + ChargeNurse+"^" +SupervisorNurse+ "^" + HospitalCode + "^" + Residence
   // s argStr = argStr + "^" + isEsHeight+ "^" + isEsWeight+ "^" + Pregnant+ "^" + Gestation+ "^" + DeliveryDate+ "^" + PreDayCPR+ "^" + SourceHospital+ "^" + SourceLocType+ "^" + PreHospitalAdmDate.ToString()+ "^" + InHospitalDT.ToString()
	//s argStrPM = IdentityCard + "^" + PatName + "^" + Birthday.ToString() + "^" + isEsBirth + "^" + Sex + "^" + Ethnicity + "^" + Nation
	K ^LynTmp
	s ^LynTmp("argStr")=argStr
	s ^LynTmp("argStrPM")=argStrPM
	;q 0
	s ret=""
	k PLIST
	s birthday=##class(web.DHCClinicCom).ConvertToDateH($p(argStrPM,"^",3))
	//s DeliveryDate=$p(argStr,"^",13)
	//I DeliveryDate'="" s deliveryDate=##class(web.DHCClinicCom).ConvertToDateH($p(argStr,"^",13))
	//I PreHospitalAdmDate'="" s preHospitalAdmDate=##class(web.DHCClinicCom).ConvertToDateH($p(argStr,"^",17))
	//I InHospDate'="" s preHospitalAdmDate=##class(web.DHCClinicCom).ConvertToDateH($p(argStr,"^",18))
	TSTART
	s pmRowid=""
	s PLIST(2)=$p(argStrPM,"^",1)
	s PLIST(3)=$p(argStrPM,"^",2)
	s PLIST(4)=birthday
	s PLIST(5)=(+$p(argStrPM,"^",4))
	s PLIST(6)=$p(argStrPM,"^",5)
	s PLIST(8)=$p(argStrPM,"^",6)
	s PLIST(9)=$p(argStrPM,"^",7)
	i $p(argStrPM,"^",1)'=""  s pmRowid=$o(^DHCICUPatMaster(0,"IdentityCard",$p(argStrPM,"^",1),pmRowid))
	i pmRowid ="" d  
	.&sql(INSERT INTO SQLUSER.DHC_ICU_PatMaster Values :PLIST())
	.;s pmRowid=%ROWID
	e  d  &sql(update  SQLUSER.DHC_ICU_PatMaster Values :PLIST() where ICUPM_RowId=:pmRowid)
	s Ret=%ROWID
	i SQLCODE'=0  TRollBack  q "-1^插入PatMaster表错误!"
	;q Ret
	b
	//更新安排表信息
	k PLIST
	s PLIST(25)=(+$p(argStr,"^",1)) 		;身高	ICUA_PatHeight 
	s PLIST(26)=(+$p(argStr,"^",2)) 		;体重	ICUA_PatWeight 
	s PLIST(29)=$p(argStr,"^",3) 			;住院医生
	s PLIST(30)=$p(argStr,"^",4)			;主治医生
	s PLIST(87)=$p(argStr,"^",20)			;收治类型
	s PLIST(61)=$p(argStr,"^",5)			;主管护师
	s PLIST(62)=$p(argStr,"^",6)			;责任护士
	s PLIST(63)=Ret							;ICUA_ICUPM_Dr 
	s PLIST(65)=$p(argStr,"^",7)			;医院编码
	s PLIST(66)=$p(argStr,"^",8)			;住所来源
	s PLIST(67)=(+$p(argStr,"^",9))			;是否估计身高
	s PLIST(68)=(+$p(argStr,"^",10))		;是否估计体重
	s PLIST(69)=$p(argStr,"^",11)			;妊娠情况
	s PLIST(70)=$p(argStr,"^",12)			;孕周
	s DeliveryDate=$p(argStr,"^",13)		;分娩日期
	i DeliveryDate'="" s PLIST(71)=##class(web.DHCClinicCom).ConvertToDateH(DeliveryDate)
	s InHospDate=$p(argStr,"^",14)			;入院时间
	i InHospDate'="" s PLIST(72)=##class(web.DHCClinicCom).ConvertToDateH(InHospDate)
	s PLIST(73)=$p(argStr,"^",15)			;入院24小时CPR
	s PLIST(74)=$p(argStr,"^",16)			;医院来源
	s PLIST(75)=$p(argStr,"^",17)			;医院来源科室类型
	s preHospitalAdmDate=$p(argStr,"^",18)	;入其他医院日期
	i preHospitalAdmDate'="" s PLIST(76)=##class(web.DHCClinicCom).ConvertToDateH(preHospitalAdmDate)
	s PLIST(77)=$p(argStr,"^",19)			;基础心肺疾病
	//$p(argStr,"^",20) // TreatedType?
	s PLIST(15)=$p(argStr,"^",21)			;更新人
	s PLIST(16)=+$h							;更新日期
	s PLIST(17)=$p($h,",",2)				;更新时间
	
	b ;00
	&sql(update SQLUSER.DHC_ICU_Arrange Values :PLIST() where ICUA_RowId=:ArranageId)
	s Ret1=%ROWID
	i SQLCODE'=0  TRollBack  q "-2^更新DHC_ICU_Arrange表错误!"
	b ;01
	TCOMMIT
	q Ret1
}

/// creater:	Lyn
/// date:		20150525
/// description:获取下拉列表的信息
/// table:		DHC_ICU_PatMaster
/// d ##class(%ResultSet).RunQuery("web.DHCICUArrange","GetCmbBaseInfo")
Query GetCmbBaseInfo(type As %String = "") As %Query(ROWSPEC = "Code:%String,Desc:%String,Type:%String") [ SqlProc ]
{
}

ClassMethod GetCmbBaseInfoExecute(ByRef qHandle As %Binary, type As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s rowid=0
	f  s rowid=$o(^CmbBaseInfo(rowid)) q:rowid=""  d
	.s Code=$p($g(^CmbBaseInfo(rowid)),"^",1)
	.s Desc=$p($g(^CmbBaseInfo(rowid)),"^",2)
	.s Type=$p($g(^CmbBaseInfo(rowid)),"^",3)
	.q:(type'="")&&(Type'=type)
    .d OutputRow       
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(Code,Desc,Type)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod GetCmbBaseInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCmbBaseInfoExecute ]
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

ClassMethod GetCmbBaseInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCmbBaseInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// d ##class(web.DHCICUArrange).SetCmbBASE()
/// add by lyn 
/// desc:新版基线值数据配置
ClassMethod SetCmbBASE()
{
	
	K ^CmbBaseInfo
	S ^CmbBaseInfo(0)=53
	s ^CmbBaseInfo(1)="Home^家^ResidenceO"
	s ^CmbBaseInfo(2)="Hospital^医院^ResidenceO"
	s ^CmbBaseInfo(3)="C^目前妊娠中^Pregnant"
	s ^CmbBaseInfo(4)="R^近一年妊娠史^Pregnant"
	s ^CmbBaseInfo(5)="U^无妊娠^Pregnant"
	s ^CmbBaseInfo(6)="H^有CPR院内^CPR"
	s ^CmbBaseInfo(7)="C^有CPR院外^CPR"
	s ^CmbBaseInfo(8)="N^无CPR^CPR"
	s ^CmbBaseInfo(9)="N^非本院^SourceHos"
	s ^CmbBaseInfo(10)="S^本院^SourceHos"
	s ^CmbBaseInfo(11)="O^其他医院^SourceHos"
	s ^CmbBaseInfo(12)="I^ICU^OSLocType"
	s ^CmbBaseInfo(13)="E^急诊室^OSLocType"
	s ^CmbBaseInfo(14)="O^手术室^OSLocType"
	s ^CmbBaseInfo(15)="P^麻醉恢复室^OSLocType"
	s ^CmbBaseInfo(16)="N^普通病房^OSLocType"
	s ^CmbBaseInfo(17)="R^放射科^OSLocType"
	s ^CmbBaseInfo(18)="U^门诊^OSLocType"
	s ^CmbBaseInfo(19)="T^其他^OSLocType"
	s ^CmbBaseInfo(20)="E^急诊室^SSLocType"
	s ^CmbBaseInfo(21)="O^手术室^SSLocType"
	s ^CmbBaseInfo(22)="P^麻醉恢复室^SSLocType"
	s ^CmbBaseInfo(23)="N^普通病房^SSLocType"
	s ^CmbBaseInfo(24)="D^影像科室^SSLocType"
	s ^CmbBaseInfo(25)="U^门诊^SSLocType"
	s ^CmbBaseInfo(26)="T^其他^SSLocType"
	s ^CmbBaseInfo(27)="M^家^Residence"
	s ^CmbBaseInfo(28)="W^工作场所^Residence"
	s ^CmbBaseInfo(29)="U^疗养院^Residence"
	s ^CmbBaseInfo(30)="H^医院^Residence"
	s ^CmbBaseInfo(31)="I^医疗相关机构^Residence"
	s ^CmbBaseInfo(32)="T^临时住所^Residence"
	s ^CmbBaseInfo(33)="N^非医疗相关医院^Residence"
	s ^CmbBaseInfo(34)="Y^黄种人^Ethnicity"
	s ^CmbBaseInfo(35)="W^白种人^Ethnicity"
	s ^CmbBaseInfo(36)="B^黑种人^Ethnicity"
	s ^CmbBaseInfo(37)="M^混血^Ethnicity"
	s ^CmbBaseInfo(38)="O^其他^Ethnicity"
	s ^CmbBaseInfo(39)="1^男^Sex"
	s ^CmbBaseInfo(40)="2^女^Sex"
	s ^CmbBaseInfo(41)="0^未知^Sex"
	s ^CmbBaseInfo(42)="9^未测^Sex"

	s ^CmbBaseInfo(43)="Han^汉族^Nation"
	s ^CmbBaseInfo(44)="Hui^回族^Nation"
	s ^CmbBaseInfo(45)="Zang^藏族^Nation"
	s ^CmbBaseInfo(46)="QT^其他民族^Nation"

	s ^CmbBaseInfo(47)="W^维持原有治疗^LimitedTreatment"
	s ^CmbBaseInfo(48)="D^撤出治疗^LimitedTreatment"
	s ^CmbBaseInfo(49)="N^无限制治疗^LimitedTreatment"

	s ^CmbBaseInfo(50)="W^生活完全自理^ArriveAssistance"
	s ^CmbBaseInfo(51)="M^生活大部分自理^ArriveAssistance"
	s ^CmbBaseInfo(52)="J^生活小部分自理^ArriveAssistance"
	s ^CmbBaseInfo(53)="T^生活不能自理^ArriveAssistance"
}

/// Creator：		-
/// CreatDate：		-
/// Description：	查询重症监护列表
/// Input: 			fromDate:开始日期,toDate:结束日期,regNo:登记号,ctlocId:重症科室ID,
/// 				icuaStatusCode:重症监护记录状态代码,papmiMedicare:住院号,papmiName:姓名
/// 				WardType:病区类型
/// Output: 		对应重症科室正在监护的所有重症记录，
/// 				有登记号、住院号、姓名其中之一则查询此病人对应的所有重症记录
/// 				优先级：登记号 > 住院号 > 姓名 > 当前科室
/// Tips:			与FindICUArrange意义相同，应与之合并
/// d ##class(%ResultSet).RunQuery("web.DHCICUArrange","FindICUArrangeNew","","","","","16","114","","In","N")
Query FindICUArrangeNew(fromDate As %String, toDate As %String, bedId As %String = "", regNo As %String = "", ctlocId As %String = "", papmiMedicare As %String = "", papmiName As %String = "", WardType As %String = "In", ifAllLoc As %String = "N") As %Query(ROWSPEC = "tStartDateTime:%String,tEndDateTime:%String,tRegNo:%String,tPatName:%String,tAdmLocDesc:%String,tStatus:%String,statusDesc:%String,tBedCode:%String,tDiagDesc:%String,tWardDesc:%String,icuaId:%String,tEpisodeID:%String,tMedCareNo:%String,tIcuaType:%String,tICUANormalStartDate:%String,tICUANormalStartTime:%String,tPatHeight:%String,tPatWeight:%String,tBodySquare:%String,icuBedId:%String,curWardId:%String,tICUAResidentCtcpDr:%String,tICUAResidentCtcpDesc:%String,tICUAAttendingCtcpDr:%String,tICUAAttendingCtcpDesc:%String,mainNurse:%String,mainNurseTwo:%String,patLeaveCon:%String,leaveDateTime:%String,apacheQty:%String,limitedTreatment:%String") [ SqlProc ]
{
}

ClassMethod FindICUArrangeNewExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, bedId As %String = "", regNo As %String = "", ctlocId As %String = "", papmiMedicare As %String = "", papmiName As %String = "", WardType As %String = "In", ifAllLoc As %String = "N") As %Status
{
	k ^TMPLYN	
	//优先级：regNo,papmiMedicare,papmiName,时间,ctlocId
	s ^tempwhl("icu")=fromDate_"^"_toDate_"^"_regNo_"^"_ctlocId_"^"_papmiMedicare_"^"_papmiName_"^"_WardType
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1	
	s showAllOut="N"
	
	s fromDate=##class(web.DHCClinicCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCClinicCom).ConvertToDateH(toDate)
	i toDate>+$h s toDate=+$h
	i fromDate>+$h s fromDate=+$h
	i fromDate=+$h s showAllOut="Y"
	s icuaId="" 
	i fromDate>toDate Set qHandle=$lb(0,repid,0) Quit $$$OK
	s EpisodeIDList="",wardIdList=""
	s ifSingle="N" ,isNullWard=0
	i regNo="",papmiMedicare="",papmiName="",bedId="" s ifSingle="Y",tBodySquare=""
    b 
	s LocId=ctlocId
	i ctlocId'="",wardIdList="" d
		.i ($p($g(^CTLOC(ctlocId)),"^",13)="W")||($p($g(^CTLOC(ctlocId)),"^",13)="EM")  d
			..s linkWardId=$o(^PAWARD(0,"WARD_LocationDR",ctlocId,0))
			..i wardIdList'="" s wardIdList=wardIdList_"^"
			..s wardIdList=wardIdList_linkWardId
			..s LocId=$o(^CTLOC(ctlocId,"LINK",0,"Loc",0))
		.e  d
			..s linkLocIdStr=##class(web.DHCClinicCom).GetLinkLocId(ctlocId)
			..f i=1:1:$l(linkLocIdStr,"^") d
				...s linkLocId=$p(linkLocIdStr,"^",i)
				...q:linkLocId=""
				...q:$p($g(^CTLOC(linkLocId)),"^",13)'="W"
				...s linkWardId=$o(^PAWARD(0,"WARD_LocationDR",linkLocId,0))
				...i wardIdList'="" s wardIdList=wardIdList_"^"
				...s wardIdList=wardIdList_linkWardId
	
	///查询多个病人信息
	i ifSingle="Y" {
		///出病区
		i WardType ="Out" d
		.i showAllOut="Y" d
		..s icuaId=""
		..&sql(declare ArrangeOutCursor cursor for SELECT ICUA_RowId INTO :icuaId  FROM DHC_ICU_Arrange WHERE ICUA_Status ='T')
		..&sql(open ArrangeOutCursor)
        ..for  &SQL(FETCH ArrangeOutCursor) QUIT:SQLCODE  do
		...do GetArrangeInfo1(icuaId)	
	    ..&sql(close ArrangeOutCursor)
		.e  d
		..f date=fromDate:1:toDate  d
		...s icuaId=""
		...f  s icuaId=$o(^DHCICUArrange(0,"LDate",date,icuaId)) q:icuaId=""  d
		....q:'$d(^DHCICUArrange(icuaId))
		....d GetArrangeInfo1(icuaId)
		
		///在病区
		i WardType="In" d
		.s icuaId=""
		.&sql(declare ArrangeInCursor cursor for SELECT ICUA_RowId INTO :icuaId  FROM DHC_ICU_Arrange WHERE ICUA_Status !='T')
		.&sql(open ArrangeInCursor)
        .for  &SQL(FETCH ArrangeInCursor) QUIT:SQLCODE  do
		..do GetArrangeInfo1(icuaId)	
	    .&sql(close ArrangeInCursor)
		
	}
	
	///查询单个病人		
	i ifSingle="N" {
		i regNo'="" s EpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID(regNo,"")
		i papmiMedicare'="",EpisodeIDList="" d	
			.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
			.;s papmiId=$o(^PAPERi("Medicare1",papmiMedicare,""))
			.s EpisodeIDList=..GetEpisodeListByMedcareNo(papmiMedicare)  ;##class(web.DHCClinicCom).GetPatientEpisodeID("",papmiId)
		i papmiName'="",EpisodeIDList="" d
			.s papmiName=$$ALPHAUP^SSUTIL4(papmiName)
			.s papmiId=""
			.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiName,papmiId)) q:papmiId=""  d
				..s curPapmiEpisodeIDList=##class(web.DHCClinicCom).GetPatientEpisodeID("",papmiId)
				..i EpisodeIDList'="" s EpisodeIDList=EpisodeIDList_"^"_curPapmiEpisodeIDList
				..e  s EpisodeIDList=curPapmiEpisodeIDList
		if bedId'="", EpisodeIDList="" d
			.&sql(SELECT ICUA_Adm_Dr INTO :EpisodeIDList  from DHC_ICU_Arrange WHERE ICUA_Bed_Dr=:bedId and ICUA_Status !='T')
			
	 	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr")=EpisodeIDList
		f i=1:1:$l(EpisodeIDList,"^") d
	    .s tEpisodeID=+$p(EpisodeIDList,"^",i)
	    .q:tEpisodeID=0
	    .s icuaIdList=##class(web.DHCICUCom).GetIcuaId(tEpisodeID, "", "", ifSingle, "N",LocId)
	   	.f j=1:1:$l(icuaIdList,"^") d
			..s icuaId=+$p(icuaIdList,"^",j)
			..q:icuaId=0
			..d GetArrangeInfo1(icuaId)
	}

	s tBedCode=0,curWardId=""
	f  s curWardId=$o(tmpList(curWardId)) q:curWardId=""  d
	.f  s tBedCode=$o(tmpList(curWardId,tBedCode)) q:tBedCode=""  d 
	..s icuaId=0
	..f  s icuaId=$o(tmpList(curWardId,tBedCode,icuaId)) q:icuaId=""  d
	...d OutputRow1
			
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow1
	//set Data=tmpList(curWardId,tBedCode,icuaId) //$lb(tStartDateTime,tEndDateTime,tRegNo,tPatName,tAdmLocDesc,tStatus,tBedCode,tDiagDesc,tWardDesc,icuaId,tEpisodeID)
 	Set ^CacheTemp(repid,ind)=tmpList(curWardId,tBedCode,icuaId)
 	Set ind=ind+1
	quit
	
GetArrangeInfo1(icuaId)	
	s tStatus=$p($g(^DHCICUArrange(+icuaId)),"^",18)
	s statusDesc=$s(tStatus="R":"安排",tStatus="M":"监护",tStatus="T":"停止",1:"异常")
	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)="/4:status null?"
	;q:tStatus=""	;20120625
	s ^TMPLYN(icuaId)=1
	s tEpisodeID=$p(^DHCICUArrange(icuaId),"^",1)
	s patHeight=$p(^DHCICUArrange(icuaId),"^",24)
	s patWeight=$p(^DHCICUArrange(icuaId),"^",25)
	s tBodySquare=..Sqr((patHeight*patWeight)/3600)
	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/5:status equal?"
	s ^TMPLYN(icuaId)=2
	;q:(icuaStatusCode'="")&(tStatus'=icuaStatusCode)
	;b ;01
	s startDate=$p($g(^DHCICUArrange(+icuaId)),"^",6)
	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/6:before start date?"
	;q:(ifSingle'="Y")&(startDate'="")&(startDate>toDate)
	s endDate=$p($g(^DHCICUArrange(+icuaId)),"^",7)
	;w "icuaId="_icuaId_"tStatus="_tStatus,!
	s ctlocIdIcu=$p($g(^DHCICUArrange(icuaId)),"^",2)
	s ^TMPLYN(icuaId)=3
	q:(ctlocIdIcu'=LocId)&(tStatus'="M")&(ifAllLoc="N") ;已经转归了的病人，在本科室做监护
	q:(fromDate=toDate)&((+fromDate)=+$h)&((+toDate)=+$h)&(tStatus'="M")&(ifSingle="Y")&&(WardType="In") //当天在监护的
	s ^TMPLYN(icuaId)=4
	
	s groupId="103"
	s canseeday=$g(^DHCCLSet("ICU","CanSeeDays","Finish"))
	;某些安全组的只能查看7天内的数据
	s ^TMPLYN(icuaId)=5
	q:(+$h>(endDate+canseeday))&(endDate'="")&(groupId="100")
	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/7:after end date?"
	;q:(ifSingle'="Y")&(curIcuaStatusCode'="M")&(endDate'="")&(endDate<fromDate)
	s icuBedId=$p($g(^DHCICUArrange(+icuaId)),"^",4)
	
	;后面加上+20130502
	s ICUAAdmDr=$p($g(^DHCICUArrange(icuaId)),"^",1)    //只显示床位上有的病人的信息
	s curWardId=$o(^PAWARDA(0,"ADM",ICUAAdmDr,""))

	s ^TMPLYN(icuaId)=6
	q:(papmiName="")&&(regNo="")&&((curWardId="")!(("^"_wardIdList_"^")'[("^"_curWardId_"^")))&(groupId="100")&(ifSingle)
	
	s bedId=$p($g(^PAADM(tEpisodeID)),"^",73)
	s bedSub=$p(bedId,"||",2)
	s ^TMPLYN(icuaId)=wardIdList_"/"_curWardId_""
	q:(bedSub="")&(ifSingle="Y")&(WardType="In")
	q:(papmiName="")&&(regNo="")&&(("^"_wardIdList_"^")'[("^"_curWardId_"^"))&(tStatus="M")&(ifAllLoc="N")
	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/8:have bed?"
	
	s ^TMPLYN(icuaId)=8
	s bedTpId=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",2)
	s icuBed=$p($g(^PAC("BEDTP",+bedTpId)),"^",5)
	s icuBedTPId=$p($g(^PAWARD(+icuBedId,"BED",+$p(icuBedId,"||",2))),"^",2)
	s icuMonBed=$p($g(^PAC("BEDTP",+icuBedTPId)),"^",5)
	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/9:icu bed?"
	//q:(+icuBedId=curWardId)&(icuBed'="Y")&(icuMonBed'="Y") //"非重症床!"
	s icuBedSub=$p(icuBedId,"||",2)
	s tBedCode=$p($g(^PAWARD(+icuBedId,"BED",+icuBedSub)),"^",1)
	i tBedCode="" s tBedCode=$p($g(^PAWARD(+bedId,"BED",+bedSub)),"^",1)
	s tWardDesc=$P($g(^PAWARD(+bedId)),"^",2)
	s papmiId=$p($g(^PAADM(tEpisodeID)),"^",1)
	s tRegNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	q:(regNo'="")&(tRegNo'=regNo)
	b ;04
	i $p(^DHCICUArrange(+icuaId),"^",18)'="F" d
		.s canEdit="Y"
		.i $g(^DHCCLSet("ICU","EditDays","Decease"))>0 d
			..q:$p(^PAPER(papmiId,"ALL"),"^",12)'="Y"
			..s papmiDeceaseDate=$p(^PAPER(papmiId,"ALL"),"^",13) 
			..i (($h-papmiDeceaseDate)>^DHCCLSet("ICU","EditDays","Decease")) s canEdit="N"
		.i $g(^DHCCLSet("ICU","EditDays","Discharge"))>0 d
			..q:$p(^PAADM(tEpisodeID),"^",20)'="D"
			..s paadmDischgDate=$p(^PAADM(tEpisodeID),"^",17)
			..i (($h-paadmDischgDate)>^DHCCLSet("ICU","EditDays","Discharge")) s canEdit="N"
		.i $g(^DHCCLSet("ICU","EditDays","Transaction"))>0 d
			..q:(+icuBedId=curWardId)
			..s retStr=##class(web.DHCClinicCom).GetAdmTransWardList(tEpisodeID, .transWardList)
			..s dateTime="",leaveDate=+$h,ifFind=0
			..f  s dateTime=$o(transWardList(dateTime),-1) q:(dateTime="")!(ifFind)  d
				...i transWardList(dateTime)=+icuBedId s ifFind=1 q
				...s leaveDate=$p(dateTime,".")
			..i (($h-leaveDate)>^DHCCLSet("ICU","EditDays","Transaction")) s canEdit="N"
		.i canEdit'="Y" &SQL(update DHC_ICU_Arrange set ICUA_Status='F' where ICUA_RowId=:icuaId)
	;病案号
	//s tPapmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s paadmtype=$p($g(^PAADM(tEpisodeID)),"^",2)
	s tPapmiMedicare=##Class(DHCWMR.IO.OutService).IGetMrNoByEpisodeID(tEpisodeID,paadmtype,.ErrMsg)
	s ^TMPLYN(icuaId)=9
	q:(papmiMedicare'="")&(tPapmiMedicare'=papmiMedicare)
	;w tPapmiMedicare
	s tStartDateTime=""
	i startDate'="" d
		.s tStartDateTime=##class(web.DHCClinicCom).ConvertToDate(startDate,"")
		.s startTime=+$p($g(^DHCICUArrange(+icuaId)),"^",8)
		.s tStartDateTime=tStartDateTime  ;_" "_$zt(startTime)
	s tEndDateTime=""		
	i endDate'="" d
		.s tEndDateTime=##class(web.DHCClinicCom).ConvertToDate(endDate,"")
		.s endTime=+$p($g(^DHCICUArrange(+icuaId)),"^",9)
		.s tEndDateTime=tEndDateTime  ;_" "_$zt(endTime)
	;s medCareNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	;病人姓名
	s tPatName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s ^TMPLYN(icuaId)=10
	;q:($$ALPHAUP^SSUTIL4(tPatName)'=papmiName)&(papmiName'="")
	
	
	s admLocId=+$p($g(^DHCICUArrange(+icuaId)),"^",2)
	i admLocId=0,ifSingle="Y" s admLocId=+$p($g(^PAADM(tEpisodeID)),"^",4)
	s tAdmLocDesc=$p(^CTLOC(admLocId),"^",2)
	
	;病人诊断
	s tDiagDesc=""
	s tDiagdr=$p($g(^DHCICUArrange(+icuaId)),"^",20)
	s num=$l(tDiagdr,"|")
	f k=1:1:num  d
		.s Diagdr=$p(tDiagdr,"|",k)
		.q:Diagdr=""
		.i tDiagDesc="" s tDiagDesc=$p(^MRC("ID",Diagdr),"^",2)
		.e  s tDiagDesc=tDiagDesc_";"_$p(^MRC("ID",Diagdr),"^",2)
	
  	s tIcuaType=$p($g(^DHCICUArrange(+icuaId)),"^",5)
	i $g(^tmpIcu("arr"))="Y" s ^tmpIcu("arr",+icuaId)=^tmpIcu("arr",+icuaId)_"/10:OK!"
	s tICUANormalStartDate=##class(web.DHCClinicCom).ConvertToDate($p(^DHCICUArrange(icuaId),"^",22),"")
	s tICUANormalStartTime=##class(web.DHCClinicCom).ConvertToTime($p(^DHCICUArrange(icuaId),"^",23),"")
	i curWardId="" s curWardId=+icuBedId  //curWardId=%session.Get("LOGON.WARDID")
	s tICUAResidentCtcpDesc="",tICUAAttendingCtcpDesc=""
	s tICUAResidentCtcpDr=$p($g(^DHCICUArrange(+icuaId)),"^",28)
	s tICUAAttendingCtcpDr=$p($g(^DHCICUArrange(+icuaId)),"^",29)
	
	i tICUAResidentCtcpDr'="" s tICUAResidentCtcpDesc=$p(##class(web.DHCClinicCom).GetUserTypeName(tICUAResidentCtcpDr),"^",2)
	i tICUAAttendingCtcpDr'="" s tICUAAttendingCtcpDesc=$p(##class(web.DHCClinicCom).GetUserTypeName(tICUAAttendingCtcpDr),"^",2)
	//i +icuaId=7104 s ^LynT("7104")="RES:"_tICUAResidentCtcpDr_tICUAResidentCtcpDesc_"  ATT:"_tICUAAttendingCtcpDr_tICUAAttendingCtcpDesc
	
	s retNurseStr=##class(web.DHCMainNurse).GetWardNurse(tEpisodeID)
	s ICUAChargeNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",60) //责任护士 LYN 20150427
	i ICUAChargeNurseDr=""  d
	.i retNurseStr'="" d
	..i (("^"_retNurseStr)]"^NKICU")!(("^"_retNurseStr)]"^ZZYXK") d
	...s ctcpId=$P($G(retNurseStr),"^",4)
	...i ctcpId '="" s ICUAChargeNurseDr=$o(^SSU("SSUSR",0,"CTPCP",ctcpId,""))
	
	s ICUASupervisorNurseDr=$p($g(^DHCICUArrange(+icuaId)),"^",61) //主管护士 LYN 20150427
	i ICUASupervisorNurseDr="" d
	.i (retNurseStr'="") D
	..i (("^"_retNurseStr)]"^NKICU")!(("^"_retNurseStr)]"^ZZYXK") d
	...s ctcpId=$P($G(retNurseStr),"^",6)
	...i ctcpId '="" s ICUASupervisorNurseDr=$o(^SSU("SSUSR",0,"CTPCP",ctcpId,""))
	
	s mainNurse1="",mainNurse="",mainNurse2="",mainNurseTwo=""
	i ICUAChargeNurseDr'= "" d
	.s mainNurse1=ICUAChargeNurseDr
	.s mainNurse=$p(##class(web.DHCClinicCom).GetUserTypeName(mainNurse1),"^",2)
	
	i ICUASupervisorNurseDr'= "" d
	.s mainNurse2=ICUASupervisorNurseDr
	.s mainNurseTwo=$p(##class(web.DHCClinicCom).GetUserTypeName(mainNurse2),"^",2)

	//病人去向
	s value=$p(^DHCICUArrange(icuaId),"^",43)
	s val=value
	s patLeaveCon=$s(val="":"",val="D":"死亡",value="T":"转科",value="A":"自动出院",value="M":"治愈出院",value="O":"外出治疗")
	;s patLeaveCon=value
	s LimitedTreatment=$p($g(^DHCICUArrange(+icuaId)),"^",81) ;限制治疗
	s LimitedTreatment=$s(LimitedTreatment="W":"维持原有治疗",LimitedTreatment="D":"撤出治疗",LimitedTreatment="N":"无限制治疗",1:"无")
	s leaveDate=$p(^DHCICUArrange(icuaId),"^",44)
	i leaveDate'="" s leaveDate=$zd(leaveDate,3) ;##class(web.DHCClinicCom).ConvertToDate(leaveDate,"")
	s leaveTime=$p(^DHCICUArrange(icuaId),"^",45)
	i leaveTime'="" s leaveTime=##class(web.DHCClinicCom).ConvertToTime(leaveTime,"")
	s leaveDateTime=leaveDate ;_" "_leaveTime ;转归时间
	;s apacheQty=value=##class(web.DHCICUOrder).GetRecordValue(icuaId,"ApacheTotalScore",inDate,inTime,inDate+1,inTime,"First","","","","")
	s icuOId="",IsQuit=0,apacheQty=""
	s icucriId=##class(web.DHCICUCom).GetIcuriIdByCode("ApacheTotalScore")
	s ^TMPLYN(icuaId)=11
	s fromTime=$o(^DHCICUOrder(0,"RecordItem",icucriId,fromDate,icuaId,""),-1) //取最新一次
	.f  s icuOId=$o(^DHCICUOrder(0,"RecordItem",icucriId,fromDate,icuaId,fromTime,icuOId)) q:(icuOId="")!(IsQuit=1)  d
	.s apacheQty=$p($g(^DHCICUOrder(icuOId)),"^",11)
	.s IsQuit=1
	s tmpList(+curWardId,0_tBedCode,tEpisodeID_"."_+icuaId)=$lb(tStartDateTime,tEndDateTime,tRegNo,tPatName,tAdmLocDesc,tStatus,statusDesc,tBedCode,tDiagDesc,tWardDesc,icuaId,tEpisodeID,tPapmiMedicare,tIcuaType,tICUANormalStartDate,tICUANormalStartTime,patHeight,patWeight,tBodySquare,icuBedId,curWardId,tICUAResidentCtcpDr,tICUAResidentCtcpDesc,tICUAAttendingCtcpDr,tICUAAttendingCtcpDesc,mainNurse,mainNurseTwo,patLeaveCon,leaveDateTime,apacheQty,LimitedTreatment)
	q
}

/// w ##class(web.DHCICUArrange).GetEpisodeListByMedcareNo("000114")
ClassMethod GetEpisodeListByMedcareNo(medcareNo As %String) As %String
{
	set PatientID=##class(MA.IPMR.IO.OutService).GetPatientIDByMrNo(medcareNo,"IP",.ErrMsg)  ;##class(web.DHCWMRService).IGetPatientIDByMrNo(medcareNo)
	kill EpisodeList
	set result=..GetEpisodeListByPatientID(PatientID,.EpisodeList)
	quit result
}

ClassMethod GetEpisodeListByPatientID(PatientID As %String, ByRef EpisodeList As %String) As %String
{
	set result=""
	if (##class(User.PAPatMas).%ExistsId(PatientID))
	{
		set admType="",splitChar=","
		for
		{
			set admType=$o(^PAPERdr(PatientID,"ADM",admType))
			quit:(admType="")
			set EpisodeID=0
			for
			{
				set EpisodeID=$o(^PAPERdr(PatientID,"ADM",admType,EpisodeID))
				quit:(EpisodeID="")
				set:(result'="") result=result_splitChar
				continue:($data(EpisodeList(EpisodeID)))
				set result=result_EpisodeID	
				set EpisodeList(EpisodeID)=""
			}	
		}
	}
	quit result
}

ClassMethod FindICUArrangeNewFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindICUArrangeNewExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {				// fetch row
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindICUArrangeNewClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindICUArrangeNewExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// description:查询重症病人的状态
/// table:		DHC_ICU_Arrange
/// Adm:就诊号 Ward：病区ID
/// 返回0是正常 返回1是重症没有结束监护
/// w ##class(web.DHCICUArrange).GetICUStatus("70000330","143")
ClassMethod GetICUStatus(Adm, Ward) As %String
{
	q:Adm=""&&Ward="" 0
	s ICUAID="",WardID="",ICUAStatus="",Flag=""
	s ICUAID = $o(^DHCICUArrange(0,"Adm",Adm,ICUAID),-1)
	q:ICUAID="" 0
	s ICUBedNo = $p($g(^DHCICUArrange(ICUAID)),"^",4)
	s WardID= $p($g(ICUBedNo),"||",1)
	q:WardID'=Ward 0
	s ICUAStatus = $p(^DHCICUArrange(ICUAID),"^",18)
	i (ICUAStatus="T")||(ICUAStatus="F") d
		.s Flag=0
	e  d
		.s Flag=1	
	q Flag
}

}
