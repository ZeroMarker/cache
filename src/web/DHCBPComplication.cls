Import SQLUser

Class web.DHCBPComplication Extends %RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// d ##class(%ResultSet).RunQuery("web.DHCBPComplication","FindComplication","2019-03-21","2019-03-26","C879608","N","C879608","菲奥娜","","416")
Query FindComplication(fromDate As %String, toDate As %String, regNo As %String = "", needStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", ctLoc As %String = "", registerId As %String = "", ComplicationId As %String = "") As %Query(ROWSPEC = "Id,RegNo,PatName,Medicare,patSex,patAge,RegisterId,BPCOccurrence,BPCEventDescription,BPCTreatmentOfDisease,BPCDate,BPCStatus,BPCCreateCtcpDr,BPCCreateCtcpDesc,BPCCreateDate,BPCCreateTime,BPCUpdateCtcpDr,BPCUpdateCtcpDesc,BPCUpdateDate,BPCUpdateTime")
{
}

ClassMethod FindComplicationExecute(ByRef qHandle As %Binary, fromDate As %String, toDate As %String, regNo As %String = "", needStatus As %String = "", papmiMedicare As %String = "", papmiName As %String = "", ctLoc As %String = "", registerId As %String = "", ComplicationId As %String = "") As %Status
{
	//优先级：regNo,papmiMedicare,papmiName,ctlocId
  	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	i ComplicationId'="" d
		.s bpcId=ComplicationId
		.q:$$GetComplication()<0
		.d OutputRow
	i ComplicationId'="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s fromDate=##class(web.DHCANOPCom).ConvertToDateH(fromDate)
	s toDate=##class(web.DHCANOPCom).ConvertToDateH(toDate)	
	s EpisodeIDList=""
	i regNo'="" s EpisodeIDList=##class(web.DHCANOPCom).GetPatientEpisodeID(regNo,"")
	s papmiIdList=""
	s bpprIdList=""
	i regNo'="" s papmiIdList=$o(^PAPERi("PAPMI_PatNo",$$ALPHAUP^SSUTIL4(regNo),""))
	i papmiIdList="",papmiMedicare'="" d
		.s papmiMedicare=$$ALPHAUP^SSUTIL4(papmiMedicare)
		.s papmiIdList=$o(^PAPERi("Medicare1",papmiMedicare,""))
	i papmiIdList="",papmiName'="" d
		.s papmiName=$$ALPHAUP^SSUTIL4(papmiName)
		.s papmiId=""
		.f  s papmiId=$o(^PAPERi("PAPER_PatName",papmiName,papmiId)) q:papmiId=""  d
			..i papmiIdList'="" s papmiIdList=papmiIdList_"^"
			..s papmiIdList=papmiIdList_papmiId
	i (regNo'="")!(papmiMedicare'="")!(papmiName'="") s isLocQuery=0
	e  s isLocQuery=1
	s wardIdStr=##Class(web.DHCBPCom).GetLinkLocByLocId(ctLoc) //科室关联
	i papmiIdList'="" d
		.f i=1:1:$l(papmiIdList,"^") d
			..s papmiId=$p(papmiIdList,"^",i)
			..q:papmiId=""
			..q:'$d(^PAPER(papmiId,"PAT",1))
			..s bpprId=""
			..f  s bpprId=$o(^DHCBPPatRegister(0,"PaPatMas",papmiId,bpprId)) q:bpprId=""  d 			
				...;w bpprId_"/"_registerId,!
				...q:(registerId'="")&&(bpprId'=registerId)
				...;w registerId,!
				...s bpprPatLocationDr=$lg(^DHCBPPatRegister(bpprId),34)
				...q:(bpprPatLocationDr'="")&&(wardIdStr'="")&&(("^"_wardIdStr_"^")'[("^"_bpprPatLocationDr_"^"))
				...s bpcId=""
				...f  s bpcId=$o(^DHCBPComplication(0,"Register",bpprId,bpcId)) q:bpcId=""  d
					....q:$$GetComplication()<0
					....d OutputRow
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
GetComplication()
	q:bpcId="" -1
	s RegisterId=$lg(^DHCBPComplication(bpcId),1)	
	s papmiId=$lg(^DHCBPPatRegister(RegisterId),1)	
	s regNo=$p($g(^PAPER(papmiId,"PAT",1)),"^",1)
	s patName=$p($g(^PAPER(papmiId,"ALL")),"^",1)
	s papmiMedicare=$p($g(^PAPER(papmiId,"PAT",1)),"^",22)
	s patSex=$p($g(^CT("SEX",$p($g(^PAPER(papmiId,"ALL")),"^",7))),"^",2)
	s patBirth=$p($g(^PAPER(papmiId,"ALL")),"^",6)	//出生日期
	s patAge=##class(web.DHCClinicCom).CalAge(patBirth,+$h)
	;w bpcId,!    
	s BPCOccurrence=$lg(^DHCBPComplication(bpcId),2)
	s BPCEventDescription=$lg(^DHCBPComplication(bpcId),3)
	s BPCTreatmentOfDisease=$lg(^DHCBPComplication(bpcId),4)
	
	s BPCDate=$lg(^DHCBPComplication(bpcId),5)
	q:(BPCDate'="")&(BPCDate>toDate) -1
	q:(BPCDate'="")&(BPCDate<fromDate) -2
	i BPCDate'="" d
	.s BPCDate=##class(web.DHCClinicCom).ConvertToDate(BPCDate)
	
	s BPCStatus=$lg(^DHCBPComplication(bpcId),6)
	;w "BPCStatus:"_BPCStatus,!
	q:(needStatus'="")&&(needStatus'[BPCStatus) -3
	
	s BPCCreateCtcpDr=$lg(^DHCBPComplication(bpcId),7)
	s BPCCreateCtcpDesc=##class(web.DHCBPCom).GetNameById(BPCCreateCtcpDr)
	s BPCCreateDate=$lg(^DHCBPComplication(bpcId),8)
	i BPCCreateDate'="" d
	.s BPCCreateDate=##class(web.DHCClinicCom).ConvertToDate(BPCCreateDate)
	s BPCCreateTime=$lg(^DHCBPComplication(bpcId),9)
	i BPCCreateTime'="" d
	.s BPCCreateTime=##class(web.DHCClinicCom).ConvertToTime(BPCCreateTime)
	
	
	s BPCUpdateCtcpDr=$lg(^DHCBPComplication(bpcId),10)
	s BPCUpdateCtcpDesc=##class(web.DHCBPCom).GetNameById(BPCUpdateCtcpDr)
	s BPCUpdateDate=$lg(^DHCBPComplication(bpcId),11)
	i BPCUpdateDate'="" d
	.s BPCUpdateDate=##class(web.DHCClinicCom).ConvertToDate(BPCUpdateDate)
	s BPCUpdateTime=$lg(^DHCBPComplication(bpcId),12)
	i BPCUpdateTime'="" d
	.s BPCUpdateTime=##class(web.DHCClinicCom).ConvertToTime(BPCUpdateTime)
	
	w bpcId,!
	q 0
OutputRow
	set Data=$lb(bpcId,regNo,patName,papmiMedicare,patSex,patAge,RegisterId,BPCOccurrence,BPCEventDescription,BPCTreatmentOfDisease,BPCDate,BPCStatus,BPCCreateCtcpDr,BPCCreateCtcpDesc,BPCCreateDate,BPCCreateTime,BPCUpdateCtcpDr,BPCUpdateCtcpDesc,BPCUpdateDate,BPCUpdateTime)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod FindComplicationFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindComplicationExecute ]
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

ClassMethod FindComplicationClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindComplicationExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// w ##class(web.DHCBPComplication).AddComplication("416$c(3)2019$c(3)3$c(3)1$c(3)2$c(3)3$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)正常$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)$c(3)52$c(3)$c(3)$c(3)N$c(3)")
ClassMethod AddComplication(Complication As %String) As %String
{
	q:($p(Complication,$c(3),1)="") "未登记的病人不能进行严重并发症记录"
	s ComplicationObj=""        
    s ComplicationObj=##class(User.DHCBPComplication).%New()	
    s ComplicationObj.BPCPatRegisterDr=##class(User.DHCBPPatRegister).%OpenId($p(Complication,$c(3),1))
	s ComplicationObj.BPCOccurrence=$p(Complication,$c(3),2)
	s ComplicationObj.BPCEventDescription=$p(Complication,$c(3),3)
	s ComplicationObj.BPCTreatmentOfDisease=$p(Complication,$c(3),4)	
	s bpCDate=$p(Complication,$c(3),5)
    s bpCDate=##class(DHCANOPCom).ConvertToDateH(bpCDate)
	s ComplicationObj.BPCDate=bpCDate	
	s ComplicationObj.BPCStatus=$p(Complication,$c(3),6)	
	s ComplicationObj.BPCCreateCtcpDr=$p(Complication,$c(3),7)
	s ComplicationObj.BPCCreateDate=+$h
	s ComplicationObj.BPCCreateTime=$p($h,",",2)	
	
	d ComplicationObj.%Save()
	s result=ComplicationObj.%Id()
	d ComplicationObj.%Close()
	q result
}

/// w ##class(web.DHCBPComplication).StopComplication("4$c(3)D$c(3)52")
ClassMethod StopComplication(Complication As %String) As %String
{
	q:Complication="" "未选中严重并发症"
	s result=0
	s rowId=$p(Complication,$c(3),1)
	q:rowId="" 
	s ComplicationObj=""
    s ComplicationObj=##class(User.DHCBPComplication).%OpenId(rowId) 	
	s ComplicationObj.BPCStatus=$p(Complication,$c(3),2)
	s ComplicationObj.BPCUpdateCtcpDr=$p(Complication,$c(3),3)
	s ComplicationObj.BPCUpdateDate=+$h
	s ComplicationObj.BPCUpdateTime=$p($h,",",2)
	d ComplicationObj.%Save()
	s result=ComplicationObj.%Id()
	d ComplicationObj.%Close()
	q result
}

}
