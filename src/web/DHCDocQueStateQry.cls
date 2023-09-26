Class web.DHCDocQueStateQry Extends DHCDoc.Util.RegisteredObject
{

/// d ##class(%ResultSet).RunQuery("web.DHCDocQueStateQry","QueryUpState","","","","")
Query QueryUpState(PatNo As %String, StartDate As %String, EndDate As %String, State As %String) As %Query(ROWSPEC = "Tind,TPatID,TPatName,TAdmDate,TAdmDep,TAdmDocCode,TAdmDepDesc,Tstatus,TQSDate,TQSTime,TQSStatus,TQSUpUser,OPTransAdmFlag")
{
}

ClassMethod QueryUpStateClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryUpStateExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod QueryUpStateExecute(ByRef qHandle As %Binary, PatNo As %String, StartDate As %String, EndDate As %String, State As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	s LogonHospDr=%session.Get("LOGON.HOSPID")
 	s ^tmpnk("QueryUpStateExecute")=PatNo_"^"_StartDate_"^"_EndDate_"^"_State
 	i StartDate'="" s StartDate=..%ZDH(StartDate)
 	i EndDate'="" s EndDate=..%ZDH(EndDate)
 	/*i StartDate["-" s StartDate=$zdh(StartDate,3)
 	i StartDate["/" s StartDate=$zdh(StartDate,4)
 	i EndDate["-" s EndDate=$zdh(EndDate,3)
 	i EndDate["/" s EndDate=$zdh(EndDate,4)*/
 	i StartDate="" s StartDate=..%SysDate()
 	i EndDate="" s EndDate=..%SysDate()
 	s (PatName,AdmDep,AdmDocCode,AdmDepDesc,status,QSDate,QSTime,QSStatus,QSUpUser,AdmDate)="" 
 	s PatRowID=""
 	if (PatNo'=""){
		s PatRowID=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
		if (PatRowID=""){
			Set qHandle=$lb(0,repid,0)
	        Quit $$$OK
		}
	}
	s Statedesc=""
	if (State'="") {
		s Statedesc=$List(^User.DHCPerStateD(State),6)
		if (Statedesc="") {
			s Statedesc=$List(^User.DHCPerStateD(State),4)
		}
	}
 	f FindDate=StartDate:1:EndDate d
 	.s QueRowId=""
 	.f  s QueRowId=$o(^User.DHCQueueI("QueDateIndex",FindDate,QueRowId)) q:QueRowId=""  d
 	..s AdmId=$List(^User.DHCQueueD(QueRowId),11)
 	..s myPatRowID=$p(^PAADM(AdmId),"^",1)
    ..q:(myPatRowID="")
    ..s PAADMType=$p(^PAADM(AdmId),"^",2)
    ..q:(myPatRowID'=PatRowID)&&(PatRowID'="")
	..s myFindPatNo=$P(^PAPER(myPatRowID,"PAT",1),"^",2)
    ..Q:myFindPatNo=""
	..s PatName=$p(^PAPER(myPatRowID,"ALL"),"^",1)
	..s AdmDep=$List(^User.DHCQueueD(QueRowId),4)
	..Q:AdmDep=""
	..s LocHospDr=$p(^CTLOC(AdmDep),"^",22)
	..Q:(LocHospDr'=LogonHospDr)
	..s AdmDate=$p(^PAADM(AdmId),"^",6)
	..s:AdmDate'="" AdmDate=..%ZD(AdmDate) //$zd(AdmDate,3)
	..s AdmTime=$p(^PAADM(AdmId),"^",7)
	..s:AdmTime'="" AdmTime=..%ZT(AdmTime,4)
	..s AdmDate=AdmDate_" "_AdmTime
	..s AdmDepDesc=$p(^CTLOC(AdmDep),"^",2)
 	..s:AdmDepDesc["-" AdmDepDesc=$p(AdmDepDesc,"-",2)
	..s AdmDocCodeDR=$List(^User.DHCQueueD(QueRowId),5)
	..i AdmDocCodeDR="" s AdmDocCodeDR=$List(^User.DHCQueueD(QueRowId),8)
	..s AdmDocCode=""
	..i AdmDocCodeDR'="" s AdmDocCode=$P(^CTPCP(AdmDocCodeDR,1),"^",2)    
 	..s QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	..q:QueStateDr=""
	..s status=$List(^User.DHCPerStateD(QueStateDr),6)
	..i status="" s status=$List(^User.DHCPerStateD(QueStateDr),4)
	..s QueStaID=0
	..f  s QueStaID=$o(^DHCQueueStatus(QueRowId,QueStaID)) q:QueStaID=""  d
	...s QSDate=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",1)
	...//q:(QSDate>EndDate)||(QSDate<StartDate)
	...s:QSDate'="" QSDate=..%ZD(QSDate) //$zd(QSDate,3)
	...s QSTime=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",2)
	...s:QSTime'="" QSTime=..%ZT(QSTime,1)
	...S QSDocDr=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",3)
	...s QSStatus=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",4)
	...s:QSStatus'="" QSStatus=$List(^User.DHCPerStateD(QSStatus),6)
	...i status="" s status=$List(^User.DHCPerStateD(QueStateDr),4)
	...if (PAADMType="E")&&(QSDocDr'="") s QSStatus="到达"
	...i (QSStatus="等候") d
	....s AdmDocCodeDR=$List(^User.DHCQueueD(QueRowId),8)
	....s AdmDocCode=$P(^CTPCP(AdmDocCodeDR,1),"^",2)   
	...q:(Statedesc'="")&&(QSStatus'[Statedesc)
	...s QSUpUserID=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",5)
	...s:QSUpUserID'="" QSUpUser=$p(^SSU("SSUSR",QSUpUserID),"^",2)
	...//判断此队列记录是否由转诊记录
	...s TransRowID=$o(^DHCOPTransAdmI("Adm",AdmId,""))
	...s OPTransAdmFlag=""
	...i TransRowID'="" s OPTransAdmFlag="Y" 
	...d OutputRow

 	
 	
	/*if (PatNo'=""){
		s PatRowID=$o(^PAPERi("PAPMI_PatNo",PatNo,""))
	    Q:PatRowID=""
	    s PAADMTypeStr="O^E"
		f FindDate=StartDate:1:EndDate d
		.f i=1:1:$l(PAADMTypeStr,"^") d
		..s AdmType=$p(PAADMTypeStr,"^",i)
		..s myAdmId=""
		..f  s myAdmId=$o(^PAPERdr(PatRowID,"ADM",AdmType,myAdmId)) q:myAdmId=""  d
		...d FindQueState(myAdmId)
	}else{
		/*f FindDate=StartDate:1:EndDate d
		.s FindTime=""
		.f  s FindTime=$o(^PAADMi("PAADM_DateTime",FindDate,FindTime)) q:FindTime=""  d
		..s myAdmId=""
		..f  s myAdmId=$o(^PAADMi("PAADM_DateTime",FindDate,FindTime,myAdmId)) q:myAdmId=""  d
		...s myPatRowID=$p(^PAADM(myAdmId),"^",1)
		...s myAdmType=$p(^PAADM(myAdmId),"^",2)
		...q:myAdmType="I"
		...q:myPatRowID=""
		...s myFindPatNo=$P(^PAPER(myPatRowID,"PAT",1),"^",2)
		...Q:myFindPatNo=""
		...d FindQueState(myFindPatNo)
		f FindDate=StartDate:1:EndDate d
		.s QSParRef=""
		.f  s QSParRef=$o(^DHCQueueStatusi("Date",FindDate,QSParRef)) q:QSParRef=""  d
		..s myAdmId=$list(^User.DHCQueueD(QSParRef),11)
		..s myAdmType=$p(^PAADM(myAdmId),"^",2)
		..q:myAdmType="I"
		..d FindQueState(myAdmId)
	}*/
    		  	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow
	set Data=$lb(ind,myFindPatNo,PatName,AdmDate,AdmDep,AdmDocCode,AdmDepDesc,status,QSDate,QSTime,QSStatus,QSUpUser,OPTransAdmFlag)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
FindQueState(AdmId)
	s (PatName,AdmDep,AdmDocCode,AdmDepDesc,status,QSDate,QSTime,QSStatus,QSUpUser,AdmDate)="" 
    s myPatRowID=$p(^PAADM(AdmId),"^",1)
    q:myPatRowID=""
	s myFindPatNo=$P(^PAPER(myPatRowID,"PAT",1),"^",2)
    Q:myFindPatNo=""
	s PatName=$p(^PAPER(myPatRowID,"ALL"),"^",1)
	s QueRowId=$o(^User.DHCQueueI("QuePaadmDrIndex",AdmId,""))
	Q:QueRowId=""
	s AdmDep=$p(^PAADM(AdmId),"^",4)
	s AdmDate=$p(^PAADM(AdmId),"^",6)
	s:AdmDate'="" AdmDate=$zd(AdmDate,3)
	s AdmTime=$p(^PAADM(AdmId),"^",7)
	s:AdmTime'="" AdmTime=..%ZT(AdmTime,4)
	s AdmDate=AdmDate_" "_AdmTime
 	s AdmDepDesc=$p(^CTLOC(AdmDep),"^",2)
 	s:AdmDepDesc["-" AdmDepDesc=$p(AdmDepDesc,"-",2)
 	s AdmDocCode=""
 	s AdmDocCodeDR=$p(^PAADM(AdmId),"^",9)
    i AdmDocCodeDR'="" s AdmDocCode=$P(^CTPCP(AdmDocCodeDR,1),"^",2)
 	s QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	q:QueStateDr=""
	s status=$List(^User.DHCPerStateD(QueStateDr),4)
	s QueStaID=0
	f  s QueStaID=$o(^DHCQueueStatus(QueRowId,QueStaID)) q:QueStaID=""  d
	.s QSDate=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",1)
	.s:QSDate'="" QSDate=$zd(QSDate,3)
	.s QSTime=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",2)
	.s:QSTime'="" QSTime=..%ZT(QSTime,1)
	.s QSStatus=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",4)
	.s:QSStatus'="" QSStatus=$List(^User.DHCPerStateD(QSStatus),4)
	.q:(Statedesc'="")&&(QSStatus'[Statedesc)
	.s QSUpUserID=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",5)
	.s:QSUpUserID'="" QSUpUser=$p(^SSU("SSUSR",QSUpUserID),"^",2)
	.//判断此队列记录是否由转诊记录
	.s TransRowID=$o(^DHCOPTransAdmI("Adm",AdmId,""))
	.s OPTransAdmFlag=""
	.i TransRowID'="" s OPTransAdmFlag="Y" 
	.d OutputRow
	/*s FindPatNo=$zcvt(FindPatNo,"U")
	s PatRowID=$o(^PAPERi("PAPMI_PatNo",FindPatNo,""))
	Q:PatRowID=""
	s PatName=$p(^PAPER(PatRowID,"ALL"),"^",1)
	s QueRowId=0
	f  s QueRowId=$o(^User.DHCQueueI("QuePersonIdIndex"," "_FindPatNo,QueRowId)) q:QueRowId=""  d
	.s QueExaBorDR=$List(^User.DHCQueueD(QueRowId),6)
	.s:QueExaBorDR'="" QueExaBor=$List(^User.DHCExaBoroughD(QueExaBorDR),5)
	.s AdmId=$List(^User.DHCQueueD(QueRowId),11)
	.s AdmDep=$p(^PAADM(AdmId),"^",4)
	.s AdmDate=$p(^PAADM(AdmId),"^",6)
	.q:(StartDate'="")&&(AdmDate<StartDate)
	.q:(EndDate'="")&&(AdmDate>EndDate)
	.s:AdmDate'="" AdmDate=$zd(AdmDate,3)
	.s AdmTime=$p(^PAADM(AdmId),"^",7)
	.s:AdmTime'="" AdmTime=..%ZT(AdmTime,4)
	.s AdmDate=AdmDate_" "_AdmTime
 	.s AdmDepDesc=$p(^CTLOC(AdmDep),"^",2)
 	.s:AdmDepDesc["-" AdmDepDesc=$p(AdmDepDesc,"-",2)
 	.s AdmDocCode=""
 	.s AdmDocCodeDR=$p(^PAADM(AdmId),"^",9)
 	.i AdmDocCodeDR'="" s AdmDocCode=$P(^CTPCP(AdmDocCodeDR,1),"^",2)
 	.s QueStateDr=$List(^User.DHCQueueD(QueRowId),14)
	.q:QueStateDr=""
	.s status=$List(^User.DHCPerStateD(QueStateDr),4)
	.s QueStaID=0
	.f  s QueStaID=$o(^DHCQueueStatus(QueRowId,QueStaID)) q:QueStaID=""  d
	..s QSDate=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",1)
	..s:QSDate'="" QSDate=$zd(QSDate,3)
	..s QSTime=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",2)
	..s:QSTime'="" QSTime=..%ZT(QSTime,1)
	..s QSStatus=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",4)
	..s:QSStatus'="" QSStatus=$List(^User.DHCPerStateD(QSStatus),4)
	..q:(State'="")&&(QSStatus'[State)
	..s QSUpUserID=$p(^DHCQueueStatus(QueRowId,QueStaID),"^",5)
	..s:QSUpUserID'="" QSUpUser=$p(^SSU("SSUSR",QSUpUserID),"^",2)
	..//判断此队列记录是否由转诊记录
	..s TransRowID=$o(^DHCOPTransAdmI("Adm",AdmId,""))
	..s OPTransAdmFlag=""
	..i TransRowID'="" s OPTransAdmFlag="Y" 
	..d OutputRow*/
	q
}

ClassMethod QueryUpStateFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryUpStateExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
	 Set repid=$LIST(qHandle,2)
	 Set ind=$LIST(qHandle,3)
	 Set ind=$o(^CacheTemp(repid,ind))
	 If ind="" 
	 {	// if there are no more rows, finish fetching
	 Set AtEnd=1
	 Set Row=""
	 }
	 Else      
	 {				// fetch row
	 Set Row=^CacheTemp(repid,ind)
	 }
	 // Save QHandle
	 s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindPatByID(PAPMINo)
{
 s RtnStr=""
 q:PAPMINo="" ""
 s PatName=""
 s PAPMI=$o(^PAPERi("PAPMI_PatNo",PAPMINo,""))
 i (PAPMI'="") s PatName=$p(^PAPER(PAPMI,"ALL"),"^",1) 
 s RtnStr=PAPMI_"^"_PatName
 q RtnStr
}

ClassMethod GetDHCPerStateJson() As %String
{
	s JsonObj=[]
	s rset=##Class(%ResultSet).%New("web.DHCExaBorough.UFindDHCPerState")
	If rset.QueryIsValid() {
		Set Status=rset.Execute()
		If 'Status Quit
		Set columns = rset.GetColumnCount()
		if (columns=0) Quit
		While (rset.Next()) {
			//s liquidOut=rset.GetDataByName("OBSValue")
			s name=rset.GetDataByName("Tname")
			s showname=rset.GetDataByName("Tshowname")
			if (showname="") s showname=name
			s JsonData={}
			do JsonData.%Set("id",rset.GetDataByName("Tid"))
			do JsonData.%Set("text",showname)
			do JsonObj.%Push(JsonData,"")
		}
	}	
	s JsonInfo=""
	s obj=##class(%Stream.GlobalCharacter).%New()
	do JsonObj.%ToJSON(obj)
	While 'obj.AtEnd { 
		s JsonInfo=JsonInfo_obj.ReadLine(,.sc,.eol)
	}
	q JsonInfo
}

}
