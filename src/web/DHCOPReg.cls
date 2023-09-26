Include webimport

IncludeGenerator webimport

Class web.DHCOPReg Extends DHCDoc.Util.RegisteredObject [ ClassType = "", ProcedureBlock ]
{

ClassMethod RegPrint()
{
	w "<object ID='ClsDHCPrint' WIDTH=0 HEIGHT=0 CLASSID='CLSID:2759E092-B26D-4A60-B353-4F7402A4BC95' CODEBASE='../addins/client/DHCRegPring.CAB#version=1,0,0,1' VIEWASTEXT>"
	w "</object>"
}

ClassMethod PaadmFind(itmjs As %Library.String = "", itmjsex As %Library.String = "", RegNo As %Library.String = "")
{
 Set SysDate=..%SysDate()
 &sql(select count(paadm_rowid) into :CountNum from sqluser.pa_adm  where paadm_papmi_dr->papmi_no=:RegNo and paadm_admdate=:SysDate and paadm_visitstatus='A')

 set desc=$g(CountNum)
 //i SQLCODE s desc=CountNum q 0
 i CountNum=0 q 0
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"')"
 &javascript<#(retval)#>
 q 1
}

ClassMethod DocListBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s (id,code,desc)=""
 ; Try and find a matching code
 ;&sql(SELECT	CTLOC_Desc,CTLOC_RowID,CTLOC_Code 
 ;INTO	:desc, :id, :code
 ;FROM	SQLUser.CT_Loc
 ;WHERE	((%UPPER CTLOC_Desc = %UPPER :val) OR (%UPPER CTLOC_Code = %UPPER :val)))
 ;
 s RName=""
 s FID=val
 s AccMRowId=0
 s PapmiRowid=0  f  s PapmiRowid=$o(^PAPERi("PAPMI_PatNo",$ZCVT(FID,"U"),PapmiRowid)) q:PapmiRowid=""  d
	.s RName=$p($g(^PAPER(PapmiRowid,"ALL")),"^",1)
	.s RBirth=$ZD($p($g(^PAPER(PapmiRowid,"ALL")),"^",6),3)
	.s RIDCardNo=$p($g(^PAPER(PapmiRowid,"ALL")),"^",9)
	.s sexid=$p($g(^PAPER(PapmiRowid,"ALL")),"^",7)
	.s RSex=$p($g(^CT("SEX",sexid)),"^",2)
	.s RId=$p($g(^PAPER(PapmiRowid,"PAT",1)),"^",2) ;IP_No
	.s RTelNo=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",11) ;pa_person.paper_telh
	.s RInMedicare=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID("",PapmiRowid,"I","") ;pa_patmas.papmi_medicare
	.s ROpMedicare=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID("",PapmiRowid,"O","") ;paper_governcardno
	.;add by gwj *****
	.s CountryDR="",Countdesc=""
    .s provincedr="",provincedesc=""
    .s Rzipid="",Rzipcode=""
    .s citydr="",citydesc=""
    .s cityarea="",cityareaid=""
    .s CountryDR=$p(^PAPER(PapmiRowid,"PER",1),"^",8)
    .i CountryDR'=""  d
    ..i $d(^CT("COU",CountryDR))=0  d
    ...s CountryDR="",Countdesc=""
    ..e  d
    ...s Countdesc=$p(^CT("COU",CountryDR),"^",2)
    ...i $f(Countdesc,"-")'=0  d 
	....s Countdesc=$p(Countdesc,"-",2)
    .s provincedr=$p(^PAPER(PapmiRowid,"PER",4),"^",2)
    .i provincedr'=""  d
    ..i $d(^CT("PROV",provincedr))=0  d
	...s provincedr="",provincedesc=""
	..e  d
	...s provincedesc=$p(^CT("PROV",provincedr),"^",2)
	...i $f(provincedesc,"-")'=0  d 
	....s provincedesc=$p(provincedesc,"-",2)
	.s citydr=$p(^PAPER(PapmiRowid,"PER",1),"^",5)
	.i citydr'=""  d
	..i $d(^CT("CIT",citydr))=0  d
	...s citydr=""
	...s citydesc=""
	..e  d
	...s citydesc=$p(^CT("CIT",citydr),"^",2)
	...i $f(citydesc,"-")'=0  d
	....s citydesc=$p(citydesc,"-",2) 
    .s Rzipid=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",7)  ;PAPER_Zip_DR 
    .i Rzipid'=""  d
    ..i $d(^CT("ZIP",Rzipid))=0  d
	...s Rzipid=""
	...s Rzipcode=""
	..e  s Rzipcode=$p($g(^CT("ZIP",Rzipid)),"^",1) 
	.s cityareaid=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",9)
	.i cityareaid'=""  d
	..i (($d(^CT("CITAREA",cityareaid))=0)!(^CT("CITAREA",cityareaid)=10))  d
	...s cityareaid="",cityarea=""
	..e  d
	...s cityarea=$p(^CT("CITAREA",cityareaid),"^",2)
	...i $f(cityarea,"-")'=0  d
	....s cityarea=$p(cityarea,"-",2) 
	.s INSUNO=$P($G(^PAPER(PapmiRowid,"PAT",2)),"^",6)  ;PAPMI_Medicarecode 
    .;*****
	.s soc=""
	.s RPatType=""
	.s socialstatus=$p($g(^PAPER(PapmiRowid,"PER",1)),"^",10) 
	.i socialstatus'="" d
	..s RPatType=$p($g(^CT("SS",socialstatus)),"^",2)      ;paper_socialstatus_dr->ss_desc
    .s RCompany=$p($g(^PAPER(PapmiRowid,"PER",4)),"^",18) 
    .s RAddress=$p($g(^PAPER(PapmiRowid,"PER","ADD",1)),"^",1) 
    .s AccMRowId=$o(^DHCACDi("AccM",0,"PAPMI",PapmiRowid,AccMRowId))  ;DHC_Accmanager
    .i AccMRowId'=""  s RCredType=$p(^DHCACD("AccM",AccMRowId),"^",17)
    .i AccMRowId'=""  s RCredNo=$p(^DHCACD("AccM",AccMRowId),"^",18)    
 S desc=$g(RName)_"^"_$g(RBirth)_"^"_$g(RSex)_"^"_$g(RIDCardNo)_"^"_$g(RTelNo)_"^"_$g(RInMedicare)_"^"_$g(RPatType)_"^"_$g(RAddress)_"^"_$g(ROpMedicare)_"^"_$g(RCompany)_"^"_$g(RCredNo)_"^"_$g(RCredType)
 s desc=desc_"^"_$G(CountryDR)_"^"_$g(Countdesc)_"^"_$g(Rzipid)_"^"_$g(Rzipcode)_"^"_$g(provincedr)_"^"_$g(provincedesc)_"^"_$g(citydr)_"^"_$g(citydesc)_"^"_$g(cityarea)_"^"_$g(cityareaid)_"^"_INSUNO
 s ^DHCApp=desc
 
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
 &javascript<#(retval)#>
 q desc
}

ClassMethod DupNameBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s (id,code,desc)=""
 ;
 ; Try and find a matching code
 &sql(SELECT count(PAPMI_Name) 
 INTO	:CountNum
 FROM	sqluser.PA_PatMas
 WHERE	%UPPER PAPMI_Name = %UPPER :val)
 ;
 set desc=$g(CountNum)
 i SQLCODE s desc=val q 0
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod DupIDCardNoBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s (id,code,desc)=""
 ;
 ; Try and find a matching code
 &sql(SELECT count(PAPMI_ID) 
 INTO	:CountNum
 FROM	sqluser.PA_PatMas
 WHERE	%UPPER PAPMI_ID = %UPPER :val)
 ;
 set desc=$g(CountNum)
 i SQLCODE s desc=val q 0
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

ClassMethod GetEncrypt(Method As %String)
{
	s encmeth=##Class(%CSP.Page).Encrypt($lb(Method))
	Quit encmeth
}

ClassMethod CommitPatDetail(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 s (id,code,desc)=""
	
 ;
 ; Try and find a matching code
 ;取参数

 s IDpar=$ZCVT($p($g(val),"^",1),"U")
 s Namepar=$p($g(val),"^",2)
 s Sexpar=$p($g(val),"^",3)
 s Birthpar=$p($g(val),"^",4)
 s TelNopar=$p($g(val),"^",5)
 s OpMedicare=$p($g(val),"^",6)
 s InMedicare=$p($g(val),"^",7)
 s PatType=$p($g(val),"^",8)
 s IDCardNo1=$p($g(val),"^",9)
 s Vocation=$p($g(val),"^",10)
 s Company=$p($g(val),"^",11)
 s Address=$p($g(val),"^",12)
 s CredNo=$p($g(val),"^",13)
 s CredType=$p($g(val),"^",14)
 s Zipcode=$p($g(val),"^",15)
 s CityDr=$p($g(val),"^",16)
 s ProvDr=$p($g(val),"^",17)
 s Cityarea=$p($g(val),"^",18)
 s CountryDr=$p($g(val),"^",19)
 s PatINSUNO=$p($g(val),"^",20)
  s SexDr=0
  s SexDr=$o(^CT("SEX",0,"Desc",Sexpar,SexDr))
  
  s PatTypeDr=0
  s PatTypeDr=$o(^CT("SS",0,"Desc",$g(PatType),PatTypeDr))
  
  s Birthpar=$ZDH(Birthpar,3)
  //s =$p($g(val),"^",4)
  S IDrowid=0
  s IDrowid=$o(^PAPERi("PAPMI_PatNo",IDpar,IDrowid))

 //Set Config=##Class(websys.Configuration).%OpenId(1)
 //Set MEDDATA=Config.DataNamespace            
 //Set LABDATA=Config.LabDataNamespace         
 //Set CurrentNS=$ZNSPACE                     
 //ZN MEDDATA            
          
 d UpdatePatInfo^DHCOPUpdatePatInfo(IDrowid,Namepar,SexDr,Birthpar,IDCardNo1,OpMedicare,PatTypeDr,TelNopar,Company,Zipcode,CityDr,ProvDr,Cityarea,CountryDr) 
 //ZN CurrentNS  
 
 S ^PAPER(IDrowid,"PER","ADD",0)=1
 S ^PAPER(IDrowid,"PER","ADD",1)=Address
 s PAPMIRowID=0
 s AccMRowId=0
 s PAPMIRowID=$o(^PAPERi("PAPMI_PatNo",IDpar,PAPMIRowID))
 s AccMRowId=$o(^DHCACDi("AccM",0,"PAPMI",PAPMIRowID,AccMRowId))
 
 i AccMRowId'=""  s $p(^DHCACD("AccM",AccMRowId),"^",17)=CredType
 i AccMRowId'=""  s $p(^DHCACD("AccM",AccMRowId),"^",18)=CredNo
 &sql(update sqluser.pa_patmas set papmi_medicare =:InMedicare,papmi_medicarecode=:PatINSUNO
   	where papmi_no=:IDpar)
  ;
  
	 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
	 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
 	&javascript<#(retval)#>
	 q 1
 //}
}

ClassMethod PatTypeBroker(itmjs As %Library.String = "", itmjsex As %Library.String = "", val As %Library.String = "")
{
 n (id,code,desc)
 ;
 s (id,code,desc)=""
 ;
 ; Try and find a matching code
 &sql(SELECT ss_desc,ss_rowid,ss_code 
 INTO	:desc, :id, :code
 FROM	sqluser.CT_SocialStatus
 WHERE	((%UPPER ss_desc = %UPPER :val) OR (%UPPER ss_code = %UPPER :val)))
 ;
 i SQLCODE s desc=val q 0
 s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 i itmjsex'="""" s retval=retval_itmjsex_"('"_$ZCVT(desc,"O","JS")_"^"_id_"^"_$ZCVT(code,"O","JS")_"');"
 &javascript<#(retval)#>
 q 1
}

Query LookUp() As %SQLQuery(CONTAINID = 1, ROWSPEC = "类型:%String,代码:%String")
{
SELECT ss_desc,ss_code 
 FROM sqluser.CT_SocialStatus
}

// 取科室

ClassMethod OPLoclookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = OPLoclookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod OPLoclookupExecute(ByRef qHandle As %Binary, desc As %String, hospid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    s desc=$$ALPHAUP^SSUTIL4(desc)
    If $g(ind)="" Set ind=1
	s OPLocdesc="",rowid="0"
	Set langid=..%LanguageID()
	s rowid="0"
	f  s rowid=$o(^PAC("ADMLOC",0,"AdmType","O",rowid))  q:rowid=""  d
	.s ActiveFlag=$p(^CTLOC(rowid),"^",14)
	.q:ActiveFlag="N"
	.s DateFrom=$p(^CTLOC(rowid),"^",24)
	.q:(DateFrom'="")&&(DateFrom>+$h)
	.s DateTo=$p(^CTLOC(rowid),"^",25)
	.q:(DateTo'="")&&(DateTo<+$h)
	.s OPLocdesc=$p(^CTLOC(rowid),"^",2)
	.//s OPLocdesc=$$ALPHAUP^SSUTIL4(OPLocdesc)
	.s LocHospId=$p(^CTLOC(rowid),"^",22)
	.q:(hospid'="")&&(LocHospId'=hospid)
	.s OPLocdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OPLocdesc,langid)
	.i desc'=""  d
	..//i $$ALPHAUP^SSUTIL4(OPLocdesc)[desc  d
	..i ##class(web.DHCOPAdmReg).CheckLocDesc(rowid,desc)=1 d 
	...d OutputRow9
 	.e  d
 	..d OutputRow9
	s rowid="0"
	f  s rowid=$o(^PAC("ADMLOC",0,"AdmType","E",rowid))  q:rowid=""  d
	.s ActiveFlag=$p(^CTLOC(rowid),"^",14)
	.q:ActiveFlag="N"
	.s DateFrom=$p(^CTLOC(rowid),"^",24)
	.q:(DateFrom'="")&&(DateFrom>+$h)
	.s DateTo=$p(^CTLOC(rowid),"^",25)
	.q:(DateTo'="")&&(DateTo<+$h)
	.s OPLocdesc=$p(^CTLOC(rowid),"^",2)
	.s OPLocdesc=##class(User.CTLoc).GetTranByDesc("CTLOCDesc",OPLocdesc,langid)
	.//s OPLocdesc=$$ALPHAUP^SSUTIL4(OPLocdesc)
	.s LocHospId=$p(^CTLOC(rowid),"^",22)
	.q:(hospid'="")&&(LocHospId'=hospid)
	.i desc'=""  d
	..//i $$ALPHAUP^SSUTIL4(OPLocdesc)[desc  d
	..i ##class(web.DHCOPAdmReg).CheckLocDesc(rowid,desc)=1 d 
	...d OutputRow9
 	.e  d
 	..d OutputRow9
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow9
    s OPLocdesc=##class(web.DHCOPAdmReg).LocDescFormate(OPLocdesc)
    s CTLocContactName=$P(^CTLOC(rowid),"^",43)
	set Data=$lb(OPLocdesc,rowid,CTLocContactName)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod OPLoclookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = OPLoclookupExecute ]
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

Query OPLoclookup(desc As %String, hospid As %String) As %Query(ROWSPEC = "OPLocdesc:%String,rowid:%String,Alias:%String") [ SqlProc ]
{
}

ClassMethod InsertPatInfo(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	
	s desc=0
	//该程序不用
	
	 Set Detail=##Class(web.DHCOPReg).InsertPatInfo1("0")
	s retval=itmjs_"('"_$ZCVT(desc,"O","JS")_"');"
 	&javascript<#(retval)#>
	
	q desc
}

ClassMethod InsertPatInfo1(CPDr As %String) As %String
{
	
	s desc=0
	s file="/trakcare/BACKUP/Pmi.txt"
	;s $zt="close^"_$zn
	s num=0
	s ^DHCApp(0)=1
	w "File Upload Starting...",!
	o file:"RS":2
	u file
	For  d
	.r sRec
	.s num=num+1
	.s ^DHCApp(0)=num
	.s name=$p($g(sRec),",",1)
	.s sex=$p($g(sRec),",",2)
	.s Birthday=$p($g(sRec),",",3)
	.;s Birthday=$p($zd($h-(Birthday*365),3),"-",1)
	.;s Birthday=Birthday_"-01-01"
	.s Telphone=$p($g(sRec),",",4)
	.s Opmedicare=$p($g(sRec),",",5)
	.s Inmedicare=$p($g(sRec),",",6)
	.s Commpany=$p($g(sRec),",",8)
	.s Address=$p($g(sRec),",",9)	
	.s ^DHCApp(num)=name_"^"_sex_"^"_Birthday_"^"_Inmedicare_"^"_Opmedicare_"^"_Commpany_"^"_Address_"^"_Telphone
	;.&sql(insert into sqluser.DHCOPPatInfo (name,sex,Birthday,Inmedicare,Opmedicare,Commpany,Address,Telphone) values(:name,:sex,:Birthday,:Inmedicare,:Opmedicare,:Commpany,:Address,:Telphone))
 
	;s desc=desc+SQLCODE
	
	q num
}

ClassMethod GetCredType(id As %String) As %String
{
	k ^cjbtest
	s id=0
	s InStr=""
	s i=0
	f  s id=$o(^DHCACCCredType(id)) q:id=""  d
	.s CRTCode=$p(^DHCACCCredType(id),"^",1)
	.s CRTDesc=$p(^DHCACCCredType(id),"^",2)
	.s InStr=InStr_","_id_"^"_CRTCode_"^"_CRTDesc
	.s i=i+1
	q InStr
}

ClassMethod admContlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admprovlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admContlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    s desc=$$ALPHAUP^SSUTIL4(desc)
    If $g(ind)="" Set ind=1
	s contdesc="",rowid="0"
	d OutputRow8
	s rowid="0"
	f  s rowid=$o(^CT("COU",rowid))  q:rowid=""  d
	.s contdesc=$p(^CT("COU",rowid),"^",2)
	.s cotdesc1=$$ALPHAUP^SSUTIL4(contdesc)
	.i $f(contdesc,"-")'=0  d
	..s contdesc=$p(contdesc,"-",2)
	.i desc'=""  d
	..i contdesc[desc  d
	...i $f(contdesc,"-")'=0  d
    ....s contdesc=$p(contdesc,"-",2)
    ...d OutputRow8
 	.e  d
 	..i $f(contdesc,"-")'=0  d
    ...s contdesc=$p(contdesc,"-",2)
    ..d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
    
	set Data=$lb(contdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admContlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admContlookupExecute ]
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

Query admContlookup(desc As %String) As %Query(ROWSPEC = "Contdesc:%String,Contid:%String")
{
}

ClassMethod admprovlookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admprovlookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admprovlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    s desc=$$ALPHAUP^SSUTIL4(desc)
    If $g(ind)="" Set ind=1
	s provdesc="",rowid="0"
	d OutputRow8
	s rowid="0"
	f  s rowid=$o(^CT("PROV",rowid))  q:rowid=""  d
	.s provdesc=$p(^CT("PROV",rowid),"^",2)
	.s provdesc1=$$ALPHAUP^SSUTIL4(provdesc)
	.i $f(provdesc,"-")'=0  d
	..s provdesc=$p(provdesc,"-",2)
	.i desc'=""  d
	..i provdesc1[desc  d
	...i $f(provdesc,"-")'=0  d
    ....s provdesc=$p(provdesc,"-",2)
    ...d OutputRow8
 	.e  d
 	..i $f(provdesc,"-")'=0  d
    ...s provdesc=$p(provdesc,"-",2)
    ..d OutputRow8
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow8
    
	set Data=$lb(provdesc,rowid)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admprovlookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admprovlookupExecute ]
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

Query admprovlookup(desc As %String) As %Query(ROWSPEC = "provdesc:%String,provid:%String")
{
}

ClassMethod admziplookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admziplookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admziplookupExecute(ByRef qHandle As %Binary, desc As %String, provid As %String, cityid As %String, cityareaid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    s desc=$$ALPHAUP^SSUTIL4(desc)
    If $g(ind)="" Set ind=1
	s zipdesc="",zipcode="",cityarea="",citydesc="",provdesc=""
	s rowid="0",cityareadr="",citydr="",provdr=""
	d OutputRow6
	s rowid="0"
	f  s rowid=$o(^CT("ZIP",rowid))  q:rowid=""  d
	.s zipdesc=$p(^CT("ZIP",rowid),"^",2)
	.s zipdesc1=$$ALPHAUP^SSUTIL4(zipdesc)
	.s zipcode=$p(^CT("ZIP",rowid),"^",1)
	.s citydr=$p(^CT("ZIP",rowid),"^",6)
	.s provdr=$p(^CT("ZIP",rowid),"^",4)
	.s cityareadr=$p(^CT("ZIP",rowid),"^",7)
	.q:(citydr="")
	.q:(provdr="")
	.;q:(cityareadr="")
	.q:($d(^CT("CIT",citydr))=0)
	.q:($d(^CT("PROV",provdr))=0)
	.;q:($d(^CT("CITAREA",cityareadr))=0)
	.q:(cityid'="")&(cityid'=citydr)
	.q:(provid'="")&(provid'=provdr)
	.;q:(cityareaid'="")&(cityareaid'=cityareadr)
	.;s cityarea=$p(^CT("CITAREA",cityareadr),"^",2)
	.i $f(cityarea,"-")'=0  d
	..s cityarea=$p(cityarea,"-",2)
	.s citydesc=$p(^CT("CIT",citydr),"^",2)
	.i $f(citydesc,"-")'=0  d
	..s citydesc=$p(citydesc,"-",2)
	.s provdesc=$p(^CT("PROV",provdr),"^",2)
	.i $f(provdesc,"-")'=0  d
	..s provdesc=$p(provdesc,"-",2)
	.i desc'=""  d
	..i zipdesc1[desc  d
	...i $f(zipdesc,"-")'=0  d
    ....s zipdesc=$p(zipdesc,"-",2)
    ...d OutputRow6
 	.e  d
 	..i $f(zipdesc,"-")'=0  d
    ...s zipdesc=$p(zipdesc,"-",2)
    ..d OutputRow6
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow6
    
	set Data=$lb(zipdesc,zipcode,cityarea,citydesc,provdesc,rowid,cityareadr,citydr,provdr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admziplookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admziplookupExecute ]
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

Query admziplookup(desc As %String, provid As %String, cityid As %String, cityareaid As %String) As %Query(ROWSPEC = "zipdesc:%String,zipcode:%String,cityarea:%String,citydesc:%String,provdesc:%String,zipid:%String,cityareaid:%String,cityid:%String,provid:%String")
{
}

ClassMethod cityarealookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = cityarealookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod cityarealookupExecute(ByRef qHandle As %Binary, desc As %String, cityid As %String, provid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    
    s desc=$$ALPHAUP^SSUTIL4(desc)
    s stdate=..%SysDate()
    If $g(ind)="" Set ind=1
	s ctdesc="",citydesc="",rowid="0" ,citydr=""
	s provdesc="",provdr="" 
    d OutputRow22
	s rowid="0"
	f  s rowid=$o(^CT("CITAREA",rowid))  q:rowid=""  d
	.q:($d(^CT("CITAREA",rowid))=0)
	.s ctdesc=$p(^CT("CITAREA",rowid),"^",2)
	.s citydr=$p(^CT("CITAREA",rowid),"^",3)
	.q:(citydr="")
	.q:(cityid'="")&(citydr'=cityid)
	.s provdr=$p(^CT("CIT",citydr),"^",4)
	.q:(provdr="")
	.q:(provid'="")&(provdr'=provid)
	.s provdesc=""
	.i (($d(^CT("PROV",provdr))'=0)&($d(^CT("PROV",provdr))'=10))  d
	..s provdesc=$p(^CT("PROV",provdr),"^",2)
	..i $f(provdesc,"-")'=0  d
	...s provdesc=$p(provdesc,"-",2)
	.s citydesc=""
	.i ($d(^CT("CIT",citydr))'=0)&($d(^CT("CIT",citydr))'=10)  d
	..s citydesc=$p(^CT("CIT",citydr),"^",2)
	..i $f(citydesc,"-")'=0  d
	...s citydesc=$p(citydesc,"-",2)
	.s ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	.s actstdate=$p(^CT("CITAREA",rowid),"^",4)
	.s actenddate=$p(^CT("CITAREA",rowid),"^",5)
	.q:(actstdate'="")&(actstdate>stdate)
	.q:(actenddate'="")&(actenddate<stdate)
	.i desc'=""  d
	..i ctdesc1[desc  d
	...i $f(ctdesc,"-")'=0  d
    ....s ctdesc=$p(ctdesc,"-",2)
    ...d OutputRow22
 	.e  d
 	..i $f(ctdesc,"-")'=0  d
    ...s ctdesc=$p(ctdesc,"-",2)
    ..d OutputRow22
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
	
OutputRow22    
	set Data=$lb(ctdesc,citydesc,provdesc,rowid,citydr,provdr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod cityarealookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = cityarealookupExecute ]
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

Query cityarealookup(desc, cityid, provid) As %Query(ROWSPEC = "cityarea:%String,ciytdesc:%String,provdesc:%String,cityareaid:%String,citydr:%String,provdr:%String")
{
}

ClassMethod admcitylookupClose(ByRef qHandle As %Binary) As %Status [ PlaceAfter = admcitylookupExecute ]
{
	Set repid=$LIST(qHandle,2)
 	Kill ^CacheTemp(repid)
 	Quit $$$OK
}

ClassMethod admcitylookupExecute(ByRef qHandle As %Binary, desc As %String, provid As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
    s desc=$$ALPHAUP^SSUTIL4(desc)
    If $g(ind)="" Set ind=1
	s citydesc="",provdesc="",rowid="0",provdr=""
	d OutputRow7
	s rowid="0"
	f  s rowid=$o(^CT("CIT",rowid))  q:rowid=""  d
	.s citydesc=$p(^CT("CIT",rowid),"^",2)
	.s citydesc1=$$ALPHAUP^SSUTIL4(citydesc)
	.s provdr=$p(^CT("CIT",rowid),"^",4)
	.q:(provdr="")
	.q:(provid'="")&(provdr'=provid)
	.s provdesc=$p(^CT("PROV",provdr),"^",2)
	.i $f(provdesc,"-")'=0  d
	..s provdesc=$p(provdesc,"-",2)
	.i desc'=""  d
	..i citydesc1[desc  d
	...i $f(citydesc,"-")'=0  d
    ....s citydesc=$p(citydesc,"-",2)
    ...d OutputRow7
 	.e  d
 	..i $f(citydesc,"-")'=0  d
    ...s citydesc=$p(citydesc,"-",2)
    ..d OutputRow7
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRow7
    
	set Data=$lb(citydesc,provdesc,rowid,provdr)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

ClassMethod admcitylookupFetch(ByRef qHandle As %Binary, ByRef Row As %List, ByRef AtEnd As %Integer = 0) As %Status [ PlaceAfter = admcitylookupExecute ]
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

Query admcitylookup(desc As %String, provid As %String) As %Query(ROWSPEC = "citydesc:%String,provdesc:%String,cityid:%String,provid:%String")
{
}

}
