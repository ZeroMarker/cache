Import SQLUser

Class web.DHCQTRECTYPW Extends %RegisteredObject
{

ClassMethod InsertTyp(TYPCODE As %String, TYPDESC As %String, TYPTYPE As %String, TYPTYPECODE As %String, HOSPITALID = "")
{
    s TYPROWID=0
    q:HOSPITALID="" "医院不能为空"
    ;s TYPROWID=$o(^DHCQTRECTYP("typ",TYPROWID),-1) 
	TSTART
	;s PList(1)=TYPROWID
	s PList(2)=TYPCODE
	s PList(3)=TYPDESC
	s PList(4)=TYPTYPE
	s PList(5)=TYPTYPECODE
	s PList(6)=HOSPITALID
	&SQL(insert into DHC_QTRECTYP Values :PList())
	i SQLCODE
	{
		TROLLBACK
		q SQLCODE
	}
	TCOMMIT
	q SQLCODE
}

ClassMethod DeleteTyp(TYPROWID As %String)
{
	i TYPROWID'="" d
	.k ^DHCQTRECTYP("typ",TYPROWID)
	q 0
}

ClassMethod UpdateTyp(TYPROWID As %String, TYPCODE As %String, TYPDESC As %String, TYPTYPE As %String, TYPTYPECODE As %String, HOSPITALID)
{
	;s ^tmpSC("v1") = TYPCODE_","_TYPDESC_","_TYPTYPE_","_TYPTYPECODE
	i (TYPROWID'="")&&(TYPCODE'="")&&(TYPDESC'="")
	{
		&sql(update DHC_QTRECTYP set TYP_CODE=:TYPCODE,TYP_DESC=:TYPDESC,TYP_TYPE=:TYPTYPE,TYP_TYPE_CODE=:TYPTYPECODE,TYP_HOSPITAL=:HOSPITALID where TYP_ROWID=:TYPROWID)
	}
	Q 0
}

/// ##class(%ResultSet).RunQuery("web.DHCQTRECTYPW","FindQTRec",2)
Query FindQTRec(HospitalRowId As %String) As websys.Query(ROWSPEC = "TYP_ROWID,TYP_CODE,TYP_DESC,TYP_TYPE, TYP_TYPE_CODE, TYP_HOSPITAL")
{
}

ClassMethod FindQTRecExecute(ByRef qHandle As %Binary, HospitalRowId As %String) As %Status
{
	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1
 	
	if $d(%session)&&(HospitalRowId=""){
	 	;w "yiyuan:"_%session.Get("LOGON.HOSPID")
 		set HospitalRowId=%session.Get("LOGON.HOSPID")	 	
	}
	s:HospitalRowId'="" defHosp=##class(Nur.Interface.Other.BDPInterface).GetDefHospIdByTableName("Nur_IP_DHCQTRECTYP",HospitalRowId)
	s rw="" f  s rw=$o(^DHCQTRECTYP("typ",rw)) q:rw=""  d
	.s code=$p(^DHCQTRECTYP("typ",rw),"^",1)
	.s desc=$p(^DHCQTRECTYP("typ",rw),"^",2)
	.s type=$p(^DHCQTRECTYP("typ",rw),"^",3)
	.s typeCode=$p(^DHCQTRECTYP("typ",rw),"^",4)
	.s hosp=$p(^DHCQTRECTYP("typ",rw),"^",5)
	.q:hosp'=$g(defHosp)
	.d getQTRec	
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK	
getQTRec
	set Data=$lb(rw,code,desc,type,typeCode,hosp)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

}
