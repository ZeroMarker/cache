Class DHCDoc.DHCDocConfig.PALocAmount Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-07-06
/// desc:医生站设置程序->科室功能设置->科室费用限制 查询所有科室费用设置
Query GetPALocAmount(HospId As %String = "") As %Query(ROWSPEC = "PLARowid:%String,PatientTypeDR:%String,PatientType:%String,PAADMType:%String,LocDr:%String,LocDesc:%String,AllowAmount:%String,PAADMTypeDr:%String")
{
}

ClassMethod GetPALocAmountExecute(ByRef qHandle As %Binary, HospId As %String = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PALocAmount","GetPALocAmount")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospId)="")&&($d(%session)) s HospId=%session.Get("LOGON.HOSPID")
    s PLARowid=0 f  s PLARowid=$o(^DHCPALocAmount(PLARowid)) q:PLARowid=""  d
    .s PatientTypeDR=$p(^DHCPALocAmount(PLARowid),"^",1)
    .s PatientType=$p(^CT("SS",PatientTypeDR),"^",2)
    .s PAADMTypeDr=$p(^DHCPALocAmount(PLARowid),"^",2)
    .i PAADMTypeDr="O" s PAADMType="门诊"
    .i PAADMTypeDr="E" s PAADMType="急诊"
    .i PAADMTypeDr="I" s PAADMType="住院"
    .i PAADMTypeDr="H" s PAADMType="体检"
    .i PAADMTypeDr="N" s PAADMType="新生儿"
    .s LocDr=$p(^DHCPALocAmount(PLARowid),"^",3)
    .s LocHosDr=$p(^CTLOC(LocDr),"^",22)
    .Q:(LocHosDr'=HospId)&&(HospId'="")
    .s LocDesc=$p(^CTLOC(LocDr),"^",2)
    .s AllowAmount=$p(^DHCPALocAmount(PLARowid),"^",4)
	.Do OutputRowGetPALocAmount
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetPALocAmount
	set Data=$lb($g(PLARowid),$g(PatientTypeDR),$g(PatientType),$g(PAADMType),$g(LocDr),$g(LocDesc),$g(AllowAmount),$g(PAADMTypeDr))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetPALocAmountClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPALocAmountExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPALocAmountFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPALocAmountExecute ]
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
/// desc:医生站设置程序->科室功能设置->科室费用限制 查询病人类型
Query GetSocialList(HospId = "") As %Query(ROWSPEC = "SSRowId:%String,SSDesc:%String")
{
}

ClassMethod GetSocialListExecute(ByRef qHandle As %Binary, HospId = "") As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PALocAmount","GetSocialList")
	s HospId=##Class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(HospId)
	Set repid=$I(^CacheTemp)
    Set ind=1
    s SSRowId=0
    f  s SSRowId=$o(^CT("SS",SSRowId)) q:SSRowId=""  d
    .s SSDesc=$p(^CT("SS",SSRowId),"^",2)
    .Q:##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("CT_SocialStatus",SSRowId,HospId)="N"
	.Do OutputRowGetSocialList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetSocialList
	set Data=$lb($g(SSRowId),$g(SSDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetSocialListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSocialListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSocialListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSocialListExecute ]
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
/// desc:医生站设置程序->科室功能设置->科室费用限制 查询就诊类型
Query GetPAAdmTypeList() As %Query(ROWSPEC = "PAADMType:%String,PAAdmTypeDesc:%String")
{
}

ClassMethod GetPAAdmTypeListExecute(ByRef qHandle As %Binary) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.PALocAmount","GetPAAdmTypeList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s PAAdmTypeStr="O^E^I^H^N"
    For i=1:1:$l(PAAdmTypeStr,"^") d
    .s PAADMType=$p(PAAdmTypeStr,"^",i)
    .i PAADMType="O" s PAAdmTypeDesc="门诊"
    .i PAADMType="E" s PAAdmTypeDesc="急诊"
    .i PAADMType="I" s PAAdmTypeDesc="住院"
    .i PAADMType="H" s PAAdmTypeDesc="体检"
    .i PAADMType="N" s PAAdmTypeDesc="新生儿"
	.Do OutputRowGetPAAdmTypeList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetPAAdmTypeList
	set Data=$lb($g(PAADMType),$g(PAAdmTypeDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetPAAdmTypeListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetPAAdmTypeListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetPAAdmTypeListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetPAAdmTypeListExecute ]
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

// Rowid As %String,PatientType As %String, PAADMType As %String, Loc As %String, AllowAmount As %String

// w ##class(DHCDoc.DHCDocConfig.PALocAmount).insert(1,"O",44,1)

ClassMethod save(str As %String) As %String
{
	s Rowid=$p(str,",",1)
	s PatientType=$p(str,",",2)
	s PAADMType=$p(str,",",3)
	s Loc=$p(str,",",4)
	s AllowAmount=$p(str,",",5)
	s find=..find(Rowid,PAADMType,PatientType,Loc)
	q:find=1 "-1"
	if (Rowid=""){
		k PLIST
		s PLIST(2)=PatientType
	    s PLIST(3)=PAADMType
	    s PLIST(4)=AllowAmount
	    s PLIST(5)=Loc
	    &sql(insert into SQLUser.DHC_PALocAmount values :PLIST())
	}else{
		&sql(update SQLUser.DHC_PALocAmount
            set PLA_PatientType_DR=:PatientType,PLA_PAADMType=:PAADMType,PLA_Loc_DR=:Loc,PLA_AllowAmount=:AllowAmount
            where PLA_Rowid=:Rowid )
	}
	Q SQLCODE
}

ClassMethod find(Rowid As %String, PAADMTypeRowid As %String, PatientTypeRowid As %String, LocRowid As %String) As %String
{
	k PLIST
	s count=0
	if (Rowid="") {
		&sql(select count(*) into :count from SQLUser.DHC_PALocAmount
          where PLA_PAADMType=:PAADMTypeRowid and PLA_PatientType_DR=:PatientTypeRowid and PLA_Loc_DR=:LocRowid)
	}else{
		&sql(select count(*) into :count from SQLUser.DHC_PALocAmount
          where PLA_PAADMType=:PAADMTypeRowid and PLA_PatientType_DR=:PatientTypeRowid and PLA_Loc_DR=:LocRowid and PLA_Rowid<>:Rowid)
	}
	Q count
}

ClassMethod delete(Rowid) As %String
{
	&sql(delete from SQLUser.DHC_PALocAmount where PLA_Rowid=:Rowid)
    q SQLCODE
}

}
