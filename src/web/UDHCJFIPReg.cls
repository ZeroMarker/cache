Import SQLUser

Class web.UDHCJFIPReg Extends %Library.RegisteredObject [ ClassType = "", Not ProcedureBlock ]
{

Query admdeplookup(desc As %String, UserDepID As %String) As websys.Query(ROWSPEC = "dep:%String,depid:%String,ctContactName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPReg", "admdeplookup", "内分泌科", "197")
ClassMethod admdeplookupExecute(ByRef qHandle As %Binary, desc As %String, UserDepID As %String) As %Status
{
  	set repid=$I(^CacheTemp)
	set qHandle=$lb(0,repid,0)
	set ind=1

 	if (desc'="") do
    .set desc=$$ALPHAUP^SSUTIL4(desc)
    
    set UserDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(UserDepID)
	set rowid="0"
	for  set rowid=$o(^PAC("ADMLOC",0,"AdmType","I",rowid))  quit:(rowid="")  do
	.quit:($d(^CTLOC(rowid))=0)
	.set DepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(rowid)
	.quit:((UserDepHosDr'=DepHosDr)&&(UserDepHosDr'="")&&(DepHosDr'=""))
	.set ctdesc=$p(^CTLOC(rowid),"^",2)
	.set ctContactName=$p(^CTLOC(rowid),"^",43)   //科室检索码
	.quit:((desc'="")&&($$ALPHAUP^SSUTIL4(ctContactName)'[desc)&&($$ALPHAUP^SSUTIL4(ctdesc)'[desc))
	.set:($f(ctdesc,"-")'=0) ctdesc=$p(ctdesc,"-",2)
    .do OutputRow

	quit $$$OK
OutputRow
	set Data=$lb(ctdesc,rowid,ctContactName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query admwardlookup(admdepid As %String, desc As %String) As websys.Query(ROWSPEC = "ward:%String,wardid:%String,ctContactName:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPReg", "admwardlookup","","")
ClassMethod admwardlookupExecute(ByRef qHandle As %Binary, admdepid As %String, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set ind=1
	set qHandle=$lb(0,repid,0)
	
    if (admdepid="")  quit $$$OK
    
    if (desc'="") do
	.set desc=$$ALPHAUP^SSUTIL4(desc)
	
	set childid="0"
	for  set childid=$o(^CTLOC(admdepid,"LINK",childid))  quit:(childid="")  do
	.set linkid=$p(^CTLOC(admdepid,"LINK",childid),"^",1)
	.quit:($d(^CTLOC(linkid))=0)
	.set loctype=$p(^CTLOC(linkid),"^",13)
	.quit:(loctype'="W")
	.set ctdesc=$p(^CTLOC(linkid),"^",2)
	.set rowid=$o(^PAWARD(0,"WARD_LocationDR",linkid,""))
	.set ctContactName=$p(^CTLOC(linkid),"^",43)   //科室检索码
	.quit:((desc'="")&&($$ALPHAUP^SSUTIL4(ctContactName)'[desc)&&($$ALPHAUP^SSUTIL4(ctdesc)'[desc))
    .set:($f(ctdesc,"-")'=0) ctdesc=$p(ctdesc,"-",2)
    .do OutputRow1
 	
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow1
    set Data=$lb(ctdesc,rowid,ctContactName)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query admdoclookup(admdepid As %String, desc As %String) As websys.Query(ROWSPEC = "name:%String,id:%String,depname:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPReg","admdoclookup","","")
ClassMethod admdoclookupExecute(ByRef qHandle As %Binary, admdepid As %String, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
 	if (admdepid="") set qHandle=$lb(0,repid,0) quit $$$OK
 	//RB_Resource
 	kill ^||TMP($j)
	set desc=$$ALPHAUP^SSUTIL4(desc)
	set rowid="0"
	for  set rowid=$o(^RB("RES",0,"CTLOC",admdepid,rowid))  quit:(rowid="")  do
	.set rbpcpdr=$p(^RB("RES",rowid),"^",2)
	.quit:($d(^CTPCP(rbpcpdr))=0)
	.quit:($d(^||TMP($j,rbpcpdr)))   //去重
	.set ^||TMP($j,rbpcpdr)=""
	.set activeFlag=$p(^CTPCP(rbpcpdr,1),"^",9)
	.quit:(activeFlag'="Y")
	.set name=$p(^CTPCP(rbpcpdr,1),"^",2)
	.;2015-3-18 hujunbin 添加过滤
	.set code=$p(^CTPCP(rbpcpdr,1),"^",1)
	.set UpName=$$ALPHAUP^SSUTIL4(name)
	.set UpCode=$$ALPHAUP^SSUTIL4(code)
	.quit:((UpName'[desc)&&(UpCode'[desc))
	.set id=rbpcpdr
	.set depname=$p(^CTLOC(admdepid),"^",2)
	.do OutputRow3
	
	kill ^||TMP($j)
	
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow3
	set Data=$lb(name,id,depname)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query admsearchlookup(papmiid As %String, UserDepID As %String = "") As websys.Query(ROWSPEC = "admno:%String,papno:%String,papname:%String,admdate:%String,admtime:%String,admdept:%String,admward:%String,admbed:%String,admstatus:%String,admid:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPReg","admsearchlookup", "9", "300")
ClassMethod admsearchlookupExecute(ByRef qHandle As %Binary, papmiid As %String, UserDepID As %String = "") As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
	set qHandle=$lb(0,repid,0)
	if (papmiid="")  quit $$$OK
	set UserDepID=$g(UserDepID)
	
    set UserDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(UserDepID)
    
	set rowid=0
	for  set rowid=$o(^PAPERdr(papmiid,"ADM","I",rowid))  quit:(rowid="")  do
	.quit:($d(^PAPER(papmiid))=0)
	.&sql(SELECT papmi_no,papmi_name into :papno,:papname from pa_patmas where papmi_rowid=:papmiid)
	.set papno=$p(papno,$c(1))
	.set papname=$p(papname,$c(1))
	.set admno=$p(^PAADM(rowid),"^",81)
	.set admdate=$p(^PAADM(rowid),"^",6)
	.set admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
	.set admtime=$p(^PAADM(rowid),"^",7)
	.set admtime=##class(websys.Conversions).TimeLogicalToHtml(admtime, 1)
	.set admdeptid=$p(^PAADM(rowid),"^",4)
	.set AdmDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(admdeptid)
	.quit:((AdmDepHosDr'=UserDepHosDr)&(AdmDepHosDr'="")&(UserDepHosDr'=""))
	.quit:($d(^CTLOC(admdeptid))=0)
	.set admdept=$p(^CTLOC(admdeptid),"^",2)
	.if (admdept'="") do
	..if ($f(admdept,"-")'=0)  do
	...set admdept=$p(admdept,"-",2)
	.set admwardid=$p(^PAADM(rowid),"^",70)
	.quit:($g(admwardid)="") 
	.quit:($d(^PAWARD(admwardid))=0)
	.set admward=$p(^PAWARD(admwardid),"^",2)
	.if (admward'="")  do
	..if ($f(admward,"-")'=0)  do
	...set admward=$p(admward,"-",2)
	.set admbedid=$p(^PAADM(rowid),"^",73)
	.set admbed=""
	.set admbed=##class(web.DHCBillCommon).GetPatBedCode(rowid)
	.set admstatus=$p(^PAADM(rowid),"^",20)
	.quit:(admstatus="P")
	.if (admstatus="A")  set admstatus="在院"
	.if (admstatus="C")  set admstatus="取消住院"
	.if (admstatus="D")  set admstatus="出院"
	.if (admstatus="P")  set admstatus="预住院"
	.do OutputRow4
 	
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow4
	set Data=$lb(admno,papno,papname,admdate,admtime,admdept,admward,admbed,admstatus,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod getdatetime()
{
	set stdate="",sttime=""
	set stdate=##class(websys.Conversions).DateLogicalToHtml(+$h)
	set sttime=##class(websys.Conversions).TimeLogicalToHtml($p($h,",",2),1)
	quit stdate_"^"_sttime
}

ClassMethod GetadmreasonId(itmjs As %Library.String = "", itmjsex As %Library.String = "")
{
	&sql(select rea_rowid into :rearowid from pac_admreason where rea_desc like '自费%')
	quit rearowid
}

Query admbedlookup(wardid As %String, bedno As %String, sexdr As %String) As websys.Query(ROWSPEC = "beddesc:%String,warddesc:%String,roomdesc:%String,bedtype:%String,bedstatus:%String,roomtype:%String,roomstatus:%String,roomid:%String,bedid:%String")
{
}

ClassMethod admbedlookupExecute(ByRef qHandle As %Binary, wardid As %String, bedno As %String, sexdr As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
 	set qHandle=$lb(0,repid,0)
    if (wardid="")  quit $$$OK
    
	set stdate=+$h
	set bedid="0"  
	for  set bedid=$o(^PAWARD(wardid,"BED",bedid))  quit:(bedid="")  do
	.set beddesc=$p(^PAWARD(wardid,"BED",bedid),"^",1)
	.quit:((bedno'="")&&(bedno[beddesc))
	.set datefrom=$p(^PAWARD(wardid,"BED",bedid),"^",21)
	.set dateto=$p(^PAWARD(wardid,"BED",bedid),"^",22)
	.quit:(datefrom'="")&(stdate<datefrom)
	.quit:(dateto'="")&&(stdate>dateto)
	.set roomid=$p(^PAWARD(wardid,"BED",bedid),"^",3)
	.quit:($d(^PAROOM(roomid))=0)
	.set rmdtfrom=$p(^PAROOM(roomid),"^",8)
	.set rmdtto=$p(^PAROOM(roomid),"^",9)
	.quit:(rmdtfrom'="")&(stdate<rmdtfrom)
	.quit:(rmdtto'="")&(stdate>rmdtto)
	.set flag=..checkini(wardid, bedid)
	.quit:(flag["N")
	.set rmsexdiff=$p(^PAROOM(roomid),"^",4)
	.set bedid1=""
	.set bednum=0
	.for bedid1=$o(^PAWARD("BED_Room_DR",roomid,wardid,bedid1))  quit:(bedid1="")  do
	..set bedadmid=""
	..for  set bedadmid=$o(^PAWARDA(wardid,"BED",bedid1,"ADM",bedadmid))  quit:(bedadmid="")  do
	...set admno=$p(^PAWARDA(wardid,"BED",bedid1,"ADM",bedadmid),"^",1)
	...quit:($d(^PAADM(admno))=0)
	...set admvisit=$p(^PAADM(admno),"^",20)
	...quit:(admvisit'="A")
	...set papmiid=$p(^PAADM(admno),"^",1)
	...quit:($d(^PAPER(papmiid))=0)
	...set admsexdr=$p(^PAPER(papmiid,"ALL"),"^",7)
	...if (admsexdr'=sexdr)&&(sexdr'="")  do
	....set bednum=bednum+1
	.quit:(bednum>0)&(rmsexdiff="N")
	.if (rmsexdiff="D")  do
	..set roomstatus="正常"
	.else  if (rmsexdiff="W")  do
	..set roomstatus="警告"
	.set roomtypeid=$p(^PAROOM(roomid),"^",3)
	.quit:(roomtypeid="")
	.quit:($d(^PAC("ROOMT",roomtypeid))=0)
	.set roomtype=$p(^PAC("ROOMT",roomtypeid),"^",2)
	.set roomdesc=$p(^PAROOM(roomid),"^",2)
	.set bedtypeid=$p(^PAWARD(wardid,"BED",bedid),"^",2)
	.quit:(bedtypeid="")
	.quit:($d(^PAC("BEDTP",bedtypeid))=0)
	.set bedtype=$p(^PAC("BEDTP",bedtypeid),"^",2)
	.set bedrowid=wardid_"||"_bedid
	.&sql(SELECT BED_Available INTO :bedavail 
	      FROM pac_bed WHERE bed_rowid=:bedrowid)
	.set bedavail=$p(bedavail,$c(1))
	.quit:(bedavail="N")
	.if (bedavail="N")  do
	..set bedstatus="使用中"
	.else  do
	..set bedstatus="空"
	.set warddesc=$p(^PAWARD(wardid),"^",2)
	.do OutputRow5
 	
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow5
    set Data=$lb(beddesc,warddesc,roomdesc,bedtype,bedstatus,roomtype,roomstatus,roomid,bedrowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// w ##class(web.UDHCJFIPReg).getpatinfo("0000000052", "", "", "302")
ClassMethod getpatinfo(papno, zyno, IPBook, UserDepID)
{
	;s ^TMP("getpatinfo")=papno_","_zyno_","_IPBook_","_UserDepID
	s papno=$g(papno),zyno=$g(zyno),IPBook=$g(IPBook),UserDepID=$g(UserDepID)
	q:((papno="")&&(zyno="")) "-1^"
	s UserDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(UserDepID)
    ;住院证信息 yyx 2012-02-14
    s admdep="", admward="", IPBookFlag=""
    ;add by wangjian2014-01-15 判断住院证有效性转移到公用类
    i (IPBook'="") s IPBookFlag=##class(web.DHCBillInterface).IIsIPBook(IPBook)
    q:(IPBookFlag'="") IPBookFlag
    ;end
	s rowid=""
	i (papno'="")  d
	.s papno=##class(web.UDHCJFBaseCommon).regnocon(papno)
	.i (papno'="") s rowid=$o(^PAPERi("PAPMI_PatNo",papno,rowid))
	i ((zyno'="")&&(rowid="")) d
	.s zyno=$$ALPHAUP^SSUTIL4(zyno)
	.;s rowid=$o(^PAPERi("Medicare1",zyno,""))
	.//update by zf 20150317 通过住院病案号取PatientID
	.s rowid=##Class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(zyno,"I","","")
	.//
	s sexdr=""
	q:(rowid="") "-2^" 
	s AdmNum=..GetAdmFlag(rowid)
	
	s photo=""  //+2017-08-17 ZhYW
	i (rowid'="")  d
	.s ZYZReturn=..GetIPBookInfo(IPBook)
	.i (ZYZReturn'="-1")  s ZYZFlag="Y"
	.i (AdmNum>0) s ZYZReturn="-1"
	.s papno=$p(^PAPER(rowid,"PAT",1),"^",1)
	.s papname=$p(^PAPER(rowid,"ALL"),"^",1)
	.;add by lml 2015-01-15 增加病人密级和级别
    .s EncryptLevel="", PatLevel=""
    .s PatEncryptLevel=##class(web.UDHCJFBaseCommon).GetPatEncryptLevel(rowid,"")
    .s EncryptLevel=$p(PatEncryptLevel,"^",1)
    .s PatLevel=$p(PatEncryptLevel,"^",2)
    .;end
	.s pycode=$p($g(^PAPER(rowid,"ALL")),"^",2)
    .s HCP=$p(^PAPER(rowid,"PER",4),"^",17)
	.s HCPDesc=""
	.i (HCP'="")  s HCPDesc=$p($g(^CT("HCP",HCP)),"^",2)
	.;s Medicare=$p($g(^PAPER(rowid,"PAT",1)),"^",22)
	.//update by zf 20150317 通过PatientID取住院病案号
	.s Medicare=##class(DHCWMR.IO.OutService).IGetMrNoByPatientID(rowid,"I","","")
	.//
	.s govcardno=$p($g(^PAPER(rowid,"PAT",3)),"^",6)
	.s cardtypeid=$p($g(^PAPER(rowid,"PAT",3)),"^",7)
	.s InsuNo=$p($g(^PAPER(rowid,"PAT",3)),"^",12)
	.s cardtype=""
	.i (+cardtypeid'=0) d
	..s cardtype=$p($g(^PAC("CARD",cardtypeid)),"^",2)
	.s cardtype=cardtypeid_"@"_cardtype
	.s sexdr=$p($g(^PAPER(rowid,"ALL")),"^",7)
	.s sexdesc=""
	.i (+sexdr'=0)  d
	..s sexdesc=$p($g(^CT("SEX",sexdr)),"^",2)
	.s sexdesc=sexdr_"@"_sexdesc
	.s idcard=$p($g(^PAPER(rowid,"ALL")),"^",9)	  
	.s rowid=$p(rowid,$c(1))
	.&sql(select papmi_paper_dr into :paperid from pa_patmas where papmi_rowid=:rowid)
	.s paperid=$p(paperid,$c(1))
	.&sql(select paper_dob,paper_ageyr,paper_agemth,paper_ageday into :patdob,:patageyr,:patagemth,:patageday 
	       from pa_person where paper_rowid=:paperid)
	.;取住院登记备注信息，临时
	.s foreignnotes=$g(^PAPERZYJF("Patinfo",paperid))
	.i (patdob'="")  s patdob=##class(websys.Conversions).DateLogicalToHtml(patdob)
	.i (patageyr="")  s patageyr=0
	.i (patagemth="")  s patagemth=0
	.i (patageday="")  s patageday=0
	.i (patageyr=0)  d
	..i (patagemth=0)  d
	...i (patageday=0)  d
	....s agedesc=""
	...e  d
	....;s agedesc=patageday_"天"
	..e  d
	...;s agedesc=patagemth_"月"
	.e  d
	..;s agedesc=patageyr
	.//start add hujunbin 2014.12.04
	.s myAdm="", flag=0, myAdmDate=+$h
	.f  s myAdm=$o(^PAPERdr(paperid,"ADM","I",myAdm),-1) q:((myAdm="")||(flag=1))  d
	..s myAdmStatus=$p(^PAADM(myAdm),"^",20)
	..s myAdmType=$p(^PAADM(myAdm),"^",2)
	..;+2015-3-4 hujunbin 判断医院
	..s myAdmdep=$p(^PAADM(myAdm),"^",4)
	..q:(myAdmdep="")
	..s myAdmDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myAdmdep)
	..q:((UserDepHosDr'=myAdmDepHosDr)&&(myAdmDepHosDr'="")&&(UserDepHosDr'=""))
	..i (myAdmStatus="A") d
	...s myadmid=myAdm
	...s flag=1
	.i ($g(myadmid)'="") d
	..s myAdmDate=$p(^PAADM(myadmid),"^",6)
	..s myAdmTime=$p(^PAADM(myadmid),"^",7)
	.s agedesc=##class(web.DHCBillInterface).GetPapmiAge(paperid, $g(myadmid))
	.//
	.s mardr=$p($g(^PAPER(paperid,"PER",2)),"^",3)     //婚姻状况
	.s mardesc=""
	.i (+mardr'=0) d
	..s mardesc=$p($g(^CT("MAR",mardr)),"^",2)
	.s mardesc=mardr_"@"_mardesc
	.
	.s rlgdr=$p($g(^PAPER(paperid,"PER",2)),"^",2)
	.s rlgdesc=""
	.i (+rlgdr'=0) d
	..s rlgdesc=$p($g(^CT("RLG",rlgdr)),"^",2)
	.s rlgdesc=rlgdr_"@"_rlgdesc
	.
	.s nationdr=$p($g(^PAPER(paperid,"PER",2)),"^",1)    //民族
	.s nationdesc=""
	.i (+nationdr'=0) d
	..s nationdesc=$p($g(^CT("NAT",nationdr)),"^",2)
	.i (nationdesc["-") d
	..s nationdesc=$p(nationdesc,"-",2)
	.s nationdesc=nationdr_"@"_nationdesc
	.
	.s occupatid=$p($g(^PAPER(paperid,"PER",2)),"^",6)
	.s occupation=""
	.i (+occupatid'=0) d
	..s occupation=$p($g(^CT("OCC",occupatid)),"^",2)
	.i (occupation["-") d
	..s occupation=$p(occupation,"-",2)
	.s occupation=occupatid_"@"_occupation
	.
	.s educatid=$p($g(^PAPER(paperid,"PER",2)),"^",5)
	.s education=""
	.i (+educatid'=0)  d
	..s education=$p($g(^CT("EDU",educatid)),"^",2)
	.i (education["-") d
	..s education=$p(education,"-",2)
	.s education=educatid_"@"_education
	.
	.s birprovid=$p($g(^PAPER(paperid,"PER",2)),"^",11)
	.s birprov=""
	.i (+birprovid'=0) d
	..s birprov=$p($g(^CT("PROV",birprovid)),"^",2)
	.i (birprov["-") d
	..s birprov=$p(birprov,"-",2)
	.
	.s foreignid=$p($g(^PAPER(paperid,"PER",2)),"^",13)
	.
	.s provincedr=$p($g(^PAPER(paperid,"PER",4)),"^",2)
	.s provincedesc=""
	.i (+provincedr'=0)  d
	..s provincedesc=$p($g(^CT("PROV",provincedr)),"^",2)
	.i (provincedesc["-") d
	..s provincedesc=$p(provincedesc,"-",2)
	.s provincedesc=provincedr_"@"_provincedesc
	.
	.s citydr=$p($g(^PAPER(paperid,"PER",1)),"^",5)
	.s citydesc=""
	.i (+citydr'=0) d
	..s citydesc=$p($g(^CT("CIT",citydr)),"^",2)
	.i (citydesc["-") d
	..s citydesc=$p(citydesc,"-",2)
	.s citydesc=citydr_"@"_citydesc
	.
	.s zipdr=$p($g(^PAPER(paperid,"PER",1)),"^",7)
	.s zipdesc=""
	.i (+zipdr'=0)  d
	..s zipdesc=$p($g(^CT("ZIP",zipdr)),"^",1)
	.s zipdesc=zipdr_"@"_zipdesc
	.
	.s worktel=$p($g(^PAPER(paperid,"PER",1)),"^",9)
	.s hometel=$p($g(^PAPER(paperid,"PER",1)),"^",11)
	.s SocSatdr=$p($g(^PAPER(paperid,"PER",1)),"^",10)   //PAPER_SocialStatus_DR
	.s SocSatdesc=""
	.i (+SocSatdr'=0)  d
	..s SocSatdesc=$p($g(^CT("SS",SocSatdr)),"^",2)
	.s SocSatdesc=SocSatdr_"@"_SocSatdesc
	.
	.s countryid=$p($g(^PAPER(paperid,"PER",1)),"^",8)
	.s country=""
	.i (+countryid'=0) d
	..s country=$p($g(^CT("COU",countryid)),"^",2)
	.i (country["-") d
	..s country=$p(country,"-",2)
	.s country=countryid_"@"_country
	.
	.s foreignaddress=$p($g(^PAPER(paperid,"PER",1)),"^",1)
	.s address=$g(^PAPER(paperid,"PER","ADD",1))
	.s company=$p($g(^PAPER(paperid,"PER",4)),"^",18)
	.s email=$p($g(^PAPER(paperid,"PER",4)),"^",19)
	.s mobpone=$p($g(^PAPER(paperid,"PER",4)),"^",21)
	.s cityareaid=$p($g(^PAPER(paperid,"PER",4)),"^",9)
	.s cityarea=""
	.i (+cityareaid'=0)  d
	..s cityarea=$p($g(^CT("CITAREA",cityareaid)),"^",2)
	.i (cityarea["-")  d
	..s cityarea=$p(cityarea,"-",2)
	.s cityarea=cityareaid_"@"_cityarea
	.
	.s languid=$p($g(^PAPER(paperid,"ALL")),"^",10)
	.s language=""
	.i (+languid'=0)  d
	..s language=$p(^SS("LAN",languid),"^",2)
	.i (language["-")  d
	..s language=$p(language,"-",2)
	.s language=languid_"@"_language
	.
	.s photo=$p($g(^PAPER(paperid,"PER",6)),"^",5)   //+2017-08-17 ZhYW
	.s emptypeid=$p($g(^PAPER(paperid,"EMP")),"^",1)
	.s employeetype=""
	.i (+emptypeid'=0) d
	..s employeetype=$p($g(^PAC("EPE",emptypeid)),"^",2)
	.i (employeetype["-")  d
	..s employeetype=$p(employeetype,"-",2)
	.s employeetype=emptypeid_"@"_employeetype
	.
	.s ctrltid=$p($g(^PAPER(paperid,"EMP")),"^",4)
	.s ctrlt=""
	.i (+ctrltid'=0)  d
	..s ctrlt=$p($g(^CT("RLT",ctrltid)),"^",2)
	.i (ctrlt["-")  d
	..s ctrlt=$p(ctrlt,"-",2)
	.s ctrlt=ctrltid_"@"_ctrlt
	.
	.s bircityid=$p($g(^PAPER(paperid,"ALL")),"^",18)
	.s bircity=""
	.i (+bircityid'=0)  d
	..s bircity=$p(^CT("CIT",bircityid),"^",2)
	.i (bircity["-")  d
	..s bircity=$p(bircity,"-",2)
	.
	.s foreignphone=$p($g(^PAPER(paperid,"ALL")),"^",4)
	.s dhcpersonid=$o(^DHCPERSON(0,"PAPERSON",paperid,""))
    .s dhcpersonid=$p(dhcpersonid,$c(1))
	.s hzipcode="", czipcode=""
	.i (dhcpersonid'="")  d
	..s czipcode=$p(^DHCPERSON(dhcpersonid),"^",7)
	..s hzipcode=$p(^DHCPERSON(dhcpersonid),"^",8)   
	..//modify 2012-01-12 增加户口地址、出生地、户口邮编等字段
    ..s BirthProvinceDr=$p($g(^DHCPERSON(dhcpersonid)),"^",13)
	..i (BirthProvinceDr'="")  d
	...s BirthProvince=$p($g(^CT("PROV",BirthProvinceDr)),"^",2)
	...i ($f(BirthProvince,"-")'=0)  d
	....s BirthProvince=$p(BirthProvince,"-",2)
	...s BirthProvince=BirthProvinceDr_"@"_BirthProvince
	..e  d
	...s BirthProvince="@"
	..s BirthCityDr=$p($g(^DHCPERSON(dhcpersonid)),"^",14)
	..i (BirthCityDr'="")  d
	...s BirthCity=$p($g(^CT("CIT",BirthCityDr)),"^",2)
	...i $f(BirthCity,"-")'=0  d
	....s BirthCity=$p(BirthCity,"-",2)
	...s BirthCity=BirthCityDr_"@"_BirthCity
	..e  d
	...s BirthCity="@"
	..s BirthAreaDr=$p($g(^DHCPERSON(dhcpersonid)),"^",15)
	..i (BirthAreaDr'="")  d
	...s BirthArea=$p($g(^CT("CITAREA",BirthAreaDr)),"^",2)
	...i $f(BirthArea,"-")'=0  d
	....s BirthArea=$p(BirthArea,"-",2)
	...s BirthArea=BirthAreaDr_"@"_BirthArea
	..e  d
	...s BirthArea="@" 
	..s BirthAddress=$p($g(^DHCPERSON(dhcpersonid)),"^",16)
	..s HouseProvinceDr=$p($g(^DHCPERSON(dhcpersonid)),"^",17)
	..i (HouseProvinceDr'="")  d
	...s HouseProvince=$p($g(^CT("PROV",HouseProvinceDr)),"^",2)
	...i ($f(HouseProvince,"-")'=0)  d
	....s HouseProvince=$p(HouseProvince,"-",2)
	...s HouseProvince=HouseProvinceDr_"@"_HouseProvince
	..e  d
	...s HouseProvince="@" 
	..s HouseCityDr=$p($g(^DHCPERSON(dhcpersonid)),"^",18)
	..i (HouseCityDr'="")  d
	...s HouseCity=$p($g(^CT("CIT",HouseCityDr)),"^",2)
	...i ($f(HouseCity,"-")'=0)  d
	....s HouseCity=$p(HouseCity,"-",2)
	...s HouseCity=HouseCityDr_"@"_HouseCity
	..e  d
	...s HouseCity="@"
	..s HouseAreaDR=$p($g(^DHCPERSON(dhcpersonid)),"^",19)
	..i (HouseAreaDR'="")  d
	...s HouseArea=$p($g(^CT("CITAREA",HouseAreaDR)),"^",2)
	...i ($f(HouseArea,"-")'=0)  d
	....s HouseArea=$p(HouseArea,"-",2)
	...s HouseArea=HouseAreaDR_"@"_HouseArea
	..e  d
	...s HouseArea="@"
	..s HouseAddress=$p($g(^DHCPERSON(dhcpersonid)),"^",20)
	..s HouseZipCode=$p($g(^DHCPERSON(dhcpersonid)),"^",9)
	.s homeplace=bircity_" "_birprov_"@"_bircityid_"@"_birprovid
	.s admrowid="",admno="",admvisit="",admdepdesc="@",admwarddesc="@",admbeddesc="@"
	.s admdocdesc="@",admreadesc="@",admepisdesc="@",admdate="",admtime="",admusename=""
	.s admroomdesc="@",admqkdesc="@",dig1="@",dig2="@",dig3=""
	.s admrefdocdesc="@",admrefpriorityDesc="@"
    .;卡号
	.s patNo=""
	.s CFRowID=$o(^DHCCARDi("CF",0,"PAPMIDR",paperid,""),-1) 
	.i CFRowID'="" s cardno=$p($g(^DHCCARD("CF",CFRowID)),"^",2) 
	.s admid=""
	.s admtimes=0
	.f  s admid=$o(^PAPERdr(rowid,"ADM","I",admid))  q:(admid="")  d
	..;+2015-3-4 hujunbin 判断医院
	..s myAdmdep=$p(^PAADM(admid),"^",4)
	..q:(myAdmdep="")
	..s myAdmDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myAdmdep)
	..q:((UserDepHosDr'=myAdmDepHosDr)&(myAdmDepHosDr'="")&(UserDepHosDr'=""))
	..s visitstatus=$p(^PAADM(admid),"^",20)
	..q:(visitstatus="C")
	..q:visitstatus="D"
	..q:visitstatus="P" ;add by wangjian 2015-01-08
	..s admtype=$p(^PAADM(admid),"^",2)
	..q:(admtype'="I")
	..s admtimes=$p(^PAADM(admid),"^",29)
	..;i admtimes="" s admtimes=admtimes+1
	.s admnum=0
	.s admid=""
	.f  s admid=$o(^PAPERdr(rowid,"ADM","I",admid),-1)  q:(admid="")!(admnum>0)  d
	..;+2015-3-4 hujunbin 判断医院 将下面程序提前
	..s myAdmDep=$p(^PAADM(admid),"^",4)
	..q:(myAdmDep="")
	..s AdmDepHosDr=##class(web.UDHCHospitalGroup).GetHospitalIDByLocID(myAdmDep)
	..q:((UserDepHosDr'=AdmDepHosDr)&&(AdmDepHosDr'="")&&(UserDepHosDr'=""))
	..s visitstatus=$p(^PAADM(admid),"^",20)
	..q:(visitstatus="C")
	..q:visitstatus="D"
	..q:visitstatus="P" ;add by wangjian 2015-01-08
	..s admtype=$p(^PAADM(admid),"^",2)
	..q:(admtype'="I")
	..i visitstatus="A"  s admvisit="在院"  
	..i visitstatus="D"  s admvisit="出院"
	..i visitstatus="C"  s admvisit="取消住院"
	..i visitstatus="P"  s admvisit="预约"
	..s admrowid=admid
	..s admno=$p(^PAADM(admid),"^",81)
	..s admdep=$p(^PAADM(admid),"^",4)
	..q:(admdep="")
	..q:($d(^CTLOC(admdep))=0)
	..s admdepdesc=$p(^CTLOC(admdep),"^",2)
	..i $f(admdepdesc,"-")'=0  d
	...s admdepdesc=$p(admdepdesc,"-",2)
	..s admdepdesc=admdep_"@"_admdepdesc
	..s admward=$p(^PAADM(admid),"^",70)
	..q:(admward="")
	..q:($d(^PAWARD(admward))=0)
	..s wardlocdr=$p(^PAWARD(admward),"^",5)
	..q:(wardlocdr="")
	..q:($d(^CTLOC(wardlocdr))=0)
	..s admwarddesc=$p(^CTLOC(wardlocdr),"^",2)
	..i $f(admwarddesc,"-")'=0  d
	...s admwarddesc=$p(admwarddesc,"-",2)
	..s admwarddesc=admward_"@"_admwarddesc
	..s admbed=$p(^PAADM(admid),"^",73)
	..i (admbed="")  d
	...s admbeddesc=""
	..e  d
	...i ($f(admbed,"||")=0)  d
	....s admbed=""
	....s admbeddesc=""
	...e  d
	....s admbed1=$p(admbed,"||",1)
	....s admbed2=$p(admbed,"||",2)
	....s admbeddesc=$p(^PAWARD(admbed1,"BED",admbed2),"^",1)
	..s admbeddesc=admbed_"@"_admbeddesc
	..s admroom=$p(^PAADM(admid),"^",69)
	..s admroomdesc=""
	..i (+admroom'=0) d
	...s admroomdesc=$p($g(^PAROOM(admroom)),"^",1)
	..s admroomdesc=admroom_"@"_admroomdesc
	..s admdocid=$p(^PAADM(admid),"^",9)
	..s admdocdesc=""
	..i (+admdocid'=0)  d
	...s admdocdesc=$p($g(^CTPCP(admdocid,1)),"^",2)
	..s admdocdesc=admdocid_"@"_admdocdesc
	..s admreaid=$p(^PAADM(admid,1),"^",7)
	..q:(admreaid="")
	..q:($d(^PAC("ADMREA",admreaid))=0)
	..s admreadesc=$p(^PAC("ADMREA",admreaid),"^",2)
	..s admreadesc=admreaid_"@"_admreadesc
	..s admepisid=$p(^PAADM(admid,1),"^",6)
	..i (admepisid="")  d
	...s admepisdesc=""
	..e  d
	...i $d(^PAC("SUBT",admepisid))=0  d
	....s admepisid=""
	....s admepisdesc=""
	...e  d
	....s admepisdesc=$p($g(^PAC("SUBT",admepisid)),"^",2)
	..s admepisdesc=admepisid_"@"_admepisdesc
	..s AdmSourceID=$p(^PAADM(admid),"^",10)  ;入院途径
	..i AdmSourceID'="" s AdmSource=$p($g(^PAC("ADSOU",AdmSourceID)),"^",2)
	..s AdmSourceInfo=$g(AdmSourceID)_"@"_$g(AdmSource)
	..s admdate=$p(^PAADM(admid),"^",6)
	..s admdate1=admdate
	..i (admdate'="")  s admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
	..s admtime=$p(^PAADM(admid),"^",7)
	..s admtime1=admtime
	..i (admtime'="")  s admtime=##class(websys.Conversions).TimeLogicalToHtml(admtime,1)
	..s admuser=$p(^PAADM(admid),"^",43)
	..q:(admuser="")
	..q:($d(^SSU("SSUSR",admuser))=0)
	..s admusename=$p(^SSU("SSUSR",admuser),"^",2)
	..s admqkdr="",admqkdesc=""
	..s admqkdr=$p(^PAADM(admid),"^",5)
	..i (admqkdr="")  d
	...s admqkdesc=""
	..e  d
	...i (($d(^PAC("ADMCAT",admqkdr))=0)&($d(^PAC("ADMCAT",admqkdr))=10))  d
	....s admqkdr="",admqkdesc=""
	...e  d
	....s admqkdesc=$p($g(^PAC("ADMCAT",admqkdr)),"^",2)
	..s admqkdesc=admqkdr_"@"_admqkdesc
	..s admrefdoc="", admrefdocdr=""
	..s admrefdocdr=$p(^PAADM(admid),"^",82)
	..i (admrefdocdr'="")  d
	...i $d(^CTPCP(admrefdocdr))'=0 d 
	....s admrefdoc=$p(^CTPCP(admrefdocdr,1),"^",2)
	...e  d
	....s admrefdoc="",admrefdocdr=""
	..s admrefdocdesc=admrefdocdr_"@"_admrefdoc
	..;入院病情
	..s admrefpriority="", admrefprioritydr=""
	..s admrefprioritydr=$p(^PAADM(admid,1),"^",52)
	..i (admrefprioritydr'="") s admrefpriority=$p($g(^PAC("REFPRI",admrefprioritydr)),"^",2)
	..s admrefpriorityDesc=admrefprioritydr_"@"_$g(admrefpriority)
	..s mradmid=$p(^PAADM(admid),"^",61)
	..i (mradmid'="")  d
	...s mradmid1="0"
	...s mradmnum=0
	...f  s mradmid1=$o(^MR(mradmid,"DIA",mradmid1))  q:((mradmid1="")||(mradmnum=1))  d
	....s mradmnum=mradmnum+1
	....s dig3=$g(^MR(mradmid,"DIA",mradmid1,"DES",1))    //诊断备注
	....s mricd=$p(^MR(mradmid,"DIA",mradmid1),"^",1)
	....s dig1desc=""
	....i (mricd'="")  d
	.....i ($d(^MRC("ID",mricd))'=0)!($d(^MRC("ID",mricd))'=10)  d
	......s dig1desc=$p(^MRC("ID",mricd),"^",2)
	......s dig1=mricd_"@"_dig1desc 
	.....e  d
	......s dig1="@"
	....e  d
	.....s dig1="@"
	....s mrdigtypeid="0"
	....s mrdigtpnum=0
	....f  s mrdigtypeid=$o(^MR(mradmid,"DIA",mradmid1,"TYP",mrdigtypeid))  q:((mrdigtypeid="")||(mrdigtpnum=1))  d
	.....s mrdigtpnum=mrdigtpnum+1
	.....s digtpid=$p(^MR(mradmid,"DIA",mradmid1,"TYP",mrdigtypeid),"^",1)
	.....i (digtpid="") d
	......s dig2="@"
	.....e  d
	......i ($d(^MRC("DTYP",digtpid))'=0)&($d(^MRC("DTYP",digtpid))'=10)  d
	.......s dig2desc=$p(^MRC("DTYP",digtpid),"^",2)
	.......s dig2=digtpid_"@"_dig2desc
	......e  d
	.......s dig2="@"   
	..s admnum=admnum+1	
	//调取住院证信息
	s DepositSum=""
	i (ZYZReturn'="-1")  d
	.i $g(admdep)=""  d
	..s admdep=$p(ZYZReturn,"^",14)
	..q:($d(^CTLOC(admdep))=0)
	..s admdepdesc=$p(^CTLOC(admdep),"^",2)
	..i $f(admdepdesc,"-")'=0  d
	...s admdepdesc=$p(admdepdesc,"-",2)
	..s admdepdesc=admdep_"@"_admdepdesc
	.i $g(admward)=""  d
	..s admward=$p(ZYZReturn,"^",12)  
	..q:(admward="")
	..q:($d(^PAWARD(admward))=0)
	..s wardlocdr=$p(^PAWARD(admward),"^",5)
	..q:(wardlocdr="")
	..q:($d(^CTLOC(wardlocdr))=0)
	..s admwarddesc=$p(^CTLOC(wardlocdr),"^",2)
	..i $f(admwarddesc,"-")'=0  d
	...s admwarddesc=$p(admwarddesc,"-",2)
	..s admwarddesc=admward_"@"_admwarddesc
	.s DepositSum=$p(ZYZReturn,"^",18)
	.s mricdStr=$p(ZYZReturn,"^",37)     ;增加住院证接口,取诊断  20171130
	.s mricdStr1=$p(mricdStr,$c(2),1)
	.s dig1desc=$p(mricdStr1,$c(1),1)
	.s mricd=$p(mricdStr1,$c(1),2)
	.i (mricd'="") d
	..s dig1=mricd_"@"_dig1desc 
	.e  s dig1="@"
	.s mrUserID=$p($g(ZYZReturn),"^",7)  ;开住院证人
	.s dig3=$p($g(ZYZReturn),"^",20)     ;诊断备注
	.i $g(admdocid)="" d
	..;modify 2015-3-18 hujunbin 通过住院证链接的，入院医生默认为空不是开住院证的人
	..s admdocid=$p($g(ZYZReturn),"^",43)
	..i admdocid'="" s admdocdesc=$p(^CTPCP(admdocid,1),"^",2)
	..s admdocdesc=admdocid_"@"_admdocdesc
	.;add by wangjian 2015-01-08 如果没有取到就诊记录,把住院证的就诊传出
	.i +admrowid=0  d
	..s admrowid=$p($g(ZYZReturn),"^",4)
	..s admvisit=$p($g(ZYZReturn),"^",26)
	..i (+admrowid'=0)&&($d(^PAADM(admrowid))) d
	...;s visitstatus=$p(^PAADM(admrowid),"^",20)
	...;i visitstatus="P"  s admvisit="预住院"
	...;i visitstatus="A"  s admvisit="在院"  
	...;i visitstatus="D"  s admvisit="出院"
	...;i visitstatus="C"  s admvisit="取消住院"
	...s admreaid=$p(^PAADM(admrowid,1),"^",7)
	...i (admreaid'="")&&($d(^PAC("ADMREA",admreaid))) d
	....s admreadesc=$p(^PAC("ADMREA",admreaid),"^",2)
	....s admreadesc=admreaid_"@"_admreadesc
	.s admrefprioritydr=$p($g(ZYZReturn),"^",21) ;入院病情
	.s admrefpriority=""
	.i admrefprioritydr'="" s admrefpriority=$p(^PAC("REFPRI",admrefprioritydr),"^",2)
	.s admrefpriorityDesc=admrefprioritydr_"@"_$g(admrefpriority)
	.s AdmSourceID=$p($g(ZYZReturn),"^",23) ;入院途径
	.i AdmSourceID'="" s AdmSource=$p($g(^PAC("ADSOU",AdmSourceID)),"^",2)
	.s AdmSourceInfo=$g(AdmSourceID)_"@"_$g(AdmSource)
	    
	s birthDate=##class(web.UDHCJFCOMMON).GetPatBirthDate(rowid)
	s birthTime=##class(web.UDHCJFCOMMON).GetPatBirthTime(rowid)
    s babyage="", babydate="", babyhour="", babymin=""
	i ((+birthDate'=0)&&(+birthTime'=0))  d
	.i ($g(admdate1)="") s admdate1=+$h
	.s babyage=##class(web.UDHCJFCOMMON).DispPatAge(birthDate, admdate1, birthTime, $g(admtime1)) //modify hujunbin 14.12.13
	.//+2018-01-02 ZhYW 新生儿超过1个月时不显示"天时分"
	.i (($f(babyage,"年")'=0)||($f(babyage,"月")'=0)) d
	..s babyage=""
	//modify hu 14.12.4
	i (babyage'="") d
	.s agedesc=$p(babyage,"||",1)
	.s babydate=$p(babyage,"||",10)
	.s babyhour=$p(babyage,"||",11)
	.s babymin=$p(babyage,"||",12)
	//end
	i $f($g(address),"#")'=0  d
    .s address=$tr(address,"#","＃")
    
    i $f($g(BirthAddress),"#")'=0  d
    .s BirthAddress=$tr(BirthAddress,"#","＃")
    
    i $f($g(HouseAddress),"#")'=0  d
    .s HouseAddress=$tr(HouseAddress,"#","＃")

	s FormerAdm=$o(^PAPERdr(rowid,"ADM","I",""),-1)
	s FormerAdmreadesc="@"
	i (FormerAdm'="") d
	.s FormerAdmreaid=$p(^PAADM(FormerAdm,1),"^",7)
	.i (FormerAdmreaid'="")&&($d(^PAC("ADMREA",FormerAdmreaid))) d
	..s FormerAdmreadesc=$p(^PAC("ADMREA",FormerAdmreaid),"^",2)
	..s FormerAdmreadesc=FormerAdmreaid_"@"_FormerAdmreadesc
	;根据社会地位取默认费别
	s admrea=$p(admreadesc,"@",2)
	i (admrea="")  d
	.s socDr=$p(SocSatdesc,"@",1)
	.s pacadmDr=""
	.i (socDr'="") s pacadmDr=$o(^DHCPACADM(0,"Social",socDr,""))
	.s admresDr=""
	.i (pacadmDr'="") s admresDr=$p(^DHCPACADM(pacadmDr),"^",2)
	.i (admresDr'="")&&($d(^PAC("ADMREA",admresDr))) d
	..s admreadesc=$p(^PAC("ADMREA",admresDr),"^",2)
	..s admreadesc=admresDr_"@"_admreadesc
		
	s str=rowid_"^"_paperid_"^"_papno_"^"_papname_"^"_Medicare_"^"_sexdesc_"^"_idcard
	s str=str_"^"_patdob_"^"_agedesc_"^"_mardesc_"^"_rlgdesc_"^"_address_"^"_hometel_"^"_zipdesc
	s str=str_"^"_company_"^"_worktel_"^"_provincedesc_"^"_email_"^"_mobpone_"^"_citydesc
	s str=str_"^"_admrowid_"^"_admno_"^"_admvisit_"^"_admdepdesc_"^"_admwarddesc_"^"_admbeddesc
	s str=str_"^"_admdocdesc_"^"_admreadesc_"^"_admepisdesc_"^"_admdate_"^"_admtime_"^"_admusename_"^"_admroomdesc_"^"_SocSatdesc_"^"_admqkdesc_"^"_nationdesc
	s str=str_"^"_cardtype_"^"_govcardno_"^"_country_"^"_occupation_"^"_education_"^"_language
	s str=str_"^"_employeetype_"^"_homeplace_"^"_foreignid_"^"_ctrlt_"^"_foreignphone_"^"_foreignaddress
	s str=str_"^"_foreignnotes_"^"_admtimes_"^"_cityarea_"^"_pycode_"^"_dig1_"^"_dig2_"^"_dig3_"^"_babyage_"^"_babydate_"^"_babyhour_"^"_babymin_"^"_admrefdocdesc
	s str=str_"^"_hzipcode_"^"_czipcode_"^"_InsuNo_"^"_$g(ZYZFlag)_"^"_$g(HCP)_"@"_$g(HCPDesc)_"^"_$g(cardno)   //61--66
	s str=str_"^"_$g(BirthProvince)_"^"_$g(BirthCity)_"^"_$g(BirthArea)_"^"_$g(BirthAddress)   //67--70
	s str=str_"^"_$g(HouseProvince)_"^"_$g(HouseCity)_"^"_$g(HouseArea)_"^"_$g(HouseAddress)_"^"_$g(HouseZipCode)_"^"_$g(AdmSourceInfo) 	  ///71--76
	s str=str_"^"_EncryptLevel_"^"_PatLevel_"^"_admrefpriorityDesc_"^"_FormerAdmreadesc_"^"_DepositSum    //77--81
	s str=str_"^"_photo_"^"_birthDate_"^"_birthTime   //+2017-08-17 ZhYW
	s str=$tr(str,$c(0),"")
	q str
}

/// w ##class(web.UDHCJFIPReg).getpatage("1990-01-01", "2017-06-13")
ClassMethod getpatage(birthdate, admdate)
{
	//modify 2014-04-23 判断出生日期是否合法
	s agestr=""
	s admdate=$g(admdate)
	i (birthdate="")  d
	.s birthdate=+$h
	e  d
	.i birthdate["-" d
	..s birthdate=$zdh(birthdate,3)
	i (admdate'="")  d
	.s enddate=$zdh(admdate,3)
  	e  d
  	.s enddate=+$h
  	s agestr1=..CalAge(birthdate,enddate)
  	s agestr1=$g(agestr1)
  	i ($l(agestr1,"^")=3)  d
  	.s yeartmp=$p(agestr1,"^",1)
  	.s montmp=$p(agestr1,"^",2)
  	.s daytmp=$p(agestr1,"^",3)
  	.i (yeartmp=0)  d
  	..i (montmp=0)  d
  	...s agestr=daytmp_"天"
  	..e  d
  	...s agestr=montmp_"月"
  	.e  d
  	..s agestr=yeartmp
  	s agestr=agestr_"^"_agestr1  
  	q agestr
}

ClassMethod CalAge(IBirth As %String, IToday As %String)
{
   ;根据出生日期计算年龄
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
	s reage=$p(AgeYr,"|",12)_"^"_AgeMth_"^"_AgeDay
	q reage
}

/// w ##class(web.UDHCJFIPReg).inspatinfo("", "", "^SHD^^1^^23/01/1990^28岁^28^11^6^^^^^^^^^^^^6^1^^^1^^^^^^^^^^^^^SHD^^^N^^^^^^^^^^^^^^^^","105^1^^^^1^^29/12/2018^13:18:17^4632^2^^^^4^入院诊断^^^","")
ClassMethod inspatinfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", patval, admval, opcardinfo)
{
	s ^TMP("inspatinfo")=$lb(itmjs, itmjsex, patval, admval, opcardinfo)
	q:(patval="") "patnullerr^^^^^^"
	q:(admval="") "admnullerr^^^^^^"
	;patval=papmirowid^姓名^病历号^性别^身份证号^出生日期^年龄^ageyr^agemth^ageday^婚姻状况
	;^宗教^地址^家庭电话^邮政编码^工作单位^工作电话^省^email^手机^市^社会地位
	;^证件类型^证件号码^国籍^职业^教育^语言^在职状态^籍贯（省）^籍贯（市）^与病人关系^联系人姓名^联系人电话
	;^联系人地址^备注^区^拼音码，存在pa_person表中paper_name2字段
	;admval=科室^病区^房间号^床位^入院医生^收费类别^就诊类别^入院日期^入院时间^操作员^入院情况^诊断
		
	s retcode=0,mno="",patid1="",admid="",admno="",admvisit="",medicare=""
	s patid=$p(patval,"^",1)
  	i (patid'="") s PatStayStat=##class(web.UDHCJFBaseCommon).GetPatStayStat(patid)
  	q:$g(PatStayStat)=1 "StayStat"
	s mid=patid
	s patname=$p(patval,"^",2)
	;add by wangjian 判断传过来的姓名跟系统是否一样，不一样的话提示先改基本信息再办理入院(防止办理住院时候误更新基本信息)
	s oldpatname=""
	i (patid'="") s oldpatname=$p(^PAPER(patid,"ALL"),"^",1)
	q:(oldpatname'=patname)&&(oldpatname'="") "PatNameErr" 
   
	s medicare=$p(patval,"^",3)
	s sexdr=$p(patval,"^",4)
	i (sexdr="")  s sexdr="3"
	s idcard=$p(patval,"^",5)   
	s birdob=$p(patval,"^",6)
	s age=$p(patval,"^",7)	 
  	s ageyr=$p(patval,"^",8)
  	s agemth=$p(patval,"^",9)
  	s ageday=$p(patval,"^",10)   
  	s paperage="|||||||||||"_ageyr_"|"_agemth_"|"_ageday
  	s mardr=$p(patval,"^",11)    
  	s rlgdr=$p(patval,"^",12)
  	s address=$p(patval,"^",13) 
  	//modify 2014-11-19 将地址和单位带#号的自付转为全角"＃" 否则查询程序会有问题
  	i $f(address,"#")'=0  d
  	.s address=$tr(address,"#","＃")
  	//
  	s homtel=$p(patval,"^",14)    
  	s zipdr=$p(patval,"^",15)
  	s company=$p(patval,"^",16)  
  	//modify 2014-11-19 将地址和单位带#号的自付转为全角"＃" 否则查询程序会有问题
  	i ($f(company,"#")'=0)  d
  	.s company=$tr(company,"#","＃")
	//
  	s worktel=$p(patval,"^",17)  
  	s provdr=$p(patval,"^",18)
  	s email=$p(patval,"^",19)  
  	s mobtel=$p(patval,"^",20)  
  	s citydr=$p(patval,"^",21)
  	s SocSatdr=$p(patval,"^",22)
  	s nationdr=$p(patval,"^",23)
  	s cardtypeid=$p(patval,"^",24)
  	s govcardno=$p(patval,"^",25)
  	s countryid=$p(patval,"^",26)
  	s occuid=$p(patval,"^",27)
  	s eduid=$p(patval,"^",28)
  	s languid=$p(patval,"^",29)
  	s emptypeid=$p(patval,"^",30)
  	s birprovid=$p(patval,"^",31)
  	s bircityid=$p(patval,"^",32)
  	s ctrltid=$p(patval,"^",33)
  	s ForeignId=$p(patval,"^",34)
  	s FPhone=$p(patval,"^",35)
  	s FAddress=$p(patval,"^",36)
  	//modify 2014-11-19 将地址和单位带#号的自付转为全角"＃" 否则查询程序会有问题
  	i $f(FAddress,"#")'=0  d
  	.s FAddress=$tr(FAddress,"#","＃")
  	//
  	s FNotes=$p(patval,"^",37)
  	s cardtypeid=$g(cardtypeid)
  	s cityareaid=$p(patval,"^",38)
  	;insert by cx 2007.05.21
  	s pycode=$p(patval,"^",39)
  	s soundx1=patname_"00"
  	s babydob1=$p(patval,"^",40)
  	s babydob2=$p(patval,"^",41)
  	;insert by cx 2007.08.03 患者病案号自动生成
  	s Medicareflag=$p(patval,"^",42)
  	s newcardno=$p(patval,"^",43)
  	s hzipcode=$p(patval,"^",44)
  	s czipcode=$p(patval,"^",45)  
  	s InsuNo=$p(patval,"^",46) 
  	s IPBook=$p(patval,"^",47)    //住院证ID
  	s HCPId=$p(patval,"^",48)     //add by zhl 20111020   
  	s BirthProvinceDr=$p(patval,"^",49)
  	s BirthCityDr=$p(patval,"^",50)
  	s BirthAreaDr=$p(patval,"^",51)
  	s BirthAddress=$p(patval,"^",52)
  	//modify 2014-11-19 将地址和单位带#号的自付转为全角"＃" 否则查询程序会有问题
  	i ($f(BirthAddress,"#")'=0)  d
  	.s BirthAddress=$tr(BirthAddress,"#","＃")
  	//
  	s HouseProvinceDr=$p(patval,"^",53)
  	s HouseCityDr=$p(patval,"^",54)
  	s HouseAreaDR=$p(patval,"^",55)
  	s HouseAddress=$p(patval,"^",56)
  	//modify 2014-11-19 将地址和单位带#号的自付转为全角"＃" 否则查询程序会有问题
  	i ($f(HouseAddress,"#")'=0)  d
  	.s HouseAddress=$tr(HouseAddress,"#","＃")
  	//
  	s HouseZipCode=$p(patval,"^",57)
  	s photo=$p(patval,"^",58)     //2017-08-18 ZhYW
  	//以上为病人基本信息
  
  	s visdate=""
  	s:(IPBook'="") visdate=$p(^DHCDocIPBK(IPBook),"^",10)
  	;q:(visdate'="")&(visdate'=+$h) "IPBookErr"  
  	s IPBookFlag="" 
  	i (IPBook'="") s IPBookFlag=##class(web.DHCBillInterface).IIsIPBook(IPBook)
  	q:(IPBookFlag'="") IPBookFlag
  	i (cardtypeid'="")  d
  	.i (($d(^PAC("CARD",cardtypeid))'=0)&($d(^PAC("CARD",cardtypeid))'=10))  d
  	..s cdtypedesc=$p(^PAC("CARD",cardtypeid),"^",2)
  	..i (cdtypedesc="身份证")  d
  	...i (idcard="")  d
  	....s idcard=govcardno
  	
 	s deptdr=$p(admval,"^",1)
	s warddr=$p(admval,"^",2)
	s roomdr=$p(admval,"^",3)
	s beddr=$p(admval,"^",4)
	s docdr=$p(admval,"^",5)
	s readr=$p(admval,"^",6)
	s episdr=$p(admval,"^",7)
	s admuser=$p(admval,"^",10)
	s admdate=$p(admval,"^",8)
	s admtime=$p(admval,"^",9)
	s admqkdr=$p(admval,"^",11)
	s diagnosid=$p(admval,"^",13)
	s diagnosdesc=$p(admval,"^",14)
	s diagnostypeid=$p(admval,"^",15)
	s diagnostype=$p(admval,"^",16)
	s refdocdr=$p(admval,"^",17)
	s refdocdr=$p(refdocdr,$c(1))
	s AdmsourceOfAttend=$p(admval,"^",18)  //入院途径
	s AdmPriorityID=$p(admval,"^",19)      //入院病情
  	
	q:(deptdr="") "admdep^^^^^^"
  	q:(warddr="") "admward^^^^^^"
  	q:(readr="") "admreadr^^^^^^"

  	i (admdate="")  d
  	.s admdate=+$h
  	e  d
  	.s admdate=##class(websys.Conversions).DateHtmlToLogical(admdate)
  	i (admtime="")  d
  	.s admtime=$p($h,",",2)
  	e  d
  	.s admtime=##class(websys.Conversions).TimeHtmlToLogical(admtime, 1)
	s birdob=##class(websys.Conversions).DateHtmlToLogical(birdob)
  	;判断出生日期与入院日期
  	q:(birdob>admdate) "AdmDateError^^^^^"
  	
	//+2018-07-16 ZhYW 开启了预约床位但没有约到时不能登记
  	i (IPBook'="") d
  	.s appSwitch=##class(Nur.InService.Interface).ifHospNeedAppByWard(warddr)
  	.i (appSwitch="Y") d
  	..s appBedInfo=##class(Nur.InService.Interface).ifPatAppBed(IPBook)   //预约床位
  	..s retcode=$p(appBedInfo,"^",1)
  	q:(+retcode'=0) "APPBedErr^^^^^^"
  	
  	//+2018-08-09 ZhYW 若科室开启了住院总签床,住院证状态不是签床不能办理住院登记
  	i (IPBook'="") d
  	.s locBeInHospital=$p($g(^CTLOC(deptdr)),"^",87)
  	.q:(locBeInHospital'="Y")
  	.s currentStateDR=$p($g(^DHCDocIPBK(IPBook)),"^",8)   ;住院证状态
	.q:(+currentStateDR=0)
  	.s IPMDICCode=$p($g(^DHCDocIPBDIC(currentStateDR)),"^",1)
  	.i (IPMDICCode'="SignBed") d
  	..s retcode=-1
  	q:(+retcode'=0) "SignBedErr^^^^^^"
  	
  	i (birdob'="")  d
  	.s birdobjs=$zd(birdob,3)
  	.s admdatejs=$zd(admdate,3)
  	.s agestr=..getpatage(birdobjs, admdatejs)
  	.s ageyr=$p(agestr,"^",2)
  	.s agemth=$p(agestr,"^",3)
  	.s ageday=$p(agestr,"^",4)
  	.;modify hu 14.12.4 还是使用上边的方法
  	.;s agestr=##class(web.UDHCJFCOMMON).DispPatAge(birdobjs, admdatejs)
  	.;s ageyr=$p(agestr,"||",7)
  	.;s agemth=$p(agestr,"||",8)
  	.;s ageday=$p(agestr,"||",9)
  	.;;end
  	.s paperage="|||||||||||"_ageyr_"|"_agemth_"|"_ageday
  	
  	
  	s admitFlag=0
  	i (patid'="")  d
  	.s admrowid=""
  	.s patid=$p(patid,$c(1))
  	.s lastAdm=$o(^PAPERdr(patid,"ADM","I",""),-1)
  	.q:(+lastAdm=0)
  	.s admStatus=$p(^PAADM(lastAdm),"^",20)
  	.i (admStatus="A") d
  	..s admitFlag=1
  	.e  i (admStatus="D")  d
  	..s disDateInfo=##class(web.DHCDischargeHistory).GetDischargeDateTime(lastAdm)
  	..s disDate=$p(disDateInfo,"^",1)
  	..i (disDate>+$h) d
  	...s admitFlag=1
  	q:(admitFlag'=0) "admerr"
  	
  	s myWardBedIdleNum=..GetWardBedIdleNum($g(warddr))
  	q:($g(warddr)'="")&&(myWardBedIdleNum'>0) "bederr"
  	//2016-07-08 chenxi 增加判断 出生日期不能大于当前日期
  	q:((birdob'="")&&(birdob>+$h)) "BirthGreatthan"
  
  	s admsexnum=0
	i ((sexdr="1")||(sexdr="2"))  d
	.i (beddr'="")  d
	..i (roomdr'="")  d
	...s admbedid=""
	....f  s admbedid=$o(^PAWARD("BED_Room_DR",roomdr,warddr,admbedid))  q:(admbedid="")  d
	.....s admbedsub=""
	.....s rmdiff=$p(^PAROOM(roomdr),"^",4)
	.....q:(rmdiff'="N")
	.....f  s admbedsub=$o(^PAWARDA(warddr,"BED",admbedid,"ADM",admbedsub))  q:(admbedsub="")  d
  	......s admold=$p(^PAWARDA(warddr,"BED",admbedid,"ADM",admbedsub),"^",1)
	......q:(admold="")
	......q:($d(^PAADM(admold))=0)
	......s patdrold=$p(^PAADM(admold),"^",1)
  	......q:(patrold="")
  	......q:($d(^PAPER(patrold))=0)
  	......s sexdrold=$p(^PAPER(patrold,"ALL"),"^",7)
  	......i (sexdrold="1")&(sexdrold="2")&(sexdrold'=sexdr)  d
  	.......s admsexnum=admsexnum+1
  
  	q:(admsexnum>0) "beddiff^^^^^^"
  	
  	//+2018-06-21 ZhYW
  	s locationDR=$p(^PAWARD(warddr),"^",5)
  	s locRtn=..GetSexAndAgeByLoc(locationDR, sexdr, age, birdob)
  	q:(locRtn'="") locRtn

  	s $ZT="ERROR^DHCSSERR"
  	d ..tb()
  
  	i (opcardinfo'="")  d
  	.s opcardno=$p(opcardinfo,"^",4)
  	.i (opcardno'="")  d
  	..s operr=##class(web.UDHCAccCardManage).grantcardUpdate(opcardinfo)
  	..s operr1=$p(operr,"^",1)
  	..s retcode=retcode+operr1
  
  	i (retcode'=0)  d
  	.Trollback
  	q:(retcode'=0) "opcarderror^^^^^^"
  
	i (patid="")  d
  	.s AdmTimes=1
  	.&sql(insert into SQLUSER.PA_Person
	 (paper_name,paper_sex_dr,paper_id,PAPER_Marital_DR,PAPER_Religion_DR,
	   PAPER_TelH,PAPER_Zip_DR,PAPER_SecondPhone,PAPER_TelO,
	   PAPER_CT_Province_DR,PAPER_Email,PAPER_MobPhone,PAPER_CityCode_DR,
	   paper_userupdate,paper_updatedate,paper_updatetime,paper_estdob,paper_dateadded,
	   paper_useradded_dr,PAPER_SocialStatus_DR,PAPER_Nation_DR,
	   PAPER_Country_DR,PAPER_Occupation_DR,PAPER_Education_DR,
	   PAPER_LangPrim_DR,PAPER_EmplType_DR,PAPER_Province_Birth_DR,PAPER_CityBirth_DR,
	   PAPER_CTRLT_DR,PAPER_ForeignId,PAPER_ForeignPhone,PAPER_ForeignAddress,PAPER_CityArea_DR,
	   paper_name2,PAPER_Soundex1,paper_exemptionnumber,PAPER_HCP_DR,PAPER_Photo)
	  values(:patname,:sexdr,:idcard,:mardr,:rlgdr,
	  :homtel,:zipdr,:company,:worktel,
	  :provdr,:email,:mobtel,:citydr,
	  :admuser,:admdate,:admtime,'N',:admdate,:admuser,:SocSatdr,:nationdr,
	  :countryid,:occuid,:eduid,
	  :languid,:emptypeid,:birprovid,:bircityid,
	  :ctrltid,:ForeignId,:FPhone,:FAddress,:cityareaid,
	  :pycode,:soundx1,:AdmTimes,:HCPId,:photo))
	.s retcode=retcode+SQLCODE
	.i (retcode'=0)  d
	..Trollback
	.i (retcode=0) d
	..s mid=$g(%ROWID)
	..&sql(update SQLUSER.pa_person
            set paper_dob=:birdob, paper_age=:paperage,
	            paper_ageday=:ageday, paper_agemth=:agemth,
	            paper_ageyr=:ageyr
            where paper_rowid=:mid)
  	..s retcode=retcode+SQLCODE
  	..i (retcode'=0)  d
  	...Trollback
  	..i (retcode=0)  d
  	...s ^PAPER(mid,"PER","ADD",0)=1
  	...S ^PAPER(mid,"PER","ADD",1)=address
  	...s ^PAPERZYJF("Patinfo",mid)=FNotes
  	...i (babydob1'="")&&(babydob2'="")  d
  	....s retcode=##class(web.UDHCJFCOMMON).SaveNewBabyDob(mid, babydob1, babydob2)
  	...i (newcardno'="")  d
  	....s ^PAPER("DHC","NewCardNo",newcardno,mid,admdate,admtime)=newcardno
  	...l +^PAPER(0,"CNT","I")
	...s mno=$I(^PAPER(0,"CNT","I"))
	...l -^PAPER(0,"CNT","I")
	...s mno=##class(web.UDHCJFBaseCommon).regnocon(mno)  
  	...;s count=8-$l(mno)
 	....;f i=0:1:count-1 d
  	.....;s mno="0"_mno
  	...//update by zf 20150318 屏蔽住院登记修改病人信息表病案号
  	...//PAPMI_Medicare=:medicare,
  	...&sql(update SQLUSER.pa_patmas
	       			set papmi_No=:mno,
	                      papmi_ipno=:mno,
	                      papmi_opno=:mno,
	                      PAPMI_SafetyNetCardNo=:medicare,
	                      PAPMI_CardType_DR=:cardtypeid,
	                      PAPMI_DVAnumber=:govcardno,
	                  	  PAPMI_HealthFundNo=:InsuNo
	                where papmi_rowid=:mid)
  	...s retcode=retcode+SQLCODE              
  	...i (retcode'=0)  d
  	....Trollback
	e  d
	.s AdmTimes=$p($g(^PAPER(patid,"PER",4)),"^",8)
	.s AdmTimes=AdmTimes+1
	.s upda=+$h
	.s uptime=$p($h,",",2)
	.&sql(update SQLUSER.pa_person 
        set paper_name =:patname,               paper_sex_dr =:sexdr,
            paper_id=:idcard,                   PAPER_Marital_DR=:mardr,
            PAPER_Religion_DR=:rlgdr,           PAPER_TelH=:homtel,
	        PAPER_Zip_DR=:zipdr,                PAPER_SecondPhone=:company,
	        PAPER_TelO=:worktel,                PAPER_CT_Province_DR=:provdr,
	        PAPER_Email=:email,                 PAPER_MobPhone=:mobtel,
	        PAPER_CityCode_DR=:citydr,          paper_userupdate=:admuser,
	        paper_updatedate=:upda,             paper_updatetime=:uptime,
	        PAPER_SocialStatus_DR=:SocSatdr,    PAPER_Nation_DR=:nationdr,
	        PAPER_Country_DR=:countryid,
	        PAPER_Occupation_DR=:occuid,        PAPER_Education_DR=:eduid,
	        PAPER_LangPrim_DR=:languid,         PAPER_EmplType_DR=:emptypeid,
	        PAPER_Province_Birth_DR=:birprovid, PAPER_CityBirth_DR=:bircityid,
	        PAPER_CTRLT_DR=:ctrltid,            PAPER_ForeignId=:ForeignId,
	        PAPER_ForeignPhone=:FPhone,         PAPER_ForeignAddress=:FAddress,
	        PAPER_CityArea_DR=:cityareaid ,     paper_name2=:pycode,
	        PAPER_Soundex1=:soundx1,            
	        PAPER_ExemptionNumber=:AdmTimes,    PAPER_HCP_DR=:HCPId,
	        PAPER_Photo=:photo                 
        where paper_rowid=:patid)
	.s retcode=retcode+SQLCODE
	.i (retcode'=0)  d
    ..Trollback
    .i retcode=0  d
    ..&sql(update SQLUSER.pa_person
            set paper_dob=:birdob, paper_age=:paperage,
	            paper_ageday=:ageday, paper_agemth=:agemth,
	            paper_ageyr=:ageyr
            where paper_rowid=:patid
          )
    ..s retcode=retcode+SQLCODE
    ..i (retcode'=0)  d
    ...Trollback
    ..i (retcode=0)  d
	...//update by zf 20150318 屏蔽住院登记修改病人信息表病案号
	...//PAPMI_Medicare=:medicare,
    ...&sql(update SQLUSER.pa_patmas
	                set  PAPMI_SafetyNetCardNo=:medicare,
	                     PAPMI_CardType_DR=:cardtypeid,
	                     PAPMI_DVAnumber=:govcardno,
	                     PAPMI_HealthFundNo=:InsuNo
	                where papmi_rowid=:patid)
    ...s retcode=retcode+SQLCODE
    ...i (retcode'=0)  d
    ....Trollback
    ...i (retcode=0)  d
    ....s ^PAPER(patid,"PER","ADD",0)=1
    ....s ^PAPER(patid,"PER","ADD",1)=address
    ....i ((babydob1'="")&&(babydob2'=""))  d
    .....s retcode=##class(web.UDHCJFCOMMON).SaveNewBabyDob(mid, babydob1, babydob2)
    ....i (newcardno'="")  d
    .....s ^PAPER("DHC","NewCardNo",newcardno,mid,admdate,admtime)=newcardno
	....s ^PAPERZYJF("Patinfo",patid)=FNotes
	
	i (patid'="")  d
	.s patid1=patid
  	e  d
  	.s patid1=mid
  	i (retcode=0)  d
  	.s dhcpersonid=$o(^DHCPERSON(0,"PAPERSON",patid1,""))
  	.s dhcpersonid=$p(dhcpersonid,$c(1))
  	.i (dhcpersonid'="")  d
  	..&sql(update DHC_Person
          set PAPER_Comment1=:czipcode                    ,PAPER_Comment2=:hzipcode , 
              PAPER_BirthProvince_DR=:BirthProvinceDr      ,PAPER_BirthCity_DR=:BirthCityDr,
              PAPER_BirthArea_dr=:BirthAreaDr              ,PAPER_BirthAddress=:BirthAddress,
              PAPER_HouseProvince_DR=:HouseProvinceDr      ,PAPER_HouseCity_DR=:HouseCityDr,
              PAPER_HouseArea_DR=:HouseAreaDR              ,PAPER_HouseAddress=:HouseAddress,
              PAPER_Comment3=:HouseZipCode 
          where PAPER_RowID=:dhcpersonid)
  	..s retcode=retcode+SQLCODE
  	.e  d
  	..&sql(insert into SQLUSER.DHC_Person(PAPER_PaPerson_dr,PAPER_Comment1,PAPER_Comment2,PAPER_BirthProvince_DR,PAPER_BirthCity_DR,
                                         PAPER_BirthArea_dr,PAPER_BirthAddress,PAPER_HouseProvince_DR,PAPER_HouseCity_DR,PAPER_HouseArea_DR,
                                         PAPER_HouseAddress,PAPER_Comment3)  
                                  values(:patid1,:czipcode,:hzipcode,:BirthProvinceDr,:BirthCityDr,:BirthAreaDr,:BirthAddress,:HouseProvinceDr,:HouseCityDr,
                                         :HouseAreaDR,:HouseAddress,:HouseZipCode))
  	..s retcode=retcode+SQLCODE
  	
  	i (retcode'=0)  d
	.Trollback
	q:(retcode'=0) "paterror^^^^^^"
	
	s insadmstr=patid1_"^"_"I"_"^"_admdate_"^"_admtime_"^"_deptdr_"^"_docdr_"^"_readr_"^"_admuser_"^"_warddr_"^"_roomdr_"^"_beddr_"^"_episdr_"^"_admqkdr_"^"_refdocdr_"^"_""_"^"_""_"^"_AdmTimes_"^"_AdmsourceOfAttend_"^"_""_"^"_""_"^"_""_"^"_AdmPriorityID
	s admid=##class(web.DHCPAADM).ADMInsert(insadmstr)
	s admid=$p(admid,$c(1))
	
	i (admid="")  d
	.Trollback
	q:(admid="") "admerror^^^^^^"
	
	//新增长效诊断标识
	s rtn=##class(DHCDoc.Interface.Inside.Service).InsertPALongICD(admid, admuser)
	i (rtn'=0) d
	.Trollback
	q:(rtn'=0) rtn
	
	s rtn=##class(web.DHCDischargeHistory).SaveAdminDateTime(admid, admdate, admtime, 1, deptdr, warddr)
	i (rtn=-2) d
	.Trollback
	q:(rtn=-2) rtn
	
	k PLIST
	s PLIST(0)=admid
	s PLIST(3)=admdate
	s PLIST(4)=admtime
	s PLIST(7)=docdr
	s PLIST(8)=deptdr
	s PLIST(14)="5"
	s PLIST(15)="Y"
	s PLIST(16)=admdate
	s PLIST(17)=admtime
	s PLIST(18)=admuser
	&sql(INSERT INTO SQLUSER.PA_AdmTransaction Values PLIST())
	s retcode=retcode+SQLCODE
	i (retcode'=0)  d
	.Trollback
	q:(retcode'=0) retcode
	
	i (retcode=0)  d
	.k PLIST
	.s PLIST(0)=admid
	.s PLIST(3)=admdate
	.s PLIST(4)=admtime
	.s PLIST(9)=roomdr
	.s PLIST(10)=warddr
	.s PLIST(11)=beddr
	.s PLIST(14)="5"
	.s PLIST(16)=admdate
	.s PLIST(17)=admtime
	.s PLIST(18)=admuser
	.s roomtypedr=""
	.i (roomdr'="") d
	..i ($d(^PAROOM(roomdr))'=0)  d
  	...s roomtypedr=$p(^PAROOM(roomdr),"^",3)
	.s bedtypedr=""
	.s beddr=$g(beddr)
	.s beddr=$p(beddr,$c(1))
	.i (beddr'="")  d
  	..i $f(beddr,"||")'=0  d
  	...s beddr1=$p(beddr,"||",1)
  	...s beddr2=$p(beddr,"||",2)
  	...i $d(^PAWARD(beddr1,"BED",beddr2))'=0  d
  	....s bedtypedr=$p(^PAWARD(beddr1,"BED",beddr2),"^",2)
  	.s PLIST(34)=bedtypedr
  	.&sql(INSERT INTO SQLUSER.PA_AdmTransaction Values PLIST())
  	.s retcode=retcode+SQLCODE
  	.i (retcode'=0)  d
  	..Trollback
  	.i (retcode=0)  d
  	..s admtransid=$g(%ROWID)
  	..i ((admtransid'="")&&(admid'="")&&(beddr'="")) d
  	...&sql(update SQLUSER.pac_bed set BED_Available='N'  where bed_rowid=:beddr )
  	...s retcode=retcode+SQLCODE
  	...i (retcode'=0)  d
  	....Trollback
  	...i (retcode=0)  d
  	....k PLIST
  	....s PLIST(0)=beddr
  	....s PLIST(3)=admid
  	....s PLIST(4)="O"
  	....s PLIST(5)=admtransid
  	....&sql(INSERT INTO SQLUSER.PAC_BedAdm  VALUES PLIST())
  	....s retcode=retcode+SQLCODE
  	....i retcode'=0  d
  	.....Trollback
  	..i ((admtransid'="")&&(admid'="")&&(beddr="")) d
  	...k PLIST
  	...s PLIST(0)=warddr
  	...s PLIST(3)=admid
  	...s PLIST(4)="O"
  	...s PLIST(5)=admtransid
  	...&sql(INSERT INTO SQLUSER.PAC_WardAdm  VALUES PLIST())
  	...s retcode=retcode+SQLCODE
  	...i (retcode'=0)  d
  	....Trollback
  	q:(retcode'=0) retcode_"^^^^^^"
  	
  	i (retcode=0)  d
  	.i ((diagnosid'="")||(diagnosdesc'=""))  d
  	..;+2015-3-2 hujunbin 如果住院证下了诊断，则下诊断人为开住院证的人
  	..s DiagUser=admuser
  	..s ZYZReturn="", myDiag=""
  	..s:(IPBook'="")&&($d(^DHCDocIPBK(IPBook))) ZYZReturn=..GetIPBookInfo(IPBook)
  	..i (ZYZReturn'="-1")  d
  	...s myDiag=$p(ZYZReturn,"^",6)  //增加住院证接口,取诊断  20100506
  	...s mrDiagUser=$p($g(ZYZReturn),"^",9)  //开住院证人
  	...i ($g(diagnosid)=$g(myDiag))&($g(myDiag)'="") s DiagUser=mrDiagUser
  	..s mradmid=$p(^PAADM(admid),"^",61)
  	..//医生站提供新方法，要求插入发病日期  add zhli 18.3.19
  	..s diagStatusDR=$o(^MRC("DSTAT",0,"Code","01",0))
  	..s err=##class(web.DHCDocDiagnosEntryV8).InsertOneMRDiagnos(deptdr, mradmid, diagnosid, admuser, diagnosdesc, diagnostypeid, "", "", "", "", "", diagStatusDR, "", DiagUser, "N", "", "", "", +$h, "", +$h)
  	..i (+err=0)  d
  	...s retcode=0
  	..e  d
  	...s retcode=100
  	..i (retcode'=0)  d
  	...Trollback
  	
  	i (retcode=0)  d          //add  by  zhl 20111020  start
  	.i (+IPBook=0)&($g(patid)'="") s IPBook=..GetIPBNoByID(patid)
  	.i (+IPBook'=0)  d
	..s err=##class(web.DHCDocIPBookingCtl).PatientArrive(IPBook, admid, admuser)
	..s retcode=err
	..i (retcode'=0)  d
	...Trollback             //add  by  zhl 20111020  end
	
	s admno=""
	s admvisit=""
	i (retcode=0) d
	.s rtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADMINFO",admid)
	.s retcode=$p(rtn,"^",1)
	i (retcode=0) d
	.d ..tc()
	e  d
	.trollback
  
	i (retcode=0)  d
	.s admno=$p(^PAADM(admid),"^",81)
	.s admvisit="在院"
	.i (patid'="")  d
	..s patid2=patid
	.e  d
	..s patid2=mid
	.s idcard2=idcard_"Z"
	.s ^PAPERi("PAPMI_ICPPBC",idcard2,patid2)=""
	.s $p(^PAPER(patid2,"ALL"),"^",9)=idcard
  
	q retcode_"^"_mno_"^"_patid1_"^"_admid_"^"_admno_"^"_admvisit_"^"_medicare
}

ClassMethod tb()
{
	n SQLCODE
	TSTART  
	q
}

ClassMethod tc()
{
    n SQLCODE
    TCOMMIT  
	q
}

/// w ##class(web.UDHCJFIPReg).upreginfo("", "", "23","张彦武^100147^1^511702197108242276^24/08/1971^47岁^^    ^^^^^15584123695^^^^^^^^4632^1^1^20^511702197108242276^1^^^^^^^^^^^^^ZYW^47717^^^^^^^^^^^^^^^","902")
ClassMethod upreginfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", patid, patval, admid)
{
	s ^TMP("upreginfo")=$lb(patid, patval, admid)
	q:(patid="") "patiderror"
	q:(patval="") "patvalerror"
 	s admid=$g(admid)
 	s retcode=0
 	q:($d(^PAPER(patid))=0) "patiderror"
 	s upda=+$h
 	s uptime=$p($h,",",2)
 	s papnamenew=$p(patval,"^",1)
 	s medicarenew=$p(patval,"^",2)
 	s sexnew=$p(patval,"^",3)
 	s idcardnew=$p(patval,"^",4)
 	s birthnew=$p(patval,"^",5)
 	i (birthnew'="")  s birthnew=##class(websys.Conversions).DateHtmlToLogical(birthnew)
 	s agenew=$p(patval,"^",6),              ageyrnew=$p(patval,"^",7)
 	s agemthnew=$p(patval,"^",8),           agedaynew=$p(patval,"^",9)
 	s maridnew=$p(patval,"^",10),           rlgidnew=$p(patval,"^",11)
 	s addressnew=$p(patval,"^",12),         hometelnew=$p(patval,"^",13)
 	s zipidnew=$p(patval,"^",14),           companynew=$p(patval,"^",15)
 	s worktelnew=$p(patval,"^",16),         cityidnew=$p(patval,"^",17)
 	s providnew=$p(patval,"^",18),          mobtelnew=$p(patval,"^",19)
 	s emailnew=$p(patval,"^",20),           userid=$p(patval,"^",21)
 	s SocSatnew=$p(patval,"^",22),          nationnew=$p(patval,"^",23)
 	s papagenew="|||||||||||"_ageyrnew_"|"_agemthnew_"|"_agedaynew
 	s cdtpidnew=$p(patval,"^",24),          govcdnonew=$p(patval,"^",25)
 	s counidnew=$p(patval,"^",26),          occuidnew=$p(patval,"^",27)
 	s eduidnew=$p(patval,"^",28),           languidnew=$p(patval,"^",29)
 	s emptpidnew=$p(patval,"^",30),         birpidnew=$p(patval,"^",31)
 	s bircidnew=$p(patval,"^",32),          ctrltidnew=$p(patval,"^",33)
 	s ForeIdnew=$p(patval,"^",34),          FPhonenew=$p(patval,"^",35)
 	s FAddressnew=$p(patval,"^",36),        FNotesnew=$p(patval,"^",37) 
 	s ctareaidnew=$p(patval,"^",38)
 	s pycodenew=$p(patval,"^",39)
 	s soundx1=papnamenew_"00"
 	s papnameold=$p(^PAPER(patid,"ALL"),"^",1)
 	s pycodeold=$p(^PAPER(patid,"ALL"),"^",2)
 	s babydobnew1=$p(patval,"^",40),       babydobnew2=$p(patval,"^",41)
 	s hzipcodenew=$p(patval,"^",42),       czipcodenew=$p(patval,"^",43)
 	s InsuNoNew=$p(patval,"^",44),         HCPID=$p(patval,"^",45)
 	//modify 2012-10-13 增加修改户口地址、出生地地址等功能
 	s BirthProvDrNew=$p(patval,"^",46),   BirthCityDrNew=$p(patval,"^",47)
 	s BirthAreaDrNew=$p(patval,"^",48),    BirthAddressNew=$p(patval,"^",49)
 	s HouseProvDrNew=$p(patval,"^",50),    HouseCityDrNew=$p(patval,"^",51)
 	s HouseAreaDRNew=$p(patval,"^",52),    HouseAddressNew=$p(patval,"^",53)
 	s HouseZipCodeNew=$p(patval,"^",54)
 	s photo=$p(patval,"^",55)   //+2017-08-17 ZhYW

 	//modify 2014-11-19 将地址和单位带#号的自付转为全角"＃" 否则查询程序会有问题
 	i ($f(addressnew,"#")'=0)  d
  	.s addressnew=$tr(addressnew,"#","＃")
 	i ($f(companynew,"#")'=0)  d
 	.s companynew=$tr(companynew,"#","＃") 
 	i ($f(BirthAddressNew,"#")'=0)  d
 	.s BirthAddressNew=$tr(BirthAddressNew,"#","＃")
 	i ($f(HouseAddressNew,"#")'=0)  d
 	.s HouseAddressNew=$tr(HouseAddressNew,"#","＃")
 	//
 	s HCPIDold=$p($g(^PAPER(patid,"PER",4)),"^",17)
 	;s medicareold=$p($g(^PAPER(patid,"PAT",1)),"^",22)
	//update by zf 20150317 通过PatientID取住院病案号
	s medicareold=##Class(DHCWMR.IO.OutService).IGetMrNoByPatientID(patid, "I", "", "")
	//
 	s cdtpidold=$p($g(^PAPER(patid,"PAT",3)),"^",7)
	s sexold=$p($g(^PAPER(patid,"ALL")),"^",7)
	s idcardold=$p($g(^PAPER(patid,"ALL")),"^",9)
 
	s patid=$p(patid,$c(1))
 	&sql(select papmi_paper_dr into :paperid from pa_patmas where papmi_rowid=:patid)
 	s paperid=$p(paperid,$c(1))
 	&sql(select paper_dob,paper_ageyr,paper_agemth,paper_ageday,paper_age into :birthold,:ageyrold,:agemthold,:agedayold,:papageold 
    	from pa_person where paper_rowid=:paperid)
 	s maridold=$p($g(^PAPER(paperid,"PER",2)),"^",3)
	s rlgidold=$p($g(^PAPER(paperid,"PER",2)),"^",2)
	s nationold=$p($g(^PAPER(paperid,"PER",2)),"^",1)
	s occuidold=$p($g(^PAPER(paperid,"PER",2)),"^",6)
	s eduidold=$p($g(^PAPER(paperid,"PER",2)),"^",5)
	s birpidold=$p($g(^PAPER(paperid,"PER",2)),"^",11)
	s ForeIdold=$p($g(^PAPER(paperid,"PER",2)),"^",13)
	s providold=$p($g(^PAPER(paperid,"PER",4)),"^",2)
	s govcdnoold=$p($g(^PAPER(paperid,"PAT",3)),"^",6) 
	s ctareaidold=$p($g(^PAPER(paperid,"PER",4)),"^",9)
	s cityidold=$p($g(^PAPER(paperid,"PER",1)),"^",5)
	s zipidold=$p($g(^PAPER(paperid,"PER",1)),"^",7)
	s hometelold=$p($g(^PAPER(paperid,"PER",1)),"^",11)
	s worktelold=$p($g(^PAPER(paperid,"PER",1)),"^",9)
	s SocSatold=$p($g(^PAPER(paperid,"PER",1)),"^",10)
	s counidold=$p($g(^PAPER(paperid,"PER",1)),"^",8)
	s FAddressold=$p($g(^PAPER(paperid,"PER",1)),"^",1)
	s addressold=$g(^PAPER(paperid,"PER","ADD",1))
 	s mobtelold=$p($g(^PAPER(paperid,"PER",4)),"^",21)
 	s emailold=$p($g(^PAPER(paperid,"PER",4)),"^",19)
	s companyold=$p($g(^PAPER(paperid,"PER",4)),"^",18)
 	s languidold=$p($g(^PAPER(paperid,"ALL")),"^",10)
 	s emptpidold=$p($g(^PAPER(paperid,"EMP")),"^",1)
 	s ctrltold=$p($g(^PAPER(paperid,"EMP")),"^",4)
 	s bircidold=$p($g(^PAPER(paperid,"ALL")),"^",18)
	s FPhoneold=$p($g(^PAPER(paperid,"ALL")),"^",4)
 	s FNotesold=$g(^PAPERZYJF("Patinfo",patid))
 	//+2017-08-30 ZhYW 
 	s InsuNoOld=$p($g(^PAPER(paperid,"PAT",3)),"^",12)   //PA_PatMas.PAPMI_HealthFundNo
 	s babydobold1=##class(web.UDHCJFCOMMON).GetPatBirthDate(paperid)
 	s babydobold2=##class(web.UDHCJFCOMMON).GetPatBirthTime(paperid)
 	s hzipcodeold="", czipcodeold=""
	s BirthProvDrOld="", BirthCityDrOld="", BirthAreaDrOld="", BirthAddressOld="", HouseProvDrOld=""
 	s HouseCityDrOld="", HouseAreaDROld="", HouseAddressOld="", HouseZipCodeOld=""
 	s dhcpersonid=$o(^DHCPERSON(0,"PAPERSON",paperid,""))
 	s dhcpersonid=$p(dhcpersonid,$c(1))
 	i (dhcpersonid'="")  d
 	.s hzipcodeold=$p(^DHCPERSON(dhcpersonid),"^",8)
 	.s czipcodeold=$p(^DHCPERSON(dhcpersonid),"^",7)  
 	.//modify 2012-10-13 增加修改户口地址、出生地地址等功能
 	.s BirthProvDrOld=$p(^DHCPERSON(dhcpersonid),"^",13)
 	.s BirthCityDrOld=$p(^DHCPERSON(dhcpersonid),"^",14)
 	.s BirthAreaDrOld=$p(^DHCPERSON(dhcpersonid),"^",15)
 	.s BirthAddressOld=$p(^DHCPERSON(dhcpersonid),"^",16)
 	.s HouseProvDrOld=$p(^DHCPERSON(dhcpersonid),"^",17)
 	.s HouseCityDrOld=$p(^DHCPERSON(dhcpersonid),"^",18)
 	.s HouseAreaDROld=$p(^DHCPERSON(dhcpersonid),"^",19)
 	.s HouseAddressOld=$p(^DHCPERSON(dhcpersonid),"^",20)
 	.s HouseZipCodeOld=$p(^DHCPERSON(dhcpersonid),"^",9)
  
 	s admtimeold=""
 	//+2017-09-27 ZhYW
 	i (+admid'=0) d
 	.s admdateold=$p(^PAADM(admid),"^",6)
 	.s admtimeold=$p(^PAADM(admid),"^",7)
 	e  d
 	.s admdateold=+$h
 	.s admtimeold=$p($h,",",2)
 	//
	i (birthnew'=birthold)  d
 	.i (birthnew'="")  d
 	..s birthnewgx=$zd(birthnew,3)
 	..s admdateold=$zd(admdateold,3)
 	..s agestrgx=..getpatage(birthnewgx, admdateold)
 	..s ageyrnew=$p(agestrgx,"^",2)
 	..s agemthnew=$p(agestrgx,"^",3)
 	..s agedaynew=$p(agestrgx,"^",4)
 	..s papagenew="|||||||||||"_ageyrnew_"|"_agemthnew_"|"_agedaynew
 
	//2016-07-08 chenxi 增加判断 出生日期不能大于当前日期
	q:(birthnew'="")&&(birthnew>+$h) "BirthGreatthan"
	q:((babydobnew2'="")&&(babydobnew1=babydobold1)&&(babydobnew2>admtimeold)) "BabyDobError"
 	
	s upnum=0
	i ((papnamenew=papnameold)&&(sexnew=sexold)&&(idcardnew=idcardold)&&(maridnew=maridold)) d
	.s upnum=upnum+1
 	i ((rlgidnew=rlgidold)&&(hometelnew=hometelold)&&(zipidnew=zipidold)&&(companynew=companyold)) d
 	.s upnum=upnum+1
 	i ((worktelnew=worktelold)&&(providnew=providold)&&(emailnew=emailold)&&(mobtelnew=mobtelold)) d
 	.s upnum=upnum+1
  	i ((cityidnew=cityidold)&&(birthnew=birthold)&&(medicarenew=medicareold)&&(addressnew=addressold)&&(SocSatnew=SocSatold)) d
 	.s upnum=upnum+1
 	i ((nationnew=nationold)&&(cdtpidnew=cdtpidold)&&(govcdnonew=govcdnoold)&&(counidnew=counidold)&&(occuidnew=occuidold))  d
 	.s upnum=upnum+1
 	i ((eduidnew=eduidold)&&(languidnew=languidold)&&(emptpidnew=emptpidold)&&(birpidnew=birpidold)&&(bircidnew=bircidold))  d
 	.s upnum=upnum+1
 	i ((ctrltidnew=ctrltold)&&(ForeIdnew=ForeIdold)&&(FPhonenew=FPhoneold)&&(FAddressnew=FAddressold)&&(FNotesnew=FNotesold))  d
 	.s upnum=upnum+1
 	i (ctareaidnew=ctareaidold)&&(pycodenew=pycodeold)&&(babydobnew1=babydobold1)&&(babydobnew2=babydobold2)  d
 	.s upnum=upnum+1
 	i (((hzipcodenew=hzipcodeold)&&(czipcodenew=czipcodeold)&&(HCPIDold=HCPID)))  d
 	.s upnum=upnum+1
 	//modify 2012-10-13 增加修改户口地址、出生地地址等功能
 	i (($g(BirthProvDrNew)=$g(BirthProvDrOld))&&($g(BirthCityDrNew)=$g(BirthCityDrOld))&&($g(BirthAreaDrNew)=$g(BirthAreaDrOld))&&($g(BirthAddressNew)=$g(BirthAddressOld)))  d
 	.s upnum=upnum+1
 	i (($g(HouseProvDrNew)=$g(HouseProvDrOld))&&($g(HouseCityDrNew)=$g(HouseCityDrOld))&&($g(HouseAreaDRNew)=$g(HouseAreaDROld))&&($g(HouseAddressNew)=$g(HouseAddressOld))&&($g(HouseZipCodeNew)=$g(HouseZipCodeOld)))  d
 	.s upnum=upnum+1
 	//+2017-08-30 ZhYW
 	i (InsuNoOld=InsuNoNew) d
 	.s upnum=upnum+1
 	//
 	q:(upnum=12) "patvalno"

	TSTART
	&sql(update SQLUSER.pa_person 
       set paper_name =:papnamenew,             paper_sex_dr =:sexnew,
            paper_id=:idcardnew,                PAPER_Marital_DR=:maridnew,
            PAPER_Religion_DR=:rlgidnew,        PAPER_TelH=:hometelnew,
	        PAPER_Zip_DR=:zipidnew,             PAPER_SecondPhone=:companynew,
	        PAPER_TelO=:worktelnew,             PAPER_CT_Province_DR=:providnew,
	        PAPER_Email=:emailnew,              PAPER_MobPhone=:mobtelnew,
	        PAPER_CityCode_DR=:cityidnew,       paper_userupdate=:userid,
	        paper_updatedate=:upda,             paper_updatetime=:uptime,
	        PAPER_SocialStatus_DR=:SocSatnew,   PAPER_Nation_DR=:nationnew,
	        PAPER_Country_DR=:counidnew,
	        PAPER_Occupation_DR=:occuidnew,     PAPER_Education_DR=:eduidnew,
	        PAPER_LangPrim_DR=:languidnew,      PAPER_EmplType_DR=:emptpidnew,
	        PAPER_Province_Birth_DR=:birpidnew, PAPER_CityBirth_DR=:bircidnew,
	        PAPER_CTRLT_DR=:ctrltidnew,         PAPER_ForeignId=:ForeIdnew,
	        PAPER_ForeignPhone=:FPhonenew,      PAPER_ForeignAddress=:FAddressnew,
	        PAPER_CityArea_DR=:ctareaidnew ,    paper_name2=:pycodenew,
	        PAPER_Soundex1=:soundx1,            
          	PAPER_HCP_DR=:HCPID,                PAPER_Photo=:photo            
        where paper_rowid=:paperid)
	s retcode=retcode+SQLCODE
	&sql(update SQLUSER.pa_person 
       	set paper_dob=:birthnew,              paper_age=:papagenew,
	        paper_ageday=:agedaynew,           paper_agemth=:agemthnew,
	        paper_ageyr=:ageyrnew 
        where paper_rowid=:paperid)
	s retcode=retcode+SQLCODE
	i (retcode=0)  d
	.//update by zf 20150318 屏蔽住院登记修改病人信息表病案号
	.//PAPMI_Medicare=:medicarenew,
	.&sql(update SQLUSER.pa_patmas
	                set  PAPMI_SafetyNetCardNo=:medicarenew,
	                     PAPMI_CardType_DR=:cdtpidnew,
	                     PAPMI_DVAnumber=:govcdnonew,
	                     PAPMI_HealthFundNo=:InsuNoNew
	                where papmi_rowid=:patid)
   	.s retcode=retcode+SQLCODE
	i (retcode=0)  d
	.i (dhcpersonid'="")  d
	..&sql(update DHC_Person 
          set PAPER_Comment1=:czipcodenew                  ,PAPER_Comment2=:hzipcodenew, 
              PAPER_BirthProvince_DR=:BirthProvDrNew       ,PAPER_BirthCity_DR=:BirthCityDrNew,
              PAPER_BirthArea_dr=:BirthAreaDrNew           ,PAPER_BirthAddress=:BirthAddressNew,
              PAPER_HouseProvince_DR=:HouseProvDrNew       ,PAPER_HouseCity_DR=:HouseCityDrNew,
              PAPER_HouseArea_DR=:HouseAreaDRNew           ,PAPER_HouseAddress=:HouseAddressNew,
              PAPER_Comment3=:HouseZipCodeNew 
          where PAPER_RowID=:dhcpersonid)
  
	..s retcode=retcode+SQLCODE
	.e  d
    ..&sql(insert into SQLUSER.DHC_Person(PAPER_PaPerson_dr,PAPER_Comment1,PAPER_Comment2,PAPER_BirthProvince_DR,PAPER_BirthCity_DR,
                                         PAPER_BirthArea_dr,PAPER_BirthAddress,PAPER_HouseProvince_DR,PAPER_HouseCity_DR,PAPER_HouseArea_DR,
                                         PAPER_HouseAddress,PAPER_Comment3)  
                                  values(:paperid,:czipcodenew,:hzipcodenew,:BirthProvDrNew,:BirthCityDrNew,:BirthAreaDrNew,:BirthAddressNew,:HouseProvDrNew,:HouseCityDrNew,
                                         :HouseAreaDRNew,:HouseAddressNew,:HouseZipCodeNew))
	..s retcode=retcode+SQLCODE

	i (retcode=0)  d
   .i (papnamenew'=papnameold)  d
   ..s t1="PA_Person",  t2="PAPER_Name"
   ..s t3=papnameold, t4=papnamenew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((pycodenew'=pycodeold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_Name2"
   ..s t3=pycodeold, t4=pycodenew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((sexnew'=sexold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_Sex_DR"
   ..s t3=sexold, t4=sexnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((idcardnew'=idcardold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_ID"
   ..s t3=idcardold, t4=idcardnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((maridnew'=maridold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_Marital_DR"
	..s t3=maridold, t4=maridnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((rlgidnew'=rlgidold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_Religion_DR"
   ..s t3=rlgidold, t4=rlgidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((hometelnew'=hometelold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_TelH"
   ..s t3=hometelold, t4=hometelnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((zipidnew'=zipidold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_Zip_DR"
   ..s t3=zipidold, t4=zipidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((companynew'=companyold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_SecondPhone"
   ..s t3=companyold, t4=companynew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((worktelnew'=worktelold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_TelO"
   ..s t3=worktelold, t4=worktelnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((providnew'=providold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_CT_Province_DR"
   ..s t3=providold, t4=providnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((emailnew'=emailold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_Email"
   ..s t3=emailold, t4=emailnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((mobtelnew'=mobtelold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_MobPhone"
   ..s t3=mobtelold, t4=mobtelnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((cityidnew'=cityidold)&&(retcode=0)) d
   ..s t1="PA_Person", t2="PAPER_CityCode_DR"
   ..s t3=cityidold, t4=cityidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((SocSatnew'=SocSatold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_SocialStatus_DR"
   ..s t3=SocSatold, t4=SocSatnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((birthnew'="")&&(retcode=0))  d
   ..i (birthnew'=birthold)  d
   ...s t1="PA_Person", t2="PAPER_Dob"
   ...i (birthold'="")  d
   ....s t3=$zd(birthold,3)
   ...e  d
   ....s t3=""
   ...i (birthnew'="")  d
   ....s t4=$zd(birthnew,3)
   ...s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ...s retcode=retcode+err
   ...i (retcode=0)  d
   ....s t1="PA_Person", t2="PAPER_Age"
   ....s t3=papageold, t4=papagenew
   ....s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ....s retcode=retcode+err
   ...i ((ageyrnew'=ageyrold)&&(retcode=0))  d
   ....s t1="PA_Person", t2="PAPER_AgeYr"
   ....s t3=ageyrold, t4=ageyrnew
   ....s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ....s retcode=retcode+err
   ...i ((agemthnew'=agemthold)&&(retcode=0))  d
   ....s t1="PA_Person",  t2="PAPER_AgeMth"
   ....s t3=agemthold, t4=agemthnew
   ....s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ....s retcode=retcode+err
   ...i ((agedaynew'=agedayold)&&(retcode=0))  d
   ....s t1="PA_Person", t2="PAPER_AgeDay"
   ....s t3=agedayold, t4=agedaynew
   ....s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ....s retcode=retcode+err
   .i ((medicarenew'=medicareold)&&(retcode=0))  d
   ..s t1="PA_PatMas", t2="PAPMI_SafetyNetCardNo"
   ..s t3=medicareold, t4=medicarenew
   ..s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i (nationnew'=nationold)  d
   ..s t1="PA_Person", t2="PAPER_Nation_DR"
   ..s t3=nationold, t4=nationnew
   ..s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((addressnew'=addressold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_StName"
   ..s t3=addressold, t4=addressnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((cdtpidnew'=cdtpidold)&&(retcode=0))  d
   ..s t1="PA_PatMas", t2="PAPMI_CardType_DR"
   ..s t3=cdtpidold, t4=cdtpidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((govcdnonew'=govcdnoold)&&(retcode=0))  d
   ..s t1="PA_PatMas", t2="PAPMI_DVAnumber"
   ..s t3=govcdnoold, t4=govcdnonew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((counidnew'=counidold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_Country_DR"
   ..s t3=counidold, t4=counidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((occuidnew'=occuidold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_Occupation_DR"
   ..s t3=occuidold, t4=occuidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((eduidnew'=eduidold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_Education_DR"
   ..s t3=eduidold, t4=eduidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((languidnew'=languidold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_LangPrim_DR"
   ..s t3=languidold, t4=languidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((emptpidnew'=emptpidold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_EmplType_DR"
   ..s t3=emptpidold, t4=emptpidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((birpidnew'=birpidold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_Province_Birth_DR"
   ..s t3=birpidold, t4=birpidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((bircidnew'=bircidold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_CityBirth_DR"
   ..s t3=bircidold, t4=bircidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((ctrltidnew'=ctrltold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_CTRLT_DR"
   ..s t3=ctrltold, t4=ctrltidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((ForeIdnew'=ForeIdold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_ForeignId"
   ..s t3=ForeIdold, t4=ForeIdnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((FPhonenew'=FPhoneold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_ForeignPhone"
   ..s t3=FPhoneold, t4=FPhonenew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((FAddressnew'=FAddressold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_ForeignAddress"
   ..s t3=FAddressold, t4=FAddressnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((FNotesnew'=FNotesold)&&(retcode=0))  d
   ..s t1="PAPERZYJFGlobal", t2="PatNote"
   ..s t3=FNotesold, t4=FNotesnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((ctareaidnew'=ctareaidold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_CityArea_DR"
   ..s t3=ctareaidold, t4=ctareaidnew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((babydobnew1'=babydobold1)&(retcode=0))  d
   ..s t1="PA_Person", t2="BabyBirth1"
   ..s t3=babydobold1, t4=babydobnew1
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((babydobnew2'=babydobold2)&&(retcode=0))  d
   ..s t1="PA_Person", t2="BabyBirth2"
   ..s t3=babydobold2, t4=babydobnew2
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((hzipcodenew'=hzipcodeold)&&(retcode=0))  d
   ..s t1="DHC_Person", t2="PAPER_Comment1"
   ..s t3=hzipcodeold, t4=hzipcodenew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((czipcodenew'=czipcodeold)&&(retcode=0))  d
   ..s t1="DHC_Person", t2="PAPER_Comment2"
   ..s t3=czipcodeold, t4=czipcodenew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i (retcode=0)  d
   ..S ^PAPER(patid,"PER","ADD",0)=1
   ..S ^PAPER(patid,"PER","ADD",1)=addressnew
   ..s ^PAPERZYJF("Patinfo",patid)=FNotesnew
   .i (((babydobnew1'=babydobold1)||(babydobnew2'=babydobold2))&&(retcode=0))  d
   ..s err=##class(web.UDHCJFCOMMON).SaveNewBabyDob(patid, babydobnew1, babydobnew2)
   ..s retcode=retcode+err
   .i ((InsuNoNew'=InsuNoOld)&&(retcode=0))  d
   ..s t1="PA_PatMas", t2="PAPMI_HealthFundNo"
   ..s t3=InsuNoOld, t4=InsuNoNew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((HCPID'=HCPIDold)&&(retcode=0))  d
   ..s t1="PA_Person", t2="PAPER_HCP_DR"
   ..s t3=HCPIDold, t4=HCPID
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((BirthProvDrNew'=BirthProvDrOld)&&(retcode=0))  d
   ..s t1="DHC_Person", t2="PAPER_BirthProvince_DR"
   ..s t3=BirthProvDrOld, t4=BirthProvDrNew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((BirthCityDrNew'=BirthCityDrOld)&&(retcode=0))  d
   ..s t1="DHC_Person", t2="PAPER_BirthCity_DR"
   ..s t3=BirthCityDrOld, t4=BirthCityDrNew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((BirthAreaDrNew'=BirthAreaDrOld)&&(retcode=0))  d
   ..s t1="DHC_Person", t2="PAPER_BirthArea_dr"
   ..s t3=BirthAreaDrOld, t4=BirthAreaDrNew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((BirthAddressNew'=BirthAddressOld)&&(retcode=0))  d
   ..s t1="DHC_Person", t2="PAPER_BirthAddress"
   ..s t3=BirthAddressOld, t4=BirthAddressNew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i (HouseProvDrNew'=HouseProvDrOld)&&(retcode=0)  d
   ..s t1="DHC_Person", t2="PAPER_HouseProvince_DR"
   ..s t3=HouseProvDrOld, t4=HouseProvDrNew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((HouseCityDrNew'=HouseCityDrOld)&&(retcode=0))  d
   ..s t1="DHC_Person", t2="PAPER_HouseCity_DR"
   ..s t3=HouseCityDrOld, t4=HouseCityDrNew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((HouseAreaDRNew'=HouseAreaDROld)&&(retcode=0))  d
   ..s t1="DHC_Person", t2="PAPER_HouseArea_DR"
   ..s t3=HouseAreaDROld, t4=HouseAreaDRNew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((HouseAddressNew'=HouseAddressOld)&&(retcode=0))  d
   ..s t1="DHC_Person", t2="PAPER_HouseAddress"
   ..s t3=HouseAddressOld, t4=HouseAddressNew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err
   .i ((HouseZipCodeNew'=HouseZipCodeOld)&&(retcode=0))  d
   ..s t1="DHC_Person", t2="PAPER_Comment3"
   ..s t3=HouseZipCodeOld, t4=HouseZipCodeNew
   ..s err=..insupreport(paperid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
   ..s retcode=retcode+err

	i (retcode'=0)  d
	.Trollback
	e  d
	.TCommit    
	
	i (retcode=0)  d
	.s idcard2=idcardnew_"Z"
	.s ^PAPERi("PAPMI_ICPPBC",idcard2,patid)=""
	.s $p(^PAPER(patid,"ALL"),"^",9)=idcardnew 
 
	q retcode
}

ClassMethod insupreport(up1, up2, up3, up4, up5, up6, up7, up8, up9, up10, up11, up12, up13, up14)
{
	k PLIST
	s PLIST(2)=up1
	s PLIST(3)=up2
	s PLIST(4)=up3
	s PLIST(5)=up4
	s PLIST(6)=up5
	s PLIST(7)=up6
	s PLIST(8)=up7
	s PLIST(9)=up8
	s PLIST(10)=up9
	s PLIST(11)=up10
	s PLIST(12)=up11
	s PLIST(13)=up12
	s PLIST(14)=up13
	s PLIST(15)=up14
	&sql(INSERT INTO SQLUSER.DHC_JFUpReport Values PLIST())	
	q SQLCODE
}

/// w ##class(web.UDHCJFIPReg).upadminfo("", "", 5515, "1^^^^5816^^^156^44^^^22/09/2017^", 8942)
ClassMethod upadminfo(itmjs As %Library.String = "", itmjsex As %Library.String = "", admid, admval, patid)
{
 	s ^TMP("upadminfo")=admid_","_admval_","_patid
 	q:(admid="") "admiderror"
 	q:(admval="") "admvalerror"
 	q:(patid="") "admiderror"
 	;admreaid^admepisid^admryqkid^userid^admrefdocid
 	s retcode=0
 	q:($d(^PAADM(admid))=0) "admiderror"
 	q:($d(^PAPER(patid))=0) "admiderror"
  
 	s CurDate=+$h
 	s upda=+$h
	s uptime=$p($h,",",2)
 	s admreaidnew=$p(admval,"^",1)
 	s admepisidnew=$p(admval,"^",2) 
 	s admryqkidnew=$p(admval,"^",3)
 	s admrefdocidnew=$p(admval,"^",4)
 	s userid=$p(admval,"^",5)
 	s depDr=$p(admval,"^",8)
 	s wardDr=$p(admval,"^",9)
 	s AdmDoc=$p(admval,"^",10)
 	s AdmSource=$p(admval,"^",11)
 	s AdmDateNew=$p(admval,"^",12)
 	i AdmDateNew'="" s AdmDateNew=##class(websys.Conversions).DateHtmlToLogical(AdmDateNew)
 	s AdmPriorityIDNew=$p(admval,"^",13)
 
 	s admreaidold=$p(^PAADM(admid,1),"^",7)
 	s admepisidold=$p(^PAADM(admid,1),"^",6)
 	s admryqkidold=$p(^PAADM(admid),"^",5)
 	s admrefdocidold=$p(^PAADM(admid),"^",82)
 	s depDrOld=$p(^PAADM(admid),"^",4)
  	s wardDrOld=$p(^PAADM(admid),"^",70)
 	s BedRowID=$p(^PAADM(admid),"^",73)
 	s AdmDate=$p(^PAADM(admid),"^",6)
 	s AdmDocOld=$p(^PAADM(admid),"^",9)
 	s AdmSourceOld=$p(^PAADM(admid),"^",10)
 	s AdmPriorityIDOld=$p(^PAADM(admid,1),"^",52)  
  
 	i (depDrOld'=depDr)  d 
 	.s UpDeptFlag="N"
 	e  d
 	.s UpDeptFlag="Y"
 	i (wardDrOld'=wardDr)  d
 	.s UpWardFlag="N"
 	e  d
 	.s UpWardFlag="Y"
 	i (AdmDocOld'=AdmDoc)  d
 	.s UpDocFlag="N"
 	e  d
 	.s UpDocFlag="Y"
 
	s upnum=0
 	i ((admreaidnew=admreaidold)&(admepisidnew=admepisidold)&(admryqkidnew=admryqkidold)&(admrefdocidnew=admrefdocidold)&(depDr=depDrOld)&(wardDr=wardDrOld)&(AdmDocOld=AdmDoc)&(AdmSource=AdmSourceOld)&(AdmPriorityIDOld=AdmPriorityIDNew)) d
 	.s upnum=upnum+1
 	q:(upnum=1) "admvalno"
 
 	q:((AdmDateNew'="")&(AdmDate'=AdmDateNew)!(AdmDateNew="")) "AdmDateErr"
 	q:(BedRowID'="")&(UpDeptFlag'="Y") "BedErr"
	q:(BedRowID'="")&(UpWardFlag'="Y") "BedErr"
	
	s wardBedLeftNum=..GetWardBedIdleNum(wardDr)
  	q:((UpWardFlag'="Y")&&(wardBedLeftNum'>0)) "-1001"  //+2018-01-19 ZhYW 判断病区剩余床位

 	q:($d(^OEORD(0,"Adm",admid))&($g(UpDeptFlag)'="Y")) "-1002"  ;按医嘱控制，如果有医嘱不能修改病区
 	q:($d(^OEORD(0,"Adm",admid))&($g(UpWardFlag)'="Y")) "-1002"  ;按医嘱控制，如果有医嘱不能修改病区
 	q:($d(^OEORD(0,"Adm",admid))&($g(UpDocFlag)'="Y")) "-1003"   ;按医嘱控制，如果有医嘱不能修改医生
 	q:(AdmDate'=CurDate)&($g(UpDeptFlag)'="Y") "AdmDateErr"
 	q:(AdmDate'=CurDate)&($g(UpWardFlag)'="Y") "AdmDateErr"
 	s TransSub="0",TransNum=0
 	f  s TransSub=$o(^PAADM(admid,"TRANS",TransSub))  q:(TransSub="")  d
 	.s TransNum=TransNum+1 
 	q:(TransNum>2)&(UpDeptFlag'="Y") "AdmTransErr" 
 	q:(TransNum>2)&(UpWardFlag'="Y") "AdmTransErr"
 	;q:(TransNum>2)&($g(UpDocFlag)'="Y") "AdmTransErr" ;2014-12-25 tang 暂时放开，不能根据转科表2条记录就不能修改医生，这块判断比较复杂

	TSTART
 	&sql(update SQLUSER.pa_adm 
    	set PAADM_AdmCateg_DR =:admryqkidnew,           
            PAADM_AdmReason_DR=:admreaidnew,     
            PAADM_Epissubtype_DR=:admepisidnew,
            PAADM_UpdateDate=:upda,
            PAADM_UpdateTime=:uptim,
            PAADM_UpdateUser_DR=:userid,
            PAADM_RefDocList_DR=:admrefdocidnew,
            PAADM_DepCode_DR=:depDr,
            PAADM_CurrentWard_DR=:wardDr,
            PAADM_AdmDocCodeDR=:AdmDoc,
            PAADM_AdmSrc_DR=:AdmSource,
            PAADM_ReferralPriority_DR=:AdmPriorityIDNew
        where paadm_rowid=:admid)
	s retcode=retcode+SQLCODE
  
	i ((depDr'="")&(depDr'=depDrOld)&(retcode=0)) d
  	.s transSub="",transCTLocDr=""
  	.f  s transSub=$o(^PAADM(admid,"TRANS",transSub)) q:((transSub="")!(transCTLocDr'=""))  d
  	..s transCTLocDr=$p(^PAADM(admid,"TRANS",transSub),"^",6)
  	..q:transCTLocDr=""
  	..s transRowid=admid_"||"_transSub
  	..&sql(update SQLUSER.PA_AdmTransaction
      	  	set TRANS_CTLOC_DR=:depDr where TRANS_RowId=:transRowid )
  	..s retcode=retcode+SQLCODE    	  
  	
  	/*
  	i (BedRowID="")  d
  	.s wardsubid=$o(^PAWARDA(0,"WADM",admid,wardDrOld,""))
  	.i (wardsubid'="")&(wardsubid'=0)  d
  	..s wardsubrowid=wardDrOld_"||"_wardsubid
  	..&sql(delete from PAC_WardAdm where WADM_RowId=:wardsubrowid)
  	..s retcode=SQLCODE
  	*/
  	
  	i ((wardDr'="")&(wardDr'=wardDrOld)&(retcode=0)) d
  	.s transSub="",transWardDr=""
  	.f  s transSub=$o(^PAADM(admid,"TRANS",transSub)) q:((transSub="")!(transWardDr'=""))  d
  	..s transWardDr=$p(^PAADM(admid,"TRANS",transSub),"^",9)
  	..q:transWardDr=""
  	..s transRowid=admid_"||"_transSub
  	..&sql(update SQLUSER.PA_AdmTransaction
      	 	set TRANS_Ward_DR=:wardDr where TRANS_RowId=:transRowid)
  	..s retcode=retcode+SQLCODE  
  	..i (retcode=0)&(wardDrOld'="")  d
  	...s wardsub=$o(^PAWARDA(0,"WADM",admid,wardDrOld,"0"))
  	...q:wardsub=""
 	...s wardadmdr=wardDrOld_"||"_wardsub
  	...&sql(delete from SQLUSER.PAC_WardAdm where WADM_RowId=:wardadmdr)
  	...s retcode=retcode+SQLCODE  
  	...q:retcode   
  	..k PLIST
  	..s PLIST(0)=wardDr
  	..s PLIST(3)=admid
  	..s PLIST(4)="O"
  	..s PLIST(5)=transRowid
  	..&sql(INSERT INTO SQLUSER.PAC_WardAdm  Values PLIST())
  	..s retcode=retcode+SQLCODE
  
	//转科记录表里只有两条记录且医生没有开医嘱时可以修改住院医生，更新到转科记录表里的第一条记录
  	i ((AdmDoc'=AdmDocOld)&(retcode=0)) d
  	.s transSub="0",transCTLocDr=""
  	.s transSub=$o(^PAADM(admid,"TRANS",transSub))
  	.i +transSub'=0  d
 	..s transRowid=admid_"||"_transSub 
  	..&sql(update SQLUSER.PA_AdmTransaction
      	 	set TRANS_CTCP_DR=:AdmDoc where TRANS_RowId=:transRowid )
  	..s retcode=retcode+SQLCODE    	  
  
  	i (retcode=0)  d
  	.i admryqkidnew'=admryqkidold  d
  	..s t1="PA_Adm",t2="PAADM_AdmCateg_DR"
  	..s t3=admryqkidold,t4=admryqkidnew
  	..s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
  	..s retcode=retcode+err
  	.i (admreaidnew'=admreaidold)&(retcode=0)  d
  	..;s t1="PA_Adm" ,t2="PAADM_AdmReason_DR"
  	..;s t3=admreaidold ,t4=admreaidnew
  	..;s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
  	..;s retcode=retcode+err
  	.i (admepisidnew'=admepisidold)&(retcode=0)  d
  	..s t1="PA_Adm", t2="PAADM_Epissubtype_DR"
  	..s t3=admepisidold ,  t4=admepisidnew
  	..s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
  	..s retcode=retcode+err
  	.i (depDr'=depDrOld)&(retcode=0)  d
  	..s t1="PA_Adm", t2="PAADM_DepCode_DR"
  	..s t3=depDrOld ,  t4=depDr
 	..s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
  	..s retcode=retcode+err
  	.i (wardDr'=wardDrOld)&(retcode=0)  d
  	..s t1="PA_Adm", t2="PAADM_CurrentWard_DR"
  	..s t3=wardDrOld ,  t4=wardDr
  	..s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
  	..s retcode=retcode+err
  	.i (AdmDoc'=AdmDocOld)&(retcode=0)  d
  	..s t1="PA_Adm", t2="PAADM_AdmDocCodeDr"
  	..s t3=AdmDocOld ,  t4=AdmDoc
  	..s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
  	..s retcode=retcode+err
  	.i (AdmSource'=AdmSourceOld)&(retcode=0)  d
  	..s t1="PA_Adm", t2="PAADM_AdmSrc_DR"
  	..s t3=AdmSourceOld ,  t4=AdmSource
  	..s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
  	..s retcode=retcode+err
  	.i (admrefdocidnew'=admrefdocidold)&(retcode=0)  d
  	..s t1="PA_Adm", t2="PAADM_RefDocList_DR"
  	..s t3=admrefdocidold ,  t4=admrefdocidnew
  	..s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
  	..s retcode=retcode+err
  	.i (AdmPriorityIDNew'=AdmPriorityIDOld)&(retcode=0)  d
  	..s t1="PA_Adm", t2="PAADM_ReferralPriority_DR"
  	..s t3=AdmPriorityIDOld ,  t4=AdmPriorityIDNew
  	..s err=..insupreport(patid,admid,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
  	..s retcode=retcode+err
  	;修改病人费别时，同时修改Pa_Adm和dhc_patientbill表
  	i retcode=0 d
  	.d ..IUpdateAdmReason(admid,admreaidold, admreaidnew, userid, "")
  
	i (retcode'=0)  d
  	.Trollback
  	e  d
  	.TCommit    
  	
  	q retcode
}

Query admziplookup(desc As %String, provid As %String, cityid As %String, cityareaid As %String) As websys.Query(ROWSPEC = "zipdesc:%String,zipcode:%String,cityarea:%String,citydesc:%String,provdesc:%String,zipid:%String,cityareaid:%String,cityid:%String,provid:%String")
{
}

ClassMethod admziplookupExecute(ByRef qHandle As %Binary, desc As %String, provid As %String, cityid As %String, cityareaid As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
	set zipdesc="",zipcode="",cityarea="",citydesc="",provdesc=""
	set rowid="",cityareadr="",citydr="",provdr=""
	do OutputRow6
	set rowid="0"
	for  set rowid=$o(^CT("ZIP",rowid))  quit:(rowid="")  do
	.set zipdesc=$p(^CT("ZIP",rowid),"^",2)
	.set zipdesc1=$$ALPHAUP^SSUTIL4(zipdesc)
	.set zipcode=$p(^CT("ZIP",rowid),"^",1)
	.set citydr=$p(^CT("ZIP",rowid),"^",6)
	.set provdr=$p(^CT("ZIP",rowid),"^",4)
	.set cityareadr=$p(^CT("ZIP",rowid),"^",7)
	.quit:(citydr="")
	.quit:(provdr="")
	.;quit:(cityareadr="")
	.quit:($d(^CT("CIT",citydr))=0)
	.quit:($d(^CT("PROV",provdr))=0)
	.;quit:($d(^CT("CITAREA",cityareadr))=0)
	.quit:(cityid'="")&(cityid'=citydr)
	.quit:(provid'="")&(provid'=provdr)
	.;quit:(cityareaid'="")&(cityareaid'=cityareadr)
	.;set cityarea=$p(^CT("CITAREA",cityareadr),"^",2)
	.if ($f(cityarea,"-")'=0)  do
	..set cityarea=$p(cityarea,"-",2)
	.set citydesc=$p(^CT("CIT",citydr),"^",2)
	.if ($f(citydesc,"-")'=0)  do
	..set citydesc=$p(citydesc,"-",2)
	.set provdesc=$p(^CT("PROV",provdr),"^",2)
	.if ($f(provdesc,"-")'=0)  do
	..set provdesc=$p(provdesc,"-",2)
	.if (desc'="")  do
	..if (zipdesc1[desc)  do
	...if ($f(zipdesc,"-")'=0)  do
    ....set zipdesc=$p(zipdesc,"-",2)
    ...do OutputRow6
 	.else  do
 	..if ($f(zipdesc,"-")'=0)  do
    ...set zipdesc=$p(zipdesc,"-",2)
    ..do OutputRow6
    
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow6
	set Data=$lb(zipdesc,zipcode,cityarea,citydesc,provdesc,rowid,cityareadr,citydr,provdr)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query admcitylookup(desc As %String, provid As %String) As websys.Query(ROWSPEC = "citydesc:%String,provdesc:%String,cityid:%String,provid:%String")
{
}

ClassMethod admcitylookupExecute(ByRef qHandle As %Binary, desc As %String, provid As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
	set citydesc="",provdesc="",rowid="0",provdr=""
	do OutputRow7
	set rowid="0"
	for  set rowid=$o(^CT("CIT",rowid))  quit:(rowid="")  do
	.set citydesc=$p(^CT("CIT",rowid),"^",2)
	.set stdate=$p(^CT("CIT",rowid),"^",5)
	.set enddate=$p(^CT("CIT",rowid),"^",6)
	.quit:(((stdate>+$h)&&(stdate'=""))||((enddate<+$h)&&(enddate'="")))    ;不在有效期的城市不显示 add zhli  17.9.7
	.set citydesc1=$$ALPHAUP^SSUTIL4(citydesc)
	.set provdr=$p(^CT("CIT",rowid),"^",4)
	.quit:(provdr="")
	.quit:(provid'="")&(provdr'=provid)
	.set provdesc=$p(^CT("PROV",provdr),"^",2)
	.if ($f(provdesc,"-")'=0)  do
	..set provdesc=$p(provdesc,"-",2)
	.if (desc'="")  do
	..if (citydesc1[desc)  do
	...if ($f(citydesc,"-")'=0)  do
    ....set citydesc=$p(citydesc,"-",2)
    ...do OutputRow7
 	.else  do
 	..if ($f(citydesc,"-")'=0)  do
    ...set citydesc=$p(citydesc,"-",2)
    ..do OutputRow7
    
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow7
	set Data=$lb(citydesc,provdesc,rowid,provdr)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query admprovlookup(desc As %String) As websys.Query(ROWSPEC = "provdesc:%String,provid:%String")
{
}

ClassMethod admprovlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
	set provdesc="",rowid="0"
	do OutputRow8
	set rowid="0"
	for  set rowid=$o(^CT("PROV",rowid))  quit:(rowid="")  do
	.set provdesc=$p(^CT("PROV",rowid),"^",2)
	.set provdesc1=$$ALPHAUP^SSUTIL4(provdesc)
	.set stdate=$p(^CT("PROV",rowid),"^",4)
	.set enddate=$p(^CT("PROV",rowid),"^",5)
	.quit:(((stdate>+$h)&&(stdate'=""))||((enddate<+$h)&&(enddate'=""))) ;不在有效期的地址不显示 add zhli  17.9.7
	.if ($f(provdesc,"-")'=0)  do
	..set provdesc=$p(provdesc,"-",2)
	.if (desc'="")  do
	..if (provdesc1[desc)  do
	...if ($f(provdesc,"-")'=0)  do
    ....set provdesc=$p(provdesc,"-",2)
    ...do OutputRow8
 	.else  do
 	..if ($f(provdesc,"-")'=0)  do
    ...set provdesc=$p(provdesc,"-",2)
    ..do OutputRow8
    
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow8
	set Data=$lb(provdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod getadminfo(admid)
{
	n (admid)
	q:(admid="") "-1^"
	q:($d(^PAADM(admid))=0) "-2^"
	
	s papmiid=$p(^PAADM(admid),"^",1)
	s admtimes=0
	i (papmiid'="")  d
	.s admrowid=0
	.f  s admrowid=$o(^PAPERdr(papmiid,"ADM","I",admrowid))  q:(admrowid="")  d
	..s visstatus=$p(^PAADM(admrowid),"^",20)
	..q:((visstatus="C")||(visstatus="P"))
	..s admtimes=admtimes+1
	
	s admdeptdr=$p(^PAADM(admid),"^",4)
	s admdeptdesc=""
	i (+admdeptdr'=0)  d
	.s admdeptdesc=$p($g(^CTLOC(admdeptdr)),"^",2)
	.i ($f(admdeptdesc,"-")'=0)  d
	..s admdeptdesc=$p(admdeptdesc,"-",2)
	s admdeptdesc=admdeptdr_"@"_admdeptdesc
	
	s admwarddr=$p(^PAADM(admid),"^",70)
	s admwarddesc=""
	i (+admwarddr'=0)  d
	.s admwarddesc=$p($g(^PAWARD(admwarddr)),"^",2)
	.i ($f(admwarddesc,"-")'=0)  d
	..s admwarddesc=$p(admwarddesc,"-",2)
	s admwarddesc=admwarddr_"@"_admwarddesc

	s admroomdr=$p(^PAADM(admid),"^",69)
	s admroomdesc=""
	i (+admroomdr'=0)  d
	.s admroomdesc=$p($g(^PAROOM(admroomdr)),"^",2)
	.i ($f(admroomdesc,"-")'=0)  d
	..s admroomdesc=$p(admroomdesc,"-",2)
	s admroomdesc=admroomdr_"@"_admroomdesc
	
	s admbeddr=$p(^PAADM(admid),"^",73)
	s admbeddesc=""
	i (admbeddr'="") d
	.s admbeddesc=$p($g(^PAWARD(+$p(admbeddr,"||",1),"BED",+$p(admbeddr,"||",2))),"^",1)
	.i ($f(admbeddesc,"-")'=0)  d
	..s admbeddesc=$p(admbeddesc,"-",2)
	s admbeddesc=admbeddr_"@"_admbeddesc
	
	s admdocdr=$p(^PAADM(admid),"^",9)
	s admdocdesc=""
	i (+admdocdr'=0)  d
	.s admdocdesc=$p($g(^CTPCP(admdocdr,1)),"^",2)
	s admdocdesc=admdocdr_"@"_admdocdesc
	
	s admreadr=$p(^PAADM(admid,1),"^",7)
	s admreadesc=""
	i (+admreadr'=0)  d
	.s admreadesc=$p($g(^PAC("ADMREA",admreadr)),"^",2)
	.i ($f(admreadesc,"-")'=0)  d
	..s admreadesc=$p(admreadesc,"-",2)
	s admreadesc=admreadr_"@"_admreadesc
	
	s admepisdr=$p(^PAADM(admid,1),"^",6)
	s admepisdesc=""
	i (+admepisdr'=0)  d
	.s admepisdesc=$p($g(^PAC("SUBT",admepisdr)),"^",2)
	.i ($f(admepisdesc,"-")'=0)  d
	..s admepisdesc=$p(admepisdesc,"-",2)
	s admepisdesc=admepisdr_"@"_admepisdesc
	
	s admuser=$p(^PAADM(admid),"^",43)
	s username=""
	i (+admuser'=0)  d
	.s username=$p($g(^SSU("SSUSR",admuser)),"^",2)
	
	s admryqkdr=$p(^PAADM(admid),"^",5)
	s admryqkdesc=""
	i (+admryqkdr'=0)  d
	.s admryqkdesc=$p($g(^PAC("ADMCAT",admryqkdr)),"^",2)
	.i ($f(admryqkdesc,"-")'=0)  d
	..s admryqkdesc=$p(admryqkdesc,"-",2)
	s admryqkdesc=admryqkdr_"@"_admryqkdesc

	s admrefdocdr=$p(^PAADM(admid),"^",82)
	s admrefdoc=""
	i (+admrefdocdr'=0)  d
	.s admrefdoc=$p($g(^CTPCP(admrefdocdr,1)),"^",2)
	s admrefdocdesc=admrefdocdr_"@"_admrefdoc

	s str=0_"^"_admdeptdesc_"^"_admwarddesc_"^"_admroomdesc_"^"_admbeddesc_"^"_admdocdesc
	s str=str_"^"_admreadesc_"^"_admepisdesc_"^"_admryqkdesc_"^"_username_"^"_admtimes_"^"_admrefdocdesc
	q str
}

Query ryqklookup() As websys.Query(ROWSPEC = "type:%String,typeid:%String")
{
}

/// do ##class(%ResultSet).RunQuery("web.UDHCJFIPReg", "ryqklookup")
ClassMethod ryqklookupExecute(ByRef qHandle As %Binary) As %Status
{
 	set repid=$I(^CacheTemp)
	set ind=1
	set today=+$h
	set rowid="0"
	for  set rowid=$o(^PAC("ADMCAT",rowid))  quit:(rowid="")  do
	.set admCateGoryInfo=$g(^PAC("ADMCAT",rowid))
	.quit:(admCateGoryInfo="")
	.set dateFrom=$p(admCateGoryInfo,"^",3)
	.set dateTo=$p(admCateGoryInfo,"^",4)
	.quit:((dateFrom'="")&&(dateFrom>today))
	.quit:((dateTo'="")&&(dateTo<today))   //+2018-01-16 ZhYW 过滤不在有效期的
	.set desc=$p(admCateGoryInfo,"^",2)
	.do OutputRow9
	
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow9
	set Data=$lb(desc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query getuppat(stdate1 As %String, enddate1 As %String, papmiid As %String, admid As %String, userid As %String, name, regno) As websys.Query(ROWSPEC = "Tregno:%String,Tname:%String,Tadmdate:%String,Tadmtime:%String,Tdischdate:%String,Tdischtime:%String,Titmname:%String,Tolddesc:%String,Tnewdesc:%String,Tupdate:%String,Tuptime:%String,Tupuser:%String,Tadmdep:%String,Tadmward:%String,Tbedno:%String,Tflag:%String,Tjob:%String")
{
}

ClassMethod getuppatExecute(ByRef qHandle As %Binary, stdate1 As %String, enddate1 As %String, papmiid As %String, admid As %String, userid As %String, name, regno) As %Status
{
 	set repid=$I(^CacheTemp)
	set ind=1
 	set stdate1=##class(websys.Conversions).DateHtmlToLogical(stdate1)
 	set enddate1=##class(websys.Conversions).DateHtmlToLogical(enddate1)
 	s papmiid=$g(papmiid)
 	i $g(regno)="" s papmiid=""
 	s admid=$g(admid)
 	s userid=$g(userid)
 	i (stdate1="")  d
 	.s stdate1=+$h
 	i (enddate1="")  d
 	.s enddate1=+$h
 	
 	f prtdate=stdate1:1:enddate1 d
 	.s rowid=""
 	.f  s rowid=$o(^DHCJFUPR(0,"date",prtdate,rowid))  q:rowid=""  d
 	..s papmidr=$p(^DHCJFUPR(rowid),"^",1)
 	..s papminame=$p(^PAPER(papmidr,"ALL"),"^",1)
 	..q:(name'="")&(name'=papminame)
 	..q:(papmiid'="")&(papmiid'=papmidr)
 	..s admdr=$p(^DHCJFUPR(rowid),"^",2)
 	..q:(admid'="")&(admid'=admdr)
 	..s userdr=$p(^DHCJFUPR(rowid),"^",7)
 	..q:((userid'="")&&(userid'=userdr))
 	..s username=$s((+userdr'=0):$p($g(^SSU("SSUSR",userdr)),"^",2),1:"")
 	..s regno=$p(^PAPER(papmidr,"PAT",1),"^",1)
 	..s patname=$p(^PAPER(papmidr,"ALL"),"^",1)
 	..s admdate="",admtime="",dischdate="",dischtime=""
 	..s admdepdesc="",admwarddesc="", admbeddesc=""
 	..i (admdr'="")  d
 	...s admInOutDateInfo=##class(web.UDHCJFBaseCommon).GetAdmInOutDatebyEpisodeID(admdr)
 	...s admdate=$p(admInOutDateInfo,"^",1)
 	...s admdate=##class(websys.Conversions).DateLogicalToHtml(admdate)
 	...s admtime=$p(admInOutDateInfo,"^",2)
 	...s admtime=##class(websys.Conversions).TimeLogicalToHtml(admtime, 1)
 	...s dischdate=$p(admInOutDateInfo,"^",4)
 	...s dischdate=##class(websys.Conversions).DateLogicalToHtml(dischdate)
 	...s dischtime=$p(admInOutDateInfo,"^",5)
 	...s dischtime=##class(websys.Conversions).TimeLogicalToHtml(dischtime, 1)
 	...s admdep=$p(^PAADM(admdr),"^",4)
 	...i (admdep'="")  d
 	....s admdepdesc=$p($g(^CTLOC(admdep)),"^",2)
 	....i $f(admdepdesc,"-")'=0  d
 	.....s admdepdesc=$p(admdepdesc,"-",2)
 	...s admward=$p(^PAADM(admdr),"^",70)
 	...i (admward'="")  d
 	....s admwarddesc=$p($g(^PAWARD(admward)),"^",2)
 	....i $f(admwarddesc,"-")'=0  d
 	.....s admwarddesc=$p(admwarddesc,"-",2)
 	...s admbeddesc=##class(web.DHCBillCommon).GetPatBedCode(admdr)
 	..s tablename=$p(^DHCJFUPR(rowid),"^",3)
 	..s itmname=$p(^DHCJFUPR(rowid),"^",4)
 	..q:(itmname="PAPER_Age")
 	..q:(itmname="PAPER_AgeYr")
 	..q:(itmname="PAPER_AgeMth")
 	..q:(itmname="PAPER_AgeDay")
	..q:(itmname="BabyBirth1")
 	..//q:(itmname="BabyBirth2")
 	..s olddesc=$p(^DHCJFUPR(rowid),"^",5)
 	..s newdesc=$p(^DHCJFUPR(rowid),"^",6)
 	..s olddesc=$p(olddesc,$c(1))
 	..s newdesc=$p(newdesc,$c(1))
 	..i ((tablename="PA_Person")&&(itmname="PAPER_Name"))  d
 	...s itmname="患者姓名"
 	..i (tablename="PA_Person")&&(itmname="PAPER_Name2")  d
 	...s itmname="患者拼音码"
 	..i (tablename="PA_PatMas")&&(itmname="PAPMI_SafetyNetCardNo")  d
 	...s itmname="病历号"
 	..i (tablename="PA_Person")&&(itmname="PAPER_Sex_DR")  d
 	...s itmname="性别"
 	...i (olddesc'="")  d
  	....s olddesc=$p($g(^CT("SEX",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^CT("SEX",newdesc)),"^",2)
 	..i (tablename="PA_Person")&&(itmname="PAPER_ID")  d
 	...s itmname="身份证号码"
 	..i (tablename="PA_Person")&&(itmname="PAPER_Dob")  d
 	...s itmname="出生日期"
 	...s olddesc=$zdh(olddesc,3)
 	...s olddesc=##class(websys.Conversions).DateLogicalToHtml(olddesc)
 	...s newdesc=$zdh(newdesc,3)
 	...s newdesc=##class(websys.Conversions).DateLogicalToHtml(newdesc)
 	..i (tablename="PA_Person")&(itmname="PAPER_Marital_DR")  d
 	...s itmname="婚姻状况"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^CT("MAR",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^CT("MAR",newdesc)),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_Religion_DR")  d
 	...s itmname="宗教"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^CT("RLG",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^CT("RLG",newdesc)),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_StName")  d
 	...s itmname="地址"
 	..i (tablename="PA_Person")&(itmname="PAPER_TelH")  d
 	...s itmname="家庭电话"
 	..i (tablename="PA_Person")&(itmname="PAPER_Zip_DR")  d
 	...s itmname="邮政编码"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^CT("ZIP",olddesc)),"^",1)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^CT("ZIP",newdesc)),"^",1)
 	..i (tablename="PA_Person")&(itmname="PAPER_SecondPhone")  d
 	...s itmname="工作单位"
 	..i (tablename="PA_Person")&(itmname="PAPER_TelO")  d
 	...s itmname="单位电话"
 	..i (tablename="PA_Person")&(itmname="PAPER_CT_Province_DR")  d
 	...s itmname="省"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^CT("PROV",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^CT("PROV",newdesc)),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_Email")  d
 	...s itmname="email"
 	..i (tablename="PA_Person")&(itmname="PAPER_MobPhone")  d
 	...s itmname="手机"
 	..i (tablename="PA_Person")&(itmname="PAPER_CityCode_DR")  d
 	...s itmname="市"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^CT("CIT",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^CT("CIT",newdesc)),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_SocialStatus_DR")  d
 	...s itmname="社会地位"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^CT("SS",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^CT("SS",newdesc)),"^",2)
 	..i (tablename="PA_Adm")&(itmname="PAADM_AdmCateg_DR")  d
 	...s itmname="入院情况"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^PAC("ADMCAT",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^PAC("ADMCAT",newdesc)),"^",2)
 	..i (tablename="PA_Adm")&(itmname="PAADM_AdmReason_DR")  d
 	...s itmname="收费类别"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^PAC("ADMREA",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^PAC("ADMREA",newdesc)),"^",2)
 	..i (tablename="PA_Adm")&(itmname="PAADM_Epissubtype_DR")  d
 	...s itmname="就诊类别"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^PAC("SUBT",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^PAC("SUBT",newdesc)),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_Nation_DR")  d
 	...s itmname="民族"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^CT("NAT",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^CT("NAT",newdesc)),"^",2)
 	..i (tablename="PA_PatMas")&(itmname="PAPMI_CardType_DR")  d
 	...s itmname="证件类型"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^PAC("CARD",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^PAC("CARD",newdesc)),"^",2)
 	..i (tablename="PA_PatMas")&(itmname="PAPMI_DVAnumber")  d
 	...s itmname="证件号码"
 	...i (olddesc'="")  d
 	....s olddesc=$p(^DHCJFUPR(rowid),"^",5)
 	...i (newdesc'="")  d
 	....s newdesc=$p(^DHCJFUPR(rowid),"^",6) 
 	..i ((tablename="PA_Person")&(itmname="PAPER_Country_DR"))  d
 	...s itmname="国籍"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^CT("COU",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^CT("COU",newdesc)),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_Occupation_DR")  d
 	...s itmname="职业"
 	...i (olddesc'="")  d
 	....i ($d(^CT("OCC",olddesc))'=0)&($d(^CT("OCC",olddesc))'=10)   d
 	.....s olddesc=$p(^CT("OCC",olddesc),"^",2)
 	...i (newdesc'="")  d
 	....i ($d(^CT("OCC",newdesc))'=0)&($d(^CT("OCC",newdesc))'=10)   d
 	.....s newdesc=$p(^CT("OCC",newdesc),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_Education_DR")  d
 	...s itmname="教育"
 	...i olddesc'=""  d
 	....i ($d(^CT("EDU",olddesc))'=0)&($d(^CT("EDU",olddesc))'=10)   d
 	.....s olddesc=$p(^CT("EDU",olddesc),"^",2)
 	...i newdesc'=""  d
 	....i ($d(^CT("EDU",newdesc))'=0)&($d(^CT("EDU",newdesc))'=10)   d
 	.....s newdesc=$p(^CT("EDU",newdesc),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_LangPrim_DR")  d
 	...s itmname="语言"
 	...i olddesc'=""  d
 	....i ($d(^SS("LAN",olddesc))'=0)&($d(^SS("LAN",olddesc))'=10)   d
 	.....s olddesc=$p(^SS("LAN",olddesc),"^",2)
 	...i newdesc'=""  d
 	....i ($d(^SS("LAN",newdesc))'=0)&($d(^SS("LAN",newdesc))'=10)   d
 	.....s newdesc=$p(^SS("LAN",newdesc),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_EmplType_DR")  d
 	...s itmname="在职状态"
 	...i olddesc'=""  d
 	....i ($d(^PAC("EPE",olddesc))'=0)&($d(^PAC("EPE",olddesc))'=10)   d
 	.....s olddesc=$p(^PAC("EPE",olddesc),"^",2)
 	...i newdesc'=""  d
 	....i ($d(^PAC("EPE",newdesc))'=0)&($d(^PAC("EPE",newdesc))'=10)   d
 	.....s newdesc=$p(^PAC("EPE",newdesc),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_CTRLT_DR")  d
 	...s itmname="与病人关系"
 	...i olddesc'=""  d
 	....i ($d(^CT("RLT",olddesc))'=0)&($d(^CT("RLT",olddesc))'=10)   d
 	.....s olddesc=$p(^CT("RLT",olddesc),"^",2)
 	...i newdesc'=""  d
 	....i ($d(^CT("RLT",newdesc))'=0)&($d(^CT("RLT",newdesc))'=10)   d
 	.....s newdesc=$p(^CT("RLT",newdesc),"^",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_ForeignId")  d
 	...s itmname="联系人"
 	...i olddesc'=""  d
 	....s olddesc=$p(^DHCJFUPR(rowid),"^",5)
 	...i newdesc'=""  d
 	....s newdesc=$p(^DHCJFUPR(rowid),"^",6)
 	..i (tablename="PA_Person")&(itmname="PAPER_ForeignPhone")  d
 	...s itmname="联系人电话"
 	...i olddesc'=""  d
 	....s olddesc=$p(^DHCJFUPR(rowid),"^",5)
 	...i newdesc'=""  d
 	....s newdesc=$p(^DHCJFUPR(rowid),"^",6)
 	..i (tablename="PA_Person")&(itmname="PAPER_ForeignAddress")  d
 	...s itmname="联系人地址"
 	...i olddesc'=""  d
 	....s olddesc=$p(^DHCJFUPR(rowid),"^",5)
 	...i newdesc'=""  d
 	....s newdesc=$p(^DHCJFUPR(rowid),"^",6) 	
 	..i (tablename="PAPERZYJFGlobal")&&(itmname="PatNote")  d
 	...s itmname="备注"
 	..i (tablename="PA_Person")&&(itmname="PAPER_Province_Birth_DR")  d
 	...s itmname="籍贯(省)"
 	...i olddesc'=""  d
 	....i (($d(^CT("PROV",olddesc))'=0)&&($d(^CT("PROV",olddesc))'=10))  d
 	.....s olddesc=$p(^CT("PROV",olddesc),"^",2)
 	.....i $f(olddesc,"-")'=0  d
 	......s olddesc=$p(olddesc,"-",2)
 	...i newdesc'=""  d
 	....i (($d(^CT("PROV",newdesc))'=0)&&($d(^CT("PROV",newdesc))'=10))  d
 	.....s newdesc=$p(^CT("PROV",newdesc),"^",2)
 	.....i $f(newdesc,"-")'=0  d
 	......s newdesc=$p(newdesc,"-",2)
 	..i (tablename="PA_Person")&&(itmname="PAPER_CityBirth_DR")  d
 	...s itmname="籍贯(市)"
 	...i (olddesc'="")  d
 	....i (($d(^CT("CIT",olddesc))'=0)&&($d(^CT("CIT",olddesc))'=10))  d
 	.....s olddesc=$p(^CT("CIT",olddesc),"^",2)
 	.....i $f(olddesc,"-")'=0  d
 	......s olddesc=$p(olddesc,"-",2)
 	...i newdesc'=""  d
 	....i (($d(^CT("CIT",newdesc))'=0)&($d(^CT("CIT",newdesc))'=10))  d
 	.....s newdesc=$p(^CT("CIT",newdesc),"^",2)
 	.....i $f(newdesc,"-")'=0  d
 	......s newdesc=$p(newdesc,"-",2)
 	..i (tablename="PA_Person")&(itmname="PAPER_CityArea_DR")  d
 	...s itmname="区"
 	...i olddesc'=""  d
 	....i (($d(^CT("CITAREA",olddesc))'=0)&($d(^CT("CITAREA",olddesc))'=10))  d
 	.....s olddesc=$p(^CT("CITAREA",olddesc),"^",2)
 	.....i $f(olddesc,"-")'=0  d
 	......s olddesc=$p(olddesc,"-",2)
 	...i newdesc'=""  d
 	....i (($d(^CT("CITAREA",newdesc))'=0)&($d(^CT("CITAREA",newdesc))'=10))  d
 	.....s newdesc=$p(^CT("CITAREA",newdesc),"^",2)
 	.....i $f(newdesc,"-")'=0  d
 	......s newdesc=$p(newdesc,"-",2)
 	..i (tablename="PA_Person")&(itmname="BabyBirth1")  d
 	...s itmname="出生日期"
 	...s olddesc=##class(websys.Conversions).DateLogicalToHtml(olddesc)
 	...s newdesc=##class(websys.Conversions).DateLogicalToHtml(newdesc)
 	..i (tablename="PA_Person")&(itmname="BabyBirth2")  d
 	...s itmname="出生时间"
 	...s olddesc=##class(websys.Conversions).TimeLogicalToHtml(olddesc, 1)
 	...s newdesc=##class(websys.Conversions).TimeLogicalToHtml(newdesc, 1)
 	..i (tablename="PA_Adm")&(itmname="PAADM_RefDocList_DR")  d
 	...s itmname="推荐医生"
 	...i (olddesc'="")  d
 	....i ($d(^PAC("REFD",olddesc))'=0)&($d(^PAC("REFD",olddesc))'=10)  d
 	.....s olddesc=$p(^PAC("REFD",olddesc),"^",2)
 	...i (newdesc'="")  d
 	....i ($d(^PAC("REFD",newdesc))'=0)&($d(^PAC("REFD",newdesc))'=10)  d
 	.....s newdesc=$p(^PAC("REFD",newdesc),"^",2)
 	..i (tablename="DHC_Person")&(itmname="PAPER_Comment1")  d
 	...s itmname="住址邮编" 	
 	..i (tablename="DHC_Person")&(itmname="PAPER_Comment2")  d
 	...s itmname="工作邮编"
 	..i (tablename="DHC_Person")&(itmname="PAPER_Comment3")  d
 	...s itmname="户口邮编"
 	..i (tablename="DHC_Person")&(itmname="PAPER_BirthProvince_DR")  d
 	...s itmname="省(出生)"
 	...i olddesc'=""  d
 	....s olddesc=$p(^CT("PROV",olddesc),"^",2)
 	....i $f(olddesc,"-")'=0  d
 	.....s olddesc=$p(olddesc,"-",2) 
 	...i newdesc'=""  d
 	....s newdesc=$p(^CT("PROV",newdesc),"^",2)
 	....i $f(newdesc,"-")'=0  d
 	.....s newdesc=$p(newdesc,"-",2) 
 	..i (tablename="DHC_Person")&(itmname="PAPER_BirthCity_DR")  d
 	...s itmname="市(出生)"
 	...i olddesc'=""  d
 	....s olddesc=$p(^CT("CIT",olddesc),"^",2)
 	....i $f(olddesc,"-")'=0  d
 	.....s olddesc=$p(olddesc,"-",2) 
 	...i newdesc'=""  d
 	....s newdesc=$p(^CT("CIT",newdesc),"^",2)
 	....i $f(newdesc,"-")'=0  d
 	.....s newdesc=$p(newdesc,"-",2)
 	..i (tablename="DHC_Person")&(itmname="PAPER_BirthArea_dr")  d
 	...s itmname="区县(出生)"
 	...i olddesc'=""  d
 	....s olddesc=$p(^CT("CITAREA",olddesc),"^",2)
 	....i $f(olddesc,"-")'=0  d
 	.....s olddesc=$p(olddesc,"-",2) 
 	...i newdesc'=""  d
 	....s newdesc=$p(^CT("CITAREA",newdesc),"^",2)
 	....i $f(newdesc,"-")'=0  d
 	.....s newdesc=$p(newdesc,"-",2)
 	..i (tablename="DHC_Person")&(itmname="PAPER_BirthAddress")  d
 	...s itmname="出生地址"
 	..i (tablename="DHC_Person")&(itmname="PAPER_HouseProvince_DR")  d
 	...s itmname="省(户口)"
 	...i (+olddesc'=0)  d
 	....s olddesc=$p(^CT("PROV",olddesc),"^",2)
 	....i $f(olddesc,"-")'=0  d
 	.....s olddesc=$p(olddesc,"-",2) 
 	...i (+newdesc'=0)  d
 	....s newdesc=$p(^CT("PROV",newdesc),"^",2)
 	....i $f(newdesc,"-")'=0  d
 	.....s newdesc=$p(newdesc,"-",2)
 	..i (tablename="DHC_Person")&(itmname="PAPER_HouseCity_DR")  d
 	...s itmname="市(户口)"
 	...i (+olddesc'=0)  d
 	....s olddesc=$p(^CT("CIT",olddesc),"^",2)
 	....i $f(olddesc,"-")'=0  d
 	.....s olddesc=$p(olddesc,"-",2) 
 	...i (+newdesc'=0)  d
 	....s newdesc=$p(^CT("CIT",newdesc),"^",2)
 	....i $f(newdesc,"-")'=0  d
 	.....s newdesc=$p(newdesc,"-",2)
 	..i (tablename="DHC_Person")&(itmname="PAPER_HouseArea_DR")  d
 	...s itmname="区县(户口)"
 	...i (olddesc'="")  d
 	....s olddesc=$p(^CT("CITAREA",olddesc),"^",2)
 	....i $f(olddesc,"-")'=0  d
 	.....s olddesc=$p(olddesc,"-",2) 
 	...i (newdesc'="")  d
 	....s newdesc=$p(^CT("CITAREA",newdesc),"^",2)
 	....i $f(newdesc,"-")'=0  d
 	.....s newdesc=$p(newdesc,"-",2)
 	..i (tablename="DHC_Person")&(itmname="PAPER_HouseAddress")  d
 	...s itmname="出生地址" 
 	..i (tablename="PA_Adm")&(itmname="PAADM_CurrentWard_DR")  d
 	...s itmname="病区"
 	...i (olddesc'="")  d
 	....i ($d(^PAWARD(olddesc))'=0)&($d(^PAWARD(olddesc))'=10)  d
 	.....s olddesc=$p(^PAWARD(olddesc),"^",2)
 	.....i $f(olddesc,"-")'=0  d
 	......s olddesc=$p(olddesc,"-",2)
 	...i (newdesc'="")  d
 	....i ($d(^PAWARD(newdesc))'=0)&($d(^PAWARD(newdesc))'=10)  d
 	.....s newdesc=$p(^PAWARD(newdesc),"^",2)
 	.....i $f(newdesc,"-")'=0  d
 	......s newdesc=$p(newdesc,"-",2)
 	..i (tablename="PA_Adm")&(itmname="PAADM_AdmSrc_DR")  d
 	...s itmname="入院途径"
 	...i (olddesc'="")  d
 	....i ($d(^PAC("ADSOU",olddesc))'=0)&($d(^PAC("ADSOU",olddesc))'=10)  d
 	.....s olddesc=$p($g(^PAC("ADSOU",olddesc)),"^",2)
 	.....i $f(olddesc,"-")'=0  d
 	......s olddesc=$p(olddesc,"-",2)
 	...i (newdesc'="")  d
 	....i ($d(^PAC("ADSOU",newdesc))'=0)&($d(^PAC("ADSOU",newdesc))'=10)  d
 	.....s newdesc=$p($g(^PAC("ADSOU",newdesc)),"^",2)
 	.....i $f(newdesc,"-")'=0  d
 	......s newdesc=$p(newdesc,"-",2)
 	..i (tablename="PA_Adm")&(itmname="PAADM_DepCode_DR")  d
 	...s itmname="科室"
 	...i (olddesc'="")  d
 	....i ($d(^CTLOC(olddesc))'=0)&($d(^CTLOC(olddesc))'=10)  d
 	.....s olddesc=$p(^CTLOC(olddesc),"^",2)
 	.....i $f(olddesc,"-")'=0  d
 	......s olddesc=$p(olddesc,"-",2)
 	...i (newdesc'="")  d
 	....i ($d(^CTLOC(newdesc))'=0)&($d(^CTLOC(newdesc))'=10)  d
 	.....s newdesc=$p(^CTLOC(newdesc),"^",2)
 	.....i $f(newdesc,"-")'=0  d
 	......s newdesc=$p(newdesc,"-",2)
 	..i (tablename="PA_PatMas")&(itmname="PAPMI_HealthFundNo")  d
 	...s itmname="医保手册号"
 	..//modify 2013-3-15 增加诊断修改记录查询
 	..i (tablename="MR_Diagnos")&(itmname="MRDIA_ICDCode_DR")  d
 	...s itmname="诊断"
 	...i (olddesc'="")  d
 	....s olddesc=$p(^MRC("ID",olddesc),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p(^MRC("ID",newdesc),"^",2)  
 	..i (tablename="MR_Diagnos")&(itmname="MRDIA_Desc")  d
 	...s itmname="诊断描述"
 	..i (tablename="MR_DiagType")&(itmname="TYP_MRCDiagTyp")  d
 	...s itmname="诊断类型"
 	...i (olddesc'="")  d
 	....s olddesc=$p(^MRC("DTYP",olddesc),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p(^MRC("DTYP",newdesc),"^",2)
 	..i (tablename="PA_Adm")&(itmname="PAADM_AdmDocCodeDr")  d
 	...s itmname="就诊医生"
 	...i (olddesc'="")  d
 	....s olddesc=$p(^CTPCP(olddesc,1),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p(^CTPCP(newdesc,1),"^",2)
 	..;+2015-3-19 hujunbin 添加合同单位
 	..i (tablename="PA_Person")&(itmname="PAPER_HCP_DR")  d
 	...s itmname="合同单位"
 	...i (olddesc'="") d
 	....s olddesc=$p(^CT("HCP",olddesc),"^",2)
 	...i (newdesc'="") d
 	....s newdesc=$p(^CT("HCP",newdesc),"^",2)
 	..i (tablename="PA_Adm")&(itmname="PAADM_ReferralPriority_DR")  d
 	...s itmname="入院病情"
 	...i (olddesc'="")  d
 	....s olddesc=$p($g(^PAC("REFPRI",olddesc)),"^",2)
 	...i (newdesc'="")  d
 	....s newdesc=$p($g(^PAC("REFPRI",newdesc)),"^",2)
 	..s update=$p(^DHCJFUPR(rowid),"^",8) 
 	..s update=##class(websys.Conversions).DateLogicalToHtml(update)
 	..s uptime=$p(^DHCJFUPR(rowid),"^",9)
 	..s uptime=##class(websys.Conversions).TimeLogicalToHtml(uptime, 1)
 	..s upflag=$p(^DHCJFUPR(rowid),"^",10)
 	..i (upflag="1")  s upflagdesc="修改"
 	..i (upflag="2")  s upflagdesc="住院"
 	..d OutputRow10
 	
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
    
OutputRow10
	set Data=$lb(regno,patname,admdate,admtime,dischdate,dischtime,itmname,olddesc,newdesc,update,uptime,username,admdepdesc,admwarddesc,admbeddesc,upflagdesc,+$j)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod getpatname(papno)
{
	n (papno)
	q:(papno="") "-1^"
	s rowid=""
	s papno=##class(web.UDHCJFBaseCommon).regnocon(papno)
	s rowid=$o(^PAPERi("PAPMI_PatNo",papno,rowid))
	q:(rowid="") "-2^" 
	s papname=$p(^PAPER(rowid,"ALL"),"^",1)
	s str=0_"^"_rowid_"^"_papname_"^"_papno
	q str
}

/// w ##class(web.UDHCJFIPReg).getbirthday(23)
ClassMethod getbirthday(agestr As %String)
{
	n (agestr)
    i (agestr="")  d
    .s birthstr=""
    e  d
    .s curda=$zd(+$h,3)
    .s curyr=$p(curda,"-",1)
    .s birthyr=curyr-agestr
    .s Curdate=##class(websys.Conversions).DateLogicalToHtml(+$h)
    .i (Curdate["/") s birthstr="01/01/"_birthyr
    .i (Curdate["-") s birthstr=birthyr_"-"_"01-01"
    q birthstr
}

Query SocSatlookup(desc As %String) As websys.Query(ROWSPEC = "type:%String,typeid:%String")
{
}

ClassMethod SocSatlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set ind=1
	set desc=$$ALPHAUP^SSUTIL4(desc)
	set rowid="0"
	for  set rowid=$o(^CT("SS",rowid))  quit:(rowid="")  do
	.set typerowid=rowid
	.set typedesc=$p(^CT("SS",rowid),"^",2)
	.set typedesc1=typedesc
	.if (desc'="")  do
	..if (typedesc1[desc)  do
	...if ($f(typedesc,"-")'=0)  do
    ...set typedesc=$p(typedesc,"-",2)
    ...do OutputRow11
 	.else  do
 	..if ($f(typedesc,"-")'=0)  do
    ...set typedesc=$p(typedesc,"-",2)
    ..do OutputRow11
    
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
    
OutputRow11
	set Data=$lb(typedesc,typerowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// w ##class(web.UDHCJFIPReg).getSocSatid(1)
ClassMethod getSocSatid(admreaid)
{
	new (admreaid)
	set socstr="^"
	quit:(admreaid="") socstr
	set today=+$h
	set rowid="0"
	for  set rowid=$o(^DHCPACADM(0,"AdmReason",admreaid,rowid))  quit:(rowid="")  do
	.set tmp=$g(^DHCPACADM(rowid))
	.quit:(tmp="")
	.set dateFrom=$p(tmp,"^",3)
	.set dateTo=$p(tmp,"^",4)
	.quit:((dateFrom'="")&&(dateFrom>today))
	.quit:((dateTo'="")&&(dateTo<today))
	.set socsatdr=$p(tmp,"^",1)
	.quit:(+socsatdr=0)
	.set socsatdesc=$p($g(^CT("SS",socsatdr)),"^",2)
	.set socstr=socsatdr_"^"_socsatdesc
  
	quit socstr
}

/// w ##class(web.UDHCJFIPReg).getadmcancel("", "", 593, 4632)
ClassMethod getadmcancel(itmjs As %Library.String = "", itmjsex As %Library.String = "", admid, guser)
{
 	s admid=$g(admid)
 	s admid=$p(admid,$c(1))
 	s guser=$g(guser)
 	q:(admid="") "100"
 	q:(guser="") "1"
 	q:($d(^PAADM(admid))=0) "100"
 	s visitstatus1=$p(^PAADM(admid),"^",20)
 	q:(visitstatus1'="A") "2"

 	s ordnum=0,ItemStatnum=0
 	i $d(^OEORD(0,"Adm",admid))=10  d
 	.s ordid=$o(^OEORD(0,"Adm",admid,""))
 	.s ordsubid="0"
 	.f  s ordsubid=$o(^OEORD(ordid,"I",ordsubid))  q:(ordsubid="")  d
 	..s ItemStatDR=$p($g(^OEORD(ordid,"I",ordsubid,1)),"^",13)
 	..s ItemStatCode=$p($g(^OEC("OSTAT",+ItemStatDR)),"^",1)
 	..s prior=$p($g(^OEORD(ordid,"I",ordsubid,1)),"^",8)
 	..s priorcode=$s((prior'=""):$p($g(^OECPR(+prior)),"^",1),1:"")
 	..i (priorcode'["OM")  d
 	...s OEORDExec="0"
 	...f  s OEORDExec=$o(^OEORD(ordid,"I",ordsubid,"X",OEORDExec))  q:(OEORDExec="")  d
 	....s OEOREBillFlag=$p(^OEORD(ordid,"I",ordsubid,"X",OEORDExec),"^",6)
 	....q:((OEOREBillFlag="B")||(OEOREBillFlag="R"))
 	....s ordnum=ordnum+1
 	..i ((ItemStatCode'="D")&&(ItemStatCode'="I")&&(ItemStatCode'="U")&&(ItemStatCode'="C")) d  ;作废医嘱也不算
 	...s ItemStatnum=ItemStatnum+1
 
 	q:(ItemStatnum'=0) "6"
 	q:(ordnum'=0) "4"

 	s admfee=0
 	i $d(^DHCPB(0,"ADM",admid))=10  d
 	.;s pbid=$o(^DHCPB(0,"ADM",admid,""))
 	.;s admfee=$p(^DHCPB(pbid),"^",8)
 	.s admfeeinfo=##class(web.UDHCJFBaseCommon).GetPatFeeByEpisodeID(admid)
 	.s admfee=$p(admfeeinfo,"^",1)
 	q:(admfee'=0) "3"
 
 	s yjnum=0
 	i $d(^DHCSFPRINTDETAIL(0,"adm",admid))=10  d
 	.s yjid=""
 	.f  s yjid=$o(^DHCSFPRINTDETAIL(0,"adm",admid,yjid))  q:(yjid="")  d
 	..s yjstatus=$p(^DHCSFPRINTDETAIL(yjid),"^",8)
 	..q:(yjstatus'=1)
 	..s yjtype=$p(^DHCSFPRINTDETAIL(yjid),"^",13)
 	..s yjtypedesc=""
 	..i (yjtype'="")  d
 	...s yjtypedesc=$p($g(^ARC("ARCDT",yjtype)),"^",2)
 	..q:(yjtypedesc'="住院押金")
 	..s yjnum=yjnum+1
 	q:(yjnum'=0) "5"
 
 	s BabyVisFlag=0
 	s BabyAdmStr=##class(web.UDHCJFCASHIER).GetBabyAdm(admid)
 	i (BabyAdmStr'="") d
 	.f i=1:1:$l(BabyAdmStr,"^") d
 	..s BabyAdm=$p(BabyAdmStr,"^",i)
 	..q:(BabyAdm="")
 	..s BabyVistatus=$p(^PAADM(BabyAdm),"^",20)
 	..i ((BabyVistatus="A")||(BabyVistatus="D")) d
 	...s BabyVisFlag=BabyVisFlag+1    ;婴儿在院或者出院母亲不允许退院，避免召回的问题
 	s Conf=$O(^DHCTarC("CF",""))
 	i $p(^DHCTarC("CF",Conf),"^",5)="N" s BabyVisFlag=0 ;母亲与婴儿账单分开的不控制
 	q:(BabyVisFlag'=0) "7"	;有在院婴儿就诊不能退院
 
 	;如果有包床信息，则提示不允许退院，需要取消包床才能退院DHC_PAC_BedStatusChange
 	i $d(^PAWARDA(0,"SADM",admid))'=0 q "BedErr"
 
 	;如果有门诊费用转住院不允许退院
 	i $d(^DHCOPIPADMCON("OPAdm",admid))'=0 q "OPAdm"
 
 	;如果病人在床不允许退院   add zhangli  17.7.25
 	s ifPatInBed=##Class(web.DHCNurseInterface).ifPatInBed(admid)
 	q:(ifPatInBed="Y") "PatInBedErr"
 	
 	s retcode=0
	s wardsubrowid=""
 	s bedid=$p(^PAADM(admid),"^",73)
 	s wardid=$p(^PAADM(admid),"^",70)
 	i (bedid="")  d
 	.s wardsubid=$o(^PAWARDA(0,"WADM",admid,wardid,""))
 	.i ((wardsubid'="")&&(wardsubid'=0))  d
 	..s wardsubrowid=wardid_"||"_wardsubid
 	.i (wardsubrowid="")  d   //分床在等候区的病人根据room索引来查  add zhli 18.3.19
 	..s wardsubid=$o(^PAWARDA(0,"RADM",admid,wardid,""))
 	..i ((wardsubid'="")&&(wardsubid'=0))  d
 	...s wardsubrowid=wardid_"||"_wardsubid
 	.e   d
 	..//s wardsubid=$o(^PAWARDA(0,"RADM",admid,wardid,""))
 	..//i ((wardsubid'="")&&(wardsubid'=0))   s wardsubrowid=wardid_"||"_wardsubid
 	e  d
 	.s bedid1=$p(bedid,"||",1)
 	.s bedid2=$p(bedid,"||",2)
 	.s bedsubid=$o(^PAWARDA(0,"ADM",admid,bedid1,bedid2,""))
 	.i ((bedsubid'="")&&(bedsubid'=0))  d
 	..s bedsubrowid=bedid1_"||"_bedid2_"||"_bedsubid
 	
 	s update=+$h
 	s uptime=$p($h,",",2)
 	s AdmTimes=$p(^PAADM(admid),"^",29)
 	s patdr=$p(^PAADM(admid),"^",1)
 	TSTART
 	&SQL(UPDATE SQLUSER.PA_Person SET paper_exemptionnumber=:AdmTimes-1 WHERE PAPER_RowId=:patdr)
 	s retcode=retcode+SQLCODE
 	i (retcode'=0)  d
 	.Trollback
 	q:(retcode'=0) retcode
 	
 	&SQL(UPDATE PA_Adm
      SET PAADM_VisitStatus='C',  PAADM_Current='N',
          PAADM_UpdateDate=:update,  PAADM_UpdateTime=:uptime,
          PAADM_UpdateUser_DR=:guser,PAADM_InPatNo=:AdmTimes-1
          WHERE paadm_rowid=:admid)
 	s retcode=retcode+SQLCODE
 	i (retcode'=0)  d
 	.Trollback
 	e  d
 	.&SQL(UPDATE PA_AdmTransaction SET TRANS_Status_DR='2' WHERE TRANS_ParRef=:admid)
 	.s retcode=retcode+SQLCODE
 	.i (retcode'=0)  d
 	..Trollback
 	.e  d
 	..i (bedid="")  d
 	...i (wardsubrowid="")  d
 	....//s retcode=100
 	....//Trollback
 	...e  d
 	....&SQL(DELETE FROM PAC_WardAdm WHERE WADM_RowId=:wardsubrowid)
 	....s retcode=retcode+SQLCODE
 	....i (retcode'=0)  d
 	.....Trollback
 	..e  d
 	...&SQL(UPDATE PAC_Bed SET BED_Available='Y' WHERE BED_RowID=:bedid)
 	...s retcode=retcode+SQLCODE
 	...i (retcode'=0)  d
 	....Trollback
 	...e  d
 	....i (bedsubrowid="")  d
 	.....s retcode=100
 	.....Trollback
 	....e  d
 	.....;2016-02-27 Lid 判断床位是否是婴儿床，如果是，则退院成功后要把状态设为“不可见”
 	.....s mBabyBedtpId=$o(^PAC("BEDTP",0,"BEDTP_Code","MATERNALBABY",""))
 	.....s babyBedtpId=$p(^PAWARD(+bedsubrowid,"BED",$p(bedsubrowid,"||",2)),"^",2)
 	.....i (babyBedtpId=mBabyBedtpId) d
 	......s $p(^PAWARD(+bedsubrowid,"BED",$p(bedsubrowid,"||",2)),"^",4)="N"
 	.....;
 	.....&SQL(DELETE FROM PAC_BedAdm WHERE ADM_RowId=:bedsubrowid)
 	.....s retcode=retcode+SQLCODE
	.....i (retcode'=0)  d
 	......Trollback
 	
 	i (retcode=0) d
 	.i ($o(^DHCDocIPBDIC(0,"TypeCode","IPBookingState","Cancel",""))'="") d
 	..s retcode=##class(web.DHCDocIPBookingCtl).IUpdateIPBState(admid, "Cancel")
 	..i (retcode'=0) Trollback
 	
 	i (retcode=0) d
 	.s retcode=##class(web.DHCDischargeHistory).SaveAdminDateTime(admid, "", "", 3, "", "")
 	.i (retcode'=0) Trollback
 	
 	i (retcode=0) d
 	.s Ensrtn=##class(web.DHCENS.EnsHISService).DHCHisInterface("SENDADMCANCELINFO", admid)
 	.s retcode=$p(Ensrtn,"^",1)
 	
 	i (retcode=0)  d
 	.TCommit
 	
 	q retcode
}

Query patsexlookup(desc As %String) As websys.Query(ROWSPEC = "sexdesc:%String,sexcode:%String,sexid:%String")
{
}

ClassMethod patsexlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
	set rowid="0"
	for  set rowid=$o(^CT("SEX",rowid))  quit:(rowid="")  do
	.set sexcode=$p(^CT("SEX",rowid),"^",1)
	.set sexcode=$$ALPHAUP^SSUTIL4(sexcode)
	.quit:(desc'="")&(sexcode'=desc)
	.set sexdesc=$p(^CT("SEX",rowid),"^",2)
	.set stdate=$p(^CT("SEX",rowid),"^",4)
	.set enddate=$p(^CT("SEX",rowid),"^",5)
	.quit:(((stdate>+$h)&&(stdate'=""))||((enddate<+$h)&&(enddate'=""))) ;不在有效期的性别不显示 add zhli  17.9.7
	.do OutputRow12
 	
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow12    
	set Data=$lb(sexdesc,sexcode,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query nationlookup(desc As %String) As websys.Query(ROWSPEC = "nation:%String,nationidid:%String")
{
}

ClassMethod nationlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
	set rowid="0"
	for  set rowid=$o(^CT("NAT",rowid))  quit:(rowid="")  do
	.quit:($d(^CT("NAT",rowid))=0)
	.set ctdesc=$p(^CT("NAT",rowid),"^",2)
	.set ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	.if (desc'="")  do
	..if (ctdesc1[desc)  do
	...if ($f(ctdesc,"-")'=0)  do
    ....set ctdesc=$p(ctdesc,"-",2)
    ...do OutputRow13
 	.else  do
 	..if ($f(ctdesc,"-")'=0)  do
    ...set ctdesc=$p(ctdesc,"-",2)
    ..do OutputRow13
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow13
	set Data=$lb(ctdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod getryqkid(desc)
{
	set desc=$g(desc)
	quit:(desc="") ""
	set ryqkid=""
	&sql(SELECT admcat_rowid INTO :ryqkid FROM PAC_AdmCategory WHERE admcat_desc=:desc) 
	quit ryqkid
}

Query cardtypelookup() As websys.Query(ROWSPEC = "cardtype:%String,cardtypeid:%String,code:%String")
{
}

ClassMethod cardtypelookupExecute(ByRef qHandle As %Binary) As %Status
{
 	set repid=$I(^CacheTemp)
	set ind=1
	set today=+$h
    set rowid=0
	for  set rowid=$o(^PAC("CARD",rowid)) quit:(rowid="")  do
	.set cardTypeInfo=$g(^PAC("CARD",rowid))
	.quit:(cardTypeInfo="")
	.set code=$p(cardTypeInfo,"^",1)
	.set desc=$p(cardTypeInfo,"^",2)
	.set active=$p($g(^PAC("CARD",rowid,"DHC")),"^",1)
	.quit:(active'="Y")
	.set default=$p($g(^PAC("CARD",rowid,"DHC")),"^",2)
	.set dateFrom=$p(cardTypeInfo,"^",3)
	.set dateTo=$p(cardTypeInfo,"^",4)
	.quit:((dateFrom'="")&&(dateFrom>today))
	.quit:((dateTo'="")&&(dateTo<today))   //+2018-01-16 ZhYW 过滤不在有效期的
	.do OutputRow14
	
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow14
	set Data=$lb(desc,rowid,code)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query countrylookup(desc) As websys.Query(ROWSPEC = "country:%String,countryid%String")
{
}

ClassMethod countrylookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
    set stdate=+$h
	set rowid="0"
	for  set rowid=$o(^CT("COU",rowid))  quit:(rowid="")  do
	.quit:($d(^CT("COU",rowid))=0)
	.set activeflag=$p(^CT("COU",rowid),"^",3)
	.set actstdate=$p(^CT("COU",rowid),"^",4)
	.set actenddate=$p(^CT("COU",rowid),"^",5)
	.quit:(activeflag'="Y")
	.quit:(actstdate'="")&(actstdate>stdate)
	.quit:(actenddate'="")&(actenddate<stdate)
	.set ctdesc=$p(^CT("COU",rowid),"^",2)
	.set ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	.if (desc'="")  do
	..if (ctdesc1[desc)  do
	...if ($f(ctdesc,"-")'=0)  do
    ....set ctdesc=$p(ctdesc,"-",2)
    ...do OutputRow15
 	.else  do
 	..if ($f(ctdesc,"-")'=0)  do
    ...set ctdesc=$p(ctdesc,"-",2)
    ..do OutputRow15
    
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow15
	set Data=$lb(ctdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query occulookup(desc) As websys.Query(ROWSPEC = "occupation:%String,occupationid:%String")
{
}

ClassMethod occulookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
    set stdate=+$h
	set rowid="0"
	for  set rowid=$o(^CT("OCC",rowid))  quit:(rowid="")  do
	.quit:($d(^CT("OCC",rowid))=0)
	.set actstdate=$p(^CT("OCC",rowid),"^",3)
	.set actenddate=$p(^CT("OCC",rowid),"^",4)
	.quit:((actstdate'="")&&(actstdate>stdate))
	.quit:((actenddate'="")&&(actenddate<stdate))
	.set ctdesc=$p(^CT("OCC",rowid),"^",2)
	.set ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	.if (desc'="")  do
	..if (ctdesc1[desc)  do
	...if ($f(ctdesc,"-")'=0)  do
    ....set ctdesc=$p(ctdesc,"-",2)
    ...do OutputRow16
 	.else  do
 	..if ($f(ctdesc,"-")'=0)  do
    ...set ctdesc=$p(ctdesc,"-",2)
    ..do OutputRow16
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRow16    
	set Data=$lb(ctdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query educationlookup(desc) As websys.Query(ROWSPEC = "education:%String,educationid:%String")
{
}

ClassMethod educationlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
    set stdate=+$h
	set rowid="0"
	for  set rowid=$o(^CT("EDU",rowid))  quit:(rowid="")  do
	.quit:($d(^CT("EDU",rowid))=0)
	.set ctdesc=$p(^CT("EDU",rowid),"^",2)
	.set ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	.if (desc'="")  do
	..if (ctdesc1[desc)  do
	...if ($f(ctdesc,"-")'=0)  do
    ....set ctdesc=$p(ctdesc,"-",2)
    ...do OutputRow17
 	.else  do
 	..if ($f(ctdesc,"-")'=0)  do
    ...set ctdesc=$p(ctdesc,"-",2)
    ..do OutputRow17
    
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow17    
	set Data=$lb(ctdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query langulookup(desc) As websys.Query(ROWSPEC = "language:%String,languageid:%String")
{
}

ClassMethod langulookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
    set stdate=+$h
	set rowid="0"
	for  set rowid=$o(^SS("LAN",rowid))  quit:(rowid="")  do
	.quit:($d(^SS("LAN",rowid))=0)
	.set ctdesc=$p(^SS("LAN",rowid),"^",2)
	.set ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	.if (desc'="")  do
	..if (ctdesc1[desc)  do
	...if ($f(ctdesc,"-")'=0)  do
    ....set ctdesc=$p(ctdesc,"-",2)
    ...do OutputRow18
 	.else  do
 	..if ($f(ctdesc,"-")'=0)  do
    ...set ctdesc=$p(ctdesc,"-",2)
    ..do OutputRow18
    
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow18    
	set Data=$lb(ctdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query emptypelookup(desc) As websys.Query(ROWSPEC = "EmployeeType:%String,EmployeeTypeid:%String")
{
}

ClassMethod emptypelookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
 	Set ind=1
    s desc=$$ALPHAUP^SSUTIL4(desc)
    s stdate=+$h
	s rowid="0"
	f  s rowid=$o(^PAC("EPE",rowid))  q:rowid=""  d
	.q:($d(^PAC("EPE",rowid))=0)
	.s ctdesc=$p(^PAC("EPE",rowid),"^",2)
	.s ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	.i desc'=""  d
	..i ctdesc1[desc  d
	...i $f(ctdesc,"-")'=0  d
    ....s ctdesc=$p(ctdesc,"-",2)
    ...d OutputRow19
 	.e  d
 	..i $f(ctdesc,"-")'=0  d
    ...s ctdesc=$p(ctdesc,"-",2)
    ..d OutputRow19
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow19    
	set Data=$lb(ctdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query hplacelookup(desc) As websys.Query(ROWSPEC = "homeplace:%String,birprovid:%String,bircityid:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPReg","hplacelookup", "北京")
ClassMethod hplacelookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
	if (desc'="") {
		set desc=$$ALPHAUP^SSUTIL4(desc)
	}
	set curDate=+$h
	
	set cityrowid="0"
	for  set cityrowid=$o(^CT("CIT",cityrowid))  quit:(cityrowid="")  do
	.set ctdesc=$p(^CT("CIT",cityrowid),"^",2)
	.set frmDate=$p(^CT("CIT",cityrowid),"^",5)
	.set toDate=$p(^CT("CIT",cityrowid),"^",6)
	.quit:((frmDate'="")&&(+frmDate>curDate))
	.quit:((toDate'="")&&(+toDate<curDate))
	.set tmpData=""
	.set provdesc=""
	.set provrowid=$p(^CT("CIT",cityrowid),"^",4)
	.if ((+provrowid'=0)&&($d(^CT("PROV",provrowid))'=0))  do
	..set provdesc=$p(^CT("PROV",provrowid),"^",2)
	..set tmpData=ctdesc_"^"_provdesc
	.set tmpData=$$ALPHAUP^SSUTIL4(tmpData)
	.quit:((desc'="")&&(tmpData'[desc))
	.if ($f(ctdesc,"-")'=0)  set ctdesc=$p(ctdesc,"-",2)
	.if ($f(provdesc,"-")'=0)  set provdesc=$p(provdesc,"-",2)
	.set homeplace=ctdesc_" "_provdesc
	.do OutputHomePlace
    
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputHomePlace
	set Data=$lb(homeplace,provrowid,cityrowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query ctrltlookup(desc) As websys.Query(ROWSPEC = "ctrlt:%String,ctrltid:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPReg","ctrltlookup", "")
ClassMethod ctrltlookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
    set desc=$$ALPHAUP^SSUTIL4(desc)
    
    set curDate=+$h
    
	set rowid="0"
	for  set rowid=$o(^CT("RLT",rowid))  quit:(rowid="")  do
	.quit:($d(^CT("RLT",rowid))=0)
	.set ctdesc=$p(^CT("RLT",rowid),"^",2)
	.set ctdesc1=$$ALPHAUP^SSUTIL4(ctdesc)
	.set stDate=$p(^CT("RLT",rowid),"^",3)
	.set endDate=$p(^CT("RLT",rowid),"^",4)
	.quit:((stDate'="")&&(stDate>curDate))
	.quit:((endDate'="")&&(endDate<curDate))
	.if (desc'="")  do
	..if (ctdesc1[desc)  do
	...if ($f(ctdesc,"-")'=0)  do
    ....set ctdesc=$p(ctdesc,"-",2)
    ...do OutputCtrlt
 	.else  do
 	..if $f(ctdesc,"-")'=0  d
    ...set ctdesc=$p(ctdesc,"-",2)
    ..do OutputCtrlt
    
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputCtrlt
	set Data=$lb(ctdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

Query cityarealookup(desc, cityid, provid) As websys.Query(ROWSPEC = "cityarea:%String,ciytdesc:%String,provdesc:%String,cityareaid:%String,citydr:%String,provdr:%String")
{
}

ClassMethod cityarealookupExecute(ByRef qHandle As %Binary, desc As %String, cityid As %String, provid As %String) As %Status
{
 	set repid=$I(^CacheTemp)
 	set ind=1
    s desc=$$ALPHAUP^SSUTIL4(desc)
    s stdate=+$h
	s ctdesc="",citydesc="",rowid="0" ,citydr=""
	s provdesc="",provdr=""
    d OutputRow22
	s rowid="0"
	f  s rowid=$o(^CT("CITAREA",rowid))  q:(rowid="")  d
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
    
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
	
OutputRow22    
	set Data=$lb(ctdesc,citydesc,provdesc,rowid,citydr,provdr)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod test()
{
 ;70067!60607!37573!1991!1062!!!!!!!!!O!!!!!!!
 s PatientID="70067",AdmDate=+$h,AdmTime=$p($H,",",2),AdmDoc="1991"
 s AdmDep="1062",RefDoc="",RefDate=+$h,Payor="",Plan=""
 s PayorOffice="",InsDateFrom="",InsDateTo="",EpisodeID=""
 s AdmType="I",Bed="",P0="",P1="",P2="",P3="",P4="",P5=""
 w !,PatientID_"!"_AdmDate_"!"_AdmTime_"!"_AdmDoc_"!"_AdmDep_"!"_RefDoc_"!"_RefDate_"!"_Payor_"!"_Plan_"!"_PayorOffice_"!"_InsDateFrom_"!"_InsDateTo_"!"_EpisodeID_"!"_AdmType_"!"_Bed_"!"_P0_"!"_P1_"!"_P2_"!"_P3_"!"_P4_"!"_P5
 s aa=##Class(web.PAAdm).ADMInsert(PatientID,AdmDate,AdmTime,AdmDoc,AdmDep,RefDoc,RefDate,Payor,Plan,PayorOffice,InsDateFrom,InsDateTo,EpisodeID,AdmType,Bed,P0,P1,P2,P3,P4,P5)
 w !,aa
 q
}

ClassMethod JudgePatStatus(papno)
{
 s papno=$g(papno)
 q:(papno="") ""
 s papmi=$o(^PAPERi("PAPMI_PatNo",papno,"")) ;papmi_rowid
 q:papmi="" ""
 s admId=0
 s status=""
 f  s admId=$o(^PAPERdr(papmi,"ADM","I",admId)) q:(admId="")!(status'="")  d ;???ǘ?admId
 .q:'$d(^PAADM(admId))
 .s amount=##class(web.UDHCJFQFDEAL).getqfamount(admId)
 .i amount'=0 s status="-1"
 .s pbrowid=""
 .f  s pbrowid=$o(^DHCPB(0,"ADM",admId,pbrowid)) q:(pbrowid="")!(status'="")  d
 ..s pbflag=$p(^DHCPB(pbrowid),"^",16)
 ..s pbamt=$p(^DHCPB(pbrowid),"^",8)
 ..i (pbflag="B")&(+pbamt'=0) s status="-2"
 q status
}

ClassMethod getnewcardinfo(id)
{
   s str=""
   s id=$g(id)
   q:(id="") str
   s patid="",patno=""
   s patid=$o(^PAPER("DHC","NewCardNo",id,patid))
   s newcardno=id
   i patid'=""  d
   .&sql(select papmi_no into :papno from pa_patmas where papmi_rowid=:patid )
   .i SQLCODE'=0  d
   ..s patno=""
   ..s patid=""
   ..s str=""
   .e  d
   ..s str=id_"^"_patid_"^"_papno  
   e  d
   .s str=""
   q str
}

Query refdoclookup(desc As %String) As websys.Query(ROWSPEC = "name:%String,id:%String")
{
}

ClassMethod refdoclookupExecute(ByRef qHandle As %Binary, desc As %String) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ind=1
	s desc=$$ALPHAUP^SSUTIL4(desc)
	s rowid="0"
	f  s rowid=$o(^PAC("REFD",rowid))  q:rowid=""  d
	.s refcode=$p(^PAC("REFD",rowid),"^",1)
	.s refcode=$$ALPHAUP^SSUTIL4(refcode)
	.s refdesc=$p(^PAC("REFD",rowid),"^",2)
	.s refdesc=$$ALPHAUP^SSUTIL4(refdesc)
	.i desc'=""  d
	..i refcode[desc d
	...d OutputRow23	
	..i refdesc[desc d
	...d OutputRow23	
	.e  d
	..d OutputRow23
	
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
    
OutputRow23
	set Data=$lb(refdesc,rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod getadmstatus(admrowid)
{
   s admrowid=$g(admrowid)
   q:(admrowid="") ""
   s admstatus=""
   i $d(^PAADM(admrowid))'=0  d
   .s admstatus=$p(^PAADM(admrowid),"^",20)
   .i admstatus'="A"  d
   ..s admstatus=""
   q admstatus
}

/// w ##Class(web.UDHCJFIPReg).GetWardBedIdleNum("5")
ClassMethod GetWardBedIdleNum(WardID As %String) As %String
{
	n (WardID)
	s rtn=0
	q:(WardID="") rtn
	
	s WardBedNum=..GetWardBedNum(WardID)
	s WardAdmitNum=..GetWardAdmitNum(WardID)
	
	s rtn=WardBedNum-WardAdmitNum

	q rtn
}

/// w ##class(web.UDHCJFIPReg).GetWardBedNum(45)
ClassMethod GetWardBedNum(WardID As %String) As %String
{
	n (WardID)
	s WardBedNum=0
	q:(WardID="") WardBedNum
	
	s Today=+$h
	s BedSub="0"
	f  s BedSub=$o(^PAWARD(WardID,"BED",BedSub)) q:(BedSub="")  d
	.s RcFlag=$p($g(^PAWARD(WardID,"BED",BedSub)),"^",4)
	.q:(RcFlag'="Y")
	.s bedTypeDR=$p($g(^PAWARD(WardID,"BED",BedSub)),"^",2)
	.s bedTypeCode=$p(^PAC("BEDTP",bedTypeDR),"^",1)
	.s bedTypeCode=$$ALPHAUP^SSUTIL4(bedTypeCode)
	.q:(bedTypeCode["BABY")         //不统计婴儿床
	.s DateFrom=$p($g(^PAWARD(WardID,"BED",BedSub)),"^",21)
	.s DateTo=$p($g(^PAWARD(WardID,"BED",BedSub)),"^",22)
	.q:((DateFrom'="")&&(DateFrom>Today))
	.q:((DateTo'="")&&(DateTo<Today))
	.s WardBedNum=WardBedNum+1
	
	q WardBedNum
}

/// w ##class(web.UDHCJFIPReg).GetWardAdmitNum(45)
ClassMethod GetWardAdmitNum(WardID As %String) As %String
{
	n (WardID)
	s WardAdmitNum=0
	q:(WardID="") WardAdmitNum

	s Adm="0"
	f  s Adm=$o(^PAADMi("AdmTypeCurr","I",Adm)) q:(Adm="")  d
	.s CurrWard=$p($g(^PAADM(Adm)),"^",70)
	.q:(CurrWard'=WardID)
	.s BMBRowID=$o(^DHCBed("MaternalBaby",0,"Ward",CurrWard,"0"))   //+2018-02-28 ZhYW 取护士长母婴床维护配置(DHC_Bed_MaternalBaby)
	.s motherAdm=$p(^PAADM(Adm),"^",75)
	.q:((motherAdm'="")&&(+BMBRowID'=0))        //母婴床的婴儿不占用床位
	.s WardAdmitNum=WardAdmitNum+1
	
	q WardAdmitNum
}

/// 作者：    陈曦
/// 编写日期：2008-11-4
/// 描述：    检查床位是否可用
/// 入参：    pac_Bed.Rowid
/// 返回值：  N--床位不可用，Y--床位可用
ClassMethod GetPacBedFlag(PacWardID, PacBedSubID, SexID)
{
   q:(PacWardID="") "N"
   q:(PacBedSubID="") "N"
   s PacBedID=PacWardID_"||"_PacBedSubID
   s PacBedFlag="Y"
   q:($d(^PAWARD(PacWardID,"BED",PacBedSubID))=0) "N"
   s bedavail="" 
   &sql(select BED_Available into :PacBedAvail from pac_bed where bed_rowid=:PacBedID)
   s PacBedAvail=$p(PacBedAvail,$c(1))
   q:(PacBedAvail'="Y") "N"
   s CurrDate=+$h
   s BedDateFrom=$p(^PAWARD(PacWardID,"BED",PacBedSubID),"^",21)
   s BedDateTo=$p(^PAWARD(PacWardID,"BED",PacBedSubID),"^",22)
   q:(BedDateFrom'="")&(CurrDate<BedDateFrom) "N"
   q:(BedDateTo'="")&(CurrDate>BedDateTo) "N"
   s PacRoomID=$p(^PAWARD(PacWardID,"BED",PacBedSubID),"^",3)
   q:(PacRoomID="") "N"
   q:($d(^PAROOM(PacRoomID))=0) "N"
   s RoomDateFrom=$p(^PAROOM(PacRoomID),"^",8)
   s RoomDateTo=$p(^PAROOM(PacRoomID),"^",9)
   q:(RoomDateFrom'="")&(CurrDate<RoomDateFrom) "N"
   q:(RoomDateTo'="")&(CurrDate>RoomDateTo) "N"
   s PacBedFlag=..checkini(PacWardID,PacBedSubID)
   i PacBedFlag'="N"  d
   .s PacBedFlag="Y"
   q:(PacBedFlag="N") PacBedFlag
   s RoomSexDiff=$p(^PAROOM(PacRoomID),"^",4)   
   s BedAdmID="",bednum=0
   f  s BedAdmID=$o(^PAWARDA(PacWardID,"BED",PacBedSubID,"ADM",BedAdmID))  q:BedAdmID=""  d
   .s EpisodeID=$p(^PAWARDA(PacWardID,"BED",PacBedSubID,"ADM",BedAdmID),"^",1)
   .q:($d(^PAADM(EpisodeID))=0)
   .s AdmVisit=$p(^PAADM(EpisodeID),"^",20)
   .q:(AdmVisit'="A")
   .s PatientID=$p(^PAADM(EpisodeID),"^",1)
   .q:($d(^PAPER(PatientID))=0)
   .s PAPERSexId=$p(^PAPER(PatientID,"ALL"),"^",7)
   .i (PAPERSexId'=SexID)&(SexID'="")  d
   ..s bednum=bednum+1
   q:(bednum>0)&(RoomSexDiff="N") "N"
   q PacBedFlag
}

ClassMethod checkini(ward, bed) As %String
{
	n (ward,bed)
	q:($g(ward)="")||($g(bed)="") ""
	s falg=""
	s inidate=+$h+1
	f  s inidate=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate),-1)  q:(inidate="")||(falg="N")  d
	.s initime=""
	.s:inidate=+$h initime=+$p($h,",",2)+1
	.f  s initime=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate,initime),-1)  q:(initime="")||(falg="N")  d
	..s sub=""
	..f  s sub=$o(^PAWARDA(ward,"BED",bed,"STAT",0,"Date",inidate,initime,sub),-1)  q:(sub="")||(falg="N")  d 
	...s dateto=$p($g(^PAWARDA(ward,"BED",bed,"STAT",sub)),"^",5)
	...s:+dateto=0 falg="N"
	...s timeto=$p($g(^PAWARDA(ward,"BED",bed,"STAT",sub)),"^",6)
	...q:((+dateto<+$h)||((dateto=+$h)&&(timeto<+$P($h,",",2))))
	...s falg="N"
    q falg
}

ClassMethod MRN(Type)
{
  ;自动生成病案号 yyx2008-07-07
  s cntrowid=""
  s cntrowid=$o(^COUNT("DHCCNT",0,"Desc",Type,""))
  i cntrowid="" q 0
  L +^COUNT("DHCCNT",cntrowid)
  s s1=$g(^COUNT("DHCCNT",cntrowid))
  s len=$p(s1,"^",3),cnt=^COUNT("DHCCNT",cntrowid,"CNT")
  s cnt=cnt+1
  S ^COUNT("DHCCNT",cntrowid,"CNT")=cnt
  L -^COUNT("DHCCNT",cntrowid)
  ;f i=$l(cnt):1:len-1 d
  .;s cnt="0"_cnt
  q cnt
}

ClassMethod GetMRN(Type)
{
  ;自动生成病案号 yyx2008-07-07
  s cntrowid=""
  s cntrowid=$o(^COUNT("DHCCNT",0,"Desc",Type,""))
  i cntrowid="" q 0
  s s1=$g(^COUNT("DHCCNT",cntrowid))
  s len=$p(s1,"^",3),cnt=^COUNT("DHCCNT",cntrowid,"CNT")
  q cnt
}

ClassMethod GetMRN1(Type, MedCNT, patid)
{
  ;自动生成病案号 yyx2008-07-07
  s MedCNT=$g(MedCNT)
  q:(MedCNT="") ""
  s MedCNT1=+MedCNT
  q:(MedCNT1'=MedCNT) MedCNT 
  s cntrowid=""
  s cntrowid=$o(^COUNT("DHCCNT",0,"Desc",Type,""))
  i cntrowid="" q ""
  s s1=$g(^COUNT("DHCCNT",cntrowid))
  s len=$p(s1,"^",3)
  ;f i=$l(MedCNT):1:len-1 d
  .;s MedCNT="0"_MedCNT
  s MedCNT=$$ALPHAUP^SSUTIL4(MedCNT)
  s rowid=""
  s rowid=$o(^PAPERi("Medicare1",MedCNT,rowid))
  q:(rowid'="")&(rowid'=patid) "MRNError1"
  q MedCNT
}

/// Creator: ZhYW
/// CreatDate: 2018-06-05
/// Description: 根据住院证ID取住院证信息
/// Input: IPBookID: DHCDocIPBooking.RowID
/// Output:
/// Return: 
/// Debug: w ##class(web.UDHCJFIPReg).GetIPBookInfo(421)
ClassMethod GetIPBookInfo(IPBookID As %String) As %String
{
	new (IPBookID)
	set ret="-1"
	quit:(IPBookID="") ret
	set ret=##class(web.DHCDocIPBookNew).GetBookMesage(IPBookID)
	//+2018-07-16 ZhYW 有预约到床位时，取预约的病区
	set appBedInfo=##class(Nur.InService.Interface).ifPatAppBed(IPBookID)   //预约床位
	set err=$p(appBedInfo,"^",1)
	if (+err=0) {
		set deptDR=$p(appBedInfo,"^",2)
		if (+deptDR'=0) {
			set deptCode=$p($g(^CTLOC(deptDR)),"^",1)
			set wardDR=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(deptCode),0))
		 	set wardDesc=$s((+wardDR'=0):$p(^PAWARD(wardDR),"^",2), 1:"")
			if (+wardDR'=0) {
				set $p(ret,"^",12)=wardDR
			}
		}
	}
	quit ret
}

/// modify by rp 201004
/// w ##class(web.UDHCJFIPReg).GetIPBKPatInfoByPatientID(421,"")
ClassMethod GetIPBKPatInfoByPatientID(PatientID As %String, IPBook As %String) As %String
{
	s IPBookID=""

	s ret="-1"
	s IPBookID=IPBook
	q:IPBookID="" "-1"
	
	s ret=##class(web.DHCDocIPBookNew).GetBookMesage(IPBookID)
	q ret
}

/// modify by rp 201004
ClassMethod GetIPBKPatInfoByPatientIDOLD(PatientID As %String) As %String
{
	s IPBookID=""
	;s IPBookID=$o(^DHCDocIPBK(0,"EpisodeIDFrom",EpisodeIDFrom,IPBookID))
	Q:PatientID="" "-1"
	s IPBookID=$o(^DHCDocIPBK(0,"PatientID",PatientID,""),-1)
	s ret="-1"
	q:IPBookID="" "-1"
	q:'$d(^DHCDocIPBK(IPBookID)) "-1"
	s str=$g(^DHCDocIPBK(IPBookID))
	s CtlocID=$p(str,"^",13)		//科室ID
	s WardID=$p(str,"^",11)			//病区ID
	s BedID=$p(str,"^",12)			//床位ID
	s DocID=$p(str,"^",7)			//医生ID
	s DiagnoseID=$p(str,"^",14) 	//诊断ID
	s TemplateItemCode="IPDeposit" 	//取预交金金额约定代码
	s IPDeposit=""
	s ret=CtlocID_"^"_WardID_"^"_BedID_"^"_DocID_"^"_IPDeposit
	q:'$d(^DHCDocIPBKTI(0,"ItemCode",TemplateItemCode)) "-1"
	s ItemRowID=""
	s ItemID=$o(^DHCDocIPBKTI(0,"ItemCode",TemplateItemCode,ItemRowID))
	q:'$d(^DHCDocIPBKD(0,"BookItem",IPBookID,ItemID)) "-1"
	s DetailID=""
	s DetailID=$o(^DHCDocIPBKD(0,"BookItem",IPBookID,ItemID,DetailID))
	i DetailID'=""  d
	.s IPDeposit=$p($g(^DHCDocIPBKD(DetailID)),"^",3)
	s ret=CtlocID_"^"_WardID_"^"_BedID_"^"_DocID_"^"_IPDeposit_"^"_DiagnoseID
	q ret
}

/// Lid
/// 2010-10-20
/// 病人类型转换更新接口
/// 入参:adm:就诊Rowid,
///     admReasonDr:Pa_admreason表Rowid
///     updateUser:更新人Rowid
/// 		expStr:扩展字段，以"^"分开
/// 出参:-1:就诊Rowid为空
///     -2:病人类型指针为空
///     -3:更新人为空
///     0:更新成功
///     其它:更新不成功
/// w ##class(web.UDHCJFIPReg).IUpdateAdmReason(adm, admReasonDr, updateUser, expStr)
ClassMethod IUpdateAdmReason(adm, admReaDrOld, admReasonDr, updateUser, expStr)
{
	n (adm,admReaDrOld,admReasonDr,updateUser,expStr)
	q:adm="" -1
    q:admReasonDr="" -2
    q:updateUser="" -3
    s upda=+$h
    s uptime=$p($h,",",2)
    s papmiDr=$p(^PAADM(adm),"^",1)
	;s admReaDrOld=$p(^PAADM(adm,1),"^",7)  ;原“病人类型”
	s admReaDrNew=admReasonDr
	s userid=updateUser
	s err=0
	TSTART
	;更新paadm表的病人类型
	 
	i ((admReaDrNew'=admReaDrOld)&(err=0)) d
    .&sql(update SQLUSER.pa_adm set  
            PAADM_AdmReason_DR=:admReaDrNew,   
            PAADM_UpdateDate=:upda,
            PAADM_UpdateTime=:uptim,
            PAADM_UpdateUser_DR=:userid
        where paadm_rowid=:adm)
    .s err=SQLCODE
    ;更新账单表的病人类型
    i ((admReaDrNew'=admReaDrOld)&(err=0)) d
    .s billDr=""
    .f  s billDr=$o(^DHCPB(0,"ADM",adm,billDr)) q:((billDr="")!(err'=0))  d
    ..s payedFlag=$p($g(^DHCPB(billDr)),"^",16)
    ..q:payedFlag'="B"
    ..&sql(UPDATE DHC_PatientBill SET PB_PatInsType_DR=:admReaDrNew WHERE PB_RowId= :billDr)
    ..s err=SQLCODE

    i (admReaDrNew'=admReaDrOld)&(err=0)  d
  	.s t1="PA_Adm" ,t2="PAADM_AdmReason_DR"
  	.s t3=admReaDrOld ,t4=admReaDrNew
  	.s err=..insupreport(papmiDr,adm,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")

    i err=0 d
    .TCOMMIT
    e  d
    .TROLLBACK
    
    q err
}

/// Creator:yyx
/// CreateDate:2011-05-12
/// Function  :修改住院次数，只能修改在院的住院次数，而且是最后一个就诊的，不允许修改以前就诊的住院次数湘雅二院需求
/// w ##class(web.UDHCJFIPReg).UpdateAdmInPatNo(1285,2,639) 
ClassMethod UpdateAdmInPatNo(AdmRowID, InPatNo, User)
{
	s AdmVisitStatus=$p(^PAADM(AdmRowID),"^",20)
	q:AdmVisitStatus'="A" "D"   ;不是在院的不允许修改
	s PAPMiID=$p(^PAADM(AdmRowID),"^",1)
	s OldInPatNo=$p(^PAADM(AdmRowID),"^",29)
	TStart
	&sql(update pa_adm set paadm_inpatno=:InPatNo where paadm_rowid=:AdmRowID)
	s rtn=SQLCODE
	i rtn=0 d
	.s ^DHCIPBILL("UDHCJFIPReg",AdmRowID,+$h,$p($h,",",2))=User_"^"_OldInPatNo_"^"_InPatNo
	.&sql(update pa_person set paper_ExemptionNumber=:InPatNo where paper_rowid=:PAPMiID)
	.s rtn=SQLCODE
	i rtn=0 d 
	.tcommit
	e  d
	.trollback
	q rtn
}

/// 根据就诊取医嘱信息，如果有则不允许修改科室，否则可以修改
ClassMethod GetAdmOrder(AdmRowID)
{
	q:AdmRowID="" "0"
	S OrdNum=0
	s OEOrder=$o(^OEORD(0,"Adm",AdmRowID,""))
	i OEOrder="" s OrdNum="0"
	e  d
	.s OrdSub=0
	.f  s OrdSub=$o(^OEORD(OEOrder,"I",OrdSub)) q:OrdSub=""  d
	..s OrdNum=OrdNum+1
	q +$g(OrdNum)
}

/// 根据科室取病区
ClassMethod GetDepLinkWard(DepID)
{
	s childid="",Num=0
	s ctdesc="",rowid=""
	f  s childid=$o(^CTLOC(DepID,"LINK",childid))  q:childid=""  d
	.s linkid=$p(^CTLOC(DepID,"LINK",childid),"^",1)
	.q:($d(^CTLOC(linkid))=0)
	.s loctype=$p(^CTLOC(linkid),"^",13)
	.q:(loctype'="W")
	.s ctdesc=$p(^CTLOC(linkid),"^",2)
	.s rowid=""
	.s rowid=$o(^PAWARD(0,"WARD_LocationDR",linkid,rowid))
	.s Num=Num+1
    .i ctdesc["-" s ctdesc=$p(ctdesc,"-",2)
    q Num_"^"_ctdesc_"^"_rowid
}

Query InAdmSourceLookUp() As websys.Query(ROWSPEC = "InAdmSource:%String,InAdmSourceID")
{
}

ClassMethod InAdmSourceLookUpExecute(ByRef qHandle As %Binary) As %Status
{
 	Set repid=$I(^CacheTemp)
	Set ind=1
	s AttendRowID=0
	f  s AttendRowID=$o(^PAC("ADSOU",AttendRowID)) q:AttendRowID=""  d
	.s AdmSourceOfAttend=$p(^PAC("ADSOU",AttendRowID),"^",2)
	.s stdate=$p(^PAC("ADSOU",AttendRowID),"^",4)
	.s enddate=$p(^PAC("ADSOU",AttendRowID),"^",5)
	.q:(((stdate>+$h)&&(stdate'=""))||((enddate<+$h)&&(enddate'=""))) ;不在有效期的途径不显示 add zhli  17.9.7
    .d OutputRowAttend
 	Set qHandle=$lb(0,repid,0)
	Quit $$$OK
OutputRowAttend
	set Data=$lb(AdmSourceOfAttend,AttendRowID)
 	Set ^CacheTemp(repid,ind)=Data
 	Set ind=ind+1
	quit
}

/// 获得开住院证医生
Query GetDocCreateBookInfo(DocCreateBook As %String) As websys.Query(ROWSPEC = "DocDesc:%String,DocNo:%String,SSUSRInitials:%String")
{
}

ClassMethod GetDocCreateBookInfoExecute(ByRef qHandle As %Binary, DocCreateBook As %String) As %Status
{
	Set repid=$I(^CacheTemp)
	set ind=1
	set UserId=0 
	for  set UserId=$O(^SSU("SSUSR",UserId)) quit:(UserId="")  do
	.set Username=$P(^SSU("SSUSR",UserId),"^",2)
	.quit:(DocCreateBook'="")&&(Username'[DocCreateBook)
	.set DocDesc=Username,DocNo=UserId
	.s SSUSRInitials=$P(^SSU("SSUSR",UserId),"^",1)
	.do OutputRowDocDesc
	
	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRowDocDesc
	set Data=$lb(DocDesc,DocNo,SSUSRInitials)
	set ^CacheTemp(repid,ind)=Data
	set ind=ind+1
	quit
}

/// w ##class(web.UDHCJFIPReg).UpDiagnos("初步诊断^3^伤寒^4^^7^80")
ClassMethod UpDiagnos(DiagInfo)
{
	s ^Lid("diagnos")=DiagInfo
	q:($g(DiagInfo)="") "DiagNull"
	s upda=+$h, uptime=$p($h,",",2)
	s RetCode=0
    s DiagnosType=$p(DiagInfo,"^",1)
    s DiagnosTypeid=$p(DiagInfo,"^",2)
    s Diagnos=$p(DiagInfo,"^",3)
    s Diagnosid=$p(DiagInfo,"^",4)
    s Diagnosdesc=$p(DiagInfo,"^",5)
    s Guser=$p(DiagInfo,"^",6)
    s EpisodeID=$p(DiagInfo,"^",7)
    i (DiagnosType="")  s DiagnosTypeid="" 
    q:((Diagnosid="")&&(Diagnosdesc="")) "DiagNull"
    q:(+EpisodeID=0) "AdmNull"
    s PAPERRowid=$p(^PAADM(EpisodeID),"^",1)
    q:(+PAPERRowid=0) "AdmNull"
    s VisitStatus=$p(^PAADM(EpisodeID),"^",20)
    q:(VisitStatus'="A") "AdmDisch" 
     
    q:(DiagnosType="") "DiagnosTypeNull"
    q:(DiagnosTypeid="") "DiagnosTypeNull"
    q:(Diagnos'="")&(Diagnosid="") "DiagnosNull"
    q:(Diagnos="")&(Diagnosid'="") "DiagnosNull" 
    q:(Guser="") "GuserNull"
    s DiagNum=0
    s MrAdm=$p(^PAADM(EpisodeID),"^",61)
    q:(+MrAdm=0) "AdmNull"
    s MRDIAChildsub="0"
    f  s MRDIAChildsub=$o(^MR(MrAdm,"DIA",MRDIAChildsub))  q:(MRDIAChildsub="")  d
    .s DiagNum=DiagNum+1    
    q:(DiagNum>1) "MoreDiag"
    s DeptDr=$p(^PAADM(EpisodeID),"^",4)
    s DiagnosTypeErr=0
    s Diagnosdesc1=$LISTBUILD(Diagnosdesc)

    TSTART
    i (DiagNum=0)  d
    .//+2018-03-29 ZhYW
    .s diagStatusDR=$o(^MRC("DSTAT",0,"Code","01",0))
  	.s err=##class(web.DHCDocDiagnosEntryV8).InsertOneMRDiagnos(DeptDr, MrAdm, Diagnosid, Guser, Diagnosdesc, DiagnosType, "", "", "", "",  "", diagStatusDR, "", Guser, "N", "", "", "", upda, "", upda)
    .s RetCode=$p(err,"^",1)
    .s NewDiagRowid=$p(err,"^",2)
    .i (RetCode=0)  d
    ..i (DiagnosTypeid'="")  d
    ...s t1="MR_DiagType", t2="TYP_MRCDiagTyp"
    ...s t3="", t4=DiagnosTypeid
    ...s err=..insupreport(PAPERRowid,EpisodeID,t1,t2,t3,t4,Guser,upda,uptime,"1",NewDiagRowid,"Insert","","")
    ...s RetCode=RetCode+err
    ..i (Diagnosid'="")  d
    ...s t1="MR_Diagnos", t2="MRDIA_ICDCode_DR"
    ...s t3="", t4=Diagnosid
    ...s err=..insupreport(PAPERRowid,EpisodeID,t1,t2,t3,t4,Guser,upda,uptime,"1",NewDiagRowid,"Insert","","")
    ...s RetCode=RetCode+err
    ..i (Diagnosdesc'="")  d
    ...s t1="MR_Diagnos", t2="MRDIA_Desc"
    ...s t3="", t4=Diagnosdesc
    ...s err=..insupreport(PAPERRowid,EpisodeID,t1,t2,t3,t4,Guser,upda,uptime,"1",NewDiagRowid,"Insert","","")
    ...s RetCode=RetCode+err  
    .e  d
    ..s RetCode=100 
    e  i DiagNum=1  d
    .s MRDIAChildsub=$o(^MR(MrAdm,"DIA","0"))
    .i (MRDIAChildsub'="")  d  
    ..s OldDiagnosid=$p(^MR(MrAdm,"DIA",MRDIAChildsub),"^",1)
    ..s DiagnosdescDr=$g(^MR(MrAdm,"DIA",MRDIAChildsub,"DES",0))
    ..s OldDiagnosdesc=""
    ..i (DiagnosdescDr'="")  d
    ...s OldDiagnosdesc=$g(^MR(MrAdm,"DIA",MRDIAChildsub,"DES",DiagnosdescDr))
    ..s OldDiagnosTypeid=""
    ..s TYPsub=$o(^MR(MrAdm,"DIA",MRDIAChildsub,"TYP","0"))
    ..i (TYPsub'="")  d
    ...s OldDiagnosTypeid=$p(^MR(MrAdm,"DIA",MRDIAChildsub,"TYP",TYPsub),"^",1)
    ..s DiagRowid=MrAdm_"||"_MRDIAChildsub
    ..i (OldDiagnosTypeid=DiagnosTypeid)  d
    ...i (Diagnosid="")  d
    ....&sql(update MR_Diagnos set MRDIA_ICDCode_DR=null, MRDIA_Desc=:Diagnosdesc1, MRDIA_UpdateUser_DR=:Guser, MRDIA_OnsetDate=:upda where MRDIA_RowId=:DiagRowid)
    ...e  d
    ....&sql(update MR_Diagnos set MRDIA_ICDCode_DR=:Diagnosid, MRDIA_Desc=:Diagnosdesc1, MRDIA_UpdateUser_DR=:Guser, MRDIA_OnsetDate=:upda where MRDIA_RowId=:DiagRowid)
    ...s RetCode=RetCode+SQLCODE 
    ...i (Diagnosid=OldDiagnosid)&&(OldDiagnosdesc=Diagnosdesc) s RetCode="NoModify"
    ...q:RetCode="NoModify"
    ...i (RetCode=0)&(Diagnosid'=OldDiagnosid)  d
    ....s t1="MR_Diagnos", t2="MRDIA_ICDCode_DR"
    ....s t3=OldDiagnosid, t4=Diagnosid
    ....s err=..insupreport(PAPERRowid,EpisodeID,t1,t2,t3,t4,Guser,upda,uptime,"1",DiagRowid,"Update","","")     
    ....s RetCode=RetCode+err
    ...i (RetCode=0)&(OldDiagnosdesc'=Diagnosdesc)  d
    ....s t1="MR_Diagnos", t2="MRDIA_Desc"
    ....s t3=OldDiagnosdesc ,t4=Diagnosdesc
    ....s err=..insupreport(PAPERRowid,EpisodeID,t1,t2,t3,t4,Guser,upda,uptime,"1",DiagRowid,"Update","","") 
    ....s RetCode=RetCode+err     
    ..e  d
    ...s DiagnosTypeErr=1   
    
    i (RetCode=0)  d
    .Tcommit 
    e  d
    .Trollback 
    
    q:(DiagnosTypeErr=1) "DiagnosTypeErr"
    q RetCode
}

/// 判断病人是否有在院的记录
/// w ##class(web.UDHCJFIPReg).GetAdmFlag()
ClassMethod GetAdmFlag(PapRowID)
{
	s AdmRowID="",AdmNum=0
	f   s AdmRowID=$o(^PAPERdr(PapRowID,"ADM","I",AdmRowID),-1) q:(AdmRowID="")!(AdmNum'=0)  d
	.s AdmStatus=$p(^PAADM(AdmRowID),"^",20)
	.i AdmStatus="A" s AdmNum=AdmNum+1
	q AdmNum
}

Query QueryCareProv(RefDocList As %String) As websys.Query(ROWSPEC = "name:%String,id:%String")
{
}

/// d ##class(%ResultSet).RunQuery("web.UDHCJFIPReg","QueryCareProv","","")
ClassMethod QueryCareProvExecute(ByRef qHandle As %Binary, RefDocList As %String) As %Status
{
 	set repid=$I(^CacheTemp)
	set ind=1
 	set CPRowID=0
 	for  set CPRowID=$o(^CTPCP(CPRowID)) quit:(CPRowID="")  do
 	.set CPName=$p(^CTPCP(CPRowID,1),"^",2)
 	.quit:((RefDocList'="")&&(CPName'[RefDocList))
	.do OutputRowCP
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
	    
OutputRowCP
	set Data=$lb(CPName,CPRowID)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// creator:      chenxi
/// creatdate:    2014-05-22
/// Description:  判断输入日期是否合法
/// w ##class(web.UDHCJFIPReg).CheckDateIsLegality(DateStr)
ClassMethod CheckDateIsLegality(DateStr)
{
   s LDateStr1=$l(DateStr,"-")
   s LDateStr2=$l(DateStr,"/")
  
   q:(LDateStr1'=3)&&(LDateStr2'=3) "DateErr"
   s IsLegality="DateErr" 
   i LDateStr1=3  d
   .s Year=$p(DateStr,"-",1)
   .s Mon=$p(DateStr,"-",2)
   .s Day=$p(DateStr,"-",3)
   i LDateStr2=3  d
   .s Year=$p(DateStr,"/",3)
   .s Mon=$p(DateStr,"/",2)
   .s Day=$p(DateStr,"/",1)
   q:(Year["+")!(Year["-") "DateErr"
   q:(Mon["+")!(Mon["-") "DateErr"
   q:(Day["+")!(Day["-") "DateErr"
   q:(+Year=0) "DateErr"
   q:(+Mon=0) "DateErr"
   q:(+Day=0) "DateErr"
    
   q:(+Year<1841) "DateErr"     
   q:(+Year>9999) "DateErr"    
   q:(+Mon<1) "DateErr"   
   q:(+Mon>12) "DateErr"
   i Mon=12  d
   .s Year1=Year+1
   .s Mon1=1
   e  d
   .s Year1=Year
   .s Mon1=+Mon+1
   s NewDateStr=Year1_"-"_Mon1_"-"_"01"
   s NewDate=##class(websys.Conversions).DateHtmlToLogical(NewDateStr)
   s NewDate=NewDate-1
   s NewDateStr=$zd(NewDate,3)
   s NewDay=+$p(NewDateStr,"-",3)  
   q:((+Day)>(+NewDay)) "DateErr"   
   q "Yes"
}

/// creator:        chenxi
/// creatdate:      2014-11-18
/// description:    判断病人就诊状态
ClassMethod GetAdmVisitStatus(EpisodeID)
{
   n (EpisodeID)
   q:(+EpisodeID=0) "AdmNull"
   q:($d(^PAADM(EpisodeID))=0) "AdmNull"
   s AdmType=$p(^PAADM(EpisodeID),"^",2)
   s VisitStatus=$p(^PAADM(EpisodeID),"^",20)
   q AdmType_"^"_VisitStatus
}

ClassMethod ReadHealthCareProviderInfo() As %String
{
	s myobj=##class(web.DHCEntity.CTBASE.ComboListObject).%New()
	
	s myrtn=""
	s myCode=""
	s myDesc=""
	s myDefaultFlag=0
	s myDefRowID=0
	//s myDefInfo=##class(web.DHCBL.CARD.UCardPATRegConfig).GetDefaultNation()
	//s myDefRowID=$p(myDefInfo,"^",1)
	d myobj.Put("","",myDefaultFlag)
	s myRowID=0
	f  s myRowID=$o(^CT("HCP", myRowID))  q:(myRowID="")  d
	.s myCode=$p(^CT("HCP", myRowID),"^",1)
	.s myDesc=$p(^CT("HCP", myRowID),"^",2)
	.i myRowID=myDefRowID d
	..s myDefaultFlag=1
	.d myobj.Put(myRowID,myDesc_"-"_myCode,myDefaultFlag)
	.s myDefaultFlag=0
	
	s myrtn=myobj.GetListValue()
	d myobj.%Close()
	q myrtn
}

Query FindHCP() As websys.Query(ROWSPEC = "THCPDesc:%String,THCRowID:%String")
{
}

ClassMethod FindHCPExecute(ByRef qHandle As %Binary) As %Status
{
 	set repid=$I(^CacheTemp)
	set ind=1
	set myRowID=0
	for  set myRowID=$o(^CT("HCP", myRowID))  quit:(myRowID="")  do
	.set myDesc=$p(^CT("HCP", myRowID),"^",2)
	.do OutputRowHCP
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
	    
OutputRowHCP
	set Data=$lb(myDesc,myRowID)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod JudgePatInfo(PatNo)
{
	set PatNo=$g(PatNo)
	quit:(PatNo="") ""
	set PatNo=##class(web.UDHCJFBaseCommon).regnocon(PatNo)
	set papmi=$o(^PAPERi("PAPMI_PatNo",PatNo,"")) ;papmi_rowid
	quit papmi
}

ClassMethod GetAdmStatusInfo(Adm)
{
	new (Adm)
	quit:(+Adm=0) ""
	set AdmStatus=$p($g(^PAADM(Adm)),"^",20)
	quit AdmStatus
}

/// yyx 2012-10-26
/// 更新预约状态
/// w ##class(web.UDHCJFIPReg).UpdateVisitStatus(4054346,"A",3881,4439810)
ClassMethod UpdateVisitStatus(AdmID, NewVisitStatus, userid, IPBook)
{
	q:(AdmID="") 0
	s AdmOldVis=$p(^PAADM(AdmID),"^",20)
	q:AdmOldVis'["P" "VisErr"
	s papmi=$p(^PAADM(AdmID),"^",1)
	i IPBook="" d
	.s str=..GetIPBKPatInfoByPatientID(papmi,"")
	.s IPBook=$p(str,"^",9)
	tstart
	s Error=0
	s upda=+$h,uptime=$p($h,",",2)
	s VisitStatus=$p(^PAADM(AdmID),"^",20)
	s patid=$p(^PAADM(AdmID),"^",1)
	s CurrDate=+$h,CurrTime=$p($h,",",2)
 	i (VisitStatus="P") d
 	.;add by wangjian 预约住院转在院 增加住院次数
 	.s AdmTimes=+$p($g(^PAPER(papmi,"PER",4)),"^",8)
  	.s AdmTimes=AdmTimes+1
  	.&sql(update SQLUSER.PA_Person set paper_exemptionnumber=:AdmTimes where PAPER_RowId=:papmi)
  	.s Error=Error+SQLCODE
 	.;end
    .&sql(update pa_adm set paadm_visitstatus=:NewVisitStatus,paadm_updateuser_dr=:userid,paadm_updatedate=:upda,paadm_updatetime=:updtime,PAADM_AdmDate=:CurrDate,PAADM_AdmTime=:CurrTime,PAADM_CreateUser=:userid,PAADM_InPatNo=:AdmTimes where paadm_rowid=:AdmID)
    .s Error=Error+SQLCODE
    .s t1="PA_ADM", t2="PAADM_visitstatus"
    .s t3="P",  t4=NewVisitStatus   
    .s err=..insupreport(patid,AdmID,t1,t2,t3,t4,userid,upda,uptime,"1","","","","")
    .s Error=Error+err
    .i +IPBook'=0   d
    ..s err=##class(web.DHCDocIPBookingCtl).PatientArrive(IPBook, AdmID, userid)
    ..s Error=Error+err  
    .s warddr=$p(^PAADM(AdmID),"^",70)
    .s deptdr=$p(^PAADM(AdmID),"^",4)
    .k PLIST
	.s PLIST(0)=AdmID
	.s PLIST(3)=upda
	.s PLIST(4)=uptime
	.s PLIST(8)=deptdr
	.s PLIST(14)="5"
	.s PLIST(15)="Y"
	.s PLIST(16)=upda
	.s PLIST(17)=uptime
	.s PLIST(18)=userid
	.s PLIST(34)=""
	.&sql(INSERT INTO SQLUSER.PA_AdmTransaction Values PLIST())
	.s Error=Error+SQLCODE
    .q:+Error'=0
    .k PLIST
  	.s PLIST(0)=AdmID
  	.s PLIST(3)=upda
  	.s PLIST(4)=uptime
  	.s PLIST(9)=""
    .s PLIST(10)=warddr
  	.s PLIST(11)=""
  	.s PLIST(14)="5"
 	.s PLIST(16)=upda
 	.s PLIST(17)=uptime
  	.s PLIST(18)=userid
    .s PLIST(34)=""
    .&sql(INSERT INTO SQLUSER.PA_AdmTransaction Values PLIST())
    .s Error=Error+SQLCODE  
    .s admtransid=$g(%ROWID)
    .i admtransid'="" d
    ..k PLIST
    ..s PLIST(0)=warddr
    ..s PLIST(3)=AdmID
    ..s PLIST(4)="O"
    ..s PLIST(5)=admtransid
    ..&sql(INSERT INTO SQLUSER.PAC_WardAdm  Values PLIST())
    ..s Error=Error+SQLCODE  
  	
  	/*
	i (Error=0) d
	.s retstr=##class(DHCENS.REG.BS.WebREGService).IPRegInfoSend(AdmID)
	.s Error=Error+$p(retstr,"^",1)
  	*/
  	
	i (Error=0) d
	.tcommit
	e  d
	.trollback
  
    q Error
}

/// w ##class(web.UDHCJFIPReg).GetPapmiId(0000000147,500900A)
/// 通过登记号 住院号 获取 病人主索引
ClassMethod GetPapmiId(papno, zyno)
{
	s rowid=""
	i (papno'="")  d
	.s papno=##class(web.UDHCJFBaseCommon).regnocon(papno)
	.i (papno'="") s rowid=$o(^PAPERi("PAPMI_PatNo",papno,rowid))
	i (zyno'="")&&(rowid="") d
	.s zyno=$$ALPHAUP^SSUTIL4(zyno)
	.//update by zf 20150317 通过住院病案号取PatientID
	.s rowid=##class(DHCWMR.IO.OutService).IGetPatientIDByMrNo(zyno,"I","","")
	
	q rowid
}

/// 获取某个科室允许的性别和年龄范围
/// 住院登记时做控制
/// w ##class(web.UDHCJFIPReg).GetSexAndAgeByLoc(1,2,30,52961)
ClassMethod GetSexAndAgeByLoc(LocRowID As %String, PatSex As %String, PatAge As %String, DOB As %String) As %String
{
	s rtn=""
	s LocSexID=$p(^CTLOC(LocRowID),"^",64)
	s LocAgeFrom=$p(^CTLOC(LocRowID),"^",49)
	s LocAgeTo=$p(^CTLOC(LocRowID),"^",50)

	s LocAgeFrom=..GetBirthDayNew(LocAgeFrom)
	s LocAgeTo=..GetBirthDayNew(LocAgeTo)

	i (LocSexID'="")&(LocSexID'=PatSex)&(PatSex'="") s rtn="SexErr"
	i (DOB<LocAgeTo)&(+PatAge'=0)&(+LocAgeTo'="0") s rtn="AgeErr"
	i (DOB>LocAgeFrom)&(+PatAge'=0)&(+LocAgeFrom'="0") s rtn="AgeErr"
	;i (LocSexID'="")&(LocSexID'=PatSex)&(PatSex'="") s rtn="SexErr"
	;i (PatAge>LocAgeTo)&(+PatAge'=0)&(+LocAgeTo'="0") s rtn="AgeErr"
	;i (PatAge<LocAgeFrom)&(+PatAge'=0)&(+LocAgeFrom'="0") s rtn="AgeErr"
	q rtn
}

ClassMethod GetBirthDayNew(Age)
{
	q:Age="" ""
    s curda=$zd(+$h,3)
    s curyr=$p(curda,"-",1)
    s curym=$p(curda,"-",2)
    s curyd=$p(curda,"-",3)
    s birthday=(+$h)-(Age*365)
    q birthday
}

ClassMethod GetPatIDByIPBookID(IPBookID)
{
	n (IPBookID)
	q:(IPBookID="") ""
	s PapmiDr=$p(^DHCDocIPBK(IPBookID),"^",1)
	q PapmiDr
}

ClassMethod JudgeSexByIDCard(SexID, PapmiDr, idcard)
{
	q:((PapmiDr="")&(idcard="")) 0
	s CardSexID=""
	i idcard'="" d
	.s CardSexID=$e(idcard,($l(idcard)-1),($l(idcard)-1))
	.i (CardSexID#2)=1 s CardSexID=$o(^CT("SEX",0,"Desc","男","0"))
	.i (CardSexID#2)=0 s CardSexID=$o(^CT("SEX",0,"Desc","女","0"))
	e  d
	.s idcard=$p(^PAPER(PapmiDr,"ALL"),"^",9)
	.i idcard'="" d
	..s CardSexID=$e(idcard,($l(idcard)-1),($l(idcard)-1))
	..i (CardSexID#2)=1 s CardSexID=$o(^CT("SEX",0,"Desc","男","0"))
	..i (CardSexID#2)=0 s CardSexID=$o(^CT("SEX",0,"Desc","女","0"))
	q:((CardSexID'="")&(SexID'="")&(SexID'=CardSexID)) 1
	q 0
}

Query FindPACRefPriority() As websys.Query(ROWSPEC = "Desc:%String,Rowid:%String")
{
}

ClassMethod FindPACRefPriorityExecute(ByRef qHandle As %Binary) As %Status
{
 	set repid=$I(^CacheTemp)
  	set ind=1
	set Rowid="0"
	for  set Rowid=$o(^PAC("REFPRI",Rowid)) quit:(Rowid="")  do
	.set Code=$p(^PAC("REFPRI",Rowid),"^",1)
	.set Desc=$p(^PAC("REFPRI",Rowid),"^",2)
    .do OutputRowPri
 	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputRowPri
	set Data=$lb(Desc,Rowid)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

/// 找有效的住院证ID
ClassMethod GetIPBNoByID(PatientID As %String) As %String
{
	new (PatientID)
	set IPBookID=""
	quit:(PatientID="") IPBookID
	set myIPBookID=""
	for  set myIPBookID=$o(^DHCDocIPBK(0,"PatientID",PatientID,myIPBookID),-1) quit:(myIPBookID="")  do
	.quit:(+myIPBookID<1)
	.set ActiveFlag=$p($g(^DHCDocIPBK(myIPBookID)),"^",9)
	.quit:(ActiveFlag'="Y")
	.set IPBookStatusCode=""
	.set CurrentStateID=$p($g(^DHCDocIPBK(myIPBookID)),"^",8)
	.if (CurrentStateID'="") set IPBookStatusCode=$p($g(^DHCDocIPBDIC(CurrentStateID)),"^",1)
	.quit:(" Booking PreAdmOperation "'[(" "_IPBookStatusCode_" "))
	.set IPBookID=myIPBookID
	
	quit IPBookID
}

ClassMethod JudgeAdmStatus(papno As %String) As %String
{
	new (papno)
	set status=""
	quit:(papno="") status
	set papmi=$o(^PAPERi("PAPMI_PatNo",papno,""))
	quit:(papmi="") status
	set adm="0"
	for  set adm=$o(^PAPERdr(papmi,"ADM","I",adm)) quit:((adm="")||(status'=""))  do
	.quit:('$d(^PAADM(adm)))
	.set admStatusCode=##class(web.DHCDischargeHistory).GetCurrentDischargeStatus(adm)
	.if (admStatusCode="R") set status="护士撤销出院"
	.if (admStatusCode="B") set status="费用调整"

	quit status
}

/// 在类web.UDHCJFIPReg里增加以下接口
/// zfb-add 2016.7.13 更新病人的就诊费别;入参：Admid-就诊id，patType-病人费别
/// w ##class(web.UDHCJFIPReg).UpdatePatAdmReason(160, 1)
ClassMethod UpdatePatAdmReason(episodeID As %String, patType As %String) As %String
{
	new (episodeID, patType)
	
	set $ZT="ERROR^DHCSSERR"
	do ..tb()

	&SQL(UPDATE PA_ADM SET PAADM_AdmReason_DR= :patType WHERE PAADM_RowId= :episodeID)
	set rtn=SQLCODE
	;
	if (rtn'=0) tro
	quit:(rtn'=0) rtn
	
	set pbRowID="0"
	for  set pbRowID=$o(^DHCPB(0,"ADM",episodeID,pbRowID)) quit:((pbRowID="")||(rtn'=0))  do
	.set pbInfo=$g(^DHCPB(pbRowID))
	.quit:(pbInfo="")
	.set paidFlag=$p(pbInfo,"^",16)
	.quit:(paidFlag'="B")
	.&SQL(UPDATE DHC_PatientBill SET PB_PatInsType_DR= :patType WHERE PB_RowId= :pbRowID)   //把账单表里未结算的本次就诊的费别更新
	.set rtn=SQLCODE
	
	if (rtn=0) do
	.do ..tc()
	else  do
	.tro
	
	quit rtn
}

/// Creator：Lid
/// CreatDate:2017-03-17
/// Desc:获取证件类型的代码及描述
/// Return:证件类型rowid^证件类型代码^证件类型描述
/// w ##class(web.UDHCJFIPReg).GetCredTypeCode(1)
ClassMethod GetCredTypeCode(credTypeId As %String) As %String
{
	new (credTypeId)
	quit:(+credTypeId=0) "^^"
	set code=$p($g(^PAC("CARD",credTypeId)),"^",1)
	set desc=$p($g(^PAC("CARD",credTypeId)),"^",2)
	quit credTypeId_"^"_code_"^"_desc
}

/// Creator：ZhYW
/// CreatDate: 2017-08-21
/// Desciption: 取科室名称
/// Input: deptDR: 科室RowID
/// Output: 
/// Return: department: 科室名称
/// Debug: w ##class(web.UDHCJFIPReg).GetDepartmentName(1)
ClassMethod GetDepartmentName(deptDR As %String) As %String
{
	new (deptDR)
	set department=""
	quit:(+deptDR=0) department
	set deptObj=##class(User.CTLoc).%OpenId(deptDR)
	quit:('$IsObject(deptObj)) department
	set department=deptObj.CTLOCDesc
	do deptObj.%Close()
	if ($l(department,"-")=2){
		set department=$p(department,"-",2)
	}
	quit department
}

/// Creator：ZhYW
/// CreatDate: 2017-08-21
/// Desciption: 取病区名称
/// Input: wardDR: 科室RowID
/// Output: 
/// Return: department: 病区名称
/// Debug: w ##class(web.UDHCJFIPReg).GetWardName(1)
ClassMethod GetWardName(wardDR As %String) As %String
{
	new (wardDR)
	set ward=""
	quit:(+wardDR=0) ward
	set wardObj=##class(User.PACWard).%OpenId(wardDR)
	quit:('$IsObject(wardObj)) ward
	set ward=wardObj.WARDDesc
	do wardObj.%Close()
	if ($l(ward,"-")=2){
		set ward=$p(ward,"-",2)
	}
	quit ward
}

/// Creator: ZhYW
/// CreatDate: 2018-07-16
/// Description: 查询病区(有预约时，取预约到的病区，否则取住院证上的病区。没有住院证时取科室关联病区)
/// Input:  
/// Output:  
/// Debug: do ##class(%ResultSet).RunQuery("web.UDHCJFIPReg", "FindWard", "104", "")
Query FindWard(deptId As %String, docIPBookId As %String) As websys.Query(ROWSPEC = "ward:%String,wardid:%String")
{
}

ClassMethod FindWardExecute(ByRef qHandle As %Binary, deptId As %String, docIPBookId As %String) As %Status
{
	set repid=$I(^CacheTemp)
 	set ind=1
 	
	set job=$j
	do ..GetWard(docIPBookId, deptId, job)
	set rowId="0"
	for  set rowId=$o(^||TMP(job,rowId))  quit:(rowId="")  do
	.set wardInfo=$g(^||TMP(job,rowId))
	.quit:(wardInfo="")
	.set wardDesc=$p(wardInfo,"^",1)
	.do OutputWard
	kill ^||TMP(job)

	set qHandle=$lb(0,repid,0)
	quit $$$OK
OutputWard
	set Data=$lb(wardDesc,rowId)
 	set ^CacheTemp(repid,ind)=Data
 	set ind=ind+1
	quit
}

ClassMethod GetWard(docIPBookId As %String, deptId As %String, job As %String) As %String
{
	new (docIPBookId, deptId, job)
	
	kill ^||TMP(job)
	
	set wardType=""
	if (+docIPBookId'=0) {
		set appBedInfo=##class(Nur.InService.Interface).ifPatAppBed(docIPBookId)   //预约床位
 		set err=$p(appBedInfo,"^",1)
 		if (+err=0) {
	 		set deptDR=$p(appBedInfo,"^",2)
	 		if (+deptDR'=0) {
		 		set deptCode=$p($g(^CTLOC(deptDR)),"^",1)
		 		set wardDR=$o(^PAWARD(0,"WARD_Code",$$ALPHAUP^SSUTIL4(deptCode),0))
		 		set wardDesc=$s((+wardDR'=0):$p(^PAWARD(wardDR),"^",2), 1:"")
		 		if (+wardDR'=0) {
			 		set ^||TMP(job,wardDR)=wardDesc
			 	}
		 	}
			quit 0    //开启了床位预约时,只取预约的床位
			
	 	}else {
			set docIPBookInfo=##class(web.DHCDocIPBookNew).GetBookMesage(docIPBookId)
			set wardDR=$p(docIPBookInfo,"^",12)
			set wardDesc=$s((+wardDR'=0):$p($g(^PAWARD(wardDR)),"^",2), 1:"")
			if (+wardDR'=0) {
				set ^||TMP(job,wardDR)=wardDesc
			}
			set deptDR=$p(docIPBookInfo,"^",14)
			if (+deptDR'=0) {
				set deptId=deptDR
			}
			set wardType=$p(docIPBookInfo,"^",55)
		}
	}
	set defWard=""
	set rsetObj=##class(%ResultSet).%New("web.DHCDocIPBookNew:CombListFind")
	do rsetObj.Execute("InWard", deptId, defWard, wardType)
	while rsetObj.Next() {
		set wardDR=$g(rsetObj.Data("CombValue"))
		set wardDesc=$g(rsetObj.Data("CombDesc"))
		continue:($d(^||TMP(job,wardDR)))
		set ^||TMP(job,wardDR)=wardDesc
	}
	
	quit 0
}

/// Creator: ZhYW
/// CreatDate: 2018-07-16
/// Description: 有预约时，取预约到的病区，否则取住院证上的病区。没有住院证时取科室关联病区
/// Input:  
/// Output:  
/// Debug: w ##class(web.UDHCJFIPReg).GetLinkedWard(104, "")
ClassMethod GetLinkedWard(deptId As %String, docIPBookId As %String)
{
	new (deptId, docIPBookId)
	set num=0
	set (wardId, wardDesc)=""
	set rsetObj=##class(%ResultSet).%New("web.UDHCJFIPReg:FindWard")
	do rsetObj.Execute(deptId, docIPBookId)
	set columns=rsetObj.GetColumnCount()
	while (rsetObj.Next()) {
		set num=$i(num)
		if (num=1) {
			set wardDesc=rsetObj.Data("ward")
			set wardId=rsetObj.Data("wardid")
		}
	}
	if (num>1) {
		set (wardId, wardDesc)=""
	}
	
	quit num_"^"_wardDesc_"^"_wardId
}

}
