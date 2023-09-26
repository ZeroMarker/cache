Class DHCDoc.DHCApp.LabReportSet Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

/// 新增修改
ClassMethod Insert(RowID, Type, ReportFullFile, ARCIMDR, ARCIMCatDR, InfoStr, HospID)
{
	s ^tempqujian("LabReportSet")=$lb(RowID, Type, ReportFullFile, ARCIMDR, ARCIMCatDR, InfoStr, HospID)
	s ToReportNo=$P(InfoStr,$C(1),1)
	s BeforeReportNo=$P(InfoStr,$C(1),2)
	s BeforeReportNoSplit=$P(InfoStr,$C(1),3)
	s ToRegistNo=$P(InfoStr,$C(1),4)
	s BeforeRegistNo=$P(InfoStr,$C(1),5)
	s ToUserCode=$P(InfoStr,$C(1),6)
	s BeforeUserCode=$P(InfoStr,$C(1),7)
	s BeforeOther=$P(InfoStr,$C(1),8)
	if (RowID=""){
		&SQL(insert into SQLUser.DHCDocAppLabReportSet 
		(Type,ReportFullFile,ARCIMDR,ARCIMCatDR,ToReportNo,BeforeReportNo,BeforeReportNoSplit,ToRegistNo,BeforeRegistNo,ToUserCode,BeforeUserCode,BeforeOther,HospID
		) Values(:Type,:ReportFullFile,:ARCIMDR,:ARCIMCatDR,:ToReportNo,:BeforeReportNo,:BeforeReportNoSplit,:ToRegistNo,:BeforeRegistNo,:ToUserCode,:BeforeUserCode,:BeforeOther,:HospID))
		}else{
		&SQL(Update SQLUser.DHCDocAppLabReportSet set Type=:Type,ReportFullFile=:ReportFullFile, 
		ARCIMDR=:ARCIMDR,ARCIMCatDR=:ARCIMCatDR,ToReportNo=:ToReportNo,BeforeReportNo=:BeforeReportNo,BeforeReportNoSplit=:BeforeReportNoSplit,
		ToRegistNo=:ToRegistNo,BeforeRegistNo=:BeforeRegistNo,ToUserCode=:ToUserCode,BeforeUserCode=:BeforeUserCode,
		BeforeOther=:BeforeOther,HospID=:HospID where RowID=:RowID)
		}
	b ;0934
	s rtn=SQLCODE
	q rtn
}

/// 删除
ClassMethod Delect(RowID)
{
	q:RowID="" ""
	&SQL(DELETE SQLUser.DHCDocAppLabReportSet where RowID=:RowID)
	s rtn=SQLCODE
	q rtn
}

/// 查询
/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCApp.LabReportSet","GetLabReportSetList",2)
Query GetLabReportSetList(HospId As %String = "") As websys.Query(ROWSPEC = "RowID:%String,ReportFullFile:%String,ARCIMDR:%String,ARCIMCatDR:%String,Desc:%String,ToReportNo:%String,BeforeReportNo:%String,BeforeReportNoSplit:%String,ToRegistNo:%String,BeforeRegistNo:%String,ToUserCode:%String,BeforeUserCode:%String,BeforeOther:%String,Type:%String")
{
}

ClassMethod GetLabReportSetListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	s RowID=0
	for {
		s RowID=$O(^DHCDocAppLabReportSet(RowID))
		q:RowID=""
		s Type=$P(^DHCDocAppLabReportSet(RowID),"^",1)
		s hospid=$P(^DHCDocAppLabReportSet(RowID),"^",13)
		continue:HospId'=hospid
		s ReportFullFile=$P(^DHCDocAppLabReportSet(RowID),"^",2)
		s ARCIMDR=$P(^DHCDocAppLabReportSet(RowID),"^",3)
		s ARCIMCatDR=$P(^DHCDocAppLabReportSet(RowID),"^",4)
		s Desc=""
		if (ARCIMDR'=""){
			s Desc=$p(^ARCIM(+ARCIMDR,$p(ARCIMDR,"||",2),1),"^",2)
			}
		if (ARCIMCatDR'=""){
			s Desc=$P(^ARC("IC",ARCIMCatDR),"^",2)
			}
		s ToReportNo=$P(^DHCDocAppLabReportSet(RowID),"^",5)
		s BeforeReportNo=$P(^DHCDocAppLabReportSet(RowID),"^",6)
		s BeforeReportNoSplit=$P(^DHCDocAppLabReportSet(RowID),"^",7)
		s ToRegistNo=$P(^DHCDocAppLabReportSet(RowID),"^",8)
		s BeforeRegistNo=$P(^DHCDocAppLabReportSet(RowID),"^",9)
		s ToUserCode=$P(^DHCDocAppLabReportSet(RowID),"^",10)
		s BeforeUserCode=$P(^DHCDocAppLabReportSet(RowID),"^",11)
		s BeforeOther=$P(^DHCDocAppLabReportSet(RowID),"^",12)
		Set Data=$lb(RowID,ReportFullFile,ARCIMDR,ARCIMCatDR,Desc,ToReportNo,BeforeReportNo,BeforeReportNoSplit,ToRegistNo,BeforeRegistNo,ToUserCode,BeforeUserCode,BeforeOther,Type)
		Set ^CacheTemp(repid,ind)=Data
		Set ind=ind+1
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod GetUrl(Arcim, HospId, VisitNumberReportDR, PatientID, UserID)
{
	s ^tempqujian("GetUrl")=$lb(Arcim, HospId, VisitNumberReportDR, PatientID, UserID)
	s DefaulUrl=""
	s ARCImUrl=""
	s ARCCatUrl=""
	s ItemCatRowid=$p($g(^ARCIM(+Arcim,$p(Arcim,"||",2),1)),"^",10)
	s RowID=0
	for {
		s RowID=$O(^DHCDocAppLabReportSet(RowID))
		q:RowID=""
		s Type=$P(^DHCDocAppLabReportSet(RowID),"^",1)
		s hospid=$P(^DHCDocAppLabReportSet(RowID),"^",13)
		continue:HospId'=hospid
		s ReportFullFile=$P(^DHCDocAppLabReportSet(RowID),"^",2)
		s ARCIMDR=$P(^DHCDocAppLabReportSet(RowID),"^",3)
		s ARCIMCatDR=$P(^DHCDocAppLabReportSet(RowID),"^",4)
		s ToReportNo=$P(^DHCDocAppLabReportSet(RowID),"^",5)
		s BeforeReportNo=$P(^DHCDocAppLabReportSet(RowID),"^",6)
		s BeforeReportNoSplit=$P(^DHCDocAppLabReportSet(RowID),"^",7)
		s ToRegistNo=$P(^DHCDocAppLabReportSet(RowID),"^",8)
		s BeforeRegistNo=$P(^DHCDocAppLabReportSet(RowID),"^",9)
		s ToUserCode=$P(^DHCDocAppLabReportSet(RowID),"^",10)
		s BeforeUserCode=$P(^DHCDocAppLabReportSet(RowID),"^",11)
		s BeforeOther=$P(^DHCDocAppLabReportSet(RowID),"^",12)
		s Url=ReportFullFile
		if (ToReportNo="Y"){
			s Url=Url_BeforeReportNo_VisitNumberReportDR
			}
		if (ToRegistNo="Y"){
			s PatientNo=$p($g(^PAPER(PatientID,"PAT",1)),"^",1)
			s Url=Url_BeforeRegistNo_PatientNo
			}
		if (ToUserCode="Y"){
			s UserCode=$p(^SSU("SSUSR",UserID),"^",1)
			s Url=Url_BeforeUserCode_UserCode
			}
		s Url=Url_BeforeOther
		if (Type="默认"){
			s DefaulUrl=Url
			}
		if (ARCIMDR=Arcim){
			if (ReportFullFile="") s ARCImUrl="默认"
			else  s ARCImUrl=Url
			}
		if (ItemCatRowid=ARCIMCatDR) {
			if (ReportFullFile="") s ARCCatUrl="默认"
			else  s ARCCatUrl=Url
		}
			
	}
	b ;093
	if (ARCImUrl'=""){
		if ARCImUrl="默认" q DefaulUrl
		else  q ARCImUrl
		}
	if (ARCCatUrl'=""){
		if ARCCatUrl="默认" q DefaulUrl
		else  q ARCCatUrl
		}	
	q ""
}

/// 根据医嘱项查询
Query FindItem(Alias As %String, Type As %String, HospId As %String = "") As websys.Query(ROWSPEC = "ArcimRowID:%String,ArcimDesc:%String")
{
}

ClassMethod FindItemExecute(ByRef qHandle As %Binary, Alias As %String, Type As %String, HospId As %String = "") As %Status
{
	Set repid=$I(^CacheTemp)	
	Set ind=1
	if ((Alias="")&&(Type="医嘱项")){
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
	}
	if (Type="默认"){
		Set qHandle=$lb(0,repid,0)
	    Quit $$$OK
		}
	s GroupID=%session.Data("LOGON.GROUPID")
	s UserID=%session.Data("LOGON.USERID")
	s LocId=%session.Get("LOGON.CTLOCID")
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	if (Type="医嘱项"){
		Set rs2=##Class(%ResultSet).%New("DHCDoc.DHCDocConfig.ArcItemConfig:FindAllItem")
		d rs2.Execute(Alias,"","","","","","",HospId)
		while(rs2.Next()){
			s ArcimID = rs2.GetData(1)
			continue:ArcimID=""
			s ArcimDesc=rs2.GetData(2)
			d OutputRowFindItem
		}
	}
	if (Type="子类"){
		s ArcimID="0"
		for {
			s ArcimID=$O(^ARC("IC",ArcimID))
			q:ArcimID=""
			s ArcimDesc=$P(^ARC("IC",ArcimID),"^",2)
			continue:((Alias'="")&&(ArcimDesc'[Alias))
			d OutputRowFindItem
			}	
		}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFindItem
	Set Data=$lb(ArcimID,ArcimDesc)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	Quit
}

}
