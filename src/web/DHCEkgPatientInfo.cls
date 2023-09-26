Class web.DHCEkgPatientInfo Extends %RegisteredObject
{

// 日期: 2009-3-1

Query QuerySystemPatientStatus() As %Query(ROWSPEC = "rowid:%String,code:%String,desc:%String")
{
}

ClassMethod QuerySystemPatientStatusExecute(ByRef qHandle As %Binary, USERDR As %String) As %Status
{
	
	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid=0 f  s rowid=$o(^DHCRBCStatus("PatientStatus",rowid)) q:(rowid="")  d
	.s code=$p(^DHCRBCStatus("PatientStatus",rowid),"^",1)
	.s desc=$p(^DHCRBCStatus("PatientStatus",rowid),"^",2)
	.Do OutOtherLoc 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutOtherLoc
	set Data=$lb(rowid,code,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QuerySystemPatientStatusFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySystemPatientStatusExecute ]
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

ClassMethod QuerySystemPatientStatusClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySystemPatientStatusExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

Query QueryPadmType() As %Query(ROWSPEC = "TDesc:%String,TCode:%String")
{
}

ClassMethod QueryPadmTypeExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ^CacheTemp(repid,1)=$lb("住院病人","I")
 	Set ^CacheTemp(repid,2)=$lb("门诊病人","O")
 	Set ^CacheTemp(repid,3)=$lb("急诊病人","E")
    Set ^CacheTemp(repid,4)=$lb("体检病人","H")
    Set ^CacheTemp(repid,5)=$lb("其他病人","N")
    //Set ^CacheTemp(repid,6)=$lb("所有","")
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
}

ClassMethod QueryPadmTypeFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryPadmTypeExecute ]
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

ClassMethod QueryPadmTypeClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryPadmTypeExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

Query QuerySex() As %Query(ROWSPEC = "Trowid:%String,TDesc:%String")
{
}

ClassMethod QuerySexExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	s ind=1
	s rowid=0 f  s rowid=$o(^CT("SEX",rowid) ) q:(rowid="")  d
	.s desc=$p(^CT("SEX",rowid),"^",2)
	.Do OutSex 
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutSex
	set Data=$lb(rowid,desc)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QuerySexFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QuerySexExecute ]
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

ClassMethod QuerySexClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QuerySexExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod GetTypeDesc(type) As %String
{
	I type="I" d
	.s Desc="住院病人"
	else  i type="O" d 
	.s Desc="门诊病人"
	else  i type="E" d 
	.s Desc="急诊病人"
	else  i type="H" d
	.s Desc="体检病人" d
	else  i type="N" d
	.s Desc="其他病人"
   q Desc
}

ClassMethod CalAge(Birth, Today) As %String
{
 ; pass in date of birth in internal format
 ;
 //n XBirth,XToday,AgeDay,AgeMth,AgeYear,CurrMth,CurrYear,AgeYr,UseDOB
 s Birth=$g(Birth),Today=$g(Today)
 s reage=""
 q:(Birth="")
 s IBirth="",IToday=""
 s IBirth=$zdh(Birth,3)
 s IToday=$zdh(Today,3)
  ;hack of date of birth
 i IBirth>2980000 s IBirth=""
 i IBirth<0 s IBirth=""
 q:'$G(IBirth) ""
  ;
 s XBirth=$ZD(IBirth)
 s XToday=$ZD(IToday)
 s AgeMth=XToday-XBirth
 s AgeDay=$p(XToday,"/",2)-$p(XBirth,"/",2)
 s CurrYear=$p(XToday,"/",3) s:CurrYear<100 CurrYear=CurrYear+1900
 s BirthYear=$p(XBirth,"/",3) s:BirthYear<100 BirthYear=BirthYear+1900
 s AgeYear=CurrYear-BirthYear
 ;
 i AgeDay<0 d
 . s AgeMth=AgeMth-1
 . s AgeDay=AgeDay+$p("31,31,28,31,30,31,30,31,31,30,31,30,31",",",+XToday)
 . q:XToday'=2
 . s:((CurrYear#4)=0)&(((CurrYear#100)'=0)!((CurrYear#400)=0)) AgeDay=AgeDay+1
 i AgeMth<0 s AgeMth=AgeMth+12,AgeYear=AgeYear-1

 s $P(AgeYr,"|",12)=AgeYear
 i $P(AgeYr,"|",12)=0 d
 .i AgeMth=0 s reage=AgeDay_"天"
 .e  s reage=AgeMth_"月 "
 e  s reage=$p(AgeYr,"|",12)_"岁 "
  ;s reage=$p(AgeYr,"|",12)_"Y "_AgeMth_"M "_AgeDay_"D"
 q reage
}

ClassMethod GetPatientStatusDesc(Code) As %String
{
	s Desc=""
	s rowidP=$o(^DHCRBCStatusi("Code",Code,0))
	i rowidP'="" s Desc=$p(^DHCRBCStatus("PatientStatus",rowidP),"^",2) 
	q Desc
}

/// w ##class(web.DHCEkgPatientInfo).GetPaadmInfo("756")
ClassMethod GetPaadmInfo(paadmdr As %String) As %String
{
	 s DHCRisSystemInfo="",DHCRisVersion=""
     s RegNo1="",Name1="",Name2="",strAge="",strDOB="",IPNO="",LocName="",LocCode="",SexDr="",SafetynetCardNo=""
     s SexDesc="",typedesc="",ICDDesc="",patienttype="",wardname="",bedname=""
     s WardDr="",roomdesc="",feetype="",occuptiondr="",Occuption="",identifydr="",identify=""
     s DocName="",Docdr="",mradmdr="",Height="",Weight="",Telphone="",Adress=""
     s Prepaid=""
     s NationDesc=""
     s papatmasmdr=$p(^PAADM(paadmdr),"^",1)
     s paadmVisitStatus=$p(^PAADM(paadmdr),"^",20)
     
     ;南大二院需求，标准版无此接口
     ;i (paadmVisitStatus="P") d
     ;.s Prepaid=##Class(web.DHCExecIPAppointment).GetBedDescByEpisodeId(paadmdr)
     
     s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)  
     i RegNo="" q ""
     s Name=$p($g(^PAPER(papatmasmdr,"ALL")),"^",1)
     s Name2=$p($g(^PAPER(papatmasmdr,"ALL")),"^",2)
     s DOB=$p($g(^PAPER(papatmasmdr,"ALL")),"^",6)
     s identify=$p($g(^PAPER(papatmasmdr,"ALL")),"^",9)
     s occuptiondr=$p($g(^PAPER(papatmasmdr,"PER",2)),"^",6)
     i occuptiondr'="" d
     .s Occuption=$p($g(^CT("OCC",occuptiondr)),"^",2)
     i $g(^PAPER(papatmasmdr,"PAT",3))'="" d
     .s SafetynetCardNo=$p($g(^PAPER(papatmasmdr,"PAT",3)),"^",4)
     s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
     s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
     i DHCRisVersion="BJ_FX" d
     .i $g(^PAPER(papatmasmdr,"PER",4))'="" d
     ..s SafetynetCardNo=$p(^PAPER(papatmasmdr,"PER",4),"^",4)
     i DOB="" d
 	 .s strDOB=""
 	 .s strAge=""
 	 e  d
     .s strDOB=$ZD(DOB,3)
     .s strToday=$ZD(+$h,3)
     .s strAge=..CalAge(strDOB,strToday)
     s SexDr=$p($g(^PAPER(papatmasmdr,"ALL")),"^",7)
     i SexDr'="" s SexDesc=$p($g(^CT("SEX",SexDr)),"^",2)
     s patienttype=$p($g(^PAADM(paadmdr)),"^",2) ;病人类型
     s typedesc=..GetTypeDesc(patienttype)
  	 s Locdr=$p($g(^PAADM(paadmdr)),"^",4)
     i $g(Locdr)'="" s LocName=$p(^CTLOC(Locdr),"^",2) s LocCode=$p(^CTLOC(Locdr),"^",1)
	 s DHCRisSystemInfo=##class(web.DHCEkgSystemParam).GetSystemParam()
     s DHCRisVersion=$p(DHCRisSystemInfo,"^",15)
     s Adress=$p($g(^PAPER(papatmasmdr,"PER",4)),"^",18)
     i Adress="" s Adress=$g(^PAPER(papatmasmdr,"PER","ADD",1))
     i (DHCRisVersion="BJ_YY")!(DHCRisVersion="BJ_FX") d  
     .s IPNO=$p($g(^PAPER(papatmasmdr,"PER",4)),"^",4)   ;住院号(友谊/复兴医院）
     else  d
     .s IPNO=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",22)
     i DHCRisVersion="BJ_JST" d
     .i $g(^PAPER(papatmasmdr,"PER",4))'="" d
     ..s SafetynetCardNo=$p($g(^PAPER(papatmasmdr,"PER",4)),"^",4)
     ..s IPNO=$g(SafetynetCardNo) 
 
     if DHCRisVersion="BJ_AZ"  d
     .s Adress=$p(^PAPER(papatmasmdr,"PER",4),"^",18) //modify by sjc 修改取地址的方式

     s Roomdr=$p(^PAADM(paadmdr),"^",69)
     i Roomdr'="" s roomdesc=$p($g(^PAROOM(Roomdr)),"^",2)
     s WardDr=$p(^PAADM(paadmdr),"^",70)
     i WardDr'=""  d
     .s wardname=$p($g(^PAWARD(WardDr)),"^",2)
     .if (wardname["-") do
     ..s wardname=$p(wardname,"-",2)
     s beddr=$p(^PAADM(paadmdr),"^",73)
     i beddr'=""  d 
     .s wardrowid=$p(beddr,"||",1)
     .s bedchildsub=$p(beddr,"||",2)
     .;lpd 有的床位被删除了，找不到，pacs 查询会报错 20100709
     .i $D(^PAWARD(wardrowid,"BED",bedchildsub)) d
     ..s bedname=$p(^PAWARD(wardrowid,"BED",bedchildsub),"^",1)
     s admreasondr=$p(^PAADM(paadmdr,1),"^",7)
     i admreasondr'="" s feetype=$p(^PAC("ADMREA",admreasondr),"^",2)   ;费别
     s Docdr=$p(^PAADM(paadmdr),"^",9) ;;benna added
     s Telphone=$p(^PAPER(papatmasmdr,"PER",1),"^",11) 
     i $g(Docdr)'="" s DocName=$p($g(^CTPCP(Docdr,1)),"^",2)
     s mradmdr=$p(^PAADM(paadmdr),"^",61)
     i $g(mradmdr)'="" d
     .s Height=$p(^MR(mradmdr,"PRO",1),"^",20)
     .s Weight=$p(^MR(mradmdr,"PRO",1),"^",27)
     s NationDR=$p($g(^PAPER(papatmasmdr,"PER",2)),"^",1) //qzg 20090106
     i NationDR'="" s NationDesc = $p($g(^CT("NAT",NationDR)),"^",2)
     i NationDesc'="" s NationDesc=$p($g(NationDesc),"-",2)
     i DHCRisVersion="HN_XYOYY" d
     .Set CurrentNS=$ZNSPACE   
     .d ##class(web.DHCEkgSystemParam).SetWebNameSpace()
     .s HISINFO=##class(web.DHCENS.PatientInfo).GetHisAdmByPaadm(paadmdr)
	 .s RegNo=$p(HISINFO,"^",1)
	 .zn CurrentNS
     .i RegNo= "" s RegNo=$p($g(^PAPER(papatmasmdr,"PAT",1)),"^",1)  ;add 2090728 wf    
     s Info=RegNo_"^"_Name_"^"_strDOB_"^"_strAge_"^"_$g(SexDesc)_"^"_patienttype_"^"_typedesc_"^"_Locdr_"#"_$g(LocName)_"#"_LocCode_"^"_IPNO_"^"_wardname_"^"_bedname_"^"_$g(Locdr)_"^"_SexDr_"^"_WardDr_"^"_roomdesc_"^"_feetype_"^"_Docdr_"^"_DocName_"^"_Telphone_"^"_Height_"^"_Weight_"^"_Adress_"^"_SafetynetCardNo_"^"_Occuption_"^"_identify_"^"_NationDesc_"^"_Name2_"^"_Prepaid
	 q Info
}

ClassMethod GetDiagnose(paadmdr) As %String
{
	s ICDDesc="",Desc="",lDesc="",ICDDRDesc=""
    s mradmdr=$p(^PAADM(paadmdr),"^",61)
    s mradmdr=$p($g(^PAADM(paadmdr)),"^",61)
    s rtnDiagnose=""
    ;w mradmdr
    i mradmdr="" q ICDDesc
    s diachildsub=0  f  s diachildsub=$o(^MR(mradmdr,"DIA",diachildsub)) q:((diachildsub="")||($d(^MR(mradmdr,"DIA",diachildsub))=10))  d
    .s Count=$g(^MR(mradmdr,"DIA",diachildsub,"DES",0))
    .i Count="" s Count=0
    .for i=1:1:Count d
    ..s lDesc=$g(^MR(mradmdr,"DIA",diachildsub,"DES",i))
    ..s Desc=Desc_lDesc
    .s IDCCodeDR=$p(^MR(mradmdr,"DIA",diachildsub),"^",1)
    .i $g(IDCCodeDR)'=""  d
    ..s ICDDRDesc=$p($g(^MRC("ID",IDCCodeDR)),"^",2)
    .s ICDDesc=Desc_" "_ICDDRDesc
    .i (rtnDiagnose'="") s rtnDiagnose=rtnDiagnose_","_ICDDesc
    .e  s rtnDiagnose=ICDDesc
    q ICDDesc
}

Query QueryEQNO(paadmrowid As %String) As %Query(ROWSPEC = "Desc:%String,No:%String,EQDr:%String,EQDesc:%String,LocDR:%String,LocDesc:%String,rowid:%String")
{
}

ClassMethod QueryEQNOExecute(ByRef qHandle As %Binary, paadmrowid As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	s ind=1
	s papatmasdr=$p(^PAADM(paadmrowid),"^",1)
	i papatmasdr'="" d
	.s rowid=0  f  s rowid=$o(^DHCPACRegInfoNOi("adm",0,papatmasdr,rowid)) q:rowid=""  d 
	..s Desc=$p(^DHCPACRegInfoNO("NO",0,rowid),"^",4)
	..s No=$p(^DHCPACRegInfoNO("NO",0,rowid),"^",3)
	..s EQDesc="",Locdesc=""
	..s EQDR=$p(^DHCPACRegInfoNO("NO",0,rowid),"^",5)
	..i EQDR '="" s EQDesc=$p(^RBC("EQ",EQDR),"^",2)
	..s LocDR=$p(^DHCPACRegInfoNO("NO",0,rowid),"^",2)
	..i LocDR'="" s Locdesc=$p(^CTLOC(LocDR),"^",2) 
	..d outEQNO
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
outEQNO
	set Data=$lb(Desc,No,EQDR,EQDesc,LocDR,Locdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod QueryEQNOFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = QueryEQNOExecute ]
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

ClassMethod QueryEQNOClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = QueryEQNOExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
    Quit $$$OK
}

ClassMethod SetEQNo(Desc As %String, No As %String, EQDr As %String, LocID As %String, paadmdr As %String) As %String
{
	//s papatmasdr=$p(^PAADM(paadmrowid),"^",1)
	//&sql(insert into DHCRB_NO (RNO_Desc,RNO_NO, RNO_EQGroup_DR,RNO_LOC_DR,RNO_PAPATMAS_DR)values(:Desc,:No,:EQDr,:LocID,:paadmdr))
	//q SQLCODE
}

ClassMethod DeleteEQNo(rowid As %String) As %String
{
	//&sql(delete from DHCRB_NO where RNO_Rowid=:rowid)
	//q SQLCODE
}

ClassMethod ModiEQNo(rowid As %String, Desc As %String, No As %String, EQDr As %String) As %String
{
	//&sql(update DHCRB_NO (RNO_Desc,RNO_NO, RNO_EQGroup_DR ) values (:Desc,:No,:EQDr) where RNO_Rowid =:rowid)
	
	//q SQLCODE
}

ClassMethod IsDischargePatient(paadmdr) As %String
{
	s Discharge="N"
	s paadmtype=$p(^PAADM(paadmdr),"^",2)
	if paadmtype="I" d
	.s viststat=$p(^PAADM(paadmdr),"^",20)
	.i viststat="D"  s Discharge="Y"
	q Discharge
}

ClassMethod QueryBill(LocDr) As %String
{
   s IfFree="N"
   s LocRowid=0 s LocRowid=0 f  s LocRowid=$o(^DHCRBC("Loc",LocDr,LocRowid)) q:(LocRowid="")  d
   .s IfFree=$p(^DHCRBC("LocParam",LocRowid),"^",14)
   q IfFree
}

}
