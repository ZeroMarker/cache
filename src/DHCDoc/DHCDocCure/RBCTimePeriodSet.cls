Class DHCDoc.DHCDocCure.RBCTimePeriodSet Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query QueryBookTime(HospID As %String = "", SGRowID As %String = "") As %Query(ROWSPEC = "Rowid:%String,Code:%String,Desc:%String,StartTime:%String,EndTime:%String,EndChargeTime:%String,NotAvailFlag:%String,EndAppointTime:%String,HasConfigFlag:%String")
{
}

/// d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocCure.RBCTimePeriodSet","QueryBookTime",2,75)
ClassMethod QueryBookTimeExecute(ByRef qHandle As %Binary, HospID As %String = "", SGRowID As %String = "") As %Status
{
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCureRBCTimePeriodSet",HospID,+$H)
	s TimeRowid=0  
	for{
		s TimeRowid=$o(^DHCDocCureRBCTimePeriodSet(TimeRowid)) q:TimeRowid=""
		s HospShowDataFlag=##class(DHCDoc.Common.Hospital).GetHospShowDataFlag("DHC_DocCureRBCTimePeriodSet",TimeRowid,HospID)
		continue:(HospShowDataFlag="N")
		d OutTime 
	}
	Quit $$$OK 
OutTime
	s TimeCode=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",1)
	s TimeDesc=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",2)
	s StartTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",3)
	s:StartTime'="" StartTime=$zt(StartTime)
	s EndTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",4)
	s:EndTime'="" EndTime=$zt(EndTime)
	s EndChargeTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",5)
	s:EndChargeTime'="" EndChargeTime=$zt(EndChargeTime)
	s NotAvailFlag=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",6)
	s EndAppointTime=$p(^DHCDocCureRBCTimePeriodSet(TimeRowid),"^",7)
	s:EndAppointTime'="" EndAppointTime=$zt(EndAppointTime)
	s HasConfigFlag="N"
	if SGRowID'=""{
		s HasConfigFlag=..CheckHasConfigFlag(TimeRowid,SGRowID,HospID)
	}
	set Data=$lb(TimeRowid,TimeCode,TimeDesc,StartTime,EndTime,EndChargeTime,NotAvailFlag,EndAppointTime,HasConfigFlag)
	set qHandle($I(ind))=Data
	quit
}

ClassMethod QueryBookTimeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryBookTimeExecute ]
{
	s ind=$O(qHandle(""))
	if ind{
		s Row=qHandle(ind)
		k qHandle(ind)
	}else{
		s AtEnd=1
	}
	Quit $$$OK
}

/// 通过ID获取时间段设置数据
ClassMethod GetCureRBCTimePeriodSetById(Id As %String) As %String
{
	q:Id="" ""
	s Data=$G(^DHCDocCureRBCTimePeriodSet(Id))
	if $p(Data,"^",3)'="" s $p(Data,"^",3)=$zt($p(Data,"^",3),1)
	if $p(Data,"^",4)'="" s $p(Data,"^",4)=$zt($p(Data,"^",4),1)
	if $p(Data,"^",5)'="" s $p(Data,"^",5)=$zt($p(Data,"^",5),1)
	if $p(Data,"^",7)'="" s $p(Data,"^",7)=$zt($p(Data,"^",7),1)
	q Data
}

/// 保存时间段设置数据
/// w ##class(DHCDoc.DHCDocCure.RBCTimePeriodSet).SaveCureRBCTimePeriodSet("^01^早上^08:30:00^08:30:00^^")
ClassMethod SaveCureRBCTimePeriodSet(value As %String, HospID As %String = "") As %String
{
	s ^TMP("SaveCureRBCTimePeriodSet")=value
	Q:value="" -1
	s HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	Set DDCTSROWID=$P(value,"^")
	Set DDCTSCode=$P(value,"^",2)
	Set DDCTSDesc=$P(value,"^",3)
	Set DDCTSStartTime=$P(value,"^",4)
	Set DDCTSEndTime=$P(value,"^",5)
	Set DDCTSEndAppointTime=$P(value,"^",6)
	Set DDCTSNotAvailFlag=$P(value,"^",7)
	Set DDCTSEndChargeTime=""
	Q:DDCTSCode="" 100
	S RowID=$O(^DHCDocCureRBCTimePeriodSet(0,"Code",DDCTSCode,""))
	Q:(DDCTSROWID="")&&(RowID'="") 101
	Q:(DDCTSROWID'="")&&(RowID'="")&&(RowID'=DDCTSROWID) 101
	s:DDCTSStartTime'="" DDCTSStartTime=$zth(DDCTSStartTime,1)
	s:DDCTSEndTime'="" DDCTSEndTime=$zth(DDCTSEndTime,1)
	s:DDCTSEndChargeTime'="" DDCTSEndChargeTime=$zth(DDCTSEndChargeTime,1)
	s:DDCTSEndAppointTime'="" DDCTSEndAppointTime=$zth(DDCTSEndAppointTime,1)
	K PLIST
	s PLIST(2)=DDCTSCode
	s PLIST(3)=DDCTSDesc
	s PLIST(4)=DDCTSStartTime
	s PLIST(5)=DDCTSEndTime
	s PLIST(6)=DDCTSEndChargeTime
	s PLIST(7)=DDCTSNotAvailFlag
	s PLIST(8)=DDCTSEndAppointTime
	if DDCTSROWID="" 
	{	
	 	&sql(insert into SQLUser.DHC_DocCureRBCTimePeriodSet values :PLIST())	
	 	i 'SQLCODE {
		 	s HospID=##class(DHCDoc.Common.Hospital).GetDefHospIdByTableName("DHC_DocCureRBCTimePeriodSet",HospID,+$H)
		 	s RowID=$p(%ROWID,$c(1))
		 	d ##class(DHCDoc.Common.Hospital).SaveHOSP("DHC_DocCureRBCTimePeriodSet",RowID,HospID)
	 	}
	}else{
		&sql(update SQLUser.DHC_DocCureRBCTimePeriodSet values :PLIST() where DDCTS_Rowid=:DDCTSROWID ) 
	}
	q SQLCODE
}

ClassMethod DeleteCureRBCTimePeriodSet(Rowid As %String) As %String
{
	 q:Rowid="" 100
	 &sql(delete from SQLUser.DHC_DocCureRBCTimePeriodSet where DDCTS_Rowid=:Rowid)
	 q SQLCODE
}

ClassMethod SaveTPLinkSG(DataList As %String, HospID As %String) As %String
{
	s TimePeriodId=$p(DataList,$c(1),1)
	s ServiceGroupIdStr=$p(DataList,$c(1),2)
	q:TimePeriodId="" "-100"
	s ret=0
	Ts
	&sql(delete from SQLUser.DHC_DocCureTimeLinkGroup where DDCTLG_TimePeriod_Dr=:TimePeriodId and DDCTLG_Hospital_DR=:HospID)
	s ret=SQLCODE
	s:ret=100 ret=0
	if ret{
		Tro
		s ret="-101"
	}else{
		s len=$l(ServiceGroupIdStr,"^")
		for loop=1:1:len{
			s ServiceGroupId=$p(ServiceGroupIdStr,"^",loop)
			continue:ServiceGroupId=""
			k PLIST
			s PLIST(2)=TimePeriodId
			s PLIST(3)=ServiceGroupId	
			s PLIST(4)=HospID
			&sql(insert into SQLUser.DHC_DocCureTimeLinkGroup values :PLIST())
			if SQLCODE{
				Tro
				s ret="-102"
				Q
			}
		}
	}
	if ret=0{
		Tc	
	}
	Q ret
}

ClassMethod SaveSGLinkTP(SGRowID As %String, DataList As %String, HospID As %String) As %String
{
	q:SGRowID="" "-100"
	s ret=0
	Ts
	&sql(delete from SQLUser.DHC_DocCureTimeLinkGroup where DDCTLG_ServiceGroup_Dr=:SGRowID and DDCTLG_Hospital_DR=:HospID)
	s ret=SQLCODE
	s:ret=100 ret=0
	if ret{
		Tro
		s ret="-101"
	}else{
		s len=$l(DataList,"^")
		for loop=1:1:len{
			s TimePeriodId=$p(DataList,"^",loop)
			continue:TimePeriodId=""
			k PLIST
			s PLIST(2)=TimePeriodId
			s PLIST(3)=SGRowID	
			s PLIST(4)=HospID
			&sql(insert into SQLUser.DHC_DocCureTimeLinkGroup values :PLIST())
			if SQLCODE{
				Tro
				s ret="-102"
				Q
			}
		}
	}
	if ret=0{
		Tc	
	}
	Q ret
}

ClassMethod CheckHasConfigFlag(TPRowID As %String, ServiceGroupRowID As %String, HospID As %String = "")
{
	n (TPRowID,ServiceGroupRowID,HospID,%session)
	s:HospID="" HospID=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospID)
	s HasConfigFlag="N"
	s TimeLinkGroupId=""
	for{
		s TimeLinkGroupId=$o(^User.DHCDocCureTimeLinkGroupI("TLGTPandSGIndex",+TPRowID,+ServiceGroupRowID,TimeLinkGroupId))
		Q:TimeLinkGroupId=""
		s DDCTLGHospitalDR=$LG(^User.DHCDocCureTimeLinkGroupD(TimeLinkGroupId),4)
		continue:(HospID'=DDCTLGHospitalDR)
		if TimeLinkGroupId'=""{
			s HasConfigFlag="Y"
		}
	}
	Q HasConfigFlag
}

}
