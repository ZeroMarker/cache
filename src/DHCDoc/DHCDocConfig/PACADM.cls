Class DHCDoc.DHCDocConfig.PACADM Extends DHCDoc.Util.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->病人类别与费别对照 病人类别与费别对照
Query GetDHCPACADMList(value As %String, HospId As %String = "") As %Query(ROWSPEC = "PACRowId:%String,PACSocialStatusDr:%String,PACSocialStatus:%String,PACAdmReasonDr:%String,PACAdmReason:%String")
{
}

ClassMethod GetDHCPACADMListExecute(ByRef qHandle As %Binary, value As %String, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PACADM","GetDHCPACADMList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    s PACRowId=0  f  s PACRowId=$o(^DHCPACADM(PACRowId)) q:PACRowId=""  d
    .s PACSocialStatusDr=$p(^DHCPACADM(PACRowId),"^",1)
    .s PACSocialStatus=$p($g(^CT("SS",PACSocialStatusDr)),"^",2)
    .if ('$d(^CT("SS",PACSocialStatusDr))) s PACSocialStatus=PACSocialStatus_"<font color=red> 已失效</font>"
    .s PACAdmReasonDr=$p(^DHCPACADM(PACRowId),"^",2)
    .s PACAdmReason=$p($g(^PAC("ADMREA",PACAdmReasonDr)),"^",2)
    .if ('$d(^PAC("ADMREA",PACAdmReasonDr))) s PACAdmReason=PACAdmReason_"<font color=red> 已失效</font>"
    .e  d
    ..s BillTypeSttDate=$p(^PAC("ADMREA",PACAdmReasonDr),"^",3)
    ..if (BillTypeSttDate'="")&&(BillTypeSttDate>+$h) s PACAdmReason=PACAdmReason_"<font color=red> 未到生效日期</font>" 
    ..s BillTypeEndDate=$p(^PAC("ADMREA",PACAdmReasonDr),"^",4)
    ..if (BillTypeEndDate'="")&&(BillTypeEndDate<+$h) s PACAdmReason=PACAdmReason_"<font color=red> 已过截止日期</font>" 
    .s PACStartDate=$p(^DHCPACADM(PACRowId),"^",3)
    .s PACEndDate=$p(^DHCPACADM(PACRowId),"^",4)
    .q:(PACStartDate'="")&&(PACStartDate>+$h)
    .q:(PACEndDate'="")&&(PACEndDate<=..%SysDate())
    .s PACHospDr=$p(^DHCPACADM(PACRowId),"^",5)
    .Q:PACHospDr'=HospId
	.Do OutputRowGetDHCPACADMList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetDHCPACADMList
	set Data=$lb($g(PACRowId),$g(PACSocialStatusDr),$g(PACSocialStatus),$g(PACAdmReasonDr),$g(PACAdmReason))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetDHCPACADMListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetDHCPACADMListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetDHCPACADMListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetDHCPACADMListExecute ]
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

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->病人类别与费别对照 病人类别
Query GetCTSocialstatusList(HospId) As %Query(ROWSPEC = "SSRowId:%String,SSDesc:%String")
{
}

ClassMethod GetCTSocialstatusListExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PACADM","GetCTSocialstatusList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s SSRowId=0  f  s SSRowId=$o(^CT("SS",SSRowId)) q:SSRowId=""  d
    .Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_SocialStatus",SSRowId,HospId)="N"
    .s SSDesc=$p(^CT("SS",SSRowId),"^",2)
	.Do OutputRowGetCTSocialstatusList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetCTSocialstatusList
	set Data=$lb($g(SSRowId),$g(SSDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetCTSocialstatusListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetCTSocialstatusListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetCTSocialstatusListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetCTSocialstatusListExecute ]
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

ClassMethod insert(PACSocialStatus As %String, PACAdmReason As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s find=..find("",PACSocialStatus,PACAdmReason,HospId)
	q:find=1 "-1"
	k PLIST
	s PLIST(2)=PACSocialStatus
	s PLIST(3)=PACAdmReason
	s PLIST(6)=HospId
	&sql(insert into SQLUser.DHC_PACADM values :PLIST())
    Q SQLCODE
}

ClassMethod delete(Rowid As %String) As %String
{
	&sql(delete from SQLUser.DHC_PACADM where PAC_RowId=:Rowid)
    Q SQLCODE
}

ClassMethod update(Rowid As %String, PACSocialStatus As %String, PACAdmReason As %String, HospId As %String = "") As %String
{
	s find=..find(Rowid,PACSocialStatus,PACAdmReason,HospId)
	q:find=1 "-1"
     &sql(update SQLUser.DHC_PACADM
            set PAC_SocialStatus_Dr =:PACSocialStatus,PAC_AdmReason_Dr=:PACAdmReason
            where PAC_RowId =:Rowid )
    q SQLCODE
}

ClassMethod find(Rowid, PACSocialStatus As %String, PACAdmReason As %String, HospId As %String = "") As %String
{
	i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
	s Find=0
	s PACRowId=0  f  s PACRowId=$o(^DHCPACADM(0,"AdmReason",PACAdmReason,PACRowId)) q:(PACRowId="")||(Find=1)  d
	.Q:(Rowid'="")&&(PACRowId=Rowid)
	.s SocialStatus=$p($g(^DHCPACADM(PACRowId)),"^",1)
	.s Hospdr=$p($g(^DHCPACADM(PACRowId)),"^",5)
	.s:(PACSocialStatus=SocialStatus)&&(Hospdr=HospId) Find=1
	q Find
}

}
