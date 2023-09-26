/// Hospital:北京协和医院
/// Class Decription:科室护理团队建设查询
/// Date:2014-12-01
Class web.DHCMgNurCareTeamBuild Extends %RegisteredObject
{

/// Hospital:北京协和医院
/// Method Description:查询界面科室
/// 
Query SearchComboDep(ward1 = "", nurseid) As %Query(ROWSPEC = "ctlocDesc,CtLocDr")
{
}

ClassMethod SearchComboDepExecute(ByRef qHandle As %Binary, ward1 = "", nurseid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s ward1=$TR($ZConvert(ward1,"U")," ","")
 	s nurseNO=$P(nurseid,"^",1)
 	s nurseGroup=$P(nurseid,"^",2)
 	if ((nurseGroup="护理部主任")!(nurseGroup="Demo Group"))
 	{
	 	s indexNo="" f  s indexNo=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",indexNo)) q:indexNo=""  d
	 	.s id="" f  s id=$O(^DHCMGNUR.MgNurPerWardI("WardOrd",indexNo,id)) q:id=""  d
	 	..s a=##class(DHCMGNUR.MgNurPerWard).%OpenId(id)	 	
	 	..s CtLocDr=a.WardLoc
	 	..i ((CtLocDr'="9999")&(CtLocDr'="9997")&(CtLocDr'="9998"))  s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
	 	..q:(ctlocDesc'[ward1)&&(ward1'="")
	 	..d OutputRow8
 	}
 	else
 	{
		s perNurseId=$P(^SSU("SSUSR",nurseNO),"^",1)
		s id="" f  s id=$O(^DHCMGNUR.MgPersonsI("SSID"," "_perNurseId,id)) q:id=""  d
		.s a=##class(DHCMGNUR.MgPersons).%OpenId(id)
		.s CtLocDr=a.PersonDepDR
		.s ctlocDesc=$p(^CTLOC(CtLocDr),"^",2)
		.;q:(ctlocDesc'[ward1)&&(ward1'="")
		.d OutputRow8
 	}
	
	 	
  	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ctlocDesc,CtLocDr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchComboDepFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchComboDepExecute ]
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

ClassMethod SearchComboDepClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchComboDepExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Hospital:北京协和医院
/// Class Description:查询调查表列表
/// Date:2014-12-02
Query SearchSurveyList() As %Query(ROWSPEC = "aa")
{
}

ClassMethod SearchSurveyListExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
 	If $g(ind)="" Set ind=1 
 	s ret=""
	s date="" f  s date=$O(^DHCMGNUR.MgDepartConsSurveyI("FillDate",date)) q:date=""  d
	.s id="" f  s id=$O(^DHCMGNUR.MgDepartConsSurveyI("FillDate",date,id)) q:id=""  d
	..s a=##class(DHCMGNUR.MgDepartConsSurvey).%OpenId(id)
	..s StDate=$zd(a.StDate,3)
	..s EndDate=$ZD(a.EndDate,3)
	..i a.TabTitle="1" s TabTitle="科室护理团队建设情况调查表"
	..e  s TabTitle=a.TabTitle
	..s FillDate=$ZD(a.FillDate,3)
	..b ;01
	..s ret="StDate|"_StDate_"^EndDate|"_EndDate_"^TabTitle|"_TabTitle_"^FillDate|"_FillDate_"^par|"_id
	..b ;02
	..d OutputRow8
 	
	 	
  	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
	set Data=$lb(ret)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod SearchSurveyListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchSurveyListExecute ]
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

ClassMethod SearchSurveyListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchSurveyListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

/// Hospital:北京协和医院
/// Method Decription:大科护理单元查询列表
/// Date:2014-12-04
Query SearchMajorCareUnit(typ As %String) As %Query(ROWSPEC = "LocName,LocId")
{
}

ClassMethod SearchMajorCareUnitExecute(ByRef qHandle As %Binary, typ As %String) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurStatDistibute","SearchMajorCareUnit")
	;s ^TEMP("g20141204105701")=typ
	Set repid=$I(^CacheTemp)
	s typ=$ZConvert(typ,"U")
 	s ind=1
	s loc="" f  s loc=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_typ,loc)) q:loc=""  d
	.s id="" f  s id=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_typ,loc,id)) q:id=""  d
	..s a=##class(DHCMGNUR.MgNurMaCareUnit).%OpenId(id)
	..s LocName=$P(^CTLOC(a.WardLoc),"^",2)
	..s LocId=a.WardLoc
 	..d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(LocName,LocId)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SearchMajorCareUnitFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SearchMajorCareUnitExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SearchMajorCareUnitClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SearchMajorCareUnitExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// Method Decripition:汇总查询时大科类型查询
/// Date:2014-12-10
Query SchLargerLocTyp(typ As %String) As %Query(ROWSPEC = "LocCode,LocDes,rw")
{
}

ClassMethod SchLargerLocTypExecute(ByRef qHandle As %Binary, typ As %String) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurCareTeamBuild","SchLargerLocTyp")
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s ^TEM("g20141210163201")=typ
 	//typ="3901^Demo Group"
	s ret=""
	s userId=$P(typ,"^",1)
	s secGrp=$P(typ,"^",2)
	i ((secGrp="Demo Group")!(secGrp="护理部"))
	{
		s code="" f  s code=$O(^DHCMGNUR.MgNurLargeLocI("Code",code)) q:code=""  d
		.s id="" f  s id=$O(^DHCMGNUR.MgNurLargeLocI("Code",code,id)) q:id=""  d
		..s a=##class(DHCMGNUR.MgNurLargeLoc).%OpenId(id)
		..;b ;01
		..s LocCode=a.LocCode
		..s LocDes=a.LocDes
		..s rw=id
		..;s ret="LocCode|"_LocCode_"^LocDes|"_LocDes_"^rw|"_id
		..;s ret=ret
		..d OutRowtyp
 		s LocDes="全院"
    	s LocCode="AllWard"
    	s rw="0"
    	d OutRowtyp	
	}
	elseif(secGrp="总护士长")
	{
		s locTyp=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Typ"," "_userId,""))
		b ;01
		i locTyp'=""
		{
			;s locTyp=$Tr(locTyp," ","")
			s id=$O(^DHCMGNUR.MgNurLargeLocI("Code",locTyp,""))
			i id'=""
			{
				s a=##class(DHCMGNUR.MgNurLargeLoc).%OpenId(id)
				s LocCode=a.LocCode
				s LocDes=a.LocDes
				s rw=id
				d OutRowtyp
			}
		}
	}
	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	
	set Data=$lb(LocCode,LocDes,rw)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SchLargerLocTypFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchLargerLocTypExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SchLargerLocTypClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchLargerLocTypExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// Hospital:北京协和医院
/// Method Decription:根据安全组查询统计汇总信息
/// Date:2014-12-08
Query SchSumQuForSecGrp(typ As %String, par As %String, parm As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SchSumQuForSecGrpExecute(ByRef qHandle As %Binary, typ As %String, par As %String, parm As %String) As %Status
{
	s ^TEMP("g20141208145001")=typ_"&"_par_"&"_parm
	Set repid=$I(^CacheTemp)
 	s ind=1
 	s SecGroup=$P(parm,"^",1)
	s perId=$P(parm,"^",2)
	s ret=""
	s inPutValue=typ
	i ((SecGroup="护理部")!(SecGroup="Demo Group"))
	{
		i ((inPutValue="全院")!(inPutValue="AllWard"))
		{
			s ward="" f  s ward=$O(^DHCMGNUR.MgNurMaCareUnitI("WardId",ward)) q:ward=""  d
			.;b ;01
			.s score=0
			.s num=0
			.s rw="" f  s rw=$O(^DHCMGNUR.MgDepartConsSurveySubI("LOCID"," "_ward,par,rw)) q:rw=""  d
			..s a=##class(DHCMGNUR.MgDepartConsSurveySub).%OpenId(par_"||"_rw)
			..s nurScore=a.NurScore
			..s item18=a.Item18
			..i item18'="" s num=$fn(num,"")+$fn("1","")
			..s score=$fn(score,"")+$fn(nurScore,"")
			.s ret="LocName|"_$P($P(^CTLOC(ward),"^",2),"-",2)_"^LocTotal|"_score_"^Item18|"_num_"^loc|"_ward
			.s ret=ret
			.d OutRowtyp
		}else
		{
			s inPutValue=$ZConvert(inPutValue,"U")
			s ward="" f  s ward=$O(^DHCMGNUR.MgNurMaCareUnitI("Typ"," "_inPutValue,ward)) q:ward=""  d
			.s score=0
			.s num=0
			.s rw="" f  s rw=$O(^DHCMGNUR.MgDepartConsSurveySubI("LOCID"," "_ward,par,rw)) q:rw=""  d
			..s a=##class(DHCMGNUR.MgDepartConsSurveySub).%OpenId(par_"||"_rw)
			..s nurScore=a.NurScore
			..s item18=a.Item18
			..i item18'="" s num=$fn(num,"")+$fn("1","")
			..s score=$fn(score,"")+$fn(nurScore,"")
			.s ret="LocName|"_$P($P(^CTLOC(ward),"^",2),"-",2)_"^LocTotal|"_score_"^Item18|"_num_"^loc|"_ward
			.s ret=ret
			.d OutRowtyp
		}	
		
	}
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SchSumQuForSecGrpFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchSumQuForSecGrpExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SchSumQuForSecGrpClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchSumQuForSecGrpExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// Hospital:北京协和医院
/// Method Description:护士对科室护理团队的意见和建议
/// Date:2014-12-09
Query SchOpSumGrid(loc As %String) As %Query(ROWSPEC = "aa")
{
}

ClassMethod SchOpSumGridExecute(ByRef qHandle As %Binary, loc As %String) As %Status
{
	s ^TEMP("g20141208145001")=loc
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret=""
	s ward=$P(loc,"^",1)
	s par=$P(loc,"^",2)
	s id="" f  s id=$O(^DHCMGNUR.MgDepartConsSurveySubI("LOCID"," "_ward,par,id)) q:id=""  d
	.s obj=##class(DHCMGNUR.MgDepartConsSurveySub).%OpenId(par_"||"_id)
	.q:obj.Item18=""
	.s OPItem=obj.Item18
	.s ret="OPItem|"_OPItem_"^loc|"_$P($P(^CTLOC(ward),"^",2),"-",2)
	.s ret=ret
	.d OutRowtyp
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SchOpSumGridFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchOpSumGridExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SchOpSumGridClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchOpSumGridExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// Hospital:北京协和医院
/// Method Decription:大科查询
/// Date:2014-12-10
Query SchLargeLocList() As %Query(ROWSPEC = "LocCode,LocDes,rw")
{
}

ClassMethod SchLargeLocListExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret=""
	s code="" f  s code=$O(^DHCMGNUR.MgNurLargeLocI("Code",code)) q:code=""  d
	.s id="" f  s id=$O(^DHCMGNUR.MgNurLargeLocI("Code",code,id)) q:id=""  d
	..s a=##class(DHCMGNUR.MgNurLargeLoc).%OpenId(id)
	..b ;01
	..s LocCode=a.LocCode
	..s LocDes=a.LocDes
	..s rw=id
	..;s ret="LocCode|"_LocCode_"^LocDes|"_LocDes_"^rw|"_id
	..;s ret=ret
	..d OutRowtyp
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(LocCode,LocDes,rw)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SchLargeLocListFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchLargeLocListExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SchLargeLocListClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchLargeLocListExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// 
/// Method Decripition:查询大科护士长
/// Date:2014-12-10
Query SchLarLocNurHead() As %Query(ROWSPEC = "nursename,nurdr")
{
}

ClassMethod SchLarLocNurHeadExecute(ByRef qHandle As %Binary) As %Status
{
	//w ##class(%ResultSet).RunQuery("web.DHCMgNurCareTeamBuild","SchLarLocNurHead")
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret=""
	s id="" f  s id=$O(^DHCMGNUR.MgNurseI("typ"," LOCNUR",id)) q:id=""  d
	.s nurObj=##class(DHCMGNUR.MgNurse).%OpenId(id)
	.s nurdr=nurObj.Nurse
	.s a=##class(User.SSUser).%OpenId(nurdr)
	.s nursename=a.SSUSRName
    .d OutRowtyp
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	
	set Data=$lb(nursename,nurdr)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SchLarLocNurHeadFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchLarLocNurHeadExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SchLarLocNurHeadClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchLarLocNurHeadExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

/// Hospital:北京协和医院
/// Method Decription:大科护士长关联大科查询
/// Date:2014-12-10
Query SchLarNurForLoc() As %Query(ROWSPEC = "aa")
{
}

ClassMethod SchLarNurForLocExecute(ByRef qHandle As %Binary) As %Status
{
	Set repid=$I(^CacheTemp)
 	s ind=1
	s ret=""
	s locCode="" f  s locCode=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Code",locCode)) q:locCode=""  d
	.s id="" f  s id=$O(^DHCMGNUR.DHCMgNurLarNurForLocI("Code",locCode,id)) q:id=""  d
	..s Obj=##class(DHCMGNUR.DHCMgNurLarNurForLoc).%OpenId(id)
	..s useId=Obj.NurseId
	..s a=##class(User.SSUser).%OpenId(useId)
	..s LarLocNurse=a.SSUSRName
	..s locId=Obj.LocCode
	..s locId=$ZConvert(locId,"U")
	..s rw="" f  s rw=$O(^DHCMGNUR.MgNurLargeLocI("Code"," "_locId,rw)) q:rw=""  d
	...s b=##class(DHCMGNUR.MgNurLargeLoc).%OpenId(rw)
	...s LarLocDes=b.LocDes
	...s ret="LarLocNurse|"_LarLocNurse_"^LarLocDes|"_LarLocDes_"^rw|"_id
	..s ret=ret
	..d OutRowtyp
 	
    Set qHandle=$lb(0,repid,0)
	Quit $$$OK
  
OutRowtyp
	set Data=$lb(ret)
	Set ^CacheTemp(repid,ind)=Data
 	
 	Set ind=ind+1
	quit
}

ClassMethod SchLarNurForLocFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = SchLarNurForLocExecute ]
{
	Set AtEnd=$LIST(qHandle,1)
 	Set repid=$LIST(qHandle,2)
 	Set ind=$LIST(qHandle,3)
 	Set ind=$o(^CacheTemp(repid,ind))
 	If ind="" {				// if there are no more rows, finish fetching
 		Set AtEnd=1
 		Set Row=""
 	}
 	Else      {			
 		Set Row=^CacheTemp(repid,ind)
 	}
 	s qHandle=$lb(AtEnd,repid,ind)
	Quit $$$OK
}

ClassMethod SchLarNurForLocClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = SchLarNurForLocExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK   //,Percent,Meth,Flag,rw
}

}
