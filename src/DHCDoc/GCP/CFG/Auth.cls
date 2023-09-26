/// CTOR: QP
/// DATE: 2022-03-04
/// DESC: 药物临床试验审核权限管理
Class DHCDoc.GCP.CFG.Auth Extends %RegisteredObject [ ProcedureBlock ]
{

/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 保存SAE
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.CFG.Auth).Save(^TEMP("wxnn",1))
ClassMethod Save(BaseParamJson As %String) As %String
{
	s ^TEMP("wxnn",1)=BaseParamJson
	k BaseParamArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(BaseParamJson,.BaseParamArr)
	s ID=BaseParamArr("ID")	
	s CurrentDate=+$h,CurrentTime=$p($h,",",2)
	s InHosp=BaseParamArr("AHospID")
	s InType=BaseParamArr("AType")
	s InValue=BaseParamArr("AValue")
	
	i ID = "" {
		s SaveOBJ = ##class(User.DHCDocPilotAuth).%New()
		D SaveOBJ.AHospIDSetObjectId(BaseParamArr("AHospID"))
		S SaveOBJ.AAddDate=CurrentDate
		S SaveOBJ.AAddTime=CurrentTime
		D SaveOBJ.AAddUserSetObjectId(BaseParamArr("AAddUser"))
		i $d(^User.DHCDocPilotAuthI("HospTypeValue",InHosp,InType,InValue)) {
				Quit "-1^配置已存在！"
		}
		
	} else  {
		s SaveOBJ = ##class(User.DHCDocPilotAuth).%OpenId(ID)	
	}
	S SaveOBJ.AActive=BaseParamArr("AActive")
	
	S SaveOBJ.AType=BaseParamArr("AType")
	S SaveOBJ.AValue=BaseParamArr("AValue")

	
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-1^保存失败！"
	}
	s MID=SaveOBJ.%Id()
	k SaveOBJ
	
	q MID_"^保存成功！"
}

/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 保存SAE
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.CFG.Auth).SaveSub(^TEMP("wxnn",1))
ClassMethod SaveSub(BaseParamJson As %String) As %String
{
	s ^TEMP("wxnn",1)=BaseParamJson
	k BaseParamArr
	d ##Class(DHCDoc.Util.FromJSON).FromJSONToArr(BaseParamJson,.BaseParamArr)
	s ID=BaseParamArr("ID")	
	s MID=BaseParamArr("MID")	
	Quit:MID="" "-1^主表为空！"
	s CurrentDate=+$h,CurrentTime=$p($h,",",2)
	
	i ID = "" {
		s SaveOBJ = ##class(User.DHCDocPilotAuthSub).%New(MID)
		D SaveOBJ.SParRefSetObjectId(BaseParamArr("MID"))
		D SaveOBJ.SAddUserSetObjectId(BaseParamArr("SAddUser"))
		S SaveOBJ.SAddDate=CurrentDate
		S SaveOBJ.SAddTime=CurrentTime
	} else  {
		s SaveOBJ = ##class(User.DHCDocPilotAuthSub).%OpenId(ID)	
	}
	S SaveOBJ.SActive=BaseParamArr("SActive")
	D SaveOBJ.SUserSetObjectId(BaseParamArr("SUser"))
	
	s sc = SaveOBJ.%Save()
	If $$$ISERR(sc) {
		//d $system.OBJ.DisplayError(sc) 
		Quit "-1^保存失败！"
	}
	//s MID=SaveOBJ.%Id()
	k SaveOBJ
	
	q "1^保存成功！"
}

/// CTOR: QP
/// DATE: 2022-03-04
/// DESC: 
/// IN  : 
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCP.CFG.Auth","QryType")
Query QryType(InHosp = "") As %Library.Query(ROWSPEC = "id,text,active")
{
}

ClassMethod QryTypeExecute(ByRef qHandle As %Library.Binary, InHosp = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	s CFGValue=""
	i $d(^DHCDocPilotSeting(InHosp,"SAEAuth")) {
		s CFGValue=$g(^DHCDocPilotSeting(InHosp,"SAEAuth"))
	}
	s id="Group",text="安全组"
	i CFGValue=id s active=1
	d OuputRow1
	;
	s active=0
	s id="Loc",text="科室"
	i CFGValue=id s active=1
	d OuputRow1
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OuputRow1
	
	
	set Data=$lb(id,text,active)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryTypeFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryTypeExecute ]
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

ClassMethod QryTypeClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryTypeFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2022-03-07
/// DESC: 查询权限
/// IN  : 
/// OUT : 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCP.CFG.Auth","QryAuth",2,"Group")
Query QryAuth(InHosp = "", InType = "") As %Library.Query(ROWSPEC = "id,AValue,AValueDR,AActive,AAddDate,AAddTime")
{
}

ClassMethod QryAuthExecute(ByRef qHandle As %Library.Binary, InHosp = "", InType = "") As %Library.Status
{
	Set repid=$I(^CacheTemp)
	If $g(ind)="" Set ind=1
	if ((InHosp="")||(InType="")) {
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s Value=""
	f  s Value=$o(^User.DHCDocPilotAuthI("HospTypeValue",InHosp,InType,Value)) q:Value=""  d
	.s id=""
	.f  s id=$o(^User.DHCDocPilotAuthI("HospTypeValue",InHosp,InType,Value,id)) q:id=""  d
	..s AValueDR=$lg(^User.DHCDocPilotAuthD(id),4)
	..s AValue=..GetValueDesc(InType,AValueDR)
	..s AActive=$lg(^User.DHCDocPilotAuthD(id),5)
	..s AAddDate=$lg(^User.DHCDocPilotAuthD(id),6)
	..s AAddDate=##class(websys.Conversions).DateLogicalToHtml(AAddDate)
	..s AAddTime=$lg(^User.DHCDocPilotAuthD(id),7)
	..s AAddTime=$zt(AAddTime,2)
 	..d OuputRow2
 	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OuputRow2
	
	
	set Data=$lb(id,AValue,AValueDR,AActive,AAddDate,AAddTime)
	Set ^CacheTemp(repid,ind)=Data
	Set ind=ind+1
	quit
}

ClassMethod QryAuthFetch(ByRef qHandle As %Library.Binary, ByRef Row As %Library.List, ByRef AtEnd As %Library.Integer = 0) As %Library.Status [ PlaceAfter = QryAuthExecute ]
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

ClassMethod QryAuthClose(qHandle As %Library.Binary) As %Library.Status [ PlaceAfter = QryAuthFetch ]
{
 Set repid=$LIST(qHandle,2)
 Kill ^CacheTemp(repid)
 Quit $$$OK
}

/// CTOR: QP
/// DATE: 2022-02-25
/// DESC: 保存SAE
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.CFG.Auth).GetValueDesc("Group",29)
ClassMethod GetValueDesc(InType As %String, Value) As %String
{
	s mRtn=""
	i InType="Group" {
		s mRtn=$p(^SSU("SSGRP",Value),"^",1)
	}
	i InType="Loc" {
		s mRtn=$p(^CTLOC(Value),"^",2)
	}
	
	Q mRtn
}

/// CTOR: QP
/// DATE: 2022-03-07
/// DESC: 设置不良事件审核类型
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: w ##class(DHCDoc.GCP.CFG.Auth).SetCFGValue("2",29)
ClassMethod SetCFGValue(InHosp As %String, InCode As %String, InValue As %String) As %String
{
	Q:InCode=""||InHosp="" 0
	;不良事件审核类型: SAEAuth:Group/Loc
	s ^DHCDocPilotSeting(InHosp,InCode)=InValue
	
	Q 0
}

/// CTOR: QP
/// DATE: 2018-08-17
/// DESC: 获取安全组
/// IN  : 
/// OUT : 
/// TABL: 
/// EXEC: d ##class(%ResultSet).RunQuery("DHCDoc.GCP.CFG.Auth","FindGroup","","","")
Query FindGroup(InType = "", InValue = "", InHosp = "") As %Query(ROWSPEC = "AValueDR:%String,desc:%String")
{
}

ClassMethod FindGroupExecute(ByRef qHandle As %Binary, InType = "", InValue = "", InHosp = "") As %Status
{
	Set repid=$I(^CacheTemp)
    Set ind=1
    s InHosp=##class(DHCDoc.Common.Hospital).GetCurrentSYSHospitalId(InHosp)
    s InValue=$ZCVT(InValue,"U")
    
    i InType="" {
	    Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	i InType="Group" {
	    s rowid=0
	    for {
		    s rowid=$o(^SSU("SSGRP",rowid)) q:rowid=""
		    s flag =##Class(DHCDoc.Common.Hospital).GetHospShowDataFlag("SS_Group",rowid,InHosp)
			continue:flag="N"
		    s desc=$p(^SSU("SSGRP",rowid),"^",1)
		    s active=$p(^SSU("SSGRP",rowid),"^",151)
		    continue:active'="Y"
		    continue:($ZCVT(desc,"U")'[InValue)&&(InValue'="")
		    Do OutputRowFind
		}
	}
	i InType="Loc" {
		s rowid=""
		f  s rowid=$o(^CTLOC(0,"Hosp",InHosp,rowid)) Q:rowid=""  d
		.s desc=$p(^CTLOC(rowid),"^",2)
		.s type=$p(^CTLOC(rowid),"^",13)
		.s startDate=$p(^CTLOC(rowid),"^",24)
		.s endDate=$p(^CTLOC(rowid),"^",25)
		.q:(startDate'="")&&(startDate>+$h)
		.q:(endDate'="")&&(endDate<+$h)
		.q:(type'="E")&&(type'="EM")
		.d OutputRowFind
	}
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowFind
	set Data=$lb(rowid,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	Quit
}

ClassMethod FindGroupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindGroupExecute ]
{
	Set repid=$LIST(qHandle,2)
	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindGroupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindGroupExecute ]
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

/// CTOR: QP
/// DATE: 2022-03-07
/// DESC: 删除
/// IN  : 
/// OUT : 
/// EXEC: w ##class(DHCDoc.GCP.CFG.Auth).DeleteAuth("")
ClassMethod DeleteAuth(ID As %String)
{
	Q:ID="" 0
	&SQL(DELETE FROM SQLUser.DHCDocPilotAuth WHERE ID=:ID)
	Q SQLCODE
}

/// CTOR: QP
/// DATE: 2022-03-07
/// DESC: 是否具有SAE审核权限
/// IN  : 
/// OUT : 0无，1有
/// EXEC: w ##class(DHCDoc.GCP.CFG.Auth).HasSAEAuth("")
ClassMethod HasSAEAuth(InHosp = "", InGroup = "", InLoc = "", InUser = "")
{
	s mRtn=0
	Q:InHosp="" mRtn
	Q:'$d(^DHCDocPilotSeting(InHosp,"SAEAuth")) mRtn
	s CFGValue=$g(^DHCDocPilotSeting(InHosp,"SAEAuth"))
	Q:CFGValue="" mRtn
		
	Q:'$d(^User.DHCDocPilotAuthI("HospTypeValue",InHosp,CFGValue)) mRtn
	
	I CFGValue="Group" {
		Q:'$d(^User.DHCDocPilotAuthI("HospTypeValue",InHosp,CFGValue,InGroup)) mRtn
		s mRtn=1
	}
	I CFGValue="Loc" {
		Q:'$d(^User.DHCDocPilotAuthI("HospTypeValue",InHosp,CFGValue,InLoc)) mRtn
		s mRtn=1
	}
	
	Q mRtn
}

}
