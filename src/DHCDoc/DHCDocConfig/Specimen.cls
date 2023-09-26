Class DHCDoc.DHCDocConfig.Specimen Extends %RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

/// creator:宋春莉
/// date:2015-05-04
/// desc:医生站设置程序->检验标本关联医嘱设置 查询标本
Query GetSpecList(HospitalCode As %String = "") As %Query(ROWSPEC = "SPECCode:%String,SPECDesc:%String,BloodFlag:%String,BloodFlagDesc:%String")
{
}

ClassMethod GetSpecListExecute(ByRef qHandle As %Binary, HospitalCode As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Specimen","GetSpecList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    i ($g(HospitalCode)="")&&($d(%session)) s HospitalId=%session.Get("LOGON.HOSPID"),HospitalCode=$p(^CT("HOSP",HospitalId),"^",1)
    i $d(^DHCLISBSVersion(1)) {
	    s HospitalCode=$g(HospitalCode)
		s HospitalDR=$o(^dbo.BTHospitalI("IndexCode",##Class(LIS.Util.Common).IndexData(HospitalCode),""))
		//i '$l(HospitalDR) s HospitalDR = $o(^dbo.BTHospitalD(""))
		i $l(HospitalDR) {
			s SPECstr=""
			s SpecCode="" f  s SpecCode=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode)) q:SpecCode=""  d
			.s SpecimenDR=$o(^dbo.BTSpecimenI("IndexCode",HospitalDR,SpecCode,""))
			.s SPECCode=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),2)
			.s SPECDesc=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),3)
			.s Active=$lg($g(^dbo.BTSpecimenD(SpecimenDR)),11)
			.Q:Active=0
			.s BloodFlag=$p($g(^DHCDocLabLI("SPEC",SPECCode,"DHC")),"\",1)
			.s BloodFlagDesc=..GetBloodFlagDesc(BloodFlag)
			.Do OutputRowGetSpecList
		}else{
			Set qHandle=$lb(0,repid,0)
			Quit $$$OK
		}
    }else{
	 	s SPECCode="" f  s SPECCode=$o(^DHCDocLabLI("SPEC",SPECCode)) q:SPECCode=""  d
	 	.s SPECDesc=$p($g(^DHCDocLabLI("SPEC",SPECCode)),"\",1)
		.s BloodFlag=$p($g(^DHCDocLabLI("SPEC",SPECCode,"DHC")),"\",1)
		.s BloodFlagDesc=..GetBloodFlagDesc(BloodFlag)
		.Do OutputRowGetSpecList
    }
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetSpecList
	set Data=$lb($g(SPECCode),$g(SPECDesc),$g(BloodFlag),$g(BloodFlagDesc))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetSpecListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetSpecListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetSpecListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetSpecListExecute ]
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

Query GetBloodFlagList(SPECCode As %String) As %Query(ROWSPEC = "BloodFlag:%String,BloodFlagDesc:%String,selected:%Boolean")
{
}

ClassMethod GetBloodFlagListExecute(ByRef qHandle As %Binary, SPECCode As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Specimen","GetBloodFlagList")
	Set repid=$I(^CacheTemp)
    Set ind=1
    s BloodFlagStr="1^2^3^4"
    For i=1:1:$l(BloodFlagStr,"^") d
    .s BloodFlag=$p(BloodFlagStr,"^",i)
	.s BloodFlagDesc=..GetBloodFlagDesc(BloodFlag)
	.s selected=0
	.i SPECCode'="" d
	..i $p($g(^DHCDocLabLI("SPEC",SPECCode,"DHC")),"\",1)=BloodFlag  s selected=1
	.Do OutputRowGetBloodFlagList
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetBloodFlagList
	set Data=$lb($g(BloodFlag),$g(BloodFlagDesc),$g(selected))
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetBloodFlagListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetBloodFlagListExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetBloodFlagListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetBloodFlagListExecute ]
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
/// date:2015-05-04
/// desc:医生站设置程序->检验标本关联医嘱设置 根据标本查询关联医嘱
Query GetItemBySpecCode(SPECCode As %String) As %Query(ROWSPEC = "SPECIARCIMDR:%String,SPECIARCIMDesc:%String,SPECIQty:%String,rowid:%String,UserDeptDesc:%String,AdmType:%String,RepelOther:%String")
{
}

ClassMethod GetItemBySpecCodeExecute(ByRef qHandle As %Binary, SPECCode As %String) As %Status
{
	;d ##class(%ResultSet).RunQuery("DHCDoc.DHCDocConfig.Specimen","GetItemBySpecCode")
	Set repid=$I(^CacheTemp)
    Set ind=1
    zn "dhc-data"
    i SPECCode'="" d
	.s SPECIChildsub=0  f  s SPECIChildsub=$o(^DHCDocLabLI("SPEC",SPECCode,"Item",SPECIChildsub)) q:SPECIChildsub=""  d
	..s SPECIData=$g(^DHCDocLabLI("SPEC",SPECCode,"Item",SPECIChildsub))
	..s SPECIARCIMDR=$p(SPECIData,"^",1)
	..Q:(+SPECIARCIMDR=0)||('$d(^ARCIM(+SPECIARCIMDR,$p(SPECIARCIMDR,"||",2))))
	..s SPECIARCIMDesc=$p(^ARCIM(+SPECIARCIMDR,$p(SPECIARCIMDR,"||",2),1),"^",2)
	..s SPECIQty=$p(SPECIData,"^",2)
	..s UserDeptDr=$p(SPECIData,"^",3)
	..s UserDeptDesc=""
	..i UserDeptDr'="" s UserDeptDesc=$P($G(^CTLOC(UserDeptDr)),"^",2)
	..s AdmType=$p(SPECIData,"^",4)
	..s RepelOther=$p(SPECIData,"^",5)
	..Do OutputRowGetItemBySpecCode
	zn "dhc-app"
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowGetItemBySpecCode
	set Data=$lb($g(SPECIARCIMDR),$g(SPECIARCIMDesc),$g(SPECIQty),SPECCode_"||"_SPECIChildsub,UserDeptDesc,AdmType,RepelOther)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod GetItemBySpecCodeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = GetItemBySpecCodeExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod GetItemBySpecCodeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = GetItemBySpecCodeExecute ]
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

ClassMethod Delete(rowid As %String) As %String
{
	zn "dhc-data"
	s rtn=$$delete^DHCCTSpecimenLinkItem(rowid)
	zn "dhc-app"
	q rtn
}

ClassMethod Save(code As %String, arcrowid As %String, qty As %String, UserDeptDr As %String = "", AdmType As %String = "", RepelOther As %String = "", rowid As %String = "") As %String
{
	s ^tempInsert=code_","_arcrowid_","_qty
	s SPECIChildsub=0,Find=0
	s CheckData=arcrowid_"^"_"^"_UserDeptDr_"^"_AdmType_"^"_RepelOther
	f  s SPECIChildsub=$o(^DHCDocLabLI("SPEC",code,"Item",SPECIChildsub)) q:(SPECIChildsub="")||(Find=1)  d
	.Q:(rowid'="")&&(rowid=(code_"||"_SPECIChildsub))
	.s Data=$g(^DHCDocLabLI("CON",code,"Item",SPECIChildsub))
	.s $P(Data,"^",2)=""
	.i CheckData=Data s Find=1
	q:Find=1 "-1"
	if '$D(^ARCIM($P(arcrowid,"||",1))){
		q "-2"
	}
	zn "dhc-data"
	if (rowid="") {
		s rtn=$$Insert^DHCCTSpecimenLinkItem(code,arcrowid,qty,UserDeptDr,AdmType,RepelOther)
	}else{
		s rtn=$$Update^DHCCTSpecimenLinkItem(rowid,code,arcrowid,qty,UserDeptDr,AdmType,RepelOther)
	}
	zn "dhc-app"
	q rtn
}

ClassMethod updateSpecimenBloodFlag(rowid, BloodFlag)
{
	s $P(^DHCDocLabLI("SPEC",rowid,"DHC"),"\",1)=BloodFlag
	q 0
}

ClassMethod GetBloodFlagDesc(BloodFlagCode As %String) As %String
{
	s BloodFlagDesc=""
	s:BloodFlag=1 BloodFlagDesc="静脉统一采血"
	s:BloodFlag=2 BloodFlagDesc="按标本取血"
	s:BloodFlag=3 BloodFlagDesc="动脉统一采血"
	s:BloodFlag=4 BloodFlagDesc="末梢统一采血"
	q BloodFlagDesc
}

}
