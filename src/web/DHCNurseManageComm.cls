Class web.DHCNurseManageComm Extends %RegisteredObject
{

/// 获取公共代码
/// do ##class(%ResultSet).RunQuery("web.DHCNurRosterComm","FindCommDicSubData","单位级别")
Query FindCommDicSubData(parr As %String) As %Query(ROWSPEC = "id,code,desc")
{
}

ClassMethod FindCommDicSubDataExecute(ByRef qHandle As %Binary, parr As %String) As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	set cdid = $O(^DHCMGNUR.CommDictionaryI("Code"," "_$zcvt(parr,"U"),""))
	if (cdid="")
	{
		Set qHandle=$lb(0,repid,0)
		Quit $$$OK
	}
	s cdsid="" f  s cdsid = $O(^DHCMGNUR.CommDictionarySubD(cdid,cdsid)) q:cdsid=""  d
	.s id=cdid_"||"_cdsid
	.s cdsobj = ##class(DHCMGNUR.CommDictionarySub).%OpenId(id)
	.s codedesc = cdsobj.CodeDesc
	.s code=cdsobj.Code
	.;s ret="rw|"_$tr(id,"||","__")_"^Code|"_code_"^Desc|"_codedesc
	.do OutputCommDic
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputCommDic
	set Data=$lb($tr(id,"||","__"),code,codedesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindCommDicSubDataFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindCommDicSubDataExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindCommDicSubDataClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindCommDicSubDataExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 下垃框加载护士信息
/// d ##class(%ResultSet).RunQuery("web.DHCNurseManageComm","FindPersonInfo","PersonType2|N^PersonDepDR|","")
Query FindPersonInfo(parr As %String = "", input As %String = "") As %Query(ROWSPEC = "PersonID:%String,PersonName:%String")
{
}

ClassMethod FindPersonInfoExecute(ByRef qHandle As %Binary, parr As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s tmp=""
	d ..SetTemp(parr,.tmp)
	s perdr="" f  s perdr=$O(^DHCMGNUR.MgPersonsD(perdr)) q:perdr=""  d
	.s perobj=##class(DHCMGNUR.MgPersons).%OpenId(perdr)
	.q:($g(tmp("PersonType2"))'="")&&(perobj.PersonType2'=tmp("PersonType2"))
	.q:(perobj.PersonDepDR="")||($d(^CTLOC(perobj.PersonDepDR))=0)
	.q:($g(tmp("PersonDepDR"))'="")&&(perobj.PersonDepDR'=tmp("PersonDepDR"))
	.q:($g(tmp("PersonID"))'="")&&(perobj.PersonID'=tmp("PersonID"))
	.q:($g(tmp("PersonName"))'="")&&(perobj.PersonName'=tmp("PersonName"))
	.q:(input'="")&&($zcvt(perobj.PersonID,"U")'=$zcvt(input,"U"))&&($zcvt(perobj.PersonName,"U")'[$zcvt(input,"U"))
	.s PersonID=perobj.PersonID
	.i perobj.PersonType2="R" s PersonID=$E(3,$L(PersonID))
	.s PersonName=perobj.PersonName 
	.d OutputPerInfo
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputPerInfo
	set Data=$lb(PersonID,PersonName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindPersonInfoClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindPersonInfoExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

ClassMethod FindPersonInfoFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindPersonInfoExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

/// 字符串拆分
ClassMethod SetTemp(parr As %String, tmp As %String) As %String
{
	q:parr=""
	s tmp=""
	s len=$L(parr,"^")
	f i=1:1:len d
	.s item=$P(parr,"^",i)
	.q:item=""
	.s key=$P(item,"|",1)
	.i $L(item,"|")=2 s desc=$tr($P(item,"|",2),"__","||")
	.e  i $L(item,"|")=3 s desc=$P(item,"|",2)_"||"_$P(item,"|",4)
	.e  s desc=""
 	.s tmp(key)=desc
	q 0
}

/// 根据出生日计算年龄
ClassMethod CalAge(IBirth As %String, IToday As %String)
{
	//b ;1109
    s IBirth=$g(IBirth),IToday=$g(IToday)
    i IBirth>2980000 s IBirth=""
    i IBirth<0 s IBirth=""
    q:'$G(IBirth) ""
    s XBirth=$ZD(IBirth)
    s XToday=$ZD(IToday)
    s AgeMth=XToday-XBirth
    s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
    s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
    s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
    s AgeYear=CurrYear-BirthYear
    i AgeDay<0 d
        . s AgeMth=AgeMth-1
	    . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
	    . q:XToday'=2
	    . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
	i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1
	s $P(AgeYr,"|",12)=AgeYear
	s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
	q reage
}

/// 查询HIS科室
/// d ##class(%ResultSet).RunQuery("web.DHCNurseManageComm","FindHISLoc","","W","")
Query FindHISLoc(lochosp As %String = "", loctyp As %String = "", input As %String = "") As %Query(ROWSPEC = "LocId:%String,LocCode:%String,LocDesc:%String")
{
}

ClassMethod FindHISLocExecute(ByRef qHandle As %Binary, lochosp As %String = "", loctyp As %String = "", input As %String = "") As %Status
{
	s repid=$I(^CacheTemp)
	s ind=1
	s LocId="" f  s LocId=$O(^CTLOC(LocId)) q:LocId=""  d
	.s LocHosp=$P(^CTLOC(LocId),"^",22)
	.;q:(lochosp'="")&&(lochosp'=LocHosp)
	.s LocType=$P(^CTLOC(LocId),"^",13)   
	.;q:(loctyp'="")&&(loctyp'=LocType)
	.s LocDesc=$P(^CTLOC(LocId),"^",2)
	.q:(LocDesc["停用")!(LocDesc["未用")!(LocDesc["作废")
	.q:(input'="")&&($zcvt(LocDesc,"U")'[$zcvt(input,"U"))
	.s LocCode=$P(^CTLOC(LocId),"^",1)
	.d OutputHISLoc
	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputHISLoc
	set Data=$lb(LocId,LocCode,LocDesc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
 	q
}

ClassMethod FindHISLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = FindHISLocExecute ]
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
 	// Save QHandle
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod FindHISLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = FindHISLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
	Quit $$$OK
}

/// 获取科室护士长
ClassMethod GetLocHead(locid As %String) As %String
{
	q:locid="" 0
	s ret=""
	s perdr="" f  s perdr=$O(^DHCMGNUR.MgPersonsI("Dep"," "_locid,perdr)) q:(perdr="")!('$d(ret))  d
	.s perobj=##class(DHCMGNUR.MgPersons).%OpenId(perdr)
	.s perheadship=perobj.PersonheadshipDR
	.q:perheadship=""
	.s perheadshipdesc=perheadship.CodeDesc
	.q:perheadshipdesc'="护士长"
	.s perid=perobj.PersonID
	.s ret=perid
	q ret
}

/// 根据护士工号获取护士信息
ClassMethod GetPerson(perid As %String, wardid As %String = "") As %String
{
	q:perid="" ""
	s perid=$zcvt(perid,"U")
	s perdr=$O(^DHCMGNUR.MgPersonsI("SSID"," "_perid,""))
	q:perdr="" ""
	s perobj=##class(DHCMGNUR.MgPersons).%OpenId(perdr)
	s pername=perobj.PersonName
	s perward=perobj.PersonDepDR
	q:(wardid'="")&&(wardid'=perward) ""
	s perbirthday=perobj.PersonBirthDay
	s perworkdate=perobj.PersonWorkDateTime
	s perage=$P(..CalAge(perbirthday,+$h),"Y",1)
	s perworkage=$P(..CalAge(perworkdate,+$h),"Y",1)
	s perphone=perobj.PersonTelHand
	s ret="PersonID|"_perid_"^PersonName|"_pername_"^PersonWard|"_perward_"^PersonAge|"_perage_"^PersonWorkAge|"_perworkage_"^PersonPhone|"_perphone
	q ret
}

ClassMethod GetQueryData(QueryName As %String, parrm As %String, funname As %String) As %String
{
   s ^objcyf123(QueryName)=parrm_"^"_funname
   s l=$L(parrm,"!")
   s pp=""
   f i=1:1:l
   {
     s itm=$P(parrm,"!",i)
     s p=$P(itm,"$",1)
     s v=$P(itm,"$",2)
     s @p=v
     b
     if i<l s pp=pp_p_","
     e  s pp=pp_p 
     b
   }

   Set rset = ##class(%ResultSet).%New(QueryName)
   Set columns = rset.GetColumnCount()


 // Execute the query
  b
  s sc = rset.Execute(@pp)
  s i=0
  While (rset.Next()) {
       s coldata=""
       For col = 1:1:columns {
            s coldata=coldata_"'"_$ZCVT(rset.GetData(col),"O","JS")_"',"
        }

   s coldata=$e(coldata,0,$l(coldata)-1)
   s rtnval=funname_"("_coldata_");"
   b
  &javascript<#(rtnval)#>

      
 }
 Do rset.Close()
 //	    .//s rtnval=funname_"('"_$ZCVT($g(condep),"O","JS")_"','"_$ZCVT($g(status),"O","JS")_"','"_$ZCVT($P($g(bedcode),"@",2),"O","JS")_"','"_$ZCVT($g(appdep),"O","JS")_"','"_$ZCVT($g(inout),"O","JS")_"','"_$ZCVT($P($g(Diag),"@",2),"O","JS")_"','"_$ZCVT($g(condestinat),"O","JS")_"','"_$ZCVT($P($g(patname),"@",2),"O","JS")_"','"_$ZCVT($g(apptime),"O","JS")_"','"_$ZCVT($g(appdate),"O","JS")_"','"_$ZCVT($g(consultdate),"O","JS")_"','"_$ZCVT($g(contime),"O","JS")_"','"_$ZCVT($g(Adm),"O","JS")_"','"_$ZCVT($g(id),"O","JS")_"');"

 q 0
}

/// w ##class(web.DHCNurseManageComm).GetMonthDay(2015,2)
ClassMethod GetMonthDay(year As %Integer, month As %Integer) As %Integer
{
	s monthday=0
	q:(year="")||(month="")||(month<1)||(month>12) monthday
	s yearflag=0
	i ((year#4=0)&&(year#100'=0))||((year#100=0)&&(year#400=0)) s yearflag=1
	i (month=1)||(month=3)||(month=5)||(month=7)||(month=8)||(month=10)||(month=12) d
	.s monthday=31
	e  i (month=2) d
	.i (yearflag=0) s monthday=28
	.e  s monthday=29
	e  s monthday=30
	q monthday
}

/// 获取科室某天某时间点上班护士
/// parr="date^time^loc"
ClassMethod GetTimeNurse(parr As %String) As %String
{
	i $P(parr,"^",1)["-" s date=$zdh($P(parr,"^",1),3)
	e  s date=+$h
	i $P(parr,"^",2)[":" s time=$zth($P(parr,"^",2),2)
	e  s time=$P($h,",",2)
	s ward=$P(parr,"^",3)
	i (ward="")&&(%Session) s ward=%Session.Data("LOGON.CTLOCID")
	q:ward="" ""
	s ret=""
	s argid="" f  s argid=$O(^DHCMGNUR.MgNurArrangeJobI("AJWardDateIdx"," "_ward," "_date,argid)) q:argid=""  d
	.s argobj=##class(DHCMGNUR.MgNurArrangeJob).%OpenId(argid)
	.s typs=argobj.AJType
	.q:typs'["Post"
	.s codes=argobj.AJCodeDR
	.s nurse=argobj.AJNurseDR
	.s flag=0
	.f i=1:1:$L(typs,",") d
	..s typ=$P(typs,",",i)
	..q:typ'="Post"
	..s code=$P(codes,",")
	..s post=##class(DHCMGNUR.MgNurPost).%OpenId(code)
	..s poststtime=post.PostStTime
	..s postendtime=post.PostEndTime
	..q:(poststtime="")||(postendtime="")
	..i postendtime<poststtime s postendtime=postendtime+$zth("23:59:59",1)
	..q:(poststtime>time)||(postendtime<time) 
	..s flag=1
	..s perdr=$O(^DHCMGNUR.MgPersonsI("SSID"," "_$zcvt(nurse,"U"),""))
	..q:perdr=""
	..s perobj=##class(DHCMGNUR.MgPersons).%OpenId(perdr)
	..s ret=ret_perobj.PersonName_";"
	s ret=$E(ret,1,$L(ret)-1)
	q ret
}

/// 获取病区在床人数
ClassMethod getCurrPatOnBed(loc) As %String
{
	s rowId=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	s sum=0
	i rowId'="" d
	.s raw="" f  s raw=$O(^PAADMi("CurrWard",rowId,raw)) q:raw=""  d
	..s sum=sum+1
	q sum
}

/// 获取病区在床人数新
ClassMethod getCurrPatOnBedNew(loc) As %String
{
	s rowId=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	s sum=0
	q:rowId="" sum	
	s patRoomId=""
    f  s patRoomId=$o(^PAADMi("CurrWard",rowId,patRoomId)) q:patRoomId=""  d
    .s EpisodeId=0
    .f  s EpisodeId=$o(^PAADMi("CurrWard",rowId,patRoomId,EpisodeId)) q:EpisodeId=""  d
    ..s patVisit=$p($g(^PAADM(EpisodeId)),"^",20)
    ..q:patVisit'="A"
    ..s paPmiId=$p($g(^PAADM(EpisodeId)),"^",1)
    ..s regNo=$p($g(^PAPER(paPmiId,"PAT",1)),"^",1)
    ..s patName=$p($g(^PAPER(paPmiId,"ALL")),"^",1)
    ..s bedSub=$p($p($g(^PAADM(EpisodeId)),"^",73),"||",2)
    ..q:bedSub=""
    ..s sum=sum+1
	q sum
}

/// 获取病区当前病危等人数
ClassMethod getOrderPat(loc, ordDesc, date) As %String
{
	q:loc="" 0
	s date=$zdh(date,3)
	s rowId=$O(^PAWARD(0,"WARD_LocationDR",loc,""))
	q:rowId="" 0
	s sum=0
	s ordPar=$O(^ARCIM(0,"Desc",$zcvt(ordDesc,"U"),""))
	q:ordPar="" 0
	s ordRW=$O(^ARCIM(0,"Desc",$zcvt(ordDesc,"U"),ordPar,""))
	q:ordRW="" 0
	s room="" f  s room=$O(^PAADMi("CurrWard",rowId,room)) q:room=""  d
	.s raw="" f  s raw=$O(^PAADMi("CurrWard",rowId,room,raw)) q:raw=""  d
	..s OEORDROWID=$O(^OEORD(0,"Adm",raw,""))
	..q:OEORDROWID=""
	..;s date="" f  s date=$O(^OEORDi(0,"ARCIM",OEORDROWID,ordPar_"||"_ordRW,date)) q:date=""  d
	..s orderid="" f  s orderid=$O(^OEORDi(0,"ARCIM",OEORDROWID,ordPar_"||"_ordRW,date,orderid)) q:orderid=""  d
	...s status=$p(^OEORD(OEORDROWID,"I",orderid,1),"^",13)
	...s code=$P(^OEC("OSTAT",status),"^",1)
	...q:((code'="V")&&(code'="E"))
	...s sum=sum+1
	q sum
}

/// 
/// 获取当前科室病人列表
Query findWardPatient(ward As %String = "") As %Query(ROWSPEC = "CheckPat,patcode")
{
}

ClassMethod findWardPatientExecute(ByRef qHandle As %Binary, ward As %String = "") As %Status
{
 	Set repid=$I(^CacheTemp)
 	s ind=1
	s paward=$O(^PAWARD(0,"WARD_LocationDR",ward,""))
	i paward="" Set qHandle=$lb(0,repid,0) Quit $$$OK
	s room="" f  s room=$O(^PAADMi("CurrWard",paward,room)) q:room=""  d
	.s rw="" f  s rw=$O(^PAADMi("CurrWard",paward,room,rw)) q:rw=""  d
	..s PMIDR=$P(^PAADM(rw),"^",1)
	..s name=$P(^PAPER(PMIDR,"ALL"),"^",1)
	..s code=$P(^PAPER(PMIDR,"PAT",1),"^",1)
	..s ret="CheckPat|"_name_"^patcode|"_rw
 	..d OutWardPats
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutWardPats
	;set Data=$lb(ret)
	set Data=$lb(name,rw)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod findWardPatientFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = findWardPatientExecute ]
{
 	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else {		
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod findWardPatientClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = findWardPatientExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

}
